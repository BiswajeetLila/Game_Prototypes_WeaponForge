## Integration tests for Main_v2 — the composed slice + game-loop controller (A4/A5).
## Drives the full post-FTUE run (5 stages x 3 waves = 15) through the controller,
## headless + deterministic (no Timer). Proves composition + state machine + loop.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== Main_v2 controller tests ===")
	_test_composition()
	_test_full_run_loop()
	_test_buy_deducts_and_clears()
	_test_insufficient_gold_blocks()
	_test_merge_stub()
	_test_reroll_costs_gold()
	_test_equip_forge_gated()
	_test_per_kill_gold()
	_test_layout_combat()
	_test_layout_forge()
	_test_pause_no_reanchor()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_composition() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	_check("main_v2: scene loads", packed != null, "Main_v2.tscn missing")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("main_v2: HudBar exists", inst.get_node_or_null("HudBar") != null, "")
	_check("main_v2: battlefield composed (Field present)", inst.find_child("Field", true, false) != null, "")
	_check("main_v2: forge composed (ShopRail present)", inst.find_child("ShopRail", true, false) != null, "")
	var start_btn = inst.find_child("StartNextWaveBtn", true, false)
	_check("main_v2: StartNextWaveBtn in forge footer", start_btn != null, "")
	_check("main_v2: starts in COMBAT", inst.has_method("is_combat") and inst.is_combat(), "")
	_check("main_v2: START hidden during combat", start_btn != null and start_btn.visible == false, "")
	var ls = get_node_or_null("/root/LaneState")
	_check("main_v2: first wave spawned enemies", ls != null and ls.enemies.size() > 0, "got %d" % (ls.enemies.size() if ls != null else -1))
	inst.queue_free()

func _test_full_run_loop() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		_check("main_v2: full-run prerequisites", false, "scene missing")
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("main_v2: run begins in COMBAT", inst.is_combat(), "")
	var guard: int = 0
	while not inst.is_done() and guard < 6000:
		if inst.is_combat():
			inst._tick_once()
		elif inst.is_forge_break():
			inst.advance_wave()
		guard += 1
	_check("main_v2: run reaches DONE", inst.is_done(), "guard=%d state=%d" % [guard, inst.state])
	_check("main_v2: played 15 waves (5 stages x 3)", inst.waves_played == 15, "got %d" % inst.waves_played)
	_check("main_v2: did not hit guard ceiling", guard < 6000, "guard=%d" % guard)
	inst.queue_free()

func _fresh_forge():
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return null
	var inst = packed.instantiate()
	add_child(inst)
	inst.demo_forge_break()  ## FORGE state + shop populated via ShopV2.roll_items
	return inst

func _test_buy_deducts_and_clears() -> void:
	var inst = _fresh_forge()
	if inst == null:
		return
	inst.gold = 7
	var item = inst._shop_items[0]
	var cost: int = int(item.cost)
	inst._on_shop_tap(0)
	inst._on_socket_tap(0, 0)
	_check("buy: gold deducted by cost", inst.gold == 7 - cost, "gold=%d cost=%d" % [inst.gold, cost])
	_check("buy: shop slot cleared", inst._shop_items[0] == null, "got %s" % str(inst._shop_items[0]))
	var s = inst.get_socket(0, 0)
	_check("buy: function equipped in socket", s != null and s.id == StringName(item.id), "got %s" % str(s))
	inst.queue_free()

func _test_insufficient_gold_blocks() -> void:
	var inst = _fresh_forge()
	if inst == null:
		return
	inst.gold = 0
	var item = inst._shop_items[1]
	inst._on_shop_tap(1)
	inst._on_socket_tap(0, 0)
	_check("no gold: gold unchanged", inst.gold == 0, "got %d" % inst.gold)
	_check("no gold: slot still populated", inst._shop_items[1] != null and inst._shop_items[1].id == item.id, "")
	_check("no gold: nothing equipped", inst.get_socket(0, 0) == null, "got %s" % str(inst.get_socket(0, 0)))
	inst.queue_free()

func _test_merge_stub() -> void:
	var inst = _fresh_forge()
	if inst == null:
		return
	inst.gold = 99
	inst._shop_items[0] = {"id": "FIRE", "tier": 1, "cost": 1}
	inst._on_shop_tap(0)
	inst._on_socket_tap(0, 2)  ## ACTIVE slot
	inst._shop_items[0] = {"id": "FIRE", "tier": 1, "cost": 1}  ## restock same
	inst._on_shop_tap(0)
	inst._on_socket_tap(0, 2)  ## drop FIRE again same socket
	var s = inst.get_socket(0, 2)
	_check("merge stub: tier stays 1 (no T2 in slice)", s != null and s.tier == 1, "got %s" % str(s))
	_check("merge stub: shows 2/2", s != null and String(s.get("merge", "")) == "2/2", "got %s" % str(s))
	inst.queue_free()

func _test_reroll_costs_gold() -> void:
	var inst = _fresh_forge()
	if inst == null:
		return
	inst.gold = 7
	inst._on_reroll()
	_check("reroll: costs 1g", inst.gold == 6, "got %d" % inst.gold)
	inst.queue_free()

func _test_equip_forge_gated() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)  ## start_run -> COMBAT, NOT forge
	inst.gold = 7
	inst._shop_items = [{"id": "FIRE", "tier": 1, "cost": 1}]
	inst._on_shop_tap(0)
	inst._on_socket_tap(0, 0)
	_check("combat: equip blocked (gold unchanged)", inst.gold == 7, "got %d" % inst.gold)
	_check("combat: nothing equipped", inst.get_socket(0, 0) == null, "got %s" % str(inst.get_socket(0, 0)))
	inst.queue_free()

func _test_per_kill_gold() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)  ## COMBAT, wave 0 spawned
	var ls = get_node_or_null("/root/LaneState")
	var n: int = ls.enemies.size() if ls != null else 0
	var start_gold: int = inst.gold
	var guard: int = 0
	while inst.is_combat() and guard < 500:
		inst._tick_once()
		guard += 1
	_check("per-kill: cleared to forge", inst.is_forge_break(), "guard=%d" % guard)
	_check("per-kill: gold += enemies killed", inst.gold == start_gold + n, "start=%d n=%d gold=%d" % [start_gold, n, inst.gold])
	inst.queue_free()

func _test_layout_combat() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)  ## start_run -> COMBAT
	_check("layout combat: battle big (bottom ~0.66)", is_equal_approx(inst._battle.anchor_bottom, 0.66), "got %.2f" % inst._battle.anchor_bottom)
	_check("layout combat: forge compact (top ~0.66)", is_equal_approx(inst._forge.anchor_top, 0.66), "got %.2f" % inst._forge.anchor_top)
	_check("layout combat: ChainHUD visible", inst._chain_hud.visible == true, "")
	_check("layout combat: forge is_compact", inst._forge.has_method("is_compact") and inst._forge.is_compact() == true, "")
	_check("layout combat: battle not compact", inst._battle.has_method("is_compact") and inst._battle.is_compact() == false, "")
	inst.queue_free()

func _test_layout_forge() -> void:
	var inst = _fresh_forge()
	if inst == null:
		return
	_check("layout forge: battle small preview (bottom ~0.32)", is_equal_approx(inst._battle.anchor_bottom, 0.32), "got %.2f" % inst._battle.anchor_bottom)
	_check("layout forge: forge expanded (top ~0.32)", is_equal_approx(inst._forge.anchor_top, 0.32), "got %.2f" % inst._forge.anchor_top)
	_check("layout forge: ChainHUD hidden", inst._chain_hud.visible == false, "")
	_check("layout forge: forge not compact", inst._forge.is_compact() == false, "")
	_check("layout forge: battle compact", inst._battle.is_compact() == true, "")
	inst.queue_free()

func _test_pause_no_reanchor() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)  ## COMBAT
	var ab: float = inst._battle.anchor_bottom
	_check("main_v2: has is_paused", inst.has_method("is_paused"), "")
	inst._on_pause()
	_check("pause: state stays COMBAT (no swap to FORGE)", inst.is_combat() == true, "")
	_check("pause: battle anchors unchanged", is_equal_approx(inst._battle.anchor_bottom, ab), "")
	_check("pause: is_paused true", inst.has_method("is_paused") and inst.is_paused() == true, "")
	inst._on_pause()
	_check("pause: toggles back off", inst.is_paused() == false, "")
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
	add_child(label)
