## HeroState — runtime per-hero state. Created at session start from HeroData.
##
## Persistent across waves (per addendum 0.1.4): ult_gauge carries forward.
## Only ult_used resets per fight (combat.start_wave() does the reset).
##
## Reachable from GameState autoload via preload chain → type annotations on
## HeroData / Weapon are stripped to dodge cold-start global-class race.
class_name HeroState
extends RefCounted

const WeaponT = preload("res://scripts/data/weapon.gd")

var data = null            ## HeroData

var hp: int = 0
var max_hp: int = 0       ## recomputed from round(data.hp_base * level_mult) + weapon.get_hp_bonus()

## Persistent hero-level multiplier applied to innate base stats (HP + atk).
## Defaults to 1.0 so legacy callers (HeroStateT.new(data)) are unchanged.
var level_mult: float = 1.0
var is_dead: bool = false

var weapon = null         ## Weapon

## Persistent ult gauge 0..100. Carries across waves.
var ult_gauge: float = 0.0
## Resets to false each fight.
var ult_used: bool = false

## Inferno bookkeeping (addendum 0.1.7).
var last_target_name: StringName = &""
var burn_stack: int = 0

func _init(p_data, p_level_mult: float = 1.0) -> void:
	data = p_data
	level_mult = p_level_mult
	weapon = WeaponT.new()
	max_hp = _scaled_base_hp()
	hp = max_hp

## Innate HP after the level multiplier (no weapon bonus).
func _scaled_base_hp() -> int:
	return int(round(float(data.hp_base) * level_mult))

## Innate ATK after the level multiplier (no weapon bonus). Combat may read this
## in a later plan; today nothing calls it except tests.
func base_atk() -> int:
	return int(round(float(data.atk_base) * level_mult))

func refresh_max_hp() -> void:
	var bonus: int = weapon.get_hp_bonus() if weapon != null else 0
	var new_max: int = _scaled_base_hp() + bonus
	var delta: int = new_max - max_hp
	max_hp = new_max
	## Equipping +HP raises current HP by the same amount; unequipping clamps down.
	hp = clampi(hp + delta, 0, max_hp)

func reset_for_fight() -> void:
	ult_used = false
	burn_stack = 0
	last_target_name = &""

func clamp_hp() -> void:
	hp = clampi(hp, 0, max_hp)
	if hp <= 0:
		is_dead = true
