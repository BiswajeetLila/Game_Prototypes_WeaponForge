## Tests for WaveDirector — step 9.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== WaveDirector tests ===")
	_test_ftue_wave_counts()
	_test_ftue_cinematics()
	_test_ftue_lane_counts()
	_test_post_ftue()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_ftue_wave_counts() -> void:
	var wd = get_node("/root/WaveDirector")
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test_wd.json"
	acc.reset()  ## ftue_complete = false
	wd.reset()

	_check("FTUE stage 0: 1 wave", wd.waves_for_stage(0) == 1, "got %d" % wd.waves_for_stage(0))
	_check("FTUE stage 1: 1 wave", wd.waves_for_stage(1) == 1, "got %d" % wd.waves_for_stage(1))
	_check("FTUE stage 2: 3 waves", wd.waves_for_stage(2) == 3, "got %d" % wd.waves_for_stage(2))
	_check("FTUE stage 3: 3 waves", wd.waves_for_stage(3) == 3, "got %d" % wd.waves_for_stage(3))
	_check("FTUE stage 4: 3 waves", wd.waves_for_stage(4) == 3, "got %d" % wd.waves_for_stage(4))
	## Total FTUE = 1+1+3+3+3 = 11
	var total := 0
	for s in 5:
		total += wd.waves_for_stage(s)
	_check("FTUE total 11 waves", total == 11, "got %d" % total)

func _test_ftue_cinematics() -> void:
	var wd = get_node("/root/WaveDirector")
	_check("F0: no cinematic", wd.cinematic_at_forge(0) == &"", "got %s" % wd.cinematic_at_forge(0))
	_check("F1: no cinematic", wd.cinematic_at_forge(1) == &"", "")
	_check("F2: bran_joins", wd.cinematic_at_forge(2) == &"bran_joins", "got %s" % wd.cinematic_at_forge(2))
	_check("F3: no cinematic", wd.cinematic_at_forge(3) == &"", "")
	_check("F4: vex_joins", wd.cinematic_at_forge(4) == &"vex_joins", "got %s" % wd.cinematic_at_forge(4))
	_check("F5: no cinematic", wd.cinematic_at_forge(5) == &"", "")

func _test_ftue_lane_counts() -> void:
	var wd = get_node("/root/WaveDirector")
	_check("FTUE stage 0: 1 lane", wd.active_lanes_for_stage(0) == 1, "got %d" % wd.active_lanes_for_stage(0))
	_check("FTUE stage 1: 1 lane", wd.active_lanes_for_stage(1) == 1, "got %d" % wd.active_lanes_for_stage(1))
	_check("FTUE stage 2: 2 lanes", wd.active_lanes_for_stage(2) == 2, "got %d" % wd.active_lanes_for_stage(2))
	_check("FTUE stage 3: 2 lanes", wd.active_lanes_for_stage(3) == 2, "got %d" % wd.active_lanes_for_stage(3))
	_check("FTUE stage 4: 3 lanes", wd.active_lanes_for_stage(4) == 3, "got %d" % wd.active_lanes_for_stage(4))

func _test_post_ftue() -> void:
	var wd = get_node("/root/WaveDirector")
	var acc = get_node("/root/AccountState")
	acc.ftue_complete = true
	wd.reset()
	_check("post-FTUE stage 0: 3 waves", wd.waves_for_stage(0) == 3, "got %d" % wd.waves_for_stage(0))
	_check("post-FTUE stage 1: 3 waves", wd.waves_for_stage(1) == 3, "got %d" % wd.waves_for_stage(1))
	_check("post-FTUE F2: no cinematic", wd.cinematic_at_forge(2) == &"", "got %s" % wd.cinematic_at_forge(2))
	_check("post-FTUE F4: no cinematic", wd.cinematic_at_forge(4) == &"", "got %s" % wd.cinematic_at_forge(4))
	_check("post-FTUE stage 0: 3 lanes", wd.active_lanes_for_stage(0) == 3, "got %d" % wd.active_lanes_for_stage(0))
	acc.reset()
	if FileAccess.file_exists("user://account_test_wd.json"):
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://account_test_wd.json"))

func _check(name: String, ok: bool, detail: String) -> void:
	if ok: _passed += 1; _log("  PASS  " + name)
	else: _failed += 1; _log("  FAIL  " + name + (("  [" + detail + "]") if detail != "" else ""))

func _summary() -> void:
	_log("=== %d passed / %d failed ===" % [_passed, _failed])

func _log(line: String) -> void:
	print(line)
	_lines.append(line)

func _render_to_ui() -> void:
	var label := Label.new()
	label.add_theme_font_size_override(&"font_size", 12)
	label.text = "\n".join(_lines)
	label.anchor_right = 1.0; label.anchor_bottom = 1.0
	label.offset_left = 12; label.offset_top = 12
	add_child(label)
