## AUTOSHOT — BattleView_v2 + ChainHUD composite, mid-stage combat snapshot.
extends Control

const BattleViewScene = preload("res://scenes/ui/BattleView_v2.tscn")
const ChainHUDScene = preload("res://scenes/ui/ChainHUD.tscn")

func _ready() -> void:
	anchor_right = 1.0; anchor_bottom = 1.0
	var bv = BattleViewScene.instantiate()
	bv.anchor_right = 1.0; bv.anchor_bottom = 1.0
	add_child(bv)
	## Stage-3-style: 5 enemies across lanes 0+1
	var ls = get_node("/root/LaneState")
	ls.reset()
	var positions = [[0, 0.55], [0, 0.75], [1, 0.62], [1, 0.85], [0, 0.40]]
	for p in positions:
		var e = ls.make_enemy(&"goblin", p[0], p[1], 5)
		ls.enemies.append(e)
	## A couple of statuses for visual variety
	ls.apply_status(ls.enemies[1], &"Wet", 4)
	ls.apply_status(ls.enemies[3], &"Burning", 3)
	bv._sync_enemies(ls.enemies)
	## Drive ChainHUD to ×4
	var ch = ChainHUDScene.instantiate()
	add_child(ch)
	ch._on_reaction(&"steam", {})
	ch._on_reaction(&"electrocute", {})
	ch._on_reaction(&"steam", {})
	ch._on_reaction(&"steam", {})
