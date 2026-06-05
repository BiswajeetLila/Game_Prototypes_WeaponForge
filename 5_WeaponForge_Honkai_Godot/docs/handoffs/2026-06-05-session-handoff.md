# Handoff — 2026-06-05 — Forge & Infuse + playtest polish (resume here)

**Read `docs/STATUS.md` first** — it's the SSOT (state + the canonical build queue + repo/engine rules).
This doc is the session resume note; it references artifacts rather than repeating them.

## Where to work (exact)
- **Branch:** `weaponcraft-godot/wittle-inversion-phase1` — synced with origin @ `def0c31`
  (latest will differ after this session's docs commit; `git -C <worktree> status` to confirm).
  **Do NOT merge to main** (owner-gated). Do NOT base work on `main` (= `e958745`, pre-fork).
- **Worktree:** `.claude/worktrees/pedantic-golick-94f7e8/` (warm import cache). If it's gone,
  fresh-checkout the branch anywhere + run a cold `--headless --import` pass first.
- **Godot project:** `5_WeaponForge_Honkai_Godot/Prototype/godot` (boots `scenes/Home.tscn`, F5).
- **Engine ops = godot MCP by default** (owner preference): `mcp__godot__run_project(projectPath, scene?)`
  → `get_debug_output` → `stop_project`, pointed at the pedantic-golick worktree path. Run a dev-test
  suite via `run_project(scene=res://scenes/dev/TestX.tscn)` + parse the printed `=== N passed / M failed ===`.
  Console-exe headless (`Godot_v4.6.2-..._console.exe --headless --path <p> <scene> [--quit-after 400]`)
  is the fallback for batch exit-code runs. Full rule: STATUS §6 Engine/run.

## Current state (one line)
Full GDD loop + the **Forge & Infuse gacha economy** are playable and green (~423 tests).
Detail: STATUS §3-4 + `docs/handoffs/2026-06-03-forge-and-infuse.md`. This session also did a
**playtest-polish round** (see commits below); all suites green, branch pushed, main untouched.

## This session's commits (newest first; full messages in git log)
`def0c31` lich nerf · `382aa30` detail panel revert→fixed opaque + quick-swap · `5935561` hide legacy gold ·
`199b89f` HP-bar full-heal refresh · `8a6a3d3` reforge-retry ult reset + softer curve · `66afc2e`/`f65a337`/`0f40672`
infuse logic+UI+star-progress · `6302bad` 3-hero starters + reset-crash guard · `8e4ed0d` run-start full HP ·
`266c10d` stage scaling soften · `2a9f34a`/`3d861d8` pull rework + 12-weapon catalog · `5dd8c18`..`9940f27` Stages A–E.
(+ a docs commit closing this session.)

## NEXT — owner-agreed order (NOT now; for upcoming sessions)
Canonical list w/ detail = **STATUS §4 NEXT**. Summary:
1. **#2 Elemental / ability draft cards** + **#3 Hot Paladin scripted-defeat entry** → do TOGETHER = the FM-8 vertical slice.
2. **#4 Catalyst compounds** (+ socket retirement 9a–e) + **#1 spin cinematic** → do TOGETHER, after.
3. Human gates (Bran portrait eval, "Catalyst" trademark) + merge to main — owner say only.

Start the next build with `superpowers:test-driven-development` (global TDD policy: RED→GREEN, suite
green per commit, commit+push per increment). #3 needs the spec's "Stage 2 wave 14" trigger re-mapped
to the prototype's 5-wave stage shape (see design spec §roster + "Hot Baddie Stage 2 cinematic").

## Gotchas (hard-won — see STATUS + the 2026-06-02/06-03 handoffs)
- **Stage-1 combat numbers must stay EXACTLY neutral** (enemy mult 1.0; rarity_mult is 1.0 at Common). Run TestCombat after combat/weapon changes.
- **Never write `user://account.json` from headless tests** (autosave is headless-gated — keep new mutators on that path; tests use explicit `TEST_SAVE_PATH`).
- New `.tres`/`.tscn`/`.gd` load by path (no import needed); only textures need the `--import` pass.
- Two progression axes are SEPARATE: dupes→★ star (`add_dupe`), shards→rarity (`apply_forge_shard` + the deterministic `AccountState.infuse`). Don't reconflate.
- `.import` autosave churn = noise; don't commit it (commit explicit paths).

## Suggested skills (next session)
- `superpowers:test-driven-development` — before ANY production code (mandatory, global policy).
- `superpowers:brainstorming` — if #3 (Hot Paladin) needs the scripted-defeat/cinematic design fleshed out before coding.
- `anthropic-skills:game-design` — for tuning the elemental weak/resist + ability-transform draft (#2) and any difficulty re-tune.
- `caveman:caveman` — owner runs caveman mode (full); it's hook-activated at session start anyway.
