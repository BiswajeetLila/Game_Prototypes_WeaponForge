> **HISTORICAL — describes the previous 2_WC craft+collect direction. Superseded 2026-06-12 by the WeaponForge TFTransistor pivot (Function Matrix + 3-lane auto-runner + Magicka reactions). Current SSOT: [`01_GDD.md`](../01_GDD.md). Pivot rationale: [`../superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`](../superpowers/specs/2026-06-12-fork-a-pivot-addendum.md).**

# Parts — Launch Catalogue

**Status:** Scaffold. ~30 base parts planned at launch, distributed across slot types and element tags.

## Part schema (locked)

Every part is defined by:
1. **Slot type** — Head / Hilt / Rune.
2. **Class affinity** — Warrior-only / Mage-only / Rogue-only / Universal (≈30% Universal, 70% class-locked).
3. **Element / keyword tag(s)** — Fire / Ice / Bleed / Holy / Shadow / Lightning / Pierce / Poison / (more later).
4. **Flat stats** — ATK / HP / Crit% / Crit DMG / Element DMG / etc.
5. **Rarity** — Common / Rare / Epic / Legendary. Higher rarity = higher stat values + occasional additional tag.

Note: late-game weapon **4th slot (Modifier)** unlocks at Mastery 20+. Modifier parts have unique passives (bleed-on-hit, ricochet, life-leech) and a separate parts catalogue not enumerated here.

---

## ~30 base parts at launch (placeholder names)

### Heads (10 parts)
| Name | Class | Element Tag | Notes |
|---|---|---|---|
| Iron Edge | Warrior | — | Baseline melee head |
| Steel Cleaver | Warrior | Bleed | |
| Magma Edge | Warrior | Fire | |
| Crystal Orb | Mage | — | Baseline staff head |
| Frostfire Orb | Mage | Ice + Fire | Dual-tag, rare |
| Storm Crystal | Mage | Lightning | |
| Curved Dagger | Rogue | Pierce | |
| Serpent Fang | Rogue | Poison | |
| Shadow Blade | Rogue | Shadow | |
| Twin Strike | Universal | — | Bonus attack speed |

### Hilts (10 parts)
| Name | Class | Element Tag | Notes |
|---|---|---|---|
| Iron Hilt | Universal | — | Baseline |
| Oak Hilt | Universal | — | +HP variant |
| Steel Grip | Warrior | — | +ATK |
| Heated Grip | Warrior | Fire | |
| Wand Shaft | Mage | — | +Element DMG |
| Cursed Shaft | Mage | Shadow | |
| Leather Grip | Rogue | — | +Crit% |
| Venom Grip | Rogue | Poison | |
| Holy Pommel | Universal | Holy | Rare |
| Stormlace Grip | Universal | Lightning | Rare |

### Runes (10 parts)
| Name | Class | Element Tag | Notes |
|---|---|---|---|
| Fire Rune | Universal | Fire | |
| Ice Rune | Universal | Ice | |
| Bleed Rune | Universal | Bleed | |
| Holy Rune | Universal | Holy | |
| Shadow Rune | Universal | Shadow | |
| Lightning Rune | Universal | Lightning | |
| Pierce Rune | Universal | Pierce | |
| Poison Rune | Universal | Poison | |
| **Charge Rune** | Universal | — | **Accelerates ultimate gauge fill rate** (Q9 mechanic) |
| **Echo Rune** | Universal | — | **Triggers tagged effect a second time at 50% power** (rare) |

---

## Rarity scaling

| Rarity | Stat multiplier | Drop rate (in shop) |
|---|---|---|
| Common | 1.0× | 70% |
| Rare | 1.5× | 22% |
| Epic | 2.2× | 7% |
| Legendary | 3.5× | 1% |

Same part name across rarities — Common Fire Rune vs Legendary Fire Rune — same tag, scaled stats. Merge mechanic (3 of lower → 1 of higher) preserves tag identity.

## Open design tasks

- Final part names + lore flavor.
- Exact stat values per rarity.
- Class affinity balance pass (avoid any class having too many or too few part options).
- Art briefs (silhouettes for each Head/Hilt/Rune family).
- Modifier-slot parts (separate catalogue for Mastery 20+ unlock).
- Universal vs class-locked ratio playtest.
