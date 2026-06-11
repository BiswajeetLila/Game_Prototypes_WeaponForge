# Handoff — Forge UX + Balance Bundle (pre-Stage-E)

**Date:** 2026-05-26
**Branch:** `weaponcraft-godot/forge-ux-balance-w10` (8 commits, not yet merged)
**Tip:** `30de9ea` — `feat(shop) healing potion consumable every 3 waves`
**Previous handoff:** [2026-05-25-stage-c-juice-hardening-cap-fix.md](2026-05-25-stage-c-juice-hardening-cap-fix.md)
**Active prototype:** `Prototype/godot/scenes/Main.tscn` (Godot 4.6.2 Mono)

---

## What shipped this session

Eight atomic commits on a single feature branch addressing two user-reported
blockers before Stage E (Audio): forge UX confusion + anti-player balance.
All commits ended with the suite green; final state **112/112** (was 71/71).

### 1. RED tests + Main unlock constants (`8e494ab`)

TDD scaffolding for the entire bundle. Adds 41 new test cases across:
- `scripts/dev/test_ui.gd` + `scenes/dev/TestUi.tscn` (NEW) — slot labels +
  tier rim assertions.
- `scripts/dev/test_shop.gd` — 18 potion cases.
- `scripts/dev/test_merge.gd` — L2-L5 new curve + Weapon↔Merge mirror lock.
- `scripts/dev/test_combat.gd` — TOTAL_WAVES, hero HP, cost defaults,
  unlock-wave constants.

Also extracts `ELARA_UNLOCK_WAVE` / `VEX_UNLOCK_WAVE` constants in
`main.gd` at CURRENT values (2, 4) so the unlock-wave tests compile and
fail for the right reason (constants exist but hold wrong values).

### 2. Slot labels under anvil cards (`f112fda`)

User report: "people don't understand you can get 1 of each only." Adds an
`AnvilLabels` HBoxContainer between `AnvilRow` and `RecipeChips` in
`ForgePanel.tscn` with three Label nodes — `Head` / `Hilt` / `Rune` —
font_size 10, centered, purple matching `RecipeDesc`. Each label takes 1/3
of the row width via `size_flags_horizontal=3` so they align under the
3 PartCards. Always visible; no script change.

### 3. Tier rim by level + L5 rainbow tween (`e66a9c6`)

User report: "each upgraded level of items need to look cooler than the
earlier level." Adds tier-rim visual progression on PartCard. Border
overrides the former per-element border (bg stays element-driven, border
becomes tier-driven). Mapping:

| Level | Rim color | Width |
|---|---|---|
| L1 | bronze `(0.420, 0.255, 0.137)` | 2 |
| L2 | silver `(0.753, 0.753, 0.753)` | 2 |
| L3 | gold `(0.949, 0.722, 0.133)` | 3 |
| L4 | platinum `(0.898, 0.890, 0.890)` | 3 |
| L5 | animated rainbow loop | 4 |

L5 spawns a looping `Tween` over 6 hue stops (red→orange→yellow→green→blue
→purple) at 0.33 s per segment. Tween reference stashed in `_rim_tween`,
killed at top of every `_apply_element_style` AND in `_exit_tree` to
prevent stranded tweens accumulating across shop / anvil rebuilds.

### 4. TOTAL_WAVES 5 → 10 + hero HP bumps (`b4fc885`)

User report: "balance of the game is too anti-player, need to survive and
have fun till wave 10-15 atleast."

- `TOTAL_WAVES`: 5 → 10 (`scripts/core/game_state.gd:66`)
- Bran `hp_base`: 80 → 120 (+50 %)
- Elara `hp_base`: 60 → 90 (+50 %)
- Vex `hp_base`: 65 → 75 (+15 %, smallest — fragile rogue identity)

Enemy ATK curve unchanged this commit; bumps stretch the run alone.
Re-evaluate ENEMY_DMG_PER_WAVE in playtest if late waves trivialise.

### 5. Slow LEVEL_MULT curve (`aab50e7`)

User report: "recipe and hero power getting is too easy." Replaces
`[1.00, 1.50, 2.10, 2.85, 3.70]` with **`[1.00, 1.35, 1.80, 2.30, 2.75]`**
(~26 % cut at L5). L1 unchanged at 1.00 so existing combat damage
assertions stay valid. Edited in lockstep in `scripts/core/merge.gd:36`
AND `scripts/data/weapon.gd:15`; new `_test_weapon_level_mult_mirrors_merge`
locks against future drift.

### 6. PartData cost default 3 → 4 + r_pierce explicit (`edaf003`)

`scripts/data/part_data.gd:28` flips the default. Three parts inherit:
`h_iron_edge`, `p_steel_grip`, `r_pierce` (the latter had explicit
`cost = 3` and got bumped in lockstep). STARTING_GOLD stays at 20 →
5 first-shop buys instead of 6 (intentional slow-down per the
anti-power direction).

### 7. Retime hero unlocks Elara W3, Vex W6 (`4ce6788`)

`ELARA_UNLOCK_WAVE` 2 → 3, `VEX_UNLOCK_WAVE` 4 → 6. Match block in
`_on_wave_cleared` refactored to reference the constants directly
(Godot 4 `match` supports constant cases) so the constants are the
single source of truth. Spreads learning across the W1-10 run:
- W1-3: solo Bran (was W1-2)
- W4-6: dual Bran + Elara (was W3-4)
- W7-10: full trio (was W5+)

### 8. Heal potion consumable (`30de9ea`)

User report: "add a healing potion that pops up in the shop every X turns,
my chars die otherwise."

Architecture — Option A: `is_consumable: bool` flag on PartData, single
short-circuit in `Shop.buy`. Future consumables share the same code path.

- `PartData` schema: `@export var is_consumable: bool = false`.
- `data/parts/c_heal_potion.tres` (NEW): slot=`&"consumable"` sentinel,
  cost=5, is_consumable=true. Icon placeholder via `merge_sparkle.png`.
- `Shop.gd`:
  - `POTION_PART_ID` + `POTION_HEAL_FRACTION = 0.5` consts.
  - `_is_potion_wave()` → `(wave - 1) % 3 == 0` (true on W1, W4, W7, W10).
  - `_eligible_part_ids()` filters out consumables.
  - `_roll_shop()` injects `POTION_PART_ID` into slot 4 (last) after the
    slot-coverage guarantee runs. Preserves head/hilt/rune in slots 0-2.
  - `buy()` short-circuits on `def.is_consumable` → spend gold →
    `_consume_potion(def)` → null slot → emit `shop_changed`.
  - `_consume_potion()` iterates `active_heroes()`, heals
    `floor(max_hp * 0.5)` clamped to `max_hp`, emits `hero_hp_changed`.
    Dead heroes skipped via `active_heroes()` filter.
- `PartCard.gd`: detects `def.is_consumable` in `_refresh()`, overlays
  parchment-green StyleBoxFlat (`POTION_BG` / `POTION_BORDER`) on top of
  the element styling pass. Tier rim skipped (potions never level).
  Element badge hidden.

---

## Current build state

- **Engine:** Godot 4.6.2 Mono. Window: 420 × 800 portrait, Compatibility renderer.
- **Heroes:** Bran (W1) / Elara (**W3** unlock) / Vex (**W6** unlock).
- **Waves:** **10** (was 5; bosses still deferred to Stage D).
- **Parts catalog:** 11 + 1 consumable.
- **Recipes:** 8 (unchanged).
- **Hero HP base:** Bran 120 / Elara 90 / Vex 75.
- **LEVEL_MULT:** `[1.00, 1.35, 1.80, 2.30, 2.75]` (canonical in `merge.gd`, mirror in `weapon.gd`).
- **PartData default cost:** 4.
- **STARTING_GOLD:** 20 (unchanged).
- **Heal potion:** shop slot 4 on W1 / W4 / W7 / W10, cost 5 g, heals all alive 50 % max_hp.
- **Autoloads (in order):** GameState, ScreenshotHelper, RNG, Recipes, Merge, Shop, Combat, ScreenShake, HitPause, Heartbeat, SignalTrace.
- **Test suite:** **112/112 GREEN** — TestCombat 41 + TestRecipes 18 + TestShop 26 + TestMerge 19 + TestUi 8.
- **TestStress:** 5 waves × 10 ticks, heap growth ~30 KB across full run, 550 ms (no regression).

---

## Open known issues / Phase 2 candidates

| Item | Notes |
|---|---|
| Potion icon placeholder | `merge_sparkle.png` reused. Bespoke nano-banana sprite is a follow-up if visual identity feels weak in playtest. |
| Wave 1-3 may feel too easy | Hero HP +50 % vs enemy ATK unchanged. If trivial, bump `ENEMY_DMG_PER_WAVE` 1.4 → 1.5 or apply a per-wave HP multiplier per the Stage D balance sheet. |
| Potion auto-heal vs full HP | Buying potion at full HP still spends 5 g for no effect. Acceptable as-is (player choice). Could add a no-op guard if reported. |
| `.uid` files untracked | Many `.gd.uid` files generated by Godot 4 reimport pass remain untracked across the worktree. Out of scope this bundle; future cleanup commit. |

Stage E (Audio), Stage A (Juice PR2), Stage D (boss waves + 15-wave bump),
and Stage F (ult balance) all stay queued per the roadmap in
`C:\Users\Biswa\.claude\plans\snug-jumping-sparrow.md`.

---

## Lessons learned

1. **Worktree path discipline.** First batch of edits accidentally landed in
   the main repo (`C:/_BISU/.../Game_Prototypes/2_Weaponcraft_Godot/...`)
   instead of the worktree path (`.claude/worktrees/<slug>/...`). Caught
   via `git status` showing nothing to commit. Copied files across +
   restored main repo. Lesson: always pass the worktree-absolute path to
   Edit/Write when working in worktree mode.

2. **Match block with const cases.** Godot 4's `match` accepts constant
   expressions in case patterns (`match wave: ELARA_UNLOCK_WAVE:`). No
   need to maintain a constant + literal duo.

3. **Tween for animated styling.** Animating `StyleBoxFlat.border_color`
   via `Tween.tween_property(sb, "border_color", c, dur)` works cleanly
   when paired with `set_loops()` and stashed-reference cleanup. Cheap on
   the compatibility renderer (no shader).

4. **`get(&"const_name")` requires instance.** Direct attribute access on
   a preloaded `const ScriptT = preload(...)` for class constants —
   `ScriptT.MY_CONST` — works without instantiation. `ScriptT.get(...)` is
   instance-level and parse-errors at the class level.

5. **`is_consumable` schema migration is free.** Adding an `@export var
   is_consumable: bool = false` to PartData defaulted to `false` on all
   existing `.tres` files on load. No migration step needed.

---

## Where things live (delta from previous handoff)

```
2_Weaponcraft_Godot/Prototype/godot/
├── scripts/core/
│   ├── game_state.gd          (TOTAL_WAVES 5 -> 10)
│   ├── merge.gd               (LEVEL_MULT new slow curve)
│   └── shop.gd                (POTION_PART_ID, _consume_potion, injection,
│                               buy short-circuit, consumable filter)
├── scripts/data/
│   ├── part_data.gd           (cost default 3 -> 4, is_consumable: bool flag)
│   └── weapon.gd              (LEVEL_MULT mirror lockstep)
├── scripts/ui/
│   ├── main.gd                (ELARA_UNLOCK_WAVE / VEX_UNLOCK_WAVE consts +
│   │                           match block uses them; values 3 / 6)
│   └── part_card.gd           (RIM_* constants, _tier_rim_color/_width,
│                               L5 rainbow tween, _rim_tween cleanup,
│                               _apply_potion_style_overlay)
├── scripts/dev/
│   ├── test_combat.gd         (+ TOTAL_WAVES / hero HP / cost / unlock cases)
│   ├── test_merge.gd          (L5 = 2.75 update + Weapon mirror test)
│   ├── test_shop.gd           (+ 18 potion cases)
│   └── test_ui.gd                                                          NEW
├── scenes/
│   ├── ForgePanel.tscn        (+ AnvilLabels HBox with 3 Labels)
│   └── dev/TestUi.tscn                                                     NEW
└── data/
    ├── heroes/
    │   ├── bran.tres          (hp_base 80 -> 120)
    │   ├── elara.tres         (hp_base 60 -> 90)
    │   └── vex.tres           (hp_base 65 -> 75)
    └── parts/
        ├── r_pierce.tres      (cost 3 -> 4)
        └── c_heal_potion.tres                                              NEW
```

---

## How to resume tomorrow

1. `cd C:/_BISU/_WORKSPACE/AI_Explorations/_Claude/Game_Prototypes` (root).
2. `git checkout weaponcraft-godot/forge-ux-balance-w10` and review the
   8 commits via `git log --oneline main..HEAD`.
3. Open `2_Weaponcraft_Godot/Prototype/godot/project.godot` in Godot 4.6.2.
   F5 to manual-playthrough:
   - Anvil row shows `Head` / `Hilt` / `Rune` labels.
   - Buy + merge a part L2 → silver border. L3 → gold. L4 → platinum.
     L5 → animated rainbow.
   - W1 shop has Heal Potion in slot 4. Buy it at full HP (sanity check),
     then take damage in W1 combat, return forge (W4) and use potion.
   - W3 clear → ✨ Elara joins banner. W6 clear → ✨ Vex joins.
   - W10 clear → 🏆 stage clear.
4. If playthrough looks good, merge to `main` via ff-only and delete the
   feature branch.
5. Confirm with user whether to proceed to **Stage E (Audio)** next, or
   adjust roadmap based on playthrough feedback.

---

## Cost summary (this session)

| Spend | What |
|---|---|
| $0 | Heal potion icon reused `merge_sparkle.png`; no nano-banana calls. |
| Total | $0 |

---

End of handoff. Build is in a strong, polished state — 10 waves, retimed
unlocks, slower power-curve, healing safety valve, satisfying visual
merge progression, slot-name clarity. Ready for user playthrough +
optional Stage E (Audio) next.
