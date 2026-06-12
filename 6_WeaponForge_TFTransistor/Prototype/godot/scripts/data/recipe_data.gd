## RecipeData — design-time definition of a named recipe (Steamburst, Inferno, etc).
## Patterns is an Array of tag arrays. ANY pattern matching triggers the recipe.
## Example Quickdraw patterns: [["charge", "fire"], ["charge", "ice"], ["charge", "pierce"]].
##
## Bonus dict keys (per addendum 0.1.7):
##   splash         : float, fraction of dmg dealt to other enemies on hit (Steamburst)
##   stack_burn     : float, per-stack damage bonus on consecutive same-target hits (Inferno)
##   stack_cap      : int,   max stacks for stack_burn (Inferno)
##   freeze_chance  : float, chance to freeze on hit (Permafrost)
##   multi_hit      : float, fraction of dmg dealt to a second random enemy (Skewer)
##   crit_bonus     : int,   flat crit% added to weapon crit (Razor Wind)
##   crit_splash    : float, fraction of crit-dmg to splash to adjacent (Hellfire)
##   debuff         : float, fraction-reduction of target's next attack (Frostbite)
##   ult_boost      : float, fraction-increase of ult fill rate (Quickdraw)
##
## Multi-recipe aggregation rules (per addendum 0.1.7):
##   splash/multi_hit/freeze_chance/crit_splash/debuff/stack_burn -> Math.max() across active
##   crit_bonus/ult_boost -> summed
class_name RecipeData
extends Resource

@export var id: StringName = &""
@export var name: String = ""
@export var desc: String = ""
@export var icon: Texture2D

## Array of Array[StringName]. Each inner array is one valid tag combo.
@export var patterns: Array = []

## Dictionary { key: float|int } per the keys documented above.
@export var bonus: Dictionary = {}
