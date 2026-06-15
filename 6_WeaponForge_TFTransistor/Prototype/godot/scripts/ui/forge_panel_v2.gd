## ForgePanel_v2 — weapon rail (3 heroes) on TOP, shop rail (7 slots) on the BOTTOM,
## Gold + Re-roll + START footer at the very bottom. Matches Forge_State_edits.jpg:
## each hero row = portrait + 3 socket cards + a one-line weapon description UNDER the
## sockets + a "Reserve" bench of 2 slots on the right. (No right-side tooltip column;
## HP lives on the battle scene.) Placeholder art, functional.
extends Control

const MAX_HEROES: int = 3
const MAX_SOCKETS: int = 3
const MAX_RESERVE: int = 1
const SHOP_SLOTS: int = 7
## Canonical socket index: 0=PASSIVE, 1=MODIFIER, 2=ACTIVE (visual L->R == ascending index).
const SOCKET_LABELS: Array = ["PASSIVE", "MODIFIER", "ACTIVE"]
const HERO_NAMES: Array = ["Elara", "Bran", "Vex"]
const HERO_TEX: Array = [
	"res://assets/generated/heroes/elara_mage.png",
	"res://assets/generated/heroes/bran_warrior.png",
	"res://assets/generated/heroes/vex_rogue.png",
]
const RUNE_TEX: Dictionary = {
	"FIRE": "res://assets/generated/runes/fire.png",
	"WATER": "res://assets/generated/runes/water.png",
	"LIGHTNING": "res://assets/generated/runes/lightning.png",
	"AOE": "res://assets/generated/runes/aoe.png",
	"LEECH": "res://assets/generated/runes/leech.png",
	"BURST": "res://assets/generated/runes/burst.png",
	"BOUNCE": "res://assets/generated/runes/r_bounce.png",
}
## Tier rarity border colors (T1 neutral, T2 blue, T3 purple, T4 gold). One icon per
## Function; the slot frame recolors by tier (no per-tier art).
const TIER_BORDER: Array = [
	Color(0.45, 0.45, 0.5),    ## T1 — neutral
	Color(0.30, 0.62, 0.95),   ## T2 — blue
	Color(0.66, 0.40, 0.92),   ## T3 — purple
	Color(0.95, 0.78, 0.25),   ## T4 — gold
]

func _tier_color(tier: int) -> Color:
	return TIER_BORDER[clampi(tier - 1, 0, TIER_BORDER.size() - 1)]

## Apply a tier-colored rounded border to a slot PanelContainer (rarity frame).
func _apply_tier_border(panel: Control, tier: int) -> void:
	if panel == null:
		return
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.13, 0.14, 0.18, 0.92)
	sb.set_border_width_all(3)
	sb.border_color = _tier_color(tier)
	sb.set_corner_radius_all(8)
	panel.add_theme_stylebox_override(&"panel", sb)

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
## Emitted when player taps a hero's (charged) Ult button.
signal ult_pressed(hero_idx: int)

var _hero_rows: Array = []   ## 3 HeroRow containers (HBoxContainer)
var _shop_slots: Array = []  ## 7 PanelContainer nodes for shop items
var _shop_items: Array = []  ## Array[Dictionary] — current shop inventory
var _compact: bool = false   ## combat = compact rail; forge break = expanded

func _ready() -> void:
	_build_socket_header()
	_build_hero_rows()
	_build_shop_rail()
	_build_shop_footer()

## ---- top: column header (A/M/P over the sockets + "Reserve" over the bench) ----

func _build_socket_header() -> void:
	## slot-type labels (PASSIVE/MODIFIER/ACTIVE) now live UNDER each socket card so
	## they always align with their icon — the old top header was misaligned. Only the
	## Reserve column header remains up top.
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
	panel.clip_contents = true
	_apply_tier_border(panel, 1)
	## icon on TOP, name BELOW (no overlap)
	var col := VBoxContainer.new()
	col.name = "Col"
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override(&"separation", 1)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(col)
	var icon := _make_icon()
	icon.custom_minimum_size = Vector2(34, 34)
	icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	col.add_child(icon)
	var nm := Label.new()
	nm.name = "NameLabel"
	nm.text = ""
	nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nm.add_theme_font_size_override(&"font_size", 8)
	nm.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(nm)
	## cost badge, bottom-right corner
	var cost := Label.new()
	cost.name = "CostLabel"
	cost.text = ""
	cost.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	cost.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	cost.add_theme_font_size_override(&"font_size", 8)
	cost.modulate = Color(1.0, 0.85, 0.35)
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

	## Ult button beside the portrait — a vertical bar that FILLS as the meter charges
	## (3 reactions per bar). Enabled + bright only when full; tap to fire.
	var ult_btn := Button.new()
	ult_btn.name = "UltBar"  ## node name kept for set_hero_ult_bars()
	ult_btn.custom_minimum_size = Vector2(22, 46)
	ult_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	ult_btn.clip_contents = true
	ult_btn.disabled = true
	ult_btn.tooltip_text = "Ult — charges from reactions"
	var fill := ColorRect.new()
	fill.name = "Fill"
	fill.color = Color(0.95, 0.75, 0.15, 0.9)
	fill.anchor_left = 0.0; fill.anchor_right = 1.0
	fill.anchor_top = 1.0; fill.anchor_bottom = 1.0   ## empty (zero height) until charged
	fill.offset_left = 0; fill.offset_right = 0; fill.offset_top = 0; fill.offset_bottom = 0
	fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ult_btn.add_child(fill)
	var ult_lbl := Label.new()
	ult_lbl.name = "UltLabel"
	ult_lbl.text = "ULT"
	ult_lbl.add_theme_font_size_override(&"font_size", 8)
	ult_lbl.anchor_left = 0.0; ult_lbl.anchor_right = 1.0
	ult_lbl.anchor_top = 0.0; ult_lbl.anchor_bottom = 1.0
	ult_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ult_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	ult_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ult_btn.add_child(ult_lbl)
	ult_btn.pressed.connect(func(): ult_pressed.emit(hero_idx))
	row.add_child(ult_btn)

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

	## reserve bench (1 slot) on the right
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
	panel.clip_contents = true
	_apply_tier_border(panel, 1)
	## icon on TOP, label BELOW (no text overlaid on the icon)
	var col := VBoxContainer.new()
	col.name = "Col"
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override(&"separation", 1)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(col)
	var icon := _make_icon()
	icon.custom_minimum_size = Vector2(34, 34)
	icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	col.add_child(icon)
	var nm := Label.new()
	nm.name = "NameLabel"
	nm.text = SOCKET_LABELS[sock_idx]   ## empty -> slot name; filled -> function name
	nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nm.add_theme_font_size_override(&"font_size", 8)
	nm.modulate = Color(1, 1, 1, 0.4)
	nm.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(nm)
	## tier stars + merge marker as small CORNER overlays (not over the icon center)
	var stars := Label.new()
	stars.name = "TierStars"
	stars.text = ""
	stars.add_theme_font_size_override(&"font_size", 8)
	stars.anchor_top = 0.0; stars.offset_left = 3; stars.offset_top = 1
	stars.modulate = Color(1.0, 0.85, 0.3)
	stars.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(stars)
	var mg := Label.new()
	mg.name = "MergeLabel"
	mg.text = ""
	mg.add_theme_font_size_override(&"font_size", 8)
	mg.anchor_left = 1.0; mg.anchor_right = 1.0
	mg.offset_left = -22; mg.offset_right = -2; mg.offset_top = 1
	mg.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	mg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(mg)
	var btn := Button.new()
	btn.name = "TapArea"
	btn.flat = true
	btn.anchor_left = 0.0; btn.anchor_right = 1.0
	btn.anchor_top = 0.0; btn.anchor_bottom = 1.0
	## single tap = pick up / drop; double-click = sell
	btn.pressed.connect(func(): socket_tapped.emit(hero_idx, sock_idx))
	btn.gui_input.connect(_on_tile_gui.bind("socket", hero_idx, sock_idx))
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
	## single tap = pick up / drop; double-click = sell
	btn.pressed.connect(func(): reserve_tapped.emit(hero_idx, reserve_idx))
	btn.gui_input.connect(_on_tile_gui.bind("reserve", hero_idx, reserve_idx))
	panel.add_child(btn)
	return panel

## ---- double-click = sell (single click already fired tapped via `pressed`) ----

func _on_tile_gui(event: InputEvent, kind: String, hero_idx: int, idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and event.double_click:
		if kind == "socket":
			socket_sell.emit(hero_idx, idx)
		else:
			reserve_sell.emit(hero_idx, idx)

## ---- public API ----

## Update shop rail with up to 7 items (Array of {id:...}).
func populate_shop(items: Array) -> void:
	_shop_items = items
	for i in SHOP_SLOTS:
		var slot: PanelContainer = _shop_slots[i]
		var icon := slot.find_child("Icon", true, false) as TextureRect
		var nm := slot.find_child("NameLabel", true, false) as Label
		var cost := slot.find_child("CostLabel", true, false) as Label
		if i < items.size() and items[i] != null:
			var it = items[i]
			var fid := String(it.get("id", "?"))
			if icon != null: icon.texture = _rune_tex(fid)
			if nm != null: nm.text = fid
			if cost != null: cost.text = "%dG" % int(it.get("cost", 0))
			_apply_tier_border(slot, int(it.get("tier", 1)))  ## rarity frame by tier
		else:
			if icon != null: icon.texture = null
			if nm != null: nm.text = ""
			if cost != null: cost.text = ""
			_apply_tier_border(slot, 1)

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
				## socket name-below shows in forge only (icon-only in compact combat rail)
				var snm = sock.find_child("NameLabel", true, false)
				if snm != null:
					snm.visible = not c
		## weapon description text shows only in the forge (declutter combat)
		var tip = _hero_rows[h].find_child("WeaponTooltip", true, false)
		if tip != null:
			tip.visible = not c
	## re-roll is useless mid-combat -> forge only
	var rb := find_child("RerollBtn", true, false) as Button
	if rb != null:
		rb.visible = not c

func is_compact() -> bool:
	return _compact

## Ult charge 0..3 -> fill fraction; full (3) -> button enabled + bright + "ULT!".
func set_hero_ult_bars(hero_idx: int, filled: int) -> void:
	if hero_idx >= _hero_rows.size():
		return
	var ult_bar = _hero_rows[hero_idx].find_child("UltBar", true, false)
	if ult_bar == null:
		return
	var frac: float = clampf(float(filled) / 3.0, 0.0, 1.0)
	var fill := ult_bar.get_node_or_null("Fill") as Control
	if fill != null:
		fill.anchor_top = 1.0 - frac  ## grows up from the bottom
		fill.offset_top = 0
	var ready: bool = filled >= 1  ## fire at >=1 bar, consume 1 (spec §12.4)
	if ult_bar is Button:
		ult_bar.disabled = not ready
	ult_bar.modulate = Color(1, 1, 1, 1) if ready else Color(0.75, 0.75, 0.75, 1)
	var lbl := ult_bar.get_node_or_null("UltLabel") as Label
	if lbl != null:
		lbl.text = "ULT!" if ready else "ULT"

## Socket card: empty fn_id -> slot-name watermark; else icon + name + tier stars + merge.
func set_socket_fn(hero_idx: int, sock_idx: int, fn_id: StringName, tier: int = 1, display_name: String = "", merge_pending: String = "") -> void:
	if hero_idx >= _hero_rows.size():
		return
	var sock = _hero_rows[hero_idx].find_child("Socket%d_%d" % [hero_idx, sock_idx], true, false)
	if sock == null:
		return
	var icon := sock.find_child("Icon", true, false) as TextureRect
	var nm := sock.find_child("NameLabel", true, false) as Label
	var stars := sock.find_child("TierStars", true, false) as Label
	var mg := sock.find_child("MergeLabel", true, false) as Label
	if fn_id == &"":
		if icon != null: icon.texture = null
		if nm != null:
			nm.text = SOCKET_LABELS[sock_idx]
			nm.modulate = Color(1, 1, 1, 0.4)
		if stars != null: stars.text = ""
		if mg != null: mg.text = ""
		_apply_tier_border(sock, 1)  ## empty -> neutral frame
	else:
		if icon != null: icon.texture = _rune_tex(fn_id)
		if nm != null:
			nm.text = display_name if display_name != "" else String(fn_id)
			nm.modulate = Color(1, 1, 1, 1)
		if stars != null: stars.text = _stars(tier)
		if mg != null: mg.text = merge_pending
		_apply_tier_border(sock, tier)  ## rarity frame by tier (none/blue/purple/gold)

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

## Juicy merge: a sparkle burst + scale-pop on the merged socket card.
func play_merge_vfx(hero_idx: int, sock_idx: int) -> void:
	if hero_idx < 0 or hero_idx >= _hero_rows.size():
		return
	var sock := _hero_rows[hero_idx].find_child("Socket%d_%d" % [hero_idx, sock_idx], true, false) as Control
	if sock == null:
		return
	sock.pivot_offset = sock.size * 0.5
	var pop := create_tween()
	pop.tween_property(sock, "scale", Vector2(1.25, 1.25), 0.10)
	pop.tween_property(sock, "scale", Vector2(1.0, 1.0), 0.14)
	var path := "res://assets/generated/vfx/merge_sparkle.png"
	if not ResourceLoader.exists(path):
		return
	var spr := TextureRect.new()
	spr.name = "MergeVfx"
	spr.texture = load(path)
	spr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	spr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	spr.anchor_left = 0.0; spr.anchor_right = 1.0; spr.anchor_top = 0.0; spr.anchor_bottom = 1.0
	spr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sock.add_child(spr)
	var tw := create_tween()
	tw.tween_property(spr, "modulate:a", 0.0, 0.5)
	tw.tween_callback(spr.queue_free)

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
