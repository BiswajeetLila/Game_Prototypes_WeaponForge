## ElementMediator — reacts incoming damage tags against enemy status lists.
## Autoload singleton. Full impl in Phase 4 step 6.
extends Node

const _ReactionDataScript: Script = preload("res://scripts/core/reaction_data.gd")

## Emitted when a reaction fires. combat_v2 + UltController subscribe.
signal reaction_triggered(reaction_id: StringName, origin_enemy: Dictionary)

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
	## Priority order: Wet > Burning > Chilled > Cracked > Shocked
	var priority: Array[StringName] = [&"Wet", &"Burning", &"Chilled", &"Cracked", &"Shocked"]
	for status in priority:
		if not ls.has_status(enemy, status):
			continue
		## Cracked is never consumed by reaction priority — skip as trigger
		if status == &"Cracked":
			continue
		var key := _key(damage_tag, status)
		if _registry.has(key):
			var rd = _registry[key]
			_apply_reaction(rd, enemy, ls)
			reaction_triggered.emit(rd.id, enemy)
			return rd
	return null

func _apply_reaction(rd, enemy: Dictionary, ls: Node) -> void:
	for s in rd.cleanse_origin:
		ls.cleanse_status(enemy, StringName(s))
