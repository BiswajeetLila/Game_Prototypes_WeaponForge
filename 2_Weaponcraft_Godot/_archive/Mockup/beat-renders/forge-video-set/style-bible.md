# WeaponCraft — Style & Theme Bible

Source anchor: `Mockup/beat-renders/forge-video-anchor.jpg` (seedream-4.5)
Date: 2026-06-09

## Theme
Casual-mobile fantasy auto-battler. Cozy-punchy tone — not grimdark, not chibi. Player crafts weapons in a warm forge, sends 3 heroes to a stone arena, fights waves + bosses. Wood/parchment medieval UI dressing.

## Art style & render
- **Painterly stylized 2D cel-shaded**, ~5-6 head proportions
- Register: **Castle Crashers / Wittle Defender** — NOT Honkai-realistic, NOT chibi-mascot, NOT photoreal
- Bold cel line-work, soft warm shadows, painterly highlights
- Hand-painted look, NOT vector flat, NOT toon-shader-3D

## Palette
| Color | Hex-ish | Use |
|---|---|---|
| Wood/parchment tan | warm beige-brown | main UI panels, anvil strip |
| Dark wood brown | deep brown | dividers, anvil pedestal |
| Sage/forest green | mid green | primary CTA (START WAVE, FORGE & RETRY) |
| Fire orange | red-orange | FIRE element tag chips, blade glow, brazier flames |
| Ice cyan | bright cyan | ICE element tag chips, frost particles |
| Violet electric | rich violet | RUNE element tag chips (decorative — NO violet recipe pills) |
| Gold | warm yellow-gold | banner ribbons, currency coin, level badge, legendary trim |
| Tan slot frame | light brown | inactive UI elements, empty placeholders |

## Lighting
Warm torch + brazier glow inside arena. Painterly soft shadows. Combat: bold yellow damage popups w/ red drop-shadow, cyan XP-cube bursts on enemy death. Ult: gold aura ring on hero portrait.

## Camera
**LOCKED gameplay-flat 9:16 portrait.** Full UI on-screen always. NEVER cinematic crop, NEVER letterbox, NEVER punch-zoom. The player sees the same layout every frame.

## Key subjects
- **Bran (FTUE warrior):** young, brown hair, green leather vest w/ brown trim, red cape, simple iron longsword. ~5-6 head proportions.
- **Elara (W3 mage):** silver hair, blue-teal hooded robe w/ arcane trim, cyan crystal staff. (Not in forge-video frame.)
- **Vex (W6 rogue):** purple hair, dark hood, twin violet daggers. (Not in forge-video frame.)
- **Enemy roster:** small green slimes (smaller than heroes, simple eyes, NOT cute-mascot), dark-robed skeleton warriors w/ rusty swords, green hunched goblins w/ crooked staffs.
- **Bosses:** Slime King (giant emerald w/ bone crown), Iron Lich's Herald (towering dark wraith), Arcane Lich (purple chains).

## UI/HUD language
Vertical strip layout (top → bottom):
1. **Combat Arena** (~20%) — stone arena w/ wood-barred door, torches, crowd silhouettes, banners
2. **Combat log strip** (~5%) — dark-brown narrow bar w/ cream-serif damage narration
3. **Hero card** (~12-13%) — yellow-bordered parchment panel, portrait + name + HP bar + ULT% button
4. **Anvil** (~25-30%) — sword/staff with 3 visible labeled socket zones (HEAD/HILT/RUNE), part cards drop into zones, stat delta floats above
5. **(NO recipe pill row)** — recipes telegraph via sword glow + stat-delta floats only
6. **START WAVE** (~5%) — green rounded button w/ crossed-swords icon
7. **Shop** (~15-18%) — 5 horizontal part cards w/ multi-tag chips (slot tag + element tag), Reroll(2g) button, currency coin
8. **Inventory** (~5%) — small mini-cards row OR "(empty)" placeholder

## Typography
- **Headers/banners:** serif white-on-gold
- **Labels:** small cream serif
- **Stats:** bold sans-serif (ATK, +8, etc.)
- **Damage popups:** bold yellow w/ red drop-shadow (basic), purple w/ white shadow (ult)

## Do
- ✅ All UI text legible
- ✅ Multi-tag chips per part (slot + element)
- ✅ L1-L5 merge corner badges (color-tiered)
- ✅ Painterly soft shadows + warm forge palette
- ✅ Crowd silhouettes + banners + torches in arena BG
- ✅ Clear glow-outline drop targets on anvil zones
- ✅ Slime + skeleton + goblin enemies

## Don't
- ❌ Violet recipe pills (recipes telegraph via sword glow + stat delta only)
- ❌ Chibi proportions
- ❌ Honkai-realistic or photoreal
- ❌ Western cartoon line-work
- ❌ Grimdark muddy palette
- ❌ Cinematic letterbox/crops in gameplay screens
- ❌ Sticker-style flat vector
- ❌ Kawaii mascot enemies
- ❌ Robotek "TURN N/5" counter (not in frozen build)
- ❌ Pre-shaped blueprint-w/-empty-sockets weapon (use sword w/ labeled zones instead)
