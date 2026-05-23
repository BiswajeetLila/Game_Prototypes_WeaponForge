# Wittle Defender — Concept Template v2 (Worked Example)

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
| Working title | Wittle Defender |
| Genre / subgenre | Real-time arena defense / hero-collector roguelike |
| Target audience | Western mid-core players who graduated from Vampire Survivors and want a team-building hook that persists across runs. |

---

## 3\. Core thesis / idea

**Core idea (player-voice, \~100 words):**

You build a team of five chibi heroes who hold fixed positions around a circular arena while enemies pour in from all sides. The match is 20 waves of escalating threat. After each wave you pick skill upgrades for each hero from a 3-card draft, stacking commons into rares into epics. Pair two heroes of the same element and a Chain Skill triggers — passive buffs that turn a good run into a great one. Outside matches you build your roster: new heroes come from a summoning banner, and duplicates ascend the heroes you already have.

---

## 4\. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Brief intro: five chibi heroes lined up. "These are your defenders. They hold the arena." Tap to start.  
- **5–15s:** First wave begins. 2 heroes deploy in their fixed slots. Enemies appear from the edges. Heroes auto-attack. Numbers pop on hits.  
- **15–25s:** Wave 1 clears in \~8s. A modal pops: "Pick a skill." Three cards visible per active hero. Player taps one.  
- **25–40s:** Waves 2–3. The picked skill is visibly stronger. Player sees the cause-and-effect of their draft choice.  
- **40–60s:** Wave 4\. Two heroes of the same element are now both active. Chain Skill triggers — frost coats the arena, all enemies slow. **The "I want to pull more ice heroes" moment.**

---

## 5\. Hypothesis of why this would work

Western mid-core players have two unmet wants that no single shipped title currently combines well. From Vampire Survivors they want the per-wave draft-stacking loop — the "I built this run" feeling that comes from making fifteen small choices that compound. From hero collectors (AFK Arena, Brown Dust 2, Epic Seven) they want the long-arc roster identity — the "this is *my* team" feeling that persists across runs. Vampire Survivors gives them the first and throws away the run; hero collectors give them the second and make matches passive.

Wittle's bet is that the Chain Skill matrix is the bridge. Element pairings (10 elements × \~50 heroes) create a build space large enough that *which heroes you own* directly changes *what your in-run draft becomes*. The roster decision and the wave-by-wave decision are coupled. The shipped reference that validates the pattern is Archero — Habby's prior hit proved Western mid-core will accept fixed-character action-defense for the draft loop. Wittle's diff is replacing the single character with a team, which is the layer Hero Wars Alliance tried and failed at because they kept the matches passive. The active in-match draft is the assumption that has to hold.

---

## 6\. Risks

**Single fragile assumption:**

*Western mid-core players will tolerate fixed positional combat if Chain Skills feel powerful enough that positioning reads as **strategic constraint** rather than **frustrating limitation**.*

If Chain Skills feel like a bonus instead of the point, the fixed-position mechanic becomes "why can't I move my hero." Stage 1 bundle: *"Fixed positions feel strategic, not limiting."* Stage 4 (gameplay video) re-tests this with motion.

---

## 7\. Reference games

1. **Archero** — Habby, 2019, mobile. Action-defense template, skill-draft per floor, single-character. We share the per-wave draft loop; we don't share the single-character framing — Wittle is team-first.  
2. **Vampire Survivors (mobile)** — poncle, 2022\. Skill-draft roguelike, fixed character per run. We share the wave-pressure \+ draft-stacking core; we don't share single-character or permadeath-per-run.  
3. **Brown Dust 2** — Neowiz, 2023, mobile. Hero collector with positional combat, narrative-led. We share the positional-formation idea and gacha layer; we don't share the turn-based combat — Wittle is real-time.

**Genre mashup formula:** Tower defense × Vampire Survivors × hero collector

---

## 8\. Progression

### Rest of D1 (\~5–10 min after first 60s)

- Match 1 completes around wave 8 (intentional loss-feel) — first defeat tooltip explains hero swap.  
- Free 10-pull from the chapter intro lands 3 new heroes. One overlaps an existing element → second Chain Skill option unlocks.  
- Match 2 attempted with new team. Clears wave 12\. First "this matters" moment.  
- Talent-tree unlock on the lead hero at level 10\.  
- First daily Boss Challenge banner appears on the home screen — locked until D3 to anchor a return reason.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | 3–5 heroes from free pulls \+ first chapter rewards. First Chain Skill triggered. | "I want to pull more ice heroes" — the Chain Skill matrix is visibly bigger than their roster. |
| D3 | 8–10 heroes, one ascended via duplicate, picks teams by boss element. | First daily Boss Challenge unlocks — element-locked boss rotation. |
| D7 | First chapter wall — current team can't clear it. | Targeted pulls \+ ascension push to break the wall. |
| D14 | First PvP arena unlock with ascended heroes. | Weekly ranked rewards \+ leaderboard chase. |

---

## 9\. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, \~135 words)

```
You're defending a circular arena from waves of enemies. Five heroes
stand in fixed positions: one in the center, four around the edges.
Heroes don't move during the match — they stay in their slots and
attack whatever comes in range.

After each wave, every hero gets offered three skill cards. You pick
one for each. Stack three commons of the same type and it upgrades
into a rare; stack rares for an epic. Pair two heroes of the same
element (Ice, Fire, Wind, Electro) and they unlock a passive team
buff called a Chain Skill.

Each match is 20 waves. Mini-bosses show up at waves 10 and 15.
A big boss at wave 20. About 5–8 minutes from start to finish.
```

#### Full description of core loop \+ 1 meta progression (Stage 1, genre-required, \~170 words)

```
You pick five heroes from your collection. They take fixed positions
around the center of a circular arena: one in the middle, four around
the edges. Enemies start spawning from outside the arena and walking
inward. Your heroes don't move during the match — they stay in their
slots and attack whatever comes in range.

After each wave, every hero gets offered three skill cards. You pick
one for each. Stack three commons of the same type and it upgrades
into a rare; stack rares for an epic. Pair two heroes of the same
element (Ice, Fire, Wind, Electro) and they unlock a passive team
buff called a Chain Skill.

Each match is 20 waves. Mini-bosses show up at waves 10 and 15.
A big boss at wave 20. About 5–8 minutes from start to finish.

Outside matches, you build your hero roster: new heroes unlock over
time, sometimes as rewards and sometimes from a summoning banner.
Between matches you level your heroes up and equip them with weapons
and gear. Getting a duplicate of a hero you already own makes that
hero stronger.
```

#### Store-page variant (Stage 1b optional, \~55 words)

```
You command five chibi heroes who stand in a circle around the center
of an arena. Enemies pour in from all sides. Your heroes don't move —
they hold their positions and attack what gets close. Between waves,
you pick new powers for them. Over time, you collect more heroes to
swap in. Twenty waves. About five minutes a run.
```

#### First 1–5 minutes the player experiences (\~280 words)

```
Boot-up: studio logo, then a five-second cinematic — five chibi
heroes turning to face the camera, then snapping into formation
around a glowing arena. Text fades in: "Hold the line."

Tutorial wave 1 starts immediately, no menus. Two heroes are already
in their slots — a sword-girl in the center, an ice-mage at the
north edge. The other three slots are dim outlines. A tooltip arrow
points at the first enemy walking in from the south. Heroes
auto-attack. Damage numbers pop. The wave clears in eight seconds.

A draft modal appears, dimming the arena. Three cards above each
active hero — a tooltip highlights one for the sword-girl: "+15%
attack speed." Player taps it. The card flips, snaps onto the hero,
and her sword visibly glows. Modal dismisses.

Wave 2: the sword-girl is visibly faster. Player sees their choice
mattering. Wave clears in six seconds. Draft again — this time no
tooltip, the player chooses freely.

Wave 4: the third hero slot unlocks — an ice demon walks into the
arena from offscreen and takes the south edge. Both ice heroes are
now active. A blue ring pulses across the arena, "CHAIN SKILL —
FROST ARMOR" prints big across the screen. Enemies in the next wave
all slow by 30%. The frost effect lingers visibly on the ground.

By wave 8, the player has drafted twelve skills, watched two Chain
Skills trigger, and lost a hero to a wave 7 surge. Defeat screen
appears: "You held to wave 8. Three new heroes have joined your
roster." Free 10-pull animation plays. Three new heroes spin in.
The player taps "Try Again" and the next match's hero-select screen
opens for the first time.
```

#### D1–D14 player journey / progression description (Stage 2 input, \~340 words)

```
Day 1. The player finishes their first session having played 3–5
matches, cleared up to wave 12 once, and pulled their starter pack
of heroes. They've triggered at least one Chain Skill and they've
seen the talent-tree icon glow on their lead hero. The hook for
returning tomorrow is the visible incompleteness of the Chain Skill
matrix — they have heroes in two elements but can see four element
icons in the Chain Skill preview screen.

Day 2. Returning player sees a "log-in reward" pull plus the first
chapter-2 unlock. New enemies introduce a stagger mechanic that
makes Wind-element heroes feel suddenly important. The day's
progression is mostly about equipping their favourite heroes with
the first weapon drops — they see the stat-bump on next match.

Day 3. The first daily Boss Challenge unlocks. Today's boss is
weak to Fire. The player either has the team for it or they don't.
If they do, they get a big reward and feel smart. If they don't,
they get a small reward and a clear motivation to pull on the
current Fire-banner. By end of D3 the player has 8–10 heroes,
ascended their lead hero once with a duplicate pull, and is starting
to think in team compositions.

Day 7. The chapter-3 wall hits. The player's current best team
can't clear the chapter boss. The talent tree on their lead hero is
fully unlocked. The choice presented is targeted pulls on a synergy
hero, or grinding the prior chapter for ascension materials. Both
work.

Day 14. PvP arena unlocks. The player's roster is now 15–20 heroes
deep with 2–3 ascended. Weekly ranked rewards drop. The ranking
ladder becomes the new return reason — the daily Boss Challenge
still anchors the morning session, but the evening session is now
about climbing PvP rank.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a hero-collector. Required for Stage 3\.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Single static frame: five-hero formation in arena, mid-wave, enemies visible, HUD with wave counter \+ draft-pending indicator \+ Chain Skill bar. Must read as "what kind of game is this" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. Five chibi heroes in formation, frost-coated arena, threat closing in from edges. The image the store listing leads with. |
| **Key UI frames** | TBD | (1) Gameplay HUD mid-match, (2) Skill-draft modal, (3) Hero collection screen, (4) Hero upgrade / talent tree, (5) Summoning banner, (6) Daily Boss Challenge select screen. |
| **App store icon** | TBD | 1024×1024. Likely a single hero in formation pose, ice-aesthetic-led. Tested for thumbnail readability at 88×88. |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: one playable chapter (5 matches), 5 heroes available, 2 elements (Ice \+ Fire), Chain Skills functional, skill-draft loop functional. No meta-loop, no monetization, no banner. Must feel-representative on a real device. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 30s onboarding read, first Chain Skill trigger (win beat), first wave-overrun (loss beat), first draft decision moment. Each scored separately at Stage 4\. |

