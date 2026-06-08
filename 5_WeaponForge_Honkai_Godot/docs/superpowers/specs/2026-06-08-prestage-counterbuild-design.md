# Pre-Stage Counter-Build Loop — Design Spec

**Date:** 2026-06-08
**Status:** Design APPROVED in brainstorm (owner, 2026-06-08); ready for implementation plan (writing-plans → TDD).
**Branch / worktree:** `weaponcraft-godot/wittle-inversion-phase1` · `.claude/worktrees/pedantic-golick-94f7e8/`
**Project:** `5_WeaponForge_Honkai_Godot/Prototype/godot`
**Parent SSOT:** `2026-06-06-progression-economy-architecture.md` §3 (core loop). This spec **overrides** that section's "deepen the in-run draft into a synthesis draft" idea: per owner direction, the **in-run draft stays RNG**; the strategic layer is the **pre-stage counter-build**.
**Sibling specs:** `2026-06-06-economy-restructure-elara-quest-design.md` (Cores/gems/shards economy — referenced, not required by this spec) · Catalyst = the next core-loop spec after this.

---

## 1. Context (why)

The core-loop risk (FM-2: "Forge Draft too thin → mid-stage boredom") is the one that decides whether the game is *fun*. Owner direction (2026-06-08): the **interesting decision is a pre-stage counter-build** — a stage telegraphs its enemies' element affinities *before* you enter; you equip weapon-elements (from your pulled collection) to counter; the **in-run draft stays RNG spice**, not the strategic lever.

**This is well-grounded:**
- The boss-reactive *foundation already exists* in combat: `combat.gd:365-370` applies **weak ×1.8 / resist ×0.5** from weapon element-tags; bosses already carry weak/resist tags and a pre-fight telegraph fires. The gap is that (a) minion affinity is currently **random per-spawn**, (b) the telegraph fires **at the boss wave**, not pre-stage, and (c) nothing surfaces it as a **build decision**.
- Competitor research (`docs/research/anime_autobattlers/`, 2026-06-08) **validates the loop**: of the 3 closest anime auto-battlers (Terbis, OZ Re:write, Fantasy of Light), **none** implement "telegraph affinity → pre-stage counter-build" ("no reference design exists"). The roguelite-arena-in-anime seat is uncontested; OZ's death (8 mo) shows hero-gacha + open roster + story-only has no moat. Our inversion + counter-build *is* the moat.

---

## 2. Goals / Non-goals

**Goals**
- A **pre-stage briefing** that telegraphs the stage's two affinities (minions + boss) before entry.
- A **counter-build decision**: equip weapon-elements on the 3 heroes to exploit weaknesses / avoid resists, drawn from the pulled collection.
- A **stage affinity model** that makes this a real puzzle (the boss can resist what minions are weak to → tradeoff), and works for infinite procedural stages.
- A **lose → squad/loadout → re-enter** loop: defeat drops you straight on the squad/loadout screen to re-build (no retry/reforge modal).
- Unify the element vocabulary; combat already does the math.

**Non-goals (deferred)**
- **Catalyst** (element-pair squad synergy) — the *next* core-loop spec.
- Deepening the in-run **draft** — it stays RNG; richer card *types* are a later, separate pass.
- **Defensive** element axis (enemy element threatening your heroes) — a later knob; offense-only now.
- **Earth** element — gates later (FTUE set = Fire/Ice/Electric/Wind, per design spec §5).
- **Targeted weapon-exchange** ("pull-N → choose an element") — see §8 research note; deferred QoL, not prototype-critical.
- Squad *selection* depth — prototype deploys all 3 heroes; the lever is weapon-element assignment.

---

## 3. D1 end-to-end walkthrough (the player experience)

Legend: ★ = player decision · [B]uilt · [S] this spec · [E]conomy-pivot spec · [L]ater · ¤Cores ◆gems ✦shards
*(Element values in this walkthrough are illustrative; §4 defines the canonical affinity scheme.)*

```
APP OPEN → granted 3 locked heroes (Bran/Elara/Vex) + a starter weapon each. Wallet ¤5 ◆600 ✦0   [B/E]
   ▼
HOME  [ FORGE WHEEL ] [ ARMORY ] [ ▶ STAGE 1 ]   squad rail shows each hero's equipped ELEMENT     [B]
   ▼
★ FORGE WHEEL PULL  ¤5 → 🎰 reel → reveal a WEAPON (the hook).                                      [B/E]
   • new weapon → keep (+✦2 if common/rare) · dupe → +◆gems (never rots) (+✦2)                      [E]
   ▼
★ ARMORY  class-matched equip. Your pulled weapons = your ELEMENT TOOLBOX.                          [B]
   ▼
⚔️ PRE-STAGE BRIEFING  ◄ THE NEW BEAT ►                                                              [S]
   STAGE 1 "Verdant Hollow":  MINIONS weak🔥/resist❄️   ·   👑 Slime King weak🔥/resist❄️
   YOUR SQUAD: 🔥Bran ❄️Elara 🌪Vex   ⚠️ Elara ❄️ is RESISTED · ✅ Bran 🔥 exploits weak
   [ ADJUST LOADOUT ]                              [ ▶ ENTER ]
   (D1 stage 1 = one obvious counter — teaches the mechanic)
   ▼ ★ swap to a Fire weapon if owned; else enter neutral (still winnable)
BATTLE  5 waves · side-view auto-battle · single-tap ults                                           [B]
   W1–4 trash (minion affinity): 🔥→"WEAK ×1.8" · ❄️→"resist ×0.5"
        every 5 kills → ⏸ ★ RNG DRAFT (3 cards, pick 1) → resume    [B, RNG stays]
        ult gauge full → ★ TAP ult
   W5  👑 BOSS banner · boss draft = 5 cards [S] · boss gimmick fires [B]
   ├─ WIN  → +¤2 +¤1(boss) +◆ +✦ · STAGE 1→2 · 💾 save v4 → HOME richer        [B/E]
   └─ LOSE → "Slime King resisted ❄️Ice — bring 🔥Fire" → straight to SQUAD/LOADOUT → ★ re-equip → ▶ re-enter   [S, no retry modal]
   ▼
LOOP  STAGE 2 boss rotates → 🔩 Iron Golem.  MINIONS weak🔥 · BOSS weak⚡/resist🌪
      → real SPLIT: want 🔥(minions)+⚡(boss) on 3 heroes → tradeoff ★.  Gaps → pull/forge.   [S]
   ▼
SESSION END (~10–15 min): ~2–4 stages cleared, collection grew, 1st dupe→◆, quest nudge [L]. All saved.
```

**The D1 promise:** *"See what the stage is weak to → build my heroes' weapons to exploit it → watch them shred → if I lose, rebuild and win."*

---

## 4. Stage affinity model

- Every stage carries **two affinities**: a **minion affinity** (all trash share it) + the **boss affinity** (rotating boss's own tags). Both telegraphed pre-stage.
- **Boss retag** into the 4-element set *(proposed, tunable — replaces the stray "pierce"):*
  | Boss (rotation) | weak | resist |
  |---|---|---|
  | Slime King | 🔥 Fire | ❄️ Ice |
  | Iron Golem | ⚡ Electric | 🌪 Wind |
  | Arcane Lich | 🌪 Wind | 🔥 Fire |
  Boss for stage N = `STAGE_BOSS_ROTATION[(N-1) % 3]` (existing).
- **Minion affinity = deterministic from stage number** (stable, telegraphable, infinite-stage-safe). Two regimes:
  - **Stage 1 (teaching case):** minions **mirror the boss's affinity** (weak Fire / resist Ice, = Slime King) — no spread, one obvious counter, to teach the mechanic.
  - **Stage ≥2:** `minion_weak` **differs from that stage's boss weakness** (two distinct things to exploit = the spread), and is **tuned so `minion_weak` sometimes equals the boss's *resistance*** — that conflict is the puzzle (the element that shreds minions is shrugged off by the boss → choose how to split 3 heroes).
  - The exact stage→affinity mapping is a small **deterministic lookup/formula finalized in implementation to hit the test targets** (don't hard-code a brittle formula here): differ-from-boss-weak on every stage ≥2, and a boss-resist↔minion-weak **conflict on ≥⅓ of stages**.
- **Per-spawn flavor:** each spawned minion carries the stage's minion affinity with probability **0.80**; ~**20% spawn un-classed** (no weak/resist) for variety + less determinism (`UNCLASSED_CHANCE = 0.20`, tunable). Un-classed minions take neutral damage (no ×1.8 / no ×0.5).
- Replaces `combat.gd`'s **random** minion weak/resist (`combat.gd:510-516`) with this stage-defined affinity (80%) / un-classed (20%).

## 5. Counter mechanic (mostly existing)
- Weapon `rune` = element tag; vs enemy **weak ×1.8 / resist ×0.5**, **offense-only** — already `combat.gd:365-370`. This spec feeds it stage-defined affinities + surfaces them pre-stage.
- **Element set = Fire / Ice / Electric / Wind.** Retire combat's `pierce` tag; migrate `TAG_POOL`.
- **Catalog coverage:** ensure the 12-weapon catalog spans all 4 elements **per class**, so any hero can field any element you've pulled (makes counter-build feasible + rewards collection depth). Verify/retag weapon `rune`s.
- Counter unit = **equipped weapon element, per hero**. Heroes have no innate element. Prototype deploys all 3 heroes → the lever is **weapon assignment**.

## 6. Pre-stage briefing screen (the one new UI)
A panel shown on stage entry (between stage-select and battle):
- **Minion** weak/resist + **Boss** weak/resist — **icons + text** (2 channels = Clarity).
- The squad's **current elements** beside them; a **⚠️ mismatch** hint (resisted / uncovered).
- **[ Adjust Loadout ]** → existing armory/equip + weapon-detail panel. **[ Enter ]** commits.
- Reuses built equip + weapon-detail UI; new = the briefing panel + its data wiring.

## 7. 5-component check (game-design skill)
| Component | Read |
|---|---|
| **Clarity** | Strong — affinities + your elements shown side-by-side, pre-commit. ⚠️ No reference design exists (research) → telegraph must be unmissable; playtest that players act, not skip. |
| **Motivation** | Strong — counter → ×1.8 shred → win; mismatch → pull/forge the missing element (ties to gacha + forge). |
| **Response** | N/A (auto-battle); the **loadout** is the input. Keep ult-tap responsive. |
| **Satisfaction** | Needs juice — "WEAK!" popup + bigger damage numbers + a clear win-because-I-countered read (≥2 channels). |
| **Fit** | Lean-back battle + lean-forward planning. Casual-correct; matches single-tap pitch. |

## 8. Research-driven notes (from `docs/research/anime_autobattlers/`)
- **F2P element availability:** the loop assumes you *own* a counter weapon. Pure-RNG pulls risk "bring Fire, but you have no Fire weapon." For the prototype this is **intended friction** — a gap drives the next pull/forge and feeds the lose→retry loop — **provided stages stay beatable at neutral** (no hard wall). A **targeted-exchange** (Fantasy-of-Light "soft-pity → pick a weapon/element") is the eventual F2P QoL; **deferred** (12-weapon catalog → coverage comes fast).
- **Bank for later (not this spec):** Terbis **keyword-tag chains** (active synergy → enrich Catalyst/talents beyond flat element-pair %); OZ "Mirrorgram" bond loop **as a cautionary tale** — keep hero quests **active/goal-driven** (our Elara spark-chain), not passive messaging (OZ died).
- **Positioning (marketing track, not this spec):** icon/first-frame = forge + roster, not the combat field; scrub "AFK/auto" lead language; keep ASO out of the anime-gacha keyword cloud.

## 9. Scope & phasing
- **This slice:** stage-affinity model (boss+minion split, deterministic) · pre-stage briefing screen · element retag to the 4-set + catalog coverage · **defeat → squad/loadout screen → re-enter** (no retry/reforge modal; defeat doesn't advance the stage, account progress persists, run-scoped draft buffs reset). Counter math already exists.
- **Next:** Catalyst (element pairs) · richer draft card *types* (still RNG) · defensive axis · Earth · targeted-exchange QoL.

## 10. TDD test plan (RED→GREEN per increment; global policy)
Self-quitting dev scenes under `scenes/dev/`+`scripts/dev/`, parsed via the godot MCP (`run_project` → `=== N passed / M failed ===`).

| Increment | Test | RED assertion (pre-impl) |
|---|---|---|
| Stage affinity (deterministic) | new TestStageAffinity | `stage_affinity(n)` is stable per n; **stage 1: minion affinity == boss affinity** (aligned/teaching); **stage ≥2: `minion_weak != boss_weak`** (spread); conflict (`minion_weak == boss_resist`) rate **≥⅓ over stages 2..30** |
| Minion affinity applied | TestCombat / new | each spawned minion is **EITHER the stage affinity OR un-classed** (~20%, empty tags) — never a foreign/random element |
| Boss retag | TestCombat | the 3 bosses carry the new 4-element tags; no `pierce` anywhere |
| Telegraph data | new TestBriefing | briefing exposes both affinities + the squad's current elements + mismatch flags |
| Element migration | TestCombat / TestWeaponData | `TAG_POOL` = {fire,ice,electric,wind}; weak ×1.8 / resist ×0.5 unchanged |

**⚠️ Stage-1-neutral risk:** changing minion affinity (random→deterministic) + retagging touches `combat.gd`. **Must not break the stage-1-neutral combat fixtures** (TestCombat asserts Common rarity_mult=1.0 baselines). Handle: keep stage-1 affinity + the neutral fixtures compatible (e.g. fixtures use no-rune weapons, or stage-1 numbers stay as today). Run TestCombat after every combat change.

## 11. Affected files
**Modify**
- `Prototype/godot/scripts/core/combat.gd` — replace random minion weak/resist with stage-defined affinity; migrate `TAG_POOL` to the 4-set; (telegraph already exists — extend to pre-stage).
- `Prototype/godot/data/bosses/boss_*.tres` — retag weak/resist to the 4-element set.
- Weapon catalog `.tres` (`data/weapons/`) — verify/retag `rune`s for per-class element coverage.
- Stage/Home → battle flow (`scripts/ui/main.gd` / `home_screen.gd`) — insert the briefing step before battle; wire [Adjust Loadout]/[Enter]; **on defeat, route straight back to the squad/loadout (briefing) screen — remove/skip the ReforgeRetryModal.** Defeat does not advance the stage; account progress (weapons/currency) persists; run-scoped draft buffs reset. (Side-benefit: sidesteps FM-14.)

**Create**
- A stage-affinity module/function (`stage_affinity(stage) -> {minion_weak, minion_resist, boss_weak, boss_resist}`), deterministic.
- Pre-stage briefing panel scene/script.
- `scenes/dev/TestStageAffinity.tscn` + `scripts/dev/test_stage_affinity.gd`; extend TestCombat / add TestBriefing.

## 12. Open checkpoints (accepted defaults; flag to change)
1. **Boss retag table** (§4) — element identities OK, or different?
2. **Minion-affinity scheme** (§4) — "sometimes conflicts with boss resist" (≥⅓) accepted; flip to always/never if you want harder/simpler.
3. **Stage names** (e.g. "Verdant Hollow") — placeholder.
4. All §4 numbers/scheme = starting values; tune in playtest.
```
