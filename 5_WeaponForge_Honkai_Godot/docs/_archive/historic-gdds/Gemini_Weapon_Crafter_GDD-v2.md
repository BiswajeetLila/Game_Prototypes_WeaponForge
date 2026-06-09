# New Game Concept — Weapon Crafter Auto-Battler (Working Title)

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
- [x] Prototype  
      - [x] Playable Gameplay (In Blockout - HTML/JS browser prototype)  
      - [x] Playable Coreloop with Progression layers (Roguelite buffs, Selective Revives, Auto-Battler Flow, Procedural Waves, Hard Currency integration)  
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
| Working title | Forge & Fight / Weapon Crafter Auto-Battler [TBD] |
| Genre / subgenre | Puzzle-RPG / Roguelite Auto-Battler / Merge-Crafter |
| Target audience | Mobile mid-core players who enjoy the tactile puzzle satisfaction of merge games (e.g., Merge Dragons) but want the exciting combat payoff, procedural variety, and tactical depth of a fantasy roguelite. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

I'm the tactical blacksmith for a squad of heroes facing endless, procedurally generated monster waves. During the "Preparation Phase," I manage a rail of random blueprints and elemental runes. I merge identical blueprints to level them up, or combine them with runes to instantly auto-deploy weapons to my Warrior, Rogue, or Mage based on class restrictions. Once equipped, I hit 'Start Battle' and watch my squad auto-attack the monsters, exploiting randomized elemental weaknesses. It’s a fast-paced loop of tactile puzzle-prep and explosive RPG auto-combat, layered with roguelite buffs and hard-currency revive decisions to keep my run alive.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** The screen is split. Top shows my 3 heroes (Warrior, Rogue, Mage) in the Preparation Phase facing two procedural enemies (e.g., a "Mutated Slime" and "Fierce Troll"). The UI is strictly color-coded (Red for Warrior, Green for Rogue, Blue for Mage).
- **5–15s:** I tap my Warrior, filtering my blueprint rail to only show Swords and Axes. I drag a Sword and a Fire Rune to the anvil and tap "Forge & Deploy!". The weapon auto-equips, and the UI instantly switches focus to my unequipped Rogue. 
- **15–25s:** With my squad equipped, I tap "START BATTLE." The UI locks, and I watch my heroes automatically trade blows with the enemies in real-time. My Warrior hits the Troll's Fire weakness for critical damage. 
- **25–40s:** The wave clears. My squad's weapons break, returning the base blueprints to my inventory. I receive dynamic loot drops (a mix of Lv.1 and Lv.2 blueprints). I merge two Lv.1 Daggers into a Lv.2 Dagger for the next wave.
- **40–60s:** At Wave 3 (Level 1 Boss), I defeat a "Shadow Dragon." A Gacha screen triggers, letting me draft a roguelite buff (e.g., Mage Healing Aura). As I push to Level 6, the difficulty scales exponentially, forcing me to hunt for Legendary drafts and deciding whether to spend my precious Gems to revive my fallen Rogue.

---

## 5. Hypothesis of why this would work

Players love the tactile, organizational satisfaction of merging mechanics (Wittle Defenders, Merge Dragons), but often find pure merge games lack a thrilling payoff or deep strategic combat. Conversely, auto-battlers have great combat viewing but passive input. 

This concept bridges that gap by treating the merge/crafting board as the tactical "Preparation Phase" for an RPG auto-battler. It gives players active, engaging puzzle-solving (managing inventory, filtering by hero, matching elements to procedural weaknesses) with an immediate, visually explosive RPG combat reward. The addition of exponential difficulty scaling, legendary roguelite choices, and selective revives creates deep replayability in short, mobile-friendly sessions.

---

## 6. Risks

**Single fragile assumption:**

Players will find managing the dual mental load of spatial inventory merging (bottom screen) and tactical turn-based combat (top screen) engaging rather than overwhelming or disjointed.

---

## 7. Reference games

1. **Robotek** — Hexage, 2011, Mobile. *We share the split-screen layout where the bottom half determines the RNG/tactical action executed on the top half.*
2. **Wittle Defenders** — Mobile. *We share the core progression philosophy of merging lower-tier units/items to persistently upgrade power.*
3. **Potion Craft** — niceplay games, 2021, PC/Console. *We share the fantasy of being the tactile crafter manipulating ingredients to solve problems.*
4. **Teamfight Tactics / Super Auto Pets** — *We share the distinct separation between a strategic Preparation/Drafting Phase and an automated Combat Resolution Phase.*

**Genre mashup formula:** *Merge Dragons × Slay the Spire × Teamfight Tactics*

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

* Understand that exhausted blueprints return next turn, shifting focus to long-term merging vs. immediate survival.
* Face procedurally generated enemies with randomized elemental weaknesses, preventing rote memorization and forcing adaptive crafting.
* Experience the exponential difficulty spike at Level 4+, introducing Legendary Gacha drops (e.g., instant Lv. 5 weapons, +50% DMG modifiers).
* Experience a squad wipe, prompting the first major monetization hook: spend 50 Gems to revive the squad or lose the run.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | Basic blueprints, 3 heroes, 3 elements. | Discovering the merge loop, auto-battler flow, and roguelite gacha choices. |
| D3 | [GAP] | [GAP] |
| D7 | [GAP] | [GAP] |
| D14 | [GAP] | [GAP] |

---

## 9. Deliverables

*(Skipping synthetic testing tables for brevity—needs filling out later)*

### 9.3 Playable prototype
| Artifact | Used by | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | Greenlight gate | *[COMPLETED]* HTML/JS prototype features full Auto-Battler flow, contextual UI, procedural wave generation, exponential difficulty scaling, and gem-based revive monetization. |

---

## 10. Prototype Development History

This section documents the iterative steps we took during our initial brainstorming and prototyping session to reach the current playable HTML/JS build.

* **Phase 1: Core Loop & Basic Layout**
    * Established the split-screen concept. Initially tested as a manual turn-by-turn combat system.
* **Phase 2: UI Styling & Basic Progression**
    * Applied dark-fantasy CSS theme. Added basic Wave scaling.
* **Phase 3: Elements & The Merge Mechanic**
    * Introduced elemental affinities and the core Merge Mechanic (combining duplicate blueprints to level them up permanently for the run).
* **Phase 4: Visual Overhaul**
    * Overhauled UI to match a parchment/ornate reference. Added strict hero role restrictions (Warrior=Red, Rogue=Green, Mage=Blue).
* **Phase 5: Quality of Life & Inventory Management**
    * Added Exhaustion Mechanic (blueprints break and return after combat). Live stat previews added.
* **Phase 6: Roguelite Elements**
    * Decoupled loot from bosses. Added a 3-turn choice Gacha drafting system for global buffs. 
* **Phase 7: The Auto-Battler Pivot**
    * *Major Gameplay Change:* Removed manual turn-by-turn attacks. Implemented a "Preparation Phase" where players craft/equip the whole squad, followed by a real-time "Auto-Battle Phase" where heroes and enemies trade blows automatically.
    * Added contextual UI: clicking a hero filters the inventory rail to only show their usable blueprints, sorted by highest level. Weapons auto-equip upon crafting.
* **Phase 8: Difficulty Curve & Tiered Progression**
    * Implemented a true "Level" system (1 Level = 3 Waves). 
    * Shifted from linear difficulty to an exponential curve starting at Level 6.
    * Added tiered loot drops (higher chances to drop pre-merged Lv.2 and Lv.3 items at higher stages). Added "Legendary" Gacha traits for late-game power spikes.
* **Phase 9: Procedural Generation & Monetization**
    * Ripped out static waves. Built a procedural engine combining Prefixes + Base Monsters to create infinite enemy varieties with fully randomized elemental weaknesses every wave.
    * Changed auto-revive to a Selective Revive mechanic.
    * Added a "Gems" hard currency UI and a "Squad Wipe" modal, allowing players to spend premium currency to save a deep run.
    * Polished CSS layout to ensure strict flexbox boundaries, ensuring all gameplay fits on a mobile screen without any scrolling.
