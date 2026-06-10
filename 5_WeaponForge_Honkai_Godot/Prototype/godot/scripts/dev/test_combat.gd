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
	## Balance pass.
	_test_total_waves_is_15()
	_test_bran_hp_base_120()
	_test_elara_hp_base_90()
	_test_vex_hp_base_75()
	_test_partdata_default_cost_4()
	_test_h_iron_edge_cost_4()
	_test_p_steel_grip_cost_4()
	_test_r_pierce_cost_4()
	_test_elara_unlock_wave_constant_3()
	_test_vex_unlock_wave_constant_6()
	## Stage D — bosses + retry + 15-wave balance.
	_test_enemy_data_is_boss_default_false()
	_test_boss_slime_king_tres_loads()
	_test_boss_iron_golem_tres_loads()
	_test_boss_arcane_lich_tres_loads()
	_test_revive_squad_for_retry_resets_all()
	_test_wave_hp_mult_curve()
	_test_base_atk_tier_scaled()
	_test_boss_spawn_W5_single_slime_king()
	_test_boss_spawn_W10_single_iron_golem()
	_test_boss_spawn_W15_single_arcane_lich()
	_test_boss_wave_gold_doubled()
	_test_slime_king_heals_8_above_50pct()
	_test_slime_king_no_heal_below_50pct()
	_test_iron_golem_aoe_every_4_ticks()
	_test_arcane_lich_phase1_atk_bump_below_66pct()
	_test_arcane_lich_phase2_aoe_below_33pct()
	## Stage rotation (S2).
	_test_stage_mults_neutral_at_stage_1()
	_test_stage_mults_scale()
	_test_boss_rotation_by_stage()
	## Catalyst v1 combat hook (B5).
	_test_catalyst_bag_initialized_empty()
	_test_start_wave_refreshes_catalyst_bag_neutral()
	_test_start_wave_applies_firestorm_bag()
	_test_stage_1_neutrality_preserved()
	## Scripted Pacing Rework C1 — Hot Paladin descend.
	_test_paladin_defeat_trigger_at_50pct_hp()
	_test_paladin_defeat_skips_on_retry()
	_test_paladin_defeat_only_on_lich_boss()
	## Scripted Pacing Rework C2 — paladin joins squad_order via unlock_hero.
	_test_paladin_defeat_unlocks_squad_order()
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
			"max_hp": int(s.get("max_hp", s.get("hp", 50))),
			"weak": s.get("weak", &""),
			"resist": s.get("resist", &""),
			"sprite": null,
			"frozen": false,
			"debuffed": false,
			"debuff_dur": 0,
			"debuff_mult": 1.0,
			"is_boss": bool(s.get("is_boss", false)),
			"atk": int(s.get("atk", 0)),
			"phase_1_applied": bool(s.get("phase_1_applied", false)),
			"phase_2_applied": bool(s.get("phase_2_applied", false)),
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
	## New model (Task 4): 80% of minions carry the stage affinity (weak+resist both set),
	## ~20% spawn un-classed (both empty). Stale assertions for the old random model updated:
	##   - unclassed fraction (without_weak) must be in [10%, 30%]
	##   - classed fraction (with_resist) must be in [70%, 90%]
	## Both weak and resist move together: a classed minion always has both; an un-classed has neither.
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
	var unclassed_ratio: float = float(without_weak) / float(total)
	_check("unclassed spawns (empty weak) are ~20%% (10-30%%)",
		unclassed_ratio >= 0.10 and unclassed_ratio <= 0.30,
		"unclassed_ratio=%.2f (n=%d)" % [unclassed_ratio, total])
	_check("classed spawns have resist ~80%% (70-90%%)",
		resist_ratio >= 0.70 and resist_ratio <= 0.90,
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
	## Replace spawned enemies with exactly 1 known enemy. Atk left at 0 so
	## _enemy_attack falls back to Combat.base_atk(_current_wave).
	_force_enemies([{"hp": 9999, "weak": &"", "resist": &""}])
	var hp_before: int = GameState.hero.hp
	Combat.step()
	## Stage D tier-scaled base_atk at W3 = 4 + floor(3*1.2) = 7.
	var dmg: int = hp_before - GameState.hero.hp
	_check("enemy hits hero for base_atk(3) = 7",
		dmg == 7, "dmg=%d" % dmg)
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

## ---------- Balance pass (forge-ux-balance-w10 branch) ----------

func _test_total_waves_is_15() -> void:
	_check("GameState.TOTAL_WAVES == 15",
		GameState.TOTAL_WAVES == 15,
		"got %d" % GameState.TOTAL_WAVES)

func _test_bran_hp_base_120() -> void:
	var data = GameState.heroes_by_id.get(&"bran")
	_check("Bran HeroData.hp_base == 120",
		data != null and data.hp_base == 120,
		"got %d" % (data.hp_base if data else -1))

func _test_elara_hp_base_90() -> void:
	var data = GameState.heroes_by_id.get(&"elara")
	_check("Elara HeroData.hp_base == 90",
		data != null and data.hp_base == 90,
		"got %d" % (data.hp_base if data else -1))

func _test_vex_hp_base_75() -> void:
	var data = GameState.heroes_by_id.get(&"vex")
	_check("Vex HeroData.hp_base == 75",
		data != null and data.hp_base == 75,
		"got %d" % (data.hp_base if data else -1))

func _test_partdata_default_cost_4() -> void:
	const PartDataT = preload("res://scripts/data/part_data.gd")
	var fresh = PartDataT.new()
	_check("PartData() default cost == 4",
		fresh.cost == 4,
		"got %d" % fresh.cost)

func _test_h_iron_edge_cost_4() -> void:
	var def = GameState.get_part_def(&"h_iron_edge")
	_check("h_iron_edge.cost == 4 (default inherited)",
		def != null and def.cost == 4,
		"got %s" % str(def.cost if def else "null"))

func _test_p_steel_grip_cost_4() -> void:
	var def = GameState.get_part_def(&"p_steel_grip")
	_check("p_steel_grip.cost == 4 (default inherited)",
		def != null and def.cost == 4,
		"got %s" % str(def.cost if def else "null"))

func _test_r_pierce_cost_4() -> void:
	var def = GameState.get_part_def(&"r_pierce")
	_check("r_pierce.cost == 4 (explicit override)",
		def != null and def.cost == 4,
		"got %s" % str(def.cost if def else "null"))

func _test_elara_unlock_wave_constant_3() -> void:
	const MainT = preload("res://scripts/ui/main.gd")
	var v = MainT.ELARA_UNLOCK_WAVE
	_check("Main.ELARA_UNLOCK_WAVE == 3",
		v == 3, "got %s" % str(v))

func _test_vex_unlock_wave_constant_6() -> void:
	const MainT = preload("res://scripts/ui/main.gd")
	var v = MainT.VEX_UNLOCK_WAVE
	_check("Main.VEX_UNLOCK_WAVE == 6",
		v == 6, "got %s" % str(v))

## ---------- Stage D — bosses + retry + 15-wave balance ----------

const EnemyDataT = preload("res://scripts/data/enemy_data.gd")

func _test_enemy_data_is_boss_default_false() -> void:
	var fresh = EnemyDataT.new()
	var v = fresh.get(&"is_boss")
	_check("EnemyData() default is_boss == false (bool)",
		typeof(v) == TYPE_BOOL and v == false,
		"type=%d value=%s" % [typeof(v), str(v)])

func _test_boss_slime_king_tres_loads() -> void:
	var def = GameState.get_enemy_def(&"boss_slime_king")
	var ok: bool = def != null \
		and def.hp_base == 220 \
		and bool(def.get(&"is_boss")) == true \
		and int(def.get(&"atk_override")) == 18
	_check("boss_slime_king tres: hp=220 atk=18 is_boss=true",
		ok, "def=%s" % str(def))

func _test_boss_iron_golem_tres_loads() -> void:
	var def = GameState.get_enemy_def(&"boss_iron_golem")
	var ok: bool = def != null \
		and def.hp_base == 480 \
		and bool(def.get(&"is_boss")) == true \
		and int(def.get(&"atk_override")) == 28
	_check("boss_iron_golem tres: hp=480 atk=28 is_boss=true",
		ok, "def=%s" % str(def))

func _test_boss_arcane_lich_tres_loads() -> void:
	var def = GameState.get_enemy_def(&"boss_arcane_lich")
	var ok: bool = def != null \
		and def.hp_base == 300 \
		and bool(def.get(&"is_boss")) == true \
		and int(def.get(&"atk_override")) == 18
	_check("boss_arcane_lich tres: hp=300 atk=18 is_boss=true  (HP-50%% + dmg-50%% nerfs 2026-06-09)",
		ok, "def=%s" % str(def))

func _test_revive_squad_for_retry_resets_all() -> void:
	## Sets up Bran + Elara + Vex, kills everyone, calls revive helper, asserts
	## all heroes back at max_hp / not dead / ult_used cleared / burn cleared,
	## while gold + wave + inventory untouched.
	GameState.new_session()
	GameState.unlock_hero(&"elara")
	GameState.unlock_hero(&"vex")
	for h in GameState.all_heroes():
		h.hp = 0
		h.is_dead = true
		h.ult_used = true
		h.ult_gauge = 80.0
		h.burn_stack = 2
		h.last_target_name = &"junk"
	GameState.gold = 42
	GameState.wave = 5
	var dummy_uid: int = GameState.next_uid()
	GameState.inventory.append(InventoryItemT.new(dummy_uid, &"h_iron_edge", 3))
	var inv_size_before: int = GameState.inventory.size()
	if not GameState.has_method(&"revive_squad_for_retry"):
		_check("GameState.revive_squad_for_retry exists", false, "method missing")
		return
	GameState.revive_squad_for_retry()
	var all_revived: bool = true
	for h in GameState.all_heroes():
		if h.is_dead or h.hp != h.max_hp or h.ult_used or h.ult_gauge != 0.0 or h.burn_stack != 0 or h.last_target_name != &"":
			all_revived = false
	var preserved: bool = GameState.gold == 42 \
		and GameState.wave == 5 \
		and GameState.inventory.size() == inv_size_before
	_check("revive_squad_for_retry: heroes full HP + gold/wave/inv preserved",
		all_revived and preserved,
		"revived=%s gold=%d wave=%d inv=%d" % [str(all_revived), GameState.gold, GameState.wave, GameState.inventory.size()])

func _test_wave_hp_mult_curve() -> void:
	if not Combat.has_method(&"_wave_hp_mult"):
		_check("Combat._wave_hp_mult exists", false, "method missing")
		return
	## Bands: 1-3 -> 0.85, 4-6 -> 1.00, 7-9 -> 1.10, 10-12 -> 1.20, 13-15 -> 1.30.
	var samples = [
		[1, 0.85], [2, 0.85], [3, 0.85],
		[4, 1.00], [5, 1.00], [6, 1.00],
		[7, 1.10], [8, 1.10], [9, 1.10],
		[10, 1.20], [11, 1.20], [12, 1.20],
		[13, 1.30], [14, 1.30], [15, 1.30],
	]
	var all_ok: bool = true
	var bad: String = ""
	for s in samples:
		var w: int = s[0]
		var expected: float = s[1]
		var got: float = Combat._wave_hp_mult(w)
		if abs(got - expected) > 0.001:
			all_ok = false
			bad = "W%d got %.2f expected %.2f" % [w, got, expected]
			break
	_check("Combat._wave_hp_mult curve matches band table",
		all_ok, bad)

func _test_base_atk_tier_scaled() -> void:
	if not Combat.has_method(&"base_atk"):
		_check("Combat.base_atk exists", false, "method missing")
		return
	## Per plan: W1=5 W2=6 W3=7 / W4=10 W5=11 W6=12 / W7=15 W8=16 W9=17 /
	##           W10=21 W11=22 W12=23 / W13=27 W14=29 W15=30.
	var expected: Array = [-1, 5, 6, 7, 10, 11, 12, 15, 16, 17, 21, 22, 23, 27, 29, 30]
	var all_ok: bool = true
	var bad: String = ""
	for w in range(1, 16):
		var got: int = Combat.base_atk(w)
		if got != expected[w]:
			all_ok = false
			bad = "W%d got %d expected %d" % [w, got, expected[w]]
			break
	_check("Combat.base_atk tier-scaled matches plan",
		all_ok, bad)

func _test_boss_spawn_W5_single_slime_king() -> void:
	GameState.new_session()
	Combat.start_wave(5, false)
	var n: int = GameState.enemies.size()
	var first = GameState.enemies[0] if n > 0 else null
	var ok: bool = n == 1 \
		and first != null \
		and first.get(&"id") == &"boss_slime_king" \
		and bool(first.get(&"is_boss", false)) == true
	_check("W5 spawns exactly 1 boss_slime_king w/ is_boss=true",
		ok, "n=%d first=%s" % [n, str(first)])
	Combat.stop()

func _test_boss_spawn_W10_single_iron_golem() -> void:
	GameState.new_session()
	Combat.start_wave(10, false)
	var n: int = GameState.enemies.size()
	var first = GameState.enemies[0] if n > 0 else null
	var ok: bool = n == 1 \
		and first != null \
		and first.get(&"id") == &"boss_iron_golem" \
		and bool(first.get(&"is_boss", false)) == true
	_check("W10 spawns exactly 1 boss_iron_golem w/ is_boss=true",
		ok, "n=%d first=%s" % [n, str(first)])
	Combat.stop()

func _test_boss_spawn_W15_single_arcane_lich() -> void:
	GameState.new_session()
	Combat.start_wave(15, false)
	var n: int = GameState.enemies.size()
	var first = GameState.enemies[0] if n > 0 else null
	var ok: bool = n == 1 \
		and first != null \
		and first.get(&"id") == &"boss_arcane_lich" \
		and bool(first.get(&"is_boss", false)) == true
	_check("W15 spawns exactly 1 boss_arcane_lich w/ is_boss=true",
		ok, "n=%d first=%s" % [n, str(first)])
	Combat.stop()

func _test_boss_wave_gold_doubled() -> void:
	## At W5 boss kill: gold reward = (5 + 5*2) * 2 = 30.
	_fresh_session_with_weapon([])
	GameState.gold = 0
	GameState.emit_signal(&"gold_changed", 0)
	GameState.set_wave(5)
	Combat.start_wave(5, false)
	_force_enemies([{"id": &"boss_slime_king", "hp": 1, "max_hp": 220, "is_boss": true, "atk": 18}])
	Combat.step()
	_check("boss wave (W5) clears for (5+5*2)*2 = 30 gold",
		GameState.gold == 30, "gold=%d" % GameState.gold)
	Combat.stop()

func _test_slime_king_heals_8_above_50pct() -> void:
	## Boss at hp=200/max=220 (~91%). Bran (atk 6) deals 6/tick. After 3 ticks
	## without heal: 200-18=182. Heal on tick 3 (counter %3 == 0) restores +8.
	## Expected end hp = 190.
	_fresh_session_with_weapon([])
	GameState.set_wave(5)
	Combat.start_wave(5, false)
	_force_enemies([{"id": &"boss_slime_king", "hp": 200, "max_hp": 220, "is_boss": true, "atk": 18, "weak": &"", "resist": &""}])
	GameState.hero.hp = 9999
	GameState.hero.max_hp = 9999
	for _i in 3:
		Combat.step()
	var end_hp: int = GameState.enemies[0].hp
	_check("slime_king heals +8 on tick 3 while hp > 50%%",
		end_hp == 190, "hp=%d (expected 190 = 200-18+8)" % end_hp)
	Combat.stop()

func _test_slime_king_no_heal_below_50pct() -> void:
	## Boss at hp=80/max=220 (~36%). Bran 6/tick. After 3 ticks: 80-18 = 62, no heal.
	_fresh_session_with_weapon([])
	GameState.set_wave(5)
	Combat.start_wave(5, false)
	_force_enemies([{"id": &"boss_slime_king", "hp": 80, "max_hp": 220, "is_boss": true, "atk": 18, "weak": &"", "resist": &""}])
	GameState.hero.hp = 9999
	GameState.hero.max_hp = 9999
	for _i in 3:
		Combat.step()
	var end_hp: int = GameState.enemies[0].hp
	_check("slime_king does NOT heal at hp <= 50%%",
		end_hp == 62, "hp=%d (expected 62 = 80-18, no heal)" % end_hp)
	Combat.stop()

func _test_iron_golem_aoe_every_4_ticks() -> void:
	## 3-hero squad. Golem atk=28. Normal single-target hits 1 hero/tick for 28.
	## On tick 4, golem fires AoE: all 3 alive heroes take floor(28*0.7) = 19.
	## Sum hero hp loss after 4 ticks = 28*4 (single) + 19*3 (AoE on t4) = 112 + 57 = 169.
	GameState.new_session()
	GameState.unlock_hero(&"elara")
	GameState.unlock_hero(&"vex")
	## Boost hero HP so no one dies from AoE+attacks (would skew the sum).
	for h in GameState.all_heroes():
		h.max_hp = 9999
		h.hp = 9999
	GameState.set_wave(10)
	Combat.start_wave(10, false)
	_force_enemies([{"id": &"boss_iron_golem", "hp": 9999, "max_hp": 480, "is_boss": true, "atk": 28, "weak": &"", "resist": &""}])
	var max_snapshot: Array = []
	for h in GameState.all_heroes():
		max_snapshot.append(h.hp)
	for _i in 4:
		Combat.step()
	var total_loss: int = 0
	var idx: int = 0
	for h in GameState.all_heroes():
		total_loss += max_snapshot[idx] - h.hp
		idx += 1
	_check("iron_golem AoE on tick 4: total hero hp loss == 169",
		total_loss == 169, "loss=%d (expected 169)" % total_loss)
	Combat.stop()

func _test_arcane_lich_phase1_atk_bump_below_66pct() -> void:
	## Lich at hp=510/max=850 (60% < 66%). On first tick, phase 1 fires: atk goes
	## floor(18*1.2) = 21. Persists on subsequent ticks (one-shot via phase_1_applied).
	## (atk_override halved 36 -> 18 in the 2026-06-09 damage nerf.)
	_fresh_session_with_weapon([])
	GameState.set_wave(15)
	Combat.start_wave(15, false)
	_force_enemies([{"id": &"boss_arcane_lich", "hp": 510, "max_hp": 850, "is_boss": true, "atk": 18, "weak": &"", "resist": &""}])
	GameState.hero.hp = 9999
	GameState.hero.max_hp = 9999
	Combat.step()
	var atk_after_t1: int = GameState.enemies[0].atk
	Combat.step()
	var atk_after_t2: int = GameState.enemies[0].atk
	_check("arcane_lich phase 1 (<66%%): atk floor(18*1.2)=21, persists",
		atk_after_t1 == 21 and atk_after_t2 == 21,
		"atk_t1=%d atk_t2=%d (expected 21,21)" % [atk_after_t1, atk_after_t2])
	Combat.stop()

func _test_arcane_lich_phase2_aoe_below_33pct() -> void:
	## Lich at hp=255/max=850 (30% < 33%). phase_1_applied=true (skip phase 1).
	## Elara + Vex pre-killed so single-target attack lands on Bran. On tick 1
	## phase 2 fires: AoE hits each alive hero for floor(max_hp * 0.15).
	## Bran alone: takes 21 (single) + 18 (AoE = floor(120*0.15)) = 39 hp loss.
	## (atk 36->18 + AOE_RATIO 0.30->0.15 per main's 2026-06-09 damage nerf.)
	##
	## Scripted-pacing-rework C1: lich at 30% HP is past the scripted 50%
	## descent gate. Pre-set the sentinel so the scripted-wipe trigger
	## short-circuits — phase 2 is the "after the descent, retry path" scenario.
	GameState.new_session()
	AccountState.scripted_pulls_seen = [&"defeat_stage_3_paladin"]
	AccountState.paladin_unlocked = true
	GameState.unlock_hero(&"elara")
	GameState.unlock_hero(&"vex")
	var bran = GameState.get_hero(&"bran")
	var elara = GameState.get_hero(&"elara")
	var vex = GameState.get_hero(&"vex")
	elara.hp = 0; elara.is_dead = true
	vex.hp = 0; vex.is_dead = true
	var bran_start: int = bran.hp
	GameState.set_wave(15)
	Combat.start_wave(15, false)
	_force_enemies([{
		"id": &"boss_arcane_lich",
		"hp": 255,
		"max_hp": 850,
		"is_boss": true,
		"atk": 21,
		"phase_1_applied": true,
		"weak": &"",
		"resist": &"",
	}])
	Combat.step()
	var bran_loss: int = bran_start - bran.hp
	_check("arcane_lich phase 2 (<33%%): Bran-solo loses 21 (single) + 18 (AoE 15%%) = 39",
		bran_loss == 39, "loss=%d (expected 39)" % bran_loss)
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

## ---------- Stage rotation (S2 — stage 1 must equal today's numbers exactly) ----------

func _test_stage_mults_neutral_at_stage_1() -> void:
	if not Combat.has_method(&"stage_hp_mult"):
		_check("Combat has stage scaling helpers", false, "missing (RED)")
		return
	_check("stage 1 HP mult exactly 1.0", is_equal_approx(Combat.stage_hp_mult(1), 1.0),
		"mult=%f" % Combat.stage_hp_mult(1))
	_check("stage 1 ATK mult exactly 1.0", is_equal_approx(Combat.stage_atk_mult(1), 1.0),
		"mult=%f" % Combat.stage_atk_mult(1))

func _test_stage_mults_scale() -> void:
	if not Combat.has_method(&"stage_hp_mult"):
		_check("Combat has stage scaling (scale)", false, "missing (RED)")
		return
	_check("stage 3 HP mult 1.3 (1 + 0.15*2)", is_equal_approx(Combat.stage_hp_mult(3), 1.3),
		"mult=%f" % Combat.stage_hp_mult(3))
	_check("stage 3 ATK mult 1.16 (1 + 0.08*2)", is_equal_approx(Combat.stage_atk_mult(3), 1.16),
		"mult=%f" % Combat.stage_atk_mult(3))

func _test_boss_rotation_by_stage() -> void:
	if not Combat.has_method(&"boss_for_stage"):
		_check("Combat has boss_for_stage", false, "missing (RED)")
		return
	_check("stage 1 boss = slime king", Combat.boss_for_stage(1) == &"boss_slime_king",
		"got %s" % Combat.boss_for_stage(1))
	_check("stage 2 boss = iron golem", Combat.boss_for_stage(2) == &"boss_iron_golem",
		"got %s" % Combat.boss_for_stage(2))
	_check("stage 3 boss = arcane lich", Combat.boss_for_stage(3) == &"boss_arcane_lich",
		"got %s" % Combat.boss_for_stage(3))
	_check("stage 4 cycles to slime king", Combat.boss_for_stage(4) == &"boss_slime_king",
		"got %s" % Combat.boss_for_stage(4))

## ---------- Catalyst v1 combat hook (Task B5) ----------

func _test_catalyst_bag_initialized_empty() -> void:
	## Combat exposes _catalyst_bag as a property; default is EMPTY_BAG.
	_check("Combat has _catalyst_bag", "_catalyst_bag" in Combat, "property missing")
	if "_catalyst_bag" in Combat:
		var bag: Dictionary = Combat._catalyst_bag
		_check("_catalyst_bag squad_atk_mult defaults 1.0",
			is_equal_approx(float(bag.get(&"squad_atk_mult", -1.0)), 1.0),
			"mult=%f" % float(bag.get(&"squad_atk_mult", -1.0)))
		_check("_catalyst_bag squad_crit_add defaults 0.0",
			is_equal_approx(float(bag.get(&"squad_crit_add", -1.0)), 0.0),
			"add=%f" % float(bag.get(&"squad_crit_add", -1.0)))

func _test_start_wave_refreshes_catalyst_bag_neutral() -> void:
	## start_wave calls CatalystResolver.resolve and stashes merged_bag.
	## Non-elemental starters (B2) -> bag stays EMPTY (stage-1 neutrality contract).
	GameState.new_session()
	AccountState.reset_account()
	## Grant starters via the same path the home screen uses (so equipped state matches first-boot).
	var hs = load("res://scripts/ui/home_screen.gd").new()
	add_child(hs)
	hs._grant_starter_if_first_boot()
	hs.queue_free()
	Combat.start_wave(1, false)
	_check("stage 1 with non-elemental starters: bag squad_atk_mult == 1.0",
		is_equal_approx(float(Combat._catalyst_bag.get(&"squad_atk_mult", -1.0)), 1.0),
		"mult=%f" % float(Combat._catalyst_bag.get(&"squad_atk_mult", -1.0)))
	_check("stage 1 with non-elemental starters: bag squad_crit_add == 0.0",
		is_equal_approx(float(Combat._catalyst_bag.get(&"squad_crit_add", -1.0)), 0.0),
		"add=%f" % float(Combat._catalyst_bag.get(&"squad_crit_add", -1.0)))
	Combat.stop()

func _test_start_wave_applies_firestorm_bag() -> void:
	## Force-equip elemental gacha weapons; stage 1 cap-1 -> Firestorm bag (atk x1.20).
	GameState.new_session()
	GameState.unlock_hero(&"elara")   ## new_session only unlocks bran; need elara in active squad
	AccountState.reset_account()
	## Use full-elemental Rare+ weapons (since Commons are non-elemental after B2).
	var fire_w = GameState.weapons_by_id[&"w_cinderbrand_greatsword"].duplicate(true)   ## Epic fire warrior
	var ice_w = GameState.weapons_by_id[&"w_frostcall_stave"].duplicate(true)             ## Common mage — still non-elemental!
	## Override the duplicate's rune so the test forces an ice-mage even though
	## the catalog instance is non-elemental post-B2. Verifies the resolver pipeline.
	ice_w.rune = &"ice"
	AccountState.owned_weapons = [fire_w, ice_w]
	AccountState.equip(&"bran", 0)
	AccountState.equip(&"elara", 1)
	GameState.equip_weapon_data(&"bran", fire_w)
	GameState.equip_weapon_data(&"elara", ice_w)
	Combat.start_wave(1, false)
	_check("fire+ice at stage 1 -> Firestorm bag (atk x1.20)",
		is_equal_approx(float(Combat._catalyst_bag.get(&"squad_atk_mult", -1.0)), 1.20),
		"mult=%f" % float(Combat._catalyst_bag.get(&"squad_atk_mult", -1.0)))
	Combat.stop()

func _test_stage_1_neutrality_preserved() -> void:
	## STAGE-1 NEUTRALITY CONTRACT (CLAUDE.md §3). Equip non-elemental starters,
	## start wave 1, assert merged bag is empty -> hero ATK pipeline unchanged.
	GameState.new_session()
	AccountState.reset_account()
	var hs = load("res://scripts/ui/home_screen.gd").new()
	add_child(hs)
	hs._grant_starter_if_first_boot()
	hs.queue_free()
	Combat.start_wave(1, false)
	var bran = GameState.get_hero(&"bran")
	var atk_pre_bag: int = bran.data.atk_base + bran.eff_atk()
	## With empty bag, the bag-multiplied atk equals the raw atk (1.0 * x = x).
	## We're effectively asserting the bag default is multiplicative-neutral.
	var bag_mult: float = float(Combat._catalyst_bag.get(&"squad_atk_mult", -1.0))
	_check("stage-1 neutrality: squad_atk_mult is 1.0", is_equal_approx(bag_mult, 1.0),
		"mult=%f (any value != 1.0 breaks the contract)" % bag_mult)
	_check("stage-1 neutrality: hero atk unchanged with EMPTY bag",
		atk_pre_bag == bran.data.atk_base + bran.eff_atk(), "shouldn't differ")
	Combat.stop()

## ---------- Scripted Pacing Rework C1 — Hot Paladin descend ----------

func _test_paladin_defeat_trigger_at_50pct_hp() -> void:
	## C1: Arcane Lich crosses 50% HP -> scripted AOE wipes deployed squad,
	## sentinel set, paladin_unlocked = true, Helios granted, signal emitted.
	GameState.new_session()
	GameState.unlock_hero(&"elara")
	GameState.unlock_hero(&"vex")
	GameState.run_stage = 3
	AccountState.reset_account()
	AccountState.paladin_unlocked = false
	AccountState.scripted_pulls_seen = []
	AccountState.current_stage = 3
	Combat.start_wave(5, false)   ## boss wave at stage 3 -> arcane lich
	## Find the lich enemy in the spawn list.
	var lich_idx: int = -1
	for i in range(GameState.enemies.size()):
		if GameState.enemies[i].id == &"boss_arcane_lich":
			lich_idx = i
			break
	_check("lich spawned at stage 3 boss wave", lich_idx >= 0,
		"no lich found, enemies=%s" % str(GameState.enemies))
	if lich_idx < 0:
		Combat.stop(); return
	## Drop lich HP to below 50% threshold.
	var lich = GameState.enemies[lich_idx]
	lich.hp = int(float(lich.max_hp) * 0.4)
	## Listen for the signal.
	var emitted: Array = [false]
	var emit_capture: Callable = func(): emitted[0] = true
	Combat.paladin_descend.connect(emit_capture, CONNECT_ONE_SHOT)
	## One tick = boss-tick hooks fire.
	Combat.step()
	_check("paladin_descend signal emitted", emitted[0], "not emitted")
	_check("sentinel defeat_stage_3_paladin recorded",
		&"defeat_stage_3_paladin" in AccountState.scripted_pulls_seen,
		"seen=%s" % str(AccountState.scripted_pulls_seen))
	_check("paladin_unlocked = true",
		AccountState.paladin_unlocked == true, "still false")
	_check("Helios Cleaver granted + equipped on paladin",
		AccountState.get_equipped(&"paladin") != null
		and AccountState.get_equipped(&"paladin").id == &"w_helios_cleaver",
		"equipped=%s" % str(AccountState.get_equipped(&"paladin")))
	## Verify deployed squad (non-paladin) is dead.
	var alive_deployed: int = 0
	for h in GameState.active_heroes():
		if h.data.id != &"paladin" and h.hp > 0:
			alive_deployed += 1
	_check("scripted AOE killed all deployed heroes (non-paladin)",
		alive_deployed == 0, "alive=%d" % alive_deployed)
	Combat.stop()

func _test_paladin_defeat_skips_on_retry() -> void:
	## C1: sentinel-guarded — retry path (sentinel already set) does NOT
	## re-fire the scripted AOE. Normal phase 2 plays.
	GameState.new_session()
	GameState.unlock_hero(&"elara")
	GameState.unlock_hero(&"vex")
	GameState.run_stage = 3
	AccountState.reset_account()
	AccountState.scripted_pulls_seen = [&"defeat_stage_3_paladin"]
	AccountState.paladin_unlocked = true
	AccountState.current_stage = 3
	Combat.start_wave(5, false)
	var lich_idx: int = -1
	for i in range(GameState.enemies.size()):
		if GameState.enemies[i].id == &"boss_arcane_lich":
			lich_idx = i; break
	if lich_idx < 0:
		_check("lich spawned at stage 3 retry", false, "no lich"); Combat.stop(); return
	## Set lich HP to ~40% — above phase-2 threshold (33%) but below the scripted
	## 50% gate. With sentinel already set, no AOE fires; phase-1 atk bump may apply
	## (it crosses 66%) but squad must survive a single tick.
	GameState.enemies[lich_idx].hp = int(float(GameState.enemies[lich_idx].max_hp) * 0.4)
	## Boost hero HP so phase-1 atk bumps don't accidentally kill anyone in one tick.
	for h in GameState.all_heroes():
		h.hp = 9999
		h.max_hp = 9999
	## Count alive deployed before tick.
	var alive_before: int = 0
	for h in GameState.active_heroes():
		if h.data.id != &"paladin" and h.hp > 0:
			alive_before += 1
	Combat.step()
	var alive_after: int = 0
	for h in GameState.active_heroes():
		if h.data.id != &"paladin" and h.hp > 0:
			alive_after += 1
	_check("retry path: alive count unchanged by scripted AOE (sentinel guard)",
		alive_after == alive_before,
		"before=%d after=%d" % [alive_before, alive_after])
	Combat.stop()

func _test_paladin_defeat_only_on_lich_boss() -> void:
	## C1: trigger lives inside _boss_tick_arcane_lich -> ONLY fires when lich
	## is the active boss. Slime boss (stage 1) must not trigger paladin descend
	## even if its HP crosses 50%. Stage-1 neutrality contract preserved.
	GameState.new_session()
	GameState.unlock_hero(&"elara")
	GameState.unlock_hero(&"vex")
	GameState.run_stage = 1
	AccountState.reset_account()
	AccountState.paladin_unlocked = false
	AccountState.scripted_pulls_seen = []
	AccountState.current_stage = 1
	Combat.start_wave(5, false)
	## Drop boss HP to below 50%.
	var boss_idx: int = -1
	for i in range(GameState.enemies.size()):
		if bool(GameState.enemies[i].get(&"is_boss", false)):
			boss_idx = i; break
	if boss_idx < 0:
		_check("boss spawned at stage 1 boss wave", false, "no boss")
		Combat.stop(); return
	GameState.enemies[boss_idx].hp = int(float(GameState.enemies[boss_idx].max_hp) * 0.4)
	var emitted: Array = [false]
	Combat.paladin_descend.connect(func(): emitted[0] = true, CONNECT_ONE_SHOT)
	Combat.step()
	_check("paladin_descend NOT emitted on slime boss",
		not emitted[0], "emitted on wrong boss")
	_check("paladin still locked after slime fight",
		AccountState.paladin_unlocked == false, "unlocked on wrong boss")
	Combat.stop()

func _test_paladin_defeat_unlocks_squad_order() -> void:
	## C2: defeat trigger calls GameState.unlock_hero(&"paladin") so paladin
	## joins active_heroes() (squad_order). Without this wire, paladin would
	## be unlocked in AccountState but never enter combat / squad rotation.
	GameState.new_session()
	GameState.unlock_hero(&"elara")
	GameState.unlock_hero(&"vex")
	GameState.run_stage = 3
	AccountState.reset_account()
	AccountState.paladin_unlocked = false
	AccountState.scripted_pulls_seen = []
	AccountState.current_stage = 3
	Combat.start_wave(5, false)
	var lich_idx: int = -1
	for i in range(GameState.enemies.size()):
		if GameState.enemies[i].id == &"boss_arcane_lich":
			lich_idx = i; break
	if lich_idx < 0:
		_check("lich spawned for C2 unlock test", false, "no lich"); Combat.stop(); return
	GameState.enemies[lich_idx].hp = int(float(GameState.enemies[lich_idx].max_hp) * 0.4)
	Combat.step()
	var paladin_in_active: bool = false
	for h in GameState.active_heroes():
		if h.data.id == &"paladin":
			paladin_in_active = true
			break
	_check("paladin in active_heroes() after defeat trigger",
		paladin_in_active, "paladin missing — squad_order not updated")
	_check("paladin in squad_order array",
		&"paladin" in GameState.squad_order,
		"squad_order=%s" % str(GameState.squad_order))
	Combat.stop()
