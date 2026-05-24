## ScreenFlash — full-screen ColorRect overlay that briefly tints on ult fire,
## crit chains, or other "screen-feel" beats. Listens to Combat signals.
extends ColorRect

const ULT_TINT: Color = Color(0.95, 0.85, 1.0, 0.55)   ## purple-white

func _ready() -> void:
	color = Color(1, 1, 1, 0)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	Combat.ult_fired.connect(_on_ult_fired)

func _on_ult_fired(_hero_id: StringName, _total_dmg: int) -> void:
	color = ULT_TINT
	var t := create_tween()
	t.tween_property(self, "color:a", 0.0, 0.45).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
