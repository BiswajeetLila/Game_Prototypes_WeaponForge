## ForgePanel — between-wave forge moment UI (3-hero vertical layout).
##
## All 3 heroes are shown at once as stacked rows (vertical-UI reskin). Each row:
##   [ portrait + HP/Ult bars + ATK pill + Ult btn ]  [ head · rune · body slots ]  [ recipe chips ]
## Locked heroes (not yet recruited) render as a greyed shell with no info.
##
## Equip flow (prototype "shop→slot"): tap a shop tile (or inventory card) to
## ARM it — compatible empty slots across every row highlight. Tap a highlighted
## slot to equip to THAT hero. Tap a filled slot (nothing armed) to sell it back.
## Tap the armed tile again to disarm.
##
## Shop / gold / inventory stay global. Slot labels are weapon-anatomy per class
## (Hilt/Shaft/Grip · Rune · Blade/Orb/Fang) via SlotLabels.
##
## Signals wave_start_requested when the player taps Start Wave.
extends Control

const PartCardScene = preload("res://scenes/PartCard.tscn")
const SlotLabels = preload("res://scripts/ui/slot_labels.gd")
const InventoryItemT = preload("res://scripts/data/inventory_item.gd")

## Fixed display roster (always 3 rows; unlocked → full, else locked shell).
const ROSTER: Array = [&"bran", &"elara", &"vex"]
const SLOT_ORDER: Array = [&"head", &"rune", &"body"]

## Compacted card footprints (default PartCard is 78x108 — too tall to fit 3
## hero rows + shop + START WAVE on a phone screen). Anvil cards skip the cost
## label so they shrink further; shop cards keep a little more height for cost.
const ANVIL_CARD_SIZE := Vector2(66, 80)
const SHOP_CARD_SIZE  := Vector2(66, 90)
const PORTRAIT_SIZE   := Vector2(44, 44)

## Per-class accent ring colour for the portrait.
const ACCENT: Dictionary = {
	&"bran": Color(0.878, 0.635, 0.235, 1),   ## warrior gold
	&"elara": Color(0.345, 0.773, 0.910, 1),  ## mage cyan
	&"vex": Color(0.608, 0.424, 0.941, 1),    ## rogue purple
}
const HP_FILL  := Color(0.373, 0.761, 0.290, 1)   ## green
const ULT_FILL := Color(0.184, 0.608, 0.878, 1)   ## blue
const BAR_BG   := Color(0.141, 0.090, 0.063, 1)

## Reroll button styling — muted orange.
const REROLL_BG     := Color(0.776, 0.502, 0.235, 1)
const REROLL_HOVER  := Color(0.851, 0.580, 0.314, 1)
const REROLL_BORDER := Color(0.388, 0.235, 0.075, 1)
const REROLL_TEXT   := Color(1.000, 0.965, 0.871, 1)

@onready var _hero_rows: VBoxContainer = %HeroRows
@onready var _shop_grid: HBoxContainer = %ShopGrid
@onready var _reroll_btn: Button = %RerollBtn
@onready var _gold_label: Label = %GoldLabel
@onready var _inventory_strip: HBoxContainer = %InventoryStrip
@onready var _start_wave_btn: Button = %StartWaveBtn
@onready var _empty_inv_label: Label = %EmptyInvLabel

signal wave_start_requested

## Armed supply selection awaiting a slot click.
## null, or { source: "shop"/"inventory", payload: idx-or-item, slot: StringName }
var _armed = null

func _ready() -> void:
	GameState.shop_changed.connect(_rebuild_shop)
	GameState.inventory_changed.connect(_rebuild_inventory)
	GameState.weapon_changed.connect(func(_hid): _rebuild_rows())
	GameState.gold_changed.connect(_on_gold_changed)
	GameState.hero_unlocked.connect(func(_hid): _rebuild_rows())
	_reroll_btn.pressed.connect(_on_reroll_pressed)
	_apply_reroll_style()
	_start_wave_btn.pressed.connect(func(): emit_signal(&"wave_start_requested"))
	_rebuild_all()

func _apply_reroll_style() -> void:
	var sb := StyleBoxFlat.new()
	sb.bg_color = REROLL_BG
	sb.border_color = REROLL_BORDER
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(6)
	var sb_hover := sb.duplicate() as StyleBoxFlat
	sb_hover.bg_color = REROLL_HOVER
	_reroll_btn.add_theme_stylebox_override(&"normal", sb)
	_reroll_btn.add_theme_stylebox_override(&"hover", sb_hover)
	_reroll_btn.add_theme_stylebox_override(&"pressed", sb)
	_reroll_btn.add_theme_stylebox_override(&"focus", sb)
	_reroll_btn.add_theme_color_override(&"font_color", REROLL_TEXT)
	_reroll_btn.add_theme_color_override(&"font_hover_color", REROLL_TEXT)

## ---------- Public ----------

func refresh_forge_moment() -> void:
	Shop.refresh(true)
	_armed = null
	_rebuild_all()

## ---------- Rebuild dispatch ----------

func _rebuild_all() -> void:
	_rebuild_rows()
	_rebuild_shop()
	_rebuild_inventory()
	_on_gold_changed(GameState.gold)

func _on_gold_changed(new_gold: int) -> void:
	_reroll_btn.disabled = new_gold < Shop.REROLL_COST
	_reroll_btn.text = "🔄 Reroll (🪙%d)" % Shop.REROLL_COST
	_gold_label.text = "🪙 %d" % new_gold

## ---------- Hero rows ----------

func _rebuild_rows() -> void:
	for child in _hero_rows.get_children():
		child.queue_free()
	for hid in ROSTER:
		var hero = GameState.get_hero(hid)
		if hero == null:
			_build_locked_row(hid)
		else:
			_build_hero_row(hid, hero)

func _build_hero_row(hid: StringName, hero) -> void:
	var cls: StringName = hero.data.cls
	var accent: Color = ACCENT.get(hid, Color(0.85, 0.85, 0.85))

	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override(&"panel", _row_style(accent, false))
	## Attach to the tree FIRST so child PartCards' @onready refs resolve when
	## they are added below (cards self-configure on tree entry).
	_hero_rows.add_child(panel)

	var row := HBoxContainer.new()
	row.add_theme_constant_override(&"separation", 8)
	panel.add_child(row)

	# --- Left column: portrait + bars + atk/ult ---
	var col := VBoxContainer.new()
	col.custom_minimum_size = Vector2(78, 0)
	col.add_theme_constant_override(&"separation", 2)
	row.add_child(col)

	var portrait := TextureRect.new()
	portrait.custom_minimum_size = PORTRAIT_SIZE
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if hero.data.portrait != null:
		portrait.texture = hero.data.portrait
	var pwrap := PanelContainer.new()
	pwrap.add_theme_stylebox_override(&"panel", _portrait_style(accent))
	pwrap.add_child(portrait)
	col.add_child(pwrap)

	var hp_ratio: float = (float(hero.hp) / float(hero.max_hp)) if hero.max_hp > 0 else 0.0
	var ult_ratio: float = clampf(float(hero.ult_gauge) / 100.0, 0.0, 1.0)
	col.add_child(_make_bar(hp_ratio, HP_FILL, 6))
	col.add_child(_make_bar(ult_ratio, ULT_FILL, 5))

	var tagrow := HBoxContainer.new()
	tagrow.add_theme_constant_override(&"separation", 4)
	tagrow.add_child(_atk_pill(hero.weapon.get_atk()))
	tagrow.add_child(_ult_btn())
	col.add_child(tagrow)

	# --- Right column: slots + recipe chips ---
	var right := VBoxContainer.new()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.add_theme_constant_override(&"separation", 3)
	row.add_child(right)

	var slots := HBoxContainer.new()
	slots.alignment = BoxContainer.ALIGNMENT_CENTER
	slots.add_theme_constant_override(&"separation", 6)
	right.add_child(slots)
	for slot in SLOT_ORDER:
		var item = hero.weapon.get_slot(slot)
		var card = PartCardScene.instantiate()
		card.custom_minimum_size = ANVIL_CARD_SIZE
		slots.add_child(card)
		card.setup_anvil(item, slot)
		card.set_slot_label_override(SlotLabels.label(cls, slot))
		_apply_arm_highlight(card, slot, item)
		card.clicked.connect(_on_anvil_clicked.bind(hid))

	right.add_child(_build_recipe_chips(hero))

func _build_locked_row(hid: StringName) -> void:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override(&"panel", _row_style(Color(0.4, 0.4, 0.4), true))
	panel.modulate = Color(1, 1, 1, 0.55)
	_hero_rows.add_child(panel)

	var row := HBoxContainer.new()
	row.add_theme_constant_override(&"separation", 8)
	panel.add_child(row)

	var q := Label.new()
	q.text = "❔"
	q.custom_minimum_size = Vector2(66, 40)
	q.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	q.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	q.add_theme_font_size_override(&"font_size", 30)
	row.add_child(q)

	var cap := Label.new()
	cap.text = "🔒 Locked — recruit to deploy"
	cap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cap.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	cap.add_theme_font_size_override(&"font_size", 11)
	cap.add_theme_color_override(&"font_color", Color(0.6, 0.55, 0.45))
	row.add_child(cap)

## ---------- Row sub-widgets ----------

func _row_style(accent: Color, locked: bool) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.165, 0.106, 0.063, 1) if not locked else Color(0.13, 0.12, 0.11, 1)
	sb.border_color = accent
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(10)
	sb.set_content_margin_all(6)
	return sb

func _portrait_style(accent: Color) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.082, 0.063, 0.047, 1)
	sb.border_color = accent
	sb.set_border_width_all(3)
	sb.set_corner_radius_all(25)
	return sb

func _make_bar(ratio: float, fill: Color, h: int) -> Control:
	var bar := ProgressBar.new()
	bar.custom_minimum_size = Vector2(60, h)
	bar.show_percentage = false
	bar.min_value = 0.0
	bar.max_value = 1.0
	bar.value = clampf(ratio, 0.0, 1.0)
	var bg := StyleBoxFlat.new()
	bg.bg_color = BAR_BG
	bg.set_corner_radius_all(3)
	var fg := StyleBoxFlat.new()
	fg.bg_color = fill
	fg.set_corner_radius_all(3)
	bar.add_theme_stylebox_override(&"background", bg)
	bar.add_theme_stylebox_override(&"fill", fg)
	return bar

func _atk_pill(atk: int) -> Control:
	var pill := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.949, 0.722, 0.235, 1)
	sb.set_corner_radius_all(9)
	sb.set_content_margin_all(1)
	sb.content_margin_left = 7
	sb.content_margin_right = 7
	pill.add_theme_stylebox_override(&"panel", sb)
	var lbl := Label.new()
	lbl.text = "⚔ %d" % atk
	lbl.add_theme_font_size_override(&"font_size", 11)
	lbl.add_theme_color_override(&"font_color", Color(0.165, 0.102, 0.031))
	pill.add_child(lbl)
	return pill

func _ult_btn() -> Control:
	var b := Button.new()
	b.text = "⚡"
	b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_size_override(&"font_size", 11)
	var sb := StyleBoxFlat.new()
	sb.bg_color = ULT_FILL
	sb.set_corner_radius_all(9)
	sb.set_content_margin_all(1)
	sb.content_margin_left = 6
	sb.content_margin_right = 6
	b.add_theme_stylebox_override(&"normal", sb)
	b.add_theme_stylebox_override(&"hover", sb)
	b.add_theme_stylebox_override(&"pressed", sb)
	b.add_theme_color_override(&"font_color", Color(0.918, 0.965, 1))
	return b

func _build_recipe_chips(hero) -> Control:
	var box := HBoxContainer.new()
	box.add_theme_constant_override(&"separation", 4)
	if hero.weapon == null:
		return box
	for recipe_id in Recipes.get_active_recipes(hero.weapon):
		var rec = GameState.get_recipe_def(recipe_id)
		if rec == null:
			continue
		var pill := PanelContainer.new()
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color(0.416, 0.227, 0.651, 1)
		sb.border_color = Color(0.85, 0.65, 1, 1)
		sb.set_border_width_all(1)
		sb.set_corner_radius_all(6)
		sb.content_margin_left = 7
		sb.content_margin_right = 7
		sb.content_margin_top = 1
		sb.content_margin_bottom = 1
		pill.add_theme_stylebox_override(&"panel", sb)
		var chip := Label.new()
		chip.text = rec.name
		chip.add_theme_font_size_override(&"font_size", 10)
		chip.add_theme_color_override(&"font_color", Color(1, 1, 1))
		chip.tooltip_text = "%s\n%s" % [rec.name, rec.desc]
		pill.add_child(chip)
		box.add_child(pill)
	return box

## ---------- Shop ----------

func _rebuild_shop() -> void:
	for child in _shop_grid.get_children():
		child.queue_free()
	for i in range(GameState.shop_parts.size()):
		var part_id = GameState.shop_parts[i]
		var card = PartCardScene.instantiate()
		card.custom_minimum_size = SHOP_CARD_SIZE
		_shop_grid.add_child(card)
		if part_id == null or part_id == &"":
			card.setup_anvil(null, &"")
			card.modulate = Color(0.5, 0.5, 0.5, 0.6)
		else:
			card.setup_shop(part_id, i)
			if _armed != null and _armed.source == &"shop" and int(_armed.payload) == i:
				card.modulate = Color(1.35, 1.25, 0.7)  ## armed tile glows
			card.clicked.connect(_on_supply_clicked)

func _on_reroll_pressed() -> void:
	_armed = null
	Shop.reroll()

## ---------- Inventory ----------

func _rebuild_inventory() -> void:
	for child in _inventory_strip.get_children():
		if child == _empty_inv_label:
			continue
		child.queue_free()
	_empty_inv_label.visible = GameState.inventory.is_empty()
	for item in GameState.inventory:
		var card = PartCardScene.instantiate()
		_inventory_strip.add_child(card)
		card.setup_inventory(item)
		card.clicked.connect(_on_supply_clicked)

## ---------- Equip flow (armed shop→slot) ----------

func _slot_of(part_id: StringName) -> StringName:
	var def = GameState.get_part_def(part_id)
	return def.slot if def != null else &""

## A shop tile or inventory card was tapped → arm it (or disarm if re-tapped).
func _on_supply_clicked(_card, mode: StringName, payload) -> void:
	var part_id: StringName
	if mode == &"shop":
		part_id = GameState.shop_parts[int(payload)]
	else:
		part_id = payload.part_id
	if part_id == null or part_id == &"":
		return
	# Affordability gate — shop tiles cost gold. If the player can't afford this
	# part, don't arm it: flash the gold counter red + shake it instead.
	if mode == &"shop":
		var def = GameState.get_part_def(part_id)
		if def != null and GameState.gold < def.cost:
			_flash_gold_insufficient()
			return
	# Re-tapping the armed source disarms.
	if _armed != null and _armed.source == mode and _armed.payload == payload:
		_armed = null
	else:
		_armed = {"source": mode, "payload": payload, "slot": _slot_of(part_id)}
	_rebuild_all()

## A hero anvil slot was tapped.
##
## Rules (per design): a part already equipped on a hero is NEVER deleted or
## displaced by a click. The only thing that can happen to an occupied slot is a
## MERGE — applying an armed tile of the EXACT same part bumps that slot's tier
## by 1 (capped at L5). Empty slots equip the armed part. Everything else is a
## no-op (the part stays put).
func _on_anvil_clicked(_card, _mode: StringName, slot, hero_id: StringName) -> void:
	var hero = GameState.get_hero(hero_id)
	if hero == null:
		return
	if _armed == null:
		# Plain click on an equipped tile → do nothing (don't sell / unequip).
		return
	# Slot type must match the armed part's slot type.
	if slot != _armed.slot:
		return
	var current = hero.weapon.get_slot(slot)
	var armed_pid: StringName = _armed_part_id()
	if current == null:
		# Empty slot → equip the armed part.
		if _armed.source == &"shop":
			Shop.buy(int(_armed.payload), hero_id)
		else:
			Merge.equip_from_inventory(_armed.payload, hero_id)
		_armed = null
		_rebuild_all()
		return
	# Occupied slot: ONLY a same-part merge is allowed, and only below the cap.
	if current.part_id == armed_pid and current.level < InventoryItemT.LEVEL_CAP:
		if _armed.source == &"shop":
			Shop.buy(int(_armed.payload), hero_id)            ## acquire_part Step 1 → tier+1
		else:
			Merge.equip_from_inventory(_armed.payload, hero_id)  ## merges duplicate → tier+1
		_armed = null
		_rebuild_all()
	# Different part, or same part at cap → no-op. Keep the equipped part intact
	# and stay armed so the player can retarget.

## Highlight an anvil card based on the current armed selection. Only glow slots
## the click would actually act on: empty matching slots (equip) and occupied
## matching slots holding the SAME part below cap (merge → tier+1). Everything
## else dims — occupied different-part slots never react to a click.
func _apply_arm_highlight(card, slot: StringName, item) -> void:
	if _armed == null:
		return
	var actionable := false
	if slot == _armed.slot:
		if item == null:
			actionable = true   ## empty → equippable
		elif item.part_id == _armed_part_id() and item.level < InventoryItemT.LEVEL_CAP:
			actionable = true   ## same part, below cap → mergeable
	if actionable:
		card.modulate = Color(1.35, 1.25, 0.7)       ## glow
	else:
		card.modulate = Color(0.6, 0.6, 0.6, 0.85)   ## dim

## The part_id of the currently armed supply tile (shop slot or inventory item).
func _armed_part_id() -> StringName:
	if _armed == null:
		return &""
	if _armed.source == &"shop":
		return GameState.shop_parts[int(_armed.payload)]
	return _armed.payload.part_id

## Insufficient-gold feedback: flash the gold counter red a few times and shake
## the gold pill. Called when the player taps a shop tile they can't afford.
func _flash_gold_insufficient() -> void:
	var gold_col := Color(0.984, 0.788, 0.235)   ## normal gold text
	var red := Color(1.0, 0.235, 0.235)
	var flash := create_tween()
	for i in 3:
		flash.tween_callback(func(): _gold_label.add_theme_color_override(&"font_color", red))
		flash.tween_interval(0.09)
		flash.tween_callback(func(): _gold_label.add_theme_color_override(&"font_color", gold_col))
		flash.tween_interval(0.09)
	## Shake the pill (the GoldLabel's PanelContainer parent) horizontally.
	var pill := _gold_label.get_parent() as Control
	if pill != null:
		var base: Vector2 = pill.position
		var amp := 5.0
		var shake := create_tween()
		for i in 6:
			var dx: float = -amp if (i % 2 == 0) else amp
			shake.tween_property(pill, "position", base + Vector2(dx, 0), 0.035)
		shake.tween_property(pill, "position", base, 0.035)
