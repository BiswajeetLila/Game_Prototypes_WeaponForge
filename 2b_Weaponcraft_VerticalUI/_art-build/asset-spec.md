# WeaponCraft — Asset Spec (synthetic art set)

**Anchor / ref-lock for every item:** `https://i.ibb.co/zhz3TFPq/Gemini-Generated-Image-dhm62ndhm62ndhm6.png` (via `edit_image`, style+palette+framing locked to it).
**Model:** `nano-banana` (base) for ALL items — per user cost policy (no pro).
**Style truth:** `style-bible.md`. **Roster:** Bran / Elara / Vex (NOT the ref's names).
**Mockup rule:** exact in-game screenshot — real functional HUD only, **no titles / banners / logos / marketing words.** Vertical 9:16 unless noted.

| id | bucket | screen | aspect | variants |
|---|---|---|---|---|
| run_01 | mockup | RUN / combat+forge | 9:16 | 1 |
| home_01 | ui-frame | HOME / roster | 9:16 | 1 |
| squad_01 | ui-frame | Squad-select | 9:16 | 1 |
| pull_01 | ui-frame | Scripted hero-pull reveal | 9:16 | 1 |
| result_01 | ui-frame | Result / rewards | 9:16 | 1 |
| keyart_01 | key art | marketing splash *(optional)* | 16:9 | 1 |
| icon_01..03 | icon | app icon *(optional)* | 1:1 | 3 |

---

## Prompts (hierarchical, ref-locked)

### run_01 — RUN / combat+forge
> Vertical 9:16 mobile **gameplay screenshot**, same UI style/palette/layout as the reference. TOP: side-view combat band — three chibi heroes on the left (Bran the boy warrior with sword, Elara the silver-blue-haired ice mage with staff, Vex the violet-haired hooded rogue with daggers) facing a green slime and a goblin on the right, a chunky yellow "320 CRIT!" damage number, a dark battle-log bar reading "Elara casts Frostbolt!". MIDDLE: a row of three rounded hero cards (portrait + green HP bar + orange ULT bar); below, the wooden ANVIL with three labeled slots HEAD / HILT / RUNE holding element-tinted part icons with green +ATK text; two violet recipe pills "Inferno" and "Steamburst". A big green START WAVE button with crossed swords. BOTTOM: shop strip with a gold coin badge and a row of five element-tinted part cards. Warm wood/parchment, cozy hand-painted cel-shaded, Cookie Run × Wittle style. No title text, no banner.

### home_01 — HOME / roster
> Vertical 9:16 mobile **home screen**, same cozy wood/parchment UI as the reference. TOP bar: gold coin badge + gem badge + a stamina pip row. CENTER: a "Heroes" roster grid of rounded portrait cards — Bran, Elara, Vex shown unlocked (each with a small level badge like "Lv 4" and a green class pip), plus 3–4 dimmed locked "?" slots. One hero highlighted as the selected/favored. BOTTOM: a wooden "FORM SQUAD" label with three empty squad slots and a big green BATTLE button. Hand-painted cel-shaded, warm palette, real functional HUD, no title/banner/marketing text.

### squad_01 — Squad-select
> Vertical 9:16 mobile **squad-select screen**, same wood/parchment UI. A grid of owned hero portrait cards (Bran, Elara, Vex + a couple dimmed locked slots) at top; three large highlighted "deploy" slots across the middle showing the 3 picked heroes with a glowing green selected rim; each picked hero shows HP/ATK mini-stats and class icon. A big green CONFIRM / DEPLOY button at the bottom, a back arrow top-left. Cozy hand-painted style, functional HUD only, no banner text.

### pull_01 — Scripted hero-pull reveal
> Vertical 9:16 mobile **gacha reveal moment**, same warm palette but with a celebratory forge-light burst. CENTER: a single large hero card erupting from a glowing anvil/forge-wheel with radiant golden light rays, confetti and sparkle particles, a rarity-colored frame (epic violet). The revealed hero is Vex the violet-haired rogue in a heroic pose. A chunky in-game "NEW HERO!" label above the card and a small star-rarity row below (functional reveal UI, not a marketing banner). A "TAP TO CONTINUE" hint at the bottom. Dramatic warm lighting, hand-painted cel-shaded, cozy not gritty.

### result_01 — Result / rewards
> Vertical 9:16 mobile **victory results screen**, same wood/parchment UI. A "VICTORY" ribbon banner at top (in-game UI ribbon), the three heroes (Bran, Elara, Vex) celebrating in a small band below it. CENTER: a rewards list panel — gold coins earned, a hero-XP bar ticking up with a small "+XP" on each hero portrait, a couple of part/shard reward icons. A big green CONTINUE button at the bottom. Warm, cheerful, hand-painted cel-shaded, functional HUD, no marketing copy.

### keyart_01 — key art (optional)
> Landscape 16:9 **marketing key art** (cinematic, NOT a gameplay screenshot). The three heroes — Bran, Elara, Vex — in a heroic hero-shot at a glowing forge/anvil, weapons crafted and gleaming, cute monsters silhouetted in the background, warm torch-lit fantasy palette, painterly cel-shaded splash-art energy, dynamic composition. Cookie Run / Brawl Stars splash register. Title space left clear (no text).

### icon_01..03 — app icon (optional, 3 variants on named axes)
> 1024×1024 **app icon**, no text, high click-intent, legible at 88px.
> - **icon_01 (object):** a single glowing crafted sword/weapon rising from a wooden anvil with sparks, warm rim light.
> - **icon_02 (hero):** Bran the chibi warrior grinning, holding a freshly forged glowing sword, bold silhouette.
> - **icon_03 (rune):** a single radiant element rune-gem (fire-orange) with forge sparks, iconic + simple.
> Post-process: rounded squircle PNG.
