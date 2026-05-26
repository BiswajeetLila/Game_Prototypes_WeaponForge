## Merge — acquire-flow priority + level-up arithmetic.
##
## Mirrors prototype's `acquirePart` from BASE-A1 0.1.6 + the merge_mechanic.md
## level-up rule.
##
## Per addendum 0.1.6 priority (ultra-MVP single-hero version; other-hero
## steps cut, will return in Phase 2):
##   1. Merge into active hero's equipped duplicate of same rarity
##   2. Equip into active hero's empty slot
##   3. Merge into inventory duplicate of same rarity
##   4. Fresh L1 to inventory
##
## "Same rarity" rule (merge_mechanic.md): satisfied implicitly because each
## part_id maps to exactly one PartData, which has a fixed rarity. Items
## sharing a part_id always share rarity. Future cross-rarity skins would get
## their own part_id and naturally not merge.
##
## Level cap is 5 (InventoryItem.LEVEL_CAP). Acquiring a duplicate at cap does
## NOT lose the part — it falls through to step 4 (fresh L1 to inventory).
##
## Side effects on a successful equip / level-up that touches the active hero's
## weapon: refresh max_hp (hp delta if hilt's hp changed), call
## Recipes.check_hero_for_discoveries (discover-on-equip per addendum 0.1.7),
## emit weapon_changed + hero_hp_changed signals.
##
## Inventory-only ops emit inventory_changed.
##
## Untyped types throughout — this is an autoload and global class_name
## resolution is unreliable during cold-start parsing.
extends Node

const InventoryItemT = preload("res://scripts/data/inventory_item.gd")

## L1..L5 multiplier table — see merge_mechanic.md. Mirrored on Weapon for the
## hot-path read; this copy is the canonical source. Slow curve per
## forge-ux-balance-w10: leveling rewards remain but don't trivialise late
## game vs recipes / crit / affinity. Mirror is locked by
## test_weapon_level_mult_mirrors_merge.
const LEVEL_MULT: Array = [1.00, 1.35, 1.80, 2.30, 2.75]

## Returns the stat multiplier for a 1-indexed level.
func level_multiplier(level: int) -> float:
	var idx: int = clampi(level - 1, 0, LEVEL_MULT.size() - 1)
	return float(LEVEL_MULT[idx])

## ---------- Public API ----------

## Buy / reward path. Caller already paid the gold (or this is a free drop).
## Returns the InventoryItem holding the part (newly created OR leveled-up),
## or null if part_id is unknown.
##
## hero_id selects the target hero. Empty default resolves to the first alive
## squad member — preserves single-Bran behavior in tests and pre-tab UI.
func acquire_part(part_id: StringName, hero_id: StringName = &""):
	var def = GameState.get_part_def(part_id)
	if def == null:
		push_warning("Merge.acquire_part: unknown part_id %s" % str(part_id))
		return null

	var hero = _resolve_hero(hero_id)

	## Step 1 — target hero's equipped duplicate.
	if hero != null and hero.weapon != null:
		var equipped = hero.weapon.get_slot(def.slot)
		if equipped != null and equipped.part_id == part_id:
			if equipped.level < InventoryItemT.LEVEL_CAP:
				equipped.level_up()
				_on_equipped_changed(hero)
				GameState.emit_signal(&"merge_completed", equipped.uid, equipped.level)
				return equipped
			## At cap — fall through. Don't lose the part.

	## Step 2 — equip into target hero's matching empty slot.
	if hero != null and hero.weapon != null:
		if hero.weapon.get_slot(def.slot) == null:
			var fresh = _new_item(part_id)
			hero.weapon.set_slot(def.slot, fresh)
			_on_equipped_changed(hero)
			return fresh

	## Step 3 — inventory duplicate (global pool).
	for item in GameState.inventory:
		if item.part_id == part_id and item.level < InventoryItemT.LEVEL_CAP:
			item.level_up()
			GameState.emit_signal(&"inventory_changed")
			GameState.emit_signal(&"merge_completed", item.uid, item.level)
			return item

	## Step 4 — fresh L1 to inventory.
	var fresh_inv = _new_item(part_id)
	GameState.inventory.append(fresh_inv)
	GameState.emit_signal(&"inventory_changed")
	return fresh_inv

## Equip an existing InventoryItem onto the target hero's matching slot. Used
## by ForgePanel's "click inventory tile → equip" flow. Returns true on success.
## If the target slot is already occupied, the displaced item goes to inventory.
func equip_from_inventory(item, hero_id: StringName = &"") -> bool:
	if item == null:
		return false
	var hero = _resolve_hero(hero_id)
	if hero == null or hero.weapon == null:
		return false
	var def = GameState.get_part_def(item.part_id)
	if def == null:
		return false

	## Same-partId target already in slot? Merge OR swap depending on levels.
	## Bug fix: previously called current.level_up() unconditionally which
	## consumed any higher-level inventory source to bump current by +1 —
	## destroying L5 items if user clicked L5 inv onto L1 slot. Now:
	##   - if item.level > current.level: SWAP (preserve the higher-level item)
	##   - elif current.level < CAP:       MERGE (consume source, bump current)
	##   - else (current at cap, item lower-or-equal): SWAP via fall-through
	var current = hero.weapon.get_slot(def.slot)
	if current != null and current.part_id == item.part_id:
		if item.level <= current.level and current.level < InventoryItemT.LEVEL_CAP:
			current.level_up()
			GameState.inventory.erase(item)
			GameState.emit_signal(&"inventory_changed")
			_on_equipped_changed(hero)
			return true
		## Otherwise fall through to swap branch below — preserves the
		## higher-level item in the slot OR handles current-at-cap.

	## Different partId in slot — OR same-partId swap. Old goes to inventory.
	if current != null:
		GameState.inventory.append(current)
	hero.weapon.set_slot(def.slot, item)
	GameState.inventory.erase(item)
	GameState.emit_signal(&"inventory_changed")
	_on_equipped_changed(hero)
	return true

## Unequip the target hero's slot back to inventory. Returns true if a part
## was actually moved.
func unequip_to_inventory(slot: StringName, hero_id: StringName = &"") -> bool:
	var hero = _resolve_hero(hero_id)
	if hero == null or hero.weapon == null:
		return false
	var current = hero.weapon.get_slot(slot)
	if current == null:
		return false
	hero.weapon.set_slot(slot, null)
	GameState.inventory.append(current)
	GameState.emit_signal(&"inventory_changed")
	_on_equipped_changed(hero)
	return true

## ---------- Internals ----------

func _new_item(part_id: StringName):
	return InventoryItemT.new(GameState.next_uid(), part_id, 1)

## hero_id = &"" -> first alive squad member (Bran in default sessions).
func _resolve_hero(hero_id: StringName):
	if hero_id != &"":
		return GameState.get_hero(hero_id)
	var squad: Array = GameState.active_heroes()
	if squad.is_empty():
		return null
	return squad[0]

func _on_equipped_changed(hero) -> void:
	hero.refresh_max_hp()
	Recipes.check_hero_for_discoveries(hero)
	GameState.emit_signal(&"weapon_changed", hero.data.id)
	GameState.emit_signal(&"hero_hp_changed", hero.data.id)
