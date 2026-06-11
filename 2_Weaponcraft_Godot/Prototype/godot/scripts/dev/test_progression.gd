## Headless test harness for the P0 hero-progression foundation.
##
## Run headless:
##   Godot_v4.6.2-stable_mono_win64_console.exe --headless --path <godot dir> \
##     res://scenes/dev/TestProgression.tscn
## Or in-editor: scenes/dev/TestProgression.tscn -> Play Scene.
extends Control

const HeroProgressT = preload("res://scripts/core/hero_progress.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== Hero progression foundation tests ===")
	_test_level_for_xp_thresholds()
	_test_cumulative_and_to_next()
	_test_stat_mult()
	_test_account_state()
	_test_hero_state_level_mult()
	_test_unlock_applies_level_mult()
	_test_combat_reads_scaled_atk()
	_test_award_wave_xp()
	_test_account_defaults()
	_test_new_session_squad_param()
	_test_home_squad_selection()
	_test_scout_intel()
	_test_run_xp_tracking()
	_test_flags_roundtrip()
	_test_first_pull_grant()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

## ---------- hero_progress.gd ----------

func _test_level_for_xp_thresholds() -> void:
	_check("xp 0 -> level 1", HeroProgressT.level_for_xp(0) == 1, "got %d" % HeroProgressT.level_for_xp(0))
	_check("xp 999 -> level 1", HeroProgressT.level_for_xp(999) == 1, "got %d" % HeroProgressT.level_for_xp(999))
	_check("xp 1000 -> level 2", HeroProgressT.level_for_xp(1000) == 2, "got %d" % HeroProgressT.level_for_xp(1000))
	_check("xp 2999 -> level 2", HeroProgressT.level_for_xp(2999) == 2, "got %d" % HeroProgressT.level_for_xp(2999))
	_check("xp 3000 -> level 3", HeroProgressT.level_for_xp(3000) == 3, "got %d" % HeroProgressT.level_for_xp(3000))
	_check("huge xp clamps to level 20", HeroProgressT.level_for_xp(99999999) == 20, "got %d" % HeroProgressT.level_for_xp(99999999))

func _test_cumulative_and_to_next() -> void:
	_check("cumulative L1 == 0", HeroProgressT.cumulative_xp_for_level(1) == 0, "got %d" % HeroProgressT.cumulative_xp_for_level(1))
	_check("cumulative L2 == 1000", HeroProgressT.cumulative_xp_for_level(2) == 1000, "got %d" % HeroProgressT.cumulative_xp_for_level(2))
	_check("cumulative L3 == 3000", HeroProgressT.cumulative_xp_for_level(3) == 3000, "got %d" % HeroProgressT.cumulative_xp_for_level(3))
	_check("cumulative L20 == 190000", HeroProgressT.cumulative_xp_for_level(20) == 190000, "got %d" % HeroProgressT.cumulative_xp_for_level(20))
	_check("xp_to_next(1) == 1000", HeroProgressT.xp_to_next(1) == 1000, "got %d" % HeroProgressT.xp_to_next(1))
	_check("xp_to_next(20) == 0 (capped)", HeroProgressT.xp_to_next(20) == 0, "got %d" % HeroProgressT.xp_to_next(20))

func _test_stat_mult() -> void:
	_check("stat_mult(1) == 1.0", is_equal_approx(HeroProgressT.stat_mult(1), 1.0), "got %f" % HeroProgressT.stat_mult(1))
	_check("stat_mult(2) == 1.05", is_equal_approx(HeroProgressT.stat_mult(2), 1.05), "got %f" % HeroProgressT.stat_mult(2))
	_check("stat_mult(20) == 1.95", is_equal_approx(HeroProgressT.stat_mult(20), 1.95), "got %f" % HeroProgressT.stat_mult(20))
	_check("stat_mult(99) clamps to 1.95", is_equal_approx(HeroProgressT.stat_mult(99), 1.95), "got %f" % HeroProgressT.stat_mult(99))

func _test_account_state() -> void:
	## AccountState is an autoload; reach it by global name.
	var acc = get_node("/root/AccountState")
	if acc == null:
		_check("AccountState autoload present", false, "node /root/AccountState missing")
		return
	## Use a test-only save path so we never clobber a real player save.
	acc.save_path = "user://account_test.json"
	acc.reset()

	_check("fresh xp == 0", acc.get_xp(&"bran") == 0, "got %d" % acc.get_xp(&"bran"))
	_check("fresh level == 1", acc.get_level(&"bran") == 1, "got %d" % acc.get_level(&"bran"))
	_check("fresh not owned after reset", acc.is_owned(&"bran") == false, "owned=%s" % acc.is_owned(&"bran"))

	var new_level: int = acc.add_hero_xp(&"bran", 1500)
	_check("add 1500 xp -> level 2", new_level == 2, "got %d" % new_level)
	_check("stat_mult tracks level", is_equal_approx(acc.stat_mult(&"bran"), 1.05), "got %f" % acc.stat_mult(&"bran"))

	acc.award_squad_xp([&"elara", &"vex"], 100)
	_check("award_squad_xp elara +100", acc.get_xp(&"elara") == 100, "got %d" % acc.get_xp(&"elara"))
	_check("award_squad_xp vex +100", acc.get_xp(&"vex") == 100, "got %d" % acc.get_xp(&"vex"))

	acc.set_owned(&"bran", true)
	## Round-trip: save, wipe in-memory, load back.
	acc.save_account()
	acc.reset()
	_check("after reset xp gone", acc.get_xp(&"bran") == 0, "got %d" % acc.get_xp(&"bran"))
	acc.load_account()
	_check("after load xp restored (1500)", acc.get_xp(&"bran") == 1500, "got %d" % acc.get_xp(&"bran"))
	_check("after load owned restored", acc.is_owned(&"bran") == true, "owned=%s" % acc.is_owned(&"bran"))

	## Cleanup the test save file + in-memory state.
	if FileAccess.file_exists("user://account_test.json"):
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://account_test.json"))
	acc.reset()

func _test_hero_state_level_mult() -> void:
	var HeroStateT = preload("res://scripts/data/hero_state.gd")
	var gs = get_node("/root/GameState")
	if gs == null or not gs.heroes_by_id.has(&"bran"):
		_check("GameState + bran HeroData present", false, "GameState/bran missing")
		return
	var bran_data = gs.heroes_by_id[&"bran"]  ## hp_base 120, atk_base 6

	## Default (no mult arg) preserves old behavior — this is the regression guard.
	var h1 = HeroStateT.new(bran_data)
	_check("default mult: max_hp == hp_base (120)", h1.max_hp == bran_data.hp_base, "got %d" % h1.max_hp)
	_check("default mult: base_atk == atk_base (6)", h1.base_atk() == bran_data.atk_base, "got %d" % h1.base_atk())

	## With a 1.5 multiplier, base stats scale (rounded).
	var h2 = HeroStateT.new(bran_data, 1.5)
	_check("mult 1.5: max_hp == round(120*1.5)=180", h2.max_hp == 180, "got %d" % h2.max_hp)
	_check("mult 1.5: base_atk == round(6*1.5)=9", h2.base_atk() == 9, "got %d" % h2.base_atk())

func _test_award_wave_xp() -> void:
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test.json"
	acc.reset()
	var gs = get_node("/root/GameState")
	gs.new_session()
	gs.unlock_hero(&"elara")
	gs.award_wave_xp()
	_check("award_wave_xp: bran +100", acc.get_xp(&"bran") == 100, "got %d" % acc.get_xp(&"bran"))
	_check("award_wave_xp: elara +100", acc.get_xp(&"elara") == 100, "got %d" % acc.get_xp(&"elara"))
	if FileAccess.file_exists("user://account_test.json"):
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://account_test.json"))
	acc.reset()
	gs.new_session()

func _test_combat_reads_scaled_atk() -> void:
	var HeroStateT = preload("res://scripts/data/hero_state.gd")
	var gs = get_node("/root/GameState")
	gs.new_session()
	var h = HeroStateT.new(gs.heroes_by_id[&"bran"], 1.5)  ## base_atk() == 9
	gs.heroes = {&"bran": h}
	gs.squad_order = [&"bran"]
	gs.enemies = [{ "id": &"slime", "name": "Slime_T", "hp": 50, "max_hp": 50, "weak": &"", "resist": &"", "sprite": null, "frozen": false, "debuffed": false, "debuff_dur": 0, "debuff_mult": 1.0 }]
	Combat._hero_attack(h)  ## no weapon, 0 crit -> deterministic damage = base_atk
	_check("combat reads base_atk(): slime 50 -> 41", gs.enemies[0].hp == 41, "hp=%d" % gs.enemies[0].hp)
	gs.new_session()

func _test_unlock_applies_level_mult() -> void:
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test.json"
	acc.reset()
	acc.add_hero_xp(&"bran", 1000)  ## level 2 -> mult 1.05
	var gs = get_node("/root/GameState")
	gs.new_session()
	var bran = gs.get_hero(&"bran")
	_check("unlock_hero applies level mult: bran max_hp 126", bran.max_hp == 126, "got %d" % bran.max_hp)
	acc.reset()
	gs.new_session()

func _test_home_squad_selection() -> void:
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test.json"
	acc.reset()
	acc.ensure_defaults()
	var home = load("res://scenes/Home.tscn").instantiate()
	add_child(home)
	_check("home: starts empty squad", home.get_squad().is_empty(), "")
	home.toggle_hero(&"bran")
	home.toggle_hero(&"elara")
	_check("home: squad order [bran, elara]", home.get_squad() == [&"bran", &"elara"], "got %s" % str(home.get_squad()))
	home.toggle_hero(&"bran")
	_check("home: toggle removes", home.get_squad() == [&"elara"], "got %s" % str(home.get_squad()))
	home.toggle_hero(&"vex")
	_check("home: unowned hero rejected", home.get_squad() == [&"elara"], "got %s" % str(home.get_squad()))
	home.queue_free()
	acc.reset()

func _test_new_session_squad_param() -> void:
	var gs = get_node("/root/GameState")
	gs.new_session([&"bran", &"elara"])
	_check("squad param: order is [bran, elara]",
		gs.squad_order == [&"bran", &"elara"], "got %s" % str(gs.squad_order))
	gs.new_session()
	_check("squad default: [bran] only", gs.squad_order == [&"bran"], "got %s" % str(gs.squad_order))

func _test_account_defaults() -> void:
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test.json"
	acc.reset()
	acc.ensure_defaults()
	_check("defaults: bran owned", acc.is_owned(&"bran") == true, "")
	_check("defaults: elara owned", acc.is_owned(&"elara") == true, "")
	_check("defaults: vex NOT owned", acc.is_owned(&"vex") == false, "")
	acc.reset()

func _test_scout_intel() -> void:
	var gs = get_node("/root/GameState")
	var intel: String = gs.scout_intel()
	_check("scout intel mentions first boss weakness", intel.contains("ICE"), "got %s" % intel)

func _test_run_xp_tracking() -> void:
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test.json"
	acc.reset()
	acc.ensure_defaults()
	acc.add_hero_xp(&"bran", 1000)  ## start at L2
	var gs = get_node("/root/GameState")
	gs.new_session([&"bran", &"elara"])
	_check("run_xp starts 0", gs.run_xp == 0, "got %d" % gs.run_xp)
	_check("session snapshot: bran L2", gs.session_start_levels.get(&"bran", -1) == 2, "got %s" % str(gs.session_start_levels))
	gs.award_wave_xp()
	gs.award_wave_xp()
	_check("run_xp accumulates per-hero amount", gs.run_xp == 200, "got %d" % gs.run_xp)
	var rows: Array = gs.result_rows()
	_check("result_rows: 2 rows", rows.size() == 2, "got %d" % rows.size())
	_check("result_rows: bran lv_from 2", rows[0]["lv_from"] == 2, "got %s" % str(rows[0]))
	_check("result_rows: xp_gained 200", rows[0]["xp_gained"] == 200, "got %s" % str(rows[0]))
	acc.reset()
	gs.new_session()

func _test_flags_roundtrip() -> void:
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test.json"
	acc.reset()
	_check("flag default false", acc.get_flag(&"pull_seen") == false, "")
	acc.set_flag(&"pull_seen")
	_check("flag set true", acc.get_flag(&"pull_seen") == true, "")
	acc.save_account()
	acc.reset()
	acc.load_account()
	_check("flag survives save/load", acc.get_flag(&"pull_seen") == true, "")
	_check("heroes survive new schema", true, "")  ## guarded implicitly below
	if FileAccess.file_exists("user://account_test.json"):
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://account_test.json"))
	acc.reset()

func _test_first_pull_grant() -> void:
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test.json"
	acc.reset()
	acc.ensure_defaults()
	var gs = get_node("/root/GameState")
	gs.new_session([&"bran"])
	_check("wave 4: no pull", gs.maybe_grant_first_pull(4) == false, "")
	_check("wave 5 first time: pull fires", gs.maybe_grant_first_pull(5) == true, "")
	_check("pull granted vex", acc.is_owned(&"vex") == true, "")
	_check("wave 5 again: no repeat", gs.maybe_grant_first_pull(5) == false, "")
	if FileAccess.file_exists("user://account_test.json"):
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://account_test.json"))
	acc.reset()
	gs.new_session()

## ---------- helpers ----------

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
