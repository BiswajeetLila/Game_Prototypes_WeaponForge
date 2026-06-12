## Test stress — simulate 5 waves x 10 ticks each, watch for runaway memory
## growth or hung step(). No UI / signal listeners beyond what autoloads
## already do. If THIS hangs, the bug is in Combat / GameState / Recipes core.
## If THIS runs clean but Main scene hangs, the bug is in the UI signal layer.
extends Control

const InventoryItemT = preload("res://scripts/data/inventory_item.gd")

var _lines: Array = []

func _ready() -> void:
	_log("=== Stress: 5 waves × 10 ticks ===")
	var t0: int = Time.get_ticks_msec()
	var mem0: int = OS.get_static_memory_usage()
	GameState.new_session()
	for w in range(1, 6):
		_run_wave(w)
		var mem_now: int = OS.get_static_memory_usage()
		_log("  wave %d done — heap %d KB (Δ %d KB)" % [w, mem_now / 1024, (mem_now - mem0) / 1024])
	var elapsed: int = Time.get_ticks_msec() - t0
	_log("=== done in %d ms ===" % elapsed)
	_render_to_ui()

func _run_wave(w: int) -> void:
	## Gear Bran with a fire+ice recipe combo to maximise signal traffic per tick
	## (Steamburst splash hits + ult fill + Hellfire chains potentially).
	var hero = GameState.hero
	if hero == null or hero.weapon == null:
		_log("  wave %d skipped — no hero" % w)
		return
	hero.weapon.set_slot(&"head", InventoryItemT.new(GameState.next_uid(), &"h_iron_edge", 1))
	hero.weapon.set_slot(&"hilt", InventoryItemT.new(GameState.next_uid(), &"p_pyro_pommel", 1))
	hero.weapon.set_slot(&"rune", InventoryItemT.new(GameState.next_uid(), &"r_ice", 1))
	hero.refresh_max_hp()
	hero.hp = hero.max_hp
	Combat.start_wave(w, false)
	for tick in range(10):
		if not Combat.is_running():
			break
		Combat.step()
		## Heal hero so loop isn't terminated by death.
		hero.hp = hero.max_hp
		hero.is_dead = false
		## Refill enemies' hp so we keep firing signals.
		for enemy in GameState.enemies:
			if enemy.hp < 5:
				enemy.hp = enemy.max_hp
	Combat.stop()

func _log(line: String) -> void:
	print(line)
	_lines.append(line)

func _render_to_ui() -> void:
	var label := Label.new()
	label.add_theme_font_size_override(&"font_size", 12)
	label.text = "\n".join(_lines)
	label.anchor_right = 1.0
	label.anchor_bottom = 1.0
	label.offset_left = 12
	label.offset_top = 12
	add_child(label)
