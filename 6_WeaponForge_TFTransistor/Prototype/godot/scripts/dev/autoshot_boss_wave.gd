## AUTOSHOT demo wrapper — stage 4 wave 2 BOSS state via WaveDirector + BattleView.
extends Control

const BattleViewScene = preload("res://scenes/ui/BattleView_v2.tscn")

func _ready() -> void:
	anchor_right = 1.0; anchor_bottom = 1.0
	var bv = BattleViewScene.instantiate()
	bv.anchor_right = 1.0; bv.anchor_bottom = 1.0
	add_child(bv)
	var ls = get_node("/root/LaneState")
	var wd = get_node("/root/WaveDirector")
	ls.reset()
	## Force ftue mode then pull the boss roster
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_autoshot_boss.json"
	acc.reset()
	wd.reset()
	var boss_spec: Array = wd.enemies_for_stage_wave(4, 2)
	for proto in boss_spec:
		## Override screen_x to keep label fully visible inside the 420px viewport
		var e = ls.make_enemy(proto.id, proto.lane, 0.7, proto.hp)
		ls.enemies.append(e)
	bv._sync_enemies(ls.enemies)
