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
		_test_catalog_depth_four_per_class()
		_test_voltedge_in_catalog()
		_test_helios_in_catalog()
	## ForgeWheel autoload is looked up via /root path (parse-safe while unregistered).
	if get_node_or_null("/root/ForgeWheel") == null:
		_check("ForgeWheel autoload registered", false, "missing (RED)")
	else:
		_test_pull_happy_path()
		_test_pull_insufficient_gems()
		_test_pull_class_filtered_to_unlocked()
		_test_second_pull_goes_to_bench()
		_test_pull_signal()
		_test_pull_eligibility_is_fielded_roster()
		_test_pull_drops_two_shards()
		_test_dupe_pull_awards_gems()
		_test_shard_drop_by_rarity()
		_test_pull_spends_ember()
		_test_scripted_pull_1_fire_warrior()
		_test_scripted_pull_2_is_rng()
		_test_scripted_pull_3_electric_rogue()
		_test_scripted_pull_5_ice_mage()
		_test_scripted_pulls_idempotent_after_resume()
		_test_scripted_grant_ids_const_present()
		_test_helios_not_in_pull_pool()
		_test_scripted_pull_force_equips_over_starter()
		_test_rng_pull_still_goes_to_bench_when_armed()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

## ---------- Fixtures ----------

func _wheel():
	return get_node("/root/ForgeWheel")

func _reset_account(gems: int = 600, ember: int = 9999) -> void:
	AccountState.gems = gems
	AccountState.ember = ember
	AccountState.owned_weapons = []
	AccountState.equipped = {}

func _fresh(gems: int = 600, ember: int = 9999):
	GameState.new_session()      ## bran only (warrior)
	_reset_account(gems, ember)
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

## Catalog depth (Stage F): 4 weapons per fielded class (warrior/mage/rogue)
## spanning rarities Common..Legendary, so pulls have real variety + a pyramid.
func _test_catalog_depth_four_per_class() -> void:
	var by_class: Dictionary = {}        ## cls -> { rarity_idx -> true }
	for id in GameState.weapons_by_id:
		var w = GameState.weapons_by_id[id]
		if not by_class.has(w.cls):
			by_class[w.cls] = {}
		by_class[w.cls][w.rarity_idx] = true
	for cls in [&"warrior", &"mage", &"rogue"]:
		var rs: Dictionary = by_class.get(cls, {})
		_check("class '%s' spans rarities C/R/E/L" % cls,
			rs.has(0) and rs.has(1) and rs.has(2) and rs.has(3), "rarities=%s" % str(rs.keys()))
	_check("catalog has >= 12 weapons", GameState.weapons_by_id.size() >= 12,
		"size=%d" % GameState.weapons_by_id.size())

## ---------- Scripted Pacing Rework Chunk A (2026-06-10) ----------

func _test_voltedge_in_catalog() -> void:
	## A1: Rare electric rogue must exist (Voltedge Daggers) to back the
	## scripted pull #3 reshuffle (Vex's electric reveal). Catalog gap pre-A1.
	_check("voltedge_daggers exists",
		GameState.weapons_by_id.has(&"w_voltedge_daggers"), "missing")
	var w = GameState.weapons_by_id.get(&"w_voltedge_daggers")
	if w != null:
		_check("voltedge is Rare electric rogue",
			w.cls == &"rogue" and w.rune == &"electric" and w.rarity_idx == 1,
			"cls=%s rune=%s rarity=%d" % [w.cls, w.rune, w.rarity_idx])
		_check("voltedge base_atk = 21", w.base_atk == 21,
			"atk=%d" % w.base_atk)

func _test_helios_in_catalog() -> void:
	## A2: Helios Cleaver registered. Epic paladin light. Scripted-grant only —
	## B1 will add SCRIPTED_GRANT_IDS exclusion to filter from pull pool.
	_check("helios_cleaver exists",
		GameState.weapons_by_id.has(&"w_helios_cleaver"), "missing")
	var w = GameState.weapons_by_id.get(&"w_helios_cleaver")
	if w != null:
		_check("helios is Epic paladin light",
			w.cls == &"paladin" and w.rune == &"light" and w.rarity_idx == 2,
			"cls=%s rune=%s rarity=%d" % [w.cls, w.rune, w.rarity_idx])
		_check("helios stats: atk=28 hp=30 crit=8 ult=10",
			w.base_atk == 28 and w.base_hp == 30 and w.base_crit == 8 and w.base_ult_rate == 10,
			"atk=%d hp=%d crit=%d ult=%d" % [w.base_atk, w.base_hp, w.base_crit, w.base_ult_rate])

## ---------- Pull ----------

func _test_pull_happy_path() -> void:
	var h = _fresh(600)
	var ember_before: int = AccountState.ember
	var gems_before: int = AccountState.gems
	var saved: Array = _force_catalog([&"w_emberfang_cleaver"])   ## deterministic warrior pull
	var base_total: int = h.data.atk_base    ## 6, no sockets, no weapon_data
	var result: Dictionary = _wheel().pull()
	_restore_catalog(saved)
	_check("pull returns a result", not result.is_empty(), "empty")
	_check("pull deducts PULL_COST_EMBER ember", AccountState.ember == ember_before - AccountState.PULL_COST_EMBER, "ember=%d" % AccountState.ember)
	_check("pull leaves gems untouched", AccountState.gems == gems_before, "gems=%d" % AccountState.gems)
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
	## Retargeted: ember is now the pull currency; seed 0 ember to test the gate.
	var h = _fresh(600, 0)   ## plenty of gems, zero ember
	var result: Dictionary = _wheel().pull()
	_check("pull with 0 ember returns {}", result.is_empty(), "got result")
	_check("no ember spent on failed pull", AccountState.ember == 0, "ember=%d" % AccountState.ember)
	_check("no weapon acquired on failed pull", AccountState.owned_weapons.is_empty(),
		"size=%d" % AccountState.owned_weapons.size())
	_check("nothing equipped on failed pull", h.weapon_data == null, "equipped")

func _test_pull_class_filtered_to_unlocked() -> void:
	## Q1 anti-regression: a NON-warrior weapon can now be pulled pre-battle. Force a
	## mage-only pool; the pull yields a mage weapon (benched — no mage hero in a
	## bran-only squad yet). Before the fix the pool was warrior-locked at Home.
	_fresh(3000)
	var saved: Array = _force_catalog([&"w_frostcall_stave"])
	var r: Dictionary = _wheel().pull()
	_restore_catalog(saved)
	_check("non-warrior (mage) weapon can be pulled",
		not r.is_empty() and r.weapon.cls == &"mage",
		"cls=%s" % (str(r.weapon.cls) if not r.is_empty() else "empty"))

## Q1 fix (RED): the pull pool spans the FIELDED roster's classes (bran/elara/vex =
## warrior/mage/rogue), independent of combat unlock order. Pre-battle (a bran-only
## session) you must STILL be able to pull mage/rogue weapons — not warrior-only.
func _test_pull_eligibility_is_fielded_roster() -> void:
	if not GameState.has_method("fielded_classes"):
		_check("GameState.fielded_classes() exists", false, "method missing (RED)")
		return
	var fc: Dictionary = GameState.fielded_classes()
	_check("fielded_classes covers warrior/mage/rogue",
		fc.has(&"warrior") and fc.has(&"mage") and fc.has(&"rogue"),
		"got %s" % str(fc.keys()))
	_fresh(600)   ## bran-only session (only warrior unlocked for combat/shop)
	var classes: Dictionary = {}
	for w in _wheel().eligible_weapons():
		classes[w.cls] = true
	_check("eligible pool spans all fielded classes pre-battle",
		classes.has(&"warrior") and classes.has(&"mage") and classes.has(&"rogue"),
		"got %s" % str(classes.keys()))

## Stage F: every pull also drops 2 Forge Shards (the no-waste net), rarity-rolled,
## carrying the pulled weapon's element.
func _test_pull_drops_two_shards() -> void:
	_fresh(600)
	var saved: Array = _force_catalog([&"w_emberfang_cleaver"])
	var before: int = AccountState.shards.size()
	var r: Dictionary = _wheel().pull()
	_restore_catalog(saved)
	_check("pull result carries 2 shards", r.has("shards") and r.shards.size() == 2,
		"shards=%s" % str(r.get("shards", null)))
	_check("2 shards added to inventory", AccountState.shards.size() == before + 2,
		"delta=%d" % (AccountState.shards.size() - before))
	## B2: Common-tier emberfang is now non-elemental (rune = &""); shards mint with
	## the weapon's element so a non-elemental Common pull yields non-elemental shards.
	_check("dropped shards carry the weapon's element (Common = non-elemental)",
		r.has("shards") and r.shards.size() == 2 and r.shards[0].element == &"",
		"wrong element; got %s" % str(r.shards[0].element if r.shards.size() > 0 else "no shards"))

## Task 5 economy: re-pulling an owned weapon awards gems (rarity-scaled) instead
## of feeding star-up. The dupe-forcing mechanism is identical to the old test:
## pin the pool to one weapon id, pull twice (1st acquires, 2nd is guaranteed dupe).
func _test_dupe_pull_awards_gems() -> void:
	_fresh(600)
	var saved: Array = _force_catalog([&"w_emberfang_cleaver"])
	_wheel().pull()                                   ## acquire emberfang (1st pull, not a dupe)
	var gems_before: int = AccountState.gems
	var star_tier_before: int = AccountState.owned_weapons[0].star_tier
	var star_prog_before: int = AccountState.owned_weapons[0].star_progress
	_reset_gems_only(600)
	var r: Dictionary = _wheel().pull()               ## 2nd pull of same id -> guaranteed dupe
	_restore_catalog(saved)
	## The pulled weapon is emberfang (rarity_idx == 0 = Common), so expected gems = DUPE_GEMS[0] = 20
	var expected_gems: int = _wheel().DUPE_GEMS[0]
	_check("dupe pull result has dupe == true", bool(r.get("dupe", false)), "dupe flag missing")
	_check("dupe pull result carries dupe_gems key",
		r.has("dupe_gems") and r.get("dupe_gems", 0) == expected_gems,
		"dupe_gems=%d want %d" % [r.get("dupe_gems", -1), expected_gems])
	_check("AccountState.gems rose by dupe_gems",
		AccountState.gems == gems_before + expected_gems,
		"gems=%d want %d" % [AccountState.gems, gems_before + expected_gems])
	_check("star_tier unchanged by dupe",
		AccountState.owned_weapons[0].star_tier == star_tier_before,
		"star_tier=%d was %d" % [AccountState.owned_weapons[0].star_tier, star_tier_before])
	_check("star_progress unchanged by dupe",
		AccountState.owned_weapons[0].star_progress == star_prog_before,
		"star_prog=%d was %d" % [AccountState.owned_weapons[0].star_progress, star_prog_before])
	_check("still only one owned copy after dupe", AccountState.owned_weapons.size() == 1,
		"size=%d" % AccountState.owned_weapons.size())

## Task 2 / economy: 2 shards on common/rare pull (rarity_idx <= 1), 0 on epic+.
func _test_shard_drop_by_rarity() -> void:
	GameState.new_session()
	AccountState.reset_account()
	AccountState.add_ember(99999)   ## pulls cost ember
	var ok: bool = true
	var saw: bool = false
	for _i in range(40):
		if AccountState.ember < AccountState.PULL_COST_EMBER:
			AccountState.add_ember(99999)
		var r: Dictionary = ForgeWheel.pull()
		if r.is_empty():
			continue
		saw = true
		var n: int = (r.get("shards", []) as Array).size()
		var rarity: int = r["weapon"].rarity_idx
		var expected: int = 2 if rarity <= 1 else 0
		if n != expected:
			ok = false
	_check("shard drop = 2 (common/rare) / 0 (epic+)", ok and saw, "wrong shard count for rarity")

func _test_second_pull_goes_to_bench() -> void:
	## Re-pulling a weapon you ALREADY own is a DUPE -> star-up progress on the owned
	## instance, NEVER a 2nd bench copy.
	_fresh(600)
	var saved: Array = _force_catalog([&"w_emberfang_cleaver"])
	var first: Dictionary = _wheel().pull()
	_reset_gems_only(600)
	var second: Dictionary = _wheel().pull()
	_restore_catalog(saved)
	_check("first pull auto-equipped", bool(first.get("auto_equipped", false)), "false")
	_check("second same-id pull flagged as a dupe", bool(second.get("dupe", false)), "not dupe")
	_check("dupe does NOT add a 2nd owned copy", AccountState.owned_weapons.size() == 1,
		"size=%d" % AccountState.owned_weapons.size())
	_check("hero still holds the same (dupe-fed) weapon",
		AccountState.get_equipped(&"bran") == first.weapon, "changed")

func _test_pull_spends_ember() -> void:
	GameState.new_session()
	AccountState.reset_account()
	AccountState.add_ember(100)
	var gems_before: int = AccountState.gems
	var ember_before: int = AccountState.ember
	var r: Dictionary = ForgeWheel.pull()
	_check("pull succeeds with Ember", not r.is_empty(), "empty pull")
	_check("pull deducts PULL_COST_EMBER ember", AccountState.ember == ember_before - AccountState.PULL_COST_EMBER,
		"ember=%d" % AccountState.ember)
	_check("pull leaves gems untouched", AccountState.gems == gems_before, "gems=%d" % AccountState.gems)
	AccountState.spend_ember(AccountState.ember)   ## drain to 0
	_check("can_pull false at 0 ember", ForgeWheel.can_pull() == false, "can_pull true at 0")

func _reset_gems_only(gems: int) -> void:
	AccountState.gems = gems
	AccountState.ember = 9999   ## ensure ember is available (pulls cost ember now)

## Temporarily restrict the pull pool to specific weapon ids (deterministic pulls).
## Returns the saved id list; pass it to _restore_catalog when done.
func _force_catalog(ids: Array) -> Array:
	var saved: Array = GameState.weapon_ids
	GameState.weapon_ids = ids
	return saved

func _restore_catalog(saved: Array) -> void:
	GameState.weapon_ids = saved

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

## ---------- Catalyst v1 scripted pulls (Task B4) ----------

func _test_scripted_pull_1_fire_warrior() -> void:
	## Spec §6: Pull #1 on a fresh account -> guaranteed Fire weapon, warrior class.
	## After owner amendment B2 (non-elemental Common starters), the only fire-warrior
	## at Rare+ is w_cinderbrand_greatsword (Epic). Scripted pick lands there.
	_fresh(600, 9999)
	AccountState.scripted_pulls_seen = []
	AccountState.pull_count = 0
	var r: Dictionary = _wheel().pull()
	_check("pull #1 returns a result", not r.is_empty(), "empty")
	if not r.is_empty():
		_check("pull #1 is fire", r.weapon.rune == &"fire", "rune=%s" % r.weapon.rune)
		_check("pull #1 is warrior", r.weapon.cls == &"warrior", "cls=%s" % r.weapon.cls)
		_check("pull #1 is Rare+ (rarity_idx >= 1)", r.weapon.rarity_idx >= 1,
			"rarity=%d" % r.weapon.rarity_idx)
	_check("scripted_pulls_seen includes pull_1_fire_warrior",
		&"pull_1_fire_warrior" in AccountState.scripted_pulls_seen,
		"seen=%s" % str(AccountState.scripted_pulls_seen))
	_check("pull_count incremented to 1", AccountState.pull_count == 1,
		"pull_count=%d" % AccountState.pull_count)

func _test_scripted_pull_2_is_rng() -> void:
	## Spec §6: pull #2 = normal RNG. Scripts only fire on pull # 1 and pull # 3.
	_fresh(600, 9999)
	AccountState.scripted_pulls_seen = []
	AccountState.pull_count = 0
	_wheel().pull()                    ## #1 (scripted)
	var size_before: int = (AccountState.scripted_pulls_seen as Array).size()
	_wheel().pull()                    ## #2 (should NOT add a sentinel)
	_check("pull #2 doesn't add a new sentinel",
		(AccountState.scripted_pulls_seen as Array).size() == size_before,
		"size before=%d after=%d" % [size_before, (AccountState.scripted_pulls_seen as Array).size()])
	_check("pull_count after 2 pulls == 2", AccountState.pull_count == 2,
		"pull_count=%d" % AccountState.pull_count)

func _test_scripted_pull_3_electric_rogue() -> void:
	## B2: Pull #3 reshuffled to Vex Rare electric (was Elara Legendary ice).
	## Target: Voltedge Daggers (rune electric, cls rogue, rarity_idx 1).
	_fresh(600, 9999)
	AccountState.scripted_pulls_seen = []
	AccountState.pull_count = 0
	_wheel().pull()   ## #1 scripted fire warrior
	_wheel().pull()   ## #2 RNG
	var r3: Dictionary = _wheel().pull()
	_check("pull #3 returns a result", not r3.is_empty(), "empty")
	if not r3.is_empty():
		_check("pull #3 is electric", r3.weapon.rune == &"electric",
			"rune=%s" % r3.weapon.rune)
		_check("pull #3 is rogue", r3.weapon.cls == &"rogue",
			"cls=%s" % r3.weapon.cls)
		_check("pull #3 is Rare (rarity_idx 1)",
			r3.weapon.rarity_idx == 1, "rarity=%d" % r3.weapon.rarity_idx)
	_check("scripted_pulls_seen includes pull_3_electric_rogue",
		&"pull_3_electric_rogue" in AccountState.scripted_pulls_seen,
		"seen=%s" % str(AccountState.scripted_pulls_seen))

func _test_scripted_pull_5_ice_mage() -> void:
	## B2: NEW pull #5 reveals Elara Legendary ice (was pull #3).
	_fresh(600, 9999)
	AccountState.scripted_pulls_seen = []
	AccountState.pull_count = 0
	_wheel().pull()   ## #1 scripted fire warrior
	_wheel().pull()   ## #2 RNG
	_wheel().pull()   ## #3 scripted electric rogue
	_wheel().pull()   ## #4 RNG
	var r5: Dictionary = _wheel().pull()
	_check("pull #5 returns a result", not r5.is_empty(), "empty")
	if not r5.is_empty():
		_check("pull #5 is ice", r5.weapon.rune == &"ice",
			"rune=%s" % r5.weapon.rune)
		_check("pull #5 is mage", r5.weapon.cls == &"mage",
			"cls=%s" % r5.weapon.cls)
		_check("pull #5 is Legendary (rarity_idx 3)",
			r5.weapon.rarity_idx == 3, "rarity=%d" % r5.weapon.rarity_idx)
	_check("scripted_pulls_seen includes pull_5_ice_mage",
		&"pull_5_ice_mage" in AccountState.scripted_pulls_seen,
		"seen=%s" % str(AccountState.scripted_pulls_seen))

func _test_scripted_pulls_idempotent_after_resume() -> void:
	## Spec §6: scripted_pulls_seen survives save/load (B1). If all three sentinels exist
	## and pull_count >= 5 on resume, a 6th pull (and beyond) is RNG with no script.
	## B2 rebaseline: sentinels are now pull_1_fire_warrior + pull_3_electric_rogue +
	## pull_5_ice_mage (was just pull_1 + pull_3_ice_mage pre-B2).
	_fresh(600, 9999)
	AccountState.scripted_pulls_seen = [&"pull_1_fire_warrior", &"pull_3_electric_rogue", &"pull_5_ice_mage"]
	AccountState.pull_count = 5
	var size_before: int = (AccountState.scripted_pulls_seen as Array).size()
	var r: Dictionary = _wheel().pull()
	_check("6th-pull-equivalent succeeds", not r.is_empty(), "empty")
	_check("scripted_pulls_seen unchanged size (idempotent)",
		(AccountState.scripted_pulls_seen as Array).size() == size_before,
		"size before=%d after=%d" % [size_before, (AccountState.scripted_pulls_seen as Array).size()])
	_check("pull_count advances to 6",
		AccountState.pull_count == 6, "pull_count=%d" % AccountState.pull_count)

## ---------- Scripted Pacing Rework Chunk B (2026-06-10) ----------

func _test_scripted_grant_ids_const_present() -> void:
	## B1: SCRIPTED_GRANT_IDS const declared so future scripted weapons can be
	## added without touching eligible_weapons() logic. Includes Helios Cleaver
	## (Hot Paladin's signature, granted via Stage-3 boss defeat — never RNG).
	var fw = get_node("/root/ForgeWheel")
	_check("SCRIPTED_GRANT_IDS const exists",
		"SCRIPTED_GRANT_IDS" in fw,
		"missing")
	if "SCRIPTED_GRANT_IDS" in fw:
		_check("SCRIPTED_GRANT_IDS includes w_helios_cleaver",
			&"w_helios_cleaver" in fw.SCRIPTED_GRANT_IDS,
			"helios missing from exclusion list")

func _test_helios_not_in_pull_pool() -> void:
	## B1: SCRIPTED_GRANT_IDS filters Helios Cleaver out of eligible_weapons.
	## Helios is granted via Stage 3 boss defeat (Chunk C), never via RNG.
	## Today paladin class isn't yet fielded (A3 skip in fielded_classes) so this
	## assertion is defense-in-depth — once A6 lifts the skip, this filter holds
	## the line and keeps helios out of the gacha pool.
	_fresh(600, 9999)
	var ids_in_pool: Dictionary = {}
	for w in _wheel().eligible_weapons():
		ids_in_pool[w.id] = true
	_check("helios NOT in eligible pool",
		not ids_in_pool.has(&"w_helios_cleaver"),
		"leaked into pool: %s" % str(ids_in_pool.keys()))

func _test_scripted_pull_force_equips_over_starter() -> void:
	## B3: scripted pull #1 (Bran fire) force-equips Cinderbrand on Bran even when
	## Bran's non-elemental starter (Emberfang, rune="") is already in the slot.
	## Without B3 the elemental sits in bench; reveal lands silently.
	_fresh(600, 9999)
	AccountState.scripted_pulls_seen = []
	AccountState.pull_count = 0
	## Grant non-elemental starter to Bran first (mimics _grant_starter_if_first_boot).
	var starter = GameState.weapons_by_id[&"w_emberfang_cleaver"].duplicate(true)
	AccountState.owned_weapons = [starter]
	AccountState.equip(&"bran", 0)
	## Sanity: Bran's slot is occupied by starter pre-pull.
	_check("pre-pull: Bran equipped starter (rune empty)",
		AccountState.get_equipped(&"bran") != null
		and AccountState.get_equipped(&"bran").rune == &"",
		"unexpected pre-state")
	## Pull #1 scripted — Cinderbrand should force-equip on Bran.
	var r: Dictionary = _wheel().pull()
	_check("pull #1 returns a result", not r.is_empty(), "empty")
	if not r.is_empty():
		_check("Bran now equipped Cinderbrand (force-equipped over starter)",
			AccountState.get_equipped(&"bran") != null
			and AccountState.get_equipped(&"bran").id == &"w_cinderbrand_greatsword",
			"equipped=%s" % str(AccountState.get_equipped(&"bran")))
		_check("scripted pull result carries auto_equipped == true",
			bool(r.get("auto_equipped", false)), "auto_equipped=%s" % str(r.get("auto_equipped")))

func _test_rng_pull_still_goes_to_bench_when_armed() -> void:
	## B3: only SCRIPTED pulls force-equip. RNG pulls keep current "if armed, go
	## to bench" behavior so players retain agency over organic loadout.
	_fresh(600, 9999)
	AccountState.scripted_pulls_seen = [&"pull_1_fire_warrior", &"pull_3_electric_rogue", &"pull_5_ice_mage"]
	AccountState.pull_count = 5   ## past all scripted slots -> next pull is RNG
	## Bran already armed with a duplicated emberfang (starter).
	var starter = GameState.weapons_by_id[&"w_emberfang_cleaver"].duplicate(true)
	AccountState.owned_weapons = [starter]
	AccountState.equip(&"bran", 0)
	var equipped_before: Resource = AccountState.get_equipped(&"bran")
	## Pull #6 = pure RNG.
	var r: Dictionary = _wheel().pull()
	_check("pull #6 returns a result", not r.is_empty(), "empty")
	if not r.is_empty():
		## If RNG happened to roll a warrior weapon, the new weapon should be in
		## bench (not equipped on Bran) — Bran's equipped slot unchanged.
		var equipped_after: Resource = AccountState.get_equipped(&"bran")
		if r.weapon.cls == &"warrior":
			_check("RNG warrior pull goes to bench (Bran's equipped unchanged)",
				equipped_after == equipped_before,
				"Bran's slot changed: before=%s after=%s" % [equipped_before, equipped_after])
		else:
			## Non-warrior pull doesn't target Bran's slot anyway — skip the assert.
			_check("RNG non-warrior pull doesn't touch Bran (skipped)", true, "")

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
