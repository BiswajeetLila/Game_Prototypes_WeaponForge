# AFK Journey — Locked Deck Spine (Gate B)

Date: 2026-06-11. Drives `afk-journey-deck.html` build.
Spine count: **21 slides** (within template 10-25 range). Justified by AFK Journey's research depth: 55 web sources + 4 deep video analyses + 3,161 reviews + 9,311-word design doc.

Game-specific terminology preserved everywhere — "Resonating Hall", "Hands of Resonance", "Mythic Charms", "Soul Pact / Phantimals", "Miasma", "Velvet Store", "Honor Duel", "Battle Drills", "Tower of Memory", "Peaks of Time", "Dream Realm", "Twilight / Temporal Essence", "Ascension", "Paragon".

## Spine

| # | Title (AFK terms) | One-line | Layout pattern | Image |
|---|---|---|---|---|
| 01 | Cover — AFK Journey at a Glance | Title + 6 headline stats from listing + Sensor Tower | custom cover-wrap (1.4fr image + 1fr stats-grid 2×3) | ICON + COVER_HERO |
| 02 | What Is AFK Journey? | Publisher/dev/release/platform facts + positioning | stats-grid 3×2 + image left | ICON enlarged |
| 03 | Player Fantasy — Collector · Strategist · Storyteller | 3 pillars in colored cards | takeaways-grid 3-col | — |
| 04 | The Core Loop — 5-Phase AFK Cycle | Idle collect → Pull → Resonate → Push Mode → Ascend | loop-wrap (5-node SVG pentagon + notes column) | — |
| 05 | Battle Anatomy — Dream Realm Boss UI | 6 annotated callouts on real frame | anatomy-wrap (image left + 6-row grid callouts) | BATTLE |
| 06 | The Resonating Hall — Marquee Innovation | Equipment-by-class + Hands of Resonance + Synergy unlock | image-side + 4 mechanic cards (2×2 bento) | RESONHALL |
| 07 | 6 Classes × 6 Factions Matrix | Cross-product grid showing taxonomy | grid-matrix 6×6 (or 6×7 incl Celestial/Hypogean) | — |
| 08 | Hero Roster + Mythic Charm Priorities | 8-row tier table (Gerda/Shemira/etc) | iap-table sticky-header | — |
| 09 | Ascension Ladder — Elite → Paragon | 7-tier vertical color-coded ladder | tier-ladder vertical | — |
| 10 | Currency Stack — 6 Tracks | Diamonds / Gold / Temporal / Twilight / Hero Essence / Acorns | bento-grid auto-fit (6 cards: IN/OUT each) | — |
| 11 | Game Modes Map — 8 Pillars | All 8 documented modes in a system tree | bento-grid (8 cards) + linker SVG | — |
| 12 | Honor Duel Deep Dive — Roguelite PvP | 9W/3L run structure + relic/artifact tiers | timeline (run path) + side tier-ladder | — |
| 13 | Season System — Song of Strife → Waves of Intrigue → Charm Meta | Season 1/2/4 + Soul Pact + Miasma + Velvet | cohort-timeline (3 bands) + side cards | LEVELUP |
| 14 | D1-D7 Onboarding Deep Dive | First-week journey per day with verbatim friction quotes | deep-dive-grid (3 day-cards D1/D2/D3 + D4-D7 band) | — |
| 15 | D8-D30 Mid-Game | Faction discovery → first paywall → Resonance 240 push | 3-col cohort cards | — |
| 16 | Engagement Hooks — 5 Retention Layers | Idle/daily/weekly/season/endgame stacked | layer-stack | — |
| 17 | Monetization Stack | IAP table + "missing $3-5 lane" insight | iap-table + sidebar | — |
| 18 | Pain Points — Top Thumbed Complaints | Bar chart proportional to thumbs + quote cards | bar-chart + quote bento | — |
| 19 | Comparators — AFK Arena · Dislyte · Eversoul · Watcher of Realms | 4-col grid w/ "what AFKJ does differently" | comparator-grid 4-col | — |
| 20 | Visual Design & VFX — 15 Skill Effects | VFX color catalog + damage number system | image + bento (catalog) | VFX |
| 21 | Lila Takeaways — COPY / AVOID / WATCH | 3-col with checkmarks/crosses/eye | takeaways-grid 3-col | — |

## Layout variety audit (no 3+ consecutive same pattern)

```
01 cover-custom
02 stats+image                — different from 01 (stats grid emphasis)
03 3-col pillars              — different
04 SVG loop                   — different
05 anatomy (image+callouts)   — different
06 image + 2x2 bento          — different sub-shape from 05
07 matrix grid                — different
08 sticky table               — different
09 vertical tier-ladder       — different
10 bento auto-fit             — different
11 bento + svg                — close to 10 but adds SVG layer
12 timeline + side ladder     — different
13 cohort-timeline + cards    — different sub-shape from 12
14 deep-dive 3-col + band     — different
15 3-col cohort cards         — close to 14 sub-shape but no nested sections
16 layer-stack                — different
17 iap-table + sidebar        — different
18 bar-chart + quotes         — different
19 comparator 4-col grid      — different
20 image + bento              — different (image returns)
21 takeaways-grid             — different
```

No 3+ consecutive identical layouts. 

## Chip target

≥ 4 × 21 = **84 chips**. Stretch goal: ≥120 (we hit 146 in the v1 deck — same depth available).

## Image embedding plan

| Slide | Key | Why |
|---|---|---|
| 01 Cover | ICON + COVER_HERO | branding + victory party hero |
| 02 What Is | ICON enlarged | publisher visual identity |
| 05 Battle Anatomy | BATTLE | real Dream Realm boss UI (not marketing) |
| 06 Resonating Hall | RESONHALL | Hands of Resonance hero grid |
| 13 Season System | LEVELUP | Level Up cinematic ties to season meta |
| 20 Visual Design & VFX | VFX | skill cast silhouette |

Image total: 7 manifest keys; 6 placements (RESONANCE key UNUSED — Resonance Synergy modal mechanic illustrated by RESONHALL grid instead).

Actually — check: should keep RESONANCE on slide 06 since it shows the Resonance Synergy modal (max level 340 tooltip). Put RESONANCE on slide 06 main image, RESONHALL on slide 11 (Game Modes Map → Resonating Hall hub). Re-plan:

| Slide | Key |
|---|---|
| 01 | ICON + COVER_HERO |
| 02 | ICON |
| 05 | BATTLE |
| 06 | RESONANCE (the synergy modal — primary visual) + RESONHALL inset (grid) |
| 13 | LEVELUP |
| 20 | VFX |

6 placements, 7 keys used (06 uses 2).

## Source chip vocab (locked — copy verbatim into assembler)

| Source slug from design-doc tag | Chip text |
|---|---|
| 54-sensortower-afk-journey-metrics | `SensorTower` |
| 02-appstore-us-listing | `AppStore` |
| listing_metadata.json | `Reviews-lifetime` |
| reviews analysis_pack (3161 sample) | `PlayStore-3161` |
| 01-wikipedia-afk-journey | `Wikipedia` |
| 04-farlight-major-updates | `Farlight` |
| 05-afkguide-beginners | `afkguide` |
| 06-bluestacks-beginners | `Bluestacks` |
| 07-ldshop-mythic-charm-priority | `Ldshop` |
| 08-aywren-season2-waves | `Aywren` |
| 09-lootbar-battle-drills | `Lootbar-Drills` |
| 10-lootbar-ascension-guide | `Lootbar-Ascension` |
| 11-fandom-wiki-main | `Fandom-Wiki` |
| 12-fandom-arena | `Fandom-Arena` |
| 13-fandom-ascension | `Fandom-Ascension` |
| 14-fandom-battle-drills | `Fandom-Battle-Drills` |
| 15-fandom-exclusive-equipment | `Fandom-Exclusive-Eq` |
| 16-fandom-faction | `Fandom-Faction` |
| 17-fandom-hero | `Fandom-Hero` |
| 18-fandom-honor-duel | `Fandom-Honor-Duel` |
| 19-fandom-honor-duel-artifacts | `Fandom-Artifacts` |
| 20-fandom-honor-duel-equipment | `Fandom-HD-Equip` |
| 21-fandom-resonance-level | `Fandom-Resonance-Level` |
| 22-fandom-resonating-hall | `Fandom-Resonating-Hall` |
| 23-fandom-season | `Fandom-Season` |
| 24-fandom-soul-pact | `Fandom-Soul-Pact` |
| 25-fandom-supreme-arena | `Fandom-Supreme-Arena` |
| 26-fandom-tower-of-memory-exploration | `Fandom-Tower-of-Memory` |
| 27-fandom-training-manual | `Fandom-Training-Manual` |
| v1-f2-9q0wgfOY/ANALYSIS | `v1-GachaJosh` |
| v2-0mb9XIFjFG4/ANALYSIS | `v2-Carzak` |
| v3-48SNAAhcKLk/ANALYSIS | `v3-MythicCharms` |
| v4-x4YngIZN1-8/ANALYSIS | `v4-MythicS4` |
| Reddit (any individual thread) | `Reddit-<topic-shortname>` (e.g. `Reddit-Pity`, `Reddit-Miasma`, `Reddit-Parisa`, `Reddit-Powercreep`) |
| Quoted review with thumb count | `Reviews-<N>👍 <R>★` e.g. `Reviews-405👍 1★` |
| [ASSUMED] in design doc | `Assumed` (class="src inf") |
| Inferred / synthesis | `Inferred` (class="src inf") |
| Data missing | `Gap` (class="src gap") |
