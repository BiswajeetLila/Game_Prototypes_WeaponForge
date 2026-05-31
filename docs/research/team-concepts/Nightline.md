# Nightline — Concept Template v2

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
| Working title | Nightline |
| Genre / subgenre | Train-as-base survival with day/night phase loop, FTL-style crew command, and auto-roguelite stage progression with in-run upgrade picks |
| Target audience | Mid-core players (14–40) who love tower-defense-meets-management hybrids and auto-roguelites — FTL, This War of Mine, They Are Billions, Project Zomboid, Vampire Survivors. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

Your train is your home and your only safe zone. Each journey splits into Chapters — regions of rail — built from Stages, where a Stage is one night drive between stations. During the day, the train is parked and you walk off into a small scavenge zone to find supplies, survivors, and new train-cart blueprints. At dusk you board. Night Things climb the sides, smash windows, drop from the roof. You position crew at gun ports and breaches; combat resolves automatically. Kills drop upgrade cards — pick one. Defensive carts like electric fences damage boarders on contact. Survive to dawn. Reach the next station. The train is named, customized, yours.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Train parked at a rural depot at noon. Voiceover: "The Night Things come at dusk. Daylight repels them. The train is the only way." Chapter 1 — Stage 1 banner fades in. Tap to start.
- **5–15s:** Day phase: player walks off the train into a small wave-cleared scavenge zone. Tap-to-move tutorial.
- **15–25s:** First scavenge: an abandoned gas station. Loot scrap and ammo. A single shambler is auto-engaged on approach.
- **25–40s:** Dusk warning timer flashes. Player runs back to the train.
- **40–60s:** Train drives. Night phase begins. First zombie climbs the side of a car. Player taps the crew portrait, taps the car — crew auto-engages the breach. Kill drops an upgrade-card pick: "+25% gun-port damage" / "Headlight stun." Player taps to pick. **The "command-mode roguelite on rails" moment.**

---

## 5. Hypothesis of why this would work

FTL proved Western players love crew-control management in a high-pressure context. They Are Billions and Project Zomboid proved zombie-defense holds long-arc attention. Snowpiercer's pop-culture footprint validates the "train as last refuge" silhouette as instantly readable. Vampire Survivors and Brotato proved the in-run upgrade-pick loop sustains massive Western engagement on its own. The unmet combination is *FTL-style crew command + train-as-base + day/night phase loop + roguelite upgrade picks on mobile*.

The bet is that the *day/night phase contrast* is the core engagement engine, and that the auto-combat + upgrade-card layer broadens the audience without diluting the management fantasy. Most survival games have a single dominant moment-to-moment; Nightline has two, and the contrast between safe-day-scavenge and command-mode-night-defense is its own pleasure. Auto-combat-default removes the panic-twitch barrier that mid-core mobile players bounce off, while crew positioning + repair triage + upgrade picks keep agency high. Our diff is the third-person walking-the-train metaphor (vs. FTL's top-down ship), the physical day/night cycle, the chapter/stage rail structure, and the named-train customization layer that gives the player a "this is mine" emotional anchor.

---

## 6. Risks

**Single fragile assumption:**

*With auto-combat default ON, the player's moment-to-moment job during night phase is crew positioning + upgrade-card picks + repair triage. The fragile assumption is that this command + roguelite-pick loop feels active and high-agency, not passive idle. If the night reads as "auto-play with menu picks," players churn at the second or third night because nothing they do feels like the difference between winning and losing.*

Stage 1 bundle: *"Night phase feels like an active command-mode climax of the cycle, not idle auto-play between scavenges."* Stage 4 (gameplay video) must show the dusk transition as a "lean in" moment, and must show at least one player-decision that visibly changes the outcome — a re-routed crew member saving a breach, or a chosen upgrade card cutting through a wave. Manual-override combat is available for players who want it but is not the default contract.

---

## 7. Reference games

1. **FTL: Faster Than Light** — Subset Games, 2012. Crew-control + station management in high-pressure combat. We share the crew-station defense pattern; we don't share paused-tactical play — Nightline is real-time with auto-resolved combat.
2. **Snowpiercer (cultural reference) + Dredge** — Bong Joon-ho / Black Salt. Train-as-last-refuge silhouette + tense night-creature mechanic. We share the visual silhouette of a single moving home in a hostile world and the night-creature pacing; we don't share the IP.
3. **Project Zomboid / This War of Mine** — Indie Stone / 11 bit. Zombie survival + named-survivor management. We share the named-NPC management + day/night cycle pattern; we don't share the open-world map — Nightline is rail-network gated.
4. **Vampire Survivors / Brotato** — poncle / Blobfish, 2022–2023. Auto-combat with in-run upgrade-card picks driving the roguelite cadence. We share the per-stage upgrade-card layer; we don't share the bullet-heaven density — Nightline's picks layer onto crew/cart command.

**Genre mashup formula:** FTL × Snowpiercer × Project Zomboid × Vampire Survivors

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- Chapter 1 — Stage 1 cleared. First night survived to dawn. Defense screen tallies kills, breaches, repairs, and the 3 upgrade cards picked during the run.
- Arrive at next station at dawn. Day phase: scavenge zone with a new survivor pod.
- Recruit Dr. Ellis (medic). Stage reward roll: infirmary car blueprint unlocked.
- Player adds the infirmary car to their train layout. Visible: the train is one car longer. Chapter 1 — Stage 2 banner cues up.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | Train with 3 cars (engine + cargo + sleeper), 1 survivor. Chapter 1 Stage 1 cleared. | Stage 2 ahead + first electric-fence-car blueprint tease. |
| D3 | 5 cars (infirmary + gunner), 4 survivors. Chapter 1 Stage 3 cleared. ~8 upgrade-card runs completed. | Chapter 1 milestone-hub Stage 4 unlock + harder night drives. |
| D7 | 8 cars, 8 survivors, electric-fence car built, named-train customization unlocked. Chapter 1 complete. | Mounted-cannon car unlock + first Screamer variant + Chapter 2 region tease. |
| D14 | 12 cars, 12 survivors, mid-Chapter 2 (darker biome). | Chapter 3 long-arc tease + nightly per-stage leaderboard for upgrade-card builds. |

**Station-reward rule:** Every station yields one of: a new survivor with skill tags, a new car blueprint, or a permanent-roster upgrade-card unlock. Randomized but weighted by chapter progress so harder stages drop better rewards.

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~135 words)

```
Your train is your home and your only safe zone. The journey splits
into Chapters and Stages — one Stage is one night drive between
stations.

Day phase, the train is parked. You step off into a small wave-
cleared scavenge zone. Tap to move, tap to interact. You loot
containers, refuel, recruit survivors. A dusk warning counts down.

At dusk you board. Night phase begins. Zombies climb the sides,
smash windows, drop from the roof. You run car to car inside the
moving train, tapping crew portraits and dragging them to breach
cars and gun ports. Combat auto-resolves once crew are positioned.
Defensive carts like electric fences damage boarders on contact.
Each kill drops an upgrade-card pick — tap one. Picks persist for
the stage.

Arrive at the next station at dawn. The cycle starts again. Each
stage runs fifteen to twenty-five minutes.
```

#### Full description of core loop + 1 meta progression (Stage 1, genre-required, ~170 words)

```
Your train is your home and your only safe zone. The journey splits
into Chapters and Stages — one Stage is one night drive between
stations.

Day phase, the train is parked. You step off into a small wave-
cleared scavenge zone. Tap to move and interact. You loot
containers, refuel, recruit survivors. A dusk warning counts down.

At dusk you board. Night phase begins. Zombies climb the sides,
smash windows, drop from the roof. You position crew at gun ports
and breaches; combat auto-resolves. Kills drop upgrade-card picks
that persist for the stage. Defensive carts like electric fences
damage boarders on contact.

Arrive at the next station at dawn.

Rescued survivors join the train. Each has skill tags and gets
assigned to a car as station crew. Station rewards drop new modular
cars — gunner, infirmary, mess, sleeper, mounted-cannon, plow,
electric-fence, comms — and engine upgrades for speed and headlight
reach. The train is named, customized, and grows visibly. Chapters
chain toward milestone hubs.
```

#### Store-page variant (Stage 1b optional, ~55 words)

```
Your train is the only safe place left. Park during the day, step
off to scavenge and recruit. At dusk, board and drive. Night Things
climb the sides and break the windows. Position your crew, pick
upgrade cards on every kill, bolt on electric fences and gun cars.
Survive until dawn. Push deeper. Family-found, claustrophobic,
defiant.
```

#### First 1–5 minutes the player experiences (~280 words)

```
Boot-up: studio logo, then a slow camera pan across a small train
parked at a rural depot at noon. The train is named and customized
(a placeholder banner says "give your train a name" later).
Voiceover: "The Night Things come at dusk. Daylight repels them.
The train is the only way." A title card fades in: Chapter 1 —
Stage 1. Tap to start.

Day phase. The player character steps off the train into a sun-
bright scavenge zone — an abandoned gas station, a derelict
hardware store. Tap-to-move activates. Tooltip: "Tap to walk, tap
to interact." Player taps toward a container.

Loot drops: 6 scrap, 3 ammo. A shambler stumbles out of the
hardware store. The player character auto-engages and the shambler
goes down in three hits.

Countdown HUD: "Dusk in 30 seconds." Player runs back to the train.
A cinematic of the doors hissing shut.

The view shifts to the train interior, over-the-shoulder third-
person inside a narrow corridor.

Night phase. The world outside the windows darkens. The train rolls
forward. A first zombie climbs the side of the forward car. A
breach indicator flashes red on the HUD. Tooltip: "Tap a crew
portrait, then tap a car." Player drags their only crew to the
breach. Crew auto-engages. Zombie down.

A kill-banner appears: "Pick an upgrade." Three cards: "+25% gun-
port damage," "Headlight stun: 1s," "Repair speed +30%." Player
taps one. The card glows on the HUD as active for the stage.

A second breach blinks in the rear car. The train drives on. Dawn
approaches at the 10-minute mark.
```

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

```
Day 1. The player completes Chapter 1 — Stage 1, survives the first
night with 2 breaches, recruits Dr. Ellis (medic), and the Stage
reward roll unlocks the infirmary car blueprint. They picked 3
upgrade cards during the run; one persists as a permanent-roster
unlock at the station. The hook for returning tomorrow is the
visible train layout — 4 more car slots open and 3 more crew
portraits glow on the recruit screen as future possibilities.

Day 2. Returning player clears Stages 2 and 3 of Chapter 1. Stage 3
introduces sprinter zombies — faster threats that demand quicker
crew routing. First "I have to think about positioning" moment.
Electric-fence car blueprint drops as a Stage reward.

Day 3. Player adds the gunner car and the electric-fence car. The
electric fence does meaningful boarding damage on its first night.
They name their train ("The Iron Wren") on the cosmetic menu.
Customization persists.

Day 5. Player encounters a Screamer variant — when one spawns the
horde density spikes. The infirmary car becomes critical. First
time the player has to re-route ammo couriers mid-stage and lean
on the upgrade-card layer to break a stalled night.

Day 7. Mounted-cannon car unlocked. Player's train is now 8 cars
long. Chapter 1 complete — they reach the first milestone hub, a
heavily fortified station that serves as a major safe-rest.
Cinematic of meeting other survivors who run the hub.

Day 10. Chapter 2 attempted — a darker biome with new enemy
variants. First long-route (three consecutive Stages without a
hub) attempted. Player fails on the third night, reduced-cargo
setback, not full wipe. Upgrade-card build felt undertuned.

Day 14. Player has 12 cars including a comms car, a workshop car,
and a plow car. 12 survivors across stations. Named-train livery
changed twice. The dominant return reasons stack: Chapter 2
milestone push, new-car upgrades, crew morale management, upgrade-
card build experimentation, and the Chapter 3 long-arc tease.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a train-base survival game with auto-roguelite night defense.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Two candidate frames: (A) day phase scavenge in sun-bright street, train parked in background as safe-zone, player character mid-loot, dusk countdown visible. (B) night phase inside the train, narrow car corridor view, zombie smashing a window, crew portrait HUD on the side, breach indicators flashing, **upgrade-card pick overlay popping in at the bottom**. Both must read as "day/night defense + train base + roguelite picks" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. The train at dusk, headlights cutting forward, silhouettes of Night Things outside, **arcs of electric-fence current visible along one car**. Strong directional lighting — warm interior, black-blue exterior. |
| **Key UI frames** | TBD | (1) Day phase HUD with dusk countdown, (2) Night phase HUD with breach indicators, (3) Crew assignment screen, (4) Car modular layout (including electric-fence car), (5) **Upgrade-card pick screen (3-card layout) — the roguelite tentpole UI**, (6) Train customization (livery + name), (7) Route map showing chapters as regions and stages as nodes between hubs. |
| **App store icon** | TBD | 1024×1024. The train silhouetted against a stormy night sky, headlights forward, faint electric-fence arc visible. Tested for thumbnail readability at 88×88 — must read as "train + survival" not just "train sim." |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: train with 3 cars (engine, cargo, sleeper) + 1 unlockable electric-fence car, 1 day station (rural depot), 1 full Chapter 1 — Stage 1 day/night cycle, 1 zombie variant (shambler), 1 survivor rescue with car unlock, auto-combat default with manual-override tap, **upgrade-card pick system live (3-card pop on kill, 3 picks per night)**. Crew assignment functional. No Chapter 2, no long-route. Must feel-representative on a real device — day/night transition + upgrade-card moment are the central pillars. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Five beats: first 30s day-phase scavenge, dusk warning → board cinematic, first night-phase breach defense + crew assignment, **first upgrade-card pick (3-card overlay)**, first dawn arrival → recruit + electric-fence-car unlock. Each scored separately at Stage 4. |
