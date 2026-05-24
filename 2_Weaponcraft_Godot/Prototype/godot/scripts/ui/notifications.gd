## Notifications — full-width banner overlay for transient announcements.
##
## API:
##   show_banner(text, color, lifetime := 1.4)
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
