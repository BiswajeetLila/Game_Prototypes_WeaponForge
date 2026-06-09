## Test harness for CatalystData (10-compound table) + CatalystResolver (cap-1/no-cap).
## Spec: docs/superpowers/specs/2026-06-09-catalyst-design.md
##
## Run via godot MCP:
##   mcp__godot__run_project(projectPath, scene="res://scenes/dev/TestCatalyst.tscn")
##   mcp__godot__get_debug_output — find "=== N passed / M failed ==="
## Headless self-quits with exit code = failure count.
extends Control

const CatalystDataT = preload("res://scripts/data/catalyst_data.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== CatalystData + CatalystResolver tests ===")
	_test_compounds_returns_ten_records()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_compounds_returns_ten_records() -> void:
	## Spec §2: 6 active FTUE compounds + 4 Earth-gated = 10 total.
	var rows: Array = CatalystDataT.compounds()
	_check("compounds() returns 10 records", rows.size() == 10, "size=%d" % rows.size())
	var earth_gated: int = 0
	for r in rows:
		if int(r.get("gated_from_stage", 0)) >= 10:
			earth_gated += 1
	_check("4 records gated from stage 10", earth_gated == 4, "count=%d" % earth_gated)

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
