## Main — composition root for the ultra-MVP play scene.
##
## Lifecycle:
##   _ready
##     -> GameState autoload has already called new_session()
##     -> open_forge_moment for wave 1
##
##   ForgePanel emits wave_start_requested -> Combat.start_wave(wave)
##   GameState.wave_cleared -> banner + per-hero award_wave_xp
##                             then next forge OR stage clear modal
##   GameState.stage_cleared -> ResultModal.open("clear")
##   GameState.squad_wiped   -> ResultModal.open("wipe")
##   GameState.hero_died     -> per-individual death banner (informational)
##   ResultModal.restart_requested -> _on_reset_pressed
##
##   Notifications layer renders transient banners (wave start / clear /
##   wipe / stage clear). ScreenFlash overlay tints purple on ult fire.
extends Control

@onready var _forge: Control = %ForgePanel
@onready var _squad_bar: Control = %SquadBar
@onready var _reset_btn: Button = %ResetBtn
@onready var _hud: Control = %Hud
@onready var _codex_modal: Control = %CodexModal
@onready var _result_modal: Control = %ResultModal
@onready var _reforge_retry_modal: Control = %ReforgeRetryModal
@onready var _notifications: Control = %Notifications

func _ready() -> void:
	_reset_btn.pressed.connect(_on_reset_pressed)
	_forge.wave_start_requested.connect(_on_wave_start_requested)
	_hud.codex_pressed.connect(_codex_modal.open)
	_result_modal.restart_requested.connect(_on_reset_pressed)
	_reforge_retry_modal.retry_requested.connect(_on_retry_pressed)
	_reforge_retry_modal.give_up_requested.connect(_on_give_up_pressed)
	GameState.wave_cleared.connect(_on_wave_cleared)
	GameState.stage_cleared.connect(_on_stage_cleared)
	GameState.squad_wiped.connect(_on_squad_wiped)
	GameState.hero_died.connect(_on_hero_died)
	Combat.boss_telegraph.connect(_on_boss_telegraph)
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
	GameState.award_wave_xp()
	var reward: int = 5 + wave * 2
	_notifications.show_card(
		"✓ WAVE %d CLEAR" % wave,
		"+ 🪙 %d" % reward,
		Color(0.6, 1, 0.7),
		1.2)
	if JuiceConfig.JUICE_ENABLED:
		ScreenShake.kick(JuiceConfig.WAVE_CLEAR.shake_amp, JuiceConfig.WAVE_CLEAR.shake_dur)

	if wave >= GameState.TOTAL_WAVES:
		return
	GameState.set_wave(wave + 1)
	_open_forge_moment()

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

## Stage D — Reforge & Retry path. Revive squad, leave inventory + gold +
## wave untouched, reopen the forge for the same boss wave.
func _on_retry_pressed() -> void:
	Combat.stop()
	GameState.revive_squad_for_retry()
	_open_forge_moment()

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

func _on_reset_pressed() -> void:
	Combat.stop()
	get_tree().change_scene_to_file("res://scenes/Home.tscn")
