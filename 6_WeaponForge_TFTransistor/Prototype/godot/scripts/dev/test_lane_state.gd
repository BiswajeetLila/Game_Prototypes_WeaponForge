## Headless tests for LaneState autoload (Phase 4 step 2).
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== LaneState tests ===")
	_test_distance()
	_test_advance()
	_test_knockback()
	_test_status_lifecycle()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_distance() -> void:
	var ls = get_node("/root/LaneState")
	_check("same point: dist 0.0", is_equal_approx(ls.distance(0, 0.5, 0, 0.5), 0.0), "")
	# same lane, delta_x=0.2 -> k*0.2 = 0.6 -> dist=0.6
	_check("same lane delta_x 0.2: dist 0.6",
		is_equal_approx(ls.distance(0, 0.3, 0, 0.5), 0.6), "got %f" % ls.distance(0, 0.3, 0, 0.5))
	# adjacent lane, same x: dist = sqrt(1²+0²) = 1.0
	_check("adj lane same x: dist 1.0",
		is_equal_approx(ls.distance(0, 0.5, 1, 0.5), 1.0), "got %f" % ls.distance(0, 0.5, 1, 0.5))
	# 2 lanes apart, same x: dist = 2.0
	_check("2 lanes apart same x: dist 2.0",
		is_equal_approx(ls.distance(0, 0.5, 2, 0.5), 2.0), "got %f" % ls.distance(0, 0.5, 2, 0.5))
	# adj lane + delta_x 0.2: sqrt(1 + 0.36) = sqrt(1.36)
	var expected := sqrt(1.0 + 0.36)
	_check("adj lane + delta_x 0.2",
		is_equal_approx(ls.distance(0, 0.3, 1, 0.5), expected), "got %f" % ls.distance(0, 0.3, 1, 0.5))

func _test_advance() -> void:
	var ls = get_node("/root/LaneState")

	# normal advance
	var e = ls.make_enemy(&"t", 1, 0.5)
	ls.advance_enemy(e)
	_check("advance reduces screen_x by walk_speed",
		is_equal_approx(e.screen_x, 0.45), "got %f" % e.screen_x)
	_check("advance: not engaged at 0.45",
		e.engaged == false, "")

	# Chilled: half speed
	e = ls.make_enemy(&"t", 1, 0.5)
	ls.apply_status(e, &"Chilled", 3)
	ls.advance_enemy(e)
	_check("Chilled: advances at half speed (0.475)",
		is_equal_approx(e.screen_x, 0.475), "got %f" % e.screen_x)

	# Frozen: no advance
	e = ls.make_enemy(&"t", 1, 0.5)
	ls.apply_status(e, &"Frozen", 1)
	ls.advance_enemy(e)
	_check("Frozen: screen_x unchanged",
		is_equal_approx(e.screen_x, 0.5), "got %f" % e.screen_x)

	# reach 0 -> engaged
	e = ls.make_enemy(&"t", 1, 0.03)
	ls.advance_enemy(e)
	_check("reach 0: engaged=true", e.engaged == true, "")
	_check("screen_x clamped to 0.0", is_equal_approx(e.screen_x, 0.0), "got %f" % e.screen_x)

func _test_knockback() -> void:
	var ls = get_node("/root/LaneState")

	var e = ls.make_enemy(&"t", 1, 0.3)
	var hit: bool = ls.knockback_enemy(e, 0.2)
	_check("knockback returns true", hit == true, "")
	_check("knockback pushes screen_x to 0.5",
		is_equal_approx(e.screen_x, 0.5), "got %f" % e.screen_x)
	_check("knockback sets kb_immune to 2", e.kb_immune == 2, "got %d" % e.kb_immune)

	# second knockback blocked by immunity
	hit = ls.knockback_enemy(e, 0.2)
	_check("2nd knockback blocked: returns false", hit == false, "")
	_check("screen_x unchanged at 0.5", is_equal_approx(e.screen_x, 0.5), "got %f" % e.screen_x)

	# immunity decays via advance_enemy
	ls.advance_enemy(e)  # kb_immune: 2->1
	hit = ls.knockback_enemy(e, 0.1)
	_check("kb_immune=1: still blocked", hit == false, "")
	ls.advance_enemy(e)  # kb_immune: 1->0
	hit = ls.knockback_enemy(e, 0.1)
	_check("kb_immune=0: knockback lands again", hit == true, "")

	# cap at 1.0
	e = ls.make_enemy(&"t", 1, 0.95)
	ls.knockback_enemy(e, 0.5)
	_check("knockback capped at 1.0", is_equal_approx(e.screen_x, 1.0), "got %f" % e.screen_x)

func _test_status_lifecycle() -> void:
	var ls = get_node("/root/LaneState")

	var e = ls.make_enemy(&"t", 1, 0.5)
	_check("no status: has_status false", ls.has_status(e, &"Burning") == false, "")
	_check("no status: stacks 0", ls.get_status_stacks(e, &"Burning") == 0, "")

	ls.apply_status(e, &"Burning", 3)
	_check("apply Burning: has status", ls.has_status(e, &"Burning") == true, "")
	_check("apply Burning: stacks 1", ls.get_status_stacks(e, &"Burning") == 1, "")

	# decay
	ls.decay_statuses(e)
	_check("after 1 decay: ticks=2, still present", ls.has_status(e, &"Burning") == true, "")
	ls.decay_statuses(e)
	ls.decay_statuses(e)
	_check("after 3 decays: Burning removed", ls.has_status(e, &"Burning") == false, "")

	# refresh on re-apply
	e = ls.make_enemy(&"t", 1, 0.5)
	ls.apply_status(e, &"Wet", 4)
	ls.decay_statuses(e)  # ticks: 3
	ls.apply_status(e, &"Wet", 4)  # refresh -> 4
	ls.decay_statuses(e); ls.decay_statuses(e); ls.decay_statuses(e)
	_check("Wet refresh: still present after 3 more decays", ls.has_status(e, &"Wet") == true, "")

	# Cracked stacks to 3
	e = ls.make_enemy(&"t", 1, 0.5)
	ls.apply_status(e, &"Cracked", 4, 1, 3)
	ls.apply_status(e, &"Cracked", 4, 1, 3)
	ls.apply_status(e, &"Cracked", 4, 1, 3)
	_check("Cracked: 3 stacks", ls.get_status_stacks(e, &"Cracked") == 3, "got %d" % ls.get_status_stacks(e, &"Cracked"))
	ls.apply_status(e, &"Cracked", 4, 1, 3)
	_check("Cracked: capped at 3", ls.get_status_stacks(e, &"Cracked") == 3, "got %d" % ls.get_status_stacks(e, &"Cracked"))

	# cleanse
	e = ls.make_enemy(&"t", 1, 0.5)
	ls.apply_status(e, &"Wet", 4)
	ls.cleanse_status(e, &"Wet")
	_check("cleanse Wet: gone", ls.has_status(e, &"Wet") == false, "")

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
