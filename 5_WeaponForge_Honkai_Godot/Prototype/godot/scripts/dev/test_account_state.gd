## Test harness for scripts/core/account_state.gd — P0 meta-persistence + pull economy.
##
## Design contract (migration plan, entry contract #1):
##   - AccountState = ACCOUNT-scoped (durable across runs); GameState = RUN-scoped.
##     GameState.new_session() must never touch account state.
##   - Owned weapons are runtime duplicate(true) instances — never the catalog .tres
##     (mutable star/rarity/forge fields would corrupt the shared resource).
##   - Save = explicit JSON dict with version field at user://account.json.
##     Version mismatch or corrupt payload -> load fails -> caller keeps fresh account.
##   - Serialization is self-contained (full weapon fields), no catalog dependency at load.
##   - Economy starting values (Numbers Policy, test plan in migration plan doc):
##     STARTING_GEMS 600 (= 2 pulls day one), 15/wave + 25 boss bonus (= 300/full run
##     = 1 pull per run), PULL_COST 300 (spec §11, Wittle-derived).
##
## Run headless:
##   Godot_v4.6.2-stable_mono_win64_console.exe --headless --path <godot dir> \
##     res://scenes/dev/TestAccountState.tscn
extends Control

const SCRIPT_PATH := "res://scripts/core/account_state.gd"
const WeaponDataT = preload("res://scripts/data/weapon_data.gd")
const TEST_SAVE_PATH := "user://test_account_save.json"

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []
var _Account = null

func _ready() -> void:
	_log("=== AccountState (P0 persistence + economy) tests ===")
	_Account = load(SCRIPT_PATH) if ResourceLoader.exists(SCRIPT_PATH) else null
	_check("AccountState script exists at " + SCRIPT_PATH, _Account != null, "not found")
	if _Account != null:
		_test_starting_gems()
		_test_reset_account()
		_test_gems_add_spend()
		_test_pull_cost_constant()
		_test_acquire_weapon_duplicates_catalog()
		_test_equip_and_get_equipped()
		_test_save_dict_round_trip()
		_test_version_mismatch_rejected()
		_test_corrupt_payload_rejected()
		_test_disk_round_trip()
		_test_wave_clear_earnings()
		_test_victory_bonus()
		_test_stage_persistence()
		_test_unequip_returns_weapon_to_bench()
		_test_equip_rejects_class_mismatch()
		_test_swap_between_owned_weapons()
		_test_run_reset_does_not_touch_account()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _make_catalog_weapon() -> Resource:
	var w = WeaponDataT.new()
	w.id = &"w_iron_blade"
	w.name = "Iron Blade"
	w.cls = &"warrior"
	w.ability = "Cleave"
	w.rune = &"fire"
	w.recipe = &"inferno"
	w.base_atk = 30
	w.base_hp = 12
	w.base_crit = 5
	w.base_ult_rate = 10
	return w

## ---------- Economy ----------

func _test_starting_gems() -> void:
	var a = _Account.new()
	_check("fresh account starts with 600 gems (2 pulls)", a.gems == 600, "gems=%d" % a.gems)
	a.free()

func _test_gems_add_spend() -> void:
	var a = _Account.new()
	a.add_gems(100)
	_check("add_gems: 600+100=700", a.gems == 700, "gems=%d" % a.gems)
	var ok: bool = a.spend_gems(300)
	_check("spend_gems within balance succeeds", ok and a.gems == 400, "ok=%s gems=%d" % [ok, a.gems])
	var too_much: bool = a.spend_gems(10000)
	_check("spend_gems over balance fails, unchanged", too_much == false and a.gems == 400,
		"ok=%s gems=%d" % [too_much, a.gems])
	a.free()

func _test_pull_cost_constant() -> void:
	_check("PULL_COST == 300 (spec banner table)", _Account.PULL_COST == 300,
		"PULL_COST=%d" % _Account.PULL_COST)

## ---------- Owned weapons ----------

func _test_acquire_weapon_duplicates_catalog() -> void:
	## THE shared-Resource trap test: mutating an owned instance must never touch
	## the catalog resource it was pulled from.
	var a = _Account.new()
	var catalog = _make_catalog_weapon()
	var owned = a.acquire_weapon(catalog)
	_check("acquire returns an instance", owned != null, "null")
	_check("owned_weapons size 1", a.owned_weapons.size() == 1, "size=%d" % a.owned_weapons.size())
	owned.star_tier = 5
	owned.rarity_idx = 3
	owned.forge_progress = 0.5
	_check("catalog star_tier untouched after owned mutation", catalog.star_tier == 1,
		"catalog star=%d" % catalog.star_tier)
	_check("catalog rarity untouched", catalog.rarity_idx == 0, "catalog rarity=%d" % catalog.rarity_idx)
	var owned2 = a.acquire_weapon(catalog)
	_check("second acquire is an independent instance", owned2.star_tier == 1 and a.owned_weapons.size() == 2,
		"star=%d size=%d" % [owned2.star_tier, a.owned_weapons.size()])
	a.free()

func _test_equip_and_get_equipped() -> void:
	var a = _Account.new()
	a.acquire_weapon(_make_catalog_weapon())
	var ok: bool = a.equip(&"bran", 0)
	_check("equip valid index succeeds", ok, "false")
	var w = a.get_equipped(&"bran")
	_check("get_equipped returns the owned weapon", w != null and w.id == &"w_iron_blade",
		"got %s" % (w.id if w != null else &"null"))
	_check("equip out-of-range index fails", a.equip(&"bran", 99) == false, "accepted 99")
	_check("get_equipped unknown hero is null", a.get_equipped(&"elara") == null, "not null")
	a.free()

## ---------- Serialization ----------

func _test_save_dict_round_trip() -> void:
	var a = _Account.new()
	a.add_gems(150)                                   ## 750
	var owned = a.acquire_weapon(_make_catalog_weapon())
	owned.star_tier = 3
	owned.rarity_idx = 2
	owned.forge_progress = 0.5
	owned.forge_target_idx = 3
	a.acquire_weapon(_make_catalog_weapon())
	a.equip(&"bran", 0)
	var d: Dictionary = a.to_save_dict()
	var b = _Account.new()
	var ok: bool = b.load_from_dict(d)
	_check("round-trip load succeeds", ok, "false")
	_check("round-trip gems", b.gems == 750, "gems=%d" % b.gems)
	_check("round-trip owned count", b.owned_weapons.size() == 2, "size=%d" % b.owned_weapons.size())
	var w = b.get_equipped(&"bran")
	_check("round-trip equipped resolves", w != null, "null")
	if w != null:
		_check("round-trip weapon identity", w.id == &"w_iron_blade" and w.rune == &"fire",
			"id=%s rune=%s" % [w.id, w.rune])
		_check("round-trip star/rarity", w.star_tier == 3 and w.rarity_idx == 2,
			"star=%d rarity=%d" % [w.star_tier, w.rarity_idx])
		_check("round-trip forge bank survives", is_equal_approx(w.forge_progress, 0.5) and w.forge_target_idx == 3,
			"progress=%f target=%d" % [w.forge_progress, w.forge_target_idx])
		_check("round-trip combat stats", w.base_atk == 30 and w.base_crit == 5 and w.base_ult_rate == 10,
			"atk=%d crit=%d ult=%d" % [w.base_atk, w.base_crit, w.base_ult_rate])
	a.free()
	b.free()

func _test_version_mismatch_rejected() -> void:
	var a = _Account.new()
	var d: Dictionary = a.to_save_dict()
	d["version"] = 999
	var b = _Account.new()
	var ok: bool = b.load_from_dict(d)
	_check("future version rejected", ok == false, "accepted v999")
	_check("rejected load leaves fresh defaults", b.gems == 600, "gems=%d" % b.gems)
	a.free()
	b.free()

func _test_corrupt_payload_rejected() -> void:
	var b = _Account.new()
	var v: int = _Account.SAVE_VERSION
	_check("missing-keys payload rejected", b.load_from_dict({"version": v}) == false, "accepted")
	_check("non-dict weapon entry rejected",
		b.load_from_dict({"version": v, "gems": 5, "weapons": ["junk"], "equipped": {}}) == false, "accepted")
	b.free()

func _test_disk_round_trip() -> void:
	var a = _Account.new()
	a.add_gems(45)                                    ## 645
	a.acquire_weapon(_make_catalog_weapon())
	a.equip(&"bran", 0)
	var saved: bool = a.save_to_disk(TEST_SAVE_PATH)
	_check("save_to_disk succeeds", saved, "false")
	var b = _Account.new()
	var loaded: bool = b.load_from_disk(TEST_SAVE_PATH)
	_check("load_from_disk succeeds", loaded, "false")
	_check("disk round-trip gems", b.gems == 645, "gems=%d" % b.gems)
	_check("disk round-trip equipped", b.get_equipped(&"bran") != null, "null")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_SAVE_PATH))
	a.free()
	b.free()

## ---------- Run integration ----------

func _test_wave_clear_earnings() -> void:
	## Tuned after first playtest (owner stuck at 45 gems, ~7 runs per pull):
	## 25/wave + 75 boss bonus -> a full 15-wave run pays 600 = 2 pulls/run.
	var a = _Account.new()
	a._on_wave_cleared(2)
	_check("normal wave pays 25", a.gems == 625, "gems=%d" % a.gems)
	a._on_wave_cleared(5)
	_check("boss wave pays 25+75", a.gems == 725, "gems=%d" % a.gems)
	a.free()

func _test_victory_bonus() -> void:
	## Boss kill ends the run (Wittle stage shape): victory pays +100 so a cleared
	## run totals 4*25 + (25+75) + 100 = 300 = exactly one pull.
	var a = _Account.new()
	if not a.has_method(&"award_victory"):
		_check("AccountState has award_victory()", false, "method missing (RED)")
		a.free()
		return
	a.award_victory()
	_check("victory pays +100", a.gems == 700, "gems=%d" % a.gems)
	a.free()

func _test_reset_account() -> void:
	## Playtest hygiene: Home's debug reset returns the account to first-boot state.
	var a = _Account.new()
	if not a.has_method(&"reset_account"):
		_check("AccountState has reset_account()", false, "method missing (RED)")
		a.free()
		return
	a.gems = 45
	a.acquire_weapon(_make_catalog_weapon())
	a.equip(&"bran", 0)
	a.reset_account()
	_check("reset restores starting gems", a.gems == 600, "gems=%d" % a.gems)
	_check("reset clears owned weapons", a.owned_weapons.is_empty(), "size=%d" % a.owned_weapons.size())
	_check("reset clears equipped map", a.equipped.is_empty(), "size=%d" % a.equipped.size())
	a.free()

func _test_stage_persistence() -> void:
	## S1: stage is ACCOUNT progression — victory advances, defeat doesn't,
	## survives save/load, and old saves without the key start at stage 1.
	var a = _Account.new()
	if not ("current_stage" in a):
		_check("AccountState has current_stage", false, "property missing (RED)")
		a.free()
		return
	_check("fresh account at stage 1", a.current_stage == 1, "stage=%d" % a.current_stage)
	a.advance_stage()
	_check("victory advances stage", a.current_stage == 2, "stage=%d" % a.current_stage)
	var d: Dictionary = a.to_save_dict()
	var b = _Account.new()
	b.load_from_dict(d)
	_check("stage survives save round-trip", b.current_stage == 2, "stage=%d" % b.current_stage)
	var legacy: Dictionary = a.to_save_dict()
	legacy.erase("stage")
	var c = _Account.new()
	var ok: bool = c.load_from_dict(legacy)
	_check("save without stage key loads at stage 1", ok and c.current_stage == 1,
		"ok=%s stage=%d" % [ok, c.current_stage])
	a.reset_account()
	_check("reset returns to stage 1", a.current_stage == 1, "stage=%d" % a.current_stage)
	a.free()
	b.free()
	c.free()

## ---------- Armory equip rules (H1) ----------

func _mage_weapon() -> Resource:
	var w = WeaponDataT.new()
	w.id = &"w_test_stave"
	w.name = "Test Stave"
	w.cls = &"mage"
	w.base_atk = 16
	return w

func _test_unequip_returns_weapon_to_bench() -> void:
	var a = _Account.new()
	if not a.has_method(&"unequip"):
		_check("AccountState has unequip()", false, "method missing (RED)")
		a.free()
		return
	a.acquire_weapon(_make_catalog_weapon())
	a.equip(&"bran", 0)
	var ok: bool = a.unequip(&"bran")
	_check("unequip succeeds", ok, "false")
	_check("hero has nothing equipped after unequip", a.get_equipped(&"bran") == null, "still equipped")
	_check("weapon stays OWNED (bench, not deleted)", a.owned_weapons.size() == 1,
		"size=%d" % a.owned_weapons.size())
	_check("unequip with nothing equipped is a no-op false", a.unequip(&"bran") == false, "true")
	a.free()

func _test_equip_rejects_class_mismatch() -> void:
	var a = _Account.new()
	if not a.has_method(&"unequip"):
		_check("AccountState has class guard (gate)", false, "method missing (RED)")
		a.free()
		return
	a.acquire_weapon(_mage_weapon())
	var ok_wrong: bool = a.equip(&"bran", 0)          ## mage stave on the warrior
	_check("mage weapon on Bran rejected", ok_wrong == false, "accepted")
	_check("nothing equipped after rejected equip", a.get_equipped(&"bran") == null, "equipped")
	var ok_right: bool = a.equip(&"elara", 0)         ## mage stave on the mage
	_check("mage weapon on Elara accepted", ok_right, "rejected")
	a.free()

func _test_swap_between_owned_weapons() -> void:
	var a = _Account.new()
	if not a.has_method(&"unequip"):
		_check("AccountState has swap path (gate)", false, "method missing (RED)")
		a.free()
		return
	a.acquire_weapon(_make_catalog_weapon())          ## idx 0 (warrior)
	a.acquire_weapon(_make_catalog_weapon())          ## idx 1 (warrior)
	a.equip(&"bran", 0)
	var ok: bool = a.equip(&"bran", 1)                ## re-equip = swap
	_check("re-equip swaps to the new weapon", ok and a.get_equipped(&"bran") == a.owned_weapons[1],
		"ok=%s" % ok)
	_check("displaced weapon still owned (bench)", a.owned_weapons.size() == 2,
		"size=%d" % a.owned_weapons.size())
	a.free()

func _test_run_reset_does_not_touch_account() -> void:
	## THE account-vs-run boundary: restarting a run must not reset gems/weapons.
	var a = _Account.new()
	a.add_gems(111)                                   ## 711
	a.acquire_weapon(_make_catalog_weapon())
	GameState.new_session()
	_check("new_session leaves gems alone", a.gems == 711, "gems=%d" % a.gems)
	_check("new_session leaves owned weapons alone", a.owned_weapons.size() == 1,
		"size=%d" % a.owned_weapons.size())
	a.free()

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
