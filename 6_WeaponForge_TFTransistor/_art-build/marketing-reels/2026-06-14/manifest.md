# Run manifest — marketing-reels · 6_TFT · 2026-06-14

**Winner: hook-01 (satisfying-cascade).** Pipeline: LEARN → MAKE → VALIDATE → GENERATE. First full run (v0.1).

## Artifacts
| Stage | File |
|---|---|
| LEARN (KB) | `Marketing-Reels/knowledge/pattern-library/ios-games-baseline.md` |
| M0 | `brief.md` · M1 `positioning.md` · B `creative-intel.md` |
| M2 | `beat-sheet.md` · `hooks/hook-01..05.md` |
| M3 | `storyboard/hook-01.md`, `hook-02.md` |
| V | `validation-scorecard.md` (winner = hook-01) |
| G | `video/beat-script.md` · **`video/social_9x16_hook01.mp4`** · `video/frames-qc/` |

## Generation
- **Anchor (first frame):** `In_Battle.png` → `https://i.ibb.co/Dfk11r1m/In-Battle.png` (current-design mockup; pre-pivot `ref-gameplay.png` rejected as stale).
- **Model:** `bytedance/seedance-2.0-fast` · 480p · 9:16 · 8s · audio on.
- **Permanent URL:** https://cdn.syntheticalresearch.com/video/biswajeet@lilagames.com/2026-06-14/cad56da3-b1c9-427a-929b-bda7d10eb849.mp4
- **Local:** `video/social_9x16_hook01.mp4` (4.2 MB).

## Cost
| Item | Cost |
|---|---|
| LEARN (app-intel data + agent tokens) | $0 media |
| MAKE + VALIDATE (tokens) | $0 media |
| Video (Seedance Fast 480p 8s) | **$0.4304** |
| First video attempt (10s) — transient OpenRouter timeout, failed | $0 (no charge) |
| **Total media spend** | **$0.4304** |

## QC verdict (frames-qc spread)
- ✅ Opens on board (CHAIN x3 + STEAM); counter climbs **x3→x9**; cross-lane chain detonates; enemies dissolve in waves; ends on cleared board + heroes standing.
- ✅ UI/HUD/hero consistency held; minimal morphing; counter animated correctly.
- ⚠️ **Miss:** the forge-the-function cause-beat (6s) didn't render distinctly → differentiator underplayed (reads as payoff-only). Steam fades after frame 1 (electric-dominant).
- ⏳ Captions ("wait for the chain" / "x9 CHAIN" / "I CAUSED THAT" / CTA) = post step, not yet burned in.

## v0.1 learnings → next-iteration deltas (heavy edits expected)
1. **Forge-beat prompt delta:** make the socket/rune insert explicit and EARLY (a distinct shot before the big chain) so the differentiator reads.
2. **Anchor:** prefer current-design mockups (`In_Battle.png`); host them — pre-pivot `ref-gameplay.png` is stale.
3. **LEARN bug:** `genre` arg didn't propagate to the workflow return (`unknown-genre`). Fix arg handling.
4. **Category too broad:** `6014` returns casual/puzzle top-spenders, not tactical-autobattler. Re-pull by comparable `app_id`s.
5. **Networks:** Instagram + TikTok = 0 coverage in-window; default to **Applovin + Unity**.
6. **Seedance:** one continuous shot (no hard cuts); 10s timed out once → 8s succeeded. Captions are post.
7. **Validation worked:** blind judge independently flagged pull-the-pin saturation (matched KB) → not circular.
