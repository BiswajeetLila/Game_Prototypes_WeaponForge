# Economy Restructure + Elara Signature Mission — Design Spec

**Date:** 2026-06-06
**Status:** Design APPROVED by owner (2026-06-06); ready for implementation plan (writing-plans → TDD).
**Branch / worktree:** `weaponcraft-godot/wittle-inversion-phase1` · `.claude/worktrees/pedantic-golick-94f7e8/`
**Project:** `5_WeaponForge_Honkai_Godot/Prototype/godot`
**Supersedes nothing** — extends the locked design (`docs/superpowers/specs/2026-05-27-wittle-inversion-design.md`). Addresses 4 playtest-feedback items.

---

## 1. Context (why)

Playtest feedback + owner direction surfaced four economy/hook problems:

1. **Common dupes feel bad** when you already own an epic/legendary weapon — a dupe just banks ★ progress on a weapon you'll never equip.
2. **Shards are too powerful** in forging — a mained weapon races up the rarity ladder too fast.
3. **Gems do two jobs at once** — they're both earned-from-play AND the gacha-pull currency. Wittle (and Gear Defenders) isolate the gacha currency from the routine play loop. Owner wants gems OUT of pulls, repurposed for forging.
4. **No hero hook** — the locked-roster + hero-bond is the game's moat, but zero hero narrative exists in code. We need ONE hero quest (Elara's), fleshed out and minimally playable, to test the attachment thesis (pre-mortem FM-8).

**Reference-game grounding.** Two competitor studies informed this:
- **Wittle Defender** — gacha currency (gems) is never earned from play; excess summons auto-convert to essence → star-up fuel.
- **Gear Defenders** — ~90% of gacha pulls drop upgrade *materials*, not units (dupes structurally barely exist); simple visible type-advantage combat; and — tellingly — **no hero narrative at all**, retaining purely on a systems treadmill that hits a content cliff. That absence is precisely our differentiator: the Elara bond-quest is the thing GD lacks.

Both reference games converge on the same answer to #1/#3: **a redundant pull becomes upgrade-currency, and the gacha currency is separate from the play-earned upgrade currency.** This spec adopts that, wrapped in our weapon-pull skin (the slot-machine weapon reveal stays the headline).

---

## 2. Goals / Non-goals

**Goals**
- Split currency into three clean buckets: a scarce **pull currency**, play-earned **gems** (forge), and **shards** (forge fuel).
- Kill the common-dupe feel-bad without losing the weapon-pull reveal.
- Slow forging via the fill-speed lever only (rarity power per tier unchanged).
- Ship a minimal, playable **Elara signature mission** that grants a hero-bound Mythic weapon + a bond beat (FM-8 probe).

**Non-goals (explicitly deferred)**
- Spin cinematic, Hot Paladin entry, Catalyst compounds, socket retirement (separate queued items — STATUS §4).
- Full Hero Mastery / Affinity meter (the quest uses simple objective counters, not the 1→100 mastery track).
- Multi-tier portrait art, voiceover, animated cinematics for the quest.
- IAP / premium pricing for the pull currency (prototype earns it through play; monetization later).
- `bound_hero` field on weapons — not needed while Elara is the only mage (mage-class lock already makes the weapon Elara-only). Revisit when a 2nd mage lands.

---

## 3. Currency model (3 buckets)

| Bucket | Currency | Earn | Spend |
|---|---|---|---|
| **Gacha** | **Forge Core** *(placeholder name — see §3.1)* — scarce | boss-clear +1, run-victory +2 (≈3/run) + quest one-offs | Forge Wheel pull |
| **Gettable** | **Gems** (play-earned) | per-wave (keep current earn) + **dupe conversion** | **star-up** (★ any owned weapon) |
| **Gettable** | **Shards** (element-typed) | 2 on common/rare pull, 0 on epic/legendary | **infuse** (rarity bar) — unchanged mechanic |

Clean axis separation (no reconflation): **shards = rarity axis** (RNG, element-typed, `infuse`), **gems = star axis** (deterministic, `star_up`), **Cores = gacha**.

### 3.1 Naming
"Forge Core" is a placeholder approved as a stand-in. ⚠️ "Forge" is already overloaded (Forge Wheel, Forge Shards, Forge Math) — recommend renaming the pull currency to something distinct (**Spark / Ember / Cinder / Anvil Token**) before UI copy is written. Owner to confirm the final name; code uses a single constant/field so a rename is one-line.

### 3.2 Starting numbers (all TUNABLE — Numbers Policy)
| Knob | Value | Note |
|---|---|---|
| Core earn: boss-clear | +1 | |
| Core earn: run-victory | +2 | ≈3 Cores per full cleared run |
| Pull cost | **5 Cores** | ≈1 pull per ~1.7 runs (scarcer than today's 1/run) |
| Starting Cores | 5 | one day-one pull |
| Gem earn | keep current (25/wave, +75 boss, +100 victory) | now funds forge, not pulls |
| Dupe→gems ladder | C 20 / R 40 / E 80 / L 160 | by the pulled weapon's rarity |
| Star-up cost (gems) | `100 × current star_tier` | ★1→2 = 100 … ★9→10 = 900 |
| `SHARD_INC` (after ~50% cut) | `[0.10, 0.175, 0.275, 0.425, 0.425]` | was `[0.20,0.35,0.55,0.85,0.85]` |
| `RARITY_MULT` | `[1.0,1.15,1.35,1.6,2.0]` | **unchanged** |

---

## 4. Mechanic changes

### 4.1 Pull currency (gems → Cores)
- `account_state.gd`: add `var cores: int`, constants `STARTING_CORES`, `CORE_BOSS_BONUS`, `CORE_VICTORY_BONUS`, `PULL_COST_CORES`; `add_cores` / `spend_cores`; signal `cores_changed`. Earn Cores in `_on_wave_cleared` (boss) and `award_victory`.
- `forge_wheel.gd`: `pull()` and `can_pull()` spend/check **Cores** instead of `spend_gems(PULL_COST)`. The legacy gem `PULL_COST` constant is retired from the pull path (keep or delete per cleanup).
- Reveal/HUD: gems label → also show Cores; pull button gated on Cores.

### 4.2 Dupe → gems (the #1 fix); star-up runs on gems
- `forge_wheel.gd` dupe branch (currently `existing.add_dupe()`): instead, **refund gems** = dupe ladder value for `catalog_pick.rarity_idx`, via `AccountState.add_gems(...)`. The weapon-pull reveal still plays; the result reads **"+N gems"** (not "DUPE → ★").
- The pull `result` dict gains `dupe_gems: int`; drop/relabel `star_up`/`dupe_action` on the dupe path. `show_reveal` dupe branch updated to show the gem refund.
- **Star-up becomes a deliberate gem spend:** new `AccountState.star_up(owned_idx) -> Dictionary` — checks gems ≥ `100 × star_tier`, spends, raises `star_tier` (capped at `MAX_STAR_TIER`), autosaves, returns `{ok, before, after, reason}`. Surfaced as a button on the weapon-detail panel.
- `weapon_data.gd`: `add_dupe()` / `DUPES_PER_STAR` / `star_progress` become unused by the pull path. Keep `star_progress` in the save schema for back-compat (loads still work); `add_dupe` may stay as dead code or be removed during cleanup (implementation plan decides; removal must keep the save round-trip intact).

### 4.3 Shard nerf + drop rule (#2)
- `weapon_data.gd`: `SHARD_INC` → `[0.10, 0.175, 0.275, 0.425, 0.425]` (~50% of current). `RARITY_MULT`, `apply_forge_shard`, `_bank`, `infuse` logic all unchanged.
- `forge_wheel.gd` `pull()`: replace the fixed 2-shard mint with a rarity-gated count — **2 shards if `catalog_pick.rarity_idx ≤ 1` (common/rare), else 0.** (Mythic isn't pulled.) This applies to **every** pull, new or dupe (keyed on the pulled weapon's rarity) — so a common dupe yields gems + 2 shards, an epic dupe yields gems + 0 shards. Update the combat-log/reveal "+2 shards" text to reflect the actual count (incl. "no shards" on epic/legendary).

### 4.4 Save migration
- `account_state.gd`: bump `SAVE_VERSION` 3 → **4** (adds `cores` + quest progress). `load_from_dict` accepts v2/v3/v4; absent `cores` → 0 (so a v3 save resumes with 0 Cores and earns up), absent quest block → fresh. Add `cores` + quest dict to `to_save_dict`. Follow the existing validate-then-commit pattern (a malformed quest/cores entry is a load failure; absence is not). `reset_account` zeroes Cores + quest progress.

---

## 5. Elara signature mission (#4)

> 🔄 **REVISED (2026-06-06) → moved to Phase 2.** This section's original "single mission → early Mythic" sketch is **superseded** by the **5-spark escalating chain** (1 mission per ~3 stages; sparks combine Elara's staff → Mythic at spark 5; total effort ≈ any Mythic, so **no early power-spike** — fixes the §3-review balance flag), plus a **3-node micro talent tree** capstone (Meteor → Meteor Shower). Full design = `2026-06-06-progression-economy-architecture.md` §6 (small-B) + §3 (the core-loop deepen that gates it). The Elara slice ships in **Phase 2**, after the Phase-1 economy below; the original sketch is retained here only for context.

**Shape:** single self-contained mission (not a 3-quest chain). **Reward:** both a signature Mythic weapon AND a bond beat. **Scope this round:** design fully + minimal playable slice.

### 5.1 Elara identity (from `data/heroes/elara.tres`)
Mage · curious / scholarly / anime-tsundere · Meteor ult (AoE 1.5× atk + burn). **Element → Fire** (matches meteor/burn) — accepted default.

### 5.2 Trigger
Unlocks after the player deploys Elara **and** clears Stage 1 (so it's not at the absolute FTUE start). Tracked as a one-time unlock flag.

### 5.3 Objectives (one mission, three beats)
1. Win a run with **Elara deployed**.
2. Land Elara's **Meteor ult ×5** (cumulative across runs).
3. Clear a **boss wave with Elara alive** (survives to run victory).

On all three complete → fire the reward + completion dialogue. Progress persists (save v4).

### 5.4 Reward (the hook)
- **Elara's signature Mythic weapon** — a new `WeaponData` `.tres`: `cls = mage`, `rune = fire`, `rarity_idx = 4` (Mythic, 2.0×). **Unpullable** (Mythic drop-weight is already 0) and **mage-locked** (= Elara-only while she's the sole mage) → "earned, not gacha'd." Granted by `AccountState.acquire_weapon(<signature>)`, flagged so it's granted exactly once.
  - Signature effect (minimal): empowers Meteor (e.g. +1 burn stack). Tunable; stat-only acceptable for the slice if the burn hook is non-trivial.
  - Name: placeholder *"Emberscript"* (scholarly + fire) — owner to confirm.
- **Portrait evolution** (one step): swap Elara's portrait to an evolved variant on completion. Art TBD — use a placeholder/tint for the slice.
- **Dialogue beats** (text-only): a start beat and a completion beat.

### 5.5 Narrative spine (≈4 lines, text-only)
Elara is chasing a lost forging-script — "the First Flame." Opens prickly: *"I don't need a babysitter. I'm just… studying your technique."* Warms as you fight alongside her. Completion: *"…Fine. You've earned a look at what I've been forging. Don't make me regret it."* → hands you the weapon. This is the emotional payoff Gear Defenders structurally lacks.

### 5.6 Implementation shape (minimal slice)
- **QuestState** (new singleton or small module): holds the Elara quest definition + progress; persists via AccountState save (v4). Exposes `is_unlocked()`, objective counters, `is_complete()`, `grant_reward()` (idempotent).
- **Objective hooks:**
  - Obj 1 + 3 — listen on run-victory (`AccountState.award_victory` / a GameState victory signal); check Elara in squad / Elara alive (hp > 0).
  - Obj 2 — increment on Meteor ult firing. **Implementation detail to pin:** confirm `Combat.fire_ult` (ult_key `meteor`) emits a signal; add one if absent.
- **Dialogue panel** (new, minimal): a Control with Elara portrait + text + dismiss; shown at unlock and at completion. No branching.
- **Reward grant:** on completion, `grant_reward()` acquires the signature weapon (once), sets the portrait-evolved flag, shows the completion dialogue.

---

## 6. Test plan (TDD — RED→GREEN per increment; global policy)

Write the failing test first for each, watch it fail for the right reason, then implement. Self-quitting dev scenes under `scenes/dev/` + `scripts/dev/`, parsed via the godot MCP (`run_project` → `=== N passed / M failed ===`). **Stage-1 combat must stay exactly neutral — run TestCombat after weapon/economy changes.**

| Increment | New/updated test | RED assertion (pre-impl) |
|---|---|---|
| Cores currency | TestAccountState | `cores` starts at `STARTING_CORES`; boss/victory grant Cores; `spend_cores` guards underflow |
| Pull uses Cores | TestForgeWheel | `can_pull` false with <5 Cores; `pull()` deducts 5 Cores, leaves gems untouched |
| Dupe → gems | TestForgeWheel | duping an owned weapon adds the rarity-ladder gems, does NOT touch `star_tier`/`star_progress`; result carries `dupe_gems` |
| Star-up on gems | TestAccountState / TestWeaponData | `star_up` spends `100×tier`, raises ★, caps at 10, refuses when gems short |
| Shard fill-speed | TestWeaponData / TestInfuse | `apply_forge_shard` advances by the new `SHARD_INC`; tier-up needs ~2× shards vs before |
| Shard drop rule | TestForgeWheel | common/rare pull mints 2 shards; epic/legendary pull mints 0 |
| Save v4 | TestAccountState | round-trip preserves `cores` + quest progress; v2/v3 saves still load (Cores→0, quest fresh); malformed entry rejected |
| Elara quest | new TestElaraQuest | unlock gate (Elara + Stage 1); each objective increments on its hook; completion grants the signature weapon exactly once + sets portrait-evolved flag |

---

## 7. Affected files

**Modify**
- `Prototype/godot/scripts/core/account_state.gd` — Cores, `star_up`, dupe-gems helper, save v4 + quest block.
- `Prototype/godot/scripts/core/forge_wheel.gd` — pull cost in Cores, dupe→gems, rarity-gated shard drop, reveal text.
- `Prototype/godot/scripts/data/weapon_data.gd` — `SHARD_INC` nerf; retire/repurpose `add_dupe`/`DUPES_PER_STAR`.
- HUD / weapon-detail UI (home screen) — Cores display, star-up button. *(path pinned in the implementation plan.)*
- `Combat` ult path — add a Meteor-fired signal if absent.

**Create**
- `Prototype/godot/data/weapons/<elara_signature>.tres` — Elara's Mythic fire mage weapon.
- `data/heroes/elara_evolved` portrait asset (placeholder for slice).
- QuestState module + Elara quest definition.
- Minimal dialogue panel scene/script.
- `scenes/dev/TestElaraQuest.tscn` + `scripts/dev/test_elara_quest.gd`; extend TestAccountState / TestForgeWheel / TestWeaponData / TestInfuse.

---

## 8. Open checkpoints (accepted defaults; flag to change)
1. **Pull-currency name** — placeholder "Forge Core"; recommend a non-"forge" name (Spark/Ember/Cinder). *Owner confirm.*
2. **Elara element = Fire** — accepted default.
3. **Signature weapon name** — placeholder "Emberscript." *Owner confirm.*
4. **All §3.2 numbers** — starting values; tune in playtest.

---

## 9. Sequencing note
This work is independent of the queued FM-8 vertical slice (#2 elemental cards + #3 Hot Paladin) and the later #4 Catalyst / #1 spin cinematic (STATUS §4). It can land before or alongside them. Merge to `main` stays owner-gated.
