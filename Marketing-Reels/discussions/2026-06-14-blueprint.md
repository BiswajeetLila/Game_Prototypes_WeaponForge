# `marketing-reels` — pipeline blueprint

> **⚠️ SUPERSEDED (shape only) by [`2026-06-14-3phase-design.md`](2026-06-14-3phase-design.md)** — the approved 3-phase, game-agnostic design we're building. This v1 doc is retained for the skill audit, the two reviews, and the probe results (still current).
> Status: **design / blueprint** (not built). Authored 2026-06-14.
> This is the brief a future `skill-creator` + `Workflow` session consumes.
> Revised after two adversarial reviews (see [`2026-06-14-review-growth.md`](2026-06-14-review-growth.md) and [`2026-06-14-review-systems.md`](2026-06-14-review-systems.md)). Corrections from that review are marked **[rev]**.

## What this is

When a game prototype nears the end of its brainstorm/planning phase, produce a TikTok/IG creative **and** a longer cut that pull the *ideal* customer — repeatably, via an invocable workflow.

**[rev] Honest premise.** The anchor game (`6_WeaponForge_TFTransistor`) is an unshipped prototype: no store listing, no install button, ~3 FTUE waves built. The real job is **demand / concept validation**, not user acquisition. "Sell" = generate cheap real signal that the *concept and art direction* pull the target player — measured, not vibes. Framing the output as an "app-store performance ad" solves a launch problem the game is years from having.

Two facts anchor the work:

1. **A version of this exists — manually.** `5_WeaponForge_Honkai_Godot/Mockup/d1-trailer/D1-gameplay-video-script.md` + 47 beat renders + style bible + key art + the AFK-Journey trailer teardown (`docs/research/reference-games/afk-journey/videos/`). **[rev] But that artifact is a *trailer/animatic* (opens on a studio-logo sting + cinematic push-in), not a hook-first performance ad.** It proves the *asset + beat-production* flow we should codify — it does **not** prove the performance-ad hook logic, which is the new, unproven part.
2. **The two obvious skills are necessary but neither is the spine.** `ai-video-beats` = the final assembler. `futureback` = aspirational 3–5yr projection — optional flavor for a vision cut, not the validation-creative driver.

**Locked decisions:** scope = audit + blueprint only · spine = market-driven *concept-validation* creative (hook-tested) · anchor = `6_TFTransistor` · output = two cuts from one master beat sheet.

---

## Part 0 — Objective + persona (pin these first or nothing optimizes)

- **Primary action + KPI.** Pick ONE: playtest signup · wishlist · Discord join · publisher/investor reaction. KPI = **hook-rate** (3-sec view-through) + cost-per-action. Inherit the org's existing bar: `5_Honkai/CLAUDE.md` defines a CPI exit gate (≤$2.80 ≈ 80% of the Wittle benchmark).
- **One primary persona, named** — not "casual tactician" (comparables span Brotato-hardcore → Capybara-idle → AFK-midcore — opposite ads). Force a single persona with a *named pain* and a *scroll context*. Example for 6_TFT: *"ex-Archero / Capybara-Go player, bored of one-button autobattlers, wants build expression without APM, watching Reels on the commute, sound usually OFF."*
- Two cohorts = two tagged hook variants, never one mushy average.

---

## Part 1 — Skill / tool audit (corrected)

★ = high-value tool not obvious at first pass. **[rev]** marks a correction from review.

| Stage | Skill / tool | Verdict |
|---|---|---|
| **Reuse** | repo `greenlight-pitch.md`, `D1-trailer` script, `competitor-landscape-synthesis.md`, style bibles | Codify the *production* flow. **[rev]** Don't inherit the trailer's cinematic logo-open as a perf-ad pattern. |
| **Positioning** | `product-management:competitive-brief`, `:synthesize-research`, `design:user-research` | Extract the ONE hook + the single persona (Part 0). |
| | ★ `lila-skills:play-store-reviews` | Mine competitor review *language* for ad copy (not stats — scraped sample ≠ lifetime). |
| | ★ `Research_Eastern_Intel` | Comparables are East-Asian-led; surfaces patterns Western search misses. |
| **Creative intel** | ★ App-intel MCP (`ad_top_creatives`, `ad_network_analysis`, `top_and_trending`, `aso_keyword_research`) | **[rev]** Use for **target selection + format/saturation** (who's spending, what length/CTA works, what's oversaturated to *avoid*) — **not** hook *content*. License unconfirmed → Part 4 probe + fallback. |
| | ★ `lila-skills:video-analysis` | **[rev]** The real teardown engine, but a **macOS** toolchain (brew/whisper-cpp/tesseract) on a **Windows** box — won't run natively. Use WSL/scoop, or fall back to in-repo AFK-Journey breakdowns. |
| | `deep-research` | Backstop when MCP coverage is thin. |
| **Concept gate** | ★ `Council_LLM` | **[rev]** Demoted: sanity-checks beat-sheet *logic*, can't predict hook-rate. Real pre-spend gate = **cheap real signal** (480p variants → tiny organic/paid test). |
| | `futureback` | Optional vision-cut flavor only. |
| **Assets** | ★ `lila-skills:ai-art-set` | 1 ref frame → key art + mockup + beat frames. **[rev]** Does **not** "force cheap nano-banana": it *mandates* `nano-banana-pro` for its 2 pilots and asks per-batch; last real run = **$0.84** (`6_TFTransistor/_art-build/manifest.md`). Reconcile per-name pro approval with the global cost policy. |
| **Video** | `lila-skills:ai-video-beats` | The assembler. Requires a **hosted public URL** + harness may block proprietary uploads → Part 4. |
| **Package** | ★ `skill-creator` / `write-a-skill`; **`Workflow`** | See architecture correction (Part 2). |

---

## Part 2 — Pipeline design (architecture corrected)

**[rev] Core correction — this is NOT "one skill that calls other skills."** Skills are model-read instructions with no `invoke()`; the lila skills are explicitly manual-only with blocking cost gates. The deliverable is two cooperating pieces:

1. **A human-driven runbook** — the gated, judgment-heavy spine. A checklist of *when to fire each `/lila-skills:` skill by hand* and *how to hand artifacts between them*. Owns Stages 0–C and the cost gates.
2. **An optional `Workflow` (MCP-direct)** — for automatable fan-out only: calls **MCP tools directly** (`generate_image`, `generate_video`, app-intel pulls) and re-implements gates as approval points. Owns the Stage-B research fan-out and the Stage-E **hook-variant batch**.

### Stages

- **0 — Objective + persona** (Part 0) → `brief.md`.
- **A — Positioning** → `positioning.md`: the ONE hook, the single persona, USP-line candidates, 3 comparables.
- **B — Creative intel** → `creative-intel.md`: app-intel for *format/saturation/targets* **and direct creative media** (`ad_top_creatives` returns S3 `.mp4` URLs + durations + dims → `curl` + `ffmpeg` frame-teardown, both present natively — see Part 4 Probe 1/2); review-language mining via `play-store-reviews`; YouTube-trailer teardown only if `yt-dlp` installed. **[rev]** Fallback (now unlikely — license confirmed): in-repo AFK breakdowns + `play-store-reviews`.
- **C — Beat sheet + N hook variants + gate** → `beat-sheet.md` + `hooks/`: one master 5-beat body, then **[rev] ≥3–5 hook variants sharing that body**. **≥1 variant leads with the differentiator** (cross-hero reaction / "forge functions, not pulls") — anti-mimicry. **[rev] Sound-off legibility is a hard gate** (every beat reads muted with burned-in captions). Pre-spend gate = cheap-signal plan, not Council.
- **D — Assets (GATED $)** → `ai-art-set`: ref frame → key art + mockup + beat first-frames. **[rev]** Cost ~$0.84, pro pilots, approve per cost policy.
- **E — Video (GATED $)** → `ai-video-beats`: batch the hook variants at Seedance Fast 480p → upscale only winners. Frame-verify loop.
- **F — QC + package** → output folder (Part 3) + run manifest (cost + URLs).
- **G — Iterate** → read KPI signal → cull losers → re-cut winners. (Stub for blueprint scope, but named — the actual UA job lives here.)

### Footage honesty — the locked dual-cut/dual-source rule (both reviewers endorsed)

- **Social variants (9:16, 15–30s):** stylized `ai-art-set` frames — **[rev] constrained to what the prototype can almost deliver**; any aspirational shot labeled "target visual / not actual gameplay." Validating idealized footage you can't ship validates a mirage.
- **Truth cut (30–60s):** **real gameplay capture** via the existing `WC_AUTOSHOT` + `screenshot_helper.gd` of FTUE 1–3. **[rev]** Honesty anchor, not an "app-store ad" (no store exists yet).
- Art-direction validation and gameplay-concept validation are *separate tests* — measure separately.

---

## Part 3 — Folder structure

Two homes, deliberately separated.

### 3a. The pipeline folder (this folder — `Marketing-Reels/` at repo root)
```
Marketing-Reels/
├── README.md
├── discussions/   (this blueprint + the two preserved reviews)
├── templates/     (brief · positioning · creative-intel · beat-sheet · hook)
├── skill/         (DEFERRED build — placeholder README)
├── workflow/      (DEFERRED build — placeholder README)
└── tests/         (contract-test spec — TDD applies at build time)
```

### 3b. Per-run output — inside the target game's existing `_art-build/`
```
6_WeaponForge_TFTransistor/_art-build/
├── ref-gameplay.png            # EXISTING cold-start ref frame (bootstrap for Stage D)
├── style-bible.md  asset-spec.md  manifest.md   # EXISTING — reuse
├── screens/  renders/          # EXISTING art outputs
└── marketing-reels/<YYYY-MM-DD>/
    ├── brief.md  positioning.md  creative-intel.md  beat-sheet.md
    ├── hooks/hook-{01..0N}.md            # Stage C variants (≥3–5)
    ├── video/
    │   ├── beat-script.md
    │   ├── social_9x16_hook01..0N.mp4    # variant batch (stylized, labeled)
    │   ├── truth_16x9_<slug>.mp4          # real AUTOSHOT capture
    │   └── frames-qc/
    └── manifest.md             # run index: artifacts, total cost, hosted URLs
```
**[rev]** ai-art-set defaults to a `synthetic-art/` folder — the runbook redirects/copies into `_art-build/`. Cold-start ref = existing `_art-build/ref-gameplay.png` + its hosted URL in `manifest.md`; document the manual host step that clears the upload block.

---

## Part 4 — Pre-build probe checklist

### Probe results — RUN 2026-06-14 (all four green)

1. **App-intel license → ✅ PASS (strong).** `ad_top_creatives` (os=ios, cat=6014 Games, US, network=Applovin, 2026-05-01, month) returned **74,551** creatives with direct media URLs (`creative_url`/`preview_url`/`thumb_url` on S3), `video_duration`, dimensions (e.g. 720×1280 = 9:16), `first_seen_at`/`last_seen_at`, and per-app attribution (Royal Kingdom/Dream Games, Brawl Stars/Supercell, Vita Mahjong). The Ad-Intelligence module is fully licensed.
   - **Gotchas for the runbook:** valid `network` values are `Adcolony, Admob, Applovin, Chartboost, Instagram, Mopub, Pinterest, Snapchat, Supersonic, Tapjoy, TikTok, Unity, Vungle, Youtube` (**no "Facebook"** — use `Instagram`). `usage.limit:0` does **not** mean blocked. Some date×network combos return `count:0` (e.g. TikTok/2026-06-01 was empty) — pick a populated month/network.
2. **video-analysis on Windows → ✅ effectively unblocked.** `ffmpeg`/`ffprobe` present (winget); `wsl` + `winget` present. `yt-dlp`/`tesseract`/`whisper` absent. **But Probe 1 changes the math:** ad creatives arrive as direct `.mp4` URLs, so the primary teardown path = `curl <creative_url>` + `ffmpeg` frame-extract — **fully native, no yt-dlp/whisper/tesseract**. `winget install yt-dlp` is needed *only* to tear down YouTube trailers; whisper/tesseract only for local transcription/OCR (skippable — YouTube auto-subs via yt-dlp avoid whisper).
3. **Hosted-URL gate → ✅ PASS.** `generate_video.image_url` accepts http(s) URLs; the gen-MCP returns permanent public `cdn.syntheticalresearch.com` URLs for every image → feed straight into video. Cold-start anchor already hosted (`i.ibb.co/...` in `_art-build/manifest.md`). Only the first anchor is a manual host step.
4. **Chaining → ✅ CONFIRMED NO.** ai-video-beats frontmatter: *"manual invocation; not intended to auto-trigger."* Locks the runbook + MCP-direct-Workflow architecture (no nested-skill auto-invoke).

**Net: no remaining feasibility blockers.** The spine is real and stronger than assumed (app-intel yields creative media + durations + dims directly).

### The probes (for re-running on another machine/game)
1. **App-intel license** — one `ad_top_creatives` call (use a populated network like `Applovin`): returns data? If no → demote to optional, promote in-repo research.
2. **video-analysis toolchain** — confirm `ffmpeg` + (for YouTube) `yt-dlp`; ad-creative teardown needs only `curl`+`ffmpeg`.
3. **Hosted-URL gate** — confirm a public URL passes `generate_video.image_url`.
4. **Chaining** — confirm `/lila-skills:` skills can't be auto-invoked → runbook architecture.

---

## Worked example — `6_WeaponForge_TFTransistor`

**Read first:** `6_WeaponForge_TFTransistor/docs/01_GDD.md`, `docs/story-beats-2026-06-13.md`, `2_Weaponcraft_Godot/docs/superpowers/specs/2026-06-12-greenlight-pitch.md` (positioning format).

**Game in one line:** *Forge functions, run the lane, react in chains.* A 3-hero squad (Elara mage / Bran warrior / Vex rogue) auto-walks a 3-lane corridor; you reshape each hero's attack by socketing Functions, then chain cross-hero Magicka reactions.

**Comparables:** Capybara Go · Wittle Defender · Brotato · Slice & Dice · AFK Journey.

**The ONE hook:** the differentiator nobody else has — *you don't pull heroes, you forge their functions*, and **cross-hero reaction chains** ("I CAUSED THAT"). Genre convention (gacha pulls, one-button auto) is the foil.

**Master 5-beat body (perf-ad, NOT logo-open):**
1. **0–1s Hook** — cold open on the payoff: a cross-lane Electrocute chain lights all 3 lanes, chain-counter spikes. (Open on dopamine.)
2. **1–4s Problem** — fast contrast: "every autobattler plays itself" — dull one-button combat.
3. **4–8s Mechanic reveal** — drag a FIRE Function into a socket → Elara's attack visibly changes shape + color. Caption: *forge functions, not pulls.*
4. **8–12s Payoff** — FIRE on Wet enemies → STEAM burst across lanes; counter ticks; the *"I CAUSED THAT"* beat.
5. **12–15s CTA** — primary action (wishlist / playtest signup) over key art.

**Hook variants (≥3, share the body above):**
- **H01 payoff-led (differentiator-first):** open on the Electrocute chain, no setup.
- **H02 problem-led:** "POV: every autobattler bores you in 10 seconds" → reveal.
- **H03 POV/UGC:** phone-in-hand, drag a Function, genuine "wait — I made that?"
- **H04 stat-led:** "3 heroes · 12 functions · 15 reactions · 1 chain" rapid-fire.
- **H05 reaction-led:** "watch this combo" → chain stinger. (H01 or H05 satisfies the differentiator-first rule.)

**Assets:** bootstrap ref = `6_TFTransistor/_art-build/ref-gameplay.png` (+ hosted URL in its `manifest.md`); truth-cut footage = AUTOSHOT of FTUE 1–3 (Elara solo → Bran joins → Steam moment).

---

## Risks
1. ~~App-intel license unconfirmed~~ → **RESOLVED 2026-06-14** (Probe 1: 74,551 creatives returned; module licensed).
2. ~~`video-analysis` macOS-only on Windows~~ → **DOWNGRADED 2026-06-14** (Probe 2: ffmpeg native; ad-creative teardown = curl+ffmpeg, no yt-dlp/whisper. yt-dlp install optional, YouTube-only).
3. Thin real gameplay (FTUE 1–3 only) → truth cut is small; social variants must stay near-buildable, not mirages. **(Still open — the main real constraint.)**
4. Cost reality (~$0.84/asset run, pro pilots mandatory) vs the global never-pro-unless-named policy → explicit per-run approval.
5. Validation target must be named (Part 0) or "convert" is undefined for a storeless prototype.
