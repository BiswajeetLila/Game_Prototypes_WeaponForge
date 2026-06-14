## ReactionData — design-time definition of a status reaction.
## One resource per reaction. Loaded from data/reactions/*.tres.
class_name ReactionData
extends Resource

@export var id: StringName = &""
@export var trigger_tag: StringName = &""     ## incoming damage tag (FIRE, LIGHTNING…)
@export var trigger_status: StringName = &""  ## existing enemy status that reacts

@export var dmg_mult: float = 1.0
@export var splash: StringName = &"none"
##   none | cross_lane | own_lane_radius
@export var splash_filter: StringName = &"none"
##   none | wet_only  (Electrocute arc only hits Wet enemies)

## Statuses removed from the origin enemy on reaction (PackedStringArray)
@export var cleanse_origin: PackedStringArray = []
## Statuses applied to the ORIGIN enemy on reaction (Frostbite→Chilled, Quench→Wet,
## Freeze Solid→Frozen, Stonesmith→Shocked, Mudslide→Chilled-slow). Applied AFTER cleanse.
@export var apply_origin: PackedStringArray = []
## Duration (ticks) used when applying apply_origin statuses.
@export var apply_origin_duration: int = 2
## Statuses applied to splashed/arced enemies
@export var apply_splashed: PackedStringArray = []

## Consume 1 Cracked stack on the origin (Magma Burst, Mudslide-W, Stonesmith).
## Note: this is the EXPLICIT Cracked-triggered consumption — distinct from the
## "never consumed as passenger" rule (a higher-priority status reacting leaves Cracked alone).
@export var consume_cracked: bool = false
## Push the origin enemy back 1 unit (Avalanche). Honours lane_state knockback immunity.
## (Capacitor's "refresh Shocked at 2× duration" is modelled via apply_origin=[Shocked] +
##  apply_origin_duration=4, since apply_status always refreshes duration.)
@export var knockback: bool = false

@export var vfx_hook: StringName = &""
@export var audio_hook: StringName = &""
