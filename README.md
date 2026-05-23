# WeaponCraft — Game Prototype Workspace

A vertical-mobile fantasy auto-battler centered on a 3-piece weapon crafting hook (Head + Hilt + Rune), tag-based recipe discovery, and a 3-hero squad. Three parallel prototype variants explore different combat-pacing models against the same shared design DNA (parts, recipes, sprites, mockup, hero kits).

**Author:** Biswajeet (Lila Games)
**Repo:** [`BiswajeetLila/Game_Prototypes_WeaponForge`](https://github.com/BiswajeetLila/Game_Prototypes_WeaponForge)
**Status:** Active prototyping. No production code. Each variant ships as a single HTML/JS file (Godot port is the exception).

---

## Folder map

| Folder | What it is | Active build |
|---|---|---|
| **`1_Robotek_WeaponCraft/`** | Pristine archive. Original Direction A GDD (`01_GDD.md`) + early Gemini Direction B exemplar prototypes (HTML). **Do not modify** — kept as the canonical pre-prototype reference. | `Gemini_Weapon_Crafter_0.2.0.html` (frozen) |
| **`2_WeaponCraft_Base/`** | Turn-based casual-mobile RPG variant. The primary BASE-A1 build line. Robotek-cadence combat (1100ms ticks), discrete waves, forge between every wave. Active iteration target for the recipe/crafting loop. | `BASE-A1_0.1.10.html` (stable on `main`) · `BASE-A1_0.2.0.html` (gacha + synergies + factions on `feature/2_v0.2.0-gacha-synergies`) |
| **`2_Weaponcraft_Godot/`** | Ultra-MVP Godot 4 port — same design, native engine. Parallel exploration. Data-driven (.tres) parts/recipes/heroes for engine sanity. | `godot/project.godot` (open in Godot 4) |
| **`3_WeaponCraft_RealTime/`** | Continuous-stream defender variant (Wittle × Potion Craft × Brotato). Single lane, enemies march in, 1-tile-churn carousel shop, 3-minute stages. Shares assets + recipes with `2_`. | `REAL-TIME_0.1.0.html` |

---

## Shared assets

Each variant ships with its own copy of:
- `Mockup/WeaponCraft_mockup_v1.png` — AI-generated art-direction reference (Clash Royale × Wittle Defenders × Hearthstone polish, parchment + ornate-wood frame).
- `Prototype/dist/assets/heroes/` — three chibi hero sprites (Bran the Warrior 🛡️, Elara the Mage 🧙‍♀️, Vex the Rogue 🥷). PNG, 512×512 transparent-fallback. Generated via `nano-banana` / `nano-banana-pro` (Gemini Image).

The same 12-part starter catalogue + 8 named recipes + 3 cross-hero recipes (in `0.2.0`) live inside the HTML constants of each prototype — kept in sync by hand for now (no shared module yet).

---

## Quick start

### Browser variants
```bash
# Open any HTML file directly in Chrome/Edge/Firefox:
start 2_WeaponCraft_Base/Prototype/dist/BASE-A1_0.1.10.html
start 2_WeaponCraft_Base/Prototype/dist/BASE-A1_0.2.0.html
start 3_WeaponCraft_RealTime/Prototype/dist/REAL-TIME_0.1.0.html
```

No build step. No dependencies. Vertical-mobile portrait layout — resize the browser window to ~420 px wide for the intended look. Each file is self-contained HTML + CSS + JS.

### Godot variant
Open `2_Weaponcraft_Godot/Prototype/godot/project.godot` in Godot 4.3+.

---

## Core gameplay (Direction A — `2_`)

1. **3-piece weapon system** — Head + Hilt + Rune slots per hero. Each part contributes stats (ATK/HP/Crit/UltRate) + element/keyword tags (Fire/Ice/Pierce; derived Crit/Charge).
2. **TFT-style shop** — 5 random parts per wave, click to auto-equip to active hero. Reroll for 2 gold.
3. **Wittle-style merge** — duplicate part buys level up the existing copy (L1 → L5 cap, stat mult 1.0× → 3.7×).
4. **Recipe engine** — combos of tags across the 3 slots trigger named effects (Steamburst Fire+Ice, Inferno Fire+Fire, Permafrost Ice+Ice, Skewer Pierce+Pierce, Razor Wind Pierce+Crit, Hellfire Fire+Crit, Frostbite Ice+Pierce, Quickdraw Charge+Element). Multi-path: any matching pattern fires.
5. **Codex + discovery** — first-time recipe activation triggers a full-screen celebration overlay, then enters the codex.
6. **Cross-hero recipes** (0.2.0) — Volcano / Glacial Wind / Static Storm trigger when paired recipes are active across different heroes.
7. **Roster ramp** — Bran @ wave 1, Elara @ wave 3, Vex @ wave 5.
8. **Boss-retry-with-reforge** — wipe at any boss wave (mini-bosses w5/w10, final w15) opens a reforge modal; parts preserved, retry as many times as needed.
9. **Persistent ult bank** — gauge fills from damage dealt, persists across waves. Tap to fire once per fight.
10. **Gacha drafts** (0.2.0) — every 3rd cleared wave shows a 3-card draft (common 60% / uncommon 30% / rare 8% / mega 2%). Effects range from stat tweaks to game-changers (Pyromancer +50% Fire, Cryomancer +50% Ice, Divine Surge, Midas Touch).
11. **TFT-style faction stubs** (0.2.0) — each hero contributes 1-2 factions (Knight / Steel / Mystic / Frost / Shadow / Blade). Tier-1 bonuses apply now; tier-2/3 scaffolding ready for a 50+ hero roster.

---

## Branch model

```
main                              — stable 0.1.10 (UI shuffle + 15-wave curve)
└─ feature/2_v0.2.0-gacha-synergies  — adds gacha + S1 + S3 + factions
```

All `2_` 0.1.x snapshots (0.1.2 → 0.1.10) are kept as historical HTML files in the `dist/` folder, never deleted, since each represents a discrete playtestable state.

---

## Design docs

| Path | What |
|---|---|
| `1_Robotek_WeaponCraft/docs/01_GDD.md` | Original pre-prototype GDD (canonical Direction A) |
| `2_WeaponCraft_Base/docs/02_GDD.md` | Part I (original GDD) + Part II (build log of every 0.1.x decision) |
| `2_WeaponCraft_Base/docs/02_systems/merge_mechanic.md` | Cross-rarity vs level-up merge analysis + rationale |
| `2_WeaponCraft_Base/docs/superpowers/specs/` | BASE-A1 prototype spec + playtest handout |
| `3_WeaponCraft_RealTime/docs/03_GDD.md` | RealTime variant GDD (continuous stream + carousel shop + 3-min stages) |
| `2_Weaponcraft_Godot/docs/superpowers/specs/2026-05-23-godot-ultra-mvp-port-design.md` | Godot port architecture |

---

## Console instrumentation (browser variants)

Every gameplay action logs a JSON event to `console.log` with prefix `[A1-EVT]` (e.g. `forge_swap`, `shop_buy`, `recipe_discovered`, `cross_recipe_discovered`, `gacha_pick`, `wipe`, `boss_retry`, `session_end`). Open DevTools console (F12), play a stage, right-click the console → "Save as…" to capture full telemetry for playtest analysis.

---

## Cost policy

**Image-gen MCP**: default to `nano-banana` (Gemini 2.5 Flash, ~$0.04/image) only. `nano-banana-pro` (Gemini 3 Pro Image, ~$0.24/image) is forbidden unless the user explicitly names it per-call. Locked in user-global `~/.claude/CLAUDE.md`.
