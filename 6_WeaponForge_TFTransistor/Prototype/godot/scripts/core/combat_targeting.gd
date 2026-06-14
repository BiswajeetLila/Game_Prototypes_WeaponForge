## CombatTargeting — pure target-selection for the lane corridor (spec §3 targeting primitives).
## Stateless static helpers; preload to use (class_name unreliable in headless parse).
## resolve() returns the ORDERED list of enemy dicts a Function's Active should hit this tick.
class_name CombatTargeting
extends RefCounted

const LANE_K: float = 3.0  ## 1 lane-stride ≈ 0.33 screen-x (matches lane_state.LANE_K)

static func _dist(la: int, xa: float, lb: int, xb: float) -> float:
	var dl := float(abs(lb - la))
	var dx := (xb - xa) * LANE_K
	return sqrt(dl * dl + dx * dx)

## Closest enemy to the hero in the hero's OWN lane (smallest screen_x = nearest the anchor).
static func _own_lane_closest(hero_lane: int, enemies: Array) -> Array:
	var best = null
	for e in enemies:
		if int(e.lane) != hero_lane:
			continue
		if best == null or float(e.screen_x) < float(best.screen_x):
			best = e
	return [best] if best != null else []

## Closest enemy across ALL lanes by Euclidean lane-distance.
static func _any_lane_closest(hero_lane: int, hero_x: float, enemies: Array):
	var best = null
	var best_d := INF
	for e in enemies:
		var d := _dist(hero_lane, hero_x, int(e.lane), float(e.screen_x))
		if d < best_d:
			best_d = d
			best = e
	return best

## Every enemy in the hero's lane, front (nearest) to back.
static func _own_lane_line(hero_lane: int, enemies: Array) -> Array:
	var out: Array = []
	for e in enemies:
		if int(e.lane) == hero_lane:
			out.append(e)
	out.sort_custom(func(a, b): return float(a.screen_x) < float(b.screen_x))
	return out

## N nearest enemies to the hero (any lane), nearest first. For fan / radial / spread.
static func _n_nearest_to_hero(hero_lane: int, hero_x: float, enemies: Array, n: int) -> Array:
	var sorted := enemies.duplicate()
	sorted.sort_custom(func(a, b):
		return _dist(hero_lane, hero_x, int(a.lane), float(a.screen_x)) < _dist(hero_lane, hero_x, int(b.lane), float(b.screen_x)))
	return sorted.slice(0, maxi(1, n))

## Ricochet: start at the any-lane closest, then chain to the nearest unhit enemy to the
## last enemy hit, up to `max_hits` total.
static func _ricochet(hero_lane: int, hero_x: float, enemies: Array, max_hits: int) -> Array:
	var primary = _any_lane_closest(hero_lane, hero_x, enemies)
	if primary == null:
		return []
	var chain: Array = [primary]
	var remaining := enemies.filter(func(e): return e != primary)
	while chain.size() < max_hits and not remaining.is_empty():
		var last = chain[chain.size() - 1]
		var best = null
		var best_d := INF
		for e in remaining:
			var d := _dist(int(last.lane), float(last.screen_x), int(e.lane), float(e.screen_x))
			if d < best_d:
				best_d = d
				best = e
		chain.append(best)
		remaining = remaining.filter(func(e): return e != best)
	return chain

## Lowest-HP enemy across all lanes.
static func _lowest_hp(enemies: Array) -> Array:
	var best = null
	for e in enemies:
		if best == null or int(e.hp) < int(best.hp):
			best = e
	return [best] if best != null else []

## Resolve the target list for a targeting primitive.
static func resolve(targeting: StringName, hero_lane: int, hero_x: float,
		enemies: Array, max_hits: int = 1) -> Array:
	if enemies.is_empty():
		return []
	match targeting:
		&"own_lane_closest", &"":
			return _own_lane_closest(hero_lane, enemies)
		&"any_lane_closest":
			var t = _any_lane_closest(hero_lane, hero_x, enemies)
			return [t] if t != null else []
		&"lowest_hp":
			return _lowest_hp(enemies)
		&"own_lane_line":
			return _own_lane_line(hero_lane, enemies)
		&"ricochet":
			return _ricochet(hero_lane, hero_x, enemies, maxi(1, max_hits))
		&"fan_3":
			return _n_nearest_to_hero(hero_lane, hero_x, enemies, 3)
		&"chain_arc":
			return _n_nearest_to_hero(hero_lane, hero_x, enemies, 2)
		&"radial_5":
			return _n_nearest_to_hero(hero_lane, hero_x, enemies, 5)
		&"cross_lane_spread":
			return _n_nearest_to_hero(hero_lane, hero_x, enemies, 3)
		_:
			return _own_lane_closest(hero_lane, enemies)
