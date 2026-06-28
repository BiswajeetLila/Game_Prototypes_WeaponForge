## DiscoveryOverlay — first-discovery flash card.
##
## Fires whenever GameState pushes a recipe into pending_discoveries (via
## Recipes.check_hero_for_discoveries -> GameState.mark_discovered). Pauses
## Combat while open. Click anywhere to dismiss + show next in queue (or
## resume combat if queue is empty).
extends ColorRect

@onready var _click_btn: Button = %ClickToDismiss
@onready var _icon: TextureRect = %Icon
@onready var _name_label: Label = %NameLabel
@onready var _tag_label: Label = %TagLabel
@onready var _desc_label: Label = %DescLabel
@onready var _headline: Label = %Headline

var _was_combat_running: bool = false

func _ready() -> void:
	hide()
	_click_btn.pressed.connect(_on_dismiss)
	GameState.recipe_discovered.connect(_on_recipe_discovered)

func _on_recipe_discovered(_rid: StringName) -> void:
	if visible:
		## Already showing one — the queue will drain in dismiss order.
		return
	_show_next()

func _show_next() -> void:
	if GameState.pending_discoveries.is_empty():
		hide()
		_resume_combat_if_paused()
		return
	var rid: StringName = GameState.pending_discoveries[0]
	GameState.pending_discoveries.remove_at(0)
	var rec = GameState.get_recipe_def(rid)
	if rec == null:
		_show_next()
		return
	_pause_combat()
	_render(rec)
	show()

func _render(rec) -> void:
	_headline.text = "✨ RECIPE DISCOVERED"
	_name_label.text = rec.name
	_icon.texture = rec.icon
	_icon.visible = rec.icon != null
	## Tag pattern text.
	var pattern_strs: Array = []
	for pattern in rec.patterns:
		var bits: Array = []
		for tag in pattern:
			bits.append(String(tag).to_upper())
		pattern_strs.append(" + ".join(bits))
	_tag_label.text = " / ".join(pattern_strs)
	_desc_label.text = rec.desc
	## Pop-in tween for a little dopamine.
	scale = Vector2(0.85, 0.85)
	modulate.a = 0.0
	var tw := create_tween().set_parallel(true)
	tw.tween_property(self, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "modulate:a", 1.0, 0.2)

func _on_dismiss() -> void:
	_show_next()

func _pause_combat() -> void:
	if Combat.is_running():
		_was_combat_running = true
		Combat.stop()

func _resume_combat_if_paused() -> void:
	if _was_combat_running:
		_was_combat_running = false
		Combat.resume()
