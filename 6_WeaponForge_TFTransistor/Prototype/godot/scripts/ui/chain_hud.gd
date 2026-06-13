## ChainHUD — reaction chain ×N counter shown at top of combat HUD.
## Subscribes to ElementMediator.reaction_triggered; resets on timer.
extends Control

const RESET_AFTER_SEC: float = 2.0

var _chain_count: int = 0
var _lbl: Label
var _reset_timer: Timer

func _ready() -> void:
	_build_ui()
	_connect_mediator()

func _build_ui() -> void:
	_lbl = Label.new()
	_lbl.name = "ChainLabel"
	_lbl.text = ""
	_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_lbl.add_theme_font_size_override(&"font_size", 22)
	add_child(_lbl)

	_reset_timer = Timer.new()
	_reset_timer.name = "ResetTimer"
	_reset_timer.one_shot = true
	_reset_timer.wait_time = RESET_AFTER_SEC
	_reset_timer.timeout.connect(_reset_chain)
	add_child(_reset_timer)

func _connect_mediator() -> void:
	var em := get_node_or_null("/root/ElementMediator")
	if em != null and em.has_signal("reaction_triggered"):
		em.reaction_triggered.connect(_on_reaction)

## Called by ElementMediator.reaction_triggered.
func _on_reaction(_reaction_id: StringName, _enemy: Dictionary) -> void:
	_chain_count += 1
	_lbl.text = "×%d" % _chain_count
	_reset_timer.stop()
	_reset_timer.start()

func _reset_chain() -> void:
	_chain_count = 0
	_lbl.text = ""

## Read-only — for tests.
func get_chain_count() -> int:
	return _chain_count
