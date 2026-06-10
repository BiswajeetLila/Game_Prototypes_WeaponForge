# Anime Auto-Battler Cluster — Video Analysis & Threat Assessment

**Date:** 2026-06-08
**Trigger:** Biswajeet flagged YouTube video [*"Top 10 Best Anime Gacha games | Most Play AUTO PLAY games RPG (AFK & iDLE)"*](https://www.youtube.com/watch?v=ozCDDzr9OmE) — worried **WeaponCraft is "already out there."**
**Method:** Full transcript + 12 sampled frames (188 extracted) + cross-reference against `2_Weaponcraft_Godot` design spec v2.2 and the 2026-05-28 competitor synthesis.

---

## 30-second verdict

> **No. Your game is not already out there.** This video is a different genre lineage — **hero-gacha anime JRPGs** (Epic Seven and its descendants: turn-based / party-auto-RPG / idle). They share exactly **two surface attributes** with WeaponCraft — *anime art* and *auto-combat* — and differ on **every load-bearing pillar**: they pull **heroes** (you pull **weapons**); large pullable rosters (you have **7 locked story heroes**); open-content campaign RPGs (you ship **5-minute roguelite wave-arena** runs); zero between-wave card draft or forge meta.
>
> The danger is **not** that you're a clone. The danger is that you could be **mistaken** for one — at the thumbnail, store-listing, and keyword level — and that leaning into "anime autoplay" framing would **forfeit your actual differentiators**. Position *against* this category, not *within* it.

**Tell that proves it:** your real competitors — Wittle Defender and Archero 2 — **are not in this video at all.** A curator who makes "anime gacha" content doesn't consider Habby's arena-roguelites part of this set. Neither should the market.

**Deep-dive update (2026-06-08):** the 3 closest-looking games were then web-researched in depth (Terbis, OZ Re:write, Fantasy of Light). Result: **all three UNRELATED — 0 of 18 convergence checks landed.** Each pulls heroes / open roster / long campaign (Epic Seven & AFK Arena competitors), not weapon-gacha roguelites. One (OZ Re:write) **already shut down after 8 months.** Verdict confirmed and strengthened → see [`03_DEEPDIVE_VERDICT_3_closest.md`](03_DEEPDIVE_VERDICT_3_closest.md).

---

## Documents in this folder

| File | What it is |
|---|---|
| [`01_VIDEO_BREAKDOWN.md`](01_VIDEO_BREAKDOWN.md) | What the video is, the 11 games (10 + bonus), each one's real mechanics, with frame citations |
| [`02_REPORT_threat_and_recommendations.md`](02_REPORT_threat_and_recommendations.md) | **The report.** Overlap matrix, "are you a clone?" verdict, 5 ranked risks, recommendations, what to add to your existing research |
| [`03_DEEPDIVE_VERDICT_3_closest.md`](03_DEEPDIVE_VERDICT_3_closest.md) | **Web-research verdict** on the 3 closest games — consolidated table, findings, risk downgrade |
| [`deepdive_terbis.md`](deepdive_terbis.md) · [`deepdive_oz_rewrite.md`](deepdive_oz_rewrite.md) · [`deepdive_fantasy_of_light.md`](deepdive_fantasy_of_light.md) | Per-game evidence files (cited sources, full design breakdown) |
| [`MANIFEST.md`](MANIFEST.md) | File index + sizes + how to re-run |
| `ozCDDzr9OmE.transcript.txt` | Cleaned narrator transcript (1,868 words) |
| `ozCDDzr9OmE.info.json` | yt-dlp metadata (title, channel, store links per game) |
| `ozCDDzr9OmE.en.vtt` | Raw captions |
| `frames/` | 188 sampled frames (1 / 3s) |

---

## The 11 games at a glance

All are **hero-collector gacha** (you pull/summon characters), auto/idle combat, story-driven anime RPGs. Combat *format* varies; the **gacha axis is identical across all of them — and it is the opposite of WeaponCraft's.**

| # | Game | Studio | Combat format | Gacha unit |
|---|---|---|---|---|
| 1 | **Terbis** | Webzen | Side-view 5-hero party auto-battle (manual ults) | Heroes |
| 2 | **OZ Re:write** | (Japanese) | Side-view 3-hero party auto-battle | Heroes |
| 3 | **Seven Knights Re:Birth** | Netmarble | Auto-RPG, cinematic skills | Heroes |
| 4 | **Epic Seven** | Smilegate | **Turn-based** | Heroes |
| 5 | **Fantasy of Light** | Fantasy Games | Side-view party auto-battle (auto/speed toggle) | Heroes |
| 6 | **Dream and Lethe Record** | VNG | Party auto-combat, idle | Heroes |
| 7 | **Dragon Raja Rerise** | — | Anime action / autoplay | Heroes |
| 8 | **Outerplane** | Smilegate | Turn-based, chain-attack combos | Heroes |
| 9 | **Dragon Traveler** | — | Open-field party auto-combat, idle/AFK | Heroes |
| 10 | **The Promise** | — | Cinematic story gacha (in beta) | Heroes |
| 🎁 | **Go Go Muffin** | XD | **Portrait** idle RPG, full AFK | Heroes |

→ Full mechanics, store IDs, and frame references in [`01_VIDEO_BREAKDOWN.md`](01_VIDEO_BREAKDOWN.md).
