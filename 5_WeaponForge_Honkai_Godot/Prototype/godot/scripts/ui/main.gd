## Main — composition root for the ultra-MVP play scene.
##
## Lifecycle:
##   _ready
##     -> GameState autoload has already called new_session()
##     -> open_forge_moment for wave 1
##
##   ForgePanel emits wave_start_requested -> Combat.start_wave(wave)
##   GameState.wave_cleared -> banner + per-hero unlock at wave 2 / 4
##                             then next forge OR stage clear modal
##   GameState.stage_cleared -> ResultModal.open("clear")
##   GameState.squad_wiped   -> ResultModal.open("wipe")
##   GameState.hero_died     -> per-individual death banner (informational)
##   ResultModal.restart_requested -> _on_reset_pressed
##
##   Notifications layer renders transient banners (wave start / clear /
##   wipe / hero join / stage clear). ScreenFlash overlay tints purple on
##   ult fire.
extends Control

## Hero unlock thresholds — wave on which clearing triggers the unlock banner.
## Authoritative source; the _on_wave_cleared match block reads these.
## Retimed per forge-ux-balance-w10: Elara W2->W3, Vex W4->W6 — gives 3 solo
## Bran waves to learn basics, 3 dual-hero waves, then trio for W7-10.
const ELARA_UNLOCK_WAVE: int = 3
const VEX_UNLOCK_WAVE: int = 6

@onready var _forge: Control = %ForgePanel
@onready var _squad_bar: Control = %SquadBar
@onready var _reset_btn: Button = %ResetBtn
@onready var _hud: Control = %Hud
@onready var _codex_modal: Control = %CodexModal
@onready var _result_modal: Control = %ResultModal
@onready var _reforge_retry_modal: Control = %ReforgeRetryModal
@onready var _notifications: Control = %Notifications

const DraftModalScript = preload("res://scripts/ui/draft_modal.gd")

## A run is ONE stage: 4 waves + the boss on wave 5 (GameState.RUN_FINAL_WAVE
## is the single source; HUD reads it too). Boss kill -> victory -> home.
const RUN_FINAL_WAVE: int = GameState.RUN_FINAL_WAVE

var _draft_modal: ColorRect = null
var _pending_next_wave: int = -1
var _kill_bar: ProgressBar = null
var _strip_labels: Dictionary = {}

func _ready() -> void:
	_reset_btn.pressed.connect(_on_reset_pressed)
	_reset_btn.text = "⌂ HOME"
	_hud.codex_pressed.connect(_codex_modal.open)
	_result_modal.restart_requested.connect(_on_back_home)
	_reforge_retry_modal.retry_requested.connect(_on_retry_pressed)
	_reforge_retry_modal.give_up_requested.connect(_on_give_up_pressed)
	GameState.wave_cleared.connect(_on_wave_cleared)
	GameState.stage_cleared.connect(_on_stage_cleared)
	GameState.squad_wiped.connect(_on_squad_wiped)
	GameState.hero_died.connect(_on_hero_died)
	Combat.boss_telegraph.connect(_on_boss_telegraph)
	ScreenShake.register_target(self)
	## NEW FLOW (GDD loop): the meta layer (pulls/equip) lives on the Home
	## screen. Battle = waves + post-wave Forge Draft only — no between-wave
	## shop/forge. The legacy ForgePanel stays in the scene for the old test
	## suites but is hidden in play.
	_forge.visible = false
	## Modal lives on its own CanvasLayer: viewport-relative full-rect sizing
	## (as a plain child of Main it laid out 0x0) + guaranteed top-most draw.
	var modal_layer := CanvasLayer.new()
	modal_layer.layer = 100
	add_child(modal_layer)
	_draft_modal = DraftModalScript.new()
	modal_layer.add_child(_draft_modal)
	_draft_modal.card_picked.connect(_on_draft_picked)
	ForgeDraft.meter_full.connect(_on_meter_full)
	_build_battle_overlay(modal_layer)
	_start_run()

## Fresh run: the FULL squad enters with their account-loaded weapons
## (pull at Home -> fight with what you forged).
func _start_run() -> void:
	GameState.new_session()
	GameState.unlock_hero(&"elara")
	GameState.unlock_hero(&"vex")
	for id in GameState.squad_order:
		var w = AccountState.get_equipped(id)
		if w != null:
			GameState.equip_weapon_data(id, w)
	## Enter the stage at FULL HP (weapon bonus included) AND refresh the bars —
	## equip_weapon_data clamps-not-refills (mid-run rule); run start is the exception.
	## restore_squad_full emits hero_hp_changed per hero so the bars don't show stale HP (#1).
	GameState.restore_squad_full()
	GameState.run_stage = AccountState.current_stage
	ForgeDraft.reset_run()
	_refresh_strip()
	_notifications.show_banner("🏰 STAGE %d" % GameState.run_stage, Color(0.8, 0.9, 1.0), 1.2)
	_begin_wave(1)

func _begin_wave(wave: int) -> void:
	_notifications.show_banner("⚔ WAVE %d" % wave, Color(1, 0.9, 0.6), 1.0)
	await get_tree().create_timer(0.8).timeout
	Combat.start_wave(wave)

func _on_wave_cleared(wave: int) -> void:
	var reward: int = 5 + wave * 2
	_notifications.show_card(
		"✓ WAVE %d CLEAR" % wave,
		"+ 🪙 %d" % reward,
		Color(0.6, 1, 0.7),
		1.2)
	if JuiceConfig.JUICE_ENABLED:
		ScreenShake.kick(JuiceConfig.WAVE_CLEAR.shake_amp, JuiceConfig.WAVE_CLEAR.shake_dur)

	## THE LOOP: run ends at the boss. Otherwise waves chain AUTOMATICALLY —
	## drafts are kill-gated (meter_full), not wave-gated.
	if wave >= RUN_FINAL_WAVE:
		if _draft_modal.visible:
			_draft_modal.visible = false   ## run over — a pending pick is moot
		AccountState.award_victory()
		AccountState.advance_stage()
		_notifications.show_banner("🏆 STAGE %d CLEAR  +%d💎" % [GameState.run_stage,
			AccountState.RUN_VICTORY_BONUS], Color(1, 0.85, 0.2), 1.6)
		_result_modal.open(&"clear")
		return
	var next_wave: int = wave + 1
	if _draft_modal.visible:
		_pending_next_wave = next_wave   ## wave ended on the filling kill: pick first
		return
	GameState.set_wave(next_wave)
	_begin_wave(next_wave)

## Kill meter filled: pause the fight (mid-wave) and offer the pick.
func _on_meter_full() -> void:
	if _draft_modal.visible:
		return
	Combat.stop()
	_draft_modal.open(ForgeDraft.deal(3))

func _on_draft_picked(card) -> void:
	ForgeDraft.apply(card)
	ForgeDraft.consume_draft()
	if _pending_next_wave > 0:
		var w: int = _pending_next_wave
		_pending_next_wave = -1
		GameState.set_wave(w)
		_begin_wave(w)
	else:
		Combat.resume()   ## mid-wave pick: fight on, same enemies

func _on_stage_cleared() -> void:
	_notifications.show_banner("🏆 STAGE CLEAR", Color(1, 0.85, 0.2), 1.8)
	_result_modal.open(&"clear")

func _on_squad_wiped() -> void:
	_notifications.show_banner("💀 WIPE", Color(1, 0.3, 0.3), 1.6)
	## Stage D — boss-wave wipes open the ReforgeRetryModal (revive + same
	## wave). Non-boss wipes fall through to the standard ResultModal flow.
	if GameState.wave in GameState.BOSS_WAVES:
		var boss_id: StringName = Combat.BOSS_BY_WAVE.get(GameState.wave, &"")
		var boss_def = GameState.get_enemy_def(boss_id)
		var boss_name: String = boss_def.name if boss_def != null else "Boss"
		_reforge_retry_modal.open(boss_name, GameState.wave)
		return
	_result_modal.open(&"wipe")

## Reforge & Retry path. Revive squad and re-fight the same boss wave
## (run mods + equipped weapons untouched).
func _on_retry_pressed() -> void:
	Combat.stop()
	GameState.revive_squad_for_retry()
	_begin_wave(GameState.wave)

## Stage D — Give Up routes through to the standard wipe result modal.
func _on_give_up_pressed() -> void:
	_result_modal.open(&"wipe")

## Stage D — pre-fight boss telegraph banner. Combat emits this from
## _spawn_boss right before the first tick fires, giving the player ~1s to
## read the weak/resist hint.
func _on_boss_telegraph(text: String) -> void:
	_notifications.show_banner(text, Color(1, 0.55, 0.55), 1.6)

func _on_hero_died(hero_id: StringName) -> void:
	## Per-individual death — informational only. Squad keeps fighting as long
	## as any_alive(); the stage-failure modal opens via _on_squad_wiped above.
	var hero = GameState.get_hero(hero_id)
	if hero == null:
		return
	_notifications.show_banner("💔 %s FALLS" % hero.data.name.to_upper(), Color(1, 0.55, 0.55), 1.0)

## ---------- Battle overlay: kill bar + per-hero weapon strip (W3) ----------
## Explicit viewport sizing — runtime Controls under a CanvasLayer don't lay
## out from anchor presets alone (the draft-modal 0x0 lesson).

func _build_battle_overlay(layer: CanvasLayer) -> void:
	var vp: Vector2 = get_viewport_rect().size

	## Kill bar under the wave banner: fills per enemy killed, gold when full.
	_kill_bar = ProgressBar.new()
	_kill_bar.min_value = 0
	_kill_bar.max_value = ForgeDraft.KILLS_PER_DRAFT
	_kill_bar.value = 0
	_kill_bar.show_percentage = false
	_kill_bar.position = Vector2(110.0, 54.0)
	_kill_bar.size = Vector2(vp.x - 220.0, 10.0)
	layer.add_child(_kill_bar)
	ForgeDraft.meter_changed.connect(_on_meter_changed_ui)

	## Weapon strip: three columns under the portraits — weapon, ATK, upgrade pips.
	var strip := HBoxContainer.new()
	strip.position = Vector2(0.0, vp.y - 44.0)
	strip.size = Vector2(vp.x, 40.0)
	strip.add_theme_constant_override(&"separation", 6)
	layer.add_child(strip)
	for id in [&"bran", &"elara", &"vex"]:
		var l := Label.new()
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.add_theme_font_size_override(&"font_size", 11)
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		strip.add_child(l)
		_strip_labels[id] = l
	GameState.weapon_data_changed.connect(func(_h): _refresh_strip())
	ForgeDraft.draft_applied.connect(func(_c): _refresh_strip())

func _on_meter_changed_ui(kills: int, needed: int) -> void:
	if _kill_bar == null:
		return
	_kill_bar.value = mini(kills, needed)
	_kill_bar.modulate = Color(1.0, 0.85, 0.2) if kills >= needed else Color(1, 1, 1)

func _refresh_strip() -> void:
	for id in _strip_labels:
		var l: Label = _strip_labels[id]
		var hero = GameState.get_hero(id)
		if hero == null:
			l.text = ""
			continue
		var weapon_str: String = "— no weapon"
		if hero.weapon_data != null:
			weapon_str = "⚔ %s  ATK %d" % [hero.weapon_data.name, hero.eff_atk()]
		var pips: int = clampi(hero.run_card_count, 0, 3)
		l.text = "%s\n%s%s" % [weapon_str, "●".repeat(pips), "○".repeat(3 - pips)]

## Battle over (or HOME button): back to the meta layer.
func _on_back_home() -> void:
	Combat.stop()
	get_tree().change_scene_to_file("res://scenes/Home.tscn")

func _on_reset_pressed() -> void:
	_on_back_home()
