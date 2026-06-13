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

func _on_dismiss() -> void:
	visible = false
	dismissed.emit()
