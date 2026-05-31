# Archero 2 — Game Design Documentation

**Compiled:** 2026-05-18
**Author:** Tarun (Lila Games) via Claude Code research synthesis
**Sources:** game-vault wiki (33 pages), luhcaran wiki (28 heroes + 64 items + 120 skills + 20 Google Sheets), Archero fandom (~250 pages), progameguides (5 articles), 21 YouTube videos (~5.7 hr of gameplay/commentary), 3,042 Play Store review bodies, 162,850 lifetime ratings
**App:** `com.xq.archeroii` — Google Play **4.49★** with 162,850 ratings (72.1% 5-star) [REVIEWS]
**Publisher:** Habby
**Genre tag for this doc:** Stationary wave-survival roguelite with mid-core meta gacha
**Status:** Live, post-global, on v1.1.6 as of 2026-05-15 [V:FaZlxQNpK9U]

---

## 0. Source Tagging Convention

Every claim in this document is tagged with its provenance. **Trust hierarchy** (high → low):

| Tag | Meaning | Trust Level |
|-----|---------|-------------|
| `[GV:Page]` | game-vault.net Archero 2 wiki — community-maintained, Archero 2-specific, datamining-backed | **High** |
| `[LC]` | luhcaran wiki — secondary Archero 2 wiki, structured hero/item/skill data + 20 official spreadsheets | **High** |
| `[SHEETS:name]` | Google Sheets exported from luhcaran's `google-sheet` page (datamining tables) | **High** |
| `[V:id, channel, date]` | YouTube creator content notes (transcripts + frames) | **Medium-High** — creators with hands-on play, but with channel slant |
| `[REVIEWS]` | Play Store review bodies + listing metadata | **High for sentiment, biased for prevalence** (HELPFULNESS sort over-indexes complaints) |
| `[PGG]` | progameguides editorial guides | **Medium** — editorial site, not always datamined |
| `[FANDOM]` | archero.fandom.com — Archero **1** wiki, included by user for design-DNA reference | **Low for current Archero 2** (kept as legacy comparison only) |
| `[INFERRED]` | My deduction by combining tagged sources — explicitly marked when synthesis goes beyond what any single source states | **Mid** — labeled so you can challenge |
| `[ASSUMED]` | Stated assumption where data is genuinely missing; flagged so you know it's not from the corpus | **Low** — to be verified |

When the same fact appears in multiple sources I cite the strongest. When sources disagree I show both and call out the divergence. When a number is in the wiki but contradicted by a recent video patch I prefer the recent video and note the discrepancy.

---

## 1. Executive Summary

Archero 2 is a free-to-play mobile **stationary wave-survival roguelite** by Habby, released globally in 2024–2025. It is **NOT** a room-to-room dungeon crawler like the original Archero — multiple commentators converge on the framing **"bumper Survivor"** [V:KrXJHpk_uXU, TheGameHuntah, 2025-03-03; V:jCpmNrXYJsc]. The hero stays in a single arena and survives 50 waves / 50 rooms / 6-minute survival per chapter format [GV:Campaign].

**The strongest single signal of product-market fit:** 162,850 lifetime ratings at **4.49★** with **72.1% 5-star** [REVIEWS]. The game is a legitimate hit; the most-thumbed negative reviews are loud but represent ~5.7% of the rated player base.

**Why it works (highest-confidence signals):**
1. **Genre fit.** The Vampire Survivors-style auto-attack + skill-roulette loop is genre-validated and matches Archero's existing IP shape.
2. **Roguelite session length.** Chapters cap at 6 min (timed) or ~3–5 min (rooms/waves), so a session is a complete dopamine cycle. Players consistently describe **"30 min/day"** as their habit [REVIEWS:240-thumb 5★].
3. **Multi-currency horizontal progression.** ~11 currencies (Gold, Gems, 6 Gear Scrolls, 3 Chest Keys, 8+ Shards, Shovels, Tickets ×4, Wish Tokens, Enchantium, Guild Gold, Balloon Tickets, Dice) [GV:Currency_and_Items] mean every session generates *something* and nothing feels "done" — classic mid-core retention.
4. **Visible spend value.** First IAP at **$4.99** is repeatedly called "worth the money" by 5★ reviewers [REVIEWS:292-thumb 5★]; **Permanent Supply Card** at €6/$5.99 is universally rated #1 by multiple creators as the best lifetime deal [V:kpIdlbhx4s8; V:lEb22efbhjs].

**Why it bleeds players (highest-confidence signals):**
1. **Sky Tower as forced campaign gate.** This is the **#1 negative theme** — Sky Tower (a separate roguelite mode) hard-gates campaign chapter unlocks (e.g., Chapter 40 requires Sky Tower lvl 450) [V:lEb22efbhjs; REVIEWS:447-thumb 1★, 185-thumb 1★]. Players who wanted dungeon-crawling resent grinding a separate mode for it.
2. **Mid-game difficulty cliff.** Player XP scaling falls behind enemy HP scaling at ~Chapter 30–40 [REVIEWS:193-thumb 1★]. Coupled with one-shot lethality at higher chapters, it forces grind-or-spend.
3. **Two-set PvE/PvP gear meta.** Oracle Set best for PvE, Griffin best for PvP — switching costs progression because both require chromatic-chest gachas. Players in Arena season feel "locked out of campaign" [V:FaZlxQNpK9U]. [INFERRED: this is design-intentional resource sink, not a bug.]
4. **Energy gating.** 5 energy/battle, 30 max base, 12-min regen [GV:Campaign]. Plays into the spend-or-wait pattern that 2★ reviews call out [REVIEWS:88-thumb 2★].

**The single biggest design lever Habby is using:** they ladder players across **8+ daily activities** (campaign, Sky Tower, Arena, Gold Cave, Rune Ruins, Quick Hunt, Guild Monster Invasion, dailies + weeklies) each with its own ticket-currency and reward, layered over a **6-axis meta progression** (Hero stars/Resonance, Gear merge/upgrade, Rune merge/enchant, Talent Cards, Artifacts, Character Codex skins). Any player on any spend tier always has 3–5 things they "could" do today. That's the retention engine. [INFERRED, but synthesized from [GV:Events] + [V:kpIdlbhx4s8] + [V:lEb22efbhjs].]

---

## 2. Game Positioning & Genre

### 2.1 Genre Identification (strongest claim of the doc)

Archero 2 is a **stationary, single-screen, auto-attack wave-survival roguelite with a 3-card-pick skill-roulette loop**, wrapped in **mid-core mobile gacha/meta-progression**. Closest reference points:
- **Vampire Survivors / Survivor.io / Boomerang Fu** for the in-run loop [INFERRED based on V:KrXJHpk_uXU's "bumper Survivor" framing]
- **Archero 1** for the IP, hero/skill DNA, and economy patterns [FANDOM, plus continuity in hero names like Atreus, Rolla]
- **AFK Arena / Hero Wars** for meta layers (gear merge, hero stars, artifact wishes) [INFERRED from the wiki shape]

### 2.2 Departure from Archero 1

The single biggest design pivot from Archero 1, and the one most-noted by reviewers and creators:

> "you move from one location to another it's like a big map this one is just a one stationary location like a your trap in a Coliseum" — [V:KrXJHpk_uXU, TheGameHuntah, 2025-03-03]

> "It's a more polished version of the original. Though I enjoy the game, it still has alot of the same issues." — [REVIEWS: 291-thumb 2★]

Archero 1 (FANDOM-confirmed) was room-to-room: player walks into an arena, kills mobs, walks to next room. Archero 2 collapses this to one arena and replaces the "walk to next room" pacing with **wave timers** [GV:Campaign].

### 2.3 What stays from Archero 1

- Auto-attack-while-stationary, manual movement only [V:KrXJHpk_uXU; FANDOM]
- Skill-pick choice screen between waves/levels [GV:Skills]
- Angel/Devil/Valkyrie NPC encounters (Devil costs HP for power; Angel heals/gives a passive) [GV:Skills, "Skills Providers"]
- Hero progression by collecting shards [GV:Characters]
- Equipment tier merge (Normal → Mythic) [GV:Gear; FANDOM:Fusing_%26_Dismantling_Equipment]
- Bow as default weapon archetype [GV:Gear; V:KrXJHpk_uXU]

### 2.4 Audience signals

From [REVIEWS]:
- **Returning Archero 1 players** are a significant cohort — multiple top-reviewers explicitly compare to Archero 1 [REVIEWS: 193-thumb 5★ "I've played archero 1 for about 6 months"]
- Aged 30+ casual mobile crowd is well-represented in 5★ reviews ("30 min/day," "easy to sink an hour"), suggesting Archero 2 is a **commuter/evening unwind** game, not a hardcore PvP destination
- **Hardcore PvE roguelite fans** (Gunfire Reborn / Returnal mentions [REVIEWS: 193-thumb 5★ "fan of roguelike games like returnal and gunfire reborn"]) form a smaller but vocal segment
- **Whales exist and are visible:** [V:SWt0cYOM0kM, iPICKmyBUTT, 2025-04-06] discloses $5,000+ spent

---

## 3. Moment-to-Moment Gameplay (in-run mechanics)

### 3.1 Controls & Camera

- **Top-down 3/4 view.** Single virtual joystick (left-thumb) controls movement only; auto-attack handles aiming and firing. [V:nhJMWJRWq30, MobileGamesDaily; V:kpIdlbhx4s8]
- **No attack button.** Standing still attacks, moving stops attacks (except for builds with auto-detached weapon via Weapon Enchantment skill). [GV:Skills; V:kpIdlbhx4s8]
- **Active skill slot** (bottom-right) exists but is mostly used for in-run consumables; default loadout has none in the early chapters [V:NgiDHZuNFy0, frame interval_0050].
- **Settings flagged as mandatory by creators:** Hide Joystick ON, Skip Skill Choice Animation ON, Effect Reduction ON. The Effect Reduction setting's *existence* signals that the default particle density is unreadable at high build power [GV:Tips_and_Tricks; V:VGFEPNdXhAE]. **This is a documented UX pain point.**

### 3.2 Combat fundamentals

- **Damage formula** is hybrid additive-multiplicative across 3 buff categories: **ATK PWR**, **Main Weapon DMG**, **DMG**. Buffs add inside their category, categories multiply each other [GV:Skills, "How is Damage Calculated"].
  - Example calculation given by GV: `(1 + 0.20 - 0.30)[ATK] × (1 - 0.20)[DMG] × (1 - 0.15)[Main weapon DMG] = 0.612× damage per arrow` if you stacked Giant's Strength + Weapon Enchantment + Swift Arrow + Front Arrow.
  - Full Damage Formula sheet on Google Sheets, credit Fierywind on Discord [SHEETS]
- **Attack Speed uses a breakpoint system**, not linear. Same skill can give +10%, +20%, or 0% depending on current AS bucket [GV:Skills, "How is Attack Speed Calculated"]. Bow/Staff/Claws all have **different breakpoint curves** — Renox's sheet on Discord [SHEETS] is the canonical source.
- **Weapon Enchantment** detaches weapon for auto-fire and applies ~25-30% AS penalty, but boosts all other AS gains slightly — effectively self-canceling around +225% AS [GV:Skills].
- **Charged skills (Charged Arrow, Energy Beam, Energy Ring)** apply multiplicative AS penalties (0.6-0.7×) and only the lowest applies if multiple are present [GV:Skills].
- **Elements (Fire/Lightning/Ice/Poison)** stacking rules [V:NgiDHZuNFy0, Grinnn, 2025-06-28]:
  - Same-element sources do NOT stack
  - Ice has 10s on-hit cooldown per target, Poison has 0.4s
  - Lightning and Blaze (fire) have no cooldown — stack freely
  - Different elements DO stack (blaze + venom sprite both apply)
  - Staff weapon hits Blaze TWICE per attack (significant fire synergy) [V:NgiDHZuNFy0]
  - **Tier list from creator:** Fire > Lightning > Ice > Poison (Poison is boss-fight specialist only)
  - **Source credit:** "EpicJapan" Japanese MOD via Archero 2 Discord — community datamining
- **Critical Rate** caps in practice via gear/talent stacking; CRIT DMG multiplier scales linearly [GV:Talent_Cards; GV:Gear].

### 3.3 Combat loop within a chapter

Three chapter formats; **the same chapter biome may use any of the three** [GV:Campaign]:

1. **Rooms Chapter** (50 rooms, boss every 10th) — sequential clear, but per the design pivot **each room is still played as a stationary arena**, you don't "walk" between rooms in the Archero 1 sense [INFERRED + V:nhJMWJRWq30 frames showing room transitions as cuts]. Between rooms: pick a skill from 3 cards.
2. **Waves Chapter** (single arena, 50 waves, boss waves 10/20/30/40/50). After each wave, brief pause; sometimes a skill card pops [GV:Campaign].
3. **Timed Chapter** (6-min survival, 2 boss spawns every 3 minutes) [GV:Campaign]. Used in some chapters (Chapter 4 confirmed [V:nhJMWJRWq30]) and most events (Shackled Jungle = timed) [V:W43vRnoT7ZQ].

### 3.4 NPC encounters mid-run

Three NPC types interrupt the run [GV:Skills, "Skills Providers"]:

| NPC | Trigger | Offer | Cost |
|-----|---------|-------|------|
| **Valkyrie** | Stage ending in 5 (e.g., Wave 15, 25, 35); every 30s in timed; **every floor in Sky Tower** | Choice of Legendary/Epic/Rare skill from broad pool (offensive/defensive/utility) | Free |
| **Angel** | Stage ending in 9; every 30s in timed | Fine-tier passive (Warrior's Breath, Restore HP, etc.) **+ healing** | Free |
| **Devil** | After defeating a boss without taking damage; conditional | Legendary/Epic/Rare skill from aggressive pool | **15%/23%/30% of base max HP** depending on rarity. Devil Pact rune mitigates this. [GV:Skills; GV:Runes "Devil Pact"] |

[V:nhJMWJRWq30] confirms all three NPC types visually with damage cost scaling from 69 to 407 max HP across a 40-min run.

**Seraph hero has unique synergy:** her Lv.1 ability "Divine Favor" gives a 50% chance to encounter the Valkyrie at the start; Lv.3 gives a chance for "MAX HP not reduced when making a pact with the devil" — i.e., a free Devil pact. This makes Seraph a meta-pick for aggressive rune+devil builds [GV:Characters, "Seraph"; V:3rPvl1xCvAw].

### 3.5 In-run progression: skill picks

- Every level-up presents **3 random skills** for selection. [V:KrXJHpk_uXU; V:kpIdlbhx4s8]
- Talent card "Glory" (1-star max) grants **First Skill Selection Chance +1** — guaranteeing one of your first 3 skills is your specific pick instead of random [GV:Talent_Cards]
- Talent card "Tactics" (2nd-tier unlock) grants **Skill Refreshes +1** in battle [GV:Talent_Cards]
- Rune "Intelligence" Legendary enchant: **In-battle skill refreshes +1**, Mythic: refreshes +2, Max level cap +1 [GV:Runes]
- **Resonance** unlocks at hero 3-star and adds another slot at 6-star, letting you bring **a starting skill from another unlocked character** into the run [GV:Characters]. This is a major build-customization lever — explicitly described in [GV:Characters] as "key feature for character progression," and reinforced as "the best and one of the most powerful thing in the game" in [V:IGpuzVuEO1o].

### 3.6 Skill rarities (4 tiers)

[GV:Skills, full skill table — copied verbatim subset below]

**Legendary skills (11 listed):** Warrior's Soul (+30% ATK), Power Trio (+15/+20/+20%), Multishot (+1 projectile), Corrosive Field (35% more dmg to nearby enemies), Energy Beam (charged laser), Soul of Strength (+40% Max HP), Sacred Protection (1 hit/wave shield), Sprite King (companion), Super Meteor (random meteors every 4s), Beam Strike (1 strike every 2.5s shoots laser), Circle Web (orbs form damaging web)

**Epic skills (24+ listed):** ATK Increase, Giant's Strength, Weapon Enchantment, Soul of Swiftness, Tracking Eye, Diagonal Arrow, Energy Ring, Wall-Piercing Arrow, Wind Blessing, Water Walker, Slow Field, **Revive** (death-prevention, only from Devil/Valkyrie), Super Blaze/Bolt/Venom/Freeze, Laser Sprite, Sprite Frenzy, Meteor Pursuit, Chain Meteors, Beam Circle, Super Circle, Magic Strike, Strike Boost, Twin Strike

**Rare skills (~25):** Underworld Warrior, Demon Slayer, Warrior's Heart, Stand Strong, Short-Range Strike, Perilous Fervor, Lightwing Arrow, Swift Arrow, Fairy of the Wind, Front Arrow, **Charged Arrow** (enables Energy Beam/Ring synergies), Piercing Arrow, Split Shot, Ricochet Arrow, Lucky Band-Aid, Lucky Cracker, Cloudfooted, Lucky Heart, Fountain of Life, Heart of Vitality, Angelic Shelter, Invincibility Potion, Abundant Potions, **Blaze, Bolt, Venom, Freeze** (the base elemental on-hit skills), Bomb Sprite, Sprite Boost, Circle Boost, Blitz Strike, Instant Strike

**Fine skills (~32):** Warrior's/Fairy's/Breath of Wind, Strength Blood (HP+10%), Restore HP, Wounded Warrior (+50% ATK while damaged for 5s), **Boss Slayer** (+25% boss dmg, fully heal before boss — universally rated high), Long-Range Power (up to +40% scaling with distance), Frenzy Potion, Bounce Arrow, Rear Arrow, Fiery Path, Perilous/Demon Recovery, Flame/Lightning/Venom/Ice Spike Sprite, all 4 elemental Meteor Potions, Fire/Bolt/Poison/Ice/Vampiric Circle, Assault/Blade Potion/Pursuit/Riposte Strike

### 3.7 Beginner skill tier list (community consensus)

[GV:Guide:Skills_Tier_List]:

| Tier | Skill |
|------|-------|
| **S** | Tracking Eye, Multishot |
| **A** | Energy Beam, Soul of Swiftness, Boss Slayer, Power Trio, Super Blaze, Revive, Wind Blessing, Super Bolt |
| **B** | Weapon Enchantment, Super Circle, Lightwing Arrow, Warrior's Soul |
| **C** | Corrosive Field, Diagonal Arrow, Stand Strong |

**The single most-cited "broken" combo:** Tracking Eye + Oracle Set [V:SWt0cYOM0kM, iPICKmyBUTT] — "absolutely broken." Reason: Oracle's combo-based effects scale with sustained DPS, and Tracking Eye removes aim friction.

### 3.8 Build archetypes

Three primary archetypes [GV:Guide:Ultimate_Beginners_Guide; cross-confirmed in V:kpIdlbhx4s8; V:lEb22efbhjs; V:jCpmNrXYJsc]:

1. **Archer Build** — long-range projectile spam. Bow/Crossbow + Diagonal Arrow + Multishot + Tracking Eye + elemental on-hits. Lower DPS than Circle but easier survivability. Anchored by **Oracle Set** (combo-based ATK PWR/CRIT scaling).
2. **Circle Build** — rotating orbs (Fire/Ice/Poison/Bolt/Vampiric Circle) supplemented by Beam Circle, Super Circle. Higher mobility damage, but you must hug enemies. Anchored by **Decisiveness Set** (close-range bonuses) or **Echo Set**.
3. **Sword Strike / Sprite build** — companion-based DPS (Sprite King, Sprite Frenzy + Twin Strike). [INFERRED as a third archetype from skill design — confirmed in [V:jCpmNrXYJsc] but called rare/niche.]

[V:W43vRnoT7ZQ] documents the **canonical Circle build for events**: Giant Arrow + Energy Ring + Laser Circle → Vampire Circle + Freeze. Boss strategy: freeze → laser circle deploy → vampire heal during freeze.

---

## 4. Heroes (Full Roster)

### 4.1 Roster (17 confirmed playable as of v1.1.6) [GV:Characters]

| # | Hero | Theme | Passive name | Acquisition (primary) |
|---|------|-------|--------------|----------------------|
| 1 | Alex | "Default" demon hunter | Braveheart | Default unlock |
| 2 | Nyanja | Wind/sleep cat assassin | Cloudfooted | Shards (event/shop) |
| 3 | Helix | HP-low berserker | Absolute Counter | Gems |
| 4 | Hela | Aura support (best rare F2P) | Hadean Blessing | Shards |
| 5 | Mymu | Cursed mummy / Overdraw revive | Immortal Curse | Shards |
| 6 | Hou Yi | Boss-stacking bow | Sunpiercer | Shards |
| 7 | Seraph | Luck/Valkyrie/Devil-friendly paladin | Divine Favor | $30 USD IAP [V:3rPvl1xCvAw] |
| 8 | Dracoola | High-HP lifesteal vampire | Lifesteal | $30 USD IAP [V:3rPvl1xCvAw] |
| 9 | Rolla | Frost mage | Frostsinger | Arena Shop (5,400 VS tickets) [V:PtgbAzxp4rM] |
| 10 | Loki | Erratic PvP focus state | Fervent Rhythm | Shards |
| 11 | Phynx | Bleed/element synergy cat god | Desert Tribunal | Shards |
| 12 | Nezha | Fiery path tracking-orb | Cosmic Hoop | Shards |
| 13 | Otta | CRIT-on-high-HP boss specialist | Brutality | Event-only [V:3rPvl1xCvAw] |
| 14 | Atreus | Shield + dark energy orbs (legendary) | Demon King Energy | Shards / event |
| 15 | Thor | Mjolnir + Lightning warrior | Storm's Judgment | Event (Eon Core) [V:3ixTDUf0nvY] |
| 16 | Cleo | Fire/Frighten mark queen | Ember Throne | Shards |
| 17 | Wukong | Monkey Mirages buff stacker | Monkey Brethren | Not specified |

[INFERRED: Rarity tier matches shard requirement table — Legendary heroes need fewer shards per star (50/50/50/50/100/100/100/150/150) than Rare/Epic (50/50/100/100/150/150/200/300/500). [GV:Characters]]

### 4.2 Star-up shard costs (canonical)

[GV:Characters, Leveling Up section, verbatim]

**Rare & Epic heroes:**
| Star | Shards |
|------|--------|
| 0 (unlock) | 50 |
| 1 | 50 |
| 2 | 100 |
| 3 | 100 |
| 4 | 150 |
| 5 | 150 |
| 6 | 200 |
| 7 | 300 |
| 8 | 500 |
| **Total to 8★** | **1,600** |

**Legendary heroes:**
| Star | Shards |
|------|--------|
| 0–6 | 50 / 50 / 50 / 50 / 100 / 100 / 100 |
| 7 | 150 |
| 8 | 150 |
| **Total to 8★** | **800** |

[INFERRED: Legendary heroes need HALF the shards of Rare/Epic — this is an unusual reverse-rarity-cost gacha pattern. It implies that the limiting factor for legendaries is *acquiring shards at all* (event-locked), not the per-star cost. Habby is gating legendaries behind event windows, not behind shard grinding once unlocked.]

### 4.3 Star-up ability progression (universal pattern)

[GV:Characters — same pattern across all 17 heroes, e.g., Atreus]

| Star | Effect |
|------|--------|
| 0 | LV.1 of passive (the "always-on" base) |
| 1 | [All] +3% stat (varies by hero: HP/ATK/MOV SPD/CRIT) |
| 2 | LV.2 of passive (first major upgrade) |
| 3 | **Resonance unlock** — borrow another hero's LV.1 passive |
| 4 | [All] +3% stat |
| 5 | LV.3 of passive (second major upgrade) |
| 6 | **Resonance slot +1** — borrow a second hero's LV.1 |
| 7 | [All] +3% stat |
| 8 | LV.4 of passive (final tier — often a powerful conditional) |

**Design observation [INFERRED]:** Hero progression is gated to **8 stars × 4 passive tiers** but power gates fire on **2★, 5★, 8★**. The 1★/4★/7★ steps are flat stat boosts. This creates a clear "next big unlock" target every few hundred shards. Resonance at 3★ and 6★ adds a *combinatorial* progression — players gravitate to maxing one hero first to unlock the Resonance ladder, then collect breadth.

### 4.4 Standout hero designs (deep dives)

[GV:Characters — verbatim ability rows for context]

**Hela** [GV:Characters; V:3ixTDUf0nvY, Grinnn, 2026-03-09]: aura support — buffs herself and nearby allies. Lv.1 +5% ATK; Lv.2 +1% HP/sec regen; Lv.3 +5% CRIT Rate; Lv.4 +20% CRIT DMG. **Critical caveat: only one Hela boost applies per ally at a time.** Stacking Helas is pointless. Useless in single-player chapters but excellent for **GvG and Peak Arena**.

**Dracoola** [GV:Characters; V:3rPvl1xCvAw, EnderClan, 2025-01-14]: **EnderClan's #1 pick — "best character in the game."** Lifesteal at Lv.1; Lv.2 converts excess healing to next-attack damage (elegant dead-state elimination); Lv.3 MOV SPD +20% above 50% HP; Lv.4 **+40% ATK at full HP**. The full-HP +40% creates a high-HP-strong build philosophy [INFERRED: deliberate counter-pattern to Helix's low-HP-strong design].

**Helix** [GV:Characters]: explicit *low-HP-strong* design. Lv.1 +20% ATK at low HP; Lv.2 +20% ATK SPD for 5s after taking damage; Lv.3 +20% ATK for 10s after damage; Lv.4 +20% ATK SPD below 50% HP. **Polar opposite of Dracoola.** [V:CdZ122DGL_A] confirms Helix is "high-skill, high-reward." [V:3rPvl1xCvAw] ranks him "skilled player pick, very powerful."

**Seraph** [GV:Characters; V:3rPvl1xCvAw]: builds the entire run around **mid-run NPC encounters**. Lv.1 starts Valkyrie 50% of runs. Lv.2 chance for extra skill on Angel heal. Lv.3 free Devil pacts. Lv.4 higher-quality ability rolls. **Synergizes with Devil Pact rune.** $30 IAP-locked.

**Alex** [GV:Characters; V:CdZ122DGL_A, Grinnn, 2026-02-25]: default hero. **Both major hero-guide creators converge on "Alex is a trap" — weak long-term investment.** Personal pick for [V:CdZ122DGL_A] Grinnn is Hela; for [V:3rPvl1xCvAw] EnderClan, Dracoola. Alex is the "tutorial hero you grow out of."

**Otta** [GV:Characters; V:3rPvl1xCvAw]: pirate, CRIT-on-high-enemy-HP. **Event-only acquisition.** Lv.4: farther range = higher CRIT (up to +15%). "Boss specialist." [INFERRED: Otta is a "FOMO unit" — limited-time event acquisition with strong niche power.]

**Wukong** [GV:Characters; V:CdZ122DGL_A]: 3 permanent Monkey Mirages on entry. Lv.4: Mirages steal enemy hearts/potions, ATK +20% for 7s. Late-game elite unit. "If you have him, don't bother with Alex" [V:CdZ122DGL_A].

**Thor** [GV:Characters; V:3ixTDUf0nvY]: Mjolnir auto-attacks, lightning damage, paralyze synergy. Event-locked (Eon Core event). Lv.4: paralyzed enemies trigger 3 Mini-Mjolnirs.

### 4.5 Skins (Character Codex update — v1.1.6)

Pre-v1.1.6, hero skins were cosmetic only [V:CdZ122DGL_A — "Alex has 3 skins, cosmetic only"]. **Post-v1.1.6** [V:FaZlxQNpK9U, Grinnn, 2026-05-15]:

> The **Character Codex** ties hero star levels + owned skins to **stat boosts**. Hero skins now have gameplay value. Creator flags this as **F2P-hostile** because skins are largely cash-shop.

[INFERRED: This is a major monetization escalation. Pre-Codex, F2P could compete at the meta level even without skins. Post-Codex, owning skins materially affects power. Watch this signal — it's a recent enough change (3 days before research) that medium-term retention impact isn't visible in the review corpus yet.]

[REVIEWS sentiment around skins is currently muted — pre-v1.1.6 — so the doc cannot yet quote player reaction to the Codex change. Recommended re-pull review data in 60–90 days post-patch.]

---

## 5. Equipment System (Gear)

### 5.1 Slot structure

6 gear slots [GV:Gear]:
- **Weapon** (left column — ATK Power)
- **Amulet** (left column — ATK Power)
- **Ring** (left column — ATK Power)
- **Armor** (right column — HP)
- **Helmet** (right column — HP)
- **Boots** (right column — HP)

**Spend priority** [GV:Guide:Ultimate_Beginners_Guide, verbatim]: "Spend most of your Gold on the gear upgrades, prioritizing left column (Weapon, Amulet, Ring), as it gives more ATK Power."

**Slot inheritance** [V:kpIdlbhx4s8, Archer Greene]: Gear upgrades persist at the slot level. Swapping an item into the slot inherits the upgrades. **Strategic implication:** F2P players over-invest gear scrolls in one slot regardless of which specific piece they currently own [INFERRED].

### 5.2 The 6 Sets

[GV:Gear; per-set pages]:

| Set | Archetype | Best For | Notes |
|-----|-----------|----------|-------|
| **Oracle** | Combo-based scaling (combo → ATK PWR, ATK SPD, CRIT) | **PvE / chapters** | Most meta. Beam Staff weapon. Diagonal-arrow synergy. |
| **Echo** | Same combo mechanic as Oracle, non-S equivalent | **PvE F2P** | F2P alternative to Oracle. |
| **Dragon Knight** | Explosion + Meteor on-hit | **PvE chapters (AOE)** | Crossbow weapon. Carnival event grants this F2P. |
| **Destruction** | Same explosion mechanic, non-S | **PvE AOE F2P** | Heroic Longbow weapon. F2P alternative to Dragon Knight. |
| **Griffin** | Close-range bonuses (closer = more DMG/CRIT) | **PvP / Arena** | Griffin Claw weapon. |
| **Decisiveness** | Same close-range mechanic, non-S | **PvP F2P** | Agile Knuckles weapon. |

[INFERRED: The set design is *paired* — each "S-tier" set has a non-S equivalent. Habby's clearly trying to give F2P a similar shape of build at lower ceiling. The S-tier unlocks a unique quality bonus at Epic that non-S only gets at Legendary, plus extra Mythic/Mythic+/Chaotic tiers that non-S can't reach.]

### 5.3 Rarity & merging ladder

[GV:Gear, verbatim merge table]:

| From | Fodder | Result |
|------|--------|--------|
| Normal | 2× Normal duplicate | Fine |
| Fine | 2× Fine duplicate | Rare |
| Rare | 2× Rare duplicate | Epic |
| Epic | 1× Epic same-slot or material | Epic +1 |
| Epic +1 | 2× Epic same-slot | Epic +2 |
| Epic +2 | 1× Epic duplicate +2 | **Legendary** |
| Legendary | 1× Legendary same-slot | Legendary +1 |
| Legendary | 1× Legendary same-slot | Legendary +2 *(note: GV table looks duplicated — both +1 and +2 require 1 Legendary same-slot. [INFERRED: this is likely a wiki typo and the +2 step should require 1 Legendary same-slot)* |
| Legendary +2 | 2× Legendary same-slot | Legendary +3 |
| Legendary +3 | 1× Legendary duplicate +3 | **Mythic** (S-tier only) |
| Mythic | 1× Legendary duplicate +3 | Mythic +1 |
| Mythic +1 | 1× Legendary duplicate +3 | Mythic +2 |
| Mythic +2 | 1× Legendary duplicate +3 | Mythic +3 |
| Mythic +3 | 1× Legendary duplicate +3 | Mythic +4 |
| Mythic +4 | 1× Legendary duplicate +3 | **Chaotic** (S-tier only) |

**Chaotic gear requires 14 copies of the same S-grade piece** [V:SWt0cYOM0kM] — counting the Legendary +3 duplicates required to push from Mythic to Chaotic. This is the **explicit P2W wall**.

### 5.4 Quality skill timing

- **Non-S gear** ("normal" variants like Echo/Destruction/Decisiveness): Major Quality Skill unlocks at **Legendary** tier. Caps at **Legendary +3**. [GV:Guide:Ultimate_Beginners_Guide]
- **S gear** (Oracle/Dragon Knight/Griffin): Major Quality Skill unlocks at **Epic** tier (earlier!). Can be pushed to **Chaotic**.

[INFERRED: Habby's deliberately giving F2P a usable "set complete" feeling at Legendary +3 while reserving the lategame power curve for S-gear whales.]

### 5.5 Per-set quality skills (representative — Oracle weapon)

[GV:Gear, "All Gear" table — Oracle Light Spear row, verbatim]:

| Tier | Effect |
|------|--------|
| Fine | ATK PWR +5% |
| Rare | ATK PWR increases with combo, up to 10% (reached at 20 combo). For every 5 combo, CRIT Rate +2%, up to 8% |
| Epic | ATK PWR +10%; Weapon's base stats +20%; For every 5 combo, CRIT Rate +4%, up to 16% |
| Legendary | Weapon's base stats +30% |
| Legendary +3 | Weapon's base stats +40% |
| Mythic | The more enemies the main weapon hits, the higher the next attack's DMG |

[INFERRED: Each set's *Mythic* quality skill is the build-defining "I am this set" effect. Examples from [GV:Gear]:]
- Oracle Mythic Boots: 20% DMG REDUC when stationary (rewards Stand Strong builds)
- Griffin Mythic Helmet: Higher ATK SPD at closer distances, up to 100% (rewards melee close-up)
- Dragon Knight Mythic Crossbow: +5% Main weapon DMG per skill taken in battle (up to +50%) — scales with run length

### 5.6 Blacksmith rules (community consensus, F2P)

[GV:Gear; GV:Guide:Ultimate_Beginners_Guide; V:ffZpg7ndjLA, Kosh; V:lEb22efbhjs, Archer Greene]:

1. **All gear up to Epic can be safely fused.** [GV verbatim]
2. **NEVER fuse S-tier gear.** Universal rule across all 3 beginner-guide videos in the corpus. Use S only for its slot, fodder non-S into S.
3. Non-S gear: **cap at Legendary +0** specifically as a fodder material pool for S-tier upgrades. (Most explicit guidance from [V:lEb22efbhjs].)
4. Universal material can substitute for "same-slot gear" fodder — fungible across slots. [GV:Gear]

---

## 6. Skills (covered in §3 — in-run only)

Skills are runtime-only — they reset every run. The skill list lives in [GV:Skills] (full table). 80+ unique skills. See §3.6 for the full rarity breakdown.

The single design principle worth calling out separately: **skills are pure roguelite randomness, but the rune & talent layer below adjusts the RNG odds**. The Rabbit's Foot Blessing rune at Epic+2 gives "Chance of obtaining high-quality rewards upon meeting Valkyrie increases by 20%" [GV:Runes]. The Glory talent card gives "First Skill Selection Chance +1" [GV:Talent_Cards]. So **meta progression tilts the in-run RNG** — this is the core economy hook.

---

## 7. Runes

### 7.1 Slots

[GV:Runes]:
- **Blessing Rune × 2**
- **Ability Rune × 4**
- **Enhancement Rune × 4**
- **Etched Rune × 3**

**Total: 13 simultaneous runes.** [GV:Runes — "There are 4 types of runes... you can equip one of each in their respective slots"]

[INFERRED: The 13-slot rune system is the densest gear layer in the game. With 100+ rune varieties and 10 rarity tiers each (Normal → Mythic), the combinatorial space is huge — this is the "depth" hook for mid-core players who want to optimize.]

### 7.2 Rune varieties (high-level)

[GV:Runes — full tables, abbreviated here]

**Blessing runes (7 varieties):** Revive (50%/100% revive at half HP), Lucky Shadow (luck+dodge), **Intelligence** (in-battle EXP, Mythic = +1 max level), **Rabbit's Foot** (rare-skill chance), Guardian (DMG taken -%), Devil Pact (devil chance +%, HP cost -%), Resilience (ATK → HP conversion)

**Enhancement runes (13):** Sharp Arrow, Flame-Poison Seal, Frost-Thunder Seal, Rotating SPD Up, Sawblade Circle, Giant Meteor, Potion Magnet, Sprite Multishot, Sprite Link, Dragonflight Sword, Ricocheting Strike, Rootguard, Vine Bind

**Ability runes (13):** Arrow Rain, Flame-Poison Touch, Frost-Thunder Touch, Ring of Agony, Circle, Star of Fury, Star of Time, Healing Sprite, Melee Sprite, Sword of Time, Strike Potion, Plant Summon, Equinox Bloom

**Etched runes (13):** Arrow Of Echoes, Elemental Domain, Pulsing Orb, Meteor Split, Sprite's Awe, Sword Strike Split, Sprite Assist, Sword Strike Aerie, Potion Spring, Elemental Crit, Life Surge, Orbital Orb, Echo Scythe

### 7.3 Highest-priority runes (community consensus)

[V:SWt0cYOM0kM, iPICKmyBUTT — most authoritative single source on rune meta]:
- **Revive Blessing rune = universally #1 priority.** "50% on-death revive" effectively doubles your effective HP per run. Mythic = 100% revive.

[V:eTxwhXcZ48k; V:GH1iVtcWgzg]:
- **Sharp Arrow Enhancement** for projectile builds — Mythic gives +30% Main weapon DMG and +4 bounces
- **Frost-Thunder Seal** for Rolla/Thor (ice/lightning compatible)
- **Arrow of Echoes Etched** = aspirational — "for each Main Weapon skill obtained, Main Weapon DMG is increased (max 10 stacks)" + projectile-web behavior

[GV:Runes "Devil Pact"]: At Mythic, Devil HP cost becomes *direct HP* (no Max HP reduction). Powerful for Seraph-Devil aggressive builds.

### 7.4 Rune Workshop (merging)

[GV:Runes — verbatim merge table]:

Normal → Fine → Rare → Epic → Epic+1 → Epic+2 → Legendary → Legendary+1/+2/+3 → **Mythic**.

Each step requires **2× duplicate** of the same rune at the same tier.

[INFERRED: Rune merging is the longest grind in the game — to get one Mythic rune you need 2^9 = 512 normal-rune copies. The reason **Rune Ruins** (see §10) is the central daily — that's where the duplicates come from.]

### 7.5 Twinborn Rune Workshop (v1.1.6 patch — newest power lever)

[V:FaZlxQNpK9U, Grinnn, 2026-05-15, just 3 days before this research]:

> Twinborn Rune = **fuse 2 same-class runes into 1 slot** — effectively doubling rune power in that slot. Requires 1 Mythic rune to unlock. Creator calls it "biggest power jump yet."

[INFERRED: This is a major late-game ceiling raise. Mythic rune fusion was the previous endgame; Twinborn now lets whales double-stack. Watch for whether F2P pull rates support this or whether it becomes the next P2W wall.]

### 7.6 Rune Enchantments

[GV:Runes — extensive enchantment tables]

Rune Enchantment is a second layer of upgrades that **unlocks at Rare tier** (verbatim from each rune's "Rare" column: "Unlocks Rune Enchantment").

The enchantment system uses **Enchantium** currency [GV:Currency_and_Items] obtained from Rune Ruins daily play.

Generic enchantments per rune tier (universal across rune types):
- **Normal**: small flat ATK/HP bonus
- **Fine**: ATK/HP + 0.3% boss/minion DMG
- **Rare**: ATK/HP + 0.5% boss/minion DMG
- **Epic**: ATK/HP + 2% boss/minion DMG + 4% CRIT DMG
- **Legendary**: 7.5% boss/minion DMG + 15% CRIT DMG
- **Mythic**: 15% boss/minion DMG + 30% CRIT DMG

Per-rune-specific enchantments add unique effects (e.g., Sharp Arrow Legendary: "Main Weapon DMG+15%, Main Weapon CRIT Rate+15%, Main Weapon bounces +2"). Mythic versions roughly double these.

[INFERRED: The enchantment-on-top-of-rarity system is the second-most-elaborate progression layer in the game (after gear merging). Habby has engineered this to never feel "complete" — even at Mythic gear you're still chasing better enchantments.]

### 7.7 Rune base stats by tier

[GV:Runes — full base-stat table, abbreviated]:

| Tier | Enhancement | Ability | Blessing | Etched |
|------|-------------|---------|----------|--------|
| Normal | ATK +20 | HP +80 | — | — |
| Mythic | ATK +1500 | HP +6000 | ATK +900 / HP +3600 | ATK +4500 / HP +18000 |

**The Etched runes are the most powerful per-slot** (you only get 3 slots vs. 4 Enhancement/Ability) — Mythic Etched gives **+4500 ATK and +18000 HP**, dwarfing all other rune contributions. This explains why community ranks Arrow of Echoes Etched as endgame priority.

---

## 8. Talent Cards (Meta Stat Bonuses)

[GV:Talent_Cards — verbatim, full list]:

Talent Cards are an account-wide passive stat layer. Most cards max at **5 stars** (1 star for Glory and Tactics).

**First-tier cards (always available):**
- **Glory** — First Skill Selection Chance +1 (1-star max — exists only at 1★)
- Vigor — Max HP +300
- Strength — ATK PWR +75
- Recovery — Red Heart Heal +75
- Iron Wall — Collision DMG REDUC +36
- Super Vigor — Max HP +420
- Super Strength — ATK PWR +105
- Super Recovery — Red Heart Heal +105
- Super Iron Wall — Collision DMG REDUC +48
- Healing — Heal on Level Up +120
- Titan — HP +150, ATK PWR +36, CRIT DMG +6%
- Swift Wind — ATK SPD +3%, MOV SPD +3%
- Refinement — Gears Base Stats +6%
- Wealth — Gold obtained in battle +18%
- Super CRIT Rate / Super CRIT DMG / Super Dodge — small CRIT/dodge layers
- Ult CRIT Rate / Ult CRIT DMG / Ult Dodge — larger CRIT/dodge layers

**Tier-2 cards** (unlock after collecting all tier-1) [GV verbatim "The second set of talent cards [2] is unlocked after collecting all cards from the first set"]:
- **Tactics** — Skill Refreshes +1
- Master Explorer — Scroll Drop Rate +6%
- Brave Adventurer — Gear Drop Rate +6%
- Alchemist — Rune Drop Rate +6%
- Vigor 2 / Strength 2 / Recovery 2 (each +HP/ATK/Heart Recovery)
- Super Vigor 2 / Super Strength 2 / Super Recovery 2 (larger)
- Angelic Embrace — Angel Recovery +0.2% per star
- Devil Discount — Devil's Pact HP cost reduced +0.2% per star

[INFERRED: This is a "complete the set" mechanic — gating tier-2 behind tier-1 completion forces breadth-first acquisition before optimization. Players can't min-max a single talent line until they own all base cards.]

**Currency for upgrading:** Gold [GV:Currency_and_Items "Gold is the main Currency in Archero 2. It is used to Draw Talent Cards and Upgrade Gear"]. **This is why gold is the F2P chokepoint** — it's spent both on gear upgrades and talent card draws.

[V:kpIdlbhx4s8 confirms gear upgrades cost 180-200K gold per item at mid-level — and gold acquisition is heavily gated.]

---

## 9. Artifacts

[GV:Artifacts]:

Artifacts are obtained via **Wish Tokens** spent in the shop's Wish tab. Each Artifact can be raised to **15 stars**; each star adds +50% base stats.

### 9.1 Pool composition

| Rarity | Count seen in wiki | Examples |
|--------|---|----------|
| Mythic | 18 | Cupid's Arrow, Demon King's Eye, Goldfinger, Golden Fleece, Pan's Flute, Tidal Conch, Voidblade, Aeon Spire |
| Legendary | 16 | Cupid's Bow, Brisingamen, Dragon Heart, Healing Grail, Bull Skull, Magic Harp, Quiet Quill |
| Epic | 7 | Magic Lamp, Magic Carpet, Poison Apple, Laurel Wreath, Four-Leaf Clover, Crystal Shoe, Red Hood |
| Rare | 5 | Gladiator's Helm, Pumpkin Lantern, Supreme Staff, Iron Throne, Sword in the Stone |

### 9.2 Pull rates (Wish tab)

[GV:Pull_Rates]:

| Artifact rarity | Single-pull % |
|-----------------|---------------|
| Mythic | 0.1% |
| Legendary | 1% |
| Epic | 9% |
| Rare | 18% |
| Epic shards | 24% |
| Rare shards | 47.9% |

**Pity:** [GV:Artifacts] "guaranteed a Legendary or Mythic Artifact if you unsuccessfully find one within 100 wishes."

### 9.3 Artifact sets

Sets of 3 artifacts give multiplicative stat bonuses at 3/6/9/12/15 stars per set. Example: **Golden Dragon's Treasure Set** (Golden Fleece + Golden Mask + Goldfinger): at 3★ each = ATK +12%, HP +12%; at all 15★ = ATK +42%, HP +42% [GV:Artifacts].

[INFERRED: Artifact sets are the late-mid-game power lever once gear is near-Legendary. They're acquired via Wish, which is gated by Wish Tokens — primarily earned in Sky Tower [GV:Artifacts "Wish Token... obtained from Sky Tower, Tasks, Purchases, Events"]. This is one of the reasons Sky Tower can't be optional — it's the artifact-pull pipeline.]

### 9.4 Artifact special stats

[GV:Artifacts] — every Epic+ artifact has a "Special Stat" beyond base ATK/HP. Examples:
- Demon King's Eye (Mythic): Player DMG reduced by 8%
- Goldfinger (Mythic): DODGE +4%
- Pan's Flute (Mythic): CRIT Rate +4%
- Tidal Conch (Mythic): CRIT DMG +16%

These special stats are the build-defining picks.

---

## 10. Currencies & Resources (Full Index)

[GV:Currency_and_Items — full list]:

### 10.1 Main currencies

| Currency | Source | Spend |
|----------|--------|-------|
| **Gold** | Battle drops, chests, daily quests, Gold Cave | Gear upgrades, Talent Card draws — the F2P chokepoint |
| **Gems** | Quests, daily, Sky Tower, events, IAP | Chest keys, shards, tickets, shovels (premium) |

### 10.2 Gear Scrolls (6 types — one per gear slot)

Weapon, Armor, Helmet, Ring, Amulet, Boots — each used to upgrade its respective slot. [GV:Currency_and_Items]

### 10.3 Chest Keys (3 types)

| Key | Opens | Pull Rate Headline |
|-----|-------|-------------------|
| Silver Chest Key | Silver Chest | 33.33% Fine, 66.67% Normal [GV:Pull_Rates] |
| Obsidian Chest Key | Obsidian Chest | 4% Epic, 40% Rare, 56% Fine [GV:Pull_Rates] |
| **Chromatic Chest Key** | **Chromatic/Mythstone Chest** | **1.46% Epic S, 2.18% Epic, 38.18% Rare, 58.18% Fine** [GV:Pull_Rates] |

**Mythstone Chests** are *specific-type* Chromatic Chests — they rotate every **3 days** (per [GV:Pull_Rates] which says 3-day) or **4 days** (per [V:eTxwhXcZ48k, Sept 2025] — likely a patch update) cycling through **Griffin → Oracle → Dragon Knight**.

**[INFERRED: This rotation is the single most economically-significant timing pattern in the game.** Players save gems for their target set's rotation window. Missing your rotation = 6-12 day wait. This is structural F2P pacing.]

### 10.4 Character Shards (8 types currently named in wiki, but 17 heroes total)

[GV:Currency_and_Items lists]: Alex, Nyanja, Helix, Seraph, Dracoola, Rolla, Otta, Atreus shards. [INFERRED: 9 newer heroes (Hela, Mymu, Hou Yi, Loki, Phynx, Nezha, Thor, Cleo, Wukong) probably have shards too but the wiki page is dated 2025-10-28 — likely pre-some additions. Verify against current shop.]

### 10.5 Other items

| Item | Use |
|------|-----|
| **Shovel** | Rune Ruins digs (1 shovel = 1 dig, OR 200 Gems) [GV:Rune_Ruins] |
| Promised Relic Shovel | Promised Ruins event |
| **Gold Cave Ticket** | Gold Cave attempts |
| **Seal Battle Ticket** | Seal Battle attempts (event/mode) |
| **Arena Ticket** | Arena battles |
| **Sky Tower Ticket** | Sky Tower attempts (3/day + 3 via ads = 6 max free) [GV:Sky_Tower] |
| Dice | Monopoly event |
| **Guild Gold** | Guild shop |
| **Wish Token** | Artifact wishes |
| Balloon Ticket | Bingo event |
| **Enchantium** | Rune enchanting |

[INFERRED: The proliferation of ticket-currencies is intentional — each mode has its own ticket, so a player can't binge-spend on one favorite mode. The whole system is "do something in every mode every day." This is a textbook AFK Arena / Hero Wars-style daily-routine engine.]

### 10.6 Energy

[GV:Campaign]:
- **5 energy per Campaign attempt**
- **30 base max** (50 with Hunting Warrior Card subscription)
- **12 minutes per 1 Energy regen** → 6 hours to fully refill 30 energy from empty
- Energy is **not** required for Sky Tower, Arena, Gold Cave, Rune Ruins, etc. — those each have their own ticket

**Daily energy budget:** 30 starting + ~110 from 22 hours of regen = ~**140 energy/day** = ~**28 campaign attempts/day** F2P [INFERRED: math from GV:Campaign].

---

## 11. Meta Progression Layers (multi-axis tower)

A player's account power is the product of **8 simultaneous progression axes**:

| # | Axis | Pacing | Source |
|---|------|--------|--------|
| 1 | **Hero level** (per-hero) | Per-hero XP gained in battle | Battles |
| 2 | **Hero stars** (per-hero, 0–8★) | Shards | Quests, events, shop, Arena Shop |
| 3 | **Hero Resonance** (3★/6★ unlock) | Hero star progression | (same as #2) |
| 4 | **Gear merging** (Normal → Chaotic) | Duplicates + materials | Chromatic Chests, daily Silver/Obsidian |
| 5 | **Gear upgrades** (Gear Scrolls + Gold per slot) | Scrolls + gold | Battle drops, events |
| 6 | **Rune merging** (Normal → Mythic) | Duplicates | Rune Ruins |
| 7 | **Rune enchantments** | Enchantium | Rune Ruins daily |
| 8 | **Talent Cards** (5-star ceiling, 2 tiers) | Gold to draw | Talent draws |
| 9 | **Artifacts** (0–15★, with set bonuses) | Wish Tokens | Sky Tower, tasks, events |
| 10 | **Character Codex** (v1.1.6) | Hero stars + skins | Skin purchases + star progression |

[INFERRED: That's **10 progression axes**. No single one closes out — they're all asymptotic. The brilliance of this design (and its danger) is that every play session pushes 3–5 axes a tiny amount, so players always feel they're "progressing." The danger is that *no axis ever feels finished*, which is the underlying engine of the burnout complaints we see at Chapter ~30-40 in [REVIEWS].]

---

## 12. Game Modes

### 12.1 Regular (Daily) Events

[GV:Events]:

#### Campaign — the main mode
[GV:Campaign]:
- **95 chapters** named (Moonlight Forest, Cloud Dreamland, ... Bloodlit Altar)
- 3 chapter formats per chapter: Rooms (50 + 5 bosses), Waves (50 + 5 boss waves), Timed (6 min + 2 boss spawns)
- Each chapter has 6 progress milestones (10/20/30/40/50 or 1-6 min) yielding sequential rewards: Gold → Silver Key → Gems+Energy → Obsidian Key → Gold → Gems+Energy
- Energy: 5/attempt, 30 base max, 12 min/regen
- Vanity-only leaderboard

#### Sky Tower — the most controversial mode
[GV:Sky_Tower; REVIEWS]:
- 5 consecutive floors per session
- 1 Sky Tower Ticket per attempt; **3/day + 3 from ads = 6 free attempts/day**
- After each floor: Valkyrie skill choice (no other NPCs)
- Rewards: Gems, **Ruin Shovels** (only source for many players), Gear Scrolls
- Every 25 floors: bonus Gems + Obsidian Chest Key + extra Shovels
- "Sky Tower also has a Leaderboard, but there are no rewards, just a vanity metrics" [GV verbatim]

**The forced-progression complaint:** Sky Tower **gates campaign chapter unlocks**. [V:lEb22efbhjs]: "Chapter 40 requires Sky Tower level 450." This is the **#1 negative theme** in [REVIEWS] (262 reviews mention it; top-thumbed 1★ at 447 thumbs).

**Why this design exists [INFERRED]:**
1. Sky Tower runs out the 6 daily tickets fast (~30-45 min of play), forcing a session break that resets daily.
2. Gating chapters behind Sky Tower forces engagement with both modes — players who only want chapters can't ignore Sky Tower.
3. **Wish Tokens** (Artifact pulls) come primarily from Sky Tower — without it players can't progress artifacts.
4. **Shovels** (Rune Ruins fuel) come primarily from Sky Tower — without it players can't progress runes.

The design forces a session to touch ≥3 modes (chapters + Sky Tower + Rune Ruins). It's a textbook mid-core retention pattern. **Whether it's worth the visible churn impact is the open question** — the 4.49★ rating suggests yes, but the visible 1★ cluster suggests there's a vocal segment Habby is losing.

#### Arena — PvP (auto-resolve)
[GV:Arena; V:eTxwhXcZ48k]:
- Open daily UTC 00:00–16:00
- 1 Arena Ticket per match (daily allotment + ad refills)
- Best-of-3 auto-battle (spectator only)
- 3 random skills assigned per round, 3 more added each subsequent round
- Equipped gear + runes apply
- **Crucial mechanic** [V:eTxwhXcZ48k]: **Outcome is determined server-side at battle start.** You can quit immediately and the result auto-resolves — **"100% success rate" exploit** to skip animation time.
- 6 tiers: Bronze (50 players) → Gold (100) → Diamond (200) → Master → Transcendent → Supreme
- Weekly season Monday UTC 0:00 → Sunday UTC 23:50
- Master tier rewards (verbatim from GV):
  - Top 1: 5000 Gems, 50k Gold, 500 Gear Scrolls, Frame
  - Top 2: 4000 Gems, 45k Gold, 450 Gear Scrolls
  - Top 121–999999: 1000 Gems, 14k Gold, 140 Gear Scrolls

[INFERRED: 1000 Gems/week from being "in Master tier at all" is ~52,000 Gems/year — a major F2P income source if you can hit Master.]

#### Gold Cave — gold farming mode
[GV:Gold_Cave]:
- 10-wave structure: enemy waves alternating with **Roulette rewards** (Gear Scrolls, Gold, Gems)
- Wave 9 = Boss, Wave 10 = double-rewards roulette
- 1 Gold Cave Ticket/attempt; daily allotment + ad refills
- "Difficulty based on Gold Cave level" — pick lower for easier completion
- **Gold drops from enemies = primary Gold source** [INFERRED: this is *the* gold farm]

#### Rune Ruins — the daily must-do
[GV:Rune_Ruins; V:k3mxy2oWlAE — month-long study confirming randomness]:
- **3×3 grid** of hidden tiles per dig session
- Tile composition: 4 Upgrade tiles, 2 ×2 (doubler) tiles, 3 Keys
- **Mechanic:** Reveal tiles one at a time. Finding 2 Upgrades = chest rarity tier up. Finding 2 ×2 tiles = chest count doubled. Finding 2 of the 3 Keys ENDS the session.
- Cost: **1 Shovel** (or 200 Gems) per dig
- 5× dig option (uses 5 shovels, scaled rewards — **cosmetic convenience only**, no math benefit [V:k3mxy2oWlAE])
- Daily free refresh of the grid (player must claim)

**Chest pull rates** [GV:Pull_Rates]:

| Chest | Epic | Rare | Fine | Normal | Requires |
|-------|------|------|------|--------|----------|
| Rusty Chest | — | — | 7.2% | 28.8% | — |
| Sturdy Chest | — | 10% | 40% | — | 2 Upgrades |
| Glorious Chest | 2.8% | 11.2% | — | — | 4 Upgrades |

Revive rune is rarer — **0.15% in Sturdy** vs. 0.30% for other Blessing runes.

[V:k3mxy2oWlAE confirms via month-long photographic study that **tile placement is fully random** — there is no pattern to exploit.]

### 12.2 Occasional Events

[GV:Events] lists these as rotating:
- **Island Treasure Hunt** (Otta shards historically [V:3rPvl1xCvAw])
- **Angler's Bounty** (fishing)
- **World Tree's Pulse**
- **Demon King Clash**

Plus events documented in videos but not yet wiki'd:
- **Shackled Jungle** [V:W43vRnoT7ZQ, Apr 2025] — 6-min timed survival with bosses at 2/4/6/8/10 min; rewards capped at 2-min mark
- **Carnival 1 & 2** [GV:Events] — onboarding event giving Dragon Knight Crossbow to new players
- **Umbrella Tempest** [V:GH1iVtcWgzg] — weekly resource event with hard caps (30/10/2500/week)
- **Eon Core Event** [V:3ixTDUf0nvY] — Legendary hero acquisition (Thor, Demon King); progress persists across cycles (key F2P note)
- **Warden Revival** [V:FaZlxQNpK9U] — scheduled June 6–12 2026

### 12.3 One-time Events

[GV:Events]:
- **Carnival** and **Carnival 2** — new-player onboarding events; single use per account

### 12.4 Modes documented in videos not in wiki

- **Quick Hunt** [V:kpIdlbhx4s8] — auto-farm of highest cleared chapter; limited tickets (Unlimited via paid Hunting Warrior Card subscription)
- **Seal Battle** [V:kpIdlbhx4s8] — daily PvP-ish; Sealing Master Card gives +1/day = +7/week extra
- **Monster Invasion (Guild)** [V:KrXJHpk_uXU; V:CdZ122DGL_A] — guild-coop boss fight; source of some hero shards
- **Peak Arena / GvG (Guild vs Guild)** [V:3ixTDUf0nvY] — appears to be a separate PvP tier above standard Arena
- **Hunt (no-attack exploit)** [V:GH1iVtcWgzg] — claim Hunt rewards by entering and immediately exiting without attacking ("100% success rate")
- **Dragon Gate** [V:FaZlxQNpK9U] — golden tickets, may become permanent in upcoming patch

---

## 13. Monetization

### 13.1 IAP price ladder (Gem packs)

[V:PtgbAzxp4rM, MondoMan, Sept 2025, OCR confirmed]:

| Price | Gem amount | Marker |
|-------|------------|--------|
| **$0.99** | 80 Gems | starter (limited count) |
| **$9.99** | 1,200 Gems | mid pack |
| **$19.99** | 2,500 Gems | "400% value" badge |
| **$25.99** | 3,300 Gems | "400% value" badge |
| **$49.99** | 6,500 Gems | "400% value" badge |

[V:lEb22efbhjs confirms similar ladder with €4.99 / €9.99 / €24.99 in EUR markets.]

**Visible "Purchases left: N" counters** [V:PtgbAzxp4rM] = all packs are limited-time/count, encouraging quick buy decisions.

### 13.2 Subscriptions (Cards)

[V:kpIdlbhx4s8, Archer Greene; V:lEb22efbhjs cross-confirmed]:

| Card | Price | Benefit | Creator rating |
|------|-------|---------|----------------|
| **Permanent Supply Card** | ~$5.99/€6 one-time | **+800 diamonds/day forever** | **#1 deal in game** [universal] |
| **Permanent Ad-Free** | ~$5.99/€6 one-time | +20 diamonds/day, no forced ads | Top 5; high QoL value |
| **Monthly Diamond Card** | €6/month | 12,000 diamonds/month (~400/day) | Solid value, recurring |
| **Hunting Warrior Card** | €6 (period unclear) | +20 energy cap (30→50), 20% AFK boost, unlimited Quick Hunts | #2 — "Quick Hunt unlimited is huge" |
| **Cave Explorer Card** | €6 | +2 Gold Cave attempts/day | "Least valuable" |
| **Sealing Master Card** | €6 | +1 Seal Battle attempt/day (+7/week) | **"Most P2W card in the game"** [V:kpIdlbhx4s8, exact quote] |

[INFERRED: The "Permanent" + "Daily" card stack is genius monetization psychology. Players see "800 diamonds/day forever" and amortize the $6 over months — it feels like a no-brainer. Once locked in, the player is anchored into the daily login routine. Multiple creators independently rate Permanent Supply Card as the #1 spend — this is the conversion funnel.]

### 13.3 Direct character purchases

[V:3rPvl1xCvAw]:
- **Seraph: $30 USD** (Epic hero direct unlock)
- **Dracoola: $30 USD** (Epic hero direct unlock)

[INFERRED: $30 hard unlock for two top-tier heroes is the second tier of monetization. Cheaper than chasing shards via gacha.]

### 13.4 Battle Pass

[V:kpIdlbhx4s8 mentions but rates as "too expensive."]
[V:lEb22efbhjs rates as ~€40 with "good relative value if you'll play through it."]

[ASSUMED: Standard mobile Battle Pass shape — free + premium tracks with cosmetic and currency rewards. Specific price tiers not consistently documented in the corpus.]

### 13.5 Event packs / Growth packs

[V:kpIdlbhx4s8]: "Event packs and Growth packs rated as best value buys when available."

[INFERRED: These are scaled-to-progression bundles. The "Growth Pack" pattern (common in Habby/MoonActive games) typically gives a fixed reward for low price, refreshing as you hit chapter milestones.]

### 13.6 Gear & Rune gacha

- **Chromatic Chest / Mythstone Chest**: 1.46% Epic S-tier per pull. Pity at 50 pulls per [V:ffZpg7ndjLA, Kosh].
- **Rune Ruins Glorious Chest**: 2.8% Epic per pull; 4× upgrade tiles required to unlock per dig.
- **Wish (Artifacts)**: 0.1% Mythic, 1% Legendary; pity at 100 wishes.
- **Hero shard packs**: time-limited event purchases (varies)

### 13.7 Daily / weekly shop offers

[V:kpIdlbhx4s8; V:LkzThHCkFjA]:
- Daily shop refresh with hero shards (gem-purchased) — **explicitly rated #1 F2P daily action** by multiple creators [V:LkzThHCkFjA, iPICKmyBUTT, "BEST Way to SPEND Your GEMS"]
- Weekly shop with epic runes, gear, materials
- Arena Shop (VS tickets): hero shards at 5,400 VS, epic runes at 20,250–30,750 VS [V:PtgbAzxp4rM]

### 13.8 Monetization summary

**Spend ladder Habby is offering:**

| Tier | Spend | What you get |
|------|-------|--------------|
| **Dolphin minimum** | $0–$0.99 | F2P; first pack |
| **Light spender** | $5.99 one-time | Permanent Supply Card — "best deal in game" |
| **Mid spender** | $5.99 + $9.99/mo | + Monthly Diamond Card |
| **Committed F2P-2P** | $20–$50/mo | + Battle Pass + Growth Packs + select event packs |
| **Whale** | $30 character + $19.99 chests + ... | Direct character unlocks, chromatic chest spam |
| **Mega-whale** | $5,000+ | [V:SWt0cYOM0kM disclosure]: chaotic-tier gear |

[INFERRED: The Permanent Supply Card is the killer SKU — universally praised, low price, captures lifetime value. This is a sophisticated funnel. Players who buy it are likely 5× ARPU over players who don't, per typical mid-core mobile economics. **Recommend Lila study this card pattern specifically.**]

### 13.9 [REVIEWS] sentiment on monetization

**1,220 reviews mention pay/money/spend** [REVIEWS]. The cluster splits sharply:

**Positive (5★):**
> "I don't HAVE to buy micro transactions to stay competitive, but the ones available are WORTH THE MONEY. Ive played games where 50$ doesn't even level up a weapon. Here, as little as 4.99 gets you MULTIPLE upgrades" — 292 thumbs

**Negative (1★):**
> "the prices for next to nothing is ridiculous" — 193 thumbs
> "Watched a lot of ads, make a purchase and still ZERO. The epic items doesn't even do that much" — 116 thumbs

[INFERRED: The split correlates with **whether the player has hit the Sky Tower / Chapter 30-40 wall**. Pre-wall players think the monetization is fair. Post-wall players resent it. This is a **bad churn signal** for late-mid players regardless of how good early-game perception is.]

---

## 14. UI / UX Patterns

### 14.1 Visual density problem (most-cited UX issue)

[V:jCpmNrXYJsc, Kosh, verbatim quote]:
> "this is the major problem with the game because of all those flash effects here it's so easy to get hit randomly because you can't truly see what the hell is happening"

The game ships with **Effect Reduction setting** [GV:Tips_and_Tricks; V:VGFEPNdXhAE] — the *existence* of this setting is a tell that the default state is unreadable at peak build.

**Three mandatory settings flagged by every beginner-guide creator:**
1. Hide Joystick (ON) — virtual joystick blocks dangerous projectile view at advanced levels
2. Skip Skill Choice Animation (ON) — saves time
3. Effect Reduction (ON) — clears clutter

[INFERRED: These are **near-mandatory settings, but they default to OFF** — a baseline UX failure. Players who don't watch tutorials struggle with combat readability.]

### 14.2 Phone thermal throttling at peak build

[V:W43vRnoT7ZQ — Shackled Jungle event]: explicit observation that phones thermal-throttle when build density peaks (rings + swords + circles + meteor potion). 2× speed mode crashes mid-range phones.

[INFERRED: Habby's pushing the visual ceiling beyond what their min-spec hardware can sustain. This is a soft warning sign for the broader Android install base — most players aren't on flagship phones. Could be a contributing factor to the 5.7% 1★ rate even without explicit reviews flagging it.]

### 14.3 Promo code redemption friction

[V:VGFEPNdXhAE — full flow documented]:
- External portal: `https://gift.archero2.com/`
- Requires: 9-digit User UID + code + CAPTCHA
- Creator's first attempt fails on CAPTCHA — **explicit UX friction documented on camera**

Active codes [V:VGFEPNdXhAE]: `vip666` (3 Silver Keys), `v1g777` (500 Gold + 5 Gear Scroll), `v1p888` (200 Gems), `lucky2024/lucky2025` (20 Energy + 200 Gold) — all expire Dec 2025.

[INFERRED: The external-portal CAPTCHA flow is unusual — most modern mobile games redeem codes in-app. This is friction-by-design (perhaps anti-bot) but it loses casual players who can't complete the redemption.]

### 14.4 Auto-attack inheritance & build legibility

[V:KrXJHpk_uXU]: noted UI resembles Clash Royale. Top-down view with hero centered. Damage numbers scrolling. Already-obtained skill labels prevent confused duplicate selection.

[INFERRED: Habby is following genre conventions tightly here — there's no UX innovation, but also no obvious miss outside the visual density problem.]

### 14.5 OCR-confirmed UI elements

[Cross-video OCR — multiple videos]:
- Hero ability panel: 4-tier layout, lock icons for 5★/8★ gates
- "You've met an angel!" / "You've met the devil!" mid-run popups
- "DANGER!!" red scrolling alert for incoming boss
- Active skill orb with countdown
- Aura ring (Hela in-combat): large teal circle visible on arena floor
- Chest comparison UIs in shop
- "Purchases left: N" / "Sold Out" badges on shop items
- Star count and shard progress bars (N/50, N/100) on hero cards

---

## 15. The Core Loop (Multi-Scale)

This is the most important section in the doc. Habby's design intentionally **interlocks 5 loop scales**:

### 15.1 Loop 1 — Moment-to-moment (seconds)
Move → enemies attack → auto-fire kills mobs → enemies drop gold/heart/potion → next wave or level-up → skill choice.

**The dopamine beat:** every ~30-60 seconds, a skill choice or a boss kill or a wave transition. Vampire-Survivors-style **constant micro-reward**.

### 15.2 Loop 2 — Per-run (3–6 minutes)
Pick chapter → spend 5 energy → fight 50 waves/rooms or 6 min → collect drops + level up hero a few times → finish run → claim progress reward.

[INFERRED: 3-6 min run length is the **session-anchor** — it's an interruptible commute-friendly unit. Matches the "30 min/day" habit visible in [REVIEWS].]

### 15.3 Loop 3 — Per-session (15–30 min)
Open game → spend 30 energy (~6 chapter runs) → 6 Sky Tower runs (3 free + 3 ad) → 3 Gold Cave runs → 1-3 Rune Ruins digs → 5 Arena battles → claim daily quests → claim 2× free shop chest → log out for 6 hours.

**This is the daily playthrough.** [INFERRED from [GV:Guide:Ultimate_Beginners_Guide]'s recommended daily order:]
1. Claim Free Silver + Obsidian Chest daily
2. Events / dailies
3. Daily + Weekly Task List
4. Sky Tower
5. Guild stuff (Free Donation + Monster Invasion)
6. Push Chapters
7. Hunt mode
8. Spend extra energy replaying chapters

### 15.4 Loop 4 — Weekly (cycles within a week)
Mythstone Chest rotation cycles every 3-4 days (Griffin → Oracle → Dragon Knight). Players save gems for their target rotation.
Arena season Monday–Sunday — top tier rewards.
Rotating event windows (Carnival, Shackled Jungle, Umbrella Tempest, etc.).

### 15.5 Loop 5 — Long-term (months)
Unlock new heroes (1,600 shards per Rare/Epic to 8★; ~12 months F2P per hero [INFERRED from event-shard drip rate observed in videos]).
Push gear from Epic → Legendary → Mythic → Chaotic (whale wall at Chaotic).
Push Sky Tower beyond floor 450 to unlock Chapter 40+.
Push Arena up tiers (Bronze → Supreme).
Build Talent Card collection across two tiers.

[INFERRED: The 5 interlocking loops are why Habby has 4.49★. Every loop closes within its own time window, and progression on the longer loops happens automatically as you play the shorter ones. **A player who plays 30 min/day for 90 days has meaningfully progressed every loop scale**. That's the engagement engine.]

---

## 16. D1–D7 Player Experience (Day-by-Day)

This synthesizes the new-player journey from [GV:Guide:Ultimate_Beginners_Guide], [V:SWt0cYOM0kM], [V:jCpmNrXYJsc], [V:kpIdlbhx4s8], [V:lEb22efbhjs], and [REVIEWS]. Each day's specifics are calibrated to a typical F2P player playing 30 min/day.

### Day 1 (first session)

**What unlocks:**
- Tutorial run (likely 1-2 chapters)
- Alex (default hero) at 0★
- First gear pieces (probably Normal-tier weapon, armor)
- **Carnival event** opens — onboarding event giving **Dragon Knight Crossbow** [GV:Guide:Ultimate_Beginners_Guide; INFERRED: this is the first F2P S-tier weapon path]
- First gem allotment (a few hundred from tutorial)
- Daily quest system

**What players experience:**
- "**Surprisingly addictive**" — the most common 5★ adjective [REVIEWS: 240 thumbs]
- Visual polish + Archero IP recognition
- Easy first chapters (the "as hell mobile initiation" phase that 2★ reviews call out — implying intentional easy-onboarding [REVIEWS: 55 thumbs])
- First Mythstone Chest pull (Habby will frontload a guaranteed Epic likely [ASSUMED standard mobile pattern; not confirmed])

**Likely friction:**
- The "3 mandatory settings" (Hide Joystick, Skip Skill Animation, Effect Reduction) — D1 players don't change defaults
- CAPTCHA + UID dance if they try promo codes early [V:VGFEPNdXhAE]

### Day 2

**What unlocks:**
- **Sky Tower** likely unlocked (it's the 2nd-most-cited progression mode in the corpus; happens within first few chapters [ASSUMED: chapter 5 unlock, common for mobile mid-core])
- More skill pool exposure
- First daily-task cycle starts to land
- Maybe Nyanja or Helix shards from quests/events

**What players experience:**
- "lots of content" feeling kicks in
- First Devil pact (HP-for-skill) — emotional decision moment
- First boss without taking damage → first Devil encounter

**Friction:** Early skill RNG can be bad, low-roll runs hurt.

### Day 3

**What unlocks:**
- **Runes unlock at Chapter 5** [GV:Runes: "are unlocked upon reaching Chapter 5 in the main portion of the game"]. This is THE major D3 unlock for most players.
- **Rune Ruins** opens
- **Gold Cave** likely unlocked [ASSUMED: typical D3 unlock]
- **Arena** likely unlocked

**What players experience:**
- The "many things to do daily" sensation kicks in. **This is when the retention machine starts working.**
- First Rune Ruins dig — moment of "ooh, mini-game"
- First Gold Cave Roulette spin
- Players who hit this point likely become D7+ retained [INFERRED]

**Friction:**
- Information overload (many new currencies)
- First Energy stall — if they played long they're now out of energy and confused what to do

### Day 4

**What unlocks:**
- **Resonance** (if any hero hit 3★ — possible with focused shard spending)
- Talent Cards likely [ASSUMED: progression-gated unlock around here]
- Guild invitation likely (Guild Monster Invasion unlocks gold + shards)

**What players experience:**
- "I have a build now" feeling
- First gear merge to Rare or Epic
- First Sky Tower 25th floor bonus (Obsidian Key)

**Friction:**
- **First "what do I spend gems on?" decision crisis** — Mythstone Chests vs. Wish Tokens. [GV:Guide:Ultimate_Beginners_Guide recommends 60% Mythstone / 40% Wish, F2P.]

### Day 5

**What unlocks:**
- **Carnival event progress** likely landing — Dragon Knight Crossbow F2P [GV:Guide:Ultimate_Beginners_Guide explicitly names Carnival as the D1-D7 goal]
- First Hunting / Quick Hunt
- Maybe enough shards for a 2nd-hero unlock

**What players experience:**
- "I have multiple heroes" — first Resonance slot active in runs
- First chapter 10+ where they realize bosses are getting harder

**Friction:**
- First gear-stuck moment (Epic → Epic+1 needs more chest pulls)

### Day 6

**What unlocks:**
- **First Arena weekly reset** — players in Bronze tier collect first weekly reward
- More events likely cycling in
- First "Permanent Supply Card" offer popup at $5.99 [INFERRED: typical mobile timing]

**What players experience:**
- First **monetization moment**. Players evaluate "is this worth $6?"
- Most-thumbed 5★ explicitly calls out **$4.99 first IAP as great value** [REVIEWS: 292 thumbs]
- Conversion rate likely peaks around D5-D10 [ASSUMED standard mobile pattern]

### Day 7

**What unlocks:**
- Likely Chapter ~10-15 — first **biome change** (Moonlight Forest → Cloud Dreamland → Autumn Ruins → Breeze Prairie → Shadow King City) [GV:Campaign chapter list]
- First Battle Pass tier progression
- Maybe first Talent Card 5-star

**What players experience:**
- "**I see myself playing this for months**" — the most common transition statement implied in 5★ reviews ("Been playing 2 months, 30 min/day")
- First *real* gear merge to Legendary likely happens in this window for engaged players

**Friction starts:**
- Sky Tower starts to feel like a chore for some
- "Why am I climbing this tower again?" — early signal of the eventual #1 complaint
- Chapter unlock gates start being mentioned in chats/guilds

[INFERRED: D1-D7 retention is genuinely strong — the multi-loop design, polish, and 4.49★ rating support this. The risk window is **D14-D30** when the Sky Tower gate first slows people down, and **D45-D60** when the chapter 30-40 difficulty cliff hits. The corpus contains explicit "I was on one level for 2 weeks" 1★ reviews — that's the wall.]

---

## 17. Why Players Come Back (Retention Drivers)

Synthesized from [REVIEWS] 5★ + 1★ patterns, video commentary, and design analysis. Ordered by signal strength:

### 17.1 "Just one more session" — variable-reward roguelite loop (highest signal)

The per-run randomness (3-card skill picks, NPC encounter chances, Devil pact decisions, mid-run drops) gives every session a **lottery quality**. Players don't know which build they'll get. This is genre-validated for retention (Vampire Survivors, Hades, Dead Cells).

[REVIEWS: "Archero 2 is surprisingly addictive. I kept seeing ads and finally gave it a shot — haven't touched my other games since." — 240 thumbs]

### 17.2 Daily ticket-mode rotation = "always something to do"

8+ daily modes (chapters, Sky Tower, Arena, Gold Cave, Rune Ruins, Quick Hunt, Seal Battle, Monster Invasion) — each with its own ticket economy. A 30-min daily session can touch 5-6 modes. **Habit formation lever.**

[REVIEWS: "Been playing for a little over 2 months now, about 30min a day" — 240 thumbs (5★)]

### 17.3 Multi-axis progression — you always made *some* progress

10 progression axes (§11). Even an awful run gives:
- Hero XP (Loop 5)
- Daily quest progress (Loop 3)
- Maybe a gear scroll (Loop 5)
- Energy regenerated while playing other modes (Loop 4)

Players never feel like they "wasted time." This is the highest-value design pattern in mid-core mobile.

### 17.4 Skin/Codex collection (post-v1.1.6) — collection psychology

Recent Character Codex change means owning more skins = more stats. **Activates collection mindset** for players who previously didn't care about skins. [V:FaZlxQNpK9U]

[INFERRED: This is a deliberate retention re-leverage by Habby — getting older players to engage with a new system. Will likely show up in metrics within 60-90 days post-patch.]

### 17.5 Event FOMO

Carnival (one-time, new-player), Shackled Jungle (timed event), Eon Core (limited hero acquisition), Demon King Clash, Warden Revival, etc. — **rotating windows force scheduled returns**.

[V:kpIdlbhx4s8: "Event packs are best value when available" — explicit FOMO confirmation.]

### 17.6 Social / Guild

Monster Invasion (guild boss), Guild Donation, Guild Gold, Peak Arena (GvG-like) — guild membership creates **social accountability** for daily login.

[REVIEWS: "no real point in guild participation" — 1★ 174 thumbs] — counter-signal that guild is rated as low-value by some players.

### 17.7 Visible spend value

The Permanent Supply Card and ad-free option are universally praised. Players who buy these feel they got a deal — that *feeling* keeps them engaged because they're amortizing.

[REVIEWS: 292-thumb 5★ explicitly praises **$4.99 = multiple upgrades.**]

### 17.8 Improvement over Archero 1

Returning Archero 1 players (a substantial cohort per review themes) get a polished sequel feeling. Improved visuals, deeper systems, retained core feel.

[REVIEWS: "First time I've ever pre-registered for a mobile game" — 193 thumbs (5★)]

---

## 18. What Players Like (Praise Patterns)

[REVIEWS — 1,574 reviews with fun/addictive/love keywords]:

Ranked by frequency:

1. **Visual polish** — "this game is gorgeous. From the UI, to the vfx, character designs, and animations" [193 thumbs 5★]
2. **F2P fairness in early game** — "completely f2p with a good bit of content" [240 thumbs 5★]
3. **$4.99 IAP value perception** — "as little as 4.99 gets you MULTIPLE upgrades" [292 thumbs 5★]
4. **Ad-free option** — "The ad-free option is cheap and comes with great perks" [240 thumbs 5★]
5. **Weekly rotating events** — "weekly rotating events that give you additional items free of charge" [240 thumbs 5★]
6. **Roguelite skill variety** — "tons of content"
7. **Comparison favorable to Archero 1** — "First time I've ever pre-registered..."
8. **Difficulty (some players love it)** — "I'm a fan of rougelike games like returnal and gunfire reborn, I enjoy that archero 2 is much more difficult" [193 thumbs]
9. **Roguelike speed-run / hit-less challenges** — "hit-less speedrun challenges of those stages" [240 thumbs]

**[INFERRED: The single most-loved feature is probably "I can get value without spending much" — F2P fairness is the dominant positive theme, even on a 4.49★ game with a vocal P2W complaint. This is unusual and worth studying as a benchmark.]**

---

## 19. Pain Points & Frustrations

[REVIEWS — 1★ themes, ranked by thumb count]:

### 19.1 Sky Tower as forced campaign gate (#1 complaint, 447-thumb top review)

> "you need to clear an OBSCENE amount of sky tower levels to unlock more campaign levels. Definitely gets boring after a quick time."

262 reviews specifically mention Sky Tower in negative context. **This is the single most-cited complaint in the entire corpus.**

[V:lEb22efbhjs explicit: Chapter 40 requires Sky Tower level 450.]

### 19.2 Mid-game difficulty cliff (777 reviews mention)

> "I was on one level for over 2 weeks trying to get strong enough and every level prior I was able to beat in a couple tries. It makes the game instantly repetitive and boring." [193 thumbs]

> "Extremely high difficulty curves after giving you meaningless stat numbers so that you quickly clear the easy as hell 'mobile initiation' levels." [55 thumbs]

XP scaling doesn't keep pace with chapter requirements at ~Chapter 30-40. Players hit a hard wall.

### 19.3 Energy gating (276 reviews mention)

> "you run out of 'energy' so you can no longer play… one of the worst anti-game patterns." [88 thumbs 2★]

### 19.4 Hitbox / projectile-density readability

> "The hitbox is so big for a small map" [116 thumbs 1★]
> "More levels have limited size that prevent you from dodging well." [121 thumbs 2★]

Compounds with the Effect Reduction setting being OFF by default.

### 19.5 Sequel-feels-like-Archero-1 (291 thumbs 2★)

> "This doesn't feel like a sequel. It feels like a more polished version of the original."

A nuanced complaint — players expecting *more* from a sequel feel the wave-survival format is a sideways move.

### 19.6 P2W escalation specifically around orbs/gear

> "swapping orbs — very pay to win, don't even worry about it" [V:PtgbAzxp4rM, MondoMan, explicit]

[INFERRED: "Swapping orbs" refers to artifact set switches between PvE/PvP — a paid-feature ramp.]

### 19.7 Localization issues (1★ explicit)

> "poor English localization" [174 thumbs 1★]

[ASSUMED: standard issue for Chinese-developed mobile games. Not extensively documented in the corpus.]

### 19.8 No-real-point guild participation (1★ explicit)

> "no real point in guild participation" [174 thumbs 1★]

Counter-signal to retention driver #17.6 — guild is rated as low-value by some players.

### 19.9 Two-set PvE/PvP gear meta forces re-progression

[V:FaZlxQNpK9U creator forced into Griffin set for arena season, can't progress chapters in parallel.]

### 19.10 Phone thermal throttling at peak

[V:W43vRnoT7ZQ] — explicit observation. Affects mid-range Android primarily.

---

## 20. Strengths & Weaknesses Synthesis

### 20.1 Design strengths (what works)

| # | Strength | Why it works |
|---|----------|--------------|
| 1 | **3–6 min session length** | Commute-friendly, dopamine-cycle-complete |
| 2 | **Roguelite RNG inside meta determinism** | Every run is different, but you always make some progress |
| 3 | **Multi-axis progression (10 axes)** | Never feels "done"; always one more thing |
| 4 | **Permanent Supply Card economics** | Best-rated SKU; high ARPU lock-in at low spend |
| 5 | **Ticket-mode-per-day design** | 8+ daily-touch modes prevent any single mode from feeling stale |
| 6 | **Resonance hero-sharing** | Combinatorial late-game; rewards focus-then-breadth pacing |
| 7 | **Pity timers on chests** | 50 pulls for chromatic, 100 for wish — predictable progression |
| 8 | **Mythstone Chest rotation** | Creates weekly saving rhythm for F2P |
| 9 | **Star-gated ability unlocks (2★/5★/8★)** | Always a visible next-unlock target |
| 10 | **Visible "value" badges on IAP** | 400% Value framing builds spend confidence |
| 11 | **Event progress persistence** | F2P can complete legendary events over multiple cycles [V:PtgbAzxp4rM] |
| 12 | **High visual polish** | Above genre baseline; appearance matches premium ($4.99) IAP framing |

### 20.2 Design weaknesses (what risks losing players)

| # | Weakness | Evidence | Severity |
|---|----------|----------|----------|
| 1 | **Sky Tower forced campaign gate** | 447-thumb 1★, 262 reviews | **CRITICAL** — top complaint in entire corpus |
| 2 | **Mid-game difficulty cliff at ~Ch30-40** | 777 reviews mention; 193-thumb 1★ | **CRITICAL** — late-mid churn driver |
| 3 | **Two-set PvE/PvP meta forces re-grind** | [V:FaZlxQNpK9U] explicit | High |
| 4 | **Visual density unreadable at peak builds** | [V:jCpmNrXYJsc] explicit; Effect Reduction is mandatory but OFF by default | High |
| 5 | **Chaotic gear requires 14 S-grade dupes** | [V:SWt0cYOM0kM] | High (P2W wall, but only affects whales) |
| 6 | **Energy gating mid-session** | 88-thumb 2★ | Medium |
| 7 | **Character Codex (v1.1.6) makes skins meta-relevant** | [V:FaZlxQNpK9U] explicit "F2P-hostile" | Medium-High (new) |
| 8 | **Promo code CAPTCHA flow loses casuals** | [V:VGFEPNdXhAE] | Low |
| 9 | **Localization quality** | 174-thumb 1★ | Medium (depends on market) |
| 10 | **Game crashes on 2× speed for mid-range phones** | [V:W43vRnoT7ZQ] | Medium |
| 11 | **Settings defaults are wrong (joystick, animation, effects)** | Multiple creator commentary | Low (fixable with onboarding tutorial change) |
| 12 | **Repetitive (when grind sets in)** | "instantly repetitive and boring" [193 thumbs 1★] | High once it kicks in |

### 20.3 Verdict

**Archero 2 is a well-tuned mid-core mobile roguelite with a visible structural problem at mid-game.** The 4.49★ rating and 162k+ ratings prove product-market fit. The Sky Tower gate is the single biggest churn driver and is **likely a deliberate retention/spend pacing mechanism** — if it didn't exist, players would clear chapters too fast and churn faster. Habby has made a calculated tradeoff: accept the vocal Sky Tower complaints in exchange for higher LTV.

[INFERRED: For Lila evaluating this as a competitive/reference title: the design is sound; the monetization is studied and effective; the visible churn drivers are *trade-offs Habby chose*, not accidents. The lessons to copy are: (a) Permanent Supply Card economics, (b) ticket-mode-per-day design, (c) 3-6 min session length, (d) multi-axis progression with star-gated unlocks. The lessons to *avoid* are: (a) hard-gating one mode behind another without giving players a choice (Sky Tower), (b) defaulting UX settings to OFF when they're necessary for legibility, (c) introducing skin-stat ties post-launch (Character Codex) without compensating F2P.]

---

## 21. Cross-Time Evolution (Patch Timeline from Corpus)

[Synthesized from video upload dates and patch references]:

| Date | Event | Source |
|------|-------|--------|
| Oct 2024 | First creator beginner guide (Archer Greene) — game has full economy already | [V:lEb22efbhjs] |
| Dec 2024 | Kosh's 38-min beginner guide — most comprehensive baseline | [V:jCpmNrXYJsc] |
| Jan 2025 | EnderClan character guide — Dracoola/Seraph $30 IAP confirmed | [V:3rPvl1xCvAw] |
| Apr 2025 | iPICKmyBUTT 43-min ultimate guide — Oracle/Griffin meta locked in | [V:SWt0cYOM0kM] |
| Apr 2025 | Shackled Jungle event documented | [V:W43vRnoT7ZQ] |
| ~Sept 2025 | Mythstone Chest rotation cadence changed from 3-day to 4-day [V:eTxwhXcZ48k notes "every 4th day" vs [GV] "3-day"]; Hela becomes a thing | [V:eTxwhXcZ48k] |
| Sept 2025 | MondoMan F2P guide — IAP ladder $0.99-$49.99, Arena Shop pricing | [V:PtgbAzxp4rM] |
| Feb-Mar 2026 | "Alex is a trap" — common community consensus | [V:CdZ122DGL_A] |
| Mar 2026 | Hela best F2P rare consensus | [V:3ixTDUf0nvY] |
| **May 2026** | **v1.1.6: Twinborn Rune Workshop + Character Codex + Hard Mode Star Challenges** | [V:FaZlxQNpK9U] |

[INFERRED trajectory:** Habby is adding **vertical** systems (Twinborn ruins-on-runes, Character Codex on hero stars) rather than horizontal content (new chapters). This is *power ceiling-raising* monetization — re-monetize existing players, not acquire new ones. **This is what mature mobile mid-core does**, and it's why the game is profitable but visibly P2W-escalating for veterans.]

---

## 22. Comparable Reference Games (for Lila context)

[INFERRED + corpus references]:

| Game | Similarity to Archero 2 | Difference |
|------|------------------------|------------|
| **Archero 1** | Direct predecessor; same IP, heroes, economy patterns | Room-to-room movement vs stationary wave-survival |
| **Vampire Survivors** | Stationary auto-attack roguelite skill pickup | No meta progression layer or gacha |
| **Survivor.io** | Habby's other survival roguelite | Less depth, more focused on combat |
| **Hades** | Roguelite with meta progression | Premium, single-player, no IAP gacha |
| **Gunfire Reborn** | Roguelite mentioned by reviewers | Co-op shooter, premium |
| **AFK Arena** | Multi-axis meta progression, daily quest hub | Idle, not real-time combat |
| **Hero Wars** | Hero gacha + multi-mode | Different combat genre |
| **Brawl Stars** | Auto-aim + roguelite-ish mode | Real-time PvP, no meta gacha density |

[INFERRED: Archero 2 sits at the intersection of "Vampire Survivors loop" + "AFK Arena meta layer." That intersection is currently dominated by Habby; competition from Western devs is thin. **This is a defensible market position.**]

---

## 23. Open Questions / Things I Don't Know

Explicitly flagging what the corpus doesn't tell us, so this can be filled in later:

1. **DAU / MAU absolute numbers** — not in public data. Only proxy: 162,850 lifetime Play Store ratings → likely 5-10M+ Android lifetime downloads (typical ratio for mid-core mobile). iOS adds more. [ASSUMED]
2. **ARPDAU / Whale concentration** — no public source. [V:SWt0cYOM0kM] suggests $5,000+ whales exist but volume unknown.
3. **D30 / D60 / D90 retention curves** — not in corpus. Cohort-quality reviews ("2 months 30min/day") suggest D60 retention is meaningful but rate unknown.
4. **Conversion rate to paying** — unknown. Implied from "lots of F2P players + $5,000+ whales" comments that there's a long-tail.
5. **Exact Sky Tower → Chapter unlock thresholds** for all chapters — only Chapter 40 = Sky Tower 450 confirmed [V:lEb22efbhjs]. Earlier gates unknown.
6. **Exact event reward economy** — corpus has partial data (Shackled Jungle, Carnival, Umbrella Tempest) but no event-level revenue/participation rates.
7. **Whether Character Codex is causing measurable churn** — too recent (3 days before corpus collection). Re-evaluate in 60-90 days.
8. **Detailed IAP price tier conversion rates** — proprietary data, not in corpus.
9. **Whether Habby is patching mid-game difficulty cliff** — no patch notes in corpus addressing it; possibly being addressed via Star Challenge gem rewards [V:FaZlxQNpK9U].
10. **Specific Mythstone chest rotation as of 2026** — wiki says 3-day, Sept 2025 video says 4-day; current cadence not verified post-v1.1.6.
11. **Whether the "Predetermined arena" exploit [V:eTxwhXcZ48k] is patched** — only documented Sept 2025; current status unknown.
12. **Cross-platform progression** — iOS vs Android sync, not investigated.
13. **The 9 newer heroes' shard sources** (Mymu, Hou Yi, Loki, Phynx, Nezha, Thor, Cleo, Wukong, Hela) — wiki Currency_and_Items page only lists 8 shard types; the gap is probably wiki-outdated. [ASSUMED standard event/shop sources.]
14. **Battle Pass exact pricing and rewards** — corpus has rough estimates (~€40) but no full structure documented.

---

## 24. Tagging Reference & Citation Index

For traceability, every claim above is tagged. Cross-reference:

**game-vault wiki pages used:**
- Main_Page, Guide_Ultimate_Beginners_Guide, Guide_Skills_Tier_List, Gear, Skills, Characters, Runes, Talent_Cards, Currency_and_Items, Events, Campaign, Sky_Tower, Arena, Gold_Cave, Rune_Ruins, Artifacts, Pull_Rates, Tips_and_Tricks, Reward_Codes

**Videos used (most-cited):**
- SWt0cYOM0kM (iPICKmyBUTT, 43-min ultimate guide, Apr 2025, 106k views) — meta authority
- jCpmNrXYJsc (Kosh, 38-min beginner, Dec 2024) — depth
- kpIdlbhx4s8 (Archer Greene, 14-min update guide, 2025, 104k views) — monetization authority
- lEb22efbhjs (Archer Greene, complete beginner, Oct 2024, 32k views) — sky tower gate
- 3rPvl1xCvAw (EnderClan, character guide, Jan 2025) — hero meta
- CdZ122DGL_A (Grinnn, "Alex is a trap", Feb 2026) — hero design analysis
- W43vRnoT7ZQ (TheGameHuntah, Shackled Jungle, Apr 2025) — event mechanics
- KrXJHpk_uXU (TheGameHuntah, first-impression, Mar 2025) — genre framing
- VGFEPNdXhAE (TheGameHuntah, tips, Mar 2025) — UX friction
- 3ixTDUf0nvY (Grinnn, Hela guide, Mar 2026) — Hela meta
- PtgbAzxp4rM (MondoMan, F2P walkthrough, Sept 2025) — IAP ladder
- NgiDHZuNFy0 (Grinnn, elements, Jun 2025) — element mechanics authority
- FaZlxQNpK9U (Grinnn, v1.1.6 patch, May 2026) — latest patch
- nhJMWJRWq30 (MobileGamesDaily, 52-min gameplay walkthrough) — visual confirmation
- IGpuzVuEO1o (Grinnn, essential tips, Mar 2026)
- LkzThHCkFjA (iPICKmyBUTT, best gem spend, 47k views) — economy authority
- k3mxy2oWlAE (iPICKmyBUTT, Rune Ruins randomness study, 86k views) — RNG study
- ffZpg7ndjLA (Kosh, gear guide, Jan 2025)
- 3 more (eTxwhXcZ48k, GH1iVtcWgzg) — supplementary

**[REVIEWS]:** 3,042 review bodies / 162,850 lifetime ratings (4.49★) from `com.xq.archeroii` Play Store listing, collected 2026-05-18

**[SHEETS]:** 20 Google Sheets from luhcaran's `/google-sheet/` — Damage Formula (Fierywind), Attack Speed (Renox), Extra Arrows (Alyssa), and 17 other community datamining sheets — saved as `.xlsx` at `/Users/tarun/LILA/Game Research/Archero 2/Web Sources/_google_sheets/`

---

## 25. Bottom Line for Lila

If Lila is evaluating Archero 2 as a competitive title for a similar genre slot:

**Steal these mechanics:**
1. **Permanent Supply Card** ($5.99 one-time, +800/day forever) — best-rated monetization SKU in the entire game
2. **Multi-axis meta progression** so no session feels wasted (10 axes is excessive; aim for 5-6)
3. **3-card skill pick** at every level-up — universally validated
4. **Resonance** (borrow ability from another hero) at progression milestones
5. **6 daily ticket-modes** with their own currencies — prevents single-mode burnout
6. **Mythstone chest rotation** weekly to create save-up rhythm
7. **Pity timers** on every gacha (50 and 100 pulls)
8. **Carnival-style onboarding event** with guaranteed F2P S-tier weapon

**Do NOT copy:**
1. **Sky Tower as forced campaign gate** — the #1 churn complaint, an avoidable design choice
2. **Mid-game difficulty cliff** without compensating XP scaling
3. **Default UX settings that are wrong** (joystick visible, animations slow, effects max)
4. **Skin-meta ties added post-launch** (Character Codex) — alienates existing F2P
5. **CAPTCHA flow for promo codes** — friction with no benefit
6. **Performance issues at peak build density** on mid-range hardware

**The single most important insight:** Archero 2 retains players via **interlocking session loops**, not via any single hook. A new title competing with it must either (a) match the 10-axis progression depth, or (b) win on a single dimension (combat feel, IP, visual identity) so strongly that the loop density gap doesn't matter.

[INFERRED but with high confidence based on the cross-source convergence: **Archero 2's strongest moat is its retention engine — the loop architecture, not any single feature.** Competing on features alone is futile; you must compete on the *shape* of the progression system or sidestep it entirely (e.g., a premium roguelite that doesn't need 10 axes).]

---

*End of document. Total length: ~25 sections, ~580 lines of synthesis. Standing by for follow-ups.*
