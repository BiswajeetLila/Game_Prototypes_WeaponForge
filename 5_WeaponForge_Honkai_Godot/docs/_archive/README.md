# `_archive/` — non-authoritative docs preserved for git-archaeology

**These docs are NOT the current design.** They predate the Wittle-inversion
pivot (2026-05-27) or have been superseded by newer specs. Kept in-tree only
so a curious reader can find the historic context without spelunking through
`git log`.

If you are looking for current state, design, rules, or roadmap, use these
instead:

| You want | Read |
|---|---|
| current state + queue | `docs/STATUS.md` |
| current design (top-of-hierarchy) | `docs/01_GDD.md` |
| project rules / agent behavior | `5_WeaponForge_Honkai_Godot/CLAUDE.md` (root of this subproject) |
| pitch / submission concept | `docs/101-WeaponCraft-Concept.md` (RICOCHET template — soon to be renamed) |
| storyboard / per-screen beats | `docs/prototype-screen-beats.md` |
| pitch deck for teammates | `docs/teammate-deck.html` |
| detail-level design specs | `docs/superpowers/specs/*` |
| implementation plans | `docs/superpowers/plans/*` |

## What's in here

### `historic-gdds/`
Pre-pivot design documents.

- `01_GDD-robotek.md` — the original Robotek-fusion + TFT-shop concept (working
  folder was `1_Robotek_WeaponCraft/`). Dead concept; the project pivoted to
  Wittle-inversion on 2026-05-27.
- `Gemini_Weapon_Crafter_GDD-v2.md` — pre-fork concept doc from the HTML/JS
  prototype era. Predates the Godot fork (2026-06-01).

### `02_systems/` · `03_content/` · `04_economy/`
Stubs / scaffolds authored when the project was still TFT-shop-shaped. All
superseded by the locked design (`docs/superpowers/specs/2026-05-27-...md` v2.2)
and the post-pivot specs.

`04_economy/currency.md` was already self-flagged "SUPERSEDED" — kept for
reference; current economy is in `docs/superpowers/specs/2026-06-06-...md` +
the 2026-06-08 Ember-pivot spec.

### `handoffs-pre-fork/`
Five session handoffs from 2026-05-25 and 2026-05-26 — before the Godot fork.
Historic context only; not useful for resuming current work.

### `handoffs-superseded/`
- `2026-06-08-economy-architecture-counterbuild-design.md` — mid-session design
  handoff that the same-day `2026-06-08-build-shipped-counterbuild-economy.md`
  explicitly supersedes.

---

**Do not design from any file in this folder.** If something here looks useful,
verify against the current SSOTs above before relying on it.
