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
const ShardDataT = preload("res://scripts/data/shard_data.gd")
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
		_test_save_version_is_5()
		_test_v2_save_loads_without_shards()
		_test_shards_round_trip()
		_test_corrupt_shard_rejected()
		_test_reset_clears_shards()
		_test_star_progress_round_trip()
		_test_ember_basics()
		_test_ember_save_roundtrip()
		_test_star_up_spends_gems()
		_test_v4_save_migrates_to_v5()
		_test_v5_round_trip_persists_catalyst_fields()
		_test_reset_clears_catalyst_fields()
		_test_v5_corrupt_arrays_rejected()
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

## ---------- Shard inventory + save v2->v3 migration (Stage E) ----------

func _test_save_version_is_5() -> void:
	_check("SAVE_VERSION bumped to 5 (catalyst v1)", _Account.SAVE_VERSION == 5,
		"version=%d" % _Account.SAVE_VERSION)

func _test_v2_save_loads_without_shards() -> void:
	## A pre-shard v2 save must LOAD (not be wiped): shards default empty, and old
	## weapon dicts lacking star_progress default it to 0.
	var a = _Account.new()
	a.add_gems(50)                                ## 650
	a.acquire_weapon(_make_catalog_weapon())
	var d: Dictionary = a.to_save_dict()
	d["version"] = 2
	d.erase("shards")
	for wd in d["weapons"]:
		wd.erase("star_progress")                 ## v2 weapons predate the field
	var b = _Account.new()
	var ok: bool = b.load_from_dict(d)
	_check("v2 save still loads (not wiped)", ok, "rejected")
	_check("v2 load: gems survive", b.gems == 650, "gems=%d" % b.gems)
	_check("v2 load: weapon survives", b.owned_weapons.size() == 1, "size=%d" % b.owned_weapons.size())
	_check("v2 load: shards default empty", ("shards" in b) and (b.shards as Array).is_empty(),
		"shards missing or non-empty")
	_check("v2 load: missing star_progress defaults to 0",
		b.owned_weapons.size() == 1 and b.owned_weapons[0].star_progress == 0,
		"star_progress not defaulted")
	a.free(); b.free()

func _test_shards_round_trip() -> void:
	var a = _Account.new()
	if not a.has_method(&"add_shard"):
		_check("AccountState has add_shard()", false, "method missing (RED)")
		a.free(); return
	var s = ShardDataT.new(); s.rarity_idx = 3; s.element = &"fire"
	a.add_shard(s)
	a.add_shard(ShardDataT.new())                 ## common, default
	var d: Dictionary = a.to_save_dict()
	var b = _Account.new()
	var ok: bool = b.load_from_dict(d)
	_check("shards round-trip load succeeds", ok, "false")
	_check("shards count preserved (2)", b.shards.size() == 2, "size=%d" % b.shards.size())
	if b.shards.size() == 2:
		_check("shard rarity + element preserved",
			b.shards[0].rarity_idx == 3 and b.shards[0].element == &"fire",
			"rarity=%d element=%s" % [b.shards[0].rarity_idx, b.shards[0].element])
	a.free(); b.free()

func _test_corrupt_shard_rejected() -> void:
	var a = _Account.new()
	var d: Dictionary = a.to_save_dict()
	d["shards"] = ["junk"]                         ## non-dict entry
	var b = _Account.new()
	var ok: bool = b.load_from_dict(d)
	_check("corrupt shard entry rejected", ok == false, "accepted")
	_check("rejected corrupt-shard load leaves fresh defaults", b.gems == 600, "gems=%d" % b.gems)
	a.free(); b.free()

func _test_reset_clears_shards() -> void:
	var a = _Account.new()
	if not a.has_method(&"add_shard"):
		_check("AccountState shards (gate)", false, "method missing (RED)")
		a.free(); return
	a.add_shard(ShardDataT.new())
	a.reset_account()
	_check("reset clears shards", ("shards" in a) and (a.shards as Array).is_empty(), "not cleared")
	a.free()

func _test_star_progress_round_trip() -> void:
	var a = _Account.new()
	var owned = a.acquire_weapon(_make_catalog_weapon())
	owned.star_progress = 2
	var d: Dictionary = a.to_save_dict()
	var b = _Account.new()
	b.load_from_dict(d)
	_check("star_progress survives save round-trip",
		b.owned_weapons.size() == 1 and b.owned_weapons[0].star_progress == 2,
		"star_progress not persisted")
	a.free(); b.free()

## ---------- Ember currency (Task 3) ----------

func _test_ember_basics() -> void:
	AccountState.reset_account()
	_check("ember starts at STARTING_EMBER", AccountState.ember == AccountState.STARTING_EMBER,
		"ember=%d" % AccountState.ember)
	AccountState.add_ember(3)
	_check("add_ember raises ember", AccountState.ember == AccountState.STARTING_EMBER + 3, "ember=%d" % AccountState.ember)
	var ok: bool = AccountState.spend_ember(2)
	_check("spend_ember within balance true", ok and AccountState.ember == AccountState.STARTING_EMBER + 1, "ember=%d" % AccountState.ember)
	_check("spend_ember over balance false", AccountState.spend_ember(9999) == false, "overspent")

func _test_ember_save_roundtrip() -> void:
	AccountState.reset_account()
	AccountState.add_ember(7)
	var d: Dictionary = AccountState.to_save_dict()
	_check("save dict version is 5", int(d.get("version", -1)) == 5, "ver=%s" % str(d.get("version")))
	_check("save dict carries ember", int(d.get("ember", -1)) == AccountState.ember, "ember=%s" % str(d.get("ember")))
	var v3: Dictionary = {"version": 3, "gems": 100, "stage": 1, "weapons": [], "equipped": {}, "shards": []}
	_check("v3 save loads", AccountState.load_from_dict(v3) == true, "v3 rejected")
	_check("absent ember -> 0", AccountState.ember == 0, "ember=%d" % AccountState.ember)

## ---------- Star-up via gem spend (Task 6) ----------

func _test_star_up_spends_gems() -> void:
	AccountState.reset_account()
	var w = GameState.weapons_by_id.values()[0].duplicate(true)
	w.star_tier = 1
	AccountState.owned_weapons = [w]
	AccountState.gems = 1000
	var r: Dictionary = AccountState.star_up(0)
	_check("star_up ok", r.get("ok", false), "reason=%s" % str(r.get("reason")))
	_check("star_up cost = 100 * old tier (100)", int(r.get("cost", -1)) == 100, "cost=%s" % str(r.get("cost")))
	_check("star raised to 2", w.star_tier == 2, "tier=%d" % w.star_tier)
	_check("gems spent (1000 -> 900)", AccountState.gems == 900, "gems=%d" % AccountState.gems)
	## Refuses when gems short.
	AccountState.gems = 10
	var r2: Dictionary = AccountState.star_up(0)
	_check("star_up refused when gems short", r2.get("ok", true) == false and r2.get("reason") == "no_gems", "r2=%s" % str(r2))
	## Caps at MAX_STAR_TIER.
	w.star_tier = w.MAX_STAR_TIER
	AccountState.gems = 100000
	_check("star_up refused at max", AccountState.star_up(0).get("reason") == "max_star", "not capped")

## ---------- Catalyst v5 schema (Task B1) ----------

func _test_v4_save_migrates_to_v5() -> void:
	## A v4 save (pre-catalyst) must LOAD into v5: scripted_pulls_seen +
	## catalyst_codex_discovered + pull_count default to empty arrays / 0.
	var v4: Dictionary = {"version": 4, "gems": 700, "stage": 1, "ember": 5,
		"weapons": [], "equipped": {}, "shards": []}
	var b = _Account.new()
	var ok: bool = b.load_from_dict(v4)
	_check("v4 save still loads", ok, "rejected")
	_check("v4 load: gems survive", b.gems == 700, "gems=%d" % b.gems)
	_check("v4 load: scripted_pulls_seen defaults []",
		("scripted_pulls_seen" in b) and (b.scripted_pulls_seen as Array).is_empty(),
		"missing or non-empty")
	_check("v4 load: catalyst_codex_discovered defaults []",
		("catalyst_codex_discovered" in b) and (b.catalyst_codex_discovered as Array).is_empty(),
		"missing or non-empty")
	_check("v4 load: pull_count defaults 0",
		("pull_count" in b) and b.pull_count == 0,
		"pull_count missing or non-zero")
	b.free()

func _test_v5_round_trip_persists_catalyst_fields() -> void:
	var a = _Account.new()
	a.scripted_pulls_seen = [&"pull_1_fire_warrior", &"pull_3_ice_mage"]
	a.catalyst_codex_discovered = [&"firestorm"]
	a.pull_count = 7
	var d: Dictionary = a.to_save_dict()
	_check("save dict version is 5", int(d.get("version", -1)) == 5, "ver=%s" % str(d.get("version")))
	_check("save dict carries pull_count", int(d.get("pull_count", -1)) == 7,
		"pull_count=%s" % str(d.get("pull_count")))
	var b = _Account.new()
	var ok: bool = b.load_from_dict(d)
	_check("v5 round-trip load ok", ok, "rejected")
	_check("scripted_pulls_seen survives", (b.scripted_pulls_seen as Array).size() == 2,
		"size=%d" % (b.scripted_pulls_seen as Array).size())
	_check("catalyst_codex_discovered survives", (b.catalyst_codex_discovered as Array).size() == 1,
		"size=%d" % (b.catalyst_codex_discovered as Array).size())
	_check("pull_count survives", b.pull_count == 7, "pull_count=%d" % b.pull_count)
	a.free(); b.free()

func _test_reset_clears_catalyst_fields() -> void:
	var a = _Account.new()
	a.scripted_pulls_seen = [&"pull_1_fire_warrior"]
	a.catalyst_codex_discovered = [&"firestorm"]
	a.pull_count = 5
	a.reset_account()
	_check("reset clears scripted_pulls_seen",
		("scripted_pulls_seen" in a) and (a.scripted_pulls_seen as Array).is_empty(),
		"not cleared")
	_check("reset clears catalyst_codex_discovered",
		("catalyst_codex_discovered" in a) and (a.catalyst_codex_discovered as Array).is_empty(),
		"not cleared")
	_check("reset clears pull_count",
		("pull_count" in a) and a.pull_count == 0,
		"not cleared, pull_count=%d" % a.pull_count)
	a.free()

func _test_v5_corrupt_arrays_rejected() -> void:
	## Validate-then-commit contract: malformed array entry must reject the whole load.
	var a = _Account.new()
	var d: Dictionary = a.to_save_dict()
	d["scripted_pulls_seen"] = "not_an_array"   ## wrong type
	var b = _Account.new()
	var ok: bool = b.load_from_dict(d)
	_check("corrupt scripted_pulls_seen rejected", ok == false, "accepted bad type")
	_check("rejected load leaves fresh defaults", b.gems == 600, "gems=%d" % b.gems)
	a.free(); b.free()

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
