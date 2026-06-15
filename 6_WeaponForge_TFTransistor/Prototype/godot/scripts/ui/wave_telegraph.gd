## WaveTelegraph — pre-stage preview overlay (spec §17).
## Shows wave count, enemy lineup, hero weaknesses, dismiss button.
## Appears before each stage; blocks combat until dismissed.
extends PanelContainer

signal dismissed

var _wave_count_label: Label
var _enemy_list: VBoxContainer
var _dismiss_btn: Button

func _ready() -> void:
	_build_ui()
	visible = false

func _build_ui() -> void:
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override(&"separation", 8)
	add_child(vbox)

	var title := Label.new()
	title.name = "TitleLabel"
	title.text = "INCOMING WAVE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override(&"font_size", 18)
	vbox.add_child(title)

	_wave_count_label = Label.new()
	_wave_count_label.name = "WaveCountLabel"
	_wave_count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_wave_count_label.add_theme_font_size_override(&"font_size", 13)
	vbox.add_child(_wave_count_label)

	_enemy_list = VBoxContainer.new()
	_enemy_list.name = "EnemyList"
	vbox.add_child(_enemy_list)

	_dismiss_btn = Button.new()
	_dismiss_btn.name = "DismissBtn"
	_dismiss_btn.text = "READY"
	_dismiss_btn.pressed.connect(_on_dismiss)
	vbox.add_child(_dismiss_btn)

## Show telegraph for given wave index (1-based display) and enemy lineup.
## enemies = Array[{id, lane, weakness_tag}]
func show_wave(wave_number: int, total_waves: int, enemies: Array) -> void:
	_wave_count_label.text = "Wave %d / %d" % [wave_number, total_waves]
	## Clear previous enemy rows
	for child in _enemy_list.get_children():
		child.queue_free()
	## Add new rows
	for e in enemies:
		var row := Label.new()
		row.text = "Lane %d — %s  (weak: %s)" % [e.get("lane", 0), e.get("id", "?"), e.get("weakness_tag", "none")]
		row.add_theme_font_size_override(&"font_size", 12)
		_enemy_list.add_child(row)
	visible = true

## Show the full upcoming-stage preview (spec §17): one row per wave with its enemy
## lineup + primary weakness / resistance. entries = Array of
## { wave:int, enemies:Array[StringName], weak_tag:StringName, resist_tag:StringName }.
## Element tag -> status-cutout icon (matches main_v2 intel strip).
const _ELEM_ICON: Dictionary = {
	&"FIRE": "burning", &"WATER": "wet", &"LIGHTNING": "shocked", &"ICE": "chilled", &"EARTH": "cracked",
}

func show_stage(stage_num: int, entries: Array) -> void:
	_wave_count_label.text = "Stage %d — %d waves" % [stage_num + 1, entries.size()]
	for child in _enemy_list.get_children():
		_enemy_list.remove_child(child)  ## immediate (queue_free alone defers a frame)
		child.queue_free()
	for e in entries:
		_enemy_list.add_child(_build_wave_row(e))
	visible = true

## One detailed row per wave: "W{n}: {enemies} ×{count}  weak [icon]  resist [icon]".
func _build_wave_row(e: Dictionary) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override(&"separation", 4)
	var names := ""
	for x in e.get("enemies", []):
		names += (", " if names != "" else "") + String(x)
	if names == "":
		names = "—"
	var cnt: int = int(e.get("count", 0))
	var lbl := Label.new()
	lbl.text = "W%d: %s%s" % [int(e.get("wave", 0)) + 1, names, ("  ×%d" % cnt) if cnt > 0 else ""]
	lbl.add_theme_font_size_override(&"font_size", 12)
	row.add_child(lbl)
	_add_tag_chip(row, "weak", StringName(e.get("weak_tag", &"")), Color(0.5, 1.0, 0.5))
	_add_tag_chip(row, "resist", StringName(e.get("resist_tag", &"")), Color(1.0, 0.5, 0.5))
	return row

func _add_tag_chip(row: HBoxContainer, caption: String, tag: StringName, tint: Color) -> void:
	if tag == &"":
		return
	var cap := Label.new()
	cap.text = "  " + caption
	cap.add_theme_font_size_override(&"font_size", 10)
	cap.modulate = tint  ## green=weak / red=resist cue on the caption (icon keeps natural colour)
	row.add_child(cap)
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(16, 16)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE  ## scale to 16px (else demands native 256px -> huge row)
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.tooltip_text = String(tag)
	var key: String = _ELEM_ICON.get(tag, "")
	if key != "":
		var p := "res://assets/generated/status/%s_cut.png" % key
		if ResourceLoader.exists(p):
			icon.texture = load(p)
	row.add_child(icon)
	## fallback: if no texture, show the tag letters so the row still conveys the element
	if icon.texture == null:
		var t := Label.new()
		t.text = String(tag)
		t.add_theme_font_size_override(&"font_size", 10)
		t.modulate = tint
		row.add_child(t)

func _on_dismiss() -> void:
	visible = false
	dismissed.emit()
