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

## stages with no element Function since last element seen
var _dry_stages: int = 0
var pity_triggered: bool = false  ## test probe: true when pity guarantee fired

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
