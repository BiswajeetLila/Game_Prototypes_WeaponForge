# WeaponCraft — Godot Ultra-MVP Port Plan (revised)

## Context

WeaponCraft is a vertical-mobile auto-battler. Canonical pre-prototype design lives in `2_WeaponCraft_Base/docs/01_GDD.md`. The **active prototype** (BASE-A1 lineage, currently `Prototype/dist/BASE-A1_0.1.9.html`) has iterated heavily — the design log and locked decisions live in `docs/01b_GDD_addendum_BASE-A1.md`, which is the authoritative source for what the game actually is right now. The live-ops roadmap is `docs/05_roadmap.md`.

Key locks from the addendum:
- **Turn-based combat via 1.1s ticks** (not real-time; "Start Wave" pauses combat between waves)
- **Recipe Engine + Codex + First-Discovery Moment** is THE core hook ("Crafting Juice pivot" at 0.1.7)
- **Part-level merge (L1→L5, `[1.00, 1.50, 2.10, 2.85, 3.70]×`, same-rarity-only)** — replaces the old "3→1 stash promotion"
- **Persistent ult gauge** (carries across waves; only `ultUsed` resets)
- **All enemies have weak/resist affinities** (not just bosses)
- **Derived tags** (`crit` from any crit%, `charge` from any ultRate%) visible alongside explicit tags (`fire/ice/pierce`)
- **Active-hero priority** for buy/equip/merge
- **Slot-coverage guarantee** while any unlocked hero is not fully kitted

This plan ports a **minimal slice** of that loop into Godot 4.4, driven by the Coding-Solo godot-mcp server. Goal is not feature parity. Goal is to **prove the Godot + MCP + Kenney-art pipeline is viable for THIS specific game**, including the new core hook (merge + recipe discovery), before scaling up. If pipeline holds, Phase 2 expands to full 0.1.9 parity (3 heroes, 5 waves+boss, 11 parts, all 8 recipes, retry).

Output folder: `2_Weaponcraft_Godot/` (already cloned from base; original folder untouched).

---

## Locked decisions

| Decision | Choice |
|---|---|
| Engine | Godot 4.4 stable, Compatibility renderer |
| MCP server | Coding-Solo `godot-mcp` (free, stdio, no editor required) |
| Art | Kenney.nl CC0 sprite packs (everything — heroes, enemies, parts, UI) |
| Blender 3D pipeline | Deferred to Phase 2 |
| Audio | Deferred to Phase 2 (silent ultra-MVP) |
| Authoritative spec | `01_GDD.md` + `01b_GDD_addendum_BASE-A1.md` + `05_roadmap.md`. Prototype `BASE-A1_0.1.9.html` is reference implementation. |
| Target window | Desktop 420×800 portrait (mimics mobile vertical) |
| Determinism | Godot `randi()` direct (matches prototype's `Math.random()`) |

### Ultra-MVP scope (expanded to validate the NEW core hook)

**Hero (1):** Bran — Warrior — `hp: 80`, `baseAtk: 6`, ult `Whirlwind` (AoE all alive enemies, dmg = `floor(atk * 3.5)`).

**Parts catalog (5)** — chosen so both target recipes are reachable AND merge is testable:
1. `h_iron_edge` — head, warrior, atk +8, cost 3, common, tag: —
2. `p_steel_grip` — hilt, warrior, atk +4, cost 3, common, tag: —
3. `p_pyro_pommel` — hilt, universal, atk +2, cost 4, common, tag: **fire**
4. `r_fire` — rune, universal, atk +3, cost 3, common, tag: **fire**
5. `r_ice` — rune, universal, atk +3, cost 3, common, tag: **ice**

Reachable combos on Bran's 3-slot weapon:
- `p_pyro_pommel` + `r_fire` → tag counts `{fire:2}` → **Inferno** triggers
- `p_pyro_pommel` + `r_ice` → tag counts `{fire:1, ice:1}` → **Steamburst** triggers
- Buying duplicate `h_iron_edge`, `r_fire`, or `r_ice` levels existing copy up → **merge** testable

**Recipes (2 from the 8-recipe catalogue):**
| Recipe | Pattern | Effect |
|---|---|---|
| **Steamburst** | `[fire, ice]` | 35% splash to all other alive enemies on hit |
| **Inferno** | `[fire, fire]` | Consecutive same-target hits stack +12% damage, cap 3 stacks (+36%) |

Codex: `📜 Codex` button shows 2 recipes as silhouettes; on first trigger of either, full-screen first-discovery overlay pauses battle (per addendum 0.1.7 spec).

**Merge mechanic (per `docs/02_systems/merge_mechanic.md`):**
- Every owned part has `level` (default 1, cap **L5**).
- Acquire (buy/reward) duplicate `partId` of same rarity → level up existing copy by +1; do NOT spawn a new L1.
- Stat scaling per level: `[1.00, 1.50, 2.10, 2.85, 3.70]×` applied to `atk / hp / crit / ultRate` simultaneously. Tag unchanged.
- VFX: ✨ "MERGED! L(n+1)" gold pop on affected card.

**Acquire flow priority (per addendum 0.1.6):**
1. Merge into active hero's equipped duplicate
2. Equip into active hero's empty slot
3. Merge into inventory duplicate
4. Fresh L1 to inventory
(other-hero steps from 0.1.6 omitted — only 1 hero in ultra-MVP)

**Waves (3 normal, no boss):** Enemies = random from Slime/Goblin/Skeleton. Spawn 2–3 per wave. HP = `15 + wave * 8`. Damage/tick = `4 + floor(wave * 1.4)`. Each enemy assigned random `weak` (always) + random `resist` (70% chance) from `{fire, ice, pierce}` per addendum 0.1.5. Element multipliers: weak `× 1.8`, resist `× 0.5`.

**Forge shop:** 5 parts per refresh; reroll cost 2🪙. Slot-coverage guarantee while Bran is not fully kitted (must include ≥1 head, ≥1 hilt, ≥1 rune).

**Combat tick (per 0.1.2 baseline, unchanged through 0.1.9):**
- `TICK_MS = 1100`. One `Timer` autostart=false at 1.1s.
- Per tick: Bran attacks random alive enemy; all alive enemies attack Bran; ult gauge fills.
- Damage formula:
  ```
  dmg = atk
  if rand*100 < crit: dmg = floor(dmg * 1.6)
  for tag in weapon_tags:
      if tag == enemy.weak:   dmg *= 1.8
      if tag == enemy.resist: dmg *= 0.5
  dmg = floor(dmg)
  ```
- Ult gauge fill per attack: `6 + floor(dmg * 0.2) + (ultRate / 4)`, capped at 100. Hard time-cap 30s forces fill to 100.
- **Persistent ult gauge**: gauge carries across waves; only `ultUsed` flag resets per fight.

**Recipe bonus application (in tick):**
- Recompute active recipes after each weapon change (`getActiveRecipes(weapon)`).
- Steamburst: after primary hit, deal `floor(dmg * 0.35)` to every other alive enemy.
- Inferno: track `hero._lastTargetName` + `hero._burnStack`. Same target → `_burnStack = min(3, _burnStack + 1)`. Dmg multiplier `1 + 0.12 * _burnStack`. Switching target resets `_burnStack = 0`.

**Discovery hook:** after every equip/unequip AND every successful recipe trigger, call `checkHeroForDiscoveries(hero)`. If a recipe in `getActiveRecipes(hero.weapon)` is not in `GameState.discoveredRecipes`, push to `pendingDiscoveries` queue and trigger first-discovery overlay (pauses combat Timer).

**Win/lose:** clear 3 waves → "Stage Clear" modal. Bran dies → "Wipe" modal. Both return to wave 1 with fresh forge + reset codex discoveries (codex is per-stage per spec).

---

## Pipeline & software setup (one-time)

1. **Install Godot 4.4 stable** (Windows 64-bit, standard build, not .NET): download from godotengine.org, unzip `Godot_v4.4-stable_win64.exe` to e.g. `C:\Tools\Godot\`.
2. **Install Node.js 18+** if absent (`node -v` to verify).
3. **Register godot-mcp with Claude Code:**
   ```bash
   claude mcp add godot -- npx @coding-solo/godot-mcp
   ```
   Set `GODOT_PATH` env var to the Godot **executable** (`C:/Tools/Godot/Godot_v4.4-stable_win64.exe`). Use forward slashes in JSON to avoid Windows escape issues.
4. **Verify MCP** with sanity call (`mcp__godot__launch_editor` on a throwaway project).
5. **Download Kenney asset packs** (CC0): `Tiny Dungeon` (heroes + enemies), `UI Pack RPG Expansion` (panels, buttons, frames), `Generic Items` / `Weapon Pack` (part icons). Unzip into `2_Weaponcraft_Godot/Prototype/godot/assets/kenney/`.
6. **GDScript screenshot helper** — single 6-line autoload script saves `user://shot_<ts>.png` on F12 (closes visual-feedback gap vs Coding-Solo MCP not having auto-screenshot).

---

## Godot project structure

Create new Godot project at `2_Weaponcraft_Godot/Prototype/godot/`:

```
godot/
├── project.godot                  # window 420x800 portrait, Compatibility renderer
├── assets/
│   ├── kenney/                    # raw Kenney PNGs
│   └── icons/                     # game-specific exports / atlases
├── data/                          # Resource (.tres) files = pure data
│   ├── parts/                     # 5x PartData.tres
│   ├── heroes/                    # 1x HeroData.tres (Bran)
│   ├── enemies/                   # 3x EnemyData.tres (Slime/Goblin/Skeleton)
│   └── recipes/                   # 2x RecipeData.tres (Steamburst/Inferno)
├── scripts/
│   ├── data/
│   │   ├── part_data.gd           # Resource: slot, cls, atk, crit, hp, ult_rate, tag, cost, rarity, desc
│   │   ├── hero_data.gd           # Resource: name, cls, hp_base, atk_base, ult_name
│   │   ├── enemy_data.gd          # Resource: name, hp_base, hp_per_wave, dmg_base, sprite
│   │   ├── recipe_data.gd         # Resource: id, name, patterns (Array of tag arrays), bonus dict, icon, desc
│   │   ├── inventory_item.gd      # plain class: {uid, part_id, level}
│   │   ├── weapon.gd              # plain class: head/hilt/rune InventoryItems + aggregator methods
│   │   └── hero_state.gd          # runtime hero: hp, max_hp, ult_gauge, ult_used, weapon, _last_target, _burn_stack
│   ├── core/
│   │   ├── game_state.gd          # Autoload: wave, gold, hero_state, shop, inventory, discovered_recipes, pending_discoveries
│   │   ├── combat.gd              # Tick loop, dmg formula, ult fill, recipe bonus application, win/lose detection
│   │   ├── shop.gd                # Roll, reroll, eligibility, slot-coverage guarantee, buy
│   │   ├── merge.gd               # Acquire flow priority (per 0.1.6), level-up, level multiplier lookup
│   │   ├── recipes.gd             # weapon_tag_counts(), pattern_matches(), get_active_recipes(), get_recipe_bonuses(), check_hero_for_discoveries()
│   │   └── rng.gd                 # Thin wrapper over randi/randf (future-seedable)
│   └── ui/
│       ├── hud.gd                 # Gold + wave + 📜 Codex button (X/2 badge)
│       ├── battle_view.gd         # Hero sprite + enemy row + HP bars + combat log + element-colored damage pops + recipe banner
│       ├── squad_bar.gd           # Bran portrait + HP bar + persistent ult gauge + tap-to-ult + aura ring
│       ├── forge_panel.gd         # Anvil (3 slots, level badges, active recipe chips) + shop grid (5) + inventory strip + reroll btn
│       ├── shop_part.gd           # Single part card (slot label, all tag badges incl derived, level badge if inventory dup, tooltip)
│       ├── codex_modal.gd         # Lists 2 recipes; silhouette if undiscovered, full detail if discovered
│       ├── discovery_overlay.gd   # First-discovery pause card; click to dismiss + resume Timer
│       └── result_modal.gd        # Wipe / Stage Clear modal
└── scenes/
    ├── Main.tscn                  # Root, mounts HUD + BattleView + SquadBar + ForgePanel + modals
    ├── BattleView.tscn
    ├── SquadBar.tscn
    ├── ForgePanel.tscn
    ├── ShopPart.tscn
    ├── CodexModal.tscn
    ├── DiscoveryOverlay.tscn
    └── ResultModal.tscn
```

### Critical files (the few that carry actual logic)

- `scripts/core/combat.gd` — tick loop. Mirrors prototype's `battleStep()`. Single `Timer` at 1.1s. Pauses on first-discovery overlay. Owns 30s hard-cap timer. Emits `wave_cleared` / `hero_died`.
- `scripts/core/recipes.gd` — `weapon_tag_counts`, `pattern_matches`, `get_active_recipes`, `get_recipe_bonuses`, `check_hero_for_discoveries`. Pure functions; no state. The recipe-engine heart.
- `scripts/core/merge.gd` — `acquire_part(part_id, rarity)` runs the 4-step priority; `level_multiplier(level) -> float`. Same-rarity-only enforcement here.
- `scripts/core/shop.gd` — `refresh()` w/ eligibility + slot-coverage guarantee while not fully kitted.
- `scripts/data/weapon.gd` — aggregator: `get_atk() / get_crit() / get_hp_bonus() / get_ult_rate() / get_explicit_tags() / get_all_tags()` (explicit + derived). Applies level multipliers per slot. One source of truth for weapon math.
- `scripts/core/game_state.gd` — singleton autoload holding `wave`, `gold`, `hero_state`, `shop_parts[]`, `inventory[]`, `discovered_recipes: Set`, `pending_discoveries: Array`, `combat_log[]`. UI panels read; combat + shop + merge write.

### Data flow

```
ShopPart click ──► Merge.acquire_part() ──► (level up OR new L1) ──► GameState ──► ForgePanel.refresh()
ForgePanel ──reroll(2g)──► Shop.refresh() ──► GameState.shop_parts ──► ForgePanel.refresh()
ForgePanel equip/unequip ──► Weapon mutate ──► Recipes.check_hero_for_discoveries() ──► (queue overlay if new) ──► HUD codex badge updates
[Start Wave] ──► Combat.start(wave) ──tick (1.1s)──► dmg formula ──► Recipes.get_recipe_bonuses() applied ──► HP mutate ──► BattleView pops + log
Combat ──recipe triggered──► Recipes.check_hero_for_discoveries() ──► DiscoveryOverlay (pauses Timer)
Combat ──ult_ready (gauge=100)──► SquadBar glow ──tap──► Combat.fire_ult() ──► AoE dmg
Combat ──wave_cleared──► gold += 5 + wave * 2 ──► next wave OR Stage Clear modal
Combat ──hero_died────► Wipe modal
```

All panels are small scenes with their own scripts. The only cross-cutting state is the `GameState` autoload — keeps files focused and units independently testable.

---

## MCP-driven build order (one execution session)

Each step independently verifiable. Commit after each green step.

1. **Init project** via MCP — `create_scene Main.tscn`, configure `project.godot` (window 420×800 portrait, Compatibility renderer, autoload `game_state.gd`, autoload `screenshot_helper.gd`).
2. **Stub Resource scripts** — `part_data.gd`, `hero_data.gd`, `enemy_data.gd`, `recipe_data.gd`, `inventory_item.gd`, `weapon.gd`, `hero_state.gd`. No game logic yet.
3. **Populate `.tres` data files** — 5 parts, 1 hero, 3 enemies, 2 recipes with stats/patterns from spec above.
4. **Drop Kenney sprites** into `assets/kenney/`. Wire `.tres` icon refs (Bran portrait, enemy portraits, part icons, UI 9-patch frames).
5. **Build BattleView scene** — hero sprite placeholder, enemy row, HP bars (`TextureProgressBar`), combat log. No logic.
6. **Build ForgePanel scene + ShopPart scene** — anvil (3 slot drop zones with level badges + active recipe chips area), shop grid (5 part cards with slot label + multi-tag badges + tooltip), inventory strip, reroll button.
7. **Implement `shop.gd`** — `refresh()` w/ eligibility + slot-coverage-while-not-kitted. Wire to reroll button. Verify wave-1 always returns ≥1 head, hilt, rune.
8. **Implement `merge.gd`** — `acquire_part()` 4-step priority. Level-up path increments existing item's `level`. Same-rarity-only guard. VFX hook stubbed (just gold border flash for ultra-MVP; full sparkle particles Phase 2).
9. **Implement `recipes.gd`** — pure functions. Unit-test in `_ready()` of a throwaway scene: confirm `r_fire + r_ice` returns `[steamburst]`; `p_pyro_pommel + r_fire` returns `[inferno]`.
10. **Implement weapon equip/unequip** — click shop part → Merge.acquire_part. Click inventory item → equip to anvil. Click anvil slot → unequip to inventory. After every mutation, call `recipes.check_hero_for_discoveries()` and update HUD codex badge.
11. **Implement `combat.gd`** — `Timer` 1.1s. Damage formula with element multipliers. Apply recipe bonuses (Steamburst splash, Inferno stack burn). Persistent ult gauge fill. Hard time-cap 30s. Emit signals. First-discovery triggered mid-tick pauses Timer.
12. **Wire SquadBar** — Bran portrait, HP bar, persistent ult gauge bar, tap-to-fire-ult button (greyed until gauge=100), aura ring (CSS-equivalent: `Sprite2D` with shader or simple modulated outline texture).
13. **Wire codex + discovery overlay** — `HUD` 📜 button opens `CodexModal`. `DiscoveryOverlay` pauses combat Timer, plays scale-pop tween, click-anywhere dismisses + resumes Timer.
14. **Wave progression** — clear wave → award `5 + wave * 2` gold → re-open forge → Start Wave button (in deployment-zone, always in viewport per addendum 0.1.8). After wave 3, Stage Clear modal.
15. **Wipe state** — Bran dies → Wipe modal → restart wave 1, reset `discovered_recipes` and `pending_discoveries`.
16. **Manual playthrough** via MCP `run_project` + `get_debug_output`. Take screenshot via F12 helper at every key state. Iterate.

---

## Verification

End-to-end manual test (after step 16):

1. **Launch** via `mcp__godot__run_project` on `2_Weaponcraft_Godot/Prototype/godot/`. Window opens 420×800 portrait.
2. **Wave 1 forge** opens with 5 parts, slot-coverage holds (≥1 head, ≥1 hilt, ≥1 rune among the 5). HUD shows gold=20, wave 1/3, codex badge `0/2`.
3. **Buy `h_iron_edge`** — Bran's anvil head slot fills. ATK display `6 + 8 = 14`.
4. **Buy `p_pyro_pommel`** — hilt slot fills with fire-tag indicator. Recipe chips area still empty (only 1 fire tag).
5. **Buy `r_ice`** — rune slot fills. Recipe chips area lights up showing "💨 Steamburst". **First-discovery overlay fires**, Timer paused, "STEAMBURST DISCOVERED" headline. Click → dismiss → forge resumes. Codex badge `1/2`.
6. **Open Codex** via HUD button → 2 entries, Steamburst full-color, Inferno silhouette.
7. **Reroll** (cost 2g, gold drops to 12). Shop refreshes; now non-guaranteed because Bran is fully kitted.
8. **Buy duplicate `h_iron_edge`** (if it rolls) → merges, h_iron_edge becomes L2. Anvil ATK recalcs `8 * 1.5 = 12` (head atk contribution) → total `6 + 12 + 2 + 0 = 20`. Gold pop "MERGED! L2".
9. **Start Wave** — enemies appear (2–3), each with weak/resist row visible. 1.1s tick cadence visible. Damage pops are orange (fire-tagged hits) and may include weak (★) or resist (~) prefix. Hero HP drops. Ult gauge fills.
10. **Tap ult portrait** when gauge=100 → all enemies take `floor(atk * 3.5)` dmg, purple ult pops. Wave clears.
11. **Gold +7** awarded (5 + 1*2). Forge re-opens for wave 2. Ult gauge **persists** (does not reset to 0); `ult_used` resets.
12. **Build Inferno path**: swap to `p_pyro_pommel` + `r_fire` → recipe chip shows "🔥 Inferno", second first-discovery overlay fires, codex badge `2/2`.
13. **Wave 2 + 3** play through. Stage Clear modal. "Restart" resets wave 1 + clears `discovered_recipes`.
14. **Wipe path** — strip Bran's weapon, start wave 1, let him die → Wipe modal.
15. **Debug output** via `get_debug_output` — no GDScript errors during a full clear or full wipe.
16. **Screenshot check** via F12 helper at: forge populated / mid-combat / discovery overlay / codex open / stage clear modal. Confirm visual matches expected layout.

Pass criteria: all 16 steps green. Failure on any = pipeline/spec gap to address before Phase 2 scale-up.

---

## What this plan deliberately omits (Phase 2+)

- Heroes 2 & 3 (Elara/Mage, Vex/Rogue) + their ults (Meteor, Shadowstep) + roster unlock ramp (w3/w5).
- The other 6 parts to reach the 11-part 0.1.9 catalogue.
- Boss wave (wave 6) + boss affinity telegraph + boss-retry-with-reforge.
- The other 6 recipes (Permafrost, Skewer, Razor Wind, Hellfire, Frostbite, Quickdraw).
- Wittle-style merge VFX (sparkle particles, full level-badge animations L2/L3/L4/L5 color tiers).
- Element-streak between-entity overlays + persistent aura ring polish.
- Combat log narration with full recipe-name strings.
- Sound + animations.
- Blender 3D-in-2D hero render swap.
- Recipe Engine cluster 4/5 (codex state machine, recipe families, mastery tiers, scrolls).
- Persistent meta layer (gacha / BP / AFK idle / stamina / chapter map).
- Android/iOS export.

YAGNI; ship the pipeline + core-hook proof first.
