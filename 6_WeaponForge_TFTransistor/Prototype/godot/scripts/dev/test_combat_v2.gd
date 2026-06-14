## Tests for CombatV2 tick order — step 7.
## + Q2: CombatTargeting resolver + Function-driven attack wiring.
extends Control

const _Targeting = preload("res://scripts/core/combat_targeting.gd")
const _TierScale = preload("res://scripts/core/tier_scale.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []

func _ready() -> void:
	_log("=== CombatV2 tests ===")
	_test_tick_order()
	_test_enemy_dies_in_cleanup()
	_test_status_decays_before_advance()
	_test_contact_damage()
	## Q2b — targeting resolver
	_test_target_own_lane_closest()
	_test_target_own_lane_ignores_other_lanes()
	_test_target_own_lane_line_pierces()
	_test_target_ricochet_chain()
	_test_target_lowest_hp()
	## Q2c — Function-driven attack
	_test_active_fn_applies_status_emit()
	_test_active_fn_knockback()
	_test_active_fn_beam_hits_all_in_lane()
	## Q3 — tier stat scaling
	_test_tier_scale_values()
	_test_tier_mult_scales_damage()
	## Q6 — review fixes
	_test_reaction_dmg_mult_applied()
	_test_reaction_cracked_amplifies()
	_test_per_tick_burning_damage()
	_test_per_tick_bleed_pct_damage()
	_test_freeze_solid_halts_advance()
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

func _test_tick_order() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	cv2.reset()
	var e = ls.make_enemy(&"t", 1, 0.5)
	var hero = {"id": &"bran", "lane": 1, "base_dmg": 0, "damage_tag": &""}
	var gs = {"enemies": [e], "heroes": [hero], "lane_state": ls}
	cv2.tick(gs)
	var log: Array = cv2._tick_order_log
	_check("tick order: decay before advance", log.find("decay") < log.find("advance"), "log=%s" % str(log))
	_check("tick order: advance before attack", log.find("advance") < log.find("attack"), "log=%s" % str(log))
	_check("tick order: attack before react", log.find("attack") < log.find("react"), "log=%s" % str(log))
	_check("tick order: react before cleanup", log.find("react") < log.find("cleanup"), "log=%s" % str(log))

func _test_enemy_dies_in_cleanup() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	var e = ls.make_enemy(&"goblin", 1, 0.5, 1)  ## hp=1
	var hero = {"id": &"bran", "lane": 1, "base_dmg": 5, "damage_tag": &""}
	var gs = {"enemies": [e], "heroes": [hero], "lane_state": ls}
	cv2.tick(gs)
	_check("enemy with 0 hp removed in cleanup", gs["enemies"].size() == 0, "size=%d" % gs["enemies"].size())

func _test_status_decays_before_advance() -> void:
	## enemy has Frozen (no advance); after decay Frozen removed; in SAME tick advance applies normal speed
	## After tick: decay removes Frozen, THEN advance uses walk_speed
	## => enemy moves. Without decay-before-advance it wouldn't.
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	var e = ls.make_enemy(&"t", 1, 0.5)
	ls.apply_status(e, &"Frozen", 1)  ## 1 tick left -> decays to 0 this tick, removed before advance
	var hero = {"id": &"bran", "lane": 1, "base_dmg": 0, "damage_tag": &""}
	var gs = {"enemies": [e], "heroes": [hero], "lane_state": ls}
	cv2.tick(gs)
	## After decay: Frozen gone; after advance: screen_x = 0.5 - 0.05 = 0.45
	_check("decay-before-advance: Frozen expires + enemy moves this tick",
		is_equal_approx(e.screen_x, 0.45), "got %f" % e.screen_x)

func _test_contact_damage() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	var e = ls.make_enemy(&"g", 1, 0.0)  ## at hero anchor
	e.engaged = true
	var hero = {"id": &"bran", "lane": 1, "base_dmg": 0, "damage_tag": &"", "hp": 30, "max_hp": 30}
	var gs = {"enemies": [e], "heroes": [hero], "lane_state": ls}
	cv2.tick(gs)
	_check("contact: engaged enemy damages lane hero", int(hero.hp) < 30, "got %d" % int(hero.hp))
	## tick order still 4 phases (contact folded into advance, not a new logged step)
	_check("contact: tick order unchanged (no extra step)", cv2._tick_order_log.size() == 5, "got %s" % str(cv2._tick_order_log))

## ---- Q2b: CombatTargeting resolver ----

func _test_target_own_lane_closest() -> void:
	var ls = get_node("/root/LaneState")
	var far = ls.make_enemy(&"a", 1, 0.7)
	var near = ls.make_enemy(&"b", 1, 0.3)
	var hit = _Targeting.resolve(&"own_lane_closest", 1, 0.0, [far, near])
	_check("own_lane_closest hits nearest in lane", hit.size() == 1 and hit[0].id == &"b", "got %s" % str(hit.map(func(e): return e.id)))

func _test_target_own_lane_ignores_other_lanes() -> void:
	var ls = get_node("/root/LaneState")
	var other = ls.make_enemy(&"a", 0, 0.1)  ## closer but wrong lane
	var mine = ls.make_enemy(&"b", 1, 0.5)
	var hit = _Targeting.resolve(&"own_lane_closest", 1, 0.0, [other, mine])
	_check("own_lane_closest ignores other lanes", hit.size() == 1 and hit[0].id == &"b", "got %s" % str(hit.map(func(e): return e.id)))

func _test_target_own_lane_line_pierces() -> void:
	var ls = get_node("/root/LaneState")
	var e1 = ls.make_enemy(&"a", 1, 0.3)
	var e2 = ls.make_enemy(&"b", 1, 0.7)
	var e3 = ls.make_enemy(&"c", 0, 0.5)  ## other lane, excluded
	var hit = _Targeting.resolve(&"own_lane_line", 1, 0.0, [e1, e2, e3])
	_check("own_lane_line pierces all in lane (front->back)",
		hit.size() == 2 and hit[0].id == &"a" and hit[1].id == &"b", "got %s" % str(hit.map(func(e): return e.id)))

func _test_target_ricochet_chain() -> void:
	var ls = get_node("/root/LaneState")
	var es := []
	for i in 5:
		es.append(ls.make_enemy(StringName("e%d" % i), 1, 0.2 + 0.1 * i))
	var hit = _Targeting.resolve(&"ricochet", 1, 0.0, es, 3)
	var ids := {}
	for e in hit: ids[e.id] = true
	_check("ricochet returns max_hits distinct targets", hit.size() == 3 and ids.size() == 3, "got %s" % str(hit.map(func(e): return e.id)))

func _test_target_lowest_hp() -> void:
	var ls = get_node("/root/LaneState")
	var a = ls.make_enemy(&"a", 1, 0.5, 10)
	var b = ls.make_enemy(&"b", 2, 0.5, 3)
	var c = ls.make_enemy(&"c", 0, 0.5, 7)
	var hit = _Targeting.resolve(&"lowest_hp", 1, 0.0, [a, b, c])
	_check("lowest_hp hits the weakest enemy anywhere", hit.size() == 1 and hit[0].id == &"b", "got %s" % str(hit.map(func(e): return e.id)))

## ---- Q2c: Function-driven attack ----

func _test_active_fn_applies_status_emit() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	cv2.reset()
	var fire = load("res://data/functions/fire.tres")
	var e = ls.make_enemy(&"g", 1, 0.5, 15)
	var hero = {"id": &"bran", "lane": 1, "base_dmg": 4, "active_fn": fire}
	var gs = {"enemies": [e], "heroes": [hero], "lane_state": ls}
	cv2.tick(gs)
	_check("active FIRE applies Burning to target", ls.has_status(e, &"Burning"), "")
	_check("active FIRE damages target", int(e.hp) < 15, "got %d" % int(e.hp))

func _test_active_fn_knockback() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	cv2.reset()
	var knock = load("res://data/functions/knockback.tres")
	var e = ls.make_enemy(&"g", 1, 0.5, 30)
	var hero = {"id": &"bran", "lane": 1, "base_dmg": 4, "active_fn": knock}
	var gs = {"enemies": [e], "heroes": [hero], "lane_state": ls}
	cv2.tick(gs)
	_check("KNOCKBACK active pushes target back", e.screen_x > 0.5, "got %f" % e.screen_x)

func _test_active_fn_beam_hits_all_in_lane() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	cv2.reset()
	var beam = load("res://data/functions/beam.tres")
	var e1 = ls.make_enemy(&"a", 1, 0.3, 20)
	var e2 = ls.make_enemy(&"b", 1, 0.7, 20)
	var hero = {"id": &"bran", "lane": 1, "base_dmg": 10, "active_fn": beam}
	var gs = {"enemies": [e1, e2], "heroes": [hero], "lane_state": ls}
	cv2.tick(gs)
	_check("BEAM pierces: both lane enemies take damage", int(e1.hp) < 20 and int(e2.hp) < 20, "got %d / %d" % [int(e1.hp), int(e2.hp)])

## ---- Q3: tier stat scaling (spec §10.1) ----

func _test_tier_scale_values() -> void:
	_check("T1 mult 1.0", is_equal_approx(_TierScale.mult(1), 1.0), "got %f" % _TierScale.mult(1))
	_check("T2 mult 1.4", is_equal_approx(_TierScale.mult(2), 1.4), "got %f" % _TierScale.mult(2))
	_check("T3 mult 2.0", is_equal_approx(_TierScale.mult(3), 2.0), "got %f" % _TierScale.mult(3))
	_check("T4 mult 2.8", is_equal_approx(_TierScale.mult(4), 2.8), "got %f" % _TierScale.mult(4))
	_check("T5 mult 4.0", is_equal_approx(_TierScale.mult(5), 4.0), "got %f" % _TierScale.mult(5))

## Higher tier_mult on a hero = strictly more damage from the same Function (merge payoff).
func _test_tier_mult_scales_damage() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	var fire = load("res://data/functions/fire.tres")
	## T1 hero
	cv2.reset()
	var e1 = ls.make_enemy(&"a", 1, 0.5, 100)
	var h1 = {"id": &"bran", "lane": 1, "base_dmg": 10, "active_fn": fire, "tier_mult": _TierScale.mult(1)}
	cv2.tick({"enemies": [e1], "heroes": [h1], "lane_state": ls})
	var dmg_t1: int = 100 - int(e1.hp)
	## T4 hero
	cv2.reset()
	var e4 = ls.make_enemy(&"b", 1, 0.5, 100)
	var h4 = {"id": &"bran", "lane": 1, "base_dmg": 10, "active_fn": fire, "tier_mult": _TierScale.mult(4)}
	cv2.tick({"enemies": [e4], "heroes": [h4], "lane_state": ls})
	var dmg_t4: int = 100 - int(e4.hp)
	_check("T4 Function deals more damage than T1 (merge payoff)", dmg_t4 > dmg_t1, "t1=%d t4=%d" % [dmg_t1, dmg_t4])

## ---- Q6 fix F1: reaction dmg_mult applied as bonus damage ----

func _test_reaction_dmg_mult_applied() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	var light = load("res://data/functions/lightning.tres")  ## tag LIGHTNING
	## Wet enemy -> LIGHTNING x Wet = Electrocute (2.0x); dry enemy -> no reaction
	cv2.reset()
	var ewet = ls.make_enemy(&"w", 1, 0.5, 200)
	ls.apply_status(ewet, &"Wet", 4)
	cv2.tick({"enemies": [ewet], "heroes": [{"id": &"e", "lane": 1, "base_dmg": 10, "active_fn": light}], "lane_state": ls})
	var with_reaction: int = 200 - int(ewet.hp)
	cv2.reset()
	var edry = ls.make_enemy(&"d", 1, 0.5, 200)
	cv2.tick({"enemies": [edry], "heroes": [{"id": &"e", "lane": 1, "base_dmg": 10, "active_fn": light}], "lane_state": ls})
	var no_reaction: int = 200 - int(edry.hp)
	_check("reaction dmg_mult: Electrocute (2.0x) deals more than a no-reaction hit",
		with_reaction > no_reaction, "with=%d no=%d" % [with_reaction, no_reaction])

func _test_reaction_cracked_amplifies() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	var light = load("res://data/functions/lightning.tres")
	## Wet only vs Wet+Cracked(2): Cracked amps the reaction (spec §4: x1.30 at 2 stacks)
	cv2.reset()
	var e1 = ls.make_enemy(&"a", 1, 0.5, 300)
	ls.apply_status(e1, &"Wet", 4)
	cv2.tick({"enemies": [e1], "heroes": [{"id": &"e", "lane": 1, "base_dmg": 10, "active_fn": light}], "lane_state": ls})
	var plain: int = 300 - int(e1.hp)
	cv2.reset()
	var e2 = ls.make_enemy(&"b", 1, 0.5, 300)
	ls.apply_status(e2, &"Wet", 4)
	ls.apply_status(e2, &"Cracked", 4, 2, 3)
	cv2.tick({"enemies": [e2], "heroes": [{"id": &"e", "lane": 1, "base_dmg": 10, "active_fn": light}], "lane_state": ls})
	var cracked: int = 300 - int(e2.hp)
	_check("reaction Cracked amp: Wet+Cracked Electrocute > Wet-only", cracked > plain, "plain=%d cracked=%d" % [plain, cracked])

## ---- Q6 fix F2: per-tick status DoT (Burning/Shocked/Bleed) ----

func _test_per_tick_burning_damage() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	cv2.reset()
	var e = ls.make_enemy(&"b", 1, 0.9, 100)
	ls.apply_status(e, &"Burning", 5)
	## hero in an empty lane dealing 0 -> isolates the DoT
	cv2.tick({"enemies": [e], "heroes": [{"id": &"x", "lane": 2, "base_dmg": 0}], "lane_state": ls})
	_check("Burning deals -2 HP/tick", int(e.hp) == 98, "got %d" % int(e.hp))

func _test_per_tick_bleed_pct_damage() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	cv2.reset()
	var e = ls.make_enemy(&"b", 1, 0.9, 100)  ## max_hp 100
	ls.apply_status(e, &"Bleed", 4)
	cv2.tick({"enemies": [e], "heroes": [{"id": &"x", "lane": 2, "base_dmg": 0}], "lane_state": ls})
	_check("Bleed deals 5% maxHP/tick (-5 of 100)", int(e.hp) == 95, "got %d" % int(e.hp))

## ---- Q6 fix F3: Freeze Solid's Frozen must halt the enemy's advance ----

func _test_freeze_solid_halts_advance() -> void:
	var cv2 = get_node("/root/CombatV2")
	var ls = get_node("/root/LaneState")
	var ice = load("res://data/functions/ice.tres")  ## ICE active
	cv2.reset()
	var e = ls.make_enemy(&"w", 1, 0.7, 500)  ## big HP so it survives the hits
	ls.apply_status(e, &"Wet", 6)
	var hero = {"id": &"x", "lane": 1, "base_dmg": 2, "active_fn": ice}
	cv2.tick({"enemies": [e], "heroes": [hero], "lane_state": ls})  ## tick A: ICE x Wet = Freeze Solid -> Frozen
	var xA: float = e.screen_x
	cv2.tick({"enemies": [e], "heroes": [hero], "lane_state": ls})  ## tick B: Frozen must halt advance
	_check("Freeze Solid's Frozen halts advance the next tick", is_equal_approx(e.screen_x, xA), "xA=%f xB=%f" % [xA, e.screen_x])

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
