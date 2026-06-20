# Session progress — slot models (A/B/C) + game-design review

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md). **Date:** 2026-06-20 · **Branch:** `weaponforge-tftransistor/post-slice-phase5`.
> **Status:** Brainstorm + prototype progress — **NOT spec yet.** Continues the craft redesign. No production code touched.
> **Freshest design state = this doc + [`2026-06-18-core-craft-mechanic-brainstorm.html`](2026-06-18-core-craft-mechanic-brainstorm.html).** The older [`2026-06-17-craft-model-resolved-and-gating.md`](2026-06-17-craft-model-resolved-and-gating.md) is now **PARTLY SUPERSEDED** — see "What changed since 06-17".

## One-line state
Craft **engine** resolved (mana → fire-the-mix; cascade killed). Craft **geometry** converged on a hex weapon-board with Element×Style runes + directional modifier-bridges. **Open decision: the SLOT MODEL (A / B / C)** — prototyped + game-design-reviewed this session; user to LOCK next.

## What changed since the 06-17 "resolved" doc (read this — it prevents confusion)
The 06-17 doc's "5 locks" were partly overtaken on 06-18/19:
- **Cascade / fill-then-explode reaction = KILLED** by user ("i dont like it"). The "reaction" is now a *component of the fired volley*, not a separate meter pop.
- **hero-as-frame / emitter-distance → weapon-as-board on a HEX grid** with Element×Style runes (TFT origin×class).
- **Power-gating question RESOLVED** → the gate is the **mana bar**: each base attack fills mana; on full, the weapon fires its current arranged mix. Craft tunes the fill-rate = the GD speed-gear analog.
- **SURVIVED unchanged:** craft-is-the-engagement; combat is auto (zero in-combat micro); Magicka lives in the element-combine table; cross-hero payoff = spatial bridges across lane seams; matchup-churn + piece-churn = the why-rearrange engine.

## This session (06-20)
1. Built **Version 2** of the throwaway prototype from the user's sketch: 3 hero hex-rows (3 element hexes each) + 2 modifier hexes nestled in each valley between heroes (the "seams"). 3 elements (Fire/Water/Storm) + 6 modifiers, **each with a distinct connector-logic** (which hex edges it bridges; the image-2 idea). Delivered a brutal critique.
2. Built **three slot-model options A / B / C** side-by-side to decide before locking.
3. Ran the **`game-design` 5-component review** on the whole model + the A/B/C choice + the tug-of-war question.

## The OPEN DECISION — slot model A / B / C
- **A — Combiner-only seams.** Board modifiers = combiners only (Conduit/Splitter/Prism) in the seams. Power/speed moved OFF-board (hero leveling). Cleanest, most casual, lowest agency.
- **B — Combiner seams + a per-hero power slot.** Each hero gets its own power slot (buffs whole hero = GD speed-gear, unambiguously owned). Seams stay combiner-only. Medium.
- **C — Unified grid (the tug-of-war).** One hex board, any cell = element OR modifier. Cluster same elements for buffs, but every modifier costs a cell + can break a cluster. Highest agency, highest legibility cost.

### Game-design verdict (5-component filter)
- The framework ranks **Response (do player inputs matter?) highest — and combat has ZERO Response by design.** So the FORGE carries 100% of player agency → the slot model literally = how much agency the only interactive layer has. (Reframes A/B/C from "layout" to "agency budget".)
- Response + Motivation (anti-solve-once) favor **C**; the project's LOCKED #1 risk (Clarity, casual audience) favors **A**.
- **Resolution = don't pick one, SEQUENCE them:** A = FTUE (clear) → B = stage-5 step → C = stage-10+ depth. This IS the existing 5/10/15 complexity-reveal schedule.
- **Recommendation:** prototype **A** for the casual feel-gate; spec the system as **A→B→C** staged; treat **C / the tug-of-war** as the endgame engine.

## The tug-of-war (keep it — but 2 load-bearing conditions)
User's idea: keep same elements adjacent for a **cluster buff (TFT-style)** vs. spend that space on a **modifier between them** that transforms both. Best idea this session for beating "solve-once". **Only exists if elements & modifiers compete for the same cells → only in C** (in A/B they have dedicated homes, so no tension). Verified in the prototype: *Cluster* preset = 3 buffs / 0 combos; *Bridge* preset = 0 buffs / 1 combo.
1. **A tile must count for cluster OR combo, NOT both** — else the tension evaporates. Enforce via **cell scarcity**, not a rule: total cells < (cells for max cluster + cells for max combo). Tune board size. *(Prototype currently allows both if there's room — left that way to show the trade is geometry-driven.)*
2. **Cluster value ≈ combo value** (within a band) or one strategy dominates. **Starting value + test (Numbers Policy):** 3-tile cluster ≈ +30%; single combo ≈ +30–40% effective output vs the raw tiles it consumes. Test ~20 mock boards + the wave-matchup set — each strategy chosen 40–60% of the time; if either >80%, shift 10% toward parity.

## Other game-design flags banked
- **Connector-logic learning load (Clarity):** 6 distinct edge-shapes is heavy for casual. Drip 1–2 in FTUE, rest on 5/10/15. Keep shapes FIXED early; **rotation = stage-10+ lever** (it doubles the state space).
- **Fit win:** A and B both fix the v2 incoherence (a "speed gear" floating between two heroes). v2-as-drawn breaks the GD speed-gear mental model.
- **Asymmetry in the seam layout (v2/A/B):** H2's centre tile touches all 4 modifiers; H3 has no seam below it → three heroes aren't equal citizens. Intentional or accident? decide.
- **Satisfaction (deferred):** the "full mana → fire the mix" moment + combo emission (Steam blast) need ≥2 feedback channels (visual+audio) in the real build; prototype is visual-only.

## The prototype
File: [`../../../_paper-prototypes/ftue-beat5.html`](../../../_paper-prototypes/ftue-beat5.html) — single self-contained HTML, **double-click to open** (works offline). Now contains **5 sections** top→bottom:
1. Original FTUE beat-5 walkthrough (v1).
2. **Version 2** — the sketch: 3 hero boards + seam modifiers + the 6 connector-logics + a designer's-critique callout + "Load a combo" button.
3. **Option A** · 4. **Option B** · 5. **Option C** (with **Cluster / Bridge** preset buttons that demonstrate the tug-of-war).
Verified working in-browser this session (no console errors; A/B/C build with correct cell/piece counts; C presets flip cluster↔combo exactly as designed). Preview config: `.claude/launch.json` (name `ppftue`, serves `_paper-prototypes/` on :8771).

## Git / uncommitted (RISK — read)
Everything from 06-18 onward is **UNCOMMITTED**: the 06-18 brainstorm HTML, the GD-mapping King correction, this prototype (v2 + A/B/C), and this doc. The last commit (`383de6c`) holds only the now-partly-stale 06-17 checkpoint. **One disk wipe = gone.** Standing offer: commit the pile. (Unrelated pre-existing churn: `docs/research/anime_autobattlers/` shows deleted — NOT from these sessions; user to restore or keep.)

## Resume tomorrow — sequence
1. *(optional but advised)* **Commit** the design pile so it's safe.
2. **Click the 4 boards** (v2 + A/B/C in the prototype) → **LOCK the slot model** (recommend A, with the system designed as staged A→B→C).
3. Decide the two tug-of-war numbers (board size for scarcity; cluster vs combo values) — or defer to a balance pass.
4. Finalise the element + style lists + the **Magicka pair table** (combinable / neutral / opposite).
5. Convert the converged model → **formal craft spec** → `writing-plans` → moat-first TDD build.

## Still-open pins (carried from the 06-18 doc)
Final element + style lists (proto target 4×3 = 12 tiles) · exact mana numbers (fill rate, per-shot cost, fast-vs-slow) · does Style drive its own synergy or only flavour the combo delivery · hero roster + which unlock when + gacha cadence · the full Magicka pair table · balance (enemy HP curves, mana economy, slot-unlock thresholds).
