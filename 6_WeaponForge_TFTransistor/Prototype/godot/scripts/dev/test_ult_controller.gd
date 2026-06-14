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
	## Q4 — Ult effects
	_test_ult_consumes_one_bar()
	_test_bran_leap_damages_and_cracks()
	_test_bran_refund_on_empty()
	_test_elara_storm_chains_wet()
	_test_elara_storm_failsafe_no_wet()
	_test_vex_strike_lowest_hp_burning_bleed()
	_test_vex_refund_on_empty()
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

## ---- Q4: Ult effects (spec §12) ----

func _ctx(lane: int, enemies: Array) -> Dictionary:
	return {"lane": lane, "enemies": enemies, "base_dmg": 2, "lane_state": get_node("/root/LaneState")}

func _test_ult_consumes_one_bar() -> void:
	var uc = get_node("/root/UltController")
	var ls = get_node("/root/LaneState")
	uc.reset()
	uc.bars = 2
	var e = ls.make_enemy(&"g", 1, 0.5, 50)
	var r = uc.fire_ult(&"bran", _ctx(1, [e]))
	_check("ult fired", r.get("fired", false) == true, "got %s" % str(r))
	_check("ult consumes exactly 1 bar (2->1)", uc.bars == 1, "got %d" % uc.bars)

func _test_bran_leap_damages_and_cracks() -> void:
	var uc = get_node("/root/UltController")
	var ls = get_node("/root/LaneState")
	uc.reset(); uc.bars = 1
	var e = ls.make_enemy(&"g", 1, 0.6, 100)
	uc.fire_ult(&"bran", _ctx(1, [e]))
	_check("Bran Leap damages lane target", int(e.hp) < 100, "got %d" % int(e.hp))
	_check("Bran Leap applies Cracked", ls.has_status(e, &"Cracked"), "")

func _test_bran_refund_on_empty() -> void:
	var uc = get_node("/root/UltController")
	uc.reset(); uc.bars = 1
	var r = uc.fire_ult(&"bran", _ctx(1, []))
	_check("Bran on empty grid: refunded", r.get("refunded", false) == true, "got %s" % str(r))
	_check("Bran refund: bar restored", uc.bars == 1, "got %d" % uc.bars)

func _test_elara_storm_chains_wet() -> void:
	var uc = get_node("/root/UltController")
	var ls = get_node("/root/LaneState")
	uc.reset(); uc.bars = 1
	var wet = ls.make_enemy(&"w", 0, 0.5, 100)
	ls.apply_status(wet, &"Wet", 4)
	var dry = ls.make_enemy(&"d", 2, 0.5, 100)
	uc.fire_ult(&"elara", _ctx(0, [wet, dry]))
	_check("Elara Storm damages Wet enemy", int(wet.hp) < 100, "got %d" % int(wet.hp))
	_check("Elara Storm applies Shocked to Wet enemy", ls.has_status(wet, &"Shocked"), "")

func _test_elara_storm_failsafe_no_wet() -> void:
	var uc = get_node("/root/UltController")
	var ls = get_node("/root/LaneState")
	uc.reset(); uc.bars = 1
	var a = ls.make_enemy(&"a", 0, 0.5, 100)
	var b = ls.make_enemy(&"b", 1, 0.5, 100)
	var r = uc.fire_ult(&"elara", _ctx(0, [a, b]))
	_check("Elara failsafe (no Wet): all enemies take damage", int(a.hp) < 100 and int(b.hp) < 100, "got %d / %d" % [int(a.hp), int(b.hp)])
	_check("Elara never refunds", r.get("refunded", false) == false and uc.bars == 0, "bars=%d" % uc.bars)

func _test_vex_strike_lowest_hp_burning_bleed() -> void:
	var uc = get_node("/root/UltController")
	var ls = get_node("/root/LaneState")
	uc.reset(); uc.bars = 1
	var big = ls.make_enemy(&"big", 0, 0.5, 100)
	var weak = ls.make_enemy(&"weak", 2, 0.5, 30)
	uc.fire_ult(&"vex", _ctx(2, [big, weak]))
	_check("Vex strikes lowest-HP enemy", int(weak.hp) < 30, "got %d" % int(weak.hp))
	_check("Vex applies Burning", ls.has_status(weak, &"Burning"), "")
	_check("Vex applies Bleed", ls.has_status(weak, &"Bleed"), "")
	_check("Vex leaves the high-HP enemy untouched", int(big.hp) == 100, "got %d" % int(big.hp))

func _test_vex_refund_on_empty() -> void:
	var uc = get_node("/root/UltController")
	uc.reset(); uc.bars = 1
	var r = uc.fire_ult(&"vex", _ctx(2, []))
	_check("Vex on empty grid: refunded", r.get("refunded", false) == true and uc.bars == 1, "got %s bars=%d" % [str(r), uc.bars])

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
