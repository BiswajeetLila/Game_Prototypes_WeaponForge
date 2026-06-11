# AFK Journey — Cross-Video Synthesis

**Generated:** 2026-06-11
**Videos analyzed:** v1-f2-9q0wgfOY, v2-0mb9XIFjFG4, v3-48SNAAhcKLk, v4-x4YngIZN1-8

---

## 1. What These Videos Cover

| Video | ID | Title Summary | Focus Area |
|---|---|---|---|
| v1 | f2-9q0wgfOY | New Player Tip Guide — Classes, Teams, Resonance Hall | New-player orientation: factions, classes, team composition, Resonance Hall unlock, combat B-roll |
| v2 | 0mb9XIFjFG4 | Hero Resonance and Resonance Synergy Explained | Late-game leveling wall (Lv240+ Resonance Synergy), Training Manual conversion, Max Equipment unlock |
| v3 | 48SNAAhcKLk | Mythic Charm Priority Guide (Season ~current) | Charm crafting priority by faction/hero for Dream Realm and AFK Stages |
| v4 | x4YngIZN1-8 | Mythic Charm Priority Guide — Season 4 | Week-1 charm priority for Season 4, hero-by-hero Dream Realm recommendations, charm set effects |

v1 is the only video with live combat footage. v2 focuses exclusively on the Resonating Hall UI and progression mechanics. v3 and v4 are both charm priority guides covering overlapping hero pools from different seasonal contexts (v3 = Season current global; v4 = Season 4 VN-server ahead-of-global perspective).

---

## 2. Combat System Summary

**Source:** v1 exclusively — all other videos show no combat.

### Arena / Battle Modes Observed

| Mode | Environment | Timer | Gold Passive |
|---|---|---|---|
| AFK Stages (world map) | Vaduso Mountains (sandy ruins), Oblivion Valley (green forest) | 80s countdown | Yes (0 → 800 per battle) |
| Dream Realm (boss raid) | Teal-floor arena, yellow/teal stone walls | None visible | No |
| Elite Challenge | Holy Temple Cave — dark colosseum, purple torches | 70s | No |

### Battle HUD Elements (v1)
- Top center: location name + coordinates (e.g. "Vaduso Mountains(387, 323)")
- Top right: countdown timer + accumulated gold
- Hero bottom bar: 5 portrait icons, names visible, energy meter under each
- Controls: pause (||), chat (...), 2x speed, gear
- Left edge: green energy charge bar
- Status effects float above units (green "Immune", "Phys Immunity", "Unaffected", "Life Drain+", "ATK SPD+")

### VFX Catalog — All Named Effects (v1 frames)

| # | Effect Name | Color/Shape | Size | Context |
|---|---|---|---|---|
| 1 | Golden Ring AoE | Flat warm-gold circle, ground-level | ~4 hero-widths diameter | Buff/heal area (f_00043, f_00097) |
| 2 | Blue Energy Beam | Narrow plasma column, blue-white | Single-target width | Ranged hero to boss (f_00055, f_00067, f_00069, f_00143) |
| 3 | Full-Screen Teal Downpour | Vertical teal light columns, full arena | Full screen | Ultimate-tier (f_00071) |
| 4 | Purple/Red Crescent Moon | Rotating crescent ring, purple-red | Mid-field coverage | Likely Lyca or rogue AOE (f_00035, f_00069, f_00107) |
| 5 | Lightning Crackle Ring | Blue-white lightning from yellow ground circle | Large diameter, screen darkens | AoE stun/electro (f_00017, f_00081, f_00083, f_00103) |
| 6 | Orange Fire Explosion | Warm orange-red circular burst + particle sparks | Single-target | Boss hit (f_00083, f_00109) |
| 7 | Cyan Ice/Water Radial Wave | Full-screen, arc brushstroke texture | Full screen | White mage ultimate (f_00033) |
| 8 | Golden Pillar Level-Up | Three vertical gold pillars, hero silhouetted | Full-screen takeover | Level-up moment (f_00019, f_00119, f_00125) |
| 9 | White Star Burst | Tight white sparkle burst | Small, tight | Crit or short-range impact (f_00089, f_00095) |
| 10 | Life Drain Loop | Gold/orange orbiting tendril | Hero-to-target arc | Vampiric drain VFX (f_00153) |
| 11 | Phys Immunity Shield | Blue ring on unit | Unit-sized | Boss phase: "Phys Immunity" text floats above (f_00073, f_00075, f_00105) |
| 12 | Lightning Column Rain | 4-5 simultaneous white-blue columns from above | Full-width multi-hit | Ultimate strike on boss (f_00157) |
| 13 | ATK SPD Buff | Green upward-triangle text on allies | Text overlay | Buff indicator (f_00089) |
| 14 | Red Concentric Sweep | Large red orbital ring around boss | Boss-sized | Boss sweep attack or hero orbital (f_00107) |
| 15 | Golden Starburst/Torus | Wide gold ring with starburst | Boss-sized | Shield or armor phase on boss (f_00075, f_00077, f_00117) |
| 16 | Green AoE Ring Heal | Large green ring + sparkle particles | 3-4 hero-widths | Party heal (f_00097) |
| 17 | Pink Sword Arc | Pink slash arc | Single-target | Melee rogue strike (f_00067) |

### Camera Shake
Observed at f_00017, f_00033, f_00103, f_00157 — all full-screen VFX saturation moments. Approximate frequency: heavy shake on ~4 out of every 15 frames of Dream Realm combat (roughly every 3-4 seconds during boss phases). Camera shake is reserved for ultimate-tier abilities only; standard hits do not trigger it.

### Damage Number System (v1)
| Color | Meaning | Observed Range |
|---|---|---|
| Green +NNK | Heals | +137K, +171K, +293K, +358K, +447K |
| Yellow/gold | Normal hits or chain combos | "6+200", "6+32" chain combos |
| Purple +NNNNN | Critical hits | +63,365 |
| Blue +NNNK | Magic ability damage | +293K |
| Red NNNNN | Damage received / low hits | 13,864, -4K |

---

## 3. UI/UX Flow Map

Every distinct UI screen observed across all 4 videos, with source video noted.

| Screen | Description | Video(s) |
|---|---|---|
| AFK Stage Idle Collection | AFK duration clock + reward grid + Instant/Collect buttons | v1 |
| AFK Stage Progress Map | Linear node bar (stages 199-204), current + boss nodes visible | v1 |
| World Map Team Selection | Hex grid top-down, enemy/player levels, hero card tray, Battle button | v1 |
| Auto-Battle HUD | In-battle: location name, timer, hero bar, speed controls, gold counter | v1 |
| Elite Challenge HUD | Named boss fight, boss HP bar + stack counter, hero dialogue bubble, purple-lit colosseum | v1 |
| Victory Screen — Full Party | "VICTORY" serif text, 4 heroes walking, reward icons | v1 |
| Victory Screen — Hero Highlight | Single hero pose, class badge (letter + two-word title) | v1 |
| Resonance Swap | "Choose the hero to be replaced" header, 5 current Hands + large hero grid, Confirm button | v1 |
| Journey's Gift (Login Calendar) | 7-day list, days 1-2 claimed, Day 7 = Epic hero chest | v1 |
| Draw for Epic Heroes / Login Milestone | Flip-card slots, login milestone bar, hero portrait grid below | v1 |
| Cross-Platform Promo (no HUD) | iMac+iPhone mockup on meadow, AFK Journey logo | v1 |
| PvP Hex Placement | Light grey hex tile grid, forest backdrop, unit placement | v1 |
| World Environment Art (no HUD) | Greek/Roman shrine, turquoise water, no UI | v1 |
| Equipment Screen | Hero artwork, stat popup (ATK/DEF/Haste/Healing/Power), 6 equipment slots, Quick Equip button | v1, v2 |
| Resonating Hall — Hero Roster View | 3D hall scene, 5 Hands of Resonance + full Resonance Heroes grid, Artifacts/Equipment buttons | v1, v2 |
| Resonating Hall — 3D Navigation View | Hall scene with floating "Equipment" / "Artifact" labels, chibi heroes on glowing platform | v2 |
| Resonance Synergy Level-Up Panel | Large level number (275/300), Level Up button, Convert button, Power Change display | v2 |
| Training Manual Conversion Dialog | Modal: wizard mascot, 4869K Training Manuals → 1475 Hero Essence, confirm/cancel | v2 |
| Treasure Found Reward Popup | Full-screen takeover, amber glow, item card + quantity, "Tap to close" | v2 |
| Max Resonance Synergy Level Tooltip | Bullet-point info, Current Max Level 340, Supreme+ hero grid (8 heroes) | v2 |
| Class Upgrade / Equipment Overview | Stained-glass arch art, 6 class silhouettes all at Max, Congrats banner | v2 |
| Marksman Equipment Detail | Deer/stag archer art, 6 Max equipment slots, Congrats banner, Max Forging Level 249 | v2 |
| Hero Detail Page (Charm view) | Hero portrait, 3 skill icons, charm slot grid with charm type icons | v3, v4 |
| Magic Charms Crafting UI | Charm type selector, quality tiers (Epic → Legendary+ → Mythic+), set effect preview | v3, v4 |
| Resonance Hall / Soul Pact Roster | Scrolled roster of all heroes; shows ascension tier per hero | v3 |
| Charm Priority Overlay (custom, not in-game) | Fixed top-left presenter overlay listing recommended heroes by priority order | v4 |
| Farlight Store (affiliate page, in-game browser) | Web page embedded in game for dragon crystal purchases | v3 |

---

## 4. Heroes Catalog

All heroes named or shown across all 4 videos. Heroes from v3/v4 are named in transcript only (no visual confirmation from frames in analyzed ANALYSIS.md — v3 has no ANALYSIS.md, v4 ANALYSIS.md is a stub).

### Heroes with Visual Confirmation (v1, v2)

| Hero | Class | Faction | Level Seen | Power | Notes |
|---|---|---|---|---|---|
| Brutus | Tank/Warrior | Mauler (red/orange) | Lv130 | 1,546,989 | "Talented Tank" badge; lion warrior art |
| Lyca | Marksman | Wilder (green) | Lv130 | — | Recurring in party (AFK Stages + Dream Realm) |
| Silvina | Rogue | Graveborn (purple) | Lv130 | — | AFK Stages party member |
| Casadra | Support | Lightbringer (blue) | Lv130 | — | AFK Stages party member |
| Atalanta | Support/Healer | Wilder (green) | Elite level | — | Elite Challenge; dialogue: "How's the Holy Hammer taste, big guy!!" |
| Healyn | Support (Healer) | Wilder (green) | — | — | "Hotshot Healer" badge; blonde elf, green/white dress, leaf cape |
| Helcyna | Unknown | Unknown | Oblivion Valley | — | Named in Oblivion Valley battle |
| Lucius | Tank/Warrior | Lightbringer (blue) | Oblivion Valley | — | Named in Oblivion Valley battle |
| Gothic Mage | Mage | Graveborn (purple) | Lv130 | 1,838,928 | Long green hair, pale, black/white dress, candelabra |
| Red-haired Support | Support | Unknown | Lv130 | 1,731,650 | Red hair, black bird companion on log |
| Antlered Elf Rogue | Rogue | Wilder (green) | Lv130 | — | Glowing green sword; Gold star Quick Equip upgrade available |
| Stone Warrior | Warrior | Unknown | Lv130 | — | Mechanical stone art |
| Deer/Stag Marksman | Marksman | Unknown | Lv130 | — | Anthropomorphic stag, golden armor, bow; seen in v2 Class Equipment screen |

### Heroes Named in v3/v4 Transcripts (charm priority guides)

**Lightbearers:** Hogan, Sylvan, Zanny, Siren, Perseus, Cassy
**Wilders:** Valera, Solise, Fera Mora, Flora Bell, Ravan, Theodora, Lilith May
**Maulers:** Galahad (referred to as "the queen"), Korden, Smokey, Nazik, Masha, Shakira
**Graveborn:** Shamira, Damon, Voka, Isabella, Thorin/King Croaker, Shadring, Ludovic, Bonnie
**Celestial/Hypogean:** Twins, Aurora, Balerion, Alice, Alna, Taylean, Contes, Gorvo, Huroc, Forestro, Ravadrum, Titan Reaver, Mejira, Rainier, Kulu, Saida, Pandora, Sinbad, Krueger, Phamore, Tossi, Aara, Boran

### Ascension Tiers Referenced
- Grade A hero (easier gacha pull, lower shop cost)
- Grade S hero (harder to pull)
- Supreme+ (highest ascension; each Supreme+ hero raises Resonance Synergy cap by 5 levels)
- 8 Supreme+ heroes confirmed in v2 (presenter's account)

---

## 5. Progression Touchpoints

All progression moments observed or described across all 4 videos.

| Moment | System | Details | Video |
|---|---|---|---|
| Daily Login Calendar | Journey's Gift | 7-day rewards; Day 7 = Select Hero Chest (Epic) | v1 |
| Login Flip-Card Draw | Draw for Epic Heroes | 4 flip-card slots unlock at 7/14/21/28 login milestones; grid of 20 hero portraits | v1 |
| Level-Up (individual hero) | Hero leveling | Golden pillar animation; Level 95, 96, 98 observed; resources shown (XP/gold costs) | v1 |
| Resonance Swap | Resonance Hall | Swap heroes in/out of 5 Hands with no cost; all Resonance Heroes auto-synced to Resonance Level | v1, v2 |
| Resonance Level = 120 | Resonance Hall | Synced level for all heroes at mid-game; seen in v1 (Lv120 roster) | v1 |
| Resonance Level = 275 → 276 | Resonance Synergy | Late-game: convert Training Manuals (4869K) → Hero Essence (1475) → level up; all heroes instantly sync | v2 |
| Resonance Synergy Unlock | Milestone at Lv240 | System unlocks at Resonance Level 240; all heroes gain unified leveling from that point | v2 |
| Max Equipment Unlock | Class Equipment | Unlocks at Resonance Level 240; all 6 class equipment types can reach Max Forging Level | v2 |
| Supreme+ Ascension | Hero ascension | Each Supreme+ hero owned raises Resonance Synergy hard cap by +5 (8 owned = cap raised to 340 from base 300) | v2 |
| Equipment Level 130 | Equipment screen | Equipment Level 130 shown; stats: ATK +3222/+3773, Haste +11.6, Healing +18.0, Power ~1.5M-1.8M | v1 |
| Mythic Charm Crafting | Magic Charms | New system unlocked when Dura Trials floors reach mythic tier; charms slot per hero with set effects | v3, v4 |
| Charm Quality Tiers | Magic Charms | Epic → Legendary+ → Mythic+ progression; Mythic+ grants set effect bonuses | v3, v4 |
| Dream Realm Score Push | Dream Realm | Charm investment directly raises boss fight scores (e.g. Ludovic insight charms = +10-15B damage on Sigman boss) | v4 |
| AFK Stage Progress | AFK Stages | Linear node progression; Stage 200 (current) to Stage 203 (boss node) observed | v1 |

---

## 6. Game Mode Summary

All game modes demonstrated or described across all 4 videos.

### AFK Stages (World Map Auto-Battle)
- **Shown in:** v1
- **Description:** Top-down isometric auto-combat. 5-hero party vs 5-8 enemies. Passive gold accumulates during battle.
- **UI:** Location name + coordinates, 80s timer, gold counter, 5-portrait hero bar, 2x speed toggle
- **Biomes confirmed:** Vaduso Mountains (sandy ruins, purple stones), Oblivion Valley (green forest)
- **Stage progression:** Linear node map; standard nodes + purple diamond boss nodes

### AFK Idle Farming
- **Shown in:** v1
- **Description:** Passive offline accumulation. Screen shows AFK duration (3h43m example) and accumulated rewards (7k gold, 203 diamonds, 30k XP).
- **UI:** AFK clock, 2x6 reward grid, "Instant" button (2 free fast-collects) + "Collect" button

### Dream Realm (Boss Raid)
- **Shown in:** v1 (gameplay); v3/v4 (charm priority context only)
- **Description:** Dedicated arena boss fight vs single large boss. Party of 5 heroes. Boss has phase mechanics (Phys Immunity, stack counters). Very large K-scale damage numbers.
- **UI:** Teal floor arena, boss in targeting circle, K-scale heal/damage numbers, status effects floating
- **Bosses seen:** Nature tree creature (leaf crown, bark torso); Sarothian boss, Sigman boss, Doom Scourge boss, Nocturne Grove boss, Necro Draken (named in v3/v4 transcripts)
- **Difficulty tiers:** Standard → Endless (requires stronger builds for top score)

### Elite Challenge
- **Shown in:** v1
- **Description:** Named boss fight in a specific named location. Boss has a stack counter (x30 → x17 observed). Hero dialogue triggers mid-combat. Dark colosseum environment.
- **UI:** Location + "Elite Challenge" subtitle, boss HP orange bar, xNN stack counter, hero speech bubble, 70s timer
- **Boss seen:** White stone golem (Holy Temple Cave 24,31) — blue gem joints, claw arms

### PvP / Honor Duel (Hex Placement)
- **Shown in:** v1 (pre-battle placement only)
- **Description:** Hexagonal tile grid deployment. Player places heroes on specific hexes before combat begins.
- **UI:** Light grey hex grid, forest backdrop, orange/green button row at bottom

### World Map Exploration + Team Deployment
- **Shown in:** v1
- **Description:** Top-down hex grid world map. Enemy camps have level tags (Lv149 observed). Pre-battle hero selection panel slides up from bottom.
- **UI:** Green diamond resource counter, gold counter, hex grid with level-tagged entities, 19-card hero tray, large green "Battle" button

### Resonating Hall (Progression Hub — not a game mode)
- **Shown in:** v1, v2
- **Description:** Central hero management hub. 3D hall scene with chibi hero models on glowing platform. Two sub-systems: hero swap (Resonance swap) and Resonance Synergy leveling.
- **Navigation zones in 3D scene:** "Equipment" and "Artifact" labels floating
- **Bottom nav:** Mystical Stone | Battle Modes | Resonating Hall | (fourth tab)

### Dream Realm Endless Difficulty
- **Referenced in:** v3/v4 transcripts only (no footage)
- **Description:** Higher-difficulty boss variant unlocked at higher progression. Requires specific hero builds and Mythic+ charms for top scores.

---

## 7. Verification Report

| Video | ANALYSIS.md | transcript.md | frames/ | Word Count | Status | Gaps |
|---|---|---|---|---|---|---|
| v1-f2-9q0wgfOY | PASS (525 lines, complete) | PASS (1,297 words) | PASS (168 files) | 1,297 | **PASS** | None — full analysis with VFX catalog, UI catalog, hero roster, art direction, verbatim text |
| v2-0mb9XIFjFG4 | PASS (395 lines, complete) | PASS (516 words) | PASS (99 files) | 516 | **PASS** | No combat footage by design; analysis complete for its scope |
| v3-48SNAAhcKLk | **FAIL** (file missing — not present in folder despite MANIFEST.md referencing it) | PASS (3,740 words) | PASS (498 files) | 3,740 | **FAIL — ANALYSIS.MD MISSING** | ANALYSIS.md was never written or was deleted; transcript is complete and rich; frames exist but were never analyzed |
| v4-x4YngIZN1-8 | **FAIL** (10 lines — metadata stub only, no analysis sections) | PASS (2,326 words) | PASS (307 files) | 2,326 | **FAIL — ANALYSIS.MD STUB** | ANALYSIS.md contains only the metadata header block; all analysis sections (Moment-by-Moment, VFX, UI Catalog, Hero Roster, Game Modes, Verbatim Text) are absent |

### Summary of Gaps

1. **v3 ANALYSIS.md missing entirely.** The MANIFEST.md claims it exists, but the file is absent from the folder. All 498 frames and the full 3,740-word transcript are available for a complete re-analysis. Primary content would be: Hero Detail pages (16 heroes), Magic Charms crafting UI, Resonance Hall roster view, skill detail pages.

2. **v4 ANALYSIS.md is a metadata stub.** Only the 10-line header was written. The full 307 frames and 2,326-word transcript are available. Primary content would be: charm priority overlay UI, hero charm detail screens, Season 4 dream realm boss teams.

3. **No combat footage in v2, v3, v4.** All combat VFX, camera shake data, and battle UI observations derive solely from v1. Any future combat-focused synthesis would require new combat-focused video sources.

4. **v3 and v4 cover overlapping hero pools** (same charm priority topic, different seasonal context). Key divergence: v3 is the current global server; v4 uses VN server (one week ahead) as reference.
