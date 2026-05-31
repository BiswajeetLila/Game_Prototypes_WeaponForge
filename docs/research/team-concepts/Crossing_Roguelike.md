# Crossing (Roguelike) — Concept Template v2

**Owner:** Concept author

---

## 1. Greenlight checklist

- [ ] Filled out Stage 1–6
- [ ] Text write-ups for SSR
      - [ ] Full description of core loop (~135 words)
      - [ ] Full description of core loop + 1 meta progression (~170 words)
      - [ ] Store-page variant (~55 words)
      - [ ] First 1–5 minutes the player experiences (~280 words)
      - [ ] D1–D14 player journey / progression description (~340 words)
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
| :---- | :---- |
| Working title | Crossing (Roguelike) |
| Genre / subgenre | One-thumb portrait procedural chase roguelike |
| Target audience | Mid-core mobile players (14–40) who like Slay-the-Spire / Vampire Survivors run structure and want a chase-driving fantasy with per-run randomization. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

You're a smuggler running cross-country routes. Each run, the map regenerates around you — same region, new layout. AI pursuers spawn in waves and escalate as you push from A toward B. Power-ups drop in the world; pick them up mid-run, use them to break chases. At forks you tilt the wheel to pick branches. Some POIs are guaranteed (the lighthouse, the wreckage), some are rolled. Reach B = win the run. Die = run over. One-time relics persist across runs and build a permanent perk gallery. Stat trees absorb your banked Miles. Five maps, each one different.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Title screen, then a quick courier-on-the-radio voiceover. "Coastal route. Get to the safe house." Tap to start.
- **5–15s:** Car rolls forward. Drag-to-steer tooltip. Player swerves around the first traffic.
- **15–25s:** First pursuer arrives. Red rear-view indicator. Player evades by lane-change.
- **25–40s:** First power-up pickup glows on the road shoulder. Player diverts a lane to grab it. Smoke equips. Tooltip: "Tap the icon to use." Player taps, smoke blooms behind, pursuer drops off.
- **40–60s:** First fork. Player tilts hard right toward an optional POI marker — the lighthouse. **The "the map is different every time, I have to pick my path" moment.**

---

## 5. Hypothesis of why this would work

Vampire Survivors, Brotato, and Slay the Spire mobile proved Western players will accept short-session roguelike runs on phones. None of those are chase-driving games, however. Subway Surfers proved that one-thumb endless driving silhouettes hold attention but its progression is wipe-light and skips the roguelike build-stacking pleasure. The unmet combination is chase-driving + per-run randomization + permanent relic gallery + map memory.

The bet is that the "different map every run" pattern is the right pull for chase fantasy. In Subway Surfers, every run feels the same — the procedural placement is invisible. Here it's loud: at forks the player chooses a branch and that's a real strategic decision. Pursuer AI varies by map. The relic gallery is the *AFK-collector* hook layered on top of a Survivors-loop — players who want both per-run dopamine and long-arc collection get both. The shipped reference is Death Road to Canada — Rocketcat proved per-run randomization + persistent meta + arcade-driving silhouette holds attention. Our diff is the one-thumb mobile contract and the chase-pursuer combat that DRtC lacks.

---

## 6. Risks

**Single fragile assumption:**

*The procedural map generator can produce route variety that *reads* as varied to the player — not just stat-different but visibly different routes that drive a "I want one more run because the next one will be different" feeling.*

If the procedural maps feel same-y after 4–5 runs, the run-based randomization layer collapses to "the same drive over and over" and the genre advantage is lost. Stage 1 bundle: *"Each run feels meaningfully different, not just stat-different."* Stage 4 (gameplay video) re-tests with three back-to-back run cuts that must visibly differ.

---

## 7. Reference games

1. **Death Road to Canada** — Rocketcat, 2017, mobile. Per-run randomized arcade-driving with persistent unlocks. We share the run-based + persistent meta pattern and the road-trip framing; we don't share the top-down party-survival mechanic — Crossing is portrait single-car chase.
2. **Vampire Survivors (mobile)** — poncle, 2022. Run-based + perma-meta upgrade loop. We share the stat-tree meta and the run-length pattern; we don't share top-down character movement.
3. **Subway Surfers** — Sybo, 2012, mobile. One-thumb endless driving + collection. We share the input contract and the lane-swerve gesture; we don't share the endless format — Crossing is run-with-end.

**Genre mashup formula:** Death Road to Canada × Vampire Survivors × Subway Surfers

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- Run 1 dies at minute 6 to a swarm pursuer in the desert biome. Defeat screen: "650 Miles banked. 1 relic collected (Lighthouse Logbook)."
- First stat-tree screen. Player spends Miles on the Evasion tree (radar +20%). Visible tooltip.
- Run 2 starts. Map seed shifts. New POI placement; same lighthouse spawns in a different position. Player makes it further.
- First map unlock — Desert Crossing — clears after run 4. Anchor for tomorrow.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | 1 map cleared once. 1 relic. 3 power-ups encountered. Stat tree barely touched. | "I want to see what changes next run" — visible randomization on home map. |
| D3 | Desert Crossing cleared. Mountain Pass attempted. 4–5 relics collected. | New maps + modifier toggles unlock; first prestige modifier challenge. |
| D7 | Mountain Pass clear. Relic gallery half full. Stat tree branches diverging. | Targeted relic hunt + chapter-3 lore beat. |
| D14 | Urban Ruin attempted, The Bridge teased. 30+ runs deep. | Daily seeded run + modifier leaderboard. |

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~135 words)

```
You're a smuggler driving cross-country routes. Each run, the map
regenerates — same region, new layout. You spawn at point A and
drive toward point B. AI pursuers chase you in waves: ram-class,
sniper-class, swarm-class. You steer with one thumb at the bottom
of the screen.

Along the road, power-ups drop — turbo, oil slick, EMP, smoke,
shield. You pick them up by driving over them. You tap to fire them
when pursuers close.

At every fork, you tilt the wheel toward the branch you want. Some
POIs are guaranteed every run (lighthouse, oasis, monastery), some
are rolled in by the seed. Reach B and you win the run. Die and the
run ends.

Each run is four to eight minutes. Death is frequent but never
punishing — the road always gets a little easier.
```

#### Full description of core loop + 1 meta progression (Stage 1, genre-required, ~170 words)

```
You're a smuggler driving cross-country routes. Each run, the map
regenerates — same region, new layout. You spawn at point A and
drive toward point B. AI pursuers chase you in waves. You steer
with one thumb at the bottom of the screen.

Along the road, power-ups drop — turbo, oil slick, EMP, smoke,
shield. You pick them up by driving over them. You tap to fire them
when pursuers close.

At every fork, you tilt the wheel toward the branch you want. Some
POIs are guaranteed every run, some are rolled in by the seed.
Reach B and you win the run. Die and the run ends.

Each run is four to eight minutes.

Between runs, you spend Miles on permanent stat trees — speed,
durability, evasion, luck. One-time relic POIs grant permanent
perks once you find them. The relic gallery is your collection,
filling in with every map you push deeper into. New maps unlock
when you clear the prior one, and modifier seals add prestige
challenges for the maps you've already cleared.
```

#### Store-page variant (Stage 1b optional, ~55 words)

```
Smuggle yourself across procedural roads while AI pursuers hunt you.
Pick up power-ups mid-run, tilt at forks, push for the safe house.
Die a lot. Bank Miles. Build a permanent stat tree. Collect the
relics of couriers who didn't make it. Five minutes a run. The road
is never the same.
```

#### First 1–5 minutes the player experiences (~280 words)

```
Boot-up: studio logo, then a static-radio crackle and a courier
voiceover: "Coastal route. Don't get spotted." Tap to start.

The car rolls out of a fortified depot. Tooltip arrow at the bottom
of the screen: "Drag to steer." Player drags. The car swerves
around the first traffic. The HUD shows a mini-map with a route
arrow pointing roughly toward B.

Twenty seconds in, the first pursuer appears in the rear-view. Red
indicator. A power-up icon glows on the road shoulder — smoke.
Player diverts a lane to grab it. Smoke equips to the HUD. Tooltip:
"Tap the icon." Player taps. Smoke blooms behind. The pursuer
drops off for eight seconds.

At the first fork — minute one — the player tilts hard right toward
an optional POI marker glowing in the distance. The lighthouse
relic. Mini-puzzle: navigate two narrow rock pinches. Pick up the
relic. Logbook fragment glows briefly: "Day 14: I lost the convoy
near the cliffs."

Back on route. The pursuer rejoins. A second pursuer (sniper-class)
joins from a side road. Player has no counter for it. They survive
by weaving. They pick up an oil-slick mid-run and use it to spin
out the sniper.

Minute 4: a swarm of three ram-class chasers spawns. Player
exhausts their power-ups. The car takes a wreck. Defeat screen:
"You traveled 12 km. You banked 650 Miles. 1 relic collected
(Lighthouse Logbook)."

Stat tree screen opens. Player spends 200 Miles on Evasion node 1
(+20% radar). New run starts. Map seed shifts visibly — the same
biome but a different layout.
```

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

```
Day 1. The player completes 3–4 runs of Coastal Run, clearing it
once on attempt 4, collecting 1 relic, banking ~2000 Miles total.
They've sunk a few points into stat trees and they've seen the
relic gallery — 5 slots on Coastal Run alone, of which they've
filled 1. The hook for returning tomorrow is the visible
incompleteness — they know the seeded POIs roll different relics
across runs and they want the rest.

Day 2. Returning player runs Coastal Run again with a new seed.
Different POI placement, different forks-of-the-day. Picks up
relics 2 and 3. Desert Crossing unlocks. First run there is brutal
because of the dust storms — they didn't have evasion built up.

Day 3. Player invests heavily in the evasion tree. Returns to
desert. Clears it on run 7. Picks up the wreckage relic. First
Mountain Pass attempt — fails at the switchbacks.

Day 5. Mountain Pass cleared. The monastery relic adds a permanent
+5% speed perk. Player notices their build is now "speed evader" —
their stat picks and relic perks are starting to compose a coherent
style. First "I am building a way of playing" moment.

Day 7. Modifier seals unlock on Coastal Run. The "more chasers"
modifier triples spawn rate. Player tackles the prestige challenge.
Clears it with a different build — heavy evasion + decoy power-up
focus. Gets the prestige relic.

Day 10. Urban Ruin in progress. The city layout introduces
collapsing-building hazards and sniper towers. Player loses to
sniper towers three times before adapting. Tries the EMP power-up
heavy build. Clears it.

Day 14. The Bridge teased on the map. Player has 3 of 5 maps fully
3-starred, 18 relics, all four stat trees half-deep, and a clear
preferred build (evasion-decoy). The dominant return reason is the
daily seeded run leaderboard — same seed for everyone, race to the
fastest A→B time.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a roguelike chase driver.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Single static frame mid-run: player car in lower-third, cinematic chase camera, rear-view inset with pursuers, fork ahead with two visible branches, optional-POI glow off-route, power-up HUD strip, mini-map. Must read as "I'm running roads with a different map every time" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. Player car at speed against a stylized cross-country horizon, pursuers blurred behind. Tense, romantic-fugitive tone. |
| **Key UI frames** | TBD | (1) Map select w/ relic counts, (2) In-run HUD, (3) Stat tree, (4) Relic gallery, (5) Run summary, (6) Modifier seal screen. |
| **App store icon** | TBD | 1024×1024. Player car mid-evade, dramatic angle, dust trail. Tested for thumbnail readability at 88×88 — must read as "running from something" not "racing." |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: one map (Coastal Run) with procedural seed regeneration, 6 power-ups, 2 pursuer classes, 5 relic POIs in the rolled pool. Run-end → stat tree + relic gallery. No second map, no modifier seals. Must feel-representative on a real device — the procedural map variation IS the pitch. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 30s drive + first pursuer, first fork-choice + relic divert, first power-up use, first death → stat tree transition. Each scored separately at Stage 4. |
