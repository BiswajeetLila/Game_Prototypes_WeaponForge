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
- `shop_v2.gd` — `cost_for(stage,tier)` (T1_BASE=[1,1,2,2,3], TIER_MULT=[1,1.4,2,2.8,4]), `reroll_cost_for(stage)`=2×base, `roll_items(stage,count,pity)`, `buy(item,gold)`, `reroll(gold,cost)` (gold-gated), `populate_schedule_3wave` (the 2/3/2 drip), pity (`notify_stage_end`).
- `loadout_v2.gd` — 3 sockets/hero (idx 0=PASSIVE,1=MODIFIER,2=ACTIVE — flipped in C1); `apply_drop(...)` (legacy path; equip now goes through `reserve_v2`).
- `reserve_v2.gd` *(not an autoload — pure static, preloaded)* — 2 reserve slots/hero; `equip` (place/merge/displace/blocked-full), `equip_from_reserve` (bench↔socket swap), `sell_value`/`sell_socket`/`sell_reserve` (floor-50%). Socket+reserve entries carry `cost`.
- `function_data.gd` — +`active_desc/mod_desc/passive_desc/best_fit` + `describe(slot)`; 6 `.tres` populated (fire/water/lightning/aoe/leech/burst; BOUNCE has no .tres).

**UI (the rebuilt screens):**
- `scenes/Main_v2.tscn` + `main_v2.gd` — controller. State machine COMBAT/FORGE/DONE. **Forge per stage, auto-battle waves** (`_on_wave_cleared` auto-advances within a stage; opens forge at the boundary). Shop slow-populates via `_reset_stage_shop`/`_drip_shop_for_wave`. Equip via `reserve_v2` (`_on_socket_tap` buy+equip-with-displacement; `_on_reserve_tap` bench pickup; `_on_socket_sell`/`_on_reserve_sell`; `_sync_hero_forge` pushes sockets+reserve to the panel). Timer drives combat windowed (0.3s); headless tests drive `_tick_once()`/`advance_wave()` directly. Slice = post-FTUE (3 heroes elara/bran/vex, hp 30, lanes 0/1/2; base_dmg 2; tags WATER/FIRE/LIGHTNING).
- `battle_view_v2.gd` — single field + faint 3×3 grid + hero anchors (HP bar floats ABOVE sprite, battle-only) + enemies render-snapped to 3 depth cells (`_depth_cell_for`) + status chips (dot+name) + numeric HP + reaction labels (`show_reaction_label`) + VFX layer. `set_compact(true)` → heroes lay out HORIZONTALLY (forge preview); `false` → vertical lanes. mouse_filter IGNORE.
- `forge_panel_v2.gd` — weapon rail (3 rows: portrait + ult pips + 3 PASSIVE|MODIFIER|ACTIVE socket cards + one-line **weapon desc UNDER the sockets** (MidCol) + **Reserve bench (2 slots)** on the right, "Reserve" header) ; shop rail (7 rune cards) ; footer (Gold + Re-roll + START). Sockets+reserve use a **tap/long-press gesture** (`button_down`/`button_up`, hold≥500ms = sell). Signals: socket_tapped, shop_item_tapped, reserve_tapped, socket_sell, reserve_sell, reroll_tapped, start_next_wave. Methods: set_socket_fn, set_reserve_item, set_weapon_desc, flash_error, set_compact (sockets 64↔40), set_hero_ult_bars, set_reroll_cost/enabled, set_next_wave_visible. Matches `Forge_State_edits.jpg`. NO HP bar (battle only).
- `chain_hud.gd` — ×N reaction badge (top strip). mouse_filter IGNORE.

## Locked design decisions
1. **Universal Transistor slots** — any Function any slot, behaves differently per 36-cell matrix. Distinction via shown behavior, NOT restriction.
2. **Socket order PASSIVE | MODIFIER | ACTIVE** (data idx 0/1/2).
3. **Forge = per STAGE (not per wave).** Waves auto-battle continuously inside a stage; the forge/equip break is the stage boundary (F0 open + after each stage). `_on_wave_cleared` auto-advances within a stage. *(G1 — superseded the earlier per-wave forge + F1's full-shop-at-open.)*
4. **Shop: FULL (7) at world start / F0; slow-populates 2/3/2 within each stage** (full again at every stage break). `_reset_stage_shop(full)` + `_drip_shop_for_wave`. *(G1 + G6 — F0-full per user; slow-populate is the within-stage rhythm.)*
5. **Gold = per-kill** (1g/kill in `_tick_once`), not flat-per-forge.
6. **Reserve bench = 2 slots/hero** (`reserve_v2.gd`). Buying onto an occupied socket → displace old to reserve; same id+tier → **merge = tier bump (T1→T4, cap 4)**; reserve full → blocked + red flash, no charge. *(G2/G3; merge-bump G13 — lifted the '2/2' stub.)*
7. **Free tile movement, hero-agnostic** (`forge_grid.gd`): tap any owned tile (socket/reserve, any hero) to pick up, tap any other to drop — empty=move, same=merge, occupied=swap; no gold. Unified `_held` pick/drop in main_v2. *(G5.)*
8. **Sell = double-click** an owned socket/reserve (floor-50% refund). Single tap = pick up/drop. *(G5 — was long-press.)*
9. **Re-roll = fresh full board of 7** (the whole list); price = `2× T1 base` scaled by stage. *(G6.)*
10. **Ult button** per hero (fills with charge, 3 reactions/bar; "ULT!" + enabled at full; press consumes; Ult effect = Phase 5). `ult_pressed` signal. *(G7.)*
11. **Weapon description** = one line UNDER each hero's sockets (combined ATK/+MOD/PASS), real-time; right-side tooltip removed. HP floats above sprites in the battle scene only. *(D2/G3.)*
12. Layout SSOT: combat = `In_Battle.png`; forge = `Forge_State_edits.jpg` (the edited one with the Reserve column).
13. **Item icons** = flat-bold transparent set in `assets/generated/runes/` (fire/water/lightning/aoe/leech/burst), each a **distinct silhouette** (round/rounded-square/diamond/hexagon/shield/octagon). Generated nano-banana, white-cut via `cut_icon_bg.gd`; bake-off tests in `_art-build/icons/_archive`. Shop/socket cards = **icon-top + name-below + cost badge** (no overlap). *(G12.)*
14. **Tier rarity borders, in-engine** (no per-tier art): slot frame recolors by tier T1 neutral / T2 blue / T3 purple / T4 gold (`forge_panel._apply_tier_border` + `TIER_BORDER`). *(G12; live via merge-bump G13.)*
15. **Combat juice** (`battle_view`): HP-delta-driven hit-flash + impact burst on enemies (+ attacking-hero pulse) and on heroes; merge sparkle+pop on socket. VFX reused from 5_project. Status = bg-cut element icons (`status/*_cut.png`). *(G9/G11.)*
16. **Boot = HomeV2** (title + PLAY → Main_v2). Run end: cleared all stages = VICTORY; all heroes dead = DEFEAT (permadeath). Result overlay → Play Again / Home. *(G10.)*
17. **Combat arena squeezed** (0.06–0.54) so the rail isn't cramped; battle shows icons only (no enemy/hero name/number text). *(G8.)*

## Commit history (real-asset-pass, newest first)
`G13` merge bumps tier T1→T4 (rarity borders go live) ·
`G12` readable item icons (varied shapes) + icon-top/label-below cards + tier borders ·
`G11` status icon cutouts (transparent) wired into battle ·
`G10` HomeV2 + run-end VICTORY/DEFEAT result + permadeath ·
`G9` combat hit VFX (flash/impact/pulse) + merge sparkle ·
`G8` squeeze combat arena + icons-only battle (declutter) ·
`G5` any-tile moves (forge_grid) + double-click sell + F0-full shop + reroll-whole-list + Ult button (G5-G7 bundled) ·
`G4` docs (GDD/HANDOFF) + forge re-sync hardening ·
`G3` forge layout = Forge_State_edits.jpg (Reserve column + under-row desc + sell + error flash) ·
`G2` Reserve bench logic (`reserve_v2.gd`): equip-displacement / merge / blocked-full / sell / bench-reequip + main_v2 wiring ·
`G1` forge per STAGE + auto-battle waves + slow-populate 2/3/2 ·
`F1` open run in FORGE (equip first) + reroll cost scaling ·
`E1` freeze fix (ChainHUD click-eating + pause trap) + reroll visible-change ·
`D2` weapon tooltip + HP→battle + horizontal heroes + removed overlap panel ·
`D1` shop per-stage + reroll-button-path test ·
`C11` START→footer + AUTOSHOT QC · `C10` status chips+numeric HP+reaction labels+contact dmg ·
`C9` phase-adaptive layout + HP/Ult sizing + pause fix · `C8` (superseded by D2 tooltip) ·
`C6+C7` socket+shop cards · `C5` FunctionData descriptions · `C3+C4` shop economy wiring+pity ·
`C2` ShopV2 economy core · `C1` socket index flip · earlier: B1–B4 real assets, A1–A7 layout slice.

## OPEN — awaiting user F5 retest of G1–G3
The E1 freeze is resolved (user confirmed "reroll works"). Current build to retest:
- **Loop:** opens in FORGE (F0, 2 shop items), START → stage auto-battles all 3 waves continuously (no inter-wave stop), shop drips 2/3/2, stage-end forge break shows the full board → equip → START next stage. 6 forge breaks F0–F5.
- **Reserve/sell:** equip onto an occupied socket benches the old item; bench full → red flash + no charge; tap a benched item then a socket to re-equip; **long-press ~0.5s** a socket/reserve item to sell (50% refund).
- The reserve/sell GESTURES are UI-only (not exercised by headless tests — the handlers + pure logic ARE tested). **Long-press is release-timed** (decided on button release), not held-fire — confirm it feels right.

## Session gotchas / trials (engineering — for future me)
- **Shell auto-backgrounding + stdout encoding:** PowerShell `*>` writes UTF-16 (Select-String saw garble); the harness also auto-backgrounded long Godot runs. **Fix that worked:** Bash tool, redirect Godot `> file 2>&1`, then Read the file (plain UTF-8). Use a known absolute Windows path for the out-file.
- **Parse error masks the whole suite:** a renamed test fn left a stale `_ready` call → `SCRIPT ERROR: Parse Error ... not found` → exit 255, ZERO test output (looked like "no RED"). Always check for `SCRIPT ERROR/Parse Error` in the grep, and if a suite emits nothing, suspect a parse error before assuming pass.
- **Clean RED for a new module:** write the test + a COMPILING stub (functions return defaults) → run for clean per-assertion RED → fill in. (Preloading a missing script = parse error, not clean RED.) For an in-place behavior change, retroactive RED via `git stash push -- <file>` (path-scoped) then run then `git stash pop` — note pop prints the full `.import` churn `git status`, that's noise.
- **`pressed` → gesture migration breaks tap tests:** sockets moved from Button `pressed` to `button_down`/`button_up` (for long-press). Tests that did `tap.pressed.emit()` must do `button_down.emit(); button_up.emit()`.
- **const Arrays/Dicts are READ-ONLY in Godot 4** (still true): combat writes `hero["hp"]`; any test feeding heroes from a `const` array must `.duplicate(true)`.
- **`Time.get_ticks_msec()`** is fine in Godot runtime (used for the long-press timing) — unrelated to the Workflow-script `Date.now` ban.

## Known cosmetic / deferred (not blocking)
- Status icons generated but white-bg (`assets/generated/status/*.png`) — NOT wired; battle uses colored dots. Needs bg cutout.
- 2.5D perspective faked as flat 3×3 grid (art/shader pass = Phase 5).
- Audio is stub (`_on_audio_triggered` prints). No SFX wired.
- Tiny 6-function T1-only pool → reroll options look samey by design.
- Home→Main_v2 nav not wired (main_scene jumps straight to slice).

## Next moves (suggested)
1. User retests F5 → confirm the per-stage loop + slow-populate drip + reserve/sell (long-press) feel right.
2. Decide merge real-asset-pass→vertical-slice or open PR (still not merged; their call).
3. Feel-test pass / Phase 5 art (status sprites, real VFX, 2.5D). Wave-telegraph still [ROADMAP].
4. Possible polish: true held-fire long-press (currently release-timed); reserve slot art (circles); sell confirmation toast.
