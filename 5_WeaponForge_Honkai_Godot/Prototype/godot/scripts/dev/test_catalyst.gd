## Test harness for CatalystData (10-compound table) + CatalystResolver (no-cap from stage 1).
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
	_test_resolve_alpha_winner_at_stage1()
	_test_resolve_alpha_winner_at_stage4()
	_test_resolve_nocap_at_stage5()
	_test_resolve_three_same_element_null()
	_test_resolve_compose_math_explicit()
	_test_earth_pair_skipped_below_stage10()
	_test_earth_pair_triggers_at_stage10()
	_test_stormfront_swarm_field_present()
	_test_resolve_nocap_compounds_alpha_sorted()
	_test_format_effect_default_atk()
	_test_format_effect_default_crit_only()
	_test_format_effect_default_enemy_atk_spd()
	_test_format_effect_default_swarm()
	_test_format_effect_compact_labels()
	_test_format_effect_neutral_bag_returns_dash()
	_test_format_effect_neutral_bag_custom_empty_str()
	_test_format_effect_glyph_prefix()
	_test_format_effect_glyph_prefix_neutral_bag()
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

func _test_resolve_alpha_winner_at_stage1() -> void:
	## Post-cap-1-removal: stage 1 with 3-element squad returns ALL 3 triggering
	## compounds. The primary `compound` field still picks the alpha winner
	## (Blizzard < Firestorm < Wildfire by alphabetical_priority).
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"ice"), _make_weapon(&"wind")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 1)
	_check("3-element squad at stage 1 -> compound = Blizzard (alpha winner)",
		r["compound"].get("id", &"") == &"blizzard",
		"id=%s" % r["compound"].get("id", &""))
	_check("3-element squad at stage 1 -> 3 compounds active (no-cap from stage 1)",
		(r["compounds"] as Array).size() == 3,
		"size=%d" % (r["compounds"] as Array).size())

func _test_resolve_alpha_winner_at_stage4() -> void:
	## Stage 4 same as any other no-cap stage: 3 compounds active, alpha winner
	## as primary `compound`.
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"ice"), _make_weapon(&"wind")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 4)
	_check("stage 4 no-cap -> compound = Blizzard (alpha winner)",
		r["compound"].get("id", &"") == &"blizzard",
		"id=%s" % r["compound"].get("id", &""))
	_check("stage 4 no-cap -> 3 compounds active",
		(r["compounds"] as Array).size() == 3,
		"size=%d" % (r["compounds"] as Array).size())

func _test_resolve_nocap_at_stage5() -> void:
	## Spec §9 C-6: fire+ice+wind at stage 5 -> 3 compounds (Firestorm + Wildfire + Blizzard),
	## bags compose multiplicatively. Order in the list = alpha priority for stability.
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"ice"), _make_weapon(&"wind")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 5)
	_check("stage 5 no-cap: 3 compounds active", (r["compounds"] as Array).size() == 3,
		"size=%d" % (r["compounds"] as Array).size())
	## Compose: Firestorm 1.20 * Wildfire 1.15 * Blizzard 1.0 = 1.38. Crit additive: Wildfire 0.10.
	## Blizzard sets enemy_atk_speed_mult 0.80.
	var bag: Dictionary = r["merged_bag"]
	_check("merged squad_atk_mult = 1.20 * 1.15 = 1.38",
		is_equal_approx(float(bag.get(&"squad_atk_mult", 1.0)), 1.20 * 1.15),
		"mult=%f" % float(bag.get(&"squad_atk_mult", 1.0)))
	_check("merged squad_crit_add = 0.10",
		is_equal_approx(float(bag.get(&"squad_crit_add", 0.0)), 0.10),
		"add=%f" % float(bag.get(&"squad_crit_add", 0.0)))
	_check("merged enemy_atk_speed_mult = 0.80",
		is_equal_approx(float(bag.get(&"enemy_atk_speed_mult", 1.0)), 0.80),
		"mult=%f" % float(bag.get(&"enemy_atk_speed_mult", 1.0)))

func _test_resolve_three_same_element_null() -> void:
	## Spec §9 C-8: 3 same-element squad -> null compound (no pair).
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"fire"), _make_weapon(&"fire")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 5)
	_check("same-element squad -> null compound", r.get("compound", null) == null,
		"compound=%s" % str(r.get("compound")))
	_check("same-element squad -> bag is EMPTY_BAG", _bags_equal(r["merged_bag"], CatalystDataT.EMPTY_BAG),
		"bag=%s" % str(r["merged_bag"]))

func _test_resolve_compose_math_explicit() -> void:
	## Spec §9 case C-9: explicit ADDITIVE compose math — Wildfire 0.10 + Plasma 0.15
	## crit add = 0.25. Squad: fire+wind+electric at stage 5 (no-cap).
	## Triggered compounds: Wildfire (atk 1.15, crit +0.10), Plasma (atk 1.0, crit +0.15),
	## Stormfront (atk 1.0, swarm 1.25). atk = 1.15 * 1.0 * 1.0 = 1.15. crit = 0.25.
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"wind"), _make_weapon(&"electric")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 5)
	_check("compose: 3 compounds active (Wildfire+Plasma+Stormfront)",
		(r["compounds"] as Array).size() == 3,
		"size=%d" % (r["compounds"] as Array).size())
	## Only Wildfire has a non-1.0 atk mult.
	_check("compose atk_mult = 1.15 (Wildfire alone, others 1.0)",
		is_equal_approx(float(r["merged_bag"][&"squad_atk_mult"]), 1.15),
		"mult=%f" % float(r["merged_bag"][&"squad_atk_mult"]))
	## ADDITIVE: 0.10 (Wildfire) + 0.15 (Plasma) + 0.0 (Stormfront) = 0.25.
	_check("compose ADDITIVE crit 0.10 + 0.15 = 0.25",
		is_equal_approx(float(r["merged_bag"][&"squad_crit_add"]), 0.25),
		"add=%f" % float(r["merged_bag"][&"squad_crit_add"]))
	## Stormfront's swarm mult also lands in the merged bag.
	_check("compose swarm_mult = 1.25 (Stormfront)",
		is_equal_approx(float(r["merged_bag"][&"squad_atk_vs_swarm_mult"]), 1.25),
		"swarm=%f" % float(r["merged_bag"][&"squad_atk_vs_swarm_mult"]))

func _test_earth_pair_skipped_below_stage10() -> void:
	## Spec §9 case C-7 + §5: Earth-pair compounds skip when stage < 10.
	## fire+earth at stage 9 -> no compound (Volcanic gated).
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"earth"), _make_weapon(&"")]
	var r9: Dictionary = CatalystResolverT.resolve(squad, 9)
	_check("fire+earth at stage 9 -> no compound (gated)", r9.get("compound", null) == null,
		"compound=%s" % str(r9.get("compound")))
	_check("fire+earth at stage 9 -> EMPTY_BAG", _bags_equal(r9["merged_bag"], CatalystDataT.EMPTY_BAG),
		"bag=%s" % str(r9["merged_bag"]))

func _test_earth_pair_triggers_at_stage10() -> void:
	## Spec §9 case C-7: at stage 10, the Earth gate opens. fire+earth -> Volcanic.
	## Single-pair squad -> 1 triggering compound in the `compounds` array.
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"earth"), _make_weapon(&"")]
	var r10: Dictionary = CatalystResolverT.resolve(squad, 10)
	var compounds: Array = r10.get("compounds", [])
	_check("fire+earth at stage 10 -> 1 triggered compound", compounds.size() == 1,
		"size=%d" % compounds.size())
	var first_id: StringName = (compounds[0] as Dictionary).get("id", &"") if compounds.size() > 0 else &""
	_check("fire+earth at stage 10 -> Volcanic", first_id == &"volcanic",
		"id=%s" % first_id)

func _test_stormfront_swarm_field_present() -> void:
	## Spec §9 C-11 surface: the merged bag carries squad_atk_vs_swarm_mult = 1.25 when
	## Stormfront triggers (wind+electric). Combat applies the actual >=3-enemies check
	## conditionally inside hit-resolution (covered by TestCombat in Chunk C).
	var squad: Array = [_make_weapon(&"wind"), _make_weapon(&"electric"), _make_weapon(&"")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 1)
	_check("Stormfront at stage 1 (single pair)", r["compound"].get("id", &"") == &"stormfront",
		"id=%s" % r["compound"].get("id", &""))
	_check("Stormfront bag carries squad_atk_vs_swarm_mult=1.25",
		is_equal_approx(float(r["merged_bag"][&"squad_atk_vs_swarm_mult"]), 1.25),
		"swarm=%f" % float(r["merged_bag"][&"squad_atk_vs_swarm_mult"]))

func _test_resolve_nocap_compounds_alpha_sorted() -> void:
	## C1 cleanup: at stage >= 5 the compounds[] array MUST be sorted alpha-priority
	## so callers picking compounds[0] get a stable, predictable winner regardless
	## of squad equip order. Squad: fire+ice+wind at stage 5 -> Blizzard < Firestorm
	## < Wildfire (alphabetical_priority indices 0, 1, 5 per CatalystData).
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"ice"), _make_weapon(&"wind")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 5)
	var compounds_arr: Array = r["compounds"]
	_check("no-cap compounds size 3", compounds_arr.size() == 3,
		"size=%d" % compounds_arr.size())
	if compounds_arr.size() == 3:
		_check("compounds[0] is Blizzard (alpha winner)",
			compounds_arr[0]["id"] == &"blizzard", "id=%s" % compounds_arr[0]["id"])
		_check("compounds[1] is Firestorm",
			compounds_arr[1]["id"] == &"firestorm", "id=%s" % compounds_arr[1]["id"])
		_check("compounds[2] is Wildfire",
			compounds_arr[2]["id"] == &"wildfire", "id=%s" % compounds_arr[2]["id"])

## ---------- format_effect (C5 cleanup: triplicated formatters consolidated) ----------

func _test_format_effect_default_atk() -> void:
	## Firestorm: +20% squad_atk_mult only. Defaults: no glyph, no compact, empty_str "—".
	var rec: Dictionary = CatalystDataT.for_pair(&"fire", &"ice")
	var s: String = CatalystDataT.format_effect(rec)
	_check("format_effect Firestorm default = '+20% squad ATK'",
		s == "+20% squad ATK", "got=%s" % s)

func _test_format_effect_default_crit_only() -> void:
	## Plasma: +15% crit only.
	var rec: Dictionary = CatalystDataT.for_pair(&"fire", &"electric")
	var s: String = CatalystDataT.format_effect(rec)
	_check("format_effect Plasma default = '+15% crit'",
		s == "+15% crit", "got=%s" % s)

func _test_format_effect_default_enemy_atk_spd() -> void:
	## Blizzard: enemy_atk_speed_mult 0.80 -> "-20% enemy atk-spd".
	var rec: Dictionary = CatalystDataT.for_pair(&"ice", &"wind")
	var s: String = CatalystDataT.format_effect(rec)
	_check("format_effect Blizzard default = '-20% enemy atk-spd'",
		s == "-20% enemy atk-spd", "got=%s" % s)

func _test_format_effect_default_swarm() -> void:
	## Stormfront: squad_atk_vs_swarm_mult 1.25 -> "+25% ATK vs swarm" (default label).
	var rec: Dictionary = CatalystDataT.for_pair(&"wind", &"electric")
	var s: String = CatalystDataT.format_effect(rec)
	_check("format_effect Stormfront default = '+25% ATK vs swarm'",
		s == "+25% ATK vs swarm", "got=%s" % s)

func _test_format_effect_compact_labels() -> void:
	## compact=true shortens "squad ATK"->"ATK" and "ATK vs swarm"->"vs swarm" (codex usage).
	var firestorm: Dictionary = CatalystDataT.for_pair(&"fire", &"ice")
	var stormfront: Dictionary = CatalystDataT.for_pair(&"wind", &"electric")
	var s1: String = CatalystDataT.format_effect(firestorm, {"compact": true})
	var s2: String = CatalystDataT.format_effect(stormfront, {"compact": true})
	_check("format_effect compact Firestorm = '+20% ATK'",
		s1 == "+20% ATK", "got=%s" % s1)
	_check("format_effect compact Stormfront = '+25% vs swarm'",
		s2 == "+25% vs swarm", "got=%s" % s2)

func _test_format_effect_neutral_bag_returns_dash() -> void:
	## A record with an all-neutral bag returns the canonical "—" empty string.
	var rec: Dictionary = {"elements": [&"fire", &"ice"], "modifier_bag": CatalystDataT.EMPTY_BAG}
	var s: String = CatalystDataT.format_effect(rec)
	_check("format_effect neutral bag = '—'", s == "—", "got=%s" % s)

func _test_format_effect_neutral_bag_custom_empty_str() -> void:
	## empty_str opt overrides the dash (legacy call sites can opt into "no effect" etc).
	var rec: Dictionary = {"elements": [&"fire", &"ice"], "modifier_bag": CatalystDataT.EMPTY_BAG}
	var s: String = CatalystDataT.format_effect(rec, {"empty_str": "no effect"})
	_check("format_effect neutral bag custom empty_str = 'no effect'",
		s == "no effect", "got=%s" % s)

func _test_format_effect_glyph_prefix() -> void:
	## glyph_prefix=true prepends "🔥+❄   " (3-space tail; banner usage).
	var rec: Dictionary = CatalystDataT.for_pair(&"fire", &"ice")
	var s: String = CatalystDataT.format_effect(rec, {"glyph_prefix": true})
	_check("format_effect glyph_prefix Firestorm = '🔥+❄   +20% squad ATK'",
		s == "🔥+❄   +20% squad ATK", "got=%s" % s)

func _test_format_effect_glyph_prefix_neutral_bag() -> void:
	## glyph_prefix + neutral bag still prefixes the elements; body is the empty_str.
	var rec: Dictionary = {"elements": [&"fire", &"ice"], "modifier_bag": CatalystDataT.EMPTY_BAG}
	var s: String = CatalystDataT.format_effect(rec, {"glyph_prefix": true})
	_check("format_effect glyph_prefix + neutral bag = '🔥+❄   —'",
		s == "🔥+❄   —", "got=%s" % s)

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
