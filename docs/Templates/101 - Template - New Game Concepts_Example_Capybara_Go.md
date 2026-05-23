# Capybara Go — Concept Template v2 (Worked Example)

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
| Working title | Capybara Go |
| Genre / subgenre | Tap-driven roguelite / story-event runner |
| Target audience | Casual mobile players who want a 5-minute "play a few cards on the train" loop with a story wrapper and visible run-over-run progression. |

---

## 3\. Core thesis / idea

**Core idea (player-voice, \~100 words):**

You play a capybara who taps through a series of story-event cards — a merchant offering a stick, an angel offering a heal, a witch trading magic for HP. Most cards are choices, sometimes a card is combat that resolves on its own in a few seconds while you watch numbers pop. Each run is 60 tap-days and ends at the chapter boss or when you wipe. Between runs, you spend what you earned on weapon upgrades and a talent tree, so each new run starts a little stronger than the last. You're playing a story where battles happen to be one of the things that occur.

---

## 4\. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Title screen, then a soft cutaway to a small capybara on a path. Text fades in: "Tap Next Day to continue."  
- **5–15s:** Player taps "Next Day." A card flips up: a merchant offering a wooden stick for 10 gold. Two buttons: "Buy" / "Pass."  
- **15–25s:** Player taps "Buy." The stick equips. The capybara's portrait now shows a stick. Next-day button reappears. Player taps again — a combat card. A short auto-battle plays. Numbers pop. Win. Small XP bar fills.  
- **25–40s:** Two more event cards. An angel asks if you'd rather have \+1 skill or \+20 HP. Player picks skill. The skill icon docks onto the capybara's loadout. Another combat resolves cleanly.  
- **40–60s:** Wave-day 5\. A witch offers a magic boost in exchange for half your HP. The first real *decision* — high reward, real cost. **The "this is actually a story, not a battle game" moment.**

---

## 5\. Hypothesis of why this would work

Casual mobile players have a five-minute-on-the-train slot that current roguelites and idle games both fail at. Roguelites (Slay the Spire mobile, Soul Knight) demand attention and input — they're high-engagement, not coffee-break games. Idle games (AFK Arena, Cookie Run: Kingdom) demand no attention — they're notifications-as-gameplay, which feels weightless. There's a gap in the middle: light engagement, real decisions, completable session.

Capybara's bet is that the story-event card frame fills that gap. Reigns proved the card-flip rhythm holds attention with binary choices and minimal mechanics. The Capybara diff is replacing Reigns's permadeath-binary structure with a roguelite run arc \+ persistent meta layer — so a player who plays for five minutes finishes a run, dies, and has *something* (coins, talent points) to invest before tomorrow's session. The auto-combat is load-bearing: it lets the run finish in five minutes without demanding tactical attention, and the choice-card decisions carry the player-agency feel that prevents idle-game perception. The shipped reference that validates the wrapper is Cookie Run: Kingdom — proving casual players will accept "story is the wrapper, mechanic is light." Our bet is that swapping the team-building meta for run-based progression hits a player segment that wants visible per-session progress without the team-management overhead.

---

## 6\. Risks

**Single fragile assumption:**

*Western casual players will accept that the combat resolves automatically with no input, as long as the choice cards in between carry enough weight that the run feels like the **player** is making it happen.*

If the auto-combat reads as "the game is playing itself," the entire loop collapses into idle-game perception. Stage 1 bundle: *"Auto-resolved combat feels like a feature, not a flaw."* The bundle needs to score positively in the target casual-player bucket, not just in idle-game-veteran personas.

---

## 7\. Reference games

1. **Reigns** — Nerial, 2016, mobile. Tap-through story cards with binary choices. We share the card-flip rhythm and lightweight-decision tone; we don't share the swipe-left/swipe-right binary — Capybara's cards have more state and combat.  
2. **Cookie Run: Kingdom** — Devsisters, 2021, mobile. Idle-friendly with story wrapper and persistent meta progression. We share the "story is the wrapper, mechanic is light" pattern; we don't share the team-building or PvP layers.  
3. **Soul Knight** — ChillyRoom, 2017, mobile. Roguelite with weapon upgrades. We share the run-based \+ persistent-upgrade structure; we don't share the action combat — Capybara's combat is auto-resolved.

**Genre mashup formula:** Reigns × idle RPG × Slay-the-Spire-lite map (60 nodes deep)

---

## 8\. Progression

### Rest of D1 (\~5–10 min after first 60s)

- Run 1 lasts \~6 minutes, ends at day 30 to a wolf encounter the player wasn't ready for. Death screen shows: "You earned 240 coins. Spend them on weapons."  
- First weapon upgrade screen. Player upgrades their starter stick → wooden club. Visible stat-bump in tooltip.  
- Talent tree appears. One point available. Player picks "+5% attack." First "meta layer" moment.  
- Run 2 starts. Player notices the same early cards but feels stronger. Clears day 45\.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | Wooden club, one talent point spent, 2 runs done, knows the rhythm. | "I almost cleared the chapter" — the next run is one upgrade away from breaking through. |
| D3 | Cleared chapter 1\. Has 3–4 weapons unlocked, talent tree halfway. First skill build emerging. | Chapter 2 unlocks new event types and a darker tone shift. |
| D7 | Mid-chapter 2\. First "build wipe" — a high-risk witch choice ruins a run. First emotional investment. | The story is teasing a chapter 3 reveal. Talent tree feels like a real shape now. |
| D14 | Cleared chapters 1–2, mid-chapter 3\. Has tried multiple builds. | Daily login event \+ first limited-time pet drop. Slight social hook (friend leaderboards). |

---

## 9\. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, \~125 words)

```
You play a capybara. You tap "Next Day" and a story event appears: a
merchant offering you a stick for some gold, an angel offering you a
basic skill or a heal, a witch trading a magic boost for some of your
HP, a bandit hut asking you to rest or search.

Most cards are choices. Sometimes a card is combat — a fight begins
and resolves on its own in a few seconds. You watch numbers pop.

Each run is 60 tap-days. About 3–10 minutes from start to finish.
The run ends when you reach the chapter boss or wipe trying. You'll
wipe often, but it usually feels like your choices did it, not the
game.

You're not really playing a battle game. You're playing a story
where battles happen to be one of the things that occur.
```

#### Full description of core loop \+ 1 meta progression (Stage 1, optional for run-based, \~165 words)

```
You play a capybara. You tap "Next Day" and a story event appears: a
merchant offering you a stick for some gold, an angel offering you a
basic skill or a heal, a witch trading a magic boost for some of your
HP, a bandit hut asking you to rest or search.

Most cards are choices. Sometimes a card is combat — a fight begins
and resolves on its own in a few seconds. You watch numbers pop.

Each run is 60 tap-days. About 3–10 minutes from start to finish.
The run ends when you reach the chapter boss or wipe trying. You'll
wipe often, but it usually feels like your choices did it, not the
game.

Between runs, you spend what you earned on upgrades — better weapons
for your capybara, points in a talent tree — so each new run starts a
little stronger than the last.

You're not really playing a battle game. You're playing a story
where battles happen to be one of the things that occur.
```

#### Store-page variant (Stage 1b optional, \~50 words)

```
You're a capybara on an adventure. Tap your way through merchants,
angels, witches, and bandits. Make choices. Watch fights resolve.
Earn coins. Upgrade your weapons and talents between runs. Five
minutes a run, sixty days per chapter. A story where battles happen
to be one of the things that occur.
```

#### First 1–5 minutes the player experiences (\~270 words)

```
Boot-up: a soft logo, then a watercolor pan across a forest path. A
small capybara walks into frame, sits down. Text fades in: "Tap
Next Day."

The player taps. A card flips up — a merchant in a wide hat offering
a stick for 10 coins. Two buttons: Buy / Pass. The player taps Buy.
The capybara's portrait sprite gains a tiny stick. The next-day
button glows.

Tap. A combat card. The screen shifts to a side-on view: capybara on
the left, a small slime on the right. Damage numbers pop. The
capybara wins in 3 seconds. XP bar fills slightly. Card flips away.

Tap. An angel card — "Choose: +1 skill, or +20 HP." Player picks
skill. A small skill icon docks onto the loadout strip at the top of
the screen. Tap again. Another combat. Tap. A campfire card —
"Rest? +30 HP. Costs one day." Player taps yes. The day counter
ticks up by one.

By day 10, the player has made eight choices, won three fights, and
unlocked their first skill icon. By day 20, a witch appears: "Trade
half your HP for a magic boost?" The first real cost-benefit card.
The player risks it. The next fight is dramatic — they almost wipe
but win on the last hit. By day 30, an unlucky encounter ends the
run.

Death screen: "You traveled 30 days. You earned 240 coins."
Two buttons: "Upgrade" and "Try Again." The upgrade screen shows
weapons and a talent tree. The player spends. The next run starts
stronger.
```

#### D1–D14 player journey / progression description (Stage 2 input, \~360 words)

```
Day 1. The player completes 2–3 runs, dies mid-chapter-1 each time,
unlocks the wooden club and spends their first talent point. The
hook for returning tomorrow is visible: they almost cleared the
chapter boss on run 3 — one or two more upgrades away from breaking
through.

Day 2. Returning player clears chapter 1 on run 4 or 5. The first
big story beat lands — the capybara meets a recurring NPC who hints
at chapter 2's darker tone. New event types unlock: a thief card
introduces risk-of-loss, a shrine card introduces stat-buff trades.
By end of day, the player has 4 weapons unlocked and 3 talent points
spent.

Day 3. Mid-chapter-2. The player's first "build identity" emerges:
they realize their talent picks are tilting them toward magic-heavy
runs, and they start picking witch cards more aggressively. First
"I am playing this game my way" moment.

Day 5. Chapter 2 clears. The player has a stable weapon-upgrade
rhythm — runs end with predictable coin yields and predictable
upgrade choices. The risk of monotony surfaces here; the game
introduces the first pet drop as a counter-pull. A small companion
follows the capybara on the next run.

Day 7. Mid-chapter 3. First "build wipe" — a witch trade ruins a
run the player had high hopes for. Real emotional moment. The
talent tree has fully one branch unlocked; the other two branches
become the next return reason.

Day 10. Daily login event introduces a limited-time event chapter
(a side quest, 30 tap-days). New encounter art, new rewards. The
event creates a parallel goal alongside the chapter-3 push.

Day 14. The player has cleared 3 of the planned 5 chapters, has 2
pets, has tried both alternate talent branches, and has hit the
first "this run was perfect" feeling. Friend leaderboards quietly
appear — same-chapter completions ranked by tap-day efficiency.
The social hook is whisper-quiet, not aggressive.
```

### 9.2 Synthetic testing materials — Art

Run-based / story-event game. Lighter art surface than a collection game.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Single static frame mid-run: card centered on screen (a witch event), capybara portrait \+ loadout strip at top, day counter \+ coin counter visible, "Choose" buttons rendered. Must read as "tap to continue a story" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. Capybara on a winding path, key NPCs (merchant, angel, witch) lining the path as silhouettes. Cozy-watercolor aesthetic. The image that leads the store listing. |
| **Key UI frames** | TBD | (1) Card-event in-run, (2) Combat resolution view, (3) Death/run-end screen, (4) Weapon upgrade screen, (5) Talent tree, (6) Chapter select screen. No hero-collection screen — this game doesn't have one. |
| **App store icon** | TBD | 1024×1024. Capybara with a weapon, expressive face — cozy \+ adventurous reads. Tested for thumbnail readability at 88×88. |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: one playable chapter (30 tap-days, 5 event card types, auto-combat, weapon upgrade, 1 talent branch). No story beyond placeholder text, no pets, no limited-time events. Must feel-representative on a real device — the tap-rhythm is the entire game. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 30s tap-rhythm read, first major choice (witch trade), first auto-combat moment, first run-end → upgrade transition. Each scored separately at Stage 4\. |

