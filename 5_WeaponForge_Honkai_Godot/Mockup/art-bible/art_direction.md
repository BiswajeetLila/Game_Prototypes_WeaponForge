# WeaponForge — Art Bible (v1.0)

**Status:** **LOCKED v1.0** (2026-06-08). Promoted from stub. Single source of truth for all visual work — character renders, UI, VFX, environments, marketing.
**Style anchor:** **2E — cel-shaded 3D anime, Honkai-Star-Rail polish.** Decided after style-test sweep (5 styles + 4 PRO variants, see `docs/research/d1-beat-mockups/style-test/`); 2E exemplar approved 2026-05 and used for all D1 beat mockups in `docs/research/d1-beat-mockups/2e-beats/` + `2e-beats-v2/`.
**Rejected styles** (do NOT use): style1-chibi-casual (too low-whale), style3-stylized-3d (too generic mobile), style4-painterly-splash (off-brand for combat read), style5-hd2d-pixel (wrong audience).

> Pre-AI-gen checklist: **paste §11 Continuity Sheet into every prompt.** Drop any prompt that omits it.

---

## 1. North star (one line)

*"Honkai-Star-Rail character render meets Wittle Defender arena tempo — anime souls on a casual-mobile silhouette."*

Heroes carry premium anime-RPG polish (story-locked roster moat); combat & UI keep the readable, low-friction mobile loop. The render style is what justifies the 7-hero story-lock pitch. Drop the polish and the moat collapses.

---

## 2. Style fundamentals

| Axis | Lock |
|---|---|
| Render technique | Cel-shaded 3D character bake → painterly 2D background composite |
| Line treatment | Clean, crisp outlines on characters; soft / no outlines on environments |
| Shading | 2-3 tone cel shading, soft AA on hair/cloth; warm rim-light on heroes |
| Proportions | **Half-realistic anime** (7-head, NOT chibi). Hot Paladin/Bran tall heroic; Elara/Vex slender |
| Background | Painterly + slight depth-of-field; never flat colors |
| Detail density | **Hero faces > weapons > FX > enemies > UI chrome > environment background** |
| Camera | Side-view orthographic for combat; ¾ portrait for splash; low-angle push-in for cinematics |
| Frame | Mobile-first — 9:16 portrait for in-game, 16:9 for cinematic/marketing |

**Banned:** chibi proportions on heroes, photorealism, pixel art, flat vector UI, full grimdark desaturation, anime hyper-cute (CookieRun-style), western cartoon outlines (TF2-style thick), AI slop tells (six-finger hands, melted weapons, garbled UI text).

---

## 3. Palette

### 3.1 Master palette

```
BACKGROUND          deep indigo #1A1B2E → slate #2C2F4A → forge-warm #3D2A1F
HUD CHROME          desaturated cool gray #3A3D52 with cyan glow accents #4ECDE6
LEGENDARY          warm gold #F4C04A → orange ember #D87B2C
MYTHIC             gold-purple shimmer #B574F5 + #F4C04A
RARE               violet #A560FF
EPIC               purple #7A3DD6
COMMON             pale steel #BDC4D2
DEFEAT VIGNETTE    blood red #B22A2A (edges only, never full screen)
WARM DAWN          pale gold #F8DC92 → soft pink #F3B4AE (Hot Paladin scenes)
```

### 3.2 Element palette (locks weapon glow, VFX color, badges)

| Element | Primary | Secondary | Glow / VFX |
|---|---|---|---|
| 🔥 Fire | ember orange #FF7A33 | deep red #C8331C | flickering flame, ember motes |
| ❄️ Ice | crystal cyan #6FE4F1 | deep ocean #2C5A8C | crystalline shards, frost beam |
| ⚡ Electric | electric violet #9B5DFF | hot pink-violet #D14ECC | crackle arcs, sparks |
| 🌪 Wind | pale teal #7FE8C8 | sky blue #4DA8D8 | swirl streaks, dust trail |
| 🌍 Earth (S10+) | warm ochre #C49555 | deep brown #5C3A1E | crack lines, dust plumes |

**Catalyst compounds** = visible blended VFX (Fire+Ice = steam VFX in palette #C9D8E8; Fire+Electric = plasma orange-violet #FFB347 → #9B5DFF). Lock when each pair ships.

---

## 4. Character bible — locked roster (v1.0 = heroes 1-4)

### 4.1 Hero 1 — BRAN (warrior, FTUE)

| Field | Lock |
|---|---|
| Sex/age | Male, mid-20s |
| Hair | White spiky anime hair, layered cut, slight forelock |
| Eyes | Hazel-gold |
| Build | Tall, broad shoulders, heroic |
| Armor | Dark teal-trim **navy-and-gold breastplate**, layered shoulder pauldrons, gold filigree |
| Weapon (default) | **Stormblaze Katana** — long curved blade, glowing fire-imbued edge, rune-engraved guard |
| Element default | 🔥 Fire |
| Personality | Stoic, quietly determined, "Hold the line" |
| Rim-light | Warm gold |
| Voice direction | Low, restrained — guardian energy |

### 4.2 Hero 2 — ELARA (mage, FTUE wave 2)

| Field | Lock |
|---|---|
| Sex/age | Female, late teens |
| Hair | Long flowing silver hair, side-parted, ice-blue highlights |
| Eyes | Pale cyan |
| Build | Slender, elegant, slightly elevated platform pose |
| Robe | **Blue-teal robes** w/ arcane-blue trim and frost crystals embedded at shoulders/hem |
| Weapon (default) | **Cyan crystal staff** — long shaft, crystalline orb at top |
| Element default | ❄️ Ice |
| Personality | Calm, measured, "The ice in me holds the storm" |
| Rim-light | Cyan/teal |
| Voice direction | Soft but firm — scholarly poise |

### 4.3 Hero 3 — VEX (rogue, FTUE wave 3 / Stage 1 boss clear)

| Field | Lock |
|---|---|
| Sex/age | Female, early 20s |
| Hair | Short purple hair, layered, partially hidden under hood |
| Eyes | Bright violet |
| Build | Slim, agile, low-crouch combat stance |
| Outfit | Dark hood + short cape over leather-armored midriff, asymmetric belts |
| Weapon (default) | **Twin daggers** crackling with violet electric energy |
| Element default | ⚡ Electric |
| Personality | Cocky, blade-loving, anime-trickster |
| Rim-light | Violet / electric pink |
| Voice direction | Sly, smirking — cocky DPS energy |

### 4.4 Hero 4 — HOT PALADIN (warrior-priestess, Stage 2 cinematic / W14 defeat)

| Field | Lock |
|---|---|
| Sex/age | Female, mid-20s |
| Hair | **Blonde or red braided** (lock blonde for now — confirm if red preferred) |
| Eyes | Storm blue |
| Build | Tall heroic, gravitas posture |
| Armor | Ornate **storm-blue plate armor**, white-and-silver underlay, halo-motif pauldrons, sash |
| Weapon (default) | **Two-handed glowing storm-blue greatsword**, point-down planting pose default |
| Element default | 🌪 Wind (storm-blue cross-element, locked) |
| Personality | Warrior-priestess, calm gravitas, "I saw your blades work hard" |
| Rim-light | Storm-blue w/ warm dawn fill |
| Voice direction | Mid-range, warm — protector energy |
| Final name | **TBD — currently placeholder "Hot Paladin"**. Confirm before any external asset bake. |

### 4.5 Heroes 5–7 (designed, not visually locked)

| # | Class | Unlock | Visual stub |
|---|---|---|---|
| 5 | 2nd Rogue | Stage 5–7 (TBD) | Stealth-DPS variant. Darker palette than Vex. **TBD design.** |
| 6 | 2nd Mage | Stage 8–10 (TBD) | Counterpart to Elara — opposing element (Fire mage?). **TBD design.** |
| 7 | Hot Assassin | Late-game (S12+) | Anime-assassin archetype, exotic palette. **TBD design.** |

**Rule:** every new hero must (a) own a distinct silhouette at 88×88 px, (b) own a distinct element/color rim, (c) own at least one signature pose for splash art.

### 4.6 NPCs

| NPC | Role | Lock |
|---|---|---|
| **Master Smith** | Stage 10 unlock cinematic; opens Forge Phase 1 (Part Pull) | Grizzled male, late 50s, leather apron, ash-streaked beard, hammer in hand. Backdrop = glowing forge w/ anvil + brazier. |
| **Iron Lich's Herald** | Stage 2 W14 hardcoded-defeat boss; Stage 8 unlock gate | Towering dark wraith-lich, skeletal crowned face, blue-black robes, necrotic staff, blue-black necrotic energy aura. |
| **Slime King** | Stage 1 boss (W15) | Larger crowned slime, gold crown, lime-green body, subtle royal palette. |

---

## 5. Enemy bible

| Tier | Enemies | Visual lock |
|---|---|---|
| Common minions | **Slimes** (lime green, simple eyes), **skeleton warriors** (rusty swords, dark robes), **goblin shaman** (back-row, staff) | All chibi-flavored to contrast w/ half-realistic heroes — clear silhouette + clear color tag for element |
| Mini-bosses | TBD per stage | Larger version of minion w/ crown/horn motif |
| Stage bosses | Slime King (S1) · Iron Lich's Herald (S2 narrative defeat) · TBD S3-S15 | Each owns a unique color silhouette readable at 1/4 frame |
| Death VFX | Slime → bright cyan XP gem burst; skeleton → bone clatter + gray dust; goblin → green smoke |

**Rule:** enemy palette never overlaps hero element rim. If hero glows cyan (Elara/Ice), no enemy in same frame may have a cyan glow.

---

## 6. UI / HUD style

| Element | Treatment |
|---|---|
| Panels | Dark indigo (#1A1B2E) base, slight inner glow, gold or violet borders for tier |
| Buttons | Primary = glowing gold (#F4C04A) w/ inner shadow; secondary = gray (#3A3D52); danger = muted red |
| Typography | Sans-serif game font (Inter / Poppins family). Caps for banners, mixed-case for body |
| Tier frames | Common=steel, Rare=violet, Epic=purple, Legendary=gold, Mythic=gold-purple shimmer |
| Currency icons | Gold coin, blue gem (gems), forge-icon (Cores), purple shard (element shards) |
| Element badges | Small circular icon w/ element color + glyph; placed at corner of hero portrait |
| Damage numbers | Stylized bold sans-serif, white w/ element-tinted outline; CRIT = larger + gold outline |
| Boss banner | Red gradient bar w/ skull motif, HP bar in deep blood red |
| Modal overlay | Dim arena to 40% opacity, modal slides up w/ ease, subtle parallax |

**Chromatic-aberration glow** on UI edges = on. Subtle, not Cyberpunk-2077 levels. Conveys "premium polish without overcommitting to cyberpunk."

**Banned UI:** parchment-scroll wood-plank skeumorphism (too Wittle-derivative), pure flat-modern (too generic), grunge metal textures (off-brand).

---

## 7. Environment bible

| Location | Lock |
|---|---|
| **Combat arena (default)** | Side-view, painterly stone-and-cyber-tile floor; far background = dim arena wall w/ faint torch/brazier glow; ember motes drifting. Floor 2/3 of frame; sky/ceiling 1/3. |
| **Stage 1 — Slime Hollow** | Cooler indigo cave, dripping ceiling, faint cyan moss glow. |
| **Stage 2 — Iron Lich's Antechamber** | Necrotic crypt — blue-black palette, cracked stone, dark mist. |
| **Master Smith's Forge (S10 unlock)** | Warmest interior — orange brazier glow, anvil center, hammer racks, glowing forge core. |
| **Forge Wheel meta screen** | Dark indigo interior, single slot reel center, anvil silhouette, glowing rune frames. |
| **End card / marketing splash** | Hero key art lighting — strong rim-lights, god-rays, deep indigo bg, ember confetti. |

**Time of day:** dim arena, theatrical key-light from upper-left. Heroes silhouetted-rim-lit against darker enemy half. Cold blue fill on enemy side, warm gold fill on hero side. This is the lighting signature.

---

## 8. VFX language

| Effect | Locked treatment |
|---|---|
| Storm Cyclone (Bran ult) | Translucent blue-purple swirl, cyclone shape, 3 cyclones when card-buffed |
| Frost beam (Elara) | Crystalline cyan beam w/ ice-shard particles, slight refraction |
| Electric daggers (Vex) | Violet-pink crackle arcs, sparks on dash trail |
| Hot Paladin blade hum | Soft storm-blue glow, ambient hum particles |
| Iron Lich shockwave | Blue-black necrotic mist expanding radially |
| Forge Wheel jackpot | Gold god-rays from reel, ember confetti, light-ray flash zoom |
| Part Pull (Epic+) | Purple particle burst, fly-up animation into rarity meter |
| XP gem burst | Bright cyan diamonds, slight arc fly outward, fade after ~0.5s |
| Damage number pop | Pop-up scale 1.0 → 1.2 → 1.0 over 0.3s |
| Ult-ready pulse | Soft gold halo around hero portrait, pulse at 1Hz |
| Element badge | Small steady glow, no animation |
| Tap-finger hint | Soft white finger silhouette, gentle pulse, fades after 2 taps |

**Banned VFX:** screen-filling flashbang particles (epilepsy risk + cheap-mobile feel), volumetric god-rays in combat (only for meta/cinematic), motion blur on hero models (only on background and dash trails).

---

## 9. Portrait evolution (5-tier system, FM-19 gated)

Each hero owns 5 portrait tiers unlocked by Hero Mastery (1→100). Test render done for Bran: [bran_5tier_evolution.png](../research/portrait-tier-test/bran_5tier_evolution.png). **Awaits 20-Honkai-player eval gate** (≥14/20 "evolves the character" → ship 5-tier, else fall to 3-tier per pre-mortem FM-19).

| Tier | Mastery range | Visual progression |
|---|---|---|
| 1 Basic | 1-20 | Baseline character render |
| 2 Awakened | 21-40 | New armor accent, slight palette warm-up |
| 3 Forged | 41-60 | Major armor/silhouette evolution, signature weapon visible |
| 4 Ascendant | 61-80 | Aura added, palette dramatic shift, scar/mark of mastery |
| 5 Apotheosis | 81-100 | Full transcendent form, key-art splash quality |

**Lock pending:** until eval passes, all marketing/store assets use Tier 1 only.

---

## 10. AI generation pipeline

### 10.1 Model policy

| Use case | Model | Cost/img | When |
|---|---|---|---|
| Default | **nano-banana** (Gemini 2.5 Flash) | $0.039 | All mockups, all D1 beats, all iterations |
| Premium | nano-banana-pro (Gemini 3 Pro) | $0.24 | ONLY for hero splash key art or store-page hero shots, w/ owner approval per call |
| Banned | midjourney, DALL-E, etc | — | Trademark/style drift risk |

**Cost policy** (from user CLAUDE.md): NEVER use nano-banana-pro without explicit user ask per call.

### 10.2 Aspect ratio policy

| Use | Aspect |
|---|---|
| In-game gameplay/HUD screens | **9:16 portrait** |
| Cinematic beats (cold open, defeat, rescue) | **16:9 landscape** |
| Hero splash / key art | **16:9** or **2:3 portrait** for store |
| App store icon | **1:1** (1024×1024, tested at 88×88) |
| Marketing end card | **16:9** |

### 10.3 Prompt skeleton

Every prompt MUST start with:

```
A high-quality 2E cel-shaded 3D anime [SCREEN TYPE], [ASPECT], Honkai-Star-Rail polish. Reads in 2s as "[ONE-LINE INTENT]."
```

…then describe LAYOUT in % bands (top X% / middle Y% / bottom Z%) for mobile screens, then VISUAL palette + lighting, then negative constraints.

Always include the **§11 Continuity Sheet** verbatim at the end of the prompt.

### 10.4 Iteration rules

- First-pass: nano-banana, single call, ~$0.04
- If style drift → bump description of "2E cel-shaded" earlier in prompt, NOT model upgrade
- If anatomy wrong (six fingers, melted weapon) → re-roll same prompt
- If composition wrong → adjust LAYOUT bands, re-roll
- Pro upgrade only after 2 nano-banana retries fail AND screen is marketing-critical
- Save all approved renders to `docs/research/d1-beat-mockups/2e-beats-v2/` (or successor folder)

---

## 11. CONTINUITY SHEET (paste verbatim into every image prompt)

```
ART STYLE: 2E — cel-shaded 3D anime (Honkai-Star-Rail-grade character rendering,
painterly backgrounds, slight chromatic-aberration glow on UI edges).
PALETTE: deep indigo + slate background; Bran=warm gold rim-light; Elara=cyan/teal;
Vex=violet/electric pink; Hot Paladin=storm-blue + warm dawn; slime=lime-green;
XP gems=bright cyan; Iron Lich=blue-black wraith energy.
CAST:
- BRAN: male warrior, mid-20s, white spiky anime hair, navy-and-gold breastplate
  with dark teal trim, fire-storm katana ("Stormblaze Katana"), stoic.
- ELARA: female mage, late teens, long flowing silver hair, blue-teal robes with
  arcane trim, cyan crystal staff, calm composure.
- VEX: female rogue, purple hair, dark hood with face visible, twin violet-electric
  daggers, low-crouch combat stance.
- HOT PALADIN: female warrior-priestess, blonde braided hair, ornate storm-blue
  plate armor with halo motif, two-handed storm-blue greatsword, gravitas.
- MASTER SMITH: grizzled male, late 50s, leather apron, hammer, glowing forge.
- IRON LICH'S HERALD: towering dark wraith, skeletal crowned face, blue-black
  necrotic energy, raised staff.
PROPORTIONS: half-realistic anime (7-head heroes, NOT chibi).
LIGHTING: warm gold key from upper-left on heroes; cold blue fill on enemy half;
ember motes; subtle chromatic-aberration on UI edges only.
NEGATIVES: NO real-world logos, NO watermarks, NO copyrighted character
likenesses, NO chibi proportions on heroes, NO photorealism, NO pixel art,
NO western cartoon outlines, NO overlaid marketing tagline outside in-game HUD.
```

---

## 12. Open locks (decide before next bake)

| # | Question | Default | Owner |
|---|---|---|---|
| 1 | Hot Paladin hair color | Blonde braided | TBD |
| 2 | Hot Paladin final name | "Hot Paladin" placeholder | TBD |
| 3 | Pull-currency final name | "Cores" placeholder. Alts: Spark / Ember / Cinder / Anvil Token / Forge Core | TBD |
| 4 | Part Pull cost currency | "150 gems" (old) vs Cores (new) — spec contradiction | TBD |
| 5 | Game title final | "WeaponForge" suggested by folder rename | TBD |
| 6 | 5-tier vs 3-tier portrait evolution | Awaits 20-Honkai-player eval on Bran test render | FM-19 |
| 7 | "Catalyst" trademark | USPTO/EUIPO check pending. Fallbacks: Alloy / Confluence / Reaction / Harmonic | FM-17 |
| 8 | Heroes 5/6/7 designs | Stub only | Phase 1+ |
| 9 | Stages 3-15 environment palettes | Stage 1+2 locked; rest TBD | Phase 1+ |
| 10 | Catalyst compound VFX colors | Fire+Ice (steam) locked; other 8 TBD | Phase 1+ |

---

## 13. Reference shelf

**Primary (style anchor):**
- Honkai: Star Rail (miHoYo, 2023) — character rendering ceiling, story-locked roster aesthetic
- Wittle Defender (Habby, 2025) — combat tempo + arena framing
- Archero 2 (Habby, 2025) — equipment-gacha precedent + meta-screen polish

**Secondary:**
- AFK Journey (Lilith, 2024) — half-realistic anime + casual-mobile UI density
- Genshin Impact — VFX language for elements (carefully — too high-budget)

**Anti-references (do NOT pull from):**
- CookieRun (too chibi)
- Raid: Shadow Legends (too grimdark / western)
- Cup Heroes (too hypercasual)

**Internal exemplars** (locked):
- `docs/research/d1-beat-mockups/style-test/style2E-cel-3d-PRO.png` — the locked style sample
- `docs/research/d1-beat-mockups/2e-beats-v2/` — full 10-beat first-pass set (2026-06-08)
- `docs/research/portrait-tier-test/bran_5tier_evolution.png` — portrait evolution test

---

## 14. Change log

| Date | Change | By |
|---|---|---|
| 2026-06-08 | Promoted from stub to v1.0 LOCKED. 2E cel-shaded 3D anime locked. Continuity sheet authored. Open locks listed. | session 2026-06-08 |
| Pre-2026-06-08 | Stub w/ deferred questions, recommended "stylized fantasy chibi-leaning" (now superseded). | initial GDD |

---

*End of Art Bible v1.0. Linked from: `docs/STATUS.md` (canonical doc table), `docs/superpowers/specs/2026-05-27-wittle-inversion-design.md` §art, `docs/research/d1-beat-mockups/D1-gameplay-video-script.md` (style anchor §3).*
