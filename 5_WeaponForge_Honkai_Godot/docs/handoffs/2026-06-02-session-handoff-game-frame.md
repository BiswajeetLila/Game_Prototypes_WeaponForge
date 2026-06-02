# Handoff — 2026-06-02 — THE NEW GAME EXISTS (frame + loop + armory)

**Resume from exactly this point in a fresh session.** Continues `2026-06-01-session-handoff-p1a-fork.md`.

---

## TL;DR

The GDD core loop is now THE playable game in `5_WeaponForge_Honkai_Godot`:

```
HOME (pull gacha weapons → armory grid → tap-tap equip per hero, class-matched)
  → START BATTLE — STAGE N (squad of 3 enters WITH loaded weapons)
    → waves chain automatically; enemy KILLS fill a bar (5 kills)
    → bar full → combat pauses → 3 perk cards → pick one (buffs weapon THIS RUN)
    → boss on wave 5 (rotates per stage, scales) → kill: +💎, stage N+1 → HOME
                                                  → die: Reforge retry or HOME
```

Draft picks are run-scoped; pulled weapons + gems + stage are account-persistent
(`user://account.json`). 368 tests green. All work on branch
`weaponcraft-godot/wittle-inversion-phase1`, pushed, **NOT merged to main (owner
review gate, explicit hold)**.

---

## Git state (exact)

- **Branch:** `weaponcraft-godot/wittle-inversion-phase1` @ `81e7726`, synced with origin.
- **main** = `e958745` (pre-fork). Do NOT base work on main; merge waits on owner review.
- Main repo working dir (`Game_Prototypes/`) is dirty with autosave `.import` noise — leave it.
- Work happened in worktree `.claude/worktrees/pedantic-golick-94f7e8/` — if it's gone
  next session, fresh-checkout the branch anywhere; everything is pushed.

### Session-3 commits (today, newest first)
- `81e7726` armory: bench grid + tap-tap equip/swap + detail panel; pull only auto-equips empty-handed heroes
- `0c01c88` stages: rotation (slime→golem→lich) + scaling (+40% HP/+25% ATK per stage, stage 1 neutral); persists
- `c185011` layout: arena fills screen, squad cards bottom, full squad rendered in arena
- `2c94b92` kill-meter drafts: 5 kills fill bar → mid-wave pause → pick → resume; waves auto-chain
- `89e3b90` UI truth: WAVE n/5, victory/wipe modals match the 5-wave run
- `c0029f8` draft modal 0x0 fix (CanvasLayer + forced viewport rect — see Gotchas)
- `c11056e` run ends at the boss (kill boss/die → home); victory +100💎
- `95d767a` economy: save v2 invalidates pre-frame saves; 25/wave + 75 boss; reset-account button
- `98d32b0` game frame: Home↔Battle flow + post-wave draft + FTUE starter (the big rewrite)
- `234a812` forge wheel: starter catalog (3 .tres) + pull service + reveal
- `772b795` bridge: HeroState.weapon_data — combat reads pulled weapons (replacement semantics)
- `6840f87` autosave after pull/wave-earn (headless-gated)
- `47499ef` AccountState: meta-persistence + gems economy

(Session 1-2 below them: fork `b04ecc7`, Forge Math `7274b47`+`ee09437`, SkillCardData `78cdcc3`, combat interface `79b6c30`, docs/contracts `053c247`/`2daea91`.)

---

## Architecture — who owns what

**Autoloads (project.godot order):** GameState, ScreenshotHelper, RNG, Recipes, Merge,
Shop, Combat, ScreenShake, HitPause, Heartbeat, SignalTrace, **AccountState, ForgeWheel, ForgeDraft**.

| File | Owns |
|---|---|
| `scripts/core/account_state.gd` | ACCOUNT layer: gems, owned_weapons (duplicate(true) instances), equipped{hero→idx}, current_stage. JSON save v2 `user://account.json`, validate-then-commit loads, autosave (headless-gated). Class-guarded `equip()`, `unequip()`, `advance_stage()`, `award_victory()`, `reset_account()`. Economy: 600 start, 25/wave+75 boss+100 victory = 300/cleared run = 1 pull (PULL_COST 300). |
| `scripts/core/forge_wheel.gd` | `pull()`: spend → class-filtered catalog pick → acquire → auto-equip ONLY if hero empty-handed else bench. Global reveal overlay (`show_reveal(result)`). |
| `scripts/core/forge_draft.gd` | Draft service + KILL METER: `sync_dead_count()` diffing, KILLS_PER_DRAFT=5, overflow banks via `consume_draft()`, `reset_wave_baseline()/reset_run()`; `deal(n)` axis-distinct stat cards (atk_flat+4/atk_pct+20%/crit+6/ult_rate+6/hp_flat+25), `apply()` → hero.run_mods + run_card_count. |
| `scripts/core/combat.gd` | Tick loop (unchanged core) + feeds meter after step/ult + stage helpers: `stage_hp_mult/stage_atk_mult` (1.0 at stage 1!), `boss_for_stage` rotation; wave-5 boss stage-aware, waves 10/15 legacy map. |
| `scripts/core/game_state.gd` | Run state. NEW: `run_stage` (set from AccountState at battle start, reset 1 by new_session), `RUN_FINAL_WAVE=5`, `weapons_by_id` catalog, `combat_stat_source` toggle (AUTO/LEGACY_ONLY/PULLED_ONLY/ADDITIVE), `equip_weapon_data()` + `weapon_data_changed` signal. |
| `scripts/data/hero_state.gd` | `weapon_data` (pulled, REPLACES socket stats under AUTO), `eff_atk/crit/ult_rate/hp_bonus/tags()` (combat reads these), `run_mods` + `apply_run_mod()` (draft buffs, die with run), `run_card_count` (pips), HP rule: weapon_data path = clamp-never-refill (no swap-heal); legacy keeps +delta. |
| `scripts/data/weapon_data.gd` | Unitary weapon: stats, ★ scaling, combat interface, Forge Math ladder w/ `forge_target_idx` bank + Mythic cap (READY but dupes don't feed it yet — next step). |
| `scripts/data/skill_card_data.gd` | Draft card schema (4 hero-tagged types). |
| `scripts/ui/home_screen.gd` | META screen: roster rows (equipped weapons, tappable), ARMORY bench grid (rarity tiles, dashed empties, scroll>6), detail panel, squad element-trio line, pull btn, START BATTLE — STAGE N, reset-account debug, FTUE starter grant. |
| `scripts/ui/main.gd` | Battle flow: `_start_run` (new_session + unlock all 3 + equip from account + run_stage + stage banner), kill bar UI, weapon strip + pips, draft modal on meter_full (pause/resume), wave auto-chain, victory→advance_stage→result→Home, retry refights. RUN_FINAL_WAVE=5. |
| `scripts/ui/draft_modal.gd` | 3-card overlay (CanvasLayer 100, viewport-forced rect). |
| `scripts/ui/battle_view.gd` | Arena renders FULL squad column (dims dead); legacy single portrait hidden. |
| `scenes/Home.tscn` | Main scene (project boots here). `Main.tscn` = battle (VBox bottom-inset 48px for strip; BattleView expand). |
| Legacy (`weapon.gd` sockets, shop/merge/forge_panel) | ALIVE for the 144-test legacy contract only; invisible in the new game. Retirement = migration plan stages 9a-e. |

## Test matrix — 368 green

| Suite | Tests | Headless quit |
|---|---|---|
| TestCombat | 65 | needs `--quit-after 400` |
| TestRecipes / TestShop / TestMerge / TestUi | 18/26/22/21 | needs `--quit-after 400` |
| TestWeaponData | 50 | self-quits (exit=fails) |
| TestSkillCardData | 14 | self-quits |
| TestAccountState | 53 | self-quits |
| TestWeaponBridge | 27 | self-quits |
| TestForgeWheel | 26 | self-quits |
| TestForgeDraft | 26 | self-quits |

Runner: `C:/Godot_v4.6.2-stable_mono_win64/Godot_v4.6.2-stable_mono_win64_console.exe --headless --path 5_WeaponForge_Honkai_Godot/Prototype/godot res://scenes/dev/<Scene>.tscn`

## Gotchas (hard-won — read before touching)

1. **Cold clone needs a full import pass first** (`--headless --import --path <godot dir>`) else `.tres` textures fail and catalogs come up empty (false test failures).
2. **Runtime-built Controls under Main/CanvasLayer lay out 0x0** from anchor presets alone — force `position`+`size` from `get_viewport_rect()` (draft modal bug; pattern now in main.gd `_build_battle_overlay`).
3. Headless `--quit-after` counts FRAMES but combat timers are real-time — battle smokes need `timeout <secs>` real time, not frame counts.
4. `.import` autosave churn = noise (K-12): discard, don't commit. `.godot/` is gitignored.
5. Stage-1 multipliers MUST stay exactly 1.0 — the 65-test combat contract depends on it.
6. Save schema: v2 + optional `stage` key. Breaking changes → bump SAVE_VERSION (old saves then boot fresh, by design).

## Known rough edges (deliberate, v1)

Programmer-art UI everywhere · no audio assets (2nd feedback channel = log lines) ·
no spin cinematic · **dupes are dumb** (a re-pull of the same weapon = second copy on the
bench; Forge Math ladder is built+tested but unfed) · draft cards = 5 stat axes only
(no elemental/ability transforms) · reveal doesn't block battle HUD interactions ·
Catalyst line shows trio only (P1e) · enemy curve beyond stage ~3 untuned.

## NEXT STEPS (owner-agreed queue)

1. **Wheel cinematic + dupes→Forge Math** ← next up. Spin (anvil-strike reel stops, skippable ≤0.6s), dupe pull feeds `apply_forge_part` (tier meter, rarity jumps, bank-retarget warning per entry contract #6) instead of stacking bench copies.
2. **Elemental/ability draft cards** — rune cards (change/strengthen element vs enemy weak/resist), ability transforms; makes boss 5-card drafts meaningful (FM-2).
3. **P1f Hot Paladin tease** — hero-attachment anchor (FM-8).
4. **Catalyst compounds (P1e)** — squad element-pair synergy; THEN migration stages 9a-e (retire sockets/shop/merge + ~80 legacy tests; contracts in `docs/2026-06-01-combat-weapon-migration-plan.md`).
5. Human gates: Bran 5-tier portrait eval (20 Honkai players), "Catalyst" trademark check.
6. When owner approves: merge phase1 → main.

*Closed 2026-06-02. 368 green, branch pushed @ 81e7726, main untouched.*
