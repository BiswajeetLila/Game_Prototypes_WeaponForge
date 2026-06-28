# P0 Hero Progression Foundation — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the persistent hero-progression engine — XP→level math, a saved per-hero account state, and a level multiplier hook on `HeroState` — as a standalone, headless-tested module. **Purely additive: no existing live codepath changes, no existing test breaks.**

**Architecture:** Two new files plus one autoload registration. `hero_progress.gd` = pure static math (no state). `account_state.gd` = an autoload singleton holding `{hero_id: {xp, owned}}`, persisted as JSON to `user://`. `HeroState._init` gains an optional `level_mult` param that defaults to `1.0` (old behavior). The live game does NOT yet read any of this — wiring (`unlock_hero` + XP award on run-end) is the next plan. This mirrors how `weapon_data.gd` (P1a) was built and tested in isolation before integration.

**Tech Stack:** Godot 4.6 Mono, GDScript. Headless test harness (the `scenes/dev/Test*.tscn` + `scripts/dev/test_*.gd` pattern, exit-code = failure count).

**SSOT:** [hero-squad meta design §9 (P0)](../specs/2026-06-11-hero-squad-meta-design.md). Numbers (level cap 20, +5%/level, 1000×level curve, 100 XP/wave) are spec starting-values.

---

## File Structure

- **Create** `Prototype/godot/scripts/core/hero_progress.gd` — pure static math: `level_for_xp`, `cumulative_xp_for_level`, `xp_to_next`, `stat_mult`. No state, no dependencies. One responsibility: the XP/level curve.
- **Create** `Prototype/godot/scripts/core/account_state.gd` — autoload singleton: persistent per-hero `{xp, owned}`, XP award, save/load JSON. One responsibility: durable account progression.
- **Modify** `Prototype/godot/scripts/data/hero_state.gd` — add optional `level_mult` constructor param (default `1.0`), apply to `max_hp` + expose `base_atk()`. Backward-compatible.
- **Modify** `Prototype/godot/project.godot` — register `AccountState` autoload **before** `GameState`.
- **Create** `Prototype/godot/scripts/dev/test_progression.gd` + `Prototype/godot/scenes/dev/TestProgression.tscn` — headless test scene covering all of the above.

Why these boundaries: the math is pure (trivially testable, no side effects); the save layer owns all persistence; `HeroState` only learns to *accept* a multiplier, it doesn't decide policy. Nothing reads the account in the live game yet, so regression risk is structurally zero.

---

### Task 1: Hero progression math (`hero_progress.gd`)

**Files:**
- Create: `Prototype/godot/scripts/core/hero_progress.gd`
- Create (this task starts it): `Prototype/godot/scripts/dev/test_progression.gd`

- [ ] **Step 1: Write the failing test**

Create `Prototype/godot/scripts/dev/test_progression.gd`:

```gdscript
## Headless test harness for the P0 hero-progression foundation.
##
## Run headless:
##   Godot_v4.6.2-stable_mono_win64_console.exe --headless --path <godot dir> \
##     res://scenes/dev/TestProgression.tscn
## Or in-editor: scenes/dev/TestProgression.tscn -> Play Scene.
extends Control

const HeroProgressT = preload("res://scripts/core/hero_progress.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== Hero progression foundation tests ===")
	_test_level_for_xp_thresholds()
	_test_cumulative_and_to_next()
	_test_stat_mult()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

## ---------- hero_progress.gd ----------

func _test_level_for_xp_thresholds() -> void:
	_check("xp 0 -> level 1", HeroProgressT.level_for_xp(0) == 1, "got %d" % HeroProgressT.level_for_xp(0))
	_check("xp 999 -> level 1", HeroProgressT.level_for_xp(999) == 1, "got %d" % HeroProgressT.level_for_xp(999))
	_check("xp 1000 -> level 2", HeroProgressT.level_for_xp(1000) == 2, "got %d" % HeroProgressT.level_for_xp(1000))
	_check("xp 2999 -> level 2", HeroProgressT.level_for_xp(2999) == 2, "got %d" % HeroProgressT.level_for_xp(2999))
	_check("xp 3000 -> level 3", HeroProgressT.level_for_xp(3000) == 3, "got %d" % HeroProgressT.level_for_xp(3000))
	_check("huge xp clamps to level 20", HeroProgressT.level_for_xp(99999999) == 20, "got %d" % HeroProgressT.level_for_xp(99999999))

func _test_cumulative_and_to_next() -> void:
	_check("cumulative L1 == 0", HeroProgressT.cumulative_xp_for_level(1) == 0, "got %d" % HeroProgressT.cumulative_xp_for_level(1))
	_check("cumulative L2 == 1000", HeroProgressT.cumulative_xp_for_level(2) == 1000, "got %d" % HeroProgressT.cumulative_xp_for_level(2))
	_check("cumulative L3 == 3000", HeroProgressT.cumulative_xp_for_level(3) == 3000, "got %d" % HeroProgressT.cumulative_xp_for_level(3))
	_check("cumulative L20 == 190000", HeroProgressT.cumulative_xp_for_level(20) == 190000, "got %d" % HeroProgressT.cumulative_xp_for_level(20))
	_check("xp_to_next(1) == 1000", HeroProgressT.xp_to_next(1) == 1000, "got %d" % HeroProgressT.xp_to_next(1))
	_check("xp_to_next(20) == 0 (capped)", HeroProgressT.xp_to_next(20) == 0, "got %d" % HeroProgressT.xp_to_next(20))

func _test_stat_mult() -> void:
	_check("stat_mult(1) == 1.0", is_equal_approx(HeroProgressT.stat_mult(1), 1.0), "got %f" % HeroProgressT.stat_mult(1))
	_check("stat_mult(2) == 1.05", is_equal_approx(HeroProgressT.stat_mult(2), 1.05), "got %f" % HeroProgressT.stat_mult(2))
	_check("stat_mult(20) == 1.95", is_equal_approx(HeroProgressT.stat_mult(20), 1.95), "got %f" % HeroProgressT.stat_mult(20))
	_check("stat_mult(99) clamps to 1.95", is_equal_approx(HeroProgressT.stat_mult(99), 1.95), "got %f" % HeroProgressT.stat_mult(99))

## ---------- helpers ----------

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
```

- [ ] **Step 2: Run test to verify it fails**

Create a temporary scene to run it (you will formalize the `.tscn` in Task 4; for now create `Prototype/godot/scenes/dev/TestProgression.tscn` with this content):

```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/dev/test_progression.gd" id="1"]

[node name="TestProgression" type="Control"]
layout_mode = 3
anchors_preset = 15
script = ExtResource("1")
```

Run: `Godot_v4.6.2-stable_mono_win64_console.exe --headless --path Prototype/godot res://scenes/dev/TestProgression.tscn`
Expected: FAIL — parser/preload error "Could not load res://scripts/core/hero_progress.gd" (file does not exist yet).

- [ ] **Step 3: Write minimal implementation**

Create `Prototype/godot/scripts/core/hero_progress.gd`:

```gdscript
## HeroProgress — pure static math for hero leveling. No state, no autoload.
##
## Curve (spec starting values, hero-squad design §4/§9.4):
##   - MAX_LEVEL 20
##   - xp to go from level L to L+1 = XP_STEP * L  (1000, 2000, 3000, ...)
##   - stat multiplier = 1.0 + STAT_PER_LEVEL*(level-1)  (+5% per level)
class_name HeroProgress
extends RefCounted

const MAX_LEVEL: int = 20
const XP_STEP: int = 1000
const STAT_PER_LEVEL: float = 0.05

## Total cumulative XP required to BE at `level`. Level 1 = 0.
static func cumulative_xp_for_level(level: int) -> int:
	var lvl: int = clampi(level, 1, MAX_LEVEL)
	## sum_{k=1}^{lvl-1} XP_STEP*k = XP_STEP * (lvl-1)*lvl/2
	return XP_STEP * (lvl - 1) * lvl / 2

## XP needed to advance FROM `level` to `level+1`. 0 at/after cap.
static func xp_to_next(level: int) -> int:
	if level >= MAX_LEVEL:
		return 0
	return XP_STEP * maxi(1, level)

## Highest level whose cumulative threshold is met by `xp`. Clamped to MAX_LEVEL.
static func level_for_xp(xp: int) -> int:
	var lvl: int = 1
	while lvl < MAX_LEVEL and xp >= cumulative_xp_for_level(lvl + 1):
		lvl += 1
	return lvl

## Stat multiplier applied to a hero's base stats at this level.
static func stat_mult(level: int) -> float:
	var lvl: int = clampi(level, 1, MAX_LEVEL)
	return 1.0 + STAT_PER_LEVEL * float(lvl - 1)
```

- [ ] **Step 4: Run test to verify it passes**

Run: `Godot_v4.6.2-stable_mono_win64_console.exe --headless --path Prototype/godot res://scenes/dev/TestProgression.tscn`
Expected: PASS — `=== 16 passed / 0 failed ===`, process exit code 0.

- [ ] **Step 5: Commit**

```bash
git add Prototype/godot/scripts/core/hero_progress.gd Prototype/godot/scripts/dev/test_progression.gd Prototype/godot/scenes/dev/TestProgression.tscn
git commit -m "feat(progression): hero XP/level curve math (hero_progress.gd) + tests"
```

---

### Task 2: Account state persistence (`account_state.gd`)

**Files:**
- Create: `Prototype/godot/scripts/core/account_state.gd`
- Modify: `Prototype/godot/project.godot` (register autoload)
- Modify: `Prototype/godot/scripts/dev/test_progression.gd` (add cases)

- [ ] **Step 1: Write the failing test**

In `Prototype/godot/scripts/dev/test_progression.gd`, add a call `_test_account_state()` inside `_ready()` right after `_test_stat_mult()`, and add this method (before the `## ---------- helpers ----------` line):

```gdscript
func _test_account_state() -> void:
	## AccountState is an autoload; reach it by global name.
	var acc = get_node("/root/AccountState")
	if acc == null:
		_check("AccountState autoload present", false, "node /root/AccountState missing")
		return
	## Use a test-only save path so we never clobber a real player save.
	acc.save_path = "user://account_test.json"
	acc.reset()

	_check("fresh xp == 0", acc.get_xp(&"bran") == 0, "got %d" % acc.get_xp(&"bran"))
	_check("fresh level == 1", acc.get_level(&"bran") == 1, "got %d" % acc.get_level(&"bran"))
	_check("fresh not owned after reset", acc.is_owned(&"bran") == false, "owned=%s" % acc.is_owned(&"bran"))

	var new_level: int = acc.add_hero_xp(&"bran", 1500)
	_check("add 1500 xp -> level 2", new_level == 2, "got %d" % new_level)
	_check("stat_mult tracks level", is_equal_approx(acc.stat_mult(&"bran"), 1.05), "got %f" % acc.stat_mult(&"bran"))

	acc.award_squad_xp([&"elara", &"vex"], 100)
	_check("award_squad_xp elara +100", acc.get_xp(&"elara") == 100, "got %d" % acc.get_xp(&"elara"))
	_check("award_squad_xp vex +100", acc.get_xp(&"vex") == 100, "got %d" % acc.get_xp(&"vex"))

	acc.set_owned(&"bran", true)
	## Round-trip: save, wipe in-memory, load back.
	acc.save_account()
	acc.reset()
	_check("after reset xp gone", acc.get_xp(&"bran") == 0, "got %d" % acc.get_xp(&"bran"))
	acc.load_account()
	_check("after load xp restored (1500)", acc.get_xp(&"bran") == 1500, "got %d" % acc.get_xp(&"bran"))
	_check("after load owned restored", acc.is_owned(&"bran") == true, "owned=%s" % acc.is_owned(&"bran"))

	## Cleanup the test save file + in-memory state.
	if FileAccess.file_exists("user://account_test.json"):
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://account_test.json"))
	acc.reset()
```

- [ ] **Step 2: Run test to verify it fails**

Run: `Godot_v4.6.2-stable_mono_win64_console.exe --headless --path Prototype/godot res://scenes/dev/TestProgression.tscn`
Expected: FAIL — "AccountState autoload present" fails (node `/root/AccountState` missing) and subsequent calls error, because the autoload does not exist yet.

- [ ] **Step 3: Write minimal implementation**

Create `Prototype/godot/scripts/core/account_state.gd`:

```gdscript
## AccountState — persistent, cross-run hero progression. Autoload singleton.
##
## Registered BEFORE GameState in project.godot so it is ready when GameState
## builds the roster. P0: holds per-hero { xp, owned }. Level is derived from
## xp via HeroProgress (never stored, so the curve can be retuned freely).
##
## The live game does not read this yet (wiring is the next plan); P0 only
## builds + tests the engine.
extends Node

const HeroProgressT = preload("res://scripts/core/hero_progress.gd")

## Overridable so tests can target a throwaway file. Real game uses the default.
var save_path: String = "user://account.json"

## String(hero_id) -> { "xp": int, "owned": bool }
var _heroes: Dictionary = {}

func _ready() -> void:
	load_account()
	## Bran is the free starter — owned by default on a fresh account.
	if not is_owned(&"bran"):
		set_owned(&"bran", true)

## Wipe in-memory progression (tests + new-account).
func reset() -> void:
	_heroes = {}

func _entry(hero_id) -> Dictionary:
	var key: String = String(hero_id)
	if not _heroes.has(key):
		_heroes[key] = {"xp": 0, "owned": false}
	return _heroes[key]

func get_xp(hero_id) -> int:
	return int(_entry(hero_id)["xp"])

func get_level(hero_id) -> int:
	return HeroProgressT.level_for_xp(get_xp(hero_id))

func stat_mult(hero_id) -> float:
	return HeroProgressT.stat_mult(get_level(hero_id))

func is_owned(hero_id) -> bool:
	return bool(_entry(hero_id)["owned"])

func set_owned(hero_id, owned: bool) -> void:
	_entry(hero_id)["owned"] = owned

## Adds XP (clamped non-negative) and returns the hero's new level.
func add_hero_xp(hero_id, amount: int) -> int:
	var e: Dictionary = _entry(hero_id)
	e["xp"] = int(e["xp"]) + maxi(0, amount)
	return HeroProgressT.level_for_xp(int(e["xp"]))

## Grants `per_hero` XP to each id in `squad_ids`.
func award_squad_xp(squad_ids: Array, per_hero: int) -> void:
	for hero_id in squad_ids:
		add_hero_xp(hero_id, per_hero)

func save_account() -> void:
	var f := FileAccess.open(save_path, FileAccess.WRITE)
	if f == null:
		push_warning("AccountState: could not open %s for write" % save_path)
		return
	f.store_string(JSON.stringify(_heroes))
	f.close()

func load_account() -> void:
	if not FileAccess.file_exists(save_path):
		_heroes = {}
		return
	var f := FileAccess.open(save_path, FileAccess.READ)
	if f == null:
		_heroes = {}
		return
	var txt: String = f.get_as_text()
	f.close()
	var parsed = JSON.parse_string(txt)
	if typeof(parsed) != TYPE_DICTIONARY:
		_heroes = {}
		return
	## JSON restores numbers as floats; normalize xp back to int.
	var out: Dictionary = {}
	for key in parsed.keys():
		var row = parsed[key]
		if typeof(row) == TYPE_DICTIONARY:
			out[String(key)] = {
				"xp": int(row.get("xp", 0)),
				"owned": bool(row.get("owned", false)),
			}
	_heroes = out
```

Then register the autoload — in `Prototype/godot/project.godot`, the `[autoload]` block currently begins with `GameState=...`. Add `AccountState` as the FIRST line of the block (before `GameState`) so it initializes first:

```
[autoload]

AccountState="*res://scripts/core/account_state.gd"
GameState="*res://scripts/core/game_state.gd"
ScreenshotHelper="*res://scripts/core/screenshot_helper.gd"
RNG="*res://scripts/core/rng.gd"
Recipes="*res://scripts/core/recipes.gd"
Merge="*res://scripts/core/merge.gd"
Shop="*res://scripts/core/shop.gd"
Combat="*res://scripts/core/combat.gd"
ScreenShake="*res://scripts/core/screen_shake.gd"
HitPause="*res://scripts/core/hit_pause.gd"
Heartbeat="*res://scripts/core/heartbeat.gd"
SignalTrace="*res://scripts/core/signal_trace.gd"
```

- [ ] **Step 4: Run test to verify it passes**

Run: `Godot_v4.6.2-stable_mono_win64_console.exe --headless --path Prototype/godot res://scenes/dev/TestProgression.tscn`
Expected: PASS — `=== 26 passed / 0 failed ===`, exit code 0.

- [ ] **Step 5: Commit**

```bash
git add Prototype/godot/scripts/core/account_state.gd Prototype/godot/project.godot Prototype/godot/scripts/dev/test_progression.gd
git commit -m "feat(progression): AccountState autoload (persistent hero xp/owned) + save round-trip tests"
```

---

### Task 3: `HeroState` level multiplier (backward-compatible)

**Files:**
- Modify: `Prototype/godot/scripts/data/hero_state.gd`
- Modify: `Prototype/godot/scripts/dev/test_progression.gd` (add cases)

- [ ] **Step 1: Write the failing test**

In `test_progression.gd`, add `_test_hero_state_level_mult()` to `_ready()` after `_test_account_state()`, and add this method:

```gdscript
func _test_hero_state_level_mult() -> void:
	var HeroStateT = preload("res://scripts/data/hero_state.gd")
	var gs = get_node("/root/GameState")
	if gs == null or not gs.heroes_by_id.has(&"bran"):
		_check("GameState + bran HeroData present", false, "GameState/bran missing")
		return
	var bran_data = gs.heroes_by_id[&"bran"]  ## hp_base 120, atk_base 6

	## Default (no mult arg) preserves old behavior — this is the regression guard.
	var h1 = HeroStateT.new(bran_data)
	_check("default mult: max_hp == hp_base (120)", h1.max_hp == bran_data.hp_base, "got %d" % h1.max_hp)
	_check("default mult: base_atk == atk_base (6)", h1.base_atk() == bran_data.atk_base, "got %d" % h1.base_atk())

	## With a 1.5 multiplier, base stats scale (rounded).
	var h2 = HeroStateT.new(bran_data, 1.5)
	_check("mult 1.5: max_hp == round(120*1.5)=180", h2.max_hp == 180, "got %d" % h2.max_hp)
	_check("mult 1.5: base_atk == round(6*1.5)=9", h2.base_atk() == 9, "got %d" % h2.base_atk())
```

- [ ] **Step 2: Run test to verify it fails**

Run: `Godot_v4.6.2-stable_mono_win64_console.exe --headless --path Prototype/godot res://scenes/dev/TestProgression.tscn`
Expected: FAIL — `HeroStateT.new(bran_data, 1.5)` errors ("Too many arguments") because `_init` takes one param, and `base_atk()` does not exist.

- [ ] **Step 3: Write minimal implementation**

In `Prototype/godot/scripts/data/hero_state.gd`, replace the `var max_hp` declaration, the `_init`, and `refresh_max_hp` with the versions below (add `level_mult`, apply it to the innate base only — weapon bonus is unscaled).

Replace:
```gdscript
var max_hp: int = 0       ## recomputed from data.hp_base + weapon.get_hp_bonus()
```
with:
```gdscript
var max_hp: int = 0       ## recomputed from round(data.hp_base * level_mult) + weapon.get_hp_bonus()

## Persistent hero-level multiplier applied to innate base stats (HP + atk).
## Defaults to 1.0 so legacy callers (HeroStateT.new(data)) are unchanged.
var level_mult: float = 1.0
```

Replace:
```gdscript
func _init(p_data) -> void:
	data = p_data
	weapon = WeaponT.new()
	max_hp = data.hp_base
	hp = max_hp
```
with:
```gdscript
func _init(p_data, p_level_mult: float = 1.0) -> void:
	data = p_data
	level_mult = p_level_mult
	weapon = WeaponT.new()
	max_hp = _scaled_base_hp()
	hp = max_hp

## Innate HP after the level multiplier (no weapon bonus).
func _scaled_base_hp() -> int:
	return int(round(float(data.hp_base) * level_mult))

## Innate ATK after the level multiplier (no weapon bonus). Combat may read this
## in a later plan; today nothing calls it except tests.
func base_atk() -> int:
	return int(round(float(data.atk_base) * level_mult))
```

Replace:
```gdscript
func refresh_max_hp() -> void:
	var bonus: int = weapon.get_hp_bonus() if weapon != null else 0
	var new_max: int = data.hp_base + bonus
	var delta: int = new_max - max_hp
	max_hp = new_max
	## Equipping +HP raises current HP by the same amount; unequipping clamps down.
	hp = clampi(hp + delta, 0, max_hp)
```
with:
```gdscript
func refresh_max_hp() -> void:
	var bonus: int = weapon.get_hp_bonus() if weapon != null else 0
	var new_max: int = _scaled_base_hp() + bonus
	var delta: int = new_max - max_hp
	max_hp = new_max
	## Equipping +HP raises current HP by the same amount; unequipping clamps down.
	hp = clampi(hp + delta, 0, max_hp)
```

- [ ] **Step 4: Run test to verify it passes**

Run: `Godot_v4.6.2-stable_mono_win64_console.exe --headless --path Prototype/godot res://scenes/dev/TestProgression.tscn`
Expected: PASS — `=== 30 passed / 0 failed ===`, exit code 0.

- [ ] **Step 5: Commit**

```bash
git add Prototype/godot/scripts/data/hero_state.gd Prototype/godot/scripts/dev/test_progression.gd
git commit -m "feat(progression): HeroState optional level_mult (default 1.0, backward-compatible) + base_atk()"
```

---

### Task 4: Regression guard — confirm the 144-test suite is unaffected

**Files:** none changed. This task verifies the additive change broke nothing.

Rationale: the only existing file touched is `hero_state.gd`, and `_init` gained an *optional* param defaulting to `1.0` (legacy `HeroStateT.new(data)` is identical to before). `unlock_hero` is untouched. No existing test should move.

- [ ] **Step 1: Run the new suite headless (must be green)**

Run: `Godot_v4.6.2-stable_mono_win64_console.exe --headless --path Prototype/godot res://scenes/dev/TestProgression.tscn`
Expected: `=== 30 passed / 0 failed ===`, exit code 0.

- [ ] **Step 2: Run the combat suite in-editor (it has no headless auto-quit)**

Open `Prototype/godot` in the Godot editor, open `scenes/dev/TestCombat.tscn`, press Play Scene (Ctrl+Shift+F5). Read the on-screen summary label.
Expected: the suite's existing pass count, **0 failed**. Pay attention to the Bran/Elara/Vex `hp_base` assertions (Bran 120 / Elara 90 / Vex 75) — these confirm the `level_mult` default did not shift live stats.

- [ ] **Step 3: Spot-check the other suites in-editor**

Play Scene on `scenes/dev/TestMerge.tscn`, `TestShop.tscn`, `TestRecipes.tscn`, `TestUi.tscn`. Each must report **0 failed**.

- [ ] **Step 4: Commit (docs-only note, if anything was adjusted)**

If all green, nothing to commit. If a test needed a trivial fix (it should not), commit it:
```bash
git commit -am "test(progression): regression confirmation for additive HeroState change"
```

---

## Self-Review

**Spec coverage (design §9 P0 — the *foundation* slice of it):**
- Persistence/save layer → `account_state.gd` (Task 2). ✅
- Hero Level (XP → stat scaling) → `hero_progress.gd` + `HeroState.level_mult` (Tasks 1, 3). ✅
- *Not in this plan (next plans):* HOME screen, pre-run squad-select, removing the in-run unlock, awarding XP from real runs, scaling combat ATK, juice/audio, the faked pitch beats. These are listed under "Follow-on plans" below — intentionally out of scope so this plan stays additive and headless-testable.

**Placeholder scan:** none — every step has complete code and an exact run command with expected output.

**Type consistency:** `level_for_xp` / `cumulative_xp_for_level` / `xp_to_next` / `stat_mult` signatures match between `hero_progress.gd` and the tests; `AccountState` methods (`get_xp`/`get_level`/`stat_mult`/`is_owned`/`set_owned`/`add_hero_xp`/`award_squad_xp`/`save_account`/`load_account`/`reset`/`save_path`) match between impl and test; `HeroState.base_atk()` + `level_mult` + `_init(p_data, p_level_mult)` match between impl and test.

**Risk note:** the one cross-test hazard would be `unlock_hero` reading `AccountState` and a stray `user://account.json` leveling Bran past 120 — which is why this plan does NOT wire `unlock_hero` (deferred to the next plan, where the affected combat/shop tests get an `AccountState.reset()` in setup as part of the same change).

---

## Follow-on plans (write each after reading the relevant code)

1. **P0 wiring** — `unlock_hero` applies `AccountState.stat_mult` at run start; award XP to the deployed squad on `stage_cleared` in `main.gd`; route combat hero-ATK through `HeroState.base_atk()`. Includes migrating combat/shop tests to `AccountState.reset()` in setup. (Needs: full `main.gd` + `combat.gd` hero-attack read points.)
2. **P0 HOME + squad-select UI** — new `Home.tscn` (roster + per-hero level + Form Squad ≤3 + Battle), result/rewards screen; remove the in-run `ELARA_UNLOCK_WAVE`/`VEX_UNLOCK_WAVE` flow + migrate the tests that assert those constants. (Needs: existing `.tscn` UI patterns, `main.gd`.)
3. **Slice beats (pitch)** — scripted/faked hero pull moment, stage-affinity telegraph, juice + audio pass. (Needs: `forge_panel`/`notifications`/`juice_config` + an audio plan.)

---

## Execution Handoff

Plan complete. Two execution options:
1. **Subagent-Driven (recommended)** — a fresh subagent per task, review between tasks.
2. **Inline Execution** — execute tasks in this session with checkpoints.

(Per repo policy: `.import` autosave churn + untracked `.gd.uid` sidecars are noise — do not stage them in task commits.)
