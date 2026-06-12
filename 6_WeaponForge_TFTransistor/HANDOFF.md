# HANDOFF — WeaponForge TFTransistor pivot, Phase 3 → 4 transition

**Last updated:** 2026-06-13 (sleep handoff) · **Previous session:** Phase 3 spec authored to REVIEW-3 + 3-review pass + doc tree consolidation + 2_WC archive · **Next chat:** picks up at LOCK gate → Phase 4 cut.

## TL;DR for the next chat

We pivoted from `2_Weaponcraft_Godot/` (single-lane auto-battler with anatomical Head/Hilt/Rune weapons) to a new game in `6_WeaponForge_TFTransistor/` — **3-lane horizontal auto-runner (Capybara Go / Wittle Defender format) + Transistor-style Function Matrix + Magicka cross-hero status reactions + Wittle-clone meta-progression direction**. Statuses attach to enemies, not tiles. Heroes lane-locked, no spatial placement. 7-slot shop slow-populates across each 3-wave stage. 5 stages per world = 15 waves ≈ 4-5 min session.

**`2_Weaponcraft_Godot/` is FROZEN.** Do not touch its files. The full pivot plan lives at `C:\Users\Biswa\.claude\plans\weaponcraft-game-design-fuzzy-llama.md` (read first).

## Phase 3 — what landed this session

Branch: **`weaponforge-tftransistor/design-spec`** @ `3c27be2`. 6 commits this session:

| Commit | What |
|---|---|
| `1bf7986` | DRAFT — mirrored 3×3 grid + initial Function catalog |
| `761bef0` | REVIEW-2 — central 4×4 grid w/ 4-edge spawn (Wittle-style); FTUE, Ults, wave/forge cadence |
| `6e386a4` | **REVIEW-3** — auto-runner 3-lane pivot (Capybara Go format), 26 locked decisions, Phase 4 slice scope doc authored |
| `d1d6ccc` | Doc tree consolidation — **01_GDD restored as SSOT** (user caught that Phase 2 wrongly demoted it); banners updated on 17 missed historical docs |
| `ce16021` | Forward `roadmap-2026-06-13.md` + `story-beats-2026-06-13.md` for the new direction |
| `3c27be2` | **Archived 22 2_WC-direction docs** → `_archive/docs-pre-pivot-2026-06-12/` (git-mv preserves history) |

## 3-review pass executed this session (all findings folded into REVIEW-3)

1. **`/game-design`** — 5-component filter applied. Findings: clarity gaps on advance telegraph, response score 4/10 (auto-battler screensaver risk), audio missing, Ult state machine gaps, knockback exploit, Cracked priority ambiguity. **All folded into REVIEW-3 §1-§16.**
2. **`/plan-ceo-review`** — SELECTIVE EXPANSION mode. C1-C10 critical patches + E1 (chain HUD) accepted, E2 (replay 3-sec) deferred Phase 5. Scope decisions written into spec §13 + §17 + new §14/§15/§16.
3. **`/product-management:product-brainstorming`** — assumption testing + JTBD. P2 (shop pity counter) accepted, P4 (hero meta-XP) deferred to Phase 5 Wittle-meta spec, P6 (wave telegraph) accepted at medium granularity, monetization deferred post-slice.

## User-locked design decisions accumulated this session

- **Q1-Q3:** 12 Functions, 15 reactions, status durations 3/3/2/4/4 — locked
- **Q4 → REVIEW-3 reversion:** 4×4 central → **3-lane horizontal auto-runner** (Capybara Go); enemies right→left; no spatial placement
- **Q5:** WATER → cross-lane spread (target + 2 adj lanes)
- **Q6:** Vex innate +20% vs Burning — kept hard-coded
- **Q7:** Boss skipped in slice (stage 5 W3 = stationary 5×HP stand-in)
- **Q8:** Modifier-without-Active warps base weapon
- **Q9:** FTUE replays on `AccountState.reset()` (debug button already wires)
- **D11:** Shop pity ≥1 Element per 2 stages
- **D12:** Hero-level Wittle-clone meta deferred to Phase 5 (separate spec)
- **D13:** Wave telegraph medium granularity (portraits + weak/resist icons)
- **D14:** Cohort positioning rewrite deferred post-slice playtest
- **D15:** Monetization model deferred post-slice
- **Mit-A:** Salvageable death — dead hero stays dead but shop+gold continue for survivors
- **Mit-B revised:** FTUE stages 1+2 = 1 wave each; stages 3+4 = 3 waves; stage 5 = boss (2 mini + 1 boss)
- **Mit-C → docs-only:** 3-card in-combat module = deferred contingency (spec §20); activate if Phase 4 playtest shows forge-only is lackluster
- **Mit-D:** Shop slow-populate 2/3/2 across stage
- **Bottom rail:** Weapon-always-visible, 3 heroes × 3 sockets, HP, Ult bars
- **Tiers:** T1-T5, **2-to-1 merge** (16 commons → 1 mythic). T1 only in slice.
- **Worlds:** Heroes persist across worlds (Wittle-meta layer); Functions reset per world. 1 world = 1 session.
- **FTUE timing:** Bran joins F2 cinematic; Vex joins F4 cinematic (via reused `PullOverlay`)
- **scout_intel revived** as per-stage wave telegraph (was killed initially, user pulled back)

Full list of 26 locked decisions in [function spec §21](docs/superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md#21-locked-decisions-register).

## Current doc tree (lean — only forward work in `docs/`)

```
docs/
├── 01_GDD.md                                       ⭐ SSOT
├── roadmap-2026-06-13.md                           forward roadmap
├── story-beats-2026-06-13.md                       forward narrative
└── superpowers/specs/
    ├── 2026-06-12-function-catalog-and-status-matrix.md   REVIEW-3 contract (904 lines)
    ├── 2026-06-13-phase4-vertical-slice-scope.md          Phase 4 scope (338 lines)
    ├── 2026-06-12-fork-a-pivot-addendum.md                pivot rationale verbatim
    └── grid-4x4-wittle-style.png                          interim ref image

_archive/docs-pre-pivot-2026-06-12/                  22 archived 2_WC docs (R100 renames)
```

## What's IN PROGRESS / NEXT (for tomorrow's chat)

### Resume-step 1: LOCK gate

User reads (or has read) REVIEW-3 spec end-to-end + Phase 4 scope doc. Says `lock spec` →
- Flip status DRAFT/REVIEW-3 → **LOCKED** in [function spec](docs/superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md) header
- Flip status DRAFT → **LOCKED** in [Phase 4 scope](docs/superpowers/specs/2026-06-13-phase4-vertical-slice-scope.md) header
- Cut new branch `weaponforge-tftransistor/vertical-slice` off `3c27be2`
- Mark TaskList #2 completed; #3 in_progress
- Commit + push: `chore(6_WF_TFT): LOCK design spec REVIEW-3 + Phase 4 scope; cut vertical-slice branch`

### Resume-step 2: Phase 4 build sequence §4

18 TDD steps per [Phase 4 scope §4](docs/superpowers/specs/2026-06-13-phase4-vertical-slice-scope.md#4-build-sequence-tdd-driven). Step 1 = `account_state.gd` v2→v3 migration:
- Write test in `Prototype/godot/scripts/dev/test_progression.gd` for v2→v3 migration (`ftue_complete` field defaults false on existing saves; v3 saves round-trip)
- Watch test FAIL
- Extend `account_state.gd` schema to v3 + add migration logic
- Watch test PASS
- Run full TestProgression suite headless — confirm 58 + new = green

Target dev time: 2-3 days for slice freeze. Test sweep target: 90+ tests green.

## Environment / how to run things (unchanged from previous handoff)

| Thing | Value |
|---|---|
| Godot binary | `C:\Godot_v4.6.2-stable_mono_win64\Godot_v4.6.2-stable_mono_win64_console.exe` |
| 6_ Godot project path | `C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\6_WeaponForge_TFTransistor\Prototype\godot` |
| Headless run | `<godot.exe> --headless --path <project_path> res://scenes/dev/<Scene>.tscn` — exit code = failure count |
| Test sweep scenes | `TestProgression`, `TestWeaponData`, `TestCombat`, `TestMerge`, `TestRecipes`, `TestShop`, `TestUi` |
| Last 6_ sweep | 210/210 green (TestProgression 58 + TestWeaponData 10 + TestCombat 55 + TestMerge 22 + TestRecipes 18 + TestShop 26 + TestUi 21) — but slice will start adding new ones |
| AUTOSHOT screenshot | `$env:WC_AUTOSHOT = "<abs path>.png"; & <godot.exe> --path <project_path> [scene.tscn]` |
| Git root | `C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes` |
| User name + email | Biswajeet · biswajeet@lilagames.com |
| Token policy | Sonnet for code subagents, haiku for scans; weekly cap monitor |
| Image gen | `nano-banana` default ($0.04/img); `nano-banana-pro` only on explicit user OK |

## Task list state at handoff

```
#1. [completed]   Phase 2: Redirect + freeze markers (doc-only)
#2. [in_progress] Phase 3: Lock Function catalog + status matrix spec
                  (REVIEW-3 + Phase 4 scope authored + 3 reviews folded + doc tree consolidated +
                   01_GDD restored as SSOT + forward roadmap/story-beats + 2_WC archive done.
                   Awaiting LOCK sign-off.)
#3. [pending]     Phase 4: Vertical slice (throwaway)
                  (Resume after LOCK. 18 TDD steps. Target 2-3 days. Branch:
                   weaponforge-tftransistor/vertical-slice to cut off 3c27be2.)
```

## First moves for the next chat

1. `Read C:\Users\Biswa\.claude\plans\weaponcraft-game-design-fuzzy-llama.md`
2. `Read C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\6_WeaponForge_TFTransistor\HANDOFF.md` (this file)
3. `Read C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\6_WeaponForge_TFTransistor\docs\01_GDD.md` (SSOT)
4. Verify branch: `git branch --show-current` → should be `weaponforge-tftransistor/design-spec`
5. Recreate TaskList from "Task list state at handoff" above (TaskCreate doesn't persist across sessions)
6. Ask user: "Read REVIEW-3 spec + Phase 4 scope. Say `lock spec` → cut Phase 4 branch + begin TDD step 1 (AccountState v3 migration)."

**Operator notes (carry forward):**
- User prefers caveman-style output (terse, fragments OK; code/commits/security = normal prose).
- Batched subagent dispatches over many small calls.
- Commit + push per phase boundary (not per task).
- Explicit tag/branch freeze markers over implicit ones.
- User bias = action; redirect if call is wrong.

## Critical files / surfaces for orientation (next chat)

**Read first:**
- [`docs/01_GDD.md`](docs/01_GDD.md) — folder SSOT
- [`docs/roadmap-2026-06-13.md`](docs/roadmap-2026-06-13.md) — phases + decision gates
- [`docs/superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md`](docs/superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md) — REVIEW-3 implementation contract
- [`docs/superpowers/specs/2026-06-13-phase4-vertical-slice-scope.md`](docs/superpowers/specs/2026-06-13-phase4-vertical-slice-scope.md) — Phase 4 mission + build sequence + feedback plan

**Reference (good patterns to reuse from 2_WC P0 meta layer):**
- TDD harness: `6_/Prototype/godot/scripts/dev/test_progression.gd` (`_check`, headless quit)
- Save layer: `6_/Prototype/godot/scripts/core/account_state.gd` — schema v2 (heroes + flags), v1 migration; extends to v3 in Phase 4
- Progression math: `6_/Prototype/godot/scripts/core/hero_progress.gd` — pure static
- Home UI shape: `6_/Prototype/godot/scenes/Home.tscn` + `home.gd` — survives unchanged
- Pull cinematic: `6_/Prototype/godot/scripts/ui/pull_overlay.gd` — reused for FTUE Bran/Vex unlocks

**Files that DIE in Phase 5 (do NOT extend in Phase 4):**
- `combat.gd` (rewrite as `combat_v2.gd` for lane-runner)
- `shop.gd` (rewrite as `shop_v2.gd` for 7-slot slow-populate)
- `recipes.gd`, `weapon.gd`, `part_data.gd`, `recipe_data.gd` (delete)
- `battle_view.gd` (rewrite as `battle_view_v2.gd` for 3-lane corridor)
- `forge_panel.gd` (rewrite as `forge_panel_v2.gd` for 7-slot + bottom rail)
- `data/parts/*.tres`, `data/recipes/*.tres`

## Known nits + caveats (carry forward)

1. **`.godot/` cache** in 6_ is local-only (in `.gitignore`). Was bootstrapped by copying from 2_WC. Fresh clone will rebuild on first editor open.
2. **Mid-conversation working-tree dirt** — pre-existing `.import` autosave churn + uncommitted root-research deletions in the worktree from earlier sessions. Not blocking. Verify staged diff before any commit (use `git diff --cached --name-only`).
3. **Image-gen MCP** intermittently reconnects/disconnects — doesn't matter for code work; matters only when generating new art.
4. **Active branch at handoff:** `weaponforge-tftransistor/design-spec`. Phase 4 will cut `weaponforge-tftransistor/vertical-slice` off this branch's HEAD (`3c27be2`).
5. **`HANDOFF.md` itself** is this file; older version was tracked in commit `7512f35` (kept in git history; overwritten by this commit).

Goodnight. Resume tomorrow with `lock spec` (or redirect any item before lock).
