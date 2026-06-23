---
name: marketing-reels
description: >-
  Turn any game prototype's product sense into a hook-tested marketing reel for
  demand/concept validation. Three phases: LEARN (mine winning competitor ad
  creatives into a Creative Knowledge Base), MAKE (brief → positioning → beats →
  ≥3 hook variants → storyboards), VALIDATE→GENERATE (predictively score
  storyboards $0, then generate a real .mp4 of the winner via the lila image/video
  MCP). Game-agnostic — takes a <game-folder> argument; never hard-codes a game.
  Invoke explicitly — manual; gated on real generation spend.
---

# marketing-reels (v0.1 runbook)

> Human-driven runbook (skills can't auto-chain — see ../discussions/2026-06-14-3phase-design.md). Claude drives the stages; cost gates surface to the user. v0.1 — heavy edits expected after the first full run.

## Input
- `<game-folder>` — absolute path to the target game (e.g. a prototype folder). **The only game-specific input.** Everything else is generic.
- The skill reads that game's GDD / story-beats / existing `_art-build/` (ref frame + hosted URL in its `manifest.md`).

## Output
- `<game-folder>/_art-build/marketing-reels/<YYYY-MM-DD>/` — brief, positioning, beat-sheet, hooks, storyboards, validation-scorecard, and a real `video/social_9x16_<winner>.mp4`, plus `manifest.md`.

---

## Phase I — LEARN  (refresh the Creative Knowledge Base; generic)
Skip if `../knowledge/pattern-library/<genre>.md` is fresh (< ~30 days) for this genre.
1. Identify genre + comparables from the game's GDD.
2. Run the Learn fan-out: `Workflow({ scriptPath: "Marketing-Reels/workflow/learn-fanout.js", args: { genre, networks: ["Applovin","Unity","Instagram","TikTok"], country: "US" } })`.
   - It pulls `ad_top_creatives` (populated month + network — **not "Facebook"**; `limit:0` ≠ blocked), tears down the **longest-running** winners with `curl`+`ffmpeg`, and appends longevity-weighted patterns to `../knowledge/pattern-library/<genre>.md`.
3. Promote recurring cross-genre findings into `../knowledge/ad-grammar.md`; recalibrate `../knowledge/validation-rubric.md`.

## Phase II — MAKE  (per game; consume the KB)
Create the run folder, then fill from `../templates/`:
- **M0 `brief.md`** — ONE objective+KPI, ONE persona (named pain + scroll context). Halt if not singular.
- **M1 `positioning.md`** — the ONE hook, 3 comparables, USP-line candidates.
- **M2 `beat-sheet.md` + `hooks/hook-01..NN.md`** — master 5-beat body + **≥3 hook variants**, ≥1 differentiator-led, applying KB patterns. **Sound-off captions mandatory** on every beat.
- **M3 `storyboard/hook-NN.md`** — per-variant shot list (frame, timing, camera, caption, asset-per-shot).

## Phase III — VALIDATE → GENERATE
- **V (gate, $0) `validation-scorecard.md`** — score each storyboard with `../knowledge/validation-rubric.md`: rubric + longevity benchmark + an **independent** persona LLM-judge panel (spawn judge subagents that don't see the author's rationale). Rank; pick winner(s) above threshold + panel majority. **If none pass → revise M2, do not spend.**
- **G1 (cost gate) assets** — winner only: generate first-frames/key art via lila `generate_image` (ai-art-set-style ref-lock to the game's `_art-build/ref-gameplay.png` hosted URL). **`nano-banana` default; `nano-banana-pro` only if the user approves by name.**
- **G2 (cost gate) video** — winner only: beats → `generate_video` (Seedance Fast 480p to iterate; image_url = a hosted CDN frame URL). Frame-verify with `ffmpeg`; upscale the winner.
- **G3 package** — write `manifest.md` (artifacts, per-item + total cost, hosted URLs, which variant won + why). Relay cost/budget blocks verbatim per the MCP reply rules.

---

## Gates summary
- VALIDATE is **$0** and **precedes** any generation — spend only on a validated winner.
- Every `generate_*` call needs explicit cost approval; honor the global never-`nano-banana-pro`-unless-named policy.
- No video without a hosted `image_url`.

## Verify the run
`python ../tests/check_run.py <game-folder>/_art-build/marketing-reels/<YYYY-MM-DD>` → exit 0 = contract met.

## Genericity guard
Nothing in this file names a game. Test-fixture inputs (the first target, its comparables/persona/ref) live in `../test-run/README.md`, never here.
