# Craft Model — RESOLVED + Power-Gating brainstorm (in progress)

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md). **Date:** 2026-06-17 · **Branch:** `weaponforge-tftransistor/post-slice-phase5`.
> **Status:** Craft model **RESOLVED** this session (supersedes the tentative #4 in [`2026-06-16-craft-mechanic-options-ranked.md`](2026-06-16-craft-mechanic-options-ranked.md)). Power-gating = **brainstorm IN PROGRESS** (paused mid-stream). No code started.

## The 3-layer architecture (settled)

```
FORGE (per hero)          LINEUP (pre-combat)          COMBAT (auto)
clip parts on frame   →   assign heroes to lanes   →   resolves itself
YOUR HANDS (main craft)   adjacent lanes cross-react   cross-lane cascade
sets each hero's emission  "line up the team" = moat   = VISUAL PAYOFF
```

The craft (FORGE) is the main engagement. The cross-hero reaction is **authored at LINEUP** (which elements sit in adjacent lanes) and **pays off in COMBAT** (auto). This is the anti-screensaver split: hands live in the forge + lineup, never in combat micro.

## LOCKED craft decisions (this session, 5 forks resolved via visual brainstorm)

1. **Reaction locus = CROSS-HERO, in combat.** NOT intra-hero in the forge. Confirms the moat = "line up your *team's* elements → the screen chain-reacts." (Killed the option where Steam resolves inside one hero's frame.)
2. **Forge adjacency verb = MODIFIER-WARP.** A part warps its neighbour (GD power-train + Transistor's Modifier role). Reactions do NOT fire in the forge — only warps.
3. **Hero differentiation = SHARED PARTS + PER-HERO FRAME SHAPE.** Parts are universal (one shop, merges carry across heroes = fungible draft). Each hero's nub-count + bone pattern differs → a new build puzzle per hero (collection feeds craft). Frame shape echoes fantasy (Ashe = a line/projectile frame, Elara = a wide spread/AoE frame, Bran = a compact cluster).
4. **3-role mapping = EMITTER-DISTANCE.** Each frame has one **emitter** nub = the **Active** (what the hero shoots). Parts **bone-adjacent** to the emitter = **Modifiers** (warp the shot). Parts **far** = **Passives** (auras/stats). *One rule (adjacency) governs both the warp and the role.* Legibility via visual zoning: hot muzzle ring (Modifier zone) vs dim outer (Passive zone).
5. **Part vocabulary = TWO CLASSES** (refinement of "Part = Function," per the role-gallery exercise):
   - **FUNCTIONS = elements/abilities.** One part, two outcomes by placement: **Active** on the emitter / **Passive** on an outer nub. ~6 for the prototype. Candidates: FIRE, FROST, STORM, VENOM, LIFE, STONE.
   - **MODIFIERS = shapes.** Adjacent-ring only; warp the emitter's shot; **no standalone Active/Passive**. ~4–6. Candidates: SPLIT, PIERCE, SEEK, BOUNCE, AMPLIFY, FORK.
   - **Why two classes:** the 10×3 role-gallery showed elements read well in all 3 roles, but shape-parts (Split/Pierce/…) are flavorless filler as Actives. The emitter-distance zones already sort the two classes (Functions → emitter/outer, Modifiers → adjacent ring), so this costs no extra UI concept.

### Worked examples (PARKED for fine-tuning — names/pairings not final)
From the brainstorm screens (`.superpowers/brainstorm/.../function-modifier-combos.html`):
- **Fire + Split** = three fireballs, burns the lane · **Frost + Seek** = homing freeze · **Storm + Bounce** = arc across 4 enemies · **Venom + Pierce** = poison line · **Life + Amplify** = full-team heal · **Blood + Bounce** = healing ricochet.
- Clever cross-role design to mine later: **Life-as-Modifier = lifesteal**; **Stone-as-Modifier = armor-pierce**.

## OPEN — Power-gating (brainstorm in progress, RESUME HERE)

**The gate** = the mechanism that converts a static build into a *rate* of output, paces combat (no instant blowout), and times the cascade. Without it the craft has no throughput axis to optimize.

- **Critical reframe (agreed direction):** GD gates *raw power* (DPS) — a commodity. Our moat is the *reaction*. So our gate should likely meter **the reaction / time-to-next-screen-pop**, not raw damage.
- **Currency options posed (undecided):** **A reaction-charge** ⭐ (lanes build element-charge → cascade at threshold) / B raw-power tank / C per-Active cooldown. Floor against "dead combat": heroes still auto-attack for chip damage; the gate meters the reaction on top.
- **12 mechanisms surfaced (batch 1):** Global Beat · ATB/Initiative · Heat/Overdrive · Combo/Momentum · Pressure Boiler · Mana Battery · Element Breakpoints · Magazine/Reload · Fuel Burn · Forge Conveyor · Charge & Hold · Resonance Windows.
- **User signal:** likes the **Expedition 33 mana/AP** model (earn resource by basic-attacking, spend on the payoff skill) — maps to "AP economy" / Mana Battery / Charge-&-Hold cluster. Wants **casual-easy** gates + blend with the hypercasual research catalog (`C:\_BISU\...\HyperCasual_Research\catalog\hypercasual-game-ideas-catalog.html`).
- **Batch 2 (casual, research-blended)** delivered in chat 2026-06-17 — to be folded here once a direction is picked. Research seeds in play: **multiplier gates** (Mob Control / Count Masters — literally "gates"), pour-to-fill (Happy Glass), merge-to-charge (2048), crowd-snowball (Crowd City), idle-bake (Cookie Clicker), beat-tap (BIT.TRIP / A Dance of Fire and Ice), pin-pull/release.

**Gating resume sequence:** more casual ideas → pick the **currency** (what flows through the gate) → pick the **cadence** (beat/charge/etc.) → fold into this doc.

## Still-open craft sub-questions (after gating)
- **Board specifics:** nub count per hero (target 3–5), free-points vs micro-grid, portrait legibility.
- **LINEUP layer detail:** still 3 lanes? how the player arranges; how adjacent lanes cross-react; telegraph vs enemy weakness.
- **Legibility plan:** preview lines, a "this build does X" readout, the charge bars as the teaching surface.
- **Part vocabulary finalisation:** lock the ~6 Functions + ~4–6 Modifiers + their A/P/combo behaviours.

## NOT in scope (unchanged guardrails)
Items/Synergies/Catalysts deep brainstorm, Wittle-meta lift, balance numbers — all still **parked** for their own sessions per [`2026-06-15-prototype-direction-design.md`](2026-06-15-prototype-direction-design.md).
