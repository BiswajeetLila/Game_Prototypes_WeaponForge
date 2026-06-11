# AFK Journey — Phase 1 Orchestration Plan (AWAITING APPROVAL)

Date: 2026-06-11. Game: **AFK Journey** (Farlight / Lilith).
Method: **match prior HSR/HI3 Phase 1 exactly** — hybrid raw-HTTP + browser; Sensor Tower via MCP; word-for-word, no sampling/consolidation.

## Folder layout (to create)
```
reference-games/afk-journey/
  web-sources/<NN-slug>/
    _meta.md       # URL, fetch timestamp, HTTP status, method, notes
    raw.html|raw.json   # unmodified payload
    content.md     # word-for-word readable text (NO summarizing)
    images/  + images.md   # downloaded images + manifest
  videos/    # Phase 2 — /video-analysis output
  reviews/   # Phase 2 — /play-store-reviews output
```

## Access recipes (per source type)
- **Reddit** → `https://old.reddit.com/<path>/` via curl, browser User-Agent. Verify: unique `thing_t1_` comment ids in raw.html == comment blocks in content.md (no sampling).
- **Fandom / guides / blogs / official news** → raw HTML via curl, browser UA.
- **Wikipedia** → raw HTML via curl (or REST API).
- **Apple App Store** → Sensor Tower `app_metadata` MCP + `/browse` for listing prose/screens (JS SPA).
- **Steam Community reviews** → `/browse` (JS-rendered), capture top-rated review bodies verbatim.
- **Sensor Tower dashboards** → Sensor Tower MCP (downloads, revenue, ratings, MAU).

## Source manifest — web-sources/ (53 web + 1 ST MCP)

### Official / store / encyclopedia (4)
| NN | slug | URL | type | method |
|----|------|-----|------|--------|
| 01 | wikipedia-afk-journey | en.wikipedia.org/wiki/AFK_Journey | wiki | html |
| 02 | appstore-us-listing | apps.apple.com/us/app/afk-journey/id1628970855 | store | MCP + browser |
| 03 | steam-community-reviews | steamcommunity.com/app/4195600/reviews | reviews | browser |
| 04 | farlight-major-updates | afkjourney.farlightgames.com/news/e387139d0f6fd3c88d43888dce1c0a56 | official | html/browser |

### Guides / blogs (6)
| NN | slug | URL | type | method |
|----|------|-----|------|--------|
| 05 | afkguide-beginners | afk.guide/afk-journey-beginners-guide | guide | html |
| 06 | bluestacks-beginners | bluestacks.com/blog/game-guides/afk-2-journey/afkj-beginners-guide-en.html | guide | html |
| 07 | ldshop-mythic-charm-priority | ldshop.gg/blog/afk-Journey/mythic-charm-priority-guide.html | guide | html |
| 08 | aywren-season2-waves | aywren.com/2024/12/06/afk-journey-a-look-at-season-2-waves-of-intrigue | blog | html |
| 09 | lootbar-battle-drills | lootbar.com/blog/en/master-afk-journey-battle-drills-with-top-teams-and-pro-tips.html | article | html |
| 10 | lootbar-ascension-guide | lootbar.com/blog/en/afk-journey-ascension-guide.html | article | html |

### Fandom wikis (17)
| NN | slug | URL (fandom.com/wiki/...) | method |
|----|------|------|--------|
| 11 | fandom-wiki-main | AFK_Journey_Wiki | html |
| 12 | fandom-arena | Arena | html |
| 13 | fandom-ascension | Ascension | html |
| 14 | fandom-battle-drills | Battle_Drills | html |
| 15 | fandom-exclusive-equipment | Exclusive_Equipment | html |
| 16 | fandom-faction | Faction | html |
| 17 | fandom-hero | Hero | html |
| 18 | fandom-honor-duel | Honor_Duel | html |
| 19 | fandom-honor-duel-artifacts | Honor_Duel/Artifacts | html |
| 20 | fandom-honor-duel-equipment | Honor_Duel/Equipment | html |
| 21 | fandom-resonance-level | Gameplay_Guide/Function/Resonance_Level | html |
| 22 | fandom-resonating-hall | Resonating_Hall | html |
| 23 | fandom-season | Season | html |
| 24 | fandom-soul-pact | Soul_Pact | html |
| 25 | fandom-supreme-arena | Supreme_Arena | html |
| 26 | fandom-tower-of-memory-exploration | Tower_of_Memory/Exploration | html |
| 27 | fandom-training-manual | Training_Manual | html |

### Reddit threads (26)  — all r/AFKJourney unless noted
| NN | slug | comment id | method |
|----|------|------|--------|
| 28 | reddit-waves-intrigue-trailer | 1fbv6t0 | old.reddit |
| 29 | reddit-convert-twilight-temporal | 1q980xw | old.reddit |
| 30 | reddit-pull-rates-scam | 1c1lqb7 | old.reddit |
| 31 | reddit-dev-update-powercreep | 1cf1car | old.reddit |
| 32 | reddit-atiers-epic-wishlist | 1cl9wae | old.reddit |
| 33 | reddit-phantimals-soul-pact | 1np4i1d | old.reddit |
| 34 | reddit-waves-intrigue-ended | 1fs2na7 | old.reddit |
| 35 | reddit-help-paragons | 1sce3iv | old.reddit |
| 36 | reddit-honor-duel-guide | 1cit9e5 | old.reddit |
| 37 | reddit-honor-duel-relic-tier | 1chn9o2 | old.reddit |
| 38 | reddit-pity-how-works | 1h3nwis | old.reddit |
| 39 | reddit-math-rateup-banner-value | 1cpj63s | old.reddit |
| 40 | reddit-prydwen-parisa-b-to-s | 1c32qzp | old.reddit |
| 41 | reddit-always-hit-pities | 1buoe47 | old.reddit |
| 42 | reddit-mythic-charms-pvp-afk-dream | 1t78axc | old.reddit |
| 43 | reddit-my-worry-season-updates | 1c1iyrc | old.reddit |
| 44 | reddit-explain-seasons-peaks-of-time | 1i182wk | old.reddit |
| 45 | reddit-incredible-drop-rate | 1cpjklu | old.reddit |
| 46 | reddit-supreme-arena-rank-system | 1ctz7r4 | old.reddit |
| 47 | reddit-temporal-essence | 1q1zafb | old.reddit |
| 48 | reddit-temporal-vs-twilight-essence | 1edgby2 | old.reddit |
| 49 | reddit-waves-struggling | 1fmdmuc | old.reddit |
| 50 | reddit-what-happened-game | 1d770gg | old.reddit |
| 51 | reddit-miasma-dispel | 1ckk4t1 | old.reddit |
| 52 | reddit-gacha-rates-not-accurate | 1c2l7jz | old.reddit |
| 53 | reddit-megathread-puzzle-solutions | 1cwr8mh | old.reddit |

### Sensor Tower (MCP)
| NN | slug | source | method |
|----|------|------|--------|
| 54 | sensortower-afk-journey-metrics | ST app id (iOS 1628970855 + Android com.farlight.afkjourney) | MCP |

### Internal doc (no URL) — LOCATE, don't fetch
- "Architectural Systemics, Progression Economics, and Game Design Patterns in AFK Journey" — search local notebook / My_Notes; copy into web-sources/55-internal-architectural-systemics/ if found. Flag if not found.

## Agent batching (extraction wave)
Concurrency cap ~6-8. Same-method sources grouped per agent so each agent reuses one curl recipe.

| Batch | Sources | Agent count | Tool |
|-------|---------|-------------|------|
| A — Fandom | 11–27 (17) | 3 agents (~6 each) | curl html |
| B — Reddit | 28–53 (26) | 4 agents (~6-7 each) | curl old.reddit |
| C — Guides/blogs/wiki/official | 01, 04–10 (8) | 2 agents | curl html |
| D — Browser/store | 02 App Store, 03 Steam reviews | 1 agent | /browse + MCP |
| E — Sensor Tower | 54 | 1 agent (or inline) | ST MCP |
| F — Locate internal doc | 55 | 1 quick agent | Glob/Grep local |

Each agent writes `_meta.md` + `raw.*` + `content.md` (verbatim) + `images/` per source. No summarizing.

## Verification wave (2nd agent set, after extraction)
Mirror HSR verification — 1 verifier per batch, PASS/FAIL per source:
- **Reddit:** count unique `thing_t1_` ids in raw.html, assert == _meta count == comment blocks in content.md, EXACTLY.
- **Fandom/guides:** distinctive table cells + numeric values survive verbatim; no truncation/summary markers.
- **Images:** every folder images/ count == images.md rows; spot-check magic bytes.
- **Store/Steam:** review bodies captured verbatim, count matches.
- **ST:** spot-check figures vs raw JSON.
Output: `afk-journey/PHASE1-STATUS.md` (mirrors HSR status: extracted table, verification result, honest gaps, headline data).

## Open questions before GO
1. **Steam app id** — list says `4195600`. Confirm correct AFK Journey Steam appid (some links use it; verify or I'll resolve via Steam search).
2. **Internal markdown doc** — where does the "Architectural Systemics…" notebook doc live locally? Path hint helps; else I Glob for it.
3. **Concurrency** — OK to run ~6-8 fetch agents in parallel?
```
```
