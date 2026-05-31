# Last Line — Concept Template v2

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
| Working title | Last Line |
| Genre / subgenre | Train-base + expedition with auto-resolved on-foot scavenging, chapter/stage rail progression, in-run upgrade picks, and return-ride defense via modular carts |
| Target audience | Survival + base-building players (14–45) who love State of Decay, Frostpunk, This War of Mine, Pacific Drive, and auto-roguelites like Vampire Survivors. Want a methodical expedition cadence with returning home-base growth. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

You run a fortified train station at the edge of a post-collapse wasteland. The rail network splits into Chapters — regions — each with multiple Stages, one per town. You pick a destination, ride out, park the train as your forward base, and step off on foot. On-foot combat resolves automatically; you tap to interact, loot, and pick upgrade cards that drop as light hostiles fall — buffs that last the expedition. You haul resources back. The return ride sometimes triggers an ambush; defensive carts like turrets and electric fences fight for you. Survivors rescued become workers and unlock station modules and new carts. Long arc: restore the regional rail hub.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Fortified train station at dawn. Voiceover: "The Long Winter took everyone. The rails are how we go forward." Chapter 1 — Stage 1 banner fades in. Tap to start.
- **5–15s:** Network map opens. One destination glows: Greenfield (farming suburb). Player taps. Cinematic of boarding the train.
- **15–25s:** Train drive segment. Drag-throttle tutorial. Player taps a junction to switch tracks. Hazard scan: a wreck on the line.
- **25–40s:** Arrives at Greenfield. Train parks. Cinematic of stepping off. Tap-to-move on foot.
- **40–60s:** First scavenge — container in a ruined farmhouse. Loot: 8 scrap, 3 food. A shambler is auto-engaged on approach. Kill drops an upgrade-card pick: "+1 carry slot" / "+25% loot speed" / "Heal on next pickup." Player taps one. **The "this is my expedition, my pick, my haul" moment.**

---

## 5. Hypothesis of why this would work

State of Decay and This War of Mine proved Western mid-core will invest deeply in survivor-management base-building. Frostpunk proved the methodical-expedition cadence holds attention. Vampire Survivors and Brotato proved auto-combat with in-run upgrade picks sustains massive Western engagement. Mobile has had no winning version of this combination — Frostpunk Mobile exists but is tiny, and State of Decay mobile doesn't ship. The unmet pattern is *train-as-base + expedition + auto-resolved on-foot scavenging + roguelite upgrade picks on mobile*.

The bet is that the train-as-base mechanic gives the game a unique silhouette no other survival mobile game has — visually instantly readable in marketing and giving the gameplay a built-in pacing rhythm (ride to town, get off, return). Auto-combat unifies the input contract across train drive + on-foot scavenge (one tap-to-act metaphor everywhere), and the upgrade-card layer broadens the audience to the roguelite crowd without diluting the survival-management fantasy. The shipped reference is Pacific Drive — Ironwood proved Western players love the "your vehicle is your home" pattern at intense engagement. Our diff is mobile-first, train-network-structured (vs. open road), chapter/stage progression, and survivor-driven progression that compounds across expeditions.

---

## 6. Risks

**Single fragile assumption:**

*With auto-combat default ON across both train drive and on-foot scavenge, the player's moment-to-moment work is route choice, looting, upgrade-card picks, and defensive-cart loadout decisions. The fragile assumption is that the on-foot scavenge feels like an agency-driven expedition, not like "watch the character auto-fight while I tap loot." If the player can't point to a decision they made in the first expedition that changed the outcome, the loop reads as idle.*

Stage 1 bundle: *"Riding the train and getting off to scavenge feels like one game with one input contract, and every expedition has a moment where my choice mattered."* The earlier dual-control-scheme risk is largely defused by the auto-combat default — train and foot now share one tap-to-act metaphor. Stage 4 (gameplay video) must show at least one player-decision that visibly changes the outcome — a chosen upgrade card opening a previously inaccessible loot stash, or a cart loadout repelling the return-ride ambush. Manual-override tap-combat available but not the default.

---

## 7. Reference games

1. **State of Decay** — Undead Labs, 2013, multi-platform. Survivor-management + base + expedition loop. We share the survivor-skill-driven unlock pattern and base growth; we don't share the open-world driving — Last Line is rail-network gated.
2. **Frostpunk** — 11 bit, 2018, PC/console/mobile. Methodical-expedition + base survival. We share the cadence and the survivor management; we don't share the city-builder grid.
3. **Pacific Drive** — Ironwood, 2024, PC/console. "Your vehicle is your home" loop. We share the vehicle-as-base feel; we don't share the open-road structure — Last Line is rail.
4. **Vampire Survivors / Brotato** — poncle / Blobfish, 2022–2023. Auto-combat with in-run upgrade-card picks. We share the per-expedition upgrade-card layer driving the roguelite cadence; we don't share the bullet-heaven density — Last Line's picks shape a methodical scavenge.

**Genre mashup formula:** State of Decay × Frostpunk × Pacific Drive × Vampire Survivors

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- Chapter 1 — Stage 1 (Greenfield) cleared with 1 survivor rescued (Mary, mechanic), 30 scrap, 12 food, 3 upgrade-card picks during the run.
- Train ride home. A scripted first ambush triggers at the midway point — bandit raiders board the locomotive. The player's stock train has no defensive carts yet; they take some damage but survive. The ambush ends with a turret-cart blueprint dropped on the tracks.
- Station screen opens. Mary's mechanic skill unlocks the workshop module. Player places the workshop on the base grid. Build timer: 3 minutes real-time.
- Westport destination unlocked on the rail map as Chapter 1 — Stage 2. Anchor for tomorrow.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | Train, station with 2 modules, 1 survivor. Chapter 1 Stage 1 cleared. Turret-cart blueprint dropped. | Workshop completing + Stage 2 (Westport) tease + first defensive cart build. |
| D3 | 3 survivors, 4 modules built, turret cart attached. Chapter 1 Stage 3 cleared. ~9 upgrade-card runs completed. | Stage 4 (Ironhill, industrial) tease + electric-fence-cart blueprint drop. |
| D7 | Chapter 1 milestone-hub (Ironhill) reached. First gang faction encountered. Train has turret + electric fence + cargo + sleeper. | Chapter 2 Stage 1 (St. Marian, hospital) tease + infected hostiles tease. |
| D14 | 8 survivors. Station looks like a real settlement. Chapter 2 mid-route. 4 stages cleared overall. | Chapter 3 (Foxbridge junction) unlock tease + long-arc Capitol approach + permanent upgrade-card roster experimentation. |

**Station-reward rule (per Stage):** Each town yields a survivor with skill tags **and** a chance at a new cart blueprint (offensive: turret, mounted-cannon; defensive: electric fence, plow; utility: workshop, infirmary, fuel-extender). Higher-Stage towns weight toward better drops.

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~135 words)

```
You run a fortified train station. The rail network is split into
Chapters — regions — each with multiple Stages, one per town. You
pick a destination and board your train. The train rolls out. You
drive it with one thumb — throttle drag, tap to brake, tap a
junction to switch tracks.

You arrive at the town. The train parks and becomes your forward
base. You step off on foot. Tap to walk, tap to interact and loot.
Light hostiles are auto-engaged. Each kill drops an upgrade-card
pick that persists for the expedition.

You haul resources back to the parked train. You drive home. Some
return rides trigger an ambush — turret carts and electric-fence
carts you've attached fight for you.

Each expedition takes ten to twenty-five minutes. There are no
runs and no wipes.
```

#### Full description of core loop + 1 meta progression (Stage 1, optional for run-based, ~170 words)

```
You run a fortified train station. The rail network is split into
Chapters and Stages — one Stage is one town expedition. You pick a
destination and board your train. The train rolls out. You drive
with one thumb — throttle drag, tap to brake, tap a junction.

You arrive at the town. The train parks and becomes your forward
base. You step off. Tap to walk, tap to interact and loot. Light
hostiles are auto-engaged. Kills drop upgrade-card picks that
persist for the expedition.

You haul resources back. The return ride may trigger an ambush;
attached turret and electric-fence carts auto-defend.

Each expedition runs ten to twenty-five minutes.

At the home station, you unload haul and assign survivors to roles.
Each survivor has 1–3 skill tags (mechanic, medic, engineer, scout,
gunner). Their skills unlock or accelerate station modules —
workshop, infirmary, comms, armory, farm. Stage rewards drop new
train-cart blueprints (offensive, defensive, utility). New Chapters
unlock as you push the rail map forward.
```

#### Store-page variant (Stage 1b optional, ~55 words)

```
Run a fortified train station at the edge of a quiet wasteland.
Board your train. Ride to ruined towns. Park, step off, scavenge.
Pick upgrade cards on every kill. Bolt turret and electric-fence
carts to your train and survive the return ambush. Rescue
survivors. Each one unlocks a new building. Slow, methodical,
hopeful.
```

#### First 1–5 minutes the player experiences (~280 words)

```
Boot-up: studio logo, then a slow camera pan across a fortified
train station at dawn. A small steam train sits at the platform.
Voiceover: "The Long Winter took everyone. The rails are how we go
forward." A title card fades in: Chapter 1 — Stage 1. Tap to start.

The network map opens. The home station sits at the center. One
destination glows: Greenfield (farming suburb). Player taps.
Cinematic of boarding the train.

The view shifts to the train cab. Tooltip: "Drag for throttle."
Player drags. The train rolls forward. The world streams past —
overgrown fields, abandoned cars on adjacent roads. A junction
marker glows: "Tap to switch tracks." Player taps. The train
branches onto the right line. A wreck looms on the left line.

The train arrives at Greenfield. Cinematic: the train parks at a
ruined platform. The view shifts to over-the-shoulder third-person.
The player character steps off. Tooltip: "Tap to walk, tap to
interact."

Container glows. Player taps. Loot drops: 8 scrap, 3 food. A
shambler shambles in and is auto-engaged. Three swings, down.

A kill-banner appears: "Pick an upgrade." Three cards: "+1 carry
slot," "+25% loot speed," "Heal on next pickup." Player taps one.

A survivor pod glows in the next building. Mary (mechanic) joins
the roster.

Player taps "Return to Train." They haul resources into the cargo
car. Train drives back. At the midway point a scripted ambush
triggers — bandits board the locomotive. The player has no
defensive carts yet; they take some damage. The ambush ends with
a turret-cart blueprint dropped as Stage reward. Station screen
opens. Mary unlocks the workshop. Chapter 1 — Stage 2 (Westport)
appears on the rail map.
```

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

```
Day 1. The player completes Chapter 1 — Stage 1, rescues Mary,
builds the workshop, and unlocks Stage 2 (Westport). 80 scrap, 25
food hauled, 3 upgrade-card picks during the run. The first return-
ride ambush dropped a turret-cart blueprint. The hook for returning
tomorrow is the visible base grid — 12 empty plots, 3 module
blueprints already queued — plus the turret cart they can build
before the next expedition.

Day 2. Returning player tackles Westport. Docks, fuel-rich, gang
factions introduce the first faction encounter. They rescue Davis
(scout) and refuel. The turret cart engages the return-ride ambush
and the player visibly takes less damage than yesterday. First
"my loadout matters" moment.

Day 3. Workshop complete. Electric-fence cart blueprint drops at
the Stage reward. The base grid visibly fills. Stage 4 (Ironhill,
industrial) tease appears on the rail map.

Day 5. Ironhill expedition is brutal. Heavy hostiles, parts-rich
loot. The upgrade-card layer is tested — a "+50% damage to heavies"
card mid-expedition decides whether the player can clear. They
retreat with half the intended haul. Invest in the armed train
cart upgrade.

Day 7. Chapter 1 milestone-hub (Ironhill) cleared. The faction
storyline at the gang fort unfolds — a survivor's-kid quest line.
First emotional NPC story investment.

Day 10. Chapter 2 Stage 1 (St. Marian, hospital) attempted.
Infected hostiles introduce a new combat threat type and a new
upgrade-card meta — radiation resistance. The infirmary module
unlocks.

Day 14. Player has 8 survivors, 4 Stages cleared, train has 5 cars
including turret + electric fence + armed cart. Station has
visibly grown into a small settlement. The base map shows colored
zones — farm, workshop district, infirmary. Chapter 3 (Foxbridge
junction) appears on the rail map. The long-arc Capitol Ruin goal
becomes visible. The dominant return reasons stack: module build
timers, town-storyline quests, cart-loadout experimentation,
upgrade-card builds, and visible base growth between sessions.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a train-base + auto-roguelite on-foot expedition game.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Three candidate frames: (A) train ride mid-segment, side-on third-person, junction switch ahead, HUD with throttle/brake/scan. (B) on-foot scavenging in a ruined town, over-the-shoulder third-person, parked train visible in background as a safe-zone, container loot prompts visible, **upgrade-card pick overlay popping in at bottom**. (C) return-ride ambush, side-on third-person, **turret cart firing on bandits**, electric-fence arc visible. All must read as "running expeditions from a train base with roguelite picks" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. The home station at dusk, train rolling out, a survivor on the platform waving, **a faint silhouette of a turret cart bolted to the train**. Painterly, slightly desaturated, hopeful tone. |
| **Key UI frames** | TBD | (1) Rail network map showing chapters and stages, (2) Train drive HUD, (3) On-foot scavenge view, (4) **Upgrade-card pick screen (3-card layout) — the roguelite tentpole UI**, (5) Station base grid, (6) Survivor roster + skill assignment, (7) Train cart loadout (offensive / defensive / utility slots). |
| **App store icon** | TBD | 1024×1024. A train pulling out of a fortified station at dawn, **turret cart silhouette on the rear**, painterly tone. Tested for thumbnail readability at 88×88 — must read as "trains + survival" not "racing." |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: home station with 3 modules buildable, 1 train (with base car set + 1 unlockable turret cart), 1 destination (Greenfield = Chapter 1 — Stage 1), 1 on-foot zone with 3 buildings + light hostile spawn, 1 survivor rescue with skill unlock, 1 scripted return-ride ambush event, auto-combat default with manual-override tap, **upgrade-card pick system live (3-card pop on kill, ~3 picks per expedition)**. No Stage 2, no faction storylines. Must feel-representative on a real device — train-drive + on-foot transition + upgrade-card pick + return-ambush are the central pillars. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Five beats: first 30s train drive + junction switch, train-park → first step-off cinematic, first scavenge + auto-engaged hostile + **first upgrade-card pick (3-card overlay)**, first survivor rescue, return-ride ambush → turret cart engages → station arrival → module unlock. Each scored separately at Stage 4. |
