## HomeScreen — the META layer (R4). This is "the other stuff" outside combat:
## see your roster + their loaded weapons, PULL gacha weapons (Forge Wheel),
## then START BATTLE. Battle ends -> back here. Wittle pulls heroes; we pull
## weapons onto a locked roster — this screen IS that inversion.
##
## FTUE: first boot with an empty account grants + equips a free starter weapon
## on Bran (spec FM: guaranteed first pull) so wave 1 never starts bare-handed.
extends Control

const ROSTER_IDS: Array = [&"bran", &"elara", &"vex"]

var _gems_label: Label = null
var _pull_btn: Button = null
var _battle_btn: Button = null
var _roster_box: VBoxContainer = null

func _ready() -> void:
	_build_ui()
	_grant_starter_if_first_boot()
	AccountState.gems_changed.connect(func(_g): _refresh())
	AccountState.owned_weapons_changed.connect(func(): _refresh())
	if get_node_or_null("/root/ForgeWheel") != null:
		ForgeWheel.pull_completed.connect(func(_r): _refresh())
	_refresh()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.07, 0.06, 0.10)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var v := VBoxContainer.new()
	v.set_anchors_preset(Control.PRESET_FULL_RECT)
	v.offset_left = 24.0
	v.offset_right = -24.0
	v.offset_top = 28.0
	v.offset_bottom = -28.0
	v.add_theme_constant_override(&"separation", 14)
	add_child(v)

	var title := Label.new()
	title.text = "⚒ WEAPONFORGE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override(&"font_size", 30)
	v.add_child(title)

	## Debug: wipe the account back to first-boot (fresh 600 gems + starter grant).
	var reset := Button.new()
	reset.text = "reset account (debug)"
	reset.add_theme_font_size_override(&"font_size", 9)
	reset.modulate = Color(1, 1, 1, 0.45)
	reset.pressed.connect(func():
		AccountState.reset_account()
		_grant_starter_if_first_boot()
		_refresh())
	v.add_child(reset)

	_gems_label = Label.new()
	_gems_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_gems_label.add_theme_font_size_override(&"font_size", 18)
	v.add_child(_gems_label)

	var roster_title := Label.new()
	roster_title.text = "— SQUAD —"
	roster_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	roster_title.modulate = Color(1, 1, 1, 0.7)
	v.add_child(roster_title)

	_roster_box = VBoxContainer.new()
	_roster_box.add_theme_constant_override(&"separation", 6)
	v.add_child(_roster_box)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(spacer)

	_pull_btn = Button.new()
	_pull_btn.text = "⚒ FORGE WHEEL — PULL WEAPON (300💎)"
	_pull_btn.custom_minimum_size = Vector2(0, 52)
	_pull_btn.pressed.connect(_on_pull_pressed)
	v.add_child(_pull_btn)

	var odds := Label.new()
	odds.text = "Equal odds · weapons for your unlocked classes"
	odds.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	odds.add_theme_font_size_override(&"font_size", 10)
	odds.modulate = Color(1, 1, 1, 0.55)
	v.add_child(odds)

	_battle_btn = Button.new()
	_battle_btn.custom_minimum_size = Vector2(0, 64)
	_battle_btn.add_theme_font_size_override(&"font_size", 22)
	_battle_btn.pressed.connect(_on_battle_pressed)
	v.add_child(_battle_btn)

func _grant_starter_if_first_boot() -> void:
	if not AccountState.owned_weapons.is_empty():
		return
	var starter = GameState.weapons_by_id.get(&"w_emberfang_cleaver")
	if starter == null:
		return
	AccountState.acquire_weapon(starter)
	AccountState.equip(&"bran", 0)
	AccountState.autosave()
	GameState.append_combat_log("⚒ Starter weapon granted: Emberfang Cleaver → Bran")

func _refresh() -> void:
	_gems_label.text = "💎 %d gems   ·   🏰 Stage %d" % [AccountState.gems, AccountState.current_stage]
	_battle_btn.text = "⚔ START BATTLE — STAGE %d" % AccountState.current_stage
	var broke: bool = AccountState.gems < AccountState.PULL_COST
	_pull_btn.disabled = broke
	_pull_btn.text = ("⚒ FORGE WHEEL — need 300💎 (clear waves to earn!)" if broke
		else "⚒ FORGE WHEEL — PULL WEAPON (300💎)")
	for child in _roster_box.get_children():
		child.queue_free()
	for id in ROSTER_IDS:
		var data = GameState.heroes_by_id.get(id)
		if data == null:
			continue
		var row := Label.new()
		var w = AccountState.get_equipped(id)
		var weapon_str: String = "—  no weapon"
		if w != null:
			weapon_str = "%s  ·  ATK %d  ·  %s" % [w.name, w.get_atk(), String(w.rune).capitalize()]
		row.text = "%s  (%s)    %s" % [data.name, String(data.cls).capitalize(), weapon_str]
		_roster_box.add_child(row)

func _on_pull_pressed() -> void:
	var result: Dictionary = ForgeWheel.pull()
	if result.is_empty():
		return
	ForgeWheel.show_reveal(result)
	_refresh()

func _on_battle_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
