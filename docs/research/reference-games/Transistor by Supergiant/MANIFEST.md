# Manifest — Transistor (Supergiant) video analysis

**Mode:** default (deliverables + frames kept; 233 MB source mp4 removed — re-downloadable)
**Total kept:** ~15.9 MB (frames dominate at 15.3 MB)
**Source video:** https://www.youtube.com/watch?v=_hhqPQH01Zw — "Supergiant's Underrated Masterpiece | Reflections on Transistor" · Livewire Voodoo (Jintekki) · 15:01 · 2025-03-01 · 71 subs / ~559 views
**Analyzed:** 2026-06-15

## Deliverables (~25 KB)
- `README.md` — index + 30-second verdict + three-systems-at-a-glance
- `01_VIDEO_BREAKDOWN.md` — faithful record of the video (game, 3 combat systems, 4 experimentation pressures, story/presentation), frame-cited
- `02_DESIGN_REFERENCE.md` — transferable lessons + relevance to `6_WeaponForge_TFTransistor` + Transistor's failure modes to avoid
- `03_WEAPON_DESIGN_GDD.md` — standalone, game-agnostic weapon/Function-system design spec (no prototype references); synthesized from the video + the two research dossiers
- `MANIFEST.md` — this file

## User-supplied research dossiers (~41 KB) — inputs to docs 03 + 04
- `Technical Synthesis and Systemic Analysis of Transistor….md` (27 KB) — 41-reference deep dive; Function archetypes, Process AI/FSM, Art Nouveau design, Limiters
- `Transistor_ Comprehensive Game Design Specification….md` (14 KB) — Genuine-Source/Assumed-tagged spec; Function MEM costs + exact slot effects, Limiter XP bonuses, D1–D30 journey

## Phase 1–3 research corpus (added 2026-06-15) — total folder ~116 MB / 772 files
- `04_CONSOLIDATED_DESIGN_SPEC_D1-D30.md` (23 KB) — the consolidated, fully source-tagged spec (GS vs ASSUMED). Synthesized from the entire corpus below.
- `Web Sources/` (~115 MB incl. raw payloads; 751 KB of `content.md`) — **Phase 1**: 40 sources, each `<NN-slug>/` = `content.md` (verbatim) + `_meta.md` + `images.md` + raw.html/json/txt + `images/`. 148 images downloaded. Produced by a 2-stage agent workflow (40 scrape → 40 independent verify; 0 fails). Method per source recorded in each `_meta.md` (curl raw = true verbatim for reddit `.json` / fandom `?action=raw` / wikipedia `?action=raw`; WebFetch fallback flagged non-verbatim for JS-walled Steam/Medium/IGN).
- `Video Analysis/QLYkM4YZEMc/` — **Phase 2** 2nd video (5:06 tutorial): `VIDEO_BREAKDOWN.md`, `transcript.txt` (790 words), `.en.vtt`, `.info.json`, `_parse.py`, `frames/` (102 @ 1/3 s), `QLYkM4YZEMc.mp4` (~31 MB, retained — small; removable + re-downloadable).
- `Reviews/` — **Phase 2** Steam appid 237930: `steam_237930_reviews.csv` (290 KB) + `.jsonl` (698 KB) = 600 recent English reviews; `summary.md` = lifetime 29,271👍/1,882👎 of 31,153 ("Very Positive", ~94%). Pulled via public `store.steampowered.com/appreviews` (no auth). **Play Store N/A** — Transistor ships PC/PS4/iOS, not Android; no comparable public iOS review API.

### Re-run Phase 1 (web scrape+verify) / Phase 2 (2nd video + reviews)
- Phase 1 workflow script persisted at the session path (run `wf_95a843f4-619`); re-invoke Workflow with that `scriptPath` to re-scrape.
- Steam reviews: `Invoke-RestMethod store.steampowered.com/appreviews/237930?json=1&...&cursor=*` paginated (see `Reviews/`).
- 2nd video: `python -m yt_dlp ... QLYkM4YZEMc` then `python _parse.py` + `ffmpeg -vf "fps=1/3,scale=854:-1"`.

## Source provenance (~637 KB)
- `_hhqPQH01Zw.info.json` (488 KB) — yt-dlp metadata: title, tags, chapters, full description (Steam link, chapter timestamps)
- `_hhqPQH01Zw.en.vtt` (134 KB) — raw YouTube captions
- `_hhqPQH01Zw.transcript.txt` (14 KB) — cleaned narrator transcript, 2,766 words
- `_parse.py` (1 KB) — metadata + VTT→plaintext parser (re-runnable)

## Re-runnable inputs (~15.3 MB)
- `frames/` — 300 jpgs at 854px wide, 1 frame / 3 s (timestamp = frame# × 3 s). 14 read via vision; the combat section (f_00079–f_00202) carries the design-relevant UIs.

## Removed
- `_hhqPQH01Zw.mp4` (233 MB, 1280×720@60) — deleted after frame extraction. **Not committed; too heavy for the repo.** Re-fetch if needed (below).
- `_hhqPQH01Zw.en-orig.vtt` — byte-identical duplicate of `.en.vtt`; removed.

## Key frames (design reference)
| Frame | ≈ time | What |
|---|---|---|
| `frames/f_00155.jpg` ⭐ | 7:42 | FUNCTIONS / MEM loadout screen — prints `Crash()`'s Active/Upgrade/Passive slot effects |
| `frames/f_00190.jpg` ⭐ | 9:27 | PROCESS LIMITERS screen — *Efficiency* "Process strikes 2× power", 10 limiters → +32% XP |
| `frames/f_00170.jpg` | 8:27 | Turn() planning mode — frozen, enemies QUEUED UP, planning timeline |
| `frames/f_00110.jpg` | 5:27 | Turn() execution — red action-trails resolving |
| `frames/f_00095.jpg` | 4:42 | Real-time combat — 4-slot ability bar, Turn meter |
| `frames/f_00125.jpg` | 6:12 | Access Point (save / respec terminal) |
| `frames/f_00185.jpg` | 9:12 | Timed challenge arena |

## How to re-run
```powershell
$work = "docs\research\reference-games\Transistor by Supergiant"; Set-Location $work
# transcript + metadata (already present):
python -m yt_dlp --skip-download --write-auto-sub --write-sub --write-info-json --sub-lang "en.*" --sub-format vtt -o "%(id)s.%(ext)s" "https://www.youtube.com/watch?v=_hhqPQH01Zw"
python _parse.py
# re-download video + re-extract frames (only if frames/ is gone):
python -m yt_dlp -f "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720]" --merge-output-format mp4 -o "%(id)s.%(ext)s" "https://www.youtube.com/watch?v=_hhqPQH01Zw"
ffmpeg -i _hhqPQH01Zw.mp4 -vf "fps=1/3,scale=854:-1" -q:v 3 "frames/f_%05d.jpg"
```

## Run config
- yt-dlp 2026.06.09 (via `python -m yt_dlp`) · ffmpeg 8.1.1 · Python 3.12 (Windows)
- transcript: YouTube auto-captions (`en`). Narrator is a (sick) native English speaker but auto-caption garbles proper nouns — Camerata→"camarada", Supergiant→"super giant", Jintekki→"jinchi/jinie". Corrected in the reports against well-documented facts about the 2014 game; uncertainties flagged.
- frames: fps 1/3, scaled 854px, q:v 3 → 300 frames
- OCR: not used — frames read directly via multimodal vision (more reliable per skill)
- whisper: not used — YouTube captions sufficient for a talking-head essay

## Note on `.gitignore`
If committing, consider adding `frames/` + `*.mp4` to `.gitignore` — keep the 4 markdown deliverables + `transcript.txt` + `info.json` + `_parse.py` (~660 KB), drop the 15.3 MB of frames (regenerable from the command above). Mirrors the `anime_autobattlers/` precedent.
