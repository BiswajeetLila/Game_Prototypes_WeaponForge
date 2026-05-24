## SquadBar — horizontal row of HeroCard tiles, one per unlocked hero.
##
## Listens to GameState.hero_unlocked. When &"bran" unlocks (always the first
## call of every new_session), the bar fully rebuilds — this also covers the
## restart-after-wipe / restart-after-clear case where the prior squad's
## Elara/Vex cards need to disappear. Subsequent unlocks (elara / vex) get a
## single new card faded in beside the existing ones.
extends PanelContainer

const HeroCardScene := preload("res://scenes/HeroCard.tscn")
const JuiceConfigT = preload("res://scripts/core/juice_config.gd")

@onready var _cards_row: HBoxContainer = %CardsRow

func _ready() -> void:
	GameState.hero_unlocked.connect(_on_hero_unlocked)
	Combat.enemy_hit_hero.connect(_on_enemy_hit_hero)
	_rebuild_all()

## Routes the enemy-hit-hero juice to the matching card so each hero "reacts"
## visually, regardless of which one the BattleView happens to display.
func _on_enemy_hit_hero(_enemy_idx: int, hero_id: StringName, _dmg: int) -> void:
	var card = _find_card(hero_id)
	if card != null:
		card.flash(float(JuiceConfigT.ENEMY_HIT_HERO.flash_dur))

func _find_card(hero_id: StringName):
	for child in _cards_row.get_children():
		if child.has_method(&"hero_id") and child.hero_id() == hero_id:
			return child
	return null

func _on_hero_unlocked(hero_id: StringName) -> void:
	if hero_id == &"bran":
		_rebuild_all()
	else:
		_add_card(hero_id, true)

func _rebuild_all() -> void:
	for child in _cards_row.get_children():
		child.queue_free()
	for id in GameState.squad_order:
		_add_card(id, false)

func _add_card(hero_id: StringName, fade_in: bool) -> void:
	var card := HeroCardScene.instantiate()
	_cards_row.add_child(card)
	card.setup(hero_id)
	if fade_in:
		card.modulate.a = 0.0
		var t := create_tween()
		t.tween_property(card, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
