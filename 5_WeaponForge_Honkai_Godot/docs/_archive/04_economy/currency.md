# Currency Layering — Stub

> ⚠️ **SUPERSEDED (2026-06-06).** This stub is **pre-pivot** (it lists hero-shards-from-banner, a TFT in-stage shop, and recipe scrolls — all dropped by the Wittle inversion). The current, consolidated currency + progression map is:
> **`docs/superpowers/specs/2026-06-06-progression-economy-architecture.md`** (§5 currency table).
> Kept only for historical reference. Do not design from this file.

**Status:** SUPERSEDED — see the architecture doc above. (Originally: deferred from initial GDD.)

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

Lean toward the **AFK Journey currency model** — 7–9 active currencies, clear sources/sinks for each, occasional event-only currencies that don't dilute the main economy.

## References to consult

- AFK Journey currency map (very well documented on Prydwen.gg).
- Hero Wars economy diagrams.
- Cookie Run: Kingdom (similar gacha + idle hybrid).
