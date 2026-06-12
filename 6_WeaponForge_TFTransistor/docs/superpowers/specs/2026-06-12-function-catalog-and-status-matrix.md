# Function Catalog + Status Reaction Matrix — Design Spec

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md) — folder SSOT. This doc is the cell-by-cell implementation contract elaborating the GDD's Function Matrix + reaction system + lane combat + FTUE pillars. Parent rationale (verbatim): [`2026-06-12-fork-a-pivot-addendum.md`](2026-06-12-fork-a-pivot-addendum.md). Slice scope: [`2026-06-13-phase4-vertical-slice-scope.md`](2026-06-13-phase4-vertical-slice-scope.md).

**Date:** 2026-06-13 · **Status:** **REVIEW-3** — auto-runner pivot. 3-lane Capybara-Go-style replaces grid. Awaiting LOCK sign-off.

**Revision history**
- `DRAFT` (`1bf7986`, 2026-06-12) — mirrored 3×3 grid
- `REVIEW-2` (`761bef0`, 2026-06-12) — central 4×4 grid w/ 4-edge spawn, FTUE, Ults, wave/forge cadence
- `REVIEW-3` (this rev, 2026-06-13) — switched to **3-lane horizontal auto-runner** (no grid, no placement); weapon-always-visible bottom rail; 7-item shop slow-populate across stage; 3-wave stages w/ 5-stage worlds; tiered Functions (T1-T5, 2-to-1 merge); FTUE re-paced (stages 1+2 = 1 wave each); 3-card module deferred to contingency; Wittle-meta direction locked for Phase 5; game-design/CEO/product-brainstorming patches folded in

---

## 0. The game in one paragraph

3 heroes (Elara mage, Bran warrior, Vex rogue) walk right through a 3-lane corridor. Enemies spawn from the right edge and walk left toward them. Heroes auto-fight enemies in their lane via their **Function Matrix** (3 universal sockets per hero: Active / Modifier / Passive — Transistor-style). Functions are atomic data blocks (`FIRE`, `WATER`, `BOUNCE`, `LEECH`...) bought from a 7-slot shop that slow-populates across each stage. Reactions trigger when an incoming damage tag hits an existing status on an enemy (Magicka-style — `LIGHTNING` × `Wet` = Electrocute, `FIRE` × `Wet` = Steam, etc.). Stages = 3 waves each. Worlds = 5 stages (4 normal + 1 boss). One session = one world ≈ 4-5 minutes.

---

## 1. Cardinal rules (read first)

1. **Every Function is useful in every slot.** No dead-weight cells.
2. **Modifier warps the Active beneath it.** If Active is empty, Modifier warps the hero's **base weapon** (never dead).
3. **Passive disables the Function's mechanical attack shapes** and emits a continuous trait/aura.
4. **Statuses attach to enemies** (per-enemy, not per-tile). On enemy death, status dies with the enemy. Status duration counts down per tick.
5. **Reactions fire when an incoming damage tag hits an existing status on the target enemy.** Tag comes from the Active socket of the firing hero (Modifier adds secondary tag; Passive carries no tag).
6. **One reaction per hit.** Priority: `Wet > Burning > Chilled > Cracked > Shocked`. Ties broken by oldest-status-first.
7. **Reactions consume their input status unless the matrix says otherwise.** (Exception: `Cracked` is a pure dmg-amp passenger, never consumed by other reactions — see §5.)
8. **All targeting = same-lane primary, cross-lane via Function pattern.** No row/column or Manhattan — lane index (0/1/2) + screen-x position is the spatial metric.
9. **Heroes locked to lanes** by deploy assignment. No player placement, no swap mid-run. (Static identity = readability.)

---

## 2. The 12 Functions

| Category | Functions |
|---|---|
| **Elements (status emitters)** | `FIRE`, `ICE`, `LIGHTNING`, `WATER`, `EARTH` |
| **Patterns (attack shape)** | `AOE`, `BEAM`, `BOUNCE`, `BURST` |
| **Tactical (targeting + trait)** | `SEEKER`, `LEECH`, `KNOCKBACK` |

Elements emit a status when in Active. Patterns + Tactical do not emit unless they carry an Element via Modifier.

### Slot stacking — resolution order per attack tick

1. **Active socket** — projectile/shape + damage tag.
2. **Modifier socket** — warps Active's pattern (shape/fan/bounce/etc.) and may add a secondary damage tag.
3. **Passive socket** — runs every tick independently; never fires the attack.

If Active is empty, hero attacks with **base weapon** (§6); Modifier still warps it; Passive still runs.

---

## 3. The 36-cell Function × Slot matrix (lane-aware)

**Damage tag** = element key emitted when this Function is in Active and a hit lands.
**Modifier warp** = what this Function does to *another* Active beneath it.
**Passive trait** = continuous effect, no attack fired.

**Lane targeting primitive (used by all rows below):**
- **own-lane closest** — nearest enemy in hero's own lane, by screen-x
- **any-lane closest** — nearest enemy across all 3 lanes, by Euclidean distance (lane-stride counts as 1 unit; screen-x scaled to same unit)
- **cross-lane spread** — hits target lane + the 2 adjacent lanes (or 1 adj if hero on edge lane)
- **own-lane line** — pierces every enemy in hero's lane from front to back

### 3.1 Elements

#### `FIRE`
- **Active:** melee single, range 1.0× hero base reach, own-lane closest. Tag = `FIRE`. Applies `Burning`.
- **Modifier:** adds `FIRE` tag to Active hits (multi-tag — reactions match highest mult). +20% base dmg.
- **Passive:** "Forge Aura" — all allied heroes +10% dmg vs `Burning` and `Chilled` enemies.

#### `ICE`
- **Active:** ranged single, no range cap, own-lane closest. Tag = `ICE`. Applies `Chilled`.
- **Modifier:** adds `ICE` tag. +15% base dmg. Active hits also slow target's walk-left speed by 50% for 1 tick.
- **Passive:** "Frost Field" — all enemies on grid walk 15% slower while this hero alive.

#### `LIGHTNING`
- **Active:** chain — primary hit on own-lane closest; arcs to 1 next-nearest enemy in **any lane** (at 50% dmg). Tag = `LIGHTNING`. Applies `Shocked` to both hit enemies.
- **Modifier:** adds `LIGHTNING` tag. +25% base dmg. Active gains 20% miss chance on primary (chaos mod).
- **Passive:** "Static Charge" — every 5 ticks, discharges 1 dmg to closest enemy in hero's lane; applies `Shocked` (no reaction unless followed by Active hit).

#### `WATER`
- **Active:** cross-lane spread — target = any-lane closest; applies `Wet` to target + 1 enemy each in the 2 adjacent lanes (lane-spread). Tag = `WATER`. Base dmg low (0.5× per hit).
- **Modifier:** adds `WATER` tag. Active hits also apply `Wet` to target enemy. Dmg unchanged.
- **Passive:** "Tidepool" — every 4 ticks, applies `Wet` to a random enemy on grid (front-most in random lane). Pure utility setup.

#### `EARTH`
- **Active:** melee single, range 1.0×, own-lane closest. Tag = `EARTH`. Applies `Cracked` (stacks to 3). High base dmg (1.5×), slow attack speed (1 atk per 2 ticks).
- **Modifier:** adds `EARTH` tag. Active hits stack `Cracked` (+1 per hit). +30% base dmg, -20% attack speed.
- **Passive:** "Tectonic Plate" — hero +30% HP, +10% dmg reduction.

### 3.2 Patterns

#### `AOE`
- **Active:** radial blast — target = any-lane closest; hits target + 2 adjacent-lane enemies AND target's nearest in-lane neighbors (up to 5 enemies). Tag = none. Base dmg 0.7× per enemy.
- **Modifier:** Active shape becomes radial — primary target + 4 nearest enemies (any lane). Per-enemy dmg = Active × 0.7. Status emission spreads.
- **Passive:** "Concussion Aura" — every 6 ticks, blasts closest enemy in hero's lane for 1 dmg + brief stagger (push 0.5× speed for 1 tick). No status.

#### `BEAM`
- **Active:** own-lane line — fires straight in hero's lane, pierces every enemy in lane from front to back. Tag = none. Base dmg 0.6× per pierce, 1 atk per 2 ticks.
- **Modifier:** Active becomes piercing — continues through first target in own-lane, hits every enemy behind it. Per-pierce dmg falls 20%. Status emission applies per pierce.
- **Passive:** "Long Sight" — enemy HP visible in hero's lane; +15% dmg vs enemies in back third of lane (far from hero).

#### `BOUNCE`
- **Active:** ricochet — primary on any-lane closest; bounces to next-closest by Euclidean dist, max 3 hits. Tag = none. Base dmg 0.8× per hit, no falloff.
- **Modifier:** Active projectile bounces 2× after impact, next-closest each time at 70% prior dmg. Status emission per bounce.
- **Passive:** "Echo" — 20% chance per hero attack to fire a free secondary hit on same target (half dmg). Triggers off any Active.

#### `BURST`
- **Active:** 3-shot fan — fires at any-lane closest + 2 next-nearest enemies (3-shot, often hits cross-lane). Tag = none. Base dmg 0.45× per shot (3 × 0.45 = 1.35× total).
- **Modifier:** Active fires 3 shots in 3-target fan instead of 1. Per-shot dmg = Active × 0.45. Status emission per shot — 3 reaction opportunities.
- **Passive:** "Rapid Fire" — hero attack speed +40%.

### 3.3 Tactical

#### `SEEKER`
- **Active:** lowest-HP enemy across all lanes; ranged single, no range cap. Tag = none. Base dmg 0.9×.
- **Modifier:** overrides Active's targeting — Active strikes lowest-HP instead of closest. Shape + dmg tag of Active preserved.
- **Passive:** "Executioner" — hero attacks deal +50% dmg vs enemies under 30% HP.

#### `LEECH`
- **Active:** melee single, range 1.0×, own-lane closest. Tag = none. Base dmg 0.6×. Heals self for 50% of dmg dealt.
- **Modifier:** Active hits heal firing hero for 25% of dmg dealt. Shape/tag/status preserved.
- **Passive:** "Lifelink" — hero passively heals 1 HP per tick. Also DISABLES mechanical attacks (Active + Modifier) — when LEECH in Passive, this hero does not fire, only sustains.

#### `KNOCKBACK`
- **Active:** melee single, range 1.0×, own-lane closest. Tag = none. Base dmg 0.5×. Pushes target back 1 screen-unit (resets advance progress).
- **Modifier:** Active hits push target back 1 unit on connect. Stacks w/ status emission (push happens after damage; reaction resolves on pre-push enemy).
- **Passive:** "Repulse Field" — when any enemy enters within 1 screen-unit of hero in own-lane, push them back 1 unit (1× per tick max). Defensive zoning.

**Knockback immunity rule:** an enemy that has been knocked back is immune to further knockback for 2 ticks. Prevents lock-out exploit.

---

## 4. Status output table

5 statuses emitted by Element Functions in Active. Patterns + Tactical do not emit unless carrying an Element via Modifier.

| Function (Active) | Status | Duration | Stack rules | Decay / cleanse |
|---|---|---|---|---|
| `FIRE` | **Burning** | 3 ticks | refresh on re-apply | natural decay; cleansed by `WATER`-tag reaction |
| `ICE` | **Chilled** | 3 ticks | refresh | cleansed by `FIRE`-tag reaction |
| `LIGHTNING` | **Shocked** | 2 ticks | refresh | natural decay only |
| `WATER` | **Wet** | 4 ticks | refresh | cleansed by `FIRE`-tag reaction (Steam) |
| `EARTH` | **Cracked** | 4 ticks | stacks to 3 (+15% incoming dmg per stack) | natural decay; **never consumed by reaction priority** (pure dmg-amp passenger) |

**Per-enemy effect** (active even without reaction firing):

| Status | Effect on occupying enemy |
|---|---|
| Burning | -2 HP per tick |
| Chilled | walk-left speed halved (advance speed × 0.5) |
| Shocked | -1 HP per tick + 10% chance to skip own attack |
| Wet | no inherent dmg; reaction-enabler only |
| Cracked | +15% incoming dmg per stack (max +45% at 3 stacks) |

**Cracked stack rule (clarification):** when a reaction fires on an enemy carrying Cracked + another status, the OTHER status is consumed per priority (rule 6/7). Cracked's dmg-amp multiplier applies on top of the reaction's `dmg_mult` (e.g., LIGHTNING × Wet = Electrocute at 2.0×, on a 2-stack-Cracked target = 2.0 × 1.30 = 2.6×). Cracked stacks NOT consumed.

---

## 5. The reaction matrix (15 reactions, v1)

| # | Tag | × Status | → Reaction | Dmg mult | Splash | Status mutation | VFX hook | Audio hook |
|---|---|---|---|---|---|---|---|---|
| 1 | `LIGHTNING` | × Wet | **Electrocute** | 2.0× | cross-lane (target lane + 2 adj — only Wet enemies in those lanes get arced) | cleanse Wet on origin + arced; apply Shocked to arced | `vfx_arc_chain` | `sfx_electrocute_zap` |
| 2 | `FIRE` | × Wet | **Steam** | 1.0× | cross-lane (target + 1 enemy each in 2 adj lanes) | cleanse Wet + Burning on origin + splashed; apply `Blind` (1-tick miss) to splashed | `vfx_steam_puff` | `sfx_steam_hiss` |
| 3 | `FIRE` | × Chilled | **Thaw** | 1.5× | none | cleanse Chilled | `vfx_fire_burst` | `sfx_thaw_crack` |
| 4 | `FIRE` | × Cracked | **Magma Burst** | 1.8× | own-lane 1-enemy-radius (next nearest enemy in lane) | consume 1 Cracked stack; apply Burning to splashed | `vfx_magma` | `sfx_magma_thud` |
| 5 | `ICE` | × Wet | **Freeze Solid** | 1.5× | none | cleanse Wet; apply `Frozen` (skip next attack + advance, 1 tick) | `vfx_freeze_solid` | `sfx_freeze_shatter` |
| 6 | `ICE` | × Burning | **Frostbite** | 1.3× | none | cleanse Burning; apply Chilled | `vfx_frostbite` | `sfx_frostbite` |
| 7 | `ICE` | × Shocked | **Capacitor** | 1.4× | none | refresh Shocked for 2× duration; cleanse Chilled if any | `vfx_arc_freeze` | `sfx_capacitor_hum` |
| 8 | `WATER` | × Burning | **Quench** | 0.8× | none | cleanse Burning; apply Wet | `vfx_steam_small` | `sfx_quench_pop` |
| 9 | `WATER` | × Shocked | **Backsplash** | 0.5× | cross-lane (only Wet enemies get arced) | propagate Shocked to splashed Wet enemies | `vfx_water_arc` | `sfx_backsplash` |
| 10 | `WATER` | × Cracked | **Mudslide (W)** | 1.2× | none | consume 1 Cracked stack; apply slow (+2 ticks before next advance) | `vfx_mudslide` | `sfx_mudslide` |
| 11 | `EARTH` | × Wet | **Mudslide (E)** | 1.4× | none | cleanse Wet; apply slow (+2 ticks before next advance) | `vfx_mudslide` | `sfx_mudslide` |
| 12 | `EARTH` | × Burning | **Ash Cloud** | 1.2× | own-lane 1-enemy-radius | cleanse Burning on origin; apply `Blind` to splashed | `vfx_ash_cloud` | `sfx_ash_cloud` |
| 13 | `EARTH` | × Chilled | **Avalanche** | 1.6× | none | cleanse Chilled; knockback 1 unit away from hero (subject to 2-tick knockback immunity) | `vfx_rock_slam` | `sfx_rock_slam` |
| 14 | `LIGHTNING` | × Cracked | **Stonesmith** | 2.0× | none | consume 1 Cracked stack; apply Shocked | `vfx_arc_stone` | `sfx_arc_stone` |
| 15 | `LIGHTNING` | × Burning | **Arc Storm** | 1.5× | cross-lane (target + 1 adj-lane closest enemy) | spread Shocked to splashed; consume Burning on origin only | `vfx_arc_storm` | `sfx_arc_storm` |

**Audio escalation rule:** chain ≥3 reactions within 2 sec window → play `sfx_chain_stinger` over the 3rd reaction; chain HUD lights up "3 CHAIN" (see §11).

**Not in matrix (base dmg only):** any tag × no status; `WATER` × Wet; `WATER` × Chilled; `FIRE` × Burning; `ICE` × Chilled; `EARTH` × Cracked; `EARTH` × Shocked; `LIGHTNING` × Shocked.

**Auxiliary statuses (reaction-only — no Function emits these directly):**

| Status | Effect | Duration |
|---|---|---|
| `Blind` | enemy's next attack misses | 1 attack instance |
| `Frozen` | enemy skips next attack + advance | 1 tick |
| `Bleed` (Vex Ult only — see §12) | enemy loses 5% maxHP per tick | 4 ticks |

---

## 6. Per-hero base weapons + lane assignment

**Lane assignment is locked at hero deploy — no player placement, no swap mid-run.**

| Lane | Hero | Base attack | Damage tag | Status emit | Base dmg | Atk cadence | Crit | HP |
|---|---|---|---|---|---|---|---|---|
| **0 (top)** | **Elara (Mage)** | ranged single-target, no range cap, any-lane closest | none | none | 0.8× | 1 atk/tick | 0% | 70 |
| **1 (mid)** | **Bran (Warrior)** | melee single-target, range 1.0×, own-lane closest | none | none | 1.0× | 1 atk/tick | 0% | 100 |
| **2 (bot)** | **Vex (Rogue)** | melee single-target, range 1.0×, own-lane closest | none | none + **innate +20% dmg vs `Burning` targets** | 0.9× | 1.2 atk/tick | 15% (2× crit) | 80 |

**Why these lane assignments:**
- Elara top: ranged + any-lane base = naturally a back-line support, but in 3-lane format she anchors a lane while reaching cross-lane (her base alone can hit lane 1 or 2 enemies, making her the "swing" hero).
- Bran middle: tank in the central lane, the natural target for AOE / Modifier-stack builds.
- Vex bottom: executor anchor, exploits Burning that Elara/Bran set up in adjacent lanes.

**FTUE single-lane phase:** during FTUE stages 1+2, only the middle lane (lane 1) is active. Solo Elara deploys to **lane 1** for the duration of these stages (override default lane 0). On Bran joining (F2), Elara returns to lane 0 (top), Bran takes lane 1 (mid). Vex joins at F4 cinematic, deploys to lane 2 (bot). See §13.

---

## 7. Lane corridor system (replaces grid)

3 horizontal lanes. Heroes anchored to **left third of screen** (visually walking right, camera-follow gives a stationary-hero illusion). Enemies spawn from **off-screen right** and walk left toward the heroes.

```
                                   Screen width →

    LANE 0 (top)    [Elara]→  · · · · · · · · ·  ←[e][e]  ⇐ spawn edge
                                                            (off-screen right)
    LANE 1 (mid)    [Bran]→   · · · · · · · · ·  ←[e][E][e]
                                                            (each lane spawns
    LANE 2 (bot)    [Vex]→    · · · · · · · · ·  ←[e]      independently)

                  ^                                       ^
              hero anchor                          enemy spawn line
              (left 1/3 of screen)              (right edge + buffer)
```

**Coord scheme:**
- **lane index** ∈ {0, 1, 2}. 0 = top, 2 = bottom. Fixed assignment per §6.
- **screen-x position** ∈ [0.0, 1.0]. 0.0 = hero anchor (left); 1.0 = spawn line (right). Fractional.
- Distance metric for cross-lane targeting: `dist = sqrt((Δlane)² + (k · Δx)²)` where `k = 3.0` (1 lane-stride ≈ 0.33 screen-x). Tunable in code.

**Hero movement:** heroes visually walk forward at constant speed (camera follows; heroes appear screen-stationary). All distance/range mechanics expressed in screen-x position. Heroes do not change lane.

**Enemy advance:** enemy spawns at screen-x = 1.0 in assigned lane. Walks left at speed `enemy.walk_speed` (varies per enemy type, default 0.05 screen-x per tick = reaches hero in ~20 ticks = ~10 sec at 0.5s/tick). On status-modify: `Chilled` × 0.5, `Frozen` × 0.0, `Wet` no change.

**Contact rule:** enemy reaches hero anchor (screen-x ≈ 0.0 in hero's lane) → engages. Enemy stops advancing, deals 1 dmg/tick to hero in melee until killed. Hero auto-attack continues normally.

**Hero death:** hero dies → that lane becomes "ghost lane" (enemies in that lane march past unopposed, dealing squad-wide damage of 2 dmg/tick per enemy past the anchor — distributed across surviving heroes). Mit-A behavior: shop + gold economy unchanged for survivors. See §15 UX edge cases.

**Boss footprint (Phase 5+):** a boss occupies all 3 lanes simultaneously (huge sprite that spans the corridor vertically). Single HP bar. Treats all 3 hero attacks as legal targets. Phase 4 slice skips boss.

---

## 8. Combat flow + tick cadence

### 8.1 Per-tick resolution order

1 tick = 0.5 sec at 1× speed. Player can toggle 2× speed.

Per tick, in order (locked):

1. **Status decay** — decrement remaining_ticks on every active status on every enemy + hero. Remove zero-tick statuses.
2. **Enemy advance** — apply walk_speed × status_modifiers; reduce each enemy's screen-x by speed; if screen-x ≤ 0, transition to engaged state. Apply knockback effects.
3. **Hero attack pass** — for each living hero in deploy order, call `resolve_active(hero) → AttackResult`. Result encodes targets + damage tags + status applies.
4. **Reaction resolve pass** — `element_mediator.gd` checks every hit landed in step 3 against `target_enemy.status_list` for matches in §5; dispatches reaction, applies dmg + status mutation; emits `reaction_triggered` signal (+ chain HUD increment).
5. **Death + cleanup** — kill enemies with HP ≤ 0 (status dies with enemy); kill heroes with HP ≤ 0 (lane becomes ghost); award gold per kill.

### 8.2 Wave / stage / world boundaries

- **Wave ends** when all enemies spawned for that wave are dead. Heroes keep walking forward (cosmetically); no enemies on screen.
- **Stage ends** after the 3rd wave clears (or 1st wave for FTUE stages 1+2). Forge break opens.
- **Forge break** = paused timeline, 8-10 sec. Player drags any remaining shop items into sockets. Tap **Continue** → next stage starts; shop resets (new 7-item pool).
- **World ends** after stage 5 (boss stage). Run rewards distributed via meta layer.

### 8.3 Signal emit ordering (when multiple reactions in 1 tick)

Reactions in step 4 above are queued in **hit-order** as they're emitted in step 3. VFX renders staggered at 0.1 sec per reaction (prevents on-screen overlap chaos at chain ≥3).

### 8.4 Enemy concurrency cap

Maximum **12 enemies on grid** simultaneously. Excess enemies queue in incoming-wave state off-screen until grid clears under cap. Prevents render + reaction storm collapse on mobile.

---

## 9. World structure — stage / wave / forge cadence

### 9.1 The world formula

Every world (=1 play session ≈ 4-5 min) follows this structure:

| Stage | Waves | Notes | Forge break before |
|---|---|---|---|
| 1 | 3 (FTUE: 1) | Normal (FTUE: Elara solo, lane 1 only, forced FIRE+WATER shop) | F0 (deploy phase at run start) |
| 2 | 3 (FTUE: 1) | Normal (FTUE: Elara solo, lane 1, full 7-slot shop) | F1 |
| 3 | 3 | Normal (FTUE: **+Bran joins** at F2 cinematic; lane 0 + lane 1 active) | F2 |
| 4 | 3 | Normal (Elara + Bran) | F3 |
| 5 (boss) | 3 (mini-boss W1, mini-boss W2, BOSS W3) | Boss stage (FTUE: **+Vex joins** at F4 cinematic; all 3 lanes active for boss climax) | F4 |

**Totals:**
- **FTUE world (= world 1):** 1 + 1 + 3 + 3 + 3 = **11 waves**, 6 forge moments (F0–F5).
- **Post-FTUE world:** 3 + 3 + 3 + 3 + 3 = **15 waves**, 6 forge moments.

**World transition (locked per D6 v3 = option C):** heroes persist across worlds w/ meta progression (Wittle-clone meta — see §19). Socketed Functions RESET each world (each world = fresh forge). Prevents late-world god-mode snowball.

### 9.2 Shop slow-populate (Mit-D)

Per stage, the 7-slot shop populates **across the stage's waves** so cognitive load is dispersed:

- **2 items** at stage start (immediate planning options visible)
- **3 items** spread across waves 1, 2, 3 (1 new item drops ~5 sec into each wave)
- **2 items** as wave 3 begins (final pop-in moment)
- **Stage break** (post-wave-3): all 7 items visible + 8-10 sec **paused chill time** — player consolidates final loadout before next stage.

**FTUE shape (stages 1+2 = 1 wave each):** different rhythm — 2 items at stage start, 2 items during wave, 3 items at stage break for the chill consolidation.

**New-item arrival cue:** brief icon flash on shop rail + soft "ping" audio (`sfx_shop_arrival`). No popup, no auto-tooltip — player drags attention voluntarily.

**Shop persistence:** items reset between stages (each stage = new 7-roll). Items NOT taken during a stage are LOST when the stage ends. Forces commitment.

### 9.3 Shop economy + RNG

- 5 slots populate per Mit-D rhythm; total 7 slots per stage.
- **Cost per Function (T1):** scales with stage. Stage 1 = 1g, Stage 3 = 2g, Stage 5 = 3g.
- **Re-roll cost:** 1g (single tap on shop header). Re-rolls only EMPTY slots from the next-to-populate queue (you can't re-roll items you haven't seen yet).
- **Gold per kill:** 1g standard; mini-bosses 5g; boss 20g.
- **Shop pity counter (locked per D11):** guarantees ≥1 Element-category Function per 2 stages (across consecutive shop pools). Prevents dry-streak frustration.
- **Tier drop rates (locked per §10):** stage-dependent — see §10.

### 9.4 Cognitive load dispersal (the design intent)

The whole shop slow-populate scheme exists for ONE psychological goal: distribute cognitive load across ~20-30 sec instead of dumping 7 items at once. Player thinks about permutations while watching auto-combat. By stage break, the decision is half-baked — they just consolidate. Matches Csikszentmihalyi flow theory: passive watching + active background-thinking = engagement without pressure.

---

## 10. Tiered Function system

Functions exist in 5 tiers. Tier increases multiply Function values (dmg, range, durations) and unlock minor visual flair.

### 10.1 Tier scale

| Tier | Name | Color | Stat × | Notes |
|---|---|---|---|---|
| **T1** | Common | white | 1.0× | base; only tier in Phase 4 slice |
| **T2** | Rare | green | 1.4× | upgraded VFX color tint |
| **T3** | Epic | blue | 2.0× | second VFX flourish on hit |
| **T4** | Legendary | purple | 2.8× | unique audio cue + screen flash on Active hit |
| **T5** | Mythic | gold | 4.0× | particle aura on socket; ult-charge generates 50% faster while equipped |

### 10.2 Merge rule (2-to-1 — locked per user)

- **2× T_n** same Function ID → **1× T_(n+1)** same Function ID
- Auto-merge happens on duplicate drop: drag T1 `FIRE` onto socket already holding T1 `FIRE` → instantly becomes T2 `FIRE`. Same socket position retained (Active stays Active).
- Cross-tier merges (e.g. T1 + T2) do not stack — they are different Functions to the merger.
- Full chain: 2×2×2×2 = **16 commons → 1 mythic**. Achievable in 2-3 worlds of focused merging.

### 10.3 Shop drop weights per stage (post-FTUE worlds)

| Stage | T1 % | T2 % | T3 % | T4 % | T5 % |
|---|---|---|---|---|---|
| 1 | 90 | 10 | 0 | 0 | 0 |
| 2 | 70 | 27 | 3 | 0 | 0 |
| 3 | 50 | 35 | 13 | 2 | 0 |
| 4 | 30 | 38 | 24 | 7 | 1 |
| 5 (boss) | 15 | 30 | 32 | 18 | 5 |

FTUE world (= world 1): forced T1 only across all stages — keeps onboarding clean. T2+ unlock in world 2.

### 10.4 Phase 4 slice scope

T1 only. Merge mechanic stubbed (visible "2/2 to upgrade" indicator on duplicate stack, but no T2 spawning). Tier system fully active starting Phase 5.

---

## 11. Forge UI — weapon-always-visible bottom rail

### 11.1 Bottom rail (the locked weapon-vis design)

**Always-on**, all combat + forge phases. Shows current squad loadout at a glance so player can plan permutations while watching auto-combat.

```
┌───────────────────────────────────────────────────────────────────────────┐
│   [Elara]   [A: FIRE-2★] [M: WATER-1★] [P: --]      HP 55/70 / Ult [██░]  │
│   [Bran]    [A: BEAM-1★] [M: --]        [P: --]      HP 80/100/ Ult [█░░]  │
│   [Vex]     [A: --]      [M: --]        [P: LEECH-1★] HP 65/80 / Ult [░░░]  │
└───────────────────────────────────────────────────────────────────────────┘
```

- Hero portrait (square, 64×64) + 3 socket pips (square, 56×56 each) + HP bar + Ult charge bar
- Socket pips show Function icon + tier badge (1★-5★). Empty = "--" placeholder.
- **Tap pip during combat:** shows behavior tooltip for 2 sec (no pause). 
- **Drag from shop onto pip during forge break:** swaps Function; old one discarded for half-cost gold refund.
- **Touch target ≥44pt** (mobile HIG compliance).
- **Dead hero row:** greyed + ✖ overlay, no interactions (Mit-A behavior: shop+gold continue for survivors, dead hero's row is a visual reminder).

### 11.2 Shop rail (top of screen)

```
┌───────┬───────┬───────┬───────┬───────┬───────┬───────┐
│FIRE 1★│WATER1★│LIGHT1★│  ░░░  │  ░░░  │  ░░░  │  ░░░  │
└───────┴───────┴───────┴───────┴───────┴───────┴───────┘
Gold: 7   Re-roll: 1g
```

- 7 slots horizontal at top of screen
- ░░░ = unpopulated (Mit-D will fill)
- Populated cards: Function icon + tier badge + cost in corner
- **Tap card during forge break:** preview behavior in all 3 sockets (which hero best fit)
- **Drag card to a hero's socket pip:** purchases + equips. Auto-merge if duplicate.
- **Tap re-roll:** rolls the unpopulated next-to-come items (not visible ones).

### 11.3 Combat HUD (between rail + shop)

```
              Wave 2 / 3       [Reaction Chain ×3 ⚡]        Stage 4
              [2× speed]       [Stage Telegraph: ⓘ]         [Pause]
```

- **Wave counter** top-left
- **Reaction Chain HUD** (NEW per E1 accepted): live counter ×N when reactions fire within 2 sec window. ×3+ triggers visual glow + chain stinger audio. Drops to 0 after 2 sec silence.
- **Stage Telegraph icon** (NEW per §17): tap during forge break to preview next stage's enemy mix + weaknesses
- **Speed toggle** + Pause button

### 11.4 Mobile screen budget (1080×1920 portrait reference)

- Top bar (HUD): 120px
- Shop rail: 200px
- Combat viewport (3-lane corridor): 1120px ← bulk of screen
- Bottom rail (weapon-vis): 380px
- Safe-area padding: ~50px each end
- Total: 1920px ✅

### 11.5 Accessibility

- **Color-blind safe palette:** 12 distinct colors (5 status × 5 tier overlap) chosen from Wong palette + tested via Coblis simulator (deuteranopia, protanopia, tritanopia).
- **Status icons distinguishable by SHAPE + color** — never color-only:
  - Burning = flame shape
  - Chilled = snowflake
  - Shocked = bolt
  - Wet = droplet
  - Cracked = chevron stack
- **Touch targets:** ≥44pt minimum (iOS HIG); 48pt preferred for shop cards and socket pips.
- **Audio:** every reaction has unique audio cue (§5 audio_hook column) so deaf-blind players + audio-only feedback users get full info.

---

## 12. Hero Ultimates — the juicy combo moments

Each hero has **1 hero-locked Ultimate**. Charge resource = squad-shared **Reaction Charge** bar.

**Charge rule:** every 3 reactions triggered by any hero → +1 Ult bar. Max 3 bars stored. Bars persist across waves until used.

**Tap hero portrait** (bottom rail) when ≥1 bar → fires that hero's Ult, consumes 1 bar.

### 12.1 Bran — "Leap & Slam"
- 1-tick wind-up: Bran sprite arcs upward off the lane (visibly airborne).
- Crashes onto the back-most enemy in his lane (highest screen-x); explodes for **5× base dmg** on landing enemy + 2 nearest cross-lane enemies (5 total at most).
- Applies `Cracked` (+2 stacks) to all hit enemies.
- Returns to home position in 1 tick (animation, invulnerable for 2-tick total).
- **Edge case (empty lane):** if no enemy in Bran's lane, target the most-advanced enemy across all lanes. If grid is empty, charge refunded.
- **Edge case (death mid-air):** if Bran takes lethal damage during airborne tick, animation completes (no damage taken until landing); on landing he dies in place. Ult dmg still resolves.

### 12.2 Elara — "Chain Storm"
- Spawns 8 LIGHTNING arc-jumps that chain across every `Wet` enemy on the grid (any lane).
- Each jump = 2× base dmg + applies `Shocked`.
- If no Wet enemies → degrades to "all enemies on grid take 1× LIGHTNING dmg" (failsafe; never wasted).
- Visual: 0.5 sec total stormburst, then return to combat tick.

### 12.3 Vex — "Phantom Strike"
- Teleports adjacent to lowest-HP enemy on grid (any lane). Cosmetic teleport — Vex returns to home lane after.
- 3 strikes at 200% each, crit-locked (always crit).
- Applies `Burning` + `Bleed` to target.
- **Edge case (no enemies on grid):** Ult charge REFUNDED (do not waste).

### 12.4 Ult State Machine (per Ult)

| Property | Bran Leap | Elara Storm | Vex Strike |
|---|---|---|---|
| Entry | tap portrait, ≥1 bar, ≥1 enemy on grid | tap, ≥1 bar | tap, ≥1 bar, ≥1 enemy on grid |
| Exit | landing crash resolved + return-home complete | 8 arcs resolved | 3 strikes resolved + return-home |
| Interruptibility | NONE — animation completes even if hero dies | NONE | NONE |
| Chain w/ another Ult | queue, fire after current Ult completes (1-Ult-per-tick cap) | same | same |
| Cost on entry | -1 Ult bar | -1 Ult bar | -1 Ult bar |
| Charge refund | refund if grid empty at entry | never | refund if grid empty at entry |

---

## 13. FTUE — staged hero unlock (per Mit-B revised)

**Replay condition:** FTUE plays on first run AND replays whenever `AccountState.reset()` clears the `ftue_complete` flag (debug reset button on Home already does this — no new code path needed). Useful for demos / showcase to multiple people.

### 13.1 World 1 (FTUE) — wave-by-wave script

| Stage | Wave | Heroes live | Shop | Enemy spawn | Tutorial overlay |
|---|---|---|---|---|---|
| **1** | W1 only | Elara at lane 1 | forced cards: `FIRE` + `WATER` (T1) only | 3 weak goblins, lane 1 only | "Drag FIRE to Elara's Active. Watch FIRE projectiles + Burning status." |
| | F1 break | — | — | — | "Try a Modifier — warps the Active beneath. Try WATER as Mod for Wet+FIRE multi-hit." |
| **2** | W1 only | Elara at lane 1 | normal 7-slot shop (Mit-D rhythm; T1 only) | 4 enemies, lane 1 only | "Watch the shop populate as combat plays. Plan your build." |
| | F2 break | — | — | **Bran joins cinematic** (`PullOverlay`). Elara moves to lane 0; Bran takes lane 1. | "When Elara's WATER hits a tile + Bran's swing with FIRE Mod = **STEAM** reaction. First Magicka moment." |
| **3** | W1 / W2 / W3 | Elara + Bran (lanes 0+1) | normal 7-slot, Mit-D rhythm | scaling enemies, lanes 0+1 only | hint: "Stack reactions to fill the Ult bar." |
| | F3 break | — | — | — | hint: "Tap Bran's portrait when Ult bar is full = Leap & Slam." |
| **4** | W1 / W2 / W3 | Elara + Bran | normal | lanes 0+1 | none |
| | F4 break | — | — | **Vex joins cinematic** (`PullOverlay`). Vex deploys to lane 2 for boss climax. | "Vex executes Burning targets. All 3 heroes now — full Magicka chain." |
| **5 (boss)** | W1 mini / W2 mini / W3 BOSS | Elara + Bran + Vex (all 3 lanes) | normal | all 3 lanes; mini-boss occupies single lane center, BOSS spans all 3 lanes | no overlay during boss; let player play |

**Mechanics during FTUE:**
- Locked heroes not shown in HUD or forge panel (gradual reveal).
- Lane assignments revealed progressively (lane 1 only → lanes 0+1 → all 3).
- Forced shop cards (Stage 1) ensure first reaction is reachable by FTUE end.
- Cinematic at Bran/Vex unlock = reuse `pull_overlay.gd` from 2_WC P0.
- Once `ftue_complete = true`, subsequent runs deploy all 3 heroes from world start with normal shop rolls.

### 13.2 Implementation notes

- `AccountState` gains `ftue_complete: bool` (default false; schema v3, see Appendix A migration).
- `WaveDirector` reads `ftue_complete` + world_index + stage_index to drive scripted vs open play.
- Boss visuals + AI = Phase 5 (slice has stationary 5× HP mini at end of stage 5 wave 3 only).

---

## 14. Test specification

Locked test surfaces. Must be green-light before Phase 5 graduation.

| Test surface | Type | Critical scenarios |
|---|---|---|
| `function_data.gd` loading | Unit | every of 12 Functions × 3 slot behaviors parses + matches §3 |
| `status_data.gd` lifecycle | Unit | apply, refresh, stack-max (Cracked 3-cap), natural decay at exact 0-tick boundary |
| `lane_state.gd` distance fn | Unit | own-lane vs cross-lane Euclidean math; tie-break determinism |
| `lane_state.gd` enemy advance | Unit | advance vs Chilled vs Frozen modifiers; knockback immunity 2-tick rule |
| `element_mediator.gd` reaction dispatch | Integration | each of 15 reactions fires under correct (tag × status) input; correct dmg_mult, splash filter, status mutation |
| `combat_v2.gd` tick order | Integration | status-decay before advance before hero-attack before reaction-resolve before cleanup |
| `ult_controller.gd` charge accumulation | Unit | +1 bar per 3 reactions; cap at 3; bar persistence across waves; refund on no-target Ults |
| FTUE script | Integration | stages 1+2 = 1 wave; F2 + F4 cinematics fire; lane assignments correctly toggled |
| `account_state.gd` v2→v3 migration | Unit | existing save w/o `ftue_complete` field defaults to false; v3 saves round-trip |
| Shop slow-populate | Integration | Mit-D 2/3/2 rhythm; pity counter ≥1 Element per 2 stages; T1-only in FTUE |
| Auto-merge | Unit | 2 × T1-FIRE on socket = T2-FIRE; socket position retained; different-Function drop just swaps not merges |
| Cracked stack rule | Integration | LIGHTNING × Wet on Cracked-stacked enemy = Electrocute dmg × Cracked multiplier; Cracked stacks NOT consumed |

---

## 15. UX edge cases

Locked behaviors for non-happy-path interactions.

| Interaction | Edge case | Locked behavior |
|---|---|---|
| Drag Function to socket | Drop on non-socket area (e.g., off-screen) | Card returns to shop slot. No purchase. |
| Tap Ult portrait | Tap during wave clear screen / forge break transition | Ult input buffered; fires on next valid tick. |
| Tap Ult portrait | Multiple Ult bars + spam-tap | 1 Ult per tick cap; remaining taps queue (max 1 queued). |
| Forge break expires | Player still dragging when timer hits 0 | Timer pauses while drag in progress; resumes on drop. |
| Run resume | App backgrounded mid-wave | Auto-pause on background; resume on foreground (1-sec ramp). |
| FTUE reset | Player resets via debug button mid-FTUE (e.g., wave 3) | FTUE replays from stage 1; `ftue_complete = false`. |
| Hero death | Last hero dies mid-wave | Wave completes (enemies despawn cosmetically); run over → result modal. |
| Hero death | Mid-stage death | Mit-A: dead hero greyed on bottom rail; shop + gold + Mit-D rhythm continue for survivors. |
| Ult charge | Refund on no-target Bran/Vex Ult | Bar refunded immediately on tap (UI feedback: bar fills back). |
| Shop card | Card populated mid-wave but player wants to tap during combat | Allowed — opens preview tooltip without pausing. Drag-equip during combat: gated to forge break only (combat is auto). |

---

## 16. Debug observability

Locked dev/QA toggles. Activated in debug builds via console or hotkey (not visible in player release).

| Feature | Hotkey | Behavior |
|---|---|---|
| Debug overlay | F12 | Show every enemy's `status_list` + remaining ticks + screen-x. Show every Function's resolution per attack tick. |
| FTUE skip | F11 | Set `ftue_complete = true`, save, restart current run with all 3 heroes deployed and full 7-slot shop. |
| Tier override | F10 | Cycle current run's shop tier weights (debug = T1-only / T3-only / T5-only). |
| Spawn override | F9 | Spawn 1 enemy of selected type in lane 1 (debug enemy registry). |
| Reaction log scrubber | F8 | Open in-game log of last 50 reactions with frame-precise replay capability. |

All toggles persist in `debug_overlay.gd` autoload, available only when `OS.is_debug_build()`.

---

## 17. Wave Telegraph (scout_intel revived)

Per locked D6-revised + user-requested feature: before each stage starts (during F0/F1/F2/F3/F4 forge breaks), player can tap **Stage Telegraph icon** (HUD) to preview the upcoming stage's enemy mix + key vulnerabilities. Drives forge decisions.

### 17.1 Telegraph display (medium granularity per D13)

```
┌────────────────────────────────────────────────────┐
│           Next stage: 3 waves                       │
├────────────────────────────────────────────────────┤
│  W1: ┌──────┐  ┌──────┐  ┌──────┐                  │
│      │🔵Slime│  │🔵Slime│  │ Gob  │                  │
│      └──────┘  └──────┘  └──────┘                  │
│      Weak: 🔥FIRE   Resist: ❄ICE                    │
├────────────────────────────────────────────────────┤
│  W2: ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐        │
│      │ Gob  │  │ Gob  │  │ Gob  │  │💀Skel │        │
│      └──────┘  └──────┘  └──────┘  └──────┘        │
│      Weak: ⚡LIGHTNING   Resist: 🔥FIRE              │
├────────────────────────────────────────────────────┤
│  W3: ┌──────┐  ┌──────┐                            │
│      │💀Skel │  │💀Skel │                            │
│      └──────┘  └──────┘                            │
│      Weak: 💧WATER       Resist: 💀DARK              │
└────────────────────────────────────────────────────┘
```

- Enemy portraits (icons) per wave
- 2 icons per wave: primary weakness + primary resistance
- Tap any enemy icon → expanded tooltip (HP, attack pattern, advance speed)
- Boss stage: shows mini-boss W1/W2 + final boss W3 (with phase preview Phase 5)

### 17.2 Implementation hook

- Extends existing 2_WC `account_state.gd` `scout_intel` data path (was per-run static, now per-stage dynamic).
- Per-enemy data in `enemy_data.gd`: new fields `weakness_tag: StringName`, `resistance_tag: StringName`.
- Telegraph overlay scene: `WaveTelegraph.tscn` + `wave_telegraph.gd`. Opens on icon-tap, dismissible.

### 17.3 Boss telegraph (Phase 5)

For boss stage (stage 5), telegraph reveals boss's phase mechanics: HP thresholds at which boss changes attack pattern, immunity windows, etc. Players plan stage-4 forge accordingly.

---

## 18. Playtest scenarios

Locked test scripts for Phase 4 slice + future polish gates.

### 18.1 New-player FTUE (5 testers, fresh saves)

1. **Stage 1 W1 (Elara solo, FIRE + WATER forced):** kill 3 goblins, infer Burning effect from VFX. Pass = no confusion at wave end.
2. **F2 cinematic (Bran joins):** observer can articulate "Bran is the new melee guy" within 5 sec of cinematic end.
3. **Stage 3 first Magicka moment (Elara WATER → Bran FIRE-Mod = Steam):** observer sees Steam reaction; first-reaction slow-mo + chain stinger fires. Pass = player can name the reaction without UI text.
4. **F4 cinematic (Vex joins):** similar — observer articulates Vex's role.
5. **Stage 5 boss:** at least 2 of 5 testers reach boss W3 alive.

### 18.2 Engagement test (mid-loop)

- Watch player attention during waves. Eye-track or behavior-observe: are they looking at the shop populating, or at combat, or both? Pass = 60%+ of wave time = combat-focused; remaining = shop-glances during slow moments.
- "Did you feel forge or combat was the engaging part?" — open-ended, target = both mentioned.

### 18.3 Reaction comprehension

- After 1 run, ask: "Name 3 reactions you triggered." Pass = 3+/5 testers can name ≥3 reactions.
- "Which hero set up the reaction, which hero fired it?" — pass = 2+/5 testers can attribute cross-hero combos.

### 18.4 Mit-A salvageable-death check

- Force-kill Bran in stage 2 W1 (via dev console). Observer: does the run feel doomed or salvageable?
- Pass = 3+/5 testers say "I think I can still win" within 10 sec post-death.

### 18.5 Skip-shop run abuse check (post-FTUE)

- Run with NO forge interactions (player never drops items into sockets). Pass criterion: run fails by stage 3 = natural difficulty curve adequate.

### 18.6 Stress: full-loadout stage 5 boss

- Forge all 9 sockets fully w/ T2-T3 Functions (via dev console). Confirm: boss is challenging but beatable in 2-3 ult cycles.

---

## 19. Deferred / open questions (out-of-scope for slice)

### 19.1 Out-of-scope for Phase 4 (slice)

- Tier system T2-T5 (T1 only in slice)
- Boss AI (single stationary 5× HP mini at stage 5 W3 only; Phase 5 adds real boss)
- All 12 Functions × full polish (slice = 6 Functions: FIRE / WATER / AOE / LIGHTNING / LEECH / BURST; chosen to enable Steam + Electrocute reactions)
- Wittle-meta-progression (hero levels, skill trees, equipment, talents, stars, dailies, season pass, idle income) — **direction locked: Wittle Defender clone**; design doc to author after Phase 4 feel-gate
- Monetization model (IAP / battle pass / cosmetic) — defer until post-slice playtest reveals what feels good to price
- 3-card in-combat module (§20) — **deferred contingency**; activate only if Phase 4 playtest shows forge-only feels lackluster
- Cosmetic shop, achievements, dailies, leaderboards
- Save-cloud sync, social features

### 19.2 Open product questions (deferred, no spec decision)

| ID | Question | Defer reason |
|---|---|---|
| P1 | Monetization model | Wait for post-slice feel data |
| P3 | Hero unlock economy post-FTUE (gacha? meta-shop?) | Wittle-meta design phase |
| P7 | Open-play retention hook (W7-10 in old wave count → boss in new stage count) | Observe in playtest first |
| P8 | Cohort positioning (Wittle vs AFK vs Brotato vs Slice & Dice) | Rewrite pitch artifact post-Phase 4 feel-gate |

### 19.3 TODOS deferred to Phase 5+

- Hero Ult shareable highlight clip auto-capture
- Mythic Function tier polish (5-star aura, unique audio)
- Function evolution L5+ (FIRE T5 + 5 reactions caused = INFERNO special tier)
- Personal-best chain counter persistent across runs
- Enemy carrying Function (each enemy has 1 active Function for emergent variety)
- Wave 1-10 daily challenge with modifier
- Achievement system (unlock 5 reactions, cause 100 Steam, etc.)
- Reaction replay (long-press portrait during forge break = slow-mo last 3 sec)

---

## 20. Module: In-Combat 3-Card Pick (DEFERRED CONTINGENCY — docs only)

**Status: documented but NOT in Phase 4 slice.**

**Activation gate:** if Phase 4 playtest reveals forge-only loop feels lackluster (<40% testers report engagement during waves), activate this module as Phase 5 patch.

### 20.1 Design overview

At the start of every wave (so per FTUE world: 11 triggers; per normal world: 15 triggers): auto-pause ~3-4 sec, 3 cards slide in. Player picks 1; effect applies for rest of stage (or rest of run — see card list). Hero-flavored passives + universal buffs.

### 20.2 Sample card list (12-15 starter pool)

| Card | Hero | Effect | Duration |
|---|---|---|---|
| Brand Sigil | Bran | +25% HP | this stage |
| Iron Stance | Bran | +20% dmg reduction | this stage |
| Fury Pulse | Bran | next 3 attacks = +50% dmg | next 3 atks |
| Elara Spark | Elara | +1 LIGHTNING jump | this stage |
| Frost Veil | Elara | enemies in Elara's lane -50% advance speed | this stage |
| Combust | Elara | Burning duration +2 ticks | this stage |
| Vex Step | Vex | crit chance +15% | this stage |
| Bleed | Vex | Vex hits apply 1-stack Bleed (5% maxHP/tick × 4 ticks) | this stage |
| Shadow Strike | Vex | next attack = guaranteed crit | next atk |
| Forge Gleam | universal | +5 gold | immediate |
| Tactical Eye | universal | next wave: shop pre-populates +1 free item | next wave |
| Synergy | universal | reaction dmg mults +20% | this stage |

### 20.3 Card weighting

3 cards drawn per wave from a deck weighted to deployed heroes (e.g., 40% Bran cards, 40% Elara cards, 20% universal cards during FTUE stage 1). Excludes cards for dead heroes.

### 20.4 Drag-swap alternative (REJECTED in favor of 3-card)

Alternative explored: drag-swap shop items onto sockets mid-wave (no pause). Rejected because it splits player attention away from combat reactions. 3-card auto-pause = cleaner agency beat.

---

## 21. Locked decisions register

| # | Decision | Source |
|---|---|---|
| 1 | 12-Function set | DRAFT |
| 2 | 15-reaction matrix | DRAFT |
| 3 | Status durations 3/3/2/4/4 | DRAFT |
| 4 | Central grid w/ 4-edge spawn | REVIEW-2 |
| **4-rev** | **Auto-runner 3-lane corridor (statuses on enemies)** | REVIEW-3 |
| 5 | WATER cross-lane spread (was 5-tile +-cross) | REVIEW-3 |
| 6 | Vex innate Burning exploiter | REVIEW-2 |
| 7 | Boss skipped in slice | REVIEW-2 |
| 8 | Modifier-without-Active warps base | REVIEW-2 |
| 9 | FTUE stages 1+2 = 1 wave each; Bran F2 cinematic; Vex F4 cinematic | REVIEW-3 |
| 10 | Wave + forge cadence: 3 waves/stage, 5 stages/world, F0-F5 forge moments | REVIEW-3 |
| 11 | Hero Ults: Leap & Slam / Chain Storm / Phantom Strike; 3-reaction charge | REVIEW-2 |
| 12 | World transition: heroes persist (Wittle-meta), Functions reset each world | REVIEW-3 |
| 13 | Hero level meta = Wittle clone (separate Phase 5 spec doc) | REVIEW-3 |
| 14 | Cracked = pure dmg-amp passenger, never consumed | game-design |
| 15 | Full HP regen between stages; hero dead = dead until run end (Mit-A salvageable: shop + gold continue for survivors) | game-design + Mit-A |
| 16 | Shop pity ≥1 Element per 2 stages | product-brainstorming |
| 17 | Tier system T1-T5; **2-to-1 merge ratio** | REVIEW-3 |
| 18 | Wave telegraph at medium granularity (portraits + weak/resist icons) | REVIEW-2 + user |
| 19 | Reaction chain HUD counter | game-design/CEO |
| 20 | Knockback immunity 2 ticks post-knockback | game-design |
| 21 | BEAM cardinal tie-break priority (own-lane only in lane format = no tie-break needed) | game-design |
| 22 | Multi-EARTH stack (Active+Mod) double-stacks Cracked (+2 per hit) | game-design |
| 23 | Color-blind palette + status icon SHAPE-distinguishable + ≥44pt touch targets | CEO |
| 24 | Weapon-always-visible bottom rail | user |
| 25 | 7-item shop / 3-wave stage / Mit-D 2/3/2 slow-populate | user |
| 26 | 3-card in-combat module = deferred contingency (docs only) | user-revised |

**LOCK gate:** user reads this revision end-to-end + signs off → status flips DRAFT/REVIEW-3 → `LOCKED`, Phase 4 vertical slice branch cuts. Below this line, implementation only.

---

## Appendix A — Implementation hooks (Phase 4 dev reference)

**Autoloads:**
- `lane_state.gd` — replaces grid_state. Tracks per-lane enemy list + screen-x per enemy + status_list per enemy. Exports `dist(a, b)` for cross-lane Euclidean.
- `element_mediator.gd` — reaction dispatch (signals: `hit_landed`, `reaction_triggered`, `chain_increment`).
- `ult_controller.gd` — charge accumulation + Ult dispatch.
- `wave_director.gd` — scripted FTUE + normal-world spawn schedules. Reads `ftue_complete` flag.
- `debug_overlay.gd` — F8-F12 hotkeys (debug builds only).

**Data resources:**
- `function_data.gd` (Resource): `id`, `category`, `active_behavior`, `modifier_behavior`, `passive_behavior`, `damage_tag`, `status_emit`, `base_dmg_mult`, `atk_speed_mod`, `tier (T1-T5)`.
- `status_data.gd`: `id`, `duration`, `stack_max`, `per_enemy_effect`, `decay_rule`.
- `reaction_data.gd`: `incoming_tag`, `existing_status`, `dmg_mult`, `splash_filter`, `splash_pattern`, `status_mutation`, `vfx_hook`, `audio_hook`.
- `enemy_data.gd`: extends 2_WC enemy w/ `weakness_tag`, `resistance_tag`, `walk_speed`, `lane_assignment_rule` (e.g. "any" / "specific" / "boss-all-lanes").

**Scenes:**
- `BattleView_v2.tscn` (Phase 4 throwaway, graduates to `BattleView.tscn` in Phase 5): 3-lane corridor renderer, hero anchors, enemy sprites, status pip overlays, reaction VFX bus.
- `ForgePanel_v2.tscn`: 7-slot shop rail + 3-hero bottom rail with sockets.
- `WaveTelegraph.tscn`: pre-stage enemy preview overlay (§17).
- `ChainHUD.tscn`: reaction chain ×N counter (top of combat HUD).

**AccountState v3 migration:**
- New field: `ftue_complete: bool` (default false).
- v2 → v3 migration: existing saves get `ftue_complete = false` on load (replays FTUE for existing playtesters — desired for showcase). v3 saves include the field.
- Test case: `test_account_state.gd` validates v2 → v3 migration + round-trip.

**Reuse from 2_WC P0:**
- `account_state.gd` schema v2 → v3 extension (1 bool added).
- `hero_progress.gd` unchanged.
- `pull_overlay.gd` reused for FTUE cinematics (Bran/Vex unlock).
- `home.gd` + Home.tscn unchanged (debug reset btn already in place).
- `result_modal.gd` + ResultModal.tscn unchanged.
- `screenshot_helper.gd` (AUTOSHOT) reused for Phase 4 visual QC.
- TDD harness pattern (`Test*.tscn` + `_check` + headless quit) reused for new test surfaces in §14.

**Dying systems (do not extend):**
- `combat.gd` — rewritten as `combat_v2.gd`.
- `grid_state.gd` (was in REVIEW-2 plan) — never authored; replaced by `lane_state.gd`.
- `shop.gd` — rewrite as `shop_v2.gd` for 7-slot slow-populate.
- `weapon.gd` / `part_data.gd` / `recipe_data.gd` — delete (Phase 5).
- `battle_view.gd` — rewrite as `BattleView_v2.gd`.
- `forge_panel.gd` — rewrite as `ForgePanel_v2.gd`.
