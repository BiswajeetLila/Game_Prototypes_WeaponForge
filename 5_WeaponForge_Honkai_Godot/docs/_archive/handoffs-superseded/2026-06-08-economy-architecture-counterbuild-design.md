# Handoff — 2026-06-08 — Economy pivot + Progression architecture + Counter-build design (+ build start)

**Read `docs/STATUS.md` first.** This is the session resume note for a long design session that produced 3 specs + 1 implementation plan and kicked off the build.

## Where to work (exact)
- **Branch:** `weaponcraft-godot/wittle-inversion-phase1` — **the continuity branch.** Worktree `.claude/worktrees/pedantic-golick-94f7e8/` (warm import cache). Owner-gated: pushed, **NOT merged to main**.
- **Godot project:** `5_WeaponForge_Honkai_Godot/Prototype/godot` (boots `scenes/Home.tscn`).
- Engine ops = **godot MCP** (`run_project`/`get_debug_output`/`stop_project`) at the pedantic-golick path. ~423 tests green baseline.

## What this session produced (design — no production code yet)
All under `5_WeaponForge_Honkai_Godot/docs/`:
1. **`superpowers/specs/2026-06-06-economy-restructure-elara-quest-design.md`** — the **economy pivot** (Phase-1 buildable slice).
2. **`superpowers/specs/2026-06-06-progression-economy-architecture.md`** — the **full-game depth map** (SSOT for the whole game: 15 layers, currency table, core-loop, B small/full, ≤4-concurrent pacing).
3. **`superpowers/specs/2026-06-08-prestage-counterbuild-design.md`** — the **core-loop "is it fun" fix** (APPROVED).
4. **`superpowers/plans/2026-06-08-prestage-counterbuild.md`** — the **implementation plan** (6 TDD tasks) for #3. **← the active build.**
5. **`research/anime_autobattlers/`** — competitor study (copied in from the monorepo root, where it had been mis-placed). Verdict: **NOT a threat** (hero-gacha JRPGs; different lineage; validates our moat + the counter-build loop is uncontested).
6. `04_economy/currency.md` → redirect banner (superseded by the architecture doc).

## Key decisions LOCKED this session
- **Economy = 3 buckets:** scarce **pull currency** (Cores, name TBD — NOT "Forge Core"/"Spark", collisions) + **gems** (play-earned → star-up) + **shards** (→ infuse rarity). Gems OUT of pulls. Save v3→v4.
- **#1 dupe:** weapon-reveal stays; dupe → **gems** (C20/R40/E80/L160); star-up = gem spend (`100×tier`). Materials-gacha accepted; aspiration moves to QUESTS.
- **#2 shards:** `SHARD_INC` halved; `RARITY_MULT` untouched; drop 2 on common/rare pull, 0 on epic/leg.
- **#4 Elara:** 5-spark escalating chain (1/~3 stages) → Mythic staff at spark 5 (no early spike) + small-B **3-node micro talent tree** capstone Meteor→Meteor Shower. Phase 2.
- **B (hero talents) = core:** small now (Elara micro-tree) + full later (roster trees + ability transforms, Cyberpunk-gated). Deferred Phase 3.
- **§18 reconciled:** "full depth, ≤4 concurrent" — 10+ layers over the game's life, ~4 active at once.
- **Core loop = pre-stage COUNTER-BUILD** (owner direction): stage telegraphs boss + minion affinities BEFORE entry; equip weapon-elements to counter; **in-run draft stays RNG**. Boss+minion **split** (2 affinities). Element set **Fire/Ice/Electric/Wind** (retire `pierce`). **~20% of minions spawn un-classed** (flavor; `UNCLASSED_CHANCE=0.20`). Offense-only weak ×1.8/resist ×0.5 (already in combat). **Defeat → squad/loadout screen** (no retry/reforge modal; sidesteps FM-14). Catalyst = the NEXT core-loop spec.

## Active build — counter-build plan (subagent-driven, TDD)
`superpowers/plans/2026-06-08-prestage-counterbuild.md`, 6 tasks:
1. Retag 3 boss `.tres` (fire/ice/electric/wind). 2. Verify per-class weapon element coverage. 3. `StageAffinity` module + TestStageAffinity. 4. Wire minion affinity into combat (80% affinity / 20% un-classed) — **keep TestCombat green (stage-1-neutral contract)**. 5. Pre-stage briefing panel on Home. 6. Defeat → Home.

## Worktree note
Continuity worktree = `pedantic-golick-94f7e8` on `weaponcraft-godot/wittle-inversion-phase1`. 14 other worktrees exist from parallel sessions — **left alone** (may be live in other windows). The anime research was untracked in the monorepo ROOT (`main`); copied into the project tree on this branch.

## Standing reminders
- **TDD mandatory** (RED→GREEN per increment); suite green per commit.
- **Stage-1 combat EXACTLY neutral** (mult 1.0; TestCombat is the contract) — run it after combat changes.
- **Never write `user://account.json` from headless** (autosave headless-gated).
- Merge to main = owner say-so only. Caveman mode (full) hook-active.
