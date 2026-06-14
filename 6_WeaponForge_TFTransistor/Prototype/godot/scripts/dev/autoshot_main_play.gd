## DIAG wrapper — auto-plays Main_v2 at frame rate (windowed) to reproduce late-wave hangs.
## Drives _tick_once / advance_wave from _process so combat + tweens + render all run live.
extends Control

const MainV2Scene = preload("res://scenes/Main_v2.tscn")
var m
var _frames: int = 0
var _last_log: int = 0

func _ready() -> void:
	anchor_right = 1.0; anchor_bottom = 1.0
	m = MainV2Scene.instantiate()
	m.anchor_right = 1.0; m.anchor_bottom = 1.0
	add_child(m)
	await get_tree().process_frame
	## leave m's TickTimer running -> combat uses the REAL 0.3s cadence

func _process(_dt: float) -> void:
	if m == null:
		return
	_frames += 1
	if m.is_done():
		print("[play] DONE at frame %d, waves_played=%d" % [_frames, m.waves_played])
		set_process(false)
		return
	if m.is_forge_break():
		m.advance_wave()  ## auto-click START; combat driven by m's own Timer
	if _frames - _last_log >= 60:
		_last_log = _frames
		var ls = get_node_or_null("/root/LaneState")
		var vfx = m.find_child("Vfx", true, false)
		print("[play] f%d stage=%d wave=%d state=%d enemies=%d gold=%d vfxchildren=%d" % [
			_frames, m.current_stage, m.current_wave, m.state,
			(ls.enemies.size() if ls != null else -1), m.gold,
			(vfx.get_child_count() if vfx != null else -1)])
