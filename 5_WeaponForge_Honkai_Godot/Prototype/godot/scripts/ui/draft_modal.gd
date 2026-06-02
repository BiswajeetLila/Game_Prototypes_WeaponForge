## DraftModal — post-wave Forge Draft pick (R3, spec §10). Programmatic UI v1.
##
## Main opens it with the dealt cards after every wave clear (combat is already
## stopped — Combat._on_wave_cleared calls stop()). Player taps a card -> emits
## card_picked -> Main applies it via ForgeDraft.apply and starts the next wave.
## Unpicked cards vanish (no inventory, spec §10).
extends ColorRect

signal card_picked(card)

var _cards: Array = []
var _title: Label = null
var _row: HBoxContainer = null

func _ready() -> void:
	color = Color(0.02, 0.02, 0.06, 0.88)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	visible = false

	var center := VBoxContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	center.offset_left = -190.0
	center.offset_right = 190.0
	center.offset_top = -140.0
	center.offset_bottom = 140.0
	center.add_theme_constant_override(&"separation", 12)
	add_child(center)

	_title = Label.new()
	_title.text = "⚒ FORGE DRAFT — pick one"
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title.add_theme_font_size_override(&"font_size", 20)
	center.add_child(_title)

	_row = HBoxContainer.new()
	_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_row.add_theme_constant_override(&"separation", 10)
	center.add_child(_row)

func open(cards: Array) -> void:
	_cards = cards
	for child in _row.get_children():
		child.queue_free()
	for card in cards:
		var btn := Button.new()
		var hero = GameState.get_hero(card.hero_id)
		var hero_name: String = hero.data.name if hero != null else String(card.hero_id)
		btn.text = "%s\n%s\n→ %s" % [card.name, card.desc, hero_name]
		btn.custom_minimum_size = Vector2(118, 96)
		btn.clip_text = false
		btn.pressed.connect(_on_pick.bind(card))
		_row.add_child(btn)
	## Belt + braces: runtime-built Controls under a CanvasLayer have laid out
	## 0x0 despite full-rect anchors — force the rect from the viewport.
	position = Vector2.ZERO
	size = get_viewport_rect().size
	visible = true

func _on_pick(card) -> void:
	visible = false
	card_picked.emit(card)
