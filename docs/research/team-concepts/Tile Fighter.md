# Spellbound — Concept Template v2 (Worked Example)

**Owner:** Concept author  
---

## 1\. Greenlight checklist

- [ ] Filled out Stage 1–6  
- [ ] Text write-ups for SSR  
      - [ ] Full description of core loop (\~135 words)  
      - [ ] Full description of core loop \+ 1 meta progression (\~170 words)  
      - [ ] Store-page variant (\~55 words)  
      - [ ] First 1–5 minutes the player experiences (\~280 words)  
      - [ ] D1–D14 player journey / progression description (\~340 words)  
- [ ] Prototype  
      - [ ] Playable Gameplay (In Blockout)  
      - [ ] Playable Coreloop with 1 Progression layer  
      - [ ] Integrate AI art assets  
- [ ] AI Art Assets  
      - [ ] Mockup of gameplay screen  
      - [ ] Key art  
      - [ ] Key UI frames  
      - [ ] App store icon  
- [ ] SSR Test Results  
- [ ] Internal Playtest and Conviction  
- [ ] Fake App Store Tests  
- [ ] Publish AI Prototype on store and test D1 \+ number of games on D0

---

## 2\. Identity

| Field | Value |
| :---- | :---- |
| Working title | Spellbound |
| Genre / subgenre | Real-time arena combat / rhythm-action hero-collector |
| Target audience | Western mid-core players who play hero-collectors but want the skill expression of a rhythm game layered on top — the "I'm conducting this fight" feeling that pure auto-battlers don't deliver. |

---

## 3\. Core thesis / idea

**Core idea (player-voice, \~100 words):**

You're the wizard. Four heroes fight in the dungeon in front of you — they move on their own, attacking enemies, dodging, picking targets. At the bottom of the screen, your hands hover, and rhythm tiles slide down toward a strike line. Tap each tile right as it crosses the line and your hands cast a spell — a fireball that arcs into the fight, a healing wave that lands on a hero, a frost ring that slows everything. Miss the tile and the spell fizzles in a wisp of smoke. Each match is 20 waves. Outside matches you pull new heroes — each one teaches your hands a new rhythm.

---

## 4\. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Camera tilts down. Two wizard hands rest at the bottom of the screen, fingers curled. Above them, a dim dungeon corridor. Text fades in: "These are your hands. Cast well." Tap to start.  
- **5–15s:** First wave begins. Two heroes — a knight, an archer — walk in from offscreen and engage three goblins. Heroes auto-attack. A single rhythm tile slides down from the top of the screen toward a glowing strike line just above the hands. Tooltip arrow: "Tap."  
- **15–25s:** Player taps as the tile crosses the line. Hands flare green; a healing pulse lands on the knight. Wave clears. A draft modal pops with three skill cards for the knight. Player taps one.  
- **25–40s:** Wave 2\. Two tiles come down, then a held tile (long press). Player nails the combo; a fireball arcs out and detonates among the next enemy cluster. Numbers stack.  
- **40–60s:** Wave 4\. A third hero — a violet-robed mage — walks in from offscreen. The tile strip now shows hero-tinted highlights: green for the cleric, red for the mage, blue for frost. **The "I'm conducting this fight" moment.**

---

## 5\. Hypothesis of why this would work

Western mid-core players who play hero-collectors (AFK Arena, Hero Wars, Watcher of Realms) increasingly flag passivity as the churn signal. The two-week meta is rich, but the moment-to-moment is "press auto and watch." They want the skill expression of an action game without the input demands of an action game — a way for *their* competence to be visible inside an otherwise idle frame. The Magic Tiles / Beatstar audience proves Western casual\+midcore will tap rhythms for hours on a phone. Archero proved the same audience will accept first-person-adjacent action-defense framing for a draft loop.

Spellbound's bet is that the rhythm-tile strip is the bridge: it layers skill expression onto auto-battle hero combat without demanding tactical positioning. The wizard-hands first-person frame is the load-bearing trick — in third-person hero-collectors the player has no body, just a team they own; in first-person wizard view every cast is *the player's hand*, and perfect-hit feedback (visual flare, screen shake, audio chord) lands as the player's competence, not the team's. The roster decision and the rhythm decision couple: different heroes carry different spell rhythms, so collecting heroes is collecting rhythms. The diff vs. Wittle: hero free movement keeps the dungeon alive, and the tile strip carries the active skill check that fixed positioning would otherwise have to.

---

## 6\. Risks

**Single fragile assumption:**

*Western mid-core players will engage with the rhythm-tile strip across 5+ minute matches without it reading as busywork — only if perfect-hit feedback is satisfying enough that streaks feel like flow, not labor.*

If the rhythm strip reads as a treadmill, the whole skill layer collapses and we've shipped a worse auto-battler. Stage 1 bundle: *"Rhythm casting feels like skill, not chore."* Stage 4 (gameplay video) re-tests with motion, especially perfect-hit chains and Conductor's Touch combo triggers.

---

## 7\. Reference games

1. **Magic Tiles 3** — Amanotes, 2018, mobile. Rhythm-tile core mechanic, massive Western casual reach. We share the slide-and-tap tile strip and the haptic feel of perfect-hit chains; we don't share music as the content layer — Spellbound's tiles serve combat outcomes, not song progression.  
2. **AFK Arena** — Lilith, 2019, mobile. Hero-collector with deep meta and 5-minute sessions. We share the roster meta and session shape; we don't share the fully-passive combat — Spellbound's combat is rhythmically active and the player's input drives spell output.  
3. **Archero** — Habby, 2019, mobile. Action-defense template with per-floor skill draft. We share the wave-pressure escalation and the first-person-adjacent framing; we don't share the single-character joystick — Spellbound is team-first and the player's input is tap-rhythm, not movement.

**Genre mashup formula:** Magic Tiles × AFK Arena × first-person tabletop combat

---

## 8\. Progression

### Rest of D1 (\~5–10 min after first 60s)

- Match 1 completes around wave 12 (intentional loss-feel) — first defeat tooltip explains hero swap and "Stronger heroes cast stronger spells."  
- Free 10-pull from the chapter intro lands 4 new heroes. Two new rhythm patterns unlock — one is a fast 4-tap combo, one is a hold-and-release.  
- Match 2 attempted with new team. Clears wave 15\. First "this matters" moment: a perfect-hit streak triggers the **Conductor's Touch** ring around the hands and the match shifts pace.  
- Heroic Mastery unlock on the lead hero at level 10 — adds a fifth tile slot to her rotation.  
- First daily Spell Trial banner appears on the home screen — locked until D3 to anchor a return reason.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | 4–5 heroes, three rhythm patterns memorized, first Conductor's Touch streak landed. | "I want to feel new rhythms" — the Spell Codex shows twelve rhythm-icons but only three are learned. |
| D3 | 8–10 heroes, one ascended via duplicate, picks teams by Trial restriction. | First daily Spell Trial unlocks — rotation restricted to one spell family, big rewards for the right roster. |
| D7 | First chapter wall — current rotation can't sustain DPS at the boss. | Targeted pulls on a burst-DPS hero whose rhythm closes the gap. |
| D14 | First PvP Arena unlock — async ghosts of other players' rotations. | Weekly ranked rewards \+ a leaderboard where placement reads as your rotation quality. |

---

## 9\. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, \~135 words)

```
You're playing a wizard, and four heroes fight in the dungeon in front
of you. The heroes move on their own — they pick targets, dodge,
attack. You don't control them directly.

At the bottom of the screen, your wizard hands hover. Rhythm tiles
slide down from above and reach a strike line just above the hands.
When you tap each tile right as it lands, your hands cast a spell —
a fireball that arcs into the fight, a healing wave, a frost ring
that slows enemies.

Each match is 20 waves of enemies. Mini-bosses appear at waves 10
and 15. A big boss at wave 20. About 5–8 minutes from start to
finish.

Miss tiles and your heroes start losing. Hit a streak of perfect
taps and a Conductor's Touch combo triggers, doubling spell strength.
```

#### Full description of core loop \+ 1 meta progression (Stage 1, genre-required, \~170 words)

```
You pick four heroes from your collection. They appear in the
dungeon in front of you and start fighting on their own — moving,
dodging, picking targets, attacking. You don't control them directly.

At the bottom of the screen, your wizard hands hover. Rhythm tiles
slide down from above and reach a strike line just above the hands.
When you tap each tile right as it lands, your hands cast a spell —
a fireball that arcs into the fight, a healing wave, a frost ring
that slows enemies.

Each match is 20 waves of enemies. Mini-bosses at waves 10 and 15.
A big boss at wave 20. About 5–8 minutes from start to finish. Miss
tiles and your heroes start losing. Hit a streak and Conductor's
Touch combos trigger, doubling spell strength.

Outside matches, you build your hero roster: new heroes unlock from
chapter rewards and a summoning banner. Between matches you level
heroes and equip them with gear. Each hero brings a different spell
rhythm — so changing your team changes what you're tapping.
```

#### Store-page variant (Stage 1b optional, \~55 words)

```
You're the wizard. Your four heroes fight the dungeon in front of
you. Your hands cast the spells. Tiles slide down — tap them right
and fireballs fly, healing waves land, frost coats the floor. Twenty
waves a match. Five minutes a run. Collect more heroes. Each one
teaches your hands a new rhythm.
```

#### First 1–5 minutes the player experiences (\~280 words)

```
Boot-up: studio logo, then a soft tilt down. The camera lowers. Two
wizard hands rest at the bottom of the screen, fingers curled. Above
them, a dim dungeon corridor lit by torches. Text fades in: "These
are your hands. Cast well."

Tutorial wave 1 starts. Two heroes walk in from offscreen — a knight
with a shield, an archer behind him. Three goblins shuffle out from
the back of the corridor. The heroes auto-engage. Damage numbers pop.

A single rhythm tile slides down from the top of the screen toward a
glowing strike line just above the hands. A tooltip arrow points:
"Tap." The player taps as the tile crosses the line. Hands flare
green; a healing pulse lands on the knight; the player sees it.

Wave 1 clears. The screen briefly dims and three skill-draft cards
appear above the knight's portrait. "Pick one." Player taps. Card
flips and snaps onto the hero.

Wave 2: two tiles come down, then a held tile (long press). Player
misses the hold; the spell fizzles in a wisp of smoke. No punishment,
but the next enemy gets close.

Wave 3: a third hero — a mage in violet robes — walks in from
offscreen. A new red-tinted tile appears: fire spell. Player hits it
clean. The wizard hands form a circle. A fireball arcs out and
detonates among the goblins. "+621" pops on three of them at once.

By wave 6, the player has hit twelve tiles, missed three, and watched
their first Conductor's Touch streak trigger — a gold ring around the
hands. Defeat at wave 13: "You held to wave 13. Four new heroes
joined your roster." Free 10-pull plays. The player taps "Try Again."
```

#### D1–D14 player journey / progression description (Stage 2 input, \~340 words)

```
Day 1. The player finishes their first session having played 3–5
matches, cleared up to wave 15 once, and pulled their starter pack
of heroes. They've felt the rhythm strip start to click — the
held-tile timing was the moment it stopped feeling random and started
feeling like skill. The hook for tomorrow is the visible
rotation-incompleteness: they've memorized three rhythm patterns but
can see twelve rhythm-icons in the Spell Codex preview.

Day 2. Returning player gets a log-in pull plus the first chapter-2
unlock. Chapter 2 introduces an enemy type that closes distance fast,
forcing the player to weight heal-tiles higher in their rotation.
The day's progression is mostly about gear — each hero shows the
next equipment tier in their detail screen, and the player upgrades
two of them and sees the stat-bump on the next match.

Day 3. The first daily Spell Trial unlocks. Today's Trial restricts
rotation to fire-tile heroes only. The player either has the team
for it or they don't. If they do, big reward and a "I read this
right" feeling. If they don't, small reward and clear motivation to
pull the current Fire banner. By end of D3 the player has 8–10
heroes, ascended their lead hero once with a duplicate pull, and is
starting to think in rotations, not individual spells.

Day 7. The chapter-3 wall hits. Boss spawns burst-summon enemies
that overwhelm low-DPS rotations. The talent tree on the lead hero
is fully unlocked — adding a fifth tile to her rotation makes the
tap density real. The choice presented is targeted pulls on a
burst-DPS hero, or grinding the prior chapter for ascension
materials. Both work.

Day 14. PvP Arena unlocks. Opponents are AI ghosts of other players'
rotations — the asynchronous "your perfect run vs. their perfect run"
loop. The player's roster is 15–20 deep with 2–3 ascended. Weekly
ranked rewards drop. The morning session is Spell Trial; the evening
session is climbing PvP rank against ghost rotations.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a rhythm-action hero-collector. Required for Stage 3\.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Single static frame: first-person view with wizard hands at bottom, four hero-portrait slots along the bottom edge, dungeon above with 4-hero formation mid-wave, enemies clustered ahead, rhythm tiles streaming down the right-of-center channel toward the strike line, HUD with wave counter \+ Conductor's Touch meter \+ coin/gem counters. Must read as "I'm the wizard, my heroes fight, I tap to cast" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. Wizard hands lit by spell-glow at the bottom, four heroes silhouetted in the dungeon ahead, an arcing fireball mid-flight from hands to enemies, torches \+ stone walls framing the scene. The image that leads the store listing. |
| **Key UI frames** | TBD | (1) Gameplay HUD mid-wave with rhythm tiles in motion, (2) Skill-draft modal between waves, (3) Hero collection screen, (4) Hero detail / spell-rhythm upgrade screen, (5) Summoning banner, (6) Daily Spell Trial select screen. |
| **App store icon** | TBD | 1024×1024. Wizard hands forming a triangle, a glowing rhythm tile centered above the fingertips, dungeon-aesthetic-led. Tested for thumbnail readability at 88×88. |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: one playable chapter (5 matches), 4 heroes available, 3 spell rhythms functional (heal, fireball, frost), rhythm strip with strike-line and timing windows, Conductor's Touch combo trigger functional, hero free-movement AI functional. No meta-loop, no monetization, no banner. Input latency is critical — rhythm timing must feel locked-in on a real device. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 30s onboarding read (hands-down camera reveal \+ first tile tap), first Conductor's Touch streak (skill-feedback beat), first wave-overrun (loss beat), first multi-tile combo land (mastery beat). Each scored separately at Stage 4\. |
