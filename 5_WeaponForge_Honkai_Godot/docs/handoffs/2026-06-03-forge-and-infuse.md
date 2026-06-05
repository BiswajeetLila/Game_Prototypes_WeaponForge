# Handoff — 2026-06-03 — Forge & Infuse economy (shards + dupes→star-up)

**Resume from here.** Continues `2026-06-02-session-handoff-game-frame.md`. Branch
`weaponcraft-godot/wittle-inversion-phase1` (NOT merged to main — owner review gate).

## TL;DR

Reworked the gacha economy so **every pull advances the squad and nothing is wasted**,
and made forging a **deep deterministic loop** (no skill/minigame — owner call: never
lose gacha-earned value to reflex). Two **independent progression axes** now exist
(realigned to the locked design spec, which my first plan had conflated):

- **Rarity** Common→Mythic — raised by **Forge Shards** (2 drop per pull, rarity-rolled)
  via the existing `apply_forge_part` ladder. Rarity is a **direct stat multiplier**
  (`[1.0,1.15,1.35,1.6,2.0]`, Mythic = 2× a Common). Spend shards at the armory **Forge**
  button — deterministic, irreversible (confirm dialog), Mythic-capped, never wastes a shard.
- **Star ★1→★10** — raised by **weapon dupes** (re-pulling an owned weapon feeds
  `add_dupe()` star-up on the owned instance, never a 2nd bench copy). Reuses the wired
  `_star_mult` (+5%/★). 3 dupes/★ (flat starting value).

Heroes stay **out of the gacha** (the moat) — gacha is weapon + shard only.
Catalog deepened to **12 weapons** (4/class × C/R/E/L) with rarity-weighted (pyramid) drops.

**10 commits this session, all suites green (~415 tests), pushed.**

## Commits (oldest→newest)
- `5dd8c18` fix(pull): scope Forge Wheel eligibility to the fielded roster (Q1 — "always Bran")
- `76fc237` feat(shards): ShardData + rarity-scaled `apply_forge_shard`
- `19cfd5b` feat(weapon): rarity = direct stat multiplier
- `a0a04da` feat(weapon): dupe → star-up axis (★1-10)
- `9940f27` feat(save): account save v2→v3 + shard inventory + star_progress
- `2a9f34a` feat(pull): drop 2 shards per pull + route dupes to star-up
- `3d861d8` feat(catalog): 12-weapon pool (4/class × C/R/E/L)
- `66afc2e` feat(infuse): deterministic Forge Shard infusion logic
- `f65a337` feat(armory): Forge Shard infuse UI (deterministic, no minigame)

## Q1 bug (root cause, fixed)
Pull pool filtered by `GameState.unlocked_classes`, which only fills as heroes unlock
*mid-combat* — so at Home only bran(warrior) was unlocked → every pull was the warrior
weapon. Now keyed off `GameState.fielded_classes()` (the deployable roster) → pulls span
warrior/mage/rogue from the first pull. Shop's `unlocked_classes` filter untouched.

## Files
- `scripts/data/weapon_data.gd` — `apply_forge_shard` (SHARD_INC by rarity), `rarity_mult()` in get_atk/get_hp, `add_dupe()` + `star_progress`.
- `scripts/data/shard_data.gd` — NEW ShardData (rarity_idx, inert element, is_valid).
- `scripts/core/forge_wheel.gd` — `pull()` rework (weighted pick, dupe→star, 2 shards), `fielded_classes` eligibility.
- `scripts/core/game_state.gd` — `FIELDED_HEROES` + `fielded_classes()`.
- `scripts/core/account_state.gd` — shards inventory, `add_shard(s)`, `infuse()`, SAVE_VERSION=3 (+ v2 loads unwiped).
- `scripts/ui/home_screen.gd` — shard readout + Forge button + confirm dialog + equipped-weapon selection.
- `data/weapons/*.tres` — 9 new (R/E/L × warrior/mage/rogue).
- Tests: `test_shard_data.gd`/`TestShardData.tscn`, `test_infuse.gd`/`TestInfuse.tscn`, + cases in test_weapon_data / test_account_state / test_forge_wheel.

## Test matrix (all green)
Self-quitting: WeaponData 68 · ShardData 7 · Infuse 9 · AccountState 66 · WeaponBridge 27 ·
ForgeWheel 46 · ForgeDraft 26 · SkillCardData 14. Legacy (`--quit-after 400`): Combat 65 ·
Recipes 18 · Shop 26 · Merge 22 · Ui 21. **Stage-1 combat stays neutral** (rarity_mult is
1.0 at Common → rarity-0 fixtures unchanged; TestCombat 65/0).

## Numbers (STARTING VALUES — tune in playtest)
SHARD_INC `[.20,.35,.55,.85]` (C/R/E/L) · DUPES_PER_STAR 3 · rarity_mult `[1,1.15,1.35,1.6,2.0]` ·
weapon-drop pyramid `[50,30,15,5,0]` · shard-rarity odds `55/85/97/100`. 2 shards/pull.

## ⚠️ One un-automated check
The infuse **button-click path** in `home_screen` is wired + Home boots clean headless, but
the literal click → dialog → confirm wasn't UI-automated (infuse *logic* is fully tested via
TestInfuse). **Recommend an interactive F5 playtest:** pull (see a non-Bran weapon + 2 shards),
re-pull a dupe (see ★ progress, no 2nd copy), tap a hero → **Forge** (rarity bar fills, power
jumps), confirm the bank-reset warning never appears in normal play.

## Deferred (NOT built)
Spin cinematic; element-shift infusion (item #2 weak/resist — Shard.element field is ready);
hero Mastery/Slot-Level (play-driven); Mythic hero-bound signatures; separate 150g part-pull;
"forge focus" anti-skew; shard stack cap. Plan file: `~/.claude/plans/resume-weaponforge-go-to-jiggly-plum.md`.

*Closed 2026-06-03. Branch pushed @ `f65a337`. main untouched.*
