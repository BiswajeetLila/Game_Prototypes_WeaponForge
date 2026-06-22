# RuneSurge — FTUE flow redesign + multi-hero progressive reveal

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md). **Date:** 2026-06-23 · **Branch:** `weaponforge-tftransistor/post-slice-phase5`.
> **Status:** Decision record + build. Paper-prototype only. The game's working name is now **RuneSurge**.

## 1. Two paper-proto files
- **`_paper-prototypes/ftue-beat5.html`** — the single-hero FTUE + 3-hero showcase **backup** (kept, now polished — see §2).
- **`_paper-prototypes/RuneSurge-FTUE.html`** — the **primary** demo: a single guided stage flow that introduces heroes one at a time (see §3).

## 2. ftue-beat5 polish pass (WFT-17)
Edits applied to the live demo (and inherited by the RuneSurge copy):
- **Tick speed 2×** (`mana += 20`/100 ms = 0.5 s/segment) on both live sections.
- **Merge glow = the whole hexagon** (drop-shadow + brightness pulse via `filter`, follows the clip-path), not an edge outline. Global (`.pyroot .pycell.mergeready`).
- **Merged tiles (tier > 1) don't delete on click** — only merge or stay. Global (both boards' `onCell`).
- **Enemy panel** is now red (`#2c1417` bg) with a red **"Enemy"** title.
- Intro info-dump removed; **Stage 1 = "Place & Cluster"** (old Place&Fire + Clusters combined) with the new lesson (drop→Battle→watch; adjacent = 1 tick, apart = +1 tick each).
- **The Key** stage = **Bar key only** (text rewritten). **The Wall** stage introduces the **Vee key** (arrows point down, different from Bar). **Star key removed** everywhere. Stages renumbered → Warden is now **stage 4**.
- **History button** at the very bottom ("Older designs & prototypes") un-hides all the historical sections.

## 3. RuneSurge multi-hero reveal (WFT-18)
The marquee change: the player meets heroes **one at a time**, and the late stages **reuse the forgiving 3-hero board** instead of a separate section.

- **Stages 1–4 = Bran solo** (the single-hero tutorial board).
- **Stage 5 "+ Elara"** — hides the solo board, shows the 3-hero board with **2 active heroes** (Bran top, Elara middle; Vex hidden). Bran's board **carries over the runes the player left on the Warden stage**.
- **Stage 6 "Full squad"** — all three heroes, fresh full board, one shared budget. "This is the game."

**Architecture (the two prototype engines are separate IIFEs, so they talk via a tiny bridge):**
- The 3-hero board exposes `window.RSboard = { show, hide, setHeroes(n), carryBran(runes) }`.
- The tutorial's `loadStage` captures the previous board's runes, and for a `multi` stage hides the solo `.pygrid`, calls `RSboard.show()` + `setHeroes(n)` + (stage 5 only) `carryBran(prevRunes)`. Non-multi stages hide the board and restore the solo grid.
- Hero **gating**: each hero has a `hidden` flag; `setActiveHeroes(n)` clears cells, toggles each hero's cell DOM + rail card, and resets the fight. `volleyAll`, `tick`, `hexOutlines`, and the win-check all skip hidden heroes (win = all **active** enemies dead).
- Heroes **reordered** to Bran(0) / Elara(1) / Vex(2) so the reveal is top-down and Bran (the tutorial hero) carries the runes; per-hero colours moved into `HERODEF`.
- The separate "Full Battle" section + the "Continue" bridge were **removed** in RuneSurge (the stages replace them).

## 4. Verified (DOM/state, 2026-06-23)
Stage flow solo→2→3 and back; stage buttons 1–6 + Sandbox; hero order Bran/Elara/Vex; **stage 5 shows 2 heroes / 10 cells with Bran's 2 carried Fire runes**; stage 6 = 3 heroes / 15 cells; combat starts cleanly with Vex hidden; no console errors. (Live battle *timing* not watched — preview throttles `setInterval` when backgrounded — but every structural input is verified.)

## 5. Open / next
- **Playtest the full flow** foreground (the one thing the preview can't show me).
- Carried Bran runes count against the **shared budget** on stage 5 — may tighten Elara's room; watch in playtest. Stage 6 starts fresh (doesn't carry stage 5).
- Still parked for the post-demo rebalance: **WFT-12/13/14** (round loop, verb-space, seam symmetry) + the **WFT-11 resist puzzle** (forgiving tuning is the demo default).

## 6. Same-day refinements (2026-06-23 · WFT-19 + budget)
- **Board↔rail alignment fixed:** rail cards are a fixed 76 px (the hero-band height) with the board top-aligned, so each hero's name lines up with its hex band whether 2 or 3 heroes show (verified ~4 px on both files).
- **Stage 6 carries Bran + Elara** from stage 5 (was a fresh board) and reveals **Star + Splitter** in the tray — only at this stage.
- **Global "new" badge:** a faint blinking "new" tag on any tray piece not yet placed (shared `window.RSseen`, clears on first placement), across both the tutorial and squad trays — so Star/Splitter flag "new" in stage 6, Fire doesn't once used.
- **Forge budget 15 → 30** (generous): the forgiving demo wants room to deck out all three heroes, especially Vex at stage 6 after Bran+Elara's runes carry over. Real economy/constraint stays parked (WFT-11 / round loop).
- **History button** kept in `ftue-beat5.html` only (removed from RuneSurge); the **"Model (Path Y)" note** removed from both.
