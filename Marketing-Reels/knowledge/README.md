# knowledge/ — the Creative Knowledge Base (CKB)

Game-agnostic, **persistent**, and **grows every run**. This is the "learnings on how to make creatives" layer — the thing that lets the pipeline make ads from evidence instead of intuition.

## Files
- `ad-grammar.md` — canonical seed: hook taxonomy, ad micro-structures, mobile-game archetypes, sound-off rules. Enriched over time.
- `validation-rubric.md` — the predictive scoring rubric used at the VALIDATE gate. Derived from what actually wins.
- `pattern-library/<genre>.md` — **empirical**, longevity-weighted patterns mined from the app-intel corpus, appended each LEARN run. Genre-keyed (e.g. `tactical-autobattler.md`).

## How it grows (LEARN phase, see ../discussions/2026-06-14-3phase-design.md)
1. Pull genre creatives via app-intel `ad_top_creatives` (media URLs + `first_seen`/`last_seen` longevity + dims + durations).
2. Teardown the **longest-running** winners with `curl` + `ffmpeg`.
3. Append longevity-weighted patterns to `pattern-library/<genre>.md`; promote recurring, cross-genre findings into `ad-grammar.md`; recalibrate `validation-rubric.md`.

## The anti-circularity rule
Ad **longevity** (`last_seen − first_seen`) is an *independent* performance proxy — ads that run for months won their auctions. Weight every empirical pattern and rubric criterion by it so validation is not Claude grading its own output against its own taste.
