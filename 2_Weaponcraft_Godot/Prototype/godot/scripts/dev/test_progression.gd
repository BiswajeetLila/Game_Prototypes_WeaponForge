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
