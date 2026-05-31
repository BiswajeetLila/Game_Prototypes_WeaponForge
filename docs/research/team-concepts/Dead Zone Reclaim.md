# New Game Concept - Zombie Survivor

Owner: Concept author

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

## 2. Identity

| Field | Value |
|---|---|
| Working title | Zombie Survivor |
| Genre / subgenre | Top-down squad zombie survival roguelite with objective-based map reclamation |
| Target audience | Casual-Mid-core action players who enjoy horde survival, squad building, and visible territory progression inside a run. |

## 3. Core Thesis / Idea

### Core idea (player-voice, ~100 words)

You lead a three-person squad into zombie-held districts and take the city back one zone at a time. At first the map is dark, broken, and packed with undead, but every objective you complete turns part of it into a safe foothold with lights, rebuilt barriers, ammo, and healing. Zombies drop XP, so each fight feeds into roguelike upgrade choices that change how the squad survives the next push. The more ground you reclaim, the harder the undead hit back. If you keep using the same trick, the AI starts adapting with counters, flankers, and new attack patterns.

## 4. Gameplay Journey

### Detailed D1 first 60 seconds

- 0-5s: The player sees a dark district map with one lit starting safe zone, a three-person squad, low ammo, and a nearby objective marker. The first instruction is simple: move to the highlighted zone.
- 5-15s: The squad enters a zombie-controlled street. Zombies approach from broken alleys. The player moves, aims, and watches the squad fire automatically or semi-automatically depending on control scheme.
- 15-25s: Zombies drop XP pickups. The player collects them, fills the level bar, and sees the first upgrade draft: choose 1 of 3 upgrades such as Double Shot, Damage Buff, or Movement Buff.
- 25-40s: The first objective begins. The player holds a capture zone while the squad fights incoming zombies. Capture progress rises while inside the zone and slowly drains if the squad retreats.
- 40-60s: The zone is secured. Lights turn on, barriers rebuild, an ammo station appears, and a trapped survivor is revealed nearby. The map immediately feels changed by the player's action, then a warning shows that zombie strength has increased.

### First 1-5 minutes the player experiences

The player starts in a small safe pocket at the edge of an undead-controlled district. The nearby streets are dark, barricades are broken, and the first objective marker pulses in a hostile zone. The squad moves out, meets the first wave of zombies, and learns the basic combat rhythm: keep moving, stay close enough for the squad to focus fire, collect dropped XP, and avoid being surrounded.

After the first level-up, the player chooses 1 of 3 upgrades. The choice is immediately felt in combat, such as shooting extra projectiles, moving faster, or dealing more damage. The player then reaches a capture zone and must stay inside it for 45 seconds while zombies attack from multiple directions. If the squad retreats, the progress slowly drains, so the player has to decide whether to risk holding position or fall back to survive.

When the objective completes, the zone transforms. Lights switch on, barriers rebuild, ammo and healing stations become usable, and the area becomes a safe foothold. A survivor may be released, granting a passive squad buff such as slow healing, armor, or faster repair speed. The player then sees the strategic tradeoff: every secured zone helps the squad recover, but it also increases zombie health, movement speed, spawn density, and sometimes unlocks new zombie types. If the player keeps camping the same chokepoint or retreat route, the AI begins adapting with flankers, ambushes, or enemy types that challenge that tactic.

## 5. Hypothesis of Why This Would Work

Many horde survival games give players strong moment-to-moment combat but reset the arena emotionally after each fight. This concept bets that players will feel more invested if every successful objective visibly changes the map. Turning lights back on, rebuilding barriers, unlocking ammo and healing, and rescuing survivors gives the player a strong sense that they are not just surviving. They are reclaiming territory.

The second bet is that the tension curve can stay fresh through two linked pressures: roguelike power growth and adaptive enemy response. Players get stronger through XP upgrades and rescued survivors, but each reclaimed zone makes zombies stronger too. The AI Dynamics system adds another layer by noticing repeated tactics and gently countering them, which can make runs feel reactive without needing every map to be handcrafted. The closest success pattern is the addictive escalation of Vampire Survivors combined with the readable zombie pressure of Left 4 Dead and the territory fantasy of survival strategy games.

## 6. Risks

### Single fragile assumption

Players will find adaptive enemy counters exciting and fair instead of feeling like the game is punishing them for playing well.

This is the key testable risk. If the AI changes attacks too aggressively, players may feel cheated. If it adapts too weakly, the system will not matter. The prototype should test whether players understand why the undead response is changing and whether they naturally vary tactics because of it.

## 7. Reference Games

1. Vampire Survivors - poncle, 2022, PC/mobile/console. Comparable for XP collection, fast upgrade drafting, and escalating horde pressure; this concept adds squad control, objectives, map reclamation, and safe zones.
2. Left 4 Dead 2 - Valve, 2009, PC/Xbox 360. Comparable for readable zombie combat, special infected pressure, and director-style pacing; this concept is more progression-driven and territory-focused.
3. State of Decay 2 - Undead Labs, 2018, PC/Xbox. Comparable for survivor fantasy, scavenging pressure, and base/safe-zone value; this concept is more session-based, roguelike, and objective-arcade focused.

**Genre mashup formula:** Vampire Survivors progression x objective-based zombie survival x squad hero collection x adaptive AI director.

## 8. Progression

### Rest of D1 (~5-10 minutes after first 60s)

- The player completes the first capture objective and unlocks the first safe zone.
- The player uses the new ammo or healing station, making the value of reclaimed territory clear.
- A second objective appears, likely Repair or Clear, to show that zones are not all captured the same way.
- The player rescues the first survivor and receives a passive buff.
- Zombie stats increase after the captured zone, making the next push noticeably more dangerous.
- The player earns more XP, chooses more run upgrades, and begins forming a temporary build.
- The first failure point should happen when the player overextends without returning to a safe zone.
- The first meta-loop touchpoint appears after mission success or squad wipe: coins and XP can be spent on weapons, gear, or squad members.

### Vague D1-D14 idea

| Day | What the player has | What brings them back |
|---|---|---|
| D1 | One starter squad, basic weapons, one reclaimed map attempt, and a first taste of safe zones and upgrade drafting. | The player wants to complete the first full liberation, try different upgrade choices, and spend earned coins on a clear weapon or gear improvement. |
| D3 | A stronger starting squad, early weapon upgrades, several known survivor types, and familiarity with Capture, Repair, and Clear objectives. | The player is chasing cleaner runs, new rescued survivor combinations, and a better answer to the AI's counter-tactics. |
| D7 | Multiple squad members, upgraded gear slots, harder maps, and new zombie types that force more deliberate team composition. | The player returns to test squad builds, optimize routes through maps, and beat zones that previously overwhelmed them. |
| D14 | A broader hero roster, meaningful weapon choices, upgraded gear, and map-specific strategies. | The player comes back for new map layouts, harder liberation challenges, rarer squad members, and the satisfaction of mastering adaptive enemy behavior. |

## 9. Deliverables

### 9.1 Synthetic testing materials - Design (text)

| Artifact | Used by | Word target | Notes |
|---|---|---:|---|
| Full description of core loop | Stage 1 | ~135-170 | Player-voice. No monetization. Describes minute-to-minute run play. |
| Full description of core loop + 1 meta progression | Stage 1 | ~150-200 | Adds one between-run progression layer. |
| Store-page variant | Stage 1b | ~50 | Pre-install pitch. |
| First 1-5 minutes the player experiences | Stage 1 / Stage 2 prep | ~200-300 | Opening session reference for art and UI mocks. |
| D1-D14 player journey | Stage 2 | ~200-400 | Progression description across two weeks. |

#### Full description of core loop (~135-170 words)

You lead a small squad into a zombie-held district and push from one dark zone to the next. Each area has an objective: hold a capture zone, repair a generator or gate, or clear every zombie inside a marked area. Zombies drop XP, so every fight pushes you toward a level-up where you choose 1 of 3 upgrades for the run. When you secure a zone, the map changes: lights turn on, barriers rebuild, and ammo or healing stations become usable. Sometimes a trapped survivor is released and joins the run as a passive buff. But every captured zone also raises the danger by increasing zombie health, speed, and spawn density. If you rely on the same tactic too often, the AI adapts with different attack routes or enemy types. You keep pushing until the squad liberates the map or gets wiped out.

#### Full description of core loop + 1 meta progression (~150-200 words)

You lead a three-person squad into a zombie-held district and reclaim it zone by zone. Each area has an objective: stay inside a capture zone, repair a broken generator or gate, or clear every zombie in a highlighted space. Killed zombies drop XP, and when you level up you choose 1 of 3 run upgrades like extra shots, more health, faster movement, automatic grenades, or exploding kills. Securing an objective turns the area into a safe foothold with lights, rebuilt barriers, ammo, and healing. Rescued survivors add passive buffs, such as slow healing, armor, or faster repairs. The pressure rises because each secured zone makes zombies stronger, faster, and denser. The AI also watches repeated tactics and can respond with flankers, ambushes, or enemy types that counter the player's habits. If the squad dies, map progress resets, but earned coins and XP are kept. Between runs, the player upgrades weapons, equips gear, and chooses better squad members before trying to liberate the map again.

#### Store-page variant (~55 words)

Key art of a three-person armed squad reclaiming a dark zombie-held district, with one side lit by restored power, rebuilt barriers, ammo and healing stations, trapped survivors behind them, and a massive adaptive undead horde closing in from the shadows.

#### First 1-5 minutes the player experiences (~200-300 words)

The run begins in a small safe zone on the edge of a dark, undead-controlled district. The squad has limited ammo and basic weapons. Nearby, a highlighted objective pulls the player into the first hostile street. Zombies shamble out from broken alleys, and the player learns the basic rhythm: move as a squad, focus fire, avoid being surrounded, and collect XP drops from killed zombies.

Within the first minute, the player levels up and chooses 1 of 3 upgrades. The chosen upgrade is immediately visible in combat, such as extra projectiles, faster movement, or higher damage. The squad then reaches a Capture objective. A timer begins, and the squad must stay inside the marked zone for 45 seconds while zombies attack. Leaving the zone is allowed, but capture progress slowly drains, creating a clear risk-reward decision.

When the objective completes, the zone transforms. Lights turn on, barriers rebuild, and ammo or healing stations appear. The player can now retreat here to recover. A trapped survivor may also be freed, adding a passive buff for the rest of the mission.

The next objective appears deeper in the map, but the game warns that zombie health, movement speed, and spawn density have increased. If the player keeps using the same chokepoint or retreat path, the AI begins changing its attack approach. The first session ends with a clear promise: every zone reclaimed makes the squad safer, but the undead response becomes more dangerous.

#### D1-D14 player journey (progression description, ~200-400 words)

Day 1: The player learns the main fantasy: enter a dark zombie district, complete objectives, and turn hostile zones into safe footholds. The first few runs are about understanding when to hold a capture zone, when to retreat, how XP upgrades change combat, and why safe zones matter. The first between-run upgrade should be simple and concrete, such as improving a weapon or equipping stronger armor.

Day 3: The player understands the objective types and starts making better run decisions. They know that Capture objectives reward defense, Repair objectives allow hit-and-run progress, and Clear objectives demand aggressive combat. They have likely rescued several survivor types and learned how passive buffs can shape a run. The AI Dynamics system should begin to matter here, as players notice that repeated tactics can trigger flankers, ambushes, or counter-enemies.

Day 7: The player has a stronger squad foundation. Weapons, gear, and squad members create meaningful pre-run choices. Higher-rarity squad members may bring skills such as ammo drops, healing bags, or automatic throwing knives. Maps can introduce tougher zombie types and more complex objective chains, pushing the player to build squads for specific threats.

Day 14: The player is chasing mastery. They are optimizing routes, selecting squad members for synergy, upgrading preferred weapons, and adapting to map-specific zombie counters. The long-term appeal is not only becoming stronger, but becoming smarter at reclaiming territory under pressure.

### 9.2 Synthetic testing materials - Art

| Artifact | Used by | Notes |
|---|---|---|
| Mockup of gameplay screen | Stage 3 | Show a squad holding a capture zone in a dark street, zombies approaching from multiple routes, XP drops, HUD, objective timer, and a nearby safe zone with lights on. |
| Key art | Stage 3 + Stage 1b pairing | Hero shot of the squad standing between a lit reclaimed zone and a dark undead-controlled district. |
| Key UI frames | Stage 3 | Gameplay HUD, upgrade choice screen, run map, squad setup, weapon/gear upgrade screen, survivor rescue popup, and run-end summary. |
| App store icon | Stage 3 | A readable thumbnail: squad leader silhouette, glowing safe-zone light, and undead crowd edge. |

### 9.3 Playable prototype

| Artifact | Used by | Notes |
|---|---|---|
| Playable prototype | Greenlight gate | Scope should include one blockout map, three objective types, basic zombie spawning, XP drops, upgrade draft, one safe zone transformation, one survivor, and one between-run upgrade layer. |
| Gameplay video (30-90s, beat-sliced) | Stage 4 | Include first 30s onboarding, first zone secured, first upgrade choice, first survivor rescue, first AI adaptation moment, and either mission success or squad wipe. |

## 10. Detailed Mechanics Reference

### Objective types

| Objective | Rule | Player tension |
|---|---|---|
| Capture | Remain in the zone for 45 seconds. Leaving the zone slowly removes capture progress. | Hold position under pressure or retreat and lose time. |
| Repair | Stand near a generator, gate, or structure to repair it. Progress does not reset when the squad leaves. | Repair in bursts while managing incoming waves. |
| Clear | Kill all zombies inside a highlighted area. | Commit to aggressive combat and target prioritization. |

### Safe zones

When an objective is completed, the surrounding area becomes reclaimed. Lights turn on, barriers rebuild, ammo stations appear, healing stations activate, safer navigation routes open, and survivor access may unlock. Safe zones give the player a place to recover, but they do not remove tension because global zombie difficulty increases after every secured area.

### Escalating difficulty after each secured zone

- Zombie health increases by 10%.
- Zombie spawn density increases by 0.5.
- Zombie movement speed increases by 10%.
- New zombie types may appear depending on the map or difficulty stage.

### Roguelike upgrade examples

| Upgrade | Effect |
|---|---|
| Double Shot | Squad members fire 2 projectiles instead of 1. |
| Extended Mag | Increases magazine size by 10%. |
| Ammo Reserve | Increases maximum ammo capacity by 10%. |
| Health Buff | Increases squad max HP by 5%. |
| Damage Buff | Increases squad damage by 5%. |
| Frag Grenade | Squad automatically throws a frag grenade every 15 seconds. |
| Critical Buff | Increases critical hit chance by 5%. |
| Movement Buff | Increases squad movement speed by 5%. |
| Reload Master | Increases squad reload speed by 5%. |
| Explode | Killed zombies have a 10% chance to explode and damage nearby zombies. |
| XP Buff | Increases XP gained by 10%. |

### Survivor examples

| Survivor | Passive buff |
|---|---|
| Doctor | Slowly heals squad members over time after they avoid damage for a short period. |
| Tailor | Grants 10% armor to all squad members, reducing damage taken. |
| Engineer | Increases objective repair speed by 15%. |
| Officer | Increases squad damage by 5% and reduces damage taken by 5%. |

### AI Dynamics

The AI watches how the player fights and gradually adapts to repeated tactics. The system should not instantly punish strong play. Instead, it should respond when a tactic becomes overused across a run.

Possible adaptations:

- Change zombie pathing to attack from multiple directions.
- Spawn enemies that counter the player's most-used tactic.
- Send faster enemies when the player retreats too often.
- Send armored enemies if the player relies heavily on basic gunfire.
- Spread zombies out if the player relies on grenades or explosions.
- Increase pressure around safe zones if the player camps them too much.
- Use special zombies to break defensive positions.
- Create ambushes after repeated movement patterns.

### Mission failure

If the squad dies, the mission fails. Map progression for that run is wiped, and the player starts the map again from the beginning. The player keeps long-term rewards such as XP and coins, so failure still contributes to account progression.

### Mission success

When the player secures all required zones and completes the final objective, the map is liberated. The results screen shows XP earned, kills, coins earned, survivors rescued, zones captured, time taken, squad members downed, and upgrades chosen. The player then returns to the menu to prepare for the next mission.

### Between-run progression

Between runs, the player spends earned XP and coins to improve their starting power.

Weapons can be equipped and upgraded to improve damage, fire rate, reload speed, magazine size, critical chance, accuracy, and ammo capacity.

Gear slots include helmet, body armor, and boots. Gear improves base stats such as health, damage resistance, movement speed, reload speed, and damage output.

Squad setup allows the player to choose 3 squad heroes. Higher-rarity heroes have better starting stats, and rare or higher heroes can have special skills such as dropping ammo every 30 seconds, dropping a healing bag every 30 seconds, throwing an instant-kill knife every 20 seconds, increasing nearby squad damage, repairing objectives faster, or reviving downed squad members more quickly.

## 11. Overall Player Experience

The game should feel like a constant push-and-hold survival campaign. The player is not just killing zombies. They are retaking territory. Every completed objective changes the map, every safe zone feels earned, and every upgrade gives the squad a better chance against a horde that keeps learning and escalating.

The intended emotional arc:

- Early game: cautious exploration and first foothold.
- Mid game: growing power, rescued survivors, expanding safe zones.
- Late game: intense pressure as stronger zombies flood the map and adapt to repeated tactics.
- Victory: the map lights up, the undead are pushed back, and the player feels like they truly reclaimed the district.
