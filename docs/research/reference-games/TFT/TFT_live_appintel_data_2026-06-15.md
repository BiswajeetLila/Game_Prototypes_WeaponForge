# TFT — Live App-Intel Data Pull (2026-06-15)

> **What this is:** Genuine live data fetched on 2026-06-15 from a licensed Sensor-Tower-class
> app-intelligence MCP, to enrich the design spec's player-sentiment / retention sections with
> sourced numbers instead of assumptions. This file is the raw-ish data appendix; the prose
> synthesis lives in `TFT_Design_Spec_Core-Loop_Progression_D1-D30_2026-06-15.md`.
>
> **Scope & reliability caveats (read before citing):**
> - All figures below are **US, Android only** unless stated. Global/iOS will differ.
> - Active-user and retention figures are **panel-modeled estimates**, not Riot-official telemetry.
>   The retention model carries a low provider confidence score (`confidence: 13`). Treat as
>   **directional**, not precise.
> - Ratings/review counts are scraped from the Google Play listing and are reliable as counts;
>   sentiment tags are provider-classified.
> - Tag legend used in the spec: `[LIVE]` = from this file.

---

## 1. App identity (both stores)

| Field | Android | iOS |
|---|---|---|
| App ID | `com.riotgames.league.teamfighttactics` | `1480616748` |
| Name | TFT: Teamfight Tactics | TFT: Teamfight Tactics |
| Publisher | Riot Games, Inc | Riot Games |
| Mobile release | 2020-03-16 | 2020-03-18 |
| Last updated | 2026-06-05 | 2026-06-10 |
| Global rating count | 754,876 | 493,013 |
| Category | Strategy / Game | 6014 (Games) |

> Cross-check: mobile launch March 2020 is consistent with a June **2019** PC launch (the "7-year
> anniversary" a reviewer complains about in June 2026 corroborates the 2019 origin).

---

## 2. Ratings — lifetime distribution & trend (Android, US)

**Snapshot 2026-06-14:** average **4.512**, total **754,821** ratings.

| Stars | Count | Share |
|---|---|---|
| 5★ | 616,026 | 81.6% |
| 4★ | 48,436 | 6.4% |
| 3★ | 14,280 | 1.9% |
| 2★ | 13,192 | 1.7% |
| 1★ | 62,887 | 8.3% |

**Trend (avg rating, US Android):**

| Date | Avg | Total ratings |
|---|---|---|
| 2026-01-01 | 4.540 | 729,638 |
| 2026-02-15 | 4.551 | 738,503 |
| 2026-03-01 | 4.531 | 740,383 |
| 2026-04-01 | 4.512 | 743,613 |
| 2026-05-01 | 4.511 | 750,090 |
| 2026-06-14 | 4.512 | 754,821 |

> Lifetime average **eroded ~0.04 (4.55→4.51)** across H1 2026, with the decline concentrated
> Feb→Apr — coincident with the Set 17 launch window that recent reviews complain about.

---

## 3. Recent text-review sentiment (Android, US) — NEGATIVE SKEW

The lifetime 4.5★ is propped up by ~616k historical 5★ ratings. The **recent review *flow* is
much more negative.**

**Text reviews 2026-03-01 → 2026-06-15 (n=591):**

| Stars | Count | Share |
|---|---|---|
| 1★ | 258 | 43.7% |
| 2★ | 56 | 9.5% |
| 3★ | 57 | 9.6% |
| 4★ | 33 | 5.6% |
| 5★ | 187 | 31.6% |

**1★ text reviews 2026-01-01 → 2026-06-15:** 406 total.

> Bimodal, negative-leaning. Recent writers are mostly either venting (1★) or loyal (5★);
> the middle is thin.

### Dominant complaint themes (from review bodies + provider tags)

1. **Mobile performance & bugs — #1 by volume.** Crashes/freezes (notably in *Tocker's Trials*),
   30fps lock on Android, no in-app graphics-quality setting, "can't move my heroes or pick up
   items," stuck at matching phase, dead buttons (boons, arena/skin change, **battle-pass
   purchase**), loadout inaccessible. Recurrent refrain: *"fun on PC, trash on mobile,"*
   *"should've stayed on PC."*
2. **RNG / fairness perception.** *"unfair," "why does half the players get 2-3 cost while others
   get 1," "the game is messing with probabilities," "system just decides who wins,"* bots
   reportedly winning.
3. **Current-set (Set 17) backlash.** *"avoid the current set, it's absolute garbage," "uninstalled
   because of set 17," "new characters suck."*
4. **Monetization grievance.** *"2 pulls for a 7-year anniversary," "League's little brother,"
   "cozy game being milked."*
5. **Missing social / QoL on mobile.** Requests for voice chat / party chat (esp. Double Up),
   profile-icon change, localization (e.g., Bahasa Indonesia).

### Representative verbatim quotes (genuine, dated)

- 5★ 2026-06-11 — *"good game"* | 5★ 2026-06-04 — *"A great way to play TFT portably <3"*
- 5★ 2026-06-13 — *"BRO. IS LIKE MLBB BUT MORE HARDER. i like the game"*
- 2★ 2026-06-11 — *"Overall I've enjoyed the game. The builds are interesting, and the learning
  curve feels engaging… but 80% of my games (largely Tocker's Trials) freeze partway thru…"*
- 3★ 2026-06-01 — *"The overall experience is excellent and I am addicted to the game, but… my
  shop seems to be bugged."*
- 1★ 2026-06-10 — *"I especially love it on PC where it works. but I am so tired of buttons not
  working… now I can't even give them my money for the battle pass."*
- 1★ 2026-06-09 — *"uninstalled… matches are heavily RNG-based… kept getting matched with bots,
  and even then the bots ended up winning. TFT SEA feels very unfair and poorly balanced."*
- 1★ 2026-06-12 — *"mid tier patch and a whopping 2 pulls for a 7 year anniversary… a cozy game
  being milked."*

---

## 4. Active users (MAU proxy, US Android, panel estimate)

| Month | Active users |
|---|---|
| 2026-01 | 95,476 |
| 2026-02 | 77,620 |
| 2026-03 | 64,413  ← trough |
| 2026-04 | 86,995  ← spike (new content / set cycle) |
| 2026-05 | 82,484 |
| 2026-06 | 82,517 |

> Genuine evidence of the **set-rotation re-engagement curve**: decline through a set's late life
> (Jan→Mar), sharp re-acquisition spike on new content (Apr), plateau. US-Android-only and modeled
> — a small slice of global DAU/MAU, directional only.

---

## 5. Retention curve (US Android, all-time cohort, panel model, confidence 13)

`corrected_retention` (share of installers still active on day N):

| Day | TFT | Category baseline | TFT ÷ baseline |
|---|---|---|---|
| D1 | 37.7% | 3.1% | ~12.2× |
| D2 | 30.0% | 2.1% | ~14× |
| D3 | 24.5% | 1.7% | ~14× |
| D7 | 15.9% | 1.25% | ~12.7× |
| D14 | 11.4% | 0.89% | ~12.8× |
| D30 | 7.4% | 0.65% | ~11.3× |
| D60 | ~5.0% | ~0.46% | ~11× |
| D90+ | ~4.3% (plateau) | ~0.4% | ~11× |

> Shape = **steep early drop + hardcore plateau**. ~62% churn by D1, but survivors are very sticky
> (the curve flattens near 4.3% by D90 and barely decays after). Classic competitive-ladder
> retention profile: a large casual top-of-funnel that mostly bounces, feeding a small,
> extremely durable core. TFT sits ~11–13× above the modeled category baseline at every horizon.
> **Numbers are modeled estimates with low provider confidence — cite as directional.**

---

## 6. Provenance

- Source: licensed app-intelligence MCP (Sensor-Tower-class), endpoints `search_entities`,
  `ratings`, `reviews`, `active_users`, `retention`. Pulled 2026-06-15.
- Raw review sample persisted in `TFT_play_reviews_sample_2026-06-15.csv`.
- `download_revenue_estimates` was fetched but returned a 98k-char daily/per-country dump that did
  not aggregate cleanly in-session; omitted as non-essential to a design/experience spec. Re-pull
  with monthly granularity if revenue sizing is needed.
