# Board topology LOCKED (hex + color-coding) + costs/budget v1

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md). **Date:** 2026-06-22 (latest of the 06-22 set) · **Branch:** `weaponforge-tftransistor/post-slice-phase5`.
> **Status:** Decision record + build. Paper-prototype only (`ftue-beat5.html`, "3-Hero Board" section). Resolves the topology question opened by the board-topology brainstorm (same day) and delivers issue **WFT-9**.

## 1. Board topology — RESOLVED: keep the hex honeycomb, color-code by hero

The single-row-per-hero option proposed in the board-topology brainstorm (WFT-8) is **set aside**. The user playtested the packed hex honeycomb with **per-hero color-coding** and players could read it — they could tell which cells belong to which hero. Decision: **keep the packed hex honeycomb; solve legibility with per-hero identity colour**, not by changing the cell shape.

**The legibility fix (the key insight):** tile *fill* already encodes element (Fire/Water/Storm), so colour can't also mark hero. Hero identity therefore goes on the hex **outline** (+ a matching swatch on the rail). Fill = element, outline = hero — both readable at once.

**Implementation (`ftue-beat5.html`):**
- `HEROCOL = ['#cdd3da','#9b7bf0','#d98a3c']` — Elara (light), Bran (purple), Vex (orange). Hero 0's "black" from the sketch was inverted to light grey for contrast on the dark UI.
- `hexOutlines()` strokes each cell's pointy-top hexagon (width 46 / height 51, matching the CSS `clip-path`) in its hero colour, drawn in the shared SVG layer *under* the combo/seam lines. 15 outlines (5 × 3 heroes), `stroke-width: 3`.
- Rail hero name gets a `.h3swatch` colour chip so the legend matches the board.

**Scope / caveats:**
- This is **legibility only**. The downward-only cross-hero seam asymmetry (from the Pass-2 doc) is **not** addressed here — it remains open as **WFT-14**.
- Vex's outline orange (`#d98a3c`) sits near Fire's fill (`#e0552e`); distinguishable as border-vs-fill but flagged for a hue tweak if it reads poorly in play.

## 2. Costs + budget — BUILT (WFT-9)

Every tray piece now has a shop cost, paid from a **single shared forge budget across all three boards**. Shared (not per-hero) on purpose: it makes placement a genuine tradeoff *and* attaches a price to cross-hero power — you must spend to place the bridging Key — partially answering the "cross-hero = free power" critique.

**Starting values** (game-design Numbers Policy — provisional, retune in WFT-11):

| Piece | Cost |
|---|---|
| Fire / Water / Storm | 1 |
| Splitter | 2 |
| Bar Key / Vee Key | 3 |
| Star Key (epic) | 5 |
| **Shared budget** | **18** |

**Rules:**
- Placing checks `cost ≤ remaining`; over-budget placement is **blocked** with a hint. Removing a tile refunds it.
- **Merge conserves budget:** a tier-T element costs `base × 3^(T-1)`, so 3 Fire (@1 = 3) merged into one Fire II still reads 3 — no refund exploit, no double-charge.
- Only **affordable** empty cells glow when a piece is selected; **unaffordable** tray pieces dim.

**Verified live (DOM/SVG inspection — `preview_screenshot` is flaky in this env, no console errors):**
- Start 0/18; 3 Stars = 15/18; 4th Star **blocked**, stays 15/18.
- At 3 remaining: Star (5) dims, Bar (==3) stays affordable.
- Merge conserves: 3 Fire → 1 Fire II, still 3/18.
- Clear resets to 0/18.

**Test plan (for when stakes exist):** once incoming damage + win/lose land (WFT-10), retune costs/budget/HP (WFT-11) so a well-built board *barely* wins and a lazy or over-budget board loses. Pass/fail: the budget forces ≥1 meaningful cut, and boards settle around 60–75% full rather than fully packed.

## 3. Open / next
- **WFT-10 — stakes (incoming damage + win/lose)** is now the #1 item: combat is still a punching-bag with no fail state.
- **WFT-11 — retune** depends on WFT-10.
- **WFT-14 — seam symmetry** (downward-only) still open; color-coding did not touch it.
- **WFT-15 — FTUE staged-tutorial edits** queued (single-hero onboarding flow: Place&Fire / Clusters / Merge / The Key / The Wall / Sandbox); specific edits TBD from the user.
