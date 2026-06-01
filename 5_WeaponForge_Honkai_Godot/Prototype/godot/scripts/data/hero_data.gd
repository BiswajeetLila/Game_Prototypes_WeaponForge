## HeroData — design-time definition of a hero.
## One .tres per hero under data/heroes/. Ultra-MVP: only Bran.
class_name HeroData
extends Resource

@export var id: StringName = &""
@export var name: String = ""
@export var cls: StringName = &"warrior"   ## "warrior" | "mage" | "rogue"
@export var portrait: Texture2D

@export var hp_base: int = 80
@export var atk_base: int = 6

@export var ult_name: String = "Whirlwind"
@export var ult_desc: String = "AoE all alive enemies for atk * 3.5"
@export var ult_atk_multiplier: float = 3.5

## Dispatch key for Combat.fire_ult(). "whirlwind" | "meteor" | "shadowstep".
## Empty defaults to whirlwind in the match block.
@export var ult_key: StringName = &"whirlwind"
