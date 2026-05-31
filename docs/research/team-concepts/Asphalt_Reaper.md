# Asphalt Reaper — Concept Template v2

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
| Working title | Asphalt Reaper |
| Genre / subgenre | One-thumb portrait driving combat roguelike |
| Target audience | Western mid-core players (16–35) who graduated from Vampire Survivors / Brotato and want an arcade-driving wrapper around the per-wave draft-stack loop. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

You drive one beat-up car forward down a hostile road. Traffic, zombies, gun-trucks, and ramming bikers come at you in waves and you steer with one thumb to dodge or ram them. Your mounted weapons auto-fire on cooldown. Every few seconds a wave clears, a level-up meter fills, and the game pauses so you can pick one of three ability cards — bigger guns, fire ramming, oil slicks behind you. Stack the right cards and a normal run turns into a screen-clearing firestorm. You die a lot, but each run banks scrap you spend on a permanent garage.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** A beat-up sedan sits at a roadblock. "Hold the lane. Survive the highway." Tap to start.
- **5–15s:** The car rolls forward automatically. First lane-bias drag tutorial: a tooltip arrow says "drag to steer." Player swerves around two stalled cars.
- **15–25s:** A small pack of zombies pour onto the road. The mounted weapon auto-fires. Numbers pop. Player rams two for bonus scrap.
- **25–40s:** Level-up modal. Three cards visible: "+15% fire rate," "Flame ramming," "Side gun." Player picks one. Card snaps onto the car and the chosen effect is visibly on the vehicle.
- **40–60s:** Wave 2 escalates. A gun-truck spawns behind. The picked card visibly mattering — the second mini-wave clears in three seconds. **The "I want to stack this card again" moment.**

---

## 5. Hypothesis of why this would work

Western mobile players who like Vampire Survivors and Brotato have proven they want the per-wave draft-stack loop on the phone — short sessions, snowballing builds, a death that resets but is never "punishing." What they don't currently have is a driving game that delivers the exact same pleasure curve. Crashlands / Earn to Die / Road Rash hit nostalgia for vehicular arcade combat but none of them carry the Survivors-genre draft mechanic. The bet is that one-thumb portrait driving + auto-fire weapons + per-wave card pick is the unmet combination.

The shipped reference that validates the pattern is Archero — Habby proved Western mid-core will accept a fixed-control action-defense template with skill drafts. Asphalt Reaper's diff is replacing the top-down arena with a forward-scrolling road, which is a more immediately readable "I am playing a game about driving" silhouette than top-down. The hypothesis is that the driving silhouette earns clicks at the icon level (a thing top-down Survivors clones consistently fail at) while the draft loop earns retention once installed.

---

## 6. Risks

**Single fragile assumption:**

*Western mid-core players will accept one-thumb portrait driving as a real combat input — that a steer-only lane-bias gesture feels expressive enough to carry 5+ minute runs of escalating threat without players wanting full vehicle control.*

If the steering reads as "too simple" the entire driving fantasy collapses into "the game is on rails." Stage 1 bundle: *"One-thumb steering feels like driving, not like an idle game on wheels."* Stage 4 (gameplay video) re-tests this with motion — the swerves around traffic have to read as the player choosing them.

---

## 7. Reference games

1. **Archero** — Habby, 2019, mobile. Action-defense template, skill-draft per floor, fixed control surface. We share the per-wave draft loop and the one-handed input contract; we don't share the top-down arena — Asphalt Reaper is forward-scrolling.
2. **Vampire Survivors (mobile)** — poncle, 2022. Skill-draft roguelite with auto-attack. We share the auto-fire + level-up card pick + run-length pattern; we don't share the static character — the player is steering a car.
3. **Earn to Die / Road Rash** — Not Doppler / Electronic Arts. Vehicular-arcade-combat lineage. We share the road-combat fantasy and ram-physics tone; we don't share the level-by-level structure — Asphalt Reaper is roguelike.

**Genre mashup formula:** Vampire Survivors × Archero × Earn to Die

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- Run 1 ends at ~wave 9 on a mini-boss convoy. Defeat screen: "You earned 280 scrap. Spend it in the garage."
- First stat-tree screen. Player upgrades the Engine node (+5% top speed). Visible tooltip.
- First Card Library unlock: "Spread shot" added to the run pool. Anchors a return reason.
- Run 2 starts. Same biome, but the spread shot is in the draft pool now. Player notices the new option in the level-up modal.
- Mid-run radio chatter introduces the Mechanic survivor — first "this run had a story beat" moment.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | Starter car, 1–2 stat tree nodes, ~3 unlocked cards. First mini-boss fought. | "I almost made it to Biome 2." Card library is visibly bigger than current draft pool. |
| D3 | Biome 2 reached. Second car unlocked at the garage. 4–5 stat nodes per tree. | First survivor (Mechanic) rescued — Engine tree gets a new tier. |
| D7 | Biome 3 wall. Current build can't survive the Industrial choke points. | Targeted card unlocks + Armor stat-tree push. |
| D14 | First Wasteland clear, weekly modifier challenges unlocked. | Daily run challenge w/ rotating modifier + leaderboard. |

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~135 words)

```
You drive a beat-up car forward down a hostile road in portrait
view. You hold one thumb at the bottom of the screen and drag side
to side to pick a lane. Traffic, zombies, gun-trucks, and ramming
bikers come at you in waves. Your mounted weapons fire automatically
on cooldown.

Every time you clear enough enemies, a level-up meter fills and the
game pauses. Three ability cards appear — bigger guns, side-mounted
weapons, fire ramming, oil slicks, shields. You pick one. The card
snaps onto your car and the effect is visibly on the vehicle.

A run lasts about three to seven minutes. Every ninety seconds a
mini-boss convoy shows up. The run ends when your car dies. You'll
die a lot, but it usually feels like the road killed you, not the
game.
```

#### Full description of core loop + 1 meta progression (Stage 1, genre-required, ~170 words)

```
You drive a beat-up car forward down a hostile road in portrait
view. You hold one thumb at the bottom of the screen and drag side
to side to pick a lane. Traffic, zombies, gun-trucks, and ramming
bikers come at you in waves. Your mounted weapons fire automatically
on cooldown.

Every time you clear enough enemies, a level-up meter fills and the
game pauses. Three ability cards appear — bigger guns, side-mounted
weapons, fire ramming, oil slicks, shields. You pick one. The card
snaps onto your car and the effect is visibly on the vehicle.

A run lasts about three to seven minutes. Every ninety seconds a
mini-boss convoy shows up. The run ends when your car dies.

Between runs you bring back scrap from the run. You spend it at a
fortified rest stop on permanent upgrades for four crew members —
engine, armor, weapon, ECU — and you unlock new cars and new
ability cards that show up in future runs. Every run you die a
little less.
```

#### Store-page variant (Stage 1b optional, ~55 words)

```
Drive one car forward through hostile traffic, zombies, and gun-
trucks. Steer with one thumb. Your weapons fire by themselves. Every
wave you pick a new ability card and stack them into a screen-
clearing build. Die. Bring scrap home. Upgrade your garage. Push
further next run. Three to seven minutes a run. One thumb, full
mayhem.
```

#### First 1–5 minutes the player experiences (~280 words)

```
Boot-up: studio logo, then a slow camera pan across a fortified rest
stop at dusk. A beat-up sedan rolls out of the garage gate. Text
fades in: "Hold the lane. Survive the highway."

Tutorial wave 1 begins immediately, no menus. The car rolls forward
automatically. A tooltip arrow points at the bottom of the screen:
"Drag to steer." Player drags. The car swerves around two stalled
cars. A small pack of suburb zombies pour onto the road from the
shoulder. The mounted front gun auto-fires. Damage numbers pop.

Wave 1 clears in ten seconds. A draft modal appears, dimming the
road. Three cards: "+15% fire rate," "Flame ramming," "Side gun."
A tooltip highlights the side gun. Player taps it. The card flips,
snaps onto the right side of the car, and a stubby gun barrel
extrudes visibly.

Wave 2: the side gun fires at a biker pack on the shoulder. Player
sees the choice mattering. Wave clears in six seconds. Draft again.
No tooltip this time. Player picks freely.

Wave 4: a gun-truck spawns behind, firing forward. Player swerves
out of the line of fire while their guns continue auto-firing. The
mini-boss convoy appears — three armored cars in formation. Player's
flame ramming card hits the lead car. The convoy breaks apart.

By wave 8, the player has drafted six cards, killed a mini-boss,
and watched the suburb biome give way to the highway biome. The car
takes a hit too many at wave 11. Defeat screen: "You held to wave
11. You earned 280 scrap." The garage screen opens. Four stat trees
are visible. The player spends. The first node lights up. They tap
"Try Again" and the next run starts with a measurably faster
engine.
```

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

```
Day 1. The player finishes their first session having played 3–4
runs, cleared up to wave 11 once, and bought their first two stat-
tree nodes. They've drafted across two biomes and they've seen the
Card Library glow on the home screen showing 20-plus locked cards.
The hook for returning tomorrow is the visible card pool — they've
seen four cards in four runs and they can see they've barely
scratched the deck.

Day 2. Returning player sees a "daily run" modifier — today's run
spawns extra bikers, extra scrap. Player runs it twice. They unlock
the Spread Shot card. Their next run is the first time they feel a
real "build" — front gun + spread shot + side gun stacks into a
proper cone of fire. End of day: 5 cards unlocked, two stat trees
opened.

Day 3. The first survivor (Mechanic) rescues at the rest stop. The
Engine tree gets a second tier. The player notices the rest stop is
visibly bigger — the Mechanic's caravan is now parked next to the
fuel pump. First "this game has a base" moment.

Day 7. The Industrial biome wall. The choke points and exploding
barrels punish the player's current build. They go back to the
Wasteland to grind a few easy runs and unlock the Armor card line.
First "I need to grind a specific upgrade" moment, but it lands
positive because the runs themselves are still 5 minutes each.

Day 14. The City Ruins biome unlocks. Final-boss convoy attempted
for the first time. Daily challenge has rotated to "starting car
only" — a constraint mode that anchors a return reason. The player
has 4 of 4 trees unlocked, 12 cards in the pool, and 3 cars in the
garage. The Card Library is now the dominant home-screen
preoccupation — they can see the synergy tags on cards they haven't
unlocked and they're targeting the rare-tier slots.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a roguelike action-driver.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Single static frame mid-wave: car in lower-third, mounted weapons firing, suburb biome around, 4–6 visible enemies (zombies, biker, gun-truck), HUD with HP/fuel/level meter, draft-pending indicator. Must read as "drive forward, fight, level up" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. The beat-up car mid-broadside slide, fire trailing, a horde of zombies and a gun-truck closing in. Post-collapse highway tone, gritty but arcade-saturated. |
| **Key UI frames** | TBD | (1) Gameplay HUD mid-wave, (2) Level-up draft modal with 3 cards, (3) Garage / stat tree screen, (4) Car select / build, (5) Card library, (6) Run summary / defeat screen. |
| **App store icon** | TBD | 1024×1024. Front-three-quarter beat-up car, mounted gun and chrome details, mid-impact frame. Tested for thumbnail readability at 88×88 — must read as "driving game" not "shooter." |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: one biome (Suburbs), 1 starter car, 15 ability cards, 1 mini-boss every 90s, full draft loop, banked-scrap to one stat tree. No second car, no meta-survivors, no monetization. Must feel-representative on a real device — the one-thumb steering is the entire core loop. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 30s tutorial read (steering + auto-fire), first draft pick moment, first mini-boss convoy fight, first defeat → garage transition. Each scored separately at Stage 4. |
