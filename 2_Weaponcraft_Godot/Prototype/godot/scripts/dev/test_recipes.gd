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
	AccountState.save_path = "user://account_test.json"
	AccountState.reset()
	_log("=== Recipes engine tests ===")
	_test_empty_weapon_no_recipes()
	_test_pyro_pommel_alone_no_recipe()
	_test_pyro_pommel_plus_ice_rune_steamburst()
	_test_pyro_pommel_plus_fire_rune_inferno()
	_test_pattern_matches_helper()
	_test_tag_count_explicit_and_derived()
	_test_bonus_aggregation()
	_test_check_hero_for_discoveries_fires_once()
	_test_permafrost_double_ice()
	_test_skewer_double_pierce()
	_test_razor_wind_derived_crit_plus_pierce()
	_test_hellfire_fire_plus_pierce()
	_test_frostbite_ice_plus_pierce()
	_test_quickdraw_derived_charge_plus_fire()
	_test_all_eight_recipes_registered()
	_summary()
	_render_to_ui()
	## Headless auto-quit with exit code = failure count (0 = all green).
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

## ---------- Cases ----------

func _test_empty_weapon_no_recipes() -> void:
	var w = WeaponT.new()
	var active: Array = Recipes.get_active_recipes(w)
	_check("empty weapon: no recipes", active.is_empty(), "got %s" % str(active))

func _test_pyro_pommel_alone_no_recipe() -> void:
	var w = WeaponT.new()
	w.set_slot(&"body", InventoryItemT.new(1, &"p_pyro_pommel", 1))
	var counts: Dictionary = Recipes.weapon_tag_counts(w)
	var active: Array = Recipes.get_active_recipes(w)
	_check("pyro_pommel alone: fire=1, no recipe", counts.get(&"fire", 0) == 1 and active.is_empty(),
		"counts=%s active=%s" % [str(counts), str(active)])

func _test_pyro_pommel_plus_ice_rune_steamburst() -> void:
	var w = WeaponT.new()
	w.set_slot(&"body", InventoryItemT.new(2, &"p_pyro_pommel", 1))
	w.set_slot(&"rune", InventoryItemT.new(3, &"r_ice", 1))
	var active: Array = Recipes.get_active_recipes(w)
	_check("pyro_pommel + r_ice: Steamburst triggers",
		active.size() == 1 and active[0] == &"steamburst",
		"active=%s" % str(active))

func _test_pyro_pommel_plus_fire_rune_inferno() -> void:
	var w = WeaponT.new()
	w.set_slot(&"body", InventoryItemT.new(4, &"p_pyro_pommel", 1))
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
	w.set_slot(&"body", InventoryItemT.new(10, &"p_steel_grip", 1))
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
	w.set_slot(&"body", InventoryItemT.new(20, &"p_pyro_pommel", 1))
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
	w.set_slot(&"body", InventoryItemT.new(30, &"p_pyro_pommel", 1))
	w.set_slot(&"rune", InventoryItemT.new(31, &"r_fire", 1))
	var hero = HeroStateT.new(GameState.heroes_by_id[&"bran"])
	hero.weapon = w

	Recipes.check_hero_for_discoveries(hero)
	Recipes.check_hero_for_discoveries(hero)  ## second call: should NOT re-fire
	_check("Inferno discovery fires exactly once on repeated check",
		fire_count[0] == 1, "fired=%d" % fire_count[0])

## ---------- New recipe cases (Stage C) ----------

func _test_permafrost_double_ice() -> void:
	## Permafrost = [ice, ice]. Frost Crown (head, ice) + r_ice (rune, ice) = fire 0, ice 2.
	var w = WeaponT.new()
	w.set_slot(&"head", InventoryItemT.new(40, &"h_frost_crown", 1))
	w.set_slot(&"rune", InventoryItemT.new(41, &"r_ice", 1))
	var active: Array = Recipes.get_active_recipes(w)
	_check("h_frost_crown + r_ice: Permafrost triggers",
		&"permafrost" in active and active.size() == 1,
		"active=%s" % str(active))

func _test_skewer_double_pierce() -> void:
	## Skewer = [pierce, pierce]. Thorn Spike (head, pierce) + r_pierce (rune, pierce).
	var w = WeaponT.new()
	w.set_slot(&"head", InventoryItemT.new(42, &"h_thorn_spike", 1))
	w.set_slot(&"rune", InventoryItemT.new(43, &"r_pierce", 1))
	var active: Array = Recipes.get_active_recipes(w)
	_check("h_thorn_spike + r_pierce: Skewer triggers",
		&"skewer" in active and active.size() == 1,
		"active=%s" % str(active))

func _test_razor_wind_derived_crit_plus_pierce() -> void:
	## Razor Wind = [crit, pierce]. crit is the derived tag (any part with crit > 0).
	## p_razor_grip (hilt, crit=10, no explicit tag) + r_pierce (rune, pierce) ->
	## explicit tags = [pierce]; derived = [crit] (crit% > 0). counts = {crit:1, pierce:1}.
	var w = WeaponT.new()
	w.set_slot(&"body", InventoryItemT.new(44, &"p_razor_grip", 1))
	w.set_slot(&"rune", InventoryItemT.new(45, &"r_pierce", 1))
	var counts: Dictionary = Recipes.weapon_tag_counts(w)
	var active: Array = Recipes.get_active_recipes(w)
	_check("p_razor_grip + r_pierce: crit derived + pierce -> Razor Wind",
		counts.get(&"crit", 0) == 1 and counts.get(&"pierce", 0) == 1
			and &"razor_wind" in active,
		"counts=%s active=%s" % [str(counts), str(active)])

func _test_hellfire_fire_plus_pierce() -> void:
	## Hellfire = [fire, pierce]. Pyro Visor (head, fire) + r_pierce (rune, pierce).
	## Also satisfies Steamburst's [fire, ice]? No — no ice. Should be Hellfire only.
	var w = WeaponT.new()
	w.set_slot(&"head", InventoryItemT.new(46, &"h_pyro_visor", 1))
	w.set_slot(&"rune", InventoryItemT.new(47, &"r_pierce", 1))
	var active: Array = Recipes.get_active_recipes(w)
	_check("h_pyro_visor + r_pierce: Hellfire triggers",
		&"hellfire" in active and not (&"steamburst" in active),
		"active=%s" % str(active))

func _test_frostbite_ice_plus_pierce() -> void:
	## Frostbite = [ice, pierce]. Frost Crown (head, ice) + r_pierce (rune, pierce).
	var w = WeaponT.new()
	w.set_slot(&"head", InventoryItemT.new(48, &"h_frost_crown", 1))
	w.set_slot(&"rune", InventoryItemT.new(49, &"r_pierce", 1))
	var active: Array = Recipes.get_active_recipes(w)
	_check("h_frost_crown + r_pierce: Frostbite triggers",
		&"frostbite" in active and active.size() == 1,
		"active=%s" % str(active))

func _test_quickdraw_derived_charge_plus_fire() -> void:
	## Quickdraw = [charge, fire]. charge = derived tag (any part with ult_rate > 0).
	## Lightning Grip (hilt, ult_rate=12, no explicit tag) + r_fire (rune, fire).
	## counts = {fire:1, charge:1}.
	var w = WeaponT.new()
	w.set_slot(&"body", InventoryItemT.new(50, &"p_lightning_grip", 1))
	w.set_slot(&"rune", InventoryItemT.new(51, &"r_fire", 1))
	var counts: Dictionary = Recipes.weapon_tag_counts(w)
	var active: Array = Recipes.get_active_recipes(w)
	_check("p_lightning_grip + r_fire: charge derived + fire -> Quickdraw",
		counts.get(&"charge", 0) == 1 and counts.get(&"fire", 0) == 1
			and &"quickdraw" in active,
		"counts=%s active=%s" % [str(counts), str(active)])

func _test_all_eight_recipes_registered() -> void:
	## Sanity: all 8 recipe ids load from data/recipes/. Catches typos in file
	## names or missing tres parse.
	var expected := [&"steamburst", &"inferno", &"permafrost", &"skewer",
		&"razor_wind", &"hellfire", &"frostbite", &"quickdraw"]
	var missing: Array = []
	for rid in expected:
		if GameState.get_recipe_def(rid) == null:
			missing.append(rid)
	_check("all 8 recipes registered in GameState.recipes_by_id",
		missing.is_empty(),
		"missing=%s registered=%s" % [str(missing), str(GameState.recipe_ids)])

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
