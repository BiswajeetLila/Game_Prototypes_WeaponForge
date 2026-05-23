## Merge — acquire-flow priority + level-up arithmetic.
##
## Mirrors prototype's `acquirePart` from BASE-A1 0.1.6 + the merge_mechanic.md
## level-up rule.
##
## Per addendum 0.1.6 priority (single-hero ultra-MVP version — other-hero
## steps cut, will return in Phase 2):
##   1. Merge into active hero's equipped duplicate of same rarity
##   2. Equip into active hero's empty slot
##   3. Merge into inventory duplicate of same rarity
##   4. Fresh L1 to inventory
##
## NOTE: stub for build step 1-2 (autoload registration). Implementation
##       fills in during task #13 (build step 7-8).
extends Node

## L1..L5 multiplier table — see merge_mechanic.md. Lives here as the canonical
## source; Weapon._stat_for() reads its own copy for hot-path performance.
const LEVEL_MULT: Array = [1.00, 1.50, 2.10, 2.85, 3.70]

## Returns the stat multiplier for a given 1-indexed level.
func level_multiplier(level: int) -> float:
	return LEVEL_MULT[clampi(level - 1, 0, LEVEL_MULT.size() - 1)]

## Buy / reward path. Caller already paid the gold (or this is a free drop).
## Returns the InventoryItem that ended up holding the part, or null on error.
##
## Return type untyped because this script is an autoload — class_name resolution
## is unreliable during cold-start parsing. Caller treats as InventoryItem.
func acquire_part(_part_id: StringName):
	return null
