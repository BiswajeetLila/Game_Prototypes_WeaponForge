# Phase 1 — Web Source Extraction: STATUS (COMPLETE & VERIFIED)

Date: 2026-06-06. Games: Honkai: Star Rail (HSR) + Honkai Impact 3rd (HI3).
Method (per user decision): hybrid raw-HTTP + browser; Sensor Tower via MCP; split-by-game + shared layout; word-for-word, no sampling/consolidation.

## What was extracted (42 sources)
| Group | Count | Folder |
|---|---|---|
| HSR Reddit threads | 7 | honkai-star-rail/web-sources/ (01,05,08,10,11,12,13) |
| HSR keqingmains guides | 8 | (03,04,09,14,15,16,17,19) |
| HSR Fandom wikis | 2 | (02 Additional_DMG, 18 True_DMG) |
| HSR articles/news | 3 | (06 coopboardgames, 07 GWO-100M, 20 GWO-2M-prereg) |
| HSR Sensor Tower metrics (MCP) | 1 | (22-sensortower-hsr-metrics) |
| HI3 Reddit threads | 10 | honkai-impact-3rd/web-sources/ (01,03,04,05,06,07,09,10,11,12) |
| HI3 Fandom wikis | 2 | (02 Damage_Calculation, 08 Stats) |
| Shared market/cross-game articles | 4 | shared/web-sources/ (01 devtodev, 02 bittopup, 03 sensortower-top10, 06 nubiamart) |
| Shared device Reddit | 2 | (04 poco-mtk-8400u, 05 neverness-performance) |
| Shared HoYoLAB articles | 2 | (07 hoyolab-1564676, 08 hoyolab-278634) |

Each folder: `_meta.md`, `raw.html`/`raw.json`, `content.md` (verbatim), `images/` + `images.md`. ST folder also has aggregated + raw JSON.

## Verification (2nd agent pass) — 42/42 PASS, 0 FAIL
- Reddit: unique `thing_t1_` comment ids in raw.html == _meta count == comment blocks in content.md, EXACTLY, on all 19 threads (no sampling). Post titles match raw `<title>`; selftext is real post body (the sidebar-as-body bug is absent).
- Wikis/guides: distinctive table cells + all `displaystyle` formulas survive verbatim into content.md; no truncation/summary markers anywhere.
- Images: every folder's images/ count == images.md rows; sampled files >2KB with valid PNG/JPEG/WebP/GIF magic bytes. Live re-fetch of Fandom True_DMG matched the archive byte-for-byte (~351,6xx B).
- Sensor Tower (22): 9 spot-checked figures match the JSON exactly.

## Known gaps / honest failures (NOT hallucinated around)
1. **HSR #21 sensortower-fsn-collab-news — FAILED-GATED.** Login-walled React app; only page title + meta-description captured. Underlying event (Fate/stay night collab → biggest revenue spike since April) is corroborated by ST data: 2025-07 WW revenue $68.25M (up from 2025-06 $15.81M) and MAU peak 11.08M. Article prose itself uncaptured.
2. **HoYoLAB sources are low-value / off-topic:** #07 (id 1564676) = HI3 damage-calc post that just points to an external Google Doc (math not on HoYoLAB); #08 (id 278634) = **Genshin Impact** MediaTek graphics-settings guide (not HSR/HI3 — archived honestly, label corrected in _meta).
3. **Sensor Tower top-10 (shared #03):** per-rank numeric tables exist ONLY inside two chart images (images/01.webp revenue, 02.webp downloads); article prose narrates highlights only. Both images downloaded + valid. Same for devtodev (#01): data lives in 99 downloaded chart images.
4. **HI3 Reddit threads** have ~0 content images (only link thumbnails) — legitimately zero, not a failure.
5. **ST caveat:** all figures are Sensor Tower *estimates*; revenue is gross consumer spend; China iOS / 3rd-party Android stores undercounted → true global totals higher.

## Headline data captured (genuine-source, for later spec use)
- HSR lifetime (Apr 2023–May 2026 window): ~66.8M downloads, ~$1.64B revenue (Sensor Tower est.).
- Launch May 2023 = all-time monthly revenue peak ~$129M. Recent MAU ~7.5M–11M.
- HSR store ratings: iOS 4.41 (237k), Android 3.77 (514k). Loot Boxes advisory (iOS).
- 100M+ downloads milestone reached < 1 year post-launch (GWO article); 2M pre-registrations pre-launch (GWO article).

## NEXT (paused — awaiting go)
Per agreed scope, stopped after Phase 1 + verification. Not started:
- Phase 2: /video-analysis on 5 YouTube URLs + /play-store-reviews (videos/, reviews/ folders).
- Phase 3: consolidated design spec (D1–D30), genuine-vs-assumed tagging.
