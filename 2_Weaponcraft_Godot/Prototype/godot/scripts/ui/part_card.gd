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
@onready var _cost_label: Label = %CostLabel
@onready var _level_badge: Label = %LevelBadge
@onready var _btn: Button = %Btn
@onready var _empty_label: Label = %EmptyLabel

var _mode: StringName = &"shop"
var _payload                  ## shop_idx:int OR InventoryItem OR slot_name:StringName
var _part_id: StringName = &""
var _level: int = 1

signal clicked(card, mode: StringName, payload)

func _ready() -> void:
	_btn.pressed.connect(func(): emit_signal(&"clicked", self, _mode, _payload))

## Setup helpers. Pass null part_id for empty slot in anvil mode.

func setup_shop(part_id: StringName, shop_idx: int) -> void:
	_mode = &"shop"
	_payload = shop_idx
	_part_id = part_id
	_level = 1
	_refresh()

func setup_inventory(item) -> void:
	_mode = &"inventory"
	_payload = item
	_part_id = item.part_id if item != null else &""
	_level = item.level if item != null else 1
	_refresh()

func setup_anvil(item, slot_name: StringName) -> void:
	_mode = &"anvil"
	_payload = slot_name
	_part_id = item.part_id if item != null else &""
	_level = item.level if item != null else 1
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
	_render_cost(def)
	_render_level_badge()
	tooltip_text = "%s\n%s" % [def.name, def.desc]

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
