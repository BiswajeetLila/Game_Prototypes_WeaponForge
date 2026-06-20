# Validation rubric (predictive, $0 — the gate before generation)

> Scores a **storyboard** (not a finished video) so we spend generation $ only on a winner. Score each hook variant; rank; pick winner(s) above threshold.

## Three independent signals (combine — don't let one dominate)
1. **Rubric score** — Claude scores against criteria below.
2. **Longevity benchmark** — does the variant's hook/structure match patterns that *ran long* in `pattern-library/<genre>.md`? (Outside signal — guards circularity.)
3. **Persona LLM-judge panel** — N subagents, each *as the target persona*, asked "thumb-stop or scroll?" on the first 3s and "would you tap the CTA?". Majority vote. Judges must be **independent** of the writer (don't show them the rubric or the author's rationale).

## Rubric criteria (0–5 each)
| Criterion | 5 = | 0 = |
|---|---|---|
| Thumbstop (first 1s) | Instantly arresting, sound-off | Slow/logo/setup |
| Sound-off clarity | Reads fully muted, captioned | Needs audio to make sense |
| Differentiator-led | Leads with the unique mechanic | Generic genre trope |
| Pattern match | Matches a long-running winning structure | Matches nothing / a dead pattern |
| Persona fit | Speaks to the named pain + scroll context | Aimed at "everyone" |
| Payoff strength | Clear, earned dopamine beat | Flat / unclear |
| CTA clarity | One obvious next action | Absent/confusing |

## Scoring + gate
- Weighted total (weight Pattern-match + Thumbstop ×2 — they predict hook-rate most). Normalize to 0–100.
- **Gate:** generate only variants scoring ≥ threshold **AND** passing the persona-panel majority. If none pass → revise beats (back to M2), don't spend.
- Record per-variant scores + the panel verdict + which won and why in `validation-scorecard.md`.

## Note
This is calibration-in-progress. As real outcomes accrue (longevity data, and later any real-spend tests), re-weight criteria toward what actually predicted winners.
