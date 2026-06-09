## Test harness for CatalystData (10-compound table) + CatalystResolver (cap-1/no-cap).
## Spec: docs/superpowers/specs/2026-06-09-catalyst-design.md
##
## Run via godot MCP:
##   mcp__godot__run_project(projectPath, scene="res://scenes/dev/TestCatalyst.tscn")
##   mcp__godot__get_debug_output — find "=== N passed / M failed ==="
## Headless self-quits with exit code = failure count.
extends Control

const CatalystDataT = preload("res://scripts/data/catalyst_data.gd")
const CatalystResolverT = preload("res://scripts/core/catalyst_resolver.gd")
const WeaponDataT = preload("res://scripts/data/weapon_data.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== CatalystData + CatalystResolver tests ===")
	_test_compounds_returns_ten_records()
	_test_for_pair_order_independent()
	_test_for_pair_empty_element_rejected()
	_test_resolve_empty_squad_returns_neutral()
	_test_resolve_single_pair_cap1()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_compounds_returns_ten_records() -> void:
	## Spec §2: 6 active FTUE compounds + 4 Earth-gated = 10 total.
	var rows: Array = CatalystDataT.compounds()
	_check("compounds() returns 10 records", rows.size() == 10, "size=%d" % rows.size())
	var earth_gated: int = 0
	for r in rows:
		if int(r.get("gated_from_stage", 0)) >= 10:
			earth_gated += 1
	_check("4 records gated from stage 10", earth_gated == 4, "count=%d" % earth_gated)

## ---------- for_pair ----------

func _test_for_pair_order_independent() -> void:
	## Spec §4 + §9 case C-2: for_pair(fire, ice) == for_pair(ice, fire) == Firestorm.
	var ab: Dictionary = CatalystDataT.for_pair(&"fire", &"ice")
	var ba: Dictionary = CatalystDataT.for_pair(&"ice", &"fire")
	_check("for_pair(fire,ice) returns Firestorm", ab.get("id", &"") == &"firestorm",
		"id=%s" % ab.get("id", &""))
	_check("for_pair is order-independent", ab.get("pair_key", &"") == ba.get("pair_key", &""),
		"ab=%s ba=%s" % [ab.get("pair_key"), ba.get("pair_key")])

func _test_for_pair_empty_element_rejected() -> void:
	## Spec §4 + §9 case C-3: empty-element inputs return {} (non-elemental starters skip).
	var r: Dictionary = CatalystDataT.for_pair(&"", &"ice")
	_check("for_pair with empty element returns {}", r.is_empty(), "id=%s" % r.get("id"))
	var same: Dictionary = CatalystDataT.for_pair(&"fire", &"fire")
	_check("for_pair with same-element returns {}", same.is_empty(), "id=%s" % same.get("id"))

## ---------- resolver ----------

func _test_resolve_empty_squad_returns_neutral() -> void:
	## Spec §9 C-4: 2 non-elemental + 1 fire at stage 1 -> null compound, EMPTY_BAG.
	var squad: Array = [_make_weapon(&""), _make_weapon(&""), _make_weapon(&"fire")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 1)
	_check("resolve returns dict", typeof(r) == TYPE_DICTIONARY, "type=%d" % typeof(r))
	_check("resolve null compound (1 element only)", r.get("compound", null) == null,
		"compound=%s" % str(r.get("compound")))
	_check("resolve bag == EMPTY_BAG", _bags_equal(r.get("merged_bag", {}), CatalystDataT.EMPTY_BAG),
		"bag=%s" % str(r.get("merged_bag")))

func _test_resolve_single_pair_cap1() -> void:
	## Spec §9 C-5 partial: fire+ice squad at stage 1 -> Firestorm.
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"ice"), _make_weapon(&"")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 1)
	var c: Dictionary = r.get("compound", {})
	_check("fire+ice at stage 1 -> Firestorm", c.get("id", &"") == &"firestorm",
		"id=%s" % c.get("id", &""))
	_check("Firestorm bag has +20%% atk",
		is_equal_approx(float(r["merged_bag"].get(&"squad_atk_mult", 1.0)), 1.20),
		"mult=%f" % float(r["merged_bag"].get(&"squad_atk_mult", 1.0)))

## ---------- fixtures ----------

func _make_weapon(rune: StringName) -> Resource:
	var w = WeaponDataT.new()
	w.rune = rune
	w.base_atk = 10
	return w

## Order-tolerant bag comparison — bags are float-valued; equality uses is_equal_approx.
func _bags_equal(a: Dictionary, b: Dictionary) -> bool:
	if a.size() != b.size():
		return false
	for k in a:
		if not b.has(k):
			return false
		if typeof(a[k]) == TYPE_FLOAT and not is_equal_approx(float(a[k]), float(b[k])):
			return false
	return true

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
