# BALL x PIT — Roguelike Abilities Reference

**Companion to:** `DESIGN_DOC.md` (which only sketches the evolution system at a high level)
**Scope:** Every in-run, player-facing choice — **special balls, evolved balls, fused balls, passives, evolved passives, status effects, and the Fusion Reactor pickup** — and how each one mutates moment-to-moment gameplay.
**Date:** 2026-05-20
**Primary sources:** `Web Sources/ballxpit.wiki.gg/Balls.md`, `Web Sources/ballxpit.wiki.gg/Passives.md`, `Web Sources/ballpit.fandom.com/Fusion_Reactor.md`, `Web Sources/dexerto.com/all-evolution-recipes.md`, `Web Sources/dexerto.com/passive-tier-list.md`, `Web Sources/steam_community/guide_3587888441.md` (K708 "All Evolutions").

---

## 0. How the roguelike layer is shaped

Inside a single ~15-minute run, the player owns exactly **8 active loadout slots**:

| Slot block | Count | What goes here |
|---|---|---|
| **Special Ball slots** | 4 | The player-controllable, ricocheting "weapons." Each can be levelled 1 → 2 → 3. |
| **Passive slots** | 4 | Always-on modifiers (defense, crit, summons, scaling, healing). Each can be levelled 1 → 2 → 3. |

Baby Balls (small white projectiles) are a separate, **always-on** background system spawned by various sources; they do not occupy a slot.

Three kinds of pick-event during the run:

1. **Level-up panels** — every few seconds the player gains XP and the screen splits: the left half shows **3 random offers** (a new ball, a new passive, or a level-up to one already owned). The right half stays live — you must keep dodging while choosing. **[VID:Jbz1Obo82cg / VID:nkRcLrAQjsA]**
2. **Fusion Reactor pickups** — a rainbow yin-yang orb that materializes mid-run (see §6). Opens a menu offering **Fission, Fusion, or Evolution** of what you already own.
3. **First-clear and Encyclopedia unlocks** — clearing each layer for the first time permanently adds new balls and passives to your pool of possible level-up offers in future runs (see §7).

Once all 4 ball slots are full, the only ways to add more balls are to **fuse** two existing level-3 balls into one (freeing a slot) or **evolve** specific level-3 pairs into named Evolved Balls.

---

## 1. Status effects — the verb library

Every ball and many passives reference one or more of these. They stack independently and interact (Hemorrhage consumes Bleed; Frostburn = Burn+Freeze; Radiation amplifies all incoming damage).

| Status | What it does | Sources (examples) |
|---|---|---|
| **Bleed** | Stacks (max 8). Each bleeding enemy takes +1 damage per stack on every subsequent hit. | Bleed ball, Hemorrhage, Leech, Sacrifice, Vampire Lord |
| **Burn** | Stacks (max 3–5). DoT per stack per second; lasts 3–6 s. | Burn ball, Sun, Inferno, Magma, Brimstone, Satan |
| **Freeze** | Stops enemies for a fixed duration; frozen enemies take **+25% damage**. | Freeze ball, Blizzard, Wraith, Glacier, Freeze Ray, Timestop |
| **Frostburn** | Burn + Freeze hybrid: DoT per stack and **+25% damage** taken from all sources. | Frozen Flame |
| **Poison** | Stacks DoT per second; long duration. | Poison ball, Virus, Brimstone, Swamp, Noxious |
| **Disease** | Like poison but contagious — each second has a 15% chance to spread to nearby enemies. | Virus |
| **Venom** | Hybrid poison that also slows. | Venom |
| **Radiation** | Stacks (max 5). Each stack = **+10% damage taken from every source** — game's strongest debuff. | Nuclear Bomb, X Ray, Radiation Beam |
| **Curse** | Marks enemy; after N hits, detonates for a flat burst. | Phantom, Banshee, Sacrifice, Incubus |
| **Charm** | Enemy walks toward your back-wall and attacks its allies. | Charm ball, Incubus, Succubus, Lovestruck |
| **Berserk** | Enemy deals AoE damage to its own neighbours. | Berserk, Satan |
| **Lovestruck** | When a Lovestruck enemy attacks, 50% chance to heal **you** for 5. | Lovestruck |
| **Blind** | Enemies have a hard time detecting you and have 50% miss chance on attacks. | Light ball, Sun, Flash, Sandstorm, Laser Beam |
| **Slow** | Movement-speed reduction. | Wind ball, Swamp, Venom, Hand Fan |
| **Lifesteal** | Sap chance: steal HP on hit, debuff their attack. | Vampire, Soul Sucker, Heart Swallower, Mosquito King |
| **Heal** | Direct HP gain on certain triggers. | Vampire, Vampire Lord, Lover's Quiver, Reaper |
| **Instant Kill** | Outright deletes a non-boss enemy. | Black Hole, Reaper, Deadeye's Impaler, Odiferous Shell, Tormenter's Mask, Voodoo Doll |
| **Time Snare / Timestop** | Local or global pause on enemy movement. | Time ball, Timestop, Time Bomb |
| **Overgrowth** | Stacks to 3 → AoE burst. | Overgrowth |
| **Darkflame** | Stacks decaying Burn variant; pops for big damage when it ends. | Banished Flame |
| **Leech** | A leech parasite that auto-applies Bleed per second. | Leech |
| **Infest** | Enemy explodes into baby balls on death. | Maggot |
| **Baby Ball Spawn** | Triggers extra Baby Ball spawns (passive multiplier of your background DPS). | Brood Mother, Egg Sac, Spider Queen, Catapult, Shotgun, Voluptuous Egg Sac |
| **Attack Down** | Reduces enemy outgoing damage. | Soul Sucker, Heart Swallower |

> **[INFERRED]** This list of ~22 status keywords is the "verb library" the entire ball/passive system riffs on. Evolution recipes almost always combine two complementary verbs — Bleed+Iron → "consume bleed for % HP," Burn+Freeze → "Frostburn that does both," Poison+Cell → "Virus that spreads."

---

## 2. Stats touched by abilities

Balls and passives ultimately push the same 11 derived stats listed in DESIGN_DOC §4.1:

- **HP** — Vampiric Sword, Lover's Quiver, Reaper, Soul Reaver, Everflowing Goblet
- **Base Damage** — Hourglass, Sword Breaker, Iron Onesie, Silver Bullet, Wagon Wheel, Upturned Hatchet
- **Baby Ball Count / Damage** — Baby Rattle, Bandage Roll, Bottled Tornado, Cornucopia, War Horn, Turret
- **Ball Speed** — Radiant Feather, Rubber Headband, Wings of the Anointed
- **Move Speed** — Fleet Feet, Wings of the Anointed
- **Crit Chance** — 4× Hilted Daggers, Reacher's Spear, Silver Blindfold, Deadeye's Cross
- **Crit Damage / Effect** — Deadeye's Amulet, Gracious Impaler, Deadeye's Impaler
- **Fire Rate** — Shortbow
- **AoE Power** — Magic Staff
- **Status Effect Power** — implicitly boosted by evolutions that compound a verb
- **Passive Power** — meta scaling that affects Effigies, Turret, Gemspring tick rates

---

## 3. The 20 Base Balls (full catalogue)

All sourced from `ballxpit.wiki.gg/Balls.md`. "Unlock" = how the ball enters your pool of possible level-up offers. **Starter character** = the character who begins each run with this ball already equipped.

### 3.1 Bleed family

| Ball | What it does | Starter | Unlock |
|---|---|---|---|
| **Bleed** | Inflicts 2 stacks of Bleed; bleeding enemies take **+1 dmg per stack** on every subsequent hit (max 8). | Warrior, False Messiah | Default |

**How it changes play:** every ball you own becomes a slightly stronger version of itself against any target you've already shot once. Stacks with crit (more total hits = more bleed application). Cornerstone of Hemorrhage / Vampire Lord / Leech / Sacrifice builds.

### 3.2 Burn family

| Ball | What it does | Starter | Unlock |
|---|---|---|---|
| **Burn** | 1 stack of Burn on hit for 3 s (max 3); 4–8 dmg per stack per second. | Itchy Finger | Default |

**How it changes play:** DoT scaling that punishes enemies that survive multiple hits. Itchy Finger's 11.95 fire rate makes burn stacks trivial to keep capped. Gateway to Inferno (AoE Burn), Sun (screen Burn+Blind), Magma (lava puddles), Satan (max-stack Burn+Berserk).

### 3.3 Crowd-control balls

| Ball | What it does | Starter | Unlock |
|---|---|---|---|
| **Freeze** | 4% chance to freeze for 5 s; frozen enemies take **+25% dmg**. | Repentant | Default |
| **Charm** | 4% chance to charm for 5 s; charmed units walk up and attack their own side. | Carouser | Clear HEAVENLYxGATES |
| **Light** | Blinds on hit for 3 s; blinded units have 50% miss chance and can't detect you well. | Physicist | Clear LIMINALxDESERT |
| **Wind** | Passes through enemies and slows them 30% for 5 s; deals **25% less** direct damage. | Radical | Default |

**How they change play:** these aren't damage-first — they're tempo controllers that make the survival side of the run easier. Freeze + Iron / Earthquake → Wraith / Blizzard / Glacier. Charm + Dark → Incubus (cursed crowd manager). Light is the only universal Blind source and gates Silver Blindfold (+20% crit on blinded).

### 3.4 Poison / disease

| Ball | What it does | Starter | Unlock |
|---|---|---|---|
| **Poison** | 1 stack on hit (max 5); 1–4 dmg per stack per second for 6 s. | Embedded | Default |

**How it changes play:** the "DoT that scales with shots taken, not damage dealt." Has the deepest evolution tree of any single ball — Poison + (Ghost/Cell) = Virus (spreading disease), Poison + Bomb = Nuclear Bomb (radiation), Poison + Earthquake = Swamp (slowing tar), Poison + Freeze = Venom (slow + DoT), Poison + Wind/Dark = Noxious (AoE poison cloud).

### 3.5 Single-target / damage-mod balls

| Ball | What it does | Starter | Unlock |
|---|---|---|---|
| **Iron** | Deals double damage but moves **40% slower**. | Shieldbearer, Tactician | Default |
| **Stone** | Initially deals **300% damage**; erodes 40% per hit (min 50%). | — | Clear SNOWYxSHORES |
| **Dark** | Deals **3× damage** but self-destructs after hitting an enemy; 3 s cooldown. | Shade | Clear BONExYARD |

**How they change play:** these are **first-hit assassins** — Iron rewards careful aim, Stone front-loads damage onto the toughest target on the field, Dark is a guaranteed nuke per cooldown window. Iron is also the structural enabler for most "heavy" evolutions (Bomb, Hemorrhage, Steel, Shotgun, Assassin, Lightning Rod). Dark unlocks four evil-themed evolutions (Sacrifice, Phantom, Incubus, Banished Flame, Black Hole).

### 3.6 AoE / line balls

| Ball | What it does | Starter | Unlock |
|---|---|---|---|
| **Earthquake** | 5–13 AoE damage in a 3×3 square. | Sisyphus, Tunneller | Default |
| **Lightning** | 1–20 dmg to up to 3 nearby enemies (chain). | Juggler, Falconer | Default |
| **Laser (Horizontal)** | 9–18 dmg to all enemies in the **same row**. | Tiptoer | Default |
| **Laser (Vertical)** | 9–18 dmg to all enemies in the **same column**. | Cogitator | Default |

**How they change play:** these define the screen-clear axis. Two lasers = **Holy Laser** (row AND column), Laser+Light = **Laser Beam** (Blind beam), Holy + Beam = **X Ray** (X-shaped Radiation laser). Earthquake is the underdog: it's required for Magma, Swamp, Glacier, Landslide, Overgrowth, Sandstorm. Lightning is the cleanest of the four for new players (chain damage with no positional thinking required).

### 3.7 Baby-ball amplifiers

| Ball | What it does | Starter | Unlock |
|---|---|---|---|
| **Brood Mother** | 25% chance to spawn a Baby Ball on each enemy hit. | Cohabitants | Default |
| **Egg Sac** | Explodes into 2–4 Baby Balls on enemy hit; 3 s cooldown. | Flagellant | Default |
| **Cell** | Splits into a clone on hit, up to 2 times. | — | Clear FUNGALxFOREST |

**How they change play:** these scale your **background DPS** — Baby Balls already do chip damage; these turn the screen into a swarm. Brood Mother + Egg Sac = **Spider Queen** (Egg Sacs on hit), Brood Mother + Vampire = **Mosquito King** (homing mosquitos that lifesteal), Brood Mother + Cell = **Maggot** (infested corpses pop into Baby Balls). Cell is unique — it doubles your shots without needing a slot, so it's a force-multiplier on any ball it joins.

### 3.8 Niche / exotic balls

| Ball | What it does | Starter | Unlock |
|---|---|---|---|
| **Ghost** | Passes through enemies. | Empty Nester | Default |
| **Vampire** | 4.5% chance to heal 1 HP on hit. | Spendthrift | Default |
| **Time** | Explodes into a Time Snare on enemy hit, freezing anyone inside for 20 s. | — | **?** (uncatalogued) |

**How they change play:** Ghost is a piercing tool — required for Phantom, Wraith, Heart Swallower, Soul Sucker. Vampire is a defensive damage ball that gates Mosquito King, Vampire Lord, Succubus. Time is the rarest base ball and the catalyst for Timestop (Time+Freeze), Time Bomb (Time+Bomb), Warp (Time+Light), Erosion (Time+Wind).

---

## 4. The 59 Evolved Balls (by recipe family)

Evolution requires **two specific level-3 balls** (sometimes three for Nosferatu) and is performed at a Fusion Reactor pickup. Evolutions are deterministic — same recipe always yields the same Evolved Ball. The unlock is permanent (added to Encyclopedia).

> Some Evolved Balls **further evolve** (marked **→**). Maximum chain depth observed: 3 (Vampire Lord → Nosferatu after picking up Spider Queen & Mosquito King; Holy Laser → X Ray with Laser Beam; Bomb → Nuclear Bomb with Poison or Time Bomb with Time; Shotgun → Sniper with Assassin).

### 4.1 Bleed-centric evolutions

| Evolved Ball | Recipe | Effect |
|---|---|---|
| **Vampire Lord** | Bleed + Vampire (or Bleed + Dark) | 3 stacks Bleed; **at ≥10 stacks consumes all and heals 1 HP**. → Nosferatu (with Spider Queen + Mosquito King). |
| **Hemorrhage** | Bleed + Iron | 3 stacks Bleed; at ≥12 stacks **consumes all to deal 20% of current HP**. The premier executor ball. |
| **Leech** | Bleed + Brood Mother | Attaches a leech that auto-applies 2 stacks of Bleed per second (max 24). Bleeds without you firing. |
| **Sacrifice** | Bleed + Dark | 4 stacks Bleed + Curse. Cursed enemies take 50–100 after 5 hits. |
| **Berserk** | Bleed + Charm (or Burn + Charm) | 30% chance enemies go berserk for 6 s, hitting their neighbours for 15–24 dmg/s. |
| **Heart Swallower** | Bleed + Ghost | 40% lifesteal chance + attack-down on enemies hit. → Reaper (with Soul Sucker). |

### 4.2 Burn-centric evolutions

| Evolved Ball | Recipe | Effect |
|---|---|---|
| **Inferno** | Burn + Wind (or Burn + Time) | 1 stack Burn per second to all enemies within 2-tile radius — AoE pulse. |
| **Sun** | Burn + Light | Blinds **all** visible enemies and adds 1 stack Burn per second (max 5). → Black Hole (with Dark or Time). |
| **Magma** | Burn + Earthquake | Lava blobs over time; 15–30 dmg + Burn to anyone who walks in. |
| **Brimstone** | Burn + (Stone or Poison) | Pulses Burn + Poison to a 2-tile radius. Dual DoT. |
| **Bomb** | Burn + Iron | 150–300 AoE damage on hit; 3 s CD. → Nuclear Bomb (+ Poison) or Time Bomb (+ Time). |
| **Frozen Flame** | Burn + Freeze | **Frostburn** — 8–12 dmg per stack per second AND **+25% dmg taken**. |
| **Fireworks** | Burn + Egg Sac | Explodes into 3–6 fireworks that target random enemies and apply Burn. |
| **Banished Flame** | Burn + Dark | Darkflame DoT that pops for 1–100 burst when it expires. |

### 4.3 Freeze-centric evolutions

| Evolved Ball | Recipe | Effect |
|---|---|---|
| **Blizzard** | Freeze + (Wind or Lightning) | Screen-wash AoE — freezes anyone within 2-tile radius for 0.8 s and deals 1–50. |
| **Wraith** | Freeze + Ghost | Pass-through ball that freezes anyone it tunnels through for 0.8 s. → Banshee (with Phantom). |
| **Glacier** | Freeze + (Earthquake or Stone) | Plants glacial spikes that freeze and damage anyone touching them. |
| **Freeze Ray** | Freeze + (Laser H or V) | Emits a freeze ray on contact — long line of Freeze. |
| **Timestop** | Freeze + Time | **Freezes everything on the field for 5 s**, then self-destructs. 30 s cooldown. |
| **Venom** | Poison + Freeze | 8-stack Venom (3–6 dmg/s) + slow. |
| **Frozen Flame** | Burn + Freeze | (See Burn family.) |

### 4.4 Poison / radiation / disease

| Evolved Ball | Recipe | Effect |
|---|---|---|
| **Virus** | Poison + (Ghost or Cell) | Disease that has 15% chance per second to **spread** to nearby enemies. |
| **Swamp** | Poison + Earthquake | Tar blobs slow 50% + apply Poison + chip damage. |
| **Noxious** | Wind + (Poison or Dark) | Passes through enemies and applies AoE Poison cloud. |
| **Nuclear Bomb** | Bomb + Poison | 300–500 AoE damage + permanent Radiation stacks (max 5; **+10% incoming dmg per stack**). |
| **Radiation Beam** | (Laser H or V) + (Poison or Cell) | Beam that applies Radiation. |
| **X Ray** | Holy Laser + Laser Beam | X-shaped laser; 50–75 dmg + Radiation. |

### 4.5 Dark / curse / charm

| Evolved Ball | Recipe | Effect |
|---|---|---|
| **Phantom** | Dark + Ghost | Curse on hit; 5 hits = 100–200 burst. → Banshee (+ Wraith). |
| **Banshee** | Phantom + Wraith | Curses **all** on-field enemies on launch; 6 hits = 150–300 burst. |
| **Incubus** | Charm + Dark | 4% Charm for 9 s + cursed-area effect. → Satan (with Succubus). |
| **Succubus** | Charm + Vampire | 4% Charm for 9 s + heals you 1 on hitting charmed enemies. → Satan (with Incubus). |
| **Satan** | Incubus + Succubus | Per-second: **1 stack Burn (max 5) AND Berserk on every active enemy**. Build-defining. |
| **Lovestruck** | Charm + (Light or Lightning or Time) | Charmed enemies' attacks heal you 5 HP at 50% chance. Defensive scaling. |

### 4.6 Laser / light

| Evolved Ball | Recipe | Effect |
|---|---|---|
| **Holy Laser** | Laser H + Laser V | 24–36 dmg to entire row **and** column. → X Ray (with Laser Beam). |
| **Laser Beam** | Light + (Laser H or V) | 30–42 dmg + 8 s Blind. → X Ray (with Holy Laser). |
| **Flash** | Lightning + Light | Screen-wide 1–3 dmg burst + 2 s Blind. |
| **Flicker** | Light + Dark | Every 1.4 s: 1–7 dmg to **every enemy on screen**. |
| **Laser Cutter** | (Laser H or V) + Steel | Constant front-facing laser, 100–150 dmg/s. |
| **Warp** | Time + Light | Teleports after each hit; +5% speed per hit. |

### 4.7 Lightning / wind / stone family

| Evolved Ball | Recipe | Effect |
|---|---|---|
| **Storm** | Lightning + Wind | Auto-zaps nearby enemies once per second for 1–40. |
| **Lightning Rod** | Lightning + Iron | Plants a rod; lightning chains every 3 s to 8 nearby enemies. |
| **Sandstorm** | (Earthquake or Stone) + Wind | Phases through enemies surrounded by a damaging storm + Blind. |
| **Landslide** | Stone + Earthquake | On hit, drops a 5 s persistent AoE that deals 20–30/s in 2 tiles. |
| **Steel** | Iron + Stone | Slow but ramps **+10% damage per hit, max 300%**. → Laser Cutter. |
| **Erosion** | Time + Wind | Pierces; **deals 3% of current HP as bonus damage** per hit. Boss-melter. |

### 4.8 Summon / swarm

| Evolved Ball | Recipe | Effect |
|---|---|---|
| **Spider Queen** | Brood Mother + Egg Sac | 25% chance to spawn an Egg Sac on hit. → Nosferatu. |
| **Mosquito King** | Brood Mother + Vampire | Spawns homing mosquitos (80–120 dmg, lifesteal). → Nosferatu. |
| **Mosquito Swarm** | Vampire + Egg Sac | Explodes into 3–6 mosquitos on hit. |
| **Maggot** | Brood Mother + Cell | Infest; corpses pop 1–2 baby balls. |
| **Voluptuous Egg Sac** | Egg Sac + Cell | Explodes into 2–3 Egg Sacs (recursive baby-ball factory). |
| **Catapult** | Stone + Egg Sac | Auto-launches 3–5 stone baby balls every 1.5 s. |
| **Shotgun** | Iron + Egg Sac | Shoots 3–7 iron baby balls after each wall-bounce. → Sniper (+ Assassin). |

### 4.9 Pierce / position

| Evolved Ball | Recipe | Effect |
|---|---|---|
| **Assassin** | Iron + (Ghost or Dark) | Pierces fronts but not backs; **+30% backstab damage**. → Sniper (+ Shotgun). |
| **Sniper** | Shotgun + Assassin | Pierces + drops sniper baby balls that themselves pierce. |
| **Soul Sucker** | Vampire + Ghost | Phases through enemies; 30% lifesteal + attack-down. → Reaper (+ Heart Swallower). |
| **Reaper** | Soul Sucker + Heart Swallower | **10% chance per hit to instant-kill non-bosses**; +5 HP per kill. |

### 4.10 Apex / 3-ball / instant-kill

| Evolved Ball | Recipe | Effect |
|---|---|---|
| **Nosferatu** | Vampire Lord + Spider Queen + Mosquito King | Spawns a vampire bat every bounce; 132–176 on hit, then becomes a Vampire Lord. **3-ball fusion**. |
| **Black Hole** | Sun + (Dark or Time) | First non-boss hit = instant kill; self-destructs. 7 s CD. |
| **Time Bomb** | Time + Bomb | Periodic timed explosive for 80–120 dmg in an AoE. |
| **Overgrowth** | Earthquake + Cell | 3 stacks → 150–200 dmg in 3×3 burst. |

> **[INFERRED]** The 59 named evolutions are a deliberately curated subset of the 6,085 fused-ball space — the developer hand-designed each one to feel like a **named mechanic the player can build around**, while leaving the long tail to procedural fusion. Players hunt evolved balls; fused balls happen by accident when you run out of slots.

---

## 5. Fused Balls — procedural hybrids

When two level-3 balls **don't** have a named Evolution recipe, you can **Fuse** them at a Fusion Reactor. The fused ball:

- **Inherits both parents' effects** stacked together. No effect is lost.
- **Frees up a slot**, because the two parents collapse into one.
- **Cannot be fused with itself again** (no Fuse-of-a-fuse to make the same ball stronger).
- Sprite art is a procedural visual hybrid of the two parents; order of selection doesn't change stats but can change visuals **[WIKI/Balls]**.

**Total potential combinations: 6,085** **[WIKI/Balls]**. In practice a player sees 5–15 fused balls per long run.

> **[INFERRED]** Fusion is the "I'm out of slots and I need to keep adding balls" mechanic. It's also the build-finisher: a Hemorrhage + Mosquito King + Holy Laser fused ball delivers Bleed-execute, swarm lifesteal, and full row/column AoE on a single shot, with one of the three pulling double duty as that build's identity.

---

## 6. The Fusion Reactor — what the menu actually does

Source: `Web Sources/ballpit.fandom.com/Fusion_Reactor.md`.

The Fusion Reactor is a rainbow yin-yang orb that occasionally drops on the field mid-run. Picking it up pauses the menu over the live game and offers **three exclusive options**:

### 6.1 Fission (always available)

Awards a **random number of upgrade levels** distributed across your owned balls and passives. Max roll = **all 4 of your balls +1 level simultaneously** (full-screen cosmic starfield + "+1 Level" labels + "Whoa" confirm) **[VID:M8nLJ82HwfI f_00900]**.

If everything is already level 3, Fission grants a **random amount of Gold** instead — turning the pickup into meta-currency.

**How it shapes play:** Fission is the safe, generalist pick. Take it early to level up your build; take it late when you have nothing left to evolve and want gold for the base.

### 6.2 Fusion (requires ≥ 2 unfused level-3 balls)

Lets the player **manually pick two of their unfused level-3 balls** and combine them into a single fused ball that inherits both effects. The combined ball replaces both parents, freeing a slot.

Restriction: **balls that share an Evolution recipe cannot be Fused** — you must Evolve them. The lone exception is the 3-ball Nosferatu recipe — the wiki notes Vampire Lord / Spider Queen / Mosquito King can Fuse pairwise because they evolve into Nosferatu only as a 3-way.

### 6.3 Evolution (requires the specific recipe components at level 3)

If you happen to own **every ball in a known Evolution recipe at level 3**, this option appears and lets you spend them to create the named Evolved Ball — usually replacing the two parents with the evolution. Some evolutions (Nosferatu) consume three.

> The three options are **mutually exclusive per Reactor pickup** — one pickup, one choice **[FANDOM/Fusion_Reactor]**.

---

## 7. The 53 Base Passives (by role)

Sourced from `ballxpit.wiki.gg/Passives.md`. Passives can be levelled 1 → 3 the same way balls can. They cannot be **fused** — only **evolved** via specific recipes (§8). Each character has access to all passives.

### 7.1 Defensive passives

| Passive | Effect | Unlock |
|---|---|---|
| **Breastplate** | -10% damage taken. | Default |
| **Protective Charm** | Shield blocks the next damage instance; recharges every 60 s. | Clear FUNGALxFOREST |
| **Eye of the Beholder** | 10% chance to dodge incoming attacks. | Default |
| **Ethereal Cloak** | Balls pass through enemies and deal **+25% dmg until they hit back wall**. | Default |
| **Ghostly Corset** | Balls pass through enemies and deal **+20% dmg from the side**. | Clear HEAVENLYxGATES |
| **Crown of Thorns** | Destroys the 2 nearest enemies when you're hit at close range. | Default |
| **Spiked Collar** | 30–50 dmg to enemies first entering your melee range. | Clear FUNGALxFOREST |

### 7.2 Damage scaling

| Passive | Effect | Unlock |
|---|---|---|
| **Hourglass** | +150% ball damage, **decays 30% per bounce** (min 50%). First-hit alpha-strike. | Default |
| **Silver Bullet** | +20% damage **until ball hits a wall**. | Default |
| **Sword Breaker** | -40% damage, but **+1% per enemy on field** (scales into mob waves). | Unknown |
| **Iron Onesie** | +0.5% damage per **baby ball** currently on the field. | Default |
| **Magic Staff** | +20% AoE damage. | Default |
| **War Horn** | All baby balls deal +20% damage. | Default |
| **Wagon Wheel** | Each wall-bounce → next hit deals +30% damage. | Clear SMOLDERINGxDEPTHS |
| **Upturned Hatchet** | +80% damage after hitting **back of field**, -20% otherwise. | Default |
| **Midnight Oil** | Balls that hit flaming enemies catch fire and deal +10–20 bonus damage. | Default |

### 7.3 Crit & precision

| Passive | Effect | Unlock |
|---|---|---|
| **Diamond Hilted Dagger** | Crit chance → 20% on enemies hit **from front**. | Default |
| **Sapphire Hilted Dagger** | Crit chance → 30% on enemies hit **from left**. | Default |
| **Ruby Hilted Dagger** | Crit chance → 15% on enemies hit **from back**. | Default |
| **Emerald Hilted Dagger** | Crit chance → 20% on enemies hit **from right**. | Default |
| **Reacher's Spear** | Crit chance → 20% on enemies **in same column** as you. | Default |
| **Silver Blindfold** | Crit chance → 20% on **Blinded** enemies. | Clear LIMINALxDESERT |
| **Deadeye's Amulet** | Crits deal **+10–15 bonus damage**. | Clear LIMINALxDESERT |

### 7.4 Baby-ball amplifiers

| Passive | Effect | Unlock |
|---|---|---|
| **Baby Rattle** | +1.5× baby balls but aim becomes scattered. | Default |
| **Bandage Roll** | Spawn 1–2 baby balls every time you're healed. | Default |
| **Bottled Tornado** | When you catch a special ball, auto-shoot 1–3 baby balls. | Default |
| **Slingshot** | 25% chance to launch a baby ball when you pick up an XP gem. | Default |
| **Turret** | Floats around you, auto-fires a baby ball every 2 s. | Default |

### 7.5 Summon / friendlies

| Passive | Effect | Unlock |
|---|---|---|
| **Stone Effigy** | Every 7–12 rows, spawn a stone soldier (200 HP) on your side. | Default |
| **Archer's Effigy** | Every 7–12 rows, spawn a stone archer (160 HP). | Clear SNOWYxSHORES |
| **Healer's Effigy** | Every 7–12 rows, spawn a stone healer (heals you 10 HP/min). | Clear SNOWYxSHORES |
| **Golden Bull** | Every 7–11 rows, spawn a golden bull (400 HP). | Clear SNOWYxSHORES |
| **Gemspring** | Every 7–11 rows, spawn a Gemspring that drops XP gems when damaged. | Clear SMOLDERINGxDEPTHS |
| **Dynamite** | Every 5–10 rows, spawn an enemy with dynamite attached (turns mob into bomb). | Clear SMOLDERINGxDEPTHS |
| **Artificial Heart** | Friendly pieces gain +100% HP. | Default |
| **Traitor's Cowl** | Stone allies are now damaged by your balls; heal 2 HP when one is hit. | Clear HEAVENLYxGATES |
| **Ghostly Shield** | Balls go through allies and heal them for 2 HP. | Clear HEAVENLYxGATES |

### 7.6 Status-effect synergy

| Passive | Effect | Unlock |
|---|---|---|
| **Frozen Spike** | Frozen enemies emit a chill dealing 10–20. | Default |
| **Voodoo Doll** | Curse has 10% chance to outright kill. | Clear BONExYARD |
| **Pressure Valve** | Enemies explode on death for 20–30 to adjacent enemies. | Clear BONExYARD |
| **Cursed Elixir** | When a poisoned enemy dies, 10% chance they return as a zombie ally. | Clear BONExYARD |
| **Kiss of Death** | Charmed enemies have 10% chance to die after recovering. | Default |
| **Wretched Onion** | Deals 6–12/s to all enemies within 2 tiles. | Clear FUNGALxFOREST |

### 7.7 Mobility / fire rate

| Passive | Effect | Unlock |
|---|---|---|
| **Fleet Feet** | +10% move speed; move at full speed while shooting. | Default |
| **Radiant Feather** | +20% ball launch speed; you get knocked back when shooting. | Default |
| **Rubber Headband** | Balls start at 70% speed, +20% per bounce (max 200%). | Default |
| **Shortbow** | +15% fire rate. | Default |
| **Magnet** | +1.0 tile pickup range for items and ball catches. | Default |

### 7.8 Healing / sustain

| Passive | Effect | Unlock |
|---|---|---|
| **Vampiric Sword** | +5 HP per kill, but each shot you take deals 2 dmg to you. | Clear LIMINALxDESERT |
| **Everflowing Goblet** | You can heal past max HP at 20% efficiency. | Default |
| **Lover's Quiver** | Incoming projectiles have 40% chance to heal you for 1 HP instead of damaging. | Clear GORYxGRASSLANDS |
| **Hand Mirror** | Incoming projectiles have 50% chance to reflect, dealing 20–40 if they hit. | Clear GORYxGRASSLANDS |
| **Hand Fan** | Enemies in your column are slowed by 50%. | Clear GORYxGRASSLANDS |

---

## 8. The 13 Evolved Passives (by recipe)

Built from specific 2-passive (or 4-passive!) combinations at level 3 via the Fusion Reactor. These are the **build payoffs** — most are S-tier on Dexerto's tier list.

| Evolved Passive | Recipe | Effect |
|---|---|---|
| **Argent Stopwatch** | Hourglass + Silver Bullet | +200% ball damage, decays 20% per bounce (min 100%). Strict upgrade to Hourglass. |
| **Arrow of Fate** | Lover's Quiver + Hand Mirror | Incoming projectiles **no longer hurt you** AND spawn 1–2 baby balls when they "hit." |
| **Cornucopia** | Baby Rattle + War Horn | Every baby-ball spawn rolls 0–1 **additional** baby balls. |
| **Deadeye's Cross** | Diamond + Sapphire + Ruby + Emerald Hilted Daggers | **Crit chance flat 60%** regardless of angle. |
| **Gracious Impaler** | Reacher's Spear + Deadeye's Amulet | Crits have 5% chance to instant-kill enemies. |
| **Deadeye's Impaler** | Deadeye's Cross + Gracious Impaler | +5% crit chance AND **crits instantly kill non-boss enemies**. S-tier. |
| **Full Metal Rapier** | Iron Onesie + Sword Breaker | +1% damage per baby ball **AND** per enemy on field. Compound scaling. |
| **Grotesque Artillery** | Turret + Hand Fan | Floating attendant shoots a **random level-1 Special Ball** every 8 s. Free build expansion. |
| **Odiferous Shell** | Wretched Onion + Breastplate | When you touch enemies, **50% chance they die instantly**. Body-block as a weapon. |
| **Phantom Regalia** | Ghostly Corset + Ethereal Cloak | Balls pierce all the way to back wall and deal +50% while piercing. |
| **Soul Reaver** | Vampiric Sword + Everflowing Goblet | +1 HP per kill AND heal past max HP at 30% efficiency. Strict upgrade. |
| **Tormenter's Mask** | Spiked Collar + Crown of Thorns | When enemies **detect** you, 10% chance they die instantly. |
| **Wings of the Anointed** | Radiant Feather + Fleet Feet | +40% ball speed, +20% move speed, **immune to ground hazards**. |

---

## 9. Notable build archetypes the system enables

Synthesised from `Web Sources/dexerto.com/best-character-combinations.md`, the Steam Community K708 guide, and observed playthroughs.

### 9.1 Bleed-execute (Warrior, False Messiah)

- **Core balls:** Bleed → Hemorrhage (Bleed + Iron). Optional Leech, Vampire Lord, Sacrifice.
- **Passives:** Hourglass / Argent Stopwatch, Wagon Wheel, Sword Breaker → Full Metal Rapier.
- **Behaviour:** Stack Bleed to 12+; Hemorrhage hit removes 20% of current HP. Boss-melter.

### 9.2 Crit-cross (any character; gated by 4 Daggers)

- **Core passives:** Diamond + Sapphire + Ruby + Emerald → Deadeye's Cross (60% crit) → + Reacher's Spear + Deadeye's Amulet → Gracious Impaler → Deadeye's Impaler.
- **Synergy ball:** Any high-fire-rate ball benefits — Itchy Finger's Burn at 11.95 fire rate triggers crit-kills constantly.
- **Behaviour:** Mid-late-game every shot has a meaningful chance to delete an entire non-boss enemy.

### 9.3 Status-spam / no-direct-damage (Sisyphus)

- **Core balls:** Earthquake → Magma / Swamp / Landslide / Overgrowth / Glacier. Poison → Virus / Brimstone.
- **Passives:** Magic Staff, Pressure Valve, Wretched Onion → Odiferous Shell.
- **Behaviour:** Sisyphus's direct damage is zero — runs on +400% AoE/status multiplier baked into the character.

### 9.4 Baby-ball swarm (Cohabitants, Empty Nester for inverted version)

- **Core balls:** Brood Mother → Spider Queen → Nosferatu. Egg Sac → Catapult / Shotgun / Voluptuous Egg Sac.
- **Passives:** Baby Rattle + War Horn → Cornucopia, Iron Onesie, Turret → Grotesque Artillery.
- **Behaviour:** Screen fills with 50+ baby balls; chip DPS dominates.

### 9.5 Screen-clear lasers (Tiptoer + Cogitator pairing or Holy Laser builds)

- **Core balls:** Laser H + Laser V → Holy Laser → + Laser Beam → X Ray.
- **Passives:** Magic Staff, Ethereal Cloak → Phantom Regalia.
- **Behaviour:** Continuous row+column wipe; Radiation stacks compound everything else.

### 9.6 Demonic / Satan (Shade, Carouser)

- **Core balls:** Charm + Vampire → Succubus, Charm + Dark → Incubus → Satan. Optional Sun, Black Hole.
- **Passives:** Voodoo Doll, Kiss of Death, Lovestruck synergies.
- **Behaviour:** Every enemy on field perpetually Burns and Berserks itself.

### 9.7 Defensive / sustain (Spendthrift, Repentant)

- **Core balls:** Vampire → Vampire Lord / Mosquito King / Succubus. Reaper / Heart Swallower / Soul Sucker.
- **Passives:** Vampiric Sword + Everflowing Goblet → Soul Reaver. Lover's Quiver + Hand Mirror → Arrow of Fate. Protective Charm.
- **Behaviour:** "Healing past max HP" loop where projectiles flip into healing.

### 9.8 Apex assassin (Reaper / Black Hole / Deadeye's Impaler)

- **Core:** Vampire + Ghost → Soul Sucker. Bleed + Ghost → Heart Swallower. Soul Sucker + Heart Swallower → Reaper. **+ Black Hole + Deadeye's Impaler.**
- **Behaviour:** Three sources of instant-kill stacking on top of each other. Hits the "crash the game" power level [VID:SRcNWzJIML0].

---

## 10. How offers are gated (what shows up in the level-up panel)

Three filters apply to every level-up draw:

1. **Encyclopedia gate.** Until a ball/passive's first **unlock condition** (default, or clearing a specific biome — listed in §3, §7) is met, it cannot appear as an offer. This is why the early game feels narrow and biome 4+ feels combinatorially explosive — the offer pool grows as you clear layers.
2. **Slot availability.** Once both slot blocks (4 balls + 4 passives) are full at level 3, the panel only offers **levels on existing picks** or **new passives if a slot is open**. The way to add more balls past 4 is to **Fuse or Evolve at the next Fusion Reactor**.
3. **Character constraint.** A character's starter ball is pre-loaded into a slot. Some characters lock out baby balls (Empty Nester, Sisyphus) and therefore lock out baby-ball passives' utility.

---

## 11. Quick-reference index

- **20 Base Balls** — §3.
- **59 Evolved Balls** — §4 (full recipe table).
- **6,085 Fused Balls** — §5 (procedural; not catalogued).
- **53 Base Passives** — §7.
- **13 Evolved Passives** — §8.
- **Status-effect verbs (~22)** — §1.
- **Build archetypes (~8)** — §9.

Totals visible in a single run's offer pool, once everything is unlocked: **20 + 59 + ~6,085 (latent) = 6,164 ball outcomes** × **53 + 13 = 66 passives** = effectively unbounded loadout space, which is the source of the game's "1000-hour" reputation [STEAM-REV].

---

## 12. Cross-references

- `DESIGN_DOC.md` §4.3, §4.4, §4.5 — high-level summaries of these systems.
- `DESIGN_DOC.md` §4.2 — how each character interacts with the ball roster (starters + restrictions).
- `Web Sources/steam_community/guide_3587888441.md` — K708's "All Evolutions" guide, 71,818 visitors; canonical community reference.
- `Web Sources/dexerto.com/all-evolution-recipes.md` — alternate evolution table with screenshots.
- `Web Sources/dexerto.com/passive-tier-list.md` — community S/A/B/C ranking of passives.
- `Web Sources/dexerto.com/character-tier-list.md` — how each character maps onto the build archetypes in §9.
