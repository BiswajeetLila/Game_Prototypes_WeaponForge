# Handoff — 2026-06-08 (session end) — Counter-build + Economy SHIPPED

**This is the NEWEST handoff — start here after STATUS.** Supersedes `2026-06-08-economy-architecture-counterbuild-design.md` (that one was mid-session "design, no code yet" — both features are now BUILT + pushed).

## One-line state
The **pre-stage counter-build loop** and the **Ember economy** are both implemented, tested (301 dev tests green), and **MERGED TO `main`** (origin `b6de582`) — now in the main checkout, **no worktree**. Next planned build = **Catalyst** (element-pair synergy), on a fresh in-place branch. Owner is playtesting.

## Where to work (exact) — UPDATED at session close (moved to main)
- **MERGED TO MAIN.** Everything is on **`main`** (origin `b6de582`). Work from the **main checkout**: `C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\5_WeaponForge_Honkai_Godot`. The old worktree is gone.
- **NO MORE WORKTREES (owner pref, 2026-06-08).** For the next feature, cut a branch IN PLACE in the main folder: `git checkout -b forgeloop/<feature>` (e.g. `forgeloop/catalyst-element-pairs`). Do NOT create `.claude/worktrees/*`.
- **First Godot open in the main folder = a one-time cold re-import** (textures) — let it finish.
- **Godot project:** `5_WeaponForge_Honkai_Godot/Prototype/godot` (boots `scenes/Home.tscn`).
- **Engine ops = godot MCP** at the **main-folder** godot path (`…\Game_Prototypes\5_WeaponForge_Honkai_Godot\Prototype\godot`): `run_project(scene="res://scenes/dev/TestX.tscn")` → `get_debug_output` (parse `=== N passed / M failed ===`) → `stop_project` (legacy TestCombat doesn't self-quit; stop after the summary).
- **Leftover (harmless):** the old `.claude/worktrees/pedantic-golick-94f7e8/` dir is orphaned on disk (git-unregistered; a long-path file blocked auto-delete). Delete manually if desired: elevated `rd /s /q "\\?\<that path>"`.

## SHIPPED this session (all pushed)
**A. Pre-stage Counter-Build loop** (spec `docs/superpowers/specs/2026-06-08-prestage-counterbuild-design.md`, plan `docs/superpowers/plans/2026-06-08-prestage-counterbuild.md`; commits `99c9523`→`2da9c0a` + UI `662415a` + cleanup `7b6621d`):
- Bosses retagged to **Fire/Ice/Electric/Wind** (retired `pierce`). `StageAffinity` (pure static, `scripts/core/stage_affinity.gd`): deterministic per-stage minion+boss affinity — stage 1 mirrors the boss (teaching), stage ≥2 spreads + conflicts ≥⅓.
- Combat: minions get the stage affinity 80% / **un-classed 20%** (flavor), replacing the random roll. weak ×1.8 / resist ×0.5 already existed.
- **Pre-stage briefing panel** on Home (telegraphs both affinities + ✅/⚠️ squad coverage before battle).
- **Defeat → squad/loadout screen** (removed ReforgeRetryModal; sidesteps FM-14).
- UI polish: solid-bg/autowrap banners (boss telegraph no longer clips) + draft-card solid panels + gold click-flash.

**B. Ember economy** (spec `docs/superpowers/specs/2026-06-06-economy-restructure-elara-quest-design.md` §1-4, plan `docs/superpowers/plans/2026-06-08-economy-ember-forge.md`; commits `65ef9ec`→`a7b0fec`):
- **Ember** = the gacha currency (pulls cost 5; earned boss +1 / victory +2; start 5). **Gems no longer pull.**
- **Gems → forge currency:** **star-up** is now a gem spend (`AccountState.star_up`, 100×tier, caps at ★10). **Dupe → gems** (rarity ladder 20/40/80/160; no more dupe-star).
- **Shard nerf:** `SHARD_INC` halved (~2× slower) + drop **2 on common/rare pull, 0 on epic+**.
- **Save v3→v4** (back-compat: old saves load with ember=0).
- Home UI surfaces Ember + forge gems + the star-up button + dupe="+gems" reveal.

## ⚠️ Playtest gotcha (tell the owner / next session)
**Existing saves load with Ember = 0** (the migration default). So on an old save, pulls are blocked until a boss-clear/victory earns Ember — OR use Home's **"reset account (debug)"** for a fresh start (5 Ember). Not a bug.

## NEXT — roadmap (owner playtests first, then picks)
1. **Catalyst** (element-pair squad synergy — §5 of the design spec / architecture doc). The pre-stage build's 2nd axis (counter the affinity AND form good element pairs). Needs: `superpowers:brainstorming` → spec → `superpowers:writing-plans` → subagent-driven build. **Catalyst is currently 100% design-only** (10 named compounds, placeholder effects; `home_screen` already shows a squad-element readout stub).
2. **Elara signature mission** (FM-8 hero-bond probe) + **small-B** micro talent tree (Meteor→Meteor Shower) — spec `2026-06-06-economy-restructure-elara-quest-design.md` §5 (Phase 2; was excluded from the economy build) + architecture doc §6. Then **full-B** hero talent trees (Phase 3).
3. **Balance/tuning pass** (Numbers Policy, playtest-driven): Ember earn-vs-cost, dupe→gems ladder, star-up cost, shard pacing, stage-affinity conflict rate, the 20% un-classed rate, difficulty curve.
4. **Human gates:** Bran 5-tier portrait eval (20 Honkai players) + "Catalyst" trademark check.
5. **Merge** `weaponcraft-godot/wittle-inversion-phase1` → `main` — owner say-so only.

## Open / known nits (low priority — non-blocking)
- `forge_wheel.gd`: `var star_up` in `pull()` is now always-false dead (kept for result-dict back-compat); `AccountState.PULL_COST` (300 gems) dead in prod (kept for one legacy test). `WeaponData.add_dupe`/`DUPES_PER_STAR`/`star_progress` retained for save back-compat. Stale comment in `test_forge_wheel._test_second_pull_goes_to_bench`. Clean up opportunistically.
- All economy/affinity numbers are Numbers-Policy STARTING values — tune in playtest.

## Locked names / decisions
Pull currency = **Ember**. Elements (FTUE) = Fire/Ice/Electric/Wind (Earth gates later). Counter-build: draft stays RNG; strategy = pre-stage loadout. §18 "≤4 concurrent axes" reconciled (full depth, paced).

## Doc index (read order)
1. `docs/STATUS.md` (SSOT — state + queue + repo/engine rules).
2. `docs/superpowers/specs/2026-06-06-progression-economy-architecture.md` (full-game depth map).
3. The 2 feature specs + 2 plans listed above.
4. `docs/superpowers/specs/2026-05-27-wittle-inversion-design.md` (the locked v2.2 design).
5. `docs/research/anime_autobattlers/` (competitor study — not a threat; validates the moat).

## Standing reminders
- **TDD** mandatory (RED→GREEN, suite green per commit). **Stage-1 combat EXACTLY neutral** — run TestCombat after combat changes (it's the contract). **Never write `user://account.json` from headless.** Engine = godot MCP. Merge/push = owner-gated (this session's work IS pushed). Caveman mode (full) hook-active.
