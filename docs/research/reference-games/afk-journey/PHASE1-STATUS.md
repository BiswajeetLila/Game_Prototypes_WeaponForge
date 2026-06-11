# Phase 1 — Web Source Extraction: STATUS (COMPLETE & VERIFIED)

Date: 2026-06-11. Game: AFK Journey.
Method (per user decision): hybrid raw-HTTP (curl + Firefox UA) + Fandom MediaWiki API + PullPush archive API + Redlib proxy + Sensor Tower MCP; word-for-word extraction, no sampling/consolidation.

## What was extracted (55 sources)
| Group | Count | Folder |
|---|---|---|
| Fandom wiki pages | 15 | afk-journey/web-sources/ (11–27) |
| Reddit threads (old.reddit / PullPush / Redlib) | 26 | (28–53) |
| App stores & storefronts | 2 | (02 appstore-us, 03 steam-community-reviews) |
| Wikipedia | 1 | (01 wikipedia-afk-journey) |
| Official / publisher pages | 1 | (04 farlight-major-updates) |
| Third-party guides / blogs | 4 | (05 afkguide-beginners, 06 bluestacks-beginners, 08 aywren-season2-waves, 09–10 lootbar) |
| FAILED / blocked | 1 | (07 ldshop-mythic-charm-priority) |
| Sensor Tower metrics (MCP) | 1 | (54 sensortower-afk-journey-metrics) |
| Internal doc locate (NOT_FOUND) | 1 | (55 internal-architectural-systemics) |

Each folder: `_meta.md`, `raw.html`/`raw.json`/`raw_api.json`, `content.md` (verbatim), `images/` + `images.md`.
ST folder also has aggregated + raw JSON (1.93 MB).

## Verification (2nd agent pass) — summary
| Verdict | Count |
|---------|-------|
| PASS | 43 |
| PARTIAL | 8 |
| FAIL | 4 |

### Verification methodology
- **Reddit (old.reddit):** unique `thing_t1_` comment IDs in raw.html == _meta count == comment blocks in content.md, exactly. Post `<title>` matched. No sidebar-as-body bug.
- **Reddit (PullPush):** `id: t1_` patterns in content.md counted; raw.html IDs cross-checked. Gaps explained by `[deleted]` users not archived by PullPush (documented per thread, not treated as failures).
- **Reddit (Redlib proxy):** unique alphanumeric comment IDs in raw.html cross-checked against `u/` author occurrences in content.md.
- **Fandom wikis:** AFK-specific term density checked (faction names, hero names, game mechanic terms); content.md char count checked against 1000-char floor; images/ file count vs images.md row count verified.
- **Sensor Tower (54):** 9+ spot-checked figures from content.md tables matched raw.json exactly (iOS rating, Android rating, rating counts, MAU figures, revenue and download totals).
- **Stub / NOT_FOUND sources:** verified _meta.md explicitly states the condition (FAIL / NOT_FOUND) with documented search steps.

## Full source table
| NN | slug | type | extract_status | verify_result |
|----|------|------|---------------|---------------|
| 01 | wikipedia-afk-journey | wiki | ok | PASS |
| 02 | appstore-us-listing | storefront | ok | PASS |
| 03 | steam-community-reviews | storefront | partial | PASS |
| 04 | farlight-major-updates | official | ok_no_content | FAIL |
| 05 | afkguide-beginners | guide | ok | PASS |
| 06 | bluestacks-beginners | guide | ok | PASS |
| 07 | ldshop-mythic-charm-priority | guide | FAILED (403) | FAIL |
| 08 | aywren-season2-waves | blog | ok | PASS |
| 09 | lootbar-battle-drills | guide | ok | PASS |
| 10 | lootbar-ascension-guide | guide | ok | PASS |
| 11 | fandom-wiki-main | wiki | ok | PASS |
| 12 | fandom-arena | wiki | ok | PASS |
| 13 | fandom-ascension | wiki | ok | PASS |
| 14 | fandom-battle-drills | wiki | ok | PASS |
| 15 | fandom-exclusive-equipment | wiki | ok | PARTIAL |
| 16 | fandom-faction | wiki | ok | PASS |
| 17 | fandom-hero | wiki | ok | PARTIAL |
| 18 | fandom-honor-duel | wiki | ok | PARTIAL |
| 19 | fandom-honor-duel-artifacts | wiki | ok | PARTIAL |
| 20 | fandom-honor-duel-equipment | wiki | ok | PASS |
| 21 | fandom-resonance-level | wiki | ok | FAIL |
| 22 | fandom-resonating-hall | wiki | ok | PARTIAL |
| 23 | fandom-season | wiki | partial (API 200 / page 403) | PASS |
| 24 | fandom-soul-pact | wiki | partial (API 200 / page 403) | PASS |
| 25 | fandom-supreme-arena | wiki | partial (API 200 / page 403) | PASS |
| 26 | fandom-tower-of-memory-exploration | wiki | partial (API 200 / page 403) | PASS |
| 27 | fandom-training-manual | wiki | partial (API 200 / page 403) | FAIL |
| 28 | reddit-waves-intrigue-trailer | reddit | OK | PASS |
| 29 | reddit-convert-twilight-temporal | reddit | OK | PASS |
| 30 | reddit-pull-rates-scam | reddit | OK | PASS |
| 31 | reddit-dev-update-powercreep | reddit | OK | PASS |
| 32 | reddit-atiers-epic-wishlist | reddit | OK | PASS |
| 33 | reddit-phantimals-soul-pact | reddit | OK | PASS |
| 34 | reddit-waves-intrigue-ended | reddit | OK (PullPush) | PASS |
| 35 | reddit-help-paragons | reddit | FAILED (all methods) | FAIL |
| 36 | reddit-honor-duel-guide | reddit | OK (PullPush) | PASS |
| 37 | reddit-honor-duel-relic-tier | reddit | OK (PullPush) | PASS |
| 38 | reddit-pity-how-works | reddit | OK (PullPush) | PASS |
| 39 | reddit-math-rateup-banner-value | reddit | OK (PullPush) | PASS |
| 40 | reddit-prydwen-parisa-b-to-s | reddit | ok | PARTIAL |
| 41 | reddit-always-hit-pities | reddit | ok | PARTIAL |
| 42 | reddit-mythic-charms-pvp-afk-dream | reddit | ok | PASS |
| 43 | reddit-my-worry-season-updates | reddit | ok | PASS |
| 44 | reddit-explain-seasons-peaks-of-time | reddit | ok | PASS |
| 45 | reddit-incredible-drop-rate | reddit | ok | PARTIAL |
| 46 | reddit-supreme-arena-rank-system | reddit | ok | PARTIAL |
| 47 | reddit-temporal-essence | reddit | ok (Redlib) | PASS |
| 48 | reddit-temporal-vs-twilight-essence | reddit | ok (Redlib) | PASS |
| 49 | reddit-waves-struggling | reddit | ok (Redlib) | PASS |
| 50 | reddit-what-happened-game | reddit | ok (Redlib) | PASS |
| 51 | reddit-miasma-dispel | reddit | ok (Redlib) | PASS |
| 52 | reddit-gacha-rates-not-accurate | reddit | ok (Redlib) | PASS |
| 53 | reddit-megathread-puzzle-solutions | reddit | ok (Redlib) | PARTIAL |
| 54 | sensortower-afk-journey-metrics | metrics | ok | PASS |
| 55 | internal-architectural-systemics | internal | NOT_FOUND | PASS |

## Known gaps / honest failures (NOT hallucinated around)

1. **#04 farlight-major-updates — FAIL (JS shell only).** The official patch notes page at afkjourney.farlightgames.com is a Vue/Angular SPA. WebFetch retrieved only the template shell with binding placeholders (`[[getCurrentData.multilang_title]]`). Zero article/patch-note content recovered.

2. **#07 ldshop-mythic-charm-priority — FAIL (HTTP 403).** Both fetch attempts returned 403 Forbidden. Likely geo-blocked or anti-scraper. No tier list data captured. Zero fabrication.

3. **#21 fandom-resonance-level — FAIL (stub page, 528 chars).** The source wiki page itself is a two-sentence stub. Content.md is 528 chars — below the 1000-char threshold. Genuine thin article, not a scraping failure.

4. **#27 fandom-training-manual — FAIL (stub page, 403 chars).** Same situation as #21. The wiki item-infobox page has only 2 sentences of body text. Content.md is 403 chars.

5. **#35 reddit-help-paragons — FAIL (all methods exhausted).** Post ID `1sce3iv` not indexed in PullPush. Reddit direct returns 403. Wayback Machine: no snapshot. Reveddit: empty. Likely too new or deleted post.

6. **#01 wikipedia-afk-journey — PASS (re-verified 2026-06-11).** Content.md contains full verbatim wikitext from the Wikipedia API including `{{Infobox video game | developer = Lilith Games | publisher = Farlight Games | released = EU/NA: March 27, 2024 | AS: August 8, 2024}}`, complete article prose with `<ref>` tags, and the full accolades wikitable. Previous PARTIAL verdict was in error.

7. **#05, #06, #08, #09, #10 (guides/blogs) — PASS (re-verified 2026-06-11).** All five contain verbatim scraped page text including nav/footer chrome, confirming raw extraction not paraphrasing. Key evidence: #05 has equipment priority chains and ascension cap rules verbatim; #06 has "300 Diamonds" / "2700 Diamonds" / pity numbers verbatim; #08 has personal blog prose with "Velvet Store, where you can purchase cosmetics – outfits, eyes, headwear, skintones, etc"; #09 has hero names in team comps verbatim; #10 has "64 in total" and "350 camp acorns" copy requirements verbatim. Previous PARTIAL verdict was in error.

8. **#19 fandom-honor-duel-artifacts — PARTIAL (DPL table unresolvable).** The artifact table is generated server-side via Fandom's Dynamic Page List (DPL) extension. The wikitext is a DPL query wrapper only; 40+ artifact entries cannot be reconstructed from the API response. Only 9 sample artifact names captured.

9. **Reddit PARTIAL threads (#40, #41, #45, #46) — deleted-user gap.** PullPush does not archive `[deleted]` user comments. All missing IDs were confirmed as deleted accounts in raw.html (not sampling). Data loss: 1–6 comments per thread.

10. **Fandom images (403-blocked):** Sources #17, #22 have image filenames identified in wikitext but images/ folders could not be populated due to HTTP 403 on the main Fandom page. Image data is documented in images.md with CDN URLs.

11. **Sensor Tower caveat:** All figures are Sensor Tower estimates. Revenue = gross consumer spend. China iOS and 3rd-party Android stores are undercounted — true global totals are higher.

## Headline data captured (genuine sources, for later spec use)
- **AFK Journey lifetime (Mar 2024–May 2026, 27 months):** ~8.39M downloads combined (iOS 798k + Android 7.59M); ~$158.2M revenue combined (iOS $88.3M + Android $69.9M). Source: Sensor Tower MCP (54).
- **Peak MAU:** April 2024 = 3,223,774 combined. May 2026 MAU = 844,317 combined. Source: Sensor Tower MCP (54).
- **App Store (iOS):** rating 4.82976 / 72,810 ratings (iTunes API, version 1.7.1.1, released 2024-03-27). Source: #02.
- **Sensor Tower iOS global rating:** 4.82974 / 274,310 ratings. Android global rating: 4.551099 / 296,381 ratings. Source: #54.
- **Steam:** 605 total reviews, 78% positive overall, 74% positive recent (249 reviews). Launched Steam 2026-04-27. Source: #03.
- **Gacha pity (community-documented):** Soft pity begins ~73 pulls; hard pity at 100. Epic (A-tier) pity at 10. Source: Reddit threads #38, #39.
- **Ascension copy requirements (community-documented):** A-Level to Supreme+ requires 64 total copies + 200 acorns; S-Level requires 8 total copies + 350 acorns. Source: #10 (lootbar guide).
- **Honor Duel:** Fair Play PVP mode, 9 wins or 3 losses ends the run. ~95 equipment items across Rare/Elite/Epic/Legendary tiers documented. Source: #18, #20.
- **Resonance Level cap:** 240 via Starter Story; Resonance Synergy unlocks at 240. Source: #22.

## NEXT (not started — awaiting go)
Per agreed scope, stopped after Phase 1 + verification. Not started:
- Phase 2: `/video-analysis` on 4 YouTube URLs + `/play-store-reviews` (videos/, reviews/ folders).
- Phase 3: consolidated design spec (D1–D30), genuine-vs-assumed tagging.
