## BattleView_v2 — 3-lane corridor rendering for Phase 4 slice.
## Root of the combat viewport (middle section of screen).
## Displays enemies as placeholder rects at their screen_x positions per lane.
## Connects to LaneState for live enemy data; redraws each tick via Heartbeat.
extends Control

## Lane colors (placeholder — final art in Phase 5)
const LANE_COLORS: Array = [
	Color(0.18, 0.22, 0.32, 0.6),  ## lane 0 top
	Color(0.22, 0.28, 0.22, 0.6),  ## lane 1 mid
	Color(0.28, 0.22, 0.22, 0.6),  ## lane 2 bot
]
const LANE_COUNT: int = 3

var _lane_rects: Array = []       ## 3 ColorRect nodes
var _enemy_nodes: Dictionary = {} ## enemy id -> Label node

func _ready() -> void:
	_build_lanes()
	var hb := get_node_or_null("/root/Heartbeat")
	if hb != null and hb.has_signal("ticked"):
		hb.connect("ticked", _on_tick)

func _build_lanes() -> void:
	for i in LANE_COUNT:
		var rect := ColorRect.new()
		rect.name = "Lane%d" % i
		rect.color = LANE_COLORS[i]
		rect.anchor_left = 0.0; rect.anchor_right = 1.0
		rect.anchor_top = float(i) / LANE_COUNT
		rect.anchor_bottom = float(i + 1) / LANE_COUNT
		rect.offset_left = 0; rect.offset_right = 0
		rect.offset_top = 0; rect.offset_bottom = 0
		add_child(rect)
		_lane_rects.append(rect)

func _on_tick() -> void:
	var ls := get_node_or_null("/root/LaneState")
	if ls == null:
		return
	_sync_enemies(ls.enemies)

func _sync_enemies(enemies: Array) -> void:
	var seen_ids: Array = []
	for enemy in enemies:
		var eid: String = "%s_%d" % [enemy.id, enemy.lane]
		seen_ids.append(eid)
		if not _enemy_nodes.has(eid):
			_spawn_enemy_node(eid, enemy)
		_update_enemy_node(eid, enemy)
	## Remove stale enemy nodes
	for old_id in _enemy_nodes.keys():
		if not seen_ids.has(old_id):
			_enemy_nodes[old_id].queue_free()
			_enemy_nodes.erase(old_id)

func _spawn_enemy_node(eid: String, enemy: Dictionary) -> void:
	var lbl := Label.new()
	lbl.name = eid
	lbl.add_theme_font_size_override(&"font_size", 10)
	lbl.text = str(enemy.id)
	add_child(lbl)
	_enemy_nodes[eid] = lbl

func _update_enemy_node(eid: String, enemy: Dictionary) -> void:
	var lbl: Label = _enemy_nodes[eid]
	var lane_height: float = size.y / float(LANE_COUNT)
	lbl.position = Vector2(
		enemy.screen_x * size.x,
		float(enemy.lane) * lane_height + lane_height * 0.3
	)
	lbl.text = "%s\nHP:%d\n%s" % [enemy.id, enemy.hp, str(enemy.statuses.keys())]
