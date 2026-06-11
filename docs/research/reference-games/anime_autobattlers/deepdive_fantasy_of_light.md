# Deep-Dive: Fantasy of Light — Design Analysis vs WeaponCraft

**Research date:** 2026-06-08  
**Analyst:** Claude Sonnet 4.6 (automated deep-research pass)  
**Confidence note:** All claims are sourced from public store listings, press releases, emulator guides, and community tier-list articles. No in-game play footage was directly observed. Claims marked [LOW CONF] lack corroborating sources.

---

## 1. Definitive Identity

| Field | Value | Source |
|---|---|---|
| Official title | Fantasy of Light | [App Store US](https://apps.apple.com/us/app/fantasy-of-light/id6651838020) |
| Developer | VORTEXPLAY NETWORK LIMITED | [App Store US](https://apps.apple.com/us/app/fantasy-of-light/id6651838020), [TapTap](https://www.taptap.io/app/33765594) |
| Publisher | LOVO ENTERTAINMENT HONG KONG LIMITED (QooApp/Android distribution); VORTEXPLAY also named on iOS listing | [BlueStacks](https://www.bluestacks.com/apps/role-playing/fantasy-on-pc.html), [QooApp news](https://news.qoo-app.com/en/post/189889/fantasy-of-light-will-be-launched-on-qooapp-on-july-16th-embark-on-a-legendary-journey-immediately), [now.gg](https://now.gg/apps/lovo-entertainment-hong-kong-limited/10561/fantasy-of-light.html) |
| iOS App ID | 6651838020 | [App Store](https://apps.apple.com/us/app/fantasy-of-light/id6651838020) |
| Android package | com.fantasygames.android (primary); com.fantasy.qooapp (QooApp build) | [Google Play](https://play.google.com/store/apps/details?id=com.fantasygames.android), [QooApp](https://m-apps.qoo-app.com/en-US/app/139835) |
| Platforms | iOS 12.0+, Android 7.0+, Mac (M1, via iOS), PC via emulator | App Store listing |
| iOS release date | October 24, 2024 (US App Store); November 4–5, 2024 also cited in other listings | [App Store NZ listing](https://apps.apple.com/nz/app/fantasy-of-light/id6651838020), [TapTap](https://www.taptap.io/app/33765594) |
| QooApp (Android) launch | July 16, 2025 | [QooApp news](https://news.qoo-app.com/en/post/189889/fantasy-of-light-will-be-launched-on-qooapp-on-july-16th-embark-on-a-legendary-journey-immediately) |
| Regions | Global English; QooApp launch targeting Asia/international markets | QooApp press release |
| Marketed genre | Casual idle card RPG / "medieval fantasy" RPG | [QooApp news](https://news.qoo-app.com/en/post/189889/), [BlueStacks](https://www.bluestacks.com/apps/role-playing/fantasy-on-pc.html) |
| Official site | http://xwoplay.com / https://fantasy.xwoplay.com (JavaScript-only, content inaccessible to scraper) | Search results |
| Social | https://www.facebook.com/fantasyxwo | Facebook |
| Age rating | 18+ (frequent cartoon/fantasy violence) | App Store listing |
| App size | ~2 GB (iOS); 667 MB (QooApp APK) | Store listings |
| Current version (as of research) | 1.3 (iOS, updated June 20, 2025); v1.1 QooApp build | App Store, QooApp |
| Store rating | 3.1/5, 33 ratings (iOS US); 3.9/5, 264 ratings (QooApp) | Store listings |
| In-app purchases | $0.99–$1,999 (currency "Amethyst"); gift packs $3.99–$399 | App Store listing |

**Publisher ambiguity note:** VORTEXPLAY NETWORK LIMITED appears as developer/publisher on the iOS App Store. LOVO ENTERTAINMENT HONG KONG LIMITED appears as publisher on BlueStacks, now.gg, and QooApp. The most probable interpretation is VORTEXPLAY = developer/studio, LOVO = publishing/distribution entity. Both names are linked to the same game and same APK content.

---

## 2. Gacha Unit: Heroes vs Weapons

**Finding: Players pull HEROES (characters), not weapons.**

- Rarity tiers confirmed: **UR** (Ultra Rare, highest) > **SSR** > **SR** (implied). The terms "UR hero" and "SSR hero" appear repeatedly in store descriptions and guides.
- New player offer: "Log in for seven days after the server is launched and you can receive a powerful UR hero." — [App Store](https://apps.apple.com/us/app/fantasy-of-light/id6651838020)
- Reroll guides instruct players to target "S-tier characters" from pulls. — [Roonby tier list](https://roonby.com/2024/11/12/fantasy-of-light-tier-list-best-characters-to-reroll/amp/)
- The gacha pool is called "Elemental Recruitment card pool" and "Hero Harbor card pool." Pulls yield heroes (e.g., named characters: Jeanne, Kevin, Angela, Arcadio, Morsedyl, etc.). — [App Store NZ version notes](https://apps.apple.com/nz/app/fantasy-of-light/id6651838020), [Roonby](https://roonby.com/2024/11/12/fantasy-of-light-tier-list-best-characters-to-reroll/amp/)
- "Elemental Sigil" is a soft-pity/exchange currency earned at every-10-pull intervals, redeemable for specific UR/SSR heroes. — App Store review responses
- No weapon-pull banner or weapon gacha is mentioned in any source.
- Pity structure: Soft pity via Sigil accumulation confirmed; hard pity number not publicly documented in indexed sources. [LOW CONF on specific pity number]

---

## 3. Roster Model: Pullable vs Fixed

**Finding: Large, growing, fully-pullable hero roster.**

- At least 12 named meta-tier characters listed in the Roonby (November 2024) tier guide: Morsedyl, Kevin, Angela, Arcadio, Er Qiao, Filna, Jeannie (Jeanne), Jia Xu, Qinglin, Reylan, Rocka, Shingliss. Additional S/A-tier heroes: Elysia, Astrid, Leona. Total visible from a single guide: 15+. — [Roonby](https://roonby.com/2024/11/12/fantasy-of-light-tier-list-best-characters-to-reroll/amp/)
- Five elemental factions: Water, Light, Dark, Nature, Flame — each faction presumably has multiple heroes. — [QooApp news](https://news.qoo-app.com/en/post/189889/)
- Heroes are acquired via: gacha pulls, 7-day login reward (1 UR free), Sigil Exchange, daily task completions. — Multiple sources
- "One-click replacement function for cultivation progress" allows swapping heroes without losing investment — designed to accommodate a large growing roster where players cycle in new meta heroes. — [TapTap](https://www.taptap.io/app/33765594), [QooApp](https://m-apps.qoo-app.com/en-US/app/139835)
- Roster is **not fixed/locked**. The entire hero collection model is gacha-driven.

**Total hero count:** Not explicitly documented in any indexed source. Given 5 factions + tier variety, estimate 30–60+ heroes at launch. [LOW CONF on exact count]

---

## 4. Combat System

**Finding: Auto-battle, team-vs-team (likely front-facing formation), idle-accelerated. NOT side-view wave defense.**

- Update notes confirm "5x battle acceleration" and "battle skip function" — hallmarks of idle/auto-battle RPG, not active wave defense. — [App Store NZ](https://apps.apple.com/nz/app/fantasy-of-light/id6651838020)
- Game engine: Cocos2dx. Characters render as "cute short-legged chibi forms during battle with gorgeous skill effects." — [QooApp news](https://news.qoo-app.com/en/post/189889/)
- Team-building guides describe formation strategies: tank heroes (Jeanne as primary tank, Kevin as secondary), support/healer (Angela), DPS (Arcadio with bleed/lifesteal). Formation roles imply a grid/row-based auto-battle, not a side-view brawler. — [LDPlayer search results], [Roonby tier guide]
- Combat style is described as "strategic lineup composition" and "build an effective lineup to defeat your enemies" — passive team-vs-team, not real-time player-controlled action. — [BlueStacks](https://www.bluestacks.com/apps/role-playing/fantasy-on-pc.html)
- Game modes include Abyss mode and Endless mode (with skip) alongside a story campaign unlocking at player level 80+. — [App Store NZ version notes]
- The "match timer" and "auto/X1/EFFECTS" toggles observed in your video frames are consistent with standard idle-RPG battle UI (speed multiplier toggle, effects toggle, auto-skip) — fully consistent with this game's documented feature set.
- **No manual skill input, no player-controlled ultimates** documented. [LOW CONF — absence of evidence, not evidence of absence]

---

## 5. Run/Session Model

**Finding: Long open-content campaign + idle/AFK — NOT 5-min self-contained runs.**

- Story campaign unlocks progressively (level-gated at 80+). — App Store version history
- Game modes confirmed: story campaign, daily challenges, Team Group Boss, Abyss mode, Endless mode, real-time castle siege (multiplayer), guild dragon boss raid. — [App Store NZ](https://apps.apple.com/nz/app/fantasy-of-light/id6651838020), [QooApp news](https://news.qoo-app.com/en/post/189889/)
- "Expeditions" style content: one-click hero cultivation replacement, pet evolution system, and guild castle occupation all point to persistent ongoing progression — classic idle RPG session model (log in, collect offline gains, spend stamina, do daily missions).
- 300-day consecutive reward ladder (3,001 total rewards) — designed for long-term daily engagement, not run-based play. — [TapTap](https://www.taptap.io/app/33765594)
- "Real-time multiplayer castle-seizing battles" and guild dragon boss raids are endgame content requiring coordination — long-form session model.
- No evidence of discrete 5-min "run" structure, wave-defense arena, or permadeath-per-run mechanic.

---

## 6. Roguelite Layer

**Finding: NO roguelite layer. No between-wave card/skill draft. No run-scoped temporary upgrades.**

- Zero mention of card drafts, run-scoped upgrades, between-wave shops, roguelite mechanics, or permadeath in any indexed source.
- The "Abyss mode" and "Endless mode" names *could* imply roguelite elements (e.g., incremental wave progression), but no source describes draft mechanics or run resets. [LOW CONF — mode details not fully documented]
- Permanent progression via hero cultivation, rune resonance, and relic systems — these are long-term account upgrades, not run-scoped.

---

## 7. Crafting/Forge Meta

**Finding: No weapon-forge or weapon-crafting. "Relics Furnace" exists but is a hero/equipment upgrade system, not a gacha weapon-forge.**

- Three named upgrade subsystems: **Hero Covenant** (likely hero bond/relationship system), **Rune Resonance** (rune/passive equip enhancement), **Relics Furnace** (likely relic/artifact crafting or refinement). — [QooApp news](https://news.qoo-app.com/en/post/189889/)
- "Relics Furnace" name implies a crafting/upgrade UI for relics/artifacts — analogous to AFK Arena's "Elder Tree" or "Twisted Realm" gear, not a weapon-gacha forge.
- No weapon-as-gacha pull, no weapon part system, no forge-wheel mechanic documented anywhere.
- Characters do have equipment slots implied by rune/relic systems, but these are standard idle-RPG gear layers, not a core design bet like WeaponCraft's Forge Wheel.

---

## 8. Synergy Systems

**Finding: Element-based restraint/counter system exists. No compound cross-element "Catalyst" mechanic documented.**

- Five factions (Water, Light, Dark, Nature, Flame) with an elemental restraint counter mechanic: "players can adjust their teammate's match to avoid being restrained by opponents." — App Store review/response text
- Standard 5-element wheel (likely: Water > Flame > Nature > Light > Dark > Water, or similar). — [Duel Masters-style 5-color comparison noted in search]
- No evidence of "cross-element compound" reactions (e.g., Fire + Ice = Steam damage multiplier). The restraint system is a standard advantage/disadvantage matrix, not a compound catalyst reaction.
- Team synergy comes from role composition (tank/healer/DPS) + elemental counter-picking, not element-pair chemistry.

---

## 9. Monetization & Progression

| Layer | Details |
|---|---|
| IAP currency | Amethyst ($0.99–$1,999/bundle) |
| Gift packs | $3.99–$399 (special packs) |
| Gacha pity | Elemental Sigil exchange every 10 pulls (soft pity); hard pity undocumented |
| Free UR path | 7-day login UR; daily task UR channels; Sigil Exchange |
| P2W concern | Players report UR heroes locked behind spending except when featured; developers acknowledged and promised improvement |
| Long-term hook | 300-day/3,001-item reward ladder; guild wars; castle siege endgame |
| Skill cap | Low — auto-battle, team-builder meta, no active inputs |

---

## 10. Audience

- Casual mobile RPG player accustomed to AFK/idle auto-battlers (AFK Arena, Idle Heroes, Eternal Evolution archetype)
- Gacha collector audience (anime character portraits, Live2D, voice acting)
- Guild/social player attracted to castle siege and guild boss modes
- Low-end phone players (667 MB APK, Cocos2dx engine, chibi art = low-spec friendly)
- **NOT** Habby action-game audience (Archero/Wittle Defender — no active skill inputs, no wave-defense roguelite loop)

---

## 11. Six Convergence Questions vs WeaponCraft

| # | Question | Answer | Evidence | Source |
|---|---|---|---|---|
| 1 | Does Fantasy of Light make you pull **WEAPONS** (vs heroes)? | **No** | Players pull heroes (UR/SSR characters) via "Elemental Recruitment" and "Hero Harbor" banners. Zero weapon-pull banner documented. | [App Store](https://apps.apple.com/us/app/fantasy-of-light/id6651838020), [Roonby tier list](https://roonby.com/2024/11/12/fantasy-of-light-tier-list-best-characters-to-reroll/amp/), App Store NZ version notes |
| 2 | Is the hero roster **LOCKED/fixed** (vs open pullable gacha)? | **No** | Large, fully pullable roster. 15+ named heroes visible in Nov 2024 tier guide alone; 5 elemental factions; reroll guides target character pulls. One-click cultivation transfer designed for roster cycling. | [Roonby](https://roonby.com/2024/11/12/fantasy-of-light-tier-list-best-characters-to-reroll/amp/), [QooApp news](https://news.qoo-app.com/en/post/189889/), [TapTap](https://www.taptap.io/app/33765594) |
| 3 | Is it a **5-min wave-defense roguelite arena** (vs open campaign RPG)? | **No** | Story campaign (level-gated), Abyss, Endless, guild boss raid, castle siege — persistent idle/open-content model with 300-day reward ladder. No run-based permadeath structure. | [App Store NZ](https://apps.apple.com/nz/app/fantasy-of-light/id6651838020), [QooApp news](https://news.qoo-app.com/en/post/189889/) |
| 4 | **Between-wave card/skill DRAFT**? | **No** | No draft mechanic of any kind mentioned in any source. Abyss/Endless modes exist but no wave-draft described. | Absence across all sources; [App Store NZ](https://apps.apple.com/nz/app/fantasy-of-light/id6651838020) lists all update content without any draft mention |
| 5 | **Weapon FORGE/crafting meta**? | **No** | "Relics Furnace" is a relic/artifact upgrade system (standard idle-RPG gear layer). No weapon-as-gacha, no forge-wheel, no weapon-part pulls. Heroes are the core collect/upgrade object. | [QooApp news](https://news.qoo-app.com/en/post/189889/), [BlueStacks](https://www.bluestacks.com/apps/role-playing/fantasy-on-pc.html) |
| 6 | **Cross-element compound/Catalyst-like system**? | **No** (partial) | 5-element restraint matrix (Water/Light/Dark/Nature/Flame counter wheel) confirmed. But this is a standard advantage/disadvantage system, not a compound-reaction "Catalyst" mechanic. No source describes paired-element fusion or cross-element chain reactions. | [QooApp news](https://news.qoo-app.com/en/post/189889/), App Store review text |

---

## 12. Overlap Score vs WeaponCraft: **1 / 10**

**Scoring rationale:**

- Q1 Weapon-pull: 0 pts (opposite — hero pull)
- Q2 Fixed roster: 0 pts (opposite — full gacha roster)
- Q3 5-min roguelite arena: 0 pts (opposite — open campaign idle RPG)
- Q4 Between-wave draft: 0 pts (none)
- Q5 Forge/weapon meta: 0 pts (none)
- Q6 Catalyst compounds: +1 pt partial (element restraint exists, but is standard matrix, not compound catalyst)

**Score: 1/10**

---

## 13. Verdict

**UNRELATED** — adjacent genre skin only.

Fantasy of Light is a standard **idle/AFK hero-collector RPG** (AFK Arena archetype) with chibi anime art, large pullable hero roster, persistent open campaign, guild endgame, and no roguelite layer. It shares only two surface-level properties with WeaponCraft: anime aesthetic and auto-battle combat. Every single one of WeaponCraft's six core design bets (weapon-pull, locked roster, 5-min run, between-wave draft, forge wheel, catalyst compounds) is absent. The games target partially overlapping audiences only at the broadest level (mobile anime gacha), but the session model, monetization bet, and core gameplay loop are completely different categories. Fantasy of Light competes with Idle Heroes, AFK Arena, and Eternal Evolution — not with WeaponCraft or the Habby/Archero action-game lineage.

---

## Sources

- [Fantasy of Light — Apple App Store US](https://apps.apple.com/us/app/fantasy-of-light/id6651838020)
- [Fantasy of Light — Apple App Store NZ (version notes)](https://apps.apple.com/nz/app/fantasy-of-light/id6651838020)
- [Fantasy of Light — TapTap](https://www.taptap.io/app/33765594)
- [Fantasy of Light — QooApp](https://m-apps.qoo-app.com/en-US/app/139835)
- [QooApp Press Release — July 16 2025 launch](https://news.qoo-app.com/en/post/189889/fantasy-of-light-will-be-launched-on-qooapp-on-july-16th-embark-on-a-legendary-journey-immediately)
- [BlueStacks emulator page](https://www.bluestacks.com/apps/role-playing/fantasy-on-pc.html)
- [Roonby — Tier List and Reroll Guide (Nov 2024)](https://roonby.com/2024/11/12/fantasy-of-light-tier-list-best-characters-to-reroll/amp/)
- [VORTEXPLAY NETWORK LIMITED — App Store developer page](https://apps.apple.com/us/developer/vortexplay-network-limited/id1746033629)
- [now.gg listing (LOVO ENTERTAINMENT)](https://now.gg/apps/lovo-entertainment-hong-kong-limited/10561/fantasy-of-light.html)
- [LDPlayer — Team Composition Guide](https://www.ldplayer.net/blog/fantasy-of-light-best-team-building-and-team-composition-guide.html) (403 on direct fetch; details surfaced via search snippet)
- [LDPlayer — Tier List 2025](https://www.ldplayer.net/blog/fantasy-of-light-tier-list.html) (403 on direct fetch; details surfaced via search snippet)
