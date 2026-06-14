## ShopV2 — 7-slot slow-populate shop logic for Phase 4.
## Autoload singleton. Full impl in Phase 4 step 10.
##
## Mit-D populate rhythm per stage:
##   3-wave stage: 2 at start + 1 per wave (3) + 2 at wave-3-start = 7
##   1-wave FTUE:  2 at start + 2 during wave + 3 at break = 7
##
## Pity: if ≥2 consecutive stages had zero Element Functions, next stage
## guaranteed ≥1 Element in first pop.
extends Node

## ---- economy (spec §9.3 / §10) ----
const T1_BASE_BY_STAGE: Array = [1, 1, 2, 2, 3]      ## spec §9.3, index = current_stage
const TIER_MULT: Array = [1.0, 1.4, 2.0, 2.8, 4.0]    ## spec §10.1, index = tier-1 (T2-T5 dormant in slice)
const REROLL_COST: int = 1                            ## spec §9.3, flat
const SLICE_FN_IDS: Array = ["FIRE", "WATER", "LIGHTNING", "AOE", "LEECH", "BURST"]  ## T1 slice pool (no BOUNCE)
const ELEMENT_IDS: Array = ["FIRE", "WATER", "LIGHTNING"]

## stages with no element Function since last element seen
var _dry_stages: int = 0
var pity_triggered: bool = false  ## test probe: true when pity guarantee fired

## Gold cost for a Function at (stage 0-4, tier 1-5). Slice uses tier 1 only.
static func cost_for(stage: int, tier: int) -> int:
	var base: int = T1_BASE_BY_STAGE[clampi(stage, 0, 4)]
	return int(ceil(base * TIER_MULT[clampi(tier - 1, 0, 4)]))

## Roll `count` shop items for a stage (T1-only slice). pity forces slot 0 to an element.
## Each item = {id:String, tier:int, cost:int}.
func roll_items(stage: int, count: int, pity: bool) -> Array:
	var items: Array = []
	for i in count:
		var id: String = SLICE_FN_IDS[randi() % SLICE_FN_IDS.size()]
		items.append({"id": id, "tier": 1, "cost": cost_for(stage, 1)})
	if pity and items.size() > 0:
		items[0] = {"id": ELEMENT_IDS[randi() % ELEMENT_IDS.size()], "tier": 1, "cost": cost_for(stage, 1)}
	return items

## Buy decision (state-light: caller mutates gold + slots). item = {id,tier,cost}.
func buy(item: Dictionary, gold: int) -> Dictionary:
	var cost: int = int(item.get("cost", 0))
	if gold < cost:
		return {"ok": false, "cost": cost}
	return {"ok": true, "cost": cost, "fn": {"id": StringName(item.get("id", "")), "tier": int(item.get("tier", 1))}}

## Reroll decision: needs gold >= REROLL_COST and something to reroll (rollable_count > 0).
func reroll(gold: int, rollable_count: int) -> Dictionary:
	if gold < REROLL_COST or rollable_count <= 0:
		return {"ok": false, "cost": REROLL_COST}
	return {"ok": true, "cost": REROLL_COST}

func _ready() -> void:
	pass

func reset() -> void:
	_dry_stages = 0
	pity_triggered = false

## Returns schedule as Array of {wave:int, count:int} dicts.
## wave=-1 = stage start (before wave 0); wave=N = during wave N start.
static func populate_schedule_3wave() -> Array:
	return [
		{"wave": -1, "count": 2},   ## 2 at stage start
		{"wave": 0,  "count": 1},   ## 1 drops during wave 1
		{"wave": 1,  "count": 1},   ## 1 drops during wave 2
		{"wave": 2,  "count": 1},   ## 1 drops at wave 3 start
		{"wave": 2,  "count": 2},   ## 2 more at wave 3 start (final batch)
	]

static func populate_schedule_1wave() -> Array:
	## FTUE single-wave stages: 2 at start + 2 mid-wave + 3 at break
	return [
		{"wave": -1, "count": 2},
		{"wave": 0,  "count": 2},
		{"wave": 0,  "count": 3},
	]

## Call after each stage ends with list of element function ids that appeared.
func notify_stage_end(element_ids: Array, _had_element: bool) -> void:
	if element_ids.is_empty():
		_dry_stages += 1
	else:
		_dry_stages = 0
	pity_triggered = _dry_stages >= 2
