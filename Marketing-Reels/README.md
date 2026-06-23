# Marketing-Reels

A game-agnostic pipeline that turns any game prototype's product sense into **hook-tested marketing reels** for **demand/concept validation**. Three phases: **LEARN** (mine winning competitor ads into a Creative Knowledge Base) → **MAKE** (brief → positioning → beats → ≥3 hook variants → storyboards) → **VALIDATE→GENERATE** (predictively score $0, then generate a real reel of the winner via the lila image/video MCP).

> **Status: v0.1 built — not yet run.** Next: one full run on the test fixture (`test-run/`); heavy edits expected after.

## Start here
- **[discussions/2026-06-14-3phase-design.md](discussions/2026-06-14-3phase-design.md)** — the authoritative 3-phase design (what we built).
- [skill/SKILL.md](skill/SKILL.md) — the runbook you actually execute.
- [discussions/2026-06-14-blueprint.md](discussions/2026-06-14-blueprint.md) — v1 audit + probe results + the two adversarial reviews (shape superseded, rationale still useful).

## Two homes
- **The pipeline** lives here in `Marketing-Reels/` — generic, no game names.
- **Per-run output** lands in the target game's `_art-build/marketing-reels/<YYYY-MM-DD>/`.

## Folder map
```
Marketing-Reels/
├── README.md
├── discussions/         design record (3-phase design + v1 blueprint + 2 reviews)
├── knowledge/           the Creative Knowledge Base — ad-grammar · validation-rubric · pattern-library/ (grows each LEARN run)
├── skill/SKILL.md       the game-agnostic 3-phase runbook
├── workflow/            learn-fanout.js — Phase-I app-intel fan-out (Workflow-tool script)
├── templates/           brief · positioning · creative-intel · beat-sheet · hook · storyboard
├── tests/check_run.py   contract checker (RED until the first run, then GREEN)
└── test-run/            6_TFT test-fixture inputs (kept out of the generic skill)
```

## Run it
Read `skill/SKILL.md`, pass a `<game-folder>`. For the first test, fixture inputs are in `test-run/README.md`. Verify after: `python tests/check_run.py <game-folder>/_art-build/marketing-reels/<date>`.

**Spend:** LEARN + VALIDATE are $0 (data/tokens only); only the validated winner's image+video generation costs money — gated, `nano-banana` default, pro only if approved by name.
