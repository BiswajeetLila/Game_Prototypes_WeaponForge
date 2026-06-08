# Economy Restructure (Ember + gems→forge) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Split the currency: a new scarce **Ember** drives gacha pulls (gems no longer pull); gems become the forge/star-up currency; dupes convert to gems; shards are nerfed; saves migrate v3→v4.

**Architecture:** Additive changes to the meta layer (`AccountState`) + the pull service (`ForgeWheel`) + the weapon stat model (`WeaponData`) + the Home UI. Combat is untouched. Each task is independent + TDD'd against the existing self-quitting dev suites.

**Tech Stack:** Godot 4.6.2 Mono, GDScript. Spec: `docs/superpowers/specs/2026-06-06-economy-restructure-elara-quest-design.md` (Phase-1 economy; the Elara mission §5 is OUT of scope — later Phase 2).

**Conventions:**
- Worktree `C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\.claude\worktrees\pedantic-golick-94f7e8`; branch `weaponcraft-godot/wittle-inversion-phase1`; Godot project `5_WeaponForge_Honkai_Godot/Prototype/godot`. Commit per task; **do NOT push** (owner-gated).
- **Run a test:** `mcp__godot__run_project(projectPath=<godot dir>, scene="res://scenes/dev/TestX.tscn")` → `get_debug_output` (find `=== N passed / M failed ===`) → `stop_project`. Self-quitting suites (TestAccountState/TestForgeWheel/TestWeaponData/TestInfuse) end on their own; legacy TestCombat may not (stop it after the summary).
- ⚠️ **Stage-1 combat stays neutral; keep TestCombat green.** This plan doesn't touch combat, but run TestCombat once at the end as a guard.
- Autoloads referenced globally: `GameState`, `AccountState`, `ForgeWheel`, `Combat`. Dev-test harness shape: copy `scripts/dev/test_account_state.gd` / `test_forge_wheel.gd`.
- Commit footer: `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`.

**Locked numbers (Numbers Policy starting values):** Ember: start 5, boss-clear +1, victory +2, pull cost 5. Dupe→gems ladder `[20, 40, 80, 160, 320]` (by rarity 0-4). Star-up gem cost `100 × current star_tier`. `SHARD_INC` halved → `[0.10, 0.175, 0.275, 0.425, 0.425]`. Shard drop: 2 on common/rare pull (rarity_idx ≤ 1), else 0.

---

### Task 1: Shard fill-speed nerf (`SHARD_INC` halved)

**Files:** Modify `Prototype/godot/scripts/data/weapon_data.gd` · Test `scripts/dev/test_weapon_data.gd` (or TestInfuse)

- [ ] **Step 1: Write the failing test.** Append to `scripts/dev/test_weapon_data.gd`'s `_ready()` (before its summary call) a call to `_test_shard_inc_nerfed()`, and add:
```gdscript
func _test_shard_inc_nerfed() -> void:
	var w = WeaponData.new()           ## common (rarity_idx 0), forge_target -1
	## A single COMMON shard now banks 0.10 toward Rare (was 0.20). No tier-up yet.
	var up: bool = w.apply_forge_shard(0)
	_check("common shard banks 0.10 (nerfed)", absf(w.forge_progress - 0.10) < 0.0001 and not up,
		"progress=%f up=%s" % [w.forge_progress, str(up)])
	## 10 common shards reach Rare (was 5).
	for _i in range(9):
		w.apply_forge_shard(0)
	_check("10 common shards -> Rare (rarity_idx 1)", w.rarity_idx == 1, "rarity=%d" % w.rarity_idx)
```
(Use the same `_check`/`_log`/`_summary` harness already in that file.)

- [ ] **Step 2: Run — verify FAIL.** Run `TestWeaponData.tscn`. Expected: the new check fails (common shard still banks 0.20 → progress 0.20, and 5 shards already tiered up).

- [ ] **Step 3: Implement.** In `weapon_data.gd`, change:
```gdscript
const SHARD_INC: Array = [0.20, 0.35, 0.55, 0.85, 0.85]
```
to:
```gdscript
const SHARD_INC: Array = [0.10, 0.175, 0.275, 0.425, 0.425]   ## halved (Numbers Policy: slower rarity forge)
```

- [ ] **Step 4: Run — verify PASS.** Run `TestWeaponData.tscn` → all green. Also run `TestInfuse.tscn` → green (its tier-up tests may assert shard counts; if a test hard-coded "N shards → tier up" on the OLD increments, update that count to the new `SHARD_INC` and note it).

- [ ] **Step 5: Commit.**
```
git -C "<worktree>" add 5_WeaponForge_Honkai_Godot/Prototype/godot/scripts/data/weapon_data.gd 5_WeaponForge_Honkai_Godot/Prototype/godot/scripts/dev/test_weapon_data.gd
# + test_infuse.gd if you updated a shard-count assertion
git -C "<worktree>" commit -m "balance(forge): halve SHARD_INC (shards ~2x slower to tier up)" -m "Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 2: Shard drop-rule (2 on common/rare pull, 0 on epic/legendary)

**Files:** Modify `Prototype/godot/scripts/core/forge_wheel.gd` · Test `scripts/dev/test_forge_wheel.gd`

- [ ] **Step 1: Write the failing test.** Add to `test_forge_wheel.gd`'s `_ready()` a call to `_test_shard_drop_by_rarity()`, and add:
```gdscript
func _test_shard_drop_by_rarity() -> void:
	## Mint helper is private; assert via the public pull() result over many pulls:
	## every pull's shard count is 2 (common/rare weapon) or 0 (epic/legendary).
	GameState.new_session()
	var ok: bool = true
	for _i in range(40):
		var r: Dictionary = ForgeWheel.pull()
		if r.is_empty():
			AccountState.add_ember(50)   ## keep affording pulls
			continue
		var n: int = (r.get("shards", []) as Array).size()
		var rarity: int = r["weapon"].rarity_idx
		var expected: int = 2 if rarity <= 1 else 0
		if n != expected:
			ok = false
	_check("shard drop = 2 (common/rare) / 0 (epic+)", ok, "wrong shard count for rarity")
```
(If `ForgeWheel.pull` still costs gems at this point, give the account gems instead; this test is ordered before Task 4, so adapt the "keep affording" line to whatever pull currently spends. Simplest: call `AccountState.add_gems(500)` before the loop.)

- [ ] **Step 2: Run — verify FAIL** (`TestForgeWheel.tscn`): epic/legendary pulls still mint 2 shards.

- [ ] **Step 3: Implement.** In `forge_wheel.gd` `pull()`, find:
```gdscript
	## Every pull also drops 2 Forge Shards (the no-waste net): rarity-rolled,
	## carrying the pulled weapon's element.
	var drops: Array = [_mint_shard(catalog_pick.rune), _mint_shard(catalog_pick.rune)]
	AccountState.add_shards(drops)
```
replace with:
```gdscript
	## Shard consolation: 2 shards on a low-rarity pull (common/rare), 0 on epic+.
	## (Spoils for a "meh" pull; high-rarity pulls are their own reward.)
	var drops: Array = []
	if catalog_pick.rarity_idx <= 1:
		drops = [_mint_shard(catalog_pick.rune), _mint_shard(catalog_pick.rune)]
		AccountState.add_shards(drops)
```

- [ ] **Step 4: Run — verify PASS** (`TestForgeWheel.tscn`). If any existing test asserted "every pull drops 2 shards", update it to the rarity rule.

- [ ] **Step 5: Commit.**
```
git -C "<worktree>" add 5_WeaponForge_Honkai_Godot/Prototype/godot/scripts/core/forge_wheel.gd 5_WeaponForge_Honkai_Godot/Prototype/godot/scripts/dev/test_forge_wheel.gd
git -C "<worktree>" commit -m "balance(forge): shards drop 2 on common/rare pull, 0 on epic+" -m "Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 3: Ember currency + save v4

**Files:** Modify `Prototype/godot/scripts/core/account_state.gd` · Test `scripts/dev/test_account_state.gd`

- [ ] **Step 1: Write the failing test.** Add to `test_account_state.gd`'s `_ready()` calls to `_test_ember_basics()` and `_test_ember_save_roundtrip()`, and add:
```gdscript
func _test_ember_basics() -> void:
	AccountState.reset_account()
	_check("ember starts at STARTING_EMBER", AccountState.ember == AccountState.STARTING_EMBER,
		"ember=%d" % AccountState.ember)
	AccountState.add_ember(3)
	_check("add_ember raises ember", AccountState.ember == AccountState.STARTING_EMBER + 3, "ember=%d" % AccountState.ember)
	var ok: bool = AccountState.spend_ember(2)
	_check("spend_ember within balance returns true", ok and AccountState.ember == AccountState.STARTING_EMBER + 1, "ember=%d" % AccountState.ember)
	_check("spend_ember over balance returns false", AccountState.spend_ember(9999) == false, "overspent")

func _test_ember_save_roundtrip() -> void:
	AccountState.reset_account()
	AccountState.add_ember(7)
	var d: Dictionary = AccountState.to_save_dict()
	_check("save dict version is 4", int(d.get("version", -1)) == 4, "ver=%s" % str(d.get("version")))
	_check("save dict carries ember", int(d.get("ember", -1)) == AccountState.ember, "ember=%s" % str(d.get("ember")))
	## v3 save (no ember key) still loads, ember defaults to 0.
	var v3: Dictionary = {"version": 3, "gems": 100, "stage": 1, "weapons": [], "equipped": {}, "shards": []}
	_check("v3 save loads", AccountState.load_from_dict(v3) == true, "v3 rejected")
	_check("absent ember -> 0", AccountState.ember == 0, "ember=%d" % AccountState.ember)
```

- [ ] **Step 2: Run — verify FAIL** (`TestAccountState.tscn`): `ember`/`STARTING_EMBER`/`add_ember`/`spend_ember` don't exist; version is 3.

- [ ] **Step 3: Implement.** In `account_state.gd`:

(a) Bump the version const:
```gdscript
const SAVE_VERSION: int = 3   ## v3 adds the shard inventory + star_progress (v2 saves still load)
```
→
```gdscript
const SAVE_VERSION: int = 4   ## v4 adds the Ember pull-currency (v2/v3 saves still load; ember -> 0)
```

(b) After the gem/pull consts (the `const PULL_COST: int = 300` line), add:
```gdscript
## Ember — the scarce GACHA currency (pulls cost Ember; gems no longer pull).
## Earned only from boss clears + run victory (NOT per wave) -> savored pulls.
const STARTING_EMBER: int = 5
const EMBER_BOSS_BONUS: int = 1
const EMBER_VICTORY_BONUS: int = 2
const PULL_COST_EMBER: int = 5
```

(c) After `var gems: int = STARTING_GEMS`, add:
```gdscript
var ember: int = STARTING_EMBER
```

(d) After the `signal shards_changed` line, add:
```gdscript
signal ember_changed(new_ember: int)
```

(e) Next to `add_gems`/`spend_gems`, add:
```gdscript
func add_ember(amount: int) -> void:
	ember += amount
	ember_changed.emit(ember)

func spend_ember(amount: int) -> bool:
	if ember < amount:
		return false
	ember -= amount
	ember_changed.emit(ember)
	return true
```

(f) In `_on_wave_cleared`, after `add_gems(amount)` add an Ember boss reward:
```gdscript
func _on_wave_cleared(wave: int) -> void:
	var amount: int = GEMS_PER_WAVE
	if wave in GameState.BOSS_WAVES:
		amount += GEMS_BOSS_BONUS
		add_ember(EMBER_BOSS_BONUS)
	add_gems(amount)
	autosave()
```

(g) In `award_victory`, add the Ember victory reward:
```gdscript
func award_victory() -> void:
	add_gems(RUN_VICTORY_BONUS)
	add_ember(EMBER_VICTORY_BONUS)
	autosave()
```

(h) In `reset_account`, after `gems = STARTING_GEMS` add `ember = STARTING_EMBER` and after `gems_changed.emit(gems)` add `ember_changed.emit(ember)`.

(i) In `to_save_dict`, add `ember` to the returned dict:
```gdscript
	return {"version": SAVE_VERSION, "gems": gems, "stage": current_stage,
		"ember": ember, "weapons": ws, "equipped": eq, "shards": ss}
```

(j) In `load_from_dict`, widen the accepted versions:
```gdscript
	if ver != 2 and ver != 3:                         ## accept v2 (pre-shard) + current v3
		return false
```
→
```gdscript
	if ver < 2 or ver > 4:                             ## accept v2 (pre-shard) / v3 / v4 (ember)
		return false
```
and in the commit section (after `gems = int(d["gems"])`), add:
```gdscript
	ember = int(d.get("ember", 0))                     ## absent in v2/v3 -> 0
```
and after `gems_changed.emit(gems)` add `ember_changed.emit(ember)`.

- [ ] **Step 4: Run — verify PASS** (`TestAccountState.tscn`). Existing save round-trip tests should still pass (they don't assert version==3 unless one does — if so, update it to 4).

- [ ] **Step 5: Commit.**
```
git -C "<worktree>" add 5_WeaponForge_Honkai_Godot/Prototype/godot/scripts/core/account_state.gd 5_WeaponForge_Honkai_Godot/Prototype/godot/scripts/dev/test_account_state.gd
git -C "<worktree>" commit -m "feat(economy): add Ember currency (boss/victory earn) + save v4 (back-compat)" -m "Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 4: Pulls cost Ember (gems no longer pull)

**Files:** Modify `Prototype/godot/scripts/core/forge_wheel.gd` · Test `scripts/dev/test_forge_wheel.gd`

- [ ] **Step 1: Write the failing test.** Add to `test_forge_wheel.gd` a call to `_test_pull_spends_ember()`:
```gdscript
func _test_pull_spends_ember() -> void:
	GameState.new_session()
	AccountState.reset_account()
	AccountState.add_ember(100)
	var gems_before: int = AccountState.gems
	var ember_before: int = AccountState.ember
	var r: Dictionary = ForgeWheel.pull()
	_check("pull succeeds with Ember", not r.is_empty(), "empty pull")
	_check("pull deducts PULL_COST_EMBER ember", AccountState.ember == ember_before - AccountState.PULL_COST_EMBER,
		"ember=%d" % AccountState.ember)
	_check("pull leaves gems untouched", AccountState.gems == gems_before, "gems=%d" % AccountState.gems)
	## With 0 ember, cannot pull.
	AccountState.spend_ember(AccountState.ember)
	_check("can_pull false at 0 ember", ForgeWheel.can_pull() == false, "can_pull true at 0")
```

- [ ] **Step 2: Run — verify FAIL**: pull still spends gems (gems drop, ember unchanged).

- [ ] **Step 3: Implement.** In `forge_wheel.gd`:

(a) `can_pull`:
```gdscript
func can_pull() -> bool:
	return AccountState.gems >= AccountState.PULL_COST and not eligible_weapons().is_empty()
```
→
```gdscript
func can_pull() -> bool:
	return AccountState.ember >= AccountState.PULL_COST_EMBER and not eligible_weapons().is_empty()
```

(b) In `pull()`, the spend guard:
```gdscript
	if not AccountState.spend_gems(AccountState.PULL_COST):
		return {}
```
→
```gdscript
	if not AccountState.spend_ember(AccountState.PULL_COST_EMBER):
		return {}
```

- [ ] **Step 4: Run — verify PASS** (`TestForgeWheel.tscn`). Update any existing pull test that pre-seeded gems to afford a pull → pre-seed `add_ember(...)` instead (e.g. the happy-path + insufficient-currency tests).

- [ ] **Step 5: Commit.**
```
git -C "<worktree>" add 5_WeaponForge_Honkai_Godot/Prototype/godot/scripts/core/forge_wheel.gd 5_WeaponForge_Honkai_Godot/Prototype/godot/scripts/dev/test_forge_wheel.gd
git -C "<worktree>" commit -m "feat(economy): Forge Wheel pulls cost Ember (gems no longer pull)" -m "Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 5: Dupe → gems (rarity-scaled)

**Files:** Modify `Prototype/godot/scripts/core/forge_wheel.gd` · Test `scripts/dev/test_forge_wheel.gd`

- [ ] **Step 1: Write the failing test.** Add `_test_dupe_awards_gems()`:
```gdscript
func _test_dupe_awards_gems() -> void:
	GameState.new_session()
	AccountState.reset_account()
	AccountState.add_ember(100)
	## Pull until we own something, then force a dupe of that exact weapon.
	var first: Dictionary = ForgeWheel.pull()
	var owned = first["weapon"]
	var star_before: int = owned.star_tier
	var prog_before: int = owned.star_progress
	var gems_before: int = AccountState.gems
	## Force a dupe: pull again until the same id comes up (or assert via a direct dupe path
	## if your pull exposes one). Simplest deterministic check: the LADDER value is awarded.
	var ladder: Array = ForgeWheel.DUPE_GEMS
	var expected_gain: int = ladder[clampi(owned.rarity_idx, 0, ladder.size() - 1)]
	## Re-pull the same weapon by exhausting eligible variety is non-deterministic; instead
	## assert the ladder constant exists + the dupe branch awards it (see impl) by pulling
	## ~30 times and confirming gems only ever increase by ladder values on dupes.
	var ok_gain: bool = true
	for _i in range(30):
		if AccountState.ember < AccountState.PULL_COST_EMBER:
			AccountState.add_ember(50)
		var g0: int = AccountState.gems
		var r: Dictionary = ForgeWheel.pull()
		if r.get("dupe", false):
			var rar: int = r["weapon"].rarity_idx
			if AccountState.gems - g0 != ladder[clampi(rar, 0, ladder.size() - 1)]:
				ok_gain = false
			if r.get("star_up", false) or r["weapon"].star_progress != 0:
				pass   ## star untouched check below
	_check("DUPE_GEMS ladder exists (5 entries)", ladder.size() == 5, "ladder=%s" % str(ladder))
	_check("dupe awards exactly the rarity-ladder gems", ok_gain, "wrong dupe gem award")
```

- [ ] **Step 2: Run — verify FAIL**: `ForgeWheel.DUPE_GEMS` doesn't exist; dupes currently call `add_dupe` (star), award no gems.

- [ ] **Step 3: Implement.** In `forge_wheel.gd`:

(a) Add the ladder const near `WEAPON_DROP_WEIGHT`:
```gdscript
## Dupe consolation: a duplicate pull mints gems (the forge currency) by the
## pulled weapon's rarity, instead of feeding star progress. C/R/E/L/M.
const DUPE_GEMS: Array = [20, 40, 80, 160, 320]
```

(b) Replace the dupe branch:
```gdscript
	if dupe:
		owned = existing
		star_up = existing.add_dupe()
		dupe_action = "star_up"
	else:
```
with:
```gdscript
	var dupe_gems: int = 0
	if dupe:
		owned = existing
		dupe_gems = DUPE_GEMS[clampi(catalog_pick.rarity_idx, 0, DUPE_GEMS.size() - 1)]
		AccountState.add_gems(dupe_gems)
		dupe_action = "gems"
	else:
```
(`star_up` stays declared above as `false`; it's now always false on the dupe path. Leave the `result` dict's `star_up` key for back-compat, and ADD `dupe_gems`.)

(c) In the `result` dict, add the new key:
```gdscript
		"dupe_gems": dupe_gems,
```

(d) Update the dupe combat-log line (it referenced star-up):
```gdscript
	if dupe:
		var tail: String = ("★%d!" % owned.star_tier) if star_up else "★ progress"
		GameState.append_combat_log("[color=66ddff]⚒ Forge Wheel: %s DUPE → %s  (+2 shards)[/color]"
			% [owned.name, tail])
```
→
```gdscript
	if dupe:
		GameState.append_combat_log("[color=66ddff]⚒ Forge Wheel: %s DUPE → +%d gems[/color]"
			% [owned.name, dupe_gems])
```

- [ ] **Step 4: Run — verify PASS** (`TestForgeWheel.tscn`). If an existing test asserted "dupe feeds star_up", update it: dupe now awards `DUPE_GEMS[rarity]` and leaves `star_tier`/`star_progress` unchanged.

- [ ] **Step 5: Commit.**
```
git -C "<worktree>" add 5_WeaponForge_Honkai_Godot/Prototype/godot/scripts/core/forge_wheel.gd 5_WeaponForge_Honkai_Godot/Prototype/godot/scripts/dev/test_forge_wheel.gd
git -C "<worktree>" commit -m "feat(economy): dupe pulls award rarity-scaled gems (no longer star-up)" -m "Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 6: Star-up is a gem spend (`AccountState.star_up`)

**Files:** Modify `Prototype/godot/scripts/core/account_state.gd` · Test `scripts/dev/test_account_state.gd`

- [ ] **Step 1: Write the failing test.** Add `_test_star_up_spends_gems()`:
```gdscript
func _test_star_up_spends_gems() -> void:
	AccountState.reset_account()
	var w = GameState.weapons_by_id.values()[0].duplicate(true)
	w.star_tier = 1
	AccountState.owned_weapons = [w]
	AccountState.gems = 1000
	var r: Dictionary = AccountState.star_up(0)
	_check("star_up ok", r.get("ok", false), "reason=%s" % str(r.get("reason")))
	_check("star_up cost = 100 * old tier (100)", int(r.get("cost", -1)) == 100, "cost=%s" % str(r.get("cost")))
	_check("star raised to 2", w.star_tier == 2, "tier=%d" % w.star_tier)
	_check("gems spent", AccountState.gems == 900, "gems=%d" % AccountState.gems)
	## Refuses when gems short.
	AccountState.gems = 10
	var r2: Dictionary = AccountState.star_up(0)
	_check("star_up refused when gems short", r2.get("ok", true) == false and r2.get("reason") == "no_gems", "r2=%s" % str(r2))
	## Caps at MAX_STAR_TIER.
	w.star_tier = w.MAX_STAR_TIER
	AccountState.gems = 100000
	_check("star_up refused at max", AccountState.star_up(0).get("reason") == "max_star", "not capped")
```

- [ ] **Step 2: Run — verify FAIL**: `AccountState.star_up` doesn't exist.

- [ ] **Step 3: Implement.** In `account_state.gd`, add the const near the economy consts:
```gdscript
const STAR_GEM_BASE: int = 100   ## gems to raise a weapon one ★ = STAR_GEM_BASE * current star_tier
```
and add the method (near `infuse`):
```gdscript
## Deterministic star-up: spend gems to raise a weapon's ★ tier (the gem sink that
## replaces dupe-banking). Cost = STAR_GEM_BASE * current star_tier. Returns
## {ok, cost, star, reason}.
func star_up(owned_idx: int) -> Dictionary:
	if owned_idx < 0 or owned_idx >= owned_weapons.size():
		return {"ok": false, "reason": "no_weapon"}
	var w = owned_weapons[owned_idx]
	if w.star_tier >= w.MAX_STAR_TIER:
		return {"ok": false, "reason": "max_star"}
	var cost: int = STAR_GEM_BASE * w.star_tier
	if gems < cost:
		return {"ok": false, "reason": "no_gems", "cost": cost}
	spend_gems(cost)
	w.star_tier += 1
	owned_weapons_changed.emit()
	autosave()
	return {"ok": true, "cost": cost, "star": w.star_tier}
```

- [ ] **Step 4: Run — verify PASS** (`TestAccountState.tscn`).

- [ ] **Step 5: Commit.**
```
git -C "<worktree>" add 5_WeaponForge_Honkai_Godot/Prototype/godot/scripts/core/account_state.gd 5_WeaponForge_Honkai_Godot/Prototype/godot/scripts/dev/test_account_state.gd
git -C "<worktree>" commit -m "feat(economy): star-up via gem spend (100 x current tier)" -m "Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 7: Home UI — Ember display, pull cost, gems=forge, star-up button, dupe reveal

**Files:** Modify `Prototype/godot/scripts/ui/home_screen.gd` + `scripts/core/forge_wheel.gd` (reveal text). Manual verify via godot MCP.

- [ ] **Step 1: Ember + pull-cost in `home_screen._refresh`.** Find:
```gdscript
	_gems_label.text = "💎 %d gems   ·   🏰 Stage %d" % [AccountState.gems, AccountState.current_stage]
	_battle_btn.text = "⚔ START BATTLE — STAGE %d" % AccountState.current_stage
	var broke: bool = AccountState.gems < AccountState.PULL_COST
	_pull_btn.disabled = broke
	_pull_btn.text = ("⚒ FORGE WHEEL — need 300💎 (clear waves to earn!)" if broke
		else "⚒ FORGE WHEEL — PULL WEAPON (300💎)")
```
replace with:
```gdscript
	_gems_label.text = "🔥 %d Ember   ·   💎 %d gems (forge)   ·   🏰 Stage %d" % [
		AccountState.ember, AccountState.gems, AccountState.current_stage]
	_battle_btn.text = "⚔ START BATTLE — STAGE %d" % AccountState.current_stage
	var broke: bool = AccountState.ember < AccountState.PULL_COST_EMBER
	_pull_btn.disabled = broke
	_pull_btn.text = ("⚒ FORGE WHEEL — need %d🔥 Ember (boss/victory earns it!)" % AccountState.PULL_COST_EMBER if broke
		else "⚒ FORGE WHEEL — PULL WEAPON (%d🔥 Ember)" % AccountState.PULL_COST_EMBER)
```

- [ ] **Step 2: Subscribe to `ember_changed`.** In `home_screen._ready()`, next to the existing `AccountState.gems_changed.connect(...)` line, add:
```gdscript
	AccountState.ember_changed.connect(func(_e): _refresh())
```

- [ ] **Step 3: Add a Star-up button** in `_rebuild_detail_actions(w)`, after the Forge button is added (and before the Unequip block). Insert:
```gdscript
	var star := Button.new()
	star.custom_minimum_size = Vector2(0, 34)
	star.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var maxed_star: bool = w.star_tier >= w.MAX_STAR_TIER
	var cost: int = AccountState.STAR_GEM_BASE * w.star_tier
	star.disabled = maxed_star or AccountState.gems < cost
	star.text = ("★ Max" if maxed_star else "★ Star-up (%d💎)" % cost)
	star.pressed.connect(_on_star_up_pressed)
	_detail_actions.add_child(star)
```
and add the handler near `_on_infuse_pressed`:
```gdscript
func _on_star_up_pressed() -> void:
	if _selected_idx < 0 or _selected_idx >= AccountState.owned_weapons.size():
		return
	var r: Dictionary = AccountState.star_up(_selected_idx)
	if r.get("ok", false):
		_flash_detail(Color(1.0, 0.85, 0.3))
	_refresh()
```

- [ ] **Step 4: Fix the dupe reveal text** in `forge_wheel.gd` `show_reveal` — the dupe branch currently shows star-up. Find:
```gdscript
		if bool(result.get("star_up", false)):
			_reveal_delta.text = "★ STAR UP → ★%d   ·   +%d shards" % [w.star_tier, n_shards]
		else:
			_reveal_delta.text = "★ progress banked   ·   +%d shards" % n_shards
```
replace with:
```gdscript
		_reveal_delta.text = "+%d gems   ·   +%d shards" % [int(result.get("dupe_gems", 0)), n_shards]
```
(Also update the dupe title from "DUPE!" if you like — optional; leave it.)

- [ ] **Step 5: Verify (godot MCP).** `run_project(scene="res://scenes/Home.tscn")` → `get_debug_output`: confirm Home loads with **no script errors**, the top line shows "🔥 N Ember · 💎 N gems (forge)", and the pull button reads "PULL WEAPON (5🔥 Ember)". `stop_project`. (Tap-through — pulling, the dupe "+gems" reveal, the star-up button — is an owner manual check; your bar is "loads clean + labels correct".)

- [ ] **Step 6: Commit.**
```
git -C "<worktree>" add 5_WeaponForge_Honkai_Godot/Prototype/godot/scripts/ui/home_screen.gd 5_WeaponForge_Honkai_Godot/Prototype/godot/scripts/core/forge_wheel.gd
git -C "<worktree>" commit -m "feat(economy): Home shows Ember + forge gems, star-up button, dupe=+gems reveal" -m "Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 8: Full-suite guard

- [ ] **Step 1: Run all self-quitting suites** (`TestWeaponData`, `TestInfuse`, `TestShardData`, `TestForgeWheel`, `TestAccountState`, `TestHomeScreen` if present, `TestStageAffinity`) via godot MCP. Each must report `0 failed`.
- [ ] **Step 2: Run `TestCombat`** (the stage-1-neutral contract — unaffected by economy, but guard it). Expect `65 passed / 0 failed`.
- [ ] **Step 3:** If all green, no commit needed (verification only). If a suite needed a fixture update you didn't already commit with its task, commit it now with `test: update fixtures for Ember/dupe-gems economy`.

---

## Self-review

**Spec coverage (`2026-06-06-economy-restructure-elara-quest-design.md`, Phase-1 economy only):**
- §3 Ember pull currency (scarce, boss/victory earn) → Task 3 + Task 4. ✅
- §3/§4.2 gems→forge, dupe→gems ladder, star-up=gem spend → Task 5 + Task 6 + Task 7. ✅
- §4.3 shard fill-speed nerf + 2/0 drop-rule → Task 1 + Task 2. ✅
- §4.4 save v3→v4 (+ember, back-compat) → Task 3. ✅
- UI surfacing (Ember/forge labels, star-up, dupe reveal) → Task 7. ✅
- §5 Elara mission → **OUT of scope** (Phase 2), intentionally excluded. ✅
- Counter-build interplay: none — combat untouched; the shard drop rule is on the pull path only.

**Placeholder scan:** Task 5's test notes a non-deterministic dupe-forcing caveat but provides a concrete over-N-pulls assertion + the ladder-constant check — no "TODO". All edits show exact old→new. No vague steps.

**Type consistency:** `ember`/`STARTING_EMBER`/`PULL_COST_EMBER`/`EMBER_BOSS_BONUS`/`EMBER_VICTORY_BONUS`/`add_ember`/`spend_ember`/`ember_changed` used consistently across Tasks 3/4/7. `DUPE_GEMS` (Task 5) + `STAR_GEM_BASE`/`star_up` (Task 6) used in Task 7's UI. Save key `"ember"` consistent (Task 3). `SHARD_INC` halved values consistent (Task 1).

**Ordering note:** Task 2's test pulls before Task 4 lands (pull still costs gems) — its "keep affording" line says to seed gems pre-Task-4; after Task 4 it seeds Ember. Flagged in the task. Tasks are otherwise independent and committable in order.
