## CatalystChip — persistent HUD chip (top-right) showing active compound(s) for
## the active stage (spec §7.4).
##
## Public:
##   set_compounds(records: Array)  Replace the rendered set. [] -> hidden.
##                                  1 record = cap-1 mode (single row).
##                                  2-3 records = no-cap mode (stacked rows).
##   expand_requested signal        Emitted on gui_input mouse-press (tap-to-expand).
##                                  v1: no overlay attached; main.gd connects a no-op.
##
## Wired by main.gd::_build_battle_overlay.
class_name CatalystChip
extends PanelContainer

signal expand_requested

const ELEM_GLYPH: Dictionary = {
	&"fire": "🔥", &"ice": "❄", &"electric": "⚡",
	&"wind": "🌪", &"earth": "🪨",
}

var _rows: VBoxContainer

func _ready() -> void:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.10, 0.06, 0.16, 0.78)
	sb.set_border_width_all(1)
	sb.border_color = Color(0.55, 0.45, 0.75, 0.6)
	sb.set_corner_radius_all(6)
	add_theme_stylebox_override(&"panel", sb)
	custom_minimum_size = Vector2(150, 0)
	_rows = VBoxContainer.new()
	_rows.add_theme_constant_override(&"separation", 2)
	add_child(_rows)
	visible = false
	gui_input.connect(_on_gui_input)

func set_compounds(records: Array) -> void:
	## Free old rows synchronously (immediate, not queue) so children count is
	## stable in the same frame for tests + downstream layout queries.
	for c in _rows.get_children():
		_rows.remove_child(c)
		c.free()
	if records.is_empty():
		visible = false
		return
	for rec in records:
		_rows.add_child(_build_row(rec))
	visible = true

func _build_row(rec: Dictionary) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override(&"separation", 4)
	var icon_text: String = "💠"
	var elements: Array = rec.get("elements", [])
	if elements.size() == 2:
		var g1: String = String(ELEM_GLYPH.get(elements[0], ""))
		var g2: String = String(ELEM_GLYPH.get(elements[1], ""))
		icon_text = "%s+%s" % [g1, g2]
	var icon := Label.new()
	icon.text = icon_text
	icon.add_theme_font_size_override(&"font_size", 12)
	row.add_child(icon)
	var name_l := Label.new()
	name_l.text = String(rec.get("display_name", ""))
	name_l.add_theme_font_size_override(&"font_size", 11)
	row.add_child(name_l)
	return row

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		expand_requested.emit()
