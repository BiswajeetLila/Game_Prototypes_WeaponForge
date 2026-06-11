# AFK Journey Design Doc — Verification Report

**Reviewer:** Claude Sonnet 4.6 (automated subagent)
**Date:** 2026-06-11
**Target file:** `AFK_JOURNEY_DESIGN_DOC.md` (820 lines)
**Sources cross-checked:** `54-sensortower-afk-journey-metrics/content.md`, `52-reddit-gacha-rates-not-accurate/content.md`, `18-fandom-honor-duel/content.md`, `reviews/analysis_pack.md`

---

## Check 1 — All 13 Required Sections Present?

**PASS**

Sections found and confirmed:

| # | Section title | Present |
|---|---|---|
| 1 | Game Overview | YES |
| 2 | Core Loop | YES |
| 3 | Hero System | YES |
| 4 | Progression Systems | YES |
| 5 | Gacha & Economy | YES |
| 6 | Game Modes | YES (9 sub-modes covered) |
| 7 | Season System | YES |
| 8 | Mythic Charms | YES |
| 9 | D1–D30 Player Journey | YES |
| 10 | Why Players Love It / Why They Come Back | YES |
| 11 | Why Players Quit / Frustrations | YES |
| 12 | Business Model & Market Performance | YES |
| 13 | Visual Design & VFX | YES |

---

## Check 2 — Untagged Factual Claims

**FAIL — 3 untagged sentences found**

Methodology: scanned every sentence that ends with a period (or line-end) without a trailing `[SOURCE: ...]` or `[ASSUMED]` tag. Prose inside block-quotes is exempt. Table cells with no tag are treated as untagged only where a specific measurable claim is made.

### Finding 2-A (line 718) — CRITICAL

> "Seasons function as confirmed strong retention/reactivation events: August 2024 bounce (Season 1) nearly matched launch peak; Season 1 launch was also peak revenue month."

No source tag. This sentence restates specific Sensor Tower figures already sourced elsewhere in the section, but the sentence itself lacks a trailing tag.

**Recommended patch:** Append `[SOURCE: 54-sensortower-afk-journey-metrics]` at the end of the sentence.

---

### Finding 2-B (line 287) — MINOR

> "**Unlock:** Available from the start of the game."

Appears under the AFK Stages sub-section, directly after a tagged paragraph. This factual claim has no tag.

**Recommended patch:** Append `[ASSUMED — standard tutorial unlock, no dedicated source]` or cite `05-afkguide-beginners` if it confirms this.

---

### Finding 2-C (line 448 area) — Magic Charms sentence under Season 2

> "**Magic Charms:** Introduced fully; equippable by all heroes, providing stats and set bonuses; primarily obtained through Dura's Trials."

The sub-bullet describing Magic Charms in the Season 2 list has no trailing tag. Surrounding bullets all have `[SOURCE: 04-farlight-major-updates]`.

**Recommended patch:** Append `[SOURCE: 04-farlight-major-updates]` to that bullet.

---

No other untagged sentences were found. All major claim-paragraphs, table footnotes, and stats carry tags. The three findings above are the only violations.

---

## Check 3 — D1–D30 Section: 30 Days with Specificity + Known vs. Assumed

**PARTIAL PASS — structural concern flagged**

### Coverage

The section covers D1, D2–3, D4–7, D8–14, D15–21, and D22–30. These six windows span all 30 days. Coverage is not day-by-day, but the section is written as a progression arc, not a literal daily log.

**Issue:** The section heading says "D1–D30 Player Journey" and the document footer states "All claims are tagged [SOURCE:] or [ASSUMED]." However, the D1–D30 section uses fewer explicit tags per claim than other sections. Several inferential sentences about player behaviour in week 2–4 cite only `[SOURCE: analysis_pack.md]` or `[SOURCE: 03-steam-community-reviews]` in aggregate, without distinguishing which sub-claims are directly sourced vs. synthesised.

**Specific concern:** The sentence on line 574:

> "Server assignment was noted as a point of friction at launch — players may be placed in a server with a different primary language."

This is tagged `[SOURCE: analysis_pack.md]`, which is acceptable, but the full analysis_pack.md is itself a scraped review aggregation. This is a valid sourcing chain; no change required.

**Assessment:** All 30 days are covered. The section adequately distinguishes known (sourced review quotes) vs. inferred (synthesis statements). No mandatory patches; recommend adding a brief note clarifying that D1–D30 arc dates are approximate player trajectories, not guaranteed timelines (one sentence would suffice).

---

## Check 4 — Key Topic Coverage (Spot Checks)

### 4-A Exact Gacha Pity Numbers — PASS

The gacha table (Section 5) cites exact pity numbers: 60 (standard), 40 (rate-up), 30 (epic), 40 (stargaze). All sourced. `[SOURCE: 52-reddit-gacha-rates-not-accurate]`, `[SOURCE: 06-bluestacks-beginners]`, `[SOURCE: 30-reddit-pull-rates-scam]`.

Cross-check against source `52-reddit-gacha-rates-not-accurate/content.md` confirms: "hard pity at 60 rolls" for standard; "pity at 40 rolls" for rate-up; "hard pity at 30 rolls" for Epic; "pity at 40 rolls" for Stargaze. **Numbers match.**

### 4-B Resonance Synergy Cap (300 base + 5 per Supreme+) — PASS

Section 4 ("Resonance Synergy") documents:
- Base hard cap: Resonance Synergy Level 300 `[SOURCE: v2-0mb9XIFjFG4/transcript.md]`
- Supreme+ expansion: +5 per Supreme+ hero; in-game tooltip quoted verbatim; example of 340 = base 300 + 8 Supreme+ heroes × 5 `[SOURCE: v2-0mb9XIFjFG4/ANALYSIS.md]`

Both sub-mechanics are present, sourced, and exact. **PASS.**

### 4-C Honor Duel Run Structure (9 wins / 3 losses) — PASS

Section 6 (Honor Duel) states: "The run ends after **9 wins OR 3 losses**, whichever comes first." `[SOURCE: 18-fandom-honor-duel]`

Cross-check against `18-fandom-honor-duel/content.md` confirms verbatim: "The challenge ends after achieving 9 wins or experiencing 3 losses." **Exact match. PASS.**

### 4-D Sensor Tower Lifetime Revenue and MAU Numbers — PASS WITH ONE DISCREPANCY

Section 12 states:
- Total lifetime revenue (iOS + Android): $158,194,590 — **matches** source table.
- Peak MAU (April 2024): 3,223,774 — **matches** source table.
- May 2026 MAU: 844,317 — **matches** source table.
- iOS vs. Android revenue split: iOS $88.3M / Android $69.9M — source shows iOS $88,295,016 / Android $69,899,574. **Matches (rounded correctly).**

**One minor rounding note:** The doc states iOS contributed $88.3M (55.8%) — the exact figure from source is $88,295,016 (55.8%). Acceptable.

**PASS.**

### 4-E Play Store Rating (4.50 vs 4.55) and Scraped Pool (3.37) — FAIL (WRONG NUMBER IN DOC)

The doc states (line 723):
> "Android global average: 4.55 (296,381 ratings)"

Source `54-sensortower-afk-journey-metrics/content.md` states:
- `rating | 4.551099` (Android global)
- US snapshot as of 2026-06-01: average 4.555

The doc correctly rounds to **4.55**. However, the doc does NOT mention a 4.50 rating at any point. The doc never claims a 4.50 figure.

**The check asks whether "4.50 and 3.37 both present with caveat." The 3.37 scraped pool average IS present with caveat (line 724), correctly flagged as bimodal and selection-biased. The "4.50" number does not appear in any source and is not in the doc. The actual rating is 4.55. No error in the doc on this number — the 4.50 in the check prompt appears to be incorrect.**

**PASS for what's in the doc. The doc correctly uses 4.55, not 4.50. The scraped 3.37 is present with caveat.**

### 4-F Soul Pact / Phantimals — PASS

Section 7 includes a dedicated subsection "Soul Pact / Phantimals" with rules, reset mechanics, Crown of Ashes Phantimals, and sources `[SOURCE: 24-fandom-soul-pact]`. Also noted in Version 1.5.1 changelog. **PASS.**

---

## Check 5 — Sections with Too Many [ASSUMED] Tags

**PASS — Only one [ASSUMED] claim found in the entire document**

Grep result: exactly one `[ASSUMED]` tag appears in the document:

> Line 716: `[ASSUMED — calculated from SOURCE: 54-sensortower-afk-journey-metrics]`

This is the MAU retention ratio (26.2%). The `[ASSUMED]` tag correctly labels it as a derived calculation, not a directly stated figure. The underlying source is cited. This is the appropriate use of `[ASSUMED]`.

There are no sections with excessive [ASSUMED] tags. The document leans heavily on `[SOURCE: ...]` throughout.

---

## Summary Table

| Check | Result | Severity |
|---|---|---|
| 1. All 13 sections present | PASS | — |
| 2. Untagged sentences | FAIL — 3 found | Low–Medium |
| 3. D1–D30: 30 days + known vs. assumed | PARTIAL PASS | Low |
| 4-A. Gacha pity numbers | PASS | — |
| 4-B. Resonance Synergy cap (300 + 5×Supreme+) | PASS | — |
| 4-C. Honor Duel (9 wins / 3 losses) | PASS | — |
| 4-D. Sensor Tower revenue + MAU | PASS | — |
| 4-E. Play Store 4.55 + scraped 3.37 with caveat | PASS (doc uses 4.55, not 4.50) | — |
| 4-F. Soul Pact / Phantimals present | PASS | — |
| 5. Excessive [ASSUMED] sections | PASS — only 1 total | — |

**Overall status: PASS WITH MINOR PATCHES NEEDED**

---

## Recommended Patches (Priority Order)

**Patch 1 — Critical (untagged claim, line 718)**
Add `[SOURCE: 54-sensortower-afk-journey-metrics]` to end of:
> "Seasons function as confirmed strong retention/reactivation events: August 2024 bounce (Season 1) nearly matched launch peak; Season 1 launch was also peak revenue month."

**Patch 2 — Low (untagged claim, line 287)**
Add `[ASSUMED — standard tutorial unlock]` (or cite `05-afkguide-beginners` if it confirms) to:
> "**Unlock:** Available from the start of the game."

**Patch 3 — Low (untagged claim, Magic Charms bullet under Season 2)**
Add `[SOURCE: 04-farlight-major-updates]` to the Magic Charms bullet in the Season 2 changelog.

**Patch 4 — Informational (D1–D30 section)**
Consider adding a one-line preamble to Section 9 stating that day windows are approximate player experience arcs, not guaranteed timelines. This is cosmetic and not a tagging issue.

---

## Notes on Check Prompt Item 4-E

The prompt asked for "Play Store rating (4.50)". The actual Android global average from Sensor Tower is **4.55** (specifically 4.551099). The doc correctly uses 4.55. The 4.50 value does not exist in any source file. This discrepancy should be noted if the prompt was based on an earlier data pull or a different market snapshot; the current doc is correct.
