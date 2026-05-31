# Wittle Defender — Game Design Documentation

**Researcher:** Tarun (Lila Games, PM/founder)
**Compiled:** 2026-04-27
**Subject:** Wittle Defender (Habby) — Android package `com.game.kingrush`, iOS available
**Soft launch:** ~April 2025 (beta) → Global launch June 2025 → 2026-04 still actively updated (v2.0.0 / 1-yr anniversary)

---

## Source Tagging Conventions

This document is built from 20 web sources (verbatim-scraped), 14 YouTube videos, 2,099 Play Store reviews, and 1 user-supplied tier list image. Every claim is tagged so you can trust its provenance.

| Tag | Meaning | Strength |
| --- | --- | --- |
| **[Source: <provider>]** | Directly stated in scraped content (creator, blog, review, in-game UI screenshot OCR) | High |
| **[Cross-confirmed]** | Stated by ≥2 independent sources | Highest |
| **[Inferred]** | My deduction from indirect signals — not stated, but supported by data | Medium |
| **[Assumed]** | Industry-norm assumption based on Habby genre conventions, not in any source | Low — verify before betting on |
| **[Gap]** | Information explicitly missing from corpus | — |

Source shorthand:
- **iPICK1** = iPICKmyBUTT "Global Launch BEGINNER GUIDE" (2025-06-06; `t7w4ocrEnS8`)
- **iPICK2** = iPICKmyBUTT "ADVANCED Beginner Guide" (2025-08-17; `gOlZWwa95Pw`)
- **PlayMe1** = PlayMe "Ultimate Beginner Guide" (2025-06-09; `MHDTR0XPLEc`)
- **PlayMe2** = PlayMe "Hero Positions & Strategies" (2025-06-22; `XlwBjn-2v0g`)
- **IronJosh** = IronJosh300 "F2P Guide" (2026-02-05; `UrXWdIQE2iQ`)
- **KruMobile** = KruMobile silent walkthrough series (Pts 1–9; chapter biome names confirmed)
- **Segwise** = Segwise creative analysis blog (2025-06-17)
- **AllClash** / **LDPlayer** / **PocketGamer** / **Theria** / **wd-com** = the corresponding scraped guide site
- **Reviews** = Google Play Store review corpus (n=2,099, avg 3.84★)
- **TierImg** = user-provided "High-End Tier List - Week of Mar 10th" image

---

## 1. Executive Summary

Wittle Defender is a **gacha-driven hybrid auto-battler / tower-defense / roguelike skill-draft hero collector** developed and published by Habby (the Archero / Capybara Go! studio). [Source: Segwise; iPICK1] Players assemble a team of 5 chibi-style heroes, deploy them in fixed positional slots in an arena defense scenario, and survive 20 waves per chapter while drafting roguelike skill upgrades for each hero in real time. [Source: iPICK1; PlayMe2; KruMobile OCR]

**Genre identity:** "Vampire Survivors meets tower defense with a card-strategy layer." [Source: 3★ Reviews; Segwise]

**Commercial performance:**
- **$1.4M IAP revenue + 1.3M+ downloads in <30 days post-launch** [Source: Segwise, June 2025 data]
- Habby spent ~50% UA on YouTube, 17% AppLovin, 14% Facebook, 10% TikTok [Source: Segwise]
- "East-first" geo strategy: Singapore 48% / South Korea 15% / Hong Kong 10% / Taiwan 6% / West 21% of UA spend [Source: Segwise]
- Play Store rating polarized: **3.84★ average across 2,099 reviews — 59.5% 5★ vs 18.8% 1★** [Source: Reviews aggregates.json]
- Review volume peaked **Jun 2025: 796 reviews** (global launch month), then steady decay to 26–48/month by Q1 2026 — characteristic UA-driven review curve [Source: Reviews monthly distribution]

**Core thesis:** A polished, low-skill-floor / high-investment-ceiling collector that sells progression speed-ups to whales while serving F2P a generous-feeling early arc that hooks for ~7–14 days before the spend wall escalates aggressively. [Inferred from: review polarization + iPICK1 self-reported $842/2mo + multiple reviews citing $1K–$5K spend]

---

## 2. Core Gameplay Loop

### 2.1 The match (a single chapter / "stage")

A match is a **20-wave timed arena defense run on a fixed circular battlefield**. [Source: KruMobile OCR; iPICK1]

```
┌─────────────────────────────────────────────────────┐
│ Pre-battle: select up to 5 heroes (mandatory order) │
│   1st pick → CENTER                                  │
│   2nd      → BOTTOM RIGHT                            │
│   3rd      → BOTTOM LEFT                             │
│   4th      → TOP RIGHT                               │
│   5th      → TOP LEFT                                │
│ [Source: iPICK1, PlayMe2; cross-confirmed]           │
├─────────────────────────────────────────────────────┤
│ Battle starts: 2 heroes deployed initially           │
│ XP bar fills as waves clear (multiplier scales       │
│ with #heroes deployed). Reach milestone → unlock    │
│ next slot. Progressively reach all 5.               │
│ [Source: iPICK1]                                     │
├─────────────────────────────────────────────────────┤
│ Wave 1–9:  trash mobs                                │
│ Wave 10:   first boss                                │
│ Wave 11–14: trash                                    │
│ Wave 15:   mid-boss                                  │
│ Wave 16–19: trash                                    │
│ Wave 20:   final boss → chapter complete             │
│ [Source: iPICK1; cross-confirmed by KruMobile OCR]   │
├─────────────────────────────────────────────────────┤
│ Per-hero level: 1 → 12 in-run via skill drafts       │
│ Battle hard-cap level: 20 (combined draws)          │
│ [Source: iPICK1; PlayMe2 confirms lvl 20 cap]        │
└─────────────────────────────────────────────────────┘
```

### 2.2 The roguelike skill draft (the "fun core")

This is the loop's **headliner mechanic**. After each wave (or at level-up triggers), players are presented with a **3-card skill draft** per active hero. [Source: KruMobile OCR — "Select a skill" modal; iPICK1; PlayMe1]

**Skill rarity tiers** [Source: iPICK1; cross-confirmed PlayMe1]:
- **Rare** (1 diamond) — common
- **Epic** (3 diamonds) — earned by stacking 3 matching Rares of a hero
- **Locked legendary** — weapon and outfit-driven [Source: iPICK2]

**"Chest skills"** are a separate skill source layered on top of level-up draws — typically lower-quality / variance pool. [Source: PlayMe2; KruMobile OCR shows distinct chest-pickup events]

**Roll/Reroll** mechanic with limited charges: players can re-spin a draft. [Source: PlayMe2]

**Force-close re-roll exploit** [Source: iPICK2]: closing the app on the third draft attempt forces a reroll without consuming the run — works on Golden Rat Hole, Goblin Ground, Voyage. **This is a known and unpatched bug** as of Aug 2025.

### 2.3 Chain Skills

When two heroes of the same element are deployed, a chain icon appears on their portrait, and a **chain-skill** activates as a passive team buff (does NOT level the heroes themselves). [Source: iPICK1; cross-confirmed Theria, wd-com, AllClash]

Confirmed pairings:
- **Ice Queen + Ice Demon → "Icicle Storm"** [Source: wd-com; Theria]
- **Demon Spawn + Blazing Archer → "Burning Ground"** [Source: wd-com]
- **Cat Assassin → wind-resistance reduction (debuff)** synergizes with Sword Saint [Source: iPICK2]
- **Blazing Archer crit-damage passive → buffs Sword Saint** [Source: iPICK2]

### 2.4 Elements & matchups

**4 elements** [Source: iPICK1, cross-confirmed all sources]: **Ice, Fire, Wind, Electro/Lightning**

Bosses have explicit **elemental weaknesses + element-buffs** — sometimes a boss self-buffs to negate a specific element's damage. [Source: iPICK1] The Boss Challenge (daily) leans heavily into this — players run mono-element teams to counter the day's boss. [Source: iPICK1]

A **5th class designation** ("Sublime" / Xenoscape) sits above element categorization — these are tier-locked premium heroes. [Source: PlayMe1; iPICK2]

### 2.5 Devil's Offer

**Mid-run risk/reward proc**: the game offers a powerful skill or stat boost in exchange for some negative side-effect. [Source: PlayMe1] Recommendation: **always accept unless you have no healer.** [Source: PlayMe1]

[Inferred] Likely a debuff-for-buff mechanic — penalizes survivability for damage. [Assumed] Could also gate behind ad-watches or gem cost; no source confirms.

### 2.6 In-battle Pacing & Speed

- **3x speed = bugged/broken**: deals less actual damage than 1x speed. Meta is **3x for trash, 1x for bosses**. [Source: iPICK2 — "broken for so long"]
- A match runs ~5 minutes at default speed. [Inferred from creator's "20–25 min/day for full daily routine" and 4–6 daily challenge runs + boss + 1 chapter]

---

## 3. Meta Progression Systems

This game has **at least 8 stacked progression vectors**. The depth (and the source of monetization pressure) is in the system count, not any single system's depth.

### 3.1 Hero Roster

**Rarity ladder (low → high)** [Cross-confirmed iPICK1, PlayMe1, AllClash]:
1. **Common / Rare** — basic
2. **Epic** — early useful units
3. **Legendary** — long-tail strong (e.g. Saraf, Ice Witch)
4. **Mythic** — flagship pulls
5. **Sublime / Xenoscape** — premium endgame tier
6. **Immortal** — added in a 2025 update; mythic→immortal evolution path [Source: iPICK1]

**Star Level (intra-hero progression)** [Source: iPICK1]:
- 20 visual tiers: Stars → Moons → Diamonds → Prismatic Star (final)
- Upgrade path: spend **duplicate hero copies + Elemental Essence** of matching element
- High-star upgrades require **both duplicates AND essence simultaneously**
- All deployed heroes must stay within **±10 levels** of each other (caps swap-in flexibility)

**Hero Level (slot-based)** [Source: iPICK1; reviews praise]:
- Range: 1–12 (in-run) and meta-level up to 200 [Source: IronJosh — "all heroes lvl 200" gate for Pantheon]
- **CRITICAL DESIGN: You upgrade SLOTS, not heroes.** [Source: iPICK1; wd-com; cross-confirmed by viral 5★ review with 53 upvotes: *"You don't upgrade the characters, you upgrade the slot. This is hands down one of the best things a gacha game can have."*]
- This means swapping heroes into an upgraded slot inherits the level — protects players from regret on misplaced investment.
- **Promotion Stones** required every 10 levels [Source: iPICK1] — described as the **#1 progression bottleneck**
- Hero EXP (between 10-level breakpoints) is plentiful and rarely the limiter

**Hero archetypes by combat role** [Source: PlayMe2; iPICK2]:
- **Healers** (Saraf, Sheffy, Cheffy, Seraph) → middle/back row
- **Mages / supporters** (Ice Demon, Ice Witch, Fire Mage) → mid-back
- **Rangers / fighters** (Sword Saint, Blazing Archer, Cat Assassin) → front (die first)
- **Tanks/summoners** (Ice Demon trolls, Pyro Servant) → aggro distraction

### 3.2 Gear

**Six-slot equipment per hero.** [Source: iPICK1; cross-confirmed Theria, PlayMe1]
- Stats: ATK / HP / DEF
- Rarity tiers + star levels per piece
- **CANNOT FUSE GEARS.** [Source: PlayMe1; cross-confirmed Theria]
- "Equip All" auto-optimizer button [Source: iPICK1]
- **Salvage** unwanted gear → currency for slot enhancement [Source: PlayMe1]
- Two upgrade tracks per slot:
  - **Level** (right number) → uses **Enhanced Sight** material
  - **Refine** (left number) → uses **Azure Essence**
  - Both capped by your account/player level [Source: iPICK1; Theria]
- Slot-not-gear enhancement [Source: PlayMe1] — same design ethos as hero slots

### 3.3 Treasures (Sets, distinct from gear)

**Six-slot treasure system per hero.** [Source: iPICK1]
- **CAN FUSE** treasures (opposite of gear) [Source: PlayMe1; cross-confirmed Theria]
- Rarity tiers: Common → Epic → Legendary → **Mythic** (whale-only) [Source: PlayMe1; iPICK1]
- Each rarity tier unlocks an **additional skill on the hero** [Source: PlayMe1]
- Pulled with **Hammers** (common/rare/epic) [Source: iPICK1]
- Three banners: Common Treasure, Rare Treasure, **Ancient Treasure** (gem-cost, better odds for epic) [Source: iPICK1]
- During raid-up events: **Guaranteed-Up Treasures** banner [Source: iPICK1]
- F2P recommendation: **stop investing at Legendary quality** — Mythic is whale territory [Source: PlayMe1]
- Two "skill version" treasures per hero (e.g. Ice Demon "Initial Summons" treasure) preferred over raw stat versions at Mythic tier [Source: iPICK2]

### 3.4 Runes

**Six-slot rune system per hero, layered on top of gear and treasures.** [Source: PlayMe1; iPICK2]

Rune set bonuses [Source: iPICK2]:
- **Divine Revival** (2pc each) → 10% cooldown reduction; **stacking 6 = \~22% reduction** (vs 13% for 4+2 split) — exploit
- **Unshaken Will** (4pc) → bonus damage when DPS > 30% HP
- **Elusive Fury** → crit rate (skip on Robot — has built-in 100% crit skill)
- **Divine Grace** (4pc) → +healing to all allies (for healers)
- **Blood Rage Slam** → bonus damage [Source: IronJosh]

**Slot semantics** [Source: iPICK2]:
- Slot 1 → fixed ATK main stat
- Slot 2 → fixed DEF main stat
- Slot 3 → fixed HP main stat
- Slot 4/5/6 → **variable main stat** (the "real choice" slots)

**Acquisition** [Source: PlayMe1; IronJosh]:
- Different challenge modes drop different rune types
- Higher difficulty drops more **but** lower difficulty allows more wave clears in 2-min timer (sometimes higher reward) — non-monotonic optimum
- **Manual equip strongly recommended**; auto-equip produces inferior set effects [Source: PlayMe1]
- Salvage runes → **Rune Powder** (separate currency)
- Powder upgrades **the rune itself** (not the slot) — opposite of gear

**Endgame**: rune farming happens in **Runic Plains**; sublime-tier runes are the cap [Source: iPICK2; IronJosh]

### 3.5 Weapons & Glyphs (added post-launch)

**New system added between June and August 2025.** [Source: iPICK2 — "newly added", "originally polluted skill pool, now auto-grant"]

- One weapon per hero, leveled with **Glyphs**:
  - **Silver glyphs** → lvl 1–10
  - **Gold glyphs** → lvl 10–30
  - **Element-specific glyphs** (Ice / Fire / Wind / Lightning) → lvl 30–50 [Source: iPICK2]
- Glyphs farmed in **Elemental Trials** (one per element) [Source: iPICK2]
- **Hellvoid Slash** named as Demon Spawn's weapon skill, level 20 unlock [Source: IronJosh]

### 3.6 Statues (newest system, Aug 2025)

**The most recent meta-progression layer.** [Source: iPICK2 — "Probably one of the newest things"]
- Upgrade meter unlocks **higher-rarity skills + more presets**
- Preset skill stats include: **Mage damage bonus, Wind damage bonus, Fighter damage bonus, Boss damage bonus**
- Multiple preset slots → swap loadouts per hero
- [Inferred] Reads as a "build templates" system to compete in different game modes without re-equipping runes/treasures

### 3.7 Talents

Per-hero talent tree, leveled with **Gold**. [Source: iPICK1] Gated by player level. iPICK1 reports it's quickly maxed and players sit on excess gold mid-game — [Inferred] talents are a soft progression pacing tool, not a long-tail sink.

### 3.8 Outfits / Skins (the whale hook)

**Outfits give passive +1% HP / ATK / DEF account-wide whether the hero is deployed or not.** [Source: iPICK2 — explicit]

- Acquired via **200 pulls** on a rate-up event
- **Stack multiplicatively across all heroes** [Inferred from "1% HP/ATK/DEF just for owning them"]
- iPICK creator: *"I'm a big believer of going and at least hitting that first 200 to get that outfit"* [Source: iPICK2]
- This is the single most powerful whale incentive — outfits create permanent compounding stat advantage that **cannot be matched by F2P play**, no matter how much grinding

---

## 4. Progression Systems Map (visual)

```
                  ┌─── Hero Pool (gacha) ──── stars 1–20
                  │      via duplicates + element essence
                  │
SLOT (1–5) ───────┼─── Hero Slot Level (1–200)
                  │      via Promotion Stones (every 10 levels)
                  │      + Hero EXP (between 10-level gates)
                  │
                  ├─── Gear (6 slots) — atk/hp/def
                  │      slot-level ↑ via Enhanced Sight
                  │      slot-refine ↑ via Azure Essence
                  │      cannot fuse; salvage for materials
                  │
                  ├─── Treasures (6 slots) — fusable
                  │      pulled via Hammers (common/rare/Ancient)
                  │      Common→Epic→Legendary→Mythic
                  │      each tier unlocks +1 skill
                  │
                  ├─── Runes (6 slots) — sets matter
                  │      Divine Revival / Unshaken Will / Elusive Fury / Divine Grace / Blood Rage Slam
                  │      farmed by mode (Runic Plains for sublime)
                  │      manual equip; rune-itself upgrade via Powder
                  │
                  ├─── Weapon — element-locked (Ice/Fire/Wind/Lightning)
                  │      Silver/Gold/Element glyphs to lvl 50
                  │      farmed in Elemental Trials
                  │
                  ├─── Statues — preset skill loadouts
                  │      mage / wind / fighter / boss damage bonus
                  │
                  └─── Talents (gold-only) — short tree, soft pacing

TEAM-WIDE LAYER:
  ├─ Outfits (per-hero, +1% HP/ATK/DEF account-wide; 200-pull each)
  ├─ Account/player level (gates many of the above caps)
  └─ Wishlist (configure pull priorities)
```

---

## 5. The D1–D7 Player Experience

### D1 — Onboarding (≈45–60 min first session)

[Source: iPICK1, PlayMe1, multiple Reviews] The first session funnels through:
1. **Tutorial chapter** (Frostbitten / Glacial Crown biome) [Source: KruMobile OCR — Stage 5 = Frostbitten Cavern]
2. Free starting heroes: Ice-themed roster [Inferred from cover art + ice-elemental tutorial chain — ★★★]
3. **First gacha 10x pull** — typically guaranteed Legendary or Mythic on 10x [Assumed; standard Habby pity behavior]
4. **Growth Path quest tracker** (bottom-left) gates feature unlocks step-by-step [Source: iPICK1]
5. First-time-user-experience offers (FTUE bundles): "Beginner Pack" — heavily promoted [Source: 2★ Review *"sunk about $50 into beginner packs"*]

**Player feels:** "Wow, charming chibi art, easy to pick up." [Source: dozens of 5★ reviews — top sentiments: "fun", "cute", "easy to understand", "smooth gameplay"]

**What unlocks D1:**
- Hero Summons tab
- Daily Quest list (7-day Carnival sign-in starts) [Source: iPICK1]
- First 2–3 chapters of campaign
- Black Market shop visible
- Mail
- Hero & Monster Galleries (free gem rewards on first unlock) [Source: iPICK1]
- Gear system **was** late-unlock pre-patch but moved earlier in updates [Source: iPICK1]

### D2 — Habit formation

The daily routine begins to form [Source: iPICK1 — "20–25 min/day with ad-free"]:

1. **Mail** → boss challenge rewards from yesterday
2. **Daily Sign-In** (7-day Carnival)
3. **Quick Patrol** AFK rewards [Source: iPICK1]
4. **Boss Challenge** (4 daily bosses with weekly rotation; element gimmicks) [Source: iPICK1]
5. **Golden Rat Hole** (gold + gems; mob style; 2 free blitzes + 1 paid) [Source: iPICK1]
6. **Goblin Ground** (hero EXP + gems; boss style; rerollable for skill perfection) [Source: iPICK1]
7. **Boar Hunt** (200xp/clear; difficulty up freely, down has 7-day cooldown) [Source: iPICK1, PlayMe1]
8. **Star Challenge** replays [Source: iPICK1]
9. **Abyss Crusade** floors (drops Hammers for Treasures) [Source: iPICK1]
10. **5x energy ad views** for free 25 energy [Source: iPICK1]
11. **Black Market gem-refresh shopping** (Goddess Water + discounted summon tickets at 210/240 gems) [Source: iPICK1]
12. **Discord gift code redemption** (auto-redeem buttons in #gift-code channel) [Source: PlayMe1, IronJosh]

**Energy economy** [Source: 4★ Review — heavily upvoted complaint]:
- Each match costs **5 energy**
- 1 energy regenerates every **13 minutes** (per review) or **20 min** (per another review)
- **5 energy = \~65 min wait** = 1 match per hour without ads
- This is the core retention timer — players check in throughout the day

### D3–D4 — Friction begins

[Source: Reviews + iPICK1 chapter difficulty curve]

Players hit the **first chapter wall** (commonly chapter 8–12). Symptoms:
- "Can't beat level 8/9/10" reviews ★1–★3 cluster here [Source: 2★ reviews]
- Star Challenge replay becomes the catch-up path [Source: PlayMe1: "if you cannot pass a chapter, play star challenges"]
- Players are nudged toward gear improvements / element matching

**The first paywall pulse:**
- Beginner Pack offers escalate
- "Ad-free for 30 days @ $9.99" surfaces aggressively [Source: 4★ Reviews — top complaint]
- Lifetime Privilege (one-time purchase) appears [Source: iPICK1]

### D5–D7 — The D7 fork

By D7, players sort into **3 cohorts** [Inferred from review sentiment + creator commentary + Habby genre data]:

**Cohort A: Engaged F2P (\~40% of D1 cohort)** [Assumed retention split; needs Habby-internal data to confirm]
- Joined Discord for codes
- Hit chapter ~20 in campaign
- Have figured out Boss Market currency loop
- Built first F2P-viable team (Demon Spawn + Parody + Sheffy) [Source: IronJosh]

**Cohort B: Light spender (\~10–15%)**
- Bought Beginner Pack ($1.99–$9.99)
- Maybe Premium Monthly ($9.99 ad-free + privileges)
- Pulled to first guaranteed Mythic at 100 [Source: iPICK1]

**Cohort C: Already-churned (\~45%+)**
- Primary churn drivers from review corpus:
  1. **Energy gating** (★4 review with 42 upvotes — "13 min for 1 energy is too much")
  2. **Predatory monetization** — most-upvoted ★1 themes
  3. **RNG skill draws** — "Even with a Legendary hero, RNG skills = zero chance" (★1, 56 upvotes)
  4. **Red-dot hell** — "More time clearing red dots than playing" (★4, 25 upvotes)
  5. **Repetitive daily routine** — Habby-formula fatigue

**The D7 "carnival close-out"** [Source: iPICK1 — "7-day carnival" mentioned multiple times]:
- 7-Day Carnival event ends → final big reward unlock (typically a guaranteed scroll bundle or summon ticket pack)
- Designed as a **D7 retention spike** — players who stuck it out get a tangible payoff
- Then a new event cycles in (Lunarite event, raid-up rotation, etc.)

---

## 6. What Players Like (sentiment from 1,249 5★ reviews)

Highest-frequency positive themes [Source: Reviews top 25 upvoted; corroborated by IronJosh, PlayMe, iPICK]:

1. **Cute chibi art / "super fun and very cute"** — most common positive descriptor
2. **Skill-drafting depth** — *"so many different level up combos"*; the roguelike layer is the headliner
3. **Slot-not-hero upgrade design** — *"hands down one of the best things a gacha game can have"* (53 upvotes)
4. **Casual-friendly / "good for killing time"** — broad audience signal
5. **Strategic chain-skill synergies** — "combining heroes can create chain effects"
6. **Habby's polish** — animations, music, sound effects called out positively
7. **No mandatory ads** — for the first ~week of play, ads feel optional [Source: 5★ 85-upvote review at week 1]
8. **Offline / low-connectivity play** [Source: 5★ "best offline game ever"]

---

## 7. Why Players Come Back (Retention Architecture)

The retention system has **5 stacked layers** designed to overlap and create non-stop reasons to log in:

### Layer 1: Daily Energy Drain
5 energy per chapter run, ~13–20 min/energy → players check in **multiple times per day** to spend energy. [Source: Reviews; iPICK1] This is the foundational cadence anchor.

### Layer 2: Daily Challenge Roster (~6 modes)
Each daily mode is **1–3 free runs + N gem-paid blitz** [Source: iPICK1]. The variety prevents "do my dailies in 5 min" boredom — each mode has a different optimal team and skill draft, and Boss Challenge rotates element gimmicks daily.

### Layer 3: Weekly Refresh Cadence
- **Summon Market refreshes weekly** [Source: PlayMe1]
- **Boar Hunt difficulty cooldown is 7 days** [Source: PlayMe1] → forces a weekly-paced commitment
- Boss Challenge has a weekly rotation [Inferred from 4-boss roster + refresh patterns]

### Layer 4: Time-Limited Events / Rate-Ups (~2–3 weeks per cycle)
[Source: iPICK2; IronJosh]
- **Raid-Up summons** — exclusive Mythic heroes obtainable only during the event window
- **Xenoscape banner** — Sublime tier; rotates separately
- **Lunarite events** — currency exchange for past rate-up hero runes
- **Limited Time Rushes**: Summon Rush, Keys Rush, Rune Rush, Treasure Rush, Adventure Quest, Fate Wheel — running concurrently
- "Always an event running" [Source: iPICK2]

### Layer 5: Long-Tail Endgame Gates
[Source: IronJosh; iPICK2; PlayMe1]
- **Pantheon** — gated by all deployed heroes reaching **lvl 200**
- **Runic Plains** — sublime-rune farming
- **Voyage** — extended chapter content
- **Guild Raid** — 3 daily attempts; force-close-reroll exploit; social retention
- **Mythic treasures** — multi-month grind for whales

### The "Red Dot Hell" Side Effect
A player complaint that's actually a deliberate design pattern: **every menu has unread/claimable indicators** [Source: 4★ Review with 25 upvotes — "more time clearing red dots than playing"]. This pushes players to traverse every tab daily — high engagement at the cost of perceived menu fatigue.

---

## 8. Unlock Timeline (when does feature X appear?)

Based on creator timing, growth-path mentions, review chapter callouts, and explicit gating statements [tagged per row]:

| Unlock | Approx. timing | Source |
| --- | --- | --- |
| First 2-hero deployment | Wave 0 of first match | Source: iPICK1 |
| 3rd / 4th / 5th deployment slot | Mid-to-late wave (XP-bar gated) | Source: iPICK1 |
| Hero Summon tab | D1 tutorial | Inferred — standard FTUE |
| Black Market shop | D1 tutorial | Source: iPICK1 |
| Daily Sign-In / 7-Day Carnival | D1 | Source: iPICK1 |
| Quick Patrol (AFK) | D1–D2 | Source: iPICK1 |
| Star Challenge mode | After clearing chapter 1–3 (best guess) | Inferred from "replay earlier chapters" |
| Boss Challenge | D2–D3 player level gate | Source: iPICK1 — daily |
| Golden Rat Hole / Goblin Ground / Boar Hunt | D2–D5 unlocked individually | Source: iPICK1 |
| Abyss Crusade | After meaningful campaign progress | Source: iPICK1 |
| Hero Star-Up (essence required) | When duplicates accumulate (~D4–D7) | Source: iPICK1 |
| Gear system | Was late, moved earlier in patch | Source: iPICK1 — explicit |
| Treasure system | Mid-tier player level (~D3–D5) | Inferred from currency drops |
| Rune system (Runic Plains) | Mid-game | Source: iPICK2 |
| Weapons system (post-launch added) | Mid-game | Source: iPICK2 |
| Statues system (newest) | Late mid-game | Source: iPICK2 |
| Voyage mode | Mid-late game | Source: iPICK2 |
| Guild & Guild Raid | Player-level gated (~D5–D7+) | Source: IronJosh — "find a good guild" |
| Xenoscape banner / Sublime heroes | Premium currency required | Source: PlayMe1 |
| Pantheon endgame | All heroes deployed lvl 200 | Source: IronJosh — explicit |
| Immortal star tier | Post-Mythic; "long time or lots of money" | Source: iPICK1 |

---

## 9. Monetization Detail

### 9.1 Currency Stack
| Currency | Source | Sink |
| --- | --- | --- |
| **Gems** (premium) | IAP, daily login, achievements, ads | Summons, Black Market refresh, energy refills, Top-Up |
| **Coins/Gold** | All modes | Talents, gear refine, slot levels |
| **Hero EXP** | Goblin Ground primarily | Slot levels (between 10-tier breakpoints) |
| **Promotion Stones** | Boss Challenge, events | Slot level 10/20/30/etc. gates — main bottleneck |
| **Element Essences** (Ice/Fire/Wind/Electro) | Summon Market, events, Black Market | Hero star-up |
| **Soul Stones / Shards** | Summon excess | Generic shard exchange for targeted heroes |
| **War Soul Crystals** | Boss Challenge daily | **Boss Market** — buys hero shards (Demon Spawn, Parody, Ice Demon, Ice Queen) |
| **Purple Stones** | Excess Epic summons | **Summon Market** (Saraf, raid-up tickets, essences) |
| **Hammers** (common/rare/epic) | Abyss Crusade | Treasure pulls |
| **Enhanced Sight** | Gear salvage / rewards | Gear level upgrade |
| **Azure Essence** | Gear salvage / rewards | Gear refine upgrade |
| **Rune Powder** | Rune salvage | Rune-itself upgrade |
| **Lunarites** | Event ranking | Past rate-up hero runes (14 → set) |
| **Goddess Water** | Black Market 80g, events | In-run revives (max 2 per run after 1 free ad) |
| **Glyphs** (silver/gold/element) | Elemental Trials | Weapon upgrades |
| **Scrolls** (summon tickets) | Multiple sources | Hero gacha |
| **Raid-Up Summon Tickets** | Limited events, premium | Rate-up banners |

[Source: cross-confirmed iPICK1, PlayMe1, IronJosh]

### 9.2 Spend SKU Inventory
[Source: iPICK1; cross-confirmed Reviews]:

| SKU | Price (when stated) | Notes |
| --- | --- | --- |
| **Basic Monthly Pass** | [Gap — not stated] | 30-day cycle, includes "Lucky Summon" feature [Source: 1★ Review — distinguishing detail] |
| **Premium Monthly Pass** | $9.99 [Source: 4★ Review] | Ad-free privilege, 30-day cycle |
| **Lifetime Privilege** | [Gap] | One-time purchase [Source: iPICK1; 1★ Review notes "they updated lifetime to monthly" — controversy] |
| **Prestige tab** | Spend-gated tiers | VIP system [Source: iPICK1] |
| **Beginner Pack** | ~$1.99–$9.99 [Source: 2★ Review "$50 into beginner packs"] | First-week onboarding bundle |
| **Daily Top-Up Gift** | Spend-triggered | Spend X gems → bonus chest [Source: iPICK1] |
| **Top-Up Gift** | Spend-triggered | Cumulative-spend chest [Source: iPICK1] |
| **Pack Shop** | Various | Themed bundles, rotating |
| **Gem Top-Up** | Various | Direct gem purchase; "1st time double" promotion; iPICK1 says **last resort — worst value** |
| **Black Market** | Gems | Summon tickets at 210/240g (vs 300g normal); Goddess Water 80g; essence 400g |

### 9.3 Pity & Drop Rates
[Source: iPICK1 — confirmed gameplay]:
- **Standard summon banner**: 100-pull pity → guaranteed Mythic wheel selection (player picks)
- **Rate-up banner**: 50-pull pity does NOT guarantee the rate-up hero — guaranteed only on the 2nd 50-pull cycle (so "soft pity at 50, hard pity at 100" for the rate-up hero specifically)
- **Xenoscape (Sublime) banner**: separate banner; rates [Gap]
- **Standard summon cost**: 300 gems / pull; **2900 gems for a 10x pull** [Source: wd-com]
- **Black Market ticket discount**: 210–240 gems vs 300 [Source: iPICK1]

[Conflict: LDPlayer mentions a 500-pull pity. Likely a different banner type or stale info — IronJosh and iPICK1 both confirm 50/100 for current banners.]

### 9.4 The Whale Hooks
[Source: iPICK2; IronJosh; Reviews]:
1. **Outfits at 200 pulls** → permanent +1%/+1%/+1% account-wide stat compounds — **the most powerful single hook**
2. **Mythic Treasures** — multi-month commitment, 6 slots × N heroes
3. **Immortal star tier** — explicit creator note: "long time or lots of money"
4. **Sublime / Xenoscape heroes** — separate banner economy
5. **Account-power leaderboards** in PvP/Arena drive constant spend pressure
6. **Lunarite event currency** — non-stop running event = continuous spend pressure [Source: iPICK2]

---

## 10. UA & Creative Strategy (Habby's playbook)
[Source: Segwise — high-confidence; cross-confirmed by iPICK creator's "I've spent $842" and Habby genre patterns]

### 10.1 Network Mix
- YouTube: **50%** of UA spend
- AppLovin: **17%**
- Facebook: **14%**
- TikTok: **10%**
- Other: **9%**

### 10.2 Geo Strategy ("East-First")
Singapore 48% / South Korea 15% / Hong Kong 10% / Taiwan 6% / Western 21% — validate creative in proven Habby-success Asian markets, then scale West with adapted versions.

### 10.3 Creative Pillars
1. **Progression Showcase (36% of top ads)** — "Just Started → 1 hour → 1 week → 1 month" transformation reels with split-screen format
2. **Battle Intensity (27.3%)** — controlled-chaos sequences that **cut at peak tension without resolution** (curiosity gap)
3. **Character Collection Diversity (81.8% feature multiple heroes)** — Mage, Lion Swordmaster, Cat Assassin, Crossbowman archetypes targeted at different player identities

### 10.4 Format Optimization
- 72.7% gameplay footage (not animated)
- 63.6% are 25+ seconds long
- 72.7% music-only (no VO/dialogue) → localization-cheap
- Only 36.4% include hook text → visual-narrative dominant

---

## 11. Player Pain Points & Churn Drivers
[Source: Reviews ★1-★3 corpus, n=655]

Top reasons cited for ★1 reviews (frequency-ranked, hand-coded from top upvoted):

| # | Theme | Representative quote (with upvotes) |
| --- | --- | --- |
| 1 | **Predatory monetization / pay-to-win** | "$3K-$5K USD to compete" (★1, 72👍); "Spent over $5K… don't worry I quit" (★1) |
| 2 | **Ad-walls for basic rewards** | "Unbearable amount of rewards behind ad walls" (★1, 90👍) |
| 3 | **Energy gating** | "13 min for 1 energy, 5 energy per match = 3 games per 5 hrs" (★1, 30👍) |
| 4 | **RNG skill draws** | "Even with Legendary, if RNG gives trash skills you have ZERO chance" (★1, 56👍) |
| 5 | **Lifetime → monthly pass changes** | "Bought forever non-ads package, they updated to monthly" (★1) — **multiple 2026 reviews** = potential class-action / scam complaints |
| 6 | **Cross-platform account migration broken** | "iOS to Android required photos of both phones + receipts — nearly impossible" (★2) |
| 7 | **Bug: levels resetting / "already claimed" rewards** | (★2, 32👍) |
| 8 | **Power creep / new stat enhancers behind paywalls** | "Way of progress = add new stat enhancer hidden behind paywall" (★1, 2026) |
| 9 | **Anniversary monetization** | "Anniversary event is shameless cash grab, violates gambling laws" (★1, 2026-04-08) — tied to v2.0.0 anniversary update |

**Critical retention insight from review timestamps:**
- Jun 2025 review explosion (796 reviews) was a healthy mix of curiosity + criticism
- By **Q1 2026 (40–46/month)** review volume collapsed ~95% from peak — typical post-UA-burst decay
- 2026 reviews are **dominated by ★1** complaints from long-tenured players ("playing since beta", "thousands of dollars") — **the whales are churning out**

---

## 12. Game Modes Catalog (full)

| Mode | Type | Frequency | Reward | Source |
| --- | --- | --- | --- | --- |
| **Main Campaign / Chapters** | 20-wave PvE | Energy-gated; sequential | Gems, EXP, scrolls, gear | iPICK1, KruMobile |
| **Star Challenge** | Replay chapters for stars | Energy-gated | Scrolls + gem bundles every 5 stars | iPICK1, PlayMe1 |
| **Golden Rat Hole** | Daily mob blitz | 2 free + 1 paid blitz/day | Gold + gems | iPICK1, PlayMe1 |
| **Goblin Ground** | Daily boss-style | 2 free + 1 paid blitz/day | Hero EXP + gems | iPICK1, PlayMe1 |
| **Boar Hunt** | Score-based hybrid | 200 pts per clear x2 | Various; difficulty up free, down 7d cooldown | iPICK1, PlayMe1 |
| **Boss Challenge** | 4 daily bosses w/ element gimmicks | Daily, all 5 heroes auto-deployed | War Soul Crystals (→ Boss Market) | iPICK1, PlayMe1 |
| **Abyss Crusade** | Endless tower | Floors persist | Common/Rare/Epic Hammers (→ Treasures) | iPICK1 |
| **Quick Patrol** | AFK idle income | Always running | Gold, EXP, materials | iPICK1 |
| **Elemental Trials** | Per-element challenge | [Gap on cadence] | Weapon glyphs (silver/gold/element) | iPICK2 |
| **Runic Plains** | Endgame rune farm | Difficulty ladders | Sublime-tier runes | iPICK2, IronJosh |
| **Voyage** | Long-form chapter mode (e.g. "Ride the Rapids") | Event/persistent | [Gap] | iPICK2 |
| **Arena (PvP)** | Player-vs-player ranking | 2 entries/day | Arena Market currency → DPS shards | IronJosh |
| **Guild Raid** | Co-op boss | 3 attempts/day | Guild rewards | iPICK2 |
| **BSU** | Wave + boss hybrid | [Gap on cadence] | Similar to chapters | PlayMe1 |
| **Shrouded Dungeon** | Dungeon variant | [Gap] | [Gap] | KruMobile pt 2 (silent) |
| **Skeletal Dungeon / Glacial Crown** | Themed biomes | Campaign zones, not separate modes | Same as campaign | KruMobile |
| **Wave/"Van" Challenge** | Fixed 5-hero deploy | [Gap on cadence] | [Gap] | PlayMe2 |
| **Limited Time Rushes** | Event tracks (Summon, Keys, Rune, Treasure, Fate Wheel, Adventure Quest) | Rolling, concurrent | Event-specific | IronJosh |
| **Lunarite Event** | Continuous event | Always-on | Lunarite currency → past rate-up runes | iPICK2 |
| **7-Day Carnival** | Recurring sign-in event | Resets weekly | Cumulative bundle | iPICK1, PlayMe1 |

---

## 13. The Hero Roster (cross-source synthesis)

**Confirmed heroes** (named in ≥1 source). Tier mapping is the reconciled meta tier from 4+ tier-list sources (PocketGamer, LDPlayer, AllClash, TheriaGames, plus user TierImg). Note: meta drift between mid-2025 and Mar 2026 is significant; **TierImg is most recent**.

### SSS / Top Meta (TierImg + cross-confirmed)
| Display Name | TierImg abbrev | Element | Rarity | Notes |
| --- | --- | --- | --- | --- |
| **Sword Saint Lark** | SW | Wind | Mythic | "Broken" top wind DPS [iPICK2]; #1 in old meta |
| **Void Witch Celine** | VW | [Gap-element] | Sublime/Xenoscape | Best Xenoscape vs Peacemaker [iPICK2] |
| **Peacekeeper Karl** | PC | [Gap] | Sublime/Xenoscape | Older xenoscape; replaced by VW |
| **Lich** | Lich | [Gap] | Sublime | Synergy with Xeno wind teams (VW summons) [TierImg notes] |
| **Northern Tyrant Ulfric** | NT | [Gap] | Mythic | Bumped up for Arena PC+Lich teams [TierImg notes] |
| **Panda** | Panda | [Gap] | Sublime (new) | Recent SSS slotting; "ridiculously good damage buffing" [TierImg notes] |
| **Stella?** | AA | [Gap] | Sublime | "Survival second to AA" [TierImg notes — abbreviation ambiguous] |

### S Tier
| Name | Element | Rarity | Notes |
| --- | --- | --- | --- |
| **War Reaper / Scarlet Reaper** | Fire | Mythic | Top-meta DPS [IronJosh] |
| **Phoenix Dancer Xiluan** | Fire | Mythic | "In all top teams" [IronJosh, PocketGamer] |
| **Valkyrie** | [Gap] | Mythic | [PocketGamer] |
| **Frost Lich / Floss** | Ice | Mythic | A+ [AllClash], F2P DPS option [IronJosh] |
| **Phoenix Dancer (PD)** | Fire | Mythic | [PocketGamer] |
| **Fire Mage** | Fire | Mythic | [PocketGamer S-tier] |

### Mid / A Tier
| Name | Element | Rarity | Notes |
| --- | --- | --- | --- |
| **God Ruler Odin** | Lightning | Mythic | S+ [AllClash] |
| **Robot Fystron** | Lightning | Mythic | "Strongest single-target DPS" [iPICK1]; built-in 100% crit skill |
| **Demon Spawn Zain** | Fire | Mythic | F2P-friendly via Boss Market [IronJosh] |
| **Blazing Archer Parody** | Fire | Mythic | Crit-damage buff synergy [iPICK2] |
| **Ice Demon Floss** | Ice | Mythic | Troll-summon aggro distractor [PlayMe1] |
| **Ice Queen Shiva** | Ice | Mythic | F2P combo with Ice Demon [IronJosh] |
| **Cat Assassin** | Wind | Mythic | Wind-resistance debuff (buffs Sword Saint) [iPICK2] |
| **Night Baron** | [Gap] | Mythic | A-tier [PocketGamer] |
| **Swordmaster** | [Gap] | Mythic | A-tier |
| **Thunder Pharaoh** | Lightning | Mythic | A-tier |
| **Demon Hunter** | Fire | Mythic | A-tier |
| **High Priest** | [Gap] | Mythic | A-tier healer |
| **Fire Witch** | Fire | Mythic | A-tier |
| **Ice Mage** | Ice | Mythic | A-tier [PocketGamer] |
| **Necrym** | [Gap] | Mythic | A-tier [PocketGamer] |

### Healers (always run 1)
| Name | Notes |
| --- | --- |
| **Saraf / Sarah** | Legendary; team healer; ATK-scaling heal; Thunderbolt skill = more heals [iPICK1, iPICK2] |
| **Sheffy / Cheffy** | Mythic; "best healer in game" once leveled [iPICK2, IronJosh] |
| **Seraph** | Top-tier healer [PocketGamer S-tier] — possibly same as Saraf with naming variance |
| **Novice Priest** | B-tier [PocketGamer] |

### B / F2P Tier
- **Elf Ranger, Frost Archer, Fire Apprentice, Unyielding Lancer, Frankenstein, Rogue Fire Mage, Ice Wolf Pup** [PocketGamer]
- **Aegis / Aegus** — Mythic; build-on-pull [IronJosh]
- **Kilonek / Killian / Kilex** — support not DPS [IronJosh, AllClash]
- **Archon** — premium pull [IronJosh]
- **Polar Captain** — limited rate-up [PlayMe1]

### Tier abbreviation map (TierImg → full name) — confidence-tagged
**High confidence:**
- SW = Sword Saint, VW = Void Witch, PC = Peacekeeper, NT = Northern Tyrant, ID = Ice Demon, IQ = Ice Queen, BA = Blazing Archer, FL = Frost Lich, PD = Phoenix Dancer, SR = Scarlet Reaper, WR = War Reaper, VG = Valkyrie [Inferred], SS = Sword Saint or Swordmaster [Ambiguous], DH = Demon Hunter, HP = High Priest, FM = Fire Mage, IM = Ice Mage, FW = Fire Witch, NB = Night Baron

**Lower confidence / Gap:**
- AA = ? (possibly "Apex Avenger" or similar new Sublime; **Stella** mentioned in TierImg notes as adjacent), MK / PK = ? (likely new sublime additions post-mid-2025), DS = Demon Spawn (per IronJosh)

---

## 14. Genre Comparison & Lila Strategic Take

**Closest comparables** [Inferred + Reviews]:
- **Archero (Habby's own)** — same studio playbook, same reward cadence, same UA approach
- **Capybara Go! (Habby)** — same chibi art direction
- **Vampire Survivors / Brotato** — skill-draft roguelike layer
- **Empires & Puzzles / Hero Wars** — gacha hero collector layered on combat
- **Idle hero defense games** (Idle Heroes, AFK Arena) — daily-login engineering

**What Habby got right:**
1. **Slot-not-hero progression** is genuinely loved (highest-praise mechanic in reviews)
2. **Skill-drafting per match** keeps the auto-battler from feeling auto
3. **Chain skills** create combinatorial team-building depth without overwhelming new players
4. **East-first UA** validated economic model before expensive Western scaling

**What's risk-prone:**
1. **9 progression systems** is overwhelming; review fatigue on "red dot hell" + "menu of menus"
2. **Cross-platform account migration is broken** (multiple ★1–★2 complaints) — solvable, but they haven't
3. **Lifetime → monthly pass change controversy** (2026) signals trust erosion among long-term spenders
4. **Whale churn evident in 2026 reviews** — "spent $5K, quit" is a class of review now appearing repeatedly. This precedes commercial tail-off.

**[Lila implications — opinion, not from sources]:**
- This is a textbook "**run-the-Habby-playbook**" title — proven, but late-cycle. The studio is now monetizing power-creep with new stat-enhancer systems (Statues added in Aug 2025; Weapons added between June and August 2025; Immortal tier added; v2.0.0 / anniversary update controversy). A new stat layer every 1–2 months is the model.
- For Lila's #4 evaluation: **Wittle Defender's $1.4M/30d at 1.3M downloads ≈ $1.08 per download in month 1** — strong but driven by aggressive whale monetization. The D7 retention question is what would matter to copy. Review decay 96→26/mo over 9 months = D90+ retention is **not** the strength.
- The skill-drafting + slot-progression hybrid is the most genuinely innovative element and worth lifting. The 9-system progression sprawl is the red flag worth avoiding.

---

## 15. Information Gaps (what's still unknown)

[Gap] — explicit holes in the corpus that would matter for a true competitor spec:

1. **Drop rates by rarity** — no source publishes Habby's official rates; only pity confirmed
2. **Energy regen rate** — reviews give conflicting numbers (13 min vs 20 min per energy)
3. **Account/player level cap and gates** — references to lvl 200 hero gates, but no confirmed account cap
4. **Specific skill numbers** — damage values, cooldowns, scaling formulas absent
5. **Banner cost matrix** — Xenoscape banner cost not stated
6. **D1/D7/D30 retention numbers** — no public data; only review-volume proxy
7. **ARPDAU / IAP segmentation** — Segwise gives revenue snapshot only, not segmentation
8. **PvP/Arena ladder rules** — IronJosh mentions Arena Market but no detail on tier system, season length, matchmaking
9. **Guild mechanics depth** — Raid is mentioned but war/contribution mechanics are not detailed
10. **Wittle-defender.com hero portraits** — site lazy-loads images via JS; the scrape returned 0 images from this domain
11. **Specific hero skill names** — partial list (Hellvoid Slash, Icicle Storm, Burning Ground, Pyro Servant, Initial Summons treasure) — exhaustive list missing
12. **Outfit catalog & exact pull-200-rewards** — concept is confirmed but the full SKU list / cosmetic variety is not
13. **The "Immortal" tier mechanics** — mentioned as added in update; no progression details

To fill these the next pass should: (a) install the game and play 2 weeks, (b) request Habby's published rate sheet (regulatory in some jurisdictions), (c) pull SensorTower / data.ai for retention curves, (d) run Claude-in-Chrome on wittle-defender.com to capture lazy-loaded portraits, (e) datamine the iOS IPA for skill tables.

---

## 16. Source Index

### Web sources scraped (20 markdown files, all verbatim post-fix)
- `wittle-defender-com/` — 10 guides
- `pocketgamer/` — 3 paginated tier list pages (byte-identical; client-side pagination)
- `theriagames/` — 4 guides (beginner, gear, tips, tier list)
- `other-sites/` — Segwise creative analysis, LDPlayer tier list, AllClash hero ranking

### YouTube (14 videos analyzed)
- iPICKmyBUTT × 2 (rich content)
- PlayMe × 2 (rich content)
- IronJosh300 × 1 (F2P focus)
- KruMobile × 9 (silent walkthroughs — value is biome/UI confirmation, not commentary)

### Play Store
- 2,099 unique reviews scraped via `pull_reviews.py`
- Aggregates + analysis pack at `Web Sources/reviews_com.game.kingrush/`

### Image Assets
- 67 images downloaded (`Web Sources/images/`)
- 1 user-supplied tier list (Mar 10) — abbreviation-mapped above

### Verification reports
- `Web Sources/_verification_files.md`
- `Web Sources/_verification_consistency.md`
- `Web Sources/_verification_images.md`

---

*End of design spec. Update cycle suggested: every 4–6 weeks (Habby is on a rapid update cadence; new systems land roughly every 6–8 weeks based on Statues / Weapons timing).*
