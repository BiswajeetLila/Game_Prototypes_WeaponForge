# Manifest — Anime Auto-Battler Cluster analysis

**Mode:** default (deliverables + frames kept; 237 MB source mp4 removed — re-downloadable)
**Total kept:** ~12.2 MB (frames dominate)
**Source video:** https://www.youtube.com/watch?v=ozCDDzr9OmE — "Top 10 Best Anime Gacha games (AUTO PLAY)" · GameMobile HDgraphic · 9:23 · 2025-12-15

## Deliverables (~33 KB)
- `README.md` — index + 30-second verdict + 11-game glance table
- `01_VIDEO_BREAKDOWN.md` — the reel + all 11 games' real mechanics, store IDs, frame citations
- `02_REPORT_threat_and_recommendations.md` — **the report.** Overlap matrix, clone verdict, 5 ranked risks, recommendations
- `MANIFEST.md` — this file

## Source provenance (~622 KB)
- `ozCDDzr9OmE.info.json` (521 KB) — yt-dlp metadata; per-game Play Store / App Store links in the description field
- `ozCDDzr9OmE.transcript.txt` (10 KB) — cleaned narrator transcript, 1,868 words
- `ozCDDzr9OmE.en.vtt` (91 KB) — raw captions
- `_parse.py` (1 KB) — metadata + VTT→plaintext parser (re-runnable)

## Re-runnable inputs (~11.5 MB)
- `frames/` — 188 jpgs at 854px, 1 frame / 3 s (timestamp = frame# × 3 s). Used for visual verification of each game.

## Removed
- `ozCDDzr9OmE.mp4` (237 MB, 1280×720) — deleted after frame extraction. **Not committed; too heavy for the repo.** Re-fetch if needed (see below).

## How to re-run
```powershell
$work = "docs\research\anime_autobattlers"; cd $work
# transcript + metadata (already present):
python -m yt_dlp --skip-download --write-auto-sub --write-sub --write-info-json --sub-lang en --sub-format vtt -o "%(id)s.%(ext)s" "https://www.youtube.com/watch?v=ozCDDzr9OmE"
python _parse.py
# re-download video + re-extract frames (only if frames/ is gone):
python -m yt_dlp -f "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720]" --merge-output-format mp4 -o "%(id)s.%(ext)s" "https://www.youtube.com/watch?v=ozCDDzr9OmE"
ffmpeg -i ozCDDzr9OmE.mp4 -vf "fps=1/3,scale=854:-1" -q:v 3 "frames/f_%05d.jpg"
```

## Run config
- yt-dlp 2026.03.17 (via `python -m yt_dlp`) · ffmpeg 8.1.1
- transcript: YouTube manual `en` captions (not whisper) — narrator is a non-native English speaker, so some game names are garbled in captions; corrected from on-screen overlays (Terbis, OZ Re:write) and description store-IDs
- frames: fps 1/3, scaled to 854px wide, q:v 3
- OCR: not used — frames read directly via multimodal vision (more reliable per skill)

## Note on `.gitignore`
If you commit this folder, consider adding `frames/` and `*.mp4` to `.gitignore` — keep the 4 markdown deliverables + `transcript.txt` + `info.json` + `_parse.py` (~655 KB), drop the 11.5 MB of frames (regenerable from the command above).
