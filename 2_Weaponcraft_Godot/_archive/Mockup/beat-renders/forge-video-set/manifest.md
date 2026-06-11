# Forge Video Set — Manifest

**Scope:** ONE deliverable (user override). Single image to feed /ai-video-beats.
**Run date:** 2026-06-09
**Total cost:** $0.04

| id | artifact | stage tag | file | aspect | model | QC | URL | cost |
|---|---|---|---|---|---|---|---|---|
| anchor | gameplay-mockup | pre-render reference | `../forge-video-anchor.jpg` | 9:16 | seedream-4.5 | ✅ shipped | https://cdn.syntheticalresearch.com/image/biswajeet@lilagames.com/2026-06-09/be5951b9-8ec8-44aa-8108-7df3e91107ec.jpg | $0.04 (prior) |
| A01 | gameplay-mockup | Stage 1 pre-wave forge | `forge-screen-v2.png` | 9:16 | nano-banana | ✅ shipped | https://cdn.syntheticalresearch.com/image/biswajeet@lilagames.com/2026-06-09/72682c9e-4c8c-4cfc-9b00-1b4086cb648f.png | $0.04 |

## Pass-test verdict for A01
- ✅ 3 anvil zones HEAD/HILT/RUNE clearly labeled w/ pulsing colored glow drop targets
- ✅ Shop 5 cards: HEAD (Pyro Visor) / HILT (Steel Grip) / RUNE (Fire Rune) / HEAD (Iron Edge) / CONSUMABLE (Heal Potion)
- ✅ START WAVE greyed + "fill slots first" hint visible
- ✅ NO violet pills
- ✅ Bran on-model (brown hair, green vest, red cape)
- ✅ Slime teaser silhouettes at arena right edge
- ✅ Painterly Castle Crashers register
- ✅ All UI text legible in clean serif

## Next step
Feed A01 to `/ai-video-beats` skill as img2vid source. Public CDN URL above.

Recommended call:
```
/ai-video-beats
  source: https://cdn.syntheticalresearch.com/image/biswajeet@lilagames.com/2026-06-09/72682c9e-4c8c-4cfc-9b00-1b4086cb648f.png
  model: seedance-2-fast
  aspect: 9:16
  duration: 10s
  beats: (see story-beats.md → "Point 2 rewrite — gameplay-flat forge video")
```
