## WaveDirector — FTUE-scripted vs open-play world/stage/wave sequencing.
## Autoload singleton. Full impl in Phase 4 step 9.
##
## FTUE world (world_index=0, ftue_complete=false):
##   stages 0+1 = 1 wave each; stages 2-4 = 3 waves each.
##   F2 cinematic = bran_joins; F4 cinematic = vex_joins.
##   active lanes: stage 0+1 -> 1 lane; stage 2+3 -> 2 lanes; stage 4 -> 3 lanes.
extends Node

var world_index: int = 0

func _ready() -> void:
	pass

func reset() -> void:
	world_index = 0

func _is_ftue() -> bool:
	var acc := get_node_or_null("/root/AccountState")
	if acc == null:
		return false
	return not acc.ftue_complete and world_index == 0

## Number of waves for a given stage (0-indexed).
func waves_for_stage(stage: int) -> int:
	if _is_ftue() and stage < 2:
		return 1
	return 3

## Returns cinematic id to fire at forge index, or &"" if none.
func cinematic_at_forge(forge_index: int) -> StringName:
	if not _is_ftue():
		return &""
	if forge_index == 2:
		return &"bran_joins"
	if forge_index == 4:
		return &"vex_joins"
	return &""

## Number of active lanes for a given stage (0-indexed).
func active_lanes_for_stage(stage: int) -> int:
	if not _is_ftue():
		return 3
	if stage < 2:
		return 1
	if stage < 4:
		return 2
	return 3
