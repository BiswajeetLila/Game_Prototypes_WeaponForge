## Tests for ShopV2 — step 10.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== ShopV2 tests ===")
	_test_populate_schedules()
	_test_pity_counter()
	_test_cost_table()
	_test_roll_items()
	_test_buy()
	_test_reroll()
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

func _test_cost_table() -> void:
	var sv2 = get_node("/root/ShopV2")
	_check("cost stage1 T1 = 1g", sv2.cost_for(0, 1) == 1, "got %d" % sv2.cost_for(0, 1))
	_check("cost stage3 T1 = 2g", sv2.cost_for(2, 1) == 2, "got %d" % sv2.cost_for(2, 1))
	_check("cost stage5 T1 = 3g", sv2.cost_for(4, 1) == 3, "got %d" % sv2.cost_for(4, 1))
	_check("cost stage1 T2 = 2g (ceil 1.4)", sv2.cost_for(0, 2) == 2, "got %d" % sv2.cost_for(0, 2))
	_check("REROLL_COST == 1", sv2.REROLL_COST == 1, "got %d" % sv2.REROLL_COST)

func _test_roll_items() -> void:
	var sv2 = get_node("/root/ShopV2")
	var items: Array = sv2.roll_items(0, 2, false)
	_check("roll: 2 items", items.size() == 2, "got %d" % items.size())
	var all_t1_slice: bool = true
	for it in items:
		if int(it.get("tier", 0)) != 1 or int(it.get("cost", -1)) != 1:
			all_t1_slice = false
		if not sv2.SLICE_FN_IDS.has(String(it.get("id", ""))):
			all_t1_slice = false
		if String(it.get("id", "")) == "BOUNCE":
			all_t1_slice = false
	_check("roll: all T1, cost 1, slice ids, no BOUNCE", all_t1_slice, "items=%s" % str(items))
	var pity_items: Array = sv2.roll_items(0, 3, true)
	_check("roll pity: first item is an element", pity_items.size() > 0 and sv2.ELEMENT_IDS.has(String(pity_items[0].get("id", ""))),
		"got %s" % str(pity_items[0] if pity_items.size() > 0 else {}))

func _test_buy() -> void:
	var sv2 = get_node("/root/ShopV2")
	var ok_res: Dictionary = sv2.buy({"id": "FIRE", "tier": 1, "cost": 1}, 7)
	_check("buy ok: gold>=cost", ok_res.get("ok", false) == true and int(ok_res.get("cost", -1)) == 1, "got %s" % str(ok_res))
	_check("buy ok: returns fn", ok_res.has("fn") and ok_res["fn"].get("id", &"") == &"FIRE", "got %s" % str(ok_res))
	var no_res: Dictionary = sv2.buy({"id": "FIRE", "tier": 1, "cost": 1}, 0)
	_check("buy fail: insufficient gold", no_res.get("ok", true) == false, "got %s" % str(no_res))

func _test_reroll() -> void:
	var sv2 = get_node("/root/ShopV2")
	_check("reroll ok: gold + pending>0", sv2.reroll(7, 2).get("ok", false) == true, "")
	_check("reroll fail: no gold", sv2.reroll(0, 2).get("ok", true) == false, "")
	_check("reroll fail: nothing to roll", sv2.reroll(7, 0).get("ok", true) == false, "")

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
