## ElementMediator — reacts incoming damage tags against enemy status lists.
## Autoload singleton. Full impl in Phase 4 step 6.
extends Node

const _ReactionDataScript: Script = preload("res://scripts/core/reaction_data.gd")

## Emitted when a reaction fires. combat_v2 + UltController subscribe.
signal reaction_triggered(reaction_id: StringName, origin_enemy: Dictionary)
## Emitted with reaction.vfx_hook on reaction fire. BattleView_v2 subscribes for temp flash.
## TODO Phase 5: replace stub flash with real VFX (Steam puff, Electrocute arc).
signal vfx_triggered(hook: StringName, origin_enemy: Dictionary)
## Emitted with reaction.audio_hook on reaction fire.
## TODO Phase 5: wire to AudioStreamPlayer once SFX assets land.
signal audio_triggered(hook: StringName, origin_enemy: Dictionary)

## reaction registry: StringName("{tag}x{status}") -> ReactionData
var _registry: Dictionary = {}
## StringName status -> base_duration (StatusData), for splash status application
var _status_dur_cache: Dictionary = {}

func _ready() -> void:
	_build_registry()

func reset() -> void:
	_build_registry()

func _build_registry() -> void:
	_registry = {}
	var dir := "res://data/reactions/"
	var da := DirAccess.open(dir)
	if da == null:
		return
	da.list_dir_begin()
	var fname := da.get_next()
	while fname != "":
		if fname.ends_with(".tres"):
			var res = load(dir + fname)
			if res != null and res.get_script() == _ReactionDataScript:
				var key := _key(res.trigger_tag, res.trigger_status)
				_registry[key] = res
		fname = da.get_next()

func _key(tag: StringName, status: StringName) -> StringName:
	return StringName(String(tag) + "x" + String(status))

## Check enemy status list against damage tag. Returns ReactionData or null.
## Mutates enemy statuses per reaction spec on match. `enemies` (the full live list) enables
## splash targeting (apply_splashed to cross-lane / own-lane-radius neighbours); pass [] to skip.
func dispatch_reaction(damage_tag: StringName, enemy: Dictionary, enemies: Array = []):
	var ls = get_node_or_null("/root/LaneState")
	if ls == null:
		return null
	## Priority order: Wet > Burning > Chilled > Cracked > Shocked (spec rule 6).
	## One reaction per hit: the FIRST status in priority order that has a registered
	## reaction for this tag fires. Cracked sits at priority 4 so a higher-priority status
	## (if it has a reaction for this tag) is consumed first and Cracked is left untouched
	## ("never consumed as a passenger"). Cracked only triggers its own reactions
	## (Magma Burst / Mudslide-W / Stonesmith) when nothing above it matched.
	var priority: Array[StringName] = [&"Wet", &"Burning", &"Chilled", &"Cracked", &"Shocked"]
	for status in priority:
		if not ls.has_status(enemy, status):
			continue
		var key := _key(damage_tag, status)
		if _registry.has(key):
			var rd = _registry[key]
			_apply_reaction(rd, enemy, ls, enemies)
			reaction_triggered.emit(rd.id, enemy)
			if rd.vfx_hook != &"":
				vfx_triggered.emit(rd.vfx_hook, enemy)
			if rd.audio_hook != &"":
				audio_triggered.emit(rd.audio_hook, enemy)
			return rd
	return null

func _apply_reaction(rd, enemy: Dictionary, ls: Node, enemies: Array = []) -> void:
	for s in rd.cleanse_origin:
		ls.cleanse_status(enemy, StringName(s))
	if rd.consume_cracked:
		ls.consume_status_stack(enemy, &"Cracked", 1)
	## Apply statuses to the origin (Frostbite→Chilled, Quench→Wet, Freeze Solid→Frozen,
	## Stonesmith→Shocked, Mudslide→Chilled-slow, Capacitor→refresh Shocked). After cleanse.
	for s in rd.apply_origin:
		ls.apply_status(enemy, StringName(s), rd.apply_origin_duration)
	if rd.knockback:
		ls.knockback_enemy(enemy)
	## Splash: apply each apply_splashed status to neighbouring enemies per the splash pattern
	## (cross_lane = nearest in each adjacent lane; own_lane_radius = nearest other in lane),
	## filtered by splash_filter (wet_only). spec §5.
	if rd.splash != &"none" and not rd.apply_splashed.is_empty() and not enemies.is_empty():
		for nb in _splash_targets(rd, enemy, enemies):
			for s in rd.apply_splashed:
				ls.apply_status(nb, StringName(s), _status_dur(StringName(s)))

func _splash_targets(rd, origin: Dictionary, enemies: Array) -> Array:
	var out: Array = []
	var ol: int = int(origin.lane)
	var ox: float = float(origin.screen_x)
	var lanes: Array = []
	if rd.splash == &"cross_lane":
		lanes = [ol - 1, ol + 1]
	elif rd.splash == &"own_lane_radius":
		lanes = [ol]
	else:
		return out
	for lane in lanes:
		var best = null
		var best_d := INF
		for e in enemies:
			if e == origin or int(e.lane) != lane:
				continue
			if rd.splash_filter == &"wet_only" and not e.get("statuses", {}).has(&"Wet"):
				continue
			var d := absf(float(e.screen_x) - ox)
			if d < best_d:
				best_d = d
				best = e
		if best != null:
			out.append(best)
	return out

func _status_dur(status: StringName) -> int:
	if not _status_dur_cache.has(status):
		var p := "res://data/statuses/%s.tres" % String(status).to_lower()
		var def = load(p) if ResourceLoader.exists(p) else null
		_status_dur_cache[status] = int(def.base_duration) if def != null else 2
	return _status_dur_cache[status]
