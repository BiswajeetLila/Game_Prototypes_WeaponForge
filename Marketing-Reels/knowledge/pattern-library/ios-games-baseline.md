# iOS Games (cat 6014) — broad baseline creative patterns
> Source: app-intel `ad_top_creatives` · networks: Applovin (10) + Unity (10) · Instagram + TikTok pulled but **0 creatives** (structurally empty for iOS-Games/US, Dec 2025–May 2026 — coverage gap, not a query bug) · os=ios, country=US, ad_types=video, period=month (AppLovin 2026-05-01; Unity fell back to 2026-04-01 after 2026-05 returned count:0) · pulled 2026-06-14 · 20 creatives.

> ⚠️ This is the **iOS-Games umbrella (cat 6014)**, NOT a single genre. The winning set is overwhelmingly **casual puzzle / match-3 + a hyper-casual outlier (Hole.io)**. For tactical-autobattler-specific patterns, re-pull targeted by competitor app_ids — see [`tactical-autobattler.md`](tactical-autobattler.md).
> ⚠️ All first-1s descriptions are **INFERRED** from app+genre+format (vertical 720×1280 / landscape 1280×720) — the actual mp4 bytes were NOT decoded. High confidence for documented advertisers (Dream Games pull-pin, Gossip Harbor drama, Block Blast/Candy Crush satisfying-clear); lower for smaller merge titles.
> ⚠️ Run length = ad-unit lifetime-to-date (`last_seen − first_seen`), a performance proxy, NOT spend. Ranking is over **top-ranked returned rows only** (AppLovin 50 of 74,551; Unity 50 of 13,092).

## Winning hooks (longevity-ranked)
| pattern | example app | run length | first-1s (inferred) |
|---|---|---|---|
| Satisfying-clear / fake-fail ASMR (near-complete grid, one move left, finger about to swipe) | **Word Search Explorer** | 2023-07→2026-06 = **≥1056d** | near-finished word grid, one word left, finger poised (or intentional wrong swipe = "you can do better") |
| Oddly-satisfying tile-clear / ASMR cascade | **Vita Mahjong** | **486d** | crowded mahjong tower, hand taps pairs that pop & dissolve, board melts fast |
| Satisfying-clear, longer ("lvl 1 vs lvl 999" tease) | **Vita Mahjong** | **467d** | same tower, difficulty-jump tease, then tap-cascade |
| Pull-the-pin / save-the-king peril fake-fail ⚠️ ≥401d left-censored | **Royal Match** (Dream) | **≥401d** | trap diorama: lava rising toward King Robert, two pins (one wrong), finger on the fatal one — withholds the match-3 board |
| Satisfying near-miss combo (8×8 grid, ghost piece, combo counter) ⚠️ ≥401d | **Block Blast!** | **≥401d** | nearly-full grid, one perfect-fit slot, combo counter teasing a screen-clear |
| Ragdoll-violence gag (punchy 30s) ⚠️ ≥401d | **Bowmasters** | **≥401d** | character mid-wind-up, aim-arc on opponent, slow-mo headshot promised in ~2s |
| Cartoon fail-bait + "help the character" | **Toon Blast** | **395d** | mascot trapped, wrong move in progress + red X, baits a correction tap |
| Big-cascade "Sweet!/can-you-solve-this?" | **Candy Crush Saga** | **395d** | candy board mid-explosion, color-bomb combo, one tap from clearing |
| Pull-the-pin king-in-peril (sibling) | **Royal Match** | **368d** | King dangling over hazard, countdown, two rope choices |
| Chaos / power-fantasy escalation | **Hole.io** (Voodoo) | **339d** | tiny hole swallows trash→car→building in ~2s |
| IQ "are you smart enough" (NOT rage-bait) | **Elevate** | **325d** | clean card, fast word/math puzzle + ticking timer, answer-in-your-head |
| Merge-reveal + narrative-mystery | **Mystery Town** | **318d** | dark detective scene, items merge brighter, "Who did it?" caption |
| Pull-the-pin playable-style funnel (112–119s) | **Royal Kingdom** (Dream) | **312d** | trapped king / rising lava + wrong pin, loss-aversion before match-3 reveal |
| Unblock fail-bait ("don't get it wrong") | **Color Block Jam** | **298d** | blocks behind color gates, wrong drag starting, board about to jam |
| Soap-opera betrayal (story-first, merge-second) | **Gossip Harbor** | **294d** | betrayal scene, "My husband…" caption; merge shown briefly after |

## Winning structures
- **Pull-the-pin / save-the-character fake-fail → core-loop reveal** — Royal Match, Royal Kingdom, Toon Blast, Color Block Jam · 59–119s · manufactured peril + a wrong choice in progress → loss-aversion + "they pulled the wrong one!" corrective-tap, *withholding the core loop*. The single most-repeated long-runner structure.
- **Oddly-satisfying / ASMR clear (near-complete board → cascade payoff)** — Word Search, Vita Mahjong, Block Blast, Candy Crush · 30–60s · "I want to finish that." **Highest-longevity family overall** (the ≥1056d + 486d/467d winners).
- **Power-fantasy / destruction escalation** — Hole.io · 38s · small→huge in 2s.
- **"Are you smart enough" timed micro-puzzle** — Elevate · 47s · vanity/self-improvement, a durable non-fail-bait lane.
- **Drama-first / merge-second emotional cold-open** — Gossip Harbor, Mystery Town · 57–59s.

## Saturated / avoid
- **No genuinely burned-out creative is observable here** — every returned row is a top-ranked survivor (min ≈241d). The short-run high-freq burnouts were filtered out by the API's top-ranking. **Do not read the absence as "nothing is saturated."**
- ⚠️ The 3-way 401-day tie (Royal Match / Block Blast / Bowmasters) shares identical first/last_seen → **left-censored at the ~13-month window edge**. Read as "≥401d"; never let it outrank the genuine 1056d Word Search Explorer.
- **Saturation risk (inferred): pull-the-pin fake-fail is the most-copied hook** (Dream Games + Toon Blast + Color Block Jam). High imitation density = classic fatigue precursor; fresh clones arrive late. ASMR-clear is similarly crowded.
- **No Instagram/TikTok evidence** — both count:0 across 3–5 fallback months (provider coverage gap, cross-checked vs a populated AppLovin call). Any "what works on IG/TikTok" claim is unsupported by this data.

## Recurring copy / caption phrases
- "Pull the pin" / "save the king" + wrong-vs-right choice · "My husband…" betrayal · "Who did it?" mystery · "Can you solve this?" / "are you smart enough?" · "Sweet!"/"Delicious!" payoff popup · "Level 1 vs Level 999" / "clear this in 30s?" · red ✗ + wrong-move-in-progress corrective bait (text-light).
