# Outbound (Roguelike) — Concept Template v2

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
| Working title | Outbound (Roguelike) |
| Genre / subgenre | One-thumb portrait driving + exploration roguelike with fog-reveal |
| Target audience | Mid-core mobile players (14–40) who love Vampire Survivors + Don't Starve + Forager-style discovery loops and want to slowly reveal a sealed-city map over many runs. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

You're a driver trapped in a sealed-off city. Each run, you leave your garage in a hand-built car and push into the fog. Threats spawn, POIs hide in unrevealed districts, and a level-up meter fills as you fight. Every level you pick an ability card. Stack them into a build. Push as far as fuel lets you. Die and a courier picks you up — you keep some of your loot and the map you uncovered stays revealed forever. Back at the garage you assemble new cars from recovered parts and recruit survivors who unlock new cards.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Sealed garage gate at dusk. Voiceover: "The city's been quiet for ten years. Find a way out." Tap to start.
- **5–15s:** Car rolls forward into a fogged street. Drag-to-steer tutorial. Player swerves around debris.
- **15–25s:** First threat — a small patrol of feral cars. Auto-fire weapon clears them. XP gems drop. Player drives over them.
- **25–40s:** Level up. Three cards: "+15% fire rate," "Side gun," "Repair-on-kill." Player picks side gun.
- **40–60s:** Player spots a glowing POI marker through the fog — a survivor pod. Player diverts. **The "the fog is hiding things and I have to push deeper" moment.**

---

## 5. Hypothesis of why this would work

Vampire Survivors / Brotato proved Western mid-core mobile will eat roguelike build-stacking, but neither of those games has a fog-of-war discovery layer. Don't Starve and Forager proved the discovery-loop meta works on phones at length, but neither has the per-run draft stack. Mini Motorways and Subnautica's early-game both prove fog-reveal-on-discovery is satisfying. The unmet combination is roguelike per-run build + permanent fog reveal + driving silhouette.

The bet is that *permanent map memory* is the sticky meta layer. Where Vampire Survivors retention comes purely from per-run dopamine and the meta-stat tree, Outbound layers a "I am uncovering my city" overlay on top — every run permanently widens the player's known world. The shipped reference is Death Road to Canada — Rocketcat proved per-run randomized arcade-driving + persistent meta + a thematic world works mobile. Our diff is the permanent-fog-reveal and the survivor-driven card unlock layer that DRtC lacks.

---

## 6. Risks

**Single fragile assumption:**

*Players will accept the per-run loss of ability cards as "the run resetting" rather than as "the game taking my upgrades." The death-tax (~30% of inventory lost on death) has to land as tolerable, not as a punishment that breaks the contract.*

If the death-tax reads as punitive, Western roguelike players churn — they're used to "everything keeps you something." Stage 1 bundle: *"Death feels like the run ending, not like the game stealing my stuff."* Stage 4 (gameplay video) tests this with a clear death → extract → garage flow that highlights what's kept (map data, survivors) versus what's lost (the 30% inventory tax).

---

## 7. Reference games

1. **Vampire Survivors (mobile)** — poncle, 2022. Run-based + draft-stack + permanent meta. We share the per-level card pick and run-length pattern; we don't share top-down arena — Outbound is driving in a city.
2. **Don't Starve / Forager** — Klei / HopFrog. Fog-of-war discovery + base building + survival meta. We share the permanent-map-reveal pattern and the base-loop; we don't share the survival-sim mechanic.
3. **Death Road to Canada** — Rocketcat, 2017, mobile. Per-run randomized driving + persistent unlocks. We share the run-and-meta + thematic-world pattern; we don't share the party-management mechanic — Outbound is single-driver.

**Genre mashup formula:** Vampire Survivors × Don't Starve × Death Road to Canada

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- Run 1 ends at minute 7 to fuel-out. Auto-extract: courier picks up driver, 70% of inventory kept, map data committed.
- Garage screen. Player sorts recovered parts. Assembles a slightly better car (replacement engine).
- First survivor rescued (a mechanic). New ability card unlocks in the run pool.
- Run 2 starts. The starting district's fog is now permanently revealed; the player can see a new POI marker farther in.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | Starter car, 1 survivor, 1 district mostly revealed, 8 cards in run pool. | The Old Town district visible at the fog edge. |
| D3 | Old Town partially revealed. 2nd car built. 3 survivors. 15 cards in pool. | Docks district teased + first mini-boss encounter. |
| D7 | Industrial district wall. Player can't sustain the heavy threats yet. | Targeted survivor rescue + part-grinding. |
| D14 | Highway Ring half-revealed. Player has 4 cars, 8 survivors, 30+ cards. | The Inner Wall escape attempt teased + Nightmare Mode post-credit content. |

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~135 words)

```
You're a driver trapped in a sealed-off city. You leave your garage
in one car with one fuel tank. The map is hidden under fog.

You drive into the fog with one thumb at the bottom of the screen,
dragging side to side to steer. Your weapons fire on their own.
Threats spawn — patrol cars, ferals, mini-bosses guarding rare
parts. XP gems drop. You drive over them.

Every level, three ability cards appear: bigger guns, fire ramming,
repair-on-kill, shield. You pick one. The card equips for the rest
of the run.

You push as far as fuel allows. Die or fuel-out and a courier
picks you up. You keep about seventy percent of your loot. The
map you uncovered stays uncovered.

A run is five to twelve minutes. The city is enormous.
```

#### Full description of core loop + 1 meta progression (Stage 1, genre-required, ~170 words)

```
You're a driver trapped in a sealed-off city. You leave your garage
in one car with one fuel tank. The map is hidden under fog.

You drive into the fog with one thumb at the bottom of the screen,
dragging side to side to steer. Your weapons fire on their own.
Threats spawn — patrol cars, ferals, mini-bosses guarding rare
parts. XP gems drop. You drive over them.

Every level, three ability cards appear: bigger guns, fire ramming,
repair-on-kill, shield. You pick one. The card equips for the rest
of the run.

You push as far as fuel allows. Die or fuel-out and a courier picks
you up. You keep about seventy percent of your loot. The map you
uncovered stays uncovered.

A run is five to twelve minutes.

Back at the garage, you sort what you brought home. Car parts
assemble into bigger, better cars. Survivors you rescue join the
garage co-op and unlock new ability cards in the run pool. Each
run you reveal a little more of the city; each run a little more
of it stays known.
```

#### Store-page variant (Stage 1b optional, ~55 words)

```
You're trapped in a sealed-off city. Build a car. Drive into the
fog. Fight, loot, level up, stack ability cards. Die or run out of
fuel and a courier brings you back. Keep the loot. Keep the map.
Rebuild at the garage. Push deeper next run. The Inner Wall is
waiting.
```

#### First 1–5 minutes the player experiences (~280 words)

```
Boot-up: studio logo, then a slow camera pan across a sealed garage
gate at dusk. A beat-up sedan idles inside, headlights cutting
through fog. Voiceover: "The city's been quiet for ten years. Find
a way out." Tap to start.

The gate opens. The car rolls forward. Tooltip: "Drag to steer."
Player drags. The car swerves around debris on a fog-thick street.
A first threat appears: three feral cars circle in. Auto-fire
clears them. XP gems pop. The player drives over them.

Level up. Three cards: "+15% fire rate," "Side gun," "Repair-on-
kill." Tooltip highlights the side gun. Player taps. A small
turret extrudes from the right side of the car.

Mid-run, a survivor pod glows through the fog. Player diverts. A
short fight clears the surrounding threats. They open the pod: a
mechanic named Reyes joins. Auto-pickup vacuum sucks the survivor
into a "secured" slot in the inventory.

At minute 6, fuel runs low. The player's HUD blinks red. They turn
to extract via a flare. The flare deploys. A courier helicopter
descends. A short animation: the driver climbs in. 70% of
inventory is highlighted as "kept," 30% as "lost." Garage screen
opens.

Reyes is at the workbench. Her mechanic skill unlocks a new card
("Engine boost") into the run pool. The fog map shows a small
visible-now region. The player sees a glowing POI a little farther
in — a hospital — that wasn't visible before.

Player taps "New Run." The car heads back into the fog. The same
gate, a different push.
```

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

```
Day 1. The player completes 2–3 runs, dies twice, rescues 1
survivor, reveals about a quarter of the starter district. They've
drafted across 10+ cards and they've assembled a slightly
upgraded starter car from recovered parts. The hook for returning
tomorrow is the visible fog frontier — they can see the boundary
of Old Town district glowing just past the revealed zone.

Day 2. Returning player pushes into Old Town. The tight alley
combat is different from Garage Quarter — they have to adapt their
card preferences. First "I want to build for alley combat" moment.
They rescue a second survivor and unlock the EMP card.

Day 3. Old Town mostly revealed. First mini-boss encounter at a
hospital POI. The mini-boss drops a rare frame part. The player
assembles their second car (lighter, faster).

Day 5. Docks district revealed. Smuggler gangs introduced — a new
threat class. The player's preferred build is starting to crystallize
(fire-themed, ram-focused). First "this is *my* build" moment.

Day 7. Industrial district wall. The heavy enemies tear the
player's runs apart in minutes. They focus on grinding parts from
Docks for armor upgrades. The grind feels tolerable because each
run is 5–8 minutes and they net forward progress.

Day 10. First fuel-rod dropped from an Industrial mini-boss. Hard
currency. The player banks it toward the eventual escape attempt.
The city threat-pulse mechanic kicks in — they notice some
districts are "heating up" while they push others.

Day 14. Highway Ring half-revealed. Player has 4 cars, 8
survivors, 30+ cards in the pool, and 3 fuel rods banked. The
Inner Wall escape attempt is visible on the city map as a
late-game POI — they can see how far they need to push but it's
still gated behind 5 more fuel rods. The dominant return reason is
the city map itself: the fog frontier is loud, and every run
peels back a little more of it.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a roguelike driving-exploration game.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Single static frame mid-run: player car in lower-third, top-down or angled-3rd-person camera, fog peeling back around the car, threat indicators visible, level-up meter and HUD strip, mini-map showing revealed-vs-unrevealed regions. Must read as "I'm driving into a fog-hidden city" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. Player car silhouette mid-drive, fog and ruined city around, a glowing survivor pod in the distance, district color-zoning visible (warm garage / sickly green industrial). |
| **Key UI frames** | TBD | (1) Gameplay HUD mid-run, (2) Level-up card draft, (3) Auto-extract / courier-pickup screen, (4) Garage / car builder, (5) Survivor roster + skills, (6) City fog-map overview. |
| **App store icon** | TBD | 1024×1024. Player car at angle, headlights cutting through fog, district silhouette behind. Tested for thumbnail readability at 88×88. |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: one car, one district (Garage Quarter), fog reveal + permanent-map memory, 8 ability cards, 1 survivor rescue, auto-extract flare. Garage screen with car-part assembly. No second district, no second car, no Inner Wall. Must feel-representative on a real device — the drive-into-fog + permanent-map pattern is the entire pitch. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 30s drive-into-fog read, first level-up card pick, first survivor pod rescue, first auto-extract → garage transition. Each scored separately at Stage 4. |
