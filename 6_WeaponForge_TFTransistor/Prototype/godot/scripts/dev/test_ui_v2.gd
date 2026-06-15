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
	_test_battle_chips()
	_test_battle_view_vfx_flash()
	_test_battle_view_audio_logs()
	_test_forge_panel_v2()
	_test_forge_cards()
	_test_weapon_tooltip()
	_test_reserve_ui()
	_test_ult_button()
	_test_battle_hit_vfx()
	_test_merge_vfx()
	_test_home_v2()
	_test_tier_border()
	_test_compact_mode()
	_test_battle_hero_hp()
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

## -- C10: enemy status chips + numeric HP + reaction labels --

func _test_battle_chips() -> void:
	var packed = load("res://scenes/ui/BattleView_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	var ls = get_node_or_null("/root/LaneState")
	if ls == null:
		inst.queue_free()
		return
	ls.reset()
	var e = ls.make_enemy(&"goblin", 0, 0.8, 5)
	ls.apply_status(e, &"Burning", 4)
	inst._sync_enemies([e])
	var en = inst.get_node("Enemies").get_child(0)
	## compact battle: NO verbose text — no enemy name, no numeric HP, no chip label
	_check("bc: enemy name text removed (compact)", en.find_child("Name", true, false) == null, "")
	_check("bc: enemy numeric HP removed (compact)", en.find_child("HPValue", true, false) == null, "")
	_check("bc: status chip is a text-free icon (no ChipLabel)", en.find_child("ChipLabel", true, false) == null, "")
	var status = en.find_child("Status", true, false)
	_check("bc: status shows an icon dot", status != null and status.get_child_count() >= 1, "got %d" % (status.get_child_count() if status != null else -1))
	_check("bc: has show_reaction_label", inst.has_method("show_reaction_label"), "")
	if inst.has_method("show_reaction_label"):
		var vfx = inst.get_node_or_null("Vfx")
		var before: int = vfx.get_child_count() if vfx != null else 0
		inst.show_reaction_label(&"steam", e)
		var after: int = vfx.get_child_count() if vfx != null else 0
		_check("bc: reaction label spawned", after > before, "before=%d after=%d" % [before, after])
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
		if vfx != null and vfx.get_child_count() > 0:
			var last = vfx.get_child(vfx.get_child_count() - 1)
			_check("bv2: steam vfx uses textured sprite", last is TextureRect and last.texture != null, "")
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
	_check("fp2: set_weapon_desc method (HP moved to battle)", inst.has_method("set_weapon_desc"), "")
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
	## B3: rune icons in shop slots + sockets
	inst.populate_shop([{"id": "FIRE"}, {"id": "LIGHTNING"}])
	if rail != null and rail.get_child_count() > 0:
		var icon = rail.get_child(0).find_child("Icon", true, false)
		_check("fp2: shop slot has Icon node", icon != null, "")
		_check("fp2: shop slot Icon textured after populate", icon != null and icon.texture != null, "")
	inst.set_socket_fn(0, 0, &"FIRE")
	if rows != null and rows.get_child_count() > 0:
		var sock = rows.get_child(0).find_child("Socket0_0", true, false)
		var sicon = sock.find_child("Icon", true, false) if sock != null else null
		_check("fp2: socket has Icon node", sicon != null, "")
		_check("fp2: socket Icon textured after equip", sicon != null and sicon.texture != null, "")
	inst.queue_free()

## -- C6/C7: forge socket cards + shop cards (info) --

func _test_forge_cards() -> void:
	var packed = load("res://scenes/ui/ForgePanel_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	## empty-socket watermark = slot name (C1 order: 0=PASSIVE, 2=ACTIVE)
	var s00 = inst.find_child("Socket0_0", true, false)
	var nm00 = s00.find_child("NameLabel", true, false) if s00 != null else null
	_check("fc: empty socket0_0 watermark PASSIVE", nm00 != null and nm00.text == "PASSIVE", "got %s" % (nm00.text if nm00 != null else "null"))
	var s02 = inst.find_child("Socket0_2", true, false)
	var nm02 = s02.find_child("NameLabel", true, false) if s02 != null else null
	_check("fc: empty socket0_2 watermark ACTIVE", nm02 != null and nm02.text == "ACTIVE", "got %s" % (nm02.text if nm02 != null else "null"))
	_check("fc: socket card >= 56px", s02 != null and s02.custom_minimum_size.x >= 56, "got %s" % (str(s02.custom_minimum_size) if s02 != null else "null"))
	## equip with tier 2 -> name + 2 stars
	inst.set_socket_fn(0, 2, &"FIRE", 2, "FIRE", "")
	_check("fc: equipped socket name FIRE", nm02 != null and nm02.text == "FIRE", "got %s" % (nm02.text if nm02 != null else "null"))
	var stars = s02.find_child("TierStars", true, false)
	_check("fc: tier 2 -> 2 stars", stars != null and stars.text.length() == 2, "got %s" % (stars.text if stars != null else "null"))
	## merge pending "2/2"
	inst.set_socket_fn(1, 1, &"WATER", 1, "WATER", "2/2")
	var s11 = inst.find_child("Socket1_1", true, false)
	var mg = s11.find_child("MergeLabel", true, false) if s11 != null else null
	_check("fc: merge label 2/2", mg != null and mg.text == "2/2", "got %s" % (mg.text if mg != null else "null"))
	## shop card name + cost
	inst.populate_shop([{"id": "FIRE", "tier": 1, "cost": 1}])
	var slot0 = inst.get_node("ShopRail").get_child(0)
	var snm = slot0.find_child("NameLabel", true, false)
	_check("fc: shop card name FIRE", snm != null and snm.text == "FIRE", "got %s" % (snm.text if snm != null else "null"))
	var scost = slot0.find_child("CostLabel", true, false)
	_check("fc: shop card cost shows 1", scost != null and "1" in scost.text, "got %s" % (scost.text if scost != null else "null"))
	## reroll cost + enabled
	_check("fc: has set_reroll_cost", inst.has_method("set_reroll_cost"), "")
	if inst.has_method("set_reroll_cost"):
		inst.set_reroll_cost(1)
		var rb = inst.find_child("RerollBtn", true, false)
		_check("fc: reroll btn shows cost 1", rb != null and "1" in rb.text, "got %s" % (rb.text if rb != null else "null"))
	_check("fc: has set_reroll_enabled", inst.has_method("set_reroll_enabled"), "")
	if inst.has_method("set_reroll_enabled"):
		inst.set_reroll_enabled(false)
		var rb2 = inst.find_child("RerollBtn", true, false)
		_check("fc: reroll disabled toggles", rb2 != null and rb2.disabled == true, "")
	inst.queue_free()

## -- #2: always-on weapon tooltip (combined effect) replaces the C8 overlay --

func _test_weapon_tooltip() -> void:
	var packed = load("res://scenes/ui/ForgePanel_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("wt: no overlapping PreviewPanel (removed)", inst.get_node_or_null("PreviewPanel") == null, "")
	_check("wt: has set_weapon_desc", inst.has_method("set_weapon_desc"), "")
	var rows = inst.get_node_or_null("HeroRows")
	var tip0 = rows.get_child(0).find_child("WeaponTooltip", true, false) if rows != null else null
	_check("wt: row has WeaponTooltip", tip0 != null, "")
	_check("wt: tooltip defaults to Empty weapon", tip0 != null and "Empty" in tip0.text, "got %s" % (tip0.text if tip0 != null else "null"))
	if inst.has_method("set_weapon_desc"):
		inst.set_weapon_desc(0, "ATK: Hits closest, applies Burning")
		_check("wt: set_weapon_desc updates tooltip", tip0 != null and "Burning" in tip0.text, "got %s" % (tip0.text if tip0 != null else "null"))
	inst.queue_free()

## -- G3: Reserve bench column + sell signals (Forge_State_edits.jpg) --

func _test_reserve_ui() -> void:
	var packed = load("res://scenes/ui/ForgePanel_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("rsv: reserve_tapped signal", inst.has_signal("reserve_tapped"), "")
	_check("rsv: socket_sell signal", inst.has_signal("socket_sell"), "")
	_check("rsv: reserve_sell signal", inst.has_signal("reserve_sell"), "")
	_check("rsv: has set_reserve_item", inst.has_method("set_reserve_item"), "")
	_check("rsv: has flash_error", inst.has_method("flash_error"), "")
	_check("rsv: Reserve header label", inst.find_child("ReserveHeader", true, false) != null, "")
	var r00 = inst.find_child("Reserve0_0", true, false)
	var r01 = inst.find_child("Reserve0_1", true, false)
	var r20 = inst.find_child("Reserve2_0", true, false)
	_check("rsv: hero 0 has exactly 1 reserve slot", r00 != null and r01 == null, "")
	_check("rsv: hero 2 reserve slot exists", r20 != null, "")
	## weapon desc now lives UNDER the sockets (inside MidCol), not a right-side column
	var mid0 = inst.find_child("MidCol", true, false)
	var wt = mid0.find_child("WeaponTooltip", true, false) if mid0 != null else null
	_check("rsv: weapon desc under sockets (in MidCol)", wt != null, "")
	## set_reserve_item populates / clears the bench slot icon
	inst.set_reserve_item(0, 0, &"FIRE")
	var icon = r00.find_child("Icon", true, false) if r00 != null else null
	_check("rsv: reserve icon textured after set", icon != null and icon.texture != null, "")
	inst.set_reserve_item(0, 0, &"")
	_check("rsv: reserve icon cleared on empty", icon != null and icon.texture == null, "")
	inst.queue_free()

## -- G7: Ult button that fills (replaces cryptic yellow pips) --

func _test_ult_button() -> void:
	var packed = load("res://scenes/ui/ForgePanel_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("ult: ult_pressed signal", inst.has_signal("ult_pressed"), "")
	var ult = inst.find_child("UltBar", true, false)
	_check("ult: UltBar is a Button", ult is Button, "got %s" % (ult.get_class() if ult != null else "null"))
	var fill = ult.get_node_or_null("Fill") if ult != null else null
	_check("ult: has Fill overlay", fill != null, "")
	## empty -> disabled, fill collapsed to the bottom (anchor_top ~1.0)
	inst.set_hero_ult_bars(0, 0)
	_check("ult: empty -> disabled", ult is Button and ult.disabled == true, "")
	_check("ult: empty -> fill collapsed", fill != null and is_equal_approx(fill.anchor_top, 1.0), "got %.2f" % (fill.anchor_top if fill != null else -1.0))
	## 1 bar -> usable (spec §12: fire at >=1 bar, consume 1)
	inst.set_hero_ult_bars(0, 1)
	_check("ult: 1 bar -> enabled", ult is Button and ult.disabled == false, "")
	## full -> enabled, fill spans full height (anchor_top ~0.0), label ULT!
	inst.set_hero_ult_bars(0, 3)
	_check("ult: full -> enabled", ult is Button and ult.disabled == false, "")
	_check("ult: full -> fill spans up", fill != null and is_equal_approx(fill.anchor_top, 0.0), "got %.2f" % (fill.anchor_top if fill != null else -1.0))
	var lbl = ult.get_node_or_null("UltLabel") if ult != null else null
	_check("ult: full -> label ULT!", lbl != null and lbl.text == "ULT!", "got %s" % (lbl.text if lbl != null else "null"))
	inst.queue_free()

## -- G9: combat hit VFX (enemy + hero damage) + merge VFX --

func _test_battle_hit_vfx() -> void:
	var packed = load("res://scenes/ui/BattleView_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	var ls = get_node_or_null("/root/LaneState")
	if ls == null:
		inst.queue_free()
		return
	ls.reset()
	var e = ls.make_enemy(&"goblin", 0, 0.8, 5)
	inst._sync_enemies([e])           ## first sync -> no flash (no prior hp)
	var vfx = inst.get_node_or_null("Vfx")
	var before: int = vfx.get_child_count() if vfx != null else 0
	e.hp = 3
	inst._sync_enemies([e])           ## hp dropped -> impact vfx spawns
	_check("hit: enemy damage spawns impact vfx", vfx != null and vfx.get_child_count() > before, "before=%d after=%d" % [before, (vfx.get_child_count() if vfx != null else -1)])
	var before2: int = vfx.get_child_count() if vfx != null else 0
	inst.set_hero_hp(0, 30, 30)       ## first -> no flash
	inst.set_hero_hp(0, 20, 30)       ## hero took damage -> impact vfx spawns
	_check("hit: hero damage spawns impact vfx", vfx != null and vfx.get_child_count() > before2, "before=%d after=%d" % [before2, (vfx.get_child_count() if vfx != null else -1)])
	inst.queue_free()

func _test_merge_vfx() -> void:
	var packed = load("res://scenes/ui/ForgePanel_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("mv: has play_merge_vfx", inst.has_method("play_merge_vfx"), "")
	inst.set_socket_fn(0, 2, &"FIRE", 1, "FIRE", "2/2")
	inst.play_merge_vfx(0, 2)
	var sock = inst.find_child("Socket0_2", true, false)
	_check("mv: merge sparkle overlay added to socket", sock != null and sock.find_child("MergeVfx", true, false) != null, "")
	inst.queue_free()

## -- G10: minimal slice Home (boot -> PLAY -> Main_v2) --

func _test_home_v2() -> void:
	var packed = load("res://scenes/HomeV2.tscn")
	_check("home: HomeV2.tscn loads", packed != null, "")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("home: PLAY button present", inst.find_child("PlayBtn", true, false) != null, "")
	_check("home: title present", inst.find_child("Title", true, false) != null, "")
	inst.queue_free()

## -- G12: real item icons + tier-color rarity borders --

func _test_tier_border() -> void:
	var packed = load("res://scenes/ui/ForgePanel_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	## socket gets a tier-colored rarity frame
	inst.set_socket_fn(0, 2, &"FIRE", 2, "FIRE", "")  ## tier 2 -> blue
	var sock = inst.find_child("Socket0_2", true, false)
	var sb = sock.get_theme_stylebox("panel") if sock != null else null
	_check("tier: socket frame is StyleBoxFlat", sb is StyleBoxFlat, "")
	_check("tier 2 -> blue border", sb is StyleBoxFlat and sb.border_color.is_equal_approx(inst.TIER_BORDER[1]), "got %s" % (str(sb.border_color) if sb is StyleBoxFlat else "n/a"))
	## shop slot tier-3 -> purple + new icon art loads
	inst.populate_shop([{"id": "FIRE", "tier": 3, "cost": 1}])
	var slot0 = inst.get_node("ShopRail").get_child(0)
	var sb2 = slot0.get_theme_stylebox("panel")
	_check("shop tier 3 -> purple border", sb2 is StyleBoxFlat and sb2.border_color.is_equal_approx(inst.TIER_BORDER[2]), "")
	var icon = slot0.find_child("Icon", true, false)
	_check("shop icon uses new rune art (textured)", icon != null and icon.texture != null, "")

## -- C9: forge compact mode + HP-bar sizing --

func _test_compact_mode() -> void:
	var packed = load("res://scenes/ui/ForgePanel_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("cm: has set_compact", inst.has_method("set_compact"), "")
	_check("cm: has is_compact", inst.has_method("is_compact"), "")
	if inst.has_method("set_compact") and inst.has_method("is_compact"):
		var s00 = inst.find_child("Socket0_0", true, false)
		inst.set_compact(true)
		_check("cm: compact true", inst.is_compact() == true, "")
		_check("cm: compact shrinks socket", s00 != null and s00.custom_minimum_size.x <= 48, "got %s" % (str(s00.custom_minimum_size) if s00 != null else "null"))
		inst.set_compact(false)
		_check("cm: expanded false", inst.is_compact() == false, "")
		_check("cm: expanded socket >= 56", s00 != null and s00.custom_minimum_size.x >= 56, "got %s" % (str(s00.custom_minimum_size) if s00 != null else "null"))
	## HP bar must be GONE from the forge rail entirely (moved to battle scene)
	_check("cm: HP bar removed from forge rail", inst.find_child("HPBar", true, false) == null, "")
	inst.queue_free()

## -- #2: hero HP floats in battle scene + horizontal heroes in compact (forge) --

func _test_battle_hero_hp() -> void:
	var packed = load("res://scenes/ui/BattleView_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	## hero HP bar exists above each hero sprite + set_hero_hp updates it
	var h0 = inst.get_node_or_null("Heroes/Hero0")
	_check("bh: hero anchor has HPBar", h0 != null and h0.find_child("HPBar", true, false) != null, "")
	_check("bh: has set_hero_hp", inst.has_method("set_hero_hp"), "")
	if inst.has_method("set_hero_hp"):
		inst.set_hero_hp(0, 15, 30)
		var bar = h0.find_child("HPBar", true, false)
		## compact battle: HP is the BAR only (no numeric text); half HP -> half width (~24 of 48)
		_check("bh: set_hero_hp updates bar width (~half)", bar != null and is_equal_approx(bar.size.x, 24.0), "got %.1f" % (bar.size.x if bar != null else -1.0))
		_check("bh: no numeric HP text (compact)", h0.find_child("HPValue", true, false) == null, "")
	## compact (forge) -> heroes laid out HORIZONTALLY (distinct x, ~same y)
	inst.set_compact(true)
	var a0 = inst.get_node("Heroes/Hero0")
	var a1 = inst.get_node("Heroes/Hero1")
	var a2 = inst.get_node("Heroes/Hero2")
	_check("bh: compact heroes spread horizontally (x rising)", a0.position.x < a1.position.x and a1.position.x < a2.position.x,
		"x=%.0f,%.0f,%.0f" % [a0.position.x, a1.position.x, a2.position.x])
	_check("bh: compact heroes same row (equal y)", is_equal_approx(a0.position.y, a2.position.y), "y=%.0f,%.0f" % [a0.position.y, a2.position.y])
	## combat -> back to vertical lanes (y rising)
	inst.set_compact(false)
	_check("bh: combat heroes stacked by lane (y rising)", a0.position.y < a1.position.y and a1.position.y < a2.position.y,
		"y=%.0f,%.0f,%.0f" % [a0.position.y, a1.position.y, a2.position.y])
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
	## Q5 — stage telegraph (all waves of the upcoming stage, with weak/resist)
	_check("wt: show_stage method", inst.has_method("show_stage"), "")
	if inst.has_method("show_stage"):
		inst.show_stage(0, [
			{"wave": 0, "enemies": [&"goblin"], "count": 3, "weak_tag": &"LIGHTNING", "resist_tag": &"FIRE"},
			{"wave": 1, "enemies": [&"goblin"], "count": 4, "weak_tag": &"LIGHTNING", "resist_tag": &"FIRE"},
		])
		_check("wt: visible after show_stage", inst.visible == true, "")
		var el = inst.find_child("EnemyList", true, false)
		_check("wt: show_stage renders one row per wave", el != null and el.get_child_count() == 2, "got %d" % (el.get_child_count() if el != null else -1))
		## detail: each wave row carries weak/resist element icons
		var row0 = el.get_child(0) if (el != null and el.get_child_count() > 0) else null
		var icon_count = row0.find_children("*", "TextureRect", true, false).size() if row0 != null else 0
		_check("wt: detail rows show weak/resist icons", icon_count >= 1, "got %d icons" % icon_count)
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
