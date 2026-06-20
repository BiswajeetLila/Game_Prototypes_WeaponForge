# `marketing-reels` — v2 design (3-phase, game-agnostic)

> Status: **approved 2026-06-14**, building v0.1. Authoritative build spec. Supersedes the flat-pipeline shape in [`2026-06-14-blueprint.md`](2026-06-14-blueprint.md) (v1 retained for the skill audit, the two adversarial reviews, and the probe results — all still current).

## Locked decisions
- **Game-agnostic.** The skill/runbook/KB never name a game; they take a `<game-folder>` argument. The current project (`6_WeaponForge_TFTransistor`) is only the **test fixture** — its specifics live in `test-run/`, never in the skill.
- **Knowledge = hybrid, empirical-heart.** Thin canonical scaffold, filled by tearing down the app-intel corpus; persists in a Creative Knowledge Base that grows each run.
- **Validation = predictive ($0).** Score the *storyboard* (cheap artifact) against the KB + an ad-longevity benchmark + an independent persona LLM-judge. This **gates** generation — spend only on a winner.
- **Output = a real reel.** The workflow ends by generating an actual `.mp4` via an ai-video-beats *variation* calling the lila MCP (`generate_image` → `generate_video`).
- **Three phases:** LEARN → MAKE → VALIDATE→GENERATE.

## Why this shape
The v1 pipeline assumed Claude already knew ad-craft; it pulled competitor creatives only for format stats. v2 adds the missing **LEARN** layer that extracts *craft* (what hooks/structures actually win, measured by ad longevity) into a reusable KB, then makes beats/storyboards from evidence, validates cheaply, and spends only on the validated winner.

---

## Phase I — LEARN (generic · persistent · grows each run)
Builds/refreshes the Creative Knowledge Base. Game-agnostic; keyed by genre + comparable set.

| Step | Action | Tool | Output |
|---|---|---|---|
| L1 | Pull genre creatives (per network, populated month) | app-intel `ad_top_creatives` | creative media URLs + **longevity** (first/last seen) + dims + durations |
| L2 | Teardown longest-running winners | `curl` + `ffmpeg` frame-extract | first-1-3s hook, structure, text overlays, pacing, sound-off design |
| L3 | Extract → patterns, longevity-weighted | LLM synthesis | KB updates (below) |

**KB artifacts** (`Marketing-Reels/knowledge/`):
- `ad-grammar.md` — hook taxonomy, ad micro-structures, mobile-game archetypes, sound-off rules (canonical seed + empirical enrichment).
- `pattern-library/<genre>.md` — empirical, longevity-weighted patterns per genre; appended each run.
- `validation-rubric.md` — the predictive scoring criteria, *derived from what wins*.

**Independent signal (anti-circularity):** longevity (`last_seen − first_seen`) is an outside performance proxy — long-running ads won. The KB and rubric are weighted by it so validation isn't Claude grading its own homework.

---

## Phase II — MAKE (per game · consumes the KB)
| Step | Action | Output |
|---|---|---|
| M0 | Brief: ONE objective+KPI, ONE persona | `brief.md` |
| M1 | Positioning: the ONE hook, comparables | `positioning.md` |
| M2 | Beat sheet + ≥3 hook variants (≥1 differentiator-led), applying KB patterns; sound-off captions mandatory | `beat-sheet.md`, `hooks/hook-NN.md` |
| M3 | **Storyboard** per variant: shot list — frame, timing, camera, on-screen text, asset-per-shot | `storyboard/hook-NN.md` |

---

## Phase III — VALIDATE → GENERATE (gate, then real spend)
| Step | Action | Tool | Gate |
|---|---|---|---|
| V | Predictive score each storyboard vs `validation-rubric.md` + longevity benchmark + independent persona LLM-judge → rank → pick winner(s) | LLM-judge (subagents) | **$0; produces `validation-scorecard.md`** |
| G1 | Winner only: generate first-frames / key art | ai-art-set *variation* → lila `generate_image` (`nano-banana` default; pro only if approved by name) | **cost gate** |
| G2 | Winner only: beats → real video | ai-video-beats *variation* → lila `generate_video` (Seedance Fast 480p iterate → upscale) | **cost gate** |
| G3 | QC + package: frame-verify, write run manifest | `ffmpeg` | — |

**Not doing:** generate-all-then-judge (wastes video $ on losers). Validate the cheap artifact (storyboard) first.

---

## Folder layout
```
Marketing-Reels/                         # the generic pipeline (no game names)
├── knowledge/                           # the Creative Knowledge Base (persistent, grows)
│   ├── README.md  ad-grammar.md  validation-rubric.md
│   └── pattern-library/<genre>.md
├── skill/SKILL.md                       # the game-agnostic runbook (3 phases, gates)
├── workflow/learn-fanout.js             # Workflow-tool script: Phase-I fan-out (app-intel + teardown)
├── templates/                           # brief · positioning · creative-intel · beat-sheet · hook · storyboard
├── tests/check_run.py                   # contract checker (validates a run's output vs spec)
└── test-run/README.md                   # 6_TFT test-fixture inputs ONLY (keeps the skill generic)

<game-folder>/_art-build/marketing-reels/<YYYY-MM-DD>/   # per-run output
├── brief.md  positioning.md  creative-intel.md  beat-sheet.md
├── hooks/hook-NN.md  storyboard/hook-NN.md
├── validation-scorecard.md              # the predictive gate result
├── video/  (beat-script.md · social_9x16_<winner>.mp4 · frames-qc/)
└── manifest.md                          # artifacts · cost · URLs · which variant won + why
```

## Spend model
- LEARN = data calls only ($0 media). VALIDATE = $0. Only the **validated winner's** asset+video gen costs money — gated, `nano-banana` default, pro only if approved by name (global cost policy).

## v0.1 build manifest (this session)
1. `knowledge/` scaffold (README, ad-grammar seed, validation-rubric, pattern-library/ placeholder).
2. `skill/SKILL.md` — genericized 3-phase runbook (replaces the placeholder).
3. `workflow/learn-fanout.js` — Phase-I Learn fan-out (app-intel pulls + teardown agents).
4. `templates/storyboard.md` (+ keep existing templates).
5. `tests/check_run.py` — contract checker (Python stdlib).
6. `test-run/README.md` — 6_TFT fixture inputs (comparables, persona, ref frame) isolated from the skill.

Lean by intent — heavy edits expected after the first full run.

## Verification (RED → GREEN)
- `python tests/check_run.py <run-folder>` asserts the run contract (folder + required files + manifest schema + ≥3 hooks + winner named + a real `.mp4` present + sound-off captions present).
- **RED now:** no run folder exists → checker fails for the right reason.
- **GREEN after** the one full run on the 6_TFT fixture (gated generation spend).
