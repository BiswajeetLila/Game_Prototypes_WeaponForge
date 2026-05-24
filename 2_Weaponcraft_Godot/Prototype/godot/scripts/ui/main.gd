## Main — composition root for the ultra-MVP play scene.
##
## Lifecycle:
##   _ready
##     -> new_session (handled by GameState autoload)
##     -> open_forge_moment for wave 1
##
##   ForgePanel emits wave_start_requested when the player taps Start Wave.
##   Main calls Combat.start_wave(GameState.wave).
##
##   Combat emits wave_cleared (via GameState) when all enemies die. Main
##   either opens the next forge moment OR shows the Stage Clear modal
##   (modal lives in UI Chunk 4 — for now, just open the next forge moment
##   or print a console line).
##
##   Combat emits hero_died on wipe. UI Chunk 4 adds the Wipe modal; for now
##   Main resets the session so the player can keep poking the build.
extends Control

@onready var _forge: Control = %ForgePanel
@onready var _reset_btn: Button = %ResetBtn

func _ready() -> void:
	_reset_btn.pressed.connect(_on_reset_pressed)
	_forge.wave_start_requested.connect(_on_wave_start_requested)
	GameState.wave_cleared.connect(_on_wave_cleared)
	GameState.stage_cleared.connect(_on_stage_cleared)
	GameState.hero_died.connect(_on_hero_died)
	_open_forge_moment()

func _open_forge_moment() -> void:
	## Free roll the shop for this wave's forge moment.
	_forge.refresh_forge_moment()

func _on_wave_start_requested() -> void:
	Combat.start_wave(GameState.wave)

func _on_wave_cleared(wave: int) -> void:
	print("[Main] wave %d cleared" % wave)
	if wave >= GameState.TOTAL_WAVES:
		return  ## stage_cleared signal will fire too — handled there
	GameState.set_wave(wave + 1)
	_open_forge_moment()

func _on_stage_cleared() -> void:
	print("[Main] STAGE CLEARED — UI Chunk 4 will add the modal")

func _on_hero_died(_hero_id: StringName) -> void:
	print("[Main] WIPE — UI Chunk 4 will add the modal")

func _on_reset_pressed() -> void:
	Combat.stop()
	GameState.new_session()
	_open_forge_moment()
