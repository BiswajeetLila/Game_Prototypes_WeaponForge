## Tests for forge_grid — hero-agnostic tile move/swap/merge (G5).
extends Control

const Grid = preload("res://scripts/core/forge_grid.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== forge_grid tests ===")
	_test_get_tile()
	_test_move_to_empty()
	_test_merge_same()
	_test_swap_different()
	_test_cross_hero_move()
	_test_socket_to_reserve()
	_test_reserve_to_reserve_cross_hero()
	_test_same_tile_noop()
	_test_empty_src()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _mk_loadouts() -> Array:
	return [[null, null, null], [null, null, null], [null, null, null]]

func _mk_reserves() -> Array:
	return [[null, null], [null, null], [null, null]]

func _socket(h: int, i: int) -> Dictionary:
	return {"kind": "socket", "hero": h, "idx": i}

func _reserve(h: int, i: int) -> Dictionary:
	return {"kind": "reserve", "hero": h, "idx": i}

func _test_get_tile() -> void:
	var lo := _mk_loadouts()
	var rs := _mk_reserves()
	lo[0][2] = {"id": &"FIRE", "tier": 1, "cost": 1}
	rs[1][0] = {"id": &"WATER", "tier": 1, "cost": 1}
	_check("get socket tile", Grid.get_tile(lo, rs, _socket(0, 2)) != null and Grid.get_tile(lo, rs, _socket(0, 2)).id == &"FIRE", "")
	_check("get reserve tile", Grid.get_tile(lo, rs, _reserve(1, 0)) != null and Grid.get_tile(lo, rs, _reserve(1, 0)).id == &"WATER", "")
	_check("get empty tile -> null", Grid.get_tile(lo, rs, _socket(2, 0)) == null, "")

func _test_move_to_empty() -> void:
	var lo := _mk_loadouts()
	var rs := _mk_reserves()
	lo[0][1] = {"id": &"FIRE", "tier": 1, "cost": 1}
	var res: Dictionary = Grid.move(lo, rs, _socket(0, 1), _socket(0, 2))
	_check("move-empty: result moved", res.get("result") == "moved", "got %s" % str(res))
	_check("move-empty: dst now FIRE", lo[0][2] != null and lo[0][2].id == &"FIRE", "got %s" % str(lo[0][2]))
	_check("move-empty: src now empty", lo[0][1] == null, "got %s" % str(lo[0][1]))

func _test_merge_same() -> void:
	var lo := _mk_loadouts()
	var rs := _mk_reserves()
	lo[0][1] = {"id": &"FIRE", "tier": 1, "cost": 1}
	lo[0][2] = {"id": &"FIRE", "tier": 1, "cost": 1}
	var res: Dictionary = Grid.move(lo, rs, _socket(0, 1), _socket(0, 2))
	_check("merge: result merged", res.get("result") == "merged", "got %s" % str(res))
	_check("merge: dst tier bumps 1 -> 2", lo[0][2] != null and int(lo[0][2].tier) == 2, "got %s" % str(lo[0][2]))
	_check("merge: src consumed (empty)", lo[0][1] == null, "got %s" % str(lo[0][1]))

func _test_swap_different() -> void:
	var lo := _mk_loadouts()
	var rs := _mk_reserves()
	lo[0][1] = {"id": &"FIRE", "tier": 1, "cost": 1}
	lo[0][2] = {"id": &"WATER", "tier": 1, "cost": 1}
	var res: Dictionary = Grid.move(lo, rs, _socket(0, 1), _socket(0, 2))
	_check("swap: result swapped", res.get("result") == "swapped", "got %s" % str(res))
	_check("swap: dst now FIRE", lo[0][2] != null and lo[0][2].id == &"FIRE", "got %s" % str(lo[0][2]))
	_check("swap: src now WATER", lo[0][1] != null and lo[0][1].id == &"WATER", "got %s" % str(lo[0][1]))

func _test_cross_hero_move() -> void:
	var lo := _mk_loadouts()
	var rs := _mk_reserves()
	lo[0][2] = {"id": &"LIGHTNING", "tier": 1, "cost": 1}
	var res: Dictionary = Grid.move(lo, rs, _socket(0, 2), _socket(1, 2))
	_check("cross-hero: result moved", res.get("result") == "moved", "got %s" % str(res))
	_check("cross-hero: hero1 socket now LIGHTNING", lo[1][2] != null and lo[1][2].id == &"LIGHTNING", "got %s" % str(lo[1][2]))
	_check("cross-hero: hero0 socket empty", lo[0][2] == null, "got %s" % str(lo[0][2]))

func _test_socket_to_reserve() -> void:
	var lo := _mk_loadouts()
	var rs := _mk_reserves()
	lo[2][0] = {"id": &"AOE", "tier": 1, "cost": 1}
	var res: Dictionary = Grid.move(lo, rs, _socket(2, 0), _reserve(2, 1))
	_check("sock->rsv: moved", res.get("result") == "moved", "got %s" % str(res))
	_check("sock->rsv: reserve has AOE", rs[2][1] != null and rs[2][1].id == &"AOE", "got %s" % str(rs[2][1]))
	_check("sock->rsv: socket empty", lo[2][0] == null, "got %s" % str(lo[2][0]))

func _test_reserve_to_reserve_cross_hero() -> void:
	var lo := _mk_loadouts()
	var rs := _mk_reserves()
	rs[0][0] = {"id": &"LEECH", "tier": 1, "cost": 1}
	rs[1][1] = {"id": &"BURST", "tier": 1, "cost": 1}
	var res: Dictionary = Grid.move(lo, rs, _reserve(0, 0), _reserve(1, 1))
	_check("rsv->rsv x-hero: swapped", res.get("result") == "swapped", "got %s" % str(res))
	_check("rsv->rsv x-hero: dst now LEECH", rs[1][1] != null and rs[1][1].id == &"LEECH", "got %s" % str(rs[1][1]))
	_check("rsv->rsv x-hero: src now BURST", rs[0][0] != null and rs[0][0].id == &"BURST", "got %s" % str(rs[0][0]))

func _test_same_tile_noop() -> void:
	var lo := _mk_loadouts()
	var rs := _mk_reserves()
	lo[0][2] = {"id": &"FIRE", "tier": 1, "cost": 1}
	var res: Dictionary = Grid.move(lo, rs, _socket(0, 2), _socket(0, 2))
	_check("same tile: not ok / same_tile", res.get("ok") == false and res.get("result") == "same_tile", "got %s" % str(res))
	_check("same tile: unchanged", lo[0][2] != null and lo[0][2].id == &"FIRE", "got %s" % str(lo[0][2]))

func _test_empty_src() -> void:
	var lo := _mk_loadouts()
	var rs := _mk_reserves()
	var res: Dictionary = Grid.move(lo, rs, _socket(0, 0), _socket(0, 1))
	_check("empty src: not ok", res.get("ok") == false and res.get("result") == "empty_src", "got %s" % str(res))

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
