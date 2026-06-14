## LaneState — per-tick enemy position + status state for the v2 lane corridor.
##
## Autoload singleton. Holds live enemies as dicts; does NOT own signals.
## Pure logic only — no scene references, no Node children.
##
## Enemy dict schema (v2):
##   id           StringName
##   lane         int          0=top 1=mid 2=bot
##   screen_x     float        0.0=hero-anchor 1.0=spawn-edge
##   hp           int
##   max_hp       int
##   walk_speed   float        screen-x units per tick (default 0.05)
##   statuses     Dictionary   StringName -> {ticks:int, stacks:int}
##   kb_immune    int          knockback-immune ticks remaining
##   engaged      bool         true when screen_x <= 0.0
extends Node

## Distance metric weight: 1 lane-stride ≈ 0.33 screen-x.
const LANE_K: float = 3.0

var enemies: Array = []

func _ready() -> void:
	pass

func reset() -> void:
	enemies = []

## ---- factory ----

func make_enemy(id: StringName, lane: int, screen_x: float,
		hp: int = 15, walk_speed: float = 0.05) -> Dictionary:
	return {
		"id": id, "lane": lane, "screen_x": screen_x,
		"hp": hp, "max_hp": hp, "walk_speed": walk_speed,
		"statuses": {}, "kb_immune": 0, "engaged": false,
	}

## ---- distance ----

## Euclidean cross-lane distance: sqrt((Δlane)² + (k·Δx)²).
func distance(from_lane: int, from_x: float, to_lane: int, to_x: float) -> float:
	var dl := float(abs(to_lane - from_lane))
	var dx := (to_x - from_x) * LANE_K
	return sqrt(dl * dl + dx * dx)

## ---- enemy advance ----

## Apply one tick of enemy movement. Mutates enemy dict in-place.
func advance_enemy(enemy: Dictionary) -> void:
	if enemy.kb_immune > 0:
		enemy.kb_immune -= 1
	var speed: float = enemy.walk_speed
	if enemy.statuses.has(&"Frozen"):
		speed = 0.0
	elif enemy.statuses.has(&"Chilled"):
		speed *= 0.5
	enemy.screen_x -= speed
	if enemy.screen_x <= 0.0:
		enemy.screen_x = 0.0
		enemy.engaged = true

## Push enemy back `amount` screen-x units. Honours knockback immunity.
func knockback_enemy(enemy: Dictionary, amount: float = 1.0) -> bool:
	if enemy.kb_immune > 0:
		return false
	enemy.screen_x = minf(1.0, enemy.screen_x + amount)
	enemy.kb_immune = 2
	enemy.engaged = false
	return true

## ---- status lifecycle ----

## Apply status. Handles refresh-on-re-apply (max_stacks=1) and stack-to-cap.
## Returns final stack count.
func apply_status(enemy: Dictionary, status_name: StringName,
		duration_ticks: int, stacks_to_add: int = 1, max_stacks: int = 1) -> int:
	if not enemy.statuses.has(status_name):
		enemy.statuses[status_name] = {"ticks": duration_ticks, "stacks": 0}
	var entry: Dictionary = enemy.statuses[status_name]
	entry["ticks"] = duration_ticks  # always refresh duration
	entry["stacks"] = mini(entry["stacks"] + stacks_to_add, max_stacks)
	return entry["stacks"]

## Decrement all statuses by 1 tick; remove entries that reach 0.
func decay_statuses(enemy: Dictionary) -> void:
	var to_remove: Array = []
	for k in enemy.statuses.keys():
		enemy.statuses[k]["ticks"] -= 1
		if enemy.statuses[k]["ticks"] <= 0:
			to_remove.append(k)
	for k in to_remove:
		enemy.statuses.erase(k)

## Remove a specific status from enemy (cleanse).
func cleanse_status(enemy: Dictionary, status_name: StringName) -> void:
	enemy.statuses.erase(status_name)

## Remove `amount` stacks from a status; erase the status if it hits 0. Returns remaining stacks.
## Used by reactions that consume Cracked stacks (Magma Burst, Mudslide-W, Stonesmith).
func consume_status_stack(enemy: Dictionary, status_name: StringName, amount: int = 1) -> int:
	if not enemy.statuses.has(status_name):
		return 0
	var entry: Dictionary = enemy.statuses[status_name]
	entry["stacks"] = int(entry["stacks"]) - amount
	if entry["stacks"] <= 0:
		enemy.statuses.erase(status_name)
		return 0
	return int(entry["stacks"])

func get_status_stacks(enemy: Dictionary, status_name: StringName) -> int:
	if not enemy.statuses.has(status_name):
		return 0
	return int(enemy.statuses[status_name]["stacks"])

func has_status(enemy: Dictionary, status_name: StringName) -> bool:
	return enemy.statuses.has(status_name)
