## HeroProgress — pure static math for hero leveling. No state, no autoload.
##
## Curve (spec starting values, hero-squad design §4/§9.4):
##   - MAX_LEVEL 20
##   - xp to go from level L to L+1 = XP_STEP * L  (1000, 2000, 3000, ...)
##   - stat multiplier = 1.0 + STAT_PER_LEVEL*(level-1)  (+5% per level)
class_name HeroProgress
extends RefCounted

const MAX_LEVEL: int = 20
const XP_STEP: int = 1000
const STAT_PER_LEVEL: float = 0.05

## Total cumulative XP required to BE at `level`. Level 1 = 0.
static func cumulative_xp_for_level(level: int) -> int:
	var lvl: int = clampi(level, 1, MAX_LEVEL)
	## sum_{k=1}^{lvl-1} XP_STEP*k = XP_STEP * (lvl-1)*lvl/2
	return XP_STEP * (lvl - 1) * lvl / 2

## XP needed to advance FROM `level` to `level+1`. 0 at/after cap.
static func xp_to_next(level: int) -> int:
	if level >= MAX_LEVEL:
		return 0
	return XP_STEP * maxi(1, level)

## Highest level whose cumulative threshold is met by `xp`. Clamped to MAX_LEVEL.
static func level_for_xp(xp: int) -> int:
	var lvl: int = 1
	while lvl < MAX_LEVEL and xp >= cumulative_xp_for_level(lvl + 1):
		lvl += 1
	return lvl

## Stat multiplier applied to a hero's base stats at this level.
static func stat_mult(level: int) -> float:
	var lvl: int = clampi(level, 1, MAX_LEVEL)
	return 1.0 + STAT_PER_LEVEL * float(lvl - 1)
