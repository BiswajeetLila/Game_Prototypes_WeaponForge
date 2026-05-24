## Shop — TFT-style 5-slot parts shop with reroll.
##
## Mirrors prototype's `refreshShop` (BASE-A1 0.1.2 baseline + addendum 0.1.8
## slot-coverage-while-not-kitted extension).
##
## Public API:
##   refresh(free := false)        Roll a new 5-part shop. Costs REROLL_COST
##                                  unless `free` is true (used by combat.gd at
##                                  the start of each wave's forge moment).
##                                  No-op if not free and gold < REROLL_COST.
##   reroll()       -> bool        Same as refresh(false). Returns true on success,
##                                  false if gold short.
##   buy(slot_idx)  -> bool        Buy the part at GameState.shop_parts[slot_idx].
##                                  Deducts the part's cost, hands it off to
##                                  Merge.acquire_part (which decides merge vs
##                                  fresh L1 vs inventory), clears the shop slot.
##                                  Returns false if no part there, gold short,
##                                  or merge declined.
##
## State lives on GameState.shop_parts: Array — 5 elements, each is a part_id
## StringName or null (bought / empty). UI panels listen to GameState.shop_changed.
##
## Eligibility (addendum 0.1.2): a PartData is eligible if its class matches an
## unlocked hero class OR is universal. Ultra-MVP: only warrior is unlocked.
##
## Slot-coverage guarantee (addendum 0.1.8): while ANY unlocked hero is not
## fully kitted, the 5-shop must include at least one head, one hilt, and one
## rune from the eligible pool. Once all heroes are fully kitted, pure random.
##
## Untyped function args (no `: SomeClass`) because this script is an autoload —
## global class_name resolution is unreliable during cold-start parsing.
extends Node

const SHOP_SIZE: int = 5
const REROLL_COST: int = 2

## Public so the UI can grey-out the reroll button.
func can_afford_reroll() -> bool:
	return GameState.gold >= REROLL_COST

## Roll a new shop. If `free` is true, gold is not spent (used for the
## auto-refresh at the start of each wave's forge moment). Otherwise costs
## REROLL_COST; aborts and returns silently if gold is short.
func refresh(free: bool = false) -> void:
	if not free:
		if not GameState.spend_gold(REROLL_COST):
			return
	GameState.shop_parts = _roll_shop()
	GameState.emit_signal(&"shop_changed")

func reroll() -> bool:
	if not can_afford_reroll():
		return false
	refresh(false)
	return true

func buy(slot_idx: int) -> bool:
	if slot_idx < 0 or slot_idx >= GameState.shop_parts.size():
		return false
	var part_id = GameState.shop_parts[slot_idx]
	if part_id == null or part_id == &"":
		return false
	var def = GameState.get_part_def(part_id)
	if def == null:
		push_warning("Shop.buy: unknown part_id %s" % str(part_id))
		return false
	if GameState.gold < def.cost:
		return false
	if not GameState.spend_gold(def.cost):
		return false
	## Hand off to Merge — it decides level-up vs new L1 + active-hero priority.
	var item = Merge.acquire_part(part_id)
	if item == null:
		## Merge declined (shouldn't happen with current rules). Refund and bail.
		GameState.add_gold(def.cost)
		push_warning("Shop.buy: Merge.acquire_part returned null for %s — refunded" % str(part_id))
		return false
	## Consume the shop slot.
	GameState.shop_parts[slot_idx] = null
	GameState.emit_signal(&"shop_changed")
	return true

## ---------- Internals ----------

func _roll_shop() -> Array:
	var eligible: Array = _eligible_part_ids()
	if eligible.is_empty():
		## Empty catalog — return all-null shop and warn. UI will still render
		## empty cards, not crash.
		push_warning("Shop._roll_shop: no eligible parts; check class-unlock rules")
		var blanks: Array = []
		blanks.resize(SHOP_SIZE)
		return blanks

	var out: Array = []
	if _needs_slot_guarantee():
		## Force 1 head, 1 hilt, 1 rune (each from eligibles of that slot, if any).
		for slot in [&"head", &"hilt", &"rune"]:
			var bucket: Array = eligible.filter(
				func(pid): return GameState.get_part_def(pid).slot == slot
			)
			if not bucket.is_empty():
				out.append(bucket[randi() % bucket.size()])
		## Fill remaining shop slots with pure-random eligibles (duplicates OK).
		while out.size() < SHOP_SIZE:
			out.append(eligible[randi() % eligible.size()])
	else:
		for i in SHOP_SIZE:
			out.append(eligible[randi() % eligible.size()])
	return out

func _eligible_part_ids() -> Array:
	var out: Array = []
	for pid in GameState.part_ids:
		var def = GameState.get_part_def(pid)
		if def == null:
			continue
		if def.cls == &"universal" or _class_unlocked(def.cls):
			out.append(pid)
	return out

func _class_unlocked(cls: StringName) -> bool:
	return GameState.unlocked_classes.has(cls)

func _needs_slot_guarantee() -> bool:
	## True if any unlocked hero is not fully kitted. Multi-hero: scan the
	## active squad; one empty slot anywhere = guarantee fires.
	var squad: Array = GameState.active_heroes()
	if squad.is_empty():
		return true
	for h in squad:
		if h.weapon == null:
			return true
		if not h.weapon.is_full():
			return true
	return false
