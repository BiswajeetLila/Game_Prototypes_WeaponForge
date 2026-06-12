# _archive — historical, reference-only

> **Do not use anything here for forward work on `6_WeaponForge_TFTransistor`.**
> This folder exists for archival / historical reasons only. Nothing in it is canonical, current, or a design target.

The single source of truth lives elsewhere:
- **SSOT:** [`../docs/01_GDD.md`](../docs/01_GDD.md)
- **Folder rules:** [`../CLAUDE.md`](../CLAUDE.md)

## Why these were archived

Three layers of archive, by direction abandoned:

### 1. `docs-pre-pivot-2026-06-12/` — the 2_WC direction (anatomical Head/Hilt/Rune + single-lane combat + recipe discovery + hero-squad gacha)

Archived 2026-06-13 after the WeaponForge TFTransistor pivot. See [`docs-pre-pivot-2026-06-12/README.md`](docs-pre-pivot-2026-06-12/README.md) for full inventory. 22 docs total: 2_WC roadmap + story-beats + 5 system stubs + 4 content scaffolds (parts, recipes are DEAD) + 4 economy stubs + 4 P0 implementation plans + 3 superseded hero-squad-direction specs.

### 2. The Wittle-inversion fork (inherited from 2_WC seed)

The abandoned weapon-gacha fork that continued as the separate `5_WeaponForge_Honkai_Godot` project:

| Path | What it is | Why archived |
|---|---|---|
| `docs/STATUS.md` | Old project entry-point | Named the Wittle-inversion fork spec as canonical. |
| `docs/superpowers/specs/2026-05-27-wittle-inversion-design.md` | Fork design spec (v2.2) | "Pull weapons, lock heroes, Catalyst, Forge Wheel" — a **different game**. Continued as `5_WeaponForge_Honkai_Godot`. |
| `docs/101-WeaponCraft-Concept.md` | Fork concept doc | Fork direction. |
| `docs/Gemini_Weapon_Crafter_GDD-v2.md` | Older alternate GDD | Competing design doc. |
| `docs/research/` | Competitor synthesis + portrait test | Research backing the fork direction. |
| `docs/decks/`, `docs/101-deck.html`, `docs/teammate-deck.html` | HTML slide decks + assets | Presentation artifacts (101 deck = fork). |
| `docs/handoffs/` | Session handoffs (2026-05-22 → 06-01) | Historical record of how the build was made. |
| `docs/superpowers/specs/` (BASE-A1, godot-port, juice) | Build implementation specs | Point-in-time specs, already shipped. |

### 3. `Mockup/` — visual exploration artifacts

Style tests, gameplay mockups, beat-renders. Inherited from 2_WC seed. Current visual hub for the weapon-gacha thread moved to `5_WeaponForge_Honkai_Godot`. WeaponForge TFTransistor visual direction is TBD (post-Phase 4 feel-gate).

## If you need something from here

Promote a **clean copy** into `docs/`, reconcile it to the new direction's SSOT ([`../docs/01_GDD.md`](../docs/01_GDD.md)), and tag any unbuilt intent `[ROADMAP]`. Never cite the archive directly as truth.
