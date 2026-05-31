# Black Tide (Roguelike) — Concept Template v2

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
| Working title | Black Tide (Roguelike) |
| Genre / subgenre | Pirate ship roguelike / FTL-style run map with action sailing combat |
| Target audience | Mid-core mobile players (14–40) who like FTL/Slay-the-Spire run structure and want pirate-ship fantasy with active per-encounter combat. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

You're a single captain sailing out of a hidden cove. You pick a heading and a node-map of the region appears — combat ships, merchants, weather, wrecks, a regional boss at the end. You sail node to node, fighting with one thumb on the rudder and one tap to fire your broadside cannons. After each kill you pick one of three "spoils" — cannon mods, crew buffs, sail tweaks, oil-fire shots. Stack them into a build that fits this run. Sink and you lose the ship but bank some gold. The cove grows. Pick a new heading and try again.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Sloop sits in the cove. "Pick a heading." A small region map glows.
- **5–15s:** Player taps a coastal-merchant node. The sloop sails toward it. First combat encounter loads — a fat merchant brig drifts into range.
- **15–25s:** Drag rudder left, broadside swings to face the merchant. Tap to fire. Cannons boom, the merchant takes hull damage. Numbers pop.
- **25–40s:** Merchant cripples. Spoil modal: 3 cards (Chain shot, Extra powder, Lookout perk). Player picks. Chain shot equips visibly to the front cannons.
- **40–60s:** Next node — a navy patrol sloop. Player tries the chain shot. The merchant's mast cracks on the first volley. **The "I want to stack more powder" moment.**

---

## 5. Hypothesis of why this would work

The FTL-on-mobile gap exists. Slay the Spire mobile shipped to 4M+ players and proved that node-graph run-map structures port to mobile. FTL itself has had a slow-burn mobile presence but the combat is paused-tactical, which is not what Western mid-core players reach for in a 10-minute session. Vampire Survivors / Brotato proved Western mobile will eat run-based action with build-stacking. The unmet combination is: FTL's region-map + Survivors' active build-stacking + pirate ship fantasy (which has no recent winning mobile entry — Skull and Bones whiffed; Sea of Thieves is console).

The bet is that ship sailing + active broadside combat is a more interesting set of physics than top-down character movement at a moment when the genre is starting to feel same-y. The spoil-card draft loop ports the Survivors mechanic directly. The cove + named-legendary-crew meta layer ports the AFK-collector pull from hero collectors. The shipped reference that anchors the bet is Hades — proving Western run-based players will tolerate (and pay for) a strong cosmetic / narrative meta layer around a run. Our diff is the asset-light mobile pirate setting.

---

## 6. Risks

**Single fragile assumption:**

*Per-thumb sail-and-broadside combat will feel skill-expressive in 30-second-per-node bursts. The player must feel that *they* sank the ship, not that the auto-aim did.*

If the combat reads as passive — drag rudder, tap fire, wait — the build stacking doesn't matter because the moment-to-moment has no skill ceiling. Stage 1 bundle: *"Sailing combat feels like I'm steering, not like I'm watching."* Stage 4 (gameplay video) re-tests this with motion — the rudder swings have to read as the player's choices.

---

## 7. Reference games

1. **FTL: Faster Than Light** — Subset Games, 2012, PC/mobile. Run-map structure with node choices, spoils, build identity. We share the region map + per-run build stacking; we don't share paused-tactical combat — ours is active broadside.
2. **Vampire Survivors (mobile)** — poncle, 2022. Auto-attack + per-level draft, stack synergy. We share the spoil-card mechanic and run-length pattern; we don't share top-down character movement — we're sailing a ship.
3. **Sid Meier's Pirates! / Sea of Thieves** — Firaxis / Rare. Pirate-ship combat lineage. We share the broadside-cannon fantasy and crew-named flavor; we don't share open-world freedom — we're run-structured.

**Genre mashup formula:** FTL × Vampire Survivors × Pirates!

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- Run 1 lasts ~9 minutes, sinks at the region boss. Defeat screen: "You banked 180 gold. Spend it at the cove."
- First cove screen. Player unlocks an extra spoil card (Oil-fire shot) into the run pool. The cove visibly has a new building (powder shed).
- Run 2 starts with the new card now possible in drafts. Player builds a fire-themed run. Clears region 1 boss for the first time. First "I built that run" moment.
- A named legendary crew (Cannoneer Quinn) unlocks from a prestige drop on the boss kill. They're slot-able into next run.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | Starter sloop, 1 region cleared once, 1 named crew unlocked, ~8 spoil cards in pool. | "I want to pull more powder cards" — synergy tags visibly suggest builds they haven't tried. |
| D3 | Region 2 (Spice Coast) unlocked. Second ship (Brigantine) buyable at cove. | First daily-modifier seal — restricted-spoils challenge with prestige reward. |
| D7 | Region 3 (Stormbreak Reefs) wall. Weather-shaped boss kills most runs. | New legendary crew + new spoil cards from prior region grinds. |
| D14 | First Cursed Latitudes run attempted. 3 ships at cove, 6 legendary crew, 50+ spoil cards in pool. | Weekly modifier seal + flagship-hunt leaderboard. |

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~135 words)

```
You captain a single pirate ship sailing out of a hidden cove. You
pick a heading on a region map, and a node-graph appears — combat
encounters, merchants, weather, wrecks, port stops, and a regional
boss at the end. You traverse node by node.

At each combat node, you sail with one thumb on the rudder. Drag
horizontally to steer, drag vertically for sail speed, tap to fire
your broadside cannons. Combat takes thirty seconds to two minutes
per encounter.

When you sink an enemy, three "spoils" cards appear. You pick one —
chain shot, oil-fire cannon, extra powder, crew buff, ghost-flag
stealth. The card equips to your ship for the rest of the run.

A run is one region: about eight to fifteen minutes. Sink the
regional boss to clear; sink yourself to end the run.
```

#### Full description of core loop + 1 meta progression (Stage 1, genre-required, ~170 words)

```
You captain a single pirate ship sailing out of a hidden cove. You
pick a heading on a region map, and a node-graph appears — combat
encounters, merchants, weather, wrecks, port stops, and a regional
boss at the end. You traverse node by node.

At each combat node, you sail with one thumb on the rudder. Drag
horizontally to steer, drag vertically for sail speed, tap to fire
your broadside cannons. Combat takes thirty seconds to two minutes
per encounter.

When you sink an enemy, three "spoils" cards appear. You pick one.
The card equips to your ship for the rest of the run.

A run is one region: about eight to fifteen minutes. Sink the
regional boss to clear; sink yourself to end the run.

Between runs, you return to the cove and spend banked gold. You
unlock new starter ships, you add new spoil cards to the run pool,
and you recruit named legendary crew who survive run sinks and slot
into future runs on a real-world cooldown. The cove grows visibly
across days.
```

#### Store-page variant (Stage 1b optional, ~55 words)

```
Captain a pirate ship through procedurally generated regions of a
cursed sea. Fight, sail, plunder. After each kill, pick a new
cannon mod, crew buff, or sail tweak to stack a one-of-a-kind build.
Sink and try again. Between runs, grow your cove and recruit
legendary crew. Ten minutes a run. The sea always rewrites itself.
```

#### First 1–5 minutes the player experiences (~280 words)

```
Boot-up: studio logo, then a slow camera pan across a hidden cove at
sunset. A small sloop is moored at a dock. A grizzled NPC says "Pick
your first heading, captain." A region map flickers into view.

Player taps the first node. The sloop sails toward a fat merchant
brig. Encounter loads. The merchant drifts into broadside range.
Tooltip: "Drag the bottom of the screen to steer." Player drags.
The rudder swings. Second tooltip: "Tap to fire when your guns are
aimed." Player taps. Cannons boom. The merchant's hull takes a hit,
damage number pops, sail goes ragged.

The merchant cripples. The encounter resolves to a treasure
animation — gold coins spill into the hold. A spoils modal pops:
three cards — Chain shot, Extra powder, Lookout perk. A tooltip
highlights Chain shot. Player taps. The card snaps onto the bow
cannons, and the cannon barrels physically lengthen and chain-link
ammunition appears in the loader.

Next node: a navy patrol sloop. The player tries the chain shot.
The patrol's mast cracks on the first volley. The encounter ends
faster than the merchant did. Player feels the build mattering.

By the third node, the player has fought a weather event (a
brewing squall that drains sail speed), drafted two more spoils,
and unlocked their first named crew member from a wreck dive node.
At the region boss — a navy frigate — the player's chain shot + 
extra powder build cracks the frigate's mast in three volleys. Win
screen: "Region cleared. 210 gold banked. New legendary crew:
Cannoneer Quinn."

The cove screen opens. The cove visibly has a new building — the
powder shed. The player taps "New Heading" and the next region's
map glows.
```

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

```
Day 1. The player completes 2–3 runs, clears region 1 on run 2,
sinks twice trying region 2. They've drafted across 15+ spoils,
unlocked their first legendary crew (Cannoneer Quinn), and the cove
has visibly grown by one building. The hook for returning is the
spoil card library — they see 50+ tags and have only seen 12 cards
in their runs so far.

Day 2. Returning player sees a "today's modifier" tag on region 1
— extra navy patrols, extra reputation reward. Player runs it. They
clear with a different build (powder-focused) and unlock the
Brigantine ship from the cove shipwright. First "I'm playing a
different way now" moment.

Day 3. The first daily Bounty Hunt unlocks — a named flagship in
region 2 with a unique prestige drop. Player attempts it with Quinn
slotted as legendary crew. The flagship sinks them, but they bank
enough gold to unlock a third ship variant.

Day 5. Region 2 cleared. Player has 18 spoil cards in pool, three
ships at cove, two legendary crew. The Spice Coast lore unlocks —
the dying mentor's diary fills in across runs. First emotional
investment moment.

Day 7. Stormbreak Reefs wall. The weather-shaped boss wipes the
player's first three attempts. They go back to region 1 to grind a
new spoil into the pool (the Bilge Pump card). The grind feels
tolerable because runs are 8–10 minutes each and they still net
gold.

Day 10. First Imperial Lanes attempt. Navy frigates and ships-of-
the-line are a noticeably harder threat tier. The legendary crew
cooldown becomes a real strategic constraint — Quinn is recovering
and the player has to slot a backup. First "I'm planning around the
roster" moment.

Day 14. Cursed Latitudes attempted. Ghost-ship encounters introduce
a supernatural threat tier and a new spoils-card category (cursed
spoils with downsides). Player has cleared 3 of 5 regions, has 4
ships, 6 legendary crew, and 50+ spoil cards. The weekly modifier
seal becomes the dominant return reason — daily run + weekly
prestige chase.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a roguelike action-sailor.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Single static frame mid-encounter: player sloop on lower half angled toward an enemy brig, broadside firing, smoke + cannon-fire FX, region map peek-overlay in corner, HUD with HP/sail-speed/spoil count. Must read as "I'm captaining a pirate ship in combat" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. Player sloop framed against a stormy painterly sea, region boss frigate emerging from rain. Treasure-map / parchment UI accent. |
| **Key UI frames** | TBD | (1) Cove home screen, (2) Region map node-graph, (3) Encounter HUD mid-combat, (4) Spoils draft modal, (5) Crew roster + legendary cooldowns, (6) Run summary / sink screen. |
| **App store icon** | TBD | 1024×1024. A single pirate sloop firing broadside, dramatic angle, parchment frame. Tested for thumbnail readability at 88×88. |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: one starter sloop, one region (Home Waters) with full node-graph map, 8 spoil cards in pool, 1 regional boss, banked-gold to cove with one cove upgrade visible. No second ship, no legendary crew, no second region. Must feel-representative on a real device — sail-and-broadside combat is the entire core loop. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 30s sail + broadside tutorial, first kill + first spoils pick, first region-boss encounter, first sink → cove transition. Each scored separately at Stage 4. |
