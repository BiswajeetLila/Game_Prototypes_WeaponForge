# Outbound (Persistent) — Concept Template v2

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
| Working title | Outbound (Persistent) |
| Genre / subgenre | One-thumb portrait driving + exploration with persistent (no-wipe) progression |
| Target audience | Casual / light-progression mobile players (12–45) who like open-world exploration, vehicle building, and survival-lite — and dislike the death-sting of roguelikes. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

You're a driver trapped in a sealed-off city. Each run, you leave your garage and push into the fog. Threats spawn, POIs hide upgrades, and you fight, loot, and explore. Unlike a roguelike, anything you pick up is yours forever. Run out of fuel or HP? Fire your recall flare. A courier brings you and your full inventory home for a small scrap-and-fuel fee. No death. No wipes. Difficulty comes from how deep you push, how heavy your loadout is, and how the city's threat level climbs over real-world time. The Inner Wall waits at the end.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Sealed garage gate at dusk. Voiceover: "The city's been quiet for ten years. Build a way out." Tap to start.
- **5–15s:** Car rolls into fogged street. Drag-to-steer tutorial.
- **15–25s:** First threat — a small patrol of feral cars. Auto-fire clears them. Pickups drop — parts and scrap.
- **25–40s:** First POI marker glows through fog. Player diverts. A small building has a workbench inside; a battering-ram ability sits inside. Player picks it up. Tooltip: "Recovered ability. Install at the workshop."
- **40–60s:** Player taps "Recall Flare." Tooltip: "Costs 8 scrap + 5 fuel." Player confirms. Helicopter pickup cinematic. **The "I get to keep everything I found" moment.**

---

## 5. Hypothesis of why this would work

Mad Max (open-world), Pacific Drive, and Forager all proved Western mobile/console players love vehicle-driven exploration with persistent base building. Mobile, however, has not had a winning entry in this lane. Subway Surfers and Asphalt 8 (career) prove that no-wipe progression with persistent garage works on phones at long-arc scale. The unmet combination is *open-world exploration + persistent vehicle build + survival-lite resource pressure*.

The bet is that the *recall flare + repair invoice* friction system is the right substitute for roguelike death. Players who *hated* the roguelike sibling's 30% inventory tax can keep playing the same fantasy without the sting; the game still has tension (fuel, weight, repair cost) without breaking the "I keep what I find" contract. The shipped reference is Subway Surfers — Sybo proved indefinite-replay no-wipe progression holds Western casual + mid-core for years. Our diff is the open-world fog reveal which gives the game a discovery layer Subway Surfers structurally lacks.

---

## 6. Risks

**Single fragile assumption:**

*The friction system (recall flare costs scrap + fuel; tow has a repair invoice; weight is capped per car build; district threat scales over real time) will provide enough tension to make decisions matter, WITHOUT crossing into "feels like roguelike-lite punishment."*

If the friction reads as punishment, players resent it; if it reads as too soft, the game has no decisions and exploration loses its weight. Stage 1 bundle: *"Pushing deeper feels like a real decision, but failing doesn't sting — it just costs me a little time and scrap."* Stage 4 (gameplay video) shows a clean recall flare moment to test that the framing reads as a feature, not a defeat.

---

## 7. Reference games

1. **Pacific Drive** — Ironwood, 2024, PC/console. Vehicle-driven exploration + persistent build + no roguelike wipes. We share the "your car is the build" pattern and persistent progression; we don't share the survival-sim depth — Outbound Persistent is more arcade.
2. **Mad Max (open-world)** — Avalanche, 2015, console. Open-world vehicle combat + persistent garage. We share the open-world car-build fantasy; we don't share the production scope — Outbound Persistent is mobile-first.
3. **Forager / Mini Motorways** — HopFrog / Dinosaur Polo Club. Slow no-wipe progression with persistent discovery. We share the no-wipe contract and discovery layer; we don't share the puzzle silhouette.

**Genre mashup formula:** Pacific Drive × Mad Max × Forager

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- Garage screen. Workshop install of the battering ram. Player slots it on the starter car's utility slot.
- First survivor rescue prep — the player can see a "rescue survivor" POI in the fog edge.
- Run 2 starts with the battering ram. Player rams through a garrisoned barricade and clears their first POI lieutenant. District threat tier drops visibly.
- First fuel-rod dropped from a district lieutenant. Anchor for tomorrow.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | Starter car, 2 abilities installed, 1 district half-revealed, 1 lieutenant cleared. | Old Town district unrevealed border + visible POI markers in the fog. |
| D3 | Old Town garrison cleared. 2 cars built. 4 abilities. First hidden bunker discovered. | Hidden bunker requires EMP ability. Targeted POI hunt anchors return. |
| D7 | Industrial threat tier-2 active. Recall flare costs becoming notable. | Better engine / fuel-range upgrade pulls; long-arc Inner Wall visible on map. |
| D14 | Highway Ring half-revealed. 4 cars, 6 abilities installed, 3 fuel rods banked. | Inner Wall escape attempt teased + post-credits Nightmare Mode hint. |

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~140 words)

```
You're a driver trapped in a sealed-off city. You leave your
garage in a car you built. The map is hidden under fog. You push
into it.

You drive with one thumb at the bottom of the screen. Auto-fire on
weapons. Auto-pickup on items. Threats spawn — patrol cars,
ferals, lieutenants guarding rare loot. You divert to POIs glowing
through the fog and loot them.

Everything you find is yours. No per-run wipes.

When your fuel or HP gets low, you tap the recall flare. A courier
helicopter picks you up for a small scrap + fuel fee. If your car
dies, it gets towed home with a small repair invoice. You don't
lose what you brought.

Difficulty is the city itself: distances are far, weight is
capped, and threat levels climb the more time you've spent in a
district. Six to twenty-minute trips.
```

#### Full description of core loop + 1 meta progression (Stage 1, optional for stage-based, ~170 words)

```
You're a driver trapped in a sealed-off city. You leave your
garage in a car you built. The map is hidden under fog. You push
into it.

You drive with one thumb at the bottom of the screen. Auto-fire on
weapons. Auto-pickup on items. Threats spawn — patrol cars,
ferals, lieutenants guarding rare loot. You divert to POIs glowing
through the fog and loot them.

Everything you find is yours. No per-run wipes.

When your fuel or HP gets low, you tap the recall flare. A courier
helicopter picks you up for a small scrap + fuel fee. If your car
dies, it gets towed home with a small repair invoice. You don't
lose what you brought.

Six to twenty-minute trips.

At the garage you sort parts and assemble new cars. Abilities you
recovered install onto cars at the workshop bench. Survivors join
the garage co-op and unlock new abilities. The city is sealed but
the map fills in permanently around you, and every garrisoned POI
you clear visibly burns on the map — your runs leave a record.
```

#### Store-page variant (Stage 1b optional, ~55 words)

```
You're trapped in a sealed-off city. Build a car. Drive into fog.
Fight, loot, explore. Everything you find is yours forever. Recall
home when you're low. No wipes, no roguelike sting. Build out a
fleet of cars, install abilities, rescue survivors, push toward
the Inner Wall. The city remembers your runs.
```

#### First 1–5 minutes the player experiences (~280 words)

```
Boot-up: studio logo, then a slow camera pan across a sealed
garage gate at dusk. A beat-up sedan idles inside. Voiceover:
"The city's been quiet for ten years. Build a way out." Tap to
start.

The gate opens. The car rolls into a fogged street. Tooltip:
"Drag to steer." Player drags. The car swerves around debris. The
HUD shows a small city map with the fog frontier visible.

A first threat — three feral cars circle in. Auto-fire clears
them. Parts drop. Player drives over them — auto-pickup adds them
to inventory.

A POI marker glows through the fog. Player diverts. A small
ruined workshop building. Player drives into the bay. A glowing
ability sits on a workbench — a battering ram attachment. Pickup
animation. The ability docks into the player's "abilities to
install" inventory.

The fuel meter on the HUD blinks yellow. Tooltip: "Hold the bottom
edge for 2 seconds to fire the recall flare." Player holds. A
confirmation animation. The flare deploys. A courier helicopter
descends. Cinematic of the car being lifted into the helicopter.
Tooltip: "Recall cost: 8 scrap, 5 fuel."

Garage screen opens. The workshop bench glows. Player taps it.
The battering ram is highlighted. Player drags it onto the starter
car's utility slot. The car visibly sprouts a heavy front prow.

The mini-map shows the now-revealed region permanently. A new POI
marker just past the revealed zone glows — a hidden bunker. A
tooltip flashes: "Hidden Bunker — requires Battering Ram or EMP."

Player taps "New Trip." The car heads back out, now with the
ram, and a new objective beckons.
```

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

```
Day 1. The player completes 2 trips, recalls once and tows once,
recovers 2 abilities (Battering Ram, Side Gun), reveals about a
quarter of Garage Quarter, and clears one lieutenant POI. The
hook for returning tomorrow is the visible fog frontier and the
hidden-bunker tease that requires their battering ram.

Day 2. Returning player heads back into the fog. The garrisoned
POI they cleared yesterday stays cleared — the threat tier of
that district is visibly lower. They push deeper into Old Town and
find another ability (Smoke Cloud). They install it. First "the
city's getting easier where I've been" moment.

Day 3. First hidden bunker opened with the battering ram. Rare
ability inside: a Repair Drone passive. The Drone changes the
recall economy — they no longer have to recall as soon as HP
drops. First "this ability changed how I play" moment.

Day 5. Docks district revealed. Smuggler-gang threats are
different from Old Town's. They build a second car (lighter,
faster). They start specializing — the starter car is the heavy
combat car, the new one is the explorer.

Day 7. Industrial wall. The heavy threats tear through the
explorer car. Player switches to combat car for industrial runs.
First "I'm picking the right car for the right job" moment.
Recall costs at this distance are notable now (40 scrap + 30
fuel) — players start optimizing trip planning.

Day 10. First fuel-rod recovered from a lieutenant. Hard currency.
Tier-3 upgrades unlock at the workshop.

Day 14. Highway Ring half-revealed. Player has 4 cars, 6
abilities installed across them, 3 fuel-rods banked, and 8
survivors at the garage. The Inner Wall escape attempt is visible
on the city map — the final push needs 5 fuel rods total. The
dominant return reasons stack: hidden-bunker chase, lieutenant
clears, fuel-rod grind, and the city's visible record of all the
player's prior runs (burning garrisons, paved-over rubble, opened
bunker doors).
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a no-wipe vehicle-exploration game.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Single static frame mid-trip: player car in lower-third, top-down or angled-3rd-person camera, fog peeling back, POI marker glowing in the distance, HUD with fuel/HP/scrap, recall-flare prompt. Must read as "I'm exploring at my own pace, no run-timer" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. Player car parked in front of a hidden bunker, opening it. The city visibly burning behind from prior clears — "your runs leave a record" is the marketing pitch. |
| **Key UI frames** | TBD | (1) Trip HUD, (2) Recall flare cinematic, (3) Garage with car build menu, (4) Workshop bench for ability install, (5) Permanent city fog-map with cleared garrisons highlighted, (6) Survivor roster + base assignment. |
| **App store icon** | TBD | 1024×1024. Player car silhouette in front of a fog-shrouded city, headlights cutting forward. Tested for thumbnail readability at 88×88. |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: one car, one district (Garage Quarter), fog reveal with permanent memory, 5 abilities recoverable, 1 lieutenant POI, recall flare + tow mechanics. Garage workshop bench with ability install. No second district, no hidden bunker, no second car. Must feel-representative on a real device — the no-wipe contract and the recall-flare cadence are the central pillars. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 30s drive-into-fog read, first ability recovery + workshop install, first lieutenant clear (district threat drops), first recall flare → garage transition. Each scored separately at Stage 4. |
