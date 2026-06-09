# Handoff — 2026-06-09 — Teammate deck shipped + docs consolidated

**This is the NEWEST handoff — start here after STATUS / 01_GDD.** Supersedes
`2026-06-08-build-shipped-counterbuild-economy.md` as the resume doc.

## One-line state

Teammate deck (`docs/teammate-deck.html`) shipped + tuned over many iterations
this session; docs/ folder cleanly consolidated (15 stale files archived, new
`01_GDD.md` as the design SSOT); two Lich nerf commits sit on their own branch
awaiting your merge to main. **Catalyst v1 impl is still NOT started** — only
spec + plan exist. Owner-gated next step.

## Branches in flight (3 active)

| Branch | State | Owner action |
|---|---|---|
| `forgeloop/catalyst-element-pairs` | **just FF-merged with the deck branch** (`2a992b8`). Holds Catalyst design spec + the entire deck + the consolidated `01_GDD.md` + the archive cleanup. | Merge → main when ready (owner say-so). |
| `forgeloop/teammate-deck` | Same tip as catalyst now (deck FF-merged INTO catalyst). Branch can be deleted after main merge, or kept for further deck iteration. | Keep or delete — `git branch -d forgeloop/teammate-deck` once main has it. |
| `forgeloop/lich-nerf-stage3` | 2 commits: HP 600→300 (`2b2043c`) + ATK 36→18 + phase-2 AoE 0.30→0.15 (`9e8b982`). TestCombat 65/65 green. | Merge → main when ready. Independent of catalyst — separate concern. |

## What shipped this session

### A. Teammate deck (`forgeloop/teammate-deck` branch → now folded into catalyst)
Self-contained HTML one-pager for Lila internal team + leadership. 9 commits.

- **Files** (live under `5_WeaponForge_Honkai_Godot/docs/`):
  - `teammate-deck.html` — the deck (open in any browser).
  - `decks/style.css` — theme (forge industrial × anime rondel, Cinzel + Manrope + JetBrains Mono, 8-color forge palette).
  - `decks/scrub.js` — Bran 5-tier scrubber + IntersectionObserver dividers + Beats carousel logic + reduced-motion fallback.
  - `decks/assets/` — 12 game assets (heroes, enemies, parts, Bran 5-tier).
  - `decks/assets/beats/` — 8 mockup images (6 from 2E-beats + 2 Elara concept-screens).
- **7 sections + sticky nav:** Hero · Bet · What · Roster · Loop · **Beats** · Build · Next.
- **Hook:** Bran 5-tier portrait scrubber on the Roster card (drag slider, portrait morphs ★1→★5 with the asset's baked labels: Basic / Awakened / Ascended / Eternal / Apotheosis).
- **Beats carousel:** 8 clickable mockups w/ captions (Combat read / Forge Draft / Boss defeat / Forge Wheel pull / Phase-1 part-pull / Hot Paladin / Elara signature / Elara talents / Elara gear). Caption fonts 2× bumped per owner. Auto-fit thumbnail grid.
- **Owner-resolved Qs** during the session: WEAPONFORGE wrap fixed (white-space nowrap + 8vw font clamp), Bran rondel switched from circle to rectangular bg-image frame, slider thumb bumped 16→22 px with ember glow, captions ~2× larger.

### B. Docs consolidation (Codex-reviewed)
Four commits land the doc cleanup per the Codex-revised plan:
- `a61af65` — research consolidated: 918 file renames; `5_WeaponForge_Honkai_Godot/docs/research/` → root-level `Game_Prototypes/docs/research/`. Unique items (`competitor-landscape-synthesis.md`, `portrait-tier-test/`, divergent `anime_autobattlers/`) carried over; existing root research preserved.
- `41006c5` — 21 stale docs archived under `docs/_archive/` with subpaths preserved: `historic-gdds/` (Robotek GDD + Gemini doc), `02_systems/` `03_content/` `04_economy/` (stubs/TFT-era), `handoffs-pre-fork/`, `handoffs-superseded/`. README.md in `_archive/` flags non-authoritative.
- `87087f5` — `docs/2026-06-01-combat-weapon-migration-plan.md` → `docs/superpowers/plans/2026-06-01-socket-retirement-migration.md`. STATUS + 2 handoffs updated inline.
- `f251ead` — **new `docs/01_GDD.md`** (~200 lines opinionated overview + links, NOT a 1000-line subsume). Banner-marked v2.2 spec as DETAIL REFERENCE. STATUS rewritten — points at GDD as design SSOT. CLAUDE.md gets the "update-inline rule" (no session-close ritual — would rot).

### C. Lich nerfs (`forgeloop/lich-nerf-stage3` branch — NOT in catalyst/deck)
- HP 600 → 300 (50% nerf).
- ATK 36 → 18 (50% nerf) + phase-2 AoE ratio 0.30 → 0.15.
- TestCombat 65/65 green throughout; stage-1 contract intact.
- Lich phase-2 Bran-solo per-tick damage went 79 → 39.

## NEXT — the queue that's been on hold all session

The session was a deck + docs detour. **Real prototype work resumes here.** Listed in owner-agreed priority (from STATUS §4 NEXT + this session's design specs):

### 1. **Catalyst v1 impl** (HIGHEST PRIORITY — paused at "go time" earlier)
Spec is locked at `docs/superpowers/specs/2026-06-09-catalyst-design.md`.
Plan is locked at `docs/superpowers/plans/2026-06-09-catalyst.md`.
3-chunk build:
- **Chunk A — Core:** `catalyst_data.gd` + `catalyst_resolver.gd` + `TestCatalyst.tscn` (~11 tests). No game-side effect yet.
- **Chunk B — Integrations:** Starter weapons → non-elemental (`rune = &""`), scripted-pull #1 Fire-Bran + #3 Ice-Elara on Forge Wheel, Combat modifier-bag hook, Account v4 → v5 migration.
- **Chunk C — UI:** Home squad-elements line upgrade, briefing-panel Catalyst section, battle-start banner, persistent HUD chip, Catalyst Codex sub-screen.
Branch is ready (`forgeloop/catalyst-element-pairs`); spec + plan already on it.

### 2. **Lich nerfs → main** (trivial, owner-gated)
`forgeloop/lich-nerf-stage3` is ready. Single FF-merge to main; no test rebaseline needed (already updated).

### 3. **FM-8 hero-bond probe — TWO options**
Pick one OR build both:
- **Option A: Hot Paladin scripted-defeat entry** (Stage 2 cinematic). Mockup exists at `docs/decks/assets/beats/beat5-hot-paladin-cinematic-2E.png`. Requires: a new `paladin` hero data, Sunblade Lance starter weapon, mid-stage cinematic engine, 4-hero squad slot expansion, retry-with-Paladin flow.
- **Option B: Elara signature mission** (mid-game). Mockups exist at `beat6-elara-signature-mission.png` + `beat7-elara-talent-tree.png`. Spec: `docs/superpowers/specs/2026-06-06-economy-restructure-elara-quest-design.md` §5. Requires: quest_state.gd + cinematic + spark-chain combat mechanic + small-B Meteor talent tree.

### 4. **Full-B hero talent trees** (extends from Elara signature)
After option B above: generalize to Bran (Warrior: Taunt → AOE Taunt → Counter) and Vex (Rogue: Poison → Bleed → Execute). Mockup at `beat7-elara-talent-tree.png` shows the template.

### 5. **Socket retirement 9a-e** (depends on Catalyst v1 done first)
Plan: `docs/superpowers/plans/2026-06-01-socket-retirement-migration.md`. Stage 1 done; Stages 2-3 deferred. Becomes do-able once Catalyst replaces the in-stage recipe layer. Expects ~80 legacy tests to delete (TestRecipes / TestShop / TestMerge).

### 6. **Spin cinematic** (last Forge Wheel polish)
The ≤0.6s anvil-strike reel on pull, skippable. Touches `forge_wheel.gd` + a small new animation scene. Mockup at `beat4-forge-wheel-pull-2E.jpg` shows the moment.

### 7. **Balance pass — Numbers Policy tune** (after Catalyst lands)
Tune via playtest data: Ember earn/cost, dupe-to-gems ladder, star-up cost, shard pacing, conflict rate, un-classed %, stage curve, Catalyst compound effect sizes. Per CLAUDE.md §8: starting values only until playtest signals.

### 8. **Human gates** (non-code, can run in parallel)
- Bran 5-tier portrait eval (20 Honkai players) — pass if ≥14/20 give ≥7. Asset: `docs/research/portrait-tier-test/bran_5tier_evolution.png`.
- "Catalyst" trademark check — USPTO TESS + EUIPO eSearch. Fallback names locked: Alloy / Confluence / Reaction / Harmonic.

### 9. **Exit-gate evaluation** (prototype-end)
After ≥3 of the above land. Any 2 of 3 pass: D1≥35%, FM-8 ≥6/10 both axes, ad CPI ≤80% of Wittle. Kill triggers per CLAUDE.md §15.

## How to continue the deck specifically (later, on a fresh branch)

**Why a fresh branch later:** the deck is conceptually independent of Catalyst. Right now it's folded into the catalyst branch because that's where it was authored. After catalyst merges to main, the deck-continuation work should branch off main fresh — the deck and catalyst should not be tangled in future history.

### Resume recipe

```bash
# 1. Verify catalyst (which holds the deck) has merged to main:
git checkout main && git pull --ff-only
ls 5_WeaponForge_Honkai_Godot/docs/teammate-deck.html   # confirm deck file exists on main

# 2. Cut a fresh deck-continuation branch:
git checkout -b forgeloop/teammate-deck-v2
# or whatever next-iteration name fits ("forgeloop/deck-real-screenshots",
# "forgeloop/deck-key-art", etc.)

# 3. Make changes:
#    - Live in 5_WeaponForge_Honkai_Godot/docs/teammate-deck.html
#                                       /docs/decks/style.css
#                                       /docs/decks/scrub.js
#                                       /docs/decks/assets/   (+ /beats/, /heroes/, /enemies/, /parts/)

# 4. Test by opening teammate-deck.html in Chrome / Firefox / Safari.
#    No Godot, no MCP — pure HTML/CSS/JS.

# 5. Commit per change (small, atomic). Push branch. Owner-gated merge.
```

### Likely next deck iterations (owner-driven, not yet requested)

- **Live screenshots.** Owner intended to drop in 3-5 actual-build screenshots later (per deck spec §16). Currently the deck shows mockups — switch to real screenshots from the Godot build once the loop is more visually polished.
- **AI-generated key art / hero portraits.** Currently uses in-game full-body portraits + the Bran 5-tier eval render. Owner may want polished hero key art via nano-banana (~$0.04/img per CLAUDE.md cost policy — confirm before each call). Hot Paladin / 2nd Rogue / 2nd Mage / Hot Assassin are currently silhouette placeholders.
- **More beats as they ship.** When Hot Paladin descent or Elara arc become real game-screen mockups (not concept art), swap the corresponding beat.
- **101 file sync** (deferred — per owner: "keep 101 file up to date and always maintain after major GDD changes"). Not done this session because the deck didn't change the GDD content. Next major design change → update `101-WeaponCraft-Concept.md` to mirror the new GDD state.
- **GitHub Pages publish** (deferred per deck spec §16) — for a shareable URL across the team.
- **Print fallback verification.** The print-CSS exists but hasn't been visually proofed by owner.

### Files map (deck-only — easy reference)

```
5_WeaponForge_Honkai_Godot/docs/
├─ teammate-deck.html             ← the deck (entry point)
└─ decks/
   ├─ style.css                   ← ~600 lines of theme + section + responsive
   ├─ scrub.js                    ← ~150 lines: Bran scrubber + Beats carousel + dividers
   └─ assets/
      ├─ heroes/bran.png · elara.png · vex.png
      ├─ enemies/slime.png · goblin.png · skeleton.png
      ├─ parts/r_fire.png · r_ice.png · r_pierce.png · h_iron_edge.png · p_steel_grip.png
      ├─ bran_5tier.png            ← the scrubber source (1344×768, 5 frames)
      └─ beats/
         ├─ beat1-combat-read-2E.jpg
         ├─ beat2-forge-draft-2E.png
         ├─ beat3-boss-defeat-2E.png
         ├─ beat4-forge-wheel-pull-2E.jpg
         ├─ beat4b-forge-phase1-part-pull-2E.jpg
         ├─ beat5-hot-paladin-cinematic-2E.png
         ├─ beat6-elara-signature-mission.png
         ├─ beat7-elara-talent-tree.png
         └─ beat8-elara-gear-screen.png
```

Per-beat title/sub/desc copy lives in `scrub.js` BEATS[] array — single-place edit to add/remove/retitle beats.

### Design spec + plan (still authoritative)

- Spec: `docs/superpowers/specs/2026-06-09-teammate-deck-design.md` (20 sections, all owner-approved).
- Plan: `docs/superpowers/plans/2026-06-09-teammate-deck.md` (19 tasks across D-1/D-2/D-3 chunks; all executed this session).

If a future change wants to repaint the deck's aesthetic (e.g. flip to anime-TCG holo or arcade-HUD), update the spec FIRST, get owner sign-off, then re-author. The forge × anime-rondel direction is locked unless explicitly revised.

## Standing reminders (per CLAUDE.md)

- **TDD** mandatory on game code; UI deck has manual checklist instead. **Stage-1 combat contract EXACTLY neutral** (TestCombat 65/65; verified this session after Lich nerfs).
- **Engine ops = godot MCP**, main-folder godot path, never a worktree.
- **In-place branches**, no `.claude/worktrees/*`.
- **Merge to main = owner say-so only.** Catalyst and Lich-nerf branches both await.
- **Numbers Policy** — current Catalyst + Ember + Lich values are starting values; tune in playtest.
- **Never `git add -A`** (catches `.import` autosave noise).
- **No new docs** unless task explicitly requires one (specs + plans + handoffs + GDD + CLAUDE are the exceptions).
- **Update `01_GDD.md` inline** when design changes; do NOT fork a parallel SSOT.

## Suggested next-session opener

> "Resume WeaponForge from `5_WeaponForge_Honkai_Godot/docs/handoffs/2026-06-09-teammate-deck-shipped.md` on `forgeloop/catalyst-element-pairs`. Deck + docs + lich-nerf branches all live. Next: pick — (a) merge catalyst + lich-nerf to main and start Catalyst v1 Chunk A (`docs/superpowers/plans/2026-06-09-catalyst.md`), OR (b) something else from the §NEXT queue (Hot Paladin / Elara arc / talents / sockets / spin cinematic / balance / human gates)."

*Session closed 2026-06-09. Catalyst branch tip `2a992b8`. Lich-nerf branch tip `9e8b982`. Both pushed to origin, main untouched.*
