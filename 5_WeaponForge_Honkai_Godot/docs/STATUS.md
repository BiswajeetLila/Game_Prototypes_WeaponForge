# WeaponCraft — Single Source of Truth (STATUS)

> ⚙️ **Active dev folder = `5_WeaponForge_Honkai_Godot`** (forked from `2_Weaponcraft_Godot`
> @ `e958745` on 2026-06-01; see `../FORK-ORIGIN.md`). Path references below that read
> `2_Weaponcraft_Godot/...` are historical-origin paths; live equivalents are under
> `5_WeaponForge_Honkai_Godot/...`. The origin folder is a frozen playtester build.

**Last updated:** 2026-06-08
**Maintainer:** keep this doc current; it is the canonical entry point for the project.

> **If you read one file, read this one.** It points to everything else and states what is done, planned, and remaining.

---

## 1. What WeaponCraft is (one paragraph)

Casual-mobile RPG / hero-collector for the Wittle Defender ∩ anime-curious audience. **Inverts the Wittle gacha axis**: you pull *weapons* (not heroes) from a slot-machine Forge Wheel, and master a **locked 7-hero roster** with anime-style personality + story. Combat is auto-resolved side-view squad-of-3 with single-tap ultimates. **Prototype build:** a stage = 5 waves (boss on wave 5); bosses rotate slime→golem→lich and scale per stage (procedural — no fixed stage count, 3 boss encounters in rotation). Element-pair **Catalyst** compounds (renamed from "Resonance") will drive squad synergy. (Spec design is 15-wave stages w/ W5/W10/W15 bosses; the prototype runs the compressed 5-wave shape.) The bet: equipment-gacha is precedented (Archero $263M), story-locked roster is unprecedented — **the combination is the moat**.

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

**2026-06-08 design suite (NEW — read alongside the v2.2 spec):**
- `docs/superpowers/specs/2026-06-06-progression-economy-architecture.md` — full-game depth map (15 layers, currency table, core loop, B small/full, ≤4-concurrent pacing).
- `docs/superpowers/specs/2026-06-06-economy-restructure-elara-quest-design.md` — economy pivot (Cores/gems/shards, dupe→gems, shard nerf, Elara spark-chain).
- `docs/superpowers/specs/2026-06-08-prestage-counterbuild-design.md` — pre-stage counter-build (the core-loop "is it fun" fix) + `docs/superpowers/plans/2026-06-08-prestage-counterbuild.md` (the ACTIVE build).
- `docs/research/anime_autobattlers/` — anime auto-battler cluster study (NOT a direct threat; validates the moat + the uncontested counter-build loop).

**THE THREE SSOTs (read these; ignore stale next-step lists anywhere else):**
1. **`docs/STATUS.md`** (this file) — current state + the canonical build queue (§4 NEXT) + repo/branch + engine/MCP rules. **Start here.**
2. **`docs/superpowers/specs/2026-05-27-wittle-inversion-design.md`** — the locked DESIGN (identity / roster / Forge Wheel / combat / synergy / exit-gates).
3. **`docs/handoffs/<newest>.md`** — the session RESUME doc (read the newest on resume).

`docs/05_roadmap.md` is the post-LAUNCH live-ops roadmap ONLY, and predates the inversion pivot (TFT-shop/recipe content) — historical, **not** the prototype queue. The prototype queue is §4 NEXT below.
Plan-mode scratch files in `C:/Users/Biswa/.claude/plans/` are session artifacts, not canonical.

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
- **Teammate deck shipped (2026-06-09, branch `forgeloop/teammate-deck`)** — self-contained HTML one-pager (`docs/teammate-deck.html` + `docs/decks/style.css` + `docs/decks/scrub.js` + 12 asset copies in `docs/decks/assets/`). Forge industrial × anime rondel aesthetic, Cinzel + Manrope + JetBrains Mono, 7 sections w/ `<details>` collapsibles, sticky nav, Bran 5-tier scrubber as the unforgettable hook, scroll-triggered engraved dividers, print fallback, reduced-motion fallback. Spec: `docs/superpowers/specs/2026-06-09-teammate-deck-design.md`. Plan: `docs/superpowers/plans/2026-06-09-teammate-deck.md`.

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

> **UPDATED 2026-06-08.** A long design session added the **economy pivot** + **full-game progression architecture** + the **pre-stage counter-build** core-loop design (see §2 "2026-06-08 design suite"). **SHIPPED + pushed (2026-06-08):** the counter-build plan — 9 commits (boss retag → fire/ice/electric/wind, deterministic `StageAffinity`, minions 80% affinity / 20% un-classed, pre-stage briefing panel, defeat→loadout, + UI polish: solid-bg/autowrap banners so the boss telegraph no longer clips, draft-card click-flash). Playtested OK. **ALSO SHIPPED + pushed (2026-06-08):** the economy (plan `docs/superpowers/plans/2026-06-08-economy-ember-forge.md`, 8 commits) — **Ember** pull-currency (gacha; gems no longer pull; earned boss+victory, 5/pull), gems→forge/**star-up** (gem spend, 100×tier), **dupe→gems** (C20/R40/E80/L160, no more dupe-star), **shard nerf** (SHARD_INC halved + drop 2 on common/rare / 0 on epic+), **save v3→v4** (back-compat: old saves load with ember=0). 301 tests green. **NEXT (roadmap):** Catalyst (element-pair synergy) → Elara signature mission (FM-8) + full-B hero talents. Notes vs the old queue below: the old **#2 elemental/ability cards** is now the **counter-build** work (in-run draft stays RNG; the strategic layer moved pre-stage); **Catalyst** = the next core-loop spec after counter-build; **economy build**, **Hot Paladin**, **Elara spark-quest + hero-talents (B)**, **spin cinematic** all remain queued.

### Pre-flight gates (before Phase 1 implementation)
- [x] Branch for impl work created → `weaponcraft-godot/wittle-inversion-phase1` (merged to main 2026-06-01)
- [~] Bran 5-tier portrait nano-banana test render done → **awaits 20-Honkai-player eval** → lock 5 or fall to 3-tier (FM-19)
- [ ] USPTO/EUIPO trademark check on "Catalyst" (FM-17) → confirm or fall to Alloy/Confluence/Reaction/Harmonic

### Phase 1 implementation (~24.5 sprints / ~6 months)
- **NEW GAME FRAME SHIPPED (2026-06-02).** The GDD core loop is the playable game:
  HOME (Forge Wheel pulls → armory bench grid → tap-tap class-matched equip) →
  STAGE-N battle (squad enters with loaded weapons; kills fill a bar; bar full →
  combat pauses → 3-card Forge Draft pick, run-scoped weapon buffs) → boss rotates +
  scales per stage → victory advances persistent stage; gems/weapons/stage saved at
  `user://account.json` (schema v2). Legacy socket/shop/merge loop invisible (alive
  only for its 144-test contract). **368 tests green.** Full detail + architecture
  map + next steps: `docs/handoffs/2026-06-02-session-handoff-game-frame.md`.
  Effectively: **P1b Phase-0 = LIVE, P1c v1 = LIVE (stat cards only).**
- **FORGE & INFUSE ECONOMY SHIPPED (2026-06-03).** Two independent progression axes —
  **shards → rarity** (a direct stat multiplier; deterministic armory Forge button, no
  minigame) and **dupes → star-up ★** — plus the Q1 "always Bran" pull fix and a 12-weapon
  catalog (4/class × C/R/E/L, pyramid drops). Every pull drops 2 shards (no-waste net);
  heroes stay out of the gacha (the moat). ~415 tests green; stage-1 combat stays neutral.
  Detail + commits: `docs/handoffs/2026-06-03-forge-and-infuse.md`. (Old "next step #1" now
  done except the spin cinematic.)
- **PLAYTEST POLISH + BALANCE (2026-06-05).** Heroes start each stage at FULL HP (HP-bar
  display-refresh fix); legacy battle gold hidden; stage curve softened to +15% HP / +8% ATK;
  reforge-retry now resets ult; weapon detail is a FIXED opaque panel between squad + armory
  with quick-swap (popup reverted); stage-3 Arcane Lich nerfed (hp 850→600, phase-2 AOE
  0.5→0.30). **~423 tests green.** Detail + commits: `docs/handoffs/2026-06-05-session-handoff.md`.
- **P1a — most cycles done (2026-06-01, in `5_WeaponForge_Honkai_Godot`).** WeaponData unitary schema + Forge Math (all diff cases incl. diff≥2 bank: diff2 instant+50% bank, diff3 ½×2, diff4 ⅓×3), `skill_card_data.gd` (SkillCardData Forge-Draft schema: 4 hero-tagged card types), and the WeaponData **combat interface** (`get_crit`/`get_ult_rate`/`get_all_tags`/`get_hp_bonus` — Stage 1 of the combat migration) all DONE under TDD. TestWeaponData 32/32, TestSkillCardData 14/14, **144-suite green (zero regression)**. **Remaining P1a (DEFERRED):** the actual `combat.gd`/`GameState` switch onto WeaponData + socket retirement on `weapon.gd` — blocked because the unitary model can't reproduce multi-part recipe tag-combos, so it needs Forge Draft (P1c) + Catalyst (P1e) built first. Full analysis + staged plan: `docs/2026-06-01-combat-weapon-migration-plan.md`.
- **First-10-min vertical slice = P1a + P1b + P1c + P1f** (full Phase-1 sequence P1b→P1l in design spec §23).

### NEXT — prototype build queue (OWNER-AGREED ORDER, 2026-06-05) ← THE one true queue
Not scheduled "now"; this is the order for upcoming sessions:
1. **#2 — Elemental / ability draft cards** (finishes P1c). Rune cards vs enemy weak/resist + ability transforms → makes the boss 5-card draft matter. Shard `element` field is already wired for it.
2. **#3 — Hot Paladin scripted-defeat entry** (P1f, the FM-8 hero-attachment probe). Re-map the spec's "Stage 2 wave 14" trigger to the 5-wave stage structure; add the Paladin hero + a Paladin starter weapon + the descend cinematic + the retry-with-4-hero-squad flow.
   → **Do #2 + #3 together = the testable FM-8 vertical slice.**
3. **#4 — Catalyst compounds** (P1e, squad element-pair synergy) → THEN **socket retirement 9a–e** (delete legacy sockets/shop/merge + ~80 legacy tests; contracts in `docs/2026-06-01-combat-weapon-migration-plan.md`).
4. **#1 — Spin cinematic** (the last unfinished bit of the Forge Wheel — skippable ≤0.6s anvil-strike reel).
   → **Do #4 + #1 together.**
5. **Human gates** (not code): Bran 5-tier portrait eval (20 Honkai players) + "Catalyst" trademark check.
6. **Merge `phase1` → `main`** — ONLY on explicit owner say.

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

- **`main`** = the LIVE branch now (origin `b6de582`, merged 2026-06-08). **Counter-build + Ember economy + research-`.md` are all MERGED into main** (clean fast-forward from the old `e958745`). **Work from the main checkout** `…\Game_Prototypes\5_WeaponForge_Honkai_Godot` — NOT a worktree.
- **NO MORE WORKTREES (owner pref, 2026-06-08).** Next feature = a branch cut IN PLACE in the main folder: `git checkout -b forgeloop/<feature>` (e.g. `forgeloop/catalyst-element-pairs`). The old `weaponcraft-godot/wittle-inversion-phase1` branch == main now (redundant).
- `feature/2_v0.2.0-gacha-synergies` = old WeaponCraft_Base HTML prototype (pre-Godot). Abandoned.
- Stale `claude/*` + `.claude/worktrees/*` from parallel sessions remain on disk — incl. the orphaned `pedantic-golick-94f7e8` dir (git-unregistered; a long-path file blocked auto-delete; harmless). Left alone.

### Engine / run
- Godot 4.6.2 Mono. **Active project: `5_WeaponForge_Honkai_Godot/Prototype/godot/project.godot`** (F5 to run). `2_Weaponcraft_Godot/...` is the FROZEN playtester build — open it only to demo, never to develop (see its root `FROZEN-2026-06-01.md`).
- **Engine ops via the godot MCP — OWNER PREFERENCE (2026-06-03): default to `mcp__godot__*` for everything Godot.** Run/inspect with `run_project(projectPath, scene?)` → `get_debug_output` → `stop_project`; pass the **main-folder** godot path (`…\Game_Prototypes\5_WeaponForge_Honkai_Godot\Prototype\godot`). Dev-test suites: `run_project(scene=res://scenes/dev/TestX.tscn)` then parse the printed `=== N passed / M failed ===` from `get_debug_output` (self-quitting suites end on their own; legacy TestCombat/Recipes/Shop/Merge/Ui can't take `--quit-after` via MCP → `stop_project` once the summary has printed). Console-exe headless is a fallback only when batch exit codes are required.
- `.import` files are TRACKED (Godot 4 UID stability). Autosave churn on them is noise — discard, don't commit (K-12).
- Tests: **~423 green across 14 dev scenes.** Self-quitting (exit code = fail count): TestWeaponData / TestShardData / TestInfuse / TestHomeScreen / TestAccountState / TestWeaponBridge / TestForgeWheel / TestForgeDraft / TestSkillCardData. Legacy (need `--quit-after 400`): TestCombat / TestRecipes / TestShop / TestMerge / TestUi. Headless gotchas (cold-clone `--import` pass, quit behavior): `docs/handoffs/2026-06-01-session-handoff-p1a-fork.md`.
