## HeroCard — one squad member's UI tile (portrait + HP + ult gauge + ult button).
##
## Bound to a single hero by id via setup(hero_id). Signal handlers filter on
## that id so the card only reacts to changes for its own hero. The card
## queue_free()s itself if its hero disappears from GameState.squad_order
## (e.g., on new_session — SquadBar fully rebuilds anyway).
extends PanelContainer

@onready var _portrait: TextureRect = %Portrait
@onready var _name_label: Label = %NameLabel
@onready var _hp_bar: ProgressBar = %HpBar
@onready var _hp_text: Label = %HpText
@onready var _ult_bar: ProgressBar = %UltBar
@onready var _ult_btn: Button = %UltBtn

var _hero_id: StringName = &""
var _ult_pulse_tween: Tween = null

func setup(hero_id: StringName) -> void:
	_hero_id = hero_id
	## Wait until the scene's ready before touching @onready node refs.
	if not is_inside_tree() or _portrait == null:
		ready.connect(_refresh_all, CONNECT_ONE_SHOT)
	else:
		_refresh_all()

func _ready() -> void:
	GameState.hero_hp_changed.connect(_on_hp_changed)
	GameState.hero_ult_changed.connect(_on_ult_changed)
	GameState.weapon_changed.connect(_on_weapon_changed)
	_ult_btn.pressed.connect(_on_ult_btn_pressed)
	if _hero_id != &"":
		_refresh_all()

func _hero():
	return GameState.get_hero(_hero_id)

func _refresh_all() -> void:
	var hero = _hero()
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
	modulate = Color(0.5, 0.5, 0.5, 0.8) if hero.is_dead else Color.WHITE

func _refresh_ult_btn() -> void:
	var hero = _hero()
	if hero == null:
		_ult_btn.disabled = true
		_ult_btn.text = "—"
		return
	var ready_now: bool = hero.ult_gauge >= Combat.ULT_GAUGE_MAX and not hero.ult_used and not hero.is_dead
	var was_disabled: bool = _ult_btn.disabled
	_ult_btn.disabled = not ready_now
	_ult_btn.text = ("🌀 %s" % hero.data.ult_name) if ready_now else ("ULT %d%%" % int(hero.ult_gauge))
	if ready_now and was_disabled:
		_start_ult_pulse()
	elif not ready_now:
		_stop_ult_pulse()

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

func _tween_bar(bar: ProgressBar, target: float) -> void:
	var t := create_tween()
	t.tween_property(bar, "value", target, 0.20).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

func _on_hp_changed(hero_id: StringName) -> void:
	if hero_id != _hero_id:
		return
	var hero = _hero()
	if hero == null:
		return
	_hp_bar.max_value = float(hero.max_hp)
	_tween_bar(_hp_bar, float(hero.hp))
	_hp_text.text = "%d / %d" % [hero.hp, hero.max_hp]
	modulate = Color(0.5, 0.5, 0.5, 0.8) if hero.is_dead else Color.WHITE

func _on_ult_changed(hero_id: StringName) -> void:
	if hero_id != _hero_id:
		return
	var hero = _hero()
	if hero == null:
		return
	_tween_bar(_ult_bar, float(hero.ult_gauge))
	_refresh_ult_btn()

func _on_weapon_changed(hero_id: StringName) -> void:
	if hero_id != _hero_id:
		return
	## Atk total is shown elsewhere (BattleView / ForgePanel); the card stays
	## minimal at this width. Refresh anyway in case max_hp changed.
	_refresh_all()

func _on_ult_btn_pressed() -> void:
	if _hero_id != &"":
		Combat.fire_ult(_hero_id)

## ---------- Juice ----------

const _FLASH_BOOST: Color = Color(1.8, 1.8, 1.8, 1.0)

## Briefly brightens the portrait via modulate boost. Called by SquadBar in
## response to Combat.enemy_hit_hero so the right card "reacts" to the hit
## even though it isn't the BattleView's displayed hero.
func flash(duration: float) -> void:
	if _portrait == null or duration <= 0.0:
		return
	_portrait.modulate = _FLASH_BOOST
	var t := create_tween()
	t.tween_property(_portrait, "modulate", Color.WHITE, duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

func hero_id() -> StringName:
	return _hero_id
