# NIGHT-LOG — P0 vertical slice overnight run

**Started:** 2026-06-12 ~02:30 · **Branch:** `weaponcraft-godot/p0-hero-progression-foundation` · **Operator:** autonomous (user away)

**Contract:** full slice playable — HOME → squad-select → RUN → result → scripted pull + stage telegraph; 2D visuals cut from `_art-build/screens/`; TDD headless per task; commit+push per green task; judgment calls logged here; skip-to-independent-work on hard block; subagents = sonnet (code) / haiku (scans); no audio (silent hooks); no real economy (scripted pull only).

**Build targets:** `_art-build/screens/{run,home,squad,pull,result}_01.png` · design spec §9 (P0) · plan `docs/superpowers/plans/2026-06-12-p0-hero-progression-foundation.md`.

---

## Decisions / events log

- [02:30] Run started. Art set committed (`01bef51`), research housekeeping (`789ea3d`). Out-of-scope root-research deletions left uncommitted per permission guard — flagged in morning report.
- [02:35] Godot console binary located: `C:\Godot_v4.6.2-stable_mono_win64\Godot_v4.6.2-stable_mono_win64_console.exe`. Headless smoke: TestWeaponData 10/10 green, exit 0. TDD loop operational.
- [02:40] User constraints added: (1) if 5h token window exhausts, retry/resume next window and continue; (2) HARD cap 80% weekly tokens (36% at start). Enforcement: sonnet/haiku subagents only, batched dispatches, frugal re-reads; on usage-limit errors -> stop spawning, push all, report with what's done.
- [02:41] Budget decision: Plan1 T1-T3 executed by ONE sonnet subagent (same files, sequential, plan self-contained) instead of 3 dispatches. Main loop verifies + runs T4 regression.
- [03:05] Plan1 COMPLETE. T1-T3 via sonnet subagent (64k tokens): hero_progress.gd (16 checks), AccountState autoload + JSON round-trip (26 cum), HeroState level_mult back-compat (30 cum). Commits 20c23a8/6fce7ae/a5845f5.
- [03:10] T4: added headless auto-quit to 5 GUI-run suites (test-infra, TDD-exempt). FULL SWEEP: 184/184 green across 7 suites, exit 0. Test corpus now one-command CI-able. Pushed.
- [03:45] Plan2 COMPLETE via sonnet (85k tokens): hermetic test resets, unlock_hero spawns at persistent level, combat+hero-card read base_atk(), wave clears award 100 XP/hero + save. Commits 4cb162c/c4281ee/a2297ff/e1662f0. Sweep 188/188. Progression is LIVE in-game.
- [03:50] DECISION: skip pixel-cutting UI chrome from AI screens (baked text/perspective risk). HOME built from existing portraits + StyleBox theme matched to art palette; art = layout/palette truth. Cut pieces only if something specific is missing.
- [03:51] DECISION: ONE Home screen (roster grid + FORM SQUAD row + BATTLE) per home_01 art; separate squad_01 screen redundant -> dropped for P0. Boot -> Home.tscn; BATTLE -> new_session(selected squad) -> Main.tscn. In-run W3/W6 unlocks removed (squad-select replaces, per spec).
- [03:52] DECISION: fresh account = Bran+Elara owned; Vex NOT owned until the scripted pull beat (post-first-victory, pull_01 art) -> account flag pull_seen. Matches pitch beat 2.
- [04:30] Plan3 COMPLETE via sonnet (96k tokens): ensure_defaults (Bran+Elara owned), new_session(squad) param, in-run W3/W6 unlocks REMOVED, WC_AUTOSHOT capture tool, Home.tscn+home.gd (roster grid/squad-select/BATTLE). Commits b56c3b5/a0da58c/c5f294c/5e82a29. Sweep 195/195.
- [04:35] VISUAL QC (home_render.png vs home_01 art): structure+palette+logic correct (real Total Lv, owned-only cards, locked ?, disabled BATTLE). Nits logged: elara sprite purple vs ice-blue target (asset regen task, not code), dead vertical gap mid-screen (polish later). VERDICT: pass P0 bar.
- [04:36] DECISION: scripted pull triggers on FIRST W5 boss clear (not full-stage clear) — demoable in ~2min, Vex joins ROSTER (not the locked in-run squad), visible on Home after run. Result screen shows run XP + level-ups; CONTINUE -> Home. Scout intel = Home strip reading first-boss weak_tag (1-of-3 reveal per spec §6).
