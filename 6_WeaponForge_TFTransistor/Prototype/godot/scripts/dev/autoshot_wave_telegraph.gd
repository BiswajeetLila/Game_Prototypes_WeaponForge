## AUTOSHOT demo wrapper — shows WaveTelegraph overlay with a sample enemy roster.
extends Control

const WaveTelegraphScene = preload("res://scenes/ui/WaveTelegraph.tscn")

func _ready() -> void:
	anchor_right = 1.0; anchor_bottom = 1.0
	## Solid backdrop so the panel reads against something
	var bg := ColorRect.new()
	bg.color = Color(0.08, 0.09, 0.12, 1.0)
	bg.anchor_right = 1.0; bg.anchor_bottom = 1.0
	add_child(bg)
	var wt = WaveTelegraphScene.instantiate()
	add_child(wt)
	wt.show_wave(1, 3, [
		{"lane": 0, "id": "goblin", "weakness_tag": "WATER"},
		{"lane": 1, "id": "goblin", "weakness_tag": "FIRE"},
		{"lane": 2, "id": "skeleton", "weakness_tag": "FIRE"},
	])
