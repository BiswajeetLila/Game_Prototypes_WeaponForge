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
