## Home — persistent meta screen: roster grid + FORM SQUAD + BATTLE.
## Boot scene. BATTLE starts a run (Main.tscn) with the selected squad;
## Main's exit paths come back here. Visual target: _art-build/screens/home_01.png.
extends Control

const MAX_SQUAD: int = 3
const ROSTER_SLOTS: int = 6   ## grid cells; unowned/locked render as "?"
const HERO_ORDER: Array = [&"bran", &"elara", &"vex"]

const COL_BG := Color("2e2019")
const COL_PANEL := Color("6b4a32")
const COL_PANEL_BORDER := Color("4a3826")
const COL_CARD := Color("e8d0a9")
const COL_CARD_BORDER := Color("8a5a3a")
const COL_GREEN := Color("57ab5a")
const COL_GREEN_BORDER := Color("2e6b33")
const COL_GOLD := Color("ffd700")
const COL_LOCK := Color("3f3023")
const COL_TEXT_DARK := Color("3a2a1c")

var _selected: Array = []      ## StringName, tap order
var _roster_cards: Dictionary = {}  ## StringName -> Button

@onready var _roster_grid: GridContainer = %RosterGrid
@onready var _squad_row: HBoxContainer = %SquadRow
@onready var _battle_btn: Button = %BattleBtn
@onready var _total_lv: Label = %TotalLv
@onready var _scout_label: Label = %ScoutLabel
@onready var _debug_reset_btn: Button = %DebugResetBtn

func _ready() -> void:
	_style_static()
	_build_roster()
	_scout_label.text = "🔭 " + GameState.scout_intel()
	_refresh()
	_battle_btn.pressed.connect(_on_battle)
	_debug_reset_btn.pressed.connect(_on_debug_reset)

## Dev/QA tool: wipe AccountState (XP, ownership, flags incl. pull_seen), restore
## defaults (Bran+Elara owned), persist, and rebuild the screen. One-tap, no
## confirm dialog — single-tap simplicity for dev use. Lives in 2_WC's shipped
## P0 so QA can re-test the scripted pull beat without nuking user://account.json
## by hand. Carries into 6_ via the seed copy.
func _on_debug_reset() -> void:
	AccountState.reset()
	AccountState.ensure_defaults()
	AccountState.save_account()
	_selected = []
	_build_roster()
	_refresh()

## ---------- selection model (headless-tested) ----------

func toggle_hero(hero_id: StringName) -> void:
	if not AccountState.is_owned(hero_id):
		return
	if _selected.has(hero_id):
		_selected.erase(hero_id)
	elif _selected.size() < MAX_SQUAD:
		_selected.append(hero_id)
	_refresh()

func get_squad() -> Array:
	return _selected.duplicate()

## ---------- build / refresh ----------

func _style_static() -> void:
	var bg := StyleBoxFlat.new()
	bg.bg_color = COL_GREEN
	bg.border_color = COL_GREEN_BORDER
	bg.set_border_width_all(3)
	bg.set_corner_radius_all(12)
	_battle_btn.add_theme_stylebox_override(&"normal", bg)
	var bg2 := bg.duplicate()
	bg2.bg_color = COL_GREEN.lightened(0.12)
	_battle_btn.add_theme_stylebox_override(&"hover", bg2)
	var bg3 := bg.duplicate()
	bg3.bg_color = COL_LOCK
	bg3.border_color = COL_PANEL_BORDER
	_battle_btn.add_theme_stylebox_override(&"disabled", bg3)

func _panel_style(card: bool = false, selected: bool = false) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = COL_CARD if card else COL_PANEL
	sb.border_color = COL_GREEN if selected else (COL_CARD_BORDER if card else COL_PANEL_BORDER)
	sb.set_border_width_all(3 if selected else 2)
	sb.set_corner_radius_all(10)
	return sb

func _build_roster() -> void:
	for c in _roster_grid.get_children():
		c.queue_free()
	_roster_cards = {}
	var filled: int = 0
	for hero_id in HERO_ORDER:
		if not AccountState.is_owned(hero_id):
			continue
		var data = GameState.heroes_by_id.get(hero_id)
		if data == null:
			continue
		_roster_grid.add_child(_make_hero_card(hero_id, data))
		filled += 1
	for i in range(ROSTER_SLOTS - filled):
		_roster_grid.add_child(_make_locked_slot())

func _make_hero_card(hero_id: StringName, data) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(110, 132)
	btn.add_theme_stylebox_override(&"normal", _panel_style(true))
	btn.add_theme_stylebox_override(&"hover", _panel_style(true))
	btn.add_theme_stylebox_override(&"pressed", _panel_style(true, true))
	var v := VBoxContainer.new()
	v.set_anchors_preset(Control.PRESET_FULL_RECT)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tex := TextureRect.new()
	tex.texture = data.portrait
	tex.custom_minimum_size = Vector2(0, 72)
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(tex)
	var name_l := Label.new()
	name_l.text = data.name
	name_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_l.add_theme_color_override(&"font_color", COL_TEXT_DARK)
	name_l.add_theme_font_size_override(&"font_size", 14)
	name_l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(name_l)
	var lv_l := Label.new()
	lv_l.text = "Lv %d" % AccountState.get_level(hero_id)
	lv_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lv_l.add_theme_color_override(&"font_color", COL_GREEN_BORDER)
	lv_l.add_theme_font_size_override(&"font_size", 12)
	lv_l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(lv_l)
	btn.add_child(v)
	btn.pressed.connect(func(): toggle_hero(hero_id))
	_roster_cards[hero_id] = btn
	return btn

func _make_locked_slot() -> PanelContainer:
	var p := PanelContainer.new()
	p.custom_minimum_size = Vector2(110, 132)
	var sb := _panel_style()
	sb.bg_color = COL_LOCK
	p.add_theme_stylebox_override(&"panel", sb)
	var q := Label.new()
	q.text = "?"
	q.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	q.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	q.add_theme_font_size_override(&"font_size", 40)
	q.add_theme_color_override(&"font_color", COL_PANEL_BORDER)
	p.add_child(q)
	return p

func _refresh() -> void:
	## Roster selection rims.
	for hero_id in _roster_cards:
		var btn: Button = _roster_cards[hero_id]
		btn.add_theme_stylebox_override(&"normal", _panel_style(true, _selected.has(hero_id)))
	## Squad row: selected mini-cards in order, then empty "+" slots.
	for c in _squad_row.get_children():
		c.queue_free()
	for hero_id in _selected:
		var data = GameState.heroes_by_id.get(hero_id)
		var p := PanelContainer.new()
		p.custom_minimum_size = Vector2(96, 110)
		p.add_theme_stylebox_override(&"panel", _panel_style(true))
		var v := VBoxContainer.new()
		v.alignment = BoxContainer.ALIGNMENT_CENTER
		var tex := TextureRect.new()
		tex.texture = data.portrait if data != null else null
		tex.custom_minimum_size = Vector2(0, 64)
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		v.add_child(tex)
		var l := Label.new()
		l.text = (data.name if data != null else "?") + "  Lv %d" % AccountState.get_level(hero_id)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.add_theme_color_override(&"font_color", COL_TEXT_DARK)
		l.add_theme_font_size_override(&"font_size", 11)
		v.add_child(l)
		p.add_child(v)
		_squad_row.add_child(p)
	for i in range(MAX_SQUAD - _selected.size()):
		var p := PanelContainer.new()
		p.custom_minimum_size = Vector2(96, 110)
		var sb := _panel_style()
		sb.bg_color = COL_LOCK
		p.add_theme_stylebox_override(&"panel", sb)
		var plus := Label.new()
		plus.text = "+"
		plus.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		plus.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		plus.add_theme_font_size_override(&"font_size", 34)
		plus.add_theme_color_override(&"font_color", COL_PANEL_BORDER)
		p.add_child(plus)
		_squad_row.add_child(p)
	_battle_btn.disabled = _selected.is_empty()
	## Real data only: sum of owned hero levels.
	var total: int = 0
	for hero_id in HERO_ORDER:
		if AccountState.is_owned(hero_id):
			total += AccountState.get_level(hero_id)
	_total_lv.text = "⭐ Total Lv %d" % total

func _on_battle() -> void:
	if _selected.is_empty():
		return
	GameState.new_session(_selected.duplicate())
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
