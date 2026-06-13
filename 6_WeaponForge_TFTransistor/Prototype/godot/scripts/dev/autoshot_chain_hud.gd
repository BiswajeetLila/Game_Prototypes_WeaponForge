## AUTOSHOT demo wrapper — drives ChainHUD with 3 reactions to show count.
extends Control

const ChainHUDScene = preload("res://scenes/ui/ChainHUD.tscn")

func _ready() -> void:
	anchor_right = 1.0; anchor_bottom = 1.0
	## Solid dark backdrop for contrast
	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.07, 0.1, 1.0)
	bg.anchor_right = 1.0; bg.anchor_bottom = 1.0
	add_child(bg)
	var ch = ChainHUDScene.instantiate()
	add_child(ch)
	ch._on_reaction(&"steam", {})
	ch._on_reaction(&"electrocute", {})
	ch._on_reaction(&"steam", {})
