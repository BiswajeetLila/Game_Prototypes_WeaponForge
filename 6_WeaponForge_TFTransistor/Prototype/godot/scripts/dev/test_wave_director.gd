## Tests for WaveDirector — step 9.
extends Control

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== WaveDirector tests ===")
	_test_ftue_wave_counts()
	_test_ftue_cinematics()
	_test_ftue_lane_counts()
	_test_enemies_for_stage_wave_ftue()
	_test_enemies_boss_wave()
	_test_post_ftue()
	_test_telegraph_for_stage()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_enemies_for_stage_wave_ftue() -> void:
	var wd = get_node("/root/WaveDirector")
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test_wd.json"
	acc.reset()
	wd.reset()
	_check("has enemies_for_stage_wave method", wd.has_method("enemies_for_stage_wave"), "")
	if not wd.has_method("enemies_for_stage_wave"):
		return
	## Stage 0 W0: per spec, 3 weak goblins lane 1 only
	var s0 = wd.enemies_for_stage_wave(0, 0)
	_check("stage 0 W0: 3 enemies", s0.size() == 3, "got %d" % s0.size())
	var all_lane_1: bool = true
	for e in s0:
		if int(e.get("lane", -1)) != 1:
			all_lane_1 = false
	_check("stage 0 W0: all enemies lane 1", all_lane_1, "")
	## Stage 1 W0: 4 enemies lane 1
	var s1 = wd.enemies_for_stage_wave(1, 0)
	_check("stage 1 W0: 4 enemies", s1.size() == 4, "got %d" % s1.size())
	## Stage 2 W0: lanes 0+1 only (not lane 2)
	var s2 = wd.enemies_for_stage_wave(2, 0)
	_check("stage 2 W0: >=4 enemies", s2.size() >= 4, "got %d" % s2.size())
	var no_lane_2: bool = true
	for e in s2:
		if int(e.get("lane", -1)) == 2:
			no_lane_2 = false
	_check("stage 2 W0: no enemies in lane 2", no_lane_2, "")
	## Stage 4 W0: all 3 lanes
	var s4 = wd.enemies_for_stage_wave(4, 0)
	var lanes_seen: Dictionary = {}
	for e in s4:
		lanes_seen[int(e.get("lane", -1))] = true
	_check("stage 4 W0: at least 1 enemy lane 2", lanes_seen.has(2), "lanes seen: %s" % str(lanes_seen.keys()))

func _test_enemies_boss_wave() -> void:
	var wd = get_node("/root/WaveDirector")
	var acc = get_node("/root/AccountState")
	acc.reset()
	wd.reset()
	if not wd.has_method("enemies_for_stage_wave"):
		_check("[boss test skipped — method missing]", false, "")
		return
	## Stage 4 W2 = BOSS wave: per spec, single high-HP enemy
	var boss_wave = wd.enemies_for_stage_wave(4, 2)
	_check("stage 4 W2: boss wave has 1 enemy", boss_wave.size() == 1, "got %d" % boss_wave.size())
	if boss_wave.size() == 1:
		var boss: Dictionary = boss_wave[0]
		_check("boss: hp >= 30", int(boss.get("hp", 0)) >= 30, "got %d" % int(boss.get("hp", 0)))
		_check("boss: id is BOSS", boss.get("id", &"") == &"BOSS", "got %s" % str(boss.get("id", &"?")))

func _test_ftue_wave_counts() -> void:
	var wd = get_node("/root/WaveDirector")
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test_wd.json"
	acc.reset()  ## ftue_complete = false
	wd.reset()

	_check("FTUE stage 0: 1 wave", wd.waves_for_stage(0) == 1, "got %d" % wd.waves_for_stage(0))
	_check("FTUE stage 1: 1 wave", wd.waves_for_stage(1) == 1, "got %d" % wd.waves_for_stage(1))
	_check("FTUE stage 2: 3 waves", wd.waves_for_stage(2) == 3, "got %d" % wd.waves_for_stage(2))
	_check("FTUE stage 3: 3 waves", wd.waves_for_stage(3) == 3, "got %d" % wd.waves_for_stage(3))
	_check("FTUE stage 4: 3 waves", wd.waves_for_stage(4) == 3, "got %d" % wd.waves_for_stage(4))
	## Total FTUE = 1+1+3+3+3 = 11
	var total := 0
	for s in 5:
		total += wd.waves_for_stage(s)
	_check("FTUE total 11 waves", total == 11, "got %d" % total)

func _test_ftue_cinematics() -> void:
	var wd = get_node("/root/WaveDirector")
	_check("F0: no cinematic", wd.cinematic_at_forge(0) == &"", "got %s" % wd.cinematic_at_forge(0))
	_check("F1: no cinematic", wd.cinematic_at_forge(1) == &"", "")
	_check("F2: bran_joins", wd.cinematic_at_forge(2) == &"bran_joins", "got %s" % wd.cinematic_at_forge(2))
	_check("F3: no cinematic", wd.cinematic_at_forge(3) == &"", "")
	_check("F4: vex_joins", wd.cinematic_at_forge(4) == &"vex_joins", "got %s" % wd.cinematic_at_forge(4))
	_check("F5: no cinematic", wd.cinematic_at_forge(5) == &"", "")

func _test_ftue_lane_counts() -> void:
	var wd = get_node("/root/WaveDirector")
	_check("FTUE stage 0: 1 lane", wd.active_lanes_for_stage(0) == 1, "got %d" % wd.active_lanes_for_stage(0))
	_check("FTUE stage 1: 1 lane", wd.active_lanes_for_stage(1) == 1, "got %d" % wd.active_lanes_for_stage(1))
	_check("FTUE stage 2: 2 lanes", wd.active_lanes_for_stage(2) == 2, "got %d" % wd.active_lanes_for_stage(2))
	_check("FTUE stage 3: 2 lanes", wd.active_lanes_for_stage(3) == 2, "got %d" % wd.active_lanes_for_stage(3))
	_check("FTUE stage 4: 3 lanes", wd.active_lanes_for_stage(4) == 3, "got %d" % wd.active_lanes_for_stage(4))

func _test_post_ftue() -> void:
	var wd = get_node("/root/WaveDirector")
	var acc = get_node("/root/AccountState")
	acc.ftue_complete = true
	wd.reset()
	_check("post-FTUE stage 0: 3 waves", wd.waves_for_stage(0) == 3, "got %d" % wd.waves_for_stage(0))
	_check("post-FTUE stage 1: 3 waves", wd.waves_for_stage(1) == 3, "got %d" % wd.waves_for_stage(1))
	_check("post-FTUE F2: no cinematic", wd.cinematic_at_forge(2) == &"", "got %s" % wd.cinematic_at_forge(2))
	_check("post-FTUE F4: no cinematic", wd.cinematic_at_forge(4) == &"", "got %s" % wd.cinematic_at_forge(4))
	_check("post-FTUE stage 0: 3 lanes", wd.active_lanes_for_stage(0) == 3, "got %d" % wd.active_lanes_for_stage(0))
	acc.reset()
	if FileAccess.file_exists("user://account_test_wd.json"):
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://account_test_wd.json"))

## Q5 — wave telegraph data (spec §17)
func _test_telegraph_for_stage() -> void:
	var wd = get_node("/root/WaveDirector")
	var acc = get_node("/root/AccountState")
	acc.ftue_complete = true  ## post-FTUE: 3 waves/stage
	wd.reset()
	_check("has telegraph_for_stage method", wd.has_method("telegraph_for_stage"), "")
	if not wd.has_method("telegraph_for_stage"):
		return
	var tg = wd.telegraph_for_stage(0)
	_check("telegraph: 3 wave entries for a normal stage", tg.size() == 3, "got %d" % tg.size())
	if tg.size() >= 1:
		_check("telegraph: wave 0 lists goblin", &"goblin" in tg[0].get("enemies", []), "got %s" % str(tg[0].get("enemies", [])))
		_check("telegraph: wave 0 carries enemy count (3)", int(tg[0].get("count", 0)) == 3, "got %s" % str(tg[0].get("count", 0)))
		_check("telegraph: wave 0 carries goblin weakness LIGHTNING", tg[0].get("weak_tag", &"") == &"LIGHTNING", "got %s" % str(tg[0].get("weak_tag", &"")))
		_check("telegraph: wave 0 carries a resist tag", tg[0].get("resist_tag", &"") != &"", "got %s" % str(tg[0].get("resist_tag", &"")))
	## Boss stage telegraph: stage 4 wave 2 = BOSS
	var tg4 = wd.telegraph_for_stage(4)
	_check("telegraph: boss stage wave 2 lists BOSS", tg4.size() == 3 and (&"BOSS" in tg4[2].get("enemies", [])), "got %s" % (str(tg4[2].get("enemies", [])) if tg4.size() == 3 else "size %d" % tg4.size()))
	acc.reset()

func _check(name: String, ok: bool, detail: String) -> void:
	if ok: _passed += 1; _log("  PASS  " + name)
	else: _failed += 1; _log("  FAIL  " + name + (("  [" + detail + "]") if detail != "" else ""))

func _summary() -> void:
	_log("=== %d passed / %d failed ===" % [_passed, _failed])

func _log(line: String) -> void:
	print(line)
	_lines.append(line)

func _render_to_ui() -> void:
	var label := Label.new()
	label.add_theme_font_size_override(&"font_size", 12)
	label.text = "\n".join(_lines)
	label.anchor_right = 1.0; label.anchor_bottom = 1.0
	label.offset_left = 12; label.offset_top = 12
	add_child(label)
