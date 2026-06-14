## Integration tests for ElementMediator — step 6.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

## Captured signal payloads for step 16 VFX/audio hook tests.
var _vfx_emits: Array = []
var _audio_emits: Array = []

func _ready() -> void:
	_log("=== ElementMediator tests ===")
	_test_dispatch_steam()
	_test_dispatch_electrocute()
	_test_cracked_not_consumed()
	_test_no_match()
	_test_priority_wet_over_burning()
	_test_vfx_signal_emits()
	_test_audio_signal_emits()
	_test_no_emit_when_no_reaction()
	_test_full_matrix_15()
	_test_apply_origin_quench()
	_test_consume_cracked_magma()
	_test_refresh_capacitor()
	_test_knockback_avalanche()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _capture_vfx(hook: StringName, _enemy: Dictionary) -> void:
	_vfx_emits.append(hook)

func _capture_audio(hook: StringName, _enemy: Dictionary) -> void:
	_audio_emits.append(hook)

func _test_vfx_signal_emits() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	_vfx_emits.clear()
	em.connect("vfx_triggered", _capture_vfx)
	var e = ls.make_enemy(&"g", 1, 0.5)
	ls.apply_status(e, &"Wet", 4)
	em.dispatch_reaction(&"FIRE", e)
	em.disconnect("vfx_triggered", _capture_vfx)
	_check("vfx_triggered emits steam hook on FIRE x Wet",
		_vfx_emits.size() == 1 and _vfx_emits[0] == &"vfx_steam_puff",
		"got %s" % str(_vfx_emits))

func _test_audio_signal_emits() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	_audio_emits.clear()
	em.connect("audio_triggered", _capture_audio)
	var e = ls.make_enemy(&"g", 1, 0.5)
	ls.apply_status(e, &"Wet", 4)
	em.dispatch_reaction(&"LIGHTNING", e)
	em.disconnect("audio_triggered", _capture_audio)
	_check("audio_triggered emits electrocute hook on LIGHTNING x Wet",
		_audio_emits.size() == 1 and _audio_emits[0] == &"sfx_electrocute_zap",
		"got %s" % str(_audio_emits))

func _test_no_emit_when_no_reaction() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	_vfx_emits.clear()
	_audio_emits.clear()
	em.connect("vfx_triggered", _capture_vfx)
	em.connect("audio_triggered", _capture_audio)
	var e = ls.make_enemy(&"g", 1, 0.5)
	## No status -> no reaction -> no emits
	em.dispatch_reaction(&"FIRE", e)
	em.disconnect("vfx_triggered", _capture_vfx)
	em.disconnect("audio_triggered", _capture_audio)
	_check("no reaction: vfx_triggered not emitted", _vfx_emits.is_empty(), "got %s" % str(_vfx_emits))
	_check("no reaction: audio_triggered not emitted", _audio_emits.is_empty(), "got %s" % str(_audio_emits))

func _test_dispatch_steam() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var e = ls.make_enemy(&"g", 1, 0.5)
	ls.apply_status(e, &"Wet", 4)
	var rd =em.dispatch_reaction(&"FIRE", e)
	_check("FIRE x Wet = Steam", rd != null and rd.id == &"Steam", "got %s" % (str(rd.id) if rd else "null"))
	_check("Steam: Wet cleansed from origin", not ls.has_status(e, &"Wet"), "")

func _test_dispatch_electrocute() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var e = ls.make_enemy(&"g", 1, 0.5)
	ls.apply_status(e, &"Wet", 4)
	var rd =em.dispatch_reaction(&"LIGHTNING", e)
	_check("LIGHTNING x Wet = Electrocute", rd != null and rd.id == &"Electrocute", "got %s" % (str(rd.id) if rd else "null"))
	_check("Electrocute: Wet cleansed", not ls.has_status(e, &"Wet"), "")
	_check("Electrocute dmg_mult 2.0", rd != null and is_equal_approx(rd.dmg_mult, 2.0), "")

func _test_cracked_not_consumed() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var e = ls.make_enemy(&"g", 1, 0.5)
	ls.apply_status(e, &"Wet", 4)
	ls.apply_status(e, &"Cracked", 4, 2, 3)
	var rd =em.dispatch_reaction(&"LIGHTNING", e)
	_check("Cracked present: LIGHTNING x Wet still = Electrocute", rd != null and rd.id == &"Electrocute", "got %s" % (str(rd.id) if rd else "null"))
	_check("Cracked stacks NOT consumed", ls.get_status_stacks(e, &"Cracked") == 2, "got %d" % ls.get_status_stacks(e, &"Cracked"))

func _test_no_match() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var e = ls.make_enemy(&"g", 1, 0.5)
	## No status on enemy
	var rd =em.dispatch_reaction(&"FIRE", e)
	_check("no status: no reaction", rd == null, "got %s" % (str(rd.id) if rd else "null"))

	## Tag x status genuinely absent from the matrix (spec §5 "not in matrix" list): FIRE x Burning.
	ls.apply_status(e, &"Burning", 3)
	rd = em.dispatch_reaction(&"FIRE", e)
	_check("FIRE x Burning: not in matrix -> base dmg only", rd == null, "got %s" % (str(rd.id) if rd else "null"))

func _test_priority_wet_over_burning() -> void:
	## Wet takes priority (Wet > Burning per spec §8.1)
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var e = ls.make_enemy(&"g", 1, 0.5)
	ls.apply_status(e, &"Wet", 4)
	ls.apply_status(e, &"Burning", 3)
	var rd =em.dispatch_reaction(&"FIRE", e)
	_check("FIRE + Wet+Burning: Steam fires (Wet priority)", rd != null and rd.id == &"Steam", "got %s" % (str(rd.id) if rd else "null"))

## Each of the 15 reactions fires under its correct (tag × status) input (spec §5).
func _test_full_matrix_15() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var matrix := [
		[&"FIRE", &"Wet", &"Steam"],
		[&"FIRE", &"Chilled", &"Thaw"],
		[&"FIRE", &"Cracked", &"Magma Burst"],
		[&"ICE", &"Wet", &"Freeze Solid"],
		[&"ICE", &"Burning", &"Frostbite"],
		[&"ICE", &"Shocked", &"Capacitor"],
		[&"WATER", &"Burning", &"Quench"],
		[&"WATER", &"Shocked", &"Backsplash"],
		[&"WATER", &"Cracked", &"Mudslide W"],
		[&"EARTH", &"Wet", &"Mudslide E"],
		[&"EARTH", &"Burning", &"Ash Cloud"],
		[&"EARTH", &"Chilled", &"Avalanche"],
		[&"LIGHTNING", &"Wet", &"Electrocute"],
		[&"LIGHTNING", &"Cracked", &"Stonesmith"],
		[&"LIGHTNING", &"Burning", &"Arc Storm"],
	]
	for row in matrix:
		var e = ls.make_enemy(&"g", 1, 0.5)
		if row[1] == &"Cracked":
			ls.apply_status(e, row[1], 4, 1, 3)
		else:
			ls.apply_status(e, row[1], 4)
		var rd = em.dispatch_reaction(row[0], e)
		_check("%s x %s = %s" % [row[0], row[1], row[2]],
			rd != null and rd.id == row[2], "got %s" % (str(rd.id) if rd else "null"))

func _test_apply_origin_quench() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var e = ls.make_enemy(&"g", 1, 0.5)
	ls.apply_status(e, &"Burning", 3)
	var rd = em.dispatch_reaction(&"WATER", e)
	_check("Quench fires (WATER x Burning)", rd != null and rd.id == &"Quench", "got %s" % (str(rd.id) if rd else "null"))
	_check("Quench cleanses Burning", not ls.has_status(e, &"Burning"), "")
	_check("Quench applies Wet to origin", ls.has_status(e, &"Wet"), "")

func _test_consume_cracked_magma() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var e = ls.make_enemy(&"g", 1, 0.5)
	ls.apply_status(e, &"Cracked", 4, 2, 3)  ## 2 stacks
	var rd = em.dispatch_reaction(&"FIRE", e)
	_check("Magma Burst fires (FIRE x Cracked)", rd != null and rd.id == &"Magma Burst", "got %s" % (str(rd.id) if rd else "null"))
	_check("Magma consumes 1 Cracked stack (2->1)", ls.get_status_stacks(e, &"Cracked") == 1, "got %d" % ls.get_status_stacks(e, &"Cracked"))

func _test_refresh_capacitor() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var e = ls.make_enemy(&"g", 1, 0.5)
	ls.apply_status(e, &"Shocked", 1)  ## about to expire
	var rd = em.dispatch_reaction(&"ICE", e)
	_check("Capacitor fires (ICE x Shocked)", rd != null and rd.id == &"Capacitor", "got %s" % (str(rd.id) if rd else "null"))
	_check("Capacitor refreshes Shocked to 2x base (4 ticks)",
		e.statuses.has(&"Shocked") and int(e.statuses[&"Shocked"]["ticks"]) == 4,
		"got %s" % (str(e.statuses.get(&"Shocked", {}))))

func _test_knockback_avalanche() -> void:
	var ls = get_node("/root/LaneState")
	var em = get_node("/root/ElementMediator")
	var e = ls.make_enemy(&"g", 1, 0.3)
	ls.apply_status(e, &"Chilled", 3)
	var x0: float = e.screen_x
	var rd = em.dispatch_reaction(&"EARTH", e)
	_check("Avalanche fires (EARTH x Chilled)", rd != null and rd.id == &"Avalanche", "got %s" % (str(rd.id) if rd else "null"))
	_check("Avalanche cleanses Chilled", not ls.has_status(e, &"Chilled"), "")
	_check("Avalanche knocks origin back", e.screen_x > x0, "x0=%f now=%f" % [x0, e.screen_x])

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
