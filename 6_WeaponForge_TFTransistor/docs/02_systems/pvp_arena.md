> **HISTORICAL — describes the previous 2_WC craft+collect direction. Superseded 2026-06-12 by the WeaponForge TFTransistor pivot (Function Matrix + 3-lane auto-runner + Magicka reactions). Current SSOT: [`01_GDD.md`](../01_GDD.md). Pivot rationale: [`../superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`](../superpowers/specs/2026-06-12-fork-a-pivot-addendum.md).**

# PvP Arena — Stub

**Status:** Deferred from initial GDD. Roadmap target: **Month 9 post-launch**.

## Scope

Format and mechanics for the optional PvP mode added in the "Beyond Season 2" roadmap window.

## Open design questions

- **Format**: async ghost-data (vs another player's best-run AI clone) vs sync turn-based vs blind-pick draft.
- **Matchmaking**: by power rating, by chapter cleared, or by ladder rank.
- **Reward structure**: separate currency? PvP-exclusive cosmetics? Leaderboard skins?
- **Anti-pay-to-win**: how do we keep PvP balanced without alienating whales who spent on Star-Up?
- **Season reset cadence**: weekly / monthly / per-season.

## Recommended approach

**Async ghost-data**, AFK Arena / Hero Wars style. Lowest engineering cost, no real-time servers needed, plays during commute. Pay-to-win risk is contained because matchmaking can pair similarly-spent players.

## References to consult

- AFK Arena's "Arena of Heroes" (canonical async PvP for this genre).
- Hero Wars' Arena (similar pattern, slightly different reward economy).
- Avoid Clash Royale-style sync PvP (too much engineering overhead for our target audience).
