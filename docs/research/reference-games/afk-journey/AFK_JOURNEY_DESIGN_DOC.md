# AFK Journey — Comprehensive Game Design Reference Document

**Document type:** Internal research reference  
**Date:** 2026-06-11  
**Scope:** Full design analysis covering mechanics, progression, economy, player experience, and market performance

---

## 1. Game Overview

AFK Journey is a fantasy role-playing idle game developed by **Lilith Games** and published by **Farlight Games**. [SOURCE: 01-wikipedia-afk-journey] It is the direct sequel to AFK Arena. [SOURCE: 01-wikipedia-afk-journey]

**Platforms:** Windows, Android, iOS. [SOURCE: 01-wikipedia-afk-journey]  
**Release dates:** March 27, 2024 (EU/NA); August 8, 2024 (Asia / worldwide launch). [SOURCE: 01-wikipedia-afk-journey]  
**Business model:** Free-to-play with gacha monetization. [SOURCE: 01-wikipedia-afk-journey]  
**Publisher country:** China. [SOURCE: 54-sensortower-afk-journey-metrics]  
**Steam launch:** April 27, 2026. [SOURCE: 03-steam-community-reviews]

**Setting:** The land of Esperia. Players assume the role of Merlin, a powerful mage who has lost their memories. [SOURCE: 01-wikipedia-afk-journey]

**Development context:** Development began May 2021. Much of the team transitioned from AFK Arena with a stated vision to create a game that could last 10 years. After 16 months of development, closed tests ran in UK, Canada, Australia, Indonesia, and Philippines, followed by an open beta in April 2023. [SOURCE: 01-wikipedia-afk-journey]

**Genre positioning:** Idle RPG / gacha collector. The game sits in the same space as Genshin Impact and Honkai: Star Rail in terms of gacha mechanics, but differentiates on the idle/auto-battle loop, open-world exploration, and the class-based (not character-based) equipment system. Unlike Genshin, combat is fully automatic with player control limited to triggering ultimates. [SOURCE: 06-bluestacks-beginners]

**Awards:** Won Google Play Best of 2024, App Store Awards Best Game, and was nominated for The Game Awards 2024 Best Mobile Game. [SOURCE: 01-wikipedia-afk-journey]

**Art style:** Draws inspiration from church stained glass — bold color blocks, striking contrasts, and distinct outlines. Described visually as painterly cel-shaded 3D with storybook/Ghibli influences: soft-focus backgrounds, richly colored characters, exaggerated proportions, and large expressive eyes. [SOURCE: 01-wikipedia-afk-journey] [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

---

## 2. Core Loop

### Minute-to-Minute Loop

1. Open the game and collect AFK idle rewards accumulated since last session. [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]
2. Run AFK Stage auto-battles (battles proceed automatically on a tile board; player may tap to trigger hero Ultimates). [SOURCE: 01-wikipedia-afk-journey]
3. Complete daily game mode runs: Dream Realm (boss damage score), Arena challenges (5 free tickets/day), Supreme Arena (Glory Badge challenges). [SOURCE: 12-fandom-arena] [SOURCE: 25-fandom-supreme-arena]
4. Spend accumulated resources: upgrade hero levels, ascend heroes using Soulstones, upgrade equipment, craft/upgrade Charms. [SOURCE: 22-fandom-resonating-hall]
5. Progress main story quests and explore the open world map for chests, puzzles, and treasures. [SOURCE: 05-afkguide-beginners]

### Session-to-Session Loop

The core retention rhythm is: **login → collect → fight → upgrade → repeat**. The game is designed so meaningful progress can occur in short sessions, though veterans note "the game is not really AFK — you need to actively play it to make progress." [SOURCE: analysis_pack.md] [ASSUMED: short-session accessibility is a stated design goal based on the AFK idle collection system]

### Weekly Loop

- Arena rewards tallied and sent every Monday at 01:00 UTC+1. [SOURCE: 12-fandom-arena]
- Supreme Arena defensive map changes weekly; off-season on Mondays/Tuesdays. [SOURCE: 25-fandom-supreme-arena]
- Lucky Flip provides up to 20 random Temporal Essence per week. [SOURCE: 47-reddit-temporal-essence]
- Battle Drills run on a periodic guild schedule (six rounds per season). [SOURCE: 14-fandom-battle-drills]

### Auto-Battle System

Combat unfolds automatically on a tile board. Heroes are positioned by the player before battle starts. Once combat begins, characters move and attack without player input. Players can manually cast each hero's Ultimate ability — this slows down the action until the move is made — or set Ultimates to automatic. [SOURCE: 01-wikipedia-afk-journey]

Heroes have two resource bars: a green HP bar and a yellow Energy bar. When the Energy bar fills, the Ultimate ability becomes available. [SOURCE: 06-bluestacks-beginners] A 3x auto-speed function and a complete auto-battle mode are available. [SOURCE: 06-bluestacks-beginners] Players can utilize environmental mechanisms like flamethrowers and landmines, as well as terrain itself, to gain tactical advantage. [SOURCE: 01-wikipedia-afk-journey]

---

## 3. Hero System

### Six Hero Classes

| Class | Role | Position | Notes |
|---|---|---|---|
| Mage | Magic damage, ranged | Backline | Specializes in magic damage from afar [SOURCE: v1-f2-9q0wgfOY/transcript] |
| Marksman | Ranged physical DPS | Backline | Similar to Mage but uses ranged attacks rather than magical spells [SOURCE: v1-f2-9q0wgfOY/transcript] |
| Rogue | Melee DPS, speed | Frontline | Exceptionally speedy frontline damage dealer [SOURCE: v1-f2-9q0wgfOY/transcript] |
| Warrior | Melee DPS, moderate tankiness | Frontline | Can soak more damage than Mage/Marksman/Rogue but is still a DPS class [SOURCE: v1-f2-9q0wgfOY/transcript] |
| Tank | Protection, damage soak | Frontline | Protects teammates and soaks damage [SOURCE: v1-f2-9q0wgfOY/transcript] |
| Support | Healing/buff/debuff | Flexible | Provides healing, buffing, or debuffing abilities [SOURCE: v1-f2-9q0wgfOY/transcript] |

Each class has its own equipment set (Weapon, Gloves, Accessory, Helm, Armor, Boots — 6 pieces total). Equipment is class-based, not character-based: all heroes of the same class share the same equipment automatically during combat. [SOURCE: 06-bluestacks-beginners] [SOURCE: 05-afkguide-beginners]

**Recommended team composition:** 1 Tank, 2 damage dealers, 1 Support, 1 flex (second tank, second support, or specialist). Triple DPS is not recommended. [SOURCE: v1-f2-9q0wgfOY/transcript]

**Mono-faction caution:** Aiming for purely mono-faction teams is not recommended. Most optimal teams use a core of 3 heroes from one faction plus 2 others chosen for synergy or individual power. [SOURCE: 05-afkguide-beginners]

### Factions

There are 6 standard factions plus 1 special faction for collaboration heroes. [SOURCE: 16-fandom-faction]

**Faction strength cycle (rock-paper-scissors):**
- Lightbearer beats Mauler; loses to Graveborn
- Mauler beats Wilder; loses to Lightbearer
- Wilder beats Graveborn; loses to Mauler
- Graveborn beats Lightbearer; loses to Wilder

Faction advantage/disadvantage deals +15% or -15% damage respectively. Celestials and Hypogeans are **not** part of this cycle. [SOURCE: 16-fandom-faction]

**Faction Bonus:** When 3 / (3+2) / 4 / 5 heroes of the same faction are deployed, all deployed heroes gain ATK and HP +10% / +14% / +18% / +22%. Celestials and Hypogeans count as heroes from any faction for bonus calculations. For each Celestial or Hypogean in the formation, all deployed heroes gain +1% ATK and HP. [SOURCE: 16-fandom-faction]

| Faction | Lore flavor | Notable heroes |
|---|---|---|
| Lightbearers | Fight for the god Dura; primary enemies are Graveborns, Maulers, and Hypogeans; objective is to rid Esperia of evil [SOURCE: 06-bluestacks-beginners] | Marilee, Rowan, Temesia, Walker, Vala, Sinbad, Lucca, Sonja, Perseus [SOURCE: 16-fandom-faction] |
| Maulers | Warrior culture that values strength above all else; might and usefulness are their standards [SOURCE: 06-bluestacks-beginners] | Antandra, Odie, Brutus, Rhys, Shakir, Smokey & Meerky, Soren, Gerda, Zandrok [SOURCE: 16-fandom-faction] |
| Wilders | Abilities reflect enchanted bond with Yggdrasil and the forest; Dura planted Yggdrasil as a farewell gift [SOURCE: 06-bluestacks-beginners] | Arden, Damian, Kafra, Lyca, Parisa, Eironn, Florabelle, Hewynn, Tasi, Lorsan [SOURCE: 16-fandom-faction] |
| Graveborn | Serve in death, resurrected as Undead, use necromancy and dark arts to achieve immortality [SOURCE: 06-bluestacks-beginners] | Cecia, Thoran, Igor, Nara, Hodgkin, Bonnie, Shemira, Daimon, Isabella [SOURCE: 16-fandom-faction] |
| Celestials | Primary objective is to eradicate the Hypogeans and lingering Darkness threatening Esperia [SOURCE: 06-bluestacks-beginners] | Dionel, Scarlita, Talene, Elijah & Lailah, Athalia, Aliceth, Aurora [SOURCE: 16-fandom-faction] |
| Hypogeans | Primary antagonists; objective is to disperse evil throughout Esperia to destroy all of Dura's creations [SOURCE: 06-bluestacks-beginners] | Beiral, Reinier, Phraesto, Harak, Cryonaia, Kulu, Saida, Mehira [SOURCE: 16-fandom-faction] |
| Dimensionals (collab) | Heroes from crossover collaborations; no standard faction lore [SOURCE: 16-fandom-faction] | Lucy, Natsu, Pandora, Laios, Marcille, Himmel, Frieren [SOURCE: 16-fandom-faction] |

### Hero Tiers and Rarity

- **Rare:** Only Chippy and Hammie. Cannot be ascended. [SOURCE: 17-fandom-hero]
- **A-Level heroes:** Start at Elite tier; have 14 tiers available up to Paragon 4. [SOURCE: 13-fandom-ascension]
- **S-Level heroes:** Start at Epic tier; have 12 tiers up to Paragon 4. [SOURCE: 13-fandom-ascension]
- **Celestial/Hypogean:** All are S-Level; no A-Level versions exist. [SOURCE: 05-afkguide-beginners]
- **Dimensional (collab):** Use Dimensional Soulstones once their recruitment banner ends; conversion rate is 1 Soul Sigil to 3 Dimensional Soulstones; ascension costs are 3x the standard A-Level Soulstone cost. [SOURCE: 13-fandom-ascension]

Heroes are obtained primarily via Recruitment using Invite Letters, Epic Invite Letters, Rate Up Invite Letters, or Stellar Crystals. [SOURCE: 17-fandom-hero]

### Resonating Hall — Core System Innovation

The Resonating Hall is where all obtained heroes are displayed alongside Artifacts and Equipment. [SOURCE: 22-fandom-resonating-hall]

**Hands of Resonance:** After completing the tutorial, 5 heroes are designated as Hands of Resonance. Only these 5 can be actively leveled. The Resonance Level equals the lowest-leveled member of the 5. [SOURCE: 17-fandom-hero] [SOURCE: 22-fandom-resonating-hall]

**Synchronized Leveling:** All heroes NOT in the Hands of Resonance automatically match their level to the current Resonance Level. This means every hero in a player's roster is always usable at near-full power, removing the need to grind individual hero levels. [SOURCE: 22-fandom-resonating-hall]

**Swap mechanic:** The 5 Hands of Resonance can be swapped with any obtained hero at any time at no cost. When swapping, hero levels exchange. Hands of Resonance must stay within 10 levels of each other. [SOURCE: 22-fandom-resonating-hall]

> "you only need to level up 5 heroes and get equipment for the 6 types of heroes once, and that automatically applies to all of them." [SOURCE: analysis_pack.md]

This system is consistently cited as the game's standout mechanical innovation by players. [SOURCE: analysis_pack.md]

---

## 4. Progression Systems

### Resonance Level

- Heroes can be leveled from Level 1 to Level 240 using Gold, Training Manuals, and Hero Essence. [SOURCE: 17-fandom-hero]
- Early leveling is bottlenecked by Hero Experience, then around level 110–120 Hero Essence becomes the hard cap until level 240. [SOURCE: v2-0mb9XIFjFG4/transcript.md]
- Upon reaching Resonance Level 240, all equipment can be upgraded to maximum level. [SOURCE: v2-0mb9XIFjFG4/ANALYSIS.md]
- Video confirmation: Resonance Level 275 shown with all heroes in roster at Lv 275. [SOURCE: v2-0mb9XIFjFG4/ANALYSIS.md]

**Training Manual conversion:** After Resonance Level 240, Training Manuals can be recycled into Hero Essence at a rate of 3,000 Training Manuals = 1 Hero Essence. [SOURCE: 22-fandom-resonating-hall] In-game conversion dialog (verbatim): *"Training Manuals can be converted into Hero Essence. Convert all your Training Manuals?"* — confirmed in video showing conversion of 4,869,000 Training Manuals into 1,475 Hero Essence. [SOURCE: v2-0mb9XIFjFG4/ANALYSIS.md]

### Resonance Synergy (Post-240 Progression)

After reaching Resonance Level 240, **Resonance Synergy** unlocks, continuing to require Hero Essence to level up. [SOURCE: 22-fandom-resonating-hall]

- Resonance Synergy increases stats just like Resonance Levels until +60. After +60 there is no additional combat effect — instead, each additional level provides Diamond rewards. [SOURCE: 22-fandom-resonating-hall]
- Base hard cap: **Resonance Synergy Level 300**. [SOURCE: v2-0mb9XIFjFG4/transcript.md]
- **Supreme+ expansion:** For every Supreme+ hero owned, the maximum Resonance Synergy level increases by 5. In-game tooltip verbatim: *"For every Supreme+ hero you own, the max level of Resonance Synergy increases by 5" and "Current Max Level: 340"* (representing base 300 + 8 Supreme+ heroes × 5). [SOURCE: v2-0mb9XIFjFG4/ANALYSIS.md]

### Ascension System

**Tier progression and copy requirements:**

| Ascension Tier | A-Level cost | S-Level cost | Celestial/Hypogean cost |
|---|---|---|---|
| Elite → Elite+ | 1x A Soulstone | N/A | N/A |
| Elite+ → Epic | 3x A Soulstone | N/A | N/A |
| Epic → Epic+ | 4x A Soulstone | 1x S Soulstone | 1x S Soulstone |
| Epic+ → Legendary | 5x A Soulstone | 50x Omni-Acorn | 1x S Soulstone |
| Legendary → Legendary+ | 8x A Soulstone | 2x S Soulstone | 1x S Soulstone |
| Legendary+ → Mythic | 10x A Soulstone | 100x Omni-Acorn | 2x S Soulstone |
| Mythic → Mythic+ | 12x A Soulstone | 2x S Soulstone | 2x S Soulstone |
| Mythic+ → Supreme | 200x Omni-Acorn | 200x Omni-Acorn | 2x S Soulstone |
| Supreme → Supreme+ | 20x A Soulstone | 2x S Soulstone | 4x S Soulstone |
| Supreme+ → Paragon 1 | 45x A Soulstone | 6x S Soulstone | 4x S Soulstone |

[SOURCE: 17-fandom-hero]

**Total hero copy requirements to Supreme+:**
- A-Level: 1 original + 63 copies (64 total) + 200 Faction Acorns [SOURCE: 10-lootbar-ascension-guide]
- S-Level: 1 original + 7 copies (8 total) + 350 Camp Acorns [SOURCE: 10-lootbar-ascension-guide]
- Celestial/Hypogean: 1 original + 13 copies (14 total) [SOURCE: 10-lootbar-ascension-guide]

**Key ascension milestones:**
- **Legendary+**: Unlocks Hero Focus (stat buff in battle; upgrades with Tidal Essence) [SOURCE: 17-fandom-hero]
- **Mythic+**: Unlocks Exclusive Equipment (new skill called Exclusive Skill / EX) [SOURCE: 17-fandom-hero]
- **Supreme+**: Unlocks Skill Enhancement (additional effect on one skill) [SOURCE: 05-afkguide-beginners]

**Paragon tier unlock requirements (hidden until 25 heroes at Supreme+):**
- Paragon 1: 25 heroes at Supreme+
- Paragon 2: 20 heroes at Paragon 1
- Paragon 3: 15 heroes at Paragon 2
- Paragon 4: 15 heroes at Paragon 3

Paragon tiers grant special PvP bonuses known as Rivalry Stats; they do not unlock new skills. [SOURCE: 13-fandom-ascension]

**Winged Crown:** A special frame (not a distinct tier) for heroes ascended to Paragon 4 with +25 Exclusive Equipment. [SOURCE: 13-fandom-ascension]

### Equipment System

Equipment is class-based, not character-based. All heroes of the same class share identical equipment automatically. [SOURCE: 06-bluestacks-beginners] Equipment can be dropped from AFK stages, obtained as quest rewards, or crafted (Forging) using Casting Shards obtained by recycling unwanted gear. Forgeable equipment level is tied to Resonance level. [SOURCE: 05-afkguide-beginners]

**Upgrade priority by class:**
- Mage: Weapon > Accessory > Helm > Armor > Gloves > Boots
- Warrior: Weapon > Boots > Accessory > Helm > Gloves > Armor
- Rogue: Weapon > Helm > Gloves > Accessory > Armor > Boots
- Tank: Boots > Armor > Accessory > Helm > Gloves > Weapon
- Marksman: Weapon > Helm > Gloves > Accessory > Armor > Boots
- Support: Helm > Boots > Armor > Accessory > Weapon > Gloves

[SOURCE: 05-afkguide-beginners]

### Exclusive Equipment (EX Weapon)

Every hero has a distinct Exclusive Equipment with unique effects designed specifically for them. It unlocks when the hero reaches Mythic+ rarity, starting at Level 0. Unlocking grants a new skill called the Exclusive Skill (EX). Every +5 levels unlocks a new ability or enhances an existing one. [SOURCE: 15-fandom-exclusive-equipment]

**Upgrade cost table:**

| Stage | Unlocks | Requirement | Cost |
|---|---|---|---|
| 0 → +5 | Stats + Ability Upgrade | Mythic+ | 150x Tidal Essence |
| +6 → +10 | Stats + Ability Upgrade | Supreme | 75x Temporal Essence |
| +11 → +15 | Stats + Ability Upgrade | Supreme+ | 200x Temporal Essence |
| +16 → +20 | Stats | Supreme+ | 125x Twilight Essence |
| +21 → +25 | Stats | Supreme+ | 500x Twilight Essence |

[SOURCE: 15-fandom-exclusive-equipment]

### Paragon System

Paragon tiers are unlocked after 25 heroes reach Supreme+. They are hidden from the UI until that milestone. [SOURCE: 13-fandom-ascension] Steam reviews describe Paragon inflation as a mechanism by which PvP is "replaced with who has the higher paragon stats" — positioning it as a pure stat-check layer beyond normal hero investment. Every season brings stronger Paragon bonuses, contributing to what veteran players describe as "forced obsolescence." [SOURCE: 03-steam-community-reviews]

---

## 5. Gacha & Economy

### Banner Types and Costs

| Banner | Rate (displayed) | True per-pull rate | Hard pity | Pull cost |
|---|---|---|---|---|
| Standard / All-Hero | 2.05% | ~0.726% | 60 pulls | 270 Diamonds (10x) / 300 (single) |
| Rate-Up / Limited | 3% | ~0.962% | 40 pulls | 300 Diamonds (no 10x discount) |
| Epic Recruitment | 5.22% | ~3.35% | 30 pulls | Epic Invite Letters only |
| Stargaze / Stargazing | 3.25% | ~1.4% | 40 pulls | Separate currency |

[SOURCE: 52-reddit-gacha-rates-not-accurate] [SOURCE: 06-bluestacks-beginners] [SOURCE: 30-reddit-pull-rates-scam]

**No soft pity:** AFK Journey has no soft pity system. The rate is flat from pull 1 all the way to the hard pity pull, then instantly resets. This contrasts with Genshin Impact and Honkai: Star Rail where rates increase near pity. [SOURCE: 52-reddit-gacha-rates-not-accurate] [SOURCE: 41-reddit-always-hit-pities]

**Key finding on displayed rates:** Community analysis (327 upvotes, 94% upvoted) demonstrated that the rates displayed in-game are not per-pull odds but averages over a full pity cycle. The calculated true per-pull rate on the standard banner: ~0.726%. The change from 1.65% to 2.05% when pity was lowered from 80 to 60 (during PTR) is consistent with these being pity-adjusted averages, not base rates. The game provides no explicit clarification of this, unlike HSR and Reverse:1999. [SOURCE: 52-reddit-gacha-rates-not-accurate]

### Wishlist System

- **Standard banner Wishlist:** Unlocks after 30 pulls; players can mark 2 S-Level and 2 A-Level heroes per faction. Every 30 pulls guarantees 1 of the 5 wishlisted heroes (can be S-level or A-level). [SOURCE: 06-bluestacks-beginners] [SOURCE: 45-reddit-incredible-drop-rate]
- **Epic Recruitment Wishlist:** 5-hero selection available immediately. If pity triggers, the player receives one of those 5. [SOURCE: 32-reddit-atiers-epic-wishlist]

> "AFKJ epic recruitment standard pool - 10 pulls guarantee A-level or above; 30 pulls guarantee 1 of the 5 heroes you chose which can be S-level or A-level. if that's not amazing, i dunno what is" — u/mastergoopie (score 134) [SOURCE: 45-reddit-incredible-drop-rate]

**No 50/50 on rate-up:** If you pull an S-tier hero on the rate-up banner before hard pity, it is 100% guaranteed to be the rate-up character. No 50/50 random split exists. [SOURCE: 38-reddit-pity-how-works]

**Limited to standard pool:** Limited banner characters enter the general/standard pool immediately after their banner run ends, allowing wishlist targeting afterward. This is broadly praised as unusually generous. [SOURCE: 45-reddit-incredible-drop-rate]

### Currency Ecosystem

**Diamonds:** Primary premium currency. Used to purchase pulls (270 per pull for 10x on standard banner, 300 per single pull on rate-up). Described as "pretty easy to take back, even in F2P." [SOURCE: 30-reddit-pull-rates-scam]

**Tidal Essence (Blue):** Used for EX upgrades from 0 to +5 (150x per hero). Bottleneck for players aiming for EX+10. "Blue essence becomes 'just useless for anyone who's been playing for a while.'" [SOURCE: 48-reddit-temporal-vs-twilight-essence]

**Temporal Essence (Yellow/Gold):** Used for EX +6 through +15 (75x for +6–+10; 200x for +11–+15). Described as the hardest essence to obtain and the intentional progression bottleneck for the average player. Best free sources: Dream Realm ranking rewards and the Dream Realm store. Also 20 random Temporal Essence per week from Lucky Flip. Described as Farlight's "main money maker." [SOURCE: 47-reddit-temporal-essence]

**Twilight Essence (Red):** Used for EX +16 through +25 (125x for +16–+20; 500x for +21–+25). Players typically accumulate far more than they can spend — one player reported having 3,000+ Twilight Essence. No conversion to Temporal exists; developer acknowledged the community request but did not implement it. [SOURCE: 29-reddit-convert-twilight-temporal] [SOURCE: 48-reddit-temporal-vs-twilight-essence]

**EX weapon cost example:** Getting a team of 5 to EX+25 requires 3,125 Temporal Essence total. Two characters to +15 and four to +10 takes the same Temporal Essence as getting one character to +25. [SOURCE: 48-reddit-temporal-vs-twilight-essence]

### Rate-Up Banner Value Analysis

Community math by u/crashlanding87: 42,000 Diamonds on rate-up banner yields ~5 rate-up S units + ~20 wishlist A units. The same diamonds on the standard banner yield ~6 wishlist S units + ~43 wishlist A units. Conclusion: rate-up banner gives one fewer S unit and 23 fewer A units per 42k diamonds spent, making it better only for hyper-targeting a single specific unit. [SOURCE: 39-reddit-math-rateup-banner-value]

### F2P Viability

Multiple community voices confirm F2P is viable for content progression and even competitive play at lower server tiers:

> "as a f2p, im pretty happy, feel like im always progressing/pulling" — u/Odd-Seaworthiness826 [SOURCE: 45-reddit-incredible-drop-rate]

One mid-level spender reports every relevant character at EX+10 and top damage dealers at EX+25 through pure F2P Temporal income. [SOURCE: 47-reddit-temporal-essence] However, true competitive ranking at the top is dominated by spenders, and multiple commenters argue that the ranking race is not achievable as F2P regardless of summoning strategy. [SOURCE: 32-reddit-atiers-epic-wishlist]

---

## 6. Game Modes

### AFK Stages (Idle Collection)

**What it is:** The primary idle progression mode. Heroes automatically battle while the player is offline, accumulating resources over time. [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

**How it works:** AFK Stage progress is tracked on a linear node map. Stage nodes are numbered (199–204 observed in video), with boss nodes marked as purple diamonds and current progress as green circles. [SOURCE: v1-f2-9q0wgfOY/ANALYSIS] Auto-battles use a top-down isometric view with a countdown timer (80s default). The idle collection screen shows: AFK duration (3h43m observed), accumulated resources (7k gold, 203 diamonds, 30k XP shown), and two buttons: 'Instant' (free fast-collect, 2/2 uses) and 'Collect'. [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

**Version 1.5.1 overhaul:** Clearing AFK Stages now rewards Select Equipment Chests (player chooses piece); one-time season rewards tied to Season Handbook; on first day of a new season, AFK rewards hit maximum efficiency after Stage 10. The mode previously called "Infinite Stage" was renamed to Apex Stage. [SOURCE: 04-farlight-major-updates]

**Unlock:** Available from the start of the game. [ASSUMED — standard tutorial unlock]

---

### Dream Realm

**What it is:** A dedicated boss raid mode focused on maximizing damage score against rotating large bosses. [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

**Setting:** Teal seafoam floor tiles, yellow/gold cubic rock formations on left wall, teal stone arch columns on right. [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

**Boss mechanics observed:** Large organic tree/nature creature with green leaf crown and brown bark torso. Boss has a 'Phys Immunity' phase where physical damage is blocked. A persistent teal cauldron-like ally summon entity stays in the lower-left field throughout combat. Eight total bosses exist (including Endless difficulty), with several named: Crystal Beetle, Orson, Sarothian/Saratro, Nocturne Judicator, Doom Scourge, Gloomwall, Blight Room, King Croaker/Titan Reaver. [SOURCE: v1-f2-9q0wgfOY/ANALYSIS] [SOURCE: 04-farlight-major-updates] [SOURCE: 07-ldshop-mythic-charm-priority]

**Importance to economy:** Dream Realm ranking is the best free source of Temporal Essence. Top score requires optimized Mythic Charm sets. Two new Dream Realm bosses (Crystal Beetle and Orson) were added in Version 1.2.1. [SOURCE: 47-reddit-temporal-essence] [SOURCE: 04-farlight-major-updates]

---

### Arena (PvP)

**What it is:** Non-Season permanent PvP battle mode. Released Version 1.0. [SOURCE: 12-fandom-arena]

**How it works:** Players spend Arena Tickets to challenge others on the same server. Defeating opponents earns Arena Points that increase tier. Each player receives 5 Arena Tickets daily after reset; up to 5 more can be purchased with Diamonds (increasing cost per ticket), capping daily attacks at 10. [SOURCE: 12-fandom-arena]

**Level normalization:** Heroes above level 151 are set to 151; heroes between baseline+1 and 240 have 10% of excess added to baseline for their effective Arena level. Season content (Season Equipment Resonance Levels, Season Equipment, Season Magic Charms, Season Artifacts) is NOT effective in Arena. [SOURCE: 12-fandom-arena]

**Tier structure:** Novice I through Legendary III as Basic Tiers (1,000 to 3,000+ Arena Points), then Champion tiers (Top 101–200 through Top 5) for players exceeding 3,200 Arena Points. [SOURCE: 12-fandom-arena]

**Rewards:** Tallied and sent every Monday at 01:00 UTC+1 (weekly) and daily at 01:00 UTC+1 for Champion tier. First-time rewards across all tiers total Diamond x23,395, Temporal Essence x160, Twilight Essence x100. [SOURCE: 12-fandom-arena]

**Demotion:** Bottom 100 Champion-tier players face a Defensive Match on weekends; losers are demoted to Legendary III. [SOURCE: 12-fandom-arena]

**Inactivity:** Players inactive for more than 14 days have their defense replaced by Chippy and Hammie NPCs; restored on login. [SOURCE: 12-fandom-arena]

---

### Supreme Arena (Seasonal PvP)

**What it is:** Seasonal PvP battle mode with a best-of-three format. Baseline season level: 160. [SOURCE: 25-fandom-supreme-arena]

**Unlock condition:** Requires reaching Season AFK Stage 130. [SOURCE: 25-fandom-supreme-arena]

**How it works:** Players spend Glory Badges to challenge others in the same district. 3 free Glory Badges provided; up to 12 more purchasable with Diamonds. Winning 2 out of 3 rounds achieves victory; challenger and defender exchange ranks. [SOURCE: 25-fandom-supreme-arena]

**Rank mechanic:** Position-swap system (not points differential). Position is locked at a random time within the 10 minutes before daily calculation to prevent last-second rank sniping. [SOURCE: 46-reddit-supreme-arena-rank-system]

**Off-season:** Mondays and Tuesdays; no challenges can be issued, no rewards distributed, but formations can be set. [SOURCE: 25-fandom-supreme-arena]

**Rewards (top tier):** Top 1–5 daily: Supreme Point x50, cosmetic items, Twilight Essence x8, Diamond x360, Season Token x500, Season XP Hourglass x6. [SOURCE: 25-fandom-supreme-arena]

**Weekly map effects** (rotating each season): Infinite Front - Frozen Respite, Haunting Grounds, Rallying Grounds, Field Forge, Majestic Court, Hidden Tile. [SOURCE: 25-fandom-supreme-arena]

---

### Honor Duel (Roguelite PvP)

**What it is:** Fair Play PvP where players build a run-based deck of heroes and equipment, battling opponents across a gauntlet structure. Not P2W (confirmed by community). Released Version 1.0.9. [SOURCE: 18-fandom-honor-duel] [SOURCE: 37-reddit-honor-duel-relic-tier]

**Run structure:** Choose an initial Artifact (the run-defining starting choice) and initial heroes. The run ends after **9 wins OR 3 losses**, whichever comes first. Between rounds, players purchase heroes and equipment in the Duel Store using Honor Badges. [SOURCE: 18-fandom-honor-duel]

**Artifact rarity/upgrading:** 40+ artifacts exist. Artifacts can be upgraded to 1 Star (gaining upgraded effect) and to 2 Stars. Upgrading to 2 Stars awards Legendary equipment. [SOURCE: 19-fandom-honor-duel-artifacts] [SOURCE: 20-fandom-honor-duel-equipment]

**Equipment tiers and costs:**
- Rare: 10 Honor Badges (note: purple items are Elite, not Rare — community cited this as confusing)
- Elite: 20 Honor Badges
- Epic: 40 Honor Badges (yellow items)
- Legendary: Only obtained by upgrading artifacts to 2 Stars or as a random reward from Fitz's Trials [SOURCE: 20-fandom-honor-duel-equipment] [SOURCE: 37-reddit-honor-duel-relic-tier]

**Sample Legendary equipment effects:** Bloom (splash on normal attacks), Chained Step (HP% damage to all enemies), Eternal Blade (stacking +5% team damage per 5s up to 70%), Reclusive Sage (15s untargetable then full reset with +40% damage). [SOURCE: 20-fandom-honor-duel-equipment]

**Strategy principles:** Artifact defines the run archetype. Duplicates grant artifact XP for upgrading. Key documented combos: Rowan + Lithe Larkspur/Immortal Flame artifact; Thoran + Obsidian Earring artifact; Marilee + Dawn Antlers + Fallen Dagger. Economy rotation artifacts (Crystal Dew) enable different draft strategies than hero-specific artifacts. [SOURCE: 37-reddit-honor-duel-relic-tier]

---

### Battle Drills (Guild PvE)

**What it is:** Periodic PvP/PvE Guild Battle Mode for all players in a guild who have cleared AFK Stage 50. Released Version 1.0. [SOURCE: 14-fandom-battle-drills]

**Node types:**
- **Passages:** Waves of enemies to defeat; recommended 3-hero team (Tank + DPS + Support) to conserve stamina. [SOURCE: 09-lootbar-battle-drills]
- **Strongholds:** 5 strong enemies with high HP; defeating grants buff bonuses; recommended 5-hero AoE team. [SOURCE: 14-fandom-battle-drills]
- **Bosses:** Toughest enemies with unique powers; requires a strong team; 3 difficulty modes (Stout Recruit, Seasoned Challenger, Restless Warrior). In Restless Warrior mode, the boss respawns indefinitely until round ends. [SOURCE: 14-fandom-battle-drills]

**Stamina system:** Players start with 10 Stamina; recovers 10 daily at 08:00 UTC+8; stores up to 30 (or 45 for camps at Level 90+). Each hero also has 3 individual Stamina (recovers 1 daily). Deploying a hero costs 1 hero Stamina and 1 daily Stamina. Each hero can only be used once per day. [SOURCE: 14-fandom-battle-drills] [SOURCE: 09-lootbar-battle-drills]

**Season Level adjustment:** All Battle Drills rounds are adjusted to Level 400 with equipment adjusted to match. [SOURCE: 14-fandom-battle-drills]

**Rounds per season:** 3 rounds during Starter Season; 6 rounds per season from Season 1 onward. [SOURCE: 14-fandom-battle-drills]

**Round buffs (examples):** Defense Master, Divine Punishment, Energy Flow, Focus Hit, Instant Momentum, Moment of Glory, Superiority (250% boss damage boost for Supreme+ heroes with Lv.15 Exclusive Equipment), Trailblazer (250% Passage Brawl damage). [SOURCE: 14-fandom-battle-drills]

---

### Tower of Memory

**What it is:** A seasonal exploration content area set at the Serene Lyceum and surrounding areas. [SOURCE: 26-fandom-tower-of-memory-exploration]

**Regions:** Starfall County, Interrealm, Simulacrum Isles, Skyrealm Forest, Stellar Hall. [SOURCE: 26-fandom-tower-of-memory-exploration]

**Exploration mechanic:** Find Crimson Treasures (x10 Exploration Progress each), Luxury Chests (x5 each), and Wooden Chests (x5 each). Starfall County has 5 sub-areas; completing each awards Diamond x100. Completing the full Starfall County region awards Origami Hamster x60 + Hat Trick emote + Diamond x200. [SOURCE: 26-fandom-tower-of-memory-exploration]

---

### Elite Challenge

**What it is:** A named boss fight mode encountered within the open world map at specific named locations (e.g., Holy Temple Cave at coordinates 24, 31). [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

**Observed details:** Set in a dark stone colosseum with purple torch lighting. Boss is a massive white stone golem with blue gem joints and claw arms. Boss has a stack counter that counts down (x30 to x17+ observed over a session). Timer visible (70s–66s observed). Hero dialogue triggers during combat (Atalanta: "How's the Holy Hammer taste, big guy!!"). Status effects observed: 'Unaffected' (on boss), 'Life Drain up' (buff on hero). [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

---

### World Map Exploration

**Structure:** Open world with several regions to explore via hex grid with coordinate system (e.g., Vaduso Mountains at 387,323; Oblivion Valley at 113,74). Enemy level brackets are visible on map entities before engagement. [SOURCE: v1-f2-9q0wgfOY/ANALYSIS] Teleportation points allow fast travel. Puzzles scattered across the map give rewards. [SOURCE: 01-wikipedia-afk-journey]

**Puzzle types (documented):** Philip's Inventory Sort, Pressure Plate Puzzles, Light the Beacons Puzzles, Treasure Hunting, Missing Chests on the Map, Barricaded Pathways. Map areas include Dark Forest, Crimson Highlands, Vaduso Mountains, Eroded Enclave, and Waves of Intrigue areas (Century Forge, Land of Riches). [SOURCE: 53-reddit-megathread-puzzle-solutions]

**Miasma mechanic:** The dark purple mist on the game map that covers locked regions. To dispel it, players must defeat the Hypofiend blocking the way to a new region. The ability to unlock new regions is gated by AFK stage level. [SOURCE: 51-reddit-miasma-dispel]

---

### Peaks of Time (Past Season Archive)

**What it is:** An archive system for past seasons allowing players who missed a season to access its story, map resources, and quests. Also referred to as the Temporal Nexus in official developer communication. Added October 1 (during Version 1.2.1 cycle). [SOURCE: 04-farlight-major-updates]

**Unlock condition:** Requires completing The Last Leg quest (and broadly: finishing the main storyline and reaching Resonance Level 240). [SOURCE: 04-farlight-major-updates] [SOURCE: 44-reddit-explain-seasons-peaks-of-time]

**Story independence:** Story chapters are not affected by seasonal progressions. Developer communication compared it to Netflix — "you can explore them in any order you like." [SOURCE: 31-reddit-dev-update-powercreep]

---

## 7. Season System

### Season Structure

Seasons are major, self-contained storylines lasting approximately 4 months. Only one live season is available at a time (excluding the starter story). [SOURCE: 23-fandom-season]

**Dual progression design:**
1. **Permanent Progression System** — foundation of player power across all seasons. Covers: starter story artifacts, resonance levels, class equipment, hero tiers, hero exclusive equipment, etc.
2. **Seasonal Progression System** — developed only through seasonal content, only effective during its season. Covers: seasonal resonance level, seasonal class equipment, seasonal artifacts, seasonal magic charms, seasonal skills. [SOURCE: 23-fandom-season]

**What resets at season end:** All seasonal hero upgrades, progress, rankings, and rewards in seasonal modes reset. [SOURCE: 23-fandom-season]  
**What persists:** Hero ascension, EX weapons, resonance base level, permanent heroes and roster. [SOURCE: 50-reddit-what-happened-game]

**Unlock requirements:** Resonance Level 240, clearing AFK Stages 1125, and completing the main questline. [SOURCE: 23-fandom-season] [SOURCE: 31-reddit-dev-update-powercreep]

**Server eligibility:** A new season is available when a server has been active for a minimum set number of days (originally stated as 42 days). A countdown event banner starts 14 days before each season starts on each server. [SOURCE: 31-reddit-dev-update-powercreep]

**District mechanic:** At the start of each season, multiple servers are assigned to a District for cross-server cooperative or competitive modes. Servers are reassigned to different Districts for the next season. [SOURCE: 31-reddit-dev-update-powercreep]

**AFK Final Push:** Before a season starts, if a player is falling behind in progression, this mechanism automatically activates to help them catch up by providing extra Essence rewards through main quests and various game modes. [SOURCE: 31-reddit-dev-update-powercreep]

### Season History

**Starter Story:** The initial game experience (pre-seasonal content). Covers Esperia's core narrative. [SOURCE: 23-fandom-season]

**Season 1 — Song of Strife (May 2024):** First seasonal content update. Introduced: Season Resonance Level (resets each season), Season Hero Skills (1 seasonal skill per hero, unlocked at Season Resonance Level 51, only effective during season), Season Class Equipment (resets each season), Season Artifacts (8 new artifacts per season, obtainable through Season Journey), Magic Charms (5 quality tiers, reset each season, collecting 3 same-quality charms activates hero's special ability). New areas including Holistone and beyond. [SOURCE: 31-reddit-dev-update-powercreep]

**Season 2 — Waves of Intrigue (Version 1.2.1, September 19, 2024):** Pirate-themed area (Rustport). New hero: Dunlingr, the Eternal Voice (Celestial, September 20, 2024). [SOURCE: 04-farlight-major-updates]

New mechanics in Season 2:
- **Rustport Fishing:** Players choose a fishing spot on the season map to gain Skill Points, increase Fishing Level, and unlock bonuses. (Fishing was first introduced in Version 1.1.17 on August 2, 2024.) [SOURCE: 04-farlight-major-updates]
- **Magic Charms:** Introduced fully; equippable by all heroes, providing stats and set bonuses; primarily obtained through Dura's Trials. [SOURCE: 04-farlight-major-updates]
- **Heroic Gauntlet:** Heroes temporarily upgraded to Mythic tier; rewards include Invite Letters, Velvet Vouchers, Twilight Essence. [SOURCE: 04-farlight-major-updates]
- **Talent Trials:** New mode in Season AFK Stages using Faction Talents; clearing stages increases Season AFK progress. [SOURCE: 04-farlight-major-updates]
- **Season Swaps:** Swap two heroes released during Waves of Intrigue, exchanging their hero tiers and levels of Exclusive Equipment, Hero Focus, and Enhance Force. [SOURCE: 04-farlight-major-updates]
- **Season Handbook:** Earn Season Milestone Points by completing Season Challenge Missions to unlock rewards. [SOURCE: 04-farlight-major-updates]
- **Velvet Store:** Cosmetics (clothing, eyes, headwear, skintones, etc.) purchasable with Velvet Vouchers. [SOURCE: 04-farlight-major-updates]
- **Two new Dream Realm Bosses:** Crystal Beetle and Orson. [SOURCE: 04-farlight-major-updates]
- **Peaks of Time:** Added October 1, 2024. [SOURCE: 04-farlight-major-updates]

**Season 2 story cast:** Sinbad, Nara (Sonja's sister, became a Water Wight / Graveborn), Sonja, Lucca, Hodgkin (pirate villain), Bonnie (Cecia's twin sister, Graveborn), Viperian, Tesio (Carmine Whispers leader), Hugin (inventor). The Kraken is a major beast/character. [SOURCE: 34-reddit-waves-intrigue-ended]

**Season 2 story reception (negative):**
> "The story itself had potential to be great, but it feels like the end was so rushed that it's like someone waved a wand and went and they all lived happily ever after." — u/IceboundEmu [SOURCE: 34-reddit-waves-intrigue-ended]

**Season 2 story reception (positive):**
> "[T]he character development and the story beats might have been more enjoyable than FFXIV Dawntrail." — Aywren (blogger) [SOURCE: 08-aywren-season2-waves]

**Version 1.5.1 — September 26, 2025:** New heroes: Aliceth (Celestial, Marksman, S-Level, 'the Radiant Wings') and Perseus (Lightbearer, Warrior, S-Level, 'the Chosen Champion'). AFK Stages overhauled (Select Equipment Chests). Treasure Trials overhauled (6 class-specific trials, 3-day rotation). Soul Pact / Phantimals introduced. [SOURCE: 04-farlight-major-updates]

### Soul Pact / Phantimals

A Seasonal Mechanic introduced in the Thorns of Devotion season (Version 1.5.1). Also active in Tower of Memory and Crown of Ashes seasons. [SOURCE: 24-fandom-soul-pact]

**Rules:** Activate by deploying 3 heroes from the same faction (deploying 3 Celestial or Hypogean heroes activates the Celestial & Hypogean Faction Phantimal). During preparation phase, adjust the Phantimal's position. Once battle begins, the Phantimal fights alongside the player as a 6th unit. After upgrading a Phantimal to a certain level, it designates an ally as a spirit-marked hero granting powerful bonuses. Phantimal stats scale with the deployed heroes' levels and tiers. Dimensional heroes on the battlefield grant bonus ATK and HP to activated Phantimals. [SOURCE: 24-fandom-soul-pact]

**Reset mechanics:** Phantimals' upgrade progress resets at season end. Materials are returned on reset. Free reset available once every 3 days; Phantimal Reshapers required otherwise. [SOURCE: 24-fandom-soul-pact]

**Crown of Ashes Phantimals:** Wilder: Blightshroom (Mage). Lightbearer: Aurelian (Support). Mauler: Orson (Tank). Graveborn: Necrodrakon (Mage). Celestial & Hypogean: Oathbound Spear (Warrior). [SOURCE: 24-fandom-soul-pact]

### Power Creep — Developer Stance

From the pre-Season 1 dev Q&A post (409 upvotes):

> "At AFK Journey, we want to address this issue, especially the problem of long-term power creep that is common in gacha games." [SOURCE: 31-reddit-dev-update-powercreep]

The developer solution is the dual permanent/seasonal progression split — seasonal systems reset each season, preventing power gains from accumulating indefinitely. Community response:

> "Seasonal skills and artifacts allows them to field-test stuff for possible later implementation, with the safety catch of it's gone when the season ends if it doesn't pan out." — u/Mystic_x (score 132) [SOURCE: 31-reddit-dev-update-powercreep]

Steam reviewers by 2025–2026 largely consider this promise unfulfilled: "Power creep described as out of control — every season makes old progress feel worthless." [SOURCE: 03-steam-community-reviews]

---

## 8. Mythic Charms

### System Overview

Charms have 4 quality tiers: Elite, Epic, Legendary, and Mythic. Mythic Charms can be further upgraded to V+ and V++ using currency earned through salvaging duplicates. Having 3 Mythic charms upgraded to at least V+ earns an additional Type Bonus. [SOURCE: 07-ldshop-mythic-charm-priority]

**Raw stat uplift:** A Mythic+ charm gives 15.3% attack vs. 12% attack for a Legendary+ charm — a direct stat boost independent of set effects. [SOURCE: v4-x4YngIZN1-8/transcript]

**Seasonality:** Charms completely disappear (reset) at the beginning of every season. Mythic charms from previous seasons reappear for purchase when a new season starts. [SOURCE: 42-reddit-mythic-charms-pvp-afk-dream]

**Set bonus:** When 3 Mythic charms of the same type are equipped, a set bonus activates that can dramatically elevate performance. The game's own recommended charms are generalized; following them for PvP or Dream Realm leaves significant potential untapped. [SOURCE: 07-ldshop-mythic-charm-priority]

**Charm merchant:** Heroes released in the current season (including Celestials and new dimensional heroes) can have their charms purchased from the charm merchant before crafting. [SOURCE: v3-48SNAAhcKLk/transcript]

### Charm Types Reference

| Type | Stats granted | Primary use |
|---|---|---|
| Blast | ATK + Ultimate Power | Heroes whose damage scales with Ultimate or burst |
| Butcher | Sustained damage scaling | Best for long-fight damage heroes (e.g., Shemira) |
| Gale | ATK + ATK Speed | Highest ceiling for attack-speed-scaling heroes (e.g., Silven) |
| Mystic | Haste + Skill Power | Safe/versatile; especially for support/buff heroes |
| Arcane | Skill Power + ATK | Buff-bot healers whose attack buff scales with Skill Power |
| Insight | Skill Power (crit/damage buff to allies) | Ludovic, Barrel, Theodora, Shakir |
| Sorcery | Consistent general damage | Most Dream Realm bosses; wide hero applicability |

[SOURCE: 07-ldshop-mythic-charm-priority] [SOURCE: v4-x4YngIZN1-8/transcript]

### Priority Guide (Per-Hero)

| Hero | Charm | Notes |
|---|---|---|
| Shemira | Butcher | Do NOT use Blast despite in-game recommendation; proven superior across PvE, AFK Stages, Legend Trial, and most Dream Realm bosses [SOURCE: 07-ldshop-mythic-charm-priority] |
| Gerda | Blast | 100% Dream Realm usage across all 8 bosses; most impactful single investment [SOURCE: 07-ldshop-mythic-charm-priority] |
| Ludovic | Insight | Worth 10–15 billion extra score per boss; extremely high priority [SOURCE: v4-x4YngIZN1-8/transcript] |
| Silven | Gale | Attack speed procs extra blades more frequently [SOURCE: 07-ldshop-mythic-charm-priority] |
| Cecia | Arcane | Skill Power increases attack buff to allies; Attack scales buff value; non-negotiable for Dream Realm [SOURCE: 07-ldshop-mythic-charm-priority] |
| Damian | Mystic | Haste increases skill cast frequency for Playtime Plunder; Skill Power increases attack buff ~8% per 4 SP [SOURCE: v4-x4YngIZN1-8/transcript] |
| Shakir | Mystic | Lupine's Aura gives 4% bonus ATK per 4 SP per ally; meta in Nocturne Judicator [SOURCE: v4-x4YngIZN1-8/transcript] |
| Barrel | Insight | Meta in 3–4 of 8 Dream Realm bosses; high priority if built [SOURCE: v4-x4YngIZN1-8/transcript] |
| Smokey | Recovering / Sorcery | SP increases attack buff aura up to 4% per 4 SP [SOURCE: v4-x4YngIZN1-8/transcript] |
| Pandora | Blast | Ultimate Power scales HP loss ultimate (20% per tick × 10 ticks = 200% total) [SOURCE: v4-x4YngIZN1-8/transcript] |
| Twins (Elijah & Lailah) | Sorcery | Present in ~7/8 Dream Realm boss top teams [SOURCE: v3-48SNAAhcKLk/transcript] |
| Huroc | Butcher (or Balanced) | Butcher slightly better overall; Balanced wins on specific bosses [SOURCE: v4-x4YngIZN1-8/transcript] |
| Tossi | Blast | Ultimate Power prolongs CC (sleep) duration; major priority for AFK stages [SOURCE: v4-x4YngIZN1-8/transcript] |
| Ferostro | Sorcery (no set required) | HP-per-second Vicious Sting not affected by SP; just upgrading to Mythic+ for raw stats is sufficient [SOURCE: v4-x4YngIZN1-8/transcript] |
| Hugan | Mystic (preferred) or Blast | Mystic better when ally stays on Mechanized Bond tile [SOURCE: 07-ldshop-mythic-charm-priority] |

### Endgame Relevance

After reaching Supreme+, refining Mythic Charms is the primary performance-optimization loop for Dream Realm. Dream Realm ranking determines access to Temporal Essence and Stargazer Orbs. The seasonal charm reset creates a recurring endgame loop of re-crafting and re-refining charms every 4 months. Veterans recommend using content creator videos, wiki, and Discord to track optimal charm priorities rather than figuring them out independently. [SOURCE: 07-ldshop-mythic-charm-priority] [SOURCE: 42-reddit-mythic-charms-pvp-afk-dream] [SOURCE: 03-steam-community-reviews]

---

## 9. D1–D30 Player Journey

### Day 1: First Session

The player lands in Esperia as Merlin and completes a combat tutorial that introduces auto-battle, hero classes, and the Ultimate ability trigger. The game's art and voice acting make an immediate strong first impression. [SOURCE: analysis_pack.md]

> "Easy to pick up. There's the story portion and the stages portion. Battles are auto. Party management is a delight." — review with 339 thumbs-up (2024-03-27) [SOURCE: analysis_pack.md]

Heroes obtained: Chippy and Hammie (Rare tier, cannot be ascended) plus several A-level and S-level heroes from starter pulls. [SOURCE: 17-fandom-hero] The Resonating Hall tutorial introduces the Hands of Resonance mechanic — the moment players realize they don't need to level every hero is cited as a major satisfaction moment. [SOURCE: analysis_pack.md]

First pulls introduce the gacha system and wishlist. The All-Hero Recruitment wishlist unlocks after 30 pulls. Early free currency provides several pulls immediately. [SOURCE: 06-bluestacks-beginners]

### Day 2–3: Early Hooks

AFK idle collection rhythm establishes itself: players check in, collect accumulated gold/XP/diamonds, set up the next AFK stage fight. [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

Story quest progression drives world map exploration. Puzzles begin appearing. The map's open-world feel with visible biomes and enemy camps creates discovery momentum. Equipment begins dropping and the class-based upgrade system (Weapon, Gloves, Accessory, Helm, Armor, Boots) becomes the second major system players interact with. [SOURCE: 05-afkguide-beginners]

> "Game is very f2p friendly with the amount of rewards you can get by just simply progressing with 0 grind. Manage to get a lot of S tier characters in less than a week." — review with 259 thumbs-up (2024-12-28) [SOURCE: analysis_pack.md]

### Day 4–7: First Week — Faction Discovery and First Wall

Team composition discovery begins as more heroes accumulate. Players experiment with faction bonuses (3-faction core) and begin to understand the strength cycle. [SOURCE: 16-fandom-faction]

The Hero Essence bottleneck is typically hit around Resonance Level 110–120. [SOURCE: v2-0mb9XIFjFG4/transcript.md] This is the first major progression gate:

> "you hit the hero essence bottleneck way too quick, after that it's like every other single gatcha game out there." — review with 115 thumbs-up (2024-04-17) [SOURCE: analysis_pack.md]

Level disparities in open-world areas become apparent — areas are "recommended for lvl 120, but the enemies in these areas are lvl 180+." [SOURCE: analysis_pack.md] Players who try to push ahead of their resonance level hit hard walls.

Server assignment was noted as a point of friction at launch — players may be placed in a server with a different primary language. [SOURCE: analysis_pack.md]

### Day 8–14: Second Week — Mode Unlocking and Daily Routine

Arena becomes accessible and begins providing Arena Tickets daily (5 free). The daily check-in rhythm solidifies around: idle collect → AFK Stage push → Dream Realm → Arena → resource spend. [SOURCE: 12-fandom-arena]

Ascension system engagement begins as duplicate heroes accumulate from pulls. The gap between A-level and S-level ascension costs becomes apparent (A-level requires 64 copies total; S-level only 8). [SOURCE: 10-lootbar-ascension-guide]

Guild recruitment typically occurs in this window, unlocking Battle Drills. [SOURCE: 03-steam-community-reviews]

Formation placement tips are notably absent from the tutorial, and players report feeling confused about tile board positioning: "the tutorials isn't detailed enough. There are no in-game tips for ally placement in the tiles, formations." [SOURCE: analysis_pack.md]

### Day 15–21: Third Week — First "Stuck" Moments and Gacha Pressure

Story progression slows as the Resonance Level bottleneck becomes a hard gate. Players who have cleared accessible content face the "nothing to do besides dailies" feeling if they completed the season story arc early. [SOURCE: 50-reddit-what-happened-game]

Gacha pressure increases as players identify which S-tier heroes they want for their optimal team and realize the true per-pull odds (~0.726% on standard banner) make non-pity pulls rare. [SOURCE: 52-reddit-gacha-rates-not-accurate]

Honor Duel may become accessible around this time, offering a fair-play PvP alternative that is explicitly not pay-to-win. [SOURCE: 18-fandom-honor-duel] [SOURCE: 37-reddit-honor-duel-relic-tier]

### Day 22–30: First Month — Endgame Horizon

Players approaching Resonance Level 240 encounter the game's second major gate. Upon reaching 240, equipment upgrades to maximum level and Resonance Synergy unlocks. [SOURCE: v2-0mb9XIFjFG4/ANALYSIS.md]

For players who joined at season start, Season content becomes accessible (requires AFK Stage 1125 completion and Resonance Level 240). Supreme Arena unlocks at Season AFK Stage 130. [SOURCE: 23-fandom-season] [SOURCE: 25-fandom-supreme-arena]

Hero Focus (unlocked at Legendary+) and the first Exclusive Equipment upgrades (unlocked at Mythic+) become relevant. Temporal Essence scarcity becomes apparent as a long-term planning constraint. [SOURCE: 10-lootbar-ascension-guide]

By day 30, players are either deeply embedded in the daily loop (Dream Realm, Arena, Supreme Arena, guilds) or have churned due to the paywall or content pacing frustrations. [SOURCE: analysis_pack.md]

---

## 10. Why Players Love It / Why They Come Back

### Top Love Signals (with verbatim citations)

**Resonating Hall innovation:**
> "you only need to level up 5 heroes and get equipment for the 6 types of heroes once, and that automatically applies to all of them. The map is full of rewards you aren't required to get." — 524 thumbs-up [SOURCE: analysis_pack.md]

**Art, music, voice acting:**
> "I don't know how to fully express how much I've enjoyed this game the past month. My biggest praise goes to the art direction and music." — 173 thumbs-up (2025-09-18) [SOURCE: analysis_pack.md]

**F2P perception at launch:**
> "I had the preconceived idea that this was going to be another cash grab... But surprisingly, this gotta be the most f2p friendly game in this genre I have ever played." — 187 thumbs-up (2024-03-31) [SOURCE: analysis_pack.md]

**Story depth:**
> "this is the only game I played more than a month it's story is excellent." — 5-star review (2026-05-30) [SOURCE: analysis_pack.md]

**No forced ads:**
> "They never force you to watch ads and there are no ads for bonuses." — 196 thumbs-up [SOURCE: analysis_pack.md]

### Retention Hooks

1. **AFK idle collection:** Passive rewards accumulate while offline, creating a daily "harvest" moment. This is the core returning hook that persists even when other content is exhausted. [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

2. **Story beats:** The episodic seasonal story structure keeps players progressing through narrative beats. Story quality is the #1 stated reason returning players cite for continued engagement. [SOURCE: 50-reddit-what-happened-game]

3. **Open world exploration:** Hidden puzzles, chests, and treasures generate ongoing exploration motivation. A megathread for puzzle solutions attracted community engagement spanning May 2024 through July 2025. [SOURCE: 53-reddit-megathread-puzzle-solutions]

4. **Seasonal reset dopamine:** Seasonal reset provides a fast-progression dopamine re-hit every ~4 months, mimicking the onboarding rush. [SOURCE: 50-reddit-what-happened-game]

5. **Collaboration events:** Frieren collab drove a spike of 171 reviews in May 2026 (vs ~40/month baseline) and a MAU bounce to 844,317. Players explicitly reinstall for collabs. [SOURCE: analysis_pack.md]

6. **Dream Realm daily ranking:** Competitive daily ranking with real resource consequences (Temporal Essence). [SOURCE: 47-reddit-temporal-essence]

7. **Guild social retention:** Guilds create interpersonal commitment; Battle Drills create shared cooperative goals. [SOURCE: 03-steam-community-reviews]

### Session Design

Short sessions are possible (5–10 minutes of dailies for veteran players), but meaningful progression and competitive positioning require more active play. [SOURCE: 50-reddit-what-happened-game]

---

## 11. Why Players Quit / Frustrations

### Top Complaints (with verbatim citations)

**#1 Most-liked 1-star review (405 thumbs-up):**
> "there comes a point when the only thing that you can do to progress is wait and collect the afk rewards until you can progress. It is very annoying, lame." (2024-04-11) [SOURCE: analysis_pack.md]

**Season reward nerf (May 2024, triggered mass negative shift):**
> "After the latest Season update the game has become incredibly restricting, there's no sufficient xp books, no diamonds like before... Starting to become P2W even in casual gameplay." — 161 thumbs-up (2024-05-12) [SOURCE: analysis_pack.md]

**"Not really AFK":**
> "The only critique is that this game is not an afk game. You got to be actively playing it to make progress." — noted even in a 5-star review (387 thumbs-up) [SOURCE: analysis_pack.md]

**Long-term P2W trajectory (2026):**
> "Update, prev. 4 stars. Their greed is unmeasurable. The game is done for me. Endless upgrading of one hero which will be dethroned even before you build them fully. They are removing F2P friendly events from the game completely." — 188 thumbs-up (2026-05-26) [SOURCE: analysis_pack.md]

**MTX pricing:**
> "the cheap 3 to 5 dollar buys in other games are not found here." — 243 thumbs-up (2024-05-05) [SOURCE: analysis_pack.md]

**Cosmetic paywall:**
> "all the best character cosmetics are still locked behind some very pricey paywalls. You cant really make your avatar look super cool unless you spend $$$." — 237 thumbs-up (2025-05-01) [SOURCE: analysis_pack.md]

**Intrusive push notifications:**
> "the game has started leaving voicemails about in game events on my phone. That's not appropriate at all." — 230 thumbs-up (2024-05-18) [SOURCE: analysis_pack.md]

**Open world linearity:**
> "The promised open world is nothing more than a long tube and exploration is 90% clicking on auto run until you are at your target." — 164 thumbs-up (2024-05-12) [SOURCE: analysis_pack.md]

**Steam-specific issue:** PC performance degrades severely when alt-tabbed, consuming excessive RAM. No "exit to desktop" option. Account linking problems at Steam launch. [SOURCE: 03-steam-community-reviews]

### Paywall Structure

The paywall is layered with increasing severity:
1. **D1–D7:** Feels very F2P friendly; rewards flow easily.
2. **~Level 110–120:** Hero Essence bottleneck first major gate. [SOURCE: v2-0mb9XIFjFG4/transcript.md]
3. **Resonance Level 240:** Second gate; progress slows without Supreme+ heroes.
4. **EX weapon +11+:** Temporal Essence scarcity becomes the hard budget constraint. [SOURCE: 47-reddit-temporal-essence]
5. **Top-ranked competitive play:** Dominated by spenders; Paragon stat inflation makes casual competitive play a stat check. [SOURCE: 03-steam-community-reviews]

---

## 12. Business Model & Market Performance

### Revenue (Sensor Tower, March 2024 – May 2026)

- **Total lifetime revenue (iOS + Android):** $158,194,590 USD [SOURCE: 54-sensortower-afk-journey-metrics]
- **Peak revenue month:** August 2024 — iOS ~$13.85M, Android ~$11.42M (aligns with Season 1 Song of Strife launch, not game launch) [SOURCE: 54-sensortower-afk-journey-metrics]
- **May 2026 revenue:** iOS ~$898,690, Android ~$800,104 (combined ~$1.7M; Frieren-collab boosted, roughly 2x prior months) [SOURCE: 54-sensortower-afk-journey-metrics]
- **iOS vs. Android split:** iOS contributed $88.3M (55.8%), Android $69.9M (44.2%), despite Android having ~9.5x more downloads (7.59M vs. 798K) [SOURCE: 54-sensortower-afk-journey-metrics]

### Downloads

- **Total lifetime downloads (iOS + Android):** 8,392,771
- **iOS:** 798,619 | **Android:** 7,594,152
- **Top markets:** US, Korea, Japan (iOS); US, Korea, Brazil (Android) [SOURCE: 54-sensortower-afk-journey-metrics]

### Monthly Active Users (MAU)

| Period | Combined MAU | Notes |
|---|---|---|
| April 2024 (peak) | 3,223,774 | Launch month |
| July 2024 (trough) | 1,174,698 | Pre-season content drought |
| August 2024 (bounce) | 2,714,699 | Season 1 launch reactivation |
| September 2024 | 2,132,491 | Post-launch decay begins |
| April 2026 | 646,920 | Steady decline |
| May 2026 | 844,317 | Frieren collab bounce |

[SOURCE: 54-sensortower-afk-journey-metrics]

**MAU retention ratio:** May 2026 (844,317) = 26.2% of April 2024 peak (3,223,774). [ASSUMED — calculated from SOURCE: 54-sensortower-afk-journey-metrics]

Seasons function as confirmed strong retention/reactivation events: August 2024 bounce (Season 1) nearly matched launch peak; Season 1 launch was also peak revenue month. [SOURCE: 54-sensortower-afk-journey-metrics]

### App Store Ratings

- **iOS global average:** 4.83 (274,310 ratings); US distribution: 91.2% five-star, 2.1% one-star
- **Android global average:** 4.55 (296,381 ratings); US distribution: 79.4% five-star, 6.0% one-star [SOURCE: 54-sensortower-afk-journey-metrics]
- **Scraped text-review pool average:** 3.37 (3,161 reviews) — bimodal distribution: 39.2% five-star, 22.0% one-star, 12.2% three-star. This gap reflects selection bias in text reviewers (motivated to write, disproportionately frustrated). [SOURCE: analysis_pack.md]

### Steam (April 27, 2026 launch)

- **Overall:** 78% positive (Mostly Positive) out of 605 reviews [SOURCE: 03-steam-community-reviews]
- **Recent:** 74% positive (249 reviews) [SOURCE: 03-steam-community-reviews]
- **Key friction:** Account linking issues, RAM/performance on PC, no exit-to-desktop button [SOURCE: 03-steam-community-reviews]

### Monetization Mechanics

Primary monetization levers:
1. **Diamonds** (pull currency) — primary spend; pulls available at 270 Diamonds/10x standard or 300 single rate-up
2. **Noble Path** (battle pass) — recommended as best-value light spend
3. **Temporal Essence packs** — community considers poor value vs. diamonds
4. **Growth packs** — reported at ~46 AUD per pack; community called out as predatory
5. **Velvet Store** (cosmetics) — cosmetics only; does not affect gameplay power
6. **Stargazer banner pulls** — reported at ~$100 for 20 pulls [SOURCE: 30-reddit-pull-rates-scam] [SOURCE: 41-reddit-always-hit-pities]

---

## 13. Visual Design & VFX

### Art Style

Painterly cel-shaded 3D with storybook/Ghibli influences. Soft-focus backgrounds, richly colored characters, exaggerated proportions with large expressive eyes. Inspired by church stained glass: bold color blocks, striking contrasts, distinct outlines. [SOURCE: 01-wikipedia-afk-journey] [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

**Color branding:** Warm amber/gold and teal/cyan as primary contrast pair throughout all modes. Faction accent colors: purple (Graveborn), red-orange (Mauler), green (Wilder), blue (Lightbearer). [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

**UI palette:** Cream/parchment aesthetic, rounded corners, serif decorative titles, green buttons for primary actions, orange/gold for secondary. Victory screens use warm orange gradient. Resonance Hall uses deep gold/brown ornate architectural backdrop. [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

### Environment Types (Observed)

- **Vaduso Mountains:** Sandy ruins, desert aesthetic, coordinates system (387,323; 625,303) [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]
- **Oblivion Valley:** Green forest (113,74) [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]
- **Dream Realm Arena:** Teal seafoam floor tiles, yellow/gold cubic rock formations, teal stone arch columns [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]
- **Holy Temple Cave (Elite Challenge):** Dark stone colosseum, purple torch lighting [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

### Skill VFX Catalog (Observed)

| VFX Name | Description |
|---|---|
| Golden Ring AoE | ~4 hero-widths buff/heal area indicator |
| Blue Energy Beam | Narrow plasma column, ranged single-target |
| Full-Screen Teal Downpour | Entire arena flooded with vertical teal light columns; hero in protective bubble = ultimate-tier |
| Purple/Red Crescent Moon | Rotating ring covering mid-field |
| Lightning Crackle Ring | Blue-white lightning from yellow ground circle, screen darkens, large AoE |
| Orange Fire Explosion | Warm burst with particle sparks |
| Cyan Ice/Water Radial Wave | Full-screen, arc brushstroke texture |
| Golden Pillar Level-Up | Three vertical gold pillars |
| White Star Burst | Tight sparkle, basic crit or short-range hit |
| Life Drain Loop | Gold/orange orbiting tendril (vampiric) |
| Phys Immunity Shield | Blue ring on boss, 'Phys Immunity' green text, physical damage blocked |
| Lightning Column Rain | 4–5 simultaneous white-blue vertical beam strikes from above |
| Red Concentric Sweep | Large red orbital ring, white impact burst |
| Golden Starburst/Torus | Wide gold ring with starburst |

[SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

**High-magnitude ability moments** show full-screen VFX saturation with heavy camera shake — visible in frames f_00017, f_00033, f_00103, f_00157. [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

### Damage Number Color System

| Color | Meaning |
|---|---|
| Green (+NNK) | Heals (e.g., +137K, +358K, +447K) |
| Yellow/Gold (NNN) | Normal hits or chain combos |
| Purple (+NNNNN) | Critical hits (e.g., +63,365) |
| Blue (+NNNK) | Magic ability damage (e.g., +293K) |
| Red (NNNNN) | Damage received or low hits |

[SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

### Faction Color Coding on Hero Cards

| Dot color | Faction |
|---|---|
| Blue circle | Lightbearer |
| Green circle | Wilder |
| Red/Orange circle | Mauler |
| Purple circle | Graveborn |
| Teal/Cyan | Celestial |

[SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

### UI Screen Catalog

- **Resonating Hall:** Deep gold/brown ornate architectural backdrop; Resonance Level displayed as horizontal pill banner; 5 Hands of Resonance heroes shown at their levels; grid of all other heroes shown at synchronized level [SOURCE: v1-f2-9q0wgfOY/ANALYSIS] [SOURCE: v2-0mb9XIFjFG4/ANALYSIS.md]
- **Equipment Screen:** Class label (e.g., 'Warrior Equipment'); Equipment Level shown; 6 slot icons in tray; stats displayed: ATK, DEF (Phys and Magic), Haste, Healing, Power [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]
- **Auto-Battle HUD:** Top-center: location name + coordinates; top-right: countdown timer + gold count; bottom: hero bar with 4–5 portrait icons + energy indicator; controls: pause, x2 speed, settings gear; left-edge green energy charge bar [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]
- **Victory Screen — Two variants:** (1) Full-party: 4 heroes walking in procession, orange gradient, rewards listed; (2) Hero-highlight: single hero art, class badge with colored letter + two-word title (e.g., 'Talented Tank', 'Hotshot Healer') [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]
- **AFK Idle Collection Screen:** AFK duration shown (3h43m observed), accumulated resources (7k gold, 203 diamonds, 30k XP), 'Instant' button (2/2 uses) and 'Collect' button [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]
- **World Map:** Hex grid with (X,Y) coordinate system; enemy level brackets visible before engagement; pre-battle team selection panel slides up from bottom [SOURCE: v1-f2-9q0wgfOY/ANALYSIS]

---

*Document compiled from 54 research sources including fandom wiki pages, Reddit community threads, Sensor Tower market data, Google Play review scrapes, YouTube video frame analysis, lootbar guides, and official Farlight patch notes. All claims are tagged [SOURCE:] or [ASSUMED]. Research date range: 2024-03-27 through 2026-06-11.*
