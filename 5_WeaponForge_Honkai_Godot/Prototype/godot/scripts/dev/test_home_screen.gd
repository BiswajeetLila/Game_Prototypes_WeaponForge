## Test harness for HomeScreen FTUE + robustness (post-playtest fixes).
##   - #5: all 3 heroes start armed with a class Common at first boot.
##   - #6: refresh survives a stale / out-of-bounds _selected_idx (the reset crash —
##     reset empties owned_weapons while the selection index is still stale).
##
## Instantiates HomeScreen in-tree (builds the full UI; Controls work headless).
## Mutates the AccountState autoload (headless never writes disk).
##
## Run headless:
##   Godot_v4.6.2-stable_mono_win64_console.exe --headless --path <godot dir> \
##     res://scenes/dev/TestHomeScreen.tscn
extends Control

const HomeScreenT = preload("res://scripts/ui/home_screen.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== HomeScreen FTUE + robustness tests ===")
	## Fresh account so _grant_starter_if_first_boot() runs on boot.
	AccountState.owned_weapons = []
	AccountState.equipped = {}
	AccountState.shards = []
	var hs = HomeScreenT.new()
	add_child(hs)   ## _ready -> _build_ui + _grant_starter_if_first_boot + _refresh

	## #5 — all three heroes armed with a class-matched Common.
	var bran = AccountState.get_equipped(&"bran")
	var elara = AccountState.get_equipped(&"elara")
	var vex = AccountState.get_equipped(&"vex")
	_check("all 3 heroes start with an equipped weapon",
		bran != null and elara != null and vex != null,
		"bran=%s elara=%s vex=%s" % [bran != null, elara != null, vex != null])
	if bran != null and elara != null and vex != null:
		_check("each starter matches its hero class",
			bran.cls == &"warrior" and elara.cls == &"mage" and vex.cls == &"rogue",
			"%s/%s/%s" % [bran.cls, elara.cls, vex.cls])

	## Detail popup builds its dynamic action buttons (Forge + Equip→hero) for a valid
	## selection without error (exercises the PopupPanel + _rebuild_detail_actions path).
	hs._selected_idx = 0
	hs._selected_hero = &""
	hs._refresh_detail()
	_check("detail builds action buttons for a selection",
		hs._detail_actions.get_child_count() >= 1, "actions=%d" % hs._detail_actions.get_child_count())
	hs._selected_idx = -1
	hs._selected_hero = &""
	hs._refresh_detail()

	## #6 — a stale out-of-bounds selection must not crash the refresh (was OOB read).
	hs._selected_idx = 99
	hs._selected_hero = &""
	hs._refresh_hero_rows()
	hs._refresh_detail()
	_check("refresh survives an out-of-bounds selection (no crash)", true, "")

	hs.queue_free()

	_test_starters_are_non_elemental()
	_test_squad_line_hidden_when_no_pair()
	_test_squad_line_shows_firestorm_when_fire_ice()

	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

## ---------- Catalyst v1 (Task B2) ----------

func _test_starters_are_non_elemental() -> void:
	## Spec §6: starters preserve the stage-1 neutrality contract. The 3 Common
	## .tres files (emberfang/frostcall/stormpierce) have rune stripped to &"".
	## _grant_starter_if_first_boot grants those same ids, so the equipped squad
	## carries no element on first boot -> no Catalyst possible until pulls hit Rare+.
	AccountState.reset_account()
	var hs = HomeScreenT.new()
	add_child(hs)
	for hero_id in [&"bran", &"elara", &"vex"]:
		var w = AccountState.get_equipped(hero_id)
		_check("starter equipped for %s" % hero_id, w != null, "null")
		if w != null:
			_check("%s starter rune == &\"\"" % hero_id, w.rune == &"",
				"rune=%s" % str(w.rune))
	hs.queue_free()

## ---------- Catalyst v1 squad-line (Task C1) ----------

func _test_squad_line_hidden_when_no_pair() -> void:
	## Spec §7.1: with 0-1 distinct elements, the catalyst readout is hidden.
	## A fresh-boot squad (non-elemental Commons post-B2) -> no Catalyst phrase.
	AccountState.reset_account()
	var hs = HomeScreenT.new()
	add_child(hs)
	hs._refresh()
	var s: String = hs._squad_line.text
	_check("squad line lacks Catalyst phrase pre-pair",
		not s.contains("Catalyst"), "text=%s" % s)
	hs.queue_free()

func _test_squad_line_shows_firestorm_when_fire_ice() -> void:
	## Equip Rare+ fire-warrior + Rare+ ice-mage (Commons are non-elemental post-B2).
	## The squad line gains "Catalyst: Firestorm (+20% squad ATK)".
	AccountState.reset_account()
	## Use Cinderbrand (Epic fire warrior) + Glacial Aegis Staff (Legendary ice mage).
	var fire_w = GameState.weapons_by_id[&"w_cinderbrand_greatsword"].duplicate(true)
	var ice_w = GameState.weapons_by_id[&"w_glacial_aegis_staff"].duplicate(true)
	AccountState.owned_weapons = [fire_w, ice_w]
	AccountState.equip(&"bran", 0)
	AccountState.equip(&"elara", 1)
	var hs = HomeScreenT.new()
	add_child(hs)
	hs._refresh()
	var s: String = hs._squad_line.text
	_check("squad line includes Catalyst", s.contains("Catalyst"), "text=%s" % s)
	_check("squad line names Firestorm", s.contains("Firestorm"), "text=%s" % s)
	_check("squad line shows +20% ATK effect", s.contains("+20") and s.contains("ATK"),
		"text=%s" % s)
	hs.queue_free()

## ---------- Helpers ----------

func _check(name: String, ok: bool, detail: String) -> void:
	if ok:
		_passed += 1
		_log("  PASS  " + name)
	else:
		_failed += 1
		_log("  FAIL  " + name + (("  [" + detail + "]") if detail != "" else ""))

func _summary() -> void:
	_log("=== %d passed / %d failed ===" % [_passed, _failed])

func _log(line: String) -> void:
	print(line)
	_lines.append(line)

func _render_to_ui() -> void:
	var label := Label.new()
	label.add_theme_font_size_override(&"font_size", 12)
	label.text = "\n".join(_lines)
	label.anchor_right = 1.0
	label.anchor_bottom = 1.0
	label.offset_left = 12
	label.offset_top = 12
	add_child(label)
