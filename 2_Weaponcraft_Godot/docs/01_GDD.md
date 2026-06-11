# WeaponCraft — Game Design Doc

**Working title:** WeaponCraft
**Working folder:** `Game_Prototypes/2_Weaponcraft_Godot/`
**Target platform:** Vertical mobile (iOS + Android)
**Target audience:** Casual-mobile RPG players (Wittle Defender, AFK Journey, AFK Arena, Hero Wars cohort)

---

## ⚠ SSOT & build reconciliation (read first)

**This document is the single source of truth (SSOT) for `2_Weaponcraft_Godot`.** The shipped Godot build in [`Prototype/godot/`](../Prototype/godot/) is **authoritative for all current-state facts** — where this doc's prose and the build disagree, **the build wins**. Design intent not yet in the build is tagged **[ROADMAP]**.

Folder rules live in [`../CLAUDE.md`](../CLAUDE.md). Historical / superseded material — the abandoned "Wittle-inversion" weapon-gacha fork (now its own project, `5_WeaponForge_Honkai_Godot`), plus old handoffs, research, decks, and mockups — lives in [`../_archive/`](../_archive/) and **must not** be used for forward work. Archive is reference-only.

### As-built deltas (build = truth)
- **15 waves per run**, boss waves at **W5 / W10 / W15** (supersedes older "5–6 waves" prose below).
- **3 heroes, scripted unlock**: Bran (start) · Elara (on clearing W3) · Vex (on clearing W6). No hero gacha in build.
- **Weapon = 3 slots**: Head + Hilt + Rune. Built via a **TFT-style gold shop + paid reroll** — no premium pulls.
- **Named effects** emerge from part tag-combos (Steamburst = Fire+Ice, Inferno = Fire+Fire, …) — 8 recipes live.
- **Merge** L1→L5. **Heal potion = 15% max HP**. **Boss Reforge-&-Retry** on wipe.

### [ROADMAP] — designed here, NOT in the build yet
Hero gacha + 15-character roster · multi-stage chapter map · idle/AFK layer · stamina · Star-Up · Build Templates · recipe scrolls · 4th "Modifier" slot · bench-fusion · battle pass / monetization · PvP arena · party synergies. All remain valid design targets — treat as future, not current.

---

## Context

A casual-mobile game concept that fuses two influences:

1. **Robotek** (Hexage, 2011) — turn-based tactical combat with slot-machine-flavored randomness, a "send my unit out to fight" feel, and a node-map campaign.
2. **A weapon-crafting layer** — a randomized parts feed (hilts, runes, blades, upgrades) the player composes into weapons each round.

Initial sketch shows a vertical mobile screen with combat on top, crafting bay below, weapon list on the left, parts strip on the bottom, and a "send the weapon up" arrow connecting the two halves.

The concept settled into a **fantasy 3-character party auto-battler with deep weapon crafting**. Core hook: the "randomized dice roll" is moved out of combat and into crafting, where the player's strategic input lives. Combat auto-resolves on weapon stats with a single-tap ultimate as the drama beat.

---

## High-concept pitch

> "Forge weapons, send heroes. WeaponCraft is a casual-mobile auto-battler where you craft randomized weapons in a TFT-style shop, equip your 3-hero fantasy party, and watch them fight. Discover hundreds of weapon recipes by combining elemental and structural parts. Counter every boss with a new build. Collect heroes, master classes, and forge legends."

---

## Core loop (moment-to-moment)

A single **stage** (~3–4 min, Wittle-style) plays as:

1. **Pre-stage** — player picks 3 heroes from unlocked roster (Warrior / Mage / Rogue / etc.) using **Auto-pick + manual override** UX.
2. **Wave 1**
   - **Forge moment** opens. TFT-style shop displays 5 random parts. Player buys with round currency, drags onto 3 weapon slots (one per hero). Class-affinity parts auto-route to matching hero; universal parts queue for manual placement. Reroll button refreshes shop for currency cost.
   - Player confirms loadout. **Combat** plays out auto, side-view single-lane, party-on-left vs. monsters-on-right (Robotek-style framing).
   - During combat, each hero's **Ultimate gauge** fills from damage dealt. Player taps hero portrait when ready to fire single-use ultimate.
   - Wave clears → reward (currency, occasional parts/shards) → next wave.
3. **Waves 2–5** — same forge → fight beat. Weapons persist across waves and can be upgraded (add parts, swap parts, scrap-and-rebuild).
4. **Wave 5/6 = Boss** — full-kit fight. If beaten, stage clears, banks XP/loot. If lost, **boss-retry** screen opens: rearrange lineup + reforge weapons (parts already collected stay in inventory) + try again. Boss has visible **affinity** (resists fire / weak to pierce / etc.) telegraphing counter-build needed.
5. **Post-stage** — stage rewards drop. Player returns to chapter map. Stamina ticks down.

**Idle / offline layer (AFK Journey pattern):**
- Currency, gold, scrap-parts, hero XP accrue at a slow rate while offline (12hr cap).
- On reopen, player claims "AFK rewards" → instant shop currency for next session.

---

## Locked design decisions

### Combat pacing
Turn-based, Robotek-cadence. Combat pauses between waves. No real-time pressure on crafting.

### Combat agency
Hybrid auto + single-tap ultimate. Combat auto-resolves on weapon stats. Player taps hero portrait to fire that hero's signature ultimate, once per fight. Ultimate is the main player-engagement beat during combat.

### Weapon lifetime + meta progression
Weapons are per-stage (called "per-run" in the casual-mobile sense). Persistent meta lives in:
- Hero roster (unlocked characters, levels, Star-Up tier).
- Recipe codex (discovered combos).
- Part shard collection (legendary part shards).
- Build Templates (saved successful weapon configs).
- Character "weapon mastery" passives (unlocked at character levels).

> Alternatives considered and rejected: disposable per-round, per-run weapon evolving, persistent weapon collection.

### Combat scale
3-character fantasy party vs monster waves, side-view single-lane (Robotek-style). Heroes on left, monsters waddle in from right, auto-attack, health bars. Tap hero portrait to fire ultimate.

**Roster ramp:** Player starts with 1 hero (Warrior). 2nd hero (Mage) unlocks at stage 3–5. 3rd hero (Rogue) unlocks at chapter 1 boss. Subsequent heroes via gacha.

### Parts → weapon assignment
Auto-assign with override. Class-affinity parts auto-route to that class's weapon slot. Universal parts queue for manual drag. Combined with the TFT shop: shop displays 5 parts, player buys, bought parts flow into the auto-route system.

### World / run structure
Chapter map at launch. Live-ops roadmap adds an Endless Tower event mode in Season 2.

Chapter map is the campaign spine. Each chapter has ~10–15 stages culminating in a chapter boss.

> Alternatives considered and rejected: endless tower as main spine, roguelike runs (contradicts boss-retry mechanic).

### Weapon anatomy
3-slot weapons: **Head + Hilt + Rune**. All weapons have 3 part slots. **Late-game unlock**: a 4th "Modifier" slot opens for each hero at character mastery level 20+ (modifier slots host passive triggers: bleed-on-hit, ricochet, life-leech, etc.). Gives a clean late-game depth ramp.

### Parts feed mechanic
TFT-style shop with reroll. Each forge moment: shop displays 5 random parts. Player buys with round currency. Reroll button refreshes shop for currency cost. Unbought parts vanish at confirm. Same shop UX language as character gacha = consistent learning curve.

### Ultimate charge mechanic
Damage-dealt + Charge Rune accelerator + time-cap backstop. Base charge fills from damage dealt (better weapon → faster ult). Optionally accelerated by **Charge Rune** archetype parts (build choice matters). Time-cap backstop ensures ult is ready by fight end at minimum.

### Recipe discovery flow
Hybrid (codex hints + recipe scrolls + tutorial seed), enriched with three Potion-Craft-inspired enhancements:
1. **Many-paths-to-one-effect.** Each named effect (Steamburst, Hemorrhage, Twilight) has 2–4 valid part-combos. Players love finding *their* combo.
2. **Effect-name visible, recipe hidden silhouettes.** Codex shows "??? makes *Steamburst — AoE on hit*" with recipe blanks. Goal-known, path-unknown discovery flavor.
3. **Saved Build Templates.** Player pins favorite weapon configs. Quick-rebuild any run if parts available.

Plus original features:
- Tutorial seeds the first 5–10 recipes.
- Recipe scrolls drop from bosses / quests / premium currency (preemptive recipe reveals).
- Hint silhouettes for undiscovered combos.
- Every craft produces *something* (no wasted attempts).

### Stage structure
**Wittle Defender cadence + AFK Journey idle + Robotek node-map.**
- **5–6 waves per stage**, ~3–4 min per stage. *([AS-BUILT] prototype runs a single **15-wave** run with boss waves at W5/W10/W15; the multi-stage chapter cadence below is [ROADMAP].)*
- **Forge moment between every wave** — TFT shop opens, parts roll, player crafts, confirms, next wave fires.
- **Weapons persist and upgrade across waves** within a stage.
- **Currency banks across waves within stage**, resets between stages.
- **Boss on every 5th stage** (stages 1–4 normal, stage 5 chapter sub-boss; chapter end has a bigger boss).
- **Stamina-gated** — 3 plays free, 4th costs stamina, refills over time.
- **Star Challenge** mode for completed stages (Wittle pattern).
- **AFK idle layer** — currency / gold / scrap / hero XP accrue offline (12hr cap) → claim on reopen.
- **Robotek node-map UI** for chapter view: stage nodes connected on a hand-drawn map, with boss / elite / normal node types visually distinct.

### Monetization
**Hybrid model with five layered hooks:**
- **Gacha (primary pillar)** — character pulls + part shard packs + recipe scroll packs.
- **Battle Pass** — seasonal (~$5–10/season), free + premium track.
- **Rewarded ads** — free pulls / 2× rewards / extra stamina.
- **Light energy** — stamina-gated stage plays, refill packs.
- **Cosmetics** — hero skins, weapon visual effects, ultimate animation skins.
- **IAP bundles** — starter packs, monthly card, holiday events.

### Part schema (combat math foundation)
Every part contributes three layers:
1. **Flat stats** — Iron Edge: +5 ATK. Steel Hilt: +10% crit chance. Fire Rune: +3 fire damage.
2. **Class affinity tag** — Warrior-only / Mage-only / Rogue-only / Universal. Drives auto-routing.
3. **Element / keyword tag** — Fire / Ice / Bleed / Holy / Shadow / Lightning / Pierce / Poison / etc.

**Named effects emerge from tag combinations within a weapon:**
- Fire + Ice = **Steamburst** (AoE on hit)
- Bleed + Crit = **Hemorrhage** (compounded DoT)
- Holy + Shadow = **Twilight Edge** (alternating damage type each swing)
- Poison + Bleed = **Necrosis** (DoT stacks compound)
- Iron + Storm = **Thunderclap Grip** (chain lightning on crit)
- ... ~30 base parts × 4 rarities → ~200+ discoverable combos (Potion Craft-scale codex).

**Effects are also class-tinted.** Mage Steamburst (cone of steam) ≠ Warrior Steamburst (steam-coated strike) ≠ Rogue Steamburst (steam smokebomb). Same name, three flavor variants per class.

### Roster launch shape
- **15 characters at launch.**
- **3 free starter heroes**: Warrior (free at tutorial), Mage (stage 3–5 unlock), Rogue (chapter 1 boss unlock).
- **12 gacha-only heroes**: 4 Rare / 5 Epic / 3 Legendary.
- **Pull rates**: Common 70% / Rare 22% / Epic 7% / Legendary 1%.
- **Pity system**: Epic guaranteed every 30 pulls, Legendary guaranteed every 80 pulls.
- **10-pull discount**: 10× cost 9× single price + 1 guaranteed Rare+.
- **Shard duplicates** drive **Star-Up** (★1 → ★5). Each tier: minor passive perk + ult cosmetic upgrade. Damage scaling is gentle so F2P-at-★1 stays competitive.
- **Banner cadence**: 1–2 new heroes/month post-launch via featured banner.

---

## Locked extras (side-thread decisions)

### Hybrid TFT-pattern for characters
Characters are **roles, not power**. Each class has unique signature ultimate + small kit identity. Stats don't bloat with levels. All numerical depth lives in the crafting layer. This preserves character collection / gacha hooks while keeping crafting as the depth axis.

### Merge mechanics
- **Parts merge (passive, in stash)**: 3× Common → 1× Rare → Epic → Legendary. Auto-stacks silently. Stash sink + dupe solution. Sell merge accelerators for monetization.
- **Character Star-Up via duplicates**: TFT-style. Pulling a dupe gives shards. X shards → next star tier. Standard casual-mobile gacha pattern.

### Boss-retry counter-build (core hook)
Bosses have visible affinities (resists fire, weak to pierce, immune to bleed). First attempt usually fails. Game keeps all unlocks + parts. Player rearranges lineup + reforges weapons + retries. Strong dopamine loop. Pulls from AFK Arena elemental rock-paper-scissors + Slay the Spire boss adaptation.

### Class-specific ultimates
Each class has a unique signature ultimate scaling with crafted weapon stats:
- **Warrior**: Whirlwind (AoE melee burst).
- **Mage**: Meteor (delayed AoE).
- **Rogue**: Shadowstep (teleport + crit strike).
- **Paladin**: Divine Shield (party-heal + invuln).
- **Ranger**: Volley (multi-target ranged barrage).
- **Druid**: Wildform (transform-and-rage).
- **Necromancer**: Soul Drain (life-leech AoE).
- (... 15 total at launch.)

Gacha sells *characters with their unique ultimates* — collection AND power in one pull.

### Bench characters as resource
Benched heroes (not in active 3) can be **"sacrificed" / fused** into an active hero's weapon for stat boost or rerouted Element tag. Solves roster bloat after weeks of pulling.

### Recipe codex by class
Each class has its own recipe tree. Warrior recipes ≠ Mage recipes. Long-term completion meta: "complete all class codexes." Massive content runway, low art cost (data-driven recipes).

### Party synergies (demoted)
Originally proposed as match-the-tags-across-party. Demoted to either:
- **Passive pair bonuses**: a flat buff that just exists when X + Y are in lineup (e.g., Warrior + Paladin → +5% party HP).
- **Late-game opt-in only**: synergies surface after the player unlocks all 3 chars + fills a chunk of the codex.

No cognitive tax in the first 5 hours of play.

---

## Open questions (deferred — not blocking GDD sign-off)

These should be answered during pre-prototype design refinement. Each has a stub spec file in the appropriate subfolder.

1. **Combat resolution math** — exact damage formula (additive vs multiplicative scaling, defense reduction curve). → `02_systems/combat_math.md`
2. **Stamina economics** — how many free plays/day, how much each refill costs, refill rate. → `04_economy/stamina.md`
3. **Battle Pass content scope** — exact reward tiers per season. → `04_economy/battle_pass.md`
4. **Cosmetic taxonomy** — hero skins / weapon glow / ultimate VFX skins / banner frames / etc. → `04_economy/cosmetics.md`
5. **PvP arena format** — async ghost vs sync vs blind-pick. → `02_systems/pvp_arena.md`
6. **Onboarding arc** — first 30 minutes script (tutorial pacing, free pull sequence, BAM-new-character moments). → `02_systems/onboarding.md`
7. **Boss affinity taxonomy** — list of resistances/weaknesses and how telegraphed. → `03_content/boss_affinities.md`
8. **Currency layering** — gold / gems / shards / scrolls / dust — exact economy graph. → `04_economy/currency.md`
9. **Sound + music direction** — needed pre-mockup phase. → `02_systems/audio.md`
10. **Art direction** — cute Wittle-flavor vs grimdark vs stylized fantasy. → `02_systems/art_direction.md`

---

## References used during design

- **Wittle Defender** (Habby, 2024) — stage structure, hero gacha, AFK idle, casual-mobile combat cadence.
- **AFK Journey** (Farlight, 2024) — AFK rewards model, stage scale, season phases.
- **AFK Arena** (Lilith Games, 2019) — affinity-based boss counters, character collection meta.
- **Hero Wars / Empires & Puzzles** (Nexters / Zynga) — battle pass + chapter map + gacha economy.
- **Robotek** (Hexage, 2011) — combat framing, single-lane side-view, node-map campaign metaphor.
- **Teamfight Tactics** (Riot, 2019) — shop mechanic, item-combine philosophy, character-as-role pattern.
- **Potion Craft: Alchemist Simulator** (Niceplay Games, 2021) — discovery codex, many-paths-to-one-effect, recipe-book-as-saved-routes, fog-of-war progression.
- **Brotato / Vampire Survivors** (analyzed as anti-pattern for our locked decisions).
- **Slay the Spire / Hades** (analyzed as variable-node-type alternative, ultimately not picked).
- **Little Alchemy / Doodle God / Infinite Craft** (analyzed for pure-discovery model, ultimately layered into our hybrid).
