# Driftcrew — Concept Template v2

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
| Working title | Driftcrew |
| Genre / subgenre | Cozy single-ship pirate collector with asynchronous ghost-crew social layer |
| Target audience | Cozy + collection-driven players (8–45) who love Animal Crossing, Cozy Grove, Spiritfarer, and Sky: Children of the Light. Family-friendly. No PvP. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

You captain one beloved galleon, The Biscuit, and an ever-growing crew of 84 chibi pirates. You sail cozy seas, rescue dinghies, deliver mail, shoo barnacle-pest squids with your biscuit-cannons. Each voyage is short — five to fifteen minutes. You rotate your crew across four ship stations for different perks. Slowly, over many days, The Biscuit upgrades from Tier 1 to Tier 8. Other players' ghosts join your voyages to help; your ghost helps them while you're asleep. Friends can borrow each other's full live crews. No death, no PvP — only tea and postcards.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Sun-warm cove at golden hour. The Biscuit sits at the dock, hand-stitched sails fluttering. Gran Meriweather, the elderly host, waves. "Welcome, captain. Set sail when you're ready."
- **5–15s:** Tutorial sail. Drag-to-steer tooltip. The Biscuit sails out of the cove past smiley dolphins.
- **15–25s:** First friendly POI — a dinghy waving for rescue. Player diverts. Crew (Pip the chef) deploys for the rescue.
- **25–40s:** First scuffle: a polite barnacle-squid taps the Biscuit. Player taps to fire the biscuit-cannon. Non-lethal puff of crumbs sends the squid waddling away.
- **40–60s:** First ghost-crew encounter — a stranger's ghost ship sails past, waves. Player taps to wave back. **The "this game is gentle and someone else is here" moment.**

---

## 5. Hypothesis of why this would work

The Western cozy market has clear winners (Stardew, Cozy Grove, Spiritfarer, Animal Crossing) but very few mobile-native cozy games with strong social layers. Sky: Children of the Light proved Western mobile players will invest deeply in non-competitive asynchronous social games. The unmet combination is *cozy pirate collection + asynchronous social ghost help + slow single-ship upgrade*.

The bet is that the ghost-crew exchange is the durable engagement engine. Every voyage records the player's crew as ghosts that other captains may borrow once; every voyage they may receive a stranger's ghost help. This creates a feeling of "the world is full of other players quietly helping me" without requiring synchronous play. The shipped reference is Death Stranding — Kojima proved Western players love asymmetric "your work helps strangers" social patterns. Our diff is the cozy collection layer (84 chibi crew across 5 station families) which provides the per-session dopamine that Sky / Death Stranding ration more slowly.

---

## 6. Risks

**Single fragile assumption:**

*Cozy-genre players will accept the slow Tier 1→8 ship upgrade cadence (every 5–7 days) AS the long-arc goal, *provided* the per-voyage crew collection delivers enough small-dopamine hits to fill the gaps.*

If the per-voyage crew unlock rate is too slow, the long upgrade cadence reads as gating. If the crew layer is too prolific, the ship-upgrade arc loses its weight. The pacing balance is fragile. Stage 1 bundle: *"I never feel like I'm waiting for the next reward; there's always a chibi or postcard arriving."* Stage 4 (gameplay video) needs to show crew unlocks + ghost-rewards in the first voyage so testers feel the dopamine cadence.

---

## 7. Reference games

1. **Animal Crossing: Pocket Camp / Stardew Valley** — Nintendo / ConcernedApe. Cozy persistent base + character collection + slow-burn upgrade pacing. We share the slow-build aesthetic and named-character collection; we don't share the farm-or-camp setting — Driftcrew is the sea.
2. **Sky: Children of the Light** — thatgamecompany, 2019, mobile. Cozy asynchronous social, no PvP, gentle progression. We share the ghost-help social pattern and the wholesome tone; we don't share the platformer mechanic.
3. **Death Stranding** — Kojima Productions, 2019, console. Asynchronous social pattern at long-arc scale. We share the "your work helps strangers" loop; we don't share the package-delivery mechanic.

**Genre mashup formula:** Animal Crossing × Sky: Children of the Light × Death Stranding (ghost-help layer)

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- Voyage 1 ends. Crew Scroll opens — first new chibi (Mochi, GUNS station) joins the roster.
- Cove screen with Gran Meriweather hands the player a postcard from a stranger ghost.
- First crew rotation: drag Mochi to the GUNS station. The HUD shows the perk: "+15% biscuit-cannon range."
- Second voyage: Honeydew Shallows tease. Player sees a golden-hour merchant caravan in the distance.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | The Biscuit Tier 1, 4 crew, 1 postcard, 1 ghost interaction. | Tomorrow's daily scroll + Tier 2 ship upgrade visible. |
| D3 | 12 crew across 4 stations. First friend added. First ghost-borrow from a friend. | Tier 2 visible upgrade arrives; Cinnamon Isles region teased. |
| D7 | 30+ crew. The Biscuit Tier 3. Postcard wall starts to fill. Daily contracts grind. | First Ghost Regatta event teased on the calendar. |
| D14 | 50+ crew. The Biscuit Tier 4. First Ghost Regatta participated in. | Seasonal event chain + Lavender Latitudes tease for mythic crew. |

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~135 words)

```
You captain one beloved galleon, The Biscuit, and a crew of chibi
pirates. You sail out from your cove into cozy seas — pastel
shallows, golden-hour islands, lavender twilight latitudes.

You drag with one thumb to steer. Friendly POIs glow on the
horizon: rescue dinghies, mail caravans, ghost regatta buoys,
friendly merchants, polite barnacle-squids. You divert to whichever
one catches your eye.

Crew rotate across four ship stations: Helm, Guns, Galley, Lookout.
Each station's chibi gives the ship a perk — steering speed, biscuit-
cannon range, morale, scout range. You drag a chibi to a station;
the perk applies.

A voyage lasts five to fifteen minutes. You return to the cove
with scrolls, postcards, and gentle loot. No combat death — defeat
means going home for biscuits and tea.
```

#### Full description of core loop + 1 meta progression (Stage 1, genre-required, ~170 words)

```
You captain one beloved galleon, The Biscuit, and a crew of chibi
pirates. You sail out from your cove into cozy seas. You drag with
one thumb to steer. Friendly POIs glow on the horizon — rescue
dinghies, mail caravans, ghost regatta buoys.

Crew rotate across four ship stations: Helm, Guns, Galley, Lookout.
Each chibi gives a station perk. A voyage lasts five to fifteen
minutes. You return to the cove with scrolls, postcards, and
gentle loot. No combat death.

Strangers' ghost ships join your voyages to help once. Your own
ghost helps strangers while you're offline; when they finish their
voyage you get a postcard and a small reward.

The Biscuit slowly upgrades from Tier 1 to Tier 8 — each tier takes
5 to 7 days and visibly transforms the ship. You collect 84 chibi
crew across 5 families. Friends can borrow each other's full live
crews on demand. The cove decorates with everything you've earned.
```

#### Store-page variant (Stage 1b optional, ~55 words)

```
Captain one beloved ship with a growing crew of 84 chibi pirates.
Sail cozy seas. Rescue dinghies. Deliver mail. Shoo polite pests.
Ghosts of other captains drop by to help. Yours helps strangers
while you sleep. Slowly upgrade your ship across many days. Cozy,
gentle, family-friendly. No PvP. Only tea.
```

#### First 1–5 minutes the player experiences (~280 words)

```
Boot-up: studio logo, then a watercolor pan across a sun-warm cove
at golden hour. The Biscuit, a small hand-stitched galleon, sits
at a wooden dock. Gran Meriweather — a kindly elderly woman with a
teacup — waves. "Welcome, captain. Set sail when you're ready."

The Biscuit sails out. Tooltip: "Drag to steer." Player drags. The
ship swerves past smiley dolphins. A small chibi (Pip the chef)
waves from the deck.

A dinghy bobs in the water ahead, waving. Tooltip: "Rescue?" Player
taps. The Biscuit pulls alongside. A cinematic of Pip throwing a
biscuit to the dinghy. The dinghy waves back and a small
"Friendship Point +5" pops.

A polite barnacle-squid waddles into the Biscuit's path. Tooltip:
"Tap to fire biscuit-cannon." Player taps. A puff of crumbs hits
the squid. The squid does a surprised animation and waddles away.
No damage tally, no health bar.

A ghost ship appears off the starboard bow — a stranger's Biscuit
with a translucent overlay. The ghost waves. Tooltip: "Tap to wave
back." Player taps. The ghost ship's HUD shows "stranger from
Toulouse." A small "thank-you" particle drifts toward the player.

The voyage ends naturally at the 8-minute mark. The Biscuit pulls
back into the cove. Cinematic: Gran hands the player a sealed
scroll. The scroll opens. A new chibi pops out — Mochi, GUNS
station, "shy explosives enthusiast." Mochi joins the roster.

Crew rotation screen opens. Player drags Mochi to the GUNS station
slot. The HUD updates: "+15% biscuit-cannon range."

Second voyage loads.
```

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

```
Day 1. The player completes 2 voyages, rescues 3 dinghies, gets 1
scroll-unlocked chibi, receives 1 postcard from a stranger ghost,
and starts contributing to Tier 2 of The Biscuit (needs 5 days).
The hook for returning tomorrow is the daily scroll — they can
visibly see "Daily Scroll: 1 of 3 unlocked" in the cove UI.

Day 2. Returning player runs 2 more voyages. The Honeydew Shallows
region teases. They get a stranger ghost from a different country
and a postcard with sticker compositions. First friend addition
(by code share with a real-world friend). Friend's ghost shows up
on the third voyage — much longer duration than a stranger ghost.

Day 3. 12 chibi crew unlocked. Player starts rotating stations
between voyages to test perks. First "I'm playing my crew, not
just collecting" moment. Cinnamon Isles tease appears on the map.

Day 5. Daily delivery contracts unlock. The Biscuit hits Tier 2 —
visible transformation: longer hull, bigger sails, new figurehead
options. Cosmetic ship customization unlocks alongside.

Day 7. Friend ghost-borrows become routine. Player has a small
in-game friend list of 3–4 real-world friends. Ghost Regatta event
teases on the calendar — seasonal event with leaderboard.

Day 10. Player participates in their first Ghost Regatta. Solo-
friendly. Gets event-specific seasonal chibi (a captain in a
party-hat). First "this game has seasons" moment.

Day 14. The Biscuit Tier 3 in progress (3 more days). Player has
50+ chibi unlocked across the 5 station families. Postcard wall
fills with stickers from real friends and warm strangers. The
Lighthouse Beacon long-arc goal becomes visible in the cove UI —
unlocking it signals the player's cove as "open for visitors"
worldwide. The dominant return reason stacks: daily scrolls + Tier
upgrade timers + friend ghost-borrows + seasonal events + 
postcard mail.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a cozy single-ship collector.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Two candidate frames: (A) The Biscuit mid-voyage with chibi crew visible on deck, painterly pastel sea, a rescue dinghy waving in the distance, a ghost ship in soft silhouette. (B) cove dock view with Gran, the scroll mailbox, cosmetic ship customization tease. Both must read as "this is cozy + collection + warm sea fantasy" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. The Biscuit at golden hour, chibi crew on deck, a small flock of ghost ships in the soft middle-distance. Pastel palette (honey-gold / peach / mint). |
| **Key UI frames** | TBD | (1) Voyage gameplay HUD, (2) Crew rotation screen across 4 stations, (3) Scroll-opening animation, (4) Ship-tier upgrade screen w/ visible transformation, (5) Postcard wall, (6) Cove decoration + friend visit screen. |
| **App store icon** | TBD | 1024×1024. A chibi pirate standing on The Biscuit's deck, waving, pastel sea behind. Tested for thumbnail readability at 88×88. Must read as "cozy + collection" not "combat pirate." |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: The Biscuit at Tier 1, 4 chibi crew, 4 station rotation, 1 region (Home Waters) with 3 friendly POI types, mock ghost-ship encounter (1 scripted stranger ghost per voyage), cove with scroll mailbox + station rotation UI. No friend ghost-borrow, no Tier 2 upgrade. Must feel-representative on a real device — the cozy gentle tone is the entire pitch. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 30s gentle sail + dolphin/dinghy encounter, first ghost-ship wave-back interaction, first scuffle with a polite barnacle-squid, first scroll-opening → new chibi join. Each scored separately at Stage 4. |
