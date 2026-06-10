# WeaponForge — Game Design Document

> ⚙️ **This is the consolidated, top-of-hierarchy design doc.** When the design
> changes, update this file first; the detail specs in `docs/superpowers/specs/`
> may lag. Anything stale is amended here; anything new is folded in here.
> Volatile sections (in-flight features still iterating in playtest) are
> flagged inline.

**Project:** WeaponForge (working title; trademark check pending on "Catalyst" — see §13).
**Engine / repo:** Godot 4.6.2 Mono, `5_WeaponForge_Honkai_Godot/` subproject, forked
from `2_Weaponcraft_Godot/` @ `e958745` on 2026-06-01.
**Maintainer note:** keep this current; it is the entry point for the design.
For *state* (what's done / queued) see `docs/STATUS.md`. For *rules* see
`5_WeaponForge_Honkai_Godot/CLAUDE.md`.

---

## 1. One-liner

A casual-mobile RPG / hero-collector that **inverts the Wittle-Defender gacha** —
you pull *weapons* (not heroes) from a slot-machine Forge Wheel, and master a
**locked 7-hero roster** with anime-style personality + story. Side-view
auto-resolve squad-of-3 combat. Single-tap ultimates. Per-stage Forge Draft
between waves.

---

## 2. The Bet (the strategic frame)

- **Audience.** Wittle Defender ∩ anime-curious. Casual-mobile RPG players who
  would happily install a hero-collector but want more story than the genre
  normally delivers.
- **Inversion.** Wittle pulls heroes. We pull *weapons*. The roster is locked
  at seven — time invested becomes character + bond, not duplicate inventory.
- **Moat.** Equipment-gacha is precedented (Archero $263M LTV). Story-locked
  roster is unprecedented. **The combination is the moat** — neither half is
  novel; the union is.

Detail: `docs/superpowers/specs/2026-05-27-wittle-inversion-design.md` v2.2
(banner-marked as detail reference; this GDD wins on amendments).
Competitor synthesis: `docs/research/2026-05-28-competitor-landscape-synthesis.md`.

---

## 3. Identity (locked decisions, current as of 2026-06-09)

| Area | Decision |
|---|---|
| Gacha unit | **Weapons** (not heroes). Locked 7-hero roster. |
| Pull currency | **Ember.** 5 per pull. Earned from boss-clears (+1) and stage victory (+2). |
| Forge currency | **Gems.** Used for star-up + (S10+) part-pull. Earned from dupes (C 20 / R 40 / E 80 / L 160). |
| Forge consumable | **Shards.** Dropped from C/R pulls (2 each, halved per Ember-economy spec). Spent on rarity-up via deterministic Forge button. |
| Elements (FTUE) | Fire / Ice / Electric / Wind. **Earth gates at Stage 10** (with Forge Wheel Phase 1). |
| Synergy system | **Catalyst** — element-pair compounds. (Renamed from "Resonance" — Habby owns that term.) Trademark check pending; fallback names: Alloy / Confluence / Reaction / Harmonic. |
| Stage shape | **5 waves / boss on W5** for the prototype. Design intent is 15 waves w/ W5/W10/W15 bosses; prototype runs the compressed shape. |
| Save schema | v4 (Ember + scripted-pull bookkeeping + counter-build state). |

---

## 4. Roster (7 locked, 3 FTUE + 4 unlocks)

- 🟢 **Bran** — Warrior. FTUE. Stoic, dependable, front-line tank.
- 🟢 **Elara** — Mage. FTUE. Quiet prodigy w/ a meteor lineage (signature arc, §11).
- 🟢 **Vex** — Rogue. FTUE. Shadow-corps assassin; crits + chains with Elara.
- 📋 **Hot Paladin** — Lance. Unlocks via Stage-2 scripted-defeat cinematic (§11).
- 📋 **2nd Rogue** — variant Rogue, mid-game unlock. Identity TBD.
- 📋 **2nd Mage** — variant Mage, mid-game unlock. Identity TBD.
- 📋 **Hot Assassin** — late-game unlock. Identity TBD.

3 deploy per stage; 4-slot squad opens after Stage 2 (Paladin entry).

---

## 5. Forge Wheel (the gacha)

Two-phase. Same slot-machine UI both phases.

**Phase 0 — Stages 1-9.** Whole-weapon pulls. Equal odds, class-matched to
unlocked roster. **Scripted reveals** preserve the stage-1 neutrality contract
and pace the first Catalyst trigger:

- Pull #1 = guaranteed **Fire weapon, Bran-class**.
- Pull #3 = guaranteed **Ice weapon, Elara-class**.
- Pull #2 + pull ≥4 = normal RNG.
- Starter weapons are **non-elemental** until the scripted pulls land. (Catalyst
  v1 reverses an earlier v2.2 decision that pre-equipped distinct elements.)

**Phase 1 — Stage 10+.** Unlocks via the Master-Smith cinematic. Adds **part-pull**
(150 gems): pick head / hilt / rune; class-matched; 5-tier Forge Math
(same-tier +50% / +1 instant / +2 ½×2 / +3 ⅓×3 / +4 banked). Earth runes drop here.

Spin cinematic (≤0.6 s anvil-strike reel, skippable) is **queued**, not yet built.

---

## 6. Combat (the loop)

Side-view auto-resolve, squad-of-3 vs a wave of enemies. Each stage = 5 waves;
boss on W5. Heroes restored to full HP at stage start.

**Per-wave beat:**
1. Heroes attack on their own timers (per WeaponData stats).
2. Single-tap ultimates fire when each hero's ult gauge fills.
3. A **kill meter** (`ForgeDraft.KILLS_PER_DRAFT`) fills with each kill.
4. Meter full → combat **pauses** → Forge Draft modal opens.

**Forge Draft.** 3 cards on a normal wave, **5 cards on the W5 boss wave** (Wittle
1:1). Card types: stat / ability / element / hero-tagged. Cards = run-scoped buffs
applied to the picked hero's pip row (●○○ → ●●○ → ●●●). RNG draft — the strategic
layer lives **pre-stage**, not in-run.

**Hit math.** Base damage from WeaponData; **weak ×1.8 / resist ×0.5** (counter-build);
crit / ult-rate per hero; stage-scaling bands (+15% HP / +8% ATK per stage at the
prototype curve).

**End conditions.**
- Stage clear → +Ember rewards + stage++ + heroes restored.
- Squad wiped → return to Home loadout screen (no retry modal — sidesteps FM-14).

Detail: `docs/superpowers/specs/2026-06-08-prestage-counterbuild-design.md`.

---

## 7. Pre-stage briefing (the puzzle)

A modal on Home that telegraphs the upcoming stage before the player enters.
Tells the player **two strategic axes**:

**Axis 1 — Counter-build** (shipped 2026-06-08). Bosses are tagged
Fire/Ice/Electric/Wind. `StageAffinity` (pure static) determines per-stage minion
weak+resist deterministically: stage 1 mirrors the boss (teaching), stage ≥2
spreads + occasionally conflicts (≥⅓ rate). Minions roll 80% the stage affinity /
20% un-classed (flavor). Briefing shows boss weak/resist + minion affinity +
squad coverage (✅ / ⚠).

**Axis 2 — Catalyst** (in-flight, §8). Briefing shows the active compound(s)
the player's current squad triggers.

---

## 8. Catalyst (element-pair synergy) — **in-flight, MVP-6 simple v1**

Squad-of-3 carrying weapons of two distinct elements triggers a **named compound**
that buffs the squad. 10 compounds total (6 FTUE-active + 4 Earth-gated S10):

| Pair | Compound | v1 effect (Numbers Policy starting values) |
|---|---|---|
| 🔥 + ❄ | Firestorm | +20% squad ATK |
| 🔥 + 🌪 | Wildfire | +15% ATK · +10% crit |
| 🔥 + ⚡ | Plasma | +15% squad crit |
| ❄ + 🌪 | Blizzard | −20% enemy attack speed |
| ❄ + ⚡ | Glacial Storm | +15% squad ATK |
| 🌪 + ⚡ | Stormfront | +25% ATK *when ≥3 enemies alive* |
| 🔥 + 🪨 | Volcanic (S10) | +30% ATK (v2 adds −20% self move speed) |
| ❄ + 🪨 | Permafrost (S10) | +15% ATK placeholder (v2 = root on heavy hit) |
| 🌪 + 🪨 | Sandstorm (S10) | +15% ATK placeholder (v2 = −30% enemy accuracy) |
| 🪨 + ⚡ | Magnetic Storm (S10) | +15% ATK placeholder (v2 = pull-cluster + 50% AoE) |

**Stacking.** Cap-1 stages 1-4 (alphabetical-by-compound-name priority, Blizzard
wins ties). No-cap stages 5+ (multiplicative bag compose).

**Trigger.** ≥2 distinct equipped weapon elements in the deployed squad matching
a defined pair. Non-elemental starter weapons (`rune = &""`) never count.
Earth-gated compounds skip when `current_stage < 10`.

**Stage-1 neutrality contract.** Starters are non-elemental → no Catalyst
possible on stage 1 → TestCombat's exact-damage assertions stay green.

⚠ Volatile: numbers are Numbers-Policy starts. Tune via playtest, not architecture.

Detail: `docs/superpowers/specs/2026-06-09-catalyst-design.md`.

---

## 9. Economy (4 concurrent axes + a 5th squad-puzzle)

Per `docs/superpowers/specs/2026-06-06-progression-economy-architecture.md` §18
"≤4 concurrent" — older axes fade to background as new ones unlock.

1. **🔥 Ember** (pull currency). Boss +1 / victory +2. Forge Wheel 5/pull.
2. **💎 Gems** (forge currency). Dupes earn (C20/R40/E80/L160). Star-up 100×tier
   (caps ★10). Part-pull 150 (S10+).
3. **🔧 Shards** (rarity consumable). Drop on C/R pulls (2 each), 0 on E+. Spent
   on rarity-up via Forge button.
4. **Talents** (per-hero progression). Gem-spend per node. Small-B Elara tree
   unlocks via signature arc (§11); full-B (Bran/Vex) follows.
5. **Catalyst** (free; squad-loadout puzzle). The pre-stage axis 2 of §7.

Stamina = 10 free spins/day + Forge Rings refill. Outfits = +1% per outfit
cap +20% (locked, not built). Prestige Skins = uncapped cosmetic (post-launch).

Detail: `docs/superpowers/specs/2026-06-06-economy-restructure-elara-quest-design.md`.

---

## 10. Cinematics + signature moments

- **Stage 1 W3** — Elara unlock (still-frame portrait + 80-word panel).
- **Stage 1 W6** — Vex unlock (same).
- **Stage 2 mid** — **Hot Paladin scripted-defeat entry**. The FM-8 hero-bond
  probe (option A). Mid-stage cinematic; Paladin descends + wipes minions; 4-hero
  slot opens; retry-with-4 path. 📋 Queued.
- **Elara signature arc** — first crit-kill of a boss with Elara in squad fires
  "A Spark of Power" cinematic → spark-chain mechanic in combat → small-B Meteor
  talent tree unlocks. FM-8 hero-bond probe (option B). 📋 Queued.
- **Stage 10 — Master Smith** — Forge Wheel Phase 1 unlock + Earth runes + 5-tier
  Forge Math + part-pull. 📋 Queued.

Detail: storyboard per-beat in `docs/prototype-screen-beats.md`.

---

## 11. Exit gates (prototype-end) + kill triggers

**Pass = any 2 of 3:**
- D1 retention ≥ 35%.
- FM-8 hero-bond probe ≥ 6/10 on BOTH axes (attachment + build-investment).
- ad CPI ≤ 80% of Wittle benchmark (~$3.50 → ≤ $2.80).

\+ 10 h internal self-play, "want to come back?" ≥ 70%.

**Kill triggers:** D1 < 30% · satisfaction < 6/10 · no creative within 30% of
Wittle CPI · FM-8 < 6/10 on either axis.

---

## 12. Risk register (pre-mortem highlights)

19 failure modes locked in the v2.2 spec (FM-1 → FM-19). Highest-priority:

- **FM-1** Hero-collector players reject locked-roster. Mitigation: sell weapons
  as the "collection" axis; sell heroes as "your mains."
- **FM-8** Hero-bond probe fails. Mitigation: Paladin entry (option A) +
  Elara arc (option B); test both during prototype.
- **FM-14** Reforge-retry feels punishing. Mitigation: removed retry modal
  2026-06-08; defeat → loadout-adjust screen with no penalty.
- **FM-17** "Catalyst" trademarked. Mitigation: USPTO/EUIPO check before any
  external asset; fallback names locked.
- **FM-19** Bran 5-tier portrait doesn't motivate grind. Mitigation: 20-Honkai-
  player eval gate; fall back to 3-tier if < 14/20.

Full register: `docs/superpowers/specs/2026-05-27-wittle-inversion-design.md` §pre-mortem.

---

## 13. Open trademark + portrait gates (non-code)

- **"Catalyst" TM check** (FM-17) — USPTO TESS + EUIPO eSearch. Pending.
- **Bran 5-tier portrait eval** (FM-19) — 20 Honkai players, ≥14/20 give ≥7 to
  lock 5-tier; else fall to 3-tier. Pending.

---

## 14. Document map (where the details live)

| Doc | Role |
|---|---|
| `docs/STATUS.md` | **state** — done / queued / repo + engine rules. |
| `5_WeaponForge_Honkai_Godot/CLAUDE.md` | **rules** for agents + team. |
| `docs/prototype-screen-beats.md` | **storyboard** — per-screen mockups, ~50 beats. |
| `docs/teammate-deck.html` | **pitch deck** — internal team + leadership. |
| `docs/101-WeaponCraft-Concept.md` | **RICOCHET-template pitch / SSR submission** (current content, name pre-rename). |
| `docs/05_roadmap.md` | **post-launch live-ops** — historical, not prototype scope. |
| `docs/superpowers/specs/2026-05-27-wittle-inversion-design.md` v2.2 | foundational design (banner-marked DETAIL REFERENCE — amendments above win). |
| `docs/superpowers/specs/2026-06-06-progression-economy-architecture.md` | full-game depth map. |
| `docs/superpowers/specs/2026-06-06-economy-restructure-elara-quest-design.md` | Ember-pivot economy + Elara arc spec. |
| `docs/superpowers/specs/2026-06-08-prestage-counterbuild-design.md` | counter-build (shipped). |
| `docs/superpowers/specs/2026-06-09-catalyst-design.md` | Catalyst v1 (in-flight). |
| `docs/superpowers/specs/2026-06-09-teammate-deck-design.md` | deck design. |
| `docs/superpowers/plans/*` | implementation plans. |
| `docs/research/` | competitor + reference research (global, monorepo-wide). |
| `docs/_archive/` | **non-authoritative** stale docs (see `_archive/README.md`). |

---

*Last updated: 2026-06-09 — consolidated from v2.2 (2026-05-27) + economy-architecture (2026-06-06) + economy-restructure (2026-06-06) + counter-build (2026-06-08) + Catalyst v1 (2026-06-09). When this drifts, update HERE first; the detail specs may lag.*
