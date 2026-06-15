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

## Returns the active lane indices for a given stage.
## FTUE: stage 0+1 -> [1] (mid), stage 2+3 -> [0,1] (top+mid), stage 4 -> [0,1,2].
## Post-FTUE: always [0,1,2].
func active_lane_indices(stage: int) -> Array:
	var n: int = active_lanes_for_stage(stage)
	if _is_ftue() and n == 1:
		return [1]
	if _is_ftue() and n == 2:
		return [0, 1]
	return [0, 1, 2]

## Returns spawn roster (Array of enemy dicts) for a given (stage, wave).
## Stage 4 wave 2 = boss (single high-HP enemy, lane 1).
## Otherwise: 3 + stage + wave goblin-class enemies distributed across active lanes.
## Each enemy dict shape: {id:StringName, lane:int, screen_x:float, hp:int}.
func enemies_for_stage_wave(stage: int, wave: int) -> Array:
	if stage == 4 and wave == 2:
		return [{"id": &"BOSS", "lane": 1, "screen_x": 0.95, "hp": 30}]
	var lanes: Array = active_lane_indices(stage)
	var count: int = 3 + stage + wave
	var enemies: Array = []
	for i in count:
		var lane: int = lanes[i % lanes.size()]
		var sx: float = 0.6 + (float(i) / float(maxi(count - 1, 1))) * 0.35
		enemies.append({"id": &"goblin", "lane": lane, "screen_x": sx, "hp": 5 + stage * 2})
	return enemies

## ---- wave telegraph (spec §17) ----
## Per-wave preview of the upcoming stage: distinct enemy ids + the wave's primary
## weakness/resistance tag (from EnemyData). Drives forge decisions during the break.
## Returns Array of { wave:int, enemies:Array[StringName], weak_tag:StringName, resist_tag:StringName }.
func telegraph_for_stage(stage: int) -> Array:
	var out: Array = []
	var nwaves: int = waves_for_stage(stage)
	for w in nwaves:
		var roster: Array = enemies_for_stage_wave(stage, w)
		var ids: Array = []
		var seen: Dictionary = {}
		for e in roster:
			var eid = e.get("id", &"")
			if not seen.has(eid):
				seen[eid] = true
				ids.append(eid)
		var weak: StringName = &""
		var resist: StringName = &""
		if not roster.is_empty():
			var ed = _enemy_data(roster[0].get("id", &""))
			if ed != null:
				weak = ed.weak_tag
				resist = ed.resist_tag
		out.append({"wave": w, "enemies": ids, "count": roster.size(), "weak_tag": weak, "resist_tag": resist})
	return out

func _enemy_data(id: StringName):
	var p := "res://data/enemies/%s.tres" % String(id).to_lower()
	return load(p) if ResourceLoader.exists(p) else null
