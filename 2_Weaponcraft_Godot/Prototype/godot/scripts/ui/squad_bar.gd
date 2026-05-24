## SquadBar — Bran's hero card.
##
## Portrait + HP bar + persistent ult gauge + tap-to-fire-ult button.
## Listens to GameState.weapon_changed (atk text) + hero_hp_changed + hero_ult_changed.
extends Control

@onready var _portrait: TextureRect = %Portrait
@onready var _name_label: Label = %NameLabel
@onready var _hp_bar: ProgressBar = %HpBar
@onready var _hp_text: Label = %HpText
@onready var _atk_label: Label = %AtkLabel
@onready var _ult_bar: ProgressBar = %UltBar
@onready var _ult_btn: Button = %UltBtn

func _ready() -> void:
	GameState.hero_hp_changed.connect(_on_hp_changed)
	GameState.hero_ult_changed.connect(_on_ult_changed)
	GameState.weapon_changed.connect(_on_weapon_changed)
	_ult_btn.pressed.connect(_on_ult_btn_pressed)
	_refresh_all()

func _refresh_all() -> void:
	var hero = GameState.hero
	if hero == null:
		return
	_portrait.texture = hero.data.portrait if hero.data != null else null
	_name_label.text = hero.data.name if hero.data != null else "?"
	_hp_bar.max_value = float(hero.max_hp)
	_hp_bar.value = float(hero.hp)
	_hp_text.text = "%d / %d" % [hero.hp, hero.max_hp]
	_ult_bar.max_value = float(Combat.ULT_GAUGE_MAX)
	_ult_bar.value = float(hero.ult_gauge)
	_refresh_ult_btn()
	_refresh_atk_label()

func _refresh_atk_label() -> void:
	var hero = GameState.hero
	if hero == null or hero.weapon == null:
		_atk_label.text = "ATK —"
		return
	var total: int = hero.data.atk_base + hero.weapon.get_atk()
	var crit: int = hero.weapon.get_crit()
	_atk_label.text = "ATK %d  CRIT %d%%" % [total, crit]

func _refresh_ult_btn() -> void:
	var hero = GameState.hero
	if hero == null:
		_ult_btn.disabled = true
		_ult_btn.text = "—"
		return
	var ready: bool = hero.ult_gauge >= Combat.ULT_GAUGE_MAX and not hero.ult_used and not hero.is_dead
	var was_disabled: bool = _ult_btn.disabled
	_ult_btn.disabled = not ready
	_ult_btn.text = "🌀 %s" % (hero.data.ult_name if hero.data != null else "ULT") if ready else "ULT %d%%" % int(hero.ult_gauge)
	## Start the pulse loop the moment the button just went from disabled -> ready.
	if ready and was_disabled:
		_start_ult_pulse()
	elif not ready:
		_stop_ult_pulse()

var _ult_pulse_tween: Tween = null

func _start_ult_pulse() -> void:
	_stop_ult_pulse()
	_ult_btn.pivot_offset = _ult_btn.size * 0.5
	_ult_pulse_tween = create_tween().set_loops()
	_ult_pulse_tween.tween_property(_ult_btn, "scale", Vector2(1.08, 1.08), 0.45).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_ult_pulse_tween.tween_property(_ult_btn, "scale", Vector2.ONE, 0.45).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _stop_ult_pulse() -> void:
	if _ult_pulse_tween != null and _ult_pulse_tween.is_running():
		_ult_pulse_tween.kill()
	_ult_pulse_tween = null
	_ult_btn.scale = Vector2.ONE

func _on_hp_changed(_hero_id: StringName) -> void:
	var hero = GameState.hero
	if hero == null:
		return
	_hp_bar.max_value = float(hero.max_hp)
	_tween_bar(_hp_bar, float(hero.hp))
	_hp_text.text = "%d / %d" % [hero.hp, hero.max_hp]
	## Reset modulate every refresh — otherwise a prior wipe leaves the panel
	## greyed even after new_session() resurrects Bran.
	modulate = Color(0.5, 0.5, 0.5, 0.8) if hero.is_dead else Color.WHITE

func _tween_bar(bar: ProgressBar, target: float) -> void:
	var t := create_tween()
	t.tween_property(bar, "value", target, 0.20).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

func _on_ult_changed(_hero_id: StringName) -> void:
	var hero = GameState.hero
	if hero == null:
		return
	_tween_bar(_ult_bar, float(hero.ult_gauge))
	_refresh_ult_btn()

func _on_weapon_changed(_hero_id: StringName) -> void:
	_refresh_atk_label()

func _on_ult_btn_pressed() -> void:
	Combat.fire_ult(&"bran")
