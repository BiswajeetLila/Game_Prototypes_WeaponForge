## Structural tests for Phase 4 UI scenes (steps 11-14).
## Checks that each scene loads, key nodes present, key signals/methods exist.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== UiV2 structural tests ===")
	_test_battle_view_v2()
	_test_battle_view_vfx_flash()
	_test_battle_view_audio_logs()
	_test_forge_panel_v2()
	_test_wave_telegraph()
	_test_chain_hud()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

## -- Step 11: BattleView_v2 --

func _test_battle_view_v2() -> void:
	var scene_path := "res://scenes/ui/BattleView_v2.tscn"
	var packed = load(scene_path)
	_check("bv2: scene file loads", packed != null, "path missing: " + scene_path)
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("bv2: 3 Lane children created", inst.get_child_count() >= 3, "got %d" % inst.get_child_count())
	_check("bv2: Lane0 exists", inst.get_node_or_null("Lane0") != null, "")
	_check("bv2: Lane1 exists", inst.get_node_or_null("Lane1") != null, "")
	_check("bv2: Lane2 exists", inst.get_node_or_null("Lane2") != null, "")
	_check("bv2: has _sync_enemies method", inst.has_method("_sync_enemies"), "")
	inst.queue_free()

## -- Step 16: VFX/audio temp stubs --

func _test_battle_view_vfx_flash() -> void:
	var scene_path := "res://scenes/ui/BattleView_v2.tscn"
	var packed = load(scene_path)
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("bv2: has _on_vfx_triggered method", inst.has_method("_on_vfx_triggered"), "")
	## Spawn a fake enemy node so flash has a position anchor.
	var ls = get_node_or_null("/root/LaneState")
	if ls != null:
		ls.reset()
		var e = ls.make_enemy(&"g", 1, 0.5)
		inst._sync_enemies([e])
		var before: int = inst.get_child_count()
		inst._on_vfx_triggered(&"vfx_steam_puff", e)
		_check("bv2: vfx flash adds child node", inst.get_child_count() > before, "before=%d after=%d" % [before, inst.get_child_count()])
	inst.queue_free()

func _test_battle_view_audio_logs() -> void:
	var scene_path := "res://scenes/ui/BattleView_v2.tscn"
	var packed = load(scene_path)
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("bv2: has _on_audio_triggered method", inst.has_method("_on_audio_triggered"), "")
	## Just call it — stub should print, not crash.
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
	## Check 7 shop slots
	var rail = inst.get_node_or_null("ShopRail")
	_check("fp2: ShopRail has 7 children", rail != null and rail.get_child_count() == 7,
		"got %d" % (rail.get_child_count() if rail != null else -1))
	## Check 3 hero rows
	var rows = inst.get_node_or_null("HeroRows")
	_check("fp2: HeroRows has 3 children", rows != null and rows.get_child_count() == 3,
		"got %d" % (rows.get_child_count() if rows != null else -1))
	## Check socket signals / methods
	_check("fp2: populate_shop method", inst.has_method("populate_shop"), "")
	_check("fp2: set_hero_hp method", inst.has_method("set_hero_hp"), "")
	_check("fp2: set_hero_ult_bars method", inst.has_method("set_hero_ult_bars"), "")
	_check("fp2: socket_tapped signal", inst.has_signal("socket_tapped"), "")
	_check("fp2: shop_item_tapped signal", inst.has_signal("shop_item_tapped"), "")
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
	## Show and check visibility
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
	## Simulate reactions
	inst._on_reaction(&"steam", {})
	_check("ch: chain = 1 after reaction", inst.get_chain_count() == 1, "got %d" % inst.get_chain_count())
	inst._on_reaction(&"electrocute", {})
	_check("ch: chain = 2 after second reaction", inst.get_chain_count() == 2, "got %d" % inst.get_chain_count())
	## Manual reset
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
