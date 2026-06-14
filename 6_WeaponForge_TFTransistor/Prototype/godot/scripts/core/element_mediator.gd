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
## Mutates enemy statuses per reaction spec on match.
func dispatch_reaction(damage_tag: StringName, enemy: Dictionary):
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
			_apply_reaction(rd, enemy, ls)
			reaction_triggered.emit(rd.id, enemy)
			if rd.vfx_hook != &"":
				vfx_triggered.emit(rd.vfx_hook, enemy)
			if rd.audio_hook != &"":
				audio_triggered.emit(rd.audio_hook, enemy)
			return rd
	return null

func _apply_reaction(rd, enemy: Dictionary, ls: Node) -> void:
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
