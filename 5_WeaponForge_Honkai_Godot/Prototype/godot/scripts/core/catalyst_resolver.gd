## CatalystResolver — pure static squad+stage -> active-compound-state resolver.
##
## Spec: docs/superpowers/specs/2026-06-09-catalyst-design.md §4-§5.
##
## Stacking rule (CLAUDE.md §13):
##   stages 1-4 -> cap-1 (alphabetical compound-name priority wins)
##   stages 5+  -> no-cap (all triggering compounds active; bags compose
##                  multiplicatively for *_mult keys, additively for *_add)
##   Earth-gated compounds skip entirely when stage < 10, regardless of cap.
##
## Empty-element entries in squad_weapons are skipped (non-elemental starters
## never count toward a pair).
class_name CatalystResolver
extends RefCounted

const CatalystDataT = preload("res://scripts/data/catalyst_data.gd")

## Returns:
##   {
##     compound:    Dictionary | null      # cap-1: the winning record, else null
##     compounds:   Array[Dictionary]      # no-cap (stage>=5): every triggering record
##     merged_bag:  Dictionary             # composed modifier bag
##   }
static func resolve(squad_weapons: Array, stage: int) -> Dictionary:
	## 1. Distinct equipped elements (skip empty + dedupe).
	var elems: Array = []
	for w in squad_weapons:
		if w == null:
			continue
		var r: StringName = w.rune if "rune" in w else &""
		if r == &"" or r in elems:
			continue
		elems.append(r)

	if elems.size() < 2:
		return {"compound": null, "compounds": [], "merged_bag": CatalystDataT.EMPTY_BAG.duplicate()}

	## 2. Enumerate all distinct pairs and look up matching compounds.
	var triggered: Array = []
	for i in range(elems.size()):
		for j in range(i + 1, elems.size()):
			var rec: Dictionary = CatalystDataT.for_pair(elems[i], elems[j])
			if rec.is_empty():
				continue
			if int(rec.get("gated_from_stage", 0)) > stage:
				continue   ## Earth-gated, stage < 10
			triggered.append(rec)

	if triggered.is_empty():
		return {"compound": null, "compounds": [], "merged_bag": CatalystDataT.EMPTY_BAG.duplicate()}

	## 3. Stacking.
	if stage <= 4:
		## cap-1: alphabetical priority by compound id (lower index = wins).
		triggered.sort_custom(func(a, b): return int(a["alphabetical_priority"]) < int(b["alphabetical_priority"]))
		var winner: Dictionary = triggered[0]
		return {"compound": winner, "compounds": [winner],
			"merged_bag": _compose([winner])}
	## stage >= 5: all triggering.
	return {"compound": null, "compounds": triggered, "merged_bag": _compose(triggered)}

## Composition rules (spec §3): *_mult keys multiplicative, *_add keys additive,
## starting from EMPTY_BAG. squad_atk_vs_swarm_mult composes as a normal mult key
## here; the gated >=3-enemies check is applied at hit-resolution time, not here.
static func _compose(records: Array) -> Dictionary:
	var bag: Dictionary = CatalystDataT.EMPTY_BAG.duplicate()
	for rec in records:
		var mb: Dictionary = rec.get("modifier_bag", {})
		for k in mb:
			var v = mb[k]
			if String(k).ends_with("_add"):
				bag[k] = float(bag.get(k, 0.0)) + float(v)
			else:
				bag[k] = float(bag.get(k, 1.0)) * float(v)
	return bag
