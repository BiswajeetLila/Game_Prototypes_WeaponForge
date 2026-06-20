# Transistor — Weapon Design Specification

### The Transistor & the Function System

**Primary video source:** https://www.youtube.com/watch?v=_hhqPQH01Zw — *"Supergiant's Underrated Masterpiece | Reflections on Transistor"* (Livewire Voodoo)
**Subject:** *Transistor* (Supergiant Games, 2014). Director: Amir Rao · Creative director: Greg Kasavin · Art director: Jen Zee.
**Scope:** This document specifies the design of the game's **single weapon — the Transistor — and the modular "Function" system that runs on it.** Enemy, narrative, and world systems are referenced only where they directly constrain how the weapon is used. Synthesized from the video (transcript + on-screen UI frames) and two source-cited research dossiers in this folder.

---

## 1. Concept overview

The Transistor is the game's **only** weapon. It is not a melee/ranged item among many — it is a programmable platform. Every offensive, defensive, and utility capability the player ever gains is expressed as a **Function** installed into the weapon. Diegetically, the Transistor is a great sword-shaped device that has absorbed the consciousness ("Trace") of the protagonist's companion and acts as the narrator; mechanically, it is the **build canvas**.

The core design move — and the reason the weapon carries an entire game on a tiny content budget:

> **Every Function can be installed in one of three roles — Active, Upgrade, or Passive — and behaves completely differently in each.** A small library of 16 Functions therefore expands into a combinatorial space of builds rather than a flat list of 16 abilities.

On-screen confirmation: the **Functions / MEM** loadout screen (frame [`frames/f_00155.jpg`](frames/f_00155.jpg)) shows the 16-Function grid, the `MEM` capacity gauge, and a DETAILS panel that prints all three slot-effects for the selected Function.

---

## 2. Design origin & pillars

- **Origin:** The team drew from **collectible card games (notably *Magic: The Gathering*)** — the early concept was a "deck" of abilities the player would draw from. This matured into a pool of **16 Functions**, each derived from the **Trace** (data-soul) of a prominent Cloudbank citizen absorbed by the weapon.
- **Pillar 1 — Horizontal, not vertical, progression.** The weapon rejects "invest XP to level one skill." Power comes from **recombination**, not from grinding a single ability upward.
- **Pillar 2 — Forced experimentation.** The systems are built so a player *cannot* comfortably find one optimal build and coast (see §8–§9). Variety is mechanically pushed and narratively rewarded.
- **Pillar 3 — Story ≡ system.** The programming metaphor is literal: Functions are written like code calls (`Crash()`, `Ping()`…), installing/removing is "compiling" a kit, "death" is hardware overload, New Game+ is "Recursion." The weapon's fiction and its mechanics are the same object.

---

## 3. The Function — the core unit

- **Count:** 16 Functions (the complete library).
- **Naming:** Each is stylized as a programming function call — `Crash()`, `Breach()`, `Spark()`, `Jaunt()`, `Bounce()`, `Load()`, `Help()`, `Mask()`, `Ping()`, `Switch()`, `Get()`, `Purge()`, `Flood()`, `Cull()`, `Tap()`, `Void()`.
- **Balance intent:** No Function is strictly superior. A Function's value is **contextual** — it shifts with the slot it occupies and the current enemy composition. The 16 deliberately span familiar action-RPG archetypes (single-target, AoE, stun, charm, long-range, lifesteal, stealth, summon) but each is re-expressed so it can serve in any of the three roles.

---

## 4. The three-slot architecture

The weapon exposes **Active slots**, each Active slot carries its own **Upgrade sub-slots**, and there are separate **Passive slots**. The same Function dropped into each role does something different:

| Slot | Operational mechanic | Design implication |
|---|---|---|
| **Active** | The base ability you trigger — strike, projectile, dash, summon, debuff. | Defines the primary interaction in both real-time and Turn() (§7). |
| **Upgrade** | Installed *into* an Active Function; injects that Function's secondary property into the host (e.g. add stun, chaining, AoE, lifesteal). | Lets the player patch an Active's weakness or amplify a strength through synergy. Most Functions, as an Upgrade, modify "most Functions." |
| **Passive** | A persistent, global buff to the player (regen, damage resistance, faster Turn() recovery, larger planning bar, etc.). | "Under-the-hood" stabilization that costs no input bandwidth during combat. |

**Worked example (`Crash()`, matches the in-game DETAILS panel in [`frames/f_00155.jpg`](frames/f_00155.jpg)):**
- *Active:* harm and disrupt nearby targets, exposing vulnerabilities.
- *Upgrade:* causes most Functions to stun and disrupt targets.
- *Passive:* grants damage resistance and immunity to slowing effects.

One Function → a disruptive opener, *or* a universal stun-rider on any other attack, *or* a defensive passive. That tri-use is the entire engine.

---

## 5. The MEM (Memory) economy

Installing Functions costs **Memory (MEM)** — the weapon's hardware capacity.

- Each Function has a fixed **MEM cost** (see §6). Costs apply in **every** slot, so a high-value combo (e.g. a 4-MEM Active carrying two 4-MEM Upgrades) consumes a large share of capacity.
- **Total MEM scales with User Level** (gained via XP). Early builds are capacity-starved; late builds can afford devastating multi-slot synergies.
- MEM is the **balancing constraint** that prevents stacking every strong effect at once — it forces trade-offs and is what makes the combinatorial space a *choice* rather than a checklist.

→ Visible as the segmented `MEM` gauge on the left of the loadout screen ([`frames/f_00155.jpg`](frames/f_00155.jpg)).

---

## 6. Full Function reference

MEM costs and slot effects below follow the source-cited research dossier; the `Crash()` row is independently confirmed by the in-game UI frame.

| Function | MEM | Active slot | Upgrade slot | Passive slot |
|---|:--:|---|---|---|
| **Crash()** | 1 | Harm/disrupt nearby targets; expose vulnerabilities | Causes most Functions to stun/disrupt targets | Damage resistance (~25%) + immunity to stun/slow |
| **Ping()** | 1 | Fire rapid kinetic charges in a line | Reduces Turn() planning cost & charge time | Move 200% farther in a single Turn() |
| **Mask()** | 1 | Conceal user; amplify next action by 200% | Raises potency of backstab effects | Concealment + speed boost after a kill |
| **Get()** | 1 | Magnetic pull (stronger at distance) | Makes most Functions pull targets out of position | Draw in Cells faster and from farther |
| **Spark()** | 2 | Launch unstable shells that split into particles | Subdivides most Functions for wider results | Spawns a Copy/decoy when attacked, to divert targets |
| **Bounce()** | 2 | Ricocheting bolt jumps between targets | Adds a chain-reactive effect to most Functions | Deflecting shield negates one instance of damage |
| **Switch()** | 2 | Alter a target's allegiance (charm) | Integrates allegiance-altering subroutines into Functions | Spawns a friendly Badcell when retrieving Cells |
| **Purge()** | 2 | Seeking parasite dismantles target from within (DoT) | Applies corruption/slow to most Functions | Retaliate ~10 damage automatically when struck |
| **Breach()** | 3 | Pierces targets across long distances | Raises range & velocity of most Functions | +120% planning potential (longer Turn() bar) |
| **Jaunt()** | 3 | Immediate transport to a nearby location (dash) | Allows Functions to be used during Turn() recovery | +125% Turn() recovery speed |
| **Load()** | 3 | Place a volatile Packet; strike to detonate | Increases AoE of most Functions | Generates Packets automatically (~every 10 s) |
| **Flood()** | 3 | Project a disintegrating storm sphere (lingering) | Adds lingering destructive trails to Functions | Regenerate HP when not in Turn() recovery |
| **Help()** | 4 | Summon a "Friend" (Luna the Fetch) to aid | 50% chance Cells don't spawn on kill | 25% chance to enter SuperUser state in Turn() |
| **Cull()** | 4 | Strike targets upward with massive force | Raises kinetic impact / effect duration | Deal 150 damage on contact during Turn() movement |
| **Tap()** | 4 | Siphon life from targets in an area | Applies lifesteal to most Functions | +150% total life points |
| **Void()** | 4 | Stackable debuff to target defense & attack | Augments potency & effects of most Functions | +125% base damage output |

*(Ordered by MEM cost for readability. The four 1-MEM Functions are the cheap, spammable backbone; the four 4-MEM Functions are build-defining capstones.)*

---

## 7. Turn() — the weapon's temporal mode

The weapon operates in a constant oscillation between **real-time** action and **Turn()**, a frozen tactical planning mode. This hybrid resolves the weakness of each: real-time alone is too chaotic for deep tactics; pure turn-based feels disconnected from the kinetic character.

**Planning phase:**
- Activating Turn() **freezes the simulation**; the player queues a sequence of actions against a finite **planning bar (≈100-point budget)** shown at the top of the screen ([`frames/f_00170.jpg`](frames/f_00170.jpg)).
- **Every action costs budget, including movement** (cost scales with distance). Positioning is a first-class tactical resource — **backstabs deal substantially more damage**, so where you move inside the plan matters as much as which abilities you fire.
- **Per-Function cost varies:** cheap Functions like `Ping()` are designed for high-frequency use within one Turn(); heavy hitters like `Cull()` / `Tap()` eat large chunks of the bar.
- **Overload exception:** as long as **one point** of bar remains, the player may queue **one final action regardless of its cost** — enabling all-in finishers that empty the bar.
- **Estimation, not guarantee:** the predicted outcome is an estimate. Because enemies still move during execution, plans can miss (e.g. a teleporting target dodges the opening hit). The deliberate imperfection preserves tension.

**Execution & recovery:**
- On execute, the player performs the queued actions at high speed while enemies move in slow motion.
- Afterward comes the **Recovery period**: the bar must refill and the player is **largely defenseless — all Functions are locked except `Jaunt()`** (or any Function carrying a `Jaunt()` upgrade). The only safety is movement and cover.
- This creates the weapon's signature **rhythm**: alternating between *omnipotent planner* and *vulnerable fugitive*. The skill expression is balancing maximum queued damage against ending the Turn() in a safe position — i.e. **hit-and-run** is the intended idiom.

**Combat-loop constraint on weapon use (the "Cell" janitorial rule):** a defeated enemy collapses to a **Cell** rather than dying outright; if the player doesn't physically reach and collect it within a short countdown, the enemy **regenerates at full health**. This forces the player to **path toward kills during a Turn()** rather than sniping safely from range — directly shaping how movement budget is spent inside the plan.

---

## 8. Function Overload — the "slow death" failure model

The weapon redefines death. There is **no instant game-over** from losing all health:

- When health hits zero, the **highest-MEM-cost Active Function "overloads"** and is **removed from the kit** until the player survives a set number of encounters / reaches subsequent **Access Points** (the in-world save/respec terminals — frame [`frames/f_00125.jpg`](frames/f_00125.jpg)).
- Effects of this design:
  1. **Systemic forcing** — losing your crutch Function (e.g. a long-range `Breach()`) forces an immediate improvised build from what remains.
  2. **Frustration mitigation** — you effectively get multiple "lives" within a fight at the cost of a shrinking kit, rather than a hard restart.
  3. **Tonal alignment** — "overloading" reads as the weapon's hardware buckling under strain, fitting the computational fiction.

---

## 9. Experimentation incentives (why the player keeps recombining)

A deep build system is inert unless something forces its use. The weapon design layers four pressures:

| Pressure | Mechanic | Behavioral effect |
|---|---|---|
| **Capacity ceiling** | MEM budget (§5) | Can't run everything → constant trade-offs |
| **Forced churn on failure** | Function Overload (§8) | Build is stripped mid-crisis → adapt on the fly; keep a backup |
| **Narrative reward for variety** | **Lore unlock** — a citizen's full biography unlocks only after their Function has been used in **all three slots** (Active, Upgrade, Passive) | Story content is gated behind mechanical breadth → curiosity drives experimentation |
| **Practice sandbox** | The **Backdoor** hub hosts optional **Tests/Challenges** | Safe, non-narrative space to master combos the campaign wouldn't force |

The lore-unlock hook is the most elegant: it makes "try this Function three different ways" a *story* action, not a chore.

---

## 10. Limiters — opt-in difficulty bound to the weapon's progression

**Limiters** are optional handicaps (unlocking around User Level 4) that **buff the enemy in exchange for an XP bonus** — faster leveling, hence faster MEM/Function unlocks. Fiction: they are "safety interlocks" on the enemy force that the player chooses to *switch off*. This is self-policing difficulty with no shame menu — the reward loops straight back into the weapon's build economy.

| Limiter | Effect when active | XP bonus |
|---|---|:--:|
| **Superiority** | Enemies spawn in significantly greater numbers | 6% |
| **Efficiency** | Enemies strike with double power | 4% |
| **Responsibility** | Reduces total MEM (−6 or more) | 4% |
| **Priority** | More Functions overload at once; slower recovery | 4% |
| **Permanence** | Uninstalling a Function at an Access Point overloads it (no free hot-swaps) | 4% |
| **Abundance** | Enemies spawn twin Cells on death | 2% |
| **Initiative** | Cells regenerate much faster | 2% |
| **Resilience** | Cells spawn with protective shields | 2% |
| **Concentration** | Turn() no longer auto-activates at low health (removes the safety net) | 2% |
| **Legacy** | Cells spawn as Corrupt Cells that damage the player on contact | 2% |

**All ten active → +32% User Level bonus.** Independently confirmed on the in-game **Process Limiters** screen (frame [`frames/f_00190.jpg`](frames/f_00190.jpg)): *"10 Limiters Now In Use / User Level Bonus Total: 32%."* The completionist marker for clearing the game with all ten on is the **Risk() achievement.**

Note how several Limiters attack the weapon system itself — **Responsibility** shrinks MEM, **Priority** worsens Overload, **Permanence** blocks build hot-swapping — so raising difficulty also raises the demand on build discipline.

---

## 11. Recursion (New Game+) — duplication & stacking

The post-campaign mode is **Recursion**: it retains all character progress and, critically, grants **duplicate copies of Functions**. This unlocks build space impossible on a first run:

- Players can construct **~32-MEM kits** and **stack multiple copies of the same Function** — e.g. `Void()` carrying another `Void()` as an Upgrade for a multiplied damage debuff.
- Fiction frames it as the story "calling itself again with updated variables" — the system is explicitly built to be re-optimized.

---

## 12. Combinatorial scale & design summary

Sixteen Functions, each usable in three roles, across multiple Active slots with nested Upgrade sub-slots and separate Passive slots, gated by MEM — research cites on the order of **~22.28 trillion** distinct configurations. The headline number matters less than the principle it demonstrates:

> **Maximum build depth from a minimum content set.** Sixteen well-designed modular units, made tri-purpose and placed under constant pressure to be recombined, deliver more tactical variety than libraries many times larger. The weapon's real "content" is not the 16 abilities — it is the *relationships* between them.

**The reusable design lessons (weapon-agnostic):**
1. **Make one content unit multi-role** (Active/Upgrade/Passive) → multiplicative, not additive, depth.
2. **Gate combinations with a scaling resource** (MEM) → builds are choices, and progression literally enlarges the design space.
3. **Force the system into use**, don't merely permit variety — capacity limits, a failure state that strips your build, content gated behind breadth, and opt-in difficulty whose reward feeds back into the build economy.
4. **Layer a plan-then-execute beat over real-time**, where the true cost is *positioning at the end of the plan*, and keep prediction honestly imperfect to preserve tension.
5. **Bind fiction to mechanics** so learning the weapon is also experiencing the story.

---

## 13. Sources & confidence

- **Primary video:** https://www.youtube.com/watch?v=_hhqPQH01Zw (transcript + UI frames `f_00155`, `f_00170`, `f_00190`, `f_00125` in [`frames/`](frames/)).
- **Research dossiers (this folder):** *"Technical Synthesis and Systemic Analysis of Transistor"* (41 cited references) and *"Transistor: Comprehensive Game Design Specification"* (per-claim **Genuine Source** / **Assumed** tagging). Function MEM costs and slot effects, Limiter effects + XP bonuses, and Recursion details are taken from these and tagged by the originals as drawn from in-game/wiki data.
- **Confidence flags:**
  - *High (UI-confirmed):* the three-slot system; `Crash()` slot effects; Turn() planning bar + recovery vulnerability; Limiters exist and all-ten = +32%.
  - *Sourced but not first-party-verified here:* exact per-Function MEM costs and percentages; the ~22.28-trillion combination count; the level-4 Limiter unlock and Risk() achievement. Treat exact numbers as research-cited, not measured in-engine for this document.
