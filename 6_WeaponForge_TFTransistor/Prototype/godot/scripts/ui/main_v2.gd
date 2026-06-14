## Main_v2 — the composed vertical-slice screen + game-loop controller.
##
## Composition (top -> bottom, matches In_Battle.png / Forge_State.jpeg):
##   HudBar        0.00-0.06   Wave / Stage / pause + speed
##   BattleView_v2 0.06-0.58   battlefield (3x3 render-snap)
##   ForgePanel_v2 0.58-1.00   weapon rail (top) + shop rail (bottom)
##   ChainHUD      overlay     reaction chain badge
##   NextWaveBtn   overlay     shown only in FORGE_BREAK
##
## State machine: COMBAT (tick driver runs, enemies advance) <-> FORGE_BREAK
## (paused, shop populated, START NEXT WAVE shown) -> DONE (run complete).
##
## Slice runs post-FTUE (3 heroes, 3 lanes, 3-wave stages) to match the mockup,
## which shows the full 3-hero state. FTUE onboarding flow = Phase 5.
##
## Headless: the Timer is NOT added (tests drive _tick_once()/advance_wave()
## deterministically). Windowed: Timer drives the loop for play / AUTOSHOT.
extends Control

const BattleViewScene: PackedScene = preload("res://scenes/ui/BattleView_v2.tscn")
const ForgePanelScene: PackedScene = preload("res://scenes/ui/ForgePanel_v2.tscn")
const ChainHUDScene: PackedScene = preload("res://scenes/ui/ChainHUD.tscn")
const Loadout = preload("res://scripts/core/loadout_v2.gd")
const Reserve = preload("res://scripts/core/reserve_v2.gd")
const ForgeGrid = preload("res://scripts/core/forge_grid.gd")

const STATE_COMBAT: int = 0
const STATE_FORGE: int = 1
const STATE_DONE: int = 2

const TICK_INTERVAL: float = 0.3
const SAFETY_TICKS: int = 400
const STAGES: int = 5
const SEED_STATUSES: Array = [&"Wet", &"Burning", &"Chilled"]
const SHOP_SAMPLE: Array = ["FIRE", "WATER", "LIGHTNING", "AOE", "LEECH", "BURST", "BOUNCE"]

var state: int = STATE_FORGE
var current_stage: int = 0
var current_wave: int = 0
var waves_played: int = 0
var gold: int = 7
var _ticks_this_wave: int = 0
var _chain: int = 0
var _loadouts: Array = []      ## 3 heroes, each a loadout_v2 Array[3]
var _reserves: Array = []      ## 3 heroes, each a reserve_v2 Array[2] (bench)
## the item currently "picked up" (one tap), to drop on the next tile tap.
## null, or { kind:"shop"|"socket"|"reserve", hero:int, idx:int }. shop hero=-1.
var _held = null
var _shop_items: Array = []    ## 7 slots, each {id,tier,cost} or null (bought/empty)
var _stage_elements_seen: Array = []  ## element ids that appeared in shop this stage (pity)
var _shop_populate_count: int = 0     ## test probe: number of per-stage shop resets
var _shop_stage: int = 0              ## which stage the current _shop_items belong to (reset boundary)

var _battle: Control
var _forge: Control
var _chain_hud: Control
var _hud: Control
var _heroes: Array = []
var _paused: bool = false   ## pause gates the tick; does NOT change state/layout

func _ready() -> void:
	_build_layout()
	var em := get_node_or_null("/root/ElementMediator")
	if em != null and em.has_signal("reaction_triggered"):
		em.reaction_triggered.connect(_on_reaction)
	start_run()
	if DisplayServer.get_name() != "headless":
		var t := Timer.new()
		t.name = "TickTimer"
		t.wait_time = TICK_INTERVAL
		t.autostart = true
		t.timeout.connect(_on_timer)
		add_child(t)

## ---- layout ----

func _build_layout() -> void:
	_hud = _build_hud()
	add_child(_hud)

	_battle = BattleViewScene.instantiate()
	_battle.mouse_filter = Control.MOUSE_FILTER_IGNORE  ## display only — never eat button clicks
	_region(_battle, 0.06, 0.58)
	add_child(_battle)

	_forge = ForgePanelScene.instantiate()
	_region(_forge, 0.58, 1.0)
	add_child(_forge)
	if _forge.has_signal("reroll_tapped"):
		_forge.reroll_tapped.connect(_on_reroll)
	if _forge.has_signal("shop_item_tapped"):
		_forge.shop_item_tapped.connect(_on_shop_tap)
	if _forge.has_signal("socket_tapped"):
		_forge.socket_tapped.connect(_on_socket_tap)
	if _forge.has_signal("reserve_tapped"):
		_forge.reserve_tapped.connect(_on_reserve_tap)
	if _forge.has_signal("socket_sell"):
		_forge.socket_sell.connect(_on_socket_sell)
	if _forge.has_signal("reserve_sell"):
		_forge.reserve_sell.connect(_on_reserve_sell)
	if _forge.has_signal("ult_pressed"):
		_forge.ult_pressed.connect(_on_ult)
	if _forge.has_signal("start_next_wave"):
		_forge.start_next_wave.connect(advance_wave)

	_chain_hud = ChainHUDScene.instantiate()
	_chain_hud.mouse_filter = Control.MOUSE_FILTER_IGNORE  ## top-strip overlay must not block HUD buttons
	add_child(_chain_hud)

func _set_next_wave(v: bool) -> void:
	if _forge != null and _forge.has_method("set_next_wave_visible"):
		_forge.set_next_wave_visible(v)

## ---- phase-adaptive layout (combat = big battle / compact rail; forge = small preview / big forge) ----

func _apply_layout(s: int) -> void:
	if s == STATE_COMBAT:
		_region(_battle, 0.06, 0.54)  ## squeeze the arena so the weapon rail + shop fit uncramped
		_region(_forge, 0.54, 1.0)
		if _battle.has_method("set_compact"): _battle.set_compact(false)
		if _forge.has_method("set_compact"): _forge.set_compact(true)
		if _chain_hud != null: _chain_hud.visible = true
	else:  ## FORGE_BREAK / DONE
		_region(_battle, 0.06, 0.32)
		_region(_forge, 0.32, 1.0)
		if _battle.has_method("set_compact"): _battle.set_compact(true)
		if _forge.has_method("set_compact"): _forge.set_compact(false)
		if _chain_hud != null: _chain_hud.visible = false

func _build_hud() -> Control:
	var hud := Control.new()
	hud.name = "HudBar"
	_region(hud, 0.0, 0.06)
	var bg := ColorRect.new()
	bg.name = "Bg"
	bg.color = Color(0.12, 0.10, 0.08, 0.9)
	_fill(bg)
	hud.add_child(bg)

	var wave := Label.new()
	wave.name = "WaveLabel"
	wave.text = "WAVE 1/3"
	wave.add_theme_font_size_override(&"font_size", 13)
	wave.position = Vector2(10, 6)
	hud.add_child(wave)

	var stage := Label.new()
	stage.name = "StageLabel"
	stage.text = "STAGE 1"
	stage.add_theme_font_size_override(&"font_size", 13)
	stage.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	stage.anchor_left = 1.0; stage.anchor_right = 1.0
	stage.offset_left = -170; stage.offset_right = -96; stage.offset_top = 6
	hud.add_child(stage)

	var speed := Button.new()
	speed.name = "SpeedBtn"
	speed.text = "2x"
	speed.add_theme_font_size_override(&"font_size", 11)
	speed.anchor_left = 1.0; speed.anchor_right = 1.0
	speed.offset_left = -88; speed.offset_right = -48
	speed.offset_top = 3; speed.offset_bottom = -3
	speed.pressed.connect(_on_speed)
	hud.add_child(speed)

	var pause := Button.new()
	pause.name = "PauseBtn"
	pause.text = "II"
	pause.add_theme_font_size_override(&"font_size", 11)
	pause.anchor_left = 1.0; pause.anchor_right = 1.0
	pause.offset_left = -42; pause.offset_right = -6
	pause.offset_top = 3; pause.offset_bottom = -3
	pause.pressed.connect(_on_pause)
	hud.add_child(pause)

	var paused_lbl := Label.new()
	paused_lbl.name = "PausedLabel"
	paused_lbl.text = "⏸ PAUSED"
	paused_lbl.add_theme_font_size_override(&"font_size", 12)
	paused_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	paused_lbl.anchor_left = 0.5; paused_lbl.anchor_right = 0.5
	paused_lbl.offset_left = -40; paused_lbl.offset_right = 40; paused_lbl.offset_top = 6
	paused_lbl.visible = false
	hud.add_child(paused_lbl)
	return hud

func _region(c: Control, top_frac: float, bottom_frac: float) -> void:
	c.anchor_left = 0.0; c.anchor_right = 1.0
	c.anchor_top = top_frac; c.anchor_bottom = bottom_frac
	c.offset_left = 0; c.offset_right = 0
	c.offset_top = 0; c.offset_bottom = 0

func _fill(c: Control) -> void:
	c.anchor_left = 0.0; c.anchor_top = 0.0
	c.anchor_right = 1.0; c.anchor_bottom = 1.0

## ---- run lifecycle ----

func start_run() -> void:
	var acc := get_node_or_null("/root/AccountState")
	if acc != null:
		acc.save_path = "user://account_main_v2.json"
		acc.reset()
		acc.ftue_complete = true  ## slice = post-FTUE 3-hero 3-lane
	for path in ["/root/LaneState", "/root/WaveDirector", "/root/ElementMediator",
			"/root/UltController", "/root/ShopV2", "/root/CombatV2"]:
		var a = get_node_or_null(path)
		if a != null and a.has_method("reset"):
			a.reset()
	current_stage = 0
	current_wave = 0
	waves_played = 0
	_chain = 0
	gold = 7
	_held = null
	_shop_items = []
	_stage_elements_seen = []
	_loadouts = [Loadout.make_loadout(), Loadout.make_loadout(), Loadout.make_loadout()]
	_reserves = [Reserve.make_reserve(), Reserve.make_reserve(), Reserve.make_reserve()]
	_heroes = _make_heroes()
	_shop_populate_count = 0
	_reset_stage_shop(true)  ## F0 / world start: shop opens FULL (7) so you can build a kit
	_paused = false
	_update_pause_indicator()
	_park_forge()  ## OPEN in the forge: equip, then START stage 1

func _make_heroes() -> Array:
	return [
		{"id": &"elara", "lane": 0, "base_dmg": 2, "damage_tag": &"WATER", "hp": 30, "max_hp": 30},
		{"id": &"bran", "lane": 1, "base_dmg": 2, "damage_tag": &"FIRE", "hp": 30, "max_hp": 30},
		{"id": &"vex", "lane": 2, "base_dmg": 2, "damage_tag": &"LIGHTNING", "hp": 30, "max_hp": 30},
	]

func _spawn_current_wave() -> void:
	var ls = get_node_or_null("/root/LaneState")
	var wd = get_node_or_null("/root/WaveDirector")
	if ls == null or wd == null:
		return
	ls.reset()
	var spec: Array = wd.enemies_for_stage_wave(current_stage, current_wave)
	var i: int = 0
	for proto in spec:
		var e = ls.make_enemy(proto.id, proto.lane, proto.screen_x, proto.hp)
		ls.apply_status(e, SEED_STATUSES[i % SEED_STATUSES.size()], 40)
		ls.enemies.append(e)
		i += 1
	_ticks_this_wave = 0
	_update_hud()
	if _battle != null and _battle.has_method("_sync_enemies"):
		_battle._sync_enemies(ls.enemies)

## ---- tick ----

func _on_timer() -> void:
	if state == STATE_COMBAT and not _paused:
		_tick_once()

func _tick_once() -> void:
	if state != STATE_COMBAT:
		return
	var ls = get_node_or_null("/root/LaneState")
	var combat = get_node_or_null("/root/CombatV2")
	if ls == null or combat == null:
		return
	var before: int = ls.enemies.size()
	var gs: Dictionary = {"enemies": ls.enemies, "heroes": _heroes, "lane_state": ls}
	combat.tick(gs)
	ls.enemies = gs.get("enemies", [])
	var kills: int = maxi(0, before - ls.enemies.size())
	if kills > 0:
		gold += kills  ## per-kill income (spec §9.3: 1g/kill standard)
	_ticks_this_wave += 1
	if _battle != null and _battle.has_method("_on_tick"):
		_battle._on_tick()
	_update_forge()
	if ls.enemies.size() == 0 or _ticks_this_wave >= SAFETY_TICKS:
		_on_wave_cleared()

## Wave cleared. If more waves remain in the stage, auto-battle straight into the next
## wave (NO forge break between waves). If it was the LAST wave, end the stage: advance
## the stage counter, then open the forge break (or finish the run). Forge = per STAGE.
func _on_wave_cleared() -> void:
	waves_played += 1
	var wd = get_node_or_null("/root/WaveDirector")
	var waves_in_stage: int = 3
	if wd != null:
		waves_in_stage = wd.waves_for_stage(current_stage)
	if current_wave + 1 < waves_in_stage:
		## more waves this stage -> auto-advance, keep auto-battling, shop keeps dripping
		current_wave += 1
		_spawn_current_wave()
		_drip_shop_for_wave(current_wave)
		_update_hud()
		return
	## stage complete -> stage break (forge)
	current_wave = 0
	current_stage += 1
	## stage boundary -> feed pity counter with what appeared in shop this stage
	var shop = get_node_or_null("/root/ShopV2")
	if shop != null and shop.has_method("notify_stage_end"):
		shop.notify_stage_end(_stage_elements_seen, not _stage_elements_seen.is_empty())
	_stage_elements_seen = []
	if current_stage >= STAGES:
		state = STATE_DONE
		_set_next_wave(false)
		_apply_layout(STATE_FORGE)
		_update_hud()
		return
	## park in FORGE — the shop still shows the just-finished stage's full board;
	## it resets to the new stage's start batch on the next START (advance_wave).
	_park_forge()

## Show the FORGE break for the currently-spawned wave: forge layout, fresh shop UI,
## START NEXT WAVE revealed. Does NOT advance the wave or spawn enemies.
func _park_forge() -> void:
	state = STATE_FORGE
	## gold is earned per-kill in _tick_once (no flat grant); shop persists across the
	## stage's waves (rolled at stage start / on reroll), so it is NOT re-rolled here.
	_refresh_shop_ui()
	_set_next_wave(true)
	if _forge != null and _forge.has_method("set_reroll_cost"):
		var rc: int = 1
		var shop = get_node_or_null("/root/ShopV2")
		if shop != null and shop.has_method("reroll_cost_for"):
			rc = int(shop.reroll_cost_for(current_stage))
		_forge.set_reroll_cost(rc)
	for i in _loadouts.size():
		_sync_hero_forge(i)  ## ensure the panel's sockets + reserve match state on every forge open
	_refresh_weapon_tips()
	_apply_layout(STATE_FORGE)
	_update_hud()

## START NEXT WAVE: begin combat for the wave we are parked in front of. Its enemies
## are already spawned (start_run / _enter_forge_break) — no increment, no respawn.
func advance_wave() -> void:
	if state != STATE_FORGE:
		return
	## clear transient forge selections so they never leak into the next forge break
	_held = null
	## starting a stage's combat -> the shop resets to the slow-populate drip for THIS stage
	## (the full board you saw at the forge break is committed; unbought items are discarded).
	_reset_stage_shop(false)
	_spawn_current_wave()  ## materialize the first wave's enemies as combat begins
	_drip_shop_for_wave(current_wave)  ## stage's wave-0 shop drip
	state = STATE_COMBAT
	_paused = false  ## each stage starts playing (never resume into a paused freeze)
	_update_pause_indicator()
	_set_next_wave(false)
	_apply_layout(STATE_COMBAT)

## ---- HUD / forge updates ----

func _on_reaction(rid: StringName, enemy: Dictionary) -> void:
	_chain += 1
	if _battle != null and _battle.has_method("show_reaction_label"):
		_battle.show_reaction_label(rid, enemy)

## ---- shop slow-populate (GDD §4: 2/3/2 across the stage's 3 waves) ----

func _schedule() -> Array:
	var shop = get_node_or_null("/root/ShopV2")
	if shop != null and shop.has_method("populate_schedule_3wave"):
		return shop.populate_schedule_3wave()
	return [{"wave": -1, "count": 2}, {"wave": 0, "count": 1}, {"wave": 1, "count": 1}, {"wave": 2, "count": 1}, {"wave": 2, "count": 2}]

## Roll `n` fresh items into the first `n` EMPTY shop slots (the slow-populate drip).
func _add_shop_items(n: int, pity: bool) -> void:
	var shop = get_node_or_null("/root/ShopV2")
	if shop == null or not shop.has_method("roll_items") or n <= 0:
		return
	var fresh: Array = shop.roll_items(current_stage, n, pity)
	var fi: int = 0
	for i in _shop_items.size():
		if fi >= fresh.size():
			break
		if _shop_items[i] == null:
			_shop_items[i] = fresh[fi]
			fi += 1
	_track_elements(fresh)

## Reset the board for a stage. full=true -> fill all 7 immediately (world start / F0).
## full=false -> drop only the stage-start batch (the "2" of the 2/3/2 slow-populate).
func _reset_stage_shop(full: bool = false) -> void:
	_shop_items = [null, null, null, null, null, null, null]
	_shop_stage = current_stage
	_shop_populate_count += 1
	var shop = get_node_or_null("/root/ShopV2")
	var pity: bool = bool(shop.pity_triggered) if shop != null else false
	if full:
		_add_shop_items(7, pity)
	else:
		for e in _schedule():
			if int(e.get("wave", -99)) == -1:
				_add_shop_items(int(e.get("count", 0)), pity)
				pity = false  ## pity element guarantee applies only to the stage's first item
	_refresh_shop_ui()

## During combat: drop this wave's scheduled batch(es) into the always-visible rail.
func _drip_shop_for_wave(wave_idx: int) -> void:
	for e in _schedule():
		if int(e.get("wave", -99)) == wave_idx:
			_add_shop_items(int(e.get("count", 0)), false)
	_refresh_shop_ui()

## Track element ids that appear in the shop this stage (feeds pity at stage end).
func _track_elements(items: Array) -> void:
	var shop = get_node_or_null("/root/ShopV2")
	if shop == null:
		return
	for it in items:
		if it != null and shop.ELEMENT_IDS.has(String(it.get("id", ""))) and not _stage_elements_seen.has(String(it.get("id", ""))):
			_stage_elements_seen.append(String(it.get("id", "")))

func _refresh_shop_ui() -> void:
	if _forge == null:
		return
	if _forge.has_method("populate_shop"):
		_forge.populate_shop(_shop_items)
	if _forge.has_method("set_gold"):
		_forge.set_gold(gold)

func _update_hud() -> void:
	if _hud == null:
		return
	var w := _hud.get_node_or_null("WaveLabel") as Label
	var s := _hud.get_node_or_null("StageLabel") as Label
	var wd = get_node_or_null("/root/WaveDirector")
	var total: int = 3
	if wd != null:
		total = wd.waves_for_stage(current_stage)
	if w != null:
		w.text = "WAVE %d/%d" % [current_wave + 1, total]
	if s != null:
		s.text = "STAGE %d" % (current_stage + 1)

func _update_forge() -> void:
	if _forge == null:
		return
	var uc = get_node_or_null("/root/UltController")
	var bars: int = 0
	if uc != null:
		bars = int(uc.bars)
	for i in 3:
		var hp: int = 100
		var mhp: int = 100
		if i < _heroes.size():
			hp = int(_heroes[i].get("hp", 100))
			mhp = int(_heroes[i].get("max_hp", 100))
		## HP lives on the battle scene (floats above the hero sprite), not the forge rail
		if _battle != null and _battle.has_method("set_hero_hp"):
			_battle.set_hero_hp(i, hp, mhp)
		if _forge.has_method("set_hero_ult_bars"):
			_forge.set_hero_ult_bars(i, bars)
	if _forge.has_method("set_gold"):
		_forge.set_gold(gold)
	_refresh_weapon_tips()

## Reroll wipes the WHOLE shop list and loads a fresh full board of 7 (including any
## slots already bought/emptied). Price scales with the stage (see ShopV2.reroll_cost_for).
func _on_reroll() -> void:
	var shop = get_node_or_null("/root/ShopV2")
	if shop == null:
		return
	var cost: int = 1
	if shop.has_method("reroll_cost_for"):
		cost = int(shop.reroll_cost_for(current_stage))
	var res: Dictionary = shop.reroll(gold, cost)
	if not res.get("ok", false):
		return
	gold -= int(res.get("cost", 0))
	var pity: bool = bool(shop.pity_triggered)
	_shop_items = shop.roll_items(current_stage, 7, pity)  ## fresh full board (the whole list)
	_track_elements(_shop_items)
	_refresh_shop_ui()

## ---- forge equip (tap shop item, then tap a hero socket; drag = Phase 5) ----

func _on_shop_tap(slot_idx: int) -> void:
	if state != STATE_FORGE:
		return
	if slot_idx < 0 or slot_idx >= _shop_items.size() or _shop_items[slot_idx] == null:
		return
	_held = {"kind": "shop", "hero": -1, "idx": slot_idx}  ## pick up a shop item to buy

## ---- real-time weapon tooltip (combined P/M/A effect per hero) ----

func _fn_slot_desc(fn_id: StringName, slot: int) -> String:
	var path := "res://data/functions/%s.tres" % String(fn_id).to_lower()
	if ResourceLoader.exists(path):
		var f = load(path)
		if f != null:
			return f.describe(slot)
	return String(fn_id)

## Combined "what does this weapon do now" text from the hero's loadout (0=P,1=M,2=A).
func _weapon_desc(hero_idx: int) -> String:
	if hero_idx < 0 or hero_idx >= _loadouts.size():
		return "Empty weapon"
	var lo: Array = _loadouts[hero_idx]
	var passive = lo[0]
	var modf = lo[1]
	var active = lo[2]
	if active == null and modf == null and passive == null:
		return "Empty weapon"
	var lines: Array = []
	if active != null:
		lines.append("ATK: " + _fn_slot_desc(active.id, 2))
	else:
		lines.append("ATK: — (equip an Active)")
	if modf != null:
		lines.append("+MOD: " + _fn_slot_desc(modf.id, 1))
	if passive != null:
		lines.append("PASS: " + _fn_slot_desc(passive.id, 0))
	return "\n".join(lines)

func _refresh_weapon_tips() -> void:
	if _forge == null or not _forge.has_method("set_weapon_desc"):
		return
	for i in _loadouts.size():
		_forge.set_weapon_desc(i, _weapon_desc(i))

func _on_socket_tap(hero_idx: int, socket_idx: int) -> void:
	_tile_tap("socket", hero_idx, socket_idx)

func _on_reserve_tap(hero_idx: int, reserve_idx: int) -> void:
	_tile_tap("reserve", hero_idx, reserve_idx)

## Unified pick-up / drop. Tap an occupied tile to pick it up; tap any other tile to
## drop. Shop -> tile = BUY. Owned tile -> owned tile = move/swap/merge (no gold,
## hero-agnostic). Shop pick-up happens in _on_shop_tap.
func _tile_tap(kind: String, hero_idx: int, idx: int) -> void:
	if state != STATE_FORGE:
		return  ## equip/move is forge-break only (spec §15)
	var dst := {"kind": kind, "hero": hero_idx, "idx": idx}
	if _held == null:
		if ForgeGrid.get_tile(_loadouts, _reserves, dst) != null:
			_held = dst  ## pick up this owned item
		return
	var src = _held
	_held = null
	if String(src.get("kind", "")) == "shop":
		_buy_into(int(src.get("idx", -1)), dst)
	else:
		_move_owned(src, dst)

## Buy the held shop item and place it into dst (socket or reserve). Charges only on
## success; reserve/socket-full blocks flash an error and do not charge.
func _buy_into(shop_slot: int, dst: Dictionary) -> void:
	if shop_slot < 0 or shop_slot >= _shop_items.size():
		return
	var item = _shop_items[shop_slot]
	if item == null:
		return
	var shop = get_node_or_null("/root/ShopV2")
	if shop == null:
		return
	var buy: Dictionary = shop.buy(item, gold)
	if not buy.get("ok", false):
		return  ## can't afford
	var hero_idx: int = int(dst.get("hero", -1))
	if hero_idx < 0 or hero_idx >= _loadouts.size():
		return
	if String(dst.get("kind", "")) == "socket":
		var res: Dictionary = Reserve.equip(_loadouts[hero_idx], _reserves[hero_idx], int(dst.get("idx", -1)), item)
		if not res.get("ok", false):
			if _forge != null and _forge.has_method("flash_error"):
				_forge.flash_error(hero_idx)
			return
	else:  ## reserve dst: place if empty, merge if same id+tier, else blocked
		var ri: int = int(dst.get("idx", -1))
		if ri < 0 or ri >= _reserves[hero_idx].size():
			return
		var cur = _reserves[hero_idx][ri]
		if cur == null:
			_reserves[hero_idx][ri] = {"id": StringName(item.get("id", &"")), "tier": int(item.get("tier", 1)), "cost": int(item.get("cost", 0))}
		elif StringName(cur.get("id", &"")) == StringName(item.get("id", &"")) and int(cur.get("tier", 1)) == int(item.get("tier", 1)):
			_reserves[hero_idx][ri] = {"id": StringName(item.get("id", &"")), "tier": int(item.get("tier", 1)), "cost": int(item.get("cost", 0)), "merge": "2/2"}
		else:
			if _forge != null and _forge.has_method("flash_error"):
				_forge.flash_error(hero_idx)
			return
	gold -= int(buy.get("cost", 0))
	_shop_items[shop_slot] = null  ## remove bought item from shop
	_sync_hero_forge(hero_idx)
	_refresh_shop_ui()
	_refresh_weapon_tips()

## Move an OWNED item between any two tiles (any hero). No gold. move/swap/merge.
func _move_owned(src: Dictionary, dst: Dictionary) -> void:
	var res: Dictionary = ForgeGrid.move(_loadouts, _reserves, src, dst)
	if not res.get("ok", false):
		return
	_sync_hero_forge(int(src.get("hero", -1)))
	_sync_hero_forge(int(dst.get("hero", -1)))
	_refresh_weapon_tips()

## Long-press a socket -> sell that Function back to the shop for a reduced refund.
func _on_socket_sell(hero_idx: int, socket_idx: int) -> void:
	if state != STATE_FORGE or hero_idx < 0 or hero_idx >= _loadouts.size():
		return
	_held = null  ## a sell cancels any in-progress pick-up
	var res: Dictionary = Reserve.sell_socket(_loadouts[hero_idx], socket_idx)
	if res.get("ok", false):
		gold += int(res.get("gold_refund", 0))
		_sync_hero_forge(hero_idx)
		_refresh_shop_ui()
		_refresh_weapon_tips()

## Long-press a reserve slot -> sell that benched Function for a reduced refund.
func _on_reserve_sell(hero_idx: int, reserve_idx: int) -> void:
	if state != STATE_FORGE or hero_idx < 0 or hero_idx >= _reserves.size():
		return
	_held = null  ## a sell cancels any in-progress pick-up
	var res: Dictionary = Reserve.sell_reserve(_reserves[hero_idx], reserve_idx)
	if res.get("ok", false):
		gold += int(res.get("gold_refund", 0))
		_sync_hero_forge(hero_idx)
		_refresh_shop_ui()

## Push a hero's full forge state (3 sockets + 2 reserve slots) to the panel.
func _sync_hero_forge(hero_idx: int) -> void:
	if _forge == null:
		return
	for s in 3:
		var e = _loadouts[hero_idx][s]
		if _forge.has_method("set_socket_fn"):
			if e == null:
				_forge.set_socket_fn(hero_idx, s, &"")
			else:
				_forge.set_socket_fn(hero_idx, s, e.id, int(e.tier), String(e.id), String(e.get("merge", "")))
	if _forge.has_method("set_reserve_item"):
		for r in 2:
			var ri = _reserves[hero_idx][r]
			if ri == null:
				_forge.set_reserve_item(hero_idx, r, &"")
			else:
				_forge.set_reserve_item(hero_idx, r, ri.id, int(ri.tier))

func get_reserve(hero_idx: int, reserve_idx: int):
	if hero_idx < 0 or hero_idx >= _reserves.size():
		return null
	if reserve_idx < 0 or reserve_idx >= _reserves[hero_idx].size():
		return null
	return _reserves[hero_idx][reserve_idx]

func get_socket(hero_idx: int, socket_idx: int):
	if hero_idx < 0 or hero_idx >= _loadouts.size():
		return null
	if socket_idx < 0 or socket_idx >= _loadouts[hero_idx].size():
		return null
	return _loadouts[hero_idx][socket_idx]

## Fire a hero's Ult when its meter is full. Ult VFX/effect = Phase 5; for now firing
## just consumes the (shared) charge so the button + feedback loop is demonstrable.
func _on_ult(_hero_idx: int) -> void:
	var uc = get_node_or_null("/root/UltController")
	if uc == null:
		return
	if int(uc.bars) < 3:
		return  ## not charged
	uc.bars = 0  ## consume
	_update_forge()

func _on_pause() -> void:
	## pause only gates the tick — never swaps state or re-anchors (was a layout bug)
	_paused = not _paused
	_update_pause_indicator()

func _update_pause_indicator() -> void:
	if _hud == null:
		return
	var pl := _hud.get_node_or_null("PausedLabel") as Label
	if pl != null:
		pl.visible = _paused
	var pb := _hud.get_node_or_null("PauseBtn") as Button
	if pb != null:
		pb.text = "▶" if _paused else "II"

func is_paused() -> bool:
	return _paused

func _on_speed() -> void:
	var t := get_node_or_null("TickTimer") as Timer
	if t != null:
		t.wait_time = TICK_INTERVAL if t.wait_time < TICK_INTERVAL else TICK_INTERVAL * 0.5

## Demo helper: jump straight to a clean FORGE_BREAK (no enemies) for AUTOSHOT.
func demo_forge_break() -> void:
	var ls = get_node_or_null("/root/LaneState")
	if ls != null:
		ls.enemies = []
	if _battle != null and _battle.has_method("_sync_enemies"):
		_battle._sync_enemies([])
	## simulate a stage-end break with a FULL board (7) for forge/buy/sell/layout QC
	var shop = get_node_or_null("/root/ShopV2")
	if shop != null and shop.has_method("roll_items"):
		_shop_items = shop.roll_items(current_stage, 7, false)
	else:
		_shop_items = []
	_shop_stage = current_stage
	_park_forge()

## ---- test introspection ----

func is_combat() -> bool: return state == STATE_COMBAT
func is_forge_break() -> bool: return state == STATE_FORGE
func is_done() -> bool: return state == STATE_DONE
