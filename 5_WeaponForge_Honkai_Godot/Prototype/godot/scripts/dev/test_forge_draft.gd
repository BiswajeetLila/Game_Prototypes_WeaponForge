## Test harness for the ForgeDraft service (R2 — Wittle-style post-wave perk pick).
##
## deal(n=3) -> n SkillCardData, AXIS-DISTINCT (each card a different stat axis:
## atk_flat / atk_pct / crit / ult_rate / hp_flat — fake choice = same axis twice),
## each tagged to an unlocked hero. apply(card) -> writes the effect into the
## tagged hero's run_mods (R1) and returns true; invalid card -> false, no change.
## Card values are Numbers-Policy starting values (see forge_draft.gd header).
##
## Run headless:
##   Godot_v4.6.2-stable_mono_win64_console.exe --headless --path <godot dir> \
##     res://scenes/dev/TestForgeDraft.tscn
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== ForgeDraft service (R2) tests ===")
	if get_node_or_null("/root/ForgeDraft") == null:
		_check("ForgeDraft autoload registered", false, "missing (RED)")
	else:
		_test_deal_three_axis_distinct_valid()
		_test_deal_five_for_boss()
		_test_deal_repeats_stay_axis_distinct()
		_test_apply_atk_card()
		_test_apply_hp_card_no_heal()
		_test_apply_invalid_rejected()
		_test_kill_meter_fills_and_signals()
		_test_kill_meter_overflow_banks()
		_test_kill_meter_wave_baseline_reset()
		_test_kill_meter_run_reset()
		_test_apply_increments_hero_card_count()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _draft():
	return get_node("/root/ForgeDraft")

func _fresh():
	GameState.new_session()
	return GameState.get_hero(&"bran")

func _axes_of(cards: Array) -> Array:
	var axes: Array = []
	for c in cards:
		axes.append(c.effect.keys()[0])
	return axes

## ---------- Deal ----------

func _test_deal_three_axis_distinct_valid() -> void:
	_fresh()
	var cards: Array = _draft().deal()
	_check("deal() returns 3 cards", cards.size() == 3, "size=%d" % cards.size())
	var ok_valid: bool = true
	var ok_hero: bool = true
	for c in cards:
		if not c.is_valid():
			ok_valid = false
		if not GameState.heroes.has(c.hero_id):
			ok_hero = false
	_check("all cards valid (id+type+hero tag)", ok_valid, "invalid card present")
	_check("all cards tagged to unlocked heroes", ok_hero, "unknown hero tag")
	var axes: Array = _axes_of(cards)
	var uniq: Dictionary = {}
	for a in axes:
		uniq[a] = true
	_check("3 distinct stat axes (no fake choice)", uniq.size() == 3, "axes=%s" % str(axes))

func _test_deal_five_for_boss() -> void:
	_fresh()
	var cards: Array = _draft().deal(5)
	_check("deal(5) returns 5 cards (boss draft)", cards.size() == 5, "size=%d" % cards.size())
	var uniq: Dictionary = {}
	for a in _axes_of(cards):
		uniq[a] = true
	_check("boss draft: 5 distinct axes", uniq.size() == 5, "axes=%s" % str(_axes_of(cards)))

func _test_deal_repeats_stay_axis_distinct() -> void:
	_fresh()
	var always_distinct: bool = true
	for i in range(10):
		var cards: Array = _draft().deal()
		var uniq: Dictionary = {}
		for a in _axes_of(cards):
			uniq[a] = true
		if uniq.size() != 3:
			always_distinct = false
			break
	_check("10 deals, every hand axis-distinct", always_distinct, "duplicate axis hand")

## ---------- Apply ----------

func _test_apply_atk_card() -> void:
	var h = _fresh()
	var card = _draft().make_card(&"atk_flat", &"bran")
	var amount: int = int(card.effect[&"atk_flat"])
	var before: int = h.eff_atk()
	var ok: bool = _draft().apply(card)
	_check("apply atk_flat card returns true", ok, "false")
	_check("eff_atk rose by the card amount", h.eff_atk() == before + amount,
		"eff=%d want %d" % [h.eff_atk(), before + amount])

func _test_apply_hp_card_no_heal() -> void:
	var h = _fresh()
	h.hp = 50
	var card = _draft().make_card(&"hp_flat", &"bran")
	var amount: int = int(card.effect[&"hp_flat"])
	var max_before: int = h.max_hp
	var ok: bool = _draft().apply(card)
	_check("apply hp card returns true", ok, "false")
	_check("max rose by card amount", h.max_hp == max_before + amount,
		"max=%d want %d" % [h.max_hp, max_before + amount])
	_check("current hp untouched (no heal)", h.hp == 50, "hp=%d" % h.hp)

func _test_apply_invalid_rejected() -> void:
	var h = _fresh()
	var before: int = h.eff_atk()
	_check("apply(null) rejected", _draft().apply(null) == false, "accepted null")
	var junk = _draft().make_card(&"atk_flat", &"nobody_home")
	_check("card tagged to unknown hero rejected", _draft().apply(junk) == false, "accepted")
	_check("rejected applies change nothing", h.eff_atk() == before, "eff=%d" % h.eff_atk())

## ---------- Kill meter (W1 — Wittle-style: ~5 kills fill the bar -> draft) ----------

var _meter_changed_count: int = 0
var _meter_full_count: int = 0

func _on_meter_changed(_k: int, _n: int) -> void:
	_meter_changed_count += 1

func _on_meter_full() -> void:
	_meter_full_count += 1

func _meter_guard() -> bool:
	if not _draft().has_method(&"sync_dead_count"):
		_check("ForgeDraft has kill meter (sync_dead_count)", false, "method missing (RED)")
		return false
	return true

func _test_kill_meter_fills_and_signals() -> void:
	if not _meter_guard():
		return
	var d = _draft()
	d.reset_run()
	_meter_changed_count = 0
	_meter_full_count = 0
	d.meter_changed.connect(_on_meter_changed)
	d.meter_full.connect(_on_meter_full)
	d.sync_dead_count(2)                       ## 2 enemies died this wave
	_check("2 kills -> meter 2", d.meter_kills == 2, "meter=%d" % d.meter_kills)
	_check("meter_changed fired", _meter_changed_count == 1, "count=%d" % _meter_changed_count)
	_check("not full at 2/5", _meter_full_count == 0, "full fired early")
	d.sync_dead_count(2)                       ## same dead count -> no new kills
	_check("repeat sync adds nothing", d.meter_kills == 2, "meter=%d" % d.meter_kills)
	d.sync_dead_count(5)                       ## 3 more kills -> 5 total
	_check("5 kills -> full fired once", _meter_full_count == 1 and d.meter_kills == 5,
		"full=%d meter=%d" % [_meter_full_count, d.meter_kills])
	d.meter_changed.disconnect(_on_meter_changed)
	d.meter_full.disconnect(_on_meter_full)

func _test_kill_meter_overflow_banks() -> void:
	if not _meter_guard():
		return
	var d = _draft()
	d.reset_run()
	d.sync_dead_count(6)                       ## burst: 6 kills at once
	_check("burst counts all kills", d.meter_kills == 6, "meter=%d" % d.meter_kills)
	d.consume_draft()
	_check("consume banks the overflow kill", d.meter_kills == 1, "meter=%d" % d.meter_kills)

func _test_kill_meter_wave_baseline_reset() -> void:
	if not _meter_guard():
		return
	var d = _draft()
	d.reset_run()
	d.sync_dead_count(3)                       ## wave A: 3 dead
	d.reset_wave_baseline()                    ## wave B spawns (dead count starts over)
	d.sync_dead_count(2)                       ## wave B: 2 dead
	_check("kills accumulate across waves (3+2)", d.meter_kills == 5, "meter=%d" % d.meter_kills)

func _test_kill_meter_run_reset() -> void:
	if not _meter_guard():
		return
	var d = _draft()
	d.reset_run()
	d.sync_dead_count(4)
	d.reset_run()
	_check("run reset zeroes the meter", d.meter_kills == 0, "meter=%d" % d.meter_kills)
	d.sync_dead_count(1)
	_check("baseline also reset with the run", d.meter_kills == 1, "meter=%d" % d.meter_kills)

func _test_apply_increments_hero_card_count() -> void:
	var h = _fresh()
	if not ("run_card_count" in h):
		_check("HeroState has run_card_count", false, "property missing (RED)")
		return
	_draft().apply(_draft().make_card(&"atk_flat", &"bran"))
	_draft().apply(_draft().make_card(&"crit", &"bran"))
	_check("two applied cards -> run_card_count 2 (pips)", h.run_card_count == 2,
		"count=%d" % h.run_card_count)

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
