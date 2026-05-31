# RICOCHET — New Game Concept

**Owner:** Tarun

---

## 1. Greenlight checklist

- [x] Filled out Stage 1–6
- [x] Text write-ups for SSR
  - [x] Full description of core loop (~135 words)
  - [x] Full description of core loop + 1 meta progression (~170 words)
  - [x] Store-page variant (~55 words)
  - [x] First 1–5 minutes the player experiences (~280 words)
  - [x] D1–D14 player journey / progression description (~340 words)
- [ ] Prototype
  - [ ] Playable Gameplay (In Blockout)
  - [ ] Playable Coreloop with 1 Progression layer
  - [ ] Integrate AI art assets
- [ ] AI Art Assets
  - [ ] Mockup of gameplay screen
  - [ ] Key art
  - [ ] Key UI frames
  - [ ] App store icon
- [ ] SSR Test Results
- [ ] Internal Playtest and Conviction
- [ ] Fake App Store Tests
- [ ] Publish AI Prototype on store and test D1 + number of games on D0

---

## 2. Identity

| Field | Value |
|---|---|
| Working title | RICOCHET |
| Genre / subgenre | Portrait F2P brick-breaker roguelite / hero collector |
| Target audience | Western mid-core mobile players who currently play Wittle Defender or Archero 2 and want skill-expressive aim instead of auto-attack, plus mode-bending hero variety that genuinely changes how the game plays. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

You stand at the bottom of a tall narrow pit and fire ricocheting balls up at enemies pouring down from the top. Balls bounce off walls, off enemies, off each other. Every level-up you pick a new ball from three cards, or fuse two existing balls into something new — by minute three of a run you've got fifty balls in the air. You catch returning balls to instantly reload. Five-minute runs, twenty waves, a boss. Outside runs you collect heroes — each one plays *fundamentally* differently. One makes combat turn-based. One auto-plays the whole game. One has gravity.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Pixel-art hero descends into a tall vertical pit. Text fades: "Hold the line." Tap to start.
- **5–15s:** Wave 1. One ball auto-fires upward. White trajectory dots show where it bounces. Hits a slime. Number pops: 14. Slime bursts into XP gem. Player's thumb tutorial-arrows at the bottom-right.
- **15–25s:** Player drags right thumb — trajectory line rotates with the drag. They lift. Ball fires at the angle they set. Hits two enemies on one bounce. *Cause-and-effect for aim clicks.*
- **25–40s:** Wave 2. Level-up. Three cards slide over the bottom half of the screen. One reads "Burn ball — 8 dmg/sec for 5s." Player picks it. Burn balls join the salvo, dotting enemies with orange numbers.
- **40–60s:** Wave 3. A rainbow orb floats onto the field. Player walks into it — a Fusion menu opens. Bleed + Burn = **VIRUS**. Card reveal animation, "Whoa." **The "I want to see what else fuses" moment.**

---

## 5. Hypothesis of why this would work

Mid-core mobile players who graduated to Wittle Defender / Archero 2 have two unmet wants that no shipped F2P title currently combines well. From their auto-attack survivor loop they want a **skill-expression input that lets them feel responsible for big moments** — Wittle is fundamentally passive in-match, and the active layer is just hero positioning and skill drafts. From their hero collector they want **a roster where pulling a new hero genuinely changes how the game plays** — Archero 2 reviewers describe Alex as "a trap" because most heroes feel like stat variations on the same auto-archer.

RICOCHET's bet is that BALL x PIT's ball-fusion combat — already validated on PC at 95% "Overwhelmingly Positive" across 22,751 Steam reviews — solves the first want, and BxP's roster of 21 *mode-bending* heroes (Tactician makes combat turn-based; Empty Nester removes baby balls; Radical auto-plays) solves the second. The shipped reference that validates the wrapper is Wittle Defender — proving the mid-core mobile audience exists at $21M/month, that single-hero combat with collection-meta retention works, and that the slot-not-hero upgrade pattern is genuinely loved (highest-praise mechanic in Wittle's 5★ reviews). The diff is replacing Wittle's positional auto-attack with BxP's bouncing-ball skill expression, and replacing Archero's stat-variation heroes with playstyle-defining ones. The audience is the same; the inputs change.

---

## 6. Risks

**Single fragile assumption:**

*Mid-core mobile players will trade their auto-attack loop for a bouncing-ball loop with the same hero-collection structure — because ball-fusion produces "screen-clearing" moments their current games can't deliver.*

If touch-aim-with-bounce-prediction can't be made comfortable in portrait, the entire skill-expression pillar collapses and the game falls back to "Wittle with worse art." Stage 1 bundle: *"The bouncing-ball combat feels more skillful and rewarding than auto-attack."* Stage 4 (gameplay video) re-tests with motion. The Phase 1 50-player playtest measures D1 retention parity with Wittle in the same cohort — that's the falsifiability gate.

---

## 7. Reference games

1. **BALL x PIT** — Kenny Sun and Friends, 2025, PC + mobile. The anchor. We share the brick-breaker ricochet core, the 79 named balls + 6,085 procedural fusions, the in-run Evolution/Fusion/Fission triad, and the 21-hero mode-bending roster. We don't share the landscape orientation, the upfront paywall, the dual-thumbstick controls, or the polarizing Ballbylon town builder — all four are structurally replaced.
2. **Wittle Defender** — Habby, 2025, mobile. The audience and meta-progression model. We share the slot-not-hero upgrade pattern, the 5-min session length, the daily ticket cadence, and the 92%-male midcore-TD-RPG audience. We don't share the positional team combat (we're single-hero), the chibi-medieval art (we tilt cyber-magical), or the 8-axis progression sprawl (we cap at 5 axes).
3. **Archero 2** — Habby, 2024, mobile. The gacha shape and the Resonance lever. We share the shard-based hero star-up ladder, the multi-currency horizontal progression, and the Resonance-borrow-from-other-hero pattern (we adapt it from "borrow passive" to "borrow starting ball"). We don't share auto-attack combat or stationary-arena positioning — both replaced by BxP's bouncing-ball core.

**Genre mashup formula:** Brick-breaker × Vampire-Survivors × hero-collector, anchored in BxP's ball-fusion combinatorics.

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- First run completes at wave 12 — Skeleton King boss kill on first attempt (designed 80%-win-rate target). Boss-drops modal: gold, 10× The Warrior shards, a Pouch (gear) blueprint.
- Return to the Lab. First walkthrough: idle Ball Forge (gold/Ball XP accruing while offline), roster screen (1 hero owned + 19 silhouettes), chapter map (Archero-style grid).
- First 10-pull on the FTUE hero banner — guaranteed Tier-1 hero (rotating: The Itchy Finger / The Repentant / The Cohabitants). Player gets a second hero.
- Second run with the new hero — same biome, same balls, but the new hero's starting ball + passive twist makes it feel like a different game. *First "this matters who I picked" moment.*
- Talents branch 1 (Offense) introduced. First point spent → +5% ball damage.
- Battle Pass (free track only) opens with a Day-1 mission: "Complete 3 runs." Reward: 200 gems.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
|---|---|---|
| D1 | 2 heroes, 6 balls, 1 talent point spent, 2 runs done. First Fusion discovered. | "I want to see what other balls fuse into" — the Encyclopedia is visibly mostly silhouettes. |
| D3 | 3–4 heroes, ~12 balls in Encyclopedia, gear unlocked at lvl 8. First chapter wall hit. | Daily Boss Rush unlocks — element-themed boss, gear-set chase. |
| D7 | 5–6 heroes, ~22 balls, Endless Mode unlocked + first leaderboard placement. First Tier-2 mode-bender pulled. | 7-Day Carnival closes with a Mythic-shard bundle. The mode-bender (Empty Nester / Embedded / Cogitator) is mechanically different — game feels new. |
| D14 | 8–12 heroes, ~30 balls discovered, Hero Slot lvl 60+, gear at Epic-Legendary, first Resonance triggered. | First Tier-3 mode-bender (Tactician or Radical) banner — limited-time, "this hero literally plays the game differently" hook. Endless Mode weekly leaderboard reset. |

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~135 words)

```
You stand at the bottom of a tall narrow pit. Enemies pour down from
the top. You fire ricocheting balls up at them — balls bounce off
walls, off enemies, off each other. A dotted line shows where each
ball will bounce. When a ball returns to you, you catch it to reload
instantly.

Every level-up, three cards appear. You pick a new ball or a passive
upgrade. Balls can be fused at glowing rainbow orbs that appear
mid-run: combine two of the same to evolve them into something
named, or combine two different ones for a procedural hybrid that
inherits both effects.

By minute three you have fifty balls in the air. A boss spawns around
minute five. The pit widens, the boss takes the top third. Five to
seven minutes a run. Twenty waves. One boss at the end.
```

#### Full description of core loop + 1 meta progression (Stage 1 required for collection-driven, ~170 words)

```
You stand at the bottom of a tall narrow pit. Enemies pour down from
the top. You fire ricocheting balls up at them — balls bounce off
walls, off enemies, off each other. A dotted line shows where each
ball will bounce. When a ball returns to you, you catch it to reload
instantly.

Every level-up, three cards appear. You pick a new ball or a passive
upgrade. Balls can be fused at glowing rainbow orbs that appear
mid-run: combine two of the same to evolve them into something
named, or combine two different ones for a procedural hybrid that
inherits both effects.

By minute three you have fifty balls in the air. A boss spawns around
minute five. The pit widens, the boss takes the top third. Five to
seven minutes a run. Twenty waves. One boss at the end.

Outside runs, you collect heroes. Each hero plays fundamentally
differently — one makes combat turn-based, one auto-plays the whole
game, one has gravity. You pull heroes from a summoning banner.
Duplicates ascend the heroes you already have, unlocking new passive
tiers and letting them borrow a starting ball from another hero you
own.
```

#### Store-page variant (Stage 1b optional, ~55 words)

```
Stand at the bottom of a pit. Fire bouncing balls at enemies pouring
down from the top. Catch returning balls to instantly reload. Fuse
balls into named hybrids. Collect heroes who each play the game
differently — one is turn-based, one auto-plays, one has gravity.
Five-minute runs. Twenty waves. Hundreds of balls. Twenty heroes.
Portrait. Free to play.
```

#### First 1–5 minutes the player experiences (~280 words)

```
Boot-up: studio logo, then a six-second pre-rendered pixel cinematic.
A pixel-art hero descends a rope into a tall narrow stone pit. Text
fades in: "Hold the line." Tap to start.

Tutorial run 1 begins immediately, no menus. The Warrior stands on a
strip at the bottom of the pit. Two slimes walk in from the top. A
tooltip arrow points at the bottom-right of the screen: "Hold to
aim." Player holds. The hero freezes. A radial drag controls launch
angle — white dotted parabola previews the path including the first
bounce. Lift to fire. Ball hits both slimes on one bounce. "14, 14"
floats up. Slimes burst into cyan XP gems. The XP bar fills.

Wave 2: a level-up modal slides over the bottom half of the screen
— top half stays live, enemies still descending. Three cards visible.
One is highlighted by a tooltip: "Burn ball — 8 dmg/sec for 5s."
Player picks it. The modal slides away. Burn balls join the salvo,
dotting enemies with orange tick numbers.

Wave 4: a rainbow orb floats onto the field. Player walks into it.
A Fusion menu opens, transparent over live combat. Bleed + Burn =
"Virus." Card reveal animation, "Whoa" confirm button. Virus replaces
the Bleed slot — green damage numbers, area-of-effect status.

By wave 8, the player has ~15 balls in the air, has drafted six
skills, has triggered one Fusion. The Skeleton King boss spawns —
the pit visibly widens by 25%, boss takes the top third, the boss
name slides in from the right edge in white text. Player wins on
~70% HP. Boss-drops modal: 240 gold, 10 Warrior shards, a Pouch
blueprint. Return to the Lab. Free 10-pull animation. Three new
heroes spin in.
```

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

```
Day 1. The player finishes their first session having played 3–5
runs, cleared the Skeleton King once, and pulled their starter pack
of heroes from the FTUE 10-pull. They've discovered their first
fusion (Virus or Inferno), spent one talent point, and seen the
Encyclopedia screen — 6 of 79 balls discovered, mostly silhouettes.
The hook for returning tomorrow is the visible incompleteness of
the Encyclopedia plus the second hero's mode-tweak (a Burn-focused
build feels different from Bleed).

Day 2. Returning player completes the daily Sign-In, runs 3 more
Quick-Run tickets, and clears chapter 3. First Resonance unlocks at
3★ on The Warrior — they can now borrow Burn from the second hero.
First meta-strategy moment: which starting ball pairs best?

Day 3. The first chapter wall hits at chapter 6. Player's current
build can't clear the mid-boss. Star Challenge replay path opens.
Daily Boss Rush unlocks — today's boss is fire-weak; player has the
team for it. Big reward + felt smart. The day ends with the
player's first Epic gear drop.

Day 7. Mid-chapter-3. Player has 5–6 heroes, ~22 balls discovered,
hit Endless Mode for the first time and placed somewhere in the
top 40% of their leaderboard pool. 7-Day Carnival closes with a
guaranteed Mythic-shard bundle — the player can now ascend their
lead hero to 4★. First Tier-2 mode-bender pulled (Empty Nester or
Embedded) — playstyle change is genuinely different.

Day 14. PvE mid-late game. Player has 8–12 heroes, ~30 balls,
Hero Slot lvl 60+, Epic-Legendary gear, all 4 talent branches
opened. They've triggered the second Resonance slot (6★ on lead
hero). A limited-time Tier-3 mode-bender banner runs — The Tactician
or The Radical, "this hero literally plays the game differently."
The player either has the gems to pull, or has a clear goal for
next week. Endless Mode weekly reset gives a fresh leaderboard
chase. The evening session anchors here.
```

### 9.2 Synthetic testing materials — Art

Hero-collector with combat-emphasis. Required for Stage 3.

| Artifact | Status | Notes |
|---|---|---|
| **Mockup of gameplay screen** | TBD | Single static frame: portrait pit with player hero at bottom, 8+ enemies descending, 15+ balls in the air with trajectory ghosting, level-up modal half-visible on bottom, top-bar HUD (wave counter, HP, 4 ball slots, 4 passive slots, Fusion Reactor indicator). Must read as "brick-breaker survivor with hero" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. 5 hero silhouettes (Warrior front, Tactician + Radical + Sisyphus + Empty Nester behind) inside a pit, a wall of bouncing balls forming a chaotic spiral, boss silhouette ominous at top. Pixel-cyberpunk-fantasy color palette (saturated magentas, cyans, deep purples). The image that leads the store listing. |
| **Key UI frames** | TBD | (1) Gameplay HUD mid-wave, (2) Level-up draft modal, (3) Fusion Reactor menu, (4) Hero roster screen (grid of owned heroes + silhouettes), (5) Hero detail / star-up + Resonance screen, (6) Encyclopedia screen (grid of 79 balls + discovery percentages), (7) Hero gacha banner + pull animation, (8) Battle Pass screen, (9) Chapter map. Nine frames — heavier surface than Wittle because we have the Encyclopedia identity layer. |
| **App store icon** | TBD | 1024×1024. A single hero in profile mid-aim, with a single arcing ball + dotted trajectory visible. Saturated purple/cyan. Tested for thumbnail readability at 88×88 — the dotted trajectory line is the visual hook that has to read at small size. |

### 9.3 Playable prototype

| Artifact | Status | Notes |
|---|---|---|
| **Playable prototype** | TBD | Scope: one playable hero (The Warrior), 6 starter balls, 1 portrait pit (BoneYard), 1 boss (Skeleton King), all 3 in-run combine systems (Fusion / Evolution / Fission) functional, all 8 control schemes implemented in greybox. No meta-loop, no gacha, no Lab, no Encyclopedia. Must be feel-representative on a real Android device — the touch aim is the entire pre-launch decision. The prototype's job is to falsify or confirm the single fragile assumption in §6. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Five beats: (1) first 20s onboarding read — control comprehension, (2) first level-up + draft decision moment, (3) first Fusion discovery (Bleed+Burn=Virus, "Whoa" reveal), (4) screen-clear moment at minute 4 (50+ balls in flight, multi-kill chain), (5) boss kill. Each beat scored separately at Stage 4. The Fusion-discovery beat is the make-or-break — if it doesn't pop, the whole concept's headline moment doesn't pop. |
