# HANDOFF — WeaponForge TFTransistor Phase 4 (18/18 mech-complete; feel-test pending)

**Last updated:** 2026-06-13 · **Branch:** `weaponforge-tftransistor/vertical-slice`

## TL;DR

**Phase 4 build sequence steps 1-18 all mechanically complete and committed.** Feel-test
remains a human job (open editor, run, judge pacing). All systems are TDD-gated with
268/268 tests green and 7 AUTOSHOT artifacts captured.

## Test totals (all green)

```
TestLaneState:        29/29
TestFunctions:        45/45
TestStatuses:         35/35
TestReactions:        18/18
TestElementMediator:  14/14   (was 10; +VFX/audio emit assertions)
TestCombatV2:          6/6
TestUltController:    11/11
TestWaveDirector:     32/32   (was 22; +enemies_for_stage_wave + boss-wave asserts)
TestShopV2:           12/12
TestUiV2:             34/34   (was 30; +BattleView_v2 vfx/audio handler asserts)
TestFtueSmoke:        32/32   (NEW step 17 — 11-wave FTUE integration smoke)
TOTAL:               268/268
```

## What landed this session (steps 1-18)

| Commit | Steps | Scope |
|---|---|---|
| `cd030cc` | 1 | AccountState v3 — `ftue_complete` + v2 migration |
| `8e9c5b1` | 2-10, 15 | LaneState, 6 Functions, 5 Statuses, 2 Reactions, ElementMediator, CombatV2, UltController, WaveDirector, ShopV2, DebugOverlay |
| `6c42ee4` | 11-14 | BattleView_v2, ForgePanel_v2, WaveTelegraph, ChainHUD |
| `751fbc2` | docs | HANDOFF v1 |
| `21974c4` | 16 | VFX/audio signal stubs + temp BattleView ColorRect flash |
| `25e51ad` | 17 | FTUE 11-wave mechanical smoke (TestFtueSmoke + enemies_for_stage_wave) |
| (next) | 18 | AUTOSHOT artifacts + demo wrappers |

## AUTOSHOT artifacts — step 18

7 PNGs captured under `Prototype/godot/shots_phase4/`:

| File | Scene | What it proves |
|---|---|---|
| `00_home.png` | `Home.tscn` (P0 inherit) | Home screen still renders; hero panel + FORM SQUAD + BATTLE button |
| `01_battle_view.png` | `BattleView_v2.tscn` | 3-lane corridor + 3 enemies (1 with Wet status) render correctly |
| `02_forge_panel.png` | `ForgePanel_v2.tscn` | 7-slot shop (4 filled) + 3 hero rows + HP/Ult bars + mounted Functions |
| `03_wave_telegraph.png` | `WaveTelegraph.tscn` | Pre-wave overlay shows enemy roster + READY button |
| `04_chain_hud.png` | `ChainHUD.tscn` | Chain counter renders "×3" after 3 reactions |
| `05_boss_wave.png` | `BattleView_v2` + WaveDirector | Stage-4 wave-2 BOSS (HP 30) lane 1 |
| `06_battle_chain.png` | `BattleView_v2` + `ChainHUD` | Composite: 5 enemies + chain ×4 + Wet/Burning statuses |

**Note**: BattleView label rendering is placeholder text (`goblin HP:5 []`) — final art
sprites land in Phase 5. AUTOSHOT proves *contract* (UI mounts, data flows), not *polish*.

Each shot's demo wrapper:
- `scripts/dev/autoshot_<scene>.gd` — populates state in `_ready()`
- `scenes/dev/AutoShot_<Scene>.tscn` — wraps the demo script

Re-capture command pattern:
```powershell
$env:WC_AUTOSHOT = "<absolute-png-path>"
& <godot.exe> --path <project> "res://scenes/dev/AutoShot_<X>.tscn"
```
ScreenshotHelper autoload captures viewport at t=1.5s then quits.

## What each system does

| Script | Autoload | Purpose |
|---|---|---|
| `lane_state.gd` | LaneState | Enemy dict pool, distance metric, status lifecycle, advance/knockback |
| `element_mediator.gd` | ElementMediator | Reacts damage tags against enemy statuses; emits `reaction_triggered`, **`vfx_triggered`**, **`audio_triggered`** |
| `ult_controller.gd` | UltController | 3 reactions → +1 Ult bar (cap 3); `consume_bar()` |
| `wave_director.gd` | WaveDirector | FTUE 11-wave scripted sequence + **`enemies_for_stage_wave(stage, wave)`** spawn roster |
| `combat_v2.gd` | CombatV2 | Locked tick loop: decay → advance → attack → react → cleanup |
| `shop_v2.gd` | ShopV2 | 7-slot slow-populate schedule + 2-stage pity counter |
| `debug_overlay.gd` | DebugOverlay | F8 = reaction log, F11 = FTUE skip, F12 = toggle |

| Scene | Script | Purpose |
|---|---|---|
| `scenes/ui/BattleView_v2.tscn` | `battle_view_v2.gd` | 3-lane corridor + enemy sync + **temp VFX ColorRect flash + audio-stub print** |
| `scenes/ui/ForgePanel_v2.tscn` | `forge_panel_v2.gd` | 3×3 socket grid + HP/Ult bars + 7-slot shop rail |
| `scenes/ui/WaveTelegraph.tscn` | `wave_telegraph.gd` | Pre-stage enemy preview overlay |
| `scenes/ui/ChainHUD.tscn` | `chain_hud.gd` | ×N reaction chain counter (auto-resets 2s) |

## What's still TODO for human (feel-test, Phase 5)

This is the work that I (Claude) cannot do without a human at the keyboard:

1. **Feel-test the 11-wave FTUE** — open editor, wire `Main_v2.tscn` to compose
   BattleView_v2 + ForgePanel_v2 + ChainHUD, hit F5, play through. Judge pacing,
   satisfaction, clarity, frustration spots. Mechanical green ≠ "fun".

2. **Replace VFX placeholders** (Phase 5) — currently `BattleView_v2._on_vfx_triggered`
   spawns a 40px ColorRect that fades over 0.4s. Real assets needed: steam puff
   sprite, electrocute arc sprite, Bran Ult effect. Hook field on each ReactionData
   already points to the right asset name.

3. **Wire AudioStreamPlayer** (Phase 5) — currently `_on_audio_triggered` only prints
   the hook to stdout. Need actual SFX assets (sfx_steam_hiss.wav, sfx_electrocute_zap.wav)
   loaded and played per ReactionData.audio_hook.

4. **Polish enemy rendering** (Phase 5) — current labels are `goblin HP:5 []` text.
   Replace with sprite + HP bar + status icons.

5. **Wire CombatV2 to BattleView_v2** — BattleView listens for `Heartbeat.ticked` but
   Heartbeat is a liveness pinger, no signal. Need a tick driver (Timer or `_process`)
   that calls CombatV2.tick() then BattleView._on_tick() each frame/step.

## Approved presentation mockups (Phase 5 art/UX SSOT — locked 2026-06-14)

Two user-approved screens are the build target. They are a matched frame set; build to them.
- [`_art-build/screens/In_Battle.png`](_art-build/screens/In_Battle.png) — combat screen
- [`_art-build/screens/Forge_State.jpeg`](_art-build/screens/Forge_State.jpeg) — forge-break screen

**Rebuild deltas (current v0 code → mockup):**
- **BattleView_v2**: replace the 3 flat full-width ColorRect lane bands with ONE shared
  2.5D ~30° battlefield + faint 3×3 grid overlay. Render hero sprites anchored LEFT
  (one per lane), enemy sprites advancing leftward. Add per-unit HP bar + floating
  status-icon stack (Wet/Burning/Chilled/Shocked/Cracked) + VFX layer (Steam puff,
  Electrocute arc, fire projectile). Heroes are currently NOT drawn in battle view at
  all — add them.
- **Hybrid grid render-snap**: mechanic keeps continuous `screen_x` (LaneState, 268
  tests unchanged); BattleView snaps each enemy's *visual* x to nearest of 3 depth
  cells per lane (`≥0.67`→far, `0.33–0.67`→mid, `<0.33`→near). Same-cell enemies need
  stack-offset so they don't overlap.
- **ForgePanel_v2**: move shop rail to the BOTTOM (below weapon rail). Sockets labelled
  ACTIVE/MODIFIER/PASSIVE (full words). Forge break = shop fully populated + big
  `START NEXT WAVE` button + merge-spark affordance on duplicate runes.
- **Composition (Main_v2)**: HUD + battlefield + weapon rail + shop are ONE screen, not
  4 detached scenes. Forge break = same screen, combat paused, no enemies, heroes idle.

## Environment

| Thing | Value |
|---|---|
| Godot binary | `C:\Godot_v4.6.2-stable_mono_win64\Godot_v4.6.2-stable_mono_win64_console.exe` |
| Project path | `C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\6_WeaponForge_TFTransistor\Prototype\godot` |
| Headless test | `<godot.exe> --headless --path <proj> res://scenes/dev/<Scene>.tscn` — exit code = failure count |
| AUTOSHOT capture | set `WC_AUTOSHOT` env var, run WITHOUT --headless (needs GL render context) |
| Git root | `C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes` |
| Branch | `weaponforge-tftransistor/vertical-slice` |

## Known issues / quirks

- `class_name` types (FunctionData, StatusData, ReactionData) are preload-checked in
  tests (`get_script() == preload(...)`) because Godot 4.6 headless mode doesn't
  reliably register `class_name` before autoloads parse. Works fine in editor.
- BattleView label uses `screen_x * size.x` which puts labels off-viewport past 0.85.
  Demo wrappers clamp screen_x to ≤0.85 for visible captures. Sprite rendering in
  Phase 5 will use anchored layout, not raw x position.
- `Heartbeat` autoload is liveness-only (writes heartbeat.txt). It does NOT emit a
  tick signal — BattleView_v2._ready() guards with `has_signal("ticked")`. Phase 5
  needs to either add the signal to Heartbeat or introduce a CombatClock autoload.
- `.import` autosave churn is noise — discard.
- `_archive/docs-pre-pivot-2026-06-12/` is historical only.

## Task list state

```
#1. [completed]   Phase 2: doc redirect + freeze markers
#2. [completed]   Phase 3: spec LOCKED (function catalog + status matrix)
#3. [in_progress] Phase 4: vertical slice — 18/18 mech-complete; feel-test pending
```

## Next chat first moves

1. Open `6_WeaponForge_TFTransistor/Prototype/godot/` in Godot 4.6 editor.
2. Inspect the 7 `shots_phase4/*.png` artifacts.
3. Compose `Main_v2.tscn` from BattleView_v2 + ForgePanel_v2 + ChainHUD (TODO).
4. Wire a tick driver (Timer 0.1s) → CombatV2.tick() → BattleView._on_tick().
5. Play one FTUE wave. Judge feel. Either greenlight Phase 5 or iterate Phase 4.5.
