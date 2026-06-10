# WeaponCraft — D1 Video-Gen Prompts · SEEDANCE 2.0 build

**Engine:** Seedance 2.0 (`seedance-2`), image-to-video. Follows `general-video-agent.md` §6 Profile B.
**Canonical timeline source:** `D1-video-gen-prompts-FLOW.md` (this is the Seedance-shaped rewrite).

### Seedance rules applied (§6 Profile B)
- Discrete durations **4/5/6/8/10/12/15s** only · native max 15s · all our clips ≤8s → each is a single Seedance shot.
- **Exactly ONE camera move per beat** (stacking = jitter). Lighting named **every** beat (highest-impact token).
- **NO hard cuts / freezes inside a clip** — Seedance renders one flowing shot; "freeze" makes subjects STOP. → We render the 8 clips **separately and STITCH** in post; that's where all cuts live.
- Per-beat order: shot type → subject → action → environment → 1 camera move → lighting → style. 2–3 sentences / 50–75 words. ≤4–5 timestamp marks.
- References: `Image 1` = start frame (CDN url per clip). `@audio1`-style beat-synced audio via the trailing Audio line.

### Cross-clip identity lock (paste into every prompt)
Bran = white spiky hair, dark teal-trim armor, fire-storm katana (orange flame blade) · Elara = silver hair, blue-teal robe, cyan staff · Vex = dark hood, twin daggers · Hot Paladin = warrior-priestess, ornate silver armor, storm-blue greatsword · Master Smith = burly bearded smith. Style = cel-shaded 3D anime, thick outlines, lava-glow forge-dungeon, teal accents. **Keep everything IDENTICAL to Image 1 — no morphing.**

### ⚠️ UI-interrupt / text beats (Seedance can't freeze + softens UI text)
Clips **2 (draft modal), 4.5 (tier meter/ladder), 5 (subtitle), 6 (end card)** carry UI/text that Seedance may garble or that wants a hard pop-in. **Plan:** render the motion in Seedance, then **composite the crisp UI layer (cards, ladder numerals, subtitle, logo) in post** (After Effects / Premiere). Prompts below ask for the UI but assume post-fix.

### Stitch order & frames
0 → 1 → 2 → 4 → 3 → (4.5) → 5 → 6 · core ≈34s (+8s w/ 4.5). Frames dir: `2e-beats/`. *(forge 4 = meta reward before boss-DEFEAT 3; 3→5 = one Stage-2 loss→rescue)*

---

## CLIP 1 — CORE COMBAT READ
- **Shot:** single continuous **5s** · 9:16 · 720p · audio on
- **Image 1:** `https://cdn.syntheticalresearch.com/image/biswajeet@lilagames.com/2026-06-01/bd3e3af0-3b1a-440a-9790-330897b48f69.jpg`

| t | Beat | Subject + action | Camera (1) | Lighting |
|:--|:--|:--|:--|:--|
| 0s | Auto-battle | Bran swings flaming katana, Elara channels staff, Vex flicks daggers; dmg numbers pop; ult-rings fill | static gameplay cam | warm lava glow, orange key |
| 3s | Slime burst | front slime takes hits, bursts into scattering cyan XP cubes; gold counter ticks | static (hold) | warm + cyan pop |

```
Single continuous flowing shot, 5 seconds, 9:16 vertical, continuing from Image 1 (a cel-shaded
3D anime side-view forge-dungeon battle; three heroes hold the left, green slimes on the right,
full mobile HUD anchored). Keep the heroes, HUD and art style IDENTICAL to Image 1 — no morphing.
Static gameplay camera the whole time.

[0s] Auto-battle: Bran swings his fire-storm katana on a steady cadence, Elara channels her cyan
staff, Vex flicks twin daggers; yellow damage numbers pop and float up; the three ult-charge rings
on the bottom portraits fill gradually. Camera: static. Lighting: warm orange lava glow.

[3s] Slime burst: the front green slime takes the hits and bursts into scattering cyan XP cubes
that bounce across the floor; the gold counter ticks up. Camera: static hold. Lighting: warm key
with a cyan burst pop.

Audio: rhythmic hit thwacks, slime splats, a light battle-music loop, soft coin/XP chime.
```
- **Gen:** `seedance-2` · 5 · 9:16 · 720p · generate_audio true · image_url=Image 1 · save → `output/wc_clip1_combat_5s_720p.mp4`

---

## CLIP 2 — FORGE DRAFT TRANSFORM
- **Shot:** single continuous **8s** · 9:16 · 720p · audio on · *(no freeze — combat continues under modal)*
- **Image 1:** `https://cdn.syntheticalresearch.com/image/biswajeet@lilagames.com/2026-06-01/3ca577a8-d5b0-473e-8ad2-cb9bea3d955a.png`

| t | Beat | Subject + action | Camera (1) | Lighting |
|:--|:--|:--|:--|:--|
| 0s | Card offer | combat continues behind; FORGE DRAFT panel slides up; "STORM CYCLONE x3" card glows, arrow bobs | slow push-in on Bran | warm forge |
| 4s | Split payoff | x3 card lights + selected, panel slides away; Bran's swing splits ONE cyclone into THREE blue cyclones, scattering slimes | (same push-in continues) | electric-blue VFX wash |

```
Single continuous flowing shot, 8 seconds, 9:16 vertical, continuing from Image 1 (cel-shaded 3D
anime arena with a FORGE DRAFT card panel rising over the lower half). Keep Bran, the cards, HUD and
art style IDENTICAL to Image 1 — no morphing. NO stopping and NO freeze: the heroes keep fighting in
the background the entire time. Slow steady push-in toward Bran throughout.

[0s] Card offer: the FORGE DRAFT panel rests across the lower half showing three cards; the
"STORM CYCLONE x3" card on the right glows gold and its tooltip arrow bobs, while slimes keep
advancing and heroes keep attacking behind it. Camera: slow push-in. Lighting: warm forge orange.

[4s] Split payoff: the x3 card flashes selected and the panel slides down out of frame; Bran swings
and a single storm cyclone splits into THREE swirling electric-blue cyclones that spin outward and
scatter the slimes; blue energy particles, light screen-shake. Camera: continue the same slow
push-in. Lighting: cool electric-blue wash over the warm scene.

Audio: a soft UI chime and card whoosh, then a rising power-up sweetener and multi-hit impacts.
```
- **Gen:** `seedance-2` · 8 · 9:16 · 720p · generate_audio true · image_url=Image 1 · save → `output/wc_clip2_draft_8s_720p.mp4`
- **Residual risk:** card text may soften / panel may stall Bran (no-freeze). If so → split the pick + the swing into 2 shots, or composite the 3 cards in post.

---

## CLIP 3 — BOSS DEFEAT · Iron Lich's Herald  *(gameplay; hardcoded loss)*
- **Shot:** single continuous **6s** · 9:16 · 720p · audio on · *(no slow-mo; this is a LOSS, not a kill)*
- **Image 1:** `https://cdn.syntheticalresearch.com/image/biswajeet@lilagames.com/2026-06-01/41571690-1675-463e-9f30-3b2d1533ea23.png`

| t | Beat | Subject + action | Camera (1) | Lighting |
|:--|:--|:--|:--|:--|
| 0s | Herald slam | quick exchange; Iron Lich's Herald rears and slams a dark-energy wave; heroes brace; boss HP bar stays ~full | static | cold blue gloom + red edge |
| 3s | Overwhelmed | the wave overwhelms them — Bran drops to a knee, Elara thrown, Vex reels; heroes go down, Herald looms | slow pull-back | dim ash-blue, heavy shadow |

```
Single continuous flowing shot, 6 seconds, 9:16 vertical, continuing from Image 1 (cel-shaded 3D
anime arena; a towering Iron Lich's Herald on the right, three heroes overwhelmed on the left, a red
boss HP bar near full). Keep the boss, heroes, HUD and style IDENTICAL to Image 1 — no morphing. Full
speed; this is a LOSS, not a kill.

[0s] After a couple of quick exchanges the Iron Lich's Herald rears up and slams a wave of cold
blue-black energy across the arena; the heroes brace and stagger; the red boss HP bar barely dents.
Camera: static. Lighting: cold blue gloom with a red danger edge.

[3s] The wave overwhelms them — Bran drops to one knee with his katana flame guttering, Elara is
thrown off her feet, Vex reels back; dust kicks up as the Herald looms triumphant over the downed
squad. Camera: slow pull-back. Lighting: dim ash-blue, heavy shadow.

Audio: an ominous boss roar, heavy body thuds, a low dread drone as the music falls away.
```
- **Gen:** `seedance-2` · 6 · 9:16 · 720p · generate_audio true · image_url=Image 1 · save → `output/wc_clip3_defeat_6s_720p.mp4`
- **Residual risk:** boss-bar label "IRON LICH'S HERALD" may soften → composite in post.

---

## CLIP 4 — FORGE WHEEL PULL (USP)
- **Shot:** single continuous **8s** · 9:16 · 720p · audio on
- **Image 1:** `https://cdn.syntheticalresearch.com/image/biswajeet@lilagames.com/2026-06-01/c983e6ae-f0c2-4ec4-8f62-24960a8d480c.jpg`

| t | Beat | Subject + action | Camera (1) | Lighting |
|:--|:--|:--|:--|:--|
| 0s | Reel spin | forge reel spins fast with motion-blur, sparks; tension | slow push-in on reel | dim warm forge |
| 3s | Legendary land | reel slams to "STORMBLAZE KATANA" gold card; god-rays, confetti | (push-in continues) | bright gold flash |
| 5s | Hero reacts | Bran's bust portrait (already in frame, right) animates a proud half-smile; banner slides | hold | warm gold |

```
Single continuous flowing shot, 8 seconds, 9:16 vertical, continuing from Image 1 (cel-shaded 3D
anime FORGE WHEEL screen with a tall slot reel and Bran's bust portrait on the right). Keep the
weapon card, Bran and art style IDENTICAL to Image 1 — no morphing. One slow push-in that settles
to a hold.

[0s] Reel spin: the tall forge reel spins fast with motion-blur and flying sparks, tension building.
Camera: slow push-in toward the reel. Lighting: dim warm forge glow.

[3s] Legendary land: the reel slams to a stop on the "Stormblaze Katana" legendary card in a glowing
gold frame; radiant god-rays burst out and ember confetti rains down. Camera: the push-in continues
into the card. Lighting: bright gold jackpot flash.

[5s] Hero reacts: on the right, Bran's bust portrait animates a slow proud half-smile as the
"Bran wields the Stormblaze Katana" banner slides in. Camera: settle to a hold. Lighting: warm gold.

Audio: a slot-reel ratchet, a jackpot chime with a bass hit, then a triumphant musical stinger.
```
- **Gen:** `seedance-2` · 8 · 9:16 · 720p · generate_audio true · image_url=Image 1 · save → `output/wc_clip4_forgewheel_8s_720p.mp4`
- **Residual risk:** weapon-name text may soften → composite the card label in post if needed.

---

## CLIP 4.5 — MASTER SMITH'S FORGE (Stage 10, Phase 1) · OPTIONAL
- **Shot:** single continuous **8s** · 9:16 · 720p · audio on
- **Image 1:** `https://cdn.syntheticalresearch.com/image/biswajeet@lilagames.com/2026-06-01/1dae9c9a-4280-483f-9df1-a3eddf744b87.jpg`

| t | Beat | Subject + action | Camera (1) | Lighting |
|:--|:--|:--|:--|:--|
| 0s | Part pull | PART PULL button glows + presses; left gear reel spins | static | forge orange |
| 2s | Epic land | reel lands on EPIC PART purple gem with a burst | static | purple flash |
| 4s | Forge | part flies into rarity ladder, meter to 1/2; Smith hammers katana, sparks | slow push-in on anvil | orange + spark flares |
| 6s | Tier-up | second part flies in, meter to 2/2; weapon gold-flashes, Epic→Legendary | hold | gold burst |

```
Single continuous flowing shot, 8 seconds, 9:16 vertical, continuing from Image 1 (cel-shaded 3D
anime MASTER SMITH'S FORGE; a gear-motif slot reel on the left, a rarity ladder and tier meter on
the right, the Master Smith hammering a katana on an anvil in the center). Keep the Smith, weapon,
ladder and art style IDENTICAL to Image 1 — no morphing. Full speed, no freeze.

[0s] Part pull: the "PART PULL 150" button glows and depresses; the left gear-motif reel begins to
spin with motion-blur. Camera: static. Lighting: warm forge orange.

[2s] Epic land: the reel slams to a glowing purple "EPIC PART" gem with a small burst. Camera:
static. Lighting: a purple flash.

[4s] Forge: the epic-part icon flies right into the rarity ladder and the tier meter fills toward
"1 / 2"; the Master Smith hammers the flaming katana on the anvil, sparks flying with each strike.
Camera: slow push-in on the anvil. Lighting: warm orange with bright spark flares.

[6s] Tier-up: a second part flies in, the meter fills to "2 / 2", and the weapon gold-flashes as it
upgrades a tier, the LEGENDARY row on the ladder igniting. Camera: hold. Lighting: a gold burst.

Audio: a slot-reel ratchet, two hammer clangs, a part whoosh, and a tier-up fanfare with a bass hit.
```
- **Gen:** `seedance-2` · 8 · 9:16 · 720p · generate_audio true · image_url=Image 1 · save → `output/wc_clip45_mastersmith_8s_720p.mp4`
- **Residual risk:** ladder labels + "1/2 → 2/2" numerals likely garble → render forge motion in Seedance, composite the ladder + meter UI in post.

---

## CLIP 5 — HOT PALADIN RESCUE (grounded)  *(cinematic; aftermath of the loss)*
- **Shot:** single continuous **8s** · 9:16 · 720p · audio on
- **Image 1:** `https://cdn.syntheticalresearch.com/image/biswajeet@lilagames.com/2026-06-01/3327368f-f562-41bc-a132-eb2209d6a598.png`

| t | Beat | Subject + action | Camera (1) | Lighting |
|:--|:--|:--|:--|:--|
| 0s | Dejected | heroes slumped on the ground, defeated; Herald's shadow receding | static low | dim cold ash, faint warm break |
| 3s | Arrival | Hot Paladin strides in at ground level, plants greatsword; warm light + blade-glow spread | slow push-in | warm hopeful rim, dawn |
| 6s | Hand of hope | she extends a hand to fallen Bran; he lifts his head, squad stirs | hold | building warm key |

```
Single continuous flowing shot, 8 seconds, 9:16 vertical, continuing from Image 1 (cel-shaded 3D
anime; three heroes slumped defeated on cracked ground, a battle-worn Hot Paladin arriving at ground
level through smoke, letterbox bars). Keep the squad, the Paladin and style IDENTICAL to Image 1 —
no morphing.

[0s] The three heroes sit slumped and dejected on the cracked ground as dust settles and the Iron
Lich's Herald's shadow recedes behind them. Camera: static low angle. Lighting: dim cold ash with a
faint warm break on the horizon.

[3s] The Hot Paladin strides forward through the smoke at ground level and plants her glowing
storm-blue greatsword; a warm steady light spreads and her blade-glow catches the heroes' faces,
giving a ray of hope — grounded, no heavenly beam, no sky descent. Camera: slow push-in on the
Paladin. Lighting: warm hopeful rim with dawn breaking through the haze.

[6s] She extends a hand toward the fallen Bran; he lifts his head and the squad stirs with renewed
resolve. Camera: hold. Lighting: a building warm key.

Audio: quiet wind and somber music, rising into a warm hopeful swell with a soft blade hum.
```
- **Gen:** `seedance-2` · 8 · 9:16 · 720p · generate_audio true · image_url=Image 1 · save → `output/wc_clip5_paladin_8s_720p.mp4`
- **Residual risk:** subtitle text — composite the line "I saw your blades work hard. Let me join." + letterbox in post.

---

## CLIP 0 — COLD OPEN & CLIP 6 — END CARD (no start frame)
No 2E frame exists. Options: (a) generate a first frame first (reuse 2E style), then image-to-video; (b) Clip 6 end card is UI-heavy — **best built entirely in post** (logo + roster grid + CTA composite over a simple Seedance particle/ember background or a static card). Cold-open prompt below if you generate a Bran-in-forge first frame.

**CLIP 0 — COLD OPEN · 4s**
```
Single continuous flowing shot, 4 seconds, 9:16 vertical, continuing from Image 1 (a cel-shaded 3D
anime white-haired warrior, Bran, standing in a dim stone forge chamber, blade lowered). Keep Bran
and the art style IDENTICAL to Image 1 — no morphing.

[0s] Bran stands in the dim forge as low embers drift; faint forge-fire flicker. Camera: static.
Lighting: dim ember orange.

[2s] Bran raises his fire-storm katana toward the camera; the flame blade ignites brighter, embers
rise, a rim-light sweeps his armor. Camera: slow push-in. Lighting: a warm forge flare.

Audio: a single anvil clang, then a low war-drum swell with soft fire crackle.
```
- **Gen:** `seedance-2` · 4 · 9:16 · 720p · generate_audio true · image_url=<generated Bran-forge frame> · save → `output/wc_clip0_coldopen_4s_720p.mp4`
- Title "Hold the line." → composite in post.

---

## Render checklist (Seedance, 1-by-1)
- [ ] Clip 1 (5s) · [ ] Clip 2 (8s, +UI post) · [ ] Clip 3 (6s) · [ ] Clip 4 (8s)
- [ ] Clip 4.5 (8s, +UI post, opt) · [ ] Clip 5 (8s, +subtitle post) · [ ] Clip 0 (4s, gen frame) · [ ] Clip 6 (post-built)
- Render each as its own shot → stitch in order → composite UI/text/letterbox/logo passes → add music bed across the cut.
```
