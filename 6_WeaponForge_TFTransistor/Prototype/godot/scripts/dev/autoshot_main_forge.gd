## AUTOSHOT wrapper — Main_v2 forced into FORGE_BREAK for a clean forge-state capture.
extends Control

const MainV2Scene = preload("res://scenes/Main_v2.tscn")

func _ready() -> void:
	anchor_right = 1.0; anchor_bottom = 1.0
	var m = MainV2Scene.instantiate()
	m.anchor_right = 1.0; m.anchor_bottom = 1.0
	add_child(m)
	## Defer one frame so Main_v2._ready (start_run) completes first.
	await get_tree().process_frame
	if m.has_method("demo_forge_break"):
		m.demo_forge_break()
