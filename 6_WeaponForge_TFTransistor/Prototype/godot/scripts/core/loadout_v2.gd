## loadout_v2 — per-hero Function socket model + equip/merge logic (A6).
##
## A loadout is an Array of 3 sockets — canonical index 0=PASSIVE, 1=MODIFIER, 2=ACTIVE.
## Each socket is either null (empty) or { id: StringName, tier: int }.
##
## Merge rule (spec §10): dropping the SAME function at the SAME tier onto a socket
## that already holds it -> tier + 1 (cap 5), position retained. A DIFFERENT function
## (or same id at a different tier) just swaps. Empty socket -> place.
##
## Pure static logic (no Node state) so it is trivially testable and reusable.
extends RefCounted

const SOCKETS: int = 3
const MAX_TIER: int = 5

static func make_loadout() -> Array:
	return [null, null, null]

## allow_merge=true (default): same-id+tier drop bumps tier (cap 5).
## allow_merge=false (slice stub §10.4): same-id+tier drop does NOT bump — marks {merge:"2/2"}.
static func apply_drop(loadout: Array, socket_idx: int, fn_id: StringName, fn_tier: int = 1, allow_merge: bool = true) -> Array:
	if socket_idx < 0 or socket_idx >= loadout.size():
		return loadout
	var cur = loadout[socket_idx]
	if cur == null:
		loadout[socket_idx] = {"id": fn_id, "tier": fn_tier}
	elif cur.id == fn_id and cur.tier == fn_tier:
		if allow_merge:
			loadout[socket_idx] = {"id": fn_id, "tier": mini(fn_tier + 1, MAX_TIER)}
		else:
			loadout[socket_idx] = {"id": fn_id, "tier": fn_tier, "merge": "2/2"}
	else:
		loadout[socket_idx] = {"id": fn_id, "tier": fn_tier}
	return loadout

static func is_empty(loadout: Array, socket_idx: int) -> bool:
	if socket_idx < 0 or socket_idx >= loadout.size():
		return true
	return loadout[socket_idx] == null
