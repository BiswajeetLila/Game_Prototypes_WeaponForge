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
var _detail: PopupPanel = null
var _detail_label: Label = null
var _selected_idx: int = -1         ## index into AccountState.owned_weapons, -1 = none
var _selected_hero: StringName = &""  ## set when the selection is an EQUIPPED weapon (its hero); else &""
var _shard_label: Label = null
var _detail_actions: VBoxContainer = null  ## rebuilt each refresh: Forge + Equip/Unequip
var _confirm: ConfirmationDialog = null

func _ready() -> void:
	_build_ui()
	_grant_starter_if_first_boot()
	AccountState.gems_changed.connect(func(_g): _refresh())
	AccountState.owned_weapons_changed.connect(func(): _refresh())
	AccountState.shards_changed.connect(func(): _refresh())
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
		_selected_idx = -1                 ## clear selection BEFORE the array empties (#6)
		_selected_hero = &""
		AccountState.reset_account()
		_grant_starter_if_first_boot()
		_refresh())
	v.add_child(reset)

	_gems_label = Label.new()
	_gems_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_gems_label.add_theme_font_size_override(&"font_size", 16)
	v.add_child(_gems_label)

	_shard_label = Label.new()
	_shard_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_shard_label.add_theme_font_size_override(&"font_size", 12)
	_shard_label.modulate = Color(0.7, 0.85, 1.0)
	v.add_child(_shard_label)

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

	## Weapon detail as a POPUP overlay: it does NOT reflow the page (so START BATTLE
	## stays put) and auto-closes on any click outside it. ALL weapon actions
	## (Forge, Equip → <hero>, Unequip) live INSIDE the popup, rebuilt per refresh.
	_detail = PopupPanel.new()
	_detail.popup_hide.connect(_on_detail_closed)
	var detail_v := VBoxContainer.new()
	detail_v.add_theme_constant_override(&"separation", 8)
	detail_v.custom_minimum_size = Vector2(320, 0)
	_detail.add_child(detail_v)
	_detail_label = Label.new()
	_detail_label.add_theme_font_size_override(&"font_size", 12)
	detail_v.add_child(_detail_label)
	_detail_actions = VBoxContainer.new()
	_detail_actions.add_theme_constant_override(&"separation", 6)
	detail_v.add_child(_detail_actions)
	add_child(_detail)

	## Irreversible-infuse confirm (built once, reused).
	_confirm = ConfirmationDialog.new()
	_confirm.title = "Forge — infuse shard?"
	_confirm.confirmed.connect(_on_infuse_confirmed)
	add_child(_confirm)

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
	## Arm ALL three heroes with their class Common so nobody starts empty-handed (#4/#5).
	var starters: Array = [
		[&"bran", &"w_emberfang_cleaver"],
		[&"elara", &"w_frostcall_stave"],
		[&"vex", &"w_stormpierce_fangs"],
	]
	for pair in starters:
		var wdef = GameState.weapons_by_id.get(pair[1])
		if wdef == null:
			continue
		AccountState.acquire_weapon(wdef)
		AccountState.equip(pair[0], AccountState.owned_weapons.size() - 1)
	AccountState.autosave()
	GameState.append_combat_log("⚒ Starters granted: Bran / Elara / Vex each armed with a Common.")

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
	_shard_label.text = "🔧 %d Forge Shards   (tap a weapon, then Forge)" % AccountState.shards.size()
	_refresh_hero_rows()
	_refresh_grid()
	_refresh_squad_line()
	_refresh_detail()

func _refresh_hero_rows() -> void:
	var selected = AccountState.owned_weapons[_selected_idx] if (_selected_idx >= 0 and _selected_idx < AccountState.owned_weapons.size()) else null
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
	## Class tag, top-right corner (rarity-coloured). Ignores mouse so the tile stays tappable.
	var tag := Label.new()
	tag.text = String(w.cls).capitalize()
	tag.add_theme_font_size_override(&"font_size", 8)
	tag.modulate = RARITY_COLORS[rarity]
	tag.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	tag.offset_left = -54
	tag.offset_top = 4
	tag.offset_right = -6
	tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(tag)
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
		if _detail.visible:
			_detail.hide()
		return
	var w = AccountState.owned_weapons[_selected_idx]
	var rarity: int = clampi(w.rarity_idx, 0, RARITY_NAMES.size() - 1)
	var where: String = "On the bench" if _selected_hero == &"" else "Equipped on %s" % String(_selected_hero).capitalize()
	_detail_label.text = "%s  —  ★%d %s\nATK %d · HP %d · CRIT %d%% · ULT %d%%\nAbility: %s\nElement: %s %s\nForge: %s\nStar: %s\n%s\n(tap outside to close)" % [
		w.name, w.star_tier, RARITY_NAMES[rarity],
		w.get_atk(), w.get_hp(), w.get_crit(), w.get_ult_rate(),
		(w.ability if w.ability != "" else "—"),
		_elem_icon(w.rune), String(w.rune).capitalize(), _forge_bar_str(w), _star_bar_str(w), where]
	_rebuild_detail_actions(w)
	if not _detail.visible:
		_detail.popup_centered()

## Rebuild the popup's action buttons for the selected weapon: Forge (infuse) +
## either Equip → <legal hero> (bench weapon) or Unequip (equipped weapon).
func _rebuild_detail_actions(w) -> void:
	for c in _detail_actions.get_children():
		c.queue_free()
	var maxed: bool = w.rarity_idx >= w.MAX_RARITY_IDX
	var have_shards: bool = not AccountState.shards.is_empty()
	var forge := Button.new()
	forge.custom_minimum_size = Vector2(0, 36)
	forge.disabled = maxed or not have_shards
	forge.text = ("Maxed: Mythic" if maxed
		else ("⚒ Forge (need shards)" if not have_shards else "⚒ Forge (spend 1 shard)"))
	forge.pressed.connect(_on_infuse_pressed)
	_detail_actions.add_child(forge)
	if _selected_hero == &"":
		## Bench weapon -> one Equip button per LEGAL (class-matched) hero.
		for id in ROSTER_IDS:
			var hd = GameState.heroes_by_id.get(id)
			if hd == null or hd.cls != w.cls:
				continue
			var eq := Button.new()
			eq.custom_minimum_size = Vector2(0, 34)
			eq.text = "Equip → %s" % String(id).capitalize()
			eq.pressed.connect(_on_equip_pressed.bind(id))
			_detail_actions.add_child(eq)
	else:
		var un := Button.new()
		un.custom_minimum_size = Vector2(0, 34)
		un.text = "Unequip"
		un.pressed.connect(_on_unequip_pressed)
		_detail_actions.add_child(un)

## Human-readable star-up bar, e.g. "★1 · 2/3 dupes to ★2" (or "★10 (max)").
## Dupes feed this; a dupe that doesn't tier up still moves star_progress here.
func _star_bar_str(w) -> String:
	if w.star_tier >= w.MAX_STAR_TIER:
		return "★%d (max)" % w.star_tier
	return "★%d  ·  %d/%d dupes to ★%d" % [w.star_tier, w.star_progress, w.DUPES_PER_STAR, w.star_tier + 1]

## Human-readable rarity bar, e.g. "Common → Rare  44%" (or "Mythic (max)").
func _forge_bar_str(w) -> String:
	var rarity: int = clampi(w.rarity_idx, 0, RARITY_NAMES.size() - 1)
	if w.rarity_idx >= w.MAX_RARITY_IDX:
		return "%s (max)" % RARITY_NAMES[rarity]
	var pct: int = int(round(w.forge_progress * 100.0))
	return "%s → %s  %d%%" % [RARITY_NAMES[rarity], RARITY_NAMES[rarity + 1], pct]

## ---------- Interaction ----------

func _on_tile_pressed(owned_idx: int) -> void:
	_selected_idx = -1 if (_selected_idx == owned_idx and _selected_hero == &"") else owned_idx
	_selected_hero = &""   ## bench selection
	_refresh()

func _on_hero_row_pressed(hero_id: StringName) -> void:
	## Open this hero's EQUIPPED weapon in the detail popup (inspect / forge / unequip).
	## Equipping a bench weapon is done from INSIDE the popup (Equip → <hero> buttons).
	var idx: int = int(AccountState.equipped.get(hero_id, -1))
	_selected_idx = idx
	_selected_hero = hero_id if idx >= 0 else &""
	_refresh()

func _on_unequip_pressed() -> void:
	if _selected_hero != &"":
		AccountState.unequip(_selected_hero)
		_selected_idx = -1
		_selected_hero = &""
		_refresh()

func _on_equip_pressed(hero_id: StringName) -> void:
	## Equip the selected BENCH weapon on this (legal) hero, then close the popup.
	if _selected_idx < 0:
		return
	if AccountState.equip(hero_id, _selected_idx):
		_selected_idx = -1
		_selected_hero = &""
		_refresh()

func _on_detail_closed() -> void:
	## Popup dismissed (outside click / hide) -> drop the selection so the tiles
	## and hero rows deselect and the panel stays closed.
	if _selected_idx != -1 or _selected_hero != &"":
		_selected_idx = -1
		_selected_hero = &""
		_refresh()

func _on_pull_pressed() -> void:
	var result: Dictionary = ForgeWheel.pull()
	if result.is_empty():
		return
	ForgeWheel.show_reveal(result)
	_refresh()

func _on_battle_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

## ---------- Forge (deterministic infuse — no skill/minigame) ----------

func _on_infuse_pressed() -> void:
	if _selected_idx < 0 or _selected_idx >= AccountState.owned_weapons.size():
		return
	var sidx: int = _lowest_shard_idx()
	if sidx < 0:
		return
	var w = AccountState.owned_weapons[_selected_idx]
	if w.rarity_idx >= w.MAX_RARITY_IDX:
		return
	var shard = AccountState.shards[sidx]
	## Non-mutating before -> after preview via a deep dup.
	var dry = w.duplicate(true)
	var tier_up: bool = dry.apply_forge_shard(shard.rarity_idx)
	var sr: int = clampi(shard.rarity_idx, 0, RARITY_NAMES.size() - 1)
	var txt: String = "Spend a %s Shard on %s.\n\n%s\n→ %s" % [
		RARITY_NAMES[sr], w.name, _forge_bar_str(w), _forge_bar_str(dry)]
	if tier_up:
		txt += "\n\n★ TIER UP to %s!" % RARITY_NAMES[clampi(dry.rarity_idx, 0, RARITY_NAMES.size() - 1)]
	if w.forge_target_idx != -1 and w.forge_target_idx != w.rarity_idx + 1:
		txt += "\n\n⚠ Resets pending forge progress toward a different tier."
	txt += "\n\nShards are consumed permanently."
	_confirm.dialog_text = txt
	_confirm.popup_centered()

func _on_infuse_confirmed() -> void:
	var sidx: int = _lowest_shard_idx()
	if sidx < 0:
		return
	var r: Dictionary = AccountState.infuse(_selected_idx, sidx)
	if r.get("ok", false):
		var w = AccountState.owned_weapons[_selected_idx]
		GameState.append_combat_log("[color=ffcc66]⚒ Forged %s → %s%s[/color]" % [
			w.name, RARITY_NAMES[clampi(w.rarity_idx, 0, RARITY_NAMES.size() - 1)],
			"  TIER UP!" if r.get("tier_up", false) else ""])
		_flash_detail(Color(1.0, 0.85, 0.3) if r.get("tier_up", false) else Color(0.6, 0.9, 1.0))
	_refresh()

## Spend the LOWEST-rarity shard first (conserve the big ones). -1 = none.
func _lowest_shard_idx() -> int:
	if AccountState.shards.is_empty():
		return -1
	var best: int = 0
	for i in range(AccountState.shards.size()):
		if AccountState.shards[i].rarity_idx < AccountState.shards[best].rarity_idx:
			best = i
	return best

func _flash_detail(c: Color) -> void:
	_detail.modulate = c
	var tw := create_tween()
	tw.tween_property(_detail, "modulate", Color(1, 1, 1), 0.4)
