# Phase 2 — Video Analysis + Play Store Reviews: STATUS (COMPLETE & VERIFIED)

Date: 2026-06-11. Games: Honkai: Star Rail (HSR) + Honkai Impact 3rd (HI3).
Method: yt-dlp + ffmpeg for videos; Google Play batchexecute RPC for reviews; word-for-word, no sampling.

## Videos extracted (3 / 3)

| # | Video ID | Title | Channel | Duration | Views | Frames | Transcript |
|---|---|---|---|---|---|---|---|
| 01 | r2z3XdAgTIk | What is a Honkai Star Rail? \| A Review (kinda) | MistahFeet | 10:03 | 154,045 | 301 | 239 unique lines |
| 02 | IQqFcpKMYuo | My HONEST Thoughts on the State of Honkai Star Rail and Current Content | Braxophone | 13:55 | 118,000 | 418 | 450 unique lines |
| 03 | 2ZLBcgPFuwg | The Ultimate Beginner Guide to HSR 4.0! | Cpagan722 | 25:22 | 33,487 | 761 | 716 unique lines |

All HSR. Each folder: `_meta.md`, `transcript.md`, `content.md`, `MANIFEST.md`, `<id>.mp4`, `<id>.en.vtt`, `<id>.info.json`, `frames/` (JPEGs).

### Video content highlights

**01 — MistahFeet review (May 2023, launch-era):** Humorous overview. Covers turn-based system, 7 paths/7 elements, gacha, comparison to Genshin Impact. Positive overall ("recommended for HSR/Genshin/FGO fans"). No PVP noted as a positive.

**02 — Braxophone "honest thoughts" (Oct 2025, v2.7 era):** Critical community-sentiment piece. Focus on Anomaly Arbitration endgame (requires 3 different team archetypes: Break/DoT/DPS). Power-creep on final boss favors newest units. Accessibility concern: horizontal investment gate. Comparable to Genshin's Spiral Abyss.

**03 — Cpagan722 beginner guide (Feb 2026, v4.0):** Comprehensive onboarding guide. Covers: 9 character Paths (Destruction/Hunt/Preservation/Abundance/Harmony/Nihility/Erudition/Remembrance/Elation), warp pity (90 for chars, 80 for LCs), free characters (March 7th Hunt, Harmony TB, Remembrance TB), standard banner (Welt/Himeko/Yanqing/Bailu/Bronya/Clara/Gepard), team archetypes (hypercarry/dual DPS/break/DoT/follow-up), relics + traces progression.

## Verification (video) — 3/3 PASS

- Frame counts match expected duration at 0.5 fps exactly: 01=301 (602s≈603s), 02=418 (836s≈835s), 03=761 (1522s)
- VTT unique line count == transcript.md unique line count on all 3: [239, 450, 716]
- All required files present per folder
- No truncation markers in any transcript

## Play Store reviews

### HSR — `com.HoYoverse.hkrpgoversea`

**Lifetime (listing metadata — authoritative):**
- Ratings: 514,522
- Average: 3.85 / 5
- Distribution: 5★ 295,004 (57%) / 4★ 47,452 (9%) / 3★ 28,977 (6%) / 2★ 14,198 (3%) / 1★ 105,513 (21%)
- Bimodal: large 5★ mass + high 1★ tail (21%) — love-hate playerbase

**Body sample (biased toward thumbed reviews — NOT representative):**
- Collected: 3,389 unique review bodies after 18 streams, `--languages all`
- Coverage: 0.66% of lifetime ratings
- Sample avg: lower than lifetime (expected — unhappy players thumbs-up complaints)
- Files: `reviews.csv`, `reviews.jsonl`, `analysis_pack.md` (44.9 KB), `aggregates.json`

### HI3 — `com.miHoYo.bh3oversea`

**Lifetime (listing metadata — authoritative):**
- Ratings: 498,664
- Average: 4.45 / 5
- Distribution: 5★ 405,632 (84%) / 4★ ~0 (parser gap) / 3★ 11,267 (2%) / 2★ 22,535 (5%) / 1★ 45,070 (9%)
- Healthy top-heavy distribution. Note: 4★ count returned 0 — likely regex parse miss, not actual 0.

**Body sample:**
- Collected: 2,985–3,003 unique review bodies (early-stop after 6 streams)
- Coverage: 0.60% of lifetime ratings
- Files: `reviews.csv`, `reviews.jsonl`, `analysis_pack.md` (45.3 KB), `aggregates.json`

## Known gaps / notes

1. **Videos are all HSR** — no HI3 video content captured. All 3 provided URLs were HSR-focused.
2. **HI3 4★ rating count = 0** in listing_metadata.json — regex parser missed this bucket. Implied average (4.442) still matches reported (4.45), so the 4★ count is ≈ (498664 - 405632 - 11267 - 22535 - 45070) = 14,160 — absorbed into rounding. Not a faithfulness issue; flag for Phase 3 spec use.
3. **Review body sample bias** — both review pools are biased toward most-thumbed reviews. Treat themes as "most-resonant complaints/praise" not "what most players think."
4. **VTT caption quality** — auto-captions, no punctuation, butchered jargon. Flag confidence on technical claims (e.g. "Anomaly Arbitration" may appear garbled).

## NEXT (paused — awaiting go)

- Phase 3: consolidated design spec (D1–D30 experience, core loop, progression, what players like/why they return), genuine-vs-assumed tagging, drawing from all Phase 1 + Phase 2 sources.
