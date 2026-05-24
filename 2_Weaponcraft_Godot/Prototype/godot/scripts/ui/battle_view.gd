## BattleView — combat-area panel.
##
## Holds:
##   - HeroPortrait (Bran sprite, left-anchored)
##   - EnemyRow (HBoxContainer dynamically populated from GameState.enemies)
##   - DamagePops (Control overlay where transient floating labels spawn)
##   - CombatLog (ScrollContainer + RichTextLabel)
##
## Listens to Combat.hero_hit_enemy / Combat.enemy_hit_hero / Combat.ult_fired
## for damage-pop spawn; listens to GameState.enemies_spawned /
## enemy_hp_changed / enemy_status_changed for enemy panel rebuilds + HP bar
## updates; listens to combat_log_appended for log lines.
extends Control

const POP_LIFETIME: float = 0.9
const POP_RISE_PX: float = 38.0

const TAG_COLORS: Dictionary = {
	&"fire":       Color("ff8800"),
	&"ice":        Color("88ddff"),
	&"pierce":     Color("dddddd"),
	&"steamburst": Color("aaffee"),
	&"hellfire":   Color("ff5544"),
	&"skewer":     Color("ccccff"),
	&"ult":        Color("aa66ff"),
}
const CRIT_COLOR: Color = Color("ffd700")
const ENEMY_HIT_COLOR: Color = Color("ff5555")

@onready var _hero_portrait: TextureRect = %HeroPortrait
@onready var _enemy_row: HBoxContainer = %EnemyRow
@onready var _pops_layer: Control = %DamagePops
@onready var _log_label: RichTextLabel = %CombatLog
@onready var _hero_anchor: Control = %HeroAnchor
@onready var _recipe_chips: HBoxContainer = %RecipeChips

func _ready() -> void:
	if GameState.hero != null and GameState.hero.data != null:
		_hero_portrait.texture = GameState.hero.data.portrait
	GameState.enemies_spawned.connect(_rebuild_enemy_row)
	GameState.enemy_hp_changed.connect(_on_enemy_hp_changed)
	GameState.enemy_status_changed.connect(_on_enemy_status_changed)
	GameState.combat_log_appended.connect(_on_log_appended)
	GameState.weapon_changed.connect(_rebuild_recipe_chips)
	Combat.hero_hit_enemy.connect(_on_hero_hit_enemy)
	Combat.enemy_hit_hero.connect(_on_enemy_hit_hero)
	Combat.ult_fired.connect(_on_ult_fired)
	_rebuild_enemy_row()
	_rebuild_recipe_chips(&"bran")

func _rebuild_recipe_chips(_hero_id: StringName) -> void:
	for child in _recipe_chips.get_children():
		child.queue_free()
	var hero = GameState.hero
	if hero == null or hero.weapon == null:
		return
	for recipe_id in Recipes.get_active_recipes(hero.weapon):
		var rec = GameState.get_recipe_def(recipe_id)
		if rec == null:
			continue
		var chip := Label.new()
		chip.text = rec.name
		chip.add_theme_font_size_override(&"font_size", 11)
		chip.add_theme_color_override(&"font_color", Color("d8a8ff"))
		chip.tooltip_text = "%s\n%s" % [rec.name, rec.desc]
		_recipe_chips.add_child(chip)

## ---------- Enemy row ----------

func _rebuild_enemy_row() -> void:
	for child in _enemy_row.get_children():
		child.queue_free()
	for i in range(GameState.enemies.size()):
		_enemy_row.add_child(_make_enemy_card(i))

func _make_enemy_card(idx: int) -> Control:
	var enemy: Dictionary = GameState.enemies[idx]
	var v := VBoxContainer.new()
	v.name = "Enemy_%d" % idx
	v.custom_minimum_size = Vector2(72, 0)
	## Vertically center the card in the row so it aligns with the hero portrait
	## instead of stacking at the top of the EnemyRow.
	v.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	var sprite := TextureRect.new()
	sprite.name = "Sprite"
	sprite.custom_minimum_size = Vector2(56, 56)
	## EXPAND_IGNORE_SIZE + STRETCH_KEEP_ASPECT_CENTERED makes the texture fit
	## within the control bounds instead of expanding the control to the
	## texture's native 128 px size (which was overflowing the arena).
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sprite.texture = enemy.get("sprite")
	v.add_child(sprite)

	var hp_bar := ProgressBar.new()
	hp_bar.name = "HpBar"
	hp_bar.max_value = float(enemy.max_hp)
	hp_bar.value = float(enemy.hp)
	hp_bar.show_percentage = false
	hp_bar.custom_minimum_size = Vector2(0, 8)
	v.add_child(hp_bar)

	var hp_text := Label.new()
	hp_text.name = "HpText"
	hp_text.text = "%d/%d" % [enemy.hp, enemy.max_hp]
	hp_text.add_theme_font_size_override(&"font_size", 10)
	hp_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(hp_text)

	var aff := Label.new()
	aff.name = "Affinity"
	aff.add_theme_font_size_override(&"font_size", 10)
	aff.text = _affinity_text(enemy)
	aff.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(aff)

	var status := Label.new()
	status.name = "Status"
	status.add_theme_font_size_override(&"font_size", 10)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.text = _status_text(enemy)
	v.add_child(status)

	return v

func _affinity_text(enemy: Dictionary) -> String:
	var parts: Array = []
	if enemy.weak != &"":
		parts.append("★%s" % String(enemy.weak))
	if enemy.resist != &"":
		parts.append("~%s" % String(enemy.resist))
	return " ".join(parts)

func _status_text(enemy: Dictionary) -> String:
	var bits: Array = []
	if enemy.get(&"frozen", false):
		bits.append("❄ frozen")
	if enemy.get(&"debuffed", false):
		bits.append("⛓ debuff")
	return " ".join(bits)

func _on_enemy_hp_changed(idx: int) -> void:
	if idx < 0 or idx >= _enemy_row.get_child_count():
		return
	var card := _enemy_row.get_child(idx) as Control
	var enemy: Dictionary = GameState.enemies[idx]
	var bar := card.get_node_or_null("HpBar") as ProgressBar
	if bar != null:
		_tween_bar(bar, float(enemy.hp))
	var txt := card.get_node_or_null("HpText") as Label
	if txt != null:
		txt.text = "%d/%d" % [enemy.hp, enemy.max_hp]
	if enemy.hp <= 0 and not card.get_meta(&"dying", false):
		card.set_meta(&"dying", true)
		_play_enemy_death(card)

func _tween_bar(bar: ProgressBar, target: float) -> void:
	var t := create_tween()
	t.tween_property(bar, "value", target, 0.18).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

func _play_enemy_death(card: Control) -> void:
	card.pivot_offset = card.size * 0.5
	var t := create_tween().set_parallel(true)
	t.tween_property(card, "modulate:a", 0.35, 0.45)
	t.tween_property(card, "scale", Vector2(0.75, 0.75), 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	t.tween_property(card, "rotation", deg_to_rad(8.0), 0.45)

func _on_enemy_status_changed(idx: int) -> void:
	if idx < 0 or idx >= _enemy_row.get_child_count():
		return
	var card := _enemy_row.get_child(idx)
	var enemy: Dictionary = GameState.enemies[idx]
	var status := card.get_node_or_null("Status") as Label
	if status != null:
		status.text = _status_text(enemy)

## ---------- Damage pops ----------

func _on_hero_hit_enemy(_hero_id: StringName, enemy_idx: int, dmg: int, source: StringName, is_crit: bool) -> void:
	if enemy_idx < 0 or enemy_idx >= _enemy_row.get_child_count():
		return
	var card := _enemy_row.get_child(enemy_idx) as Control
	_shake(card, 4.0, is_crit)
	var origin: Vector2 = card.global_position + Vector2(card.size.x * 0.5, 0)
	var color: Color = TAG_COLORS.get(source, Color.WHITE)
	if is_crit:
		color = CRIT_COLOR
	var prefix: String = ""
	var enemy: Dictionary = GameState.enemies[enemy_idx]
	## Star prefix on weakness hits — but the source key here is the tag/source label,
	## so we approximate: any damage pop where weapon has a tag matching enemy.weak.
	## Simpler heuristic: if source is fire/ice/pierce and matches enemy.weak, prefix ★.
	if source in [&"fire", &"ice", &"pierce"]:
		if source == enemy.get(&"weak"):
			prefix = "★ "
		elif source == enemy.get(&"resist"):
			prefix = "~ "
	if is_crit:
		prefix = "⚡ " + prefix
	_spawn_pop(origin, "%s%d" % [prefix, dmg], color, is_crit)

func _on_enemy_hit_hero(_enemy_idx: int, _hero_id: StringName, dmg: int) -> void:
	_shake(_hero_anchor, 3.0, false)
	var origin: Vector2 = _hero_anchor.global_position + Vector2(_hero_anchor.size.x * 0.5, 0)
	_spawn_pop(origin, "-%d" % dmg, ENEMY_HIT_COLOR, false)

func _on_ult_fired(_hero_id: StringName, total_dmg: int) -> void:
	## A single pop at center to highlight the ult. Per-enemy pops already fired
	## from hero_hit_enemy with source=&"ult".
	var origin: Vector2 = _enemy_row.global_position + Vector2(_enemy_row.size.x * 0.5, 0)
	_spawn_pop(origin, "ULT %d" % total_dmg, TAG_COLORS[&"ult"], true)

func _spawn_pop(origin: Vector2, text: String, color: Color, big: bool) -> void:
	var label := Label.new()
	label.text = text
	label.modulate = color
	label.add_theme_font_size_override(&"font_size", 18 if big else 14)
	label.add_theme_color_override(&"font_color", color)
	label.add_theme_color_override(&"font_outline_color", Color.BLACK)
	label.add_theme_constant_override(&"outline_size", 4)
	label.z_index = 100
	_pops_layer.add_child(label)
	## Place relative to pops_layer.
	label.global_position = origin
	var tween := create_tween().set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - POP_RISE_PX, POP_LIFETIME)
	tween.tween_property(label, "modulate:a", 0.0, POP_LIFETIME)
	tween.chain().tween_callback(label.queue_free)

## ---------- Hit-shake ----------

func _shake(node: Control, amplitude: float, big: bool) -> void:
	if node == null:
		return
	## Lightweight position-offset shake; spring back.
	var origin: Vector2 = node.position
	var amp: float = amplitude * (1.6 if big else 1.0)
	var t := create_tween()
	t.tween_property(node, "position", origin + Vector2(amp, 0), 0.04)
	t.tween_property(node, "position", origin - Vector2(amp, 0), 0.04)
	t.tween_property(node, "position", origin, 0.04)

## ---------- Log ----------

func _on_log_appended(line: String) -> void:
	_log_label.append_text(line + "\n")
	## Auto-scroll to bottom.
	await get_tree().process_frame
	_log_label.scroll_to_line(_log_label.get_line_count() - 1)
