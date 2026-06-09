## CatalystBanner — start-of-stage compound-reveal banner (spec §7.3).
##
## After the existing boss-telegraph banner fades, this banner fades in for
## BANNER_HOLD_SEC and fades out (owner-approved 1.2s hold per CLAUDE.md §13).
##
## Public:
##   show_compound(record: Dictionary)  Fade in with compound name + bag-effect.
##                                      {} is treated as a hide (no crash).
##   hide_banner()                      Force-hide (used by tests + scene-out).
##
## Wired by main.gd::_build_battle_overlay.
class_name CatalystBanner
extends Control

const BANNER_HOLD_SEC: float = 1.2
const FADE_SEC: float = 0.30

const ELEM_GLYPH: Dictionary = {
	&"fire": "🔥", &"ice": "❄", &"electric": "⚡",
	&"wind": "🌪", &"earth": "🪨",
}

var _title: Label
var _effect: Label
var _bg: ColorRect
var _hide_timer: Timer

func _ready() -> void:
	set_anchors_preset(Control.PRESET_TOP_WIDE)
	custom_minimum_size = Vector2(0, 88)
	visible = false

	_bg = ColorRect.new()
	_bg.color = Color(0.12, 0.06, 0.18, 0.85)
	_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_bg)

	var v := VBoxContainer.new()
	v.set_anchors_preset(Control.PRESET_CENTER)
	v.offset_left = -180
	v.offset_right = 180
	v.offset_top = -32
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(v)

	_title = Label.new()
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title.add_theme_font_size_override(&"font_size", 22)
	v.add_child(_title)

	_effect = Label.new()
	_effect.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_effect.add_theme_font_size_override(&"font_size", 13)
	_effect.modulate = Color(1, 1, 1, 0.85)
	v.add_child(_effect)

	_hide_timer = Timer.new()
	_hide_timer.one_shot = true
	_hide_timer.wait_time = BANNER_HOLD_SEC
	_hide_timer.timeout.connect(_fade_out)
	add_child(_hide_timer)

func show_compound(rec: Dictionary) -> void:
	if rec.is_empty():
		hide_banner()
		return
	var name_s: String = String(rec.get("display_name", "")).to_upper()
	_title.text = "💠 %s CATALYST ACTIVE" % name_s
	_effect.text = _format_effect(rec)
	visible = true
	modulate = Color(1, 1, 1, 0)
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 1.0, FADE_SEC)
	_hide_timer.start()

func hide_banner() -> void:
	visible = false
	if _hide_timer != null and not _hide_timer.is_stopped():
		_hide_timer.stop()

func _fade_out() -> void:
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 0.0, FADE_SEC)
	tw.finished.connect(func(): visible = false)

## Human-readable effect string for the banner. Mirrors home_screen's
## _format_compound_effect but prefixes the element glyphs (e.g. "🔥+❄").
func _format_effect(rec: Dictionary) -> String:
	var mb: Dictionary = rec.get("modifier_bag", {})
	var parts: Array = []
	var atk_mult: float = float(mb.get(&"squad_atk_mult", 1.0))
	if not is_equal_approx(atk_mult, 1.0):
		parts.append("+%d%% squad ATK" % int(round((atk_mult - 1.0) * 100.0)))
	var crit_add: float = float(mb.get(&"squad_crit_add", 0.0))
	if not is_equal_approx(crit_add, 0.0):
		parts.append("+%d%% crit" % int(round(crit_add * 100.0)))
	var enemy_as: float = float(mb.get(&"enemy_atk_speed_mult", 1.0))
	if not is_equal_approx(enemy_as, 1.0):
		parts.append("-%d%% enemy atk-spd" % int(round((1.0 - enemy_as) * 100.0)))
	var swarm: float = float(mb.get(&"squad_atk_vs_swarm_mult", 1.0))
	if not is_equal_approx(swarm, 1.0):
		parts.append("+%d%% ATK vs swarm" % int(round((swarm - 1.0) * 100.0)))
	var elements: Array = rec.get("elements", [])
	var elem_s: String = ""
	if elements.size() == 2:
		var g1: String = String(ELEM_GLYPH.get(elements[0], ""))
		var g2: String = String(ELEM_GLYPH.get(elements[1], ""))
		elem_s = "%s+%s   " % [g1, g2]
	return elem_s + " · ".join(parts)
