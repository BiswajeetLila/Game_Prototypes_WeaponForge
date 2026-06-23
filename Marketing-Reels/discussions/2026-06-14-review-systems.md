# Adversarial review — systems / feasibility lens

> Preserved verbatim. Reviewer stance: staff eng / tech-lead, adversarial. Read the plan + all 5 dependency SKILL.md files + verified repo state. Verdict: **needs-changes**.
> (Project later renamed `game-sell-reel` → `marketing-reels`; the critique stands unchanged.)

---

## Ranked challenges (most damaging first)

### 1. The orchestration model is wrong: a skill cannot *call* other skills. (breaks the core architecture)
The plan's Part 2 says "Orchestration: skill, not a Workflow" and designs `SKILL.md` to drive Stages A–F, each of which "calls" `ai-art-set`, `ai-video-beats`, `video-analysis`, etc. But in Claude Code a skill is **model-read instructions**, not a callable function. There is no `invoke(ai-art-set)` primitive. Worse: every dependency skill is explicitly **manual-invoke-only** — all four lila skills end with "Invoke explicitly with /lila-skills:… — manual invocation; not intended to auto-trigger." You cannot reliably nest one `/lila-skills:` skill inside another's execution; the model would have to *re-load and re-follow* a second multi-gate SKILL.md mid-run, which collides with the parent's flow and gates.
**Fix:** Reframe the deliverable as a **runbook / orchestration guide the human drives**, not an auto-chaining skill. The "skill" should be a checklist that tells the operator *when to fire each `/lila-skills:` skill by hand* and how to pass artifacts between them. If true automation is wanted later, the only honest options are (a) a `Workflow`/agent that calls the underlying **MCP tools directly** (`generate_image`, `generate_video`) re-implementing the gate logic, or (b) accept human-in-the-loop. The plan's skill-vs-Workflow decision is backwards: the *manual gates* are an argument the chaining can't be autonomous, not an argument for "skill over Workflow."

### 2. The plan's own anchor evidence refutes its "forces cheap nano-banana" claim. (factual error, repeated 3×)
Plan asserts ai-art-set "Forces cheap `nano-banana`". The actual `6_TFTransistor/_art-build/manifest.md` from the last real run says: **"Model: `nano-banana-pro` … user-approved by name"**, batch total **$0.8371**, ~$0.14/image. And ai-art-set's own GATE 2 mandates the two pilots run in **`nano-banana-pro`**. So the skill does *not* force the cheap model — it forces pro for pilots and asks per-batch. The blueprint's cost premise (Stage D ≈ "$0.4–0.8" cheap) is understated and conflicts with the documented real cost, *and* with the user's global "never use nano-banana-pro unless asked by name" cost policy.
**Fix:** Correct every "forces nano-banana" line. State the real gate: pilots are pro by default, batch model is a GATE-2 choice, real runs ~$0.84. Reconcile with the cost policy explicitly (who approves the per-name pro spend, at which gate).

### 3. Stage B's competitor-reel teardown is built on a macOS toolchain that does not exist on this Windows box. (a whole stage won't run as written)
`video-analysis` prerequisites are `brew install yt-dlp ffmpeg tesseract whisper-cpp`; its scripts hardcode `~/.cache/whisper`, `ln -sf`, `/private/tmp` realpath workarounds, `whisper-cli`, and a "CRITICAL: macOS sandbox quirk" section. The environment here is **Windows 11 / PowerShell**. The plan's risk list never mentions the OS mismatch — only *finding URLs*. Stage B is a "spine" stage; if it silently can't run, the market-driven differentiator collapses to the app-intel MCP alone (see #4).
**Fix:** Add an explicit Windows-port risk. Either (a) document Windows equivalents (winget/scoop yt-dlp + ffmpeg + tesseract, whisper.cpp Windows build, drop `/private/tmp` hack) and verify in a 1-clip POC, or (b) scope Stage B's video teardown to "manual / WSL only" and lean on the in-repo AFK-Journey breakdowns already cited.

### 4. The entire spine is anchored to an MCP whose license is unconfirmed, with no real fallback. (single point of failure)
Plan Part 1 calls the App-intelligence MCP "the spine," then risk #1 admits the **license/Ad-Intelligence module is unconfirmed**. The named fallback (`deep-research`) is a thin backstop for ad-creative taxonomy, and the *other* spine input (`video-analysis`, #3) is also at risk on this OS. Both legs of the "market-proven creative intel" spine are shaky simultaneously.
**Fix:** De-risk Stage B *before* it's the spine. One cheap probe call (`ad_top_creatives` or `api_usage`) confirms module access. If unlicensed, demote app-intel to optional and promote in-repo competitor research + `play-store-reviews` language mining to primary. State the fallback architecture explicitly.

### 5. Output folder contradicts the repo's real convention — and the plan's own cited model. (will fragment the repo)
Plan put every run under `6_TFTransistor/marketing/<date>/`, citing `5_Honkai/Mockup/d1-trailer/`. But the **actual** asset-build convention is `_art-build/` — it exists in *both* `2_Weaponcraft_Godot/_art-build/` and `6_TFTransistor/_art-build/`, and already contains `style-bible.md`, `asset-spec.md`, `ref-gameplay.png`, `screens/`, `renders/`, `manifest.md`. ai-art-set (the cited model) writes to a *third* path, `synthetic-art/`. The plan proposed a fourth tree (`marketing/`) matching neither; `grep` confirms no `marketing/` folder exists today.
**Fix:** Reuse existing trees. Stage-D art lands in / extends `6_TFTransistor/_art-build/`. Put only the *video + reel-specific* docs under a subfolder, e.g. `_art-build/marketing-reels/<date>/`. Reconcile the dep skill's `synthetic-art/` default vs the repo's `_art-build/`.

### 6. The first-ref-image circular dependency is hand-waved — though the repo accidentally saves it. (sequencing gap)
ai-art-set and ai-video-beats *both* hard-require a **hosted public image URL** ("No URL → don't generate") and both note the harness **blocks proprietary uploads**. The plan's Stage D input is "ref frame + one-liner" but never says where the *first* hosted ref URL comes from or how it clears the upload block.
**Fix:** Name the bootstrap: `6_TFTransistor/_art-build/ref-gameplay.png` exists and `manifest.md` has a hosted anchor URL. Document that as the seed, state the manual-host step (user pastes an ibb/cdn URL — the skill can't auto-upload), and note the truth cut's "real gameplay capture" comes from the existing AUTOSHOT (`WC_AUTOSHOT` + `screenshot_helper.gd`).

### 7. "Blueprint-only, no build" defers all the real risk — a 30-min POC would de-risk more than a longer spec. (scope)
Challenges #1, #3, #4, #6 are *feasibility unknowns* no document resolves — each needs one tool call: does the app-intel MCP respond? does yt-dlp run on Windows? can the harness pass an ibb URL into `generate_image`? does a nested `/lila-skills:` invoke complete? Writing a polished spec on four unverified assumptions risks a doc that's confidently wrong.
**Fix:** Keep blueprint scope but prepend a **4-probe feasibility checklist** (no real spend). Fold results into the blueprint's assumptions.

## Verdict
**needs-changes.** The pipeline *insight* is sound (reuse the manual `5_Honkai` flow; add demand-side intel + the asset bridge), and dual-cut/dual-source is genuinely good. But the document ships four load-bearing errors: (1) skills can't chain, (2) mis-stated cost model vs its own manifest + the cost policy, (5) a fabricated folder tree vs the real `_art-build/` convention, and (3)+(4) a spine on an unverified Windows toolchain + unlicensed MCP. Fix #1 (runbook or MCP-direct Workflow), correct the cost claims, repoint to `_art-build/`, add the 4-probe pass — then it's buildable.

**Couldn't break:** the dual-cut/dual-source decision (stylized `ai-art-set` for the 9:16 social cut, real AUTOSHOT capture for the truth cut). Correct on ad-policy grounds and on what `6_TFTransistor` can produce today — leave it locked.
