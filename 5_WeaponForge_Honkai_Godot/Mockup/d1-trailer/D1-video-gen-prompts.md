# WeaponCraft — D1 Video-Gen Prompts (image-to-video, render 1-by-1)

**Use:** one clip per beat. **Image-to-video** recommended — feed the matching 2E frame as the start/first frame, then the prompt below drives motion only (look is already locked by the frame). Works with Kling, Runway Gen-3/4, Veo, Sora, Hailuo/MiniMax, Pika.

- **Aspect:** 9:16 · **Per clip:** 5s (8s where noted) · **FPS:** 24–30
- **Frames:** `docs/research/d1-beat-mockups/2e-beats/`
- **Stitch order:** Cold Open → B1 → B2 → B4 → B3 → (B4.5 optional) → B5 → End Card  *(forge pull B4 = meta reward, sits before the B3 boss DEFEAT; B3→B5 = one Stage-2 loss→rescue)*
- **Global negative (append to every clip):** `warping UI text, morphing faces, extra fingers, flickering logos, melting weapons, jitter, watermark, letterbox unless specified, style drift`
- **Tip:** for two-motion beats, render the two sub-clips separately and cut between them.

---

## CLIP 0 — COLD OPEN ("Hold the line") · 4s
**Start frame:** (none / generate) a dim forge chamber, Bran from `beat1` lit dramatically, blade lowered.
**Prompt:**
> Slow cinematic push-in on a stoic white-haired anime warrior in a dim forge. He raises his fire-storm katana toward the camera; orange embers drift upward, firelight rim-lights his armor, the flame blade flares. Subtle dust motes, gentle heat-haze. Cel-shaded 3D anime style, dark scene with warm orange glow. Camera slowly dollies in, ends on a held hero pose.
**End state:** blade raised, holding for title text. **SFX cue:** anvil clang → drum swell.

---

## CLIP 1 — CORE COMBAT READ · 5s
**Start frame:** `beat1-combat-read-2E.jpg`
**Prompt:**
> Side-view battle. The three heroes on the left auto-attack in place — the warrior swings his flaming katana on a steady cadence, the silver-haired mage channels her staff with a cyan glow, the hooded rogue flicks twin daggers. Green slimes hop in from the right; the front slime bursts into a shower of cyan XP cubes. Yellow damage numbers pop and float up. The three ult-charge rings on the bottom portraits slowly fill. Looping mobile-game combat motion, lava glow flickering in the background. Locked camera (gameplay framing) with a faint parallax drift.
**End state:** mid-combat, rings ~70% full. **SFX:** rhythmic hits, slime splats.

---

## CLIP 2 — FORGE DRAFT TRANSFORM ("whoa") · 8s (two motions)
**Start frame:** `beat2-forge-draft-2E.png`
**Prompt (motion A → B):**
> First 3s: the FORGE DRAFT card panel rests at the bottom; the highlighted "STORM CYCLONE x3" card pulses with a golden glow and the tooltip arrow bounces. A finger-tap pip presses the card; it flashes and lifts. Then cut-forward: the warrior swings and a single storm cyclone splits into THREE swirling electric-blue cyclones that spin outward and scatter the slimes — screen-shake on impact, blue energy particles. Cel-shaded 3D anime, punchy mobile VFX.
**End state:** three cyclones spinning. **SFX:** UI chime → rising power-up sweetener.
*(If single-motion only: render just the 3-cyclone burst from a mid-swing frame.)*

---

## CLIP 3 — BOSS DEFEAT (Iron Lich's Herald) · 6s  *(gameplay; hardcoded loss)*
**Start frame:** `beat3-boss-defeat-2E.png`
**Prompt:**
> Gameplay shot, a LOSING fight. The towering Iron Lich's Herald (dark armored wraith-lich wreathed in cold blue-black energy) looms on the right and slams a wave of dark energy; the three heroes on the left trade a couple of quick blows then are overwhelmed and beaten down — the warrior drops to one knee with his katana flame guttering, the mage is thrown off her feet, the rogue reels. The red boss HP bar labeled "IRON LICH'S HERALD" stays nearly FULL (the heroes are losing); the hero ult-rings flicker out; a low-HP red vignette pulses at the edges. Cel-shaded 3D anime. Slow pull-back as the heroes go down.
**End state:** heroes downed, Herald looming → clean handoff to Clip 5. **SFX:** boss roar, heavy thuds → dread drone, music drops out.

---

## CLIP 4 — FORGE WHEEL PULL (the USP) · 7s
**Start frame:** `beat4-forge-wheel-pull-2E.jpg`
**Prompt:**
> A slot-machine forge reel spins fast with motion-blur and flying sparks, tension building, then SLAMS to a stop revealing the legendary weapon card "Stormblaze Katana" in a glowing gold frame — radiant god-rays burst out, ember confetti rains down, the frame flares. The camera does a quick jackpot flash-zoom toward the card, then pans right to the warrior's bust portrait, which animates a slow proud half-smile. Triumphant gacha reveal, cel-shaded 3D anime, warm forge glow.
**End state:** weapon revealed, hero smiling. **SFX:** reel ratchet → jackpot chime + bass hit.

---

## CLIP 4.5 — MASTER SMITH'S FORGE (Stage 10, Phase 1) · 8s · OPTIONAL extended cut
**Start frame:** `beat4b-forge-phase1-part-pull-2E.jpg`
**Prompt:**
> The "PART PULL" button glows and is pressed; the gear-motif reel on the left spins and lands on a glowing purple "EPIC PART" gem with a burst. The part icon flies across into the rarity ladder on the right; the tier-progress meter ticks up to "1 / 2" toward Legendary. In the center the burly Master Smith hammers the flaming katana on the anvil — sparks fly with each strike, metal glows. Then a second part flies in, the meter fills to 2/2 and gold-flashes as the weapon upgrades a tier. Cel-shaded 3D anime, forge sparks, satisfying progression VFX.
**End state:** tier-up gold flash. **SFX:** reel, hammer clangs, tier-up chime.

---

## CLIP 5 — HOT PALADIN RESCUE (grounded) · 8s  *(cinematic; aftermath of the loss)*
**Start frame:** `beat5-hot-paladin-cinematic-2E.png`
**Prompt:**
> Cinematic letterbox bars. Aftermath of a lost battle: the three heroes are slumped on the cracked ground, dejected and exhausted (the warrior propped on his planted sword head low, the mage on her knees, the rogue against rubble), the Iron Lich's Herald's shadow receding in the back. The Hot Paladin arrives at GROUND LEVEL — striding in through the smoke (NOT descending from the sky), planting her glowing storm-blue greatsword and extending a hand toward the fallen heroes; a steady warm light spreads and her blade-glow catches their faces, a grounded ray of hope. Warm dawn breaking through the haze (no divine heavenly beams). Awe via her presence, scale and glow. Slow push-in as the warrior lifts his head.
**End state:** Paladin standing over the squad, hand extended, hope dawning. **SFX:** wind + somber low → warm hopeful swell. **DIALOGUE (subtitle):** "I saw your blades work hard. Let me join."

---

## CLIP 6 — END CARD · 4s
**Start frame:** (generate) roster grid — 3–4 lit hero portraits + shadow silhouettes, WeaponCraft logo.
**Prompt:**
> A hero roster grid assembles: lit hero portraits snap into their slots one by one with a soft glow, empty shadow-silhouette slots pulse invitingly beside them. The WeaponCraft logo settles in with a metallic shine sweep. Clean, premium mobile-game outro, cel-shaded 3D anime, subtle particle sparkle.
**End state:** logo + CTA hold. **SFX:** logo clang + button chime.

---

## Render checklist
- [ ] Clip 0 cold open  · [ ] Clip 1 combat  · [ ] Clip 2 draft (A+B)  · [ ] Clip 3 boss
- [ ] Clip 4 forge pull  · [ ] Clip 4.5 phase-1 (opt)  · [ ] Clip 5 paladin  · [ ] Clip 6 end card
- Keep clips 5s (8s for 2/4.5/5). Hold the last frame ~0.5s for clean cuts. Match-cut on action where possible.
