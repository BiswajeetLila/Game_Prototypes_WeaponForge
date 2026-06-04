## Test harness for scripts/data/shard_data.gd — the Forge Shard upgrade item.
##
## Shards are the consumable rarity-forge fuel dropped by gacha pulls (2/pull).
## A shard carries its own rarity (Common..Legendary); bigger rarity = bigger forge
## increment (applied via WeaponData.apply_forge_shard). v1: `element` is stored but
## INERT — reserved for the deferred element-shift infusion.
##
## Run headless (self-quitting, exit code = failure count):
##   Godot_v4.6.2-stable_mono_win64_console.exe --headless --path <godot dir> \
##     res://scenes/dev/TestShardData.tscn
extends Control

const ShardDataT = preload("res://scripts/data/shard_data.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== ShardData (Forge Shard) tests ===")
	_test_defaults()
	_test_is_valid()
	_test_duplicate_is_independent()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

## ---------- Cases ----------

func _test_defaults() -> void:
	var s = ShardDataT.new()
	_check("default rarity_idx is 0 (Common)", s.rarity_idx == 0, "got %d" % s.rarity_idx)
	_check("default element is empty (inert in v1)", s.element == &"", "got '%s'" % str(s.element))
	_check("default id is forge_shard", s.id == &"forge_shard", "got '%s'" % str(s.id))

func _test_is_valid() -> void:
	var probe = ShardDataT.new()
	if not probe.has_method("is_valid"):
		_check("ShardData.is_valid() exists", false, "method missing (RED)")
		return
	var all_ok: bool = true
	for r in range(0, 5):
		var s = ShardDataT.new()
		s.rarity_idx = r
		if not s.is_valid():
			all_ok = false
	_check("is_valid() true for rarity 0..4", all_ok, "a valid rarity was rejected")
	var lo = ShardDataT.new(); lo.rarity_idx = -1
	var hi = ShardDataT.new(); hi.rarity_idx = 5
	_check("is_valid() false for rarity -1", not lo.is_valid(), "accepted -1")
	_check("is_valid() false for rarity 5", not hi.is_valid(), "accepted 5")

func _test_duplicate_is_independent() -> void:
	var a = ShardDataT.new()
	a.rarity_idx = 2
	var b = a.duplicate(true)
	b.rarity_idx = 4
	_check("duplicate(true) is an independent instance",
		a.rarity_idx == 2 and b.rarity_idx == 4, "a=%d b=%d" % [a.rarity_idx, b.rarity_idx])

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
