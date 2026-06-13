## StatusData — design-time definition of a status effect.
## One resource per status (Burning, Wet, etc.). Loaded from data/statuses/*.tres.
class_name StatusData
extends Resource

@export var id: StringName = &""
@export var max_stacks: int = 1              ## 1 = refresh-only; Cracked = 3
@export var base_duration: int = 3          ## ticks at standard application

## Per-tick enemy effects (applied by combat_v2 in status-decay phase)
@export var hp_dmg_per_tick: int = 0        ## Burning=2, Shocked=1
@export var speed_mult: float = 1.0         ## Chilled=0.5, Frozen=0.0
@export var dmg_amp_per_stack: float = 0.0  ## Cracked=0.15 per stack
@export var skip_attack_chance: float = 0.0 ## Shocked=0.10 (10%)
