## CatalystData — Catalyst v1 compound table (element-pair synergy).
##
## Spec: docs/superpowers/specs/2026-06-09-catalyst-design.md
## Pure data class — static fns only, no instance state. RefCounted so callers
## can `preload`/`load` and call without an autoload entry.
##
## 10 compounds: 6 FTUE-reachable (gated_from_stage = 0) + 4 Earth-pair gated
## from stage 10 (per the design spec's Earth gate at S10). v1 implements all 10
## as simple modifier-bag rows; Earth-pair compounds carry a placeholder
## squad_atk_mult of 1.15 until v2 lands their rich effects.
##
## Modifier bag schema (spec §3):
##   squad_atk_mult         (1.0 neutral, multiplicative)
##   squad_crit_add         (0.0 neutral, additive %)
##   enemy_atk_speed_mult   (1.0 neutral, multiplicative — applied to enemy side)
##   squad_atk_vs_swarm_mult(1.0 neutral, multiplicative, gates on >=3 alive enemies)
class_name CatalystData
extends RefCounted

const EMPTY_BAG: Dictionary = {
	&"squad_atk_mult":        1.0,
	&"squad_crit_add":        0.0,
	&"enemy_atk_speed_mult":  1.0,
	&"squad_atk_vs_swarm_mult": 1.0,
}

## Cap-1 alphabetical priority — by COMPOUND name (CLAUDE.md §13).
## Lower index = higher priority.
##   Blizzard > Firestorm > Glacial Storm > Plasma > Stormfront > Wildfire
##   then Earth unlocks (S10+):
##   Magnetic Storm > Permafrost > Sandstorm > Volcanic
const _PRIORITY_ORDER: Array = [
	&"blizzard", &"firestorm", &"glacial_storm", &"plasma",
	&"stormfront", &"wildfire",
	&"magnetic_storm", &"permafrost", &"sandstorm", &"volcanic",
]

## Element pair-keys are sorted alphabetically before lookup so order is irrelevant.
static func _pair_key(a: StringName, b: StringName) -> StringName:
	var sa: String = String(a)
	var sb: String = String(b)
	if sa <= sb:
		return StringName("%s+%s" % [sa, sb])
	return StringName("%s+%s" % [sb, sa])

## Canonical 10-record table. Each record:
##   { id: StringName, pair_key: StringName, elements: [StringName, StringName],
##     display_name: String, modifier_bag: Dictionary, gated_from_stage: int,
##     alphabetical_priority: int }
static func compounds() -> Array:
	## STARTING VALUES (Numbers Policy) per spec §11.
	var rows: Array = [
		{"id": &"firestorm", "elements": [&"fire", &"ice"], "display_name": "Firestorm",
			"modifier_bag": {&"squad_atk_mult": 1.20, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 0},
		{"id": &"wildfire", "elements": [&"fire", &"wind"], "display_name": "Wildfire",
			"modifier_bag": {&"squad_atk_mult": 1.15, &"squad_crit_add": 0.10,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 0},
		{"id": &"plasma", "elements": [&"fire", &"electric"], "display_name": "Plasma",
			"modifier_bag": {&"squad_atk_mult": 1.0, &"squad_crit_add": 0.15,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 0},
		{"id": &"blizzard", "elements": [&"ice", &"wind"], "display_name": "Blizzard",
			"modifier_bag": {&"squad_atk_mult": 1.0, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 0.80, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 0},
		{"id": &"glacial_storm", "elements": [&"ice", &"electric"], "display_name": "Glacial Storm",
			"modifier_bag": {&"squad_atk_mult": 1.15, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 0},
		{"id": &"stormfront", "elements": [&"wind", &"electric"], "display_name": "Stormfront",
			"modifier_bag": {&"squad_atk_mult": 1.0, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.25},
			"gated_from_stage": 0},
		## Earth pairs — gated_from_stage 10. v1 placeholder bag = +15% ATK; v2 = rich effects.
		{"id": &"volcanic", "elements": [&"fire", &"earth"], "display_name": "Volcanic",
			"modifier_bag": {&"squad_atk_mult": 1.30, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 10},
		{"id": &"permafrost", "elements": [&"ice", &"earth"], "display_name": "Permafrost",
			"modifier_bag": {&"squad_atk_mult": 1.15, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 10},
		{"id": &"sandstorm", "elements": [&"wind", &"earth"], "display_name": "Sandstorm",
			"modifier_bag": {&"squad_atk_mult": 1.15, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 10},
		{"id": &"magnetic_storm", "elements": [&"earth", &"electric"], "display_name": "Magnetic Storm",
			"modifier_bag": {&"squad_atk_mult": 1.15, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 10},
	]
	for r in rows:
		r["pair_key"] = _pair_key(r["elements"][0], r["elements"][1])
		r["alphabetical_priority"] = _PRIORITY_ORDER.find(r["id"])
	return rows

## Order-independent pair lookup. Empty-element inputs (or pairs without a defined
## compound) return {}.
static func for_pair(a: StringName, b: StringName) -> Dictionary:
	if a == &"" or b == &"" or a == b:
		return {}
	var key: StringName = _pair_key(a, b)
	for r in compounds():
		if r["pair_key"] == key:
			return r
	return {}

## All compounds sorted by alphabetical_priority (for cap-1 tie-break). Earth
## entries are included; callers filter on gated_from_stage themselves.
static func by_priority() -> Array:
	var rows: Array = compounds()
	rows.sort_custom(func(a, b): return int(a["alphabetical_priority"]) < int(b["alphabetical_priority"]))
	return rows
