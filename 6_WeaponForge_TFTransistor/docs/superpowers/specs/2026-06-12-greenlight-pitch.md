> **HISTORICAL — describes the previous 2_WC craft+collect direction. Superseded 2026-06-12 by the WeaponForge TFTransistor pivot (Function Matrix + 3-lane auto-runner + Magicka reactions). Current SSOT: [`../../01_GDD.md`](../../01_GDD.md). Pivot rationale: [`2026-06-12-fork-a-pivot-addendum.md`](2026-06-12-fork-a-pivot-addendum.md).**

> **SSOT:** [01_GDD.md](../../01_GDD.md) — single source of truth for `2_Weaponcraft_Godot`. Pitch artifact built on the [hero-squad meta design](2026-06-11-hero-squad-meta-design.md) + [retention arc](2026-06-12-retention-arc-d1-d20.md).

# WeaponCraft — Greenlight Pitch (CEO)

**Date:** 2026-06-12 · **Ask:** approve the D1–3 vertical slice → greenlight Phase 1.

---

## The pitch, one line
> **A cozy-mobile auto-battler where you *craft* your weapons (the hook) and *collect* a hero squad (the business).** Crafting depth — the rare thing — acquires and retains; hero-collection — the proven thing — monetizes.

## The bet / the whitespace
- **Hero-collectors are saturated** (AFK, Wittle); **crafting-roguelite-autobattlers are rare** (Brotato, Backpack Hero — and those are premium, no live-service meta).
- The empty quadrant: **crafting depth + hero-collection meta in one F2P game.** That combination is the moat.
- Precedent de-risks both halves: equipment/build-craft loops retain (Brotato word-of-mouth); hero-collection monetizes ($100M+ cohort). Nobody has fused them.

## Beacon user + funnel
**Beacon = the craft-tinkerer.** Funnel spine: **come for the craft, stay for the discovery, monetize via the collection.**

## What the D1–3 playable demonstrates (the "fun is real")
A running vertical slice, four beats:
1. **Craft hook** — TFT-style part shop → 3-slot weapon. Juiced, with audio. *"This is satisfying."*
2. **Scripted hero pull** — a faked slot-machine pull, "NEW HERO!", confetti. *Shows the collection dopamine + the business model in one beat.* (No real economy yet — the feeling is real, the wallet isn't.)
3. **Squad-build + level** — new hero joins the squad, persistent level ticks up. *"I'm building something that lasts."*
4. **Counter-build aha** — stage telegraph ("fire-weak") → craft a counter set. *Shows depth + the replay reason.*

This proves the two things a CEO needs to feel: the craft loop has "it," and the collect-moment lands.

## The D7–D20 business (the "it's credible")
Full retention narrative in [`retention-arc-d1-d20.md`](2026-06-12-retention-arc-d1-d20.md). Summary:
- **D7** — collection ladder takes over (gacha + Star-up); player has a main + a build identity.
- **D14** — attachment layer (Mastery/bond, portrait evolution, permanent recipe knowledge).
- **D20** — expression layer (signature weapons, squad synergy) + evergreen on the horizon (seasons, Elite/Nightmare).
- **Targets (projections):** D1 40% / D7 18% / D30 8%; 3–5 sessions/day early.

## The two ways this dies — and the cheap test (the "we see the risks")
*This is the slide that earns the greenlight: we already found our kill-shots and have a cheap experiment for each.*

| Kill-shot | When it shows | Cheap de-risk |
|---|---|---|
| **Audience mismatch** — the craft fan won't touch the gacha | ~D7 (collection should take over) | **P1 monetization probe** (mock store + pull-intent / craft-fan-engagement signal) tells us *before* we sink real money |
| **Moat erosion** — heroes outshine craft, the differentiator dies | D14–D20 (hero power compounds) | **moat guardrail** (heroes monetize via identity/utility/synergy, not raw power; tested `craft ≥60%` invariant) — deferred, ready when it bites |

## The ask + what greenlight unlocks
- **Approve:** the D1–3 slice as proof the hook is real.
- **Greenlight:** Phase 1 — real gacha + Star-up + 2–3 new heroes + stage telegraph + economy + **the monetization probe**.
- **Greenlight buys the answer to the scariest question** (does the craft-tinkerer pay for heroes) at the cheapest possible cost, before P2/P3 investment.

## Go / kill criteria (borrowed from the design spec exit gates)
- **GO signal:** D1 ≥ 35% + the monetization probe shows craft-engaged players *do* pull.
- **KILL/pivot signal:** craft fans churn at the gacha wall (probe fails) → revisit beacon or de-emphasize gacha.

## Build reality
- Engine: Godot 4.6, on top of the **already-shipped** craft+fight prototype (15 waves, 3 heroes, recipes, bosses, retry). The slice is *additive*, not from scratch — meaningful de-risk on the playable.
- Phasing is incremental and independently shippable (P0 → P1 → …), so spend is staged against evidence.
