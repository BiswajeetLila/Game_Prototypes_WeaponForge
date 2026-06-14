## C1 — socket index convention PASSIVE|MODIFIER|ACTIVE (idx 0=PASSIVE, 2=ACTIVE).
## Visual leftmost == data index 0 == PASSIVE. Routing: leftmost socket emits idx 0.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []
var _tap_capture: Array = []

func _ready() -> void:
	_log("=== socket order tests ===")
	_test_label_order()
	_test_header_order()
	_test_routing_leftmost_is_zero()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_label_order() -> void:
	var fp = load("res://scripts/ui/forge_panel_v2.gd")
	_check("forge_panel script loads", fp != null, "")
	if fp == null:
		return
	var labels = fp.SOCKET_LABELS
	_check("SOCKET_LABELS[0] == PASSIVE", labels[0] == "PASSIVE", "got %s" % str(labels[0]))
	_check("SOCKET_LABELS[1] == MODIFIER", labels[1] == "MODIFIER", "got %s" % str(labels[1]))
	_check("SOCKET_LABELS[2] == ACTIVE", labels[2] == "ACTIVE", "got %s" % str(labels[2]))

func _test_header_order() -> void:
	var packed = load("res://scenes/ui/ForgePanel_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	var header = inst.get_node_or_null("SocketHeader")
	_check("SocketHeader exists", header != null, "")
	if header != null and header.get_child_count() >= 3:
		var first = header.get_child(0) as Label
		_check("leftmost header label == PASSIVE", first != null and first.text == "PASSIVE", "got %s" % (first.text if first != null else "null"))
	inst.queue_free()

func _test_routing_leftmost_is_zero() -> void:
	var packed = load("res://scenes/ui/ForgePanel_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_tap_capture.clear()
	inst.socket_tapped.connect(_on_socket_tapped)
	var sock = inst.find_child("Socket0_0", true, false)
	var tap = sock.find_child("TapArea", true, false) if sock != null else null
	_check("Socket0_0 + TapArea exist", tap != null, "")
	if tap != null:
		## socket uses a tap/long-press gesture now: quick down+up == a tap
		tap.button_down.emit()
		tap.button_up.emit()
		_check("leftmost socket emits socket_idx 0 (=PASSIVE)", _tap_capture.size() == 1 and _tap_capture[0] == 0,
			"got %s" % str(_tap_capture))
	inst.socket_tapped.disconnect(_on_socket_tapped)
	inst.queue_free()

func _on_socket_tapped(_hero_idx: int, socket_idx: int) -> void:
	_tap_capture.append(socket_idx)

func _check(name: String, ok: bool, detail: String) -> void:
	if ok: _passed += 1; _log("  PASS  " + name)
	else: _failed += 1; _log("  FAIL  " + name + (("  [" + detail + "]") if detail != "" else ""))

func _summary() -> void:
	_log("=== %d passed / %d failed ===" % [_passed, _failed])

func _log(line: String) -> void:
	print(line)
	_lines.append(line)

func _render_to_ui() -> void:
	var label := Label.new()
	label.text = "\n".join(_lines)
	add_child(label)
