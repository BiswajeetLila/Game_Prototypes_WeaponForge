# WeaponCraft — Live-ops Roadmap

> ⚠️ **SCOPE: post-LAUNCH live-ops only — NOT the prototype build queue.** This file also
> predates the wittle-inversion pivot (it describes the old TFT-shop / recipe content model),
> so treat it as historical/aspirational. **The current prototype queue is `docs/STATUS.md`
> §4 NEXT** — the single source of truth for "what's next."

This roadmap follows the "ship A, grow into D" plan: launch with a focused chapter-map progression RPG (Q6 option A), expand to a chapter-map + weekly endless event hybrid (Q6 option D) by Season 2.

---

## v1.0 — Launch

**World structure: chapter map only (Q6 = A).**

Content:
- 2 chapters at launch (~25 stages, ~10–15 hours of campaign content).
- 15 characters total: 3 free starters (Warrior, Mage, Rogue) + 12 gacha-only (4 Rare, 5 Epic, 3 Legendary).
- ~30 base parts × 4 rarities (Common/Rare/Epic/Legendary).
- ~200 discoverable recipes (effect combos from tag-based crafting).
- 1 chapter boss per chapter, 1 chapter sub-boss every 5th stage.

Systems:
- TFT-style parts shop with reroll.
- 5–6 wave stage structure (~3–4 min per stage).
- AFK idle reward layer (12hr cap).
- Stamina-gated stages (3 free plays + paid refills).
- Discovery codex with hint silhouettes + scroll drops + saved Build Templates.
- Boss-retry counter-build loop.
- Star-Up via duplicate shards.
- Passive parts merge (3 → 1 next rarity) in stash.

Monetization:
- Gacha (character pulls, part shard packs, recipe scroll packs).
- Battle Pass Season 1 (free + premium track).
- Rewarded ads (free pulls, 2× rewards, stamina).
- IAP bundles (starter packs, monthly card, holiday bundles).
- Cosmetics (hero skins, weapon glow, ultimate VFX).

---

## v1.x — Months 2–6 (post-launch ramp)

Cadence: new chapter every 6 weeks (~5–8 new stages each).

- **Month 2**: Chapter 3 launches. 1 new hero via featured banner. New boss affinity introduced (Frost-immune boss, requires Fire counter-build).
- **Month 3**: Chapter 4 launches. 1 new hero. Recipe scroll event (limited-time pack with 5 rare scrolls).
- **Month 4**: Chapter 5 launches. 2 new heroes (banner refresh week). New element keyword added (Lightning) → unlocks new recipe space.
- **Month 5**: Chapter 6 launches. 1 new hero. Battle Pass Season 2.
- **Month 6**: Chapter 7 launches. 1 new hero. Quality-of-life refresh based on player data.

Live-ops cadence:
- **1–2 new heroes/month** via featured banners.
- **1 new boss affinity** every 2 chapters.
- **Recipe codex expansions** every chapter.
- **Seasonal Battle Pass** every 8 weeks.

---

## v2.0 — Season 2 (expand to Q6 = D)

**World structure: chapter map + weekly Endless Tower event.**

The Endless Tower is the live-ops engagement engine — it adds whale-extraction depth without doubling content-pipeline burden.

- **Endless Tower mode launches.** Single ascending tower, scaling difficulty, leaderboards reset weekly.
- **Tower-exclusive cosmetics** (special weapon glows, leaderboard banners, hero skins).
- **Tower-exclusive recipes** (rare effects only discoverable in tower play, then permanently unlocked).
- **Tower Battle Pass** parallel to main BP. Whales who chase leaderboards have a dedicated progression track.
- **Tower stamina** separate from main stamina (so it doesn't compete with campaign play).

Target feature parity with AFK Journey / Wittle Defender by end of Season 2.

---

## Beyond Season 2

Opportunistic content additions, prioritized by player data:

- **Month 9**: PvP arena (async ghost-data) — players' best stage runs become AI opponents for matchmaking.
- **Month 12**: Guild raids — large-scale weekly boss with shared damage contribution.
- **Crossover events** — IP partnerships (Wittle Defender did this with Cookie Run); opportunistic and budget-dependent.
- **Daily dungeon rotations** — limited-time stage variants with bonus rewards.

---

## Strategic notes

- **Architect for D from day one, ship as A.** Endless Tower mode should be data-modeled in v1.0 even if not exposed in UI. Cheaper to refactor zero code than re-architect a shipped system.
- **Pull rates and pity should be locked at launch.** Changing rates post-launch causes player backlash (Genshin and AFK Journey both learned this hard).
- **Content cadence > content depth.** Casual-mobile retention is driven by "something new this week" feel, not by "more variety in any one drop." Lean into smaller-frequent over large-rare.
- **Battle Pass is the steadiest revenue.** Optimize BP design hardest after launch — it has the highest ratio of revenue-to-content-cost.
