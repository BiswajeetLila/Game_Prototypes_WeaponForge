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
	## demonstrate equipped sockets + a behavior preview for the capture
	m.gold = 1250
	if m.has_method("_on_socket_tap"):
		var injects = [[0, 2, "FIRE"], [0, 0, "WATER"], [1, 2, "LIGHTNING"], [2, 1, "AOE"]]
		for inj in injects:
			m._shop_items[0] = {"id": inj[2], "tier": 2, "cost": 1}
			m._on_shop_tap(0)
			m._on_socket_tap(inj[0], inj[1])
	## restock + tap an item to show the per-slot behavior preview
	m._shop_items = m.get_node("/root/ShopV2").roll_items(3, 7, false)
	if m.has_method("_refresh_shop_ui"):
		m._refresh_shop_ui()
	m._on_shop_tap(0)
	## show a couple of benched (Reserve) items for the QC capture
	if m._forge.has_method("set_reserve_item"):
		m._forge.set_reserve_item(0, 0, &"WATER")
		m._forge.set_reserve_item(1, 0, &"AOE")
		m._forge.set_reserve_item(2, 1, &"LEECH")
	if m.has_method("_refresh_weapon_tips"):
		m._refresh_weapon_tips()
	if m._forge.has_method("set_reroll_cost"):
		m._forge.set_reroll_cost(5)
	m._forge.set_gold(1250)
