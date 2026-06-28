> **SSOT:** [01_GDD.md](../01_GDD.md) — single source of truth for `2_Weaponcraft_Godot`. This spec elaborates the GDD; the Godot build in `Prototype/godot/` wins on current-state facts. `_archive/` is reference-only. Unbuilt intent here is **[ROADMAP]**.

# Boss Affinity Taxonomy — Stub

**Status:** Deferred from initial GDD. To be specified during pre-prototype design refinement.

## Scope

The full list of boss affinity types (resistances, weaknesses, immunities) and how they are visually telegraphed to the player. Critical for the **boss-retry counter-build** core hook.

## Locked anchors (already in GDD)

- Bosses have **visible affinities** — telegraphed pre-fight.
- First attempt usually fails (engineered for the counter-build dopamine).
- Game keeps all unlocks + parts; player rearranges lineup + reforges weapons + retries.
- Element keywords available at launch: **Fire / Ice / Bleed / Holy / Shadow / Lightning / Pierce / Poison**.

## Open design questions

- **Affinity types per boss**: how many? 1 weakness + 1 resistance + 1 immunity?
- **Numerical impact**: weakness = +50% damage from that element? Immunity = 0 damage?
- **Telegraph design**: icon row on boss splash screen? Animated weakness pulse? Tooltip on hover?
- **Affinity rotation**: do bosses have one fixed affinity, or rotate weekly?
- **Counter-build viability**: every affinity needs at least 2–3 ways to counter (multiple element tags, multiple class strategies). Avoid bosses where only one specific Legendary character can clear.
- **Easter-egg affinities**: hidden boss weaknesses (e.g., "this boss takes 100% extra from Necrosis recipe") that reward discovery codex completion.

## Boss affinity types to launch with (proposed)

Each boss should have **1 weakness** (visible), **1 resistance** (visible), and optionally **1 immunity** (visible after first attempt).

Examples:
| Boss | Weakness | Resistance | Immunity |
|---|---|---|---|
| Magma Tyrant | Ice | Fire | — |
| Frost Wyrm | Fire | Ice | Pierce |
| Bloodbound Knight | Holy | Bleed | — |
| Shadow Sovereign | Holy + Light | Shadow | Shadow |
| Stormcaller | Pierce | Lightning | — |
| Plagueheart | Holy | Poison | Poison |

Pattern: each element has at least 2 bosses that fear it (encourages players to keep variety in their roster).

## References to consult

- AFK Arena's faction/element rock-paper-scissors.
- Slay the Spire boss weakness telegraphing.
- Pokémon type chart (gold standard for elemental matchups, though too complex for casual mobile).
