# Forge Video — Seedance Beat Script v1

**Model:** Seedance 2.0 Fast (`bytedance/seedance-2.0-fast`)
**Aspect:** 9:16 vertical · **Duration:** 10s · **Resolution:** 480p (draft default per skill policy; can bump to 720p for final pass)
**Source first-frame:** `forge-screen-v3-pro.jpg` ← hosted CDN URL
**Estimated cost:** ~$0.47-0.73 at 480p · ~$0.90-1.40 at 720p (Seedance Fast 10s)
**Audio:** silent
**Save path:** `Mockup/beat-renders/forge-video-set/forge-video-v1.mp4`

---

## Restructured prompt (Seedance-shaped — header + 5 timestamp marks + style/audio trail)

```
Single continuous flowing shot, 10 seconds, 9:16 vertical, continuing from @firstframe (a static mobile-RPG forge UI: stone arena with Bran in red cape on left + green slime silhouettes on right, hero card showing "Bran 120/120 ULT 0%", anvil with iron longsword having 3 glowing dotted-line socket zones labeled HEAD / HILT / RUNE, shop strip with 5 part cards). Camera LOCKED, NO movement, NO zoom, NO pan, NO crop — phone-screen recording of gameplay. Keep all UI text, hero design, sword shape, layout positions IDENTICAL to @firstframe throughout — no morphing.

[0s] Idle starter. Bran stands ready, his red cape twitches subtly with the torch flicker. The 2 green slime silhouettes at the arena's right edge pulse faintly. The anvil's 3 socket zones pulse with their colored dotted-line glows (red-orange HEAD, brown HILT, cyan RUNE). Camera: locked, no movement. Lighting: warm torch-orange ambient with soft parchment-tan UI panels.

[2s] Three parts fly and socket sequentially. First the Pyro Visor card lifts off shop slot 1 and curves up into the sword's blade tip (HEAD zone) — red-orange ember-spark burst on contact, blade glows hot, ATK display ticks "6 → 14". Then Steel Grip flies into the grip (HILT zone) with a brown spark burst, ATK "14 → 18". Then Fire Rune flies into the pommel socket (RUNE zone) with a cyan spark burst and a red gem inset, ATK "18 → 21". Sword fully assembled, blade glowing with fire-aura halo. Camera: locked, no movement. Lighting: bright ember-orange flashes on each socket, ambient stays warm.

[4.5s] Recipe activation. A gold "+15 ATK" stat-delta floater pulses above the assembled sword. The sword's fire-glow halo intensifies (NO violet pill, NO recipe banner — just sword glow). The START WAVE button transitions from greyed/desaturated to vibrant pulsing sage-green. The "fill slots first" hint fades and is replaced by a faint "tap to fight" pulse. Camera: locked. Lighting: soft golden god-rays radiate briefly from above the sword, then settle.

[6s] Combat tick. A finger-tap circle hint lands on START WAVE, button briefly compresses. Arena strip activates — the slime silhouettes solidify into fully-rendered green slimes, plus a third walks in from the right edge. They charge and lunge aggressively TOWARD Bran (do not retreat). Bran swings his fire-glowing iron longsword in a smooth horizontal arc. Bold yellow damage popups with red drop-shadow appear in sequence — "21" then "27" then "45 crit" (brighter yellow with sparkle). Each slime bursts into a cluster of cyan XP gem-cube particles that drift upward and fade. Camera: locked. Lighting: bright yellow flashes on hits, warm arena ambient.

[8.5s] Wave clear. All slimes gone. A "WAVE 1 CLEARED" gold ribbon banner slides across the arena strip with gold sparkle particles. A small "+7g" gold-coin floater rises from the top-right gold counter — the counter visibly increments "20 → 27". The sword on the anvil continues glowing hot. Camera: locked. Lighting: warm gold celebratory glow filling the arena strip briefly.

Style: painterly stylized 2D cel-shaded mobile-RPG (Castle Crashers / Wittle Defender energy). NOT cinematic. NO chibi. NO violet recipe pills. The entire 10-second clip reads as a phone-screen recording of an actual playable casual-mobile RPG. Keep Bran, sword shape, HUD layout, all UI text positions IDENTICAL to @firstframe — no morphing.

Audio: silent.
```

## Why this shape

- **Header first** w/ `@firstframe` named reference per Seedance profile rules
- **5 timestamp marks** at [0s, 2s, 4.5s, 6s, 8.5s] — under the 4-5/15s limit
- Each beat: subject → action → environment → camera (LOCKED — same value all beats) → lighting (named per beat)
- **No-morphing instruction** repeated in header AND footer (survives 10s context)
- **Countered Seedance failure modes:**
  - "charge and lunge aggressively TOWARD Bran (do not retreat)" — counters passive-enemy default
  - "separate clusters / packs with gaps" — implicit via "the 2 slime silhouettes ... plus a third" wording
  - "keep ... IDENTICAL to @firstframe — no morphing" — twice
- **Lighting named every beat** — highest-impact token
- Camera value = "locked, no movement" repeated every beat to anchor against drift

---

## Cost gate (skill Step 4)

| Model | Resolution | ~Cost (10s) | Notes |
|---|---|---|---|
| Seedance 2.0 Fast | **480p** ⭐ | ~$0.47–0.73 | DEFAULT DRAFT — fast iteration |
| Seedance 2.0 Fast | 720p | ~$0.90–1.40 | quality pass after 480p approved |
| Seedance 2.0 Pro | 720p | ~$1.50–1.80 | premium pass for App Store ship cut |

**Firing 480p first** per draft-resolution policy. User pre-approved spend; defaulting to cheap iteration tier.
