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

@onready var _forge: Control = %ForgePanel
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
	_open_forge_moment()

func _open_forge_moment() -> void:
	Shop.refresh(true)
	_forge.refresh_forge_moment()

func _on_wave_start_requested() -> void:
	_notifications.show_banner("⚔ WAVE %d" % GameState.wave, Color(1, 0.9, 0.6), 1.0)
	Combat.start_wave(GameState.wave)

func _on_wave_cleared(wave: int) -> void:
	var reward: int = 5 + wave * 2
	_notifications.show_banner("✓ WAVE %d CLEAR  +🪙%d" % [wave, reward], Color(0.6, 1, 0.7), 1.3)

	## Per-hero unlocks: wave 2 -> Elara (mage), wave 4 -> Vex (rogue).
	## Banner fires 0.7s later so it doesn't pile under the wave-clear banner.
	match wave:
		2:
			GameState.unlock_hero(&"elara")
			_show_unlock_banner_delayed(&"elara", "✨ ELARA JOINS — MAGE", Color(0.85, 0.55, 1))
		4:
			GameState.unlock_hero(&"vex")
			_show_unlock_banner_delayed(&"vex", "✨ VEX JOINS — ROGUE", Color(0.55, 0.85, 1))

	if wave >= GameState.TOTAL_WAVES:
		return
	GameState.set_wave(wave + 1)
	_open_forge_moment()

func _show_unlock_banner_delayed(_hero_id: StringName, text: String, color: Color) -> void:
	await get_tree().create_timer(0.7).timeout
	_notifications.show_banner(text, color, 1.6)

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
