# Crossing (Linear) — Concept Template v2

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
| Working title | Crossing (Linear) |
| Genre / subgenre | One-thumb portrait stage-based chase driving with persistent power-up loadout |
| Target audience | Casual / light-progression mobile players (12–45) who dislike full per-run wipes but love stage-based mobile action and chase fantasy. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

You're a courier driving cross-country routes while AI pursuers hunt you. You pick a stage on a world map, pick a car, and load it with the power-ups you've installed — turbo, oil slick, EMP, smoke. Drive from point A to point B. Pursuers escalate as you go. Trigger power-ups to shake them. Divert to optional POIs along the route for one-time relics. Fail a stage? Retry. Nothing you found ever goes away. Each stage advances a chapter of a multi-courier story; relics fill in lore. You're building a permanent garage, not surviving runs.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Cinematic intro: a fortified depot at dawn, a beat-up courier car rolls out. "Reach the safe house. Don't get caught." Tap to start.
- **5–15s:** Drag tutorial. Player swerves out of the depot gate. The route HUD shows distance to B.
- **15–25s:** First pursuer arrives in the rear-view. A red-coded ram-class chaser. It taps the bumper. Player swerves wide.
- **25–40s:** First power-up tutorial. A glowing "Smoke" icon highlights on the HUD. Player taps. The car drops smoke; the chaser disappears from rear-view for 8 seconds.
- **40–60s:** Player approaches the first optional POI marker — a lighthouse glints off-route. Choice: divert (lose 5 seconds, gain a one-time relic) or push through. **The "this isn't just driving, it's a route choice game" moment.**

---

## 5. Hypothesis of why this would work

Subway Surfers / Asphalt 8 / Hill Climb Racing 2 collectively prove that stage-based mobile driving with persistent garage progression is one of the durable patterns on phones. None of them, however, layer chase combat against AI pursuers as the central tension. Need for Speed mobile has the chase silhouette but its progression is wipe-light and its session is too long for the casual slot. The unmet combination is: stage-based no-wipe progression + persistent garage + AI chase tension + relic collection as a permanent collection layer.

The bet is that the relic-collection layer is what carries retention. Casual players who don't tolerate roguelike resets can still tolerate "I had to retry a stage" if every relic they pick up before failure is *kept*. The shipped reference is Subway Surfers — Sybo proved indefinite-replay progression with cosmetic collection holds Western mid-casual players for years. Our diff is the chase-as-combat structure and the AI pursuer classes, which give the genre its strategic-power-up layer that Subway Surfers lacks.

---

## 6. Risks

**Single fragile assumption:**

*Casual mobile players will accept that the "challenge" is the AI pursuer pressure rather than per-run wipes, AND will find the no-wipe stage retry pattern motivating rather than padding.*

If players read "you retry stages until you clear them" as grind, the structure collapses into a perceived idle-game. Stage 1 bundle: *"Retrying stages with all my gear feels like steady progress, not like running in place."* Stage 4 (gameplay video) re-tests with motion — the AI chase has to read as a real threat, not as a scripted speed bump.

---

## 7. Reference games

1. **Hill Climb Racing 2** — Fingersoft, 2016, mobile. Stage-based mobile racing with persistent garage and no-wipe progression. We share the stage-retry + garage pattern; we don't share the physics-puzzle hill format — Crossing is a chase.
2. **Subway Surfers** — Sybo, 2012, mobile. Persistent collection + endless silhouette + lane-swipe input. We share the persistent-collection meta and the one-thumb input contract; we don't share the endless format — Crossing has discrete stages.
3. **Asphalt 8 (career)** — Gameloft, 2013, mobile. Career-mode driving with stage clear + car collection. We share the career arc and garage layer; we don't share the racing-against-rivals framing — our antagonist is AI pursuers, not racers.

**Genre mashup formula:** Hill Climb Racing 2 × Need for Speed mobile × stage-based chase

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- Stage 1 cleared 2-star (missed one optional POI). First clear screen: stars, relics, Miles awarded.
- Garage screen. Player installs the smoke power-up they picked up mid-stage. It now permanently sits in loadout slot 1.
- First car upgrade screen. Player spends Miles on tire grip (+5% handling). Visible tooltip.
- Stage 2 (Desert Crossing) unlocks. Player attempts. Fails at minute 4 to a sniper pursuer they didn't have a counter for. Retry screen — no penalty, no lost gear.
- First mini-quest NPC encountered — "the smuggler's daughter" gives the first lore note.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | 1 stage cleared (2-star), 2 power-ups installed, 3 relics collected, 1 car upgraded. | The 3-star retry of stage 1 + Map 2 unlock. |
| D3 | Map 2 (Desert) cleared. 5 power-ups, 6 relics, second car unlocked. | Map 3 (Mountain Pass) opens — needs specific power-up for shortcut. |
| D7 | Mid-Map 3, hit the avalanche-tunnel shortcut requirement. | Targeted relic-grind to unlock the shortcut, plus campaign story beat at the mountain monastery. |
| D14 | Maps 1–3 3-starred, Map 4 (Urban Ruin) in progress. Garage has 5 cars, 15 power-ups, 25 relics. | Daily modifier rotations on cleared maps + Map 5 (The Bridge) tease. |

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~140 words)

```
You're a contraband courier. You pick a stage on a world map. You
pick a car from your garage. You pick the power-ups installed on
that car — turbo, smoke, oil slick, EMP, shield.

You spawn at point A. You drive toward point B. AI pursuers chase
you in escalating waves — ram-class, sniper-class, swarm-class.
You drive with one thumb at the bottom of the screen, dragging side
to side to steer and up/down for throttle.

When pursuers close, you tap to fire a power-up. Smoke breaks
line of sight. Oil slick spins them out. EMP knocks them offline.

Along the route there are optional POIs — a lighthouse, a smuggler
cove, a ferry. Divert and you get a one-time relic. Skip and you
save time.

Each stage is four to eight minutes. Reach B to clear. Fail? Retry,
nothing lost.
```

#### Full description of core loop + 1 meta progression (Stage 1, optional for stage-based, ~170 words)

```
You're a contraband courier. You pick a stage on a world map. You
pick a car from your garage. You pick the power-ups installed on
that car — turbo, smoke, oil slick, EMP, shield.

You spawn at point A. You drive toward point B. AI pursuers chase
you in escalating waves — ram-class, sniper-class, swarm-class. You
drive with one thumb at the bottom of the screen, dragging side to
side to steer and up/down for throttle.

When pursuers close, you tap to fire a power-up. Smoke breaks line
of sight. Oil slick spins them out. EMP knocks them offline.

Along the route there are optional POIs — a lighthouse, a smuggler
cove, a ferry. Divert and you get a one-time relic. Skip and you
save time.

Each stage is four to eight minutes. Reach B to clear. Fail? Retry,
nothing lost.

Between stages, you visit your garage. You install power-ups you
picked up. You spend Miles on car upgrades — engine, handling,
armor. You unlock new cars. You read the relics you've collected;
each one tells a piece of the story of the couriers before you.
```

#### Store-page variant (Stage 1b optional, ~55 words)

```
You're a courier on a network of cross-country routes. AI pursuers
hunt you on every drive. Trigger power-ups to shake them. Divert
to relics along the way to fill in the story of who drove this
route before. Fail a stage? Retry, lose nothing. Build the garage.
Earn the bridge.
```

#### First 1–5 minutes the player experiences (~280 words)

```
Boot-up: studio logo, then a cinematic of a fortified depot at dawn.
A beat-up courier sedan rolls out of the gate. Voiceover: "Reach the
safe house. Don't get caught." Tap to start.

The car is already rolling forward. Tooltip arrow at the bottom of
the screen: "Drag to steer." Player drags. The car swerves around a
pothole. The HUD shows a small route map with distance to point B.

Twenty seconds in, the first pursuer appears in the rear-view — a
red-coded ram-class sedan. It accelerates and taps the player's
bumper. The screen jolts. A "smoke power-up ready" icon glows in
the HUD. A tooltip: "Tap the icon." Player taps. The car ejects a
plume of smoke; the chaser disappears from the rear-view for eight
seconds.

At the first fork, an optional POI marker glows off-route — a
lighthouse. Tooltip: "Divert? Costs five seconds. Awards a relic."
Player diverts. The car arcs onto a coastal track. A small mini-
puzzle plays: navigate two narrow rock pinches. Pick up the
lighthouse relic. Cinematic glimpse — the relic shows an old
courier's logbook fragment.

Back on route. The chaser is back. A second pursuer joins — a
sniper-class sedan that fires a long-range shot. The player has no
counter for it yet but they survive by weaving.

Point B appears: a fortified safe house. The car pulls in. Win
screen: 2 stars (missed one optional POI), 350 Miles, 1 relic
collected, 1 power-up picked up mid-stage ("Oil slick").

Garage screen opens. Player installs Oil slick into loadout slot 2.
Stage 2 unlocks on the map.
```

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

```
Day 1. The player clears stage 1 (Coastal Run) 2-star, retries to
3-star on attempt 3, and unlocks stage 2 (Desert Crossing). They've
installed 2 power-ups, picked up 3 relics, and made their first car
upgrade. The hook for returning tomorrow is the visible map — 4
more stages glow on it, plus a scripted finale stage (The Bridge)
shaded grey.

Day 2. Returning player tackles Desert Crossing. Sandstorm
visibility events test the smoke power-up (which now doesn't help
much in low-vis) and force them to install the EMP power-up they
picked up. First "I'm playing tactics with my loadout" moment.

Day 3. Stage 3 (Mountain Pass) unlocks. The avalanche-tunnel
shortcut requires the EMP power-up, which the player has installed.
They use it. The shortcut shaves 90 seconds off the stage. They
beat their previous time and get a 3-star reward including their
first hard-currency Tokens drop.

Day 5. First story beat — at the mountain monastery POI, a courier
NPC gives an extended cutscene. The world's tone shifts darker. The
relics on the player's gallery start telling a coherent story about
the previous Crossing driver, whose logbook ends on the bridge.

Day 7. Stage 3 fully 3-starred. Stage 4 (Urban Ruin) unlocks. The
city pursuers are a different shape — alley-block ambushes test
new power-up routings. Player buys a second car (better armor).

Day 10. Daily modifier system kicks in on stages 1–3. "No power-
ups" challenge on Coastal Run anchors a return reason. Player
attempts and fails — but the failure costs nothing and the run is
6 minutes. They try a second time and clear it; the modifier
challenge nets a relic they didn't have.

Day 14. Stage 4 mostly cleared. Stage 5 (The Bridge) teased on the
map screen — only one stage to go. The player's garage has 5 cars,
15 power-ups installed, 25 relics, and the relic-gallery story is
clearly setting up a finale revelation at the bridge. The dominant
return reason is the campaign — they want to read the next chapter.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a stage-based no-wipe chase driver.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Single static frame mid-stage: player car in lower-third, dramatic chase camera, rear-view inset showing pursuers, optional-POI marker glowing off-route, power-up HUD strip with three icons, route map peek-overlay. Must read as "I'm a courier being chased" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. Player car at speed across a coastal cliffside road, two pursuers in shot, dramatic horizon-line framing. Painterly stylized 3D, cinematic chase tone. |
| **Key UI frames** | TBD | (1) World map / stage select, (2) Stage HUD mid-drive, (3) Garage / car loadout, (4) Power-up install screen, (5) Relic gallery, (6) Stage clear / retry screen. |
| **App store icon** | TBD | 1024×1024. Player car mid-chase, motion-blurred pursuer behind, dramatic three-quarter angle. Tested for thumbnail readability at 88×88 — must read as "chase game" not "racing." |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: one full map (Coastal Run, A→B drive), 1 car, 4 power-ups, 1 AI pursuer class, 2 optional POIs, 2 relics. Stage clear + retry flow + garage install of one new power-up. No second map, no story cutscenes. Must feel-representative on a real device — chase tension is the entire pitch. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 30s drive + steering read, first pursuer engage + first power-up use, first optional-POI divert, first stage clear → garage transition. Each scored separately at Stage 4. |
