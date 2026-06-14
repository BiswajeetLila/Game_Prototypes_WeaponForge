## Tests for CombatV2 tick order — step 7.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== CombatV2 tests ===")
	_test_tick_order()
	_test_enemy_dies_in_cleanup()
	_test_status_decays_before_advance()
	_test_contact_damage()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_tick_order() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	cv2.reset()
	var e = ls.make_enemy(&"t", 1, 0.5)
	var hero = {"id": &"bran", "lane": 1, "base_dmg": 0, "damage_tag": &""}
	var gs = {"enemies": [e], "heroes": [hero], "lane_state": ls}
	cv2.tick(gs)
	var log: Array = cv2._tick_order_log
	_check("tick order: decay before advance", log.find("decay") < log.find("advance"), "log=%s" % str(log))
	_check("tick order: advance before attack", log.find("advance") < log.find("attack"), "log=%s" % str(log))
	_check("tick order: attack before react", log.find("attack") < log.find("react"), "log=%s" % str(log))
	_check("tick order: react before cleanup", log.find("react") < log.find("cleanup"), "log=%s" % str(log))

func _test_enemy_dies_in_cleanup() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	var e = ls.make_enemy(&"goblin", 1, 0.5, 1)  ## hp=1
	var hero = {"id": &"bran", "lane": 1, "base_dmg": 5, "damage_tag": &""}
	var gs = {"enemies": [e], "heroes": [hero], "lane_state": ls}
	cv2.tick(gs)
	_check("enemy with 0 hp removed in cleanup", gs["enemies"].size() == 0, "size=%d" % gs["enemies"].size())

func _test_status_decays_before_advance() -> void:
	## enemy has Frozen (no advance); after decay Frozen removed; in SAME tick advance applies normal speed
	## After tick: decay removes Frozen, THEN advance uses walk_speed
	## => enemy moves. Without decay-before-advance it wouldn't.
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	var e = ls.make_enemy(&"t", 1, 0.5)
	ls.apply_status(e, &"Frozen", 1)  ## 1 tick left -> decays to 0 this tick, removed before advance
	var hero = {"id": &"bran", "lane": 1, "base_dmg": 0, "damage_tag": &""}
	var gs = {"enemies": [e], "heroes": [hero], "lane_state": ls}
	cv2.tick(gs)
	## After decay: Frozen gone; after advance: screen_x = 0.5 - 0.05 = 0.45
	_check("decay-before-advance: Frozen expires + enemy moves this tick",
		is_equal_approx(e.screen_x, 0.45), "got %f" % e.screen_x)

func _test_contact_damage() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	var e = ls.make_enemy(&"g", 1, 0.0)  ## at hero anchor
	e.engaged = true
	var hero = {"id": &"bran", "lane": 1, "base_dmg": 0, "damage_tag": &"", "hp": 30, "max_hp": 30}
	var gs = {"enemies": [e], "heroes": [hero], "lane_state": ls}
	cv2.tick(gs)
	_check("contact: engaged enemy damages lane hero", int(hero.hp) < 30, "got %d" % int(hero.hp))
	## tick order still 4 phases (contact folded into advance, not a new logged step)
	_check("contact: tick order unchanged (no extra step)", cv2._tick_order_log.size() == 5, "got %s" % str(cv2._tick_order_log))

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
	label.offset_left = 12; label.offset_top = 12
	add_child(label)
