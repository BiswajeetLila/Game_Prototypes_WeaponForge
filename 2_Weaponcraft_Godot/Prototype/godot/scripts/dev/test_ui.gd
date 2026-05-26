## Test harness for UI behavioural assertions: ForgePanel slot labels +
## PartCard tier rim.
##
## Headless: instantiates ForgePanel.tscn / PartCard.tscn into the test tree,
## reads theme overrides + child structure. No real combat, no shop.
##
## Run: scenes/dev/TestUi.tscn -> Play Scene (Ctrl+Shift+F5).
extends Control

const InventoryItemT = preload("res://scripts/data/inventory_item.gd")
const ForgePanelScene = preload("res://scenes/ForgePanel.tscn")
const PartCardScene = preload("res://scenes/PartCard.tscn")

## Expected tier-rim colours. New scheme (no rainbow): bronze / silver / emerald
## / platinum / gold. L5 is static gold per user feedback.
const EXPECTED_RIM_BRONZE   := Color(0.420, 0.255, 0.137, 1)
const EXPECTED_RIM_SILVER   := Color(0.753, 0.753, 0.753, 1)
const EXPECTED_RIM_EMERALD  := Color(0.200, 0.750, 0.400, 1)
const EXPECTED_RIM_PLATINUM := Color(0.898, 0.890, 0.890, 1)
const EXPECTED_RIM_GOLD     := Color(0.949, 0.722, 0.133, 1)

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== UI tests ===")
	_test_anvil_labels_exist()
	_test_anvil_labels_visible()
	_test_partcard_rim_l1_bronze()
	_test_partcard_rim_l2_silver()
	_test_partcard_rim_l3_emerald()
	_test_partcard_rim_l4_platinum()
	_test_partcard_rim_l5_gold_static()
	_test_partcard_rim_width_scales()
	_summary()
	_render_to_ui()

## ---------- Slot label cases ----------

func _test_anvil_labels_exist() -> void:
	var fp = ForgePanelScene.instantiate()
	add_child(fp)
	var labels_node = fp.find_child("AnvilLabels", true, false)
	if labels_node == null:
		_check("ForgePanel has AnvilLabels child", false, "node not found")
		fp.queue_free()
		return
	var children = labels_node.get_children().filter(func(c): return c is Label)
	var texts: Array = []
	for c in children:
		texts.append(c.text)
	var ok = children.size() == 3 and texts == ["Head", "Hilt", "Rune"]
	_check("AnvilLabels has 3 Labels: Head / Hilt / Rune",
		ok,
		"got %d labels = %s" % [children.size(), str(texts)])
	fp.queue_free()

func _test_anvil_labels_visible() -> void:
	var fp = ForgePanelScene.instantiate()
	add_child(fp)
	var labels_node = fp.find_child("AnvilLabels", true, false)
	if labels_node == null:
		_check("AnvilLabels visible after _ready", false, "node not found")
		fp.queue_free()
		return
	var all_visible = true
	for c in labels_node.get_children():
		if c is Label and not c.visible:
			all_visible = false
			break
	_check("AnvilLabels Labels all visible", all_visible, "")
	fp.queue_free()

## ---------- Tier rim cases ----------

func _build_card_at_level(level: int):
	var card = PartCardScene.instantiate()
	add_child(card)
	var item = InventoryItemT.new(GameState.next_uid(), &"h_iron_edge", level)
	card.setup_anvil(item, &"head")
	return card

func _test_partcard_rim_l1_bronze() -> void:
	var card = _build_card_at_level(1)
	var sb = card.get_theme_stylebox(&"panel")
	var ok = sb != null and sb.border_color.is_equal_approx(EXPECTED_RIM_BRONZE)
	_check("L1 rim colour = bronze", ok,
		"got %s" % str(sb.border_color if sb else null))
	card.queue_free()

func _test_partcard_rim_l2_silver() -> void:
	var card = _build_card_at_level(2)
	var sb = card.get_theme_stylebox(&"panel")
	var ok = sb != null and sb.border_color.is_equal_approx(EXPECTED_RIM_SILVER)
	_check("L2 rim colour = silver", ok,
		"got %s" % str(sb.border_color if sb else null))
	card.queue_free()

func _test_partcard_rim_l3_emerald() -> void:
	var card = _build_card_at_level(3)
	var sb = card.get_theme_stylebox(&"panel")
	var ok = sb != null and sb.border_color.is_equal_approx(EXPECTED_RIM_EMERALD)
	_check("L3 rim colour = emerald", ok,
		"got %s" % str(sb.border_color if sb else null))
	card.queue_free()

func _test_partcard_rim_l4_platinum() -> void:
	var card = _build_card_at_level(4)
	var sb = card.get_theme_stylebox(&"panel")
	var ok = sb != null and sb.border_color.is_equal_approx(EXPECTED_RIM_PLATINUM)
	_check("L4 rim colour = platinum", ok,
		"got %s" % str(sb.border_color if sb else null))
	card.queue_free()

func _test_partcard_rim_l5_gold_static() -> void:
	var card = _build_card_at_level(5)
	var sb = card.get_theme_stylebox(&"panel")
	var ok = sb != null and sb.border_color.is_equal_approx(EXPECTED_RIM_GOLD)
	_check("L5 rim colour = gold (static, no rainbow tween)", ok,
		"got %s" % str(sb.border_color if sb else null))
	card.queue_free()

func _test_partcard_rim_width_scales() -> void:
	var l1 = _build_card_at_level(1)
	var l3 = _build_card_at_level(3)
	var l5 = _build_card_at_level(5)
	var w1 = l1.get_theme_stylebox(&"panel").border_width_top if l1.get_theme_stylebox(&"panel") else -1
	var w3 = l3.get_theme_stylebox(&"panel").border_width_top if l3.get_theme_stylebox(&"panel") else -1
	var w5 = l5.get_theme_stylebox(&"panel").border_width_top if l5.get_theme_stylebox(&"panel") else -1
	var ok = w1 == 2 and w3 == 3 and w5 == 4
	_check("rim width scales: L1=2 / L3=3 / L5=4", ok,
		"w1=%d w3=%d w5=%d" % [w1, w3, w5])
	l1.queue_free()
	l3.queue_free()
	l5.queue_free()

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
	label.add_theme_font_size_override(&"font_size", 13)
	label.text = "\n".join(_lines)
	label.anchor_right = 1.0
	label.anchor_bottom = 1.0
	label.offset_left = 12
	label.offset_top = 12
	add_child(label)
