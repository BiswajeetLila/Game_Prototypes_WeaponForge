# WeaponForge — Prototype Screen Beats (Storyboard)

> **Beat = one observable screen-state in the prototype.** Each beat below is
> a snapshot of what the player sees + does at that moment, drawn in ASCII so
> the doc travels (paste in Slack, print, hand to a designer).
>
> Status legend per beat:
> - ✅ **shipped** — live on `main` today
> - 🛠 **in-flight** — on `forgeloop/catalyst-element-pairs` (Catalyst build)
> - 📋 **queued** — design locked, code not started
> - 🧪 **proposed** — design draft, not yet locked
>
> Order = chronological player journey, FTUE → S10 → exit gates.
>
> Updated 2026-06-09 (mid-Catalyst session). Authoritative for the prototype
> scope only; post-launch live-ops stuff is in `05_roadmap.md`.

---

## CHAPTER 1 — BOOT

### Beat 1.1 ✅ Cold boot (first time ever)

```
┌────────────────────────────────────┐
│                                    │
│                                    │
│         ⚒ WEAPONFORGE              │
│         (engine splash)            │
│                                    │
│                                    │
│         loading…                   │
│                                    │
└────────────────────────────────────┘
```
- account.json absent → AccountState defaults loaded.
- Heartbeat + breadcrumb files initialise.
- Auto-grant 3 starter Commons to Bran/Elara/Vex (`_grant_starter_if_first_boot`).
- Transitions to Home.

---

### Beat 1.2 ✅ Warm boot (returning player)

```
┌────────────────────────────────────┐
│                                    │
│         ⚒ WEAPONFORGE              │
│         loading saved state…       │
│                                    │
└────────────────────────────────────┘
```
- account.json v4 read. Migration runs if older version.
- Heroes / weapons / shards / ember / stage restored.
- Old-save migration default: ember = 0 (forces a boss-clear before next pull).
- Transitions to Home with saved state.

---

## CHAPTER 2 — HOME / META

### Beat 2.1 ✅ Home — fresh account (post-FTUE grant)

```
┌─ WEAPONFORGE ─────────────────────────────────┐
│            reset account (debug)              │
│  🔥 5 Ember  ·  💎 0 gems  ·  🏰 Stage 1      │
│            🔧 0 Forge Shards                  │
│  ─────────── SQUAD ───────────                │
│  Bran  (Warrior)   ⚒ Emberfang Cleaver · 18   │
│  Elara (Mage)      ⚒ Frostcall Stave · 16     │
│  Vex   (Rogue)     ⚒ Stormpierce Fangs · 17   │
│       Squad elements:  🔥 ❄ ⚡                │
│                                               │
│  ┌─ DETAIL ─────────────────────────────────┐ │
│  │ Tap a weapon to inspect / forge.         │ │
│  │ Tap a weapon then a hero = equip.        │ │
│  └──────────────────────────────────────────┘ │
│  ── ARMORY (tap a weapon, then a hero) ──     │
│  [empty] [empty] [empty]                      │
│  [empty] [empty] [empty]                      │
│                                               │
│  ⚒ FORGE WHEEL — PULL (5🔥)                   │
│       Equal odds · class-matched              │
│                                               │
│  ⚔ START BATTLE — STAGE 1                     │
└───────────────────────────────────────────────┘
```
- 5 Ember = exactly one free pull on day 1.
- All 3 starter weapons equipped, armory empty.

---

### Beat 2.2 🛠 Home — same screen w/ Catalyst built

```
┌─ WEAPONFORGE ─────────────────────────────────┐
│  🔥 5 Ember · 💎 0 · 🏰 Stage 1 · 🔧 0        │
│  ─────────── SQUAD ───────────                │
│  Bran  (Warrior)   ⚒ Emberfang Cleaver · 18   │
│  Elara (Mage)      ⚒ Frostcall Stave · 16     │
│  Vex   (Rogue)     ⚒ Stormpierce Fangs · 17   │
│  Squad elements:  🔥 ❄ ⚡                     │
│  💠 Catalyst: Firestorm  (+20% squad ATK)     │
│       cap-1 active · stages 1-4               │
│  …                                            │
└───────────────────────────────────────────────┘
```
- Catalyst chip surfaces once ≥2 distinct elements + a triggering pair.
- Cap-1 picks alphabetical winner (Firestorm beats Stormfront).
- Tap chip → opens the Catalyst codex sheet (Beat 9.3).

---

### Beat 2.3 ✅ Weapon detail panel (tap a weapon)

```
┌─ DETAIL ──────────────────────────────────────┐
│  Emberfang Cleaver   ★1 Common · 🔥 fire      │
│  ATK 18 · HP 0 · CRIT 5% · ULT 100%           │
│  Ability: Hellfire — burn-stack on hit        │
│  Forge: 🔧 → rarity-up    Star: 💎100 → ★2    │
│  Equipped on Bran                             │
│                                               │
│  [Forge (need 4🔧)] [Star-up (100💎)] [Unequip]│
└───────────────────────────────────────────────┘
```
- Same panel for bench and equipped weapons.
- Forge / Star-up disabled if can't afford.

---

### Beat 2.4 ✅ Forge Wheel — pull animation

```
┌─ FORGE WHEEL ─────────────────────────────────┐
│                                               │
│       ┌────────────────────────┐              │
│       │       ⚒  ⚒  ⚒          │              │
│       │   <spin / blur / dust>  │              │
│       │       ⚒  ⚒  ⚒          │              │
│       └────────────────────────┘              │
│            REVEAL in 3 · 2 · 1…               │
└───────────────────────────────────────────────┘
```
- 📋 Spin cinematic (≤0.6s anvil-strike reel) **NOT YET BUILT** — current build
  reveals instantly. Skippable on tap when built.

---

### Beat 2.5 ✅ Forge Wheel — reveal (new weapon)

```
┌─ PULL RESULT ─────────────────────────────────┐
│         ⚒  YOU FORGED  ⚒                      │
│   ┌───────────────────────────────┐           │
│   │  Venomwhisper Daggers          │           │
│   │  Rogue · ❄ ice · ★1 Common    │           │
│   │  ATK 23                        │           │
│   └───────────────────────────────┘           │
│   ATK 0 → 23  ·  +2 🔧 shards                 │
│   [Equip on Vex]   [Send to bench]            │
└───────────────────────────────────────────────┘
```
- Drops 2 shards on C/R, 0 on E+.
- Reveal card shows class + element + rarity + ATK delta.
- Pulls #1 and #3 are scripted (Fire-Bran, Ice-Elara — only when 🛠).

---

### Beat 2.6 ✅ Forge Wheel — reveal (DUPE)

```
┌─ PULL RESULT ─────────────────────────────────┐
│         ⚒  DUPLICATE!  ⚒                      │
│   ┌───────────────────────────────┐           │
│   │  Emberfang Cleaver (dupe)     │           │
│   │  Warrior · 🔥 fire · ★1 C     │           │
│   └───────────────────────────────┘           │
│   💎 +20 gems                                 │
│   [Continue]                                  │
└───────────────────────────────────────────────┘
```
- Dupe ladder: C 20 / R 40 / E 80 / L 160 gems.
- No more dupe-star (old system retired).

---

### Beat 2.7 ✅ Star-up confirm

```
┌─ STAR-UP ─────────────────────────────────────┐
│   Emberfang Cleaver  ★1 → ★2                  │
│   ATK 18 → 19  (+5% per tier)                 │
│   Cost: 💎 100 (you have 200)                 │
│                                               │
│   [Cancel]                       [Confirm]    │
└───────────────────────────────────────────────┘
```
- Cost scales 100×current tier. Caps at ★10.

---

### Beat 2.8 ✅ Forge — rarity-up confirm

```
┌─ FORGE (irreversible) ────────────────────────┐
│   Emberfang Cleaver  ★1 Common → Rare         │
│   ATK 18 → 26  (+~40% from rarity table)      │
│   Cost: 4 🔧 shards (you have 6)              │
│                                               │
│   ⚠ this consumes the shards forever          │
│   [Cancel]                       [Forge]      │
└───────────────────────────────────────────────┘
```
- Irreversible ConfirmDialog — owner-spec'd guard.

---

## CHAPTER 3 — PRE-STAGE BRIEFING

### Beat 3.1 ✅ Pre-stage briefing — stage 1 (teaching)

```
┌─ STAGE 1 BRIEFING ────────────────────────────┐
│  Boss:  SLIME KING  (weak fire / resist ice)  │
│  Minion affinity:  weak fire / resist ice     │
│  ✅ Squad covers fire weakness (Bran 🔥)      │
│  ⚠ Bringing 🔥 — but you also have ❄ + ⚡    │
│      (free hits + safe damage)                │
│                                               │
│  [Adjust Loadout]            [⚔ ENTER STAGE]  │
└───────────────────────────────────────────────┘
```
- Stage-1 MIRRORS boss affinity (teaching pattern).
- ✅ / ⚠ telegraphs presence of weak-exploit + resist-bring-warning.

---

### Beat 3.2 ✅ Pre-stage briefing — stage 2+ (spread + conflict)

```
┌─ STAGE 2 BRIEFING ────────────────────────────┐
│  Boss:  IRON GOLEM  (weak electric / resist fire)│
│  Minion affinity:  weak ice / resist wind     │
│  ✅ Covers boss weak (Vex ⚡)                 │
│  ✅ Covers minion weak (Elara ❄)             │
│  ⚠ Bran 🔥 is RESISTED by the boss (½ dmg)  │
│                                               │
│  [Adjust Loadout]            [⚔ ENTER STAGE]  │
└───────────────────────────────────────────────┘
```
- Stage ≥2: minion ≠ boss (spread); conflict possible (>1/3 rate).

---

### Beat 3.3 🛠 Pre-stage briefing — w/ Catalyst axis 2

```
┌─ STAGE 5 BRIEFING ────────────────────────────┐
│  Boss:  SLIME KING ★3 scale  (weak fire / resist ice)│
│  Minion affinity:  weak wind / resist fire    │
│  ✅ Bran 🔥 hits boss-weak                    │
│  ⚠ Elara ❄ is RESISTED by boss               │
│                                               │
│  💠 ACTIVE CATALYST                           │
│     ┌──────────────────────────────────────┐ │
│     │ 🔥+❄ Firestorm    +20% squad ATK    │ │
│     │ 🔥+⚡ Plasma       +15% squad crit   │ │
│     │ ❄+⚡ Glacial Storm +15% squad ATK    │ │
│     │ (no-cap — stage 5+)                  │ │
│     └──────────────────────────────────────┘ │
│  [Adjust Loadout]            [⚔ ENTER STAGE]  │
└───────────────────────────────────────────────┘
```
- Stage 5+ → no-cap stacking, 3-different squad shows 3 compounds.
- Tap any compound → mini codex card (Beat 9.3).

---

## CHAPTER 4 — COMBAT (STAGE LOOP)

### Beat 4.1 ✅ Stage-start banner

```
┌────────────────────────────────────┐
│                                    │
│        🏰 STAGE 1                 │
│        (fades in 1.2s)             │
│                                    │
└────────────────────────────────────┘
```
- Notifications layer over the dimmed battle area.

---

### Beat 4.2 🛠 Catalyst-active banner (if any)

```
┌────────────────────────────────────┐
│                                    │
│    💠 FIRESTORM CATALYST ACTIVE   │
│    🔥+❄  +20% squad ATK          │
│    (fades in 1.2s)                 │
│                                    │
└────────────────────────────────────┘
```
- Plays once at stage-start, after the stage banner.
- Persistent chip stays on HUD for the rest of the stage.

---

### Beat 4.3 ✅ Wave 1 mid-fight (3 heroes vs minions)

```
┌─ S1 · WAVE 1/5 ───────────────────────────────┐
│  ┌──────────────────────────────────────────┐│
│  │                                          ││
│  │ ◯Bran                  💀goblin ATK 18  ││
│  │   (idle anim)              22/22 ★fire   ││
│  │ ◯Elara                                   ││
│  │   (cast anim)         💀skeleton ATK 17 ││
│  │ ◯Vex                       22/22 ★ice    ││
│  │   (attack anim)                          ││
│  └──────────────────────────────────────────┘│
│  ── kill meter ───────  3 / 8  ─────────────  │
│  ┌─ Bran ── ◯ ──┐ ┌─ Elara ─◯─┐ ┌─ Vex ──◯─┐ │
│  │ 145/145      │ │ 105/105    │ │ 85/85    │ │
│  │ ⚒ Emberfang  │ │ ⚒ Frostcall│ │ ⚒ Storm- │ │
│  │   Cleaver ATK│ │   Stave  ATK│ │   pierce │ │
│  │   ●○○        │ │   ●○○      │ │ ●○○     │ │
│  │ ─ ult bar ─  │ │ ─ ult bar ─│ │─ ult bar │ │
│  │ [ ULT 18% ]  │ │ [ ULT 22% ]│ │[ULT 14%] │ │
│  └──────────────┘ └────────────┘ └─────────┘ │
└───────────────────────────────────────────────┘
```
- Side-view auto-resolve. Heroes attack on a timer per their data.
- 80% minions match the stage affinity, 20% un-classed (flavor).
- Hit floaters appear above damaged units.

---

### Beat 4.4 ✅ Kill-meter full → PAUSE banner

```
┌────────────────────────────────────┐
│                                    │
│       ⏸ FORGE READY — pick a card  │
│       (combat freezes)             │
│                                    │
└────────────────────────────────────┘
```
- Combat.pause(true). Enemies stop, projectiles freeze mid-air.
- Forge Draft modal opens immediately after (Beat 4.5).

---

### Beat 4.5 ✅ Forge Draft modal — 3 cards (normal waves)

```
┌─ FORGE DRAFT ─────────────────────────────────┐
│   Pick a run-buff for your squad              │
│   ┌──────────┐  ┌──────────┐  ┌──────────┐    │
│   │ STAT     │  │ ABILITY  │  │ ELEMENT  │    │
│   │ +12% ATK │  │ Hellfire │  │ Frost    │    │
│   │ Bran     │  │ +1 burn  │  │ Rune ★1  │    │
│   │          │  │ stack    │  │ Elara    │    │
│   └──────────┘  └──────────┘  └──────────┘    │
│         (tap to pick · cannot reroll)         │
└───────────────────────────────────────────────┘
```
- 4 card types: stat / ability / element / hero-only.
- Stays RNG (strategic layer = pre-stage, NOT this).
- Pick → animation flies card to the target hero's pip row.

---

### Beat 4.6 ✅ Forge Draft modal — 5 cards (BOSS WAVE 5)

```
┌─ FORGE DRAFT  ·  BOSS PREP ───────────────────┐
│   Pick a run-buff — 5 choices for the boss    │
│  [STAT] [STAT] [ABILITY] [ELEMENT] [HERO]     │
│                                               │
│  ⚠  Boss telegraph: Slime King heals at 50%+  │
│      bring burst damage                       │
└───────────────────────────────────────────────┘
```
- 5 cards on the W5 boss wave (per spec, Wittle 1:1).
- Boss telegraph reminds player of the boss mechanic about to land.

---

### Beat 4.7 ✅ Card picked → fly-to-pip animation

```
       ┌──────────┐
       │ STAT     │      ╲
       │ +12% ATK │       ╲╲  fly arc
       │ Bran     │        ╲╲
       └──────────┘         ╲╲
                              ╲╲    ╭─ Bran ──╮
                                ╲╲  │ ●●○     │
                                  ╲ │         │
                                    →●●○      │
                                    └─────────┘
```
- 0.3s Bezier tween from card centre to hero pip row.
- Pip count increments (○○○ → ●○○ → ●●○ → ●●●).
- Combat.pause(false) on land.

---

### Beat 4.8 ✅ ULT button glows yellow

```
┌─ Bran ── ◯ ──┐
│ 145/145      │
│ ⚒ Emberfang  │
│   ●●○        │
│ ─ ult bar ──█│   ← full
│ [ 🌀 Whirlwind ] ← static yellow, big
└──────────────┘
```
- Single-tap. No animation pulse (owner: "yellow only, no pulse").
- Tap → fire_ult(hero_id) → AOE / single-target effect per hero.

---

### Beat 4.9 ✅ Ult firing — AOE flash

```
┌──────────────────────────────────────────┐
│            🌀 WHIRLWIND                   │
│       ◯Bran  spins → all enemies hit     │
│  💀 💀 💀  red numbers float: -63 -63 -63│
│  screen-shake · short freeze-frame       │
└──────────────────────────────────────────┘
```
- HitPause.freeze(0.1s) + ScreenShake.trauma(0.5).
- Per-enemy hit floater.

---

### Beat 4.10 ✅ Hero hit / HP delta trail

```
┌─ Vex ──── ◯ ─────────────┐
│  85/85  →  47/85          │
│  hp-bar:  ████░░░░░░░░    │
│  delta trail (red):  ░░██ ← lags 250ms then catches up
└───────────────────────────┘
```
- ColorRect-based delta bar. Hold 250 ms → catch-up 200 ms (Quart-In).
- Card border red-flash on hit.

---

## CHAPTER 5 — BOSS ENCOUNTERS

### Beat 5.1 ✅ Boss entry banner (W5)

```
┌────────────────────────────────────┐
│   👑 BOSS — SLIME KING 👑         │
│   weak fire · resist ice           │
│   1.5s banner                      │
└────────────────────────────────────┘
```

---

### Beat 5.2 ✅ Slime King — heal tick at HP > 50%

```
┌──────────────────────────────────────┐
│  💀 Slime King   220 → 228  (+8 heal)│
│      green +8 floats above the boss  │
│      hp-bar pulses green             │
└──────────────────────────────────────┘
```
- Every 3 ticks while hp > 50%. Stops below.
- Telegraphed pre-fight in the briefing.

---

### Beat 5.3 ✅ Iron Golem — AoE telegraph then strike

```
T-2s   ⚠ "GOLEM WIND-UP"   (gold border on golem)
T-0s   💥 SLAM — every hero loses 56 HP (total 169 if 3 alive)
       screen-shake heavy · red flash on all hero cards
```

---

### Beat 5.4 ✅ Arcane Lich — phase 2 (<33% HP)

```
┌──────────────────────────────────────────┐
│  🧙 ARCANE LICH — PHASE 2                │
│  banner: "phase shift — AoE 30% added"   │
│  per attack: 43 single + 36 AoE          │
│  visual: lich glows purple + chain VFX   │
└──────────────────────────────────────────┘
```
- Already-tuned: hp 600, AoE 0.30. Hard but fair.

---

## CHAPTER 6 — STAGE END

### Beat 6.1 ✅ Stage clear popup

```
┌─ STAGE CLEARED ───────────────────────────────┐
│      ⚒ STAGE 1 COMPLETE ⚒                     │
│                                               │
│   Rewards:                                    │
│      +2 🔥 Ember (victory bonus)              │
│      +1 🔥 Ember (boss kill)                  │
│      +30 🪙 gold (last-wave)                  │
│      Stage → 2                                │
│      Heroes restored to full HP               │
│                                               │
│            [Continue to Home]                 │
└───────────────────────────────────────────────┘
```
- 0.5s gold-burst confetti.
- Auto-routes to Home after 1.0s + button.

---

### Beat 6.2 ✅ Squad-wipe → loadout screen (NO retry modal)

```
┌─ DEFEAT ──────────────────────────────────────┐
│   Your squad fell.                            │
│   No penalty — adjust your loadout and        │
│   try again.                                  │
│                                               │
│        [Return Home]                          │
└───────────────────────────────────────────────┘
```
- ReforgeRetryModal removed (sidesteps FM-14).
- Returns to Home; stage NOT incremented.

---

### Beat 6.3 ✅ Run-state reset between stages

```
- ForgeDraft.reset_run()
- per-hero run_card_count → 0 (pips reset)
- hero HP restored
- weapon star / forged rarity persist (meta)
```

---

## CHAPTER 7 — HERO UNLOCK CINEMATICS

### Beat 7.1 ✅ Elara unlock (Stage 1, Wave 3)

```
┌─ NEW HERO ────────────────────────────────────┐
│      🟢 ELARA  joins the squad                │
│      "ice mage of the frozen vale"            │
│      (still-frame portrait + 80-word panel)   │
│      [Continue]                               │
└───────────────────────────────────────────────┘
```
- Auto-equipped Elara starter (Frostcall Stave).
- 📋 In Catalyst-build, Elara's starter becomes basic (non-elemental).

---

### Beat 7.2 ✅ Vex unlock (Stage 1, Wave 6)

```
┌─ NEW HERO ────────────────────────────────────┐
│      🟢 VEX  joins the squad                  │
│      "rogue from the shadow corps"            │
│      [Continue]                               │
└───────────────────────────────────────────────┘
```

---

### Beat 7.3 📋 Hot Paladin scripted-defeat entry (Stage 2 mid)

```
┌─ STAGE 2 — WAVE 3 ─────────────────────────────┐
│  squad fights as normal …                      │
│                                                │
│  T = wave-mid trigger:                         │
│  ─────────────────────────────────────────     │
│  ┌──────────────────────────────────────────┐ │
│  │   ☄ FROM ABOVE …  ☄                       │ │
│  │   (lance crashes to centre stage)        │ │
│  │   ⚔ HOT PALADIN  descends                │ │
│  │   "I'll handle the rest. Stand back."    │ │
│  │   (one-line dialogue, voiceover stinger) │ │
│  └──────────────────────────────────────────┘ │
│  PALADIN ult-overrides → wave wipes            │
│                                                │
│  ┌─ ROSTER UNLOCK ─────────────────────────┐   │
│  │  🟢 PALADIN added to your squad pool    │   │
│  │  Starter weapon: Sunblade Lance ★1      │   │
│  │  Retry Stage 2 with 4-hero deploy slot? │   │
│  │  [Yes — replay]    [Continue]           │   │
│  └─────────────────────────────────────────┘   │
└────────────────────────────────────────────────┘
```
- FM-8 hero-bond probe (option A).
- Scripted-once per save. Replays free.
- 4-hero squad slot opens for this stage onward.

---

### Beat 7.4 📋 Stage 10 — Master Smith cinematic

```
┌─ STAGE 10 ────────────────────────────────────┐
│      ⚒ THE MASTER SMITH ⚒                     │
│      old hand reveals the second wheel        │
│      Forge Wheel PHASE 1 unlocked             │
│      Earth runes unlocked                     │
│      Part-pull added (150 💎)                 │
│      5-tier Forge Math live                   │
│      [Continue]                               │
└───────────────────────────────────────────────┘
```

---

## CHAPTER 8 — ELARA SIGNATURE ARC

### Beat 8.1 📋 Elara mission trigger (after crit-killing a boss)

```
┌─ ELARA — A SPARK OF POWER ────────────────────┐
│   still-frame portrait                        │
│   "I felt something. Something… more."        │
│   (200-word panel — narrative beat)           │
│   [Skip]                          [Continue]  │
└───────────────────────────────────────────────┘
```
- Triggered the first run after Elara is in squad AND
  crit-kills the stage boss.
- Quest enters in-progress state.

---

### Beat 8.2 📋 Spark-chain in combat — Elara crit chains

```
T-0   ◯Elara casts Frost Bolt → 💀goblin1 (crit)
T+0.1 ⚡ ⚡ ⚡  arcs jump to goblin2 + goblin3
       red numbers — 11, 11, 11 (chained dmg)
       blue lightning VFX between targets
```
- Per-target chain damage = atk × 0.6 (placeholder).
- Up to N chains per cast (N grows with Meteor talent tier).

---

### Beat 8.3 📋 Small-B talent tree (Elara only, post-trigger)

```
┌─ TALENTS — ELARA ─────────────────────────────┐
│  Mage tree (mini)                             │
│                                               │
│       ┌───────────┐                           │
│       │ Meteor    │  ★ unlocked               │
│       │ AoE atk×3.5│  next: 150 💎            │
│       └────╥──────┘                           │
│            ▼                                  │
│       ┌───────────┐                           │
│       │ Meteor    │  ☆ locked                 │
│       │ Shower    │  → +1 chain, wider AoE    │
│       └────╥──────┘                           │
│            ▼                                  │
│       ┌───────────┐                           │
│       │ Meteor    │  ☆ locked                 │
│       │ Storm     │  → +2 chains, lingers     │
│       └───────────┘                           │
│                                               │
│  Gems available: 💎 320                       │
│  [Unlock next — 150 💎]                       │
└───────────────────────────────────────────────┘
```
- 3-node mini-tree. Gem-spend per node.
- Unlock animation: rune glow + portrait flash.

---

### Beat 8.4 📋 Mission complete cinematic

```
┌─ ELARA — POWER CLAIMED ───────────────────────┐
│   still-frame: Elara surrounded by meteors    │
│   "It's part of me now."                      │
│   200-word resolution panel                   │
│   Meteor unlocked permanently (★3 reachable)  │
│   FM-8 probe data point recorded              │
│   [Continue]                                  │
└───────────────────────────────────────────────┘
```

---

### Beat 8.5 📋 Full-B talent screen (all 3 FTUE heroes, Phase 3)

```
┌─ TALENTS ─────────────────────────────────────┐
│  [BRAN] [ELARA] [VEX]  ← tabs                │
│                                               │
│  BRAN — Warrior tree                          │
│     ┌─ Taunt ─┐ ┌─ AOE Taunt ┐ ┌─ Counter ─┐ │
│     │  ★      │→│   ☆ locked  │→│  ☆ locked  ││
│     └─────────┘ └─────────────┘ └────────────┘│
│  next node: 150 💎                            │
└───────────────────────────────────────────────┘
```
- Same shape for Vex (Poison → Bleed → Execute).
- Each hero's tree mirrors their class fantasy.

---

## CHAPTER 9 — CATALYST REVEAL MOMENT

### Beat 9.1 🛠 First-ever Catalyst trigger (mid-game, scripted-pull #3 lands Ice-Elara)

```
PRE-CONDITION: pull #1 landed Fire weapon on Bran (stage 1).
               pull #3 lands Ice weapon on Elara (~stage 4-5).

┌─ HOME ────────────────────────────────────────┐
│   ⚒ Pull reveal: Frostbite Wand · ❄ ice       │
│   [Equip on Elara]                            │
└───────────────────────────────────────────────┘
                ↓ equip
┌────────────────────────────────────────────────┐
│   📣 CATALYST DISCOVERED                       │
│   ┌─────────────────────────────────────────┐ │
│   │  🔥 + ❄ = FIRESTORM                     │ │
│   │  +20% squad ATK while both equipped     │ │
│   │  added to your Catalyst Codex (1/10)    │ │
│   │  [view codex]            [Continue]     │ │
│   └─────────────────────────────────────────┘ │
└────────────────────────────────────────────────┘
```
- Reveal moment fires ONCE per compound (codex-driven).
- Persistent codex tracker.

---

### Beat 9.2 🛠 Catalyst Codex panel

```
┌─ CATALYST CODEX ──── 3 / 10 discovered ───────┐
│  🔥+❄  Firestorm     +20% squad ATK     ★    │
│  🔥+🌪 Wildfire      +15% atk +10% crit ★    │
│  ❄+🌪 Blizzard       -20% enemy atk spd ★    │
│  🔥+⚡ Plasma        +15% squad crit    ☐    │
│  ❄+⚡ Glacial Storm  +15% squad ATK     ☐    │
│  🌪+⚡ Stormfront    +25% atk vs swarm  ☐    │
│  🔥+🪨 Volcanic      +30% atk -20% spd  🔒 S10│
│  ❄+🪨 Permafrost     root on heavy hit  🔒 S10│
│  🌪+🪨 Sandstorm     -30% enemy acc     🔒 S10│
│  🪨+⚡ Magnetic Storm pull-cluster +50% 🔒 S10│
└───────────────────────────────────────────────┘
```

---

### Beat 9.3 🛠 Catalyst chip — persistent in-battle HUD

```
top-right of battle view:

┌─────────────────┐
│ 💠 🔥+❄         │   ← tap to expand
│   Firestorm     │
└─────────────────┘
```
- Compact icon-pair + name. Tap = quick description overlay.
- Shows ALL active compounds at stage 5+ (no-cap mode).

---

## CHAPTER 10 — PHASE 1 FORGE WHEEL (STAGE 10+)

### Beat 10.1 📋 Forge Wheel Phase 1 — choose weapon-pull vs part-pull

```
┌─ FORGE WHEEL — PHASE 1 ───────────────────────┐
│  Phase 1 unlocks targeted part-pulls.         │
│  ┌──────────────────┐   ┌──────────────────┐  │
│  │ WEAPON PULL      │   │ PART PULL        │  │
│  │ 5 🔥 Ember       │   │ 150 💎 gems      │  │
│  │ random weapon    │   │ pick: head / hilt│  │
│  │                  │   │       / rune     │  │
│  │                  │   │ class-matched    │  │
│  └──────────────────┘   └──────────────────┘  │
└───────────────────────────────────────────────┘
```

---

### Beat 10.2 📋 Part-pull — pick target slot first

```
┌─ PART PULL — choose target ───────────────────┐
│   Which slot do you want to upgrade?          │
│   [ Head ]   [ Hilt ]   [ Rune ]              │
│                                               │
│   Spending 150 💎 — non-refundable.           │
└───────────────────────────────────────────────┘
```

---

### Beat 10.3 📋 Part-pull — reveal + Forge Math diff display

```
┌─ PART RESULT ─────────────────────────────────┐
│   Pyro Visor  ★3 (Epic)                       │
│   slot: HEAD · class: Warrior · rune: 🔥      │
│                                               │
│   Your Bran's current head: Iron Edge ★1 (C)  │
│   Diff: +2 → ½×2 multiplier applied           │
│                                               │
│   [Apply (banks +2 onto Iron Edge)]           │
│   [Keep on bench]                             │
└───────────────────────────────────────────────┘
```
- Forge Math: same-tier +50% / +1 instant / +2 ½×2 / +3 ⅓×3 / +4 banked.

---

## CHAPTER 11 — QUEST LOG

### Beat 11.1 📋 Quest log entry (Home)

```
┌─ QUESTS ──────────────────────────────────────┐
│  Active:                                      │
│   ◌ Elara · Spark of Power      progress 2/3  │
│   ◌ Bran  · First Blood          progress 1/3 │
│   ◌ Vex   · Shadowstep           locked       │
│                                               │
│  Tap a quest to see objectives + rewards.     │
└───────────────────────────────────────────────┘
```
- 21 quests at launch (3 per hero × 7 heroes).

---

### Beat 11.2 📋 Quest complete popup

```
┌─ QUEST COMPLETE ──────────────────────────────┐
│      ✓ Bran — First Blood                     │
│      +500 💎 gems                             │
│      +1 talent point                          │
│      next quest unlocked: "Iron Will"         │
│      [Continue]                               │
└───────────────────────────────────────────────┘
```

---

## CHAPTER 12 — HUMAN GATES (non-code)

### Beat 12.1 📋 Bran 5-tier portrait — external eval (20 Honkai players)

```
external_survey:
  prompt: "Would this 5-tier evolution motivate you to grind stages 1-10
           in a casual-mobile RPG?"
  show: docs/research/portrait-tier-test/bran_5tier_evolution.png
  scoring: 1-10 per respondent
  gate: ≥14/20 give ≥7 → LOCK 5-tier
        else → fall to 3-tier (keep tiers 1 / 3 / 5)
```

---

### Beat 12.2 📋 "Catalyst" trademark check

```
USPTO TESS:   search "catalyst"  Class 41 (games)
EUIPO eSearch: same query
gate:
  no conflict → ship name
  conflict   → rename to Alloy > Confluence > Reaction > Harmonic
              (preference order)
  one-commit rename in code + spec + UI strings
```

---

## CHAPTER 13 — EXIT GATES

### Beat 13.1 📋 10h internal self-play log

```
playtester_log.csv  (rows per session, ≥3 days, ≥10 h aggregate)
  date | playtime_min | stage_reached | "want to come back?"
                                       (yes / no / why)
gate: ≥70% yes ⇒ PASS
```

---

### Beat 13.2 📋 D1 retention panel (5-10 external)

```
panel:
  recruit 5-10 players (Reddit / Discord)
  give: free 1-h session, return ping next day
  measure: did they come back?  D1 = returners / panel_size
  gate: ≥35% ⇒ PASS
```

---

### Beat 13.3 📋 Ad CPI test (optional)

```
$100-200 UA buy on Meta / TikTok
creatives: portrait-evolution moments + Catalyst reveal moments
benchmark: Wittle Defender CPI ~$3.50
gate: ≤$2.80 (≥20% beat) ⇒ PASS
```

---

### Beat 13.4 📋 Exit decision

```
exit_gate_decision:
  passes := count(D1≥35, FM-8≥6/6, adCPI≥20)
  kills  := any(D1<30, sat<6, adCPI<30%-of-Wittle, FM-8<6 either axis)

  if passes ≥ 2 AND kills == 0:
    GREEN → Phase 2 (monetization wiring, quest scale-up, content)
  elif any kill_trigger:
    RED   → /retro, pivot or shelve
  else:
    YELLOW → 5-day iteration on weakest gate, re-eval
```

---

## APPENDIX A — Beat dependency graph

```
[Boot] → [Home] → [Pull] → [Equip] → [Briefing] → [Stage banner]
                                                       ↓
                                          [Wave loop ×4] ↔ [Draft modal]
                                                       ↓
                                          [Boss wave] ↔ [Draft modal 5-card]
                                                       ↓
                                            [Stage clear] OR [Wipe]
                                                       ↓
                                                   [Home]

Cross-cuts:
  [Hero unlock cinematics] fire on stage gates (1.3 / 1.6 / 2.mid / 10)
  [Elara arc] fires once on first crit-kill stage clear w/ Elara
  [Catalyst reveal] fires once per compound (codex tracker)
  [Master Smith] fires once on stage 10 (Phase 1 unlock)
  [Quest popups] fire on quest objective completion
  [Talent tree] reachable from long-press on a hero
```

---

## APPENDIX B — File map (where each beat is built)

| Beat | File(s) |
|---|---|
| 1.1 / 1.2 boot | `scripts/core/account_state.gd` |
| 2.x home | `scripts/ui/home_screen.gd` |
| 2.4 spin cinematic | 📋 not built — will live in `scripts/core/forge_wheel.gd` |
| 2.5/2.6 pull reveal | `scripts/core/forge_wheel.gd` + a popup scene |
| 3.x briefing | `scripts/core/stage_affinity.gd` + briefing panel in home_screen.gd |
| 4.1-4.10 combat | `scripts/core/combat.gd` + `scripts/ui/main.gd` + `scripts/ui/hero_card.gd` |
| 4.5/4.6 draft | `scripts/core/forge_draft.gd` + `scripts/ui/draft_modal.gd` |
| 5.x bosses | `scripts/core/combat.gd` boss-special branches |
| 6.x end | `scripts/ui/main.gd` + `scripts/ui/notifications.gd` |
| 7.x cinematics | 📋 new `scripts/cinematic/*.gd` |
| 8.x Elara arc | 📋 new `scripts/core/quest_state.gd` + cinematic scenes |
| 9.x Catalyst | 🛠 new `scripts/data/catalyst_data.gd` + `catalyst_resolver.gd` |
| 10.x Phase 1 | 📋 new `scripts/core/part_pull.gd` |
| 11.x quests | 📋 new `scripts/core/quest_state.gd` |
| 12/13 gates | non-code (research, legal, playtest) |

---

*End of storyboard. Update beat numbers + 🛠/📋 flags as features land. Pair
with `STATUS.md` (canonical state) + the design specs in
`docs/superpowers/specs/`.*
