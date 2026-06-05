## Test harness for AccountState.infuse() — the DETERMINISTIC Forge Shard infusion.
##
## No skill, no minigame: spending a shard always advances the weapon's rarity bar
## (rarity axis), never the star axis (dupes own that). Mythic-capped; never wastes
## a shard on a failed infuse. Logic-level (headless, no UI nodes).
##
## Run headless (self-quitting, exit code = failure count):
##   Godot_v4.6.2-stable_mono_win64_console.exe --headless --path <godot dir> \
##     res://scenes/dev/TestInfuse.tscn
extends Control

const SCRIPT_PATH := "res://scripts/core/account_state.gd"
const WeaponDataT = preload("res://scripts/data/weapon_data.gd")
const ShardDataT = preload("res://scripts/data/shard_data.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []
var _Account = null

func _ready() -> void:
	_log("=== AccountState.infuse() — deterministic Forge Shard infusion ===")
	_Account = load(SCRIPT_PATH) if ResourceLoader.exists(SCRIPT_PATH) else null
	_check("AccountState script exists", _Account != null, "not found")
	if _Account != null:
		_test_infuse_consumes_shard_and_advances()
		_test_infuse_fills_to_tier_up()
		_test_infuse_no_shards_is_noop()
		_test_infuse_no_weapon_is_noop()
		_test_infuse_mythic_capped_keeps_shard()
		_test_infuse_leaves_star_untouched()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _weapon(rarity: int = 0):
	var w = WeaponDataT.new()
	w.id = &"w_test"; w.cls = &"warrior"; w.base_atk = 20
	w.rarity_idx = rarity
	return w

func _shard(rarity: int = 0):
	var s = ShardDataT.new()
	s.rarity_idx = rarity
	return s

## ---------- Cases ----------

func _test_infuse_consumes_shard_and_advances() -> void:
	var a = _Account.new()
	if not a.has_method(&"infuse"):
		_check("AccountState.infuse() exists", false, "method missing (RED)")
		a.free(); return
	a.owned_weapons = [_weapon(0)]
	a.shards = [_shard(3)]                         ## Legendary shard = big nudge
	var r: Dictionary = a.infuse(0, 0)
	_check("infuse returns ok", r.get("ok") == true, "ok=%s" % r.get("ok"))
	_check("infuse consumes the shard", a.shards.size() == 0, "shards=%d" % a.shards.size())
	_check("infuse advances the rarity bar", a.owned_weapons[0].forge_progress > 0.0,
		"progress=%f" % a.owned_weapons[0].forge_progress)
	a.free()

func _test_infuse_fills_to_tier_up() -> void:
	var a = _Account.new()
	if not a.has_method(&"infuse"):
		a.free(); return
	a.owned_weapons = [_weapon(0)]
	a.shards = [_shard(3), _shard(3)]              ## 0.85 + 0.85 = 1.7 -> tier up on 2nd
	a.infuse(0, 0)
	var r: Dictionary = a.infuse(0, 0)
	_check("infuse tiers up when the bar fills",
		r.get("tier_up") == true and a.owned_weapons[0].rarity_idx == 1,
		"tier_up=%s rarity=%d" % [r.get("tier_up"), a.owned_weapons[0].rarity_idx])
	a.free()

func _test_infuse_no_shards_is_noop() -> void:
	var a = _Account.new()
	if not a.has_method(&"infuse"):
		a.free(); return
	a.owned_weapons = [_weapon(0)]
	a.shards = []
	var r: Dictionary = a.infuse(0, 0)
	_check("infuse with no shards -> ok false", r.get("ok") == false, "ok=%s" % r.get("ok"))
	a.free()

func _test_infuse_no_weapon_is_noop() -> void:
	var a = _Account.new()
	if not a.has_method(&"infuse"):
		a.free(); return
	a.owned_weapons = []
	a.shards = [_shard(0)]
	var r: Dictionary = a.infuse(0, 0)
	_check("infuse with no weapon -> ok false, shard kept",
		r.get("ok") == false and a.shards.size() == 1, "ok=%s shards=%d" % [r.get("ok"), a.shards.size()])
	a.free()

func _test_infuse_mythic_capped_keeps_shard() -> void:
	var a = _Account.new()
	if not a.has_method(&"infuse"):
		a.free(); return
	a.owned_weapons = [_weapon(4)]                 ## Mythic — no tier above
	a.shards = [_shard(0)]
	var r: Dictionary = a.infuse(0, 0)
	_check("infuse on Mythic -> ok false, shard NOT wasted",
		r.get("ok") == false and a.shards.size() == 1, "ok=%s shards=%d" % [r.get("ok"), a.shards.size()])
	a.free()

func _test_infuse_leaves_star_untouched() -> void:
	## Rarity (shards) and star (dupes) are independent axes — infusing must not move ★.
	var a = _Account.new()
	if not a.has_method(&"infuse"):
		a.free(); return
	var w = _weapon(0)
	w.star_tier = 3
	w.star_progress = 1
	a.owned_weapons = [w]
	a.shards = [_shard(3)]
	a.infuse(0, 0)
	_check("infuse changes rarity, never the star axis",
		a.owned_weapons[0].star_tier == 3 and a.owned_weapons[0].star_progress == 1,
		"star=%d progress=%d" % [a.owned_weapons[0].star_tier, a.owned_weapons[0].star_progress])
	a.free()

## ---------- Helpers ----------

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
