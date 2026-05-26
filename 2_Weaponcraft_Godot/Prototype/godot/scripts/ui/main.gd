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
@onready var _notifications: Control = %Notifications

func _ready() -> void:
	_reset_btn.pressed.connect(_on_reset_pressed)
	_forge.wave_start_requested.connect(_on_wave_start_requested)
	_hud.codex_pressed.connect(_codex_modal.open)
	_result_modal.restart_requested.connect(_on_reset_pressed)
	GameState.wave_cleared.connect(_on_wave_cleared)
	GameState.stage_cleared.connect(_on_stage_cleared)
	GameState.squad_wiped.connect(_on_squad_wiped)
	GameState.hero_died.connect(_on_hero_died)
	_squad_bar.hero_selected.connect(_forge.set_current_hero)
	ScreenShake.register_target(self)
	_open_forge_moment()

func _open_forge_moment() -> void:
	Shop.refresh(true)
	_forge.refresh_forge_moment()

func _on_wave_start_requested() -> void:
	_notifications.show_banner("⚔ WAVE %d" % GameState.wave, Color(1, 0.9, 0.6), 1.0)
	Combat.start_wave(GameState.wave)

func _on_wave_cleared(wave: int) -> void:
	var reward: int = 5 + wave * 2
	_notifications.show_card(
		"✓ WAVE %d CLEAR" % wave,
		"+ 🪙 %d" % reward,
		Color(0.6, 1, 0.7),
		1.2)
	if JuiceConfig.JUICE_ENABLED:
		ScreenShake.kick(JuiceConfig.WAVE_CLEAR.shake_amp, JuiceConfig.WAVE_CLEAR.shake_dur)

	## Per-hero unlocks: Elara at ELARA_UNLOCK_WAVE clear, Vex at VEX_UNLOCK_WAVE.
	## Card fires 0.7s later so it doesn't pile under the wave-clear card.
	match wave:
		ELARA_UNLOCK_WAVE:
			GameState.unlock_hero(&"elara")
			_show_unlock_card_delayed(&"elara", Color(0.85, 0.55, 1))
		VEX_UNLOCK_WAVE:
			GameState.unlock_hero(&"vex")
			_show_unlock_card_delayed(&"vex", Color(0.55, 0.85, 1))

	if wave >= GameState.TOTAL_WAVES:
		return
	GameState.set_wave(wave + 1)
	_open_forge_moment()

## Hero-unlock card with name + class + ult description, then auto-focuses
## the ForgePanel to the new hero so the player can immediately equip them.
## Per user feedback: 'have their card come up with a short description ...
## and then focus to that cards char so that i can put items on her.'
const UNLOCK_PRE_DELAY: float = 0.7   ## let wave-clear card settle first
const UNLOCK_CARD_DUR:  float = 1.8   ## card lifetime
const UNLOCK_POST_GAP:  float = 0.15  ## small breath after fade before focus shift

func _show_unlock_card_delayed(hero_id: StringName, accent: Color) -> void:
	await get_tree().create_timer(UNLOCK_PRE_DELAY).timeout
	var data = GameState.heroes_by_id.get(hero_id)
	if data == null:
		return
	var class_str: String = String(data.cls).to_upper()
	var subtitle: String = "%s  •  %s\n%s" % [class_str, data.ult_name, data.ult_desc]
	_notifications.show_card("✨ %s JOINS" % String(data.name).to_upper(), subtitle, accent, UNLOCK_CARD_DUR)
	## Wait card lifetime + post-gap, then switch ForgePanel to this hero.
	await get_tree().create_timer(UNLOCK_CARD_DUR + UNLOCK_POST_GAP).timeout
	if _forge != null and _forge.has_method(&"set_current_hero"):
		_forge.set_current_hero(hero_id)

func _on_stage_cleared() -> void:
	_notifications.show_banner("🏆 STAGE CLEAR", Color(1, 0.85, 0.2), 1.8)
	_result_modal.open(&"clear")

func _on_squad_wiped() -> void:
	_notifications.show_banner("💀 WIPE", Color(1, 0.3, 0.3), 1.6)
	_result_modal.open(&"wipe")

func _on_hero_died(hero_id: StringName) -> void:
	## Per-individual death — informational only. Squad keeps fighting as long
	## as any_alive(); the stage-failure modal opens via _on_squad_wiped above.
	var hero = GameState.get_hero(hero_id)
	if hero == null:
		return
	_notifications.show_banner("💔 %s FALLS" % hero.data.name.to_upper(), Color(1, 0.55, 0.55), 1.0)

func _on_reset_pressed() -> void:
	Combat.stop()
	GameState.new_session()
	_open_forge_moment()
