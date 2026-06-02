## ForgeDraft — Wittle-style post-wave perk draft service (R2, spec §10 v1).
##
## deal(n=3) builds n AXIS-DISTINCT stat cards (same axis twice = fake choice),
## each tagged to a random unlocked hero. apply(card) writes the effect into the
## tagged hero's run_mods (run-scoped — dies with the run; pulls are the permanent
## layer). Boss waves deal 5 (spec §10 Boss Bonus Draft).
##
## v1 card pool = 5 stat axes on the equipped weapon/hero. Ability/rune transform
## cards (storm splits, hellfire chains) come with the card-types-expand increment.
##
## Card values — Numbers Policy starting values (test plan: post-wave power bump
## should feel ~10-20%; if picks feel meaningless, raise atk_pct/atk_flat first):
##   atk_flat +4 · atk_pct +20% · crit +6 · ult_rate +6 · hp_flat +25
extends Node

const SkillCardDataT = preload("res://scripts/data/skill_card_data.gd")

signal draft_ready(cards: Array)
signal draft_applied(card)

const AXES: Array = [&"atk_flat", &"atk_pct", &"crit", &"ult_rate", &"hp_flat"]
const AXIS_VALUES: Dictionary = {
	&"atk_flat": 4, &"atk_pct": 0.20, &"crit": 6, &"ult_rate": 6, &"hp_flat": 25,
}
const AXIS_NAMES: Dictionary = {
	&"atk_flat": "Whetstone", &"atk_pct": "Forge Temper", &"crit": "Killing Edge",
	&"ult_rate": "Battle Rhythm", &"hp_flat": "Iron Skin",
}
const AXIS_DESCS: Dictionary = {
	&"atk_flat": "+4 weapon ATK",
	&"atk_pct": "+20% weapon ATK",
	&"crit": "+6% crit chance",
	&"ult_rate": "+6% ult charge rate",
	&"hp_flat": "+25 max HP",
}
## atk/crit/ult buff the weapon -> "weapon" card type; hp buffs the hero.
const AXIS_TYPES: Dictionary = {
	&"atk_flat": &"weapon", &"atk_pct": &"weapon", &"crit": &"weapon",
	&"ult_rate": &"weapon", &"hp_flat": &"hero",
}

## Deal n cards across n distinct axes, heroes randomized per card.
func deal(count: int = 3) -> Array:
	var axes: Array = AXES.duplicate()
	axes.shuffle()
	var heroes: Array = GameState.squad_order
	var cards: Array = []
	for i in range(mini(count, axes.size())):
		if heroes.is_empty():
			break
		var hero_id: StringName = heroes[randi() % heroes.size()]
		cards.append(make_card(axes[i], hero_id))
	draft_ready.emit(cards)
	return cards

## Build one stat card for a given axis + hero tag.
func make_card(axis: StringName, hero_id: StringName):
	var c = SkillCardDataT.new()
	c.id = StringName("card_%s_%s" % [axis, hero_id])
	c.name = String(AXIS_NAMES.get(axis, String(axis)))
	c.desc = String(AXIS_DESCS.get(axis, ""))
	c.card_type = AXIS_TYPES.get(axis, &"weapon")
	c.hero_id = hero_id
	c.rarity_idx = 0
	c.effect = {axis: AXIS_VALUES.get(axis, 0)}
	return c

## Apply the picked card to its tagged hero's run-scoped mods.
func apply(card) -> bool:
	if card == null or not card.is_valid():
		return false
	var hero = GameState.get_hero(card.hero_id)
	if hero == null:
		return false
	for key in card.effect:
		hero.apply_run_mod(key, card.effect[key])
	GameState.append_combat_log("[color=ffcc66]🃏 %s — %s (%s)[/color]"
		% [hero.data.name, card.name, card.desc])
	draft_applied.emit(card)
	return true
