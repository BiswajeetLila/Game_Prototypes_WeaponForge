# WFT-11 retune — resists make the build a puzzle (+ darker hex fills)

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md). **Date:** 2026-06-22 (latest of the 06-22 set) · **Branch:** `weaponforge-tftransistor/post-slice-phase5`.
> **Status:** Decision record + build + tune. Paper-prototype only (`ftue-beat5.html`, "3-Hero Board"). Delivers **WFT-11**; builds on the stakes from `2026-06-22-stakes-incoming-damage-and-winlose.md`.

## 1. The problem the retune had to fix
With no resists, the optimal board is always "5 of one element, clustered" (30 DPS) — it trivially wins every lane regardless of budget. Pure HP/atk tuning can't fix that: it only changes *how fast* the one degenerate build wins. **Building had no depth.** So the retune's substance is not numbers — it's giving enemies **resists** (already coded; combos/Keys bypass them) so each lane becomes a matchup puzzle, then tuning HP/atk so a *matched* build barely wins and a *lazy mono* build loses.

## 2. The tuned encounter (3-lane puzzle)

| Lane | Hero HP | Enemy | Enemy HP | atk / cadence | Resist | Intended answer |
|---|---|---|---|---|---|---|
| Elara | 85 | Wisp | 100 | 8 / 1.1 s | **Fire** | non-Fire cluster (Storm/Water) *or* any combo |
| Bran | 130 | Brute | 200 | 15 / 1.3 s | — (raw lane) | high sustained DPS — big cluster / full board |
| Vex | 90 | Shade | 85 | 9 / 1.1 s | **ALL** | a **Key combo is mandatory** (raw is quartered; combos bypass resist) |

- **Budget tightened 18 → 15.** A matched build costs ~12–14 (e.g. Elara Storm×4 = 4, Bran Fire×5 = 5, Vex Bar+Fire+Water = 5 → 14), so the shared budget forces real allocation; over-investing one lane starves another.
- Resists/weaknesses are now **telegraphed** in the foe readout (`resist Fire · ⚔8/1.1s`) — required for the player to plan (Clarity).
- Costs unchanged (elem 1 · Splitter 2 · Bar/Vee 3 · Star 5).

## 3. Why this works (verified damage, then race math)
Damage is computed instantly by `volleyAll`, so the puzzle was verified without the real-time clock:

| Build | vs | Volley |
|---|---|---|
| Elara 3×Storm | Fire-resist Wisp | **~18** (full) |
| Elara 3×Fire | Fire-resist Wisp | **~5** (×0.25) |
| Vex Bar→Steam | resist-ALL Shade | **~16** (combo bypasses) |
| Vex 3×Fire | resist-ALL Shade | **~5** (×0.25) |

Race math with these numbers: matched ≈ 18–30 DPS → kills in ~5–7 s and survives; lazy/wrong ≈ 5–7.5 DPS → kills in ~17–20 s but the enemy downs the hero first (~11–12 s). **Matched wins, lazy loses** — the intended gap. Estimated win margins: Elara ~52 %, Vex ~52 %, Bran ~41 % HP remaining (Bran/Brute is the tightest lane, by design).

## 4. Cosmetic: darker hex interiors
Per the user, empty hexes are now filled with the hero's identity colour ~3 shades darker (`HEROFILL = ['#3e444d','#322a54','#4a3820']`), via a `--hf` CSS var on each cell so the element fill still overrides when a tile is placed. Result: solid hero-tinted hexes (dark fill + brighter outline); element colour still shows on placed tiles. Extends the WFT-8 colour-coding.

## 5. Verification & caveat
- ✅ Verified instantly (no clock): config (budget 15, HP 85/130/90, foe 100/200/85), resist telegraphs, the four damage cases above, per-hero empty-hex fills, no console errors.
- ⚠️ **Win/lose *margins* are estimates.** The full real-time race can't be watched here (the headless preview throttles/suspends `setInterval` when backgrounded). The *damage* and *resist* math is verified exact; the *timing* margins need the user's foreground playtest. Likely refinements: Brute may need to hit slightly harder (tighten Bran's lane toward <30 % remaining), or Shade's resist-ALL may feel too binary.

## 6. Open / next
- **Playtest** to confirm/adjust margins (this is iterative — numbers above are tuned-by-estimate).
- Next ticket: **WFT-12 — round loop** (result → shop → rebuild), the meta layer that makes the matchup puzzle repeat with escalation.
- `weak`-element ×3 combo bonuses are coded + telegraphed but unused — a lever for later depth (reward a *specific* combo per enemy).
