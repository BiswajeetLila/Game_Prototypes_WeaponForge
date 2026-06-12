# HANDOFF — WeaponForge TFTransistor pivot, Phase 2 + Phase 3

**Created:** 2026-06-12 · **Previous session ended:** mid-Phase 2 (in_progress) · **Operator:** new chat picks up from here.

## TL;DR for the next chat

We pivoted from `2_Weaponcraft_Godot/` (single-lane auto-battler with anatomical Head/Hilt/Rune weapons) to a new game in `6_WeaponForge_TFTransistor/` — spatial 3×3 grid combat + Transistor-style universal Active/Modifier/Passive Function Matrix + Magicka-style cross-hero status reactions. 64% of gameplay code dies in the rewrite; meta layer survives.

**`2_Weaponcraft_Godot/` is FROZEN.** Do not touch its files. Returning to it later is allowed but the current pivot work happens only in `6_WeaponForge_TFTransistor/`.

The full pivot plan is `C:\Users\Biswa\.claude\plans\weaponcraft-game-design-fuzzy-llama.md`. Read it first.

## Decisions locked from previous chat (do NOT relitigate)

| # | Decision |
|---|---|
| 1 | Fork A (full pivot per the user's "Function Matrix" addendum) — not B (surgical) or C (polish only) |
| 2 | Vertical slice first (Phase 4, 2-3 days) BEFORE full rewrite (Phase 5, 5-7 weeks) |
| 3 | Lock full Function catalog + status matrix spec BEFORE any code (Phase 3) |
| 4 | New game lives in `6_WeaponForge_TFTransistor/`; `2_WC` frozen on remote |
| 5 | Old WeaponCraft pitch docs (`01_GDD.md`, `retention-arc-d1-d20.md`, `greenlight-pitch.md`, `hero-squad-meta-design.md`) — banner-mark as historical/superseded in Phase 2; archive only after Phase 3 spec lands |
| 6 | New `6_/CLAUDE.md` = rules only; design content lives in spec docs |
| 7 | Grid recommended 3×3 player + 3×3 enemy mirrored (smaller than addendum's 4×4 for mobile readability) — subject to user revision in Phase 3 |
| 8 | Subagents = sonnet for code, haiku for scans, save tokens (~36% weekly used at last check) |

## What's DONE (pushed to remote)

| Branch | HEAD | What it is |
|---|---|---|
| `2_WeaponCraft_Brainstorming` | `eba176c` (frozen) | Original docs-only branch, pristine reference |
| `weaponcraft-godot/p0-hero-progression-foundation` | `fbe426d` | Shipped P0 build of 2_WC (lane combat + hero-squad meta + scripted pull + scout + debug reset). Frozen. |
| `2_WC/frozen-shipped-p0` | `fbe426d` | Human-readable freeze alias of the above |
| Tag `2_WC/p0-shipped-2026-06-12` | `fbe426d` | Annotated tag for permanent retreat point |
| `weaponforge-tftransistor/seed-from-2wc` | `4894108` | **Current pivot branch.** 6_ folder seeded with bulk copy of 2_WC P0 (1550 files). Project renamed in `project.godot` so user:// + Mono assembly don't collide. 210/210 tests green from the new root. |

## What's IN PROGRESS / NEXT

**Phase 2 — Redirect + freeze markers (doc-only, ~15 min):** *unstarted, in_progress task #25*. Do this first in the next chat.
1. In `6_WeaponForge_TFTransistor/`:
   - **Rewrite `CLAUDE.md`** for the new direction. Rules only (no design content). State: folder = WeaponForge TFTransistor pivot game; SSOT is the pivot addendum (path below); non-collision note vs `2_WC` (frozen) and `5_WeaponForge_Honkai_Godot` (separate weapon-gacha project); meta layer files that survive (account_state, hero_progress, home, result_modal, pull_overlay, etc.) are still valid; gameplay-core files (combat, shop, recipes, weapon, part_data, etc.) are dying — do not extend them in this branch.
   - **Save the user's pivot addendum verbatim** as `docs/superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`. The addendum text is in the previous chat's user message titled "WeaponCraft — Game Design Addendum" (status: PROPOSED PIVOT (Post 2026-06-11 Architecture Review)). Copy it word-for-word — it is the new SSOT until Phase 3 spec lands.
   - **Banner-mark historical docs** with a top-of-file `> **HISTORICAL — describes the previous 2_WC craft+collect direction. Superseded 2026-06-12 by the Function Matrix + spatial grid pivot. See `superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`.**` block. Apply to:
     - `docs/01_GDD.md`
     - `docs/superpowers/specs/2026-06-11-hero-squad-meta-design.md`
     - `docs/superpowers/specs/2026-06-12-retention-arc-d1-d20.md`
     - `docs/superpowers/specs/2026-06-12-greenlight-pitch.md`
     - `docs/roadmap-2026-06-12.md`
     - `docs/story-beats.md`
     Do NOT delete or move them — banner only. Archive comes after Phase 3.
2. In `2_Weaponcraft_Godot/CLAUDE.md` (the FROZEN folder): prepend a single banner `> **FROZEN 2026-06-12 — see `../6_WeaponForge_TFTransistor/`.** Forward work happens there; this folder is reference-only.` No content edits below it. This is the ONLY edit allowed inside 2_WC from this point.
3. Commit + push on `weaponforge-tftransistor/seed-from-2wc` (or cut a new branch if cleaner — user preference is OK on same branch since seed is one logical setup unit).
   Message: `docs(6_WF_TFT): pivot SSOT redirect (addendum) + historical-doc banners + 2_WC freeze marker`.

**Phase 3 — Lock the design spec (~1 day, doc-only):** *unstarted, task #26*. After Phase 2 commits.
1. Cut design branch off Phase 2 HEAD: `weaponforge-tftransistor/design-spec`.
2. Author `6_WeaponForge_TFTransistor/docs/superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md`.
3. Sections required (per plan):
   - **Function catalog** — 12 atomic Functions × 3 slot behaviors = 36 cells. Per Function: id, theme, **Active**-slot behavior (attack pattern + tile shape + range + targeting), **Modifier**-slot behavior (how it warps the Active beneath it), **Passive**-slot behavior (continuous aura/trait). Starting cut to propose (user can revise): `FIRE`, `ICE`, `LIGHTNING`, `WATER`, `EARTH`, `AOE`, `BURST`, `BEAM`, `BOUNCE`, `SEEKER`, `LEECH`, `KNOCKBACK`.
   - **Status outputs** — for each Function in Active slot: which status it leaves on hit tiles (Burning / Wet / Chilled / Shocked / Cracked / etc.), duration, stack rules, cleanse rules.
   - **Reaction matrix** — every (incoming-damage-tag × existing-status) pair: reaction name, damage multiplier, splash radius, VFX hook, status mutation. Examples to seed: `LIGHTNING × Wet → Electrocute (2× dmg, splash 1 tile)`, `FIRE × Chilled → Steam (cleanse + blind 1 tick)`, `EARTH × Wet → Mudslide (slow 2 ticks)`. Aim ~12–15 reactions for v1.
   - **Per-hero base weapons** — what Bran/Elara/Vex do with ZERO Functions socketed. Default attack pattern, default targeting, default status output if any.
   - **Grid** — 3×3 player + 3×3 enemy mirrored. Tile coordinate scheme. Hero static (no movement) v1.
   - **Targeting rules** — derived per Active Function (closest-by-line for melee, closest-by-Manhattan for ranged, line-by-row for BEAM, etc.). Enemy advance cadence (one row per N ticks). Boss = single multi-row tile.
4. **User review gate** — author the spec, present to user, they sign off / revise / iterate in markdown only. Do NOT start Phase 4 code before signed off.
5. Commit + push: `docs(6_WF_TFT): lock Function catalog + status reaction matrix design spec`.

**Phase 4 — Vertical slice (~2-3 days, throwaway):** task #27, after Phase 3 sign-off. Out of scope for the next chat unless time permits + Phase 3 is approved. See plan file for details.

**Phase 5 — Full rewrite (5-7 weeks):** out of scope for the next chat. Drafted separately after Phase 4 feel-gate.

## Environment / how to run things

| Thing | Value |
|---|---|
| Godot binary | `C:\Godot_v4.6.2-stable_mono_win64\Godot_v4.6.2-stable_mono_win64_console.exe` |
| 6_ Godot project path | `C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\6_WeaponForge_TFTransistor\Prototype\godot` |
| Headless run | `<godot.exe> --headless --path <project_path> res://scenes/dev/<Scene>.tscn` — exit code = failure count |
| Test sweep scenes | `TestProgression`, `TestWeaponData`, `TestCombat`, `TestMerge`, `TestRecipes`, `TestShop`, `TestUi` |
| Last 6_ sweep | 210/210 green (TestProgression 58, TestWeaponData 10, TestCombat 55, TestMerge 22, TestRecipes 18, TestShop 26, TestUi 21) |
| AUTOSHOT screenshot | `$env:WC_AUTOSHOT = "<abs path>.png"; & <godot.exe> --path <project_path> [scene.tscn]` — runs WITHOUT --headless, renders ~1.5s, saves PNG, quits |
| Git root | `C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes` |
| User name + email | Biswajeet · biswajeet@lilagames.com |
| Token policy | Sonnet for code subagents, haiku for scans; weekly cap 80% (was ~36% used at last check, monitor) |
| Image gen | `nano-banana` default ($0.04/img); `nano-banana-pro` only on explicit user OK ($0.24/img) |

## Critical files / surfaces (next-chat orientation)

**Read first to orient:**
- `C:\Users\Biswa\.claude\plans\weaponcraft-game-design-fuzzy-llama.md` — full pivot plan, all phases
- `6_WeaponForge_TFTransistor/CLAUDE.md` — currently still says "2_Weaponcraft_Godot" (it's the unchanged 2_WC copy); rewrite this in Phase 2
- `6_WeaponForge_TFTransistor/docs/01_GDD.md` — old direction, banner-mark in Phase 2
- The user's pivot addendum is in the previous chat as a user message; copy verbatim into `6_/docs/superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`

**Reference (good patterns to reuse):**
- TDD test harness pattern: `6_/Prototype/godot/scripts/dev/test_progression.gd` (`_check`, headless quit)
- Save layer: `6_/Prototype/godot/scripts/core/account_state.gd` — schema v2 (heroes + flags), v1 migration
- Progression math: `6_/Prototype/godot/scripts/core/hero_progress.gd` — pure static
- Home UI shape: `6_/Prototype/godot/scenes/Home.tscn` + `home.gd` — survives unchanged

**Files that DIE in Phase 5 (do NOT extend in Phase 2 / 3):**
- `combat.gd`, `shop.gd`, `recipes.gd`, `weapon.gd`, `part_data.gd`, `recipe_data.gd`
- `battle_view.gd`, `forge_panel.gd`, `part_card.gd`, `codex_modal.gd`, `discovery_overlay.gd`
- `data/parts/*.tres`, `data/recipes/*.tres`

## Known nits + caveats

1. **`.godot/` cache in 6_ is local-only** (in `.gitignore`). Was bootstrapped by copying from 2_WC for the sanity test. If 6_ gets opened on a fresh machine, Godot will rebuild it automatically on first editor open — slow first time, then fine.
2. **Mid-conversation working-tree dirt** — there are pre-existing `.import` autosave churn + uncommitted root-research deletions in the worktree from earlier sessions. Not your problem; left for user decision. Verify staged diff before any commit (use `git diff --cached --name-only`).
3. **Worktree state at handoff** — current branch `weaponforge-tftransistor/seed-from-2wc`, working tree has pre-existing `.import` noise + research deletion noise (out-of-scope, owner's call). Phase 2 should commit only files under `6_/docs/`, `6_/CLAUDE.md`, and `2_Weaponcraft_Godot/CLAUDE.md` (banner only).
4. **Image-gen MCP** is reconnecting / disconnecting — fine for doc work, irrelevant unless we generate new art.

## Task board (carry forward)

Open tasks at handoff (numbers from previous chat's TaskCreate IDs):
- #25 **Phase 2: Redirect + freeze markers (doc-only)** — in_progress (was marked in_progress before close; pick this up first)
- #26 **Phase 3: Lock Function catalog + status matrix spec** — pending
- #27 **Phase 4: Vertical slice** — pending (out of scope until Phase 3 signed off)

Closed tasks list (for context): #1, #10-#24 — see previous chat's task history.

## First moves for the next chat

1. `Read C:\Users\Biswa\.claude\plans\weaponcraft-game-design-fuzzy-llama.md` (the plan)
2. `Read C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\6_WeaponForge_TFTransistor\HANDOFF.md` (this file)
3. Verify state: `git -C "C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes" branch --show-current` → should be `weaponforge-tftransistor/seed-from-2wc`
4. Verify sweep still 210/210 from 6_ (one PowerShell loop, ~2 min)
5. Start Phase 2 per the steps above.

**Operator note for the next chat:** user prefers terse caveman-style output, batched subagent dispatches over many small calls, commit + push per phase boundary (not per task), explicit tag/branch freeze markers over implicit ones. User will redirect if the call is wrong — bias toward action.
