> **SSOT:** [01_GDD.md](../01_GDD.md) — single source of truth for `2_Weaponcraft_Godot`. This spec elaborates the GDD; the Godot build in `Prototype/godot/` wins on current-state facts. `_archive/` is reference-only. Unbuilt intent here is **[ROADMAP]**.
>
> **⟳ Reconciled 2026-06-12 (hero-squad direction):** **Hero Level** is the P0 stat spine (**+5% ATK & HP / level**, cap 20); Star-up (P1) is the gentle dupe-tier layer on top. Whatever damage model is chosen, keep **craft ≥ 60%** of effective run power (a maxed hero with no weapon must not clear content). See [hero-squad spec §4, §9.4](../superpowers/specs/2026-06-11-hero-squad-meta-design.md).

# Combat Resolution Math — Stub

**Status:** Deferred from initial GDD. To be specified during pre-prototype design refinement.

## Scope

Exact damage formula and stat interaction rules for auto-resolved combat.

## Open design questions

- **Damage scaling**: additive (sum of ATK + element bonuses) vs multiplicative (ATK × element × crit × class bonus). Multiplicative scales worse but feels more "build-y."
- **Defense reduction curve**: flat subtraction vs percentage reduction vs sigmoid. Affects late-game difficulty curve and how Tier-5 parts feel.
- **Crit math**: crit chance × crit multiplier. Standard 2× crit multiplier? Variable per part?
- **Element interaction matrix**: Fire vs Ice modifier, Holy vs Shadow modifier. Affinity-based bonus and resistance percentages.
- **Star-Up scaling**: ★1 → ★5 stat curve. Should F2P-at-★1 vs whale-at-★5 power gap be <2×? <3×?
- **Attack speed**: fixed per class, or part-modified? If part-modified, balance impact on ultimate charge rate (Q9 mechanic).
- **HP scaling**: how does hero HP scale with stage progression vs monster HP scaling.

## Recommended approach

Start with simple additive math (cheap to balance), add multiplicative layer only when needed (likely after first playtest reveals where the math feels flat).

## References to consult

- AFK Journey damage formula reverse-engineering (Prydwen.gg has data).
- Wittle Defender hero stat scaling.
- TFT item stat math (item recipes have clean documented formulas).
