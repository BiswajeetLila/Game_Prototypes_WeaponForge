## PartCard — single card for shop / inventory / anvil display.
##
## Three modes:
##   "shop"      — shows cost, click = Shop.buy(slot_idx)
##   "inventory" — shows level badge, click = Merge.equip_from_inventory(item)
##   "anvil"     — shows level badge, click = Merge.unequip_to_inventory(slot_name)
##                 If item is null shows empty slot placeholder.
##
## Same .tscn file used everywhere; configure via `setup(...)`.
##
## Element coding:
##   - Card bg tinted per primary element tag (bronze / fire orange / ice blue)
##   - ElementBadge corner pill in top-left when fire/ice present
##   - Text colors adapt for legibility on dark fire/ice bgs
class_name PartCard
extends PanelContainer

## ---------- Style tokens ----------

## Desaturated palette (~60% saturation drop from prior values) for the
## cozy parchment vibe — fire / ice should be felt as warm/cool tilts on the
## bronze base, not Crayola callouts.
const BRONZE_BG       := Color(0.910, 0.769, 0.510, 1)
const BRONZE_BORDER   := Color(0.420, 0.255, 0.137, 1)
const FIRE_BG         := Color(0.671, 0.522, 0.412, 1)
const FIRE_BORDER     := Color(0.353, 0.255, 0.184, 1)
const FIRE_ACCENT     := Color(0.835, 0.596, 0.420, 1)
const ICE_BG          := Color(0.408, 0.467, 0.541, 1)
const ICE_BORDER      := Color(0.196, 0.243, 0.290, 1)
const ICE_ACCENT      := Color(0.541, 0.651, 0.745, 1)

const TEXT_DARK_NAME  := Color(0.176, 0.110, 0.059, 1)
const TEXT_DARK_STAT  := Color(0.165, 0.392, 0.157, 1)
const TEXT_DARK_COST  := Color(0.553, 0.353, 0.094, 1)

const TEXT_LIGHT_NAME := Color(1, 0.965, 0.871, 1)
const TEXT_LIGHT_STAT := Color(0.682, 1, 0.671, 1)
const TEXT_LIGHT_COST := Color(1, 0.871, 0.337, 1)

## Tier rim — overrides the per-element border based on _level. Layers cleanly
## on top of element-tinted backgrounds (bg stays element-driven, border
## becomes tier-driven). L5 animates through a rainbow cycle via _rim_tween.
const RIM_BRONZE   := Color(0.420, 0.255, 0.137, 1)
const RIM_SILVER   := Color(0.753, 0.753, 0.753, 1)
const RIM_GOLD     := Color(0.949, 0.722, 0.133, 1)
const RIM_PLATINUM := Color(0.898, 0.890, 0.890, 1)

## L5 rainbow stops — looped via _rim_tween. ~0.33 s per segment, ~2 s total cycle.
const RAINBOW_STOPS: Array = [
	Color(1.00, 0.40, 0.40),  ## red
	Color(1.00, 0.75, 0.30),  ## orange
	Color(1.00, 1.00, 0.40),  ## yellow
	Color(0.40, 1.00, 0.50),  ## green
	Color(0.40, 0.80, 1.00),  ## blue
	Color(0.80, 0.40, 1.00),  ## purple
]

## ---------- Node refs ----------

@onready var _icon: TextureRect = %Icon
@onready var _slot_label: Label = %SlotLabel
@onready var _slot_badge: PanelContainer = %SlotBadge
@onready var _element_label: Label = %ElementLabel
@onready var _element_badge: PanelContainer = %ElementBadge
@onready var _name_label: Label = %NameLabel
@onready var _stat_label: Label = %StatLabel
@onready var _cost_label: Label = %CostLabel
@onready var _level_badge: Label = %LevelBadge
@onready var _btn: Button = %Btn
@onready var _empty_label: Label = %EmptyLabel

var _mode: StringName = &"shop"
var _payload                  ## shop_idx:int OR InventoryItem OR slot_name:StringName
var _part_id: StringName = &""
var _level: int = 1
var _current_uid: int = -1

## Active rainbow Tween for L5 rim cycling. Killed on every refresh + exit.
var _rim_tween: Tween = null

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

## ---------- Setup helpers ----------

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
	_slot_badge.visible = true
	_apply_element_style(def.tag)
	_render_stats(def)
	_render_cost(def)
	_render_level_badge()
	tooltip_text = "%s (L%d)\n%s" % [def.name, _level, def.desc]

func _apply_element_style(tag: StringName) -> void:
	## Kill any prior L5 rainbow tween — fresh refresh resets the rim.
	if _rim_tween != null and _rim_tween.is_valid():
		_rim_tween.kill()
	_rim_tween = null

	## Card bg, element badge, and text colors swap together per element.
	var bg := BRONZE_BG
	var badge_color := Color.TRANSPARENT
	var badge_text := ""
	var text_name := TEXT_DARK_NAME
	var text_stat := TEXT_DARK_STAT
	var text_cost := TEXT_DARK_COST
	match tag:
		&"fire":
			bg = FIRE_BG
			badge_color = FIRE_ACCENT
			badge_text = "FIRE"
			text_name = TEXT_LIGHT_NAME
			text_stat = TEXT_LIGHT_STAT
			text_cost = TEXT_LIGHT_COST
		&"ice":
			bg = ICE_BG
			badge_color = ICE_ACCENT
			badge_text = "ICE"
			text_name = TEXT_LIGHT_NAME
			text_stat = TEXT_LIGHT_STAT
			text_cost = TEXT_LIGHT_COST
		_:
			pass
	## Card bg. Border = tier rim (level-driven, replaces former element border).
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	var rim_w: int = _tier_rim_width()
	sb.border_color = _tier_rim_color()
	sb.border_width_left = rim_w
	sb.border_width_top = rim_w
	sb.border_width_right = rim_w
	sb.border_width_bottom = rim_w
	sb.corner_radius_top_left = 8
	sb.corner_radius_top_right = 8
	sb.corner_radius_bottom_left = 8
	sb.corner_radius_bottom_right = 8
	add_theme_stylebox_override(&"panel", sb)
	## L5: spawn looping rainbow cycle through the stylebox border.
	if _level >= 5:
		_rim_tween = create_tween().set_loops()
		for c in RAINBOW_STOPS:
			_rim_tween.tween_property(sb, "border_color", c, 0.33)
	## Element badge.
	if badge_text == "":
		_element_badge.visible = false
	else:
		_element_badge.visible = true
		_element_label.text = badge_text
		var ebsb := StyleBoxFlat.new()
		ebsb.bg_color = badge_color
		ebsb.corner_radius_top_left = 0
		ebsb.corner_radius_top_right = 0
		ebsb.corner_radius_bottom_right = 4
		ebsb.corner_radius_bottom_left = 0
		ebsb.content_margin_left = 5.0
		ebsb.content_margin_right = 5.0
		ebsb.content_margin_top = 1.0
		ebsb.content_margin_bottom = 1.0
		_element_badge.add_theme_stylebox_override(&"panel", ebsb)
	## Adaptive text colors.
	_name_label.add_theme_color_override(&"font_color", text_name)
	_stat_label.add_theme_color_override(&"font_color", text_stat)
	_cost_label.add_theme_color_override(&"font_color", text_cost)

func _tier_rim_color() -> Color:
	match _level:
		1: return RIM_BRONZE
		2: return RIM_SILVER
		3: return RIM_GOLD
		4: return RIM_PLATINUM
		_: return RIM_GOLD  ## L5 starts here, tween takes over on next frames

func _tier_rim_width() -> int:
	match _level:
		1, 2: return 2
		3, 4: return 3
		_:    return 4

func _exit_tree() -> void:
	## Defensive: kill any active rim tween before the node leaves the tree.
	if _rim_tween != null and _rim_tween.is_valid():
		_rim_tween.kill()
	_rim_tween = null

func _render_stats(def: PartData) -> void:
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
	_slot_badge.visible = false
	_element_badge.visible = false
	_cost_label.visible = false
	_level_badge.visible = false
	tooltip_text = ""
	## Reset to bronze default (empty slots in the anvil should look "neutral").
	_apply_element_style(&"")

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
	_level = new_level
	var def = GameState.get_part_def(_part_id)
	if def != null:
		_render_stats(def)
	_render_level_badge()
	_level_badge.pivot_offset = _level_badge.size * 0.5
	pivot_offset = size * 0.5
	var t1 := create_tween()
	t1.tween_property(self, "scale", Vector2(1.18, 1.18), 0.10).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t1.tween_property(self, "scale", Vector2.ONE, 0.12)
	var orig: Color = self_modulate
	var t2 := create_tween()
	t2.tween_property(self, "self_modulate", Color(1.4, 1.2, 0.5, 1.0), 0.08)
	t2.tween_property(self, "self_modulate", orig, 0.30)
	_level_badge.scale = Vector2(2.0, 2.0)
	var t3 := create_tween()
	t3.tween_property(_level_badge, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_spawn_sparkle_sprite()
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
