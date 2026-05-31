# Black Tide (Sandbox) — Concept Template v2

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
| Working title | Black Tide (Sandbox) |
| Genre / subgenre | Open-sea pirate ship sandbox with base building + fleet collection |
| Target audience | Mid-core mobile players (12–45) who want open-world pirate fantasy and a persistent fleet to grow — Sea of Thieves / Black Flag fans on phones. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

You're a pirate captain with one ship, a hidden cove base, and an ocean to plunder. You sail out from the cove, spot a target on the horizon — a merchant convoy, a navy patrol, a wreck — and fight, board, and loot. You bring the haul back home. At the cove you upgrade your ship: bigger cannons, better hull, deeper hold. You recruit named pirates at the tavern; each crew member's skill boosts a role on the ship. Eventually you commission bigger ships and command a small fleet. No runs, no resets — every sortie advances the empire.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Tropical cove at sunset. A small sloop is moored. Dying mentor voiceover: "This cove is yours. Find the rest." Tap to start.
- **5–15s:** Sloop sails out. Drag-to-steer tutorial. Player swerves around a reef.
- **15–25s:** First sail-on-the-horizon — a merchant brig. Player drags rudder to angle the broadside.
- **25–40s:** First cannon volley. Tap to fire. The merchant takes a hull hit. Numbers pop.
- **40–60s:** The merchant cripples. A boarding prompt appears. Player taps. Boarding auto-resolves with a brief tap-timing window. Loot screen: gold, wood, rum. **The "this is *my* ship and *my* cove" moment.**

---

## 5. Hypothesis of why this would work

Pirate fantasy is famously under-served on mobile. Skull and Bones whiffed at console scale; Sea of Thieves is console/PC-locked; Sid Meier's Pirates has nostalgia but no modern mobile heir. Meanwhile Stardew Valley mobile and Animal Crossing: Pocket Camp have proven that sandbox progression with a base + persistent identity holds Western mid-core players for years on phones.

The bet is that the *base + named crew + visible fleet growth* loop is the right mobile sandbox shape. Players get the open-world feel of sailing, the build-identity of a customizable ship, and the AFK-collector pull of named crew with skill tags. The shipped reference is Pocket Camp / Stardew — proving sandbox base growth holds attention on phones. Our diff is the ship-combat moment-to-moment which gives sessions a tighter dopamine curve than pure cozy sims. The long-arc Admiral goal (commanding a fleet of NPC ships) gives this a power-fantasy ceiling that cozy-only games lack.

---

## 6. Risks

**Single fragile assumption:**

*Mid-core mobile players will tolerate the longer 8–25 minute session length AND the no-run-wipe structure as a deliberate *commitment* pattern rather than as a "doesn't respect my time" anti-pattern.*

If sessions read as too long for the slot players actually have, they bounce after one sortie. If the no-wipe structure reads as "the game has no end," some players churn for lack of clear short-term goals. Stage 1 bundle: *"Each sortie advances something specific I'm working toward, and I can stop after any sortie without losing progress."* Stage 4 (gameplay video) shows the sortie → cove transition explicitly.

---

## 7. Reference games

1. **Sid Meier's Pirates! / Assassin's Creed Black Flag** — Firaxis / Ubisoft. Pirate-ship combat lineage with persistent captain progression. We share the broadside-and-boarding combat fantasy and the captain-empire arc; we don't share the open-world freedom — Black Tide Sandbox is region-gated.
2. **Stardew Valley** — ConcernedApe, 2016, multi-platform. Cozy sandbox with persistent base and no per-run wipe. We share the persistent-progression structure and named NPC crew pattern; we don't share the farm-sim.
3. **Skull and Bones (as cautionary reference)** — Ubisoft. Pirate-ship combat done at console scale. We share the broadside combat ambition; we don't share the production scope — Black Tide Sandbox is mobile-first and asset-light.

**Genre mashup formula:** Pirates! × Stardew Valley × Sea of Thieves (lite)

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- First return to cove. Gold and parts unloaded.
- Cove screen with a base build grid. Tooltip highlights the shipyard module. Player builds the shipyard.
- First tavern recruit unlocked — a navigator named Doña.
- Second sortie. Player goes for a slightly bigger target. Spots a small navy patrol. First "real ship combat" engagement.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | Sloop, cove with 2 modules, 1 named crew, ~80 gold banked. | Tavern shows 3 more recruits to unlock. |
| D3 | Brigantine hull commissioned. 4 named crew. Spice Coast region unlocked. | First reputation faction (Spice Coast merchants) unlocks contracts. |
| D7 | Stormbreak Reefs hazards encountered. First wreck dive completed. | Faction contracts gate a unique rare flag. |
| D14 | First Imperial Lane navy patrol encountered. Fleet command teased. | Long-arc Admiral goal visible; first NPC-controlled escort ship hireable. |

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~135 words)

```
You're a pirate captain. You sail your ship out of a hidden cove
into open water. You spot a target on the horizon — a merchant
convoy, a navy patrol, a wreck-dive site. You sail toward it.

You steer with one thumb at the bottom of the screen. Drag
horizontally to turn the rudder, drag vertically for sail speed.
Cannons auto-elevate to range; you tap to fire your broadside.

When an enemy ship is crippled you can board. Boarding plays a
brief auto-resolved mini-game with a tap-timing window. Loot drops
onto your deck.

You sail back to the cove and unload — gold, wood, iron, sailcloth,
rum, exotic goods.

There are no runs. Each sortie lasts eight to twenty-five minutes
and ends when you choose to head home. Everything you earn stays.
```

#### Full description of core loop + 1 meta progression (Stage 1, genre-required, ~170 words)

```
You're a pirate captain. You sail your ship out of a hidden cove
into open water. You spot a target on the horizon — a merchant
convoy, a navy patrol, a wreck-dive site. You sail toward it.

You steer with one thumb at the bottom of the screen. Drag
horizontally to turn the rudder, drag vertically for sail speed.
Cannons auto-elevate to range; you tap to fire your broadside.

When an enemy ship is crippled you can board. Boarding plays a
brief auto-resolved mini-game with a tap-timing window. Loot drops
onto your deck.

You sail back to the cove and unload.

There are no runs. Each sortie lasts eight to twenty-five minutes
and ends when you choose to head home. Everything you earn stays.

At the cove, you upgrade your ship at the drydock — bigger cannons,
better hull plating, deeper hold, more sails. You recruit named
pirates at the tavern; each crew member's skill boosts a role on
the ship. Over time you commission bigger ships — sloop, brig,
frigate, galleon — and eventually command a small fleet of
NPC-controlled escorts in formation.
```

#### Store-page variant (Stage 1b optional, ~55 words)

```
Captain a pirate ship in an open sea. Hunt merchants, board them,
plunder. Return to your hidden cove. Upgrade your ship. Recruit
named pirates. Build a fleet. Become an Admiral. No runs, no
resets — every sortie grows the empire. Sail under your own flag,
forever.
```

#### First 1–5 minutes the player experiences (~280 words)

```
Boot-up: studio logo, then a tropical cove at sunset. A small sloop
is moored at a wooden dock. A grizzled mentor sits on a barrel.
He coughs once, points at the sloop: "This cove is yours, now.
Find the rest of them." Tap to start.

The sloop sails out. Tooltip: "Drag to steer." Player drags. The
sloop swerves around a reef break. The HUD shows a small region
map with the cove marked.

A sail glints on the horizon — a fat merchant brig. Player closes
the distance. Tooltip: "Aim the broadside, then tap to fire."
Player drags the rudder until the side faces the brig. Tap. Two
cannons boom. The brig takes a hull hit; damage number pops.

The brig fires back. A small hull-damage indicator on the player's
ship. Player adjusts. Three more broadsides. The brig's mast
cracks and the ship lists.

Boarding prompt. Player taps. A brief animation: the sloop pulls
alongside, grappling hooks fly, pirates swarm aboard. A short tap-
timing mini-game (skill check against crew tags). Player wins.
Loot screen: 60 gold, 4 wood, 2 rum, 1 exotic-spices bottle.

Player heads back to the cove. The sloop pulls into the dock. Loot
unloads visibly into crates on shore. Cove screen opens. A "build"
icon flashes on the empty plot next to the dock. Tooltip: "Build a
shipyard." Player taps. The shipyard begins construction — 2
minutes real-time.

A tavern icon glows on the cove screen. Player taps. A list of 3
potential crew recruits. Doña the navigator is highlighted. Player
recruits her for 30 gold. Doña's portrait pops into the ship's
crew roster.

Second sortie loads.
```

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

```
Day 1. The player completes 2 sorties, banks ~150 gold, builds the
shipyard, recruits 1 named crew (Doña the navigator), and unlocks
the drydock for ship upgrades. The hook for returning tomorrow is
the visible cove plot grid — they can see 6 more buildings to
construct.

Day 2. Returning player upgrades the sloop's cannons at the
drydock. They sortie into the Home Waters again with a measurably
stronger ship. They take down their first navy patrol. They notice
the reputation system unlocking — the Spice Coast merchants now
mark them as "neutral."

Day 3. Spice Coast region unlocks via the mapmaker building.
Player sorties there. Richer merchant convoys, but escorted by
sloops. First contested combat. They board a fat trade galleon and
score their first "big haul" (~300 gold).

Day 5. Brigantine hull commissioned at the shipyard. 30-minute
real-time construction. Player check-ins to wait. First "the cove
is a base I'm building" moment lands hard.

Day 7. Stormbreak Reefs unlocked. Weather and reef hazards make
sortie planning harder. Player attempts a wreck-dive POI for the
first time — a small puzzle vignette that grants exotic spice loot.

Day 10. First Imperial Lane patrol encountered. Navy frigates are
genuinely dangerous. Player retreats. Returns with a stronger crew
loadout. Beats one. Gets a rare gold-laced flag drop.

Day 14. Player has 2 ships at cove (the upgraded sloop and a
freshly built brigantine), 8 named crew, 4 regions unlocked, and
the cove visibly bustling — buildings, named NPCs walking
between them, smoke from the foundry. The long-arc Admiral goal
appears as a quest line: "Commission your first NPC-controlled
escort ship." The dominant return reasons stack: cove build
queues, faction contracts, the rare-flag chase, and the slow climb
toward fleet command. Sessions naturally stretch to 15–20 minutes
as players juggle multiple parallel goals.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for an open-sea pirate sandbox.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Two candidate frames: (A) ship combat mid-broadside, player ship on lower half, enemy brig framed against painterly sea, cannon fire, HUD with crew tags and hull state. (B) cove base view with shipyard, drydock, tavern, named NPCs walking. Both must read as "I'm a pirate captain with a base" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. Player ship under full sail at sunset, flags flying, a fat merchant on the horizon. Painterly stylized 3D, swashbuckling tone. |
| **Key UI frames** | TBD | (1) Open-sea sailing HUD, (2) Combat broadside view, (3) Cove base build grid, (4) Drydock ship outfitting screen, (5) Tavern crew recruitment, (6) Region map / mapmaker. |
| **App store icon** | TBD | 1024×1024. A single pirate ship under sail, dramatic three-quarter angle, sunset palette. Tested for thumbnail readability at 88×88. |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: one ship (sloop), one region (Home Waters), 5 enemy ship types (merchant, navy patrol, wreck site, smuggler, mini-flagship), boarding mini-game, cove base with shipyard + tavern + drydock. No second region, no second ship hull. Must feel-representative on a real device — sail-and-broadside is the central pillar. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 30s sail + spotting a target, first broadside engagement, first boarding mini-game, first return-to-cove → build/recruit transition. Each scored separately at Stage 4. |
