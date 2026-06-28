## HUD — top bar with gold + wave pill + codex button.
##
## Subscribes to GameState signals; refreshes labels reactively. No polling.
extends Control

@onready var _gold_label: Label = %GoldLabel
@onready var _wave_label: Label = %WaveLabel
@onready var _codex_btn: Button = %CodexBtn

signal codex_pressed

func _ready() -> void:
	GameState.gold_changed.connect(_on_gold_changed)
	GameState.wave_changed.connect(_on_wave_changed)
	GameState.codex_badge_changed.connect(_on_codex_badge_changed)
	_codex_btn.pressed.connect(func(): emit_signal(&"codex_pressed"))
	_refresh_all()

func _refresh_all() -> void:
	_on_gold_changed(GameState.gold)
	_on_wave_changed(GameState.wave)
	_on_codex_badge_changed(GameState.discovered_recipes.size(), GameState.recipe_ids.size())

func _on_gold_changed(new_gold: int) -> void:
	_gold_label.text = "🪙 %d" % new_gold

func _on_wave_changed(new_wave: int) -> void:
	_wave_label.text = "WAVE %d/%d" % [new_wave, GameState.TOTAL_WAVES]

func _on_codex_badge_changed(discovered: int, total: int) -> void:
	_codex_btn.text = "CODEX %d/%d" % [discovered, total]
