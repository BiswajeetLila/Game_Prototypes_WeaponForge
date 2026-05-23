# Merge Mechanic — Direction A Addendum

**Date:** 2026-05-23
**Status:** Spec proposal (introduced after BASE-A1 playtest feedback). Pending validation in `BASE-A1_0.1.4`.

---

## Why this entry exists

The original `docs/02_GDD.md` (Part I) documents **only one merge model** under §"Merge mechanics":
> **Parts merge (passive, in stash)**: 3× Common → 1× Rare → Epic → Legendary. Auto-stacks silently. Stash sink + dupe solution.

This is a **rarity-promotion** merge (cross-tier, 3-to-1, passive, invisible). It was inherited from generic casual-mobile dupe-sink patterns (Hero Wars, AFK Arena).

During playtest of `BASE-A1_0.1.3`, user feedback explicitly asked:
> "Buying same thing should merge them automatically with a VFX pop immediately. e.g. if 2 fire runes are bought, it should become 1 lvl 2 fire rune."

This is a **level-up** merge (same-tier, 2-to-1, active, visible-with-VFX). It is the Wittle Defenders / Merge Dragons / Direction-B model. It was NOT in `02_GDD.md` (Part I).

The two models can coexist or one can replace the other. This addendum proposes adopting the level-up merge as the **primary visible** merge mechanic in Direction A, with the rarity-promotion merge **demoted** to a quieter stash-side feature (or cut).

---

## Proposed level-up merge

### Trigger
Whenever a player acquires a part (from shop buy, boss-retry parts-restore, or future scroll reward), check:

1. Is a **same-`partId`** part already equipped on the active hero (universal) or class-matching hero (class-locked)?
2. Otherwise, is a **same-`partId`** part already in the inventory?

If either → instead of placing a fresh L1 part, **level up** the existing part by +1. Spawn a merge VFX pop on the affected slot.

If neither → place fresh L1 normally (auto-equip on buy, else inventory).

### Stat scaling per level
| Level | Stat multiplier | Visual indicator |
|---|---|---|
| L1 | 1.00× | (none — base appearance) |
| L2 | 1.50× | Subtle glow on icon, "L2" badge |
| L3 | 2.10× | Stronger glow, "L3" badge with gold accent |
| L4 | 2.85× | Pulsing glow, "L4" badge with epic-color border |
| L5 (cap) | 3.70× | Animated aura, "MAX" badge |

Stat multiplier scales `atk`, `hp`, `crit`, `ultRate` simultaneously. Tag (element/keyword) is unchanged.

Cap at L5 for prototype. Future: legendary-rarity parts may have a higher cap (L7?) as a power-creep lever.

### Cross-rarity interaction
If the player buys a **Rare Fire Rune** while owning a **Common L2 Fire Rune** — both are `partId: r_fire` but different rarities. Three options:

- **Option X — same-rarity-only merge:** Only same-rarity parts merge. Rare buy makes a fresh L1 Rare. Common L2 stays untouched.
- **Option Y — rarity wins:** Rare absorbs the Common L2 → becomes Rare L1 (no level transfer). Common L2 destroyed. *Bad — loses progress.*
- **Option Z — rarity + level both merge:** Rare absorbs Common L2's level too → Rare L2. Common L2 destroyed.

**Recommendation: X for prototype** (clean rules), revisit later.

### Merge VFX (in 0.1.4)
- Brief sparkle particle burst on the merged slot.
- Level badge animates from L(n) → L(n+1) with scale-pulse.
- Text pop: "MERGED! L(n+1)" in gold.
- Audio: cha-ching (TBD — no audio in prototype yet).

---

## Demotion of the original 3→1 rarity merge

Two options for the older mechanic from `02_GDD.md` (Part I):

- **Demote-and-keep:** rarity-promotion stays as a passive *stash* feature accessed via a separate UI ("Merge Stash" panel). 3 same-name Common parts → 1 Rare. Useful for dupe-sink after many runs.
- **Cut:** remove entirely. Level-up merge is the sole merge model. Cleaner spec.

**Recommendation: Cut for `BASE-A1` scope** (simpler prototype). Re-add as a meta-progression layer in a later prototype if dupe inflation becomes a problem.

---

## Impact on existing spec

### `docs/02_GDD.md` (Part I) § "Merge mechanics" should be updated to read:

> ### Merge mechanics
> - **Part level-up merge (active, visible)**: buying or earning a duplicate `partId` levels up the existing copy (cap L5). Stat multiplier per level: 1.0× / 1.5× / 2.1× / 2.85× / 3.7×. Same-rarity-only — different rarities never cross-merge (each rarity has its own level track).
> - **Merge VFX**: sparkle + badge animation + "MERGED!" text pop on the affected slot.
> - **(Legacy) 3→1 cross-rarity merge**: cut for prototype; may return as a stash-side meta layer post-launch.
> - **Character Star-Up via duplicates**: TFT-style. Pulling a dupe gives shards. X shards → next star tier. (unchanged)

### Console event schema additions

| evt | payload |
|---|---|
| `part_merge` | `{partId, newLevel, source: 'buy' \| 'reward', target: 'inventory' \| 'equipped', heroId?}` |

### Decision rubric additions for playtest

| Pillar | Pass | Fail |
|---|---|---|
| P-merge | ≥3/5 testers verbalize "I want to roll the same part again to level it up" | Testers ignore merges, prefer variety, or feel cheated by losing the duplicate |

---

## Open questions (resolve in playtest)

1. Should merge happen on **acquisition** (auto) or on **player command** (manual via drag-to-anvil)? Auto is simpler, faster — matches Wittle Defenders. Manual is more puzzle-y — matches Direction B prototype.
2. Should merging an equipped part **swap the part back to inventory** while leveling up, or **level in place**? In-place is faster, swap exposes inspectable merge moment.
3. Should reroll cost scale with the number of L2+ parts owned (anti-spam)?
4. Does the L5 cap pace correctly across a 6-wave stage? Will need playtest data.
