# WeaponForge — Midjourney Niji 7 prompts (v1.2 — continuity restructure)

**Style anchor:** 2E cel-shaded 3D anime, Honkai Star Rail polish. See `../art-bible/art_direction.md` v1.0 for full Art Bible.
**Storyboard spine:** `../../docs/prototype-screen-beats.md` (canonical beat IDs).
**Model:** Midjourney `--niji 7`. Date: 2026-06-09.

> **Two tracks.**
> - **Track A — Prototype screen beats** — match the canonical storyboard IDs (Beat 2.1, 4.3, 7.3, etc.). Player-journey ordered.
> - **Track B — D1 marketing video beats** — alternate continuity for the 60s trailer (heroes defeated by Iron Lich → Hot Paladin warm-dawn rescue). Cinematic only, not a prototype screen.
>
> Cast + style + negatives are SHARED across both tracks (cohesion lock from v1.1 preserved).

---

## 1. Style cohesion rules (carry-over from v1.1)

1. All heroes + NPCs = **half-realistic anime** (7-head proportions, NOT chibi).
2. Enemies (slimes/goblins/skeletons) MAY be slightly smaller/simpler for silhouette — never sticker-cute / kawaii-mascot. Bosses (Slime King, Iron Lich's Herald, Iron Golem) read full-scale dramatic.
3. `chibi` / `chibi-cute` / `sticker-style` / `kawaii-mascot` BANNED from every prompt body + listed in every `--no` block.
4. Universal `--no` block (§3) is identical across all prompts.
5. Style anchor `half-realistic anime cel-shaded 3D, Honkai Star Rail style, painterly background` repeated verbatim in every prompt.
6. Cast descriptors (§2) copy-pasted verbatim — never paraphrased.
7. Param structure identical: `--ar X --niji 7 --stylize NNN [--style scenic|expressive] --no <universal block>`.

---

## 2. Cast continuity (verbatim only — paste from this table, do NOT paraphrase)

| Hero / NPC | Verbatim descriptor |
|---|---|
| **Bran** | half-realistic anime male warrior with white spiky anime hair, navy-and-gold breastplate with dark teal trim, glowing fire-imbued katana, stoic expression |
| **Elara** | half-realistic anime female mage with long flowing silver hair, blue-teal robes with arcane trim, cyan crystal staff, calm composure |
| **Vex** | half-realistic anime female rogue with purple hair, dark hood, twin violet-electric daggers, low confident stance |
| **Hot Paladin** | half-realistic anime female warrior-priestess with blonde braided hair, ornate storm-blue plate armor with halo motif, two-handed glowing storm-blue greatsword |
| **Master Smith** | half-realistic anime grizzled male blacksmith in leather apron, hammer in hand, anvil and glowing forge backdrop |
| **Slime King** | giant emerald slime boss with crown of bone, jelly translucency, lazy menacing grin |
| **Iron Golem** | massive iron-and-stone construct boss with glowing electric core, runed plate armor, slow heavy stance |
| **Iron Lich's Herald** | towering dark wraith-lich, skeletal crowned face, blue-black necrotic energy, raised staff |
| **Slimes (minions)** | small green slime creatures with simple eyes, clearly smaller than heroes, NOT cute mascot style |
| **Skeleton warriors** | dark-robed skeleton warriors with rusty swords |
| **Goblin shaman** | green hunched goblin with crooked staff in back row |

---

## 3. Universal negatives (paste verbatim into every `--no` block)

```
--no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## 4. Universal style params

| Param | Default | Notes |
|---|---|---|
| `--niji 7` | required | latest anime model |
| `--ar` | per-beat | 16:9 cinematic, 9:16 mobile UI, 1:1 icon |
| `--stylize 250` | balanced hero/combat | 350 = cinematic, 300 = hero meta, 200 = UI-heavy |
| `--style scenic` | cinematic beats only | richer painterly backgrounds |
| `--style expressive` | dramatic hero shots | more emotional poses |
| `--oref <url>` + `--ow 100` | mandatory after first lock | omni-reference for character consistency |

---

## 5. Beat-ID map (this doc → canonical storyboard)

| This doc | Storyboard beat | Status | Aspect | Notes |
|---|---|---|---|---|
| A0 | (marketing key art) | — | 16:9 | not a prototype beat |
| A1 | **Beat 2.1** Home — fresh account | ✅ | 9:16 | NEW v1.2 |
| A2 | **Beat 2.5** Forge Wheel — reveal new weapon | ✅ | 9:16 | refined |
| A3 | **Beat 3.1/3.2** Pre-stage briefing | ✅ | 9:16 | UI-heavy |
| A4 | **Beat 3.3** Pre-stage briefing w/ Catalyst | 🛠 | 9:16 | NEW v1.2 |
| A5 | **Beat 4.3** Wave 1 mid-fight (combat read) | ✅ | 9:16 | refined |
| A6 | **Beat 4.5** Forge Draft 3-card (normal wave) | ✅ | 9:16 | refined |
| A7 | **Beat 4.6** Forge Draft 5-card (boss prep) | ✅ | 9:16 | NEW v1.2 |
| A8 | **Beat 4.9** Ult firing — AOE flash | ✅ | 9:16 | NEW v1.2 |
| A9 | **Beat 5.1** Boss banner — Slime King | ✅ | 9:16 | NEW v1.2 |
| A10 | **Beat 6.1** Stage clear popup | ✅ | 9:16 | NEW v1.2 |
| A11 | **Beat 6.2** Defeat → Home loadout | ✅ | 9:16 | UI-heavy |
| A12 | **Beat 7.1** Elara unlock cinematic | ✅ | 9:16 | NEW v1.2 |
| A13 | **Beat 7.3** Hot Paladin scripted-defeat entry (S2 W3) | 📋 | 16:9 | REFRAMED — lance-crash at wave-mid, NOT W14 rescue |
| A14 | **Beat 7.4** Master Smith S10 cinematic | 📋 | 9:16 | NEW v1.2 — split from old #6 |
| A15 | **Beat 9.1** Catalyst first reveal | 🛠 | 9:16 | NEW v1.2 |
| A16 | **Beat 10.2/10.3** Part-pull reveal | 📋 | 9:16 | narrowed from old #6 |
| A17 | **Beat 8.1** Elara signature mission trigger | 📋 | 9:16 | UI-heavy |
| A18 | (end-card marketing splash) | — | 16:9 | not a prototype beat |
| B1 | D1 video Beat 3 — Iron Lich defeat | (video) | 16:9 | trailer continuity |
| B2 | D1 video Beat 5 — Hot Paladin warm-dawn rescue | (video) | 16:9 | trailer continuity |

> **UI-heavy beats (A3, A4, A11, A17)** — Niji garbles legible UI text. Use the Niji output as a hero-art backdrop only; composite buttons/currency/modals in Figma. Use Gemini nano-banana renders in `d1-beat-mockups/2e-beats-v2/` for full-UI mockups.

---

## 6. Render priority (highest narrative + marketing value first)

**P0 — render first (5 beats):** A0 Key Art · A13 Hot Paladin · A15 Catalyst reveal · A12 Elara unlock · A18 End card.
**P1 — combat spine (4 beats):** A5 Combat read · A8 Ult firing · A9 Boss banner · A2 Pull reveal.
**P2 — journey filler (5 beats):** A1 Home · A6 3-card draft · A7 5-card draft · A10 Stage clear · A14 Master Smith.
**P3 — UI-heavy (4 beats):** A3 Briefing · A4 Briefing+Catalyst · A11 Defeat·loadout · A17 Elara mission.
**Track B — only render if cutting the D1 trailer:** B1 · B2.

---

# TRACK A — PROTOTYPE SCREEN BEATS

## A0. KEY ART — marketing splash (16:9, cinematic)

> Not a prototype beat. Marketing splash. Used for store hero image / ad creative.

```
anime mobile RPG marketing key art, four lit heroes flanking an ornate slot-machine forge wheel mid-spin throwing ember sparks, three shadow-silhouette hero slots in background, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, half-realistic anime male warrior with white spiky anime hair and navy-and-gold breastplate with dark teal trim mid-swing with glowing fire katana on far left, half-realistic anime female mage with long flowing silver hair and blue-teal robes with arcane trim holding cyan crystal staff with frost particles around her, half-realistic anime female rogue with purple hair and dark hood holding twin violet-electric daggers crossed, half-realistic anime female warrior-priestess with blonde braided hair and ornate storm-blue plate armor with halo motif holding two-handed glowing storm-blue greatsword planted point-down on right, deep indigo and slate background fading to warm forge-orange center, dramatic god-rays piercing through, gold legendary frame around the reel, anvil-and-gear motif, floating ember confetti, strong rim-lights matching elements warm gold on warrior cyan on mage violet on rogue storm-blue on paladin, cinematic key-art lighting, chromatic-aberration glow on edges, premium gacha hero-collector splash, dynamic dramatic composition, high detail

--ar 16:9 --niji 7 --stylize 350 --style scenic --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## A1. Beat 2.1 — HOME, fresh account (9:16) — ✅ shipped

> **Player journey:** lands here after FTUE grant. 5 Ember = exactly one free pull. All three starters equipped, armory empty. **Next beat:** A2 (tap PULL) or A3 (tap START BATTLE).

```
anime mobile RPG home meta screen, vertical phone aspect, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, warm forge interior backdrop with anvil and orange brazier glow softly out of focus, top status strip showing small Ember flame icon Forge Shard wrench icon gem crystal icon and stage castle icon, three squad portrait cards in a vertical column on the left side showing half-realistic anime male warrior with white spiky anime hair holding glowing fire katana, half-realistic anime female mage with long flowing silver hair holding cyan crystal staff, and half-realistic anime female rogue with purple hair and dark hood holding twin violet electric daggers, each card has a small element badge corner glyph, on the right side a vertical 2x3 empty armory grid with faint rune outline placeholders, large gold-bordered FORGE WHEEL PULL button at lower-center with an ornate anvil-and-gear motif and a small ember-flame icon, START BATTLE button below it with a sword silhouette, deep indigo and slate panels with gold accents and warm ember-orange highlights, premium gacha mobile RPG aesthetic

--ar 9:16 --niji 7 --stylize 200 --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

> **Niji caveat:** real button text + currency numbers will garble. Composite real labels in Figma.

---

## A2. Beat 2.5 — FORGE WHEEL pull reveal, NEW weapon (9:16) — ✅ shipped

> **Continues from:** A1 (player tapped PULL). **Next beat:** A1 (back to Home) or A3 (next stage briefing).

```
anime mobile RPG forge wheel pull reveal moment, vertical phone aspect, half-realistic anime cel-shaded 3D in Honkai Star Rail style with painterly background, dark forge interior with brazier glow and anvil silhouette receding into the background, single tall vertical slot-machine reel center frame with rune-engraved metal sides just slammed down landing on a glowing weapon banner card in a gold legendary frame, weapon shown is a glowing fire-imbued katana floating in front of the frame with bright god-rays radiating outward and ember confetti particles flying, lower right shows half-realistic anime male warrior bust portrait with white spiky anime hair and navy-and-gold breastplate with dark teal trim reacting with a proud stoic smile, deep indigo and slate palette with warm gold legendary glow and orange ember accents, premium gacha jackpot moment, dramatic key-art lighting

--ar 9:16 --niji 7 --stylize 300 --style scenic --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## A3. Beat 3.1/3.2 — PRE-STAGE BRIEFING (9:16) — ✅ shipped, ⚠ UI-heavy

> **Continues from:** A1 (player tapped START BATTLE). **Next beat:** A5 (combat read). Stage 1 mirrors boss affinity (teaching pattern); stage 2+ shows spread + conflict warning.

```
anime mobile RPG pre-stage briefing screen, vertical phone aspect, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, parchment-style affinity panel at top showing minion element weakness icon and boss element weakness icon side by side using small element rune glyphs only, three half-realistic anime hero portrait cards in a horizontal row below showing half-realistic anime male warrior with white spiky anime hair and fire katana, half-realistic anime female mage with long silver hair and cyan crystal staff, and half-realistic anime female rogue with purple hair and violet electric daggers, each card has a small element badge in the corner with element rune glyph, warm forge-room background with anvil and brazier blur in distance, painterly stone tile floor, drifting ember motes, deep indigo and slate UI panels with gold accents, premium gacha mobile RPG aesthetic

--ar 9:16 --niji 7 --stylize 200 --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

> **Niji caveat:** use as backdrop, composite real UI in Figma.

---

## A4. Beat 3.3 — PRE-STAGE BRIEFING with Catalyst axis (9:16) — 🛠 in-flight

> **Continues from:** A3 (stage 5+ version). Player has built a Catalyst-eligible squad → catalyst card appears below briefing. **Next beat:** A5 with the persistent A15 chip surfacing in combat HUD.

```
anime mobile RPG pre-stage briefing screen with Catalyst panel, vertical phone aspect, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, parchment affinity panel at top with minion + boss element weakness rune icons, three half-realistic anime hero portrait cards in a horizontal row showing half-realistic anime male warrior with white spiky anime hair and fire katana, half-realistic anime female mage with long silver hair and cyan staff, and half-realistic anime female rogue with purple hair and violet daggers, each with a small element badge corner glyph, below them a glowing CATALYST panel with an ornate violet-and-gold frame containing three stacked compound-pair badges each showing two small element rune glyphs combined (fire+ice, fire+wind, ice+wind), faint particle-link arcs between the matching hero portraits and the catalyst panel showing which elements are feeding which compound, warm forge-room background with anvil silhouette in the distance, painterly stone floor, drifting ember motes, deep indigo and slate palette with violet catalyst accent and gold trim, premium gacha mobile RPG aesthetic

--ar 9:16 --niji 7 --stylize 200 --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## A5. Beat 4.3 — WAVE MID-FIGHT, combat read (9:16) — ✅ shipped

> **Continues from:** A3 / A4. **Next beat:** A6 (kill-meter fills → draft modal opens).

```
anime mobile RPG gameplay screenshot, vertical phone aspect, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, mid-wave combat side-view arena, three locked-position half-realistic anime heroes on the LEFT side facing right — half-realistic anime male warrior with white spiky anime hair in navy-and-gold breastplate with dark teal trim mid-swing with glowing fire katana, half-realistic anime female mage with long silver hair in blue-teal robes on an elevated platform behind firing a cyan frost beam from her crystal staff, half-realistic anime female rogue with purple hair and dark hood in low crouch with twin violet electric daggers — small green slimes (clearly smaller than the heroes, simple eyes, NOT cute mascot style) and dark-robed skeleton warriors and a back-row green goblin shaman with crooked staff pouring in from the RIGHT side, one slime bursting into bright cyan XP gem cubes, stylized damage numbers floating, painterly stone arena floor, drifting ember motes, three hero portrait avatars at bottom with glowing ult-gauge rings, deep indigo and slate palette, warm gold rim-light on warrior cyan on mage violet on rogue lime-green slime accents, dynamic combat composition

--ar 9:16 --niji 7 --stylize 250 --style expressive --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## A6. Beat 4.5 — FORGE DRAFT, 3 cards (9:16) — ✅ shipped

> **Continues from:** A5 (kill-meter full → combat freezes → modal opens). **Next beat:** card flies to hero pip row → A5 resumes.

```
anime mobile RPG forge draft modal screen, vertical phone aspect, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, dimmed combat arena background showing three paused half-realistic anime heroes (white-spiky-hair warrior, silver-haired mage, purple-haired rogue) holding mid-pose, large modal sliding up from bottom covering lower half, three vertical glowing skill cards side by side with tier-colored borders red common violet rare and blue common, center violet card glowing brightest with a tooltip arrow above it showing a triple cyclone mini-preview icon, particle motes around the rare card, deep indigo and slate palette with violet rare highlight, premium gacha mobile RPG aesthetic, dramatic UI moment

--ar 9:16 --niji 7 --stylize 250 --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## A7. Beat 4.6 — FORGE DRAFT, 5 cards (BOSS WAVE) (9:16) — ✅ shipped

> **Continues from:** A5 wave 5 / boss wave. Larger pick — 5 cards for boss prep, includes boss telegraph callout. **Next beat:** A9 boss banner.

```
anime mobile RPG forge draft modal screen boss prep variant, vertical phone aspect, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, dimmed combat arena background showing three paused half-realistic anime heroes holding mid-pose, expanded modal covering most of the lower half, FIVE vertical glowing skill cards side by side with tier-colored borders red common red common violet rare blue common gold legendary creating a power-pick moment, gold legendary card on the right glowing brightest with a tooltip arrow above it and a dramatic ember-confetti burst, small boss telegraph banner panel at the top showing the Slime King boss icon silhouette with a small warning sigil, particle motes drifting across the modal, deep indigo and slate palette with gold legendary highlight, dramatic UI moment, premium gacha mobile RPG aesthetic

--ar 9:16 --niji 7 --stylize 250 --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## A8. Beat 4.9 — ULT FIRING, AOE flash (9:16) — ✅ shipped

> **Continues from:** A5 (player tapped Bran's ULT button while glowing). Single frame mid-spin. **Next beat:** A5 resumes after 0.1s hit-pause.

```
anime mobile RPG ultimate ability finisher moment, vertical phone aspect, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, side-view arena framing, half-realistic anime male warrior with white spiky anime hair in navy-and-gold breastplate with dark teal trim center-frame mid-Whirlwind ultimate spinning his glowing fire katana around himself creating a swirling fire-storm vortex outward, three small green slimes (clearly smaller than the hero, simple eyes, NOT cute mascot style) and dark-robed skeleton warriors caught in the AOE around him with stylized red damage numbers floating above each, screen radiating outward with motion-blur lines, ember sparks flying everywhere, half-realistic anime female mage with long silver hair and half-realistic anime female rogue with purple hair on either side reacting watching, hit-pause freeze-frame intensity, painterly stone arena floor cracked from impact, deep indigo and slate palette with bright warm gold and orange fire-storm vortex accents, dynamic key-frame composition

--ar 9:16 --niji 7 --stylize 300 --style expressive --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## A9. Beat 5.1 — BOSS BANNER, Slime King entry (9:16) — ✅ shipped

> **Continues from:** A7 (5-card draft picked). 1.5s banner before boss fight begins. **Next beat:** A5 boss-variant or A11 defeat.

```
anime mobile RPG boss entry banner moment, vertical phone aspect, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, dramatic centre-frame banner introducing the Slime King boss, giant emerald slime boss with crown of bone and jelly translucency and a lazy menacing grin filling the upper two-thirds of the frame on the RIGHT side, three small half-realistic anime hero silhouettes on the LEFT lower-third in defensive stance — half-realistic anime male warrior with white spiky anime hair, half-realistic anime female mage with long silver hair, half-realistic anime female rogue with purple hair — looking up at the boss, dramatic gold-bordered horizontal boss-banner overlay across the middle with a fire weakness rune icon and ice resist rune icon small in the corners of the banner, dust kicked up around the boss feet, deep indigo and slate palette with vivid emerald-green boss accent and warm gold banner trim, dramatic low-angle composition

--ar 9:16 --niji 7 --stylize 300 --style scenic --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## A10. Beat 6.1 — STAGE CLEAR popup (9:16) — ✅ shipped

> **Continues from:** A5 / A9 (boss dies). Auto-routes to A1 Home after ~1s. **Next beat:** A1.

```
anime mobile RPG stage clear victory popup, vertical phone aspect, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, warm orange-gold celebration burst centre-frame, three half-realistic anime heroes — half-realistic anime male warrior with white spiky anime hair raising glowing fire katana, half-realistic anime female mage with long silver hair holding cyan staff up, half-realistic anime female rogue with purple hair flicking twin violet daggers — standing in triumphant pose on a cleared painterly stone arena, gold confetti and ember sparks bursting outward, reward strip floating above showing small Ember flame icon Forge Shard wrench icon gold coin icon in a horizontal row each in a small gold-frame badge, dramatic god-rays piercing through from upper-right, deep indigo and slate background with brilliant warm gold victory accent, premium gacha celebratory moment, high-key lighting

--ar 9:16 --niji 7 --stylize 250 --style scenic --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## A11. Beat 6.2 — DEFEAT → Home loadout (9:16) — ✅ shipped, ⚠ UI-heavy

> **Continues from:** A5 / A9 (squad wipes — no retry modal per spec, sidesteps FM-14). Stage NOT incremented. **Next beat:** A1 Home (adjust loadout).

```
anime mobile RPG defeat screen returning to home loadout, vertical phone aspect, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, muted indigo background with subtle red vignette edges and somber defeat mood, three half-realistic anime hero portrait cards in a vertical column on the left showing half-realistic anime male warrior with white spiky anime hair (slightly dimmer), half-realistic anime female mage with long silver hair (slightly dimmer), and half-realistic anime female rogue with purple hair (slightly dimmer), each card with a small element badge corner glyph, on the right a vertical weapon armory grid with three weapon thumbnails one being a glowing fire katana subtly highlighted as the suggested swap with a soft gold pulsing border, faint diagnostic affinity strip at the top showing a slime king minion icon with crossed-out ice element rune, deep indigo and slate panels with soft red defeat vignette and gold highlight on suggested action, premium gacha mobile RPG aesthetic

--ar 9:16 --niji 7 --stylize 200 --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

> **Niji caveat:** UI text composite in Figma.

---

## A12. Beat 7.1 — ELARA UNLOCK cinematic (9:16) — ✅ shipped

> **Continues from:** A5 stage 1 wave 3. Cinematic stinger interrupts wave. **Next beat:** A5 resumes (Elara now in squad).

```
anime mobile RPG hero unlock cinematic stinger, vertical phone aspect, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, half-body portrait shot of half-realistic anime female mage Elara with long flowing silver hair in blue-teal robes with arcane trim holding her cyan crystal staff vertical with calm composed expression and a faint warm half-smile, ornate frost-themed painterly background with floating ice crystals snowflake motifs and faint blue arcane runes glowing around her, gold legendary frame border around the portrait, "NEW HERO" style golden ribbon banner curling across the upper-left corner of the frame (no readable text — design as an empty ornamental ribbon shape), warm rim-light catching her silver hair and cyan staff, ember motes drifting in front, deep indigo and slate background with cool blue-teal hero highlight and warm gold legendary frame accents, cinematic intro lighting, premium gacha hero-collector moment

--ar 9:16 --niji 7 --stylize 300 --style expressive --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## A13. Beat 7.3 — HOT PALADIN scripted-defeat entry (16:9, cinematic, make-or-break) — 📋 queued

> **Continues from:** A5 stage 2 wave 3 mid-fight. Squad fights as normal → wave-mid trigger fires → lance crashes down, Paladin descends, dialogue line stinger, paladin's ult overrides → wave wipes → roster unlock popup. **REFRAMED from v1.1 (was the W14 warm-dawn rescue — that's now Track B2).**

```
anime mobile RPG cinematic hero arrival moment, mid-fight scripted entry, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, side-view arena framing, in the CENTRE-FRAME half-realistic anime female warrior-priestess Hot Paladin with blonde braided hair in ornate storm-blue plate armor with halo motif has just descended landing in a low ground-impact pose with her two-handed glowing storm-blue greatsword planted point-down through the cracked tile floor sending a circular shockwave of dust and storm-blue energy outward, the LANCE/sword strike has stunned the wave of enemies around her — small green slimes (clearly smaller than her, simple eyes, NOT cute mascot style) and dark-robed skeleton warriors flying backward off-balance and dissolving into cyan XP gem cubes — on the LEFT side three half-realistic anime heroes (half-realistic anime male warrior with white spiky anime hair holding fire katana, half-realistic anime female mage with long silver hair holding cyan staff, half-realistic anime female rogue with purple hair with twin violet daggers) frozen in surprise watching her, warm gold halo-light fans outward from the Paladin's planted sword catching all four heroes faces, ember motes and dust swirling, painterly stone arena floor cracked from the impact, deep indigo and slate background with brilliant storm-blue energy radial and warm gold halo accents, dramatic low-angle cinematic key-art lighting

--ar 16:9 --niji 7 --stylize 350 --style scenic --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

> **Make-or-break beat.** Spend 4-6 generations to nail Paladin's planted-sword pose + storm-blue shockwave. Use `--style expressive` as alt try.

---

## A14. Beat 7.4 — MASTER SMITH S10 cinematic (9:16) — 📋 queued

> **Continues from:** A10 Stage 10 clear. Old smith reveals second wheel + Phase 1 forge unlocks. **Next beat:** A16 Part-pull.

```
anime mobile RPG master smith reveal cinematic, vertical phone aspect, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, dramatic warm forge interior background with deep crafting atmosphere and orange forge-glow filling the lower half, half-realistic anime grizzled male blacksmith Master Smith in leather apron centre-frame at his anvil with his hammer raised mid-strike striking sparks off a glowing fire katana on the anvil, behind him on the back wall a second larger ornate slot-machine reel frame is being uncovered with a rune-engraved metal frame and faint glow rays of light emerging from behind a falling cloth drape revealing it, scattered weapon parts on shelves and tool racks around the workshop with hammers tongs and rune-engraved metal stock, ember sparks flying everywhere around the anvil strike, deep indigo and slate background fading into warm orange forge-glow with brilliant gold legendary glow on the reveal reel and ember accents, dramatic key-art reveal lighting, premium gacha cinematic moment

--ar 9:16 --niji 7 --stylize 300 --style scenic --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## A15. Beat 9.1 — CATALYST first reveal (9:16) — 🛠 in-flight

> **Continues from:** A2 (scripted pull #3 lands Ice-Elara) → A1 (player equips on Elara) → reveal popup fires. **Next beat:** A4 (next stage briefing now shows Catalyst panel) + persistent in-battle chip.

```
anime mobile RPG catalyst discovery popup moment, vertical phone aspect, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, dimmed Home background out of focus, large gold-and-violet ornate popup frame centre-screen, inside the frame a glowing CATALYST compound badge showing two element rune glyphs (a fire flame rune and an ice snowflake rune) merging together at the centre into a unified glowing fire-frost sigil, dramatic radial god-rays bursting outward from the sigil, ember sparks and frost crystals drifting outward in opposing arcs, two small bust portraits at the bottom of the popup frame showing half-realistic anime male warrior Bran with white spiky anime hair on the left and half-realistic anime female mage Elara with long silver hair on the right both reacting with subtle surprise expressions, codex-tracker badge in the upper corner of the popup (small ornamental shield shape, no readable text), deep indigo and slate background with brilliant warm gold and violet catalyst accent and bright fire-frost sigil glow, dramatic discovery-moment lighting, premium gacha reveal aesthetic

--ar 9:16 --niji 7 --stylize 300 --style scenic --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## A16. Beat 10.2/10.3 — PART PULL reveal (9:16) — 📋 queued

> **Continues from:** A14 (S10 unlocks Phase 1). Player picks target slot (head/hilt/rune) → spends gems → epic part reveals + Forge Math diff applies. **Next beat:** A1 Home.

```
anime mobile RPG master smith part pull reveal moment, vertical phone aspect, half-realistic anime cel-shaded 3D in Honkai Star Rail style with painterly background, warm forge interior background with deep crafting atmosphere and orange forge-glow, centre-frame an EPIC weapon part floating in a violet legendary frame with bright purple god-rays radiating outward — the part is a pyro-themed warrior helmet visor with engraved fire-rune motif, half-realistic anime grizzled male blacksmith Master Smith on the lower-left in leather apron with hammer in hand approving the result, horizontal rarity ladder strip below the part frame showing five slot pips Common Rare Epic Legendary Mythic with a small katana token positioned on the Epic slot glowing, faint Forge Math diff indicator overlay at top corner showing two small chevron arrows (a "+2" diff visual without readable numbers), ember sparks and purple particle confetti flying around the part, deep indigo and slate background with brilliant violet epic accent and warm orange forge-glow ember accents, dramatic key-art reveal lighting

--ar 9:16 --niji 7 --stylize 250 --style scenic --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## A17. Beat 8.1 — ELARA signature mission trigger (9:16) — 📋 queued, ⚠ UI-heavy

> **Continues from:** A5 / A9 (Elara crit-kills the stage boss). Triggers once per save. **Next beat:** A1 Home with quest now in-progress.

```
anime mobile RPG hero signature mission trigger panel, vertical phone aspect, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, half-body half-realistic anime female mage Elara with long flowing silver hair in blue-teal robes with arcane trim holding her cyan crystal staff vertical on the left side with a faint curious-troubled expression as if she just felt something new, ornate frost-themed painterly background with floating ice crystals and snowflake motifs and faint awakening violet meteor-energy sparks beginning to drift in among the frost (foreshadowing the talent unlock), narrative panel frame on the right side with an ornate gold trim and parchment texture, three quest objective rows in the middle each with a small frost-themed icon, reward preview bar at the bottom showing two glowing items a mythic frostfire staff weapon thumbnail in gold-purple frame and an evolved hero portrait thumbnail, cool blue-teal palette dominant with warm gold reward accents and faint violet meteor sparks awakening accent, premium gacha mobile RPG aesthetic

--ar 9:16 --niji 7 --stylize 250 --style expressive --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

> **Niji caveat:** treat as backdrop, composite UI panels in Figma.

---

## A18. END CARD — marketing splash (16:9)

> Not a prototype beat. Roster grid + logo + CTA for the D1 video close (D1 video script Beat END).

```
anime mobile RPG marketing end card, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, four lit half-realistic anime heroes side by side on the LEFT with three shadow silhouette hero slots barely visible behind them, on the RIGHT a slot-machine forge wheel mid-spin throwing ember sparks with a glowing fire katana floating in front in a gold legendary frame radiating light rays, half-realistic anime male warrior with white spiky anime hair and navy-and-gold breastplate with fire katana raised, half-realistic anime female mage with long silver hair holding glowing cyan staff, half-realistic anime female rogue with purple hair and dark hood with twin violet daggers crossed, half-realistic anime female warrior-priestess with blonde braided hair and ornate storm-blue plate armor with storm-blue greatsword pointed up, deep indigo background with strong rim-lights matching elements warm gold cyan violet and storm-blue dramatic god-rays behind the forge wheel ember confetti, cinematic marketing splash, premium gacha hero-collector aesthetic

--ar 16:9 --niji 7 --stylize 300 --style scenic --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

# TRACK B — D1 MARKETING VIDEO BEATS

> Only render these if cutting the 60s D1 trailer per `D1-gameplay-video-script.md`. These are NOT prototype screen-states.

## B1. D1 Beat 3 — Iron Lich's Herald defeat (16:9, cinematic)

> D1 video beat at 0:34–0:45. Scripted loss (no analogue in the prototype storyboard). The Hot Paladin rescue (B2) follows this beat in the trailer.

```
anime cinematic boss defeat scene, dark fantasy mobile RPG, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, towering dark wraith-lich Iron Lich's Herald with skeletal crowned face and blue-black necrotic energy radiating from a raised staff on the RIGHT side filling half the frame, recent shockwave of dark energy mist still expanding outward, on the LEFT side aftermath shows half-realistic anime male warrior with white spiky anime hair in navy-and-gold breastplate fallen to one knee with fire katana planted in cracked tile head bowed, half-realistic anime female mage with long silver hair thrown back on her side with cyan staff dropped, half-realistic anime female rogue with purple hair and dark hood slumped against rubble with violet daggers down, cracked floor tiles dust and faint red low-HP vignette over the edges, deep indigo and slate palette with blue-black necrotic accents and small red edge vignette, narrative defeat mood, cinematic low-angle composition

--ar 16:9 --niji 7 --stylize 300 --style scenic --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

---

## B2. D1 Beat 5 — Hot Paladin warm-dawn rescue (16:9, cinematic, make-or-break)

> D1 video beat at 0:45–0:58. Hot Paladin strides in at ground level through smoke, plants greatsword, warm dawn breaks. Distinct from A13 (which is mid-fight lance-crash at S2 W3).

```
anime cinematic rescue scene, mobile RPG cinematic frame, half-realistic anime cel-shaded 3D characters in Honkai Star Rail style with painterly background, on the LEFT THIRD aftermath of defeat shows half-realistic anime male warrior with white spiky anime hair in navy-and-gold breastplate propped on his planted fire katana head low but alive, half-realistic anime female mage with long silver hair on her knees beside him with cyan staff in her lap, half-realistic anime female rogue with purple hair and dark hood slumped against rubble with violet daggers loose, all three dejected on cracked tile floor with faint dust settling, in the background a dark wraith-lich shadow recedes into the distance on the far right, in the CENTER-RIGHT a half-realistic anime female warrior-priestess with blonde braided hair in ornate storm-blue plate armor with halo motif strides in at ground level through the smoke with her two-handed glowing storm-blue greatsword planted point-down both gauntlets resting on the pommel, storm-blue blade-glow catches the heroes faces with warm rim-light, warm dawn breaking through the haze on the horizon with faint golden sun-rays piercing through, ember motes drifting in warm light, deep indigo and slate palette transitioning to warm dawn gold and storm-blue, emotional cinematic key-art lighting, low angle slow push-in composition

--ar 16:9 --niji 7 --stylize 350 --style scenic --no text, words, letters, logos, watermarks, signature, artist name, chibi, chibi-cute, kawaii-mascot, sticker style, ugly hands, deformed fingers, six fingers, extra fingers, melted weapon, blurry faces, photorealism, western cartoon, grimdark, oversaturated
```

> **Make-or-break beat for the trailer.** Spend 4-6 generations.

---

## Workflow guide

### Step 1 — first pass per beat
1. Paste prompt into Midjourney Discord `/imagine` or web
2. Get 4-grid
3. Pick best frame → `Vary (Subtle)` if close, `Vary (Strong)` if needs adjustment

### Step 2 — character consistency lock (mandatory for hero beats)
1. Upload `docs/research/d1-beat-mockups/style-test/style2E-cel-3d-PRO.png` (or a chosen v2 hero render) to a public host
2. Add to prompt: `--oref <public-url> --ow 100`
3. Re-run hero-focused beats (A2, A5, A8, A12, A13, A14, A15, B2, Key Art, End Card)

### Step 3 — UI beats (A3, A4, A11, A17)
1. Generate hero-art backdrop with Niji
2. Composite UI panels / buttons / currency / modals in Figma or Photoshop
3. Use Gemini nano-banana for full-UI mockups in parallel (already done for v1 set in `d1-beat-mockups/2e-beats-v2/`)

### Step 4 — upscale + export
1. `Upscale (Subtle)` for clean delivery
2. Export 16:9 at 1920×1080 or 9:16 at 1080×1920
3. Save to `docs/research/d1-beat-mockups/niji7-beats/`

---

## Cost estimate

| Plan | Cost | Capacity |
|---|---|---|
| MJ Basic ($10/mo) | ~3.3 hrs fast / month | enough for 1-pass on P0+P1 beats only |
| MJ Standard ($30/mo) | ~15 hrs fast / month | full iteration on all ~20 beats + retries |
| MJ Pro ($60/mo) | ~30 hrs fast / month | overkill for this scope |

**Recommended:** Standard. Allows 4-6 retries per beat + `--oref` consistency loops on the make-or-break beats (A13, B2, Key Art).

---

## Quality bar

| Pass | What counts as "ship" |
|---|---|
| Niji first pass | Composition right, character lookalikes recognizable, palette correct, no chibi heroes |
| Niji + `--oref` | Bran/Elara/Vex/Hot Paladin/Master Smith all read as the SAME characters across beats (faces don't drift) |
| Continuity audit | Walking through A1→A18 should feel like the player journey (Home → Pull → Briefing → Combat → Draft → Boss → Clear / Defeat → Hero unlock cinematics → Catalyst reveal → S10 Master Smith → Part pull → Elara arc → End card). Mismatches between beat → next beat = re-render. |
| Final ship | Adversarial review against Art Bible §11 Continuity Sheet — every callout matches |

---

## Change log

| Date | Change |
|---|---|
| 2026-06-09 (v1.2) | **Continuity restructure.** Aligned to `prototype-screen-beats.md` canonical beat IDs. Renumbered all beats to storyboard IDs (A0–A18). Re-ordered to player-journey sequence. Added 10 new beats: A1 Home, A4 Briefing-w/-Catalyst, A7 5-card draft, A8 Ult firing, A9 Boss banner, A10 Stage clear, A12 Elara unlock, A14 Master Smith, A15 Catalyst reveal, A16 Part-pull. **Reframed A13:** Hot Paladin entry is the scripted-defeat at S2 W3 lance-crash (per storyboard Beat 7.3), NOT the W14 warm-dawn rescue (that's now Track B2, D1-video-only). Split old "Master Smith / Part Pull" combo into A14 (cinematic) + A16 (part-pull). Added Track B for D1 trailer-only beats. Added render priority (P0–P3). Added beat-ID map table. Added "Continues from / Next beat" notes to every prompt for journey threading. |
| 2026-06-09 (v1.1) | Cohesion audit. Stripped "chibi-leaning" from #1. Added "half-realistic anime" verbatim to every hero/NPC mention. Standardized `--no` block + `--stylize` tiers + `--style` modifiers. Clarified enemy proportions (smaller, NOT cute-mascot). |
| 2026-06-09 (v1.0) | Initial 11-prompt set. |

---

*End of Niji 7 prompt reference v1.2. Source-of-truth: `../../docs/prototype-screen-beats.md` (beat IDs) + `../art-bible/art_direction.md` v1.0 (cast + palette + style).*
