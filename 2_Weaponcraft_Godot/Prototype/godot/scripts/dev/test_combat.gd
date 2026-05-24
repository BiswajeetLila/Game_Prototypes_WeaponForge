## Test harness for scripts/core/combat.gd.
##
## Drives Combat.step() manually (start_wave with auto_tick=false) so we can
## inspect state at every micro-step without waiting on the real-time Timer.
##
## Run: scenes/dev/TestCombat.tscn -> Play Scene (Ctrl+Shift+F5).
extends Control

const InventoryItemT = preload("res://scripts/data/inventory_item.gd")

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
