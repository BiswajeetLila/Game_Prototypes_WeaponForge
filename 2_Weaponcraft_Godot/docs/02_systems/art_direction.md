> **SSOT:** [01_GDD.md](../01_GDD.md) — single source of truth for `2_Weaponcraft_Godot`. This spec elaborates the GDD; the Godot build in `Prototype/godot/` wins on current-state facts. `_archive/` is reference-only. Unbuilt intent here is **[ROADMAP]**.

# Art Direction — Stub

**Status:** Deferred from initial GDD. To be specified pre-mockup phase. **Highest-priority deferred item** — drives all subsequent visual work.

## Scope

Visual style guide for characters, monsters, weapons, parts, UI, and environments.

## Open design questions

- **Style spectrum**:
  - **Cute Wittle-flavor** (chibi proportions, big eyes, bright colors). Mass-market friendly. Lower art cost. Lower whale-appeal.
  - **Stylized fantasy** (AFK Journey / Hero Wars, painterly with detailed character art). Higher whale-appeal. Higher art cost. Standard casual-mobile-RPG aesthetic.
  - **Grimdark fantasy** (Raid: Shadow Legends). Strong UA performance, narrow audience appeal.
  - **Hand-drawn / illustrated** (Cookie Run-style). Distinctive but expensive per asset.
- **Character proportions**: chibi vs half-realistic vs full-realistic.
- **Weapon art treatment**: how does a 3-part weapon visually combine? Layered sprite stack? Pre-rendered combinations? Procedural?
- **UI direction**: skeumorphic (wooden plank menus, parchment scrolls) vs flat-modern.
- **Color palette**: per-chapter themes (forest green, desert ochre, dungeon stone)?

## Recommended approach

**Stylized fantasy with chibi-leaning characters** (somewhere between AFK Journey and Wittle Defender). Reasons:
- Whale-appeal high enough to support gacha pulls.
- Art cost manageable vs full-realistic.
- Reads instantly to the genre's existing audience.
- Weapon visuals can use a layered sprite stack — each part contributes a layer (Head sprite + Hilt sprite + Rune glow overlay).

## References to consult

- AFK Journey character art (closest to recommended direction).
- Wittle Defender (slightly chibier, very mobile-friendly).
- Hero Wars (more painterly but similar audience).
- Cookie Run: Kingdom (most distinctive, hardest to ship at scale).
