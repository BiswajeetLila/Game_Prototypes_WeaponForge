## Combat — turn-based tick loop. Mirrors prototype BASE-A1 0.1.7+ `battleStep`.
##
## Single Timer fires every TICK_SEC (1.1s). Each tick:
##   1. Every alive hero in the squad attacks one random alive enemy.
##   2. Every alive non-frozen enemy attacks one random alive squad member.
##   3. Status effects tick down (debuff_dur, frozen one-turn clears).
##   4. Win/loss check. Stage ends when all squad dead (squad_wiped) or all
##      waves cleared (stage_cleared). Individual hero deaths fire hero_died
##      but the squad fights on as long as any_alive().
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

## Stage D — boss roster keyed by wave. _spawn_enemies looks up the id and
## spawns exactly one boss enemy when the current wave matches.
const BOSS_BY_WAVE: Dictionary = {
	5: &"boss_slime_king",
	10: &"boss_iron_golem",
	15: &"boss_arcane_lich",
}

## ---------- Stage rotation (S2) ----------
## A run is one stage (GameState.RUN_FINAL_WAVE). The boss rotates per stage and
## enemies scale up; STAGE 1 MULTIPLIERS ARE EXACTLY 1.0 so the legacy balance
## numbers (and the 57-test combat contract) are untouched.
## Numbers Policy starting values: HP +40%/stage, ATK +25%/stage. Test plan:
## stage 2 should be losable with a starter weapon and winnable after 1-2 pulls;
## if it's a wall, drop ATK growth to +15% first.
const STAGE_BOSS_ROTATION: Array = [&"boss_slime_king", &"boss_iron_golem", &"boss_arcane_lich"]

func stage_hp_mult(stage: int) -> float:
	return 1.0 + 0.4 * float(maxi(stage, 1) - 1)

func stage_atk_mult(stage: int) -> float:
	return 1.0 + 0.25 * float(maxi(stage, 1) - 1)

func boss_for_stage(stage: int) -> StringName:
	return STAGE_BOSS_ROTATION[(maxi(stage, 1) - 1) % STAGE_BOSS_ROTATION.size()]

signal tick_completed
signal hero_hit_enemy(hero_id: StringName, enemy_idx: int, dmg: int, source: StringName, is_crit: bool)
signal enemy_hit_hero(enemy_idx: int, hero_id: StringName, dmg: int)
signal ult_fired(hero_id: StringName, total_dmg: int)
## Stage D — pre-wave banner. Main listens and displays before Combat.start_wave.
signal boss_telegraph(text: String)

var _tick_timer: Timer
var _time_cap_timer: Timer
var _running: bool = false
var _current_wave: int = 0
var _tick_counter: int = 0

## Crash diagnostics breadcrumb path. Combat.step() writes the current wave +
## tick count here at the END of every tick. If Godot hard-hangs, this file
## tells the next session exactly where we were.
const BREADCRUMB_PATH: String = "user://last_tick.txt"

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
	_tick_counter = 0
	GameState.set_wave(wave)
	_spawn_enemies(wave)
	ForgeDraft.reset_wave_baseline()   ## kill meter: new wave's dead-count starts at 0
	_write_breadcrumb_phase(&"start")
	## Reset per-fight state for every squad member (alive AND dead — dead heroes
	## stay dead, this only clears ult_used / burn_stack tracking).
	for h in GameState.all_heroes():
		h.reset_for_fight()
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

	## Sub-phase breadcrumbs let us pinpoint which segment of a tick hangs.
	## Each write overwrites user://last_tick.txt. On crash, last value names
	## the deepest reached point.
	_tick_counter += 1
	_write_breadcrumb_phase(&"tick_enter")

	## 1. Heroes attack. Each alive squad member attacks one random alive enemy.
	for h in GameState.active_heroes():
		if h.has_weapon():
			_write_breadcrumb_phase(StringName("tick_hero_attack:%s" % String(h.data.id)))
			_hero_attack(h)
	_write_breadcrumb_phase(&"after_hero_loop")

	## 2. Enemies attack. Each non-frozen enemy targets one random alive hero.
	for i in range(GameState.enemies.size()):
		var enemy = GameState.enemies[i]
		if enemy.hp <= 0:
			continue
		if enemy.get(&"frozen", false):
			enemy.frozen = false   ## one-turn freeze, clears after the turn
			GameState.emit_signal(&"enemy_status_changed", i)
			continue
		var target = _pick_target_hero()
		if target == null:
			break   ## squad wiped mid-tick; win/loss check below handles it
		_write_breadcrumb_phase(StringName("tick_enemy_attack:%d->%s" % [i, String(target.data.id)]))
		_enemy_attack(i, target)
	_write_breadcrumb_phase(&"after_enemy_loop")

	## 2.5 Stage D — boss tick hooks. Dispatched on enemy.id; non-boss enemies
	## skip the match block entirely. Hooks may mutate enemy.atk (lich phase 1),
	## damage all alive heroes (golem AoE / lich phase 2 AoE), or restore boss
	## hp (slime king heal).
	for i in range(GameState.enemies.size()):
		var boss = GameState.enemies[i]
		if not bool(boss.get(&"is_boss", false)):
			continue
		if boss.hp <= 0:
			continue
		match boss.id:
			&"boss_slime_king":
				_boss_tick_slime_king(i, boss)
			&"boss_iron_golem":
				_boss_tick_iron_golem(i, boss)
			&"boss_arcane_lich":
				_boss_tick_arcane_lich(i, boss)
	_write_breadcrumb_phase(&"after_boss_hooks")

	## 3. Tick down debuffs (one-turn frostbite per addendum 0.1.7 wording).
	for i in range(GameState.enemies.size()):
		var enemy = GameState.enemies[i]
		if int(enemy.get(&"debuff_dur", 0)) > 0:
			enemy.debuff_dur = int(enemy.debuff_dur) - 1
			if enemy.debuff_dur <= 0:
				enemy.debuffed = false
				enemy.debuff_mult = 1.0
				GameState.emit_signal(&"enemy_status_changed", i)
	_write_breadcrumb_phase(&"after_status")

	## 3.5 Kill meter: report current dead-count; ForgeDraft diffs per-wave.
	ForgeDraft.sync_dead_count(_dead_enemy_count())

	## 4. Win/loss.
	if _all_enemies_dead():
		_on_wave_cleared()
		return
	if not GameState.any_alive():
		_on_wipe()
		return

	_write_breadcrumb()
	emit_signal(&"tick_completed")

## Writes a single-line breadcrumb with the current wave + tick to user://.
## Called at the end of every step() that survives the win/loss check.
func _write_breadcrumb() -> void:
	_write_breadcrumb_phase(&"end")

## Phase-tagged variant for diagnostics. start_wave writes phase=start;
## end-of-tick writes phase=end. If the breadcrumb is stuck at phase=start
## (or phase=end on tick N) when Godot is force-killed, we know exactly
## which tick the hang happened in.
func _write_breadcrumb_phase(phase: StringName) -> void:
	var f := FileAccess.open(BREADCRUMB_PATH, FileAccess.WRITE)
	if f == null:
		return
	f.store_line("wave=%d tick=%d phase=%s" % [_current_wave, _tick_counter, String(phase)])

func fire_ult(hero_id: StringName) -> bool:
	var hero = GameState.get_hero(hero_id)
	if hero == null or hero.is_dead or hero.ult_used:
		return false
	if hero.ult_gauge < ULT_GAUGE_MAX:
		return false
	if not hero.has_weapon():
		return false
	var alive: Array = _alive_enemy_indices()
	if alive.is_empty():
		return false

	## Dispatch per HeroData.ult_key. Empty / unknown -> Whirlwind fallback so
	## new heroes default to a sane AoE while their custom ult is being built.
	var total_dmg: int = 0
	match hero.data.ult_key:
		&"meteor":
			total_dmg = _ult_meteor(hero, alive)
		&"shadowstep":
			total_dmg = _ult_shadowstep(hero, alive)
		_:
			total_dmg = _ult_whirlwind(hero, alive)

	hero.ult_used = true
	hero.ult_gauge = 0.0
	GameState.emit_signal(&"hero_ult_changed", hero_id)
	emit_signal(&"ult_fired", hero_id, total_dmg)
	ForgeDraft.sync_dead_count(_dead_enemy_count())   ## ult kills feed the meter too
	GameState.append_combat_log("[color=aa66ff]🌀 %s — %d total[/color]" % [hero.data.ult_name, total_dmg])

	if _all_enemies_dead():
		_on_wave_cleared()
	return true

## ---------- Ult implementations ----------

func _ult_whirlwind(hero, alive: Array) -> int:
	## Warrior Whirlwind = AoE all alive enemies × ult_atk_multiplier.
	var total_atk: int = hero.data.atk_base + hero.eff_atk()
	var ult_atk: int = int(floor(float(total_atk) * float(hero.data.ult_atk_multiplier)))
	var total: int = 0
	for idx in alive:
		var enemy = GameState.enemies[idx]
		enemy.hp = maxi(0, enemy.hp - ult_atk)
		total += ult_atk
		GameState.emit_signal(&"enemy_hp_changed", idx)
		emit_signal(&"hero_hit_enemy", hero.data.id, idx, ult_atk, &"ult", false)
	return total

func _ult_meteor(hero, alive: Array) -> int:
	## Mage Meteor = AoE all alive × ult_atk_multiplier + applies one burn stack
	## to the highest-HP enemy (capped by stack_cap; effectively no-op unless
	## the caster has Inferno equipped for the stack_burn payoff). The narrow
	## scope avoids refactoring burn to per-(hero, enemy).
	var total_atk: int = hero.data.atk_base + hero.eff_atk()
	var ult_atk: int = int(floor(float(total_atk) * float(hero.data.ult_atk_multiplier)))
	var primary_idx: int = _highest_hp_idx(alive)
	var primary = GameState.enemies[primary_idx]
	var total: int = 0
	for idx in alive:
		var enemy = GameState.enemies[idx]
		enemy.hp = maxi(0, enemy.hp - ult_atk)
		total += ult_atk
		GameState.emit_signal(&"enemy_hp_changed", idx)
		emit_signal(&"hero_hit_enemy", hero.data.id, idx, ult_atk, &"ult_meteor", false)
	var bonuses: Dictionary = Recipes.get_recipe_bonuses(hero)
	var stack_cap: int = int(bonuses.get(&"stack_cap", 0))
	if stack_cap > 0:
		hero.burn_stack = mini(stack_cap, hero.burn_stack + 1)
	hero.last_target_name = primary.name
	return total

func _ult_shadowstep(hero, alive: Array) -> int:
	## Rogue Shadowstep = single-target highest-HP, damage = atk × ult_atk_multiplier.
	## is_crit=true is emitted on the hit signal for VFX / future recipe hooks,
	## but does NOT additionally multiply by CRIT_MULT — locking the ult damage
	## ceiling at the multiplier alone (3× by default).
	var total_atk: int = hero.data.atk_base + hero.eff_atk()
	var dmg: int = int(floor(float(total_atk) * float(hero.data.ult_atk_multiplier)))
	var target_idx: int = _highest_hp_idx(alive)
	var enemy = GameState.enemies[target_idx]
	enemy.hp = maxi(0, enemy.hp - dmg)
	GameState.emit_signal(&"enemy_hp_changed", target_idx)
	emit_signal(&"hero_hit_enemy", hero.data.id, target_idx, dmg, &"ult_shadowstep", true)
	return dmg

func _highest_hp_idx(alive: Array) -> int:
	var best_idx: int = alive[0]
	var best_hp: int = GameState.enemies[alive[0]].hp
	for idx in alive:
		var hp: int = GameState.enemies[idx].hp
		if hp > best_hp:
			best_hp = hp
			best_idx = idx
	return best_idx

## ---------- Tick internals ----------

func _hero_attack(hero) -> void:
	var alive: Array = _alive_enemy_indices()
	if alive.is_empty():
		return
	var target_idx: int = alive[randi() % alive.size()]
	var enemy = GameState.enemies[target_idx]

	## Total atk = hero baseAtk + sum of part contributions (matches prototype's
	## weaponStats(hero) formula). weapon.get_atk() alone is parts-only.
	var stats_atk: int = hero.data.atk_base + hero.eff_atk()
	var stats_crit: int = hero.eff_crit()
	var stats_ultrate: int = hero.eff_ult_rate()
	var weapon_tags: Array = hero.eff_tags()
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
	## Tag stack-burn hits with the &"inferno" source so the juice layer
	## fires the fire_puff burst + bigger popup. Falls back to &"basic" for
	## normal hits.
	var hit_source: StringName = &"inferno" if hero.burn_stack > 0 else &"basic"
	emit_signal(&"hero_hit_enemy", hero.data.id, target_idx, final_dmg, hit_source, is_crit)
	_log_hero_hit(hero, enemy, final_dmg, is_crit)

	## Ult gauge fill (Quickdraw multiplies via ult_boost).
	var gauge_gain: float = ULT_BASE_FILL + floor(float(final_dmg) * ULT_FILL_PER_DMG) + float(stats_ultrate) * ULT_FILL_PER_RATE
	var ult_boost: float = float(bonuses.get(&"ult_boost", 0.0))
	if ult_boost > 0.0:
		gauge_gain *= (1.0 + ult_boost)
	hero.ult_gauge = min(ULT_GAUGE_MAX, hero.ult_gauge + gauge_gain)
	GameState.emit_signal(&"hero_ult_changed", hero.data.id)

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
				emit_signal(&"hero_hit_enemy", hero.data.id, other_idx, splash_dmg, &"steamburst", false)

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
			emit_signal(&"hero_hit_enemy", hero.data.id, second_idx, sec_dmg, &"skewer", false)

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
			emit_signal(&"hero_hit_enemy", hero.data.id, adj_idx, sp_dmg, &"hellfire", false)

	## Frostbite debuff on the primary target (target's NEXT attack is weaker).
	var debuff: float = float(bonuses.get(&"debuff", 0.0))
	if debuff > 0.0 and enemy.hp > 0:
		enemy.debuffed = true
		enemy.debuff_mult = max(0.0, 1.0 - debuff)
		enemy.debuff_dur = 1
		GameState.emit_signal(&"enemy_status_changed", target_idx)

func _enemy_attack(enemy_idx: int, hero) -> void:
	var enemy = GameState.enemies[enemy_idx]
	if hero == null or hero.is_dead:
		return
	## Stage D — enemy ATK precedence: enemy.atk (set at spawn from base_atk()
	## or, for bosses, from def.atk_override + per-phase mutation). Falls back
	## to base_atk(_current_wave) when force_enemies tests didn't set the field.
	var base_dmg: int = int(enemy.get(&"atk", 0))
	if base_dmg <= 0:
		base_dmg = base_atk(_current_wave)
	if enemy.get(&"debuffed", false):
		base_dmg = int(floor(float(base_dmg) * float(enemy.get(&"debuff_mult", 1.0))))
	hero.hp = maxi(0, hero.hp - base_dmg)
	var killed_this_hit: bool = false
	if hero.hp <= 0 and not hero.is_dead:
		hero.is_dead = true
		killed_this_hit = true
	GameState.emit_signal(&"hero_hp_changed", hero.data.id)
	emit_signal(&"enemy_hit_hero", enemy_idx, hero.data.id, base_dmg)
	GameState.append_combat_log("[color=ff8888]%s → %s for %d[/color]" % [enemy.name, hero.data.name, base_dmg])
	if killed_this_hit:
		## Per-hero death notice. Squad-level wipe (squad_wiped) is emitted from
		## _on_wipe() when no heroes remain alive.
		GameState.emit_signal(&"hero_died", hero.data.id)

## ---------- Spawning ----------

func _spawn_enemies(wave: int) -> void:
	GameState.enemies.clear()
	if GameState.enemy_ids.is_empty():
		push_warning("Combat._spawn_enemies: no enemy catalog")
		GameState.emit_signal(&"enemies_spawned")
		return
	## Stage D — boss waves spawn exactly 1 boss via id lookup; non-boss
	## enemies are filtered from the random pool so they only roll on normal
	## waves.
	if BOSS_BY_WAVE.has(wave):
		_spawn_boss(wave)
		GameState.emit_signal(&"enemies_spawned")
		return
	var atk_for_wave: int = int(floor(float(base_atk(wave)) * stage_atk_mult(GameState.run_stage)))
	var hp_mult: float = _wave_hp_mult(wave) * stage_hp_mult(GameState.run_stage)
	var non_boss_pool: Array = []
	for eid in GameState.enemy_ids:
		var d = GameState.get_enemy_def(eid)
		if d != null and not d.is_boss:
			non_boss_pool.append(eid)
	if non_boss_pool.is_empty():
		push_warning("Combat._spawn_enemies: no non-boss enemies in catalog")
		GameState.emit_signal(&"enemies_spawned")
		return
	var count: int = 2 + (randi() % 2)   ## 2 or 3 enemies per addendum
	for i in count:
		var enemy_id = non_boss_pool[randi() % non_boss_pool.size()]
		var def = GameState.get_enemy_def(enemy_id)
		if def == null:
			continue
		var hp: int = int(floor(float(def.hp_base + def.hp_per_wave * wave) * hp_mult))
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
			"is_boss": false,
			"atk": atk_for_wave,
			"phase_1_applied": false,
			"phase_2_applied": false,
		})
	GameState.emit_signal(&"enemies_spawned")

## Stage D — boss spawn. Single enemy, hand-tuned stats, telegraph banner.
## The run-final wave's boss rotates per stage; legacy waves 10/15 keep the map.
func _spawn_boss(wave: int) -> void:
	var boss_id: StringName = BOSS_BY_WAVE[wave]
	if wave == GameState.RUN_FINAL_WAVE:
		boss_id = boss_for_stage(GameState.run_stage)
	var def = GameState.get_enemy_def(boss_id)
	if def == null:
		push_error("Combat._spawn_boss: missing tres for %s" % boss_id)
		return
	var boss_hp: int = int(floor(float(def.hp_base) * stage_hp_mult(GameState.run_stage)))
	GameState.enemies.append({
		&"id": boss_id,
		"name": def.name,
		"hp": boss_hp,
		"max_hp": boss_hp,
		"weak": def.weak_tag,
		"resist": def.resist_tag,
		"sprite": def.sprite,
		"frozen": false,
		"debuffed": false,
		"debuff_dur": 0,
		"debuff_mult": 1.0,
		"is_boss": true,
		"atk": int(floor(float(def.atk_override) * stage_atk_mult(GameState.run_stage))),
		"phase_1_applied": false,
		"phase_2_applied": false,
	})
	var banner: String = "👑 %s" % def.name.to_upper()
	var weak_str: String = String(def.weak_tag)
	var resist_str: String = String(def.resist_tag)
	var parts: Array = []
	if weak_str != "":
		parts.append("weak: %s" % weak_str)
	if resist_str != "":
		parts.append("resist: %s" % resist_str)
	if not parts.is_empty():
		banner += "  •  " + "  /  ".join(parts)
	emit_signal(&"boss_telegraph", banner)

## Stage D — tier-scaled enemy ATK curve. Replaces the old single-line
## `4 + floor(wave*1.4)` formula with bands matching the 15-wave plan.
func base_atk(wave: int) -> int:
	if wave <= 3:
		return 4 + int(floor(float(wave) * 1.2))
	if wave <= 6:
		return 5 + int(floor(float(wave) * 1.3))
	if wave <= 9:
		return 6 + int(floor(float(wave) * 1.3))
	if wave <= 12:
		return 7 + int(floor(float(wave) * 1.4))
	return 8 + int(floor(float(wave) * 1.5))

## Stage D — softened tutorial / peaked finale HP curve. Multiplier applied to
## non-boss enemy hp at spawn. Bosses have fixed hp_base (no curve).
func _wave_hp_mult(wave: int) -> float:
	if wave <= 3:
		return 0.85
	if wave <= 6:
		return 1.00
	if wave <= 9:
		return 1.10
	if wave <= 12:
		return 1.20
	return 1.30

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

func _pick_target_hero():
	var pool: Array = GameState.active_heroes()
	if pool.is_empty():
		return null
	return pool[randi() % pool.size()]

## True only if every alive squad member is already at gauge max — used by
## resume() to skip re-arming the time-cap timer when it would be a no-op.
func _time_cap_already_fired() -> bool:
	var alive: Array = GameState.active_heroes()
	if alive.is_empty():
		return true
	for h in alive:
		if h.ult_gauge < ULT_GAUGE_MAX:
			return false
	return true

## ---------- Stage D — boss tick hooks ----------

## Slime King — heals +8 hp every 3rd tick while > 50% max HP. Falls silent
## once chipped below the threshold so the player gets a "the king is dying"
## momentum window.
const SLIME_KING_HEAL: int = 8
const SLIME_KING_TICK_INTERVAL: int = 3

func _boss_tick_slime_king(idx: int, boss) -> void:
	if _tick_counter % SLIME_KING_TICK_INTERVAL != 0:
		return
	if boss.hp <= int(boss.max_hp) / 2:
		return
	boss.hp = mini(int(boss.max_hp), boss.hp + SLIME_KING_HEAL)
	GameState.emit_signal(&"enemy_hp_changed", idx)

## Iron Golem — every 4th tick, AoE pulse hits all alive heroes for 70% of
## the golem's current atk. Lands in ADDITION to the regular single-target
## attack on the same tick (raises the stakes when squad is undermanned).
const GOLEM_TICK_INTERVAL: int = 4
const GOLEM_AOE_RATIO: float = 0.7

func _boss_tick_iron_golem(idx: int, boss) -> void:
	if _tick_counter % GOLEM_TICK_INTERVAL != 0:
		return
	var aoe_dmg: int = int(floor(float(boss.atk) * GOLEM_AOE_RATIO))
	if aoe_dmg <= 0:
		return
	for h in GameState.active_heroes():
		_boss_strike_hero(idx, h, aoe_dmg)

## Arcane Lich — multi-phase. Phase 1 at <66% HP: +20% atk (one-shot). Phase 2
## at <33% HP: one-time AoE for 50% of each alive hero's max HP. Both flags
## live on the enemy dict (set at spawn from `_force_enemies` defaults or
## `_spawn_boss`).
const LICH_PHASE_1_RATIO: float = 0.66
const LICH_PHASE_1_ATK_MULT: float = 1.2
const LICH_PHASE_2_RATIO: float = 0.33
const LICH_PHASE_2_AOE_RATIO: float = 0.5

func _boss_tick_arcane_lich(idx: int, boss) -> void:
	var hp_ratio: float = float(boss.hp) / float(boss.max_hp)
	if hp_ratio < LICH_PHASE_1_RATIO and not bool(boss.get(&"phase_1_applied", false)):
		boss.atk = int(floor(float(boss.atk) * LICH_PHASE_1_ATK_MULT))
		boss.phase_1_applied = true
	if hp_ratio < LICH_PHASE_2_RATIO and not bool(boss.get(&"phase_2_applied", false)):
		boss.phase_2_applied = true
		for h in GameState.active_heroes():
			var dmg: int = int(floor(float(h.max_hp) * LICH_PHASE_2_AOE_RATIO))
			_boss_strike_hero(idx, h, dmg)

## Shared damage path for boss-special attacks (golem AoE / lich phase 2 AoE).
## Mirrors _enemy_attack's death-notification + signal contract minus the
## debuff multiplier (specials ignore Frostbite-style debuffs).
func _boss_strike_hero(boss_idx: int, hero, dmg: int) -> void:
	if hero == null or hero.is_dead:
		return
	hero.hp = maxi(0, hero.hp - dmg)
	var killed: bool = false
	if hero.hp <= 0 and not hero.is_dead:
		hero.is_dead = true
		killed = true
	GameState.emit_signal(&"hero_hp_changed", hero.data.id)
	emit_signal(&"enemy_hit_hero", boss_idx, hero.data.id, dmg)
	if killed:
		GameState.emit_signal(&"hero_died", hero.data.id)

## ---------- End-of-state hooks ----------

func _dead_enemy_count() -> int:
	var dead: int = 0
	for e in GameState.enemies:
		if int(e.hp) <= 0:
			dead += 1
	return dead

func _on_wave_cleared() -> void:
	stop()
	var gold_award: int = 5 + _current_wave * 2
	if BOSS_BY_WAVE.has(_current_wave):
		gold_award *= 2   ## Stage D — boss gold reward doubled
	GameState.add_gold(gold_award)
	GameState.emit_signal(&"wave_cleared", _current_wave)
	if _current_wave >= GameState.TOTAL_WAVES:
		GameState.emit_signal(&"stage_cleared")

func _on_wipe() -> void:
	stop()
	GameState.emit_signal(&"squad_wiped")

func _on_time_cap() -> void:
	## Force-fill the gauge of every alive squad member who hasn't burned their
	## ult yet, so the player always gets to fire each hero's ult before the
	## fight drags past TIME_CAP_SEC.
	for h in GameState.active_heroes():
		if not h.ult_used:
			h.ult_gauge = ULT_GAUGE_MAX
			GameState.emit_signal(&"hero_ult_changed", h.data.id)

## Tag-aware narration helper for the combat log.
func _log_hero_hit(hero, enemy, dmg: int, is_crit: bool) -> void:
	var prefix: String = ""
	if is_crit:
		prefix += "⚡"
	GameState.append_combat_log("[color=ffd070]%s%s → %s for %d[/color]" % [prefix, hero.data.name, enemy.name, dmg])
