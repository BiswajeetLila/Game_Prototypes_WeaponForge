# 6_WeaponForge_TFTransistor — Folder Rules

> Scope: these rules govern **only** `6_WeaponForge_TFTransistor/`. Sibling prototype folders are out of scope.

## Single Source of Truth (SSOT)

**SSOT = [`docs/01_GDD.md`](docs/01_GDD.md) + the Godot build in [`Prototype/godot/`](Prototype/godot/).**

- `docs/01_GDD.md` is the design SSOT. Everything in `docs/` either **is** the SSOT or is a spec that **points to** it.
- The **Godot build is authoritative for all current-state facts.** Where this doc and the build disagree on what is implemented, the build wins. Design intent not yet implemented is tagged **[ROADMAP]** in the GDD.
- **Current direction (locked 2026-06-12):** WeaponForge TFTransistor pivot — Function Matrix + 3-lane auto-runner + Magicka reactions. Full design + phasing in [`docs/01_GDD.md`](docs/01_GDD.md). Implementation contract in [`docs/superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md`](docs/superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md). Phase 4 (prototype-1) scope in [`docs/superpowers/specs/2026-06-13-phase4-vertical-slice-scope.md`](docs/superpowers/specs/2026-06-13-phase4-vertical-slice-scope.md). Pivot rationale (verbatim) in [`docs/superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`](docs/superpowers/specs/2026-06-12-fork-a-pivot-addendum.md).

## Active docs (forward work happens here)

| Path | Role |
|---|---|
| [`docs/01_GDD.md`](docs/01_GDD.md) | **THE SSOT.** Game pillars, core loop, hero roster, Function/reaction overview, pivot history, status of locked/ROADMAP/out-of-scope items. |
| [`docs/roadmap-2026-06-13.md`](docs/roadmap-2026-06-13.md) | **Roadmap** for the new direction. Phase-by-phase planning, timeline estimates, decision gates, risk register. Replaces the 2_WC roadmap (now HISTORICAL). |
| [`docs/story-beats-2026-06-13.md`](docs/story-beats-2026-06-13.md) | **Narrative beats** — wave-by-wave felt-experience script for FTUE world + subsequent worlds. Reference for art / audio / UX / playtest observation. Replaces the 2_WC story-beats (now HISTORICAL). |
| [`docs/superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md`](docs/superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md) | **Implementation contract** (REVIEW-3, awaiting LOCK). 36-cell Function × slot matrix, 15-reaction matrix, hero base weapons, 3-lane corridor rules, FTUE script, tier system T1-T5, Ults, wave telegraph, 26 locked decisions register. |
| [`docs/superpowers/specs/2026-06-13-phase4-vertical-slice-scope.md`](docs/superpowers/specs/2026-06-13-phase4-vertical-slice-scope.md) | **Phase 4 (prototype-1) scope.** Mission, in/out scope, build sequence, success/failure criteria, feedback plan. |
| [`docs/superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`](docs/superpowers/specs/2026-06-12-fork-a-pivot-addendum.md) | **Pivot rationale** (verbatim user addendum). Parent design doc — explains the "why" behind the Function Matrix + spatial-combat + Magicka pillars. Subordinate to 01_GDD now. |
| [`docs/superpowers/specs/grid-4x4-wittle-style.png`](docs/superpowers/specs/grid-4x4-wittle-style.png) | Reference image (interim 4×4 grid design now superseded by 3-lane auto-runner; kept as design-evolution artifact). |

Every active spec carries a "Subordinate to" or "SSOT" banner pointing at `01_GDD.md`. When a spec decision is finalised and reflected in the build, fold the fact into `01_GDD.md`.

## Historical docs (banner-marked, do NOT use for forward work)

All carry a `HISTORICAL` banner at the top pointing at the current SSOT + pivot rationale. They describe the previous `2_Weaponcraft_Godot` direction (anatomical Head/Hilt/Rune crafting + single-lane combat + recipe discovery). Kept for design archeology only — to be archived after Phase 3 spec lands LOCKED + Phase 4 slice freezes.

### High-level historical docs (`docs/`)

| Path | Role |
|---|---|
| [`docs/roadmap-2026-06-12.md`](docs/roadmap-2026-06-12.md) | 2_WC P0 → full game roadmap. Stale. |
| [`docs/story-beats.md`](docs/story-beats.md) | 2_WC P0 observable beats narrative. Stale. |

### Subsystem stubs (`docs/02_systems/`)

| Path | Role |
|---|---|
| [`docs/02_systems/art_direction.md`](docs/02_systems/art_direction.md) | 2_WC art direction stub. |
| [`docs/02_systems/pvp_arena.md`](docs/02_systems/pvp_arena.md) | 2_WC PvP arena stub (Month-9 roadmap target). |
| [`docs/02_systems/onboarding.md`](docs/02_systems/onboarding.md) | 2_WC onboarding stub. References Mage/Rogue scripted unlocks now superseded by REVIEW-3 FTUE script. |
| [`docs/02_systems/audio.md`](docs/02_systems/audio.md) | 2_WC P0 audio direction (Wittle/Cookie-Run register). Direction may inform Phase 5 sound but content references parts/recipes/craft moments that died. |
| [`docs/02_systems/combat_math.md`](docs/02_systems/combat_math.md) | 2_WC combat math stub (Hero Level +5%/lvl). Hero-level direction informs Wittle-meta Phase 5 spec. |

### Content scaffolds (`docs/03_content/`)

| Path | Role |
|---|---|
| [`docs/03_content/characters.md`](docs/03_content/characters.md) | 2_WC 9-12 hero roster scaffold. Bran/Elara/Vex carry into REVIEW-3 (with new lane-locked identities). Roster size + Mastery system stale. |
| [`docs/03_content/parts.md`](docs/03_content/parts.md) | 2_WC ~30 parts catalogue (Head/Hilt/Rune). **Entirely dead** — Functions replace parts. |
| [`docs/03_content/recipes.md`](docs/03_content/recipes.md) | 2_WC ~200 discoverable recipes codex. **Entirely dead** — Function Matrix replaces recipes. |
| [`docs/03_content/boss_affinities.md`](docs/03_content/boss_affinities.md) | Boss affinity taxonomy stub. Maps partially to REVIEW-3 wave telegraph weakness/resistance but model itself is stale. |

### Economy stubs (`docs/04_economy/`)

| Path | Role |
|---|---|
| [`docs/04_economy/currency.md`](docs/04_economy/currency.md) | 2_WC 4 launch currencies. Gold + Hero Shards + Hero XP carry into REVIEW-3 + Phase 5 Wittle-meta direction. |
| [`docs/04_economy/stamina.md`](docs/04_economy/stamina.md) | 2_WC P1 stamina gate. Maps to Phase 5+ Wittle-meta. |
| [`docs/04_economy/battle_pass.md`](docs/04_economy/battle_pass.md) | Live-ops battle pass stub. Phase 5+ Wittle-meta. |
| [`docs/04_economy/cosmetics.md`](docs/04_economy/cosmetics.md) | Cosmetic taxonomy stub. Phase 5+ Wittle-meta. |

### Historical specs (`docs/superpowers/specs/`)

| Path | Role |
|---|---|
| [`docs/superpowers/specs/2026-06-11-hero-squad-meta-design.md`](docs/superpowers/specs/2026-06-11-hero-squad-meta-design.md) | 2_WC hero-squad meta direction (locked 2026-06-11, superseded 2026-06-12). |
| [`docs/superpowers/specs/2026-06-12-retention-arc-d1-d20.md`](docs/superpowers/specs/2026-06-12-retention-arc-d1-d20.md) | 2_WC D1-D20 retention narrative. Stale. |
| [`docs/superpowers/specs/2026-06-12-greenlight-pitch.md`](docs/superpowers/specs/2026-06-12-greenlight-pitch.md) | 2_WC CEO greenlight pitch. Stale. |

### P0 implementation plans (`docs/superpowers/plans/`)

These are historical implementation plans for the **shipped 2_WC P0 build** (at `fbe426d`). Do NOT re-execute — they describe how to build dying gameplay. Listed for archeology + because parts of the meta layer they shipped (account_state, hero_progress, home, modals, pull_overlay) survive into REVIEW-3 unchanged.

| Path | Role |
|---|---|
| [`docs/superpowers/plans/2026-06-12-p0-hero-progression-foundation.md`](docs/superpowers/plans/2026-06-12-p0-hero-progression-foundation.md) | P0 progression engine (hero_progress + account_state autoloads). SHIPPED. Carries into REVIEW-3 meta layer unchanged. |
| [`docs/superpowers/plans/2026-06-12-p0-wiring.md`](docs/superpowers/plans/2026-06-12-p0-wiring.md) | P0 wiring of hero levels into 2_WC live combat. SHIPPED. Combat layer rewrites in Phase 5; meta layer hooks survive. |
| [`docs/superpowers/plans/2026-06-12-p0-home-squad.md`](docs/superpowers/plans/2026-06-12-p0-home-squad.md) | P0 Home + squad-select implementation. SHIPPED. Home.tscn + home.gd survive into REVIEW-3 unchanged. |
| [`docs/superpowers/plans/2026-06-12-p0-slice-beats.md`](docs/superpowers/plans/2026-06-12-p0-slice-beats.md) | P0 Result modal + scripted Vex pull + scout intel + juice. SHIPPED. PullOverlay reused for REVIEW-3 FTUE Bran/Vex cinematics; scout_intel data path revived as REVIEW-3 wave telegraph. |

## `_archive/` — historical, reference-only

**`_archive/` MUST NOT be used for forward work.** Inherited from 2_WC P0 seed. Contains the abandoned Wittle-inversion weapon-gacha fork (that direction continues as the separate `5_WeaponForge_Honkai_Godot` project — different commercial bet, no overlap with this folder), old session handoffs, mockups, and beat-renders. If something is needed, promote a clean copy into `docs/` and reconcile to current SSOT first.

## Pivot phases (current status)

Full plan: `C:\Users\Biswa\.claude\plans\weaponcraft-game-design-fuzzy-llama.md`. Companion handoff: [`HANDOFF.md`](HANDOFF.md).

| Phase | What | Status |
|---|---|---|
| −1 | Debug reset button on 2_WC Home | ✅ shipped in 2_WC `fbe426d` |
| 0 | Snapshot 2_WC P0 (tag + freeze branch) | ✅ tag `2_WC/p0-shipped-2026-06-12`, branch `2_WC/frozen-shipped-p0` |
| 1 | Seed `6_/` (bulk copy from 2_WC) | ✅ commit `4894108` on `weaponforge-tftransistor/seed-from-2wc` |
| 2 | Redirect SSOT + freeze markers (initial pass) | ✅ commit `d212469` |
| 3 | Lock Function catalog + status reaction matrix spec | 🟡 REVIEW-3 awaiting LOCK sign-off, `6e386a4` |
| 3.5 | Full doc tree consolidation (this commit) | 🟡 in-progress |
| 4 | Vertical slice (prototype-1) | ⏳ pending Phase 3 LOCK |
| 5 | Full rewrite (~5-7 weeks) | ⏳ pending Phase 4 feel-gate |
| 5+ | Wittle-clone meta-progression spec + impl | ⏳ separate spec doc, post-Phase-4 |

## Surviving meta layer (ports unchanged into REVIEW-3)

These work, are tested, and survive the pivot. Do NOT gratuitously refactor:

- `Prototype/godot/scripts/core/account_state.gd`, `hero_progress.gd` (schema v2 + v1 migration; v3 in Phase 4 adds `ftue_complete` bool)
- `Prototype/godot/scripts/data/hero_state.gd`, `hero_data.gd`, `inventory_item.gd`
- `Prototype/godot/scenes/Home.tscn` + `scripts/ui/home.gd` (incl. debug reset button)
- `Prototype/godot/scenes/ResultModal.tscn` + `scripts/ui/result_modal.gd`
- `Prototype/godot/scenes/PullOverlay.tscn` + `scripts/ui/pull_overlay.gd` (reused for FTUE Bran/Vex cinematics)
- `Prototype/godot/scripts/ui/main.gd`, `hud.gd`, `squad_bar.gd`, `notifications.gd`, `reforge_retry_modal.gd`
- `Prototype/godot/scripts/dev/test_progression.gd` (58 tests)
- `Prototype/godot/scripts/dev/screenshot_helper.gd` (AUTOSHOT)
- TDD harness pattern: `Test*.tscn` + `_check` + headless quit

## Dying gameplay core (do NOT extend in design-spec branch or Phase 4)

These files exist only because the seed was a bulk copy. They die in Phase 5; do not add features, fix non-blocking bugs, or invest in their tests in this branch. Phase 4 builds `_v2` versions alongside; Phase 5 replaces the originals.

- Core: `combat.gd` (rewrite as `combat_v2.gd` for lane-runner), `shop.gd` (rewrite as `shop_v2.gd` for 7-slot slow-populate), `recipes.gd` (delete), `merge.gd` (slot-rename survives ~80%), `weapon.gd` (rewrite)
- Data: `part_data.gd` (delete), `recipe_data.gd` (delete), `data/parts/*.tres`, `data/recipes/*.tres`
- UI: `battle_view.gd` (rewrite as `battle_view_v2.gd` for 3-lane), `forge_panel.gd` (rewrite as `forge_panel_v2.gd` for 7-slot + bottom rail), `part_card.gd` (rewrite as Function card), `codex_modal.gd` (delete or repurpose), `discovery_overlay.gd` (rewrite)
- Tests: `test_recipes.gd`, `test_shop.gd`, `test_merge.gd` (rewrite); `test_combat.gd` (~50% rewrite). Existing passes validate the dying game, not the new direction.

## Non-collision with sibling folders

- **`2_Weaponcraft_Godot/`** — FROZEN 2026-06-12. Shipped P0 build (lane combat + hero-squad meta + scripted pull + scout + debug reset). Forward work has moved here. Returning to 2_WC later remains possible (folder + branches don't move) but is a deliberate fork-back, not a default. Only edit allowed in 2_WC: the FROZEN banner in its CLAUDE.md (already done in Phase 2).
- **`5_WeaponForge_Honkai_Godot/`** — separate weapon-gacha + Honkai-style narrative + lane combat prototype. Different commercial bet. No code or design overlap with this folder; no shared assets except possibly raw character refs.

## Engine / run

- Godot **4.6** Mono. Project: `Prototype/godot/project.godot` (`config/name` = "WeaponForge TFTransistor Prototype").
- Run: F5 from editor; main scene `scenes/Main.tscn` (still wired to the dying combat loop — Phase 4 wires a new `BattleView_v2.tscn`).
- Headless test sweep:
  ```
  C:\Godot_v4.6.2-stable_mono_win64\Godot_v4.6.2-stable_mono_win64_console.exe --headless --path <project_path> res://scenes/dev/<Scene>.tscn
  ```
  Exit code = failure count. Last green sweep = 210/210 (TestProgression 58 + TestWeaponData 10 + TestCombat 55 + TestMerge 22 + TestRecipes 18 + TestShop 26 + TestUi 21).
- `WC_AUTOSHOT` non-interactive screenshot tool (`screenshot_helper.gd`) ports as-is — useful for visual QC.
- `.import` autosave churn is noise — discard, don't commit.
