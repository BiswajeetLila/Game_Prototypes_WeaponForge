## TilePicker — dev-only scene for assigning Kenney sprites to game data .tres files.
##
## Workflow:
##   1. Run this scene (right-click TilePicker.tscn → Play Scene, or set as main).
##   2. Pick a pack tab (Tiny Dungeon / Generic Items) on the left.
##   3. Click a slot on the right (Bran / Slime / Goblin / Skeleton / one of 5 parts).
##      That slot becomes "active" (highlighted yellow).
##   4. Click any tile in the grid → assigned to the active slot. Auto-advances.
##   5. Repeat for all 9 slots. Or skip ones you don't care about.
##   6. Click "Save All" → writes the icon refs into the existing .tres files via
##      ResourceSaver. Close + reopen the scene to see changes in the Inspector.
##
## Not shipped in production builds — lives under scripts/dev/ and scenes/dev/.
extends Control

const TINY_DUNGEON_DIR := "res://assets/kenney/kenney_tiny-dungeon/Tiles/"
const GENERIC_ITEMS_DIR := "res://assets/kenney/kenney_generic-items/PNG/Colored/"

const TILE_DISPLAY_SIZE := Vector2i(48, 48)
const GRID_COLUMNS := 6

## Each slot definition: id, label, target .tres path, target property name.
const SLOTS := [
	{"id": &"bran",          "label": "Bran (portrait)",  "path": "res://data/heroes/bran.tres",          "prop": "portrait"},
	{"id": &"slime",         "label": "Slime (sprite)",   "path": "res://data/enemies/slime.tres",        "prop": "sprite"},
	{"id": &"goblin",        "label": "Goblin (sprite)",  "path": "res://data/enemies/goblin.tres",       "prop": "sprite"},
	{"id": &"skeleton",      "label": "Skeleton (sprite)","path": "res://data/enemies/skeleton.tres",     "prop": "sprite"},
	{"id": &"h_iron_edge",   "label": "Iron Edge (head)", "path": "res://data/parts/h_iron_edge.tres",    "prop": "icon"},
	{"id": &"p_steel_grip",  "label": "Steel Grip (hilt)","path": "res://data/parts/p_steel_grip.tres",   "prop": "icon"},
	{"id": &"p_pyro_pommel", "label": "Pyro Pommel (hilt)","path": "res://data/parts/p_pyro_pommel.tres", "prop": "icon"},
	{"id": &"r_fire",        "label": "Fire Rune",        "path": "res://data/parts/r_fire.tres",         "prop": "icon"},
	{"id": &"r_ice",         "label": "Ice Rune",         "path": "res://data/parts/r_ice.tres",          "prop": "icon"},
]

## Runtime maps slot_id -> picked res:// texture path (or empty if not yet picked).
var picks: Dictionary = {}
var active_slot_id: StringName = &""

@onready var pack_tabs: TabContainer = %PackTabs
@onready var slot_list: VBoxContainer = %SlotList
@onready var status_label: Label = %StatusLabel
@onready var save_btn: Button = %SaveBtn

func _ready() -> void:
	## Project window is locked to 420x800 portrait for the game. The picker is a
	## dev tool that needs more room — force-resize and center on launch so every
	## label, button, and the right-hand slot column are fully visible.
	_resize_window_for_picker()
	for slot in SLOTS:
		picks[slot.id] = _load_existing_pick(slot)
	_build_pack_tab("Tiny Dungeon", TINY_DUNGEON_DIR)
	_build_pack_tab("Generic Items", GENERIC_ITEMS_DIR)
	_build_slot_list()
	save_btn.pressed.connect(_on_save_all)
	_set_active_slot(SLOTS[0].id)
	_refresh_status()

func _resize_window_for_picker() -> void:
	const W := 1100
	const H := 760
	var win_id: int = get_window().get_window_id() if get_window() != null else 0
	DisplayServer.window_set_size(Vector2i(W, H), win_id)
	## Center on the primary screen.
	var screen_idx: int = DisplayServer.window_get_current_screen(win_id)
	var screen_size: Vector2i = DisplayServer.screen_get_size(screen_idx)
	var screen_pos: Vector2i = DisplayServer.screen_get_position(screen_idx)
	var pos := screen_pos + (screen_size - Vector2i(W, H)) / 2
	DisplayServer.window_set_position(pos, win_id)

## ---------- Pack tabs (left panel: scrollable grid of tile buttons) ----------

func _build_pack_tab(label: String, dir_path: String) -> void:
	var scroll := ScrollContainer.new()
	scroll.name = label
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	var grid := GridContainer.new()
	grid.columns = GRID_COLUMNS
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(grid)
	pack_tabs.add_child(scroll)

	var d := DirAccess.open(dir_path)
	if d == null:
		push_warning("TilePicker: cannot open %s" % dir_path)
		return
	d.list_dir_begin()
	var fname := d.get_next()
	var files: Array = []
	while fname != "":
		if not d.current_is_dir() and fname.ends_with(".png"):
			files.append(fname)
		fname = d.get_next()
	d.list_dir_end()
	files.sort()
	for f in files:
		grid.add_child(_make_tile_button(dir_path + f))

func _make_tile_button(res_path: String) -> Control:
	var tex: Texture2D = load(res_path)
	var btn := TextureButton.new()
	btn.texture_normal = tex
	btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	btn.ignore_texture_size = true
	btn.custom_minimum_size = TILE_DISPLAY_SIZE
	btn.tooltip_text = res_path.get_file()
	btn.pressed.connect(func(): _on_tile_clicked(res_path))
	return btn

## ---------- Slot list (right panel: 9 assignment cards) ----------

func _build_slot_list() -> void:
	for slot in SLOTS:
		slot_list.add_child(_make_slot_card(slot))

func _make_slot_card(slot: Dictionary) -> Control:
	var panel := PanelContainer.new()
	panel.name = "Slot_" + String(slot.id)
	panel.set_meta(&"slot_id", slot.id)

	var hbox := HBoxContainer.new()
	panel.add_child(hbox)

	var preview := TextureRect.new()
	preview.custom_minimum_size = Vector2(40, 40)
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.name = "Preview"
	hbox.add_child(preview)

	var label := Label.new()
	label.text = slot.label
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(label)

	## Whole card is clickable. PanelContainer doesn't capture clicks by default
	## — wrap in a Button-flat for the click area.
	var click_btn := Button.new()
	click_btn.flat = true
	click_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	click_btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
	click_btn.focus_mode = Control.FOCUS_NONE
	click_btn.pressed.connect(func(): _set_active_slot(slot.id))
	panel.add_child(click_btn)
	click_btn.anchor_right = 1.0
	click_btn.anchor_bottom = 1.0

	_refresh_slot_card(panel, slot.id)
	return panel

func _refresh_slot_card(panel: PanelContainer, slot_id: StringName) -> void:
	var preview := panel.get_node("HBoxContainer/Preview") as TextureRect
	if preview == null:
		## Different child ordering — find by class.
		for c in panel.find_children("*", "TextureRect", true, false):
			preview = c
			break
	if preview == null:
		return
	var p: String = picks.get(slot_id, "")
	preview.texture = (load(p) if p != "" else null)
	var is_active: bool = (slot_id == active_slot_id)
	panel.modulate = Color(1.2, 1.2, 0.6) if is_active else Color.WHITE

func _set_active_slot(slot_id: StringName) -> void:
	active_slot_id = slot_id
	for child in slot_list.get_children():
		if child is PanelContainer:
			_refresh_slot_card(child, child.get_meta(&"slot_id"))
	_refresh_status()

## ---------- Click handlers ----------

func _on_tile_clicked(res_path: String) -> void:
	if active_slot_id == &"":
		return
	picks[active_slot_id] = res_path
	## Refresh card preview.
	for child in slot_list.get_children():
		if child is PanelContainer and child.get_meta(&"slot_id") == active_slot_id:
			_refresh_slot_card(child, active_slot_id)
			break
	_advance_to_next_unset()
	_refresh_status()

func _advance_to_next_unset() -> void:
	## Move to the next slot that doesn't have a pick yet. If all set, stay.
	var found_current := false
	for slot in SLOTS:
		if found_current and picks.get(slot.id, "") == "":
			_set_active_slot(slot.id)
			return
		if slot.id == active_slot_id:
			found_current = true
	## Wrap from top.
	for slot in SLOTS:
		if picks.get(slot.id, "") == "":
			_set_active_slot(slot.id)
			return

## ---------- Persistence ----------

func _on_save_all() -> void:
	var saved := 0
	var skipped := 0
	for slot in SLOTS:
		var pick_path: String = picks.get(slot.id, "")
		if pick_path == "":
			skipped += 1
			continue
		var res: Resource = load(slot.path)
		if res == null:
			push_warning("TilePicker: failed to load %s" % slot.path)
			continue
		var tex: Texture2D = load(pick_path)
		if tex == null:
			push_warning("TilePicker: failed to load texture %s" % pick_path)
			continue
		res.set(slot.prop, tex)
		var err: int = ResourceSaver.save(res, slot.path)
		if err == OK:
			saved += 1
		else:
			push_warning("TilePicker: ResourceSaver.save returned err=%d for %s" % [err, slot.path])
	status_label.text = "Saved %d / Skipped %d (no pick)" % [saved, skipped]
	print("[TilePicker] saved=%d skipped=%d" % [saved, skipped])

func _load_existing_pick(slot: Dictionary) -> String:
	## On open, pre-populate picks from whatever the .tres already references.
	var res: Resource = load(slot.path)
	if res == null:
		return ""
	var tex = res.get(slot.prop)
	if tex == null or not (tex is Texture2D):
		return ""
	return (tex as Texture2D).resource_path

func _refresh_status() -> void:
	var unset := 0
	for slot in SLOTS:
		if picks.get(slot.id, "") == "":
			unset += 1
	var name := ""
	for slot in SLOTS:
		if slot.id == active_slot_id:
			name = slot.label
			break
	status_label.text = "Active: %s | Unassigned: %d / %d" % [name, unset, SLOTS.size()]
