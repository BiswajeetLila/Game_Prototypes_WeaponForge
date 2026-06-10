# WeaponCraft — D1 Video-Gen Prompts · GOOGLE FLOW format (Gemini Omni Flash, Video Mode)

**Engine:** Google Flow / Gemini Omni Flash (Video Mode). Structured per `general-video-agent.md`
(@Ingredient binding · timeline mapping · layer isolation · native audio sync).

**How to render 1-by-1:** upload the named 2E frame as the `@StyleReference` Ingredient, paste one
clip block, render. Each block is self-contained.

- **Aspect:** 9:16 · **FPS:** 24 · **Per clip:** 4–8s (noted) · **Stitch order:** 0 → 1 → 2 → 4 → 3 → (4.5) → 5 → 6  *(forge B4 = meta reward before the B3 boss DEFEAT; B3→B5 = one Stage-2 loss→rescue)*
- **Frames dir:** `docs/research/d1-beat-mockups/2e-beats/`
- **Global negative (every clip):** `warping UI text, morphing faces/weapons, extra fingers, flickering logos, drifting HUD, jitter, watermark, style drift, texture popping`
- **Cross-clip lock (paste into every clip's @MainSubject):** Bran = white spiky hair, dark teal-trim armor, fire-storm katana (orange flame blade) · Elara = long silver hair, blue-teal robe + cloak, cyan staff · Vex = dark hood/cloak, twin short daggers · Hot Paladin = warrior-priestess, ornate silver armor, glowing storm-blue greatsword · Master Smith = burly bearded smith, leather apron.
- **Seedance-2 variant:** TODO — second file `D1-video-gen-prompts-SEEDANCE.md` once the Seedance prompting guide arrives. Keep this Flow file as the canonical timeline source.

---

## CLIP 0 — COLD OPEN ("Hold the line") · 4s

```
@Ingredients
  @StyleReference: match beat1-combat-read-2E.jpg style (cel-3D anime, thick outlines, warm forge glow) — GENERATE start frame: Bran alone in a dim forge chamber, blade lowered
  @MainSubject:  Bran (white spiky hair, dark teal-trim armor, fire-storm katana)
  @UIOverlay:    none until end (reserve lower-third for title)
  @Environment:  dim stone forge chamber, low embers, single forge fire off-screen
  @InteractingEntities: floating ember particles, heat-haze

Timeline
  0:00–0:01  Black; faint forge-fire flicker fades up. [audio] anvil CLANG (logo sting).
  0:01–0:03  Slow push-in, low angle. Bran raises the fire-storm katana toward camera; flame blade ignites brighter, embers drift up, rim-light sweeps his armor. [VFX] ember rise, heat-haze, blade flare. [audio] low war-drum swell.
  0:03–0:04  Hold on heroic pose. [UI] title "Hold the line." fades in lower-third + tap-to-start pulse.

Continuity: zero morphing on Bran; title is crisp anchored screen-space text
Audio (native): anvil clang → war-drum swell, soft fire crackle
Fidelity: razor-sharp title text; sharp blade edge, no flicker
Negative: <global>
```

---

## CLIP 1 — CORE COMBAT READ · 5s

```
@Ingredients
  @StyleReference: beat1-combat-read-2E.jpg
  @MainSubject:  Bran, Elara, Vex (holding left third, fixed positions)
  @UIOverlay:    "WAVE 1" banner top-C; GOLD 3500 + GEMS 250 top-R; 3 circular hero portraits w/ green ult-rings bottom — anchored screen-space
  @Environment:  forge-dungeon arena, flickering lava backdrop
  @InteractingEntities: green slimes (enter from right), cyan XP cubes

Timeline
  0:00–0:02  Bran swings flaming katana on cadence; Elara channels cyan staff; Vex flicks daggers. [UI] ult-rings 40%→60%; yellow dmg numbers "450 / 720" pop and float up. [VFX] katana fire-trail, ice shimmer. [audio] rhythmic hit thwacks.
  0:02–0:04  Front slime takes hits and bursts into scattering cyan XP cubes. [UI] GOLD 3500→3560 tick. [audio] slime splat + coin blip.
  0:04–0:05  Ult-rings reach ~75%; one portrait glows ready (pulse). [audio] battle loop swells.

Continuity: zero morphing on heroes; @UIOverlay crisp anchored layer; lava bg parallax drifts independently behind UI
Audio (native): light battle loop, hit impacts, slime splats, XP chime
Fidelity: razor-sharp HUD numerals, no flicker
Negative: <global>
```

---

## CLIP 2 — FORGE DRAFT TRANSFORM ("whoa") · 8s

```
@Ingredients
  @StyleReference: beat2-forge-draft-2E.png
  @MainSubject:  Bran (mid-arena, will swing)
  @UIOverlay:    "WAVE 2" banner top-C; FORGE DRAFT modal lower-half w/ 3 cards — "+20% ATK SPEED", "+200% HP", "STORM CYCLONE x3" (highlighted, gold glow, tooltip arrow) — anchored
  @Environment:  forge-dungeon arena
  @InteractingEntities: green slimes, three storm cyclones

Timeline
  0:00–0:03  Modal rests at bottom; the "STORM CYCLONE x3" card pulses gold, tooltip arrow bounces. A finger-tap pip presses the card; it flashes white and lifts. [UI] card selects, modal slides down. [audio] UI chime + card whoosh.
  0:03–0:06  Cut-forward to arena: Bran swings; ONE storm cyclone splits into THREE swirling electric-blue cyclones spinning outward. [VFX] 1→3 cyclones, blue energy particles, screen-shake. [audio] rising power-up sweetener.
  0:06–0:08  The three cyclones scatter the slimes; XP cubes fly. [UI] ult-rings tick up. [audio] multi-hit impacts, music adds a layer.

Continuity: zero morphing on Bran/cyclones; @UIOverlay modal + cards crisp anchored; background sim freezes while modal is open, resumes on selection
Audio (native): UI chime, card whoosh, power-up sweetener, impacts
Fidelity: razor-sharp card text + icons
Negative: <global>
```

---

## CLIP 3 — BOSS DEFEAT · Iron Lich's Herald · 6s  *(gameplay; hardcoded loss)*

```
@Ingredients
  @StyleReference: beat3-boss-defeat-2E.png
  @MainSubject:  Iron Lich's Herald (dark armored wraith-lich, cold blue-black energy) overwhelming Bran, Elara, Vex
  @UIOverlay:    red boss HP bar top labeled "IRON LICH'S HERALD" (stays ~full); 3 ult-rings dimming out; low-HP red vignette — anchored
  @Environment:  dark Stage-2 forge-dungeon arena, cracked ground, dust
  @InteractingEntities: Herald's blue-black energy waves; the three heroes being knocked down

Timeline
  0:00–0:02  Heroes trade a couple of quick blows; the Herald rears and slams a wave of dark energy. [UI] boss bar barely dents (~95%); player HP flashes red. [VFX] blue-black shockwave. [audio] ominous boss roar.
  0:02–0:04  The wave overwhelms them — Bran drops to one knee, Elara is thrown, Vex reels. [UI] ult-rings flicker out. [VFX] impact dust, dark arcs. [audio] heavy thuds, music darkens.
  0:04–0:06  Heroes down on the cracked ground; the Herald looms over them. Camera: slow pull-back. [VFX] red screen-edge weight. [audio] low dread drone, music drops out.

Continuity: zero morphing on heroes/Herald; @UIOverlay boss bar crisp anchored; pull-back affects scene layer only
Audio (native): boss roar, heavy thuds, dread drone
Fidelity: razor-sharp boss-bar label
Negative: <global>
```

---

## CLIP 4 — FORGE WHEEL PULL (the USP) · 7s

```
@Ingredients
  @StyleReference: beat4-forge-wheel-pull-2E.jpg
  @MainSubject:  Stormblaze Katana weapon card + Bran bust portrait (right)
  @UIOverlay:    forge-wheel frame, single tall reel, GOLD/GEMS top-R, "Bran wields the Stormblaze Katana" banner — anchored
  @Environment:  anvil + gear-motif forge backdrop, sparks
  @InteractingEntities: legendary weapon card, god-rays, ember confetti

Timeline
  0:00–0:03  Reel spins fast with motion-blur, sparks fly; tension builds. [audio] reel ratchet loop, music drops to a held note.
  0:03–0:05  Reel SLAMS to a stop on "STORMBLAZE KATANA — Warrior — Fire-imbued" in a gold legendary frame; god-rays burst, ember confetti rains. [VFX] jackpot flash-zoom, legendary rays. [audio] jackpot chime + bass hit.
  0:05–0:07  Camera pans right to Bran's bust portrait; he animates a slow proud half-smile. [UI] banner slides in. [audio] triumphant music re-enters.

Continuity: zero morphing on weapon card + Bran; @UIOverlay frame/banner crisp anchored; only reel + portrait animate
Audio (native): reel ratchet, jackpot chime, bass hit, triumphant stinger
Fidelity: razor-sharp weapon-name text + rarity frame
Negative: <global>
```

---

## CLIP 4.5 — MASTER SMITH'S FORGE (Stage 10, Phase 1) · 8s · OPTIONAL extended cut

```
@Ingredients
  @StyleReference: beat4b-forge-phase1-part-pull-2E.jpg
  @MainSubject:  Master Smith (burly, mid hammer-strike) + Stormblaze Katana on anvil
  @UIOverlay:    "MASTER SMITH'S FORGE" header top-C; GOLD/GEMS top-R; LEFT gear-motif reel; RIGHT rarity ladder (Common→Rare→Epic→Legendary→Mythic) + tier meter; bottom buttons "WEAPON PULL 300" / "PART PULL 150" — anchored
  @Environment:  dark forge, glowing anvil, orange lava glow
  @InteractingEntities: EPIC PART purple gem, flying part icons, sparks

Timeline
  0:00–0:02  "PART PULL 150" button depresses + glows; LEFT reel spins (motion-blur). [VFX] gear teeth turning. [audio] reel ratchet loop.
  0:02–0:04  Reel SLAMS to "EPIC PART" purple gem with a burst. [UI] gem locks in frame. [audio] reveal chime.
  0:04–0:06  Part icon flies right into the ladder; tier meter fills 0→"1 / 2" toward LEGENDARY; Smith hammers the katana, sparks per strike. [audio] whoosh + 2× hammer clang.
  0:06–0:08  A second part flies in; meter "1/2"→"2/2"; weapon GOLD-flashes, Epic→Legendary tier-up; ladder "LEGENDARY" row ignites. [VFX] tier-up gold burst. [audio] tier-up fanfare + bass hit.

Continuity: zero morphing on Smith/weapon; @UIOverlay ladder + buttons rigidly anchored; ONLY the meter fill, reel spin, and part-icon flight animate
Audio (native): reel ratchet, hammer clangs, tier-up fanfare
Fidelity: razor-sharp ladder labels + "1/2 → 2/2" numerals (no garble)
Negative: <global>
```

---

## CLIP 5 — HOT PALADIN RESCUE (grounded) · 8s  *(cinematic; aftermath of the loss)*

```
@Ingredients
  @StyleReference: beat5-hot-paladin-cinematic-2E.png
  @MainSubject:  Hot Paladin (warrior-priestess, ornate battle-worn silver armor, glowing storm-blue greatsword) striding in at ground level
  @UIOverlay:    cinematic letterbox bars + single subtitle line — anchored
  @Environment:  dark battlefield aftermath, dust, Iron Lich's Herald shadow receding, warm dawn break on horizon
  @InteractingEntities: Bran/Elara/Vex slumped on the ground, dejected

Timeline
  0:00–0:03  The three heroes sit slumped and dejected on the cracked ground (Bran propped on his planted sword, Elara on her knees, Vex against rubble); the Herald's shadow recedes. [audio] quiet wind, somber low music.
  0:03–0:06  The Hot Paladin strides in at ground level through the smoke and plants her glowing greatsword; warm light spreads and her blade-glow catches the heroes' faces. [VFX] dust swirl, gentle blade glow, embers, warm dawn breaking — NO heavenly beam, NO sky descent. [audio] warm music swell, blade hum.
  0:06–0:08  She extends a hand to the fallen Bran; he lifts his head, the squad stirs with renewed resolve. [UI] subtitle: "I saw your blades work hard. Let me join." [audio] hopeful theme rises.

Continuity: zero morphing on Paladin or the slumped squad; awe via scale/glow/cape, NOT divine godrays; letterbox + subtitle crisp anchored; slow push-in affects scene layer only
Audio (native): wind/somber → warm swell → hopeful theme
Fidelity: razor-sharp subtitle text; sharp armor + sword glow
Negative: <global> (allow letterbox bars here)
```

---

## CLIP 6 — END CARD · 4s

```
@Ingredients
  @StyleReference: match 2E cel-3D anime style — GENERATE start frame: hero roster grid (3–4 lit portraits + shadow silhouettes) + WeaponCraft logo
  @MainSubject:  WeaponCraft logo + roster grid
  @UIOverlay:    roster grid tiles, logo, CTA line + store badges — anchored
  @Environment:  clean dark premium menu backdrop, subtle particles
  @InteractingEntities: lit hero portrait tiles, shadow-silhouette empty slots

Timeline
  0:00–0:02  Lit hero portraits snap into their roster slots one by one with a soft glow; empty shadow-silhouette slots pulse invitingly. [audio] soft snap ticks.
  0:02–0:04  WeaponCraft logo settles in with a metallic shine sweep; CTA + store badges fade in. [audio] logo clang + button chime.

Continuity: zero morphing on logo; all UI crisp anchored screen-space; particles drift behind
Audio (native): snap ticks, logo clang, button chime
Fidelity: razor-sharp logo + CTA text + store badges
Negative: <global>
```

---

## Render checklist
- [ ] 0 cold open (4s) · [ ] 1 combat (5s) · [ ] 2 draft (8s) · [ ] 3 boss (6s)
- [ ] 4 forge pull (7s) · [ ] 4.5 phase-1 (8s, opt) · [ ] 5 paladin (8s) · [ ] 6 end card (4s)
- Total core cut ≈ 0:34 (+8s with 4.5). Hold each last frame ~0.5s for clean cuts; match-cut on action.
- **UI-state animations to verify per clip:** ult-rings fill (1,2,3) · boss HP drain (3) · gold tick (1) · tier meter 1/2→2/2 (4.5) · card select (2).
```
