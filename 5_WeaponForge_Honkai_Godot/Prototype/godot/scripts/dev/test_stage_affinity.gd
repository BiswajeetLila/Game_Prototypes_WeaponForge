## Test harness for StageAffinity — deterministic per-stage element affinities.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

const FTUE: Array = [&"fire", &"ice", &"electric", &"wind"]

func _ready() -> void:
	_log("=== StageAffinity tests ===")
	_test_in_element_set()
	_test_deterministic()
	_test_stage1_mirrors_boss()
	_test_stage2plus_spread()
	_test_conflict_rate()
	_test_combat_minions_use_affinity()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_in_element_set() -> void:
	var ok: bool = true
	for n in range(1, 31):
		var a: Dictionary = StageAffinity.affinity_for(n)
		if not (a[&"minion_weak"] in FTUE) or not (a[&"minion_resist"] in FTUE):
			ok = false
			break
	_check("minion tags always in the 4-element set", ok, "off-set tag found")

func _test_deterministic() -> void:
	var a1: Dictionary = StageAffinity.minion_affinity(7)
	var a2: Dictionary = StageAffinity.minion_affinity(7)
	_check("same stage -> same affinity", a1 == a2, "non-deterministic")

func _test_stage1_mirrors_boss() -> void:
	var a: Dictionary = StageAffinity.affinity_for(1)
	_check("stage 1 minion_weak == boss_weak (teaching)", a[&"minion_weak"] == a[&"boss_weak"],
		"mw=%s bw=%s" % [a[&"minion_weak"], a[&"boss_weak"]])
	_check("stage 1 minion_resist == boss_resist", a[&"minion_resist"] == a[&"boss_resist"],
		"mr=%s br=%s" % [a[&"minion_resist"], a[&"boss_resist"]])

func _test_stage2plus_spread() -> void:
	var ok: bool = true
	for n in range(2, 31):
		var a: Dictionary = StageAffinity.affinity_for(n)
		if a[&"minion_weak"] == a[&"boss_weak"]:
			ok = false
			break
	_check("stage >=2: minion_weak != boss_weak (spread)", ok, "alignment on a stage >=2")

func _test_conflict_rate() -> void:
	var conflicts: int = 0
	var total: int = 0
	for n in range(2, 31):
		total += 1
		var a: Dictionary = StageAffinity.affinity_for(n)
		if a[&"minion_weak"] == a[&"boss_resist"] and a[&"boss_resist"] != &"":
			conflicts += 1
	var rate: float = float(conflicts) / float(total)
	_check("conflict (minion_weak==boss_resist) rate >= 1/3 over stages 2..30",
		rate >= 0.3333, "rate=%.2f (%d/%d)" % [rate, conflicts, total])

func _test_combat_minions_use_affinity() -> void:
	## Each minion must be EITHER the stage affinity OR un-classed (empty) — never a
	## foreign element. (Asserts the invariant, not the exact 20% split, to avoid RNG flake.)
	GameState.new_session()
	GameState.run_stage = 3
	var exp: Dictionary = StageAffinity.minion_affinity(3)
	var ok: bool = true
	var saw_any: bool = false
	for _w in range(8):
		Combat.start_wave(1, false)   ## auto_tick=false: spawn only, no timers
		for e in GameState.enemies:
			if e.get(&"is_boss", false):
				continue
			saw_any = true
			var is_aff: bool = e[&"weak"] == exp[&"weak"] and e[&"resist"] == exp[&"resist"]
			var is_unclassed: bool = e[&"weak"] == &"" and e[&"resist"] == &""
			if not (is_aff or is_unclassed):
				ok = false
		Combat.stop()
	_check("stage-3 minions are EITHER stage-affinity OR un-classed (never foreign)", ok and saw_any,
		"a minion had foreign tags")

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
	label.text = "\n".join(_lines)
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(label)
