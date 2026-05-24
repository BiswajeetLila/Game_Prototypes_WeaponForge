## PartCard — single card for shop / inventory / anvil display.
##
## Three modes:
##   "shop"      — shows cost, click = Shop.buy(slot_idx)
##   "inventory" — shows level badge, click = Merge.equip_from_inventory(item)
##   "anvil"     — shows level badge, click = Merge.unequip_to_inventory(slot_name)
##                 If item is null shows empty slot placeholder.
##
## Same .tscn file used everywhere; configure via `setup(...)`.
class_name PartCard
extends PanelContainer

const TAG_COLORS: Dictionary = {
	&"fire":   Color("ff8800"),
	&"ice":    Color("88ddff"),
	&"pierce": Color("dddddd"),
	&"crit":   Color("ffd700"),
	&"charge": Color("aa66ff"),
}

@onready var _icon: TextureRect = %Icon
@onready var _slot_label: Label = %SlotLabel
@onready var _name_label: Label = %NameLabel
@onready var _tag_box: HBoxContainer = %TagBox
@onready var _stat_label: Label = %StatLabel
@onready var _cost_label: Label = %CostLabel
@onready var _level_badge: Label = %LevelBadge
@onready var _btn: Button = %Btn
@onready var _empty_label: Label = %EmptyLabel

var _mode: StringName = &"shop"
var _payload                  ## shop_idx:int OR InventoryItem OR slot_name:StringName
var _part_id: StringName = &""
var _level: int = 1
var _current_uid: int = -1   ## set by setup_inventory/anvil so we can match merge signals

signal clicked(card, mode: StringName, payload)

func _ready() -> void:
	_btn.pressed.connect(func(): emit_signal(&"clicked", self, _mode, _payload))
	## Pop-in scale tween every time the card is freshly added to the tree
	## (i.e. every shop/inventory/anvil rebuild). Cheap juice.
	pivot_offset = size * 0.5
	scale = Vector2(0.85, 0.85)
	modulate.a = 0.0
	var t := create_tween().set_parallel(true)
	t.tween_property(self, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "modulate:a", 1.0, 0.15)
	GameState.merge_completed.connect(_on_merge_completed)

func _on_merge_completed(uid: int, new_level: int) -> void:
	if uid != _current_uid:
		return
	_play_merge_celebration(new_level)

## Setup helpers. Pass null part_id for empty slot in anvil mode.

func setup_shop(part_id: StringName, shop_idx: int) -> void:
	_mode = &"shop"
	_payload = shop_idx
	_part_id = part_id
	_level = 1
	_current_uid = -1
	_refresh()

func setup_inventory(item) -> void:
	_mode = &"inventory"
	_payload = item
	_part_id = item.part_id if item != null else &""
	_level = item.level if item != null else 1
	_current_uid = item.uid if item != null else -1
	_refresh()

func setup_anvil(item, slot_name: StringName) -> void:
	_mode = &"anvil"
	_payload = slot_name
	_part_id = item.part_id if item != null else &""
	_level = item.level if item != null else 1
	_current_uid = item.uid if item != null else -1
	_refresh()

## ---------- Render ----------

func _refresh() -> void:
	if _part_id == &"":
		_render_empty()
		return
	var def = GameState.get_part_def(_part_id)
	if def == null:
		_render_empty()
		return
	_empty_label.visible = false
	_icon.visible = true
	_icon.texture = def.icon
	_name_label.text = def.name
	_slot_label.text = String(def.slot).to_upper()
	_render_tags(def)
	_render_stats(def)
	_render_cost(def)
	_render_level_badge()
	tooltip_text = "%s (L%d)\n%s" % [def.name, _level, def.desc]

func _render_stats(def: PartData) -> void:
	## Apply level multiplier to each contributing stat so the player sees
	## raw -> scaled numbers climb as they merge.
	var mult: float = Merge.level_multiplier(_level)
	var parts: Array = []
	if def.atk > 0:
		parts.append("+%d ATK" % int(floor(float(def.atk) * mult)))
	if def.hp > 0:
		parts.append("+%d HP" % int(floor(float(def.hp) * mult)))
	if def.crit > 0:
		parts.append("+%d%% CRIT" % int(floor(float(def.crit) * mult)))
	if def.ult_rate > 0:
		parts.append("+%d ULT" % int(floor(float(def.ult_rate) * mult)))
	_stat_label.text = "  ".join(parts)

func _render_empty() -> void:
	_empty_label.visible = true
	_icon.visible = false
	_name_label.text = ""
	_slot_label.text = ""
	for child in _tag_box.get_children():
		child.queue_free()
	_cost_label.visible = false
	_level_badge.visible = false
	tooltip_text = ""

func _render_tags(def: PartData) -> void:
	for child in _tag_box.get_children():
		child.queue_free()
	## Explicit tag.
	if def.tag != &"":
		_tag_box.add_child(_make_tag_chip(def.tag))
	## Derived crit/charge — only if this part contributes.
	if def.crit > 0:
		_tag_box.add_child(_make_tag_chip(&"crit"))
	if def.ult_rate > 0:
		_tag_box.add_child(_make_tag_chip(&"charge"))

func _make_tag_chip(tag: StringName) -> Label:
	var l := Label.new()
	l.text = String(tag).to_upper()
	l.add_theme_font_size_override(&"font_size", 9)
	l.add_theme_color_override(&"font_color", TAG_COLORS.get(tag, Color.WHITE))
	return l

func _render_cost(def: PartData) -> void:
	if _mode == &"shop":
		_cost_label.visible = true
		_cost_label.text = "🪙 %d" % def.cost
	else:
		_cost_label.visible = false

func _render_level_badge() -> void:
	if _level <= 1:
		_level_badge.visible = false
		return
	_level_badge.visible = true
	_level_badge.text = "L%d" % _level

## ---------- Merge celebration ----------

const MERGE_SPARKLE_TEX = preload("res://assets/generated/vfx/merge_sparkle.png")

func _play_merge_celebration(new_level: int) -> void:
	## Update level + re-render badge + stats so numbers climb on screen.
	_level = new_level
	var def = GameState.get_part_def(_part_id)
	if def != null:
		_render_stats(def)
	_render_level_badge()
	_level_badge.pivot_offset = _level_badge.size * 0.5
	## Card scale bounce.
	pivot_offset = size * 0.5
	var t1 := create_tween()
	t1.tween_property(self, "scale", Vector2(1.18, 1.18), 0.10).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t1.tween_property(self, "scale", Vector2.ONE, 0.12)
	## Gold border flash via self_modulate so children stay normal color.
	var orig: Color = self_modulate
	var t2 := create_tween()
	t2.tween_property(self, "self_modulate", Color(1.4, 1.2, 0.5, 1.0), 0.08)
	t2.tween_property(self, "self_modulate", orig, 0.30)
	## Level badge pop.
	_level_badge.scale = Vector2(2.0, 2.0)
	var t3 := create_tween()
	t3.tween_property(_level_badge, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	## Sparkle burst sprite centered on the card.
	_spawn_sparkle_sprite()
	## Floating "✨ L<n>!" text.
	_spawn_merge_pop(new_level)

func _spawn_sparkle_sprite() -> void:
	var s := TextureRect.new()
	s.texture = MERGE_SPARKLE_TEX
	s.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	s.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	s.size = Vector2(96, 96)
	s.position = size * 0.5 - s.size * 0.5
	s.pivot_offset = s.size * 0.5
	s.z_index = 90
	s.mouse_filter = Control.MOUSE_FILTER_IGNORE
	s.scale = Vector2(0.2, 0.2)
	s.modulate = Color(1, 1, 1, 1)
	add_child(s)
	var burst := create_tween().set_parallel(true)
	burst.tween_property(s, "scale", Vector2(1.4, 1.4), 0.32).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	burst.tween_property(s, "rotation", deg_to_rad(30.0), 0.55)
	burst.tween_property(s, "modulate:a", 0.0, 0.55)
	burst.chain().tween_callback(s.queue_free)

func _spawn_merge_pop(new_level: int) -> void:
	var label := Label.new()
	label.text = "✨ MERGED L%d!" % new_level
	label.add_theme_color_override(&"font_color", Color(1, 0.9, 0.3))
	label.add_theme_color_override(&"font_outline_color", Color.BLACK)
	label.add_theme_constant_override(&"outline_size", 4)
	label.add_theme_font_size_override(&"font_size", 14)
	label.z_index = 100
	add_child(label)
	label.position = Vector2(size.x * 0.5 - 40, 6)
	var tw := create_tween().set_parallel(true)
	tw.tween_property(label, "position:y", label.position.y - 28, 0.85)
	tw.tween_property(label, "modulate:a", 0.0, 0.85)
	tw.chain().tween_callback(label.queue_free)
