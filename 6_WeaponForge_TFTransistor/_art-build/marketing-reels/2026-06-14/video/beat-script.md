# Beat script — hook-01 (Seedance, model-specific) — GENERATE spec

> The model-specific prompt for the winner (hook-01). Authored at GENERATE-time per the ai-video-beats flow. **Review/edit before approving spend.**
> ⚠️ Storyboard-vs-engine reconciliation: `storyboard/hook-01.md` has 5 hard cuts (incl. a rewind-to-forge). **Seedance renders ONE continuous shot — no hard cuts.** v0.1 choice: one continuous ~10s shot below; captions + the "rewind" beat are composited in POST, or split into 2 stitched clips later. (Heavy-edit candidate.)

## Step 1 — first-frame image (nano-banana, ref-locked)
- **Tool:** `edit_image` (ref-lock beats text-only for consistency) · **model:** `nano-banana` · **aspect:** 9:16
- **Input ref:** `6_TFT/_art-build/ref-gameplay.png` → hosted `https://i.ibb.co/zhz3TFPq/Gemini-Generated-Image-dhm62ndhm62ndhm6.png`
- **Prompt:**
  > "Cute storybook mobile-game battle screen, 3 vertical lanes, top-down ~30°. Three heroes on the LEFT — purple-robed mage Elara, red-armored warrior Bran, green-hooded rogue Vex — facing waves of goblins and slimes pouring in from the RIGHT in separate packs. MID-REACTION: a white steam burst blooming in the center lane where fire meets wet enemies, plus yellow electric arcs leaping between lanes. A small combo counter reads 'x3' top-center. Bright, colorful, high-saturation storybook style. Keep the heroes, enemies and lane layout consistent with the reference. 9:16 vertical."
- Output → `video/frames/hook01_firstframe.png`; its returned CDN URL = the `image_url` for Step 2.

## Step 2 — the Seedance prompt (THE prompt)
- **Tool:** `generate_video` · **model:** `bytedance/seedance-2.0-fast` (cheapest) · **resolution:** `480p` · **aspect_ratio:** `9:16` · **duration:** `10` (valid preset) · **generate_audio:** `true` (free on Seedance) · **image_url:** <Step-1 CDN URL>
- **prompt:**

```
Single continuous flowing shot, 10 seconds, 9:16 vertical, continuing from @firstframe (a cute storybook 3-lane battle corridor: three heroes on the left — purple-robed mage Elara, red-armored warrior Bran, green-hooded rogue Vex — facing waves of goblins and slimes pouring in from the right; a white steam burst and yellow electric arcs mid-reaction across the lanes; a small combo counter reads "x3"). Keep the three heroes, the enemies, the 3-lane layout and the bright storybook art style IDENTICAL to @firstframe — no morphing.

[0s] Close on the center lane: fire collides with wet enemies and a white steam burst blooms outward; yellow electric arcs leap lane-to-lane, chaining between separate packs of enemies. Camera: slow push-in. Lighting: bright magical rim-light, warm fire glow against cool blue steam.
[3s] The chain spreads across all three lanes at once, enemies dissolving in waves; the combo counter ticks up fast x3 to x7. Camera: smooth pull-back revealing the full 3-lane board. Lighting: punchy elemental flashes, high saturation.
[6s] A glowing function rune snaps into a hero's weapon socket and her attack visibly changes shape and color, igniting a bigger second chain. Camera: steady hold. Lighting: crisp golden socket flare.
[8s] The biggest chain detonates across the whole screen; the counter peaks and the lanes clear. Camera: gentle push-in on the three heroes standing victorious. Lighting: triumphant warm glow.

Keep all heroes, enemies and art style identical to @firstframe throughout — no morphing. Enemies charge aggressively toward the heroes in separate packs, not one blob. Audio: layered elemental impacts, rising chain-combo zaps, a satisfying final boom.
```

## Step 3 — post (not asked of Seedance)
- Burned-in captions over the clip, safe zone (avoid top/bottom ~15%):
  - 0–2s "wait for the chain…" · 3–5s "x7 CHAIN" · 6–8s "forge functions, not pulls" · 8–10s "I CAUSED THAT" · tail card "Forge your squad → playtest"
- Output: `video/social_9x16_hook01.mp4`.

## Step 4 — verify loop
`ffmpeg -y -i video/social_9x16_hook01.mp4 -vf "fps=2,scale=480:-1" -q:v 3 video/frames-qc/f_%05d.jpg` → Read a spread → check: chain spreads across lanes? counter climbs? socket-snap visible? no morphing? → turn misses into prompt deltas, re-roll.

## Cost estimate
- 1× `edit_image` nano-banana ≈ $0.04 (maybe a 2nd retry ≈ $0.08)
- 1× Seedance Fast 480p 10s ≈ **$0.45–0.70** (audio free); +1 re-roll if a beat misses
- **Run total ≈ $0.5–1.0** (worst case ~$1.5 with retries). Upscale to Pro/720p only if it's a keeper.
