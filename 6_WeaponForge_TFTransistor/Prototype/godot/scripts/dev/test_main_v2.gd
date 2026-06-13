## Integration tests for Main_v2 — the composed slice + game-loop controller (A4/A5).
## Drives the full post-FTUE run (5 stages x 3 waves = 15) through the controller,
## headless + deterministic (no Timer). Proves composition + state machine + loop.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== Main_v2 controller tests ===")
	_test_composition()
	_test_full_run_loop()
	_test_equip_and_merge()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_composition() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	_check("main_v2: scene loads", packed != null, "Main_v2.tscn missing")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("main_v2: HudBar exists", inst.get_node_or_null("HudBar") != null, "")
	_check("main_v2: battlefield composed (Field present)", inst.find_child("Field", true, false) != null, "")
	_check("main_v2: forge composed (ShopRail present)", inst.find_child("ShopRail", true, false) != null, "")
	_check("main_v2: NextWaveBtn exists", inst.get_node_or_null("NextWaveBtn") != null, "")
	_check("main_v2: starts in COMBAT", inst.has_method("is_combat") and inst.is_combat(), "")
	_check("main_v2: NextWaveBtn hidden during combat", inst.get_node_or_null("NextWaveBtn") != null and inst.get_node("NextWaveBtn").visible == false, "")
	var ls = get_node_or_null("/root/LaneState")
	_check("main_v2: first wave spawned enemies", ls != null and ls.enemies.size() > 0, "got %d" % (ls.enemies.size() if ls != null else -1))
	inst.queue_free()

func _test_full_run_loop() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		_check("main_v2: full-run prerequisites", false, "scene missing")
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("main_v2: run begins in COMBAT", inst.is_combat(), "")
	var guard: int = 0
	while not inst.is_done() and guard < 6000:
		if inst.is_combat():
			inst._tick_once()
		elif inst.is_forge_break():
			inst.advance_wave()
		guard += 1
	_check("main_v2: run reaches DONE", inst.is_done(), "guard=%d state=%d" % [guard, inst.state])
	_check("main_v2: played 15 waves (5 stages x 3)", inst.waves_played == 15, "got %d" % inst.waves_played)
	_check("main_v2: did not hit guard ceiling", guard < 6000, "guard=%d" % guard)
	inst.queue_free()

func _test_equip_and_merge() -> void:
	var packed = load("res://scenes/Main_v2.tscn")
	if packed == null:
		return
	var inst = packed.instantiate()
	add_child(inst)
	_check("main_v2: has _on_shop_tap", inst.has_method("_on_shop_tap"), "")
	_check("main_v2: has _on_socket_tap", inst.has_method("_on_socket_tap"), "")
	_check("main_v2: has get_socket", inst.has_method("get_socket"), "")
	if not (inst.has_method("_on_shop_tap") and inst.has_method("_on_socket_tap") and inst.has_method("get_socket")):
		inst.queue_free()
		return
	## tap shop slot 0 (FIRE), then hero 0 socket 0 -> equips FIRE t1
	inst._on_shop_tap(0)
	inst._on_socket_tap(0, 0)
	var s = inst.get_socket(0, 0)
	_check("main_v2: equip places FIRE in socket", s != null and s.id == &"FIRE", "got %s" % str(s))
	## tap FIRE again onto same socket -> merge to t2
	inst._on_shop_tap(0)
	inst._on_socket_tap(0, 0)
	s = inst.get_socket(0, 0)
	_check("main_v2: re-equip same -> merge t2", s != null and s.tier == 2, "got %s" % str(s))
	inst.queue_free()

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
	label.add_theme_font_size_override(&"font_size", 12)
	label.text = "\n".join(_lines)
	label.anchor_right = 1.0; label.anchor_bottom = 1.0
	add_child(label)
