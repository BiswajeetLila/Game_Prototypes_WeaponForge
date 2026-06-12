> **HISTORICAL — describes the previous 2_WC craft+collect direction. Superseded 2026-06-12 by the WeaponForge TFTransistor pivot (Function Matrix + 3-lane auto-runner + Magicka reactions). Current SSOT: [`01_GDD.md`](../01_GDD.md). Pivot rationale: [`../superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`](../superpowers/specs/2026-06-12-fork-a-pivot-addendum.md).**
>
> **⟳ Reconciled 2026-06-12 (hero-squad direction):** Launch currencies cap at **4 — Gold · Gems · Hero Shards · Hero XP**. The 9-currency table below is **superseded**: "Mastery XP" → renamed **Hero XP**; Part Shards, Recipe Scrolls, Battle Pass XP, Tower Coins are NOT launch currencies (fold or defer to live-ops). A 5th (expedition) currency only at the roadmap stage. See [hero-squad spec §5](../superpowers/specs/2026-06-11-hero-squad-meta-design.md).

# Currency Layering — Stub

**Status:** Deferred from initial GDD. To be specified during pre-prototype design refinement.

## Scope

Full currency economy graph. What currencies exist, where they come from, what they're spent on, conversion rates between them.

## Currencies likely needed at launch

| Currency | Source | Spent on |
|---|---|---|
| **Gold** | Stage rewards, AFK idle, daily quests | Shop parts (TFT shop within stage) |
| **Gems** (premium) | IAP, achievement rewards, daily login, occasional events | Gacha pulls, stamina refills, premium shop |
| **Stamina** | Time refill, IAP, ad watch | Stage plays |
| **Hero Shards** | Banner pulls (duplicates), event rewards | Hero Star-Up |
| **Part Shards** | Stage drops, merge dupes | Part rarity merge |
| **Recipe Scrolls** | Boss rewards, premium packs | Codex recipe reveals |
| **Mastery XP** | Stage completion, AFK idle | Hero level + 4th slot unlock |
| **Battle Pass XP** | Quest completion, stage clears | Battle Pass tier progression |
| **Tower Coins** (Season 2) | Endless Tower play | Tower-exclusive cosmetics + scrolls |

## Open design questions

- **Soft cap on hoarding**: do gems expire? Should F2P players be able to bank for 6 months before pulling?
- **Conversion paths**: can players convert excess parts → gold? Excess gold → gems? Avoid bottlenecks.
- **Daily / weekly stamina cap**: how many stages can a maxed-out player play per day? F2P vs whale.
- **Stamina vs ad-refill ratio**: 1 ad = how much stamina? Balance ad fatigue against revenue cannibalization.
- **First-pull pity**: should new players get a softer pity (e.g., guaranteed Epic at pull 10)?

## Recommended approach

**Superseded.** The original "AFK Journey 7–9 currency" recommendation is rejected — locked direction caps launch at **4 currencies** (Gold / Gems / Hero Shards / Hero XP) to avoid Wittle-style "red-dot hell" (~12–14 currencies). Keep clear source+sink per currency; a 5th (expedition) only at live-ops.

## References to consult

- AFK Journey currency map (very well documented on Prydwen.gg).
- Hero Wars economy diagrams.
- Cookie Run: Kingdom (similar gacha + idle hybrid).
