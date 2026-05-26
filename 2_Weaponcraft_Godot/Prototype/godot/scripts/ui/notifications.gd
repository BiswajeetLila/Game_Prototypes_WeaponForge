## Notifications — full-width banner overlay for transient announcements.
##
## API:
##   show_banner(text, color, lifetime := 1.4)
##   show_card(title, subtitle, accent, lifetime := 1.2)
##
## Centered scale-pop + fade. Stacks vertically if multiple fire in one frame.
extends Control

func show_banner(text: String, color: Color, lifetime: float = 1.4) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_color_override(&"font_color", color)
	label.add_theme_color_override(&"font_outline_color", Color.BLACK)
	label.add_theme_constant_override(&"outline_size", 8)
	label.add_theme_font_size_override(&"font_size", 36)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_CENTER, true)
	add_child(label)
	## Center horizontally over the screen.
	label.size = Vector2(size.x, 60)
	label.position = Vector2(0, size.y * 0.30 + get_child_count() * 20)
	label.pivot_offset = label.size * 0.5
	label.scale = Vector2(0.4, 0.4)
	label.modulate.a = 0.0

	var t := create_tween().set_parallel(true)
	t.tween_property(label, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(label, "modulate:a", 1.0, 0.18)
	## Hold, then fade.
	var tf := create_tween()
	tf.tween_interval(lifetime - 0.45)
	tf.tween_property(label, "modulate:a", 0.0, 0.35)
	tf.tween_callback(label.queue_free)

## Card-style overlay for richer wave / unlock announcements. Panel with
## border + 2-line title/subtitle, quick scale-pop + fade. Use this when text
## alone reads as flat ('just text sucks' per user feedback).
##
## title    — large headline, e.g. "✓ WAVE 3 CLEAR"
## subtitle — small detail, e.g. "+ 🪙 11"
## accent   — border + title colour
## lifetime — total wall-clock seconds (default 1.2)
func show_card(title: String, subtitle: String, accent: Color, lifetime: float = 1.2) -> void:
	var panel := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.157, 0.094, 0.063, 0.94)         ## deep umber, slight transparency
	sb.border_color = accent
	sb.border_width_left = 3
	sb.border_width_top = 3
	sb.border_width_right = 3
	sb.border_width_bottom = 3
	sb.corner_radius_top_left = 10
	sb.corner_radius_top_right = 10
	sb.corner_radius_bottom_left = 10
	sb.corner_radius_bottom_right = 10
	sb.content_margin_left = 22
	sb.content_margin_right = 22
	sb.content_margin_top = 14
	sb.content_margin_bottom = 14
	panel.add_theme_stylebox_override(&"panel", sb)

	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override(&"separation", 4)
	panel.add_child(vbox)

	var title_label := Label.new()
	title_label.text = title
	title_label.add_theme_color_override(&"font_color", accent)
	title_label.add_theme_color_override(&"font_outline_color", Color.BLACK)
	title_label.add_theme_constant_override(&"outline_size", 6)
	title_label.add_theme_font_size_override(&"font_size", 28)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title_label)

	if subtitle != "":
		var sub_label := Label.new()
		sub_label.text = subtitle
		sub_label.add_theme_color_override(&"font_color", Color(0.961, 0.902, 0.784, 1))
		sub_label.add_theme_font_size_override(&"font_size", 16)
		sub_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(sub_label)

	panel.set_anchors_preset(Control.PRESET_CENTER, true)
	add_child(panel)
	## Force layout pass so size is real before pivot/position math.
	panel.reset_size()
	await get_tree().process_frame
	panel.pivot_offset = panel.size * 0.5
	panel.position = Vector2(size.x * 0.5 - panel.size.x * 0.5,
		size.y * 0.32 + get_child_count() * 12)
	panel.scale = Vector2(0.55, 0.55)
	panel.modulate.a = 0.0

	var t := create_tween().set_parallel(true)
	t.tween_property(panel, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(panel, "modulate:a", 1.0, 0.14)
	var tf := create_tween()
	tf.tween_interval(maxf(0.1, lifetime - 0.40))
	tf.tween_property(panel, "modulate:a", 0.0, 0.30)
	tf.tween_callback(panel.queue_free)
