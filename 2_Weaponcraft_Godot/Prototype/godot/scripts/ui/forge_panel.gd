## ForgePanel — between-wave forge moment UI.
##
## Layout (top to bottom):
##   - Anvil row (3 PartCards: head, hilt, rune; empty = "EMPTY")
##   - Active recipe chips (purple pills, populated from Recipes.get_active_recipes)
##   - Shop header + Reroll button (shared across all heroes)
##   - Shop grid (5 PartCards; bought slots show "SOLD" overlay)
##   - Inventory header
##   - Inventory strip (horizontal HBox in ScrollContainer; shared, global pool)
##   - Start Wave button (in deployment zone — always visible)
##
## Active hero (for anvil + recipe binding) selected by clicking a HeroCard in
## SquadBar; Main wires SquadBar.hero_selected -> ForgePanel.set_current_hero.
## Shop, gold, and inventory stay global — only the anvil / recipe view
## scopes to the selected card.
##
## Signals wave_start_requested when the player taps Start Wave; Main handles
## advancing the wave + calling Combat.start_wave().
extends Control

const PartCardScene = preload("res://scenes/PartCard.tscn")

@onready var _anvil_row: HBoxContainer = %AnvilRow
@onready var _recipe_chips: HBoxContainer = %RecipeChips
@onready var _recipe_desc: Label = %RecipeDesc
@onready var _shop_grid: HBoxContainer = %ShopGrid
@onready var _reroll_btn: Button = %RerollBtn
@onready var _gold_label: Label = %GoldLabel
@onready var _inventory_strip: HBoxContainer = %InventoryStrip
@onready var _start_wave_btn: Button = %StartWaveBtn
@onready var _empty_inv_label: Label = %EmptyInvLabel

signal wave_start_requested

var _current_hero_id: StringName = &"bran"

func _ready() -> void:
	GameState.shop_changed.connect(_rebuild_shop)
	GameState.inventory_changed.connect(_rebuild_inventory)
	GameState.weapon_changed.connect(_on_weapon_changed)
	GameState.gold_changed.connect(_on_gold_changed)
	GameState.hero_unlocked.connect(_on_hero_unlocked)
	_reroll_btn.pressed.connect(_on_reroll_pressed)
	_start_wave_btn.pressed.connect(func(): emit_signal(&"wave_start_requested"))
	_rebuild_all()

## ---------- Public ----------

func refresh_forge_moment() -> void:
	## Called by Main at the start of a forge moment (between waves). Free roll
	## the shop and rebuild the panel.
	Shop.refresh(true)
	_rebuild_all()

## ---------- Rebuild dispatch ----------

func _rebuild_all() -> void:
	_ensure_current_hero_valid()
	_rebuild_anvil()
	_rebuild_recipe_chips()
	_rebuild_shop()
	_rebuild_inventory()
	_on_gold_changed(GameState.gold)

func _ensure_current_hero_valid() -> void:
	if GameState.squad_order.is_empty():
		_current_hero_id = &""
		return
	if not GameState.squad_order.has(_current_hero_id):
		_current_hero_id = GameState.squad_order[0]

## Public: SquadBar signals which hero is now selected; rebind anvil / recipes
## to that hero. Called by Main wiring SquadBar.hero_selected -> this method.
func set_current_hero(hero_id: StringName) -> void:
	if hero_id == _current_hero_id:
		return
	_current_hero_id = hero_id
	_rebuild_anvil()
	_rebuild_recipe_chips()

func _on_hero_unlocked(_hero_id: StringName) -> void:
	## new_session unlocks &"bran" — reset to bran selection so a stale
	## Elara/Vex pointer from the prior run doesn't show an empty anvil.
	if _hero_id == &"bran":
		_current_hero_id = &"bran"
	_rebuild_all()

func _on_weapon_changed(hero_id: StringName) -> void:
	if hero_id == _current_hero_id:
		_rebuild_anvil()
		_rebuild_recipe_chips()

func _on_gold_changed(new_gold: int) -> void:
	_reroll_btn.disabled = new_gold < Shop.REROLL_COST
	_reroll_btn.text = "🔄 Reroll (🪙%d)" % Shop.REROLL_COST
	_gold_label.text = "🪙 %d" % new_gold

## ---------- Anvil ----------

func _current_hero():
	return GameState.get_hero(_current_hero_id)

func _rebuild_anvil() -> void:
	for child in _anvil_row.get_children():
		child.queue_free()
	var hero = _current_hero()
	if hero == null or hero.weapon == null:
		return
	for slot in [&"head", &"hilt", &"rune"]:
		var item = hero.weapon.get_slot(slot)
		var card = PartCardScene.instantiate()
		_anvil_row.add_child(card)
		card.setup_anvil(item, slot)
		card.clicked.connect(_on_card_clicked)

## ---------- Recipe chips ----------

func _rebuild_recipe_chips() -> void:
	for child in _recipe_chips.get_children():
		child.queue_free()
	var hero = _current_hero()
	if hero == null or hero.weapon == null:
		_refresh_recipe_desc()
		return
	var active: Array = Recipes.get_active_recipes(hero.weapon)
	for recipe_id in active:
		var rec = GameState.get_recipe_def(recipe_id)
		if rec == null:
			continue
		var pill := PanelContainer.new()
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color(0.416, 0.227, 0.651, 1)
		sb.border_color = Color(0.85, 0.65, 1, 1)
		sb.border_width_left = 1
		sb.border_width_top = 1
		sb.border_width_right = 1
		sb.border_width_bottom = 1
		sb.corner_radius_top_left = 6
		sb.corner_radius_top_right = 6
		sb.corner_radius_bottom_left = 6
		sb.corner_radius_bottom_right = 6
		sb.content_margin_left = 8
		sb.content_margin_right = 8
		sb.content_margin_top = 2
		sb.content_margin_bottom = 2
		pill.add_theme_stylebox_override(&"panel", sb)
		var chip := Label.new()
		chip.text = rec.name
		chip.add_theme_font_size_override(&"font_size", 12)
		chip.add_theme_color_override(&"font_color", Color(1, 1, 1))
		chip.tooltip_text = "%s\n%s" % [rec.name, rec.desc]
		pill.add_child(chip)
		_recipe_chips.add_child(pill)
	_refresh_recipe_desc()

func _refresh_recipe_desc() -> void:
	var hero = _current_hero()
	if hero == null or hero.weapon == null:
		_recipe_desc.text = ""
		return
	var lines: Array = []
	for recipe_id in Recipes.get_active_recipes(hero.weapon):
		var rec = GameState.get_recipe_def(recipe_id)
		if rec != null:
			lines.append("• %s — %s" % [rec.name, rec.desc])
	_recipe_desc.text = "\n".join(lines)

## ---------- Shop ----------

func _rebuild_shop() -> void:
	for child in _shop_grid.get_children():
		child.queue_free()
	for i in range(GameState.shop_parts.size()):
		var part_id = GameState.shop_parts[i]
		var card = PartCardScene.instantiate()
		_shop_grid.add_child(card)
		if part_id == null or part_id == &"":
			card.setup_anvil(null, &"")  ## empty-style placeholder
			card.modulate = Color(0.5, 0.5, 0.5, 0.6)
		else:
			card.setup_shop(part_id, i)
			card.clicked.connect(_on_card_clicked)

func _on_reroll_pressed() -> void:
	Shop.reroll()

## ---------- Inventory ----------

func _rebuild_inventory() -> void:
	## EmptyInvLabel is also a child of the strip — leave it alone, queue_free the rest.
	for child in _inventory_strip.get_children():
		if child == _empty_inv_label:
			continue
		child.queue_free()
	_empty_inv_label.visible = GameState.inventory.is_empty()
	for item in GameState.inventory:
		var card = PartCardScene.instantiate()
		_inventory_strip.add_child(card)
		card.setup_inventory(item)
		card.clicked.connect(_on_card_clicked)

## ---------- Click handler ----------

func _on_card_clicked(_card, mode: StringName, payload) -> void:
	match mode:
		&"shop":
			Shop.buy(int(payload), _current_hero_id)
		&"inventory":
			Merge.equip_from_inventory(payload, _current_hero_id)
		&"anvil":
			if payload != &"":
				Merge.unequip_to_inventory(payload, _current_hero_id)
