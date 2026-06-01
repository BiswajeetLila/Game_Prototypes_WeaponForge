## SkillCardData — Forge Draft card schema (P1a).
##
## Forge Draft (spec §10): after each wave the player drafts 1 of 3 skill cards
## (5 on boss waves). Each card is TAGGED to a specific hero and modifies one of
## their abilities / weapons / runes. No inventory — unpicked cards vanish.
##
## Four card types (spec §10 authoring scale):
##   ability — modifies a weapon's named ability branch (~60 cards)
##   hero    — flat hero stat-buff                      (~35 cards)
##   weapon  — weapon-tier modifier                     (~45 cards)
##   rune    — element / rune intensity                 (~12-15 cards)
##
## Pure data Resource (cf. recipe_data.gd). The draft flow (P1c) consumes it; the
## catalog loader uses is_valid() the way GameState skips recipes missing an id.
## Type annotations kept light to dodge the cold-start global-class race (see weapon.gd).
class_name SkillCardData
extends Resource

const TYPE_ABILITY: StringName = &"ability"
const TYPE_HERO: StringName = &"hero"
const TYPE_WEAPON: StringName = &"weapon"
const TYPE_RUNE: StringName = &"rune"
const CARD_TYPES: Array = [TYPE_HERO, TYPE_WEAPON, TYPE_ABILITY, TYPE_RUNE]

## ---------- Identity (config) ----------
@export var id: StringName = &""
@export var name: String = ""
@export var desc: String = ""

## One of CARD_TYPES.
@export var card_type: StringName = &""
## The hero this card is tagged to (spec §10: every card targets a specific hero).
@export var hero_id: StringName = &""
## 0=common 1=rare 2=epic — stacking variants raise rarity (spec §10 authoring scale).
@export var rarity_idx: int = 0
## Type-specific payload (cf. RecipeData.bonus). Keys interpreted by the draft flow.
@export var effect: Dictionary = {}

## ---------- Queries ----------

func is_valid_type() -> bool:
	return card_type in CARD_TYPES

## A card is usable iff it has an id, is tagged to a hero, and has a known type.
## Mirrors GameState catalog validation (skip resources missing required fields).
func is_valid() -> bool:
	return id != &"" and hero_id != &"" and is_valid_type()

func applies_to(query_hero_id: StringName) -> bool:
	return hero_id == query_hero_id
