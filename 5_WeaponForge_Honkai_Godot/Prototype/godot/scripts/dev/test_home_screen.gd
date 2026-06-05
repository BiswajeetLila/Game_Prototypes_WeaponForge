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

	## #6 — a stale out-of-bounds selection must not crash the refresh (was OOB read).
	hs._selected_idx = 99
	hs._selected_hero = &""
	hs._refresh_hero_rows()
	hs._refresh_detail()
	_check("refresh survives an out-of-bounds selection (no crash)", true, "")

	hs.queue_free()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

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
