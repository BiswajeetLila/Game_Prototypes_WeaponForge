## Weapon — runtime aggregator over 3 equipped InventoryItem slots.
## Looks up the PartData catalog by part_id and applies the level multiplier
## per slot. Single source of truth for weapon math.
##
## All getters are derived from current slot state — no caching, no separate
## "compiled stats" struct. Recomputing is cheap (3 slot lookups + sums) and
## avoids stale state when slots mutate.
##
## Reachable from GameState autoload via preload chain → InventoryItem / PartData
## type annotations stripped to untyped to dodge cold-start global-class race.
class_name Weapon
extends RefCounted

## Per-level stat multiplier (merge_mechanic.md): L1..L5. Hot-path mirror of
## Merge.LEVEL_MULT; test_weapon_level_mult_mirrors_merge locks drift.
const LEVEL_MULT: Array = [1.00, 1.35, 1.80, 2.30, 2.75]

## Three slots: head · rune · body. Rune is the CENTER slot; `body` replaced the
## old `hilt`. Each is either an InventoryItem (RefCounted) or null.
var head = null
var rune = null
var body = null

## ---------- Slot access ----------

func get_slot(slot: StringName):
	match slot:
		&"head": return head
		&"rune": return rune
		&"body": return body
	return null

func set_slot(slot: StringName, item) -> void:
	match slot:
		&"head": head = item
		&"rune": rune = item
		&"body": body = item

func slots() -> Array:
	return [head, rune, body]

func is_full() -> bool:
	return head != null and rune != null and body != null

## ---------- Stat aggregation ----------
## Reads PartData via GameState.get_part_def() — a deliberate dependency so we
## don't have to pass the catalog through every call.

func _stat_for(item, key: StringName) -> float:
	if item == null:
		return 0.0
	var def = GameState.get_part_def(item.part_id)   ## PartData or null
	if def == null:
		return 0.0
	var idx: int = clampi(item.level - 1, 0, LEVEL_MULT.size() - 1)
	var mult: float = float(LEVEL_MULT[idx])
	var raw: float = 0.0
	match key:
		&"atk":      raw = float(def.atk)
		&"hp":       raw = float(def.hp)
		&"crit":     raw = float(def.crit)
		&"ult_rate": raw = float(def.ult_rate)
	return raw * mult

func get_atk() -> int:
	return int(floor(_stat_for(head, &"atk") + _stat_for(rune, &"atk") + _stat_for(body, &"atk")))

func get_hp_bonus() -> int:
	return int(floor(_stat_for(head, &"hp") + _stat_for(rune, &"hp") + _stat_for(body, &"hp")))

func get_crit() -> int:
	return int(floor(_stat_for(head, &"crit") + _stat_for(rune, &"crit") + _stat_for(body, &"crit")))

func get_ult_rate() -> int:
	return int(floor(_stat_for(head, &"ult_rate") + _stat_for(rune, &"ult_rate") + _stat_for(body, &"ult_rate")))

## ---------- Tags ----------
## Explicit tags come from PartData.tag. Derived tags ("crit" from any crit%,
## "charge" from any ult_rate%) are added per addendum 0.1.9.

func get_explicit_tags() -> Array:
	var out: Array = []
	for item in slots():
		if item == null:
			continue
		var def = GameState.get_part_def(item.part_id)
		if def != null and def.tag != &"":
			out.append(def.tag)
	return out

func get_derived_tags() -> Array:
	var out: Array = []
	if get_crit() > 0:
		out.append(&"crit")
	if get_ult_rate() > 0:
		out.append(&"charge")
	return out

func get_all_tags() -> Array:
	var out: Array = get_explicit_tags()
	out.append_array(get_derived_tags())
	return out
