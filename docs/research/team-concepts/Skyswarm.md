# Skyswarm — Concept Template v2

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
| Working title | Skyswarm |
| Genre / subgenre | Vertical 3D parkour horde-shooter roguelite (Vampire-Survivors-meets-Mirror's-Edge) |
| Target audience | Mid-core mobile players (13–40) who love horde shooters (Vampire Survivors, Brotato) AND 3D parkour escape feel (Mirror's Edge, Ghostrunner) and want a 3D-vertical Survivors that feels skill-expressive. |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

You're a tiny chibi courier with floating-sphere hands and feet running across the rooftops of a procedurally-generated metropolis. The streets below are flooded with non-lethal "static plague" zombies. You aim your finger; the chibi figures out the verb — runs, vaults, wall-runs, ledge-grabs, window-dives, crane-swings — all from one input. Your weapons auto-fire. XP gems suck in. Every level you pick a perk. Stack weapons and parkour upgrades into a build. Survive 8–15 minutes across 5 districts to the city center. Cute, fast, vertical, never grim.

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** Drop-pod cinematic onto a pastel rooftop at sunset. Chibi courier lands, sphere-arms jiggle. "Deliver the cure-canister." Tap to start.
- **5–15s:** Tutorial: touch screen, drag direction. Chibi runs forward, leg-spheres splay. First auto-jump impulse: chibi vaults to a lower rooftop.
- **15–25s:** First zombie wave — a small group of shamblers below. Chibi auto-fires a starter pistol; gems pop. Player drags toward a glowing purple wall-strip. Auto wall-run.
- **25–40s:** Level up. Three cards: "+15% fire rate," "Vault speed +20%," "Slide-shoot." Player picks Slide-shoot.
- **40–60s:** Player runs toward a low pipe. Auto-slide. Slide-shoot triggers — bullets spray under the pipe at a horde rushing in. **The "I'm playing a parkour build, not just steering" moment.**

---

## 5. Hypothesis of why this would work

Vampire Survivors / Brotato proved the Survivors-genre's massive Western mobile audience. The genre's bottleneck is that *every successful clone is 2D top-down*. No one has cracked a true 3D vertical Survivors. Meanwhile, Mirror's Edge / Dying Light / Ghostrunner proved parkour-as-routing has an evergreen fan base that mobile has never served. The unmet combination is *3D vertical horde + parkour routing + auto-fire weapons + Survivors meta*.

The bet is that *parkour upgrades are build resources* — wall-run duration, slide-shoot, kick-vault — interleave with weapon evolutions to create a much larger build space than 2D Survivors. The skill ceiling is route-finding under pressure rather than aim or button-mashing, which means the input contract stays mobile-friendly. The shipped reference is Vampire Survivors mobile (4M+ players) — proving the auto-fire + level-up draft template ports. Our diff is the 3D vertical world and the auto-everything single-touch parkour, which gives Skyswarm a marketing silhouette no other Survivors clone has.

---

## 6. Risks

**Single fragile assumption:**

*The "single-touch direction-only" parkour contract — where the chibi auto-jumps, auto-wall-runs, auto-grabs, auto-slides from one drag input — will feel like *the player's parkour*, not like a cutscene. The skill must feel expressive even though the player has no button presses.*

If the auto-parkour reads as "the game is doing the parkour for me," players churn at the first wall-run sequence because there's no perceived skill expression. Stage 1 bundle: *"The chibi feels like an extension of my finger, not an AI doing tricks at me."* Stage 4 (gameplay video) tests this with a long take of route-choice and parkour chaining under horde pressure — the player's *choices* of where to point have to be visibly impactful.

---

## 7. Reference games

1. **Vampire Survivors / Brotato (mobile)** — poncle / Blobfish. Auto-fire + level-up draft + horde roguelite. We share the meta and per-run build-stack pattern; we don't share top-down 2D — Skyswarm is 3D vertical.
2. **Mirror's Edge / Ghostrunner** — DICE / One More Level. First/third-person parkour traversal. We share the parkour-as-routing fantasy and the rooftop silhouette; we don't share manual button-press parkour — Skyswarm is auto-parkour from direction input.
3. **20 Minutes Till Dawn / Survivor.io** — flanne / Habby. Mobile horde shooters with strong meta. We share the auto-fire + meta-progression layer and the mobile session length; we don't share the top-down camera.

**Genre mashup formula:** Vampire Survivors × Mirror's Edge × Ghostrunner (auto-parkour mobile)

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

- Run 1 dies in Lowtown at minute 6 to a swarm overrun. Run-end loot: Scrip + 1 Common equipment item (Head).
- Loadout screen: player equips the Head item ("Runner Goggles," +ledge-grab range).
- First weapon upgrade purchase with Scrip (+1 rank on the starter pistol).
- Run 2 reaches Industrial Belt and clears the first mini-boss. First "I made a build" moment.

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
| :---- | :---- | :---- |
| D1 | 1 chibi, 2 weapons, 1 Head item equipped, ranks 1–2 on starter weapon. | First mini-boss visible at Industrial Belt; second chibi tease. |
| D3 | 2 chibis unlocked, 3 weapons, 4 equipment items, ranks 3–5 on favorites. | Spire Heights district teased. New chibi (Vault Specialist) feels distinct. |
| D7 | All 5 districts visited once. First Legendary equipment dropped. | Apex (center boss) attempted. Equipment affix re-roll teased. |
| D14 | 4 chibis, 8 weapons leveled, Apex defeated once. | Daily challenge rotation + replay-clip share + Legendary affix re-rolls. |

---

## 9. Deliverables

### 9.1 Synthetic testing materials — Design (text)

#### Full description of core loop (Stage 1 required, ~135 words)

```
You drop a tiny chibi courier with floating-sphere hands and feet
into a pastel rooftop metropolis. The streets below are flooded
with "static plague" zombies — slow, surprised-looking, non-grim.
You're delivering cure-canisters across the city.

You touch the screen anywhere. A floating virtual stick appears.
You drag to set direction. That's the whole input. Your weapons
fire automatically. The chibi auto-jumps off ledges, auto-wall-
runs into wall surfaces, auto-vaults railings, auto-grabs ledges,
auto-slides under pipes, auto-window-dives through glass, auto-
swings on crane hooks — all triggered by direction + speed +
proximity.

XP gems drop from zombies and vacuum toward you. Every level you
pick one of three perks: weapon evolutions, parkour upgrades,
passives. Stack them into a build.

A run is eight to fifteen minutes.
```

#### Full description of core loop + 1 meta progression (Stage 1, genre-required, ~170 words)

```
You drop a tiny chibi courier with floating-sphere hands and feet
into a pastel rooftop metropolis. The streets below are flooded
with non-lethal zombies. You're delivering cure-canisters.

You touch the screen anywhere. A floating virtual stick appears.
You drag to set direction. That's the whole input. Weapons auto-
fire. The chibi auto-jumps, auto-wall-runs, auto-vaults, auto-
grabs ledges, auto-slides, auto-window-dives, auto-crane-swings —
all triggered by direction + speed + proximity to traversal
anchors.

XP gems drop and vacuum. Every level you pick one of three perks
— weapon evolutions, parkour upgrades, passives.

A run is eight to fifteen minutes across five districts to a
center-skyscraper final boss.

Outside runs, you unlock new chibis (8 at launch, each with a
parkour signature) and new weapons. Per-weapon and per-character
upgrade ladders persist. Equipment drops on run-end — Head, Body,
Trinket slots with rarity tiers and affixes. Duplicate equipment
dismantles into crafting dust for affix re-rolls. Daily challenges
rotate.
```

#### Store-page variant (Stage 1b optional, ~55 words)

```
You're a tiny chibi courier with sphere-arms running rooftops
across a flooded zombie city. Aim your finger — the chibi figures
out the verb. Wall-runs, ledge-grabs, window-dives, crane-swings,
auto-fire weapons. Eight-to-fifteen-minute runs across five
districts. Cute, fast, vertical, never grim. Vampire Survivors
meets Mirror's Edge.
```

#### First 1–5 minutes the player experiences (~280 words)

```
Boot-up: a punchy synthwave intro, drop-pod cinematic onto a
pastel rooftop at sunset. The chibi lands — sphere-hands and feet
jiggle on impact. A friendly UI tooltip: "Deliver the cure-
canister. Touch and drag." Tap to start.

Player touches the screen. A floating stick appears under their
thumb. They drag forward. The chibi sprints. Leg-spheres splay
visibly. The starter pistol auto-fires; a low-density shambler
horde scatters on the street below.

Player drags toward the rooftop edge. The chibi auto-jumps to a
lower rooftop. Tooltip: "Drag toward walls to run them." Player
drags into a purple-highlighted wall strip. Chibi auto wall-runs
along the surface, inside hand-sphere skimming the wall with a
particle trail.

A small swarm of XP gems appears below. Player drops off the wall-
run, descends, the auto-jumps land the chibi on a low rooftop.
Gems vacuum in. Level-up modal: three cards — "+15% fire rate,"
"Vault speed +20%," "Slide-shoot." Tooltip highlights Slide-shoot.
Player taps.

Wave 2 begins. The chibi runs forward toward a low pipe. Auto-
slide engages — the chibi slides under, slide-shoot triggers, a
spray of bullets clears the horde.

By minute 4, the chibi has crane-swung once, window-dived through
a billboard, and triggered 6 level-ups. The first district mini-
boss (Lowtown's siege-zombie) emerges at a handcrafted rooftop
arena. Player kites it across the rooftops, build coming together.

Minute 6: the player gets overrun by a screamer-triggered horde.
Run ends. Run-summary screen: Scrip earned + 1 Common Head item
dropped. Loadout screen opens. Player equips Runner Goggles
(+ledge-grab range). New run loads.
```

#### D1–D14 player journey / progression description (Stage 2 input, ~340 words)

```
Day 1. The player completes 3–4 runs, dies in Lowtown twice and in
Industrial Belt once, picks up 2 Common equipment items, and
spends Scrip on starter-weapon rank 2. They've drafted across 15+
perks and they've felt the auto-parkour click on the third run.
The hook for returning tomorrow is the visible meta-vault — they
can see the locked roster of 8 chibis, only 1 unlocked.

Day 2. Returning player runs 3 more runs. Industrial Belt clears
for the first time on run 6 — the first mini-boss falls. They
earn City Tokens (rare currency). Vault Specialist chibi unlocks.
They try her on the next run; her +25% vault speed visibly changes
their preferred route — they vault more rails, wall-run less. First
"the chibi is the build" moment.

Day 3. Skyline Mid attempted. The taller buildings + sky bridges
shift the gameplay — wall-runs are longer, window-dives become a
viable shortcut. Player gets their first Rare equipment item
(Trinket, "Wall-Run Damage Stacks"). First build-warping moment.

Day 5. Daily challenge unlocks: "Clear Lowtown without touching
the ground." Player attempts it 3 times. Clears it. Reward:
guaranteed Rare equipment drop + City Tokens.

Day 7. Spire Heights cleared. First Legendary equipment drop (a
Body vest with +max HP + revive-once-per-run). Apex (final boss
district) attempted but the giant siege-class zombie wipes the
run.

Day 10. 4 chibis unlocked. Player has a clear preference (Long
Jumper — auto-jump horizontal carry + bow affinity). They're at
rank 6 on the bow weapon, hunting for the rank 8 evolution-tag
unlock.

Day 14. Apex defeated once. 4 chibis fully equipped with cross-
character itemization. Crafting Dust is accumulating, used for
affix re-rolls on the player's best Legendary. The dominant
return reasons stack: daily challenge rotations, City Token saves
toward chibi #5, equipment affix-chase, weapon-rank ladders, and
replay-clip sharing on social — the parkour highlights inherently
make shareable clips.
```

### 9.2 Synthetic testing materials — Art

Genre-conditional set for a 3D parkour horde-shooter.

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Mockup of gameplay screen** | TBD | Single static frame mid-run: chibi mid-wall-run across a midrise window-line, sphere-hand trailing particles, weapons auto-firing at a swarm of cherry-eye zombies below, XP gems scattered, HUD with weapon icons top-left + run timer top-right. Saturated pastel-neon palette. Must read as "3D vertical parkour horde-shooter" in 2 seconds. |
| **Key art** | TBD | Marketing hero shot. Chibi mid-jump between two pastel rooftops at sunset, zombie horde climbing scaffolding below, glittery mint-green XP gems mid-vacuum. Stylized, never grim. |
| **Key UI frames** | TBD | (1) Gameplay HUD mid-run, (2) Level-up perk modal, (3) Run-end loot drop screen, (4) Loadout screen (character + weapon + equipment), (5) Character / weapon upgrade ladder, (6) Daily challenge select. |
| **App store icon** | TBD | 1024×1024. A single chibi mid-wall-run, sphere-hand splayed, bright pastel-purple wall-strip behind. Tested for thumbnail readability at 88×88 — must read as "cute parkour zombie shooter" not "shooter" alone. |

### 9.3 Playable prototype

| Artifact | Status | Notes |
| :---- | :---- | :---- |
| **Playable prototype** | TBD | Scope: 1 chibi (Runner) with the procedural sphere-rig, 1 hand-built test district (Lowtown), 3 zombie variants (shambler, sprinter, screamer), 3 weapons + 1 evolution path, full parkour state machine (wall-run, ledge-grab, vault, slide, window-dive, crane-swing), perk roller, basic run-end loot screen with 1 equipment type. No procedural metropolis, no meta vault. Must feel-representative on a real device — the single-touch direction-only parkour contract is the entire pitch. |
| **Gameplay video (30–90s, beat-sliced)** | TBD | Cut from prototype. Four beats: first 30s touch+drag → first auto-wall-run + auto-vault chain, first perk pick, first mini-boss arena engagement, first death → run-summary → equipment loot. Each scored separately at Stage 4. |
