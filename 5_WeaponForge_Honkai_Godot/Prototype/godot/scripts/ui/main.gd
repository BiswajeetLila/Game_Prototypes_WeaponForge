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

## A run is ONE stage: 4 waves + the boss on wave 5. Boss kill ends the run
## (victory -> home). Stage rotation (golem/lich, scaling) comes next pass.
const RUN_FINAL_WAVE: int = 5

var _draft_modal: ColorRect = null

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
	_draft_modal = DraftModalScript.new()
	add_child(_draft_modal)
	_draft_modal.card_picked.connect(_on_draft_picked)
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

	## THE LOOP: run ends at the boss (Wittle stage shape). Kill the boss ->
	## victory -> home. Otherwise: Forge Draft (3 cards), pick -> next wave auto.
	if wave >= RUN_FINAL_WAVE:
		AccountState.award_victory()
		_notifications.show_banner("🏆 BOSS DOWN  +%d💎" % AccountState.RUN_VICTORY_BONUS,
			Color(1, 0.85, 0.2), 1.6)
		_result_modal.open(&"clear")
		return
	_draft_modal.open(ForgeDraft.deal(3))

func _on_draft_picked(card) -> void:
	ForgeDraft.apply(card)
	var next_wave: int = GameState.wave + 1
	GameState.set_wave(next_wave)
	_begin_wave(next_wave)

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

## Battle over (or HOME button): back to the meta layer.
func _on_back_home() -> void:
	Combat.stop()
	get_tree().change_scene_to_file("res://scenes/Home.tscn")

func _on_reset_pressed() -> void:
	_on_back_home()
