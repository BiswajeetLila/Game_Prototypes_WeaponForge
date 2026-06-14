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
var _selected_shop: int = -1   ## currently selected shop slot (tap-to-equip)
var _shop_items: Array = []    ## 7 slots, each {id,tier,cost} or null (bought/empty)
var _stage_elements_seen: Array = []  ## element ids that appeared in shop this stage (pity)
var _shop_populate_count: int = 0     ## test probe: shop rolls ONCE per stage, not per wave

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
	if _forge.has_signal("start_next_wave"):
		_forge.start_next_wave.connect(advance_wave)

	_chain_hud = ChainHUDScene.instantiate()
	add_child(_chain_hud)

func _set_next_wave(v: bool) -> void:
	if _forge != null and _forge.has_method("set_next_wave_visible"):
		_forge.set_next_wave_visible(v)

## ---- phase-adaptive layout (combat = big battle / compact rail; forge = small preview / big forge) ----

func _apply_layout(s: int) -> void:
	if s == STATE_COMBAT:
		_region(_battle, 0.06, 0.66)
		_region(_forge, 0.66, 1.0)
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
	_selected_shop = -1
	_shop_items = []
	_stage_elements_seen = []
	_loadouts = [Loadout.make_loadout(), Loadout.make_loadout(), Loadout.make_loadout()]
	_heroes = _make_heroes()
	_shop_populate_count = 0
	_spawn_current_wave()
	_populate_shop()  ## shop opens at STAGE start (persists across the stage's waves)
	state = STATE_COMBAT
	_paused = false
	_set_next_wave(false)
	_apply_layout(STATE_COMBAT)

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
		_enter_forge_break()

func _enter_forge_break() -> void:
	state = STATE_FORGE
	waves_played += 1
	## gold is earned per-kill in _tick_once now (no flat grant)
	## shop is NOT re-rolled here — it persists across the stage's waves (populated at stage start)
	_refresh_shop_ui()
	_set_next_wave(true)
	if _forge != null and _forge.has_method("set_reroll_cost"):
		_forge.set_reroll_cost(1)
	_apply_layout(STATE_FORGE)
	_update_hud()

func advance_wave() -> void:
	if state == STATE_DONE:
		return
	var wd = get_node_or_null("/root/WaveDirector")
	var waves_in_stage: int = 3
	if wd != null:
		waves_in_stage = wd.waves_for_stage(current_stage)
	current_wave += 1
	var new_stage: bool = false
	if current_wave >= waves_in_stage:
		current_wave = 0
		current_stage += 1
		new_stage = true
		## stage boundary -> feed pity counter with what appeared in shop this stage
		var shop = get_node_or_null("/root/ShopV2")
		if shop != null and shop.has_method("notify_stage_end"):
			shop.notify_stage_end(_stage_elements_seen, not _stage_elements_seen.is_empty())
		_stage_elements_seen = []
	if current_stage >= STAGES:
		state = STATE_DONE
		_set_next_wave(false)
		_update_hud()
		return
	_spawn_current_wave()
	if new_stage:
		_populate_shop()  ## fresh shop ONLY at a new stage
	_set_next_wave(false)
	state = STATE_COMBAT
	_apply_layout(STATE_COMBAT)

## ---- HUD / forge updates ----

func _on_reaction(rid: StringName, enemy: Dictionary) -> void:
	_chain += 1
	if _battle != null and _battle.has_method("show_reaction_label"):
		_battle.show_reaction_label(rid, enemy)

func _populate_shop() -> void:
	var shop = get_node_or_null("/root/ShopV2")
	if shop != null and shop.has_method("roll_items"):
		var pity: bool = bool(shop.pity_triggered)
		_shop_items = shop.roll_items(current_stage, 7, pity)
	else:
		_shop_items = []
	_shop_populate_count += 1
	_track_elements(_shop_items)
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

## Reroll the unbought (non-null) visible shop slots for 1g (slice deviation from
## spec §11.2 pending-only, so the forge-break reroll button actually works).
func _on_reroll() -> void:
	var shop = get_node_or_null("/root/ShopV2")
	if shop == null:
		return
	var rollable: int = 0
	for it in _shop_items:
		if it != null:
			rollable += 1
	var res: Dictionary = shop.reroll(gold, rollable)
	if not res.get("ok", false):
		return
	gold -= int(res.get("cost", 0))
	for i in _shop_items.size():
		if _shop_items[i] != null:
			var fresh: Array = shop.roll_items(current_stage, 1, false)
			if fresh.size() > 0:
				_shop_items[i] = fresh[0]
				_track_elements([fresh[0]])
	_refresh_shop_ui()

## ---- forge equip (tap shop item, then tap a hero socket; drag = Phase 5) ----

func _on_shop_tap(slot_idx: int) -> void:
	_selected_shop = slot_idx

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
	if state != STATE_FORGE:
		return  ## equip is forge-break only (spec §15)
	if _selected_shop < 0 or _selected_shop >= _shop_items.size():
		return
	if hero_idx < 0 or hero_idx >= _loadouts.size():
		return
	var item = _shop_items[_selected_shop]
	if item == null:
		return  ## slot already bought / empty
	var shop = get_node_or_null("/root/ShopV2")
	if shop == null:
		return
	var res: Dictionary = shop.buy(item, gold)
	if not res.get("ok", false):
		return  ## can't afford
	gold -= int(res.get("cost", 0))
	var fn_id := StringName(item.get("id", ""))
	var tier: int = int(item.get("tier", 1))
	## slice merge-stub: no tier bump (allow_merge=false) -> shows "2/2"
	_loadouts[hero_idx] = Loadout.apply_drop(_loadouts[hero_idx], socket_idx, fn_id, tier, false)
	_shop_items[_selected_shop] = null  ## remove bought item from shop
	_selected_shop = -1
	var entry = _loadouts[hero_idx][socket_idx]
	if _forge != null and _forge.has_method("set_socket_fn") and entry != null:
		_forge.set_socket_fn(hero_idx, socket_idx, entry.id, int(entry.tier), String(entry.id), String(entry.get("merge", "")))
	_refresh_shop_ui()
	_refresh_weapon_tips()  ## real-time: weapon tooltip updates as you equip

func get_socket(hero_idx: int, socket_idx: int):
	if hero_idx < 0 or hero_idx >= _loadouts.size():
		return null
	if socket_idx < 0 or socket_idx >= _loadouts[hero_idx].size():
		return null
	return _loadouts[hero_idx][socket_idx]

func _on_pause() -> void:
	## pause only gates the tick — never swaps state or re-anchors (was a layout bug)
	_paused = not _paused

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
	_enter_forge_break()

## ---- test introspection ----

func is_combat() -> bool: return state == STATE_COMBAT
func is_forge_break() -> bool: return state == STATE_FORGE
func is_done() -> bool: return state == STATE_DONE
