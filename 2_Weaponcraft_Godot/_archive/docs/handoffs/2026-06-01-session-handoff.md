# Handoff — 2026-06-01 — WeaponCraft design-lock + P1a kickoff

**Resume from exactly this point in a fresh chat session.**

---

## TL;DR (read first)

WeaponCraft design is locked at **v2.2.1**. Competitor research integrated, concept doc + AI-leverage written, repo consolidated to `main`, and **Phase 1 P1a (weapon schema migration) is in progress** under TDD on branch `weaponcraft-godot/wittle-inversion-phase1` (merged to main today but kept open). Bran 5-tier portrait test rendered, awaiting human eval. Next dev step: finish P1a (drop sockets from legacy weapon, wire WeaponData into combat).

---

## Canonical docs (read in this order)

1. `2_Weaponcraft_Godot/docs/STATUS.md` — **single source of truth** (done/planned/remaining + decision log).
2. `2_Weaponcraft_Godot/docs/superpowers/specs/2026-05-27-wittle-inversion-design.md` — **design spec v2.2.1** (the working GDD; §23.1 = AI-leverage, §21 = exit gates, §20 = pre-mortem FM-1..19).
3. `2_Weaponcraft_Godot/docs/101-WeaponCraft-Concept.md` — team-template concept doc (shareable, RICOCHET format, ~95% of RICOCHET completeness).
4. `2_Weaponcraft_Godot/docs/research/2026-05-28-competitor-landscape-synthesis.md` — 50-game + 170 Sensor-Tower-call research.
5. This handoff.

Plan-mode scratch (how-we-arrived, not canonical): `C:/Users/Biswa/.claude/plans/` → `okay-i-did-a-pure-cerf.md` (latest), `let-s-also-resolve-right-zippy-stallman.md`, `ticklish-percolating-flute.md`, `i-need-to-do-encapsulated-swan.md`.

---

## Concept in one line

Casual-mobile hero-collector that **inverts Wittle's gacha** — you pull *weapons*, not heroes — wrapped around a **locked 7-hero roster** with Honkai-style anime personality + story. Moat = the combination (equipment-gacha precedented by Archero $263M; story-locked roster unprecedented).

---

## Git state (exact)

- **main** HEAD after today's merge = phase1 merged in. Contains: design spec v2.2.1, STATUS, research, Stage D combat, concept doc, AI-leverage §23.1, P1a WeaponData.
- **`weaponcraft-godot/wittle-inversion-phase1`** = active dev branch. Resume here for P1a. Pushed, tracks origin.
- Remote: `https://github.com/BiswajeetLila/Game_Prototypes_WeaponForge.git`
- `feature/2_v0.2.0-gacha-synergies` = old WeaponCraft_Base HTML prototype, abandoned, left intact on remote.
- Other `claude/*` worktrees + branches = parallel sessions, left alone.

### Key commits this session
- `06eb561` docs: design spec v2.2 + research + STATUS (main)
- `9b0af9f` merge Stage D → main
- `7caa788` concept doc (main)
- P1a on phase1: `bf00594` WeaponData first cycle → `c48d60e` star scaling + Forge Math → `95bb24d` §23.1 AI-leverage + .uid
- `af4541a` concept doc cherry-picked onto phase1

---

## Build state (playable)

- **Engine:** Godot 4.6.2 Mono. Binary: `C:/Godot_v4.6.2-stable_mono_win64/`.
- **Project:** `2_Weaponcraft_Godot/Prototype/godot/project.godot`. Main scene `res://scenes/Main.tscn`. F5 to play.
- **What plays today:** Stage-D prototype — 3 heroes (Bran/Elara/Vex, unlock W1/3/6), 15 waves, bosses W5/W10/W15, Reforge-&-Retry on boss wipe, OLD 3-socket forge (head/hilt/rune shop+merge — the slow one), tap-portrait ult.
- **NOT yet built (design-only):** Forge Wheel slot-machine pulls, weapon-gacha, Forge Draft 3-card, Catalyst compounds, Hot Paladin cinematic, hero missions, portrait evolution. `WeaponData` exists in code but is NOT wired into gameplay yet.
- **Tests:** 144/144 green (TestCombat/Recipes/Shop/Merge/Ui) + new TestWeaponData 10/10.

### Headless test run command
```
C:/Godot_v4.6.2-stable_mono_win64/Godot_v4.6.2-stable_mono_win64_console.exe \
  --headless --path 2_Weaponcraft_Godot/Prototype/godot \
  res://scenes/dev/TestWeaponData.tscn
```
Exit code = failure count (0 = green). TestWeaponData auto-quits headless.

---

## P1a status (TDD, in progress)

**Done (10/10 tests green):** `WeaponData` unitary schema —
- `get_atk()/get_hp()` from base stats (no socket aggregation)
- ★-tier scaling (+5%/tier, STAR_STEP)
- `apply_forge_part(part_idx)` Forge Math: same-tier +50% progress, one-tier-higher instant upgrade, lower-tier no-op
- Config fields: id/cls/ability/rune/recipe/rarity_idx/forge_progress

Files: `scripts/data/weapon_data.gd`, `scripts/dev/test_weapon_data.gd`, `scenes/dev/TestWeaponData.tscn`.

**Remaining P1a (next cycles, TDD):**
1. Forge Math diff≥2 cases (diff==2 instant+bank-50%; diff==3 bank-50%; diff==4 bank-33%) — write tests first.
2. `skill_card_data.gd` (Forge Draft card schema — hero/weapon/ability/rune card types).
3. Drop sockets from legacy `scripts/data/weapon.gd` (or retire it); migrate `scripts/core/combat.gd` + `scripts/core/game_state.gd` weapon references from slot-aggregator → WeaponData.
4. Re-run full 144-suite to confirm no regression from the migration.

**TDD discipline reminder:** RED (watch fail) → GREEN (minimal) → REFACTOR. Per user CLAUDE.md, invoke `superpowers:test-driven-development` before production code.

---

## Pre-flight gates (before deep Phase 1)

- [x] phase1 branch created + merged to main
- [~] **Bran 5-tier portrait test rendered** (`docs/research/portrait-tier-test/bran_5tier_evolution.png`) — **ACTION: show 20 Honkai players, ≥14/20 "evolves the character" → ship 5-tier, else 3-tier (FM-19).**
- [ ] **USPTO/EUIPO trademark check on "Catalyst"** (FM-17) — before any external asset. Fallbacks: Alloy / Confluence / Reaction / Harmonic.

---

## First-10-min vertical slice target

**P1a + P1b + P1c + P1f** (~10 sprints). Combat substrate exists (Stage D). New work = WeaponData wiring + Forge Wheel Phase 0 pull + Forge Draft 3-card + Hot Paladin Stage-2 cinematic.

---

## Deferred (next brainstorm / not started)

- Proposal A (GTM/UA strategy: network mix, geo, creative pillars) — drafted in chat, user deferred. ~94→97% completeness lift if added.
- Reroll cost (Forge Draft); daily challenge modes; heroes 5/6 identity; cinematic script polish.
- Research debt: Wittle/Archero D7/D30 retention, ARPPU, NTE retention, App Store skin-dialogue policy.

---

## Suggested next-session opener

> "Resume WeaponCraft from `2_Weaponcraft_Godot/docs/handoffs/2026-06-01-session-handoff.md`. Continue P1a on branch `weaponcraft-godot/wittle-inversion-phase1`: next TDD cycle = Forge Math diff≥2 bank cases, then `skill_card_data.gd`, then migrate combat.gd off the legacy socket weapon."

---

*Session closed 2026-06-01. All work committed + pushed. main + phase1 in sync with origin.*
