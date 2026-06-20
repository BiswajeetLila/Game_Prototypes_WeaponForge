# Reference-Games Research — Phase 1 Source Manifest

Game research: **Honkai: Star Rail (HSR)** + **Honkai Impact 3rd (HI3)**.
Phase 1 = word-for-word extraction of web sources into local knowledge base. No sampling, no consolidation.

Layout:
- `honkai-star-rail/web-sources/<NN-slug>/`
- `honkai-impact-3rd/web-sources/<NN-slug>/`
- `shared/web-sources/<NN-slug>/` (cross-game market data + device/performance)

Each source folder contains:
- `_meta.md` — URL, fetch timestamp, HTTP status, method, notes
- `raw.html` (or `raw.json`) — unmodified fetched payload
- `content.md` — word-for-word readable text extraction (NO summarizing)
- `images/` + `images.md` — downloaded images + manifest (src URL, alt, local file)

Access recipes:
- Reddit → `https://old.reddit.com/<path>/` via curl, browser User-Agent
- Fandom / keqingmains / news / blogs → raw HTML via curl, browser User-Agent
- HoYoLAB → gstack browser (`/browse`, JS-rendered SPA)
- Sensor Tower dashboards → Sensor Tower MCP (structured data)

## HSR — honkai-star-rail/web-sources/
| NN | slug | URL | type | method |
|----|------|-----|------|--------|
| 01 | reddit-moc-12-cycle-cost | reddit.com/r/HonkaiStarRail/comments/1oapbdu | reddit | old.reddit |
| 02 | fandom-additional-dmg | honkai-star-rail.fandom.com/wiki/Additional_DMG | wiki | html |
| 03 | keqing-feixiao-quickguide | hsr.keqingmains.com/q/feixiao-quickguide/ | guide | html |
| 04 | keqing-fu-xuan | hsr.keqingmains.com/fu-xuan/ | guide | html |
| 05 | reddit-phone-settings | reddit.com/r/HonkaiStarRail/comments/17x92x0 | reddit | old.reddit |
| 06 | coopboardgames-hsr | coopboardgames.com/online-gaming/honkai-star-rail/ | article | html |
| 07 | gwo-100m-downloads | gameworldobserver.com/2024/02/06/...100-million | article | html |
| 08 | reddit-boot-fix | reddit.com/r/HonkaiStarRail/comments/16mt59c | reddit | old.reddit |
| 09 | keqing-beginner-guide | hsr.keqingmains.com/misc/beginner-guide/ | guide | html |
| 10 | reddit-fps-drops | reddit.com/r/HonkaiStarRail/comments/1r98uw7 | reddit | old.reddit |
| 11 | reddit-cant-change-fps | reddit.com/r/HonkaiStarRail/comments/1me068o | reddit | old.reddit |
| 12 | reddit-prydwen-tierlist-34 | reddit.com/r/HonkaiStarRail/comments/1lpntf7 | reddit | old.reddit |
| 13 | reddit-nvidia-drivers | reddit.com/r/HonkaiStarRail/comments/1tskg1v | reddit | old.reddit |
| 14 | keqing-ruan-mei | hsr.keqingmains.com/ruan-mei/ | guide | html |
| 15 | keqing-silver-wolf | hsr.keqingmains.com/silver-wolf/ | guide | html |
| 16 | keqing-the-herta | hsr.keqingmains.com/the-herta/ | guide | html |
| 17 | keqing-topaz-numby | hsr.keqingmains.com/topaz-and-numby/ | guide | html |
| 18 | fandom-true-dmg | honkai-star-rail.fandom.com/wiki/True_DMG | wiki | html |
| 19 | keqing-yanqing | hsr.keqingmains.com/yanqing/ | guide | html |
| 20 | gwo-2m-preregistrations | gameworldobserver.com/2023/02/14/...2-million | article | html |
| 21 | sensortower-fsn-collab-news | app.sensortower.com/news-feed/honkai-star-rail...fatestay-night-collab | article | html |

## HI3 — honkai-impact-3rd/web-sources/
| NN | slug | URL | type | method |
|----|------|-----|------|--------|
| 01 | reddit-memorial-arena-bosses | reddit.com/r/houkai3rd/comments/9elm3p | reddit | old.reddit |
| 02 | fandom-damage-calculation | honkaiimpact3.fandom.com/wiki/Damage_Calculation | wiki | html |
| 03 | reddit-endgame-dodge | reddit.com/r/houkai3rd/comments/1rlrdn6 | reddit | old.reddit |
| 04 | reddit-f2p-stigma-sets | reddit.com/r/houkai3rd/comments/9y6xfr | reddit | old.reddit |
| 05 | reddit-how-big-android | reddit.com/r/houkai3rd/comments/1l2q7kp | reddit | old.reddit |
| 06 | reddit-redownload-ios-storage | reddit.com/r/houkai3rd/comments/nmegvm | reddit | old.reddit |
| 07 | reddit-kallen-sss-boss | reddit.com/r/houkai3rd/comments/wjskpq | reddit | old.reddit |
| 08 | fandom-stats | honkaiimpact3.fandom.com/wiki/Stats | wiki | html |
| 09 | reddit-usual-setup-abyss | reddit.com/r/houkai3rd/comments/dfexok | reddit | old.reddit |
| 10 | reddit-mobile-storage | reddit.com/r/houkai3rd/comments/1qnk5sk | reddit | old.reddit |
| 11 | reddit-game-size-pc | reddit.com/r/houkai3rd/comments/1lh886d | reddit | old.reddit |
| 12 | reddit-storage-download | reddit.com/r/houkai3rd/comments/10fo4tg | reddit | old.reddit |

## SHARED — shared/web-sources/
| NN | slug | URL | type | method |
|----|------|-----|------|--------|
| 01 | devtodev-market-jun-2023 | devtodev.com/resources/articles/game-market-overview...june-2023 | article | html |
| 02 | bittopup-genshin-optimizer-atk | bittopup.com/article/Genshin-Optimizer-MultiTarget-Setup-Guide-Why-ATK-is-Dead | article | html |
| 03 | sensortower-top10-jul-2025 | sensortower.com/blog/top-10-worldwide-mobile-games...july-2025 | blog | html |
| 04 | reddit-poco-mtk-8400u | reddit.com/r/PocoPhones/comments/1kmfyj0 | reddit | old.reddit |
| 05 | reddit-neverness-performance | reddit.com/r/NevernessToEverness/comments/1t1g6na | reddit | old.reddit |
| 06 | nubiamart-redmagic-astra | nubiamart.com/blog/redmagic-gaming-tablet-3-pro...review | article | html |
| 07 | hoyolab-article-1564676 | hoyolab.com/article/1564676 | hoyolab | browser |
| 08 | hoyolab-article-278634 | hoyolab.com/article/278634 | hoyolab | browser |
| ST | sensortower-dashboards | app.sensortower.com/overview/{1599719154, 63e5633f..., com.HoYoverse.hkrpgoversea} | dashboard | MCP |

Total: 21 HSR + 12 HI3 + 8 shared web pages + 3 Sensor Tower dashboards (MCP).

---

## AFK Journey — afk-journey/web-sources/

Game research: **AFK Journey** (Farlight Games / Lilith Games, released 2024-03-27).
Phase 1 completed: 2026-06-11.

Access recipes:
- Reddit (old.reddit) → curl + Firefox User-Agent on old.reddit.com
- Reddit (PullPush archive) → api.pullpush.io for older/blocked posts
- Reddit (Redlib proxy) → redlib.perennialte.ch for posts blocked by both methods above
- Fandom wikis → Fandom MediaWiki API (action=parse) — direct wiki URLs return HTTP 403 Cloudflare
- Guides / blogs / storefronts → WebFetch
- Sensor Tower → Sensor Tower MCP (structured data)

| NN | slug | URL | type | method |
|----|------|-----|------|--------|
| 01 | wikipedia-afk-journey | en.wikipedia.org/wiki/AFK_Journey | wiki | WebFetch |
| 02 | appstore-us-listing | apps.apple.com/us/app/afk-journey/id1628970855 | storefront | iTunes API + WebFetch |
| 03 | steam-community-reviews | store.steampowered.com/app/4195600/AFK_Journey (community reviews) | storefront | WebFetch |
| 04 | farlight-major-updates | afkjourney.farlightgames.com/en/news (patch notes) | official | WebFetch (JS-blocked) |
| 05 | afkguide-beginners | afk.guide/beginners-guide | guide | WebFetch |
| 06 | bluestacks-beginners | bluestacks.com/blog/game-guides/afk-journey-beginners-guide | guide | WebFetch |
| 07 | ldshop-mythic-charm-priority | ldshop.gg/afk-journey-mythic-charm-priority | guide | WebFetch (403 blocked) |
| 08 | aywren-season2-waves | aywren.com/2024/12/06/afk-journey-season-2-waves-of-intrigue | blog | WebFetch |
| 09 | lootbar-battle-drills | lootbar.gg/blog/en/afk-journey-battle-drills-guide | guide | WebFetch |
| 10 | lootbar-ascension-guide | lootbar.gg/blog/en/afk-journey-ascension-guide | guide | WebFetch |
| 11 | fandom-wiki-main | afk-journey.fandom.com/wiki/AFK_Journey_Wiki | wiki | Fandom API |
| 12 | fandom-arena | afk-journey.fandom.com/wiki/Arena | wiki | Fandom API |
| 13 | fandom-ascension | afk-journey.fandom.com/wiki/Ascension | wiki | Fandom API |
| 14 | fandom-battle-drills | afk-journey.fandom.com/wiki/Battle_Drills | wiki | Fandom API |
| 15 | fandom-exclusive-equipment | afk-journey.fandom.com/wiki/Exclusive_Equipment | wiki | Fandom API |
| 16 | fandom-faction | afk-journey.fandom.com/wiki/Faction | wiki | Fandom API |
| 17 | fandom-hero | afk-journey.fandom.com/wiki/Hero | wiki | Fandom API |
| 18 | fandom-honor-duel | afk-journey.fandom.com/wiki/Honor_Duel | wiki | Fandom API |
| 19 | fandom-honor-duel-artifacts | afk-journey.fandom.com/wiki/Honor_Duel/Artifacts | wiki | Fandom API (DPL-limited) |
| 20 | fandom-honor-duel-equipment | afk-journey.fandom.com/wiki/Honor_Duel/Equipment | wiki | Fandom API |
| 21 | fandom-resonance-level | afk-journey.fandom.com/wiki/Resonance_Level | wiki | Fandom API (stub) |
| 22 | fandom-resonating-hall | afk-journey.fandom.com/wiki/Resonating_Hall | wiki | Fandom API |
| 23 | fandom-season | afk-journey.fandom.com/wiki/Season | wiki | Fandom API |
| 24 | fandom-soul-pact | afk-journey.fandom.com/wiki/Soul_Pact | wiki | Fandom API |
| 25 | fandom-supreme-arena | afk-journey.fandom.com/wiki/Supreme_Arena | wiki | Fandom API |
| 26 | fandom-tower-of-memory-exploration | afk-journey.fandom.com/wiki/Tower_of_Memory/Exploration | wiki | Fandom API |
| 27 | fandom-training-manual | afk-journey.fandom.com/wiki/Training_Manual | wiki | Fandom API (stub) |
| 28 | reddit-waves-intrigue-trailer | reddit.com/r/AFKJourney/comments/1f2zxxx (Waves of Intrigue trailer) | reddit | old.reddit |
| 29 | reddit-convert-twilight-temporal | reddit.com/r/AFKJourney/comments/... (Convert Twilight to Temporal) | reddit | old.reddit |
| 30 | reddit-pull-rates-scam | reddit.com/r/AFKJourney/comments/... (pull rates scam) | reddit | old.reddit |
| 31 | reddit-dev-update-powercreep | reddit.com/r/AFKJourney/comments/... (dev update power creep Q&A) | reddit | old.reddit |
| 32 | reddit-atiers-epic-wishlist | reddit.com/r/AFKJourney/comments/... (A-tiers epic wishlist) | reddit | old.reddit |
| 33 | reddit-phantimals-soul-pact | reddit.com/r/AFKJourney/comments/... (Phantimals introduction) | reddit | old.reddit |
| 34 | reddit-waves-intrigue-ended | reddit.com/r/AFKJourney/comments/... (Waves of Intrigue ended) | reddit | PullPush |
| 35 | reddit-help-paragons | reddit.com/r/AFKJourney/comments/1sce3iv (help paragons) | reddit | FAILED (all methods) |
| 36 | reddit-honor-duel-guide | reddit.com/r/AFKJourney/comments/... (Honor Duel guide) | reddit | PullPush |
| 37 | reddit-honor-duel-relic-tier | reddit.com/r/AFKJourney/comments/... (Honor Duel relic tier) | reddit | PullPush |
| 38 | reddit-pity-how-works | reddit.com/r/AFKJourney/comments/... (pity how works) | reddit | PullPush |
| 39 | reddit-math-rateup-banner-value | reddit.com/r/AFKJourney/comments/... (math rate-up banner) | reddit | PullPush |
| 40 | reddit-prydwen-parisa-b-to-s | reddit.com/r/AFKJourney/comments/... (Parisa B to S tier) | reddit | old.reddit + PullPush |
| 41 | reddit-always-hit-pities | reddit.com/r/AFKJourney/comments/... (always hit pities) | reddit | old.reddit + PullPush |
| 42 | reddit-mythic-charms-pvp-afk-dream | reddit.com/r/AFKJourney/comments/... (mythic charms PVP) | reddit | old.reddit + PullPush |
| 43 | reddit-my-worry-season-updates | reddit.com/r/AFKJourney/comments/... (worry season updates) | reddit | old.reddit + PullPush |
| 44 | reddit-explain-seasons-peaks-of-time | reddit.com/r/AFKJourney/comments/... (explain seasons) | reddit | old.reddit + PullPush |
| 45 | reddit-incredible-drop-rate | reddit.com/r/AFKJourney/comments/... (incredible drop rate) | reddit | old.reddit + PullPush |
| 46 | reddit-supreme-arena-rank-system | reddit.com/r/AFKJourney/comments/... (supreme arena rank) | reddit | old.reddit + PullPush |
| 47 | reddit-temporal-essence | reddit.com/r/AFKJourney/comments/... (temporal essence) | reddit | Redlib proxy |
| 48 | reddit-temporal-vs-twilight-essence | reddit.com/r/AFKJourney/comments/... (temporal vs twilight) | reddit | Redlib proxy |
| 49 | reddit-waves-struggling | reddit.com/r/AFKJourney/comments/... (waves struggling) | reddit | Redlib proxy |
| 50 | reddit-what-happened-game | reddit.com/r/AFKJourney/comments/... (what happened game) | reddit | Redlib proxy |
| 51 | reddit-miasma-dispel | reddit.com/r/AFKJourney/comments/... (miasma dispel) | reddit | Redlib proxy |
| 52 | reddit-gacha-rates-not-accurate | reddit.com/r/AFKJourney/comments/... (gacha rates not accurate) | reddit | Redlib proxy |
| 53 | reddit-megathread-puzzle-solutions | reddit.com/r/AFKJourney/comments/... (puzzle solutions megathread) | reddit | Redlib proxy |
| 54 | sensortower-afk-journey-metrics | app.sensortower.com/overview/{1628970855, com.farlightgames.igame.gp} | dashboard | MCP |
| 55 | internal-architectural-systemics | (local) docs/research/ — 'Architectural Systemics' doc | internal | filesystem search (NOT_FOUND) |

Total AFK Journey: 10 non-wiki/non-reddit sources + 15 Fandom wikis + 26 Reddit threads + 1 Sensor Tower dashboard (MCP) + 1 internal locate = **55 sources**.
