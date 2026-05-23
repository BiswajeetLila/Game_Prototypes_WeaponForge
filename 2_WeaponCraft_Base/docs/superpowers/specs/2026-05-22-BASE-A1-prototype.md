# BASE-A1 Prototype — Spec (1-pager)

**Date:** 2026-05-22
**Direction:** A (canonical BASE, per `docs/02_GDD.md` (Part I))
**Status:** v0.1.2 shipped. Single-file HTML/JS at `Prototype/dist/BASE-A1_0.1.2.html`.

## Version history

- `0.1.0` — first build. 3 heroes auto-unlocked; auto-route shop buy; click-anvil unequips destructively.
- `0.1.1` — bug+polish. Fixed `hpBonus` not applied. Added shop tag-badges. Auto-advance after full-kit. Gold start 15→20. Boss HP −25%.
- `0.1.2` — **major flow rewrite + onboarding ramp**:
  - **Shared inventory** — shop buys land in inventory, not auto-equipped. Owned parts persist until manually equipped or discarded.
  - **Click-to-inspect info modal** — shop / inventory / anvil clicks all open an info popup with stats + an explicit action button (Buy / Equip-to-X / Unequip / Discard).
  - **No-destroy unequip** — anvil-click unequip returns part to inventory; swap behavior also moves the old part to inventory.
  - **Roster ramp** — only Bran (Warrior) starts unlocked at wave 1. Elara (Mage) unlocks at wave 3. Vex (Rogue) unlocks at wave 5. Locked heroes show a lock overlay and don't participate in combat.
  - **Wave 1 shop guarantee** — shop is rigged on wave 1 to include at least one Head + Hilt + Rune for the unlocked class set. Prevents starvation.
  - **Shop class filter** — locked-class parts are filtered out of the random pool.
  - **`hero_unlocked` console event** added.

---

## Goal

Validate the core casual-mobile-RPG forge→fight loop from `02_GDD.md` (Part I) with a playable single-stage slice. Stress-test 8 design pillars in one ~1-day build. No meta layer (gacha/BP/AFK deferred).

## Pillars under test (from `02_GDD.md` (Part I))

| ID | Pillar |
|---|---|
| P1 | 3-slot weapons (Head + Hilt + Rune) |
| P2 | TFT-style parts shop with round currency + reroll |
| P3 | Class-affinity auto-routing for class-locked parts; manual for Universal |
| P5 | Single-tap ultimate per hero, gauge fills from damage dealt |
| P6 | Boss with telegraphed affinity + boss-retry-with-reforge |
| P7 | 5–6 wave stage cadence; forge between every wave |
| P8 | 3-hero auto-route under quick decision pressure |
| P10 | Weapons persist + upgrade across waves in-stage |

**Deferred (not in this prototype):**
- P4 (named recipe discovery) → `BASE-A2`
- P9 (persistent meta: gacha, BP, AFK, stamina, codex)
- Star-Up, character mastery, modifier 4th slot, scrap merge

## Scope (what ships in BASE-A1)

### Content
- 3 heroes with **roster ramp**:
  - Wave 1: Warrior (Bran) — only hero unlocked at start.
  - Wave 3: Mage (Elara) unlocks.
  - Wave 5: Rogue (Vex) unlocks.
  - Locked heroes are dimmed with a 🔒 overlay and don't fight.
- 1 stage = 5 normal waves + 1 boss wave (wave 6).
- ~10 parts at launch:
  - **Heads (4):** Iron Edge (Warrior, none), Crystal Orb (Mage, none), Curved Dagger (Rogue, Pierce), Twin Strike (Universal, none)
  - **Hilts (3):** Iron Hilt (Universal, none, +HP), Steel Grip (Warrior, none, +ATK), Leather Grip (Rogue, none, +Crit%)
  - **Runes (3):** Fire Rune (Universal, Fire), Ice Rune (Universal, Ice), Charge Rune (Universal, none, +ult fill)
- 5 procedural enemy types per wave 1–5; 1 telegraphed boss at wave 6.

### Systems
- **Forge moment** between every wave. Shop displays 5 random parts. Player **clicks** a part → info modal with stats + Buy button. Buy → gold deducted, part goes to **inventory** (not auto-equipped). Reroll cost 2🪙. Unbought parts vanish on next wave.
- **3-slot anvil**: Head + Hilt + Rune. Parts equipped by clicking an item in the **inventory strip** → info modal → "Equip → [hero]" button. Class-locked parts only show Equip buttons for matching-class unlocked heroes; Universal parts show all unlocked heroes.
- **Unequip** = click filled anvil slot → info modal → Unequip button → part returns to inventory (never destroyed).
- **Discard** from inventory refunds ⅓ cost.
- **Auto-battle**: side-view, heroes left, monsters right. Auto-attack on weapon stats.
- **Ultimate gauge** fills from damage dealt. Charge Rune accelerates fill. Tap hero portrait to fire single-shot ult once per fight. Time-cap backstop at 30s.
- **Class ultimates:** Warrior = Whirlwind AoE, Mage = Meteor delayed AoE, Rogue = Shadowstep crit-strike.
- **Boss affinity telegraph**: panel shows "Resists: X | Weak to: Y" on boss-wave start.
- **Boss-retry-with-reforge**: on wipe at boss, modal offers `Reforge & Retry` (parts kept) or `Restart Stage`.
- **Weapon persistence**: weapons stay equipped wave-to-wave. Player can swap parts at any forge moment.
- **Currency banks across waves within stage**. Reset between stages (n/a — only 1 stage).

### Excluded
- Merge mechanic (Direction B leftover, not in `02_GDD.md` (Part I))
- Per-run buff draft (Direction B leftover)
- Gem currency / hard-currency revive
- Named recipes / codex
- Procedural element weakness per non-boss wave (boss only has telegraphed affinity)

## Console event schema (instrumentation)

All events logged via `console.log(JSON.stringify({t, evt, payload}))`.

| evt | payload |
|---|---|
| `session_start` | `{stageStartTime, unlockSchedule}` |
| `wave_start` | `{wave, isBoss, bossAffinity?}` |
| `shop_refresh` | `{wave, parts: [...]}` |
| `shop_buy` | `{wave, partId, slotType, costG, uid}` |
| `reroll` | `{wave, costG}` |
| `forge_swap` | `{heroId, slotType, oldPartId, newPartId, fromInventory?, toInventory?, discarded?, refund?}` |
| `wave_start_battle` | `{wave, loadouts: [{heroId, parts}]}` (only unlocked heroes) |
| `ult_tapped` | `{heroId, wave, gaugeAtTap}` |
| `wave_clear` | `{wave, timeMs, heroHpRemaining: [...]}` |
| `hero_unlocked` | `{heroId, wave}` |
| `boss_retry` | `{partsKept}` |
| `wipe` | `{wave, isBoss}` |
| `session_end` | `{reason, lastWave, totalTimeMs?, retries?}` |

## Decision rubric (per pillar pass/fail signal)

| Pillar | Pass | Fail |
|---|---|---|
| P1 3-slot | Forge-time decisions/wave ≥3 swaps; no "too many slots" comments | Slots filled blind, no part swapping |
| P2 shop+reroll | ≥2 rerolls/session avg; testers verbalize "I'm looking for X" | Reroll ignored or universally on every wave |
| P3 auto-route | No "where did that part go?" confusion; manual placements feel deliberate | Heroes get wrong-class parts, players hunt UI |
| P5 ult-tap | ≥3/5 testers fire ult before time-cap; ≥3/5 say it "felt good" | Ult button ignored or "felt unnecessary" |
| P6 boss-retry | ≥3/5 attempt reforge retry instead of restart; ≥2/5 win on retry | Always restart or always lose retry too |
| P7 5+1 cadence | Stage feels ~"just right"; no "too short" or "too long" | Boredom mid-stage or rushed at boss |
| P8 3-hero load | Decision time/wave plateaus by wave 3 | Decision time grows wave-over-wave (overload) |
| P10 persistence | Players upgrade existing weapons ≥50% of forges (vs full rebuild) | Always scrap-and-rebuild, persistence wasted |

## Build approach

Fork `Prototype/dist/Gemini_Weapon_Crafter_0.2.0.html` UI shell. Strip merge anvil + per-run draft modal + gem currency. Keep heroes/squad bar, auto-battle loop, wave structure. Add:
- 3-slot anvil grid
- TFT shop panel (5 parts, buy buttons, reroll button, round-currency counter)
- Ult-gauge bar on each hero card + tap handler
- Boss-affinity telegraph banner
- Boss-retry-with-reforge modal (replaces wipe modal at boss wave only)
- Console instrumentation per schema above

Output path: `2_WeaponCraft_Base/Prototype/dist/BASE-A1_0.1.0.html`.

## Validation protocol

- 5 internal testers, ~30 min each (1 baseline session + 1 free-replay session)
- Think-aloud + OBS screen-record + browser console copy
- Post-session: 6 scripted questions tied to rubric above
- Tally against rubric; survivors graduate to `BASE-A2` (adds named recipes)

## Open questions (resolve during build)

- Currency drop rate per wave clear? (Default: `5 + wave * 2` gold/wave.)
- Part shop prices? (Default: Common 3G, Rare 5G, Epic 8G, Legendary 15G. Only Common+Rare in this prototype.)
- Ult time-cap value? (Default: 30s from wave start.)
- Boss HP scaling vs 5-wave normal HP curve? (Default: boss = 4× wave-5 enemy HP.)
- Wipe-retry attempt cap? (Default: unlimited retries with current parts, but parts pool doesn't refill mid-retry.)
