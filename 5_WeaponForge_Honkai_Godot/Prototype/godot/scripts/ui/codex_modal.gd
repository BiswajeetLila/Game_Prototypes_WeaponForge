## CodexModal — list of recipes; silhouette if undiscovered, full if discovered.
##
## Opens from Hud's 📜 button. Click outside list or press Close to dismiss.
extends ColorRect

@onready var _list: VBoxContainer = %RecipeList
@onready var _close_btn: Button = %CloseBtn
@onready var _backdrop: Button = %Backdrop

func _ready() -> void:
	hide()
	_close_btn.pressed.connect(close)
	_backdrop.pressed.connect(close)

func open() -> void:
	_rebuild()
	show()

func close() -> void:
	hide()

func _rebuild() -> void:
	for child in _list.get_children():
		child.queue_free()
	for recipe_id in GameState.recipe_ids:
		var rec = GameState.get_recipe_def(recipe_id)
		if rec == null:
			continue
		var discovered: bool = GameState.discovered_recipes.has(recipe_id)
		_list.add_child(_make_row(rec, discovered))

func _make_row(rec, discovered: bool) -> Control:
	var panel := PanelContainer.new()
	var v := VBoxContainer.new()
	panel.add_child(v)

	var title := Label.new()
	title.text = rec.name if discovered else "???"
	title.add_theme_font_size_override(&"font_size", 16)
	title.add_theme_color_override(&"font_color",
		Color("d8a8ff") if discovered else Color(0.4, 0.4, 0.4))
	v.add_child(title)

	var tags := Label.new()
	tags.add_theme_font_size_override(&"font_size", 11)
	if discovered:
		var pattern_strs: Array = []
		for pattern in rec.patterns:
			var bits: Array = []
			for tag in pattern:
				bits.append(String(tag).to_upper())
			pattern_strs.append(" + ".join(bits))
		tags.text = "Tags: " + "  /  ".join(pattern_strs)
	else:
		tags.text = "Tags: ???"
	tags.add_theme_color_override(&"font_color", Color(0.7, 0.7, 0.7))
	v.add_child(tags)

	var desc := Label.new()
	desc.text = rec.desc if discovered else "Unknown effect. Forge weapons to find out."
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.add_theme_font_size_override(&"font_size", 12)
	v.add_child(desc)

	return panel
