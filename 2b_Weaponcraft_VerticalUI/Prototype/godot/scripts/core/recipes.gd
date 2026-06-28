## Recipes — pure-function recipe engine. No state.
##
## Mirrors prototype's tag/recipe machinery (BASE-A1 0.1.7 + 0.1.9).
##
## Public API:
##   weapon_tag_counts(weapon)              -> Dictionary { tag: count }
##                                              Counts explicit tags (fire/ice/pierce
##                                              from PartData.tag) + derived tags
##                                              (crit if any crit%, charge if any
##                                              ult_rate%).
##
##   pattern_matches(pattern, counts)       -> bool
##                                              True if every tag in `pattern` is
##                                              present in `counts` with at least
##                                              the multiplicity required (a pattern
##                                              ["fire","fire"] needs counts.fire>=2).
##
##   get_active_recipes(weapon)             -> Array[StringName]
##                                              Recipe ids whose ANY pattern matches.
##
##   get_recipe_bonuses(hero)               -> Dictionary
##                                              Aggregated bonus dict ready for combat
##                                              to apply. Per addendum 0.1.7:
##                                                splash, multi_hit, freeze_chance,
##                                                crit_splash, debuff, stack_burn,
##                                                stack_cap          -> Math.max() across
##                                                crit_bonus, ult_boost -> summed
##
##   check_hero_for_discoveries(hero)       -> void
##                                              Diff hero.weapon's active recipes
##                                              against GameState.discovered_recipes;
##                                              push any new ones via
##                                              GameState.mark_discovered (which
##                                              handles the pending_discoveries queue
##                                              + signals).
##
## All references to Weapon / HeroState are untyped because this script is an
## autoload — global class_name resolution is unreliable during cold-start parsing.
## Duck-typed on passed objects.
extends Node

## Bonus keys aggregated with max() (per addendum 0.1.7 rules).
const _MAX_KEYS: Array = [
	&"splash", &"multi_hit", &"freeze_chance",
	&"crit_splash", &"debuff", &"stack_burn", &"stack_cap",
]
## Bonus keys aggregated with sum().
const _SUM_KEYS: Array = [&"crit_bonus", &"ult_boost"]

## ---------- Tag counting ----------

func weapon_tag_counts(weapon) -> Dictionary:
	var counts: Dictionary = {}
	if weapon == null:
		return counts
	for tag in weapon.get_all_tags():
		counts[tag] = int(counts.get(tag, 0)) + 1
	return counts

## ---------- Pattern matching ----------

func pattern_matches(pattern: Array, counts: Dictionary) -> bool:
	## A pattern is a list of required tags (with repeats meaning required
	## multiplicity). Build the required-multiplicity dict and check counts.
	if pattern.is_empty():
		return false
	var required: Dictionary = {}
	for tag in pattern:
		required[tag] = int(required.get(tag, 0)) + 1
	for tag in required:
		if int(counts.get(tag, 0)) < int(required[tag]):
			return false
	return true

## ---------- Active recipes ----------

func get_active_recipes(weapon) -> Array:
	var out: Array = []
	if weapon == null:
		return out
	var counts: Dictionary = weapon_tag_counts(weapon)
	for recipe_id in GameState.recipe_ids:
		var rec = GameState.get_recipe_def(recipe_id)
		if rec == null:
			continue
		for pattern in rec.patterns:
			if pattern_matches(pattern, counts):
				out.append(recipe_id)
				break  ## ANY pattern triggers — stop checking remaining patterns for this recipe
	return out

## ---------- Aggregated bonuses ----------

func get_recipe_bonuses(hero) -> Dictionary:
	var bonuses: Dictionary = {}
	if hero == null or hero.weapon == null:
		return bonuses
	for recipe_id in get_active_recipes(hero.weapon):
		var rec = GameState.get_recipe_def(recipe_id)
		if rec == null:
			continue
		_merge_bonus(bonuses, rec.bonus)
	return bonuses

func _merge_bonus(into: Dictionary, src: Dictionary) -> void:
	for key in src:
		var v = src[key]
		if key in _MAX_KEYS:
			into[key] = max(float(into.get(key, 0.0)), float(v))
		elif key in _SUM_KEYS:
			into[key] = float(into.get(key, 0.0)) + float(v)
		else:
			## Unknown key — pass through, latest-wins. Surfaces typos as warnings.
			push_warning("Recipes: unknown bonus key '%s'; passing through" % key)
			into[key] = v

## ---------- Discovery hook ----------

func check_hero_for_discoveries(hero) -> void:
	if hero == null or hero.weapon == null:
		return
	for recipe_id in get_active_recipes(hero.weapon):
		if not GameState.discovered_recipes.has(recipe_id):
			GameState.mark_discovered(recipe_id)
