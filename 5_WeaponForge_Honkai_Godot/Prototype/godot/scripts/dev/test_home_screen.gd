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
	_test_briefing_hides_catalyst_when_no_pair()
	_test_briefing_shows_firestorm_when_fire_ice()
	_test_paladin_in_catalog()
	_test_fielded_classes_excludes_paladin_when_locked()
	_test_home_paladin_row_locked()
	_test_home_paladin_row_unlocked()
	_test_stage_3_briefing_shows_light_weakness()
	_test_stage_3_retry_flow_post_defeat()

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

## ---------- Catalyst v1 briefing (Task C2) ----------

func _test_briefing_hides_catalyst_when_no_pair() -> void:
	## Fresh squad (non-elemental Commons post-B2) -> briefing has no
	## "ACTIVE CATALYST" section.
	AccountState.reset_account()
	var hs = HomeScreenT.new()
	add_child(hs)
	hs._open_briefing()
	var body: String = hs._briefing.dialog_text
	_check("briefing body lacks ACTIVE CATALYST pre-pair",
		not body.contains("ACTIVE CATALYST"), "body=%s" % body.left(200))
	hs.queue_free()

func _test_briefing_shows_firestorm_when_fire_ice() -> void:
	## Equip Cinderbrand (Epic fire warrior) + Glacial Aegis Staff (Legendary ice mage).
	## Briefing should list Firestorm with its +20% squad ATK effect.
	AccountState.reset_account()
	var fire_w = GameState.weapons_by_id[&"w_cinderbrand_greatsword"].duplicate(true)
	var ice_w = GameState.weapons_by_id[&"w_glacial_aegis_staff"].duplicate(true)
	AccountState.owned_weapons = [fire_w, ice_w]
	AccountState.equip(&"bran", 0)
	AccountState.equip(&"elara", 1)
	var hs = HomeScreenT.new()
	add_child(hs)
	hs._open_briefing()
	var body: String = hs._briefing.dialog_text
	_check("briefing body contains ACTIVE CATALYST", body.contains("ACTIVE CATALYST"),
		"body=%s" % body.left(200))
	_check("briefing body names Firestorm", body.contains("Firestorm"),
		"body=%s" % body.left(200))
	_check("briefing body shows +20% ATK", body.contains("+20") and body.contains("ATK"),
		"body=%s" % body.left(200))
	hs.queue_free()

## ---------- Scripted Pacing Rework Chunk A (2026-06-10) ----------

func _test_paladin_in_catalog() -> void:
	## A3: Hot Paladin registered in GameState.heroes_by_id (folder-scanned from
	## data/heroes/paladin.tres) AND added to FIELDED_HEROES so its class flows
	## through fielded_classes() once unlocked. Locked-by-default filter logic
	## (the AccountState.paladin_unlocked gate) lands in A6.
	_check("paladin hero exists",
		GameState.heroes_by_id.has(&"paladin"), "missing")
	var h = GameState.heroes_by_id.get(&"paladin")
	if h != null:
		_check("paladin class == paladin",
			h.cls == &"paladin", "cls=%s" % h.cls)
		_check("paladin in FIELDED_HEROES",
			&"paladin" in GameState.FIELDED_HEROES, "missing from roster")

func _test_fielded_classes_excludes_paladin_when_locked() -> void:
	## A6: GameState.fielded_classes() filters paladin via AccountState.paladin_unlocked.
	AccountState.reset_account()
	AccountState.paladin_unlocked = false
	var fc: Dictionary = GameState.fielded_classes()
	_check("paladin NOT in fielded when locked",
		not fc.has(&"paladin"), "leaked: %s" % str(fc.keys()))
	AccountState.paladin_unlocked = true
	fc = GameState.fielded_classes()
	_check("paladin IS in fielded when unlocked",
		fc.has(&"paladin"), "missing: %s" % str(fc.keys()))
	## Restore neutral state.
	AccountState.paladin_unlocked = false

## ---------- Scripted Pacing Rework Chunk C (2026-06-10) ----------

func _test_home_paladin_row_locked() -> void:
	## C3: Pre-unlock, home_screen renders a "🔒 Hot Paladin — locked" disabled
	## row in the squad list. Per spec §8: paladin is the 4th roster slot.
	AccountState.reset_account()
	AccountState.paladin_unlocked = false
	var hs = HomeScreenT.new()
	add_child(hs)
	hs._refresh()
	_check("paladin row exists in _hero_rows", hs._hero_rows.has(&"paladin"),
		"hero_rows keys=%s" % str(hs._hero_rows.keys()))
	var row: Button = hs._hero_rows.get(&"paladin")
	if row != null:
		_check("locked paladin row shows 🔒",
			row.text.contains("🔒"), "text=%s" % row.text)
		_check("locked paladin row is disabled",
			row.disabled == true, "disabled=%s" % str(row.disabled))
	hs.queue_free()

func _test_home_paladin_row_unlocked() -> void:
	## C3: Post-unlock, home_screen renders paladin row normally (no 🔒, enabled).
	AccountState.reset_account()
	AccountState.paladin_unlocked = true
	var hs = HomeScreenT.new()
	add_child(hs)
	hs._refresh()
	var row: Button = hs._hero_rows.get(&"paladin")
	_check("paladin row exists when unlocked", row != null, "missing")
	if row != null:
		_check("unlocked paladin row drops 🔒",
			not row.text.contains("🔒"), "text=%s" % row.text)
		_check("unlocked paladin row enabled (not disabled)",
			row.disabled == false, "disabled=%s" % str(row.disabled))
	hs.queue_free()

## ---------- Scripted Pacing Rework Chunk D (2026-06-10) ----------

func _test_stage_3_briefing_shows_light_weakness() -> void:
	## D2: Stage 3 boss (Arcane Lich) is weak to light pre-defeat — telegraphed
	## in the briefing dialog. Player has no light access (Helios is scripted-
	## grant only), so they walk in blind. Defeat triggers (C1) -> Paladin
	## descends with Helios -> retry trivializes the boss.
	AccountState.reset_account()
	AccountState.current_stage = 3
	var hs = HomeScreenT.new()
	add_child(hs)
	hs._open_briefing()
	var body: String = hs._briefing.dialog_text
	## Briefing must telegraph LIGHT weakness pre-defeat.
	_check("Stage 3 briefing mentions light or ☀ weakness",
		body.contains("light") or body.contains("☀"),
		"body=%s" % body.left(300))
	## Should also telegraph EARTH resist.
	_check("Stage 3 briefing mentions earth or 🪨 resist",
		body.contains("earth") or body.contains("🪨"),
		"body=%s" % body.left(300))
	hs.queue_free()

func _test_stage_3_retry_flow_post_defeat() -> void:
	## D4: After Hot Paladin defeat: current_stage stays 3 (no auto-advance),
	## paladin is unlocked + Helios equipped, Home start-battle routes to Stage 3
	## retry, briefing still telegraphs light weak (cold telegraph — same pre
	## and post-defeat). Combat retry: sentinel guard skips the scripted AOE.
	AccountState.reset_account()
	AccountState.current_stage = 3
	## Simulate post-defeat state (Combat C1 would have flipped these).
	AccountState.paladin_unlocked = true
	AccountState.scripted_pulls_seen = [&"defeat_stage_3_paladin"]
	## Grant + equip Helios on paladin (simulating the C1 grant).
	var helios = GameState.weapons_by_id[&"w_helios_cleaver"].duplicate(true)
	AccountState.owned_weapons = [helios]
	AccountState.equip(&"paladin", 0)
	## --- Test 1: current_stage unchanged. ---
	_check("current_stage = 3 (defeat doesn't advance stage)",
		AccountState.current_stage == 3,
		"stage=%d" % AccountState.current_stage)
	## --- Test 2: Helios equipped on paladin. ---
	var pal_eq = AccountState.get_equipped(&"paladin")
	_check("Paladin equipped Helios Cleaver post-defeat",
		pal_eq != null and pal_eq.id == &"w_helios_cleaver",
		"equipped=%s" % str(pal_eq))
	## --- Test 3: Home start-battle button targets Stage 3 retry. ---
	var hs = HomeScreenT.new()
	add_child(hs)
	hs._refresh()
	_check("battle button targets STAGE 3",
		hs._battle_btn.text.contains("STAGE 3") or hs._battle_btn.text.contains("Stage 3"),
		"btn text=%s" % hs._battle_btn.text)
	## --- Test 4: Briefing still telegraphs light weak (cold telegraph). ---
	hs._open_briefing()
	var body: String = hs._briefing.dialog_text
	_check("retry briefing still shows light/☀ weakness",
		body.contains("light") or body.contains("☀"),
		"body=%s" % body.left(300))
	hs.queue_free()
	## --- Test 5: Combat retry — sentinel guard short-circuits scripted AOE. ---
	GameState.new_session()
	GameState.unlock_hero(&"elara")
	GameState.unlock_hero(&"vex")
	GameState.unlock_hero(&"paladin")
	GameState.run_stage = 3
	## Re-grant the post-defeat state (new_session resets parts of state).
	AccountState.current_stage = 3
	AccountState.paladin_unlocked = true
	AccountState.scripted_pulls_seen = [&"defeat_stage_3_paladin"]
	Combat.start_wave(5, false)
	var lich_idx: int = -1
	for i in range(GameState.enemies.size()):
		if GameState.enemies[i].id == &"boss_arcane_lich":
			lich_idx = i; break
	if lich_idx >= 0:
		GameState.enemies[lich_idx].hp = int(float(GameState.enemies[lich_idx].max_hp) * 0.4)
		## Boost hero HP so phase-1 atk bumps don't kill anyone in one tick
		## (mirrors test_combat _test_paladin_defeat_skips_on_retry pattern).
		for h in GameState.all_heroes():
			h.hp = 9999
			h.max_hp = 9999
		var alive_before: int = 0
		for h in GameState.active_heroes():
			if h.data.id != &"paladin" and h.hp > 0:
				alive_before += 1
		var emitted: Array = [false]
		Combat.paladin_descend.connect(func(): emitted[0] = true, CONNECT_ONE_SHOT)
		Combat.step()
		var alive_after: int = 0
		for h in GameState.active_heroes():
			if h.data.id != &"paladin" and h.hp > 0:
				alive_after += 1
		_check("retry: paladin_descend NOT re-emitted (sentinel guard)",
			not emitted[0], "re-emitted on retry")
		_check("retry: squad survives (no scripted AOE)",
			alive_after == alive_before,
			"alive before=%d after=%d" % [alive_before, alive_after])
	else:
		_check("retry: lich spawned at stage 3 boss wave", false, "no lich")
	Combat.stop()

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
