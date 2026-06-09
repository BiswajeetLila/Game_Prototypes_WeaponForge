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

## Element -> emoji glyph. Single source of truth for catalyst UI surfaces
## (chip / banner / codex). Mirrors the icon vocabulary in home_screen.
const ELEM_GLYPH: Dictionary = {
	&"fire": "🔥", &"ice": "❄", &"electric": "⚡",
	&"wind": "🌪", &"earth": "🪨",
	&"light": "☀",   ## A4 scripted-pacing-rework — Hot Paladin's Helios Cleaver
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

## Human-readable effect string for a compound record. Consolidates the formatters
## previously duplicated in home_screen / catalyst_banner / catalyst_codex.
##
## opts (all optional):
##   "glyph_prefix": bool   prepend "🔥+❄   " (3-space tail) — banner usage
##   "empty_str":    String body when every bag entry is neutral — default "—"
##   "compact":      bool   shorter labels — "ATK" not "squad ATK", "vs swarm"
##                          not "ATK vs swarm" — codex usage
static func format_effect(rec: Dictionary, opts: Dictionary = {}) -> String:
	var glyph_prefix: bool = bool(opts.get("glyph_prefix", false))
	var empty_str: String = String(opts.get("empty_str", "—"))
	var compact: bool = bool(opts.get("compact", false))
	var atk_label: String = "ATK" if compact else "squad ATK"
	var swarm_label: String = "vs swarm" if compact else "ATK vs swarm"
	var mb: Dictionary = rec.get("modifier_bag", {})
	var parts: Array = []
	var atk_mult: float = float(mb.get(&"squad_atk_mult", 1.0))
	if not is_equal_approx(atk_mult, 1.0):
		parts.append("+%d%% %s" % [int(round((atk_mult - 1.0) * 100.0)), atk_label])
	var crit_add: float = float(mb.get(&"squad_crit_add", 0.0))
	if not is_equal_approx(crit_add, 0.0):
		parts.append("+%d%% crit" % int(round(crit_add * 100.0)))
	var enemy_as: float = float(mb.get(&"enemy_atk_speed_mult", 1.0))
	if not is_equal_approx(enemy_as, 1.0):
		parts.append("-%d%% enemy atk-spd" % int(round((1.0 - enemy_as) * 100.0)))
	var swarm: float = float(mb.get(&"squad_atk_vs_swarm_mult", 1.0))
	if not is_equal_approx(swarm, 1.0):
		parts.append("+%d%% %s" % [int(round((swarm - 1.0) * 100.0)), swarm_label])
	var body: String = empty_str if parts.is_empty() else " · ".join(parts)
	if glyph_prefix:
		var elements: Array = rec.get("elements", [])
		if elements.size() == 2:
			var g1: String = String(ELEM_GLYPH.get(elements[0], ""))
			var g2: String = String(ELEM_GLYPH.get(elements[1], ""))
			return "%s+%s   %s" % [g1, g2, body]
	return body
