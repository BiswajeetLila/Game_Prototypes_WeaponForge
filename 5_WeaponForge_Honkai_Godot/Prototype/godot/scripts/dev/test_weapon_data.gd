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
