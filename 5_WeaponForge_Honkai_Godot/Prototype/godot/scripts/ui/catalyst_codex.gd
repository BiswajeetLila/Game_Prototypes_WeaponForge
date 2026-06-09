## CatalystCodex — discovery-driven codex listing all 10 compounds (spec §7.5).
##
## Public:
##   refresh(discovered: Array, stage: int = -1)
##     Rebuild the 10-row list. discovered = ids triggered at least once.
##     stage = stage gate for Earth-pair locking (default reads AccountState).
##     Row marker:  ★ = discovered, 🔒 = Earth-gated and below stage 10, blank otherwise.
##
## v1 = pure discovery surface. No completion rewards (spec §10 — deferred).
## Codex completion = catalyst_codex_discovered persists across save/load (v5 schema).
class_name CatalystCodex
extends Control

const CatalystDataT = preload("res://scripts/data/catalyst_data.gd")

const ELEM_GLYPH: Dictionary = {
	&"fire": "🔥", &"ice": "❄", &"electric": "⚡",
	&"wind": "🌪", &"earth": "🪨",
}

var _header: Label
var _list: VBoxContainer
var _row_records: Dictionary = {}   ## Label -> source compound record (for _row_record lookup)

func _ready() -> void:
	var v := VBoxContainer.new()
	v.set_anchors_preset(Control.PRESET_FULL_RECT)
	v.add_theme_constant_override(&"separation", 4)
	add_child(v)
	_header = Label.new()
	_header.add_theme_font_size_override(&"font_size", 16)
	v.add_child(_header)
	_list = VBoxContainer.new()
	_list.add_theme_constant_override(&"separation", 2)
	v.add_child(_list)

func refresh(discovered: Array, stage: int = -1) -> void:
	if stage < 0:
		stage = AccountState.current_stage
	## Synchronous free for stable same-frame child counts (mirrors catalyst_chip).
	for c in _list.get_children():
		_list.remove_child(c)
		c.free()
	_row_records.clear()
	var rows: Array = CatalystDataT.by_priority()
	var disc_count: int = 0
	for rec in rows:
		var disc: bool = rec["id"] in discovered
		if disc:
			disc_count += 1
		var label: Label = _build_row(rec, disc, stage)
		_list.add_child(label)
		_row_records[label] = rec
	_header.text = "CATALYST CODEX — %d / 10 discovered" % disc_count

func _build_row(rec: Dictionary, discovered: bool, stage: int) -> Label:
	var l := Label.new()
	l.add_theme_font_size_override(&"font_size", 12)
	var elements: Array = rec.get("elements", [])
	var icons: String = ""
	if elements.size() == 2:
		var g1: String = String(ELEM_GLYPH.get(elements[0], ""))
		var g2: String = String(ELEM_GLYPH.get(elements[1], ""))
		icons = "%s+%s " % [g1, g2]
	var locked: bool = int(rec.get("gated_from_stage", 0)) > stage
	var prefix: String = ("🔒 " if locked else ("★ " if discovered else "  "))
	var effect_s: String = _format_effect(rec)
	l.text = "%s%s%-16s  %s" % [prefix, icons, rec.get("display_name", ""), effect_s]
	if locked:
		l.modulate = Color(0.6, 0.6, 0.6)
	elif discovered:
		l.modulate = Color(1.0, 0.85, 0.4)
	else:
		l.modulate = Color(0.85, 0.85, 0.85)
	return l

## Used by tests: fetch the Label row whose backing record has the given id.
func _row_for(id: StringName) -> Label:
	for label in _row_records:
		var rec: Dictionary = _row_records[label]
		if rec["id"] == id:
			return label
	return null

## Used by tests: fetch the source record for a given row Label.
func _row_record(label: Label) -> Dictionary:
	return _row_records.get(label, {})

## Effect renderer — mirrors home_screen/banner formatters. Will consolidate
## in the post-C5 cleanup (move to CatalystData.format_effect).
func _format_effect(rec: Dictionary) -> String:
	var mb: Dictionary = rec.get("modifier_bag", {})
	var parts: Array = []
	var atk_mult: float = float(mb.get(&"squad_atk_mult", 1.0))
	if not is_equal_approx(atk_mult, 1.0):
		parts.append("+%d%% ATK" % int(round((atk_mult - 1.0) * 100.0)))
	var crit_add: float = float(mb.get(&"squad_crit_add", 0.0))
	if not is_equal_approx(crit_add, 0.0):
		parts.append("+%d%% crit" % int(round(crit_add * 100.0)))
	var enemy_as: float = float(mb.get(&"enemy_atk_speed_mult", 1.0))
	if not is_equal_approx(enemy_as, 1.0):
		parts.append("-%d%% enemy atk-spd" % int(round((1.0 - enemy_as) * 100.0)))
	var swarm: float = float(mb.get(&"squad_atk_vs_swarm_mult", 1.0))
	if not is_equal_approx(swarm, 1.0):
		parts.append("+%d%% vs swarm" % int(round((swarm - 1.0) * 100.0)))
	if parts.is_empty():
		return "—"
	return " · ".join(parts)
