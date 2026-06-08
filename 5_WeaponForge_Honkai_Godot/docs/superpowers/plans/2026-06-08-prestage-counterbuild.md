# Pre-Stage Counter-Build Loop — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A stage telegraphs its enemies' element affinities (minions + boss) before you enter; you equip weapon-elements to counter; defeat drops you back on the squad/loadout screen to rebuild.

**Architecture:** A pure static `StageAffinity` helper computes deterministic per-stage affinities (stage 1 mirrors the boss to teach; stage ≥2 spreads + conflicts). Combat reads it to tag minions (replacing the random roll). The boss `.tres` are retagged into the 4-element set. A pre-stage briefing panel on Home renders the affinities + squad mismatch before launching battle. On wipe, Main routes straight to Home.

**Tech Stack:** Godot 4.6.2 Mono, GDScript. Spec: `docs/superpowers/specs/2026-06-08-prestage-counterbuild-design.md`. Worktree `.claude/worktrees/pedantic-golick-94f7e8/`, project `5_WeaponForge_Honkai_Godot/Prototype/godot`.

**Conventions (from this codebase):**
- Autoloads referenced globally: `GameState`, `Combat`, `ForgeDraft`, `AccountState`, `ForgeWheel`.
- Dev tests: a `Control` scene under `scenes/dev/TestX.tscn` + `scripts/dev/test_x.gd`, extends `Control`, prints `=== N passed / M failed ===`, and `get_tree().quit(_failed)` when headless. Copy the harness shape from `scripts/dev/test_forge_draft.gd`.
- **Run a test (godot MCP, preferred):** `run_project(projectPath=<worktree>/5_WeaponForge_Honkai_Godot/Prototype/godot, scene="res://scenes/dev/TestStageAffinity.tscn")` → `get_debug_output` → parse `=== N passed / M failed ===` → `stop_project`. **Fallback (console exe):** `Godot_v4.6.2-stable_mono_win64_console.exe --headless --path <godot dir> res://scenes/dev/TestStageAffinity.tscn`.
- ⚠️ **Stage-1 combat is a frozen contract.** `combat.gd` multipliers are exactly 1.0 at stage 1 and `TestCombat` guards it. Run `TestCombat` after every combat change.
- Commit per task. Commit message footer: `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`. Do NOT push (owner-gated).

**Element set (canonical):** `[fire, ice, electric, wind]` (FTUE 4; earth gates later). Retire the stray `pierce` tag.

**Boss retag table (this plan applies it):**
| Boss | id | new weak | new resist |
|---|---|---|---|
| Slime King | `boss_slime_king` | `fire` | `ice` |
| Iron Golem | `boss_iron_golem` | `electric` | `wind` |
| Arcane Lich | `boss_arcane_lich` | `wind` | `fire` |

---

### Task 1: Retag the three boss `.tres` to the 4-element set

**Files:**
- Modify: `Prototype/godot/data/enemies/boss_slime_king.tres` (`weak_tag`/`resist_tag` lines)
- Modify: `Prototype/godot/data/enemies/boss_iron_golem.tres`
- Modify: `Prototype/godot/data/enemies/boss_arcane_lich.tres`

- [ ] **Step 1: Edit Slime King**

In `boss_slime_king.tres`, change:
```
weak_tag = &"ice"
resist_tag = &""
```
to:
```
weak_tag = &"fire"
resist_tag = &"ice"
```

- [ ] **Step 2: Edit Iron Golem**

In `boss_iron_golem.tres`, change:
```
weak_tag = &""
resist_tag = &"fire"
```
to:
```
weak_tag = &"electric"
resist_tag = &"wind"
```

- [ ] **Step 3: Edit Arcane Lich**

In `boss_arcane_lich.tres`, change:
```
weak_tag = &"pierce"
resist_tag = &"ice"
```
to:
```
weak_tag = &"wind"
resist_tag = &"fire"
```

- [ ] **Step 4: Verify no `pierce` remains in boss data**

Run (Grep tool or shell): search `data/enemies/` for `pierce`. Expected: **zero matches**.

- [ ] **Step 5: Commit**

```bash
git add Prototype/godot/data/enemies/boss_slime_king.tres Prototype/godot/data/enemies/boss_iron_golem.tres Prototype/godot/data/enemies/boss_arcane_lich.tres
git commit -m "feat(combat): retag bosses to fire/ice/electric/wind (retire pierce)"
```

---

### Task 2: Verify weapon catalog covers the 4 elements per fielded class

The counter-build is only feasible if each fielded class (warrior/mage/rogue) can field multiple FTUE elements from pulled weapons. This task is a **data audit + targeted retag if a gap exists**.

**Files:**
- Inspect/Modify (only if a gap): `Prototype/godot/data/weapons/*.tres` (`cls` + `rune` fields)

- [ ] **Step 1: Build the class→elements map**

Grep `data/weapons/` for both `cls` and `rune` (Grep tool, pattern `cls|rune`, output content). For each weapon record its `cls` and `rune`. Known runes today: fire×3, ice×2, electric×3, wind×2, earth×2 (earth = gated, ignore for FTUE).

- [ ] **Step 2: Apply the coverage rule**

Rule: **each fielded class (`warrior`, `mage`, `rogue`) must own weapons spanning ≥3 of the 4 FTUE elements** (so a player can usually counter a 2-affinity stage by collecting that class). If a class is short, retag the `rune` of one of its surplus-element weapons to the missing element. Example edit (only if, say, `mage` lacks `wind`):
```
# in the chosen mage weapon .tres
rune = &"wind"
```
Do NOT touch `earth` weapons (gated content).

- [ ] **Step 3: Re-verify**

Re-grep; confirm each fielded class now spans ≥3 FTUE elements. If no edits were needed, record "coverage already sufficient" and skip the commit.

- [ ] **Step 4: Commit (only if edits made)**

```bash
git add Prototype/godot/data/weapons/<changed>.tres
git commit -m "chore(weapons): ensure per-class FTUE element coverage for counter-build"
```

---

### Task 3: `StageAffinity` deterministic module + tests

**Files:**
- Create: `Prototype/godot/scripts/core/stage_affinity.gd`
- Create: `Prototype/godot/scripts/dev/test_stage_affinity.gd`
- Create: `Prototype/godot/scenes/dev/TestStageAffinity.tscn`

- [ ] **Step 1: Create the test scene**

`TestStageAffinity.tscn` — a single Control root with the test script attached. Mirror `scenes/dev/TestForgeDraft.tscn`. Minimal `.tscn`:
```
[gd_scene load_steps=2 format=3]
[ext_resource type="Script" path="res://scripts/dev/test_stage_affinity.gd" id="1"]
[node name="TestStageAffinity" type="Control"]
script = ExtResource("1")
```

- [ ] **Step 2: Write the failing test**

`scripts/dev/test_stage_affinity.gd`:
```gdscript
## Test harness for StageAffinity — deterministic per-stage element affinities.
## Run headless: ... res://scenes/dev/TestStageAffinity.tscn
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== StageAffinity tests ===")
	_test_in_element_set()
	_test_deterministic()
	_test_stage1_mirrors_boss()
	_test_stage2plus_spread()
	_test_conflict_rate()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

const FTUE: Array = [&"fire", &"ice", &"electric", &"wind"]

func _test_in_element_set() -> void:
	var ok: bool = true
	for n in range(1, 31):
		var a: Dictionary = StageAffinity.affinity_for(n)
		if not (a[&"minion_weak"] in FTUE) or not (a[&"minion_resist"] in FTUE):
			ok = false
			break
	_check("minion tags always in the 4-element set", ok, "off-set tag found")

func _test_deterministic() -> void:
	var a1: Dictionary = StageAffinity.minion_affinity(7)
	var a2: Dictionary = StageAffinity.minion_affinity(7)
	_check("same stage -> same affinity", a1 == a2, "non-deterministic")

func _test_stage1_mirrors_boss() -> void:
	var a: Dictionary = StageAffinity.affinity_for(1)
	_check("stage 1 minion_weak == boss_weak (teaching)", a[&"minion_weak"] == a[&"boss_weak"],
		"mw=%s bw=%s" % [a[&"minion_weak"], a[&"boss_weak"]])
	_check("stage 1 minion_resist == boss_resist", a[&"minion_resist"] == a[&"boss_resist"],
		"mr=%s br=%s" % [a[&"minion_resist"], a[&"boss_resist"]])

func _test_stage2plus_spread() -> void:
	var ok: bool = true
	for n in range(2, 31):
		var a: Dictionary = StageAffinity.affinity_for(n)
		if a[&"minion_weak"] == a[&"boss_weak"]:
			ok = false
			break
	_check("stage >=2: minion_weak != boss_weak (spread)", ok, "alignment on a stage >=2")

func _test_conflict_rate() -> void:
	var conflicts: int = 0
	var total: int = 0
	for n in range(2, 31):
		total += 1
		var a: Dictionary = StageAffinity.affinity_for(n)
		if a[&"minion_weak"] == a[&"boss_resist"] and a[&"boss_resist"] != &"":
			conflicts += 1
	var rate: float = float(conflicts) / float(total)
	_check("conflict (minion_weak==boss_resist) rate >= 1/3 over stages 2..30",
		rate >= 0.3333, "rate=%.2f (%d/%d)" % [rate, conflicts, total])

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
	label.text = "\n".join(_lines)
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(label)
```

- [ ] **Step 3: Run the test — verify it FAILS**

Run `TestStageAffinity.tscn` (godot MCP `run_project` + `get_debug_output`).
Expected: parse error / `StageAffinity` not found → all checks fail (RED). Confirms the module is missing.

- [ ] **Step 4: Implement `StageAffinity`**

`scripts/core/stage_affinity.gd`:
```gdscript
## StageAffinity — deterministic per-stage element affinities for the pre-stage
## counter-build. Pure static helper (no autoload). Stage 1 mirrors the boss
## (teaching, no spread); stage >=2 the minion affinity differs from the boss
## weakness (spread) and sometimes equals the boss resistance (conflict).
class_name StageAffinity
extends RefCounted

const ELEMENTS: Array = [&"fire", &"ice", &"electric", &"wind"]

static func _boss_def(stage: int):
	return GameState.get_enemy_def(Combat.boss_for_stage(stage))

static func boss_weak(stage: int) -> StringName:
	var d = _boss_def(stage)
	return d.weak_tag if d != null else &""

static func boss_resist(stage: int) -> StringName:
	var d = _boss_def(stage)
	return d.resist_tag if d != null else &""

## Deterministic minion {weak, resist}. STARTING formula (Numbers Policy) — tune
## the index offsets if the conflict-rate test (>=1/3) fails.
static func minion_affinity(stage: int) -> Dictionary:
	var bw: StringName = boss_weak(stage)
	var br: StringName = boss_resist(stage)
	if stage <= 1:
		return {&"weak": bw, &"resist": br}   ## teaching: mirror the boss
	var n: int = ELEMENTS.size()
	var wi: int = (stage * 2 + 1) % n
	var w: StringName = ELEMENTS[wi]
	if w == bw:                                ## guarantee the spread
		w = ELEMENTS[(wi + 1) % n]
	var ri: int = (stage + 1) % n
	var r: StringName = ELEMENTS[ri]
	if r == w:
		r = ELEMENTS[(ri + 1) % n]
	return {&"weak": w, &"resist": r}

static func affinity_for(stage: int) -> Dictionary:
	var m: Dictionary = minion_affinity(stage)
	return {
		&"minion_weak": m[&"weak"], &"minion_resist": m[&"resist"],
		&"boss_weak": boss_weak(stage), &"boss_resist": boss_resist(stage),
	}
```

- [ ] **Step 5: Run the test — verify it PASSES (tune if needed)**

Run `TestStageAffinity.tscn`. Expected: `=== 6 passed / 0 failed ===`.
If `conflict-rate` fails, adjust the `wi`/`ri` offset constants in `minion_affinity` (e.g. try `wi = (stage*3) % n`) and re-run until the rate ≥ ⅓ while the spread test still passes. (Determinism + set-membership are offset-independent, so only the conflict test can wobble.)

- [ ] **Step 6: Commit**

```bash
git add Prototype/godot/scripts/core/stage_affinity.gd Prototype/godot/scripts/dev/test_stage_affinity.gd Prototype/godot/scenes/dev/TestStageAffinity.tscn
git commit -m "feat(combat): deterministic StageAffinity (stage1 mirrors boss, stage2+ spread/conflict)"
```

---

### Task 4: Wire stage-defined minion affinity into Combat (retire random + pierce)

**Files:**
- Modify: `Prototype/godot/scripts/core/combat.gd:57` (TAG_POOL), `:510-516` (minion tagging)
- Test: `scripts/dev/test_stage_affinity.gd` (add a spawn-integration check) + run `TestCombat`

- [ ] **Step 1: Add the failing integration check**

Append to `test_stage_affinity.gd`'s `_ready()` (before `_summary()`): `_test_combat_minions_use_affinity()`. Add the method:
```gdscript
func _test_combat_minions_use_affinity() -> void:
	## Each minion must be EITHER the stage affinity OR un-classed (empty) — never a
	## foreign element. (Asserts the invariant, not the exact 20% split, to avoid RNG flake.)
	GameState.new_session()
	GameState.run_stage = 3
	var exp: Dictionary = StageAffinity.minion_affinity(3)
	var ok: bool = true
	var saw_any: bool = false
	for _w in range(8):
		Combat.start_wave(1, false)   ## auto_tick=false: spawn only, no timers
		for e in GameState.enemies:
			if e.get(&"is_boss", false):
				continue
			saw_any = true
			var is_aff: bool = e[&"weak"] == exp[&"weak"] and e[&"resist"] == exp[&"resist"]
			var is_unclassed: bool = e[&"weak"] == &"" and e[&"resist"] == &""
			if not (is_aff or is_unclassed):
				ok = false
		Combat.stop()
	_check("stage-3 minions are EITHER stage-affinity OR un-classed (never foreign)", ok and saw_any,
		"a minion had foreign tags")
```

- [ ] **Step 2: Run — verify it FAILS**

Run `TestStageAffinity.tscn`. Expected: the new check FAILS (minions still get random tags from `TAG_POOL`).

- [ ] **Step 3: Replace the random tagging in `combat.gd`**

In `_spawn_enemies`, replace the block at lines ~510-516:
```gdscript
		var weak: StringName = TAG_POOL[randi() % TAG_POOL.size()]
		var resist: StringName = &""
		if randf() < RESIST_CHANCE:
			var resist_pool: Array = TAG_POOL.duplicate()
			resist_pool.erase(weak)
			if not resist_pool.is_empty():
				resist = resist_pool[randi() % resist_pool.size()]
```
with:
```gdscript
		## 80% carry the stage affinity; ~20% spawn un-classed (no weak/resist) for flavor.
		var weak: StringName = &""
		var resist: StringName = &""
		if randf() >= UNCLASSED_CHANCE:
			var _aff: Dictionary = StageAffinity.minion_affinity(GameState.run_stage)
			weak = _aff[&"weak"]
			resist = _aff[&"resist"]
```
(The `weak`/`resist` vars are consumed unchanged by the `GameState.enemies.append({...})` below.)

- [ ] **Step 4: Retire `pierce` / dead constants**

In `combat.gd:57`, change `TAG_POOL` to the canonical set and add the un-classed chance:
```gdscript
const TAG_POOL: Array = [&"fire", &"ice", &"electric", &"wind"]
const UNCLASSED_CHANCE: float = 0.20   ## ~20% of minions spawn with no weak/resist (flavor; tunable)
```
`RESIST_CHANCE` (line 58) is now unused — leave it (harmless) or delete it. Grep `combat.gd` for `pierce`: expect zero matches.

- [ ] **Step 5: Run the affinity test — verify PASS**

Run `TestStageAffinity.tscn`. Expected: `=== 7 passed / 0 failed ===`.

- [ ] **Step 6: Run `TestCombat` — verify still GREEN (the contract)**

Run `scenes/dev/TestCombat.tscn` (needs `--quit-after 400` on the console exe; via MCP `run_project` then `stop_project` after the summary prints). Expected: the full combat suite passes unchanged.
- If `TestCombat` spawns via `start_wave` and asserts on the OLD random tags, it was testing removed behavior → update those assertions to `StageAffinity.minion_affinity(GameState.run_stage)`. If it injects enemies via a force path (likely), it is unaffected and should pass as-is.

- [ ] **Step 7: Commit**

```bash
git add Prototype/godot/scripts/core/combat.gd Prototype/godot/scripts/dev/test_stage_affinity.gd
git commit -m "feat(combat): minions use StageAffinity tags instead of random roll"
```

---

### Task 5: Pre-stage briefing panel on Home

A panel that, on START BATTLE, shows the upcoming stage's minion + boss affinities and the squad's current elements (with mismatch flags), then launches the battle.

**Files:**
- Modify: `Prototype/godot/scripts/core/stage_affinity.gd` (add a tested briefing-data helper)
- Modify: `Prototype/godot/scripts/dev/test_stage_affinity.gd` (test the helper)
- Modify: `Prototype/godot/scripts/ui/home_screen.gd` (render the panel; intercept `_on_battle_pressed`)

- [ ] **Step 1: Failing test for the briefing helper**

Add to `_ready()`: `_test_briefing_mismatch()`, and the method:
```gdscript
func _test_briefing_mismatch() -> void:
	## squad fields the boss-weak element but NOT the minion-weak element.
	var a: Dictionary = StageAffinity.affinity_for(3)
	var squad_elems: Array = [a[&"boss_weak"]]          ## only covers the boss
	var b: Dictionary = StageAffinity.briefing(3, squad_elems)
	_check("briefing exposes minion + boss affinity", b.has(&"minion_weak") and b.has(&"boss_weak"),
		"missing keys")
	_check("briefing flags the uncovered minion weakness",
		b[&"minion_weak_covered"] == false, "minion-weak wrongly marked covered")
	_check("briefing marks the covered boss weakness",
		b[&"boss_weak_covered"] == true, "boss-weak wrongly uncovered")
```

- [ ] **Step 2: Run — verify FAIL** (`briefing` method missing). Run `TestStageAffinity.tscn`.

- [ ] **Step 3: Implement `StageAffinity.briefing`**

Append to `stage_affinity.gd`:
```gdscript
## Briefing data for the pre-stage panel: the affinities + whether the squad's
## equipped elements cover each weakness. `squad_elements` = Array[StringName].
static func briefing(stage: int, squad_elements: Array) -> Dictionary:
	var a: Dictionary = affinity_for(stage)
	a[&"minion_weak_covered"] = a[&"minion_weak"] in squad_elements
	a[&"boss_weak_covered"] = a[&"boss_weak"] in squad_elements
	## a resisted element you're bringing is a soft warning (wasted on that target)
	a[&"minion_resist_brought"] = a[&"minion_resist"] in squad_elements
	a[&"boss_resist_brought"] = a[&"boss_resist"] in squad_elements
	return a
```

- [ ] **Step 4: Run — verify PASS** (`=== N passed / 0 failed ===`). Commit the helper:

```bash
git add Prototype/godot/scripts/core/stage_affinity.gd Prototype/godot/scripts/dev/test_stage_affinity.gd
git commit -m "feat(home): StageAffinity.briefing data helper (mismatch flags)"
```

- [ ] **Step 5: Render the briefing panel + intercept START BATTLE**

In `home_screen.gd`, replace `_on_battle_pressed` (lines 387-388):
```gdscript
func _on_battle_pressed() -> void:
	_open_briefing()
```
Add a reusable confirm-style panel built once in `_build_ui()` (after the `_confirm` block, ~line 163):
```gdscript
	_briefing = ConfirmationDialog.new()
	_briefing.title = "Stage Briefing"
	_briefing.ok_button_text = "⚔ ENTER STAGE"
	_briefing.cancel_button_text = "Adjust Loadout"
	_briefing.confirmed.connect(func(): get_tree().change_scene_to_file("res://scenes/Main.tscn"))
	add_child(_briefing)
```
Add the field near the other vars (~line 39): `var _briefing: ConfirmationDialog = null`.
Add the builder:
```gdscript
func _open_briefing() -> void:
	var stage: int = AccountState.current_stage
	var squad_elems: Array = []
	for id in ROSTER_IDS:
		var w = AccountState.get_equipped(id)
		if w != null and w.rune != &"":
			squad_elems.append(w.rune)
	var b: Dictionary = StageAffinity.briefing(stage, squad_elems)
	var ic := func(t): return _elem_icon(t)
	var lines: Array = []
	lines.append("STAGE %d" % stage)
	lines.append("Minions   weak %s   resist %s   %s" % [ic.call(b[&"minion_weak"]),
		ic.call(b[&"minion_resist"]), ("✅" if b[&"minion_weak_covered"] else "⚠️ not covered")])
	lines.append("👑 Boss   weak %s   resist %s   %s" % [ic.call(b[&"boss_weak"]),
		ic.call(b[&"boss_resist"]), ("✅" if b[&"boss_weak_covered"] else "⚠️ not covered")])
	lines.append("")
	lines.append("Your squad: %s" % "  ".join(squad_elems.map(func(e): return ic.call(e))))
	if b[&"minion_resist_brought"] or b[&"boss_resist_brought"]:
		lines.append("⚠️ You're bringing a RESISTED element (½ damage on that target).")
	_briefing.dialog_text = "\n".join(lines)
	_briefing.popup_centered()
```

- [ ] **Step 6: Manual verify (godot MCP)**

`run_project(scene="res://scenes/Home.tscn")` → `get_debug_output`/`capture_viewport`: tap START BATTLE → the briefing shows the stage's two affinities + squad elements + mismatch; "Adjust Loadout" closes it (stay on Home), "⚔ ENTER STAGE" loads Main. `stop_project`.

- [ ] **Step 7: Commit**

```bash
git add Prototype/godot/scripts/ui/home_screen.gd
git commit -m "feat(home): pre-stage briefing panel (telegraph affinities + mismatch) before battle"
```

---

### Task 6: Defeat routes to the squad/loadout screen (remove ReforgeRetryModal)

**Files:**
- Modify: `Prototype/godot/scripts/ui/main.gd` (`_on_squad_wiped`, `_ready` connections, retry handlers)

- [ ] **Step 1: Rewrite `_on_squad_wiped`** (lines 153-163) to route every wipe straight to Home:
```gdscript
func _on_squad_wiped() -> void:
	_notifications.show_banner("💀 DEFEATED — rebuild your loadout", Color(1, 0.3, 0.3), 1.3)
	await get_tree().create_timer(1.3).timeout
	_on_back_home()
```

- [ ] **Step 2: Remove the ReforgeRetryModal wiring.**
- Delete the `@onready var _reforge_retry_modal` line (34).
- Delete the two `_reforge_retry_modal.*.connect(...)` lines (53-54).
- Delete `_on_retry_pressed` (167-171) and `_on_give_up_pressed` (173-174).
(The `%ReforgeRetryModal` node can stay in `Main.tscn` unused — leave the scene file alone.)

- [ ] **Step 3: Manual verify (godot MCP)**

`run_project(scene="res://scenes/Main.tscn")`; let the squad lose a wave (or force a wipe). Expected: "💀 DEFEATED — rebuild your loadout" banner, then the app returns to `Home.tscn` (the squad/loadout). No retry modal appears. `stop_project`.

- [ ] **Step 4: Sanity — run the self-quitting suites**

Run `TestStageAffinity`, `TestForgeDraft`, `TestAccountState` (and `TestCombat`). Expected: all green — this task only touches `main.gd` UI flow, which the dev suites don't load, so they must be unaffected.

- [ ] **Step 5: Commit**

```bash
git add Prototype/godot/scripts/ui/main.gd
git commit -m "feat(combat): defeat returns to squad/loadout (remove ReforgeRetryModal; sidesteps FM-14)"
```

---

## Self-review

**Spec coverage:**
- §4 boss retag → Task 1. ✅
- §5 element set Fire/Ice/Electric/Wind + retire pierce → Task 1 (boss) + Task 4 (TAG_POOL/minions). ✅
- §5 per-class catalog coverage → Task 2. ✅
- §4 minion affinity (stage1 mirror, stage≥2 spread, ≥⅓ conflict, deterministic) → Task 3. ✅
- §4 replace random minion weak/resist → Task 4. ✅
- §6 pre-stage briefing screen (affinities + squad elements + mismatch) → Task 5. ✅
- §9/§11 defeat → squad/loadout, no retry modal → Task 6. ✅
- §10 stage-1-neutral guard → Task 4 Step 6. ✅
- Counter math (weak ×1.8/resist ×0.5) → already in combat (`_hero_attack`), unchanged — no task needed (verified present at combat.gd:365-370). ✅

**Placeholder scan:** Task 2 is a verification-with-conditional-edit (rule + command + example given) — acceptable, not a vague TODO. No "TBD"/"handle edge cases"/"write tests for the above" present.

**Type consistency:** `StageAffinity.minion_affinity(stage) -> {weak,resist}`, `affinity_for(stage) -> {minion_weak,minion_resist,boss_weak,boss_resist}`, `briefing(stage, Array) -> + *_covered/*_brought` — used consistently across Tasks 3/4/5. `boss_for_stage` and `get_enemy_def` are existing autoload methods (combat.gd:84, GameState). Test harness shape matches `test_forge_draft.gd`.

**Risk note:** Task 4 Step 6 is the one place that can surface a hidden coupling (TestCombat asserting old random tags); the step gives the contingency. Everything else is additive or isolated.
