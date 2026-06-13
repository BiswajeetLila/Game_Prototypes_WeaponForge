## Tests for FunctionData resources — step 3.
extends Control

const _FnScript = preload("res://scripts/core/function_data.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== FunctionData tests ===")
	_test_load_all()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_load_all() -> void:
	var specs := {
		"FIRE":      {"category": &"element", "tag": &"FIRE",      "status": &"Burning", "dmg": 1.0, "target": &"own_lane_closest"},
		"WATER":     {"category": &"element", "tag": &"WATER",     "status": &"Wet",     "dmg": 0.5, "target": &"cross_lane_spread"},
		"LIGHTNING": {"category": &"element", "tag": &"LIGHTNING", "status": &"Shocked", "dmg": 1.0, "target": &"chain_arc"},
		"AOE":       {"category": &"pattern", "tag": &"",          "status": &"",        "dmg": 0.7, "target": &"radial_5"},
		"LEECH":     {"category": &"tactical","tag": &"",          "status": &"",        "dmg": 0.6, "target": &"own_lane_closest"},
		"BURST":     {"category": &"pattern", "tag": &"",          "status": &"",        "dmg": 0.45,"target": &"fan_3"},
	}
	for fn_id in specs:
		var path := "res://data/functions/%s.tres" % fn_id.to_lower()
		var res = load(path)
		_check("%s .tres loads" % fn_id, res != null and res.get_script() == _FnScript, "path=%s" % path)
		if res == null or res.get_script() != _FnScript:
			continue
		var spec: Dictionary = specs[fn_id]
		_check("%s id" % fn_id, res.id == StringName(fn_id), "got %s" % res.id)
		_check("%s category" % fn_id, res.category == spec.category, "got %s" % res.category)
		_check("%s active_damage_tag" % fn_id, res.active_damage_tag == spec.tag, "got %s" % res.active_damage_tag)
		_check("%s active_status_emit" % fn_id, res.active_status_emit == spec.status, "got %s" % res.active_status_emit)
		_check("%s active_dmg_mult" % fn_id, is_equal_approx(res.active_dmg_mult, spec.dmg), "got %f" % res.active_dmg_mult)
		_check("%s active_targeting" % fn_id, res.active_targeting == spec.target, "got %s" % res.active_targeting)

	## Spot-check specific fields
	var fire = load("res://data/functions/fire.tres")
	_check("FIRE mod_adds_tag = FIRE", fire != null and fire.mod_adds_tag == &"FIRE", "")
	var water = load("res://data/functions/water.tres")
	_check("WATER passive tidepool", water != null and water.passive_id == &"tidepool", "")
	var leech = load("res://data/functions/leech.tres")
	_check("LEECH heal_pct 0.5", leech != null and is_equal_approx(leech.active_heal_pct, 0.5), "")

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
