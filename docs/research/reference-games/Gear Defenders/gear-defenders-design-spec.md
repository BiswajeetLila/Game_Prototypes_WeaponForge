# Gear Defenders — Game Design Documentation

**Researcher:** Biswa
**Compiled:** 2026-05-27
**Subject:** Gear Defenders (Mobibrain Technology Pte Ltd) — Android package `com.iogame.gearworld`, iOS App Store id `6740892835`
**Soft launch / Release:** Apple original release 2025-01-29 (soft launch?); apkfami "released" 2025-11-16 (likely global launch) → 2026-05 actively updated (v1.4.9 iOS / v1.4.8 Android crawled)

---

## Source Tagging Conventions

This document is built from 6 web sources (~107 KB content), 7 YouTube videos (~5.7 hours of footage, ~150 KB notes+transcripts), and 3,011 Play Store review bodies (3.4% of 88,339 lifetime ratings). Every claim is tagged so you can trust its provenance.

| Tag | Meaning | Strength |
| --- | --- | --- |
| **[Source: <provider>]** | Directly stated in scraped content (creator, blog, review, in-game UI screenshot OCR) | High |
| **[Cross-confirmed]** | Stated by ≥2 independent sources | Highest |
| **[Inferred]** | My deduction from indirect signals — not stated, but supported by data | Medium |
| **[Assumed]** | Industry-norm assumption based on genre conventions, not in any source | Low — verify before betting on |
| **[Gap]** | Information explicitly missing from corpus | — |

Trust hierarchy: `[Source: Reviews-lifetime]` > `[Source: WEB:*]` ≈ `[Source: V:*]` (creator commentary preferred over silent walkthroughs) > `[Source: Reviews]` (individual quotes) > `[Inferred]` > `[Assumed]`.

Source shorthand:
- **GameHydro1** = Game Hydro "Tips, Cheats, Strategy Guide" (2025-11-04; `bG_jVb0KkoA`, 18:11, 20,202 views)
- **GameHydro2** = Game Hydro "TIER LIST of Best Heroes!" (2026-01-13; `UiWsglJN1D8`, 22:12, 6,892 views)
- **PryGames** = PryGames "Gameplay Walkthrough Part 1" silent (2025-11-23; `MNSeIZ_lRcA`, 18:59, 1,553 views)
- **Pryszard** = Pryszard "Gameplay Walkthrough Part 1" silent (2025-11-26; `KGGgsYPQoEk`, 27:02)
- **IOSTouch** = IOSTouchplayHD "Gear Defenders IOS Gameplay" silent (2025-07-05; `VfBxHo2Lkyc`, 13:13, 51 views)
- **PGames** = PGames "Gameplay Walkthrough Part 1" silent (2025-11-18; `ePO0xTaSiu8`, 8:29, 2,291 views)
- **WaltonRulf** = walton rulf "Arenas Abrasadoras Nivel 11–15" Spanish (2025-12-14; `GuHfd31XCjU`, 47:16)
- **PlayStore** = Google Play listing — description, 18–20 reviews (`com.iogame.gearworld`)
- **AppStore** = Apple App Store listing + 117 reviews scrape across US-iPhone, CA-iPhone, CA-iPad (id `6740892835`)
- **apkfami** = apkfami.net 3rd-party guide + linked `gear-defenders.md` page
- **MobibrainCatalogue** = Apple developer page — 15 apps; Android dev page comparator confirms duplicate Mobibrain catalogue (10 apps overlap on Android)
- **GearFightComparator** = Voodoo's `com.EternalStudio.GearFight` — adjacency comparator only, not same studio
- **Reviews** = Google Play Store review corpus (n=3,011, scraped avg 2.64★ — sample-biased toward "Newest" sort)
- **Reviews-lifetime** = `listing_metadata.json` authoritative Play Store lifetime metrics

---

## 1. Executive Summary

Gear Defenders is a **tower-defense + idle gear-merge hybrid** developed and published by Mobibrain Technology Pte Ltd (Singapore). [Source: PlayStore; AppStore] The most accurate compound tag is **tower-defense + auto-battler + gear-merge puzzle**, played in mobile portrait. Combat is fully automatic once units are deployed; player agency lives in (a) gear/troop selection between waves, (b) gear placement/merge on the grid, and (c) timing of one-shot boosters. [Source: GameHydro1, GameHydro2, WaltonRulf]

**Genre identity:** Self-description from store listing — "fresh blend of 'idle collection' and 'strategic adventure'... Build your war machine with a flick of your finger." [Source: PlayStore, AppStore; Cross-confirmed]

**Headline metrics:**
- **Lifetime Play Store rating:** 4.50★ across **88,339** ratings, distribution = 5★ 66,623 / 4★ 7,788 / 3★ 3,861 / 2★ 589 / 1★ 6,479 [Source: Reviews-lifetime]
- **Lifetime Apple App Store rating (US):** 4.82★ across **7,367** ratings [Source: AppStore]
- **Install count claim (Play Store):** 5,000,000+ [Source: PlayStore]
- **Last update (iOS v1.4.9):** 2026-05-13 [Source: AppStore]; **Play Store last updated:** 2026-05-13 [Source: PlayStore]
- **In-app purchase range (Play):** ₹100 – ₹9,700 [Source: PlayStore]; **Apple IAP range:** $0.99 – $19.99 [Source: AppStore]
- **Size:** 260.3 MB on iOS [Source: AppStore]; 156 MB as of v1.1.16 [Source: apkfami]
- **Supported languages (iOS):** 15 — EN, FR, DE, HI, ID, IT, JA, KO, PT, RU, ZH, ES, TH, ZH-TW, VI [Source: AppStore]
- **Mobibrain catalogue:** 15 published iOS titles; this is one of their biggest by rating count (#3 after Fish Eater.io at 55,950 and Idle Magic Academy at 24,192) [Source: MobibrainCatalogue]

**Strongest single signal of product-market fit:** The combined Play+Apple rating profile — 4.50★ from 88k Play reviews plus 4.82★ from 7k iOS — is **exceptionally strong for a free-to-play mobile game six months post-launch**. [Source: Reviews-lifetime, AppStore] The 5,000,000+ install number on Play, combined with 88k ratings, implies an unusually high opt-in rating rate (~1.8% of installers rate the app — 88,339 ÷ 5,000,000 = 1.77%). [Inferred] This pattern is more typical of polished casual hits than typical-installs casual TD games. The game has clear product-market fit in its segment.

**Three reasons it works:**
1. **Tactile satisfying core loop** — drag-and-drop gears around a Power Core to auto-produce troops who march to defend a bridge; reviewers explicitly call out the calculation/combinatorial puzzle pleasure. *"gear alignment strategies are very diverse"* (★5, 43👍); *"combine gears to generate soldiers... You have to think about how to combine the gears"* (★5, 35👍). [Source: Reviews]
2. **No-forced-ads early game is a major positive signal** — early reviewers repeatedly highlight that ads are optional. *"Good game with interesting mechanics. Quite a few adds, but you don't have to watch all of them"* (★5, 74👍); *"the ads only happen when you want to do an ad so it's not bombarding you with constant ads"* (★5, 70👍); *"It's fun, addictive, has no forced ads, and is challenging but not too difficult"* (★5, 38👍). [Source: Reviews]
3. **Tier-list-able cast with strong meta clarity** — 13 distinct named troops with clearly differentiated roles (Heavy Guard immune to crits, Catifact area damage, Paladine lasso/AoE, etc.); creator-driven theorycraft thrives because the mechanics support visible build differentiation. [Source: GameHydro2]

**Three reasons it bleeds players:**
1. **VIP/SVIP subscription deception is the single biggest churn driver** — the top-thumbed review (793 thumbs, 1★) is specifically about hidden 30-day duration on a purchase marketed as permanent. [Source: Reviews] The pattern repeats across many platforms and many months (Jan 2026 OracleX, Mar 2026 Reviews!32145, Apr 2026 copeharderdepressedboi, Apr 2026 eyeleeuh, Apr 2026 asdrewqa, Feb 2026 UOPayroll, Jan 2026 Chimprarr). [Source: AppStore, Reviews] Multiple players say "I would have paid more if it had been honest" — the deception is destroying high-LTV cohorts, not just freebie players.
2. **Ad infrastructure crashes / ads-without-reward** — broken ad SDK is consistently cited across reviews and across versions 1.0.7 → 1.4.8 (over 7 months). Players watch ads, the ad fails or freezes, and they lose level progress because there is no mid-level save. (★1, 142👍; ★5, 115👍; ★2, 102👍; ★1, 67👍) [Source: Reviews, GameHydro1] This converts the "voluntary ads" goodwill into rage.
3. **Save-progress fragility / no resume-mid-level** — multiple top reviews report losing all progress on a stage when the app is backgrounded, the device sleeps, or an ad crashes. Cited as a deal-breaker. *"My game has refused to save for over a week"* (★1, 142👍); *"leveled up my Archer 4 times today... still lost the progress"* (★2, 21👍). [Source: Reviews]

**Core thesis: Permission-gated ad watching as the primary monetization, wrapped in the "no forced ads" framing.** The game shows zero unskippable interstitials and instead funnels nearly every gameplay accelerator (gear refresh, troop summon, +1.5x speed, additional ad-only gear card, daily chest milestones, mid-level wall repair) into rewarded-video ad gates. [Source: GameHydro1, PryGames, Pryszard, WaltonRulf] This earns the game its 4.5★ rating because users feel they're in control — until the difficulty ramps and "voluntary" becomes "required." *"you realize it's entirely pay to win (via ads, you're effectively paying them with more time)"* (★1, 65👍, v1.4.5); *"Anything you want to do seems blocked behind an ad"* (★2, 18👍). [Source: Reviews] The high opt-in rating rate strongly suggests this perception inversion happens consistently around mid-game. [Inferred] The "you can choose to watch them" frame is the single largest design decision shaping both the headline rating and the churn curve.

---

## 2. Core Gameplay Loop

### 2.1 The match (a single level / wave run)

A match is a **multi-wave timed lane defense run played in mobile portrait, on a static top-down view**. [Source: GameHydro1, PryGames, Pryszard]

```
┌─────────────────────────────────────────────────────┐
│ Pre-battle: select level on world map; energy ⚡×5  │
│   per battle; Castle HP scales by Castle Level      │
│   (Lv1 = 325, Lv2 = 1040, Lv3 = 2070; mid: 430,    │
│   473, 649)                                          │
│ [Source: Pryszard, GameHydro1, GameHydro2]           │
├─────────────────────────────────────────────────────┤
│ Build phase: drag troop-gear next to Power Core     │
│ to auto-spawn troops; refresh shop (gem/coin/ad)    │
│ for new gears; merge stacks; tap Battle to start    │
│ wave                                                 │
│ [Source: PryGames, Pryszard]                         │
├─────────────────────────────────────────────────────┤
│ Wave count scales with level:                       │
│   Lv1 = 5 waves, Lv2 = 6, Lv3 = 7, Lv4 = 8, Lv5 = 9 │
│   Lv11–15 = 12 waves (cap)                           │
│   Pattern: min(level + 4, 12)                       │
│ [Source: PryGames, Pryszard, GameHydro1, WaltonRulf;│
│   Inferred for the cap formula]                     │
├─────────────────────────────────────────────────────┤
│ Boss waves typically final wave of each level.      │
│ Banner "BOSS" with flame/devil icon slides in.      │
│ Boss enemies have numeric HP bars (330, 600).       │
│ [Source: Pryszard, WaltonRulf]                       │
├─────────────────────────────────────────────────────┤
│ Lose condition: castle HP (green bar over bridge    │
│ gate) reaches 0.                                     │
│ Partial completion is rewarded: "DEFEATED" +        │
│ "Completed Waves 7/8" + EXP/Gold/Troop Materials.   │
│ [Source: PryGames]                                   │
└─────────────────────────────────────────────────────┘
```

**Time pressure:** Within a wave, there is no clock — the wave ends when all enemies die. Between waves, the player gets a build phase to refresh and merge gears. [Source: Pryszard]

**Controls + camera:** Static top-down portrait view, **no shake, no pan, no zoom** during combat — confirmed across all 5 videos with battle footage. [Source: GameHydro1, GameHydro2, PryGames, Pryszard, IOSTouch, PGames, WaltonRulf; Cross-confirmed] apkfami corroborates: *"Visual effects such as attack animations and impact cues are deliberately restrained."* [Source: apkfami] Controls are drag-and-drop gear placement; tap to merge stacks; tap to refresh shop; tap to start wave. The official description names "drag, drop, and strategize." [Source: PlayStore, AppStore] apkfami: *"control system is built on simple drag-and-tap gestures, and placing gear clusters around the Power Core is smooth on touchscreens."* [Source: apkfami] Battle is fully automatic once waves begin. apkfami: *"The auto-battle system allows me to pause without feeling pressured to constantly concentrate."* [Source: apkfami] Pause button visible during battle from Level 3 onward. [Source: PryGames, Pryszard]

**Speed toggle:** 1× is default; **1.5× speed costs a rewarded ad** and lasts ~15 minutes. *"you can increase the speed of the game for about 15 minutes by hitting the play button up above that says X1. You can increase it to times 1.5. by watching an ad video"* [Source: GameHydro1]

### 2.2 Gear placement + merge (the core puzzle)

- **Grid:** a hex/circle pattern of gear slots around a central **Power Core** (yellow orb). Grid starts ~2×2 and expands to ~3×3 and ~4×4 as castle levels up. [Source: Pryszard]
- **Production rule:** a troop-gear placed adjacent to the Power Core (or in a connected chain via Speed Gears / connectors) auto-produces a soldier of that troop type at a rate displayed as "X.XX/s" (e.g. 0.14/s → 0.92/s over a run). [Source: PryGames, Pryszard, IOSTouch]
- **Merge mechanic:** stacking two identical-tier gears on the same slot merges them into the next tier. Tier numbers visible: 1 (grey) → 2 (blue) → 4 (gold/yellow) → 8 (red/gold high-end). [Source: GameHydro1, Pryszard] The exact tier sequence (1→2→3→4 vs 1→2→4→8) is not fully stated in any single source — some frames show Tier 4 as the apparent ceiling on the gear-ring badge [Source: Pryszard], others show Gear-8 [Source: GameHydro1]. The gear-ring number tracks merge count, doubling each merge (1→2→4→8), which is the standard merge-2 idle pattern. [Inferred]
- **Negative / locked slots:** "-1" gear slots appear on the grid as **rotation-bonus locks** — the creator describes the "-1" slot mechanic as confusing but related to circling the center gear with troops to gain a rotation bonus. *"Mechanic: surrounding a gear with troops reduces available gear positions by 1 to gain a rotation bonus"* [Source: WaltonRulf]; *"the presence of those negative gears there is going to kind of change what I can do battlewise"* [Source: GameHydro1]
- **Movable post-placement:** *"you can move your gears around after you place them. Don't forget that you can do that. So, we moved him around to get the maximum possible hits on the gear per rotation."* [Source: GameHydro1]
- **Merge strategy is the dominant in-run skill expression:** *"it's best to merge character gears together rather than having a whole bunch of separate ones. ... when you have too many character gears down, then your summoning can slow down."* [Source: GameHydro1]

**Power Core / center slot:** The **Power Core** is a fixed yellow orb at the center of the gear grid. [Source: PGames, Pryszard] Tutorial: *"Drag the Troops gear next to the power core can produce troops."* [Source: PGames] Power Core does not directly produce troops itself in early game — it is the **adjacency anchor** for troop gears. A separate "gold coin orb" appears on the grid in some sessions as a **passive coin generator** (no DPS shown). [Source: Pryszard] This may be a function-gear variant of the Power Core, not the Power Core itself.

**Between-wave shop:** The bottom card tray during the build phase offers three randomized gear choices. [Source: PryGames, Pryszard] Each gear shows its tier number, the troop sprite icon, and its coin cost.

- **Refresh costs:**
  - "Refresh 6" / "Cambiar 6" — uses a **rewarded ad** to give 6 refreshes. [Source: GameHydro1, WaltonRulf] The "6" number is the **count of refreshes you can chain** after watching one ad.
  - "Refresh" / "Actualizar" (5 coins or 5 gems) — paid single refresh. [Source: Pryszard, PGames, IOSTouch] Multiple sources show this priced in gold coins in some battles and in gems in others — possible mode-dependent pricing.
- **Battle button:** blue pill at far right of tray; starts the wave. [Source: Pryszard]
- One player wishes: *"A refresh button that costs double coins, but lets you pick 1 gear to guarantee."* (★4, 11👍) [Source: Reviews]

### 2.3 Troop production loop + Power Core

- Each placed gear continuously spawns soldiers of that troop's type along its production rate. Troops appear at the gear position with a small pop, then **march toward the top of the screen** to engage enemies. [Source: Pryszard, PryGames]
- **Troop cap (Chicken Leg / Turkey Leg system):** total simultaneous troops on the field are capped. Visible caps: 17/17 mid-game [Source: GameHydro1], 24/24 late-game [Source: WaltonRulf]. The cap is increased by upgrading the Castle. *"upgrading the castle levels hit points and the level of the castle itself will get... more chicken legs"* [Source: GameHydro1]
- **Troop combat is melee/ranged auto-engage:** units lunge or fire at the nearest enemy. Damage numbers float above hits (12, 17, 25, 27, 33, 45 observed). [Source: Pryszard, PryGames, PGames] No camera shake or hit-pause on impact.

### 2.4 Type advantage system / role differentiation

Confirmed in tier-list video — Infantry, Ranged, Cavalry, Heavy archetypes with explicit `Bonus DMG vs <type>` shown on troop cards. [Source: GameHydro2] Examples: Archer (Ranged) gets bonus vs Infantry; Lancer (Cavalry) gets bonus vs Ranged; Catifact (Cavalry) bonus vs Ranged; Arbalist (Ranged) bonus vs Infantry.

[Gap] No explicit elemental system (fire/ice/wind/etc.) is documented — the system is type-vs-type (Infantry/Ranged/Cavalry/Heavy), not elemental.

### 2.5 Special procs (Counter Warning, Unhurt 7s, Timed Buff, Restore)

- **Counter Warning / Counter Active:** mid-wave system that shows an incoming enemy formation icon set; the player gets a brief preview of what counters them. "Counter Active" then fires when the counter formation enters the field, applying some debuff/buff. Banner sweeps across castle wall area. [Source: GameHydro1, PryGames, Pryszard, PGames] [Gap] Exact effect not fully documented.
- **"Unhurt 7s" buff:** castle/bridge briefly glows gold and "Unhurt" text floats above; HP ticks back up by a small amount. Triggered situationally (likely an idle/no-hits-taken streak). [Source: PGames]
- **Timed Buff (x1.5):** a stackable global multiplier visible with two stacked countdown timers (e.g., 14:51 remaining / 19:05 total). Sources call it "Timed Buff" [Source: PryGames, Pryszard, WaltonRulf] or "Beneficio Temporal" in Spanish [Source: WaltonRulf]. Activation source not fully documented — possibly rewarded ad or daily login. Provides x1.5 to damage and/or game speed.
- **Boss waves:** typically the final wave of each level. Boss banner "BOSS" with flame/devil icon slides in from the right. [Source: Pryszard, WaltonRulf] Boss enemies have visible numeric HP bars (e.g., 330, 600). [Source: Pryszard] Bosses include large armored cataphract-types, "barn/spawn den" structures with their own HP bars, dragon-riders on Level 5, and a "scorched sands jumping invincible-during-jump" enemy mentioned by a reviewer: *"In Scorched Sands, that enemy that jumps and it gets invincible for a few seconds, sometimes gets buggy and is invincible forever, so unfinishable game"* (★5, 60👍). [Source: Reviews]
- **Spawn den / enemy barracks:** a thatched barn at the top of the field appears as an enemy spawn structure with its own HP bar in later waves of Levels 2–3 and beyond. [Source: PryGames, Pryszard, PGames]
- **Function Gear / Shield Gear:** a non-troop gear that applies a buff to adjacent troops. The Shield Gear specifically gives shields equal to ~31% (+1% per upgrade tier) of troop max HP. [Source: GameHydro1] The creator calls it his #1 gear pick: *"the shield will give them a free hit without taking any damage before it wears off."* [Source: GameHydro1]
- **Speed Gear:** a connector gear that boosts production rate of adjacent troop gears. Tutorial: *"The higher the Tier of the Speed Gear, the higher the efficiency of the connected production gears."* [Source: PryGames]
- **Chain card:** *"Connects two production gears; each production from one adds 10% progress to other"* — described in creator commentary but dismissed as not worth the coin cost. [Source: GameHydro1]
- **Ad-card (random level-up):** *"the card with the ad video... upgrades the level randomly of a character if you use it, but I'm not tapping it because the ad video will play automatically."* [Source: GameHydro1] Auto-triggers a rewarded ad on tap.
- **One-shot 100%-production gear (Nivel 11+):** a gear that *"immediately increase production 100%, disappear after activation"* — one-use booster. [Source: WaltonRulf]
- **"Restore" / "Restaurar" button:** appears on the castle HP bar when castle HP is critically low; likely costs gems or triggers an ad to restore wall HP mid-battle. [Source: PryGames, WaltonRulf] Players hate this — see the "meat system" complaint where soldiers get stuck behind the wall while the only repair option is an ad. (★2, 147👍) [Source: Reviews]

### 2.6 In-battle pacing & speed (camera, no-shake, VFX taxonomy)

The game's visual feedback is **deliberately minimal**. apkfami documents this as a design choice: *"Visual effects such as attack animations and impact cues are deliberately restrained. This helps players understand unit roles and enemy behavior without distractions."* [Source: apkfami] Across all 7 videos and across 25+ sampled frames (NOTES.md: *"Camera shake observations: No significant camera shake was observed in any sampled frame"*), the same pattern holds. [Source: GameHydro1]

**Present:**
- Floating damage numbers (white/yellow; orange for higher values like 45+) [Source: Pryszard, PGames]
- Yellow particle burst on AoE / explosion at castle gate [Source: Pryszard]
- White-flash hit pop on enemy sprites for ~1–2 frames [Source: IOSTouch, WaltonRulf]
- Coin drop "+30" floating text on enemy death [Source: GameHydro1]
- Soft yellow shield aura on troops with Shield Gear active [Source: GameHydro1]
- Green Counter Active banner sweep [Source: GameHydro1]
- BOSS banner slide-in with devil icon [Source: Pryszard, WaltonRulf]
- Astrology orb gacha pulsing animation [Source: GameHydro1]
- Star-up glow on upgraded troops [Source: GameHydro2]
- Gear orbit/rotation animation on production gears [Source: IOSTouch]

**Conspicuously absent:**
- Camera shake (all 5 battle videos — zero shake) [Source: GameHydro1, PryGames, Pryszard, IOSTouch, WaltonRulf; Cross-confirmed]
- Hit-pause / hit-stop [Source: GameHydro1]
- Full-screen flash [Source: GameHydro1]
- Death explosions or particle ragdolls (NOTES.md: *"Enemies appear to briefly flash then disappear; no ragdoll"*) [Source: IOSTouch]
- AoE rings [Source: GameHydro1]

This restraint is intentional for low-end Android device compatibility (apkfami praises *"accessibility across a wide range of phones"*) [Source: apkfami] and for the auto-battle game model — the player's attention belongs on the gear grid, not the combat zone.

---

## 3. Meta Progression Systems

### 3.1 Hero / troop roster (rarities, tier list)

From the tier-list video and warband captures, **13 named troops** confirmed across 3 rarities. [Source: GameHydro2]

| Name | Rarity | Type | Notable trait |
|---|---|---|---|
| Warrior | Rare | Infantry | Balanced, no strengths |
| Archer | Rare | Ranged | Bonus vs Infantry; 30% chance to shoot 2 arrows at Star 1 |
| Shielder | Rare | Heavy | High prod speed + HP; tanky frontline |
| Lancer | Rare | Cavalry | Bonus vs Ranged; "Upon leaving the gate, performs a flanking charge, knocking aside enemies" |
| Alchemist | Rare | Ranged | Strong vs heavy; poison DoT; "extraordinarily slow" production speed |
| Spearman (Rare) | Rare | Infantry | Long range, good crit, bonus vs Infantry |
| Barbarian | Epic | Infantry | "Jumps into battle" entrance; axe whirlwind AoE at Star 1 |
| Mage | Epic | Ranged | High crit rate; splash + meteor shower; bonus vs Heavy |
| Arbalist | Epic | Ranged | Piercing bolts; 30% chance +2 bolts; guaranteed crit burst every 4s |
| Catifact (also spelled "Cataphract") | Epic | Cavalry | 100% area damage arc swing; lance swing |
| Heavy Guard | Epic | Heavy | **Immune to crits**; reduces AoE damage taken by 50% within 3m; blocks enemies within 1m |
| Caveman | Legendary | Infantry | Wall-damage niche; near-death piercing glove throw |
| Spearman (Legendary) | Legendary | Infantry | Better Rare Spearman; bonus vs Cavalry; fast production |
| Ninja | Legendary | Ranged | Highest attack speed + prod speed; throwing stars; smoke screen; shadow clones |
| Paladine | Legendary | Cavalry(?)/Heavy | Spinning hammer AoE; holy shield glow; **lasso ally** mechanic (yanks slower allies forward) |

Notable observations:
- Both Spearman variants exist with identical names — creator calls this out: *"I don't know if the developers realize that they named two of the characters in the game the same thing."* [Source: GameHydro2]
- The v1.4.9 update added new top-tier units: **"First Mythic Cavalry: Elephant Knight. Trample everything!"** and **"Legendary Mage: Thunder Caller. Thunder strikes!"** [Source: AppStore] Mythic appears to be a new rarity above Legendary, introduced post-Tier-List video.
- **⚠ CORRECTED 2026-06-17 — THIS LINE IS WRONG. See [`CORRECTION-2026-06-17-king-is-an-active-combatant.md`](CORRECTION-2026-06-17-king-is-an-active-combatant.md).** It describes only the passive *mascot*. A SEPARATE gacha-summoned **King** stands on the wall and auto-fires a skill ("Gale Arrowstorm", CD 60s), grants army-wide passive bonuses, and has its own gacha/level/equipment system (v1.3.5+).
- ~~The Player Hero (blonde chibi at the bridge gate, sometimes shown reading a book) is a static cosmetic character, not a controlled unit.~~ [Source: Pryszard, PryGames, PGames] Gains visual variation (sword, fire aura on Counter Active). [Source: Pryszard, PGames] *(← "cosmetic" claim conflated the mascot with the King; corrected above.)*

### 3.2 Gear (the merge-able cards — core economy)

- Gears merge by stacking same-tier identical gears in the same slot. Tier number visible on the gear ring.
- Higher-tier gears produce faster (Tier 1 ~0.14/s → Tier 8 ~0.53/s). [Source: GameHydro1, Pryszard]
- Higher-tier Speed Gears multiply adjacent troop-gear production. [Source: PryGames]
- Players can purchase gear from the between-wave shop using coins, refresh the shop using gems or ads, and combine duplicates. [Source: Pryszard]

### 3.3 Troop tiers (gear tiers, not rarities)

Visible on the in-grid gear-ring badge:
- **Tier 1** — grey gear; lowest production rate (0.14–0.21/s) [Source: Pryszard, IOSTouch]
- **Tier 2** — blue gear; standard early game (0.17–0.35/s) [Source: Pryszard]
- **Tier 3** — orange/gold gear (0.18–0.45/s) [Source: Pryszard]
- **Tier 4** — bright yellow gear; late-mid game (0.34–0.71/s) [Source: Pryszard]
- **Tier 8** — red/gold high-tier (0.53/s+) [Source: GameHydro1]

The tier-ring number is the merge count of stacked Tier-1 gears. The doubling pattern 1→2→4→8 is the standard merge-2 progression; this matches visible tier badges. [Inferred]

### 3.4 Heroes / Hero Gears (recent addition)

apkfami's What's New section documents: *"Added Hero Gears and Skill Gears for expanded strategy options"* and *"Hero Gears and Skill Gears introduced in its most recent update deepen strategic options."* [Source: apkfami] The exact mechanics aren't fully documented in the corpus — they likely extend the function-gear system with troop-specific buffs (Hero Gears) and skill-trigger modifications (Skill Gears). [Assumed]

### 3.5 Skill Gears (recent addition)

See 3.4 — apkfami groups Hero Gears and Skill Gears as a paired recent system addition. No video captures them being placed or activated specifically. [Gap]

### 3.6 Castle upgrades / troop cap

- Castle has its own level. Upgrade Castle increases:
  - **Castle HP** (lose threshold) — visible scaling: Lv1 325 → Lv2 1040 → Lv3 2070 → Lv5 mid-range. [Source: GameHydro1, GameHydro2, Pryszard]
  - **Troop cap (Chicken Legs)** — *"upgrading the castle levels hit points and the level of the castle itself will get... chicken legs."* [Source: GameHydro1] Cap evolves from 10 (start) → 17 → 24. [Source: GameHydro1, WaltonRulf]
- Castle upgrade tokens are awarded in wave chests. [Source: GameHydro1]
- Upgrade cost visible at Castle Lv2 = 620 coins to upgrade [Source: GameHydro1]; Lv5 = 1430 coins [Source: GameHydro2].
- The "Wall system is fully upgraded!" line in v1.4.9 patch notes hints at wall sub-stats. [Source: AppStore]

### 3.7 Energy / stamina

- **Cost:** ⚡×5 per battle [Source: GameHydro1, GameHydro2, WaltonRulf, IOSTouch, PGames; Cross-confirmed]
- **Max cap:** 30 ⚡ [Source: GameHydro1, IOSTouch, PGames; Cross-confirmed]
- **Regen timer:** ~1 unit per few minutes (countdown "00:21" visible at near-cap; "01:24" visible elsewhere — implies ~3–5 minutes per ⚡ at full speed). [Source: WaltonRulf, PGames, GameHydro1] Specific regen rate not exactly documented — combining 30-max + multi-battle play sessions implies ~3–6 min per ⚡. [Inferred]
- **Energy bug post-update:** *"Energy is needed to play but it is no longer regenerating with a timer of 1k+ hours, afk/patrol income no longer works, purchasing energy also has 1k+ cd"* [Source: AppStore] and *"the energy stopped refilling after recent update"* [Source: AppStore], *"regenerating energy at a pace of 105 hrs for a single energy"* [Source: AppStore]. **Bugged energy regen is a recurring post-update complaint.**
- **Patrol system:** parallel offline reward collection — "Patrol 05:55:46" timer on main screen [Source: GameHydro1]. Patrulla "00:03:39" in Spanish version [Source: WaltonRulf]. apkfami calls it *"afk/patrol income"* and notes it's tied to energy. [Source: AppStore]

### 3.8 Astrology / Alchemy / Gacha (late-game systems)

Two probability tables surfaced across the corpus, indicating either evolution of rates over time or two different gacha pools:

**Earlier rates (Nov 2025, Astrology pool)** [Source: GameHydro1]:
- Legendary: **4%** (Spearman, Ninja — and Troop Materials)
- Epic: **32%** (Barbarian, Mage, Arbalist, Cataphract — and Troop Materials)
- Rare: **64%** (Shielder, Warrior, Archer, Lancer — and Troop Materials)

**Later rates (Jan 2026, Alchemy/Astrology Reward Probability)** [Source: GameHydro2]:
- Legendary: **7.6628%** total (Spearman 0.0205%, Ninja 0.0205%, Paladine 0.0205%, Caveman 0.0205%, **Troop Materials 7.5808%**)
- Epic: **32.0174%** (Barbarian 0.3197%, Mage 0.3199%, Arbalist 0.3197%, Catifact 0.2197%, Heavy Guard 0.3197%, **Troop Materials 30.4133%**)
- Rare: **60.3198%** (Shielder 0.5933%, Warrior 0.5933%, Archer 0.5933%, Lancer 0.5933%, Alchemist 0.5933%, ...)

Critical observation: **the troop drop rates are catastrophically low** — even a Legendary is only ~0.02% per pull for any specific troop. The creator surfaces this: *"the game is kind of burying the lead a little bit though. You have very low probabilities of getting troops in general. You have very high probabilities of getting troop materials, which allow you to upgrade troops that you already have."* [Source: GameHydro1]

**Pity system:**
- *"Every 10 draws you get troops"* — guaranteed troop at 10-pull. [Source: GameHydro1]
- *"Every 100 draws you get guaranteed epic troops."* [Source: GameHydro1]
- Visible options in alchemy screen: "Excluding Pity", "Pity at 10 Pulls", "Pity at 100 Pulls". [Source: GameHydro2]
- **Legendary pity at 100 pulls** referenced by creator: *"Getting the caveman as my first legendary, it makes me feel like all those gems spent over in the alchemy area were a complete waste, honestly."* [Source: GameHydro2]

Pull options:
- **Draw 1** = 20 coins (soft) [Source: Pryszard]
- **Draw 10** = 180 gems (hard) [Source: Pryszard]
- **Draw 2** = ad-watch (0/5 ads) — gated ad pulls [Source: Pryszard]

**Astrology vs Alchemy naming:** Game Hydro's video calls the gacha "Astrology" and shows an elf character with crystal ball [Source: GameHydro1]. The tier-list video also references "the alchemy area" / "alchemy poll" / "alchemy pool" for legendary pity [Source: GameHydro2]. Most likely same system, different naming over versions or different in-game UI labels. [Inferred] [Gap] Conclusive disambiguation absent.

---

## 4. Progression Systems Map (visual)

```
                  ┌─── Troop Pool (Astrology/Alchemy gacha) ── 13 named troops
                  │      rarity ladder: Rare → Epic → Legendary → Mythic (v1.4.9+)
                  │      via Troop Materials (90%+ of drops)
                  │
LEVEL / WORLD ────┼─── Castle Level (Lv1 → Lv5+)
   MAP            │      via wave-chest tokens + 620–1430 coin upgrades
                  │      raises Castle HP (325 → 1040 → 2070)
                  │      raises Troop Cap "Chicken Legs" (10 → 17 → 24)
                  │
                  ├─── Gear Grid — drag-and-drop puzzle around Power Core
                  │      Tier 1 (grey) → Tier 2 (blue) → Tier 4 (gold) → Tier 8 (red/gold)
                  │      merge-2 doubling pattern
                  │      production rate 0.14/s (T1) → 0.53/s+ (T8)
                  │
                  ├─── Function Gears (Shield, Speed, Chain, one-shot 100% prod)
                  │      Shield: ~31% troop max HP (+1%/tier)
                  │      Speed: connector; multiplies adjacent prod
                  │      Chain: 10% cross-feed (creator dismisses as not worth coin)
                  │
                  ├─── Hero Gears + Skill Gears (recent post-launch addition)
                  │      [Source: apkfami] — mechanics not fully documented
                  │
                  ├─── Energy / Stamina — 30 cap, 5/battle, ~3–6 min/⚡ regen
                  │
                  ├─── Patrol / AFK Income — parallel passive cycle
                  │      Patrol timer e.g. 5:55:46
                  │
                  └─── Daily / Weekly / Event activities
                         Daily: check-in / 5 ads / 1 elite / 1 nightmare / 2 logins
                         Weekly: 5th chest = 300 gems
                         Events: Battle Festival, Boss Appears, Spring Festival 7d
                         Monster Codex (v1.4.9+) — battles-fought tracker

WORLD MAP LAYER:
  ├─ Forest Realm (4 stages?) → Scorching Sands (15 stages) → Aquatic/Ocean → ...
  ├─ 3 difficulty tiers per realm: Normal → Elite → Nightmare
  ├─ ≥191 levels per Normal cap reachable (top players: lvl 192 normal)
  └─ Stage selector: dotted-path nodes with chests at Wave 3 / 7 / 12

WHALE LAYER:
  ├─ VIP / SVIP ($3.99–$9.99) — 30-day passes marketed as "permanent" (DECEPTION)
  ├─ Battle Pass ($9.99–$19.99)
  ├─ Starter Pack / Piggy Bank / Pass — persistent lobby buttons
  ├─ Premium bundle ($500 → $50 discounted)
  └─ Daily Bundles (T1 Troop Bundle "400% MORE VALUE", refreshes ~10h)
```

---

## 5. The D1–D30 Player Experience

**Methodological caveat:** The corpus does not have a longitudinal D1–D30 player diary. The journey below is reconstructed from (a) silent gameplay walkthroughs (which show D1 progression mainly), (b) review-pack version-tagged complaints (which surface where the difficulty cliff hits), and (c) creator commentary on grind/pity timing. D-cohort timing claims are heavily [Inferred] or [Assumed] and tagged accordingly.

### 5.1 D1 — Onboarding (first session, ≈10–20 min)

Players see:
- A long, multi-level unskippable tutorial introducing each new mechanic. *"forced to do unskipable 'tutorials' every time a new thing is introduced"* (★2, 220👍); *"Barely through the tutorial and I can already tell how bad this is"* (★1, 42👍); *"Tutorial is way too long. One level. If you need more than one level to teach your mobile game, then I think that points to your game being badly designed for its platform"* [Source: AppStore Jason Keswick ★2]. [Source: Reviews]
- Tutorial tooltip examples: *"Drag the Troops gear next to the power core can produce troops"* [Source: PGames] and *"Place [Function Gear] to grant [Shields] to targeted troops"* [Source: PryGames].
- Forest Realm Level 1, Wave 1/5 — first wave is a single goblin. Player drags a single Warrior gear next to the Power Core. [Source: PGames]
- First merge happens via the between-wave shop refresh once player has duplicates.
- Castle HP 325, low troop cap, single gear slot active.
- Tutorial pushes the player through specific exact actions (cannot deviate) — *"How do I delete king you forced me to summon and upgrade?"* [Source: AppStore Cakekizy ★1] indicates the tutorial forcefully spawns specific units.
- First IAP popup: **6.39 PLN "First Purchase: Get Exclusive Rewards 1000% MORE VALUE"** (Elite Unit + 14 stars + 4000 coins + 5 items). [Source: Pryszard]
- First GDPR consent dialog on iOS: Advertising pre-checked, Age + Privacy Policy agreement required. [Source: IOSTouch]
- First reward chest at the end of Level 1: tank hero unit (qty 6). [Source: IOSTouch]

By end of session 1, player typically reaches Levels 2–3 (~10–20 minutes of play). [Source: PGames, IOSTouch]

### 5.2 D2 — Habit formation (energy economy + return motivations)

- Energy refilled from yesterday's depletion (~30 ⚡ over ~12 hours regen).
- Daily login chest (Check-in tab). [Source: GameHydro1]
- Daily quests refreshed: complete a Normal/Elite/Nightmare level, watch ads, log in. [Source: GameHydro1]
- New troop unlocks: Hero unlocks at Level 6, 10, 21. [Source: IOSTouch] First major unlock around D2–3 — at ~5⚡/battle × 30 energy daily, player gains 5–6 player-level XP per day; reaches Level 6 around D1.5–D2. [Inferred]

### 5.3 D3–D4 — Friction begins (first wall, first paywall pulse)

**D3:**
- First **Counter Warning / Counter Active** mechanic introduced (Level 2–3 timeframe per video evidence). [Source: Pryszard, PryGames]
- **Function Gear** tutorial appears at Level 3. [Source: PryGames]
- First boss wave at Level 3 final wave (Wave 7/7). [Source: Pryszard]
- Castle HP upgrade unlocks (Lv1 → Lv2) — first time the player can buy power, costs ~620 coins. [Source: GameHydro1]

**D4** [Inferred]:
- Player likely enters Forest Realm completion phase, transitions to second realm (Scorching Sands or similar).
- First Epic-tier troops obtained from gacha (epics at 32% rate). [Source: GameHydro1]
- Players start hitting visible difficulty bump.

### 5.4 D5–D7 — D7 fork into cohorts

**D5** [Inferred]:
- First multi-wave loss possible. Defeat screen + partial rewards seen (rewards still paid for partial completion). [Source: PryGames]
- Players reaching Scorched Sands first encounter "the jumping invincible enemy" boss. (★5, 60👍) [Source: Reviews]

**D6** [Inferred]:
- Energy frustrations begin: 30 ⚡ / 5 per battle = 6 battles/refill cycle, ~30 min play per day at full energy.
- Players start engaging with Patrol / offline-AFK income more seriously. [Source: GameHydro1, WaltonRulf]

**D7 — first weekly cycle complete:**
- Weekly chests unlocked, **5th weekly chest = 300 gems**. [Source: GameHydro1] This is the first time a player has accumulated enough gems for a 10-pull (180 gems), which is when first-time gacha experimentation typically happens. Combining gem economy by D7 + Game Hydro's "earning a bunch of free gems" framing. [Inferred]
- First major gacha disappointment surfaces — player pulls Caveman (Legendary), realizes it's a low-tier Legendary. *"Getting the caveman as my first legendary, it makes me feel like all those gems spent... were a complete waste."* [Source: GameHydro2] This is a known pity trap.

### 5.5 D8–D14 — second-week behaviors, walls

- Players who reach mid-game start hitting the **difficulty cliff**. Reviewers explicitly call out 15–20 minute mark as the inflection point: *"ramps the difficulty up after like 15 minutes to basically railroad you to either watch ads or pay money."* [Source: PlayStore Tomer Ilan ★1]
- *"it quickly gets to the point where it's almost impossible to make meaningful progress without watching multiple ads."* [Source: PlayStore James Braun ★3]
- *"There are certain levels that can only be passed through watching lots of ads for boosted units."* [Source: PlayStore Gregory Williams ★3]
- Stage-progression walls: *"Sat at the second map (barely out of the tutorial) for 2 days because the enemies can spawn camp you from a distance."* [Source: AppStore J-bob ★1]
- Players notice piercing-shot enemies break the spawn balance: *"Piercing shots can kill multiple units including units that haven't even attacked yet, not to mention they can pierce through your castle walls, basically spawn camping."* (★4, 91👍) [Source: Reviews]
- Players note save/resume frustration: *"It's annoying how you can not save mid-game progress, so if you close the game, you lose all progress on the level."* (★3, 10👍) [Source: Reviews]

### 5.6 D15–D30 — long-tail retention drivers and paywall

- Castle upgrades (Lv5+) unlock by ~D14. Castle scaling visible in videos at Lv2→Lv5 across few-hours sessions; players reaching Scorched Sands 10/15 are at Castle Lv5. [Inferred] [Source: GameHydro2]
- Players start spending. VIP/SVIP purchases begin around weeks 2–4. Review patterns "I bought the SVIP", "I paid for VIP. I played for a month" all reference week-to-month-long engagement before purchasing. [Inferred]
- **The biggest churn moment is the VIP deception:** *"Now, it has started messing up during ads so that the battle I am doing, closes and it goes back to the games home screen."* (★2, 18👍) [Source: Reviews] Combined with VIP expiring at 30 days instead of being permanent. (★1, 793👍) [Source: Reviews] Many one-month-engaged players churn here.
- **Paywall pressure converges on troop tier-ups:** *"you need to spend money on packs and recharges (aka spending money on packs) are behind paywalls so you literally can't get a pity pull for King unless you spend money."* [Source: AppStore HonestReview9182 ★2]
- Top-end players hit content cliff: *"Out of levels — Once you run out of levels you have nothing to do"* [Source: AppStore Kamaull ★3] and *"Need more levels"* [Source: AppStore Mrmrvos ★3].

---

## 6. What Players Like (sentiment from positive reviews)

### 6.1 Strategic / puzzle depth

Among the highest-thumbed 5★ reviews, the core praise is the **strategic combinatorial depth of the gear placement puzzle**:

- *"This game is fun and entertaining and the gear alignment strategies are very diverse"* (★5, 43👍). [Source: Reviews]
- *"The instructions are straight forward, combine gears to generate soldiers that will defeat monsters. I like that this game is not easy to win against. You have to think about how to combine the gears, its arrangement, what to prioritize first and strategize your formation for the upcoming waves"* (★5, 35👍). [Source: Reviews]
- *"I honestly thought this would be like another random mobile game, but this one is actually enjoyable... you actually have to think about each choice you make"* (★5, 70👍). [Source: Reviews]
- *"I like the calculation element to troop generation."* [Source: AppStore DeenoDiony ★5]
- *"I love the higher levels when you get more people to deploy its pure chaos."* [Source: AppStore Branmc267 ★5]

### 6.2 Optional-ads framing (early game)

Strongest single positive theme — when the ads work and are optional, players reward the studio with 5-star ratings:

- *"I genuinely love this game. It's fun, addictive, has no forced ads, and is challenging but not too difficult. Because it has no forced ads, I'm actually more willing to watch ads while playing, which the devs definitely understand. Thanks for making such a great game"* (★5, 38👍). [Source: Reviews]
- *"the ads only happen when you want to do an ad so it's not bombarding you with constant ads and you can actually play the game"* (★5, 70👍). [Source: Reviews]
- *"Great game, no ads, only if you want to get additional cards or upgrades, which is nice if you choose to go faster"* (★5, 60👍). [Source: Reviews]
- *"I've been playing it for about a month and not only is a very engaging and fun game but I love that I haven't got a single forced ad!!"* [Source: AppStore Blolel ★5]
- *"No pressure to spend money, one of the few games I enjoy because of this."* [Source: AppStore Crimson Starr ★5]

### 6.3 Visual style / chibi cute production

- *"cute graphics"* (★2, 147👍) [Source: Reviews]
- *"super cute units"* [Source: PlayStore Anonymous ★4]
- *"Such a calming game like at first that I didn't know where to start."* [Source: AppStore R(g7"gf) ★5]
- apkfami: *"bright, cartoon styled fantasy presentation that prioritizes clarity and readability during combat. Units, enemies, and gear elements are visually distinct, making it easy to follow what is happening on screen."* [Source: apkfami]

### 6.4 Offline / casual-session fit

- *"good game with no ads, only if you want to get additional cards or upgrades... great game to play offline."* [Source: PlayStore Anonymous ★4]
- *"No pop up adds and works with no wifi actually very fun."* [Source: AppStore parkery50.000 ★5] (note: by May 2026 the offline mode was removed, see Section 11 Pain Point 7.)
- apkfami: *"Levels can be completed quickly, and the auto-battle system allows me to pause without feeling pressured to constantly concentrate."* [Source: apkfami]

### 6.5 Late-game chaos satisfaction

- *"I love the higher levels when you get more people to deploy its pure chaos."* [Source: AppStore Branmc267 ★5]
- *"Right now it's completely broken, they don't die. They are larger than normal"* — creator describing the late-game x4 Giants build as a satisfying power-fantasy. [Source: WaltonRulf]

### 6.6 Repeat-engagement appeal

- *"This is the 2nd time I've installed this game to play because I really enjoy it. Keep up the good work!"* [Source: AppStore] — 2026-05-19 reviewer reinstalled.
- *"I have to say, this game is pretty addictive."* [Source: PlayStore Anonymous ★5]
- *"I love this game. once you start you can't stop!"* [Source: PlayStore Anonymous ★5]

---

## 7. Why Players Come Back (Retention Architecture)

Synthesizing from review patterns + observed gameplay loops + creator engagement, the retention system has stacked layers:

### Layer 1: Mechanical hooks

1. **Daily login + daily quest chain** — 5-chest reward bar with refresh CD. [Source: GameHydro1] The 5th weekly chest at 300 gems specifically times the gacha urge. [Source: GameHydro1]
2. **Energy regen + Patrol/AFK** — 30 cap, 5/battle, regen during break time. Patrol passively accumulates rewards offline. This creates a "check in twice a day" rhythm. [Source: GameHydro1, WaltonRulf]
3. **Wave chest milestones** — chests gated at Wave 3 / Wave 7 / Wave 12 within a level reward partial progress. [Source: GameHydro1] Encourages re-runs of "almost" wins.
4. **Gacha pity at 10 and 100 pulls** — players know exactly how many gems away they are from guaranteed Epic or Legendary. [Source: GameHydro1, GameHydro2]
5. **Difficulty tier replays** — once Normal is cleared on a realm, Elite and Nightmare unlock; reviewers cite this as the long-tail content. [Source: WaltonRulf]
6. **Timed Buff x1.5 stacking** — a buff with a clear countdown creates urgency to play "now". [Source: PryGames, Pryszard, WaltonRulf]

### Layer 2: Psychological hooks

1. **Sunk-cost via VIP purchases** — players who paid for VIP feel locked-in until 30 days expire, even when frustrated. *"I actually pay you guys for the big VIP package each month"* (★1, 142👍) [Source: Reviews]; *"I paid for VIP. I played for a month"* [Source: AppStore Namesarejustlabells ★1]
2. **Completionism on troop roster** — *"I only needed one more legendary to get every warrior in the game."* [Source: AppStore KitKat-2232 ★5]
3. **Tier-list theorycraft community** — creators publish tier lists and strategy guides; this gives social-comparison hooks. Game Hydro's videos alone surface 13 named troops with detailed rankings. [Source: GameHydro2]
4. **"It was fun, then it broke" mourning** — repeated review pattern of players who churn unhappily but explicitly express they used to love the game. *"If you asked me a few days ago I would have given this 10/10, 5 stars, all that stuff. I spent several hours a day playing this"* (★1, 74👍); *"pretty fun, until you realize..."* (★1, 65👍). [Source: Reviews] This is sticky — players keep checking back to see if it's fixed.
5. **Top-player ego loops** — players reaching the level 191 cap show ego investment: *"As one of the top players in Gear Defender, I have a few suggestions. Please add a 1v1 online mode."* [Source: PlayStore Mark Vincent Lacsinto ★3]

### Layer 3: Daily / weekly / event activities

Daily Tasks (5-chest reward bar, refresh CD ~14h):
- "Watch ads 5 times in total" → 500 coins
- "Recharge 1 times" → 1500 coins
- "Complete elite level 1 times" → 500 coins
- "Complete nightmare level 1 times" → 500 coins
- "Log in 2 times" (checked)
- Tabs: Check-in / Daily / Weekly / Deeds [Source: GameHydro1]

Spanish version shows similar daily quests: *"Complete level (8/18), Combine 8 gears 4×, Fuse 5 Tier-3 troops, Use strategy 2 times, Watch 3 ads total."* [Source: WaltonRulf]

Weekly Tasks: *"Fifth weekly chest gets you 300 free gems."* [Source: GameHydro1]

### Layer 4: Events (time-limited)

Events surfaced from store listing and reviews:
- *"Boss Appears! Fight for Victory!"* event running on Play Store with 4-day countdown. [Source: PlayStore]
- *"Charge in and slash your way to victory!"* event (ends 06/11). [Source: PlayStore]
- **Battle Festival** launched in v1.4.9. [Source: AppStore]
- **Monster Codex** added in v1.4.9 — tracks battles fought. [Source: AppStore]
- *"Spring festival event has a 7 day sign in."* [Source: AppStore Darbyman ★1]
- "New event system" — reviewer says *"the new event system is awful, the special event game mode takes forever and is unfun to play."* [Source: AppStore RyGuy37 ★2]
- Raffle ticket events: *"you need to spend real money to buy raffle tickets in order to get the only two things worth even touching the event for (the two new troop gears you can only get from said event)."* [Source: AppStore RyGuy37 ★2]

### Layer 5: Long-tail endgame (191-level Normal cap + Elite/Nightmare)

- Three difficulty tiers per realm: Normal → Elite → Nightmare, gated sequentially. *"we will try to do it on elite difficulty and then again, so we go through a normal world, an elite world, a nightmare world."* [Source: WaltonRulf]
- One iOS reviewer: *"There are three levels base, elite, and nightmare. Each has 191 levels then its done."* [Source: AppStore Schoochie boochie ★1] So **at least 191 main-mode levels per difficulty** are reachable.
- Another top player reports being at *"Lvl 192 in normal mode."* [Source: PlayStore Mark Vincent Lacsinto ★3] — corroborates the ~191 cap.
- Top-end players hit content cliff (see Section 5.6 and 11 Pain Point 8).

---

## 8. Unlock Timeline (when does feature X appear?)

| Unlock | Approx. timing | Source |
| --- | --- | --- |
| Forest Realm Level 1 Wave 1 | First session (D1) | Source: PGames |
| First IAP popup ("First Purchase 6.39 PLN") | First session (D1) | Source: Pryszard |
| GDPR consent dialog (iOS) | First session (D1) | Source: IOSTouch |
| Daily Check-in tab | D1 | Source: GameHydro1 |
| Pause button | Level 3 onward | Source: PryGames, Pryszard |
| Counter Warning / Counter Active | Level 2–3 | Source: Pryszard, PryGames |
| Function Gear tutorial | Level 3 | Source: PryGames |
| First boss wave | Level 3 final wave (Wave 7/7) | Source: Pryszard |
| Castle HP upgrade Lv1 → Lv2 | ~D3, 620 coins | Source: GameHydro1 |
| Hero unlocks (Player Level gates) | Level 6, Level 10, Level 21 | Source: IOSTouch |
| Patrol / AFK income | D2+ | Source: GameHydro1, WaltonRulf |
| Daily quests (refresh ~14h) | D2 | Source: GameHydro1 |
| Weekly chests (5th = 300 gems) | D7 first cycle | Source: GameHydro1 |
| First Epic-tier troop from gacha | Around D4 (32% Epic rate) | Source: GameHydro1 |
| First Legendary pull (pity at 100) | Variable; likely D7+ once 300+ gems accumulated | Source: GameHydro2 |
| Forest Realm → Scorching Sands transition | After clearing Forest Realm (4 stages?) | Inferred — Source: PGames, WaltonRulf |
| Aquatic / Ocean biome (Level 5) | Mid-game | Source: Pryszard |
| Castle Lv5 (1430 coins) | ~D14 | Source: GameHydro2; Inferred |
| Difficulty tier unlocks (Normal → Elite → Nightmare) | After completing all Normal stages of a realm | Source: WaltonRulf |
| VIP / SVIP purchase moment | Weeks 2–4 typical | Inferred from review patterns |
| Mythic rarity (Elephant Knight, Thunder Caller) | v1.4.9 patch (2026-05-13) | Source: AppStore |
| Hero Gears + Skill Gears | Recent post-launch update | Source: apkfami |
| Battle Festival event | v1.4.9 | Source: AppStore |
| Monster Codex (battles-fought tracker) | v1.4.9 | Source: AppStore |
| Level 191 content cliff (Normal) | Top-end players | Source: PlayStore Mark Vincent Lacsinto, AppStore Schoochie boochie |

---

## 9. Monetization Detail

### 9.1 Currency Stack

| Currency | Source | Sink |
| --- | --- | --- |
| **Gems** (premium) | IAP, daily login, weekly chests (300/5th chest), achievements | Gacha (Draw 10 = 180 gems), Refresh, Restore (likely) |
| **Coins/Gold** | All modes, wave chests, enemy drops ("+30") | Castle upgrades (620 → 1430), gacha (Draw 1 = 20 coins), Refresh |
| **Troop Materials** | Gacha (90%+ of drops) | Upgrading owned troops |
| **Energy ⚡** | Regen (~3–6 min per ⚡), IAP, ad-watch (post-bug) | Battle entry (5 ⚡/battle, cap 30) |
| **Chicken Legs (Troop Cap)** | Castle upgrades | Implicit cap on field troops (10 → 17 → 24) |
| **Ad-skip tokens** | VIP/SVIP daily quota (5–15/day) | Skipping rewarded ads |
| **Raffle tickets** | Real-money purchase only (event-specific) | Event-locked troop gears |
| **Castle upgrade tokens** | Wave chests | Castle level-up |

[Source: GameHydro1, GameHydro2, Pryszard; Cross-confirmed]

### 9.2 Spend SKU Inventory

| Item | Price | Source |
| --- | --- | --- |
| First Purchase Bundle | 6.39 PLN (~$1.60 USD) | Source: Pryszard |
| Standard Pack 1 | $0.99 | Source: AppStore |
| Standard Pack 4 | $9.99 | Source: AppStore |
| SVIP (Super VIP, 30-day) | ~$9.99 | Source: AppStore Support Not Answering, Bipnips |
| VIP (30-day) | ~$3.99–$9.99 | Source: AppStore |
| Battle Pass | $9.99–$19.99 | Source: AppStore |
| Single ad-skip token | $1 CAD | Source: AppStore Bipnips |
| Ad-removal full | ~$50 | Source: AppStore Hollywood2133 ★1 |
| Premium bundle | $500 → $50 (discounted) | Source: AppStore |
| Gem bundles | various | Source: AppStore |
| Starter Pack | persistent lobby button | Source: GameHydro1, GameHydro2, WaltonRulf |
| Piggy Bank | persistent lobby button | Source: GameHydro1, GameHydro2 |
| Pass (Season Pass) | persistent lobby button | Source: GameHydro1, GameHydro2 |
| Daily Bundles (T1 Troop Bundle "400% MORE VALUE") | refreshes ~10h | Source: Pryszard |

Play Store IAP price range: **₹100.00 – ₹9,700.00 per item**. [Source: PlayStore]

Pricing observed across currencies (confirming global rollout):
- USD: $0.99, $9.99, $10, $19.99, $50 [Source: AppStore]
- CAD: $1 (single ad-skip token) [Source: AppStore Bipnips]
- PLN: 6.39 (Poland — First Purchase Bundle) [Source: Pryszard]
- INR: ₹100 – ₹9,700 [Source: PlayStore]

### 9.3 Pity & drop rates

Two gacha probability tables — see Section 3.8 for full detail.

**Earlier rates (Nov 2025, Astrology pool)** [Source: GameHydro1]:
- Legendary: **4%**
- Epic: **32%**
- Rare: **64%**

**Later rates (Jan 2026, Alchemy/Astrology Reward Probability)** [Source: GameHydro2]:
- Legendary: **7.6628%** total (but per-troop rates ~0.0205% each; Troop Materials = 7.5808%)
- Epic: **32.0174%** (per-troop rates ~0.22–0.32% each; Troop Materials = 30.4133%)
- Rare: **60.3198%** (per-troop rates ~0.59% each)

**Pity system:**
- Guaranteed troop at 10-pull (vs the 7.58–30.4% Troop Materials default outcome). [Source: GameHydro1]
- Guaranteed Epic troop at 100 pulls. [Source: GameHydro1]
- Visible pity options in alchemy screen: "Excluding Pity", "Pity at 10 Pulls", "Pity at 100 Pulls". [Source: GameHydro2]
- **Legendary pity at 100 pulls** referenced by creator — Caveman is a "first legendary" pity outcome. [Source: GameHydro2]

Pull options:
- **Draw 1** = 20 coins (soft) [Source: Pryszard]
- **Draw 10** = 180 gems (hard) [Source: Pryszard]
- **Draw 2** = ad-watch (0/5 ads — gated ad pulls) [Source: Pryszard]

**Mythic rarity (v1.4.9):** [Gap] Drop rates, pity threshold, and materials required for Mythic-tier troops (Elephant Knight, Thunder Caller) are not documented in the corpus. Likely uses a new pity ceiling above 100 pulls. [Assumed]

### 9.4 The whale hooks

**Subscriptions — VIP/SVIP.** This is the single most damaging monetization design in the game.

- **VIP and SVIP are marketed as one-time purchases of permanent perks (e.g. "x2 speed for life"), but they actually expire after 30 days.** This is documented across multiple top reviews and dates:
  - *"a 4-5* game, but the VIP packs don't say they last 30 days until after you purchase them. I thought I was purchasing x2 speed for life, but after I made the purchase there was a duration. Nowhere did it say that there was a duration before I bought it"* (★1, 793👍, v1.2.1) — the highest-thumbed negative review in the corpus. [Source: Reviews]
  - *"there is an option to purchase VIP package which prior to purchasing says nothing about time limit duration. However, once you've purchased it, it shows a 30 day countdown. Definitely misleading or false advertising."* [Source: AppStore OracleX ★1]
  - *"Bought the VIP package. The price was high enough and there is no indication it is a limited duration once purchased. Very bait and switch."* [Source: AppStore UOPayroll ★2]
  - *"The 'permanent VIP' isn't permanent, it's 30 days."* [Source: AppStore Chimprarr ★1]
- **Worse, the VIP gets canceled by updates:** *"Updates have deleted vip purchases twice. So I deleted game"* [Source: AppStore Dgmacg ★3]; *"I purchased both 30 day VIP packs and now they've ended after maybe 5 days?"* [Source: AppStore LexxBor ★1]; *"I bought the SVIP bundle in the game that was supposed to give me 30 days of perks, but it only gave me 3 days"* [Source: AppStore copeharderdepressedboi ★1]; *"Was supposed to last a month but only lasted about a week and a half."* [Source: AppStore eyeleeuh ★1]
- **Subscription value is poor anyway:** *"Not a monthly subscription that only gives you 15 ad tickets. That's only if you have both. 5 from one and 10 from the other daily which is nowhere near enough to remove ads. I know because I tried the subscription for one month and I kept having to watch ads after using them"* (★3, 35👍). [Source: Reviews] So even when VIP works correctly, it doesn't actually remove ads — it just gives a small daily ad-skip quota.

**Other whale hooks:**
1. **Piggy Bank** — persistent lobby button; classic accumulating-deposit unlock-once-paid mechanic. [Source: GameHydro1, GameHydro2]
2. **Pass (Season Pass)** — $9.99–$19.99 Battle Pass tier. [Source: AppStore, GameHydro1, GameHydro2]
3. **Premium bundle $500 → $50** discount implies a whale segment is being targeted. [Source: AppStore]
4. **Daily Bundles "400% MORE VALUE" T1 Troop Bundle** refreshes ~10h. [Source: Pryszard]
5. **Raffle ticket events** — *"you need to spend real money to buy raffle tickets in order to get the only two things worth even touching the event for."* [Source: AppStore RyGuy37 ★2]

**Ad infrastructure as monetization spine** (the big lever — see Section 1 core thesis):

- Speed boost x1.5 (15 min) [Source: GameHydro1]
- Refresh 6 (multi-refresh chain) [Source: GameHydro1, WaltonRulf]
- "Watch ads 5 times in total" daily quest [Source: GameHydro1]
- Ad-watch milestone bar in Gear screen (5/9/13/19/25 ads → chests) [Source: GameHydro1]
- Ad-watch milestone bar in Astrology screen (3/7/11/16/22 ads → chests) [Source: GameHydro1]
- Ad-watch milestone bar in Draw screen (5/9/13/19/25 ads → rewards) [Source: Pryszard]
- Mid-battle gear via ad-card (auto-plays ad on tap) [Source: GameHydro1]
- Castle "Restore" wall HP repair (likely ad-gated) [Source: PryGames, WaltonRulf]
- Free troop trials between rounds (ad-gated unlock test) — *"Thank you very much to the magic of advertisement videos in between rounds."* [Source: GameHydro2]
- Boost coins / power / castle for 20 minutes via ad [Source: AppStore Schoochie boochie]

**Ad-watch frustrations from reviews:**
- **Ad duration:** 90 seconds, 116 seconds, 120 seconds, even **7-minute** ads cited. *"I regularly watch ads to support game makers but the first ad I watched was 116 seconds long, no skip available and then three pauses to press X to finally end this stupidly long ad."* [Source: AppStore Rexwall ★2]; *"I got a 7 minute ad wtf."* [Source: AppStore Bad_game_reviewer100 ★2]
- **Ad crashes after watching:** *"Anything you want to do seems blocked behind an ad. On top of that, about 25% of the time, I finish watching an ad and get dumped back to the launch screen losing the reward completely."* (★2, 18👍) [Source: Reviews]
- **Ad missing X button:** *"it's always not showing the skip button."* [Source: AppStore TheSpectralV0ID ★1]
- **Repeat Temu ads:** *"I watched 3 ads which themselves were 3 Temu ads each and didn't receive my reward."* [Source: PlayStore M Morgz ★2]; *"Such a fun creative game ruined by greed. A VIP subscription that doesn't block ads is the greediest I've seen so far."* [Source: AppStore GCM29 ★1]
- **Offensive ads:** *"In your ad, the 'character selection' was a depiction of a noose going around the neck of different characters. The character selected was the only dark-skinned character."* [Source: AppStore Angus McCrazy ★1]; *"Diet patch ads — one shows a mom berating her child and her child crying."* [Source: AppStore Mesha1234 ★3]; *"This game is just one giant gambling ad scam."* [Source: AppStore Not much of a review ★1]

**Energy gating + soft-paywall structure:** Energy gating is light by design — 30 ⚡ / 5 per battle = 6 battles before depletion, regen filling the cap in ~3–5 hours. [Source: GameHydro1, IOSTouch, PGames] This is gentler than typical mobile gacha energy curves. The **monetization pressure is in gem→gacha and ad→accelerator, not in energy purchase prompts**. The "Restore" button for mid-battle wall HP [Source: WaltonRulf] is the most direct soft-paywall — when you're about to lose, the game offers a paid recovery.

---

## 10. UA & Creative Strategy

[Gap] No Segwise-style UA data captured in this research pass; review-volume monthly curve from `analysis_pack.md` is the only proxy available.

### 10.1 Network Mix
[Gap] Not in corpus.

### 10.2 Geo Strategy
[Gap] Not directly stated, though the **15-language iOS support** (EN, FR, DE, HI, ID, IT, JA, KO, PT, RU, ZH, ES, TH, ZH-TW, VI) [Source: AppStore] and the multi-currency IAP observation (USD, CAD, PLN, INR) [Source: AppStore, Pryszard, PlayStore] confirm a global rollout including Southeast Asian, European, and South Asian markets. The Spanish auto-translated WaltonRulf walkthrough (Arenas Abrasadoras) suggests LATAM penetration as well. [Source: WaltonRulf] **No spend-allocation percentages are documented.**

### 10.3 Creative Pillars
[Gap] No public UA creative analysis available for Gear Defenders. The store-listing self-description tagline is *"fresh blend of 'idle collection' and 'strategic adventure'... Build your war machine with a flick of your finger."* [Source: PlayStore, AppStore]

### 10.4 Format Optimization
[Gap] Not in corpus.

---

## 11. Player Pain Points & Churn Drivers

The scraped review sample (n=3,011, biased toward "Newest" sorting which surfaces post-update frustration disproportionately) shows a scraped avg of 2.64★ vs the **lifetime 4.50★** ground truth. [Source: Reviews-lifetime; analysis_pack.md sample-bias note] The scraped sample is therefore best read as a **diagnostic of where players bleed**, not as a representative sentiment snapshot.

| # | Theme | Representative quote |
| --- | --- | --- |
| 1 | **VIP/SVIP subscription deception** | *"VIP packs don't say they last 30 days until after you purchase them. I thought I was purchasing x2 speed for life, but after I made the purchase there was a duration."* (★1, 793👍, v1.2.1) [Source: Reviews] |
| 2 | **Ad infrastructure crashes / ads-without-reward** | *"about 25% of the time, I finish watching an ad and get dumped back to the launch screen losing the reward completely"* (★2, 18👍) [Source: Reviews] |
| 3 | **Save / cloud-save failures, no mid-level resume** | *"My game has refused to save for over a week no matter how many times I hit 'save progress'"* (★1, 142👍); *"I have played the same level 4 times today, I have leveled up my Archer 4 times today. I have opened the final chests 4 times today"* (★2, 21👍) [Source: Reviews] |
| 4 | **Forced unskippable tutorials** | *"hate being forced to do unskipable 'tutorials' every time a new thing is introduced as the game goes on"* (★2, 220👍); *"give people the option to skip the tutorial"* (★1, 47👍); *"Tutorial is way too long. One level. If you need more than one level to teach your mobile game, then I think that points to your game being badly designed for its platform"* [Source: AppStore Jason Keswick ★2]; *"Incredibly slow start, unskippable tutorial, horrible sound effects I couldn't turn off until I had played 2 (previously mentioned to be slow) rounds"* [Source: AppStore CraigCraigCraig12 ★2] |
| 5 | **Difficulty cliff / paywall pressure** | *"ramps the difficulty up after like 15 minutes to basically railroad you to either watch ads or pay money"* [Source: PlayStore Tomer Ilan ★1]; *"you reach a point in the game that you will need to watch many ads to pass a level or get any achievements. stops being fun"* [Source: PlayStore latest]; *"if they have at least three of them, good luck trying to even reach them to take them out before they just shoot at your castle and defeat you"* — about ranged enemy spawn camping (★1, 65👍); *"Piercing shots can kill multiple units including units that haven't even attacked yet, not to mention they can pierce through your castle walls(which is completely unrealistic), basically spawn camping. Spawn camping ruined many games"* (★4, 91👍); *"Hit a P2W wall after the literal first map"* [Source: AppStore J-bob ★1] [Source: Reviews, AppStore, PlayStore] |
| 6 | **Meat / wall / chicken-leg system** | *"I don't like the meat system, having soldiers stuck behind my wall while the enemy draws closer with nothing I can do except watch an ad to repair my wall. I'm not even sure if it's upgradable? It makes getting more gears pointless because faster production is not linked to a win"* (★2, 147👍); v1.1.11 update specifically cut castle HP in half and introduced/changed the chicken-leg mechanic: *"A new update cut my castle's HP by half, introduced this chicken leg mechanic that li..."* (★1, 74👍, truncated) [Source: Reviews] |
| 7 | **Offline mode removed (recent regression, May 2026)** | *"Really enjoyable game, but sadly, they removed the offline feature. I fly a lot of work, some would say it's my job, so having an offline game for the long hauls was clutch. But, can't play in airplane mode anymore, so this game is no longer of interest. Biggest mistake these developers could have done"* [Source: PlayStore Chris Sprenkle ★3 v1.4.6 / May 2026]. Developer response confirms: *"In the latest version, the online connection is needed to help maintain game fairness and ensure a more stable gameplay environment for all players."* [Source: PlayStore]; *"Doesn't work offline despite the tag"* [Source: PlayStore latest 2026-05-22] |
| 8 | **Late-game content cliff** | *"Once you run out of levels you have nothing to do and can't collect anything for the daily chests"* [Source: AppStore Kamaull ★3]; *"Don't get diamonds past a certain point. Just bought 3 svip with 14 days left and updated the game and it took them away. Need more levels"* [Source: AppStore Mrmrvos ★3]; *"Even at lvl 192 in normal mode, it's honestly so hard to clear because the level gap is just too much"* [Source: PlayStore Mark Vincent Lacsinto ★3] |
| 9 | **Customer support broken** | *"The developers webpage doesn't work so I haven't been able to contact support"* (★1, 142👍) [Source: Reviews]; *"Tried submitting a support request from the developers directly, but their support page reads error when trying to submit"* [Source: AppStore eyeleeuh ★1]; *"Tried opening a ticket and you'll get a server error anyway you try"* [Source: AppStore Kamaull ★3]; *"Tried to file a bug report. Ad view (which I thought I paid to skip) not working"* [Source: AppStore The Original Lobster ★1] |
| 10 | **Boss balance / lane-piercing** | *"In Scorched Sands, that enemy that jumps and it gets invincible for a few seconds, sometimes gets buggy and is invincible forever, so unfinishable game"* (★5, 60👍) [Source: Reviews]; *"Endless isn't exactly endless if a boss can one shot your full health wall through a lane full of ultimate form and shielded characters from the far end of the lane"* [Source: AppStore Chimera911 ★4]; *"I have been on this new years event and it has been stuck on 'day 7' without allowing me to gain the rewards for the past few days"* [Source: AppStore tamentatsu ★1] |
| 11 | **Ad SDK persistent regression across versions** | Cited across versions 1.0.7 → 1.4.8 (every major release for 7 months): v1.0.7 *"the game gets stuck in a loop and becomes unplayable"* (★1, 83👍); v1.1.16 *"some ads just bug and made you restart the game or sometimes after watching ads the game just restart itself"* (★5, 115👍); v1.2.1 *"when using the ads video to boost up my hero, the game crash and starts me back over on the same level"* (★5, 53👍); v1.2.3 *"about 25% of the time, I finish watching an ad and get dumped back to the launch screen losing the reward completely"* (★2, 18👍); v1.2.7 *"you weren't cheated out of your reward for watching ads... lucky if I get through the ads and get rewarded"* (★2, 44👍); v1.3.2 *"lock up or crash at least once a day when trying to load or exit the huge number of ads, which basically makes the game unplayable"* (★2, 102👍); v1.4.5 *"you somehow made it worse with limited ad refreshes, because it just makes it impossible to win"* (★1, 65👍); v1.4.8 (May 2026) *"optional ads will always fail letting you watch 3/3 ads.. non skippable.. and it will fail again"* [Source: AppStore latest reviews]. **This is a persistent core infrastructure issue, not a one-time regression.** [Source: Reviews, AppStore] |
| 12 | **Save sync broken across Google / Facebook** | *"no google play sync?! only FB. No Thanks"* [Source: PlayStore M Morgz ★2]; *"EVERYTIME I SAVE MY PROGRESS TO MY GOOGLE ACCOUNT OR FACEBOOK ACCOUNT THE GAME RESTARTS IN ITS START UP OPENING, SAVING DOESN'T WORK"* [Source: PlayStore latest 2026-05-21]; *"Please make it to where if you close the game you can RESUME where you left off on a level"* [Source: AppStore HonestReview9182 ★2] |

---

## 12. Game Modes Catalog

| Mode | Type | Frequency | Reward | Source |
| --- | --- | --- | --- | --- |
| **Campaign / Main Mode (Normal)** | Lane-defense PvE, 5–9 → 12 waves per level + boss final wave | Energy-gated (5 ⚡/battle); sequential by realm | EXP/Gold/Troop Materials; wave chests at Wave 3 / 7 / 12 | Source: GameHydro1, PryGames, Pryszard |
| **Campaign — Elite difficulty** | Replay of cleared Normal realm at higher difficulty | After all Normal stages cleared in realm | Daily-quest reward (500 coins for 1 Elite clear) | Source: WaltonRulf, GameHydro1 |
| **Campaign — Nightmare difficulty** | Replay of cleared Elite realm at highest difficulty | After all Elite stages cleared in realm | Daily-quest reward (500 coins for 1 Nightmare clear) | Source: WaltonRulf, GameHydro1 |
| **Boss waves** | Final wave of each level with banner "BOSS" | Once per level | Boss-specific drops | Source: Pryszard, WaltonRulf |
| **Patrol / AFK** | Offline idle reward accumulation | Always running (e.g. 5:55:46 countdown) | Tied to energy; afk/patrol income | Source: GameHydro1, WaltonRulf, AppStore |
| **Daily Tasks (Daily tab)** | 5-chest reward bar | Refresh CD ~14h | Watch 5 ads → 500 coins; Recharge 1× → 1500 coins; Elite clear → 500 coins; Nightmare clear → 500 coins; Log in 2× | Source: GameHydro1 |
| **Weekly Tasks (Weekly tab)** | Cumulative weekly bar | Weekly reset | 5th weekly chest = 300 gems | Source: GameHydro1 |
| **Check-in (Check-in tab)** | Daily login bonus | Daily | Calendar-based rewards | Source: GameHydro1 |
| **Deeds (Deeds tab)** | Achievement-style tab | [Gap on cadence] | [Gap] | Source: GameHydro1 |
| **"Boss Appears! Fight for Victory!" event** | Time-limited event | 4-day countdown observed | Event-specific | Source: PlayStore |
| **"Charge in and slash your way to victory!" event** | Time-limited event | Ends 06/11 observed | Event-specific | Source: PlayStore |
| **Battle Festival** | New event mode | Launched in v1.4.9 | [Gap on rewards] | Source: AppStore |
| **Monster Codex** | Battles-fought tracker / collection mode | Always-on (v1.4.9+) | [Gap on direct rewards] | Source: AppStore |
| **Spring Festival sign-in event** | 7-day sign-in event | Seasonal | [Gap on rewards] | Source: AppStore Darbyman ★1 |
| **New event game mode (raffle-ticket gated)** | Special event game mode | Time-limited | Event-only troop gears (paywall: must buy raffle tickets) | Source: AppStore RyGuy37 ★2 |
| **Astrology / Alchemy gacha** | Pull-banner gacha | Always available | Troops + Troop Materials per rate tables (Sec 3.8 / 9.3) | Source: GameHydro1, GameHydro2, Pryszard |

---

## 13. The Troop / Hero Roster (tier list synthesis)

**Confirmed troops** — 13 named units across Rare / Epic / Legendary, plus Mythic (v1.4.9+ addition). Tier mapping is from Game Hydro's January 2026 tier-list video. [Source: GameHydro2]

### S+ Tier
| Name | Rarity | Type | Notes |
|---|---|---|---|
| **Paladine** | Legendary | Cavalry(?)/Heavy | "Absolutely the best character in the game" [Source: GameHydro2] |

### S Tier
| Name | Rarity | Type | Notes |
|---|---|---|---|
| **Heavy Guard** | Epic | Heavy | "An absolute ass kicker"; **immune to crits**; reduces AoE damage taken by 50% within 3m; blocks enemies within 1m [Source: GameHydro2] |
| **Shielder** | Rare | Heavy | (S or S-) "Crucial part of my battle party"; high prod speed + HP; tanky frontline [Source: GameHydro2] |

### A Tier
| Name | Rarity | Type | Notes |
|---|---|---|---|
| **Catifact (Cataphract)** | Epic | Cavalry | 100% AoE arc swing; "highly highly highly valuable"; lance swing [Source: GameHydro2, GameHydro1] |
| **Spearman (Rare)** | Rare | Infantry | (A-) Long range, good crit, bonus vs Infantry [Source: GameHydro2] |
| **Arbalist** | Epic | Ranged | (A-) Piercing bolts; 30% chance +2 bolts; guaranteed crit burst every 4s [Source: GameHydro2] |

### B+ Tier
| Name | Rarity | Type | Notes |
|---|---|---|---|
| **Lancer** | Rare | Cavalry | Bonus vs Ranged; "Upon leaving the gate, performs a flanking charge, knocking aside enemies" [Source: GameHydro2] |
| **Barbarian** | Epic | Infantry | "Jumps into battle" entrance; axe whirlwind AoE at Star 1 [Source: GameHydro2] |
| **Mage** | Epic | Ranged | High crit rate; splash + meteor shower; bonus vs Heavy [Source: GameHydro2] |
| **Spearman (Legendary)** | Legendary | Infantry | Better Rare Spearman; bonus vs Cavalry; fast production [Source: GameHydro2] |
| **Ninja** | Legendary | Ranged | Highest attack speed + prod speed; throwing stars; smoke screen; shadow clones [Source: GameHydro2] |

### B- Tier
| Name | Rarity | Type | Notes |
|---|---|---|---|
| **Warrior** | Rare | Infantry | "No strengths"; balanced [Source: GameHydro2] |
| **Archer** | Rare | Ranged | Bonus vs Infantry; 30% chance to shoot 2 arrows at Star 1 [Source: GameHydro2] |
| **Alchemist** | Rare | Ranged | Strong vs heavy but "freaking slow" prod speed; poison DoT [Source: GameHydro2] |

### C++ Tier (Caveman pity trap)
| Name | Rarity | Type | Notes |
|---|---|---|---|
| **Caveman** | Legendary | Infantry | Wall-damage niche; near-death piercing glove throw. *"I'm kind of pissed about... a complete waste"* — creator got Caveman as his first legendary via pity [Source: GameHydro2] |

### New tier (v1.4.9+, Mythic)
| Name | Rarity | Type | Notes |
|---|---|---|---|
| **Elephant Knight** | Mythic | Cavalry | "First Mythic Cavalry: Elephant Knight. Trample everything!" [Source: AppStore What's New v1.4.9] |
| **Thunder Caller** | Mythic? Legendary? | Mage | "Legendary Mage: Thunder Caller. Thunder strikes!" — store text calls it Legendary; if Mythic is truly a new rarity, Thunder Caller may be a parallel high-tier add [Source: AppStore What's New v1.4.9] |

**Meta observation from creator:** *"The developers of this game have kind of broken the meta a little bit by giving all their tanks higher attack power than everyone else. So, the tanks are fairly overpowered in this game."* [Source: GameHydro2]

### Healers
[Gap] No dedicated healer class observed in the 13-troop roster; the "Restore" castle-HP button is the only healing mechanic surfaced, and it appears to be a paid/ad-gated wall repair, not a per-troop healer.

### F2P Tier
[Inferred from creator commentary] F2P-viable picks based on rarity availability and tier:
- **Shielder** (Rare, S/S-) — universally praised by GameHydro2 as F2P backbone
- **Spearman (Rare)** (Rare, A-) — accessible high-tier Rare
- **Heavy Guard** (Epic, S) — once acquired via 100-pity, becomes a meta cornerstone
- One reviewer believes the game is genuinely F2P-friendly: *"no real need to watch ads to progress or make the game easier, f2p is possible."* [Source: AppStore Komuto Hirowato ★4]

---

## 14. Genre Comparison & Lila Strategic Take

### Closest comparables

- **GearFightComparator (Voodoo's `com.EternalStudio.GearFight`)** — Play Store lists it as a "Similar game". [Source: PlayStore] **NOT same studio** (Voodoo, France) — Mobibrain is Singapore-based. [Source: GearFightComparator, PlayStore] **Gear Fight rating:** 3.9★ across 67,653 ratings vs Gear Defenders' 4.5★ across 88,339 ratings. [Source: GearFightComparator, Reviews-lifetime] Mobibrain wins decisively.
  - **Genre framing:** "puzzle-adventure" — described as *"build a well oiled machine to take down these pesky enemies! First, place down some gears. Then, put your newly constructed factory to the test versus all of the evil enemies!"* [Source: GearFightComparator] Same auto-spawn-from-gears concept.
  - **Key differentiator (negative for Voodoo):** Voodoo introduced **forced ads after every wave** in mid-game; this is the #1 cited reason for Gear Fight churn. *"devs put in forced ads AFTER. EVERY. WAVE."* [Source: GearFightComparator Jim Strange ★1]; *"it lulled me into a false sense of security regarding ads"* [Source: GearFightComparator Darci Cowell ★3]. Gear Defenders carefully avoids this — its "no forced ads" framing is what protects its rating.
  - **Voodoo lacks the merge depth:** Gear Fight reviewers describe it as much more of a pure auto-battler with budget-management framing — *"Manage your budget, and take them all down!"* [Source: GearFightComparator] The combinatorial gear-merge puzzle is less central.
  - **Voodoo also has VIP problems:** *"I paid for no adds yet they keep showing up!! Almost every wave"* [Source: GearFightComparator LEGIT JEFFO ★3]. The "paid to remove ads, ads still play" issue mirrors Gear Defenders.
- **Survivor.io comparison from a reviewer** — *"This game has similar mechanics to Survivor io and yet with that game you can resume where you left off on a level even if you close the game."* [Source: AppStore HonestReview9182 ★2] So players associate the genre with auto-battle survivor games.
- **Lucky Defense and "Gear Pod Defenders"** — explicitly named by creator as the gear-genre that Gear Defenders sits in. [Source: GameHydro1]
- **GearPaw Defenders!** (`com.gearpaw.defenders.td.game`) — listed as a Voodoo "Players also install" sibling, 4.5★. [Source: GearFightComparator] Same casual TD niche.
- **Random Dice / similar dice-merge TD games** — not named in sources but mechanically adjacent. Gear-merge-on-grid + auto-spawn troops + escalating waves is the Random Dice formula on a lane map. [Inferred]
- Other "Similar games" on Play Store: Eternal Empire: Warrior Eras (4.8★), Idle Weapon Shop (4.0★), XP Hero (4.4★), Gear Truck! (4.5★), Idle Outpost: Upgrade Games (4.3★). [Source: PlayStore]
- **EA products comparison (negative)** — *"EA products 👎👎... You have to pay up to enjoy this game. The developers are greedy and money grabbers!"* [Source: AppStore lee hun su ★1] — the cultural anchoring is "this feels like EA-tier monetization."

### MobibrainCatalogue context

15 published iOS titles (per dev page): [Source: MobibrainCatalogue]

| Title | Rating | Ratings count | Genre |
|---|---|---|---|
| Fish Eater.io | 4.8★ | 55,950 | io-style eat-and-grow |
| Idle Magic Academy | 4.8★ | 24,192 | idle tycoon |
| **Gear Defenders** | **4.8★** | **7,367** | TD + gear-merge (this game) |
| Survivor Island-Idle Game | 4.7★ | 5,443 | idle survival |
| Idle Superpower School | 4.8★ | 4,549 | idle tycoon |
| Fish Eat Fish.io | 4.8★ | 3,260 | io-style |
| My Hamster Story | 4.6★ | 743 | management sim |
| Survivor Base — Zombie Siege | 4.6★ | 658 | base defense |
| I'm Fireman | 4.3★ | 325 | sim |
| Sloppy Capy Life | 4.9★ | 179 | casual sim |
| Doki Doki Days | 4.9★ | 83 | manage/social |
| Tiny Paws: Cute Idle Tycoon | 4.3★ | 81 | idle |
| Tukier Factory Inc.-Idle Game | 4.7★ | 59 | idle factory |
| Food Chronicles: Merge & Story | 4.7★ | 28 | merge |
| Knight Survivor | 5.0★ | 11 | survivor |

**Design DNA observations:**
- Mobibrain's portfolio skews heavily toward **idle/tycoon/merge/io-style casuals**. They are not a strategy or hardcore studio.
- The studio repeatedly hits **4.7–4.9★ ratings** — Gear Defenders' 4.8★ (iOS) is on-brand for their portfolio.
- Their largest title by reviews (Fish Eater.io, 55k ratings) is also a casual auto-loop game. Gear Defenders is their first move toward the strategy/TD niche.
- The Play Store "More by" sidebar surfaces only 2 sister titles (Idle Superpower School and Feed & Grow: Fish), suggesting the Android catalogue presentation is narrower than the iOS one. [Source: PlayStore]

### Audience signals

- **Age:** rated 7+ on Play (Mild Violence) and 4+ on Apple. [Source: PlayStore, AppStore] Apple's softer rating reflects the chibi/cartoon aesthetic.
- **Reviewer demographics (qualitative):** One review explicitly says *"I am only 9 so I love this game and it is not impossible."* [Source: AppStore Really fun gear game ★5] Several reviewers reference age-appropriate use ("kids game" framing). [Source: AppStore Not much of a review ★1] The art and tutorial pace suggest broad casual demo with a teenage long tail.
- **Returning player signals:** Multiple reviews mention multi-month engagement: *"Been playing for months"* [Source: PlayStore M Morgz ★2]; *"I've been playing it for about a month."* [Source: AppStore Blolel ★5] Top reviewer Mark Vincent Lacsinto says he's *"Lvl 192 in normal mode"* [Source: PlayStore] — late-game content gating evidence.
- **Whales present:** Spend signals from CA iPhone reviews — *"I bought the $10 SVIP 30-day pass"* [Source: AppStore Support Not Answering ★1]; *"$50.00 to get rid of the ads"* reference [Source: AppStore Hollywood2133 ★1]; *"I pay you guys for the big VIP package each month"* (★1, 142👍) [Source: Reviews]; *"I made the mistake of purchasing VIP."* [Source: AppStore Anomalogue ★2] The "premium bundle" mentioned at $500-marked-down-to-$50 implies a whale segment is being targeted. [Source: AppStore]
- **PvP appetite from top-end players:** *"Please add a 1v1 online mode and set the troop max level to 100"* — request from a self-identified top player. [Source: PlayStore Mark Vincent Lacsinto ★3]
- **F2P viability claim:** *"no real need to watch ads to progress or make the game easier, f2p is possible."* [Source: AppStore Komuto Hirowato ★4] — at least one reviewer believes the game is genuinely F2P-friendly.

### Lila implications [opinion, not from sources]

- Gear Defenders is the **textbook "polished idle/merge casual hits Western/global lane-defense"** play. Mobibrain's portfolio confirms they are a casual-idle studio iterating into TD/strategy — the 4.50★/88k profile is exceptional for a 6-month-old casual game in this genre, particularly given how much friction the long-tail reviews surface.
- The biggest design lesson is the **"voluntary ads" frame as the headline-rating-protecting decision**. Voodoo's GearFight ships forced post-wave interstitials and gets 3.9★; Mobibrain ships only rewarded-video gates and gets 4.5★ on the same core mechanic. This is a single decision that swings ~0.6★ on a 5-point scale and likely doubles the install→rating opt-in rate.
- The biggest risk is the **VIP/SVIP deception pattern**. The single highest-thumbed review in the entire corpus (793👍, 1★) is about this deception, and the pattern repeats across dozens of months and updates. This is destroying high-LTV whale cohorts and is the most likely candidate for regulatory/consumer-protection trouble (multiple "false advertising" / "bait and switch" terms used in reviews).
- The **merge-puzzle depth + tier-list-able 13-troop cast** is the genuinely differentiated element worth lifting. Most lane TDs do not support creator tier-list theorycraft at this density.
- The **"no mid-level save + ad-crash = lost run" loop** is the biggest infrastructure liability. Fixing this would convert a meaningful share of the ★1 ad-crash cohort to neutral/positive.

---

## 15. Information Gaps

These are honest unknowns. The reader should challenge or update these before treating any claim in the spec as gospel.

1. [Gap] **Exact world-map count and naming.** Confirmed realms: Forest Realm (4 stages?), Scorching Sands / Scorched Sands (15 stages), aquatic/ocean (Level 5+). How many realms total? What are the later realm names? Assumed ≥ 4 realms based on 191-level Normal cap and 15 stages per realm. [Assumed] Not directly stated anywhere.

2. [Gap] **Mythic rarity introduction (v1.4.9).** "First Mythic Cavalry: Elephant Knight" implies a brand new rarity tier above Legendary. [Source: AppStore] What are the drop rates? Pity threshold? Materials required? No source documents this. Mythic uses a new pity ceiling above 100 pulls. [Assumed]

3. [Gap] **Top-end PvP / leaderboard mechanics.** Top player asks for "1v1 online mode" and "global world ranking" [Source: PlayStore Mark Vincent Lacsinto ★3] — implying these don't exist yet but are demanded. The corpus has no observed PvP UI, no leaderboard surface, no clan or guild evidence.

4. [Gap] **Guild / clan / co-op features.** No source mentions any guild system. Likely absent in current build.

5. [Gap] **Lifetime ARPU / spend-tier distribution.** Only qualitative whale signals (VIP, SVIP, $50 ad-removal, $500-marked-down-to-$50 premium bundle). No ARPU data available.

6. [Gap] **D8–D14 mid-game pacing curve.** Videos cover D1 walkthroughs and creator commentary on late-mid mechanics; reviews surface "around 15 minutes / a few days in" friction. But there is no observational evidence of the exact session-by-session progression at days 8–14.

7. [Gap] **Exact stage / wave count at the Mythic-tier soft cap.** Reviewer cites "level 192 normal" as a soft cap and another cites "191 levels then it's done." [Source: PlayStore Mark Vincent Lacsinto, AppStore Schoochie boochie] Are Elite and Nightmare also 191 levels each? Mirror structure assumed. [Assumed]

8. [Gap] **Counter Warning / Counter Active exact effect.** The banner mechanic is visible in 5 videos but no source explains the precise damage modifier, duration, or trigger condition.

9. [Gap] **Hero Gears + Skill Gears mechanics.** apkfami's What's New mentions these as recent additions but provides no mechanical detail. [Source: apkfami] No video captures them being placed or activated specifically.

10. [Gap] **Patrol / AFK income rate and ceiling.** Patrol timer visible (e.g., 5:55:46 countdown) but the exact rewards earned per Patrol cycle, the ceiling on accumulation, and the relationship to player level are not documented.

11. [Gap] **Speed Gear vs Function Gear vs Hero Gear distinction.** The Function Gear tutorial in PryGames [Source: PryGames] defines Function Gears as those that buff adjacent troops (Shield Gear being one example). Speed Gears are described as connectors that multiply efficiency. [Source: PryGames] apkfami calls out Hero Gears as a separate recent addition. The hierarchy and overlap is fuzzy.

12. [Gap] **Astrology vs Alchemy gacha distinction.** Game Hydro's video calls the gacha "Astrology" and shows an elf character with crystal ball. [Source: GameHydro1] The tier-list video also references "the alchemy area" / "alchemy poll" / "alchemy pool" for legendary pity. [Source: GameHydro2] Are these the same system with naming inconsistency, or two parallel gacha pools? Most likely same system, different naming over versions or different in-game UI labels. [Inferred]

13. [Gap] **What "Sloppy Capy Life", "Knight Survivor", and "Food Chronicles" reveal about Mobibrain's design DNA.** Worth a separate comparator pass — the studio's identity is "cute polished casual" with strong rating-curation discipline.

14. [Gap] **iOS-vs-Android cross-platform sync issues.** Reviews surface *"no google play sync?! only FB"* [Source: PlayStore M Morgz ★2] — implying Facebook Login is the primary account system; this is unusual for 2025-2026 and warrants investigation.

15. [Gap] **Why is the developer reply boilerplate?** Out of dozens of developer replies surfaced, ~80% are identical: *"Hello, we are trying to know more from our players to make us improve. Please be patient and believe that we will give you a better experience."* [Source: PlayStore, AppStore passim] This pattern suggests an automated or low-effort CS function — possibly contributing to the customer-support pain point.

---

## 16. Source Index

### Web sources scraped (6 sources, ~107 KB)
- `\Web Sources\play-store-com.iogame.gearworld\content.md` — Google Play listing (description, 18–20 reviews)
- `\Web Sources\app-store-id6740892835\content.md` — Apple App Store listing + 117 reviews across US-iPhone, CA-iPhone, CA-iPad
- `\Web Sources\apkfami-tier-list-guide\content.md` + `\linked-pages\gear-defenders.md` — apkfami 3rd-party guide + linked Gear Defenders page (3rd-party blog; placeholder content in tier-list page; the linked page is substantive)
- `\Web Sources\app-store-developer-mobibrain-1544896321\content.md` — Apple developer catalogue (Mobibrain — 15 apps; Android dev page comparator confirms duplicate Mobibrain catalogue, 10 apps overlap on Android)
- `\Web Sources\_comparators\play-store-com.EternalStudio.GearFight\content.md` — Voodoo Gear Fight! comparator (adjacency only, not same studio)

### YouTube (7 videos analyzed, ~5.7 hours total)
- **GameHydro1** (`bG_jVb0KkoA`): Game Hydro "Tips, Cheats, Strategy Guide" — 18:11, 2025-11-04, 20,202 views (rich commentary, English captions)
- **GameHydro2** (`UiWsglJN1D8`): Game Hydro "TIER LIST of Best Heroes" — 22:12, 2026-01-13, 6,892 views (rich commentary, English captions)
- **PryGames** (`MNSeIZ_lRcA`): PryGames "Gameplay Walkthrough Part 1" — 18:59, 2025-11-23, 1,553 views (silent walkthrough; observation-only)
- **Pryszard** (`KGGgsYPQoEk`): Pryszard "Gameplay Walkthrough Part 1" — 27:02, 2025-11-26 (silent walkthrough; observation-only)
- **IOSTouch** (`VfBxHo2Lkyc`): IOSTouchplayHD "Gear Defenders IOS Gameplay" — 13:13, 2025-07-05, 51 views (silent walkthrough; on-screen text only — VTT was HTTP 429)
- **PGames** (`ePO0xTaSiu8`): PGames "Gameplay Walkthrough Part 1" — 8:29, 2025-11-18, 2,291 views (silent walkthrough; observation-only)
- **WaltonRulf** (`GuHfd31XCjU`): walton rulf "Arenas Abrasadoras Nivel 11–15" — 47:16, 2025-12-14, Spanish (rich commentary, Spanish auto-translated; mid-game footage)

### Play Store
- `\Play Store Reviews\reviews_com.iogame.gearworld\listing_metadata.json` — authoritative Play Store lifetime rating count (88,339), average (4.50★), distribution (5★ 66,623 / 4★ 7,788 / 3★ 3,861 / 2★ 589 / 1★ 6,479)
- `\Play Store Reviews\reviews_com.iogame.gearworld\reviews.csv` — 3,011 review bodies scraped via `pull_reviews.py` (3.4% of lifetime ratings)
- `\Play Store Reviews\reviews_com.iogame.gearworld\analysis_pack.md` — review-thumb-ranked pain themes and verbatim quotes; sample-bias note documenting scraped avg 2.64★ vs lifetime 4.50★

### Image Assets
[Gap] Image inventory not separately listed in this research pass — visual evidence is via the 7 video frame captures referenced inline (e.g. `[V:bG_jVb0KkoA:f_00490]` style frame indices in raw notes).

### Verification reports
- `\Video Analysis\_VERIFICATION_REPORT.md` — full sampling-bias documentation; sample/lifetime divergence reminder (the scraped review sample n=3,011, avg 2.64★ is heavily biased toward "Newest"-sorted reviews surfaced via the public batchexecute RPC; lifetime distribution is 4.50★ across 88,339 ratings per `[Source: Reviews-lifetime]`; any sentiment-percentage claim in this spec should be read as **diagnostic of where the long tail of frustrated players cluster**, not as a measure of overall sentiment)

### Sample/lifetime divergence reminder

The scraped review sample (n=3,011, avg 2.64★) is heavily biased toward "Newest"-sorted reviews surfaced via the public batchexecute RPC. The lifetime distribution is **4.50★ across 88,339 ratings**. [Source: Reviews-lifetime] Any sentiment-percentage claim in this spec should be read as **diagnostic of where the long tail of frustrated players cluster**, not as a measure of overall sentiment.

### How this spec was assembled

1. Read `listing_metadata.json` and `aggregates.json` first to anchor headline truth.
2. Read `analysis_pack.md` for review-thumb-ranked pain themes and verbatim quotes.
3. Read each of 6 web `content.md` sources for storefront-verbatim claims.
4. Read each of 7 video `NOTES.md` files for mechanical observation and creator commentary.
5. Spot-checked two video transcripts (GameHydro1 `bG_jVb0KkoA`, WaltonRulf `GuHfd31XCjU`) for creator quote accuracy.
6. Cross-referenced any single-source claim against ≥1 corroborating source where possible.
7. Tagged every factual claim with provenance per the "Source Tagging Conventions" block.
8. Self-reviewed for tag density, [Assumed] minimization, and [Inferred] reasoning justification.

---

*End of design spec. Update cycle suggested: every 4–6 weeks (Mobibrain ships rapid iterations; v1.4.9 in May 2026 introduced Mythic rarity, Battle Festival, and Monster Codex — a meaningful systems-layer expansion within a 6-month-old game).*
