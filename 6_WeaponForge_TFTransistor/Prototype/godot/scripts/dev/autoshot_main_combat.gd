## AUTOSHOT wrapper — Main_v2 frozen mid-COMBAT with a representative enemy set,
## varied statuses, and a couple of reaction VFX, for a combat-state capture.
extends Control

const MainV2Scene = preload("res://scenes/Main_v2.tscn")

func _ready() -> void:
	anchor_right = 1.0; anchor_bottom = 1.0
	var m = MainV2Scene.instantiate()
	m.anchor_right = 1.0; m.anchor_bottom = 1.0
	add_child(m)
	await get_tree().process_frame
	## Freeze: stop the tick timer, force COMBAT state, hide NEXT WAVE
	var t = m.get_node_or_null("TickTimer")
	if t != null:
		t.stop()
	m.state = 0  ## COMBAT
	var nb = m.get_node_or_null("NextWaveBtn")
	if nb != null:
		nb.visible = false
	## Seed a representative mid-combat board across all 3 lanes
	var ls = get_node_or_null("/root/LaneState")
	if ls == null:
		return
	ls.reset()
	var defs = [
		[&"goblin", 0, 0.85, &"Wet"], [&"skeleton", 0, 0.55, &"Burning"], [&"goblin", 0, 0.30, &""],
		[&"goblin", 1, 0.80, &"Wet"], [&"slime", 1, 0.50, &"Chilled"],
		[&"goblin", 2, 0.88, &""], [&"goblin", 2, 0.40, &"Wet"],
	]
	for d in defs:
		var e = ls.make_enemy(d[0], d[1], d[2], 5)
		if d[3] != &"":
			ls.apply_status(e, d[3], 30)
		ls.enemies.append(e)
	var bv = m.find_child("BattleView_v2", true, false)
	if bv != null and bv.has_method("_sync_enemies"):
		bv._sync_enemies(ls.enemies)
	## Fire a couple of reaction VFX for the combat-juice capture
	var em = get_node_or_null("/root/ElementMediator")
	if em != null and em.has_signal("vfx_triggered"):
		em.vfx_triggered.emit(&"vfx_steam_puff", ls.enemies[3])
		em.vfx_triggered.emit(&"vfx_arc_chain", ls.enemies[0])
