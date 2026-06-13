## Tests for UltController — step 8.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== UltController tests ===")
	_test_charge_accumulation()
	_test_bar_cap()
	_test_consume()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_charge_accumulation() -> void:
	var uc = get_node("/root/UltController")
	uc.reset()
	_check("bars start 0", uc.bars == 0, "")
	uc.on_reaction(); uc.on_reaction()
	_check("2 reactions: bars still 0", uc.bars == 0, "")
	uc.on_reaction()
	_check("3 reactions: bars = 1", uc.bars == 1, "got %d" % uc.bars)
	uc.on_reaction(); uc.on_reaction(); uc.on_reaction()
	_check("6 reactions: bars = 2", uc.bars == 2, "got %d" % uc.bars)
	uc.on_reaction(); uc.on_reaction(); uc.on_reaction()
	_check("9 reactions: bars = 3", uc.bars == 3, "got %d" % uc.bars)

func _test_bar_cap() -> void:
	var uc = get_node("/root/UltController")
	uc.reset()
	for i in 12:
		uc.on_reaction()
	_check("12 reactions: capped at 3", uc.bars == 3, "got %d" % uc.bars)

func _test_consume() -> void:
	var uc = get_node("/root/UltController")
	uc.reset()
	## Fill 1 bar (3 reactions)
	uc.on_reaction(); uc.on_reaction(); uc.on_reaction()
	_check("before consume: 1 bar", uc.bars == 1, "")
	var consumed: bool = uc.consume_bar()
	_check("consume_bar returns true", consumed == true, "")
	_check("after consume: 0 bars", uc.bars == 0, "got %d" % uc.bars)
	consumed = uc.consume_bar()
	_check("consume_bar on empty returns false", consumed == false, "")
	_check("bars stay 0 after failed consume", uc.bars == 0, "")

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
