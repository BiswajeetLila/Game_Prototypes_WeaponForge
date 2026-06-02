## AccountState — ACCOUNT-scoped durable state (P0 meta-persistence + pull economy).
##
## Contract (migration plan, entry contract #1):
##   - This autoload is the account/meta layer; GameState stays run-scoped.
##     GameState.new_session() never touches anything here.
##   - Owned weapons are runtime duplicate(true) instances of catalog WeaponData —
##     the catalog .tres is never handed out (its mutable star/rarity/forge fields
##     would otherwise be shared by every future pull of the same weapon).
##   - Save = explicit JSON with a version field at user://account.json. Loads are
##     validate-then-commit: any corrupt/mismatched payload leaves current state
##     untouched and returns false (caller keeps the fresh account).
##   - Weapon serialization is self-contained (full field snapshot) so loading
##     never depends on the catalog still containing the weapon.
##
## Economy starting values (Numbers Policy — test plan in the migration plan doc):
##   STARTING_GEMS 600 = 2 pulls on day one; GEMS_PER_WAVE 15 + GEMS_BOSS_BONUS 25
##   = 300 per full 15-wave run = 1 earned pull/run; PULL_COST 300 per spec §11
##   (Wittle-derived banner pricing). If playtesters can't afford >=2 pulls per
##   session, raise GEMS_PER_WAVE first.
extends Node

const WeaponDataT = preload("res://scripts/data/weapon_data.gd")

signal gems_changed(new_gems: int)
signal owned_weapons_changed

## v2: invalidates saves written by the pre-game-frame loop (owner playtest got
## stranded at 45 gems from a deprecated-flow save). Old versions load as fresh.
const SAVE_VERSION: int = 2
const SAVE_PATH: String = "user://account.json"
const STARTING_GEMS: int = 600
## Tuned after first playtest: full 15-wave run = 25*15 + 75*3 = 600 = 2 pulls.
const GEMS_PER_WAVE: int = 25
const GEMS_BOSS_BONUS: int = 75
const PULL_COST: int = 300

var gems: int = STARTING_GEMS
var owned_weapons: Array = []      ## Array[WeaponData] — runtime instances, never catalog refs
var equipped: Dictionary = {}      ## StringName hero_id -> int index into owned_weapons

## All WeaponData fields that round-trip through a save. Self-contained snapshot.
const _WEAPON_FIELDS: Array = [
	"id", "name", "cls", "ability", "rune", "recipe",
	"base_atk", "base_hp", "base_crit", "base_ult_rate",
	"star_tier", "rarity_idx", "forge_progress", "forge_target_idx",
]
const _STRINGNAME_FIELDS: Array = ["id", "cls", "rune", "recipe"]
const _FLOAT_FIELDS: Array = ["forge_progress"]
const _STRING_FIELDS: Array = ["name", "ability"]

func _ready() -> void:
	## Account loads once at boot; absent/corrupt file -> fresh account (defaults).
	load_from_disk(SAVE_PATH)
	connect_run_signals()

func connect_run_signals() -> void:
	if not GameState.wave_cleared.is_connected(_on_wave_cleared):
		GameState.wave_cleared.connect(_on_wave_cleared)

## ---------- Economy ----------

func add_gems(amount: int) -> void:
	gems += amount
	gems_changed.emit(gems)

func spend_gems(amount: int) -> bool:
	if gems < amount:
		return false
	gems -= amount
	gems_changed.emit(gems)
	return true

func _on_wave_cleared(wave: int) -> void:
	var amount: int = GEMS_PER_WAVE
	if wave in GameState.BOSS_WAVES:
		amount += GEMS_BOSS_BONUS
	add_gems(amount)
	autosave()

## Playtest hygiene: wipe back to first-boot state (fresh gems, no weapons) and
## persist it. Home exposes this as a small debug button.
func reset_account() -> void:
	gems = STARTING_GEMS
	owned_weapons = []
	equipped = {}
	gems_changed.emit(gems)
	owned_weapons_changed.emit()
	autosave()

## Persist after meaningful account mutations (pull, wave earn). Headless-gated so
## test suites never write user://account.json — the save/load round-trip itself
## is covered by explicit-path tests.
func autosave() -> void:
	if DisplayServer.get_name() == "headless":
		return
	save_to_disk(SAVE_PATH)

## ---------- Owned weapons ----------

## Pull acquisition: deep-duplicate the catalog weapon into an owned runtime
## instance. Returns the instance (caller equips / shows reveal), or null.
func acquire_weapon(catalog_weapon) -> Resource:
	if catalog_weapon == null:
		return null
	var inst: Resource = catalog_weapon.duplicate(true)
	owned_weapons.append(inst)
	owned_weapons_changed.emit()
	return inst

func equip(hero_id: StringName, owned_idx: int) -> bool:
	if owned_idx < 0 or owned_idx >= owned_weapons.size():
		return false
	equipped[hero_id] = owned_idx
	return true

## Returns the equipped WeaponData instance for a hero, or null.
func get_equipped(hero_id: StringName):
	var idx: int = int(equipped.get(hero_id, -1))
	if idx < 0 or idx >= owned_weapons.size():
		return null
	return owned_weapons[idx]

## ---------- Serialization ----------

func to_save_dict() -> Dictionary:
	var ws: Array = []
	for w in owned_weapons:
		ws.append(_weapon_to_dict(w))
	var eq: Dictionary = {}
	for k in equipped:
		eq[String(k)] = equipped[k]
	return {"version": SAVE_VERSION, "gems": gems, "weapons": ws, "equipped": eq}

## Validate-then-commit: returns false on ANY structural problem without touching
## current state, so a corrupt save can never half-apply.
func load_from_dict(d: Dictionary) -> bool:
	if int(d.get("version", -1)) != SAVE_VERSION:
		return false
	if not (d.has("gems") and d.has("weapons") and d.has("equipped")):
		return false
	if typeof(d["weapons"]) != TYPE_ARRAY or typeof(d["equipped"]) != TYPE_DICTIONARY:
		return false
	var new_weapons: Array = []
	for wd in d["weapons"]:
		if typeof(wd) != TYPE_DICTIONARY:
			return false
		var w = _weapon_from_dict(wd)
		if w == null:
			return false
		new_weapons.append(w)
	var new_equipped: Dictionary = {}
	for k in d["equipped"]:
		var idx: int = int(d["equipped"][k])
		if idx < 0 or idx >= new_weapons.size():
			return false
		new_equipped[StringName(k)] = idx
	gems = int(d["gems"])
	owned_weapons = new_weapons
	equipped = new_equipped
	gems_changed.emit(gems)
	owned_weapons_changed.emit()
	return true

func save_to_disk(path: String = SAVE_PATH) -> bool:
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_warning("AccountState: cannot write save at %s" % path)
		return false
	f.store_string(JSON.stringify(to_save_dict(), "\t"))
	f.close()
	return true

func load_from_disk(path: String = SAVE_PATH) -> bool:
	if not FileAccess.file_exists(path):
		return false
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return false
	var parsed = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("AccountState: corrupt save at %s — keeping fresh account" % path)
		return false
	var ok: bool = load_from_dict(parsed)
	if not ok:
		push_warning("AccountState: invalid save at %s — keeping fresh account" % path)
	return ok

func _weapon_to_dict(w) -> Dictionary:
	var d: Dictionary = {}
	for f in _WEAPON_FIELDS:
		var v = w.get(f)
		d[f] = String(v) if v is StringName else v
	return d

## Returns a WeaponData or null if any field is missing (treated as corrupt).
func _weapon_from_dict(d: Dictionary):
	for f in _WEAPON_FIELDS:
		if not d.has(f):
			return null
	var w = WeaponDataT.new()
	for f in _WEAPON_FIELDS:
		if f in _STRINGNAME_FIELDS:
			w.set(f, StringName(String(d[f])))
		elif f in _STRING_FIELDS:
			w.set(f, String(d[f]))
		elif f in _FLOAT_FIELDS:
			w.set(f, float(d[f]))
		else:
			w.set(f, int(d[f]))
	return w
