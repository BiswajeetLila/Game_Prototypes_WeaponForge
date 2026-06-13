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

## Statuses removed from the origin enemy on reaction (comma-sep strings as PackedStringArray)
@export var cleanse_origin: PackedStringArray = []
## Statuses applied to splashed/arced enemies
@export var apply_splashed: PackedStringArray = []

@export var vfx_hook: StringName = &""
@export var audio_hook: StringName = &""
