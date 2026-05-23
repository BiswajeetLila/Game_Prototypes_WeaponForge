## Recipes — pure-function recipe engine. No state.
##
## Mirrors prototype's tag/recipe machinery (BASE-A1 0.1.7 + 0.1.9):
##   weapon_tag_counts(weapon)        -> {tag: count} including derived crit/charge
##   pattern_matches(pattern, counts) -> bool
##   get_active_recipes(weapon)       -> Array[StringName] of triggered recipe ids
##   get_recipe_bonuses(hero_state)   -> Dictionary of aggregated bonus values
##   check_hero_for_discoveries(hero) -> queues newly-active recipes for the
##                                       first-discovery overlay
##
## NOTE: stub for build step 1-2 (autoload registration). Implementation
##       fills in during task #14 (build step 9-10).
##
## All references to Weapon / HeroState are untyped here because this script is
## an autoload — global class_name resolution is unreliable during cold-start
## parsing. Implementations will use duck typing on the passed objects.
extends Node

func weapon_tag_counts(_weapon) -> Dictionary:
	return {}

func pattern_matches(_pattern: Array, _counts: Dictionary) -> bool:
	return false

func get_active_recipes(_weapon) -> Array:
	return []

func get_recipe_bonuses(_hero) -> Dictionary:
	return {}

func check_hero_for_discoveries(_hero) -> void:
	pass
