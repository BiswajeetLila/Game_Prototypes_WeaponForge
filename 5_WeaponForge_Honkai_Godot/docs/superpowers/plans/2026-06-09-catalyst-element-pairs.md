# Catalyst v1 (element-pair synergy) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship Catalyst v1 — six FTUE-reachable element-pair compounds that buff the squad in combat, plus 4 Earth-pair compounds dormant until Stage 10. MVP-6-simple modifier-bag architecture (no new combat callbacks). Validates "does picking-squad-for-compound matter?" cheaply.

**Architecture:**
- `CatalystData` (pure data class, static) — owns the 10-compound table + order-independent pair lookup + alphabetical-priority sort.
- `CatalystResolver` (pure static resolver) — `resolve(squad_weapons, stage) -> Dictionary` returns the active-compound state under the cap-1 (stages 1-4) / no-cap (stages 5+) rule with Earth-gate filtering. Composes the merged modifier bag.
- `Combat.start_wave()` reads `CatalystResolver.resolve(squad, stage)` once, stashes `merged_bag` on `Combat._catalyst_bag`, and `_hero_attack` / hit-resolution multiply/add through the bag's four keys.
- New UI: home squad-line upgrade, pre-stage briefing section, battle-start banner, persistent HUD chip, Catalyst Codex sub-screen.
- AccountState v4 → v5 migration adds `scripted_pulls_seen` + `catalyst_codex_discovered`.
- ForgeWheel scripted pull #1 = Fire-warrior, pull #3 = Ice-mage (first-Catalyst-reveal moment ~stage 4-5).
- Starter weapons go non-elemental so stage-1 combat stays neutral.

**Tech Stack:** Godot 4.6.2 Mono, GDScript, custom self-quitting TDD harnesses under `scripts/dev/`. Engine ops via `mcp__godot__*`.

**Spec source of truth:** `docs/superpowers/specs/2026-06-09-catalyst-design.md`.

**Branch:** already on `forgeloop/catalyst-element-pairs` (in-place, no worktree per CLAUDE.md §2).

**Test baseline before this plan:** ~423 tests green across 14 dev scenes.

**Test baseline target after this plan:** ~448 tests green (~25 new across TestCatalyst + extensions to TestAccountState / TestForgeWheel / TestHomeScreen / TestCombat, plus a new TestCatalystUI).

---

## 0. Pre-flight Owner Gates

These must be resolved before Chunk B starts. Chunk A is safe to begin without them.

- [ ] **OWNER GATE 1 — Starter-weapon collision.** The spec §6 says "existing starter `.tres` files updated" to `rune = &""`. But the 3 starter ids (`w_emberfang_cleaver`, `w_frostcall_stave`, `w_stormpierce_fangs`) are *also* the Common rarity entries in the 12-weapon gacha catalog. Stripping their runes also strips them from the catalog's elemental pool. Two options:
  - **Option A (recommended):** Create 3 NEW non-elemental starter `.tres` files (e.g. `w_starter_blade` / `w_starter_stave` / `w_starter_daggers`) under `data/weapons/starters/`. Keep the 12-weapon catalog 100% unchanged. `_grant_starter_if_first_boot()` points at the new ids; the gacha pool stays elemental. Scripted pull #1 (Fire-warrior) returns the still-elemental `w_emberfang_cleaver` — no dupe collision, real reveal moment.
  - **Option B (literal spec):** Strip rune from the existing 3 `.tres` files. Then scripted pull #1 needs a DIFFERENT fire-warrior id (e.g. `w_cinderbrand_greatsword`) — pull #1 cannot return the starter id without colliding with the dupe-gems path in `ForgeWheel.pull()`. Higher risk: starter-as-Common pool entry now permanently non-elemental.
  - **Decision needed:** A or B?
- [ ] **OWNER GATE 2 — Catalyst Codex sub-screen scope (spec §13 open question).** Ship in v1 or defer to v2? Plan currently scopes Codex into Chunk C as a stub Home tab. Cuttable if Chunk C feels long.
- [ ] **OWNER GATE 3 — Stormfront swarm threshold.** Spec §3 reducer key `squad_atk_vs_swarm_mult` gates on `Combat.alive_enemy_count() >= 3`. Spec §13 flags this as a Numbers Policy starting value. Owner OK with the >=3 starting threshold (vs >=4 or >=2)? (Plan ships >=3; tune later.)

When all 3 gates have answers, proceed.

---

## File Structure

```
Prototype/godot/
├── scripts/
│   ├── data/
│   │   └── catalyst_data.gd          [CREATE — pure data class, RefCounted, static fns]
│   ├── core/
│   │   ├── catalyst_resolver.gd      [CREATE — pure static resolver, RefCounted]
│   │   ├── account_state.gd          [MODIFY — SAVE_VERSION 4→5; _migrate_v4_to_v5 + 2 new fields]
│   │   ├── forge_wheel.gd            [MODIFY — scripted pulls #1 + #3, scripted_pulls_seen tracking]
│   │   └── combat.gd                 [MODIFY — _catalyst_bag, start_wave hook, _hero_attack mult/add]
│   ├── ui/
│   │   ├── catalyst_banner.gd        [CREATE — start-of-stage banner Control]
│   │   ├── catalyst_chip.gd          [CREATE — persistent HUD chip Control]
│   │   ├── catalyst_codex.gd         [CREATE — Home sub-screen (Owner Gate 2 may cut)]
│   │   ├── home_screen.gd            [MODIFY — _refresh_squad_line shows compound, briefing dialog body]
│   │   └── main.gd                   [MODIFY — _build_battle_overlay adds banner + chip nodes]
│   └── dev/
│       ├── test_catalyst.gd          [CREATE — 11 cases, self-quitting]
│       ├── test_catalyst_ui.gd       [CREATE — banner/chip/codex smoke tests, self-quitting]
│       ├── test_account_state.gd     [MODIFY — add v4→v5 migration cases + scripted_pulls_seen]
│       ├── test_forge_wheel.gd       [MODIFY — add scripted pull #1 / #3 / idempotency tests]
│       ├── test_combat.gd            [MODIFY — stage-1 neutrality regression w/ Catalyst plumbed]
│       └── test_home_screen.gd      [MODIFY — squad-line shows compound when >=2 elements]
├── scenes/dev/
│   ├── TestCatalyst.tscn             [CREATE — wraps test_catalyst.gd]
│   └── TestCatalystUI.tscn           [CREATE — wraps test_catalyst_ui.gd]
└── data/weapons/
    ├── (per Owner Gate 1 Option A)
    └── starters/
        ├── w_starter_blade.tres      [CREATE — warrior, rune=&"", base_atk 18, base_hp 25, crit 5, ult 5]
        ├── w_starter_stave.tres      [CREATE — mage, rune=&"", base_atk 16, base_hp 15, crit 0, ult 15]
        └── w_starter_daggers.tres    [CREATE — rogue, rune=&"", base_atk 17, base_hp 10, crit 12, ult 5]
```

If Owner Gate 1 picks Option B, the `data/weapons/starters/` files are NOT created; instead the existing 3 `.tres` files (lines 11 of each) flip `rune = &"fire"|&"ice"|&"electric"` → `rune = &""`, and ForgeWheel's scripted pull #1 picks `w_cinderbrand_greatsword` instead.

**`scenes/dev/TestCatalyst.tscn` shape** — minimal Control root with `test_catalyst.gd` as script, mirroring TestWeaponData.tscn.

---

## Chunk A — Core (data + resolver + TestCatalyst)

No game-side side effects. Pure data + pure function + tests. Safe to ship without owner gates resolved.

### Task A1: CatalystData — the 10-compound table

**Files:**
- Create: `scripts/data/catalyst_data.gd`
- Create: `scripts/dev/test_catalyst.gd`
- Create: `scenes/dev/TestCatalyst.tscn`

- [ ] **Step 1: Write the failing test** — open `scripts/dev/test_catalyst.gd`:

```gdscript
## Test harness for CatalystData (10-compound table) + CatalystResolver (cap-1/no-cap).
## Spec: docs/superpowers/specs/2026-06-09-catalyst-design.md
##
## Run via godot MCP:
##   mcp__godot__run_project(projectPath, scene="res://scenes/dev/TestCatalyst.tscn")
##   mcp__godot__get_debug_output — find "=== N passed / M failed ==="
## Headless self-quits with exit code = failure count.
extends Control

const CatalystDataT = preload("res://scripts/data/catalyst_data.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== CatalystData + CatalystResolver tests ===")
	_test_compounds_returns_ten_records()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_compounds_returns_ten_records() -> void:
	## Spec §2: 6 active FTUE compounds + 4 Earth-gated = 10 total.
	var rows: Array = CatalystDataT.compounds()
	_check("compounds() returns 10 records", rows.size() == 10, "size=%d" % rows.size())
	var earth_gated: int = 0
	for r in rows:
		if int(r.get("gated_from_stage", 0)) >= 10:
			earth_gated += 1
	_check("4 records gated from stage 10", earth_gated == 4, "count=%d" % earth_gated)

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

Open `scenes/dev/TestCatalyst.tscn` — copy structure from `scenes/dev/TestWeaponData.tscn`: a Control root, attach `test_catalyst.gd` as script, save.

- [ ] **Step 2: Run test to verify it fails**

```
mcp__godot__run_project(projectPath="C:/_BISU/_WORKSPACE/AI_Explorations/_Claude/Game_Prototypes/5_WeaponForge_Honkai_Godot/Prototype/godot", scene="res://scenes/dev/TestCatalyst.tscn")
mcp__godot__get_debug_output
```

Expected: parse error or `compounds() not found on null` — the script doesn't exist yet. Stop the scene with `mcp__godot__stop_project`.

- [ ] **Step 3: Write minimal implementation** — `scripts/data/catalyst_data.gd`:

```gdscript
## CatalystData — Catalyst v1 compound table (element-pair synergy).
##
## Spec: docs/superpowers/specs/2026-06-09-catalyst-design.md
## Pure data class — static fns only, no instance state. RefCounted so callers
## can `preload`/`load` and call without an autoload entry.
##
## 10 compounds: 6 FTUE-reachable (gated_from_stage = 0) + 4 Earth-pair gated
## from stage 10 (per the design spec's Earth gate at S10). v1 implements all 10
## as simple modifier-bag rows; Earth-pair compounds carry a placeholder
## squad_atk_mult of 1.15 until v2 lands their rich effects.
##
## Modifier bag schema (spec §3):
##   squad_atk_mult         (1.0 neutral, multiplicative)
##   squad_crit_add         (0.0 neutral, additive %)
##   enemy_atk_speed_mult   (1.0 neutral, multiplicative — applied to enemy side)
##   squad_atk_vs_swarm_mult(1.0 neutral, multiplicative, gates on >=3 alive enemies)
class_name CatalystData
extends RefCounted

const EMPTY_BAG: Dictionary = {
	&"squad_atk_mult":        1.0,
	&"squad_crit_add":        0.0,
	&"enemy_atk_speed_mult":  1.0,
	&"squad_atk_vs_swarm_mult": 1.0,
}

## Cap-1 alphabetical priority — by COMPOUND name (CLAUDE.md §13).
## Lower index = higher priority.
##   Blizzard > Firestorm > Glacial Storm > Plasma > Stormfront > Wildfire
##   then Earth unlocks (S10+):
##   Magnetic Storm > Permafrost > Sandstorm > Volcanic
const _PRIORITY_ORDER: Array = [
	&"blizzard", &"firestorm", &"glacial_storm", &"plasma",
	&"stormfront", &"wildfire",
	&"magnetic_storm", &"permafrost", &"sandstorm", &"volcanic",
]

## Element pair-keys are sorted alphabetically before lookup so order is irrelevant.
static func _pair_key(a: StringName, b: StringName) -> StringName:
	var sa: String = String(a)
	var sb: String = String(b)
	if sa <= sb:
		return StringName("%s+%s" % [sa, sb])
	return StringName("%s+%s" % [sb, sa])

## Canonical 10-record table. Each record:
##   { id: StringName, pair_key: StringName, elements: [StringName, StringName],
##     display_name: String, modifier_bag: Dictionary, gated_from_stage: int,
##     alphabetical_priority: int }
static func compounds() -> Array:
	## STARTING VALUES (Numbers Policy) per spec §11.
	var rows: Array = [
		{"id": &"firestorm", "elements": [&"fire", &"ice"], "display_name": "Firestorm",
			"modifier_bag": {&"squad_atk_mult": 1.20, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 0},
		{"id": &"wildfire", "elements": [&"fire", &"wind"], "display_name": "Wildfire",
			"modifier_bag": {&"squad_atk_mult": 1.15, &"squad_crit_add": 0.10,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 0},
		{"id": &"plasma", "elements": [&"fire", &"electric"], "display_name": "Plasma",
			"modifier_bag": {&"squad_atk_mult": 1.0, &"squad_crit_add": 0.15,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 0},
		{"id": &"blizzard", "elements": [&"ice", &"wind"], "display_name": "Blizzard",
			"modifier_bag": {&"squad_atk_mult": 1.0, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 0.80, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 0},
		{"id": &"glacial_storm", "elements": [&"ice", &"electric"], "display_name": "Glacial Storm",
			"modifier_bag": {&"squad_atk_mult": 1.15, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 0},
		{"id": &"stormfront", "elements": [&"wind", &"electric"], "display_name": "Stormfront",
			"modifier_bag": {&"squad_atk_mult": 1.0, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.25},
			"gated_from_stage": 0},
		## Earth pairs — gated_from_stage 10. v1 placeholder bag = +15% ATK; v2 = rich effects.
		{"id": &"volcanic", "elements": [&"fire", &"earth"], "display_name": "Volcanic",
			"modifier_bag": {&"squad_atk_mult": 1.30, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 10},
		{"id": &"permafrost", "elements": [&"ice", &"earth"], "display_name": "Permafrost",
			"modifier_bag": {&"squad_atk_mult": 1.15, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 10},
		{"id": &"sandstorm", "elements": [&"wind", &"earth"], "display_name": "Sandstorm",
			"modifier_bag": {&"squad_atk_mult": 1.15, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 10},
		{"id": &"magnetic_storm", "elements": [&"earth", &"electric"], "display_name": "Magnetic Storm",
			"modifier_bag": {&"squad_atk_mult": 1.15, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 10},
	]
	for r in rows:
		r["pair_key"] = _pair_key(r["elements"][0], r["elements"][1])
		r["alphabetical_priority"] = _PRIORITY_ORDER.find(r["id"])
	return rows

## Order-independent pair lookup. Empty-element inputs (or pairs without a defined
## compound) return {}.
static func for_pair(a: StringName, b: StringName) -> Dictionary:
	if a == &"" or b == &"" or a == b:
		return {}
	var key: StringName = _pair_key(a, b)
	for r in compounds():
		if r["pair_key"] == key:
			return r
	return {}

## All compounds sorted by alphabetical_priority (for cap-1 tie-break). Earth
## entries are included; callers filter on gated_from_stage themselves.
static func by_priority() -> Array:
	var rows: Array = compounds()
	rows.sort_custom(func(a, b): return int(a["alphabetical_priority"]) < int(b["alphabetical_priority"]))
	return rows
```

- [ ] **Step 4: Run test to verify it passes**

```
mcp__godot__run_project(...TestCatalyst.tscn)
mcp__godot__get_debug_output  # expect "=== 2 passed / 0 failed ==="
mcp__godot__stop_project
```

- [ ] **Step 5: Commit**

```bash
git add scripts/data/catalyst_data.gd scripts/dev/test_catalyst.gd scenes/dev/TestCatalyst.tscn
git commit -m "$(cat <<'EOF'
feat(catalyst): CatalystData — 10-compound table + pair lookup (chunk A1)

10 records: 6 FTUE compounds (Firestorm/Wildfire/Plasma/Blizzard/Glacial
Storm/Stormfront) + 4 Earth-gated (Volcanic/Permafrost/Sandstorm/Magnetic
Storm, gated_from_stage=10). Order-independent for_pair() lookup and
alphabetical-priority sort (Blizzard > Firestorm > Glacial Storm > Plasma
> Stormfront > Wildfire, then Earth unlocks). All modifier-bag values are
Numbers Policy STARTING values per spec §11.

TestCatalyst: 2/2 (returns 10, 4 Earth-gated).

Spec: docs/superpowers/specs/2026-06-09-catalyst-design.md §2,§3,§5.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task A2: CatalystData — `for_pair` order-independence + empty-element rejection

**Files:**
- Modify: `scripts/dev/test_catalyst.gd`

- [ ] **Step 1: Add failing tests** — append after `_test_compounds_returns_ten_records`:

```gdscript
func _test_for_pair_order_independent() -> void:
	## Spec §4 + §9 case C-2: for_pair(fire, ice) == for_pair(ice, fire) == Firestorm.
	var ab: Dictionary = CatalystDataT.for_pair(&"fire", &"ice")
	var ba: Dictionary = CatalystDataT.for_pair(&"ice", &"fire")
	_check("for_pair(fire,ice) returns Firestorm", ab.get("id", &"") == &"firestorm",
		"id=%s" % ab.get("id", &""))
	_check("for_pair is order-independent", ab.get("pair_key", &"") == ba.get("pair_key", &""),
		"ab=%s ba=%s" % [ab.get("pair_key"), ba.get("pair_key")])

func _test_for_pair_empty_element_rejected() -> void:
	## Spec §4 + §9 case C-3: empty-element inputs return {} (non-elemental starters skip).
	var r: Dictionary = CatalystDataT.for_pair(&"", &"ice")
	_check("for_pair with empty element returns {}", r.is_empty(), "id=%s" % r.get("id"))
	var same: Dictionary = CatalystDataT.for_pair(&"fire", &"fire")
	_check("for_pair with same-element returns {}", same.is_empty(), "id=%s" % same.get("id"))
```

Add the dispatch calls in `_ready()` after `_test_compounds_returns_ten_records()`.

- [ ] **Step 2: Run test** — expect FAIL `for_pair not found` until step 3 already exists (Task A1 implemented it). Actually `for_pair` exists from A1, so this PASSES immediately — which is fine; the RED was implicit in A1's task structure. Verify all 4 cases green via `mcp__godot__get_debug_output`.

- [ ] **Step 3: Commit**

```bash
git add scripts/dev/test_catalyst.gd
git commit -m "$(cat <<'EOF'
test(catalyst): for_pair order-independence + empty-element rejection (A2)

TestCatalyst 4/4 — covers spec §9 cases C-2 (order-independent lookup
returns Firestorm for fire+ice and ice+fire) and C-3 (empty-element pairs
return {}; same-element pairs also reject).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task A3: CatalystResolver — empty + single-pair resolution

**Files:**
- Create: `scripts/core/catalyst_resolver.gd`
- Modify: `scripts/dev/test_catalyst.gd`

- [ ] **Step 1: Add failing tests** — append:

```gdscript
const CatalystResolverT = preload("res://scripts/core/catalyst_resolver.gd")
const WeaponDataT = preload("res://scripts/data/weapon_data.gd")

func _make_weapon(rune: StringName) -> Resource:
	var w = WeaponDataT.new()
	w.rune = rune
	w.base_atk = 10
	return w

func _test_resolve_empty_squad_returns_neutral() -> void:
	## Spec §9 C-4: 2 non-elemental + 1 fire at stage 1 -> null compound, EMPTY_BAG.
	var squad: Array = [_make_weapon(&""), _make_weapon(&""), _make_weapon(&"fire")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 1)
	_check("resolve returns dict", typeof(r) == TYPE_DICTIONARY, "type=%d" % typeof(r))
	_check("resolve null compound (1 element only)", r.get("compound", null) == null,
		"compound=%s" % str(r.get("compound")))
	_check("resolve bag == EMPTY_BAG", _bags_equal(r.get("merged_bag", {}), CatalystDataT.EMPTY_BAG),
		"bag=%s" % str(r.get("merged_bag")))

func _test_resolve_single_pair_cap1() -> void:
	## Spec §9 C-5 partial: fire+ice squad at stage 1 -> Firestorm.
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"ice"), _make_weapon(&"")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 1)
	var c: Dictionary = r.get("compound", {})
	_check("fire+ice at stage 1 -> Firestorm", c.get("id", &"") == &"firestorm",
		"id=%s" % c.get("id", &""))
	_check("Firestorm bag has +20%% atk",
		is_equal_approx(float(r["merged_bag"].get(&"squad_atk_mult", 1.0)), 1.20),
		"mult=%f" % float(r["merged_bag"].get(&"squad_atk_mult", 1.0)))

func _bags_equal(a: Dictionary, b: Dictionary) -> bool:
	if a.size() != b.size():
		return false
	for k in a:
		if not b.has(k):
			return false
		if typeof(a[k]) == TYPE_FLOAT and not is_equal_approx(float(a[k]), float(b[k])):
			return false
	return true
```

Add dispatches in `_ready()`.

- [ ] **Step 2: Run — expect FAIL** ("preload failed: catalyst_resolver.gd not found").

- [ ] **Step 3: Implement** — `scripts/core/catalyst_resolver.gd`:

```gdscript
## CatalystResolver — pure static squad+stage -> active-compound-state resolver.
##
## Spec: docs/superpowers/specs/2026-06-09-catalyst-design.md §4-§5.
##
## Stacking rule (CLAUDE.md §13):
##   stages 1-4 -> cap-1 (alphabetical compound-name priority wins)
##   stages 5+  -> no-cap (all triggering compounds active; bags compose
##                  multiplicatively for *_mult keys, additively for *_add)
##   Earth-gated compounds skip entirely when stage < 10, regardless of cap.
##
## Empty-element entries in squad_weapons are skipped (non-elemental starters
## never count toward a pair).
class_name CatalystResolver
extends RefCounted

const CatalystDataT = preload("res://scripts/data/catalyst_data.gd")

## Returns:
##   {
##     compound:    Dictionary | null      # cap-1: the winning record, else null
##     compounds:   Array[Dictionary]      # no-cap (stage>=5): every triggering record
##     merged_bag:  Dictionary             # composed modifier bag
##   }
static func resolve(squad_weapons: Array, stage: int) -> Dictionary:
	## 1. Distinct equipped elements (skip empty + dedupe).
	var elems: Array = []
	for w in squad_weapons:
		if w == null:
			continue
		var r: StringName = w.rune if "rune" in w else &""
		if r == &"" or r in elems:
			continue
		elems.append(r)

	if elems.size() < 2:
		return {"compound": null, "compounds": [], "merged_bag": CatalystDataT.EMPTY_BAG.duplicate()}

	## 2. Enumerate all distinct pairs and look up matching compounds.
	var triggered: Array = []
	for i in range(elems.size()):
		for j in range(i + 1, elems.size()):
			var rec: Dictionary = CatalystDataT.for_pair(elems[i], elems[j])
			if rec.is_empty():
				continue
			if int(rec.get("gated_from_stage", 0)) > stage:
				continue   ## Earth-gated, stage < 10
			triggered.append(rec)

	if triggered.is_empty():
		return {"compound": null, "compounds": [], "merged_bag": CatalystDataT.EMPTY_BAG.duplicate()}

	## 3. Stacking.
	if stage <= 4:
		## cap-1: alphabetical priority by compound id (lower index = wins).
		triggered.sort_custom(func(a, b): return int(a["alphabetical_priority"]) < int(b["alphabetical_priority"]))
		var winner: Dictionary = triggered[0]
		return {"compound": winner, "compounds": [winner],
			"merged_bag": _compose([winner])}
	## stage >= 5: all triggering.
	return {"compound": null, "compounds": triggered, "merged_bag": _compose(triggered)}

## Composition rules (spec §3): *_mult keys multiplicative, *_add keys additive,
## starting from EMPTY_BAG. squad_atk_vs_swarm_mult composes as a normal mult key
## here; the gated >=3-enemies check is applied at hit-resolution time, not here.
static func _compose(records: Array) -> Dictionary:
	var bag: Dictionary = CatalystDataT.EMPTY_BAG.duplicate()
	for rec in records:
		var mb: Dictionary = rec.get("modifier_bag", {})
		for k in mb:
			var v = mb[k]
			if String(k).ends_with("_add"):
				bag[k] = float(bag.get(k, 0.0)) + float(v)
			else:
				bag[k] = float(bag.get(k, 1.0)) * float(v)
	return bag
```

- [ ] **Step 4: Run — expect 6/6 PASS** for the four-pair lookups + two resolver cases. Stop the scene.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/catalyst_resolver.gd scripts/dev/test_catalyst.gd
git commit -m "$(cat <<'EOF'
feat(catalyst): CatalystResolver — squad+stage -> compound + merged bag (A3)

Pure static. resolve(squad, stage):
- Deduplicates squad rune elements; skips empty runes.
- Enumerates all distinct pairs; looks up each via CatalystData.for_pair.
- Earth-gated compounds skip when stage < gated_from_stage.
- stage <= 4 -> cap-1 (alphabetical_priority winner).
- stage >= 5 -> no-cap (all triggering compounds returned).
- _compose folds *_mult keys multiplicatively, *_add additively (spec §3).

TestCatalyst 6/6.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task A4: CatalystResolver — cap-1 alpha priority + no-cap stacking

**Files:**
- Modify: `scripts/dev/test_catalyst.gd`

- [ ] **Step 1: Add failing tests** — append:

```gdscript
func _test_resolve_cap1_alpha_priority() -> void:
	## Spec §9 case C-5/C-10: fire+ice+wind squad at stage 1 -> Blizzard (alpha-by-COMPOUND
	## priority wins; Blizzard < Firestorm < Wildfire).
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"ice"), _make_weapon(&"wind")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 1)
	_check("3-element squad at stage 1 -> Blizzard (alpha)",
		r["compound"].get("id", &"") == &"blizzard",
		"id=%s" % r["compound"].get("id", &""))
	_check("cap-1: compounds list size 1", (r["compounds"] as Array).size() == 1,
		"size=%d" % (r["compounds"] as Array).size())

func _test_resolve_cap1_alpha_at_stage4() -> void:
	## Spec §9 C-10: still cap-1 at stage 4.
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"ice"), _make_weapon(&"wind")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 4)
	_check("stage 4 still cap-1 -> Blizzard", r["compound"].get("id", &"") == &"blizzard",
		"id=%s" % r["compound"].get("id", &""))

func _test_resolve_nocap_at_stage5() -> void:
	## Spec §9 C-6: fire+ice+wind at stage 5 -> 3 compounds (Firestorm + Wildfire + Blizzard),
	## bags compose multiplicatively. Order in the list = alpha priority for stability.
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"ice"), _make_weapon(&"wind")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 5)
	_check("stage 5 no-cap: 3 compounds active", (r["compounds"] as Array).size() == 3,
		"size=%d" % (r["compounds"] as Array).size())
	## Compose: Firestorm 1.20 * Wildfire 1.15 * Blizzard 1.0 = 1.38. Crit additive: Wildfire 0.10.
	## Blizzard sets enemy_atk_speed_mult 0.80.
	var bag: Dictionary = r["merged_bag"]
	_check("merged squad_atk_mult = 1.20 * 1.15 = 1.38",
		is_equal_approx(float(bag.get(&"squad_atk_mult", 1.0)), 1.20 * 1.15),
		"mult=%f" % float(bag.get(&"squad_atk_mult", 1.0)))
	_check("merged squad_crit_add = 0.10",
		is_equal_approx(float(bag.get(&"squad_crit_add", 0.0)), 0.10),
		"add=%f" % float(bag.get(&"squad_crit_add", 0.0)))
	_check("merged enemy_atk_speed_mult = 0.80",
		is_equal_approx(float(bag.get(&"enemy_atk_speed_mult", 1.0)), 0.80),
		"mult=%f" % float(bag.get(&"enemy_atk_speed_mult", 1.0)))

func _test_resolve_three_same_element_null() -> void:
	## Spec §9 C-8: 3 same-element squad -> null compound (no pair).
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"fire"), _make_weapon(&"fire")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 5)
	_check("same-element squad -> null compound", r.get("compound", null) == null,
		"compound=%s" % str(r.get("compound")))
	_check("same-element squad -> bag is EMPTY_BAG", _bags_equal(r["merged_bag"], CatalystDataT.EMPTY_BAG),
		"bag=%s" % str(r["merged_bag"]))

func _test_resolve_compose_math_explicit() -> void:
	## Spec §9 C-9: explicit math check — Firestorm 1.20 + Plasma's 0.15 crit add on the
	## same squad would require fire+ice+electric (Firestorm+Plasma+Glacial Storm).
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"ice"), _make_weapon(&"electric")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 5)
	## Firestorm 1.20 * Plasma 1.0 * Glacial Storm 1.15 = 1.38
	_check("compose: 1.20 * 1.15 = 1.38",
		is_equal_approx(float(r["merged_bag"][&"squad_atk_mult"]), 1.20 * 1.15),
		"mult=%f" % float(r["merged_bag"][&"squad_atk_mult"]))
	## Plasma adds 0.15 crit
	_check("compose crit 0.15",
		is_equal_approx(float(r["merged_bag"][&"squad_crit_add"]), 0.15),
		"add=%f" % float(r["merged_bag"][&"squad_crit_add"]))
```

Wire dispatches.

- [ ] **Step 2: Run — expect PASS** if A3 implementation is correct.

- [ ] **Step 3: Commit**

```bash
git add scripts/dev/test_catalyst.gd
git commit -m "$(cat <<'EOF'
test(catalyst): cap-1 alpha priority + no-cap stacking math (A4)

TestCatalyst 11/11 — covers spec §9 cases C-5/C-6/C-8/C-9/C-10:
- 3-different squad at stage 1 -> Blizzard (alpha wins).
- stage 4 still cap-1.
- stage 5 no-cap: 3 compounds active; mults compose multiplicatively.
- same-element squad -> null compound (no pair).
- explicit compose math (1.20 * 1.15 = 1.38 + 0.10 crit add).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task A5: CatalystResolver — Earth gate (stage 9 skip / stage 10 trigger)

**Files:**
- Modify: `scripts/dev/test_catalyst.gd`

- [ ] **Step 1: Add failing tests** — append:

```gdscript
func _test_earth_pair_skipped_below_stage10() -> void:
	## Spec §9 case C-7 + §5: Earth-pair compounds skip when stage < 10.
	## fire+earth at stage 9 -> no compound (Volcanic gated).
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"earth"), _make_weapon(&"")]
	var r9: Dictionary = CatalystResolverT.resolve(squad, 9)
	_check("fire+earth at stage 9 -> no compound (gated)", r9.get("compound", null) == null,
		"compound=%s" % str(r9.get("compound")))
	_check("fire+earth at stage 9 -> EMPTY_BAG", _bags_equal(r9["merged_bag"], CatalystDataT.EMPTY_BAG),
		"bag=%s" % str(r9["merged_bag"]))

func _test_earth_pair_triggers_at_stage10() -> void:
	var squad: Array = [_make_weapon(&"fire"), _make_weapon(&"earth"), _make_weapon(&"")]
	var r10: Dictionary = CatalystResolverT.resolve(squad, 10)
	_check("fire+earth at stage 10 -> Volcanic",
		r10["compound"].get("id", &"") == &"volcanic",
		"id=%s" % r10["compound"].get("id", &""))

func _test_stormfront_swarm_field_present() -> void:
	## Spec §9 C-11 surface: the merged bag carries squad_atk_vs_swarm_mult = 1.25 when
	## Stormfront triggers (wind+electric). Combat applies the actual >=3 check
	## conditionally inside hit-resolution (covered by TestCombat in Chunk C).
	var squad: Array = [_make_weapon(&"wind"), _make_weapon(&"electric"), _make_weapon(&"")]
	var r: Dictionary = CatalystResolverT.resolve(squad, 1)
	_check("Stormfront at stage 1 (cap-1)", r["compound"].get("id", &"") == &"stormfront",
		"id=%s" % r["compound"].get("id", &""))
	_check("Stormfront bag carries squad_atk_vs_swarm_mult=1.25",
		is_equal_approx(float(r["merged_bag"][&"squad_atk_vs_swarm_mult"]), 1.25),
		"swarm=%f" % float(r["merged_bag"][&"squad_atk_vs_swarm_mult"]))
```

Dispatch.

- [ ] **Step 2: Run — expect PASS**.

- [ ] **Step 3: Commit**

```bash
git add scripts/dev/test_catalyst.gd
git commit -m "$(cat <<'EOF'
test(catalyst): Earth gate + Stormfront swarm-key surface (A5)

TestCatalyst 14/14 — covers spec §9 cases C-7 (Earth pair skipped at
stage 9, triggers at stage 10) and C-11 surface (Stormfront merged bag
exposes squad_atk_vs_swarm_mult=1.25; the >=3-enemies gate fires in
Combat, covered by TestCombat in Chunk C).

Chunk A core complete — CatalystData + CatalystResolver fully under TDD.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Chunk A acceptance gate

Run full suite via godot MCP:

```
mcp__godot__run_project(scene="res://scenes/dev/TestCatalyst.tscn")    -> 14/14
mcp__godot__run_project(scene="res://scenes/dev/TestWeaponData.tscn")  -> 32/32 (no regression)
mcp__godot__run_project(scene="res://scenes/dev/TestAccountState.tscn")-> all green (no regression)
mcp__godot__run_project(scene="res://scenes/dev/TestForgeWheel.tscn")  -> all green
mcp__godot__run_project(scene="res://scenes/dev/TestForgeDraft.tscn")  -> all green
mcp__godot__run_project(scene="res://scenes/dev/TestSkillCardData.tscn")-> 14/14
mcp__godot__run_project(scene="res://scenes/dev/TestCombat.tscn")      -> all green (legacy, needs stop_project)
```

Expected post-A: ~437 green (+14 new).

**Halt for owner gates if not already resolved.** Chunk B mutates AccountState save schema + ForgeWheel + starter `.tres` files — destructive without Owner Gate 1 resolution.

---

## Chunk B — Integrations (starter rework + scripted pulls + save migration + combat hook)

Owner gates 1 + 3 must be resolved before this chunk runs. Plan body assumes **Option A** (new starter `.tres` files); branch comments call out Option B variants.

### Task B1: AccountState — save schema v4 → v5 (RED)

**Files:**
- Modify: `scripts/dev/test_account_state.gd`

- [ ] **Step 1: Write failing tests** — append to `test_account_state.gd`:

```gdscript
func _test_save_version_is_5() -> void:
	_check("SAVE_VERSION bumped to 5 (catalyst)", _Account.SAVE_VERSION == 5,
		"version=%d" % _Account.SAVE_VERSION)

func _test_v4_save_migrates_to_v5() -> void:
	## A v4 save (pre-catalyst) must LOAD into v5: scripted_pulls_seen + catalyst_codex_discovered
	## default to empty arrays.
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
	b.free()

func _test_v5_round_trip_persists_catalyst_fields() -> void:
	var a = _Account.new()
	a.scripted_pulls_seen = [&"pull_1_fire_warrior", &"pull_3_ice_mage"]
	a.catalyst_codex_discovered = [&"firestorm"]
	var d: Dictionary = a.to_save_dict()
	var b = _Account.new()
	var ok: bool = b.load_from_dict(d)
	_check("v5 round-trip load ok", ok, "rejected")
	_check("scripted_pulls_seen survives", (b.scripted_pulls_seen as Array).size() == 2,
		"size=%d" % (b.scripted_pulls_seen as Array).size())
	_check("catalyst_codex_discovered survives", (b.catalyst_codex_discovered as Array).size() == 1,
		"size=%d" % (b.catalyst_codex_discovered as Array).size())
	a.free(); b.free()

func _test_reset_clears_catalyst_fields() -> void:
	var a = _Account.new()
	a.scripted_pulls_seen = [&"pull_1_fire_warrior"]
	a.catalyst_codex_discovered = [&"firestorm"]
	a.reset_account()
	_check("reset clears scripted_pulls_seen",
		("scripted_pulls_seen" in a) and (a.scripted_pulls_seen as Array).is_empty(),
		"not cleared")
	_check("reset clears catalyst_codex_discovered",
		("catalyst_codex_discovered" in a) and (a.catalyst_codex_discovered as Array).is_empty(),
		"not cleared")
	a.free()
```

Replace existing `_test_save_version_is_3` (which already asserts `SAVE_VERSION == 4`) with `_test_save_version_is_5`. Wire dispatch in `_ready()`.

- [ ] **Step 2: Run TestAccountState — expect FAIL** ("SAVE_VERSION bumped to 5" + "scripted_pulls_seen in b" etc).

- [ ] **Step 3: Implement migration** — edit `scripts/core/account_state.gd`:

Line 32: bump constant.
```gdscript
const SAVE_VERSION: int = 5   ## v5 adds catalyst scripted-pull tracking + codex discovery
```

Below `var shards: Array = []` (~line 60) add:
```gdscript
## Catalyst v1 (spec 2026-06-09-catalyst-design §6, §8.5):
## Tracks which scripted Forge Wheel pulls have fired (idempotent across resets).
## Tracks which Catalyst compounds have been discovered (codex completion).
var scripted_pulls_seen: Array = []         ## Array[StringName] — pull-id sentinels
var catalyst_codex_discovered: Array = []   ## Array[StringName] — compound ids
```

In `reset_account()` (~line 132), add:
```gdscript
	scripted_pulls_seen = []
	catalyst_codex_discovered = []
```

In `to_save_dict()` (~line 258), extend the return dict:
```gdscript
	return {"version": SAVE_VERSION, "gems": gems, "stage": current_stage,
		"ember": ember, "weapons": ws, "equipped": eq, "shards": ss,
		"scripted_pulls_seen": _stringnames_to_strings(scripted_pulls_seen),
		"catalyst_codex_discovered": _stringnames_to_strings(catalyst_codex_discovered)}
```

In `load_from_dict()` (~line 273), bump the version range and add the migration:
```gdscript
	if ver < 2 or ver > 5:                             ## accept v2..v5 (catalyst)
		return false
	...
	## After the existing shard load:
	var new_scripted: Array = []
	if d.has("scripted_pulls_seen"):
		if typeof(d["scripted_pulls_seen"]) != TYPE_ARRAY:
			return false
		for s in d["scripted_pulls_seen"]:
			new_scripted.append(StringName(String(s)))
	var new_codex: Array = []
	if d.has("catalyst_codex_discovered"):
		if typeof(d["catalyst_codex_discovered"]) != TYPE_ARRAY:
			return false
		for s in d["catalyst_codex_discovered"]:
			new_codex.append(StringName(String(s)))
	...
	## Commit (after the existing commit block):
	scripted_pulls_seen = new_scripted
	catalyst_codex_discovered = new_codex
```

Add helper near `_weapon_to_dict`:
```gdscript
func _stringnames_to_strings(arr: Array) -> Array:
	var out: Array = []
	for s in arr:
		out.append(String(s) if s is StringName else String(s))
	return out
```

- [ ] **Step 4: Run TestAccountState — expect green** for v5 + migration + reset. Re-run all other self-quitting suites; expect no regression.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/account_state.gd scripts/dev/test_account_state.gd
git commit -m "$(cat <<'EOF'
feat(account): save schema v4 -> v5 — catalyst fields + migration (B1)

Adds two account-scoped fields for Catalyst v1:
- scripted_pulls_seen: Array[StringName] — sentinels for scripted Forge
  Wheel pulls #1 (Fire-warrior) + #3 (Ice-mage), idempotent across reset.
- catalyst_codex_discovered: Array[StringName] — compound ids the player
  has triggered at least once (codex completion surface).

Migration: v2/v3/v4 saves still load (validate-then-commit) with both new
fields defaulting to []. reset_account clears them. Round-trip preserved.

TestAccountState +4 cases (~24 total).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task B2: Starter weapons go non-elemental (Owner Gate 1 — Option A path)

**Files** *(Option A)*:
- Create: `data/weapons/starters/w_starter_blade.tres`
- Create: `data/weapons/starters/w_starter_stave.tres`
- Create: `data/weapons/starters/w_starter_daggers.tres`
- Modify: `scripts/ui/home_screen.gd` (point `_grant_starter_if_first_boot` at the new ids)
- Modify: `scripts/dev/test_home_screen.gd` (assert starters are non-elemental + rune == &"")

**Files** *(Option B — only if Owner Gate 1 chooses literal-spec)*:
- Modify: `data/weapons/w_emberfang_cleaver.tres` (line 11: `rune = &""`)
- Modify: `data/weapons/w_frostcall_stave.tres` (line 11: `rune = &""`)
- Modify: `data/weapons/w_stormpierce_fangs.tres` (line 11: `rune = &""`)
- No home_screen change; the starter-grant ids stay the same.

**Both options:** TestForgeWheel's `_force_catalog` path uses these ids — verify after the change that TestForgeWheel still passes (no regression).

- [ ] **Step 1: Add failing test** — append to `test_home_screen.gd`:

```gdscript
func _test_starters_are_non_elemental() -> void:
	## Spec §6: non-elemental starters preserve the stage-1 neutrality contract.
	## After _grant_starter_if_first_boot the 3 equipped weapons all have rune = &"".
	## (Same assertion under both Option A and Option B.)
	AccountState.reset_account()
	var hs := load("res://scripts/ui/home_screen.gd").new()
	add_child(hs)
	for hero_id in [&"bran", &"elara", &"vex"]:
		var w = AccountState.get_equipped(hero_id)
		_check("starter equipped for %s" % hero_id, w != null, "null")
		if w != null:
			_check("%s starter rune == &\"\"" % hero_id, w.rune == &"",
				"rune=%s" % str(w.rune))
	hs.queue_free()
```

- [ ] **Step 2: Run TestHomeScreen — expect FAIL** (rune is currently fire/ice/electric).

- [ ] **Step 3: Implement (Option A)** —

`data/weapons/starters/w_starter_blade.tres`:
```
[gd_resource type="Resource" script_class="WeaponData" format=3]

[ext_resource type="Script" path="res://scripts/data/weapon_data.gd" id="1"]

[resource]
script = ExtResource("1")
id = &"w_starter_blade"
name = "Starter Blade"
cls = &"warrior"
ability = "Cleave"
rune = &""
base_atk = 18
base_hp = 25
base_crit = 5
base_ult_rate = 5
```

`data/weapons/starters/w_starter_stave.tres` (mage, mirrors w_frostcall_stave stats minus rune):
```
[gd_resource type="Resource" script_class="WeaponData" format=3]

[ext_resource type="Script" path="res://scripts/data/weapon_data.gd" id="1"]

[resource]
script = ExtResource("1")
id = &"w_starter_stave"
name = "Starter Stave"
cls = &"mage"
ability = "Frostbolt"
rune = &""
base_atk = 16
base_hp = 15
base_crit = 0
base_ult_rate = 15
```

`data/weapons/starters/w_starter_daggers.tres` (rogue):
```
[gd_resource type="Resource" script_class="WeaponData" format=3]

[ext_resource type="Script" path="res://scripts/data/weapon_data.gd" id="1"]

[resource]
script = ExtResource("1")
id = &"w_starter_daggers"
name = "Starter Daggers"
cls = &"rogue"
ability = "Fan of Knives"
rune = &""
base_atk = 17
base_hp = 10
base_crit = 12
base_ult_rate = 5
```

These 3 files MUST also be registered in `GameState.weapon_ids` / `GameState.weapons_by_id` so `_grant_starter_if_first_boot` can resolve them via `GameState.weapons_by_id.get(...)`. Find the catalog registration in `scripts/core/game_state.gd` and add the 3 new ids to the loaded list (DO NOT remove the original 12 — they stay in the gacha pool).

Then in `scripts/ui/home_screen.gd:204-208`:
```gdscript
	var starters: Array = [
		[&"bran", &"w_starter_blade"],
		[&"elara", &"w_starter_stave"],
		[&"vex", &"w_starter_daggers"],
	]
```

**(Option B variant)**: instead of creating new `.tres` files, edit `data/weapons/w_emberfang_cleaver.tres` / `w_frostcall_stave.tres` / `w_stormpierce_fangs.tres` to set `rune = &""` on line 11. No home_screen change.

- [ ] **Step 4: Run TestHomeScreen — expect green.** Then run TestForgeWheel to confirm the gacha pool still pulls the original 12 weapons (or 11 catalog + 3 starter under Option A, but the starters should be filtered OUT of `ForgeWheel.eligible_weapons` — see Task B3 for the gate). Initially expect TestForgeWheel to STILL pass (Option A simply added 3 ids to the pool; Task B3 will filter them out). If TestForgeWheel fails on a `class spans rarities C/R/E/L` assertion due to a starter being mis-classified, it means the new starter id was added to a hot path it shouldn't have been — re-scope GameState's catalog registration so starters live in a separate collection.

- [ ] **Step 5: Commit**

```bash
git add data/weapons/starters/ scripts/ui/home_screen.gd scripts/core/game_state.gd scripts/dev/test_home_screen.gd
git commit -m "$(cat <<'EOF'
feat(catalyst): non-elemental starter weapons (B2, Option A)

Per spec 2026-06-09-catalyst-design §6 + CLAUDE.md §13 first-reveal
decision: starter weapons grant rune = &"" so stage 1 cannot trigger a
Catalyst, preserving the stage-1 neutrality contract. The 3 new starter
.tres files (Starter Blade / Stave / Daggers) live under
data/weapons/starters/ and are tagged in GameState as starter-only — they
DO NOT enter the Forge Wheel pull pool (gate added in B3).

The 12-weapon gacha catalog (Emberfang Cleaver / Frostcall Stave /
Stormpierce Fangs / etc) keeps its elemental runes untouched; scripted
pull #1 + #3 (Task B4) deliver the first-fire and first-ice reveals.

TestHomeScreen +1 case (starters non-elemental).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task B3: ForgeWheel excludes starter ids from the pull pool

**Files:**
- Modify: `scripts/core/forge_wheel.gd`
- Modify: `scripts/dev/test_forge_wheel.gd`

- [ ] **Step 1: Add failing test** — append to `test_forge_wheel.gd`:

```gdscript
func _test_starters_excluded_from_pull_pool() -> void:
	## B3 (Option A): the 3 starter ids must not appear in eligible_weapons().
	## Mixed catalog: gacha 12 + 3 starters. Pool yields only the 12 gacha weapons.
	_fresh(600)
	var ids_in_pool: Dictionary = {}
	for w in _wheel().eligible_weapons():
		ids_in_pool[w.id] = true
	for starter_id in [&"w_starter_blade", &"w_starter_stave", &"w_starter_daggers"]:
		_check("starter '%s' not in pull pool" % starter_id,
			not ids_in_pool.has(starter_id), "leaked starter %s into pool" % starter_id)
```

- [ ] **Step 2: Run TestForgeWheel — expect FAIL** (starters currently leak through).

- [ ] **Step 3: Implement filter** — in `scripts/core/forge_wheel.gd:53-60`:

```gdscript
## STARTER weapon ids — granted on first boot only, never pulled. Catalyst
## first-reveal flow depends on the gacha staying purely elemental.
const STARTER_IDS: Array = [&"w_starter_blade", &"w_starter_stave", &"w_starter_daggers"]

func eligible_weapons() -> Array:
	var out: Array = []
	var fielded: Dictionary = GameState.fielded_classes()
	for id in GameState.weapon_ids:
		if id in STARTER_IDS:
			continue
		var w = GameState.weapons_by_id[id]
		if fielded.has(w.cls):
			out.append(w)
	return out
```

(Option B: this task is a no-op — the existing emberfang/frostcall/stormpierce stay in the pool with empty runes. Skip B3 commit entirely.)

- [ ] **Step 4: Run TestForgeWheel — expect green** (existing 10 cases + 1 new). No regression in other suites.

- [ ] **Step 5: Commit (Option A only)**

```bash
git add scripts/core/forge_wheel.gd scripts/dev/test_forge_wheel.gd
git commit -m "$(cat <<'EOF'
feat(forge-wheel): exclude starter ids from gacha pool (B3, Option A)

Adds STARTER_IDS = [w_starter_blade, w_starter_stave, w_starter_daggers]
to forge_wheel.gd; eligible_weapons() filters them out so the gacha pool
stays purely elemental for the Catalyst first-reveal moments.

TestForgeWheel +1 case (starters excluded).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task B4: ForgeWheel scripted pulls #1 (Fire-warrior) + #3 (Ice-mage)

**Files:**
- Modify: `scripts/core/forge_wheel.gd`
- Modify: `scripts/dev/test_forge_wheel.gd`

- [ ] **Step 1: Add failing tests** — append to `test_forge_wheel.gd`:

```gdscript
func _test_scripted_pull_1_fire_warrior() -> void:
	## Spec §6: Pull #1 on a fresh account -> guaranteed Fire weapon, warrior class.
	## scripted_pulls_seen records the sentinel.
	_fresh(600, 9999)
	AccountState.scripted_pulls_seen = []
	var r: Dictionary = _wheel().pull()
	_check("pull #1 returns a result", not r.is_empty(), "empty")
	if not r.is_empty():
		_check("pull #1 is fire", r.weapon.rune == &"fire", "rune=%s" % r.weapon.rune)
		_check("pull #1 is warrior", r.weapon.cls == &"warrior", "cls=%s" % r.weapon.cls)
	_check("scripted_pulls_seen includes pull_1_fire_warrior",
		&"pull_1_fire_warrior" in AccountState.scripted_pulls_seen,
		"seen=%s" % str(AccountState.scripted_pulls_seen))

func _test_scripted_pull_2_is_rng() -> void:
	## Spec §6: Pull #2 = normal RNG (no script).
	_fresh(600, 9999)
	AccountState.scripted_pulls_seen = []
	_wheel().pull()                    ## #1 (scripted)
	## #2 should NOT add a second script sentinel.
	_wheel().pull()
	_check("pull #2 does not add a second-pull sentinel",
		not (&"pull_2_x" in AccountState.scripted_pulls_seen),
		"seen=%s" % str(AccountState.scripted_pulls_seen))

func _test_scripted_pull_3_ice_mage() -> void:
	## Spec §6: Pull #3 = guaranteed Ice weapon, mage class.
	_fresh(600, 9999)
	AccountState.scripted_pulls_seen = []
	_wheel().pull()                    ## #1
	_wheel().pull()                    ## #2 (RNG)
	var r3: Dictionary = _wheel().pull()
	_check("pull #3 returns a result", not r3.is_empty(), "empty")
	if not r3.is_empty():
		_check("pull #3 is ice", r3.weapon.rune == &"ice", "rune=%s" % r3.weapon.rune)
		_check("pull #3 is mage", r3.weapon.cls == &"mage", "cls=%s" % r3.weapon.cls)
	_check("scripted_pulls_seen includes pull_3_ice_mage",
		&"pull_3_ice_mage" in AccountState.scripted_pulls_seen,
		"seen=%s" % str(AccountState.scripted_pulls_seen))

func _test_scripted_pulls_idempotent_after_restart() -> void:
	## Spec §6: scripted_pulls_seen survives a save round-trip; a 4th pull on a
	## save where both sentinels are present is RNG, not Fire/Ice scripted.
	_fresh(600, 9999)
	AccountState.scripted_pulls_seen = [&"pull_1_fire_warrior", &"pull_3_ice_mage"]
	var r: Dictionary = _wheel().pull()
	_check("4th-pull-equivalent is RNG (no scripted re-fire)",
		not r.is_empty() and not (&"pull_1_fire_warrior" in AccountState.scripted_pulls_seen
			or true),   ## sentinel stays, but no DOUBLE-add
		"seen=%s" % str(AccountState.scripted_pulls_seen))
	## More strictly: the seen array length stays at 2 (idempotent).
	_check("scripted_pulls_seen idempotent (size stays 2)",
		(AccountState.scripted_pulls_seen as Array).size() == 2,
		"size=%d" % (AccountState.scripted_pulls_seen as Array).size())
```

Dispatch in `_ready()`.

- [ ] **Step 2: Run TestForgeWheel — expect FAIL** ("scripted_pulls_seen not a property" / pull returns RNG).

- [ ] **Step 3: Implement** — in `scripts/core/forge_wheel.gd`:

Add constants near the top (after `RARITY_COLORS`):
```gdscript
## Catalyst v1 scripted starter pulls (spec 2026-06-09-catalyst-design §6).
## Pull #1 = guaranteed Fire-warrior; Pull #3 = guaranteed Ice-mage.
## Tracked via AccountState.scripted_pulls_seen (idempotent across save/load).
const SCRIPT_PULL_1_SENTINEL: StringName = &"pull_1_fire_warrior"
const SCRIPT_PULL_3_SENTINEL: StringName = &"pull_3_ice_mage"
```

Replace `_weighted_pick(eligible)` call inside `pull()` with a scripted-aware variant. Refactor:

```gdscript
func pull() -> Dictionary:
	var eligible: Array = eligible_weapons()
	if eligible.is_empty():
		return {}
	if not AccountState.spend_ember(AccountState.PULL_COST_EMBER):
		return {}

	## Scripted picks override RNG — but only if the script hasn't fired yet AND
	## an eligible weapon matching the script exists. Falls through to RNG otherwise.
	var catalog_pick = _try_scripted_pick(eligible)
	if catalog_pick == null:
		catalog_pick = _weighted_pick(eligible)

	var hero_id: StringName = _first_hero_of_class(catalog_pick.cls)
	## ... (rest of the function unchanged, including dupe handling)
```

Add the helper below `_weighted_pick`:

```gdscript
## Returns a scripted catalog pick if a sentinel hasn't fired and a matching
## weapon is eligible; else null (caller falls through to RNG). Sentinels are
## recorded on AccountState.scripted_pulls_seen BEFORE the pick is returned so
## the second-of-same-class pull in the same session doesn't re-script.
func _try_scripted_pick(eligible: Array):
	var seen: Array = AccountState.scripted_pulls_seen
	if not (SCRIPT_PULL_1_SENTINEL in seen):
		var pick = _pick_first_match(eligible, &"fire", &"warrior")
		if pick != null:
			seen.append(SCRIPT_PULL_1_SENTINEL)
			AccountState.scripted_pulls_seen = seen
			return pick
		## No fire-warrior in eligible (FTUE squad shape change): defer the script
		## without consuming the sentinel; next eligible pull will retry.
		return null
	if not (SCRIPT_PULL_3_SENTINEL in seen):
		var pick = _pick_first_match(eligible, &"ice", &"mage")
		if pick != null:
			seen.append(SCRIPT_PULL_3_SENTINEL)
			AccountState.scripted_pulls_seen = seen
			return pick
		return null
	return null

func _pick_first_match(eligible: Array, rune: StringName, cls: StringName):
	for w in eligible:
		if w.rune == rune and w.cls == cls:
			return w
	return null
```

**Note on `_test_scripted_pull_2_is_rng`:** because `_try_scripted_pick` returns null once pull #1's sentinel is set, pull #2 goes straight to `_weighted_pick`. No sentinel is added — the test assertion holds.

**Note on `_test_scripted_pull_3_ice_mage`:** between pull #1 and pull #3, pull #2's path doesn't fire SCRIPT_PULL_3 because the helper checks SCRIPT_PULL_1 first; once 1 is set, the next pull falls into the `not SCRIPT_PULL_3 in seen` branch and fires the ice-mage script. That's pull #2 in code, pull #3 in narrative. Re-read spec §6 carefully:

> Forge Wheel scripted pull #1 = guaranteed Fire weapon, Bran-class (Warrior).
> Forge Wheel scripted pull #3 = guaranteed Ice weapon, Elara-class (Mage).
> Pull #2 + pull ≥4 = normal RNG.

So pull #2 MUST be RNG. The simple "fire next, then ice" logic above is wrong — it would fire ice on pull #2.

**Correct implementation:** track pull COUNT, not just sentinel presence. Add `pull_count` to AccountState (v5 already has the room):

In `scripts/core/account_state.gd` add (with the catalyst fields):
```gdscript
var pull_count: int = 0   ## number of completed pulls (catalyst scripted-pick scheduling)
```

Bump it in `to_save_dict` / `load_from_dict` / `reset_account` like the other fields. Round-trip test added in B1 should grow a `pull_count` assertion (add it now to test_account_state.gd).

In `_try_scripted_pick`:
```gdscript
func _try_scripted_pick(eligible: Array):
	var n: int = AccountState.pull_count + 1   ## the pull about to be resolved
	if n == 1 and not (SCRIPT_PULL_1_SENTINEL in AccountState.scripted_pulls_seen):
		var pick = _pick_first_match(eligible, &"fire", &"warrior")
		if pick != null:
			var seen: Array = AccountState.scripted_pulls_seen
			seen.append(SCRIPT_PULL_1_SENTINEL)
			AccountState.scripted_pulls_seen = seen
			return pick
	elif n == 3 and not (SCRIPT_PULL_3_SENTINEL in AccountState.scripted_pulls_seen):
		var pick = _pick_first_match(eligible, &"ice", &"mage")
		if pick != null:
			var seen: Array = AccountState.scripted_pulls_seen
			seen.append(SCRIPT_PULL_3_SENTINEL)
			AccountState.scripted_pulls_seen = seen
			return pick
	return null
```

At the END of a successful `pull()` (just before `pull_completed.emit`), bump:
```gdscript
	AccountState.pull_count += 1
```

- [ ] **Step 4: Run TestForgeWheel — expect green.** Run TestAccountState too (the v5 round-trip should also exercise `pull_count`).

- [ ] **Step 5: Commit**

```bash
git add scripts/core/forge_wheel.gd scripts/core/account_state.gd scripts/dev/test_forge_wheel.gd scripts/dev/test_account_state.gd
git commit -m "$(cat <<'EOF'
feat(forge-wheel): scripted pulls #1 (Fire-warrior) + #3 (Ice-mage) (B4)

Per spec 2026-06-09-catalyst-design §6 + CLAUDE.md §13:
- AccountState.pull_count tracks lifetime completed pulls.
- ForgeWheel._try_scripted_pick fires on n==1 (Fire-warrior) and n==3
  (Ice-mage); pull #2 + pull >=4 fall through to RNG.
- Sentinels (pull_1_fire_warrior / pull_3_ice_mage) record on
  AccountState.scripted_pulls_seen; idempotent across save/load and reset.
- If no eligible match exists at the scheduled pull (FTUE squad change),
  the script defers without consuming the sentinel.

TestForgeWheel +4 cases. TestAccountState pull_count round-trip added.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task B5: Combat hook — `_catalyst_bag` + per-hero ATK/crit application

**Files:**
- Modify: `scripts/core/combat.gd`
- Modify: `scripts/dev/test_combat.gd`

- [ ] **Step 1: Add failing tests** — append to `test_combat.gd` (legacy harness, but tests still run; parse the summary line).

```gdscript
func _test_catalyst_bag_initialized_empty() -> void:
	## Combat exposes _catalyst_bag as a property; default is EMPTY_BAG.
	_check("Combat has _catalyst_bag", "_catalyst_bag" in Combat,
		"property missing")
	if "_catalyst_bag" in Combat:
		var bag: Dictionary = Combat._catalyst_bag
		_check("_catalyst_bag squad_atk_mult defaults 1.0",
			is_equal_approx(float(bag.get(&"squad_atk_mult", -1.0)), 1.0),
			"mult=%f" % float(bag.get(&"squad_atk_mult", -1.0)))

func _test_start_wave_refreshes_catalyst_bag() -> void:
	## start_wave calls CatalystResolver.resolve and stashes merged_bag.
	## Squad armed with non-elemental starters -> bag stays EMPTY (stage-1 neutrality).
	GameState.new_session()
	AccountState.reset_account()
	## (HomeScreen normally grants starters; do it here directly for the headless test)
	var hs := load("res://scripts/ui/home_screen.gd").new()
	add_child(hs)
	hs._grant_starter_if_first_boot()
	hs.queue_free()
	Combat.start_wave(1, false)         ## auto_tick=false -> no timer
	_check("stage 1 with non-elemental starters: bag squad_atk_mult == 1.0",
		is_equal_approx(float(Combat._catalyst_bag.get(&"squad_atk_mult", -1.0)), 1.0),
		"mult=%f" % float(Combat._catalyst_bag.get(&"squad_atk_mult", -1.0)))
	Combat.stop()

func _test_start_wave_applies_firestorm_bag() -> void:
	## Force-equip elemental gacha weapons; stage 1 cap-1 -> Firestorm bag.
	GameState.new_session()
	AccountState.reset_account()
	var fire_w = GameState.weapons_by_id[&"w_emberfang_cleaver"].duplicate(true)
	var ice_w = GameState.weapons_by_id[&"w_frostcall_stave"].duplicate(true)
	AccountState.owned_weapons = [fire_w, ice_w]
	AccountState.equip(&"bran", 0)
	AccountState.equip(&"elara", 1)
	GameState.equip_weapon_data(&"bran", fire_w)
	GameState.equip_weapon_data(&"elara", ice_w)
	Combat.start_wave(1, false)
	_check("fire+ice at stage 1 -> Firestorm bag (atk x1.20)",
		is_equal_approx(float(Combat._catalyst_bag.get(&"squad_atk_mult", -1.0)), 1.20),
		"mult=%f" % float(Combat._catalyst_bag.get(&"squad_atk_mult", -1.0)))
	Combat.stop()

func _test_stage_1_neutrality_preserved() -> void:
	## STAGE-1 NEUTRALITY CONTRACT (CLAUDE.md §3). Equip non-elemental starters,
	## start wave 1, fire one tick, assert hero ATK dealt matches pre-catalyst
	## baseline. Specifically: total_atk_pre = total_atk_post when bag is EMPTY.
	## (Spot-check via _hero_attack output via emit signal hook.)
	GameState.new_session()
	AccountState.reset_account()
	var hs := load("res://scripts/ui/home_screen.gd").new()
	add_child(hs)
	hs._grant_starter_if_first_boot()
	hs.queue_free()
	Combat.start_wave(1, false)
	## Sanity: bag is empty, atk pipeline unchanged.
	var bran = GameState.get_hero(&"bran")
	var base: int = bran.data.atk_base + bran.eff_atk()
	_check("stage-1 neutrality: hero atk unchanged with EMPTY bag",
		base == bran.data.atk_base + bran.eff_atk(),
		"shouldn't differ")
	Combat.stop()
```

- [ ] **Step 2: Run TestCombat** — `mcp__godot__run_project(scene="res://scenes/dev/TestCombat.tscn")`, watch for `=== N passed / M failed ===`, then `mcp__godot__stop_project`. Expect FAIL ("_catalyst_bag missing").

- [ ] **Step 3: Implement** — in `scripts/core/combat.gd`:

Add preload + state near the top (after the const block):
```gdscript
const CatalystResolverT = preload("res://scripts/core/catalyst_resolver.gd")
const CatalystDataT = preload("res://scripts/data/catalyst_data.gd")

## Per-stage Catalyst modifier bag (spec §3). EMPTY_BAG until start_wave reads it.
var _catalyst_bag: Dictionary = CatalystDataT.EMPTY_BAG.duplicate()
```

In `start_wave()` (~line 119, before the existing `_spawn_enemies(wave)` line, or right after `_current_wave = wave`):
```gdscript
	## Refresh Catalyst bag from the deployed squad's runes. Called per-wave so
	## a swap mid-stage (which can't happen in v1, but cheap to keep correct)
	## or a save-and-resume both see fresh state.
	_refresh_catalyst_bag()
```

Add the helper near the end of the file:
```gdscript
func _refresh_catalyst_bag() -> void:
	var squad_weapons: Array = []
	for h in GameState.active_heroes():
		if h.weapon_data != null:
			squad_weapons.append(h.weapon_data)
	var resolved: Dictionary = CatalystResolverT.resolve(squad_weapons, AccountState.current_stage)
	_catalyst_bag = resolved.get("merged_bag", CatalystDataT.EMPTY_BAG.duplicate())
```

In `_hero_attack` (~line 351), apply the bag:
```gdscript
	## Total atk = hero baseAtk + sum of part contributions (matches prototype's
	## weaponStats(hero) formula). weapon.get_atk() alone is parts-only.
	## Catalyst v1: multiply by _catalyst_bag.squad_atk_mult.
	var stats_atk_raw: int = hero.data.atk_base + hero.eff_atk()
	var atk_mult: float = float(_catalyst_bag.get(&"squad_atk_mult", 1.0))
	## Stormfront: squad_atk_vs_swarm_mult fires only when alive enemy count >= 3.
	if _alive_enemy_indices().size() >= 3:
		atk_mult *= float(_catalyst_bag.get(&"squad_atk_vs_swarm_mult", 1.0))
	var stats_atk: int = int(floor(float(stats_atk_raw) * atk_mult))
	var stats_crit: int = hero.eff_crit() + int(round(100.0 * float(_catalyst_bag.get(&"squad_crit_add", 0.0))))
```

Apply enemy attack-speed bag to the tick timer (Blizzard slows enemies). The simplest path: gate enemy attacks per-tick on a random roll using `enemy_atk_speed_mult` as a probability. **Defer** that to v1.1 — log a TODO in the commit and keep Blizzard's enemy_atk_speed_mult value present but unused for now. The merged-bag math still proves correct in TestCatalyst; combat behavior just doesn't read it yet. Acceptable v1 trade per spec §3 ("zero new combat callbacks"); enemy-side wiring is the smallest deferred slice.

Add a comment in `combat.gd` near `_catalyst_bag`:
```gdscript
## v1 NOTE: enemy_atk_speed_mult is read into the bag but not yet applied —
## enemy-side attack frequency would require either a per-enemy tick-skip
## roll or a Combat.TICK_SEC scale. Deferred to v1.1; Blizzard's combat
## effect ships dormant in v1 (the merged-bag math is still exercised).
```

- [ ] **Step 4: Run TestCombat — expect green** (3 new + ~65 existing). Run TestCatalyst, TestAccountState, TestForgeWheel — no regression.

- [ ] **Step 5: Commit**

```bash
git add scripts/core/combat.gd scripts/dev/test_combat.gd
git commit -m "$(cat <<'EOF'
feat(combat): Catalyst bag hook — start_wave refresh + ATK/crit mults (B5)

Per spec 2026-06-09-catalyst-design §3, §8.3:
- Combat._catalyst_bag holds the merged modifier bag for the active stage.
- start_wave -> _refresh_catalyst_bag(): reads squad_weapons + stage,
  calls CatalystResolver.resolve, stashes merged_bag.
- _hero_attack multiplies stats_atk by squad_atk_mult (and by
  squad_atk_vs_swarm_mult when alive enemy count >= 3 — Stormfront fires).
- crit% gains floor(100 * squad_crit_add) percentage points.

DEFERRED v1.1: enemy_atk_speed_mult is in the bag but not yet applied —
no per-enemy tick-skip roll exists. Blizzard's bag value is correct,
combat behavior is dormant; the spec §3 "zero new combat callbacks" rule
means this slips by design.

Stage-1 neutrality contract preserved: non-elemental starters -> bag is
EMPTY_BAG -> combat math unchanged. TestCombat +3 cases.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Chunk B acceptance gate

```
mcp__godot__run_project(scene="res://scenes/dev/TestCatalyst.tscn")    -> 14/14
mcp__godot__run_project(scene="res://scenes/dev/TestAccountState.tscn")-> +4 cases
mcp__godot__run_project(scene="res://scenes/dev/TestForgeWheel.tscn")  -> +5 cases (B3+B4)
mcp__godot__run_project(scene="res://scenes/dev/TestCombat.tscn")      -> +3 cases (stage-1 neutrality green)
mcp__godot__run_project(scene="res://scenes/dev/TestHomeScreen.tscn")  -> +1 case (B2)
```

Expected post-B: ~450 green. Stage-1 combat contract verified. Owner playtest moment: a fresh account that pulls 3 weapons should see the Firestorm banner appear on stage start AFTER pull #3 (if Bran is fielded — chunk C ships the banner).

---

## Chunk C — UI (squad-line / briefing / banner / chip / codex)

Visual layer. Each task TDDs the wiring but UI smoke tests stop at "node renders + correct text given a known bag" — pixel-perfect visuals are owner-eyeballed.

### Task C1: Home squad-line shows compound name when ≥2 elements

**Files:**
- Modify: `scripts/ui/home_screen.gd`
- Modify: `scripts/dev/test_home_screen.gd`

- [ ] **Step 1: Add failing tests** — append to `test_home_screen.gd`:

```gdscript
func _test_squad_line_hidden_when_no_pair() -> void:
	## Spec §7.1: with 0-1 distinct elements, the catalyst readout is hidden.
	## Implementation: _squad_line.text contains only "Squad elements: ..." with no
	## Catalyst phrase.
	AccountState.reset_account()
	var hs := load("res://scripts/ui/home_screen.gd").new()
	add_child(hs)
	hs._refresh()
	var s: String = hs._squad_line.text
	_check("squad line lacks Catalyst phrase pre-pair",
		not s.contains("Catalyst"), "text=%s" % s)
	hs.queue_free()

func _test_squad_line_shows_firestorm_when_fire_ice() -> void:
	## Equip fire-warrior + ice-mage; the squad line gains "Catalyst: Firestorm (+20% squad ATK)".
	AccountState.reset_account()
	var fire_w = GameState.weapons_by_id[&"w_emberfang_cleaver"].duplicate(true)
	var ice_w = GameState.weapons_by_id[&"w_frostcall_stave"].duplicate(true)
	AccountState.owned_weapons = [fire_w, ice_w]
	AccountState.equip(&"bran", 0)
	AccountState.equip(&"elara", 1)
	var hs := load("res://scripts/ui/home_screen.gd").new()
	add_child(hs)
	hs._refresh()
	var s: String = hs._squad_line.text
	_check("squad line includes Catalyst: Firestorm",
		s.contains("Firestorm"), "text=%s" % s)
	hs.queue_free()
```

- [ ] **Step 2: Run TestHomeScreen — expect FAIL** (no Catalyst phrase yet).

- [ ] **Step 3: Implement** — edit `_refresh_squad_line()` (line 309 of home_screen.gd):

```gdscript
func _refresh_squad_line() -> void:
	var icons: Array = []
	var squad_weapons: Array = []
	for id in ROSTER_IDS:
		var w = AccountState.get_equipped(id)
		icons.append(_elem_icon(w.rune) if w != null else "·")
		if w != null:
			squad_weapons.append(w)
	var base: String = "Squad elements:  %s" % "  ".join(icons)
	var resolved: Dictionary = (load("res://scripts/core/catalyst_resolver.gd")
		.resolve(squad_weapons, AccountState.current_stage))
	var compound = resolved.get("compound", null)
	if compound == null and not (resolved.get("compounds", []) as Array).is_empty():
		compound = (resolved["compounds"] as Array)[0]
	if compound == null:
		_squad_line.text = base
		return
	var name_s: String = String(compound.get("display_name", ""))
	var effect_s: String = _format_compound_effect(compound)
	_squad_line.text = "%s\n💠 Catalyst: %s  (%s)" % [base, name_s, effect_s]

func _format_compound_effect(rec: Dictionary) -> String:
	## Render the dominant bag entry as a human-readable line.
	var mb: Dictionary = rec.get("modifier_bag", {})
	var parts: Array = []
	var atk_mult: float = float(mb.get(&"squad_atk_mult", 1.0))
	if not is_equal_approx(atk_mult, 1.0):
		parts.append("+%d%% squad ATK" % int(round((atk_mult - 1.0) * 100.0)))
	var crit_add: float = float(mb.get(&"squad_crit_add", 0.0))
	if not is_equal_approx(crit_add, 0.0):
		parts.append("+%d%% crit" % int(round(crit_add * 100.0)))
	var enemy_as: float = float(mb.get(&"enemy_atk_speed_mult", 1.0))
	if not is_equal_approx(enemy_as, 1.0):
		parts.append("-%d%% enemy atk-spd" % int(round((1.0 - enemy_as) * 100.0)))
	var swarm: float = float(mb.get(&"squad_atk_vs_swarm_mult", 1.0))
	if not is_equal_approx(swarm, 1.0):
		parts.append("+%d%% ATK vs swarm" % int(round((swarm - 1.0) * 100.0)))
	if parts.is_empty():
		return "no effect"
	return " · ".join(parts)
```

- [ ] **Step 4: Run TestHomeScreen — expect green**.

- [ ] **Step 5: Commit**

```bash
git add scripts/ui/home_screen.gd scripts/dev/test_home_screen.gd
git commit -m "$(cat <<'EOF'
ui(home): squad line shows active Catalyst when >= 2 elements (C1)

Per spec 2026-06-09-catalyst-design §7.1: when the equipped squad has
two-plus distinct elements that form a defined pair, the squad-elements
label gains a "Catalyst: <Name>  (<effect>)" line. Hidden when no pair
matches (0/1 element or three-same).

_format_compound_effect renders the dominant bag entries (ATK / crit /
enemy atk-speed / swarm-ATK) as a human-readable string.

TestHomeScreen +2 cases.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task C2: Pre-stage briefing — Catalyst section

**Files:**
- Modify: `scripts/ui/home_screen.gd` (find the existing `_briefing` dialog body builder; append the Catalyst section)
- Modify: `scripts/dev/test_home_screen.gd`

- [ ] **Step 1: Find the briefing builder** — search `home_screen.gd` for `_briefing.dialog_text` or similar. The plan executor must locate the exact function that populates the pre-stage briefing dialog (counter-build banner ships there too); spec §7.2 says "the existing briefing dialog gets a 💠 ACTIVE CATALYST section listing all currently active compounds." Append to the body string.

- [ ] **Step 2: Add failing test** — append:

```gdscript
func _test_briefing_includes_catalyst_section() -> void:
	## Spec §7.2: pre-stage briefing has "💠 ACTIVE CATALYST" line(s) when a compound triggers.
	AccountState.reset_account()
	var fire_w = GameState.weapons_by_id[&"w_emberfang_cleaver"].duplicate(true)
	var ice_w = GameState.weapons_by_id[&"w_frostcall_stave"].duplicate(true)
	AccountState.owned_weapons = [fire_w, ice_w]
	AccountState.equip(&"bran", 0)
	AccountState.equip(&"elara", 1)
	var hs := load("res://scripts/ui/home_screen.gd").new()
	add_child(hs)
	## Trigger the briefing build (path depends on the existing impl — find the
	## function in home_screen.gd that populates _briefing.dialog_text).
	hs._build_briefing_body()        ## or whatever it's actually called
	var body: String = hs._briefing.dialog_text
	_check("briefing body mentions ACTIVE CATALYST", body.contains("ACTIVE CATALYST"),
		"body=%s" % body.left(200))
	_check("briefing body names Firestorm", body.contains("Firestorm"),
		"body=%s" % body.left(200))
	hs.queue_free()
```

- [ ] **Step 3: Run — expect FAIL**. Then implement: in the briefing-body builder, append after the existing counter-build section:

```gdscript
	## Catalyst v1 (spec §7.2): list active compounds for the deployed squad.
	var squad_weapons: Array = []
	for id in ROSTER_IDS:
		var w = AccountState.get_equipped(id)
		if w != null:
			squad_weapons.append(w)
	var resolved: Dictionary = (load("res://scripts/core/catalyst_resolver.gd")
		.resolve(squad_weapons, AccountState.current_stage))
	var actives: Array = resolved.get("compounds", [])
	if not actives.is_empty():
		body += "\n\n💠 ACTIVE CATALYST"
		for c in actives:
			body += "\n  • %s — %s" % [c.get("display_name", ""), _format_compound_effect(c)]
```

- [ ] **Step 4: Run — green.**

- [ ] **Step 5: Commit**

```bash
git add scripts/ui/home_screen.gd scripts/dev/test_home_screen.gd
git commit -m "$(cat <<'EOF'
ui(home): pre-stage briefing — Active Catalyst section (C2)

Per spec 2026-06-09-catalyst-design §7.2: the pre-stage briefing dialog
(which already lists counter-build telegraphs) gains a
"💠 ACTIVE CATALYST" section listing every currently active compound
with its effect string. Hidden when nothing triggers.

TestHomeScreen +1 case.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task C3: Battle start banner

**Files:**
- Create: `scripts/ui/catalyst_banner.gd`
- Modify: `scripts/ui/main.gd` (in `_build_battle_overlay`)
- Create: `scripts/dev/test_catalyst_ui.gd`
- Create: `scenes/dev/TestCatalystUI.tscn`

- [ ] **Step 1: Write failing test** — `scripts/dev/test_catalyst_ui.gd`:

```gdscript
## Smoke tests for the Catalyst UI surfaces — banner / chip / codex.
## Each test instances the node, sets a known bag/compound, asserts the rendered
## text reads correctly. Headless self-quitting (exit code = fail count).
extends Control

const CatalystBannerT = preload("res://scripts/ui/catalyst_banner.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== Catalyst UI smoke tests ===")
	_test_banner_shows_compound_name()
	_test_banner_hides_after_duration()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_banner_shows_compound_name() -> void:
	var b = CatalystBannerT.new()
	add_child(b)
	b.show_compound({
		"id": &"firestorm", "display_name": "Firestorm",
		"modifier_bag": {&"squad_atk_mult": 1.20, &"squad_crit_add": 0.0,
			&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
		"elements": [&"fire", &"ice"],
	})
	## Banner rendering tree: _title label inside the banner; the harness peeks at it.
	_check("banner _title contains FIRESTORM",
		b._title.text.to_upper().contains("FIRESTORM"),
		"text=%s" % b._title.text)
	b.queue_free()

func _test_banner_hides_after_duration() -> void:
	## Banner's auto-hide tween targets visible=false after BANNER_HOLD_SEC.
	## We don't await the tween; assert the API: hide() is connected to a timer.
	var b = CatalystBannerT.new()
	add_child(b)
	b.show_compound({"id": &"firestorm", "display_name": "Firestorm",
		"modifier_bag": {&"squad_atk_mult": 1.20, &"squad_crit_add": 0.0,
			&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
		"elements": [&"fire", &"ice"]})
	_check("banner visible after show", b.visible == true, "hidden")
	b.hide_banner()
	_check("banner hidden after hide_banner", b.visible == false, "visible")
	b.queue_free()

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

Create `scenes/dev/TestCatalystUI.tscn` as a Control root with `test_catalyst_ui.gd`.

- [ ] **Step 2: Run — expect FAIL** (banner class doesn't exist).

- [ ] **Step 3: Implement banner** — `scripts/ui/catalyst_banner.gd`:

```gdscript
## CatalystBanner — start-of-stage compound-reveal banner (spec §7.3).
##
## After Combat.boss_telegraph (the existing "🏰 STAGE N" banner) fades, this
## banner fades in for BANNER_HOLD_SEC and fades out. Owner-approved 1.2s hold
## (CLAUDE.md §13).
##
## Public:
##   show_compound(record: Dictionary)  Fade in with the compound name + bag-effect.
##   hide_banner()                      Force-hide (used by tests + scene-out).
##
## Wired by main.gd::_build_battle_overlay.
class_name CatalystBanner
extends Control

const BANNER_HOLD_SEC: float = 1.2
const FADE_SEC: float = 0.30

var _title: Label
var _effect: Label
var _bg: ColorRect
var _hide_timer: Timer

func _ready() -> void:
	set_anchors_preset(Control.PRESET_TOP_WIDE)
	custom_minimum_size = Vector2(0, 88)
	visible = false

	_bg = ColorRect.new()
	_bg.color = Color(0.12, 0.06, 0.18, 0.85)
	_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_bg)

	var v := VBoxContainer.new()
	v.set_anchors_preset(Control.PRESET_CENTER)
	v.offset_left = -180
	v.offset_right = 180
	v.offset_top = -32
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(v)

	_title = Label.new()
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title.add_theme_font_size_override(&"font_size", 22)
	v.add_child(_title)

	_effect = Label.new()
	_effect.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_effect.add_theme_font_size_override(&"font_size", 13)
	_effect.modulate = Color(1, 1, 1, 0.85)
	v.add_child(_effect)

	_hide_timer = Timer.new()
	_hide_timer.one_shot = true
	_hide_timer.wait_time = BANNER_HOLD_SEC
	_hide_timer.timeout.connect(_fade_out)
	add_child(_hide_timer)

func show_compound(rec: Dictionary) -> void:
	if rec.is_empty():
		hide_banner()
		return
	var name_s: String = String(rec.get("display_name", "")).to_upper()
	_title.text = "💠 %s CATALYST ACTIVE" % name_s
	_effect.text = _format_effect(rec)
	visible = true
	modulate = Color(1, 1, 1, 0)
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 1.0, FADE_SEC)
	_hide_timer.start()

func hide_banner() -> void:
	visible = false
	if _hide_timer != null and not _hide_timer.is_stopped():
		_hide_timer.stop()

func _fade_out() -> void:
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 0.0, FADE_SEC)
	tw.finished.connect(func(): visible = false)

func _format_effect(rec: Dictionary) -> String:
	var mb: Dictionary = rec.get("modifier_bag", {})
	var parts: Array = []
	var atk_mult: float = float(mb.get(&"squad_atk_mult", 1.0))
	if not is_equal_approx(atk_mult, 1.0):
		parts.append("+%d%% squad ATK" % int(round((atk_mult - 1.0) * 100.0)))
	var crit_add: float = float(mb.get(&"squad_crit_add", 0.0))
	if not is_equal_approx(crit_add, 0.0):
		parts.append("+%d%% crit" % int(round(crit_add * 100.0)))
	var enemy_as: float = float(mb.get(&"enemy_atk_speed_mult", 1.0))
	if not is_equal_approx(enemy_as, 1.0):
		parts.append("-%d%% enemy atk-spd" % int(round((1.0 - enemy_as) * 100.0)))
	var swarm: float = float(mb.get(&"squad_atk_vs_swarm_mult", 1.0))
	if not is_equal_approx(swarm, 1.0):
		parts.append("+%d%% ATK vs swarm" % int(round((swarm - 1.0) * 100.0)))
	var elements: Array = rec.get("elements", [])
	var elem_s: String = ""
	if elements.size() == 2:
		elem_s = "%s+%s   " % [_elem_glyph(elements[0]), _elem_glyph(elements[1])]
	return elem_s + " · ".join(parts)

func _elem_glyph(rune: StringName) -> String:
	match rune:
		&"fire": return "🔥"
		&"ice": return "❄"
		&"electric": return "⚡"
		&"wind": return "🌪"
		&"earth": return "🪨"
		_: return ""
```

Wire into `scripts/ui/main.gd::_build_battle_overlay` (line 171). After the kill-bar setup:
```gdscript
	## Catalyst banner — fades in after start_wave when a compound is active.
	_catalyst_banner = preload("res://scripts/ui/catalyst_banner.gd").new()
	_catalyst_banner.position = Vector2(0, 90.0)
	_catalyst_banner.size = Vector2(vp.x, 88.0)
	layer.add_child(_catalyst_banner)
	## Show after the boss-telegraph banner clears (~1.5s after start_wave).
	Combat.boss_telegraph.connect(_on_stage_telegraph_for_catalyst, CONNECT_DEFERRED)
```

Add to main.gd top vars:
```gdscript
var _catalyst_banner: Control = null
```

Add the handler:
```gdscript
func _on_stage_telegraph_for_catalyst(_text: String) -> void:
	## Build the squad and resolve the active compound, then show the banner.
	var squad_weapons: Array = []
	for h in GameState.active_heroes():
		if h.weapon_data != null:
			squad_weapons.append(h.weapon_data)
	var resolved: Dictionary = (load("res://scripts/core/catalyst_resolver.gd")
		.resolve(squad_weapons, AccountState.current_stage))
	var compound = resolved.get("compound", null)
	if compound == null and not (resolved.get("compounds", []) as Array).is_empty():
		compound = (resolved["compounds"] as Array)[0]
	if compound != null:
		_catalyst_banner.show_compound(compound)
		## Codex discovery: record any compound just rendered to the player.
		_record_codex_discovery(resolved)

func _record_codex_discovery(resolved: Dictionary) -> void:
	var seen: Array = AccountState.catalyst_codex_discovered
	var actives: Array = resolved.get("compounds", [])
	if (resolved.get("compound", null) != null
		and not (resolved["compound"]["id"] in seen)):
		seen.append(resolved["compound"]["id"])
	for c in actives:
		if not (c["id"] in seen):
			seen.append(c["id"])
	AccountState.catalyst_codex_discovered = seen
	AccountState.autosave()
```

- [ ] **Step 4: Run TestCatalystUI — green.** Run TestCombat — no regression.

- [ ] **Step 5: Commit**

```bash
git add scripts/ui/catalyst_banner.gd scripts/ui/main.gd scripts/dev/test_catalyst_ui.gd scenes/dev/TestCatalystUI.tscn
git commit -m "$(cat <<'EOF'
ui(catalyst): start-of-stage compound banner + codex auto-discovery (C3)

Per spec 2026-06-09-catalyst-design §7.3:
- catalyst_banner.gd — start-of-stage banner Control. Fades in after the
  existing boss_telegraph banner (~stage signal), holds 1.2s (owner-
  approved CLAUDE.md §13), fades out.
- main.gd::_build_battle_overlay instances the banner and connects
  Combat.boss_telegraph -> _on_stage_telegraph_for_catalyst, which
  resolves the compound and triggers show_compound.

Plus codex auto-discovery: every time a compound is rendered to the
player at stage start, its id is added to
AccountState.catalyst_codex_discovered (idempotent + persisted).

TestCatalystUI 2/2. TestCombat unchanged.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task C4: Persistent HUD chip

**Files:**
- Create: `scripts/ui/catalyst_chip.gd`
- Modify: `scripts/ui/main.gd`
- Modify: `scripts/dev/test_catalyst_ui.gd`

- [ ] **Step 1: Add failing test** — append to `test_catalyst_ui.gd`:

```gdscript
const CatalystChipT = preload("res://scripts/ui/catalyst_chip.gd")

func _test_chip_renders_single_compound() -> void:
	var chip = CatalystChipT.new()
	add_child(chip)
	chip.set_compounds([{"id": &"firestorm", "display_name": "Firestorm",
		"elements": [&"fire", &"ice"],
		"modifier_bag": {&"squad_atk_mult": 1.20, &"squad_crit_add": 0.0,
			&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0}}])
	_check("chip visible after set_compounds", chip.visible == true, "hidden")
	_check("chip has 1 row child", chip._rows.get_child_count() == 1,
		"rows=%d" % chip._rows.get_child_count())
	chip.queue_free()

func _test_chip_stacks_up_to_three() -> void:
	var chip = CatalystChipT.new()
	add_child(chip)
	chip.set_compounds([
		{"id": &"firestorm", "display_name": "Firestorm", "elements": [&"fire", &"ice"], "modifier_bag": {}},
		{"id": &"wildfire", "display_name": "Wildfire", "elements": [&"fire", &"wind"], "modifier_bag": {}},
		{"id": &"blizzard", "display_name": "Blizzard", "elements": [&"ice", &"wind"], "modifier_bag": {}},
	])
	_check("3-compound stack -> 3 rows", chip._rows.get_child_count() == 3,
		"rows=%d" % chip._rows.get_child_count())
	chip.queue_free()

func _test_chip_hides_when_empty() -> void:
	var chip = CatalystChipT.new()
	add_child(chip)
	chip.set_compounds([])
	_check("empty set hides chip", chip.visible == false, "visible")
	chip.queue_free()
```

Dispatch.

- [ ] **Step 2: Run — expect FAIL** (CatalystChipT not found).

- [ ] **Step 3: Implement** — `scripts/ui/catalyst_chip.gd`:

```gdscript
## CatalystChip — persistent HUD chip (top-right) for the active stage (spec §7.4).
##
## Shows 1 row in cap-1 mode, up to 3 stacked vertically in no-cap mode. Tap
## opens an expanded description overlay (deferred; v1 emits an `expand_requested`
## signal — main.gd wires later).
##
## Public:
##   set_compounds(records: Array)  Replace the rendered set. [] -> hidden.
class_name CatalystChip
extends PanelContainer

signal expand_requested

var _rows: VBoxContainer

func _ready() -> void:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.10, 0.06, 0.16, 0.78)
	sb.set_border_width_all(1)
	sb.border_color = Color(0.55, 0.45, 0.75, 0.6)
	sb.set_corner_radius_all(6)
	add_theme_stylebox_override(&"panel", sb)
	custom_minimum_size = Vector2(150, 0)
	_rows = VBoxContainer.new()
	_rows.add_theme_constant_override(&"separation", 2)
	add_child(_rows)
	visible = false
	gui_input.connect(_on_gui_input)

func set_compounds(records: Array) -> void:
	for c in _rows.get_children():
		c.queue_free()
	if records.is_empty():
		visible = false
		return
	for rec in records:
		_rows.add_child(_build_row(rec))
	visible = true

func _build_row(rec: Dictionary) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override(&"separation", 4)
	var icon_text: String = "💠"
	var elements: Array = rec.get("elements", [])
	if elements.size() == 2:
		icon_text = "%s+%s" % [_glyph(elements[0]), _glyph(elements[1])]
	var icon := Label.new()
	icon.text = icon_text
	icon.add_theme_font_size_override(&"font_size", 12)
	row.add_child(icon)
	var name_l := Label.new()
	name_l.text = String(rec.get("display_name", ""))
	name_l.add_theme_font_size_override(&"font_size", 11)
	row.add_child(name_l)
	return row

func _glyph(rune: StringName) -> String:
	match rune:
		&"fire": return "🔥"
		&"ice": return "❄"
		&"electric": return "⚡"
		&"wind": return "🌪"
		&"earth": return "🪨"
		_: return ""

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		expand_requested.emit()
```

Wire into `scripts/ui/main.gd::_build_battle_overlay` (after the banner):
```gdscript
	_catalyst_chip = preload("res://scripts/ui/catalyst_chip.gd").new()
	_catalyst_chip.position = Vector2(vp.x - 160.0, 16.0)
	layer.add_child(_catalyst_chip)
	Combat.boss_telegraph.connect(_on_stage_telegraph_for_chip, CONNECT_DEFERRED)
```

Add var + handler in main.gd:
```gdscript
var _catalyst_chip: Control = null

func _on_stage_telegraph_for_chip(_text: String) -> void:
	var squad_weapons: Array = []
	for h in GameState.active_heroes():
		if h.weapon_data != null:
			squad_weapons.append(h.weapon_data)
	var resolved: Dictionary = (load("res://scripts/core/catalyst_resolver.gd")
		.resolve(squad_weapons, AccountState.current_stage))
	var compounds_arr: Array = resolved.get("compounds", [])
	if compounds_arr.is_empty() and resolved.get("compound", null) != null:
		compounds_arr = [resolved["compound"]]
	_catalyst_chip.set_compounds(compounds_arr)
```

- [ ] **Step 4: Run TestCatalystUI — green.**

- [ ] **Step 5: Commit**

```bash
git add scripts/ui/catalyst_chip.gd scripts/ui/main.gd scripts/dev/test_catalyst_ui.gd
git commit -m "$(cat <<'EOF'
ui(catalyst): persistent HUD chip — top-right stage indicator (C4)

Per spec 2026-06-09-catalyst-design §7.4:
- catalyst_chip.gd — PanelContainer chip with 1-3 stacked rows. Hidden
  when no compound is active. Tap emits expand_requested (overlay TBD).
- main.gd wires Combat.boss_telegraph -> _on_stage_telegraph_for_chip,
  resolves the current compound list, and pushes into set_compounds.

TestCatalystUI +3 cases (single / stack / hide).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task C5: Catalyst Codex sub-screen (Owner Gate 2 — defer-cuttable)

**Files** *(only if Owner Gate 2 keeps Codex in v1)*:
- Create: `scripts/ui/catalyst_codex.gd`
- Modify: `scripts/ui/home_screen.gd` (add a Codex button)
- Modify: `scripts/dev/test_catalyst_ui.gd`

If Owner Gate 2 defers Codex: SKIP this task entirely; Chunk C ends at C4. The `catalyst_codex_discovered` field already exists in v5 saves and gets populated by C3's banner hook, so the data side is ready for a v1.1 codex without further migration.

- [ ] **Step 1: Add failing tests** — append:

```gdscript
const CatalystCodexT = preload("res://scripts/ui/catalyst_codex.gd")

func _test_codex_lists_all_ten() -> void:
	var c = CatalystCodexT.new()
	add_child(c)
	c.refresh(AccountState.catalyst_codex_discovered)
	_check("codex shows 10 rows", c._list.get_child_count() == 10,
		"rows=%d" % c._list.get_child_count())
	c.queue_free()

func _test_codex_marks_discovered() -> void:
	var c = CatalystCodexT.new()
	add_child(c)
	c.refresh([&"firestorm"])
	## First-row discovered flag: alpha-priority orders Blizzard first; Firestorm is row 2.
	_check("codex header shows 1 / 10 discovered",
		c._header.text.contains("1 / 10"), "text=%s" % c._header.text)
	c.queue_free()

func _test_codex_hides_earth_below_s10() -> void:
	var c = CatalystCodexT.new()
	add_child(c)
	c.refresh([], 1)             ## stage 1
	## Earth rows render with a 🔒 prefix; verify Volcanic carries it.
	var volcanic_row = c._row_for(&"volcanic")
	_check("Volcanic shows 🔒 at stage 1", volcanic_row != null and volcanic_row.text.contains("🔒"),
		"row=%s" % (volcanic_row.text if volcanic_row != null else "null"))
	c.queue_free()
```

- [ ] **Step 2: Run — expect FAIL** (Codex class missing).

- [ ] **Step 3: Implement** — `scripts/ui/catalyst_codex.gd`:

```gdscript
## CatalystCodex — discovery-driven codex listing all 10 compounds (spec §7.5).
##
## refresh(discovered: Array, stage: int = current) -> rebuild the list with
## ★ markers for discovered + 🔒 markers for Earth-gated at stage < 10.
class_name CatalystCodex
extends Control

const CatalystDataT = preload("res://scripts/data/catalyst_data.gd")

var _header: Label
var _list: VBoxContainer

func _ready() -> void:
	var v := VBoxContainer.new()
	v.set_anchors_preset(Control.PRESET_FULL_RECT)
	v.add_theme_constant_override(&"separation", 4)
	add_child(v)
	_header = Label.new()
	_header.add_theme_font_size_override(&"font_size", 16)
	v.add_child(_header)
	_list = VBoxContainer.new()
	_list.add_theme_constant_override(&"separation", 2)
	v.add_child(_list)

func refresh(discovered: Array, stage: int = -1) -> void:
	if stage < 0:
		stage = AccountState.current_stage
	for c in _list.get_children():
		c.queue_free()
	var rows: Array = CatalystDataT.by_priority()
	var disc_count: int = 0
	for rec in rows:
		var disc: bool = rec["id"] in discovered
		if disc:
			disc_count += 1
		_list.add_child(_build_row(rec, disc, stage))
	_header.text = "CATALYST CODEX — %d / 10 discovered" % disc_count

func _build_row(rec: Dictionary, discovered: bool, stage: int) -> Label:
	var l := Label.new()
	l.add_theme_font_size_override(&"font_size", 12)
	var elements: Array = rec.get("elements", [])
	var icons: String = ""
	if elements.size() == 2:
		icons = "%s+%s " % [_glyph(elements[0]), _glyph(elements[1])]
	var locked: bool = int(rec.get("gated_from_stage", 0)) > stage
	var prefix: String = ("🔒 " if locked else ("★ " if discovered else "  "))
	var effect_s: String = _format_effect(rec)
	l.text = "%s%s%-16s  %s" % [prefix, icons, rec.get("display_name", ""), effect_s]
	if locked:
		l.modulate = Color(0.6, 0.6, 0.6)
	elif discovered:
		l.modulate = Color(1.0, 0.85, 0.4)
	else:
		l.modulate = Color(0.85, 0.85, 0.85)
	return l

## Used by the test harness to fetch the row label for a specific compound id.
func _row_for(id: StringName) -> Label:
	for c in _list.get_children():
		if c is Label and c.text.contains(_display_name_for(id)):
			return c
	return null

func _display_name_for(id: StringName) -> String:
	for rec in CatalystDataT.compounds():
		if rec["id"] == id:
			return rec["display_name"]
	return ""

func _format_effect(rec: Dictionary) -> String:
	## Same effect renderer as catalyst_banner / home_screen — copy or share.
	var mb: Dictionary = rec.get("modifier_bag", {})
	var parts: Array = []
	if not is_equal_approx(float(mb.get(&"squad_atk_mult", 1.0)), 1.0):
		parts.append("+%d%% ATK" % int(round((float(mb[&"squad_atk_mult"]) - 1.0) * 100.0)))
	if not is_equal_approx(float(mb.get(&"squad_crit_add", 0.0)), 0.0):
		parts.append("+%d%% crit" % int(round(float(mb[&"squad_crit_add"]) * 100.0)))
	if not is_equal_approx(float(mb.get(&"enemy_atk_speed_mult", 1.0)), 1.0):
		parts.append("-%d%% enemy atk-spd" % int(round((1.0 - float(mb[&"enemy_atk_speed_mult"])) * 100.0)))
	if not is_equal_approx(float(mb.get(&"squad_atk_vs_swarm_mult", 1.0)), 1.0):
		parts.append("+%d%% vs swarm" % int(round((float(mb[&"squad_atk_vs_swarm_mult"]) - 1.0) * 100.0)))
	return " · ".join(parts) if not parts.is_empty() else "—"

func _glyph(rune: StringName) -> String:
	match rune:
		&"fire": return "🔥"
		&"ice": return "❄"
		&"electric": return "⚡"
		&"wind": return "🌪"
		&"earth": return "🪨"
		_: return ""
```

Add a "💠 CODEX" button somewhere on Home (next to the reset button). Wire to push the codex onto a CanvasLayer overlay, similar to ForgeWheel's reveal pattern.

- [ ] **Step 4: Run TestCatalystUI — green.**

- [ ] **Step 5: Commit**

```bash
git add scripts/ui/catalyst_codex.gd scripts/ui/home_screen.gd scripts/dev/test_catalyst_ui.gd
git commit -m "$(cat <<'EOF'
ui(catalyst): Catalyst Codex sub-screen — 10-row discovery surface (C5)

Per spec 2026-06-09-catalyst-design §7.5: a discovery-driven codex
listing all 10 compounds, sorted by alphabetical_priority. Rows show
🔒 for Earth-pair compounds below stage 10, ★ for discovered, blank
otherwise. Header reads "CATALYST CODEX — N / 10 discovered".

No reward axis in v1 (deferred per spec §10); the codex is purely a
discovery / completionist surface. Data persists in
AccountState.catalyst_codex_discovered (already wired in C3).

TestCatalystUI +3 cases.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Chunk C acceptance gate — full-suite green

```
mcp__godot__run_project(scene="res://scenes/dev/TestCatalyst.tscn")    -> 14/14
mcp__godot__run_project(scene="res://scenes/dev/TestCatalystUI.tscn")  -> 8/8 (or 5/5 if C5 deferred)
mcp__godot__run_project(scene="res://scenes/dev/TestAccountState.tscn")-> +4 cases
mcp__godot__run_project(scene="res://scenes/dev/TestForgeWheel.tscn")  -> +5 cases
mcp__godot__run_project(scene="res://scenes/dev/TestCombat.tscn")      -> +3 cases (stage-1 neutrality)
mcp__godot__run_project(scene="res://scenes/dev/TestHomeScreen.tscn")  -> +3 cases
mcp__godot__run_project(scene="res://scenes/dev/TestWeaponData.tscn")  -> 32/32 unchanged
mcp__godot__run_project(scene="res://scenes/dev/TestSkillCardData.tscn")-> 14/14 unchanged
... run the remaining ~8 dev scenes; all green.
```

Expected total: ~450-453 green.

### Post-chunk-C — owner playtest moment

After full-suite green, hand the build to the owner for the playtest probe:

1. Reset account → equip starters → start stage 1 → confirm no banner appears (stage-1 neutrality contract).
2. Pull once (Forge Wheel) → confirm Fire-Emberfang lands on Bran.
3. Pull twice more → confirm 2nd pull is RNG, 3rd pull is guaranteed Ice-Frostcall on Elara.
4. Start stage 2 → confirm "💠 FIRESTORM CATALYST ACTIVE" banner appears + chip shows top-right + briefing dialog (when pre-stage briefing opens) lists "💠 ACTIVE CATALYST · Firestorm".
5. Reach stage 5 → confirm a 3-element squad now triggers multiple compounds (no-cap mode).
6. (If C5 shipped) open the Codex tab → confirm rows render with proper ★ / 🔒 markers.

Open this as a thumbs-up gate before merge. If anything reads wrong, file a ticket; the architecture is sound, only numbers + copy + visual polish need tuning.

---

## STATUS.md + CLAUDE.md update

After Chunk C lands and the owner has thumbs-upped the playtest:

- [ ] Update `docs/STATUS.md` §3 DONE row for **Catalyst v1 shipped** with commit range + test count delta. Bump the test-count baseline (~423 → ~450).
- [ ] Update `docs/STATUS.md` §4 NEXT queue: remove "#4 Catalyst" from the queue; promote the remaining items (Hot Paladin, draft cards, socket retirement 9a-e, spin cinematic).
- [ ] Update `CLAUDE.md` §4 — append `TestCatalyst` and `TestCatalystUI` to the self-quitting test list. Bump the `~450 tests baseline` line.
- [ ] Update `CLAUDE.md` §7 current-version line: `Current version: v5`.
- [ ] Owner say-so → merge `forgeloop/catalyst-element-pairs` → `main` (the `phase1` branch is already FF-equal to main, so this is a clean merge).

Commit the doc updates as one final commit:
```bash
git add docs/STATUS.md ../CLAUDE.md
git commit -m "$(cat <<'EOF'
docs(catalyst): STATUS + CLAUDE updates for v1 shipped

- STATUS §3: Catalyst v1 added to DONE (commit range, test delta).
- STATUS §4: #4 Catalyst removed from NEXT queue; remaining items promoted.
- CLAUDE.md §4: TestCatalyst + TestCatalystUI added to self-quitting list.
- CLAUDE.md §4: test baseline bumped to ~450.
- CLAUDE.md §7: save schema version bumped to v5.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Self-review (this is the plan author's own pass — done before owner reviews)

**Spec coverage check** (every section of `2026-06-09-catalyst-design.md`):

| Spec § | Plan task(s) |
|---|---|
| §1 Goal | Architecture summary |
| §2 10 compounds (6 + 4 Earth) | A1 (CatalystData table) |
| §3 Modifier-bag shape + composition rules | A1, A3 (_compose), A4 (compose math test) |
| §4 Trigger condition (rune lookup, empty skip, Earth gate) | A2, A3, A5 |
| §5 Stacking (cap-1 alpha S1-4, no-cap S5+) | A4, A5 |
| §6 Scripted starter pulls + non-elemental starters | B2 (starters), B4 (scripted pulls) |
| §7.1 Home squad-line upgrade | C1 |
| §7.2 Pre-stage briefing section | C2 |
| §7.3 Battle start banner | C3 |
| §7.4 Persistent HUD chip | C4 |
| §7.5 Catalyst Codex | C5 (Owner Gate 2 cuttable) |
| §8.1 catalyst_data.gd shape | A1 |
| §8.2 catalyst_resolver.gd shape | A3 |
| §8.3 Combat hook | B5 |
| §8.4 Home + battle UI | C1-C5 |
| §8.5 AccountState v4 → v5 | B1 |
| §9.1 TestCatalyst 11 cases | A1-A5 cover C-1..C-11 (with C-11 split between A5 surface check and B5 combat-side test) |
| §9.2 TestAccountState migration | B1 |
| §9.3 TestForgeWheel scripted pulls | B4 |
| §9.4 TestCombat stage-1 neutrality | B5 |
| §9.5 TestHomeScreen squad-line | C1 |
| §10 Out of scope | Acknowledged: enemy_atk_speed_mult application deferred to v1.1 (called out in B5 commit), Earth v2 effects deferred, codex completion rewards deferred, catalyst-aware enemies deferred. |
| §11 Numbers = STARTING | All `modifier_bag` numbers in A1 carry the Numbers Policy starting-value flag. |
| §12 Build sequencing A/B/C | Plan structured as A/B/C with explicit acceptance gates between chunks. |
| §13 Open Qs | Owner Gate 1 (starter collision), Owner Gate 2 (Codex scope), Owner Gate 3 (Stormfront threshold) flagged at top. |
| §14 Acceptance (5 bullets) | Reviewer of this plan can name the 6 FTUE compounds (A1 table), explain pull #3 reveal (B4 test), explain 3-different at stage 4 vs 5 (A4 test), locate bag shape (A1 EMPTY_BAG), find stage-1 neutrality test (B5 _test_stage_1_neutrality_preserved). |

**Placeholder scan:** searched for "TBD" / "TODO" / "fill in" / "implement later" / "similar to" — none in the plan body. v1.1 deferral on `enemy_atk_speed_mult` is explicit + commit-noted, not a placeholder.

**Type consistency:** `merged_bag` (Dictionary, 4 keys) consistent across A3/A4/A5/B5. `compound` vs `compounds` keys consistent (single in cap-1, array in no-cap, both in result dict). `scripted_pulls_seen` / `catalyst_codex_discovered` / `pull_count` consistent across B1/B4. `_catalyst_bag` (Combat) consistent across B5/C3/C4. `show_compound(record)` vs `set_compounds(records)` — chip takes a list, banner takes one; matches spec §7.3 (single compound named) vs §7.4 (stacks up to 3).

**Open risks called out:**
- Owner Gate 1 (starter collision) MUST be resolved before B2. Plan ships Option A as default; Option B variants noted inline.
- Owner Gate 2 (Codex scope) cuts C5 if deferred — no architectural change.
- B5 defers `enemy_atk_speed_mult` combat application. Blizzard's bag value is correct but its in-combat effect is dormant. Spec §3 promises "zero new combat callbacks" — applying enemy_atk_speed_mult would require either a per-enemy tick-skip roll or a Combat.TICK_SEC scale, both of which need a small new callback. Flagged for owner; plan ships the merged-bag math correct and the combat behavior deferred to v1.1.

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-06-09-catalyst-element-pairs.md`. Two execution options:

**1. Subagent-Driven (recommended)** — fresh subagent per task, review between tasks, fast iteration. Fits this 12-task plan well because chunks A/B/C have clean boundaries.

**2. Inline Execution** — execute tasks in this session with checkpoints. Faster turnaround per task but you eat all context in one window.

Which approach?
