# workflow/

**[`learn-fanout.js`](learn-fanout.js)** — the Phase-I LEARN fan-out (Workflow-tool script).

Invoke from the runbook:
```
Workflow({ scriptPath: "Marketing-Reels/workflow/learn-fanout.js",
           args: { genre: "<genre>", networks: ["Applovin","Unity","Instagram","TikTok"],
                   country: "US", category: 6014, date: "2026-05-01" } })
```
It pulls `ad_top_creatives` per network, ranks by **ad longevity** (run length = performance proxy), and returns synthesized markdown. **Workflow scripts have no filesystem access** — the runbook writes the returned `markdown` to `../knowledge/pattern-library/<genre>.md`.

Phase-III generation (image/video) is **not** automated here: it's gated, manual-approval spend driven by the runbook (SKILL.md G1/G2) calling the lila MCP directly. v0.1 — heavy edits expected.
