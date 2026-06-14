## UltController — tracks squad Reaction Charge and Ult bar state.
## Autoload singleton. Full impl in Phase 4 step 8.
## Charge rule: every 3 reactions -> +1 Ult bar (max 3). Bars persist across waves.
extends Node

var bars: int = 0                ## current Ult bars (0-3)
var _reaction_count: int = 0     ## reactions since last bar fill

func _ready() -> void:
	var em := get_node_or_null("/root/ElementMediator")
	if em != null:
		em.reaction_triggered.connect(_on_reaction_triggered)

func reset() -> void:
	bars = 0
	_reaction_count = 0

## Called externally in tests; also connected to ElementMediator signal.
func on_reaction() -> void:
	_reaction_count += 1
	if _reaction_count >= 3:
		_reaction_count = 0
		bars = mini(bars + 1, 3)

func _on_reaction_triggered(_reaction_id: StringName, _enemy: Dictionary) -> void:
	on_reaction()

## Consume 1 bar (returns false if no bars available).
func consume_bar() -> bool:
	if bars <= 0:
		return false
	bars -= 1
	return true

## ---- Ult effects (spec §12) ----
## Fire a hero's Ult. ctx = { lane:int, enemies:Array, base_dmg:int, lane_state:Node }.
## Consumes 1 bar; refunds it if there was no valid target (Bran/Vex on empty grid).
## Returns { fired:bool, refunded:bool, hits:int }.
func fire_ult(hero_id: StringName, ctx: Dictionary) -> Dictionary:
	if bars <= 0:
		return {"fired": false, "refunded": false, "hits": 0}
	bars -= 1  ## consume 1 (spec §12.4)
	var res := _apply_ult(hero_id, ctx)
	if res.get("no_target", false):
		bars += 1  ## refund — Bran/Vex fired on an empty grid (spec §12.4)
		return {"fired": false, "refunded": true, "hits": 0}
	return {"fired": true, "refunded": false, "hits": int(res.get("hits", 0))}

func _apply_ult(hero_id: StringName, ctx: Dictionary) -> Dictionary:
	match hero_id:
		&"bran": return _bran_leap(ctx)
		&"elara": return _elara_storm(ctx)
		&"vex": return _vex_strike(ctx)
	return {"hits": 0}

func _dist(a: Dictionary, b: Dictionary) -> float:
	var dl := float(abs(int(b.lane) - int(a.lane)))
	var dx := (float(b.screen_x) - float(a.screen_x)) * 3.0
	return sqrt(dl * dl + dx * dx)

## Bran "Leap & Slam": 5x base on back-most own-lane enemy (or most-advanced overall if
## the lane is empty) + 2 nearest cross-lane; +2 Cracked to all hit. Refund on empty grid.
func _bran_leap(ctx: Dictionary) -> Dictionary:
	var ls = ctx.get("lane_state")
	var enemies: Array = ctx.get("enemies", [])
	var lane: int = int(ctx.get("lane", 1))
	var base: int = int(ctx.get("base_dmg", 2))
	if enemies.is_empty():
		return {"no_target": true}
	var in_lane := enemies.filter(func(e): return int(e.lane) == lane)
	var primary
	if not in_lane.is_empty():
		primary = in_lane[0]
		for e in in_lane:
			if float(e.screen_x) > float(primary.screen_x):
				primary = e  ## back-most (furthest from hero)
	else:
		primary = enemies[0]
		for e in enemies:
			if float(e.screen_x) < float(primary.screen_x):
				primary = e  ## most-advanced overall
	var others := enemies.filter(func(e): return e != primary)
	others.sort_custom(func(a, b): return _dist(primary, a) < _dist(primary, b))
	var hit: Array = [primary]
	for i in mini(2, others.size()):
		hit.append(others[i])
	var dmg: int = int(round(float(base) * 5.0))
	for t in hit:
		t["hp"] = int(t["hp"]) - dmg
		ls.apply_status(t, &"Cracked", 4, 2, 3)
	return {"hits": hit.size()}

## Elara "Chain Storm": 8 LIGHTNING arcs across every Wet enemy @2x base + Shocked.
## Failsafe: no Wet -> all enemies take 1x base. Never refunds (spec §12.4).
func _elara_storm(ctx: Dictionary) -> Dictionary:
	var ls = ctx.get("lane_state")
	var enemies: Array = ctx.get("enemies", [])
	var base: int = int(ctx.get("base_dmg", 2))
	var wet := enemies.filter(func(e): return ls.has_status(e, &"Wet"))
	if wet.is_empty():
		for e in enemies:
			e["hp"] = int(e["hp"]) - base  ## failsafe, never wasted
		return {"hits": enemies.size()}
	var dmg: int = int(round(float(base) * 2.0))
	var n: int = mini(8, wet.size())
	for i in n:
		var t = wet[i]
		t["hp"] = int(t["hp"]) - dmg
		ls.apply_status(t, &"Shocked", 2)
	return {"hits": n}

## Vex "Phantom Strike": 3 strikes @200% base (crit-locked) on lowest-HP enemy + Burning + Bleed.
## Refund on empty grid (spec §12.4).
func _vex_strike(ctx: Dictionary) -> Dictionary:
	var ls = ctx.get("lane_state")
	var enemies: Array = ctx.get("enemies", [])
	var base: int = int(ctx.get("base_dmg", 2))
	if enemies.is_empty():
		return {"no_target": true}
	var t = enemies[0]
	for e in enemies:
		if int(e.hp) < int(t.hp):
			t = e
	var per: int = int(round(float(base) * 2.0))
	for i in 3:
		t["hp"] = int(t["hp"]) - per
	ls.apply_status(t, &"Burning", 3)
	ls.apply_status(t, &"Bleed", 4)
	return {"hits": 1}
