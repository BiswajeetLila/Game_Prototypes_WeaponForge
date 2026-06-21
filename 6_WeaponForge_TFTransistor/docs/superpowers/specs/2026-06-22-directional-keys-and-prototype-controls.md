# Directional Keys + Key tiers + Splitter + prototype controls

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md). **Date:** 2026-06-22 · **Branch:** `weaponforge-tftransistor/post-slice-phase5`.
> **Status:** Decision record (brainstorm). Continues + **supersedes the Key model** in [`2026-06-21-craft-refinements-and-synergy-axes.md`](2026-06-21-craft-refinements-and-synergy-axes.md) §1. Paper-prototype only; numbers placeholder. Built + verified live in [`../../../_paper-prototypes/ftue-beat5.html`](../../../_paper-prototypes/ftue-beat5.html) (Path Y section).

## 1. Directional Keys — the answer to "3 elements touching one Key"
**Problem found in playtest:** the Path Y Key (06-21) looked at *all* adjacent elements and silently fused **the first two distinct ones in scan order**. With 3 elements around a Key, which two fuse was invisible and unpredictable — a **Clarity** failure, and a hidden priority rule no player could reason about.

**Decision — Keys are DIRECTIONAL.** A Key has fixed **sockets** (arrows). It fuses **only** the element clusters its arrows point at. Consequences:
- **The priority question disappears.** A 2-arrow Key has exactly two sockets, so it can only ever fuse those two tiles. A third adjacent element is **never pulled in** — it fires raw, or you bridge it with a *second* Key. What the arrows touch is what fuses; there is no scan-order tiebreak.
- **Placement becomes a real spatial puzzle**, not a connectivity check (this was the TFT-persona's #1 complaint on 06-21). You either pick the Key whose arrows match your layout, or arrange tiles to match a Key.
- **Telegraph:** every Key arm renders a stub — solid/bright when it points at an element, faint-dashed when empty — so the fusion is predictable *before* combat (Clarity restored). A Key whose arrows don't hit 2 *different* elements shows a warning.

Direction model on the 5-cell board (A0 A1 A2 top / B0 B1 bottom-offset): each cell knows its neighbour in each of 6 compass dirs (W,E,NW,NE,SW,SE). The centre cell **A1** touches 4 others (W,E,SW,SE), so all three Keys below are usable there — the FTUE teaches directionality on one cell.

## 2. Key tiers — 2 common + 1 epic
| Key | Rarity | Sockets (arrows) | Fuses |
|---|---|---|---|
| **Bar Key** ◄► | common | W + E | the tiles left & right |
| **Vee Key** ◣◢ | common | SW + SE | the two tiles below |
| **Star Key** ★ | **epic** | W + E + SE | **three** tiles |

- A common Key fuses **2** clusters → the normal 2-element combo (Steam / Conduct / Plasma).
- The epic **Star** fuses **3** clusters. If the three sockets cover **3 distinct** elements → a **Tempest** (grand combo). If they cover 2 distinct (e.g. Fire+Fire+Water) → the normal pair combo but fed by 3 tiles (bigger).
- Combo multiplier (starting values — tune at playtest): mega-weak match **×3** (overrides), else epic **×1.5** / common **×1.3**. Pass/fail: epic should out-damage a common only by pulling the extra tile + the 1.5, not by trivialising — if a single Star one-shots a stage, drop epic mult toward 1.3.

This is the "concentrate-vs-spread" choice in miniature: a Star wants 3 lined-up tiles (spread/legibility cost) for one big hit; two Bar/Vee Keys want tighter local pairs.

## 3. Splitter — redefined (was an undefined trap piece)
Cut from the FTUE on 06-21, kept only in the Sandbox with no clear function. **Now defined as the directional RAW-power counterpart to a Key:**
- Sockets **W + E** (same geometry as the Bar Key). Instead of *combining*, it **doubles (×2) each pointed element cluster as raw damage**.
- It does **NOT** bypass resist and forms no combo. So vs a resist-ALL wall a Splitter is useless (you need a Key); vs a weak/no-resist enemy a Splitter-doubled cluster can out-damage a combo. A genuine "armour-piercing combo vs raw muscle" choice. Sandbox-only for now; promote to a stage if it earns its place.

## 4. Prototype controls (playtest UX fixes)
- **Battle button (⚔ Battle!).** Combat no longer runs the instant a build is on the board. The player arranges freely (mana frozen at 0, live volley preview shown), then presses **Battle** to start the auto-combat. Button toggles **⚔ Battle! → ⏸ Pause** (pause freezes the mana loop to re-arrange), and shows **✓ Cleared** on win. *State machine:* `setup` (editable, no mana/fire) → `battle` (mana fills, auto-fires) → `won`/paused; Replay/Clear return to `setup`. Rationale: separates the *decision* (build) from the *resolution* (auto-combat) — the core pillar — and stops the board "playing itself" while you think.
- **Replay refreshes enemy HP (bug fix).** Replaying a cleared stage left the enemy at 0 HP (the old code recomputed `max` from the *current* hp). Each stage now stores an immutable `_hp0`; Replay restores `hp` and `max` from it. Verified: 0/30 → 30/30 on replay.

## 5. 5-Component evaluation (directional Keys)
- **Clarity** ✅ big win — arrows telegraph exactly which tiles fuse; dead-key warning; no hidden scan-order rule.
- **Response** ✅ — placement *and* Key choice both matter; orientation is a real decision (adds the spatial depth the TFT persona missed).
- **Satisfaction** ✅ — lit socket arms + combo links + combo readout ("Steam — fused 2 tiles, ×3 mega") = ≥2 feedback channels.
- **Fit** ✅ — sockets/arrows match the "build a weapon from runes" fantasy.
- **Motivation** ✅ — combos bypass resist / hit ×3 mega, i.e. they decide the fight.

## 6. Verified parity (live `__testPY`, 2026-06-22)
| Scenario | dmg | reads as |
|---|---|---|
| S4 Bar Key, Fire\|Water | 36 | Steam, fused 2, ×3 mega |
| S4 Vee Key, Fire\|Water (below) | 36 | same combo, different geometry |
| **S4 Bar Key + a 3rd Storm tile adjacent** | **38** | **Steam 36 + lone Storm raw(resisted)≈2 — the 3rd tile is NOT pulled in** |
| S4 Star Key, Fire\|Water\|Fire | 54 | Steam, fused 3, ×3 mega (epic pulls the extra tile) |
| S4 Bar Key, Fire\|Fire (same both sides) | 3 | no combo (dead key warning), 2 lone fire resisted |
| S5 Bar Key, Water\|Storm | 36 | Conduct ×3 mega (≠ S4's Steam) |
| S5 Bar Key, Fire\|Water (wrong combo) | 16 | Steam not mega here → 12×1.3 |
| Sandbox Star, Fire\|Water\|Storm | 27 | Tempest, fused 3, epic ×1.5 |
| Sandbox Splitter on a Fire pair | 31 | vs 16 un-split — ×2 raw, no combo |

No console errors across full interactive drive (place → Battle → auto-kill → Replay → HP restored).

## 7. Still-open / next (unchanged headline from 06-21)
- **#1 — the setup COST / placement budget** (06-21 §6) is still the top fix and still un-built. Directional Keys *add* the spatial-placement decision the personas wanted, but building the board is still **free** → re-run the two persona playtests after the budget lands. The budget interacts well with the epic Star (3 tiles = a budget sink).
- Re-tune enemy HP for ~4–6-volley optimal play once the budget exists (HP left at 340/520 placeholder — directional Keys produce similar burst to the old greedy Key on the typical 2-element solve, so HP was NOT changed this pass).
- Decide whether Keys can **rotate** (cycle socket orientation) — would let any Key adapt to any cell, richer but more UI. Deferred; fixed-orientation Keys are enough for the FTUE.
- Lock element + role lists + the Magicka pair table; design shop/refresh churn axis; promote Splitter to a stage if it earns it.
