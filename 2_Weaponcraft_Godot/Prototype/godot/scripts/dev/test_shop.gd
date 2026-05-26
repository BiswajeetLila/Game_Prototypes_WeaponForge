## Test harness for scripts/core/shop.gd.
##
## Covers refresh(), reroll(), eligibility filtering, slot-coverage guarantee.
## Buy() flow is exercised in Chunk C's TestMerge once merge.gd is real.
##
## Run: scenes/dev/TestShop.tscn -> Play Scene (Ctrl+Shift+F5).
extends Control

const InventoryItemT = preload("res://scripts/data/inventory_item.gd")
const WeaponT = preload("res://scripts/data/weapon.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== Shop tests ===")
	_test_refresh_free_produces_five_parts()
	_test_eligibility_warrior_and_universal_only()
	_test_slot_coverage_when_bran_empty()
	_test_slot_coverage_satisfied_when_kitted()
	_test_reroll_deducts_two_gold()
	_test_reroll_blocked_when_gold_short()
	_test_shop_changed_signal_emits()
	## Heal potion (consumable) cases.
	_test_potion_partdata_exists_with_flag()
	_test_regular_parts_not_consumable()
	_test_potion_appears_on_w1()
	_test_potion_appears_on_w4()
	_test_potion_appears_on_w7()
	_test_potion_appears_on_w10()
	_test_potion_absent_on_w2()
	_test_potion_absent_on_w3()
	_test_potion_absent_on_w5()
	_test_potion_absent_on_w6()
	_test_potion_absent_on_w8()
	_test_potion_absent_on_w9()
	_test_potion_not_in_eligible_pool()
	_test_potion_buy_heals_all_alive_50pct()
	_test_potion_buy_skips_dead_heroes()
	_test_potion_buy_caps_at_max_hp()
	_test_potion_buy_blocked_when_gold_short()
	_test_potion_buy_does_not_call_merge()
	_test_potion_buy_does_not_enter_inventory()
	_summary()
	_render_to_ui()

## ---------- Cases ----------

func _test_refresh_free_produces_five_parts() -> void:
	GameState.new_session()
	Shop.refresh(true)
	var size: int = GameState.shop_parts.size()
	var non_null: int = 0
	for p in GameState.shop_parts:
		if p != null:
			non_null += 1
	_check("refresh(true) produces 5 non-null shop slots",
		size == 5 and non_null == 5,
		"size=%d non_null=%d" % [size, non_null])

func _test_eligibility_warrior_and_universal_only() -> void:
	GameState.new_session()
	## Roll a bunch of times; collect every part_id seen. None should be mage / rogue class.
	var seen: Dictionary = {}
	for _i in 50:
		Shop.refresh(true)
		for p in GameState.shop_parts:
			if p != null:
				seen[p] = true
	var ok := true
	var bad: String = ""
	for pid in seen:
		var def = GameState.get_part_def(pid)
		if def != null and def.cls != &"universal" and def.cls != &"warrior":
			ok = false
			bad = "%s cls=%s" % [str(pid), str(def.cls)]
			break
	_check("eligibility: 50 rolls only show warrior + universal parts",
		ok, bad)

func _test_slot_coverage_when_bran_empty() -> void:
	GameState.new_session()
	## Bran's weapon starts empty -> guarantee kicks in.
	for trial in 25:
		Shop.refresh(true)
		var slots := {&"head": 0, &"hilt": 0, &"rune": 0}
		for pid in GameState.shop_parts:
			if pid == null:
				continue
			var def = GameState.get_part_def(pid)
			if def != null:
				slots[def.slot] = int(slots.get(def.slot, 0)) + 1
		if slots[&"head"] < 1 or slots[&"hilt"] < 1 or slots[&"rune"] < 1:
			_check("slot coverage when not kitted: every roll has >=1 head, hilt, rune",
				false, "trial %d slots=%s" % [trial, str(slots)])
			return
	_check("slot coverage when not kitted: 25/25 rolls have >=1 head, hilt, rune",
		true, "")

func _test_slot_coverage_satisfied_when_kitted() -> void:
	GameState.new_session()
	## Manually kit Bran with any 3 parts so guarantee should NOT apply.
	GameState.hero.weapon.set_slot(&"head", InventoryItemT.new(100, &"h_iron_edge", 1))
	GameState.hero.weapon.set_slot(&"hilt", InventoryItemT.new(101, &"p_steel_grip", 1))
	GameState.hero.weapon.set_slot(&"rune", InventoryItemT.new(102, &"r_fire", 1))
	## Now refresh many times — pure-random pool means SOME rolls will lack a slot type.
	## Since pool is 5 parts (1H/2hilts/2runes), runes-only-of-5 is unlikely but possible.
	## Looser assertion: confirm we get rolls that lack at least one slot type across 200 tries.
	var seen_missing_slot := false
	for _i in 200:
		Shop.refresh(true)
		var slots := {&"head": 0, &"hilt": 0, &"rune": 0}
		for pid in GameState.shop_parts:
			if pid == null:
				continue
			var def = GameState.get_part_def(pid)
			if def != null:
				slots[def.slot] = int(slots.get(def.slot, 0)) + 1
		if slots[&"head"] == 0 or slots[&"hilt"] == 0 or slots[&"rune"] == 0:
			seen_missing_slot = true
			break
	_check("slot coverage NOT enforced when fully kitted (rolls eventually skip a slot type)",
		seen_missing_slot, "200 rolls all had complete coverage — guarantee may be over-firing")

func _test_reroll_deducts_two_gold() -> void:
	GameState.new_session()
	## new_session leaves gold = STARTING_GOLD (20). One free initial roll first.
	Shop.refresh(true)
	var before: int = GameState.gold
	var ok: bool = Shop.reroll()
	var after: int = GameState.gold
	_check("reroll() deducts %d gold and returns true" % Shop.REROLL_COST,
		ok and (before - after) == Shop.REROLL_COST,
		"before=%d after=%d ok=%s" % [before, after, str(ok)])

func _test_reroll_blocked_when_gold_short() -> void:
	GameState.new_session()
	GameState.gold = 1  ## below REROLL_COST
	GameState.emit_signal(&"gold_changed", 1)
	var ok: bool = Shop.reroll()
	_check("reroll() returns false when gold < REROLL_COST",
		not ok and GameState.gold == 1,
		"ok=%s gold=%d" % [str(ok), GameState.gold])

func _test_shop_changed_signal_emits() -> void:
	GameState.new_session()
	var count := [0]
	var cb := func(): count[0] += 1
	GameState.shop_changed.connect(cb)
	Shop.refresh(true)
	Shop.refresh(true)
	GameState.shop_changed.disconnect(cb)
	_check("shop_changed fires once per refresh",
		count[0] == 2, "count=%d" % count[0])

## ---------- Heal potion cases ----------

const POTION_ID: StringName = &"c_heal_potion"

func _shop_contains_potion() -> bool:
	for pid in GameState.shop_parts:
		if pid == POTION_ID:
			return true
	return false

func _set_wave(w: int) -> void:
	GameState.wave = w
	GameState.emit_signal(&"wave_changed", w)

func _test_potion_partdata_exists_with_flag() -> void:
	var def = GameState.get_part_def(POTION_ID)
	if def == null:
		_check("c_heal_potion PartData exists with is_consumable=true",
			false, "c_heal_potion.tres not loaded")
		return
	var v = def.get(&"is_consumable")
	_check("c_heal_potion PartData exists with is_consumable=true",
		v == true, "is_consumable=%s" % str(v))

func _test_regular_parts_not_consumable() -> void:
	var def = GameState.get_part_def(&"h_iron_edge")
	if def == null:
		_check("h_iron_edge is_consumable=false", false, "missing")
		return
	var v = def.get(&"is_consumable")
	## Field may be absent (legacy) or false (post-feature). Both acceptable for non-consumables.
	_check("regular part h_iron_edge is_consumable=false (or absent)",
		v == false or v == null, "is_consumable=%s" % str(v))

func _test_potion_appears_on_w1() -> void:
	GameState.new_session()  ## wave=1
	Shop.refresh(true)
	_check("potion appears on W1 (potion-wave)",
		_shop_contains_potion(), "shop=%s" % str(GameState.shop_parts))

func _test_potion_appears_on_w4() -> void:
	GameState.new_session()
	_set_wave(4)
	Shop.refresh(true)
	_check("potion appears on W4 (potion-wave)",
		_shop_contains_potion(), "shop=%s" % str(GameState.shop_parts))

func _test_potion_appears_on_w7() -> void:
	GameState.new_session()
	_set_wave(7)
	Shop.refresh(true)
	_check("potion appears on W7 (potion-wave)",
		_shop_contains_potion(), "shop=%s" % str(GameState.shop_parts))

func _test_potion_appears_on_w10() -> void:
	GameState.new_session()
	_set_wave(10)
	Shop.refresh(true)
	_check("potion appears on W10 (potion-wave)",
		_shop_contains_potion(), "shop=%s" % str(GameState.shop_parts))

func _test_potion_absent_on_w2() -> void:
	GameState.new_session()
	_set_wave(2)
	Shop.refresh(true)
	_check("potion ABSENT on W2 (non-potion-wave)",
		not _shop_contains_potion(), "shop=%s" % str(GameState.shop_parts))

func _test_potion_absent_on_w3() -> void:
	GameState.new_session()
	_set_wave(3)
	Shop.refresh(true)
	_check("potion ABSENT on W3", not _shop_contains_potion(),
		"shop=%s" % str(GameState.shop_parts))

func _test_potion_absent_on_w5() -> void:
	GameState.new_session()
	_set_wave(5)
	Shop.refresh(true)
	_check("potion ABSENT on W5", not _shop_contains_potion(),
		"shop=%s" % str(GameState.shop_parts))

func _test_potion_absent_on_w6() -> void:
	GameState.new_session()
	_set_wave(6)
	Shop.refresh(true)
	_check("potion ABSENT on W6", not _shop_contains_potion(),
		"shop=%s" % str(GameState.shop_parts))

func _test_potion_absent_on_w8() -> void:
	GameState.new_session()
	_set_wave(8)
	Shop.refresh(true)
	_check("potion ABSENT on W8", not _shop_contains_potion(),
		"shop=%s" % str(GameState.shop_parts))

func _test_potion_absent_on_w9() -> void:
	GameState.new_session()
	_set_wave(9)
	Shop.refresh(true)
	_check("potion ABSENT on W9", not _shop_contains_potion(),
		"shop=%s" % str(GameState.shop_parts))

func _test_potion_not_in_eligible_pool() -> void:
	GameState.new_session()
	var eligible: Array = Shop._eligible_part_ids()
	_check("potion NOT in regular eligible pool (only via injection)",
		not (POTION_ID in eligible), "")

func _test_potion_buy_heals_all_alive_50pct() -> void:
	GameState.new_session()
	GameState.unlock_hero(&"elara")
	GameState.unlock_hero(&"vex")
	GameState.gold = 10
	## Damage all heroes to hp=1.
	for h in GameState.active_heroes():
		h.hp = 1
	GameState.shop_parts = [POTION_ID, null, null, null, null]
	var bran_max = GameState.get_hero(&"bran").max_hp
	var elara_max = GameState.get_hero(&"elara").max_hp
	var vex_max = GameState.get_hero(&"vex").max_hp
	var ok_buy = Shop.buy(0)
	var b_hp = GameState.get_hero(&"bran").hp
	var e_hp = GameState.get_hero(&"elara").hp
	var v_hp = GameState.get_hero(&"vex").hp
	var expected_b = 1 + int(floor(float(bran_max) * 0.5))
	var expected_e = 1 + int(floor(float(elara_max) * 0.5))
	var expected_v = 1 + int(floor(float(vex_max) * 0.5))
	var ok = ok_buy and b_hp == expected_b and e_hp == expected_e and v_hp == expected_v
	_check("potion buy heals all alive heroes by floor(max_hp * 0.5)",
		ok, "buy=%s bran=%d/%d (expect %d) elara=%d/%d (expect %d) vex=%d/%d (expect %d)" %
			[str(ok_buy), b_hp, bran_max, expected_b, e_hp, elara_max, expected_e, v_hp, vex_max, expected_v])

func _test_potion_buy_skips_dead_heroes() -> void:
	GameState.new_session()
	GameState.unlock_hero(&"elara")
	GameState.unlock_hero(&"vex")
	GameState.gold = 10
	for h in GameState.all_heroes():
		h.hp = 1
	## Kill Elara.
	var elara = GameState.get_hero(&"elara")
	elara.hp = 0
	elara.is_dead = true
	GameState.shop_parts = [POTION_ID, null, null, null, null]
	Shop.buy(0)
	var b_hp = GameState.get_hero(&"bran").hp
	var e_hp = elara.hp
	var v_hp = GameState.get_hero(&"vex").hp
	_check("potion buy skips dead heroes (Elara stays at hp=0)",
		b_hp > 1 and e_hp == 0 and v_hp > 1,
		"bran=%d elara=%d vex=%d" % [b_hp, e_hp, v_hp])

func _test_potion_buy_caps_at_max_hp() -> void:
	GameState.new_session()
	GameState.gold = 10
	var bran = GameState.get_hero(&"bran")
	bran.hp = bran.max_hp - 1
	GameState.shop_parts = [POTION_ID, null, null, null, null]
	Shop.buy(0)
	_check("potion buy clamps hp to max_hp (no over-heal)",
		bran.hp == bran.max_hp,
		"hp=%d max=%d" % [bran.hp, bran.max_hp])

func _test_potion_buy_blocked_when_gold_short() -> void:
	GameState.new_session()
	GameState.gold = 2  ## potion cost = 5
	GameState.emit_signal(&"gold_changed", 2)
	var bran = GameState.get_hero(&"bran")
	bran.hp = 1
	GameState.shop_parts = [POTION_ID, null, null, null, null]
	var ok = Shop.buy(0)
	_check("potion buy blocked when gold < 5 (no heal, slot kept)",
		not ok and GameState.gold == 2 and bran.hp == 1 and GameState.shop_parts[0] == POTION_ID,
		"ok=%s gold=%d hp=%d slot0=%s" % [str(ok), GameState.gold, bran.hp, str(GameState.shop_parts[0])])

func _test_potion_buy_does_not_call_merge() -> void:
	## Potion shouldn't be added to inventory and shouldn't equip on anyone.
	GameState.new_session()
	GameState.gold = 10
	var bran = GameState.get_hero(&"bran")
	bran.hp = 1
	var inv_size_before: int = GameState.inventory.size()
	var slot_before = bran.weapon.get_slot(&"head")
	GameState.shop_parts = [POTION_ID, null, null, null, null]
	Shop.buy(0)
	_check("potion buy does NOT route through Merge (no equip)",
		GameState.inventory.size() == inv_size_before and bran.weapon.get_slot(&"head") == slot_before,
		"inv_delta=%d head_changed=%s" % [GameState.inventory.size() - inv_size_before, str(bran.weapon.get_slot(&"head") != slot_before)])

func _test_potion_buy_does_not_enter_inventory() -> void:
	## Same as above but assert explicitly that no InventoryItem with consumable
	## part_id was created.
	GameState.new_session()
	GameState.gold = 10
	var bran = GameState.get_hero(&"bran")
	bran.hp = 1
	GameState.shop_parts = [POTION_ID, null, null, null, null]
	Shop.buy(0)
	var any_potion_inv = false
	for item in GameState.inventory:
		if item.part_id == POTION_ID:
			any_potion_inv = true
			break
	_check("potion NEVER enters inventory after buy",
		not any_potion_inv, "")

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
	label.add_theme_font_size_override(&"font_size", 14)
	label.text = "\n".join(_lines)
	label.anchor_right = 1.0
	label.anchor_bottom = 1.0
	label.offset_left = 12
	label.offset_top = 12
	add_child(label)
