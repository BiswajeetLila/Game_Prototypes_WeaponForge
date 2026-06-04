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
## Combat-interface stats — flat, NOT star-scaled (mirror the legacy socket weapon's
## crit% / ult-fill%; scaling crit% by star tier would inflate it absurdly).
@export var base_crit: int = 0       ## crit chance %, 0-100
@export var base_ult_rate: int = 0   ## ult-gauge fill bonus %

## ---------- Star-up (spec Q4: 10 tiers, +5% stats per tier) ----------
@export var star_tier: int = 1                  ## 1..10
const STAR_STEP: float = 0.05
const MAX_STAR_TIER: int = 10
## Dupe-weapon star-up (the Wittle dupe-sink): pulling a weapon you already own
## banks a dupe toward the next ★. DUPES_PER_STAR is a STARTING VALUE (flat; spec
## ramps 5->50 later). star_progress is @export so banked dupes survive a save.
const DUPES_PER_STAR: int = 3
@export var star_progress: int = 0   ## dupes banked toward the next ★

## ---------- Rarity + forge progression (spec §9 Phase-1) ----------
## rarity_idx: 0=common 1=rare 2=epic 3=legendary 4=mythic. Hard cap below.
const MAX_RARITY_IDX: int = 4
## Direct stat multiplier per rarity tier (C/R/E/L/M). STARTING VALUES (Numbers
## Policy): Mythic = 2x a Common. Common = 1.0 so existing rarity-0 weapons (incl.
## combat fixtures) are unaffected — shards forging rarity up = real power.
const RARITY_MULT: Array = [1.0, 1.15, 1.35, 1.6, 2.0]
@export var rarity_idx: int = 0
## forge_progress: fractional progress [0,1) banked toward forge_target_idx.
## Exported so partial forge progress survives save/load (P0 persistence).
@export var forge_progress: float = 0.0
## The rarity tier the current bank works toward; -1 = no active bank. The bank
## is target-exclusive: applying a part that banks toward a DIFFERENT tier resets
## the bank first (no cross-tier contamination — codex gate P1).
@export var forge_target_idx: int = -1

## ---------- Derived stats ----------

func _star_mult() -> float:
	return 1.0 + STAR_STEP * float(maxi(star_tier, 1) - 1)

## Direct combat multiplier from the weapon's rarity tier (shards forge this up).
## Common(0) = 1.0 (neutral); clamped to the RARITY_MULT table.
func rarity_mult() -> float:
	return RARITY_MULT[clampi(rarity_idx, 0, MAX_RARITY_IDX)]

func get_atk() -> int:
	return int(floor(float(base_atk) * _star_mult() * rarity_mult()))

func get_hp() -> int:
	return int(floor(float(base_hp) * _star_mult() * rarity_mult()))

## ---------- Star-up (dupe-weapon sink) ----------
## Bank one dupe of this weapon toward star-up. Returns true if it raised a ★ tier.
## ★ caps at MAX_STAR_TIER; star_progress carries banked dupes between pulls/saves.
func add_dupe() -> bool:
	if star_tier >= MAX_STAR_TIER:
		return false   ## ★ capped
	star_progress += 1
	if star_progress >= DUPES_PER_STAR:
		star_tier += 1
		star_progress = 0
		return true
	return false

## ---------- Combat interface (drop-in for the legacy socket weapon) ----------
## combat.gd reads get_atk/get_crit/get_ult_rate/get_all_tags off hero.weapon, and
## HeroState.refresh_max_hp() reads get_hp_bonus. Stage 1 adds these so WeaponData can
## stand in for the legacy Weapon's combat surface (the actual switch is a later stage).

func get_crit() -> int:
	return base_crit

func get_ult_rate() -> int:
	return base_ult_rate

## Alias of get_hp() — HeroState calls weapon.get_hp_bonus() on the legacy weapon.
func get_hp_bonus() -> int:
	return get_hp()

## Explicit element tag (the baked rune) + derived "crit"/"charge" tags. Mirrors
## legacy Weapon.get_all_tags(); a unitary weapon contributes a single element tag.
func get_all_tags() -> Array:
	var out: Array = []
	if rune != &"":
		out.append(rune)
	if get_crit() > 0:
		out.append(&"crit")
	if get_ult_rate() > 0:
		out.append(&"charge")
	return out

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
	if part_idx < 0 or part_idx > MAX_RARITY_IDX:
		push_warning("WeaponData.apply_forge_part: part_idx %d outside 0..%d — rejected"
			% [part_idx, MAX_RARITY_IDX])
		return false
	var diff: int = part_idx - rarity_idx
	if diff < 0:
		return false
	if diff == 0:
		if rarity_idx >= MAX_RARITY_IDX:
			## Already Mythic: no tier above to bank toward. No contribution
			## (caller refunds as essence, same as the lower-tier path).
			return false
		return _bank(rarity_idx + 1, 0.5, true)
	if diff == 1:
		rarity_idx = part_idx
		forge_progress = 0.0
		forge_target_idx = -1
		return true
	if diff == 2:
		## Instant jump straight to the part's tier + 50% banked toward the tier
		## above it — unless the part IS Mythic (no tier above: bank dropped).
		rarity_idx = part_idx
		if part_idx >= MAX_RARITY_IDX:
			forge_progress = 0.0
			forge_target_idx = -1
		else:
			forge_progress = 0.5
			forge_target_idx = part_idx + 1
		return true
	## diff >= 3: large gap. No instant upgrade — bank toward the part's tier (Y).
	var inc: float = 0.5 if diff == 3 else (1.0 / 3.0)
	return _bank(part_idx, inc, false)

## ---------- Forge SHARDS (rarity-forge fuel, Stage B) ----------
## SHARD_INC: how much of a tier one shard fills, indexed by the shard's OWN rarity
## (0=common..4=mythic). STARTING VALUES (Numbers Policy) — tune in playtest so a
## mained weapon reaches Legendary in ~N runs; a dupe (+0.5) ≈ 2-3 commons.
const SHARD_INC: Array = [0.20, 0.35, 0.55, 0.85, 0.85]

## Apply one Forge Shard of rarity `shard_rarity` to this weapon. DETERMINISTIC
## (no skill/minigame): banks a rarity-scaled fraction toward the NEXT tier
## (rarity_idx+1) via the shared _bank. Returns true if the weapon tiered up.
func apply_forge_shard(shard_rarity: int) -> bool:
	if shard_rarity < 0 or shard_rarity > MAX_RARITY_IDX:
		push_warning("WeaponData.apply_forge_shard: shard_rarity %d outside 0..%d — rejected"
			% [shard_rarity, MAX_RARITY_IDX])
		return false
	if rarity_idx >= MAX_RARITY_IDX:
		return false   ## Mythic cap — no tier above to bank toward
	return _bank(rarity_idx + 1, SHARD_INC[shard_rarity], true)

## Add `inc` to the bank toward `target`. The bank is target-exclusive: a different
## active target resets the bank before adding (harsh rule, no cross-tier mixing;
## a UI warning ships with the pull increment). On fill the weapon upgrades to the
## TARGET tier. `carry` keeps overflow past 1.0 (historical same-tier semantics).
func _bank(target: int, inc: float, carry: bool) -> bool:
	if forge_target_idx != target:
		forge_target_idx = target
		forge_progress = 0.0
	forge_progress += inc
	if forge_progress >= _FORGE_FILL:
		rarity_idx = target
		forge_progress = (forge_progress - 1.0) if carry else 0.0
		if forge_progress < 0.000001:
			forge_progress = 0.0
		forge_target_idx = -1
		return true
	return false
