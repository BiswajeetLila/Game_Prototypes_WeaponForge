## Test harness for the Catalyst UI surfaces — banner / chip / codex.
## Self-quitting: exit code = failure count.
##
## Run via godot MCP:
##   mcp__godot__run_project(projectPath, scene="res://scenes/dev/TestCatalystUI.tscn")
##   mcp__godot__get_debug_output  -> "=== N passed / M failed ==="
extends Control

const CatalystBannerT = preload("res://scripts/ui/catalyst_banner.gd")
const CatalystChipT = preload("res://scripts/ui/catalyst_chip.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== Catalyst UI surfaces — banner / chip / codex tests ===")
	_test_banner_shows_compound_name()
	_test_banner_hide_clears_visible()
	_test_banner_show_empty_dict_is_a_noop()
	_test_chip_renders_single_compound()
	_test_chip_stacks_three_compounds()
	_test_chip_hides_when_empty_array()
	_test_chip_set_compounds_replaces_rows()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

## ---------- Banner ----------

func _test_banner_shows_compound_name() -> void:
	## show_compound -> visible + _title.text contains FIRESTORM (uppercase) + _effect text non-empty.
	var b = CatalystBannerT.new()
	add_child(b)
	b.show_compound({
		"id": &"firestorm", "display_name": "Firestorm",
		"elements": [&"fire", &"ice"],
		"modifier_bag": {&"squad_atk_mult": 1.20, &"squad_crit_add": 0.0,
			&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
	})
	_check("banner visible after show_compound", b.visible == true, "hidden")
	_check("banner _title contains FIRESTORM",
		b._title.text.to_upper().contains("FIRESTORM"),
		"title=%s" % b._title.text)
	_check("banner _effect is non-empty",
		b._effect.text != "", "effect=%s" % b._effect.text)
	b.queue_free()

func _test_banner_hide_clears_visible() -> void:
	var b = CatalystBannerT.new()
	add_child(b)
	b.show_compound({"id": &"firestorm", "display_name": "Firestorm",
		"elements": [&"fire", &"ice"],
		"modifier_bag": {&"squad_atk_mult": 1.20, &"squad_crit_add": 0.0,
			&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0}})
	b.hide_banner()
	_check("banner hidden after hide_banner", b.visible == false, "still visible")
	b.queue_free()

func _test_banner_show_empty_dict_is_a_noop() -> void:
	## Calling show_compound({}) hides the banner (no crash, no garbage text).
	var b = CatalystBannerT.new()
	add_child(b)
	b.show_compound({})
	_check("banner hidden when show_compound({}) called", b.visible == false, "showed empty")
	b.queue_free()

## ---------- Chip ----------

func _test_chip_renders_single_compound() -> void:
	## set_compounds with one record -> visible + 1 row.
	var chip = CatalystChipT.new()
	add_child(chip)
	chip.set_compounds([{
		"id": &"firestorm", "display_name": "Firestorm",
		"elements": [&"fire", &"ice"],
		"modifier_bag": {&"squad_atk_mult": 1.20, &"squad_crit_add": 0.0,
			&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
	}])
	_check("chip visible after set_compounds (1 row)", chip.visible == true, "hidden")
	_check("chip _rows has 1 child",
		chip._rows.get_child_count() == 1,
		"rows=%d" % chip._rows.get_child_count())
	chip.queue_free()

func _test_chip_stacks_three_compounds() -> void:
	## set_compounds with 3 records -> visible + 3 rows (no-cap mode).
	var chip = CatalystChipT.new()
	add_child(chip)
	var rows: Array = [
		{"id": &"firestorm", "display_name": "Firestorm", "elements": [&"fire", &"ice"],
			"modifier_bag": {}},
		{"id": &"wildfire", "display_name": "Wildfire", "elements": [&"fire", &"wind"],
			"modifier_bag": {}},
		{"id": &"blizzard", "display_name": "Blizzard", "elements": [&"ice", &"wind"],
			"modifier_bag": {}},
	]
	chip.set_compounds(rows)
	_check("chip visible for 3-compound stack", chip.visible == true, "hidden")
	_check("chip _rows has 3 children",
		chip._rows.get_child_count() == 3,
		"rows=%d" % chip._rows.get_child_count())
	chip.queue_free()

func _test_chip_hides_when_empty_array() -> void:
	## set_compounds([]) -> visible = false (no header, no rows).
	var chip = CatalystChipT.new()
	add_child(chip)
	chip.set_compounds([])
	_check("chip hidden when set_compounds([])", chip.visible == false, "visible")
	_check("chip _rows empty",
		chip._rows.get_child_count() == 0,
		"rows=%d" % chip._rows.get_child_count())
	chip.queue_free()

func _test_chip_set_compounds_replaces_rows() -> void:
	## set_compounds called twice -> old rows synchronously freed, new rows
	## reflect the latest call's record count. Synchronous remove_child+free
	## (catalyst_chip.gd) means get_child_count() is stable in the same frame.
	var chip = CatalystChipT.new()
	add_child(chip)
	chip.set_compounds([
		{"id": &"firestorm", "display_name": "Firestorm", "elements": [&"fire", &"ice"], "modifier_bag": {}},
		{"id": &"wildfire", "display_name": "Wildfire", "elements": [&"fire", &"wind"], "modifier_bag": {}},
	])
	_check("chip starts with 2 rows", chip._rows.get_child_count() == 2,
		"rows=%d" % chip._rows.get_child_count())
	chip.set_compounds([
		{"id": &"blizzard", "display_name": "Blizzard", "elements": [&"ice", &"wind"], "modifier_bag": {}},
	])
	_check("re-set with 1 record -> _rows shrinks to 1", chip._rows.get_child_count() == 1,
		"rows=%d (expected 1)" % chip._rows.get_child_count())
	_check("chip still visible after re-set", chip.visible == true, "hidden after re-set")
	chip.queue_free()

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
