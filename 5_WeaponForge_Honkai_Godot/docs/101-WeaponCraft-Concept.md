# WeaponCraft — New Game Concept

**Owner:** Biswajeet (Lila Games)
**Date:** 2026-05-28
**Status:** Concept locked (design spec v2.2). Pre-Phase-1 prototype.
**One-line pitch:** *A casual-mobile hero-collector that inverts the Wittle Defender gacha — you pull weapons, not heroes — wrapped around a locked 7-hero roster with Honkai-style anime personality and story.*

**Companion docs:** design spec `docs/superpowers/specs/2026-05-27-wittle-inversion-design.md` (v2.2) · competitor synthesis `docs/research/2026-05-28-competitor-landscape-synthesis.md` · status `docs/STATUS.md`.

---

## 1. Greenlight checklist

- [x] Filled out Stage 1–6
- [ ] Text write-ups for SSR
  - [x] Full description of core loop (~135 words)
  - [x] Full description of core loop + 1 meta progression (~170 words)
  - [x] Store-page variant (~55 words)
  - [x] First 1–5 minutes the player experiences (~280 words)
  - [x] D1–D14 player journey / progression description (~340 words)
- [ ] Prototype
  - [~] Playable Gameplay (In Blockout — Godot Stage D shipped: 15-wave combat, bosses, retry, 144 tests)
  - [ ] Playable Coreloop with 1 progression layer (Forge Wheel + Forge Draft — P1a-c+f in build)
  - [ ] Integrate AI art assets
- [ ] AI Art Assets
  - [ ] Mockup of gameplay screen
  - [ ] Key art
  - [ ] Key UI frames
  - [ ] App store icon
- [ ] SSR Test Results
- [ ] Internal Playtest and Conviction
- [ ] Fake App Store Tests
- [ ] Publish AI Prototype on store and test D1 + number of games on D0

---

## 2. Identity

| Field | Value |
| :---- | :---- |
| Working title | WeaponCraft |
| Genre / subgenre | Casual-mobile hero-collector / auto-battler / weapon-gacha-with-forge-meta |
| Target audience | Western + SEA mid-core male, mid-20s–30s, who currently plays **Wittle Defender or Archero 2**, watches anime on Crunchyroll, owns a PlayStation/Steam library, lives in Discord. The intersection of **Habby loyalist ∩ anime-curious gamer**. NOT the hypercasual-graduate (Cup Heroes) cohort; NOT the pure-anime-action-RPG (Genshin-only) cohort. |

Audience triangulated from Sensor Tower app-overlap (2026-05-28): Wittle players over-index on Crunchyroll (31%), Discord (54%), PlayStation App (23%), Steam (22%), NTE (22%), Pokémon GO (23%).

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

I command three heroes who hold the line in an arena while monsters pour in — they auto-fight with whatever weapons I've equipped, and I tap each hero to fire their ultimate. The twist is what I *collect*: I don't pull heroes, I pull **weapons**. My seven heroes are locked, each with their own story and personality, but the blades, staves and runes they wield come from a slot-machine forge. Between waves I draft skill cards that visibly transform my abilities — split a storm cyclone into three, chain my hellfire to the next enemy. Five-minute runs. The heroes are mine; the weapons are the world's.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Studio logo → 5s cinematic: Bran the warrior raises his anime-styled sword in a dim chamber. "Hold the line." Tap to start.
- **5–15s:** Tutorial wave 1, no menus. Bran stands center-left in a side-view arena. Slimes waddle in from the right. Heroes auto-attack; damage numbers pop; slimes burst into XP gems. Wave clears in ~8s.
- **15–25s:** Forge Draft modal slides up over the bottom half. Three cards: "Bran +20% atk speed," "Bran +200% HP," "Bran: Storm Cyclone splits into 3." Tooltip highlights the third. Player taps.
- **25–40s:** Wave 2 — Bran's next swing conjures three cyclones instead of one. *Visible cause-and-effect.* Elara the mage drops into the back slot.
- **40–60s:** Wave 3 — Vex the rogue joins. By the wave-5 Slime King boss, the player fires ultimates and wins at half HP. Reward screen: "Forge Wheel pull available!" — **the "I want to forge my own weapon" moment.**

---

## 5. Hypothesis of why this would work

Mid-core mobile players who graduated to Wittle Defender / Archero 2 have a hero-collector loop that works ($21M/mo for Wittle) but two unmet wants the category leaders skip. First, the heroes are **interchangeable art assets with no story** — Wittle's own 5★ reviews never name a character emotionally. Second, the **collection thrill is hero-shaped**, which forces ever-growing gacha rosters and the predatory whale tail reviewers complain about.

WeaponCraft's bet is to **invert the gacha axis**. The equipment-is-gacha + heroes-not-pulled pattern is already proven — Archero shipped it to $263M lifetime in 2019. What is genuinely unprecedented in the F2P-mobile-RPG set (50-game research scan) is **hard-locking the roster to deterministic story progression** and giving each of seven heroes a Honkai-grade personality, mission chain and portrait evolution. The combination is the moat: Habby can bolt a weapon banner onto Wittle in a season patch, but they cannot story-lock heroes without forking their hero-banner LTV model. The shipped reference that validates the audience and the slot-not-hero retention loop is Wittle Defender; the diff is *what you pull* and *whether your heroes have souls*.

---

## 6. Risks

**Single fragile assumption:**

*Wittle's mid-core mobile audience will accept weapons-as-gacha replacing heroes-as-gacha — because the **combination** of equipment-gacha (precedented) + story-locked roster (unprecedented) preserves Wittle's slot-level retention loop while adding hero-narrative depth competitors don't have.*

If players feel their locked heroes are "not premium" OR weapon pulls don't carry the dopamine of a hero pull, both anchors dilute and the game falls back to "Wittle with worse art." Stage-1 SSR bundle dual-anchor probe: *"Pulling weapons feels as exciting as pulling heroes, AND I feel attached to my heroes despite not pulling them"* — must score ≥6/10 on **both** axes simultaneously, or the concept pivots to a hybrid (some heroes pullable). Stage-4 gameplay video re-tests the forge-pull splash. Phase-1 50-player playtest measures D1 parity with Wittle.

---

## 7. Reference games

1. **Wittle Defender** — Habby, 2025, mobile. The audience + meta anchor. We share the arena auto-battle, 3-card between-wave draft, slot-not-hero level pattern, 5-min session, and the 92%-male midcore-TD-RPG cohort. We don't share hero-gacha (we pull weapons), flat no-story heroes (ours have mission chains), or the 8-axis progression sprawl (we cap at 4).
2. **Archero 2** — Habby, 2025, mobile. The inversion precedent + gacha shape. We share equipment-gacha + shard-not-banner heroes + the star-up ladder. We don't share twin-stick solo combat (we're squad-of-3 auto + tap-ult), and we rename their "Resonance" to **Catalyst** (cross-element compounds, not cross-character skill-borrow).
3. **Honkai: Star Rail** — miHoYo, 2023, mobile/PC. The narrative-depth + portrait-evolution aesthetic target. We share per-character story, voiced personality, visible character-growth visuals. We don't share turn-based combat, full hero-gacha, or AAA animation budget (we ship Honkai-*styled* on a lean pipeline).

**Genre mashup formula:** Wittle Defender × Archero's inverted gacha × Honkai's character-soul — anchored by a slot-machine weapon forge.

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- First Forge Wheel 10-pull (FTUE, guaranteed 1 Legendary) — slot-machine reels resolve on "Stormblaze Katana — Warrior — Fire-imbued." Bran's portrait reacts. First weapons enter the roster.
- Run 2–3 with the new weapons equipped — same heroes, visibly stronger.
- Stage 2: at wave 14 a scripted "Iron Lich's Herald" overwhelms the line (narrative defeat, not skill failure). The **Hot Paladin** descends in a cinematic — *"I saw your blades work hard. Let me join."* — and the squad grows to four. Stage 2 retry succeeds. **The session-2 hook.**
- First Forge Draft stacking: pick the same card three times → it auto-upgrades to a rare tier.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | 3 heroes, ~3 weapons, first Forge Draft transform seen, 4 shadow roster slots visible. | "What else can I forge?" + the visibly empty roster grid. |
| D3 | 4–5 heroes (Hot Paladin joined), daily Boss Rush unlocked, first hero personal-mission quest. | Element-weakness boss-of-the-day rewards smart squad/weapon swaps. |
| D7 | 5 heroes, first **Catalyst** compound (Firestorm) triggers with Fire+Ice weapons in squad. | "I want this squad-wide steam effect every match." |
| D14 | 6 heroes, Master Smith cinematic at Stage 10 unlocks Forge Phase 1 (pull parts to upgrade weapon rarity), weekly leaderboard. | Part-pull upgrade chase + leaderboard climb + signature-weapon mission progress. |

Kept vague on purpose — Stage 2 SSR will pressure-test cadence.

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~135 words)

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

#### Full description of core loop + 1 meta progression (Stage 1 required, ~170 words)

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

#### Store-page variant (Stage 1b optional, ~55 words)

```
Forge legendary weapons. Bond with seven anime-styled heroes who
each play differently. Tap to fire ultimates, draft skill cards
between waves, and combine elements into named Catalyst compounds
across your squad. The Forge Wheel unlocks deeper crafting as you
progress. Five-minute runs. Fifteen waves. Free to play.
```

#### First 1–5 minutes the player experiences (~280 words)

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

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

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
lvl 25, unlocking his first dialogue tier AND his first
personal-mission quest.

Day 3. The first daily challenge unlocks — boss rush. The day's
boss is weak to Fire; the player has Storm Katana (Fire-imbued) on
Bran. Big win, big reward, "I felt smart" moment. Bran's per-hero
passive ("Bran's Resolve +3% atk while deployed") activates.

Day 7. Mid-Stage 8. Player has five heroes. The Forge Wheel still
operates in Phase 0 (whole-weapon pulls). First Catalyst compound —
Firestorm — triggers with Bran (Fire) + Elara (Ice) in the squad.
The squad-wide steam VFX is the "I want this every match" moment.

Day 14. Mid-Stage 12. The Master Smith cinematic plays at Stage 10
first-clear; the Forge Wheel splits — now showing both Weapon Pull
and Part Pull buttons. Player pulls a Common part for half-price
gems, applies it to their Common Warrior weapon, and watches the
tier-progress meter fill 50% toward Rare. Six heroes owned; Bran's
mission at Q3; weekly leaderboard chase begins.
```

### 9.2 Synthetic testing materials — Art

Hero-collector with combat emphasis. Required for Stage 3.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Single static frame: side-view arena, 3 heroes in slots, enemies entering from right, HUD (wave counter, 3 hero portraits with ult gauges), Forge Draft modal half-visible. Reads as "squad auto-battler with a forge" in 2s. |
| **Key art** | TBD | Marketing hero shot: the 7-hero roster (3 lit, 4 shadow-silhouette), a slot-machine Forge Wheel mid-spin throwing sparks, an anime-styled Bran foregrounded with the Stormblaze Katana. Pixel-cyber-anime palette. |
| **Key UI frames** | TBD | (1) Combat HUD mid-wave, (2) Forge Draft 3-card modal, (3) Forge Wheel slot-machine pull, (4) Hero roster grid (3 + 4 shadows), (5) Hero detail / Mastery + portrait tiers, (6) Catalyst compound preview, (7) Part-Pull upgrade screen (Phase 1). |
| **App store icon** | TBD | 1024×1024. Single anime-styled hero mid-swing with a glowing forged blade + a hint of slot-machine reels. Tested for thumbnail readability at 88×88. |
| **Bran 5-tier portrait test** | Done | `docs/research/portrait-tier-test/bran_5tier_evolution.png` — Basic→Apotheosis. Pending 20-Honkai-player approval gate (ship 5-tier vs fall to 3-tier). |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | In build | Godot 4.6.2. Stage D shipped: 15-wave combat, bosses W5/W10/W15, ReforgeRetryModal, 144 tests. Phase 1 vertical slice (P1a-c + f) adds Forge Wheel Phase 0 pull + Forge Draft 3-card + Hot Paladin Stage-2 cinematic = the first-10-minute loop. No meta gacha economy at prototype. Must be feel-representative on a real Android device. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Five beats: (1) first 20s onboarding read, (2) first Forge Draft transform (Storm Cyclone splits), (3) first Forge Wheel pull splash, (4) Stage-2 Hot Paladin cinematic, (5) first boss kill. Each scored separately at Stage 4. The Forge-pull + cinematic beats are make-or-break. |

---

## 10. Strategic notes (WeaponCraft-specific)

- **Rename done:** "Resonance" → **Catalyst** (Habby owns "Resonance" via Archero 2 + CapybaraGo). Trademark check pending before any external asset.
- **Progression cap = 4 axes** (weapons / heroes / Recipe Codex / Forge shards). Deliberate guard against Wittle's 8-axis "red-dot hell."
- **Quarterly threat watch:** Habby season-patching a weapon banner onto Wittle (6–18mo); ship the craftable part-pull forge early to stay ahead of plain "weapon gacha."
- **Moat = the combination**, not either half. Marketing wedge: lead ad creative with hero portrait-evolution + story beats — Habby's creatives never show character story.

---

*End of WeaponCraft concept (team `101` template format). Source of truth for full design: `docs/superpowers/specs/2026-05-27-wittle-inversion-design.md` v2.2.*
