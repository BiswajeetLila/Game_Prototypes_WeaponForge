# WeaponCraft — Hero-Squad Meta Design

**Date:** 2026-06-11
**Status:** Design locked (brainstorm complete). Implementation not started.
**SSOT:** elaborates [`../../01_GDD.md`](../../01_GDD.md). Where this doc and the Godot build disagree on *current-state facts*, the build wins; this doc defines *forward direction*.
**Folder rules:** [`../../../CLAUDE.md`](../../../CLAUDE.md). Archive is reference-only.
**Companion docs:** [retention arc D1→D20](2026-06-12-retention-arc-d1-d20.md) · [greenlight pitch (CEO)](2026-06-12-greenlight-pitch.md).

---

## 0. One-line

A cozy fantasy auto-battler where **crafting is the moment-to-moment hook** (TFT-style part-shop → 3-slot weapons → recipe discovery → 15-wave counter-build) and a **persistent hero-squad gacha is the day-to-day progression hook** (collect heroes, each bringing ults, passives, squad synergies, and exclusive recipes).

## 1. Vision & pillars

| Pillar | What it means | Non-negotiable |
|---|---|---|
| **Crafting is the star** | The run (craft + fight) is where skill, depth, and fun live. Potion-Craft-style discovery is the moat. | **Craft ≥ 60% of effective run power.** Heroes flavor/gate the run; they never replace crafting decisions. |
| **Heroes are the meta** | Collecting + leveling + bonding heroes is *why you return tomorrow*. Each hero is a rich unit (5 identity systems). | Hero power ≤ 40%. A maxed hero with no weapon must NOT clear content. |
| **One layer at a time** | Persistence first; gacha second; richness third. No "red-dot hell." | Each phase ships + tests independently. |

**The bet:** the existing craft loop is fun but has zero persistence (every run starts fresh, nothing carries). Adding a persistent hero collection gives the missing 2nd/3rd progression axis and the D1–D3 return reason — *without* abandoning the crafting identity (the mistake that would make us a generic hero-collector and collide with the sibling project `5_WeaponForge_Honkai_Godot`, which is the weapon-gacha take).

## 2. The loop — two screens

```
            ┌─────────────────────── HOME (new) ───────────────────────┐
            │  Roster grid · Form Squad (≤3) · Pull banner (P1+)        │
            │  Per-hero: Level · Star (P1+) · Mastery/bond (P2+)        │
            └───────────────┬───────────────────────▲──────────────────┘
                            │ deploy 3              │ claim rewards
                            ▼                       │ (Hero XP, shards, gems)
            ┌─────────────────────── RUN (today's screen, juiced) ──────┐
            │  Craft weapons in TFT shop → fight 15 waves → W5/10/15 boss│
            │  recipe discovery · merge L1-L5 · boss Reforge-&-Retry     │
            └────────────────────────────────────────────────────────────┘
```

- **Inside (RUN):** unchanged in spirit — the craft+fight loop you already built. Disposable per-run weapons keep it fresh/roguelite.
- **Outside (HOME):** new persistent wrapper. This is where the hero collection lives — NOT crammed into the combat screen.
- **Cycle:** HOME → deploy 3 → RUN → earn Hero XP + shards + pull-currency → HOME → level/pull/bond → push deeper.

## 3. Hero model — a rich unit (phased)

Every hero eventually carries **five** identity systems. Built in order so it never lands as a wall:

| System | What it does | Phase |
|---|---|---|
| **Class affinity** | Auto-routes matching parts to that hero's anvil (exists today). Warrior↔ATK heads, Mage↔ULT hilts, Rogue↔crit/pierce. | exists |
| **Signature ultimate** | Tap-portrait ult scaling with the crafted weapon (Whirlwind/Meteor/Shadowstep exist). | exists |
| **Passive kit** | One run-altering passive per hero (e.g. "+1 anvil slot", "fire parts −2g", "revive once at 1 HP"). Steers how you craft. | P3 |
| **Squad synergy** | Element/class tags; complementary squads trigger team buffs (TFT-trait / Wittle chain-skill flavor). Kept *light* to honor "no first-5-hours tax". | P3 |
| **Exclusive recipes → signature weapon** | Each hero unlocks recipes only they can forge; mastering them yields a craft-and-keep **signature weapon**. | P2–P3 |

**Design rule:** a hero's contribution is *legible* — the player can predict what each hero brings before deploying. Reveal one system at a time as the player progresses (Clarity).

## 4. Progression — Level + Star + Mastery (option 3)

| Track | Source | Reward | Phase |
|---|---|---|---|
| **Hero Level** | Hero XP from runs | Base stat scaling (the reliable spine). | **P0** |
| **Star-up ★** | Duplicate pulls → shards | Upgrades ult + passive tiers. Standard gacha dupe-sink. | P1 |
| **Mastery / bond** | Deploying the hero | Dialogue/story unlocks + a signature passive + **portrait evolution** (visible growth). | P2 |

Narrative depth (Mastery/bond + portraits) is the chosen flavor — the "waifu/story" layer that drives attachment to a fixed-ish roster.

## 5. Economy & currencies

**Hard rule: minimal currencies.** Wittle stacks **~12–14** distinct currencies/materials (verified from its design spec — 11 in the core "Currency Stack" + energy + event currencies like Lunarite/Arena) and the research corpus flags it as an *anti-pattern* ("red-dot hell"), not a target. We start with **four**:

| Currency | Source | Sink | Phase |
|---|---|---|---|
| **Gold** | in-run drops | TFT shop buys + reroll (exists) | exists |
| **Gems** | run drip + (later) IAP | gacha pulls | P1 |
| **Hero Shards** | pulls (dupes), boss drops | Star-up | P1 |
| **Hero XP** | run completion + per-wave | Hero Level | P0 |

A 5th (discovery/expedition) currency arrives ONLY with the roadmap expedition system, and only if its source+sink are clean.

**Gacha (P1) — starting values, all test-gated:**
- Pity: **50 soft / 100 hard** (benchmarked to Wittle 1:1; adjust to economy).
- F2P earns pulls via gem drip; not pull-locked behind IAP.
- Prototype uses soft/premium currency. A **fake/mock store** (simulated purchases, no real charges, no payment SDK) may be added to *feel* the monetization beat **if needed** — real IAP integration stays far out.

## 6. Stage-affinity telegraph (counter-build foresight) — P1

Sharpens the crafting decision (core moat).
- Per-enemy weak/resist already exists and is shown (e.g. `★pierce ~fire`).
- **New:** a pre-stage **scout-intel** panel half-telegraphs the 15-wave stage's threat — reveal the **primary** affinity + 1 hint, hide the rest → player commits a build "set" for the stage, adapts via reroll / boss-retry.
- **Starting value:** reveal **1 of 3** affinity facts pre-stage. *Test: do players verbalize a pre-stage plan? If ignored → reveal more.*

## 7. Permanent weapons — knowledge + signatures (NOT a 2nd gacha) — P2/P3

Resolves the "permanent weapon" idea without killing the fresh per-run craft:
- **Per-run crafted weapons stay disposable** (the fresh juice — untouched).
- **Permanent knowledge (P2):** craft a recipe N times → unlock it as a *known blueprint* you can favor/target in the shop (codex → build-craft). Permanence as *knowledge*, not pre-equipped gear.
- **Hero signature weapons (P3):** unlocked via Mastery + grind, hero-locked, craft-and-keep. This is the tangible form of "exclusive recipes."
- 🔴 **Explicitly rejected:** a weapon gacha (= `5_WeaponForge`'s identity → project collision + sprawl) and "save best weapon → start equipped next run" (kills fresh-craft).

## 8. Juice + audio pass — P0 (folded into the first prototype)

Screenshot reads functional-but-flat; **audio is unbuilt** (Satisfaction needs ≥2 channels — currently visual-only). P0 turns the dials up on what `JuiceConfig` already supports + adds SFX:

| Beat | Add |
|---|---|
| Damage numbers | scale by hit, crit = big element-tinted pop, arc+squash. A crit should *fill the screen*. |
| Enemy | hit-flash + death pop/dissolve. |
| START WAVE | anticipation: button pulse + enemies march in + "wave incoming" telegraph. |
| Recipe procs | flash the pill + 1 VFX on first trigger/wave; show Inferno stack count climbing. |
| Ult 100% | portrait glow ring + screen tint + chunky cinematic. |
| Craft | spark/clink on slot, bouncy `+ATK` floaters. |
| **Audio (new)** | SFX for hit/crit/ult/craft/merge/recipe-discover/buy/reroll + a combat loop. (`02_systems/audio.md` is a stub — gets filled here.) |

Hit-pause stays capped (0.2s) so juice never adds input lag (Response).

---

## 9. P0 — FIRST PROTOTYPE (build on the current Godot project)

**Goal / hypothesis to validate:** *"When heroes persist and level across runs, do players come back for a 2nd/3rd session?"* — the cheapest test of the whole direction, with **no gacha built yet.**

### 9.1 Scope (what P0 adds on top of the current build)
1. **Persistence/save layer** — the current build has none (`GameState` is per-run). Add a save (owned heroes, hero level, hero XP, gold-bank optional). JSON or Godot resource save.
2. **HOME screen (new scene)** — roster of owned heroes (the existing 3) + per-hero Level display + **Form Squad (≤3)** + **Battle** button. Boots here (after a first-run FTUE that still drops straight into a run).
3. **Pre-run squad-select** — pick ≤3 owned heroes → run deploys exactly that squad. **Removes the in-run scripted unlock** (`main.gd` `ELARA_UNLOCK_WAVE=3`, `VEX_UNLOCK_WAVE=6`).
4. **Hero Level** — persistent XP from run completion → base stat scaling. Bran's `120 HP` now derives from his level, not a constant.
5. **Result/rewards screen** — on run end, show Hero XP gained → applied on return to HOME (the visible reward→return link).
6. **Juice + audio pass** (§8).

### 9.2 Explicit NON-goals for P0
No gacha · no Star-up · no Mastery/portraits · no new heroes · no passive kits · no squad synergy · no exclusive/permanent weapons · no stage-affinity telegraph (P1) · no expeditions · no real-money IAP · no stamina. *(All are later phases; listing them prevents scope creep.)*

### 9.3 State machine (run-entry flow)
| Property | Definition |
|---|---|
| States | `HOME` → `SQUAD_SELECT` → `RUN`(wave 1..15) → `RESULT` → `HOME` |
| Entry → RUN | only from `SQUAD_SELECT` with 1–3 owned heroes locked |
| Squad lock | locked at run start; **no mid-run swap**; boss Reforge-&-Retry keeps the same squad |
| Exit RUN | win → `RESULT(victory)` banks XP · wipe → boss-retry first, else `RESULT(defeat)` (partial XP) · quit → confirm dialog, forfeit run XP |
| Edge: roster size | always own ≥1 (Bran); own 1–2 → deploy 1–2; lane already supports ≤3 |
| Edge: app close mid-run | run state is volatile (not saved); only HOME-level meta persists. Closing mid-run = forfeit. |

### 9.4 Numbers (starting values + test plans)
| Value | Start | Test / adjust |
|---|---|---|
| Deploy count | **3** | readable on portrait? if cluttered → 2 |
| Hero Level cap (P0) | **20** | enough headroom for ~1 week of sessions |
| Stat per level | **+5% ATK & HP / level** | *Test: level-10 hero feels stronger but level-20-no-weapon CANNOT clear stage 1 alone (craft must matter). If it can → lower to +3%.* |
| XP / wave cleared | **100** | curve below |
| Level curve | **1000 × level** to next | *Test: ~3–5 full runs to reach a satisfying mid-level (~10). Too slow → halve.* |

### 9.5 5-Component check (P0)
- **Motivation ✅** — runs now change persistent state (the whole point).
- **Satisfaction ⚠️→✅** — juice + **audio** pass closes the visual-only gap; level-up gets a celebration beat.
- **Clarity ✅** — only ONE new concept (heroes persist + level); gacha deferred. FTUE drops into a run first, HOME revealed after stage 1.
- **Response ✅** — meta is menu; tap-ult stays instant; hit-pause capped.
- **Fit ✅** — guardrail: hero level ≤40% power; craft stays decisive.

### 9.6 Playtest script (P0)
1. **Return test (core):** after a run, does the tester *verbalize* a next-session goal ("level Vex up")? If no → the layer failed its only job.
2. **Persistence test:** close + reopen the app — roster + levels + XP persist.
3. **Power-balance test:** level-20-no-weapon vs level-1-great-craft → **craft wins.**
4. **New-player test:** first session (meta hidden) — do they grasp craft→fight unaided?
5. **Squad-select clarity:** does picking 3 read clearly; is "deploy fewer than 3" understood early-game?

### 9.7 Abuse cases (P0)
- Infinite early-stage XP farm → acceptable in P0 (no gacha currency yet); **stamina gate required before P1 currency persists.**
- Quit-to-avoid-loss → quit forfeits XP (defined above).

---

## 10. Phasing — P0 → full game

| Phase | Adds | Validates / unlocks |
|---|---|---|
| **P0** ⬅ first prototype | persistence + HOME + squad-select + Hero Level + juice/audio | "do people return when heroes persist?" |
| **P1** | gacha pull + Star-up + 2–3 new heroes + **stage-affinity telegraph** + Gems/Shards economy + stamina gate + **monetization probe** (mock store live + pull-intent / craft-fan-engagement playtest signal) | the collection + counter-build hooks; first monetizable shape; **de-risks the core bet early** |
| **P2** | Mastery/bond + portrait evolution + **permanent knowledge unlocks** | narrative attachment + crafting permanence |
| **P3** | passive kits + **hero signature weapons** + squad synergy | full hero richness; build diversity |
| **Roadmap / live-ops** | **expeditions/discovery** (send benched heroes → recipes/runes/XP + new currency; Yakuza-0-Majima-flavored, solves roster bloat) · resettable monthly **seasons** · **Elite/Nightmare** difficulty replays · battle pass · cosmetics | evergreen retention |

**Launch roster (target):** 3 free (Bran/Elara/Vex) + 6–9 pullable; +1 hero/month live-ops. *(Watch the small-roster D30 content-cliff — 5_WF flagged this as FM-9.)*

## 11. Risks & mitigations
| Risk | Mitigation |
|---|---|
| **Scope sprawl** (hero = ~8 systems + gacha) | strict phasing; P0 has **no gacha**; one system revealed at a time. |
| **Identity dilution** (becomes a generic hero-collector, collides with 5_WF) | Fit guardrail craft ≥60%; hero power ≤40%; crafting is the run, heroes are the wrapper. |
| **Satisfaction half-dead** (no audio) | audio pass folded into P0. |
| **Currency bloat** (Wittle's anti-pattern) | 4 currencies max until expeditions; every new currency justifies source+sink. |
| **Farm exploit** | stamina gate before P1 currency persists. |

## 12. Open questions / assumptions (flag if wrong)
- **ASSUMPTION:** P0 validates the return-loop with the existing 3 heroes (no new heroes until P1). *If wrong:* P0 feels static → pull one extra free hero into P0.
- **DECIDED:** prototype may include a **fake/mock store** (simulated purchases, no real charges) to feel the monetization beat if needed; no real payment SDK until much later.
- **ASSUMPTION:** save = single local profile (no cloud/account) for the prototype.
- **RESOLVED:** Wittle runs **~12–14** currencies/materials (verified from its design spec). Confirms the anti-pattern; we hold at 4. Deeper economy discussion deferred (per user).
- **OPEN:** does the FTUE boot into a run-then-reveal-HOME, or HOME-first? (leaning run-first for first session only.)

## 13. Cross-project note
`5_WeaponForge_Honkai_Godot` = the **weapon-gacha** take (pull weapons, lock heroes). This project (`2_Weaponcraft_Godot`) = the **hero-gacha + crafting-core** take (craft weapons, collect heroes). **Focus = 2_WC only** — per the CEO review, ignore `5_WeaponForge` and any overlap; the goal is ONE shipped product. The only carryover guard: **do not** add a weapon gacha here.

---

## CEO review (2026-06-12) — decisions & deferred

**Mode:** Selective Expansion (hold P0 scope; cherry-pick strategic forks).

**Decided:**
- **Focus = 2_WC only.** Ignore `5_WeaponForge` and any project overlap; ship ONE product from these iterations.
- **ACCEPTED → P1 monetization probe** (folded into §10/P1). Mock store live in P1 + instrument "would you pull?" and "do crafting-lovers engage the gacha?" Front-loads the scariest assumption (does craft + hero-gacha monetize without repelling craft fans), instead of learning it at P3.

**Deferred (TODO — revisit at P1 economy tuning):**
- **Moat guardrail** (monetization-vs-pillar): codify "heroes monetize via identity / utility / synergy / roster-breadth / cosmetics, NOT raw stat dominance" + a tested invariant (maxed hero + no weapon CANNOT clear). Deferred per user; the `craft ≥60%` prose holds until then. ⚠ The habit forms *during* revenue tuning — hardest to walk back late.
- **Gem-sink cliff:** a 6–9 hero roster caps gem demand fast (FM-9). Needs a 2nd gem sink (expedition currency or a craft-side gem use) before it stalls.
- **Audience-mismatch validation:** craft-depth fans skew gacha-resistant; gacha whales skew non-craft. The P1 probe must explicitly measure whether ONE player wants BOTH — the bet's core unproven premise.

**Sequencing note:** P0 validates the *cheap* assumption (return-on-persistence). The P1 probe now validates the *scary* one (the business model). A green P0 alone does not de-risk monetization.
