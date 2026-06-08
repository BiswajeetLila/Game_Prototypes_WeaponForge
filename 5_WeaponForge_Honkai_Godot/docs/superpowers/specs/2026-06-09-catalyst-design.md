# Catalyst v1 — Design Spec

**Status:** locked design, not yet built (Chunks A/B/C below).
**Branch:** `forgeloop/catalyst-element-pairs`.
**Author:** owner + Claude (brainstorm 2026-06-09).
**Supersedes:** the placeholder Catalyst section in
`2026-05-27-wittle-inversion-design.md §catalyst` for v1 scope.
**v2 is out of scope here** (richer per-compound effects — see §10).

---

## 1. Goal

Add an **element-pair synergy** layer over the existing squad loadout so
that the *strategic* slice of combat (pre-stage equip) gains a second
axis besides counter-build. The pre-stage briefing already telegraphs
boss / minion weak+resist (counter-build axis 1). Catalyst is axis 2.

The bet is twofold:

- **Squad-puzzle motivation.** Pulling weapons doesn't matter unless
  the *combination* of equipped weapons matters. Catalyst gives the
  player a reason to swap weapons across heroes beyond raw ATK.
- **Pacing.** Catalyst is the third progression axis to unlock during
  FTUE (after pulls + counter-build), aligned with the
  `2026-06-06-progression-economy-architecture.md §18 "≤4 concurrent"`
  rule — older axes routinize, new axis takes the foreground.

---

## 2. Scope of v1 — MVP-6 simple

Six FTUE-reachable element-pair compounds, each implemented as a
**simple stat-modifier bag** (no new combat callbacks). The four
Earth-pair compounds are wired into data but **dormant until Stage 10**
(per the existing Earth gate in the design spec).

| Pair | Compound | v1 effect (Numbers Policy starting values) |
|---|---|---|
| Fire + Ice | **Firestorm** | +20% squad ATK |
| Fire + Wind | **Wildfire** | +15% squad ATK · +10% squad crit |
| Fire + Electric | **Plasma** | +15% squad crit |
| Ice + Wind | **Blizzard** | −20% enemy attack speed |
| Ice + Electric | **Glacial Storm** | +15% squad ATK |
| Wind + Electric | **Stormfront** | +25% squad ATK *when ≥3 enemies alive* |
| Fire + Earth | Volcanic (🔒 S10) | +30% squad ATK *(v1 placeholder; v2 adds −20% self move speed)* |
| Ice + Earth | Permafrost (🔒 S10) | +15% squad ATK *(v1 placeholder; v2 = root enemies 2s on heavy hit)* |
| Wind + Earth | Sandstorm (🔒 S10) | +15% squad ATK *(v1 placeholder; v2 = −30% enemy accuracy)* |
| Earth + Electric | Magnetic Storm (🔒 S10) | +15% squad ATK *(v1 placeholder; v2 = pull-cluster + 50% AoE)* |

**MVP-6 simple rationale:** validates the "does picking squad-for-compound
*matter*?" question cheaply. If yes → upgrade selected compounds to v2
rich effects (chain lightning, freeze cones, DoT spread). If no →
reconsider before building primitives.

---

## 3. Modifier-bag shape (the uniform interface)

Combat consumes a single dictionary at battle start. All six v1
compounds reduce to four keys:

```gdscript
const EMPTY_BAG: Dictionary = {
    &"squad_atk_mult":        1.0,   # Firestorm / Wildfire / Glacial Storm / Volcanic-placeholders
    &"squad_crit_add":        0.0,   # Plasma / Wildfire
    &"enemy_atk_speed_mult":  1.0,   # Blizzard
    &"squad_atk_vs_swarm_mult": 1.0, # Stormfront (gates on Combat.alive_enemy_count() >= 3)
}
```

Composition: multiplicative for `*_mult` keys, additive for `*_add`
keys. No-cap stacking (stage 5+) folds all triggering bags through this
reducer.

**Why this shape:** zero new combat callbacks. Combat reads the bag
once during `start_wave()` and applies it to the per-hero ATK / crit /
ASpd outputs. The fifth field (`squad_atk_vs_swarm_mult`) is the only
non-uniform handler — gated by an alive-enemy-count check.

---

## 4. Trigger condition

A compound triggers when **two distinct equipped weapon elements
present in the deployed squad match a defined pair**.

- Equipped weapon element = `hero.weapon_data.rune` (the existing field).
- Non-elemental starter weapons have `rune = &""` and never count.
- Earth-gated compounds skip if `current_stage < 10`.

A 3-different-elements squad (e.g. Bran-Fire, Elara-Ice, Vex-Wind)
triggers C(3,2) = 3 compounds simultaneously *if* stage ≥ 5; if stage
≤ 4, cap-1 selects one.

---

## 5. Stacking rule

- **Stages 1-4:** **cap-1**. The first compound by **alphabetical
  COMPOUND name** wins:
  Blizzard > Firestorm > Glacial Storm > Plasma > Stormfront > Wildfire.
  Deterministic, easy to doc. (Earth-pair names insert in this order at
  S10+ unlock: Magnetic Storm > Permafrost > Sandstorm > Volcanic.)
- **Stages 5+:** **no-cap**. All triggering compounds active; bags
  compose multiplicatively.
- Earth-gated compounds skip entirely if stage < 10, regardless of cap.

**Why cap-1 FTUE:** simpler onboarding. The player sees ONE compound
named on screen, learns what it does, then unlocks stacking once the
basic loop is internalized.

---

## 6. Scripted-starter pull strategy

Catalyst depends on the player having at least two distinct elemental
weapons. With the design spec's "Bran/Elara/Vex pre-equipped with
distinct elements" rule, every stage 1 fight would trigger a Catalyst
from W1, breaking the stage-1 neutrality contract.

**Fix (owner-approved 2026-06-09):**

- All 3 starter weapons become **non-elemental** (`rune = &""`).
  Existing starter `.tres` files updated.
- **Forge Wheel scripted pull #1** = guaranteed Fire weapon, Bran-class
  (Warrior).
- **Forge Wheel scripted pull #3** = guaranteed Ice weapon, Elara-class
  (Mage).
- Pull #2 + pull ≥4 = normal RNG.
- Reveal moment lands ~stage 4-5 if the player pulls once per stage.

Account state gets a new field `scripted_pulls_seen: Array[StringName]`
(persisted) to track which scripts have fired (idempotent across
restarts and resets).

**Why this is good:** preserves the stage-1 neutrality contract (no
catalyst possible w/ non-elemental starters), teaches one element at a
time, gives the player a *named moment* when the first Catalyst
triggers (Beat 9.1 in `prototype-screen-beats.md`).

---

## 7. UI surfaces

Four touchpoints across home + battle:

### 7.1 Home — squad-elements line (already exists, upgrade)

`home_screen.gd` already shows "Squad elements: 🔥 ❄ ⚡". Upgrade to
also show the active Catalyst compound name when ≥2 distinct elements
are present:

```
Squad elements:  🔥  ❄  ⚡
💠 Catalyst: Firestorm  (+20% squad ATK)
```

Hidden when the squad has 0 or 1 distinct elements (pre-reveal state).

### 7.2 Pre-stage briefing — second axis

The existing briefing dialog gets a `💠 ACTIVE CATALYST` section listing
all currently active compounds (1 in cap-1 mode, 1-3 in no-cap mode).

### 7.3 Battle — start banner

Once per stage-start, after the existing `🏰 STAGE N` banner, fade in:

```
💠 FIRESTORM CATALYST ACTIVE
🔥+❄  +20% squad ATK
```

1.2s, then fades. Owner-approved (Q4, 2026-06-09).

### 7.4 Battle — persistent HUD chip

A small icon-pair chip in the top-right of the battle view stays for
the duration of the stage. Tap = expanded description overlay.

In no-cap mode, the chip stacks vertically (max 3 visible compounds).

### 7.5 Catalyst Codex (new sub-screen)

A discovery-driven codex listing all 10 compounds. Discovered = the
compound has triggered at least once on this account. Persisted as
`account.catalyst_codex_discovered: Array[StringName]`.

```
CATALYST CODEX — 3 / 10 discovered
🔥+❄  Firestorm     +20% squad ATK    ★
🔥+🌪 Wildfire      +15% ATK +10% crit ★
…
🔥+🪨 Volcanic      …                  🔒 S10
```

Tap a compound entry → modal with full description. Codex completion
itself is not a reward axis in v1 (deferred); just a discovery surface.

---

## 8. Architecture

Three new files; minimal touches to existing.

```
scripts/data/catalyst_data.gd          (pure data class)
scripts/core/catalyst_resolver.gd      (pure static resolver)
scripts/ui/catalyst_codex.gd           (new home sub-screen — optional in v1)
shaders / scenes                       (UI surfaces in existing files)
```

### 8.1 `catalyst_data.gd`

```gdscript
class_name CatalystData
extends RefCounted

## Returns the canonical 10-record table.
## Each record: { pair_key, elements[2], display_name, modifier_bag,
##                gated_from_stage, alphabetical_priority }
static func compounds() -> Array: ...

## Order-independent pair lookup. Returns the record or {}.
static func for_pair(a: StringName, b: StringName) -> Dictionary: ...

## Sorted by alphabetical_priority (for cap-1 tie-break).
static func by_priority() -> Array: ...
```

### 8.2 `catalyst_resolver.gd`

```gdscript
class_name CatalystResolver
extends RefCounted

## Returns the active-compound state given the squad + stage.
##
##   stage <= 4 (cap-1)  -> {compound: record | null, merged_bag: bag}
##   stage >= 5 (no-cap) -> {compounds: [record1, ...], merged_bag: bag}
##
## Empty-element entries in squad_weapons are skipped.
## Earth-gated compounds skip when stage < 10.
static func resolve(squad_weapons: Array, stage: int) -> Dictionary: ...
```

### 8.3 Combat hook (in existing `combat.gd`)

`Combat.start_wave()` calls `CatalystResolver.resolve(squad, stage)` once
and stores `merged_bag` on `Combat._catalyst_bag`. Per-hero ATK / crit /
attack-speed read multiply/add through the bag in their existing getters.

`squad_atk_vs_swarm_mult` is applied conditionally inside the
hit-resolution path when `Combat.alive_enemy_count() >= 3`.

### 8.4 Home + battle UI (existing files)

- `home_screen.gd::_refresh_squad_line()` — upgrade to include catalyst
  name + effect string.
- Existing `_briefing` dialog body — append a Catalyst section.
- New `scripts/ui/catalyst_banner.gd` — short scene that plays the
  start-of-stage banner. Reused by `main.gd::_build_battle_overlay()`.
- New `scripts/ui/catalyst_chip.gd` — persistent HUD chip; added to the
  CanvasLayer in `main.gd::_build_battle_overlay()`.

### 8.5 Account state

`AccountState` v4 → v5:

- `+ scripted_pulls_seen: Array[StringName]` (default `[]`)
- `+ catalyst_codex_discovered: Array[StringName]` (default `[]`)
- Migration `_migrate_v4_to_v5()` fills both with empty arrays for old saves.

Starter weapons in the bootstrap grant get `rune = &""` (was Fire / Ice /
Wind per spec — now non-elemental).

---

## 9. Test plan

Three test scenes; all self-quitting where possible.

### 9.1 `TestCatalyst.tscn` + `test_catalyst.gd` (new, self-quitting)

| # | Case |
|---|------|
| C-1 | `compounds()` returns 10 records (6 active + 4 Earth-gated) |
| C-2 | `for_pair(fire, ice) == for_pair(ice, fire) == Firestorm` |
| C-3 | `for_pair(&"", ice)` returns `{}` (empty element skipped) |
| C-4 | `resolve` with 2-basic-1-fire squad at stage 1 returns null compound, EMPTY_BAG |
| C-5 | `resolve` with fire+ice+wind squad at stage 1 returns **Blizzard** (alpha-by-compound-name priority — see §5) |
| C-6 | `resolve` with fire+ice+wind squad at stage 5 returns 3 compounds, multiplicative bag |
| C-7 | Earth-pair at stage 9 → skipped; at stage 10 → triggers |
| C-8 | Three-same-element squad → null compound |
| C-9 | Merged-bag math: 1.2 × 1.15 = 1.38, additive crit 0.10 + 0.15 = 0.25 |
| C-10 | Cap-1 alphabetical priority: 3-different squad at stage 4 returns Blizzard |
| C-11 | Stormfront swarm-mult applies only when `alive_enemies >= 3` (mocked) |

### 9.2 `TestAccountState.tscn` (extend)

- Save v4 → v5 migration: load a v4 dict, verify
  `scripted_pulls_seen == []` and `catalyst_codex_discovered == []`.

### 9.3 `TestForgeWheel.tscn` (extend)

- Pull #1 on a fresh account → Fire weapon, Bran-class.
- Pull #3 on a fresh account → Ice weapon, Elara-class.
- Pull #2, #4+ → RNG (deterministic seed test).
- Scripted pulls are idempotent: `scripted_pulls_seen` tracks them.

### 9.4 `TestCombat.tscn` (regression)

- **Stage-1 neutrality contract.** Non-elemental starters means no
  Catalyst possible on stage 1 → bag = EMPTY_BAG → combat math
  identical to today. All 65 existing assertions stay green.

### 9.5 `TestHomeScreen.tscn` (extend)

- Squad-elements line hides Catalyst when 0 / 1 elements.
- Squad-elements line shows Catalyst name when ≥2 distinct + a pair matches.

---

## 10. Out of scope (Catalyst v2 + later)

- Per-compound rich effects (chain lightning, freeze cone, DoT spread,
  splash AOE, stun on hit, root on heavy hit, accuracy debuff,
  pull-cluster). Wait on the felt-need signal from MVP-6 playtest.
- Earth-pair v2 effects (4 compounds, S10+ — placeholder bag-effects
  for v1 are intentionally generic).
- Codex completion rewards (e.g. +0.5% acc-wide damage per discovered;
  see design spec §x "Recipe Codex").
- Catalyst-aware enemies (boss reads squad-elements, debuffs the active
  compound). Future PvP / hard-mode hook.
- Trademark fallback rename (USPTO/EUIPO check pending — fallback names
  Alloy / Confluence / Reaction / Harmonic ready in §11 of `CLAUDE.md`).

---

## 11. Numbers — STARTING values

Per Numbers Policy (§8 of `CLAUDE.md`), every number below is a starting
value to be tuned via playtest, not a final balance call.

- Firestorm +20% ATK
- Wildfire +15% ATK · +10% crit
- Plasma +15% crit
- Blizzard −20% enemy attack speed
- Glacial Storm +15% ATK
- Stormfront +25% ATK (gated on ≥3 alive enemies)
- Earth-pair placeholders +15% ATK each

If any compound feels flat in playtest → tune the number, NOT the
architecture. Architecture change (modifier-bag → rich callback) is
a v2 conversation.

---

## 12. Build sequencing (the three chunks)

The implementation plan (next doc, via `superpowers:writing-plans`) will
break this into the three chunks brainstormed in chat:

- **Chunk A — Core.** `catalyst_data.gd`, `catalyst_resolver.gd`,
  `TestCatalyst.tscn`. No game-side effect. ~10 tests.
- **Chunk B — Integrations.** Starter-weapon rework (non-elemental),
  Forge Wheel scripted pulls #1 + #3, Account v4→v5 migration, Combat
  bag-hook. ~5 tests across TestAccountState / TestForgeWheel /
  TestCombat regression.
- **Chunk C — UI.** Home squad-elements upgrade, briefing-panel
  Catalyst section, battle-start banner, persistent HUD chip, Catalyst
  Codex sub-screen. ~5 tests in TestHomeScreen + a new TestCatalystUI.

Each chunk = its own RED→GREEN cycle. Commit after each chunk. Owner
playtests after Chunk C lands.

---

## 13. Open questions (for owner review)

- **Catalyst Codex sub-screen** — included in v1 (a separate Home tab)
  or deferred to v2? Current spec includes it but it's the most-cuttable
  feature if scope tightens.
- **Stormfront swarm threshold** — `>=3 enemies` is a guess. Tune in
  playtest. (Numbers Policy says it's fine to start here.)
- **Pre-stage briefing — show ALL active compounds, or only the top
  effect?** Current spec shows all (no-cap mode). Could feel busy on
  3-compound squads; tune visually after Chunk C.

---

## 14. Acceptance

A reviewer of this spec should be able to:

- name the 6 FTUE compounds and their starting effects;
- explain when the player first sees a Catalyst (pull #3 lands Ice-Elara);
- explain what happens on a 3-different-elements squad at stage 4 vs 5;
- locate the modifier-bag shape (§3) and the migration step (§8.5);
- find the test that proves stage-1 stays neutral (§9.4).

If any of those is unclear, this spec needs a revision pass before the
implementation plan starts.
