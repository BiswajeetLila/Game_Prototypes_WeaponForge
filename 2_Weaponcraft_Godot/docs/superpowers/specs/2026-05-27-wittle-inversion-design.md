# WeaponCraft — Phase 1 Design Spec (Wittle Inversion)

**Date:** 2026-05-28
**Author:** Brainstorm grill + competitor-landscape-synthesis integration
**Version:** 2.2 — post-competitor-research integration
**Status:** Phase 1 design locked. Ready for SSR submission + implementation handoff.
**Prior session:** `docs/handoffs/2026-05-27-wittle-inversion-brainstorm.md`
**Plan files:**
- v2.1 → v2.2 update: `C:/Users/Biswa/.claude/plans/okay-i-did-a-pure-cerf.md`
- v2.0 grill output: `C:/Users/Biswa/.claude/plans/let-s-also-resolve-right-zippy-stallman.md`
**Companion research:** `docs/research/2026-05-28-competitor-landscape-synthesis.md` (1197 lines, 50-game research set, 170 Sensor Tower API calls)

---

## 0. Citation & Tagging Conventions

| Tag | Meaning |
|---|---|
| **[LOCKED]** | Design decision confirmed by user during this grill cycle |
| **[REF:Wittle]** | Lifted/adapted from Wittle Defender (`docs/research/reference-games/Wittle Defender/`) |
| **[REF:Honkai]** | Lifted from Honkai Star Rail aesthetic/UX pattern |
| **[REF:Expedition33]** | Inspired by Expedition 33 character-attachment + unlock cadence |
| **[REF:GearD]** | Lifted from Gear Defenders (`docs/research/reference-games/Gear Defenders/`) |
| **[REF:RICOCHET]** | Pattern from Tarun's RICOCHET concept doc (`docs/research/ricochet/WIP_DESIGN_DOC.md`) |
| **[REF:Bagmaster]** | Backpack-Hero-style spatial puzzle (historical — Tier 3 spatial design discarded in v2.2) |
| **[REF:Research2026-05-28]** | Sourced from competitor landscape synthesis at `docs/research/2026-05-28-competitor-landscape-synthesis.md` |
| **[INFERRED]** | Analytical synthesis, flagged for verification |
| **[GAP]** | Open question, to be resolved in next brainstorm session |

---

## 1. Identity

| Field | Value |
|---|---|
| Working title | **WeaponCraft** |
| Genre / subgenre | Casual-mobile RPG / hero-collector / weapon-gacha-with-forge-meta |
| Target audience | **Habby loyalist ∩ anime-curious cross-platform gamer.** Western + SEA mid-core male, mid-20s to mid-30s, who currently plays Wittle Defender or Archero 2, watches anime on Crunchyroll, owns a PlayStation or Steam library for cross-platform identity, lives in Discord, plays Pokémon GO as a casual side-game, and may also have installed NTE / Genshin / Honkai SR / Wuthering Waves for an anime-action fix. Empirical Wittle audience overlap (Sensor Tower 2026-05-28): Discord 54%, Crunchyroll 31%, PlayStation 23%, Steam 22%, NTE 22.2%, Pokémon GO 23%. **NOT** the Cup Heroes hypercasual-graduate cohort. **NOT** the pure-anime-action-RPG (Genshin-only) cohort. [REF:Research2026-05-28] |
| Platform | Vertical mobile portrait, iOS + Android, F2P + IAP + rewarded ads |
| Engine | Godot 4.6.2 Mono |
| One-line pitch | *"Forge weapons. Bond with heroes. WeaponCraft is a casual-mobile RPG where you pull weapons from a gacha, master a locked seven-hero roster with anime-style personality, and chain element-pair Catalyst compounds across your squad. The Forge Wheel meta unlocks deeper crafting as you progress."* |

---

## 2. Anchors and Pillars

- **Anchor 1 (combat + meta loop):** Wittle Defender, inverted. Their hero-gacha becomes our weapon-gacha. Their slot-not-hero level becomes our slot-not-weapon level plus a dual-track per-hero Mastery. Their Chain Skills element-pairs become our element-pair **Catalyst** compounds (renamed from "Resonance" per v2.2 — Habby now owns the "Resonance" term via Archero 2 + CapybaraGo). [LOCKED] [REF:Wittle] [REF:Research2026-05-28]
- **Anchor 2 (narrative depth):** Honkai-Star-Rail-lite hero personality with Expedition-33-inspired unlock cadence. Heroes have distinct voices, mission chains, dialogue rotation, and visible portrait evolution as you bond with them. [LOCKED] [REF:Honkai] [REF:Expedition33]
- **Pillar 1 (innovation):** The inversion itself — weapons-as-gacha plus a locked seven-hero roster. This is the bet that distinguishes WeaponCraft from every Wittle-shaped competitor. [LOCKED]
- **Pillar 2 (innovation):** Hero narrative depth — Hero Mastery dialogue, personal mission chains, Honkai-tier portrait evolution. Wittle and the broader competitive set skip this layer; it is our moat. [LOCKED]

**F1-F4 spatial-forge-as-USP framing closed.** The four nano-banana mockups in `docs/research/weaponcraft-forge-mockups/` remain as historic exploration. **Tier 3 spatial-puzzle Forge Wheel discarded in v2.2** — replaced by Phase 1 part-pull-upgrade system (see §9).

**Expedition 33 hero pair-up moves dropped permanently.**

**"Resonance" terminology renamed to "Catalyst" v2.2** [REF:Research2026-05-28] — Archero 2 + CapybaraGo own the "Resonance" term; rename protects against player confusion + future trademark exposure.

---

## 3. Single Fragile Assumption (Two-Layer Reframe v2.2)

> *Wittle's mid-core mobile audience will accept weapons-as-gacha replacing heroes-as-gacha — because the **combination** of equipment-gacha + story-locked roster preserves Wittle's slot-level retention loop while adding hero-narrative depth competitors don't have.*

### Two-layer breakdown [REF:Research2026-05-28]

| Layer | Precedent? | Source |
|---|---|---|
| **Equipment-gacha + heroes-not-banner** | YES — Archero (2019, $263M lifetime), Archero 2 ($32.8M/30d), CapybaraGo (Habby's Hero Supply Crate), DQSG (Square Enix April 2026, weapons-gacha + locked vocation roster) | Validated, copyable |
| **Heroes unlock by deterministic story progression** (no shards, no banner, no grind-currency) | **NO precedent in F2P mobile RPG cluster (50-game research set)** | Genuinely unprecedented |

**The combination is the moat.** Either half alone is not. Habby could season-patch Wittle with a "Forge Banner" in 6-18 months (CapybaraGo infrastructure already does equipment-gacha). What Habby will NOT do without forking their playbook is hard-lock heroes to story progression — their LTV model requires hero-banner sales.

### Falsification path

- **Stage-1 SSR bundle:** *"Pulling weapons feels as exciting as pulling heroes, AND I feel attached to MY heroes despite not pulling them."* (FM-8 dual-anchor probe — both axes must score ≥6/10)
- **Stage-1 SSR comprehension probe:** *"Why are heroes locked?"* — players should answer "because they're MINE" or similar emotional read, NOT "because the game is cheap."
- **Stage-4 gameplay video:** 60-second cut showing Forge Wheel pull → hero portrait reaction → first weapon equip → first wave clear → first ability-card transformation. Each beat scored separately.
- **Phase-1 prototype gate:** D1 retention ≥35% (Wittle benchmark 45.9%; we accept -10pp because we're adding a layer); D7 ≥14%; D30 ≥5%.
- **Tell:** if testers describe heroes as "interchangeable" or weapon pulls as "I don't care which one," the bet failed.

---

## 4. Roster — Seven Heroes / Five Classes

[LOCKED]

| # | Hero | Class | Unlock | Personality flavor |
|---|---|---|---|---|
| 1 | **Bran** | Warrior | FTUE start | Stoic, dependable, anime-shounen |
| 2 | **Elara** | Mage | FTUE wave 3 | Curious, scholarly, anime-tsundere |
| 3 | **Vex** | Rogue | FTUE wave 5 (Stage 1 boss clear) | Cocky, blade-loving, anime-trickster |
| 4 | **Hot Paladin** (female, name TBD) | Paladin | Stage 2 hardcoded-defeat cinematic (wave 14) | Warrior-priestess, gravitas, anime-warrior |
| 5 | 2nd Rogue (TBD) | Rogue | Mid-game (~Stage 5-7) | Stealth-DPS variant of Vex's lane |
| 6 | 2nd Mage (TBD) | Mage | Mid-game (~Stage 7-9) | Support/buff Mage vs Elara's burst Mage |
| 7 | **Hot Assassin** (TBD) | Assassin | Late-game (~Stage 12+) | Endgame-narrative-gated, anime-femme-fatale |

- **3 deploy per stage** at v1.0 (preserves current Stage D combat code + 144/144 tests).
- **4 shadow slots** visible on the roster screen at FTUE — silhouettes plus hint text ("Defeat the Iron Lich at Stage 8 to unlock...") drive the Wittle-style visible-incompleteness retention hook. [REF:Wittle]
- Class composition: Warrior × 1, Mage × 2, Rogue × 2, Paladin × 1, Assassin × 1.
- Expand to 5-deploy per stage in v1.x as content grows.

### Hot Baddie Stage 2 cinematic (wave 14 reframe)

[V2 LOCKED — reframed from hardcoded-boss-defeat per pre-mortem FM-7]

- **Trigger:** Stage 2 wave 14. The squad fights brilliantly, almost clears, then a designer-scripted "Iron Lich's Herald" arrives and overwhelms the line. Defeat is narrative, not skill failure.
- **Cinematic beat:** silhouette descends from the upper edge, lands at the squad position, splash-art reveals the Hot Paladin.
- **Dialogue:** *"I saw your blades work hard. The threat was beyond any single squad. Let me join."* — empowering frame, not patronizing.
- **Resolution:** Hot Paladin joins live. Stage 2 retry with 4-hero squad succeeds. Big emotional payoff. Roster grows from 3 to 4.
- **Asset cost:** ~3-5 sprints scripting + 1 cinematic illustration + chibi sprite + portrait via nano-banana cheap tier (~$0.12 total per global cost policy).

---

## 5. Elements — 5-Schema with Earth Mid-Game Gate

[LOCKED, with V2 hybrid mitigation against FM-5]

- **5-element schema at launch:** Fire / Ice / Electric / Wind / Earth (classical model).
- **v1.0 actively-playable at FTUE:** Fire / Ice / Electric / Wind (4 elements, Wittle parity, 6 element-pairs).
- **Earth content gates at Stage 10** (parallel to Forge Wheel Phase 1 unlock + Master Smith cinematic). Earth weapons, runes, and Catalyst compounds reveal then.
- **Season 2 expansion:** consider Shadow as 6th element. Year-2 elements 7-8.
- **10 unique element-pairs at full schema** (Fire-Ice, Fire-Electric, Fire-Wind, Fire-Earth, Ice-Electric, Ice-Wind, Ice-Earth, Electric-Wind, Electric-Earth, Wind-Earth).
- Status tags from prior GDD (Iron, Bleed, Holy, Shadow, Poison) repurposed as **weapon status effects**, not primary elements. Status applies via weapon, not via rune.

### 10 named Catalyst compounds (one per element pair)

System name = "Catalyst." Individual compound names append " Catalyst" suffix for unambiguous in-game language. "Firestorm Catalyst is active!" reads naturally.

| Pair | Catalyst compound | Effect (placeholder; tune in balance pass) |
|---|---|---|
| Fire + Ice | **Firestorm Catalyst** | AoE 20% atk hit on splash; squad-wide |
| Fire + Wind | **Wildfire Catalyst** | DoT spreads to nearest enemy on kill |
| Fire + Electric | **Plasma Catalyst** | +15% crit chance across squad |
| Fire + Earth | **Volcanic Catalyst** | +30% atk, -20% move speed (self) |
| Ice + Wind | **Blizzard Catalyst** | Slow 30% + freeze cone on boss-tier hit |
| Ice + Electric | **Glacial Storm Catalyst** | Stun chance 10% on hit |
| Ice + Earth | **Permafrost Catalyst** | Root enemies 2s on heavy hit |
| Wind + Electric | **Stormfront Catalyst** | Chain lightning 2 jumps |
| Wind + Earth | **Sandstorm Catalyst** | Enemy accuracy -30% |
| Earth + Electric | **Magnetic Storm Catalyst** | Pull enemies into clusters, +50% AoE |

[Earth-involving Catalyst compounds gate at Stage 10 unlock per FM-5 mitigation.]

---

## 6. Hero Progression — Dual Track

[LOCKED]

- **Slot Level 1 → 200** (Wittle's praised pattern). Slot level inherits on hero swap — no investment regret. [REF:Wittle]
- **Hero Mastery 1 → 100** (per-hero, fills only when that hero is deployed). Drives the narrative layer:
  - **Honkai-tier portrait/model evolution** [REF:Honkai]
    - **5-tier (target):** milestones 1 / 25 / 50 / 75 / 100
      - T1 (Basic): plain portrait, chibi model
      - T2 (Awakened, lvl 25): gold edge, weapon glow active
      - T3 (Ascended, lvl 50): pose change, aura particles, elemental tint
      - T4 (Eternal, lvl 75): full pose re-render, ornate weapon, scenery shift
      - T5 (Apotheosis, lvl 100): splash-art-tier portrait + chibi cosmetic crown permanent
    - **3-tier fallback (if test fails):** milestones 1 / 50 / 100
      - T1 (Basic) → T2 (Awakened, lvl 50) → T3 (Apotheosis, lvl 100)
    - **Test gate (v2.2 mitigation FM-19):** Run Bran 5-tier nano-banana cheap-tier render (~$0.60). Show 20 Honkai-player testers. If <14/20 say "evolves the character," **downgrade to 3-tier**. Otherwise ship 5-tier. Decision made before P1d sprint kickoff.
  - **Hero Affinity dialogue unlocks** at Mastery 25, 50, 75, 100 (or 25, 50, 100 at 3-tier)
  - **Personal mission progression** (gated per mitigation FM-1)
  - **Per-hero passive** unlocks at Mastery 50 (e.g., "Bran's Resolve: +3% atk while Bran deployed")

### Why dual-track resolves the slot-inherit narrative weirdness

The Wittle slot-level pattern lets a freshly-equipped hero inherit lvl-50 stats. Without a per-hero progression layer, this reads as narratively incoherent — "Bron just walked in but is somehow lvl 50." Dual-track resolution: slot inherits raw stats, but Hero Mastery (per-hero) is at T1 — the new hero is visibly strong but has not yet bonded. Player intuits: "Bron is mechanically ready but I have not built a relationship with him yet — I should play him."

### Hero personal missions (v2.2 scope-reduced per R4)

[v2.2 LOCKED — scope reduced from 70 to 21 launch quests per R4 in Research2026-05-28]

- All 7 heroes get personal mission chains, structured as **3 quests at v1.0 launch (21 total)** + **7 quests live-ops drip post-launch** (final chain length = 10 per hero, full chain rolls out over 6-8 months post-launch monthly cadence).
- v1.0 launch quest map:
  - **Q1 unlocks at Hero Affinity 25** (per hero, ~D14 for the first 3 starter heroes)
  - **Q2 unlocks at Hero Affinity 50** (~D30)
  - **Q3 unlocks at Hero Affinity 75** (~D45)
  - Q4-Q10 unlocked via monthly live-ops drops post-launch
- The hero's **signature weapon** (Mythic, hero-bound) unlocks at the final quest of the chain (Q10 at full live-ops cadence — so ~D60-D90 for the most-played starter hero).
- Player invests in "Bran's journey to Resolve" hours before the signature weapon arrives. Bond > luck.
- **Why scope-reduced:** Backpack Hero's Story Mode reviews flag long story chains as "grind chore." 3 quests per hero at launch honors screenshot promise + fits production pipeline + spreads narrative authoring across live-ops [REF:Research2026-05-28 R4].
- Authoring v1.0: ~1.5 sprints (was 3 in v2.1; LLM-assisted scripting + narrative QA pipeline per FM-13).
- Authoring per live-ops drop: ~0.3 sprints per hero-quest (LLM-batch + review).

---

## 7. Combat (Stage D shipped + V2 boss bonus draft)

[LOCKED, Stage D ship state preserved, V2 boss bonus draft addition]

- **15-wave stage structure** (W1 through W15).
- **Boss waves at W5, W10, W15** (mini-boss, mid-stage boss, stage final boss). [Stage D shipped 2026-05-27]
- **ReforgeRetryModal** on boss wipe: keep skill stacks + re-pick squad + re-equip weapons + retry the boss wave. [Stage D]
- **Per-stage element-weakness telegraph** on boss waves (current boss affinity system).
- **Auto-resolved combat** with **single-tap ultimate per hero per fight** (current Stage D pillar).
- **Forge Draft post-wave** (see §10).
- **Boss Bonus Draft** [V2 mitigation FM-2]: boss waves (W5, W10, W15) show **5 cards** in the post-wave draft instead of 3, with one pick. Visible "Boss Forge" UI variant signals the dramatic choice moment.

### Per-stage card pick count

- Standard waves W1-W4, W6-W9, W11-W14: 3 cards, pick 1 → 12 picks per stage
- Boss waves W5, W10, W15: 5 cards, pick 1 → 3 picks per stage at higher density
- Total: 15 picks per stage, 3 of which are dramatic-density boss decisions

### Tests state

- 144/144 green on `weaponcraft-godot/boss-retry-15-waves` branch (worktree `competent-noyce-3f7db4`)
- Stage D ship: 2 commits ahead of `main`, not merged

---

## 8. Weapon System

[LOCKED, post-architecture simplification]

### Schema

```
Weapon {
  name:        "Storm Katana"        # named class-flavored ability name
  class:       Warrior                # locked, drives equip eligibility
  ability:     "Stormy Slash"         # baked-in named ability (Storm Cyclone, etc.)
  rune:        Electric               # PERMANENT — set at Forge Wheel; re-forge via shards
  base_atk:    120                    # rolled at forge time
  base_hp:     20                     # rolled at forge time
  recipe:      "Stormbolt"            # built-in, auto-fires when rune element matches class flavor
  rarity:      Legendary              # Common / Rare / Epic / Legendary / Mythic
  star_tier:   ★1 → ★10               # via dupe-weapon shards
}
```

### Decisions

- **Q1 Option 1:** named-legendary weapon gacha via Forge Wheel (Phase 0)
- **Q1a hybrid class-lock:** most weapons class-locked (e.g., Warrior weapons usable by any Warrior), with 1 hero-bound signature weapon per hero (Mythic tier, unlocked via personal mission Q10)
- **Q1b launch count:** 15 weapons in gacha pool (5 Common, 5 Rare, 3 Epic, 2 Legendary — Wittle pyramid) + 7 hero-bound mission signatures = 22 weapons total at full v1.0 unlock
- **Q1c naming escalation:** Common "Iron Edge" → Rare "Steelbiter" → Epic "Wrathblade" → Legendary "Baneblade of Vulcan" → Mythic "Bran's Resolve" (hero-bound)
- **Q2 strictness (D):** strict class-lock with 3-5 universal-pool buffer weapons. Dupe-weapon-of-wrong-class converts to essence usable for star-up of any same-class weapon.
- **Q2a multi-class weapons:** deferred to v2.0
- **Q3a:** Assassin is a distinct class from Rogue (unique weapon archetype: poisoned daggers, throwing stars)
- **Q4 star-up curve:** 10 tiers compressed from Wittle's 20. ★1 → ★2 = 5 dupes ramping to ★9 → ★10 = 50 dupes. Cumulative ~200-300 dupes for max. F2P viable over ~6 months. Per-tier rewards: small flat stat bump, cosmetic glow at ★3/★5/★8/★10, new passive unlock at ★5, mythic passive at ★10.
- **Q5 sockets:** NO sockets at v1.0 — weapons are unitary entities. Phase 1 part-pull system (Stage 10+) provides the upgrade-progression substitute. Modifier slot deferred to v2.0.

### F2P viability matrix

| Source | Weapons reachable |
|---|---|
| FTUE 10-pull (guaranteed 1 Legendary) | 3-5 weapons (one per starter hero biased) |
| Stage first-clears (one Rare per chapter) | ~5 weapons over D14 |
| Hero personal mission signatures (7 total at full roster) | 7 hero-bound Mythics over ~D30-D60 |
| Recipe Codex milestones | 2-3 weapons over D14-D30 |
| Standard daily gem accrual + free pity at 100 | ~1-2 weapons over D30 |
| **F2P D60 total (estimated)** | **~17-22 weapons** |
| Whale equivalent | Full 22 + dupes for max star-up |

Whale-vs-F2P gap target: <2× total power at ★1-equivalent baseline. Tune in combat math balance pass.

---

## 9. Forge Wheel — Two-Phase Design (v2.2 REWRITE)

[LOCKED v2.2 — Tier 0-3 progression from v2.1 discarded. Replaced by simpler 2-Phase model with part-upgrade mechanics at Phase 1.]

Forge Wheel UI: slot-machine across all phases. Reels spin. Number of reels scales with phase (Phase 0 = 1 reel = whole weapon; Phase 1 part-pull = 1 reel = part rarity reveal). Visual unity across phases; mechanic depth at Phase 1.

### Phase 0 — Stages 1-10 (FTUE through early-mid game)

- **1 pull = 1 whole weapon** (Wittle-style splash)
- Slot-machine reveal: single reel spins to land on a named weapon
- Single banner, full rarity pool: 5C / 5R / 3E / 2L pyramid (per Q3 lock)
- Cost: 300 gems / pull
- FTUE 10-pull guaranteed Legendary (per Q9 Wittle parity)
- Player gets up to 22 named weapons over time (15 gacha pool + 7 hero-bound mission signatures)
- Cognitive load: zero forge depth — player learns "I pull, I get cool weapon"

### Phase 1 — Stage 10+ (unlocked via Master Smith cinematic)

Forge Wheel adds a SECOND pull option alongside Phase 0:

- **Weapon Pull** (same as Phase 0) — 300 gems, 1 whole weapon, full pool
- **Part Pull** (NEW) — 150 gems, 1 random part applied to upgrade existing weapon's rarity tier

**Part Pull mechanics:**

- Player taps "Part Pull" button → slot-machine spins a single reel → part rarity revealed (Common / Rare / Epic / Legendary / Mythic)
- Slot-machine animation crescendos similarly to Weapon Pull but visually distinct (gear / anvil motif)
- After reveal, player selects which OWNED weapon to apply the part to (from roster grid)
- **Abstract parts** at v1.0 — no head/hilt subtype, just "Weapon Part" with rarity + class tag
- **Class-matched** — Warrior part only applies to Warrior weapons. Off-class parts auto-convert to **dupe-essence** at 50% refund (essence usable for star-up of same-class weapons)
- Part rarity contributes to target weapon's tier-up meter per Forge Math below
- Immediate application — no inventory stockpile at v1.0 (parts apply during pull cinematic)

#### Forge Math (5-tier ladder, class-matched application)

Let weapon current rarity = X. Pulled part rarity = Y. Both must be class-matched.

| Relation | Effect |
|---|---|
| Y = X (same tier) | +50% progress toward X+1 tier. 2 same-tier parts = upgrade. |
| Y = X+1 (1 tier higher) | Instant upgrade weapon to Y rarity. No bank. |
| Y = X+2 (2 tiers higher) | Instant upgrade weapon to Y rarity + bank 50% toward Y+1. |
| Y = X+3 (3 tiers higher) | Bank 50% toward Y. Need 2 such parts to reach Y. |
| Y = X+4 (Common → Mythic) | Bank 33% toward Y. Need 3 such parts to reach Y. |
| Y < X (part lower than weapon) | No tier contribution. Convert to dupe-essence (50% refund). |

**Concrete examples:**
- Common Sword + Common Part → 50% toward Rare (1 of 2 needed)
- Common Sword + Rare Part → instant Rare Sword
- Common Sword + Epic Part → instant Epic Sword + 50% toward Legendary banked
- Common Sword + Legendary Part → 50% toward Legendary banked (need 2 Legendary parts total)
- Common Sword + Mythic Part → 33% toward Mythic banked (need 3 Mythic parts total)
- Rare Sword + Common Part → No effect, refund as essence
- Epic Sword + Common Part → No effect, refund as essence

**Why this works:**
- Common players see frequent progress (small parts contribute toward visible meter)
- Whales pulling Epics+ get instant gratification on Common/Rare weapons
- High-rarity gaps (Common → Legendary) take effort — preserves whale-vs-F2P gap target <2× per FM-15 mitigation
- Class-matching reinforces hero-class identity (Pillar 2 moat)
- Tier-progress meter visible per-weapon = retention hook ("3 more Commons and I'm at Rare!")

#### UI surfaces for Part Pull progress

- **Weapon-detail card:** large tier-progress bar with rarity icons and percentage. "50% toward Rare ▰▰▰▱▱"
- **Roster grid:** small badge on each weapon thumbnail showing partial-progress indicator (segmented arc around weapon icon)
- **Forge Wheel screen:** post-pull cinematic shows progress bar fill animation tied to the part's contribution

### Master Smith Stage 10 cinematic [LOCKED]

- **Trigger:** Stage 10 first-clear
- **Cinematic beat:** Master Smith NPC arrives at home-screen forge. *"Your forge awakens. Now we can refine, not just create."*
- **UI transition:** Forge Wheel splits — Weapon Pull button + new Part Pull button appear side-by-side
- **Asset cost:** ~2-3 sprints scripting + 1 NPC illustration via nano-banana cheap tier (~$0.08)

### What v2.2 dropped from v2.1

- **Tier 1 separated body+rune pulls** — DROPPED. Phase 0 is whole-weapon end-to-end through Stage 10.
- **Tier 2 head/hilt expansion** — DROPPED. Phase 1 uses abstract parts only (no head/hilt subtypes at v1.0).
- **Tier 3 spatial puzzle (Bagmaster-style)** — DROPPED ENTIRELY. BagMaster benchmark risk + production scope mismatch [REF:Research2026-05-28 §v2.E.2].
- **F1-F4 spatial mockups** — preserved in `docs/research/weaponcraft-forge-mockups/` as historic exploration; not in v1.0 product.

### v2.0 architectural rationale dropped from v2.2

The earlier "Tier 0/1/2/3 progression" framing introduced cognitive cliffs at each tier boundary. v2.2 simplifies to 2 phases with one mechanic addition (part-pull) per phase boundary. Player progression: Phase 0 = learn the pull → Phase 1 = learn the upgrade. Cleaner FTUE-to-mid-game curve.

---

## 10. Forge Draft — In-Stage Loot Flow

[LOCKED, Wittle 1:1 pattern, no inventory, no parts shop]

### Architectural shift

- **3-socket weapon system DROPPED at v1.0.** Weapons are unitary entities.
- **Per-wave parts shop DROPPED.** No buy modal, no inventory tab, no drag-equip.
- **Manual merge DROPPED.** Stacking happens implicitly per Wittle pattern.
- **Persistent inventory DROPPED.** Unpicked cards vanish.

### Forge Draft modal

- **Timing:** post-wave (NOT pre-wave). Wave clears → modal slides up over bottom half of screen.
- **Card count:** 3 cards on standard waves (Wittle 1:1). 5 cards on boss waves W5/W10/W15 (V2 Boss Bonus Draft per FM-2).
- **Pick:** 1 card. Card's effect applies this stage only.
- **Decision time target:** 5-8s per wave.

### Card types (4)

| Type | Example text | Visual flavor |
|---|---|---|
| **Hero stat** | "Bran +20% atk speed" | Hero portrait + stat icon |
| **Weapon tier** | "Storm Katana +base atk" | Weapon icon + tier indicator |
| **Ability transform** (the juicy one) | "Storm Cyclone splits into 3", "Hellfire chains to next enemy", "Stormbolt pulls enemies" | Animated ability preview |
| **Rune intensity** | "Bran's rune intensity +1 tier" | Rune crystal icon + element tint |

**Design principle: minimal flat-stat, maximum visible ability transformation.**

- ✅ "Storm splits into 3" → 3 visible cyclones spawn
- ✅ "Hellfire chains to next enemy" → visible chain VFX
- ❌ "+5% damage" alone is dry — reserve flat-stat for hero-stat cards only

### Tier-up via 3-same stack (Wittle 1:1)

- Pick "Bran +5% atk" 3 times across waves → auto-merges into 1 Rare "Bran +20% atk" card on next draft
- 3 Rares → 1 Epic
- VFX: golden flash + tier indicator floats up on next-wave draft
- No manual merge UI; happens silently

### Authoring scale at v1.0

- 15 weapons × ~4 ability upgrade branches = ~60 ability cards
- 7 heroes × ~5 stat-buff types = 35 hero cards
- 15 weapons × ~3 weapon-tier cards = ~45 weapon cards
- 4-5 elements × ~3 rune intensity cards = 12-15 rune cards
- **Total ~155 base cards + ~100 rare/epic variants via stacking = ~255 unique card states**

Manageable with template scripting + LLM-assisted writing.

### Reroll cost

[GAP — pending user's next brainstorm session. Direction agreed: Wittle-style 2g or rewarded-ad option.]

---

## 11. Synergy Stack

[LOCKED — Wittle 2-axis depth transposed to weapon-driven layer]

| Layer | Mechanic | Trigger | Frequency |
|---|---|---|---|
| L1a | Weapon's class-baked ability (Stormy Slash, Hellfire, etc.) | Equipped + on-attack | Constant |
| L1b | Per-weapon built-in recipe (Stormbolt, Permafrost-recipe, etc.) | Rune element matches weapon class flavor | Periodic auto-fire |
| L3 | **Element Affinity** (2 same-element weapons in squad → +X%) | Pre-stage equip | Auto-active |
| L4 | **Element Mastery** (3 same-element weapons → big buff + status duration) | Pre-stage equip | Auto-active |
| L5 | **Element-pair Catalyst compounds** (different-element pair → named compound: Firestorm, Blizzard, etc., 10 named at full schema) | Pre-stage equip | Auto-active |
| Dropped | Class synergy (Warrior + Paladin etc.) | — | Defer v1.x |
| Dropped | Hero pair-up named moves | — | Dropped permanently |

### Strategic stage-build split

Player chooses each stage based on boss telegraph:

| Build | Composition | Active mechanics | Style |
|---|---|---|---|
| Pure Stack | 3 weapons same element | 1 Element Mastery buff | Max single-element damage; simple play |
| Mixed Catalyst | 2 same + 1 different element | Element Affinity (2x) + 1 Catalyst compound | Balanced; mid complexity |
| Triple Different | 3 different elements | C(3,2)=3 Catalyst compounds simultaneous | Max compound chaos; high complexity |

**No cap on simultaneous Catalyst compounds active.**

---

## 12. Permanent Progression Gifts

[LOCKED, Element Attunement dropped per snowball flaw, V2 re-forge friction reduction]

- **Hero Affinity** (per-hero gauge 0 → 100; fills by deploying that hero in stages). Milestones at 25/50/75/100 unlock dialogue, per-hero passive, signature skin variant, personal mission progression.
- **Recipe Codex Discovery** (account-wide collection of every weapon-ability + Catalyst compound ever triggered; +0.5% damage account-wide per recipe, capped at +25% at 50 discoveries).
- **Forge Rings shards** (separate Phase 2 currency for re-forging rune element on weapons + stamina refill — see §16).

### Re-forge economy (V2 mitigation FM-4)

[V2 LOCKED]

- First re-forge of any weapon: **50 shards** (down from 100 in V1)
- After Stage 10 Master Smith cinematic: re-forge cost halves to **25 shards** (Master Smith narrative beat includes the easing of cost)
- Hero Affinity 25 milestone grants **1 free rune re-forge token** per hero
- Goal: keep element diversity alive long-term; avoid players locking into one element loadout

### Element Attunement (DROPPED)

- Considered early in grill; dropped due to self-fulfilling snowball flaw (Fire Attunement → use Fire more → snowballs → other elements orphan).
- Replaced by Hero Affinity + Recipe Codex (above), which do not snowball because they target diversity (use all heroes) and discovery (use all recipes) rather than per-element-stat-compounding.

---

## 13. Cinematics

[LOCKED, V2 wave-14 reframe + Master Smith Stage 10]

| Trigger | Beat | Asset cost |
|---|---|---|
| **Stage 2 Hardcoded Defeat → at wave 14, NOT boss wave 15** [V2] | Squad fights brilliantly through 14 waves. Iron Lich's Herald appears. Defeat is narrative. Hot Paladin descends, splash reveal, *"I saw your blades work hard. The threat was beyond any single squad. Let me join."* Empowering, not patronizing. Stage 2 retry succeeds with 4-hero squad. | ~3-5 sprints scripting + ~$0.12 art (nano-banana cheap) |
| **Stage 10 Master Smith Forge Unlock** | NPC: *"Your forge awakens. Now we can refine, not just create."* Phase 1 forge unlocks (Part Pull becomes available, 150 gems). Forge Wheel UI splits to show both Weapon Pull + Part Pull buttons. | ~2-3 sprints scripting + ~$0.08 art |

### Why wave-14 reframe works (FM-7 mitigation)

The original V1 placement at the wave-15 boss read as "rigged" — players who lose to a designer-scripted boss they cannot beat feel cheated. V2 places the defeat at wave 14, BEFORE the boss. Player demonstrates competence over 14 waves of real combat. The Herald's arrival reads as a story event, not a skill failure. Paladin's dialogue then validates competence: "I saw your blades work hard."

---

## 14. Skin → Dialogue Link (DEFERRED to v1.x experimental per v2.2)

[v2.2 DEFER — was v2.1 LOCKED for v1.0 launch, demoted to v1.x experimental per R5/v2.E.1 in Research2026-05-28]

**v1.0 ships Hero-Mastery-milestone-gated dialogue ONLY** (no purchase gate). Dialogue unlocks at Affinity 25/50/75/100 milestones via §6. Skins remain pure cosmetics at v1.0.

**Why deferred:**
- Unprecedented monetization (zero precedent in 50-game research set) — could be moat OR untested regulatory risk
- App Store / ESRB exposure on paywalled story content (legal review needed — Q8 in §22 open questions)
- Authoring debt: 7 heroes × ~10 skins × ~15 lines = 1,050+ LLM lines + human-review pipeline ($5-8k/month per FM-13)
- Value proposition stacks two assumptions: player pays for cosmetic AND values the dialogue unlock

**Re-evaluation window:** 6 months post-launch. Run SSR Stage-1 purchase-intent test (R5 in Research2026-05-28):
- Test mockup: skin-with-dialogue (+12 lines unlocked) vs skin-with-VFX-only
- If dialogue-unlock <10% bump in purchase intent → kill permanently; Mastery-milestone dialogue alone is the moat
- If dialogue-unlock ≥10% bump AND App Store policy review passes → ship at v1.x

**v1.0 fallback (Hero-Mastery-milestone-gated dialogue) still ships and is sufficient for narrative-depth moat (Pillar 2).** Skin-dialogue would be ADDITIVE on top of Mastery dialogue, not a replacement.

This demotion saves: ~$50k+ ongoing narrative QA budget for v1.0 launch; defers App Store policy risk until live-ops data validates the LTV bump.

---

## 15. Outfits Whale Hook + Prestige Skins

[LOCKED, V2 + Prestige Skins addition per FM-6]

### Outfit stat-stacking (capped)

- +1% account-wide stat per outfit (HP/ATK/DEF)
- Cap: +20% max (20 outfits ceiling)
- Less predatory than Wittle's uncapped pattern (which drives whale 1★ outrage per review data)

### Prestige Skins (V2 NEW)

- Uncapped cosmetic-only pull tier
- Each Prestige Skin = signature recipe VFX variant (e.g., Bran's red Prestige = Stormbolt fires red flame, with chibi cosmetic crown)
- Skin-dialogue rotation per Prestige skin (per §14)
- No stat contribution → no whale 1★ revolt risk
- Whale flex via uncapped cosmetic-status

This split protects the rating floor while preserving whale extraction LTV.

---

## 16. Stamina / Energy

[Q10 LOCKED]

- **10 free plays per day** (replenishes at midnight local OR rolling regen, TBD)
- **Free refill via Forge Rings spin** — ties Phase 2 mechanic to daily-anchor retention
- **Refill via gems** optional (240 gems = full refill, cap 2 paid refills/day)
- Lighter than Wittle's 5/match × 13-20min regen (which is the top 4★ complaint in Wittle reviews)

---

## 17. Banner / Pity

[Q9 LOCKED — Wittle 1:1]

- 300 gems per pull
- 50-pull soft pity (Epic guaranteed by pull 50)
- 100-pull hard pity (Legendary guaranteed by pull 100)
- 50% rate-up share on featured banner
- **FTUE 10-pull = guaranteed 1 Legendary** (drama hook)
- 10-pull discount: 10× cost 9× single price + 1 guaranteed Rare+

---

## 18. Progression Axes — Cap at 4

[LOCKED — explicit discipline against Wittle's 9-axis sprawl]

1. **Weapons** (gacha + Forge Wheel tier progression + slot-level + 10-tier star-up + ★8 modifier slot in v1.x)
2. **Heroes** (slot-level + Mastery + Affinity + Honkai-tier portrait evolution + per-hero passives)
3. **Recipe Codex** (account-wide discovery, +0.5%/recipe cap +25%)
4. **Forge Rings shards** (permanent currency from runs + Phase 2 spend surfaces)

**Rejected:** Armor gacha (defer v1.2), Outfits acct-wide stat > +20% (predatory), Element Attunement (snowball), Class synergy (defer v1.x), Hero pair-up moves (dropped), Talent tree as separate axis (folded into hero passives).

Prestige Skins are a sub-system of axis 2 (hero cosmetics), not a 5th axis.

---

## 19. SSR Text Bundle (Stage 1 + 2 deliverables) — v2.2 RE-AUTHORED

### 19.1 Core loop description (135 words)

```
You command a squad of three heroes — a warrior, a mage, a rogue —
who hold fixed positions in a side-view arena while waves of enemies
pour in from the right. Heroes auto-attack with whatever weapons you
have equipped, and you tap each hero's portrait to fire their
signature ultimate when the gauge fills.

After each wave, three skill cards appear. Each card is tagged to a
specific hero and modifies one of their abilities, weapons, or runes
— splits a storm cyclone into three, or chains your hellfire to the
next enemy. You pick one. Pick the same card three times across
waves and it auto-upgrades to a rare tier.

Bosses fight every five waves. The final boss at wave fifteen ends
the stage. About five minutes a run.
```

### 19.2 Core loop + meta progression (170 words)

```
You command a squad of three heroes who hold positions in an arena
while enemies pour in. Heroes auto-attack with the weapons you've
equipped to them, and you tap each hero's portrait to fire their
signature ultimate when the gauge fills.

After each wave, three skill cards appear. Each card is tagged to a
specific hero and modifies one of their abilities, weapons, or runes
— splits a storm cyclone into three, or chains your hellfire to the
next enemy. You pick one. Pick the same card three times across
waves and it auto-upgrades to a rare tier.

Bosses fight every five waves. The final boss at wave fifteen ends
the stage. About five minutes a run.

Outside matches, you collect weapons. New weapons come from the
Forge Wheel — a slot-machine forge where you pull whole named
weapons. Each hero is locked, but the weapons they wield change
every time you forge something new. Mid-game, a Master Smith arrives
and the forge expands: now you can also pull parts to upgrade your
favorite weapons toward higher rarities.
```

### 19.3 Store-page variant (55 words)

```
Forge legendary weapons. Bond with seven anime-styled heroes who
each play differently. Tap to fire ultimates, draft skill cards
between waves, and combine elements into named Catalyst compounds
across your squad. The Forge Wheel unlocks deeper crafting as you
progress. Five-minute runs. Fifteen waves. Free to play.
```

### 19.4 First 1-5 minutes the player experiences (280 words)

```
Boot-up: studio logo, then a five-second cinematic — Bran the
warrior raises his anime-styled sword at the camera in a dim
chamber. Text fades: "Hold the line." Tap to start.

Tutorial wave 1 starts immediately, no menus. Bran stands in the
center-left position of a side-view arena. A handful of slimes
waddle in from the right. A tooltip arrow points at Bran's portrait
at the bottom. Heroes auto-attack — Bran swings his sword on a
steady cadence. Damage numbers pop, the slimes burst into cyan XP
gems. Wave clears in eight seconds.

A draft modal slides up over the bottom half of the screen. Three
cards visible: "Bran: +20% atk speed," "Bran: +200% HP," "Bran:
Storm Cyclone splits into 3." A tooltip highlights the third.
Player taps it. Bran's next sword swing visibly conjures three
cyclones instead of one — a "Whoa" beat.

Wave 2: Elara the mage appears in the back position. The arrow
tutorial dismisses. Same draft pattern after wave 2. Wave 3: a
third hero slot becomes active — Vex the rogue. Now three heroes
draft cards each wave.

By wave five the Slime King appears. Its boss banner slides in, the
squad uses ultimates, and the player wins at half HP. The reward
screen drops gold, a weapon shard, and a "Forge Wheel pull
available!" notification.

The player taps the Forge Wheel. A slot-machine reel spins down,
crescendo audio, lands on "Stormblaze Katana — Warrior —
Fire-imbued." Bran's portrait reacts with a stoic smile. The first
weapon collection drops into the roster screen. Free 1-pull
animation plays. The player taps "Continue" — Stage 2 begins.
```

### 19.5 D1-D14 player journey (340 words)

```
Day 1. The player finishes their first session having played three
runs, cleared Stage 1's boss the Slime King, and pulled their
starter weapon collection from the FTUE 10-pull on the Forge Wheel.
They've collected three weapons across the gacha (one biased to each
of their three starter heroes) and seen the first ability-card
transformation — Bran's Storm Cyclone splitting into three. The
hook for returning tomorrow is the visible empty roster grid: Bran,
Elara, Vex shown, plus four shadow slots ahead.

Day 2. The player returns to Stage 2. Wave 14 plays out brilliantly
but they hit a hardcoded narrative defeat — and the Hot Paladin
descends in a cinematic, joining the squad live. She introduces
herself, storm-blue blade in hand. The player retries Stage 2 with
four heroes and wins. By end of session, Bran's Mastery is at
lvl 25, unlocking his first dialogue tier AND Bran's first
personal-mission quest.

Day 3. The first daily challenge unlocks — boss rush. The day's
boss is weak to Fire; the player has Storm Katana (Fire-imbued) on
Bran. Big win, big reward, "I felt smart" moment. Bran's Mastery
ticks higher; the first per-hero passive ("Bran's Resolve +3% atk
while Bran deployed") activates at Affinity 50.

Day 7. Mid-Stage 8. Player has five heroes collected. The Forge
Wheel still operates in Phase 0 (whole-weapon pulls). First
Catalyst compound — Firestorm Catalyst — triggers with Bran (Fire)
+ Elara (Ice) in the squad. The visible squad-wide steam VFX is
the "I want this every match" moment.

Day 14. Mid-Stage 12. The Master Smith cinematic plays at Stage 10
first-clear; the Forge Wheel splits — now showing both Weapon Pull
and Part Pull buttons. Player pulls their first Common part for
half-price gems, applies it to their Common Warrior weapon, sees
the tier-progress meter fill to 50% toward Rare. Player now has
six pre-Hot-Assassin heroes. Bran's mission is at Q3/Q10 — Q4
unlocks via live-ops next month. Weekly leaderboard chase begins.
```

---

## 20. Pre-Mortem (7 Failure Modes + Mitigations)

[V2 mitigations baked into the design above; this section documents the reasoning]

### FM-1 — Inversion fails (weapon-pull splash less emotional than hero-pull)
- **Mitigation:** Hero mission depth amplified to 10-quest chains, Affinity-gated unlock cadence, signature weapon drops at Q10. Player invests in hero-bond hours before signature gacha luck.
- **Verification:** Stage-1 SSR bundle "Pulling weapons feels as exciting as pulling heroes."

### FM-2 — Forge Draft too thin → mid-stage boredom
- **Mitigation:** Boss Bonus Draft at W5/W10/W15 (5 cards instead of 3, pick 1) creates dramatic-density choice moments. Visible ability transformation (storm splits, hellfire chains) replaces flat-stat cards.
- **Verification:** Phase-1 playtest dwell-time per wave; tester verbal "felt impactful" rate.

### FM-3 — Tier 3 Bagmaster forge over-complicates D14+ (RESOLVED v2.2)
- **v2.1 mitigation:** Tier 3 = optional toggle ("Enable Advanced Forge"). Default at Stage 20+ stays Tier 2 stat-fit. Casual mass-market protected.
- **v2.2 resolution:** Tier 3 spatial puzzle **dropped entirely** per Research2026-05-28 v2.E.2 (BagMaster Isekai + Backpack Brawl + Backpack Battles iOS ship spatial-bag as entire products; WC Tier-3-as-toggle benchmarks unfavorably). Phase 1 part-pull system at Stage 10 replaces the v2.1 Tier 2/3 progression. FM-3 no longer active.

### FM-4 — Permanent rune lock → element diversity dies
- **Mitigation:** Re-forge cost 50 shards (down from 100), halves to 25 post-Stage-10, free token at Affinity 25. Master Smith cinematic delivers the cost-reduction narrative.
- **Verification:** % of weapons re-forged per F2P account in D30; diversity index of Catalyst compounds active.

### FM-5 — 5 elements too cognitive for casual mobile
- **Mitigation:** Earth element gates at Stage 10 unlock. Launch with 4 elements (Wittle parity); Earth introduced mid-game.
- **Verification:** FTUE-Stage-5 element-pair recognition rate in playtest.

### FM-6 — Capped outfit hook leaves whale revenue on table
- **Mitigation:** Outfit cap +20% stays. Add uncapped Prestige Skins (cosmetic-only, signature recipe VFX variant per skin). Whale extraction via cosmetic-status, not stat-predation.
- **Verification:** ARPPU comparison vs Wittle in soft launch; 1★ rating concentration analysis.

### FM-7 — Stage 2 hardcoded defeat reads as "rigged"
- **Mitigation:** Defeat moved to wave 14 (NOT boss wave). Cinematic dialogue empowers ("I saw your blades work hard"). Frame as narrative reveal, not skill failure.
- **Verification:** Tutorial completion rate ≥70%; post-cinematic sentiment survey.

### FM-8 — Emotional anchor conflict: "heroes special + weapons thrilling" dilutes both

**Hypothesis:** Pillar 1 (weapons-as-gacha) and Pillar 2 (hero narrative depth) compete for emotional attention. Honkai/Genshin work because BOTH heroes and weapons are gacha — heroes get story AND collection-pull-thrill. Inverting to "heroes locked + weapons gacha" may dilute both anchors: heroes feel "non-pullable, so not premium" while weapons feel "stat sheets without character."

**Evidence:** Honkai Star Rail community treats characters as primary investment; lightcones as secondary. WeaponCraft inverts this — risk that audience trained on hero-gacha rejects the weapon-gacha-with-locked-heroes shape.

**Pre-mortem scenario:** Stage-1 SSR results show players rate "weapons exciting" 7/10 but "hero attachment" 4/10 (or vice versa). Concept fails the dual-anchor test. Phase 1 prototype ships but D7 retention drops to 9% (no emotional hook).

**Mitigation:**
- Stage-1 SSR test bundle MUST explicitly probe the dual question: *"Do these feelings reinforce each other or compete?"*
- Heavy narrative authoring at v1.0 (10-quest mission chains per hero, dialogue depth, Honkai-tier portrait evolution) reinforces hero anchor without sacrificing weapon-pull drama
- Pull animation EXPLICITLY links the two: Forge Wheel reveals weapon → hero portrait reacts emotionally → "Bran wields the Stormblaze Katana" beat. The pull is FOR the hero, not just OF the weapon
- If SSR Stage-1 fails this probe: pivot to hybrid model (some heroes pullable v1.x) before Phase 2 implementation

**Verification:** SSR Stage-1 dual-anchor probe must score ≥6/10 on both axes simultaneously. Otherwise kill or pivot.

### FM-9 — Hero pool too small for D90+ retention

**Hypothesis:** 7 locked heroes = roster maxed by ~D60. Wittle's $21M/mo is partly fueled by constant "new hero next month" banner cycle (1-2 heroes/month per their cadence). WeaponCraft's parallel = new weapon banner cycle — but weapon novelty likely decays faster than character novelty in mobile gacha context. Long-tail retention engine question.

**Evidence:** Wittle hero banner cadence drives D60+ engagement. Honkai Star Rail same pattern (3-week character banner cycle). Our 7-hero ceiling at D60 creates a content cliff.

**Pre-mortem scenario:** D90 retention drops to 3% as engaged players say "I have everything, nothing new to pull for." Forge Wheel banner cycle of new weapons doesn't fully replace hero novelty.

**Mitigation:**
- Roster expansion plan v1.x: hero #8 at ~D60 (Year 1 month 2), #9 at ~D90 (month 3), #10 at ~D120 (month 4). Cadence = 1 new hero every 6-8 weeks post-launch.
- Each new hero gets its own personal mission chain (~10 quests), Honkai-tier portrait evolution, dialogue suite, signature Mythic weapon. Maintains hero-gacha-novelty hook.
- Year 2: 2 new hero classes (Druid, Ranger or similar) widen weapon pools simultaneously.
- Live-ops: monthly "Hero Spotlight" event with 2x Affinity gain for one rotating hero — keeps existing roster engaging while pipeline ramps.
- Recipe Codex + Forge Rings shards serve as ADDITIVE long-tail (not replacement for hero-novelty).

**Verification:** D90+ retention metric tracked in soft launch. If <8% by D90, accelerate hero #8/#9 release.

### FM-10 — FTUE element bottleneck (strict class-lock + small roster)

**Hypothesis:** Strict class-lock (Q2 D) + 1 Mage at FTUE (Elara) means Elara's element is fixed at FTUE start. If her starter weapon is Ice-runed, ALL Mage damage at FTUE is Ice. Similarly Bran (1 Warrior) + Vex (1 Rogue) — each locked to whatever rune their starter has. Element Affinity/Mastery/Catalyst designs assume element mix is possible, but FTUE through Stage 6 has bottlenecked diversity until 2nd Mage/Rogue unlock at mid-game.

**Evidence:** Roster math + strict-lock design + 3-hero deploy at v1.0.

**Pre-mortem scenario:** FTUE-Stage 5 players say "I can't trigger Catalyst compounds — all my heroes are same element." Element-system tutorial reads as theoretical not practical. D5 retention dips.

**Mitigation:**
- **FTUE 10-pull guaranteed Legendary biased toward Universal-class buffer.** Universal weapons usable by any class (current GDD pattern) — 3-5 of 15 weapons in v1.0 pool are Universal. Player gets at least 1 Universal weapon at FTUE for element flex.
- **Starter weapons (pre-equipped at account creation) come with INTENTIONALLY DIFFERENT element runes.** Bran starts with Fire-Storm Katana, Elara with Ice-Frost Spire, Vex with Wind-Shadow Dagger. Catalyst triggers possible from Wave 1 (Fire+Ice = Firestorm). FTUE Wave 4 tutorial calls out the Catalyst moment.
- v2.2 note: rune-swap mechanic moved out of Forge Wheel (was Tier 1 in v2.1). Element flex now achieved via Phase 1 part-pull system at Stage 10+. Pre-Stage-10 element flex comes from starter weapons + FTUE Universal-buffer pull bias.

**Verification:** FTUE-Stage 5 element-pair recognition rate in playtest survey. ≥80% of testers must identify at least 1 Catalyst compound active.

### FM-11 — Two FTUE cinematics → pacing fatigue

**Hypothesis:** Stage 2 Hot Paladin reveal + Stage 10 Master Smith reveal = 2 mandatory cinematic gates in D1-D7. Mobile audience tolerance for cutscenes is low. Honkai Star Rail community routinely complains about "skip button doesn't work in tutorial" patterns.

**Evidence:** Mobile reviews across genre consistently flag forced cinematics as friction. Top Wittle 1★ reviews mention "too much story before I can play."

**Pre-mortem scenario:** Tutorial completion rate drops below 70%. Testers report "wanted to skip but couldn't." Negative D1 sentiment.

**Mitigation:**
- **Both cinematics support skip-after-first-view.** First playthrough must play; subsequent restarts get a skip button at frame 1.
- **Hard cap on cinematic length:** Stage 2 ≤15s, Stage 10 ≤20s. Audio-only first 3s (no full visual) for ad-frame-tolerance.
- **Settings toggle: "Replay cinematic on re-entry"** off by default. Power-users opt-in if they want to re-experience.
- Stage 2 cinematic specifically: keep dialogue tight (3-4 lines max), favor visual splash + minimal text.

**Verification:** Tutorial completion rate ≥75% in playtest. Time-to-Stage-3-start ≤8 min on cold start.

### FM-12 — Hero Affinity → Personal Mission pacing creates D60+ cliff

**Hypothesis:** Hero Affinity 100 unlocks Q10 (signature weapon) of the personal mission chain. Affinity fills ~1 point per stage-clear with hero deployed. If player deploys hero in 3/15 stages per session, ~3 Affinity per session. Affinity 100 = ~30 sessions = ~D30 minimum to unlock first signature. If player runs all 7 heroes evenly, slower per-hero gain. By D60+, missions may pace LAGS content unlocks → "I have content but can't access it" cliff.

**Evidence:** Honkai/Genshin character mission completion patterns; player journey research data.

**Pre-mortem scenario:** Engaged player reaches Stage 15-20 content but has only 2-3 signature weapons unlocked. Mission progression feels stuck. Engagement drops on the meta-narrative axis even as combat content available.

**Mitigation:**
- **Live-ops Affinity accelerators:** Monthly "Hero Spotlight" events grant 2x Affinity gain for one rotating hero. Player picks which hero to push.
- **Daily login bonus Affinity tokens** (5-10 per day, player-allocated to chosen hero).
- **Mission pacing tuned to D14/D30/D60 unlock targets:** Q1-Q3 at Affinity 25 (D14 reachable), Q4-Q6 at 50 (D30), Q7-Q9 at 75 (D45), Q10 at 100 (D60). Content cliff prevention.
- Hero #4 (Hot Paladin) Affinity gain biased high at intro to make her feel "new and engaging."

**Verification:** D60 average Affinity per hero per cohort tracked in telemetry. If average <60 by D60, accelerate event cadence or reduce mission Affinity gates.

### FM-13 — Skin-dialogue authoring quality bar

**Hypothesis:** Skin → Dialogue feature requires ~15 LLM-generated lines per skin × 10 skins per hero × 7 heroes = 1050 dialogue lines minimum. Each line needs voice consistency with hero personality + lore alignment + tone variation. LLM raw output without human review = quality drift. Bad lines slipping into player-facing surface = brand damage (reviews flag "this dialogue feels generic / weird / off-character").

**Evidence:** Honkai/Genshin polish standard requires multiple writer-review passes. AI-generated character dialogue has produced "uncanny valley" reactions in shipped products (e.g., AI Dungeon, some Honkai event minor characters).

**Pre-mortem scenario:** v1.0 ships with patchy dialogue. Reviews mention "dialogue feels AI-generated." 1★ rating concentration on dialogue quality. Skin-dialogue feature becomes a liability instead of a moat.

**Mitigation:**
- **Human-review QA pipeline per LLM batch.** Narrative QA role budgeted into v1.0 production. ~1 lead writer + 1 reviewer = ~$5-8k/month ongoing.
- **Lean launch dialogue scope:** v1.0 ships with 3-5 skins per hero (not 10). Scale to 10/hero over v1.x via banner cadence. Reduces v1.0 line count from 1050 → ~315.
- **LLM prompt templates per hero** establish voice/tone guardrails. Each batch validated against hero personality bible before deployment.
- **Player feedback loop:** in-game "Report dialogue" button on each line allows community-flagging of off-character lines. Reviewer pipeline addresses flagged lines within 2 weeks.

**Verification:** Dialogue quality reviewed at <2% reported-as-bad rate from in-game reports. Steam/Play-store review sentiment specifically on dialogue >70% positive.

### FM-14 — ReforgeRetryModal kills boss combat tension

**Hypothesis:** Stage D shipped a "Reforge & Retry" pattern on boss wipe — keep skill stacks + re-equip + retry the boss wave at no cost. Risk-free retry trivializes boss combat. Players know they can fail safely. Combat tension drops. Wittle has no retry — bosses are real loss states; stage restart is the only path.

**Evidence:** Difficulty design literature (Cuphead, Dark Souls etc) — retry friction is what makes boss victory feel earned. Easy retries = inconsequential combat.

**Pre-mortem scenario:** Playtest feedback: "Bosses don't feel scary." Combat reviews note "no stakes." D14+ engagement drops because boss-clear dopamine wanes.

**Mitigation:**
- **Boss retry COSTS 1 stamina** (or 1 retry token from a daily-rationed pool). Resets the cost-of-failure principle.
- **Implementation cost:** small patch to Stage D ReforgeRetryModal — add stamina deduction before retry button enables.
- **Alternative tested in playtest:** 3 retries per stage maximum, then forced stage restart. Bosses still beatable, but with finite mistakes.
- Boss-wipe failure feels meaningful again; combat tension preserved.

**Verification:** Boss-win sentiment survey (≥70% "felt earned"). Combat tension metric: time-to-boss-victory-celebration vs control group.

### FM-15 — Recipe Codex +25% cap snowballs whales vs F2P

**Hypothesis:** Whales pull more weapons → trigger more Recipes/Catalyst compounds → fill Codex faster → reach +25% account-wide bonus earlier. F2P plateaus at lower Codex % for months. Gap grows.

**Evidence:** Codex discovery is correlated with weapon pool variety. More weapons = more recipe combinations possible.

**Pre-mortem scenario:** F2P at +10% Codex bonus when whales at +25%. Gap = +15% damage = significant balance edge. F2P player perception of "pay to win" grows. Top-thumb 1★ reviews mention "whales steamroll content."

**Mitigation:**
- **Codex discovery weighted to STAGE FIRST-CLEAR, not pull-driven.** Each stage clear guarantees 1 Recipe discovery (regardless of squad composition). F2P parity preserved by stage progression, not weapon pool.
- 50 stages × 1 Recipe = full 50-Recipe Codex achievable by clearing all stages. F2P player who progresses naturally hits +25% cap.
- Pull-driven recipe discovery is OPTIONAL (whales accelerate path but cap is same).
- Implementation: Codex Recipe assignment table (Recipe N → unlocks on Stage M first-clear, deterministic).

**Verification:** Codex completion % at D60 should be ≤10% gap between F2P and whale cohorts. If gap >15%, re-weight discovery toward stage-clear.

---

## 21. Phase 1 Prototype Exit Gates + Kill Criteria

[RICOCHET §16 pattern adapted]

### Hard scope cap for Phase 1 prototype (v2.2 updated)

- 3 starter heroes (Bran, Elara, Vex) + Stage 2 Hot Paladin cinematic functional
- 15 weapons + 7 hero signatures (or stubs for v1.0 author pass)
- **3 quests × 3 starter heroes = 9 launch quests** (full 21-quest set authored as remaining 4 heroes unlock; Q4-Q10 live-ops post-launch)
- 1 chapter map, 5 stages (Stage 1 = FTUE, Stage 2 = cinematic, Stages 3-5 = depth)
- **Forge Wheel Phase 0 only at v1.0 Phase-1-prototype** (Phase 1 part-pull unlocks at Stage 10, post-prototype scope; prototype tests pure weapon-pull at FTUE-Stage 5)
- 4 elements at FTUE (Fire/Ice/Electric/Wind; Earth deferred to mid-game stages 6+)
- All 4 card types in Forge Draft, Boss Bonus Draft on W5/W10/W15
- Hero Mastery + Affinity gauges functional; **portrait evolution tier system locked post-Bran-test-render (5 or 3 tier per FM-19 test outcome)**
- ReforgeRetryModal on boss wipe (with stamina-cost retry per FM-14)
- NO Phase 1 part-pull at prototype, NO Tier 2/3 forge (dropped in v2.2), NO daily challenge modes, NO Prestige Skins, NO acct-wide outfit stat, NO skin-dialogue (all deferred to v1.x or dropped)

### Exit gates (any 2 of 3 must clear) — UPDATED for v2.2 dual-anchor probe

1. **50-player cold-start playtest:** D1 ≥ 35%, D3 ≥ 18%, 7+/10 control satisfaction on the locked Forge Draft pattern. **Plus mandatory FM-8 dual-anchor probe: ≥6/10 on BOTH "weapon excitement" AND "hero attachment" axes.** Plus FM-8 comprehension probe ("Why are heroes locked?"): ≥70% emotional-read answers.
2. **$500 paid ad creative test:** at least 1 ad creative beats Wittle Defender CPI benchmark by ≥ 20% in same audience. **Creatives lead with hero portrait evolution + Catalyst compound reveal moments** (Wittle ad creatives don't show character story — this is the wedge per Research2026-05-28 R6).
3. **10+ hours self-play retention** from Lila internal team — does the weapon-collection inversion + Forge Draft genuinely scratch the Wittle itch?

### Pre-flight tests (run BEFORE Phase 1 implementation)

- **Bran 5-tier portrait nano-banana test render** (FM-19) — must score ≥14/20 Honkai-player approval to ship 5-tier; otherwise downgrade to 3-tier
- **USPTO/EUIPO trademark check on "Catalyst"** (FM-17) — must clear before any external asset; fallback Alloy / Confluence / Reaction / Harmonic

### Kill criteria (any 1 of 5 triggers)

- D1 < 30%
- Control / draft satisfaction < 6/10
- No ad creative within 30% of Wittle CPI
- **FM-8 SSR dual-anchor probe scores <6/10 on either axis simultaneously** (concept failure — pivot to hybrid model with some heroes pullable)
- Engineering cost per Phase 1 part-pull system > 4 sprints (signals architectural drift)

---

## 22. Open Questions (deferred to next brainstorm + research debt from Research2026-05-28)

### Design brainstorm queue

| # | Question | Notes |
|---|---|---|
| Q-reroll | Reroll cost for in-stage Forge Draft | Wittle-style 2g vs rewarded-ad vs increasing-cost — user pending |
| Q11 | Daily challenge modes (Wittle parallels) | Boss Rush rec; user pending |
| Q-rune-source-detail | If runes come from gacha pool alongside weapons, what's the split economy? | Direction agreed: yes shared pool with biased rate |
| Q-armor | Armor gacha (Wittle parallel via Q-armor at v1.2)? | Deferred |
| Q-PvP | Async PvP arena (Year 2)? | Deferred |
| Q-guilds | Guild system (Year 2)? | Deferred |
| Q-stage10-cinematic-detail | Master Smith script + visual specifics | Draft + iterate |
| Q-second-rogue-second-mage-identity | Heroes 5/6 personality + class identity | Authoring task v1.x |
| Q-phase1-pull-target | Phase 1 — does player select target weapon BEFORE or AFTER seeing part rarity? | Default: AFTER (pull-then-choose, optimizes part application) — verify in playtest |
| Q-part-pool-share | Is Part Pull pool separate from Weapon Pull pool, or shared with biased rates? | Tentative: separate banner button, separate pool tunings, 150g vs 300g costs differentiate |

### Research debt from Research2026-05-28 (Q1-Q10)

| # | Question | Next step |
|---|---|---|
| Q1 | What's Wittle Defender's actual D7 / D30 retention curve? | Sensor Tower `retention_metrics` call |
| Q2 | What's Wittle's ARPPU vs Archero 2? | Sensor Tower `download_revenue_estimates` ÷ paying-user-share |
| Q3 | What's the top-grossing iOS RPG category leader (rank #1)? | 1 `unified_apps` call |
| Q4 | What's NTE's actual D1 / D7 retention? Real anime-cohort threat or churn-heavy? | Sensor Tower `retention_metrics` |
| Q5 | Which apps appear in top-10 overlap of Survivor.io, AFK Journey, BagMaster Isekai? | 3 more `app_overlap` calls |
| Q6 | **Is "Catalyst" trademarked?** | USPTO + EUIPO check before external asset |
| Q7 | What's the actual nano-banana cost for Honkai-tier portrait vs 3-tier? Bran test render | Run R2 test |
| Q8 | Does App Store policy actually restrict skin-gated dialogue? | Legal review before v1.x re-evaluation |
| Q9 | Cohort retention curves on the 3 kill candidates — what does Stage-1 SSR actually show? | Build SSR test instrument (R3, R5) |
| Q10 | Are there obscure F2P mobile RPGs we missed that DID try story-locked roster? | Targeted Reddit / TouchArcade / journalist outreach |

---

## 23. Implementation Handoff Plan

### Immediate next steps (post-design-approval)

1. **Stage D ff-merge** `weaponcraft-godot/boss-retry-15-waves` → `main` + delete remote feature branch. Verify 144/144 tests green on main.
2. **Worktree cleanup** — remove `charming-hugle-a501f6` + older orphan worktrees per CLAUDE.md naming policy.
3. **Branch rename** for new design-impl work — propose `weaponcraft-godot/wittle-inversion-phase1` per CLAUDE.md branch naming convention.

### Phase 1 implementation order (proposed sequencing)

| Phase | Scope | Estimated effort |
|---|---|---|
| **P1a — Data schema migration** | New `weapon_data.gd` unitary schema; drop sockets from `Weapon.gd`; preserve hero_data + recipe_data; add `skill_card_data.gd` | 2 sprints |
| **P1b — Forge Wheel Phase 0** | Slot-machine reel UI + Weapon Pull modal + reveal animation + roster persistence | 3 sprints |
| **P1c — Forge Draft modal** | Post-wave 3-card draft modal + Boss Bonus 5-card variant + tier-stacking auto-merge | 3 sprints |
| **P1d — Hero Mastery + Affinity dual track** | Per-hero gauges + Honkai-tier portrait evolution data + milestone unlocks | 2 sprints |
| **P1e — Element Affinity / Mastery / Catalyst** | Pre-stage equip resolution + buff math + UI preview | 2 sprints |
| **P1f — Hot Paladin Stage 2 cinematic + 4-hero combat** | Wave-14 defeat trigger + cinematic + 4-hero deploy | 2 sprints |
| **P1g — Hero personal mission framework (Q1-Q3 only, scope-reduced per R4)** | Mission scaffolding + Bran/Elara/Vex Q1-Q3 authored (9 quests at launch, not 21) | 1.5 sprints (down from 3 in v2.1) |
| **P1h — Skin shop UI (DIALOGUE DEFERRED per v2.2)** | Skin shop UI + Hero-Mastery-gated dialogue (no purchase-gate). Skin-dialogue link deferred to v1.x post-SSR-test | 1 sprint (down from 2) |
| **P1i — Combat balance pass + tuning** | Stat curves, F2P viability ★1-baseline lock, whale-vs-F2P gap < 2× | 2 sprints |
| **P1j — SSR submission prep + playtest scripts** | Internal playtest tooling, 50-player cohort recruit, ad creative draft, **FM-8 dual-anchor probe instruments** | 2 sprints |
| **P1k — Pre-mortem mitigation patches** (FM-8 through FM-19) | Boss-retry stamina cost (FM-14), Codex stage-first-clear weighting (FM-15), starter-weapon element diversity (FM-10), cinematic skip-after-first-view (FM-11), Universal-buffer FTUE pull bias (FM-10), FTUE Forge-Wheel-not-casino framing (FM-16) | 2 sprints (up from 1.75) |
| **P1l — Discord pre-launch infrastructure (NEW v2.2)** | Build Discord server pre-launch. Seed with art/lore drips, hero portrait reveals, community-moderator role. Per R8 in Research2026-05-28 (Wittle's audience is 54% Discord-active). | 0.5 sprint + ongoing community-mgmt cost |
| **P1-pre — Bran 5-tier portrait test render (PRE-P1d gate)** | Nano-banana cheap-tier 5-tier render of Bran; show to 20 Honkai-player testers; lock 5-tier OR fallback 3-tier before P1d kicks off | 0.25 sprint + ~$0.60 art |

**Estimated Phase-1 total: ~24.5 sprints (~6.1 months at 4 sprints/month).** Slight reduction vs v2.1's 25 sprints due to skin-dialogue deferral + quest scope reduction, offset by added P1l Discord + P1-pre test.

Phase 2 (daily challenge modes, Prestige Skins evaluation, hero #4-#7 mission chain authoring, full 10-quest authoring per hero) follows soft launch + metric validation. **NOTE v2.2:** Phase 2 NO LONGER includes "Forge Rings detailed design / Tier 2/3 forge implementation" — both dropped from spec.

---

## 24. Risk Register

| Risk | Mitigation | Owner |
|---|---|---|
| Habby (Wittle dev) copies the weapon-gacha inversion in their season-3 patch | Build hero-narrative moat hard in v1.0; bond players with characters before pattern can be copied | Lila product |
| Forge Draft 3-card model doesn't deliver Wittle dopamine despite Boss Bonus mitigation | Pivot to Wittle 5-hero-deploy + per-hero 3-card draft (15 cards/wave) in v1.x if D7 retention <12% | Engineering |
| Hero authoring cost balloons (10-quest chains × 7 heroes) | Use LLM-assisted writing pipeline; ship 3 heroes with full chains at v1.0 launch, rest at v1.1 | Narrative |
| Battle balance favors specific hero classes early → meta calcification | Combat math stub explicitly tracks per-class win rate at each stage; balance pass between Phase 1c and 1i | Engineering |
| Mobile device battery / performance during 15-wave stages with 4-hero combat + VFX | Cap simultaneous Catalyst VFX at 3; LOD on chibi sprites for low-end devices | Engineering |
| F2P-vs-whale gap >2× on combat math | Lock star-up gap to <1.8× max; refuse to ship if balance pass exceeds | Game design |
| **FM-8** Emotional anchor conflict (heroes locked vs weapons gacha) | Stage-1 SSR dual-anchor probe mandatory; pivot to hybrid (some heroes pullable v1.x) if SSR fails | Game design + Product |
| **FM-9** Hero pool too small for D90+ retention | Roster expansion plan v1.x: +1 hero every 6-8 weeks. Hero Spotlight live-ops events | Lila product + Narrative |
| **FM-10** FTUE element bottleneck (class-lock + small roster) | Universal-buffer pull bias + element-diverse starter weapons (Bran Fire / Elara Ice / Vex Wind) | Game design |
| **FM-11** Two FTUE cinematics pacing fatigue | Skip-after-first-view + length cap (S2 ≤15s, S10 ≤20s) + settings toggle | Engineering + Narrative |
| **FM-12** Affinity → Mission pacing D60+ cliff | Hero Spotlight events 2x Affinity + login Affinity tokens; mission gates tuned to D14/D30/D60 | Live-ops + Game design |
| **FM-13** Skin-dialogue authoring quality bar | Lean launch (3-5 skins/hero at v1.0), narrative QA pipeline, in-game flag-bad-line button | Narrative + Product |
| **FM-14** ReforgeRetryModal kills boss tension | Boss retry costs 1 stamina (or daily retry-token pool) | Engineering |
| **FM-15** Recipe Codex +25% snowballs whales | Codex Recipe assignment weighted to STAGE FIRST-CLEAR (deterministic) not pull-driven | Engineering + Game design |
| **FM-16** Slot-machine forge UI reads as predatory gacha | FTUE messaging frames Forge Wheel as "your crafting workshop, not a casino"; tier-progress meter shows progress is deterministic-over-time; Master Smith cinematic introduces part-pull narratively | Engineering + Narrative |
| **FM-17** "Catalyst" trademark collision | USPTO/EUIPO trademark check before any external asset (Q6 in §22); fall-back candidates: Alloy / Confluence / Reaction / Harmonic | Legal + Product |
| **FM-18** Threat: Habby season-patch adds weapon-banner to Wittle | Track quarterly (W1). Ship Phase 1 part-upgrade forge early to differentiate from "weapon gacha" → "craftable weapon gacha" | Lila product |
| **FM-19** 5-tier portrait test fails (production scope mismatch with Honkai brand promise) | Pre-P1d Bran nano-banana test render; downgrade to 3-tier if <14/20 Honkai-player approval | Art direction + Product |
| **W1** Habby patches Wittle Defender with weapon-banner or forge mode | Quarterly patch monitoring (6-18 month horizon). Ship Phase 1 forge early per FM-18 | Lila product |
| **W2** Archero 2 expands Resonance term into multi-character compound system | Quarterly patch monitoring. Catalyst Codex collection layer (post-rename) is IP-hard differentiator | Lila product |
| **W3** Habby ships hero-squad survivor with story chapters | Watch Habby roadmap/announcements quarterly | Lila product |
| **W4** Last War / Whiteout UA spend on Crunchyroll / Discord / PSN inventory | Monthly UA platform monitoring; pre-empt with own Crunchyroll + Discord placement budget | UA team |
| **W5** NTE / Genshin / Honkai / Wuthering Waves seasonal events steal audience attention | Quarterly anime-RPG event-calendar tracking; time WC content drops around miHoYo/Kuro major patches | Live-ops + Marketing |
| **W6** BagMaster Isekai / Backpack Brawl / Backpack Battles iOS feature pickup | Quarterly storefront ranking check; informs whether Tier 3 spatial design ever revisits | Game design |
| **W7** Sensor Tower app_overlap on Wittle Defender every 90 days | Quarterly data pull; watch new entries + Archero 2 share trend | Lila product + Data |

---

## 25. References

- `docs/research/2026-05-28-competitor-landscape-synthesis.md` — **v2.2 PRIMARY input** — competitor landscape synthesis (1197 lines, 50-game research set, 170 Sensor Tower API calls; drives v2.2 deltas: Catalyst rename, 2-Phase Forge Wheel, audience profile sharpening, threat ranking, R-tier action items, FM-16 through FM-19) [REF:Research2026-05-28]
- `docs/research/reference-games/Wittle Defender/wittle-defender-design-spec.md` — primary anchor
- `docs/research/reference-games/Gear Defenders/Gear_Defenders_Design_Spec.md` — gear-mechanic alternative analysis
- `docs/research/reference-games/BALL x PIT/DESIGN_DOC.md` — long-tail content + Encyclopedia retention pattern
- `docs/research/reference-games/Archero 2/Game_Design_Spec.md` — Resonance pattern reference (Archero 2's mechanic; WC renamed to Catalyst per v2.2)
- `docs/research/ricochet/WIP_DESIGN_DOC.md` — Tarun's RICOCHET concept, template-perfect SSR exemplar
- `docs/research/weaponcraft-forge-mockups/` — F1-F4 nano-banana mockups, historic exploration; v2.1 Tier 3 reference (v2.2 dropped, retained as audit trail)
- `docs/research/team-concepts/` — 22 team concept summaries for strategic position context
- `docs/Templates/101 - Template - New Game Concepts*.md` — SSR template + Wittle Defender + Capybara Go worked examples

---

## Changelog

| Version | Date | Notes |
|---|---|---|
| 2.1 | 2026-05-27 | Initial design spec from grill output + 7-mode pre-mortem with V2 mitigations (FM-1 through FM-7) + 8 additional FMs (FM-8 through FM-15) |
| 2.2 | 2026-05-28 | Post-competitor-research integration: (1) Resonance → Catalyst global rename per Habby term-ownership, (2) Tier 0-3 Forge Wheel replaced by 2-Phase model with part-upgrade mechanics, (3) audience profile sharpened to Habby ∩ anime-curious gamer (Sensor Tower data), (4) fragile assumption two-layer reframed (equipment-gacha precedented, story-locked roster unprecedented, combination = moat), (5) launch quest scope 70 → 21, (6) skin-dialogue deferred to v1.x with SSR-test-gated re-evaluation, (7) Honkai-tier portrait 5-tier test-gated with 3-tier fallback, (8) +4 FMs (16-19) and +7 W-tier threats added to risk register, (9) Discord pre-launch strategy added to implementation plan |

---

*End of Phase 1 design spec v2.2. Ready for SSR submission, exit-gate planning, and implementation kickoff. Bran 5-tier portrait test required pre-P1d. USPTO trademark check on "Catalyst" required pre-external-asset.*
