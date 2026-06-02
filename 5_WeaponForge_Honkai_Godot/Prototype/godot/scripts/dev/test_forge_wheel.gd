## Test harness for the ForgeWheel pull service + starter weapon catalog (increment #2).
##
## Catalog curve (entry contract #4): a 3-slot L1 socket kit contributes ~12-16 atk
## (h_iron_edge 8 + p_steel_grip 4 + rune 0-4), so every starter catalog weapon
## carries atk >= 16 — first equip is never a downgrade vs an early kit.
##
## Pull flow under test: spend AccountState.PULL_COST gems -> pick from the catalog
## filtered to UNLOCKED classes -> AccountState.acquire_weapon (runtime duplicate)
## -> GameState.equip_weapon_data on the first matching-class hero -> result dict
## {weapon, hero_id, old_atk, new_atk} for the reveal's before/after damage delta.
## Insufficient gems or no eligible weapon -> {} and ZERO state change.
##
## Run headless:
##   Godot_v4.6.2-stable_mono_win64_console.exe --headless --path <godot dir> \
##     res://scenes/dev/TestForgeWheel.tscn
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []
var _pull_signal_count: int = 0
var _pull_signal_result: Dictionary = {}

func _ready() -> void:
	_log("=== ForgeWheel + starter catalog (#2) tests ===")
	if not ("weapons_by_id" in GameState):
		_check("GameState has weapons_by_id catalog", false, "property missing (RED)")
	else:
		_test_catalog_loaded_and_covers_classes()
		_test_catalog_meets_curve()
	## ForgeWheel autoload is looked up via /root path (parse-safe while unregistered).
	if get_node_or_null("/root/ForgeWheel") == null:
		_check("ForgeWheel autoload registered", false, "missing (RED)")
	else:
		_test_pull_happy_path()
		_test_pull_insufficient_gems()
		_test_pull_class_filtered_to_unlocked()
		_test_second_pull_goes_to_bench()
		_test_pull_signal()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

## ---------- Fixtures ----------

func _wheel():
	return get_node("/root/ForgeWheel")

func _reset_account(gems: int = 600) -> void:
	AccountState.gems = gems
	AccountState.owned_weapons = []
	AccountState.equipped = {}

func _fresh(gems: int = 600):
	GameState.new_session()      ## bran only (warrior)
	_reset_account(gems)
	return GameState.get_hero(&"bran")

## ---------- Catalog ----------

func _test_catalog_loaded_and_covers_classes() -> void:
	_check("catalog non-empty", GameState.weapons_by_id.size() >= 3,
		"size=%d" % GameState.weapons_by_id.size())
	var classes: Dictionary = {}
	for id in GameState.weapons_by_id:
		classes[GameState.weapons_by_id[id].cls] = true
	for cls in [&"warrior", &"mage", &"rogue"]:
		_check("catalog covers class '%s'" % cls, classes.has(cls), "missing")

func _test_catalog_meets_curve() -> void:
	for id in GameState.weapons_by_id:
		var w = GameState.weapons_by_id[id]
		_check("'%s' meets curve (atk >= 16)" % id, w.base_atk >= 16, "atk=%d" % w.base_atk)
		if w.base_atk < 16:
			break

## ---------- Pull ----------

func _test_pull_happy_path() -> void:
	var h = _fresh(600)
	var base_total: int = h.data.atk_base    ## 6, no sockets, no weapon_data
	var result: Dictionary = _wheel().pull()
	_check("pull returns a result", not result.is_empty(), "empty")
	_check("pull spends 300 gems", AccountState.gems == 300, "gems=%d" % AccountState.gems)
	_check("pull adds one owned weapon", AccountState.owned_weapons.size() == 1,
		"size=%d" % AccountState.owned_weapons.size())
	if result.is_empty():
		return
	_check("pulled weapon is warrior (only unlocked class)", result.weapon.cls == &"warrior",
		"cls=%s" % result.weapon.cls)
	_check("pull equips bran", result.hero_id == &"bran" and h.weapon_data == result.weapon,
		"hero=%s" % result.hero_id)
	_check("result old_atk = pre-equip total (%d)" % base_total, result.old_atk == base_total,
		"old=%d" % result.old_atk)
	_check("result new_atk = base + weapon atk", result.new_atk == base_total + result.weapon.get_atk(),
		"new=%d want %d" % [result.new_atk, base_total + result.weapon.get_atk()])
	_check("owned instance is NOT the catalog resource",
		result.weapon != GameState.weapons_by_id.get(result.weapon.id), "same instance!")

func _test_pull_insufficient_gems() -> void:
	var h = _fresh(299)
	var result: Dictionary = _wheel().pull()
	_check("pull with 299 gems returns {}", result.is_empty(), "got result")
	_check("no gems spent on failed pull", AccountState.gems == 299, "gems=%d" % AccountState.gems)
	_check("no weapon acquired on failed pull", AccountState.owned_weapons.is_empty(),
		"size=%d" % AccountState.owned_weapons.size())
	_check("nothing equipped on failed pull", h.weapon_data == null, "equipped")

func _test_pull_class_filtered_to_unlocked() -> void:
	## Bran-only session: every pull must be warrior (mage/rogue heroes locked).
	_fresh(3000)                      ## 10 pulls worth
	var all_warrior: bool = true
	for i in range(10):
		var r: Dictionary = _wheel().pull()
		if r.is_empty() or r.weapon.cls != &"warrior":
			all_warrior = false
			break
	_check("10 pulls, all warrior-class (locked classes excluded)", all_warrior, "non-warrior pulled")

func _test_second_pull_goes_to_bench() -> void:
	## Armory model: pulls only auto-equip an EMPTY-HANDED hero. A second pull
	## must never overwrite the player's chosen loadout — it lands on the bench.
	_fresh(600)
	var first: Dictionary = _wheel().pull()
	_reset_gems_only(600)
	var second: Dictionary = _wheel().pull()
	_check("first pull auto-equipped", bool(first.get("auto_equipped", false)), "false")
	_check("second pull NOT auto-equipped", bool(second.get("auto_equipped", true)) == false, "true")
	_check("hero still holds the FIRST weapon", AccountState.get_equipped(&"bran") == first.weapon,
		"overwritten")
	_check("second weapon owned (bench)", AccountState.owned_weapons.size() == 2,
		"size=%d" % AccountState.owned_weapons.size())

func _reset_gems_only(gems: int) -> void:
	AccountState.gems = gems

func _test_pull_signal() -> void:
	_fresh(600)
	_pull_signal_count = 0
	_wheel().pull_completed.connect(_on_pull_completed)
	_wheel().pull()
	_wheel().pull_completed.disconnect(_on_pull_completed)
	_check("pull_completed emitted once", _pull_signal_count == 1, "count=%d" % _pull_signal_count)
	_check("signal carries the result dict", not _pull_signal_result.is_empty()
		and _pull_signal_result.has("weapon"), "payload=%s" % str(_pull_signal_result.keys()))

func _on_pull_completed(result: Dictionary) -> void:
	_pull_signal_count += 1
	_pull_signal_result = result

## ---------- Test helpers ----------

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
