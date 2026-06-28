## Dev AUTOSHOT helper — instances BattleView, starts wave 1, lets the
## ScreenshotHelper autoload capture the in-combat arena (3 hero lanes +
## enemies). Run with WC_AUTOSHOT set, WITHOUT --headless (needs a GL context):
##   $env:WC_AUTOSHOT="<png>"; godot --path <proj> res://scenes/dev/ShotBattle.tscn
extends Control

const BattleViewScene = preload("res://scenes/BattleView.tscn")

func _ready() -> void:
	GameState.new_session()
	var bv = BattleViewScene.instantiate()
	add_child(bv)
	bv.set_anchors_preset(Control.PRESET_FULL_RECT)
	await get_tree().process_frame
	Combat.start_wave(1, false)
