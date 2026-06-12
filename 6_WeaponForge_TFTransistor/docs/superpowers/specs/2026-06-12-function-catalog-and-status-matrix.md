# Function Catalog + Status Reaction Matrix — Design Lock

> **SSOT for forward implementation.** Parent design rationale: [`2026-06-12-fork-a-pivot-addendum.md`](2026-06-12-fork-a-pivot-addendum.md). This doc translates the addendum's pillars into the unambiguous cell-by-cell contract that Phase 4 (vertical slice) and Phase 5 (full rewrite) implement.

**Date:** 2026-06-12 · **Status:** DRAFT — pending user review gate (see §10).

**Scope:** locks the 12-Function catalog (× 3 slot behaviors = 36 cells), the 5-status output table, the 15-cell reaction matrix, per-hero base weapons, the 3×3 grid coordinate scheme, and targeting/advance rules. Numbers are starting points designed to be tunable in code — feel-passes will revisit them in Phase 4.

---

## 1. Cardinal rules (read first)

1. **Every Function is useful in every slot.** No Function is dead weight in Active, Modifier, or Passive. That's the whole point of the Transistor matrix — zero shop-slot stalling.
2. **Modifier warps the Active beneath it.** If no Active is socketed, Modifier warps the hero's **base weapon** instead (never dead).
3. **Passive disables the Function's mechanical attack shapes** and emits a continuous trait/aura instead. Same Function in Passive ≠ same Function in Active.
4. **Statuses live on enemy tiles, not enemies.** When an enemy advances onto a tile carrying a status, it inherits the status. When an enemy dies/leaves a tile, the status remains for its duration.
5. **A reaction fires when an incoming damage tag hits an existing status on the target tile.** The damage tag comes from the *Active* slot of the firing hero (or hero's base weapon if no Active). Modifier and Passive do **not** carry damage tags themselves.
6. **One reaction per hit.** If multiple statuses match, resolve in this priority: `Wet > Burning > Chilled > Cracked > Shocked` (alphabetically tied; resolved by status-stack age — oldest first).
7. **Reactions consume their input status unless the matrix says otherwise.** Default-cleanse simplifies reaction chaining.

---

## 2. The 12 Functions

Three categories. Each Function id is the in-code constant and visual label.

| Category | Functions |
|---|---|
| **Elements (status emitters)** | `FIRE`, `ICE`, `LIGHTNING`, `WATER`, `EARTH` |
| **Patterns (attack shape)** | `AOE`, `BEAM`, `BOUNCE`, `BURST` |
| **Tactical (targeting + trait)** | `SEEKER`, `LEECH`, `KNOCKBACK` |

Elements emit a status when in Active. Patterns + Tactical do not carry a status themselves — they need an Active element underneath (via the hero's base weapon, or stacked into the same hero's Active slot, in which case Modifier warps the result). See §3 for slot-combination rules.

### Slot stacking — what fires first

A hero has 3 sockets: **Active / Modifier / Passive**. Resolution per attack tick:

1. **Active socket** defines the projectile/shape and the damage tag.
2. **Modifier socket** warps Active's pattern (shape, fan, bounce, etc.) and may add a secondary damage tag.
3. **Passive socket** runs every tick independently — never fires the attack; it adjusts hero stats, applies auras, or grants traits.

If Active is empty, the hero attacks with their **base weapon** (see §6); Modifier still warps it; Passive still runs.

---

## 3. The 36-cell Function × Slot matrix

For each Function, locked behavior per slot. **Damage tag** is the element key emitted when this Function is in Active and a hit lands. **Modifier warp** is what this Function does to *another* Active beneath it. **Passive trait** is the continuous effect.

### 3.1 Elements

#### `FIRE`
- **Active:** melee single-target on closest enemy in same column; damage tag = `FIRE`; applies `Burning` to hit tile.
- **Modifier:** adds `FIRE` damage tag to Active's hits (multi-tag attack — any reaction match resolves on the highest-multiplier tag). +20% base dmg. Does not change Active's shape.
- **Passive:** "Forge Aura" — all allied heroes' attacks gain +10% dmg vs `Burning` and `Chilled` targets (exploiter).

#### `ICE`
- **Active:** ranged 2-tile straight-line on closest enemy in same column; damage tag = `ICE`; applies `Chilled` to hit tile.
- **Modifier:** adds `ICE` damage tag to Active's hits. +15% base dmg. Active's hits also slow target's advance by 1 tick (post-reaction).
- **Passive:** "Frost Field" — enemy advance cadence increases by +1 tick globally (all enemies advance slower while this hero is alive).

#### `LIGHTNING`
- **Active:** chain-jump — primary hit on closest enemy in same row; arcs to 1 adjacent enemy tile (Manhattan-1) at 50% dmg; damage tag = `LIGHTNING`; applies `Shocked` to both hit tiles.
- **Modifier:** adds `LIGHTNING` damage tag. +25% base dmg, but Active's attack now jitters: 20% miss chance on the primary hit (chaos modifier).
- **Passive:** "Static Charge" — every 5 ticks, the hero discharges 1 dmg to all enemies on the column directly in front of them; applies `Shocked` (no reaction unless an Active hit follows).

#### `WATER`
- **Active:** ranged 3-tile cone (3 tiles wide at row 2 — see §7 grid); damage tag = `WATER`; applies `Wet` to all hit tiles; base dmg low (0.5× hero base).
- **Modifier:** adds `WATER` damage tag. Active's hits also apply `Wet` to the hit tile (in addition to Active's own status). Damage unchanged.
- **Passive:** "Tidepool" — every 4 ticks, applies `Wet` to a random enemy column (front row tile). Pure utility — sets up other heroes' reactions.

#### `EARTH`
- **Active:** melee single-target on closest enemy in same column; damage tag = `EARTH`; applies `Cracked` (stackable up to 3) to hit tile; high base dmg (1.5× hero base), slow attack speed (1 attack per 2 ticks instead of 1).
- **Modifier:** adds `EARTH` damage tag. Active's hits also stack `Cracked` (1 stack per hit). +30% base dmg, -20% attack speed.
- **Passive:** "Tectonic Plate" — hero gains +30% HP and +10% dmg reduction; rooted (irrelevant v1 since heroes are static — reserved for future movement).

### 3.2 Patterns

#### `AOE`
- **Active:** radial blast on a 1-tile radius around closest enemy in same column (hits up to 5 tiles in a + shape); damage tag = **none** (no inherent element — uses hero's base weapon dmg tag if any, else neutral); base dmg 0.7× per tile hit.
- **Modifier:** Active's shape becomes radial — instead of single-target, Active strikes the target tile + all 4 Manhattan-adjacent tiles. Per-tile dmg = Active base × 0.7. Status emission from Active spreads to all hit tiles.
- **Passive:** "Concussion Aura" — once per 6 ticks, the hero emits a silent blast on the row in front of them: 1 dmg + minor knockback (advance reset on hit enemies). No status.

#### `BEAM`
- **Active:** straight-line piercing — fires down the hero's column, hits every enemy tile from front row to back; damage tag = **none**; base dmg 0.6× per tile, attack speed 1 per 2 ticks (slow).
- **Modifier:** Active's shape becomes piercing — Active continues through its first target and strikes every enemy tile in the same line/column behind it. Per-tile dmg falls 20% per pierce. Status emission applies to every pierced tile.
- **Passive:** "Long Sight" — hero's column is revealed: enemy HP visible, +15% dmg vs enemies on back row (row 2). Pure utility — no attack.

#### `BOUNCE`
- **Active:** ricochets between enemy tiles — primary hit on closest in column, then bounces to next-closest enemy by Manhattan distance, up to 3 hits total; damage tag = **none**; base dmg 0.8× per hit, no falloff.
- **Modifier:** Active's projectile gains 2 bounces after impact — each bounce hits next-closest enemy tile at 70% of prior dmg. Status emission applies on each bounce.
- **Passive:** "Echo" — 20% chance per hero attack to trigger a free secondary hit on the same target tile (same Active behavior, half dmg). Triggers off any attack the hero fires.

#### `BURST`
- **Active:** 3-shot fan — fires at closest enemy + the 2 nearest-adjacent enemy tiles in a 3-tile fan; damage tag = **none**; base dmg 0.45× per shot (3 × 0.45 = 1.35× total).
- **Modifier:** Active fires 3 shots in a 3-tile fan instead of 1. Per-shot dmg = Active × 0.45. Status emission applies per shot — three separate hits, three reaction opportunities.
- **Passive:** "Rapid Fire" — hero attack speed +40% (1 attack per 0.6 ticks). Affects whatever Active is socketed (or base weapon).

### 3.3 Tactical

#### `SEEKER`
- **Active:** auto-targets the lowest-current-HP enemy on the grid regardless of position; ranged single-target, damage tag = **none**; base dmg 0.9×; ignores cover/positioning.
- **Modifier:** overrides Active's targeting — Active now strikes lowest-HP enemy instead of closest. Shape and damage tag of Active preserved. No dmg change.
- **Passive:** "Executioner" — hero's attacks deal +50% dmg to enemies under 30% HP. Massive late-fight scaling.

#### `LEECH`
- **Active:** melee single-target on closest enemy in same column; damage tag = **none**; base dmg 0.6×; heals self for 50% of dmg dealt.
- **Modifier:** Active's hits heal the firing hero for 25% of dmg dealt. Shape, dmg tag, status preserved.
- **Passive:** "Lifelink" — hero passively heals 1 HP per tick (every tick, regardless of attack). Also disables mechanical attacks from Modifier/Active (per addendum §II) — when in Passive, this hero **does not fire**, only sustains the squad.

#### `KNOCKBACK`
- **Active:** melee single-target on closest enemy in same column; damage tag = **none**; base dmg 0.5×; pushes target back 1 row (resets advance timer for that tile).
- **Modifier:** Active's hits push target back 1 row on connect. Stacks with Active's status emission (push happens after damage, so reactions still resolve on the pre-push tile).
- **Passive:** "Repulse Field" — when any enemy advances onto the row directly in front of this hero, push them back 1 row (1× per tick max). Defensive zoning.

---

## 4. Status output table

5 statuses are emitted by Element Functions in Active. Patterns + Tactical do not emit unless they carry an Element via Modifier.

| Function (Active) | Status | Duration | Stack rules | Decay / cleanse |
|---|---|---|---|---|
| `FIRE` | **Burning** | 3 ticks | refresh on re-apply (no stack) | natural decay; cleansed by `WATER`-tag reaction |
| `ICE` | **Chilled** | 3 ticks | refresh | cleansed by `FIRE`-tag reaction |
| `LIGHTNING` | **Shocked** | 2 ticks | refresh | natural decay only; short duration is intentional |
| `WATER` | **Wet** | 4 ticks | refresh | cleansed by `FIRE`-tag reaction (Steam) |
| `EARTH` | **Cracked** | 4 ticks | stacks to 3 (each stack +15% incoming dmg) | natural decay; no element cleanse |

**Tile-level behavior.** A status applies to the hit *enemy tile*. If the tile is empty when struck (e.g., enemy died on contact), the status persists on the tile for its duration. Next enemy to advance onto that tile inherits the status. This is the core of cross-hero combo setup — hero A pre-loads tiles, hero B detonates.

**Effective gameplay impact (independent of reactions):**

| Status | Tile-level effect (passive) |
|---|---|
| Burning | -2 HP per tick to occupying enemy |
| Chilled | enemy advance speed halved (next advance roll takes 2× ticks) |
| Shocked | -1 HP per tick + 10% chance to skip own attack |
| Wet | no inherent dmg; pure reaction-enabler |
| Cracked | enemies on tile take +15% dmg per stack (max +45% at 3 stacks) |

---

## 5. The reaction matrix (15 reactions, v1)

A reaction fires when an **incoming damage tag** strikes a tile carrying an **existing status**. Tag comes from the Active socket of the firing hero (Modifier can add a secondary tag). Per-hit, only the highest-multiplier reaction matches (rule 6 above).

| # | Incoming tag | × Status | → Reaction | Dmg mult | Splash | Status mutation | VFX hook |
|---|---|---|---|---|---|---|---|
| 1 | `LIGHTNING` | × Wet | **Electrocute** | 2.0× | 1-tile Manhattan (all 4 adj) | cleanse Wet on origin + adj tiles; apply Shocked to splashed | `vfx_arc_chain` |
| 2 | `FIRE` | × Wet | **Steam** | 1.0× (no bonus) | 1-tile radius | cleanse Wet + Burning on origin + adj; apply `Blind` (1-tick miss) to splashed enemies | `vfx_steam_puff` |
| 3 | `FIRE` | × Chilled | **Thaw** | 1.5× | none | cleanse Chilled; no new status | `vfx_fire_burst` |
| 4 | `FIRE` | × Cracked | **Magma Burst** | 1.8× | 1-tile Manhattan | consume 1 Cracked stack; apply Burning to splashed | `vfx_magma` |
| 5 | `ICE` | × Wet | **Freeze Solid** | 1.5× | none | cleanse Wet; apply `Frozen` (1-tick skip own turn — distinct from Chilled) | `vfx_freeze_solid` |
| 6 | `ICE` | × Burning | **Frostbite** | 1.3× | none | cleanse Burning; apply Chilled | `vfx_frostbite` |
| 7 | `ICE` | × Shocked | **Capacitor** | 1.4× | none | refresh Shocked for 2× duration; cleanse Chilled if any | `vfx_arc_freeze` |
| 8 | `WATER` | × Burning | **Quench** | 0.8× | none | cleanse Burning; apply Wet | `vfx_steam_small` |
| 9 | `WATER` | × Shocked | **Backsplash** | 0.5× | 1-tile Manhattan (only tiles already Wet) | propagate Shocked to splashed Wet tiles (Wet becomes Shocked) | `vfx_water_arc` |
| 10 | `WATER` | × Cracked | **Mudslide (Water)** | 1.2× | none | consume 1 Cracked stack; apply slow (advance +2 ticks) | `vfx_mudslide` |
| 11 | `EARTH` | × Wet | **Mudslide (Earth)** | 1.4× | none | cleanse Wet; apply slow (advance +2 ticks) | `vfx_mudslide` |
| 12 | `EARTH` | × Burning | **Ash Cloud** | 1.2× | 1-tile Manhattan | cleanse Burning on origin; apply `Blind` (1-tick miss) to splashed | `vfx_ash_cloud` |
| 13 | `EARTH` | × Chilled | **Avalanche** | 1.6× | none | cleanse Chilled; knockback target 1 row | `vfx_rock_slam` |
| 14 | `LIGHTNING` | × Cracked | **Stonesmith** | 2.0× | none | consume 1 Cracked stack; apply Shocked (Cracked stacks may remain) | `vfx_arc_stone` |
| 15 | `LIGHTNING` | × Burning | **Arc Storm** | 1.5× | 1-tile Manhattan | spread Shocked to splashed; consume Burning on origin only | `vfx_arc_storm` |

**Not in matrix (no reaction — base dmg only):** any tag × no status; `WATER` × Wet; `WATER` × Chilled; `FIRE` × Burning; `ICE` × Chilled; `EARTH` × Cracked; `EARTH` × Shocked; `LIGHTNING` × Shocked. These either self-stack (status refreshes) or are dead pairs to keep the table tractable.

**Auxiliary statuses introduced by reactions:**

| Status | Effect | Duration |
|---|---|---|
| `Blind` | enemy's next attack misses | 1 attack instance |
| `Frozen` | enemy skips next attack + advance | 1 tick |

These are reaction-only — no Function emits them directly. Cleanse: natural decay only.

---

## 6. Per-hero base weapons (3 heroes — Bran, Elara, Vex)

What each hero does with **ZERO Functions socketed**. Base attack is the implicit "Active" if Active socket is empty; Modifier still warps it; Passive still runs.

### Bran — Warrior
- **Base attack:** melee single-target, closest enemy in same column; range = 1 row (front-most enemy in his column).
- **Damage tag:** none (neutral).
- **Status emission:** none.
- **Base dmg:** 1.0× (reference unit).
- **Attack cadence:** 1 attack per tick.
- **Squad role:** front-row anchor; benefits most from `BEAM` / `BURST` Modifier or `LEECH` for self-sustain.

### Elara — Mage
- **Base attack:** ranged single-target, closest enemy in same column, 3-row reach (can hit back row from front row).
- **Damage tag:** none (neutral).
- **Status emission:** none.
- **Base dmg:** 0.8×.
- **Attack cadence:** 1 attack per tick.
- **Squad role:** back-row caster; benefits most from `LIGHTNING` / `AOE` / `FIRE` Active for reaction-setup.

### Vex — Rogue
- **Base attack:** melee single-target, closest enemy in same column; range = 1 row.
- **Damage tag:** none (neutral).
- **Status emission:** none — but innate +20% dmg vs `Burning` targets (built-in exploiter; this is *not* a Passive Function — it's hero-intrinsic).
- **Base dmg:** 0.9×, crit chance 15% (2× crit dmg).
- **Attack cadence:** 1 attack per tick (1.2× speed flag — i.e. attacks slightly more often given multi-hero tick budget; see §8).
- **Squad role:** finisher; deploy after Elara stacks Burning, Vex executes.

**Hero stat baselines (v1 starting numbers — tunable in `hero_data.gd`):**

| Hero | HP | DMG | Speed | Crit % |
|---|---|---|---|---|
| Bran | 100 | 1.0× | 1.0 atk/tick | 0% |
| Elara | 70 | 0.8× | 1.0 atk/tick | 0% |
| Vex | 80 | 0.9× | 1.2 atk/tick | 15% |

---

## 7. Grid scheme

**3×3 player grid + 3×3 enemy grid, mirrored.** 9 tiles per side; 3 heroes leaves 6 player tiles empty (reserved for terrain/buffs/summons in later phases).

```
        PLAYER GRID                     ENEMY GRID
   col=0   col=1   col=2           col=0   col=1   col=2
 ┌───────┬───────┬───────┐       ┌───────┬───────┬───────┐
 │ (0,0) │ (1,0) │ (2,0) │ row=0 │ (0,0) │ (1,0) │ (2,0) │  row=0  (front, enemies advance here last)
 ├───────┼───────┼───────┤       ├───────┼───────┼───────┤
 │ (0,1) │ (1,1) │ (2,1) │ row=1 │ (0,1) │ (1,1) │ (2,1) │  row=1
 ├───────┼───────┼───────┤       ├───────┼───────┼───────┤
 │ (0,2) │ (1,2) │ (2,2) │ row=2 │ (0,2) │ (1,2) │ (2,2) │  row=2  (back — spawn here)
 └───────┴───────┴───────┘       └───────┴───────┴───────┘
              ⇆ (mirrored — player.col maps to enemy.col)
```

**Coord conventions:**
- **Player grid:** row=0 is **back** (mage row), row=2 is **front** (Vex/Bran row). Player column 0 is left.
- **Enemy grid:** row=0 is **front** (closest to player, where contact lands), row=2 is **back** (spawn row).
- "Same column" means `player.col == enemy.col`. "Same row" means same `row` index — but cross-grid distance is measured in *Manhattan steps across both grids* (treat the join between front rows as one cell apart).

**Distance** (for "closest by Manhattan"): `|p.col - e.col| + (p.row_inverted) + (e.row)`, where `p.row_inverted = 2 - p.row` (so Bran on player row 2 / front is 0 distance to enemy row 0). Implementation detail — `grid_state.gd` exports a `distance(player_tile, enemy_tile)` function.

**Heroes are static in v1** — they occupy a player tile at deploy and cannot move. Future phases may add movement; targeting must be coord-derived so movement plugs in cleanly.

**Boss footprint:** a Boss occupies a single column × 2 rows (e.g., (0,1)+(0,0) — back-row spawn extending to mid-row). Treats as one entity with one HP bar; either tile being hit applies status to that tile; advance is by entity not by tile (boss moves both tiles together).

---

## 8. Targeting + movement + cadence rules

### 8.1 Targeting (derived from Active Function)

The Active Function (or base weapon if Active empty) dictates the hero's target selection algorithm:

| Active type | Selection algorithm |
|---|---|
| Melee single (FIRE / ICE-melee / EARTH / KNOCKBACK / LEECH / Bran base / Vex base) | closest enemy in *same column*, by row index (lowest row = closest, since enemy row 0 = front) |
| Ranged single (LIGHTNING primary / Elara base) | closest enemy in *same row* (mirrored row, see §7), tie-broken by column distance |
| Cone (WATER) | 3 tiles wide on enemy row 2 — wraps to row 1 if row 2 empty (recompute per tick) |
| Radial / pierce (AOE / BEAM Active) | closest enemy in column as the *anchor*, then shape spreads from there |
| Bounce (BOUNCE Active) | closest in column → next-closest by Manhattan from impact, max 3 hops |
| Multi-shot (BURST Active) | closest in column + 2 nearest-adjacent enemy tiles (3-tile fan) |
| Seeker (SEEKER Active or SEEKER Modifier) | enemy with lowest current HP, regardless of column/row |

**Tie-breakers:** lowest column index, then lowest row index. Deterministic — no RNG in target selection.

### 8.2 Enemy advance

- Enemies spawn on row 2 (back of enemy grid).
- Each enemy has an **advance counter** (default 4 ticks). When counter ticks down to 0, enemy advances 1 row toward player (row 2 → 1 → 0). Counter resets to 4.
- **Reaching player grid:** when an enemy on enemy row 0 advances, they "cross over" and start dealing 1 dmg/tick to all 3 heroes (squad-wide tick damage — heroes still attack normally; the enemy is gone from the grid).
- `Chilled` status: enemy's next advance takes 2× ticks (8 instead of 4).
- `KNOCKBACK` reaction (Avalanche, etc.): pushes enemy back 1 row (row reduces? — no: enemy row goes back to spawn row, so row index increases by 1, capped at 2).

### 8.3 Tick cadence

- 1 tick = 1 game second (configurable for slow-mo / juice in code; tunable via `combat.gd` const).
- Per tick: (1) status decay pass, (2) enemy advance pass, (3) hero attack pass (in deploy order), (4) reaction resolution pass, (5) death + cleanup pass.
- A wave ends when all enemies are dead (player win) OR all heroes are dead (player loss). Player tile cross-over does NOT kill heroes directly — only HP attrition does.

### 8.4 Boss rules

- Boss spawns on row 2 occupying 1 column × 2 rows (see §7).
- Boss does NOT advance on standard cadence; instead has scripted phases (Phase 5 detail — for vertical slice, treat boss as a stationary 5× HP enemy at row 1).
- Boss can be hit on either tile of its footprint; status applies to the boss entity, not the tile (single status pool per boss).

---

## 9. Forge UI implications (Phase 4 / 5)

Not implementation — design contract for the UI rewrite. The shop and forge layers must communicate the matrix structure clearly:

- **Shop card** shows: Function id, category color (Element red/blue/yellow/cyan/brown, Pattern purple, Tactical green), and a 3-row preview of Active/Modifier/Passive behavior summaries (4–6 words each — see §3 cells for source text).
- **Hero forge panel** shows: 3 stacked sockets (Active on top, Modifier middle, Passive bottom), each labeled. Empty Active reads "Base weapon". Dragging a card into a socket previews the resulting combined effect (e.g., "Base + ICE Mod = ranged + chill on hit").
- **No recipes.** The merge system (L1→L5 Function auto-merge) survives unchanged at the slot level — drop a 2nd `FIRE` on a 1-star `FIRE` Function to get a 2-star (1.5× values), but Function behavior remains identical per slot. (Merge details out of scope for this spec — defer to existing `merge.gd` behavior with Function-card data shape.)

---

## 10. User review gate (HARD STOP)

This spec is the implementation contract for Phase 4 (vertical slice) and Phase 5 (full rewrite). **No code is written against it until the user signs off.**

**Open questions for review (revise inline before sign-off):**

1. **Function set** — is the 12-Function v1 cut correct, or should we swap one (e.g., drop `KNOCKBACK` for `TELEPORT` per the addendum's example)?
2. **Reaction count** — 15 reactions is dense but tractable. Reduce to 10 (cleaner) or expand to 20 (more depth)? Lean toward 15 for v1.
3. **Status durations** — Burning 3 / Chilled 3 / Shocked 2 / Wet 4 / Cracked 4 ticks. Feel right? Bias short for mobile readability.
4. **Grid size** — 3×3 mirrored is locked here per plan §13. Confirm vs addendum's 3×4 / 4×4 mention.
5. **Cone targeting** — `WATER`-Active uses a 3-tile cone. Confirm or simplify to "row-wide hit"?
6. **Per-hero innate trait** (Vex's +20% vs Burning) — keep as hard-coded hero identity, or make it a removable Passive seed? Currently locked as innate.
7. **Boss in vertical slice** — treat as stationary 5× HP enemy (per §8.4). Confirm or skip boss entirely for Phase 4?
8. **Modifier-without-Active** — when a Modifier is socketed but Active is empty, Modifier warps the *base weapon* (rule 2 in §1). Confirm this is the desired behavior over "Modifier inert without Active".

Once these are answered + spec adjusted, commit a **`status: LOCKED`** revision and proceed to Phase 4 branch cut.

---

## Appendix A — Implementation hooks (for Phase 4 dev reference, not normative)

- `function_data.gd` (Resource): `id: String`, `category: enum`, `active_behavior: Dict`, `modifier_behavior: Dict`, `passive_behavior: Dict`, `damage_tag: StringName` (empty for non-elements), `status_emit: StringName` (empty for non-emitters).
- `status_data.gd` (Resource or enum): `id`, `duration`, `stack_max`, `tile_effect`, `decay_rule`.
- `reaction_data.gd` (Resource): `incoming_tag`, `existing_status`, `dmg_mult`, `splash_radius`, `splash_filter` (none / Manhattan-1 / Manhattan-1-wet-only), `status_mutation` (Dict of cleanse/apply ops), `vfx_hook`.
- `grid_state.gd` (autoload): `tile_status: Dict[Vector2i, Array[StatusInstance]]`, `enemy_occupants: Dict[Vector2i, Enemy]`, `hero_occupants: Dict[Vector2i, Hero]`. Exports `distance(p_tile, e_tile) → int`.
- `element_mediator.gd` (autoload): subscribes to `hit_landed(attacker, target_tile, damage, tags)` signal; checks `tile_status[target_tile]` vs `tags`; dispatches reaction from `reaction_data.gd` registry; emits `reaction_triggered` signal back to combat for VFX + dmg apply.
- `combat.gd` rewrite (`combat_v2.gd` during vertical slice): tick loop driving §8.3 pass order; per-hero attack pass calls `resolve_active(hero) → AttackResult`; result feeds `element_mediator`.
