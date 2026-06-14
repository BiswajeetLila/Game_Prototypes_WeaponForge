## FunctionData — design-time definition of a Function card.
## One resource per Function ID (FIRE, WATER, etc.). Loaded from data/functions/*.tres.
class_name FunctionData
extends Resource

@export var id: StringName = &""
@export var category: StringName = &""  ## "element" | "pattern" | "tactical"

## Active slot
@export var active_damage_tag: StringName = &""    ## tag emitted on hit (elements only)
@export var active_status_emit: StringName = &""   ## status applied to target on hit
@export var active_dmg_mult: float = 1.0           ## damage multiplier relative to hero base
@export var active_targeting: StringName = &"own_lane_closest"
##  own_lane_closest | any_lane_closest | cross_lane_spread | own_lane_line |
##  chain_arc | radial_5 | fan_3
@export var active_atk_speed: float = 1.0          ## attacks per tick
@export var active_heal_pct: float = 0.0           ## LEECH: heal self for X% of dmg dealt

## Modifier slot
@export var mod_dmg_bonus: float = 0.0             ## additive bonus to Active dmg
@export var mod_adds_tag: StringName = &""         ## secondary damage tag on Active hits
@export var mod_applies_status: StringName = &""   ## extra status on Active hit target

## Passive slot (runtime behaviour is resolved by element_mediator + combat_v2)
@export var passive_id: StringName = &""           ## key for passive lookup table

## Display / preview (decision-1: SHOW per-slot behavior + best-fit, never restrict).
@export_multiline var active_desc: String = ""
@export_multiline var mod_desc: String = ""
@export_multiline var passive_desc: String = ""
@export var best_fit: StringName = &""             ## PASSIVE | MODIFIER | ACTIVE (hint, not a gate)

## Per-slot behavior text by canonical socket index (0=PASSIVE,1=MODIFIER,2=ACTIVE).
func describe(slot_idx: int) -> String:
	match slot_idx:
		0: return passive_desc
		1: return mod_desc
		2: return active_desc
		_: return ""
