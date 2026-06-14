# HANDOFF — WeaponForge TFTransistor (forge/shop rebuild + live-bug fixes)

**Updated:** 2026-06-14 · **Branch:** `weaponforge-tftransistor/real-asset-pass` (pushed, this is CANON) · **Model context:** post-compaction resume doc.

## Read-first

- SSOT: [`docs/01_GDD.md`](docs/01_GDD.md) + the Godot build in `Prototype/godot/`.
- Engine: Godot **4.6 Mono**, binary `C:\Godot_v4.6.2-stable_mono_win64\Godot_v4.6.2-stable_mono_win64_console.exe`.
- Project path: `6_WeaponForge_TFTransistor/Prototype/godot`.
- Main scene = `res://scenes/Main_v2.tscn` (F5 boots the slice).
- Approved art SSOT (the look we build toward): `_art-build/screens/In_Battle.png` + `Forge_State.jpeg` + `keyart_01.jpeg`.
- Rebuild tracker: [`REBUILD_PLAN.md`](REBUILD_PLAN.md) (all C1–C11 done).

## Branch state

| Branch | What |
|---|---|
| `weaponforge-tftransistor/real-asset-pass` | **CANON.** Functional slice + real chibi assets + forge/shop rebuild + live-bug fixes. All work below is here. |
| `weaponforge-tftransistor/vertical-slice` | Older placeholder-art snapshot; strict ancestor of real-asset-pass. Can be fast-forwarded or retired. |
| `main` | untouched. |

User confirmed art version is canon. No merge to vertical-slice/main done yet (their call).

## How to run / test / capture

```
# headless test (exit code = failure count)
<godot> --headless --path . res://scenes/dev/<Scene>.tscn

# full sweep (15 suites, last green = 460/460)
for s in TestLaneState TestFunctions TestStatuses TestReactions TestElementMediator \
  TestCombatV2 TestUltController TestWaveDirector TestShopV2 TestUiV2 TestFtueSmoke \
  TestLoadoutV2 TestMainV2 TestSocketOrder TestFunctionPreviewData; do
  <godot> --headless --path . "res://scenes/dev/$s.tscn"; done

# AUTOSHOT (windowed, needs GL): set WC_AUTOSHOT then run a scenes/dev/AutoShot_*.tscn
$env:WC_AUTOSHOT="<abs>.png"; & <godot> --path . "res://scenes/dev/AutoShot_MainForge.tscn"

# DIAGNOSTIC auto-play (windowed, drives waves itself, prints [play] log): AutoShot_MainPlay.tscn
timeout 16 <godot> --path . res://scenes/dev/AutoShot_MainPlay.tscn
```

Godot procs go zombie under contention — `Get-Process -Name Godot_v4.6.2-stable_mono_win64_console | Stop-Process -Force` between runs. `.import` + scene-`uid` churn is noise; don't commit it.

## Architecture (the v2 slice — all on real-asset-pass)

**Autoloads (core, headless-tested, do not casually refactor):**
- `lane_state.gd` — enemy dicts, distance, status lifecycle, advance/knockback.
- `combat_v2.gd` — 5-phase tick (decay→advance(+contact dmg)→attack→react→cleanup); engaged enemy deals 1 dmg/tick to its lane hero (folded into advance, no extra log step).
- `element_mediator.gd` — reaction dispatch; emits `reaction_triggered`/`vfx_triggered`/`audio_triggered`.
- `ult_controller.gd` — 3 reactions → +1 Ult bar (cap 3).
- `wave_director.gd` — `waves_for_stage`, `enemies_for_stage_wave(stage,wave)` (post-FTUE 3 waves/stage, 5 stages; stage4 wave2 = BOSS hp30).
- `shop_v2.gd` — `cost_for(stage,tier)` (T1_BASE=[1,1,2,2,3], TIER_MULT=[1,1.4,2,2.8,4], REROLL_COST=1), `roll_items(stage,count,pity)`, `buy(item,gold)`, `reroll(gold,rollable)`, pity (`notify_stage_end`).
- `loadout_v2.gd` — 3 sockets/hero (idx 0=PASSIVE,1=MODIFIER,2=ACTIVE — flipped in C1); `apply_drop(lo,idx,id,tier,allow_merge=true)`; slice passes `allow_merge=false` → duplicate shows `{merge:"2/2"}`, no T2 bump.
- `function_data.gd` — +`active_desc/mod_desc/passive_desc/best_fit` + `describe(slot)`; 6 `.tres` populated (fire/water/lightning/aoe/leech/burst; BOUNCE has no .tres).

**UI (the rebuilt screens):**
- `scenes/Main_v2.tscn` + `main_v2.gd` — controller. State machine COMBAT/FORGE_BREAK/DONE. Composes HudBar + BattleView_v2 + ForgePanel_v2 + ChainHUD. Timer drives combat windowed (0.3s); headless tests drive `_tick_once()`/`advance_wave()` directly. Slice runs post-FTUE (3 heroes elara/bran/vex, hp 30, lanes 0/1/2; base_dmg 2; tags WATER/FIRE/LIGHTNING).
- `battle_view_v2.gd` — single field + faint 3×3 grid + hero anchors (HP bar floats ABOVE sprite, battle-only) + enemies render-snapped to 3 depth cells (`_depth_cell_for`) + status chips (dot+name) + numeric HP + reaction labels (`show_reaction_label`) + VFX layer. `set_compact(true)` → heroes lay out HORIZONTALLY (forge preview); `false` → vertical lanes. mouse_filter IGNORE.
- `forge_panel_v2.gd` — weapon rail (3 rows: portrait + PASSIVE|MODIFIER|ACTIVE socket cards (icon+name+tier stars+merge label, empty=slot-name watermark) + always-on **WeaponTooltip** on right + Ult pips) ; shop rail (7 rune cards: icon+name+cost+tier) ; footer (Gold + Re-roll + START NEXT WAVE). `set_compact` resizes sockets 64↔40. NO HP bar in rail (moved to battle). `set_weapon_desc(hero,text)`, `set_reroll_cost/enabled`, `set_next_wave_visible`.
- `chain_hud.gd` — ×N reaction badge (top strip). mouse_filter IGNORE.

## Locked design decisions (this session)
1. **Universal Transistor slots** — any Function any slot, behaves differently per 36-cell matrix. Distinction via shown behavior, NOT restriction.
2. **Socket order PASSIVE | MODIFIER | ACTIVE** (data idx 0/1/2).
3. **Shop = per STAGE** — rolls once at stage start, persists across the stage's 3 waves' forge breaks (bought slots stay empty); re-rolls only at next stage. (`_shop_populate_count` probe.)
4. **Gold = per-kill** (1g/kill in `_tick_once`), not flat-per-forge.
5. **Weapon tooltip** = always-on per-hero, shows combined ATK(active)/+MOD(modifier)/PASS(passive), real-time on equip. HP lives in battle scene only.
6. Deviations from spec (intentional, user-approved): forge-break reroll re-rolls visible unbought slots for 1g (spec §11.2 says pending-only); per-kill gold.

## Commit history (real-asset-pass, newest first)
`E1` freeze fix (ChainHUD click-eating + pause trap) + reroll visible-change ·
`D2` weapon tooltip + HP→battle + horizontal heroes + removed overlap panel ·
`D1` shop per-stage + reroll-button-path test ·
`C11` START→footer + AUTOSHOT QC · `C10` status chips+numeric HP+reaction labels+contact dmg ·
`C9` phase-adaptive layout + HP/Ult sizing + pause fix · `C8` (superseded by D2 tooltip) ·
`C6+C7` socket+shop cards · `C5` FunctionData descriptions · `C3+C4` shop economy wiring+pity ·
`C2` ShopV2 economy core · `C1` socket index flip · earlier: B1–B4 real assets, A1–A7 layout slice.

## OPEN — what the user is testing right now (last turn)
User reported live (F5) bugs: "reroll didn't get new items, 2nd wave no new items, 3rd wave enemies didn't die, nothing responsive." Diagnosed as **ChainHUD (top-strip, mouse_filter STOP, topmost) ate pause/2× clicks → pause-in-forge carried into combat → frozen → couldn't unpause (click eaten) → permanent freeze.** Fixed in E1 (overlays mouse-transparent + advance_wave unpauses + PAUSED indicator + reroll avoid-same-id). **Could NOT reproduce the exact freeze via code** (logic + auto-play run all 15 waves clean) — fix targets the strongest root cause. **Awaiting user retest.**

### If freeze persists after retest
- Get the EXACT button sequence before freeze (I can't drive live mouse).
- Suspect remaining mouse-occlusion: check any full-rect/overlapping Control with `mouse_filter != IGNORE` on top of forge footer/HUD. Use AutoShot_MainPlay to confirm logic still cycles.
- Nuclear option offered to user: remove the pause button entirely for the slice (footgun).
- Per-stage shop "no new items on wave 2" is INTENDED (user asked per-stage); user may still want per-wave refill — confirm before changing.

## Known cosmetic / deferred (not blocking)
- Status icons generated but white-bg (`assets/generated/status/*.png`) — NOT wired; battle uses colored dots. Needs bg cutout.
- 2.5D perspective faked as flat 3×3 grid (art/shader pass = Phase 5).
- Audio is stub (`_on_audio_triggered` prints). No SFX wired.
- Tiny 6-function T1-only pool → reroll options look samey by design.
- Home→Main_v2 nav not wired (main_scene jumps straight to slice).

## Next moves (suggested)
1. User retests F5 → confirm freeze gone + reroll visibly changes.
2. If good: fold decisions 1–6 into 01_GDD as a [ROADMAP] note; decide merge real-asset-pass→vertical-slice or open PR.
3. Then: feel-test pass / Phase 5 art (sprites for status, real VFX, 2.5D).
