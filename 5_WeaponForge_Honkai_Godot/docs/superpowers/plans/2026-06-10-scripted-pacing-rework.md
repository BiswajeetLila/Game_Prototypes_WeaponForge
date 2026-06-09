# Scripted Pacing Rework — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Layer the 4-beat scripted narrative pacing on Catalyst v1 — Pull #1 Bran fire, Pull #3 Vex electric (NEW Voltedge Daggers), Stage 3 boss scripted-wipe + Hot Paladin descend (NEW light element + Helios Cleaver), Pull #5 Elara ice. Plus the economy adjustment (boss bonus 1→3, victory 2→4) that makes the pacing land consistently.

**Architecture:**
- Single-file data additions: `w_voltedge_daggers.tres`, `w_helios_cleaver.tres`, `paladin.tres` hero, paladin_entry.png asset.
- Catalyst data extends with light glyph + 4 light-pair compounds — no resolver code changes (already alpha-sorted, just bigger compound table).
- AccountState v5→v6 adds `paladin_unlocked: bool`. Existing `scripted_pulls_seen` gets new sentinels.
- ForgeWheel scripted-pick reshuffles pull #3/#5 + adds `SCRIPTED_GRANT_IDS` exclusion + scripted-only auto-equip override.
- Combat scripted-wipe lives inside `_boss_tick_arcane_lich` phase-2 entry, gated by sentinel — one-shot per account.
- UI: Paladin row in Home roster, codex 14 rows, descend cinematic overlay reading the locked paladin_entry.png reference.

**Tech Stack:** Godot 4.6.2 Mono, GDScript, self-quitting TDD harnesses under `scripts/dev/`. Engine ops via `mcp__godot__*`.

**Spec source of truth:** `docs/superpowers/specs/2026-06-09-scripted-pacing-rework-design.md` (locked 2026-06-10 with owner answers in §11).

**Branch:** `forgeloop/scripted-pacing-rework` @ `fa704a4` (spec landed, image copied to assets).

**Test baseline before this plan:**
- TestCatalyst 45, TestCatalystUI 29, TestAccountState 96, TestForgeWheel 73, TestHomeScreen 18, TestCombat 73, TestWeaponData 70 = 404 across catalyst-touched suites.

**Test baseline target after this plan:** ~450 (+~46 new across the 7 suites + light-compound + paladin-defeat + economy-bump cases).

---

## File Structure

```
Prototype/godot/
├── data/
│   ├── heroes/
│   │   └── paladin.tres                       [CREATE — locked-by-default 4th hero]
│   └── weapons/
│       ├── w_voltedge_daggers.tres            [CREATE — R rogue electric, atk 21]
│       └── w_helios_cleaver.tres              [CREATE — E paladin light, atk 28]
├── scripts/
│   ├── core/
│   │   ├── account_state.gd                   [MODIFY — v5→v6 + paladin_unlocked + ember bump]
│   │   ├── catalyst_data.gd                   [MODIFY — light glyph + 4 light compounds + priority order]
│   │   ├── combat.gd                          [MODIFY — paladin_descend signal + scripted-wipe trigger]
│   │   ├── forge_wheel.gd                     [MODIFY — scripted-pulls reshuffle + SCRIPTED_GRANT_IDS + force auto-equip]
│   │   ├── game_state.gd                      [MODIFY — 4-hero roster, paladin lock gate]
│   │   └── stage_affinity.gd                  [MODIFY — Arcane Lich weak=light resist=earth]
│   ├── ui/
│   │   ├── catalyst_codex.gd                  [MODIFY — 14-row header / light-row rendering]
│   │   ├── home_screen.gd                     [MODIFY — Paladin row + squad-selection 3-of-4]
│   │   └── main.gd                            [MODIFY — paladin_descend cinematic + retry flow]
│   └── dev/
│       ├── test_account_state.gd              [MODIFY — v6 migration + paladin_unlocked + ember bump cases]
│       ├── test_catalyst.gd                   [MODIFY — 4 new light-pair tests + priority order rebaseline]
│       ├── test_catalyst_ui.gd                [MODIFY — codex 14 rows]
│       ├── test_combat.gd                     [MODIFY — Arcane Lich scripted-wipe trigger gating]
│       ├── test_forge_wheel.gd                [MODIFY — scripted-pulls #1/#3/#5 + force auto-equip + SCRIPTED_GRANT_IDS]
│       └── test_home_screen.gd                [MODIFY — Paladin row locked/unlocked]
└── assets/generated/cinematics/
    └── paladin_entry.png                      [ALREADY COPIED — 1.4MB ref image]
```

---

## Chunk A — Data layer + light element + economy bump

Pure data + table additions. No game-side effect until ForgeWheel + Combat tasks light them up.

### Task A1: Voltedge Daggers (Rare electric rogue)

**Files:**
- Create: `Prototype/godot/data/weapons/w_voltedge_daggers.tres`
- Modify: `Prototype/godot/scripts/core/game_state.gd` (register in `WEAPON_IDS`)
- Modify: `Prototype/godot/scripts/dev/test_forge_wheel.gd` (catalog count test if applicable)

- [ ] **Step 1: Write the failing test** — `test_forge_wheel.gd` `_test_catalog_depth_four_per_class` currently asserts 12+ weapons. Bump expected count or change assertion to ≥ 13. Add a new assertion that an electric Rare rogue exists.

```gdscript
func _test_voltedge_in_catalog() -> void:
	## A1: Rare electric rogue must exist (Voltedge Daggers).
	_check("voltedge_daggers exists",
		GameState.weapons_by_id.has(&"w_voltedge_daggers"), "missing")
	var w = GameState.weapons_by_id.get(&"w_voltedge_daggers")
	if w != null:
		_check("voltedge is Rare rogue electric",
			w.cls == &"rogue" and w.rune == &"electric" and w.rarity_idx == 1,
			"cls=%s rune=%s rarity=%d" % [w.cls, w.rune, w.rarity_idx])
```

Wire dispatch in `_ready()`.

- [ ] **Step 2: Run TestForgeWheel — expect FAIL** (Voltedge not yet in catalog).

- [ ] **Step 3: Create the .tres file** — `Prototype/godot/data/weapons/w_voltedge_daggers.tres`:

```
[gd_resource type="Resource" script_class="WeaponData" format=3]

[ext_resource type="Script" path="res://scripts/data/weapon_data.gd" id="1"]

[resource]
script = ExtResource("1")
id = &"w_voltedge_daggers"
name = "Voltedge Daggers"
cls = &"rogue"
ability = "Static Burst"
rune = &"electric"
base_atk = 21
base_hp = 12
base_crit = 10
base_ult_rate = 5
rarity_idx = 1
```

- [ ] **Step 4: Register in game_state.gd** — find the `WEAPON_IDS: Array` const (likely near catalog declarations). Add `&"w_voltedge_daggers"` to the list. If catalog is loaded via folder scan + .tres discovery, no code change needed — verify via test pass.

- [ ] **Step 5: Run TestForgeWheel — expect green** (catalog count + voltedge assertions pass).

- [ ] **Step 6: Commit**

```bash
git add data/weapons/w_voltedge_daggers.tres scripts/core/game_state.gd scripts/dev/test_forge_wheel.gd
git commit -m "$(cat <<'EOF'
feat(catalog): Voltedge Daggers — Rare electric rogue weapon (A1)

Adds w_voltedge_daggers.tres to the 12-weapon gacha catalog (now 13).
ATK 21 / HP 12 / crit 10 / ult 5 — Rare-tier baseline filling the
electric-rogue gap (Common Stormpierce non-elemental post-B2; only
electric rogue was Legendary Stormfang).

Forms the basis for scripted pull #3 (Vex electric reveal) in B2.

Numbers Policy starting values. TestForgeWheel +1 case.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task A2: Helios Cleaver (Epic paladin light, scripted-grant only)

**Files:**
- Create: `Prototype/godot/data/weapons/w_helios_cleaver.tres`
- Modify: `Prototype/godot/scripts/core/game_state.gd` (register)

- [ ] **Step 1: Test:** since Helios is scripted-grant only, the only test is its presence in `GameState.weapons_by_id`. Add to `test_forge_wheel.gd`:

```gdscript
func _test_helios_in_catalog() -> void:
	## A2: Helios Cleaver is registered (scripted-grant only; not in gacha pool).
	_check("helios_cleaver exists",
		GameState.weapons_by_id.has(&"w_helios_cleaver"), "missing")
	var w = GameState.weapons_by_id.get(&"w_helios_cleaver")
	if w != null:
		_check("helios is Epic paladin light",
			w.cls == &"paladin" and w.rune == &"light" and w.rarity_idx == 2,
			"cls=%s rune=%s rarity=%d" % [w.cls, w.rune, w.rarity_idx])
```

- [ ] **Step 2: Run TestForgeWheel — expect FAIL.**

- [ ] **Step 3: Create the .tres file** — `Prototype/godot/data/weapons/w_helios_cleaver.tres`:

```
[gd_resource type="Resource" script_class="WeaponData" format=3]

[ext_resource type="Script" path="res://scripts/data/weapon_data.gd" id="1"]

[resource]
script = ExtResource("1")
id = &"w_helios_cleaver"
name = "Helios Cleaver"
cls = &"paladin"
ability = "Solar Smite"
rune = &"light"
base_atk = 28
base_hp = 30
base_crit = 8
base_ult_rate = 10
rarity_idx = 2
```

- [ ] **Step 4: Register in game_state.gd** — append id to `WEAPON_IDS`.

- [ ] **Step 5: Run — expect green** (catalog presence + Epic paladin light assertions pass). NOTE: TestForgeWheel pull tests might now incorrectly include helios in pull pool — B1 will fix via SCRIPTED_GRANT_IDS exclusion. For A2, just verify catalog presence.

If TestForgeWheel's `_test_pull_happy_path` or rarity-pyramid tests fail because helios leaks into the pool, defer to B1's exclusion fix and report `DONE_WITH_CONCERNS`.

- [ ] **Step 6: Commit**

```bash
git add data/weapons/w_helios_cleaver.tres scripts/core/game_state.gd scripts/dev/test_forge_wheel.gd
git commit -m "$(cat <<'EOF'
feat(catalog): Helios Cleaver — Epic paladin light weapon (A2)

Adds w_helios_cleaver.tres (Epic paladin light, atk 28 / hp 30 / crit
8 / ult 10). The first light-element weapon. Scripted-grant only — B1
adds SCRIPTED_GRANT_IDS exclusion so eligible_weapons() filters it
from the gacha pool. Granted by Combat's Stage 3 boss defeat trigger
(Chunk C).

Adds paladin class to the catalog. Numbers Policy starting values.

TestForgeWheel +1 case.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task A3: Hot Paladin hero data + locked-by-default state

**Files:**
- Create: `Prototype/godot/data/heroes/paladin.tres`
- Modify: `Prototype/godot/scripts/core/game_state.gd` (register paladin in roster, locked-by-default)

- [ ] **Step 1: Read sibling hero .tres for template** — `data/heroes/bran.tres` (or equivalent file). Mirror the shape.

- [ ] **Step 2: Add failing test** — `test_account_state.gd` or `test_home_screen.gd`:

```gdscript
func _test_paladin_in_roster_locked() -> void:
	## A3: Paladin is registered in GameState roster but starts LOCKED.
	_check("paladin hero exists",
		GameState.heroes_by_id.has(&"paladin"), "missing")
	## active_heroes() should NOT include paladin pre-unlock.
	AccountState.reset_account()
	AccountState.paladin_unlocked = false
	var active_ids: Array = []
	for h in GameState.active_heroes():
		active_ids.append(h.data.id)
	_check("locked paladin NOT in active_heroes",
		not (&"paladin" in active_ids), "paladin leaked")
```

(This test will also need A6's `paladin_unlocked` field — depend on A6 to land first, OR write the assertion to skip if field doesn't exist yet.)

- [ ] **Step 3: Run — expect FAIL.**

- [ ] **Step 4: Create `paladin.tres`** with these fields (Numbers Policy):

```
[gd_resource type="Resource" script_class="HeroData" format=3]

[ext_resource type="Script" path="res://scripts/data/hero_data.gd" id="1"]

[resource]
script = ExtResource("1")
id = &"paladin"
name = "Hot Paladin"
cls = &"paladin"
atk_base = 8
hp_base = 100
ult_name = "Solar Burst"
ult_atk_multiplier = 2.5
sprite = "paladin"
```

(Adjust field names to match the actual HeroData schema. Read `data/heroes/bran.tres` first to align.)

- [ ] **Step 5: Modify game_state.gd** — add `&"paladin"` to `ROSTER_IDS` const. Update `active_heroes()` to filter on `AccountState.paladin_unlocked`:

```gdscript
func active_heroes() -> Array:
	var out: Array = []
	for id in ROSTER_IDS:
		if id == &"paladin" and not AccountState.paladin_unlocked:
			continue
		var h = heroes_by_id.get(id)
		if h != null:
			out.append(h)
	return out
```

(Adjust per actual function shape — read existing implementation first.)

- [ ] **Step 6: Run — expect green** (paladin in roster but excluded from active_heroes when locked).

- [ ] **Step 7: Commit**

```bash
git add data/heroes/paladin.tres scripts/core/game_state.gd scripts/dev/test_home_screen.gd
git commit -m "$(cat <<'EOF'
feat(roster): Hot Paladin hero data + locked-by-default gate (A3)

Adds Hot Paladin as the 4th roster slot per CLAUDE.md §13 (3 deploy
still). Stats per Numbers Policy: atk 8 (mid-tier), hp 100 (tank
lean), Solar Burst ult @ 2.5x AOE (placeholder kit; v1.1 = real
talents). Sprite asset deferred.

GameState.active_heroes() filters paladin out when
AccountState.paladin_unlocked == false. Combat C-chunk flips the flag
on Stage 3 boss scripted-wipe sentinel set.

TestHomeScreen +1 case.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task A4: Light glyph in CatalystData.ELEM_GLYPH

**Files:**
- Modify: `Prototype/godot/scripts/data/catalyst_data.gd` (add `&"light": "☀"`)
- Modify: `Prototype/godot/scripts/dev/test_catalyst.gd` (assert light glyph)

- [ ] **Step 1: Add failing test** — append to `test_catalyst.gd`:

```gdscript
func _test_elem_glyph_includes_light() -> void:
	## A4: Light element joins the glyph dict.
	_check("ELEM_GLYPH has light", CatalystDataT.ELEM_GLYPH.has(&"light"),
		"missing")
	_check("ELEM_GLYPH[light] == ☀",
		String(CatalystDataT.ELEM_GLYPH.get(&"light", "")) == "☀",
		"got=%s" % CatalystDataT.ELEM_GLYPH.get(&"light", ""))
```

Wire dispatch.

- [ ] **Step 2: Run TestCatalyst — expect FAIL.**

- [ ] **Step 3: Modify catalyst_data.gd** — find `ELEM_GLYPH` (consolidated in commit `2e97774`). Add:

```gdscript
const ELEM_GLYPH: Dictionary = {
	&"fire": "🔥", &"ice": "❄", &"electric": "⚡",
	&"wind": "🌪", &"earth": "🪨",
	&"light": "☀",   ## A4: scripted-pacing-rework light element
}
```

- [ ] **Step 4: Run — expect green.**

- [ ] **Step 5: Commit**

```bash
git add scripts/data/catalyst_data.gd scripts/dev/test_catalyst.gd
git commit -m "$(cat <<'EOF'
feat(catalyst): light element joins ELEM_GLYPH (A4)

Adds &\"light\": \"☀\" to CatalystData.ELEM_GLYPH (the consolidated
glyph dict from C5 cleanup commit 2e97774). All 4 UI surfaces
(home_screen squad-line, catalyst_banner, catalyst_chip, catalyst_codex)
inherit the light icon automatically since they all read from this dict.

TestCatalyst +1 case.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task A5: 4 light-pair Catalyst compounds + priority order update

**Files:**
- Modify: `Prototype/godot/scripts/data/catalyst_data.gd`
- Modify: `Prototype/godot/scripts/dev/test_catalyst.gd`

- [ ] **Step 1: Add failing tests** — append:

```gdscript
func _test_compounds_now_fourteen() -> void:
	## A5: 4 new light-pair compounds raise the total to 14.
	var rows: Array = CatalystDataT.compounds()
	_check("compounds() returns 14 records", rows.size() == 14,
		"size=%d" % rows.size())

func _test_for_pair_light_combinations() -> void:
	## A5: 4 light pairs map to Solar Flare / Halo Bloom / Plasma Arc / Auroral Veil.
	var pairs: Array = [
		[&"light", &"fire", &"solar_flare"],
		[&"light", &"ice", &"halo_bloom"],
		[&"light", &"electric", &"plasma_arc"],
		[&"light", &"wind", &"auroral_veil"],
	]
	for p in pairs:
		var r: Dictionary = CatalystDataT.for_pair(p[0], p[1])
		_check("for_pair(%s,%s) -> %s" % [p[0], p[1], p[2]],
			r.get("id", &"") == p[2], "id=%s" % r.get("id"))

func _test_alpha_priority_with_light() -> void:
	## A5: light compounds insert in alpha-priority order. Auroral Veil precedes
	## Blizzard; Halo Bloom between Glacial Storm and Plasma; etc.
	var sorted: Array = CatalystDataT.by_priority()
	var expected: Array = [&"auroral_veil", &"blizzard", &"firestorm",
		&"glacial_storm", &"halo_bloom", &"plasma", &"plasma_arc",
		&"solar_flare", &"stormfront", &"wildfire",
		&"magnetic_storm", &"permafrost", &"sandstorm", &"volcanic"]
	for i in range(expected.size()):
		_check("alpha-priority[%d] = %s" % [i, expected[i]],
			sorted[i]["id"] == expected[i],
			"got=%s expected=%s" % [sorted[i]["id"], expected[i]])
```

Dispatch all 3.

- [ ] **Step 2: Run TestCatalyst — expect FAIL** (compounds size 10 not 14; for_pair returns {}; alpha order missing light entries).

- [ ] **Step 3: Modify catalyst_data.gd** — extend the `compounds()` record table with 4 new entries:

```gdscript
		## ---------- Light pairs (Hot Paladin scripted-pacing-rework, 2026-06-10) ----------
		{"id": &"solar_flare", "elements": [&"light", &"fire"], "display_name": "Solar Flare",
			"modifier_bag": {&"squad_atk_mult": 1.20, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 0},
		{"id": &"halo_bloom", "elements": [&"light", &"ice"], "display_name": "Halo Bloom",
			"modifier_bag": {&"squad_atk_mult": 1.15, &"squad_crit_add": 0.10,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 0},
		{"id": &"plasma_arc", "elements": [&"light", &"electric"], "display_name": "Plasma Arc",
			"modifier_bag": {&"squad_atk_mult": 1.25, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 1.0, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 0},
		{"id": &"auroral_veil", "elements": [&"light", &"wind"], "display_name": "Auroral Veil",
			"modifier_bag": {&"squad_atk_mult": 1.0, &"squad_crit_add": 0.0,
				&"enemy_atk_speed_mult": 0.80, &"squad_atk_vs_swarm_mult": 1.0},
			"gated_from_stage": 0},
```

(Insert in the rows literal alongside the existing 10. The `_PRIORITY_ORDER` const handles the sort.)

Update `_PRIORITY_ORDER`:

```gdscript
const _PRIORITY_ORDER: Array = [
	&"auroral_veil", &"blizzard", &"firestorm", &"glacial_storm",
	&"halo_bloom", &"plasma", &"plasma_arc", &"solar_flare",
	&"stormfront", &"wildfire",
	&"magnetic_storm", &"permafrost", &"sandstorm", &"volcanic",
]
```

- [ ] **Step 4: Run TestCatalyst — expect green** (14 compounds, 4 light for_pair lookups, alpha order matches).

- [ ] **Step 5: Commit**

```bash
git add scripts/data/catalyst_data.gd scripts/dev/test_catalyst.gd
git commit -m "$(cat <<'EOF'
feat(catalyst): 4 light-pair compounds — Solar Flare / Halo Bloom / Plasma Arc / Auroral Veil (A5)

Per spec §3:
- Solar Flare    (light+fire)    +20% squad ATK
- Halo Bloom     (light+ice)     +15% ATK + 10% crit
- Plasma Arc     (light+electric) +25% squad ATK
- Auroral Veil   (light+wind)    -20% enemy atk-spd

_PRIORITY_ORDER updated so 14-row alpha sort lands consistently:
Auroral Veil > Blizzard > Firestorm > Glacial Storm > Halo Bloom >
Plasma > Plasma Arc > Solar Flare > Stormfront > Wildfire > [Earth
quartet at S10+].

All Numbers Policy starting values. Tune after playtest.

TestCatalyst +13 asserts (14-count, 4 for_pair lookups, 8 alpha-order
positions).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task A6: AccountState v5 → v6 + paladin_unlocked field

**Files:**
- Modify: `Prototype/godot/scripts/core/account_state.gd`
- Modify: `Prototype/godot/scripts/dev/test_account_state.gd`

- [ ] **Step 1: Add failing tests**:

```gdscript
func _test_save_version_is_6() -> void:
	_check("SAVE_VERSION bumped to 6 (paladin)", _Account.SAVE_VERSION == 6,
		"version=%d" % _Account.SAVE_VERSION)

func _test_v5_save_migrates_to_v6() -> void:
	## v5 save (Catalyst v1) loads into v6: paladin_unlocked defaults false.
	var v5: Dictionary = {"version": 5, "gems": 700, "stage": 1, "ember": 5,
		"weapons": [], "equipped": {}, "shards": [],
		"scripted_pulls_seen": [], "catalyst_codex_discovered": [], "pull_count": 0}
	var b = _Account.new()
	var ok: bool = b.load_from_dict(v5)
	_check("v5 save still loads", ok, "rejected")
	_check("v5 load: paladin_unlocked defaults false",
		("paladin_unlocked" in b) and b.paladin_unlocked == false,
		"missing or true")
	b.free()

func _test_paladin_unlocked_round_trip() -> void:
	var a = _Account.new()
	a.paladin_unlocked = true
	var d: Dictionary = a.to_save_dict()
	_check("save dict version is 6", int(d.get("version", -1)) == 6,
		"ver=%s" % str(d.get("version")))
	var b = _Account.new()
	b.load_from_dict(d)
	_check("paladin_unlocked round-trip", b.paladin_unlocked == true,
		"got=%s" % str(b.paladin_unlocked))
	a.free(); b.free()

func _test_reset_clears_paladin_unlocked() -> void:
	var a = _Account.new()
	a.paladin_unlocked = true
	a.reset_account()
	_check("reset clears paladin_unlocked",
		("paladin_unlocked" in a) and a.paladin_unlocked == false,
		"not cleared")
	a.free()
```

Also REPLACE the existing `_test_save_version_is_5` body to assert `== 6` (since SAVE_VERSION bumps). Or rename + leave the old test as a regression check on v5 fields. Cleanest: rename old to `_test_save_version_is_6` + bump the assert.

- [ ] **Step 2: Run TestAccountState — expect FAIL.**

- [ ] **Step 3: Modify account_state.gd**:
- Bump `SAVE_VERSION: int = 6`.
- Add `var paladin_unlocked: bool = false` near `pull_count`.
- `reset_account()`: add `paladin_unlocked = false`.
- `to_save_dict()`: emit `"paladin_unlocked": paladin_unlocked`.
- `load_from_dict()`:
  - Bump version range: `if ver < 2 or ver > 6: return false`.
  - Read optional field: `var new_paladin_unlocked: bool = bool(d.get("paladin_unlocked", false))`.
  - Commit: `paladin_unlocked = new_paladin_unlocked`.

- [ ] **Step 4: Run — expect green.**

- [ ] **Step 5: Commit**

```bash
git add scripts/core/account_state.gd scripts/dev/test_account_state.gd
git commit -m "$(cat <<'EOF'
feat(account): save schema v5 -> v6 — paladin_unlocked field (A6)

Adds paladin_unlocked: bool (default false). Combat C-chunk flips
true when the Stage 3 lich scripted-wipe sentinel
&\"defeat_stage_3_paladin\" lands in scripted_pulls_seen.
GameState.active_heroes() filters paladin out when false.

v2-v6 backwards compatible (validate-then-commit). reset_account
clears.

TestAccountState +4 cases.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task A7: Economy bump — boss bonus 1→3, victory 2→4

**Files:**
- Modify: `Prototype/godot/scripts/core/account_state.gd`
- Modify: `Prototype/godot/scripts/dev/test_account_state.gd`

- [ ] **Step 1: Add failing tests + rebaseline existing**:

The existing `_test_wave_clear_earnings` asserts old values (boss bonus 1, victory 2 → 3/stage). Rebaseline to the new values:

```gdscript
func _test_wave_clear_earnings_bumped() -> void:
	## A7: Economy bumped to support 1+ pull/stage with the scripted timeline.
	## Boss bonus 1->3, victory 2->4. Total cleared stage = 7 ember.
	AccountState.reset_account()
	AccountState.ember = 0
	## Simulate stage progression — boss wave first.
	AccountState._on_wave_cleared(5)   ## boss wave
	_check("boss wave pays 3 ember (was 1)", AccountState.ember == 3,
		"ember=%d" % AccountState.ember)
	AccountState.award_victory()
	_check("victory pays 4 ember (was 2)", AccountState.ember == 7,
		"ember=%d (boss 3 + victory 4)" % AccountState.ember)

func _test_starting_ember_unchanged() -> void:
	## Economy bump touches per-stage; starting balance stays 5 = 1 pull.
	AccountState.reset_account()
	_check("starting ember still 5", AccountState.ember == 5,
		"ember=%d" % AccountState.ember)
```

Find any existing test that asserts boss bonus 1 / victory 2 / 3-per-stage. Rebaseline to 3/4/7.

- [ ] **Step 2: Run — expect FAIL on the rebaseline asserts.**

- [ ] **Step 3: Modify account_state.gd constants**:

```gdscript
## Ember — scripted-pacing-rework bump 2026-06-10. Boss + victory raised
## so the 4-beat scripted timeline (pull #1/#3/#5 + Stage 3 defeat) lands
## consistently at 1 pull/stage cadence per spec §6.
const EMBER_BOSS_BONUS: int = 3      ## was 1
const EMBER_VICTORY_BONUS: int = 4   ## was 2
```

(Find existing const lines. Replace values + add the `## Why` comment per CLAUDE.md §8.)

- [ ] **Step 4: Run — expect green.**

- [ ] **Step 5: Commit**

```bash
git add scripts/core/account_state.gd scripts/dev/test_account_state.gd
git commit -m "$(cat <<'EOF'
balance(economy): ember boss+victory bump — supports scripted-pacing (A7)

Per spec §11a: bump per-stage ember accrual so the 4-beat scripted
timeline (pull #1 + #3 + #5 + Stage 3 defeat) lands at 1 pull/stage
cadence consistently.

  EMBER_BOSS_BONUS      1 -> 3
  EMBER_VICTORY_BONUS   2 -> 4

Total cleared stage = 7 ember (was 3). Pull cost unchanged at 5.

Player flow:
  Boot:           5 ember -> Pull #1 Bran fire scripted -> 0
  Stage 1 clear:           +7 -> 7
  Pull #2 RNG:                  -> 2
  Stage 2 clear:           +7 -> 9
  Pull #3 Vex scripted:         -> 4
  Stage 3 wipe (no clear): -> 4
  Stage 3 retry clear:     +7 -> 11
  Pull #4 RNG:                  -> 6
  Stage 4 clear:           +7 -> 13
  Pull #5 Elara scripted:       -> 8
  Stage 5 entry: ready for multi-compound no-cap stack

Numbers Policy starting values; playtest-tunable.

TestAccountState +2 cases (rebaseline + starting-unchanged).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Chunk A acceptance gate

Run all touched suites + regression smoke:

```
TestCatalyst       — expect ~60/0 (was 45; +13 light + +1 glyph = +14 → 59 or similar)
TestAccountState   — expect ~102/0 (was 96; +4 v6 + +2 economy)
TestForgeWheel     — expect ~75/0 (was 73; +2 catalog additions)
TestCatalystUI     — expect 29/0 unchanged
TestHomeScreen     — expect 19/0 (was 18; +1 paladin-locked-roster)
TestCombat         — expect 73/0 unchanged
TestWeaponData     — expect 70/0 unchanged
```

If any earlier-baseline regression suite drops, REVERT and report BLOCKED.

---

## Chunk B — ForgeWheel scripted-pull reshuffle + scripted-grant exclusion + force auto-equip

### Task B1: SCRIPTED_GRANT_IDS exclusion (Helios off the gacha)

**Files:**
- Modify: `Prototype/godot/scripts/core/forge_wheel.gd`
- Modify: `Prototype/godot/scripts/dev/test_forge_wheel.gd`

- [ ] **Step 1: Add failing test**:

```gdscript
func _test_helios_not_in_pull_pool() -> void:
	## B1: SCRIPTED_GRANT_IDS filters Helios out of eligible_weapons.
	_fresh(600, 9999)
	var ids_in_pool: Dictionary = {}
	for w in _wheel().eligible_weapons():
		ids_in_pool[w.id] = true
	_check("helios NOT in eligible pool",
		not ids_in_pool.has(&"w_helios_cleaver"), "leaked into pool")
```

- [ ] **Step 2: Run — expect FAIL** (helios in pool post-A2).

- [ ] **Step 3: Modify forge_wheel.gd**:

```gdscript
## Scripted-grant-only weapons — Hot Paladin defeat (Helios Cleaver) and any
## future cinematic event drops. eligible_weapons() filters these so RNG
## never pulls them. They sit in GameState.weapons_by_id only so
## AccountState.acquire_weapon can hand them out on scripted cue.
const SCRIPTED_GRANT_IDS: Array = [&"w_helios_cleaver"]
```

In `eligible_weapons()`:

```gdscript
func eligible_weapons() -> Array:
	var out: Array = []
	var fielded: Dictionary = GameState.fielded_classes()
	for id in GameState.weapon_ids:
		if id in SCRIPTED_GRANT_IDS:
			continue   ## scripted-grant only; never RNG
		var w = GameState.weapons_by_id[id]
		if fielded.has(w.cls):
			out.append(w)
	return out
```

- [ ] **Step 4: Run — expect green.**

- [ ] **Step 5: Commit**

```bash
git add scripts/core/forge_wheel.gd scripts/dev/test_forge_wheel.gd
git commit -m "$(cat <<'EOF'
feat(forge-wheel): SCRIPTED_GRANT_IDS exclusion (B1)

Adds const SCRIPTED_GRANT_IDS = [&\"w_helios_cleaver\"]. eligible_weapons()
filters this list so RNG pulls never include scripted-grant-only weapons.
Helios Cleaver lives in GameState.weapons_by_id for acquire_weapon
hand-off via Combat (Chunk C), not for gacha distribution.

Pattern reusable for future scripted grants (Master Smith, etc.).

TestForgeWheel +1 case.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task B2: Scripted-pull reshuffle (pull #3 → Vex electric, pull #5 → Elara ice)

**Files:**
- Modify: `Prototype/godot/scripts/core/forge_wheel.gd`
- Modify: `Prototype/godot/scripts/dev/test_forge_wheel.gd`

- [ ] **Step 1: Update failing tests + add new pull #5 test**:

Find existing `_test_scripted_pull_3_ice_mage`. Rewrite as `_test_scripted_pull_3_electric_rogue`:

```gdscript
func _test_scripted_pull_3_electric_rogue() -> void:
	## B2: Pull #3 reshuffled to Vex Rare electric (was: Elara ice).
	_fresh(600, 9999)
	AccountState.scripted_pulls_seen = []
	AccountState.pull_count = 0
	_wheel().pull()   ## #1 fire-warrior (scripted)
	_wheel().pull()   ## #2 RNG
	var r3: Dictionary = _wheel().pull()
	_check("pull #3 returns a result", not r3.is_empty(), "empty")
	if not r3.is_empty():
		_check("pull #3 is electric", r3.weapon.rune == &"electric",
			"rune=%s" % r3.weapon.rune)
		_check("pull #3 is rogue", r3.weapon.cls == &"rogue",
			"cls=%s" % r3.weapon.cls)
		_check("pull #3 is Rare (rarity_idx 1)", r3.weapon.rarity_idx == 1,
			"rarity=%d" % r3.weapon.rarity_idx)
	_check("scripted_pulls_seen includes pull_3_electric_rogue",
		&"pull_3_electric_rogue" in AccountState.scripted_pulls_seen,
		"seen=%s" % str(AccountState.scripted_pulls_seen))
```

Add new pull #5 test:

```gdscript
func _test_scripted_pull_5_ice_mage() -> void:
	## B2: NEW pull #5 reveals Elara Legendary ice (was: pull #3).
	_fresh(600, 9999)
	AccountState.scripted_pulls_seen = []
	AccountState.pull_count = 0
	_wheel().pull()   ## #1
	_wheel().pull()   ## #2
	_wheel().pull()   ## #3
	_wheel().pull()   ## #4 RNG
	var r5: Dictionary = _wheel().pull()
	_check("pull #5 returns a result", not r5.is_empty(), "empty")
	if not r5.is_empty():
		_check("pull #5 is ice", r5.weapon.rune == &"ice",
			"rune=%s" % r5.weapon.rune)
		_check("pull #5 is mage", r5.weapon.cls == &"mage",
			"cls=%s" % r5.weapon.cls)
		_check("pull #5 is Legendary (rarity_idx 3)", r5.weapon.rarity_idx == 3,
			"rarity=%d" % r5.weapon.rarity_idx)
	_check("scripted_pulls_seen includes pull_5_ice_mage",
		&"pull_5_ice_mage" in AccountState.scripted_pulls_seen,
		"seen=%s" % str(AccountState.scripted_pulls_seen))
```

Wire dispatches.

- [ ] **Step 2: Run — expect FAIL.**

- [ ] **Step 3: Modify forge_wheel.gd**:

Rename `SCRIPT_PULL_3_SENTINEL`:

```gdscript
const SCRIPT_PULL_1_SENTINEL: StringName = &"pull_1_fire_warrior"
const SCRIPT_PULL_3_SENTINEL: StringName = &"pull_3_electric_rogue"
const SCRIPT_PULL_5_SENTINEL: StringName = &"pull_5_ice_mage"
```

Rewrite `_try_scripted_pick`:

```gdscript
func _try_scripted_pick(eligible: Array):
	var n: int = AccountState.pull_count + 1
	if n == 1 and not (SCRIPT_PULL_1_SENTINEL in AccountState.scripted_pulls_seen):
		var pick = _pick_first_match(eligible, &"fire", &"warrior")
		if pick != null:
			AccountState.scripted_pulls_seen.append(SCRIPT_PULL_1_SENTINEL)
			return pick
		return null
	elif n == 3 and not (SCRIPT_PULL_3_SENTINEL in AccountState.scripted_pulls_seen):
		var pick = _pick_first_match(eligible, &"electric", &"rogue")
		if pick != null:
			AccountState.scripted_pulls_seen.append(SCRIPT_PULL_3_SENTINEL)
			return pick
		return null
	elif n == 5 and not (SCRIPT_PULL_5_SENTINEL in AccountState.scripted_pulls_seen):
		var pick = _pick_first_match(eligible, &"ice", &"mage")
		if pick != null:
			AccountState.scripted_pulls_seen.append(SCRIPT_PULL_5_SENTINEL)
			return pick
		return null
	return null
```

- [ ] **Step 4: Run — expect green for both new tests.**

- [ ] **Step 5: Commit**

```bash
git add scripts/core/forge_wheel.gd scripts/dev/test_forge_wheel.gd
git commit -m "$(cat <<'EOF'
refactor(forge-wheel): scripted-pull reshuffle — #1 Bran fire / #3 Vex electric / #5 Elara ice (B2)

Per spec §2 (locked timeline):
- Pull #1 sentinel pull_1_fire_warrior (UNCHANGED) -> Cinderbrand
  Greatsword (Epic fire warrior, Bran).
- Pull #3 RENAMED pull_3_ice_mage -> pull_3_electric_rogue. Drop is
  Voltedge Daggers (Rare electric rogue, Vex; added in A1).
- Pull #5 NEW sentinel pull_5_ice_mage. Drop is Glacial Aegis Staff
  (Legendary ice mage, Elara). Moved from old pull #3 slot.

Pull #2 + #4 + #6+ remain RNG. scripted_pulls_seen tracks all three
sentinels independently; mid-stream cold-restart preserves which beats
have fired.

TestForgeWheel +2 cases (electric rogue #3, ice mage #5). Old
pull_3_ice_mage test renamed + rewritten in-place.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task B3: Scripted-pull force auto-equip override

**Files:**
- Modify: `Prototype/godot/scripts/core/forge_wheel.gd`
- Modify: `Prototype/godot/scripts/dev/test_forge_wheel.gd`

- [ ] **Step 1: Add failing test**:

```gdscript
func _test_scripted_pull_force_equips_over_starter() -> void:
	## B3: scripted pull #1 force-equips Cinderbrand on Bran even when Bran's
	## non-elemental starter (Emberfang, rune="") is already in the slot.
	_fresh(600, 9999)
	AccountState.scripted_pulls_seen = []
	AccountState.pull_count = 0
	## Grant starters first (mimics _grant_starter_if_first_boot).
	var starter = GameState.weapons_by_id[&"w_emberfang_cleaver"].duplicate(true)
	AccountState.owned_weapons = [starter]
	AccountState.equip(&"bran", 0)
	## Now pull -- scripted pick lands Cinderbrand on Bran.
	var r: Dictionary = _wheel().pull()
	_check("pull #1 returns a result", not r.is_empty(), "empty")
	if not r.is_empty():
		_check("Bran's equipped weapon is Cinderbrand (force-equipped)",
			AccountState.get_equipped(&"bran").id == &"w_cinderbrand_greatsword",
			"equipped=%s" % AccountState.get_equipped(&"bran").id)
		_check("auto_equipped flag set on scripted pull",
			bool(r.get("auto_equipped", false)), "flag false")
```

- [ ] **Step 2: Run — expect FAIL** (current logic skips auto-equip when slot non-null).

- [ ] **Step 3: Modify forge_wheel.gd::pull**:

After `_try_scripted_pick` returns a result, mark a `scripted_pick: bool` flag in the local frame. Then change the auto-equip block from:

```gdscript
if AccountState.get_equipped(hero_id) == null:
    auto_equipped = AccountState.equip(hero_id, AccountState.owned_weapons.size() - 1)
    ...
```

to:

```gdscript
## Scripted pulls (Bug 1 targeted override): force-equip even if a starter
## already sits in the slot. RNG pulls keep current "go to bench if hero
## armed" behavior.
var force_equip: bool = scripted_pick
if force_equip or AccountState.get_equipped(hero_id) == null:
    auto_equipped = AccountState.equip(hero_id, AccountState.owned_weapons.size() - 1)
    if auto_equipped and hero != null:
        GameState.equip_weapon_data(hero_id, owned)
```

The `scripted_pick` local is set by:

```gdscript
var scripted_pick: bool = false
var catalog_pick = _try_scripted_pick(eligible)
if catalog_pick == null:
    catalog_pick = _weighted_pick(eligible)
else:
    scripted_pick = true
```

- [ ] **Step 4: Run — expect green.**

- [ ] **Step 5: Commit**

```bash
git add scripts/core/forge_wheel.gd scripts/dev/test_forge_wheel.gd
git commit -m "$(cat <<'EOF'
feat(forge-wheel): scripted pulls force-equip over non-elemental starters (B3)

Bug 1 targeted fix: scripted picks (_try_scripted_pick results)
override the auto-equip guard so the elemental reveal lands on the
target hero EVEN IF a non-elemental starter (B2) is already in the
slot. Without this, scripted pulls would silently go to bench; the
narrative beat (Bran reveals fire, Vex reveals electric, Elara reveals
ice) wouldn't land visually.

RNG pulls retain current behavior (go-to-bench when hero is armed) —
players still have agency over their organic loadout.

TestForgeWheel +1 case.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Chunk B acceptance gate

```
TestForgeWheel   — expect ~78/0 (was 73; +1 helios-pool-filter, +2 reshuffle, +1 force-equip)
TestAccountState — unchanged
TestCatalyst     — unchanged
... all others unchanged
```

---

## Chunk C — Combat scripted-wipe + Paladin descend + roster expansion

### Task C1: paladin_descend signal + scripted-wipe trigger logic

**Files:**
- Modify: `Prototype/godot/scripts/core/combat.gd`
- Modify: `Prototype/godot/scripts/dev/test_combat.gd`

- [ ] **Step 1: Add failing tests** to `test_combat.gd`:

```gdscript
func _test_paladin_defeat_trigger_at_50pct_hp() -> void:
	## C1: Arcane Lich crosses 50% HP -> scripted AOE wipes squad, sentinel
	## set, paladin_unlocked = true, Helios granted, paladin_descend emitted.
	GameState.new_session()
	AccountState.reset_account()
	AccountState.paladin_unlocked = false
	AccountState.scripted_pulls_seen = []
	## Manually set stage 3 + spawn lich at half HP.
	AccountState.current_stage = 3
	Combat.start_wave(5, false)   ## boss wave
	var lich = GameState.enemies[0]
	lich.hp = int(float(lich.max_hp) * 0.4)   ## already below 50%
	## Trigger the boss tick that contains the wipe logic.
	var wipe_emitted: bool = false
	Combat.paladin_descend.connect(func(): wipe_emitted = true, CONNECT_ONE_SHOT)
	Combat.step()   ## one tick — lich tick fires
	_check("paladin_descend signal emitted", wipe_emitted, "not emitted")
	_check("sentinel defeat_stage_3_paladin recorded",
		&"defeat_stage_3_paladin" in AccountState.scripted_pulls_seen,
		"seen=%s" % str(AccountState.scripted_pulls_seen))
	_check("paladin_unlocked true after trigger",
		AccountState.paladin_unlocked == true, "still false")
	_check("Helios Cleaver granted to Paladin",
		AccountState.get_equipped(&"paladin") != null and
		AccountState.get_equipped(&"paladin").id == &"w_helios_cleaver",
		"not equipped")
	## Verify all alive squad heroes are now dead.
	var alive_squad: int = 0
	for h in GameState.active_heroes():
		if h.id != &"paladin" and h.hp > 0:
			alive_squad += 1
	_check("scripted AOE killed all 3 deployed heroes", alive_squad == 0,
		"alive=%d" % alive_squad)
	Combat.stop()

func _test_paladin_defeat_skips_on_retry() -> void:
	## C1: Sentinel-guarded — second crossing of 50% HP (retry path) does NOT
	## re-fire the scripted AOE.
	GameState.new_session()
	AccountState.reset_account()
	AccountState.scripted_pulls_seen = [&"defeat_stage_3_paladin"]
	AccountState.paladin_unlocked = true
	AccountState.current_stage = 3
	Combat.start_wave(5, false)
	var lich = GameState.enemies[0]
	lich.hp = int(float(lich.max_hp) * 0.4)
	## squad heroes alive going in:
	var alive_before: int = 0
	for h in GameState.active_heroes():
		if h.id != &"paladin" and h.hp > 0:
			alive_before += 1
	Combat.step()
	var alive_after: int = 0
	for h in GameState.active_heroes():
		if h.id != &"paladin" and h.hp > 0:
			alive_after += 1
	_check("squad still alive on retry (scripted AOE skipped)",
		alive_after == alive_before,
		"alive before=%d after=%d" % [alive_before, alive_after])
	Combat.stop()

func _test_paladin_defeat_only_on_lich() -> void:
	## C1: Trigger gates on boss.id == &"boss_arcane_lich". Slime boss (stage 1)
	## crossing 50% HP must NOT fire the paladin descend.
	GameState.new_session()
	AccountState.reset_account()
	AccountState.paladin_unlocked = false
	AccountState.scripted_pulls_seen = []
	AccountState.current_stage = 1   ## slime
	Combat.start_wave(5, false)
	var slime = GameState.enemies[0]
	slime.hp = int(float(slime.max_hp) * 0.4)
	var emitted: bool = false
	Combat.paladin_descend.connect(func(): emitted = true, CONNECT_ONE_SHOT)
	Combat.step()
	_check("paladin_descend NOT emitted vs slime boss",
		not emitted, "emitted on wrong boss")
	_check("paladin still locked", AccountState.paladin_unlocked == false,
		"unlocked on wrong boss")
	Combat.stop()
```

- [ ] **Step 2: Run TestCombat — expect FAIL** (signal + logic don't exist yet).

- [ ] **Step 3: Modify combat.gd**:

Add `signal paladin_descend` at top with other signal declarations:

```gdscript
## Scripted-pacing-rework: emitted once when Stage 3 Arcane Lich crosses 50% HP
## with paladin not yet unlocked. main.gd listens + shows the descent cinematic.
signal paladin_descend
```

Add const near boss-tick helpers:

```gdscript
const PALADIN_DEFEAT_SENTINEL: StringName = &"defeat_stage_3_paladin"
```

Modify `_boss_tick_arcane_lich(idx, boss)` — at the very start of the function, call:

```gdscript
func _boss_tick_arcane_lich(idx, boss) -> void:
	_maybe_trigger_paladin_defeat(boss)
	if not boss.is_alive():   ## or whatever the existing alive check is — re-check after wipe
		return
	## ... existing phase 1 + phase 2 logic unchanged
```

Add helper:

```gdscript
func _maybe_trigger_paladin_defeat(boss) -> void:
	if PALADIN_DEFEAT_SENTINEL in AccountState.scripted_pulls_seen:
		return   ## already triggered; retry path proceeds normally
	if float(boss.hp) > float(boss.max_hp) * 0.5:
		return   ## haven't crossed the threshold yet
	## Record sentinel + unlock paladin + grant Helios + emit signal.
	AccountState.scripted_pulls_seen.append(PALADIN_DEFEAT_SENTINEL)
	AccountState.paladin_unlocked = true
	var helios = GameState.weapons_by_id.get(&"w_helios_cleaver")
	if helios != null:
		var owned = AccountState.acquire_weapon(helios)
		AccountState.equip(&"paladin", AccountState.owned_weapons.size() - 1)
		var paladin_h = GameState.get_hero(&"paladin")
		if paladin_h != null:
			GameState.equip_weapon_data(&"paladin", owned)
	AccountState.autosave()
	## Scripted overwhelming AOE: kill every alive deployed (non-paladin) hero.
	for h in GameState.active_heroes():
		if h.data.id != &"paladin":
			h.hp = 0
	emit_signal(&"paladin_descend")
```

- [ ] **Step 4: Run TestCombat — expect green** (3 new cases) + stage-1 neutrality contract unchanged (the new trigger is gated to lich, not slime).

- [ ] **Step 5: Commit**

```bash
git add scripts/core/combat.gd scripts/dev/test_combat.gd
git commit -m "$(cat <<'EOF'
feat(combat): Hot Paladin descend trigger on Stage 3 lich 50% HP (C1)

Per spec §7. Scripted-wipe one-shot trigger:
- Fires inside _boss_tick_arcane_lich when boss.hp <= 50% AND
  PALADIN_DEFEAT_SENTINEL (&\"defeat_stage_3_paladin\") not yet in
  AccountState.scripted_pulls_seen.
- Records sentinel + AccountState.paladin_unlocked = true.
- Grants Helios Cleaver to paladin slot via AccountState.acquire_weapon
  + equip.
- Overwhelming AOE kills every alive non-paladin hero (forces defeat).
- Emits Combat.paladin_descend (new signal). main.gd (C-chunk D3) wires
  the cinematic + retry flow.

Retry path: sentinel-guard short-circuits before AOE -> normal phase 2
plays through -> player wins with 4-roster-3-deploy.

Stage 1 neutrality contract preserved: slime boss never matches lich
trigger path.

TestCombat +3 cases (50%-HP trigger, retry skip, wrong-boss gate).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task C2: GameState roster expansion (4 heroes, paladin locked by default)

**Files:**
- Modify: `Prototype/godot/scripts/core/game_state.gd`
- Modify: `Prototype/godot/scripts/dev/test_home_screen.gd` OR a dedicated GameState roster test if one exists.

Read `game_state.gd` first to see current `ROSTER_IDS` shape (whether array constant, function-built list, .tres-driven).

- [ ] **Step 1: Add failing test** to confirm `active_heroes()` excludes paladin until unlocked:

```gdscript
func _test_active_heroes_excludes_locked_paladin() -> void:
	## C2: 4-hero roster, but active_heroes filters paladin when locked.
	AccountState.reset_account()
	AccountState.paladin_unlocked = false
	var active_ids: Array = []
	for h in GameState.active_heroes():
		active_ids.append(h.data.id)
	_check("active_heroes has 3 (bran/elara/vex)", active_ids.size() == 3,
		"size=%d ids=%s" % [active_ids.size(), str(active_ids)])
	_check("paladin NOT in active_heroes when locked",
		not (&"paladin" in active_ids), "leaked")
	## Now unlock and recheck:
	AccountState.paladin_unlocked = true
	active_ids = []
	for h in GameState.active_heroes():
		active_ids.append(h.data.id)
	_check("active_heroes has 4 after unlock", active_ids.size() == 4,
		"size=%d" % active_ids.size())
	_check("paladin IS in active_heroes after unlock",
		&"paladin" in active_ids, "missing")
```

- [ ] **Step 2: Run — expect FAIL.**

- [ ] **Step 3: Modify game_state.gd**:
- Add `&"paladin"` to ROSTER_IDS (or equivalent — read existing structure first).
- Update `active_heroes()`:
  ```gdscript
  func active_heroes() -> Array:
      var out: Array = []
      for id in ROSTER_IDS:
          if id == &"paladin" and not AccountState.paladin_unlocked:
              continue
          var h = heroes_by_id.get(id)
          if h != null:
              out.append(h)
      return out
  ```
- Update `fielded_classes()` similarly if it iterates the roster.

- [ ] **Step 4: Run — expect green.** Regression-check TestForgeWheel (since `fielded_classes()` is used in `eligible_weapons`).

- [ ] **Step 5: Commit**

```bash
git add scripts/core/game_state.gd scripts/dev/test_home_screen.gd
git commit -m "$(cat <<'EOF'
feat(roster): 4-hero roster gated on paladin_unlocked (C2)

GameState.ROSTER_IDS expands [&\"bran\", &\"elara\", &\"vex\"] -> adds
&\"paladin\". active_heroes() + fielded_classes() filter paladin out
when AccountState.paladin_unlocked == false.

Deploy still capped at 3 per CLAUDE.md §13 — Paladin becomes a 4th
roster slot the player rotates into the deployed squad. UI squad-
selection (D-chunk) presents 3-of-4 picker.

TestHomeScreen +1 case (locked/unlocked toggle).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task C3: Home squad row for Paladin (locked / unlocked toggle)

**Files:**
- Modify: `Prototype/godot/scripts/ui/home_screen.gd`
- Modify: `Prototype/godot/scripts/dev/test_home_screen.gd`

- [ ] **Step 1: Read home_screen.gd's _refresh_hero_rows / _refresh_squad_line** to understand the existing hero row render.

- [ ] **Step 2: Add failing test**:

```gdscript
func _test_home_paladin_row_locked_vs_unlocked() -> void:
	## C3: Pre-unlock, paladin row shows 🔒 Locked. Post-unlock, paladin row
	## renders with its equipped weapon details.
	AccountState.reset_account()
	AccountState.paladin_unlocked = false
	var hs = HomeScreenT.new()
	add_child(hs)
	hs._refresh()
	var pal_row: Button = hs._hero_rows.get(&"paladin")
	_check("paladin row exists in UI", pal_row != null, "missing")
	if pal_row != null:
		_check("locked paladin shows 🔒",
			pal_row.text.contains("🔒"), "text=%s" % pal_row.text)
	## Unlock and re-refresh:
	AccountState.paladin_unlocked = true
	hs._refresh()
	pal_row = hs._hero_rows.get(&"paladin")
	if pal_row != null:
		_check("unlocked paladin no longer shows 🔒",
			not pal_row.text.contains("🔒"), "text=%s" % pal_row.text)
	hs.queue_free()
```

- [ ] **Step 3: Run — expect FAIL.**

- [ ] **Step 4: Modify home_screen.gd**:
- Extend `ROSTER_IDS` const to include `&"paladin"`.
- In the row builder, add a locked-state branch:
  ```gdscript
  if id == &"paladin" and not AccountState.paladin_unlocked:
      row.text = "  🔒 Hot Paladin — locked"
      row.disabled = true
      continue   ## skip equipped-weapon decoration
  ```
- For squad-line, the existing `_refresh_squad_line` iterates `ROSTER_IDS`; locked paladin's `get_equipped` returns null → adds a `·` placeholder. Verify that's OK (no element icon).

- [ ] **Step 5: Run — expect green.**

- [ ] **Step 6: Commit**

```bash
git add scripts/ui/home_screen.gd scripts/dev/test_home_screen.gd
git commit -m "$(cat <<'EOF'
ui(home): Paladin row with locked/unlocked state (C3)

Per spec §8: home_screen ROSTER_IDS extends [&\"bran\",&\"elara\",&\"vex\",
&\"paladin\"]. Locked paladin renders \"🔒 Hot Paladin — locked\" with
disabled button. Unlocked paladin renders normally with the Helios
Cleaver equipped post-defeat.

Squad-line gets a 4th placeholder · when paladin locked (no element);
when unlocked + equipped, shows ☀ for light.

TestHomeScreen +1 case.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Chunk C acceptance gate

```
TestCombat       — expect ~76/0 (+3 new defeat-trigger cases)
TestHomeScreen   — expect ~21/0 (+2 from active_heroes test + paladin-row-locked)
TestForgeWheel   — unchanged
TestCatalyst     — unchanged
TestAccountState — unchanged
TestCatalystUI   — unchanged
TestWeaponData   — unchanged
```

---

## Chunk D — UI integration + retry flow + descend cinematic

### Task D1: Catalyst Codex renders 14 rows

**Files:**
- Modify: `Prototype/godot/scripts/dev/test_catalyst_ui.gd`

Codex code in `catalyst_codex.gd` already iterates `CatalystDataT.by_priority()` — A5 added 4 new compounds + priority order. So codex auto-renders 14 rows. Just rebaseline the test asserts.

- [ ] **Step 1: Update existing failing tests** in `test_catalyst_ui.gd`:

Find `_test_codex_lists_all_ten_compounds`. Rename to `_test_codex_lists_all_fourteen_compounds` + bump assert:

```gdscript
func _test_codex_lists_all_fourteen_compounds() -> void:
	## D1: post-A5, codex renders 14 rows (was 10).
	var c = CatalystCodexT.new()
	add_child(c)
	c.refresh([], 1)
	_check("codex shows 14 rows", c._list.get_child_count() == 14,
		"rows=%d" % c._list.get_child_count())
	_check("codex header shows 0 / 14 discovered",
		c._header.text.contains("0 / 14"), "header=%s" % c._header.text)
	c.queue_free()
```

Find `_test_codex_marks_discovered` and update its "1 / 10" → "1 / 14" assertion.

Find `_test_codex_rows_sorted_by_alpha_priority` — update the expected order to include 4 light compounds inserted in the alpha-correct positions (per A5).

- [ ] **Step 2: Run TestCatalystUI — expect green** after rebaselines (codex code unchanged, just larger compound count).

- [ ] **Step 3: Commit**

```bash
git add scripts/dev/test_catalyst_ui.gd
git commit -m "$(cat <<'EOF'
test(catalyst-ui): codex renders 14 rows post-A5 light compounds (D1)

Rebaselines TestCatalystUI codex assertions for the new 14-row total
(10 original + 4 light pairs from A5). codex code unchanged — A5's
extension of CatalystData.compounds() automatically grows the rendered
list.

Alpha-priority order asserts now expect: Auroral Veil > Blizzard >
Firestorm > Glacial Storm > Halo Bloom > Plasma > Plasma Arc >
Solar Flare > Stormfront > Wildfire > Earth quartet.

TestCatalystUI count unchanged (just rebaselined values).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task D2: Stage 3 Arcane Lich weak/resist telegraph

**Files:**
- Modify: `Prototype/godot/data/enemies/boss_arcane_lich.tres` (or wherever lich data lives)
- Modify: `Prototype/godot/scripts/dev/test_stage_affinity.gd` (or equivalent)

- [ ] **Step 1: Read `boss_arcane_lich.tres`** to find current `weak_tag` / `resist_tag`.

- [ ] **Step 2: Add failing test** to whichever test exercises stage 3 boss affinity. Or add to test_home_screen.gd's briefing test (since the briefing renders weak/resist):

```gdscript
func _test_stage_3_briefing_shows_light_weakness() -> void:
	## D2: Stage 3 boss (Arcane Lich) is weak to light pre-defeat — telegraphed
	## in the briefing dialog. Player has no light access (Helios is scripted-
	## grant only), so they walk in blind. Defeat -> Paladin descends with
	## Helios -> retry trivializes the boss.
	AccountState.reset_account()
	AccountState.current_stage = 3
	var hs = HomeScreenT.new()
	add_child(hs)
	hs._open_briefing()
	var body: String = hs._briefing.dialog_text
	_check("Stage 3 briefing mentions light weakness",
		body.contains("light") or body.contains("☀"),
		"body=%s" % body.left(300))
	hs.queue_free()
```

- [ ] **Step 3: Run — expect FAIL** (current lich .tres has different weak/resist).

- [ ] **Step 4: Modify boss_arcane_lich.tres**:

```
weak_tag = &"light"
resist_tag = &"earth"
```

- [ ] **Step 5: Run — expect green.**

- [ ] **Step 6: Commit**

```bash
git add data/enemies/boss_arcane_lich.tres scripts/dev/test_home_screen.gd
git commit -m "$(cat <<'EOF'
balance(boss): Arcane Lich weak = light, resist = earth (D2)

Per spec §8 + §11 (cold-telegraph locked): Stage 3 boss now telegraphs
weak: ☀ light · resist: 🪨 earth in the pre-stage briefing. Player has
no light access (Helios is scripted-grant only, granted post-defeat)
and earth is S10-gated. The player walks in blind, gets wiped at 50%
HP, watches Hot Paladin descend with Helios, retries and wins trivially.

Narrative payoff: \"the boss telegraphed light weakness; we couldn't
bring light; Paladin arrives with light; retry kills the boss easily.\"

TestHomeScreen +1 case.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task D3: Hot Paladin descend cinematic overlay

**Files:**
- Modify: `Prototype/godot/scripts/ui/main.gd`
- Modify: `Prototype/godot/scripts/dev/test_catalyst_ui.gd` (or a new test scene for the cinematic)

- [ ] **Step 1: Add failing test** to `test_catalyst_ui.gd`:

```gdscript
func _test_paladin_descend_cinematic_renders() -> void:
	## D3: main.gd::_on_paladin_descend instances the cinematic Control with
	## a TextureRect pointing at the paladin_entry.png. Test asserts the
	## handler exists + can be invoked without crashing.
	const MainT = preload("res://scripts/ui/main.gd")
	var m = MainT.new()
	add_child(m)
	## Invoke the handler synthetically.
	if m.has_method("_on_paladin_descend"):
		m._on_paladin_descend()
		_check("cinematic overlay visible after _on_paladin_descend",
			m._paladin_cinematic_overlay != null and m._paladin_cinematic_overlay.visible,
			"not visible")
	else:
		_check("main.gd has _on_paladin_descend handler", false, "missing")
	m.queue_free()
```

(May need to adjust based on whether main.gd auto-wires the cinematic on _ready or only after `_build_battle_overlay` runs.)

- [ ] **Step 2: Run — expect FAIL.**

- [ ] **Step 3: Modify main.gd**:

Add var:
```gdscript
var _paladin_cinematic_overlay: Control = null
```

Connect signal in `_build_battle_overlay` (after the catalyst banner + chip hooks):
```gdscript
Combat.paladin_descend.connect(_on_paladin_descend, CONNECT_DEFERRED)
```

Add handler:
```gdscript
## C-chunk D3: Hot Paladin descend cinematic. Full-screen image overlay +
## continue button. Fades in 0.6s, holds, fades out on Continue tap.
func _on_paladin_descend() -> void:
	Combat.stop()   ## freeze combat until player dismisses
	if _paladin_cinematic_overlay != null:
		_paladin_cinematic_overlay.queue_free()
	var overlay := Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.85)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(dim)
	var img := TextureRect.new()
	img.texture = load("res://assets/generated/cinematics/paladin_entry.png")
	img.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	img.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(img)
	var title := Label.new()
	title.text = "💎 HOT PALADIN DESCENDS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override(&"font_size", 28)
	title.set_anchors_preset(Control.PRESET_TOP_WIDE)
	title.offset_top = 40
	overlay.add_child(title)
	var sub := Label.new()
	sub.text = "Helios Cleaver — Light burns the lich."
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_font_size_override(&"font_size", 16)
	sub.modulate = Color(1, 1, 1, 0.85)
	sub.set_anchors_preset(Control.PRESET_TOP_WIDE)
	sub.offset_top = 80
	overlay.add_child(sub)
	var btn := Button.new()
	btn.text = "CONTINUE"
	btn.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	btn.offset_top = -80
	btn.pressed.connect(_dismiss_paladin_cinematic)
	overlay.add_child(btn)
	## Fade-in
	overlay.modulate = Color(1, 1, 1, 0)
	add_child(overlay)
	_paladin_cinematic_overlay = overlay
	var tw := create_tween()
	tw.tween_property(overlay, "modulate:a", 1.0, 0.6)

func _dismiss_paladin_cinematic() -> void:
	if _paladin_cinematic_overlay != null:
		_paladin_cinematic_overlay.queue_free()
		_paladin_cinematic_overlay = null
	## Route to retry-stage-3 flow — back to Home.
	get_tree().change_scene_to_file("res://scenes/Home.tscn")
```

- [ ] **Step 4: Run — expect green** (cinematic instantiates without crash).

- [ ] **Step 5: Commit**

```bash
git add scripts/ui/main.gd scripts/dev/test_catalyst_ui.gd
git commit -m "$(cat <<'EOF'
ui(catalyst): Hot Paladin descend cinematic overlay (D3)

Per spec §11b: main.gd::_on_paladin_descend builds a full-screen
cinematic overlay (dim + paladin_entry.png TextureRect + title +
subtitle + Continue button). Wired to Combat.paladin_descend signal
via CONNECT_DEFERRED.

Image source: assets/generated/cinematics/paladin_entry.png (copied
from Mockup/all-mockups/A13_paladin-entry_2E-ref.png).

Fade-in 0.6s, holds until Continue tap, dismisses + routes to Home
scene for retry-stage-3 flow (Chunk D4).

TestCatalystUI +1 case (handler instantiates + overlay renders).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Task D4: Stage 3 retry flow integration

**Files:**
- Modify: `Prototype/godot/scripts/ui/home_screen.gd`
- Modify: `Prototype/godot/scripts/dev/test_home_screen.gd`

- [ ] **Step 1: Add failing test** verifying that after paladin_unlocked == true, the Home start-battle button still routes to Stage 3 (since stage wasn't advanced by defeat) AND the briefing telegraphs the same light-weakness:

```gdscript
func _test_retry_stage_3_after_defeat() -> void:
	## D4: After paladin defeat: current_stage stays 3 (not advanced), paladin
	## is unlocked, Helios is equipped. Home start-battle routes to Stage 3
	## retry. Briefing same as pre-defeat (boss still telegraphs light weak;
	## now player CAN bring light via Paladin).
	AccountState.reset_account()
	AccountState.current_stage = 3
	AccountState.paladin_unlocked = true
	## Grant paladin's helios (simulate the defeat trigger having fired).
	var helios = GameState.weapons_by_id[&"w_helios_cleaver"].duplicate(true)
	AccountState.owned_weapons = [helios]
	AccountState.equip(&"paladin", 0)
	var hs = HomeScreenT.new()
	add_child(hs)
	hs._refresh()
	_check("battle button targets Stage 3", hs._battle_btn.text.contains("STAGE 3"),
		"text=%s" % hs._battle_btn.text)
	hs._open_briefing()
	var body: String = hs._briefing.dialog_text
	_check("retry briefing still shows light weak telegraph",
		body.contains("light") or body.contains("☀"),
		"body=%s" % body.left(300))
	hs.queue_free()
```

- [ ] **Step 2: Run — expect green** if no logic changes needed (Home already routes to `current_stage`; briefing reuses lich's weak/resist tags). If anything fails, fix the gap.

- [ ] **Step 3: If needed, add a defeat-state banner** on Home — e.g. a small "Stage 3 failed — Paladin awaits" line. Owner-tunable.

- [ ] **Step 4: Commit**

```bash
git add scripts/ui/home_screen.gd scripts/dev/test_home_screen.gd
git commit -m "$(cat <<'EOF'
ui(home): Stage 3 retry flow verified — paladin-armed re-attempt (D4)

Verifies the post-defeat retry path works end-to-end:
- AccountState.current_stage stays 3 (defeat does not advance).
- Paladin unlocked, Helios equipped (per C1's defeat trigger).
- Home start-battle button reads STAGE 3.
- Briefing still telegraphs weak: ☀ light · resist: 🪨 earth.
- Player now has light access via Paladin's Helios -> can deploy
  Paladin in the squad rotation (3-of-4 deploy).
- Combat retry hits the sentinel guard -> scripted AOE skipped ->
  normal phase 2 plays -> player wins.

TestHomeScreen +1 case (retry flow integration).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Chunk D acceptance gate

Full-suite regression. All 7 catalyst-touched test scenes green. Updated baseline targets:

```
TestCatalyst        — ~60/0 (+13 from A4+A5)
TestCatalystUI      — ~32/0 (D1 codex 14 + D3 cinematic)
TestAccountState    — ~102/0 (+4 A6 + +2 A7)
TestForgeWheel      — ~78/0 (+5 across B1/B2/B3)
TestHomeScreen      — ~24/0 (+6 across A3/C2/C3/D2/D4)
TestCombat          — ~76/0 (+3 from C1)
TestWeaponData      — 70/0 unchanged
```

Total catalyst-touched ~450 across 7 suites. Project-wide baseline ~580.

---

## STATUS.md + CLAUDE.md update (post-Chunk-D)

Final commit after Chunk D lands:

- Add new STATUS §3 DONE row for **Scripted-pacing-rework shipped (2026-06-10)** with commit range + test delta + v1.1 deferrals (full paladin kit, light-pair rich effects, cinematic motion design).
- Update STATUS §4 NEXT queue: remove or amend the original "#3 Hot Paladin scripted-defeat entry" line — that's now done.
- CLAUDE.md §4: bump test baseline ~540 → ~580.
- CLAUDE.md §7: save schema v5 → v6.
- CLAUDE.md §13: amend "Elements" to include light (FTUE post-defeat). Amend "Roster" line to note Paladin unlocks via Stage 3 boss defeat (was: "S2 cinematic"). Amend "Catalyst first reveal" to the new 3-pull schedule (#1 Bran fire / #3 Vex electric / #5 Elara ice). Update "Catalyst display-priority order" to include the 4 light compounds in their alpha positions.

Commit:

```bash
git add docs/STATUS.md ../../CLAUDE.md
git commit -m "$(cat <<'EOF'
docs(scripted-pacing): STATUS + CLAUDE updates for shipped (post-D)

[Full per-section change details follow]

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Self-Review

**1. Spec coverage:** every spec section maps to a chunk task:
- §1 Goal — captured in Architecture.
- §2 Scripted timeline — Chunk B (pulls) + Chunk C (defeat).
- §3 Light element + 4 compounds — A4 + A5.
- §4 New weapons — A1 (Voltedge) + A2 (Helios).
- §5 Paladin hero — A3.
- §6 SCRIPTED_GRANT_IDS — B1.
- §7 Combat scripted-wipe — C1.
- §8 Roster — C2 + C3.
- §9 AccountState v6 — A6.
- §10 Numbers Policy — every commit body notes starting-values per CLAUDE.md §8.
- §11 Owner-resolved decisions — folded into spec inline.
- §11a Economy bump — A7.
- §11b Cinematic asset — D3.
- §12 Out of scope — acknowledged.
- §13 Build sequencing — matches A/B/C/D chunks.
- §14 Acceptance — testable via the suite deltas.

**2. Placeholder scan:** no "TBD", "implement later", "fill in details" remaining. Every code block is complete.

**3. Type consistency:** sentinel StringName values (`pull_3_electric_rogue`, `pull_5_ice_mage`, `defeat_stage_3_paladin`) consistent across spec, plan, and commit messages. Compound ids (`solar_flare`, `halo_bloom`, `plasma_arc`, `auroral_veil`) consistent across CatalystData entries, tests, and priority order.

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-06-10-scripted-pacing-rework.md`. Two execution options per the writing-plans skill:

**1. Subagent-Driven (recommended)** — fresh subagent per task, two-stage review per task, fast iteration. Fits this 17-task plan well.

**2. Inline Execution** — execute tasks in this session with checkpoints.

Owner: which approach? Plan is ready to dispatch on either.
