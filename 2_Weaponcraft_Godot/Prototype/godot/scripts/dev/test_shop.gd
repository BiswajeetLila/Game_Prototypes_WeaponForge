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
