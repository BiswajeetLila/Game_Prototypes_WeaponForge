# WeaponCraft — RealTime Variant — Game Design Doc

**Working title:** WeaponCraft RealTime
**Variant folder:** `Game_Prototypes/3_WeaponCraft_RealTime/`
**Forked from:** `2_WeaponCraft_Base/` at version 0.1.9.
**Target platform:** Vertical mobile (iOS + Android)
**Target audience:** Casual-mobile players who love continuous-defense rhythm (Wittle Defenders, Gear Defenders, Brotato, Vampire Survivors) blended with tactile crafting (Potion Craft).

---

## Why this variant exists

`2_WeaponCraft_Base/` is the turn-based, Robotek-cadence implementation of `01_GDD.md` (now `2_/docs/02_GDD.md` Part I). Player presses **⚔️ Start Wave**, batch of enemies attacks in 1100ms turns, wave ends, forge moment, repeat.

This variant rebuilds the same crafting hook (3-slot weapons, parts, recipes, codex) on a **continuous real-time stream**. No discrete waves. Enemies march in from the left. Combat runs in parallel with crafting. The shop is a **1-tile-churn carousel** that scrolls left-to-right every 5s — players must watch what's coming and grab what they want.

Genre mashup formula: **Wittle Defenders × Potion Craft × Brotato (light)**.

---

## High-concept pitch

> "A continuous fantasy-defense rush where you forge weapons in real time while heroes auto-fight an endless stream of monsters. Mix elemental runes mid-combat to discover new recipes. Tank a 3-minute siege. Beat the boss. Repeat with deeper combos."

---

## Core loop (moment-to-moment, ~3-minute stage)

Single stage plays as:

1. **0:00 — Stage starts.** Heroes anchored on the right side of combat zone. Only Bran (Warrior) is unlocked. Enemies begin spawning from the left edge of the lane. Combat is **real-time and continuous** — no pauses, no waves, no turn ticks.

2. **Heroes auto-attack** the nearest in-range enemy with projectile fire (no melee approach needed). Enemies **march right** at fixed speed (~35 px/sec base, +5%/15s scaling). When an enemy reaches melee range, it starts hitting the closest hero.

3. **Carousel shop** runs at the bottom — 5 tile slots horizontally. **Every 5 seconds**, the oldest tile expires + slides off the left, a fresh part appears on the right. Player clicks any visible tile → buys with gold → auto-equips to active hero (or merges duplicate, or inventory fallback).

4. **Recipes activate instantly on equip.** Place Pyro Pommel on Bran's hilt while Fire Rune is on his rune → **Steamburst** active → his very next attack splashes 35% to other enemies. The discovery overlay fires immediately, pauses the action for 2s celebration, then resumes.

5. **Hero death + revive.** Hero HP reaches 0 → "downed" state. Auto-revive after ~20s at 50% HP. **Healing potions** randomly drop from enemy kills (8% chance) — float on screen for 4s, click to heal the lowest-HP hero +25%.

6. **Hero unlock ramp.** 0:00 → Bran. 1:00 → Elara joins. 2:00 → Vex joins.

7. **Pulse-rhythm difficulty.** 15s quiet → 10s spike → 15s quiet → 10s spike. Each spike doubles spawn rate and introduces an elite mob. Final spike (2:30–3:00) is the toughest pre-boss surge.

8. **3:00 — Boss spawns.** Normal spawning halts (existing minions finish out). Boss has telegraphed affinity (e.g., "Weak to PIERCE · Resists FIRE"). Beat boss = stage clear.

9. **Wipe = boss-retry-with-reforge.** Parts inventory preserved. Boss respawns. Carousel refreshes. Try again.

---

## Locked design decisions

### Combat pacing
**Continuous real-time, single lane.** No turn-based ticks. Heroes auto-attack at fixed rate (e.g., 1 shot per 0.8s). Enemies march in continuously and approach. Tick model in code = 60 FPS update loop (requestAnimationFrame), not setInterval batches.

### Combat agency
**Same as Base.** Hybrid auto-attack + single-tap ultimate. Player taps hero portrait when ult bank is full (gauge persistent across the whole stage). Optional revive-via-potion-click during the stage.

### Crafting interaction
**One-click auto-equip to active hero.** Click carousel tile → gold deducted → auto-equip on active hero (class-locked goes to class hero; universal goes to active). Merge if duplicate. Otherwise inventory fallback. **No drag-and-drop** (mobile-friendly).

Active hero selection: click hero portrait card to set active. Default = first unlocked hero.

### Shop carousel (1-tile churn)
- 5 tile slots horizontally.
- Every 5 seconds: oldest tile expires + slides off left, fresh part appears on right.
- Each tile lives ~25 seconds on screen (5 slots × 5s).
- Per-tile TTL indicator (small shrinking bar).
- **No reroll button** — carousel auto-churns. (May add a "skip" button later that fast-forwards 5s.)
- No combat pause during shop click.

### Hero roster ramp
- 0:00 → Bran (Warrior) only.
- 1:00 → Elara (Mage) unlocks.
- 2:00 → Vex (Rogue) unlocks.

(Same heroes, same classes, same kits as `2_`. Sprites carried over.)

### Hero death + revive
- HP = 0 → downed, sprite grayed.
- Auto-revive after **20 seconds** at 50% effective max HP.
- Stage fails if all 3 are downed simultaneously.
- **Healing potions** drop randomly from kills (8% per kill). Float on screen 4s. Click to heal lowest-HP alive hero by +25% of max.

### Stage clear rule
- Survive **3:00** of streaming combat → boss spawns at 3:00 mark.
- Beat boss → stage clear.
- Time counter (`0:42 / 3:00`) is the primary HUD.

### Pulse-rhythm difficulty (within 3:00)
- 0:00–0:15 quiet (baseline mobs, 1 per 1.5s)
- 0:15–0:25 spike (2× rate, 1 elite)
- 0:25–0:45 quiet (Elara unlock window @ 1:00 in original ramp — but Bran-only here)
- 0:45–0:55 spike (2.5× rate)
- 1:00 → Elara unlocks
- 1:00–1:15 quiet
- 1:15–1:30 spike
- 1:30–1:45 quiet
- 1:45–2:00 spike (3× rate, 2 elites)
- 2:00 → Vex unlocks
- 2:00–2:15 quiet
- 2:15–2:30 spike
- 2:30–3:00 **hardest spike** (4× rate, mini-boss surge)
- 3:00 → final boss spawns (hardest spike of all)

(Numbers above are starting defaults — tune via playtest.)

### Carousel shop economy
- Currency: gold from kills (1🪙 per mob, +1 elite, +5 mini-boss, +20 final boss).
- Costs: same as `2_` per part (3🪙ish for common, 4🪙ish for tagged Universal hilts, 5🪙ish for rare).
- Starting gold: 15🪙.

### Enemy affinities (per-TYPE, not per-wave)
Streaming variant changes per-wave randomization to **per-enemy-type fixed affinities**:
- Goblin: weak FIRE, resist ICE
- Skeleton: weak PIERCE, resist FIRE
- Zombie: weak FIRE, resist PIERCE
- Wolf: weak ICE, resist nothing
- Slime: weak PIERCE, resist nothing
- (Elites + mini-bosses use the same pool with bonus HP)

Players learn the patterns. Counter-build feels skill-based rather than RNG. Bosses still have full telegraphed unique affinities.

### Boss + boss-retry
- Boss spawns at 3:00. Hardest enemy. Visible affinity banner above boss.
- On wipe: **boss-retry-with-reforge** modal. Parts kept. Fresh carousel. Boss respawns.
- Multiple retries allowed (no cap).

### Weapon anatomy, parts catalogue, recipes
**Unchanged from `2_` v0.1.9.** All carries over:
- 3-slot weapons (Head + Hilt + Rune)
- 12-part starter catalogue (incl. Universal element hilts Pyro Pommel + Glacier Pommel)
- Part levels L1–L5 with stat multipliers [1.0, 1.5, 2.1, 2.85, 3.7]
- Wittle-style merge: same-partId duplicate → level up
- 8 named recipes (Steamburst, Inferno, Permafrost, Skewer, Razor Wind, Hellfire, Frostbite, Quickdraw)
- Multi-path patterns + derived tags (crit, charge)
- Recipe codex with silhouette → discovered states
- First-discovery overlay (pauses time during celebration)

### Ult gauge
**Persistent across the whole 3:00 stage.** Fills from damage dealt. Tap to fire once per stage minimum (could allow refire on full re-charge — TBD).

### Visual style
**Same direction as `2_`** — chibi heroes (Clash Royale × Wittle Defenders × Hearthstone polish). Carousel art TBD via mockup pass.

---

## Locked extras (variant-specific)

### Crafting bay during combat
Bay is visible always (not modal). Carousel + anvil + inventory + hero cards all rendered. No "preparation phase" UI mode. Combat phase IS forge phase.

### Codex modal opening behavior
Clicking 📜 Codex button **pauses combat** for ~2 seconds (or until close) so player can study uncovered recipes. Discovery overlays also pause briefly.

### Inventory
Optional persistent. Same as `2_` — overflow + swap storage for parts displaced by merges or wrong-class drops.

### What's NOT in this variant (parity-with-Base scope)
- No persistent meta (gacha / BP / AFK / stamina) — same as `2_` BASE-A1 deferral.
- No multi-stage chapter map yet — single stage only for v0.1.0.
- No PvP, no guilds, no events.
- No buff-draft modal (defer to v0.2+).

---

## Open questions for the prototype build

These should be resolved iteratively during 0.1.x development:

1. **Enemy march speed curve** — fixed vs scaling? Default: 35 px/sec base, +5% every 15s.
2. **Hero attack rate** — 1/0.8s? Faster for Rogue?
3. **Hero attack range** — visualize as a circle or invisible auto-range?
4. **Spawn pacing per pulse phase** — exact numbers per quiet/spike.
5. **Carousel TTL visual** — shrinking bar under tile, or color-fade, or both?
6. **Healing potion visuals** — float position (above enemy that dropped it? center screen?).
7. **Boss spawn arrival** — slide in from left with march? Or teleport in?
8. **Codex pause duration** — fixed 3s, or until close?
9. **Ult refire policy** — once per stage, or refire on full re-charge?
10. **Mobile drag fallback** — currently no drag; if testers want it, add as a toggle.

---

## File registry

| Path | Purpose |
|---|---|
| `docs/03_GDD.md` | **This doc** — RealTime variant GDD |
| `docs/05_roadmap.md` | Inherited from `2_`. Needs RealTime-specific rewrite. |
| `docs/02_systems/*` | Inherited stubs from `2_` (combat_math, onboarding, audio, art_direction, pvp_arena, merge_mechanic). Stale wrt RealTime; refine as needed. |
| `docs/03_content/*` | Parts / recipes / characters / boss_affinities catalogue (inherited). |
| `docs/04_economy/*` | Stamina / currency / battle_pass / cosmetics stubs (inherited). |
| `docs/superpowers/specs/` | RealTime-specific specs to be written here. |
| `Prototype/dist/BASE-A1_0.1.9_REF.html` | Reference fork of `2_`'s latest BASE-A1 — DO NOT modify. Source of truth for parts/recipes/UI patterns. |
| `Prototype/dist/REAL-TIME_0.1.0.html` | (To be created) — first RealTime build. |
| `Prototype/dist/assets/heroes/` | Hero sprite assets carried over from `2_`. |
| `Mockup/WeaponCraft_mockup_v1.png` | Art-direction reference (shared with `2_`). |

---

## References used during design (variant additions)

Original `2_` references all apply. Variant-specific:

- **Wittle Defenders** (Habby, 2024) — streaming-defense pacing, merge mechanic, mobile portrait combat. **Primary anchor.**
- **Gear Defenders** (TBD) — similar continuous-defense flavor, more aggressive crafting integration.
- **Brotato** (Blobfish, 2022) — short-session timed survival, mid-run draft moments, weapon variety.
- **Vampire Survivors** (poncle, 2022) — auto-attack rhythm, single-screen continuous spawn.
