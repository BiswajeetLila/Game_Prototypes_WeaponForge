# WeaponForge — nano-banana + ChatGPT screen-beat prompts (v1.3 — 2e-beats lessons)

**Source-of-truth refs:**
- `2e-beats/` PNGs in this folder = the BEST renders we ever produced (analysis below)
- `../../docs/prototype-screen-beats.md` (canonical beat IDs)
- `../art-bible/art_direction.md` v1.0 (Art Bible)

**Models:**
- **nano-banana** = Gemini 2.5 Flash Image (~$0.04/img) — DEFAULT per global cost policy
- **nano-banana-pro** = Gemini 3 Pro Image (~$0.18/img) — premium, ONLY when user explicitly asks
- **ChatGPT** = GPT-image-1 (~$0.05-$0.17/img) — alternate, literal layout follower

Date: 2026-06-09.

---

## CRITICAL: Why v1.3 exists — 2e-beats post-mortem

The 6 PNGs in `2e-beats/` are the strongest mobile-RPG renders this project has produced. v1.0-v1.2 + nano-story-beats LOST those qualities by over-correcting. v1.3 reverses the over-corrections.

### What 2e-beats got right that we lost

| Dimension | 2e-beats | v1.0-v1.2 + SB1-9 | v1.3 fix |
|---|---|---|---|
| **Text labels** | "STORMBLAZE KATANA / Warrior / Fire-imbued", "EPIC PART!", "WAVE 1", currency counters all rendered legibly | Banned via `--no text, letters` to avoid Niji garbling | nano-banana + ChatGPT CAN render text — bake it IN. Only Niji gets the no-text ban. |
| **Hero proportions** | Stylized ~5-6 head, casual-mobile-RPG register (Archero / Wittle Defender) | "half-realistic anime, 7-head proportions" → too Honkai, too realistic, wrong genre | Replace lock: *"stylized 2.5D cel-shaded with bold line work, slightly stylized proportions — NOT chibi, NOT super-deformed, NOT photoreal-anime — casual-mobile-RPG character art register (Archero / Wittle Defender)"* |
| **Aspect ratio** | 9:16 native mobile, store-screenshot-ready | 16:9 cinematic for story-beats, mixed for screen-beats | 9:16 DEFAULT for every screen-beat. Reserve 16:9 only for key-art + cinematic stingers. |
| **Composition** | HUD-first: pause top-left, currency top-right, wave-banner top-center, hero avatar row bottom | Single-focal moment with empty HUD | Specify HUD chrome explicitly in every prompt. |
| **Game-state floaters** | Damage numbers (450/720/330), XP gem-cube bursts, HP bars, ult rings | Mostly absent — clean cinematic | Demand floaters: damage numbers, XP cubes, HP bars, ult-gauge rings. |
| **Environment density** | Lava pours, flame braziers, weapon racks, gear-motif arch, stone columns | Sparse painterly backdrops | "Rich forge interior dense with detail" — name the props. |
| **Named assets** | "Stormblaze Katana", "Iron Lich's Herald", "Master Smith's Forge" all called out by name | Generic descriptions | Name every weapon, boss, button, screen. |
| **Layered density** | Threat + consequence + UI + game-state ALL in one frame | One focal moment per frame | Every prompt must list: action + threat + HUD + floaters + environment. |

---

## 1. Style cohesion rules (v1.3 — REVISED)

1. **Stylized 2.5D cel-shaded** with bold line work, slightly stylized proportions (NOT chibi, NOT super-deformed, NOT photoreal-anime). Casual-mobile-RPG register — closer to **Archero / Wittle Defender** than Honkai Star Rail. ~5-6 head proportions. **Heroes still recognizable but bolder/punchier than half-realistic anime.**
2. **Enemies smaller-scale for silhouette** — slimes/goblins/skeletons clearly smaller than heroes, simple but readable. Bosses (Slime King, Iron Golem, Iron Lich's Herald) full-scale dramatic.
3. **NO chibi, NO super-deformed, NO sticker-style, NO kawaii-mascot** — banned inline + in negatives.
4. **Text labels REQUIRED** for nano-banana + ChatGPT (these render text fine). Niji 7 file separately bans text.
5. **9:16 DEFAULT** for every screen-beat (mobile app-store frame).
6. **HUD chrome SPECIFIED** in every screen-beat — pause button, currency strip, wave banner, hero avatar row.
7. **Cast descriptors** (§2) copy-pasted verbatim — never paraphrased.
8. **Named assets** — call out specific weapon names, boss names, button labels, screen headers.

---

## 2. Cast verbatim (REVISED — 2.5D casual-mobile register, NOT Honkai-realistic)

| Hero / NPC | Verbatim descriptor |
|---|---|
| **Bran** | stylized 2.5D cel-shaded male warrior with bold white spiky anime hair, navy-blue armored breastplate with dark teal trim, brown leather belt, fingerless gauntlets, glowing fire-imbued katana, stoic determined expression, slightly stylized proportions (NOT chibi but punchier than realistic anime) |
| **Elara** | stylized 2.5D cel-shaded female mage with bold long flowing silver hair tied at one side, blue-teal hooded robe with arcane trim, cyan crystal-topped staff, serene composed expression, slightly stylized proportions |
| **Vex** | stylized 2.5D cel-shaded female rogue with bold purple hair, dark hood obscuring upper face, dark fitted leather outfit, twin violet-electric daggers, low confident crouching stance, slightly stylized proportions |
| **Hot Paladin** | stylized 2.5D cel-shaded female warrior-priestess with bold blonde braided hair, ornate storm-blue plate armor with halo motif and gold trim, two-handed glowing storm-blue greatsword, slightly stylized proportions |
| **Master Smith** | stylized 2.5D cel-shaded grizzled male blacksmith with bald top + grey beard + braided side-knot, leather chest harness over bare arms, heavy hammer raised over anvil, slightly stylized proportions |
| **Slime King** | giant emerald slime boss with crown of bone, jelly translucency, lazy menacing grin, full-scale dramatic |
| **Iron Lich's Herald** | towering dark wraith-lich with skeletal crowned face, blue-black necrotic energy aura, raised staff, dramatic banner-villain |
| **Slimes (minions)** | small green slime creatures with simple eyes, clearly smaller than heroes, NOT cute-mascot |

---

## 3. Universal negatives (REVISED — keeps text-ban OUT)

Append to every nano-banana / ChatGPT prompt:

```
Style guardrails: NO chibi, NO super-deformed, NO sticker-style, NO kawaii-mascot, NO photorealism, NO western cartoon line-work, NO grimdark muddy palette, NO oversaturated colors, NO deformed hands, NO six fingers, NO melted weapons, NO blurry faces. Style is stylized 2.5D cel-shaded mobile-RPG register (Archero / Wittle Defender energy), NOT Honkai-realistic, NOT painterly-soft. Crisp readable UI text on all labels — currency strips, wave banners, button text must render legibly.
```

---

## 4. Universal HUD chrome (specify in every screen-beat prompt)

Every screen-beat prompt body must include this HUD checklist (paraphrase per beat):

- **Top-left:** square pause button (white pause-icon, gold-bordered button)
- **Top-center:** gold-bordered ornate banner ribbon with screen name in serif ("WAVE 1", "FORGE WHEEL", "MASTER SMITH'S FORGE", "STAGE 1 BRIEFING", "DEFEAT")
- **Top-right:** vertical 2-row currency strip — gold-coin icon with number (e.g. "3500 GOLD"), gem-crystal icon with number (e.g. "250 GEMS") — readable sans-serif
- **Bottom row:** three circular hero portrait avatars in gold-bordered rings, each with a HP bar segment underneath + ult-gauge ring around the portrait (green when full)
- **Floaters:** damage numbers in bold yellow with red drop-shadow (e.g. "450", "720", "330"), XP gem-cube bursts in cyan when enemies die
- **Environment:** dense forge interior — lava pours, flame braziers on wall sconces, weapon racks, anvil silhouettes, stone-block walls, gear-motif arches, ember sparks drifting

---

## 5. MCP call template

```
mcp__bc7510a0-*__generate_image
  model: "nano-banana"           # default per global cost policy
  prompt: <full prompt body + cast verbatim + HUD chrome + style guardrails>
  aspect_ratio: "9:16"           # default for screen-beats
  output_dir: "5_WeaponForge_Honkai_Godot/Mockup/all-mockups/"
  filename_prefix: "A<NN>-<beat-slug>-v3"
```

---

## 6. Beat → file map (v1.3 — same A0-A18 + B1-B2 spine as v1.2)

| ID | Storyboard beat | Status | Aspect | Recommended model | Filename |
|---|---|---|---|---|---|
| A0 | Key Art marketing | — | 16:9 | nano-banana-pro (P0 — explicit approval) | `A0-key-art` |
| A1 | **2.1** Home — fresh | ✅ | 9:16 | ChatGPT (UI text-heavy) | `A1-home-fresh-v3` |
| A2 | **2.5** Forge Wheel pull reveal | ✅ | 9:16 | nano-banana | `A2-pull-reveal-v3` |
| A3 | **3.1/3.2** Pre-stage briefing | ✅ | 9:16 | ChatGPT | `A3-briefing-v3` |
| A4 | **3.3** Briefing w/ Catalyst | 🛠 | 9:16 | ChatGPT | `A4-briefing-catalyst-v3` |
| A5 | **4.3** Wave mid-fight | ✅ | 9:16 | nano-banana | `A5-combat-read-v3` |
| A6 | **4.5** Forge Draft 3-card | ✅ | 9:16 | ChatGPT | `A6-draft-3card-v3` |
| A7 | **4.6** Forge Draft 5-card boss | ✅ | 9:16 | ChatGPT | `A7-draft-5card-v3` |
| A8 | **4.9** Ult firing AOE | ✅ | 9:16 | nano-banana | `A8-ult-firing-v3` |
| A9 | **5.1** Boss banner Slime King | ✅ | 9:16 | nano-banana | `A9-boss-banner-v3` |
| A10 | **6.1** Stage clear | ✅ | 9:16 | ChatGPT | `A10-stage-clear-v3` |
| A11 | **6.2** Defeat → loadout | ✅ | 9:16 | ChatGPT | `A11-defeat-loadout-v3` |
| A12 | **7.1** Elara unlock | ✅ | 9:16 | nano-banana | `A12-elara-unlock-v3` |
| A13 | **7.3** Hot Paladin entry | 📋 | 16:9 | nano-banana-pro (P0) | `A13-paladin-entry-v3` |
| A14 | **7.4** Master Smith cinematic | 📋 | 9:16 | nano-banana | `A14-master-smith-v3` |
| A15 | **9.1** Catalyst first reveal | 🛠 | 9:16 | nano-banana | `A15-catalyst-reveal-v3` |
| A16 | **10.2/10.3** Part Pull reveal | 📋 | 9:16 | nano-banana | `A16-part-pull-v3` |
| A17 | **8.1** Elara mission trigger | 📋 | 9:16 | ChatGPT | `A17-elara-mission-v3` |
| A18 | End card marketing | — | 16:9 | nano-banana-pro (approval) | `A18-end-card-v3` |
| B1 | D1 video Iron Lich defeat | (video) | 9:16 | nano-banana | `B1-iron-lich-defeat-v3` |
| B2 | D1 video Paladin warm-dawn | (video) | 9:16 | nano-banana-pro (P0) | `B2-paladin-warm-dawn-v3` |

> **Note:** B1 + B2 dropped from 16:9 cinematic to 9:16 in v1.3 — beat3 + beat5 2e-beats proved 9:16 carries cinematic mood fine AND keeps mobile fit.

---

# TRACK A — PROTOTYPE SCREEN BEATS (v1.3)

## A1. Beat 2.1 — HOME, fresh account

**Aspect:** 9:16 · **Model:** ChatGPT · **Filename:** `A1-home-fresh-v3`

```
9:16 vertical mobile RPG home meta screen, stylized 2.5D cel-shaded mobile-RPG art register (Archero / Wittle Defender energy), NOT Honkai-realistic.

TOP-LEFT: small square pause button (white pause-icon on gold-bordered button).
TOP-CENTER: ornate gold-bordered banner ribbon labeled "WEAPONFORGE" in serif.
TOP-RIGHT: vertical 2-row currency strip — gold-coin icon "0 GOLD", gem-crystal icon "0 GEMS", small flame icon "5 EMBER".

UPPER MIDDLE: section header "SQUAD" in white serif over a thin gold underline.

THREE SQUAD CARDS stacked vertically (centered), each card is a gold-trimmed indigo panel:
- Card 1: stylized 2.5D cel-shaded male warrior Bran with bold white spiky anime hair, navy-blue armored breastplate with dark teal trim, fingerless gauntlets, holding a glowing fire katana, stoic expression, slightly stylized proportions. Label: "BRAN — Warrior". Equipped weapon icon row: fire-katana thumbnail with text "Emberfang Cleaver · ATK 18".
- Card 2: stylized 2.5D cel-shaded female mage Elara with bold long flowing silver hair, blue-teal hooded robe with arcane trim, holding cyan crystal staff, serene composure. Label: "ELARA — Mage". Equipped row: cyan-staff thumbnail "Frostcall Stave · ATK 16".
- Card 3: stylized 2.5D cel-shaded female rogue Vex with bold purple hair, dark hood, dark fitted leather, twin violet-electric daggers. Label: "VEX — Rogue". Equipped row: dagger thumbnail "Stormpierce Fangs · ATK 17".

MIDDLE: section header "ARMORY" in white serif over thin gold underline. 2x3 empty inventory grid with faint rune-outline placeholders.

LOWER CENTER: large gold-bordered button with anvil-and-gear motif, labeled "⚒ FORGE WHEEL PULL — 5 EMBER".

BOTTOM: gold-bordered button with sword silhouette, labeled "⚔ START BATTLE — STAGE 1".

BACKGROUND: dense forge interior — flame braziers in wall sconces on either side, anvil silhouettes in mid-distance, lava-glow seeping through stone block walls, gear-motif arch overhead, ember sparks drifting throughout. Deep indigo + warm forge-orange dual palette.

Style guardrails: NO chibi, NO super-deformed, NO sticker-style, NO kawaii-mascot, NO photorealism, NO western cartoon line-work, NO grimdark muddy palette, NO oversaturated colors, NO deformed hands, NO six fingers, NO melted weapons, NO blurry faces. Style is stylized 2.5D cel-shaded mobile-RPG register, NOT Honkai-realistic, NOT painterly-soft. Crisp readable UI text on all labels — currency strips, wave banners, button text must render legibly.
```

---

## A2. Beat 2.5 — FORGE WHEEL pull reveal (HERO PRODUCT SHOT)

**Aspect:** 9:16 · **Model:** nano-banana · **Filename:** `A2-pull-reveal-v3`

> Direct successor to 2e-beats/beat4-forge-wheel-pull-2E.jpg. Match that polish.

```
9:16 vertical mobile RPG forge wheel pull-reveal screen, stylized 2.5D cel-shaded mobile-RPG art register (Archero / Wittle Defender energy), NOT Honkai-realistic.

TOP-CENTER: large gold-bordered ornate banner ribbon labeled "FORGE WHEEL" in white serif.
TOP-RIGHT: currency strip — gold-coin "3500 GOLD" + gem-crystal "250 GEMS".

CENTER OF FRAME: a large rectangular weapon card floating inside an ornate gold legendary frame on a stone anvil pedestal. The card shows a beautifully designed STORMBLAZE KATANA — curved blade with fire-imbued runes glowing along the edge AND lightning glyphs arcing across the steel — rendered as a clean product-shot illustration. Below the card art, two label lines in serif: "STORMBLAZE KATANA" (large gold), then a thin gold divider, then "— Warrior —" centered, then "Fire-imbued" centered (smaller).

ABOVE THE CARD: a sharp white-gold spotlight beam shooting down onto the frame from above, with bright god-rays radiating outward.

AROUND THE CARD: multicolored confetti ribbons + ember-spark particles flying outward in slow-motion.

LOWER-RIGHT: stylized 2.5D cel-shaded male warrior Bran (bold white spiky anime hair, navy-blue armored breastplate with dark teal trim) shown chest-up reacting with a proud half-smile, gold sigil-light catching the side of his face.

LOWER-RIGHT BOTTOM (banner element): a small indigo dialogue-box with gold trim, containing white text "Bran wields the Stormblaze Katana." with "Stormblaze Katana" highlighted in gold.

BACKGROUND: dense ornate forge — gear-motif metalwork frame visible behind the wheel, lava-glow at the very bottom of the frame, ember sparks drifting throughout, stone-block columns flanking either side.

PALETTE: deep teal + indigo background, brilliant warm gold legendary glow center, orange lava + ember accents, confetti color-pop.

Style guardrails: NO chibi, NO super-deformed, NO sticker-style, NO kawaii-mascot, NO photorealism, NO western cartoon, NO grimdark, NO oversaturated, NO deformed hands, NO six fingers, NO melted weapons, NO blurry faces. Style is stylized 2.5D cel-shaded mobile-RPG register, NOT Honkai-realistic. Crisp readable UI text — "FORGE WHEEL" banner, "STORMBLAZE KATANA" card label, "Bran wields the Stormblaze Katana." dialogue all must render legibly in clean serif.
```

---

## A3. Beat 3.1/3.2 — PRE-STAGE BRIEFING

**Aspect:** 9:16 · **Model:** ChatGPT · **Filename:** `A3-briefing-v3`

```
9:16 vertical mobile RPG pre-stage briefing screen, stylized 2.5D cel-shaded mobile-RPG art register (Archero / Wittle Defender energy), NOT Honkai-realistic.

TOP-LEFT: square pause button.
TOP-CENTER: gold-bordered ornate banner ribbon labeled "STAGE 1 BRIEFING" in white serif.
TOP-RIGHT: currency strip — "3500 GOLD" + "250 GEMS" + "5 EMBER".

UPPER PARCHMENT PANEL (indigo with gold trim): two-row affinity readout —
- Row 1: small Slime King silhouette icon on the left, label "BOSS: SLIME KING — weak fire / resist ice" with a small fire-rune icon highlighted in gold next to "weak fire" and a small ice-rune icon dimmed next to "resist ice".
- Row 2: small slime icon on the left, label "MINIONS: weak fire / resist ice" with matching highlighted icons.

BELOW PARCHMENT: two short callout rows —
- Row 1: green checkmark badge + text "✅ Squad covers fire weakness (Bran 🔥)".
- Row 2: yellow warning badge + text "⚠ Bringing 🔥 — also have ❄ + ⚡ (free hits, safe damage)".

MIDDLE: three stylized 2.5D cel-shaded hero portrait cards in a horizontal row, each on an indigo card-panel with gold corner-trim —
- Card 1: Bran (bold white spiky anime hair, fire katana) + small fire-element badge in upper-right corner of card.
- Card 2: Elara (bold long silver hair, cyan crystal staff) + small ice-element badge.
- Card 3: Vex (bold purple hair, dark hood, twin violet-electric daggers) + small electric-element badge.

BOTTOM: two stacked buttons — smaller "ADJUST LOADOUT" (indigo with gold trim), larger primary "⚔ ENTER STAGE" (gold with white serif text).

BACKGROUND: warm forge-room interior with anvil and brazier in soft focus, painterly stone tile floor, drifting ember motes. Deep indigo + warm orange dual palette.

Style guardrails: NO chibi, NO super-deformed, NO sticker-style, NO kawaii-mascot, NO photorealism, NO western cartoon, NO grimdark, NO oversaturated, NO deformed hands. Style is stylized 2.5D cel-shaded mobile-RPG register, NOT Honkai-realistic. Crisp readable UI text — banner, affinity panel, callout rows, button labels all must render legibly in clean serif.
```

---

## A5. Beat 4.3 — WAVE MID-FIGHT, combat read (HERO SCREENSHOT)

**Aspect:** 9:16 · **Model:** nano-banana · **Filename:** `A5-combat-read-v3`

> Direct successor to 2e-beats/beat1-combat-read-2E.jpg. Match that density + readability.

```
9:16 vertical mobile RPG gameplay screenshot mid-wave combat, stylized 2.5D cel-shaded mobile-RPG art register (Archero / Wittle Defender energy), NOT Honkai-realistic.

TOP-LEFT: square pause button.
TOP-CENTER: gold-bordered ornate banner ribbon labeled "WAVE 1" in white serif.
TOP-RIGHT: vertical currency strip — "3500 GOLD" + "250 GEMS".

ARENA: side-view stone arena with cracked tile floor, lava-pour visible mid-background, flame braziers on stone-block wall, weapon racks in deep background, gear-motif metalwork arch overhead.

LEFT THIRD (heroes facing right, ~5-6 head proportions): three stylized 2.5D cel-shaded heroes mid-combat —
- Bran (bold white spiky anime hair, navy-blue armored breastplate with dark teal trim) center-left mid-swing with his glowing fire katana spraying a fire-streak.
- Elara (bold long silver hair, blue-teal hooded robe, cyan crystal staff) behind Bran with staff raised, releasing a cyan frost beam.
- Vex (bold purple hair, dark hood, dark fitted leather, twin violet daggers) crouched in front-left, daggers drawn ready to lunge.
Each hero has a small green HP bar floating just above their head.

RIGHT THIRD: a pile of small green slime minions (clearly smaller than heroes, simple round eyes, NOT cute-mascot — soft-menacing) crowding inward. One slime is bursting apart into a shower of cyan XP gem-cube particles. A few skeleton warriors with rusty swords mix into the wave.

CENTER-RIGHT: three large floating damage numbers in bold yellow with red drop-shadow stacked vertically — "450", "720", "330" — leaping out toward the slime pile.

BOTTOM HUD ROW: three circular hero portrait avatars in gold-bordered rings (Bran, Elara, Vex). Each portrait has a green HP bar segment below it and a partially-full ult-gauge ring around the portrait outline.

BACKGROUND: dense forge interior — lava-pour molten metal stream visible mid-back-wall, two flame braziers flanking it, anvil silhouettes left and right, stone-block columns, gear-motif arch, ember sparks drifting.

PALETTE: deep teal + indigo arena base, warm orange lava + brazier accents, vivid lime-green slime pile, bold yellow damage floaters, cyan XP burst.

Style guardrails: NO chibi, NO super-deformed, NO sticker-style, NO kawaii-mascot, NO photorealism, NO western cartoon, NO grimdark, NO oversaturated, NO deformed hands, NO six fingers, NO melted weapons. Style is stylized 2.5D cel-shaded mobile-RPG register (Archero / Wittle Defender), NOT Honkai-realistic. Slimes smaller for silhouette but NEVER cute-mascot. Crisp readable UI text — "WAVE 1" banner, "3500 GOLD" + "250 GEMS" currency, damage numbers all must render legibly.
```

---

## A6. Beat 4.5 — FORGE DRAFT, 3 cards

**Aspect:** 9:16 · **Model:** ChatGPT · **Filename:** `A6-draft-3card-v3`

> Direct successor to 2e-beats/beat2-forge-draft-2E.png. Match that card-readability.

```
9:16 vertical mobile RPG forge draft modal screen, stylized 2.5D cel-shaded mobile-RPG art register (Archero / Wittle Defender energy), NOT Honkai-realistic.

TOP-LEFT: square pause button.
TOP-CENTER: gold-bordered ornate banner ribbon labeled "WAVE 2" in white serif.
TOP-RIGHT: currency strip — "3500 GOLD" + "250 GEMS".

UPPER HALF: dimmed combat arena background — three stylized 2.5D cel-shaded heroes paused mid-pose on the left (Bran with bold white spiky anime hair, Elara with bold long silver hair, Vex with bold purple hair), slime minions on the right faded out. ABOVE the paused arena: three large cyan storm-cyclone vortex previews floating in a row (3x preview of the highlighted card's effect).

CENTER MIDDLE: gold-bordered ornate banner ribbon labeled "FORGE DRAFT" in white serif, with a small X-close icon on the right side.

LOWER HALF: large modal panel sliding up from bottom, deep indigo with gold trim, containing THREE numbered skill cards side by side —
- Card 1 (red common border, numbered "1" in top-left corner): hero portrait of Bran (white spiky hair, navy breastplate) above a stat-up icon, label "+20% ATK SPEED" in white serif on indigo footer.
- Card 2 (red common border, numbered "2" in top-left corner): hero portrait of Bran above an HP-heart icon, label "+200% HP" in white serif.
- Card 3 (violet rare border, numbered "3" in top-left corner, glowing brightest with gold tooltip arrow pointing down at it): hero portrait of Bran above a triple-cyclone icon, label "STORM CYCLONE x3" in gold serif on indigo footer. Particle motes drifting around this rare card.

BOTTOM FOOTER TEXT (small): "tap to pick · cannot reroll".

BACKGROUND: arena visible behind modal but dimmed. Deep indigo + dim warm orange dual palette.

PALETTE: deep indigo base, violet rare highlight on Card 3, gold tooltip arrow + banner accents, cyan cyclone previews above.

Style guardrails: NO chibi, NO super-deformed, NO sticker-style, NO kawaii-mascot, NO photorealism, NO western cartoon, NO grimdark, NO oversaturated, NO deformed hands. Style is stylized 2.5D cel-shaded mobile-RPG register, NOT Honkai-realistic. Crisp readable UI text — "WAVE 2", "FORGE DRAFT", numbered card labels, "+20% ATK SPEED", "+200% HP", "STORM CYCLONE x3" all must render legibly in clean serif.
```

---

## A9. Beat 5.1 — BOSS BANNER, Slime King entry

**Aspect:** 9:16 · **Model:** nano-banana · **Filename:** `A9-boss-banner-v3`

```
9:16 vertical mobile RPG boss-entry banner moment, stylized 2.5D cel-shaded mobile-RPG art register (Archero / Wittle Defender energy), NOT Honkai-realistic.

TOP-LEFT: square pause button.
TOP-CENTER: large dramatic gold-bordered ornate banner ribbon labeled "👑 BOSS — SLIME KING 👑" in bold white serif, with a small fire-rune-weak icon highlighted next to it and a small ice-rune-resist icon dimmed.
TOP-RIGHT: currency strip — "3500 GOLD" + "250 GEMS".

UPPER 2/3 OF FRAME, CENTER-RIGHT: giant emerald Slime King boss with a crown of bone resting jauntily on his head, jelly translucency catching the brazier light, a lazy menacing grin showing two crooked teeth, eyes half-lidded with arrogance. Boss takes up most of the upper frame.

LOWER 1/3 LEFT: three stylized 2.5D cel-shaded heroes looking up at the boss in defensive stance — Bran (bold white spiky hair, navy breastplate, fire katana raised), Elara (bold long silver hair, cyan staff guarded), Vex (bold purple hair, dark hood, twin violet daggers in low crouch). All ~5-6 head proportions.

CENTER MIDDLE: a large red boss HP bar with gold trim spanning across the screen, nearly full, with small "SLIME KING" label in white serif at its left end and a tiny "Wave 5/5" tag at its right end.

BOTTOM HUD ROW: three circular hero portrait avatars in gold-bordered rings with HP bars + ult rings.

BACKGROUND: dense forge arena — lava-pour mid-back-wall, flame braziers, stone-block columns, gear-motif arch, dust kicked up around the boss feet, ember sparks. Deep indigo + warm orange + vivid emerald-green boss accent.

PALETTE: deep teal + indigo arena, vivid emerald-green boss, warm gold banner trim, red HP bar.

Style guardrails: NO chibi, NO super-deformed, NO sticker-style, NO kawaii-mascot, NO photorealism, NO western cartoon, NO grimdark, NO oversaturated, NO deformed hands. Boss reads full-scale dramatic but NEVER cute-mascot. Style is stylized 2.5D cel-shaded mobile-RPG register, NOT Honkai-realistic. Crisp readable UI text — "👑 BOSS — SLIME KING 👑" banner, "SLIME KING" HP bar label, currency strip all must render legibly.
```

---

## A10. Beat 6.1 — STAGE CLEAR popup

**Aspect:** 9:16 · **Model:** ChatGPT · **Filename:** `A10-stage-clear-v3`

```
9:16 vertical mobile RPG stage-clear victory popup, stylized 2.5D cel-shaded mobile-RPG art register (Archero / Wittle Defender energy), NOT Honkai-realistic.

CENTER: warm gold-and-orange celebration burst radiating outward, with confetti ribbons + ember sparks in slow-motion arcs.

UPPER CENTER: large gold-bordered ornate banner ribbon labeled "⚒ STAGE 1 COMPLETE ⚒" in white serif.

MIDDLE: three stylized 2.5D cel-shaded heroes in triumphant pose on cleared painterly stone arena — Bran (bold white spiky hair, navy breastplate, fire katana raised high overhead), Elara (bold long silver hair, cyan staff raised), Vex (bold purple hair, dark hood, twin violet daggers flicked outward). All ~5-6 head proportions, lit warmly.

ABOVE THE HEROES: reward strip floating in a horizontal row with three gold-frame badges — flame badge "+3 EMBER", gold-coin badge "+30 GOLD", wrench badge "+1 SHARD".

BELOW THE HEROES: sub-text in white serif on indigo "Stage → 2 · Heroes restored to full HP".

BOTTOM: large gold-bordered primary button labeled "CONTINUE TO HOME" in white serif.

BACKGROUND: deep indigo with brilliant warm gold victory god-rays piercing through from upper-right, dense forge interior visible in soft focus behind (flame braziers, anvils, lava-glow). Ember sparks throughout.

PALETTE: deep indigo + brilliant warm gold victory accent.

Style guardrails: NO chibi, NO super-deformed, NO sticker-style, NO kawaii-mascot, NO photorealism, NO western cartoon, NO grimdark, NO oversaturated, NO deformed hands. Style is stylized 2.5D cel-shaded mobile-RPG register, NOT Honkai-realistic. Crisp readable UI text — "⚒ STAGE 1 COMPLETE ⚒" banner, reward labels, sub-text, button all must render legibly.
```

---

## A11. Beat 6.2 — DEFEAT (NARRATIVE FRAME)

**Aspect:** 9:16 · **Model:** nano-banana · **Filename:** `A11-defeat-loadout-v3`

> Direct successor to 2e-beats/beat3-boss-defeat-2E.png. Match that VILLAIN-PRESENT + fallen-squad density.

```
9:16 vertical mobile RPG defeat screen narrative frame, stylized 2.5D cel-shaded mobile-RPG art register (Archero / Wittle Defender energy), NOT Honkai-realistic.

TOP-CENTER: dramatic dark-red gold-bordered ornate banner ribbon labeled "IRON LICH'S HERALD" in bold white serif, with a small skull rune-icon highlighted next to it.

UPPER 2/3 OF FRAME, CENTER-RIGHT: towering dark wraith-lich Iron Lich's Herald with skeletal crowned face, blue-black necrotic energy aura radiating from a raised staff, looming over the scene. Boss takes up significant frame space.

LOWER LEFT (aftermath): three stylized 2.5D cel-shaded heroes fallen on cracked tile floor —
- Bran (bold white spiky hair, navy breastplate with dark teal trim) on one knee, fire katana planted in the cracked tile, head bowed.
- Elara (bold long silver hair, blue-teal hooded robe) thrown back on her side, cyan staff dropped beside her.
- Vex (bold purple hair, dark hood, dark fitted leather) slumped against rubble, twin violet daggers loose.

CENTER MIDDLE FLOATERS: three large floating damage numbers in bold yellow with red drop-shadow — "320", "750", "210" — recent hits still visible in the air.

BOTTOM HUD ROW: three circular hero portrait avatars in gold-bordered rings, all greyed-out/desaturated to show defeat. Ult-gauge rings empty.

BACKGROUND: dense forge arena, BUT now choked with blue-black necrotic energy mist + heavy red low-HP vignette over all edges. Lava-pour barely visible through the mist. Cracked tile floor.

PALETTE: deep indigo + slate base, blue-black necrotic accents from the boss, red edge vignette, dimmed warm forge-orange in the back.

BOTTOM FOOTER PANEL (indigo with red trim): diagnostic text in white serif "Your squad fell. Adjust loadout and try again." with a small "RETURN HOME" button below.

Style guardrails: NO chibi, NO super-deformed, NO sticker-style, NO kawaii-mascot, NO photorealism, NO western cartoon, NO grimdark-MUDDY (dark mood OK, muddy palette NOT), NO oversaturated, NO deformed hands. Boss reads full-scale dramatic. Style is stylized 2.5D cel-shaded mobile-RPG register, NOT Honkai-realistic. Crisp readable UI text — "IRON LICH'S HERALD" banner, damage numbers, diagnostic text, button label all must render legibly.
```

---

## A13. Beat 7.3 — HOT PALADIN scripted-defeat entry (P0)

**Aspect:** 9:16 (vertical works per 2e-beat5 precedent) · **Model:** nano-banana-pro (premium — P0, explicit approval required) · **Filename:** `A13-paladin-entry-v3`

> Direct successor to 2e-beats/beat5-hot-paladin-cinematic-2E.png. Match the GOLDEN-HOUR + ICONIC-SILHOUETTE + DIALOGUE-LINE trifecta.

```
9:16 vertical mobile RPG cinematic hero-arrival scripted-defeat entry, letterbox cinematic framing, stylized 2.5D cel-shaded mobile-RPG art register (Archero / Wittle Defender energy), NOT Honkai-realistic.

LETTERBOX BARS: thin black bars top and bottom for cinematic feel.

CENTER-RIGHT OF FRAME: stylized 2.5D cel-shaded female warrior-priestess Hot Paladin (bold blonde braided hair flowing behind her, ornate storm-blue plate armor with halo motif and gold trim, two-handed glowing storm-blue greatsword) standing tall with greatsword planted point-down through cracked tile, both gauntlets resting on the pommel, head slightly lowered with calm authority. Lit by warm GOLDEN-HOUR sunlight breaking through the haze from upper-left, halo motif catching the gold rim-light.

LEFT THIRD (aftermath): two stylized 2.5D cel-shaded heroes in defeat —
- Bran (bold white spiky hair, navy breastplate with dark teal trim) propped on his planted fire katana, head low but alive, lit by warm gold dawn.
- Elara (bold long silver hair, blue-teal hooded robe) on her knees beside him with both hands covering her face in quiet grief, cyan staff in her lap.
- (Vex tucked into the rubble in the deep background, less visible — focus is Bran + Elara reaction.)

DEEP BACKGROUND, FAR RIGHT: silhouette of the Iron Lich's Herald receding into the distance, a dark wraith shape against the rising warm dawn light.

ENVIRONMENT: cracked stone tile arena, large stone-block rubble pieces scattered, dust settling, ember + dust motes drifting in the warm dawn rays. Faint distant lava-glow at the very bottom of frame.

BOTTOM (caption box): black letterbox bar at the very bottom contains a clean dialogue caption in white serif: *"I saw your blades work hard. Let me join."*

PALETTE: deep cool blue + slate sky, brilliant warm gold dawn breaking through center-left, warm rim-light on the Paladin's halo + greatsword, cool storm-blue greatsword glow, dim red whisper of fading defeat vignette at the very edges.

LIGHTING: this is a GOLDEN-HOUR cinematic — warm dawn light spilling diagonally from upper-left, catching the Paladin's silhouette, washing Bran + Elara's faces in hopeful warm gold. The Paladin's storm-blue blade-glow adds a secondary cool accent.

MOOD: emotional rescue / hero-bond peak / hope reborn. NOT triumphant — quiet + earnest + grounded.

Style guardrails: NO chibi, NO super-deformed, NO sticker-style, NO kawaii-mascot, NO photorealism, NO western cartoon, NO grimdark, NO oversaturated, NO deformed hands, NO six fingers, NO melted weapons, NO blurry faces. Style is stylized 2.5D cel-shaded mobile-RPG register (Archero / Wittle Defender), NOT Honkai-realistic. Crisp readable dialogue caption in clean serif.
```

> **P0 make-or-break.** 4-6 retries. Reference 2e-beats/beat5-hot-paladin-cinematic-2E.png for exact lighting + composition target.

---

## A14. Beat 7.4 — MASTER SMITH'S FORGE (PRODUCT MOMENT)

**Aspect:** 9:16 · **Model:** nano-banana · **Filename:** `A14-master-smith-v3`

> Direct successor to 2e-beats/beat4b-forge-phase1-part-pull-2E.jpg. Match that smith-character-design + rarity-ladder density.

```
9:16 vertical mobile RPG Master Smith's forge screen (Phase 1 unlock), stylized 2.5D cel-shaded mobile-RPG art register (Archero / Wittle Defender energy), NOT Honkai-realistic.

TOP-LEFT: square pause button.
TOP-CENTER: large gold-bordered ornate banner ribbon labeled "MASTER SMITH'S FORGE" in bold white serif.
TOP-RIGHT: currency strip — "3550 GOLD" + "250 GEMS".

UPPER-LEFT: large rectangular result card in a violet legendary frame on a stone pedestal, with header banner "EPIC PART!" in bold gold serif at the very top of the card. Card art shows an EPIC weapon part icon — a fire-rune-engraved warrior helmet visor in purple-violet — with sub-label "PART LUCK" below it.

CENTER-RIGHT: stylized 2.5D cel-shaded grizzled male Master Smith (bald top + grey beard + braided side-knot, leather chest harness over bare muscular arms, heavy hammer raised over his head) mid-strike at his anvil. Below him on the anvil: a glowing fire-imbued katana being struck, ember sparks flying outward from the hammer impact.

RIGHT SIDE (vertical rarity ladder strip): four stacked horizontal rarity slots reading TOP to BOTTOM — "MYTHIC" (gold-red badge + crown icon, locked-dim), "LEGENDARY" (gold badge + crown icon), "EPIC" (purple badge + small sword icon, just unlocked + glowing), "RARE" (blue badge + small sword icon). To the LEFT of the EPIC row: a small progress bar labeled "1 / 2" with one tick filled.

CENTER MIDDLE (between smith and rarity ladder): a small chain of cyan rune-arrow particles flying from the smith's anvil toward the EPIC slot on the ladder, showing forge progress.

BOTTOM ROW: two large gold-bordered buttons side by side —
- Left button (indigo): "WEAPON PULL · 300 💎"
- Right button (gold, primary): "PART PULL · 150 💎"

BACKGROUND: dense ornate inner forge chamber — gear-motif metalwork, stone-block columns, warm orange forge-glow in the lower half, tool racks with hammers and tongs visible, weapon parts on shelves. Deep indigo + warm forge-orange + brilliant violet epic accent.

Style guardrails: NO chibi, NO super-deformed, NO sticker-style, NO kawaii-mascot, NO photorealism, NO western cartoon, NO grimdark, NO oversaturated, NO deformed hands, NO six fingers, NO melted weapons. Style is stylized 2.5D cel-shaded mobile-RPG register, NOT Honkai-realistic. Crisp readable UI text — "MASTER SMITH'S FORGE" banner, "EPIC PART!" header, "PART LUCK" sub-label, rarity-ladder labels (MYTHIC/LEGENDARY/EPIC/RARE), "1 / 2" progress, button labels all must render legibly.
```

---

## A15. Beat 9.1 — CATALYST first reveal

**Aspect:** 9:16 · **Model:** nano-banana · **Filename:** `A15-catalyst-reveal-v3`

```
9:16 vertical mobile RPG catalyst discovery popup moment, stylized 2.5D cel-shaded mobile-RPG art register (Archero / Wittle Defender energy), NOT Honkai-realistic.

TOP-CENTER: dramatic gold-bordered ornate banner ribbon labeled "📣 CATALYST DISCOVERED" in bold white serif.

CENTER-SCREEN: large ornate gold-and-violet popup frame.

INSIDE THE FRAME (upper portion): a large glowing CATALYST compound badge showing two element rune glyphs — a fire flame rune on the left and an ice snowflake rune on the right — merging at the center into a unified glowing fire-frost sigil. Dramatic radial god-rays burst outward from the merge point, ember sparks + frost crystals drift outward in opposing arcs.

INSIDE THE FRAME (mid-band, label): large white serif text "🔥 + ❄ = FIRESTORM" centered. Below it, smaller white serif text "+20% squad ATK while both equipped".

INSIDE THE FRAME (lower band, codex tracker): small label "added to your Catalyst Codex (1/10)" in white serif, with a small ornamental shield badge to the left.

BOTTOM ROW OF FRAME: two buttons — left indigo "VIEW CODEX", right gold primary "CONTINUE".

BOTTOM OF FRAME (two small bust portraits in gold-bordered medallions):
- Left: stylized 2.5D cel-shaded male warrior Bran (bold white spiky hair, navy breastplate) reacting with subtle surprise.
- Right: stylized 2.5D cel-shaded female mage Elara (bold long silver hair, cyan staff over shoulder) reacting with calm widened eyes.

BACKGROUND: dimmed Home screen out of focus — forge interior visible faintly with brazier glow.

PALETTE: deep indigo + slate background, brilliant warm gold + violet catalyst accent, bright fire-frost sigil glow center.

Style guardrails: NO chibi, NO super-deformed, NO sticker-style, NO kawaii-mascot, NO photorealism, NO western cartoon, NO grimdark, NO oversaturated, NO deformed hands. Style is stylized 2.5D cel-shaded mobile-RPG register, NOT Honkai-realistic. Crisp readable UI text — "📣 CATALYST DISCOVERED" banner, "🔥 + ❄ = FIRESTORM" central label, "+20% squad ATK while both equipped" sub-text, "added to your Catalyst Codex (1/10)" tracker, "VIEW CODEX" + "CONTINUE" buttons all must render legibly.
```

---

## Remaining beats — pattern key

For A4, A7, A8, A12, A16, A17, B1, B2 — apply the same v1.3 transformation pattern to the v1.0 prompts:

1. Drop `--no text` style negatives. Add inline label-readability instructions.
2. Swap "half-realistic anime, 7-head proportions" → "stylized 2.5D cel-shaded mobile-RPG register (Archero / Wittle Defender), slightly stylized proportions, NOT chibi".
3. Default 9:16 unless explicitly key-art (A0, A18).
4. Add HUD chrome checklist (§4) per beat.
5. Add damage-number / XP-cube / HP-bar floaters where combat is shown.
6. Name specific weapons / bosses / button text inline.
7. Make backgrounds dense forge-world (lava pours, braziers, gear-motif, weapon racks).
8. End with REVISED universal style guardrails block (§3).

---

## Workflow guide (v1.3)

### Step 1 — first pass
- Default model: **nano-banana**
- Aspect: **9:16** (unless beat is explicitly cinematic key-art at 16:9)
- Save to: `../all-mockups/` (filename pattern: `A<NN>_<slug>_<model-tag>.png`)
- Filename: `A<NN>-<slug>-v3.png`

### Step 2 — reference-lock to 2e-beats
- The 6 2e-beats PNGs ARE the style ref. Pass them as `reference_images` for the matching beat:
  - A2 reference → 2e-beats/beat4-forge-wheel-pull-2E.jpg
  - A5 reference → 2e-beats/beat1-combat-read-2E.jpg
  - A6 reference → 2e-beats/beat2-forge-draft-2E.png
  - A11 reference → 2e-beats/beat3-boss-defeat-2E.png
  - A13 reference → 2e-beats/beat5-hot-paladin-cinematic-2E.png
  - A14 reference → 2e-beats/beat4b-forge-phase1-part-pull-2E.jpg

### Step 3 — escalate to pro
- ONLY for A0, A13, A18, B2 (P0 make-or-break) AND only after explicit user "use pro" approval per global cost policy.

---

## Cost estimate (v1.3 — 20 beats)

| Tier | Per image | First pass | + 2 retries on avg |
|---|---|---|---|
| nano-banana default | $0.04 | $0.80 | $2.40 |
| ChatGPT medium | $0.05 | $1.00 | $3.00 |
| ChatGPT high | $0.17 | $3.40 | $10.20 |

Recommended: **$5 budget** for full pass + retries. Use HIGH only on UI-heavy beats (A1, A3, A4, A6, A7, A10, A17) where label legibility is critical.

---

## Quality bar (v1.3)

| Pass | Ship criteria |
|---|---|
| First pass | Reads as a casual-mobile RPG screen (NOT cinematic key-art, NOT photoreal anime). HUD chrome present. Text labels legible. Hero proportions 5-6 head. |
| Reference-lock | Direct-comparison ship test: side-by-side with the matching 2e-beat PNG — does v3 match the energy + density + readability? If NO, retry with `reference_images` parameter set to the 2e-beat. |
| Continuity audit | Walking A1→A18 reads as the player journey AND each frame looks like the same game. |
| Final ship | Adversarial review: would this work as an App Store screenshot? If NO, retry. |

---

## Change log

| Date | Change |
|---|---|
| 2026-06-09 (v1.3) | **2e-beats lessons incorporated.** OVERWRITE of v1.0. Reversed over-corrections from v1.0-v1.2. Key changes: (1) DROP `--no text` ban — bake UI labels IN for nano-banana + ChatGPT. (2) REPLACE "half-realistic anime, 7-head" proportion lock with "stylized 2.5D cel-shaded, ~5-6 head, Archero/Wittle Defender register, NOT Honkai-realistic". (3) DEFAULT to 9:16 for every screen-beat (mobile app-store frame). (4) ADD universal HUD chrome checklist (pause button, currency strip, wave banner, hero avatar row). (5) DEMAND game-state floaters (damage numbers, XP cubes, HP bars). (6) NAME assets inline (Stormblaze Katana, Iron Lich's Herald, EPIC PART!, MASTER SMITH'S FORGE). (7) RICH forge environments (lava pours, braziers, gear-motif, weapon racks). (8) Pair every v3 prompt with its 2e-beat reference image. Rewrote 9 prompts in full (A1, A2, A3, A5, A6, A9, A10, A11, A13, A14, A15); remaining beats covered by the pattern-key section. |
| 2026-06-09 (v1.0) | Initial nano-banana + ChatGPT screen-beat file. SUPERSEDED by v1.3. |

---

*v1.3 = the 2e-beats lessons applied. Source-of-truth for style energy: `2e-beats/` PNGs in this folder. Source-of-truth for beat IDs: `prototype-screen-beats.md`. Source-of-truth for cast: `art_direction.md` v1.0.*
