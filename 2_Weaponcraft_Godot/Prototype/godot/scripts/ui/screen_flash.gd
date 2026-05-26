## ScreenFlash — full-screen ColorRect overlay that briefly tints on ult fire,
## crit chains, or other "screen-feel" beats. Listens to Combat signals.
extends ColorRect

const ULT_TINT: Color = Color(0.95, 0.85, 1.0, 0.55)   ## purple-white
const CRIT_TINT: Color = Color(1.0, 0.4, 0.2, 1.0)     ## red-orange — opaque base, alpha applied via flash()

func _ready() -> void:
	color = Color(1, 1, 1, 0)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if Engine.has_singleton("Combat") or has_node("/root/Combat"):
		Combat.ult_fired.connect(_on_ult_fired)
		Combat.hero_hit_enemy.connect(_on_hero_hit_enemy)

## Public flash API — used by Juice PR2 crit screen flash + future variants.
## Renders `tint` at `alpha`, then tweens alpha to 0 over `duration` via
## Quart-out (snappy attack, soft decay). Calling again interrupts any in-flight
## tween (Godot 4 auto-kills prior tweens on the same property when create_tween
## is bound to `self`).
func flash(tint: Color, alpha: float = 0.4, duration: float = 0.18) -> void:
	var c := tint
	c.a = clampf(alpha, 0.0, 1.0)
	color = c
	var t := create_tween()
	t.tween_property(self, "color:a", 0.0, duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

func _on_ult_fired(_hero_id: StringName, _total_dmg: int) -> void:
	color = ULT_TINT
	var t := create_tween()
	t.tween_property(self, "color:a", 0.0, 0.45).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

## Juice PR2: red-orange screen tint on any crit hit. Brief (~0.18s) — strong
## hit feedback without dominating the screen.
func _on_hero_hit_enemy(_hero_id: StringName, _enemy_idx: int, _dmg: int, _source: StringName, is_crit: bool) -> void:
	if not is_crit:
		return
	if not JuiceConfig.JUICE_ENABLED:
		return
	flash(CRIT_TINT, 0.4, 0.18)
