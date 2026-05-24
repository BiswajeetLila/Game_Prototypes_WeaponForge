## Combat — turn-based tick loop. Mirrors prototype BASE-A1 0.1.7+ `battleStep`.
##
## Single Timer fires every TICK_SEC (1.1s). Each tick:
##   1. Every alive hero attacks one random alive enemy.
##   2. Every alive non-frozen enemy attacks the hero (ultra-MVP: only Bran).
##   3. Status effects tick down (debuff_dur, frozen one-turn clears).
##   4. Win/loss check.
##
## Recipe bonuses (from Recipes.get_recipe_bonuses) drive: Steamburst splash,
## Inferno stack burn (consecutive-same-target), Skewer multi-hit, Permafrost
## freeze, Razor Wind crit_bonus, Hellfire crit splash, Frostbite debuff,
## Quickdraw ult_boost.
##
## Persistent ult gauge (addendum 0.1.4): gauge survives across waves. Only
## ult_used + Inferno burn_stack reset per fight.
##
## Time-cap (addendum 0.1.2): 30s after start_wave, gauge is forced to 100
## so the player always gets to fire ult before the fight drags.
##
## Public API:
##   start_wave(wave, auto_tick := true)
##                              Spawn 2-3 enemies (HP scales 15 + wave*8),
##                              assign weak (always) + resist (70% chance) tags
##                              per addendum 0.1.5, reset per-fight state,
##                              start the timers.  Pass auto_tick=false to
##                              skip the Timer (used by tests to drive step()
##                              manually).
##   step()                     One tick of combat logic. Public so tests can
##                              call it directly.
##   fire_ult(hero_id) -> bool  Try to fire the hero's ultimate. Requires gauge
##                              >= 100 and not yet used this fight. Warrior
##                              Whirlwind = AoE all alive enemies for
##                              atk * ult_atk_multiplier.
##   stop()                     Pause timers (used by first-discovery overlay
##                              to freeze battle until the player dismisses).
##   resume()                   Restart timers without re-spawning enemies.
##   is_running() -> bool
##
## Untyped throughout — autoload.
extends Node

const TICK_SEC: float = 1.1
const TIME_CAP_SEC: float = 30.0

## Per-tag elemental multipliers (per BASE-A1 0.1.2).
const WEAK_MULT: float = 1.8
const RESIST_MULT: float = 0.5

const CRIT_MULT: float = 1.6
const ULT_GAUGE_MAX: float = 100.0
const ULT_BASE_FILL: float = 6.0
const ULT_FILL_PER_DMG: float = 0.2
const ULT_FILL_PER_RATE: float = 0.25   ## == ult_rate / 4

const TAG_POOL: Array = [&"fire", &"ice", &"pierce"]
const RESIST_CHANCE: float = 0.7

signal tick_completed
signal hero_hit_enemy(hero_id: StringName, enemy_idx: int, dmg: int, source: StringName, is_crit: bool)
signal enemy_hit_hero(enemy_idx: int, hero_id: StringName, dmg: int)
signal ult_fired(hero_id: StringName, total_dmg: int)

var _tick_timer: Timer
var _time_cap_timer: Timer
var _running: bool = false
var _current_wave: int = 0

func _ready() -> void:
	_tick_timer = Timer.new()
	_tick_timer.one_shot = false
	_tick_timer.wait_time = TICK_SEC
	_tick_timer.timeout.connect(step)
	add_child(_tick_timer)

	_time_cap_timer = Timer.new()
	_time_cap_timer.one_shot = true
	_time_cap_timer.wait_time = TIME_CAP_SEC
	_time_cap_timer.timeout.connect(_on_time_cap)
	add_child(_time_cap_timer)

## ---------- Public API ----------

func start_wave(wave: int, auto_tick: bool = true) -> void:
	_current_wave = wave
	GameState.set_wave(wave)
	_spawn_enemies(wave)
	if GameState.hero != null:
		GameState.hero.reset_for_fight()
	_running = true
	if auto_tick:
		_tick_timer.start()
		_time_cap_timer.start()

func stop() -> void:
	_running = false
	_tick_timer.stop()
	_time_cap_timer.stop()

func resume() -> void:
	if GameState.enemies.is_empty():
		return
	_running = true
	_tick_timer.start()
	## Time-cap is one-shot — only restart if it hasn't already fired.
	if _time_cap_timer.is_stopped() and not _time_cap_already_fired():
		_time_cap_timer.start()

func is_running() -> bool:
	return _running

func step() -> void:
	if not _running:
		return

	## 1. Heroes attack.
	var hero = GameState.hero
	if hero != null and not hero.is_dead and hero.weapon != null:
		_hero_attack(hero)

	## 2. Enemies attack.
	for i in range(GameState.enemies.size()):
		var enemy = GameState.enemies[i]
		if enemy.hp <= 0:
			continue
		if enemy.get(&"frozen", false):
			enemy.frozen = false   ## one-turn freeze, clears after the turn
			GameState.emit_signal(&"enemy_status_changed", i)
			continue
		_enemy_attack(i)
		if hero != null and hero.is_dead:
			break

	## 3. Tick down debuffs (one-turn frostbite per addendum 0.1.7 wording).
	for i in range(GameState.enemies.size()):
		var enemy = GameState.enemies[i]
		if int(enemy.get(&"debuff_dur", 0)) > 0:
			enemy.debuff_dur = int(enemy.debuff_dur) - 1
			if enemy.debuff_dur <= 0:
				enemy.debuffed = false
				enemy.debuff_mult = 1.0
				GameState.emit_signal(&"enemy_status_changed", i)

	## 4. Win/loss.
	if _all_enemies_dead():
		_on_wave_cleared()
		return
	if hero != null and hero.is_dead:
		_on_wipe()
		return

	emit_signal(&"tick_completed")

func fire_ult(hero_id: StringName) -> bool:
	## Ultra-MVP: only Bran. hero_id retained for forward compat.
	var hero = GameState.hero
	if hero == null or hero.is_dead or hero.ult_used:
		return false
	if hero.ult_gauge < ULT_GAUGE_MAX:
		return false
	if hero.weapon == null:
		return false

	var total_atk: int = hero.data.atk_base + hero.weapon.get_atk()
	var ult_atk: int = int(floor(float(total_atk) * float(hero.data.ult_atk_multiplier)))
	var alive: Array = _alive_enemy_indices()
	if alive.is_empty():
		return false

	## Warrior Whirlwind = AoE all alive. Mage/Rogue variants come in Phase 2.
	var total_dmg: int = 0
	for idx in alive:
		var enemy = GameState.enemies[idx]
		var dmg: int = ult_atk    ## Ults bypass element multipliers in the prototype.
		enemy.hp = maxi(0, enemy.hp - dmg)
		total_dmg += dmg
		GameState.emit_signal(&"enemy_hp_changed", idx)
		emit_signal(&"hero_hit_enemy", hero_id, idx, dmg, &"ult", false)

	hero.ult_used = true
	hero.ult_gauge = 0.0
	GameState.emit_signal(&"hero_ult_changed", hero_id)
	emit_signal(&"ult_fired", hero_id, total_dmg)
	GameState.append_combat_log("[color=aa66ff]🌀 %s — %d total[/color]" % [hero.data.ult_name, total_dmg])

	if _all_enemies_dead():
		_on_wave_cleared()
	return true

## ---------- Tick internals ----------

func _hero_attack(hero) -> void:
	var alive: Array = _alive_enemy_indices()
	if alive.is_empty():
		return
	var target_idx: int = alive[randi() % alive.size()]
	var enemy = GameState.enemies[target_idx]

	## Total atk = hero baseAtk + sum of part contributions (matches prototype's
	## weaponStats(hero) formula). weapon.get_atk() alone is parts-only.
	var stats_atk: int = hero.data.atk_base + hero.weapon.get_atk()
	var stats_crit: int = hero.weapon.get_crit()
	var stats_ultrate: int = hero.weapon.get_ult_rate()
	var weapon_tags: Array = hero.weapon.get_all_tags()
	var bonuses: Dictionary = Recipes.get_recipe_bonuses(hero)

	## Crit (Razor Wind adds flat crit_bonus to the % roll).
	var effective_crit: int = stats_crit + int(bonuses.get(&"crit_bonus", 0))
	var dmg: float = float(stats_atk)
	var is_crit: bool = randf() * 100.0 < float(effective_crit)
	if is_crit:
		dmg = floor(dmg * CRIT_MULT)

	## Per-tag elemental multipliers (multiplicative, stacking per matching tag).
	for tag in weapon_tags:
		if tag == enemy.get(&"weak", &""):
			dmg *= WEAK_MULT
		if tag == enemy.get(&"resist", &""):
			dmg *= RESIST_MULT

	## Inferno stack burn (consecutive same-target).
	var stack_burn: float = float(bonuses.get(&"stack_burn", 0.0))
	var stack_cap: int = int(bonuses.get(&"stack_cap", 0))
	if stack_burn > 0.0:
		if hero.last_target_name == enemy.name:
			hero.burn_stack = mini(stack_cap, hero.burn_stack + 1)
		else:
			hero.burn_stack = 0
		dmg = floor(dmg * (1.0 + stack_burn * float(hero.burn_stack)))
	hero.last_target_name = enemy.name

	var final_dmg: int = int(floor(dmg))
	enemy.hp = maxi(0, enemy.hp - final_dmg)
	GameState.emit_signal(&"enemy_hp_changed", target_idx)
	emit_signal(&"hero_hit_enemy", &"bran", target_idx, final_dmg, &"basic", is_crit)
	_log_hero_hit(enemy, final_dmg, is_crit)

	## Ult gauge fill (Quickdraw multiplies via ult_boost).
	var gauge_gain: float = ULT_BASE_FILL + floor(float(final_dmg) * ULT_FILL_PER_DMG) + float(stats_ultrate) * ULT_FILL_PER_RATE
	var ult_boost: float = float(bonuses.get(&"ult_boost", 0.0))
	if ult_boost > 0.0:
		gauge_gain *= (1.0 + ult_boost)
	hero.ult_gauge = min(ULT_GAUGE_MAX, hero.ult_gauge + gauge_gain)
	GameState.emit_signal(&"hero_ult_changed", &"bran")

	## Steamburst splash to OTHER alive enemies (after primary hit).
	var splash: float = float(bonuses.get(&"splash", 0.0))
	if splash > 0.0:
		var splash_dmg: int = int(floor(float(final_dmg) * splash))
		if splash_dmg > 0:
			for other_idx in _alive_enemy_indices():
				if other_idx == target_idx:
					continue
				var other = GameState.enemies[other_idx]
				other.hp = maxi(0, other.hp - splash_dmg)
				GameState.emit_signal(&"enemy_hp_changed", other_idx)
				emit_signal(&"hero_hit_enemy", &"bran", other_idx, splash_dmg, &"steamburst", false)

	## Skewer multi-hit — 70% chance to hit a random second enemy for multi_hit%.
	var multi_hit: float = float(bonuses.get(&"multi_hit", 0.0))
	if multi_hit > 0.0 and randf() < 0.7:
		var others: Array = _alive_enemy_indices()
		others.erase(target_idx)
		if not others.is_empty():
			var second_idx: int = others[randi() % others.size()]
			var sec_dmg: int = int(floor(float(final_dmg) * multi_hit))
			GameState.enemies[second_idx].hp = maxi(0, GameState.enemies[second_idx].hp - sec_dmg)
			GameState.emit_signal(&"enemy_hp_changed", second_idx)
			emit_signal(&"hero_hit_enemy", &"bran", second_idx, sec_dmg, &"skewer", false)

	## Permafrost freeze chance on the primary target (only if it survived).
	var freeze_chance: float = float(bonuses.get(&"freeze_chance", 0.0))
	if freeze_chance > 0.0 and enemy.hp > 0 and randf() < freeze_chance:
		enemy.frozen = true
		GameState.emit_signal(&"enemy_status_changed", target_idx)

	## Hellfire — crit splashes a % of dmg to one random other enemy.
	var crit_splash: float = float(bonuses.get(&"crit_splash", 0.0))
	if is_crit and crit_splash > 0.0:
		var others2: Array = _alive_enemy_indices()
		others2.erase(target_idx)
		if not others2.is_empty():
			var adj_idx: int = others2[randi() % others2.size()]
			var sp_dmg: int = int(floor(float(final_dmg) * crit_splash))
			GameState.enemies[adj_idx].hp = maxi(0, GameState.enemies[adj_idx].hp - sp_dmg)
			GameState.emit_signal(&"enemy_hp_changed", adj_idx)
			emit_signal(&"hero_hit_enemy", &"bran", adj_idx, sp_dmg, &"hellfire", false)

	## Frostbite debuff on the primary target (target's NEXT attack is weaker).
	var debuff: float = float(bonuses.get(&"debuff", 0.0))
	if debuff > 0.0 and enemy.hp > 0:
		enemy.debuffed = true
		enemy.debuff_mult = max(0.0, 1.0 - debuff)
		enemy.debuff_dur = 1
		GameState.emit_signal(&"enemy_status_changed", target_idx)

func _enemy_attack(enemy_idx: int) -> void:
	var enemy = GameState.enemies[enemy_idx]
	var hero = GameState.hero
	if hero == null or hero.is_dead:
		return
	var base_dmg: int = 4 + int(floor(float(_current_wave) * 1.4))
	if enemy.get(&"debuffed", false):
		base_dmg = int(floor(float(base_dmg) * float(enemy.get(&"debuff_mult", 1.0))))
	hero.hp = maxi(0, hero.hp - base_dmg)
	if hero.hp <= 0:
		hero.is_dead = true
	GameState.emit_signal(&"hero_hp_changed", &"bran")
	emit_signal(&"enemy_hit_hero", enemy_idx, &"bran", base_dmg)
	GameState.append_combat_log("[color=ff8888]%s → Bran for %d[/color]" % [enemy.name, base_dmg])

## ---------- Spawning ----------

func _spawn_enemies(wave: int) -> void:
	GameState.enemies.clear()
	if GameState.enemy_ids.is_empty():
		push_warning("Combat._spawn_enemies: no enemy catalog")
		GameState.emit_signal(&"enemies_spawned")
		return
	var count: int = 2 + (randi() % 2)   ## 2 or 3 enemies per addendum
	for i in count:
		var enemy_id = GameState.enemy_ids[randi() % GameState.enemy_ids.size()]
		var def = GameState.get_enemy_def(enemy_id)
		if def == null:
			continue
		var hp: int = def.hp_base + def.hp_per_wave * wave
		var weak: StringName = TAG_POOL[randi() % TAG_POOL.size()]
		var resist: StringName = &""
		if randf() < RESIST_CHANCE:
			var resist_pool: Array = TAG_POOL.duplicate()
			resist_pool.erase(weak)
			if not resist_pool.is_empty():
				resist = resist_pool[randi() % resist_pool.size()]
		GameState.enemies.append({
			&"id": enemy_id,
			"name": "%s_%d" % [def.name, i],   ## unique per spawn for Inferno target tracking
			"hp": hp,
			"max_hp": hp,
			"weak": weak,
			"resist": resist,
			"sprite": def.sprite,
			"frozen": false,
			"debuffed": false,
			"debuff_dur": 0,
			"debuff_mult": 1.0,
		})
	GameState.emit_signal(&"enemies_spawned")

## ---------- Helpers ----------

func _alive_enemy_indices() -> Array:
	var out: Array = []
	for i in range(GameState.enemies.size()):
		if GameState.enemies[i].hp > 0:
			out.append(i)
	return out

func _all_enemies_dead() -> bool:
	for enemy in GameState.enemies:
		if enemy.hp > 0:
			return false
	return true

func _time_cap_already_fired() -> bool:
	return GameState.hero != null and GameState.hero.ult_gauge >= ULT_GAUGE_MAX

## ---------- End-of-state hooks ----------

func _on_wave_cleared() -> void:
	stop()
	var gold_award: int = 5 + _current_wave * 2
	GameState.add_gold(gold_award)
	GameState.emit_signal(&"wave_cleared", _current_wave)
	if _current_wave >= GameState.TOTAL_WAVES:
		GameState.emit_signal(&"stage_cleared")

func _on_wipe() -> void:
	stop()
	GameState.emit_signal(&"hero_died", &"bran")

func _on_time_cap() -> void:
	if GameState.hero != null and not GameState.hero.is_dead:
		GameState.hero.ult_gauge = ULT_GAUGE_MAX
		GameState.emit_signal(&"hero_ult_changed", &"bran")

## Tag-aware narration helper for the combat log.
func _log_hero_hit(enemy, dmg: int, is_crit: bool) -> void:
	var prefix: String = ""
	if is_crit:
		prefix += "⚡"
	GameState.append_combat_log("[color=ffd070]%sBran → %s for %d[/color]" % [prefix, enemy.name, dmg])
