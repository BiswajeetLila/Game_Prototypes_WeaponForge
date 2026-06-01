# WeaponCraft — Single Source of Truth (STATUS)

> ⚙️ **Active dev folder = `5_WeaponForge_Honkai_Godot`** (forked from `2_Weaponcraft_Godot`
> @ `e958745` on 2026-06-01; see `../FORK-ORIGIN.md`). Path references below that read
> `2_Weaponcraft_Godot/...` are historical-origin paths; live equivalents are under
> `5_WeaponForge_Honkai_Godot/...`. The origin folder is a frozen playtester build.

**Last updated:** 2026-06-01
**Maintainer:** keep this doc current; it is the canonical entry point for the project.

> **If you read one file, read this one.** It points to everything else and states what is done, planned, and remaining.

---

## 1. What WeaponCraft is (one paragraph)

Casual-mobile RPG / hero-collector for the Wittle Defender ∩ anime-curious audience. **Inverts the Wittle gacha axis**: you pull *weapons* (not heroes) from a slot-machine Forge Wheel, and master a **locked 7-hero roster** with anime-style personality + story. Combat is auto-resolved side-view squad-of-3 with single-tap ultimates; 15-wave stages with bosses at W5/W10/W15. Element-pair **Catalyst** compounds (renamed from "Resonance") drive squad synergy. The bet: equipment-gacha is precedented (Archero $263M), story-locked roster is unprecedented — **the combination is the moat**.

---

## 2. Canonical documents (read in this order)

| Doc | Purpose |
|---|---|
| **`docs/superpowers/specs/2026-05-27-wittle-inversion-design.md`** (v2.2) | **THE design spec.** Identity, anchors, fragile assumption, roster, Forge Wheel, combat, synergy, monetization, SSR text bundle, pre-mortem (FM-1→19), exit gates, implementation plan, risk register. |
| `docs/research/2026-05-28-competitor-landscape-synthesis.md` | Competitor landscape (50 games, 170 Sensor Tower calls). Drives v2.2 deltas. |
| `docs/handoffs/2026-05-27-wittle-inversion-brainstorm.md` | Brainstorm session capture (design rationale). |
| `docs/research/ricochet/WIP_DESIGN_DOC.md` | Tarun's RICOCHET concept (template-perfect SSR exemplar). |
| `docs/research/reference-games/` | Wittle Defender, Archero 2, BALL x PIT, Gear Defenders design specs. |
| `docs/research/weaponcraft-forge-mockups/` | F1-F4 nano-banana forge mockups (historic exploration — direction dropped). |
| This file (`docs/STATUS.md`) | Done / planned / remaining + decision log. |

Plan-mode scratch files live in `C:/Users/Biswa/.claude/plans/` (session artifacts, not canonical).

---

## 3. DONE

- **Stage D shipped** — boss waves W5/W10/W15 + ReforgeRetryModal + 15-wave curve. 144/144 tests green. (merged to main 2026-05-28)
- **Design spec v2.1 → v2.2** — full Wittle-inversion design locked across 30+ decisions.
- **Competitor landscape synthesis** — 1197-line research doc, threat ranking, audience profile.
- **Pre-mortem** — 19 failure modes (FM-1→19) with mitigations + 7 quarterly threat trackers (W1-W7).
- **SSR text bundle** — all 5 artifacts authored (135w core / 170w meta / 55w store / 280w first-5min / 340w D1-D14).
- **Repo consolidation** — design spec + research docs committed to main; Stage D merged.
- **101 concept doc** — `docs/101-WeaponCraft-Concept.md` in team template format (RICOCHET structure). ~95% of RICOCHET template completeness.
- **AI-Leverage Inventory** — design spec §23.1 (pipeline accel table, ~1.6× multiplier).
- **Bran 5-tier portrait test render** — `docs/research/portrait-tier-test/bran_5tier_evolution.png`. Awaits 20-Honkai-player eval gate (FM-19).
- **P1a STARTED (TDD)** — `WeaponData` unitary schema: get_atk/get_hp + ★-tier scaling (+5%/tier) + Forge Math (apply_forge_part: same-tier +50%, one-higher instant, lower no-op). **10/10 tests green** (`scripts/data/weapon_data.gd`, `scripts/dev/test_weapon_data.gd`, `scenes/dev/TestWeaponData.tscn`). Headless runner established.

### Key locked decisions (full log in design spec)

| Area | Decision |
|---|---|
| Gacha unit | Weapons (not heroes). Locked 7-hero roster. |
| Roster | Bran/Elara/Vex (FTUE) + Hot Paladin (S2 cinematic) + 2nd Rogue + 2nd Mage + Hot Assassin. 3 deploy/stage. |
| Elements | Fire/Ice/Electric/Wind/Earth (Earth gates S10). 10 Catalyst compounds. |
| Synergy name | **Catalyst** (renamed from Resonance — Habby owns that term). |
| Hero progression | Dual-track: Slot Level 1→200 (inherits) + Hero Mastery 1→100 (per-hero, narrative). |
| Portrait evolution | 5-tier (test-gated; 3-tier fallback if Bran render <14/20 Honkai-player approval). |
| Forge Wheel | 2-phase: Phase 0 (S1-10, whole-weapon pulls) + Phase 1 (S10+, +part-pull upgrade). Slot-machine UI all phases. |
| Part-pull | 150 gems, abstract class-matched parts, immediate-apply, 5-tier rarity ladder with Forge Math. |
| In-stage loot | Forge Draft: 3 skill cards/wave (Wittle 1:1), 5 on boss waves. Auto-merge 3-same. |
| Quest scope | 21 launch quests (3×7 heroes), 49 via live-ops. |
| Banner/pity | Wittle 1:1 (300 gems, 50 soft / 100 hard pity, 50% rate-up, FTUE guaranteed Legendary). |
| Stamina | 10 free/day + Forge Rings spin refill. |
| Outfits | +1% per outfit cap +20%; Prestige Skins (uncapped cosmetic). |
| Skin→dialogue | DEFERRED to v1.x experimental (SSR-test-gated). |
| Dropped | Tier 3 spatial puzzle, Element Attunement, class synergy, hero pair-up moves. |

---

## 4. PLANNED (design locked, not built)

### Pre-flight gates (before Phase 1 implementation)
- [x] Branch for impl work created → `weaponcraft-godot/wittle-inversion-phase1` (merged to main 2026-06-01)
- [~] Bran 5-tier portrait nano-banana test render done → **awaits 20-Honkai-player eval** → lock 5 or fall to 3-tier (FM-19)
- [ ] USPTO/EUIPO trademark check on "Catalyst" (FM-17) → confirm or fall to Alloy/Confluence/Reaction/Harmonic

### Phase 1 implementation (~24.5 sprints / ~6 months)
- **P1a — IN PROGRESS.** WeaponData unitary schema done (get_atk/hp, ★ scaling, Forge Math 3 cases, 10 tests green). **Remaining P1a:** Forge Math diff≥2 bank cases · `skill_card_data.gd` · drop sockets from legacy `weapon.gd` · migrate `combat.gd`+`GameState` to WeaponData · re-run full 144-suite for regression.
- Then: P1b Forge Wheel Phase 0 → P1c Forge Draft → P1d Mastery+Affinity+portraits → P1e Catalyst → P1f Hot Paladin cinematic → P1g hero missions Q1-Q3 → P1h skin shop → P1i balance → P1j SSR+playtest → P1k pre-mortem patches → P1l Discord pre-launch. (Detail: design spec §23.)
- **First-10-min vertical slice = P1a + P1b + P1c + P1f.**

### Exit gates (any 2 of 3): D1≥35% + FM-8 dual-anchor ≥6/10 both axes / ad CPI -20% vs Wittle / 10h internal self-play.
### Kill triggers: D1<30% / satisfaction<6/10 / no creative within 30% Wittle CPI / FM-8 probe <6/10 either axis.

---

## 5. REMAINING (open questions, deferred)

### Next brainstorm
- Reroll cost (Forge Draft): 2g vs ad vs scaling
- Daily challenge modes (Boss Rush / Coin Cave / Hero EXP / Abyss)
- Phase 1 part-pull target-select flow (pull-then-choose default)
- Heroes 5/6 (2nd Rogue, 2nd Mage) personality + identity
- Cinematic script polish (Hot Paladin S2, Master Smith S10)

### Research debt (Sensor Tower / legal / community)
- Wittle/Archero 2 D7/D30 retention; Wittle ARPPU; NTE retention; top-grossing iOS RPG #1
- Survivor.io / AFK Journey / BagMaster overlap pulls
- App Store policy on skin-gated dialogue (informs v1.x)
- Obscure F2P RPGs with story-locked roster (moat-validation)

### Live-ops / post-launch
- Quests Q4-Q10 per hero (49 over 6-8mo); roster +1 hero/6-8wk; skin-dialogue experimental; Prestige Skins; armor gacha (v1.2); PvP arena (Y2); guilds (Y2).

---

## 6. Repo / branch state

- **main** = single source of truth. Contains design spec v2.2.1 + research + Stage D + concept doc + AI-leverage + P1a (phase1 merged 2026-06-01).
- **`weaponcraft-godot/wittle-inversion-phase1`** = active dev branch (P1a). Merged to main 2026-06-01 but kept open for continued P1a work. Resume here.
- `feature/2_v0.2.0-gacha-synergies` = old WeaponCraft_Base HTML prototype (pre-Godot pivot). Left intact on remote; not merged. Abandoned direction.
- Multiple `claude/*` + `.claude/worktrees/*` exist from parallel sessions — left alone (may be live in other windows). Harness auto-cleans stale ones.

### Engine / run
- Godot 4.6.2 Mono. Project: `2_Weaponcraft_Godot/Prototype/godot/project.godot`. F5 to run.
- `.import` files are TRACKED (Godot 4 UID stability). Autosave churn on them is noise — discard, don't commit (K-12).
- Tests: 4 dev scenes (TestCombat/TestRecipes/TestShop/TestMerge), 144/144 green.
