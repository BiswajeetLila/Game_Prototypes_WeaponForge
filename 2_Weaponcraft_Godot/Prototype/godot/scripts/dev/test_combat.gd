## Test harness for scripts/core/combat.gd.
##
## Drives Combat.step() manually (start_wave with auto_tick=false) so we can
## inspect state at every micro-step without waiting on the real-time Timer.
##
## Run: scenes/dev/TestCombat.tscn -> Play Scene (Ctrl+Shift+F5).
extends Control

const InventoryItemT = preload("res://scripts/data/inventory_item.gd")
const HeroDataT = preload("res://scripts/data/hero_data.gd")
const HeroStateT = preload("res://scripts/data/hero_state.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== Combat tests ===")
	_test_start_wave_spawns_2_or_3_enemies()
	_test_spawned_enemies_have_weak_always_and_resist_70pct()
	_test_hero_attack_deals_atk_damage()
	_test_weak_multiplier_18x_applied()
	_test_resist_multiplier_05x_applied()
	_test_ult_gauge_fills_from_damage()
	_test_persistent_ult_gauge_across_waves()
	_test_fire_ult_aoe_resets_used_clears_gauge()
	_test_fire_ult_blocked_when_already_used()
	_test_fire_ult_blocked_below_100_gauge()
	_test_steamburst_splash_hits_other_enemies()
	_test_inferno_stack_burn_resets_on_target_switch()
	_test_enemy_attacks_hero_for_wave_scaled_dmg()
	_test_hero_death_emits_wipe()
	_test_wave_clear_awards_gold_5_plus_2w()
	_test_time_cap_force_fills_ult()
	_test_fire_ult_meteor_aoe_plus_burn_on_primary()
	_test_fire_ult_shadowstep_single_target_3x_crit_flag()
	_test_wipe_only_when_all_squad_dead()
	_test_hit_pause_caps_at_max_freeze()
	_test_combat_step_writes_breadcrumb()
	_test_juice_enabled_const_exists()
	_test_breadcrumb_records_start_phase()
	_test_heartbeat_advances_per_frame()
	_test_screen_shake_idle_skip()
	_test_cap_pop_layer_terminates_bounded()
	_test_cap_pop_layer_below_max_is_noop()
	_summary()
	_render_to_ui()

## ---------- Helpers ----------

func _fresh_session_with_weapon(parts: Array) -> void:
	GameState.new_session()
	## parts is Array of [slot, part_id, level] triples to set up Bran's weapon.
	for spec in parts:
		var item = InventoryItemT.new(GameState.next_uid(), spec[1], spec[2])
		GameState.hero.weapon.set_slot(spec[0], item)
	GameState.hero.refresh_max_hp()

func _force_enemies(specs: Array) -> void:
	## specs: Array of dicts to fully override the spawned enemy list. Used after
	## start_wave(false) to deterministic-ify weak/resist/hp.
	GameState.enemies.clear()
	for s in specs:
		GameState.enemies.append({
			&"id": s.get(&"id", &"slime"),
			"name": s.get("name", "Test_%d" % GameState.enemies.size()),
			"hp": int(s.get("hp", 50)),
			"max_hp": int(s.get("hp", 50)),
			"weak": s.get("weak", &""),
			"resist": s.get("resist", &""),
			"sprite": null,
			"frozen": false,
			"debuffed": false,
			"debuff_dur": 0,
			"debuff_mult": 1.0,
		})

## ---------- Cases ----------

func _test_start_wave_spawns_2_or_3_enemies() -> void:
	_fresh_session_with_weapon([])
	Combat.start_wave(1, false)
	var n: int = GameState.enemies.size()
	_check("start_wave(1) spawns 2 or 3 enemies", n == 2 or n == 3, "n=%d" % n)
	Combat.stop()

func _test_spawned_enemies_have_weak_always_and_resist_70pct() -> void:
	_fresh_session_with_weapon([])
	## Sample 200 spawns; every enemy must have a weak tag, and ~70% must have a resist.
	var total := 0
	var with_resist := 0
	var without_weak := 0
	for _i in 200:
		Combat.start_wave(1, false)
		for enemy in GameState.enemies:
			total += 1
			if enemy.weak == &"":
				without_weak += 1
			if enemy.resist != &"":
				with_resist += 1
		Combat.stop()
	var resist_ratio: float = float(with_resist) / float(total)
	_check("every spawn has a weak tag",
		without_weak == 0,
		"total=%d without_weak=%d" % [total, without_weak])
	_check("resist applies to ~70%% of spawns (±10%%)",
		resist_ratio > 0.6 and resist_ratio < 0.8,
		"resist_ratio=%.2f (n=%d)" % [resist_ratio, total])

func _test_hero_attack_deals_atk_damage() -> void:
	_fresh_session_with_weapon([
		[&"head", &"h_iron_edge", 1],    ## +8 atk -> total 6+8=14
		[&"hilt", &"p_steel_grip", 1],   ## +4 atk -> total 18
	])
	Combat.start_wave(1, false)
	_force_enemies([
		{"hp": 200, "weak": &"", "resist": &""},   ## immune to elements so we see raw atk
	])
	## Zero crit, no recipe tags. Dmg should be exactly 18 each hit (Bran baseAtk 6 + 8 + 4).
	## Use multiple ticks; track min/max hit to confirm no crit volatility.
	var saw_hits: Array = []
	for _i in 8:
		var hp_before: int = GameState.enemies[0].hp
		Combat.step()
		var hp_after: int = GameState.enemies[0].hp
		var dmg: int = hp_before - hp_after
		if dmg > 0:
			saw_hits.append(dmg)
		## Re-heal enemy so the test keeps probing.
		GameState.enemies[0].hp = 200
		GameState.hero.hp = GameState.hero.max_hp
	Combat.stop()
	## Without any +crit% part, crit is 0 -> dmg always 18.
	var ok: bool = saw_hits.size() > 0 and saw_hits.min() == 18 and saw_hits.max() == 18
	_check("zero-crit hero hits land exactly atk = 18 every time",
		ok, "hits=%s" % str(saw_hits))

func _test_weak_multiplier_18x_applied() -> void:
	_fresh_session_with_weapon([
		[&"head", &"h_iron_edge", 1],
		[&"hilt", &"p_pyro_pommel", 1],   ## fire tag, +2 atk -> total 16
	])
	Combat.start_wave(1, false)
	_force_enemies([{"hp": 9999, "weak": &"fire", "resist": &""}])
	GameState.enemies[0].hp = 9999
	Combat.step()
	var dmg: int = 9999 - GameState.enemies[0].hp
	## Expected: atk=16, weak=1.8 -> floor(16*1.8) = 28
	_check("weak (fire) multiplies dmg to floor(16*1.8) = 28",
		dmg == 28, "dmg=%d" % dmg)
	Combat.stop()

func _test_resist_multiplier_05x_applied() -> void:
	_fresh_session_with_weapon([
		[&"head", &"h_iron_edge", 1],
		[&"hilt", &"p_pyro_pommel", 1],   ## fire tag, total atk 16
	])
	Combat.start_wave(1, false)
	_force_enemies([{"hp": 9999, "weak": &"ice", "resist": &"fire"}])
	GameState.enemies[0].hp = 9999
	Combat.step()
	var dmg: int = 9999 - GameState.enemies[0].hp
	## Expected: atk=16, resist=0.5 -> floor(16*0.5) = 8
	_check("resist (fire) halves dmg to floor(16*0.5) = 8",
		dmg == 8, "dmg=%d" % dmg)
	Combat.stop()

func _test_ult_gauge_fills_from_damage() -> void:
	_fresh_session_with_weapon([
		[&"head", &"h_iron_edge", 1],
		[&"hilt", &"p_steel_grip", 1],
	])
	Combat.start_wave(1, false)
	_force_enemies([{"hp": 9999, "weak": &"", "resist": &""}])
	var before: float = GameState.hero.ult_gauge
	Combat.step()
	var after: float = GameState.hero.ult_gauge
	## dmg=18, gain = 6 + floor(18*0.2) + ult_rate(0)/4 = 6+3+0 = 9 (capped at 100)
	_check("ult gauge gains base 6 + floor(dmg*0.2) per hit (got 9)",
		(after - before) == 9.0, "gain=%.1f" % (after - before))
	Combat.stop()

func _test_persistent_ult_gauge_across_waves() -> void:
	_fresh_session_with_weapon([])
	GameState.hero.ult_gauge = 42.0
	GameState.hero.ult_used = true
	Combat.start_wave(2, false)
	_check("start_wave keeps ult_gauge but resets ult_used",
		GameState.hero.ult_gauge == 42.0 and GameState.hero.ult_used == false,
		"gauge=%.1f used=%s" % [GameState.hero.ult_gauge, str(GameState.hero.ult_used)])
	Combat.stop()

func _test_fire_ult_aoe_resets_used_clears_gauge() -> void:
	_fresh_session_with_weapon([
		[&"head", &"h_iron_edge", 1],
		[&"hilt", &"p_steel_grip", 1],
	])
	Combat.start_wave(1, false)
	_force_enemies([{"hp": 999}, {"hp": 999}, {"hp": 999}])
	GameState.hero.ult_gauge = 100.0
	var ok: bool = Combat.fire_ult(&"bran")
	## atk = 18, ult_mult 3.5 -> dmg per enemy = floor(18*3.5) = 63
	var all_hit_63: bool = true
	for enemy in GameState.enemies:
		if (999 - enemy.hp) != 63:
			all_hit_63 = false
			break
	_check("fire_ult: every alive enemy hit by floor(atk*3.5) = 63",
		ok and all_hit_63 and GameState.hero.ult_used and GameState.hero.ult_gauge == 0.0,
		"ok=%s used=%s gauge=%.0f" % [str(ok), str(GameState.hero.ult_used), GameState.hero.ult_gauge])
	Combat.stop()

func _test_fire_ult_blocked_when_already_used() -> void:
	_fresh_session_with_weapon([[&"head", &"h_iron_edge", 1]])
	Combat.start_wave(1, false)
	_force_enemies([{"hp": 9999}])
	GameState.hero.ult_gauge = 100.0
	Combat.fire_ult(&"bran")
	## Refill gauge artificially; ult_used should still block.
	GameState.hero.ult_gauge = 100.0
	var ok: bool = Combat.fire_ult(&"bran")
	_check("fire_ult returns false on second call this fight",
		not ok, "ok=%s" % str(ok))
	Combat.stop()

func _test_fire_ult_blocked_below_100_gauge() -> void:
	_fresh_session_with_weapon([[&"head", &"h_iron_edge", 1]])
	Combat.start_wave(1, false)
	_force_enemies([{"hp": 9999}])
	GameState.hero.ult_gauge = 99.0
	var ok: bool = Combat.fire_ult(&"bran")
	_check("fire_ult returns false when gauge < 100",
		not ok, "ok=%s" % str(ok))
	Combat.stop()

func _test_steamburst_splash_hits_other_enemies() -> void:
	_fresh_session_with_weapon([
		[&"hilt", &"p_pyro_pommel", 1],   ## fire
		[&"rune", &"r_ice", 1],           ## ice -> Steamburst triggers (fire+ice)
	])
	Combat.start_wave(1, false)
	_force_enemies([
		{"hp": 9999, "weak": &"", "resist": &""},
		{"hp": 9999, "weak": &"", "resist": &""},
		{"hp": 9999, "weak": &"", "resist": &""},
	])
	var hp_before: Array = [9999, 9999, 9999]
	## RNG picks one target — we measure splash by checking the other two each got
	## floor(primary_dmg * 0.35).
	## Bran atk = 6 + 0 + 2 + 3 = 11 (no h_iron_edge here). Splash dmg = floor(11*0.35) = 3.
	Combat.step()
	var hits: Array = [hp_before[0] - GameState.enemies[0].hp,
		hp_before[1] - GameState.enemies[1].hp, hp_before[2] - GameState.enemies[2].hp]
	## Exactly one slot took 11 (primary), the other two took 3 (splash). Order varies by RNG.
	hits.sort()
	_check("Steamburst splash: primary=11, two others=3 each (in any order)",
		hits[0] == 3 and hits[1] == 3 and hits[2] == 11,
		"hits=%s" % str(hits))
	Combat.stop()

func _test_inferno_stack_burn_resets_on_target_switch() -> void:
	_fresh_session_with_weapon([
		[&"hilt", &"p_pyro_pommel", 1],   ## fire
		[&"rune", &"r_fire", 1],           ## fire -> Inferno triggers (fire+fire)
	])
	Combat.start_wave(1, false)
	_force_enemies([{"hp": 9999, "weak": &"", "resist": &""}])
	## Step #1: stack starts 0 -> stays 0 (no prev target). Dmg = atk=12.
	## Bran atk = 6 + 2 + 3 = 11. Wait, no head equipped. Yes atk = 11.
	## Step #1 dmg = floor(11 * (1 + 0.12*0)) = 11.
	## Step #2 same target -> burn_stack = 1. dmg = floor(11 * 1.12) = 12.
	## Step #3 same target -> burn_stack = 2. dmg = floor(11 * 1.24) = 13.
	## Step #4 same target -> burn_stack = 3 (cap). dmg = floor(11 * 1.36) = 14.
	## Step #5 same target -> stays at cap 3. dmg = 14.
	var hits: Array = []
	for _i in 5:
		var before: int = GameState.enemies[0].hp
		Combat.step()
		hits.append(before - GameState.enemies[0].hp)
		GameState.enemies[0].hp = 9999    ## refill to keep test deterministic
	## Now switch the only enemy to a NEW one (different name) -> stack should reset to 0.
	_force_enemies([{"hp": 9999, "name": "Different_99", "weak": &"", "resist": &""}])
	var before6: int = GameState.enemies[0].hp
	Combat.step()
	var hit6: int = before6 - GameState.enemies[0].hp
	_check("Inferno stack ramps 11/12/13/14/14 then resets to 11 on target switch",
		hits == [11, 12, 13, 14, 14] and hit6 == 11,
		"hits=%s hit6=%d" % [str(hits), hit6])
	Combat.stop()

func _test_enemy_attacks_hero_for_wave_scaled_dmg() -> void:
	_fresh_session_with_weapon([])
	Combat.start_wave(3, false)
	## Replace spawned enemies with exactly 1 known enemy so we can predict dmg.
	_force_enemies([{"hp": 9999, "weak": &"", "resist": &""}])
	var hp_before: int = GameState.hero.hp
	Combat.step()
	## Enemy dmg = 4 + floor(3*1.4) = 4 + 4 = 8 per turn from one enemy.
	## (Bran also attacks the enemy, doesn't matter for the hero-hp check.)
	var dmg: int = hp_before - GameState.hero.hp
	_check("enemy hits hero for 4 + floor(wave*1.4) = 8 at wave 3",
		dmg == 8, "dmg=%d" % dmg)
	Combat.stop()

func _test_hero_death_emits_wipe() -> void:
	## Solo squad: Bran dying triggers BOTH hero_died(bran) (per-individual) and
	## squad_wiped (no heroes left alive). Phase 2 multi-hero adds a separate
	## case verifying squad_wiped does NOT fire while any teammate is alive.
	_fresh_session_with_weapon([])
	Combat.start_wave(1, false)
	_force_enemies([{"hp": 9999}, {"hp": 9999}])
	GameState.hero.hp = 1
	var died := [false]
	var wiped := [false]
	var died_cb := func(_id): died[0] = true
	var wipe_cb := func(): wiped[0] = true
	GameState.hero_died.connect(died_cb)
	GameState.squad_wiped.connect(wipe_cb)
	Combat.step()
	GameState.hero_died.disconnect(died_cb)
	GameState.squad_wiped.disconnect(wipe_cb)
	_check("solo hero death emits hero_died + squad_wiped",
		died[0] and wiped[0] and GameState.hero.is_dead,
		"died=%s wiped=%s dead=%s hp=%d" % [str(died[0]), str(wiped[0]), str(GameState.hero.is_dead), GameState.hero.hp])
	Combat.stop()

func _test_wave_clear_awards_gold_5_plus_2w() -> void:
	_fresh_session_with_weapon([[&"head", &"h_iron_edge", 1]])
	GameState.gold = 0
	GameState.emit_signal(&"gold_changed", 0)
	Combat.start_wave(2, false)
	_force_enemies([{"hp": 1, "weak": &"", "resist": &""}])
	Combat.step()  ## Bran kills the 1-hp enemy
	## Wave 2 award = 5 + 2*2 = 9.
	_check("wave clear awards 5 + wave*2 = 9 gold at wave 2",
		GameState.gold == 9, "gold=%d" % GameState.gold)
	Combat.stop()

func _test_fire_ult_meteor_aoe_plus_burn_on_primary() -> void:
	## Meteor: AoE all alive enemies × ult_atk_multiplier + advances burn_stack
	## against the highest-HP target (capped by Inferno's stack_cap).
	_fresh_session_with_weapon([
		[&"hilt", &"p_pyro_pommel", 1],   ## fire
		[&"rune", &"r_fire", 1],          ## fire -> Inferno active, stack_cap=3
	])
	Combat.start_wave(1, false)
	_force_enemies([
		{"hp": 9999, "name": "primary"},
		{"hp": 50,   "name": "secondary_a"},
		{"hp": 30,   "name": "secondary_b"},
	])
	var hero = GameState.hero
	var saved_key = hero.data.ult_key
	var saved_mult = hero.data.ult_atk_multiplier
	hero.data.ult_key = &"meteor"
	hero.data.ult_atk_multiplier = 1.5
	hero.ult_gauge = 100.0
	hero.burn_stack = 0
	hero.last_target_name = &""
	var hp_before := [9999, 50, 30]
	var ok: bool = Combat.fire_ult(&"bran")
	## Restore so subsequent tests aren't poisoned.
	hero.data.ult_key = saved_key
	hero.data.ult_atk_multiplier = saved_mult
	## Bran atk = 6 + 2 + 3 = 11. Meteor dmg = floor(11 * 1.5) = 16 per enemy.
	var deltas := [
		hp_before[0] - GameState.enemies[0].hp,
		hp_before[1] - GameState.enemies[1].hp,
		hp_before[2] - GameState.enemies[2].hp,
	]
	var all_hit_16: bool = deltas[0] == 16 and deltas[1] == 16 and deltas[2] == 16
	## With Inferno equipped (stack_cap=3), burn_stack goes 0 -> 1, primary locks in.
	var burn_ok: bool = hero.burn_stack == 1 and hero.last_target_name == "primary"
	_check("Meteor: AoE 16 to each + burn_stack=1 against primary",
		ok and all_hit_16 and burn_ok,
		"ok=%s deltas=%s burn=%d last=%s" % [str(ok), str(deltas), hero.burn_stack, str(hero.last_target_name)])
	Combat.stop()

func _test_fire_ult_shadowstep_single_target_3x_crit_flag() -> void:
	## Shadowstep: single-target highest-HP, damage = atk × ult_atk_multiplier,
	## is_crit flag emitted on the hit signal (informational; no double-stack).
	_fresh_session_with_weapon([
		[&"head", &"h_iron_edge", 1],   ## +8 atk -> total 14
	])
	Combat.start_wave(1, false)
	_force_enemies([
		{"hp": 200, "name": "primary"},   ## highest
		{"hp": 80,  "name": "weak"},
		{"hp": 50,  "name": "weakest"},
	])
	var hero = GameState.hero
	var saved_key = hero.data.ult_key
	var saved_mult = hero.data.ult_atk_multiplier
	hero.data.ult_key = &"shadowstep"
	hero.data.ult_atk_multiplier = 3.0
	hero.ult_gauge = 100.0
	## Capture the hit signal: only the primary index, with is_crit true.
	var hits := []
	var cb := func(_hid, idx, dmg, src, is_crit):
		hits.append({"idx": idx, "dmg": dmg, "src": src, "is_crit": is_crit})
	Combat.hero_hit_enemy.connect(cb)
	var ok: bool = Combat.fire_ult(&"bran")
	Combat.hero_hit_enemy.disconnect(cb)
	hero.data.ult_key = saved_key
	hero.data.ult_atk_multiplier = saved_mult
	## atk=14, dmg = floor(14 * 3.0) = 42. Only primary (idx 0) should be hit.
	var primary_hit_42: bool = (200 - GameState.enemies[0].hp) == 42
	var others_untouched: bool = GameState.enemies[1].hp == 80 and GameState.enemies[2].hp == 50
	var single_crit_hit: bool = hits.size() == 1 and hits[0].idx == 0 and hits[0].dmg == 42 and hits[0].is_crit
	_check("Shadowstep: highest-HP only for 42 with crit flag",
		ok and primary_hit_42 and others_untouched and single_crit_hit,
		"ok=%s prim=%d hits=%s" % [str(ok), 200 - GameState.enemies[0].hp, str(hits)])
	Combat.stop()

func _test_wipe_only_when_all_squad_dead() -> void:
	## Two-hero squad: while any teammate alive, squad_wiped MUST NOT fire even
	## though one hero is dead. Validates the any_alive() guard in step()'s
	## win/loss check. Per-individual hero_died is covered by the solo wipe test.
	_fresh_session_with_weapon([])
	var stunt_data = HeroDataT.new()
	stunt_data.id = &"stunt"
	stunt_data.name = "Stunt"
	stunt_data.cls = &"warrior"
	stunt_data.hp_base = 80
	stunt_data.atk_base = 6
	stunt_data.ult_key = &"whirlwind"
	var stunt = HeroStateT.new(stunt_data)
	GameState.heroes[&"stunt"] = stunt
	GameState.squad_order.append(&"stunt")
	## Kill Bran deterministically (bypass enemy-RNG); stunt stays at full hp.
	GameState.hero.hp = 0
	GameState.hero.is_dead = true

	Combat.start_wave(1, false)
	_force_enemies([{"hp": 9999, "name": "lone"}])

	var wiped := [false]
	var wipe_cb := func(): wiped[0] = true
	GameState.squad_wiped.connect(wipe_cb)

	## Tick 1: enemy can only target stunt (active_heroes filters Bran out).
	## Stunt loses some hp but lives. squad_wiped MUST stay quiet.
	Combat.step()
	var no_wipe_with_one_alive: bool = (not wiped[0]) and (not stunt.is_dead)

	## Drain stunt to 1 hp; next tick the enemy attack kills him -> full wipe.
	stunt.hp = 1
	Combat.step()
	GameState.squad_wiped.disconnect(wipe_cb)
	_check("squad_wiped fires only when no heroes alive",
		no_wipe_with_one_alive and wiped[0] and stunt.is_dead,
		"no_wipe=%s wiped=%s stunt_dead=%s stunt_hp=%d"
			% [str(no_wipe_with_one_alive), str(wiped[0]), str(stunt.is_dead), stunt.hp])
	Combat.stop()

## ---------- Popup cap infinite-loop fix (popup-cap-infinite-loop-fix) ----------

const BattleViewT = preload("res://scripts/ui/battle_view.gd")

func _test_cap_pop_layer_terminates_bounded() -> void:
	## Root-cause repro: the original cap was
	##     while layer.get_child_count() > MAX:
	##         layer.get_child(0).queue_free()
	## queue_free is deferred — get_child_count doesn't drop inside the loop —
	## so this spins forever the moment popups exceed MAX. We now use a
	## bounded for-loop. Test: with 20 children + MAX=8, cap must return
	## within 50ms wall-clock (real fix returns in microseconds; the buggy
	## version hangs the process indefinitely).
	var layer := Control.new()
	add_child(layer)
	for i in 20:
		layer.add_child(Label.new())
	var t0: int = Time.get_ticks_msec()
	BattleViewT.cap_pop_layer(layer, 8)
	var elapsed: int = Time.get_ticks_msec() - t0
	_check("cap_pop_layer terminates within 50ms with 20 children + MAX=8",
		elapsed < 50, "elapsed=%dms" % elapsed)
	## After one frame yield, queue_free flushes and child count drops to MAX.
	await get_tree().process_frame
	await get_tree().process_frame
	var final_count: int = layer.get_child_count()
	_check("cap_pop_layer leaves exactly MAX children after frame yield",
		final_count == 8, "final_count=%d" % final_count)
	layer.queue_free()

func _test_cap_pop_layer_below_max_is_noop() -> void:
	## Cap with N < MAX should be a no-op.
	var layer := Control.new()
	add_child(layer)
	for i in 5:
		layer.add_child(Label.new())
	BattleViewT.cap_pop_layer(layer, 8)
	## No frame yield needed — nothing got queue_freed.
	_check("cap_pop_layer with 5 children + MAX=8 keeps all 5",
		layer.get_child_count() == 5,
		"count=%d" % layer.get_child_count())
	layer.queue_free()

## ---------- Hang diagnostics (juice-hang-diag branch) ----------

func _test_heartbeat_advances_per_frame() -> void:
	## Heartbeat autoload writes user://heartbeat.txt every _process tick with
	## the current process frame count. Polling it from outside (Task Manager,
	## another script, file watcher) reveals if main thread is stuck. If two
	## reads 1s apart show the SAME frame number, main thread is hung.
	const HEARTBEAT_PATH := "user://heartbeat.txt"
	## Heartbeat writes once on _ready so this is reachable synchronously.
	_check("Heartbeat.gd autoload writes user://heartbeat.txt",
		FileAccess.file_exists(HEARTBEAT_PATH),
		"path=%s" % ProjectSettings.globalize_path(HEARTBEAT_PATH))
	if FileAccess.file_exists(HEARTBEAT_PATH):
		var f := FileAccess.open(HEARTBEAT_PATH, FileAccess.READ)
		var body: String = f.get_as_text() if f != null else ""
		_check("heartbeat body contains 'frame=' token",
			"frame=" in body, "body=%s" % body.strip_edges())

func _test_screen_shake_idle_skip() -> void:
	## ScreenShake._process must NOT mutate target.position every frame when
	## trauma is zero. Otherwise a 60fps `Main.position = Vector2.ZERO` write
	## triggers a Container layout cascade through the entire UI tree, which
	## CAN be the cost driver behind the wave-2 hang.
	## Spec: ScreenShake exposes a `_set_count` int that increments every time
	## _process writes target.position. We register a fake target, call
	## _process(delta) directly a few times with trauma=0, and assert
	## _set_count never advances.
	var stunt := Control.new()
	add_child(stunt)
	ScreenShake.register_target(stunt)
	ScreenShake._at_origin = true     ## reset idle-skip flag
	ScreenShake._set_count = 0
	ScreenShake._trauma = 0.0
	## Drive 5 frames manually — _process is the only path that touches the counter.
	for _i in 5:
		ScreenShake._process(0.016)
	var idle_count: int = ScreenShake._set_count
	## Now kick once and drive another frame; counter should advance.
	ScreenShake.kick(6.0, 0.18)
	ScreenShake._process(0.016)
	var after_kick: int = ScreenShake._set_count
	_check("ScreenShake idle (trauma=0) does NOT touch target.position",
		idle_count == 0,
		"idle_count=%d after_kick=%d" % [idle_count, after_kick])
	_check("ScreenShake active (trauma>0) DOES touch target.position",
		after_kick > idle_count,
		"idle_count=%d after_kick=%d" % [idle_count, after_kick])
	## Clean up
	stunt.queue_free()
	ScreenShake.register_target(null)
	ScreenShake._trauma = 0.0

## ---------- Diag kill-switch (juice-diag-kill-switch branch) ----------

func _test_juice_enabled_const_exists() -> void:
	## Global kill-switch: setting JuiceConfig.JUICE_ENABLED = false in source
	## causes BattleView + SquadBar to skip ScreenShake.kick / HitPause.freeze /
	## sprite-flash / popup spawn. Lets us isolate juice as the hang culprit
	## by flipping one constant.
	const JuiceConfigT = preload("res://scripts/core/juice_config.gd")
	_check("JuiceConfig.JUICE_ENABLED const exists and is bool",
		typeof(JuiceConfigT.JUICE_ENABLED) == TYPE_BOOL,
		"type=%d value=%s" % [typeof(JuiceConfigT.JUICE_ENABLED), str(JuiceConfigT.JUICE_ENABLED)])

func _test_breadcrumb_records_start_phase() -> void:
	## Diag enhancement: breadcrumb now records phase=start at start_wave AND
	## phase=end after each completed tick. If a hang freezes mid-tick, the
	## breadcrumb shows phase=start so we know step() never returned cleanly.
	var crumb_path: String = "user://last_tick.txt"
	if FileAccess.file_exists(crumb_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(crumb_path))
	_fresh_session_with_weapon([])
	Combat.start_wave(3, false)
	var has_start: bool = false
	if FileAccess.file_exists(crumb_path):
		var f := FileAccess.open(crumb_path, FileAccess.READ)
		var body: String = f.get_as_text() if f != null else ""
		has_start = "phase=start" in body and "wave=3" in body
	_check("breadcrumb after start_wave contains phase=start + wave=3",
		has_start,
		"file_exists=%s" % str(FileAccess.file_exists(crumb_path)))
	Combat.stop()

## ---------- Hardening guards (juice-hardening branch) ----------

func _test_hit_pause_caps_at_max_freeze() -> void:
	## Crash-prevention: a runaway chain (Steamburst + Skewer + Hellfire all
	## landing in one tick) could call HitPause.freeze many times. Each call
	## should be clamped to HitPause.MAX_FREEZE_SEC so the wall-clock window
	## cannot extend unboundedly.
	## Spec: HitPause exposes a const MAX_FREEZE_SEC (recommend 0.2). Any
	## freeze(seconds) where seconds > MAX_FREEZE_SEC clamps to that ceiling.
	## We assert by inspecting _pending_until_ms after a large freeze request.
	HitPause._pending_until_ms = -1   ## reset whatever previous tests left
	var t0: int = Time.get_ticks_msec()
	HitPause.freeze(5.0)              ## absurd 5s pause request
	var window_ms: int = HitPause._pending_until_ms - t0
	var cap_ms: int = int(HitPause.MAX_FREEZE_SEC * 1000.0)
	_check("HitPause.freeze(5.0) clamps to MAX_FREEZE_SEC ceiling",
		window_ms <= cap_ms + 50,   ## +50ms slack for the wall-clock skew
		"window_ms=%d cap_ms=%d MAX_FREEZE_SEC=%.2f" % [window_ms, cap_ms, HitPause.MAX_FREEZE_SEC])
	## Restore so subsequent tests start clean.
	HitPause._pending_until_ms = -1
	Engine.time_scale = 1.0

func _test_combat_step_writes_breadcrumb() -> void:
	## Crash diagnostics: every Combat.step() should write user://last_tick.txt
	## with wave + tick counter. If Godot hard-crashes again, the file is the
	## bread-crumb showing the last completed tick. Spec: file contents are a
	## single line "wave=<n> tick=<n>".
	var crumb_path: String = "user://last_tick.txt"
	## Wipe any prior breadcrumb so we're not reading stale state.
	if FileAccess.file_exists(crumb_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(crumb_path))
	_fresh_session_with_weapon([])
	Combat.start_wave(2, false)
	_force_enemies([{"hp": 9999, "name": "lone"}])
	Combat.step()
	_check("Combat.step() writes user://last_tick.txt breadcrumb",
		FileAccess.file_exists(crumb_path),
		"path=%s" % ProjectSettings.globalize_path(crumb_path))
	if FileAccess.file_exists(crumb_path):
		var f := FileAccess.open(crumb_path, FileAccess.READ)
		var body: String = f.get_as_text() if f != null else ""
		_check("breadcrumb body contains wave=2",
			"wave=2" in body, "body=%s" % body.strip_edges())
	Combat.stop()

func _test_time_cap_force_fills_ult() -> void:
	_fresh_session_with_weapon([[&"head", &"h_iron_edge", 1]])
	Combat.start_wave(1, false)
	_force_enemies([{"hp": 9999}])
	GameState.hero.ult_gauge = 17.0
	## Manually invoke the time-cap handler (the Timer isn't running in tests).
	Combat._on_time_cap()
	_check("time-cap forces ult_gauge to 100",
		GameState.hero.ult_gauge == Combat.ULT_GAUGE_MAX,
		"gauge=%.1f" % GameState.hero.ult_gauge)
	Combat.stop()

## ---------- Test helpers ----------

func _check(name: String, ok: bool, detail: String) -> void:
	if ok:
		_passed += 1
		_log("  PASS  " + name)
	else:
		_failed += 1
		_log("  FAIL  " + name + (("  [" + detail + "]") if detail != "" else ""))

func _summary() -> void:
	_log("=== %d passed / %d failed ===" % [_passed, _failed])

func _log(line: String) -> void:
	print(line)
	_lines.append(line)

func _render_to_ui() -> void:
	var label := Label.new()
	label.add_theme_font_size_override(&"font_size", 12)
	label.text = "\n".join(_lines)
	label.anchor_right = 1.0
	label.anchor_bottom = 1.0
	label.offset_left = 12
	label.offset_top = 12
	add_child(label)
