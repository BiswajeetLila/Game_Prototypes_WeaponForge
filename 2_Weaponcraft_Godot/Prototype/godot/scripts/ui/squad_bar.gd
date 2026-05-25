## SquadBar — horizontal row of HeroCard tiles, one per unlocked hero.
##
## Listens to GameState.hero_unlocked. When &"bran" unlocks (always the first
## call of every new_session), the bar fully rebuilds — this also covers the
## restart-after-wipe / restart-after-clear case where the prior squad's
## Elara/Vex cards need to disappear. Subsequent unlocks (elara / vex) get a
## single new card faded in beside the existing ones.
##
## Selection: clicking a card emits `hero_selected(id)` for ForgePanel to
## consume. The selected card renders with a bright gold-bordered stylebox;
## the rest render dim. Bran is the default selection on every new_session.
extends PanelContainer

const HeroCardScene := preload("res://scenes/HeroCard.tscn")
const JuiceConfigT = preload("res://scripts/core/juice_config.gd")

signal hero_selected(hero_id: StringName)

@onready var _cards_row: HBoxContainer = %CardsRow

var _selected_hero_id: StringName = &"bran"

func _ready() -> void:
	GameState.hero_unlocked.connect(_on_hero_unlocked)
	Combat.enemy_hit_hero.connect(_on_enemy_hit_hero)
	_rebuild_all()
	## No initial signal emit — Main connects to hero_selected AFTER this _ready
	## (parents run after children), so the emit would land on no listeners.
	## Both SquadBar and ForgePanel default _selected_hero_id / _current_hero_id
	## to &"bran" so the initial state agrees without a handoff.

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
		## new_session: reset selection to bran and full-rebuild so prior
		## Elara/Vex cards disappear.
		_selected_hero_id = &"bran"
		_rebuild_all()
		emit_signal(&"hero_selected", _selected_hero_id)
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
	card.set_selected(hero_id == _selected_hero_id)
	card.selected.connect(_on_card_selected)
	if fade_in:
		card.modulate.a = 0.0
		var t := create_tween()
		t.tween_property(card, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_card_selected(hero_id: StringName) -> void:
	if hero_id == _selected_hero_id:
		return
	_selected_hero_id = hero_id
	for child in _cards_row.get_children():
		if child.has_method(&"hero_id"):
			child.set_selected(child.hero_id() == _selected_hero_id)
	emit_signal(&"hero_selected", _selected_hero_id)
