# Iron Frontier — Concept Template v2

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
| Working title | Iron Frontier |
| Genre / subgenre | Cozy / methodical rail-pioneer exploration with light sim driving |
| Target audience | Cozy + slow-builder players (12–50) who love route-planning, fog-of-war discovery, and base growth — Mini Motorways / Dorfromantik fans who want a stronger narrative arc. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

You run a frontier rail station at the edge of a fogged-out continent. From your home, you decide where to lay new track — drag a route, send a crew, wait while they build. Once the rail is down, you board your train and ride along it, throttling and braking, switching junctions, scanning for hazards. At the end of the line, you dismount and explore a small POI on foot: a derelict town, a monastery, a bandit camp. You haul loot home, rescue survivors, upgrade your station and train. Slowly, the continent reopens around you, one stretch of rail at a time.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** A wide painterly shot of a frontier station at dawn, fog stretching to the horizon. Voiceover: "The Quiet Years ended. The rails are yours." Tap to start.
- **5–15s:** Planning map opens. The home station sits at the south edge. Tooltip: "Drag a track from the railhead." Player drags toward a fogged POI 200 meters out.
- **15–25s:** Construction crew lays the track in 30 seconds of compressed real-time. The new rail head opens up.
- **25–40s:** Tap-to-board the train. Cinematic of the train rolling out. First throttle drag tutorial. Player drives at modest speed.
- **40–60s:** Arrive at the first POI — a ruined depot. Step off the train. Loot a crate. **The "I'm building this railway one mile at a time" moment.**

---

## 5. Hypothesis of why this would work

Mini Motorways and Dorfromantik proved Western mobile will accept slow-pace map-planning games at sustained engagement. Neither, however, layers a narrative drive-and-explore loop on top — they're pure puzzle. Subnautica and Sable showed that hopeful exploration-with-discovery holds long sessions when the discoveries are aesthetic, not just mechanical. The unmet combination is route-planning + exploration + cozy narrative arc on mobile.

The bet is that the rail-laying decision is a high-stakes, satisfying choice that ports naturally to portrait mobile: you drag a line on a fogged map and commit. The train ride is intentionally low-stress — this is "scenic" gameplay, not racing. Survivors and POIs become the dopamine. The shipped reference is Stardew Valley mobile — ConcernedApe proved Western mobile will pay for cozy slow-burn at depth. Our diff is the rail-system mechanic which gives spatial planning a real expression (where you lay track decides what biomes you unlock) versus Stardew's farm-grid which is more static.

---

## 6. Risks

**Single fragile assumption:**

*Cozy / methodical players will accept the planning-then-waiting cadence (lay track, wait for crew to build, ride out) as the central pleasure rather than padding. They must perceive the wait as "the world is being built" not "the game is gating me."*

If the wait reads as gating, players churn before the discovery loop kicks in. Stage 1 bundle: *"Waiting for the crew to lay track feels like watching the world grow, not like waiting for the game to let me play."* Stage 4 (gameplay video) must show the lay-time as visually satisfying — the rails being driven in by little crew chibis, the fog visibly retreating.

---

## 7. Reference games

1. **Mini Motorways** — Dinosaur Polo Club, 2019, mobile/PC. Slow-pace route-planning with fog-of-progress. We share the planning-puzzle mechanic and the cozy aesthetic; we don't share the abstract roads — Iron Frontier has a literal train you ride.
2. **Stardew Valley** — ConcernedApe, 2016, multi-platform. Cozy slow-burn with progression and discovery. We share the methodical pacing, base growth, and survivor-driven unlocks; we don't share the farm sim — Iron Frontier is rail + exploration.
3. **Dorfromantik / Sable** — Toukana Interactive / Shedworks. Hopeful exploration + discovery. We share the painterly visual tone and aesthetic-led discovery; we don't share the puzzle-tile or open-walking format — Iron Frontier is rail-bound.

**Genre mashup formula:** Mini Motorways × Stardew Valley × Subnautica (early-game)

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- First trip back home. Two scrap and one survivor (a surveyor) recovered. Cinematic of the survivor settling at the station.
- Station upgrade screen. Surveyor unlocks survey range +20% — fog-reveal cone is now bigger.
- Player lays a second track segment, this time toward a biome boundary. Lay time is longer (60 seconds).
- First biome border tooltip: "Mountain region requires Trestle tech." Anchor for tomorrow.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | Home station + 2 track segments + 1 survivor (surveyor) + small loot pile. | Mountain region teased on the map; need Trestle tech to enter. |
| D3 | Greenwilds fully explored. 4 survivors. Trestle tech unlocked. First mountain segment laid. | First biome unlock + The Pan tease (bandit fortifications). |
| D7 | Ironreach mountain segments laid. Second train car (cargo) installed. | Repair runs unlocked + named NPC story beat at the abandoned bridge. |
| D14 | 3 biomes touched. 8 survivors. Train has 4 cars. First Bridge Candidate site identified. | The Iron Bridge long arc — the player can see the Capitol on the map and the bridge they need to build. |

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~140 words)

```
You run a frontier rail station at the edge of an unexplored
continent. The world is hidden under fog. You decide where to lay
new track.

You drag a line on the map from your current railhead toward a
fogged direction. The path locks. A construction crew lays the
rails over time — a minute or two at first, longer as you push
further. When the segment is done, the fog peels back along it and
the new railhead opens up new lay directions.

You board your train and ride the network. You throttle, brake,
switch junctions, scan for hazards. It's relaxed driving — not
racing.

At the end of a line, you dismount at a POI. You explore on foot,
loot, rescue survivors, fight light hostiles in certain biomes.

You ride home and spend at the station.
```

#### Full description of core loop + 1 meta progression (Stage 1, genre-required, ~170 words)

```
You run a frontier rail station at the edge of an unexplored
continent. The world is hidden under fog. You decide where to lay
new track.

You drag a line on the map from your current railhead toward a
fogged direction. The path locks. A construction crew lays the
rails over time — a minute or two at first, longer as you push
further. When the segment is done, the fog peels back along it and
the new railhead opens up new lay directions.

You board your train and ride the network. You throttle, brake,
switch junctions, scan for hazards. It's relaxed driving — not
racing.

At the end of a line, you dismount at a POI. You explore on foot,
loot, rescue survivors, fight light hostiles in certain biomes.

You ride home and spend at the station.

Survivors you rescue become crew. Each crew member has a skill —
surveyor, navvy, engineer, conductor, guard — that accelerates a
part of your operation. You spend scrap on station modules and
train cars: bigger fuel range, faster lay speed, plow car,
observation car. Slowly, the continent reopens around you.
```

#### Store-page variant (Stage 1b optional, ~55 words)

```
You run a frontier rail station at the edge of a forgotten
continent. Lay track into the fog. Drive your train along the new
line. Explore ruins. Rescue survivors. Upgrade your station and
your train. The map reopens one stretch of steel at a time. Cozy,
methodical, hopeful.
```

#### First 1–5 minutes the player experiences (~280 words)

```
Boot-up: studio logo, then a slow painterly pan across a frontier
station at dawn. Sunlight catches the rails. A small steam train
sits idle at the platform. Voiceover: "The Quiet Years are over.
The rails are yours." Tap to start.

The planning map opens. The home station is at the south edge of a
mostly fogged continent. A tooltip arrow points at the railhead:
"Drag a line into the fog." Player drags toward a faint POI silhouette
200 meters out. The line locks. A small icon pops: "Crew laying
track — 30 seconds."

The 30 seconds compress visually — chibi survey crews running
forward, ties dropping, rails clamping in. The fog peels back as
they go. The new railhead glows.

Tap to board the train. A cinematic loads — the player walking
along the platform, climbing into the cab. The view shifts to a
side-on third-person camera. Tooltip: "Drag for throttle." Player
drags. The train rolls forward. The world streams past — small
trees, a deer crossing.

The train arrives at the new POI — a ruined depot. The player
dismounts. Top-down explore camera. Two crates and a survivor pod
glow. Player loots: 12 scrap, 2 parts. They open the survivor pod:
a surveyor named Mara joins. Cinematic glimpse of Mara waving.

Player taps "Return Home." The train rides back along its own line.
Station screen opens. Mara's portrait sits at the station. Her
surveyor skill unlocks: survey range +20%. The fog cone on the next
lay-plan is visibly larger.

Player drags a second track segment, this time toward a biome
border marked "Mountain — Trestle Required." Tooltip: "Upgrade your
station to unlock trestle tech."
```

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

```
Day 1. The player lays 2 track segments, rides 2 short trips,
rescues 1 survivor, and loots ~30 scrap. They've seen the fog peel
back and seen their station gain one upgrade. The hook for
returning tomorrow is the biome boundary they can see on the map —
Mountain region, locked behind Trestle tech, which the station
roadmap shows requires 2 more survivors + 80 scrap.

Day 2. Returning player notices their crew has lay-built a second
segment passively overnight. They drive out, explore a new POI (an
abandoned signal mast), rescue an engineer, find more scrap. They
unlock Trestle tech. They lay their first mountain segment.

Day 3. Mountain biome's first POI is a ruined monastery. Player
recovers a rare artifact (a music box) that unlocks cosmetic
station decorations. First aesthetic moment.

Day 5. The Pan (dry plains) opens up. Bandit camp encountered — the
player's first hostile POI. They retreat. They send a guard
survivor on the next trip. First combat moment, lightweight.

Day 7. Iron-rich Ironreach segment cleared. The player upgrades the
train with a cargo car. They can now haul double scrap per trip.
First "the upgrades compound" moment.

Day 10. First Bridge Candidate Site identified on the map — a river
crossing that requires a major Iron Bridge construction project.
The project requires 5 different rare resources. Player begins
the long-arc gathering.

Day 14. Three biomes touched (Greenwilds, Ironreach, The Pan).
Eight survivors at the station. The station has visibly grown:
warm lights at night, a small market square, named NPCs walking
around. The first long-arc story beat lands — a survivor's
journal hints at the Capitol Ruin. The dominant return reason is
the slow-burn cadence: the player has 2 lay jobs queued, an Iron
Bridge project halfway done, and a new biome to explore once the
bridge is finished. Sessions naturally stretch to 15–20 minutes as
they juggle multiple parallel goals.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a cozy rail-pioneer game.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Two candidate frames: (A) the planning map mid-track-drag, with the proposed segment glowing, fog visible, biome borders marked. (B) the train ride mid-trip, side-on third-person, painterly biome streaming past, HUD with throttle/junction indicator. Both must read as "I'm building a railway in a hopeful frontier" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. The home station at dawn with rails curving into a foggy painterly distance, the train at the platform, a surveyor character waving. Studio-Ghibli-meets-American-frontier vibe. |
| **Key UI frames** | TBD | (1) Planning map / track-drag, (2) Train ride HUD, (3) POI on-foot exploration, (4) Station upgrade screen, (5) Survivor roster + skills, (6) Train car loadout. |
| **App store icon** | TBD | 1024×1024. A single steam train coming around a curve through a painterly biome at sunset. Tested for thumbnail readability at 88×88 — must read as "trains + exploration" not "racing" or "sim city." |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: one region (Greenwilds), planning map with 3 lay-able directions, 5 POIs, 1 train car set, 3 survivor types. Lay → ride → explore → return loop fully functional. No second biome, no Iron Bridge. Must feel-representative on a real device — the lay-and-wait cadence is the entire pitch. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 30s lay-track read, first train-ride read, first POI exploration + survivor rescue, first return-home + station-upgrade transition. Each scored separately at Stage 4. |
