# Multi-hero board + modifier verb-space

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md). **Date:** 2026-06-22 · **Branch:** `weaponforge-tftransistor/post-slice-phase5`.
> **Status:** Decision record + Pass-1 build. Paper-prototype only (`ftue-beat5.html`).

## 1. Multi-hero board — DECIDED
The single 5-cell board expands to **three** (one per hero). User decisions (AskUserQuestion 2026-06-22):
- **3 boards with bridgeable SEAMS** — modifiers/Keys can reach **across** adjacent heroes at the edges. Cross-hero synergy = a new strategic axis.
- **Per-hero tick-bars** — each hero charges + fires its **own** board at its **own** enemy, independently.

**Pass 1 — BUILT + verified** (new "3-Hero Board" section at the bottom of `ftue-beat5.html`): three independent 5-cell boards, each with its own tray placement, clustering, merge, directional per-tile Keys, Splitter, segmented tick-bar, and enemy + HP. One shared tray + a master **⚔ Battle**; **Clear all** / **Reset enemies**. Verified live: each board builds + fires its own enemy on its own cadence (e.g. Elara Steam-16, Bran cluster-18, Vex Splitter-18 all cleared their lanes independently); all-clear + reset work; no console errors. Clustering/ticks stay **within** a board for now.

**Pass 2 — NEXT:** cross-hero **seam bridging.** Right-edge cells of hero N (A2, B1) ↔ left-edge cells of hero N+1 (A0, B0). A Key on an edge cell can aim a socket *across* the seam into the neighbour's tile; the combo fires on the **Key's** hero and borrows the neighbour's tile (cross-hero assist). Seam adjacency applies to **Key sockets only**, not clustering (per "modifiers bridge seams").

## 2. Modifier design — VERB-SPACE, not one-key-rotation
**Decided:** modifiers = a **curated set of distinct-effect directional Keys** (hardcoded directionality, different *verbs*), NOT one Key type you rotate. **Rotation is demoted** to optional gold-sink polish (re-aim a placed, *valuable/tiered* Key) — layered on later, not the core system.

**Why (the argument that settled it):** depth comes from **verbs that interact**, not from re-positioning one verb. Rotation permutes the *geometry* of a single outcome ("combine these two") — a convergent, bounded puzzle (one best aim, capped by neighbour count). Distinct effects permute *kinds* of outcome **and stack/chain** (a speed-key + a combine-key → a faster combo; amplify + combine → a bigger one; swap sets up next turn) → **emergent** depth, and the best pick is **matchup-dependent** (non-convergent, replayable). Combinatorially: rotation = O(orientations) × *one* result; effects = O(verbs × interactions × elements) × *many*. This also re-converges with the original WeaponForge **"Function Matrix / universal slots behave differently"** vision.

**Caveats (curate, don't maximize):**
- Verbs must occupy **distinct strategic roles** or they collapse into "more DPS." Differentiate by direction-of-pull: **pierce** (combine → bypass resist), **raw power** (amplify → resistable), **tempo** (speed → fire sooner), **setup** (swap → future turns).
- **4–6** clean interacting verbs, not 12 fiddly ones (the GD lesson: depth from a few clean stacked axes).
- **"Swap tiles next turn"** is a *temporal* verb — great depth but a **Clarity** risk in auto-combat (the player must predict a future rearrange); telegraph hard or defer to v2.

**Verb candidates (starting set, to design):** **Combine** (the current Key → combo/pierce) · **Amplify** (the current Splitter → ×2 raw) · **Speed** (−tick / fire sooner — interacts uniquely with the mana=ticks economy) · **Swap-next-turn** (setup; deferred-risky). Each is a directional Key with a hardcoded socket shape; cross-hero seams (Pass 2) multiply their value.

## 3. Order
3-hero board (Pass 1 ✅ → **Pass 2 seams**) → **modifier verb-space** → **shop costs + rotation polish**. The **#1 setup-cost / placement budget + HP retune** still looms and now spans 3 boards (3× the economy surface).
