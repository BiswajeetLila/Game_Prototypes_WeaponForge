## Test harness for scripts/core/merge.gd.
##
## Covers the full 4-step acquire priority + equip_from_inventory +
## unequip_to_inventory + end-to-end Shop.buy → Merge.acquire_part round-trip.
##
## Run: scenes/dev/TestMerge.tscn -> Play Scene (Ctrl+Shift+F5).
extends Control

const InventoryItemT = preload("res://scripts/data/inventory_item.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== Merge tests ===")
	_test_acquire_into_empty_slot()
	_test_acquire_levels_up_equipped_duplicate()
	_test_acquire_different_partid_in_slot_goes_to_inventory()
	_test_acquire_levels_up_inventory_duplicate()
	_test_acquire_at_cap_drops_fresh_to_inventory()
	_test_equip_from_inventory_into_empty_slot()
	_test_equip_from_inventory_swaps_existing()
	_test_equip_from_inventory_levels_up_same_partid()
	_test_unequip_returns_to_inventory()
	_test_shop_buy_round_trip()
	_test_buy_with_insufficient_gold_refunded()
	_test_level_multiplier_table()
	_summary()
	_render_to_ui()

## ---------- Cases ----------

func _test_acquire_into_empty_slot() -> void:
	GameState.new_session()
	var item = Merge.acquire_part(&"h_iron_edge")
	var equipped = GameState.hero.weapon.get_slot(&"head")
	_check("acquire into empty head slot: equipped L1",
		item != null and equipped == item and equipped.level == 1,
		"item=%s equipped=%s" % [str(item), str(equipped)])

func _test_acquire_levels_up_equipped_duplicate() -> void:
	GameState.new_session()
	Merge.acquire_part(&"h_iron_edge")        ## L1 in head
	Merge.acquire_part(&"h_iron_edge")        ## should level up -> L2
	var equipped = GameState.hero.weapon.get_slot(&"head")
	_check("acquire duplicate of equipped: head levels to L2",
		equipped != null and equipped.level == 2 and GameState.inventory.is_empty(),
		"level=%d inv=%d" % [equipped.level if equipped != null else -1, GameState.inventory.size()])

func _test_acquire_different_partid_in_slot_goes_to_inventory() -> void:
	## Empty Bran -> acquire h_iron_edge (equipped). Then acquire ... there's no
	## other warrior HEAD in our 5-part catalog. So instead test with the HILT slot:
	## acquire p_steel_grip (equipped), then acquire p_pyro_pommel — different
	## partId in same slot -> goes to inventory (step 4).
	GameState.new_session()
	Merge.acquire_part(&"p_steel_grip")       ## hilt L1
	Merge.acquire_part(&"p_pyro_pommel")      ## hilt occupied, different partId -> inventory
	var equipped = GameState.hero.weapon.get_slot(&"hilt")
	var inv_ok: bool = GameState.inventory.size() == 1 and GameState.inventory[0].part_id == &"p_pyro_pommel"
	_check("different-partId in slot: new part lands in inventory L1",
		equipped != null and equipped.part_id == &"p_steel_grip" and inv_ok,
		"equipped=%s inv_size=%d" % [str(equipped.part_id) if equipped else "null",
			GameState.inventory.size()])

func _test_acquire_levels_up_inventory_duplicate() -> void:
	GameState.new_session()
	## Pre-seed inventory with an L1 r_fire (no equipped rune so this is artificial,
	## but exercises step 3 directly).
	GameState.inventory.append(InventoryItemT.new(GameState.next_uid(), &"r_fire", 1))
	## Pre-block the rune slot with r_ice so step 2 (empty slot) is skipped.
	GameState.hero.weapon.set_slot(&"rune", InventoryItemT.new(GameState.next_uid(), &"r_ice", 1))
	Merge.acquire_part(&"r_fire")             ## should level inventory r_fire -> L2
	var inv_fire = null
	for item in GameState.inventory:
		if item.part_id == &"r_fire":
			inv_fire = item
			break
	_check("acquire duplicate of inventory item: levels up to L2",
		inv_fire != null and inv_fire.level == 2,
		"level=%d" % (inv_fire.level if inv_fire else -1))

func _test_acquire_at_cap_drops_fresh_to_inventory() -> void:
	GameState.new_session()
	## Force an L5 r_fire into the rune slot.
	GameState.hero.weapon.set_slot(&"rune", InventoryItemT.new(GameState.next_uid(), &"r_fire", 5))
	Merge.acquire_part(&"r_fire")
	var equipped = GameState.hero.weapon.get_slot(&"rune")
	var inv_fresh: bool = GameState.inventory.size() == 1 and GameState.inventory[0].part_id == &"r_fire" and GameState.inventory[0].level == 1
	_check("acquire duplicate at L5 cap: fresh L1 to inventory (no loss)",
		equipped != null and equipped.level == 5 and inv_fresh,
		"equipped.level=%d inv=%d" % [equipped.level if equipped else -1, GameState.inventory.size()])

func _test_equip_from_inventory_into_empty_slot() -> void:
	GameState.new_session()
	var inv_item = InventoryItemT.new(GameState.next_uid(), &"r_fire", 3)
	GameState.inventory.append(inv_item)
	var ok: bool = Merge.equip_from_inventory(inv_item)
	var equipped = GameState.hero.weapon.get_slot(&"rune")
	_check("equip_from_inventory into empty slot: moves item, inventory empty",
		ok and equipped == inv_item and GameState.inventory.is_empty(),
		"ok=%s inv=%d" % [str(ok), GameState.inventory.size()])

func _test_equip_from_inventory_swaps_existing() -> void:
	GameState.new_session()
	var current = InventoryItemT.new(GameState.next_uid(), &"r_ice", 2)
	GameState.hero.weapon.set_slot(&"rune", current)
	var inv_item = InventoryItemT.new(GameState.next_uid(), &"r_fire", 1)
	GameState.inventory.append(inv_item)
	var ok: bool = Merge.equip_from_inventory(inv_item)
	var equipped = GameState.hero.weapon.get_slot(&"rune")
	_check("equip_from_inventory with different-partId in slot: swap, displaced -> inventory",
		ok and equipped == inv_item and GameState.inventory.size() == 1 and GameState.inventory[0] == current,
		"ok=%s equipped=%s inv=%s" % [str(ok), str(equipped.part_id) if equipped else "null", str(GameState.inventory.size())])

func _test_equip_from_inventory_levels_up_same_partid() -> void:
	GameState.new_session()
	var current = InventoryItemT.new(GameState.next_uid(), &"r_fire", 2)
	GameState.hero.weapon.set_slot(&"rune", current)
	var dup = InventoryItemT.new(GameState.next_uid(), &"r_fire", 1)
	GameState.inventory.append(dup)
	var ok: bool = Merge.equip_from_inventory(dup)
	var equipped = GameState.hero.weapon.get_slot(&"rune")
	_check("equip_from_inventory with same-partId in slot: levels equipped L3, source removed",
		ok and equipped == current and current.level == 3 and GameState.inventory.is_empty(),
		"current.level=%d inv=%d" % [current.level, GameState.inventory.size()])

func _test_unequip_returns_to_inventory() -> void:
	GameState.new_session()
	Merge.acquire_part(&"h_iron_edge")
	var ok: bool = Merge.unequip_to_inventory(&"head")
	_check("unequip_to_inventory: slot cleared, item in inventory",
		ok and GameState.hero.weapon.get_slot(&"head") == null and GameState.inventory.size() == 1,
		"ok=%s head=%s inv=%d" % [str(ok), str(GameState.hero.weapon.get_slot(&"head")), GameState.inventory.size()])

func _test_shop_buy_round_trip() -> void:
	GameState.new_session()
	## Inject a known shop: just h_iron_edge in slot 0 (so we know what we're buying).
	GameState.shop_parts = [&"h_iron_edge", null, null, null, null]
	var gold_before: int = GameState.gold
	var ok: bool = Shop.buy(0)
	var def = GameState.get_part_def(&"h_iron_edge")
	var equipped = GameState.hero.weapon.get_slot(&"head")
	_check("Shop.buy → Merge round-trip: gold deducted, part equipped, shop slot cleared",
		ok and GameState.gold == (gold_before - def.cost) and equipped != null and equipped.part_id == &"h_iron_edge" and GameState.shop_parts[0] == null,
		"ok=%s gold=%d slot0=%s" % [str(ok), GameState.gold, str(GameState.shop_parts[0])])

func _test_buy_with_insufficient_gold_refunded() -> void:
	GameState.new_session()
	GameState.gold = 1
	GameState.emit_signal(&"gold_changed", 1)
	GameState.shop_parts = [&"h_iron_edge", null, null, null, null]
	var ok: bool = Shop.buy(0)
	_check("Shop.buy with insufficient gold: returns false, no state change",
		not ok and GameState.gold == 1 and GameState.shop_parts[0] == &"h_iron_edge",
		"ok=%s gold=%d" % [str(ok), GameState.gold])

func _test_level_multiplier_table() -> void:
	_check("level_multiplier L1 = 1.00", abs(Merge.level_multiplier(1) - 1.00) < 0.001, "")
	_check("level_multiplier L5 = 3.70", abs(Merge.level_multiplier(5) - 3.70) < 0.001, "")
	_check("level_multiplier clamps L0 -> L1", abs(Merge.level_multiplier(0) - 1.00) < 0.001, "")
	_check("level_multiplier clamps L99 -> L5", abs(Merge.level_multiplier(99) - 3.70) < 0.001, "")

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
	label.add_theme_font_size_override(&"font_size", 13)
	label.text = "\n".join(_lines)
	label.anchor_right = 1.0
	label.anchor_bottom = 1.0
	label.offset_left = 12
	label.offset_top = 12
	add_child(label)
