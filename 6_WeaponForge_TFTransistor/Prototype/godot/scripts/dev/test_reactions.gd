## Tests for ReactionData resources — step 5.
extends Control

const _ReactionScript = preload("res://scripts/core/reaction_data.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== ReactionData tests ===")
	_test_load_all()
	_test_all_15_load()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_load_all() -> void:
	var steam = load("res://data/reactions/steam.tres")
	_check("steam loads", steam != null and steam.get_script() == _ReactionScript, "path missing or wrong type")
	if steam != null:
		_check("steam id", steam.id == &"Steam", "got %s" % steam.id)
		_check("steam trigger_tag FIRE", steam.trigger_tag == &"FIRE", "got %s" % steam.trigger_tag)
		_check("steam trigger_status Wet", steam.trigger_status == &"Wet", "got %s" % steam.trigger_status)
		_check("steam dmg_mult 1.0", is_equal_approx(steam.dmg_mult, 1.0), "got %f" % steam.dmg_mult)
		_check("steam splash cross_lane", steam.splash == &"cross_lane", "got %s" % steam.splash)
		_check("steam cleanse Wet+Burning", steam.cleanse_origin.has("Wet") and steam.cleanse_origin.has("Burning"), "got %s" % str(steam.cleanse_origin))
		_check("steam apply Blind to splash", steam.apply_splashed.has("Blind"), "got %s" % str(steam.apply_splashed))
		_check("steam vfx_hook", steam.vfx_hook == &"vfx_steam_puff", "got %s" % steam.vfx_hook)

	var elec = load("res://data/reactions/electrocute.tres")
	_check("electrocute loads", elec != null and elec.get_script() == _ReactionScript, "path missing or wrong type")
	if elec != null:
		_check("electrocute id", elec.id == &"Electrocute", "got %s" % elec.id)
		_check("electrocute trigger_tag LIGHTNING", elec.trigger_tag == &"LIGHTNING", "got %s" % elec.trigger_tag)
		_check("electrocute trigger_status Wet", elec.trigger_status == &"Wet", "got %s" % elec.trigger_status)
		_check("electrocute dmg_mult 2.0", is_equal_approx(elec.dmg_mult, 2.0), "got %f" % elec.dmg_mult)
		_check("electrocute splash cross_lane", elec.splash == &"cross_lane", "got %s" % elec.splash)
		_check("electrocute splash_filter wet_only", elec.splash_filter == &"wet_only", "got %s" % elec.splash_filter)
		_check("electrocute cleanse Wet", elec.cleanse_origin.has("Wet"), "got %s" % str(elec.cleanse_origin))
		_check("electrocute apply Shocked to splash", elec.apply_splashed.has("Shocked"), "got %s" % str(elec.apply_splashed))

## All 15 reactions (spec §5) load with correct trigger + dmg_mult.
func _test_all_15_load() -> void:
	## file -> [id, trigger_tag, trigger_status, dmg_mult]
	var specs := {
		"steam":        [&"Steam",        &"FIRE",      &"Wet",     1.0],
		"thaw":         [&"Thaw",         &"FIRE",      &"Chilled", 1.5],
		"magma_burst":  [&"Magma Burst",  &"FIRE",      &"Cracked", 1.8],
		"freeze_solid": [&"Freeze Solid", &"ICE",       &"Wet",     1.5],
		"frostbite":    [&"Frostbite",    &"ICE",       &"Burning", 1.3],
		"capacitor":    [&"Capacitor",    &"ICE",       &"Shocked", 1.4],
		"quench":       [&"Quench",       &"WATER",     &"Burning", 0.8],
		"backsplash":   [&"Backsplash",   &"WATER",     &"Shocked", 0.5],
		"mudslide_w":   [&"Mudslide W",   &"WATER",     &"Cracked", 1.2],
		"mudslide_e":   [&"Mudslide E",   &"EARTH",     &"Wet",     1.4],
		"ash_cloud":    [&"Ash Cloud",    &"EARTH",     &"Burning", 1.2],
		"avalanche":    [&"Avalanche",    &"EARTH",     &"Chilled", 1.6],
		"electrocute":  [&"Electrocute",  &"LIGHTNING", &"Wet",     2.0],
		"stonesmith":   [&"Stonesmith",   &"LIGHTNING", &"Cracked", 2.0],
		"arc_storm":    [&"Arc Storm",    &"LIGHTNING", &"Burning", 1.5],
	}
	for fname in specs:
		var path := "res://data/reactions/%s.tres" % fname
		var res = load(path)
		_check("%s loads" % fname, res != null and res.get_script() == _ReactionScript, "path=%s" % path)
		if res == null or res.get_script() != _ReactionScript:
			continue
		var s: Array = specs[fname]
		_check("%s id" % fname, res.id == s[0], "got %s" % res.id)
		_check("%s trigger_tag" % fname, res.trigger_tag == s[1], "got %s" % res.trigger_tag)
		_check("%s trigger_status" % fname, res.trigger_status == s[2], "got %s" % res.trigger_status)
		_check("%s dmg_mult" % fname, is_equal_approx(res.dmg_mult, s[3]), "got %f" % res.dmg_mult)

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
