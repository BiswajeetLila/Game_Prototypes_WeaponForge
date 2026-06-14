## forge_grid — hero-agnostic tile addressing + move/swap/merge across the whole forge
## (any socket or reserve slot of any hero) (G5).
##
## A tile ref = { kind: "socket"|"reserve", hero: int, idx: int }.
## Moving an OWNED item (socket<->socket, socket<->reserve, reserve<->reserve, across
## heroes) costs NO gold: empty dst -> move; same id+tier -> merge (slice stub 2/2);
## occupied dst -> swap. (Buying from the shop stays in main_v2 — it involves gold.)
## Pure static logic over the live `loadouts` (Array[3] of Array[3]) and `reserves`
## (Array[3] of Array[2]) arrays.
extends RefCounted

const MAX_TIER: int = 4  ## tier cap (T1-T4 rarity)

static func get_tile(loadouts: Array, reserves: Array, ref: Dictionary):
	var hero: int = int(ref.get("hero", -1))
	var idx: int = int(ref.get("idx", -1))
	if String(ref.get("kind", "")) == "socket":
		if hero < 0 or hero >= loadouts.size() or idx < 0 or idx >= loadouts[hero].size():
			return null
		return loadouts[hero][idx]
	if hero < 0 or hero >= reserves.size() or idx < 0 or idx >= reserves[hero].size():
		return null
	return reserves[hero][idx]

static func _set_tile(loadouts: Array, reserves: Array, ref: Dictionary, item) -> void:
	var hero: int = int(ref.get("hero", -1))
	var idx: int = int(ref.get("idx", -1))
	if String(ref.get("kind", "")) == "socket":
		if hero >= 0 and hero < loadouts.size() and idx >= 0 and idx < loadouts[hero].size():
			loadouts[hero][idx] = item
	elif hero >= 0 and hero < reserves.size() and idx >= 0 and idx < reserves[hero].size():
		reserves[hero][idx] = item

static func _same_ref(a: Dictionary, b: Dictionary) -> bool:
	return String(a.get("kind", "")) == String(b.get("kind", "")) and int(a.get("hero", -1)) == int(b.get("hero", -2)) and int(a.get("idx", -1)) == int(b.get("idx", -2))

static func _same_fn(a, b) -> bool:
	return a != null and b != null and StringName(a.get("id", &"")) == StringName(b.get("id", &"")) and int(a.get("tier", 1)) == int(b.get("tier", 1))

## Move/swap/merge an owned item from src -> dst (hero-agnostic). Returns {ok, result}.
## result: "moved" | "merged" | "swapped" | "same_tile" | "empty_src".
static func move(loadouts: Array, reserves: Array, src: Dictionary, dst: Dictionary) -> Dictionary:
	if _same_ref(src, dst):
		return {"ok": false, "result": "same_tile"}
	var s = get_tile(loadouts, reserves, src)
	if s == null:
		return {"ok": false, "result": "empty_src"}
	var d = get_tile(loadouts, reserves, dst)
	if d == null:
		_set_tile(loadouts, reserves, dst, s)
		_set_tile(loadouts, reserves, src, null)
		return {"ok": true, "result": "moved"}
	if _same_fn(s, d):
		var bumped: int = mini(int(d.get("tier", 1)) + 1, MAX_TIER)
		var merged: Dictionary = {"id": StringName(d.get("id", &"")), "tier": bumped, "cost": int(d.get("cost", 0))}
		_set_tile(loadouts, reserves, dst, merged)
		_set_tile(loadouts, reserves, src, null)
		return {"ok": true, "result": "merged"}
	## different items -> swap
	_set_tile(loadouts, reserves, dst, s)
	_set_tile(loadouts, reserves, src, d)
	return {"ok": true, "result": "swapped"}
