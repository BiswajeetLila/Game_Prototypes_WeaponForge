## UltController — tracks squad Reaction Charge and Ult bar state.
## Autoload singleton. Full impl in Phase 4 step 8.
## Charge rule: every 3 reactions -> +1 Ult bar (max 3). Bars persist across waves.
extends Node

var bars: int = 0                ## current Ult bars (0-3)
var _reaction_count: int = 0     ## reactions since last bar fill

func _ready() -> void:
	var em := get_node_or_null("/root/ElementMediator")
	if em != null:
		em.reaction_triggered.connect(_on_reaction_triggered)

func reset() -> void:
	bars = 0
	_reaction_count = 0

## Called externally in tests; also connected to ElementMediator signal.
func on_reaction() -> void:
	_reaction_count += 1
	if _reaction_count >= 3:
		_reaction_count = 0
		bars = mini(bars + 1, 3)

func _on_reaction_triggered(_reaction_id: StringName, _enemy: Dictionary) -> void:
	on_reaction()

## Consume 1 bar (returns false if no bars available).
func consume_bar() -> bool:
	if bars <= 0:
		return false
	bars -= 1
	return true
