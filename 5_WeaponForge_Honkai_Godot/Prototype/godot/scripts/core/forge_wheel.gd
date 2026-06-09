## ForgeWheel — weapon-pull service (increment #2) + temporary debug pull UI.
##
## Service: pull() spends AccountState.PULL_COST_EMBER Ember, picks uniformly from the
## starter catalog FILTERED to unlocked classes, acquires a runtime instance via
## AccountState.acquire_weapon (duplicate — never the catalog .tres), equips it on
## the first hero of that class (GameState.equip_weapon_data + AccountState.equip),
## and returns {weapon, hero_id, old_atk, new_atk} for the reveal's damage delta.
## Insufficient Ember or no eligible weapon -> {} with ZERO state change.
##
## Debug UI (skipped headless; replaced by the real slot-machine wheel in #3):
## top-right gems label + PULL button + odds line, and a full-screen reveal
## overlay — rarity-colored flash (visual channel) + combat-log line (second
## channel; no audio assets exist yet) + name/class/element + ATK before->after.
extends Node

const WeaponDataT = preload("res://scripts/data/weapon_data.gd")
const ShardDataT = preload("res://scripts/data/shard_data.gd")

signal pull_completed(result: Dictionary)

## Weapon drop pyramid by intrinsic rarity (C/R/E/L/M). Mythic = 0 (hero-bound
## signatures aren't pulled). STARTING VALUES (Numbers Policy).
const WEAPON_DROP_WEIGHT: Array = [50.0, 30.0, 15.0, 5.0, 0.0]
## Dupe consolation: a duplicate pull mints gems (the forge currency) by the
## pulled weapon's rarity, instead of feeding star progress. C/R/E/L/M.
const DUPE_GEMS: Array = [20, 40, 80, 160, 320]
## Shard rarity drop odds — cumulative %, C/R/E/L. STARTING VALUES.
const SHARD_RARITY_ODDS: Array = [55, 85, 97, 100]

## Catalyst v1 scripted starter pulls (spec 2026-06-09-catalyst-design §6).
## Pull #1 = guaranteed Fire-warrior; Pull #3 = guaranteed Ice-mage.
## Owner-amended B2: scripted picks land on the only Rare+ matches —
## Cinderbrand Greatsword (Epic fire-warrior) + Glacial Aegis Staff
## (Legendary ice-mage). Tracked via AccountState.scripted_pulls_seen
## (idempotent across save/load); scheduling reads AccountState.pull_count + 1.
const SCRIPT_PULL_1_SENTINEL: StringName = &"pull_1_fire_warrior"
const SCRIPT_PULL_3_SENTINEL: StringName = &"pull_3_ice_mage"

const RARITY_NAMES: Array = ["Common", "Rare", "Epic", "Legendary", "Mythic"]
const RARITY_COLORS: Array = [
	Color(0.75, 0.75, 0.75),  ## common - grey
	Color(0.35, 0.65, 1.0),   ## rare - blue
	Color(0.75, 0.4, 1.0),    ## epic - purple
	Color(1.0, 0.75, 0.25),   ## legendary - gold
	Color(1.0, 0.3, 0.3),     ## mythic - red
]

var _ui_layer: CanvasLayer = null
var _reveal: ColorRect = null
var _reveal_title: Label = null
var _reveal_name: Label = null
var _reveal_meta: Label = null
var _reveal_delta: Label = null

func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		return
	_build_reveal_ui()

## ---------- Pull service ----------

func eligible_weapons() -> Array:
	var out: Array = []
	var fielded: Dictionary = GameState.fielded_classes()
	for id in GameState.weapon_ids:
		var w = GameState.weapons_by_id[id]
		if fielded.has(w.cls):
			out.append(w)
	return out

func can_pull() -> bool:
	return AccountState.ember >= AccountState.PULL_COST_EMBER and not eligible_weapons().is_empty()

func pull() -> Dictionary:
	var eligible: Array = eligible_weapons()
	if eligible.is_empty():
		return {}
	if not AccountState.spend_ember(AccountState.PULL_COST_EMBER):
		return {}
	## Scripted picks override RNG when scheduled (pull #1 + pull #3 only) AND a
	## matching eligible weapon exists. Falls through to RNG otherwise.
	var catalog_pick = _try_scripted_pick(eligible)
	if catalog_pick == null:
		catalog_pick = _weighted_pick(eligible)
	var hero_id: StringName = _first_hero_of_class(catalog_pick.cls)
	var hero = GameState.get_hero(hero_id)
	var old_atk: int = (hero.data.atk_base + hero.eff_atk()) if hero != null else 0

	## Dupe? A weapon you already own mints rarity-scaled gems — never a 2nd bench
	## copy (the Wittle dupe-sink). Star-up is a separate gem-spend (later task).
	## Otherwise acquire + auto-equip if the class hero is empty-handed (never
	## overwrite a chosen loadout).
	var existing = _owned_with_id(catalog_pick.id)
	var dupe: bool = existing != null
	var owned
	var auto_equipped: bool = false
	var star_up: bool = false
	var dupe_gems: int = 0
	var dupe_action: String = "none"
	if dupe:
		owned = existing
		dupe_gems = DUPE_GEMS[clampi(catalog_pick.rarity_idx, 0, DUPE_GEMS.size() - 1)]
		AccountState.add_gems(dupe_gems)
		dupe_action = "gems"
	else:
		owned = AccountState.acquire_weapon(catalog_pick)
		if AccountState.get_equipped(hero_id) == null:
			auto_equipped = AccountState.equip(hero_id, AccountState.owned_weapons.size() - 1)
			if auto_equipped and hero != null:
				GameState.equip_weapon_data(hero_id, owned)

	## Shard consolation: 2 shards on a low-rarity pull (common/rare), 0 on epic+.
	## (Spoils for a "meh" pull; high-rarity pulls are their own reward.)
	var drops: Array = []
	if catalog_pick.rarity_idx <= 1:
		drops = [_mint_shard(catalog_pick.rune), _mint_shard(catalog_pick.rune)]
		AccountState.add_shards(drops)

	var result: Dictionary = {
		"weapon": owned,
		"hero_id": hero_id,
		"auto_equipped": auto_equipped,
		"dupe": dupe,
		"dupe_action": dupe_action,
		"star_up": star_up,
		"dupe_gems": dupe_gems,
		"shards": drops,
		"old_atk": old_atk,
		"new_atk": (hero.data.atk_base + hero.eff_atk()) if hero != null else 0,
	}
	if dupe:
		GameState.append_combat_log("[color=66ddff]⚒ Forge Wheel: %s DUPE → +%d gems[/color]"
			% [owned.name, dupe_gems])
	elif auto_equipped and hero != null:
		GameState.append_combat_log("[color=66ddff]⚒ Forge Wheel: %s — %s! ATK %d → %d  (+%d shards)[/color]"
			% [hero.data.name, owned.name, result.old_atk, result.new_atk, drops.size()])
	else:
		GameState.append_combat_log("[color=66ddff]⚒ Forge Wheel: %s → Armory  (+%d shards)[/color]" % [owned.name, drops.size()])
	AccountState.autosave()
	AccountState.pull_count += 1
	pull_completed.emit(result)
	return result

func _first_hero_of_class(cls: StringName) -> StringName:
	for id in GameState.squad_order:
		var h = GameState.get_hero(id)
		if h != null and h.data.cls == cls:
			return id
	return &""

## The owned instance matching this id (dupe detection), or null. Dupes never add
## a 2nd copy, so there is at most one owned instance per id.
func _owned_with_id(weapon_id: StringName):
	for w in AccountState.owned_weapons:
		if w.id == weapon_id:
			return w
	return null

## Rarity-weighted catalog pick (rarer weapon = rarer pull). Uniform fallback if
## the weights sum to zero.
func _weighted_pick(eligible: Array):
	var total: float = 0.0
	for w in eligible:
		total += _drop_weight(w)
	if total <= 0.0:
		return eligible[randi() % eligible.size()]
	var roll: float = randf() * total
	for w in eligible:
		roll -= _drop_weight(w)
		if roll <= 0.0:
			return w
	return eligible[eligible.size() - 1]

func _drop_weight(w) -> float:
	return WEAPON_DROP_WEIGHT[clampi(w.rarity_idx, 0, WEAPON_DROP_WEIGHT.size() - 1)]

## Returns a scripted catalog pick when scheduled (pull #1 = Fire-warrior, pull #3 =
## Ice-mage). Reads AccountState.pull_count + 1 to determine the upcoming pull #.
## Records the sentinel on AccountState.scripted_pulls_seen ONLY when a pick
## succeeds, so a defer-and-retry path (no eligible match yet) doesn't burn the
## schedule. Returns null when no script applies (so caller falls through to RNG).
func _try_scripted_pick(eligible: Array):
	var n: int = AccountState.pull_count + 1   ## the pull about to be resolved
	if n == 1 and not (SCRIPT_PULL_1_SENTINEL in AccountState.scripted_pulls_seen):
		var pick = _pick_first_match(eligible, &"fire", &"warrior")
		if pick != null:
			var seen: Array = AccountState.scripted_pulls_seen
			seen.append(SCRIPT_PULL_1_SENTINEL)
			AccountState.scripted_pulls_seen = seen
			return pick
		return null   ## defer the script — try again next eligible pull (sentinel un-burnt)
	elif n == 3 and not (SCRIPT_PULL_3_SENTINEL in AccountState.scripted_pulls_seen):
		var pick = _pick_first_match(eligible, &"ice", &"mage")
		if pick != null:
			var seen: Array = AccountState.scripted_pulls_seen
			seen.append(SCRIPT_PULL_3_SENTINEL)
			AccountState.scripted_pulls_seen = seen
			return pick
		return null
	return null

## Linear search for the first eligible weapon matching (rune, cls). Used by scripted picks.
func _pick_first_match(eligible: Array, rune: StringName, cls: StringName):
	for w in eligible:
		if w.rune == rune and w.cls == cls:
			return w
	return null

## Mint a runtime Forge Shard: rarity rolled on SHARD_RARITY_ODDS, element copied
## from the pulled weapon (inert in v1).
func _mint_shard(element: StringName):
	var s = ShardDataT.new()
	s.rarity_idx = _roll_shard_rarity()
	s.element = element
	return s

func _roll_shard_rarity() -> int:
	var roll: int = randi() % 100
	for i in range(SHARD_RARITY_ODDS.size()):
		if roll < int(SHARD_RARITY_ODDS[i]):
			return i
	return SHARD_RARITY_ODDS.size() - 1

## ---------- Reveal overlay (visual sessions only; HomeScreen calls show_reveal) ----------

func _build_reveal_ui() -> void:
	_ui_layer = CanvasLayer.new()
	_ui_layer.layer = 50
	add_child(_ui_layer)

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

## Public: HomeScreen (and later the spin cinematic) calls this after pull().
func show_reveal(result: Dictionary) -> void:
	if _reveal == null:
		return
	var w = result.weapon
	var rarity: int = clampi(w.rarity_idx, 0, RARITY_NAMES.size() - 1)
	var c: Color = RARITY_COLORS[rarity]
	var n_shards: int = (result.get("shards", []) as Array).size()
	if bool(result.get("dupe", false)):
		## Dupe -> star-up the OWNED weapon (never a 2nd copy). Make it read as a win.
		_reveal_title.text = "DUPE!"
		_reveal_title.modulate = Color(1.0, 0.85, 0.3)
		_reveal_name.text = w.name
		_reveal_name.modulate = c
		_reveal_meta.text = "%s · %s" % [String(w.cls).capitalize(), String(w.rune).capitalize()]
		_reveal_delta.text = "+%d gems   ·   +%d shards" % [int(result.get("dupe_gems", 0)), n_shards]
	else:
		_reveal_title.text = "%s WEAPON!" % String(RARITY_NAMES[rarity]).to_upper()
		_reveal_title.modulate = c
		_reveal_name.text = w.name
		_reveal_name.modulate = c
		_reveal_meta.text = "%s · %s · for %s" % [String(w.cls).capitalize(), String(w.rune).capitalize(),
			String(result.hero_id).capitalize()]
		if bool(result.get("auto_equipped", false)):
			_reveal_delta.text = "ATK %d → %d   ·   +%d shards" % [result.old_atk, result.new_atk, n_shards]
		else:
			_reveal_delta.text = "→ Armory   ·   +%d shards" % n_shards
	_reveal.visible = true
	## Rarity flash: overlay blinks in from the rarity color, settles to dark.
	_reveal.color = Color(c.r, c.g, c.b, 0.55)
	var tw := create_tween()
	tw.tween_property(_reveal, "color", Color(0, 0, 0, 0.85), 0.45)
