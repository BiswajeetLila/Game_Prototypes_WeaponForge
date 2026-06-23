# Teamfight Tactics — Design Specification: Core Loop, Progression & the D1–D30 Player Experience

**Compiled:** 2026-06-15 · **Author:** Claude (synthesis) · **Status:** research synthesis, not a Riot-official document

---

## 0. How to read this document (provenance & tagging)

This spec answers: *how TFT works, its core loop, its progression systems, what players experience
across D1–D30, what they like, why they return, and what unlocks when.* Per request, **every
non-trivial claim is tagged for reliability.**

| Tag | Meaning |
|---|---|
| `[S1]` | Genuine — from **`Systems Design Analysis of Teamfight Tactics…md`** (deep, 46-source TFT doc in this folder). Line refs given, e.g. `[S1 L33]`. |
| `[S2]` | Genuine — from **`Strategic Architecture and Market Evolution…md`** (genre/market doc in this folder). |
| `[LIVE]` | Genuine — live app-intelligence pull on 2026-06-15 (US Android). Detail in **`TFT_live_appintel_data_2026-06-15.md`**. |
| `[INFERRED]` | Reasoned from one or more sourced facts above, but **not stated verbatim** in any source. |
| `[ASSUMED]` | My assumption / industry-standard default. **No source.** Treat as hypothesis. |
| `[⚠SRC]` | Appears in a source doc, **but the source itself is low-confidence** (reads as AI-generated market boilerplate or is uncited). Flagged, not laundered. |

> ### ⚠ Corpus honesty note (important)
> The brief assumed a rich Phase-1/Phase-2 raw corpus (word-for-word web scrapes, video frames,
> transcripts, review CSVs) lived in this folder. **It did not.** At compile time the folder held
> only the **two secondary synthesis docs** named above — themselves derived from dev blogs,
> Reddit, wikis, and market reports. So:
> - The deepest, most reliable material is `[S1]` (well-cited TFT systems doc).
> - `[S2]` (market/genre doc) contains several claims that read like generic market-report or
>   AI-deep-research output (market-size dollar figures, esports prize tables, "hybrid and electric
>   battler types"). These are tagged `[⚠SRC]` and should be independently verified before use.
> - To avoid inventing the player-sentiment / retention answers, I **enriched** with genuine live
>   app-intel data (`[LIVE]`). That data is **US-Android-only and panel-modeled** (retention
>   confidence is low) — directional, not gospel.
> - The literal **"D1–D30 calendar arc" is a constructed model** `[INFERRED]/[ASSUMED]`. TFT's own
>   sources speak in *match rounds* (Stage 1-1, 3-1…) and *set lifecycles* (months), not login days.
>   Where a day's beats rest on a sourced mechanic, the mechanic is tagged; the calendar placement
>   is the assumption.

---

## 1. Executive summary

TFT is an **8-player free-for-all round-based auto-battler**: you draft units from a shared
randomized shop, arrange them on a hex grid, and watch them auto-fight a different opponent each
round; last player standing of the 8 wins `[S1 L3]`. You start at **100 HP** and bleed HP on each
combat loss `[S1 L3]`. The genuine hook is **structured, replayable variance**: rotating thematic
"Sets" of champions/traits every few months `[S1 L135] [S2 L26]`, plus per-match roguelike layers
(**Augments**, **Region Portals**) that make every game a fresh optimization puzzle
`[S1 L74-76]`. Monetization is **purely cosmetic** (Chibis, arenas, Little Legends via Treasure
Realms) — Riot sells no power `[S1 L187]`.

Live signal (2026-06, US Android) `[LIVE]`: **4.51★ over 754k ratings** (81.6% 5★), a **D1→D7→D30
retention curve of ~37.7% → 15.9% → 7.4%** that flattens to a sticky ~4.3% core by D90 (~11–13× the
modeled category baseline), and a **monthly-active curve that visibly spikes on new content** (Mar
trough 64k → Apr 87k). The flip side: the **recent review flow skews negative** (Mar–Jun text
reviews: 44% 1★ vs 32% 5★), dominated by **mobile performance/bugs**, **RNG-fairness perception**,
and **current-set (Set 17) backlash**.

---

## 2. Platforms, access & framing

- **Genre:** auto-battler / "auto chess" lineage (originated as a Dota 2 mod, *Auto Chess*) `[S2 L3]`.
- **Developer/Publisher:** Riot Games `[S2 L26] [LIVE]`.
- **PC launch:** June 18, 2019 `[S1 L211]`. **Mobile launch:** March 2020 — Android 2020-03-16,
  iOS 2020-03-18 `[LIVE]`. (A June-2026 reviewer references the **"7-year anniversary,"**
  corroborating the 2019 origin `[LIVE]`.)
- **Access model:** on PC, playable via the Riot/League client; on mobile, a **standalone app**
  with cross-progression. `[S1 L212]` frames PC access as "integrated within the League client";
  the standalone mobile app is `[LIVE]`-confirmed. `[INFERRED]` cross-platform account sharing
  (reviewers play "on PC" and "on mobile" with the same rank).
- **Design intent:** built to capture **low-APM, ex-League players** who want cognitive strategy
  over mechanical execution `[S2 L121]`. Design pillars stated as **Mastery, Competition,
  Discovery** `[S2 L119]`, expanded in §5's "four pillars."
- **Session length:** a full match runs **~25–45 minutes** `[S1 L217]`.

---

## 3. The core loop

### 3.1 One match, top to bottom

A match is a sequence of **rounds** grouped into **Stages** (e.g., Stage 1-1, 1-2 … 2-1 …). Each
round alternates a **planning phase** and an **auto-combat phase** `[S1 L2-L3]`:

```
        ┌─────────────────────── ROUND (repeats ~30+ times) ───────────────────────┐
        │                                                                            │
  PLAN  │  gain gold → (re)roll shop → buy units → combine 3-of-a-kind → place on    │
        │  hex grid → equip items → (at set rounds) pick an Augment/Portal vote      │
        │                                   │                                        │
        │                                   ▼                                        │
 COMBAT │  units auto-fight an opponent's board (no direct control); winner deals    │
        │  damage = leftover units + stage scaling; loser loses HP                   │
        │                                   │                                        │
        │                                   ▼                                        │
 RESOLVE│  collect win/loss gold, streak gold, interest; HP updated; eliminated at 0 │
        └────────────────────────────────────────────────────────────────────────────┘
```

`[S1 L3-L4]` for the plan/combat/HP structure; gold mechanics in §4.1.

### 3.2 The three beginner loops

Onboarding centers on **three intertwined loops** `[S1 L4]`:
1. **Upgrading units** — buy duplicates to star them up (§4.2).
2. **Building synergies** — assemble trait "breakpoints" from your units (§5.2).
3. **Managing item distribution** — combine components into completed items on the right carriers
   `[S1 L4-L5, L45]`.

### 3.3 Carousel / Portals (shared draft & catch-up)

Periodically all players enter a **shared draft**. Historically the **Carousel** (players physically
grab a unit+item off a rotating ring; lowest-HP players pick first → a **comeback/catch-up**
mechanic) `[S1 L33, L216]`. In modern sets the opening Carousel was **replaced by Region Portals**
— a pre-match **vote** on a rule-modifier that removes the old real-time click-accuracy scramble
`[S1 L75]`. Mid-match shared drafts still function as the loss-protected catch-up valve `[INFERRED]`.

---

## 4. Progression systems (in-match)

### 4.1 The gold economy (the strategic spine)

Gold is earned via **passive income, win bonus, interest, and streaks** `[S1 L12]`:

| Source | Rule | Reward |
|---|---|---|
| Passive | escalates early: R1-2/1-3 → +2; R1-4 → +3; R2-1 → +4; R2-2+ → +5 | +2…+5 `[S1 L16-L19]` |
| Win bonus | win a player-combat round | +1 `[S1 L20]` |
| Interest | per full 10 gold held, capped at 50g | +1 per 10g, max +5 `[S1 L21]` |
| Streak | 2–3 in a row → +1; 4 → +2; 5+ → +3 (wins **or** losses) | +1…+3 `[S1 L22-L24]` |

- **Interest formula:** `I = min(floor(G/10), 5)`, settled at round end → compounding incentive to
  bank gold `[S1 L26-L31]`. The **"Rich Get Richer"** augment raises the interest cap to **7** `[S1 L32]`.
- **Win-streak vs loss-streak tension:** losing on purpose ("loss-streaking") farms streak gold and
  better Carousel priority, trading HP for economy `[S1 L33]`. To stop passive loss-streaking from
  dominating, rewards are tuned **55/45 in favor of win-streaking**, not a neutral 50/50 `[S1 L33]`.
- **"Modified hyper roll":** at **Stage 3-1**, rolling down to exactly **32 gold** at level 4
  exploits high 1-cost odds while losing only 3 interest — a known optimal breakpoint `[S1 L34, L40]`.

> Why this matters: the economy converts "greed vs. board strength vs. HP" into the central
> recurring decision every round. It's the most-praised and most-imitated system in the genre
> `[S1 L12, L26]` and the axis players obsess over in guides `[S2 L126]`.

### 4.2 Unit star-up (the "triple")

Collecting **3 identical units** auto-merges them into a higher star tier `[S1 L4]`:

| Tier | Duplicates needed | Cumulative 1★ units | Power |
|---|---|---|---|
| 1★ | base purchase | 1 | baseline `[S1 L8]` |
| 2★ | 3× 1★ | 3 | big HP/AD/spell boost `[S1 L9]` |
| 3★ | 3× 2★ | 9 | max scaling; game-winning ability values `[S1 L10]` |

Units share a **finite shared pool** across all 8 players — if many players contest the same unit,
its shop odds collapse, forcing pivots `[S1 L71] [S2 L37]`. Developers deliberately keep **high-end
3★ 4-cost/5-cost units rare** (via bag-size + Level 10 changes) to protect composition skill over
raw highrolling `[S1 L94]`.

### 4.3 Player level & shop odds

Spending gold to **level up** raises your unit cap and **shifts shop rarity odds** toward
higher-cost units `[INFERRED from S1 L34, L94]` (the doc references levels 4 and 10 and "elevated
odds of finding 1-cost units" at low level). **Exact per-level odds tables are not in the
corpus** `[ASSUMED that they follow standard TFT per-level rarity curves]`.

### 4.4 Items

8 **basic components** combine into dozens of **completed items**; mis-itemizing is a classic
beginner trap (many use external cheat-sheets) `[S1 L45, L11]`. Modern combat-role rules changed
itemization: **anti-heal** and the death of **"drain tanks"** mean backline chip damage is no longer
wasted `[S1 L68, L184]`. **Radiant items** and **artifact/ornn items** are rare high-power variants
that drive "good variance" highrolls `[S1 L89]` — though **hyper-specific artifacts** that only suit
one champion are flagged as "bad variance" `[S1 L88]`.

### 4.5 Augments (the roguelike replay layer)

**Augments** are permanent, match-wide modifiers offered at **three set intervals**, each a choice
of **3 random options with a limited reroll** `[S1 L76]`. They are the primary **replayability
engine** `[S1 L74]`. Design tension `[S1 L88-L89]`:
- **Good variance:** rare, exciting, force adaptation (cashout augments, radiant items).
- **Bad variance:** intrusive low-tier augments / hyper-specific artifacts that **lock you into a
  forced line** and kill flexibility.
- Stats are read carefully for **selection/performance bias** (e.g., "Golden Egg" looks great only
  because healthy boards pick it; "World Runes" underperforms because mid-ELO players can't manage
  the load) `[S1 L90-L92]`.

### 4.6 Region Portals

A **start-of-match vote** that alters baseline rules from round one — ranging from minor tweaks to
"game-warping" rules (e.g., "Scuttle Puddle," "Prismatic Symphony") `[S1 L75]`. Sets the economic
vs. combat tempo context for the whole match `[S1 L75]`.

### 4.7 What unlocks *when* — in-match timeline

`[INFERRED]` composite from `[S1 L16-L34, L75-L76]` (exact set-specific timings vary by patch):

| Stage | What "unlocks" / happens |
|---|---|
| Pre-game | Region Portal vote sets match rules `[S1 L75]` |
| Stage 1 (1-1…1-4) | escalating passive gold +2→+3; first units/items; first Augment often here `[S1 L16-L18, L76]` |
| Stage 2-1 | passive hits +4, then +5; economy decisions begin in earnest; streaks form `[S1 L19]` |
| Stage 2/3 boundary | 2nd Augment; first big **roll-down** decision; "32-gold hyper roll" at 3-1 `[S1 L34]` |
| Mid-game (3–4) | level toward 7–8; stabilize a trait core; 3rd Augment `[S1 L76]` |
| Late-game (5+) | push level (up to **10**), chase 2★ 4/5-costs or 3★ carries; positioning & scouting decide placement `[S1 L65-L71, L94]` |

---

## 5. Strategic depth — why mastery is deep

### 5.1 The four pillars

TFT mastery is framed on four axes `[S1 L48, L64]`:
- **Knowledge** — memorize traits, item recipes, shop odds `[S1 L64]`.
- **Flexibility** — pivot composition against bad rolls / unexpected items `[S1 L64]`.
- **Fortune** — manage luck / optimize outcome distributions `[S1 L64]`.
- **Perception** — scout opponents, track the shared champion pool, counter-position `[S1 L64, L71]`.

### 5.2 Traits, positioning, scouting

- **Traits:** vertical (deep one-trait) vs horizontal (splash) builds; designers ensure every 1-cost
  shares a trait with another 1-cost for smooth early synergies, and use **"insular vertical twins"**
  (a 1-cost + a 4/5-cost sharing a trait, e.g., Maddie/Caitlyn) to teach comps `[S1 L69-L70]`.
- **Positioning:** auto-playable for casuals, but a **game-winning** lever at high level — drawing
  tank aggro, hiding carries from assassins/CC; reinforced by **positional augments** `[S1 L65-L66]`.
  The **"50/50 tank-targeting rule"** lets melee reliably hit the closest tank, so front-liners can
  sit in the front row `[S1 L67]`.
- **Scouting:** because the pool is shared, watching what opponents contest changes your odds math
  and forces pivots `[S1 L71]`. Heavily mediated by **"metamedia"** (tier lists, overlays, trackers)
  `[S1 L72]`.

---

## 6. Meta-progression & live-service systems (between matches)

### 6.1 Ranked ladder

A competitive ladder (tiers up to Challenger; reviewers reference **Emerald** divisions) is the
primary skill-expression and retention driver `[S1 L114] [LIVE review mentions Emerald II→IV]`.
`[ASSUMED]` standard seasonal LP/MMR ranked structure resetting per set — corpus doesn't detail the
exact tier table.

### 6.2 Set rotation (the headline retention engine)

Every few months TFT **completely swaps its champion roster, trait web, and core mechanic** — a new
**Set** `[S1 L135] [S2 L26]`. This is the deliberate antidote to "solved meta" staleness and the
biggest reason the game stays fresh for years `[S1 L74, L224] [S2 L123]`. The **Discovery-Generated
Novelty → Player-Generated Novelty → Core-Gameplay-Engagement** curve describes how a set's
engagement should evolve from launch hype to deep mastery `[S1 L95]`.

### 6.3 Monetization — cosmetic gacha

- **No power sold** — only tacticians, arenas, and premium **Chibi** champion skins `[S1 L187]`.
- **Treasure Realms:** spend **Treasure Tokens** to pull limited bounties; duplicates auto-convert
  to currencies (Realm Crystals / Mythic Medallions) `[S1 L187-L189]`:

  | Duplicate rarity | Converts to | Buys |
  |---|---|---|
  | Standard | 200 Realm Crystals | seasonal shop, standard Little Legends `[S1 L193]` |
  | Legendary | 500 Realm Crystals | premium seasonal shop `[S1 L194]` |
  | Mythic | 10 Mythic Medallions | classic Chibi skins `[S1 L195]` |
  | Prestige | 25 Mythic Medallions | prestige Chibis / arenas `[S1 L196]` |

- A **Rotating Shop** lets players trade currency for **guaranteed** cosmetics — introduced to
  replace the disliked random Little-Legend **egg** loops `[S1 L198-L199]`.
- **Battle Pass** exists `[LIVE — reviewers reference buying it]`; structure not detailed in corpus
  `[ASSUMED standard seasonal pass]`.

### 6.4 What unlocks *when* — account/calendar cadence

> **Low-confidence section.** The corpus does **not** contain a primary account-progression unlock
> table. Below is `[INFERRED]/[ASSUMED]` from scattered references; verify against the live client.

- New players: a **Set 16 "unlock system"** was added to streamline unit onboarding/progression
  without diluting depth `[S1 L46]` — `[INFERRED]` this gates/teaches content over early sessions.
- **Per-set cadence:** new set ≈ every few months; **bi-weekly balance patches** between `[S1 L221]`.
- **Battle pass / seasonal events** refresh on the patch cadence `[LIVE references "current event…
  seasonal store"]`.
- **Ranked seasons** reset per set `[ASSUMED]`.

---

## 7. The D1–D30 player experience

> **Framing caveat (repeat):** TFT is session/match-structured, not a daily-quest grind, so a
> literal login-day arc is a **model**, not a sourced timeline. Mechanics are tagged; the
> day-placement is `[INFERRED]/[ASSUMED]`. The retention numbers anchoring this section are
> `[LIVE]` (US-Android panel model, low confidence) — see `TFT_live_appintel_data_2026-06-15.md`.

### Retention reality (the spine of this section) `[LIVE]`

| Day | Retention | Read |
|---|---|---|
| D1 | **37.7%** | strong hook vs ~3% baseline, but ~62% bounce after one session |
| D3 | 24.5% | the "do I get it?" cliff |
| D7 | **15.9%** | comp/economy literacy forms here or churn |
| D14 | 11.4% | habit forming for survivors |
| D30 | **7.4%** | committed players; ranked identity |
| D90+ | ~4.3% plateau | **hardcore core that barely decays** |

### D1 — First session (the 37.7% gate)
- **Experience:** dropped into an 8-player match; taught the **three loops** (star-up, synergies,
  items) `[S1 L4]`. Auto-positioning and auto-combat mean a beginner can play without micro `[S1 L65]`.
  Region Portal + first Augments deliver an early "I made a choice that mattered" beat `[S1 L75-L76]`.
- **Friction:** historically **UI readability** — buy/reroll cues took **3–5s to parse vs 0.5–1s** in
  Underlords `[S1 L44]`; **item recipes confuse** beginners `[S1 L45]`. On mobile *today*, the first
  session is also where **bugs/perf** bite hardest `[LIVE: crashes, stuck matchmaking, 30fps]`.
- `[INFERRED]` the ~62% D1 drop is partly genre intimidation + (on mobile) technical friction.

### D2–D3 — The comprehension cliff (30% → 24.5%)
- Players who return are testing *"can I understand this?"* `[ASSUMED]`. The **insular vertical twins**
  and shared-trait 1-costs exist precisely to let a novice stumble into a working comp here
  `[S1 L69-L70]`. Survivors begin to feel the economy's greed-vs-strength tension `[S1 L33]`.

### D4–D7 — Literacy or churn (→ 15.9%)
- **Experience:** first real **economy decisions** (interest breakpoints, when to roll), first
  deliberate **trait core**, first **scouting** of opponents `[S1 L26-L34, L71]`. This is where the
  "thinking person's" loop clicks `[S2 L3]`. Live 5★ reviewers describe exactly this: *"the builds
  are interesting, the learning curve feels engaging"* and *"addicted"* `[LIVE]`.
- `[INFERRED]` D7's 15.9% ≈ the share who crossed from "watching it happen" to "driving the economy."

### D8–D14 — Habit & first highrolls (→ 11.4%)
- Players chase the **good-variance dopamine**: a cashout augment, a radiant item, a clean
  3★ `[S1 L89]`. Augment/Portal variety means **no two games are identical**, which sustains
  curiosity `[S1 L74]`. `[ASSUMED]` first ranked games / placement happen in this window for many.

### D15–D30 — Ranked identity & the core (→ 7.4%)
- **Experience:** committed players adopt a **rank identity**, consume **metamedia** (tier lists,
  trackers) to optimize `[S1 L72]`, and start "forcing" or "flexing" comps deliberately `[S1 L116]`.
- **Risk:** this is also where **balance/variance complaints** and **set fatigue** surface — live
  churn quotes ("rank dropped… feels like the system decides who wins," "uninstalled because of
  set 17") cluster among engaged players, not just newbies `[LIVE]`.
- `[INFERRED]` the ~7.4% D30 → ~4.3% D90 plateau **is** "the core": these players persist *across*
  sets, re-engaging on each content drop (visible in the Mar→Apr MAU spike) `[LIVE]`.

---

## 8. What players like (genuine)

**From the design corpus `[S1]/[S2]`:**
- **Structured, exciting variance** — rare highrolls (cashout augments, radiant items) feel great
  *because* they're rare `[S1 L89]`.
- **Constant discovery** — new Sets keep a 5+-year-old game fresh; novelty is the explicit retention
  thesis `[S1 L135, L224] [S2 L123]`.
- **Comeback tension** — the Carousel/draft catch-up keeps losing players in the game `[S1 L33, L216]`.
- **Depth without APM** — strategy over mechanics; positioning that's optional for casuals but
  decisive for experts `[S1 L65] [S2 L121]`.
- **Cosmetic-only fairness** — power isn't sold `[S1 L187]`; the move to a **guaranteed** cosmetic
  shop over RNG eggs was well-received `[S1 L199]`.

**From live reviews `[LIVE]` (verbatim):**
- *"very fun game,"* *"the builds are interesting, and the learning curve feels engaging,"*
  *"I am addicted to the game,"* *"A great way to play TFT portably,"* *"like MLBB but harder."*
- The 81.6% lifetime 5★ share (754k ratings) reflects a large satisfied base `[LIVE]`.

---

## 9. Why players come back (the retention engine)

1. **Set rotation** — a wholesale content reset every few months is the headline re-acquisition
   driver `[S1 L135] [S2 L26]`. **Live proof:** US-Android MAU jumps **64k (Mar) → 87k (Apr)** on a
   content cycle `[LIVE]`.
2. **Per-match novelty** — Augments + Portals make each *game* a new puzzle, so the loop doesn't
   "solve" `[S1 L74-L76]`. This is the explicit anti-stagnation design `[S1 L93]`.
3. **Ranked ladder** — long-horizon mastery/status goal for the committed core `[S1 L114]`.
4. **Bi-weekly balance + live-service cadence** — a steady drip that kept TFT ahead of slower rivals
   like Underlords `[S1 L220-L221]`.
5. **Sticky-core retention shape** — once past D30, decay nearly stops (~7.4%→~4.3% by D90),
   ~11–13× the category baseline `[LIVE]`. The genre's appeal: *"watching a complex plan come to
   fruition"* `[S2 L185]`.

> Contrast `[S1 L219-L221]`: **Dota Underlords** removed variance to feel "clean," felt **solved**,
> updated slowly, and stalled — the cautionary inverse of TFT's variance+cadence formula.

---

## 10. Friction & churn drivers (genuine)

**Design-level `[S1]`:** onboarding UI readability `[L44]`; item-recipe confusion `[L45]`; "bad
variance" augments/artifacts that remove agency `[L88]`; reducing variance too far makes the meta
stale (the failed **Legends** system) `[L93]`; **set fatigue** if novelty isn't managed `[L95]`;
removing public augment stats created **asymmetric info** that frustrated competitors `[L203-204]`.

**Live, current (2026-06, US Android) `[LIVE]` — recent flow is 44% 1★:**
1. **Mobile performance/bugs (dominant):** crashes/freezes (esp. *Tocker's Trials*), 30fps lock, no
   graphics-quality toggle, dead buttons (incl. **battle-pass purchase**), stuck matchmaking,
   can't-move-units. Refrain: *"fun on PC, trash on mobile."*
2. **RNG/fairness perception:** *"the system decides who wins,"* *"messing with probabilities,"*
   bots reportedly beating players. (Design counters exist — hidden odds-smoothing `[S1 L132]` — but
   perception ≠ reality, and opacity feeds distrust.)
3. **Current-set backlash:** *"avoid the current set,"* *"uninstalled because of set 17"* — the same
   rotation that re-acquires can also repel when a set misses.
4. **Monetization grievance:** *"2 pulls for a 7-year anniversary,"* *"a cozy game being milked."*
5. **Missing mobile QoL/social:** no voice/party chat, no profile-icon edit, localization gaps.

> **Tension worth noting:** lifetime 4.51★ vs recent 44%-1★ flow means the **store rating lags the
> live mood**. The committed core stays (retention plateau holds), but *new* mobile installs in
> 2026 are meeting a buggier first session than the design deserves `[LIVE + INFERRED]`.

---

## 11. Live-service balance philosophy (how Riot keeps it tuned)

- **Game Analysis Team (GAT):** ex-pros/analysts who validate designs pre-PBE against 5 goals
  (satisfying+clear combat; intuitive combat; viable rewarding traits; vertical+horizontal mix;
  reward scouting without making it mandatory) `[S1 L97-L104]`.
- **Board strings & power framework:** thousands of late-game board simulations; balanced so
  `1-cost 3★ < 4-cost 2★ ≈ 2-cost 3★ < 3-cost 3★` `[S1 L106-L110]`. Plus **path-to-carry sweeps**
  `[S1 L111]` and **LP-Delta + daily meta snapshots** `[S1 L113]`.
- **"Game Dev's Dilemma":** designers should **play to learn (off-meta), not to win (ladder-climb)**;
  balancing only for the top 1% breaks accessibility `[S1 L114-L118] [S2 L180-181]`.
- **"Swing big" tuning** + hidden mechanics that must stay hidden (odds-smoothing OK; secret
  lockouts backfire) `[S1 L121, L132-133]`.
- **Pioneer Tax / tech debt:** ambitious mechanics on compressed timelines cost visual/technical/
  balance debt; a core-engine tweak can break **500+ spells across 140+ champions** `[S1 L135-154]`.

**Set post-mortems (what they learned) `[S1 L158-L184]`:**
- **Dragonlands (S7):** two-slot dragons → rigid boards → abandoned.
- **Monsters Attack (S8):** drip-economy traits too warping → moved economy to augments + cashouts;
  **Threat** (no-synergy flex) units were a hit.
- **Magic n' Mayhem (S12):** **Charms** = many small choices vs few big swings; capped tooltips to
  protect pacing.
- **K.O. Coliseum (S15):** Power-Ups (100+ combos) = balance nightmare/dead choices; but shipped
  **Mana-per-second**, the **50/50 tank rule**, and anti-drain-tank role fixes.

---

## 12. Genre context (for benchmarking) `[S2]` — verify before quoting

- **Big Three:** TFT (hex grid, interest+streak economy, sets), **HS Battlegrounds** (linear board,
  **resetting** gold, Hero Powers, Triples), **Auto Chess** (8×8 grid, "purity") `[S2 L42-L48]`.
- **Adjacent:** **Mechabellum** (deploy/tech-tree wargame), **Botworld** (RPG hybrid, in-combat
  abilities), **Backpack Battles**/**The Bazaar** (inventory/asynchronous), **Super Auto Pets**
  (minimalist/mobile, Duo co-op), **Mojo Melee** (Web3, group-stage format) `[S2 L52-L104]`.
- `[⚠SRC]` **Market sizing** (USD 2.35B 2025 → 5.0–6.92B 2035; per-platform CAGRs) and the
  **esports prize table** (GEG $500k+, EWC $1M+) read as generic market-report / AI-deep-research
  boilerplate in `[S2]` and are **uncited** — do not cite as fact without primary verification.
- `[⚠SRC]` "**144 champions**" `[S2 L26]` and "**Set 16 unlock system**" `[S1 L46]` are plausible but
  set-version-specific; confirm against the current patch.

---

## 13. Transferable design lessons (interpretation for our prototypes)

> Entirely `[INFERRED]/[ASSUMED]` — my reading for the `Game_Prototypes` repo (esp. the active
> `6_WeaponForge_TFTransistor` TFT-like). Not from any source as "lessons."

1. **Make variance the replay engine, but tier it.** Rare = exciting; ubiquitous = noise; hyper-
   specific = agency-killing. Mirrors `[S1 L88-L89]` good/bad variance.
2. **Economy is the decision spine.** A compounding interest mechanic + win/loss-streak tension
   creates a per-round dilemma cheaper to build than deep combat AI `[S1 L26-L33]`.
3. **Auto-resolve the floor, gate the ceiling.** Let novices auto-position/auto-fight; reserve
   positioning/scouting as the expert skill `[S1 L65]`.
4. **Teach comps structurally**, not via tutorials — shared-trait low-costs + "vertical twins"
   `[S1 L69-L70]`.
5. **Plan a content-reset cadence from day one** — novelty drives re-acquisition (the Mar→Apr MAU
   spike is the proof) `[LIVE] [S1 L135]`.
6. **On mobile, technical polish is a retention feature, not a chore.** TFT's design is loved while
   its 2026 mobile *build* sheds 1★s over crashes/perf — don't let the engine undercut the design
   `[LIVE]`.

---

## 14. Reliability ledger & open questions

**Highest confidence:** core loop, gold economy, star-up, augments/portals, four pillars, GAT/balance
philosophy, set post-mortems, monetization model — all `[S1]`, a well-cited doc. Live launch dates,
ratings, MAU shape, retention shape, and current complaint themes — `[LIVE]`, genuine (US-Android,
modeled where noted).

**Treat as hypotheses / verify:**
- Literal D1–D30 calendar beats (model, not sourced).
- Per-level shop-odds tables; exact ranked tier structure; battle-pass structure (not in corpus).
- `[⚠SRC]` market-size $, esports prizing, "144 champions," "electric/hybrid battler types"
  `[S2 L18]` — low-confidence source claims.
- Retention/MAU absolute values — panel estimates, low provider confidence, US-Android slice only.

**To close the gaps (suggested next pulls):** run `/play-store-reviews` for the full ~2k-row CSV and
iOS reviews; pull `retention`/`active_users` for `both_stores` + more countries; re-pull
`download_revenue_estimates` at monthly granularity; and (Phase-1/2 as originally scoped) scrape the
primary dev-blog/Reddit URLs and analyze the gameplay videos for moment-to-moment VFX/UX that text
sources can't capture.

---

### Source files in this folder
- `Systems Design Analysis of Teamfight Tactics….md` → `[S1]`
- `Strategic Architecture and Market Evolution….md` → `[S2]`
- `TFT_live_appintel_data_2026-06-15.md` → `[LIVE]` data appendix
- `TFT_play_reviews_sample_2026-06-15.csv` → genuine review sample
