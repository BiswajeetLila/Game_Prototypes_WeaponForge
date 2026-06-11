> **SSOT:** [01_GDD.md](../01_GDD.md) — single source of truth for `2_Weaponcraft_Godot`. This spec elaborates the GDD; the Godot build in `Prototype/godot/` wins on current-state facts. `_archive/` is reference-only. Unbuilt intent here is **[ROADMAP]**.
>
> **⟳ Reconciled 2026-06-12 (hero-squad direction):** Stamina is the **P1 farm-exploit gate** (added before persistent currency; NOT in P0). It is a gate, **not one of the 4 currencies**. See [hero-squad spec §9.7, §10](../superpowers/specs/2026-06-11-hero-squad-meta-design.md).

# Stamina Economics — Stub

**Status:** Deferred from initial GDD.

## Scope

Stamina-gated stage play model. Free play count, refill rates, refill costs, cap.

## Locked anchors (already in GDD)

- **Stamina-gated** stages: 3 plays free, 4th costs stamina, refills over time (Wittle pattern).

## Open design questions

- **Daily free play count**: 3 confirmed. Bonus from daily login? VIP tier?
- **Stamina cost per stage**: flat (e.g., 6 stamina per stage)? Scaling by stage difficulty?
- **Stamina cap**: 60? 120? Affects how long players can be offline before "losing" idle accrual.
- **Refill rate**: 1 stamina per 6 minutes? Per 12 minutes?
- **Stamina refill IAP**: small ($1) = 60 stamina, medium ($5) = 360 stamina, etc.
- **Rewarded ad refill**: 1 ad = how much stamina? Daily cap on ad refills?
- **Star Challenge cost**: same stamina or higher (replaying a cleared stage)?

## Recommended approach

- **120 stamina cap**, refills 1/6min.
- **6 stamina per normal stage**, **12 per boss stage**, **9 per elite stage**.
- **20 stamina per ad watch**, max 5 ads/day.
- **First 3 stages of the day stamina-free** (loose interpretation of "3 plays free").

These numbers let F2P play ~10 stages/day actively + collect AFK idle. Tweak based on playtest data.

## References to consult

- Wittle Defender stamina exact numbers (likely on the Pocket Gamer guide).
- AFK Journey AFK currency cap (12hr offline).
- Hero Wars energy regen rate.
