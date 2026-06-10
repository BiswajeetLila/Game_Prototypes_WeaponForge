# WeaponCraft mockup video analysis — `Vid_wf_mockup_1.mp4` + `Vid_wf_mockup_2.mp4`

Source: `2_Weaponcraft_Godot/Mockup/gameplay-mockups/`
Reference still: `wf_mockup_1.png`
Analysis date: 2026-06-09

> Both videos: 10s, 1280×720 (16:9), 24fps, H.264. Frames sampled at 1fps → 10 per video, 5 reps per video read.
>
> **User constraint:** source is 16:9, target is 9:16 mobile portrait. Extract conceptual gameplay/UI intent — ignore exact aspect ratio.

---

## TL;DR — the design intent

These mockups show a **per-turn weapon-craft-and-deploy auto-battler** that fuses **Robotek's turn-counter combat metaphor** with **TFT-style rune/upgrade socketing onto pre-shaped weapon blueprints**. Distinctly different from the current 2_WC frozen build:

| Aspect | Mockup videos | Current 2_WC frozen build |
|---|---|---|
| Combat cadence | **Turn N/5** countdown (visible "TURN 2/5" banner) | 1.1s real-time tick |
| Crafting verb | **Socket runes into weapon blueprint** (3-4 empty holes filled per craft) | Drag parts to 3 slots (head/hilt/rune) |
| Weapon model | Pre-shaped blueprint (Iron Longsword / Mage Staff / Bow) + sockets | Generic head+hilt+rune assembly |
| Per-turn loop | Pick hero → pick weapon-type → socket runes → **CRAFT & DEPLOY** (fires craft + auto-attack in one tap) | Buy from TFT shop → drag to anvil → Start Wave (separate verbs) |
| Hero rotation | Cycle 3 heroes (Knight / Ranger / Mage) — one craft per turn | All 3 heroes share combat tick |
| Damage feedback | Huge yellow damage numbers (9101, 269, 155, -120 × multiple) | Modest amber damage popups |
| UI metaphor | Forge dock at bottom + combat arena on top (split-screen always-visible) | Modal-based forge ↔ combat separation |

---

## Per-video flow

### Vid_wf_mockup_1.mp4 — "Craft cycle showcase"

| Frame | Time | What's shown |
|---|---|---|
| v1_01 | 0s | Mage Staff blueprint w/ 4 empty sockets. CRAFT & DEPLOY button. Combat top: 3 heroes (knight+ranger+wizard) vs 5-goblin + ogre wave. "MARY ORINE" / "CALARE" callouts (character names?). |
| v1_03 | 2s | Switched to **BOW blueprint on parchment scroll overlay** w/ 3 socket dots + finger-tap pointer. Shelf shows owned/needed counts: 49/15, 41/10, 10/20, 26/30, 20/30, 30/30. "+20" cost on right. |
| v1_05 | 4s | Same bow, finger pressing CRAFT & DEPLOY (green-tinged finger graphic). Cost ticking down (+16). |
| v1_07 | 6s | **Wizard's purple Mage Staff** crafted — runes glowing on staff, arrow-chain showing forge progression. "IRON STAFF +40" deploy callout. Combat: MASSIVE damage popups (-120, -120, -120, -121) — wave decimated, smoke clouds rising. Heroes celebrating? |
| v1_10 | 9s | **Cinematic zoom** — knight in red cape draws Iron Longsword across body, blade glowing gold. **HUGE damage numbers: 269, 155, 9101 yellow** floating over goblin pile. Iron Longsword Blueprint label visible. |

**Flow read:** Multi-hero crafting cycle showcase. Player crafts a weapon for each hero (bow for ranger → staff for wizard → sword for knight). Each craft = visual cinematic moment. Damage scales dramatically with rune count.

### Vid_wf_mockup_2.mp4 — "Iron Longsword deep-dive"

| Frame | Time | What's shown |
|---|---|---|
| v2_01 | 0s | **Iron Longsword blueprint** — large horizontal sword w/ 4 empty round socket holes. CRAFT & DEPLOY button w/ pulsing gold-arrow indicator. Shelf: 4 rune icons (cyan, axe, cyan, purple). |
| v2_03 | 2s | **Sword socketed** — 3 green runes now filling the blade holes, sparkles around the sword. **"+10 ATK" gold pop below button.** Shelf updated — cyan runes consumed. |
| v2_05 | 4s | **Knight deploys** — red cape, draws glowing Iron Longsword in cinematic mid-pose vs goblin pack. **9101, 155, 269 damage popups in yellow.** Wizard backing in BG. |
| v2_07 | 6s | **TURN 2/5 banner now visible top-center.** Mage Staff blueprint w/ arrow-chain forge flow. "IRON IRON +64" panel right (typo or "Iron Staff IRON"-tier?). Mage Staff icon highlighted as active in left tab strip. |
| v2_10 | 9s | Same TURN 2/5. Mage Staff being crafted. "IRON STAFF -60" cost (gem spend). Enemies show heavy red HP indicators / damage. Wider crafting flow w/ arrow-chain visible on central blueprint area. |

**Flow read:** Deep-dive on the Iron Longsword craft: socket runes → CRAFT & DEPLOY → cinematic strike → next turn opens with new active hero (Mage). Turn counter and "deploy" verb central.

---

## Full UI inventory (every element seen across both videos + still ref)

### TOP HALF — Combat Arena (always-visible)
- **Top-left:** Player level/XP bar w/ "19" badge (or "18"/"14"/"13" varying — XP level)
- **Top-center:** "COMBAT ARENA" header + ornate banner ribbon
- **Top-right:** Coin icon "265" gold + "+" button + settings gear icon
- **Top-center (sometimes):** "TURN 2/5" counter (mockup_2 specifically — turn-based mode active)
- **Mid-left:** 3-hero squad — knight (red cape) + ranger (green-hooded female) + wizard (blue robe, white beard) standing in a row
  - Each hero has a **green HP bar** floating above them
  - Knight: red helmet plume + sword + shield
  - Ranger: bow + arrows + green cloak
  - Wizard: blue robes + glowing blue staff
- **Mid-right:** Enemy wave — 5 small goblins (varied: sword, axe, shield) + 1 ogre/champion (big green, axes)
  - Each enemy has a **red HP bar** floating above them
- **Right edge:** "END TURN" button (orange/wooden)
- **Background:** Stone arena w/ wooden barred doors, torches on stone-block walls, crowd silhouettes in upper background, banners (skull-emblem on yellow + red+white), barrels

### BOTTOM HALF — Forge Dock (always-visible)
- **Left vertical tab strip:** 4 weapon-class icons (sword / axe / dagger-or-staff / longsword) — filters which weapon-type to craft
- **Left label:** Active weapon name + "BLUEPRINT" sub-label (e.g. "IRON LONGSWORD / BLUEPRINT", "MAGE STAFF / BLUEPRINT")
- **Center (the workbench):** Large pre-shaped weapon **blueprint** with **3-4 empty round socket holes** along the blade/staff. Sometimes shown on a **parchment-scroll overlay** (bow blueprint frame v1_03). Glowing **upward gold arrow** above the CRAFT & DEPLOY button when ready.
- **Center button:** "CRAFT & DEPLOY" (large blue rounded button)
- **Below craft button (sometimes):** stat preview pop — "+10 ATK" gold text
- **Right side:** "CURRENT CRAFT ▼" dropdown + secondary panel showing **active hero portrait** + their planned weapon (e.g. "MARY ORINE" / "CALARE" / "IRON STAFF +40")
- **Right side (sometimes):** Second smaller "CRAFT & DEPLOY" button on the hero-preview panel — confirms craft for that specific hero
- **Far-right vertical:** "SELECT CHARACTER" label + 3 numbered portrait slots (1, 2, 3) — character rotation queue
- **Bottom strip:** "UPGRADES & RUNES SHELF" + horizontal scrollable strip of 5-6 part icons w/ left/right scroll arrows
  - Each part icon has an **owned-count badge** (e.g. 49/15, 41/10, 10/20, 26/30, 30/30) — likely "owned / required-for-craft"
  - Each part icon glows gold when usable in the current blueprint

### Modal/floating elements
- **Damage popups:** Bold yellow numbers w/ red shadow (e.g. "-120", "9101", "269", "155") floating over hit targets
- **Cost popups:** Gold "+20", "+40", "+64" near CRAFT & DEPLOY (rune-spend cost)
- **Stat-preview popup:** "+10 ATK" green when socketing
- **Smoke clouds:** post-damage rising smoke on dying enemies (v1_07)

---

## Mechanic deltas vs current 2_WC frozen build

| Mechanic | Mockup | 2_WC frozen |
|---|---|---|
| **Combat tick** | Turn-based "TURN N/5" — explicit phases | Real-time 1.1s tick |
| **Weapon model** | Pre-shaped blueprint w/ open sockets | Generic 3-slot anvil (head/hilt/rune) |
| **Crafting flow** | Socket runes into blueprint → tap CRAFT & DEPLOY (single verb, immediate combat effect) | TFT shop buy → drag to slots → Start Wave (3 separate verbs) |
| **Hero turn** | Rotate through 3 heroes — one craft per turn | All heroes share combat ticks |
| **Damage feedback** | Huge yellow numbers (9101 max seen) | Modest amber pops (per juice config) |
| **Hero portrait selector** | Right-side "SELECT CHARACTER" tab w/ 3 slots | Bottom HUD always shows 3 portraits |
| **Weapon-type filter** | Left vertical tab w/ 4-5 weapon classes | None — all weapons share same slot layout |
| **Owned/required count UI** | "49/15"-style fraction badge on each rune | Single count number |
| **Cost** | Variable per craft (+20, +40, +64) — shown live on hero panel | Per-part gold cost at shop |
| **Deploy = attack** | CRAFT & DEPLOY fires the hero's swing immediately | Equip then wait for tick |
| **Combat scene split** | Always-visible (top + bottom co-exist) | Modal forge covers combat |

---

## Art-style notes (lock these for 9:16 ports)

- **Painterly stylized 2D** — Castle Crashers / Wittle Defender register
- **~5-6 head proportions** — NOT chibi, NOT realistic — punchy casual-mobile
- **Bold cel-shading** + warm forge-orange palette + cool blue ambient
- **Crowd silhouettes** in deep background of combat arena (spectator feel)
- **Banners + torches** on stone-block arena walls (skull-emblem yellow + red+white)
- **Hero color identity:**
  - Knight: red cape + plume, silver armor
  - Ranger: green cloak + brown leather + bow
  - Wizard: blue robes + white beard + cyan staff
- **Damage numbers:** Bold yellow w/ red shadow, scale dramatically (9000+ peak)
- **Blueprint sheet treatment:** Sometimes shown as parchment scroll, sometimes as floating polished weapon — gives the forge moment two visual states (planning vs production)
- **Glow accents:** Cyan/green runes glow on socket, gold arrows pulse on Deploy CTA

---

## 9:16 port plan — what stays, what reflows, what compresses

### Stays (the conceptual core)
1. **Split-screen always-visible combat ↔ forge** — 9:16 stacks them vertically (combat top 40%, forge bottom 50%, HUD edges 10%)
2. **Pre-shaped weapon blueprint + socket holes** — the visual hook
3. **CRAFT & DEPLOY single-verb button** — collapses 3-verb flow into 1
4. **Per-rune owned/required count badge** — chase mechanic
5. **TURN N/5 counter + END TURN button** — Robotek metaphor
6. **3-hero portrait selector** + per-hero current-craft preview
7. **Damage popups in bold yellow** — visual impact priority
8. **Crowd + banners + torches background** — arena flavor

### Reflows for 9:16
| 16:9 element | 9:16 reposition |
|---|---|
| Combat arena (top half) | Top 40% — vertical compression OK, keep heroes-left / enemies-right side-view |
| Forge panel (bottom half) | Bottom 50% (taller dock for thumb reach) |
| Left vertical weapon-class tabs | Bottom-edge horizontal scrollable row (4 tabs as pills) |
| Right SELECT CHARACTER column | Mid-right vertical pip row (3 numbered portraits stacked) |
| Right CURRENT CRAFT dropdown | Just below the blueprint workbench — single info card |
| Horizontal UPGRADES & RUNES SHELF bottom | Stays horizontal but shorter — 4 visible + scroll arrows |
| END TURN right-edge button | Top-right corner button (replaces current settings if needed) |

### Compresses (drop for 9:16)
- Left/right scroll arrows on rune shelf (use swipe gestures instead)
- "CURRENT CRAFT ▼" dropdown (collapse into the central blueprint title)
- Secondary "CRAFT & DEPLOY" button on hero panel (one button only, primary)
- Character names ("MARY ORINE", "CALARE") if they're proper names — replace w/ hero class label

---

## Render priorities — which beats to mockup in THIS style at 9:16

**P0 (USP visualization):**
- **Beat 3 First Discovery** — socket rune into blueprint → recipe pops → CRAFT & DEPLOY → big damage → next turn (this video literally IS this beat)
- **Beat 1 First Forge** — empty blueprint w/ 4 holes → tap rune from shelf → socket fills → +10 ATK pop

**P1 (combat drama):**
- **Beat 5 Whirlwind Ult** — knight cinematic mid-pose draws sword + huge damage numbers (mirrors v1_10 / v2_05 directly)
- **Beat 2 First Strike** — combat tick showing heroes left, enemies right, HP bars, damage pops

**P2 (UI completeness):**
- **Beat 6 Squad Grows** — character rotation flow (frame v1_01 → v1_03 → v1_07 shows ranger→wizard→knight cycle)
- **Beat 7 Boss Affinity** — enemy w/ visible affinity badge in the wave row

**P3 (loop close):**
- **Beat 8 Reforge & Retry** — defeat state + re-socket runes + try again

---

## Open questions to resolve before rendering

1. **Turn-based or real-time?** The mockup shows "TURN N/5" but 2_WC frozen ships at 1.1s real-time tick. Pick one for the render set OR show both (turn-based = original Robotek pitch, real-time = current build).
2. **Blueprint vs 3-socket anvil?** Current build uses head/hilt/rune cards. Mockup uses pre-shaped blueprint w/ open holes. Pick one model for the render set.
3. **CRAFT & DEPLOY as single verb?** Current build separates equip + start wave. Mockup combines. If we adopt the single verb, this is a design change worth specifying.
4. **Owned/required fraction badges** (49/15)? — better than single count. Adopt?
5. **Character names "MARY ORINE" / "CALARE"** — proper names for these characters, or placeholder? If real, they replace Bran/Elara/Vex.

---

## Files generated

```
vid_analysis/
├── REPORT.md              ← this file
├── v1_frames/             ← 10 frames from Vid_wf_mockup_1.mp4 (1fps sample)
└── v2_frames/             ← 10 frames from Vid_wf_mockup_2.mp4 (1fps sample)
```

Total: 20 frames + 1 MD. Keep `vid_analysis/` for re-runnable input; delete frames if disk pressure (re-generate with `ffmpeg -i Vid_wf_mockup_*.mp4 -vf "fps=1,scale=854:-1" -q:v 3 vid_analysis/v*_frames/v*_%02d.jpg`).

---

*Pair this with `2_Weaponcraft_Godot/docs/story-beats.md` for the canonical 8-beat 2_WC narrative. These videos visualize a different (Robotek-leaning) variant of Beat 1 / Beat 3 / Beat 5.*
