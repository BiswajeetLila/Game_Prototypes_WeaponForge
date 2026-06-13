## AUTOSHOT demo wrapper — populates ForgePanel_v2 with shop + heroes + bars.
extends Control

const ForgePanelScene = preload("res://scenes/ui/ForgePanel_v2.tscn")

func _ready() -> void:
	anchor_right = 1.0; anchor_bottom = 1.0
	var fp = ForgePanelScene.instantiate()
	fp.anchor_right = 1.0; fp.anchor_bottom = 1.0
	add_child(fp)
	## Shop populated mid-stage: 4 of 7 slots filled
	fp.populate_shop([
		{"id": "FIRE"}, {"id": "WATER"}, {"id": "LIGHTNING"}, {"id": "AOE"},
	])
	## Heroes with varied HP + Ult bars
	fp.set_hero_hp(0, 30, 30)
	fp.set_hero_hp(1, 22, 30)
	fp.set_hero_hp(2, 14, 30)
	fp.set_hero_ult_bars(0, 1)
	fp.set_hero_ult_bars(1, 2)
	fp.set_hero_ult_bars(2, 3)
	## Mount Functions on a few sockets
	if fp.has_method("set_socket_fn"):
		fp.set_socket_fn(0, 0, &"FIRE")
		fp.set_socket_fn(0, 1, &"WATER")
		fp.set_socket_fn(1, 0, &"FIRE")
		fp.set_socket_fn(2, 0, &"LIGHTNING")
