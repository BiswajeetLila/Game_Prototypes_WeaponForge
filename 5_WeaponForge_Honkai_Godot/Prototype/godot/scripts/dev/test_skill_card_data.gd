## Test harness for scripts/data/skill_card_data.gd — the Forge Draft card schema (P1a).
##
## Forge Draft (spec §10): after each wave 3 skill cards appear (5 on boss waves),
## each TAGGED to a specific hero and modifying one of their abilities / weapons /
## runes. Four card types: hero / weapon / ability / rune. No inventory — unpicked
## cards vanish. This schema is the data definition of one such card; the draft flow
## (P1c) will consume it. GameState skips catalog resources missing an id, so cards
## expose an is_valid() guard mirroring that loader behavior.
##
## Run headless:
##   Godot_v4.6.2-stable_mono_win64_console.exe --headless --path <godot dir> \
##     res://scenes/dev/TestSkillCardData.tscn
extends Control

const SCRIPT_PATH := "res://scripts/data/skill_card_data.gd"

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []
var _Card = null

func _ready() -> void:
	_log("=== SkillCardData (Forge Draft card schema) tests ===")
	## load() (not preload) so this harness still compiles in RED, before the class exists.
	_Card = load(SCRIPT_PATH) if ResourceLoader.exists(SCRIPT_PATH) else null
	_check("SkillCardData script exists at " + SCRIPT_PATH, _Card != null, "not found")
	if _Card != null:
		_test_valid_card()
		_test_four_canonical_types_are_valid()
		_test_unknown_type_is_invalid()
		_test_missing_id_is_invalid()
		_test_missing_hero_tag_is_invalid()
		_test_applies_to_tagged_hero_only()
	_summary()
	_render_to_ui()
	## Headless auto-quit with exit code = failure count (0 = all green).
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _make(id: StringName, card_type: StringName, hero_id: StringName):
	var c = _Card.new()
	c.id = id
	c.card_type = card_type
	c.hero_id = hero_id
	return c

## ---------- Cases ----------

func _test_valid_card() -> void:
	## A fully-specified ability card tagged to Bran is valid.
	var c = _make(&"ab_storm_split", _Card.TYPE_ABILITY, &"bran")
	_check("valid card: is_valid_type()", c.is_valid_type(), "type=%s" % c.card_type)
	_check("valid card: is_valid()", c.is_valid(),
		"id=%s type=%s hero=%s" % [c.id, c.card_type, c.hero_id])

func _test_four_canonical_types_are_valid() -> void:
	## Spec §10: exactly four card types — hero / weapon / ability / rune.
	for t in [_Card.TYPE_HERO, _Card.TYPE_WEAPON, _Card.TYPE_ABILITY, _Card.TYPE_RUNE]:
		var c = _make(&"x", t, &"bran")
		_check("type '%s' is a valid card type" % t, c.is_valid_type(), "rejected")
	_check("exactly 4 canonical card types", _Card.CARD_TYPES.size() == 4,
		"got %d" % _Card.CARD_TYPES.size())

func _test_unknown_type_is_invalid() -> void:
	## A card_type outside the four canonical types is rejected.
	var c = _make(&"weird", &"potion", &"bran")
	_check("unknown type: is_valid_type() false", c.is_valid_type() == false, "accepted 'potion'")
	_check("unknown type: is_valid() false", c.is_valid() == false, "accepted invalid card")

func _test_missing_id_is_invalid() -> void:
	## Mirrors GameState catalog validation (skip resources missing .id).
	var c = _make(&"", _Card.TYPE_HERO, &"bran")
	_check("missing id: is_valid() false", c.is_valid() == false, "accepted empty id")

func _test_missing_hero_tag_is_invalid() -> void:
	## Cards are hero-tagged (spec §10); an untagged card is invalid.
	var c = _make(&"hp_up", _Card.TYPE_HERO, &"")
	_check("missing hero_id: is_valid() false", c.is_valid() == false, "accepted untagged card")

func _test_applies_to_tagged_hero_only() -> void:
	var c = _make(&"ab_chain", _Card.TYPE_ABILITY, &"elara")
	_check("applies_to tagged hero (elara)", c.applies_to(&"elara"), "should match")
	_check("does NOT apply to other hero (bran)", c.applies_to(&"bran") == false, "should not match")

## ---------- Test helpers ----------

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
