### **Technical Synthesis and Systemic Analysis of Transistor: A Deep Dive into Supergiant Games’ Design Architecture**

The release of Transistor in 2014 by Supergiant Games marked a significant pivot in the landscape of independent game development, following the studio’s success with Bastion. The project was not merely an aesthetic successor but a profound mechanical experiment that sought to reconcile the immediacy of real-time action with the cognitive depth of turn-based strategy. By examining the design of Transistor through a professional lens, one identifies a recursive structure where narrative, visual art, and complex system logic are inextricably linked. The game’s setting, Cloudbank, functions as a technological metaphor that justifies its combat systems, while its weapon—the titular Transistor—serves as the primary interface for both the player and the protagonist to manipulate the city’s underlying code.

### **The Function Architecture: Modular Combat and Combinatorial Logic**

At the heart of Transistor’s game design is the Function system, a modular framework for character abilities that rejects traditional linear progression. The studio director, Amir Rao, and creative director, Greg Kasavin, initially took inspiration from collectible card games, particularly Magic: The Gathering, envisioning a system where players would draw abilities from a deck. This eventually evolved into a pool of 16 distinct "Functions," each derived from the "Trace" data of Cloudbank’s prominent citizens who were assimilated by the Transistor.

### **The Three-Tiered Slotting System**

The brilliance of the Function design lies in its versatility. Every single Function is capable of serving three distinct roles, creating a combinatorial explosion of tactical possibilities. The game offers approximately 22,283,705,698,113 potential combinations, a number that underscores the depth of the customization engine.

| Slot Classification | Operational Mechanic | Design Implication |
| :---- | :---- | :---- |
| **Active Slot** | Provides the base attack, movement, or utility skill (e.g., a melee strike or a teleport). | Defines the primary interaction method during real-time and Turn() modes. |
| **Upgrade Slot** | Modifies the behavior of an Active Function with the secondary properties of the upgrade (e.g., adding a stun or a chain effect). | Allows players to mitigate the weaknesses of an Active skill or amplify its strengths through synergy. |
| **Passive Slot** | Grants a global, persistent buff to Red (e.g., health regeneration, damage resistance, or faster Turn() recovery). | Provides "under-the-hood" stabilization for specific builds without occupying active input bandwidth. |

The interaction between these slots is governed by "Memory" (MEM), a resource that scales as the player levels up. This constraint prevents early-game players from stacking high-cost Functions but allows late-game builds to achieve devastating systemic synergy.

### **Exhaustive Functionality and Systemic Synergy**

The 16 core Functions are balanced to ensure that no single ability is purely superior. Instead, their value shifts depending on their slot placement and the current enemy composition. Analysis of the Function pool reveals a meticulous design that mirrors common action-RPG archetypes—stun, charm, long-range, and area-of-effect—reimagined through a modular lens.

| Function Name | Active Role | Upgrade Utility | Passive Benefit |
| :---- | :---- | :---- | :---- |
| **Crash()** | Short-range disruptive strike. | Adds a stun effect and vulnerability. | Grants resistance to damage and slowing. |
| **Breach()** | Long-range piercing projectile. | Increases projectile range and velocity. | Expands the Turn() planning bar. |
| **Spark()** | Explosive cluster-shells. | Splits primary effects into multiple parts. | Spawns a decoy when Red is struck. |
| **Jaunt()** | Immediate teleportation/dash. | Permits the use of the skill during recovery. | Accelerates the Turn() recharge rate. |
| **Bounce()** | Ricocheting kinetic bolt. | Adds chain-reactive properties. | Provides a shield that negates one hit. |
| **Load()** | Volatile packet placement. | Increases area-of-effect (AoE) radius. | Spawns explosive packets periodically. |
| **Help()** | Summons a friendly Fetch unit. | Chance to prevent Process Cell spawning. | Small chance to trigger "SuperUser" state. |
| **Mask()** | Temporary cloaking/stealth. | Massive damage buff for backstabs. | Stealth and speed boost after a kill. |
| **Ping()** | Rapid kinetic fire. | Speeds up execution and lowers Turn() cost. | Halves the cost of movement in Turn(). |
| **Switch()** | Allegiance-altering (Charm). | Integrates charm into other attacks. | Friendly Badcells spawn from Cells. |
| **Get()** | Magnetic pull-in effect. | Forces targets toward the User. | Draws in dropped Cells from range. |
| **Purge()** | Seeking corrosive parasite. | Adds DoT and slowing effects. | Retaliates automatically when hit. |
| **Flood()** | Lingering storm sphere. | Leaves damage trails in the wake. | Passive HP regeneration over time. |
| **Cull()** | High-kinetic upward strike. | Increases impact and air-time. | Contact damage during Turn() movement. |
| **Tap()** | Life-leeching radial burst. | Adds lifesteal to primary attacks. | Increases the player's total HP pool. |
| **Void()** | Multi-stacking debuff. | Multiplies base damage and potency. | Persistent stacking damage multiplier. |

The design philosophy behind these Functions emphasizes "controlled experimentation". By making lore data—biographies of the Cloudbank citizens—discoverable only by using Functions in all three slots, the game creates a narrative incentive for mechanical variety. This prevents the common RPG "rut" where a player finds one efficient combo and relies on it exclusively for the duration of the campaign.

### **The Temporal Dialectic: Hybrid Real-Time and Turn() Mechanics**

Transistor’s most distinctive innovation is its treatment of time. The combat system operates in a perpetual state of flux between real-time action and the strategic planning mode known as Turn(). This hybridization addresses the inherent weaknesses of both genres: real-time games can become too chaotic for complex tactical decisions, while purely turn-based games can feel slow and disconnected from the kinetic energy of the character’s movements.

### **The Mechanics of the Planning Phase**

When the player activates Turn(), the simulation of Cloudbank "pauses," allowing Red to queue a series of actions within a 100-point planning budget. The cost of these actions is non-uniform:

* **Movement**: Consumes planning points based on the distance traveled. Positioning is critical, as backstabbing deals significantly higher damage—a logic derived from the tactical depth of games like Final Fantasy Tactics.  
* **Skill Execution**: Each Function has a specific cost. High-impact skills like Cull() or Tap() consume significant portions of the bar, while "Ping()" is designed for high-frequency use within a single Turn().  
* **The Overload Exception**: A vital technical detail is that the player can always perform one final action, regardless of its cost, as long as they have a single point of the planning bar remaining. This allows for desperate "all-in" maneuvers that deplete the bar entirely.

### **The Recovery Cycle and Strategic Vulnerability**

Once the Turn() is executed, Red performs her queued actions at high speed while the Process moves in slow motion. However, once the sequence is complete, the player enters a "Recovery" phase. During this interval, the action bar must refill, and Red is rendered largely defenseless. All Functions except for Jaunt() (or those upgraded with Jaunt()) are locked, forcing the player to rely on environmental cover and spatial awareness to avoid damage.  
This creates a rhythmic tension. The player fluctuates between being an omnipotent architect of time and a vulnerable fugitive. The design encourages "hit-and-run" tactics, where the player must balance the desire for maximum damage during Turn() with the necessity of being in a safe position once the Turn() ends.

### **The "Slow Death" and Function Overload**

Transistor redefines the concept of "death" in the action-RPG genre. Instead of a traditional game-over screen, the game employs a "slow death" mechanic where Red’s health depletion leads to the temporary loss of her Functions. When health hits zero, the Function in the highest-value Active slot is "overloaded" and removed from the kit until the player survives a set number of encounters or reaches subsequent Access Points.  
This design choice serves several goals:

1. **Systemic Forcing**: It forces the player out of their comfort zone. If a player relies solely on Breach() for long-range kills and loses it, they are forced to find new solutions using their remaining skills.  
2. **Mitigating Frustration**: It allows the player three "chances" to finish an encounter despite poor performance, as they can continue fighting with a reduced kit.  
3. **Tonal Alignment**: The concept of "overloading" fits perfectly within the programming metaphor of the world, suggesting that Red’s hardware is literally breaking down under the strain of the Process.

### **The Ecology of the Process: Enemy Design and AI Behavior**

The Process represents the primary antagonistic force in Transistor—an army of semi-autonomous administrative programs gone rogue. Their design is characterized by a "blind efficiency," as they attempt to deconstruct Cloudbank back into its fundamental building blocks.

### **Hierarchy of Administrative Units**

Each Process unit is designed as a specific tactical obstacle, necessitating different combinations of Functions for efficient neutralization. The "versions" (1.0 to 3.0) of these units signify their evolution into more complex administrative tasks.

| Unit Type | Design Function | Behavioral Evolution (v3.0) |
| :---- | :---- | :---- |
| **Creep** | Standard administrative grunt; basic projectile fire. | Gains "Gravity beams" to pull Red into hazardous areas. |
| **Young Lady** | Mobile harasser; teleports when struck. | Spawns Badcells; high-aggression teleport patterns. |
| **Jerk** | Heavy area-denial; shockwave close-range attacks. | Gains a "Towing beam" to restrict Red’s mobility. |
| **Clucker** | Long-range artillery; timid behavior. | Gains a "Turn() Disruptor" that forcefully ends the planning phase. |
| **Cheerleader** | Tactical force multiplier; projects invulnerability shields. | Gains a "Self-shield" to protect its own structure while shielding others. |
| **Fetch** | High-speed predator; uses "Hunting cloak" invisibility. | Features a "Stunning bark" to incapacitate Red during recovery. |
| **Snapshot** | Information gatherer; fires kinetic "clips". | Uses an "Uncertainty generator" to cloud the player's UI during Turn(). |

### **The Cell Lifecycle and Regeneration**

A critical component of Process AI is the "Cell" phase. When a Process unit is reduced to zero HP, it reverts to a core Cell instead of being immediately removed from the board. If the player does not physically collect the Cell within a few seconds, the unit regenerates at full health. This mechanic forces players to consider their pathing during the execution of a Turn(). One cannot simply kill an enemy from a distance; they must ensure they can reach the Cell to confirm the kill. This "janitorial" aspect of combat prevents the player from becoming too passive or reliant on long-range sniping without risk.

### **Programming as Metaphysics: The World-Building of Cloudbank**

Cloudbank is not a physical city in the traditional sense; it is a digital simulation governed by democratic consensus and executed by the Process. The game design utilizes this fact to create a unified theory of play where mechanics and story are indistinguishable.

### **Computational Terminology as Narrative Framework**

The use of programming language throughout the game serves to alienate the player from traditional fantasy tropes and ground them in a cyberpunk-esque reality.

* **Recursion**: The game’s "New Game+" mode is canonically referred to as Recursion, suggesting that the entire story is a function that is calling itself again with updated variables.  
* **Traces**: The "souls" of the dead are data remnants, or Traces, which the Transistor absorbs to gain their computational power.  
* **The Cradle**: The Transistor’s interface with the city’s hardware, acting as a docking station for administrative overrides.  
* **The Spine of the World**: A colossal Process entity whose presence causes the Transistor’s "voice" to experience lag and slurring, effectively simulating a system-wide hardware failure.

### **The Camerata’s Directive**

The antagonists, the Camerata, represent an elite group of four citizens who sought to impose stability on Cloudbank’s constant flux. Their motive—"When everything changes, nothing changes"—critiques the lack of permanent progress in a society where everything is voted upon daily. The failure of their project and the subsequent loss of the Transistor to Red triggers the system-wide "de-manufacturing" seen throughout the game.

### **Spatial and Aesthetic Design: The Art Nouveau Cyberpunk**

The visual language of Transistor, directed by Jen Zee, intentionally avoids the "laser-guns and space-ships" tropes of typical science fiction. Instead, it leans into the Art Nouveau movement of the late 19th century, characterized by the use of gold, organic patterns, and the "whiplash" motif.

### **Form and Function in Level Design**

The environment design follows a "living painting" philosophy, where the isometric perspective allows for elaborate, hand-painted backdrops that feel both intimate and vast.

| Design Element | Artistic Influence | Functional Purpose |
| :---- | :---- | :---- |
| **The "Whiplash" Motif** | Hermann Obrist / Art Nouveau | Represents the sudden, violent shifts in the city’s digital architecture. |
| **Gilded Architectures** | Gustav Klimt | Distinguishes the "Human" areas from the sterile, white blocks of the Process. |
| **Fixed Arenas** | Arcade Brawlers | Creates "cordoned-off" zones for combat, preventing players from escaping high-stakes encounters. |
| **The Backdoor** | Metaphysical Retreat | Serves as a hub for "Tests" (Challenges), allowing players to master mechanics in a safe, non-narrative space. |

The city is divided into four main districts—Goldwalk, Highrise, Fairview, and Sandbox—each with a distinct palette and tonal shift as the Process consumes the city. As the game progresses, the organic curves of the Art Nouveau districts are replaced by the geometric, minimalist blocks of "processed" space, visually illustrating the loss of the city’s soul.

### **Difficulty Scaling and the Limiter Safeguards**

The "Limiter" system provides a more nuanced approach to difficulty than traditional difficulty sliders. Starting at level 4, players can activate optional handicaps that grant the Process additional powers.

### **The Ten Limiters of the Process**

The design of the Limiters is deeply integrated with the enemy AI, turning each encounter into a more complex tactical puzzle.

| Limiter | Effect on Play | Design Objective |
| :---- | :---- | :---- |
| **Efficiency** | Process deals double damage. | Punishes poor positioning and lack of cover use. |
| **Resilience** | Cells spawn with protective shields. | Requires multi-hit combos to confirm kills. |
| **Abundance** | Process spawns twin Cells upon death. | Increases the "crowd control" requirements of the player. |
| **Initiative** | Cells regenerate significantly faster. | Demands high-speed pathing and movement during Turn(). |
| **Responsibility** | Reduces total MEM capacity. | Forces leaner, more efficient Function builds. |
| **Concentration** | No automatic Turn() activation at low health. | Removes the player’s "safety net," making real-time combat lethal. |
| **Priority** | Recover only one Function per Access Point. | Increases the long-term penalty of losing a battle. |
| **Legacy** | Process spawns corrupted, damaging Cells. | Adds environmental hazards to the "janitorial" phase. |
| **Permanence** | Uninstalling Functions causes them to overload. | Prevents the player from hot-swapping builds between fights. |
| **Superiority** | Process spawns in significantly greater numbers. | Tests the player’s AoE and crowd-management limits. |

These Limiters are narratively identified as "safety interlocks" created by Royce Brackett to keep the Process under control. By activating them, the player is essentially "unleashing" the Process for the sake of greater personal efficiency (represented by the XP bonus).

### **Computational Design Theory: The Finite State Machine of the Process**

In a deep dive into the underlying AI, one observes that the Process units operate on a weighted random finite state machine (FSM) model. Each unit evaluates its potential decisions based on a series of input variables: distance to the player, current health, distance to the closest ally, and the time since its last attack was used.

### **Decision Math and Flowcharts**

The AI behavior can be visualized through a series of conditional loops. For example, a "Jerk" unit might have the following logic:

1. **State: Unaware**: Cycle between "Idle" and "Patrol" animations.  
2. **State: Investigation**: Triggered by player noise or sight-cone entry. Move to point of interest.  
3. **State: Aggressive**: Constant evaluation of distance.  
   * **Condition: Too Close**: Execute a knockback kick and move to a safe radius.  
   * **Condition: Ideal Range**: Cycle between "Oscillating Arm Strike" and "Reload".  
   * **Condition: Out of Sight**: Return to "Investigation" after a set duration.

This structured approach ensures that while the combat is chaotic, the enemies are predictable enough to be countered through the precise planning of the Turn() system. The player’s skill lies in recognizing these FSM patterns and queuing actions that exploit the enemies’ recovery frames or sight-cone blind spots.

### **Synthesis of Systemic Philosophy**

The game design of Transistor is characterized by its rejection of the "path of least resistance". By punishing reliance on a single ability through the "slow death" mechanic and rewarding mechanical variety through lore-unlocks, Supergiant Games created a role-playing experience that is perpetually fresh. The combinatorial logic of the 16 Functions provides a sandbox that allows for radically different playstyles—from stealthy, single-target backstabbers to tanky, lifestealing AoE mages.  
Furthermore, the game’s success as a narrative-driven project is due to its refusal to separate story from mechanics. Cloudbank is the code; the Transistor is the admin tool; and the player’s mastery of the game is synonymous with Red’s reclamation of her city. The "Recursive" nature of the game’s structure serves as the final insight into its design: it is a story built to be re-read, a system built to be re-optimized, and a world built to be re-written. Through this synergy, Transistor remains a benchmark for architectural cohesion in video game design.

1. Transistor (video game) \- Wikipedia, [https://en.wikipedia.org/wiki/Transistor\_(video\_game)](https://en.wikipedia.org/wiki/Transistor_\(video_game\))  
2. Gone to the Country: Storytelling in Supergiant Games' Transistor RPG \- Daniel Quinn, [https://dquinn.net/gone-country-transistor-rpg/](https://dquinn.net/gone-country-transistor-rpg/)  
3. \[Spoilers all\] How programming explains Transistor's overarching story. \- Reddit, [https://www.reddit.com/r/transistor/comments/26m6ut/spoilers\_all\_how\_programming\_explains\_transistors/](https://www.reddit.com/r/transistor/comments/26m6ut/spoilers_all_how_programming_explains_transistors/)  
4. Why We Create – A Transistor Analysis \- Matt Lakeman, [https://mattlakeman.org/2020/01/22/why-we-create-a-transistor-analysis/](https://mattlakeman.org/2020/01/22/why-we-create-a-transistor-analysis/)  
5. Game Design Deep Dive: The Functions of Transistor, [https://www.gamedeveloper.com/design/game-design-deep-dive-the-functions-of-i-transistor-i-](https://www.gamedeveloper.com/design/game-design-deep-dive-the-functions-of-i-transistor-i-)  
6. The Story \- Transistor Wiki \- Fandom, [https://transistor-archive.fandom.com/wiki/The\_Story](https://transistor-archive.fandom.com/wiki/The_Story)  
7. Untitled, [https://transistor.fandom.com/wiki/Functions](https://transistor.fandom.com/wiki/Functions)  
8. Functions \- Transistor Guide \- IGN, [https://www.ign.com/wikis/transistor/Functions](https://www.ign.com/wikis/transistor/Functions)  
9. A Gameplay Analysis of Transistor \- Cliqist, [https://cliqist.com/2014/08/21/a-gameplay-analysis-of-transistor/](https://cliqist.com/2014/08/21/a-gameplay-analysis-of-transistor/)  
10. Functions \- Transistor Wiki \- Fandom, [https://transistor-archive.fandom.com/wiki/Functions](https://transistor-archive.fandom.com/wiki/Functions)  
11. Transistor Review \- We All Become One \- Niche Gamer, [https://nichegamer.com/reviews/transistor-review/](https://nichegamer.com/reviews/transistor-review/)  
12. Transistor: Narrative Through Optional World Building | by Ofir Rosen | Rough Draft: Media, Creativity and Society | Medium, [https://medium.com/rough-draft-media-story-and-society/transistor-a1d978649299](https://medium.com/rough-draft-media-story-and-society/transistor-a1d978649299)  
13. The Untold Story Behind the Design of Transistor \- NoClip : r/Games \- Reddit, [https://www.reddit.com/r/Games/comments/eo8p9y/the\_untold\_story\_behind\_the\_design\_of\_transistor/](https://www.reddit.com/r/Games/comments/eo8p9y/the_untold_story_behind_the_design_of_transistor/)  
14. Transistor Game Review (PC) \- Funcurve, [https://www.funcurve.com/gaming/transistor-pc-review/](https://www.funcurve.com/gaming/transistor-pc-review/)  
15. Combat \- Transistor Wiki \- Fandom, [https://transistor-archive.fandom.com/wiki/Combat](https://transistor-archive.fandom.com/wiki/Combat)  
16. Transistor Review \- Mainstream404 \- WordPress.com, [https://mainstream404.wordpress.com/2021/03/21/transistor-review/](https://mainstream404.wordpress.com/2021/03/21/transistor-review/)  
17. Designing Turn-Based vs Real-Time Game Mechanics \- Mahtgician Games, LLC, [https://mahtgiciangames.com/blogs/the-creative-workshop-game-design-blueprints/designing-turn-based-vs-real-time-game-mechanics](https://mahtgiciangames.com/blogs/the-creative-workshop-game-design-blueprints/designing-turn-based-vs-real-time-game-mechanics)  
18. Turn-Based VS Real-Time \- Game Developer, [https://www.gamedeveloper.com/design/turn-based-vs-real-time](https://www.gamedeveloper.com/design/turn-based-vs-real-time)  
19. GD Column 8: Turn-Based vs. Real-Time | DESIGNER NOTES, [http://www.designer-notes.com/game-developer-column-8-turn-based-vs-real-time/](http://www.designer-notes.com/game-developer-column-8-turn-based-vs-real-time/)  
20. Turn() \- Transistor Wiki \- Fandom, [https://transistor.fandom.com/wiki/Turn()](https://transistor.fandom.com/wiki/Turn\(\))  
21. Sorry if this is a bad question, but how do i make it through combat? : r/transistor \- Reddit, [https://www.reddit.com/r/transistor/comments/1fl4570/sorry\_if\_this\_is\_a\_bad\_question\_but\_how\_do\_i\_make/](https://www.reddit.com/r/transistor/comments/1fl4570/sorry_if_this_is_a_bad_question_but_how_do_i_make/)  
22. How to Play: Transistor \- Functions and Limiters \- YouTube, [https://www.youtube.com/watch?v=QLYkM4YZEMc](https://www.youtube.com/watch?v=QLYkM4YZEMc)  
23. Notes on Transistor \- Gamer Theories \- WordPress.com, [https://gamertheories.wordpress.com/2014/05/27/notes-on-transistor/](https://gamertheories.wordpress.com/2014/05/27/notes-on-transistor/)  
24. Can someone explain the story for me? : r/transistor \- Reddit, [https://www.reddit.com/r/transistor/comments/3ju9mw/can\_someone\_explain\_the\_story\_for\_me/](https://www.reddit.com/r/transistor/comments/3ju9mw/can_someone_explain_the_story_for_me/)  
25. Guide :: The Plot of Transistor \- Steam Community, [https://steamcommunity.com/sharedfiles/filedetails/?id=337587422](https://steamcommunity.com/sharedfiles/filedetails/?id=337587422)  
26. Untitled, [https://transistor-archive.fandom.com/wiki/The\_Process](https://transistor-archive.fandom.com/wiki/The_Process)  
27. Transistor: Cloudbank and Art Nouveau \- Video Game Architecture \- WordPress.com, [https://videogamearchitecture.wordpress.com/2016/06/13/transistor-the-art-nouveau-influence-on-cloudbank/](https://videogamearchitecture.wordpress.com/2016/06/13/transistor-the-art-nouveau-influence-on-cloudbank/)  
28. Introduction \- Transistor Guide \- IGN, [https://www.ign.com/wikis/transistor/Introduction](https://www.ign.com/wikis/transistor/Introduction)  
29. 10 Limiter Run Mega Thread : r/transistor \- Reddit, [https://www.reddit.com/r/transistor/comments/26qgm5/10\_limiter\_run\_mega\_thread/](https://www.reddit.com/r/transistor/comments/26qgm5/10_limiter_run_mega_thread/)  
30. Transistor Strategy, [https://transistor.fandom.com/wiki/Transistor\_Strategy](https://transistor.fandom.com/wiki/Transistor_Strategy)  
31. Explanation of the story? \[SPOILERS\] :: Transistor General Discussions \- Steam Community, [https://steamcommunity.com/app/237930/discussions/0/558756256634168851/](https://steamcommunity.com/app/237930/discussions/0/558756256634168851/)  
32. Story theories, I think I'm onto something. Warning: all of the spoilers. : r/transistor \- Reddit, [https://www.reddit.com/r/transistor/comments/266sj0/story\_theories\_i\_think\_im\_onto\_something\_warning/](https://www.reddit.com/r/transistor/comments/266sj0/story_theories_i_think_im_onto_something_warning/)  
33. Transistor \- Supergiant Games… \- Medium, [https://medium.com/@clydewater/transistor-f839e3b0ca95](https://medium.com/@clydewater/transistor-f839e3b0ca95)  
34. Jen Zee \- Wikipedia, [https://en.wikipedia.org/wiki/Jen\_Zee](https://en.wikipedia.org/wiki/Jen_Zee)  
35. The Art of Hades \- Point'n Think, [https://www.pointnthink.fr/en/the-art-of-hades-en/](https://www.pointnthink.fr/en/the-art-of-hades-en/)  
36. Limiters | Transistor Wiki \- Fandom, [https://transistor.fandom.com/wiki/Limiters](https://transistor.fandom.com/wiki/Limiters)  
37. Limiters \- Transistor Wiki \- Fandom, [https://transistor-archive.fandom.com/wiki/Limiters](https://transistor-archive.fandom.com/wiki/Limiters)  
38. Favorite Limiter Set-Ups :: Transistor General Discussions \- Steam Community, [https://steamcommunity.com/app/237930/discussions/0/540743212324297682/](https://steamcommunity.com/app/237930/discussions/0/540743212324297682/)  
39. Most efficient approach to enemy (and AI) design? : r/gamedesign \- Reddit, [https://www.reddit.com/r/gamedesign/comments/ew1qnt/most\_efficient\_approach\_to\_enemy\_and\_ai\_design/](https://www.reddit.com/r/gamedesign/comments/ew1qnt/most_efficient_approach_to_enemy_and_ai_design/)  
40. How to design a good game AI: from feelings to flowcharts, [https://kokkugames.com/how-to-design-a-good-game-ai-from-feelings-to-flowcharts/](https://kokkugames.com/how-to-design-a-good-game-ai-from-feelings-to-flowcharts/)  
41. Guide :: The Best Function Combos and Builds in Transistor \- Steam Community, [https://steamcommunity.com/sharedfiles/filedetails/?id=3285485657](https://steamcommunity.com/sharedfiles/filedetails/?id=3285485657)