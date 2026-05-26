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
const FLASH_BOOST: Color = Color(1.8, 1.8, 1.8, 1.0)
const MAX_POPS: int = 8

const JuiceConfigT = preload("res://scripts/core/juice_config.gd")

## ---------- Popup cap helper ----------
##
## CRITICAL: do NOT replace this with `while layer.get_child_count() > max_pops:
##                                         layer.get_child(0).queue_free()`.
## queue_free() is DEFERRED — the freed node remains in the scene tree until
## the end of the current frame. The while-loop's get_child_count() therefore
## NEVER decrements, and the loop spins forever calling queue_free on the
## same node every iteration. This bug previously froze the engine main
## thread + accumulated 21+ GB of Variant-wrapper garbage from the hot
## get_child(0) calls before the user task-killed Godot. See test in
## scripts/dev/test_combat.gd:_test_cap_pop_layer_terminates_bounded.
##
## The fix is a bounded for-loop that always terminates.
static func cap_pop_layer(layer: Control, max_pops: int) -> void:
	if layer == null:
		return
	var excess: int = layer.get_child_count() - max_pops
	for i in range(maxi(0, excess)):
		layer.get_child(i).queue_free()

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
		chip.add_theme_font_size_override(&"font_size", 11)
		chip.add_theme_color_override(&"font_color", Color(1, 1, 1))
		chip.tooltip_text = "%s\n%s" % [rec.name, rec.desc]
		pill.add_child(chip)
		_recipe_chips.add_child(pill)

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
	sprite.custom_minimum_size = Vector2(48, 48)
	## EXPAND_IGNORE_SIZE + STRETCH_KEEP_ASPECT_CENTERED makes the texture fit
	## within the control bounds instead of expanding the control to the
	## texture's native 128 px size (which was overflowing the arena).
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sprite.texture = enemy.get("sprite")
	v.add_child(sprite)

	## Juice PR2: HpBar + ColorRect HpBarDelta inside a Control slot. Delta is
	## the red trail behind the main bar showing damage just taken. Delta sized
	## by anchor_right = hp_ratio so it tracks the exact same horizontal extent
	## as HpBar's fill, with full slot height vertically. ColorRect (not a
	## second ProgressBar) bypasses theme fill content_margin quirks that made
	## a sibling ProgressBar paint at a different height than HpBar fill.
	var hp_slot := Control.new()
	hp_slot.name = "HpSlot"
	hp_slot.custom_minimum_size = Vector2(0, 8)
	v.add_child(hp_slot)

	var hp_delta := ColorRect.new()
	hp_delta.name = "HpBarDelta"
	hp_delta.color = Color(0.882, 0.231, 0.231, 0.95)
	hp_delta.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hp_slot.add_child(hp_delta)
	hp_delta.anchor_left = 0.0
	hp_delta.anchor_top = 0.0
	hp_delta.anchor_right = (float(enemy.hp) / float(enemy.max_hp)) if enemy.max_hp > 0 else 1.0
	hp_delta.anchor_bottom = 1.0
	hp_delta.offset_left = 0
	hp_delta.offset_top = 0
	hp_delta.offset_right = 0
	hp_delta.offset_bottom = 0

	var hp_bar := ProgressBar.new()
	hp_bar.name = "HpBar"
	hp_bar.max_value = float(enemy.max_hp)
	hp_bar.value = float(enemy.hp)
	hp_bar.show_percentage = false
	hp_bar.add_theme_stylebox_override(&"background", StyleBoxEmpty.new())
	hp_slot.add_child(hp_bar)
	hp_bar.set_anchors_preset(Control.PRESET_FULL_RECT, true)
	## Override fill with margin-free StyleBoxFlat so it renders at exact-rect
	## and matches the ColorRect delta sibling pixel-for-pixel.
	var ref_fill = hp_bar.get_theme_stylebox(&"fill")
	var hp_fill := StyleBoxFlat.new()
	if ref_fill is StyleBoxFlat:
		hp_fill.bg_color = ref_fill.bg_color
	else:
		hp_fill.bg_color = Color(0.388, 0.745, 0.345, 1)
	hp_fill.corner_radius_top_left = 2
	hp_fill.corner_radius_top_right = 2
	hp_fill.corner_radius_bottom_left = 2
	hp_fill.corner_radius_bottom_right = 2
	hp_bar.add_theme_stylebox_override(&"fill", hp_fill)

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
	var bar := card.find_child("HpBar", true, false) as ProgressBar
	if bar != null:
		_tween_bar(bar, float(enemy.hp))
	## Juice PR2: HP delta lags behind the main bar — Quart-In catchup after
	## a brief hold. On heal, snap forward immediately so the red trail only
	## ever shows damage just taken. Delta is a ColorRect; 'value' encoded as
	## anchor_right = hp_ratio.
	var delta := card.find_child("HpBarDelta", true, false) as ColorRect
	if delta != null and enemy.max_hp > 0:
		var target_ratio: float = clampf(float(enemy.hp) / float(enemy.max_hp), 0.0, 1.0)
		if target_ratio >= delta.anchor_right:
			delta.anchor_right = target_ratio
		else:
			var t := create_tween()
			t.tween_interval(0.25)
			t.tween_property(delta, "anchor_right", target_ratio, 0.20).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
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
	SignalTrace.note(&"battleview._on_hero_hit_enemy", {
		"hero": _hero_id, "enemy": enemy_idx, "dmg": dmg, "src": source, "crit": is_crit
	})
	if enemy_idx < 0 or enemy_idx >= _enemy_row.get_child_count():
		return
	var card := _enemy_row.get_child(enemy_idx) as Control
	var profile: Dictionary = JuiceConfigT.profile_for(source, is_crit)
	## Always show the popup (damage feedback) — that's the read-the-number
	## ground-truth signal players rely on. Skip shake / pause / flash when
	## the global kill-switch is off (juice-diag flow).
	if JuiceConfigT.JUICE_ENABLED:
		ScreenShake.kick(float(profile.shake_amp), float(profile.shake_dur))
		HitPause.freeze(float(profile.pause))
		_flash_sprite_in(card, float(profile.flash_dur))
		## Juice PR2: element particle burst on tagged hits (Steamburst -> ice_shard,
		## Hellfire / ult_meteor -> fire_puff). Non-tagged profiles omit the key.
		var burst_tex = profile.get("burst_texture")
		if burst_tex != null and burst_tex is Texture2D:
			_spawn_burst(card, burst_tex)
	var origin: Vector2 = card.global_position + Vector2(card.size.x * 0.5, 0)
	_spawn_pop(origin,
		"%s%d" % [String(profile.prefix), dmg],
		profile.color, int(profile.font_pt))

func _on_enemy_hit_hero(_enemy_idx: int, hero_id: StringName, dmg: int) -> void:
	SignalTrace.note(&"battleview._on_enemy_hit_hero", {
		"enemy": _enemy_idx, "hero": hero_id, "dmg": dmg
	})
	var profile: Dictionary = JuiceConfigT.ENEMY_HIT_HERO
	if JuiceConfigT.JUICE_ENABLED:
		ScreenShake.kick(float(profile.shake_amp), float(profile.shake_dur))
		HitPause.freeze(float(profile.pause))
	## Only flash + pop the BattleView portrait when the hit hero is the one
	## currently displayed (Bran in ultra-MVP). Per-card flash on every hero
	## lives in SquadBar, which dispatches by hero_id.
	if hero_id == &"bran":
		if JuiceConfigT.JUICE_ENABLED:
			_flash_sprite_in(_hero_anchor, float(profile.flash_dur))
		var origin: Vector2 = _hero_anchor.global_position + Vector2(_hero_anchor.size.x * 0.5, 0)
		_spawn_pop(origin, "%s%d" % [String(profile.prefix), dmg],
			profile.color, int(profile.font_pt))

func _on_ult_fired(_hero_id: StringName, total_dmg: int) -> void:
	SignalTrace.note(&"battleview._on_ult_fired", {"hero": _hero_id, "total": total_dmg})
	## Per-enemy pops already fired from hero_hit_enemy with source=&"ult".
	## This is the summary banner-pop centered over the arena.
	var profile: Dictionary = JuiceConfigT.PROFILES[&"ult"]
	var origin: Vector2 = _enemy_row.global_position + Vector2(_enemy_row.size.x * 0.5, 0)
	_spawn_pop(origin, "%s%d" % [String(profile.prefix), total_dmg],
		profile.color, int(profile.font_pt) + 4)

## Juice PR2: spawn a one-shot element-burst sprite at the enemy card's
## screen-center. Parents to BattleView root with top_level=true so the
## PanelContainer's child-sorter ignores the burst (no layout overhead). Tween
## scale 0.6 -> 1.4 + alpha 1 -> 0 over 0.4s, then queue_free.
func _spawn_burst(card: Control, tex: Texture2D) -> void:
	var burst := TextureRect.new()
	burst.set_meta(&"burst", true)
	burst.texture = tex
	burst.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	burst.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	burst.size = Vector2(48, 48)
	burst.mouse_filter = Control.MOUSE_FILTER_IGNORE
	burst.z_index = 80
	burst.top_level = true
	add_child(burst)
	var center: Vector2 = card.global_position + card.size * 0.5
	burst.global_position = center - burst.size * 0.5
	burst.pivot_offset = burst.size * 0.5
	burst.scale = Vector2(0.6, 0.6)
	burst.modulate.a = 1.0
	var t := create_tween().set_parallel(true)
	t.tween_property(burst, "scale", Vector2(1.4, 1.4), 0.40).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(burst, "modulate:a", 0.0, 0.40)
	t.chain().tween_callback(burst.queue_free)

func _spawn_pop(origin: Vector2, text: String, color: Color, font_pt: int) -> void:
	var label := Label.new()
	label.text = text
	label.modulate = color
	label.add_theme_font_size_override(&"font_size", font_pt)
	label.add_theme_color_override(&"font_color", color)
	label.add_theme_color_override(&"font_outline_color", Color.BLACK)
	label.add_theme_constant_override(&"outline_size", 4)
	label.z_index = 100
	_pops_layer.add_child(label)
	label.global_position = origin
	## Cap concurrent popups so the layer stays readable.
	cap_pop_layer(_pops_layer, MAX_POPS)
	## Pop-in then drift-up + fade.
	label.scale = Vector2(0.4, 0.4)
	label.pivot_offset = Vector2.ZERO
	var pop_in := create_tween()
	pop_in.tween_property(label, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - POP_RISE_PX, POP_LIFETIME)
	tween.tween_property(label, "modulate:a", 0.0, POP_LIFETIME).set_delay(POP_LIFETIME - 0.30)
	tween.chain().tween_callback(label.queue_free)

## ---------- Sprite flash ----------

## Brightens a sprite-bearing Control (or its first TextureRect child) by
## boosting modulate above 1.0, then easing back over `duration`. No shader
## required; modulate values >1 are valid and brighten the rendered texture.
func _flash_sprite_in(host: Control, duration: float) -> void:
	if host == null or duration <= 0.0:
		return
	var target: CanvasItem = _find_sprite_in(host)
	if target == null:
		return
	target.modulate = FLASH_BOOST
	var t := create_tween()
	t.tween_property(target, "modulate", Color.WHITE, duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

func _find_sprite_in(host: Control) -> CanvasItem:
	if host is TextureRect:
		return host
	for child in host.get_children():
		if child is TextureRect:
			return child
		var nested = _find_sprite_in(child) if child is Control else null
		if nested != null:
			return nested
	return null

## ---------- Log ----------

func _on_log_appended(line: String) -> void:
	_log_label.append_text(line + "\n")
	## Auto-scroll to bottom.
	await get_tree().process_frame
	_log_label.scroll_to_line(_log_label.get_line_count() - 1)
