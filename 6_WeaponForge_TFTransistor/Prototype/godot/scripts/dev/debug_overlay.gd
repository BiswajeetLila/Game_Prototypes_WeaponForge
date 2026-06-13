## DebugOverlay — dev/QA hotkeys per spec §16.
## Autoload singleton. Only active in debug builds.
## F8  = Reaction log scrubber (last 50 reactions)
## F9  = Spawn override (1 enemy in lane 1)
## F10 = Tier override (cycle shop weights)
## F11 = FTUE skip (set ftue_complete=true, restart run)
## F12 = Debug overlay (enemy status list + screen-x)
extends Node

var visible: bool = false
var _reaction_log: Array = []  ## last 50 reaction ids

func _ready() -> void:
	if not OS.is_debug_build():
		return
	var em := get_node_or_null("/root/ElementMediator")
	if em != null:
		em.reaction_triggered.connect(_on_reaction)

func _input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_F8:
				_toggle_reaction_log()
			KEY_F11:
				_ftue_skip()
			KEY_F12:
				visible = !visible

func _on_reaction(reaction_id: StringName, _enemy: Dictionary) -> void:
	_reaction_log.append(reaction_id)
	if _reaction_log.size() > 50:
		_reaction_log.pop_front()

func _toggle_reaction_log() -> void:
	pass  ## stub — Phase 4 UI pass

func _ftue_skip() -> void:
	var acc := get_node_or_null("/root/AccountState")
	if acc == null:
		return
	acc.ftue_complete = true
	acc.save_account()
