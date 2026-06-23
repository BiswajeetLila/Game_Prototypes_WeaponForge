# RICOCHET (working title) — Game Design Documentation

**Author:** Tarun (Lila Games, PM/founder)
**Date:** 2026-05-18
**Status:** First-pass design spec — pre-Phase-1 prototype
**One-line pitch:** *A portrait-orientation F2P-mobile reimagining of BALL x PIT's ball-fusion roguelite — built head-on into the Wittle Defender / Archero 2 hero-collector category.*

---

## 0. Citation & Tagging Conventions

This is a **design spec for a game we have not built yet**, not a research doc on a shipped game. Every claim is tagged with its provenance so a future reader can separate decisions from inspirations from open questions.

| Tag | Meaning | Strength |
|---|---|---|
| **[DESIGN]** | Locked design decision — Tarun has confirmed it | Highest |
| **[REF:BxP]** | Mechanic lifted from BALL x PIT (`BALL x PIT/DESIGN_DOC.md`) | High — battle-tested in source game |
| **[REF:Archero2]** | Lifted from Archero 2 (`Archero 2/Game_Design_Spec.md`) | High |
| **[REF:Wittle]** | Lifted from Wittle Defender (`Wittle Defender/wittle-defender-design-spec.md`) | High |
| **[REF:Capybara]** | Lifted from Capybara Go (`Capybara Go/Capybara_Go_Game_Design_Spec.md`) | High |
| **[INFERRED]** | Analytical inference from research corpus | Medium |
| **[PROTOTYPE]** | Open parameter — needs prototype data to lock | Low until tested |
| **[GAP]** | Information missing that we need before greenlight | — |

**Companion docs in this directory:** `101-BxP-Mobile-Concept.md` (template-driven concept validation summary), `concept-evaluation-BxP-mobile.md` (parent feasibility memo against `research-levers-v2.md`).

---

## 1. Executive Summary

RICOCHET is a **portrait-orientation, F2P-mobile, single-player ball-fusion roguelite** built around three commitments:

1. **BxP's brick-breaker fusion combat is the anchor.** Ricochet balls + level-3 fusion + Encyclopedia discovery is the inviolable core. The combinatorial richness (20 base balls × 59 evolved × 6,085 procedural fused = ~6,164 distinct ball outcomes per run [REF:BxP]) is the long-tail novelty engine — moving any of that to meta destroys what makes the source game work.

2. **Mobile-portrait controls + F2P progression are the two innovation pillars.** BxP's mobile port failed on (a) landscape orientation in a game whose pit is *literally already portrait*, and (b) a paid-unlock model that doesn't fit the audience. We fix both, structurally. Anchor + 2 pillars only — per `BLACK-retrospective-learnings.md` lesson #4. [DESIGN]

3. **Heroes are the gacha unit, balls are earned via play.** BxP's 21 heroes [REF:BxP §4.2] are uniquely *mode-bending* (turn-based, autoplay, no-baby-balls, etc.) — not stat variations — which makes hero gacha mechanically novel against Wittle's positional archetypes [REF:Wittle §3.1.7]. Balls are unlocked via gameplay (Encyclopedia hook), preserving F2P generosity. [DESIGN]

**Target audience:** Wittle Defender's audience — **92% male midcore TD-RPG / Vampire-Survivors-mobile players**, mostly Western + Southeast Asia [REF:Wittle §10.2]. Ad creative benchmarked head-on against Wittle. [DESIGN]

**Scope at launch:**

| Axis | Decision | Source |
|---|---|---|
| Orientation | Portrait only | [DESIGN] |
| PvP | None at launch; Year-2 candidate | [DESIGN] |
| Town builder | Cut — replaced with a single-screen "Lab" hub | [DESIGN] |
| Monetization | Hero gacha primary; balls earned; outfits deferred 3 months | [DESIGN] |
| Session length target | 5–7 minutes per run (vs BxP's 15-min default) | [PROTOTYPE] — match Wittle's 5min target [REF:Wittle §2.6] |
| Retention targets | D1 ≥ 35% (Wittle 45.9%); D7 ≥ 14% (Wittle 19.2%); D30 ≥ 5% (Wittle 7.2%) | [DESIGN] floor, [REF:Wittle] benchmarks |

**Single fragile assumption (§14 expands):** mobile players who currently play Wittle / Archero 2 will trade their auto-attack loop for a **bouncing-ball loop with the same hero-collection structure** — because ball-fusion produces "screen-clearing" moments that current games can't.

If that assumption is wrong, the concept dies. Phase 1 prototype exists to falsify it cheap.

---

## 2. Game Identity & Positioning

### 2.1 Pitch (player-voice, 100 words)

You play a hero standing at the bottom of a tall narrow pit. Enemies pour down from the top. You fire ricocheting balls up at them — balls bounce off walls, off each other, off enemies. Every level-up you draft a new ball, or fuse two existing ones into something new. By minute three of a run you have 50 balls in the air at once. Each new hero you collect plays *fundamentally* differently — one makes combat turn-based, another auto-plays, another has gravity. Five minutes a run. Twenty waves. A boss at the end.

### 2.2 Genre stack

**Primary tags (Play Store / App Store):** Action · Roguelike · Bullet Hell · Hero Collector · Brick Breaker · Hybrid Casual · Portrait · F2P

**Genre mashup formula:** *Brick-breaker × Vampire-Survivors × hero collector — anchored in BxP's ball-fusion combinatorics.* [DESIGN]

### 2.3 Closest comparables and where we differ

| Reference | What we share | What we don't |
|---|---|---|
| **BALL x PIT** (Kenny Sun / Devolver, 2025) | Anchor — ball physics, fusion, evolution, fission, heroes, biomes, Encyclopedia | Portrait orientation, F2P-mobile economy, no town builder, simplified controls, hero-gacha meta |
| **Archero 2** (Habby, 2024) | Hero-gacha shape, shard-based star-up, Resonance pattern, multi-currency horizontal progression | Auto-attack (we have manual-aim+catch); mech-DPS focus (we have bounce-trajectory skill expression) |
| **Wittle Defender** (Habby, 2025) | Audience, slot-not-hero upgrade pattern, daily-ticket mode roster, 5-min session length | Positional team combat (we are single-hero); chibi-medieval tone (we are pixel-cyberpunk-fantasy, see §2.4); 8-axis sprawl (we cap at 5) |
| **Capybara Go** (Habby, 2024) | Idle/offline earnings hub, F2P generosity beats, "always something accruing" economy | Tap-card story format (we are real-time action); 17-axis progression (we cap at 5) |
| **Vampire Survivors Mobile** (poncle, 2022) | Auto-elements + draft-stacking + screen-clearing endgame VFX | Hero-collector layer they don't have |

### 2.4 Art direction (placeholder)

[DESIGN] [PROTOTYPE] **Pixel art, but more saturated and "magical" than BxP's earthy palette.** BxP biomes are gritty-fantasy (BoneYard, FungalForest); we tilt toward cooler-saturated arcade-VS-bullet-hell (think Enter the Gungeon + Streets of Rogue + Brotato palette). Heroes are 32×32 chibi-with-attitude — recognizable at thumbnail size. Each hero gets a 1024×1024 portrait for the gacha pull animation.

Justification: chibi-medieval is Wittle's lane and Habby owns it. Pixel-arcade-magical is whitespace inside the same audience (the 5★ Wittle reviews repeatedly cite "cute" — we differentiate as "cool" without going dark/edgy). [INFERRED]

### 2.5 Working title

**RICOCHET** (placeholder) [DESIGN]. Single word, evokes the ball-bounce mechanic, available across major app stores and trademark registries as of last check [GAP — verify with legal pre-Phase-2].

Alternate candidates considered: *Fusion Pit, BounceCraft, Pit Heroes, Ball Saga*. RICOCHET wins on memorability + thumbnail-iconability + verb-as-name pattern (cf. *Brotato, Archero, Survivor.io*).

### 2.6 Platforms & monetization model

| Platform | Release order | Model |
|---|---|---|
| Android (Google Play) | Primary launch | F2P, IAP + ads |
| iOS App Store | Day-1 simultaneous | Same |
| PC (Steam) | Year 2 evaluation only | [GAP — strategic call deferred] |

**Monetization stack (full detail in §11):**
- Hero gacha (primary)
- Battle Pass (free + premium track)
- Daily/weekly spend offers (Beginner Pack, Lifetime Privilege, Monthly Pass pattern from [REF:Wittle §9.2])
- Outfits / Skins as whale hook — deferred 3 months post-launch [DESIGN]
- No ad walls on basic rewards [DESIGN] — top-cited [REF:Wittle] ★1 complaint, structural fix

---

## 3. The Core Loop, at Three Time-Scales

### 3.1 Second-to-second: the Pit phase (5–7 min per run)

A run takes place in **The Pit** — a tall narrow vertical corridor with the player at the bottom and waves of enemies descending from the top. [REF:BxP §3.1] Default run length is **6 minutes** [DESIGN], down from BxP's 15min to match Wittle's 5-min session length [REF:Wittle §2.6].

**Per-second action:**

1. Player **moves** along the bottom strip of the arena (1D horizontal motion only — the slot is ~70% of screen width). [REF:BxP, simplified]
2. Player **aims** — exact input depends on control scheme (§7). A white dotted trajectory line previews the ball's flight path, including the first ricochet. [REF:BxP §3.1.2]
3. Player **fires** a special ball. Auto-fire toggle exists for accessibility but is not the default. [DESIGN]
4. Balls bounce off walls + enemies. When they return to the player's altitude, **catching reloads** instantly — the player can physically reach up to catch [REF:BxP §3.1.4], OR if Catch-Tap mode is on, taps the ball mid-flight. [PROTOTYPE — see §7.9]
5. **Baby balls** (small white passive projectiles) spawn from various sources (Brood Mother, Egg Sac passives) and bounce freely doing chip damage. [REF:BxP]
6. Enemies attack — telegraphed with a red `!` ~0.5s before they fire/lunge. [REF:BxP §3.1.6]
7. Enemy deaths drop cyan XP gems (auto-magnet), gold coins, occasional health potions. [REF:BxP §3.1.7]
8. **Level-up** triggers a 3-card upgrade panel that slides over the **bottom half** of the screen (portrait variant — BxP's left-half does not translate). [DESIGN] **The top half stays live and the player must keep dodging while choosing.** [REF:BxP §3.1.9]
9. Mid-run, **Fusion Reactor orbs** materialize on the field — pickup opens an **Evolution / Fusion / Fission** menu, again as a transparent overlay over live combat. [REF:BxP §3.1.10] Three combine systems are preserved verbatim from BxP (§5).
10. Around minute 5, **boss spawns** — pit "expands" by ~25% width (camera lerp), boss takes upper third, run-ends-in-1-minute-ish. [REF:BxP §3.1.11]
11. Boss defeated → **DPS breakdown screen** ranking ball/passive contribution, then **rewards modal** (shards, gold, ball blueprints, occasional 4★ hero shard). [REF:BxP §3.1.12, adapted]

### 3.2 Run-to-run: build construction (5–7 min arc)

Compressed from BxP's 3-act 15-minute structure into a tighter 3-beat 6-minute arc [DESIGN]:

- **Act 1 (0:00–~2:00) — establish the build.** Pick up your first 2–3 balls. Damage numbers in the 14–60 range. Player learns the deck.
- **Act 2 (~2:00–~5:00) — fuse, evolve, fission.** Fill 4 ball slots + 4 passive slots. Combine balls to make room. The deck-building phase. Damage numbers 100–500.
- **Act 3 (~5:00–~6:00) — boss.** Field widens, boss occupies upper third, mechanical patterns emerge. Late-game damage 2000+.

Run ends in one of three ways:
- **Victory** (boss killed) → boss-drops modal + DPS breakdown + post-run summary
- **Defeat** (HP hits 0) → run-end with partial rewards
- **Eject** (player quits — confirmation dialog) → no rewards [DESIGN — anti-rage-quit]

### 3.3 Hour-to-hour: the Lab + chapter map (no town builder)

After every run, the player returns to **the Lab** — a single-screen pixel-art hub showing:

- A central pixel character (player avatar) standing in a small workshop
- **One idle building (the Ball Forge)** — generates Gold + Ball XP while offline, cap 12h, claim button visible [DESIGN] [REF:Capybara — Quick Patrol pattern]
- **Hero roster button** — opens grid of owned heroes + locked silhouettes
- **Map button** — opens chapter map (Archero-style level grid, 8 biomes × ~6 chapters each)
- **Mailbox / Shop / Battle Pass / Events** standard mobile-RPG menu icons

**No placement puzzle. No pinball harvest. No expansion of land.** [DESIGN] — the polarizing element from BxP that reviewers called *"a fifth wheel"*, *"forced"*, *"clunky"* [REF:BxP §10] is replaced wholesale.

This is the single biggest mechanical departure from BxP and the single biggest production-cost saving. [INFERRED]

### 3.4 Day-to-day: the daily/weekly cadence (D2+)

[REF:Wittle §7] retention architecture, simplified from 5 layers to 3:

- **Layer 1 — Daily energy** (5 energy/run, regen 12 min/energy → 1 hr for 5 runs without ads). [DESIGN] Mirrors [REF:Wittle §5] but more generous on regen.
- **Layer 2 — Daily ticket modes** (3 modes at launch: Quick-Run for shard farming, Boss Rush for gear material, Coin Cave for gold; each gives 3 tickets/day). [DESIGN, deliberately leaner than Wittle's 6+ modes — anti-"red dot hell" [REF:Wittle §11]]
- **Layer 3 — Weekly + event cadence** (Weekly Leaderboard on Endless Mode; 30-day Battle Pass; 14–21-day rate-up events). [DESIGN] [REF:Wittle §7.4]

---

## 4. Combat Systems Deep-Dive

### 4.1 Heroes — the gacha unit

**21 heroes at launch**, ported from BxP's roster [REF:BxP §4.2]. Each hero's defining mechanical hook is preserved; the cosmetic/voice/personality layer can be re-themed if IP rights aren't secured [GAP — legal/strategic call].

Full launch roster (BxP §4.2 verbatim with mobile-fit annotations):

| # | Hero | Starter Ball | Hook | Mode-bender? | Production tier |
|---|---|---|---|---|---|
| 1 | The Warrior | Bleed | Vanilla; "no special quirks" | No | Tutorial hero — Tier 0 |
| 2 | The Itchy Finger | Burn | 2× fire rate; full-speed-while-shooting; autoshoot constantly | No | Stat-flavor — Tier 1 |
| 3 | The Repentant | Freeze | +5% damage/bounce; back-wall hit pierces enemies | No | Stat-flavor — Tier 1 |
| 4 | The Cohabitants | Brood Mother | Mirror-shoots; both copies deal half damage | Light | Stat-flavor — Tier 1 |
| 5 | The Cogitator | Laser-V | Auto-chooses upgrades during runs | Yes | Mode-bender — Tier 2 |
| 6 | The Embedded | Poison | Balls pierce all enemies until they hit a wall | No | Stat-flavor — Tier 1 |
| 7 | The Empty Nester | Ghost | **NO baby balls;** each shot launches multiple instances of one special ball | Yes | Mode-bender — Tier 2 |
| 8 | The Shade | Dark | Shoots from **back** of screen; 10% base crit | Yes | Mode-bender — Tier 2 |
| 9 | The Makeshift Sisyphus | Earthquake | **Balls do NO direct damage;** AoE/status ×4; no baby balls | Yes | Mode-bender — Tier 3 (engineering-heavy) |
| 10 | The Shieldbearer | Iron | Holds shield that bounces balls back | Light | Stat-flavor — Tier 1 |
| 11 | The Spendthrift | Vampire | Shoots all 4 balls at once in wide arc | Light | Stat-flavor — Tier 1 |
| 12 | The Physicist | Light | Balls affected by gravity, pulled toward back | Yes | Mode-bender — Tier 2 |
| 13 | The Juggler | Lightning | Lobs balls into the air; don't bounce until they land | Yes | Mode-bender — Tier 2 |
| 14 | The Flagellant | Egg Sac | Balls bounce off bottom — never return | Yes | Mode-bender — Tier 3 |
| 15 | The Tactician | Iron | **Combat becomes turn-based** | Yes | Mode-bender — Tier 3 (engineering-heavy) |
| 16 | The Tunneller | Earthquake | Balls wrap around top/bottom edges | Light | Stat-flavor — Tier 2 |
| 17 | The Tiptoer | Laser-H | Stealth — enemies don't detect you (except bosses); reduced HP | Yes | Mode-bender — Tier 2 |
| 18 | The Radical | Wind | **Plays the game for you** (auto-everything) | Yes | Mode-bender — Tier 3 |
| 19 | The Falconer | Lightning | Balls shoot from two falcons on side of screen | Yes | Mode-bender — Tier 2 |
| 20 | The Carouser | Charm | Balls briefly orbit player on return | No | Stat-flavor — Tier 1 |
| 21 | The False Messiah | Bleed | Twitch/chat-vote driven choices | Yes | **Cut at launch** — PC-only [DESIGN] |

**Production tier definitions** [DESIGN]:
- **Tier 0** — tutorial hero, fully owned (1 dev-sprint to ship at launch quality)
- **Tier 1 — Stat-flavor** — same combat rules + different starter ball + 2–3 passive tweaks (~1 sprint each, suitable for standard banner)
- **Tier 2 — Light mode-bender** — modified ball physics or input behavior (2–3 sprints each)
- **Tier 3 — Heavy mode-bender** — fundamental combat-rule change (Tactician's turn-based, Sisyphus's no-direct-damage, Radical's autoplay) (4–6 sprints each, limited-banner only)

**Launch composition:** 1× Tier 0 + 11× Tier 1 + 6× Tier 2 + 3× Tier 3 = **20 heroes** (Tier 3's Tactician, Radical, Flagellant; False Messiah cut).

### 4.2 Hero attributes & derived stats

[REF:BxP §4.1] verbatim — 6 attributes (Endurance/Strength/Leadership/Speed/Dexterity/Intelligence), 11 derived stats (HP, Base Damage range, Baby Ball Count, Baby Ball Damage, Ball Speed, Move Speed, Crit Chance, Fire Rate, AOE Power, Status Effect Power, Passive Power).

Attribute scaling: **E → D → C → B → A → S** (BxP uses E→A; we add S as the long-tail mastery gate per [REF:BxP] achievement "S Rank" hint). [DESIGN]

### 4.3 Balls — the centerpiece system

**Three tiers** [REF:BxP §4.3]:

1. **Baby Balls** — passive white projectiles, ~5–12 per hero per run, scale with the Baby Ball Count stat. Free chip damage. All characters start with some (except Empty Nester & Sisyphus).
2. **Special Balls** (player-controlled, ricochet) — **20 base + 59 evolved = 79 named balls** at launch [DESIGN, matches BxP launch state].
3. **Fused Balls** — procedural hybrids. Any two unfused level-3 special balls can fuse, with rules: balls that *evolve* into a named result must be evolved, not fused. The fused result inherits both parents' effects. [REF:BxP §4.3]

**Combinatorial math:** 20 base × 19 fuse partners = 380 unique 2-ball fuses × handling rule-out for evolvable pairs ≈ ~280 unique procedural fuses + further-fusion cascades ≈ **6,000+ distinct ball outcomes per run** [REF:BxP, retained]. This is the long-tail novelty engine.

**Ball acquisition pattern (NOT gacha)** [DESIGN]:
- **Baby balls + 6 starter Special Balls** — owned at account creation
- **Balls 7–20 (base set)** — unlocked by first-clear of each chapter
- **Balls 21–79 (evolved)** — unlocked by **discovering** the evolution mid-run AND surviving to extract; once unlocked the recipe shows in Encyclopedia
- **Procedural fused balls** — auto-generated in-run, do not persist beyond the run
- **Account-wide Encyclopedia** tracks discovery (BxP has this; we deepen it with social comparison — *"34% of all players have discovered Nosferatu"*) [DESIGN] [REF:BxP §6.D2]

### 4.4 Three combine systems (preserved verbatim from BxP)

[REF:BxP §4.4] All three are inviolable in-run mechanics:

1. **Fusion** — two level-3 balls → one procedural hybrid with both effects, frees a ball slot.
2. **Evolution** — two level-3 balls of a specific recipe → one named Evolved Ball with new mechanics. 59 recipes including:
   - Vampire Lord = Bleed + Vampire (heals on bleed consumption)
   - Hemorrhage = Bleed + Iron (consumes bleed for 20% current-HP damage)
   - Holy Laser = Laser-V + Laser-H (deals to full row + column)
   - Satan = Incubus + Succubus (burn-everything + berserk-everything)
   - Nuclear Bomb = Bomb + Poison (300-500 AoE + radiation stacks)
   - Nosferatu = Vampire Lord + Spider Queen + Mosquito King (3-ball fusion, achievement-tier)
   - Reaper = Soul Sucker + Heart Swallower (10% instant-kill heal-on-kill)
   - Black Hole = Sun + (Dark or Time) (instant-kill non-bosses, 7s cooldown)
   - Timestop = Time + Freeze (freezes everything 5s, self-destructs)
   - Many more — full list in [REF:BxP §4.4]
3. **Fission** — one ball → +1 to +5 levels per ball, hitting 1–4 player balls. Max roll = all 4 balls +1 level simultaneously (full-screen cosmic VFX + "Whoa" confirm button).

### 4.5 Passives — 53 base + 13 evolved

[REF:BxP §4.5] retained verbatim. Passives level to 3, can evolve via Fusion Reactor, cannot be fused. 4 dedicated slots in HUD.

Categories:
- **Defensive** (Breastplate, Protective Charm)
- **Damage scaling** (Hourglass +150% damage decay-on-bounce, Sword Breaker -40%+1%/enemy, Iron Onesie +0.5%/baby ball)
- **Crit** (Deadeye's Amulet, the 4-Dagger system → Deadeye's Cross +60% crit)
- **Summon** (Stone Effigy, Golden Bull, Archer's Effigy, Healer's Effigy)
- **Resource** (Gemspring — spawns XP gem dispenser every 7–11 rows)
- **Mobility** (Fleet Feet, Radiant Feather, Wings of the Anointed)
- **Heal** (Vampiric Sword, Lover's Quiver, Soul Reaver)

### 4.6 Enemy roster

[REF:BxP §4.6] retained — **87 cataloged enemies across 8 biomes**. Sprite-progressive damage (clean → bloodied → broken-armor → dark-tint). 0.5s red `!` telegraph before attacks. Archers fire flaming arrows that can be **shot out of the sky** with player balls.

Biomes (preserved verbatim from BxP for clarity, may be re-themed pre-launch [GAP]):

1. THE BONExYARD (tutorial biome — free to enter)
2. THE SNOWYxSHORES
3. THE LIMINALxDESERT
4. THE FUNGALxFOREST
5. THE GORYxGRASSLANDS
6. THE SMOLDERINGxDEPTHS
7. THE HEAVENLYxGATES
8. THE VASTxVOID

Biome-gating uses Gear-like progression [REF:BxP] — each layer requires 2–5 "keys" from earlier-layer first-clears. We retain this; it's a clean F2P pacing tool.

### 4.7 Boss roster

[REF:BxP] **8 bosses, one per biome.** Names retained for design clarity; rethemable. Defining mechanics:

| Biome | Boss | Mechanic hook |
|---|---|---|
| BoneYard | Skeleton King | Back-only crit zone, purple bone-fan attack, beam laser danger zone |
| SnowyShores | Icebound Queen | Frost AoE + cone freeze attacks |
| LiminalDesert | TBD | [GAP — BxP wiki does not detail] |
| FungalForest | Shroom Swarm | Cluster of oversized purple mushrooms, 5+ floor AoE circles |
| FungalForest (late) | Dragon Prince | Large ornate skull, boss HP shown as floating number |
| GoryGrasslands | TBD | [GAP] |
| SmolderingDepths | TBD | [GAP] |
| HeavenlyGates | TBD | [GAP] |
| VastVoid | **The Moon** | Concentric ring bullet-hell + green/blue projectiles, red label = final-boss signal |

---

## 5. UX / Controls — All 8 Schemes for Phase-1 Prototyping

Per Tarun's explicit instruction, **all 8 control schemes** generated in the UX brainstorm are documented here for prototyping. The ranked recommendation is at §5.9.

Every scheme below assumes:
- **Portrait orientation only**
- **The pit corridor occupies ~85% of vertical screen**, with the **bottom 15% reserved for control UI** [DESIGN]
- **Trajectory preview** (white dotted parabola showing first bounce) is universal — present in all 8 schemes
- **Catching is a player-skill micro-game** — universal, but the catch input differs per scheme

### 5.1 Scheme A — Drag-Aim Anchor

```
┌──────────────────────────────┐
│                              │
│           ENEMIES            │
│                              │
│        \                     │
│         \  ← trajectory      │
│          \   preview         │
│           \                  │
│        ◆ player              │
├──────────────────────────────┤
│  ◀──◀──◀ MOVE                │ 1D stick (left)
│              ┌─aim─┐         │
│              │ ◯   │ ← drag  │
│              └─────┘         │
└──────────────────────────────┘
```

**Description:** Right thumb rests anywhere on the bottom-right half of the screen. Touch-down spawns a dynamic aim reticle anchored to the player position. Dragging the thumb rotates the launch angle in real time. Lift to fire. Left thumb on a dynamic 1D horizontal stick for movement (the stick appears where you touch). Catching is a tap on the descending ball.

**Aim skill expression:** **High** — full analog angle control with bounce preview.
**One-thumb playable?** Partial — right-thumb-only with movement set to auto-strafe toggle.
**Biggest risk:** Right thumb occludes the trajectory preview at low angles.
**Closest reference:** Free Fire dynamic sticks + mobile sniper drag-to-aim.
**Verdict:** The honest BxP translation — earns its skill.
**Prototype scope:** 2 days of greybox dev; A/B vs Scheme G as the "high-fidelity port" baseline.

### 5.2 Scheme B — Tilt-the-Pit (Gyro Aim)

```
┌──────────────────────────────┐
│                              │
│           ENEMIES            │
│                              │
│        / ← angle changes     │
│       /    as you tilt phone │
│        ◆ player              │
├──────────────────────────────┤
│  ◀──◀──◀ MOVE      ⊕ FIRE   │
└──────────────────────────────┘
```

**Description:** Left thumb on a dynamic 1D horizontal movement stick. Aim is controlled by tilting the device — gyro maps pitch/roll to launch angle within a clamped cone. Right-side tap fires; hold-to-charge optional. Trajectory preview always visible. Catching is a tap.

**Aim skill expression:** **Med** — gyro feels skillful but hard to be surgical with on a 1D-bounce parabola.
**One-thumb playable?** Yes — left thumb only, gyro does aim, tap fires.
**Biggest risk:** Gyro nausea + can't play prone / on transit. Recalibration UX is brutal.
**Closest reference:** Splatoon gyro / mobile sniper games.
**Verdict:** Beloved by 5%, uninstalled by the other 95%.
**Prototype scope:** 1 day of greybox dev; ship as an *accessibility-toggle option* even if not the default.

### 5.3 Scheme C — Sweep Bar

```
┌──────────────────────────────┐
│                              │
│      ↑ tap-anywhere ↑        │
│      ↑   to set     ↑        │
│      ↑   angle      ↑        │
│      ↑              ↑        │
│        ◆ player              │
├──────────────────────────────┤
│ [══════ ◆ ══════════] ← bar  │ absolute 1D
└──────────────────────────────┘
```

**Description:** Bottom 15% of screen is a horizontal **"control bar"** — dragging horizontally inside the bar moves the player **1:1 with thumb position** (absolute, not stick — solves the *"why slide, I just want to move"* complaint verbatim from [REF:BxP Play Store reviews]). Aim is controlled by a second drag on the upper screen: touch anywhere above the bar to set angle (line from player to touch point), drag to refine, lift to fire. Trajectory preview from touch-down. Catching is a tap.

**Aim skill expression:** **High** — touch-anywhere aim is unconstrained and precise.
**One-thumb playable?** No — fundamentally two-zone, two-thumb.
**Biggest risk:** Players forget which zone does what; aim taps near the bar are misread as movement.
**Closest reference:** Peggle (tap-aim) + Crossy Road (zoned tap).
**Verdict:** Directly answers the verbatim review complaints from BxP mobile.
**Prototype scope:** 3 days — needs careful zone-boundary tuning; ship with a clear visual divider.

### 5.4 Scheme D — Auto-Fire + Manual Aim ("Archero+Aim")

```
┌──────────────────────────────┐
│                              │
│           ENEMIES            │
│                              │
│        \  auto-fire at       │
│         \ this angle ⤴       │
│          \                   │
│        ◆ player              │
├──────────────────────────────┤
│  ┌MOVE┐         ┌─arc─┐      │
│  │ ⊕  │         │ ◐   │ aim  │
│  └────┘         └─────┘ dial │
└──────────────────────────────┘
```

**Description:** Single dynamic left joystick for movement (Archero-style — stand still to fire, move to stop firing) [REF:Archero2 §3.1]. Auto-fire is on. Aim angle is controlled by a small **180° dial-slider** pinned to the bottom-right, sweepable by the right thumb. Player chooses angle, stands still, balls fire automatically on cadence. Catching is auto-return + a tap-bonus for instant-reload.

**Aim skill expression:** **Med** — angle is manual but firing cadence isn't; bounce-chaining still rewards thought.
**One-thumb playable?** Partial — playable left-thumb-only with auto-aim fallback toggle.
**Biggest risk:** Erodes BxP's "fire on my terms" feel; BxP fans will revolt, Wittle/Archero converts will love it.
**Closest reference:** Archero 2 / Brotato + Peggle's angle dial.
**Verdict:** The safe commercial bet — best for Wittle-audience comfort.
**Prototype scope:** 2 days — sub-element-test as the "audience-comfort baseline" in playtests.

### 5.5 Scheme E — Pull-Back Slingshot  ❌ REJECTED in round-1 review

**Status:** Rejected — "needs constant user input to keep fighting, not good." Documented below for completeness; do not include in prototype roster.

```
┌──────────────────────────────┐
│                              │
│           ENEMIES            │
│                              │
│      ↗   ← reverse of        │
│     ↗      drag direction    │
│    ↗                         │
│   ↗   ◆ player               │
│    ↘  ← drag thumb down      │
├──────────────────────────────┤
│   to charge & release        │
└──────────────────────────────┘
```

**Description:** Touch and drag **downward** anywhere on screen to pull back a virtual slingshot from the player's position. Drag distance is **fixed power** (this isn't Angry Birds — power is constant); drag direction sets the **inverse** launch angle. Trajectory preview during drag. Release to fire. Movement is a separate left-side dynamic 1D stick OR a swipe-along-bottom gesture (player-configurable). Catching is a tap.

**Aim skill expression:** **High** — physical, tactile, satisfying. Best "game feel" of any option here.
**One-thumb playable?** Yes — single-thumb mode disables movement and the game becomes positional-only between volleys (could be its own mode).
**Biggest risk:** Slingshot drag conflicts with movement gesture; players in panic mode pull down when they meant to dodge.
**Closest reference:** Angry Birds drag-back-release.
**Verdict:** The differentiator. Highest ceiling, highest risk. Best for TikTok clips.
**Prototype scope:** 4 days — gesture-conflict resolution is the hard work; needs careful onboarding.

### 5.6 Scheme F — Tap-to-Aim Discrete  ❌ REJECTED in round-1 review

**Status:** Rejected — "too many taps to just move around." Documented below for completeness; do not include in prototype roster.

```
┌──────────────────────────────┐
│                              │
│           ENEMIES            │
│                              │
│        × ← tap here to       │
│            target this point │
│                              │
│        ◆ player              │
├──────────────────────────────┤
│  ◀                        ▶  │ tap edges
│       to dodge step          │ to move
└──────────────────────────────┘
```

**Description:** Tap anywhere on the playfield — a parabola is computed from player to tap point and previewed for ~150ms, then a ball **fires automatically** along it. No drag, no hold — just tap where you want the **first bounce or impact point** to be. Movement is tap-left-edge / tap-right-edge zones (Crossy Road style) for discrete dodge-steps, OR hold-edge for continuous slide. Catching is a tap.

**Aim skill expression:** **Med** — you choose the target point but not the bounce chain explicitly; the game solves the parabola.
**One-thumb playable?** Yes — everything is a tap.
**Biggest risk:** "Tap to move" vs "tap to aim" disambiguation. The bottom strip is for movement, the rest is for aim — but panicked players tap-aim into their own movement zone.
**Closest reference:** Crossy Road taps + shooting-gallery tap-fire.
**Verdict:** Cleanest one-thumb; sacrifices bounce-chain authorship.
**Prototype scope:** 2 days — disambiguation tuning is the variable.

### 5.7 Scheme G — Aim-Lock Hold (recommended #1)

```
┌──────────────────────────────┐
│                              │
│           ENEMIES            │
│                              │
│        ↗ AUTO-AIM            │
│       ↗  default ←           │
│      ↗                       │
│        ◆ player              │
│                              │
│  HOLD-RIGHT-THUMB to FREEZE  │
│  player + enter manual aim   │
├──────────────────────────────┤
│  ┌MOVE┐     ┌──aim hold──┐   │
│  │ ⊕  │     │      ⊕     │   │
│  └────┘     └────────────┘   │
└──────────────────────────────┘
```

**Description:** Default state — **auto-aim** at nearest threat with auto-fire cadence (Wittle/Archero familiarity). **Holding the right thumb anywhere on screen FREEZES the player in place AND enters manual aim mode** — a radial drag from the hold point sets exact angle, with trajectory preview. Release to fire that angle. No hold = auto-fire on auto-aim cadence. Left thumb is a dynamic 1D movement stick. Catching is a tap.

**Aim skill expression:** **High when it matters, Low when it doesn't** — best of both worlds. Player opts into precision.
**One-thumb playable?** Yes — right-thumb-only works with auto-movement toggle.
**Biggest risk:** Two-mode systems confuse new players; the moment-to-moment "am I in auto or manual?" cognitive load. Needs strong visual mode indicator (e.g., colored ring around player when manual aim is active).
**Closest reference:** Free Fire ADS-toggle + Archero auto-fire.
**Verdict:** The smart hybrid — most design work required.
**Prototype scope:** 5 days — visual mode indicator + onboarding flow are non-trivial; this is THE prototype to nail.

### 5.8 Scheme H — Bounce-Painter  ❌ REJECTED in round-1 review

**Status:** Rejected — "too confusing." Documented below for completeness; do not include in prototype roster.

```
┌──────────────────────────────┐
│ paint │             │ paint  │
│  here │   ENEMIES   │  here  │
│  ╱─╲  │             │  ╱─╲   │
│  ╲ ╱→ to "paint"  ←╲ ╱       │
│  bounce points              │
│        ◆ player              │
├──────────────────────────────┤
│  [═══════ ◆ ════════]        │ movement
└──────────────────────────────┘
```

**Description:** **Drag a finger along the side walls of the pit** to "paint" desired bounce points — the system fires a ball whose trajectory passes through your painted points (up to 2). Lifting off = fire. Movement is bottom-strip absolute drag (Scheme C's bar). One thumb can paint AND move by alternating. Catching is a tap.

**Aim skill expression:** **High** — uniquely expressive, lets you author bounce chains directly.
**One-thumb playable?** Yes — single thumb alternates between movement bar and paint canvas.
**Biggest risk:** **Completely novel input metaphor** — tutorial cost is enormous, and Wittle audience has zero pattern-match for it. High player rejection risk.
**Closest reference:** None directly — closest is Peggle's slider but in 2D.
**Verdict:** The trap — beautiful in theory, dies in onboarding.
**Prototype scope:** 6 days but expect to ship as a *post-launch advanced mode* if it survives the playtest, NOT default.

### 5.9 Ranked recommendation for Phase 1

| Rank | Scheme | Why |
|---|---|---|
| 1 | **G — Aim-Lock Hold** | Best identity-preservation-to-accessibility ratio. Wittle/Archero muscle memory satisfied by auto-default; BxP's aim-skill expression preserved on hold-demand. The "am I in auto or manual?" cognitive load is the main risk and is solvable with strong visual indication. **Prototype this first.** |
| 2 | **A — Drag-Aim Anchor** | Most honest port of BxP's aim feel. If Aim-Lock's mode-switching confuses cold-start players, this is the fallback — full skill expression at the cost of being more demanding. |
| 3 | **E — Pull-Back Slingshot** | Differentiator prototype. Best "game feel" of any scheme. Highest TikTok-clippability. If we want a "feels-amazing" hook no Survivor.io clone has, this is it. Higher bust risk, but the upside is a control scheme players talk about. |

**Skip first (still prototype but lower priority):**
- **H — Bounce-Painter** (too novel for Wittle audience)
- **B — Tilt-the-Pit** (gyro nausea + can't play prone — ship as an accessibility toggle, not default)
- **D — Archero+Aim** (loses BxP identity even if it'd print money — keep in pocket as the "panic-pivot" if all 3 top schemes fail)

**Prototype-all approach Tarun requested:** [DESIGN] Build all 8 in greybox during Phase 1 weeks 1–6, A/B test the top-3 against each other in weeks 7–10 with the 50-player playtest cohort, lock the final control scheme by week 12 going into Phase 2.

### 5.10 Universal UX rules across all schemes

These apply regardless of which scheme wins [DESIGN]:

1. **Trajectory preview is always-on** during aim (the white dotted parabola). Optional setting to disable for advanced players who want to internalize the physics.
2. **Catching is a tap on the descending ball.** Successful catches give a small "+15% reload speed for 3 seconds" buff to make skill-catching feel mechanically rewarding rather than purely fast-flow.
3. **Auto-fire toggle exists in all schemes** for accessibility. Default is OFF. Players can switch in settings.
4. **Level-up panel slides over bottom half of screen**, top half stays live. [REF:BxP §3.1.9, adapted to portrait]
5. **Fusion Reactor overlay is bottom-anchored** modal. Same logic — top half stays live.
6. **One-handed Mode** as a player-selectable setting — disables one of the input zones and routes everything through the other thumb. [DESIGN]
7. **Haptic feedback** on catch, level-up, fusion trigger, boss spawn. [DESIGN]

---

## 5.11 Round 2 — Additional Control Schemes (12 more, from 3-lens brainstorm)

After round-1 review, schemes E (Pull-Back Slingshot), F (Tap-to-Aim Discrete), and H (Bounce-Painter) were rejected with specific reasons:

- **E** — *"needs constant user input to keep fighting, not good"*
- **F** — *"too many taps to just move around"*
- **H** — *"too confusing"*

Round 2 launched three parallel UX-designer agents in parallel, each through a distinct lens, each producing 4 new schemes:

| Lens | Constraint | Schemes |
|---|---|---|
| **Comfort lens** | Maximum Wittle/Archero one-thumb feel. Auto-fire default. Aim skill optional. | I, J, K, L |
| **Trajectory-editor lens** | Invert the model — balls auto-fire, player edits the trajectory's apex / target / bounce point instead of setting raw angle. | M, N, O, P |
| **Mobile-convention lens** | Mine shipped portrait hits for proven patterns. Each scheme cites a real shipped game. | Q, R, S, T |

All 12 honor the round-1 rejection lessons: no constant input loops, no discrete-tap-to-move movement, no novel-metaphor confusion. [DESIGN]

---

### Comfort lens (I, J, K, L) — maximum Wittle/Archero one-thumb feel

#### 5.11.1 Scheme I — Drift Pad  ⭐ Comfort-lens winner

**Description:** Bottom-third of screen is a wide invisible touchpad. Rest your thumb anywhere on it and the player drifts toward your thumb's horizontal position with smoothing — magnetic glide rather than 1:1 stick. Auto-fire is always on; auto-aim picks the nearest enemy by default. The *only* skill input is a quick upward flick from your resting thumb — this triggers a **1.5s "Steered Volley"** where the next 3 balls fire toward where you flicked. Catching is automatic when you're under the ball. Lift thumb = soft-stop. No joystick base, no aim ring, no clutter.

```
┌──────────────────────────────┐
│           ENEMIES            │
│        ╲                     │
│         ◆ ← auto-aim target  │
│        ╱                     │
│         ◆ player drifts to   │
│           thumb position     │
├──────────────────────────────┤
│  ░░░░ flick up = volley ░░░  │
│  ░░░░░░░░░░░░ ↑ ░░░░░░░░░░░  │ rest thumb anywhere
│  ░░░░░░░░░░░ ⊙ ░░░░░░░░░░░░  │ on this invisible pad
│  ░░░░░░░░░░░░░░░░░░░░░░░░░░  │
└──────────────────────────────┘
```

- **Aim skill expression:** Optional — flick when you want it, ignore it otherwise.
- **Active input cadence:** Passive watch; ~1 flick every 5–10s when a juicy bounce is set up.
- **One-thumb playable?** Yes — designed for it.
- **Biggest risk:** Flick-to-aim mistakenly triggered during movement micro-adjustments.
- **Wittle-converter appeal:** **High** — feels like Survivor.io with one optional spice input.
- **BxP-identity preservation:** **Med** — bounce trajectory still matters but catching becomes auto.
- **Closest reference:** Survivor.io movement + Brotato's auto-fire.
- **Verdict:** The laziest viable scheme — flick is the only flourish.
- **Prototype scope:** 3 days — invisible-pad tuning + flick detection threshold are the variables.

#### 5.11.2 Scheme J — Magnet Lane

**Description:** Player is **rail-locked to 5 invisible lanes** but transitions are smooth/continuous animations (~0.25s glides), NOT teleport-snap. Thumb rests on left or right half — a long press on either half drifts you that direction lane-by-lane and stops when you lift. Auto-fire + auto-aim default. The skill input is a **double-tap anywhere = "Catch Stance"**: for 2s the player auto-positions under the next returning ball to guarantee the reload bonus. Solves the round-1 F rejection ("too many taps to move") because you HOLD instead of tapping each lane.

```
┌──────────────────────────────┐
│  │ │ │ │ │  ← 5 lanes        │
│  │ │◆│ │ │     enemies       │
│  │ │╱│ │ │                   │
│  │ ◆ │ │ │  ball bouncing    │
│  │ │ │◆│ │  ← player         │
│  │ │ │ │ │                   │
├──────────────────────────────┤
│ ┌─────────┐    ┌─────────┐   │
│ │ HOLD ◀  │    │  ▶ HOLD │   │
│ └─────────┘    └─────────┘   │
│   double-tap anywhere = catch│
└──────────────────────────────┘
```

- **Aim skill expression:** Low — aim is auto; only positional skill matters.
- **Active input cadence:** 1 hold every ~5s + occasional double-tap.
- **One-thumb playable?** Yes — left/right halves are thumb-reachable.
- **Biggest risk:** Lane-locking feels restrictive to ex-BxP players used to fine positioning.
- **Wittle-converter appeal:** **High** — discrete-feeling but no tap-spam.
- **BxP-identity preservation:** **Med-High** — catch mechanic gets elevated into a real skill input.
- **Closest reference:** Subway Surfers lane logic + Archero auto-aim.
- **Verdict:** Lane comfort with catching as the hero moment.
- **Prototype scope:** 4 days — lane-glide tuning + double-tap window calibration.

#### 5.11.3 Scheme K — Co-Pilot (Auto-Pilot Toggle)

**Description:** Default state — **fully autonomous.** Game moves you, auto-fires, auto-aims, auto-catches. You literally watch. A persistent **"Take Control"** button sits at thumb-rest position; press-and-hold to assume manual movement (1D slider appears under your thumb), release to hand back to AI. Aim stays auto throughout. The pitch: "the game plays itself well, you intervene only when you have a better idea." Vampire-Survivors mental model taken to its logical extreme but with a hard-coded override valve.

```
┌──────────────────────────────┐
│           ENEMIES            │
│        ◆                     │
│       ╱                      │
│      ◆     AI plays for you  │
│     ◆  ← AI-moved player     │
│                              │
│                              │
├──────────────────────────────┤
│                              │
│        ┌───────────┐         │
│        │ HOLD =    │         │
│        │ MANUAL    │         │
│        └───────────┘         │
└──────────────────────────────┘
```

- **Aim skill expression:** Optional — aim is never manual; only movement override exists.
- **Active input cadence:** 0 inputs baseline; 1 hold-burst every 10–20s for "I want to grab that orb."
- **One-thumb playable?** Yes — single button is the entire UI.
- **Biggest risk:** If AI is bad players feel betrayed; if AI is great they feel useless.
- **Wittle-converter appeal:** **High** — maximum laziness; makes the Fusion Reactor / level-up draft the real "game."
- **BxP-identity preservation:** **Low-Med** — bounce physics still visible but player isn't authoring it.
- **Closest reference:** AFK Arena combat + Wittle Defender's "watch the wave" rhythm.
- **Verdict:** The AFK pick; combat becomes a slot-machine spectacle.
- **Prototype scope:** 5 days — AI movement-policy quality is the make-or-break.

#### 5.11.4 Scheme L — Catch Pulse

**Description:** Movement is **passive auto-drift** — the AI moves the player to roughly track returning balls. The player's *only* job is a **single well-timed tap** the moment a ball is about to be catchable; nail the timing = "Perfect Catch" → instant reload + a damage-boosted return volley. Miss the timing = ball still catches automatically but no bonus. Auto-aim handles targeting. Converts BxP's catch mechanic from a positional skill into a **rhythm-tap skill** — easier for Wittle audience because timing taps are easier than coordinated drags.

```
┌──────────────────────────────┐
│        ◆                     │
│       ╱╲                     │
│      ◆  ◆                    │
│       ╲╱                     │
│        ◆                     │
│       ╱                      │
│      ◆ ← auto-positioned     │
│                              │
├──────────────────────────────┤
│      ╔══════════════╗        │
│      ║ TAP NOW (◯)  ║ ← ring │
│      ╚══════════════╝   pulse│
└──────────────────────────────┘
```

- **Aim skill expression:** Low — aim is fully auto; rhythm is the skill axis.
- **Active input cadence:** 1 timed tap every ~3–5s; otherwise passive.
- **One-thumb playable?** Yes — single tap is the whole input.
- **Biggest risk:** Rhythm-tap fatigue on long runs; cadence might feel busier than intended.
- **Wittle-converter appeal:** **Med-High** — taps are simple but cadence is higher than true Wittle.
- **BxP-identity preservation:** **High** — catching is the star, not a side mechanic.
- **Closest reference:** Crossy Road tap-timing + Hit Master parry windows.
- **Verdict:** Keeps BxP's soul, swaps drags for taps.
- **Prototype scope:** 3 days — tap-window calibration + auto-drift policy.

---

### Trajectory-editor lens (M, N, O, P) — invert the model, edit the auto-fire trajectory

#### 5.11.5 Scheme M — Apex Drag

**Description:** Balls auto-fire every ~0.9s on a default vertical-ish trajectory. The dotted parabola is always visible, and its **apex point** is rendered as a small draggable puck mid-air. The player drags the apex left/right (and slightly up/down for arc height) with their thumb; the launch angle and power re-solve in real time so the parabola passes through the new apex. Movement is a separate left-edge pad. The player isn't aiming — they're literally bending the top of the arc toward enemy clusters.

```
┌──────────────────────────────┐
│       ENEMIES                │
│       ╲                      │
│        ◯ ← draggable apex    │
│       ╱ ╲                    │
│      ╱   ╲     parabola      │
│     ╱     ╲    re-solves     │
│    ╱       ╲   through apex  │
│   ╱         ╲                │
│         ◆ player             │
├──────────────────────────────┤
│ ┌────┐                       │
│ │ ⊙  │ ← 1D move pad         │
│ └────┘                       │
└──────────────────────────────┘
```

- **Aim skill expression:** **High** — apex placement directly governs bounce geometry.
- **Active input cadence:** 1 small drag every 1–3s, often just nudges.
- **One-thumb playable?** **No** — move pad + apex drag = two thumbs. (Violates one-thumb preference.)
- **Biggest risk:** Apex puck occluded by enemies/VFX in dense waves; thumb covers the action.
- **Wittle-converter appeal:** **Med** — Wittle players expect bottom-half input, not mid-screen.
- **BxP-identity preservation:** **Med** — preserves bounce-feel, loses launch-from-cannon feel.
- **Closest reference:** *Where's My Water?* (drag-to-reshape-path).
- **Verdict:** Most expressive editor, but two-thumb cost is real.
- **Prototype scope:** 4 days — apex-drag visualization + re-solver math.

#### 5.11.6 Scheme N — Target Pin

**Description:** Auto-fire continuous. Player **taps any enemy or wall point** to drop a "pin." The trajectory solver re-aims so the next 2–3 auto-fired balls pass through (or first-bounce off) the pinned location, then the pin decays. Holding the tap lets the player **drag the pin** along enemies to sweep fire across a row. Movement is a separate left thumb-zone. Player thinks in **destinations**, not angles — pure bounce-target authoring.

```
┌──────────────────────────────┐
│  ◆ ◆ ◆ ◆ ENEMIES             │
│   ◆ ✕ ◆      ← active pin    │
│     ╲                        │
│      ╲                       │
│   ..  ╲                      │
│  .  .  ╲    solver routes    │
│ .    ....╲  through pin      │
│.          ╲                  │
│       ◆ player               │
├──────────────────────────────┤
│ ┌────┐                       │
│ │MOVE│  tap anywhere = pin   │
│ └────┘                       │
└──────────────────────────────┘
```

- **Aim skill expression:** **Med** — picking the right target matters, but solver does the geometry.
- **Active input cadence:** 1 tap every 2–4s, occasional drag.
- **One-thumb playable?** Yes-ish — movement can be auto-strafe toward pin if needed.
- **Biggest risk:** Feels like a tower-defense priority-target picker, not a brick-breaker; loses kinetic skill.
- **Wittle-converter appeal:** **High** — tap-to-target is Wittle's exact muscle memory.
- **BxP-identity preservation:** **Low-Med** — strips the "I aimed that shot" pride.
- **Closest reference:** *Kingdom Rush* hero targeting / *Plants vs Zombies* lobbed-shot targeting.
- **Verdict:** Most accessible, lowest skill ceiling, risks feeling passive.
- **Prototype scope:** 2 days — quickest of the trajectory-editor schemes.

#### 5.11.7 Scheme O — Bounce-Wall Drag  ⭐ Trajectory-lens winner

**Description:** Auto-fire continuous. The parabola's **first wall-bounce point** glows as a draggable marker on whichever side wall it will hit. Player drags that marker up or down the wall edge; the launch angle re-solves so the ball bounces off the wall at the chosen height before continuing into the pit. Two side-wall sliders effectively, but only the active-side marker is shown. Makes "carom shots" — BxP's highest-skill play — the **primary** input rather than an advanced flourish.

```
┌──────────────────────────────┐
│ ●              ENEMIES     ● │
│ ●╲                       ╱ ● │
│ ● ╲                     ╱ ●  │
│ ◉  ╲                   ╱  ◉ ←│ active wall
│ ●   ╲                 ╱   ●  │  marker
│ ●    ╲               ╱    ●  │  (drag ↕)
│ ●     ╲             ╱     ●  │
│ ●      ╲           ╱      ●  │
│ ●       ╲         ╱       ●  │
│          ◆ player            │
├──────────────────────────────┤
│ ┌────┐                       │
│ │MOVE│   (movement can auto- │
│ └────┘    track pin)         │
└──────────────────────────────┘
```

- **Aim skill expression:** **High** — mastering wall-bounce height is a real geometry skill.
- **Active input cadence:** 1 slide every 2–5s, side-edge thumb.
- **One-thumb playable?** Yes — right thumb on wall edge, movement can auto-track.
- **Biggest risk:** Unintuitive for first 30 seconds; *"why am I touching the wall?"* — onboarding-fragile.
- **Wittle-converter appeal:** **Low** — totally foreign gesture vocabulary.
- **BxP-identity preservation:** **High** — carom mastery IS BxP's identity, elevated to primary input.
- **Closest reference:** *Holedown* (rope-pull aim with strong geometry feel) / *Ballz*.
- **Verdict:** Highest skill expression, steepest learning curve.
- **Prototype scope:** 5 days — onboarding flow is the hard work; carom-snap UX is critical.

#### 5.11.8 Scheme P — Cone Sweep

**Description:** Auto-fire continuous within a **visible aim-cone** rendered above the player. The cone is the constraint, not a precise angle — balls auto-fire at slightly varied angles inside the cone (built-in spread). Player drags a **single bottom-edge thumb-slider** left/right to rotate the cone; pinching/spreading the cone edges (or a second tap-toggle for "narrow/wide") trades coverage for precision. Player edits the *probability envelope* of auto-fire, not individual shots.

```
┌──────────────────────────────┐
│      ╲              ╱        │
│       ╲            ╱         │
│        ╲          ╱          │
│         ╲        ╱           │
│          ╲      ╱            │
│           ╲    ╱   cone =    │
│            ╲  ╱    fire      │
│             ╲╱     envelope  │
│              ▽               │
│             ◆ player         │
├──────────────────────────────┤
│  ◀════════ ◉ ════════▶       │ rotate
│       [narrow | wide]        │ slider
└──────────────────────────────┘
```

- **Aim skill expression:** **Low-Med** — coarse coverage decisions, not precise shots.
- **Active input cadence:** 1 slide every 4–8s, very chill.
- **One-thumb playable?** Yes — bottom-edge slider is thumb-native.
- **Biggest risk:** Feels too automated — player feels like a spectator, no "I made that shot" moment.
- **Wittle-converter appeal:** **High** — ultra-low-effort, idle-adjacent feel.
- **BxP-identity preservation:** **Low** — loses precision, loses catch-reload micro-moment.
- **Closest reference:** *Archero* auto-fire with manual reposition / *Survivor.io*.
- **Verdict:** Most casual, lowest skill ceiling, risks idle-game drift.
- **Prototype scope:** 2 days — quickest of the trajectory-editor schemes (simple cone math).

---

### Mobile-convention lens (Q, R, S, T) — proven patterns from shipped portrait hits

#### 5.11.9 Scheme Q — Floating Joystick + Auto-Aim Priority

**Shipped reference:** *Survivor.io's* floating left-thumb joystick + *Brotato Mobile's* smart target-priority auto-aim (closest threat + facing-cone bias).

**Description:** Touch anywhere on the screen to spawn a floating virtual joystick anchored at first-touch. Drag in any direction — but only the X-axis component drives the 1D pit-walker (Y-axis ignored, like Last War's lane shooter). Balls auto-fire upward continuously at a priority-ranked enemy (lowest-HP-in-cone first, then closest). The thumb never leaves the screen during combat; you slide laterally to dodge returning balls and reposition under the bounce zone.

```
┌──────────────────────────────┐
│           ENEMIES            │
│        ◆     ◆     ◆         │
│           ◆     ◆            │
│          ╲╲╲╲                │
│         trajectory           │
│         dots                 │
│                              │
│             ◆ player         │
│             auto-target      │
├──────────────────────────────┤
│       ╔════╗                 │
│       ║ ⊙  ║ ← floating stick│
│       ╚════╝   spawns at     │
│                first touch   │
└──────────────────────────────┘
```

- **Aim skill expression:** **Low.**
- **Active input cadence:** Continuous hold, lateral slides only.
- **One-thumb playable?** Yes.
- **Biggest risk:** Auto-aim feels "not mine" — kills the catch-reload skill moment because aim isn't player-driven.
- **Wittle-converter appeal:** **High.**
- **BxP-identity preservation:** **Low** — overlaps heavily with Scheme D and loses bounce-skill identity.
- **Closest reference:** Survivor.io movement + Brotato priority-aim.
- **Verdict:** Safe, accessible, but launders away BxP's shot-craft soul.
- **Prototype scope:** 2 days — well-trodden pattern, fast to greybox.

#### 5.11.10 Scheme R — Lane-Slide

**Shipped reference:** *Last War: Survival Game's* horizontal lane-slide controller — single most validated portrait-hybrid-casual input of 2024–2025; also used in *Whiteout Survival's* combat and *Squad Busters'* drag-pad.

**Description:** The entire bottom third of the screen is a horizontal drag-pad. Thumb rests there; sliding left/right moves the player 1:1 with finger position (absolute, not relative — Last War's exact pattern). Balls auto-fire upward in a player-facing fan; aim direction is implicitly the screen-vertical, but the spread cone **tilts subtly toward the side the thumb last accelerated** (momentum-aim, a Last War flourish). Lift thumb = position holds. No tap needed to shoot.

```
┌──────────────────────────────┐
│           ENEMIES            │
│        ◆     ◆     ◆         │
│                              │
│         ╲ ↑ ╱                │
│          ╲│╱                 │
│           ▼  ← fire fan,     │
│              tilted by       │
│              momentum        │
│             ◆ player         │
├──────────────────────────────┤
│ ◀═══════════════════════════▶│
│   drag-pad (absolute X)      │ ← thumb rests
│   thumb position = player X  │   here
└──────────────────────────────┘
```

- **Aim skill expression:** **Low-Med** (momentum-cone is subtle).
- **Active input cadence:** Passive hold + slide.
- **One-thumb playable?** Yes.
- **Biggest risk:** **Too close to Scheme C (Sweep Bar)** — differentiation rests entirely on absolute-positioning + momentum-cone.
- **Wittle-converter appeal:** **High** (Last War players ARE the converter audience).
- **BxP-identity preservation:** **Med.**
- **Closest reference:** Last War / Whiteout Survival / Squad Busters drag-pad.
- **Verdict:** Maximum market-fit; aim expression is thin.
- **Prototype scope:** 2 days — but probably merge with Scheme C rather than ship as a separate scheme.

#### 5.11.11 Scheme S — Charge-Tap Volley  ⭐ Mobile-convention winner

**Shipped reference:** *Sky Force Reloaded's* drag-to-move-ship pattern + *Plinko Master / Peggle Blast's* tap-and-hold-to-charge-then-release volley.

**Description:** Player position follows thumb directly (drag anywhere on lower half = 1:1 movement, Sky Force style). Auto-fire is OFF by default. Holding the thumb still for ~0.4s charges a volley (visual ring fills around thumb); releasing or lifting fires a burst of 3–5 balls in a tight upward fan. Moving cancels charge. Creates a natural rhythm: **reposition → settle → volley → reposition** — the same loop Sky Force trained 50M+ players on, but with BxP's bounce physics doing the aim work for you.

```
┌──────────────────────────────┐
│           ENEMIES            │
│        ◆  ◆  ◆               │
│                              │
│         ╲╱╲╱╲                │
│         volley fan           │
│                              │
│           ◆ player           │
│            │                 │
│           ◯ ← charge ring    │
│            ⊙   thumb here    │
├──────────────────────────────┤
│  drag = move                 │
│  hold still 0.4s = charge    │
│  release = fire volley       │
└──────────────────────────────┘
```

- **Aim skill expression:** **Med** — positioning IS aiming, like BxP.
- **Active input cadence:** Rhythmic pulses, not continuous.
- **One-thumb playable?** Yes.
- **Biggest risk:** Charge-time feels like a tempo tax; tuning the 0.4s window is make-or-break.
- **Wittle-converter appeal:** **Med.**
- **BxP-identity preservation:** **High** — preserves position-as-aim.
- **Closest reference:** Sky Force Reloaded + Plinko Master charge-hold.
- **Verdict:** Closest spiritual heir to BxP's loop; tempo risk is real.
- **Prototype scope:** 4 days — charge-window tuning + rhythm-feel testing.

#### 5.11.12 Scheme T — Pinch-Free Aim Arc

**Shipped reference:** *Brick Breaker King* and *Plinko Master's* trajectory-arc preview + *Royal Match's* thumb-rest-zone discipline (no required gestures in the top half).

**Description:** Thumb sits on a fixed circular pad bottom-center (not floating — Royal Match teaches us fixed pads convert better for casual audiences). Pad is a mini 1D slider: drag left/right within the pad moves the player. The trajectory arc auto-cycles slowly through a 60° fan (~1.5s sweep, Brick Breaker King's auto-sweep mode), and balls fire continuously along the current arc. **Tap the pad to lock the arc at its current angle; tap again to unlock and resume sweeping.** Zero aim drag; aim becomes a timing decision, not a precision one.

```
┌──────────────────────────────┐
│           ENEMIES            │
│        ◆  ◆  ◆  ◆            │
│                              │
│         ╲   ╱                │
│          ╲ ╱     arc sweeps  │
│           ▽      60° / 1.5s  │
│           ◆ player           │
│                              │
├──────────────────────────────┤
│         ╔═════════╗          │
│         ║  ◀ ⊙ ▶  ║ ← fixed  │
│         ║  tap=   ║   1D pad │
│         ║  lock   ║          │
│         ╚═════════╝          │
└──────────────────────────────┘
```

- **Aim skill expression:** **Med** — timing-based skill ceiling.
- **Active input cadence:** Passive + occasional taps to lock.
- **One-thumb playable?** Yes — bottom-edge slider is thumb-native.
- **Biggest risk:** Auto-sweep feels patronizing to engaged players; lock-tap may not register as "skill."
- **Wittle-converter appeal:** **High** (Brick Breaker King has 100M+ installs in this exact pattern).
- **BxP-identity preservation:** **Med.**
- **Closest reference:** Brick Breaker King + Plinko Master + Royal Match.
- **Verdict:** Direct genre-native pattern; risks feeling like a clone.
- **Prototype scope:** 3 days — auto-sweep timing + lock-tap UX.

---

### 5.11.13 Round 2 — Cross-lens consolidated ranking

| Rank | Scheme | Lens | Why |
|---|---|---|---|
| **1** | **O — Bounce-Wall Drag** | Trajectory-editor | Only scheme that elevates BxP's signature high-skill move (the wall carom) into the primary input — preserves identity while genuinely inverting the model. Onboarding-fragile but solvable. |
| **2** | **I — Drift Pad** | Comfort | Truest one-input scheme. Thumb-rest is steady state, flick is the only flourish. Pairs cleanly with G — see synthesis below. |
| **3** | **S — Charge-Tap Volley** | Mobile-convention | Cites 50M-install Sky Force reference. Preserves BxP's position-as-aim soul. Charge-rhythm naturally accommodates the catch-reload micro-moment. |
| 4 | L — Catch Pulse | Comfort | Elevates catching from side-mechanic to primary skill — Wittle-friendly rhythm input. |
| 5 | N — Target Pin | Trajectory-editor | Highest Wittle-converter appeal of the trajectory lens; lowest implementation cost. |
| 6 | J — Magnet Lane | Comfort | Catch Stance idea is interesting; lane-lock is divisive. |
| 7 | K — Co-Pilot | Comfort | High-risk high-reward. Doubles as an "AFK Mode" feature regardless of whether it's core. |
| 8 | T — Pinch-Free Aim Arc | Mobile-convention | Direct genre-native pattern but risks feeling clone-y. |
| 9 | P — Cone Sweep | Trajectory-editor | Agent itself flagged "spectator feel" — low BxP-identity. |
| 10 | M — Apex Drag | Trajectory-editor | Most expressive editor but **fails the one-thumb constraint** — drops on a hard rule. |
| 11 | R — Lane-Slide | Mobile-convention | Overlaps too heavily with Scheme C — merge rather than ship separately. |
| 12 | Q — Floating Joystick | Mobile-convention | Pure Survivor.io clone; no BxP contribution. |

### 5.11.14 The synthesis insight — G + I layering

Agent 1 (Comfort lens) surfaced a non-obvious observation that survives consolidation:

> **Drift Pad (I) can layer cleanly under Aim-Lock Hold (G).**

Drift Pad becomes the **steady-state Wittle floor** — thumb-rest, auto-fire, magnetic glide. Aim-Lock Hold's hold-to-precise becomes the **BxP ceiling** — power-user toggle on top of the same control surface, no settings switch required.

In practice: a new player on D1 plays it as Drift Pad (auto everything + occasional flick). The same player on D14 plays it as Aim-Lock Hold (holds right thumb to enter manual precision aim when a juicy bounce is set up). **One scheme serves both audiences, growing with the player.**

This may be the most strategically valuable single insight from rounds 1 and 2 combined. [DESIGN — strong recommendation to prototype G and I together as a layered scheme, not two separate schemes]

### 5.11.15 Consolidated prototype roster (Round 1 survivors + Round 2 candidates)

| Tier | Schemes | Phase 1 priority |
|---|---|---|
| **Tier 1 — Prototype first (week 1–4)** | **G + I layered** ("Aim-Lock + Drift Pad" — see §5.11.14 synthesis), **O** (Bounce-Wall Drag), **S** (Charge-Tap Volley) | These three are the most differentiated and BxP-identity-preserving. A/B test them against each other in weeks 7–10. |
| **Tier 2 — Prototype second (week 5–6)** | **A** (Drag-Aim Anchor), **L** (Catch Pulse), **N** (Target Pin) | Fallback options if Tier 1 fails in playtest. A is the high-skill fallback; L preserves catching; N is the lowest-effort Wittle-friendly option. |
| **Tier 3 — Greybox-only / accessibility** | **B** (Tilt-the-Pit, accessibility toggle), **C** (Sweep Bar), **D** (Auto-Fire + Aim Dial), **J** (Magnet Lane), **K** (Co-Pilot — but ship as a standalone "AFK Mode" toggle regardless of whether it's the primary), **T** (Pinch-Free Aim Arc) | Greybox during weeks 1–6, do not commit playtest time unless Tier 1 + 2 all fail. |
| **Tier 4 — Drop entirely** | **M** (Apex Drag — two-thumb), **P** (Cone Sweep — spectator feel), **Q** (Floating Joystick — Survivor.io clone), **R** (Lane-Slide — merges with C) | Do not prototype. Already-rejected: E, F, H. |

**Phase 1 playtest plan:** Build Tier 1 (3 schemes) + Tier 2 (3 schemes) in greybox by week 6. A/B test Tier 1 across 50-player cohort in weeks 7–9. Pivot to Tier 2 in weeks 10–12 if Tier 1 all fail D1 ≥ 35% gate. Lock final scheme by end of week 12.

---

## 6. Meta Progression Systems

The opinionated 5-axis stack. Wittle has 8, Capybara has 17, Archero has 6+ — we deliberately stay at **5** [DESIGN] to prevent the "red dot hell" pattern that Wittle reviewers complain about [REF:Wittle §11].

### 6.1 The progression map (visual)

```
                  ┌─── 1. Hero Stars (gacha)
                  │      1★→8★ via shards + dupes
                  │      Passive tiers unlock at 2★/5★/8★
                  │      RESONANCE at 3★: borrow a starting BALL
                  │      RESONANCE +1 slot at 6★
                  │
HERO ──────────── ┼─── 2. Hero Slot Level (1–200, SLOT not hero)
                  │      Promotion Stones every 10 levels
                  │      Hero EXP between gates
                  │      Swap-friendly — no investment regret
                  │
                  ├─── 3. Account-Wide Gear (5 slots, NOT per-hero)
                  │      Pouch / Sash / Sandals / Bracer / Talisman
                  │      Common→Rare→Epic→Legendary→Mythic→S
                  │      3–4 set bonuses at launch
                  │
                  ├─── 4. Talents (gold tree, soft pacing)
                  │      4 branches: Offense / Defense / Utility / Status
                  │      Gated by player level
                  │
                  └─── 5. Ball Collection (NEVER gacha — earned)
                         79 named balls + Encyclopedia
                         Run pool draws from unlocked balls
                         Social comparison: "34% of players have Nosferatu"

IN-RUN ONLY (do NOT move to meta):
  └─ Ball Fusion / Evolution / Fission — 6,085 combinations,
     untouched core loop.

REPLACES TOWN BUILDER:
  └─ "The Lab" — single screen, idle Ball Forge + roster + map

RETENTION LAYER (lean Wittle pattern):
  ├─ Campaign (8 biomes × 6 chapters = 48 stages)
  ├─ Endless Mode (weekly leaderboard)
  ├─ Daily Quick-Run (3 tickets/day, shard farming)
  ├─ Boss Rush (weekly, gear set drops)
  └─ Battle Pass (30-day rotation)

DEFERRED to launch + 3 months:
  └─ Outfits / Skins (Wittle's whale hook +1% HP/ATK/DEF account-wide)
```

### 6.2 Axis 1 — Hero Stars (the gacha unit)

**Star ladder:** 1★ → 8★ via shards + duplicate copies [REF:Archero2 §4.2]. Each tier requires increasing shard counts:

| Tier | Shards required | Cumulative |
|---|---|---|
| 1★→2★ | 50 | 50 |
| 2★→3★ | 50 | 100 |
| 3★→4★ | 100 | 200 |
| 4★→5★ | 100 | 300 |
| 5★→6★ | 150 | 450 |
| 6★→7★ | 200 | 650 |
| 7★→8★ | 300 | 950 |

[REF:Archero2 §4.2, retained] — same numbers as Archero 2's Rare/Epic ladder; legendary heroes get a reduced ladder per [REF:Archero2 §4.2] inverse-rarity pattern.

**Passive ability progression** [REF:Archero2 §4.3]:
- **1★** — base passive Lv.1
- **2★** — passive Lv.2 (first major upgrade)
- **3★** — **RESONANCE unlock** — borrow another hero's starting **BALL** [DESIGN — adapted from Archero's "borrow passive" to "borrow ball"]
- **4★** — flat stat boost
- **5★** — passive Lv.3
- **6★** — **RESONANCE slot +1** — borrow a second hero's ball
- **7★** — flat stat boost
- **8★** — passive Lv.4 (final tier)

**Why Resonance is the gacha killer feature:** every hero you pull is *permanently useful* across your whole roster. At 6★ The Warrior with Resonance-1 = Embedded's Poison + Resonance-2 = Shade's Dark, your starting balls aren't just Bleed but Bleed+Poison+Dark. This is the **single most powerful retention mechanic** in the meta stack [INFERRED, per [REF:Archero2 §4.3] community consensus].

### 6.3 Axis 2 — Hero Slot Level (the slot-not-hero pattern)

[REF:Wittle §3.1, retained verbatim] — the design Wittle's 5★ reviews praise most: *"You don't upgrade the characters, you upgrade the slot. This is hands down one of the best things a gacha game can have."*

**Levels:** 1 → 200
**Primary bottleneck:** Promotion Stones, required every 10 levels
**Secondary input:** Hero EXP (plentiful — not the limiter)
**Caps:** Player account level gates max slot level (e.g., account-lvl 30 → max slot lvl 60)

**Key invariant:** **swapping a hero into a leveled slot inherits the level.** Players never punished for pivoting hero choice. This is the single most important retention guard against "I invested in the wrong hero" rage-quit. [DESIGN]

**Slot count:** **3 slots at launch** — Slot A (primary), Slot B (secondary), Slot C (tutorial-locked, unlocks at chapter 5). [DESIGN — leaner than Wittle's 5, since we are single-hero combat]

### 6.4 Axis 3 — Account-Wide Gear (5 slots, NOT per-hero)

[DESIGN] Account-wide, not per-hero. Reasoning: BxP heroes already diverge mechanically; per-hero gear (Wittle's pattern) would stack a second axis of "the wrong hero/gear combination" anxiety on top of the mode-bending hero variety. Account-wide gear is simpler and protects roster fluidity.

**5 slots** (custom-named to fit the BxP aesthetic):

| Slot | Stat focus | Visual |
|---|---|---|
| **Pouch** | Damage / ball damage | Belt pouch worn by hero |
| **Sash** | HP / DEF | Diagonal sash across torso |
| **Sandals** | Move speed / dodge | Footwear |
| **Bracer** | Crit chance / crit damage | Forearm bracer |
| **Talisman** | Status effect power / passive power | Pendant |

**Rarity ladder:** Common → Rare → Epic → Legendary → Mythic → **S** [REF:Capybara §7.1, Wittle §3.2]

**Two upgrade tracks per slot** [REF:Wittle §3.2]:
- **Level** (right number) → "Enhancer" material
- **Refine** (left number) → "Essence" material
- Both capped by player account level

**Set bonuses at launch — 4 sets:**
1. **Bleed Stacker** (2pc: +20% bleed damage; 4pc: bleed stacks → 1.5× hit damage)
2. **Crit Cascade** (2pc: +15% crit chance; 4pc: crits chain to next enemy)
3. **AoE Surge** (2pc: +20% AoE radius; 4pc: AoE refreshes status effects)
4. **Bounce Master** (2pc: +1 max bounce; 4pc: each bounce adds +10% damage)

[DESIGN] [REF:Archero2 §5.2] retained pattern.

### 6.5 Axis 4 — Talents (gold tree, soft pacing)

[REF:Capybara §9.1] [REF:Wittle §3.7] retained.

**4 branches:**
- **Offense** — ball damage, crit, fire rate, multi-shot
- **Defense** — HP, DEF, damage resistance, dodge
- **Utility** — move speed, magnet range, gold gain, XP gain
- **Status** — bleed/burn/freeze/poison potency, status duration, status crit

**Mechanics:**
- Gold is the only sink — talents do not require event currency [DESIGN — anti-grind, F2P-respectful]
- Player level gates the max talent points per branch (Account lvl × 0.6 = points/branch ceiling)
- Players can rebuild branches freely with no respec cost [DESIGN — anti-frustration]

[INFERRED] Talents are a soft pacing tool, not a long-tail sink — players will max one branch in ~14 days, others in ~30 days.

### 6.6 Axis 5 — Ball Collection (the F2P-identity hook)

**Balls are NEVER in a gacha banner.** [DESIGN]

This is the single most important F2P-perception decision in the whole stack. Wittle's #1 churn driver in reviews is *"predatory monetization / pay-to-win"* [REF:Wittle §11]. By removing balls from gacha, we structurally cut the "you can't compete without paying" perception while keeping heroes as the gacha bait.

**How balls unlock:**

| Source | Balls unlocked |
|---|---|
| Account creation | Baby balls + 6 starter Special Balls (Bleed, Burn, Iron, Vampire, Laser-V, Brood Mother) |
| First-clear of each chapter | 1–3 new base balls per chapter |
| **In-run discovery** | Evolutions and procedural fusions discovered mid-run unlock the recipe in Encyclopedia |
| **Achievement: Scholar tracks** | Discovery milestones (10, 25, 50, 79 named) drop hero shards as rewards |

**The Encyclopedia screen:**
- Grid view of all 79 named balls (silhouette until discovered, full art + stats after)
- Each ball card shows: discovery date, times-used-in-run, top damage record
- **Social comparison line** — *"34% of all players have discovered Nosferatu"* [DESIGN]
- Filter by element / damage type / status effect

**Why this matters for the long tail:** the 6,085 procedural fusions are a per-run discovery space; the 79 named are a multi-month account-arc. A player at month 6 still has 20+ named balls undiscovered. This is the **third-act retention engine** that Habby games don't have.

### 6.7 Cross-axis interaction matrix

How the axes feed each other [INFERRED]:

| Axis | Feeds into | Mechanism |
|---|---|---|
| Hero Stars | Ball Collection | New heroes unlock unique-to-them evolved-ball recipes (e.g., The Spendthrift's all-shots-at-once enables Vampire Lord builds faster) |
| Slot Level | All combat | Raw stat boost on the deployed hero |
| Gear | All combat | Stat boost via slot + set bonuses |
| Talents | All combat | Talent tree provides 10–25% stat multipliers |
| Ball Collection | Hero Stars | Encyclopedia milestones drop hero shards (cross-feeding the gacha) |

**The Resonance lever crosses 3 axes simultaneously** — your owned heroes (Axis 1) determine what balls you can borrow (Axis 5 indirectly), which compounds with your gear (Axis 3) and talents (Axis 4) into the build identity. This is the engine that turns the gacha into a strategy game.

---

## 7. Content Cadence — What Unlocks When

### 7.1 The 8 biomes (campaign progression)

[REF:BxP §5.1] retained — 8 layers, gear-gated unlock, building blueprints replaced with **chapter-clear shard rewards** (no buildings).

| # | Biome | Gear cost | First-clear unlocks |
|---|---|---|---|
| 1 | **BoneYard** | Free | Tutorial; Dark ball, Voodoo Doll passive |
| 2 | **SnowyShores** | 2 gears | Golden Bull, Healer's Effigy, **Stone** ball |
| 3 | **LiminalDesert** | 2 gears | **Light** ball, Vampiric Sword, Silver Blindfold |
| 4 | **FungalForest** | 2 gears | **Cell** ball, Wretched Onion, Protective Charm |
| 5 | **GoryGrasslands** | 3 gears | Hand Mirror, Lover's Quiver |
| 6 | **SmolderingDepths** | 4 gears | Gemspring, Dynamite, Wagon Wheel |
| 7 | **HeavenlyGates** | 4 gears | **Charm** ball, Ghostly Shield |
| 8 | **VastVoid** | 5 gears | None (terminal) — Endless Mode unlock + final boss "The Moon" |

Total gears to reach VastVoid = 22. Per [REF:BxP §5.1] the gear gate is permissive — the real gate is character level + ball collection. [DESIGN] retained.

### 7.2 Endless Mode unlock

Unlocks after first SnowyShores clear [DESIGN — earlier than BxP's mid-late position; we want leaderboard chase active from D2-3]. Endless mode is the **single most important retention surface post-D7** because it stays interesting indefinitely (no content gate). [REF:BxP §5.4]

### 7.3 NG+ ("Conquest") tier

[REF:BxP §5.1] retained — completing each biome with 10 different characters unlocks NG+. This is the long-tail mastery hook for whales + D60+ retention.

---

## 8. Player Experience — D1 through D14

[INFERRED throughout — no telemetry, only design intent]

### 8.1 D1 — first 30–60 minutes ("the hook")

**Boot-up sequence:**
- Studio logo (Lila Games)
- Pre-rendered 5-second cinematic — pixel-art hero descends into the pit
- Title screen with "Tap to begin"
- Free 1-pull on a guaranteed-Tier-1 hero banner (account creation gift; standard FTUE pattern [REF:Wittle])

**Tutorial run (5 min):**
- The Warrior is the starter (locked roster of 1)
- Bleed ball is the starting Special Ball
- Tutorial overlay teaches: move, aim, fire, catch, level-up draft (3 cards), first Fusion Reactor pickup
- First Evolution mid-run: Bleed + Iron → Hemorrhage (silhouette → reveal animation, "Whoa")
- First boss attempt: Skeleton King — designed to be **just-winnable** on first try (80% win rate target)

**Post-run:**
- Boss-drops modal: gold, hero shards (10× Tier-1), gear blueprint
- Return to the Lab — first walkthrough of: idle Ball Forge, roster screen, chapter map, mail, shop
- First Daily Sign-in (7-Day Carnival pattern [REF:Wittle §10.1, retained])

**First 30 minutes wraps with:**
- 2–3 completed runs
- 2 heroes owned (The Warrior + 1 from the FTUE 1-pull)
- Talents branch 1 (Offense) introduced + first 3 points spent
- Battle Pass introduced (free track only at this point)

**Player sentiment target [DESIGN]:** *"I've seen something I haven't seen in a mobile game — the ball physics + fusion moments are genuinely novel."*

### 8.2 D2 — second session ("the loop clicks")

- Repeat BoneYard with second hero — feels meaningfully different
- First **chapter wall** at chapter 3 — current build can't clear the mid-boss
- Star Challenge replay path introduced (Wittle pattern [REF:Wittle §12])
- First gacha 10-pull from accumulated daily-quest gems — 1 guaranteed 3★ (Tier-1)
- First Resonance trigger if player has 2 heroes (rare on D2, common on D3) — *"You can borrow Hero B's starting ball when you play Hero A — try it"*

### 8.3 D3–4 — depth opens up

- Layer 2 (SnowyShores) unlocks — new biome palette, Stone ball unlock
- First Evolved Ball discovery (Vampire Lord or Inferno) — Encyclopedia card unlocks with art reveal
- Gear system unlocks at player lvl 8 — first Pouch + Sash equipped
- **Endless Mode unlocks** at SnowyShores clear — leaderboard chase begins
- First Daily Boss Rush ticket unlocks — element-themed boss

### 8.4 D5–7 — the build space expands

- 4–6 heroes owned via daily-quest gems + first event rate-up banner
- First **mode-bender hero** (Tier-2) typically pulled — The Empty Nester or The Embedded — playstyle genuinely changes
- Talents branch 2 (Defense) unlocks at player lvl 15
- First chapter wall at chapter 6 — player learns to gear + ascend
- Battle Pass premium track decision point — $4.99 conversion offer
- **D7 retention spike** — 7-Day Carnival closes out with a guaranteed Mythic-shard bundle [REF:Wittle §5]

### 8.5 D8–14 — the differentiation tested

By D14, the player has [INFERRED]:
- 8–12 heroes
- ~25 of 79 named balls in Encyclopedia
- Hero Slot lvl 60+ on lead hero
- Talents 2/4 branches near-maxed
- Gear at Epic-Legendary tier
- Endless Mode leaderboard appearances
- **Has pulled at least 1 Tier-3 mode-bender** (The Tactician or The Radical) and seen the game mechanically change

**The D14 fork** [INFERRED from [REF:Wittle §5]]:
- **Cohort A — Engaged F2P (~30% of D1)** — Joined Discord, hit chapter 12, building first F2P-viable team
- **Cohort B — Light spender (~12%)** — Bought Beginner Pack, Battle Pass premium
- **Cohort C — Churned (~58%)** — Lost interest, content gate, or controls didn't click

**Cohort A's next 30 days of pull:** the Encyclopedia + Resonance lever. They want to discover the 50+ undiscovered balls and unlock 6★ on their main hero. This is the long-tail retention engine.

---

## 9. Retention Architecture (Layers)

[REF:Wittle §7] retained as the structural model, **leaner**.

### 9.1 Layer 1 — Daily energy

5 energy/run, regen 12 min/energy → **5 energy = ~60 min** wait. [DESIGN, more generous than Wittle's 13–20 min/energy]
Energy refill via gems (240 gems = full refill) — caps at 2 refills/day [DESIGN]

### 9.2 Layer 2 — Daily ticket modes (3 modes, lean)

| Mode | Tickets/day | Reward focus |
|---|---|---|
| **Quick-Run** | 3 free | Hero shards (rotating element/hero focus) |
| **Boss Rush** | 1 free + 1 ad | Gear set drops + Promotion Stones |
| **Coin Cave** | 2 free + 1 paid | Gold + Talent tree fuel |

**Deliberately leaner than Wittle's 6+ modes** [REF:Wittle §7.2] to avoid the "red dot hell" pattern [REF:Wittle §11]. Three modes is the minimum to feel varied; six is overwhelming.

### 9.3 Layer 3 — Weekly + event cadence

- **Weekly:** Endless Mode leaderboard reset; new Battle Pass week tier
- **Bi-weekly:** New hero rate-up banner (Tier-1 stat-flavor)
- **Monthly:** New Tier-2 mode-bender hero rate-up; Tier-3 mode-bender every quarter
- **Quarterly:** New biome added (post-launch content cadence — Year 1)

### 9.4 The deliberate non-feature: no Guild

[DESIGN] No guild system at launch. Wittle/Capybara both have guilds; we don't. Rationale: guild systems are a 6-week dev commitment that adds engagement variance (the variance is positive for retention, negative for D1 because new players don't have guild context). Defer to Year-2 evaluation.

---

## 10. Monetization Detail

### 10.1 Currency stack

| Currency | Source | Sink |
|---|---|---|
| **Gems** (premium) | IAP, login bonuses, achievements, ads | Hero gacha, energy refill, shop refresh |
| **Gold** | All modes, idle Ball Forge | Talent tree, gear refine |
| **Hero EXP** | Daily Quick-Run, runs | Slot levels (between 10-tier gates) |
| **Promotion Stones** | Boss Rush, events | Slot level 10/20/30/etc. gates — primary bottleneck |
| **Element Essences** (Fire/Ice/Bleed/Poison/Light/Dark) | Shop, events, daily quests | Hero star-up (matched-element required) |
| **Hero Shards** (per-hero) | Quick-Run, Encyclopedia milestones, dupe-from-gacha | Hero star-up |
| **Ball XP** | Idle Ball Forge | Ball mastery (in-run starting level) |
| **Battle Pass Tokens** | Battle Pass quests | Battle Pass progression |
| **Event Tokens** | Event participation | Event-shop exchanges |

[DESIGN] — 9 currencies, deliberately less than Wittle's 17+ [REF:Wittle §9.1]. Each has a clear sink and a clear source.

### 10.2 SKU inventory

| SKU | Price | Notes |
|---|---|---|
| **Beginner Pack** | $1.99 → $4.99 tiered | First-week onboarding; one-time |
| **Daily Top-Up Gift** | Spend-triggered | Spend X gems → bonus chest |
| **Battle Pass (premium)** | $4.99/30 days | Track unlock + exclusive cosmetic + 2× rate-up |
| **Lifetime Privilege** | $19.99 one-time | Ad-free forever + monthly gem stipend [DESIGN — explicit "lifetime means lifetime" anti-Wittle-controversy stance [REF:Wittle §11]] |
| **Monthly Pass** | $9.99/30 days | Daily gem stipend + 30 days |
| **Gem Top-Up** | $0.99 → $99.99 | Direct gem packs; 1st-time-double promotion |
| **Hero Bundle** (limited) | $9.99–$29.99 | Featured hero shards + cosmetics; rotates with banners |
| **Outfit Pack** (post-launch month 3) | $4.99–$29.99 | Cosmetic + +1% account-wide stat | [DESIGN — deferred] [REF:Wittle §3.8] |

### 10.3 Pity & drop rates

**Standard hero banner:**
- 0.6% Tier-3 (Mythic-equivalent)
- 4.4% Tier-2 (Epic-equivalent)
- 95% Tier-1 (Rare-equivalent)
- **Soft pity at 50 pulls** (rate-up increases linearly); **hard pity at 90** (guaranteed Tier-3) [DESIGN] [REF:Archero2 §4.2 pattern]

**Rate-up banner:**
- 50% rate-up share on Tier-3 pulls (industry-standard hero-collector rate)
- 100-pull double-pity guarantee for rate-up hero

**Cost:** 300 gems / pull; 2,700 gems / 10-pull (10% discount). [DESIGN, [REF:Wittle §9.3] pattern]

### 10.4 The whale hooks (gentle, not predatory)

[DESIGN — we explicitly DO NOT want Wittle's predatory tail [REF:Wittle §11]]

1. **Outfit/Skin compounding** — deferred 3 months post-launch; +1% HP/ATK/DEF per outfit account-wide (cap at 20% — equivalent to 20 outfits, intentional ceiling). Wittle has no cap, which fuels whale-churn complaints. [DESIGN]
2. **Hero star ceiling** at 8★ — no Mythic-to-Immortal evolution. [DESIGN — anti-power-creep]
3. **Battle Pass premium** — clearly time-bound, no "lifetime → monthly" controversy possible [REF:Wittle §11]
4. **Endless Mode leaderboards** — drives season-long whale-flex without paywall to participate

### 10.5 What we explicitly do NOT do

- **No ad walls on basic rewards** [DESIGN] [REF:Wittle §11 top complaint]
- **No "demo + paywall to continue"** [REF:BxP mobile failure]
- **No cross-platform-migration friction** [REF:Wittle §11 #6 — "iOS to Android required photos + receipts"]
- **No predatory anniversary events** [REF:Wittle §11 #9]
- **No gear gacha** — gear comes from gameplay [DESIGN]
- **No ball gacha** — balls come from gameplay [DESIGN]
- **No pay-to-skip-tutorial** — F2P respect from minute one

---

## 11. UA & Creative Strategy (planned)

Pre-launch placeholders [INFERRED from [REF:Wittle §10] playbook]:

### 11.1 Network mix (planned spend)

- **YouTube:** 40% (slightly less than Wittle's 50% — we're a less-mass-market visual)
- **TikTok:** 25% (more than Wittle's 10% — ball-physics is genuinely clip-worthy)
- **Meta (FB/IG):** 20%
- **AppLovin / Unity Ads:** 10%
- **Other:** 5%

### 11.2 Geo strategy

[DESIGN] Western-first (US/CA/UK/AU), not East-first like Wittle [REF:Wittle §10.2]. Rationale:
- BxP's PC base is Western-skewed (Steam reviews 95% English) [REF:BxP]
- Brick-breaker / Peggle nostalgia is a Western recognition pattern
- Eastern markets are more saturated with hero-collectors; harder breakthrough

Year-2 expansion: Japan, Korea, Taiwan (translated).

### 11.3 Creative pillars

[INFERRED from [REF:Wittle §10.3]]

1. **Ball-fusion screen-clear moments** (analog to Wittle's "Battle Intensity") — capture the 50+ balls in flight + screen-clearing AoE moments
2. **Hero variety reels** (analog to Wittle's "Character Collection Diversity") — split-screen showing 5 heroes playing the same level in 5 fundamentally different ways (Warrior vs Tactician vs Radical vs Sisyphus vs Empty Nester)
3. **Progression showcase** (analog to Wittle's #1 creative) — "Day 1 → Day 7 → Day 30" hero collection growth + Encyclopedia fill
4. **Aim-skill expression** — show the player chaining 5 bounces into a multi-kill, lean into "you're skilled"

### 11.4 Format optimization

- 70%+ gameplay footage (not animated cutscenes)
- 25–60 sec average length
- Music-only (no VO) → localization-cheap
- Hook text overlay on 40% of creatives (we use more text than Wittle because aim-skill needs explanation)

---

## 12. AI Leverage Inventory

[REF:concept-evaluation-v2.md §5] estimates **~1.5–1.7×** AI multiplier on Phase 2 timeline.

### 12.1 Where AI accelerates

| Pipeline | Tool class | Acceleration |
|---|---|---|
| Hero portraits (gacha pull animation) | Scenario / Midjourney → pixel-art LoRA | 3–5× |
| Enemy sprites + variants | Same | 4× |
| Biome palettes + tile sets | Scenario fine-tuned on biome refs | 2.5× |
| Ball icons (79 named + variants) | Midjourney style-locked | 5× |
| VFX particles | Procedural + AI-tuned | 1.8× |
| Localization (15 languages) | LLM translation + human review | 4× |
| Wave balance (self-play bots) | Stable Baselines / proprietary | 2× — quality, not speed |
| Audio (SFX, ambient) | ElevenLabs / Stable Audio | 2× |
| Marketing creative variants | Image gen + video edit pipeline | 3× |
| UI mockup iteration | Pencil MCP + Figma MCP | 1.5× |

### 12.2 Where AI does NOT help

- Ball physics simulation (bespoke engine work)
- Aim control schemes (all 8 — human design + playtest)
- Hero mode-bending mechanics (Tactician turn-based, Radical autoplay, etc. — bespoke engineering per hero)
- Monetization tuning (telemetry + economics, not gen-AI)
- Live-ops design + event balance

---

## 13. Pre-Mortem — RICOCHET Shipped, Failed 12 Months Later. Why?

[REF:concept-evaluation-BxP-mobile.md §6, expanded]

1. **Habby copied the mechanic.** Wittle added a "ball-bounce" mode in season 3 (3 months post our launch). Our combat differentiation collapsed in 90 days.
   - **Mitigation:** Build the 79-ball Encyclopedia identity into the early-game (D1–D14) hard, so players bond before Habby reacts. Moat is content velocity + identity, not patent.

2. **Mode-bender heroes too expensive to ship at pace.** We promised one per quarter; we shipped two in Year 1. Gacha felt thin.
   - **Mitigation:** Pre-build 6 Tier-3 mode-benders during Phase 2 (months 4–10 of dev). Stockpile. If we can't pre-build 6, soft-launch with 4 and stretch.

3. **Aim-Lock Hold had a D1 learning curve that crushed retention.** New players couldn't figure out auto-vs-manual mode. D1 hit 28%, not 40%.
   - **Mitigation:** 50-player cold-start playtest in Phase 1 weeks 7–10 targeting D1 control comprehension. If <70% can describe the aim mode after 5 minutes, pivot to Scheme A (Drag-Aim Anchor) immediately.

4. **Ball Encyclopedia became a checklist, not a discovery joy.** Players clear all 79 named balls in 30 days and feel done.
   - **Mitigation:** The 6,085 procedural fused-ball combinatorics + Resonance combinations are the long-tail. Make the Encyclopedia track fused variants too. Audit discovery cadence at month 1.

5. **Built progression before validating the core loop.** Exactly the BLACK lesson [REF:BLACK-retrospective-learnings.md]. Phase 1 ran into "feature complete" before "is this fun" was answered.
   - **Mitigation:** Phase 1 has ONLY 1 hero + 6 balls + portrait control + 1 boss. Zero meta. No gear, no talents, no gacha. If the core loop in portrait isn't fun, none of the progression matters.

6. **Western-first launch undershot Eastern monetization.** Wittle's $21M/mo is Eastern-driven. We chose Western and topped out at $4M/mo.
   - **Mitigation:** Year-1 Eastern expansion is mandatory post-Western validation. Don't conflate "easier launch" with "where the money is."

7. **Gear axis became a hidden whale-gate.** We promised "no pay-to-win" but Mythic-tier gear in practice required Battle Pass + events stacked.
   - **Mitigation:** Lock the gear-tier-ceiling to be F2P-achievable in 60 days. Audit at month 2 of soft-launch. Adjust drops if F2P-time-to-Mythic > 90 days.

---

## 14. Single Fragile Assumption

**Mobile players who currently play Wittle Defender / Survivor.io / Archero 2 will trade their auto-attack loop for a bouncing-ball loop with the same hero-collection structure — because ball-fusion produces moments their current games can't.**

Testable via:
- Stage 1 SSR bundle: *"The bouncing-ball combat feels more skillful and rewarding than auto-attack."*
- Stage 4 gameplay video: 30s of fusion screen-clear → measure pull-quote response
- Phase 1 playtest: D1 retention parity vs Wittle in same cohort

If this bundle does not test positively, the entire concept is invalidated. **This is the bet.**

---

## 15. Open Questions / Data Gaps (live register)

| # | Question | Source | Priority | Status |
|---|---|---|---|---|
| 1 | IP rights — can we license BALL x PIT, or is this a clean-room derivative? | Legal | **HIGH** | Open |
| 2 | Engineering cost-estimate per Tier-3 mode-bender hero | Internal eng | **HIGH** | Open |
| 3 | Wittle Defender 12-month trend curve | App Magic | HIGH | Open (carried from concept-eval-v2 §10) |
| 4 | Habby's pipeline — any ball-bounce or breakout-style prototype in soft launch? | App Magic publisher page | **HIGH** | Open |
| 5 | Exact battery cost of 60Hz ball physics + 50+ in-flight balls at peak | Internal QA | MED | Open |
| 6 | Phase 1 prototype tech stack — Unity / Godot / native? | Internal eng | **HIGH** | Open |
| 7 | Audio direction — does the FMOD-credit BxP soundscape translate, or do we re-score? | Audio direction | MED | Open |
| 8 | Phase 1 playtest panel — recruit Wittle-D14+ players specifically | Operations | HIGH | Open |
| 9 | Western vs Eastern launch order — confirm with Lila leadership | Internal | HIGH | Open |
| 10 | Battle Pass cosmetic catalogue depth at launch | Art direction | MED | Open |
| 11 | Cap on number of in-flight balls (technical) — does 100+ break frame budget on mid-tier Android? | Internal QA | HIGH | Open |
| 12 | Specific creative for ad-creative test — what does the "ball-fusion screen-clear" reel look like? | Creative | MED | Open |

---

## 16. Phase 1 Prototype Scope (3 months)

**Hard scope cap (BLACK lesson #2):**

- 1 hero (The Warrior)
- 6 starter balls (Bleed, Burn, Iron, Vampire, Laser-V, Brood Mother)
- 1 portrait pit (BoneYard biome, 6-min run)
- 1 boss (Skeleton King)
- **All 8 control schemes prototyped in greybox** (weeks 1–6)
- **Top-3 schemes A/B tested** with 50-player playtest cohort (weeks 7–10)
- Control scheme locked by week 12 going into Phase 2
- **NO** meta progression, gear, talents, gacha, Lab, Encyclopedia, hub menu

**Exit gates (any 2 of 3 must clear):**

1. 50-player cold-start playtest: **D1 ≥ 35%**, D3 ≥ 18%, 7+/10 control satisfaction on the locked scheme
2. $500 paid ad creative test: at least 1 ad creative beats Wittle Defender CPI benchmark by ≥ 20% in same audience
3. 10+ hours self-play retention from Lila internal team — does the bounce mechanic + fusion combinatorics genuinely scratch the BxP itch in portrait?

**Kill if:** D1 < 30% OR control satisfaction < 6/10 OR no ad creative within 30% of Wittle CPI OR engineering cost-estimate per Tier-3 mode-bender > 6 sprints.

---

## 17. Source Index

### Internal references (Game Research folder)

- `BALL x PIT/DESIGN_DOC.md` — anchor mechanical reference, ~570 lines
- `Archero 2/Game_Design_Spec.md` — meta progression patterns, ~1,400 lines
- `Wittle Defender/wittle-defender-design-spec.md` — audience + retention architecture, ~750 lines
- `Capybara Go/Capybara_Go_Game_Design_Spec.md` — idle/offline patterns + 17-axis F2P density, ~860 lines
- `BLACK-retrospective-learnings.md` — anti-pattern reference, ~70 lines
- `next-game-checklist.md` — pre-production gates
- `concept-evaluation-v2.md` — scoring framework
- `concept-evaluation-BxP-mobile.md` — parent feasibility memo (this concept's evaluation)
- `research-levers-v2.md` — kill criteria + scorecard dimensions

### External (canonical, for verification pre-Phase-2)

- `ballxpit.wiki.gg` — community wiki for BxP (canonical mechanical reference)
- `ballpit.fandom.com` — original Fandom source
- Steam store page App ID 2062430 (BxP) — marketing copy reference
- Google Play `com.devolverdigital.ballxpit` — mobile port baseline (the one we're improving on)
- Google Play `com.game.kingrush` (Wittle Defender) — audience + retention benchmark
- Google Play `com.xq.archeroii` (Archero 2) — gacha/progression benchmark
- Google Play `com.habby.capybara` (Capybara Go) — F2P density benchmark

### Tooling

- App Magic — competitive data refresh (Wittle, Archero 2, Capybara, Survivor.io)
- Sensor Tower (Lila account) — retention curve data when available
- Internal Lila playtest panel — 50-user cohort recruitment

---

*End of design spec.*

*Update cycle: every 4 weeks during Phase 1; every 2 weeks during Phase 2; weekly during soft launch.*
