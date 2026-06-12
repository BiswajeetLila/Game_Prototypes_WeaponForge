# docs-pre-pivot-2026-06-12 — archived 2_WC-direction design docs

> **Reference-only. Do NOT use for forward work.**

These docs were authored under the previous `2_Weaponcraft_Godot` direction (anatomical Head/Hilt/Rune crafting + single-lane combat + recipe discovery + hero-squad gacha meta). On **2026-06-12** the user pivoted to **WeaponForge TFTransistor** (Function Matrix + 3-lane auto-runner + Magicka reactions). These docs describe a different game and remain only for design archeology — they are not canonical for forward work.

**Current SSOT:** [`../../docs/01_GDD.md`](../../docs/01_GDD.md). All forward work points to that.

## What's in here

```
_archive/docs-pre-pivot-2026-06-12/
├── README.md (this file)
├── roadmap-2026-06-12.md         2_WC P0 → full game roadmap
├── story-beats.md                 2_WC P0 observable beats narrative
├── 02_systems/                    subsystem stubs
│   ├── art_direction.md
│   ├── audio.md
│   ├── combat_math.md
│   ├── onboarding.md
│   └── pvp_arena.md
├── 03_content/                    content scaffolds
│   ├── boss_affinities.md
│   ├── characters.md              (9-12 hero roster, Mastery system — superseded; Bran/Elara/Vex carry forward but with new identities)
│   ├── parts.md                   (Head/Hilt/Rune anatomical — DEAD)
│   └── recipes.md                 (~200 discoverable recipes — DEAD)
├── 04_economy/                    economy stubs
│   ├── battle_pass.md
│   ├── cosmetics.md
│   ├── currency.md
│   └── stamina.md
└── superpowers/
    ├── plans/                     P0 implementation plans (SHIPPED in 2_WC at fbe426d)
    │   ├── 2026-06-12-p0-hero-progression-foundation.md
    │   ├── 2026-06-12-p0-home-squad.md
    │   ├── 2026-06-12-p0-slice-beats.md
    │   └── 2026-06-12-p0-wiring.md
    └── specs/                     2_WC-era specs
        ├── 2026-06-11-hero-squad-meta-design.md
        ├── 2026-06-12-greenlight-pitch.md
        └── 2026-06-12-retention-arc-d1-d20.md
```

## What survives the pivot (still in active code/specs)

The following 2_WC-era artifacts were NOT archived — they survive into the WeaponForge TFTransistor direction unchanged:

- **Meta layer code:** `account_state.gd`, `hero_progress.gd`, `home.gd` + `Home.tscn`, `result_modal.gd` + `ResultModal.tscn`, `pull_overlay.gd` + `PullOverlay.tscn`, `screenshot_helper.gd` (AUTOSHOT), TDD harness pattern
- **AccountState save schema v2** (extends to v3 in Phase 4 for `ftue_complete` bool)
- **PullOverlay cinematic:** reused for FTUE Bran/Vex hero-join cinematics per [function spec §13](../../docs/superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md#13-ftue--staged-hero-unlock-per-mit-b-revised)
- **`scout_intel` data path:** revived as per-stage wave telegraph per [function spec §17](../../docs/superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md#17-wave-telegraph-scout_intel-revived)

## When to consult these docs

- **For design archeology** — understanding how the 2_WC direction reasoned about a problem
- **For code-survival reference** — the P0 plans in `superpowers/plans/` describe how the surviving meta-layer code was built; useful when re-touching that code
- **For comparing approaches** — when the new direction's design needs to weigh against the dropped one

Otherwise, **never** treat as canonical — the new direction's [`01_GDD.md`](../../docs/01_GDD.md) is the SSOT.
