## Shop — TFT-style 5-slot parts shop with reroll.
##
## Mirrors prototype's `refreshShop` (BASE-A1 0.1.2 baseline + addendum 0.1.8
## slot-coverage-while-not-kitted extension).
##
## Rules:
##   - Pool filtered to parts whose `cls` matches an unlocked hero class
##     (universal always included). Ultra-MVP: warrior + universal.
##   - While Bran is NOT fully kitted: guarantee ≥1 head, ≥1 hilt, ≥1 rune
##     among the 5. Then fill remaining 2 with random eligibles.
##   - Once Bran is fully kitted: pure random 5 from eligibles.
##   - Reroll cost: 2 gold (free first refresh per wave).
##
## NOTE: stub for build step 1-2 (autoload registration). Implementation
##       fills in during task #13 (build step 7-8).
extends Node

const REROLL_COST: int = 2

func refresh(_free: bool = false) -> void:
	pass

func buy(_shop_index: int) -> bool:
	return false

func reroll() -> bool:
	return false
