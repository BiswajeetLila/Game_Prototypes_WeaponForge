## Tests for ShopV2 — step 10.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== ShopV2 tests ===")
	_test_populate_schedules()
	_test_pity_counter()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_populate_schedules() -> void:
	## 3-wave schedule
	var s3 := ShopV2.populate_schedule_3wave()
	var total3 := 0
	for entry in s3:
		total3 += entry["count"]
	_check("3-wave: 7 items total", total3 == 7, "got %d" % total3)
	_check("3-wave: first entry at stage start (wave=-1)", s3[0]["wave"] == -1, "got %d" % s3[0]["wave"])
	_check("3-wave: 2 items at stage start", s3[0]["count"] == 2, "got %d" % s3[0]["count"])
	## Last batch during wave 2 = 2 items
	var last_wave2 := s3.filter(func(e): return e["wave"] == 2)
	var total_wave2 := 0
	for entry in last_wave2:
		total_wave2 += entry["count"]
	_check("3-wave: total wave-2 items = 3 (1+2)", total_wave2 == 3, "got %d" % total_wave2)

	## 1-wave FTUE schedule
	var s1 := ShopV2.populate_schedule_1wave()
	var total1 := 0
	for entry in s1:
		total1 += entry["count"]
	_check("1-wave: 7 items total", total1 == 7, "got %d" % total1)
	_check("1-wave: 2 at stage start", s1[0]["count"] == 2, "got %d" % s1[0]["count"])
	_check("1-wave: 3 items in final batch", s1[s1.size()-1]["count"] == 3, "got %d" % s1[s1.size()-1]["count"])

func _test_pity_counter() -> void:
	var sv2 = get_node("/root/ShopV2")
	sv2.reset()
	_check("pity: fresh = false", sv2.pity_triggered == false, "")
	sv2.notify_stage_end([], false)
	_check("pity: after 1 dry stage: false", sv2.pity_triggered == false, "")
	sv2.notify_stage_end([], false)
	_check("pity: after 2 dry stages: triggered", sv2.pity_triggered == true, "")
	## reset on element seen
	sv2.notify_stage_end([&"FIRE"], true)
	_check("pity: element seen resets counter", sv2.pity_triggered == false, "")
	sv2.notify_stage_end([], false)
	_check("pity: 1 dry after reset: false again", sv2.pity_triggered == false, "")

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
