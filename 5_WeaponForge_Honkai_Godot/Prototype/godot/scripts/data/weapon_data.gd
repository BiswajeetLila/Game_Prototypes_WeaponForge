## WeaponData — P1a unitary weapon schema.
##
## Weapons are UNITARY named entities (not 3-socket aggregators). Stats come
## from the weapon itself, scaled by star_tier. Element comes from the baked
## rune; the class-flavored ability + built-in recipe define identity.
##
## Replaces the old scripts/data/weapon.gd slot-aggregator (P1a migration).
## Forge Math (apply_forge_part) implements the Phase-1 part-pull upgrade loop
## from the design spec §9. Type annotations kept light to dodge the cold-start
## global-class race noted in the legacy weapon.gd.
class_name WeaponData
extends Resource

## ---------- Identity (config; TDD-exempt) ----------
@export var id: StringName = &""
@export var name: String = ""
@export var cls: StringName = &"warrior"        ## warrior|mage|rogue|paladin|assassin
@export var ability: String = ""                ## named class ability, e.g. "Stormy Slash"
@export var rune: StringName = &""              ## element: fire|ice|electric|wind|earth|""
@export var recipe: StringName = &""            ## built-in recipe key, e.g. "stormbolt"

## ---------- Stats ----------
@export var base_atk: int = 0
@export var base_hp: int = 0

## ---------- Star-up (spec Q4: 10 tiers, +5% stats per tier) ----------
@export var star_tier: int = 1                  ## 1..10
const STAR_STEP: float = 0.05

## ---------- Rarity + forge progression (spec §9 Phase-1) ----------
## rarity_idx: 0=common 1=rare 2=epic 3=legendary 4=mythic.
@export var rarity_idx: int = 0
## forge_progress: fractional progress toward the next rarity tier [0,1).
var forge_progress: float = 0.0

## ---------- Derived stats ----------

func _star_mult() -> float:
	return 1.0 + STAR_STEP * float(maxi(star_tier, 1) - 1)

func get_atk() -> int:
	return int(floor(float(base_atk) * _star_mult()))

func get_hp() -> int:
	return int(floor(float(base_hp) * _star_mult()))

## ---------- Forge Math (Phase-1 part-pull) ----------
## Apply a pulled part of rarity `part_idx` to this weapon. Returns true if the
## weapon's rarity tier increased. Class-match is enforced by the caller; this
## operates purely on rarity indices.
##
## Cases by diff = part_idx - rarity_idx (spec §9 ladder, 0..4):
##   diff <  0  -> no contribution (caller refunds as essence)
##   diff == 0  -> +50% progress; upgrade when progress reaches 100%
##   diff == 1  -> instant single-tier upgrade to the part's tier, no bank
##   diff == 2  -> instant jump straight to the part's tier + 50% banked toward the next
##   diff == 3  -> no instant upgrade; bank 1/2 toward the part's tier (2 parts reach it)
##   diff == 4  -> no instant upgrade; bank 1/3 toward the part's tier (3 parts reach it)
const _FORGE_FILL: float = 1.0 - 0.000001  ## float-safe completion threshold (handles 3×(1/3))
func apply_forge_part(part_idx: int) -> bool:
	var diff: int = part_idx - rarity_idx
	if diff < 0:
		return false
	if diff == 0:
		forge_progress += 0.5
		if forge_progress >= 1.0:
			rarity_idx += 1
			forge_progress -= 1.0
			return true
		return false
	if diff == 1:
		rarity_idx = part_idx
		forge_progress = 0.0
		return true
	if diff == 2:
		rarity_idx = part_idx
		forge_progress = 0.5
		return true
	## diff >= 3: large gap. No instant upgrade — bank fractional progress toward the
	## part's tier (Y). Assumes a run of same-rarity parts (the spec §9 banking model).
	var inc: float = 0.5 if diff == 3 else (1.0 / 3.0)
	forge_progress += inc
	if forge_progress >= _FORGE_FILL:
		rarity_idx = part_idx
		forge_progress = 0.0
		return true
	return false
