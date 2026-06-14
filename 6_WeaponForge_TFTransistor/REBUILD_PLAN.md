# Forge/Shop Rebuild — execution tracker (2026-06-14)

Branch: `weaponforge-tftransistor/real-asset-pass`. From workflow audit `wf_974e1bb8-259`.
Behavior-level TDD per step (RED→GREEN). Test runner: headless `Test*.tscn`, exit = fail count.

## Locked decisions
1. **Universal Transistor slots** — any Function in any slot; fix distinction via shown per-slot behavior + best-fit tag, NOT restriction.
2. **Socket order PASSIVE | MODIFIER | ACTIVE** — canonical data index `0=PASSIVE, 1=MODIFIER, 2=ACTIVE` (flipped from old `0=ACTIVE`). Visual L→R = ascending index.
3. **Real ShopV2 economy** — data-driven costs, buy deducts+removes+merges, reroll costs gold, pity.

## Deviations from spec (user-expectation, flagged)
- Reroll at forge break = re-roll unbought visible slots for 1g (spec §11.2 says pending-only → dead at forge break).
- Gold income = per-kill 1g accrual (was flat +3/forge break).

## DATA 1 — gold cost: `cost = ceil(T1_BASE[stage] * TIER_MULT[tier-1])`
`T1_BASE_BY_STAGE=[1,1,2,2,3]` (idx=current_stage 0-4) · `TIER_MULT=[1.0,1.4,2.0,2.8,4.0]` · `REROLL_COST=1` · start gold 7. Slice = T1 only.

## DATA 2 — per-slot behavior (slice fns; BOUNCE=Phase5, no .tres) — for FunctionData desc strings + best_fit
| Fn | ACTIVE | MODIFIER | PASSIVE | best_fit |
|---|---|---|---|---|
| FIRE | own-lane closest ×1.0, applies Burning | +20% dmg, adds FIRE tag | forge_aura: allies +10% vs Burning/Chilled | ACTIVE |
| WATER | cross-lane spread ×0.5, applies Wet | adds WATER tag + Wet | tidepool: every 4t Wet a front enemy | MODIFIER |
| LIGHTNING | chain own+arc1 @50%, Shocked both | +25% dmg, LIGHTNING tag, +20% self-miss | static_charge: every 5t 1dmg+Shocked closest | ACTIVE |
| AOE | radial ≤5 ×0.7 | Active→radial, status spreads | concussion_aura: every 6t blast+stagger | MODIFIER |
| LEECH | melee ×0.6, heals self 50% | Active hits heal 25% | lifelink: +1HP/t but DISABLES attacks | PASSIVE |
| BURST | 3-fan ×0.45 (×1.35) | Active→3-fan, 3 reactions | rapid_fire: atk speed +40% | MODIFIER |

## Steps / commits
- [ ] **C1** socket index flip P|M|A — forge_panel SOCKET_LABELS + loadout doc + grep combat/element_mediator for socket-0=active assumptions. (commit 1)
- [ ] **C2** ShopV2 economy core: cost_for, roll_items (T1-only, pity), buy(), reroll() contracts. (commit 2 w/ C4)
- [ ] **C4** pity wiring + per-stage element tracking. (commit 2)
- [ ] **C3** main_v2 buy/reroll wiring: deduct gold, clear slot, equip/merge-stub "2/2", forge-break-gated, per-kill gold. (commit 3)
- [ ] **C5** FunctionData +active_desc/mod_desc/passive_desc/best_fit + describe(slot) + populate 6 .tres. (commit 4)
- [ ] **C6** forge socket cards: 64px, icon+name+tier stars+merge label+empty watermark. (commit 5 w/ C7)
- [ ] **C7** shop cards: icon+name+cost+tier; footer reroll-cost + START NEXT WAVE moved into footer (kills overlap). (commit 5)
- [ ] **C8** function preview panel (3 rows P/M/A) + best-fit badge on shop tap. (commit 6)
- [ ] **C9** phase-adaptive layout `_apply_layout(state)` + child set_compact(); COMBAT battle 0.06-0.66 / FORGE battle 0.06-0.32; pause-bug fix (_paused flag). (commit 7)
- [ ] **C10** battle status chips + numeric HP + reaction labels + real hero HP into forge. (commit 8)
- [ ] **C11** AUTOSHOT QC both states + full green sweep. (commit 9)

## API changes (default-compatible)
- `loadout_v2.apply_drop(loadout, idx, id, tier=1, allow_merge=true)` — slice passes `allow_merge=false` for "2/2" stub.
- `forge_panel_v2.set_socket_fn(hero, sock, fn_id, tier=1, display_name="", merge_pending="")`.
