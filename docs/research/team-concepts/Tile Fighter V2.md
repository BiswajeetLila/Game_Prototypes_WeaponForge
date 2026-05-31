# Conduit — Concept Template v2 (Worked Example)

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
| Working title | Conduit |
| Genre / subgenre | Real-time arena combat / dual-collection hero \+ spell collector |
| Target audience | Western mid-core players who play hero-collectors but hit the meta-flatness wall around D14–D21 — they want a second collection axis that interacts mechanically with their roster, not just a costume layer. |

---

## 3\. Core thesis / idea

**Core idea (player-voice, \~100 words):**

You're a wizard. Four heroes fight in the dungeon in front of you — they move on their own, attacking enemies, dodging. At the bottom of the screen, four spell slots sit above your hands. Each spell is on a cooldown. Tap a ready spell and your hands cast it — a fireball arcs into the fight, a healing wave lands, a frost ring slows everything, spectral hounds spawn to fight beside your heroes. You pick which four spells your hands know before each match. Outside matches you collect heroes — and spells, on a separate banner. A new spell can change what every team you own is capable of.

---

## 4\. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Camera tilts down. Two wizard hands rest at the bottom of the screen. Four spell slots glow above the fingertips. Text fades in: "These are your spells. Cast at will." Tap to start.  
- **5–15s:** First wave begins. Two heroes — a knight, an archer — walk in from offscreen and engage three goblins. Heroes auto-attack. One spell slot pulses ready (heal). Tooltip arrow: "Tap to cast."  
- **15–25s:** Player taps. Hands form a green sigil. Healing pulse lands on the knight. The spell icon dims and a cooldown ring begins filling clockwise around it.  
- **25–40s:** Wave 2 — fireball is now ready. Player taps. Fireball arcs out and detonates among the enemy cluster. "+621" stacks on three of them.  
- **40–60s:** Wave 4 — a third hero (violet-robed mage) walks in. Mid-wave a new spell unlocks: **Spectral Hounds** snaps into the empty fourth slot. Player taps. Two ghostly hounds spawn in the dungeon and fight beside the heroes. **The "I shape this fight" moment.**

---

## 5\. Hypothesis of why this would work

Western mid-core players who play hero-collectors (AFK Arena, Hero Wars Alliance, Watcher of Realms, AFK Journey) consistently hit the meta-flatness wall around D14–D21 — roster expansion stops feeling consequential because every new hero slots into the same passive auto-combat. The "I built this team" feeling decays once the roster matures. Recent Brown Dust 2 and AFK Journey data suggests dual-collection meta (heroes \+ a second axis of equal weight) extends meta engagement past the first month — but the second axis has to interact mechanically, not cosmetically. Costume layers don't move the number.

Conduit's bet is that the spell loadout is the second collection axis with mechanical bite. Each spell pulls from a separate banner, has its own rarity, cooldown curve, and damage profile, and slots into a 4-spell active loadout the player taps in real time. The hero collection answers "who is fighting"; the spell collection answers "what am I doing during the fight." The first-person wizard-hands framing makes the player the spell-caster, not a team-owner — every cast lands with the emotional beat of activating an Ultimate in a MOBA. The shipped reference is Hearthstone Battlegrounds — Blizzard proved Western players will engage with two compound collection layers if they interact mechanically. Conduit's diff: real-time auto-battle hero placement plus active tap-to-cast spell loadout, instead of card-based turn structure. The dual-pull moment is the bet — every match-end shows two banners spinning, doubling the dopamine surface.

---

## 6\. Risks

**Single fragile assumption:**

*Western mid-core players will accept dual collection (heroes \+ spells) as a force-multiplier on excitement, not as a dilutant of pull moments — only if the spell-hero synergy matrix is large enough that every new spell **or** new hero meaningfully changes existing loadouts.*

If spell pulls feel less exciting than hero pulls (or vice versa), one collection becomes a chore the other has to subsidize. Stage 1 bundle: *"Collecting spells feels as good as collecting heroes."* Stage 4 (gameplay video) tests with on-screen dual-pull framing and a side-by-side reveal animation.

---

## 7\. Reference games

1. **AFK Arena** — Lilith, 2019, mobile. Hero-collector with deep meta and idle-friendly progression. We share the roster meta, 5-minute session shape, and gacha pull rhythm; we don't share fully-passive combat — Conduit's combat is actively cast by the player, not just watched.  
2. **Hearthstone Battlegrounds** — Blizzard, 2019, mobile/PC. Two collection axes (heroes \+ minion tribes) that interact mechanically inside a match. We share the dual-meta architecture and the "loadout reads telegraph strategy" feel; we don't share the turn-based card structure — Conduit is real-time auto-battle with tap-to-cast.  
3. **Brown Dust 2** — Neowiz, 2023, mobile. Hero collector with positional combat and a costume-layer second axis. We share dual-collection and positional reasoning; we don't share turn-based combat or the costume axis — Conduit's second collection is mechanical (spells with cooldowns and effects), not cosmetic.

**Genre mashup formula:** AFK Arena × Hearthstone Battlegrounds × first-person spellcaster

---

## 8\. Progression

### Rest of D1 (\~5–10 min after first 60s)

- Match 1 completes around wave 10 (intentional loss-feel) — first defeat tooltip: "Different spells suit different teams. Try swapping your loadout."  
- Free pulls land on both banners: 4 new heroes from the hero banner, 2 new spells from the spell banner. One of the new spells is chain-lightning, which pairs cleanly with the archer's burst windows.  
- The Loadout screen opens for the first time — 4 spell slots, 6 spells now available to slot. First "I made a deliberate choice" moment.  
- Match 2 attempted with new loadout. Clears wave 14\. First "this combo is *mine*" beat.  
- Talent tree unlock on the lead hero at level 10\.  
- First daily Spellforge event appears on home — locked until D3 to anchor a return reason.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | 4–5 heroes, 3 spells, first custom 4-spell loadout assembled. | Two banners visibly incomplete — twice the surface area to chase. |
| D3 | 8–10 heroes, 6–7 spells. First daily Spellforge unlocks (burn duplicates to upgrade spells). | Duplicate pulls now matter for two axes; today's chapter boss is weak to a spell type the player almost has. |
| D7 | First chapter wall — current loadout's cooldown rotation can't burst-clear the boss-summons. | Targeted pulls on a burst spell, or hero respec for cooldown reduction. |
| D14 | First PvP Arena unlock — async duels where opponent loadout is visible before the match. | Weekly ranked rewards \+ counter-build chess feel. |

---

## 9\. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, \~135 words)

```
You're playing a wizard, and four heroes fight in the dungeon in
front of you. The heroes move on their own — they pick targets,
dodge, attack. You don't control them directly.

At the bottom of the screen, your wizard hands hover and four spell
slots sit just above them. Each spell has a cooldown — when the
ring around its icon fills, the spell is ready. Tap a ready spell
and your hands cast it: a fireball arcs into the fight, a healing
wave lands on a hero, a frost ring slows enemies, a summon spell
spawns reinforcements that fight alongside your heroes.

Each match is 20 waves of enemies. Mini-bosses appear at waves 10
and 15. A big boss at wave 20. About 5–8 minutes from start to
finish. You pick which four spells to bring before the match
starts.
```

#### Full description of core loop \+ 1 meta progression (Stage 1, genre-required, \~170 words)

```
You pick four heroes and four spells before each match. The heroes
appear in the dungeon in front of you and start fighting on their
own — moving, dodging, picking targets, attacking. You don't
control them directly.

The four spells sit at the bottom of the screen, each with a
cooldown ring around its icon. Tap a ready spell and your wizard
hands cast it: a fireball arcs into the fight, a healing wave
lands, a frost ring slows enemies, a summon spawns hounds that
fight beside your heroes.

Each match is 20 waves. Mini-bosses at waves 10 and 15. A big boss
at wave 20. About 5–8 minutes from start to finish.

Outside matches, you build two collections. Heroes come from a hero
banner — chapter rewards, summoning pulls, duplicates ascend heroes
you already own. Spells come from a separate spell banner — each
spell has its own rarity, cooldown curve, and damage profile.
Duplicate spells upgrade the spell to a stronger tier. A new spell
can change what every team in your roster is capable of.
```

#### Store-page variant (Stage 1b optional, \~55 words)

```
You're the wizard. Four heroes fight the dungeon. Four spells in
your hands — fireball, heal, frost, summon. Each one on a
cooldown. Tap when ready. Collect more heroes. Collect more spells.
Every new spell changes every team you own. Twenty waves a match.
Five minutes a run.
```

#### First 1–5 minutes the player experiences (\~280 words)

```
Boot-up: studio logo, then a slow tilt down. The camera lowers.
Two wizard hands rest at the bottom of the screen, palms turned up.
Four spell slots glow softly above the fingertips. Text fades in:
"These are your spells. Cast at will."

Tutorial wave 1 starts. Two heroes walk in from offscreen — a knight
with a shield, an archer behind him. Three goblins shuffle out from
the back of the corridor. Heroes auto-engage. Damage numbers pop.

A single spell slot pulses — the heal. Tooltip arrow points: "Tap."
The player taps. Wizard hands form a green sigil; a healing pulse
lands on the knight. The spell icon dims and a cooldown ring begins
to fill clockwise around it.

Wave 1 clears. A short modal: "Pick a skill for your knight."
Three cards. Player taps one — "+15% attack speed" — it snaps onto
the hero.

Wave 2: the heal is still on cooldown. The fireball glows ready.
Player taps. Hands form a circle. A fireball arcs out and detonates
among the goblins. "+621" pops on three. The fireball's cooldown
ring starts filling.

Wave 4: a third hero — a mage in violet robes — walks in from
offscreen. Mid-wave, a new spell unlocks: "Spectral Hounds" snaps
into the empty fourth slot. The icon pulses. Player taps. Two
ghostly hounds spawn in the dungeon and join the fight. They
disappear at the end of the wave but the player sees them shred a
goblin first.

By wave 8, the player has cast eleven spells, watched the
heal-fireball-frost rotation stabilize, and lost a hero to a wave 7
surge they couldn't out-heal. Defeat screen: "You held to wave 8.
Four new heroes and two new spells joined your collection."
Dual-pull animation plays. Player taps "Try Again." The Loadout
screen opens for the first time.
```

#### D1–D14 player journey / progression description (Stage 2 input, \~340 words)

```
Day 1. The player finishes their first session having played 3–5
matches, cleared up to wave 12 once, and pulled their starter
packs of both heroes and spells. They've assembled their first
custom 4-spell loadout and felt the first "I chose this combo and
it worked" moment when fireball cleared a wave the heal alone
couldn't. The hook for tomorrow is the visible incompleteness of
both banners — two collections to chase, not one, and twice the
dopamine surface on every pull screen.

Day 2. Returning player sees log-in rewards on both banners and a
chapter-2 unlock. Chapter 2 introduces a stagger mechanic that
makes the chain-lightning spell suddenly valuable on burst windows.
The day's progression is mostly hero gear and spell-tier upgrades —
duplicate spells from yesterday's pulls graduate to rare tier and
their cooldowns shorten visibly in the spell detail screen.

Day 3. The first daily Spellforge unlocks — sacrifice duplicate
spells to upgrade chosen spells. The player has tough choices:
burn a mid-tier spell they don't use to upgrade their main
fireball? Today's chapter boss is weak to fire, and the upgrade
is the difference between clearing and grinding. By end of D3 the
player has 8–10 heroes, 6–7 spells, and starts thinking in
loadouts rather than individual unlocks — "do I bring burst or
sustain to this boss."

Day 7. The chapter-3 wall hits. Boss spawns burst-summon enemies
that overwhelm the current loadout's cooldown rotation. The choice
is targeted pulls on a burst spell, or grinding ascension
materials on a hero whose passive shortens cooldowns. Both work,
and each implies a different future identity. First "what kind of
wizard am I" moment.

Day 14. PvP Arena unlocks. Asynchronous duels where the player can
see the opponent's spell loadout before the match — it telegraphs
strategy and forces counter-builds. The roster is 15–20 deep, the
spell collection is 12–15 deep, and 2–3 of each are ascended.
Weekly ranked rewards drop. Mornings are Spellforge; evenings are
climbing PvP rank against opponents whose loadouts read like a
chess opening.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a dual-collection hero \+ spell collector. Required for Stage 3\.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Single static frame: first-person view with wizard hands at bottom, four spell slots above the fingertips (one mid-cooldown with a partial ring, three glowing ready), four hero-portrait slots along the bottom edge, dungeon above with 4-hero formation mid-wave, enemies clustered ahead, HUD with wave counter \+ coin/gem counters \+ pause/auto/speed buttons. Must read as "I'm the wizard, my heroes fight, I tap my spells" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. Wizard hands lit by overlapping spell auras at the bottom, four heroes silhouetted in the dungeon ahead, multiple spells visible in motion — fireball arcing, frost ring forming, summoned hounds running. The image that leads the store listing. The dual-collection promise has to read in a single image. |
| **Key UI frames** | TBD | (1) Gameplay HUD mid-wave with spell cooldowns visible, (2) Hero collection screen, (3) Spell collection screen, (4) Loadout screen (4 hero slots and 4 spell slots side-by-side), (5) Hero summoning banner, (6) Spell summoning banner. Two separate banner screens, separately styled. |
| **App store icon** | TBD | 1024×1024. Wizard hands holding four glowing spell sigils in an arc above the fingertips, faint hero silhouettes behind. Spell-collection-led visual identity. Tested for thumbnail readability at 88×88. |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: one playable chapter (5 matches), 4 heroes available, 6 spells available with 4-slot active loadout, cooldown system functional, loadout switching between matches, hero free-movement AI functional. No meta-loop, no monetization, no banners — players pre-equipped with all 6 spells for the prototype. Cooldown clarity and the "tap-to-cast" haptic must feel locked-in on a real device. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 30s onboarding read (camera reveal \+ first cast), first custom-loadout match (meta beat), first wave-overrun (loss beat), first dual-pull animation showing both hero \+ spell banners spinning side-by-side (dopamine beat). Each scored separately at Stage 4\. |
