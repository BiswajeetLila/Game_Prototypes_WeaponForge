# Combat ← WeaponData migration plan (P1a → beyond)

**Status:** Stage 1 DONE (2026-06-01). Stages 2–3 DEFERRED. Read before resuming the migration.

## Goal

Move `scripts/core/combat.gd` (and eventually `game_state.gd`/`hero_state.gd`) off the
legacy 3-socket `scripts/data/weapon.gd` (a part-aggregator) and onto the unitary
`scripts/data/weapon_data.gd` (`WeaponData`), then retire the socket model.

## Key finding (why this isn't one cycle)

`combat.gd` is **loosely coupled** — it treats `hero.weapon` as opaque and calls only four
methods: `get_atk()`, `get_crit()`, `get_ult_rate()`, `get_all_tags()` (plus `get_hp_bonus()`
via `hero_state.gd:37`). Swapping those is easy.

**But** the socket model underpins the **recipe / merge / shop / forge** loop and **~80 of
the 144 tests** (all TestMerge 16, TestRecipes 14, TestShop slot-coverage, ~50 TestCombat).
The killer: in-stage **recipes need multi-part tag combos** (fire socket + ice socket →
Steamburst). A *unitary* WeaponData has a single `rune` element and **cannot reproduce
multi-tag combos**. The system that replaces in-stage recipes is the spec's **Forge Draft
skill cards + Catalyst compounds (P1c/P1e), which are not built yet.** So fully retiring
sockets now would dismantle combat's synergy with nothing to catch it.

### Gap analysis (combat reads vs WeaponData) — CLOSED by Stage 1

| combat.gd needs | call site | Stage-1 status |
|---|---|---|
| `get_atk()` | combat.gd:259,275,298,328 | already existed |
| `get_crit()` | combat.gd:329 | ✅ added (flat `base_crit`) |
| `get_ult_rate()` | combat.gd:330 | ✅ added (flat `base_ult_rate`) |
| `get_all_tags()` | combat.gd:331 + recipes.gd:56 | ✅ added (rune + derived crit/charge) |
| `get_hp_bonus()` | hero_state.gd:37 | ✅ added (alias of `get_hp()`) |

### Coupling verdict (from code-explorer)

The socket API (`get_slot`/`set_slot`/`is_full`/`slots`) is **legacy-weapon-only**, used by
`merge.gd` (lines 64,75,115,129,143), `shop.gd:157 _needs_slot_guarantee`,
`forge_panel.gd _rebuild_anvil`, and directly by TestMerge/TestShop/TestRecipes. combat.gd
never touches slots. So combat can be switched in isolation **if** WeaponData exposes the 4
methods (now done) AND the recipe-tag problem is solved.

## Stages

### Stage 1 — WeaponData combat interface ✅ DONE (commit 79b6c30)
Added `base_crit`/`base_ult_rate` (flat, not star-scaled), `get_crit()`, `get_ult_rate()`,
`get_all_tags()` (baked rune + derived `crit`/`charge`), `get_hp_bonus()` (alias of `get_hp()`).
TestWeaponData 23→32 green; combat untouched; 144-suite green. WeaponData is now a structural
drop-in for the legacy weapon's combat surface.

### Stage 2 — switch combat to WeaponData (DEFERRED)
Plan when ready:
1. `hero_state.gd`: add `var weapon_data` (WeaponData), create it in `_init`. Keep legacy
   `weapon` alive for shop/merge/forge.
2. `combat.gd`: repoint the 4 reads + null guards (lines 145,228,248,259,275,298,328–331)
   from `hero.weapon` → `hero.weapon_data`.
3. `hero_state.gd:37`: `refresh_max_hp()` → `weapon_data.get_hp_bonus()`.
4. `test_combat.gd`: rewrite `_fresh_session_with_weapon` (line 79) to populate `weapon_data`
   stats equal to the socket sums it currently sets, so the ~50 exact-damage assertions hold.
5. **Recipe problem:** decide — (a) keep `Recipes.get_recipe_bonuses(hero)` reading the legacy
   `hero.weapon` (split model: base stats from weapon_data, recipe bonuses from sockets), or
   (b) block Stage 2 until Forge Draft replaces recipes. (a) keeps 144 green but is incoherent;
   recommend (b).

### Stage 3 — retire sockets (DEFERRED, own phase ≈ P1c/P1e)
Replace in-stage recipes with Forge Draft skill cards (SkillCardData exists, schema only) +
Catalyst compounds. Then delete `weapon.gd` sockets, redesign `merge.gd`/`shop.gd` slot logic,
rewrite TestMerge/TestRecipes/TestShop, redesign ForgePanel anvil. Large; sequence after
P1c (Forge Draft) + P1e (Catalyst) are built.

## Essential files
- `scripts/data/weapon.gd` — legacy socket aggregator (Weapon, RefCounted)
- `scripts/data/weapon_data.gd` — unitary WeaponData (target)
- `scripts/data/hero_state.gd:19,32,37` — holds `var weapon`; the binding point
- `scripts/core/combat.gd:328–331` — the 4 reads (hot path)
- `scripts/core/recipes.gd:56` — `weapon.get_all_tags()` → recipe bonuses
- `scripts/core/merge.gd`, `scripts/core/shop.gd:157`, `scripts/ui/forge_panel.gd` — socket consumers
- Test contract: `test_combat.gd` (`_fresh_session_with_weapon`), `test_recipes.gd` (14× `WeaponT.new()`+`set_slot`), `test_merge.gd` (16 socket tests), `test_shop.gd` (slot coverage)

## Entry contracts (from the 2026-06-01 codex gate review — write these BEFORE implementing P0/#1)

These are specs, not code. Each must be written (and where marked, test-first) before its
increment starts. Source: final gate review, 6×P1 + 5×P2; the two committed-code P1s
(bank targeting, Mythic cap) were fixed same-day in `weapon_data.gd` — the rest live here.

1. **P0 persistence contract.** Define account-vs-run state split (`GameState.new_session()`
   currently wipes everything; only currency is run-scoped `gold`). Specify: save schema +
   version field, what persists (owned WeaponData instances incl. `star_tier`/`rarity_idx`/
   `forge_progress`/`forge_target_idx` — all exported now —, equipped-per-hero id, `gems`),
   load timing (before first scene), restart/corrupt-save behavior. Owned weapons are runtime
   `duplicate(true)` instances — never the catalog `.tres` (shared-Resource mutation).
2. **HP semantics contract (test-first).** Current behavior is DELIBERATE free-heal:
   `hero_state.gd` `refresh_max_hp()` does `hp = clampi(hp + delta, 0, max_hp)` ("equipping
   +HP raises current HP"). The plan's clamp-never-refill rule is a BEHAVIOR CHANGE: write
   the failing test first, update any legacy tests that assert +delta, and decide whether
   the change applies to legacy sockets too or only weapon_data equips. Blocks the
   equip-swap free-heal exploit.
3. **Debug-toggle isolation contract.** `pulled-only` mode must zero legacy recipe bonuses
   too (recipes read sockets and feed combat damage) — otherwise FM-1 playtest signal is
   polluted. Modes: legacy-only / pulled-only (sockets contribute NOTHING incl. recipes) /
   additive (explicitly experimental).
4. **Catalog tuning curve.** "First equip never a downgrade" needs a defined comparison
   point: socket-kitted hero at wave W with merge level L, recipes included or excluded.
   Pick the curve before authoring catalog `.tres` stats; record the numbers next to it.
5. **Validation hardening (before catalog/.tres authoring ships).** Clamp/validate
   `base_crit`, `base_ult_rate`, `star_tier` (1..10), `rarity_idx` (0..4) on WeaponData;
   tighten `SkillCardData.is_valid()` (rarity range, non-empty effect per card type) before
   draft cards enter a catalog.
6. **Forge bank retarget UX.** Code rule (implemented): the bank is target-exclusive; a
   different-tier banking part RESETS the bank. Pull/dupe UI (increment #3) must warn
   before a resetting apply. Revisit ratio-conversion only if playtests hate the reset.
