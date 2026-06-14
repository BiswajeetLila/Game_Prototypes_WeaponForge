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
	_test_starts_in_forge()
	_test_auto_battle_within_stage()
	_test_slow_populate_and_reset()
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
	_test_reroll_button_path()
	_test_overlays_dont_block_input()
	_test_advance_unpauses()
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
	_check("main_v2: opens in FORGE (equip before wave 1)", inst.has_method("is_forge_break") and inst.is_forge_break(), "")
	_check("main_v2: START visible at run open", start_btn != null and start_btn.visible == true, "")
	var ls = get_node_or_null("/root/LaneState")
	_check("main_v2: no live enemies during forge", ls != null and ls.enemies.size() == 0, "got %d" % (ls.enemies.size() if ls != null else -1))
	inst.advance_wave()  ## press START
	_check("main_v2: START spawns the wave's enemies", ls != null and ls.enemies.size() > 0, "got %d" % (ls.enemies.size() if ls != null else -1))
	inst.queue_free()

func _test_starts_in_forge() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("open: FORGE not COMBAT", inst.is_forge_break() and not inst.is_combat(), "state=%d" % inst.state)
	_check("open: parked before wave 1 (stage 0, wave 0)", inst.current_stage == 0 and inst.current_wave == 0, "stage=%d wave=%d" % [inst.current_stage, inst.current_wave])
	_check("open: shop slow-populate start batch = 2 items", _shop_count(inst) == 2, "got %d" % _shop_count(inst))
	var start_btn = inst.find_child("StartNextWaveBtn", true, false)
	_check("open: START button visible", start_btn != null and start_btn.visible == true, "")
	inst.advance_wave()  ## press START
	_check("after START: COMBAT", inst.is_combat(), "state=%d" % inst.state)
	_check("after START: still wave 1 (no skip)", inst.current_wave == 0, "wave=%d" % inst.current_wave)
	_check("after START: START hidden", start_btn != null and start_btn.visible == false, "")
	inst.queue_free()

func _test_full_run_loop() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		_check("main_v2: full-run prerequisites", false, "scene missing")
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("main_v2: run begins in FORGE (equip first)", inst.is_forge_break(), "")
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
	inst._shop_items[2] = null  ## simulate an already-bought (empty) slot
	var before: int = _shop_count(inst)
	inst._on_reroll()  ## stage 0 -> reroll costs 2g
	_check("reroll: costs full-board price (stage0 = 2g)", inst.gold == 5, "got %d" % inst.gold)
	_check("reroll: re-rolls populated slots, count unchanged", _shop_count(inst) == before, "before=%d after=%d" % [before, _shop_count(inst)])
	_check("reroll: bought slot stays empty (no refill under slow-populate)", inst._shop_items[2] == null, "got %s" % str(inst._shop_items[2]))
	inst.queue_free()

func _test_equip_forge_gated() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)  ## opens in FORGE
	inst.advance_wave()  ## press START -> COMBAT (equip must now be blocked)
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
	add_child(inst)  ## F0 forge
	var wd = get_node_or_null("/root/WaveDirector")
	var total: int = 0
	if wd != null:
		for w in wd.waves_for_stage(0):
			total += wd.enemies_for_stage_wave(0, w).size()
	var start_gold: int = inst.gold
	inst.advance_wave()  ## START stage 0 (auto-battles all 3 waves)
	var guard: int = 0
	while inst.is_combat() and guard < 1500:
		inst._tick_once()
		guard += 1
	_check("per-kill: stage cleared to forge", inst.is_forge_break(), "guard=%d state=%d" % [guard, inst.state])
	_check("per-kill: gold += all enemies killed across the stage", inst.gold == start_gold + total, "start=%d total=%d gold=%d" % [start_gold, total, inst.gold])
	inst.queue_free()

func _test_layout_combat() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)  ## opens FORGE
	inst.advance_wave()  ## press START -> COMBAT layout
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
	add_child(inst)  ## opens FORGE
	inst.advance_wave()  ## press START -> COMBAT (pause must not re-anchor mid-combat)
	var ab: float = inst._battle.anchor_bottom
	_check("main_v2: has is_paused", inst.has_method("is_paused"), "")
	inst._on_pause()
	_check("pause: state stays COMBAT (no swap to FORGE)", inst.is_combat() == true, "")
	_check("pause: battle anchors unchanged", is_equal_approx(inst._battle.anchor_bottom, ab), "")
	_check("pause: is_paused true", inst.has_method("is_paused") and inst.is_paused() == true, "")
	inst._on_pause()
	_check("pause: toggles back off", inst.is_paused() == false, "")
	inst.queue_free()

func _shop_count(inst) -> int:
	var n: int = 0
	for it in inst._shop_items:
		if it != null:
			n += 1
	return n

func _test_auto_battle_within_stage() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)            ## F0 forge
	inst.advance_wave()        ## START stage 0
	_check("auto-battle: stage starts at wave 1, COMBAT", inst.current_wave == 0 and inst.is_combat(), "wave=%d state=%d" % [inst.current_wave, inst.state])
	var guard: int = 0
	while inst.is_combat() and inst.current_wave == 0 and guard < 500:
		inst._tick_once(); guard += 1
	_check("auto-battle: wave 1 cleared -> wave 2, still COMBAT (no forge)", inst.is_combat() and inst.current_wave == 1, "wave=%d state=%d" % [inst.current_wave, inst.state])
	guard = 0
	while inst.is_combat() and inst.current_wave == 1 and guard < 500:
		inst._tick_once(); guard += 1
	_check("auto-battle: wave 2 cleared -> wave 3, still COMBAT", inst.is_combat() and inst.current_wave == 2, "wave=%d state=%d" % [inst.current_wave, inst.state])
	guard = 0
	while inst.is_combat() and guard < 500:
		inst._tick_once(); guard += 1
	_check("auto-battle: last wave cleared -> FORGE break", inst.is_forge_break(), "state=%d" % inst.state)
	_check("auto-battle: forge break at stage boundary (stage 1)", inst.current_stage == 1, "stage=%d" % inst.current_stage)
	_check("auto-battle: shop full (7) at stage-end break", _shop_count(inst) == 7, "got %d" % _shop_count(inst))
	inst.queue_free()

func _test_slow_populate_and_reset() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)  ## F0 forge
	_check("slow-populate: F0 shop = 2 (start batch)", _shop_count(inst) == 2, "got %d" % _shop_count(inst))
	_check("slow-populate: 1 stage reset at boot", inst._shop_populate_count == 1, "got %d" % inst._shop_populate_count)
	inst.advance_wave()  ## START stage 0 -> drips wave 0
	_check("slow-populate: shop grows during stage (>2)", _shop_count(inst) > 2, "got %d" % _shop_count(inst))
	var guard: int = 0
	while inst.is_combat() and guard < 1500:
		inst._tick_once(); guard += 1
	_check("slow-populate: shop full (7) by stage-end break", _shop_count(inst) == 7, "got %d" % _shop_count(inst))
	_check("slow-populate: no extra reset within stage 0", inst._shop_populate_count == 1, "got %d" % inst._shop_populate_count)
	inst.advance_wave()  ## START stage 1 -> RESET + start batch + wave-0 drip
	_check("slow-populate: shop resets at new stage (<=3)", _shop_count(inst) <= 3, "got %d" % _shop_count(inst))
	_check("slow-populate: reset count increments to 2", inst._shop_populate_count == 2, "got %d" % inst._shop_populate_count)
	inst.queue_free()

func _test_reroll_button_path() -> void:
	var inst = _fresh_forge()
	if inst == null:
		return
	inst.gold = 5
	var rb = inst._forge.find_child("RerollBtn", true, false)
	_check("RerollBtn present", rb != null, "")
	if rb != null:
		rb.pressed.emit()  ## full chain: button -> reroll_tapped -> _on_reroll
		_check("reroll via real button press decrements gold (stage0 = 2g)", inst.gold == 3, "got %d" % inst.gold)
	inst.queue_free()

func _test_overlays_dont_block_input() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	## ChainHUD (top-strip overlay, added topmost) + BattleView must NOT eat button clicks
	_check("overlay: ChainHUD mouse-transparent", inst._chain_hud.mouse_filter == Control.MOUSE_FILTER_IGNORE, "got %d" % inst._chain_hud.mouse_filter)
	_check("overlay: BattleView mouse-transparent", inst._battle.mouse_filter == Control.MOUSE_FILTER_IGNORE, "got %d" % inst._battle.mouse_filter)
	inst.queue_free()

func _test_advance_unpauses() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)        ## opens FORGE
	inst.advance_wave()    ## START -> COMBAT wave 0
	## pause mid-combat, then START NEXT WAVE must resume (each new wave starts unpaused)
	inst._on_pause()
	_check("paused after pause", inst.is_paused() == true, "")
	## clear the wave -> forge break (pause persists), then START next wave
	var guard: int = 0
	while inst.is_combat() and guard < 500:
		inst._tick_once()
		guard += 1
	inst.advance_wave()
	_check("advance_wave clears pause (no permanent freeze)", inst.is_paused() == false, "")
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
