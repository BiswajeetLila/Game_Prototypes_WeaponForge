# HANDOFF — WeaponForge TFTransistor (forge/shop rebuild + live-bug fixes)

**Updated:** 2026-06-16 · **Active work branch:** `weaponforge-tftransistor/post-slice-phase5`. · **Current focus: a DESIGN REDESIGN brainstorm (paused for resume) — see the next section.** Shipped build below (slice + Phase-5 Q1–Q6) is the working baseline. · post-compaction resume doc.

## 🎨 DESIGN REDESIGN brainstorm — IN PROGRESS, paused 2026-06-16 (← RESUME HERE)

**What this is:** a from-the-research rethink of the **core gameplay + craft**, well beyond the shipped prototype. The shipped build (3-lane auto-runner + flat 3-socket forge + Q1–Q6) is now the **baseline to evolve from, not the target.** **No new code started** — this is design only.

**One-line state:** moat = **the CRAFT is the engagement** (Magicka reactions are *visual payoff*, not the hook); positioning = **GD-derived casual + TFT shop + Transistor/Magicka twist**; **tentative craft = "hero-as-frame": each hero is a silhouette, you clip element-parts onto attach-nubs, and adjacency authors reactions** (gacha heroes = new layouts).

**Read these to resume, in order:**
1. [`docs/superpowers/specs/2026-06-15-prototype-direction-design.md`](docs/superpowers/specs/2026-06-15-prototype-direction-design.md) — strategic spine + the **2026-06-16 update** + the **decision ledger** (✅ approved / 🟡 tentative / ⏳ pending).
2. [`docs/superpowers/specs/2026-06-16-craft-mechanic-options-ranked.md`](docs/superpowers/specs/2026-06-16-craft-mechanic-options-ranked.md) — ~30 craft metaphors ranked, the chosen "skeleton attach-points," + **7 open sub-questions** to develop it.

**Resume sequence:** develop the craft mechanic (answer the 7 sub-Qs) → **Items/Synergies/Catalysts** deep brainstorm (define "catalyst") → **Wittle-meta** lift (Layer-2 retention) → balance → full spec → `writing-plans` → **moat-first** TDD build (craft toy + reaction legibility/juice + FTUE before wide content).

**Suggested skills on resume:** `brainstorming` (continue), `game-design` (mechanic eval), later `writing-plans`.

**Research base used (in `docs/research/reference-games/`):** TFT ×2, Transistor ×4, Magicka, Gear Defenders, Wittle Defender. Transistor's "one part / 3 roles + MEM budget + forced-recombination pressures + lore-unlock-by-using-all-3-roles" and GD's "casual spatial craft" are the load-bearing borrows.

## ⭐ Phase-5 content batch (Q1–Q5) — autonomous overnight build, 2026-06-15

Built unattended on `post-slice-phase5`, each TDD'd (RED→GREEN), committed per-issue, then an **adversarial-review workflow** (6 read-only reviewers + per-finding verifiers, 27 agents) surfaced 5 real spec-fidelity gaps which were also fixed (Q6, TDD'd). Final headless sweep = **799 passed / 0 failed across 17 suites** (was 587). GitHub issues [#3](https://github.com/BiswajeetLila/Game_Prototypes_WeaponForge/issues/3)–[#7](https://github.com/BiswajeetLila/Game_Prototypes_WeaponForge/issues/7) track Q1–Q5.

| Q | Issue | What landed | Commit |
|---|---|---|---|
| Q1 | #3 | Full **15-reaction** Magicka matrix + 3 aux statuses (Blind/Frozen/Bleed); `element_mediator` priority + Cracked-passenger rule; `apply_origin`/`consume_cracked`/`knockback` on ReactionData | `7785806` |
| Q2 | #4 | Full **12-Function** catalog (added ICE/EARTH/BEAM/BOUNCE/SEEKER/KNOCKBACK); `combat_targeting.gd` resolver; `combat_v2` Function-driven attack (stub fallback = no regression); `main_v2` pushes equipped Active into combat | `f69bc09` |
| Q3 | #5 | **Tier stat scaling** T1–T5 (1.0/1.4/2.0/2.8/4.0) into combat damage; `tier_scale.gd`; merge bump now changes damage | `1ed5881` |
| Q4 | #6 | **Hero Ults fire** real §12 effects (Bran Leap / Elara Storm / Vex Strike); consume 1 bar / refund-on-empty; button now usable at **≥1 bar** (was full=3) | `9f0dd84` |
| Q5 | #7 | **Wave telegraph** wired — `wave_director.telegraph_for_stage` + INTEL HUD button + `wave_telegraph.show_stage`; enemy weak/resist tags | `94785a6` |
| — | — | GDD synced to Q1–Q5 | `6a77ec5` |
| Q6a | review | **F1** reaction `dmg_mult` now dealt as damage (× Cracked amp); **F2** per-tick status DoT (Burning −2 / Shocked −1 / Bleed 5%); **F3** Freeze Solid's Frozen now halts advance | `2a42311` |
| Q6b | review | **F4** reaction splash (`apply_splashed`) applied to cross-lane/own-lane neighbours (Steam Blind, Electrocute Wet-only arc, …); **F5** Modifier socket warps the Active (`mod_dmg_bonus` + `mod_adds_tag` secondary reaction + `mod_applies_status`) | `d44969a` |

**Adversarial review:** the 27-agent review workflow flagged that the green Q1–Q5 sweep masked 5 spec gaps (tests asserted *data shape*, never the combat *effect*). All 5 confirmed-real and fixed in Q6 with effect-level tests. The review output is archived in the run transcript; net result = reactions/statuses/modifiers now actually *do something* in combat, which matters for the playtest.

**New core modules:** `combat_targeting.gd` (targeting resolver), `tier_scale.gd` (tier mult). **Extended:** `reaction_data.gd`, `status_data.gd` (`hp_dmg_pct_per_tick` for Bleed), `lane_state.gd` (`consume_status_stack`), `function_data.gd` (`active_max_hits`, `active_knockback`), `element_mediator.gd`, `combat_v2.gd`, `ult_controller.gd`, `wave_director.gd`, `wave_telegraph.gd`, `main_v2.gd`, `forge_panel_v2.gd`.

**Known follow-ups (faithful — flagged, NOT silently skipped). After Q6, the combat math is live; these remain:**
- **6 new Functions have no rune-icon PNG** → render name-only in the shop (icon-top card falls back). Needs an art pass (nano-banana, ~$0.04 each — user must OK the spend per the image-cost policy).
- **Passive auras still data-only:** wired combat = each Function's **Active** + **Modifier** (Q6 F5) + tier scaling. Passive-slot traits (Echo proc, Long Sight, Frost Field, Tectonic Plate HP, Executioner, etc.) are described in the `.tres` but not applied. Also **Modifier-warps-base-weapon when the Active socket is empty** is not wired (base attack path doesn't read `mod_fn`).
- **Reaction splash DAMAGE + cleanse-on-splashed:** Q6 F4 applies splash *statuses* to neighbours (Blind/Shocked/etc.) but not the reaction's bonus *damage* to splashed enemies, nor "cleanse Wet on arced" — status splash is in, damage splash is the remaining bit.
- **Enemy attack-skip (Blind/Frozen `skip_attack_chance`, Shocked 10%) not applied** to the engaged-enemy contact damage in `combat_v2` (advance step deals a flat 1/tick regardless). Per-tick status *damage* IS now applied (Q6 F2).
- **UX shift to verify at playtest:** the Ult button now fires at ≥1 bar (consume 1), not at a full 3-bar meter (Q4).
- Boss (stage 4 wave 2) is still a stationary hp30 enemy (telegraph lists it; real boss AI = Phase 5).

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

## STATUS — vertical slice COMPLETE (playtest-ready)
Full loop built + TDD'd (last sweep **587/587** across 17 suites) + AUTOSHOT-verified + pushed. Ready for the human feel-gate playtest (roadmap Gate 4.5). G1–G14 this session are in the commit log below; locked-decisions list above is current.

**Playtest flow:** Home (PLAY) → F0 forge (full 7 shop) → equip → START → stage auto-battles 3 waves (slow-populate drip + hit VFX + status element-icons) → stage-end forge (full board) → buy 2 same → **MERGE = tier up T1→T4** (rarity border recolors + merge sparkle) → reserve bench (tap-move any tile hero-agnostic, double-click to sell 50%) → next stage → clear stage 5 = **VICTORY** / all heroes dead = **DEFEAT** → result overlay (Play Again / Home).

## Session gotchas / trials (engineering — for future me)
- **Shell auto-backgrounding + stdout encoding:** PowerShell `*>` writes UTF-16 (Select-String saw garble); the harness also auto-backgrounded long Godot runs. **Fix that worked:** Bash tool, redirect Godot `> file 2>&1`, then Read the file (plain UTF-8). Use a known absolute Windows path for the out-file.
- **Parse error masks the whole suite:** a renamed test fn left a stale `_ready` call → `SCRIPT ERROR: Parse Error ... not found` → exit 255, ZERO test output (looked like "no RED"). Always check for `SCRIPT ERROR/Parse Error` in the grep, and if a suite emits nothing, suspect a parse error before assuming pass.
- **Clean RED for a new module:** write the test + a COMPILING stub (functions return defaults) → run for clean per-assertion RED → fill in. (Preloading a missing script = parse error, not clean RED.) For an in-place behavior change, retroactive RED via `git stash push -- <file>` (path-scoped) then run then `git stash pop` — note pop prints the full `.import` churn `git status`, that's noise.
- **Sell = double-click via `gui_input` `event.double_click`** (final; long-press was reverted). Sockets/reserve emit `*_tapped` on Button `pressed` (single) + `*_sell` on the double-click event. Tests drive a tap via `tap.pressed.emit()`.
- **const Arrays/Dicts are READ-ONLY in Godot 4**: combat writes `hero["hp"]`; tests feeding heroes from a `const` array must `.duplicate(true)`.
- **New PNGs need import before `load()`:** drop a `.png` then run `<godot> --headless --path . --import` ONCE, else `ResourceLoader.exists/load` returns null (icons fell back to dots until imported). White-bg→transparent done by flood-fill-from-edges tools `cut_status_bg.gd` / `cut_icon_bg.gd` (run via `--script`).
- **Image-gen (lila-art MCP):** nano-banana + recraft-v4 one-shot transparent PNG/webp; seedream returns opaque JPG (needs cutout). Tier rarity = in-engine border color, NOT per-tier art. Cost policy: nano-banana default; premium models only when user names them in-turn.
- **Permadeath broke the full-run test:** all-heroes-dead = DEFEAT fires in `_tick_once`; the 15-wave full-run test must `_buff_heroes` to reach VICTORY.
- **Shell:** Godot runs auto-background under contention + PowerShell `*>` is UTF-16 garble. Use Bash, redirect `> file 2>&1`, then Read the file. Parse error → exit 255 + ZERO output (looks like a pass); always grep for `SCRIPT ERROR/Parse Error`.

## Known deferred (Phase 5 / post-playtest)
- Real per-Function combat VFX + bigger reaction VFX (only generic hit-flash/impact + merge sparkle now). 2.5D battlefield (flat 3×3 grid now). Audio = stub (`_on_audio_triggered` prints; no SFX/music).
- Full catalog: 12 Functions + 15 reactions + tiers T1-T5 (slice = 6 Functions, 2 reactions [Steam/Electrocute], T1-T4 rarity borders). Spec: `docs/superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md`.
- FTUE playable flow (smoke-tested only; slice runs post-FTUE 3-hero). Real stage-5 boss AI (currently a hp30 enemy). Ult EFFECT (button charges + consumes, fires nothing). Wittle-meta home (HomeV2 is a title+PLAY stub).
- Wave telegraph [ROADMAP]. Balance pass (gold econ, hero hp vs permadeath, sell value floor-50% → 0g for T1).
- Repo hygiene: working tree has unrelated uncommitted changes NOT from this session — repo-root `docs/research/anime_autobattlers/` shows DELETED, `5_.../project.godot` modified, dev-scene `uid` churn. Left untouched; user to decide (likely `git checkout -- docs/research/anime_autobattlers`).

## PROPOSED NEXT STEPS — for approval (work on `post-slice-phase5`)
Next work is gated by tomorrow's playtest (roadmap Gate 4.5: forge feel / chain dopamine / FTUE retention). Proposed order:

0. **Playtest (user, tomorrow).** Run the slice with testers; capture feedback vs the 3 feel-gate objectives.
1. **Post-playtest triage (fast).** Fold tester feedback into a fix list + balance pass (enemy/hero hp vs permadeath, gold economy, sell value).
2. **Juice + feel (high ROI, if gate passes):** (a) real per-Function attack VFX + bigger Steam/Electrocute; (b) audio pass (wire `ElementMediator.audio_triggered`); (c) make the ULT button actually FIRE an effect.
3. **Content depth (Phase 5 core):** (d) full 12-Function catalog + 15 reactions + tiers T1-T5 per the catalog spec; (e) FTUE playable flow (staged hero unlock + PullOverlay cinematics + scripted waves, gated on `AccountState.ftue_complete`) + real stage-5 boss AI.
4. **Meta + presentation (Phase 5+):** (f) 2.5D battlefield (perspective shader/layered art); (g) Wittle-meta home (replace HomeV2: hero levels, equipment, dailies).

Cheap, ungated wins anytime: wave telegraph, status-icon/reserve-slot polish.
**ACTION: user picks which of 1–4 to start (or reorders) after the playtest. Then `superpowers:writing-plans` → phased plan → TDD build.**

## Suggested skills (next session)
- **`superpowers:test-driven-development`** (the `tdd` skill) — mandatory per global policy on every production change (RED→GREEN; stub-compile new modules; retroactive RED via path-scoped `git stash`).
- **`superpowers:brainstorming`** — before any new Phase-5 feature (FTUE flow, ult effects, meta home) to lock scope/UX.
- **`superpowers:writing-plans`** — turn the approved next-steps into a phased implementation plan.
- **`lila-skills:ai-art-set`** — if generating a fuller Phase-5 art set (per-Function VFX, hero/enemy art, key UI).
- **`anthropic-skills:game-design`** — balance pass + feel tuning from playtest feedback.
