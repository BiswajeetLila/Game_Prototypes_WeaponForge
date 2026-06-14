## Tests for loadout_v2 — forge equip + merge logic (A6).
## Merge rule (spec §10): dropping the SAME function at the SAME tier onto a socket
## that already holds it -> tier+1 (cap 5), position retained. A DIFFERENT function
## just swaps (replaces). Empty socket -> place.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== loadout_v2 tests ===")
	var L = load("res://scripts/core/loadout_v2.gd")
	_check("loadout_v2 script exists", L != null, "scripts/core/loadout_v2.gd missing")
	if L == null:
		_summary(); _render_to_ui()
		if DisplayServer.get_name() == "headless": get_tree().quit(_failed)
		return

	## make_loadout -> 3 empty sockets
	var lo = L.make_loadout()
	_check("make_loadout has 3 sockets", lo.size() == 3, "got %d" % lo.size())
	_check("sockets start empty", lo[0] == null and lo[1] == null and lo[2] == null, "")

	## place into empty
	lo = L.apply_drop(lo, 0, &"FIRE", 1)
	_check("place: socket 0 = FIRE t1", lo[0] != null and lo[0].id == &"FIRE" and lo[0].tier == 1, "got %s" % str(lo[0]))

	## merge same id + tier -> tier 2
	lo = L.apply_drop(lo, 0, &"FIRE", 1)
	_check("merge: FIRE t1 + FIRE t1 = FIRE t2", lo[0].id == &"FIRE" and lo[0].tier == 2, "got %s" % str(lo[0]))

	## different id swaps (no merge)
	lo = L.apply_drop(lo, 0, &"WATER", 1)
	_check("swap: drop WATER onto FIRE = WATER t1", lo[0].id == &"WATER" and lo[0].tier == 1, "got %s" % str(lo[0]))

	## position retained: dropping into socket 2 doesn't touch 0/1
	lo = L.apply_drop(lo, 2, &"LIGHTNING", 1)
	_check("position retained: socket 0 still WATER", lo[0].id == &"WATER", "")
	_check("position retained: socket 1 still empty", lo[1] == null, "")
	_check("place: socket 2 = LIGHTNING", lo[2] != null and lo[2].id == &"LIGHTNING", "")

	## merge caps at tier 5
	var lo2 = L.make_loadout()
	lo2 = L.apply_drop(lo2, 1, &"AOE", 5)
	lo2 = L.apply_drop(lo2, 1, &"AOE", 5)
	_check("merge cap: AOE t5 + AOE t5 stays t5", lo2[1].tier == 5, "got %d" % lo2[1].tier)

	## merge requires SAME tier: FIRE t1 + FIRE t2 = swap to t2 (not t3), or stays distinct
	var lo3 = L.make_loadout()
	lo3 = L.apply_drop(lo3, 0, &"FIRE", 2)
	lo3 = L.apply_drop(lo3, 0, &"FIRE", 1)
	_check("no merge across tiers: FIRE t2 + FIRE t1 does not become t3", lo3[0].tier != 3, "got %d" % lo3[0].tier)

	## C3: allow_merge=false (slice merge-stub) -> no tier bump, marks "2/2"
	var lo4 = L.make_loadout()
	lo4 = L.apply_drop(lo4, 0, &"FIRE", 1)
	lo4 = L.apply_drop(lo4, 0, &"FIRE", 1, false)
	_check("allow_merge=false: tier stays 1", lo4[0].tier == 1, "got %d" % lo4[0].tier)
	_check("allow_merge=false: marks merge 2/2", String(lo4[0].get("merge", "")) == "2/2", "got %s" % str(lo4[0]))

	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

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
	add_child(label)
