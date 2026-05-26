## HeroCard — one squad member's UI tile (portrait + HP + ult gauge + ult button).
##
## Bound to a single hero by id via setup(hero_id). Signal handlers filter on
## that id so the card only reacts to changes for its own hero. The card
## queue_free()s itself if its hero disappears from GameState.squad_order
## (e.g., on new_session — SquadBar fully rebuilds anyway).
extends PanelContainer

## Emitted when the user clicks anywhere on the card except the ULT button.
## SquadBar relays this to ForgePanel so the clicked hero becomes the active
## forge tab.
signal selected(hero_id: StringName)

@onready var _portrait: TextureRect = %Portrait
@onready var _name_label: Label = %NameLabel
@onready var _hp_bar: ProgressBar = %HpBar
@onready var _hp_text: Label = %HpText
@onready var _ult_bar: ProgressBar = %UltBar
@onready var _ult_btn: Button = %UltBtn

## Ult-ready button styling — static yellow per user feedback
## ('PLEASE don't have the ult keep increasing/decreasing in size, just have it
## there, with a yellow color maybe').
const ULT_READY_BG     := Color(0.949, 0.776, 0.137, 1)  ## saturated yellow
const ULT_READY_HOVER  := Color(1.000, 0.851, 0.243, 1)  ## lighter on hover
const ULT_READY_BORDER := Color(0.451, 0.337, 0.063, 1)  ## dark amber outline
const ULT_READY_TEXT   := Color(0.176, 0.110, 0.059, 1)  ## near-black text

var _hero_id: StringName = &""
var _is_selected: bool = false
var _selected_style: StyleBoxFlat = null

func setup(hero_id: StringName) -> void:
	_hero_id = hero_id
	## Wait until the scene's ready before touching @onready node refs.
	if not is_inside_tree() or _portrait == null:
		ready.connect(_refresh_all, CONNECT_ONE_SHOT)
	else:
		_refresh_all()

func _ready() -> void:
	GameState.hero_hp_changed.connect(_on_hp_changed)
	GameState.hero_ult_changed.connect(_on_ult_changed)
	GameState.weapon_changed.connect(_on_weapon_changed)
	_ult_btn.pressed.connect(_on_ult_btn_pressed)
	gui_input.connect(_on_gui_input)
	_build_styles()
	_apply_selection_style()
	if _hero_id != &"":
		_refresh_all()

func _build_styles() -> void:
	## Selected card: light parchment fill + gold border so it pops vs theme
	## default. Unselected cards revert to theme default (no override).
	_selected_style = StyleBoxFlat.new()
	_selected_style.bg_color = Color("fbecca")        ## light parchment
	_selected_style.border_color = Color("d4a017")    ## gold
	_selected_style.border_width_left = 3
	_selected_style.border_width_top = 3
	_selected_style.border_width_right = 3
	_selected_style.border_width_bottom = 3
	_selected_style.corner_radius_top_left = 6
	_selected_style.corner_radius_top_right = 6
	_selected_style.corner_radius_bottom_left = 6
	_selected_style.corner_radius_bottom_right = 6
	_selected_style.content_margin_left = 4
	_selected_style.content_margin_right = 4
	_selected_style.content_margin_top = 4
	_selected_style.content_margin_bottom = 4

func set_selected(is_selected: bool) -> void:
	_is_selected = is_selected
	if _selected_style == null:
		## Called before _ready — defer.
		ready.connect(_apply_selection_style, CONNECT_ONE_SHOT)
		return
	_apply_selection_style()

func _apply_selection_style() -> void:
	if _is_selected and _selected_style != null:
		add_theme_stylebox_override(&"panel", _selected_style)
	else:
		remove_theme_stylebox_override(&"panel")

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if _hero_id != &"":
			emit_signal(&"selected", _hero_id)

func _hero():
	return GameState.get_hero(_hero_id)

func _refresh_all() -> void:
	var hero = _hero()
	if hero == null:
		return
	_portrait.texture = hero.data.portrait if hero.data != null else null
	_name_label.text = hero.data.name if hero.data != null else "?"
	_hp_bar.max_value = float(hero.max_hp)
	_hp_bar.value = float(hero.hp)
	_hp_text.text = "%d / %d" % [hero.hp, hero.max_hp]
	_ult_bar.max_value = float(Combat.ULT_GAUGE_MAX)
	_ult_bar.value = float(hero.ult_gauge)
	_refresh_ult_btn()
	modulate = Color(0.5, 0.5, 0.5, 0.8) if hero.is_dead else Color.WHITE

func _refresh_ult_btn() -> void:
	var hero = _hero()
	if hero == null:
		_ult_btn.disabled = true
		_ult_btn.text = "—"
		return
	var ready_now: bool = hero.ult_gauge >= Combat.ULT_GAUGE_MAX and not hero.ult_used and not hero.is_dead
	var was_disabled: bool = _ult_btn.disabled
	_ult_btn.disabled = not ready_now
	_ult_btn.text = ("🌀 %s" % hero.data.ult_name) if ready_now else ("ULT %d%%" % int(hero.ult_gauge))
	if ready_now and was_disabled:
		_apply_ult_ready_style()
	elif not ready_now:
		_clear_ult_ready_style()

## Static yellow stylebox override when ult is ready. Replaces the prior
## looping scale-pulse tween (was distracting per user feedback).
func _apply_ult_ready_style() -> void:
	_ult_btn.scale = Vector2.ONE
	var sb_normal := StyleBoxFlat.new()
	sb_normal.bg_color = ULT_READY_BG
	sb_normal.border_color = ULT_READY_BORDER
	sb_normal.border_width_left = 2
	sb_normal.border_width_top = 2
	sb_normal.border_width_right = 2
	sb_normal.border_width_bottom = 2
	sb_normal.corner_radius_top_left = 6
	sb_normal.corner_radius_top_right = 6
	sb_normal.corner_radius_bottom_left = 6
	sb_normal.corner_radius_bottom_right = 6
	var sb_hover := sb_normal.duplicate() as StyleBoxFlat
	sb_hover.bg_color = ULT_READY_HOVER
	_ult_btn.add_theme_stylebox_override(&"normal", sb_normal)
	_ult_btn.add_theme_stylebox_override(&"hover", sb_hover)
	_ult_btn.add_theme_stylebox_override(&"pressed", sb_normal)
	_ult_btn.add_theme_stylebox_override(&"focus", sb_normal)
	_ult_btn.add_theme_color_override(&"font_color", ULT_READY_TEXT)
	_ult_btn.add_theme_color_override(&"font_hover_color", ULT_READY_TEXT)

func _clear_ult_ready_style() -> void:
	_ult_btn.scale = Vector2.ONE
	_ult_btn.remove_theme_stylebox_override(&"normal")
	_ult_btn.remove_theme_stylebox_override(&"hover")
	_ult_btn.remove_theme_stylebox_override(&"pressed")
	_ult_btn.remove_theme_stylebox_override(&"focus")
	_ult_btn.remove_theme_color_override(&"font_color")
	_ult_btn.remove_theme_color_override(&"font_hover_color")

func _tween_bar(bar: ProgressBar, target: float) -> void:
	var t := create_tween()
	t.tween_property(bar, "value", target, 0.20).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

func _on_hp_changed(hero_id: StringName) -> void:
	if hero_id != _hero_id:
		return
	var hero = _hero()
	if hero == null:
		return
	_hp_bar.max_value = float(hero.max_hp)
	_tween_bar(_hp_bar, float(hero.hp))
	_hp_text.text = "%d / %d" % [hero.hp, hero.max_hp]
	modulate = Color(0.5, 0.5, 0.5, 0.8) if hero.is_dead else Color.WHITE

func _on_ult_changed(hero_id: StringName) -> void:
	if hero_id != _hero_id:
		return
	var hero = _hero()
	if hero == null:
		return
	_tween_bar(_ult_bar, float(hero.ult_gauge))
	_refresh_ult_btn()

func _on_weapon_changed(hero_id: StringName) -> void:
	if hero_id != _hero_id:
		return
	## Atk total is shown elsewhere (BattleView / ForgePanel); the card stays
	## minimal at this width. Refresh anyway in case max_hp changed.
	_refresh_all()

func _on_ult_btn_pressed() -> void:
	if _hero_id != &"":
		Combat.fire_ult(_hero_id)

## ---------- Juice ----------

const _FLASH_BOOST: Color = Color(1.8, 1.8, 1.8, 1.0)

## Briefly brightens the portrait via modulate boost. Called by SquadBar in
## response to Combat.enemy_hit_hero so the right card "reacts" to the hit
## even though it isn't the BattleView's displayed hero.
func flash(duration: float) -> void:
	if _portrait == null or duration <= 0.0:
		return
	_portrait.modulate = _FLASH_BOOST
	var t := create_tween()
	t.tween_property(_portrait, "modulate", Color.WHITE, duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

func hero_id() -> StringName:
	return _hero_id
