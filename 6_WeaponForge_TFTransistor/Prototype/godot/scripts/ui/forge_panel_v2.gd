## ForgePanel_v2 — weapon rail (3 heroes x 3 sockets + HP + Ult) on TOP,
## shop rail (7 slots) on the BOTTOM, Gold + Re-roll footer at the very bottom.
## Matches In_Battle.png / Forge_State.jpeg layout. Placeholder art, functional.
extends Control

const MAX_HEROES: int = 3
const MAX_SOCKETS: int = 3
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
## Emitted when player taps the Re-roll button.
signal reroll_tapped()

var _hero_rows: Array = []   ## 3 HeroRow containers (HBoxContainer)
var _shop_slots: Array = []  ## 7 PanelContainer nodes for shop items
var _shop_items: Array = []  ## Array[Dictionary] — current shop inventory
var _compact: bool = false   ## combat = compact rail; forge break = expanded

func _ready() -> void:
	_build_socket_header()
	_build_hero_rows()
	_build_shop_rail()
	_build_shop_footer()
	_build_preview_panel()

## ---- C8: per-slot behavior preview (decision 1: show, don't restrict) ----

func _build_preview_panel() -> void:
	var pp := VBoxContainer.new()
	pp.name = "PreviewPanel"
	pp.anchor_left = 0.04; pp.anchor_right = 0.96
	pp.anchor_top = 0.30; pp.anchor_bottom = 0.62
	pp.add_theme_constant_override(&"separation", 2)
	pp.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bg := ColorRect.new()
	bg.name = "Bg"
	bg.color = Color(0.06, 0.05, 0.04, 0.92)
	bg.anchor_right = 1.0; bg.anchor_bottom = 1.0
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pp.add_child(bg)
	for n in ["PreviewTitle", "PassiveRow", "ModifierRow", "ActiveRow", "BestFitLabel"]:
		var lbl := Label.new()
		lbl.name = n
		lbl.add_theme_font_size_override(&"font_size", 10 if n == "PreviewTitle" else 9)
		lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		pp.add_child(lbl)
	add_child(pp)
	pp.visible = false

## Show the 3 per-slot behaviors (order PASSIVE/MODIFIER/ACTIVE) + best-fit badge.
func show_function_preview(fn_id: StringName) -> void:
	var pp := get_node_or_null("PreviewPanel")
	if pp == null:
		return
	var path := "res://data/functions/%s.tres" % String(fn_id).to_lower()
	if not ResourceLoader.exists(path):
		pp.visible = false
		return
	var f = load(path)
	if f == null:
		pp.visible = false
		return
	(pp.get_node("PreviewTitle") as Label).text = String(fn_id)
	(pp.get_node("PassiveRow") as Label).text = "PASSIVE — " + f.describe(0)
	(pp.get_node("ModifierRow") as Label).text = "MODIFIER — " + f.describe(1)
	(pp.get_node("ActiveRow") as Label).text = "ACTIVE — " + f.describe(2)
	(pp.get_node("BestFitLabel") as Label).text = "BEST: " + String(f.best_fit)
	pp.visible = true

## ---- top: socket-column header (cosmetic, matches mockup A/M/P labels) ----

func _build_socket_header() -> void:
	var header := HBoxContainer.new()
	header.name = "SocketHeader"
	header.anchor_left = 0.0; header.anchor_right = 1.0
	header.anchor_top = 0.0; header.anchor_bottom = 0.06
	header.offset_left = 60; header.offset_right = -120
	header.add_theme_constant_override(&"separation", 6)
	add_child(header)
	for s in MAX_SOCKETS:
		var lbl := Label.new()
		lbl.text = SOCKET_LABELS[s]
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lbl.add_theme_font_size_override(&"font_size", 9)
		header.add_child(lbl)

## ---- weapon rail (3 hero rows) ----

func _build_hero_rows() -> void:
	var rows_container := VBoxContainer.new()
	rows_container.name = "HeroRows"
	rows_container.anchor_left = 0.0; rows_container.anchor_right = 1.0
	rows_container.anchor_top = 0.07; rows_container.anchor_bottom = 0.80
	rows_container.offset_left = 4; rows_container.offset_right = -4
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
	rail.anchor_top = 0.82; rail.anchor_bottom = 0.93
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
	footer.anchor_top = 0.94; footer.anchor_bottom = 1.0
	footer.offset_left = 8; footer.offset_right = -8
	add_child(footer)

	var gold := Label.new()
	gold.name = "GoldLabel"
	gold.text = "Gold: 0"
	gold.add_theme_font_size_override(&"font_size", 12)
	gold.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer.add_child(gold)

	var reroll := Button.new()
	reroll.name = "RerollBtn"
	reroll.text = "Re-roll"
	reroll.pressed.connect(func(): reroll_tapped.emit())
	footer.add_child(reroll)

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

	var portrait := TextureRect.new()
	portrait.name = "Portrait"
	portrait.custom_minimum_size = Vector2(48, 48)
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var ptex_path: String = HERO_TEX[hero_idx] if hero_idx < HERO_TEX.size() else ""
	if ptex_path != "" and ResourceLoader.exists(ptex_path):
		portrait.texture = load(ptex_path) as Texture2D
	row.add_child(portrait)

	for s in MAX_SOCKETS:
		var sock := _make_socket(hero_idx, s)
		row.add_child(sock)

	var hp_bar := ProgressBar.new()
	hp_bar.name = "HPBar"
	hp_bar.min_value = 0; hp_bar.max_value = 100; hp_bar.value = 100
	hp_bar.show_percentage = false
	hp_bar.size_flags_horizontal = Control.SIZE_SHRINK_CENTER  ## not expand-fill (kills the "huge bar")
	hp_bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hp_bar.custom_minimum_size = Vector2(84, 14)
	row.add_child(hp_bar)
	var hp_val := Label.new()
	hp_val.name = "HPValue"
	hp_val.add_theme_font_size_override(&"font_size", 9)
	hp_val.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(hp_val)

	var ult_hbox := HBoxContainer.new()
	ult_hbox.name = "UltBar"
	ult_hbox.size_flags_horizontal = Control.SIZE_SHRINK_END
	ult_hbox.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	ult_hbox.add_theme_constant_override(&"separation", 2)
	for p in 3:
		var pip := ColorRect.new()
		pip.name = "Pip%d" % p
		pip.custom_minimum_size = Vector2(12, 12)
		pip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		pip.color = Color(0.3, 0.3, 0.3)
		ult_hbox.add_child(pip)
	row.add_child(ult_hbox)

	return row

func _make_socket(hero_idx: int, sock_idx: int) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = "Socket%d_%d" % [hero_idx, sock_idx]
	panel.custom_minimum_size = Vector2(64, 64)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
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
	btn.pressed.connect(func(): socket_tapped.emit(hero_idx, sock_idx))
	panel.add_child(btn)
	return panel

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

func set_hero_hp(hero_idx: int, hp: int, max_hp: int) -> void:
	if hero_idx >= _hero_rows.size():
		return
	var bar: ProgressBar = _hero_rows[hero_idx].get_node("HPBar")
	bar.max_value = max(max_hp, 1)
	bar.value = hp
	var val := _hero_rows[hero_idx].get_node_or_null("HPValue") as Label
	if val != null:
		val.text = "%d/%d" % [hp, max_hp]

func set_compact(c: bool) -> void:
	_compact = c
	var sz := Vector2(40, 40) if c else Vector2(64, 64)
	for h in _hero_rows.size():
		for s in MAX_SOCKETS:
			var sock = _hero_rows[h].get_node_or_null("Socket%d_%d" % [h, s])
			if sock != null:
				sock.custom_minimum_size = sz
	if c:
		var pp = get_node_or_null("PreviewPanel")
		if pp != null:
			pp.visible = false

func is_compact() -> bool:
	return _compact

func set_hero_ult_bars(hero_idx: int, filled: int) -> void:
	if hero_idx >= _hero_rows.size():
		return
	var ult_bar: HBoxContainer = _hero_rows[hero_idx].get_node("UltBar")
	for p in 3:
		var pip: ColorRect = ult_bar.get_node("Pip%d" % p)
		pip.color = Color(0.9, 0.7, 0.1) if p < filled else Color(0.3, 0.3, 0.3)

## Socket card: empty fn_id -> slot-name watermark; else icon + name + tier stars + merge.
func set_socket_fn(hero_idx: int, sock_idx: int, fn_id: StringName, tier: int = 1, display_name: String = "", merge_pending: String = "") -> void:
	if hero_idx >= _hero_rows.size():
		return
	var sock: PanelContainer = _hero_rows[hero_idx].get_node("Socket%d_%d" % [hero_idx, sock_idx])
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
