## RNG — thin wrapper over Godot's built-in randi/randf.
##
## Currently unseeded (matches prototype's Math.random()). Wrapping it here so
## future seeded replays / deterministic tests are a single-file change.
##
## All methods use distinct names to avoid shadowing Godot's @GlobalScope
## randi/randf (which would cause recursion if shadowed).
extends Node

func _ready() -> void:
	randomize()

## Float in [0.0, 1.0).
func roll() -> float:
	return randf()

## Int in [0, n). Caller responsible for n > 0.
func roll_int(n: int) -> int:
	return randi() % maxi(1, n)

## Random element from a non-empty Array. Returns null on empty.
func pick(arr: Array):
	if arr.is_empty():
		return null
	return arr[randi() % arr.size()]

## True/false with given probability in [0.0, 1.0].
func chance(p: float) -> bool:
	return randf() < p
