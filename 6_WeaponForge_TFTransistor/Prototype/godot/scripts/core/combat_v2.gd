## CombatV2 — tick loop for the Phase 4 lane-runner.
## Autoload singleton (replaces dying combat.gd in Phase 5).
## Full impl in Phase 4 step 7.
##
## Tick resolution order (locked per spec §8.1):
##   1. status_decay  2. enemy_advance  3. hero_attack  4. reaction_resolve  5. death_cleanup
extends Node

## Emitted for each hero attack that lands (element_mediator subscribes).
signal hit_landed(hero_id: StringName, enemy: Dictionary, damage_tag: StringName)

const _Targeting = preload("res://scripts/core/combat_targeting.gd")

var _tick_order_log: Array = []  ## test probe: logs step names per tick
var _status_cache: Dictionary = {}  ## StringName status -> StatusData (lazy, for emit duration/stacks)

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

	## 1. Status decay (+ per-tick status damage: Burning -2, Shocked -1, Bleed 5% maxHP)
	_tick_order_log.append("decay")
	for enemy in gs.get("enemies", []):
		_apply_status_dot(enemy)
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
	## If the hero carries an equipped Active Function, resolve via the Function Matrix.
	## Otherwise fall back to the base-weapon stub (unequipped slice / legacy tests).
	if hero.get("active_fn", null) != null:
		_resolve_function_attack(hero, enemies, ls)
	else:
		_resolve_base_attack(hero, enemies, ls)

## Function-driven attack: targeting + damage tag + status emission + knockback per FunctionData.
## tier_mult (default 1.0) scales damage — wired by the forge in Q3.
func _resolve_function_attack(hero: Dictionary, enemies: Array, ls: Node) -> void:
	var fn = hero.get("active_fn")
	var lane: int = int(hero.get("lane", 1))
	var hero_x: float = float(hero.get("hero_x", 0.0))
	var targets: Array = _Targeting.resolve(fn.active_targeting, lane, hero_x, enemies, int(fn.active_max_hits))
	if targets.is_empty():
		return
	## Modifier socket warps the Active beneath it (spec §3 rule 2): +mod_dmg_bonus damage,
	## a secondary mod_adds_tag (extra reaction opportunity), and an extra mod_applies_status.
	var mod = hero.get("mod_fn")
	var dmg_mult: float = float(fn.active_dmg_mult)
	if mod != null:
		dmg_mult *= (1.0 + float(mod.mod_dmg_bonus))
	var tier_mult: float = float(hero.get("tier_mult", 1.0))
	var dmg: int = maxi(1, int(round(float(hero.get("base_dmg", 1)) * dmg_mult * tier_mult)))
	var tag: StringName = fn.active_damage_tag
	var status_emit: StringName = fn.active_status_emit
	var mod_tag: StringName = (mod.mod_adds_tag if mod != null else &"")
	var mod_status: StringName = (mod.mod_applies_status if mod != null else &"")
	for t in targets:
		t["hp"] = int(t["hp"]) - dmg
		if status_emit != &"":
			_emit_status(ls, t, status_emit)
		if mod_status != &"":
			_emit_status(ls, t, mod_status)
		if fn.active_knockback:
			ls.knockback_enemy(t)
		hit_landed.emit(hero.get("id", &""), t, tag)
		_dispatch_and_amplify(tag, t, dmg, ls, enemies)
		if mod_tag != &"":
			_dispatch_and_amplify(mod_tag, t, dmg, ls, enemies)

## Base-weapon stub: attack first enemy in hero's lane (or any if none in lane).
func _resolve_base_attack(hero: Dictionary, enemies: Array, ls: Node) -> void:
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
	_dispatch_and_amplify(tag, target, dmg, ls, enemies)

## Dispatch a reaction for a landed hit and apply its damage multiplier (spec §5) on top of
## the base hit, scaled by the target's Cracked dmg-amp (spec §4: +15%/stack). Cracked stacks are
## read BEFORE dispatch (a Cracked-triggered reaction may consume one). `enemies` enables splash.
func _dispatch_and_amplify(tag: StringName, target: Dictionary, base_hit: int, ls: Node, enemies: Array) -> void:
	var em := get_node_or_null("/root/ElementMediator")
	if em == null or tag == &"":
		return
	var cracked: int = int(ls.get_status_stacks(target, &"Cracked"))
	var rd = em.dispatch_reaction(tag, target, enemies)
	if rd == null:
		return
	var amp: float = 1.0 + 0.15 * float(cracked)
	var extra: int = int(round(float(base_hit) * (float(rd.dmg_mult) * amp - 1.0)))
	if extra > 0:
		target["hp"] = int(target["hp"]) - extra

## Per-tick status damage (spec §4): Burning -2/tick, Shocked -1/tick, Bleed 5% maxHP/tick.
## Sourced from StatusData (hp_dmg_per_tick + hp_dmg_pct_per_tick).
func _apply_status_dot(enemy: Dictionary) -> void:
	var statuses: Dictionary = enemy.get("statuses", {})
	if statuses.is_empty():
		return
	var total: int = 0
	for s in statuses.keys():
		var def = _status_def(s)
		if def == null:
			continue
		total += int(def.hp_dmg_per_tick)
		if float(def.hp_dmg_pct_per_tick) > 0.0:
			total += int(ceil(float(enemy.get("max_hp", 0)) * float(def.hp_dmg_pct_per_tick)))
	if total > 0:
		enemy["hp"] = int(enemy["hp"]) - total

## Emit a Function's status onto a target, sourcing duration + stack cap from StatusData (SSOT).
func _emit_status(ls: Node, target: Dictionary, status: StringName) -> void:
	var def = _status_def(status)
	var dur: int = int(def.base_duration) if def != null else 3
	var maxs: int = int(def.max_stacks) if def != null else 1
	ls.apply_status(target, status, dur, 1, maxs)

func _status_def(status: StringName):
	if not _status_cache.has(status):
		var p := "res://data/statuses/%s.tres" % String(status).to_lower()
		_status_cache[status] = load(p) if ResourceLoader.exists(p) else null
	return _status_cache[status]
