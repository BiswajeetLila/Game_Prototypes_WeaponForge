# Transistor (Supergiant Games) — Video Analysis & Design Reference

**Date:** 2026-06-15
**Source:** YouTube — [*"Supergiant's Underrated Masterpiece | Reflections on Transistor"*](https://www.youtube.com/watch?v=_hhqPQH01Zw) · Livewire Voodoo (creator **Jintekki**) · 15:01 · 2025-03-01 · 71 subs / ~559 views
**Method:** Full transcript (2,766 words) + 14 sampled frames (300 extracted, 1 / 3 s) read via multimodal vision. Source mp4 removed after extraction (re-downloadable).
**Why analyzed:** Transistor is a **named design touchstone** for the repo's active prototype `6_WeaponForge_TFTransistor` (name = **T**ransistor + **TFT**). This is the cheapest single source that explains its signature systems *and* shows their UIs.

> **Expanded into a full research knowledge base (2026-06-15):** a 3-phase orchestrated pass added **40 word-for-word web sources** ([`Web Sources/`](Web%20Sources/)), a **second analyzed video** ([`Video Analysis/QLYkM4YZEMc/`](Video%20Analysis/QLYkM4YZEMc/VIDEO_BREAKDOWN.md)), **600 Steam reviews** ([`Reviews/`](Reviews/)), and a fully source-tagged **D1–D30 design spec** ([`04_CONSOLIDATED_DESIGN_SPEC_D1-D30.md`](04_CONSOLIDATED_DESIGN_SPEC_D1-D30.md)). Full corpus in the table below.

---

## 30-second verdict

> **Transistor's combat is a build-depth machine: one Function = three abilities in one (Active / Upgrade / Passive), and four overlapping pressures keep you recombining them.** That single structural move — huge combinatorial depth from a tiny content set — is the most transferable idea for a weapon-forge prototype. A plan-then-execute **Turn()** mode adds spatial tension (the real cost is *where you stand* when the cooldown hits). The game's admitted weakness — it's short (2–4 h) and **"not super replayable"** because it's linear — is precisely the gap a **TFT-style meta layer is meant to fill.** So the prototype's bet reads as sound: *borrow Transistor's combinatorial-part combat, fix its replayability with the TFT round/economy loop.*

**The one frame that matters:** [f_00155](frames/f_00155.jpg) — the FUNCTIONS / MEM screen — literally prints the three-slot system for `Crash()`. Closely followed by [f_00190](frames/f_00190.jpg), the PROCESS LIMITERS screen (difficulty-for-XP dial).

---

## Documents in this folder

| File | What it is |
|---|---|
| [`01_VIDEO_BREAKDOWN.md`](01_VIDEO_BREAKDOWN.md) | Faithful record of what the video says + shows — the game, the three combat systems, the four experimentation pressures, story/presentation, all frame-cited |
| [`02_DESIGN_REFERENCE.md`](02_DESIGN_REFERENCE.md) | Distilled transferable lessons + direct relevance to `6_WeaponForge_TFTransistor` + Transistor's failure modes to avoid |
| [`03_WEAPON_DESIGN_GDD.md`](03_WEAPON_DESIGN_GDD.md) | **Standalone weapon GDD.** Pure Transistor weapon/Function-system design spec — game-agnostic (no prototype references). Synthesized from the video + the two research dossiers below |
| [`04_CONSOLIDATED_DESIGN_SPEC_D1-D30.md`](04_CONSOLIDATED_DESIGN_SPEC_D1-D30.md) | **The consolidated spec.** Full game: core loop, weapon/Function system, Turn(), combat math, enemies, progression, Limiters, D1–D30 experience, player sentiment, designer intent. Every claim tagged **[GS: source]** vs **[ASSUMED]**. Synthesized from the entire corpus |
| [`Web Sources/`](Web%20Sources/) | **Phase 1 knowledge base** — 40 web sources captured word-for-word (`<NN-slug>/content.md` + `_meta.md` + `images.md` + raw payloads). 148 images. Scraped + independently verified by a 2-stage agent workflow |
| [`Video Analysis/QLYkM4YZEMc/`](Video%20Analysis/QLYkM4YZEMc/VIDEO_BREAKDOWN.md) | **Phase 2 — 2nd video** "How to Play: Functions and Limiters" (2014 tutorial). Transcript + 102 frames + breakdown with verbatim in-game Function/Limiter panels |
| [`Reviews/`](Reviews/) | **Phase 2 — player sentiment.** 600 Steam reviews (`.csv` + `.jsonl`) + `summary.md` (lifetime ~94% positive, 31,153 reviews). Play Store N/A — Transistor is not on Android |
| `Technical Synthesis and Systemic Analysis of Transistor….md` · `Transistor_ Comprehensive Game Design Specification….md` | Source-cited research dossiers (pasted in by Biswajeet) — Function tables, MEM costs, Limiter data, AI/FSM notes, story beats. Inputs to docs 03 + 04 |
| [`MANIFEST.md`](MANIFEST.md) | File index, sizes, how to re-run |
| `_hhqPQH01Zw.*` (`transcript.txt`, `info.json`, `en.vtt`), `_parse.py`, `frames/` | First video (`_hhqPQH01Zw`) raw artifacts — transcript (2,766 words), metadata, captions, parser, 300 frames (1 / 3 s; timestamp = frame# × 3 s) |

---

## The three systems at a glance

| System | One-liner | Frame |
|---|---|---|
| **Functions** | No basic attack. Each Function works as **Active** *or* **Upgrade** (slotted into another) *or* **Passive** → combinatorial loadouts | [f_00155](frames/f_00155.jpg) ⭐ |
| **Turn()** | Freeze → queue actions vs a meter → execute in a burst → vulnerable cooldown (move-only). Predicted damage shown but not guaranteed; **positioning is the cost** | [f_00170](frames/f_00170.jpg) (plan) · [f_00110](frames/f_00110.jpg) (execute) |
| **Limiters** | Opt-in handicaps (e.g. *Efficiency* = enemies hit 2× harder) that pay an **XP multiplier** → faster Function unlocks. Self-policing difficulty | [f_00190](frames/f_00190.jpg) ⭐ |

**Four pressures that force recombination:** memory budget · soft-death strips a Function · challenge rooms demand weird builds · Limiters trade difficulty for build-toy XP. → detail in [`02_DESIGN_REFERENCE.md`](02_DESIGN_REFERENCE.md) §2.
