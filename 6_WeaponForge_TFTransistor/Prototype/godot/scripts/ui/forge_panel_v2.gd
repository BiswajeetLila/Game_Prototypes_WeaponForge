## ForgePanel_v2 — bottom rail (3 heroes × 3 sockets + HP + Ult bars) + top shop rail (7 slots).
## Phase 4 slice: placeholder art, functional socket display.
extends Control

const MAX_HEROES: int = 3
const MAX_SOCKETS: int = 3
const SHOP_SLOTS: int = 7

## Emitted when player taps a socket to assign/swap a function.
signal socket_tapped(hero_idx: int, socket_idx: int)
## Emitted when player taps a shop item to select it for placement.
signal shop_item_tapped(slot_idx: int)

var _hero_rows: Array = []   ## 3 _HeroRow containers (HBoxContainer)
var _shop_slots: Array = []  ## 7 PanelContainer nodes for shop items
var _shop_items: Array = []  ## Array[Dictionary] — current shop inventory

func _ready() -> void:
	_build_shop_rail()
	_build_hero_rows()

func _build_shop_rail() -> void:
	var rail := HBoxContainer.new()
	rail.name = "ShopRail"
	rail.anchor_left = 0.0; rail.anchor_right = 1.0
	rail.anchor_top = 0.0; rail.anchor_bottom = 0.18
	rail.offset_left = 4; rail.offset_right = -4
	rail.offset_top = 4; rail.offset_bottom = -4
	rail.add_theme_constant_override(&"separation", 4)
	add_child(rail)
	for i in SHOP_SLOTS:
		var slot := _make_shop_slot(i)
		rail.add_child(slot)
		_shop_slots.append(slot)

func _build_hero_rows() -> void:
	var rows_container := VBoxContainer.new()
	rows_container.name = "HeroRows"
	rows_container.anchor_left = 0.0; rows_container.anchor_right = 1.0
	rows_container.anchor_top = 0.2; rows_container.anchor_bottom = 1.0
	rows_container.offset_left = 4; rows_container.offset_right = -4
	rows_container.offset_top = 0; rows_container.offset_bottom = -4
	rows_container.add_theme_constant_override(&"separation", 4)
	add_child(rows_container)
	for i in MAX_HEROES:
		var row := _make_hero_row(i)
		rows_container.add_child(row)
		_hero_rows.append(row)

func _make_shop_slot(idx: int) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = "ShopSlot%d" % idx
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var lbl := Label.new()
	lbl.name = "SlotLabel"
	lbl.text = "--"
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.add_theme_font_size_override(&"font_size", 10)
	panel.add_child(lbl)
	var btn := Button.new()
	btn.name = "TapArea"
	btn.flat = true
	btn.anchor_left = 0.0; btn.anchor_right = 1.0
	btn.anchor_top = 0.0; btn.anchor_bottom = 1.0
	btn.offset_left = 0; btn.offset_right = 0
	btn.offset_top = 0; btn.offset_bottom = 0
	btn.pressed.connect(func(): shop_item_tapped.emit(idx))
	panel.add_child(btn)
	return panel

func _make_hero_row(hero_idx: int) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.name = "HeroRow%d" % hero_idx
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override(&"separation", 6)

	## Portrait placeholder
	var portrait := ColorRect.new()
	portrait.name = "Portrait"
	portrait.custom_minimum_size = Vector2(48, 48)
	portrait.color = Color(0.2, 0.2, 0.4)
	row.add_child(portrait)

	## Sockets
	for s in MAX_SOCKETS:
		var sock := _make_socket(hero_idx, s)
		row.add_child(sock)

	## HP bar
	var hp_bar := ProgressBar.new()
	hp_bar.name = "HPBar"
	hp_bar.min_value = 0; hp_bar.max_value = 100; hp_bar.value = 100
	hp_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hp_bar.custom_minimum_size = Vector2(0, 8)
	row.add_child(hp_bar)

	## Ult bar (3 pips)
	var ult_hbox := HBoxContainer.new()
	ult_hbox.name = "UltBar"
	for p in 3:
		var pip := ColorRect.new()
		pip.name = "Pip%d" % p
		pip.custom_minimum_size = Vector2(10, 10)
		pip.color = Color(0.3, 0.3, 0.3)
		ult_hbox.add_child(pip)
	row.add_child(ult_hbox)

	return row

func _make_socket(hero_idx: int, sock_idx: int) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = "Socket%d_%d" % [hero_idx, sock_idx]
	panel.custom_minimum_size = Vector2(36, 36)
	var lbl := Label.new()
	lbl.name = "FnLabel"
	lbl.text = "·"
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.add_theme_font_size_override(&"font_size", 9)
	panel.add_child(lbl)
	var btn := Button.new()
	btn.name = "TapArea"
	btn.flat = true
	btn.anchor_left = 0.0; btn.anchor_right = 1.0
	btn.anchor_top = 0.0; btn.anchor_bottom = 1.0
	btn.offset_left = 0; btn.offset_right = 0
	btn.offset_top = 0; btn.offset_bottom = 0
	btn.pressed.connect(func(): socket_tapped.emit(hero_idx, sock_idx))
	panel.add_child(btn)
	return panel

## Update shop rail with up to 7 items.
func populate_shop(items: Array) -> void:
	_shop_items = items
	for i in SHOP_SLOTS:
		var lbl: Label = _shop_slots[i].get_node("SlotLabel")
		if i < items.size():
			lbl.text = str(items[i].get("id", "?"))
		else:
			lbl.text = "--"

## Update hero row HP bar.
func set_hero_hp(hero_idx: int, hp: int, max_hp: int) -> void:
	if hero_idx >= _hero_rows.size():
		return
	var bar: ProgressBar = _hero_rows[hero_idx].get_node("HPBar")
	bar.max_value = max(max_hp, 1)
	bar.value = hp

## Update hero Ult bar pip colors.
func set_hero_ult_bars(hero_idx: int, filled: int) -> void:
	if hero_idx >= _hero_rows.size():
		return
	var ult_bar: HBoxContainer = _hero_rows[hero_idx].get_node("UltBar")
	for p in 3:
		var pip: ColorRect = ult_bar.get_node("Pip%d" % p)
		pip.color = Color(0.9, 0.7, 0.1) if p < filled else Color(0.3, 0.3, 0.3)

## Update socket label for a hero+socket.
func set_socket_fn(hero_idx: int, sock_idx: int, fn_id: StringName) -> void:
	if hero_idx >= _hero_rows.size():
		return
	var sock: PanelContainer = _hero_rows[hero_idx].get_node("Socket%d_%d" % [hero_idx, sock_idx])
	if sock == null:
		return
	sock.get_node("FnLabel").text = str(fn_id) if fn_id != &"" else "·"
