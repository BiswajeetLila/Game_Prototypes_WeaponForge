# Terbis (테르비스) — Deep-Dive Design Analysis
**Research date:** 2026-06-08  
**Purpose:** Assess design overlap with WeaponCraft; determine competitive proximity  
**Researcher:** Claude Sonnet 4.6 via deep-research harness

---

## 1. Identity Confirmation

| Field | Detail |
|---|---|
| **English title** | TERBIS |
| **Korean title** | 테르비스 |
| **Developer** | WebzenNova (Webzen 100%-owned subsidiary) |
| **Publisher** | Webzen Inc. (Korean studio; titles: MU Online, R2, Rappelz) |
| **Platforms** | Android, iOS, Windows PC (cross-platform) |
| **Release status** | As of research date: pre-release / post-CBT; delayed from 2025 to "early 2026" target |
| **Regions** | KR + JP simultaneous CBT (June 10–16, 2025); global release planned |
| **Genre (official marketing)** | "서브컬처 수집형 RPG" — Subculture Character-Collection RPG |
| **First public showing** | G-Star 2023 (Korea) |
| **CBT** | June 10–16, 2025, Korea & Japan; delete-test (progress not carried) |
| **Estimated file size** | ~2 GB (consistent with observer report; not officially published in sources reviewed) |
| **Voice cast** | Minase Inori (Goddess Terbis character); 35 voiced characters in CBT |

**Identity confirmed.** The game observed in the Dec 2025 "Top 10 anime gacha autoplay" reel is definitively TERBIS by Webzen/WebzenNova. The Korean UI text "자유도시 루로" (Free City Luro) is a story-world location name; the isekai premise (modern high-school student transported to the Terbis world), side-view party of up to 5, and PC keybinds (W/E/R for skill slots, standard on cross-platform games) all match confirmed details. The "STAGE WAVE 2/2" HUD and "STORY.2" cutscene labels are consistent with the stage-chapter structure described in CBT reviews.

**Sources:**
- https://gamingonphone.com/news/terbis-an-anime-style-rpg-from-webzen-is-starting-a-closed-beta-test-in-japan-this-june/
- https://company.webzen.com/ko/presscenter/press/pressview?seq=6771
- https://company.webzen.com/ko/presscenter/press/pressview?seq=6889
- https://www.mt.co.kr/tech/2025/06/10/2025061014523371226
- https://terbis.en.uptodown.com/windows

---

## 2. Full Design Breakdown

### 2.1 Gacha / Summon System

**Pull target: HEROES / CHARACTERS only.** No weapon-specific gacha banner was found in any source reviewed, including the official CBT probability page (https://terbis.webzen.co.kr/probability/guide/detail/34).

The official probability guide lists three pull categories:
1. **Character Summon** (hero pulls — the primary gacha)
2. **Equipment Crafting** (UR Quadcore / Hexacore — crafting RNG, not a pull banner)
3. **Materium Random Boxes** (upgrade-currency loot boxes)

**Rarity tier ladder:** R → R+ → SR → SR+ → SSR → SSR+ → UR → UR+ → LR → LR+ → MR (11 tiers)  
The ladder is a *progression* system: characters are pulled at SSR and then evolved upward using duplicates/Materium currency.

**Pull rates (CBT):** Individual SSR pull rate: ~0.1304% (extremely low). First 10-pull guarantees one SSR. Infinite reroll supported.

**Pity system:** NONE during CBT. Multiple reviewers flagged this as a critical flaw: "sometimes exceeding 100 pulls without a single SSR." Webzen acknowledged this feedback in the delay announcement.

**Banner model:** Standard character banners with limited-character rotation. Separate boxes for crafting materials.

**Roster size:** 35 characters at CBT; 40+ expected at full launch (30+ with full cinematic animation sequences). 50+ characters referenced for the post-launch roadmap.

**Sources:**
- https://terbis.webzen.co.kr/probability/guide/detail/34
- https://www.gametoc.co.kr/news/articleView.html?idxno=93509
- https://bbs.ruliweb.com/news/read/211963
- https://terbis.en.uptodown.com/android

### 2.2 Roster Model

**Large, growing, pullable character roster.** This is the opposite of a locked roster. The 35–50+ heroes are all acquirable via gacha. Players choose which 5 to deploy per battle, but the roster itself is entirely open and gacha-gated. There is no concept of "story-unlocked fixed heroes" in Terbis.

### 2.3 Combat System

**Real-time auto-battle with manual skill timing ("semi-automatic").**

- Characters and companions auto-attack continuously
- Players manually decide *when* to activate each character's special/ultimate ability
- On PC, skills are mapped to keybinds (W/E/R pattern — consistent with the video observation)
- Battle speed increase unlocks after story progression
- Full auto-battle mode also available (skills fire automatically)

**Party structure:** Up to 5 heroes deployed per battle  
**Formation:** 3-row grid (front/mid/back) × role types (tank/dealer/healer/supporter)  
**Combat type:** The game is described both as "real-time" and "semi-turn-based" across sources; the most accurate framing is *real-time auto-battle with optional manual ultimate triggers*, which is the standard subculture-RPG formula (Epic Seven, Brown Dust 2, etc.)

**Chain System:** Terbis's key differentiator. Skills carry *keyword tags* (e.g., "dizziness," "penetration"). When Character A applies a debuff keyword, Character B's skill that references that keyword triggers an amplified chain effect. Party composition around overlapping keyword chains is the core strategic layer. The chain system fires automatically in full-auto mode when party is set up correctly.

**Sources:**
- https://www.g-enews.com/article/ICT/2025/06/202506121707125978c5fa75ef86_1
- https://koreagamedesk.com/this-mobile-rpg-makes-you-rethink-every-formation-mid-battle/
- https://www.gametoc.co.kr/news/articleView.html?idxno=93509

### 2.4 Session / Run Model

**Open-content campaign RPG with long/ongoing sessions — NOT a short self-contained run model.**

Session structure (confirmed from CBT, up to Chapter 4 / Stage 9+ available):
- **Main Story:** Chapter-stage format (e.g., 1-1 → 1-3, 2-1 → 2-x…). "STAGE WAVE 2/2" HUD = waves *within* a single story stage (not a roguelite run structure). Stages cost "Willpower" stamina that regenerates every 6 minutes.
- **Resource Dungeons:** 4 dedicated dungeon types (Forbidden Archive, Royal Treasure Vault, Forgotten Temple, Underground Ruins), each capped at 5 free runs/day with sweep available
- **Arena:** Async PvP (attack team vs defense team)
- **Monster Nest (마수의 둥지):** Cooperative monster hunting  
- **Dream Labyrinth (꿈의 미궁):** Roguelite dungeon (see §2.5)

This is the standard "campaign RPG with daily stamina" loop — not a 5-minute self-contained run.

**Sources:**
- https://www.sisafocus.co.kr/news/articleView.html?idxno=340844
- https://www.gametoc.co.kr/news/articleView.html?idxno=93509
- https://terbis.webzen.co.kr/board/958/detail/319472

### 2.5 Roguelite Layer

**Partial / optional content only, not the core loop.**

The **Dream Labyrinth (꿈의 미궁)** is a side-mode roguelite dungeon:
- Player deploys 10 characters; they advance left-to-right through encounters
- Health persists between battles within the run
- After each victory, player picks 1 of 3 offered **relics** (permanent within the run)
- Random recovery nodes and special event encounters exist
- Runs reset on a 3-day ranking cycle
- Described as "dopamine-delivering" but *not* the primary game loop

**Key difference from WeaponCraft:** The Dream Labyrinth is a side mode alongside the main story campaign. The primary gameplay loop is the story chapter progression, not wave-defense runs. There is no "between-wave card draft" in the main story mode.

**Sources:**
- https://www.gametoc.co.kr/news/articleView.html?idxno=93509 (most detailed source)
- https://www.sisafocus.co.kr/news/articleView.html?idxno=340844

### 2.6 Equipment & Crafting System

**No weapon-forging, no weapon-as-gacha, no forge-draft mechanic.** Equipment is crafted using in-game currency/resources (not via gacha banner pulls).

Equipment system:
- Each character has **5 equipment slots** (confirmed multiple sources)
- Equipment requires separate leveling (criticized in reviews as "complex")
- Additionally: skill level system, core inscriptions ("마력각인 코어"), and character-rank artifacts ("아티팩트" unlocked at MR)
- Crafting uses "runestones" with random or selectable output options
- One CBT reviewer noted: "equipment crafting costs significant currency with minimal combat impact"

**There is no weapon-as-primary-gacha, no forge wheel, no recipe-based weapon crafting meta, no part-assembly system.**

**Sources:**
- https://www.gametoc.co.kr/news/articleView.html?idxno=93509
- https://terbis.webzen.co.kr/board/958/detail/319472

### 2.7 Synergy Systems

- **5 Elemental attributes:** Fire, Wind, Earth, Water, plus "Primordial" (초속성 — exclusive to "Implementer" archetype characters; has advantage over all other elements)
- **Elemental advantage/disadvantage:** Standard rock-paper-scissors-style matchups affect damage output
- **Chain Skill System:** Skills carry keyword tags; chains fire when prerequisite keywords are active on targets or allies
- **Formation synergy:** Position-based buffs activate when specific role/element combos fill formation slots
- **Relationship System (PvE):** Enemy relationship modifiers (±50% attack/defense) and ally bond bonuses (+10% attack)

**No "compound" or "catalyst" cross-element fusion mechanic was found.** The elemental system is attribute-advantage (standard), not a compound-synthesis model.

### 2.8 Monetization & Progression

- **Free-to-play with IAP** (confirmed)
- **Gacha character pulls** are the primary monetization hook
- **No pity system** in CBT (biggest community complaint; may change at launch)
- Character evolution requires duplicates (deep wallet or grind)
- Multiple parallel progression systems (character level, skill level, 5 equipment slots, core inscriptions, evolution stages) — described as "quite scattered" and potentially overwhelming
- P2W reputation: The no-pity SSR rate of 0.1304% was flagged as predatory; standard subculture-RPG P2W pressure
- Passes / battle passes: Not confirmed in reviewed sources (likely at launch given genre conventions)

### 2.9 Story & Setting

Isekai premise: modern high-school student transported to the world of "Terbis" (fantasy world name, also the game's title) to resolve a world-ending threat. Bright/colorful anime art style. Location "자유도시 루로" (Free City Luro) is a named city in the game world visited in early story chapters. Confirmed to be in the Dec 2025 gameplay video frame.

---

## 3. The 6 Convergence Questions vs WeaponCraft

| # | Question | Answer | Evidence | Source(s) |
|---|---|---|---|---|
| **1** | Does Terbis make you pull **WEAPONS** (vs heroes)? | **No** | The only gacha banner pulls characters/heroes. Equipment is crafted from resources, not pulled. Official probability page lists "Character Summon" as primary pull category. No weapon-gacha banner exists. | https://terbis.webzen.co.kr/probability/guide/detail/34; https://terbis.en.uptodown.com/android; https://www.gametoc.co.kr/news/articleView.html?idxno=93509 |
| **2** | Is the hero roster **LOCKED / fixed** (vs open pullable)? | **No** | Roster is entirely open and gacha-gated. 35–50+ heroes all acquirable via pulls. No "story-unlocked fixed 7 heroes" concept. The roster grows as players pull. | https://gamingonphone.com/news/terbis-an-anime-style-rpg-from-webzen-is-starting-a-closed-beta-test-in-japan-this-june/; https://www.gametoc.co.kr/news/articleView.html?idxno=93509 |
| **3** | Is it a **5-min wave-defense ROGUELITE arena** (vs open campaign RPG)? | **No** | Primary loop is open campaign RPG with stamina-gated story stages + daily dungeons. The "STAGE WAVE 2/2" in video = waves within a story stage. Sessions are ongoing/long, not self-contained ~5-min runs. | https://www.sisafocus.co.kr/news/articleView.html?idxno=340844; https://terbis.webzen.co.kr/board/958/detail/319472 |
| **4** | Is there a **between-wave card/skill DRAFT** (main loop)? | **No** | No card-or-skill draft in the main combat loop. The Dream Labyrinth side-mode offers a 3-relic pick after victories, but this is an optional secondary mode, not the core session structure. No "3-card Forge Draft" equivalent. | https://www.gametoc.co.kr/news/articleView.html?idxno=93509; https://www.sisafocus.co.kr/news/articleView.html?idxno=340844 |
| **5** | Is there a **weapon FORGE / crafting meta**? | **No** | Equipment is crafted using currency/runestones with RNG output, not via a Forge Wheel or weapon-part assembly meta. No weapon-gacha, no forge-wheel, no part-merge mechanic. Equipment is secondary to character power. | https://terbis.webzen.co.kr/board/958/detail/319472; https://www.gametoc.co.kr/news/articleView.html?idxno=93509 |
| **6** | **Cross-element compound / Catalyst-like** system? | **No** | Element system is standard attribute-advantage (Fire > Wind, etc.) + Primordial super-attribute. The "Chain System" is keyword-based skill synergy, not cross-element compound synthesis. No element-pair fusion catalyst mechanic found. | https://www.g-enews.com/article/ICT/2025/06/202506121707125978c5fa75ef86_1; https://koreagamedesk.com/this-mobile-rpg-makes-you-rethink-every-formation-mid-battle/ |

**Score: 0/6 convergence questions answered Yes.**

---

## 4. Overlap Score vs WeaponCraft

**Overlap score: 1.5 / 10**

Scoring rationale:

| Dimension | Terbis | WeaponCraft | Overlap |
|---|---|---|---|
| Gacha pull target | Heroes | Weapons | None |
| Hero roster model | Open pullable (50+ heroes) | Fixed 7 locked heroes | None |
| Core loop session type | Open campaign RPG (stamina/chapters) | ~5-min wave-defense run | None |
| Between-session draft | None in main loop | 3-card Forge Draft every wave | None |
| Weapon crafting meta | Craft from resources (secondary) | Forge Wheel + part-merge (PRIMARY) | None |
| Cross-element synthesis | Standard attribute advantage | Catalyst compound system | Partial (both have element systems, but different models) |
| Side-view party auto-battle | Yes, 5-hero party | Yes, 3-hero party | +0.5 (surface similarity) |
| Manual ultimate activation | Yes (timing-based) | Yes (tap-based) | +0.5 (surface similarity) |
| Anime aesthetic | Yes | Yes | Cosmetic only |
| Audience | Traditional subculture gacha RPG fans (Epic Seven / Brown Dust 2 comp-set) | Habby loyalists × anime-curious | Minimal crossover |

The 1.5 points awarded are purely for surface presentation (side-view auto-battle + manual ultimate) which is a category-wide convention, not a WeaponCraft-specific mechanic.

---

## 5. Verdict

**UNRELATED** — Terbis is not a WeaponCraft clone and poses no meaningful convergence threat.

Terbis competes directly with **Epic Seven, Brown Dust 2, Goddess of Victory: NIKKE, and Wuthering Waves** — the traditional Korean/Japanese subculture character-collection RPG comp-set. WeaponCraft competes with **Wittle Defender, Archero 2, and Halls of Torment** — the Habby-roguelite arena comp-set. These are structurally distinct product categories that happen to share an anime visual wrapper.

---

## 6. Confidence & Caveats

- **HIGH confidence:** Identity, developer, platform, release timeline, gacha-as-hero-only, no weapon-forge, no pity, roster size, chain system, element system, Dream Labyrinth side-mode. Multiple independent Korean and English sources corroborate.
- **MEDIUM confidence:** 5 equipment slots per character, SSR pull rates (CBT rates, may change at launch). Based on primary CBT reviews.
- **LOW confidence / unconfirmed:** Full monetization model at launch (battle pass, etc.) — not yet published. Exact global release date. Whether the "equipment crafting" system will be expanded post-launch.
- **Unconfirmed:** The specific "자유도시 루로" chapter placement (Chapter 2 likely based on "STORY.2" video frame, but not explicitly confirmed in text sources).
- **Note on Namu Wiki:** The primary Korean wiki (namu.wiki/w/테르비스) returned 403 during fetching. Content was partially recovered through cached/translated snippets in Korean-language search result summaries.

---

## Sources Index

1. GamingOnPhone CBT announcement: https://gamingonphone.com/news/terbis-an-anime-style-rpg-from-webzen-is-starting-a-closed-beta-test-in-japan-this-june/
2. Webzen press release (teaser): https://company.webzen.com/ko/presscenter/press/pressview?seq=6771
3. Webzen press release (PV): https://company.webzen.com/ko/presscenter/press/pressview?seq=6889
4. Daikama overview: https://daikama.com/news/terbis-webzens-upcoming-anime-style-rpg-release-teaser-site/
5. KoreaGameDesk chain skills article: https://koreagamedesk.com/this-mobile-rpg-makes-you-rethink-every-formation-mid-battle/
6. Gachago overview: https://gachago.com/en/news/everything-we-know-about-terbis-webzens-new-anime-style-rpg
7. GameToc CBT review (Korean, richest source): https://www.gametoc.co.kr/news/articleView.html?idxno=93509
8. Ruliweb CBT review (Korean): https://bbs.ruliweb.com/news/read/211963
9. Playforum CBT review (Korean): https://www.playforum.net/news/articleView.html?idxno=502971
10. SisaFocus CBT review (Korean): https://www.sisafocus.co.kr/news/articleView.html?idxno=340844
11. GlobalEconomic CBT review (Korean): https://www.g-enews.com/article/ICT/2025/06/202506121707125978c5fa75ef86_1
12. Terbis official community player review: https://terbis.webzen.co.kr/board/958/detail/319472
13. Terbis official probability page: https://terbis.webzen.co.kr/probability/guide/detail/34
14. MuMuPlayer release date article: https://www.mumuplayer.com/blog/terbis-release-date.html
15. Enduins delay report: https://www.enduins.com/news/terbis-launch-delayed-webzen-refines-game-with-player-feedback
16. MoneyToday CBT report (Korean): https://www.mt.co.kr/tech/2025/06/10/2025061014523371226
17. Nate News CBT experience (Korean): https://news.nate.com/view/20250616n21171
18. Anime News Network Comiket advertorial: https://www.animenewsnetwork.com/advertorial/2024-08-14/cosplay-and-freebies-as-webzen-announces-new-character-collecting-rpg-terbis-at-comiket/.214308
19. Uptodown Android listing: https://terbis.en.uptodown.com/android
20. Uptodown Windows listing: https://terbis.en.uptodown.com/windows
21. GameInsight KR review: https://www.gameinsight.co.kr/news/articleView.html?idxno=35472
