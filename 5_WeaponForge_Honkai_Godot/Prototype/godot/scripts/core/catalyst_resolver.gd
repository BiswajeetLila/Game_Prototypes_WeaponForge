## CatalystResolver — pure static squad+stage -> active-compound-state resolver.
##
## Spec: docs/superpowers/specs/2026-06-09-catalyst-design.md §4-§5.
##
## Stacking rule (CLAUDE.md §13):
##   no-cap from stage 1 (Earth-gated skip at stage < 10). All triggering
##   compounds active; bags compose multiplicatively for *_mult keys, additively
##   for *_add keys. The primary `compound` field = alpha winner (compounds[0]).
##
## Empty-element entries in squad_weapons are skipped (non-elemental starters
## never count toward a pair).
class_name CatalystResolver
extends RefCounted

const CatalystDataT = preload("res://scripts/data/catalyst_data.gd")

## Returns:
##   {
##     compound:    Dictionary | null      # alpha winner (compounds[0]), or null if empty
##     compounds:   Array[Dictionary]      # every triggering record, alpha-sorted
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

	## Sort by alphabetical_priority so primary `compound` (the displayed/picked
	## one) is stable across squad equip-order changes. `compound` = compounds[0]
	## (the alpha winner); `compounds` = the full triggering set.
	triggered.sort_custom(func(a, b): return int(a["alphabetical_priority"]) < int(b["alphabetical_priority"]))

	## No-cap stacking from stage 1 (cap-1 dropped post-playtest 2026-06-09).
	## All triggering compounds active; bags compose multiplicatively for *_mult,
	## additively for *_add. Earth-gated compounds remain skipped at stage < 10.
	return {"compound": triggered[0], "compounds": triggered, "merged_bag": _compose(triggered)}

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
