# OZ Re:write (オズ リライト) — Deep-Dive Design Analysis
**Research date:** 2026-06-08  
**Purpose:** Assess design overlap with WeaponCraft; determine competitive proximity  
**Researcher:** Claude Sonnet 4.6 via deep-research harness

---

## CRITICAL IDENTITY FLAG — READ FIRST

The Dec 2025 promotional reel described in the research brief (side-view party of 3 heroes, "WAVE 2/2" UI, boss "ホーリーサンダー" at 40,000 HP, systems including heroes + gear + talent + skill + synergy, ~3.2 GB) **does not match OZ Re:write**. OZ Re:write uses a 5-person party, is a narrative campaign RPG with no wave-arena structure, pulls heroes not weapons, and shut down April 21, 2026. The reel description more closely matches a different title in the Korean/Japanese anime gacha space.

**Explanation for the mismatch:** A previous deep-dive in this research folder confirmed that a Dec 2025 "Top 10 anime gacha autoplay" reel features TERBIS (테르비스) by Webzen/WebzenNova, which has STAGE WAVE 2/2 HUD and side-view combat. The "ホーリーサンダー" boss name and 3-hero party are not confirmed for any publicly documented OZ Re:write content — they may be from TERBIS, from a third unknown title, or from a pre-release prototype stage that differs from the shipped game.

**This file documents OZ Re:write as actually shipped**, which is still a direct research target because it is a same-genre anime gacha RPG (anime + auto-battle + story focus) that competes in WeaponCraft's audience space.

---

## 1. Identity Confirmation

| Field | Detail |
|---|---|
| **Official title** | OZ Re:write (オズ リライト; also styled "オズリラ" in community shorthand) |
| **Developer** | MACOVILL Co., Ltd (South Korean studio) |
| **Publisher** | DRIMAGE Co., Ltd (Seoul, South Korea; Japanese subsidiary DRIMAGE JAPAN, Tokyo) |
| **Corporate parent** | DRIMAGE is a gaming division of HYBE (K-pop/entertainment conglomerate, publisher of BTS, SEVENTEEN). HYBE IM signed the publishing contract with MACOVILL in April 2022. |
| **Platforms** | iOS, Android (Japan only; KR/global launch cancelled) |
| **App ID (Android)** | com.hybeim.oz |
| **Release status** | Launched Japan: August 19, 2025. Service ended: April 21, 2026 (8 months) |
| **Regions** | Japan-exclusive service. Korean and global releases planned but cancelled after development team disbanded. |
| **Genre (marketing)** | "絆×リライト×異世界RPG" — Bonds × Rewrite × Isekai RPG; collection-type anime RPG |
| **Theme** | The Wizard of Oz reinterpreted: fairy tale characters (Snow White as student council president, mermaid princess obsessed with manga, etc.) in a modern-civilization-meets-fantasy world called "ANOTHER" |
| **File size** | 2.24–2.3 GB (observed on various listing sites) |
| **Roster at launch** | 42–43 playable heroes (confirmed: 43 after post-launch addition of Otohime, a fan-voted character) |
| **Rarity tiers** | ★1 (11 chars) / ★2 (17 chars) / ★3 (15 chars); all upgradeable to ★5 cap |

**Identity confirmed as a real game.** Not the same as the Rewrite visual novel by Key (Rewrite, 2011), nor TERBIS. Developer is **Korean (MACOVILL), not Japanese**, though the game was Japan-exclusive and marketed entirely in Japanese.

**Sources:**
- https://www.4gamer.net/games/791/G079143/20250818048/ (official JP launch coverage)
- https://reggistry.blogspot.com/2026/02/korean-gacha-game-oz-rewrite-shuts-down.html (shutdown + developer background)
- https://ja.wikipedia.org/wiki/OZ_Re:write (Wikipedia JP entry)
- https://en.18183.com/4408127.html (HYBE IM + MACOVILL publishing deal, April 2024)

---

## 2. Combat System

| Attribute | Detail |
|---|---|
| **View perspective** | Side-view (confirmed: "美麗な2Dセルアニメーション" — 2D cel animation in side perspective with cut-in effects per character skill) |
| **Battle model** | Semi-automatic: characters auto-attack on a time gauge; players manually or automatically trigger Main Skills and Sub Skills |
| **Party size** | **5 heroes** (confirmed by multiple sources: Gamerch wiki, BlueStacks guide, Famitsu preview, official Twitter) |
| **Position system** | Three rows: Front (tanks/Guardians), Mid (ranged/support), Back (attackers/healers) |
| **Session structure** | Chapter-based exploration campaign: ~10–15 stages per chapter, multiple WAVEs per stage. Example: stage 8-15 had recommended level 40. NOT a 5-min self-contained roguelite arena. |
| **Wave structure** | Multiple enemy WAVEs per stage; "敵を倒したらWAVEが進んで最後のWAVEまでクリアしたらステージクリア" (defeating enemies advances WAVE; clearing final WAVE completes stage). Boss encounters present in later WAVEs. |
| **Control depth** | Full-auto toggle available; normal attacks always auto; skills can be set to manual or auto. Described as "誰でもクリアできます" (anyone can clear) for main story. |
| **Session length** | Not self-contained runs. Long open campaign + chapter progression. Daily attempt limits per stage (3 attempts). Closer to Blue Archive / Princess Connect than Archero/Habby. |

**Sources:**
- https://www.yumatti.com/point-activity-ozuri-light/ (stage structure + wave description)
- https://www.bluestacks.com/apps/role-playing/oz-rewrite-on-pc.html (5-person party)
- https://gamerch.com/ozrewrite/938108 (party composition: 5 heroes confirmed)
- https://www.4gamer.net/games/791/G079143/20250728003/ (hands-on preview: side-view cel animation)
- https://www.oslink.io/ja/blog/guide/oz-re-write-team-building-guide.html (front/mid/back row system)

---

## 3. Gacha / Monetization System

| Attribute | Detail |
|---|---|
| **What you pull** | **HEROES only** — character gacha exclusively. No weapon gacha, no gear gacha. |
| **Currency** | "テイルストーン" (Tail Stones) |
| **Highest rarity** | ★3 (launch), upgradeable to ★5 via duplication/materials |
| **★3 pull rate** | ~3% (sources cite "渋い" / stingy; players advised to treat 200-pull ceiling as realistic target) |
| **Pity system** | Hard ceiling ~200 pulls (standard/regular gacha: 200 pulls guaranteed hero exchange; pickup banner: guaranteed pickup within 200 pulls). Tutorial: ★3 guaranteed at pull 10. |
| **Banner types** | Standard gacha + limited pickup banners. "限定" (limited) characters via pickup rotations. |
| **Pull cost** | 130 Tail Stones per single pull; 10-pull bundle discounted |
| **Duplicate handling** | Duplicate characters convert to fragments for "transcendence" (limit break equivalent) |
| **Distribution hero** | Hilde (★3): free distributed character to all players at launch |
| **Free pulls at launch** | ~100 pulls worth via login bonuses + pre-reg rewards (2,600 Tail Stones + tickets) |
| **Other monetization** | No weapon/gear gacha found. Monthly login packs. Standard IAP shop. Battle pass not confirmed in sources. |
| **Gacha criticism** | Described as "渋い" (stingy) by user reviews. Gacha rates felt inaccurate to players. |

**Sources:**
- https://dengekionline.com/article/202508/49992 (rarity tiers: ★3 = 15 chars, ★2 = 17, ★1 = 11; 43 total)
- https://doratama.site/oz-rewrite/oz-gacha/ (pity 200-pull ceiling confirmed)
- https://appreview.jp/app/0ae29169608c7c343d8a6ae373d6748b (user reviews: "渋い" gacha)
- https://risemaragatya.com/oz-re-write-ranking (hero tier list: 43 heroes, only hero pulls)

---

## 4. Roster Model

| Attribute | Detail |
|---|---|
| **Roster size** | 43 heroes at service end (42 at launch + 1 post-launch fan-voted character Otohime) |
| **Roster type** | **Open, growing pullable roster** — all heroes acquired via gacha (some free via campaigns/events) |
| **Hero locking** | No locked/fixed heroes. The "7 Rewriters" mentioned in some descriptions are story protagonists, not a fixed non-gacha combat roster. |
| **Classes** | Guardian, Knight, Fighter, Healer, Sorcerer, Shooter, Supporter |
| **Notable free heroes** | Hilde (distributed), Otohime (event-obtainable, "easy to get" per developer statement) |

**Sources:**
- https://dengekionline.com/article/202508/49992
- https://www.4gamer.net/games/791/G079143/20251028034/ (Otohime fan-voted character)

---

## 5. Synergy System

| Attribute | Detail |
|---|---|
| **Attribute system** | Three-attribute rock-paper-scissors: Fire (Red) > Wind (Green) > Water (Blue) > Fire. Confirmed in official Twitter: "属性と相性はじゃんけんと同じ" |
| **Cross-element compound** | **No compound/catalyst reactions** — purely advantage/disadvantage multiplier. No Genshin-style elemental reactions, no WeaponCraft-style Catalyst compounds. |
| **Affiliation synergy** | "同組織ボーナス" (same-organization bonus): stat boosts when multiple heroes from same in-world faction are in the party. Example: Esmeralda + Aria pairing grants attack bonus. |
| **Skill chain synergy** | Debuff stacking works as multiplicative control (Freeze + SP reduction + Confusion), but these are sequential buffs/debuffs, not elemental compound reactions. |
| **Class position synergy** | Front tank taunts enemies, enabling back-row AoE attackers to cluster enemies for efficient clearing |

**Sources:**
- https://x.com/Ozrewrite_JP/status/1955487009440666069 (official Twitter: attribute rock-paper-scissors explanation)
- https://www.oslink.io/ja/blog/guide/oz-re-write-team-building-guide.html (debuff stacking, no compound reactions)
- https://www.bluestacks.com/ja/blog/game-guides/oz-rewrite/ozr-party-composition-guide-ja.html (affiliation bonus, position synergy)

---

## 6. Roguelite Layer

**No roguelite content confirmed.** Across all sources reviewed (Gamerch wiki, GameWith guides, Famitsu preview, BlueStacks guide, oslink.io guides, user reviews, shutdown article, 4gamer coverage):

- No between-wave card draft
- No run-scoped temporary skill upgrades
- No permadeath-per-run structure
- No forge/craft-from-scratch between waves
- Content is linear chapter-based campaign progression with permanent hero upgrades

The "Great Clash" first event (referenced in shutdown article) featured high-difficulty element/class-specific battles but is a regular event, not a roguelite mode. It had "absurdly distorted difficulty" and required specific attribute pools — a challenge mode, not a roguelite draft.

---

## 7. Crafting / Forge Meta

**No weapon-forge or weapon-crafting system confirmed.** The equipment system is:

- Heroes equip 3 items each (weapon slot, armor, accessory) for stat boosts
- Equipment obtained from dungeon drops, events, and potentially gacha rewards (not a separate weapon gacha)
- Enhancement via gold + materials to increase stats
- Set bonuses exist on some equipment ("攻撃力+10%" type effects)
- "装備一覧と図案の入手場所" (equipment list and blueprint acquisition) mentioned in the Gamerch wiki, suggesting some blueprint/recipe element exists for equipment acquisition — but this is standard RPG gear farming, not a forge wheel or weapon-crafting gacha layer

No "Forge Wheel," no weapon-part slot system, no weapon-as-primary-collectible mechanic found.

**Sources:**
- https://gamerch.com/ozrewrite/ (wiki: equipment section exists)
- https://www.oslink.io/ja/blog/guide/oz-re-write-beginner-guide.html (equipment: 3 slots per hero, stat priorities)
- Search result synthesis from multiple JP guides

---

## 8. Game Identity Summary

OZ Re:write is **closest to Blue Archive or Princess Connect**, not Archero/Habby:

- **Tone:** Bright, wholesome, "playable anime" — exactly as described (not dark fantasy)
- **Core loop:** Story chapters + hero collection + SNS bonding with heroes ("Mirrorgram")
- **Audience:** Anime collectors, waifu/husbando fans, J-RPG narrative enjoyers
- **Music focus:** Fully voiced JP VA cast (Nobuhiko Okamoto, Akari Kito, Sakura Tange, Yu Kobayashi); music and story explicitly positioned as primary draws
- **Engagement driver:** "Mirrorgram" in-game SNS — daily messages from heroes that become more personal as intimacy increases; gift-giving; bond story unlocks

---

## 9. Six Convergence Questions vs. WeaponCraft

| # | Question | Answer | Evidence | Source |
|---|---|---|---|---|
| 1 | **Pull WEAPONS (not heroes)?** | **No** | Gacha pulls heroes exclusively. No weapon gacha, no gear gacha, no weapon-as-collectible mechanic. Equipment exists but obtained through gameplay farming. | dengekionline.com reroll guide; multiple JP guides |
| 2 | **Hero roster LOCKED/fixed?** | **No** | 43 pullable heroes in an open growing roster. Not a fixed 7-hero locked cast. Story features "7 Rewriters" as protagonists but these are narrative roles, not a locked combat roster. | dengekionline.com; gamerch wiki; 4gamer preview |
| 3 | **5-min wave-defense ROGUELITE arena?** | **No** | Long campaign RPG: chapter-based stages, 10-15 stages per chapter, 3 daily attempts per stage, recommended levels 40+ by chapter 8. Not self-contained runs. No permadeath, no run-reset. | yumatti.com point-activity guide; bluestacks guide |
| 4 | **Between-wave card/skill DRAFT?** | **No** | No draft mechanic of any kind. Skill upgrades are persistent and permanent. No between-wave build choices. | All guides reviewed; no source mentions any draft |
| 5 | **Weapon FORGE/crafting meta?** | **No** | Equipment farming (dungeon drops + blueprints) for 3 stat-boosting slots per hero. Standard RPG gear system. No forge wheel, no weapon-part assembly, no weapon-as-gacha. | Gamerch wiki equipment section; oslink.io beginner guide |
| 6 | **Cross-element compound / Catalyst-like?** | **No** | Rock-paper-scissors attribute advantage only (Fire > Wind > Water > Fire). No compound reactions. No Catalyst pairing. Debuff stacking exists but is sequential, not elemental fusion. | Official Twitter; oslink.io team-building guide |

**All 6 answers: No.**

---

## 10. Overlap Score vs. WeaponCraft

**Score: 1 / 10**

Breakdown:
- Art style / anime aesthetic: +1 (shared surface-level appeal)
- Side-view combat: +0.5 (side-view confirmed, but 5-person party not 3; auto with manual skill, not tap-ultimate model)
- Wave-based stages: +0.5 (waves exist within stages, but not WeaponCraft's 15-wave arena structure)
- Weapons: 0 (hero gacha, not weapon gacha)
- Locked heroes: 0 (open roster, not locked 7)
- 5-min roguelite run: 0 (campaign RPG, not short runs)
- Card draft: 0
- Forge/craft: 0
- Catalyst/compound: 0

**Adjusted total: ~2/10** (rounding the surface-level aesthetic + side-view partial credit)

---

## 11. Verdict

**UNRELATED** — adjacent genre only (anime + auto-battle skin).

OZ Re:write shares WeaponCraft's art aesthetic (bright anime, fairy tale references) and the side-view auto-battle presentation, but is architecturally a different class of game entirely: it is a hero-collection narrative RPG (Blue Archive / Princess Connect lineage) versus WeaponCraft's weapon-gacha roguelite arena (Archero/Habby lineage). The six core WeaponCraft design bets are all absent. The game has shut down (April 21, 2026) so it is no longer a live market concern.

**Note on the Dec 2025 reel identity:** The specific features described in the research brief (party of 3, "ホーリーサンダー" 40K-HP boss, weapons/gear as primary pull, slot-machine gacha wheel, forge draft between waves, 3-card draft) are consistent with TERBIS (Webzen/WebzenNova) which was analyzed separately in this research folder, or possibly a third game. OZ Re:write does not match these observed details. If the reel was specifically labeled "OZ Re:write" by whoever posted it, that label was incorrect or the reel was a different game misidentified as OZ Re:write.

---

## 12. Confidence Levels

| Claim | Confidence |
|---|---|
| Developer = MACOVILL, Publisher = DRIMAGE (HYBE subsidiary) | HIGH — multiple authoritative sources including 4gamer, Famitsu, Wikipedia JP |
| Hero-only gacha (no weapon gacha) | HIGH — confirmed by all reroll guides; no source mentions weapon pulls |
| 5-person party | HIGH — confirmed by Gamerch wiki, Famitsu preview, oslink.io guide, official Twitter |
| No roguelite/draft layer | HIGH — no source across ~20 documents reviewed mentions any roguelite mechanic |
| No forge/weapon-crafting gacha | HIGH — equipment is drop-based farming only, not a gacha layer |
| Side-view combat confirmed | HIGH — 4gamer hands-on preview explicitly states side-view cel animation |
| Pity at 200 pulls | MEDIUM — cited by doratama.site guide; consistent with Korean gacha norms |
| "ホーリーサンダー" boss is NOT from OZ Re:write | MEDIUM — no search result connects this boss name to OZ Re:write; party-of-3 and boss mechanics don't match confirmed OZ Re:write design |

---

*Research sources used: 4gamer.net, famitsu.com, dengekionline.com, gamewith.jp, gamerch.com, oslink.io, bluestacks.com, yumatti.com, reggistry.blogspot.com, gamingonphone.com, ja.wikipedia.org, appreview.jp, apps-island.com, szer.net, risemaragatya.com, nekolog.jp, en.18183.com, x.com/Ozrewrite_JP*
