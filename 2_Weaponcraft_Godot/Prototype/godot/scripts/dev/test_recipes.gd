## Test harness for scripts/core/recipes.gd.
##
## Builds Weapon objects out of real PartData from the catalog, then asserts the
## expected recipe activations. Prints PASS/FAIL lines per case + a summary.
##
## Run: scenes/dev/TestRecipes.tscn -> Play Scene (Ctrl+Shift+F5).
extends Control

const InventoryItemT = preload("res://scripts/data/inventory_item.gd")
const WeaponT = preload("res://scripts/data/weapon.gd")
const HeroStateT = preload("res://scripts/data/hero_state.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== Recipes engine tests ===")
	_test_empty_weapon_no_recipes()
	_test_pyro_pommel_alone_no_recipe()
	_test_pyro_pommel_plus_ice_rune_steamburst()
	_test_pyro_pommel_plus_fire_rune_inferno()
	_test_pattern_matches_helper()
	_test_tag_count_explicit_and_derived()
	_test_bonus_aggregation()
	_test_check_hero_for_discoveries_fires_once()
	_summary()
	_render_to_ui()

## ---------- Cases ----------

func _test_empty_weapon_no_recipes() -> void:
	var w = WeaponT.new()
	var active: Array = Recipes.get_active_recipes(w)
	_check("empty weapon: no recipes", active.is_empty(), "got %s" % str(active))

func _test_pyro_pommel_alone_no_recipe() -> void:
	var w = WeaponT.new()
	w.set_slot(&"hilt", InventoryItemT.new(1, &"p_pyro_pommel", 1))
	var counts: Dictionary = Recipes.weapon_tag_counts(w)
	var active: Array = Recipes.get_active_recipes(w)
	_check("pyro_pommel alone: fire=1, no recipe", counts.get(&"fire", 0) == 1 and active.is_empty(),
		"counts=%s active=%s" % [str(counts), str(active)])

func _test_pyro_pommel_plus_ice_rune_steamburst() -> void:
	var w = WeaponT.new()
	w.set_slot(&"hilt", InventoryItemT.new(2, &"p_pyro_pommel", 1))
	w.set_slot(&"rune", InventoryItemT.new(3, &"r_ice", 1))
	var active: Array = Recipes.get_active_recipes(w)
	_check("pyro_pommel + r_ice: Steamburst triggers",
		active.size() == 1 and active[0] == &"steamburst",
		"active=%s" % str(active))

func _test_pyro_pommel_plus_fire_rune_inferno() -> void:
	var w = WeaponT.new()
	w.set_slot(&"hilt", InventoryItemT.new(4, &"p_pyro_pommel", 1))
	w.set_slot(&"rune", InventoryItemT.new(5, &"r_fire", 1))
	var active: Array = Recipes.get_active_recipes(w)
	_check("pyro_pommel + r_fire: Inferno triggers",
		active.size() == 1 and active[0] == &"inferno",
		"active=%s" % str(active))

func _test_pattern_matches_helper() -> void:
	var counts := {&"fire": 2, &"ice": 1}
	_check("pattern [fire,fire] matches counts fire=2",
		Recipes.pattern_matches([&"fire", &"fire"], counts), "")
	_check("pattern [fire,ice] matches counts",
		Recipes.pattern_matches([&"fire", &"ice"], counts), "")
	_check("pattern [pierce,pierce] does NOT match",
		not Recipes.pattern_matches([&"pierce", &"pierce"], counts), "")
	_check("empty pattern does NOT match",
		not Recipes.pattern_matches([], counts), "")

func _test_tag_count_explicit_and_derived() -> void:
	## p_steel_grip (no tag) + r_fire (fire) — only fire shows up.
	var w = WeaponT.new()
	w.set_slot(&"hilt", InventoryItemT.new(10, &"p_steel_grip", 1))
	w.set_slot(&"rune", InventoryItemT.new(11, &"r_fire", 1))
	var counts: Dictionary = Recipes.weapon_tag_counts(w)
	_check("steel_grip + r_fire: fire=1, no derived tags",
		counts.get(&"fire", 0) == 1 and not counts.has(&"crit") and not counts.has(&"charge"),
		"counts=%s" % str(counts))

func _test_bonus_aggregation() -> void:
	## Build a weapon that activates BOTH recipes (Steamburst splash=0.35 + Inferno
	## stack_burn=0.12). Both are max() keys, so each individually appears in bonuses.
	## Need 2 fire tags (Inferno needs fire,fire) AND 1 ice tag (Steamburst needs fire,ice).
	## With 3 slots: pyro_pommel (fire) + r_fire (fire) + r_ice (ice) — Steamburst fires
	## (fire+ice) AND Inferno fires (fire,fire). But r_ice and r_fire share the same
	## slot (rune). So we can't have both runes equipped simultaneously.
	## Achievable instead with pyro_pommel (fire hilt) + r_fire (fire rune):
	## fire=2 -> Inferno only. Test that path.
	var w = WeaponT.new()
	w.set_slot(&"hilt", InventoryItemT.new(20, &"p_pyro_pommel", 1))
	w.set_slot(&"rune", InventoryItemT.new(21, &"r_fire", 1))
	var hero = HeroStateT.new(GameState.heroes_by_id[&"bran"])
	hero.weapon = w
	var bonuses: Dictionary = Recipes.get_recipe_bonuses(hero)
	_check("inferno bonus: stack_burn=0.12 + stack_cap=3 present",
		abs(float(bonuses.get(&"stack_burn", 0.0)) - 0.12) < 0.001 and
		int(bonuses.get(&"stack_cap", 0)) == 3,
		"bonuses=%s" % str(bonuses))

func _test_check_hero_for_discoveries_fires_once() -> void:
	## Reset GameState's discovered set for a clean check.
	GameState.discovered_recipes = {}
	GameState.pending_discoveries = []
	var fire_count := [0]
	GameState.recipe_discovered.connect(func(_rid): fire_count[0] += 1)

	var w = WeaponT.new()
	w.set_slot(&"hilt", InventoryItemT.new(30, &"p_pyro_pommel", 1))
	w.set_slot(&"rune", InventoryItemT.new(31, &"r_fire", 1))
	var hero = HeroStateT.new(GameState.heroes_by_id[&"bran"])
	hero.weapon = w

	Recipes.check_hero_for_discoveries(hero)
	Recipes.check_hero_for_discoveries(hero)  ## second call: should NOT re-fire
	_check("Inferno discovery fires exactly once on repeated check",
		fire_count[0] == 1, "fired=%d" % fire_count[0])

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
	## Also render to an on-screen Label so screenshots capture results without
	## scraping the editor Output panel.
	var label := Label.new()
	label.add_theme_font_size_override(&"font_size", 14)
	label.text = "\n".join(_lines)
	label.anchor_right = 1.0
	label.anchor_bottom = 1.0
	label.offset_left = 12
	label.offset_top = 12
	add_child(label)
