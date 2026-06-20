# CORRECTION — Gear Defenders' "King" is an active combatant (+ has a skill)

**Date:** 2026-06-17 · **Trigger:** WeaponForge design-mapping review flagged the original spec's "Player Hero = static cosmetic" claim as wrong. Verified via fresh web research (gameplay-video frame analysis + store listing).

## What the original docs got wrong

Both spec files claim the player character is cosmetic:
- [`gear-defenders-design-spec.md`](gear-defenders-design-spec.md) line ~219 — *"The Player Hero … is a static cosmetic character, not a controlled unit."*
- [`Gear_Defenders_Design_Spec.md`](Gear_Defenders_Design_Spec.md) line ~258 — same claim.
- [`../../My_Notes/Gear Defenders - Game Design Breakdown.md`](../../My_Notes/Gear%20Defenders%20-%20Game%20Design%20Breakdown.md) — implies the King is only a base/identity character.

**Root cause:** the original crawl (silent walkthroughs + review text) saw the **passive mascot** — the blond kid sitting on the wall reading/holding a sword, also the game's cover/title character — and concluded "cosmetic." It **missed the separate King unit**, a gacha-summoned combatant. The King System shipped in **v1.3.5**, *before* the v1.4.8/1.4.9 crawl, so it was live and missable — not absent at the time. Text sources (store listings, tier lists, apkfami) describe the King only as a stat/equipment system and are silent on the on-wall firing, which is why text-only crawling missed it; it is only visible in gameplay footage.

## Verified facts (web research 2026-06-17)

1. **King fires periodic attacks from the wall — YES.** The active King is a gold-armored, gacha-summoned unit (e.g. *"Doom King – Edward"*, classified Ranged/Infantry, ATK 1174 @Lv4). It stands on the wall/gate line with a circular cooldown timer beside it and auto-fires its skill (radial timer observed counting 17s → 5s → fire).
2. **King has a skill ("ultimate") — YES, but AUTO-CAST on cooldown, not a manual tap.** *"Gale Arrowstorm"* (CD 60s): "Randomly rain down arrows above enemies, a total of 10 arrows, each dealing 100% basic ATK DMG." No manual skill/ultimate/rage button exists in the battle UI — only Pause, Speed (×1), gear Refresh, and Battle. The firing IS the skill (same single ability).
3. **King is a full collectible (gacha) system.** Summon banner with Draw 1 / Draw 10 + pity ("Guaranteed … in 89 summons"). First King *"Lionheart Richard"* (v1.3.5) → upgraded to **4 Kings** (v1.3.9). King has its own level (Lv4 shown) and ATK stat. Multiple Kings collected; one equipped active; rarity starred (Edward = 4★).
4. **King gives army-wide passive bonuses even when its skill isn't firing.** "Top King Bonus: Attack +1.6%", "Total King Bonus: HP +0.4%."
5. **King Equipment system (v1.5.0):** "Equip your King with exclusive gear and socket Jewels to boost battle and Troop stats." King also had Live2D animation (temporarily disabled v1.3.8/1.4.0) — confirms a featured animated character, not an icon.
6. **Two distinct characters — do not conflate.** Passive mascot (cosmetic cover art) ≠ the summoned King (combatant). The original docs described the mascot.

## Sources

1. Prohan Gamer — "NEW King System Upgrade! 4 New Kings in Gear Defenders" (King panel + in-battle King on wall + "Gale Arrowstorm CD 60") — https://www.youtube.com/watch?v=eJLI9QXZvzc
2. Apple App Store listing + What's New (King System history, King Equipment, "join the battle") — https://apps.apple.com/us/app/gear-defenders/id6740892835
3. Pryszard 27-min walkthrough (core loop + on-wall character through Lv46) — https://www.youtube.com/watch?v=KGGgsYPQoEk
4. clashiverse beginner guide + tier list (clarifies tier-list "heroes" = troop/gear units, distinct from Kings) — https://clashiverse.com/gear-defenders-beginner-guide/ , https://clashiverse.com/gear-defenders-tier-list/

**Confidence:** HIGH for the King firing from the wall + the collectible system (direct video-frame confirmation). HIGH for "auto-cast on cooldown, no manual button" (consistent across ~27 min of footage to Lv46). Residual: whether a later King/build adds a manual cast — not observed.

## Implication for the WeaponForge mapping

- **"Hero = GD's King" is now a STRONG map** (not the weak/cosmetic one in the first draft): GD's King = gacha collectible + stands at base + auto-fires a skill + army-wide passive bonus + equipment ≈ our hero (collectible wielder + innate weapon-passive + ult + later catalysts/gear).
- **Our manual tap-ult is a deliberate DIVERGENCE / improvement:** GD auto-casts the King skill on a fixed cooldown; we hand the player the trigger (charged off reactions) — player agency GD lacks.
- The earlier mapping doc claim "GD has no hero ult" was WRONG and is corrected by this report. See [`../../../6_WeaponForge_TFTransistor/docs/superpowers/specs/2026-06-17-gear-defenders-to-weaponforge-mapping.html`](../../../../6_WeaponForge_TFTransistor/docs/superpowers/specs/2026-06-17-gear-defenders-to-weaponforge-mapping.html) (needs a follow-up edit to §1/§3 and Table 1).
