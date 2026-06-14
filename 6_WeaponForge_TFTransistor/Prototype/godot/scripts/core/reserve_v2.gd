## reserve_v2 — per-hero Reserve (bench) + equip-with-displacement + sell logic (G2).
##
## Each hero has 2 Reserve slots. The forge-equip flow (spec / Forge_State_edits.jpg):
##   - Empty weapon socket + equip            -> place.
##   - Occupied socket + equip SAME id+tier    -> merge (slice stub: marks 2/2, no bump).
##   - Occupied socket + equip DIFFERENT       -> displaced item drops into a free Reserve
##                                                slot; if BOTH reserves are full -> blocked
##                                                (caller plays the error feedback).
##   - Reserve item -> socket (bench re-equip): swaps the socket item back into that reserve.
##   - Sell a socket or reserve item to the shop for a reduced refund (floor 50% of cost).
##
## Socket / reserve entries carry cost so they can be sold later: {id, tier, cost, merge?}.
## Pure static logic (no Node state) — trivially testable + reusable.
extends RefCounted

const SLOTS: int = 2          ## reserve slots per hero
const SELL_RATIO: float = 0.5 ## refund fraction when selling (reduced amount)

static func make_reserve() -> Array:
	return [null, null]

static func count(reserve: Array) -> int:
	var n: int = 0
	for it in reserve:
		if it != null:
			n += 1
	return n

static func has_room(reserve: Array) -> bool:
	return first_empty(reserve) >= 0

static func first_empty(reserve: Array) -> int:
	for i in reserve.size():
		if reserve[i] == null:
			return i
	return -1

static func _same_fn(a, b) -> bool:
	return a != null and b != null and StringName(a.get("id", &"")) == StringName(b.get("id", &"")) and int(a.get("tier", 1)) == int(b.get("tier", 1))

static func _entry(item) -> Dictionary:
	return {"id": StringName(item.get("id", &"")), "tier": int(item.get("tier", 1)), "cost": int(item.get("cost", 0))}

## Equip `item` into loadout[socket_idx]. Empty -> place. Same id+tier -> merge (slice
## stub: marks 2/2). Different + reserve has room -> displace old to reserve. Different +
## reserve full -> blocked_full (no change). Returns {ok, result, loadout, reserve}.
static func equip(loadout: Array, reserve: Array, socket_idx: int, item: Dictionary) -> Dictionary:
	if socket_idx < 0 or socket_idx >= loadout.size():
		return {"ok": false, "result": "bad_socket", "loadout": loadout, "reserve": reserve}
	var cur = loadout[socket_idx]
	if cur == null:
		loadout[socket_idx] = _entry(item)
		return {"ok": true, "result": "equipped", "loadout": loadout, "reserve": reserve}
	if _same_fn(cur, item):
		var e := _entry(item)
		e["merge"] = "2/2"  ## slice merge stub: no tier bump
		loadout[socket_idx] = e
		return {"ok": true, "result": "merged", "loadout": loadout, "reserve": reserve}
	var slot: int = first_empty(reserve)
	if slot < 0:
		return {"ok": false, "result": "blocked_full", "loadout": loadout, "reserve": reserve}
	reserve[slot] = cur  ## displaced item keeps its cost (sellable from the bench)
	loadout[socket_idx] = _entry(item)
	return {"ok": true, "result": "displaced", "loadout": loadout, "reserve": reserve}

## Re-equip a benched (reserve) item into a socket. The socket's current item swaps back
## into the reserve slot the bench item vacated. Same id+tier -> merge. Returns {ok,...}.
static func equip_from_reserve(loadout: Array, reserve: Array, socket_idx: int, reserve_idx: int) -> Dictionary:
	if reserve_idx < 0 or reserve_idx >= reserve.size() or reserve[reserve_idx] == null:
		return {"ok": false, "result": "empty", "loadout": loadout, "reserve": reserve}
	if socket_idx < 0 or socket_idx >= loadout.size():
		return {"ok": false, "result": "bad_socket", "loadout": loadout, "reserve": reserve}
	var bench = reserve[reserve_idx]
	var cur = loadout[socket_idx]
	if _same_fn(cur, bench):
		var e: Dictionary = {"id": StringName(bench.get("id", &"")), "tier": int(bench.get("tier", 1)), "cost": int(bench.get("cost", 0)), "merge": "2/2"}
		loadout[socket_idx] = e
		reserve[reserve_idx] = null
		return {"ok": true, "result": "merged", "loadout": loadout, "reserve": reserve}
	loadout[socket_idx] = bench
	reserve[reserve_idx] = cur  ## cur may be null -> reserve slot empties
	return {"ok": true, "result": "swapped", "loadout": loadout, "reserve": reserve}

## Reduced refund for selling an item back to the shop (floor of 50% of its cost).
static func sell_value(item) -> int:
	if item == null:
		return 0
	return int(floor(float(int(item.get("cost", 0))) * SELL_RATIO))

static func sell_socket(loadout: Array, socket_idx: int) -> Dictionary:
	if socket_idx < 0 or socket_idx >= loadout.size() or loadout[socket_idx] == null:
		return {"ok": false, "gold_refund": 0, "loadout": loadout}
	var v: int = sell_value(loadout[socket_idx])
	loadout[socket_idx] = null
	return {"ok": true, "gold_refund": v, "loadout": loadout}

static func sell_reserve(reserve: Array, reserve_idx: int) -> Dictionary:
	if reserve_idx < 0 or reserve_idx >= reserve.size() or reserve[reserve_idx] == null:
		return {"ok": false, "gold_refund": 0, "reserve": reserve}
	var v: int = sell_value(reserve[reserve_idx])
	reserve[reserve_idx] = null
	return {"ok": true, "gold_refund": v, "reserve": reserve}
