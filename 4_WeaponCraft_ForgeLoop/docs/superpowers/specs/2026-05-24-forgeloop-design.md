# ForgeLoop — Design Spec

**Date:** 2026-05-24
**Variant folder:** `Game_Prototypes/4_WeaponCraft_ForgeLoop/`
**Forked from:** `2_WeaponCraft_Base/` v0.1.10 (combat layer + hero sprites + parchment-brass theme reused).
**Target build:** `Prototype/dist/FORGELOOP_0.1.0.html`
**Status:** Design approved. Spec frozen pending user review. Implementation plan to follow.

---

## Context

`2_WeaponCraft_Base` (v0.1.10) shipped recipe-discovery juice via tag combos (Steamburst, Inferno, etc.). `3_WeaponCraft_RealTime` shipped streaming-defense pacing. Both still lose engagement after ~2 minutes because the *moment-to-moment craft interaction* is still a three-tap menu transaction: pick blueprint, pick rune, tap Forge.

A 6-round divergent brainstorm covering 16 source domains, 20 game inspirations (Lemmings, Loop Hero, Opus Magnum, Stacklands, Suika, Triple Triad, …), and 20 "oddly satisfying" sensory micros surfaced one candidate that hits all five DNA traits (real-world referent / causal propagation / watch-it-run / spatial input / tactile feedback): a Loop-Hero-style circular forge ring.

**ForgeLoop** wraps the auto-battler in a literal forge metaphor. The player places forge stations around a ring; a glowing ingot laps the ring; each station triggers a juicy 5–7 second minigame; the finished weapon reveals on an anvil with a screen-shaking RING and flies into the active hero's hand for combat.

The fantasy is dual: **tactical blacksmith / artificer** (hammer, bellows, quench) AND **arcane engineer / runesmith** (engraver, pattern welder, rune chains). One mechanic carries both.

---

## Pillars

| ID | Pillar | Validates |
|---|---|---|
| F1 | 8-cell hex ring with 2 fixed cells (Smelter top, Inspector bottom) + 6 customizable | Spatial layout is the build expression |
| F2 | Ingot travels clockwise; one cell visit = one station event | Causal propagation is visible |
| F3 | Each station is a distinct minigame (≤7s, modal pause) | Crafting is the toy |
| F4 | Lap-1 craft completes in 25–35s including reveal | Mobile session fits |
| F5 | Weapon reveals with anvil-RING animation + name banner + S7 snap-fit click | Satisfying climax |
| F6 | Weapon sprite visible on hero card; element bursts match engraved glyphs in combat | Watch-the-machine payoff extends into battle |
| F7 | Weapon persists across waves; re-enter loop for additional laps to upgrade | Depth-per-weapon over breadth |
| F8 | Soft-fail whiffs (no penalty); duplicates allowed (stack effect) | Forgiving, expressive |

Deferred (not in 0.1.0):

- F9 Multi-lap tiering (Rough → Tempered → Masterwork)
- F10 3-hero squad
- F11 Spatial-recipe combo codex
- F12 Weapon durability / breakage
- F13 Run timer
- F14 Station tile rotation (Pipemania-like)
- F15 Full 11-station catalogue

---

## The Forge Loop — system breakdown

### Ring layout

```
       [Smelter]
      ╱         ╲
   [ ? ]      [ ? ]
    │            │
   [ ? ]      [ ? ]
    │            │
   [ ? ]      [ ? ]
      ╲         ╱
      [Inspector]
```

- 8 hex cells in a ring around a central Forge Heart (decorative).
- Cells 1 (Smelter) and 5 (Inspector) are fixed — fixed-art, no minigame.
- Cells 2, 3, 4, 6, 7, 8 are customizable — player drags station tiles from a tray onto them.
- Ingot enters at Smelter (cell 1), travels clockwise (1→2→3→4→5→6→7→8→1), one lap = 8 station visits.
- Empty customizable cells are pass-through (no minigame, no effect).

### The ingot

- Visual: small glowing orange sphere with comet-trail.
- Hot/cold state: starts hot at Smelter, cools gradually unless Bellows refreshes it.
- Carries accumulated stats: ATK, CRIT%, DUR, element-tag, layer-count.
- Visual transforms per station: red-hot at Bellows, sparks at Anvil, cool-blue at Quench, silver at Polish, glyph-etched at Engraver.

### One lap, second by second

| t | Event |
|---|---|
| 0.0 | Player taps "Start Lap". Gold deducted (5g lap 1). Ingot drops into Smelter cell. |
| 0.5 | Ingot slides to cell 2. If station present, modal pops. If empty, ingot slides through (≈0.5s). |
| ~5s | Cell 2 minigame complete; modal closes; station icon glows gold (perfect) or silver (good) or gray (soft fail / skip); ingot continues. |
| 6–11s | Cell 3 minigame, same flow. |
| 12–17s | Cell 4 minigame. |
| 18 | Ingot passes Inspector (cell 5) — no minigame, just transit animation. |
| 18–23 | Cell 6 minigame. (In 0.1.0, only 4 starter cells filled — assume cells 2, 3, 4, 6 have stations; cells 7, 8 are empty pass-through.) |
| 24–25 | Cells 7, 8 pass-through (empty). |
| 25 | Lap completes. Player offered "Forge Weapon Now" (commit) or "Run Another Lap" (more stats). |
| 25–29 | If commit: anvil-RING reveal sequence (4s). |
| 29 | Weapon snaps to hero, combat resumes. |

Total lap-1 craft = ~25–29s. Within the 25–35s target.

---

## Stations (0.1.0 starter catalogue)

Four starter stations ship in 0.1.0. Each is a self-contained modal minigame.

### Smelter (fixed, no minigame)

- Theme: glowing furnace mouth at top of ring.
- Behavior: emits a new ingot on lap start. Carries base stats from chosen ore (only 1 ore type in 0.1.0).
- Visual: ingot drips into ring, sparks, soft whoosh SFX.

### Bellows (customizable)

- Theme: pumping leather bellows feeds the furnace beneath the cell.
- Minigame: 4 rhythm pumps. A pump-icon shows in modal center; a metronome pulse appears below. Player taps the pump-icon in time with each pulse (4 taps over ~4s). Hit zone is ±200ms.
- Scoring: count of perfect-zone hits (0–4). Heat gauge fills accordingly.
- Effect: applies a **Heat** tag to the ingot. If next station this lap is Anvil, Anvil gains "Hot Strike" bonus (+30% ATK contribution).
- Juice: tap rumbles screen; bellows visibly compress; furnace flares orange beneath cell.

### Anvil (customizable)

- Theme: glowing anvil with floating hammer.
- Minigame: 5 swinging-hammer tap-timing. A hammer icon swings left-right across a sweet-spot bar; player taps when hammer is in green zone. 5 swings total, ~3.5s.
- Scoring: count of green-zone hits (0–5). Each hit adds +2 ATK.
- Perfect (5/5): +★ Crit Bonus tag added (next strike in combat is auto-crit).
- Hot Strike combo: if Bellows preceded Anvil this lap, all hits count ×1.3.
- Juice: anvil rings (SFX) per hit; sparks burst per perfect; screen shakes lightly per hit.

### Quench (customizable)

- Theme: water bath beside ring; steam rises.
- Minigame: stop-the-bar. A vertical temperature gauge slides up and down; green "perfect quench" zone in middle; tap once to commit. ~3s.
- Scoring: distance from green-center. Perfect = +5 DUR, near = +3 DUR, miss = +0 DUR (soft fail, no penalty).
- Juice: tap freezes gauge with audible "TSSSS" hiss; massive steam burst; ingot color shifts orange → cool blue.

### Engraver (customizable)

- Theme: chisel-and-mallet on the ingot; rune templates float beside cell.
- Minigame: trace-glyph. A rune sigil shape (Fire / Ice / Pierce — chosen by player pre-game from a small palette in 0.1.0) appears as a dotted path. Player traces with finger in one stroke. ~5s.
- Scoring: trace coverage % vs target shape.
- Effect at ≥60% coverage: element tag applied (Fire / Ice / Pierce); engraved-glyph visual baked onto ingot.
- Juice: finger trail glows in element color; haptic per shape-node; final flash when glyph completes.

### Cell 7, 8 (empty in 0.1.0)

- Pass-through. Ingot slides past in ~0.5s each.
- Visual: faint forge-stone outline. Empty cell suggests upgrade potential.

---

## Lap pacing math

Each starter station fits in its own 5–7s budget:

- Bellows: 4s minigame + 1s station-glow + 1s transit = ~6s
- Anvil: 3.5s minigame + 1s glow + 1s transit = ~5.5s
- Quench: 3s minigame + 1s glow + 1s transit = ~5s
- Engraver: 5s minigame + 1s glow + 1s transit = ~7s
- Empty cells (×2): ~1s total
- Smelter + Inspector transit: ~1s total
- Forge reveal: ~4s

Total: ~30s. Within the 25–35s window.

---

## Forge reveal — the climax

Triggered when player taps **"Forge Weapon Now"** after lap completes.

```
t=0.0  Modal fade-in; combat freezes.
t=0.3  Camera punch-in on ring center; ingot slides from Inspector → center pedestal.
t=1.0  Anvil materializes over pedestal; hammer rises in slow-mo.
t=1.5  Hammer falls; screen flash white; anvil RING SFX (low-mid-high triple chime); screen shakes hard.
t=2.0  Pedestal opens; weapon silhouette rises in a particle column (sparks + light-shafts).
t=2.5  Weapon name banner unfurls (gilt parchment ribbon), e.g.:
         "Glowing Tempered Flame-Etched Shortsword"
       Name = adjective-from-perf + adjective-from-station + element-from-Engraver + base-type.
t=3.0  Stat readout types in below banner: "ATK 24 · CRIT 12% · DUR 8 · 🔥 Fire"
t=3.5  Weapon glows then arcs upward to hero portrait.
t=3.8  Snap-fit click (S7) — hero raises weapon; portrait now shows new weapon sprite.
t=4.0  Modal dismisses; combat resumes.
```

The reveal is the dopamine moment. Heavy investment in animation polish + sound design.

### Weapon name generator (0.1.0)

```
[Quality adjective]  +  [Process adjective]?  +  [Element adjective]?  +  [Base type]
```

- Quality adjective from worst-station-perf:
  - All perfect → "Masterwork"
  - All ≥ good → "Tempered"
  - Mixed → "Honed"
  - Soft fails present → "Crude"
- Process adjective: present if Folder used → "Folded"; if Polisher used → "Mirrored"; etc. (deferred — no Folder/Polisher in 0.1.0 starters).
- Element adjective from Engraver: "Flame-Etched" / "Frost-Etched" / "Pierce-Etched" / none.
- Base type: "Shortsword" (only base type in 0.1.0; expand later).

Example outputs from 0.1.0 starter set:

- "Crude Shortsword" (no Engraver used, whiffs on Anvil)
- "Tempered Flame-Etched Shortsword" (good runs, fire glyph)
- "Masterwork Frost-Etched Shortsword" (all perfects, ice glyph)

---

## Combat playback — weapon goes to battle

After reveal, combat resumes with the new weapon visible on Bran's hero card.

### Visuals during auto-battle

- **Weapon sprite**: replaces the generic Warrior weapon icon. Shows: blade color (cool-blue if quenched well), glyph etching (matching Engraver shape + color), polish sheen (if Polisher used — deferred).
- **Per-strike pulse**: when Bran swings, the ring icons that contributed pulse briefly. E.g., the Anvil cell pulses on every basic hit; the Engraver cell pulses on element burst.
- **Crit hits**: show a small **★** marker echoing the perfect-tap stars from the Anvil minigame.
- **Element bursts**: impact on enemy shows element color matching the engraved glyph (orange flame, cyan frost, silver pierce).
- **Combat log**: existing `2_` log lines now reference station-derived names. "Bran's Tempered Flame-Etched Shortsword strikes Goblin for 24 (★ crit)."

### Persistence rules

- Weapon stays equipped across waves.
- After each wave-clear, modal asks: "Forge Again? (5g — adds another lap)" or "Continue".
- Re-entering the loop: existing weapon is re-inserted at Smelter; existing stats persist; another lap *adds* to them additively (stat caps + tier-name multipliers deferred to 0.1.1+).
- Player can also clear station tiles between waves and try a different configuration (no refund in 0.1.0; cleared tiles just gone).

---

## Economy (0.1.0)

| Item | Cost / Drop |
|---|---|
| Starting gold | 5g |
| Wave clear reward | +5g |
| Forge cost (each lap, 0.1.0) | 5g flat — no tier escalation yet |
| Forge cost (laps 2/3, 0.1.1+) | 10g / 20g once multi-lap tiering ships |
| Station tile (starter) | Free (4 given at start) |
| Station tile (reward) | Free pick 1-of-3 after each wave clear |
| Station tile (shop) | Deferred to 0.1.2+ |

In 0.1.0 the gold loop is tight: 5g start + 5g/wave income = exactly enough for 1 forge per wave. Re-forging (running the same weapon through the loop again on a later wave) costs the same flat 5g and stacks stats additively — no tier name changes yet. The Rough → Tempered → Masterwork tier-naming + multipliers arrive in 0.1.1 when multi-lap tiering ships. Currency exists mainly to instrument intent and prepare the data shape.

---

## Console event schema (instrumentation)

All events logged via `console.log(JSON.stringify({t, evt, payload}))`. Extends `2_`'s schema.

| evt | payload |
|---|---|
| `session_start` | `{startTime, hero}` |
| `wave_start` | `{wave}` |
| `station_placed` | `{wave, cellIndex, stationId, fromTray}` |
| `station_removed` | `{wave, cellIndex, stationId}` |
| `forge_lap_started` | `{wave, lap, costG, ringConfig: [stationIds]}` |
| `minigame_start` | `{stationId, cellIndex, lap}` |
| `minigame_input` | `{stationId, inputType, payload}` |
| `minigame_complete` | `{stationId, cellIndex, lap, score, perf: 'perfect'|'good'|'soft_fail', statsContribution}` |
| `lap_complete` | `{wave, lap, totalDurationMs, stationsCompleted, weaponPreview}` |
| `forge_revealed` | `{wave, weaponName, finalStats, elementTag}` |
| `weapon_equipped` | `{heroId, weaponName, stats}` |
| `wave_start_battle` | `{wave, weapon}` |
| `wave_clear` | `{wave, timeMs, heroHpRemaining}` |
| `wipe` | `{wave}` |
| `session_end` | `{reason, lastWave, totalTimeMs}` |

`window.__forgeLoopStats()` returns latest snapshot.

---

## What ships in 0.1.0

### Content

- 1 hero: Bran (Warrior). Sprite reused from `2_/Prototype/dist/assets/heroes/bran_warrior.png`.
- 1 enemy wave type at a time (Goblin / Skeleton / Slime — randomized; no boss, no affinity telegraph yet).
- 8-cell hex ring. 2 fixed (Smelter, Inspector) + 6 customizable.
- 4 station tile types: Bellows, Anvil, Quench, Engraver.
- 1 base weapon type: Shortsword.
- 1 ore type (no choice).
- Weapon name generator (quality + element + base type).

### Systems

- Drag-tile-to-cell placement with S7 snap-fit click.
- Tap "Start Lap" → ingot animation → modal minigames sequentially → lap complete prompt.
- 4 modal minigames implemented (Bellows / Anvil / Quench / Engraver).
- Forge reveal sequence (anvil RING + name banner + snap-fit).
- Weapon sprite on hero card during combat.
- Weapon persists across waves; "Forge Again" prompt re-enters the loop.
- Gold currency.
- Console event instrumentation.

### Excluded

- Multi-lap tiering
- 3-hero squad (deferred 0.1.3)
- Recipe codex / named station combos (deferred 0.1.2)
- Weapon durability / breakage (deferred 0.1.2)
- Run timer (deferred 0.1.4)
- Boss waves / affinity telegraph (deferred 0.1.4)
- Station tile rotation
- Folder / Grindstone / Polisher / Pattern Welder / Cooling stations (deferred 0.1.1-0.1.5 catalogue rollout)
- Hard fails / weapon ruin
- Shop economy / tile reroll
- Persistent meta layer (gacha / BP / AFK / stamina)

---

## Open questions to resolve during 0.1.0 build

These are tuning numbers, not design questions:

1. **Bellows perfect-zone width** — ±200ms feels right or tighten?
2. **Anvil swing speed** — sweet-spot bar travels at what frequency?
3. **Quench gauge speed** — bar slides at what rate?
4. **Engraver shape complexity** — how many nodes in starter glyphs?
5. **Modal dismiss delay** — auto-close station-complete glow at 1s, or wait for tap?
6. **Empty-cell visual** — fully empty, or shows "drag a tile here" prompt persistently?
7. **Forge reveal duration** — 4s feels right or too slow on replays?
8. **Wave timer** — none in 0.1.0, but cap a wave at 60s to prevent stalls?

---

## Decision rubric (per pillar pass/fail signal)

| Pillar | Pass | Fail |
|---|---|---|
| F3 minigames juicy | ≥3/5 testers say "I want to do that again" after one craft | Minigames feel like chores |
| F4 lap pacing | Median lap-1 time 25–35s in console logs | Lap takes >45s or feels rushed at <20s |
| F5 reveal satisfying | ≥3/5 spontaneously name their weapon | Reveal skipped or "meh" |
| F6 weapon visible | ≥3/5 notice their weapon sprite changes in combat | Players don't connect forge work to battle weapon |
| F7 persistence | ≥3/5 re-enter loop after wave 1 | Players treat each forge as one-shot |
| F8 forgiving | No "I'm afraid to whiff" comments | Players paralyzed by fear of fail |

---

## Build approach

Fork `2_WeaponCraft_Base/Prototype/dist/BASE-A1_0.1.9.html` as the combat-layer base. Strip:

- TFT-style parts shop
- 3-slot anvil grid (Head/Hilt/Rune)
- Recipe codex modal
- Tag-discovery overlay
- 3-hero roster (keep Bran only)

Add:

- 8-cell hex ring UI (CSS clip-path or SVG hex cells)
- Tile tray (right-side or bottom)
- Drag-and-drop tile placement (touch + mouse)
- Ingot travel animation
- 4 modal minigame implementations
- Forge reveal animation
- Weapon sprite generator (composite: blade-color × glyph-shape × glyph-color)
- Hero card weapon-sprite replacement
- "Forge Again" prompt
- Console event schema

Output path: `4_WeaponCraft_ForgeLoop/Prototype/dist/FORGELOOP_0.1.0.html`.

---

## Validation protocol

- 5 internal testers, ~15 min each (1 baseline session + 1 free-replay session).
- Think-aloud + browser console copy + screen-record.
- Post-session 6 questions tied to rubric above:
  1. Which minigame felt best?
  2. Which felt worst?
  3. Did you want to forge again after wave 1?
  4. Did you notice your weapon changing in combat?
  5. Was the reveal satisfying?
  6. Did the 30s lap feel right?
- Tally against rubric. ≥4 pillars passing = graduate to 0.1.1 (multi-lap + recipe codex).

---

## Risks

| Risk | Mitigation |
|---|---|
| Four minigames feel like four unrelated chores | All minigame modals share the forge background frame. Camera never cuts away. Same parchment + brass aesthetic. |
| Modal pause kills tension | Combat is turn-based (inherited from `2_`); no continuous flow to break. Modal is ≤7s. |
| 6 customizable cells feel sparse for combos | 0.1.0 has no combos anyway. Combos arrive in 0.1.2 once codex ships. |
| Reveal climax under-delivers | Heavy invest: 4s sequence, multi-layer SFX, screen shake, particle column, banner unfurl. Test rubric explicitly checks. |
| Tutorial overload (4 minigames at once) | First wave forced tutorial: only Anvil cell available, only 3 hammer taps required, hand-tip animation. Other stations unlock via tray on wave 2+. |
| Persist-and-upgrade reduces craft volume | Trade-off accepted per design pillar F7. Depth > breadth in 0.1.0. |
| Weapon sprite generator complexity | 0.1.0 sprite is composite of 3 layers only (base blade + glyph + tint). Manageable. |
| Mobile drag accuracy on small cells | 8 cells (vs 12) chosen partly for touch-target size. Test on 5.5" + 6.7" devices. |

---

## File registry (target)

| Path | Purpose |
|---|---|
| `4_WeaponCraft_ForgeLoop/VARIATION.md` | 3-bullet delta from base `1_` GDD |
| `4_WeaponCraft_ForgeLoop/docs/04_GDD.md` | Full variant GDD (post-prototype) |
| `4_WeaponCraft_ForgeLoop/docs/superpowers/specs/2026-05-24-forgeloop-design.md` | **This doc** |
| `4_WeaponCraft_ForgeLoop/docs/02_systems/forge_loop_mechanic.md` | Ring + ingot + station model (writing-plans expand) |
| `4_WeaponCraft_ForgeLoop/docs/02_systems/minigames.md` | Per-station minigame specs |
| `4_WeaponCraft_ForgeLoop/docs/02_systems/reveal_animation.md` | 4s climax sequence |
| `4_WeaponCraft_ForgeLoop/docs/03_content/stations.md` | Station catalogue (4 starters → 11 full) |
| `4_WeaponCraft_ForgeLoop/docs/05_roadmap.md` | 0.1.0 → 0.1.5 milestone plan |
| `4_WeaponCraft_ForgeLoop/Mockup/ForgeLoop_mockup_v1.png` | AI-generated mobile mockup (prompts in plan file) |
| `4_WeaponCraft_ForgeLoop/Prototype/dist/FORGELOOP_0.1.0.html` | First playable build |
| `4_WeaponCraft_ForgeLoop/Prototype/dist/assets/heroes/bran_warrior.png` | Reused sprite from `2_` |

---

## References used during design

- `1_Robotek_WeaponCraft/docs/01_GDD.md` — canonical base GDD (combat layer, hero kit, auto-battler framing)
- `2_WeaponCraft_Base/docs/02_GDD.md` — Part II build log (BASE-A1 0.1.0 → 0.1.10)
- `2_WeaponCraft_Base/docs/superpowers/specs/2026-05-22-BASE-A1-prototype.md` — spec format precedent
- `3_WeaponCraft_RealTime/docs/03_GDD.md` — variant inheritance pattern
- `_COMPARISON.md` — variant indexing pattern
- Brainstorm trail: `C:/Users/Biswa/.claude/plans/we-ll-use-a-new-tender-treehouse.md`

Reference games (inspiration):

- **Loop Hero** (Four Quarters, 2021) — circular tile-placement track with auto-traversal. **Core mechanical anchor.**
- **Cooking Mama** (Office Create, 2006) — sequenced micro-game pattern per recipe stage.
- **Wittle Defenders** (Habby, 2024) — mobile portrait combat cadence, parchment-brass aesthetic.
- **Hearthstone / Clash Royale** — card-flying snap-fit animation language.
- **Gear Defenders** — auto-battler-wrapped-in-physical-metaphor precedent.
- **Magicka** (Arrowhead, 2011) — element-glyph chaining for Engraver minigame.
- **Inscryption** (Daniel Mullins, 2021) — sigil-on-card adjacency cascades for future combo system.

---

*End of design spec. Awaiting user review before transitioning to `writing-plans` skill for implementation plan.*
