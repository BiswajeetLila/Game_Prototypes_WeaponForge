## C5 — FunctionData per-slot descriptions + best_fit (decision-1 info backbone).
## describe(slot): 0=PASSIVE, 1=MODIFIER, 2=ACTIVE (C1 convention).
extends Control

const _FN = preload("res://scripts/core/function_data.gd")
const IDS: Array = ["fire", "water", "lightning", "aoe", "leech", "burst"]

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== FunctionData preview-data tests ===")
	for id in IDS:
		var f = load("res://data/functions/%s.tres" % id)
		_check("%s loads as FunctionData" % id, f != null and f.get_script() == _FN, "")
		if f != null:
			_check("%s active_desc non-empty" % id, String(f.active_desc) != "", "")
			_check("%s mod_desc non-empty" % id, String(f.mod_desc) != "", "")
			_check("%s passive_desc non-empty" % id, String(f.passive_desc) != "", "")
			_check("%s best_fit set" % id, f.best_fit != &"", "")
	var fire = load("res://data/functions/fire.tres")
	if fire != null:
		_check("fire active_desc mentions Burning", "Burning" in String(fire.active_desc), "got %s" % fire.active_desc)
		_check("fire best_fit == ACTIVE", fire.best_fit == &"ACTIVE", "got %s" % fire.best_fit)
		_check("describe(0) == passive_desc", fire.describe(0) == fire.passive_desc, "")
		_check("describe(1) == mod_desc", fire.describe(1) == fire.mod_desc, "")
		_check("describe(2) == active_desc", fire.describe(2) == fire.active_desc, "")
	var water = load("res://data/functions/water.tres")
	_check("water best_fit == MODIFIER", water != null and water.best_fit == &"MODIFIER", "got %s" % (water.best_fit if water != null else "?"))
	var leech = load("res://data/functions/leech.tres")
	_check("leech best_fit == PASSIVE", leech != null and leech.best_fit == &"PASSIVE", "got %s" % (leech.best_fit if leech != null else "?"))
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

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
	label.text = "\n".join(_lines)
	add_child(label)
