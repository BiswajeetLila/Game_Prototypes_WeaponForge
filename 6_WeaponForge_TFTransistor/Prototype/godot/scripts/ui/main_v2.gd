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

var _battle: Control
var _forge: Control
var _chain_hud: Control
var _hud: Control
var _next_btn: Button
var _heroes: Array = []

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

	_chain_hud = ChainHUDScene.instantiate()
	add_child(_chain_hud)

	_next_btn = Button.new()
	_next_btn.name = "NextWaveBtn"
	_next_btn.text = "START NEXT WAVE"
	_next_btn.anchor_left = 0.18; _next_btn.anchor_right = 0.82
	_next_btn.anchor_top = 0.515; _next_btn.anchor_bottom = 0.565
	_next_btn.pressed.connect(advance_wave)
	add_child(_next_btn)
	_next_btn.visible = false

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
	_heroes = _make_heroes()
	_spawn_current_wave()
	state = STATE_COMBAT
	if _next_btn != null:
		_next_btn.visible = false

func _make_heroes() -> Array:
	return [
		{"id": &"elara", "lane": 0, "base_dmg": 2, "damage_tag": &"WATER"},
		{"id": &"bran", "lane": 1, "base_dmg": 2, "damage_tag": &"FIRE"},
		{"id": &"vex", "lane": 2, "base_dmg": 2, "damage_tag": &"LIGHTNING"},
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
	if state == STATE_COMBAT:
		_tick_once()

func _tick_once() -> void:
	if state != STATE_COMBAT:
		return
	var ls = get_node_or_null("/root/LaneState")
	var combat = get_node_or_null("/root/CombatV2")
	if ls == null or combat == null:
		return
	var gs: Dictionary = {"enemies": ls.enemies, "heroes": _heroes, "lane_state": ls}
	combat.tick(gs)
	ls.enemies = gs.get("enemies", [])
	_ticks_this_wave += 1
	if _battle != null and _battle.has_method("_on_tick"):
		_battle._on_tick()
	_update_forge()
	if ls.enemies.size() == 0 or _ticks_this_wave >= SAFETY_TICKS:
		_enter_forge_break()

func _enter_forge_break() -> void:
	state = STATE_FORGE
	waves_played += 1
	gold += 3
	_populate_shop()
	if _next_btn != null:
		_next_btn.visible = true
	_update_hud()

func advance_wave() -> void:
	if state == STATE_DONE:
		return
	var wd = get_node_or_null("/root/WaveDirector")
	var waves_in_stage: int = 3
	if wd != null:
		waves_in_stage = wd.waves_for_stage(current_stage)
	current_wave += 1
	if current_wave >= waves_in_stage:
		current_wave = 0
		current_stage += 1
	if current_stage >= STAGES:
		state = STATE_DONE
		if _next_btn != null:
			_next_btn.visible = false
		_update_hud()
		return
	_spawn_current_wave()
	if _next_btn != null:
		_next_btn.visible = false
	state = STATE_COMBAT

## ---- HUD / forge updates ----

func _on_reaction(_rid: StringName, _enemy: Dictionary) -> void:
	_chain += 1

func _populate_shop() -> void:
	if _forge == null or not _forge.has_method("populate_shop"):
		return
	var items: Array = []
	for n in SHOP_SAMPLE:
		items.append({"id": n})
	_forge.populate_shop(items)
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
		if _forge.has_method("set_hero_hp"):
			_forge.set_hero_hp(i, 100, 100)
		if _forge.has_method("set_hero_ult_bars"):
			_forge.set_hero_ult_bars(i, bars)

func _on_reroll() -> void:
	_populate_shop()

func _on_pause() -> void:
	if state == STATE_COMBAT:
		state = STATE_FORGE
	elif state == STATE_FORGE:
		state = STATE_COMBAT

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
