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
	_test_equip_displaces_to_reserve()
	_test_reserve_full_blocks_equip()
	_test_sell_socket_refunds()
	_test_bench_reequip_swaps()
	_test_move_socket_to_socket()
	_test_move_cross_hero_no_gold()
	_test_move_merge_same_element()
	_test_reroll_costs_gold()
	_test_equip_forge_gated()
	_test_per_kill_gold()
	_test_layout_combat()
	_test_layout_forge()
	_test_pause_no_reanchor()
	_test_reroll_button_path()
	_test_overlays_dont_block_input()
	_test_advance_unpauses()
	_test_loss_on_all_dead()
	_test_win_result()
	_test_telegraph_wiring()
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

## Q5 — wave telegraph wired into the forge HUD.
func _test_telegraph_wiring() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	var btn = inst.find_child("TelegraphBtn", true, false)
	_check("main_v2: HUD has TelegraphBtn (intel)", btn != null, "")
	## persistent intel strip: weak/resist element icons for the upcoming stage, always visible
	var icons = inst.find_child("IntelIcons", true, false)
	_check("main_v2: HUD intel strip shows icons on open", icons != null and icons.get_child_count() > 0, "children=%d" % (icons.get_child_count() if icons != null else -1))
	_check("main_v2: has _on_telegraph", inst.has_method("_on_telegraph"), "")
	if inst.has_method("_on_telegraph"):
		inst._on_telegraph()  ## opens in forge -> preview the upcoming stage
		var wt = inst.find_child("WaveTelegraphOverlay", true, false)
		_check("main_v2: telegraph overlay present", wt != null, "")
		_check("main_v2: telegraph visible after intel tap in forge", wt != null and wt.visible == true, "")
	inst.queue_free()

func _test_starts_in_forge() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("open: FORGE not COMBAT", inst.is_forge_break() and not inst.is_combat(), "state=%d" % inst.state)
	_check("open: parked before wave 1 (stage 0, wave 0)", inst.current_stage == 0 and inst.current_wave == 0, "stage=%d wave=%d" % [inst.current_stage, inst.current_wave])
	_check("open: shop FULL (7) at world start", _shop_count(inst) == 7, "got %d" % _shop_count(inst))
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
	_buff_heroes(inst)  ## survive the full run so we exercise the WIN path (not permadeath)
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
	inst._on_socket_tap(0, 2)  ## drop FIRE again same socket -> merge
	var s = inst.get_socket(0, 2)
	_check("merge: tier bumps 1 -> 2", s != null and s.tier == 2, "got %s" % str(s))
	inst.queue_free()

func _test_equip_displaces_to_reserve() -> void:
	var inst = _fresh_forge()
	if inst == null:
		return
	inst.gold = 99
	inst._shop_items[0] = {"id": "FIRE", "tier": 1, "cost": 1}
	inst._on_shop_tap(0)
	inst._on_socket_tap(0, 2)  ## equip FIRE -> ACTIVE
	inst._shop_items[1] = {"id": "WATER", "tier": 1, "cost": 1}
	inst._on_shop_tap(1)
	inst._on_socket_tap(0, 2)  ## equip WATER -> ACTIVE (displaces FIRE)
	var s = inst.get_socket(0, 2)
	_check("displace: socket now WATER", s != null and s.id == &"WATER", "got %s" % str(s))
	var r0 = inst.get_reserve(0, 0)
	_check("displace: old FIRE pushed to reserve", r0 != null and r0.id == &"FIRE", "got %s" % str(r0))
	inst.queue_free()

func _test_reserve_full_blocks_equip() -> void:
	var inst = _fresh_forge()
	if inst == null:
		return
	inst.gold = 99
	var ids = ["FIRE", "WATER", "AOE"]
	for i in 3:
		inst._shop_items[i] = {"id": ids[i], "tier": 1, "cost": 1}
	inst._on_shop_tap(0); inst._on_socket_tap(0, 2)  ## FIRE -> socket
	inst._on_shop_tap(1); inst._on_socket_tap(0, 2)  ## WATER -> socket (FIRE -> reserve 0; bench now full at 1 slot)
	var gold_before: int = inst.gold
	inst._on_shop_tap(2); inst._on_socket_tap(0, 2)  ## AOE: WATER would displace but bench full -> blocked
	var s = inst.get_socket(0, 2)
	_check("full: socket unchanged (still WATER)", s != null and s.id == &"WATER", "got %s" % str(s))
	_check("full: blocked equip does NOT charge gold", inst.gold == gold_before, "before=%d now=%d" % [gold_before, inst.gold])
	_check("full: blocked shop item stays in shop", inst._shop_items[2] != null, "got %s" % str(inst._shop_items[2]))
	inst.queue_free()

func _test_sell_socket_refunds() -> void:
	var inst = _fresh_forge()
	if inst == null:
		return
	inst.gold = 99
	inst._shop_items[0] = {"id": "FIRE", "tier": 1, "cost": 2}
	inst._on_shop_tap(0); inst._on_socket_tap(0, 2)  ## equip FIRE (cost 2)
	var g: int = inst.gold
	inst._on_socket_sell(0, 2)  ## sell -> floor(2*0.5) = 1
	_check("sell: gold refunded (reduced)", inst.gold == g + 1, "g=%d now=%d" % [g, inst.gold])
	_check("sell: socket emptied", inst.get_socket(0, 2) == null, "got %s" % str(inst.get_socket(0, 2)))
	inst.queue_free()

func _test_bench_reequip_swaps() -> void:
	var inst = _fresh_forge()
	if inst == null:
		return
	inst.gold = 99
	inst._shop_items[0] = {"id": "FIRE", "tier": 1, "cost": 1}
	inst._on_shop_tap(0); inst._on_socket_tap(0, 2)  ## FIRE active
	inst._shop_items[1] = {"id": "WATER", "tier": 1, "cost": 1}
	inst._on_shop_tap(1); inst._on_socket_tap(0, 2)  ## WATER active, FIRE -> reserve 0
	inst._on_reserve_tap(0, 0)   ## pick up benched FIRE
	inst._on_socket_tap(0, 2)    ## re-equip FIRE -> active (WATER swaps back to reserve)
	var s = inst.get_socket(0, 2)
	_check("bench: socket FIRE again", s != null and s.id == &"FIRE", "got %s" % str(s))
	var r0 = inst.get_reserve(0, 0)
	_check("bench: WATER swapped into reserve", r0 != null and r0.id == &"WATER", "got %s" % str(r0))
	inst.queue_free()

func _test_move_socket_to_socket() -> void:
	var inst = _fresh_forge()
	if inst == null:
		return
	inst._loadouts[0][0] = {"id": &"FIRE", "tier": 1, "cost": 1}
	inst._loadouts[0][2] = {"id": &"WATER", "tier": 1, "cost": 1}
	inst._on_socket_tap(0, 0)  ## pick up PASSIVE (FIRE)
	inst._on_socket_tap(0, 2)  ## drop on ACTIVE (WATER) -> swap
	_check("move: socket0 now WATER (swapped)", inst.get_socket(0, 0) != null and inst.get_socket(0, 0).id == &"WATER", "got %s" % str(inst.get_socket(0, 0)))
	_check("move: socket2 now FIRE (swapped)", inst.get_socket(0, 2) != null and inst.get_socket(0, 2).id == &"FIRE", "got %s" % str(inst.get_socket(0, 2)))
	inst.queue_free()

func _test_move_cross_hero_no_gold() -> void:
	var inst = _fresh_forge()
	if inst == null:
		return
	inst.gold = 42
	inst._loadouts[0][2] = {"id": &"LIGHTNING", "tier": 1, "cost": 1}
	inst._on_socket_tap(0, 2)  ## pick up hero 0 ACTIVE
	inst._on_socket_tap(1, 2)  ## drop on hero 1 ACTIVE (empty) -> move across heroes
	_check("xhero move: hero1 ACTIVE = LIGHTNING", inst.get_socket(1, 2) != null and inst.get_socket(1, 2).id == &"LIGHTNING", "got %s" % str(inst.get_socket(1, 2)))
	_check("xhero move: hero0 ACTIVE empty", inst.get_socket(0, 2) == null, "got %s" % str(inst.get_socket(0, 2)))
	_check("xhero move: moving owned items is FREE (gold unchanged)", inst.gold == 42, "got %d" % inst.gold)
	inst.queue_free()

func _test_move_merge_same_element() -> void:
	var inst = _fresh_forge()
	if inst == null:
		return
	inst._reserves[0][0] = {"id": &"FIRE", "tier": 1, "cost": 1}
	inst._loadouts[0][2] = {"id": &"FIRE", "tier": 1, "cost": 1}
	inst._on_reserve_tap(0, 0)  ## pick up benched FIRE
	inst._on_socket_tap(0, 2)   ## drop on ACTIVE (FIRE) -> merge
	var s = inst.get_socket(0, 2)
	_check("move-merge: socket tier bumps to 2", s != null and int(s.tier) == 2, "got %s" % str(s))
	_check("move-merge: reserve source consumed", inst.get_reserve(0, 0) == null, "got %s" % str(inst.get_reserve(0, 0)))
	inst.queue_free()

func _test_reroll_costs_gold() -> void:
	var inst = _fresh_forge()
	if inst == null:
		return
	inst.gold = 7
	inst._shop_items[2] = null  ## simulate an already-bought (empty) slot
	inst._on_reroll()  ## stage 0 -> reroll the WHOLE list, costs 2g
	_check("reroll: costs full-board price (stage0 = 2g)", inst.gold == 5, "got %d" % inst.gold)
	_check("reroll: re-rolls the WHOLE list to 7 (refills bought/empty)", _shop_count(inst) == 7, "got %d" % _shop_count(inst))
	_check("reroll: previously-empty slot refilled", inst._shop_items[2] != null, "got %s" % str(inst._shop_items[2]))
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
	_check("layout combat: battle squeezed (bottom ~0.54)", is_equal_approx(inst._battle.anchor_bottom, 0.54), "got %.2f" % inst._battle.anchor_bottom)
	_check("layout combat: forge gets the rest (top ~0.54)", is_equal_approx(inst._forge.anchor_top, 0.54), "got %.2f" % inst._forge.anchor_top)
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

func _buff_heroes(inst) -> void:
	for h in inst._heroes:
		h["hp"] = 9999
		h["max_hp"] = 9999

func _test_loss_on_all_dead() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	inst.advance_wave()  ## START -> combat
	for h in inst._heroes:
		h["hp"] = 0
	inst._tick_once()
	_check("loss: run is done", inst.is_done(), "state=%d" % inst.state)
	_check("loss: did_win() == false", inst.did_win() == false, "")
	var t = inst.find_child("ResultTitle", true, false)
	_check("loss: DEFEAT result overlay", t != null and t.text == "DEFEAT", "got %s" % (t.text if t != null else "null"))
	inst.queue_free()

func _test_win_result() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_buff_heroes(inst)
	var guard: int = 0
	while not inst.is_done() and guard < 6000:
		if inst.is_combat(): inst._tick_once()
		elif inst.is_forge_break(): inst.advance_wave()
		guard += 1
	_check("win: run is done", inst.is_done(), "guard=%d" % guard)
	_check("win: did_win() == true", inst.did_win() == true, "")
	var t = inst.find_child("ResultTitle", true, false)
	_check("win: VICTORY result overlay", t != null and t.text == "VICTORY!", "got %s" % (t.text if t != null else "null"))
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
	_check("slow-populate: F0 shop FULL (7) at world start", _shop_count(inst) == 7, "got %d" % _shop_count(inst))
	inst.advance_wave()  ## START stage 0 -> shop resets to the slow-populate drip start
	_check("slow-populate: START resets to drip start (<=4)", _shop_count(inst) <= 4, "got %d" % _shop_count(inst))
	_check("slow-populate: a fresh drip began (>=2)", _shop_count(inst) >= 2, "got %d" % _shop_count(inst))
	var guard: int = 0
	while inst.is_combat() and guard < 1500:
		inst._tick_once(); guard += 1
	_check("slow-populate: shop full (7) by stage-end break", _shop_count(inst) == 7, "got %d" % _shop_count(inst))
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
