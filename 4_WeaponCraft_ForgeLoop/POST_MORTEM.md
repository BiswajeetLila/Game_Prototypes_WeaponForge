# ForgeLoop — Post-Mortem

**Date abandoned:** 2026-05-25
**Build at abandonment:** `Prototype/dist/FORGELOOP_0.1.0.html` @ commit `192c920`
**Branch:** `forgeloop/mvp-0.1.0-anvil-only`
**Verdict:** Direction rejected by playtesters. Core thesis was wrong. Archived as a learning artifact.

---

## What ForgeLoop attempted

ForgeLoop was variant **#4** in the WeaponCraft prototype family — a fork of the BASE-A1 auto-battler (variant #2). The bet was that **menu-based crafting was the source of mid-session boredom** in earlier variants, and that replacing it with a **Loop-Hero-style circular forge ring** plus juicy modal minigames would restore engagement.

The ring layout: 8 hex cells around a central forge heart. Smelter (top) and Inspector (bottom) fixed. Six customizable cells where the player dragged station tiles (Bellows, Anvil, Quench, Engraver). Tapping "Start Lap" launched a glowing ingot clockwise around the ring; at each station, a **modal minigame interrupted** the lap for 3–7 seconds:

- **Bellows** — 4 rhythm taps in time with a metronome → "heat tag" combo enabler.
- **Anvil** — 5 swinging-hammer taps inside a green zone → +ATK per hit, ★ crit bonus on 5/5.
- **Quench** — stop a bouncing marker inside a green band → +DUR, ingot visibly cools.
- **Engraver** — trace a fire/ice/pierce glyph in one stroke on a 200×200 canvas → element tag and adjective in weapon name.

Lap completes after one full revolution. Player commits with a 4-second anvil-RING reveal animation (anvil rises → white flash + screen shake → weapon SVG rises in a particle column → name banner unfurls → stats type in → weapon arcs to hero portrait). Combat resumes with the new weapon visibly mounted on Bran's card; per-strike station pulses on the ring, ★ markers on crits, element bursts on hits.

After each wave clear, "Forge Again? (5🪙)" re-enters the loop and stacks stats additively.

---

## What shipped before abandonment

**MVP (Round 1):** Anvil-only forge loop end-to-end.
- 14 commits, ~1900 lines in a single self-contained HTML file.
- Ring geometry + drag-drop placement.
- Ingot travel animation.
- Minigame framework (modal shell + promise-based result contract + stats accumulator).
- Anvil minigame with full feedback (hit/miss banner, zone flash, spark burst, hammer pulse, shake on miss).
- Weapon name generator (Crude/Honed/Tempered/Masterwork × Element × Base).
- SVG weapon sprite (blade + tint + glyph overlay).
- 4-second reveal climax.
- Hero card weapon mount + combat hooks (per-strike pulse, ★ crit, element burst).
- Forge-again prompt + additive stat stacking.
- 15-event console schema + `window.__forgeLoopStats()` snapshot.

**Round 2:** Bellows + Quench + Engraver minigames added so the spatial/combo system could be felt:
- Bellows-before-Anvil = +30% Hot Strike.
- Engraver writes element tag → weapon name adjective + sprite glyph + combat burst color.
- Quench cools the ingot (orange → blue) + adds DUR.

Total feature set delivered: spatial ring builder, 4 minigames, 4-stat weapon model, additive stacking, full event instrumentation, polish pass on Anvil feedback layer.

---

## Why it failed — playtester verdict

**The core thesis was wrong.** ForgeLoop assumed minigames-as-juice would re-engage players. The reality:

> "We don't want minigames inside a game. It's too much effort, and people churn out fast. We need things to flow cohesively in one game."

Breaking that down into what playtesters actually felt:

### 1. Minigames are micro-games, not gameplay

Each lap turned a single craft into 3–7 modal interrupts. Even at ~5s per minigame, four chained minigames = 20+ seconds of being yanked out of the main loop into mode-switched submini-experiences. The cognitive cost of "what is this minigame asking me to do?" reset on every station. Players described it as **playing four games in series** rather than playing one game.

### 2. Modal pause kills momentum

The design treated combat as turn-based (inherited from BASE-A1) precisely so the modal interrupt wouldn't fight against continuous flow. That mitigation held on paper but failed in practice — the modal still **interrupts the player's sense of building a weapon**. A craft should feel like one continuous gesture; ForgeLoop's craft was a sequence of disconnected discrete tasks.

### 3. Mastery cost too high for too little payoff

Each minigame demanded its own muscle memory: timing tap for Anvil, rhythm tap for Bellows, single-tap stop for Quench, free-trace gesture for Engraver. Players were spending mastery time on **station mechanics, not on game decisions**. The interesting decision (which stations, in which order) sat behind a layer of execution skill, and the execution skill didn't reward growth — once you can hit 5/5 Anvil, the minigame becomes a tax.

### 4. Churn risk

Mobile players have ~10–15 seconds to decide if a session is worth continuing. ForgeLoop's first forge takes 25–35 seconds plus 4-second reveal plus combat. Three of those seconds are spent on **the FIRST modal minigame** before the player has seen combat happen. If the first minigame doesn't immediately click, the player bounces — and a player who's already on a phone has zero patience for "wait, let me explain the rhythm tap."

### 5. Polish wasn't the bottleneck

The MVP shipped without per-swing visual feedback on Anvil. We added 5 layers of feedback (banner, zone flash, sparks, hammer pulse, shake) and it felt better — but the playtester signal didn't move. The minigame felt **better-juiced**, not **more fun**, because the structural problem (modal interrupt + mode-switch cost) was upstream of feedback strength.

---

## What we learned (carry forward)

1. **Crafting must remain inside the combat layer, not adjacent to it.** The next variant should explore mechanics where weapon-building happens *during* combat — passive station effects, drag-to-equip mid-fight, or environmental forge interactions — anything that doesn't pause the main loop.

2. **Minigames have a hard ceiling on mobile.** Use sparingly (one per long session, not one per craft). When you do use one, make it **the** craft, not part of it. (Hearthstone has zero minigames inside Hearthstone.)

3. **Sensory polish ≠ engagement fix.** The 5-layer Anvil feedback pass proved you can make a minigame *feel* sharp and still have players bounce. Don't conflate "this feels good per tap" with "this is fun to do for 30 seconds."

4. **Loop-Hero-style spatial placement is appealing in isolation, but breaks when each cell triggers a modal.** Loop Hero works because the loop runs at full speed and the player makes placement decisions *during* the run, in the same UI layer. ForgeLoop's modal interrupt fundamentally is not the Loop Hero mechanic — it's "Loop Hero but every tile pauses the game to play Cooking Mama."

5. **Hot Strike / element-burst combos were the most interesting decisions the build offered.** Spatial ordering (Bellows-before-Anvil = +30% ATK) is the seed of a real mechanic. Future variants should keep the **spatial combo idea** but strip the **modal minigame substrate** out from under it.

6. **The reveal climax landed.** The 4-second anvil RING + name banner + arc-to-hero animation produced visible dopamine in every tester. **Preserve this pattern** — every variant should have a payoff moment of similar shape, even if the build-up changes completely.

7. **Forge-again-to-stack-stats was directionally right.** Persistent weapons that grow across waves felt good. The mechanism (re-entering a lap) was wrong; the principle (depth-per-weapon over breadth-of-weapons) was right.

---

## What lives on for future variants

- **Combat layer** — turn-based auto-battle from BASE-A1 unchanged. Hero card + ult gauge + affinity telegraph all reusable.
- **Weapon model** — `{name, atk, crit, dur, element, elementIcon, elementColor, layers}` shape is good. Keep.
- **Weapon name generator** — quality × element × base type produces enough variety. Reusable.
- **SVG sprite composite** — layered blade + tint + glyph rendering pattern is reusable for any forging system.
- **Reveal animation timeline** — 4-second anvil RING climax is reusable on any "you forged something" moment.
- **Console event schema** — generic enough to slot into the next variant with renames.
- **Lessons above** — drive variant #5 design.

---

## Files for reference

- `Prototype/dist/FORGELOOP_0.1.0.html` — playable build, frozen at `192c920`. Open in any browser to verify lessons. The Anvil feedback pass is the cleanest illustration of "polish-is-not-fun-fix."
- `docs/superpowers/specs/2026-05-24-forgeloop-design.md` — original frozen design spec (the thesis).
- `docs/superpowers/plans/2026-05-24-forgeloop-0.1.0.md` — 18-task implementation plan (the execution).
- `VARIATION.md` — 3-bullet original delta vs base GDD.
- `HANDOFF.md` — original session handoff doc.

---

## Status

**Closed.** No more work on this branch. Variant #4 archived as a learning artifact. Next variant (#5) should design from the lessons above.
