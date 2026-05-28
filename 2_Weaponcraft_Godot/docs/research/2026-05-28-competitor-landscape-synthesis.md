# WeaponCraft — Competitor Landscape Synthesis

**Date:** 2026-05-28 (v2.2 final, finalised 2026-05-28d)
**Status:** ✅ Finalised. Authoritative position = §0 Executive Summary below. v1 + v2 sections retained as audit trail.
**Author:** Multi-agent web research (3 parallel agents) + Sensor Tower live data (170 calls) + Claude synthesis
**Source design:** [`docs/superpowers/specs/2026-05-27-wittle-inversion-design.md`](../superpowers/specs/2026-05-27-wittle-inversion-design.md) (Wittle Inversion v2.1)
**Scope:** ~55 mobile + PC competitor games across 4 clusters — hero-collector TD/survivor, Vampire-Survivors roguelites, oddball mechanic outliers (dice/bag/merge), top-grossing audience-comp anchors (AFK Journey / Whiteout / Last War / Top Heroes)

---

## How to use this doc

| If you are… | Read… |
|---|---|
| Making a Monday-morning decision | §0 Executive Summary + §Final Recommendations |
| Building UA / marketing strategy | §0 Audience Profile + v2.H + v2.I |
| Defending or revising a design bet | §0 Design-Bet Matrix + v2.D (inversion reframe) + v2.E (kill candidates) |
| Tracking competitor moves quarterly | §Final Recommendations: Track Quarterly + v2.B threat ranking |
| Auditing a claim's confidence | §Confidence Audit (before changelog) |
| Reading the full thinking | Top to bottom — v1 → v2.A → v2.I |

## Table of contents

- **[§0 Executive Summary](#0-executive-summary--authoritative-v22)** ← start here
- §1 TL;DR — Five headline findings (v1, superseded by §0)
- §WC's 9 design bets vs evidence
- §Direct competitive cluster — top 5 (v1)
- §Three validated moats
- §Three landmines
- §Top 3 Habby moves to watch
- §Recommended actions (v1 — superseded by Final Recommendations)
- §Cross-cutting design observations
- §Appendix A — Hero-collector TD/survivor (19 cards)
- §Appendix B — Vampire-Survivors cluster (22 cards)
- §Appendix C — Oddball mechanic cluster (9 cards + Backpack Hero)
- **§v2 Followup (2026-05-28b)** — critique-driven revisions
  - v2.A Live data validation
  - v2.B Rebuilt threat ranking (4 dimensions)
  - v2.C 4 new competitor cards (AFK Journey, Whiteout, Top Heroes, Last War)
  - v2.D Inversion claim reframe (two layers)
  - v2.E **Three bets to consider killing** + reversal paths
  - v2.F Numbers Policy audit
  - v2.H Mystery overlap apps de-anonymized (NTE correction)
  - v2.I Nearest-comp overlap analysis (Habby ∩ anime sweet spot)
  - v2.G Updated TL;DR
- **§Final Recommendations — Path Forward** ← end here
- §Confidence Audit
- §Open Questions / Research Debt
- §Document changelog

---

## §0 Executive Summary — Authoritative (v2.2)

**Replaces all earlier TL;DRs.** Single source of truth as of 2026-05-28d.

### The one-line read

WeaponCraft's design bets are mostly sound. The three biggest risks: (a) **"Resonance" name collision** with Habby (rename now), (b) **Tier 3 spatial forge** competes with games that ship that loop as their entire product (reframe trigger or kill), (c) the **audience target is narrower** than v1 thought — Habby loyalist ∩ anime-curious gamer, not broad "mid-core male." Three moats hold: hard-locked roster, per-hero quest depth, cross-element compound recipes.

### The seven findings that drive the recommendations

1. **Audience target sharpened** (v2.H + v2.I, Sensor Tower data): WC's actual cohort = "**Habby loyalist ∩ anime-curious cross-platform gamer**." Triangulated from app_overlap on 3 closest-feature comps. Wittle Defender's audience = NTE 22% + Crunchyroll 31% + PlayStation 23% + Steam 22% + Discord 54% + Pokémon GO 23%. Archero 2's audience = 4 of top-10 = Habby titles (SSSnaker, Wittle, Archero, Dicero). Cup Heroes' audience = hypercasual graduate (Voodoo + Azur + SayGames, **zero Habby**) → Cup Heroes shares mechanic, not audience.
2. **"Resonance" is Habby-coded** (v1): Archero 2 ships a Resonance mechanic; CapybaraGo ships an "Adventurer Resonance System." **Rename WC compounds before any external asset ships.** Candidates: Confluence, Catalyst, Alloy (forge-theme fit), Reaction, Harmonic.
3. **Inversion bet has two layers, only one is precedented** (v2.D): Equipment-gacha + non-banner-heroes = shipped at $263M lifetime (Archero, 2019). Story-progression-locked roster + 10-quest depth = genuinely unprecedented in F2P mobile RPG (50-game research set). **The combination is the moat.** Either half alone is not.
4. **Tier 3 spatial forge is the most-occupied competitor space** (v1 Appendix C): BagMaster Isekai (760k DL, 4.47★), Backpack Brawl (live), Backpack Battles iOS (Feb 2026) all ship spatial-bag *as the entire game*. WC's Stage-20+ optional toggle risks being benchmarked unfavorably.
5. **Combat-shape seat is empty** (v1 Appendix B): Side-view portrait + locked trio + auto-attack + per-hero tap-ult. Nobody owns this. Yet Another Zombie Survivors has squad-of-3 but no tap-ult; Soul Knight has tap-skill but solo. Marketing problem, not concept problem.
6. **Threat ranking** (v2.B, with v2.I demotions applied):
   1. **Wittle Defender** (Habby) — 23.2% direct audience overlap with Archero 2, same feature shape
   2. **Archero 2** (Habby) — owns "Resonance" name + closest inversion precedent + Habby cross-promo
   3. **Survivor.io** (Habby) — $500M+ lifetime, owns mobile-survivor mindshare + UA budget
   4. **Last War: Survival** (FirstFun) — $2.6B+ lifetime, audience-overlap + UA-budget threat, not feature comp
   5. **Whiteout Survival** (Century Games) — 1.5M+ ratings, audience-overlap + UA threat, 4X-strategy not feature comp
   - **Demoted from v1 threat-list:** Cup Heroes (different audience), Lonely Survivor + Survive Squad (no ST data, smaller commercial footprint), NTE (audience marker only — not design comp)
7. **Three kill candidates with falsification tests** (v2.E): Skin→dialogue link (regulatory + authoring risk), Tier 3 spatial puzzle (BagMaster benchmark risk), Honkai-tier 5-tier portraits (production-pipeline mismatch). Each has a cheap test before kill — see v2.E for full reversal paths.

### Audience profile (single statement)

> **WC's target player = Western mid-core male, mid-20s to mid-30s, who currently plays Wittle Defender + Archero 2, watches anime on Crunchyroll, owns a PlayStation or Steam library for cross-platform identity, lives in Discord, plays Pokémon GO as a casual side-game, and may also have installed NTE / Genshin / Honkai for anime-action fix. The intersection of (Habby loyalist) ∩ (anime-curious gamer).**

Excludes: hypercasual graduates (Cup Heroes cohort), pure-strategy 4X players (Last War / Whiteout cohort), Genshin-only anime players, Western premium-Steam roguelite players (Vampire Survivors / Brotato cohort).

### Design-bet matrix (final)

| # | Bet | Status | Action |
|---|---|---|---|
| 1 | Weapon-gacha + locked heroes | ✅ Validated as 2-layer moat | Ship as designed; emphasise "story-locked" half in marketing |
| 2 | Dual-track slot-level + Hero Mastery | ✅ Uncontested | Ship as designed |
| 3 | 5 elements + 10 named pairwise compounds | ⚠️ Mechanic uncontested, **name collides** | **Rename "Resonance" → e.g. Catalyst/Alloy/Confluence** |
| 4 | Forge Wheel Tier 0–2 | ✅ Differentiating (Tier 1–2 most novel) | Ship Tier 0 as Archero-2-chest parity; invest in Tier 1–2 |
| 5 | Forge Wheel Tier 3 (spatial puzzle) | ❌ Most-occupied competitor space | **Kill OR reframe trigger to hero-narrative gate** (see v2.E.2) |
| 6 | Post-wave 3-card Forge Draft + 5-card boss | ✅ Saturated but proven; polish > novelty | Ship; juice the boss-card differentiation |
| 7 | 3-of-same auto-merge to rarer tier | ✅ Wittle 1:1, known idiom | Ship as designed |
| 8 | 10-quest personal mission chains × 7 heroes | ⚠️ Moat, but scope risk | **Ship 3 chains × 7 at launch (21 quests). Live-ops the rest.** |
| 9 | Honkai-tier 5-tier portrait evolution | ⚠️ Brand-expectation mismatch with nano-banana pipeline | **Test render Bran; if <70% Honkai-player approval, downgrade to 3-tier (Basic/Awakened/Apotheosis at 1/50/100)** |
| 10 | Skin → dialogue link | ⚠️ Unprecedented (could be moat OR regulatory risk) | **Falsify before commit:** Stage-1 SSR test purchase-intent bump from dialogue unlock vs VFX-only |

### Three moats (validated, ship as planned)

1. Hard-locked 7-hero story-progression roster
2. 10-quest chains + portrait evolution (production scope warning per #9)
3. Cross-element pairwise compound Codex with stage-first-clear F2P parity (rename pending)

### Three landmines (mitigate before launch)

1. **"Resonance" Habby-coded** — rename
2. **Tier 3 BagMaster benchmark** — kill or reframe (v2.E.2)
3. **Forge Wheel as progression-gate perception** (DQSG "abhorrent monetization" backlash warning) — communicate Forge Wheel as flavor not gate; whale-vs-F2P combat math gap stays <2×

---

## TL;DR — Five headline findings *(v1, superseded by §0 above; retained for audit trail)*

1. **Inversion bet (locked heroes + weapon gacha) is novel — but not unprecedented.** Archero (2019, $263M lifetime) + Archero 2 (Jan 2025, $32.8M first 30 days) ship a *close cousin*: shard-unlocked heroes + equipment gacha. WeaponCraft's hard-locked **story-progression** roster + 7-hero cap + 10-quest chains is the actual moat — the gacha-inversion alone is not.
2. **"Resonance" is now Habby-coded.** Archero 2 ships a "Resonance" mechanic. CapybaraGo ships an "Adventurer Resonance System." Wittle Defender ships "Chain Skills" (same DNA). **Rename WeaponCraft's compounds.** Candidates: Confluence, Catalyst, Alloy (matches forge theme), Reaction, Harmonic.
3. **Combat-shape seat is empty.** Side-view portrait + locked trio + auto-attack + per-hero tap-ult = nobody owns this. Yet Another Zombie Survivors has squad-of-3 but no tap-ult; Soul Knight has auto-aim + tap-skill but solo; Lonely Survivor has 3-card-draft + L1→L5+ult but solo. **Marketing problem, not concept problem.**
4. **Tier 3 spatial forge is most-occupied competitor space.** BagMaster Isekai (760k DL, 4.47★), Backpack Brawl (live), Backpack Battles (iOS Feb 2026) all ship Tier-3-shape *as the entire product*. WC offers it as Stage-20+ optional toggle — risk of being benchmarked as shallow imitation.
5. **Top two storefront threats both Habby:** Wittle Defender (3-card-draft TD, same shape, $10M first month) + Survivor.io ($500M+ hero-collector survivor playbook). WeaponCraft competes on Habby's turf against Habby's UA budget.

---

## WeaponCraft's 9 design bets vs. competitive evidence

| Bet | Verdict | Evidence |
|---|---|---|
| **Weapon-gacha + locked heroes** | Validated but contested | Archero (2019) + Archero 2 + DQSG (Square Enix, April 2026) all ship inverted-gacha variants. Novelty = the *hard-lock* + narrative chains, not the inversion |
| **Dual-track slot-level + Hero Mastery** | Uncontested | No competitor splits "stats inherit" from "per-hero bond" this way. Genuine moat |
| **5 elements + 10 named pairwise Resonance compounds** | Uncontested mechanic; contested name | God Breaker (Fire/Water/Lightning/Moon mix→ultimate) is closest, ARPG frame not TD. Cross-element pairs is real novelty. **Rename to escape Habby's term** |
| **Forge Wheel Tier 0→1→2→3 progression** | Tier 0 contested, Tier 1-2 differentiating, Tier 3 most-occupied | Tier 0 = Archero 2 chest UX (copy-friendly). Tier 1-2 = no clean analog. Tier 3 = BagMaster + Backpack Brawl + Backpack Battles iOS own this loop as entire products |
| **Post-wave 3-card Forge Draft + 5-card boss draft** | Saturated mechanic | Wittle, Dicero, DQSG Blessings, Brotato shop, Lonely Survivor (3-card + free reroll + L1→L5+ult), Cup Heros (14+boss wave + 3-card from Hero's Deck). Polish > novelty here |
| **3-of-same auto-merge to rarer tier** | Known idiom, rare in survivor | Wittle 1:1 source. Brotato has shop-auto-combine as closest survivor cousin |
| **Hero personal mission chains (10 quests × 7 heroes)** | **Genuine moat** | Zero competitors author this depth. Fantamon explicitly "no story." Wittle heroes are interchangeable art assets. **But:** Backpack Hero's Story Mode reviews flag long story chains as "grind chore" — ship 3 chains × 7 heroes at launch, live-ops the rest |
| **Honkai-tier portrait evolution (Mastery 1/25/50/75/100)** | **Genuine moat** | Nobody in the survivor/TD cluster does this. Honkai/Genshin do it on PC/gacha, not mobile survivor |
| **Skin → dialogue link** | **Genuine moat with regulatory risk** | Zero precedents in cluster. Closest = gacha-JRPG character bond stories (Genshin Hangouts) — not paywalled. Frame as "extra fan-service flavor" not "core story" to avoid App Store review pushback |

---

## Direct competitive cluster — top 5 threats ranked

1. **Wittle Defender (Habby, June 2025)** — Same arena shape, same wave structure, same 3-card-draft, same chain-skill-on-element-pair. **The single most direct compare.** WeaponCraft loses creative differentiation if first-60-seconds onboarding doesn't communicate the inversion.
2. **Survivor.io (Habby, $500M+ lifetime)** — Owns mobile-survivor mindshare + multi-hero F2P retention crown. WeaponCraft's inverted gacha sells *against* Survivor.io's playbook — weapons must feel as collectible as their heroes.
3. **Archero 2 (Habby, $32.8M first 30 days)** — Closest inversion precedent + already owns "Resonance" terminology + shard-hero + equipment-gacha shape.
4. **Lonely Survivor (Cobby Labs, 15M+ DL)** — Mature mobile hero-collector with 3-card-draft + free reroll + L1→L5+ult skill curve. Entrenched in Asia.
5. **BagMaster Isekai (SayGames, 760k DL, Feb 2026)** — Owns Tier-3 spatial-bag space on mobile. WC Tier-3 will be benchmarked against this.

**Honorable mentions:**
- **Dicero (Habby, April 2026 GL)** — Habby systematically chunking up roguelite-draft territory
- **Cup Heros** — 14+boss-wave + 3-card-Hero's-Deck draft = uncomfortably close structurally
- **Yet Another Zombie Survivors** — closest squad-of-3 control shape (PC/Steam)
- **Soul Knight Prequel** — closest mobile auto-aim+tap-skill control input
- **Merge War (5M+ DL)** — competing genre eating WC's exact customer with cheaper authoring
- **DQSG (Square Enix, April 2026)** — validates inverted-gacha with tentpole IP; monetization-backlash warning

---

## Three validated moats

| Moat | What it is | Why competitors can't trivially copy |
|---|---|---|
| **Story-progression-locked 7-hero roster** | Heroes unlock by chapter clear, never pulled, never shard-gated | Habby's monetization model demands hero-gacha; story-locked heroes oppose their core LTV vector. They'd have to fork the playbook |
| **Per-hero 10-quest chain + 5-tier portrait evolution** | Honkai-grade hero authoring on a Wittle-shape substrate | Authoring cost. Habby ships cute-art-no-story heroes at velocity; pivoting requires rebuilding the narrative pipeline |
| **Cross-element pairwise compound Codex** | 10 named compounds (Firestorm = Fire+Ice etc.), stage-first-clear weighted F2P parity | Wittle's Chain Skills are same-element duos. The cross-element math is a different design. Codex collection mechanic adds capture layer |

---

## Three landmines

| Landmine | Specific risk | Mitigation |
|---|---|---|
| **"Resonance" naming collision** | Archero 2 + CapybaraGo own the term. Players will assume cross-character skill swap | **Rename now.** Candidates: Confluence, Catalyst, Alloy, Reaction, Harmonic |
| **Tier 3 spatial-forge benchmarking** | BagMaster Isekai + Backpack Brawl + Backpack Battles iOS ship spatial-bag as entire product | Gate Tier 3 by **hero narrative milestone** not stage 20. Marries Tier 3 reveal to locked-hero/10-quest bet. Reframe as "Master Smith's deep forge" — narrative event, not difficulty cliff |
| **Forge Wheel as progression-gate perception** | DQSG (Square Enix April 2026) shipped weapons-gacha + got "abhorrent monetization" review backlash even with DQ brand | Communicate Forge Wheel as **flavor not progression-gate**. Stage clear must always be achievable on F2P weapon. Whale-vs-F2P combat-math gap stays <2× (already in §8 spec) |

---

## Top 3 Habby moves to watch

1. **Wittle Defender adds weapon-banner mode.** CapybaraGo's Hero Supply Crate is the infrastructure they'd reuse. ~12-18 month horizon. Probable. **Mitigation:** ship Tier 1 forge (body + rune) early; the differentiator becomes *craftable* weapon gacha, not just weapon gacha.
2. **Archero 2 expands Resonance into multi-character element compounds.** They already own the word + cross-character skill-swap. **Mitigation:** rename Resonance + ship 10 named compounds as discrete Recipe Codex collectibles they can't trivially mirror.
3. **Habby ships a hero-squad survivor with story chapters.** The one gap in their portfolio. Watch quarterly. **Mitigation:** 10-quest chains + portrait evolution must be visible in trailers/ad creative; Habby ad creative does not show character story — that's the marketing wedge.

---

## Recommended actions (priority-ranked)

1. **Rename "Resonance"** before any external asset ships. Audit Recipe Codex naming for other Habby-term collisions.
2. **Reframe Tier 3 trigger** from Stage 20+ → hero-narrative milestone (e.g., Master Smith Q10 quest completion). Differentiates from BagMaster's stage-difficulty framing.
3. **Reduce launch quest authoring scope** from 70 to 21 (3 × 7 heroes). Live-ops the rest based on which heroes retain. Screenshot promise survives; production budget halves.
4. **First-60-seconds onboarding** must teach the inversion. Test: "no pulling, only forging — the heroes are yours, the weapons are the world's." Stage-1 SSR explicitly probes "do you understand why heroes are locked?"
5. **Marketing wedge against Habby:** ad creatives lead with hero portrait evolution + 10-quest reveal beats. Habby's ad creatives don't show character story; show yours.
6. **Tier 0 chest UX = Archero 2 parity.** Don't fight habit-design here. Save innovation budget for Tier 1+.
7. **Stage-1 SSR bundle additions** based on this research:
   - Dual-anchor probe: "weapons exciting AND heroes special, do these reinforce or compete?" (already in §3 of design, confirmed critical)
   - Resonance-name comprehension probe: do players confuse with Archero 2's mechanic?
   - Tier-3 audience probe: who in cohort would opt-in?

---

## Cross-cutting design observations

### Run length sweet-spot validates 5min target

| Run length | Games | Notes |
|---|---|---|
| 3–7 min | Ninja Survivors (7), Lonely Survivor (~5), MineZ Survivor, **WeaponCraft (5min)** | Casual mobile snack |
| 6–12 min | Zombie Waves (6–12), Soul Knight Origin Mode | Sweet spot |
| 15 min | Survivor.io (commercial gold standard) | Established mobile-survivor |
| 20–30 min | Vampire Survivors, Brotato, Megabonk, Disfigure, YAZS | PC-survivor norm |
| 30–60+ min | Risk of Rain 2 | PC long-form roguelite |

WC's 5min sits at casual-mobile-snack end. W5/W10/W15 boss cadence is the right answer to "how do you make 5 min feel like a complete arc?" — Brotato's wave-20-boss and Soul Knight Origin's stage-3-of-12 bosses prove the cadence works.

### Element-compound design is uncontested

Only **God Breaker** has true element-mix → different-ultimate (ARPG frame). Wittle's Chain Skills are same-element duos, not cross-element. WC's 10 named cross-element compounds (Firestorm = Fire+Ice etc.) inhabit empty space.

### Auto-combat + tap-ult on squad is empty seat

Survivor cluster splits into 4 control buckets — pure auto-everything, twin-stick, auto-aim+tap-skill, pure idle. **Nobody combines squad-of-3 + per-hero-tap-ult.** Closest: YAZS (squad-of-3, no tap-ult), Soul Knight (tap-skill, solo). This is genuinely uncrowded.

### Merge battler is biggest LTV-per-dollar threat

Merge War: 5M+ DL with minimal narrative authoring. Eats WC's exact customer (squad placement + draft + ~5min runs) at fraction of production cost. WC defense = character investment + portrait evolution actually *feel* meaningful in-session, not just on meta screen.

### Backpack Hero deep-dive: PC-native, mobile-questionable

Original Backpack Hero (Jaspel, 2023) shipped PC + Switch — **no iOS/Android port as of May 2026**. Metacritic 76, Steam Very Positive (88/100, 7,726 reviews). Devoted small audience, not mass-market. Specific complaints: Story Mode grind, control fatigue, run repetition. BagMaster Isekai mobile-scales it via simplification + pig-skin + casual framing. **WC Tier 3 cannot match either depth (huge scope) or simplicity (built around it) — must position as narrative-gated flavor layer, not depth competitor.**

---

## Appendix A — Hero-Collector TD/Survivor research (Agent 1)

Coverage: Wittle Defender, Archero, Archero 2, CapybaraGo, Idle Hero TD, Galaxy Defense, Evo Defence, Cup Heros, Mech Arena, Last Stronghold, Kitty Keep, Coop TD, Gear Defenders, Survive Squad, Hero Survival IO, Dungero, Smashero.io, Autogun Heros, Merge War.

### A.1 Wittle Defender (Habby) — primary anchor

| | |
|---|---|
| Studio / platforms | Habby, iOS + Android, global launch June 9, 2025 |
| Revenue tier | **$10M+ first month**, 1.3M+ downloads in <1 month |
| Core loop | Auto-battle squad of up to 5 heroes defends fixed arena vs waves; 1-of-3 random skill cards between waves; idle resources upgrade roster |
| Gacha unit | **Heroes** (Common / Epic / Legendary / Mythic). 10-pull pity guaranteed Mythic; 500-pull threshold unlocks Xenoscape Summon with guaranteed Mythic |
| Roster shape | ~24 heroes at launch, growing toward ~100. All gacha. **No locked roster.** |
| Combat | Auto-attack, side/top-down arena, 5-unit fixed positions, ~4+ min runs, permadeath per run, multiple boss waves |
| Skill draft | **3-card draft between waves**, gold reroll. Literal pattern WC's Forge Draft is modeled on |
| Element/synergy | **Chain Skills** — same-element duo → named compound (Lightning Conductive, Ice Shard, Burning Ground). Elements: Fire, Ice, Lightning/Electric, Light, Dark, Physical, Wind. **Direct parallel to WC Resonance** but same-element not cross-element |
| Narrative | Flat. Heroes have visual identity, no story chains, no dialogue beyond flavor |
| Monetization gimmick | **Argent skins** — Mythic-tier cosmetics granting **account-wide stats that DO NOT need to be equipped**. The outfits-as-stats pattern WC avoids |
| Overlap with WC | **9/10** |
| Inversion analog? | **No** — canonical hero-gacha shape WC inverts against |

Sources: [Pocket Gamer biz $10M milestone](https://www.pocketgamer.biz/wittle-defender-hits-10m-in-player-spending/) · [PowerUpReady review](https://powerupready.substack.com/p/reviewing-wittle-defender-habbys) · [BlueStacks beginner guide](https://www.bluestacks.com/blog/game-guides/wittle-defender/wdd-beginners-guide-en.html)

### A.2 Archero (Habby, 2019)

| | |
|---|---|
| Revenue tier | Lifetime ~$263M / ~96M downloads. Currently ~$700K/mo (Oct 2025) |
| Core loop | Single hero, top-down twin-stick-ish, attacks only when stationary, 50-floor dungeons. 3 random ability cards per room |
| Gacha unit | **Equipment** (weapons, gear). S-tier weapons gacha-only. **Heroes via shards** from progression/events |
| Roster shape | **Hybrid — heroes earned via shards (NOT banner pull), weapons are gacha. Closest existing analog to WC inversion** |
| Element/synergy | Minimal — element tags, no compound named-buff layer |
| Overlap with WC | **6/10** |
| Inversion analog? | **YES — partial.** Heroes via shards (unlock by progression), weapons via gacha. Roster is *unlockable* not *locked*. Same family WC sits in. **Strongest moat-eroder finding: model is not unprecedented; how a $263M hit shipped in 2019.** WC twist on top: hard-locked progression-only roster, 7-hero cap, narrative depth — Archero never built any of that |

Sources: [Game World Observer](https://gameworldobserver.com/2025/01/20/archero-2-revenue-8-million-in-11-days-vs-original-game) · [Hero Shard wiki](https://archero.fandom.com/wiki/Hero_Shard) · [Deconstructor of Fun](https://www.deconstructoroffun.com/blog/2019/8/9/why-archero-banked-25m-but-leaves-25m-hanging-hlx9n)

### A.3 Archero 2 (Habby, Jan 2025 GL)

| | |
|---|---|
| Revenue tier | **$8M first 11 days post-GL (9× original), $32.8M first 30 days, $31M+ through SL+GL, 8M+ downloads** |
| Gacha unit | **Both** — equipment gacha (Chromatic/Mythstone chests) AND heroes (shard-based, 50 shards to unlock) |
| Roster shape | 8 characters at launch, shard-unlock |
| Element/synergy | **"Resonance"** — at character levels 3 and 6 you slot a borrowed skill from another unlocked character. **Naming and concept explicitly Resonance. Habby term now.** |
| Notable monetization | Multiple concurrent $15+/30-day passes (criticized), Mythstone "rate-up" gear gacha rotating every 3 days |
| Overlap with WC | **7/10** |
| Inversion analog? | **YES — explicit.** Equipment is spend target, heroes are shard-locked. **They already own "Resonance."** |

Sources: [PocketGamer.biz $32.8M](https://www.pocketgamer.biz/archero-2-makes-328m-in-first-30-days-from-player-spending/) · [Archero2.org guide](https://archero2.org/) · [Pocket Gamer Resonance](https://www.pocketgamer.com/archero-2/guide/)

### A.4 CapybaraGo! (Habby)

| | |
|---|---|
| Revenue tier | **$100M+ first ~3 months GL ($109M lifetime by Feb 2025), peaked $33.3M Dec 2024** |
| Core loop | **Text-based idle RPG** — randomized events, adventurer + brands, equipment pulls |
| Gacha unit | **Equipment** (Wishing / Hero's Supply Crate). Adventurers are skins on the player |
| Element/synergy | **"Adventurer Resonance System" (added 2025)** — exact name overlap with WC |
| Overlap with WC | **4/10** |
| Inversion analog? | **Partial.** Player is locked unit, Adventurers are skin-class progressions, equipment is pulled |

Sources: [PocketGamer.biz $100M](https://www.pocketgamer.biz/habbys-capybara-go-surpasses-100m-in-gross-player-spending/) · [Adventurer wiki](https://capybara-go.game-vault.net/wiki/Adventurers)

### A.5 Cup Heros

| | |
|---|---|
| Combat | **14 waves + boss wave** — almost the same wave count as WC's 15 |
| Skill draft | **3 upgrade options per wave from Hero's Deck** — direct parallel to Forge Draft |
| Notable mechanic | "Cup multiplier" gate mini-game between waves |
| Overlap with WC | **7/10** — surprisingly close on wave-count + card-draft. Multiplier-gate idea worth studying for in-between-wave juice |

Source: [Cup Heroes wiki](https://cup-heroes-mobile-game.fandom.com/wiki/Game_Overview)

### A.6 Brief cards (lower overlap)

- **Idle Hero TD** — 48 heroes lane-TD, idle. Overlap 5/10. [Steam page](https://store.steampowered.com/app/2897580/Idle_Hero_TD__Tower_Defense/)
- **Galaxy Defense: Fortress TD** — sci-fi base defense, chip/weapon gacha. Overlap 3/10. [BlueStacks guide](https://www.bluestacks.com/blog/game-guides/galaxy-defense-fortress-td/gdftd-beginners-guide-en.html)
- **Evo Defence** — 3-min matches, 4-unit loadout, merge-TD. Overlap 3/10. [BlueStacks guide](https://www.bluestacks.com/blog/game-guides/evo-defense-merge-td/evodm-beginners-guide-en.html)
- **Mech Arena (Plarium)** — PvP mech shooter, 1000+ skins. Overlap 2/10. [Plarium](https://plarium.com/en/game/mech-arena/)
- **Last Stronghold: Idle Survival** — zombie base-builder. Overlap 2/10. [App Store](https://apps.apple.com/us/app/last-stronghold-idle-survival/id6670743431)
- **Kitty Keep (Funovus)** — cute cat TD. Overlap 4/10. [Uptodown](https://kitty-keep.en.uptodown.com/android)
- **Coop TD: Together (SuperMagic)** — 2-player co-op TD with merge. Overlap 2/10. [Google Play](https://play.google.com/store/apps/details?id=com.percent.aos.cooptd)
- **Gear Defenders** — Power Core fortress, gear-summons-troops. Overlap 3/10 (gear-gacha partial inversion). [Beginner guide](https://club.jollymax.com/beginner-guide-gearpaw-defenders-game/)
- **Survive Squad (Stardust)** — survivor.io clone with multi-hero squad. Overlap 6/10. [MWM](https://mwm.ai/apps/survive-squad/6443779468)
- **Hero Survival IO** — single-hero survivor.io. Overlap 3/10. [Google Play](https://play.google.com/store/apps/details?id=com.game.hero.survival.war)
- **Dungero: Archero Action RPG (RETROBOT)** — single-hero Archero clone, shard heroes. Overlap 3/10 (partial inversion). [TalkAndroid](https://www.talkandroid.com/37407-dungero-archero-roguelike-rpg-guide/)
- **Smashero.io** — hack-n-slash + survivor hybrid, weapon-rich solo. Overlap 3/10 (partial inversion). [BlueStacks](https://www.bluestacks.com/blog/game-guides/smashero-io-hack-n-slash-rpg.html)
- **Autogun Heroes (Nitro Games)** — solo survivor IO, web↔mobile cross-play. Overlap 3/10. [PocketGamer.biz](https://www.pocketgamer.biz/nitro-games-autogun-heroes-launches-on-crazygames-web-portal/)
- **Merge War: Army Draft Battler (Wild Sky)** — 5×4 board merge battler, 5M+ DL. Overlap 3/10 mechanic; **threat tier on LTV-per-dev-dollar**. [Hardcore Droid review](https://www.hardcoredroid.com/merge-war-army-draft-battler-review/)

---

## Appendix B — Vampire-Survivors / roguelite cluster (Agent 2)

Coverage: Vampire Survivors, Megabonk, Brotato, Disfigure, Yet Another Zombie Survivors, Monster Survivors, Cell Survivor, Soul Knight (+Prequel), Ninja Survivors, Lonely Survivor, Zombie Waves, Box Head, Pegher.io, Zombastic, Idle Zombie Wave TD, Mech Assemble, God Breaker, Risk of Rain 2, Fantamon. Plus Survivor.io as bonus context.

### B.1 Vampire Survivors (poncle)

| | |
|---|---|
| Revenue | ~$57M lifetime Steam; 3M+ mobile installs early 2023; ~50k installs/$20k IAP per month on mobile (long-tail) |
| Control | **Single-stick / movement only — no aim, no skill button.** Everything auto |
| Run length | 30-min timed runs; reaper at 30:00 forces wipe |
| Draft | Pick 1 of 4 weapons/passives per level-up. 6+6 cap. Weapon+passive at max + 10:00 chest = Evolution |
| Meta | Gold buys refundable power-up tree. 80+ achievement-unlock characters. **No gacha** |
| Element/affix | No formal element system. Arcanas as run-modifiers |
| Overlap with WC | **6/10** |
| Auto+tap-ult analog? | **No** — pure auto, no skill button |
| What they'd beat us on | Brand authority + "5 dollars, 0 friction" install |

Sources: [Steam](https://store.steampowered.com/app/1794680/) · [Arcanas wiki](https://vampire.survivors.wiki/w/Arcanas) · [Evolution wiki](https://vampire.survivors.wiki/w/Evolution)

### B.2 Megabonk (vedinad, Sept 2025)

| | |
|---|---|
| Revenue | **1M+ copies in 2 weeks**, peaked 117k CCU. Indie breakout 2025 |
| Control | WASD + dash/jump (movement + 1-2 mobility verbs) |
| Notable | **3D camera with sliding/movement tech** — proves genre can break top-down |
| Overlap | **3/10** |

Sources: [Wikipedia](https://en.wikipedia.org/wiki/Megabonk) · [Steam](https://store.steampowered.com/app/3405340/Megabonk/)

### B.3 Brotato (Blobfish)

| | |
|---|---|
| Revenue | 2M+ Steam copies; healthy mobile |
| Run length | **~20-25 min per run, 20 waves, boss wave 20** — closest structural analog to WC's wave-gated shape |
| Draft | **Shop-based, not card-pull.** **6-weapon cap + same-tier auto-combine to higher tier when slots full** — closest analog to WC's 3-of-same auto-merge |
| Roster | 63 characters, each unique stats/start-weapons/passives |
| Monetization | $4.99 premium. No IAP, no ads |
| Overlap with WC | **7/10. Highest structural overlap in cluster** |

Sources: [Wikipedia](https://en.wikipedia.org/wiki/Brotato) · [Brotato Wiki shop](https://brotato.wiki.spellsandguns.com/Shop)

### B.4 Yet Another Zombie Survivors (Awesome Games Studio)

| | |
|---|---|
| Control | **Movement only — squad of 3 auto-aims and auto-fires.** Closest control-scheme analog to WC in cluster, EXCEPT no tap-ultimates |
| Roster | 8 playable squad characters — pick 3 for squad. **No gacha, no rarities** |
| Notable | **3-survivor squad picking is THE structural twin of WC's 3-hero squad** |
| Overlap with WC | **8/10. Highest in cluster on squad shape** |
| What they'd beat us on | First-mover on "3-survivor squad" combat shape |

Sources: [Steam](https://store.steampowered.com/app/2163330/Yet_Another_Zombie_Survivors/) · [Survivors wiki](https://yetanotherzombie.wiki.gg/wiki/Survivors)

### B.5 Soul Knight + Prequel (ChillyRoom)

| | |
|---|---|
| Revenue | Top-tier — Soul Knight flagship; Prequel launched late 2023. Combined hundreds of millions of DL |
| Control | **Twin-stick with auto-aim + dodge button + skill cast button — closer to "auto-aim + tap skills" than rest of cluster** |
| Run | Level Mode = 3 stages × 5 sub-levels = 15 sub-rooms. Origin Mode = 12 stages × 3 waves |
| Roster | **20+ playable heroes**, each unique passive + special skill. Class-blend hybridization in Prequel |
| Notable | **Auto-aim + dodge + skill button is closest control analog to WC's auto-attack + tap-ult on mobile.** Textbook "fair F2P with cosmetic + character unlocks" |
| Overlap with WC | **7/10. Highest mobile-control overlap** |
| What they'd beat us on | Hero roster + fair F2P reputation — owned slot 7+ years |

Sources: [App Store](https://apps.apple.com/us/app/soul-knight/id1184159988) · [Origin wiki](https://soul-knight.fandom.com/wiki/The_Origin)

### B.6 Lonely Survivor (Cobby Labs)

| | |
|---|---|
| Revenue | **15M+ downloads** |
| Draft | **3-card pick from EX-bar fills, free reroll. Skills max L5; L5 active enables ULTIMATE-form passive sublimation. Sophisticated draft** |
| Roster | Multiple unlockable heroes (Ruby starter, Lucifer top-tier), gacha-adjacent IAP |
| Notable | **L1→L5 skill leveling → ULTIMATE sublimation pattern** + **EX bar fills via crystal pickup not EXP** |
| Overlap with WC | **6/10** |

Sources: [Game Mechanics wiki](https://lonelysurvivor.fandom.com/wiki/Game_Mechanics) · [Tier list](https://xaogame.com/en/lonely-survivor-tier-list/)

### B.7 Idle Zombie Wave: Survival TD (Ryki)

| | |
|---|---|
| Control | **Pure idle / formation-place + watch** |
| Draft | Roguelike 200+ items/skills per run |
| Roster | **30+ unique survivors** with distinct weapons/abilities |
| Element/affix | **Adjutant pairing system — pairing a survivor with an Adjutant produces combined effects. Closest pairwise-compound analog to WC Resonance in entire cluster** |
| Overlap with WC | **7/10** |

Sources: [Google Play](https://play.google.com/store/apps/details?id=com.ryki.zombie.a)

### B.8 God Breaker: Roguelike ARPG (Growking, 2025)

| | |
|---|---|
| Control | **Drag-and-release one-handed combat ARPG** |
| Element/affix | **Fire / Water / Lightning / Moon — mix-and-match to create different ultimate abilities. Closest direct analog to WC's pairwise element-pair compounds in entire research set** |
| Monetization positioning | "No microtransaction spam" marketing copy |
| Overlap with WC | **6/10** |

Sources: [App Store](https://apps.apple.com/us/app/god-breaker-roguelike-arpg/id6746064502) · [Google Play](https://play.google.com/store/apps/details?id=com.growking.godslayer)

### B.9 Brief cards (lower overlap)

- **Disfigure (Cold Brew, free)** — twin-stick horror bullet-heaven, darkness/visibility hook. Overlap 4/10. [Steam](https://store.steampowered.com/app/2083160/Disfigure/)
- **Monster Survivors (Rivvy)** — generic VS clone, 10M+ DL. Overlap 4/10. [Site](https://www.monstersurvivors.com/)
- **Cell Survivor** — microscopic theme, 3-card draft + boss pattern. Overlap 4/10. [Google Play](https://play.google.com/store/apps/details?id=defense.roguelike.cell.shoot.survivor)
- **Ninja Survivors: Multi Survivor** — **7-minute runs** + multiplayer (co-op + 10-player PvP). Overlap 5/10. [TapTap](https://www.taptap.io/app/247183)
- **Zombie Waves (MACHINGA, 10M+ DL)** — one-handed joystick+auto-aim, 6-12 min. Overlap 5/10. [Google Play](https://play.google.com/store/apps/details?id=com.ddup.zombiewaves.zw)
- **Box Head: Zombies Must Die (Migoi)** — twin-stick + manual aim. Overlap 3/10. [Google Play](https://play.google.com/store/apps/details/Box_Head_Zombies_Must_Die?id=com.migoigames.boxheadzombiesmustdie)
- **MineZ Survivor** — pure auto-attack joystick-only. Overlap 5/10
- **Pegher.io: Zombie Survivor** — pachinko-as-damage. Overlap 2/10. [App Store](https://apps.apple.com/us/app/pegher-io-zombie-survivor/id6448869405)
- **Zombastic (Playmotional)** — supermarket-survivor + crafting layer. Overlap 4/10. [Pocket Gamer](https://www.pocketgamer.com/zombastic-time-to-survive/official-launch-android-ios/)
- **Mech Assemble: Zombie Swarm** — mech-customization, 100+ parts. Overlap 5/10. [Google Play](https://play.google.com/store/apps/details?id=com.and.monstergo.online)
- **Risk of Rain 2 (Gearbox)** — 4-player co-op 3D roguelite, item stacking. Overlap 3/10. [Wikipedia](https://en.wikipedia.org/wiki/Risk_of_Rain_2)
- **Fantamon: Idle RPG (SDG)** — 4-hero team + 100+ Fantamon partners, idle gacha. Overlap 6/10 (closest team-shape hero-collector). [GamingOnPhone](https://gamingonphone.com/role-playing/fantamon-idle-rpg-beginners-guide-and-tips/)
- **[thin data]** Go Survivor!, YOU vs Zombies — ambiguous naming, low data

### B.10 Bonus context — Survivor.io (Habby)

- **$500M+ lifetime IAP** by mid-2024, $5-6M/month recurring
- 15-minute run, 1 character per run with multiple unlockable heroes
- TikTok-fueled UA dominance
- **The 800-pound gorilla in mobile survivor space**

Sources: [Gamesforum](https://www.globalgamesforum.com/news/how-survivor.io-continues-to-pull-in-5-million-a-month-three-years-later) · [Mobilegamer.biz](https://mobilegamer.biz/two-months-in-survivor-io-passes-75m-from-37m-downloads/)

---

## Appendix C — Oddball mechanic cluster (Agent 3)

Coverage: Heroll, Dicero, DQSG, BagMaster Isekai, Merge War, Fantamon, 33 Immortals, God Breaker (cross-reference) + bonus Backpack Hero deep-dive.

### C.1 Heroll: Dice Roguelike (111%)

| | |
|---|---|
| Revenue | ~$200k/month, ~100k installs/month (Feb 2026 Sensor Tower est.) |
| Mechanic | Dice as both **movement** AND **build identity** — re-face values, add modifier dice, manipulate odds |
| Roster | Single character (knight). No collection |
| Monetization | F2P with ads + IAP. **No gacha banners** |
| Overlap with WC | **2/10** |
| Lesson | Single-character roguelikes can hit $200k/mo without gacha. Philosophical opposite of WC's locked-hero bet |

Sources: [App Store](https://apps.apple.com/us/app/heroll-dice-roguelike/id6737821799) · [MiniReview](https://minireview.io/role-playing/heroll-roguelike-rpg) · [Sensor Tower](https://app.sensortower.com/overview/com.percent.aos.rollinghero?country=US)

### C.2 Dicero (Habby, April 22, 2026 GL)

| | |
|---|---|
| Revenue | Soft-launch 100k+ installs, $65k IAP. Expected to scale Habby-tier $1M+/mo |
| Mechanic | **"Balatro on mobile"** — Yahtzee combinations as build draft |
| Overlap with WC | **3/10** |
| Lesson | **Habby has now shipped Wittle (WC's direct shape) + Dicero (dice draft variant) — systematically chunking up "casual roguelite + draft" design space.** Dice framing makes choice feel like luck rather than skill — UX lesson: visible randomness lowers commitment anxiety |

Sources: [Pocket Gamer](https://www.pocketgamer.com/dicero/coming-soon/) · [GamingOnPhone](https://gamingonphone.com/news/habbys-latest-casual-roguelite-dicero-soft-launches-on-mobile-in-select-regions-with-dice-based-combat/)

### C.3 Dragon Quest Smash/Grow (DQSG, Square Enix, April 2026)

| | |
|---|---|
| Studio | Square Enix. April 20-21, 2026. Tentpole IP |
| Core loop | Roguelite-RPG hybrid: smash hordes → signature "Coup de Grâce" → random Blessings → adapt → repeat |
| Mechanic | DQ vocation tree + roguelite Blessings + Coup de Grâce timing |
| Roster | Party assembled from classic DQ vocations. **Gear is gacha-pulled; vocation roster is structural** |
| Monetization | Heavy. Gacha equipment, three timed subscriptions (~$30 total). Game8 review: "abhorrent" |
| Overlap with WC | **6/10** |
| Inversion alignment | **Strong.** DQSG also gachas weapons/gear (not characters in roster sense). Post-wave Blessing draft = WC Forge Draft |
| Lesson | Big IP can ship "weapons are the gacha" + locked vocation roster — **validates WC's inverted bet.** But monetization backlash even with DQ brand is the warning: WC must avoid Forge Wheel pulls being *required* for progression rather than *optional flavor* |

Sources: [Square Enix press](https://press.na.square-enix.com/DRAGON-QUEST-SMASHGROW-THE-NEWEST-ADDITION-TO-THE-DRAGON-QUEST-S-37422) · [Game8 review](https://game8.co/articles/reviews/dragon-quest-smash-grow)

### C.4 BagMaster Isekai (Doors Studio + SayGames, Feb 2026) — KEY COMPARABLE

| | |
|---|---|
| Revenue | **760k downloads, 310k MAU, 4.47 stars**, top-20 strategy. SayGames' first Vietnam partnership |
| Mechanic | **Grid-based backpack with rotatable shaped items + adjacency synergies** — inventory IS the build, placement determines stat activation. Pig-themed casual skin |
| Roster | Single character (pig-hero) |
| Overlap with WC | **8/10 — highest in slice. Exactly the WC Tier-3 Forge Wheel mechanic shipped as the entire game** |
| Lesson | Spatial-inventory CAN ship on mobile and chart well. **But:** (a) it's the **whole game**, not a Stage-20+ optional toggle; (b) audience that wants this loop **already has BagMaster.** WC Tier-3 must justify why a player who enjoys spatial-bag would prefer doing it in WC's locked-squad framework instead of pure-bag in BagMaster. Risk: Tier-3 feels half-baked next to a game where it's the entire design intent |

Sources: [Pocket Gamer launch](https://www.pocketgamer.com/bagmaster-isekai/official-launch/) · [SayGames blog](https://blog.say.games/posts/saygames-announces-first-vietnam-partnership-with-doors-studio-to-launch-bagmaster-isekai)

### C.5 Merge War: Army Draft Battler (Wildsky/Funovus)

| | |
|---|---|
| Revenue | **5M+ downloads combined** |
| Mechanic | 8-token draft → place units on chess-grid → merge identicals to upgrade → battle auto-resolves → energy gates |
| Overlap with WC | **5/10** |
| Lesson | **Merge-battler audience is massive and overlaps WC's exact demographic — wants spatial decision-making + collection without authoring narrative.** Trade story depth for grid-puzzle satisfaction. **Competing genre for WC's customer:** someone who likes squad placement + draft choices may be playing Merge War instead |

Sources: [Hardcore Droid review](https://www.hardcoredroid.com/merge-war-army-draft-battler-review/)

### C.6 Fantamon: Idle RPG (Shengqu Games)

| | |
|---|---|
| Studio | Shengqu Games (Shengqu Technology Holdings HK). March 11, 2026 |
| Mechanic | Profession swap on heroes + Pokémon-style 100+ Fantamon collection. Idle |
| Narrative | **Very thin — explicitly "no real story"** |
| Overlap with WC | **3/10** |
| Lesson | "Mythos narrative depth" framing is aspirational not actual — Fantamon competes by *not* writing story. Validates mobile players reward idle convenience over narrative authoring. **Direct warning for WC:** 10-quest-per-hero authoring ambition is expensive for audience that may not register narrative as value-add over "we wrote zero quests, here are 100 monsters" |

Sources: [App Store](https://apps.apple.com/us/app/fantamon-idle-rpg/id6476379307)

### C.7 33 Immortals (Thunder Lotus)

| | |
|---|---|
| Platform | PC + Xbox Series, **NO MOBILE PORT.** Early Access March 18, 2025. 500k+ players |
| Mechanic | **33-player massively-multiplayer co-op roguelike.** Co-op weapon abilities require 2+ players on glowing tiles |
| Overlap with WC | **1/10** — genre-adjacent at most |
| Lesson | "Raid-shaped co-op" is desired but stays premium-PC-console, not mobile-F2P. Confirms WC's solo-squad focus correct on mobile |

Sources: [Wikipedia](https://en.wikipedia.org/wiki/33_Immortals)

### C.8 Backpack Hero deep-dive

**Honest answer: PC-native, mobile-questionable.**

Original Backpack Hero (Jaspel, 2023) shipped PC + Switch + consoles. **No iOS/Android port as of May 2026** despite community demand. Metacritic 76, OpenCritic 64% recommend, Steam Very Positive (88/100, 7,726+ reviews).

Complaints:
- **Story Mode grind** — Haversack Hill village rebuild = dozens of hours of grind
- **Control fatigue** — endless mouse-dragging tires hands
- **Run repetition** without successful runs feels punishing
- **Sound design weak**

**What this tells us about WC Tier-3:**
- Mechanic has devoted small audience (88/100 from people who got it) — not mass-market
- BagMaster Isekai (760k DL) proves mobile version CAN scale, but only when **simplified, pig-skinned, casualized, shipped as entire game's identity** — not Stage-20+ optional toggle
- **Tier-3 as gated-optional is BOTH right move AND risk.** Right: forcing all players through it loses casual squad-TD audience. Risk: spatial-bag audience will benchmark vs BagMaster/Backpack Battles/Backpack Brawl — three games that ship spatial-bag as *the* product
- **Recommendation:** don't gate Tier-3 behind Stage 20; instead unlock at story milestone tied to specific hero whose narrative justifies "deep forge work." Marries locked-hero / 10-quest bet to Tier-3 reveal

### C.9 Bonus discoveries (adjacent)

- **Backpack Battles (PlayWithFurcifer)** — Steam 1.0 June 2025; **iOS coming Feb 2026**. PvP async auto-battler. Tetrimino-shaped items, adjacency rules, hero-class layer. Overlap **7/10** with Tier-3. Items explicitly tetrimino-shaped (matches WC "shape-fit parts" language). [Pocket Gamer iOS](https://www.pocketgamer.com/backpack-battles/announcement/) · [Steam](https://store.steampowered.com/app/2427700/Backpack_Battles/)
- **Backpack Brawl (Rapidfire Games)** — Live iOS + Android. 1v1 PvP, **hero roster + spatial bag + auto-battle** — almost exactly WC Tier-3 + hero collector hybrid. Overlap **7/10**. [Google Play](https://play.google.com/store/apps/details?id=com.rapidfiregames.backpackbrawl)
- **Backpack Hero: Merge Weapon (iKame Games)** — Dec 31, 2025 Android. Brand-piggybacked merge variant. Overlap **4/10**
- **Die in the Dungeon** — Steam Feb 21, 2025. 93% positive. Dice + Slay-the-Spire-like positional grid. **No mobile port.** Demonstrates dice-roguelike PC demand is healthy. [Steam](https://store.steampowered.com/app/2026820/Die_in_the_Dungeon/)
- **Dicey Dungeons (Terry Cavanagh)** — Mobile July 2022. Benchmark for "dice + character mechanics" on mobile. Premium one-time-buy

---

---

# v2 Followup — Critique-Driven Revisions (2026-05-28b)

**Source critique:** game-design skill review of v1 findings, run same day. Three follow-up actions:
1. Stress-test interpretations in v1 against Sensor Tower live data (where claims about "Habby owns shelf," "Resonance collision," "top-5 threats" were qualitative)
2. Fill the 4-competitor gap flagged by critique (AFK Journey, Whiteout Survival, Top Heroes, Last War: Survival Game)
3. Add a "Bets to consider killing" section v1 omitted (v1 was confirmation-biased — only moat-validating recommendations)

## v2.A — Live data validation

**Sensor Tower live data pulled 2026-05-28.** API quota: org tier null, limit 0 (interpretation = unlimited free; 159 calls used in this session, no rate-limit hit). All revenue, ratings, audience-overlap, and category-rank numbers in v2.A are sourced from Sensor Tower direct query unless otherwise noted.

### Wittle Defender audience overlap (US, April 2026)

**De-anonymized via Sensor Tower unified_apps query 2026-05-28.** [Initial v2.A guess that rank 1 was Dicero proved wrong — see v2.H below for the correction and audience reinterpretation.]

| Rank | App | Multiplier | Share of Wittle users also using | Prev period diff | Type |
|---|---|---|---|---|---|
| 1 | **NTE: Neverness to Everness** (Hotta Games) | **216.6×** | 22.19% | new entry | Anime action-RPG (recent) |
| 2 | **Archero 2** (Habby) | **166.4×** | **23.20%** | -3.76 pp (was 26.96%) | Direct comp |
| 3 | Spark Driver (Walmart gig app) | 24.5× | 23.49% | new | Utility noise |
| 4 | Alarmy (alarm clock) | 12.8× | 22.40% | +2.55 pp | Utility noise |
| 5 | **Crunchyroll** | 8.2× | 30.96% | +4.04 pp | Anime audience signal |
| 6 | **PlayStation App** | 6.6× | 23.36% | new | Console gamer signal |
| 7 | **Pokémon GO** (Niantic) | 5.85× | 23.28% | +3.07 pp | Casual mobile gamer |
| 8 | **Steam Mobile** (Valve) | 4.98× | 22.01% | -4.20 pp | PC gamer crossover |
| 9 | Taco Bell (food delivery) | 4.7× | 31.25% | +4.14 pp | Demographic noise |
| 10 | Robinhood (trading) | 4.0× | 23.27% | new | Demographic noise |
| 12 | Google Gemini | 3.2× | 27.14% | -27.68 pp (was 54.82%) | Utility |
| (high share) | **Discord** | 1.99× | 54.26% | -0.06 pp | Gamer comm |
| (high share) | YouTube | 1.10× | 86.63% | -9.32 pp | Ubiquitous |

**Key findings (corrected per v2.H below):**
- **Top non-utility overlap is NTE: Neverness to Everness**, not a Habby title. NTE = Hotta Games (Tower of Fantasy studio) anime action-RPG. This breaks the v1 + v2.A first-pass assumption that "Habby owns the audience." **The actual #1 audience-share game is a non-Habby anime action-RPG.**
- **Archero 2 still highest among gaming overlaps with prior-period data** (23.2% share, down 3.76pp). Holds the "Habby ecosystem cross-promo" story but as #2, not #1.
- **Demographic signals from the long tail:** Crunchyroll 31%, PlayStation App 23%, Pokémon GO 23%, Steam 22%, Discord 54%. **The Wittle audience profile is "anime-watching gamer with PC/console identity + Discord."** This empirically validates design doc §1's targeting of "92% male midcore-TD-RPG cohort with Honkai-style anime aesthetic" — the audience IS that cohort.
- Utility apps (Spark Driver, Alarmy, Taco Bell, Robinhood, Gemini) clutter the multiplier ranking because their base usage is low; high multipliers don't mean competitive threat. Filter those out when reading the data.

### Storefront positioning — Top Grossing iOS RPG (US, 2026-05-27)

Wittle Defender iOS (`6502815032`) ranks **#79 in top-grossing iOS Role Playing (category 7017) in the US** on the query date. (Top 200 IDs retrieved; Wittle is mid-tier within the chart.)

```
ASSUMPTION REVISITED (v1 §3 "Top-5 threat ranking")
v1 claim:    Wittle is the #1 storefront threat.
Data check:  Wittle Defender is #79 in iOS RPG top-grossing. Top grossing
             RPG slot is dominated by Honkai/Genshin/MARVEL Snap-tier IDs
             (not yet de-anonymized).
RECONCILE:   Wittle is THE feature-shape threat but NOT a top-grossing
             threat. The risk profile is "they copy your mechanic and
             ship faster" + "they out-spend you on UA," not "they sit on
             top of the shelf."
ACTION:      Reframe Wittle as feature-cannibalization risk, not chart
             dominance risk. Survivor.io / Whiteout / Last War occupy the
             actual top-grossing seats.
```

### Whiteout Survival data check (filtering critique §4 about audience)

Sensor Tower direct query:
- **iOS US global rating count: 1,537,961** (highest in the v2 cluster)
- **Android US global rating count: 1,517,001**
- iOS launch Feb 2023; Android launch Feb 2023; CN ("无尽冬日") May 2024
- Publisher: Century Games (Shanghai-based)
- Category 7017 (RPG) + 7015 (Family Simulation) — **strategy-RPG hybrid, NOT survivor/TD**

```
ASSUMPTION CONFIRMED (v1 §4 "missing competitors blind spot")
v1 omission: Whiteout Survival not researched.
Data check:  1.5M US iOS ratings = top-tier mobile hit. Same publisher
             tier as Habby. BUT genre is 4X strategy with hero formation,
             not survivor/TD/auto-shooter.
RECONCILE:   Whiteout shares NO combat mechanic overlap with WC. They
             share AUDIENCE overlap with mid-core male strategy players.
             The threat dimension is audience, not feature.
ACTION:      Track as audience-budget threat (they spend hard on UA in
             same demographic), not as feature comp.
```

---

## v2.B — Rebuilt threat ranking with explicit dimensions

Each threat scored 0-10 on four independent dimensions, then aggregated:

| Threat | Feature overlap | Revenue scale | Audience overlap (Sensor Tower) | Marketing-UA budget | Composite |
|---|---|---|---|---|---|
| **Wittle Defender** (Habby) | 9 (3-card draft + same-arena shape) | 7 ($10M/mo first month, mid-tier sustained) | **9** (direct Habby ecosystem) | 9 (Habby UA muscle) | **8.5** |
| **Archero 2** (Habby) | 7 (equipment gacha + shard heroes + Resonance term) | 8 ($32.8M first 30 days) | **9 (23.2% direct overlap with Wittle audience)** | 9 | **8.25** |
| **Dicero** (Habby, April 2026 GL) | 5 (roguelite draft variant, dice not card) | 4 (soft-launch $65k IAP, scaling) | **9 (216× multiplier, 22.2% share — top overlap)** | 8 (Habby ramping) | **6.5** |
| **Survivor.io** (Habby) | 4 (solo twin-stick, 15min) | 10 ($500M+ lifetime, $5-6M/mo recurring) | 7 (Habby ecosystem, lower direct overlap) | 10 | **7.75** |
| **Lonely Survivor** (Cobby Labs) | 6 (3-card draft, L1→L5+ult) | 5 (15M+ DL, mid-tier IAP) | 5 (Asia-centric, weaker US overlap) | 6 | **5.5** |
| **AFK Journey** (Lilith) | 4 (hero-gacha RPG, tactical not survivor) | 8 ($185M lifetime, $128M IAP, 12M+ DL) | 7 (audience overlap on hero-collector) | 8 (Lilith global launch) | **6.75** |
| **Whiteout Survival** (Century) | 2 (4X strategy, not combat-shape) | 10 (1.5M US iOS ratings, top-grossing) | 6 (audience overlap on mid-core male strategy) | 10 | **7.0** |
| **Last War: Survival** (FirstFun) | 3 (4X strategy with merge minigame onboarding) | 10 ($2.6B+ lifetime, 160M DL, $180M Sep 2025) | 6 (audience overlap on TikTok-era mid-core) | 10 | **7.25** |
| **Top Heroes: Kingdom Saga** (RiverGame) | 4 (hero collection + thumb-swipe auto-combat) | 5 (199k US ratings) | 5 | 6 | **5.0** |
| **BagMaster Isekai** (SayGames) | 8 (Tier-3 spatial-bag) | 6 (760k DL, 4.47★) | 5 | 7 | **6.5** |

### Top-5 v2 ranking (composite-ranked):

1. **Wittle Defender** (8.5) — feature + audience + UA dominance
2. **Archero 2** (8.25) — Resonance name + inversion precedent + 23.2% direct audience overlap
3. **Survivor.io** (7.75) — revenue ceiling + UA dominance, lower feature overlap
4. **Last War: Survival** (7.25) — revenue scale ($2.6B) + audience overlap, low feature overlap
5. **Whiteout Survival** (7.0) — revenue + UA, almost no feature overlap

### What changed from v1's ranking:
- **Last War: Survival** entered top-5 (was omitted in v1)
- **Whiteout Survival** entered top-5 (was omitted in v1)
- **Lonely Survivor** dropped from #4 to #6 (US audience overlap weaker than v1 assumed; entrenchment is Asia-region, not global)
- **BagMaster Isekai** dropped from #5 honorable mention to #8 (Tier-3 threat is real but Tier 3 is deferred; lower priority)
- **Wittle held #1** but the reason shifted: it's now ranked #1 because of audience overlap (empirically measured), not just feature similarity

---

## v2.C — New competitor cards (4 missing from v1)

### V2.C.1 AFK Journey (Lilith Games / Farlight)

- **Studio + platforms:** Lilith Games (developer) + Farlight Games (publisher). iOS + Android + Windows. Launched March 27, 2024.
- **Revenue tier:** **$185M lifetime IAP**, $128M of that IAP, 12M+ downloads. Top markets US 25% / China 19% / Korea 15%. [Source: [MAF blog AFK Journey analysis](https://maf.ad/en/blog/afk-journey-analysis/), [Naavik](https://naavik.co/digest/lessons-learned-from-afk-journey/)]
- **Core loop:** Sequel to AFK Arena. Idle tactical RPG. Auto-resolved tactical battles + hero collection + idle-progress + seasonal content.
- **Gacha unit:** **Heroes** (Common / Rare / Epic / Legendary, A-level vs S-level via dupes/ascension). Currency: Invite Letters. Classic pity-system gacha.
- **Roster shape:** Open gacha-pulled roster, ~50+ heroes growing seasonally.
- **Combat shape:** Auto-tactical (5-7 unit positioning on grid). Not a survivor/TD.
- **Skill draft:** No in-run draft. Pre-battle composition + during-battle hero ultimate timing.
- **Element/synergy:** Faction system (Lightbearer/Mauler/Wilder/Graveborn/Celestial/Hypogean) with rock-paper-scissors-plus relationships. No cross-element compound named buffs.
- **Narrative depth:** Real story chapters, voiced cutscenes, hero personal stories, season narratives. **High for the genre.**
- **Monetization gimmick:** Battle pass + multiple concurrent passes + cosmetics + Stargazer (Mythic-tier gacha).
- **Overlap with WC: 4/10.** Genre adjacency (hero collection + auto combat) but tactical-grid, not arena-survivor. Different combat shape. **Important: design doc §1 names AFK Journey as target-audience anchor — but it's a different combat surface.**
- **Inversion analog?** No — heroes are gacha, equipment via shards/events. Standard hero-collector model.
- **Threat type:** **Audience** (Lilith pulls the same Western+SEA midcore male cohort) + **narrative-depth competitor** (Lilith ships character stories at high polish — direct comp on WC's moat #2). Not a feature comp.

### V2.C.2 Whiteout Survival (Century Games)

- **Studio + platforms:** Century Games (Shanghai). iOS + Android. Launched Feb 9, 2023.
- **Revenue tier:** Sensor Tower direct query 2026-05-28: **1,537,961 US iOS global ratings; 1,517,001 Android US ratings.** Top-grossing tier (rating count alone places it in tier-1 mobile hits). [Source: Sensor Tower app_id `638ee532480da915a62f0b34`]
- **Core loop:** Post-apocalyptic ice-age survival 4X. Build city → recruit heroes → form rallies → alliance warfare. Long-session 4X strategy.
- **Gacha unit:** **Heroes** (Infantry/Lancer/Marksman classes, RPS counter-system). Gen 3 heroes (e.g., Logan) are current arena meta.
- **Roster shape:** Hero collection + "all heroes share the same level" (bypasses re-grind on hero swap — directly parallel to WC's slot-level inheritance design).
- **Combat shape:** Auto-resolved alliance warfare + rally combat. Not arena, not real-time action.
- **Skill draft:** No in-run draft. Expert pairing system + hero formations as pre-battle decisions.
- **Element/synergy:** RPS class triangle (Infantry > Lancer > Marksman > Infantry). Experts (separate progression layer) pair with heroes for synergy effects.
- **Narrative depth:** Light — atmospheric ice-age framing; no per-hero story chains.
- **Monetization gimmick:** State-based competition + alliance dynamics + Big Bear/SvS events.
- **Overlap with WC: 2/10** on combat shape. **6/10 on audience.** Same Western mid-core male strategy demographic, totally different combat surface.
- **Inversion analog?** No — heroes are pulled, equipment shared/auto-leveled. But: "all heroes share the same level" mechanic is the exact pattern WC's dual-track design borrows. **Worth re-reading their implementation as design reference.**
- **Threat type:** **Audience** (same mid-core male demographic) + **UA budget** (Century Games outspends almost everyone in the category). Not a feature comp.
- [Sources: [Century Games](https://www.centurygames.com/games/whiteout-survival/), [Arena Guide 2025](https://meetsinglesusa.com/blog/whiteout-survival-wosarena-hero-strategy-guide-2025/), [LDPlayer Expert Guide](https://www.ldplayer.net/blog/whiteout-survival-experts-guide.html)]

### V2.C.3 Top Heroes: Kingdom Saga (RiverGame)

- **Studio + platforms:** River Game HK Limited / RiverGame. iOS + Android + Steam. Launched Feb 17, 2024.
- **Revenue tier:** 199k US Android ratings + 120k US iOS ratings. Mid-tier (below the $100M+ club, above niche). Steam version 53% positive (94 reviews). [Source: Sensor Tower app_id `63bd1e79e36abf4ca724dad2`]
- **Core loop:** Hero collection RPG + real-time tactical battles + 4X kingdom-builder + PVP.
- **Gacha unit:** **Heroes** (recruit vouchers from events).
- **Combat shape:** **Thumb-swipe one-handed directional movement; heroes auto-attack in swipe direction.** Hybrid action-RPG-with-troop-deployment.
- **Skill draft:** No card-draft; talent-tree progression between battles.
- **Element/synergy:** Hero class system, position-based synergies.
- **Narrative depth:** Light — adventure-mode framing + fog-of-war exploration. Mixed reviews on pay-to-win.
- **Monetization gimmick:** Voucher gacha + battle pass + pay-to-progress complaints in reviews.
- **Overlap with WC: 4/10.** Hero collection + auto-attack overlap; thumb-swipe vs fixed-position combat diverges; 4X-kingdom layer not in WC.
- **Inversion analog?** No — heroes are pulled.
- **Threat type:** **Audience** (same Western mid-core male cohort, but smaller scale than Wittle/Last War). Lower-priority threat.
- [Sources: [reviewsbysupersven](https://reviewsbysupersven.com/top-heroes-review/), [Hardcore Droid](https://www.hardcoredroid.com/top-heroes-game-review/)]

### V2.C.4 Last War: Survival Game (FirstFun / FUNFLY)

- **Studio + platforms:** FUNFLY PTE LTD (FirstFun). iOS + Android. Launched Dec 1, 2023.
- **Revenue tier:** **$2.6 billion+ lifetime revenue, 160M+ downloads, $212M in January 2025 alone, top-grossing mobile game Sep 2025 ($180M/month) and Nov 2025 ($110M/month).** Sensor Tower direct query 2026-05-28: **2,013,009 Android US ratings + 1,455,417 iOS US ratings.** [Sources: [PocketGamer.biz $2bn milestone](https://www.pocketgamer.biz/last-war-survival-surpasses-2bn-after-record-player-spending-in-early-2025/), [TechNode Sep 2025 #1](https://technode.com/2025/10/30/funflys-last-war-tops-global-mobile-game-revenue-chart-in-september-with-180-million-in-earnings/), [Wikipedia](https://en.wikipedia.org/wiki/Last_War:_Survival_Game)]
- **Core loop:** **Bait-and-switch:** ad-style minigames first 3 minutes (merge / run / dodge) → seamless transition to deep 4X strategy. Base-build + alliance warfare + heroes + timed events + PVP.
- **Gacha unit:** **Heroes** (gacha-pulled, multiple tiers). Equipment via crafting + gacha.
- **Roster shape:** Open hero collection growing seasonally.
- **Combat shape:** Mixed — onboarding minigames, then auto-resolved alliance warfare.
- **Element/synergy:** Hero class triangle + equipment loadout.
- **Narrative depth:** Light post-apoc framing; no per-hero story arcs.
- **Monetization gimmick:** **The minigame-onboarding pattern is the single most-copied mobile UA mechanic of 2024-25.** Players install for the minigame ad they saw, get pulled into 4X depth. ~6% IAP conversion rate (vs. industry 2% average).
- **Overlap with WC: 3/10** combat-shape. **8/10 audience-budget threat** (any UA campaign WC runs competes with FirstFun's $180M/month spend).
- **Inversion analog?** No — heroes are pulled.
- **Threat type:** **Audience + UA budget** = highest non-Habby threat. Possibly higher than Habby in absolute UA-dollar terms.
- [Sources: [Last War Survival Case Study (ThinkingData)](https://thinkingdata.io/customer-stories/last-war-survival-case-study/), [MAF analysis](https://maf.ad/en/blog/last-war-survival/)]

### Audience filtering check (per v1 critique §4)

Of the 4 new competitors:
- **AFK Journey** — fits "Western + SEA midcore male" target. Direct audience comp.
- **Whiteout Survival** — strategy crowd, mid-core male leans into early-30s+. Some demographic skew toward older players + mixed gender, but US/Western strategy gamer audience does overlap. Threat dimension = audience + UA budget, not feature.
- **Top Heroes** — fits target. Smaller scale.
- **Last War: Survival** — fits target. Massive UA budget makes it the #1 non-Habby UA threat.

All 4 are legitimate competitors when filtered through the target audience. None of them should be dropped from the v2 tracking set.

---

## v2.D — Inversion claim reframe (per critique §3 Challenge 1)

### Old framing (v1)
> "Inversion bet (locked heroes + weapon gacha) is novel — but not unprecedented. Archero (2019, $263M) + Archero 2 (Jan 2025) ship a close cousin: shard-unlocked heroes + equipment gacha."

### Reframed (v2)
**Inversion bet has two distinct layers; only one is precedented.**

| Layer | Precedent? | Source |
|---|---|---|
| **Equipment-is-gacha + heroes-not-banner** | YES — Archero (2019, $263M lifetime), Archero 2 ($32.8M/30d), CapybaraGo (Habby's Hero Supply Crate), DQSG (Square Enix April 2026, weapons-gacha + locked vocation roster) | Validated |
| **Heroes unlock by deterministic story progression** (no shards, no banner, no grind-currency) | **NO precedent in F2P mobile RPG cluster (50-game research set)** | Genuinely unprecedented |

**The actual moat is the second layer.** The first layer is shipped, validated, monetizable — but also copyable. Habby could season-patch Wittle with a "Forge Banner" in 6 months (CapybaraGo infrastructure already does equipment-gacha). What Habby will NOT do without forking their playbook is hard-lock heroes to story progression — because their LTV model requires hero-banner sales.

```
HONEST FRAMING:
"WeaponCraft is structurally adjacent to Archero (a proven $263M model)
on the equipment-gacha axis. WeaponCraft is genuinely uncharted territory
on the story-locked roster axis — no F2P mobile RPG has shipped this
combination. The combination is the moat; either half alone is not."
```

This is the framing that should propagate to SSR pitch, marketing wedge, and Phase-1 exit-gate language.

---

## v2.E — Bets to consider killing (3 specific kills, with rationale + reversal path)

v1 critique flagged that the synthesis had zero "consider abandoning" recommendations. Here are three.

### KILL CANDIDATE 1 — Skin → dialogue link (Design Spec §14)

**Why this came up for kill:**
- Genuinely unprecedented in the cluster (could be moat OR could be untested risk)
- Carries App Store / ESRB regulatory exposure (paywalled story content)
- Authoring debt: 7 heroes × ~10 skins × ~15 lines = 1,050 LLM-generated lines minimum
- Quality bar requires human-review pipeline ($5-8k/mo per critique FM-13)
- Value proposition assumes player pays for cosmetic AND values the dialogue unlock — two assumptions stacked

**Falsification test (cheap, before kill):**
- Stage-1 SSR addition: show players a Bran skin purchase mockup with "+12 new dialogue lines unlocked" vs same mockup with just "+VFX variant." Measure: which generates higher purchase-intent score? If dialogue-unlock <10% bump over VFX-only, the feature isn't pulling its monetization weight; kill.

**Reversal path if kept:**
- Don't gate dialogue behind skin purchase. Tie dialogue unlocks to Hero Mastery milestones (per design §6 already plans 25/50/75/100 milestones). Skins remain pure cosmetics.
- Saves the authoring scope (~$50k+ ongoing narrative QA budget per FM-13) while keeping the dialogue feature.

```
PROPOSED ACTION: Move skin-dialogue from "v1.0 feature" to "v1.x experimental." 
Ship v1.0 with Mastery-milestone-gated dialogue only. 
Re-evaluate skin-dialogue link after 6 months of live-ops data.
```

### KILL CANDIDATE 2 — Tier 3 spatial puzzle Forge Wheel (Design Spec §9)

**Why this came up for kill:**
- BagMaster Isekai (760k DL, 4.47★), Backpack Brawl (live), Backpack Battles iOS (Feb 2026) all ship this loop *as the entire product*
- Tier 3 is gated to Stage 20+ AND opt-in — it serves a niche within a niche
- Asset cost is real (mockups F1-F4 already exist; full implementation is multiple sprints)
- WC players who reach Stage 20 with high engagement will defect to BagMaster for spatial-bag specifically if Tier 3 feels half-baked
- Backpack Hero PC reviews show even devoted players critique the spatial loop as repetitive after extended play

**Falsification test (cheap, before kill):**
- Stage-1 SSR: ask "if you reach Stage 20, would you opt into 'Advanced Forge'?" After describing the mechanic with screenshots. If opt-in intent <30%, kill.
- Audit `docs/research/weaponcraft-forge-mockups/` (F1-F4): would the team be proud to ship those at v1.x quality? If the answer is "they need significant additional work," that's a vote against shipping.

**Reversal path if killed:**
- Replace Tier 3 with **"Master Smith Tier 2.5"** — deeper stat-fit forge with 5-6 part categories (head + hilt + body + rune + grip + counterweight) instead of spatial puzzle. Adds depth without spatial-bag genre exposure.
- Saves: ~3-5 sprints engineering cost, design lead-time, and the BagMaster benchmarking risk.

```
PROPOSED ACTION: Kill Tier 3 spatial puzzle outright. Replace with Master Smith Tier 2.5 
stat-fit deepening. Re-allocate the sprint budget to Tier 2 polish + Tier 1 onboarding 
UX (more impact-per-sprint).
```

### KILL CANDIDATE 3 — Honkai-tier 5-tier portrait evolution (Design Spec §6)

**Why this came up for kill:**
- "Honkai-tier" sets brand expectation Honkai's animation pipeline ($100M+ animation team) created
- WeaponCraft's art pipeline: nano-banana cheap-tier at ~$0.12/illustration per global cost policy
- 5 tiers × 7 heroes = 35 portrait variants at launch. With Mastery 100 cosmetic crown, 35 portraits + 7 crowns = 42 illustrations
- v1.x roster expansion: 1 hero every 6-8 weeks (per design §FM-9 mitigation). Each new hero = 5 tier portraits = 5 illustrations. Over Year 1 (4 new heroes), +20 illustrations
- The "Honkai-tier" framing is the marketing wedge against Habby (per design's moat claim) BUT the production pipeline cannot meet Honkai's animation standard
- Risk: trailers/screenshots show 5-tier portrait progression, players compare to Honkai trailers, read as "knockoff"

**Falsification test (cheap, before kill):**
- Have nano-banana cheap-tier render 5 tiers for Bran. Show 20 Honkai players. Ask: "Does this evolve the character for you?" If <14/20 positive, kill 5-tier and downgrade to 3-tier.

**Reversal path if killed:**
- Reduce to **3-tier portrait evolution** at Mastery 1/50/100 instead of 5 at 1/25/50/75/100. Three tiers: Basic, Awakened, Apotheosis.
- Saves: 14 portraits at launch (2 × 7 heroes), 8 per Year 1 new hero. Production cost ~50% reduction.
- Lowers brand-expectation risk: 3 tiers reads as "polish" not "Honkai-tier promise."

```
PROPOSED ACTION: Run Bran 5-tier nano-banana test render. If <70% Honkai-player 
approval, downgrade to 3-tier (Basic/Awakened/Apotheosis at Mastery 1/50/100). 
Re-budget the saved portraits as polish on the surviving 3 tiers.
```

### Bets explicitly NOT recommended for kill

| Bet | Why kept |
|---|---|
| Hard-locked 7-hero roster | Core moat. v1 + v2 evidence confirms zero F2P mobile precedent. Kill would gut the design |
| Forge Wheel Tier 0-2 | The actual product. Kill removes the meta loop |
| Cross-element 10 Resonance compounds | Mechanic uncontested (only God Breaker approximate). Rename per v1, keep mechanic |
| Forge Draft 3-card + 5-card boss | Saturated but proven mechanic; execution polish matters more than novelty |
| Per-hero 10-quest chain | Genuine moat; scope down to 3 chains × 7 heroes at launch (per v1 §6) but don't kill |

---

## v2.F — Numbers Policy audit (per critique §3 Challenge 8)

| Claim from v1 or design spec | Source status | Resolution |
|---|---|---|
| "Wittle Defender $10M first month" | Sourced (PocketGamer biz) | Keep |
| "Archero 2 $32.8M first 30 days" | Sourced (PocketGamer biz) | Keep |
| "Survivor.io $500M+ lifetime" | Sourced (Mobilegamer.biz, Gamesforum) | Keep |
| "12-18 month horizon for Habby copy" | Unsourced speculation | **Reframe as: "6-18 months, watch Wittle patch cadence quarterly"** |
| "Whale-vs-F2P combat math gap stays <2×" | Design spec §8 assertion | Tag as "Starting value: 2× cap. Test: post-launch player surveys on perceived-pay-to-win." |
| "Top-5 threats" | v1: qualitative | **v2 (above): scored on 4 explicit dimensions** |
| "8/10 overlap" BagMaster | Subjective rubric | Tag as agent's qualitative score, not measured |
| "+25% Recipe Codex F2P parity" | Design spec | Tag as starting value; validate post-launch with cohort Codex-completion data |
| "23.2% Wittle ↔ Archero 2 audience overlap" (v2) | **Sourced — Sensor Tower 2026-05-28 direct query** | Live data, keep with citation |
| "AFK Journey $185M lifetime" (v2) | Sourced (MAF, Naavik) | Keep |
| "Last War $2.6B+ lifetime" (v2) | Sourced (PocketGamer biz, AppMagic) | Keep |
| "5min run length validated by mobile median" (v1) | **Critique called this out: sample-of-3** | **Reframe as: "5min sits at casual-mobile snack end of distribution; commercial gold standard is Survivor.io's 15min ($500M+). Per-session monetization data needed before validating."** |

---

## v2.H — Mystery app de-anonymization (correction to v2.A)

Sensor Tower `unified_apps` call resolved 12 unified app IDs from the Wittle Defender overlap top-12 + high-share tail (call 161, ~12 IDs in 1 batch). Findings:

### Correction: Rank 1 is NTE, not Dicero

The v2.A first-pass hypothesis that rank-1 mystery app `6986f9dbb94693e318f26ec6` was Dicero (Habby's April 2026 dice roguelite) was **wrong.**

Actual rank 1: **NTE: Neverness to Everness** by Hotta Games (the Tower of Fantasy studio).

Why the wrong guess: I anchored on "high multiplier + new entry + April 2026" and pattern-matched to the Habby cross-promo story I was already telling. The data disagreed.

Dicero search via `search_entities` returned **zero results** — Dicero is either not yet indexed by Sensor Tower (April 2026 GL very recent + soft-launch in select regions only), or indexed under a different name in their catalog.

### What NTE in the top slot means

NTE is an open-world anime action-RPG (Tower of Fantasy successor) with character gacha. **Not a TD or survivor game at all.** A 216× multiplier with 22.2% Wittle-user share means Wittle players are dramatically over-indexed on NTE installs vs the average mobile gamer.

```
ASSUMPTION CORRECTED (v1 + v2.A first pass)
v1 + v2.A:  Wittle audience is locked into Habby ecosystem (Wittle + 
            Archero 2 + likely Dicero etc).
Data check: Top non-utility overlap is NTE (Hotta) — NOT Habby. Habby's 
            Archero 2 is #2 among games. 
RECONCILE:  Wittle's audience is the broader "Western mid-core male 
            anime-curious action-RPG player" cohort, NOT specifically a 
            Habby-ecosystem-locked audience. Habby just happens to ship 
            multiple games in this cohort's interest set.
ACTION:     Add anime action-RPG titles (NTE, Tower of Fantasy, Genshin 
            Impact, Honkai Star Rail, Wuthering Waves, Zenless Zone Zero) 
            to the v3 competitor tracking. They share AUDIENCE not 
            FEATURES — but they win the cohort's emotional attention.
```

### Long-tail demographic signals (filter out utility apps)

Filtering out utility/noise apps (Spark Driver, Alarmy, Taco Bell, Robinhood, Gemini), the remaining gaming/lifestyle overlaps build a clear demographic profile:

| Signal | App | Share | What it tells us |
|---|---|---|---|
| Anime media consumption | Crunchyroll | 31.0% | Audience watches anime |
| Anime action-RPG interest | NTE | 22.2% | Audience seeks anime gacha gaming |
| Console gaming | PlayStation App | 23.4% | Cross-platform identity |
| PC gaming | Steam Mobile | 22.0% | Cross-platform identity |
| Casual mobile gaming | Pokémon GO | 23.3% | Multi-game mobile player |
| Gamer community | Discord | 54.3% | Engaged community participant |

**Profile synthesis:** The WeaponCraft target audience is the **"cross-platform anime-curious gamer who is in Discord, watches Crunchyroll, owns a console or PC, and plays Pokémon GO + a Habby game + an anime action-RPG."** This is a more specific and more actionable profile than v1's "Western SEA midcore TD-RPG cohort."

### Marketing implications

1. **Discord placement is critical.** 54% of Wittle's audience is on Discord. WeaponCraft pre-launch + post-launch Discord strategy should be first-class, not afterthought.
2. **Anime aesthetic in trailers is validated by data.** Crunchyroll + NTE overlaps confirm the design's Honkai-style direction connects with the audience. Per v1 + v2.E kill candidate #3, the production pipeline can't match Honkai exactly — but the *aesthetic target* is correctly identified.
3. **Add anime-action-RPG titles to v3 tracking:** Genshin Impact, Honkai Star Rail, Wuthering Waves, Zenless Zone Zero, NTE, Tower of Fantasy. They are audience competitors even though combat shapes differ.
4. **Habby is *one of several* anchors in this audience.** v1's "Habby owns the shelf" overstates it. Reframe: Habby + Hotta + miHoYo (Honkai/Genshin) + Kuro (Wuthering Waves) all serve this audience.

---

## v2.I — Nearest-comp overlap analysis (correction to v2.A scope)

**User pushback flagged:** v2.A only ran app_overlap on Wittle Defender. NTE: Neverness to Everness scored as rank 1 but NTE is an open-world anime action-RPG — **not a design comp for WC's side-view 3-hero TD-survivor.** v2.A risked drawing design conclusions from an audience-only signal.

Followup: ran app_overlap on **the actual nearest-feature comps** (US, April 2026). Results below.

### Coverage gaps

| Game | Overlap data available? | Notes |
|---|---|---|
| Wittle Defender | Yes (v2.A) | Anime-cohort overlap, NTE #1 |
| Archero 2 | Yes (call 142, saved truncated) | Habby-ecosystem dominant |
| Cup Heroes | Yes (call 165, saved truncated) | Hypercasual/indie cohort |
| **Lonely Survivor** | **Empty data** | ST panel doesn't track |
| **Survive Squad** | **Empty data** | ST panel doesn't track |

Empty data for Lonely Survivor + Survive Squad is itself a finding: **ST's app_overlap data appears gated by audience size or panel coverage.** Smaller mid-tier mobile games (15M DL Lonely; ~45k Survive Squad ratings) fall below the threshold. Top-tier games (Wittle, Archero 2, Cup Heroes all 100k+ ratings) make the cut.

### Archero 2 audience overlap top-10 (de-anonymized, US April 2026)

| Rank | App | Multiplier | Share | Studio | Type |
|---|---|---|---|---|---|
| 1 | **SSSnaker** | 314.7× | 0.88% | **Habby** | Snake/.io |
| 2 | **Wittle Defender** | 166.4× | 1.73% | **Habby** | Direct comp |
| 3 | Animal Warfare | 132.9× | 1.44% | PlaySide | Tower-defense |
| 4 | Kitten Run: Anime | 125.6× | 0.99% | iree | Anime runner |
| 5 | MagicCall (voice changer) | 117.4× | 4.14% | BNG Mobile | Utility noise |
| 6 | MapXplorer GPS | 112.6× | 6.81% | Goldlab | Utility noise |
| 7 | **Archero (original)** | 84.4× | 2.56% | **Habby** | Same franchise |
| 8 | Flippy Knife | 61.3× | 1.41% | Beresnev | Casual mobile |
| 9 | **Dicero!** | 59.3× | 5.7% | **Habby** | Dice roguelite |
| 10 | Head Ball 2 | 47.4× | 4.24% | Masomo | Casual soccer |

**4 of top-10 = Habby titles.** Archero 2's audience IS heavily Habby-cross-promoted. The cohort: Habby loyalists + casual mobile + occasional anime tag (Kitten Run).

### Cup Heroes audience overlap top-10 (de-anonymized, US April 2026)

| Rank | App | Multiplier | Share | Studio | Type |
|---|---|---|---|---|---|
| 1 | **Claw Master – Roguelike Hero** | 135.0× | 2.67% | Azur Games | Roguelike-hero |
| 2 | Timeline Up! | 103.9× | 8.7% | Rollic | Hypercasual evolution |
| 3 | BitCoiner | 103.1× | 0.73% | Yso Corp | Casual idle |
| 4 | **War Regions - Tactical Game** | 101.2× | 1.42% | SayGames | Tactical strategy |
| 5 | Highway Overtake | 92.5× | 5.41% | HyperMonk | Casual racing |
| 6 | **Fire Hero 2D — Space Shooter** | 84.2× | 1.34% | Azur Games | Space shooter |
| 7 | The Almanac | 58.2× | 0.88% | Voodoo (Cup Heroes' studio) | First-party cross-promo |
| 8 | **Train Miner: Idle Railway** | 51.8× | 3.62% | Azur Games | Idle |
| 9 | Train Ride | 47.2× | 1.77% | MTAG | Hypercasual |
| 10 | Idle Cult Empire | 44.4× | 1.6% | Lion Studios Plus | Idle tycoon |
| (high share) | **Tower War - Tactical Conquest** | 34.3× | **13.94%** | SayGames | Tactical TD |
| (rank 16) | Dicero | 35.7× | 3.44% | Habby | — buried in tail |

**Zero Habby titles in Cup Heroes top-10.** Studio cluster: Azur Games (3 titles), SayGames (2 titles + Tower War at 13.94% share), Rollic, Voodoo, Lion Studios Plus, MTAG — all **hypercasual graduates or mid-core indie publishers.** Different ecosystem from Archero 2.

### The big takeaway — three closest-feature comps, three different audiences

| Closest-feature comp | Audience cluster | What this means for WC |
|---|---|---|
| **Wittle Defender** | Anime-curious cross-platform gamer (NTE, Crunchyroll 31%, PlayStation 23%, Steam 22%, Discord 54%, Pokémon GO 23%) | Honkai aesthetic resonates; anime depth pays off |
| **Archero 2** | Habby ecosystem-locked (SSSnaker, Wittle, Archero, Dicero — 4 of 10) + casual mobile | Habby cross-promo is the moat to break into |
| **Cup Heroes** | Hypercasual / indie graduate (Voodoo + Azur + SayGames + Rollic — zero Habby) | Different cohort entirely; "graduating hypercasual" players, not gacha-hardcore |

WC's design doc §1 anchors the audience target on "Wittle Defender, AFK Journey, Archero 2" — that's the **anime + Habby intersection.** This is a sharper target than v1's "Western mid-core 92% male midcore-TD-RPG" framing. It excludes the Cup Heroes hypercasual cohort and excludes the broad NTE-only anime cohort (those are anime players who chose action-RPG over Wittle's TD-survivor).

```
SHARPENED AUDIENCE PROFILE (from 3-game overlap triangulation):
"Western mid-core male gamer who already plays Wittle Defender or Archero 2,
watches anime on Crunchyroll, owns a PlayStation or PC for cross-platform 
identity, is active on Discord, and may also play Pokémon GO + NTE on the 
side. NOT the Cup Heroes hypercasual graduate. NOT the pure-anime-action-RPG 
Genshin player. The overlap of (Habby loyalist) ∩ (anime gamer)."
```

### Downweight NTE in earlier sections

User correctly flagged: NTE = audience signal, not design comp. v2.A and v2.G overweighted it. **Correction:** NTE should be tagged as "audience-marker game — informs UA targeting + marketing aesthetic, does NOT inform combat design or feature competition." NTE doesn't compete with WC mechanically; it competes for the same player's anime-gacha-curiosity budget.

### What changed in the threat picture

- **Lonely Survivor + Survive Squad have NO measurable US overlap data** in ST → either small enough to fall under panel threshold, OR (more likely) their US install base is too small for ST to measure overlap reliably. **Demote both threats in v2.B ranking.** Both are still feature-similar, but their commercial footprint may be smaller than v2.B assumed.
- **Cup Heroes is in a different audience entirely** (hypercasual graduate cohort). Demote from v1's "uncomfortably close comp" framing. Cup Heroes shares mechanic (14+boss + 3-card draft) but not audience. Audience-overlap threat ≈ 0.
- **Habby cross-promo IS real for Archero 2** (4 of 10 top overlap = Habby) but **NOT real for Wittle** (Wittle's overlap = anime cohort). Cleaner narrative: Habby cross-promotes within their action-RPG flagship (Archero 2), but Wittle's audience reaches outside Habby's portfolio toward anime games.

### Updated audience tracking for v3

Audience comps to add (anime-curious gamer cohort that overlaps with Wittle):
- NTE: Neverness to Everness (Hotta Games)
- Tower of Fantasy (Hotta — predecessor)
- Genshin Impact, Honkai Star Rail (miHoYo) — anime gacha
- Wuthering Waves, Zenless Zone Zero (Kuro) — anime action-RPG

NONE are feature comps. ALL are audience-attention comps. Track for UA spend competition + marketing aesthetic benchmarking.

---

## v2.G — Updated TL;DR

**The v2 take in 5 bullets (updated for v2.H + v2.I findings):**

1. **WC sits at the intersection of two distinct audience clusters: "Habby loyalist" + "anime-curious cross-platform gamer."** Triangulated from app_overlap on Wittle (anime cohort: NTE, Crunchyroll 31%, PlayStation 23%, Steam 22%, Discord 54%, Pokémon GO 23%) and Archero 2 (Habby cluster: 4 of top-10 = SSSnaker, Wittle, Archero, Dicero). Design doc §1's "Wittle + AFK Journey + Archero 2" target IS the intersection. Sharper than v1's broad "midcore TD-RPG" framing.
2. **Cup Heroes is NOT in WC's audience.** v1 flagged it as "uncomfortably close" structurally (14+boss + 3-card draft) but its overlap top-10 is Voodoo + Azur + SayGames + Rollic — hypercasual-graduate cohort, zero Habby. Same mechanics, different player. Demote Cup Heroes from threat list.
3. **Lonely Survivor + Survive Squad have NO measurable ST overlap data.** Either below panel threshold or US footprint too small. Demote both in v2.B ranking — their commercial footprint may be smaller than v2.B's 5/10 score implied.
4. **NTE is an audience-marker, not a design comp.** v2.A overweighted it. Tag NTE + Genshin / Honkai / Wuthering Waves as "UA-competition + marketing-aesthetic benchmarks" only. None of them threaten WC's combat-shape design.
5. **Three kill candidates with reversal paths stand:** Skin→dialogue link, Tier 3 spatial puzzle, Honkai-tier 5-tier portraits. Each has a cheap falsification test. And the inversion claim is two layers: equipment-gacha precedented (Archero $263M), story-locked heroes unprecedented — combination is the moat.

---

---

# Final Recommendations — Path Forward

Decision-ready list ranked by **when** to act. Each item cites the doc section it's grounded in.

## 🔴 DO BEFORE NEXT SPRINT (blockers — must resolve before any external-facing work)

| # | Action | Why | Grounded in | Estimated cost |
|---|---|---|---|---|
| **R1** | **Rename "Resonance" mechanic.** Pick from Catalyst / Alloy / Confluence / Reaction / Harmonic. Audit all design docs for the term. | Archero 2 + CapybaraGo own this term. Players will conflate WC's cross-element compounds with Archero 2's cross-character skill-borrow. | §0 finding #2; v1 §Landmines; v2.D | 0.5 sprint (rename + audit) |
| **R2** | **Test render Bran 5-tier portrait via nano-banana cheap-tier.** Show 20 Honkai-player testers. If <14/20 say "evolves the character," downgrade to 3-tier at Mastery 1/50/100. | "Honkai-tier" is a brand promise the production pipeline cannot meet. Trailer optics risk = "knockoff Honkai." | v2.E.3 | 0.25 sprint + ~$0.60 art cost |
| **R3** | **Decide Tier 3 fate** via Stage-1 SSR question: "If you reach Stage 20, would you opt into 'Advanced Forge'?" If <30% opt-in intent, kill Tier 3. Reversal = "Master Smith Tier 2.5" with 5-6 part categories. | BagMaster Isekai + Backpack Brawl + Backpack Battles iOS ship spatial-bag as entire products. WC Tier-3-as-toggle benchmarks unfavorably. | v2.E.2 | 0.25 sprint SSR design |

## 🟡 DO BEFORE PHASE 1 EXIT GATE (should resolve before $500 ad creative test)

| # | Action | Why | Grounded in | Estimated cost |
|---|---|---|---|---|
| **R4** | **Scope launch quest authoring to 3 × 7 = 21 quests** (not 70). Live-ops the remaining 7 × 7 = 49 quests post-launch. | Backpack Hero's Story Mode reviews flag long story chains as "grind chore." 21 quests is screenshot-promise-honouring and pipeline-fittable. | v1 §1 design-bet table; v2.E "Bets NOT killed" | -1.5 sprints from design §6 plan |
| **R5** | **Test skin→dialogue link before commit.** Stage-1 SSR mockup: skin purchase with "+12 dialogue lines" vs same skin with "+VFX variant only." Measure purchase-intent delta. If dialogue-unlock <10% bump → kill (Mastery-milestone-gated dialogue only). | Unprecedented monetisation + App Store policy exposure on paywalled story content + heavy authoring debt (~1,050 LLM lines). | v2.E.1 | 0.25 sprint SSR design |
| **R6** | **First-60-seconds onboarding script teaches the inversion.** Test message: "No pulling, only forging — heroes are yours, weapons are the world's." Stage-1 SSR probe: "Why are heroes locked?" Players should answer "because they're MINE" not "because the game is cheap." | Inversion claim is the moat. If onboarding fails to teach it, players default-read as "small roster gacha-lite." | v1 §Recommended Actions #4; v2.D | 1 sprint script + UX flow |
| **R7** | **Lock Forge Wheel framing as flavor, not progression-gate.** Combat math: every stage clearable on F2P starter weapon. Whale-vs-F2P combat-math gap stays <2×. | DQSG (Square Enix April 2026) shipped weapons-gacha + got "abhorrent monetization" reviews despite DQ brand. WC has no IP cushion. | §0 Landmines #3; v2.C.3 | Design spec §8 already covers; verify in balance pass |
| **R8** | **Discord pre-launch strategy is first-class** (not afterthought). 54% of Wittle's US audience uses Discord. Build server pre-launch, seed with art/lore drips. | v2.H demographic profile. Discord is the single highest non-utility audience overlap. | v2.H; v2.I Audience Profile | 0.5 sprint plan + ongoing community-mgmt cost |

## 🟢 TRACK QUARTERLY (live operations + watch)

| # | What to track | Trigger | Mitigation if triggered | Grounded in |
|---|---|---|---|---|
| **W1** | Habby patches Wittle Defender with weapon-banner or forge mode | Within 6-18 months | Ship Tier 1 forge (body + rune) early to differentiate beyond "weapon gacha" → "craftable weapon gacha" | v1 §Top 3 Habby moves |
| **W2** | Archero 2 expands Resonance into multi-character compound system | Quarterly patch monitoring | Recipe Codex collection layer (post-rename) becomes the IP-hard differentiator | v1 §Top 3 Habby moves |
| **W3** | Habby ships hero-squad survivor with story chapters | Watch Habby roadmap/announcements | 10-quest chains + portrait evolution visible in trailers is the marketing wedge | v1 §Top 3 Habby moves |
| **W4** | Last War / Whiteout UA spend on Crunchyroll / Discord / PlayStation app inventory | Monthly UA platform monitoring | Pre-empt with own Crunchyroll + Discord placement budget | v2.I; v2.C.4 |
| **W5** | NTE / Genshin / Honkai / Wuthering Waves seasonal events steal audience attention | Quarterly anime-RPG event-calendar tracking | Time WC content drops to avoid overlap with miHoYo / Kuro major patches | v2.H; v2.I |
| **W6** | BagMaster Isekai / Backpack Brawl / Backpack Battles iOS feature pickup | Quarterly storefront ranking check | If Tier 3 kept: re-evaluate scope vs benchmark | v2.E.2; v1 Appendix C |
| **W7** | Sensor Tower app_overlap on Wittle Defender every 90 days | Quarterly data pull | Watch for new entries (next "Dicero"); watch Archero 2 share for trend | v2.A; v2.I |

## ⚫ EXPLICITLY NOT IN SCOPE (rejected during research)

- Adding hero-banner gacha as a "v1.x escape valve" — kills the moat
- Dropping the 5-element schema in favor of single-element — kills the Resonance compound mechanic which is the uncontested novelty axis
- Targeting Cup Heroes hypercasual cohort (v2.I shows they're a different audience entirely)
- Targeting pure-anime-action-RPG cohort (Genshin / Honkai / Wuthering Waves players choose action-RPG over WC's TD-survivor)
- Premium Steam launch (WC's combat shape + monetisation = F2P mobile; Steam premium = different game)

---

# Confidence Audit

Every load-bearing claim, classified by source confidence. **Use this to decide where to push back on the analysis before committing engineering or marketing resources.**

| Claim | Source | Confidence |
|---|---|---|
| Wittle Defender $10M first month | PocketGamer.biz | ⭐⭐⭐ Sourced |
| Archero 2 $32.8M first 30 days | PocketGamer.biz | ⭐⭐⭐ Sourced |
| Archero original $263M lifetime | Game World Observer | ⭐⭐⭐ Sourced |
| Survivor.io $500M+ lifetime | Mobilegamer.biz, Gamesforum | ⭐⭐⭐ Sourced |
| AFK Journey $185M lifetime / $128M IAP / 12M+ DL | MAF blog, Naavik | ⭐⭐⭐ Sourced |
| Last War: Survival $2.6B+ lifetime / $180M Sep 2025 | PocketGamer.biz, TechNode, AppMagic | ⭐⭐⭐ Sourced |
| Whiteout Survival 1.5M+ US iOS ratings | Sensor Tower direct query 2026-05-28 | ⭐⭐⭐ Sourced (live data) |
| **Wittle ↔ Archero 2 23.2% audience share (April 2026)** | Sensor Tower app_overlap 2026-05-28 | ⭐⭐⭐ Sourced (live data) |
| **Wittle audience profile (Crunchyroll 31%, Discord 54%, etc.)** | Sensor Tower app_overlap + unified_apps 2026-05-28 | ⭐⭐⭐ Sourced (live data) |
| **Archero 2 top-10 overlap = 4 Habby titles (SSSnaker, Wittle, Archero, Dicero)** | Sensor Tower 2026-05-28 | ⭐⭐⭐ Sourced (live data) |
| **Cup Heroes top-10 overlap = 0 Habby (Voodoo + Azur + SayGames cluster)** | Sensor Tower 2026-05-28 | ⭐⭐⭐ Sourced (live data) |
| Lonely Survivor + Survive Squad no ST overlap data | Sensor Tower 2026-05-28 (empty response) | ⭐⭐⭐ Sourced (negative finding) |
| Resonance term used by Archero 2 + CapybaraGo | Pocket Gamer guides + Capybara Go wiki | ⭐⭐⭐ Sourced |
| BagMaster Isekai 760k DL, 4.47★ | Pocket Gamer launch + SayGames blog | ⭐⭐⭐ Sourced |
| Backpack Hero PC reviews flag Story Mode as grind | Steam / Metacritic / OpenCritic | ⭐⭐⭐ Sourced |
| DQSG monetization "abhorrent" | Game8 review | ⭐⭐⭐ Sourced |
| "5min run length is on-target for mobile" | Genre survey (Lonely Survivor 5min, Ninja Survivors 7min, Zombie Waves 6-12min) | ⭐⭐ Inferred from genre median (sample-of-3, per v1 critique) |
| "Story-progression-locked roster unprecedented in F2P mobile RPG" | 50-game research set (3 parallel agents) | ⭐⭐ Inferred from research scope (could have missed obscure title) |
| "Combination of locked-roster + weapon-gacha is the moat" | Logical synthesis of above | ⭐⭐ Inferred |
| "Habby will copy in 6-18 months" | Speculation based on Habby iteration cadence | ⭐ Unsourced — track via W1 |
| "Skin→dialogue carries App Store regulatory risk" | Logical inference, no specific precedent cited | ⭐ Inferred — falsify via v2.E.1 SSR |
| "Backpack Hero-shape mechanic too PC-native for mobile mass-market" | Reading of BagMaster simplification vs original | ⭐⭐ Inferred (BagMaster's success shows mobile-version CAN work) |
| **NTE: Neverness to Everness as audience signal vs design comp** | v2.H + v2.I correction after user pushback | ⭐⭐⭐ Sourced + ⭐⭐ inferred interpretation |
| "Audience target = Habby loyalist ∩ anime-curious gamer" | Triangulation of 3 ST overlap pulls | ⭐⭐⭐ Sourced data + ⭐⭐ inferred interpretation |
| Whale-vs-F2P combat math gap target <2× | Design spec assertion | ⭐ Starting value — verify in balance pass per Numbers Policy |
| Recipe Codex +25% cap | Design spec assertion | ⭐ Starting value — verify post-launch with cohort-completion data |
| "Resonance rename candidates: Confluence / Catalyst / Alloy" | Synthesis suggestion | ⭐ Inferred — user decision |

**Legend:**
- ⭐⭐⭐ Sourced (citation / live data query / direct measurement)
- ⭐⭐ Inferred (logical synthesis from sourced material)
- ⭐ Unsourced (speculation / starting value / direction-only)

**Where to push back hardest:** any ⭐ claim that drives a $X engineering decision. Most ⭐ claims have a paired falsification test (Stage-1 SSR question, ad-creative test, telemetry tracking) already specified.

---

# Open Questions / Research Debt

Items the doc deliberately does NOT resolve. Each tagged with a next-step.

| # | Question | Next step |
|---|---|---|
| Q1 | What's Wittle Defender's actual D7 / D30 retention curve? | Sensor Tower `retention_metrics` call (haven't run yet) |
| Q2 | What's Wittle's ARPPU vs Archero 2? | Sensor Tower `download_revenue_estimates` on both, divide by paying-user-share |
| Q3 | What's the top-grossing iOS RPG category leader (rank #1 ID `6739554056`)? | 1 `unified_apps` call |
| Q4 | What's NTE's actual D1 / D7 retention? Is it a real anime-cohort threat or churn-heavy? | Sensor Tower `retention_metrics` call |
| Q5 | Which apps appear in top-10 overlap of Survivor.io, AFK Journey, BagMaster Isekai? | 3 more `app_overlap` calls (large response — read top-N from saved file) |
| Q6 | Is "Resonance" trademarked by Habby? | Trademark database lookup (USPTO + EUIPO) |
| Q7 | What's the actual nano-banana cost for Honkai-tier portrait vs 3-tier? Bran test render needed | Run the test per R2 |
| Q8 | Does App Store policy actually restrict skin-gated dialogue? Read App Store Review Guidelines section on IAP + content gating | Legal review |
| Q9 | Cohort retention curves on the 3 kill candidates — what does Stage-1 SSR actually show? | Build SSR test instrument per R3, R5 |
| Q10 | Are there obscure F2P mobile RPGs we missed that DID try story-locked roster? | Targeted Reddit / TouchArcade community search; ask gacha-genre journalists |

---

## Document changelog

| Date | Version | Notes |
|---|---|---|
| 2026-05-28 | 1.0 | Initial synthesis from 3-agent parallel research run. Source: design spec v2.1 (Wittle Inversion) |
| 2026-05-28b | 2.0 | Critique-driven followup: 4 missing competitors (AFK Journey, Whiteout Survival, Top Heroes, Last War), Sensor Tower live audience overlap data (23.2% Wittle↔Archero 2), rebuilt threat ranking with 4 explicit dimensions, inversion claim reframed in two layers, 3 kill candidates with reversal paths, Numbers Policy audit. Sensor Tower API: 159 calls used (limit null/unlimited). |
| 2026-05-28c | 2.1 | v2.H added: Sensor Tower `unified_apps` de-anonymized the 12 mystery overlap apps. Major correction: rank 1 overlap is NTE (Hotta Games) NOT Dicero. Audience reinterpreted as cross-platform anime-curious gamer cohort, not Habby-locked. Demographic profile sharpened (Discord 54%, Crunchyroll 31%, PlayStation 23%, Steam 22%, Pokémon GO 23%). Sensor Tower API: 163 calls used. |
| 2026-05-28d | 2.2 | v2.I added: user pushback flagged v2.A only ran overlap on Wittle (single audience signal). Ran app_overlap on Archero 2 + Cup Heroes (saved truncated, parsed top-10 from file); Lonely Survivor + Survive Squad returned empty (no ST panel data). De-anonymized both top-10s. Big finding: three closest-feature comps target THREE different audiences (Wittle = anime cohort, Archero 2 = Habby cluster, Cup Heroes = hypercasual-graduate cohort). WC sits at Habby ∩ anime intersection. NTE downweighted to "audience marker only." Sensor Tower API: 170 calls used. |
| 2026-05-28e | **2.2 final** | **Finalised for handoff.** Added §0 Executive Summary (single source of truth), reading guide, TOC, Final Recommendations (R1-R8 + W1-W7), Confidence Audit (24 claims rated), Open Questions (Q1-Q10 with next-step pointers). All earlier v1/v2 sections marked as audit trail. Ready for design team review + Phase 1 exit-gate planning. |

---

*End of competitor landscape synthesis (v2.2 final, finalised 2026-05-28e).*

**Next research session priorities (sourced from §Open Questions):**
1. Sensor Tower `retention_metrics` on Wittle, Archero 2, NTE (Q1, Q4)
2. Sensor Tower `download_revenue_estimates` on top-5 threats + 4 anime audience-comps (Q2)
3. `app_overlap` on Survivor.io + AFK Journey + BagMaster (Q5)
4. Run R2 (Bran 5-tier portrait test) + R3 (Tier 3 SSR question) + R5 (skin→dialogue SSR test) — three cheap falsifications
5. USPTO/EUIPO trademark check on "Resonance" before R1 finalises rename (Q6)

**Pair this doc with:**
- [`docs/superpowers/specs/2026-05-27-wittle-inversion-design.md`](../superpowers/specs/2026-05-27-wittle-inversion-design.md) — Phase 1 design spec v2.1 (the source of every "Bet #N" reference in §0)
- Future SSR submission package — §0 Audience Profile + R6 onboarding script should propagate to SSR text bundles in design spec §19
