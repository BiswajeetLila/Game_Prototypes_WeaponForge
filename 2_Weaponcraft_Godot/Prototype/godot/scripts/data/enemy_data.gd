## EnemyData — design-time definition of an enemy archetype.
## Actual instance state (hp, weak, resist, frozen, debuffed) lives in
## a dictionary spawned by Combat at wave start.
class_name EnemyData
extends Resource

@export var id: StringName = &""
@export var name: String = ""
@export var sprite: Texture2D

## HP scales as hp_base + hp_per_wave * wave_number (non-boss path).
## Bosses use hp_base directly (hp_per_wave 0) since boss HP is hand-tuned.
@export var hp_base: int = 15
@export var hp_per_wave: int = 8

## Damage per tick = dmg_base + floor(dmg_per_wave * wave_number) for non-boss
## enemies. Bosses use atk_override.
@export var dmg_base: int = 4
@export var dmg_per_wave: float = 1.4

## Stage D — boss support.
## When true, _spawn_enemies treats this id as the sole spawn at the matching
## boss wave (5/10/15). Combat.step dispatches tick hooks by id.
@export var is_boss: bool = false

## Boss ATK is hand-tuned. When > 0, overrides the wave-scaled enemy atk
## formula. Non-boss enemies leave this at 0 and use Combat.base_atk(wave).
@export var atk_override: int = 0

## Boss weak / resist tags are fixed (no per-spawn random roll). Non-boss
## enemies leave these blank and Combat assigns random tags per addendum 0.1.5.
@export var weak_tag: StringName = &""
@export var resist_tag: StringName = &""
