# Mana = ticks — the firing-cadence economy

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md). **Date:** 2026-06-22 · **Branch:** `weaponforge-tftransistor/post-slice-phase5`.
> **Status:** Decision record (brainstorm). Sibling to [`2026-06-22-directional-keys-and-prototype-controls.md`](2026-06-22-directional-keys-and-prototype-controls.md). Paper-prototype only; numbers placeholder. Built + verified live in [`../../../_paper-prototypes/ftue-beat5.html`](../../../_paper-prototypes/ftue-beat5.html) (Path Y section).

## 1. The mechanic (user-proposed 2026-06-22)
The mana bar is no longer one fill → fire-everything. **It is divided into ticks, one tick per *firing group*:**
- Each **cluster** (1+ adjacent same-element tiles) = **1 tick**, regardless of size.
- Each **lone tile** = **1 tick** (it's just a cluster of size 1).
- Each **combo** (a Key fusing 2–3 clusters) = **1 tick** — so a Key *collapses* the ticks of its inputs (Fire + Water = 2 ticks → Steam = 1 tick).

The hero fires **one group per tick** and completes a **full attack** after the last tick, then the cycle repeats. Worked examples (the user's two screenshots, both verified live):
- Fire · Water · Fire on top, Water · Water below (water clustered) → groups = {Fire}, {Water×3}, {Fire} → **3 ticks**.
- Fire + Water bridged by a Key → {Steam} → **1 tick** (instead of 2).

**Net:** consolidating the board (cluster, combo) reduces tick count → **fewer groups attack faster.** Tempo becomes a second reward axis for the craft, on top of damage.

## 2. Why it's good (5-component)
- **Motivation** ✅✅ — clustering/combos now pay off *twice* (damage *and* tempo); doubles down on "the craft is the engagement."
- **Clarity** ✅ — the segmented bar is a live readout of your build's structure (N segments = N groups); the readout lists each group's damage.
- **Response** ✅ — every tile you add is a real tradeoff (more power vs a slower full attack); consolidating is a skill expression.
- **Fit / Satisfaction** ✅ — sequential per-group fires (with per-tick damage flashes) read as a weapon "spinning up"; a combo visibly shortens the bar.

This is the **concentrate-vs-spread cap** from the 06-21 churn-axis roadmap (§3) — delivered inside the core loop instead of as a separate system.

## 3. Adversarial flags (live, tune around these)
1. **Damage double-dip → large balance swing.** Clustering already multiplies tile damage (~1.9× cmult); collapsing to 1 tick multiplies *throughput* on top. Measured: 5 spread fire = 5 ticks ≈ **6 dmg/tick**; 5 *clustered* fire = 1 tick ≈ **57 dmg/tick** ≈ **9× throughput**. Intended (craft-is-king) but it can trivialise stages and make un-clustered play feel pointless. **Levers:** tune enemy HP to clustered throughput; if still too swingy, change "cluster = 1 tick" → **"cluster = ⌈size/3⌉ ticks"** (a 5-cluster = 2 ticks) to cap the tempo half of the dip. Shipped the clean 1-tick rule; the cap is the knob.
2. **Inverts the usual "fill bar → fire" intuition** (more tiles = *slower* full attack). Mitigated by the segmented bar + a "N ticks → attack" label + per-tick flashes; still deserves its own FTUE beat. Seeded the explanation into Stage 2's copy.
3. **Combos now triple-dip** (resist-bypass + ×3 mega + tick-collapse) and **Splitter strengthens** (raw ×2 with *no* tick cost). Both are fine as payoffs, just now the dominant plays — on-theme, watch in tuning.

## 4. Implementation + numbers
- **Framing chosen: per-group sequential fire.** `volley()` now returns `groups[]` (combos first, then unkeyed clusters), each with its own damage; total dmg = sum (unchanged → parity preserved, `__testPY` still valid). A `cycleIdx` pointer fires `groups[cycleIdx]` when the current segment fills, advances, and wraps with an "attack cycle complete" beat. The bar renders N segments (filled / current / empty).
- **Charge rate — starting value:** `mana += 34` per 640ms interval ≈ **~1.9 s per segment**. Test: does a typical 2–3-group FTUE board feel responsive (a fire every ~2s, full attack ≤ ~6s)? If a full cycle feels sluggish (>~6–7s), raise the per-tick increment (e.g. +50 ≈ 1.3s/segment). Adjust *with* the §3 HP retune.
- **Parity verified live (`__testPY`, totals unchanged):** Bar 36, Star 54, Conduct 36, Tempest 27, Splitter 31. Tick counts verified via the live readout: image-1 board = 3 ticks (Fire 6 · Water×3 29 · Fire 6 = ~41/cycle), image-2 = 1 tick (Steam 16). A group-fire was observed live (Fire 6 dealt, segment marked done, cycle advanced). *(Headless-preview `setInterval` is throttled when the tab is unfocused — fires reliably in a real browser; verify cadence feel on a real device.)*

## 5. Interaction with the open #1 task
The tick economy adds the *tempo* dimension but does **not** replace the **setup COST / placement budget** (still the #1 open fix, 06-21 §6) — the board is still free to build. They compose well: a budget caps how many strong groups you can field, and the tick economy makes each group's *placement* (cluster vs combo vs lone) a tempo decision. Re-run the two persona playtests after the budget lands, now also reading DPS as `total ÷ ticks`.
