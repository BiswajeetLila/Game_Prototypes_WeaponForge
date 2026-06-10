# WeaponForge — Mockup library

All visual mockups, prompts, and art reference for the WeaponForge prototype.
Consolidated 2026-06-09.

---

## Folder map

| Folder | What's inside | When to use |
|---|---|---|
| **`all-mockups/`** | All 47 beat renders, one flat folder, named by canonical beat ID + generation tag | Browse / compare versions of any beat |
| **`concept-screens/`** | Future-progression UI concepts (talent tree, gear screen) | Pitch deck for post-launch features |
| **`key-art/`** | Marketing key-art splashes | Store hero image / ad creative |
| **`art-bible/`** | `art_direction.md` — canonical Art Bible | Source-of-truth for cast, palette, style |
| **`style-tests/`** | Early style direction tests (4 cozy_parchment / anime_vibrant / dark_forge + 8 style1-5 PRO tests) | Reference for "why we picked 2E cel-shaded" |
| **`prompts/`** | 3 prompt MD files (Niji 7, nano-banana+ChatGPT, ChatGPT-story-beats) | Copy a prompt → fire a render |
| **`d1-trailer/`** | D1 marketing-video script + video-gen prompts + Seedance clips + archive | Cutting the 60s D1 trailer |

---

## `all-mockups/` filename convention

Every file in `all-mockups/` follows:

```
<beat-id>_<descriptive-name>_<generation-tag>.<ext>
```

### Beat IDs

| Prefix | Source | Meaning |
|---|---|---|
| `A<NN>` | `docs/prototype-screen-beats.md` | Canonical screen-beat (HUD-first mobile screen-state) |
| `SB<N>` | `docs/prototype-screen-beats_condensed.md` | Story-beat (cinematic key-frame, 1 image per narrative chapter) |
| `B<N>` | `prompts/MJ-niji7-prompts.md` Track B | D1-trailer-only beat (not in prototype) |

### Generation tags

| Tag | Model / origin | Status |
|---|---|---|
| `2E-ref` | Original 2E-style renders | **GOLD STANDARD** — proven baseline, use as reference image |
| `nano-v2` | nano-banana 10-beat batch (2026-06-08) | Superseded by v3 |
| `nano-v3` | nano-banana 6-beat batch w/ 2e-beats lessons applied | Solid baseline |
| `seedream` | ByteDance Seedream 4.5 w/ v1.3 prompts | **CURRENT DEFAULT** — punchier proportions, sharper UI text |
| `early` | Pre-2E first attempts (deprecated style) | Archive — don't ship |
| `early-chibi` | Pre-2E chibi variant tests (rejected style) | Archive — don't ship |
| `story-cinematic` | nano-banana story-beat key-frames (SB1-9) | Pitch-deck cinematic frames |

### Examples

- `A5_combat-read_2E-ref.jpg` → the proven combat-read screen, original 2E render
- `A5_combat-read_seedream.jpg` → same beat, latest Seedream 4.5 render
- `SB5_paladin-descends_story-cinematic.png` → "The Paladin Descends" story-beat key-frame
- `A2_pull-reveal_early-chibi.png` → deprecated chibi variant of pull-reveal (archive)

---

## Current best-of-set (use these for pitch / store / trailer)

| Beat | Best file | Why |
|---|---|---|
| Pull reveal (A2) | `A2_pull-reveal_seedream.jpg` | Sharpest forge wheel + Stormblaze Katana product shot |
| Combat read (A5) | `A5_combat-read_seedream.jpg` | Best 2e-beats parity, diorama view |
| Forge Draft (A6) | `A6_forge-draft-3card_seedream.jpg` | Crisp card labels, violet rare glow |
| Defeat (A11) | `A11_defeat-iron-lich_seedream.jpg` | Iron Lich looming + full UI footer |
| Hot Paladin (A13) | `A13_paladin-entry_seedream.jpg` | Golden-hour rim-light + dialogue caption |
| Master Smith (A14) | `A14_master-smith_seedream.jpg` | EPIC PART card + rarity ladder + smith mid-strike |

For story-beat cinematic frames (one image per narrative chapter), see `SB1-9` files.

For concepts not yet beat-numbered (future-progression UI), see `concept-screens/`.

---

## Workflow

### Rendering a new beat
1. Open `prompts/nano-banana-gpt-prompts.md` (screen-beats) or `prompts/chatgpt-story-beat-prompts.md` (story-beats)
2. Find the beat (A<NN> or SB<N>)
3. Copy prompt body → fire via MCP `generate_image` with `model: "seedream"` (default) or `model: "nano-banana"` (cheap fallback)
4. Save to `all-mockups/` with filename: `<beat-id>_<slug>_<model-tag>.<ext>`

### Pairing renders with reference images
For Seedream/nano-banana retries that drift off-style, pass the matching `*_2E-ref.*` file as `reference_images`. The 2E-refs are the gold-standard anchor.

### Story-beat vs screen-beat
- **Screen-beats** (A<NN>) = mobile screen-state mockups, 9:16, HUD-first
- **Story-beats** (SB<N>) = cinematic narrative key-frames, 16:9, no HUD
- Same cast + palette + style anchor; different framing intent

---

## Cost reference (per single image)

| Model | Cost | Notes |
|---|---|---|
| nano-banana | $0.04 | Default cheap render |
| seedream 4.5 | $0.04 | Same cost, better mobile-RPG register |
| nano-banana-pro | $0.18 avg | P0 make-or-break only, requires explicit user approval |
| ChatGPT GPT-image high | $0.17 | Best for UI-text-heavy beats |

Full 6-beat regen on seedream = $0.24. Full 9 story-beats on nano = $0.36.

---

## Cross-references

- Canonical screen-beat IDs: `../docs/prototype-screen-beats.md`
- Story-beat condensation: `../docs/prototype-screen-beats_condensed.md`
- D1 marketing video script: `d1-trailer/D1-gameplay-video-script.md`
- Art Bible (cast / palette / style): `art-bible/art_direction.md`
- Prompt source-of-truth: `prompts/` (3 MDs)

---

*Last consolidated 2026-06-09. Maintain filename convention for new renders.*
