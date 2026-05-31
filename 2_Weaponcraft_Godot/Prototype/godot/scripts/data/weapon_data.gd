## WeaponData — P1a unitary weapon schema (STUB; under TDD construction).
class_name WeaponData
extends Resource

@export var base_atk: int = 0
@export var star_tier: int = 1

func get_atk() -> int:
	return base_atk
