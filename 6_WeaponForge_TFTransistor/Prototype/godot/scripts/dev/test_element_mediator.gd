## Integration tests for ElementMediator — step 6.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== ElementMediator tests ===")
	_test_dispatch_steam()
	_test_dispatch_electrocute()
	_test_cracked_not_consumed()
	_test_no_match()
	_test_priority_wet_over_burning()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_dispatch_steam() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var e = ls.make_enemy(&"g", 1, 0.5)
	ls.apply_status(e, &"Wet", 4)
	var rd =em.dispatch_reaction(&"FIRE", e)
	_check("FIRE x Wet = Steam", rd != null and rd.id == &"Steam", "got %s" % (str(rd.id) if rd else "null"))
	_check("Steam: Wet cleansed from origin", not ls.has_status(e, &"Wet"), "")

func _test_dispatch_electrocute() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var e = ls.make_enemy(&"g", 1, 0.5)
	ls.apply_status(e, &"Wet", 4)
	var rd =em.dispatch_reaction(&"LIGHTNING", e)
	_check("LIGHTNING x Wet = Electrocute", rd != null and rd.id == &"Electrocute", "got %s" % (str(rd.id) if rd else "null"))
	_check("Electrocute: Wet cleansed", not ls.has_status(e, &"Wet"), "")
	_check("Electrocute dmg_mult 2.0", rd != null and is_equal_approx(rd.dmg_mult, 2.0), "")

func _test_cracked_not_consumed() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var e = ls.make_enemy(&"g", 1, 0.5)
	ls.apply_status(e, &"Wet", 4)
	ls.apply_status(e, &"Cracked", 4, 2, 3)
	var rd =em.dispatch_reaction(&"LIGHTNING", e)
	_check("Cracked present: LIGHTNING x Wet still = Electrocute", rd != null and rd.id == &"Electrocute", "got %s" % (str(rd.id) if rd else "null"))
	_check("Cracked stacks NOT consumed", ls.get_status_stacks(e, &"Cracked") == 2, "got %d" % ls.get_status_stacks(e, &"Cracked"))

func _test_no_match() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var e = ls.make_enemy(&"g", 1, 0.5)
	## No status on enemy
	var rd =em.dispatch_reaction(&"FIRE", e)
	_check("no status: no reaction", rd == null, "got %s" % (str(rd.id) if rd else "null"))

	## Tag not in registry for that status
	ls.apply_status(e, &"Burning", 3)
	rd = em.dispatch_reaction(&"WATER", e)
	_check("WATER x Burning: no match in slice registry", rd == null, "got %s" % (str(rd.id) if rd else "null"))

func _test_priority_wet_over_burning() -> void:
	## Wet takes priority (Wet > Burning per spec §8.1)
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var e = ls.make_enemy(&"g", 1, 0.5)
	ls.apply_status(e, &"Wet", 4)
	ls.apply_status(e, &"Burning", 3)
	var rd =em.dispatch_reaction(&"FIRE", e)
	_check("FIRE + Wet+Burning: Steam fires (Wet priority)", rd != null and rd.id == &"Steam", "got %s" % (str(rd.id) if rd else "null"))

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
