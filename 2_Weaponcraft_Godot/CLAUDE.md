> **FROZEN 2026-06-12 — see [`../6_WeaponForge_TFTransistor/`](../6_WeaponForge_TFTransistor/).** Forward work happens there; this folder is reference-only.

# 2_Weaponcraft_Godot — Folder Rules

> Scope: these rules govern **only** `2_Weaponcraft_Godot/`. Sibling prototype folders are out of scope.

## Single Source of Truth (SSOT)

**SSOT = [`docs/01_GDD.md`](docs/01_GDD.md) + the shipped Godot build in [`Prototype/godot/`](Prototype/godot/).**

- `docs/01_GDD.md` is the design SSOT. Everything in `docs/` either **is** the SSOT or is a spec that **points to** it.
- The **Godot build is authoritative for all current-state facts.** Where any doc and the build disagree, **the build wins** — update the doc, not the build. (Example: heal potion = **15%** max HP, per code; any doc saying otherwise is stale and must be corrected.)
- Design intent that is not yet implemented is tagged **[ROADMAP]** in the GDD. It is valid future direction, not current state.
- **Current direction (locked 2026-06-11):** crafting-core run + persistent hero-squad gacha meta. Full spec + phasing: [`docs/superpowers/specs/2026-06-11-hero-squad-meta-design.md`](docs/superpowers/specs/2026-06-11-hero-squad-meta-design.md). First prototype = **P0** (persistence + HOME + squad-select + Hero Level + juice/audio; no gacha yet).

## Active docs (forward work happens here)

| Path | Role |
|---|---|
| `docs/01_GDD.md` | **THE SSOT.** Reconciled to the build; roadmap items tagged. |
| `docs/02_systems/` | System specs (combat math, onboarding, pvp, audio, art direction) — elaborate GDD open questions. |
| `docs/03_content/` | Content specs (characters, parts, recipes, boss affinities). |
| `docs/04_economy/` | Economy specs (currency, stamina, battle pass, cosmetics). |
| `docs/roadmap-2026-06-12.md` | Roadmap / phasing (P0 → full game). |
| `docs/story-beats.md` | Observable beats of the current build. |
| `docs/superpowers/specs/` | **Active** design specs. Current set: `2026-06-11-hero-squad-meta-design.md` (direction), `2026-06-12-retention-arc-d1-d20.md` (D1→D20 retention), `2026-06-12-greenlight-pitch.md` (CEO pitch). (The *old* fork-era specs are in `_archive/docs/superpowers/` — different tree.) |

Every active spec carries a header banner pointing back to the SSOT. When a spec decision is finalised and reflected in the build, fold the fact into `01_GDD.md`.

## `_archive/` — historical, reference-only

**`_archive/` MUST NOT be used for forward work.** It exists for archival/reference reasons only. Do not treat anything in it as canonical, current, or a design target.

It holds:
- The abandoned **"Wittle-inversion" weapon-gacha fork** (that direction continued as the separate project `5_WeaponForge_Honkai_Godot` — not here). Includes `wittle-inversion-*`, `101-WeaponCraft-Concept`, `Gemini_Weapon_Crafter_GDD-v2`, the old `STATUS.md`, competitor research, and the HTML decks.
- **Old session handoffs** and build specs (BASE-A1, godot-port, juice) — historical record of how the current build was made.
- **Mockups / beat-renders** — visual exploration, much of it fork-era.

If something in `_archive/` is needed for current work, **promote a clean copy into `docs/` and reconcile it to the SSOT first** — never reference the archive directly as truth.

## Engine / run
- Godot **4.6** Mono. Project: `Prototype/godot/project.godot`. F5 to run; main scene `scenes/Main.tscn`.
- Tests: hand-rolled dev scenes under `scenes/dev/` (`TestCombat`/`TestRecipes`/`TestShop`/`TestMerge`/`TestUi`/`TestWeaponData`). `.import` autosave churn is noise — discard, don't commit.
