# Handoff — 3-Hero Roster + Juice Foundation Session

**Date:** 2026-05-25
**Branches landed on `main`:** `feature/3-hero-roster`, `feature/juice-foundation` (both merged + remote-deleted)
**Main tip:** `dcd1286` — `juice 3/3 — per-HeroCard flash on enemy hit`
**Active prototype:** `Prototype/godot/scenes/Main.tscn` (Godot 4.6.2 Mono, 420×800 portrait)

---

## What shipped this session

Two feature PRs (12 commits total) merged sequentially. The build went from "Bran-only ultra-MVP" to "3-hero stage with full game-feel kit".

### 1. 3-hero roster (Phase 2) — 8 commits

- **Heroes added:** Elara (mage, Meteor ult) at wave 2 clear; Vex (rogue, Shadowstep ult) at wave 4 clear.
- **TOTAL_WAVES bumped 3 → 5.**
- **Ult dispatch:** `HeroData.ult_key` (`&"whirlwind"` / `&"meteor"` / `&"shadowstep"`) match block in `Combat.fire_ult`. Per-ult helpers `_ult_whirlwind / _ult_meteor / _ult_shadowstep`.
  - Meteor: AoE × 1.5 atk + advances `burn_stack` against highest-HP target (no-op without Inferno equipped; uses Inferno's `stack_cap`).
  - Shadowstep: highest-HP single-target × 3.0 atk, `is_crit=true` flag (informational, does NOT additionally stack with CRIT_MULT).
- **GameState multi-hero:** `heroes: Dictionary`, `squad_order: Array`, `unlocked_classes: Dictionary`, helpers `get_hero / active_heroes / all_heroes / any_alive / unlock_hero`. Signals `hero_unlocked(id)` + `squad_wiped`.
- **Combat:** iterates `active_heroes()` for hero attacks; `_pick_target_hero()` randomly picks among alive squad members for each enemy attack. Squad-wiped only when `not any_alive()`; per-individual `hero_died(id)` still fires informationally.
- **Shop + Merge:** Optional `hero_id=&""` param threaded through `Shop.buy / Merge.acquire_part / equip_from_inventory / unequip_to_inventory`. `_class_unlocked` reads `unlocked_classes`. `_needs_slot_guarantee` scans the whole active squad.
- **UI:**
  - `HeroCard.tscn` + `hero_card.gd` extracted from SquadBar; SquadBar becomes an HBox of cards.
  - `ForgePanel.tscn` gains a TabBar above AnvilHeader; hidden when only 1 hero unlocked. Active tab disabled (visual indicator).
  - `Main._on_wave_cleared` triggers unlocks + delayed banner; `squad_wiped` → ResultModal; per-individual `hero_died` → "💔 NAME FALLS" banner.
- **Assets:** `elara_mage.png` + `vex_rogue.png` 128² via nano-banana cheap tier ($0.0774 total) → rembg → 6% pad → LANCZOS.
- **Tests added:** Meteor AoE+burn, Shadowstep highest-HP+crit-flag, multi-hero `squad_wiped` only-when-all-dead. Suite 50/50 → 53/53.

### 2. Juice foundation (PR1 of game-feel series) — 3 commits + 1 spec

- **`ScreenShake` autoload** — trauma model. `kick(amp_px, dur_sec)`, target registered by Main. Concurrent kicks stack via `max`. Target = Main scene root (whole-game shake).
- **`HitPause` autoload** — `freeze(seconds)` sets `Engine.time_scale = 0` and waits via `process_frame` + `Time.get_ticks_msec()` wall-clock loop. Re-entrancy safe; concurrent calls extend window.
- **`JuiceConfig`** — `scripts/core/juice_config.gd` const dictionary, single source of truth for tuning. Keyed by `source` StringName (`&"basic"`, `&"basic_crit"`, `&"steamburst"`, `&"skewer"`, `&"hellfire"`, `&"ult"`, `&"ult_meteor"`, `&"ult_shadowstep"`) plus `ENEMY_HIT_HERO` and `WAVE_CLEAR`. Each profile holds `shake_amp / shake_dur / pause / font_pt / color / prefix / flash_dur`. `profile_for(source, is_crit)` resolves with `basic+crit → basic_crit` and falls back to `FALLBACK`.
- **BattleView** consumes the kit on every `hero_hit_enemy / enemy_hit_hero / ult_fired` signal. Spawns popup with profile-driven font / color / prefix, fires `ScreenShake.kick`, `HitPause.freeze`, sprite-flash via modulate boost `(1.8, 1.8, 1.8, 1) → Color.WHITE` tween.
- **HeroCard.flash(duration)** — modulate boost on the portrait. SquadBar listens to `Combat.enemy_hit_hero` and dispatches per-card flash so each hero's roster slot reacts even though BattleView only shows Bran's portrait.
- **Popup polish:** scale 0.4 → 1.0 back-out, drift up + delayed alpha fade, 8-popup concurrent cap.
- **Wave-clear shake** in `Main._on_wave_cleared`.

Spec at [`docs/superpowers/specs/2026-05-25-juice-foundation-design.md`](../superpowers/specs/2026-05-25-juice-foundation-design.md) — covers what shipped + the deferred PRs (per-element bursts, ult cinematics, status icons, UI-click bounce, audio).

---

## Current build state

- **Engine:** Godot 4.6.2 Mono (`C:/Godot_v4.6.2-stable_mono_win64/`)
- **Window:** 420×800 portrait, Compatibility renderer
- **Heroes:** Bran (wave 1), Elara (unlocks wave 2 clear), Vex (unlocks wave 4 clear)
- **Waves:** 5 (no boss yet)
- **Parts catalog:** still 5 (h_iron_edge, p_steel_grip, p_pyro_pommel, r_fire, r_ice)
- **Recipes shipped:** 2 (Steamburst, Inferno) — Combat code supports all 8 keys, awaiting tres files
- **Autoloads:** GameState, ScreenshotHelper, RNG, Recipes, Merge, Shop, Combat, **ScreenShake**, **HitPause**
- **Save logs:** `%APPDATA%/Godot/app_userdata/WeaponCraft Godot Ultra-MVP/logs/godot.log`
- **F12 in-game:** screenshots to same user dir

---

## What works end-to-end (after F5)

1. Open project at root: `C:/_BISU/_WORKSPACE/AI_Explorations/_Claude/Game_Prototypes/2_Weaponcraft_Godot/Prototype/godot/project.godot` (root now properly on `main` branch — `git pull` works directly).
2. Wave 1 forge → Bran tab only, SquadBar shows 1 card.
3. Equip parts → element-tinted PartCards, recipe chips light up.
4. Start wave → every hit produces: amber damage popup, ~3px screen shake, ~50ms freeze, enemy sprite brightens.
5. Crit → bigger red-orange "⚡" popup, ~6px shake, ~100ms freeze.
6. Steamburst splash → ice-blue popups on splashed enemies.
7. Wave 2 clear → "✓ WAVE 2 CLEAR +🪙9" + 0.7s later "✨ ELARA JOINS — MAGE"; SquadBar slides in 2nd card; ForgePanel grows 2nd tab.
8. Wave 3 forge → tab to Elara, equip from shop+inventory, start wave. Both heroes attack each tick. Fire Meteor → ~10px shake, ~180ms freeze, big magenta "🌀 N total" popup, per-enemy popups.
9. Wave 4 clear → Vex joins; 3 cards, 3 tabs.
10. Wave 5 → fire Shadowstep → only highest-HP enemy takes massive crit.
11. Enemy hits hero → screen shake + BattleView portrait flash if hero=Bran + SquadBar card flash for any hero.
12. All heroes dead → "💀 WIPE" banner + ResultModal. Individual death → "💔 NAME FALLS" informational banner only.
13. Stage clear at wave 5 → 🏆 + gold ResultModal.

Test suite: combat 20, recipes 11, shop 7, merge 15 → **53/53 green**.

---

## Tuning knobs

All juice numbers in [`scripts/core/juice_config.gd`](../../Prototype/godot/scripts/core/juice_config.gd). Single file. Tweak one profile → next F5 picks up new values. No editor restart needed for value-only changes; structural changes (adding a new source key) need a re-import.

Common knobs:
- `PEAK_AMPLITUDE_PX` in `screen_shake.gd` — cap for the trauma squared curve (currently 12px).
- Popup `font_pt`, `color`, `prefix` per source.
- `shake_amp / shake_dur` per source.
- `pause` per source (in seconds; 0.05 = subtle, 0.18 = dramatic).
- `flash_dur` per source.

---

## Open known issues / candidates for next session

| ID | Symptom | Notes |
|---|---|---|
| K-7 | BattleView only renders Bran's portrait; Elara/Vex are SquadBar-only | Intentional for ultra-MVP. Future Phase 2.5: render the "active" hero in the arena, or all three. |
| K-8 | Multi-hero ult balance: 3 ults per fight could trivialize combat | TODO in `combat.gd`. Balance pass needed — per-fight gauge reset, or shared squad pool. |
| K-9 | `Engine.time_scale = 0` during HitPause freezes Notifications banner mid-pop, looks slightly stuttery | Acceptable; brief (50-180ms) reads as deliberate hit-stop. |
| K-10 | DamagePopup spam on big AoEs (3+ Steamburst splash + Skewer) — 8-popup cap drops the oldest eagerly | Visible in heavy fights; not bad, but PR2 may want a smarter dedup. |
| K-11 | `nano-banana` raw PNGs (`*_raw.png`) tracked in git ~1.7 MB | Could move to `_raw/` ignored subfolder. Cosmetic. |
| K-12 | Project.godot autosave drift on every Godot run (CRLF on .import files, reorder of `[debug]` section) | Pure noise. Don't commit; let Godot churn. |
| K-13 | Per-element popup prefix doesn't surface weak/resist multiplier hits (★/~) — the old code computed it from wrong fields and is now dropped | Could be re-added in PR2 by checking weapon tags against enemy.weak/resist at popup time. |

---

## Phase 2 candidates (in plan-priority order, reflecting today's tip)

Already enumerated in `docs/superpowers/specs/2026-05-23-godot-ultra-mvp-port-design.md` plus today's juice spec. Top picks now:

1. **Juice PR2** — per-element particle bursts (use existing `fire_puff.png` / `ice_shard.png`) + crit-specific screen flash overlay + HP bar damage-chunk delta layer.
2. **Juice PR3** — per-ult cinematics: Whirlwind spin tween, Meteor sky-drop streak, Shadowstep dash blur. Big "show off the hero" moments.
3. **Full 11-part catalog + remaining 6 recipes** — Permafrost, Skewer, Razor Wind, Hellfire, Frostbite, Quickdraw. Combat already supports all keys; just .tres files.
4. **Boss wave + retry** — wave 6 boss with affinity telegraph + `Reforge & Retry` modal.
5. **Blender 3D-in-2D hero swap** — replace one chibi with a glb in a SubViewport (validates Blender MCP pipeline).
6. **Audio** — hit / ult / merge / click SFX from freesound or Kenney audio.
7. **Mobile export pass** — Android export template, real-device test.

---

## Where things live

```
2_Weaponcraft_Godot/
├── Mockup/                                      (locked direction: 04_cozy_parchment_vivid.png)
├── Prototype/godot/
│   ├── project.godot                            autoloads incl. ScreenShake + HitPause
│   ├── theme.tres
│   ├── icon.svg
│   ├── .gitignore                               (.godot/ ignored, *.import TRACKED)
│   ├── assets/
│   │   └── generated/
│   │       ├── heroes/{bran_warrior, elara_mage, vex_rogue}.png  (+ *_raw originals)
│   │       ├── enemies/{slime, goblin, skeleton}.png
│   │       ├── parts/{h_iron_edge, p_steel_grip, p_pyro_pommel, r_fire, r_ice}.png
│   │       └── vfx/{merge_sparkle, fire_puff, ice_shard}.png
│   ├── data/
│   │   ├── heroes/{bran, elara, vex}.tres                          NEW
│   │   ├── enemies/{slime, goblin, skeleton}.tres
│   │   ├── parts/{h_iron_edge, p_steel_grip, p_pyro_pommel, r_fire, r_ice}.tres
│   │   └── recipes/{steamburst, inferno}.tres
│   ├── scenes/
│   │   ├── Main.tscn                            mounts everything, registers ScreenShake target
│   │   ├── Hud.tscn, BattleView.tscn, SquadBar.tscn
│   │   ├── ForgePanel.tscn (tabs above AnvilHeader), PartCard.tscn
│   │   ├── HeroCard.tscn                                          NEW (extracted from SquadBar)
│   │   ├── CodexModal.tscn, DiscoveryOverlay.tscn, ResultModal.tscn
│   │   ├── Notifications.tscn
│   │   └── dev/{TestRecipes, TestShop, TestMerge, TestCombat, TilePicker}.tscn
│   ├── scripts/
│   │   ├── core/                                game_state, combat, shop, merge, recipes, rng,
│   │   │                                        screenshot_helper, screen_shake, hit_pause,
│   │   │                                        juice_config                                  NEW: 3
│   │   ├── data/                                part_data, hero_data (+ult_key), enemy_data,
│   │   │                                        recipe_data, inventory_item, weapon, hero_state
│   │   ├── dev/                                 tile_picker, test_recipes, test_shop, test_merge,
│   │   │                                        test_combat (+ 3 new ult/squad tests)
│   │   └── ui/                                  main, hud, battle_view (juice-wired),
│   │                                            squad_bar, hero_card (NEW), forge_panel (tabs),
│   │                                            codex_modal, discovery_overlay, result_modal,
│   │                                            notifications, screen_flash, part_card
└── docs/
    ├── 01_GDD.md, 01b_GDD_addendum_BASE-A1.md, 05_roadmap.md
    ├── handoffs/
    │   ├── 2026-05-25-asset-replacement-session.md            (prior)
    │   └── 2026-05-25-3hero-roster-juice-foundation.md        THIS FILE
    └── superpowers/specs/
        ├── 2026-05-23-godot-ultra-mvp-port-design.md
        └── 2026-05-25-juice-foundation-design.md              NEW
```

---

## How to resume

1. `cd C:/_BISU/_WORKSPACE/AI_Explorations/_Claude/Game_Prototypes` (root now on `main` branch).
2. `git pull` → fast-forwards main.
3. Open project in Godot: `2_Weaponcraft_Godot/Prototype/godot/project.godot`. F5 to verify.
4. Re-run all 4 dev test scenes (right-click → Play Scene): expect 53/53 PASS.
5. Pick from Phase 2 list above OR tune juice numbers in `scripts/core/juice_config.gd`.
6. For new work: `git checkout -b feature/<short-name>` from root, commit-per-atomic-change, push, ff-merge to main, push, `git push origin --delete feature/<short-name>`.

### Worktree state

- **Root** at `main` (`dcd1286`) — `git pull` works directly.
- One Claude session worktree still on disk at `.claude/worktrees/quirky-saha-7c45d0/` (this session's). Will be cleaned automatically by the harness if no changes; otherwise the branch ref persists.
- Three older orphan claude worktrees still on disk (`competent-bouman-*`, `flamboyant-ishizaka-*`, `vigorous-chaum-*`). Harmless. Clean with `git worktree remove --force <path>` when convenient.
- `brave-hodgkin-*` worktree was unregistered earlier this session; folder may still exist on disk if a process held a lock — `rm -rf` it when Godot is closed.

### Drift stashes

`stash@{0}` on root: `godot drift before juice merge` — kept as a safety net. Contains Godot's autosave-only changes to `project.godot` (the autoload section had the same content but Godot rewrote ordering/CRLF). Pop if Godot misses any setting; otherwise drop with `git stash drop`.

---

## Cost summary (this session only)

| Spend | What |
|---|---|
| ~$0.08 | Elara + Vex sprites via `nano-banana` cheap tier (per global cost policy — no `nano-banana-pro` without explicit user confirm) |
| Total | ~$0.08 |

No image-model regenerations needed; first-pass output was usable after rembg + crop + LANCZOS.

---

End of handoff. Build is in a strong place — 3 heroes, full game-feel kit, all tests green, root + origin on the same tip.
