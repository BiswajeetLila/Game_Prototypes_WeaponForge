# FTUE demo scope + forgiving showcase tuning

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md). **Date:** 2026-06-22 (latest of the 06-22 set) · **Branch:** `weaponforge-tftransistor/post-slice-phase5`.
> **Status:** Scope decision + tuning. Paper-prototype only (`ftue-beat5.html`). Sets the plan for a first-look demo (next day) and re-tunes the 3-hero showcase to be forgiving.

## 1. Scope decision — what ships for the first-look demo
The demo's job is: **a first-time viewer understands the game in a few minutes and feels a win.** That needs a teaching FTUE → a forgiving showcase battle. It does **not** need the economy/meta.

- **KEEP:** the single battle (3-hero showcase) as the payoff.
- **BUILD (today):** a path from the existing single-hero FTUE (Place & Fire → Clusters → Merge → The Key → The Wall) into the 3-hero showcase — **WFT-15**.
- **SKIP for the demo, parked for the post-demo "real rebalancing" phase:** **WFT-12** round loop, **WFT-13** modifier verb-space, **WFT-14** seam symmetry + shop polish. These answer "does the meta have legs" — the wrong question for a first impression.

Rationale: a round loop / shop stacks several systems on numbers not yet validated by real play. Validate the core (build → race → win) with a forgiving demo first; invest in meta after.

## 2. Forgiving showcase tuning (WFT-16)
Goal (user): *"normal raw tiles may or may not beat them, but any hero who does anything — merge, key combine, cluster — wins. If they learn ANYTHING, they win."*

Implementation: **removed resists**, lowered enemy HP/atk and hero HP on the 3-hero board.

| Hero | HP | Enemy | Enemy HP | atk / cadence |
|---|---|---|---|---|
| Elara | 60 | Wisp | 55 | 8 / 1.2 s |
| Bran | 65 | Brute | 65 | 8 / 1.3 s |
| Vex | 60 | Shade | 55 | 8 / 1.2 s |

Verified via damage readouts (DPS = volley ÷ groups):

| Play | DPS | Outcome |
|---|---|---|
| Raw mixed (3 different elements = 3 ticks) | **6** | coin-flip / slight loss |
| Cluster of 3 (1 tick) | **18** | clear win |
| Merge → Fire II (1 tick) | **24** | clear win |
| Key combo → Steam (1 tick) | **~16** | clear win |

Enemy DPS ≈ 6.2–6.7, hero HP 60–65 → raw (6 DPS) races to a near-dead-heat (leans loss), any technique (16–30 DPS) wins with margin. The race timing wasn't watched live (preview throttles `setInterval` when backgrounded); the **damage inputs are verified** and the arithmetic is clear — confirm feel via a foreground playtest.

## 3. Resists are PARKED, not deleted
The WFT-11 resist puzzle (Wisp=Fire, Shade=ALL, Brute=raw; combos bypass) is the right *depth* tuning and stays documented in `2026-06-22-wft11-retune-resists-and-hex-fills.md`. It's removed from the demo build only because a hard resist makes "raw" an auto-loss, which contradicts the forgiving-demo goal. It returns in the post-demo rebalance. The big-resist telegraph UI (the versus-layout) stays — it just shows "no resist" for now.

## 4. Open / next
- **WFT-15** — the FTUE → showcase flow. Connection approach (a bridge button vs a clean linear flow that hides the historical sections) to be decided with the user.
- Post-demo: unpark WFT-12/13/14; restore resists and tune properly (WFT-11 numbers).
