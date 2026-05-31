# Archero 2 Research Verification Report
**Generated:** 2026-05-18  
**Scope:** 21 video folders, Play Store reviews, frame/OCR/notes integrity  
**Mode:** Read-only — no files modified or deleted

---

## 1. Frame Inventory Table

> Note: 3 videos (3ixTDUf0nvY, NgiDHZuNFy0, PtgbAzxp4rM) use **JPEG** format, not PNG. All others use PNG. All frames verified as valid image files via `file` command.  
> Zero tiny/corrupted frame files found (0 files under 500 bytes across all 21 folders).

| Video ID | Frames | Format | Dimensions (spot-check) | Anomaly |
|---|---|---|---|---|
| 3ixTDUf0nvY | 66 | JPG | 854×480 | JPG format (not PNG) |
| 3rPvl1xCvAw | 120 | PNG | 1280×720 | OK |
| CdZ122DGL_A | 89 | PNG | 1280×720 | OK |
| eTxwhXcZ48k | 77 | PNG | 1280×720 | OK |
| FaZlxQNpK9U | 227 | PNG | 1280×720 | OK |
| ffZpg7ndjLA | 155 | PNG | 1280×720 | OK |
| GH1iVtcWgzg | 87 | PNG | 1280×720 | OK |
| IGpuzVuEO1o | 86 | PNG | 1280×720 | OK |
| jCpmNrXYJsc | 459 | PNG | 1280×720 | OK |
| k3mxy2oWlAE | 32 | PNG | 1280×720 | Low count (short video?) |
| kpIdlbhx4s8 | 176 | PNG | 1280×720 | OK |
| KrXJHpk_uXU | 243 | PNG | 1280×720 | OK |
| lEb22efbhjs | 190 | PNG | 1280×720 | OK |
| LkzThHCkFjA | 129 | PNG | 1280×720 | OK |
| NgiDHZuNFy0 | 52 | JPG | 854×476 | JPG format (not PNG) |
| nhJMWJRWq30 | 646 | PNG | 1280×720 | OK |
| PtgbAzxp4rM | 105 | JPG | 854×1366 (portrait) | JPG + portrait orientation |
| SWt0cYOM0kM | 811 | PNG | 1280×720 | OK |
| VGFEPNdXhAE | 81 | PNG | 1280×720 | OK |
| W43vRnoT7ZQ | 192 | PNG | 1280×720 | OK |
| zXH2wMVZtDE | 66 | PNG | 1280×720 | OK |

**Total frames:** 4,033 across 21 videos  
**Corrupted/tiny frames:** 0  
**Format anomalies:** 3 folders use JPEG (not PNG) — content is valid, format difference only  
**Notable:** PtgbAzxp4rM is portrait 854×1366 (mobile recording vs. landscape for all others)

---

## 2. Notes Depth Table

Sections checked (case-insensitive): metadata, gameplay/timeline, hero/character, ability/skill, build, feedback/commentary, edge, monetiz/IAP/price, UI

| Video ID | Size (KB) | Sections Present | Missing | Status |
|---|---|---|---|---|
| 3ixTDUf0nvY | 14.9 | 9/9 | — | PASS |
| 3rPvl1xCvAw | 14.1 | 9/9 | — | PASS |
| CdZ122DGL_A | 15.0 | 9/9 | — | PASS |
| eTxwhXcZ48k | 8.7 | 9/9 | — | PASS |
| FaZlxQNpK9U | 14.7 | 9/9 | — | PASS |
| ffZpg7ndjLA | 21.6 | 9/9 | — | PASS |
| GH1iVtcWgzg | 17.6 | 9/9 | — | PASS |
| IGpuzVuEO1o | 15.8 | 9/9 | — | PASS |
| jCpmNrXYJsc | 49.0 | 9/9 | — | PASS |
| k3mxy2oWlAE | 14.0 | 9/9 | — | PASS |
| kpIdlbhx4s8 | 36.4 | 9/9 | — | PASS |
| KrXJHpk_uXU | 21.8 | 9/9 | — | PASS |
| lEb22efbhjs | 25.2 | 9/9 | — | PASS |
| LkzThHCkFjA | 22.0 | 9/9 | — | PASS |
| NgiDHZuNFy0 | 15.6 | 9/9 | — | PASS |
| nhJMWJRWq30 | 19.1 | 8/9 | build | PASS-WITH-WARNINGS |
| PtgbAzxp4rM | 23.1 | 8/9 | build | PASS-WITH-WARNINGS |
| SWt0cYOM0kM | 24.5 | 9/9 | — | PASS |
| VGFEPNdXhAE | 12.8 | 8/9 | build | PASS-WITH-WARNINGS |
| W43vRnoT7ZQ | 31.1 | 9/9 | — | PASS |
| zXH2wMVZtDE | 17.9 | 9/9 | — | PASS |

**Summary:** 18/21 PASS (all 9/9 sections). 3/21 missing the "build" section keyword only (nhJMWJRWq30, PtgbAzxp4rM, VGFEPNdXhAE). No notes.md missing 3+ sections — no critical failures.  
**Smallest notes:** eTxwhXcZ48k at 8.7 KB (still 9/9 sections).  
**Richest notes:** jCpmNrXYJsc at 49.0 KB.

---

## 3. OCR Sanity Table

> `ocr_combined.txt` exists at the **video root** level (not inside `ocr/`) for all 21 videos. Per-frame `.txt` files live in `ocr/`. High zero-byte rate on individual frames is expected — OCR returns empty for frames with no readable text (loading screens, action sequences, etc.).

| Video ID | OCR Files | Zero-byte Files | Zero% | Combined Size | Status |
|---|---|---|---|---|---|
| 3ixTDUf0nvY | 66 | 38 | 58% | 4,448 B | OK |
| 3rPvl1xCvAw | 120 | 31 | 26% | 16,410 B | OK |
| CdZ122DGL_A | 89 | 37 | 42% | 6,955 B | OK |
| eTxwhXcZ48k | 77 | 2 | 3% | 7,491 B | OK |
| FaZlxQNpK9U | 227 | 5 | 2% | 12,263 B | OK |
| ffZpg7ndjLA | 155 | 11 | 7% | 43,060 B | OK |
| GH1iVtcWgzg | 87 | 34 | 39% | 5,124 B | OK |
| IGpuzVuEO1o | 86 | 26 | 30% | 4,020 B | OK |
| jCpmNrXYJsc | 459 | 24 | 5% | 34,253 B | OK |
| k3mxy2oWlAE | 32 | 18 | 56% | 1,017 B | WARN: low content |
| kpIdlbhx4s8 | 176 | 37 | 21% | 9,224 B | OK |
| KrXJHpk_uXU | 243 | 201 | 83% | 1,217 B | WARN: 83% empty, low combined |
| lEb22efbhjs | 190 | 141 | 74% | 950 B | WARN: 74% empty, combined <1 KB |
| LkzThHCkFjA | 129 | 38 | 29% | 13,985 B | OK |
| NgiDHZuNFy0 | 52 | 21 | 40% | 1,986 B | OK |
| nhJMWJRWq30 | 646 | 557 | 86% | 3,849 B | WARN: 86% empty (long video, expected) |
| PtgbAzxp4rM | 105 | 7 | 7% | 14,520 B | OK |
| SWt0cYOM0kM | 811 | 7 | <1% | 194,033 B | OK (richest OCR) |
| VGFEPNdXhAE | 81 | 7 | 9% | 13,419 B | OK |
| W43vRnoT7ZQ | 192 | 42 | 22% | 4,857 B | OK |
| zXH2wMVZtDE | 66 | 9 | 14% | 13,767 B | OK |

**No combined files below 100 bytes** — all 21 pass the minimum threshold.  
**Flagged for low OCR yield:** KrXJHpk_uXU (83% empty, 1.2 KB combined), lEb22efbhjs (74% empty, 950 B combined), k3mxy2oWlAE (56% empty, 1 KB combined). These may be gameplay-heavy videos with few UI text elements, or may have had OCR quality issues.  
**Note:** nhJMWJRWq30 has 86% empty OCR but is a very long video (646 frames); combined size of 3.8 KB is adequate.

---

## 4. Play Store Reviews Integrity

| Check | Result |
|---|---|
| `_REVIEWS_SUMMARY.md` exists | YES — 12,217 bytes (11.9 KB) — PASS |
| `listing_metadata.json` valid JSON | YES — PASS |
| `rating_count` | 162,850 |
| `rating_average` | 4.49 / 5.0 |
| `rating_distribution` | 5★: 114,269 / 4★: 27,245 / 3★: 5,998 / 2★: 1,931 / 1★: 9,047 |
| `reviews.csv` line count | 3,043 (incl. header = 3,042 reviews) |
| `reviews.jsonl` line count | 3,042 reviews |
| CSV / JSONL count match | YES — consistent |
| JSONL spot-check (5 reviews) | ALL VALID — keys present: review_id, author, rating, text, timestamp_unix, timestamp_iso, thumbs_up, app_version, source_country |
| `date` field name | `timestamp_iso` (not "date") — field exists, different key name |
| `thumbs` field name | `thumbs_up` (not "thumbs") — field exists |

**Reviews integrity:** PASS. All files present, metadata consistent, JSONL parses correctly. The schema uses `timestamp_iso` and `thumbs_up` rather than `date`/`thumbs` but all expected data is present.

---

## 5. Disk Cleanup Recommendations

### Raw Video Files Found

| File | Size | Safe to Delete? |
|---|---|---|
| `/Users/tarun/LILA/Game Research/Archero 2/Videos/nhJMWJRWq30/video.mp4` | **462 MB** | YES — frames (646) + transcript + notes complete |
| `/Users/tarun/LILA/Game Research/Archero 2/Videos/kpIdlbhx4s8/video.mp4` | **37 MB** | YES — frames (176) + transcript + notes complete |
| `/Users/tarun/LILA/Game Research/Archero 2/Videos/GH1iVtcWgzg/video.mp4` | **65 MB** | YES — frames (87) + transcript + notes complete |

**Total reclaimable: ~564 MB**

No other `.mp4`, `.webm`, `.mkv`, or `.m4v` files found in the Videos directory.

### Folder Size Context

| Video ID | Total Size | Raw Video | Notes |
|---|---|---|---|
| SWt0cYOM0kM | 627 MB | None found | Frames-only (811 PNGs) |
| nhJMWJRWq30 | 612 MB | 462 MB raw | Delete video.mp4 → ~150 MB remaining |
| jCpmNrXYJsc | 333 MB | None found | Frames-only (459 PNGs) |
| kpIdlbhx4s8 | 183 MB | 37 MB raw | Delete video.mp4 → ~146 MB remaining |
| GH1iVtcWgzg | 110 MB | 65 MB raw | Delete video.mp4 → ~45 MB remaining |

**Total Videos directory:** ~2.89 GB  
**After recommended deletions:** ~2.33 GB  

---

## 6. Top Concerns

1. **Format inconsistency (3 videos use JPEG, 18 use PNG):** 3ixTDUf0nvY, NgiDHZuNFy0, and PtgbAzxp4rM use JPEG frames extracted with a different tool/setting. Content is valid, but downstream analysis scripts expecting `.png` glob patterns will miss these. PtgbAzxp4rM is also portrait orientation (854×1366) — a mobile screen recording vs. landscape for all others.

2. **High OCR zero-byte rate on 3 videos:** KrXJHpk_uXU (83%), lEb22efbhjs (74%), and k3mxy2oWlAE (56%) have very high empty-frame OCR rates and low combined content. The notes are substantial (21.8 KB, 25.2 KB, 14 KB respectively), suggesting the analyst compensated, but OCR-dependent analysis on these will be weak.

3. **3 notes.md missing "build" section keyword:** nhJMWJRWq30, PtgbAzxp4rM, VGFEPNdXhAE. Build/loadout analysis is a core Archero 2 research vector. These notes may discuss builds under different terminology — low severity but worth checking.

4. **No `ocr_combined.txt` inside the `ocr/` subdirectory:** Combined OCR is stored at the video root level, not inside `ocr/`. This is consistent across all 21 videos (by design), but differs from the expected path in the audit spec.

5. **564 MB of deletable raw video:** 3 `video.mp4` files are still present. No research value; all derivative assets (frames, transcripts, OCR, notes) are complete.

---

## 7. Final Verdict

**PASS-WITH-WARNINGS**

- All 21 notes.md present and substantive; 18/21 cover all 9 required sections
- All 4,033 frames are valid image data (0 corrupted/tiny files)
- All 21 `ocr_combined.txt` files exist and exceed 100 bytes
- Play Store reviews fully intact: 3,042 reviews, valid JSON schema, complete metadata
- Warnings: 3 JPEG-format frame folders (vs PNG), 3 videos with weak OCR yield, 3 notes missing "build" keyword, 564 MB of reclaimable raw video files
