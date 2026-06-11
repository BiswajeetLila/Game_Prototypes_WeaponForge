> **SSOT:** [01_GDD.md](../01_GDD.md) — single source of truth for `2_Weaponcraft_Godot`. This spec elaborates the GDD; the Godot build in `Prototype/godot/` wins on current-state facts. `_archive/` is reference-only. Unbuilt intent here is **[ROADMAP]**.

# Recipes — Discovery Codex

**Status:** Scaffold. ~200 discoverable recipes at launch.

## Recipe schema (locked)

A **recipe** is a named effect that emerges when a weapon contains a specific **tag combination**. Recipes are not 1:1 part-to-effect — multiple part combos can satisfy the same recipe.

Each recipe has:
- **Name** — flavor-evocative (Steamburst, Hemorrhage, Twilight).
- **Effect** — gameplay mechanical impact.
- **Trigger tags** — set of element/keyword tags required (typically 2).
- **Class variants** — Warrior/Mage/Rogue versions with flavor-distinct VFX (same mechanical effect).
- **Discovery state** — silhouette (effect known, recipe hidden) → discovered (recipe revealed) → mastered (build template saveable).

---

## ~30 launch recipes (placeholder)

Each recipe lists the **trigger tags** (any part in the weapon contributing this tag counts). Players discover combos by crafting weapons whose tags match.

### Elemental Combination Recipes
| Recipe | Trigger Tags | Effect |
|---|---|---|
| **Steamburst** | Fire + Ice | AoE on hit (3-tile radius) |
| **Thunderclap** | Lightning + Iron | Chain lightning between enemies on crit |
| **Hellfire** | Fire + Shadow | Burning DoT zones at impact |
| **Frostbite** | Ice + Pierce | Slow + reduced enemy defense |
| **Stormstrike** | Lightning + Pierce | Hits 3 random targets |
| **Solar Flare** | Fire + Holy | Burst damage on first hit only |
| **Twilight Edge** | Holy + Shadow | Alternates damage type each swing |
| **Permafrost** | Ice + Ice (e.g., 2 Ice Runes) | Persistent slow aura |
| **Inferno** | Fire + Fire | Stacking burn DoT |
| **Eclipse** | Shadow + Shadow | Stealth on every 4th attack |

### Status DoT Recipes
| Recipe | Trigger Tags | Effect |
|---|---|---|
| **Hemorrhage** | Bleed + Crit (via Crit Hilt) | Bleed damage doubles on crit |
| **Necrosis** | Poison + Bleed | Two DoTs compound multiplicatively |
| **Plague** | Poison + Shadow | DoT spreads to adjacent enemies |
| **Open Wound** | Bleed + Pierce | Bleed bypasses defense |
| **Toxin Burst** | Poison + Lightning | Poison ticks 3× faster |

### Defensive / Support Recipes
| Recipe | Trigger Tags | Effect |
|---|---|---|
| **Sanctuary** | Holy + Oak (Hilt) | Self-heal on each kill |
| **Aegis** | Holy + Iron | Damage reduction aura |
| **Vampire's Kiss** | Bleed + Shadow + (Vampire Rune?) | Life-leech on hit |

### Crit / Multistrike Recipes
| Recipe | Trigger Tags | Effect |
|---|---|---|
| **Phantom Strike** | Shadow + Pierce | Every 3rd attack ignores defense entirely |
| **Storm Volley** | Lightning + Multi-attack hilt | All attacks become multi-target |
| **Razor Wind** | Pierce + Crit | Crit chance +25%, crits ricochet |

### Charge / Ultimate Recipes
| Recipe | Trigger Tags | Effect |
|---|---|---|
| **Quickdraw** | Charge Rune + (any) | Ult charges 50% faster |
| **Echo Cast** | Echo Rune + (any) | Ult fires twice at 50% power each |
| **Soulfire** | Fire + Charge Rune | Burn damage builds ult charge |

### Class-Tinted Hero Recipes
Some recipes activate **only when used by a specific class**, opening hero-signature build paths:

| Recipe | Trigger | Class | Effect |
|---|---|---|---|
| **Berserker's Roar** | Bleed + Fire | Warrior | Self-damage → massive ATK scaling |
| **Frostweaver** | Ice + Ice | Mage | All AoE radius +50% |
| **Death Dance** | Shadow + Poison | Rogue | Each kill resets ult |
| **Divine Wrath** | Holy + Lightning | Paladin | Ult triggers party-heal |
| **Wild Surge** | Nature + (any) | Druid | Random buff each turn |
| **Soul Banker** | Shadow + Bleed + Holy (rare 3-tag) | Necromancer | Stores damage for delayed AoE |

---

## Discovery codex structure

Codex grouped into 3 sections (matches gameplay readability):
1. **Elemental** — combinations of pure element tags.
2. **Status** — DoT / debuff combinations.
3. **Class signature** — hero-specific recipes.

Within each section, undiscovered recipes appear as:
> **???** makes *Steamburst — AoE on hit (3-tile radius)*
> Recipe: [hidden] + [hidden]

After first discovery:
> **Fire Rune + Ice Rune** makes *Steamburst*
> Variants known: 1/3

After discovering all variants:
> **Steamburst — Mastered**
> Variants: Fire Rune + Ice Rune, Magma Edge + Ice Rune, Inferno Hilt + Frost Rune

---

## Open design tasks

- Final recipe names + lore.
- Exact mechanical numbers for each effect.
- Variant counts per recipe (2–4 variants each).
- Class-tinted VFX direction (briefs for art team).
- Recipe pacing — which 5–10 are seeded in tutorial, which 20 are reasonable in first chapter, etc.
- Late-game 4th-slot Modifier recipes (separate doc).
- Recipe scroll drop rates (premium item economy).
