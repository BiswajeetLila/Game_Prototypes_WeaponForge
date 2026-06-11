## ResultModal — full-screen end-of-run screen (victory rewards / wipe).
## Visual target: _art-build/screens/result_01.png. "clear" renders the rich
## rewards panel (per-hero XP + level-ups); "wipe" stays compact.
## Main listens for restart_requested -> routes back to Home.
extends ColorRect

signal restart_requested

const COL_PANEL := Color("6b4a32")
const COL_PANEL_BORDER := Color("4a3826")
const COL_CARD := Color("e8d0a9")
const COL_CARD_BORDER := Color("8a5a3a")
const COL_GREEN := Color("57ab5a")
const COL_GREEN_BORDER := Color("2e6b33")
const COL_GOLD := Color("ffd700")
const COL_TEXT_DARK := Color("3a2a1c")

@onready var _title: Label = %Title
@onready var _subtitle: Label = %Subtitle
@onready var _reward_panel: PanelContainer = %RewardPanel
@onready var _hero_rows: VBoxContainer = %HeroRows
@onready var _btn: Button = %ActionBtn

func _ready() -> void:
	hide()
	var sb := StyleBoxFlat.new()
	sb.bg_color = COL_CARD
	sb.border_color = COL_CARD_BORDER
	sb.set_border_width_all(3)
	sb.set_corner_radius_all(12)
	_reward_panel.add_theme_stylebox_override(&"panel", sb)
	var bb := StyleBoxFlat.new()
	bb.bg_color = COL_GREEN
	bb.border_color = COL_GREEN_BORDER
	bb.set_border_width_all(3)
	bb.set_corner_radius_all(12)
	_btn.add_theme_stylebox_override(&"normal", bb)
	_btn.pressed.connect(func():
		hide()
		emit_signal(&"restart_requested")
	)

func open(kind: StringName) -> void:
	match kind:
		&"wipe":
			_title.text = "💀 DEFEAT"
			_title.add_theme_color_override(&"font_color", Color("ff5555"))
			_subtitle.text = "The squad fell at wave %d. Rebuild and try again." % GameState.wave
			_btn.text = "↺  BACK TO CAMP"
			_reward_panel.hide()
		&"clear":
			_title.text = "🏆 VICTORY"
			_title.add_theme_color_override(&"font_color", COL_GOLD)
			_subtitle.text = "All %d waves cleared!" % GameState.TOTAL_WAVES
			_btn.text = "▶  CONTINUE"
			_populate_rows()
			_reward_panel.show()
		_:
			_title.text = "?"
			_subtitle.text = ""
			_btn.text = "↺  BACK"
			_reward_panel.hide()
	show()

func _populate_rows() -> void:
	for c in _hero_rows.get_children():
		c.queue_free()
	var header := Label.new()
	header.text = "HERO XP"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override(&"font_size", 14)
	header.add_theme_color_override(&"font_color", COL_PANEL)
	_hero_rows.add_child(header)
	for row in GameState.result_rows():
		_hero_rows.add_child(_make_row(row))

func _make_row(row: Dictionary) -> Control:
	var h := HBoxContainer.new()
	h.add_theme_constant_override(&"separation", 10)
	var tex := TextureRect.new()
	tex.texture = row["portrait"]
	tex.custom_minimum_size = Vector2(44, 44)
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	h.add_child(tex)
	var v := VBoxContainer.new()
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var top := HBoxContainer.new()
	var name_l := Label.new()
	name_l.text = "%s   Lv %d → Lv %d" % [row["name"], row["lv_from"], row["lv_to"]]
	name_l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_l.add_theme_font_size_override(&"font_size", 14)
	name_l.add_theme_color_override(&"font_color", COL_TEXT_DARK)
	top.add_child(name_l)
	var xp_l := Label.new()
	xp_l.text = "+%d XP" % int(row["xp_gained"])
	xp_l.add_theme_font_size_override(&"font_size", 14)
	xp_l.add_theme_color_override(&"font_color", COL_GREEN_BORDER)
	top.add_child(xp_l)
	if int(row["lv_to"]) > int(row["lv_from"]):
		var up := Label.new()
		up.text = "  ⬆ LEVEL UP!"
		up.add_theme_font_size_override(&"font_size", 14)
		up.add_theme_color_override(&"font_color", COL_GOLD)
		top.add_child(up)
	v.add_child(top)
	var bar := ProgressBar.new()
	bar.custom_minimum_size = Vector2(0, 12)
	bar.show_percentage = false
	var lv: int = int(row["lv_to"])
	var xp: int = AccountState.get_xp(row["id"])
	var into: int = xp - HeroProgress.cumulative_xp_for_level(lv)
	var span: int = HeroProgress.xp_to_next(lv)
	bar.max_value = float(span) if span > 0 else 1.0
	bar.value = float(into) if span > 0 else 1.0
	var fill := StyleBoxFlat.new()
	fill.bg_color = COL_GREEN
	fill.set_corner_radius_all(5)
	bar.add_theme_stylebox_override(&"fill", fill)
	var track := StyleBoxFlat.new()
	track.bg_color = COL_PANEL_BORDER
	track.set_corner_radius_all(5)
	bar.add_theme_stylebox_override(&"background", track)
	v.add_child(bar)
	h.add_child(v)
	return h
