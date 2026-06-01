# WeaponForge (Honkai) — ACTIVE dev folder

> This is the **active** WeaponCraft/WeaponForge development copy. Forked from
> **`2_Weaponcraft_Godot`** at commit `e958745` on **2026-06-01** and continued from there.
> The origin folder is now a **frozen playtester build** (see `../2_Weaponcraft_Godot/FROZEN-2026-06-01.md`).

---

## What this is

Same game, same engine (Godot 4.6.2 Mono), same docs — but this is where Phase 1+
development happens. The fork was taken so the playtester-facing 15-wave / 3-hero +
boss build (`2_Weaponcraft_Godot`) stays stable while the combat core gets reworked here.

- **Project:** `Prototype/godot/project.godot` → F5 (main scene `res://scenes/Main.tscn`).
- **Branch:** `weaponcraft-godot/wittle-inversion-phase1`.
- **Canonical docs:** `docs/STATUS.md` (single source of truth) + design spec under
  `docs/superpowers/specs/`. Paths inside those docs that say `2_Weaponcraft_Godot/...`
  refer to the historical origin; the live equivalents are here under
  `5_WeaponForge_Honkai_Godot/...`.

## Headless test run

```
C:/Godot_v4.6.2-stable_mono_win64/Godot_v4.6.2-stable_mono_win64_console.exe \
  --headless --path 5_WeaponForge_Honkai_Godot/Prototype/godot \
  res://scenes/dev/TestWeaponData.tscn
```

Exit code = failure count (0 = green).

## In progress: P1a (weapon-schema migration, TDD)

Resumed from `docs/handoffs/2026-06-01-session-handoff.md`. Remaining cycles:

1. **Forge Math diff≥2 bank cases** — diff==2 instant + bank-50%; diff==3 bank-50%;
   diff==4 bank-33%. (Tests first.)
2. **`skill_card_data.gd`** — Forge Draft card schema (hero / weapon / ability / rune card types).
3. **Migrate off legacy socket weapon** — drop sockets from `scripts/data/weapon.gd`;
   move `scripts/core/combat.gd` + `scripts/core/game_state.gd` from slot-aggregator → `WeaponData`.
4. **Re-run the full 144-suite** for regression.

*Forked 2026-06-01.*
