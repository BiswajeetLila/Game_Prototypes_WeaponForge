## CombatV2 — tick loop for the Phase 4 lane-runner.
## Autoload singleton (replaces dying combat.gd in Phase 5).
## Full impl in Phase 4 step 7.
##
## Tick resolution order (locked per spec §8.1):
##   1. status_decay  2. enemy_advance  3. hero_attack  4. reaction_resolve  5. death_cleanup
extends Node

## Emitted for each hero attack that lands (element_mediator subscribes).
signal hit_landed(hero_id: StringName, enemy: Dictionary, damage_tag: StringName)

var _tick_order_log: Array = []  ## test probe: logs step names per tick

func _ready() -> void:
	pass

func reset() -> void:
	_tick_order_log = []

## Run one full tick over a minimal game-state dict.
## gs = { "enemies": Array, "heroes": Array, "lane_state": LaneState }
func tick(gs: Dictionary) -> void:
	_tick_order_log = []
	var ls: Node = gs.get("lane_state", get_node_or_null("/root/LaneState"))
	if ls == null:
		return

	## 1. Status decay
	_tick_order_log.append("decay")
	for enemy in gs.get("enemies", []):
		ls.decay_statuses(enemy)

	## 2. Enemy advance (+ contact damage: an engaged enemy hits the hero in its lane, spec §7)
	_tick_order_log.append("advance")
	for enemy in gs.get("enemies", []):
		ls.advance_enemy(enemy)
		if enemy.get("engaged", false):
			var h = _hero_in_lane(gs, int(enemy.get("lane", -99)))
			if h != null:
				h["hp"] = maxi(0, int(h.get("hp", 0)) - 1)

	## 3. Hero attack pass
	_tick_order_log.append("attack")
	for hero in gs.get("heroes", []):
		_resolve_hero_attack(hero, gs, ls)

	## 4. Reaction resolve pass (handled via hit_landed signal -> ElementMediator)
	_tick_order_log.append("react")

	## 5. Death + cleanup
	_tick_order_log.append("cleanup")
	gs["enemies"] = gs.get("enemies", []).filter(func(e): return e.hp > 0)

func _hero_in_lane(gs: Dictionary, lane: int):
	for h in gs.get("heroes", []):
		if int(h.get("lane", -99)) == lane:
			return h
	return null

func _resolve_hero_attack(hero: Dictionary, gs: Dictionary, ls: Node) -> void:
	var enemies: Array = gs.get("enemies", [])
	if enemies.is_empty():
		return
	## Simple stub: attack first enemy in hero's lane (or any if none in lane)
	var target: Dictionary = {}
	for e in enemies:
		if e.lane == hero.get("lane", 1):
			target = e
			break
	if target.is_empty() and not enemies.is_empty():
		target = enemies[0]
	if target.is_empty():
		return
	var dmg: int = int(hero.get("base_dmg", 1))
	target["hp"] = target["hp"] - dmg
	var tag: StringName = hero.get("damage_tag", &"")
	hit_landed.emit(hero.get("id", &""), target, tag)
	## Let ElementMediator handle reactions via signal
	var em := get_node_or_null("/root/ElementMediator")
	if em != null and tag != &"":
		em.dispatch_reaction(tag, target)
