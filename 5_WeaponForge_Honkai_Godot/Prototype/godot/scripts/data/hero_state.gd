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
var max_hp: int = 0       ## recomputed from data.hp_base + weapon.get_hp_bonus()
var is_dead: bool = false

var weapon = null         ## Weapon (legacy 3-socket aggregator — recipes/shop/merge still ride it)

## Pulled WeaponData (bridge #1). Null = pure legacy behavior. When equipped it
## REPLACES the socket weapon's combat contribution (atk/crit/ult_rate/hp/tags)
## under STAT_SOURCE_AUTO — never stacked on top (additive double-stacking would
## poison playtest balance signal; ADDITIVE exists only as an explicit debug mode).
var weapon_data = null    ## WeaponData

## Persistent ult gauge 0..100. Carries across waves.
var ult_gauge: float = 0.0
## Resets to false each fight.
var ult_used: bool = false

## Inferno bookkeeping (addendum 0.1.7).
var last_target_name: StringName = &""
var burn_stack: int = 0

## Run-scoped Forge Draft mods (R1). Wittle-style perk picks stack here ON TOP of
## the equipped weapon's contribution and die with the run (heroes are recreated
## by GameState.new_session()). Keys mirror SkillCardData stat-card effects.
var run_mods: Dictionary = {}
## Cards applied to this hero this run — drives the upgrade pips under the portrait.
var run_card_count: int = 0

func _init(p_data) -> void:
	data = p_data
	weapon = WeaponT.new()
	max_hp = data.hp_base
	hp = max_hp
	run_mods = {&"atk_flat": 0, &"atk_pct": 0.0, &"crit": 0, &"ult_rate": 0, &"hp_flat": 0}

## Apply one draft-card stat effect. hp_flat raises MAX under the clamp rule —
## a draft buff never heals and never damages, on either weapon path.
func apply_run_mod(key: StringName, value) -> void:
	run_mods[key] = run_mods.get(key, 0) + value
	if key == &"hp_flat":
		max_hp = data.hp_base + eff_hp_bonus()
		hp = clampi(hp, 0, max_hp)

func refresh_max_hp() -> void:
	var new_max: int = data.hp_base + eff_hp_bonus()
	if weapon_data != null:
		## weapon_data path (entry contract #2): recompute max, CLAMP current,
		## NEVER refill — blocks the equip-swap free-heal exploit.
		max_hp = new_max
		hp = clampi(hp, 0, max_hp)
	else:
		## Legacy socket path keeps its deliberate historical behavior:
		## equipping +HP raises current HP by the same amount; unequipping clamps.
		var delta: int = new_max - max_hp
		max_hp = new_max
		hp = clampi(hp + delta, 0, max_hp)

## Equip/unequip a pulled WeaponData (null = unequip). HP transition always uses
## the clamp rule in BOTH directions: no refill on equip, no delta-damage on unequip.
func equip_weapon_data(wd) -> void:
	weapon_data = wd
	max_hp = data.hp_base + eff_hp_bonus()
	hp = clampi(hp, 0, max_hp)

## ---------- Effective combat stats (the bridge combat.gd reads) ----------
## Source selection per GameState.combat_stat_source:
##   AUTO        -> weapon_data if equipped, else legacy sockets (replacement)
##   LEGACY_ONLY / PULLED_ONLY -> forced single source (playtest signal isolation)
##   ADDITIVE    -> both summed (explicitly experimental)

func has_weapon() -> bool:
	return weapon != null or weapon_data != null

func eff_atk() -> int:
	var base: int = _pick(weapon.get_atk() if weapon != null else 0,
		weapon_data.get_atk() if weapon_data != null else 0)
	return int(floor(float(base) * (1.0 + float(run_mods.get(&"atk_pct", 0.0))))) \
		+ int(run_mods.get(&"atk_flat", 0))

func eff_crit() -> int:
	return _pick(weapon.get_crit() if weapon != null else 0,
		weapon_data.get_crit() if weapon_data != null else 0) + int(run_mods.get(&"crit", 0))

func eff_ult_rate() -> int:
	return _pick(weapon.get_ult_rate() if weapon != null else 0,
		weapon_data.get_ult_rate() if weapon_data != null else 0) + int(run_mods.get(&"ult_rate", 0))

func eff_hp_bonus() -> int:
	return _pick(weapon.get_hp_bonus() if weapon != null else 0,
		weapon_data.get_hp_bonus() if weapon_data != null else 0) + int(run_mods.get(&"hp_flat", 0))

func eff_tags() -> Array:
	return _pick(weapon.get_all_tags() if weapon != null else [],
		weapon_data.get_all_tags() if weapon_data != null else [])

## Selector shared by all eff_* reads. `+` sums ints and concatenates tag Arrays.
func _pick(legacy_val, pulled_val):
	match GameState.combat_stat_source:
		GameState.STAT_SOURCE_LEGACY_ONLY:
			return legacy_val
		GameState.STAT_SOURCE_PULLED_ONLY:
			return pulled_val
		GameState.STAT_SOURCE_ADDITIVE:
			return legacy_val + pulled_val
		_:
			return pulled_val if weapon_data != null else legacy_val

func reset_for_fight() -> void:
	ult_used = false
	burn_stack = 0
	last_target_name = &""

func clamp_hp() -> void:
	hp = clampi(hp, 0, max_hp)
	if hp <= 0:
		is_dead = true
