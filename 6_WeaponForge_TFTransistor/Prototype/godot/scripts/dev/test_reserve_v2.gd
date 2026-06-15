## Tests for reserve_v2 — Reserve bench, equip-with-displacement, merge, sell (G2).
extends Control

const Reserve = preload("res://scripts/core/reserve_v2.gd")
const Loadout = preload("res://scripts/core/loadout_v2.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== reserve_v2 tests ===")
	_test_make_and_room()
	_test_equip_empty()
	_test_equip_displaces()
	_test_equip_merge()
	_test_equip_blocked_when_full()
	_test_equip_from_reserve_swaps()
	_test_equip_from_empty_reserve()
	_test_sell_value()
	_test_sell_socket()
	_test_sell_reserve()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_make_and_room() -> void:
	var r: Array = Reserve.make_reserve()
	_check("make: 1 empty slot", r.size() == 1 and r[0] == null, "got %s" % str(r))
	_check("count: empty = 0", Reserve.count(r) == 0, "got %d" % Reserve.count(r))
	_check("has_room: empty = true", Reserve.has_room(r) == true, "")
	_check("first_empty: empty = 0", Reserve.first_empty(r) == 0, "got %d" % Reserve.first_empty(r))
	r[0] = {"id": &"FIRE", "tier": 1, "cost": 1}
	_check("count: one filled = 1", Reserve.count(r) == 1, "got %d" % Reserve.count(r))
	_check("has_room: full (1 slot) = false", Reserve.has_room(r) == false, "")
	_check("first_empty: full = -1", Reserve.first_empty(r) == -1, "got %d" % Reserve.first_empty(r))

func _test_equip_empty() -> void:
	var lo: Array = Loadout.make_loadout()
	var r: Array = Reserve.make_reserve()
	var res: Dictionary = Reserve.equip(lo, r, 2, {"id": "FIRE", "tier": 1, "cost": 3})
	_check("equip empty: ok + result=equipped", res.get("ok") == true and res.get("result") == "equipped", "got %s" % str(res))
	_check("equip empty: socket holds FIRE", lo[2] != null and lo[2].id == &"FIRE", "got %s" % str(lo[2]))
	_check("equip empty: socket stores cost", lo[2] != null and int(lo[2].get("cost", -1)) == 3, "got %s" % str(lo[2]))
	_check("equip empty: reserve untouched", Reserve.count(r) == 0, "got %d" % Reserve.count(r))

func _test_equip_displaces() -> void:
	var lo: Array = Loadout.make_loadout()
	lo[2] = {"id": &"FIRE", "tier": 1, "cost": 3}
	var r: Array = Reserve.make_reserve()
	var res: Dictionary = Reserve.equip(lo, r, 2, {"id": "WATER", "tier": 1, "cost": 2})
	_check("displace: result=displaced", res.get("result") == "displaced", "got %s" % str(res))
	_check("displace: socket now WATER", lo[2] != null and lo[2].id == &"WATER", "got %s" % str(lo[2]))
	_check("displace: old FIRE moved to reserve", r[0] != null and r[0].id == &"FIRE", "got %s" % str(r[0]))
	_check("displace: displaced keeps its cost (sellable)", r[0] != null and int(r[0].get("cost", -1)) == 3, "got %s" % str(r[0]))

func _test_equip_merge() -> void:
	var lo: Array = Loadout.make_loadout()
	lo[2] = {"id": &"FIRE", "tier": 1, "cost": 3}
	var r: Array = Reserve.make_reserve()
	var res: Dictionary = Reserve.equip(lo, r, 2, {"id": "FIRE", "tier": 1, "cost": 3})
	_check("merge: result=merged", res.get("result") == "merged", "got %s" % str(res))
	_check("merge: tier bumps 1 -> 2", lo[2] != null and int(lo[2].tier) == 2, "got %s" % str(lo[2]))
	_check("merge: no displacement to reserve", Reserve.count(r) == 0, "got %d" % Reserve.count(r))

func _test_equip_blocked_when_full() -> void:
	var lo: Array = Loadout.make_loadout()
	lo[2] = {"id": &"FIRE", "tier": 1, "cost": 1}
	var r: Array = [{"id": &"WATER", "tier": 1, "cost": 1}]  ## single reserve slot, full
	var res: Dictionary = Reserve.equip(lo, r, 2, {"id": "LEECH", "tier": 1, "cost": 1})
	_check("full: not ok + result=blocked_full", res.get("ok") == false and res.get("result") == "blocked_full", "got %s" % str(res))
	_check("full: socket unchanged (still FIRE)", lo[2] != null and lo[2].id == &"FIRE", "got %s" % str(lo[2]))
	_check("full: reserve unchanged (no LEECH)", Reserve.count(r) == 1 and r[0].id == &"WATER", "got %s" % str(r))

func _test_equip_from_reserve_swaps() -> void:
	var lo: Array = Loadout.make_loadout()
	lo[2] = {"id": &"FIRE", "tier": 1, "cost": 3}
	var r: Array = [{"id": &"WATER", "tier": 1, "cost": 2}, null]
	var res: Dictionary = Reserve.equip_from_reserve(lo, r, 2, 0)
	_check("bench equip: ok + result=swapped", res.get("ok") == true and res.get("result") == "swapped", "got %s" % str(res))
	_check("bench equip: socket now WATER", lo[2] != null and lo[2].id == &"WATER", "got %s" % str(lo[2]))
	_check("bench equip: old FIRE swapped into that reserve slot", r[0] != null and r[0].id == &"FIRE", "got %s" % str(r[0]))

func _test_equip_from_empty_reserve() -> void:
	var lo: Array = Loadout.make_loadout()
	var r: Array = Reserve.make_reserve()
	var res: Dictionary = Reserve.equip_from_reserve(lo, r, 2, 0)
	_check("bench equip empty: not ok", res.get("ok") == false, "got %s" % str(res))

func _test_sell_value() -> void:
	_check("sell value: cost 3 -> 1 (floor 1.5)", Reserve.sell_value({"cost": 3}) == 1, "got %d" % Reserve.sell_value({"cost": 3}))
	_check("sell value: cost 2 -> 1", Reserve.sell_value({"cost": 2}) == 1, "got %d" % Reserve.sell_value({"cost": 2}))
	_check("sell value: cost 1 -> 0 (reduced)", Reserve.sell_value({"cost": 1}) == 0, "got %d" % Reserve.sell_value({"cost": 1}))

func _test_sell_socket() -> void:
	var lo: Array = Loadout.make_loadout()
	lo[2] = {"id": &"FIRE", "tier": 1, "cost": 3}
	var res: Dictionary = Reserve.sell_socket(lo, 2)
	_check("sell socket: ok + refund 1", res.get("ok") == true and int(res.get("gold_refund")) == 1, "got %s" % str(res))
	_check("sell socket: slot emptied", lo[2] == null, "got %s" % str(lo[2]))
	var res2: Dictionary = Reserve.sell_socket(lo, 2)
	_check("sell socket empty: not ok, no refund", res2.get("ok") == false and int(res2.get("gold_refund")) == 0, "got %s" % str(res2))

func _test_sell_reserve() -> void:
	var r: Array = [{"id": &"WATER", "tier": 1, "cost": 2}, null]
	var res: Dictionary = Reserve.sell_reserve(r, 0)
	_check("sell reserve: ok + refund 1", res.get("ok") == true and int(res.get("gold_refund")) == 1, "got %s" % str(res))
	_check("sell reserve: slot emptied", r[0] == null, "got %s" % str(r[0]))

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
	add_child(label)
