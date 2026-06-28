## InventoryItem — a runtime instance of an owned part.
## Carries a stable uid (for animations + selection), the part_id (key into
## the PartData catalog) and a level 1..5 (per merge_mechanic.md).
##
## NOT a Resource — this is per-run state, lives only in GameState.inventory
## or pinned into Weapon slots. Plain RefCounted so it gets garbage-collected
## when no longer referenced.
class_name InventoryItem
extends RefCounted

const LEVEL_CAP: int = 5

var uid: int = 0
var part_id: StringName = &""
var level: int = 1

func _init(p_uid: int = 0, p_part_id: StringName = &"", p_level: int = 1) -> void:
	uid = p_uid
	part_id = p_part_id
	level = clampi(p_level, 1, LEVEL_CAP)

func level_up() -> bool:
	if level >= LEVEL_CAP:
		return false
	level += 1
	return true

func to_dict() -> Dictionary:
	return {"uid": uid, "part_id": String(part_id), "level": level}
