## Main — composition root for the ultra-MVP play scene.
##
## Lifecycle:
##   _ready
##     -> GameState autoload has already called new_session()
##     -> open_forge_moment for wave 1
##
##   ForgePanel emits wave_start_requested -> Combat.start_wave(wave)
##   GameState.wave_cleared -> next wave forge OR stage clear modal
##   GameState.stage_cleared -> ResultModal.open("clear")
##   GameState.hero_died    -> ResultModal.open("wipe")
##   ResultModal.restart_requested -> _on_reset_pressed (clean session)
extends Control

@onready var _forge: Control = %ForgePanel
@onready var _reset_btn: Button = %ResetBtn
@onready var _hud: Control = %Hud
@onready var _codex_modal: Control = %CodexModal
@onready var _result_modal: Control = %ResultModal

func _ready() -> void:
	_reset_btn.pressed.connect(_on_reset_pressed)
	_forge.wave_start_requested.connect(_on_wave_start_requested)
	_hud.codex_pressed.connect(_codex_modal.open)
	_result_modal.restart_requested.connect(_on_reset_pressed)
	GameState.wave_cleared.connect(_on_wave_cleared)
	GameState.stage_cleared.connect(_on_stage_cleared)
	GameState.hero_died.connect(_on_hero_died)
	_open_forge_moment()

func _open_forge_moment() -> void:
	Shop.refresh(true)
	_forge.refresh_forge_moment()

func _on_wave_start_requested() -> void:
	Combat.start_wave(GameState.wave)

func _on_wave_cleared(wave: int) -> void:
	if wave >= GameState.TOTAL_WAVES:
		return  ## stage_cleared signal fires too — handled there
	GameState.set_wave(wave + 1)
	_open_forge_moment()

func _on_stage_cleared() -> void:
	_result_modal.open(&"clear")

func _on_hero_died(_hero_id: StringName) -> void:
	_result_modal.open(&"wipe")

func _on_reset_pressed() -> void:
	Combat.stop()
	GameState.new_session()
	_open_forge_moment()
