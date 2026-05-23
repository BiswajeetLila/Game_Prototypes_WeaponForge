## EnemyData — design-time definition of an enemy archetype.
## Actual instance state (hp, weak, resist, frozen, debuffed) lives in
## a dictionary spawned by Combat at wave start.
class_name EnemyData
extends Resource

@export var id: StringName = &""
@export var name: String = ""
@export var sprite: Texture2D

## HP scales as hp_base + hp_per_wave * wave_number.
@export var hp_base: int = 15
@export var hp_per_wave: int = 8

## Damage per tick = dmg_base + floor(dmg_per_wave * wave_number).
@export var dmg_base: int = 4
@export var dmg_per_wave: float = 1.4
