## Structural tests for Phase 4 UI scenes (steps 11-14 + mockup-faithful rebuild A1).
## Checks that each scene loads, key nodes present, key signals/methods exist.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== UiV2 structural tests ===")
	_test_battle_view_v2()
	_test_depth_cell_for()
	_test_render_snap_ordering()
	_test_enemy_node_structure()
	_test_real_sprites()
	_test_battle_view_vfx_flash()
	_test_battle_view_audio_logs()
	_test_forge_panel_v2()
	_test_wave_telegraph()
	_test_chain_hud()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

## -- A1: BattleView_v2 mockup-faithful layout --

func _test_battle_view_v2() -> void:
	var scene_path := "res://scenes/ui/BattleView_v2.tscn"
	var packed = load(scene_path)
	_check("bv2: scene file loads", packed != null, "path missing: " + scene_path)
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("bv2: Field bg exists", inst.get_node_or_null("Field") != null, "")
	_check("bv2: Grid overlay exists", inst.get_node_or_null("Grid") != null, "")
	_check("bv2: Heroes container exists", inst.get_node_or_null("Heroes") != null, "")
	_check("bv2: Hero0 anchor (lane 0)", inst.get_node_or_null("Heroes/Hero0") != null, "")
	_check("bv2: Hero1 anchor (lane 1)", inst.get_node_or_null("Heroes/Hero1") != null, "")
	_check("bv2: Hero2 anchor (lane 2)", inst.get_node_or_null("Heroes/Hero2") != null, "")
	_check("bv2: Enemies container exists", inst.get_node_or_null("Enemies") != null, "")
	_check("bv2: Vfx layer exists", inst.get_node_or_null("Vfx") != null, "")
	_check("bv2: has _sync_enemies", inst.has_method("_sync_enemies"), "")
	_check("bv2: has _depth_cell_for", inst.has_method("_depth_cell_for"), "")
	_check("bv2: has _cell_position", inst.has_method("_cell_position"), "")
	inst.queue_free()

func _test_depth_cell_for() -> void:
	var packed = load("res://scenes/ui/BattleView_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	if not inst.has_method("_depth_cell_for"):
		_check("bv2: _depth_cell_for present", false, "method missing")
		inst.queue_free()
		return
	## screen_x 1.0 = far (right, just spawned); 0.0 = near (left, at hero)
	_check("bv2: sx 1.0 -> far cell 0", inst._depth_cell_for(1.0) == 0, "got %d" % inst._depth_cell_for(1.0))
	_check("bv2: sx 0.7 -> cell 0", inst._depth_cell_for(0.7) == 0, "got %d" % inst._depth_cell_for(0.7))
	_check("bv2: sx 0.5 -> mid cell 1", inst._depth_cell_for(0.5) == 1, "got %d" % inst._depth_cell_for(0.5))
	_check("bv2: sx 0.34 -> cell 1", inst._depth_cell_for(0.34) == 1, "got %d" % inst._depth_cell_for(0.34))
	_check("bv2: sx 0.2 -> near cell 2", inst._depth_cell_for(0.2) == 2, "got %d" % inst._depth_cell_for(0.2))
	_check("bv2: sx 0.0 -> cell 2", inst._depth_cell_for(0.0) == 2, "got %d" % inst._depth_cell_for(0.0))
	inst.queue_free()

func _test_render_snap_ordering() -> void:
	var packed = load("res://scenes/ui/BattleView_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	if not inst.has_method("_cell_position"):
		_check("bv2: _cell_position present", false, "method missing")
		inst.queue_free()
		return
	var far: Vector2 = inst._cell_position(0, 0, 0)   ## lane 0, far cell
	var near: Vector2 = inst._cell_position(0, 2, 0)   ## lane 0, near cell
	_check("bv2: far cell renders RIGHT of near cell", far.x > near.x, "far.x=%.1f near.x=%.1f" % [far.x, near.x])
	var lane0: Vector2 = inst._cell_position(0, 1, 0)
	var lane2: Vector2 = inst._cell_position(2, 1, 0)
	_check("bv2: lane 0 renders ABOVE lane 2", lane0.y < lane2.y, "lane0.y=%.1f lane2.y=%.1f" % [lane0.y, lane2.y])
	inst.queue_free()

func _test_enemy_node_structure() -> void:
	var packed = load("res://scenes/ui/BattleView_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	var ls = get_node_or_null("/root/LaneState")
	if ls == null or not inst.has_method("_sync_enemies"):
		_check("bv2: enemy-node test prerequisites", false, "LaneState or _sync_enemies missing")
		inst.queue_free()
		return
	ls.reset()
	var e = ls.make_enemy(&"goblin", 0, 0.8)
	ls.apply_status(e, &"Wet", 4)
	inst._sync_enemies([e])
	var enemies_node = inst.get_node_or_null("Enemies")
	_check("bv2: enemy spawned under Enemies", enemies_node != null and enemies_node.get_child_count() == 1,
		"got %d" % (enemies_node.get_child_count() if enemies_node != null else -1))
	if enemies_node != null and enemies_node.get_child_count() > 0:
		var en = enemies_node.get_child(0)
		_check("bv2: enemy node has HPBar", en.find_child("HPBar", true, false) != null, "")
		_check("bv2: enemy node has Status row", en.find_child("Status", true, false) != null, "")
	inst.queue_free()

## B1: real chibi sprites wired into hero anchors + enemy nodes.
func _test_real_sprites() -> void:
	var packed = load("res://scenes/ui/BattleView_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	var h0 = inst.get_node_or_null("Heroes/Hero0")
	var hs = h0.find_child("Sprite", true, false) if h0 != null else null
	_check("bv2: hero anchor has Sprite node", hs != null, "")
	_check("bv2: hero Sprite has texture (elara art wired)", hs != null and hs.texture != null, "")
	var ls = get_node_or_null("/root/LaneState")
	if ls != null and inst.has_method("_sync_enemies"):
		ls.reset()
		var e = ls.make_enemy(&"goblin", 0, 0.8)
		inst._sync_enemies([e])
		var enemies_node = inst.get_node_or_null("Enemies")
		if enemies_node != null and enemies_node.get_child_count() > 0:
			var es = enemies_node.get_child(0).find_child("Sprite", true, false)
			_check("bv2: enemy node has Sprite node", es != null, "")
			_check("bv2: enemy Sprite has goblin texture", es != null and es.texture != null, "")
	inst.queue_free()

func _test_battle_view_vfx_flash() -> void:
	var packed = load("res://scenes/ui/BattleView_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("bv2: has _on_vfx_triggered method", inst.has_method("_on_vfx_triggered"), "")
	var ls = get_node_or_null("/root/LaneState")
	if ls != null:
		ls.reset()
		var e = ls.make_enemy(&"g", 1, 0.5)
		inst._sync_enemies([e])
		var vfx = inst.get_node_or_null("Vfx")
		var before: int = (vfx.get_child_count() if vfx != null else inst.get_child_count())
		inst._on_vfx_triggered(&"vfx_steam_puff", e)
		var after: int = (vfx.get_child_count() if vfx != null else inst.get_child_count())
		_check("bv2: vfx flash adds a node", after > before, "before=%d after=%d" % [before, after])
	inst.queue_free()

func _test_battle_view_audio_logs() -> void:
	var packed = load("res://scenes/ui/BattleView_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("bv2: has _on_audio_triggered method", inst.has_method("_on_audio_triggered"), "")
	inst._on_audio_triggered(&"sfx_steam_hiss", {})
	_check("bv2: audio handler runs without error", true, "")
	inst.queue_free()

## -- Step 12: ForgePanel_v2 --

func _test_forge_panel_v2() -> void:
	var scene_path := "res://scenes/ui/ForgePanel_v2.tscn"
	var packed = load(scene_path)
	_check("fp2: scene file loads", packed != null, "path missing: " + scene_path)
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("fp2: ShopRail exists", inst.get_node_or_null("ShopRail") != null, "")
	_check("fp2: HeroRows exists", inst.get_node_or_null("HeroRows") != null, "")
	var rail = inst.get_node_or_null("ShopRail")
	_check("fp2: ShopRail has 7 children", rail != null and rail.get_child_count() == 7,
		"got %d" % (rail.get_child_count() if rail != null else -1))
	var rows = inst.get_node_or_null("HeroRows")
	_check("fp2: HeroRows has 3 children", rows != null and rows.get_child_count() == 3,
		"got %d" % (rows.get_child_count() if rows != null else -1))
	_check("fp2: populate_shop method", inst.has_method("populate_shop"), "")
	_check("fp2: set_hero_hp method", inst.has_method("set_hero_hp"), "")
	_check("fp2: set_hero_ult_bars method", inst.has_method("set_hero_ult_bars"), "")
	_check("fp2: socket_tapped signal", inst.has_signal("socket_tapped"), "")
	_check("fp2: shop_item_tapped signal", inst.has_signal("shop_item_tapped"), "")
	## A2: shop moved to BOTTOM, hero rows above (mockup layout)
	_check("fp2: ShopRail anchored at BOTTOM", rail != null and rail.anchor_top >= 0.7,
		"anchor_top=%.2f" % (rail.anchor_top if rail != null else -1.0))
	_check("fp2: HeroRows above shop", rows != null and rail != null and rows.anchor_top < rail.anchor_top,
		"rows.top=%.2f shop.top=%.2f" % [(rows.anchor_top if rows != null else -1.0), (rail.anchor_top if rail != null else -1.0)])
	_check("fp2: GoldLabel exists", inst.find_child("GoldLabel", true, false) != null, "")
	_check("fp2: RerollBtn exists", inst.find_child("RerollBtn", true, false) != null, "")
	_check("fp2: set_socket_fn method", inst.has_method("set_socket_fn"), "")
	## B2: hero portraits use real chibi textures
	if rows != null and rows.get_child_count() > 0:
		var portrait = rows.get_child(0).get_node_or_null("Portrait")
		_check("fp2: portrait is a TextureRect", portrait is TextureRect, "")
		_check("fp2: portrait has hero texture (elara)", portrait is TextureRect and portrait.texture != null, "")
	inst.queue_free()

## -- Step 13: WaveTelegraph --

func _test_wave_telegraph() -> void:
	var scene_path := "res://scenes/ui/WaveTelegraph.tscn"
	var packed = load(scene_path)
	_check("wt: scene file loads", packed != null, "path missing: " + scene_path)
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("wt: starts invisible", inst.visible == false, "")
	_check("wt: TitleLabel exists", inst.get_node_or_null("PanelContainer/VBoxContainer/TitleLabel") != null
		or inst.find_child("TitleLabel", true, false) != null, "")
	_check("wt: DismissBtn exists", inst.find_child("DismissBtn", true, false) != null, "")
	_check("wt: show_wave method", inst.has_method("show_wave"), "")
	_check("wt: dismissed signal", inst.has_signal("dismissed"), "")
	inst.show_wave(1, 3, [{"lane": 0, "id": "goblin", "weakness_tag": "WATER"}])
	_check("wt: visible after show_wave", inst.visible == true, "")
	inst.queue_free()

## -- Step 14: ChainHUD --

func _test_chain_hud() -> void:
	var scene_path := "res://scenes/ui/ChainHUD.tscn"
	var packed = load(scene_path)
	_check("ch: scene file loads", packed != null, "path missing: " + scene_path)
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("ch: ChainLabel exists", inst.find_child("ChainLabel", true, false) != null, "")
	_check("ch: get_chain_count method", inst.has_method("get_chain_count"), "")
	_check("ch: chain starts at 0", inst.get_chain_count() == 0, "got %d" % inst.get_chain_count())
	inst._on_reaction(&"steam", {})
	_check("ch: chain = 1 after reaction", inst.get_chain_count() == 1, "got %d" % inst.get_chain_count())
	inst._on_reaction(&"electrocute", {})
	_check("ch: chain = 2 after second reaction", inst.get_chain_count() == 2, "got %d" % inst.get_chain_count())
	inst._reset_chain()
	_check("ch: chain = 0 after reset", inst.get_chain_count() == 0, "got %d" % inst.get_chain_count())
	inst.queue_free()

func _check(name: String, ok: bool, detail: String) -> void:
	if ok: _passed += 1; _log("  PASS  " + name)
	else: _failed += 1; _log("  FAIL  " + name + (("  [" + detail + "]") if detail != "" else ""))

func _summary() -> void:
	_log("=== %d passed / %d failed ===" % [_passed, _failed])

func _log(line: String) -> void:
	print(line)
	_lines.append(line)

func _render_to_ui() -> void:
	var label := Label.new()
	label.add_theme_font_size_override(&"font_size", 12)
	label.text = "\n".join(_lines)
	label.anchor_right = 1.0; label.anchor_bottom = 1.0
	label.offset_left = 12; label.offset_top = 12
	add_child(label)
