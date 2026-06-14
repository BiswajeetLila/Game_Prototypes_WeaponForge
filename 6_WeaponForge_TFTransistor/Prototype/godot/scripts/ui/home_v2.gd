## HomeV2 — minimal slice home screen (playtest framing). Title + PLAY -> Main_v2.
## The full 2_WC Home (squad/gacha meta) is out of scope for the vertical slice;
## the Wittle-style meta home lands in Phase 5+.
extends Control

func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0

	var bg := ColorRect.new()
	bg.name = "Bg"
	bg.color = Color(0.10, 0.09, 0.13)
	_fill(bg)
	add_child(bg)

	var title := Label.new()
	title.name = "Title"
	title.text = "WEAPONFORGE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override(&"font_size", 36)
	title.modulate = Color(1.0, 0.82, 0.3)
	title.anchor_left = 0.0; title.anchor_right = 1.0
	title.anchor_top = 0.26; title.anchor_bottom = 0.26
	add_child(title)

	var sub := Label.new()
	sub.name = "Subtitle"
	sub.text = "TFTransistor — vertical slice"
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_font_size_override(&"font_size", 14)
	sub.modulate = Color(0.8, 0.8, 0.85)
	sub.anchor_left = 0.0; sub.anchor_right = 1.0
	sub.anchor_top = 0.34; sub.anchor_bottom = 0.34
	add_child(sub)

	var play := Button.new()
	play.name = "PlayBtn"
	play.text = "▶  PLAY"
	play.add_theme_font_size_override(&"font_size", 22)
	play.anchor_left = 0.5; play.anchor_right = 0.5
	play.anchor_top = 0.52; play.anchor_bottom = 0.52
	play.offset_left = -100; play.offset_right = 100
	play.offset_top = 0; play.offset_bottom = 56
	play.pressed.connect(_on_play)
	add_child(play)

func _on_play() -> void:
	get_tree().change_scene_to_file("res://scenes/Main_v2.tscn")

func _fill(c: Control) -> void:
	c.anchor_left = 0.0; c.anchor_top = 0.0
	c.anchor_right = 1.0; c.anchor_bottom = 1.0
