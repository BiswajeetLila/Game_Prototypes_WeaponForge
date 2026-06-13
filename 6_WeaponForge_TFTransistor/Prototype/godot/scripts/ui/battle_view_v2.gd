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
	var em := get_node_or_null("/root/ElementMediator")
	if em != null and em.has_signal("vfx_triggered"):
		em.connect("vfx_triggered", _on_vfx_triggered)
	if em != null and em.has_signal("audio_triggered"):
		em.connect("audio_triggered", _on_audio_triggered)

## TEMP step-16 VFX stub. Spawns a brief colored ColorRect over enemy position.
## TODO Phase 5: replace with real VFX assets (steam puff sprite, electrocute arc).
func _on_vfx_triggered(hook: StringName, enemy: Dictionary) -> void:
	var rect := ColorRect.new()
	rect.name = "VfxFlash_%d" % Time.get_ticks_msec()
	rect.size = Vector2(40, 40)
	rect.color = _vfx_color_for(hook)
	var lane: int = int(enemy.get("lane", 1))
	var sx: float = float(enemy.get("screen_x", 0.5))
	var lane_h: float = size.y / float(LANE_COUNT)
	rect.position = Vector2(sx * size.x - 20, float(lane) * lane_h + lane_h * 0.5 - 20)
	add_child(rect)
	var tw := create_tween()
	tw.tween_property(rect, "modulate:a", 0.0, 0.4)
	tw.tween_callback(rect.queue_free)

## TEMP step-16 audio stub. Prints hook name.
## TODO Phase 5: load AudioStreamPlayer + actual SFX assets.
func _on_audio_triggered(hook: StringName, _enemy: Dictionary) -> void:
	print("[audio-stub] ", String(hook))

func _vfx_color_for(hook: StringName) -> Color:
	match String(hook):
		"vfx_steam_puff": return Color(1.0, 1.0, 1.0, 0.85)
		"vfx_arc_chain":  return Color(0.5, 0.8, 1.0, 0.85)
		_:                return Color(1.0, 0.6, 0.2, 0.85)

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
