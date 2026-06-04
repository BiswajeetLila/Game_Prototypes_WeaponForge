## ShardData — a Forge Shard: the consumable rarity-forge fuel dropped by gacha
## pulls (2 per pull). Each shard carries its OWN rarity (Common..Legendary); a
## bigger-rarity shard pushes the weapon's rarity bar further per the SHARD_INC
## table in WeaponData.apply_forge_shard.
##
## v1: `element` is stored but INERT — reserved for the deferred element-shift
## infusion (queue item #2). Types kept light to dodge the cold-start global-class
## race noted in weapon_data.gd / hero_state.gd.
class_name ShardData
extends Resource

const MAX_RARITY_IDX: int = 4   ## 0=common 1=rare 2=epic 3=legendary 4=mythic

@export var id: StringName = &"forge_shard"
@export var rarity_idx: int = 0        ## the shard's own rarity tier
@export var element: StringName = &""  ## INERT in v1 (deferred element-shift)

## A shard is valid iff its rarity sits on the 0..4 ladder. Catalog/drop minting
## and save-load both gate on this.
func is_valid() -> bool:
	return rarity_idx >= 0 and rarity_idx <= MAX_RARITY_IDX
