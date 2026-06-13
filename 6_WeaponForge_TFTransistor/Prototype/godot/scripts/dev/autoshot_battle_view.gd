## AUTOSHOT demo wrapper — populates BattleView_v2 with 3-lane enemies + VFX flash.
## Run via:  WC_AUTOSHOT=<png-path> godot --headless --path . res://scenes/dev/AutoShot_BattleView.tscn
extends Control

const BattleViewScene = preload("res://scenes/ui/BattleView_v2.tscn")

func _ready() -> void:
	anchor_right = 1.0; anchor_bottom = 1.0
	var bv = BattleViewScene.instantiate()
	bv.anchor_right = 1.0; bv.anchor_bottom = 1.0
	add_child(bv)
	## Pre-populate LaneState with a representative enemy roster
	var ls = get_node("/root/LaneState")
	ls.reset()
	var e0 = ls.make_enemy(&"goblin", 0, 0.7, 5)
	var e1 = ls.make_enemy(&"goblin", 1, 0.5, 5)
	var e2 = ls.make_enemy(&"goblin", 2, 0.85, 5)
	## Mark e1 with a status so its label shows it
	ls.apply_status(e1, &"Wet", 4)
	ls.enemies = [e0, e1, e2]
	bv._sync_enemies(ls.enemies)
	## Fire a VFX flash via ElementMediator to demonstrate the temp stub
	var em = get_node("/root/ElementMediator")
	em.vfx_triggered.emit(&"vfx_steam_puff", e1)
	em.vfx_triggered.emit(&"vfx_arc_chain", e0)
