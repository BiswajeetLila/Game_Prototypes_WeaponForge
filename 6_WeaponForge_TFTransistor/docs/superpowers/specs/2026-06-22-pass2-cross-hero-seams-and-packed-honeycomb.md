# Pass 2 — cross-hero seam bridging + packed honeycomb board

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md). **Date:** 2026-06-22 (latest of the 06-22 set) · **Branch:** `weaponforge-tftransistor/post-slice-phase5`.
> **Status:** Decision record + build. Paper-prototype only (`ftue-beat5.html`, "3-Hero Board" section). Supersedes the "Pass 2 = next" note in [`2026-06-22-multi-hero-and-modifier-verbs.md`](2026-06-22-multi-hero-and-modifier-verbs.md) §1 — Pass 2 is now BUILT.

## 1. Cross-hero seam bridging — BUILT + verified
The 3-hero board now lets a Key **bridge the seam** into the neighbour hero. Model (matches the vertical stack + hex geometry):

- A Key on a hero's **bottom-row cell** (B0/B1) aims its **↓ SW/SE sockets across the seam** into the hero **below**: `B0 → next.A0 / next.A1`, `B1 → next.A1 / next.A2` (the geometric down-neighbours in the packed honeycomb).
- The combo **fires for the Key's hero**; the borrowed neighbour tile is **consumed that volley** (it does NOT also fire for its own hero — marked `h3borrow`, glows, and is excluded from the owner's raw groups).
- **Clustering stays within a board** — seam adjacency applies to **Key sockets only**, never to element clustering (per the multi-hero doc). Each cell's `.nb` (cluster neighbours) is built within its own hero's 5 cells; cross-hero links live only in `.dir`.
- Bridging is **downward-only** (keys have SW/SE/E/W sockets, no NW/NE), so combos always flow from an upper hero into the one below.

**Implementation:** `volley(h)` was generalised to a single **`volleyAll()`** that resolves all keys across all heroes against one global `keyed` set (deterministic, hero-order) → a borrowed tile is consumed exactly once, with no double-count. Each hero's result carries `crossOut` (combos it owns reaching down) and `crossIn` (its tiles borrowed upward). Coordinate-agnostic, so the layout change below didn't touch it.

**Verified live (synthetic placement, no console errors):**
- Vee on Elara.B0 + Fire/Water on Bran.A0/A1 → **Elara fires cross-hero Steam ⤓ 16** (Vee ×1.3 on 2×6 base); Bran shows `— (borrowed up) (−2 pulled up)`, 0 groups; in Battle, Elara clears Wisp using Bran's tiles, Bran (fully borrowed) never fires — the tick loop handles a 0-group hero cleanly.
- Bar on Vex.A1 + Fire/Water on Vex.A0/A2 → within-hero **Steam ⚡ 16** still works (regression intact).

## 2. Packed honeycomb layout — BUILT
The three boards were merged into **one continuous honeycomb**: a single shared board + SVG, with each hero offset **+76 px** so the rows tessellate `3-2-3-2-3-2` at 38 px steps (hero0 rows y 34/72, hero1 110/148, hero2 186/224 — verified). The bottom row of each hero nestles into the top row of the next, so the seam is visually a real shared edge (this is exactly the user's annotated "boards connect" sketch).

Because all 15 cells now share one coordinate space, **cross-hero combos draw a real connecting line across the seam** (e.g. Elara.B0 → Bran.A0) instead of the earlier stub arrows.

Per-hero info (name / tick-bar / enemy HP / mix) moved to a **rail on the right**, one band per hero (dashed separators), compacted so the rail ≈ board height (middle hero aligns exactly; top/bottom drift ~20 px — acceptable, hexes-packed was the stated priority).

## 3. Excalidraw wireframe — squares → tessellated hexagons
[`_paper-prototypes/3hero-board-wireframe.excalidraw`](../../../_paper-prototypes/3hero-board-wireframe.excalidraw) re-authored with pointy-top **line-hexagons** (same tessellation), replacing the rectangles. `.png` preview regenerated. *(The Excalidraw MCP `create_view` only renders rect/ellipse/diamond, so the hex file is authored directly, not via the MCP inline view.)*

## 4. Open / deferred
- **Seam asymmetry (decide later):** downward-only bridging means the **bottom hero can never bridge** and the **top hero can never be borrowed from** — "three heroes are not equal citizens" (the old V2 critique). Fine for the prototype; if seam-equality matters, add upward sockets or wrap-around.
- **Splitter (amplify) stays within-board** — only combine-Keys bridge the seam (per the verb-space "amplify lives inside one hero" note).
- **Still #1 (unchanged):** the setup-COST / placement budget + HP retune, now across 3 boards. Cross-hero is a power source with no cost attached yet.
- Next per the order: **modifier verb-space** → **shop costs + rotation polish**.
