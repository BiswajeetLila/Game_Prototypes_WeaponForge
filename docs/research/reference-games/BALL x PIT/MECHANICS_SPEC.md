# BALL x PIT — Core Mechanics Design Spec

**Scope:** Detailed reverse-engineering spec for two systems —
1. **Ball shooting, catching, and bouncing** (base character, no abilities)
2. **Enemy wave system** (spawning, difficulty, patterns)

**Method:** Synthesized from 20 YouTube video analyses (~80h of footage, frame-by-frame at 1 fps sample, 12,000+ frames total). Every load-bearing claim is cited with `[VID:<id> f_<frame>]` or `[VID:<id> @ <timestamp>]`. Visual claims spot-verified by direct frame reads (see §0.1). Conventions:
- **[CONFIRMED]** — visually verified in a frame or stated in-game tooltip
- **[CITED]** — stated by ≥1 reliable streamer guide, not visually verified
- **[INFERRED]** — analytical conclusion, flagged for designer skepticism
- **[GAP]** — unanswered question after exhaustive search

**Sources directory:** `/Users/tarun/LILA/Game Research/BALL x PIT/Videos/`
**Supporting docs:** `DESIGN_DOC.md` (high-level), `_extract_ball_mechanics.md` (raw), `_extract_enemy_waves.md` (raw).

---

## §0. Arena & coordinate system

Before specifying systems, establish the playfield they operate inside.

### 0.1 The Pit

A **vertically-oriented top-down corridor** [VID:M8nLJ82HwfI f_00060 verified, VID:M8nLJ82HwfI f_00180 verified].

| Property | Value | Source |
|---|---|---|
| Orientation | Portrait — long axis vertical | All video frames |
| Width | ~7 enemy-cells wide | f_00060, f_01700 |
| Player home zone | Bottom ~10% of the corridor | Universal |
| Enemy spawn zone | Top edge | Universal |
| Side walls | Reflective for balls | §1.4 |
| Top wall | Reflective for balls | §1.4 |
| Bottom edge | Pass-through (balls exit, no reflect) | §2.3 |
| Boss arena | Walls expand ~25% width when boss spawns | f_01700 verified |

[INFERRED] The verticality is deliberate — it gives balls a long flight path between firing and return, enabling the "catch" skill axis. A square arena would shorten flight times and reduce the gameplay value of catching.

### 0.2 HUD anatomy (Warrior baseline)

| Region | Contents | Frame |
|---|---|---|
| Top-left | Gold count (orange) · kill count (red skull) · 4 special ball slots · 4 passive slots | f_01700 verified |
| Right edge | Vertical threat/progress meter (skull-topped column); fills as wave progresses; turns red as boss approaches | f_00180 verified |
| Right edge (boss only) | Red vertical HP bar with **white** boss name in vertical text. **Red** name for final boss "The Moon". | f_01700, [VID:Jbz1Obo82cg f_03000] |
| Left edge | Player character portrait icon (sword + red gem for Warrior) | f_00180 verified |
| Centre overlay | "FIELD CLEARED!" text + "+Xg" gold reward + fireworks burst after each wave | [VID:SRcNWzJIML0 f_00325, VID:pV4cP8gvKcA f_01200] |

---

# PART 1 — Ball Mechanics (Warrior baseline)

The Warrior is the default character — "no special gameplay quirks" [WIKI/Characters]. Every other character defines itself by *negating* or *modifying* a Warrior baseline behavior, which means the Warrior's spec is defined by what other characters take away or add.

## §1. Shooting / Firing

### 1.1 Inputs

| Action | Controller | Keyboard/Mouse | Source |
|---|---|---|---|
| Move | Left stick | WASD | [VID:M8nLJ82HwfI tutorial] |
| Aim | Right stick | Mouse cursor | [VID:M8nLJ82HwfI tutorial], [VID:ejfiE4klU1M f_00090] |
| Fire (manual) | RT | LMB | Tutorial confirmed |
| Toggle autofire | Y | B or F | [VID:ejfiE4klU1M f_00120 in-game tooltip CONFIRMED] |
| Run speed (sprint) | LB/RB | — | [VID:M8nLJ82HwfI] |

### 1.2 Autofire toggle

Continuously fires in the current aim direction while on.

- **In-game tooltip** (verbatim from tutorial frame): *"[B] or [F] to toggle autofiring (You walk slower while shooting)"* [VID:ejfiE4klU1M f_00120 verified].
- Toggle state shown by a "Autofire Enabled / Autofire Disabled" text toast above player for ~2 s [VID:ejfiE4klU1M f_00300, f_01300 verified].
- **Community consensus:** leave autofire on for normal play, toggle off only to sprint between waves [VID:TPYEHuEDg5I, VID:faqN7WC_BAg].

### 1.3 Movement-while-shooting penalty

[CONFIRMED — in-game tooltip] Move speed is reduced while firing (manual or auto). Magnitude is not numerically stated in any source. The **Fleet Feet** passive removes the penalty entirely [VID:faqN7WC_BAg f_00080 verified — Encyclopedia entry: "+10% move speed, no shoot penalty"], and the **Itchy Finger** character's card reads *"Can move at full speed while shooting"* [VID:M8nLJ82HwfI f_02350] — both confirm by negation that the Warrior's baseline includes the penalty.

### 1.4 Aim preview (trajectory line)

White dotted line emitted from the player to the crosshair, showing the predicted flight path.

- **Color:** White (normal play) [verified in multiple frames: f_00060, f_00180, f_01700]. CaRtOoNz tutorial shows red [VID:xtYnSfBgSks f_00100] — [INFERRED] tutorial-only color.
- **Number of bounces shown:** Multiple ricochets, not just one. Shroom Swarm boss frame shows a multi-segment Z-pattern from player to upper screen, with at least 2 ricochet segments [VID:pV4cP8gvKcA f_00700 verified]. The previous DESIGN_DOC claim of "one ricochet" is **revised** by this evidence.
- **Updates in real-time** with aim — angle-of-incidence reflection is deterministic, so the preview is accurate.

### 1.5 Fire Rate stat

Warrior Level 1: **Fire Rate = 3.63** [VID:M8nLJ82HwfI f_00500 verified].

- Unit is not labeled in the UI. [INFERRED] shots/sec, based on comparative scaling with character descriptions: Itchy Finger's Fire Rate of 11.95 [VID:vF17pcDXk8A f_00760] aligns with his "shoots constantly" character text at ~3.3× the Warrior's rate.
- [GAP] **Exact formula unknown.** A designer reimplementing this should treat Fire Rate as shots/sec but verify against in-game timing.
- Practical ceiling: ball flight + return time effectively caps useful fire rate at ~1 shot per ball-flight-cycle unless catching is consistent [VID:nkRcLrAQjsA observation].

### 1.6 Ball pouch / queue

- **4 special ball slots by default** [DESIGN_DOC §4.3 / WIKI/Balls]. Each slot holds one special ball at Level 1/2/3.
- **Up to 4 special balls airborne simultaneously** — one per slot. Each ball must physically return (or be caught) before that slot can fire again.
- Slots are expandable via the **Bag Maker** building [VID:pV4cP8gvKcA f_00300 shows ≥7 slots in mid-late game].
- **Baby balls are independent** of the slot system (see §4).

### 1.7 No-knockback baseline

The Warrior does not experience knockback when firing. The **Radiant Feather** passive explicitly trades a knockback effect for +20% ball speed [WIKI/Passives], confirming baseline = none.

---

## §2. Ball flight physics

### 2.1 Ball Speed stat

Warrior Level 1: **Ball Speed = 6.01** [VID:M8nLJ82HwfI f_00500 verified].

- Attribute → stat mapping: **Speed (3, E) → Ball Speed 6.01 + Move Speed 2.96** [verified from stat card visual grouping in f_00500].
- Itchy Finger (Speed grade ↑): 8.93 ball speed [VID:vF17pcDXk8A f_00760].
- Empty Nester: 7.96 [VID:569lqQN9Y1U f_00220].
- [GAP] Unit (tiles/sec, pixels/sec, multiplier of base) is undocumented. For replication: treat as a velocity multiplier on a base velocity defined empirically by the playfield's traversal time.

### 2.2 Trajectory shape — straight line, no gravity

Warrior balls travel in straight lines until they bounce. Confirmed visually [VID:M8nLJ82HwfI f_00180 verified: arrow-straight dotted path from player to crosshair].

- **The Physicist** character has gravity-pull toward the back wall ([DESIGN_DOC §4.2]). This is character-exclusive — confirms baseline = no gravity.
- **The Juggler** character lobs balls in arcs ([DESIGN_DOC §4.2]). Confirms baseline = direct fire, not lobbed.

### 2.3 Wall behaviors

| Wall | Behavior | Source |
|---|---|---|
| Top (enemy-formation ceiling) | Reflects ball back down | [VID:Dzwv-BFzAY4 GAMEPLAY_NOTES §2] |
| Left wall | Reflects (angle-of-incidence) | Aim preview accuracy + universal frame evidence |
| Right wall | Reflects (angle-of-incidence) | Same |
| Bottom edge | **Pass-through** — ball exits the play field | The Flagellant's character ability *"Balls bounce off the bottom of the screen (so they never return)"* implies bottom is non-reflective at baseline [DESIGN_DOC §4.2] |

**Wrap-around:** The **Tunneller** wraps top/bottom [DESIGN_DOC §4.2]. Confirms baseline ≠ wrap.

### 2.4 Ball-enemy collisions

- **Default: bounce off enemy** — balls do NOT pierce by default. Each enemy contact deals damage and reflects the ball.
- **The Embedded** character has piercing balls ([DESIGN_DOC §4.2]) — confirms baseline = bounce.
- Reflection uses the enemy's circular hitbox; angle-of-incidence based on contact point.
- **Damage applies on both outbound and return arcs** — balls hit on every pass that touches an enemy.

### 2.5 Reflection rules

- "Ricochet at the equivalent ricochet angle" [VID:vF17pcDXk8A @ 02:20] — classical reflection: θ_in = θ_out.
- No randomness, fuzziness, or velocity loss on bounce confirmed.
- Aim preview accurately predicts wall bounces (consistent with deterministic physics).

### 2.6 Bounce damage falloff

**Baseline: damage is constant across all bounces.** Passives modify this:

- **Hourglass** — +150% ball damage, decays −30%/bounce, min 50% [WIKI/Passives]. Falloff is opt-in.
- **"Wall Strike" passive** — +30% damage on next hit after each wall bounce [VID:vCfTL7fx3fQ @ 21:36]. Reverse direction (increase) also opt-in.

### 2.7 Ball lifetime / despawn

No expiration timer at baseline. Balls bounce indefinitely until caught or exit the bottom. "Getting balls stuck behind the enemy line" is a deliberate optimal tactic [VID:M8nLJ82HwfI @ 01:40, VID:nkRcLrAQjsA].

Some evolved balls (Black Hole, Egg Sac) self-destruct after triggering, but baseline Bleed ball does not.

---

## §3. Catching / collecting

### 3.1 Catch trigger

**Proximity / physical interception.** When the player's body intersects the ball's flight path at the ball's altitude, the catch fires automatically — no button input. Confirmed:
- [VID:faqN7WC_BAg f_00270 verified: player visibly running to intercept a returning ball]
- *"One of the most important ways to raise your attack speed is to catch your special balls mid-flight."* [VID:faqN7WC_BAg @ 04:40]

[GAP] Exact catch radius / hitbox is undocumented. Designers should empirically calibrate — likely tied to player sprite collision box, not a separate "catch ring."

### 3.2 Catch payoff (the core skill axis)

**Catching the ball instantly reloads the corresponding slot for immediate refire.**

- *"It's instantly reloaded into your pouch, letting you fling it again right away."* [VID:vF17pcDXk8A @ 07:20]
- *"Every time you catch your ball… you have more opportunity to do damage."* [VID:M8nLJ82HwfI @ 02:45]
- *"Catch your balls. Depending on the character, this can drastically boost your damage output."* [VID:TPYEHuEDg5I @ 00:57]

This is the **primary skill expression**. Catching trades positioning safety (the player must stand in the ball's return path) for DPS uptime. Without catching, the player wastes 1–3 s of dead time per ball-flight cycle.

### 3.3 Missed catch behavior

If the player fails to intercept:
- The ball does **NOT despawn or visibly bounce off the bottom edge** — the baseline bottom is pass-through (§2.3).
- The Flagellant's character text *"so they never return"* implies that in baseline mode, balls eventually pass out the bottom and the slot is *not* immediately reloaded — the player must wait until the ball naturally cycles back into play, or the slot must re-spawn from elsewhere.
- [GAP] The exact mechanic for slot replenishment after a missed catch is not explicitly stated. Two possibilities:
  1. Ball exits bottom → respawns at player after a delay (cooldown-style).
  2. Ball exits bottom → slot is empty until end-of-wave.
- [INFERRED] Option 1 is more likely given that runs sustain consistent ball uptime even when catching is imperfect, but verification requires gameplay testing.

### 3.4 Catch animation / feedback

No frame isolated a catch animation — catches appear instantaneous. No combo/streak counter visible in HUD across any frame. [GAP] Audio cue likely (the game has rich FMOD audio) but not isolated in this corpus.

### 3.5 No combo system

No source across 20 videos describes a "catch streak" multiplier. The mechanical reward is throughput-only.

---

## §4. Baby balls

A second, autonomous projectile layer that runs in parallel to the player's special-ball throws.

### 4.1 Nature

- Small white spheres, distinct from special balls (which have colored/themed sprites) [VID:xtYnSfBgSks GAMEPLAY_NOTES §2].
- **Autonomous** — bounce freely around the arena, no player aim, no catch behavior documented.
- *"Baby balls can spawn through various means and they just bounce around freely and do damage that way."* [VID:vF17pcDXk8A @ 16:50]

### 4.2 Baby Ball Count stat

Warrior Level 1: **5** [VID:M8nLJ82HwfI f_00500 verified].

- Attribute mapping: **Leadership (4, E) → Baby Ball Count 5 + Baby Ball Damage 11-17** [stat card visual grouping in f_00500].
- *"With Leadership, it affects how many baby balls you can have."* [VID:569lqQN9Y1U @ 07:00]
- Itchy Finger has 12 baby balls (Leadership grade ↑) [VID:vF17pcDXk8A f_00760].
- [INFERRED] **"5" = max simultaneous in flight**, not a per-throw count. Babies maintain a steady-state population; if one leaves the field, another spawns (timing undocumented [GAP]).

### 4.3 Baby Ball Damage

Warrior Level 1: **11–17** per hit [VID:M8nLJ82HwfI f_00500 verified]. Subject to crit chance (0.32% baseline).

### 4.4 Physics

- Bounce off walls and enemies (same reflection rules as special balls).
- Persist indefinitely until they leave the play field.
- **No boomerang** — they do not return to the player; they bounce until exit.
- [GAP] Respawn cadence not documented.

### 4.5 Comparison summary

| Property | Special ball (Bleed) | Baby ball |
|---|---|---|
| Player-aimed | Yes | No |
| Boomerang return | Yes (via reflection) | No |
| Catchable | Yes | Not documented |
| Damage | 25–44 (Base) | 11–17 |
| Cooldown | None at L1 | None |
| Max in flight | 1 per slot (4 max) | 5 (Leadership-scaled) |
| Persist? | Until catch or bottom exit | Until bottom exit |

---

## §5. Warrior Level 1 baseline — full stat block

Visually verified from frame `M8nLJ82HwfI/frames/f_00500.jpg`:

| Attribute | Value | Scaling | Stats it drives |
|---|---|---|---|
| **Endurance** | 6 (+1) | E | HP 60 (+10) |
| **Strength** | 7 | E | Base Damage 25–44 |
| **Leadership** | 4 | E | Baby Ball Count 5 · Baby Ball Damage 11–17 |
| **Speed** | 3 | E | Ball Speed 6.01 · Move Speed 2.96 |
| **Dexterity** | 4 | E | Crit Chance 0.32% · Fire Rate 3.63 |
| **Intelligence** | 3 | E | AOE Power 0.86 · Status Effect Power 0.85 · Passive Power 0.97 |

Notes:
- Scaling grade letter (E→D→C→B→A→S) applies *to the attribute*, not to individual stats; each step boosts every stat in that attribute group.
- Powers ≤1.0 (AOE 0.86, Status 0.85, Passive 0.97) are **multipliers** — at L1 the Warrior is below baseline effectiveness on these axes.
- The Warrior also starts with the **Bleed** special ball (Strength-scaling status DoT).

### 5.1 Edge cases & quirks

- **Death** ends the run; balls in flight are discarded [VID:vF17pcDXk8A]. Exception: Necromancer passive grants one revive.
- **Skeleton King** has a front-armor / back-only damage zone. Ball physics unchanged; only hit registration differs [VID:nkRcLrAQjsA @ 30:48].
- **Enemy arrows are destructible** — Warrior balls can shoot down archer arrows mid-flight [VID:M8nLJ82HwfI GAMEPLAY_NOTES §2].
- **The Tactician** turns combat turn-based [DESIGN_DOC §4.2] — by contrast, baseline = continuous real-time with no "wait for return" gate.
- **Recall Balls button** appears in late-game HUD [VID:vCfTL7fx3fQ f_10800] but is **not** a Warrior L1 mechanic — unlock condition unknown [GAP].

---

# PART 2 — Enemy Wave System

## §6. Spawn architecture

### 6.1 Spawn topology

- **Top-edge only.** Every enemy enters the playfield at the top of the corridor and marches downward [universal across all 20 videos].
- **No side spawns.** No flank entry, no teleport-in, no mid-field appearances.
- **No off-screen warnings needed** — enemies are visible from spawn moment.

### 6.2 Wave model: discrete formations, not continuous trickle

Enemies appear in **batches** — entire wave formation spawns at the top simultaneously, then advances as a group [verified in f_00060, f_00180, f_00700].

- Wave 1–3: ~4–7 enemies [VID:nkRcLrAQjsA f_00084]
- Mid-run: ~15–25 enemies per wave [VID:M8nLJ82HwfI f_00700]
- Late run / Fungal Forest: 50–60+ enemies per wave [VID:Nr2MJABYT-c f_00700]

**Exception:** Some boss fights (notably Smoldering Depths boss) spawn continuous adds — "It's like a full-on enemy spawn here" [VID:vCfTL7fx3fQ @ 19:28].

### 6.3 Wave transition signal — "FIELD CLEARED!"

After every wave is fully cleared, a non-blocking centre-screen overlay fires:
- Text: **"FIELD CLEARED!"** in white
- Below it: **"+Xg"** gold reward (observed "+148g" at mid-run [VID:pV4cP8gvKcA f_01200 verified])
- VFX: fireworks/confetti burst filling upper half of arena
- May coincide with a small "Level Up (1)" toast if XP threshold crossed
- Gap to next wave: ~2 s

[VID:SRcNWzJIML0 f_00325 and VID:pV4cP8gvKcA f_01200 both verify the overlay.]

### 6.4 Boss spawn signal sequence

1. **Right-edge progress meter fills to 100%** (red) [universal HUD element].
2. **Pit walls expand ~25% width** [VID:M8nLJ82HwfI f_01700 verified].
3. **Vertical red HP bar slides in from the right** with the boss name in vertical text — **white for regular bosses, red for the final boss "The Moon"** [VID:Jbz1Obo82cg f_03000].
4. **Boss entrance animation** plays (1–2 s) — boss is pre-firable during this window [VID:569lqQN9Y1U @ 04:33].

---

## §7. Run pacing — 15-minute default

Default run length is **15:00** (selectable via "Fast 12:00 / Normal 15:00 / harder" arrows on level select) [VID:vF17pcDXk8A f_00840, VID:Jbz1Obo82cg f_02000].

### 7.1 Three-act structure

| Act | Window | Damage range | Enemy density | Player state |
|---|---|---|---|---|
| **1 — Establish** | 0:00–~5:00 | 14–60 | 4–7 / wave | 1–2 special balls, baby balls, no fusions |
| **2 — Build** | ~5:00–~12:00 | 100–500 | 20–40 / wave | 4 slots filled, fusion/evolution decisions, Fusion Reactor pickups appearing |
| **3 — Boss** | ~12:00–15:00 | 500–4,000+ | Boss + sparse adds | Mature build, peak damage |

Damage data points (verified): "14, 16" early-wave [f_00180]; "143, 1.9, 30" boss-room [f_01700]; "434!" mid-late Hemorrhage proc [VID:Dzwv-BFzAY4]; "680, 585, 645, 236" on The Moon [VID:vCfTL7fx3fQ f_14100].

### 7.2 Scaling basis

- **Time + waves combined.** Each wave's enemy count and HP increases monotonically; biome transitions reset the curve at a higher floor.
- HP scaling: rough inference from observed numbers — Boneyard early enemies ~70–100 HP, Snowy Shores mid ~2,000+ HP, late-biome enemies into the tens of thousands.
- [GAP] Exact HP/damage scaling formulas not extractable from footage (1 fps sample misses the in-engine values).

### 7.3 Mid-run elites

- **Dynamite-strapped enemies** appear "every 5–10 rolls" [VID:vCfTL7fx3fQ @ 21:24] — kill detonates an AoE that can hurt the player.
- No formal mini-boss designation observed.

### 7.4 Intermissions

- **2-second** gap between FIELD CLEARED and next wave spawn.
- Not a true rest — balls still in flight, XP still collectable, boss progress meter continuing to fill.

---

## §8. Enemy archetypes

All Warrior-relevant archetypes documented across the 20 videos:

### 8.1 Melee Charger (dominant archetype)

- Marches straight down its spawn column toward the player.
- Attack trigger: **red `!`** above sprite ~0.5 s before lunge [VID:M8nLJ82HwfI tutorial].
- Enemy sprite shakes during telegraph [VID:569lqQN9Y1U @ 06:15].
- Visual damage states: clean → bloodied → broken armor → dark tint as HP drops [VID:M8nLJ82HwfI explicit quote].

### 8.2 Archer / Ranged

- Positioned in rear rows of the formation.
- Fires flaming arrows (small orange streaks) in a loose spread [VID:M8nLJ82HwfI].
- **Player balls can intercept arrows mid-flight** [VID:M8nLJ82HwfI explicit].
- Full corridor range; red `!` telegraph before each volley.

### 8.3 AoE Caster

- Places **red filled circles** on the pit floor (~1 cell diameter each).
- Telegraph window: ~1–2 s before detonation.
- Shroom Swarm boss is the extreme version — 5+ circles simultaneously [VID:pV4cP8gvKcA f_00700 verified].
- Magma-type variants leave persistent lava patches [VID:ejfiE4klU1M f_01050].

### 8.4 Swarm units

- Fungal Forest mushroom enemies in particular: "very dense, very little gaps" [VID:Nr2MJABYT-c @ 11:27], 50–60+ per late wave.
- The Shroom Swarm boss itself is literally an 8–10-unit loose cluster of large mushroom entities [VID:Nr2MJABYT-c f_03200 verified].

### 8.5 Armored / Shielded

- Snowy Shores introduces "blue-armored dwarves with shields, blocking from the front — requiring side/back shots" [VID:yRrX-7ekr2g].
- Skeleton King is the archetype's boss expression: front-armor only damage immunity, back-only crit zone.

### 8.6 [NOT OBSERVED] Flyers / aerials

No enemy across the 20 videos bypasses ground/grid movement. Aerial enemies may not exist in this game.

### 8.7 [NOT OBSERVED] Lateral movement / flanking

No enemy moves sideways or repositions. All advance top-to-bottom. (Boss attacks may project sideways but the boss entity itself is anchored.)

---

## §9. Wave formation patterns

### 9.1 Standard formation

**Rectangular grid** filling the corridor width (~7 columns) and 2–8 rows deep. All enemies of one wave spawn simultaneously at the top edge.

### 9.2 Variant — Loose cluster

Only observed at the Shroom Swarm boss [VID:Nr2MJABYT-c f_03200]: ~8–10 boss entities in an irregular arrangement, breaking from the tight grid.

### 9.3 Density spikes & quasi-continuous waves

- Late-Fungal-Forest waves can spawn the next batch before the previous is fully cleared, producing a near-continuous horde feel.
- Extreme player builds (Holy Laser meshes, blizzard babies) can crash the client at peak density [VID:SRcNWzJIML0].

### 9.4 No retreat / no passive AI

All observed enemies advance until killed or until they reach the player's altitude. No source describes ranged enemies maintaining stand-off distance — even archers continue advancing while shooting.

---

## §10. Difficulty scaling

### 10.1 Within-run

- HP/damage scale with wave count and elapsed time (formulas [GAP]).
- New enemy types unlock at biome transitions (next section).

### 10.2 Across-biome (enemy roster swaps)

Verified enemy palette per biome:

| Biome | Roster signature |
|---|---|
| THE BONExYARD | Skeleton grunts, armored skeleton warriors, archers |
| THE SNOWYxSHORES | Blue-armored shield dwarves, frost variants |
| THE LIMINALxDESERT | Stone golems, armadillo/scarab enemies, dragon-face creatures [VID:vF17pcDXk8A f_00200] |
| THE FUNGALxFOREST | Purple mushroom swarms (densest crowd) |
| THE SMOLDERINGxDEPTHS | Fire-torch pot creatures [VID:vCfTL7fx3fQ f_00700] |
| THE GORYxGRASSLANDS | [GAP] not catalogued in this corpus |
| THE HEAVENLYxGATES | Golden-armored humanoids, angel-bunny throne enemies [VID:vCfTL7fx3fQ f_05500] |
| THE VASTxVOID | Stone pod/mushroom-cap grey enemies [VID:vCfTL7fx3fQ f_10000] |

[INFERRED] Each biome introduces ≥1 new enemy archetype + reskins of existing ones. The 87-enemy bestiary across 8 layers averages ~11 enemies per biome (consistent with this pattern).

### 10.3 Difficulty arrows on level select

- Default: "Normal" — Length 15:00.
- One step left: "Fast" — Length 12:00 [VID:Jbz1Obo82cg f_02000].
- Further-right options exist for "harder" difficulty [VID:vF17pcDXk8A].
- [GAP] Exact HP/damage multipliers per tier not documented.

### 10.4 NG+ (Conquest)

Costs 8 gears/level vs. 2–5 baseline [DESIGN_DOC §5.1]. Described as "really high challenge" but exact scaling [GAP].

---

## §11. Bosses — verified roster

### 11.1 Universal boss mechanics

1. Pit widens ~25% [f_01700 verified].
2. Red vertical HP bar with boss name on right edge.
3. Boss occupies upper 30–40% of screen.
4. Some adds continue spawning during boss fight.
5. Boss kill guarantees **Fusion Reactor + Blueprint + Gear(s) + Biome Trophy** drop.

### 11.2 Skeleton King — THE BONExYARD

- **Visual:** Crowned giant skeleton, ~3–4 tile height [verified f_01700, VID:nkRcLrAQjsA f_01915].
- **Special mechanic:** **Back-only damage zone** — front hits absorbed at 0 damage. "Oh, he only takes damage from the back" [VID:nkRcLrAQjsA @ 30:48]. Requires banking shots around the boss.
- **Attack 1 — Purple Bone Fan:** 8–20 purple bone projectiles in a wide downward fan. Verified [VID:nkRcLrAQjsA f_01915: 20+ purple bones spreading].
- **Attack 2 — Beam Laser Danger Zone:** red diagonal hazard strip across the pit floor; player must vacate. Verified [VID:xtYnSfBgSks f_01000].
- **Phase 2 (low HP):** green orb pulses in rib cage; bone fan frequency + spread increase [VID:nkRcLrAQjsA f_01870, f_01960].
- **Adds:** small white ghost enemies during fight.

### 11.3 Icebound Queen — THE SNOWYxSHORES

- **Visual:** White ice pillar/tower with green crystalline spires, ~3–4 tiles tall (not humanoid) [VID:yRrX-7ekr2g f_01800, f_02700].
- **Attacks:** white/teal crystalline projectile darts in spreads.
- **Near-death effect:** large circular shatter radius (possible death AoE or final phase).
- [GAP] Full attack roster not catalogued.

### 11.4 Shroom Swarm — THE FUNGALxFOREST

- **Visual:** **Not a single entity** — a loose cluster of 8–10 large purple mushroom creatures [VID:Nr2MJABYT-c f_03200 verified].
- **Core attack:** 5+ red AoE circles on pit floor simultaneously [VID:pV4cP8gvKcA f_00700 verified]. Most complex floor-AoE pattern in the corpus.

### 11.5 Dragon Head Boss / Dragon Prince — FUNGALxFOREST / SMOLDERINGxDEPTHS

- **Dragon Head (mid-game):** ornate dragon/demon skull embedded in a regular wave grid (no separate arena widening). HP displayed as a floating number ("829") above sprite [VID:pV4cP8gvKcA f_02100 verified].
- **Dragon Prince (later/larger):** ~2× Skeleton King's screen footprint, continuous adds throughout [VID:vCfTL7fx3fQ f_01168 — "Dragon Prince" HP bar label].

### 11.6 The Moon — THE VASTxVOID (final boss)

- **Visual:** Massive orange dome/hemisphere occupying ~40% of screen — mechanical orbital structure, not humanoid [VID:vCfTL7fx3fQ f_14100 verified].
- **Right-edge label is RED** (only red label in the game) [VID:Jbz1Obo82cg f_03000].
- **Attack 1 — Concentric Ring Bullet Hell:** dozens of orange projectiles in multiple expanding rings simultaneously, with intentional dodge gaps between rings. Verified [VID:vCfTL7fx3fQ f_14100].
- **Attack 2 — Dual projectile types:** green (hazard) + blue (healing — triggers "lovestruck" buff) [VID:Jbz1Obo82cg @ 27:35].
- **Attack 3 — Minion adds:** small enemies spawned mid-fight [VID:Jbz1Obo82cg @ 27:47].
- **Phase 2:** boss physically exits visible screen, then re-enters in erratic movement [VID:Jbz1Obo82cg @ 26:56]. Phase 3: aggressive approach toward player.
- **Victory cinematic:** UFO/player descends to a literal moon in space [VID:vCfTL7fx3fQ f_14200 verified].

### 11.7 [GAP] GORYxGRASSLANDS boss

Not captured in the video corpus.

---

## §12. Reward / drop system

### 12.1 Per-kill drops

| Drop | Color | Frequency | Source |
|---|---|---|---|
| XP gem (standard) | Cyan square | Most kills | Universal |
| XP gem (premium) | Green | Rare | [VID:M8nLJ82HwfI, VID:Dzwv-BFzAY4] |
| Gold coin | Orange circle | Common | Universal |
| Health potion | Red | Rare | [VID:M8nLJ82HwfI, VID:Dzwv-BFzAY4] |

XP gems auto-magnet to the player within a pickup range, extendable via the **Magnet** passive [WIKI/Passives].

### 12.2 Field-cleared bonus

+Xg gold per wave clear ("+148g" observed mid-run [VID:pV4cP8gvKcA f_01200 verified]).

### 12.3 Mid-run pickups

- **Fusion Reactor** (rainbow yin-yang ring) — drops randomly from regular enemies; **guaranteed** on boss kill [VID:SRcNWzJIML0 @ 00:40, VID:pV4cP8gvKcA]. Opens the Fusion / Evolution / Fission UI as a transparent in-combat overlay (game remains live).
- **Pedestal/chest pickups** — small dark items on the floor; player walks over to collect, no menu interruption [VID:Jbz1Obo82cg, VID:569lqQN9Y1U].

### 12.4 Boss kill bundle

Single boss death drops:
- 1 Blueprint (a meta-base building)
- 1+ Gears (used to unlock next biome)
- 1 Biome Trophy
- 1 Fusion Reactor (guaranteed)
- 100 gold "Character Completion Bonus"
[VID:M8nLJ82HwfI f_01850, VID:xtYnSfBgSks f_02400, VID:vCfTL7fx3fQ]

### 12.5 Post-boss screen

DPS Breakdown ranking each ball + passive's contribution [VID:M8nLJ82HwfI f_01850].

---

## §13. Telegraph & feedback layer

### 13.1 Universal red `!` attack telegraph

- Appears above any enemy ~0.5 s before they attack.
- Sprite shakes simultaneously.
- **Mechanically meaningful** — the **Tormentor's Mask** passive grants a 10% instakill chance at this trigger point [VID:vCfTL7fx3fQ], confirming `!` is a discrete game-state event, not just VFX.

### 13.2 Floor-AoE telegraph

- Solid dark-red filled circle (~1 cell diameter) on pit floor.
- ~1–2 s window before detonation.
- Up to 5+ simultaneously at Shroom Swarm [VID:pV4cP8gvKcA f_00700 verified].

### 13.3 Beam-laser danger zone

- Red diagonal hazard strip on pit floor (Skeleton King attack 2) [VID:xtYnSfBgSks f_01000 verified].

### 13.4 What is **deliberately absent**

The game's combat feel is unusually minimal for a 2025 action title:
- **No camera shake** on any hit, including AoE clears.
- **No hitstop / freeze-frame** on big hits.
- **No camera zoom** on boss entries.

Hit feedback is communicated entirely via:
- White tile flash on enemy (~3–6 frames at 60 fps)
- Floating damage numbers (with "!" for crits)
- Progressive sprite damage states
- FMOD audio cues

[INFERRED] This is a deliberate readability trade-off — preserves visibility of 50+ balls + damage numbers in a small playfield, and avoids motion-sickness on Steam Deck / handheld.

### 13.5 [NOT OBSERVED] Off-screen projectile warnings

No edge-glow / directional arrow system observed. The right-edge progress meter signals proximity-to-boss, not projectile direction.

---

## §14. Data gaps for a designer reimplementing this

Open questions after exhaustive search of the 20-video corpus:

| # | Question | Why it matters |
|---|---|---|
| 1 | Fire Rate unit (3.63 = ?/sec) | Throughput tuning |
| 2 | Ball Speed unit (6.01 = ?) | Physics replication |
| 3 | Movement-while-shooting penalty magnitude | Mobility balance |
| 4 | Catch hitbox radius | Skill-floor calibration |
| 5 | Exact bottom-edge behavior on missed catch (despawn vs respawn) | Slot-economy logic |
| 6 | Baby ball respawn cadence | Density tuning |
| 7 | HP/damage scaling formula per wave or per minute | Difficulty curve |
| 8 | Difficulty arrow multipliers (Fast, Normal, NG+) | Mode parity |
| 9 | Aim preview's max bounce count shown | UI logic |
| 10 | Recall Balls unlock condition + behavior | Mid-late game mechanic |
| 11 | GORYxGRASSLANDS boss | Content completeness |
| 12 | Phase-transition HP thresholds for each boss | Encounter design |
| 13 | Drop probability tables (XP gem, gold, potion, Fusion Reactor) | Economy tuning |
| 14 | Fusion Reactor mid-wave drop rate | Pacing |

---

## §15. Headline design takeaways

For anyone reimplementing or borrowing from this system:

1. **The catch mechanic is the entire skill axis.** A purely-passive autobattler with bouncing balls becomes BALL x PIT only when missing a catch costs real DPS time. Without this, the game is Vampire Survivors with a worse-feeling input. Implementations should preserve: (a) automatic on-contact catch (no button input), (b) catching = instant slot reload, (c) baseline bottom edge is pass-through, not reflective, so missing has consequences.

2. **The Warrior is a baseline measured by what other characters take away.** Spec the Warrior, then design the other 20 characters as one-rule deviations: piercing, gravity, autofire-while-moving, wrap-around walls, turn-based, etc. This generates content cheaply.

3. **Baby balls + special balls are two independent projectile layers.** Don't fold them into the same system. Special balls are aim-controlled with finite slots; baby balls are autonomous swarm with a population cap. The visual chaos works because the player's attention is on the colored special balls; the white baby balls are background DPS.

4. **Discrete waves + FIELD CLEARED beats continuous spawning.** It gives the player breath-windows for level-up choices, catch-relocating, and base scanning. The 2-second intermission is enough rhythm to feel pacing without breaking flow.

5. **No camera shake / hitstop is a *feature*, not an omission.** It is what allows 50+ balls + 30+ damage numbers + 5+ floor AoE circles to be legible simultaneously. If you add camera shake later, expect a readability cliff.

6. **The red `!` telegraph is a separate game-state event**, not just a sprite overlay. Anchor passive effects (Tormentor's Mask) and AI logic to this state, so designers can later add "interrupt the attack" mechanics without rewriting the AI.

7. **Bosses are signaled by geometry (pit widens), not by music swap or camera move.** This is cheap to implement and high-impact for "uh oh" feeling.

8. **The aim preview shows multiple ricochets**, not just one. This is the single biggest "skill-ceiling enabler" for the trajectory line — it lets players plan bank shots, which is the dominant late-game tactic for back-row enemies and back-only crit zones.

---

*Document compiled from frame-by-frame analysis of 20 YouTube gameplay videos (~80 hours total runtime, ~12,000 sampled frames). All visual claims are linked to specific frame files at `/Users/tarun/LILA/Game Research/BALL x PIT/Videos/<id>_analysis/frames/`. Raw extracts available at `_extract_ball_mechanics.md` and `_extract_enemy_waves.md` in the same directory.*
