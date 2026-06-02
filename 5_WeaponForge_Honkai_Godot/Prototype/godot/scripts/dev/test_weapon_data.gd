## Test harness for scripts/data/weapon_data.gd — the P1a unitary weapon schema.
##
## P1a migration: weapons become UNITARY named entities (name + class + ability +
## rune element + base_atk/hp + recipe + rarity + star_tier). NO head/hilt/rune
## sockets, NO PartData slot aggregation. Stats come from the weapon itself,
## scaled by star_tier.
##
## Run headless:
##   Godot_v4.6.2-stable_mono_win64_console.exe --headless --path <godot dir> \
##     res://scenes/dev/TestWeaponData.tscn
## Or in-editor: scenes/dev/TestWeaponData.tscn -> Play Scene.
extends Control

const WeaponDataT = preload("res://scripts/data/weapon_data.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== WeaponData (P1a unitary schema) tests ===")
	_test_get_atk_returns_base_atk_unitary()
	_test_star_tier_scales_atk_and_hp()
	_test_forge_part_same_tier_advances_half()
	_test_forge_part_one_tier_higher_upgrades_instantly()
	_test_forge_part_lower_tier_no_progress()
	_test_forge_part_two_tiers_higher_instant_plus_bank()
	_test_forge_part_three_tiers_higher_banks_half_no_instant()
	_test_forge_part_three_tiers_higher_two_parts_reach_target()
	_test_forge_part_four_tiers_higher_banks_third()
	_test_forge_part_four_tiers_higher_three_parts_reach_target()
	_test_forge_bank_retarget_on_different_gap_tier()
	_test_forge_same_tier_after_gap_resets_bank()
	_test_instant_upgrades_set_target_correctly()
	_test_mythic_cap_same_tier_no_overflow()
	_test_out_of_range_part_rejected()
	_test_get_crit_flat()
	_test_get_ult_rate_flat()
	_test_get_all_tags_rune_and_derived()
	_test_get_all_tags_empty_when_plain()
	_test_get_hp_bonus_aliases_get_hp()
	_summary()
	_render_to_ui()
	## Headless auto-quit with exit code = failure count (0 = all green).
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

## ---------- Cases ----------

func _test_get_atk_returns_base_atk_unitary() -> void:
	## The defining P1a behavior: a unitary weapon reports its OWN base_atk,
	## not a sum of socketed parts. ★1 = no star scaling.
	var w = WeaponDataT.new()
	w.base_atk = 120
	w.star_tier = 1
	var got: int = w.get_atk()
	_check("get_atk() returns base_atk at star_tier 1 (unitary, no sockets)",
		got == 120, "expected 120, got %d" % got)

func _test_star_tier_scales_atk_and_hp() -> void:
	## 10-tier star-up: +5% per tier above 1 (spec Q4). ★3 = +10% = 1.10x.
	var w = WeaponDataT.new()
	w.base_atk = 100
	w.base_hp = 200
	w.star_tier = 3
	var atk: int = w.get_atk()
	var hp: int = w.get_hp()
	_check("★3 scales atk 100 -> 110 (+5%/tier)", atk == 110, "got %d" % atk)
	_check("★3 scales hp 200 -> 220 (+5%/tier)", hp == 220, "got %d" % hp)

func _test_forge_part_same_tier_advances_half() -> void:
	## Forge Math: same-rarity part -> +50% progress toward next tier.
	## Common(0) weapon + Common(0) part -> 0.5 progress, still Common.
	var w = WeaponDataT.new()
	w.rarity_idx = 0  ## common
	var upgraded: bool = w.apply_forge_part(0)
	_check("same-tier part: no instant upgrade", upgraded == false, "upgraded=%s" % upgraded)
	_check("same-tier part: progress = 0.5", is_equal_approx(w.forge_progress, 0.5),
		"progress=%f" % w.forge_progress)

func _test_forge_part_one_tier_higher_upgrades_instantly() -> void:
	## Common(0) weapon + Rare(1) part -> instant upgrade to Rare, progress reset.
	var w = WeaponDataT.new()
	w.rarity_idx = 0
	var upgraded: bool = w.apply_forge_part(1)
	_check("one-tier-higher part: instant upgrade", upgraded == true, "upgraded=%s" % upgraded)
	_check("one-tier-higher part: rarity now Rare(1)", w.rarity_idx == 1, "rarity_idx=%d" % w.rarity_idx)
	_check("one-tier-higher part: progress reset to 0", is_equal_approx(w.forge_progress, 0.0),
		"progress=%f" % w.forge_progress)

func _test_forge_part_lower_tier_no_progress() -> void:
	## Epic(2) weapon + Common(0) part -> no contribution (refund-as-essence path).
	var w = WeaponDataT.new()
	w.rarity_idx = 2
	var upgraded: bool = w.apply_forge_part(0)
	_check("lower-tier part: no upgrade", upgraded == false, "upgraded=%s" % upgraded)
	_check("lower-tier part: progress unchanged at 0", is_equal_approx(w.forge_progress, 0.0),
		"progress=%f" % w.forge_progress)

func _test_forge_part_two_tiers_higher_instant_plus_bank() -> void:
	## Forge Math diff==2 (spec §9): Common(0) weapon + Epic(2) part ->
	## instant upgrade STRAIGHT to Epic(2), AND bank 50% toward Legendary(3).
	var w = WeaponDataT.new()
	w.rarity_idx = 0
	var upgraded: bool = w.apply_forge_part(2)
	_check("diff==2 part: upgraded", upgraded == true, "upgraded=%s" % upgraded)
	_check("diff==2 part: instant jump to Epic(2)", w.rarity_idx == 2, "rarity_idx=%d" % w.rarity_idx)
	_check("diff==2 part: 50%% banked toward Legendary(3)", is_equal_approx(w.forge_progress, 0.5),
		"progress=%f" % w.forge_progress)

func _test_forge_part_three_tiers_higher_banks_half_no_instant() -> void:
	## Forge Math diff==3 (spec §9): Common(0) + Legendary(3) part -> NO instant
	## upgrade; bank 50% toward Y(3). Need 2 such parts to reach Y.
	var w = WeaponDataT.new()
	w.rarity_idx = 0
	var upgraded: bool = w.apply_forge_part(3)
	_check("diff==3 part: no instant upgrade", upgraded == false, "upgraded=%s" % upgraded)
	_check("diff==3 part: rarity unchanged (still Common)", w.rarity_idx == 0, "rarity_idx=%d" % w.rarity_idx)
	_check("diff==3 part: 50%% banked", is_equal_approx(w.forge_progress, 0.5), "progress=%f" % w.forge_progress)

func _test_forge_part_three_tiers_higher_two_parts_reach_target() -> void:
	## Forge Math diff==3 x2: two Legendary(3) parts on a Common(0) weapon
	## fill the bank and reach Legendary(3).
	var w = WeaponDataT.new()
	w.rarity_idx = 0
	w.apply_forge_part(3)                       ## 50% banked, still Common
	var upgraded: bool = w.apply_forge_part(3)  ## second part fills -> upgrade
	_check("diff==3 x2: second part upgrades", upgraded == true, "upgraded=%s" % upgraded)
	_check("diff==3 x2: reached Legendary(3)", w.rarity_idx == 3, "rarity_idx=%d" % w.rarity_idx)

func _test_forge_part_four_tiers_higher_banks_third() -> void:
	## Forge Math diff==4 (spec §9): Common(0) + Mythic(4) part -> bank 1/3 toward
	## Y(4), no instant upgrade. Need 3 such parts to reach Y.
	var w = WeaponDataT.new()
	w.rarity_idx = 0
	var upgraded: bool = w.apply_forge_part(4)
	_check("diff==4 part: no instant upgrade", upgraded == false, "upgraded=%s" % upgraded)
	_check("diff==4 part: rarity unchanged", w.rarity_idx == 0, "rarity_idx=%d" % w.rarity_idx)
	_check("diff==4 part: 1/3 banked", is_equal_approx(w.forge_progress, 1.0 / 3.0),
		"progress=%f" % w.forge_progress)

func _test_forge_part_four_tiers_higher_three_parts_reach_target() -> void:
	## Forge Math diff==4 x3: three Mythic(4) parts on a Common(0) weapon
	## fill the bank and reach Mythic(4).
	var w = WeaponDataT.new()
	w.rarity_idx = 0
	w.apply_forge_part(4)                       ## 1/3
	w.apply_forge_part(4)                       ## 2/3
	var upgraded: bool = w.apply_forge_part(4)  ## 3/3 -> upgrade
	_check("diff==4 x3: third part upgrades", upgraded == true, "upgraded=%s" % upgraded)
	_check("diff==4 x3: reached Mythic(4)", w.rarity_idx == 4, "rarity_idx=%d" % w.rarity_idx)

## ---------- Forge bank targeting + rarity cap (codex gate P1 fixes) ----------

func _test_forge_bank_retarget_on_different_gap_tier() -> void:
	## P1: the bank must not mix tiers. Applying a gap part of a DIFFERENT tier than
	## the active bank RESETS the bank to the new tier (harsh rule, documented;
	## UI warning ships with the pull increment). Fill upgrades to the TARGET.
	var w = WeaponDataT.new()
	if not ("forge_target_idx" in w):
		_check("WeaponData has forge_target_idx", false, "property missing (RED)")
		return
	w.rarity_idx = 0
	w.apply_forge_part(4)                       ## 1/3 banked toward Mythic(4)
	_check("gap bank targets Mythic(4)", w.forge_target_idx == 4, "target=%d" % w.forge_target_idx)
	var upgraded: bool = w.apply_forge_part(3)  ## different gap tier -> reset + re-target
	_check("retarget: no upgrade", upgraded == false, "upgraded=%s" % upgraded)
	_check("retarget: progress reset to fresh 0.5 (not 1/3+0.5 contamination)",
		is_equal_approx(w.forge_progress, 0.5), "progress=%f" % w.forge_progress)
	_check("retarget: target now Legendary(3)", w.forge_target_idx == 3, "target=%d" % w.forge_target_idx)
	w.apply_forge_part(3)                       ## second Legendary fills the bank
	_check("fill upgrades to the TARGET tier (3)", w.rarity_idx == 3, "rarity=%d" % w.rarity_idx)

func _test_forge_same_tier_after_gap_resets_bank() -> void:
	## Same single-meter rule applies to diff==0: it banks toward X+1, so arriving
	## while a gap bank is active re-targets and resets. No cross-tier mixing, ever.
	var w = WeaponDataT.new()
	if not ("forge_target_idx" in w):
		_check("WeaponData has forge_target_idx", false, "property missing (RED)")
		return
	w.rarity_idx = 0
	w.apply_forge_part(4)                       ## 1/3 toward Mythic(4)
	w.apply_forge_part(0)                       ## same-tier -> re-target to Rare(1)
	_check("same-tier after gap: progress fresh 0.5", is_equal_approx(w.forge_progress, 0.5),
		"progress=%f" % w.forge_progress)
	_check("same-tier after gap: target Rare(1)", w.forge_target_idx == 1,
		"target=%d" % w.forge_target_idx)
	_check("same-tier after gap: rarity unchanged", w.rarity_idx == 0, "rarity=%d" % w.rarity_idx)

func _test_instant_upgrades_set_target_correctly() -> void:
	var w = WeaponDataT.new()
	if not ("forge_target_idx" in w):
		_check("WeaponData has forge_target_idx", false, "property missing (RED)")
		return
	w.rarity_idx = 0
	w.apply_forge_part(2)                       ## instant Epic(2) + 50% toward Legendary(3)
	_check("diff==2 banks toward Y+1: target Legendary(3)", w.forge_target_idx == 3,
		"target=%d" % w.forge_target_idx)
	var w2 = WeaponDataT.new()
	w2.rarity_idx = 0
	w2.apply_forge_part(1)                      ## instant, no bank
	_check("diff==1 clears target (-1)", w2.forge_target_idx == -1, "target=%d" % w2.forge_target_idx)
	var w3 = WeaponDataT.new()
	w3.rarity_idx = 2
	w3.apply_forge_part(4)                      ## diff==2 straight onto Mythic: no tier above
	_check("diff==2 landing on Mythic: no overflow bank", w3.forge_target_idx == -1 and w3.rarity_idx == 4,
		"target=%d rarity=%d" % [w3.forge_target_idx, w3.rarity_idx])

func _test_mythic_cap_same_tier_no_overflow() -> void:
	## P1: rarity must never exceed Mythic(4). Same-tier parts at the cap contribute
	## nothing (caller refunds as essence, same as the lower-tier path).
	var w = WeaponDataT.new()
	w.rarity_idx = 4
	var first: bool = w.apply_forge_part(4)
	var second: bool = w.apply_forge_part(4)
	_check("mythic+mythic: first is a no-op", first == false, "returned %s" % first)
	_check("mythic+mythic: no progress banked", is_equal_approx(w.forge_progress, 0.0),
		"progress=%f" % w.forge_progress)
	_check("mythic+mythic: second is a no-op", second == false, "returned %s" % second)
	_check("rarity capped at Mythic(4)", w.rarity_idx == 4, "rarity=%d" % w.rarity_idx)

func _test_out_of_range_part_rejected() -> void:
	## P1: part_idx outside the 0..4 ladder is rejected with state untouched.
	var w = WeaponDataT.new()
	w.rarity_idx = 0
	var ok: bool = w.apply_forge_part(5)
	_check("part_idx 5 rejected", ok == false, "returned %s" % ok)
	_check("part_idx 5: no progress banked", is_equal_approx(w.forge_progress, 0.0),
		"progress=%f" % w.forge_progress)
	_check("part_idx 5: rarity unchanged", w.rarity_idx == 0, "rarity=%d" % w.rarity_idx)

## ---------- Combat-interface accessors (Stage 1: make WeaponData a drop-in for the
## legacy socket weapon's combat surface; combat.gd reads these four off hero.weapon) ----------

func _test_get_crit_flat() -> void:
	## crit% is a flat weapon property — NOT star-scaled (legacy crit came from parts,
	## not star-up; scaling crit% would inflate it absurdly).
	var w = WeaponDataT.new()
	if not w.has_method(&"get_crit"):
		_check("WeaponData has get_crit()", false, "method missing (RED)")
		return
	w.base_crit = 15
	w.star_tier = 5
	_check("get_crit() returns flat base_crit (no star scaling)", w.get_crit() == 15,
		"got %d" % w.get_crit())

func _test_get_ult_rate_flat() -> void:
	var w = WeaponDataT.new()
	if not w.has_method(&"get_ult_rate"):
		_check("WeaponData has get_ult_rate()", false, "method missing (RED)")
		return
	w.base_ult_rate = 20
	w.star_tier = 5
	_check("get_ult_rate() returns flat base_ult_rate (no star scaling)", w.get_ult_rate() == 20,
		"got %d" % w.get_ult_rate())

func _test_get_all_tags_rune_and_derived() -> void:
	## Mirrors legacy Weapon.get_all_tags(): explicit element tag (the baked rune) plus
	## derived "crit" (any crit%) and "charge" (any ult_rate%).
	var w = WeaponDataT.new()
	if not w.has_method(&"get_all_tags"):
		_check("WeaponData has get_all_tags()", false, "method missing (RED)")
		return
	w.rune = &"fire"
	w.base_crit = 10
	w.base_ult_rate = 5
	var tags: Array = w.get_all_tags()
	_check("get_all_tags has rune element 'fire'", &"fire" in tags, "tags=%s" % str(tags))
	_check("get_all_tags derives 'crit' from crit%%", &"crit" in tags, "tags=%s" % str(tags))
	_check("get_all_tags derives 'charge' from ult_rate%%", &"charge" in tags, "tags=%s" % str(tags))
	_check("get_all_tags size == 3 (rune+crit+charge)", tags.size() == 3, "tags=%s" % str(tags))

func _test_get_all_tags_empty_when_plain() -> void:
	## No rune, no crit, no ult_rate -> no tags.
	var w = WeaponDataT.new()
	if not w.has_method(&"get_all_tags"):
		_check("WeaponData has get_all_tags()", false, "method missing (RED)")
		return
	_check("plain weapon: get_all_tags empty", w.get_all_tags().is_empty(),
		"tags=%s" % str(w.get_all_tags()))

func _test_get_hp_bonus_aliases_get_hp() -> void:
	## HeroState.refresh_max_hp() calls weapon.get_hp_bonus(); expose it as an alias of
	## get_hp() so WeaponData drops into the legacy hp-bonus call site unchanged.
	var w = WeaponDataT.new()
	if not w.has_method(&"get_hp_bonus"):
		_check("WeaponData has get_hp_bonus()", false, "method missing (RED)")
		return
	w.base_hp = 200
	w.star_tier = 3
	_check("get_hp_bonus() == 220 (★3 of 200)", w.get_hp_bonus() == 220, "got %d" % w.get_hp_bonus())
	_check("get_hp_bonus() aliases get_hp()", w.get_hp_bonus() == w.get_hp(),
		"bonus=%d hp=%d" % [w.get_hp_bonus(), w.get_hp()])

## ---------- Test helpers ----------

func _check(name: String, ok: bool, detail: String) -> void:
	if ok:
		_passed += 1
		_log("  PASS  " + name)
	else:
		_failed += 1
		_log("  FAIL  " + name + (("  [" + detail + "]") if detail != "" else ""))

func _summary() -> void:
	_log("=== %d passed / %d failed ===" % [_passed, _failed])

func _log(line: String) -> void:
	print(line)
	_lines.append(line)

func _render_to_ui() -> void:
	var label := Label.new()
	label.add_theme_font_size_override(&"font_size", 12)
	label.text = "\n".join(_lines)
	label.anchor_right = 1.0
	label.anchor_bottom = 1.0
	label.offset_left = 12
	label.offset_top = 12
	add_child(label)
