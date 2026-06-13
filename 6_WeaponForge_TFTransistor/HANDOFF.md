# HANDOFF — WeaponForge TFTransistor Phase 4 (steps 15/18 done)

**Last updated:** 2026-06-13 · **Branch:** `weaponforge-tftransistor/vertical-slice` @ `6c42ee4`

## TL;DR

Phase 4 vertical slice is **15/18 steps done**. Steps 16-18 need human hands:
- Step 16: VFX + audio hooks (art assets needed)
- Step 17: 11-wave FTUE manual run (human QA)
- Step 18: AUTOSHOT visual QC (6 key beats)

All logic/data/UI code is implemented and tested green. Open in editor, test it, ship art.

## What landed this session (steps 1-15)

| Commit | Steps | What |
|---|---|---|
| `cd030cc` | 1 | AccountState v3 — `ftue_complete` + v2 migration |
| `8e9c5b1` | 2-10, 15 | Core systems — LaneState, 6 Functions, 5 Statuses, 2 Reactions, ElementMediator, CombatV2, UltController, WaveDirector, ShopV2, DebugOverlay stub |
| `6c42ee4` | 11-14 | UI scenes — BattleView_v2, ForgePanel_v2, WaveTelegraph, ChainHUD |

**Test totals (all green):**
```
TestLaneState:        29/29
TestFunctions:        45/45
TestStatuses:         35/35
TestReactions:        18/18
TestElementMediator:  10/10
TestCombatV2:          6/6
TestUltController:    11/11
TestWaveDirector:     22/22
TestShopV2:           12/12
TestUiV2:             30/30   (structural: scenes load, nodes present, signals wired)
TOTAL:               218/218
```

## What each system does

| Script | Autoload | Purpose |
|---|---|---|
| `lane_state.gd` | LaneState | Enemy dict pool, distance metric, status lifecycle, advance/knockback |
| `element_mediator.gd` | ElementMediator | Reacts damage tags against enemy statuses; emits `reaction_triggered` |
| `ult_controller.gd` | UltController | 3 reactions → +1 Ult bar (cap 3); `consume_bar()` |
| `wave_director.gd` | WaveDirector | FTUE 11-wave scripted sequence; post-FTUE all 3-wave |
| `combat_v2.gd` | CombatV2 | Locked tick loop: decay → advance → attack → react → cleanup |
| `shop_v2.gd` | ShopV2 | 7-slot slow-populate schedule + 2-stage pity counter |
| `debug_overlay.gd` | DebugOverlay | F8 = reaction log, F11 = FTUE skip, F12 = toggle |

| Scene | Script | Purpose |
|---|---|---|
| `scenes/ui/BattleView_v2.tscn` | `battle_view_v2.gd` | 3 ColorRect lane strips + enemy label sync from LaneState |
| `scenes/ui/ForgePanel_v2.tscn` | `forge_panel_v2.gd` | 3×3 socket grid + HP/Ult bars + 7-slot shop rail |
| `scenes/ui/WaveTelegraph.tscn` | `wave_telegraph.gd` | Pre-stage enemy preview overlay |
| `scenes/ui/ChainHUD.tscn` | `chain_hud.gd` | ×N reaction chain counter (auto-resets 2s) |

**Data .tres files created:**
- `data/functions/`: fire, water, lightning, aoe, leech, burst
- `data/statuses/`: burning, wet, shocked, chilled, cracked
- `data/reactions/`: steam, electrocute

## Remaining steps (16-18) — HUMAN REQUIRED

### Step 16: VFX + audio integration

**Blocker: art assets.** The system hooks are wired (`vfx_hook` + `audio_hook` fields on ReactionData). Phase 4 minimum:
- `vfx_steam_puff` on Steam reaction
- `vfx_arc_chain` + `sfx_electrocute_zap` on Electrocute
- Bran Ult art-pass (placeholder ColorRect is in ForgePanel)

You can skip art and stub placeholders for a first feel-test. If so, mark step 16 "art-deferred" and proceed.

### Step 17: 11-wave FTUE smoke test

Open Godot editor, wire `BattleView_v2.tscn` + `ForgePanel_v2.tscn` into a `Main_v2.tscn` and run the full 11-wave FTUE sequence manually. Check:
- Wave telegraph shows before each wave
- Reactions fire (Steam, Electrocute)
- Ult bar fills at correct rate
- WaveDirector serves 1/1/3/3/3 waves
- Shop rail populates correctly per Mit-D rhythm
- F11 FTUE skip works

### Step 18: AUTOSHOT visual QC

6 key beats to screenshot (use `screenshot_helper.gd` pattern):
1. Home screen
2. FTUE stage 0 (1 lane, 1 hero)
3. bran_joins cinematic (F2)
4. Active combat with reaction chain visible
5. ForgePanel mid-shop-populate
6. vex_joins cinematic (F4)

Command: `$env:WC_AUTOSHOT = "<path>.png"; & <godot.exe> --path <proj> <scene.tscn>`

## Environment

| Thing | Value |
|---|---|
| Godot binary | `C:\Godot_v4.6.2-stable_mono_win64\Godot_v4.6.2-stable_mono_win64_console.exe` |
| Project path | `C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\6_WeaponForge_TFTransistor\Prototype\godot` |
| Headless test | `<godot.exe> --headless --path <proj> res://scenes/dev/<Scene>.tscn` — exit code = failure count |
| Git root | `C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes` |
| Branch | `weaponforge-tftransistor/vertical-slice` |

## Known issues / notes

- `class_name` types (FunctionData, StatusData, ReactionData) are preload-checked in tests (`get_script() == preload(...)`) because Godot 4.6 headless mode doesn't reliably register `class_name` before autoloads parse. Works fine in editor.
- `BattleView_v2._ready()` guards `Heartbeat.ticked` with `has_signal()` — Heartbeat is a liveness pinger, not a game clock. BattleView won't auto-sync enemies until a proper tick signal is connected (Phase 5 wiring).
- `.import` autosave churn is noise — discard.
- `_archive/docs-pre-pivot-2026-06-12/` is historical only; do not reference for forward work.

## Task list state

```
#1. [completed]   Phase 2: doc redirect + freeze markers
#2. [completed]   Phase 3: spec LOCKED (function catalog + status matrix)
#3. [in_progress] Phase 4: vertical slice (15/18 steps done; steps 16-18 need human)
```

## Next chat first moves

1. Open `6_WeaponForge_TFTransistor/Prototype/godot/` in Godot 4.6 editor
2. Wire `BattleView_v2.tscn` + `ForgePanel_v2.tscn` + `ChainHUD.tscn` into a `Main_v2.tscn`
3. Run one wave manually — feel the loop
4. Step 16: decide art-stub vs real assets
5. Steps 17-18: smoke test + AUTOSHOT
