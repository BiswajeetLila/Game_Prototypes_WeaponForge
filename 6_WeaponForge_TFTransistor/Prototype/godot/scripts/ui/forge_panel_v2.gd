## ForgePanel_v2 — weapon rail (3 heroes) on TOP, shop rail (7 slots) on the BOTTOM,
## Gold + Re-roll + START footer at the very bottom. Matches Forge_State_edits.jpg:
## each hero row = portrait + 3 socket cards + a one-line weapon description UNDER the
## sockets + a "Reserve" bench of 2 slots on the right. (No right-side tooltip column;
## HP lives on the battle scene.) Placeholder art, functional.
extends Control

const MAX_HEROES: int = 3
const MAX_SOCKETS: int = 3
const MAX_RESERVE: int = 2
const SHOP_SLOTS: int = 7
const LONG_PRESS_MS: int = 500  ## hold this long on an occupied slot to SELL (else = tap)
## Canonical socket index: 0=PASSIVE, 1=MODIFIER, 2=ACTIVE (visual L->R == ascending index).
const SOCKET_LABELS: Array = ["PASSIVE", "MODIFIER", "ACTIVE"]
const HERO_NAMES: Array = ["Elara", "Bran", "Vex"]
const HERO_TEX: Array = [
	"res://assets/generated/heroes/elara_mage.png",
	"res://assets/generated/heroes/bran_warrior.png",
	"res://assets/generated/heroes/vex_rogue.png",
]
const RUNE_TEX: Dictionary = {
	"FIRE": "res://assets/generated/parts/r_fire.png",
	"WATER": "res://assets/generated/parts/r_ice.png",
	"LIGHTNING": "res://assets/generated/runes/r_lightning.png",
	"AOE": "res://assets/generated/runes/r_aoe.png",
	"LEECH": "res://assets/generated/runes/r_leech.png",
	"BURST": "res://assets/generated/runes/r_burst.png",
	"BOUNCE": "res://assets/generated/runes/r_bounce.png",
}

func _rune_tex(fn_id) -> Texture2D:
	var p: String = String(RUNE_TEX.get(String(fn_id), ""))
	if p != "" and ResourceLoader.exists(p):
		return load(p) as Texture2D
	return null

func _make_icon() -> TextureRect:
	var icon := TextureRect.new()
	icon.name = "Icon"
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return icon

## Emitted when player taps a socket to assign/swap a function.
signal socket_tapped(hero_idx: int, socket_idx: int)
## Emitted when player taps a shop item to select it for placement.
signal shop_item_tapped(slot_idx: int)
## Emitted when player taps a reserve (bench) slot to pick its item up.
signal reserve_tapped(hero_idx: int, reserve_idx: int)
## Emitted on a long-press of an occupied socket -> sell the Function.
signal socket_sell(hero_idx: int, socket_idx: int)
## Emitted on a long-press of an occupied reserve slot -> sell the benched Function.
signal reserve_sell(hero_idx: int, reserve_idx: int)
## Emitted when player taps the Re-roll button.
signal reroll_tapped()
## Emitted when player taps START NEXT WAVE (in the footer).
signal start_next_wave()

var _hero_rows: Array = []   ## 3 HeroRow containers (HBoxContainer)
var _shop_slots: Array = []  ## 7 PanelContainer nodes for shop items
var _shop_items: Array = []  ## Array[Dictionary] — current shop inventory
var _compact: bool = false   ## combat = compact rail; forge break = expanded
var _press_ms: Dictionary = {}  ## gesture: slot key -> press-start ms (tap vs long-press)

func _ready() -> void:
	_build_socket_header()
	_build_hero_rows()
	_build_shop_rail()
	_build_shop_footer()

## ---- top: column header (A/M/P over the sockets + "Reserve" over the bench) ----

func _build_socket_header() -> void:
	var header := HBoxContainer.new()
	header.name = "SocketHeader"
	header.anchor_left = 0.0; header.anchor_right = 1.0
	header.anchor_top = 0.0; header.anchor_bottom = 0.06
	header.offset_left = 60; header.offset_right = -96
	header.add_theme_constant_override(&"separation", 6)
	add_child(header)
	for s in MAX_SOCKETS:
		var lbl := Label.new()
		lbl.text = SOCKET_LABELS[s]
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lbl.add_theme_font_size_override(&"font_size", 9)
		header.add_child(lbl)

	var reserve_lbl := Label.new()
	reserve_lbl.name = "ReserveHeader"
	reserve_lbl.text = "Reserve"
	reserve_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reserve_lbl.add_theme_font_size_override(&"font_size", 9)
	reserve_lbl.modulate = Color(1, 1, 1, 0.7)
	reserve_lbl.anchor_left = 1.0; reserve_lbl.anchor_right = 1.0
	reserve_lbl.offset_left = -100; reserve_lbl.offset_right = -14; reserve_lbl.offset_top = 2
	add_child(reserve_lbl)

## ---- weapon rail (3 hero rows) ----

func _build_hero_rows() -> void:
	var rows_container := VBoxContainer.new()
	rows_container.name = "HeroRows"
	rows_container.anchor_left = 0.0; rows_container.anchor_right = 1.0
	rows_container.anchor_top = 0.07; rows_container.anchor_bottom = 0.80
	rows_container.offset_left = 4; rows_container.offset_right = -16
	rows_container.offset_top = 0; rows_container.offset_bottom = -2
	rows_container.add_theme_constant_override(&"separation", 4)
	add_child(rows_container)
	for i in MAX_HEROES:
		var row := _make_hero_row(i)
		rows_container.add_child(row)
		_hero_rows.append(row)

## ---- shop rail (BOTTOM) ----

func _build_shop_rail() -> void:
	var rail := HBoxContainer.new()
	rail.name = "ShopRail"
	rail.anchor_left = 0.0; rail.anchor_right = 1.0
	rail.anchor_top = 0.80; rail.anchor_bottom = 0.90
	rail.offset_left = 4; rail.offset_right = -4
	rail.offset_top = 2; rail.offset_bottom = -2
	rail.add_theme_constant_override(&"separation", 4)
	add_child(rail)
	for i in SHOP_SLOTS:
		var slot := _make_shop_slot(i)
		rail.add_child(slot)
		_shop_slots.append(slot)

func _build_shop_footer() -> void:
	var footer := HBoxContainer.new()
	footer.name = "ShopFooter"
	footer.anchor_left = 0.0; footer.anchor_right = 1.0
	footer.anchor_top = 0.905; footer.anchor_bottom = 1.0
	footer.offset_left = 8; footer.offset_right = -8
	footer.add_theme_constant_override(&"separation", 6)
	add_child(footer)

	var gold := Label.new()
	gold.name = "GoldLabel"
	gold.text = "Gold: 0"
	gold.add_theme_font_size_override(&"font_size", 12)
	footer.add_child(gold)

	var reroll := Button.new()
	reroll.name = "RerollBtn"
	reroll.text = "Re-roll"
	reroll.pressed.connect(func(): reroll_tapped.emit())
	footer.add_child(reroll)

	var start := Button.new()
	start.name = "StartNextWaveBtn"
	start.text = "START NEXT WAVE"
	start.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	start.pressed.connect(func(): start_next_wave.emit())
	start.visible = false
	footer.add_child(start)

func _make_shop_slot(idx: int) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = "ShopSlot%d" % idx
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_child(_make_icon())
	var nm := Label.new()
	nm.name = "NameLabel"
	nm.text = ""
	nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nm.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	nm.add_theme_font_size_override(&"font_size", 8)
	nm.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(nm)
	var stars := Label.new()
	stars.name = "TierStars"
	stars.text = ""
	stars.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	stars.add_theme_font_size_override(&"font_size", 8)
	stars.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(stars)
	var cost := Label.new()
	cost.name = "CostLabel"
	cost.text = ""
	cost.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	cost.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	cost.add_theme_font_size_override(&"font_size", 8)
	cost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(cost)
	var btn := Button.new()
	btn.name = "TapArea"
	btn.flat = true
	btn.anchor_left = 0.0; btn.anchor_right = 1.0
	btn.anchor_top = 0.0; btn.anchor_bottom = 1.0
	btn.pressed.connect(func(): shop_item_tapped.emit(idx))
	panel.add_child(btn)
	return panel

func _make_hero_row(hero_idx: int) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.name = "HeroRow%d" % hero_idx
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override(&"separation", 6)

	## portrait (kept a DIRECT child of the row)
	var portrait := TextureRect.new()
	portrait.name = "Portrait"
	portrait.custom_minimum_size = Vector2(48, 48)
	portrait.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var ptex_path: String = HERO_TEX[hero_idx] if hero_idx < HERO_TEX.size() else ""
	if ptex_path != "" and ResourceLoader.exists(ptex_path):
		portrait.texture = load(ptex_path) as Texture2D
	row.add_child(portrait)

	## ult pips (mini, de-emphasised — beside the portrait)
	var ult_hbox := HBoxContainer.new()
	ult_hbox.name = "UltBar"
	ult_hbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ult_hbox.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	ult_hbox.add_theme_constant_override(&"separation", 2)
	for p in 3:
		var pip := ColorRect.new()
		pip.name = "Pip%d" % p
		pip.custom_minimum_size = Vector2(6, 18)
		pip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		pip.color = Color(0.3, 0.3, 0.3)
		ult_hbox.add_child(pip)
	row.add_child(ult_hbox)

	## centre column: 3 socket cards + a one-line weapon description UNDER them
	var mid := VBoxContainer.new()
	mid.name = "MidCol"
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	mid.add_theme_constant_override(&"separation", 2)
	row.add_child(mid)

	var sockets_row := HBoxContainer.new()
	sockets_row.name = "SocketsRow"
	sockets_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sockets_row.add_theme_constant_override(&"separation", 6)
	mid.add_child(sockets_row)
	for s in MAX_SOCKETS:
		sockets_row.add_child(_make_socket(hero_idx, s))

	## weapon description under the sockets (replaces the old right-side tooltip column)
	var tip := Label.new()
	tip.name = "WeaponTooltip"
	tip.text = "Empty weapon"
	tip.add_theme_font_size_override(&"font_size", 9)
	tip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tip.modulate = Color(1, 1, 1, 0.85)
	tip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mid.add_child(tip)

	## reserve bench (2 slots) on the right
	var reserve_col := VBoxContainer.new()
	reserve_col.name = "ReserveCol"
	reserve_col.size_flags_horizontal = Control.SIZE_SHRINK_END
	reserve_col.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	reserve_col.add_theme_constant_override(&"separation", 4)
	row.add_child(reserve_col)
	for r in MAX_RESERVE:
		reserve_col.add_child(_make_reserve_slot(hero_idx, r))

	return row

func _make_socket(hero_idx: int, sock_idx: int) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = "Socket%d_%d" % [hero_idx, sock_idx]
	panel.custom_minimum_size = Vector2(64, 64)
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	panel.add_child(_make_icon())
	var nm := Label.new()
	nm.name = "NameLabel"
	nm.text = SOCKET_LABELS[sock_idx]   ## empty watermark = slot name
	nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nm.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	nm.add_theme_font_size_override(&"font_size", 8)
	nm.modulate = Color(1, 1, 1, 0.4)
	nm.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(nm)
	var stars := Label.new()
	stars.name = "TierStars"
	stars.text = ""
	stars.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stars.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	stars.add_theme_font_size_override(&"font_size", 9)
	stars.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(stars)
	var mg := Label.new()
	mg.name = "MergeLabel"
	mg.text = ""
	mg.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	mg.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	mg.add_theme_font_size_override(&"font_size", 8)
	mg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(mg)
	var btn := Button.new()
	btn.name = "TapArea"
	btn.flat = true
	btn.anchor_left = 0.0; btn.anchor_right = 1.0
	btn.anchor_top = 0.0; btn.anchor_bottom = 1.0
	## tap = equip/select, hold = sell (gesture decided on release)
	btn.button_down.connect(_on_slot_down.bind("s%d_%d" % [hero_idx, sock_idx]))
	btn.button_up.connect(_on_socket_up.bind(hero_idx, sock_idx))
	panel.add_child(btn)
	return panel

func _make_reserve_slot(hero_idx: int, reserve_idx: int) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = "Reserve%d_%d" % [hero_idx, reserve_idx]
	panel.custom_minimum_size = Vector2(38, 38)
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	panel.add_child(_make_icon())
	var nm := Label.new()
	nm.name = "NameLabel"
	nm.text = ""
	nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nm.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	nm.add_theme_font_size_override(&"font_size", 7)
	nm.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(nm)
	var btn := Button.new()
	btn.name = "TapArea"
	btn.flat = true
	btn.anchor_left = 0.0; btn.anchor_right = 1.0
	btn.anchor_top = 0.0; btn.anchor_bottom = 1.0
	btn.button_down.connect(_on_slot_down.bind("r%d_%d" % [hero_idx, reserve_idx]))
	btn.button_up.connect(_on_reserve_up.bind(hero_idx, reserve_idx))
	panel.add_child(btn)
	return panel

## ---- tap-vs-long-press gesture (release-timed) ----

func _on_slot_down(key: String) -> void:
	_press_ms[key] = Time.get_ticks_msec()

func _held_ms(key: String) -> int:
	return Time.get_ticks_msec() - int(_press_ms.get(key, Time.get_ticks_msec()))

func _on_socket_up(hero_idx: int, sock_idx: int) -> void:
	if _held_ms("s%d_%d" % [hero_idx, sock_idx]) >= LONG_PRESS_MS:
		socket_sell.emit(hero_idx, sock_idx)
	else:
		socket_tapped.emit(hero_idx, sock_idx)

func _on_reserve_up(hero_idx: int, reserve_idx: int) -> void:
	if _held_ms("r%d_%d" % [hero_idx, reserve_idx]) >= LONG_PRESS_MS:
		reserve_sell.emit(hero_idx, reserve_idx)
	else:
		reserve_tapped.emit(hero_idx, reserve_idx)

## ---- public API ----

## Update shop rail with up to 7 items (Array of {id:...}).
func populate_shop(items: Array) -> void:
	_shop_items = items
	for i in SHOP_SLOTS:
		var slot: PanelContainer = _shop_slots[i]
		var icon := slot.get_node_or_null("Icon") as TextureRect
		var nm := slot.get_node_or_null("NameLabel") as Label
		var cost := slot.get_node_or_null("CostLabel") as Label
		var stars := slot.get_node_or_null("TierStars") as Label
		if i < items.size() and items[i] != null:
			var it = items[i]
			var fid := String(it.get("id", "?"))
			if icon != null: icon.texture = _rune_tex(fid)
			if nm != null: nm.text = fid
			if cost != null: cost.text = "%dG" % int(it.get("cost", 0))
			if stars != null: stars.text = _stars(int(it.get("tier", 1)))
		else:
			if icon != null: icon.texture = null
			if nm != null: nm.text = ""
			if cost != null: cost.text = ""
			if stars != null: stars.text = ""

func set_gold(amount: int) -> void:
	var g := find_child("GoldLabel", true, false) as Label
	if g != null:
		g.text = "Gold: %d" % amount

## Real-time weapon description (combined P/M/A effect) shown UNDER the hero's sockets.
func set_weapon_desc(hero_idx: int, text: String) -> void:
	if hero_idx >= _hero_rows.size():
		return
	var tip := _hero_rows[hero_idx].find_child("WeaponTooltip", true, false) as Label
	if tip != null:
		tip.text = text if text != "" else "Empty weapon"

func set_compact(c: bool) -> void:
	_compact = c
	var sz := Vector2(40, 40) if c else Vector2(64, 64)
	for h in _hero_rows.size():
		for s in MAX_SOCKETS:
			var sock = _hero_rows[h].find_child("Socket%d_%d" % [h, s], true, false)
			if sock != null:
				sock.custom_minimum_size = sz

func is_compact() -> bool:
	return _compact

func set_hero_ult_bars(hero_idx: int, filled: int) -> void:
	if hero_idx >= _hero_rows.size():
		return
	var ult_bar = _hero_rows[hero_idx].find_child("UltBar", true, false)
	if ult_bar == null:
		return
	for p in 3:
		var pip: ColorRect = ult_bar.get_node_or_null("Pip%d" % p)
		if pip != null:
			pip.color = Color(0.9, 0.7, 0.1) if p < filled else Color(0.3, 0.3, 0.3)

## Socket card: empty fn_id -> slot-name watermark; else icon + name + tier stars + merge.
func set_socket_fn(hero_idx: int, sock_idx: int, fn_id: StringName, tier: int = 1, display_name: String = "", merge_pending: String = "") -> void:
	if hero_idx >= _hero_rows.size():
		return
	var sock = _hero_rows[hero_idx].find_child("Socket%d_%d" % [hero_idx, sock_idx], true, false)
	if sock == null:
		return
	var icon := sock.get_node_or_null("Icon") as TextureRect
	var nm := sock.get_node_or_null("NameLabel") as Label
	var stars := sock.get_node_or_null("TierStars") as Label
	var mg := sock.get_node_or_null("MergeLabel") as Label
	if fn_id == &"":
		if icon != null: icon.texture = null
		if nm != null:
			nm.text = SOCKET_LABELS[sock_idx]
			nm.modulate = Color(1, 1, 1, 0.4)
		if stars != null: stars.text = ""
		if mg != null: mg.text = ""
	else:
		if icon != null: icon.texture = _rune_tex(fn_id)
		if nm != null:
			nm.text = display_name if display_name != "" else String(fn_id)
			nm.modulate = Color(1, 1, 1, 1)
		if stars != null: stars.text = _stars(tier)
		if mg != null: mg.text = merge_pending

## Reserve (bench) slot: empty fn_id -> blank; else icon + short name.
func set_reserve_item(hero_idx: int, reserve_idx: int, fn_id: StringName, tier: int = 1) -> void:
	if hero_idx >= _hero_rows.size():
		return
	var slot = _hero_rows[hero_idx].find_child("Reserve%d_%d" % [hero_idx, reserve_idx], true, false)
	if slot == null:
		return
	var icon := slot.get_node_or_null("Icon") as TextureRect
	var nm := slot.get_node_or_null("NameLabel") as Label
	if fn_id == &"":
		if icon != null: icon.texture = null
		if nm != null: nm.text = ""
	else:
		if icon != null: icon.texture = _rune_tex(fn_id)
		if nm != null: nm.text = String(fn_id)

## Error feedback when an equip is blocked (reserve full): red flash on the hero row.
## (Desktop substitute for the requested haptic vibration.)
func flash_error(hero_idx: int) -> void:
	if hero_idx < 0 or hero_idx >= _hero_rows.size():
		return
	var row: Control = _hero_rows[hero_idx]
	row.modulate = Color(1.0, 0.35, 0.35)
	var t := create_tween()
	t.tween_property(row, "modulate", Color(1, 1, 1, 1), 0.35)

func _stars(tier: int) -> String:
	return "★".repeat(clampi(tier, 0, 5))

func set_reroll_cost(n: int) -> void:
	var rb := find_child("RerollBtn", true, false) as Button
	if rb != null:
		rb.text = "Re-roll %dG" % n

func set_reroll_enabled(enabled: bool) -> void:
	var rb := find_child("RerollBtn", true, false) as Button
	if rb != null:
		rb.disabled = not enabled

func set_next_wave_visible(v: bool) -> void:
	var b := find_child("StartNextWaveBtn", true, false) as Button
	if b != null:
		b.visible = v
