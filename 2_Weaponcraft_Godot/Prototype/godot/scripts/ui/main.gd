## Main — composition root for the ultra-MVP play scene.
##
## Mounts HUD + BattleView + SquadBar. The ForgePanel comes in UI Chunk 2;
## for UI Chunk 1 a debug button equips Bran with a default loadout and starts
## wave 1 so the player can verify combat ticks, ult fire, and damage pops.
##
## After UI Chunk 2 the debug button is removed and replaced by the real forge
## "Start Wave" button in the deployment zone (per addendum 0.1.8).
extends Control

const InventoryItemT = preload("res://scripts/data/inventory_item.gd")

@onready var _start_btn: Button = %StartWaveBtn
@onready var _reset_btn: Button = %ResetBtn

func _ready() -> void:
	_start_btn.pressed.connect(_on_debug_start_pressed)
	_reset_btn.pressed.connect(_on_reset_pressed)

func _on_debug_start_pressed() -> void:
	## Equip a sensible default loadout so the test player sees Steamburst trigger
	## right away (fire hilt + ice rune) once the discovery overlay lands in UI Chunk 3.
	if GameState.hero == null:
		return
	GameState.hero.weapon.set_slot(&"head", InventoryItemT.new(GameState.next_uid(), &"h_iron_edge", 1))
	GameState.hero.weapon.set_slot(&"hilt", InventoryItemT.new(GameState.next_uid(), &"p_pyro_pommel", 1))
	GameState.hero.weapon.set_slot(&"rune", InventoryItemT.new(GameState.next_uid(), &"r_ice", 1))
	GameState.hero.refresh_max_hp()
	Recipes.check_hero_for_discoveries(GameState.hero)
	GameState.emit_signal(&"weapon_changed", &"bran")
	GameState.emit_signal(&"hero_hp_changed", &"bran")
	Combat.start_wave(1)
	_start_btn.disabled = true

func _on_reset_pressed() -> void:
	Combat.stop()
	GameState.new_session()
	_start_btn.disabled = false
