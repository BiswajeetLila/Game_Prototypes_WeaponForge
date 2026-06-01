# Handoff — WeaponCraft session continuity + Wittle-inversion brainstorm

**Date:** 2026-05-27
**Status:** PAUSED — user researching Phase 1 design questions in a parallel chat. Resume on return.
**Worktree:** `C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\.claude\worktrees\competent-noyce-3f7db4\`
**Active branch:** `weaponcraft-godot/boss-retry-15-waves` (2 Stage-D commits ahead of `main`; not merged)

---

## Session arc (today)

1. **Resumed Stage D work** (boss waves W5/W10/W15 + ReforgeRetryModal + 15-wave bump). Backend + UI both landed as 2 commits on feature branch.
2. **Pivoted to brainstorm** when user pulled in Wittle Defender design spec + Weapon Forge Rings prototype plan, and pitched a feature-level mapping: invert Wittle's hero-gacha → our weapons-gacha + Forge Rings as a roguelike meta-layer.
3. Started Phase 1 design (Inversion core). Reached the "what IS a weapon" fork. Presented 3 options with concrete play moments and 2-tier persistence mapping. **User paused to research in a parallel chat before locking in.**

---

## Stage D ship status (foreground task, parked mid-stream)

**Commits ahead of `main` on `weaponcraft-godot/boss-retry-15-waves`:**

| SHA | Title |
|---|---|
| `7d141fd` | `feat(stage-d) boss waves W5/W10/W15 + retry helper + 15-wave curve` (backend) |
| `76a7944` | `feat(stage-d) ReforgeRetryModal + boss telegraph banner` (UI) |

**Suite state:** **144/144 GREEN**
- TestCombat 57 (was 41; +16 Stage D cases)
- TestRecipes 18 / TestShop 26 / TestMerge 22 / TestUi 21 (unchanged)

**Stage D pending tasks (next session — not blocking brainstorm resume):**
- F5 manual playthrough (user-side).
- ff-merge `weaponcraft-godot/boss-retry-15-waves` → main + push origin + delete remote feature branch.
- 3 boss sprites via `nano-banana` cheap tier (deferred — boss tres files reference no sprite currently; battle_view falls back to null-sprite display).
- Stage D handoff doc → `2_Weaponcraft_Godot/docs/handoffs/2026-05-27-stage-d-bosses-retry.md`
- Stage F (per-fight ult gauge reset + bumped fill constants) still queued from roadmap `C:/Users/Biswa/.claude/plans/snug-jumping-sparrow.md`.

**Schema simplifications vs. plan (noted in Stage D commit body):**
- Lich resist: single tag `&"ice"` instead of `"fire+ice"` (kept single-resist schema; +20% atk phase compensates).
- Spawn count curve unchanged (still 2-3 per non-boss wave); plan's per-band counts deferred. Boss waves do spawn exactly 1.

---

## Wittle Defender — research absorbed today

Full spec read at `C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\docs\research\reference-games\Wittle Defender\wittle-defender-design-spec.md`.

**TL;DR:**
- Hybrid auto-battler / tower-defense / roguelike skill-draft hero collector. Habby (Archero / Capybara Go! studio). $1.4M IAP + 1.3M downloads in <30 days post-launch (June 2025).
- 5 hero slots, fixed positionally (1st → center, 2nd → BR, 3rd → BL, 4th → TR, 5th → TL).
- **20-wave timed arena defense match**; bosses at wave 10/15/20; ~5 min runtime.
- **3-card skill draft per wave** (Rare / Epic / Locked-legendary) → levels hero 1→12 *during the match*. Resets each match. This is the roguelike texture.
- **Chest skills** are a separate in-match skill source.
- **Chain skills**: 2 same-element heroes deployed → passive team buff (e.g., Ice Queen + Ice Demon → "Icicle Storm").
- **4 elements**: Ice / Fire / Wind / Electro. Bosses telegraph weak/resist.
- **Devil's Offer** (mid-run risk/reward proc — debuff-for-buff).

### The 9 stacked progression systems (the whale extraction surface)

1. **Hero roster** (gacha pull, rarity Common→Immortal) + **Star tier** ★1→★20 via dupes + Elemental Essence.
2. **Slot-not-hero level 1→200** (community-favourite — swapping in a better hero inherits the slot's level; no regret).
3. **Gear** (6 slots; cannot fuse; salvage; slot-not-gear enhancement).
4. **Treasures** (6 slots; CAN fuse; each rarity unlocks +1 skill).
5. **Runes** (6 slots; set bonuses matter; manual equip critical for set effects).
6. **Weapons + Glyphs** (post-launch addition; element-locked; lvl 1→50 via silver/gold/element glyphs).
7. **Statues** (preset skill loadouts — Mage / Wind / Fighter / Boss damage bonus presets).
8. **Talents** (per-hero, gold sink, soft pacing).
9. **Outfits** (200-pull on rate-up; **+1% HP/ATK/DEF account-wide whether deployed or not** — top whale hook).

### Match-pacing notes
- 3x speed bugged — meta is 3x for trash, 1x for bosses.
- Force-close re-roll exploit on third-draft (Aug 2025, still unpatched).
- Energy gate: 5 energy/match, 1 energy / ~13-20 min — the daily-check-in anchor.

### Lila strategic take from spec (verbatim direction)

> The skill-drafting + slot-progression hybrid is the most genuinely innovative element and worth lifting. The 9-system progression sprawl is the red flag worth avoiding.

> Wittle Defender's $1.4M/30d at 1.3M downloads ≈ $1.08 per download in month 1 — strong but driven by aggressive whale monetization. The D7 retention question is what would matter to copy. Review decay 96→26/mo over 9 months = D90+ retention is NOT the strength.

---

## User's pitch — INVERT THE GACHA AXIS

> "They have tonnes of heroes, I have tonnes of weapons. They have fire/water/etc squads. I have 5 heroes who employ the elements, like godlike warriors, but they need weapons, so Wittle's char unlocks can be our weapon unlocks. So we're powering up our heroes using the new weapons + other mechanics from Wittle. The chaining of skills happens in a different way like how we have Steamburst and stuff maybe. And per wave, we have the shop still, which rotates to give you upgrades like now, and merge mechanics and stuff."

### The Wittle ↔ our-prototype mapping

| Wittle | Our prototype (proposed) |
|---|---|
| Many heroes / 4 elements / squad of 5 picked from gacha pool | **5 godlike-warrior heroes (LOCKED roster)** wielding many weapons |
| Home-screen gacha pull → random hero (permanent) | Home-screen gacha pull → random **weapon** (permanent) |
| In-match 3-card skill draft (resets each match) | Per-wave **TFT shop of parts** (already exists; resets each stage) |
| In-match hero level 1→12 over 20 waves | Per-wave parts L1→L5 merge (already exists; resets each stage) |
| Bosses wave 10/15/20 | Bosses wave 5/10/15 (Stage D — shipped this session) |
| Chain skills between 2 same-element heroes | **Cross-squad recipe activation** — element tags spanning multiple equipped weapons chain into team buffs |
| Hero star-up via dupes + element essence | **Weapon star-up via dupe-weapon shards + element essence** |
| 6-slot gear / treasure / rune per hero | Weapon's 3 sockets (head/hilt/rune) — existing model; do NOT 1:1-replicate 18 sub-slots |
| Outfits (acct-wide passive) | (TBD — weapon glow skin? Hero skin?) |
| Statues (preset loadouts) | Build templates per weapon |
| Talents (per-hero gold sink) | Per-hero talents (per-hero gold sink) |
| Daily modes (rat hole / goblin / boss / abyss) | TBD parallels (boss challenge daily is the easiest port) |

**The core trick:** the per-wave shop / parts / merge / recipe machinery we already have **stays exactly as the ephemeral in-match texture**. Weapons become the gacha collection that *enables* and *amplifies* what you can do in the shop. Two clean persistence tiers, mapping 1:1 with Wittle's two persistence tiers.

### Plus a roguelike meta-layer

The Weapon Forge Rings prototype plan (`C:\Users\Biswa\Downloads\2026-05-26-weapon-forge-rings.md`) becomes the **between-stage ring puzzle mini-game** that spends end-of-run upgrade points. Three concentric SVG rings; rotate to align power channels; alignment → permanent weapon bonus; misalignment → BACKFIRE (durability loss, weapon destabilises). Volatility gauge + backfire risk = the roguelike risk/reward texture.

---

## Scope decomposition (user-approved)

| Phase | Scope | Status |
|---|---|---|
| **Phase 1 — Inversion core** | Weapons-as-gacha + 5-hero locked roster + weapon star-up via dupes + chain-recipe expansion (cross-squad). Per-wave shop + merge keeps current behaviour. | **In active brainstorm — paused at weapon-shape fork** |
| **Phase 2 — Forge Rings meta** | Between-stage ring puzzle mini-game. Spends end-of-run upgrade points → permanent weapon bonuses. Hades-style permanent progression with backfire risk. | **Outline only — detailed design after Phase 1 lands** |

User pick: detailed Phase 1 now + outline Phase 2.

---

## Phase 1 design fork — paused here

The **"what IS a weapon"** question. Three options were presented in detail. User wanted to take them to a parallel research chat.

### Option 1 — Named legendary (Wittle 1:1) [STRONGEST FIT — my recommendation]

Weapons are the gacha pulls. Equivalent to Wittle's "you pulled Sword Saint." Player opens 10× banner → 10 named weapons drop (each with rarity rolled).

- Each weapon = stat sheet + signature recipe + class lock + rarity tier.
  - **Baneblade of Vulcan** — Epic warrior, +120 atk, signature = Inferno auto-fires on crit.
  - **Frostspire Staff** — Legendary mage, +90 atk +40 hp, signature = Permafrost AoE on ult.
  - **Whisper Dagger** — Rare rogue, +60 atk +20% crit, signature = Shadowstep dupes.
- Star-up tier ★1→★20 via dupe weapons + element essence. +5% / +10% / +15% stats + cosmetic upgrades at milestone tiers.
- Each hero slot equips **ONE weapon at a time**. 5-hero squad = 5 equipped weapons.
- Weapons keep 3 sockets (head/hilt/rune). Per-wave shop sells PARTS that socket in. Current merge mechanic = part level-up (in-run, resets). Recipes activate when weapon signature + 2 socketed parts hit a tag combo.
- **Slot-not-weapon design** (Wittle's most-loved mechanic): upgrade the WEAPON SLOT, not the weapon. Swapping a better weapon in inherits slot level → no regret on pulls.

**Play loop:** pull banner → bigger weapon pool → equip better weapons → bigger base stats + better signature recipes → bigger combo space with socketed parts → push further into chapter map.

### Option 2 — Parts as gacha (current model + star-up)

Weapons stay as head+hilt+rune assemblies (today's model). Per-wave shop becomes the gacha funnel (kind of already is). Add Wittle's star-up layer ON TOP.

- Pulls give parts. Parts have rarity (Common→Legendary). Dupe parts → star-up shards.
- ★1 Iron Edge → ★5 Iron Edge: stat ramp + small passive at ★3 / cosmetic at ★5.
- Currently L1→L5 (in-run only). Star tier would be persistent across runs.
- Heroes / weapons unchanged from current 3-slot prototype.
- Recipes unchanged.

**Cost:** weapons feel anonymous. No "I pulled Baneblade of Vulcan" moment. Closest to current prototype; least disruptive but least exciting.

### Option 3 — Hybrid (weapons via play, parts via gacha)

Two-tier separation.

- ~30 named weapons unlocked through campaign progression, boss drops, recipe-scroll-style discoveries. Slower drip, all eventually obtainable F2P.
- Parts gacha + per-wave shop. Rarity tiers + star-up.
- Weapons define SLOT IDENTITY: which parts you can socket (some weapons +1 rune socket; others lock a tag like "fire-bonded weapon — fire parts only").
- Recipes = parts combos still, but weapon's signature can amplify (e.g., Baneblade doubles Inferno's stack cap).

**Cost:** weakens the gacha splash-pull moment. Parts gacha still extracts revenue but with less identity-defining drama.

### Read

| Option | Wittle-mapping fidelity | Whale extraction | F2P friendliness | Identity-splash on pull |
|---|---|---|---|---|
| 1 — Named legendary | Highest | Highest | Lower | Highest |
| 2 — Parts gacha | Lowest | Medium | Medium | Lowest |
| 3 — Hybrid | Medium | Medium | Highest | Medium |

**My recommendation: Option 1.** Maps cleanest to Wittle's design and the user's "weapons as collection" frame. Option 3 is commercially safer; Option 2 is least disruptive but least exciting.

User wanted to chew on this in parallel chat before locking.

---

## Open design questions queued for user's parallel-chat research

When user returns, work through these in order. Anything they've already answered upstream becomes a locked input.

1. **Weapon shape** — Option 1 / 2 / 3 / hybrid-variant.
2. **Class lock semantics** — strict (warrior weapons only on warrior) vs. soft (off-class equip works but at penalty) vs. universal-and-class-bonus.
3. **Launch weapon roster size** — Wittle has ~50+ heroes; we'd target ~30-50 weapons at launch? Or smaller (~15) at v1.0 and grow with banners?
4. **Star-up curve depth** — Wittle's 20 tiers (Star → Moon → Diamond → Prismatic) or compress to 5 tiers like their hero rarity rungs?
5. **Per-weapon meta-slots** — does each weapon get its own 6-slot gear / 6-slot treasure / 6-slot rune system (Wittle 1:1)? **My instinct: collapse Wittle's gear/treasure/rune into our existing head/hilt/rune 3-socket part system, possibly + 1 modifier slot at high mastery. Don't replicate 18 sub-slots — that's the 9-system sprawl the Lila take warned against.**
6. **Chain-recipe expansion semantics** — Wittle's chain = "2 same-element heroes deployed → passive team buff." Direct translation: 2 same-element WEAPONS in the equipped squad → cross-squad recipe fires? Or stay with per-weapon recipes only (current model)?
7. **Cross-hero / cross-weapon recipes** — e.g., Elara's Frostspire + Vex's Whisper Dagger both have ice → squad-wide "Permafrost" effect persists each tick? New recipe category called "squad chains"? Or compose with existing recipes (Steamburst auto-triggers when fire-and-ice weapons coexist)?
8. **Hero roster size** — target 5 godlike heroes (current 3: Bran/Elara/Vex). Need 2 more. Or stay at 3 + grow in v1.x?
9. **Pulls / banner / pity** — copy Wittle's 100 pity / 300 gem-per-pull / 50-pull rate-up soft pity? Adapt? Different?
10. **Stamina / energy gate** — adopt (Wittle's daily-anchor mechanic) or skip (polarising in their reviews — top 4★ complaint)?
11. **Daily challenge modes** — Wittle's rat hole (gold blitz) / goblin (hero EXP) / boss (element gimmick) / abyss (tower / treasure pulls) — what's the parallel in our world?
12. **Outfits-equivalent** — Wittle's top whale hook is 200-pull outfits granting +1% acct-wide stats. Our parallel: weapon glow skins? Hero skins (godlike-warrior cosmetics)? Equivalent acct-wide passive?

Plus the Phase 2 (Forge Rings) questions below.

---

## Phase 2 — Forge Rings meta-layer (outline)

Plugs in as roguelike meta-layer ABOVE Phase 1 weapon roster.

### Loop
1. Run a stage (15 waves). Earn `forge_shards` (a new currency) from clears + boss kills + recipe discoveries.
2. Visit the Forge between runs (or as a stage-result-screen card).
3. Spend `forge_shards` to "spin up" the ring puzzle for a target weapon.
4. Rotate 3 concentric rings to align power channels (existing ring-puzzle mechanic per `WeaponForge_Rings/index.html` prototype plan).
5. Aligned channels + Forge button → permanent weapon bonus (e.g., +5% atk on that weapon forever; unlock a sub-recipe slot; +1 socket; signature-recipe upgrade).
6. Volatility gauge: each alignment spikes 23.5%; at 95%+ a Forge attempt → BACKFIRE (durability loss + weapon destabilises, lose temporary stats and possibly a forge-shard).
7. Risk/reward: chase harder alignment for legendary bonus, or play safe for incremental.

### Why this is meta vs. in-stage
- Player CHOOSES which weapon to forge-improve over time (intentionality / long-tail goal).
- The roguelike "you might brick a run" tension lives outside the stage flow (a bad ring spin doesn't ruin a stage in progress).
- Permanent buffs = long-tail progression that replaces Wittle's outfit/treasure system at lower content cost.

### Mechanics to lift from `Weapon Forge Rings` design
- 3 concentric SVG rings with 40° power channel arcs at fixed angles per ring.
- Alignment formula: `((currentAngle + powerNodeAngle) % 360 + 360) % 360` must match across all three rings.
- Volatility / durability dual gauges.
- Backfire = scramble rings + durability loss + elemental reset.
- Stat modal on success with damage / overheat / elemental / volatility cost / durability summary.
- "Reforge" reset button to retry within the same forge session.

### Open Phase 2 questions for later
- Is Forge Rings free to spin, or shard-gated?
- Per-weapon Forge progress (each weapon has its own ring-puzzle history)?
- Mythic-tier weapons unlock harder ring puzzles (more rings? smaller alignment window)?
- Does backfire destroy permanent progress, or just temp run-state?
- Should Forge Rings *replace* one of Wittle's 9 sub-systems entirely (e.g., it IS our treasure/rune layer, not in addition)?
- Does Forge run in Godot (port the HTML mockup to Godot Control nodes + Tween) or stay HTML-embedded? **Probably Godot for parity with the rest of the prototype.**

---

## Critical files for next-session navigation

```
2_Weaponcraft_Godot/Prototype/godot/
├── scripts/
│   ├── core/
│   │   ├── combat.gd          (Stage D landed — boss spawn / tick hooks / base_atk / _wave_hp_mult)
│   │   ├── game_state.gd      (TOTAL_WAVES=15, BOSS_WAVES const, revive_squad_for_retry)
│   │   ├── recipes.gd         (recipe matcher — will extend for cross-squad chain recipes)
│   │   ├── shop.gd            (per-wave shop — KEEPS existing model under Option 1)
│   │   └── merge.gd           (L1→L5 part merge — KEEPS existing model under Option 1)
│   ├── data/
│   │   ├── hero_data.gd       (3 heroes today; target 5 godlike)
│   │   ├── enemy_data.gd      (is_boss + atk_override + tags landed for Stage D)
│   │   ├── part_data.gd       (part schema — stays)
│   │   ├── recipe_data.gd     (recipe schema — extends for squad chains)
│   │   ├── weapon.gd          (CURRENT: assembled head/hilt/rune. NEEDS rework if Option 1 lands.)
│   │   └── (NEW) weapon_data.gd  (proposed: weapon-as-gacha definition w/ class lock, signature_recipe, atk_base, hp_base, rarity, star_tier)
│   └── ui/
│       ├── reforge_retry_modal.gd  (Stage D landed)
│       └── main.gd            (boss telegraph + retry routing landed)
├── data/
│   ├── enemies/boss_{slime_king,iron_golem,arcane_lich}.tres  (Stage D)
│   ├── parts/                 (11 parts catalogued today)
│   ├── recipes/               (8 recipes today)
│   └── (NEW) weapons/         (proposed: tres-per-named-weapon)
├── scenes/
│   ├── Main.tscn              (ReforgeRetryModal mount added)
│   ├── ReforgeRetryModal.tscn (Stage D)
│   └── (NEW) WeaponGachaModal.tscn  (proposed)
└── docs/
    ├── 01_GDD.md              (north-star vision)
    ├── 05_roadmap.md          (cadence)
    ├── 02_systems/            (combat_math / pvp_arena / onboarding stubs)
    ├── 03_content/            (characters / parts / recipes scaffolds — feeds Phase 1 schema)
    └── handoffs/              (per-session history; THIS file = 2026-05-27 brainstorm capture)
```

---

## Resume protocol for next session

When user returns from parallel-chat with answers:

1. Read this handoff doc first.
2. Re-invoke `/brainstorming` to continue Phase 1 design.
3. Lock weapon-shape decision (Q1 above).
4. Sequence remaining clarifications (Q2-12) one question at a time.
5. Once design is concrete, propose Phase 1 architecture (data model + Combat refactor scope + Shop changes + Recipe extension + UI mounts).
6. Optional grilling pass via `/grill-me` to stress-test the design.
7. Write final design spec to `2_Weaponcraft_Godot/docs/superpowers/specs/2026-05-27-wittle-inversion-design.md`.
8. Spec review pass (placeholder / contradictions / scope / ambiguity).
9. ExitPlanMode → implementation via `/writing-plans`.
10. Phase 2 (Forge Rings) gets its own brainstorm session **after Phase 1 lands**.

### Before brainstorm resumes — consider closing Stage D
Standing parked task list (low priority; doesn't block Phase 1 brainstorm):
- F5 verify (user-side).
- ff-merge `weaponcraft-godot/boss-retry-15-waves` → main + push origin.
- Boss sprites (3× `nano-banana` cheap tier per cost policy).
- Stage D handoff doc to `2_Weaponcraft_Godot/docs/handoffs/2026-05-27-stage-d-bosses-retry.md`.

---

## Suggested next-session opener

> "Resuming Wittle-inversion brainstorm. I have answers to the design questions from the parallel chat. Read `2_Weaponcraft_Godot/docs/handoffs/2026-05-27-wittle-inversion-brainstorm.md` first, then continue from the Phase 1 weapon-shape question."

---

End of handoff.
