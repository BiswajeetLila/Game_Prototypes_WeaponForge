# Design Reference — Transistor's combat as a touchstone for `6_WeaponForge_TFTransistor`

**Scope:** distilled, transferable design lessons from Transistor's combat, drawn from the video [`01_VIDEO_BREAKDOWN.md`](01_VIDEO_BREAKDOWN.md) + the gameplay frames. This is the analytic layer; the breakdown file is the raw record.

> **Framing caveat (read first):** This document analyzes *Transistor* and proposes *what is worth borrowing*. It does **not** claim anything about the current state of the `6_WeaponForge_TFTransistor` prototype — that lives in the sub-project's GDD, not here. Where it says "for the prototype," read it as *a candidate lesson to evaluate against the GDD*, not a description of what's already built. The prototype's own design decisions and TDD'd combat behavior are the source of truth.

---

## 1. The one insight worth stealing

Transistor's combat is loved (per the reviewer, his favorite indie game of all time) because of a single structural move:

> **One content unit (a Function) has three orthogonal roles — Active, Upgrade, Passive — and the player is under constant, gentle pressure to recombine them.**

Frame [f_00155](frames/f_00155.jpg) prints it verbatim for `Crash()`:

| Slot | `Crash()` does… |
|---|---|
| **ACTIVE** | "Harm and disrupt nearby Targets, exposing vulnerabilities." |
| **UPGRADE** (slotted into another Function) | "Cause most Functions to stun and disrupt Targets." |
| **PASSIVE** | "Gain damage resistance and immunity to all slowing effects." |

So **N Functions** do not give you **N abilities** — they give you a combinatorial space of *(base × upgrade-set × passive-set)* builds. ~16 Functions on the grid ([f_00155](frames/f_00155.jpg)) yield hundreds of meaningfully different loadouts. This is **enormous build depth from a small content budget** — exactly the trait a short game (or a prototype) needs.

The reviewer's own framing: the freeze-planning Turn() and no-basic-attack rules are *"more limiting than freeing"* in isolation — **the fun is entirely in the recombination layer**. Lesson: *the planning/constraint layer is the stage; the combinatorial loadout is the actual toy.*

---

## 2. Why the recombination actually gets used (the part most clones miss)

A deep build system is dead weight if the player finds one good build and never touches it again. Transistor installs **four pressures** that keep hands on the system — this is the genuinely transferable engineering, not the art:

| Pressure | Mechanic | Effect on player behavior | Frame |
|---|---|---|---|
| **Cost ceiling** | `MEM` memory budget gates how much you can install | Forces trade-offs; can't run everything | [f_00155](frames/f_00155.jpg) (MEM gauge) |
| **Forced churn on failure** | "Death" = **lose a Function** for the next few Access Points, not a game-over | Build is *perturbed* exactly when you're already stressed → must adapt mid-crisis; rewards keeping a backup | (transcript) |
| **Novelty injection** | Back-door **challenge rooms** demand builds you'd never assemble voluntarily | Teaches corners of the system the player would otherwise ignore | [f_00185](frames/f_00185.jpg) |
| **Opt-in difficulty for reward** | **Limiters**: turn enemies up (e.g. *Efficiency* = "Process strikes with twice as much power") for an **XP multiplier** (10 limiters → +32% User Level Bonus) → level faster → unlock Functions sooner | Player *chooses* to raise difficulty because the reward loops back into the build system | [f_00190](frames/f_00190.jpg) ⭐ |

The Limiter loop is the cleverest: **difficulty is a player-set dial whose payoff is more build toys.** It is self-policing (the reviewer's words) — no difficulty menu, no shame, and it accelerates exactly the progression the player already wants.

---

## 3. The Turn() planning mode — what it is and what it costs

Turn() = freeze time → queue a sequence of actions against a planning meter → execute in a burst → **vulnerable cooldown** where only movement is allowed ([f_00170](frames/f_00170.jpg) planning, [f_00110](frames/f_00110.jpg) execution).

Design properties worth noting:
- **Predicted damage is shown but not guaranteed** ("can't always account for how enemies will move"). Deliberately leaving the prediction *imperfect* preserves tension — planning is a strong hint, not a solved puzzle.
- **Positioning is the real cost.** The post-Turn cooldown means the question isn't only "what damage do I queue" but "where do I end up standing when I can't act." This converts a turn-based planning fantasy into a spatial one.
- **Diegetic feedback:** Red *hums the soundtrack* during Turn() — the mechanic is reinforced through audio, not just UI. (Cheap, memorable, worth copying in spirit.)

This is the "**T**" lineage in `TF**Transistor**`: a plan-then-execute beat layered over real-time positioning.

---

## 4. Direct relevance to `6_WeaponForge_TFTransistor`

The prototype's name fuses **Transistor** and **TFT (Teamfight Tactics)**. The clean mapping of *which idea comes from where*:

- **From Transistor → the action/loadout layer:**
  - *Turn()-style plan-then-execute* as a combat beat (the named "Transistor" half).
  - *One part → multiple roles* — Transistor's Active/Upgrade/Passive is a direct cousin of a **weapon-forge / part-socket** system where the same crafted part behaves differently by where it's slotted. This is the strongest single borrow and aligns with the repo's "WeaponForge / WeaponCraft" weapon-as-build-unit identity (parts, modifier sockets, reactions — see the sub-project GDD).
  - *Difficulty-for-reward Limiters* — a ready-made template for an **opt-in modifier/curse system** that pays out in faster part/XP unlocks. Self-policing, no difficulty menu.
  - *Soft-death = lose a tool, not the run* — a gentler failure state that forces in-the-moment recombination rather than a hard wipe.
- **From TFT → the economy/roster layer** (not in this video; tracked in the auto-battler research, e.g. [`../anime_autobattlers/`](../anime_autobattlers/) and the AFK Journey / Archero sources): bench, shop, units, positioning round-to-round.

**The synthesis bet** the prototype name implies: *Transistor's combinatorial-part combat plotted onto a TFT-style round/economy meta.* Transistor proves the **combat half can carry a game on build depth alone from a tiny content set** — which is the right risk profile for a prototype.

### What to watch for (Transistor's failure modes, so the prototype avoids them)
1. **Combinatorial UI is hard to read.** The Functions grid + three-slot detail panel ([f_00155](frames/f_00155.jpg)) is dense; a controller game spends real onboarding budget on it. A prototype must teach *"this part does three different things depending on the slot"* explicitly, early, or the depth reads as noise.
2. **Build depth ≠ replay depth.** The reviewer's main critique: despite the combat toy, the game is **linear and "not super replayable"** (~2–4 h). Transistor never had to solve long-tail retention. A TFT-style meta is exactly the layer that *would* — so the prototype is, in principle, fixing Transistor's biggest weakness. Make sure the round/economy loop actually delivers that, or you inherit the linearity without the 4-hour narrative excuse.
3. **Prediction honesty.** Transistor keeps Turn() damage prediction deliberately fuzzy to preserve tension. A prototype that shows *exact* outcomes risks turning combat into a solved spreadsheet; some uncertainty (enemy movement, reaction timing) is a feature.
4. **The toy must be *forced* into use.** Without Transistor's four pressures (§2), players settle on one build. Whatever the prototype's equivalents are (mana/MEM-style cost, modifier churn, challenge modifiers, opt-in curses), at least one must actively *perturb* the loadout, not just *permit* variety.

---

## 5. One-paragraph executive summary

Transistor is a short (2–4 h), linear, isometric action-RPG whose combat is beloved for one reason: **every Function is three abilities in one (Active / Upgrade / Passive), and four overlapping pressures keep the player constantly recombining them** — a memory budget, a soft-death that strips a Function, challenge rooms that demand weird builds, and opt-in **Limiters that trade difficulty for XP**. A plan-then-execute **Turn()** mode sits on top, where the real cost is *where you're standing* when the cooldown locks you out. For `6_WeaponForge_TFTransistor`, the lesson is precise: **steal the "one part, three roles" combinatorial loadout and the "difficulty as an opt-in reward dial," and use the TFT meta layer to supply the long-tail replayability Transistor deliberately never needed.**

---

*Sources: video transcript ([`_hhqPQH01Zw.transcript.txt`](_hhqPQH01Zw.transcript.txt)) + 14 sampled frames. Proper nouns cross-checked against well-documented facts about the 2014 title; the video is a hobbyist retrospective, not an authoritative design doc — treat opinions as one player's, treat the on-screen UIs ([f_00155](frames/f_00155.jpg), [f_00170](frames/f_00170.jpg), [f_00190](frames/f_00190.jpg)) as primary evidence.*
