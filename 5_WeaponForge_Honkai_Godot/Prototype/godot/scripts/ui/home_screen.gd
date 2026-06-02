## HomeScreen — the META layer: roster + loadout (armory), Forge Wheel pulls,
## stage progression, START BATTLE.
##
## Armory model (Model B "bench grid", owner-approved):
##   - Hero rows hold EQUIPPED weapons; the grid below holds UNEQUIPPED (bench).
##   - Tap a bench tile -> detail panel (full stats / ability / element) opens and
##     LEGAL hero rows highlight (class-matched, spec §9). Tap a hero -> equip;
##     the displaced weapon returns to the bench. Tap a hero with no selection ->
##     unequip. Tiles show shallow info only (rarity frame / name / element / ATK);
##     depth lives in the tap panel. Catalyst is a SQUAD property -> one trio line
##     above the grid (compound names light up when P1e lands).
extends Control

const ROSTER_IDS: Array = [&"bran", &"elara", &"vex"]
const GRID_COLS: int = 3
const MIN_GRID_TILES: int = 6   ## dashed empties up to this count ("pull to fill")

const ELEM_ICONS: Dictionary = {
	&"fire": "🔥", &"ice": "❄", &"electric": "⚡", &"wind": "🌪", &"earth": "🪨",
}
const RARITY_COLORS: Array = [
	Color(0.55, 0.55, 0.55), Color(0.35, 0.65, 1.0), Color(0.75, 0.4, 1.0),
	Color(1.0, 0.75, 0.25), Color(1.0, 0.3, 0.3),
]
const RARITY_NAMES: Array = ["Common", "Rare", "Epic", "Legendary", "Mythic"]

var _gems_label: Label = null
var _pull_btn: Button = null
var _battle_btn: Button = null
var _squad_line: Label = null
var _hero_rows: Dictionary = {}     ## hero_id -> Button
var _grid: GridContainer = null
var _detail: PanelContainer = null
var _detail_label: Label = null
var _selected_idx: int = -1         ## index into AccountState.owned_weapons, -1 = none

func _ready() -> void:
	_build_ui()
	_grant_starter_if_first_boot()
	AccountState.gems_changed.connect(func(_g): _refresh())
	AccountState.owned_weapons_changed.connect(func(): _refresh())
	if get_node_or_null("/root/ForgeWheel") != null:
		ForgeWheel.pull_completed.connect(func(_r): _refresh())
	_refresh()

## ---------- UI construction ----------

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.07, 0.06, 0.10)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var v := VBoxContainer.new()
	v.set_anchors_preset(Control.PRESET_FULL_RECT)
	v.offset_left = 18.0
	v.offset_right = -18.0
	v.offset_top = 16.0
	v.offset_bottom = -16.0
	v.add_theme_constant_override(&"separation", 8)
	add_child(v)

	var title := Label.new()
	title.text = "⚒ WEAPONFORGE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override(&"font_size", 28)
	v.add_child(title)

	var reset := Button.new()
	reset.text = "reset account (debug)"
	reset.add_theme_font_size_override(&"font_size", 9)
	reset.modulate = Color(1, 1, 1, 0.45)
	reset.pressed.connect(func():
		AccountState.reset_account()
		_selected_idx = -1
		_grant_starter_if_first_boot()
		_refresh())
	v.add_child(reset)

	_gems_label = Label.new()
	_gems_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_gems_label.add_theme_font_size_override(&"font_size", 16)
	v.add_child(_gems_label)

	var squad_title := Label.new()
	squad_title.text = "— SQUAD —"
	squad_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	squad_title.modulate = Color(1, 1, 1, 0.7)
	v.add_child(squad_title)

	for id in ROSTER_IDS:
		var row := Button.new()
		row.custom_minimum_size = Vector2(0, 40)
		row.alignment = HORIZONTAL_ALIGNMENT_LEFT
		row.add_theme_font_size_override(&"font_size", 12)
		row.pressed.connect(_on_hero_row_pressed.bind(id))
		v.add_child(row)
		_hero_rows[id] = row

	## Squad-level element trio (Catalyst readout — compound names land with P1e).
	_squad_line = Label.new()
	_squad_line.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_squad_line.add_theme_font_size_override(&"font_size", 12)
	_squad_line.modulate = Color(0.8, 0.9, 1.0)
	v.add_child(_squad_line)

	var bench_title := Label.new()
	bench_title.text = "— ARMORY (tap a weapon, then a hero) —"
	bench_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bench_title.modulate = Color(1, 1, 1, 0.7)
	bench_title.add_theme_font_size_override(&"font_size", 11)
	v.add_child(bench_title)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 170)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(scroll)

	_grid = GridContainer.new()
	_grid.columns = GRID_COLS
	_grid.add_theme_constant_override(&"h_separation", 8)
	_grid.add_theme_constant_override(&"v_separation", 8)
	_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_grid)

	## Weapon detail panel (hidden until a tile is selected).
	_detail = PanelContainer.new()
	_detail.visible = false
	_detail_label = Label.new()
	_detail_label.add_theme_font_size_override(&"font_size", 11)
	_detail.add_child(_detail_label)
	v.add_child(_detail)

	_pull_btn = Button.new()
	_pull_btn.custom_minimum_size = Vector2(0, 48)
	_pull_btn.pressed.connect(_on_pull_pressed)
	v.add_child(_pull_btn)

	var odds := Label.new()
	odds.text = "Equal odds · weapons for your unlocked classes"
	odds.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	odds.add_theme_font_size_override(&"font_size", 9)
	odds.modulate = Color(1, 1, 1, 0.5)
	v.add_child(odds)

	_battle_btn = Button.new()
	_battle_btn.custom_minimum_size = Vector2(0, 56)
	_battle_btn.add_theme_font_size_override(&"font_size", 20)
	_battle_btn.pressed.connect(_on_battle_pressed)
	v.add_child(_battle_btn)

## ---------- FTUE ----------

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

## ---------- Refresh ----------

func _elem_icon(rune: StringName) -> String:
	return String(ELEM_ICONS.get(rune, "•"))

func _refresh() -> void:
	_gems_label.text = "💎 %d gems   ·   🏰 Stage %d" % [AccountState.gems, AccountState.current_stage]
	_battle_btn.text = "⚔ START BATTLE — STAGE %d" % AccountState.current_stage
	var broke: bool = AccountState.gems < AccountState.PULL_COST
	_pull_btn.disabled = broke
	_pull_btn.text = ("⚒ FORGE WHEEL — need 300💎 (clear waves to earn!)" if broke
		else "⚒ FORGE WHEEL — PULL WEAPON (300💎)")
	_refresh_hero_rows()
	_refresh_grid()
	_refresh_squad_line()
	_refresh_detail()

func _refresh_hero_rows() -> void:
	var selected = AccountState.owned_weapons[_selected_idx] if _selected_idx >= 0 else null
	for id in _hero_rows:
		var row: Button = _hero_rows[id]
		var data = GameState.heroes_by_id.get(id)
		if data == null:
			row.text = ""
			continue
		var w = AccountState.get_equipped(id)
		var weapon_str: String = "—  tap a weapon below to equip"
		if w != null:
			weapon_str = "%s %s · ATK %d" % [_elem_icon(w.rune), w.name, w.get_atk()]
		row.text = "  %s (%s)    %s" % [data.name, String(data.cls).capitalize(), weapon_str]
		## Legal target highlight while a bench weapon is selected.
		var legal: bool = selected != null and data.cls == selected.cls
		row.modulate = Color(1.0, 0.9, 0.4) if legal else Color(1, 1, 1)

func _refresh_grid() -> void:
	for c in _grid.get_children():
		c.queue_free()
	var equipped_indices: Dictionary = {}
	for hid in AccountState.equipped:
		equipped_indices[int(AccountState.equipped[hid])] = true
	var tiles: int = 0
	for i in range(AccountState.owned_weapons.size()):
		if equipped_indices.has(i):
			continue   ## equipped weapons live on the hero rows, not the bench
		_grid.add_child(_make_tile(i))
		tiles += 1
	for _i in range(maxi(0, MIN_GRID_TILES - tiles)):
		_grid.add_child(_make_empty_tile())

func _make_tile(owned_idx: int) -> Button:
	var w = AccountState.owned_weapons[owned_idx]
	var b := Button.new()
	b.custom_minimum_size = Vector2(118, 74)
	var rarity: int = clampi(w.rarity_idx, 0, RARITY_COLORS.size() - 1)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.12, 0.11, 0.16)
	sb.border_color = RARITY_COLORS[rarity]
	sb.set_border_width_all(3 if owned_idx == _selected_idx else 1)
	sb.set_corner_radius_all(6)
	b.add_theme_stylebox_override(&"normal", sb)
	b.add_theme_font_size_override(&"font_size", 10)
	b.text = "%s\n%s · ATK %d\n★%d %s" % [w.name, _elem_icon(w.rune), w.get_atk(),
		w.star_tier, RARITY_NAMES[rarity]]
	b.pressed.connect(_on_tile_pressed.bind(owned_idx))
	return b

func _make_empty_tile() -> Panel:
	var p := Panel.new()
	p.custom_minimum_size = Vector2(118, 74)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.09, 0.08, 0.12)
	sb.border_color = Color(1, 1, 1, 0.15)
	sb.set_border_width_all(1)
	sb.set_corner_radius_all(6)
	p.add_theme_stylebox_override(&"panel", sb)
	return p

func _refresh_squad_line() -> void:
	var icons: Array = []
	for id in ROSTER_IDS:
		var w = AccountState.get_equipped(id)
		icons.append(_elem_icon(w.rune) if w != null else "·")
	_squad_line.text = "Squad elements:  %s  (Catalyst compounds land in P1e)" % "  ".join(icons)

func _refresh_detail() -> void:
	if _selected_idx < 0 or _selected_idx >= AccountState.owned_weapons.size():
		_detail.visible = false
		return
	var w = AccountState.owned_weapons[_selected_idx]
	var rarity: int = clampi(w.rarity_idx, 0, RARITY_NAMES.size() - 1)
	_detail_label.text = "%s  —  ★%d %s\nATK %d · HP %d · CRIT %d%% · ULT %d%%\nAbility: %s\nElement: %s %s — pairs with other elements for Catalyst (P1e)\nTap a highlighted hero to equip." % [
		w.name, w.star_tier, RARITY_NAMES[rarity],
		w.get_atk(), w.get_hp(), w.get_crit(), w.get_ult_rate(),
		(w.ability if w.ability != "" else "—"),
		_elem_icon(w.rune), String(w.rune).capitalize()]
	_detail.visible = true

## ---------- Interaction ----------

func _on_tile_pressed(owned_idx: int) -> void:
	_selected_idx = -1 if _selected_idx == owned_idx else owned_idx
	_refresh()

func _on_hero_row_pressed(hero_id: StringName) -> void:
	if _selected_idx >= 0:
		if AccountState.equip(hero_id, _selected_idx):
			_selected_idx = -1
		## Mismatch: keep selection so the player can pick the right hero.
	else:
		AccountState.unequip(hero_id)
	_refresh()

func _on_pull_pressed() -> void:
	var result: Dictionary = ForgeWheel.pull()
	if result.is_empty():
		return
	ForgeWheel.show_reveal(result)
	_refresh()

func _on_battle_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
