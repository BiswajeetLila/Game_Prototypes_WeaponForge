# Rogue TD

**Owner: Josh**

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
| --- | --- |
| Working title | Rogue Tower Defense (Rogue TD) |
| Genre / subgenre | Roguelike Tower Defense |
| Target audience | Casual-Mid/Core players who enjoy Roguelike gameplay loops that last 10-15 minutes. With run to run progression becoming stronger each time. |

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

You play as a lone survivor holding the line against endless nocturnal hordes. Before each run, you select a strategic loadout of three towers and upgrade your character's base stats. During the day, you race against the clock to build defenses and fortify your headquarters. When night falls, you are thrust into intense, action-packed combat. As you fight, your kills earn you XP, letting you level up and draft powerful roguelike upgrades to survive the immediate threat. If you make it to dawn, you are rewarded with premium currency, allowing you to permanently upgrade your arsenal and face even deadlier waves in future runs. Successfully completing a run grants you a chest that contains 'Tower Fragments' that can be used to upgrade your towers/structures.

## 4. Gameplay journey

Detailed D1

**First 60 seconds:**

- 0-5s: What the player sees, what they're asked to do. The player drops onto the map as a lone survivor standing next to their vulnerable HQ. A bright daylight timer ticks down at the top of the screen. A quick UI prompt asks them to select their starting loadout of three towers before the impending nightfall.
- 5-15s: First interaction. Tap target, response. The player taps their desired tower from the UI, then taps a highlighted building node near the HQ. A satisfying construction sound plays, starting currency is deducted, and the tower instantly slams into the ground, readying its weapons.
- 15-25s: First feedback loop closes. What changes on screen. The daylight timer hits zero. The environment darkens, the music shifts to a tense beat, and the first wave of nocturnal enemies rushes in. The player's character and the newly built tower open fire. The first enemy dies, dropping glowing XP gems onto the battlefield.
- 25-40s: Second loop, escalation. The horde grows larger, forcing the player to move their character to dodge attacks while scooping up the XP gems. The XP bar fills, freezing the action with a flashy "Level Up!" pop-up. The player is presented with three randomized roguelite upgrades and taps one (e.g., "Piercing Ammo") to instantly boost their combat power.
- 40-60s: The "I want more of this" moment - the specific beat that earns a second session. Unpaused, the player's new upgrade shreds through the remaining horde in a highly satisfying display of power. Dawn breaks, clearing the darkness. A "Wave Survived" screen appears, and a loot chest violently bursts open, showering the screen with Premium Currency and glowing 'Tower Fragments.' The player immediately sees the prompt to permanently upgrade their favorite tower in the meta-menu, hooking them into the loop of becoming stronger for the next run.

## 5. Hypothesis of why this would work

This game would thrive in the current market because it successfully bridges the addictive, fast-paced action of "bullet heaven" roguelikes with the cerebral, strategic planning of tower defense. On Steam, we've seen how much players crave games that blend strategy with action, with titles like Thronefall and Kingdom Two Crowns proving that day/night cycles (where you build by day and desperately defend by night) offer an incredibly satisfying gameplay rhythm. However, your game stands out by injecting the adrenaline-pumping, in-combat roguelike leveling system of massive hits like Vampire Survivors or Brotato. This hybrid approach solves the main critique of pure survivor games-which can sometimes feel too passive-by giving the player meaningful spatial and strategic choices through tower placement before the chaos begins.

Furthermore, the game's meta-progression system is perfectly engineered for long-term retention, particularly in the mobile market. By rewarding players with premium currency and 'Tower Fragments' to permanently upgrade their loadout, it taps into the highly proven progression models seen in mobile juggernauts like Survivor.io and Rush Royale. It stands out in a crowded market because it appeals to two distinct player psychologies at once: the tactical player who loves optimizing base layouts, and the action-oriented player who loves melting hordes with overpowered roguelike builds. This combination ensures strong replayability, as players will constantly want to jump back in for "just one more run" to test a newly upgraded tower.

## 6. Risks

**Single fragile assumption:**

Players will actively enjoy constantly switching their mental gears between anxious, strategic puzzle-solving (daytime building) and twitch-reflex survival (nighttime combat), rather than abandoning the game because this frequent context-switching breaks the hypnotic "flow state" they usually expect from action-roguelikes.

(If this bet is wrong, the game will feel like two completely different games stitched together-exhausting action players who just want to turn their brains off and slay hordes, while frustrating tactical players who feel too rushed to properly optimize their defenses.)

## 7. Reference games

1. Thronefall - GrizzlyGames, 2023, PC / Consoles / Mobile.
   - a. Why it's comparable: It flawlessly executes the "build during the day, fight during the night" pacing loop while keeping the player an active participant on the battlefield.
   - b. What we share: The core day/night cycle, base defense mechanics, and an action-oriented protagonist who fights alongside their structures. What we don't: Thronefall is fundamentally a light-strategy RTS without deep, run-altering roguelite progression or bullet-heaven swarm combat.
2. Kingdom Two Crowns - Noio / Fury Studios, 2018, PC / Consoles / Mobile.
   - a. Why it's comparable: It is the golden standard for side-scrolling, atmospheric day/night base defense where you prepare by daylight and survive the nocturnal hordes.
   - b. What we share: The desperate struggle to upgrade your camp and walls before nightfall, and the punishment of losing ground to a growing enemy threat. What we don't: Kingdom relies on indirect combat (recruiting AI archers/knights) rather than direct player combat, and lacks the chaotic leveling system.
3. Vampire Survivors - poncle, 2022, PC / Consoles / Mobile / VR.
   - a. Why it's comparable: It codified the highly addictive "bullet heaven" genre where fighting enormous hordes grants XP for rapid, run-defining power spikes.
   - b. What we share: Intense combat where mobility is key, killing thousands of enemies, collecting XP gems, and drafting from three randomized upgrades upon leveling up. What we don't: Vampire Survivors has zero base-building, no tower defense elements, and no distinct "safe" pacing breaks during a run.
4. Brotato - Blobfish, 2022, PC / Consoles / Mobile.
   - a. Why it's comparable: It distills the action-roguelike formula into tightly confined, high-intensity waves with a heavy emphasis on build theorycrafting.
   - b. What we share: The wave-based survival structure and the deep satisfaction of creating synergized, overpowered builds. What we don't: Brotato's breaks between waves are purely for shopping in a menu, whereas our game uses the downtime for spatial, on-map tower defense strategy.
5. Survivor.io - Habby, 2022, Mobile.
   - a. Why it's comparable: It successfully adapted the Vampire Survivors formula for a massive mobile audience with a robust out-of-game meta-progression system.
   - b. What we share: The premium currency and fragment-based meta-progression that incentivizes grinding and provides long-term retention. What we don't: Survivor.io is purely an endless runner/shooter without any strategic map control or base-building elements.
6. Rush Royale - MY.GAMES, 2020, PC / Mobile.
   - a. Why it's comparable: It is a massive hit in the mobile space that blends tower defense with randomized, fast-paced unit merging and loadout strategies.
   - b. What we share: The pre-run loadout selection (choosing which towers to take into battle) and the addictive loop of upgrading towers via fragments/currency. What we don't: Rush Royale is an indirect, competitive PvP/Co-op puzzle game without a controllable avatar or action-combat mechanics.

## 8. Progression

### Rest of D1 (~5-10 min after first 60s) 
Bullets, not prose. What does the player do for the rest of their first session? When do they hit the first wall, the first reward, the first meta-loop touchpoint?

### Vague D1-D14 idea

| Day | What the player has | What brings them back |
| --- | --- | --- |
| D1 | Basic character stats, the 3 starter towers, a taste of the chaotic combat, and their very first loot chest containing 'Tower Fragments'. | The immediate dopamine hit of the core loop. They want to spend their first fragments to upgrade a tower and see how much further they can survive in the next run. |
| D3 | Unlocked 1-2 new tower types, a basic understanding of daytime time-management, and minor permanent character stat boosts (e.g., faster move speed). | The urge to experiment with different 3-tower loadouts and the desire to conquer the first major difficulty spike (or first boss wave) they just failed against. |
| D7 | A core set of favorite towers upgraded to mid-tiers, established strategies for surviving early nights, and a growing stash of premium currency. | Saving up premium currency for a highly coveted "Rare/Epic" tower, and the habit-forming rhythm of daily login rewards and fragment grinding. |
| D14 | Deeply specialized tower loadouts, high-level permanent character stats, and mastery over multiple map biomes or difficulty tiers. | Chasing "Legendary" tower fragments, tackling weekly challenges, and the long-term sunk-cost pursuit of building the ultimate, unstoppable loadout. |

## 9. Deliverables

This is the contract. To take this concept through the SSR pipeline + greenlight gate, the concept author must produce everything below. Each row maps to a specific stage in game-testing-approach.md.

### 9.1 Synthetic testing materials - Design (text)

#### Full description of core loop (Stage 1 required, ~135 words)

You play as a lone survivor tasked with defending your headquarters against relentless nocturnal attacks. During the daylight hours, you race against the clock to scavenge the map for resources, earning the currency you need to construct vital defenses on designated building nodes. You are constantly balancing time management and strategy during this preparation phase, as every moment you spend exploring and building pushes you closer to the inevitable setting of the sun.

When night falls, you are put to the true test as waves of enemies besiege your base, forcing you into dynamic combat where mobility is key to survival.

Once you defeat the final enemy, day breaks, granting you a brief, hard-earned respite to safely explore, rebuild, and begin the cycle anew for the next wave.

#### Full description of core loop + 1 meta progression (Stage 1, genre-required, ~170 words)

You play as a lone survivor tasked with defending your headquarters against relentless nocturnal attacks. During the daylight hours, you race against the clock to scavenge the map for resources, earning the currency you need to construct vital defenses on designated building nodes. You are constantly balancing time management and strategy during this preparation phase, as every moment you spend exploring and building pushes you closer to the inevitable setting of the sun.

When night falls, you are put to the true test as waves of enemies besiege your base, forcing you into dynamic combat where mobility is key to survival.

As you fight to protect your headquarters, you earn XP from your combat and construction efforts, allowing you to level up and choose from three randomized buffs tailored to your current run.

Once you defeat the final enemy, day breaks, granting you a brief, hard-earned respite to safely explore, rebuild, and begin the cycle anew for the next wave.

#### Store-page variant (Stage 1b optional, ~55 words)

Race against the clock during the day to scavenge resources and construct vital base defenses before the sun sets. When night falls, survive relentless enemy waves in dynamic combat and earn powerful randomized upgrades to live another dawn.

#### First 1–5 minutes the player experiences (~280 words)

Boot-up: studio logo with some cinematic music, a lone survivor walks towards their HQ building with the ruins of destroyed buildings and fallen survivors. Text fades in: "They're all gone, I can't let this happen again"

Tutorial: Spawns the player in and can now be controlled, shows the player how to move around. Message pops up on the screen saying "They'll be back at night, I better prepare". Waypoint marker is placed on one of the tower building nodes. The player goes into the zone to build the tower, after building then explains that building costs currency. "Building any structure costs 'currency', spend wisely" Night then comes with tense music and the enemies start to attack again, using auto attack and the player strategically moving around to kill the wave of enemies. Night ends after the last enemy has been killed.

Morning falls, relaxing music plays. The player feels relief and is met with a pop-up "You've leveled up, select a perk/buff choice below" The player selects their choice and feels stronger, they then explore the map area to find more currency to help fortify. The player then builds any new structures and prepares for the next wave.

Wave 2: Common enemies come to attack but a new faster enemy is introduced. This enemy moves 1.5x faster but has less health, it applies the pressure on the player. During combat they level up and can select a new perk/buff. No tooltip just letting the player play freely.

Wave 3: Introduces the 'HOUSE' structure, an economy building that generates currency. Player is told about this new structure and what it does, player is given money to build it but constructing it is completely optional.

Wave 4: Player is introduced to the 'BUFF TOWER' a support structure that applies a buff to the player if within the zone. The player is told about this new structure and what it does, player is given money to build it and is shown where to go to build it. Once built they are then told to select a buff they want to activate.

Wave 7: Player has built up their base a lot more and acquired a fair few helpful perks/buffs to make them stronger. But feels the pressure of the challenge growing.

Wave 8: The wave that kills the player and wipes them out (Intentionally). Default screen shows displaying the result stats of how long you lasted, enemies killed, buildings constructed and lost. Player is then given premium currency for surviving x days that is used for later. Player then taps 'Try Again' in which an upgrades screen is shown where the player can then use the 'Premium Currency' to purchase upgrades. They are then told 'Premium Currency' can be earned through surviving each night. Player then has a choice to upgrade the 'Base Character Level' or 'Base Weapon Level'.

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

Day 1: The player finishes the first chapter after around playing 4-5 runs. Clearing up to around wave 15-20 (50 waves total). They have built and lost many structures and tried a lot of the perks/buffs that are given per player level up in-game. The hook to get players to return the next day is knowing there is more upgrades to progress and new towers/structures to unlock after completing chapter 1 and learning new structure builds.

Day 2: Player is greeted with a login reward screen, giving them a boost of 'Premium Currency' so they can start the day with an upgrade. This login reward screen also shows upcoming interest such as unlock an epic or legendary tower. As the player progresses the chapter they are introduced to new enemies with different types of attacks forcing the player to change their strategy.

Day 3: Tower fragments event is unlocked, giving the player the opportunity to get more tower parts to upgrade the tower or unlock a new tower (Player is given fragments to upgrade and unlock a new tower after completing the event once) The gratification from the rewards makes the player want to push more and acquire more fragments.

Day 7: Player has either completed chapter 2 or is halfway through chapter 3. Chapter 3 is tough and the player's current upgrades and towers just aren't that strong enough. They are given a discount on a tower pack, costing only "Premium Currency' to buy and get tower fragments. Player has 3 choices, grind earlier chapters to get the 'Premium Currency' or can buy a starter pack giving them the right amount of 'Premium Currency' to buy with plenty left over. Goal here is to focus more the grind direction as the pack won't cost too much but offers 500% bonus rewards. Last choice is just grind the game, ignore the offer and just continue with upgrades.

Day 14: Weekly Chapter scoreboards are unlocked allowing you to compete for fastest completion time, least amount of structures built, least amount of HQ damage taken. Multiple categories for the players to compete in within each chapter offering great rewards for 1st, 2nd and third place and reasonable rewards for top 100. A daily challenge is unlocked on day 8 after logging in for 7 days. This daily challenge will vary on enemy types only, HQ 1/4 health, endless mode (Last for 120 seconds) etc... Player will earn more rewards for this and will have max attempts per day. This gives incentive for the player to login daily to get these rewards.

### 9.2 Synthetic testing materials - Art

Genre-conditional set for roguelike/action oriented game. Tower collection game, with strong surfaced thematic/setting.

| Artifact | Used by | Notes |
| --- | --- | --- |
| Mockup of gameplay screen | TBD | Single static frame, hero player in the middle of the screen. Panned camera in a top-down/RTS style. Fog and environment encapsulates the player with visible enemies moving closer. Simple HUD, top right is a time bar showing day or night length remaining, player level UI below the time slider. Gold and pause button in the top right. |
| Key art | TBD | Hero player standing in front of the HQ with towers behind it supporting the hero fighting off the horde of enemies. |
| Key UI frames | TBD | (1) Gameplay HUD mid-run; (2) Player level up pop-up and perk/buff selection; (3) Upgrades screen; (4) Tower roster selection screen. |
| App store icon | TBD | 1024x1024 HQ building being destroyed (With flames and debris) with the hero flying out of it. |

### 9.3 Playable prototype

Required for greenlight (Supercell mandate). SSR cannot validate moment-to-moment feel, input latency, juice, or controls - the prototype is the only artifact that does.

| Artifact | Used by | Notes |
| --- | --- | --- |
| Playable prototype | Greenlight gate | Scope: enough to play the core loop end-to-end for one session. Doesn't need meta-loop, monetization, or polish. Must be feel-representative. Hero player controllable with auto fire mechanics, 5-7 perks or buffs for the player to choose from, 3 types of building (Tower, House, Buff Tower), HQ building, basic wave spawning system, basic blockout map with HQ walled off except from one side, build nodes placed around for player to build towers. |
| Gameplay video (30-90s, beat-sliced) | Stage 4 | Cut from the prototype. Beats: first 30s onboarding, first win, first loss, first monetization touchpoint (if shown). Each beat is scored separately. First 30 seconds, the player is building and preparing for the nightfall horde. The first time the player encounters the enemies and levels up, the player almost gets overwhelmed and loses structures, the player survives the last night and comes out a winner. |
