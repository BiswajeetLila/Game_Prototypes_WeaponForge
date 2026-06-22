# Issue tracker — local Jira-style weekly log

A lightweight, file-based stand-in for Jira. One Markdown file per week. Tick boxes as work lands; at week's end the file *is* the rollup (done vs. open).

## Files

- One log per ISO week: `YYYY-Www.md` (e.g. `2026-W26.md`), week starts **Monday**.
- This `README.md` = the convention (this file). Not a weekly log.

## Ticket IDs

- `WFT-###` (WeaponForge TFTransistor), monotonic, **never reused or renumbered**.
- Lower numbers = created earlier. Completed work gets the early IDs; new planned work appends.

## Statuses

| Box | Status |
|---|---|
| `[ ]` | To do |
| `[~]` | In progress |
| `[x]` | Done |

Priority: `P0` (substrate / do first) → `P3` (polish). `🎯 today` tags the current day's high-priority cut.

## Ticket body fields

`Status` · `Created` · `Closed` · `Priority` · `Blocked by` · `Source` (where the idea came from — a "What's next" item, a brainstorm, etc.) · **What to build** · **Acceptance criteria** (checkbox list) · optional `Done via` (commit/doc refs).

Slices follow the *tracer-bullet* rule: each is a thin **vertical** slice (rule, UI, feedback, verifiable) — not a horizontal layer.

## Weekly rollup process

1. **During the week:** flip boxes in the **Board** section as tickets move. Keep full bodies under **Tickets**.
2. **End of week:** update the **Summary** counts. The file is the retro — done vs. carried.
3. **Carry-over:** open tickets move to next week's file **with the same ID** and their original `Created` date. Add a `Carried from 2026-Www` note.
4. New tickets discovered mid-week get appended with the next free ID.

## Notes

- These weekly logs are **living files** — they are meant to be edited (boxes flipped, counts updated). They are the explicit exception to the repo's "dated decision docs are immutable" rule. Design *decisions* still go in `docs/superpowers/specs/` (immutable, dated); this folder only tracks *work status*.
- Cross-reference: design rationale lives in `docs/superpowers/specs/`; current state lives in `../../HANDOFF.md`.
