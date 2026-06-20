# Adversarial review — growth / UA lens

> Preserved verbatim. Reviewer stance: skeptical performance-marketing / user-acquisition lead. Verdict: **needs-changes**.
> (Project later renamed `game-sell-reel` → `marketing-reels`; the critique stands unchanged.)

---

## UA teardown: `game-sell-reel` blueprint

**Lead with the weakest point, ranked by damage.**

**1. The blueprint never names the conversion target — so nothing in it can be optimized.** The goal statement is "attract the *ideal* customer" and Stage F outputs "both videos + a manifest (cost + URLs)." That's the tell: the deliverable is *files*, not a *funnel*. A reel for an unshipped prototype has no install button — so "convert" is undefined. Wishlist? Discord join? Playtest signup? Publisher/investor reaction? Each demands a *different* hook, CTA, length, and success metric. The plan asks none of this. `5_Honkai/CLAUDE.md` already encodes the real bar — "ad CPI ≤ 80% of Wittle benchmark (~$3.50 → ≤ $2.80)" — which proves the org knows what a conversion goal looks like; this blueprint omits it.
**Fix:** Add a Stage 0 "Objective + KPI" that forces one primary action and its proxy metric (hook-rate / 3-s view-through, click-to-signup). Every later stage inherits it.

**2. No store listing + no install destination = the funnel has no floor; this is a *concept-test* reel, and the plan won't admit it.** Risk #3 concedes "only FTUE 1–3 + Steam reaction are capturable today," yet Stage E still emits a `trailer_16x9` whose rule is "must use real gameplay capture … App-store ad policy and player trust require footage to represent real gameplay." You cannot run an app-store ad for an app with no store page, nor honor app-store-footage policy for a game with ~3 FTUE waves built.
**Fix:** Reframe both cuts as **demand-validation creatives**, not acquisition ads. Kill the "app-store trailer" framing for this stage; replace with "concept reel → landing page → signup/wishlist," measured on click-through and cost-per-signup.

**3. "Fake/idealized gameplay" for an unbuilt game is a validation *poison pill*.** The plan leans on `ai-art-set` stylized frames to "fill gaps" and calls stylization "fine and expected." For a *concept test* that is actively harmful: if the ad shows VFX-drenched cross-hero Magicka chains the prototype can't render, a low CPI/high signup rate validates *the fake video*, not *the game*. You'll greenlight against a mirage and eat the gap at playtest. Signups acquired on footage that doesn't exist churn on contact.
**Fix:** Constrain the social cut to what the prototype can *almost* deliver (real AUTOSHOT + light VFX polish), and label any aspirational cut "target visual / not actual gameplay." If the goal is *art-direction* validation, that's legitimate but *different* — name it and measure separately.

**4. Single beat sheet, zero hook variants — the opposite of a UA workflow.** The plan produces *one* master 5-beat structure and *one* social cut. Real UA lives or dies on hook-rate testing: ship 4–8 first-3-second hooks against the *same* body and let the platform kill the losers. The "creative intel → hook taxonomy" engine builds a taxonomy then spends it on a single execution.
**Fix:** Stage C must emit **N hook variants** (≥3–5) sharing one body — problem-led, payoff-led, POV/UGC, reaction-led, stat/number-led. Stage E batches them at 480p. The deliverable is a *hook test matrix*, not a hero cut. This is where the `Workflow` fan-out actually belongs.

**5. Competitor-ad mimicry as the spine is a recipe for derivative scroll-past.** Stage B says reverse-engineer competitors' "beat cadence, first-1s hook, on-screen-text pattern, CTA" and fuse into *your* beats. Mimicking AFK Journey / Capybara Go ads means arriving late to a saturated, fatiguing pattern; the algorithm has seen that creative 10,000 times and your unbranded clone loses the auction. Worse, your differentiator ("forge functions" / cross-hero reactions) is precisely what's *absent* from their playbooks.
**Fix:** Use app-intel for **structure and anti-patterns** (what format/length/CTA works, what's oversaturated to *avoid*), not for hook content. Mandate ≥1 hook variant lead with the *mechanic nobody else has*.

**6. "Casual tactician" is too vague to drive a frame.** The five comparables span opposite players — Brotato/Slice & Dice (hardcore roguelike depth) vs Capybara/Wittle (idle-casual mass market) vs AFK Journey (mid-core gacha). These cohorts want opposite ads. The plan outputs "ideal-customer archetype" as a single slot and never resolves the tension.
**Fix:** Force Stage A to pick **one primary persona with a named pain and a scroll context**. Two cohorts = two persona-specific hook variants, explicitly tagged.

**7. No iteration loop, no sound-off design, no platform-native splits.** The pipeline is linear A→F and stops at QC. No "read the numbers → kill losers → re-cut winners" cycle. It treats "social/paid (9:16)" as one bucket, but TikTok (sound-on, UGC-native), Reels (polished, trend-audio), and paid (Meta/AppLovin — sound-OFF default, read in 1s muted) demand different masters.
**Fix:** Add Stage G "iterate". Make **sound-off legibility a Stage C gate** (every beat reads muted with burned-in captions). Split "social" into TikTok/Reels-organic vs paid-sound-off masters with safe zones.

### Smaller but real
- **App-intel role is slightly inverted.** `ad_top_creatives`/`ad_network_analysis` support *target selection* (who's spending, where) better than *creative teardown* (they surface that creatives exist, not the edit). `video-analysis` is the real teardown engine; app-intel is for targeting.
- **Council_LLM tests the wrong artifact.** An LLM panel can sanity-check a beat sheet's logic but cannot predict hook-rate. The only valid pre-spend gate is cheap real signal (480p variants → tiny test). Don't let a model council stand in for a $20 hook test.
- **Premise check:** marketing a game that isn't built is *sound* — as concept/art/CPI validation (industry-standard pre-production de-risking, exactly what `5_Honkai`'s CPI gate does). It is *not* sound as framed (an "app-store/YouTube trailer" + "performance ad" to "attract customers") — there's no product to acquire into. The premise is fine; the output framing was wrong.

### Verdict: **needs-changes**
The skeleton (reuse-don't-redo, market-driven spine, dual-cut from one beat sheet, hard cost gates) is sound. But as written it would produce a *pretty video that doesn't convert* — because (a) it never defines "convert" for a pre-launch prototype, (b) it ships one creative instead of a hook-test matrix, and (c) it validates idealized footage the game can't deliver. Fix #1 (objective+KPI), #4 (N hook variants), and #3 (constrain footage) before authoring as a skill.

**Load-bearing correction:** the cited proof-of-flow — `5_Honkai/.../D1-gameplay-video-script.md` — opens on a studio-logo sting + cinematic push-in. That's a *trailer/animatic*, the "vision, not market" artifact the plan explicitly demotes. So the blueprint claims to codify a proven *performance-ad* flow while its only evidence is a *trailer* flow. Resolve before building.
