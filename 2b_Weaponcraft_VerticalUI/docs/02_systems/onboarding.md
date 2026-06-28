> **SSOT:** [01_GDD.md](../01_GDD.md) — single source of truth for `2_Weaponcraft_Godot`. This spec elaborates the GDD; the Godot build in `Prototype/godot/` wins on current-state facts. `_archive/` is reference-only. Unbuilt intent here is **[ROADMAP]**.
>
> **⟳ Reconciled 2026-06-12 (hero-squad direction):** P0 FTUE = **run-first, reveal HOME after stage 1**. Scripted in-run hero unlocks (Mage @ stage 3–5 / Rogue @ boss) are **removed** → replaced by **pre-run squad-select (≤3 owned)**. No gacha / free-pull in P0 onboarding (pull FTUE = P1+). See [hero-squad spec §9](../superpowers/specs/2026-06-11-hero-squad-meta-design.md).

# Onboarding Arc — Stub

**Status:** Deferred from initial GDD. To be specified during pre-prototype design refinement.

## Scope

First 30 minutes of player experience — tutorial pacing, free pull sequence, "BAM new character" moments, FTUE (first-time user experience) script.

## Locked anchors (already in GDD)

- Player starts with **1 hero (Warrior)** — free at tutorial.
- **2nd hero (Mage)** unlocks at stage 3–5.
- **3rd hero (Rogue)** unlocks at chapter 1 boss.
- Tutorial seeds **5–10 starting recipes** in the codex.

## Open design questions

- **Stage 1 script**: how much UI is shown? Hide reroll button until stage 2?
- **First gacha pull**: when does it happen? Free 10-pull at end of tutorial?
- **First boss-retry**: should we engineer a guaranteed first-boss-fail to teach the counter-build mechanic, or let players win it naturally?
- **Discovery codex first encounter**: do we trigger the first recipe discovery in a scripted moment, or organically?
- **Stamina introduction**: when does the player first run out of stamina? Day 1 should not hit this wall.
- **Battle Pass introduction**: at what player level does the BP screen first appear?
- **Tutorial overlay vs hands-on**: minimize tooltips, maximize "do the thing" cadence.

## Recommended approach

Write a beat-by-beat script of the first 6 stages (covering ~30 minutes of play). Each beat has: what the player sees, what they tap, what they learn. Playtest this hard — onboarding is the single highest-leverage area for D1 retention.

## References to consult

- AFK Journey's first 30 minutes (very polished, free 10-pull at minute ~15).
- Wittle Defender's tutorial (slower, hand-holdy, may be too much).
- TFT's "Little Legends" tutorial (compact, learn-by-doing).
