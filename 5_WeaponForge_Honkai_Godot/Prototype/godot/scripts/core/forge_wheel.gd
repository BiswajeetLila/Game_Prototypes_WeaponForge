## ForgeWheel — weapon-pull service (increment #2) + temporary debug pull UI.
##
## Service: pull() spends AccountState.PULL_COST gems, picks uniformly from the
## starter catalog FILTERED to unlocked classes, acquires a runtime instance via
## AccountState.acquire_weapon (duplicate — never the catalog .tres), equips it on
## the first hero of that class (GameState.equip_weapon_data + AccountState.equip),
## and returns {weapon, hero_id, old_atk, new_atk} for the reveal's damage delta.
## Insufficient gems or no eligible weapon -> {} with ZERO state change.
##
## Debug UI (skipped headless; replaced by the real slot-machine wheel in #3):
## top-right gems label + PULL button + odds line, and a full-screen reveal
## overlay — rarity-colored flash (visual channel) + combat-log line (second
## channel; no audio assets exist yet) + name/class/element + ATK before->after.
extends Node

const WeaponDataT = preload("res://scripts/data/weapon_data.gd")

signal pull_completed(result: Dictionary)

const RARITY_NAMES: Array = ["Common", "Rare", "Epic", "Legendary", "Mythic"]
const RARITY_COLORS: Array = [
	Color(0.75, 0.75, 0.75),  ## common - grey
	Color(0.35, 0.65, 1.0),   ## rare - blue
	Color(0.75, 0.4, 1.0),    ## epic - purple
	Color(1.0, 0.75, 0.25),   ## legendary - gold
	Color(1.0, 0.3, 0.3),     ## mythic - red
]

var _ui_layer: CanvasLayer = null
var _gems_label: Label = null
var _pull_btn: Button = null
var _reveal: ColorRect = null
var _reveal_title: Label = null
var _reveal_name: Label = null
var _reveal_meta: Label = null
var _reveal_delta: Label = null

func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		return
	_build_debug_ui()
	AccountState.gems_changed.connect(func(_g): _refresh_ui())
	GameState.wave_changed.connect(func(_w): _refresh_ui())
	_refresh_ui()

## ---------- Pull service ----------

func eligible_weapons() -> Array:
	var out: Array = []
	for id in GameState.weapon_ids:
		var w = GameState.weapons_by_id[id]
		if GameState.unlocked_classes.has(w.cls):
			out.append(w)
	return out

func can_pull() -> bool:
	return AccountState.gems >= AccountState.PULL_COST and not eligible_weapons().is_empty()

func pull() -> Dictionary:
	var eligible: Array = eligible_weapons()
	if eligible.is_empty():
		return {}
	if not AccountState.spend_gems(AccountState.PULL_COST):
		return {}
	var catalog_pick = eligible[randi() % eligible.size()]
	var owned = AccountState.acquire_weapon(catalog_pick)
	var hero_id: StringName = _first_hero_of_class(catalog_pick.cls)
	var hero = GameState.get_hero(hero_id)
	var old_atk: int = hero.data.atk_base + hero.eff_atk()
	GameState.equip_weapon_data(hero_id, owned)
	AccountState.equip(hero_id, AccountState.owned_weapons.size() - 1)
	var result: Dictionary = {
		"weapon": owned,
		"hero_id": hero_id,
		"old_atk": old_atk,
		"new_atk": hero.data.atk_base + hero.eff_atk(),
	}
	GameState.append_combat_log("[color=66ddff]⚒ Forge Wheel: %s — %s! ATK %d → %d[/color]"
		% [hero.data.name, owned.name, result.old_atk, result.new_atk])
	AccountState.autosave()
	pull_completed.emit(result)
	return result

func _first_hero_of_class(cls: StringName) -> StringName:
	for id in GameState.squad_order:
		var h = GameState.get_hero(id)
		if h != null and h.data.cls == cls:
			return id
	return &""

## ---------- Debug UI (visual sessions only) ----------

func _build_debug_ui() -> void:
	_ui_layer = CanvasLayer.new()
	_ui_layer.layer = 50
	add_child(_ui_layer)

	var panel := VBoxContainer.new()
	panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	panel.offset_left = -190.0
	panel.offset_top = 8.0
	panel.offset_right = -8.0
	panel.add_theme_constant_override(&"separation", 4)
	_ui_layer.add_child(panel)

	_gems_label = Label.new()
	_gems_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	panel.add_child(_gems_label)

	_pull_btn = Button.new()
	_pull_btn.text = "⚒ PULL  (300💎)"
	_pull_btn.pressed.connect(_on_pull_pressed)
	panel.add_child(_pull_btn)

	var odds := Label.new()
	odds.text = "Equal odds, your classes only"
	odds.add_theme_font_size_override(&"font_size", 10)
	odds.modulate = Color(1, 1, 1, 0.6)
	odds.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	panel.add_child(odds)

	## Full-screen reveal overlay (hidden until a pull resolves).
	_reveal = ColorRect.new()
	_reveal.color = Color(0, 0, 0, 0.85)
	_reveal.set_anchors_preset(Control.PRESET_FULL_RECT)
	_reveal.visible = false
	_ui_layer.add_child(_reveal)

	var center := VBoxContainer.new()
	center.set_anchors_preset(Control.PRESET_CENTER)
	center.offset_left = -160.0
	center.offset_right = 160.0
	center.offset_top = -90.0
	center.add_theme_constant_override(&"separation", 8)
	_reveal.add_child(center)

	_reveal_title = Label.new()
	_reveal_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_reveal_title.add_theme_font_size_override(&"font_size", 22)
	center.add_child(_reveal_title)

	_reveal_name = Label.new()
	_reveal_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_reveal_name.add_theme_font_size_override(&"font_size", 28)
	center.add_child(_reveal_name)

	_reveal_meta = Label.new()
	_reveal_meta.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	center.add_child(_reveal_meta)

	_reveal_delta = Label.new()
	_reveal_delta.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_reveal_delta.add_theme_font_size_override(&"font_size", 18)
	center.add_child(_reveal_delta)

	var dismiss := Button.new()
	dismiss.text = "Tap to continue"
	dismiss.pressed.connect(func(): _reveal.visible = false)
	center.add_child(dismiss)

func _refresh_ui() -> void:
	if _gems_label == null:
		return
	_gems_label.text = "💎 %d" % AccountState.gems
	_pull_btn.disabled = not can_pull()

func _on_pull_pressed() -> void:
	var result: Dictionary = pull()
	_refresh_ui()
	if result.is_empty():
		return
	_show_reveal(result)

func _show_reveal(result: Dictionary) -> void:
	var w = result.weapon
	var rarity: int = clampi(w.rarity_idx, 0, RARITY_NAMES.size() - 1)
	var c: Color = RARITY_COLORS[rarity]
	_reveal_title.text = "%s WEAPON!" % String(RARITY_NAMES[rarity]).to_upper()
	_reveal_title.modulate = c
	_reveal_name.text = w.name
	_reveal_name.modulate = c
	_reveal_meta.text = "%s · %s · for %s" % [String(w.cls).capitalize(), String(w.rune).capitalize(),
		String(result.hero_id).capitalize()]
	_reveal_delta.text = "ATK %d → %d" % [result.old_atk, result.new_atk]
	_reveal.visible = true
	## Rarity flash: overlay blinks in from the rarity color, settles to dark.
	_reveal.color = Color(c.r, c.g, c.b, 0.55)
	var tw := create_tween()
	tw.tween_property(_reveal, "color", Color(0, 0, 0, 0.85), 0.45)
