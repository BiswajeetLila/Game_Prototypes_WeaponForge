> **SSOT:** [01_GDD.md](../01_GDD.md) — single source of truth for `2_Weaponcraft_Godot`. This spec elaborates the GDD; the Godot build in `Prototype/godot/` wins on current-state facts. `_archive/` is reference-only. Unbuilt intent here is **[ROADMAP]**.

# Cosmetic Taxonomy — Stub

**Status:** Deferred from initial GDD.

## Scope

Full taxonomy of cosmetic items — what categories exist, where they're acquired, how they're priced.

## Locked anchors (already in GDD)

Cosmetic monetization hooks already locked:
- **Hero skins** (alternate outfits for owned heroes).
- **Weapon visual effects** (glow, trail, particle effects on the crafted weapon).
- **Ultimate animation skins** (different VFX/animation when firing a hero's ultimate).
- **Banner frames** (player profile decoration).

## Open design questions

- **Cosmetic categories at launch**: which slots ship in v1.0?
- **Pricing tiers**: epic skin = $9.99? Legendary skin = $19.99? Bundle deals?
- **Acquisition paths**: pure IAP? Earnable via grind? BP exclusives? Event drops?
- **Cross-character cosmetics**: weapon glow tied to weapon (not hero), so applies to any hero wielding that weapon?
- **Cosmetic gacha**: separate cosmetic banner (Genshin-style "outfit gacha")? Or pure direct purchase?
- **Stackable effects**: weapon glow + weapon trail + element particle — do they stack visually?

## Recommended approach

**Pure direct-purchase cosmetics**, no cosmetic gacha. Reasons:
- Player goodwill (gacha cosmetics get backlash in casual-mobile).
- Easier UA messaging ("buy this skin directly" beats "pull this skin from this banner").
- Whales still spend; the floor lifts.

Launch with:
- **Hero skins**: $9.99 epic, $14.99 legendary. 3 skins per hero by Season 2.
- **Weapon glow effects**: $4.99 each, 10 at launch.
- **Ultimate VFX skins**: $9.99 each, 1 per class at launch.
- **Banner frames**: earnable via achievements + premium frames in BP.

## References to consult

- Genshin Impact cosmetic gacha (counter-example — players complained).
- Apex Legends direct-purchase cosmetics (positive player reception).
- Honkai: Star Rail cosmetic strategy (mixed direct + earn).
