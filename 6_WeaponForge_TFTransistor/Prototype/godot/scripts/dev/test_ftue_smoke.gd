## FTUE mechanical smoke test — step 17.
## Drives the 11-wave FTUE sequence through CombatV2 + LaneState + WaveDirector
## + UltController + ShopV2 + ElementMediator. Asserts no hangs, no missing
## contracts, and that gameplay-loop side effects accumulate as expected.
##
## This is a mechanical safety net — does NOT validate "feel". Visual + pacing
## QC remains a human-playthrough job (deferred for human partner).
extends Control

const TICKS_PER_WAVE: int = 200  ## safety upper bound per wave
const HERO_LANES_FTUE_S0_S1: Array = [{"id": &"elara", "lane": 1, "base_dmg": 1, "damage_tag": &"WATER"}]
const HERO_LANES_FTUE_S2_S3: Array = [
	{"id": &"elara", "lane": 0, "base_dmg": 1, "damage_tag": &"WATER"},
	{"id": &"bran",  "lane": 1, "base_dmg": 1, "damage_tag": &"FIRE"},
]
const HERO_LANES_FTUE_S4: Array = [
	{"id": &"elara", "lane": 0, "base_dmg": 1, "damage_tag": &"WATER"},
	{"id": &"bran",  "lane": 1, "base_dmg": 1, "damage_tag": &"FIRE"},
	{"id": &"vex",   "lane": 2, "base_dmg": 1, "damage_tag": &"LIGHTNING"},
]

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []
var _reactions_seen: int = 0
var _cinematic_log: Array = []

func _ready() -> void:
	_log("=== FTUE smoke test (mechanical) ===")
	_setup()
	_run_ftue_world()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _setup() -> void:
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test_ftue_smoke.json"
	acc.reset()  ## ftue_complete = false
	var ls = get_node("/root/LaneState")
	ls.reset()
	var wd = get_node("/root/WaveDirector")
	wd.reset()
	var em = get_node("/root/ElementMediator")
	em.reset()
	var uc = get_node("/root/UltController")
	uc.reset()
	var shop = get_node("/root/ShopV2")
	shop.reset()
	em.connect("reaction_triggered", _on_reaction_seen)

func _on_reaction_seen(_rid: StringName, _enemy: Dictionary) -> void:
	_reactions_seen += 1

func _heroes_for_stage(stage: int) -> Array:
	## deep-duplicate: combat_v2 contact-damage writes hero["hp"]; const arrays are
	## read-only in Godot 4, so hand combat a mutable copy (production heroes are mutable).
	if stage < 2:
		return HERO_LANES_FTUE_S0_S1.duplicate(true)
	if stage < 4:
		return HERO_LANES_FTUE_S2_S3.duplicate(true)
	return HERO_LANES_FTUE_S4.duplicate(true)

func _seed_status_for_reactions(stage: int, enemies: Array) -> void:
	## To prove reactions can fire, pre-apply Wet to a subset of enemies in
	## stages 2+ so the FIRE/LIGHTNING heroes have a chance to trigger Steam
	## / Electrocute. Production game will apply Wet via Elara's water attacks
	## — this is a smoke-test convenience for the headless mechanical pass.
	if stage < 2:
		return
	var ls = get_node("/root/LaneState")
	for i in enemies.size():
		if i % 2 == 0:
			ls.apply_status(enemies[i], &"Wet", 8)

func _run_ftue_world() -> void:
	var wd = get_node("/root/WaveDirector")
	var ls = get_node("/root/LaneState")
	var combat = get_node("/root/CombatV2")
	var uc = get_node("/root/UltController")
	var total_waves: int = 0
	for stage in 5:
		var n_waves: int = wd.waves_for_stage(stage)
		_check("stage %d waves count" % stage,
			n_waves == (1 if stage < 2 else 3),
			"got %d" % n_waves)
		## Forge cinematic at this stage boundary
		var cine: StringName = wd.cinematic_at_forge(stage)
		if cine != &"":
			_cinematic_log.append(cine)
		for wave in n_waves:
			total_waves += 1
			var spec: Array = wd.enemies_for_stage_wave(stage, wave)
			## Materialize as enemy dicts inside LaneState
			ls.reset()
			for proto in spec:
				var e = ls.make_enemy(proto.id, proto.lane, proto.screen_x, proto.hp)
				ls.enemies.append(e)
			_seed_status_for_reactions(stage, ls.enemies)
			var heroes: Array = _heroes_for_stage(stage)
			var gs: Dictionary = {"enemies": ls.enemies, "heroes": heroes, "lane_state": ls}
			var ticks_used: int = 0
			while gs.enemies.size() > 0 and ticks_used < TICKS_PER_WAVE:
				combat.tick(gs)
				ticks_used += 1
			_check("stage %d wave %d cleared" % [stage, wave],
				gs.enemies.size() == 0,
				"remaining: %d enemies after %d ticks" % [gs.enemies.size(), ticks_used])
			_check("stage %d wave %d under safety tick limit" % [stage, wave],
				ticks_used < TICKS_PER_WAVE,
				"used %d / %d" % [ticks_used, TICKS_PER_WAVE])
	_check("FTUE total 11 waves",
		total_waves == 11,
		"got %d" % total_waves)
	_check("bran_joins cinematic fired",
		_cinematic_log.has(&"bran_joins"),
		"log: %s" % str(_cinematic_log))
	_check("vex_joins cinematic fired",
		_cinematic_log.has(&"vex_joins"),
		"log: %s" % str(_cinematic_log))
	_check("reactions fired during FTUE",
		_reactions_seen > 0,
		"got %d reactions" % _reactions_seen)
	_check("UltController fills bars",
		uc.bars >= 1,
		"bars: %d after %d reactions" % [uc.bars, _reactions_seen])

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
	label.add_theme_font_size_override(&"font_size", 10)
	label.text = "\n".join(_lines)
	label.anchor_right = 1.0; label.anchor_bottom = 1.0
	label.offset_left = 6; label.offset_top = 6
	add_child(label)
