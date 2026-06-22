# HANDOFF — WeaponForge TFTransistor (forge/shop rebuild + live-bug fixes)

**Updated:** 2026-06-22 · **Active work branch:** `weaponforge-tftransistor/post-slice-phase5`. · **Current focus: game renamed → RuneSurge. Primary demo = [`_paper-prototypes/RuneSurge-FTUE.html`](_paper-prototypes/RuneSurge-FTUE.html) — one guided flow: Bran solo (stages 1-4) → +Elara (5) → full squad (6), reusing the 3-hero board (reveal 1→2→3; Bran's runes carry over). [`ftue-beat5.html`](_paper-prototypes/ftue-beat5.html) = polished single-hero backup. Forge budget 30 (generous demo). Demo-ready — a foreground playtest of stages 1→6 is the one thing still pending. WFT-12/13/14 parked for the post-demo rebalance.** Live task list: [`docs/issues/2026-W26.md`](docs/issues/2026-W26.md). Shipped Godot build (slice + Phase-5 Q1–Q6) is the working baseline. · post-compaction resume doc.

## 🎨 DESIGN REDESIGN brainstorm — DIRECTION CHOSEN + REFINED 2026-06-22 (← RESUME HERE)

**What this is:** a from-the-research rethink of the **core gameplay + craft**, well beyond the shipped prototype. The shipped build (3-lane auto-runner + flat 3-socket forge + Q1–Q6) is the **baseline to evolve from, not the target.** Still **design + paper-prototype only** — no production code touched.

**One-line state (2026-06-21):** moat = **the CRAFT is the engagement**; positioning = **GD-derived casual + TFT shop + Transistor/Magicka twist**. Engine = **mana → fire-the-mix**. Craft = **unified hex weapon-board**, staged reveal (5 stages + sandbox). Modifier model = **Path Y + DIRECTIONAL Keys** (a Key converts only the clusters its **arrows** point at → combo; 2-arrow common Keys fuse 2 tiles, the epic **Star** fuses 3; no hidden priority; one key per cluster; spam-proof). **Merge fixed** (tier ×4/×9 + merged tiles count toward cluster → merge never drops). **Synergy axis decided:** adjacency rewards same **element** (core) + same **role/style** (late-stage reveal); "classes" (Elemental/Magic/Cosmic) = content/gacha buckets (not synergy); utility (Heal/Haste) = the modifier family. **Roadmap reordered (GD lesson):** add the cheap churn axes — **shop draft+refresh + a concentrate-vs-spread cap** — BEFORE the 2nd synergy axis.

**Playtested 06-21 (casual + TFT personas, both 4/10):** applied fixes — merge never drops, **S4 resists ALL** (Key required, back-door closed), **S5 mega-weak Conduct** (≠ S4 → teaches matchup adaptation), Splitter cut, Key-placement feedback, live-version banner. **#1 OPEN (next session) = a setup COST / placement budget** — both personas' top fix; makes merge a real trade + kills the "every stage trivialises to 1–4 volleys" problem; a genuine economy decision, deliberately NOT yet built. See the 06-21 doc §6.

**Refined 06-22 (built + live-verified):** Keys are now **DIRECTIONAL** — a Key fuses only the tiles its **arrows** point at, so "3 elements on one Key, who wins?" is resolved (a 2-arrow Key simply can't take a 3rd tile; only the epic **Star** fuses 3). Adds the spatial-placement decision the TFT persona wanted. **Stage 4 = 3 Keys** (Bar ◄►, Vee ◣◢ common + Star ★ epic). **Splitter redefined** = directional raw ×2 doubler (no resist-bypass), Sandbox-only. Two playtest UX fixes: a **⚔ Battle button** (combat runs only on press; build freely first) and **Replay now restores enemy HP** (was stuck at 0). **Keys & Splitter convert per-TILE** — only the exact arrow-pointed tile, never its whole cluster (fixed 06-22; a clustermate no arrow points at fires raw on its own). **Tick fill speed = 1.0 s/segment.** **Clustering's damage bonus (`cmult`) CUT 06-22** — after analysis, clustering now ONLY groups ticks + enables merge; damage scaling lives in merge (×4/×9) + combos (cluster-vs-spread wasn't a real choice on the dense 5-cell board, and cmult was redundant with merge). Mono-board damage dropped ~30–60% → folds into the pending #1 HP retune. All parity-checked, no console errors. **Mana = ticks (new same day, corrected to ONE bar):** a **segmented mana bar that GROWS one fixed-width segment per tick** (1 group = 1 short segment · 2 = two · 4 = a 4-wide bar); the fill **sweeps across all segments once, then fires the whole board** (1 fire = 1 tick · 2 separated tiles = 2 · a cluster of any size = 1 · a combo = 1). More / looser groups = a longer bar = slower attack. *(Evolved this session: N-segments-firing-per-segment → single fixed bar → **this growing-segment bar, fires once at the end**, per the user's diagram.)* Clustering & combos *consolidate ticks* → the craft drives **tempo as well as damage**. *(First build wrongly used N side-by-side segments firing per-segment — corrected to one bar, charge-then-fire; see the mana-tick doc §6.)* Flagged: ~9× throughput swing for clustering → tune enemy HP; **open: fire-water-fire = 3 ticks here, user example said 2 — awaiting confirm.** See the **two 06-22 docs**. *(#1 OPEN is unchanged — the setup-cost/budget; these don't replace it, the board is still free to build.)*

**Next direction (06-22, late) → MULTI-HERO + modifier verb-space.** The board went **3-hero**: 3 boards · bridgeable seams · per-hero tick-bars. **Pass 1 + Pass 2 BUILT + verified** — the "3-Hero Board" section at the bottom of the prototype. **Layout = ONE PACKED HONEYCOMB** (the 3 boards merged into a single continuous hex column, rows tessellating 3-2-3-2-3-2 at 38px steps; per-hero info on a right rail). **Pass 2 = cross-hero seam bridging (DONE):** a Key on a hero's bottom-row cell aims its **↓ SW/SE sockets across the seam** into the hero below (B0→A0/A1, B1→A1/A2); the combo **fires for the Key's hero and consumes the borrowed tile**; clustering stays within a board (`volley(h)` generalised to a global `volleyAll()`). A cross-hero combo draws a **real connecting line across the seam**. Hex (tessellated) wireframe at [`_paper-prototypes/3hero-board-wireframe.excalidraw`](_paper-prototypes/3hero-board-wireframe.excalidraw). Modifiers next become a **verb-space** — distinct-effect directional Keys (combine / amplify / speed / swap…), **rotation demoted** to a gold-sink polish. Build order: **~~seams~~ ✅ → verb modifiers → shop costs**; the #1 setup-budget + HP retune now spans 3 boards (cross-hero is a power source with no cost yet). Full rationale: [multi-hero doc](docs/superpowers/specs/2026-06-22-multi-hero-and-modifier-verbs.md) + [Pass-2 doc](docs/superpowers/specs/2026-06-22-pass2-cross-hero-seams-and-packed-honeycomb.md). **Open caveat:** bridging is downward-only → bottom hero can't bridge, top hero can't be borrowed from (seam-equality = a later decision).

**LATEST (06-22) → board topology LOCKED + costs/budget BUILT.** Playtest resolved the legibility question: **keep the hex honeycomb, colour-code by hero** (identity on the hex *outline* + rail swatch; element stays on the fill) — the single-row option was set aside. Then the long-pending **#1 = setup-cost / placement budget is now BUILT (WFT-9):** every piece has a cost, paid from ONE **shared** forge budget (18) across all 3 boards (so cross-hero power finally costs something); over-budget blocked, removal refunds, **merge conserves** budget; affordable-only cells glow, unaffordable pieces dim. Starting values — retune once stakes exist. Live-verified, no console errors. Full record: [`2026-06-22-topology-locked-and-costs-budget.md`](docs/superpowers/specs/2026-06-22-topology-locked-and-costs-budget.md). **Work is now tracked as local Jira-style tickets** in [`docs/issues/2026-W26.md`](docs/issues/2026-W26.md) (WFT-1…10 done; WFT-11 retune = next). FTUE staged-tutorial edits queued = WFT-15 (details TBD). **STAKES (WFT-10) now BUILT:** hero HP (90/130/100), enemies attack on a cadence (⚔atk/Ys), win = all enemies dead / lose = any hero downed; result banner + Battle/Pause/Resume/Fight-again flow; empty hero grinds to a clean loss. Starting values — retune is WFT-11. See [`2026-06-22-stakes-incoming-damage-and-winlose.md`](docs/superpowers/specs/2026-06-22-stakes-incoming-damage-and-winlose.md).

> ⚠️ Read the **06-22 doc FIRST** (it supersedes the Key model in 06-21 §1: non-directional → directional), then the 06-21 doc (Path Y + synergy-axis + roadmap, which supersedes the 06-20 flat-combo model). 06-17 = ancient history.

**Read these to resume, in order:**
1. **FRESHEST first:** [`2026-06-23-runesurge-ftue-flow-and-multihero-reveal.md`](docs/superpowers/specs/2026-06-23-runesurge-ftue-flow-and-multihero-reveal.md) (**newest** — RuneSurge rename + multi-hero progressive-reveal FTUE flow + ftue-beat5 polish) · [`2026-06-22-ftue-demo-scope-and-forgiving-tuning.md`](docs/superpowers/specs/2026-06-22-ftue-demo-scope-and-forgiving-tuning.md) (demo scope; forgiving tuning) · [`2026-06-22-wft11-retune-resists-and-hex-fills.md`](docs/superpowers/specs/2026-06-22-wft11-retune-resists-and-hex-fills.md) (resists puzzle; darker hex fills) · [`2026-06-22-stakes-incoming-damage-and-winlose.md`](docs/superpowers/specs/2026-06-22-stakes-incoming-damage-and-winlose.md) (hero HP + enemy attacks + win/lose) · [`2026-06-22-topology-locked-and-costs-budget.md`](docs/superpowers/specs/2026-06-22-topology-locked-and-costs-budget.md) (board topology LOCKED = hex + colour-coding; costs/budget v1) · [`2026-06-22-pass2-cross-hero-seams-and-packed-honeycomb.md`](docs/superpowers/specs/2026-06-22-pass2-cross-hero-seams-and-packed-honeycomb.md) (Pass 2 cross-hero seams + packed honeycomb + hex wireframe) · [`2026-06-22-multi-hero-and-modifier-verbs.md`](docs/superpowers/specs/2026-06-22-multi-hero-and-modifier-verbs.md) (3-hero board decided + Pass-1 built, modifier = a **verb-space** not rotation) · [`2026-06-22-directional-keys-and-prototype-controls.md`](docs/superpowers/specs/2026-06-22-directional-keys-and-prototype-controls.md) (directional per-tile Keys, tiers, Splitter, Battle button + Replay HP fix) · [`2026-06-22-mana-tick-economy.md`](docs/superpowers/specs/2026-06-22-mana-tick-economy.md) (mana = ticks; §7 = cmult cut). All 5-component-evaluated with verified parity numbers.
2. [`docs/superpowers/specs/2026-06-21-craft-refinements-and-synergy-axes.md`](docs/superpowers/specs/2026-06-21-craft-refinements-and-synergy-axes.md) — Path Y model, merge fix, the synergy-axis decision, GD axis comparison + churn-first roadmap, GD research gaps, §6 = the 4/10 playtests + fixes.
3. [`_paper-prototypes/ftue-beat5.html`](_paper-prototypes/ftue-beat5.html) — **playable**: scroll to the bottom **"Path Y"** section (5-cell board, the live build). Press **⚔ Battle** to fight. Earlier sections = the design evolution. Serve via `.claude/launch.json` server **ppftue** (port 8771) or double-click; offline.
4. [`docs/superpowers/specs/2026-06-20-staged-game-mode-direction.md`](docs/superpowers/specs/2026-06-20-staged-game-mode-direction.md) — the chosen direction (modifier model superseded by Path Y).
5. [`docs/superpowers/specs/2026-06-18-core-craft-mechanic-brainstorm.html`](docs/superpowers/specs/2026-06-18-core-craft-mechanic-brainstorm.html) — the 57-item consolidated model.
6. [`docs/superpowers/specs/2026-06-20-slot-models-and-gamedesign.md`](docs/superpowers/specs/2026-06-20-slot-models-and-gamedesign.md) — the A/B/C slot analysis.

**Resume sequence:** **(1) ✅ costs/budget (WFT-9) + (2) ✅ stakes (WFT-10) + (3) ✅ retune — enemy resists make each lane a matchup puzzle (WFT-11), all BUILT 06-22.** Next: **foreground-playtest RuneSurge stages 1→6** (the preview can't run live battle timing here), then the **post-demo "real prototype" phase** — unpark the **WFT-11** resist puzzle (real tuning) → **WFT-12** round loop → **WFT-13** verb-space → **WFT-14** seam symmetry. Live task board: [`docs/issues/2026-W26.md`](docs/issues/2026-W26.md). *(The faithful engine `scratchpad/play_engine.py` was updated 06-22 for directional Keys — rebuild from the Path Y `<script>` if scratchpad was wiped.)* *(Deferred: role-clustering reveal ~stage 10, Key rotation, constraint slots, meta layer.)*

**✅ Committed through 06-22.** `33a7326` (directional Keys + Battle button + Replay HP fix in `ftue-beat5.html`, + the 06-21 craft-refinements doc + the 06-22 directional-keys doc + HANDOFF), `dfdb745` (GD spec gap #16), and the **mana-tick economy** (`ftue-beat5.html` + `2026-06-22-mana-tick-economy.md` + HANDOFF), plus **Pass 2** — cross-hero seam bridging + the **packed-honeycomb** 3-hero board (`ftue-beat5.html`) + the **hex** `3hero-board-wireframe.excalidraw`/`.png` + [`2026-06-22-pass2-cross-hero-seams-and-packed-honeycomb.md`](docs/superpowers/specs/2026-06-22-pass2-cross-hero-seams-and-packed-honeycomb.md). Earlier: `5e79bc9` (GD King correction), `a02cf88` (staged-direction pile). Working tree is clean for our files — *only* the `.import` churn + pre-existing unrelated changes remain (left untouched; user to decide). *Scratchpad (not in repo):* `play_engine.py` updated to the directional + tick model.

**✅ Committed `49ca564` (06-22)** — the demo milestone listed below. **NEW uncommitted (06-23):** WFT-17 polish in `ftue-beat5.html` + the new `RuneSurge-FTUE.html` (WFT-18 multi-hero flow) + **WFT-19 refinements** (board↔rail alignment, stage-6 carry Bran+Elara + Star/Splitter reveal, global blinking "new" badge — both files; Model note cut; history kept in ftue-beat5 only; forge budget 15→30) + [`2026-06-23-runesurge-ftue-flow-and-multihero-reveal.md`](docs/superpowers/specs/2026-06-23-runesurge-ftue-flow-and-multihero-reveal.md) + updated tracker + this HANDOFF. _(Historical — the 06-22 milestone contents:)_ per-hero colour-coding + costs/budget + **stakes** + **WFT-11 retune (enemy resists + tuned numbers + darker hex fills)** + **rail versus-layout (hero left / enemy right per lane, resist/weak in 16px)** + **WFT-16 forgiving demo tuning (resists removed, enemies softened so any technique wins)** + **WFT-15 demo-mode flow (demo header, hide-history script, FTUE→battle bridge, softened Wall hp520→120, demo titles)** in `ftue-beat5.html`; the dated docs [`2026-06-22-topology-locked-and-costs-budget.md`](docs/superpowers/specs/2026-06-22-topology-locked-and-costs-budget.md) + [`2026-06-22-stakes-incoming-damage-and-winlose.md`](docs/superpowers/specs/2026-06-22-stakes-incoming-damage-and-winlose.md) + [`2026-06-22-wft11-retune-resists-and-hex-fills.md`](docs/superpowers/specs/2026-06-22-wft11-retune-resists-and-hex-fills.md) + [`2026-06-22-ftue-demo-scope-and-forgiving-tuning.md`](docs/superpowers/specs/2026-06-22-ftue-demo-scope-and-forgiving-tuning.md); the issue tracker [`docs/issues/`](docs/issues/) (README + `2026-W26.md`); and this HANDOFF edit.

**Visual brainstorm artifacts** (06-16/17 screens): `.superpowers/brainstorm/*/content/*.html` (reaction-locus, three-layer-reshape, hero-frame-differentiation, three-role-mapping, part-grain, function-role-gallery, function-modifier-combos, gate-currency).

**Suggested skills on resume:** `game-design` + `brainstorming` (used 06-20/21), later `writing-plans`.

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
