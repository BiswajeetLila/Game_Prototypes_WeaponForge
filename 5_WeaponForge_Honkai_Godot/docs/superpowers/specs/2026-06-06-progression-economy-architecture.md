# Progression & Economy Architecture (Full-Game Depth Map)

**Date:** 2026-06-06
**Status:** Design draft — owner-directed (2026-06-06). The SSOT for "what the full game is": every progression layer, every currency, the core loop, and how depth is paced.
**Branch / worktree:** `weaponcraft-godot/wittle-inversion-phase1` · `.claude/worktrees/pedantic-golick-94f7e8/`

**Supersedes** `docs/04_economy/currency.md` (a pre-pivot STUB that still listed hero-shards-from-banner, a TFT in-stage shop, and recipe scrolls — all dropped by the Wittle inversion).
**Consolidates** systems scattered across `2026-05-27-wittle-inversion-design.md` (§5 elements, §6 hero progression, §8–12 weapon/forge/draft/synergy, §15–18 outfits/stamina/banner/axes-cap).
**Feeds** `2026-06-06-economy-restructure-elara-quest-design.md` = the **Phase-1 buildable slice** of this architecture.

---

## 1. Why this doc exists

Wittle (~9 currencies) and Gear Defenders (~19) run 10+ stacked progression layers. We had the pieces designed but never mapped them on one page, post-pivot — and the only economy doc (`currency.md`) was a stale stub. This doc maps the **whole iceberg** so we can see the full game, while keeping the **prototype scoped** and the **on-screen complexity casual**.

### 1.1 Design principles (the rails)
1. **Core first.** Layers are retention scaffolding on top of a fun core loop. We prove the core (§3) before stacking depth. More layers ≠ better — GD's complexity is also a churn driver.
2. **Full depth, ≤4 concurrent** (reconciles locked spec §18 "cap at 4 axes"). The full game runs 10+ layers *over its lifetime*; the player only actively juggles **~4 at any one moment**. §18 is re-read as a **concurrent-cognitive-load cap, not a total-systems cap** — exactly how Wittle/GD pace (you never see all 19 currencies on D1).
3. **Drip-feed.** Each layer unlocks at a paced moment (§7 timeline). New layer ⇒ an older one fades to background/passive.
4. **Each layer earns its place** — must add Motivation + stay Clarity-legible (game-design 5-component filter). If it fails either, cut it.
5. **Currency restraint.** Prototype = 3 global currencies + 1 quest token (§5). Sprawl is deferred to live-ops and gated.

---

## 2. Identity recap (so the map stays honest)
Casual-mobile hero-collector. **Gacha pulls WEAPONS** (Forge Wheel). **Heroes are story-unlocked**, never pulled — the moat. Combat = side-view auto-battle squad-of-3, single-tap ults, 5-wave stages (boss W5), procedural boss rotation. Anime-curious audience.

---

## 3. CORE LOOP — the part that decides if it's *fun* (the real risk)

**Honest read:** today we're **lean-back auto-battle + a thin Forge Draft** (spec FM-2 flags "Forge Draft too thin → mid-stage boredom"). GD's love comes from an **active between-wave decision** (the merge puzzle). If our core stays passive, no number of progression layers saves it.

**Direction (owner-approved 2026-06-06): deepen our existing active layers — do NOT graft GD's merge** (wrong fit for pull-weapons/auto-squad). Our two lean-forward layers:

### 3.1 In-run: Forge Draft → boss-reactive synergy draft (Slay-the-Spire-lite)
- Every wave (5 on boss) offer a card pick; cards **interact** (synergies, element procs, ability transforms) and **counter the telegraphed boss element** — not flat stat cards.
- **Clarity:** boss element/weakness is telegraphed *before* the draft, so picks are informed (the StS "see the elite, draft for it" loop).
- **Motivation:** picks are run-scoped build decisions with real tradeoffs (offense vs survive vs element-counter).
- This is queued item #2 (elemental/ability draft cards) — it's not new scope, it's the *core-loop fix*.

### 3.2 Pre-battle: Catalyst → squad build-puzzle
- The 3-hero squad + their elements form **Catalyst pairs** (10 compounds, spec §5). Choosing the squad/loadout vs the upcoming stage's boss = the **build puzzle** (the "deck-building" to the draft's "in-run play").
- Queued item #4.

### 3.3 5-component check on the deepened loop
| Component | Verdict |
|---|---|
| **Clarity** | Strong *if* boss element + card effects are telegraphed pre-pick. **Risk if** cards are vague. |
| **Motivation** | Strong — draft + Catalyst feed the run you're invested in; ties to persistent weapon/hero power. |
| **Response** | Low relevance (auto-battle); the decision points (draft pick, ult tap, squad build) are the inputs. Keep ult-tap responsive. |
| **Satisfaction** | Needs the win to *land* — 2+ feedback channels on a good draft proc / Catalyst trigger / ult. |
| **Fit** | Fits casual + single-tap (lean-back spectacle + light lean-forward brain). No genre change. |

**Lane decision:** casual lean-back core + a *light* lean-forward brain (draft + Catalyst). Not a real-time tactical game. This keeps the broad-casual TAM while answering "is it interesting?".

**Validate (playtest):** does a tester make a *non-obvious* draft pick because of the boss element? Can they articulate a build reason? If picks feel auto-pilot → the draft is still too thin (re-deepen before adding meta layers).

---

## 4. THE FULL LAYER STACK (the iceberg — 15 layers)

Marked: 🟢 prototype · 🔵 v1.0 launch · ⚪ live-ops/post-launch.

```
CORE LOOP  ── auto-battle squad-of-3 + single-tap ult                         🟢
   ├─ [L1]  In-run Forge Draft  (boss-reactive synergy draft, run-scoped)     🟢 (deepen = #2)
   └─ [L2]  Catalyst element-pair build  (pre-battle squad puzzle)            🟢 (=#4)

WEAPON AXIS (gacha + forge)
   ├─ [L3]  Forge Wheel gacha   — pull WEAPONS                                🟢
   ├─ [L4]  Rarity forge        — shards → infuse, C→Mythic                   🟢
   └─ [L5]  Star-up             — gems → ★1–10                                🟢

HERO AXIS (the moat — story, not gacha)
   ├─ [L6]  Hero unlock         — deterministic story/stage progression       🔵
   ├─ [L7]  Slot Level 1→200    — Wittle stat backbone, inherits on swap      🔵
   ├─ [L8]  Hero Mastery/Affinity — bond track → dialogue + portrait evolve   🔵
   ├─ [L9]  Personal quests     — mission chains → First-Flame Sparks →
   │                              signature Mythic weapon + bond              🟢(Elara slice)/🔵(roster)
   └─ [L10] Hero talents/abilities (B) — talent tree + ability transforms,
                                  quest-gated (Cyberpunk-style tiers)         🟢(Elara micro-tree)/⚪(full)

PROGRESSION SUPPORT
   ├─ [L11] Stage campaign      — procedural bosses; Normal→Elite→Nightmare    🟢(Normal)/⚪(tiers)
   ├─ [L12] Stamina/energy      — play gate                                    🔵
   ├─ [L13] Outfits + Prestige skins — capped stat outfit + uncapped cosmetic 🔵/⚪
   ├─ [L14] Battle Pass         — season track                                ⚪
   └─ [L15] Daily/Weekly/Events — engagement + currency faucets               🔵/⚪
```

That's 15 layers — past the "10+" bar — but only the 🟢 set is in the prototype, and §7 paces them so ≤4 are *active* at once.

---

## 5. CURRENCY TABLE (post-pivot, consolidated)

**Prototype currencies (keep lean — 3 global + 1 quest token):**

| Currency | Type | Source | Sink | Stage |
|---|---|---|---|---|
| **Forge Core** *(name TBD — §8)* | Gacha | boss-clear + victory + quest one-offs | Forge Wheel pulls | 🟢 |
| **Gems** | Soft / forge | per-wave + dupe conversion | Star-up (★) | 🟢 |
| **Shards** (element-typed) | Forge fuel | 2 on common/rare pull, 0 on epic/leg | Infuse (rarity) | 🟢 |
| **First-Flame Sparks** | Quest token (per-hero, **NOT a global HUD currency** — shown only in the hero's quest panel) | hero personal-mission beats | combine → signature weapon + unlock talent nodes | 🟢 (Elara) |

**Full-game currencies (live-ops; gated, ≤~4 active concurrently):**

| Currency | Type | Source | Sink | Stage |
|---|---|---|---|---|
| **Slot/Mastery XP** | Hero level | stage clears + AFK idle | Slot Level 1→200 | 🔵 |
| **Talent currency** *(B — name TBD)* | Hero depth | quest milestones + char progression | talent-tree nodes | ⚪ |
| **Stamina** | Gate | time / ad / IAP | stage entry | 🔵 |
| **Premium gems / IAP** | Premium | IAP, login, events | gacha, cosmetics, stamina | 🔵 (monetization) |
| **Battle Pass XP** | Season | quests + clears | BP tiers | ⚪ |
| **Event tokens** | Event | events | event shop | ⚪ |

**Reconciliations / cautions:**
- The spec's "**Forge Rings shards**" (rune re-forge + stamina refill, §16/§18) is a *different* thing from our rarity **Shards** — **defer rune-reforge entirely** to avoid a name+concept collision; if it returns, rename it.
- **Gold** (in the old stub) is **folded into Gems** for the prototype — no separate soft currency until a sink demands it. Avoid GD-style currency sprawl (a documented churn driver).
- Premium "gems" vs our play-earned "gems": when IAP lands, the **premium** currency must be named distinctly from the play-earned forge gems (or rename one). Flag for the monetization pass.

---

## 6. HERO PROGRESSION — B (small now + full later)

The deepened version of locked spec §6 (which only had "per-hero passive at Mastery 50"). B turns hero bond into **power + identity**, the thing GD entirely lacks.

### 6.1 Small-B — the Elara prototype slice (owner: "1 ability-transform, delivered via a micro tree")
- A **3-node micro talent tree** for Elara, nodes unlocked by her spark/quest progression (no separate currency — **quest-gated**, Cyberpunk-style):
  - **Node 1** (early spark): passive — e.g. +burn duration.
  - **Node 2** (mid spark): utility/stat — e.g. Meteor cooldown −10% or +crit.
  - **Node 3 = capstone** (spark 5, with the Mythic staff): **ability transform — Meteor → Meteor Shower** (Aghanim's-style: multi-strike / wider AoE).
- "1 with 2 combined" = **one ability-transform (capstone) carried by a micro tree** (the 2 supporting nodes). Proves bond→power-identity cheaply; forward-compatible with full-B.

### 6.2 Full-B — later (own brainstorm/spec; ⚪ deferred)
- Per-hero **talent trees** (~3 short branches), **tiers gated by quest progression** (can't grind past a gate — the Cyberpunk lock), nodes bought with a **talent currency**.
- **Multiple ability transforms** per hero (HotS-style choose-your-build).
- Keep it **light/curated** for the casual + anime-curious audience — not a sprawling hardcore tree.

---

## 7. CONCURRENT-LOAD PACING (≤4 active axes — reconciles §18)

What the player *actively manages* at each phase (others are not-yet-unlocked or passive background):

| Phase | Active axes (~4 max) | Background / locked |
|---|---|---|
| **FTUE (stage 1–2)** | (1) pull+equip weapon · (2) auto-battle + Forge Draft · (3) stage progress | everything else locked |
| **Early (3–10)** | + (4) weapon forge (shards/star) · Elara quest sparks begin | Catalyst introduced light; Mastery passive |
| **Mid (10+)** | Catalyst build · hero talents (B) · Mastery/affinity · outfits — *older axes (raw pull/forge) become routine/background* | Battle Pass, events |
| **Live-ops** | seasonal: Battle Pass, events, Elite/Nightmare, PvP | — |

**Rule:** introducing a new active axis should let an older one recede (auto-resolve, batch, or "set-and-forget"). Never 5+ novel decisions on screen at once.

---

## 8. Open questions / Numbers-Policy flags
- **Pull-currency name** — "Forge Core" collides with Forge Wheel/Shards/Forge-Draft; recommend Spark/Ember/Cinder. ⚠️ but "Spark" now clashes with **First-Flame Sparks** — pick two distinct names. *Owner decision.*
- **Talent currency (full-B)** — name + source (quest-only vs quest+grind hybrid) TBD.
- **Catalyst depth** — is the 10-compound system legible for casual at ≤4 concurrent? Validate in the #2/#4 build (FM-5 cognitive-load risk).
- **Core-loop validation gates** the rest: if the deepened Forge Draft doesn't test as *interesting* (§3.3 playtest), pause meta-layer expansion and re-deepen.
- All economy numbers live in `2026-06-06-economy-restructure-elara-quest-design.md` §3.2 with test plans.

## 9. Build sequencing (ties to STATUS §4 queue)
1. **Phase 1 — Economy** (the economy-restructure spec): Cores/dupe→gems/shard nerf/star-up/save v4. Ship + playtest.
2. **Phase 2 — Core-loop deepen + Elara slice**: #2 Forge Draft (boss-reactive) → the core-loop fix → then Elara spark-quest + micro talent-tree capstone (small-B). This is the FM-8 *and* FM-2 probe together.
3. **Phase 3+ — Depth** (⚪): Catalyst (#4), full Hero Mastery/affinity, full-B talent trees, outfits, Battle Pass, events, difficulty tiers, PvP.

Merge to `main` stays owner-gated throughout.
