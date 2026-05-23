# WeaponCraft — Variant Comparison

Cross-variant index. One row per variant folder. Add new variants as new rows. Keep this file as the single source of truth for what each variant is testing and where its docs live.

---

## Variants

| # | Folder | Variant name | What changed from base | GDD link | Status |
|---|---|---|---|---|---|
| 1 | `1_Robotek_WeaponCraft/` | Base | — (canonical reference design) | [01_GDD.md](1_Robotek_WeaponCraft/docs/01_GDD.md) | Locked |

---

## Dimensions tracked across variants

When adding a new variant, fill out a delta on these axes in its `VARIATION.md`. Leave unchanged axes blank.

| Axis | Base value (variant 1) |
|---|---|
| Setting / theme | Medieval fantasy |
| Combat pacing | Turn-based, Robotek-cadence |
| Combat agency | Auto + single-tap ultimate |
| Combat scale | 3-character party, side-view single lane |
| Weapon lifetime | Per-stage, persistent meta |
| World structure | Chapter map (→ + endless tower in S2) |
| Weapon anatomy | 3-slot (Head + Hilt + Rune); 4th unlocks late |
| Parts feed | TFT-style shop with reroll |
| Ultimate charge | Damage-dealt + Charge Rune + time cap |
| Recipe discovery | Enriched hybrid (silhouettes + scrolls + templates) |
| Stage structure | 5–6 waves per stage, ~3–4 min |
| Monetization | F2P + gacha + BP + ads + light energy + cosmetics |
| Part schema | Stat + class affinity + element tag |
| Roster launch | 15 chars (3 free, 12 gacha), 1% Legendary, 80-pull pity |
| Character progression | Hybrid TFT-pattern (roles + light scaling) |
| Merge mechanics | Parts auto-merge in stash + character Star-Up via dupes |
| Boss-retry counter-build | Yes |
| Art direction | Deferred (recommended: stylized fantasy, chibi-leaning) |

---

## How to add a new variant

1. New chat in `Game_Prototypes/`. First prompt: *"Read `1_Robotek_WeaponCraft/docs/01_GDD.md` as base context. Brainstorm a variation where [delta]. Output to `N_WeaponCraft_<name>/docs/`."*
2. Variant folder mirrors base scaffold: `docs/`, `Mockup/`, `Prototype/`.
3. Variant root contains `VARIATION.md` listing only the delta from base (3-5 bullets).
4. Variant `docs/01_GDD.md` is a full GDD — copy base, edit where variant diverges.
5. Add a row to the **Variants** table above with folder, variant name, delta summary, GDD link, status.
