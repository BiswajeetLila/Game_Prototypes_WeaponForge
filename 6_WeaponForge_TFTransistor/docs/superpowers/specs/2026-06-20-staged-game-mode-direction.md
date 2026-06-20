# Staged game mode — the chosen craft direction

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md). **Date:** 2026-06-20 · **Branch:** `weaponforge-tftransistor/post-slice-phase5`.
> **Status:** **DIRECTION CHOSEN** (paper-prototype validated). NOT yet a build spec; numbers are placeholder; several tuning items open. No production code touched.

## The decision
User picked the **unified-grid (Option C)** model, realized as a **staged-reveal game mode** — *"seems like a good direction."* This **resolves the A/B/C open question** in [`2026-06-20-slot-models-and-gamedesign.md`](2026-06-20-slot-models-and-gamedesign.md): **C (unified grid) is the depth target.** A/B (dedicated element-rows / per-hero power slots) are *not* the chosen layout — but the *idea* behind them (start simple, add one rule at a time) survives as the **staged reveal** itself.

## The model in one screen
- **One unified hex weapon-board.** Any cell holds an **element** OR a **modifier**.
- **Engine = mana → fire-the-mix.** Base attacks fill a mana bar; on full, the weapon fires its current arranged mix. (No fill-then-explode cascade — that was killed 06-18.)
- **Three things compete for every scarce cell** → this competition *is* the depth:
  1. **Element** — fires a shot; clusters with same-element neighbours; can be a bridge endpoint.
  2. **Modifier** — combines/transforms (costs a cell).
  3. **Merge pressure** — keep a 3-cluster for its buff, or merge it for a tier-up **+ 2 freed cells**.

## The 5-stage reveal (+ sandbox)
Each stage adds exactly **one** new rule on top of the last — the answer to the locked Clarity risk (never show the full system at once).

| Stage | New mechanic | Player does | Enemy / goal |
|---|---|---|---|
| **1 · Place & Fire** | the core loop | drop fire runes; mana fills → fires the mix | Straw Dummy |
| **2 · Clusters** | spatial trait (TFT origin×class → adjacency) | place same elements **adjacent** for a cluster buff (2=+, 3=++) | Bandit |
| **3 · Merge** | TFT merge, spatialized | 3 identical touching → **tap to fuse** → tier up, **frees 2 cells** | Brute |
| **4 · Bridges** | modifiers combine | drop a **Conduit** by Fire+Water → **Steam** combo (costs a cell) | Ironclad (**resists fire**) |
| **5 · The Tug-of-War** | the whole loop under scarcity | **choose**: cluster vs merge vs bridge; read the matchup | Warden (resists fire, **mega-weak Steam**) |
| **0 · Sandbox** | everything unlocked | free play, no enemy | — |

**Stage 5 is the thesis:** the Warden shrugs off raw fire, so you must spend scarce cells on a Steam bridge — and **merging your fire cluster is how you free the cells to build it.** That single screen contains the whole game.

## Mechanics in detail
- **Clusters (spatial trait).** Same element in adjacent cells = a buff; bigger connected cluster = bigger payoff (breakpoint feel at 2 / 3 / 4). This is TFT's trait **made spatial** — *never* positionless "have 3 anywhere" (that paradigm is explicitly rejected). Two-tag runes (Element × Style) mean a tile can join an element cluster via one neighbour and a style cluster via another (style axis is a later-stage reveal).
- **Merge-on-grid.** 3 identical runes (same element **+ tier**) in a connected group → merge-ready (glow) → tap to fuse into 1 rune at tier+1, occupying 1 cell and **freeing 2**. Manual (not auto) = agency, which matters because combat has none. Optional depth: higher tier = wider bridge reach / counts as 2 toward a cluster breakpoint (deferred).
- **Modifiers / bridges.** A **combiner** (Conduit) bridges two **unlike** adjacent elements into a combo (Fire+Water=Steam, Water+Storm=Conduct, Fire+Storm=Plasma — the Magicka table). **Splitter** doubles an adjacent element's shot. *Connector-logic per modifier* (each modifier activates specific hex edges — the image-2 idea, prototyped in the A/B/C section) is **deferred to a later reveal**; the staged mode keeps modifiers simple (affect adjacent neighbours) for casual onboarding.
- **The tug-of-war.** Enforced by **cell scarcity**, not a rule: the board is small enough that you can't simultaneously max a cluster *and* fit a full combo — so every wave's matchup forces a fresh choice. This is the engine that beats "solve-once."
- **Combat (auto).** Enemy has a **resist** (raw element ×0.25) and a **mega-weak combo** (×3). Win = HP to 0. Matchup-churn (each enemy favours a different element/combo) = the reason to keep re-arranging.

## Why — game-design read (5-component filter)
- **Response (framework's top priority):** combat is auto = zero in-combat agency *by design*, so **the forge carries 100% of player input.** Merge + placement is where the game lives. ✅
- **Clarity (project's locked #1 risk):** handled by **one-new-rule-per-stage**. The danger is that the full system is TFT-grade load — this is what pushes the game from "casual" toward "midcore." Staged reveal is the mitigation; there's a ceiling. ⚠️
- **Motivation:** merge chase + cluster traits + matchup-churn = three live reasons to re-arrange. ✅
- **Fit:** forging 3 lesser runes into 1 greater is *literally smithing* — better thematic fit than TFT's champion-stacking. ✅
- **Satisfaction:** the merge "pop" and the combo emission need ≥2 feedback channels (visual + audio) in the real build; prototype is visual-only. (deferred)

## Numbers — all placeholder, with test plans (per Numbers Policy)
From the prototype: base shot 6 · cluster +30% per same-neighbour (cap 3) · tier ×T · resist ×0.25 · combo base 14, mega ×3 · mana +34/620ms. **Two values are load-bearing and must be tested, not guessed:**
1. **Board scarcity.** Prototype = 7 cells, which may be **too loose** for the Stage-5 tug-of-war (you can fit a Steam bridge *and* spare cells). **Test:** can a player do cluster + merge + bridge all at once? If yes, **shrink the board** (the lever is cell count, not more rules).
2. **Cluster value ≈ combo value.** If one dominates, the tug-of-war collapses. **Test:** across ~20 boards + the matchup set, each strategy chosen 40–60% of the time; if either >80%, shift its value 10% toward parity.

## Open / deferred (before this becomes a build spec)
- Board size tuning (scarcity, above) · cluster-vs-combo value parity.
- Merge requires **identical** (deeper, RNG-grindier) vs **same-element any-style** (more casual) — pick.
- **Connector-logic** (6 directional modifier shapes): drip on the 5/10/15 cadence; fixed shapes early, rotation as a stage-10+ lever.
- **Cross-lane / multi-hero** (the LINEUP layer — bridge across lane seams): deferred to a later stage + its own pass. The staged mode above is single-board.
- Style axis as its own synergy vs only flavouring combo delivery.
- Still-open content pins: final element + style lists (proto 4×3=12) · exact mana economy · full Magicka pair table (combinable/neutral/opposite) · hero roster + gacha cadence · balance curves.

## The prototype
[`../../../_paper-prototypes/ftue-beat5.html`](../../../_paper-prototypes/ftue-beat5.html) — single self-contained HTML (double-click; runs offline). **6 sections** top→bottom: (1) FTUE beat-5 v1 · (2) Version-2 sketch (3 hero boards + seam modifiers + 6 connector-logics) · (3–5) Options A / B / C · (6) **Staged game mode** ← the live realization of this direction. Verified playable this session: stage gating, the cluster→merge→free-cells loop, and the Stage-5 Steam-vs-Warden matchup all confirmed working, no console errors. Preview config `.claude/launch.json` (`ppftue`, serves `_paper-prototypes/` on :8771).

## Relationship to prior docs
- **Supersedes** the A/B/C *open question* in [`2026-06-20-slot-models-and-gamedesign.md`](2026-06-20-slot-models-and-gamedesign.md) (that doc remains the analysis record).
- **Builds on** the 57-item consolidated model in [`2026-06-18-core-craft-mechanic-brainstorm.html`](2026-06-18-core-craft-mechanic-brainstorm.html).
- [`2026-06-17-craft-model-resolved-and-gating.md`](2026-06-17-craft-model-resolved-and-gating.md) is **history** (cascade/emitter-distance model, superseded 06-18).
