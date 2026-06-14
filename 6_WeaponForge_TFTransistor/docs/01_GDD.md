# WeaponForge TFTransistor — Game Design Doc

**Working title:** WeaponForge TFTransistor (formerly WeaponCraft; pivoted 2026-06-12)
**Working folder:** `Game_Prototypes/6_WeaponForge_TFTransistor/`
**Target platform:** Vertical mobile (iOS + Android)
**Target audience:** Casual-mobile RPG + tactical-roguelike players (Wittle Defender, Capybara Go, Brotato, Slice & Dice, AFK Journey cohorts)

---

## ⚠ SSOT & doc tree (read first)

**This document is the single source of truth (SSOT) for `6_WeaponForge_TFTransistor`.**

- Every spec under `docs/` either **is** the SSOT (this doc) or is a spec that **points to** it and elaborates a subsystem.
- The Godot build in [`Prototype/godot/`](../Prototype/godot/) is **authoritative for all current-state facts.** Where this doc's prose and the build disagree on what is implemented, the build wins. Design intent not yet in the build is tagged **[ROADMAP]**.
- Folder rules live in [`../CLAUDE.md`](../CLAUDE.md).
- **Historical / superseded material** — the abandoned `2_Weaponcraft_Godot` direction (anatomical Head/Hilt/Rune crafting + single-lane combat + recipe discovery) — lives in (a) the frozen sibling folder `2_Weaponcraft_Godot/` (do not touch) and (b) banner-marked HISTORICAL docs inside this folder's `docs/` tree (do not reference for forward work — they remain only for design archeology until Phase 3 spec lands and they are archived).
- **`_archive/`** in this folder = older forks (Wittle-inversion weapon-gacha — that direction continued as the separate `5_WeaponForge_Honkai_Godot` project). Reference-only. Not for forward work.

### Active design specs (elaborate this SSOT)

| Doc | Role |
|---|---|
| [`superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md`](superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md) | **The cell-by-cell implementation contract.** 12 Functions × 3 slot behaviors = 36 cells; 15-reaction matrix; lane combat rules; FTUE script; world structure; tier system; Ults. **Status: REVIEW-3** (awaiting LOCK sign-off). |
| [`superpowers/specs/2026-06-13-phase4-vertical-slice-scope.md`](superpowers/specs/2026-06-13-phase4-vertical-slice-scope.md) | **Phase 4 (prototype-1) scope doc.** Mission, in-scope systems, build sequence, success/failure criteria, playtest feedback plan. |
| [`superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`](superpowers/specs/2026-06-12-fork-a-pivot-addendum.md) | **Parent design rationale.** The user's verbatim pivot addendum from 2026-06-12 — describes the Function Matrix + spatial-combat + Magicka reactions thesis. Read once for the "why"; the cell-by-cell contract above lives in the Function catalog doc. |
| [`_art-build/screens/In_Battle.png`](../_art-build/screens/In_Battle.png) + [`Forge_State.jpeg`](../_art-build/screens/Forge_State.jpeg) | **Approved presentation mockups — art/UX SSOT for the Phase 5 rebuild.** Combat screen + forge-break screen, user-approved 2026-06-14, matched frame set. 2.5D ~30° top-down battlefield, faint **3×3 grid = hybrid** (mechanic keeps continuous `screen_x` advance per `lane_state.gd`; the view snaps each enemy to the nearest of 3 depth cells per lane, same-cell enemies stack-offset). Heroes anchored LEFT, enemies advance leftward. Shop rail is **bottommost**. Sockets labelled ACTIVE/MODIFIER/PASSIVE. Supersedes the pre-pivot `run_01`-era anatomical-anvil art. |
| **[ROADMAP]** Wittle-meta-progression spec | TBD post-Phase-4 feel-gate. Hero levels, skill trees, equipment, talents, stars, dailies, season pass, idle income — Wittle Defender clone meta-layer (locked direction per REVIEW-3 §13 row 12). |
| **[ROADMAP]** Monetization spec | TBD post-Phase-4 (locked deferred per REVIEW-3 §19.2 P1). |

---

## High-concept pitch

> **"Forge functions, run the lane, react in chains."**
>
> WeaponForge TFTransistor is a casual-mobile **tactical auto-runner** for a 3-hero squad. Heroes walk left-to-right through a 3-lane corridor; enemies spawn from the right. Each hero carries a **3-socket Function Matrix** (Active / Modifier / Passive — Transistor-style). Drag atomic Functions (`FIRE`, `WATER`, `LIGHTNING`, `AOE`, ...) into sockets to shape your attacks, and chain them into cross-hero **Magicka reactions** (`WATER` + `LIGHTNING` = Electrocute; `WATER` + `FIRE` = Steam). A 7-slot shop slow-populates between waves so you forge while you fight. Each session is one **world** — 5 stages, 15 waves, ~4 minutes. Collect heroes and level them across sessions for permanent power (Wittle-clone meta).

---

## The five design pillars

1. **The Function Matrix (Transistor)** — 3 universal sockets per hero (Active / Modifier / Passive). Every Function works in every slot, with different behavior in each. Zero RNG-lockout from rolling the wrong shop. Per-hero stack = the forge moment.
2. **3-lane auto-runner combat (Capybara Go / Wittle Defender)** — no grid, no placement. Heroes lane-locked. Enemies advance from off-screen right. Combat is auto-fire driven by Active Function. Cross-lane abilities create spatial-feeling depth without manual positioning.
3. **Magicka cross-hero reactions** — statuses (Burning / Wet / Chilled / Shocked / Cracked) attach to enemies. When an incoming damage tag hits a status, a reaction fires (Electrocute, Steam, Thaw, Magma Burst, Mudslide, ...). 15 reactions in the v1 matrix. Stacking 3 reactions in a 2-sec window = Ult charge + chain stinger juice.
4. **Distributed cognitive load (slow-populate shop)** — 7-item shop populates **across each stage's 3 waves** (rhythm: 2 items at stage start, 3 across waves, 2 right before stage break). Player thinks about builds while watching auto-combat. Stage break = 8-10 sec paused chill to consolidate. No forge-break crunch panic.
5. **Wittle-meta-progression (carry across runs)** — heroes persist across worlds with full Wittle-style meta (hero levels, skill trees, equipment, talents, stars, dailies, season pass, idle income). Function loadout resets per world to keep each session a fresh forge puzzle. Per-session = one world = ~4-5 minutes; meta builds over days.

---

## Core loop

```
   ┌──────────────────────────────────────────────────────────────┐
   │  WORLD (≈ 4-5 min, one session)                              │
   │                                                              │
   │  F0 deploy  ──> Stage 1 (3 waves) ──> F1 ──> Stage 2 (3 waves)│
   │                                                              │
   │   ──> F2 ──> Stage 3 (3 waves) ──> F3 ──> Stage 4 (3 waves)  │
   │                                                              │
   │   ──> F4 ──> Stage 5 BOSS (mini, mini, BOSS) ──> F5 / win    │
   │                                                              │
   │  Each STAGE:                                                 │
   │    Wave 1 (~12s) → Wave 2 (~12s) → Wave 3 (~12s)             │
   │    Shop slow-populates 2/3/2 across the 3 waves              │
   │    Stage break (8-10s paused chill) → drag final items       │
   │                                                              │
   │  Each WAVE: enemies spawn from right → walk left → heroes    │
   │    auto-fire Functions → reactions chain → wave ends when    │
   │    all enemies dead.                                         │
   │                                                              │
   │  Run ends: win (cleared stage 5) or loss (all heroes dead)   │
   │    → meta-XP awarded → return to Home                        │
   └──────────────────────────────────────────────────────────────┘
```

**Numbers** (locked starting values, see [function catalog spec §9](superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md#9-world-structure--stage--wave--forge-cadence)):
- 1 tick = 0.5 sec (2× speed toggle available)
- 1 world (FTUE) = 11 waves; 1 world (post-FTUE) = 15 waves
- 6 forge moments per world (F0–F5)
- Run length ≈ 4-5 minutes at 1× speed

---

## Heroes (3 in launch, lane-locked)

| Lane | Hero | Class | Base attack | Innate trait | HP | Base dmg |
|---|---|---|---|---|---|---|
| 0 (top) | **Elara** | Mage | ranged single, no range cap, any-lane | none | 70 | 0.8× |
| 1 (mid) | **Bran** | Warrior | melee single, range 1.0×, own-lane | none | 100 | 1.0× |
| 2 (bot) | **Vex** | Rogue | melee single, range 1.0×, own-lane | **+20% dmg vs `Burning` targets** | 80 | 0.9× (crit 15%) |

Heroes are **lane-locked** by deploy. Player does not place heroes on grid — there is no grid. Squad identity feels distinct via base attacks + innate traits + hero-locked Ultimates (Bran Leap & Slam / Elara Chain Storm / Vex Phantom Strike).

Phase 5+ may introduce additional heroes via the Wittle-clone meta hero-roster expansion (deferred design).

---

## The 12 Functions

Three categories:

- **Elements (status emitters):** `FIRE` `ICE` `LIGHTNING` `WATER` `EARTH`
- **Patterns (attack shape):** `AOE` `BEAM` `BOUNCE` `BURST`
- **Tactical (targeting + trait):** `SEEKER` `LEECH` `KNOCKBACK`

Each Function has 3 distinct behaviors — one per slot (Active / Modifier / Passive). Full 36-cell matrix in the [function catalog spec](superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md#3-the-36-cell-function--slot-matrix-lane-aware).

**Tier system (T1-T5, 2-to-1 merge):** Common (1.0×) → Rare (1.4×) → Epic (2.0×) → Legendary (2.8×) → Mythic (4.0×). 16 commons → 1 mythic (full chain). Phase 4 slice = T1 only; tier system fully active starting Phase 5.

---

## Magicka reaction matrix (15 reactions)

Reactions fire when an **incoming damage tag** hits an **existing status** on an enemy.

**Status outputs** (Elements in Active emit these):

| Element (Active) | Status | Duration | Per-enemy effect |
|---|---|---|---|
| FIRE | Burning | 3 ticks | -2 HP/tick |
| ICE | Chilled | 3 ticks | walk-left speed × 0.5 |
| LIGHTNING | Shocked | 2 ticks | -1 HP/tick + 10% skip own attack |
| WATER | Wet | 4 ticks | reaction enabler only |
| EARTH | Cracked | 4 ticks (stacks to 3) | +15% incoming dmg/stack |

**The 15 reactions** (sample — full table in [function spec §5](superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md#5-the-reaction-matrix-15-reactions-v1)):

- `LIGHTNING × Wet → Electrocute` (2.0×, cross-lane chain)
- `FIRE × Wet → Steam` (1.0×, cross-lane splash + Blind)
- `FIRE × Chilled → Thaw` (1.5×)
- `EARTH × Wet → Mudslide` (1.4×, slow)
- `LIGHTNING × Burning → Arc Storm` (1.5×, cross-lane Shocked spread)
- ...10 more

Chain ≥3 reactions in 2-sec window → chain stinger audio + chain HUD counter. 3 reactions = 1 Ult charge.

---

## Shop + Forge

- **7 slots** per stage, slow-populating 2/3/2 across the 3 waves — **IMPLEMENTED** in the slice (`main_v2._reset_stage_shop` + `_drip_shop_for_wave`, driven by `ShopV2.populate_schedule_3wave`). 2 at stage start, +1 as each of the 3 waves begins, +2 by the stage's end; full board = the stage-end forge break.
- **Forge break = per STAGE, not per wave** — waves auto-battle continuously inside a stage (no inter-wave stop); the forge/equip moment is the stage break. F0 (run open) shows the 2 starting items. **IMPLEMENTED** (`_on_wave_cleared` auto-advances within a stage, opens forge at the boundary).
- Items reset between stages (forces commitment; no shop persistence)
- Cost scales by stage; gold from kills
- Pity counter: ≥1 Element per 2 consecutive stages
- 2-to-1 auto-merge on duplicate drop (slice stub: marks `2/2`, no tier bump until the full tier system lands)
- **Reserve (bench): 2 slots per hero.** Equipping onto an occupied socket displaces the old Function to a free Reserve slot (same id+tier → merge instead); both reserve slots full → equip is **blocked** (red row flash, no charge). Reserve is a usable bench: tap a benched item then a socket to re-equip (the socket item swaps back). **Sell** any socket/reserve item back to the shop for a reduced refund (floor 50% of cost) via **long-press (~0.5s)** — frees slots when the bench is full. **IMPLEMENTED** (`reserve_v2.gd`). Layout = [`_art-build/screens/Forge_State_edits.jpg`](../_art-build/screens/Forge_State_edits.jpg).
- **Re-roll** wipes every currently-shown item and reloads fresh ones in place (bought/empty slots stay empty for the drip to fill); price scales with stage (`2× T1 base`).
- **Weapon-always-visible bottom rail:** 3 hero portraits + 3 sockets each + Ult bars + a one-line weapon description under each row — visible during all combat + forge phases (player can plan permutations while waiting for shop to fill). **HP floats above the hero sprites in the battle scene only** (not the forge rail).
- **Wave telegraph:** tap during forge break to preview upcoming stage's enemy mix + weaknesses [ROADMAP]

---

## FTUE (replays on `AccountState.reset()`)

Staged hero unlock distributes cognitive load across world 1:

| Stage | Waves | Heroes live | Key beat |
|---|---|---|---|
| 1 | 1 | Elara solo (lane 1, forced FIRE + WATER) | Drag FIRE to Active. See Burning. |
| 2 | 1 | Elara solo (lane 1, full 7-slot shop) | Try a Modifier. |
| 3 | 3 | + **Bran joins** (F2 cinematic) | First Magicka reaction: WATER (Elara) + FIRE-Mod (Bran) = Steam |
| 4 | 3 | Elara + Bran | Stack reactions, charge Ult bar |
| 5 (boss) | 3 (mini, mini, BOSS) | + **Vex joins** (F4 cinematic) | Full Magicka chain across 3 heroes |

FTUE replays whenever `AccountState.reset()` clears `ftue_complete` flag (debug button on Home wires this). Useful for showcase / multi-tester demos.

---

## Run end, world transition, meta progression

- **Win** (cleared stage 5 boss) or **loss** (all 3 heroes dead) → result modal → meta-XP awarded → return to Home.
- **Across worlds:** heroes persist with Wittle-meta (hero levels, equipment, etc. — [ROADMAP], Phase 5+). **Functions reset** each world (Function loadout = per-session puzzle).
- **Phase 4 slice scope:** only world 1 (FTUE) ships. Multi-world progression in Phase 5.

---

## Status — what's in the build, what's locked, what's pending

### As-built (carried from 2_WC P0 frozen at `fbe426d` + seeded into this folder; meta layer survives unchanged)

- AccountState v2 save schema + v1 migration (extends to v3 in Phase 4 for `ftue_complete` bool)
- HeroProgress autoload + pure-static level math
- Home.tscn + home.gd (with debug reset button)
- ResultModal at run end
- PullOverlay for cinematic hero unlock (will be reused for FTUE Bran/Vex)
- Result modal, scout intel strip
- 58-test TestProgression suite headless-green
- AUTOSHOT (`screenshot_helper.gd`) non-interactive capture tool
- TDD test-harness pattern (`Test*.tscn` + `_check` + headless quit)

### Locked design decisions (26 of them — see [function spec §21](superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md#21-locked-decisions-register))

Includes: 12-Function set, 15-reaction matrix, status durations, 3-lane auto-runner format, FTUE pacing, world structure, tier system, hero Ults, shop pacing, weapon-vis rail, Mit-A salvageable death, accessibility, color-blind safe icons, Wittle-meta direction for Phase 5.

### [ROADMAP] — designed here but NOT in the build yet

- Lane corridor + auto-runner combat — Phase 4 (slice)
- 7-slot slow-populate shop — Phase 4
- 6 Functions + 2 reactions + Bran full Ult — Phase 4 slice
- All 12 Functions + 15 reactions + tier system — Phase 5
- Boss AI (full) — Phase 5
- Wittle-meta-progression — Phase 5+ (separate spec doc)
- Monetization — post-slice playtest decision
- Multi-world progression — Phase 5

### Out of scope (explicit non-goals — see [Phase 4 scope §3](superpowers/specs/2026-06-13-phase4-vertical-slice-scope.md#3-scope-out--explicit-non-goals))

- Weapon gacha (lives in separate `5_WeaponForge_Honkai_Godot` project — different commercial bet)
- Anatomical Head/Hilt/Rune parts (= 2_WC frozen direction)
- Recipe codex (= 2_WC frozen direction)
- PvP arena
- 3-card in-combat module (deferred contingency per function spec §20)

---

## Pivot history (one paragraph)

This folder seeded from `2_Weaponcraft_Godot/` P0 frozen at `fbe426d` (shipped: anatomical Head/Hilt/Rune craft, single-lane combat, scripted Vex pull, 15-wave run, hero-squad meta). On 2026-06-12 the user pivoted (Fork A from the brainstorm) to the design above: **Function Matrix + spatial combat + Magicka reactions** — keeping ~36% of the meta layer (account / hero progression / home / modals / pull cinematic) and rewriting the gameplay core. 2_WC remains frozen on remote (`2_WC/p0-shipped-2026-06-12` tag) as the canonical retreat point. Rationale: the verbatim user addendum is at [`superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`](superpowers/specs/2026-06-12-fork-a-pivot-addendum.md).

---

## Companion docs

- [Roadmap (phase-by-phase planning, decision gates)](roadmap-2026-06-13.md)
- [Story beats (narrative wave-by-wave script for FTUE + subsequent worlds)](story-beats-2026-06-13.md)
- [Function catalog + Reaction matrix (REVIEW-3, the implementation contract)](superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md)
- [Phase 4 vertical slice scope](superpowers/specs/2026-06-13-phase4-vertical-slice-scope.md)
- [Pivot rationale addendum (verbatim)](superpowers/specs/2026-06-12-fork-a-pivot-addendum.md)
- [Approved presentation mockups — combat (`In_Battle.png`)](../_art-build/screens/In_Battle.png) + [forge break (`Forge_State.jpeg`)](../_art-build/screens/Forge_State.jpeg)
- [Folder rules + non-collision notes (`6_/CLAUDE.md`)](../CLAUDE.md)
- Historical 2_WC-direction specs (all banner-marked HISTORICAL — listed in `../CLAUDE.md`)
