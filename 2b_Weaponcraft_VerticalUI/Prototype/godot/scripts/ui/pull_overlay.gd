## PullOverlay — scripted NEW HERO! reveal (pitch beat 2, pull_01 target).
## open(hero_id) renders the hero card with a pop-in tween; tap dismisses.
## Pure theater: the grant itself happens in GameState.maybe_grant_first_pull.
extends ColorRect

signal dismissed

const COL_CARD := Color("e8d0a9")
const COL_VIOLET := Color("7a4fa3")
const COL_GOLD := Color("ffd700")
const COL_TEXT_DARK := Color("3a2a1c")

@onready var _click_btn: Button = %ClickToDismiss
@onready var _card: PanelContainer = %Card
@onready var _portrait: TextureRect = %Portrait
@onready var _name_l: Label = %NameL

func _ready() -> void:
	hide()
	var sb := StyleBoxFlat.new()
	sb.bg_color = COL_CARD
	sb.border_color = COL_VIOLET
	sb.set_border_width_all(5)
	sb.set_corner_radius_all(14)
	_card.add_theme_stylebox_override(&"panel", sb)
	_click_btn.pressed.connect(func():
		hide()
		emit_signal(&"dismissed")
	)

func open(hero_id: StringName) -> void:
	var data = GameState.heroes_by_id.get(hero_id)
	if data == null:
		return
	_portrait.texture = data.portrait
	_name_l.text = data.name
	show()
	_card.scale = Vector2(0.7, 0.7)
	_card.pivot_offset = _card.size / 2.0
	modulate.a = 0.0
	var tw := create_tween().set_parallel(true)
	tw.tween_property(self, "modulate:a", 1.0, 0.2)
	tw.tween_property(_card, "scale", Vector2.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
