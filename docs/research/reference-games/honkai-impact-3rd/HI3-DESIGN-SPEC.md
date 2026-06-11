# Honkai Impact 3rd — Design Research Spec
*Synthesized 2026-06-11 from: Reddit threads, Fandom wikis, 2,985 Play Store review bodies (0.60% of 499k lifetime ratings)*

---

## 1. Market Overview

**Lifetime Store Performance** [GENUINE SOURCE]

| Metric | Value |
|---|---|
| Total lifetime ratings | 498,664 |
| Aggregate rating | 4.45 / 5.0 |
| 5-star reviews | 405,632 (81.3%) |
| 3-star reviews | 11,267 (2.3%) |
| 2-star reviews | 22,535 (4.5%) |
| 1-star reviews | 45,070 (9.0%) |

HI3 launched globally in 2018, roughly five years before Honkai Star Rail (April 2023). Its 4.45★ lifetime average — driven by 81.3% five-star reviews — is substantially higher than HSR's current Android rating of 3.765★ and iOS rating of 4.408★. The gap reflects two factors: HI3's peak review period (2018–2021) predates the most corrosive endgame criticism, and its all-female cast / action-RPG identity attracted a devoted early fanbase that rated enthusiastically.

By audience composition, HI3 skews toward players who value anime aesthetics, emotional storytelling, and skill-based real-time action — a narrower audience than HSR's turn-based accessibility design. HI3 does not publish MAU figures through public channels [ASSUMED], but community migration patterns suggest active player count has declined since HSR's 2023 launch. HI3 peaked 2018–2021 on mobile and has gradually transitioned toward a Part 2 "open world" redesign that alienated a significant portion of its original base. [GENUINE SOURCE — review sentiment patterns 2022+]

---

## 2. Core Game Loop

HI3 is a **real-time action RPG**, a deliberate contrast to HSR's turn-based combat. Sessions are structured as discrete battles (not a persistent shared-world loop), entered from a map/hub interface. The loop:

1. **Pre-battle** — Select team of 3 Valkyries, equip stigmata + weapons, choose leader skill
2. **Battle** — Real-time combat with character switching, QTE triggers, ultimate management
3. **Post-battle** — Star rating, rewards (fragments, crystals, equipment drops)
4. **Spend** — Allocate resources: level up characters, rank up battlesuits, upgrade stigmata/weapons

**Daily structure** [GENUINE SOURCE]:
- Daily tasks (stamina reward, log-in bonus)
- Stamina-gated stage farming (stigmata, weapon blueprints, Valkyrie fragments)
- **Weekly Abyss** — PvP-adjacent competitive scoring mode
- **Memorial Arena** — Co-op boss rushes on rotating schedule; builds are MA-specific
- **Elysian Realm** — Roguelike difficulty-scaling mode
- **Open World (Part 2 only)** — Genshin-style exploration layer added in later versions

The session is short-burst by design: most daily content can be cleared in 15–30 minutes, with Abyss and Memorial Arena pushing players toward 45–60 minute commitment windows on weekly reset days. [ASSUMED from daily structure evidence]

**What you're working toward:** Climbing Abyss tiers (competitive ranking) and clearing Memorial Arena with top scores. Story chapters serve as a parallel, non-competitive track that functions as the primary draw for casual/F2P players.

---

## 3. Character System (Valkyries / Battlesuits)

**Battlesuit Structure** [GENUINE SOURCE]

Each "Valkyrie" is actually a battlesuit — a character + costume variant. Players collect and rank up battlesuits, not characters per se. Ranks run B → A → S → SS → SSS, with each rank unlocking new passive skills and stat bonuses via fragment investment.

Team slots: **3 Valkyries** (vs HSR's 4-character teams). Each Valkyrie has a fixed role:
- **Primary DPS** — delivers the majority of damage
- **Support/Buffer** — applies debuffs, buffs the DPS, or triggers elemental reactions
- **Flex DPS / second support** — fills rotation gaps or specializes in specific content

Elemental affiliation is critical: "Elemental valkyries and physical valkyries largely have different supports, so team building in terms of what supports you use is also key." [GENUINE SOURCE]

**Stigmata Equipment (3-Slot Gear System)** [GENUINE SOURCE]

Stigmata occupy Top (T), Middle (M), and Bottom (B) slots. Each piece provides base stats and a piece bonus; set bonuses activate at 2-piece (applying to all 3 team members) or 3-piece (enhanced bonus for the wearer).

Notable F2P-priority stigmata:
- **Attila B** — Physical damage staple; "must" for physical DPS maintaining combo
- **Jingwei T/M** — "Probably the best F2P stig in the game. Multiple copies are useful"
- **Picasso set** — Powerful but requires 3 different currency types to farm slowly
- **Einstein T/B** — Charge-hit specialists like Snowy Sniper benefit heavily
- **Tesla M** — Freeze is "a powerful debuff that's also relatively easy to inflict"

**Weapon System** [GENUINE SOURCE]

Each Valkyrie equips one weapon typed to their combat style (cross, gauntlets, lance, sword, pistol, etc.). Weapons contribute ATK stats and activate weapon skills tied to SP (skill points) generation. Skill DMG adds flat damage on top of the ATK multiplier. Shield damage multiplier (SDM) is a separate stat that scales independently from normal damage.

**Contrast to HSR:** HSR uses Light Cones (weapon equivalent) + Relics (gear sets). HI3's 3-slot stigmata system with mixed-set activation is more granular than HSR's 2-piece relic set meta, and the 3-slot structure creates more item combination depth. HSR simplified this significantly. [ASSUMED based on HSR companion spec]

---

## 4. Combat System

**Real-Time Action Foundation** [GENUINE SOURCE]

HI3 combat is real-time, requiring the player to control one active Valkyrie while two others wait off-field. The philosophical core is not reflexes but rotation precision: "combat is less about dodging (which is largely optional) and more about precise positioning, timing attack windows, and building meter to unleash Ultimate abilities."

**QTE (Quick Time Event) System** [GENUINE SOURCE]

QTEs are the most mechanically distinctive feature of HI3. When an enemy attacks a specific tagged character, the player can trigger a QTE — the tagged character enters the field instantly without consuming a standard switch cooldown. Higher-level play exploits QTE chains and animation canceling to compress rotations. Some builds intentionally skip QTE to avoid wasting time with low-value damage.

QTE chains reward preparation: assembling a team whose QTE triggers align with common boss attack patterns allows skilled players to maintain near-continuous rotation without dead time. This is meaningfully different from HSR's action-queue system; HI3 rewards reactive input in real time.

**Team Composition Meta** [GENUINE SOURCE]

Standard high-level composition: **1 DPS + 2 Supports** — not 3 DPS. Key support examples from community:
- **Divine Prayer (DP)** — Physical support; "Every 10 seconds, while off-field, she provides a very strong single target impair which can remove much of a boss' defence"
- **Phoenix** — Elemental support with damage mark; periodic swap triggers periodic damage boost
- **Void Drifter** — Shield-break specialist; self-stun buffs teammates with SP and total damage bonus
- **Drive Kometa** — Full support with gathering, weaken AoE, and time-slow on ultimate

**Damage Calculation** [GENUINE SOURCE — Fandom]:

`Final Damage = Base Damage × Character Damage Multiplier × Target Damage Receive Multiplier × Type Multiplier`

- Physical damage: scales from ATK × skill multiplier, reduced by enemy DEF
- Elemental damage: ignores DEF, cannot crit, reduced only by elemental resistance
- Type advantage (mecha > bio > psychic > mecha loop; quantum neutral): 1.3× bonus / 0.7× penalty

**The Dodging Paradox** [GENUINE SOURCE]

A critical endgame insight: dodging is not rewarded at high levels. "Engaging with boss mechanics by dodging and such will often lower your score" — because time fracture (a damage buff triggered by evasion) penalizes the rotation clock. The community sums it up as: "99% punching bags... there's little to no actual interaction with enemies or bosses mechanics and you just need to perform your rotation well enough."

This is not a design failure for HI3's target audience — it's intentional optimization puzzle design. But it represents a significant departure from action-game expectations.

---

## 5. Progression & Onboarding

**Day 1 Experience** [GENUINE SOURCE — Reddit synthesis]

New players receive "a lot of freebies at the beginning for you to catch up quick to older players." The game provides trial characters for story boss fights, meaning story content is accessible without gacha investment. One player summarizes the initial surprise: "At first, I thought it was those kinds of games which are easy to accomplish or pay-to-win games. But it isn't. Although huge amounts of money were given to the players at the first try of the game, it wasn't that huge enough to easily finish the game."

Onboarding is generous but front-loaded. The opening stages teach combat in isolation, and the tutorial economy floods the player with currencies and characters to create a sense of abundance. The true resource wall appears 20–40 hours in when currency sinks outpace free rewards.

**Progression Gates** [GENUINE SOURCE]

- Level cap: 80 (as of referenced patches)
- Valkyrie fragments drop from specific stages; old characters require slow grind
- Stigmata farming is rotation-based — specific pieces only available on specific days
- 10+ distinct currency types: crystals, Source Prism, Abyss Currency, Black/White Cores, Honkai Pieces, stamina, and more
- "There are 10+ currencies" — cited as a significant cognitive burden by community

**Story Pacing** [GENUINE SOURCE]

Story chapters use trial characters for boss encounters, keeping story accessible regardless of gacha progress. This is noted explicitly as an advantage over other HoYoverse titles: "This game literally gives you trial characters for hard bosses levels to make it easier than any other Hoyoverse games." Story is fully clearable F2P; competitive modes (Abyss, Memorial Arena) require investment to climb.

**When Gacha Appears** [ASSUMED based on new player reports]

Gacha is surfaced early — within the first session — but framed as enhancement rather than requirement. The onboarding crystal gift is sized to fund 2–5 pulls, providing an early reward hit without gating story progress.

---

## 6. Gacha System

**Banner Types** [GENUINE SOURCE]

- Character focus banners (S-Rank guaranteed at pity)
- Weapon focus banners
- Stigmata focus banners

**Cost** [GENUINE SOURCE]: 2800 crystals per pull — "highest among gacha games players compared it to (Genshin, PGR, etc.)." This is a meaningful friction point relative to competitors.

**F2P Viability** [GENUINE SOURCE — composite sentiment]

Early/mid-game: "generous to its F2P players" — multiple sources confirm the game does not require gacha spending for story completion.

Late-game: "Being a F2P is awful. Especially when you reach high level... with limited resources." New S-Rank characters are "needed for the MA and Abyss" — the competitive endgame modes effectively require staying current with the banner cycle.

The community consensus: **F2P story = accessible. F2P endgame = increasingly untenable.** This is a deliberate design decision: competitive modes monetize, story does not.

**Contrast to HSR** [GENUINE SOURCE + ASSUMED]:
- HSR has a transparent pity counter (5★ guaranteed at X pulls, publicly displayed)
- HI3 pity exists but is less clearly communicated to new players
- HSR introduced the 50/50 system with better guarantee clarity
- HI3's multi-cost is noted as higher than market average

---

## 7. Community Sentiment

**What Veteran HI3 Players Love** [GENUINE SOURCE — direct quotes]

**Story and emotional investment:**
- "The story is just phenomenal"
- "The game upgrade to a masterpiece. The CGs are high quality and a lot of interesting mechanics... Usually I play the minigames while bawling my eyes out"
- "The writing's good that it makes me cry because of the tragic theme as you progress"

**Visuals and production value:**
- "Valkyries have stunning designs, the graphics was crazy smooth, the animations are beautiful and the storyline was super bomb"
- "The graphics are smooth, and the cut scenes feels like a scene from an anime episode"
- "This game is the perfect combination of a great story, awesome combat experience, great graphics, amazing songs to fit each situation of the story"

**Longevity and loyalty:**
- "The game that has lasted longer than my phones and the first game that is installed before anything else"
- "Been playing since the launch in 2017" [Note: 2017 CN launch]

**What They Hate / Complain About** [GENUINE SOURCE — direct quotes]

**Storage bloat (highest-volume complaint):**
- "It's consuming most of my storage" (35–54GB depending on device/download state)
- "the game is bigger and bigger until your phone can't hold it anymore. Cant you guys just do the overwrite thing on updates?"
- "I updated the app, but when I opened it up, it asks me to re-download the assets I've already downloaded TWICE. For someone who only uses mobile data, this is SOOO annoying" (345 thumbs-up)

**"Updating Settings" loading freeze (highest-thumbed pain point):**
- "it says 'Updating Settings' for 6 straight hours and I've already lost 6gb of my mobile data" (503 thumbs-up)
- "Everytime I log in, it's always 'updating settings' and the updates take sooo long! Moreover, it just loops back, making it longer. Why do I have to update the game everytime I open it?"
- This single bug converted multiple 5-star reviewers into 1-star reviewers. Players reinstalled 5 times without resolution.

**Endgame repetition:**
- "I reached level 80 after one year. It got stale and repetitive. Challenge modes are more on stress rather than challenging. Most old characters are 'useless' compared to recent/newer valkyrie" (280 thumbs-up)
- "not enough time for overly repetitive grind has ultimately led to me quitting the game"
- "There's not much gameplay except for tedious chores that's super repetitive and not fun"

**Part 2 regression:**
- "There are so many things disappointing me one by one apart from the story as I play through part two. Unresponsive buttons, maps not loading, continuous lag... The controls are also a mess" (380 thumbs-up)
- "The Part 2 open world makes it more like Genshin 2.0... I don't like the open world part It's way too laggy"
- "pls add an option to change the UI back to the old one, it's a lot more comfortable"

**The HI3-to-HSR Migration Pipeline** [GENUINE SOURCE + ASSUMED]

The most common migration narrative from reviews and Reddit: players loved HI3 through Part 1, felt the Part 2 open-world redesign abandoned HI3's identity, and moved to HSR (2023) as a "fresh start" from the same developer. HSR offered better optimization (turn-based avoids real-time lag entirely), simpler progression with fewer currency types, and explicit pity transparency. Some moved to Genshin Impact first — "Used to love this game and invested an insane amount of time and effort on it... though I moved on to Genshin Impact" — then continued to HSR.

Players who migrated generally did not cite story quality as a reason to leave. They cited **performance, part 2's identity crisis, and resource fatigue.**

**Players Who Stayed on HI3** [GENUINE SOURCE]

Retention drivers for remaining players:
- Action combat depth: "There is plenty of skill expression at the highest level... top scoring runs are the result of a lot of practice"
- Story investment: emotional attachment to characters developed over years of content
- Trial character system: story clearable without gacha, making it viable for casual, non-competitive players
- Distinct playstyle per character: "ridiculously cool kits in this game" vs HSR's formulaic turn order

---

## 8. Play Store Review Analysis

**Lifetime Distribution** [GENUINE SOURCE]

| Stars | Count | Share |
|---|---|---|
| 5★ | 405,632 | 81.3% |
| 3★ | 11,267 | 2.3% |
| 2★ | 22,535 | 4.5% |
| 1★ | 45,070 | 9.0% |

*Note: 4★ count appears as 0 in source data — likely a threshold artifact in the rating distribution capture. [GENUINE SOURCE note]*

**Why HI3 Scores Higher Than HSR** [ASSUMED with evidence basis]

HI3's 4.45★ vs HSR's Android 3.765★ reflects two structural factors: (1) HI3's review corpus is older, concentrated in 2018–2021 when new-player enthusiasm peaked, before endgame power creep and Part 2 degradation became dominant themes; (2) HSR's Android rating suffers from launch-era technical reviews on lower-spec Android hardware that are difficult to improve retroactively.

**Top Complaint Themes by Thumbs-Up Volume** [GENUINE SOURCE]

1. "Updating Settings" loop — 503 / 424 / 622 thumbs on top reviews; affected versions 3.4.0–5.1.0 (2019–2021 peak)
2. Storage demand on re-download — 345 thumbs; versions 4.0.0+
3. Repetitive endgame grind — 280 thumbs; "level 80 after one year. It got stale"
4. Part 2 performance regression — 380 / 265 thumbs; concentrated in 7.3.0+ (2024+)
5. F2P progression wall — 307 / 145 thumbs; concentrated in v8.1.0 era

**Top Praise Themes by Thumbs-Up Volume** [GENUINE SOURCE]

1. Story and narrative — 1360 / 746 / 385 thumbs on leading 5-star reviews
2. Graphics and animation polish — 792 / 746 / 533 thumbs
3. Generous F2P onboarding — 583 / 463 / 446 thumbs

**Version Regression Pattern** [GENUINE SOURCE]

The review corpus shows a clear inflection at Part 2 (approximately v7.3.0, 2024). Pre-Part 2 reviews are dominantly positive with focused technical complaints. Post-v7.3.0 reviews show: performance degradation on mid-range hardware, open-world UI overhaul backlash, and increasing P2W perception at endgame. 2025–2026 most-recent reviews include: "I don't know what happened to Honkai anymore... The new story is confusing and boring; it no longer excites me" and "Very bad now as this game is dropping into 'meta-versing' already."

The historical 4.45★ average is a trailing indicator and no longer reflects current player sentiment.

---

## 9. HI3 vs HSR Comparison

| Dimension | HI3 | HSR |
|---|---|---|
| Combat style | Real-time action, rotation-based | Turn-based, action queue |
| Team size | 3 characters | 4 characters |
| Character system | Battlesuits (B→SSS rank) + Stigmata (3 slots) | Characters + Light Cones + Relics (2-piece sets) |
| Progression currencies | 10+ distinct types | Fewer, more consolidated [ASSUMED] |
| Story accessibility | Full story clearable F2P via trial characters | Gacha investment needed for some story units [ASSUMED] |
| Pity clarity | Exists but less transparent [GENUINE SOURCE + ASSUMED] | Explicit public pity counter |
| Performance | Lags on lower-end hardware; Part 2 worst | Turn-based eliminates real-time lag penalty |
| Character diversity | All-female cast | Male and female characters |
| Open world | Part 2 added, criticized as "Genshin 2.0" | More polished execution [ASSUMED] |
| Endgame skill ceiling | High; top Abyss runs reward practice and diverse comps | Lower per-session execution depth [ASSUMED] |
| Lifetime revenue (public) | Not disclosed | $1.64B (Apr 2023–May 2026) [GENUINE SOURCE] |
| Current MAU | Not disclosed | ~9M (May 2026) [GENUINE SOURCE] |

**What HSR Explicitly Improved From HI3's Model** [GENUINE SOURCE + ASSUMED]:
- Turn-based design eliminates device-tier performance as a competitive variable
- Simpler progression model reduces cognitive overhead for new players
- Better pity clarity reduces gacha anxiety
- Gender-inclusive character roster broadens audience
- Launched with better open-world performance than HI3 Part 2 achieved

**What HI3 Still Does Better** [GENUINE SOURCE]:
- Real-time combat depth: animation canceling, QTE chains, rotation optimization reward skill
- Trial character system for story — more generous than any other HoYoverse title per community
- Character gameplay distinctiveness: "ridiculously cool kits" vs formulaic turn ordering
- Anime-quality cutscene production for story chapters
- Emotional narrative investment over a 7-year arc

---

## 10. Design Lessons for WeaponCraft

**Lesson 1: Separate story accessibility from competitive gating.**
Evidence: HI3's trial character system lets players clear all story content without gacha investment. The most common praise quote: "This game literally gives you trial characters for hard bosses levels to make it easier than any other Hoyoverse games." [GENUINE SOURCE] The most common reason to continue playing after losing competitive interest: story investment.
Application: WeaponCraft should front-load the crafting narrative loop without requiring optimal gear. Let players experience the full story/campaign arc with starter-tier weapons. Reserve the deep optimization layer (min-maxing parts, rare recipes) for players who choose competitive engagement.

**Lesson 2: Technical debt on loading and updates will destroy 5-star reviews.**
Evidence: The single highest-upvoted complaint category across HI3's entire review history is not monetization, not power creep — it is a loading loop bug ("Updating Settings") that affected versions across a 2-year window. Reviews with 503, 424, and 622 thumbs-up from players who explicitly loved the game but were forced to give 1★ due to this failure alone. [GENUINE SOURCE]
Application: For WeaponCraft, treat initial load time, update friction, and save-state reliability as P0 issues equal to gameplay. A single update that forces re-download of assets or hangs on load will devastate review scores regardless of content quality.

**Lesson 3: Resource system complexity is a late-game retention killer.**
Evidence: "There are 10+ currencies" — HI3's multiple currency types (crystals, Source Prism, Abyss Currency, Black/White Cores, Honkai Pieces, stamina, plus event-specific currencies) created cognitive fatigue cited repeatedly in 1-3★ reviews. "The grind is too tiring not that fun anymore." [GENUINE SOURCE]
Application: WeaponCraft's crafting economy should consolidate resource types aggressively. A single "materials" track with clearly visualized conversion paths — rather than 8 distinct unlocks at 8 different progression gates — will keep players engaged longer and reduce the "it got stale" review pattern.

**Lesson 4: The Part 2 redesign case study — open world dilutes identity.**
Evidence: HI3's decision to add a Genshin-style open world in Part 2 is the most-cited single decision by players who left the game. Reviews describe it as "Genshin 2.0," "way too laggy," and a loss of the game's original identity. The UI overhaul alongside the open world change compounded the alienation: "pls add an option to change the UI back to the old one." [GENUINE SOURCE]
Application: WeaponCraft's core identity is the forge loop — crafting, testing, iterating. Any feature expansion (social layer, wider world, PvP) should extend that identity, not dilute it toward a different genre. When adding features, ask whether they serve the forge fantasy or substitute a different one.

**Lesson 5: High skill ceiling creates loyal whales — but only if the skill is visible.**
Evidence: HI3 retains a dedicated competitive audience because Abyss leaderboards show diverse team compositions and top scores come from execution, not just gear: "I've used different comps than the 'preferred' one... while surpassing their scores." The community rewards mastery with social recognition. [GENUINE SOURCE] This contrasts directly with the Part 2 endgame critique where dodging is penalized — skill must translate to visible output.
Application: In WeaponCraft, make optimization mastery visible. When a player builds an unusual weapon combination that outperforms the meta in battle, the score or ranking should reflect that. If optimization is invisible (all weapons deal similar damage regardless of build quality), the crafting depth has no social reward loop and high-investment players disengage.

---

*Document written 2026-06-11. Sources: HI3 Reddit synthesis, Fandom wiki mechanics data, 2,985 Play Store review bodies, HSR market data from Sensor Tower MCP and GWO/CoopBoardGames articles. Market data provided as WeaponCraft competitive context only; HI3 does not disclose public revenue figures.*
