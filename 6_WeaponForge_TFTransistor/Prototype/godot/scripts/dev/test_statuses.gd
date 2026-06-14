## Tests for StatusData resources — step 4.
extends Control

const _StatusScript = preload("res://scripts/core/status_data.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== StatusData tests ===")
	_test_load_all()
	_test_aux_statuses()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_load_all() -> void:
	## id -> {max_stacks, base_duration, hp_dmg, speed_mult, dmg_amp, skip_chance}
	var specs := {
		"burning":  [1, 3, 2,   1.0,  0.0,  0.0],
		"wet":      [1, 4, 0,   1.0,  0.0,  0.0],
		"shocked":  [1, 2, 1,   1.0,  0.0,  0.1],
		"chilled":  [1, 3, 0,   0.5,  0.0,  0.0],
		"cracked":  [3, 4, 0,   1.0,  0.15, 0.0],
	}
	for fname in specs:
		var path := "res://data/statuses/%s.tres" % fname
		var res = load(path)
		_check("%s loads" % fname, res != null and res.get_script() == _StatusScript, "path=%s" % path)
		if res == null or res.get_script() != _StatusScript:
			continue
		var s: Array = specs[fname]
		_check("%s max_stacks %d" % [fname, s[0]], res.max_stacks == s[0], "got %d" % res.max_stacks)
		_check("%s base_duration %d" % [fname, s[1]], res.base_duration == s[1], "got %d" % res.base_duration)
		_check("%s hp_dmg %d" % [fname, s[2]], res.hp_dmg_per_tick == s[2], "got %d" % res.hp_dmg_per_tick)
		_check("%s speed_mult" % fname, is_equal_approx(res.speed_mult, s[3]), "got %f" % res.speed_mult)
		_check("%s dmg_amp" % fname, is_equal_approx(res.dmg_amp_per_stack, s[4]), "got %f" % res.dmg_amp_per_stack)
		_check("%s skip_chance" % fname, is_equal_approx(res.skip_attack_chance, s[5]), "got %f" % res.skip_attack_chance)

## Auxiliary reaction-only statuses (spec §5): Blind, Frozen, Bleed.
func _test_aux_statuses() -> void:
	var blind = load("res://data/statuses/blind.tres")
	_check("blind loads", blind != null and blind.get_script() == _StatusScript, "")
	if blind != null:
		_check("blind duration 1", blind.base_duration == 1, "got %d" % blind.base_duration)
		_check("blind forces miss (skip 1.0)", is_equal_approx(blind.skip_attack_chance, 1.0), "got %f" % blind.skip_attack_chance)

	var frozen = load("res://data/statuses/frozen.tres")
	_check("frozen loads", frozen != null and frozen.get_script() == _StatusScript, "")
	if frozen != null:
		_check("frozen duration 1", frozen.base_duration == 1, "got %d" % frozen.base_duration)
		_check("frozen halts advance (speed 0)", is_equal_approx(frozen.speed_mult, 0.0), "got %f" % frozen.speed_mult)
		_check("frozen skips attack (1.0)", is_equal_approx(frozen.skip_attack_chance, 1.0), "got %f" % frozen.skip_attack_chance)

	var bleed = load("res://data/statuses/bleed.tres")
	_check("bleed loads", bleed != null and bleed.get_script() == _StatusScript, "")
	if bleed != null:
		_check("bleed duration 4", bleed.base_duration == 4, "got %d" % bleed.base_duration)
		_check("bleed 5%% maxHP/tick", is_equal_approx(bleed.hp_dmg_pct_per_tick, 0.05), "got %f" % bleed.hp_dmg_pct_per_tick)

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
