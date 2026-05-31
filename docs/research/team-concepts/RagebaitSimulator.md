# Ragebait Simulator — Concept Template v2

**Owner:** Concept author

---

## 1. Greenlight checklist

- [ ] Filled out Stage 1–6
- [ ] Text write-ups for SSR
      - [ ] Full description of core loop (~135 words)
      - [ ] Full description of core loop + 1 meta progression (~170 words)
      - [ ] Store-page variant (~55 words)
      - [ ] First 1–5 minutes the player experiences (~280 words)
      - [ ] D1–D14 player journey / progression description (~340 words)
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
- [ ] Publish AI Prototype on store and test D1 + number of games on D0

---

## 2. Identity

| Field | Value |
| :---- | :---- |
| Working title | Ragebait Simulator |
| Genre / subgenre | Mobile portrait chaos sandbox with crowd-manipulation core loop and city-by-city meta progression |
| Target audience | Casual teens + young adults (14–28) who love comedic chaos sandboxes and crowd-manipulation games — Goat Simulator, Hitman: Blood Money, Crowd City, Stick Fight. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

You're a chaos agent. You walk through cities, ragebaiting strangers into fighting each other. Curse a Karen, dodge as she charges, watch her ram into a cowboy, watch the cowboy pull a bat, watch the whole block descend into a brawl. As fights grow, NPCs pull bigger weapons — fists turn into bats, bats into guns, guns into RPGs. You earn chaos cash, spend it to unlock new districts with new archetypes, and push city after city into total mayhem. You're not in the fight — you're the spark. Just don't get caught in your own crossfire. You can die.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Spawn in "Stardust Plaza" — bright noon, sidewalk, ~20 visible NPCs going about their day. Title fades. Voiceover: "Provoke. Dodge. Let them sort it out." Tap to start.
- **5–15s:** Joystick + ragebait button surface. Tooltip: "Walk up to anyone. Tap to bait." Player wanders. A Karen NPC stands ahead, glowing with target-friendly highlight.
- **15–25s:** Player taps ragebait → curse animation → Karen's rage bar fills past threshold → she aggros and charges the player.
- **25–40s:** Player jukes around a cowboy NPC. Karen collides with cowboy. Cowboy's bump-annoyance fires → cowboy turns on Karen → first fistfight. **The "I made this happen" moment.**
- **40–60s:** Two more NPCs drawn in by friendly fire. Cowboy pulls a bat. Player backs off. Chaos meter fills its first segment. Objective text appears: "Push Stardust Plaza to 25% chaos."

---

## 5. Hypothesis of why this would work

Hitman: Blood Money proved Western players love social-engineering combat — the joy of orchestrating violence without directly causing it. Goat Simulator proved comedic chaos sandboxes hold attention in short bursts and dominate clip-share culture. Crowd City proved crowd-manipulation reads instantly on mobile portrait with single-thumb input.

The unmet combination is *Hitman-style indirect-violence orchestration in a Goat-Sim-tonal chaos sandbox, sized for mobile portrait casual sessions*. The bet is that the third-party-redirect mechanic — provoke someone, dodge, let them strike a stranger — turns every street into emergent comedy. Stereotype-readable archetypes make targets instantly legible, which solves the "who do I bait next" decision in under a second. Escalating weapon tiers (fist → bat → gun → RPG) give every brawl a natural crescendo. The deep-meta layer is the loadout choice (one ragebait ability per run, picked from main menu) crossed with the city's archetype mix — which makes loadout unlocks via Pack B feel like real strategic depth, not just shop fodder.

---

## 6. Risks

**Single fragile assumption:**

*Provoking strangers into hurting each other has to read as cathartic mischief, not as bullying or cruelty. The protagonist must feel like a trickster, not an asshole.*

If teen + young-adult players feel mean-spirited rather than chaotic-fun, retention collapses by D3 and clip-share — the title's natural amplification channel — never ignites. The framing safeguard stack is: comedic exaggeration in animation, ragdoll physics over gore, stereotypes-as-cartoon-caricatures rather than realistic targets, and NPC reactions that read as absurd rather than wounded. Stage 4 (gameplay video) must show the redirect-laugh beat clearly — target gets punched, comically ragdolls, springs back up, joins the brawl. The world has to feel like a cartoon, not a battery.

Secondary risk: archetype roster sensitivity. Several proposed archetypes (race-coded weapon archetypes, biased cop behavior) sit near satire-vs-offensive borderlines. Requires an explicit sensitivity review pass before the roster locks for production.

---

## 7. Reference games

1. **Hitman: Blood Money** — IO Interactive, 2006. Indirect-violence orchestration via crowd manipulation and environmental redirect. We share the redirect-rather-than-confront combat pattern; we don't share stealth or contract framing — Ragebait is overt, comedic, immediate-feedback chaos.
2. **Goat Simulator** — Coffee Stain, 2014. Comedic chaos sandbox built on ragdoll physics + escalating absurdity. We share the tonal register and the "every interaction is funny" pacing; we don't share the goofy non-human avatar — Ragebait keeps a human protagonist so the social-provocation core reads.
3. **Crowd City** — Voodoo, 2018. Mobile portrait crowd dynamics with single-thumb input on a city map. We share the crowd-as-substrate gameplay surface + mobile control scheme + city-traversal frame; we don't share the conversion mechanic — Ragebait turns crowds *against each other* rather than into followers.

**Genre mashup formula:** Hitman: Blood Money × Goat Simulator × Crowd City

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- Player pushes Stardust Plaza past the 25% chaos objective. Mission complete cinematic flashes — a wide overhead shot of the brawl spreading.
- Earns first chaos cash bundle. In-game store / district map appears.
- Adjacent district "Greendale Crossing" teased — locked behind in-game cash. New archetype previews shown (biased cop, influencer, hipster). Player buys access.
- Greendale archetypes have higher rage thresholds — curse barely registers on the tech-bro. First "I need stronger abilities" friction. Pre-run loadout screen surfaces — currently only curse owned. Pack B "Physical Pack" teased (slap, push, punch, dropkick) — first monetization touch.
- Rewarded-ad prompt offered: spawn a pre-aggroed NPC for free to seed Greendale. Player tries it, sees the loop.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | Starter city "Stardust." 1 district cleared, 1 unlocked. Curse ability owned. First chaos cash earned. | Greendale archetype tease + Physical Pack offer. |
| D3 | 3 districts cleared in Stardust. Slap unlocked via in-game progression. First battle pass tier reward claimed (cosmetic player skin). | Higher-threshold archetypes (yoga, tech-bro) blocking progress without Push/Punch. |
| D7 | Stardust ~70% chaos. Pack B vehicle considered. Pet sidekick offered as next IAP. First RPG-tier brawl witnessed. | Tier 2 city "Port Hadley" unlock (new region, new stereotype roster — soccer hooligans, drunk dock workers). |
| D14 | Two cities mostly fallen. Battle pass at tier ~25/50. Owns 1 Pack B (likely Throwables or Pet). Has tried Mini-mode Survival. | Tier 3 city tease + seasonal event modifier (e.g., "Black Friday" mall map) + cosmetic gacha pulls available. |

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~135 words)

```
You play a chaos agent walking around a city on mobile portrait.
Joystick to move, one button to ragebait. Pick your ragebait
ability from the main menu before the run — curse, slap, push,
punch, or dropkick.

Walk up to an NPC and press the button. Every action has an
annoyance value. Every NPC has a rage threshold. If your action
pushes them past it, they aggro and chase you. Dodge so they ram
into a third party. The third party gets annoyed, fights back.
Chain reaction. Bystanders pile in. Bats come out. Then guns. Then
RPGs.

Earn chaos cash from the mayhem. Spend it to unlock the next
district of the city. Each district has its own archetype mix —
Karens, cowboys, biased cops, tech-bros, yoga moms — each with
different rage thresholds.

Complete objectives: kill the target, destroy the building, wipe
the faction. Don't get caught in the crossfire. You can die.
```

#### Full description of core loop + 1 meta progression (Stage 1, genre-required, ~170 words)

```
You play a chaos agent walking around a city on mobile portrait.
Joystick to move, one button to ragebait. Pick your ragebait
ability from the main menu — curse, slap, push, punch, or
dropkick. Only one per run.

Walk up to an NPC and tap. Every action has an annoyance value.
Every NPC has a rage threshold. Cross it, they aggro. Dodge so
they hit a third party. Chain reaction. Bystanders pile in. Bats
become guns. Guns become RPGs.

Earn chaos cash. Spend it to unlock the next district. Each
district has a different archetype mix with different rage
thresholds. Complete objectives — kill the target, destroy the
building, wipe the faction. Don't get caught in your own
crossfire.

Meta progression: the more cities you collapse, the more ragebait
abilities, archetypes, and districts unlock. Each city is a fresh
stereotype roster from a different region. Loadout choice matters
— some archetypes ignore weak provocations. Permanent Unlock
Packs add new abilities, pets, vehicles, and disguises. A seasonal
Battle Pass layers cosmetic player skins, archetype reskins, and
limited-time chaos event modes on top.
```

#### Store-page variant (Stage 1b optional, ~55 words)

```
Walk into a city. Ragebait strangers. Dodge their fists into a
third party. Watch the whole block explode. Earn chaos cash.
Unlock new districts. New archetypes — Karens, cowboys, cops,
hipsters. Bats become guns. Guns become RPGs. Push every city
into total chaos. Just don't get caught in your own crossfire.
```

#### First 1–5 minutes the player experiences (~280 words)

```
Boot-up: studio logo. Slow camera pan across "Stardust Plaza" — a
bright noon city block, ~20 NPCs walking, eating, arguing on
sidewalks. Voiceover: "Provoke. Dodge. Let them sort it out." Tap
to start.

Loadout screen flashes briefly. Only the curse ability is
unlocked. Player auto-equips it. Confirm.

Drop into the plaza. Dual-thumb HUD: left joystick, right ragebait
button. Tooltip: "Walk up to anyone. Tap to bait." Player wanders
forward. A Karen NPC stands ahead with a soft glow — first
suggested target.

Player walks up. Taps ragebait. Curse animation plays. Karen's
rage bar fills past threshold. She turns red, aggros, charges the
player. Tooltip: "Now dodge into someone else."

Player jukes around a cowboy NPC. Karen collides with the cowboy.
Cowboy bump-annoyance fires past his threshold. He turns on
Karen. First fistfight. The player watches from a few feet away.

Two bystanders walk too close. One catches a stray punch. Now
three are fighting. The cowboy pulls a bat. The chaos meter on
the HUD fills its first segment. Objective text fades in: "Push
Stardust Plaza to 25% chaos."

Player baits two more NPCs. Brawl spreads. A biased cop spawns,
walks past the white tech-bro, beelines for the cowboy. Player
laughs. Cop pulls a pistol. First gunfire. Player backs out of
line of fire — tooltip warns: "Don't get caught in the
crossfire."

Brawl size hits chaos threshold. Mission complete cinematic — a
wide overhead shot of the spreading mayhem. Chaos cash reward
pops. District map opens. Greendale Crossing is locked but
visible — new archetype silhouettes glow behind the paywall.
Player taps to unlock with earned cash.
```

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

```
Day 1. Player drops into Stardust Plaza, clears the first 25%
chaos objective, watches a Karen-cowboy-cop chain reaction
unfold. Earns first chaos cash bundle. Unlocks adjacent district
Greendale Crossing. Returns tomorrow because Greendale's
archetype previews showed a biased cop and a tech-bro they
haven't ragebaited yet.

Day 2. Player runs 2–3 missions in Greendale. Tech-bros ignore
the curse — the player hits their first real threshold wall.
First Pack B "Physical Pack" prompt surfaces. They decline, push
through with crowd manipulation instead. First "I need a louder
ability" moment.

Day 3. Player unlocks slap via in-game progression in Greendale.
Adds first ragebait variety to loadout choices. Claims first
battle pass cosmetic — a tourist-skin player avatar. The
named-customization layer kicks in for the first time.

Day 5. Yoga-mom archetype shows up in a new Stardust district.
Threshold is brutal — only dropkick reliably bait works on them.
Player buys Pack B "Physical Pack" or Mini-mode Pack with real
money. First conversion event.

Day 7. Stardust ~70% chaos. First RPG-tier brawl seen. Player
watches an entire district level itself. Pet sidekick (Pack B
chihuahua) offered as next IAP. Tier 2 city "Port Hadley"
teased — new biome, soccer-hooligan and dock-worker archetypes
visible.

Day 10. Player completes Stardust. Migrates to Port Hadley.
Loadout meta sharpens — they realize hooligans bait fast on push
but ignore curse entirely. They restructure their pre-run
ability pick around the city's archetype mix. First evidence the
meta is real depth, not flavor.

Day 14. Player has cleared Stardust and most of Port Hadley.
Battle pass at tier ~25/50. Owns one or two Pack B unlocks
(likely Throwables and/or Pet). Has tried Survival Mini-mode at
least once. Tier 3 city tease pops — a new region with a fresh
stereotype roster. A seasonal modifier event ("Black Friday"
mall map) is live with limited-time cosmetic rewards. The
return-reason stack is now layered: city progression, ability
unlocks, battle pass tiers, seasonal event, cosmetic completion,
loadout-meta strategy.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a portrait mobile chaos sandbox.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Two candidate frames: (A) third-person-ish overhead view of player mid-curse on a Karen with two bystanders watching, chaos meter HUD top, joystick + ragebait button bottom-right. (B) wide brawl shot — 15+ NPCs across stereotype archetypes mid-fight, bats and pistols out, player character backing away from a stray RPG arc, breach-style chaos meter at 80%. Both must read as "mobile portrait + crowd chaos + stereotype-legible" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. Player character mid-shrug in foreground; behind them, a stylized city block exploding into a multi-archetype brawl — Karen mid-scream, cowboy mid-swing, cop mid-draw, hipster running away. Comedic exaggeration, cel-shaded or low-poly, slapstick over gore. |
| **Key UI frames** | TBD | (1) Main-menu ragebait ability loadout picker, (2) In-mission HUD with chaos meter + objective text + joystick/button, (3) District map with locked/unlocked tiles + cost in chaos cash, (4) Battle pass tier screen, (5) Pack B store screen with the 7 example IAP packs, (6) End-of-mission chaos summary (brawl size, kills, cash earned). |
| **App store icon** | TBD | 1024×1024. Player character holding up a megaphone or rude-gesture pose with a comedic explosion of stereotype-silhouetted NPCs behind. Tested for thumbnail readability at 88×88 — must read as "chaos / city / comedy" not as "generic fighter." |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: one starter city, one district (Stardust Plaza), one ragebait ability (curse), three archetype types (Karen, cowboy, biased cop), weapon escalation from fists → bats → pistols (RPG tier omitted for proto), one objective ("push district to 25% chaos"), portrait orientation, joystick + ragebait button. ~40 NPCs visible at peak. Must feel-representative on a real device — the redirect-laugh moment is the central pillar. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 15s player walks up and curses a Karen, Karen charges, player redirects into cowboy → first chain reaction, brawl scales and bat tier appears, mission-complete cinematic with chaos summary. Each beat scored separately at Stage 4. |
