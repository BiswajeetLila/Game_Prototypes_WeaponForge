## PartData — design-time definition of a single part.
## One .tres file per part under data/parts/. Loaded by Shop + Merge.
class_name PartData
extends Resource

## Stable string id used as merge key + shop pool key. e.g. "h_iron_edge".
@export var id: StringName = &""

## Slot the part occupies: "head", "hilt", or "rune".
@export var slot: StringName = &"head"

## Class affinity: "warrior", "mage", "rogue", or "universal".
@export var cls: StringName = &"universal"

## Display name surfaced in UI tooltips + shop cards.
@export var name: String = ""

## Hover-tooltip description (per addendum 0.1.5).
@export var desc: String = ""

## Sprite for shop card + inventory tile + anvil slot.
@export var icon: Texture2D

## Rarity: "common", "rare", "epic", "legendary". Same-rarity-only merge.
@export var rarity: StringName = &"common"

## Shop cost in gold. Default 4 per forge-ux-balance-w10; explicit overrides
## in individual .tres files take precedence.
@export var cost: int = 4

## Flat stats contributed when equipped at L1. Level multiplier scales these.
@export var atk: int = 0
@export var hp: int = 0
@export var crit: int = 0       ## percent, 0-100
@export var ult_rate: int = 0   ## percent, fills ult faster

## Explicit element tag: "fire", "ice", "pierce", or "" for none.
## Derived tags ("crit", "charge") are computed from stats, not stored here.
@export var tag: StringName = &""

## Consumable items (e.g. heal potion) skip the Merge / inventory pipeline.
## Shop.buy short-circuits to a one-shot effect handler when this is true.
@export var is_consumable: bool = false
