# Handoff — Asset Replacement + Design Polish Session

**Date:** 2026-05-25
**Branch state at handoff:** merged + deleted (`feature/asset-replacement-cozy-vivid` → `main`)
**Tip commit:** see latest `git log main --oneline -1`
**Active prototype:** `Prototype/godot/scenes/Main.tscn` (Godot 4.6.2 Mono)

---

## What shipped this session

Three layers landed on top of the ultra-MVP playable build that already existed on `main`:

### 1. Replaced placeholder Kenney sprites with AI-generated cozy-parchment assets

Pipeline: `nano-banana(-pro)` → raw PNG/JPG → `rembg` U2-Net background removal → tight bbox crop → 6% padding → LANCZOS resize → PNG with alpha.

| Asset | Path | Dim | Model | Cost |
|---|---|---|---|---|
| Bran warrior | `assets/generated/heroes/bran_warrior.png` | 128² | nano-banana-pro | $0.14 |
| Slime | `assets/generated/enemies/slime.png` | 128² | nano-banana-pro | $0.14 |
| Goblin | `assets/generated/enemies/goblin.png` | 128² | nano-banana-pro | $0.14 |
| Skeleton | `assets/generated/enemies/skeleton.png` | 128² | nano-banana-pro | $0.14 |
| 5 part icons (h_iron_edge, p_steel_grip, p_pyro_pommel, r_fire, r_ice) | `assets/generated/parts/*.png` | 64² | nano-banana | $0.04 each |
| 3 VFX (merge_sparkle, fire_puff, ice_shard) | `assets/generated/vfx/*.png` | 96² | nano-banana | $0.04 each |

Total spend ≈ $0.86.

Rune icons (r_fire, r_ice) post-processed a second time to match head/hilt visible-subject density (~22% of canvas, down from 62%). Without that shrink they visually dominated the PartCard and shoved labels into the borders.

### 2. Authored `theme.tres` and applied a cozy-parchment palette

Three-stop parchment hierarchy: deep (`#bfa178`), mid (`#e8cd9a`), light (`#fbecca`). Brown ink borders. Emerald START WAVE buttons with gold border. Gold-on-dark coin badges. Dark wood (`#3a2516`) combat-log inset. Recipe purple `#6a3aa6`.

Theme applied to Main scene root → cascades to every Panel / Button / ProgressBar in the tree.

### 3. Design + polish iterations on the visible UI

In order of fix:

1. **Match enemy + hero sprite display sizes** — added `EXPAND_IGNORE_SIZE + STRETCH_KEEP_ASPECT_CENTERED` so the 128 px source textures don't blow out the arena bounds. Sprite render = 48 px enemy / 54 px hero / 58 px squad portrait.
2. **Combat-log readability** — wrapped RichTextLabel in a PanelContainer with dark wood StyleBoxFlat and cream `#f5e6c8` default text. Contrast climbed from ~2:1 to ~7:1.
3. **ShopHeader / RerollBtn overlap** — bumped VBox separation 4 → 8, set ShopHeader minimum height 44, anchored items to vertical midline.
4. **Recipe chip vertical-text bug** — autowrap on a Label inside an unconstrained HBox was collapsing to 1-char width. Switched ForgePanel chip to a name-only purple pill and moved the full description to a dedicated full-width Label below.
5. **Codex button visibility** — replaced the emoji glyph (didn't render in default font) with `CODEX X/Y` plain text on a purple StyleBoxFlat pill, 112×40, 14 pt.
6. **PartCard contrast pass** — tag chips converted from color-only labels to colored-pill PanelContainers (FG flipped to white on saturated bg). Stat labels recolored dark green. Cost label dark amber. Gold counter wrapped in a dark earth pill with gold text + border (coin-badge feel).
7. **PartCard content overflow** — diagnosed: VBox content stacked to ~109 px in a 92 px card → top SlotLabel + bottom CostLabel rendered outside the border. Fix: moved SlotLabel to a top-right corner pill, dropped the entire TagBox row (replaced by per-element card tint + ElementBadge), reverted card size to 78×108 with 40 px icon. `clip_contents = true` on PartCard as defense.
8. **Per-element card tints** — PartCard root PanelContainer dynamically applies one of three StyleBoxFlat variants in `_apply_element_style(tag)`:
   - normal → bronze `#e8c482`
   - fire → muted tan-bronze `#ab866a` (60% desat from initial orange)
   - ice → muted slate-blue `#68778a` (60% desat from initial blue)
   Text colors swap automatically per element (cream on dark fire/ice, dark earth on bronze).
9. **DiscoveryOverlay readability** — backdrop alpha 0.85 → 0.94. Added a centered Card PanelContainer with deep purple bg + lavender border + 22 px padding. Wired real recipe icons (`fire_puff` for Inferno, `ice_shard` for Steamburst). IconBox reserves 96 px height so the layout doesn't shift when a recipe has no icon.
10. **Z-index leak** — PartCard SlotBadge / ElementBadge / LevelBadge had `z_index = 4..5`, punching through the overlay sibling. Fix: dropped the z_index (tree order already handles within-card layering). Belt-and-suspenders: DiscoveryOverlay / CodexModal / ResultModal all set `z_index = 100` + `z_as_relative = false`.

All 17 TestCombat assertions remained green throughout (no formula changes, pure presentation).

---

## Current build state

- **Engine:** Godot 4.6.2 Mono (`C:/Godot_v4.6.2-stable_mono_win64/`)
- **MCP:** `coding-solo/godot-mcp` registered (env var `GODOT_PATH` set in `.claude.json`)
- **Window:** 420×800 portrait, Compatibility renderer
- **Scope still ultra-MVP:** 1 hero (Bran), 3 waves, 5 parts, 2 recipes (Steamburst, Inferno), no boss
- **Active mockup direction:** `Mockup/04_cozy_parchment_vivid.png` (nano-banana-pro, vivid chibi parchment)
- **Save logs:** `%APPDATA%/Godot/app_userdata/WeaponCraft Godot Ultra-MVP/logs/godot.log`
- **F12 in-game:** screenshots to same user dir

---

## What works end-to-end

1. Open project in Godot, F5 → Main scene runs 420×800
2. Wave 1 forge opens with 5 part cards, slot-coverage guaranteed
3. Buy parts → cards land in anvil (or inventory if slot occupied), level up on duplicate
4. Element-tinted PartCards (bronze / muted fire / muted ice) with corner badges (SLOT top-right, ELEMENT top-left)
5. Active recipe chips light up purple when fire+ice / fire+fire on weapon
6. First-discovery DiscoveryOverlay pauses combat, shows recipe icon + name + desc, click to dismiss
7. START WAVE → combat ticks at 1.1 s, damage pops, HP drains, ult gauge fills
8. Tap Whirlwind ult at 100% → screen flash + AoE
9. Wave clears → green banner "WAVE N CLEAR +🪙X" → next forge opens
10. Stage clear (wave 3) → gold modal, hero death → red modal, both restart cleanly
11. Codex button shows recipes (silhouette if undiscovered, full when found)

50/50 logic tests pass: 11 recipes + 7 shop + 15 merge + 17 combat.

---

## Open known issues / candidates for next session

| ID | Symptom | Suggested fix |
|---|---|---|
| K-1 | Combat log lines can pile up faster than the player reads them | Throttle to one log line per 0.6 s OR fade older lines |
| K-2 | Empty anvil slot still shows the EMPTY placeholder text in default Godot font | Replace with a slot-specific outline glyph + dashed border style |
| K-3 | `Pyro Pommel` name fits but `Steel Grip` cost coin renders without a badge | Wrap CostLabel in a small dark pill for the shop-mode cards |
| K-4 | Inferno stack-burn isn't communicated visually during combat | Spawn a small ember sprite on the target when burn stack ticks up |
| K-5 | All five PartCard colors share the same bronze border on hover | Tint border on hover by element accent |
| K-6 | Reset modal restart resets `discovered_recipes` — codex feels punishing | Decide: keep per-stage codex (current) vs persistent across runs |

---

## Phase 2 candidates (in plan-priority order)

Already enumerated in `docs/superpowers/specs/2026-05-23-godot-ultra-mvp-port-design.md`. Top picks:

1. **3-hero roster** — Elara (Mage / Meteor) + Vex (Rogue / Shadowstep), unlock at waves 3 + 5. SquadBar → 3 cards, ForgePanel hero tabs.
2. **Boss wave + retry** — wave 6 boss with affinity telegraph, `Reforge & Retry` modal.
3. **Full 11-part catalog** — add the missing 6 parts so all 8 recipes are reachable in one stage.
4. **All 8 recipes** — combat already supports all bonus keys; just author 6 more `.tres` files (Permafrost, Skewer, Razor Wind, Hellfire, Frostbite, Quickdraw).
5. **Blender 3D-in-2D hero swap** — replace Bran's Tiny-Dungeon-styled chibi with a `glb` rendered in a SubViewport.
6. **Sound** — hit / ult / click SFX from freesound / Kenney audio.
7. **Mobile export pass** — Android export template, real device test.

---

## Where things live

```
2_Weaponcraft_Godot/
├── Mockup/
│   ├── 04_cozy_parchment_vivid.png      <-- locked design direction
│   └── _lower_band_72_95.png            (sanity strip)
├── Prototype/godot/
│   ├── project.godot                    Godot 4.6.2 Mono config
│   ├── theme.tres                       project-wide cozy parchment theme
│   ├── icon.svg
│   ├── .gitignore                       (.godot/ ignored, *.import TRACKED)
│   ├── assets/
│   │   ├── kenney/                      placeholder packs (no longer referenced by .tres)
│   │   └── generated/
│   │       ├── heroes/bran_warrior.png
│   │       ├── enemies/{slime,goblin,skeleton}.png
│   │       ├── parts/{h_iron_edge,p_steel_grip,p_pyro_pommel,r_fire,r_ice}.png
│   │       ├── vfx/{merge_sparkle,fire_puff,ice_shard}.png
│   │       └── parts_cutout/baseline_*.png   (mockup strip crops)
│   ├── data/                            Resource (.tres) catalog
│   │   ├── heroes/bran.tres
│   │   ├── enemies/{slime,goblin,skeleton}.tres
│   │   ├── parts/{h_iron_edge,p_steel_grip,p_pyro_pommel,r_fire,r_ice}.tres
│   │   └── recipes/{steamburst,inferno}.tres
│   ├── scenes/
│   │   ├── Main.tscn                    root, mounts everything
│   │   ├── Hud.tscn, BattleView.tscn, SquadBar.tscn
│   │   ├── ForgePanel.tscn, PartCard.tscn
│   │   ├── CodexModal.tscn, DiscoveryOverlay.tscn, ResultModal.tscn
│   │   ├── Notifications.tscn
│   │   └── dev/
│   │       ├── TestRecipes.tscn   (11/11 pass)
│   │       ├── TestShop.tscn      (7/7 pass)
│   │       ├── TestMerge.tscn     (15/15 pass)
│   │       ├── TestCombat.tscn    (17/17 pass)
│   │       └── TilePicker.tscn    (dev tool, assigns Kenney sprites)
│   ├── scripts/
│   │   ├── core/                  game_state, combat, shop, merge, recipes, rng, screenshot_helper
│   │   ├── data/                  part_data, hero_data, enemy_data, recipe_data, inventory_item, weapon, hero_state
│   │   ├── dev/                   tile_picker, test_*
│   │   └── ui/                    main, hud, battle_view, squad_bar, forge_panel, part_card,
│   │                              codex_modal, discovery_overlay, result_modal,
│   │                              notifications, screen_flash
└── docs/
    ├── 01_GDD.md, 01b_GDD_addendum_BASE-A1.md, 05_roadmap.md   (carried over from BASE folder)
    ├── handoffs/2026-05-25-asset-replacement-session.md       <-- THIS FILE
    └── superpowers/specs/
        └── 2026-05-23-godot-ultra-mvp-port-design.md
```

---

## How to resume

1. Pull `main`:
   ```bash
   git checkout main
   git pull
   ```
2. Open project: `Godot_v4.6.2-stable_mono_win64.exe` → import → `2_Weaponcraft_Godot/Prototype/godot/project.godot`
3. F5 to verify the build still runs at branch-tip state
4. Re-run all 4 dev test scenes (right-click → Play Scene): expect 50/50 PASS
5. Pick a Phase 2 candidate from the list above OR a polish K-N from the open-issues table
6. Branch convention: `feature/<short-name>` off `main`. Commit per atomic change. Merge + delete branch on completion.

---

## Cost summary (this branch only)

| Spend | What |
|---|---|
| ~$0.86 | Asset generation batch (4 chars on pro, 5 parts + 3 VFX on cheap) |
| ~$0.55 | Earlier session's mockup #4 (nano-banana-pro) |
| ~$0.12 | 3-mockup brainstorm batch (nano-banana) |
| Total visible to this project | ~$1.53 |

No re-rolls were needed for the asset batch — `rembg` carried the visual fails (parchment-card backgrounds, baked-in text on Pyro Pommel) so the first-pass output was usable end-to-end.

---

End of handoff. Have a good break.
