## BattleView_v2 — mockup-faithful battlefield (In_Battle.png layout).
##
## ONE shared battlefield, faint 3x3 grid, heroes anchored LEFT (one per lane),
## enemies advance leftward and render-SNAP to the nearest of 3 depth cells per lane
## (hybrid: LaneState keeps continuous screen_x; the view discretises for the look).
## Placeholder art (colored boxes); 2.5D perspective + sprites land in the art pass.
##
## Node tree (built in _ready):
##   Field   ColorRect   green ground
##   Grid    Control     faint 3x3 lines (thin ColorRects)
##   Heroes  Control     Hero0 / Hero1 / Hero2 anchored left, one per lane
##   Enemies Control     dynamic enemy nodes (box + name + HPBar + Status row)
##   Vfx     Control     reaction flash layer (top)
extends Control

const LANE_COUNT: int = 3
const DEPTH_CELLS: int = 3

## screen-x fraction per depth cell: cell 0 = far (right, just spawned), cell 2 = near (left, at hero).
const CELL_X: Array = [0.82, 0.58, 0.34]
const HERO_X: float = 0.10

## Default lane->hero assignment (post-FTUE; FTUE overrides via set_hero).
const DEFAULT_HEROES: Array = ["Elara", "Bran", "Vex"]
const HERO_COLORS: Array = [
	Color(0.62, 0.45, 0.85),  ## Elara purple
	Color(0.85, 0.62, 0.35),  ## Bran warm
	Color(0.30, 0.34, 0.40),  ## Vex dark
]
const STATUS_COLORS: Dictionary = {
	"Wet": Color(0.30, 0.55, 0.95),
	"Burning": Color(0.95, 0.45, 0.15),
	"Chilled": Color(0.45, 0.85, 0.95),
	"Shocked": Color(0.95, 0.85, 0.25),
	"Cracked": Color(0.55, 0.55, 0.58),
}

var _enemy_nodes: Dictionary = {}   ## eid -> Control

func _ready() -> void:
	_build_view()
	var hb := get_node_or_null("/root/Heartbeat")
	if hb != null and hb.has_signal("ticked"):
		hb.connect("ticked", _on_tick)
	var em := get_node_or_null("/root/ElementMediator")
	if em != null and em.has_signal("vfx_triggered"):
		em.connect("vfx_triggered", _on_vfx_triggered)
	if em != null and em.has_signal("audio_triggered"):
		em.connect("audio_triggered", _on_audio_triggered)

## ---- view size (fallback so positions are deterministic in headless w/o layout) ----

func _view_size() -> Vector2:
	var w: float = size.x if size.x > 1.0 else 420.0
	var h: float = size.y if size.y > 1.0 else 450.0
	return Vector2(w, h)

## ---- pure layout maths ----

## screen_x in [0,1] -> depth cell index 0(far)/1(mid)/2(near).
func _depth_cell_for(screen_x: float) -> int:
	if screen_x >= 0.67:
		return 0
	if screen_x >= 0.34:
		return 1
	return 2

## (lane, depth cell, stack) -> pixel center within the battlefield.
func _cell_position(lane: int, cell: int, stack: int = 0) -> Vector2:
	var vs := _view_size()
	var lane_h: float = vs.y / float(LANE_COUNT)
	var cx: float = CELL_X[clampi(cell, 0, DEPTH_CELLS - 1)]
	var x: float = cx * vs.x
	var y: float = float(lane) * lane_h + lane_h * 0.5 + float(stack) * 14.0
	return Vector2(x, y)

## ---- build ----

func _build_view() -> void:
	var field := ColorRect.new()
	field.name = "Field"
	field.color = Color(0.40, 0.58, 0.30)  ## grassy green placeholder
	_fill(field)
	add_child(field)

	var grid := Control.new()
	grid.name = "Grid"
	_fill(grid)
	add_child(grid)
	_build_grid_lines(grid)

	var heroes := Control.new()
	heroes.name = "Heroes"
	_fill(heroes)
	add_child(heroes)
	for i in LANE_COUNT:
		heroes.add_child(_make_hero_anchor(i))

	var enemies := Control.new()
	enemies.name = "Enemies"
	_fill(enemies)
	add_child(enemies)

	var vfx := Control.new()
	vfx.name = "Vfx"
	_fill(vfx)
	add_child(vfx)

func _fill(c: Control) -> void:
	c.anchor_left = 0.0; c.anchor_top = 0.0
	c.anchor_right = 1.0; c.anchor_bottom = 1.0
	c.offset_left = 0; c.offset_top = 0
	c.offset_right = 0; c.offset_bottom = 0
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _build_grid_lines(grid: Control) -> void:
	var faint := Color(1, 1, 1, 0.14)
	## interior verticals (depth dividers)
	for i in range(1, DEPTH_CELLS):
		var v := ColorRect.new()
		v.color = faint
		v.anchor_left = float(i) / DEPTH_CELLS; v.anchor_right = float(i) / DEPTH_CELLS
		v.anchor_top = 0.0; v.anchor_bottom = 1.0
		v.offset_left = -1; v.offset_right = 1
		v.mouse_filter = Control.MOUSE_FILTER_IGNORE
		grid.add_child(v)
	## interior horizontals (lane dividers)
	for j in range(1, LANE_COUNT):
		var h := ColorRect.new()
		h.color = faint
		h.anchor_top = float(j) / LANE_COUNT; h.anchor_bottom = float(j) / LANE_COUNT
		h.anchor_left = 0.0; h.anchor_right = 1.0
		h.offset_top = -1; h.offset_bottom = 1
		h.mouse_filter = Control.MOUSE_FILTER_IGNORE
		grid.add_child(h)

func _make_hero_anchor(lane: int) -> Control:
	var anchor := Control.new()
	anchor.name = "Hero%d" % lane
	anchor.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var box := ColorRect.new()
	box.name = "Box"
	box.color = HERO_COLORS[lane]
	box.size = Vector2(48, 56)
	box.position = Vector2(-24, -28)
	anchor.add_child(box)
	var lbl := Label.new()
	lbl.name = "Name"
	lbl.add_theme_font_size_override(&"font_size", 11)
	lbl.text = DEFAULT_HEROES[lane]
	lbl.position = Vector2(-24, 28)
	anchor.add_child(lbl)
	_position_hero(anchor, lane)
	return anchor

func _position_hero(anchor: Control, lane: int) -> void:
	var vs := _view_size()
	var lane_h: float = vs.y / float(LANE_COUNT)
	anchor.position = Vector2(HERO_X * vs.x, float(lane) * lane_h + lane_h * 0.5)

## ---- tick / sync ----

func _on_tick() -> void:
	var ls := get_node_or_null("/root/LaneState")
	if ls == null:
		return
	_sync_enemies(ls.enemies)

func _sync_enemies(enemies: Array) -> void:
	var enemies_node := get_node_or_null("Enemies")
	if enemies_node == null:
		return
	var seen_ids: Array = []
	var cell_stack: Dictionary = {}  ## "lane:cell" -> count placed so far
	for enemy in enemies:
		var eid: String = "%s_%d" % [enemy.id, enemy.lane]
		seen_ids.append(eid)
		var cell: int = _depth_cell_for(float(enemy.screen_x))
		var key: String = "%d:%d" % [int(enemy.lane), cell]
		var stack: int = int(cell_stack.get(key, 0))
		cell_stack[key] = stack + 1
		var node: Control = _enemy_nodes.get(eid)
		if node == null:
			node = _make_enemy_node(eid, enemy)
			enemies_node.add_child(node)
			_enemy_nodes[eid] = node
		_update_enemy_node(node, enemy, cell, stack)
	for old_id in _enemy_nodes.keys():
		if not seen_ids.has(old_id):
			_enemy_nodes[old_id].queue_free()
			_enemy_nodes.erase(old_id)

func _make_enemy_node(eid: String, enemy: Dictionary) -> Control:
	var node := Control.new()
	node.name = eid
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var box := ColorRect.new()
	box.name = "Box"
	box.color = Color(0.50, 0.28, 0.30)
	box.size = Vector2(40, 44)
	box.position = Vector2(-20, -22)
	node.add_child(box)

	var lbl := Label.new()
	lbl.name = "Name"
	lbl.add_theme_font_size_override(&"font_size", 9)
	lbl.text = str(enemy.id)
	lbl.position = Vector2(-20, -36)
	node.add_child(lbl)

	## HP bar background + fill
	var hp_bg := ColorRect.new()
	hp_bg.name = "HPBarBG"
	hp_bg.color = Color(0.1, 0.1, 0.1, 0.8)
	hp_bg.size = Vector2(40, 5)
	hp_bg.position = Vector2(-20, 24)
	node.add_child(hp_bg)
	var hp := ColorRect.new()
	hp.name = "HPBar"
	hp.color = Color(0.30, 0.85, 0.35)
	hp.size = Vector2(40, 5)
	hp.position = Vector2(-20, 24)
	node.add_child(hp)

	var status := HBoxContainer.new()
	status.name = "Status"
	status.position = Vector2(-20, -50)
	status.add_theme_constant_override(&"separation", 2)
	node.add_child(status)

	return node

func _update_enemy_node(node: Control, enemy: Dictionary, cell: int, stack: int) -> void:
	node.position = _cell_position(int(enemy.lane), cell, stack)
	var lbl := node.get_node_or_null("Name") as Label
	if lbl != null:
		lbl.text = str(enemy.id)
	## HP fill
	var hp := node.get_node_or_null("HPBar") as ColorRect
	if hp != null:
		var max_hp: float = maxf(float(enemy.get("max_hp", enemy.hp)), 1.0)
		var frac: float = clampf(float(enemy.hp) / max_hp, 0.0, 1.0)
		hp.size = Vector2(40.0 * frac, 5)
	## status dots
	var status := node.get_node_or_null("Status")
	if status != null:
		for c in status.get_children():
			c.queue_free()
		for s in enemy.statuses.keys():
			var dot := ColorRect.new()
			dot.color = STATUS_COLORS.get(String(s), Color(1, 1, 1))
			dot.custom_minimum_size = Vector2(8, 8)
			status.add_child(dot)

## ---- VFX (placeholder flash; real sprites in art pass) ----

func _on_vfx_triggered(hook: StringName, enemy: Dictionary) -> void:
	var vfx := get_node_or_null("Vfx")
	if vfx == null:
		vfx = self
	var rect := ColorRect.new()
	rect.name = "VfxFlash_%d" % Time.get_ticks_msec()
	rect.color = _vfx_color_for(hook)
	rect.size = Vector2(44, 44)
	var cell: int = _depth_cell_for(float(enemy.get("screen_x", 0.5)))
	var pos: Vector2 = _cell_position(int(enemy.get("lane", 1)), cell, 0)
	rect.position = pos - Vector2(22, 22)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vfx.add_child(rect)
	var tw := create_tween()
	tw.tween_property(rect, "modulate:a", 0.0, 0.4)
	tw.tween_callback(rect.queue_free)

func _on_audio_triggered(hook: StringName, _enemy: Dictionary) -> void:
	print("[audio-stub] ", String(hook))

func _vfx_color_for(hook: StringName) -> Color:
	match String(hook):
		"vfx_steam_puff": return Color(1.0, 1.0, 1.0, 0.85)
		"vfx_arc_chain":  return Color(0.5, 0.8, 1.0, 0.85)
		_:                return Color(1.0, 0.6, 0.2, 0.85)
