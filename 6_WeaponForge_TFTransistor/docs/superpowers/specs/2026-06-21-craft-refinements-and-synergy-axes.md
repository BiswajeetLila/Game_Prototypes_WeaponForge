# Craft refinements + synergy-axes decision + GD axis comparison

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md). **Date:** 2026-06-21 · **Branch:** `weaponforge-tftransistor/post-slice-phase5`.
> **Status:** Decision record (brainstorm). Continues + refines [`2026-06-20-staged-game-mode-direction.md`](2026-06-20-staged-game-mode-direction.md). Paper-prototype only; numbers placeholder.

## 1. Build refinements since 06-20 — Path Y is now the live model
The 06-20 doc described modifiers as firing a flat combo shot. **Superseded.** The prototype now runs **Path Y**:
- **Modifier = converter.** A **Key** converts its adjacent element cluster(s) into combo-type damage (scales with cluster size, bypasses resist, ×3 vs a mega-weak enemy). A cluster can be keyed **once** — a 2nd Key on it does nothing, so spamming Keys is pointless. Nothing is consumed; unkeyed elements still fire raw.
- Sim- + build-verified (5-cell board, Warden): **cluster+key 104 > spam 65 > cluster-only 53/13.** Spam is dead; cluster+key dominates.

**Merge fixed (playtest bug):** merging used to HALVE damage (Stage-4 6→3) because it dropped 2 tiles + the cluster bonus while tier was only ×2.
- **Tier scaling ×1 / ×3 / ×9** (was ×1/×2/×3) — a merged tile ≈ the tiles it ate.
- **Merged tiles count their tier toward the cluster bonus** (a Fire II counts as 2 fire neighbours).
- Result: S4 merge **6→6** (neutral, was 6→3); S3 merge+refill **57** (was 38); S5 merge-densified+key **189 vs 104** (+82%). Merge is now an upgrade/density tool, not a trap.

**Stage 4 teaching:** merge removed from S4 (returns at S5) so the player is not lured into merging resisted fire; copy steers to the Key. One-new-rule-per-stage preserved.

## 2. Synergy-axis decision (the A/B/C question) — RESOLVED: **B, staged**
**What does adjacency reward?**
- **Core (from stage 2): same ELEMENT** (Fire+Fire) — the damage engine.
- **Late reveal (~stage 10): same ROLE/STYLE** — Fire-DOT + Storm-DOT cluster on "DOT" even across different elements. This is TFT's "different units, shared trait" (Kog'Maw + Cho'Gath on *Void*), kept **spatial** (adjacency, not positionless count) and small.
- **"Classes" (Elemental / Magic / Cosmic) = content & gacha buckets** — the release/season roadmap (Elemental launch → Magic → Cosmic expansions), **NOT a synergy axis.**
- **Utility (Heal / Haste / "Synergy" / "Chakras") = the modifier/Key family**, not a 4th element class. (Haste already = the speed modifier.)
- **Cut "Cosmic (???)"** until it has a defined identity (YAGNI).

Rationale: two tight synergy axes max (element + role), role gated late → protects the locked #1 risk (legibility). Repositions the user's class taxonomy from "synergy" (overlapping/coarse) to "content roadmap" (where it is genuinely useful).

## 3. GD axis comparison → reorder the roadmap toward CHURN
Counted GD's decision axes vs ours (full tables in the 06-21 chat). Summary:
- **GD ≈ 9 in-run + 8 meta ≈ 17 axes.** Its depth = many shallowish axes **stacked** (type-RPS, placement+chains, merge, connector gears Speed/Shield/Chain, **troop-cap**, **shop draft+refresh churn**, **`-1` rotation-constraint slots**, **reactive procs** Counter-Warning/Timed-Buff/Restore/one-shot-gear).
- **We are DEEP on fewer axes** — and our **combo/conversion axis is net-new (GD has nothing equivalent)**, doing the heavy lifting.
- **We are THIN on the cheap "churn/texture" axes** that make GD re-tunable every wave: **shop draft + REFRESH**, a **cap / concentrate-vs-spread** tension, **constraint slots** (`-1`-like), and **reactive procs** (some intentionally absent — combat is auto).

**Decision — prioritize the cheap churn axes BEFORE the 2nd synergy axis.** Near-term depth order:
1. **Shop draft + refresh** (per-stage re-draft — the engagement treadmill + matchup adaptation).
2. **A cap / concentrate-vs-spread** tension (today we lean on cell-scarcity; make the tradeoff explicit).
3. *(later)* **role-clustering** (the 2nd synergy axis, ~stage 10).
4. *(later)* constraint slots, cross-hero lineup.

Reason: churn axes add decisions **cheaply and legibly** (no second synergy paradigm) — the GD lesson is that depth comes from churn + matchup + cap, not only from synergy systems.

## 4. GD research gaps (record)
- **Gate / threshold-buff gears (user-reported, unverified):** GD reportedly has gears that buff troops *as they pass a specific gate*, incentivising building production toward that gate — a positional-incentive system the scraped spec missed. Logged as gap #16 in the GD spec §15. To verify (cf. the King omission). [User report 2026-06-21]
- Reaffirm: the King correction (GD's King is an active combatant) — already committed `5e79bc9`.

## 5. Still-open / next
- Lock the element + role lists + the Magicka pair table.
- Design the **shop/refresh + cap** (the prioritised churn axes) → spec.
- Then formal craft spec → `writing-plans` → moat-first TDD build.
- Deferred: role-clustering reveal (stage 10), constraint slots, cross-hero lineup, the whole meta layer.

## 6. Persona playtests + fixes applied (06-21)
Two agents played the FTUE — a **casual mobile gamer** and a **TFT devotee** (both used a faithful Python engine, `scratchpad/play_engine.py`, for exact outcomes). Both scored **4/10** and converged on one root cause: **building the board is FREE (no cost / turn-limit), so the best build is always available and every stage trivialises to 1–4 volleys; and merge specifically both feels-bad for casuals (the damage number drops) and is a fake choice for depth players.**

**Top findings:** merge dropped damage (S3 29→23) → casual rage-quit; the Key cheaply bypassed cluster+merge depth (game collapsed to 2 templates); S4's fire-resist had a back-door (just use Storm); elements interchangeable + only Steam mattered (Plasma/Conduct dead); Splitter a trap piece; the whole auto-battler meta missing (shop/refresh/draft, opponent variety, items); positioning is just a connectivity check.

**Fixes applied to the prototype (verified in build + engine):**
- **Merge never drops** — tier mult T2 ×3→**×4** so a merged tile ≥ the cluster it came from (S3: 29→**31**, was 29→23).
- **S4 enforces the Key** — Ironclad now resists **ALL** raw (was fire-only), closing the Storm/Water back-door; only the Steam Key works (13 vs 104).
- **S5 is a new puzzle, not a reskin** — Warden now mega-weak to **Conduct (Water+Storm)**, not Steam → you must build a *different* combo (Steam build = 45 dmg/12 volleys; Conduct = 104/5). Makes a 2nd combo matter + teaches matchup adaptation.
- **Splitter cut** from the FTUE tray (trap piece; deferred until it has a real role).
- **Key placement feedback** — a misplaced Key now warns "⚠ That Key makes no combo — needs 2 different elements next to it" (was a silent fail).
- **Live-version banner** at the top of `ftue-beat5.html` (the live build is the Path Y section at the bottom; everything above is history).

**NOT done — the #1 fix, handed off as the headline next-session decision: a setup COST / budget.** A per-fight placement budget (or the enemy advancing during setup). Both agents independently named this as the single highest-leverage change: it makes merge a real trade again, stops the merge-T3 trivialisation, and makes the 5-cell scarcity actually bite. It is a genuine economy decision (cost model + numbers) that needs the user + playtest validation — deliberately NOT baked in. It IS the "concentrate-vs-spread cap" churn-axis from §3. **Recommended starting design:** a tile/placement budget per stage where merging consumes placements (so Tier-3 is unreachable on a tight budget), then re-tune HP for ~4–6-volley optimal play and re-run the two persona playtests.
