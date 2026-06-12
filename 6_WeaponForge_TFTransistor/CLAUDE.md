# 6_WeaponForge_TFTransistor — Folder Rules

> Scope: these rules govern **only** `6_WeaponForge_TFTransistor/`. Sibling prototype folders are out of scope.

## What this folder is

The **WeaponForge TFTransistor pivot** — a different game built on the bones of the shipped `2_Weaponcraft_Godot` P0 build. New direction (locked 2026-06-12):

- **Combat:** compact spatial grid (3×3 player + 3×3 enemy mirrored, v1) replacing the single-lane brawler.
- **Crafting:** Transistor-style **Function Matrix** — three universal sockets per hero (Active / Modifier / Passive) holding atomic Functions (`FIRE`, `AOE`, `LEECH`, etc.) that behave differently in each socket.
- **Element layer:** Magicka-style cross-hero status reactions (`LIGHTNING × Wet → Electrocute`, `FIRE × Chilled → Steam`, etc.).
- **Economy:** TFT-style 5-slot drafting shop with rerolls + L1→L5 auto-merges (carried from prior direction, slot rename only).

~64% of the previous `2_Weaponcraft_Godot` gameplay code dies in the rewrite; the meta layer (account/hero progression, home, modals, save schema) ports unchanged.

## Single Source of Truth (SSOT)

**Current SSOT = [`docs/superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`](docs/superpowers/specs/2026-06-12-fork-a-pivot-addendum.md)** (the user's pivot addendum, verbatim).

Once **Phase 3** lands `docs/superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md` (locked Function catalog + status reaction matrix), that doc becomes the SSOT for implementation; the addendum stays as the parent design rationale.

The shipped Godot build wins on current-state facts only for the **surviving meta layer** (see below). Everything in the dying gameplay core is *not authoritative* for forward work — it's reference for what gets removed in Phase 5.

## Pivot phases

Full plan: `C:\Users\Biswa\.claude\plans\weaponcraft-game-design-fuzzy-llama.md`.

| Phase | What | Status |
|---|---|---|
| −1 | Debug reset button on 2_WC Home | ✅ shipped in `fbe426d` |
| 0 | Snapshot 2_WC P0 (tag + freeze branch) | ✅ tag `2_WC/p0-shipped-2026-06-12`, branch `2_WC/frozen-shipped-p0` |
| 1 | Seed `6_/` (bulk copy from 2_WC) | ✅ commit `4894108` on `weaponforge-tftransistor/seed-from-2wc` |
| 2 | Redirect SSOT + freeze markers (this commit) | 🟡 in progress |
| 3 | Lock Function catalog + status reaction matrix spec | ⏳ pending |
| 4 | Vertical slice (3×3 grid, 3 Functions, 2 statuses, 1 reaction) | ⏳ pending |
| 5 | Full rewrite (~5–7 weeks) | ⏳ pending; planned after Phase 4 feel-gate |

## Surviving meta layer (ports unchanged)

Do not gratuitously refactor these — they work and are tested:

- `Prototype/godot/scripts/core/account_state.gd`, `hero_progress.gd` (schema v2 + v1 migration)
- `Prototype/godot/scripts/data/hero_state.gd`, `hero_data.gd`, `inventory_item.gd`
- `Prototype/godot/scenes/Home.tscn` + `scripts/ui/home.gd` (+ debug reset button)
- `Prototype/godot/scenes/ResultModal.tscn` + `scripts/ui/result_modal.gd`
- `Prototype/godot/scenes/PullOverlay.tscn` + `scripts/ui/pull_overlay.gd`
- `Prototype/godot/scripts/ui/main.gd`, `hud.gd`, `squad_bar.gd`, `notifications.gd`, `reforge_retry_modal.gd`
- `Prototype/godot/scripts/dev/test_progression.gd` (58 tests)
- TDD harness pattern: `Test*.tscn` + `_check` + headless quit

## Dying gameplay core (do NOT extend in Phase 2 / 3)

These files exist only because the seed was a bulk copy. They die in Phase 5; do not add features, fix non-blocking bugs, or invest in their tests in this branch.

- Core: `combat.gd` (rewrite as grid-tile dispatcher), `shop.gd` (delete), `recipes.gd` (delete), `merge.gd` (slot-rename survives ~80%), `weapon.gd` (rewrite)
- Data: `part_data.gd` (delete), `recipe_data.gd` (delete), `data/parts/*.tres`, `data/recipes/*.tres`
- UI: `battle_view.gd` (rewrite as grid), `forge_panel.gd` (rewrite for 3 universal slots), `part_card.gd` (rewrite as Function card), `codex_modal.gd` (delete or repurpose), `discovery_overlay.gd` (rewrite)
- Tests: `test_recipes.gd`, `test_shop.gd`, `test_merge.gd` (rewrite); `test_combat.gd` (~50% rewrite). Existing passes don't validate forward direction — they validate the dying game.

## Non-collision with sibling folders

- **`2_Weaponcraft_Godot/`** — FROZEN 2026-06-12. The shipped P0 build (lane combat + hero-squad meta + scripted pull + scout + debug reset). Forward work has moved here. Returning to 2_WC later is allowed (folder + branches don't move) but is a deliberate fork-back, not a default.
- **`5_WeaponForge_Honkai_Godot/`** — a separate weapon-gacha + Honkai-style narrative + lane combat prototype. Different commercial bet. No code or design overlap with this folder; no shared assets except possibly raw character refs.

## Historical docs (banner-marked, kept for context)

The seed copy carried the prior direction's docs. They have a `HISTORICAL` banner pointing here:

- `docs/01_GDD.md`
- `docs/superpowers/specs/2026-06-11-hero-squad-meta-design.md`
- `docs/superpowers/specs/2026-06-12-retention-arc-d1-d20.md`
- `docs/superpowers/specs/2026-06-12-greenlight-pitch.md`
- `docs/roadmap-2026-06-12.md`
- `docs/story-beats.md`

These are reference-only. Do not edit them for forward work. They get archived after Phase 3 spec lands.

## `_archive/` — historical, reference-only

**`_archive/` MUST NOT be used for forward work.** Inherited from the 2_WC seed; contains the abandoned Wittle-inversion fork, old handoffs, mockups. If something here is needed, promote a clean copy into `docs/` and reconcile to the current SSOT first.

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
