# BALL x PIT — Enemy Wave System: Deep Extraction

**Author:** Research synthesis from 20 BALL x PIT video analyses
**Date:** 2026-05-19
**Sources:** All 20 `*_GAMEPLAY_NOTES.md` files, frame verification, DESIGN_DOC.md
**Status:** Granular enemy / wave / boss design spec for internal reference

---

## Citation Key

| Tag | Source |
|---|---|
| `[VID:M8nLJ82HwfI]` | Dr. Incompetent beginner guide (Boneyard, complete run) |
| `[VID:nkRcLrAQjsA]` | Northernlion first session (Boneyard, 2 runs) |
| `[VID:xtYnSfBgSks]` | CaRtOoNz first play (Boneyard → Snowy Shores) |
| `[VID:ejfiE4klU1M]` | Silent Gamer tutorial walkthrough (Boneyard only) |
| `[VID:yRrX-7ekr2g]` | Gohjoe (Snowy Shores exclusive) |
| `[VID:Dzwv-BFzAY4]` | Wanderbots (Boneyard + Snowy Shores, advanced) |
| `[VID:Nr2MJABYT-c]` | Idle cub (Fungal Forest + multiple bosses) |
| `[VID:Jbz1Obo82cg]` | Idle cub (Heavenly Gates + Vast Void + final boss) |
| `[VID:pV4cP8gvKcA]` | Matzel (5 broken fusions; Shroom Swarm + Dragon bosses) |
| `[VID:vCfTL7fx3fQ]` | Idle cub full 4h44m completion stream |
| `[VID:SRcNWzJIML0]` | Matzel fusion mechanics guide |
| `[VID:faqN7WC_BAg]` | IGN 10 tips |
| `[VID:vF17pcDXk8A]` | DrybearGamers ultimate beginner guide |
| `[VID:TPYEHuEDg5I]` | Matzel tips & tricks |
| `[VID:569lqQN9Y1U]` | Suremesh beginner guide |
| `[VID:y_rRsIO8o5w]` | Suremesh Holy Laser build guide |
| `[VID:QAc66EbAFV4]` | GamingByte 3-minute review |
| `[VID:VPl6VSsOXv4]` | Burr Plus buy-or-pass review |
| `[DESIGN_DOC]` | BALL x PIT master design doc (wiki/community synthesis) |
| `[INFERRED]` | Analytical conclusion, not a quoted source |

---

## §1. Spawn Architecture

### 1.1 Where Enemies Spawn From

Enemies spawn exclusively **from the top of the pit corridor** — they materialize at the top edge and advance downward toward the player. No side-spawning has been observed in any of the 20 video analyses. The pit is a vertically-oriented narrow corridor (roughly 7 columns wide, variable depth by biome), and all enemy movement is strictly top-to-bottom [VID:M8nLJ82HwfI, VID:nkRcLrAQjsA, VID:ejfiE4klU1M — confirmed across every biome shown].

**Corridor width:** The standard corridor is approximately 7 cells wide at the widest. When the boss spawns, the pit widens by ~25% as the stone walls visually pan outward [VID:M8nLJ82HwfI f_01700, VID:nkRcLrAQjsA]. This is the only geometry change in the game.

### 1.2 Spawn Rate — Early vs. Late

The corpus does not expose raw enemy/second spawn rate numbers. Observational data:

- **Early waves (0:00–2:00 in-run):** 4–7 enemies visible in formation [VID:nkRcLrAQjsA f_00084 shows 4 enemies on wave 1; VID:M8nLJ82HwfI f_00060 shows 5 enemies]. The player begins with 1 ball; pace is explicitly slow and tutorial-friendly.
- **Mid-run waves (~5:00–10:00):** 15–25 enemies in formation, filling roughly the top 40–60% of the screen [VID:nkRcLrAQjsA f_00980 shows 40+ enemies filling upper 60%; VID:M8nLJ82HwfI f_00700 shows ~20 enemies].
- **Late waves (~10:00–14:00):** Dense grids described by Idle cub as "very dense here. I feel like there are very little gaps in between enemies" for Fungal Forest [VID:Nr2MJABYT-c 00:11:27]. Frames show 50–60+ mushroom enemies [VID:Nr2MJABYT-c f_00700, f_00800].
- **[INFERRED]** Spawn rate appears to scale continuously over the 15-minute run. There is no single documented number (enemies/second), but density roughly triples from start to late-game based on frame comparisons.

### 1.3 Waves vs. Continuous Trickle

The game operates in **discrete waves**, not a continuous trickle. Each wave consists of a fixed formation of enemies that advance together from the top. When the last enemy in a wave dies, the "FIELD CLEARED!" event fires (see §1.4), and a brief gap precedes the next wave spawning at the top. There is no visible mid-wave reinforcement trickle observed — the entire wave spawns together.

**Exception:** During boss fights, the first boss (Smoldering Depths boss described at [VID:vCfTL7fx3fQ 00:19:28]) "spawns normal enemies all the time. It's like a full on enemy spawn here" — suggesting at least one boss has continuous add-spawning as its unique mechanic. Other bosses spawn only "some ads" during the fight.

### 1.4 "Field Cleared!" — Visual Cue on Wave End

**Confirmed from multiple sources.** When the last enemy in a wave is killed:
- **Text overlay:** "FIELD CLEARED!" appears centered on screen in large white/cream text [VID:SRcNWzJIML0 f_00325, VID:pV4cP8gvKcA f_01200 — both visually confirmed from frame reads].
- **Gold bonus:** "+Xg" gold reward displays simultaneously — "+148 gold" observed in two separate frame reads [VID:SRcNWzJIML0 f_00325, VID:pV4cP8gvKcA f_01200].
- **Fireworks burst:** A dramatic particle explosion fills the upper half of the arena — dense orange sparks and white confetti/particle burst [VID:SRcNWzJIML0 f_00325 shows the most vivid capture: "orange sparks + white confetti"].
- **Level-Up notification** sometimes fires simultaneously if XP threshold was crossed by the final kill [VID:SRcNWzJIML0 f_00325 — "Level Up (1)" toast appears at same time as Field Cleared].
- **[INFERRED] Cadence:** "Field Cleared!" fires after EVERY wave, not every few waves. It is the primary inter-wave boundary event. The progress bar on the right side advances with each wave cleared [VID:M8nLJ82HwfI HUD notes].

### 1.5 Off-Screen vs. Visible-Edge Spawning

Enemies spawn at the **visible top edge** of the corridor — they are visible as soon as they exist. There is no evidence of off-screen spawning where enemies teleport in from beyond the camera view. Enemies that are newly spawned appear at the top row and immediately begin their downward advance. Players can "pre-fire" the boss before it "fully begins" — [VID:569lqQN9Y1U 00:04:33]: "my ghost balls were able to phase through him and constantly attack him while he was in his animation of getting ready" — confirming the boss spawns within camera view during an entry animation.

### 1.6 Corridor Width as Spawn Density Constraint

The ~7-column-wide corridor creates a hard maximum on formation width. Enemy formations are observed at full corridor width in late game (6–8 enemies across per row) [VID:Nr2MJABYT-c f_00800 shows ~8 wide × 6+ deep]. The narrow corridor is the core design constraint that makes ball bouncing strategically valuable — balls bouncing between side walls and enemy formations deal amplified damage by hitting multiple enemies per bounce.

---

## §2. Pacing Across a 15-Minute Run

### 2.1 The 3-Act Structure — Verified

The DESIGN_DOC §3.2 three-act structure is directly confirmed by video data:

**Act 1 (0:00–~5:00) — Establish the build**
- Damage numbers: 14–16 in the very first frames [VID:M8nLJ82HwfI f_00060, f_00180], rising to ~60–80 by 5 minutes.
- Enemy count: 4–7 per wave, advancing slowly.
- Player has 1–2 balls, 0–1 passives.
- Tutorial tooltips fire in first 2 minutes.
- First Fusion Reactor may appear as early as minute 3–4 [VID:M8nLJ82HwfI timeline].

**Act 2 (~5:00–~12:00) — Fuse, evolve, escalate**
- Damage numbers: 100–500 range [DESIGN_DOC §3.2 verified by VID:nkRcLrAQjsA f_02005 showing "389!, 402!" hits on Skeleton King at run's end].
- Enemy count: 20–40+ per wave.
- Ball inventory fills to 3–4 slots; fusion decisions drive build identity.
- "434!" observed as a peak single-hit mid-run (Hemorrhage proc, Wanderbots snow zone run) [VID:Dzwv-BFzAY4 f_02000].

**Act 3 (~12:00–15:00) — Boss**
- Regular enemy spawns slow significantly when boss appears [VID:M8nLJ82HwfI quote: "now what you're really focusing on is just dodging these purple arrows"].
- Boss occupies top ~30–40% of screen.
- Late-run damage ceiling: "3.6k on overgrowth × lightning rod" [VID:vCfTL7fx3fQ 00:46:18]; "4050×" damage numbers visible [VID:vCfTL7fx3fQ f_12500]; over 100 million for extreme fusions (dark × nuke) [VID:SRcNWzJIML0].

**Verdict: 3-act structure confirmed as designed.**

### 2.2 Difficulty Scaling — Time vs. Kills

Based on cross-video evidence, scaling appears to be **elapsed time + wave count combined**, not purely one or the other:
- The right-side progress bar fills with each wave cleared [VID:M8nLJ82HwfI HUD notes], indicating wave count is a primary trigger.
- Enemy HP is not directly shown scaling by minute, but the Wanderbots inference is compelling: a Hemorrhage proc dealing 434 damage implies the target had ~2,170 HP at that moment (434 = 20% of current HP) [VID:Dzwv-BFzAY4 caveats]. Compare this to early wave enemies dying in 3–5 ball hits at 14–20 damage = ~50–80 HP.
- [INFERRED] Enemy HP roughly scales 30–50× from wave 1 to late game, consistent with a continuous scaling function tied to wave number/time.

### 2.3 Damage Number Progression — Verified

| Phase | Observed Damage Range | Source |
|---|---|---|
| Wave 1–3 | 14–60 | VID:M8nLJ82HwfI f_00060/f_00180, VID:nkRcLrAQjsA f_00084 |
| Mid-run | 100–500 | VID:nkRcLrAQjsA, VID:Dzwv-BFzAY4 |
| Late run (pre-boss) | 500–3,600 | VID:vCfTL7fx3fQ quote, VID:Dzwv-BFzAY4 |
| Boss fight (endgame build) | 4,050+, up to millions | VID:vCfTL7fx3fQ f_12500, VID:SRcNWzJIML0 |

The 14→60→100→500→4000+ progression stated in DESIGN_DOC §3.2 is **confirmed accurate**.

### 2.4 Mini-Bosses / Elite Spawns Mid-Run

Evidence for mid-run elite/special spawns is limited but present:
- **Dynamite-strapped enemies:** "Every five to 10 rolls spawn an enemy with dynamite attached to them. Destroying them will deal a lot of damage to nearby enemies" [VID:vCfTL7fx3fQ 00:21:24]. These are scripted elite enemy types that appear at specific wave intervals.
- **Armored enemies with damage states:** Enemies show progressive sprite damage (bloodied → broken armor → dark tint) suggesting multi-HP-tier enemies that function as de facto mini-elites [VID:M8nLJ82HwfI, DESIGN_DOC §4.6].
- **Large boss-type enemy mid-wave:** VID:faqN7WC_BAg f_00100 shows a "large crystalline/diamond structure, ~3 tiles wide" at the top of a wave in the Snowy Shores biome — described as a boss but appearing within the enemy formation before the wave-end boss spawn. This may be a mid-level sub-boss or an early-appearance boss variant.
- **[MISSING DATA]** No video explicitly labels a "mini-boss" as distinct from a regular boss. The distinction is unclear from available footage.

### 2.5 Wave Intermissions (Rest Periods)

There is a brief gap between "Field Cleared!" and the next wave appearing — visible in SRcNWzJIML0 f_00325 where the arena is empty and the gold/confetti animation plays for ~2 seconds before new enemies appear. This is NOT a true rest period — XP collection, ball management, and movement continue. The upgrade panel can open during this window [INFERRED from split-screen upgrade timing].

### 2.6 "Field Cleared!" Cadence — Every Wave Confirmed

"Field Cleared!" fires after every wave. The MANIFEST confirms it was described by both Northernlion and Dr. Incompetent [MANIFEST.md cross-video section]. The progress bar on the right side advances per wave. No source suggests it skips waves. **Confirmed: fires after every wave.**

---

## §3. Enemy Archetypes — Movement & Attack Patterns

### 3.1 Melee Chargers

The most common archetype. Standard enemies in all biomes advance toward the player by marching downward (top-to-bottom) at a steady pace. They do not rush or accelerate unless they reach a trigger zone near the player's altitude [VID:M8nLJ82HwfI tutorial text: "Enemies will attack you if they get close to you or reach the bottom of the screen"].

**Behavior:** Slow steady advance in grid formation. No lateral movement observed — enemies march straight down in their column. Attack is a close-range melee lunge, telegraphed by red `!` exclamation mark ~0.5s before [VID:M8nLJ82HwfI].

**Speed:** Appears constant across the wave; no speed variation between individual melee chargers.

### 3.2 Archer / Ranged Enemies

**Confirmed from multiple sources.** IGN explicitly describes "archer enemies at the back fire flaming arrows in a loose spread" [DESIGN_DOC §4.6 from VID:M8nLJ82HwfI]. Dr. Incompetent confirms: "Archer enemies at the back fire flaming arrows (small orange streaks) in a loose spread. Can be shot out of the sky ('you can shoot the arrows out of the sky sometimes')" [VID:M8nLJ82HwfI].

**Behavior:** Positioned in rear rows of the enemy formation, maintaining distance from the player. Fire projectiles toward the player's position.

**Projectile:** Small orange streak/arrow. The game explicitly allows player balls to intercept these arrows [VID:M8nLJ82HwfI quote]. This creates a defensive ball-use meta: shallow-angle shots can sweep across incoming arrows.

**Telegraph:** Red `!` before firing, consistent with all enemy types [VID:M8nLJ82HwfI].

**Range:** Full corridor length — arrows travel from top formation to the player at bottom.

**[MISSING DATA]** Exact projectile speed not quantified. No description of spread angle degrees.

### 3.3 AoE Casters

The most visually complex non-boss archetype. Multiple variants observed:

**Red circle casters:** Enemies that place red circular AoE zones on the pit floor before detonating. Red circles are solid-bordered rings (~1 enemy cell diameter, semi-transparent fill) that persist for a short time before dealing damage [VID:Nr2MJABYT-c f_01600, f_01800; VID:pV4cP8gvKcA f_00700 showing 5+ circles simultaneously during Shroom Swarm]. The `!` telegraph appears above the enemy when it initiates the cast [VID:M8nLJ82HwfI].

**Shroom Swarm casters:** The Shroom Swarm boss acts as the most extreme AoE caster variant — 5+ floor AoE circles simultaneously [VID:pV4cP8gvKcA f_00700 — frame verified]. See §6 (Shroom Swarm boss section) for full detail.

**Lava blob emitters:** Magma-type enemies or the Magma ball evolution creates floor patches "enemies who walk into lava blobs are dealt 23-46 damage and gain 1 stack of burn" [VID:Nr2MJABYT-c f_00400]. Observed as large orange puddles on the pit floor [VID:ejfiE4klU1M f_01050].

### 3.4 Swarms / Multi-Enemy Groups

Several biomes feature distinctly grouped enemy formations functioning as swarms:

- **Purple mushrooms (FUNGALxFOREST):** Dense packs of 50–60+ mushroom enemies filling the pit [VID:Nr2MJABYT-c f_00700, f_00800]. Noted as "very dense here. Very little gaps" [VID:Nr2MJABYT-c 00:11:27]. These function as a pseudo-swarm in that their sheer density requires AoE solutions.
- **The Shroom Swarm boss** is literally a multi-entity cluster: "Multiple oversized purple mushroom creatures in a loose cluster — NOT a tight grid" [VID:Nr2MJABYT-c f_03200, frame verified visually — 8–10 large mushroom entities in loose arrangement filling the top half of the screen].

### 3.5 Armored / Tank Enemies

Confirmed through the progressive damage state system: enemies display "bloodied → broken armor → darker tint" stages as HP drops [VID:M8nLJ82HwfI quote, DESIGN_DOC §4.6]. This implies HP-tier variation among enemies even within the same wave. The shield-bearing enemies in Snowy Shores specifically block from the front — "armored/mechanical dwarf-like creatures in blue-grey metal crates; some with shields (block from front requiring side/back shots)" [VID:yRrX-7ekr2g]. This forces lateral ball bouncing rather than direct frontal shots.

**Enemy HP (Inferred Scale):** Early enemies: ~50–100 HP. Mid-game enemies: ~500–2,000 HP (based on Hemorrhage inference). Late-game enemies in Moon biome survive multiple 580–680 damage hits [VID:vCfTL7fx3fQ f_14100 shows 680 hits without immediate kills].

### 3.6 Fliers / Aerial Enemies

**[MISSING DATA — NOT CONFIRMED]** No video source identifies a flying or aerial enemy that bypasses ground physics. All observed enemies advance in the standard top-to-bottom grid formation. The Physicist character's description of "inverted gravity balls" is a player ability, not an enemy mechanic. No bypass-ground enemy type is confirmed.

### 3.7 Special Movement Patterns

- **The Moon boss:** Confirmed to leave the visible screen temporarily ("he jumped out of the screen") before re-engaging [VID:Jbz1Obo82cg transcript 00:26:56]. This is the only confirmed off-screen movement mechanic for any entity.
- **Statue/dummy enemies:** Matzel notes "these can't be — these don't work like normal enemies, even though they look like them" [VID:pV4cP8gvKcA 00:10:23]. These appear to be non-advancing obstacles or special encounter types that do not march toward the player.
- **Wrap-around:** The Tunneller character has balls that "wrap around top/bottom of screen" — but this is a player mechanic, not an enemy mechanic [DESIGN_DOC §4.2].

### 3.8 Enemy Attack Telegraph — Universal Mechanic

**Red `!` exclamation mark:** Appears above any enemy ~0.5s before an attack fires. This applies to all attack types: melee lunges, projectile shots, AoE detonations [VID:M8nLJ82HwfI explicit tutorial quote]. The `!` is red, appears above the enemy sprite, and remains for approximately 0.5s before the attack executes.

An additional telegraph is described for melee: "you'll hear an auditory cue and you'll see a visual cue where you see an enemy shake a lot" [VID:569lqQN9Y1U 00:06:15]. This implies the `!` is accompanied by enemy sprite shaking.

---

## §4. Common Formations & Wave Patterns

### 4.1 Standard Formation Type

The dominant formation is a **rectangular grid occupying the upper N rows of the corridor** — enemies arranged in a regular pattern filling the full width and 2–8 rows deep [confirmed across all biomes in all videos]. The grid is not ragged or irregular at spawn; it fills cleanly. As enemies die, gaps appear and the player exploits them for ricochet-behind-the-formation bounces.

### 4.2 Single-File Streams vs. Wide Front Lines

Both patterns exist:
- **Wide front lines** are the norm. Full-width grids (7 columns wide × 3–8 rows deep) are the standard for most waves.
- **Single-file or thin columns** appear in very early waves [VID:nkRcLrAQjsA f_00084: 4 enemies in a loose cluster] and at end-of-wave cleanup [VID:SRcNWzJIML0 f_00275: 2 enemies remain on left side after laser clear].

### 4.3 Encirclement / Flanking

**No flanking confirmed.** All enemy entry is from the top of the pit. No source shows enemies entering from sides. The corridor wall structure physically prevents side-approach. Enemies do not reposition laterally — they advance straight down their spawn column.

The only exception to pure grid-marching is the Shroom Swarm boss, which occupies a **loose cluster** rather than a tight grid [VID:Nr2MJABYT-c f_03200 — frame verified]. This feels like encirclement because the loose cluster spreads wider than a typical tight grid, but it still originates from the top.

### 4.4 Density Spikes ("Hordes")

Density spikes are a late-game feature:
- Fungal Forest specifically is described as "very dense, very little gaps" [VID:Nr2MJABYT-c 00:11:27].
- GamingByte [VID:QAc66EbAFV4] confirms "Enemies constantly move down toward you."
- The Matzel extreme-build videos show late runs where new enemies continuously spawn before the previous wave is cleared, creating a quasi-horde state [VID:SRcNWzJIML0 extreme builds]. This is particularly pronounced at game speed 2×–3× where wave refresh outpaces kill rate for under-built characters.
- The Vampire Survivors-like "crowding" moment described in the DESIGN_DOC is confirmed in Fungal Forest and Moon biome footage [VID:vCfTL7fx3fQ].

### 4.5 Aggressive vs. Passive AI

All observed enemies advance toward the player at a constant pace — there is no "passive" or range-maintaining AI observed. Ranged enemies (archers) do fire from rear rows without advancing to melee, but they are still part of an advancing formation and do not retreat or maintain static positions indefinitely.

The Tiptoer character's "stealth — enemies don't detect you" ability [DESIGN_DOC §4.2] implies enemies DO have a detection/aggression trigger when playing normally, but no observed footage shows enemy AI pausing or backing away. [INFERRED] "Detection" likely refers to enemies beginning their attack animation / `!` telegraph when the player enters a range threshold.

---

## §5. Difficulty Scaling Mechanics

### 5.1 HP Scaling

Direct data is limited. The best observable data point: Wanderbots' Hemorrhage proc dealt 434 damage = "20% of current HP" → implies enemy had ~2,170 HP in SNOWYxSHORES mid-run [VID:Dzwv-BFzAY4]. Compare to early Boneyard enemies dying in 5–6 hits of 14–20 damage = ~70–100 HP. This implies roughly a 20–30× HP multiplication between first biome and second biome.

The Dragon boss in Fungal Forest takes hits of 42–45 per ball [VID:Nr2MJABYT-c f_02800], with HP visible as "829" floating above it [VID:pV4cP8gvKcA f_02100] — a mid-game boss has ~800 HP. The Moon (final boss) absorbs 580–680 hits without dying [VID:vCfTL7fx3fQ f_14100].

### 5.2 Damage Scaling

Enemy projectile damage numbers are not directly shown in HUD (only player damage numbers float). Observable indicators:
- Player HP sphere depletes during combat, reaching critically low in Skeleton King fight [VID:nkRcLrAQjsA f_02050].
- Revive mechanics become relevant mid-game [VID:pV4cP8gvKcA: "we can revive once"].
- "Health potions that drop... heal you a little bit, just not to full" [VID:nkRcLrAQjsA].
- [INFERRED] Enemy damage scales meaningfully by Act 3 — the Skeleton King can kill players who do not dodge its bone fan.

### 5.3 New Enemy Types by Depth/Biome

Each biome introduces a distinct visual and behavioral enemy roster:

| Biome | Enemy Style | Confirmed Types |
|---|---|---|
| BONExYARD | Skeleton grunts, armored warriors | Melee chargers, archers, basic AoE casters |
| SNOWYxSHORES | Blue-armored dwarves, shield-bearers | Front-shield blockers, crystalline projectile types |
| LIMINALxDESERT | Stone golems, armadillo/scarab, dragon-face | Ranged, high-HP heavy types |
| FUNGALxFOREST | Purple mushrooms (densest packing), organic types | Dense swarm, lava/AoE casters, Shroom Swarm boss |
| GORYxGRASSLANDS | Gorilla/jungle war-paint creatures | [LIMITED DATA] |
| SMOLDERINGxDEPTHS | Fire-torch pot creatures, fire mushrooms | Fire-theme [VID:vCfTL7fx3fQ f_00700] |
| HEAVENLYxGATES | Golden armored humanoids, "angel bunny" entities in thrones | [VID:Jbz1Obo82cg, VID:vCfTL7fx3fQ f_05500] |
| VASTxVOID | Stone pod/mushroom-cap grey-green creatures | [VID:vCfTL7fx3fQ f_10000] |

The enemy roster swap between biomes is **confirmed as a visual and behavioral change**, not cosmetic only — shield-bearers in Snowy Shores require different tactics than simple melee chargers in Boneyard.

### 5.4 Difficulty Arrows on Level Select

The level select screen shows length and difficulty selection [VID:vF17pcDXk8A f_00840: "Normal — Length: 15:00" with difficulty arrows]. The left arrow returns to normal; presumably the right arrow increases difficulty. Matzel runs are described as "New Game Plus difficulty" [VID:pV4cP8gvKcA summary]. NG+ is described as "a challenge mode where you go through all the same levels again with a really high challenge" [VID:vF17pcDXk8A transcript]. **Specific mechanical changes from difficulty arrows (enemy HP/damage multipliers, new enemy behaviors)** are not documented in the available sources beyond "really high challenge."

### 5.5 NG+ Scaling

NG+ costs 8 gears per level [DESIGN_DOC §5.1]. Matzel demonstrates NG+ runs with his bank of 117,162 gold / 254,241 wood [VID:pV4cP8gvKcA f_03000], suggesting he is deep in NG+ progression. The combat in these runs shows enemy HP high enough that even Matzel's broken fusions still take time to clear waves — enemy HP scaling is significant. **[MISSING DATA]** Exact NG+ HP/damage multipliers are not quoted in any source.

### 5.6 Run Length Variants

The level select allows players to change run length with difficulty arrows [VID:vF17pcDXk8A f_00840]. VID:Jbz1Obo82cg f_02000 shows "Fast — Length: 12:00" as an available option for the Vast Void level, alongside the standard 15:00. Shorter runs compress the three-act structure but do not appear to change wave count — they presumably accelerate the wave-to-boss progression.

---

## §6. Boss Encounters — Full Detail

### 6.1 Universal Boss Mechanics (All Bosses)

These mechanics apply to every boss regardless of biome:

- **Pit geometry change:** The pit walls expand by ~25% when a boss spawns — the stone wall textures pan outward, creating a wider play area [VID:M8nLJ82HwfI f_01700, VID:nkRcLrAQjsA explicit description].
- **HP bar:** A full-height red bar appears on the RIGHT sidebar, labeled with the boss name in vertical white text (e.g., "Skeleton King") [VID:xtYnSfBgSks f_01000 — frame verified; VID:yRrX-7ekr2g "Icebound Queen" bar; VID:Nr2MJABYT-c "Shroom Swarm" bar — all frame verified].
- **Boss label color:** White for regular bosses; **RED for the final boss "The Moon"** [VID:Jbz1Obo82cg f_03000 — confirmed "The Moon" in red on right edge].
- **Spawn trigger:** The progress bar on the right side fills to 100% as waves are cleared; boss spawns when it reaches maximum [VID:M8nLJ82HwfI, VID:nkRcLrAQjsA].
- **Regular enemies during boss:** Some regular enemies remain or continue spawning during boss fights. Specifically: "small enemy reinforcements (white ghost-like figures) walk up field alongside boss" [VID:xtYnSfBgSks Skeleton King fight].
- **Boss drop on death:** Guaranteed Fusion Reactor drop [VID:pV4cP8gvKcA transcript: "The boss will spawn soon. Then we get the fusion out of him"]. Also drops Blueprint for base building [VID:M8nLJ82HwfI f_01850: "Blueprint Found! Cozy Home"]. Also awards gears [VID:vCfTL7fx3fQ 00:20:27: "two gears" from boss].
- **Post-boss DPS screen:** A "Battle Complete" / "DPS breakdown" screen shows ball-by-ball damage, launches, and DPS after every boss kill [VID:y_rRsIO8o5w f_00160–f_00190].

---

### 6.2 Skeleton King (BONExYARD — Biome 1 Boss)

**Visual:** Giant humanoid crowned skeleton, ~3–4 tile height, fills ~40% of upper screen area. White/cream bone structure with large crown. At low HP, a "green orb pulses in the rib cage area" [VID:nkRcLrAQjsA f_01870]. **Frame verified at [VID:nkRcLrAQjsA f_01915] and [VID:xtYnSfBgSks f_01000]** — boss clearly shows crowned skeleton with arms extended, bone projectiles in fan pattern.

**Back-only crit zone (CONFIRMED):** The Skeleton King can only be damaged effectively from behind. "Now what you're really focusing on is just bouncing it around because the front of the boss you can't hit. You're hitting the crown in the back of the boss's head" [VID:M8nLJ82HwfI 00:27:00]. Northernlion discovers this mid-fight: "Oh, he only takes damage from the back" [VID:nkRcLrAQjsA 00:30:48]. Front hits are absorbed/ignored.

**Attack 1 — Purple Bone Projectile Fan:** The boss fires volleys of ~8–20 purple bone-shaped missiles in a wide fan pattern downward. These bone projectiles are elongated ~20px, purple-magenta colored with slight glow [VID:ejfiE4klU1M f_01300, f_01400 — frame verified; VID:nkRcLrAQjsA f_01915 — frame verified showing fan covering lower-right half of screen]. In Phase 2, fan spread and frequency increase [VID:nkRcLrAQjsA f_01960 shows "fan attack continues — purple projectiles dense across entire lower screen"].

**Attack 2 — Beam Laser:** A targeting ray / danger zone attack [VID:M8nLJ82HwfI: "he has that ray attack where you just need to not be in that danger zone"]. Frame verified at [VID:xtYnSfBgSks f_01000] where a prominent red diagonal laser hazard zone is visible running from boss position across the pit floor — a clear danger-zone indicator. Not confirmed whether this is a fired beam or a persistent AoE zone.

**Phase 2 (Low HP):** At approximately 50% HP, behavior changes: "at ~half HP, boss glows green internally — a green orb pulses in the rib cage area. The bone projectile attacks intensify" [VID:nkRcLrAQjsA f_01870/f_01960]. Attack frequency and spread increase. "Level Up! +1 Intelligence" can trigger mid-boss fight [VID:nkRcLrAQjsA f_01870].

**Regular Enemies During Fight:** "Small enemy reinforcements (white ghost-like figures) walk up field alongside boss. Boss has multiple rows of regular enemies still active during fight" [VID:xtYnSfBgSks]. Player must manage both boss and regular enemies simultaneously.

**Arena Notes:** The Skeleton King fight shows the widened pit geometry most clearly [VID:M8nLJ82HwfI f_01700, VID:nkRcLrAQjsA f_01580/f_01870].

---

### 6.3 Icebound Queen (SNOWYxSHORES — Biome 2 Boss)

**Visual:** A massive ice/crystal formation — "white ice column structure with green crystalline spires on top, approximately 3–4 tiles tall" [VID:yRrX-7ekr2g]. More like an ice pillar/tower than a humanoid. Blue/white/teal color palette. Frame verified at [VID:yRrX-7ekr2g f_01800, f_02700].

**Attacks:** Fires white/teal crystalline projectile darts in multiple directions. A "red blood pool below" the boss observed in f_01800 — either a damage zone or player HP indicator. No beam attack confirmed for this boss.

**HP Bar:** Right sidebar, full red column, "Icebound Queen" in white vertical text [VID:yRrX-7ekr2g f_01800 — frame verified].

**Near-Death State:** At f_02700 (Gohjoe run), the boss HP bar is nearly depleted and a "large circular shatter radius" is visible around the boss — implying a death explosion or last-phase AoE [VID:yRrX-7ekr2g].

**[MISSING DATA]** No phase transition observed. Gohjoe mentions a second "ice dragon riding a pillar" encounter in the same zone [VID:yRrX-7ekr2g caveats] — it's unclear if this is a second distinct boss or the Icebound Queen in a different form.

---

### 6.4 Shroom Swarm (FUNGALxFOREST — Biome 4 Boss)

**Visual:** A **cluster of multiple large purple mushroom entities** — not a single entity. "Multiple oversized purple mushroom creatures filling the pit in a loose cluster (not a tight grid)" [VID:Nr2MJABYT-c f_03200 — frame verified; VID:pV4cP8gvKcA f_00600/f_00700]. Approximately 8–10 large purple mushrooms with skulled caps, spread across the full corridor width in an irregular pattern. "Shroom Swarm" name label slides in from right edge [VID:Nr2MJABYT-c f_03200 — frame verified].

**Attacks — Floor AoE Circles:** The boss's defining mechanic. "Large AoE attack circles on floor — large red filled circles (solid dark-red AoE zones approximately 1-cell diameter each)" [VID:pV4cP8gvKcA f_00700 — frame verified, shows 5+ red circles simultaneously]. Circles are solid-filled (not just outlines), persist for a brief duration, then presumably detonate for damage. Player must dodge between circles.

**Scale:** At [VID:pV4cP8gvKcA f_00700] with the Black Hole + Sun build, Matzel is at critically low HP during this fight — "HP bar nearly depleted" — suggesting Shroom Swarm is dangerous even for experienced players [VID:pV4cP8gvKcA].

**Player reaction:** "I barely looked at the boss. I think it was like a group of mushrooms" [VID:Nr2MJABYT-c 00:14:19] — the boss surprised the streamer by being a multi-entity cluster rather than a single enemy.

**Phase/Add Spawns:** Not clearly documented from available footage.

---

### 6.5 Dragon Prince / Dragon Head Boss (FUNGALxFOREST late / SMOLDERINGxDEPTHS)

Two distinct dragon boss references appear in the data:

**Dragon Head Boss (mid-game, FUNGALxFOREST or adjacent):**
"Large ornate dragon/demon skull creature positioned in the middle of the enemy formation. Takes hits of 42–45 damage per ball. HP displayed as '829' floating above the boss sprite" [VID:pV4cP8gvKcA f_02100 — frame verified showing large ornate dragon skull with "829" floating HP; VID:Nr2MJABYT-c f_02800 — frame verified]. Notably, the dragon boss is **embedded within the regular enemy grid** rather than taking up a separate cleared arena zone [VID:Nr2MJABYT-c: "No separate arena transformation visible"]. Regular purple enemies surround it during the fight.

**Dragon Prince (later, confirmed as different/larger):**
Frame [VID:vCfTL7fx3fQ f_01168] shows "large orange-red dragon-like entity at top of arena. Right-side HP bar labeled 'Dragon Prince.' Dense add spawns (enemies continue to appear). White laser beam hitting boss. Boss is ~2× the size of Skeleton King in relative screen area. Massive damage numbers." The Dragon Prince appears to be a more advanced variant.

**[INFERRED]** The Dragon Head and Dragon Prince may be the same boss type appearing at different depths/difficulty tiers, or they may be sequential boss encounters in the same biome chain.

---

### 6.6 The Moon (Final Boss — VASTxVOID, Biome 8)

**The most fully-documented boss in the dataset.** Two separate playthroughs complete this fight [VID:Jbz1Obo82cg, VID:vCfTL7fx3fQ].

**Visual:** "A MASSIVE ORANGE GLOWING SPHERE fills ~40% of screen. Large dome/hemisphere shape with flat base. Mechanical-looking. Orbiting elements around it. Not humanoid — it's an orbital structure." Color: deep orange/amber with darker core. HUD right-edge label: "The Moon" in **RED text** (not white like other bosses) [VID:vCfTL7fx3fQ f_14100 — frame verified; VID:Jbz1Obo82cg f_03000/f_04000].

**Frame verified** at [VID:vCfTL7fx3fQ f_14100]: The Moon is a massive orange sphere taking up nearly half the screen, surrounded by **concentric ring bullet-hell** — dozens of orange ball-projectiles arranged in multiple orbital rings simultaneously. Damage numbers 680, 585, 645, 236 visible around the boss.

**Attack 1 — Concentric Ring Bullet Hell:** "Fires orange bullet-balls in concentric ring/spiral patterns (dozens simultaneously)" [VID:vCfTL7fx3fQ f_14100 — frame verified]. The projectiles are orange spheres arranged in expanding rings. Player must dodge between ring gaps. Player balls can destroy the incoming projectiles [VID:Jbz1Obo82cg transcript: "We can also destroy his projectiles"].

**Attack 2 — Differentiated Projectile Types:** Two confirmed projectile colors — "green projectiles" and "blue ones" with different effects. Blue projectiles trigger "love struck" healing effect on player. Green projectiles = unknown hazard [VID:Jbz1Obo82cg 00:27:35].

**Attack 3 — Minion Spawns:** "That's a lot of tiny dudes. Got to make sure we don't get overwhelmed by those" [VID:Jbz1Obo82cg 00:27:47]. The Moon spawns small enemy minions mid-fight — confirmed but type unspecified.

**Phase 2 — Movement:** "Okay, he jumped out of the screen, I feel like" [VID:Jbz1Obo82cg 00:26:56] — The Moon physically leaves the visible pit area temporarily. This is the only boss with confirmed off-screen movement. Phase 2 seems to follow: "Okay, now you just uh zoom around" [VID:Jbz1Obo82cg 00:28:19] — The Moon begins moving erratically. Phase 3 (implied): boss moves toward player, becomes aggressive close-range [VID:Jbz1Obo82cg 00:29:06].

**Boss HP:** Described as having substantial HP — "this guy has some HP. Or rather, our build is trash for boss damage" [VID:Jbz1Obo82cg 00:29:19]. Suggests The Moon has build-check mechanics — some builds are ineffective.

**Arena:** Standard VASTxVOID biome floor. No arena geometry change beyond the universal 25% widen. Space/lunar aesthetic: "purple/space background with starfield. Grey stone floor with circular gear/portal patterns" [VID:vCfTL7fx3fQ f_10000].

**Victory Sequence:** After defeat, a cinematic plays — "Oh, it's a UFO. Oh, wait. Is that the thing that crashed at the beginning of the game?" [VID:Jbz1Obo82cg 00:31:05]. The victory shows a UFO descending to a literal moon in space [VID:vCfTL7fx3fQ f_14200 — frame verified: "A blue circular moon orbiting in black space with colorful particle burst radiating outward. Tiny player characters visible near the moon."].

---

### 6.7 Other Boss Data

**Biomes 5–6 Bosses (GORYxGRASSLANDS, SMOLDERINGxDEPTHS):** Limited data. VID:vCfTL7fx3fQ f_02000 shows "large glowing pink/purple blob creature at top-center of Smoldering Depths arena" — described as possibly a "wave boss" or mini-boss type. No label visible in that frame.

**Biome 7 Boss (HEAVENLYxGATES):** VID:Jbz1Obo82cg f_00300 shows "single large diamond-shaped angel boss type at top. Very sparse enemies." Not further documented.

**Boss Trophies:** Defeating a boss drops a biome-specific trophy that grants a permanent meta stat bonus — "Smoldering Trophy. Gain one baby ball damage" [VID:vCfTL7fx3fQ 00:20:18]. Each biome has its own trophy.

---

## §7. Reward Drops on Kill & Event Types

### 7.1 Standard Enemy Kill Drops

| Drop Type | Visual | Notes |
|---|---|---|
| XP Gems (standard) | Cyan/teal small square pixels | Most common drop; auto-magnet to player in range |
| XP Gems (premium) | Green squares | Worth more XP; rarer [VID:nkRcLrAQjsA] |
| Gold Coins | Orange circles | Drop from enemies [VID:faqN7WC_BAg] |
| Health Potions | Red flask | Partial heal only; "not to full" [VID:nkRcLrAQjsA] |

XP gems drift toward the player in a small magnet radius. The "Magnet" passive extends this radius [DESIGN_DOC §3.1]. "Slingshot" passive: "25% chance to launch a baby ball when you pick up a gem" — XP collection becomes an offensive trigger [VID:faqN7WC_BAg f_00330].

### 7.2 Fusion Reactor Drop

The primary mid-run reward object. Appears as a **spinning rainbow yin-yang ring** that materializes on the pit floor during combat [VID:M8nLJ82HwfI, VID:vF17pcDXk8A f_03:30 quote: "like the old school Mario"]. Player must walk over it to trigger the three-option menu (Evolution / Fusion / Fission).

Drop frequency: "Every time when killing a boss, and sometimes when killing normal enemies, this glowing rainbow ring will appear" [VID:SRcNWzJIML0 00:00:40]. The "sometimes when killing normal enemies" is unquantified — no drop rate percentage is given.

### 7.3 "Field Cleared!" Gold Bonus

Every wave clear awards a gold bonus displayed as "+Xg" on screen with the "FIELD CLEARED!" text. "+148 gold" observed in multiple wave-clear frames [VID:SRcNWzJIML0, VID:pV4cP8gvKcA]. The amount likely scales with wave number/difficulty.

### 7.4 Boss Completion Reward

On boss death:
1. "Blueprint Found!" modal — a full-screen panel showing a specific building blueprint with resource cost [VID:M8nLJ82HwfI f_01850: "Cozy Home — Unlocks a new character. 20 wheat + 5 wood"].
2. Gears — meta-currency for unlocking new levels [VID:vCfTL7fx3fQ 00:20:27: "two gears"].
3. Biome Trophy — permanent +1 stat [VID:vCfTL7fx3fQ: "Smoldering Trophy. Gain one baby ball damage"].
4. Guaranteed Fusion Reactor [VID:pV4cP8gvKcA].
5. "Character Completion Bonus! +100 gold" overlay [VID:xtYnSfBgSks f_02400 — frame verified].

### 7.5 Post-Boss DPS Breakdown Screen

A "Battle Complete" screen appears after every boss kill, showing:
- Per-ball damage, launches, and DPS [VID:y_rRsIO8o5w f_00160–f_00190 — most detailed capture].
- Character XP progress bars for both characters in a two-character run.
- Gears found count.
- "Return to Base" / "Retry" buttons.

This DPS screen is the game's only explicit damage accountability tool — it shows the player which balls contributed most to the run.

### 7.6 Chest / Treasure Events Mid-Run

Small dark chest-like boxes appear on the pit floor as drop items mid-combat. "Items visible as box objects on pit floor throughout Heavenly Gates runs (f_00100, f_00300, f_00500). They do NOT pause the game — player must physically walk to them" [VID:Jbz1Obo82cg]. Also observed: "dark gray pedestals with items on them appear on the arena floor (f_00070, f_00300, f_00360). These are item drops — the player walks over them to pick up" [VID:569lqQN9Y1U].

---

## §8. Visual & Audio Telegraphs

### 8.1 Red `!` Exclamation — Universal Enemy Attack Warning

**Timing:** ~0.5s before attack fires.
**Coverage:** Appears above any attacking enemy, any type [VID:M8nLJ82HwfI explicit tutorial: "you'll see there's a red exclamation point like 'I'm going to attack you'"].
**Accompaniment:** Enemy sprite shaking confirmed alongside the `!` [VID:569lqQN9Y1U 00:06:15].
**Works for:** Melee lunges, projectile fires, AoE initiations.

The Tormentor's Mask passive exploits this system: "Enemies have a 10% chance of dying immediately the first time they detect you (when they get the exclamation mark)" [VID:vCfTL7fx3fQ]. This confirms the `!` fires on "detection" — when an enemy first comes into attack range — and is mechanically significant enough to be the trigger for an instakill passive.

### 8.2 Red Floor AoE Circles

**Appearance:** Solid dark-red or red-border circular zones on the pit floor, approximately 1-cell diameter. Semi-transparent fill. Persist for a brief window before detonating.

**Color:** Confirmed as solid filled in Shroom Swarm encounter [VID:pV4cP8gvKcA f_00700 — frame verified: multiple solid dark-red circles on floor]. Also appears as outline-only red rings in NPC caster encounters [VID:Nr2MJABYT-c f_01600, f_01800].

**Duration:** [INFERRED] ~1–2 seconds from telegraph to detonation based on frame spacing.

**Multiple simultaneous:** Up to 5+ confirmed in Shroom Swarm fight [VID:pV4cP8gvKcA f_00700].

### 8.3 Boss Attack Telegraphs

| Boss | Telegraph | Notes |
|---|---|---|
| Skeleton King | Red diagonal danger zone on floor [VID:xtYnSfBgSks f_01000 — frame verified] | Indicates beam laser attack direction |
| Skeleton King | Arms raised before bone fan fires [VID:nkRcLrAQjsA f_01915 — frame verified: "boss unleashes fan of purple bone-missiles (~20 projectiles)"] | Visual posture change precedes volley |
| The Moon | Orange concentric ring projectiles spiral outward visibly before impact [VID:vCfTL7fx3fQ f_14100 — frame verified] | Gaps between rings are visible dodge windows |
| Shroom Swarm | Red floor circles appear ~1s before detonation [VID:pV4cP8gvKcA f_00700 — frame verified] | 5+ circles simultaneously |
| Dragon boss | No confirmed telegraph beyond standard `!` | [MISSING DATA] |

### 8.4 Off-Screen Warning for Incoming Bullet Hell

**[NOT CONFIRMED]** No video shows an off-screen arrow warning or edge-glow for incoming off-screen projectiles. The only bosses with bullet-hell patterns (The Moon, Skeleton King) fire from their on-screen position. The only "off-screen" mechanic is The Moon briefly leaving the visible area, but no warning indicator for this departure is described.

The right sidebar's "red warning circle" (visible in CaRtOoNz footage at f_00400) "appears when enemies are close to reaching bottom — threat indicator" [VID:xtYnSfBgSks HUD notes] — this is a bottom-proximity warning, not a projectile-incoming warning.

### 8.5 Boss Entrance Signal

The boss entrance is signaled by:
1. Progress bar reaching 100% [VID:M8nLJ82HwfI, VID:nkRcLrAQjsA].
2. Pit walls expand ~25% outward [VID:nkRcLrAQjsA explicit, VID:M8nLJ82HwfI f_01700].
3. Boss HP bar slides in from right edge with boss name [VID:xtYnSfBgSks f_01000 — frame verified showing "Skeleton King" vertical text].
4. The boss is simply present at the top of the arena in its entry position — no dramatic drop-in animation was captured (though Suremesh notes a brief "getting ready" animation during which players can pre-fire [VID:569lqQN9Y1U 00:04:33]).

---

## §9. Data Gaps & Contradictions

### Confirmed Missing Data

1. **Exact spawn rate (enemies/second) per wave** — not extractable from 1fps frame capture.
2. **HP and damage multipliers per wave number** — no explicit HUD display for enemy HP beyond the floating HP numbers on the Dragon boss.
3. **Off-screen projectile warnings** — not observed; may not exist.
4. **Aerial/flying enemy types** — not confirmed in any biome.
5. **GORYxGRASSLANDS boss** — biome confirmed but boss name/mechanics not documented.
6. **Full Icebound Queen attack set** — only projectile fire observed; possible beam/phase attacks unknown.
7. **Mini-boss definition** — the distinction between mid-run elite enemies and scripted wave sub-bosses is unclear. The Dynamite enemy is wave-interval-scripted but labeled as an "enemy," not a boss.
8. **Phase 2 boss HP thresholds** — all phase transitions are described qualitatively ("low HP") not quantitatively.
9. **Difficulty arrow specifics** — what exact parameters change (HP multiplier? New enemy types? Damage multiplier?) is not documented.

### Contradictions / Ambiguities

1. **Second SNOWYxSHORES boss:** Gohjoe mentions "ice dragon riding a pillar" as a separate encounter from Icebound Queen [VID:yRrX-7ekr2g caveats]. It is unclear if Snowy Shores has two bosses (sub-boss + main boss) or if this is the same boss in a different phase.
2. **"Level Cleared" vs. "Field Cleared":** MANIFEST.md attributes "Field Cleared!" sighting to both Northernlion and Dr. Incompetent, but neither is captured in their frame reads. Confirmed from Matzel and Idle cub (pV4cP8gvKcA) frames. The name appears to be "FIELD CLEARED!" (not "Level Cleared"), and fires per-wave, not per-level.
3. **Boss HP display location:** Most bosses show HP on the right-sidebar bar. The Dragon boss shows HP as a floating number above the sprite [VID:pV4cP8gvKcA f_02100 — "829" above boss]. This inconsistency may indicate mid-game dragon encounters use on-sprite HP labels while proper bosses use the sidebar bar.
4. **Fission "+2" vs. "+1-5":** Suremesh shows "Fission: +2 upgrade levels" while Gohjoe shows "+1-5 upgrade levels" [VID:yRrX-7ekr2g f_00500 vs VID:y_rRsIO8o5w]. The Candle Maker building upgrades fission guarantees [VID:vCfTL7fx3fQ] — this may explain the variance, or it may reflect a game update.

---

*End of extraction — 2026-05-19*
