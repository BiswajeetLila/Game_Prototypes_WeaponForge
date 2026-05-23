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
      - [x] Playable Coreloop with 1 Progression layer (Roguelite buffs, Revives, Boss Waves)  
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
| Target audience | Mobile mid-core players who enjoy the tactile puzzle satisfaction of merge games (e.g., Merge Dragons) but want the exciting combat payoff and tactical depth of a fantasy roguelite. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

I'm the tactical blacksmith for a squad of heroes, but I have to forge their weapons on the fly mid-battle. Every turn, I get random weapon blueprints and elemental runes on the bottom of my screen. I can drag and merge identical blueprints to level them up into stronger weapons, or combine a blueprint with a fire or ice rune to forge a sword. I hand that sword to my Warrior on the top screen, hit 'End Turn', and watch my squad auto-attack the monsters based on elemental weaknesses. It’s half tactical puzzle, half RPG combat, and every few turns I get a roguelike buff that changes my whole strategy.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** The screen is split. Top shows my 3 heroes (Warrior, Rogue, Mage) facing a Goblin. Bottom shows my Workbench and an inventory rail of basic blueprints.
- **5–15s:** I tap a Sword blueprint and a Fire Rune, putting them in the anvil slots. I tap "Deploy Weapon!"
- **15–25s:** The crafted weapon appears. I tap my Warrior to hand it to him. I hit "Finish Turn." The Warrior strikes the Goblin for "Super Effective!" damage. The weapon breaks (exhausts for the turn).
- **25–40s:** A new turn starts. I get loot drops. I have two Lv.1 Dagger blueprints. I put both in the anvil and hit "Merge Blueprints" to create a permanent Lv.2 Dagger. 
- **40–60s:** I clear wave 3, defeating a Dragon Boss. The screen goes dark and a glowing Gacha present appears. I open it and get to choose between +15% Warrior Damage or a Healing Aura for my Mage. I pick the aura, surviving by the skin of my teeth. I want to see how far this run can go.

---

## 5. Hypothesis of why this would work

Players love the tactile, organizational satisfaction of merging mechanics (Wittle Defenders, Merge Dragons), but often find pure merge games lack a thrilling payoff or deep strategic combat. Conversely, auto-battlers have great combat viewing but passive input. 

This concept bridges that gap by treating the merge/crafting board as the "ammunition" for an RPG auto-battler. It gives players active, engaging puzzle-solving (managing inventory limits, deciding whether to merge for late-game power or craft immediately for short-term survival) with an immediate, visually explosive RPG combat reward. The addition of elemental rock-paper-scissors and roguelite choices creates deep replayability in short, mobile-friendly sessions.

---

## 6. Risks

**Single fragile assumption:**

Players will find managing the dual mental load of spatial inventory merging (bottom screen) and tactical turn-based combat (top screen) engaging rather than overwhelming or disjointed.

---

## 7. Reference games

1. **Robotek** — Hexage, 2011, Mobile. *We share the split-screen layout where the bottom half determines the RNG/tactical action executed on the top half.*
2. **Wittle Defenders** — Mobile. *We share the core progression philosophy of merging lower-tier units/items to persistently upgrade power.*
3. **Potion Craft** — niceplay games, 2021, PC/Console. *We share the fantasy of being the tactile crafter manipulating ingredients to solve problems.*

**Genre mashup formula:** *Merge Dragons × Slay the Spire × Robotek*

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

* Understand that exhausted blueprints return next turn, shifting focus to inventory management.
* Face an enemy with an immunity, forcing the player to use a different elemental rune or hero.
* Experience the first squad wipe, learning about the Revive Meter (charges via wave clears).
* Play a second run, prioritizing merging early to survive later boss waves.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | Basic blueprints, 3 heroes, 3 elements. | Discovering the merge loop and roguelite gacha choices. |
| D3 | [GAP] | [GAP] |
| D7 | [GAP] | [GAP] |
| D14 | [GAP] | [GAP] |

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

| Artifact | Used by | Word target | Notes |
| :---- | :---- | :---- | :---- |
| **Full description of core loop** | Stage 1 | ~135 | *[GAP: Needs drafting based on section 3]* |
| **Full description of core loop + 1 meta progression** | Stage 1 | ~170 | *[GAP: Needs drafting]* |
| **Store-page variant** | Stage 1b | ~55 | *[GAP: Needs drafting]* |
| **First 1–5 minutes the player experiences** | Stage 2 prep | ~280 | *[GAP: Needs drafting based on section 4]* |
| **D1–D14 player journey** | Stage 2 | ~340 | *[GAP: Depends on defining meta-progression]* |

### 9.2 Synthetic testing materials — Art
*[GAP: Currently missing all visual mockups, UI frames, and App Store icon]*

### 9.3 Playable prototype
| Artifact | Used by | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | Greenlight gate | *[COMPLETED]* HTML/JS prototype features full combat, merging, elemental affinities, roguelite gacha, and revive mechanics. |
| **Gameplay video** | Stage 4 | *[GAP: Needs recording from prototype]* |


## 10. Prototype Development History

This section documents the iterative steps we took during our initial brainstorming and prototyping session to reach the current playable HTML/JS build. It serves as a record of why certain mechanics were chosen and how the game evolved.

* **Phase 1: Core Loop & Basic Layout**
    * Established the core split-screen concept: Robotek-style auto-battler on top, Potion Craft-style weapon assembly on the bottom.
    * Implemented the "weapons as ammo" mechanic, where a crafted weapon is consumed immediately after the hero attacks.
* **Phase 2: UI Styling & Basic Progression**
    * Applied a dark-fantasy CSS theme to make it feel like a modern mobile RPG.
    * Added a basic Wave system where enemies scale in health.
* **Phase 3: Elements & The Merge Mechanic**
    * Introduced elemental affinities (Fire, Ice, Poison, Lightning) and enemy weaknesses/resistances.
    * Implemented the *Wittle Defenders* style literal Merge Mechanic: placing two identical level blueprints in the anvil combines them into a permanently stronger, higher-level blueprint. 
    * Added randomized end-of-turn loot drops.
* **Phase 4: Visual Overhaul (Reference Image Integration)**
    * Completely overhauled the UI to match a provided reference screenshot. 
    * Added a parchment and ornate metal theme, a left-side scrollable blueprint rail, a central 2-slot workbench, and a "Deployment Zone" for the squad.
    * Added strict hero role restrictions (Warrior uses Swords/Axes, Rogue uses Daggers, Mage uses Wands).
* **Phase 5: Quality of Life & Inventory Management**
    * Added dynamic, live stat previews under the workbench banner (Base ATK, Total ATK, Next Lvl ATK).
    * Implemented the **Exhaustion Mechanic**: blueprints used to craft a weapon temporarily disappear from the inventory for that turn, forcing players to manage limited resources.
    * Added a "Discard Weapon" button to refund blueprints in case of a misclick.
    * Upgraded Hero Cards to show exact ATK and Element icons when equipped.
* **Phase 6: Roguelite Elements (The Current Build)**
    * **Revive System:** Heroes now enter a "DEAD" state rather than disappearing. Added a Revive Meter that charges by clearing waves (0/3) to bring heroes back to life.
    * **Turn-Based Choice Gacha:** Decoupled the loot boxes from boss kills. The Gacha now triggers every 3 turns and presents a Roguelite "Choose 1 of 3" card draft.
    * **Global Buffs:** Added persistent run-based buffs to the Gacha pool (e.g., +15% Warrior Damage, Mage Healing Aura, +20% Fire Damage) to deepen the run strategy.
