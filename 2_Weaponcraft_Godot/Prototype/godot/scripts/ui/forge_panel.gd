## ForgePanel — between-wave forge moment UI.
##
## Layout (top to bottom):
##   - Anvil row (3 PartCards: head, hilt, rune; empty = "EMPTY")
##   - Active recipe chips (purple pills, populated from Recipes.get_active_recipes)
##   - Shop header + Reroll button
##   - Shop grid (5 PartCards; bought slots show "SOLD" overlay)
##   - Inventory header
##   - Inventory strip (horizontal HBox in ScrollContainer)
##   - Start Wave button (in deployment zone — always visible)
##
## Signals wave_start_requested when the player taps Start Wave; Main handles
## advancing the wave + calling Combat.start_wave().
extends Control

const PartCardScene = preload("res://scenes/PartCard.tscn")

@onready var _anvil_row: HBoxContainer = %AnvilRow
@onready var _recipe_chips: HBoxContainer = %RecipeChips
@onready var _shop_grid: HBoxContainer = %ShopGrid
@onready var _reroll_btn: Button = %RerollBtn
@onready var _inventory_strip: HBoxContainer = %InventoryStrip
@onready var _start_wave_btn: Button = %StartWaveBtn
@onready var _empty_inv_label: Label = %EmptyInvLabel

signal wave_start_requested

func _ready() -> void:
	GameState.shop_changed.connect(_rebuild_shop)
	GameState.inventory_changed.connect(_rebuild_inventory)
	GameState.weapon_changed.connect(_on_weapon_changed)
	GameState.gold_changed.connect(_on_gold_changed)
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
	_rebuild_anvil()
	_rebuild_recipe_chips()
	_rebuild_shop()
	_rebuild_inventory()
	_on_gold_changed(GameState.gold)

func _on_weapon_changed(_hero_id: StringName) -> void:
	_rebuild_anvil()
	_rebuild_recipe_chips()

func _on_gold_changed(new_gold: int) -> void:
	_reroll_btn.disabled = new_gold < Shop.REROLL_COST
	_reroll_btn.text = "🔄 Reroll (🪙%d)" % Shop.REROLL_COST

## ---------- Anvil ----------

func _rebuild_anvil() -> void:
	for child in _anvil_row.get_children():
		child.queue_free()
	if GameState.hero == null or GameState.hero.weapon == null:
		return
	for slot in [&"head", &"hilt", &"rune"]:
		var item = GameState.hero.weapon.get_slot(slot)
		var card = PartCardScene.instantiate()
		_anvil_row.add_child(card)
		card.setup_anvil(item, slot)
		card.clicked.connect(_on_card_clicked)

## ---------- Recipe chips ----------

func _rebuild_recipe_chips() -> void:
	for child in _recipe_chips.get_children():
		child.queue_free()
	if GameState.hero == null or GameState.hero.weapon == null:
		return
	var active: Array = Recipes.get_active_recipes(GameState.hero.weapon)
	for recipe_id in active:
		var rec = GameState.get_recipe_def(recipe_id)
		if rec == null:
			continue
		var chip := Label.new()
		chip.text = "✨ %s" % rec.name
		chip.add_theme_font_size_override(&"font_size", 11)
		chip.add_theme_color_override(&"font_color", Color("d8a8ff"))
		_recipe_chips.add_child(chip)

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
	for child in _inventory_strip.get_children():
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
			Shop.buy(int(payload))
		&"inventory":
			Merge.equip_from_inventory(payload)
		&"anvil":
			if payload != &"":
				Merge.unequip_to_inventory(payload)
