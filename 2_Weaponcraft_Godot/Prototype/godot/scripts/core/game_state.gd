## GameState — autoload singleton holding all cross-cutting per-run state.
##
## UI panels read from this; combat / shop / merge write to this.
## Nothing else holds state — keeps boundary between modules clean.
##
## Lifecycle:
##   - _ready() loads PartData/HeroData/EnemyData/RecipeData catalogs from disk
##   - new_session() resets per-run state (called by Main on start + restart)
##
## Signals are how UI panels stay in sync without polling. Emit on every
## mutation; UI listens and refreshes.
extends Node

## Autoload bootstrap parses BEFORE the project's global class_name cache is
## populated on a cold first run. Preload data scripts here to get reliable
## type refs without depending on that cache.
const PartDataT     = preload("res://scripts/data/part_data.gd")
const HeroDataT     = preload("res://scripts/data/hero_data.gd")
const EnemyDataT    = preload("res://scripts/data/enemy_data.gd")
const RecipeDataT   = preload("res://scripts/data/recipe_data.gd")
const InventoryItemT = preload("res://scripts/data/inventory_item.gd")
const WeaponT       = preload("res://scripts/data/weapon.gd")
const HeroStateT    = preload("res://scripts/data/hero_state.gd")

## ---------- Signals ----------

signal gold_changed(new_gold: int)
signal wave_changed(new_wave: int)
signal shop_changed                       ## shop_parts mutated
signal inventory_changed                  ## inventory mutated
signal weapon_changed(hero_id: StringName) ## any of head/hilt/rune mutated
signal hero_hp_changed(hero_id: StringName)
signal hero_ult_changed(hero_id: StringName)
signal recipe_discovered(recipe_id: StringName)
signal codex_badge_changed(discovered: int, total: int)
signal combat_log_appended(line: String)
signal wave_cleared(wave: int)
signal stage_cleared
signal hero_died(hero_id: StringName)
signal enemies_spawned
signal enemy_hp_changed(enemy_idx: int)
signal enemy_status_changed(enemy_idx: int)

## ---------- Catalogs (loaded once from disk in _ready) ----------

var parts_by_id: Dictionary = {}      ## StringName -> PartData
var heroes_by_id: Dictionary = {}     ## StringName -> HeroData
var enemies_by_id: Dictionary = {}    ## StringName -> EnemyData
var recipes_by_id: Dictionary = {}    ## StringName -> RecipeData

## Ordered ids for stable iteration / shop pool. Untyped Array — Dictionary.keys()
## returns Array, not Array[StringName].
var part_ids: Array = []
var enemy_ids: Array = []
var recipe_ids: Array = []

## ---------- Per-run state ----------

const STARTING_GOLD: int = 20
const TOTAL_WAVES: int = 3  ## ultra-MVP: 3 normal, no boss

var wave: int = 1
var gold: int = STARTING_GOLD

var hero = null   ## HeroState — ultra-MVP: only one hero (Bran). Untyped here to dodge cold-start class registry.

var shop_parts: Array = []        ## Array[InventoryItem snapshot for shop slot]
                                  ## shop items get unique uids only when bought.
var inventory: Array = []         ## Array[InventoryItem] — unequipped owned parts
var _next_uid: int = 1

var discovered_recipes: Dictionary = {}   ## Set-as-Dict: StringName -> true
var pending_discoveries: Array = []       ## queue of StringName

var combat_log: Array = []

## Runtime enemy state during a wave. Each element is a Dictionary:
##   { id: StringName, name: String (unique per spawn, for Inferno target tracking),
##     hp: int, max_hp: int, weak: StringName, resist: StringName,
##     sprite: Texture2D, frozen: bool, debuffed: bool, debuff_dur: int,
##     debuff_mult: float }
##
## Cleared between waves by Combat._spawn_enemies().
var enemies: Array = []

## ---------- Lifecycle ----------

func _ready() -> void:
	_load_catalogs()
	new_session()

func _load_catalogs() -> void:
	parts_by_id = _load_dir("res://data/parts/", "PartData")
	heroes_by_id = _load_dir("res://data/heroes/", "HeroData")
	enemies_by_id = _load_dir("res://data/enemies/", "EnemyData")
	recipes_by_id = _load_dir("res://data/recipes/", "RecipeData")

	part_ids = parts_by_id.keys()
	enemy_ids = enemies_by_id.keys()
	recipe_ids = recipes_by_id.keys()

func _load_dir(dir_path: String, _expect_class: String) -> Dictionary:
	var out: Dictionary = {}
	var d := DirAccess.open(dir_path)
	if d == null:
		push_warning("GameState: catalog dir missing %s" % dir_path)
		return out
	d.list_dir_begin()
	var fname := d.get_next()
	while fname != "":
		if not d.current_is_dir() and fname.ends_with(".tres"):
			var res: Resource = load(dir_path + fname)
			if res != null and res.get("id") != null and res.id != &"":
				out[res.id] = res
			else:
				push_warning("GameState: skipped %s (missing .id)" % fname)
		fname = d.get_next()
	d.list_dir_end()
	return out

## Called by Main at session start AND on restart-after-wipe / restart-after-clear.
func new_session() -> void:
	wave = 1
	gold = STARTING_GOLD
	shop_parts = []
	inventory = []
	enemies = []
	discovered_recipes = {}
	pending_discoveries = []
	combat_log = []
	_next_uid = 1

	## Bran is the only hero in ultra-MVP. Assumes data/heroes/bran.tres has id="bran".
	var bran_data = heroes_by_id.get(&"bran")
	if bran_data == null:
		push_error("GameState: bran HeroData missing — check data/heroes/bran.tres")
		return
	hero = HeroStateT.new(bran_data)

	emit_signal("gold_changed", gold)
	emit_signal("wave_changed", wave)
	emit_signal("inventory_changed")
	emit_signal("weapon_changed", &"bran")
	emit_signal("hero_hp_changed", &"bran")
	emit_signal("hero_ult_changed", &"bran")
	_emit_codex_badge()

## ---------- Catalog lookups ----------

## Returns PartData or null. Untyped to avoid cold-start class registry race.
func get_part_def(part_id: StringName):
	return parts_by_id.get(part_id)

## Returns RecipeData or null.
func get_recipe_def(recipe_id: StringName):
	return recipes_by_id.get(recipe_id)

## Returns EnemyData or null.
func get_enemy_def(enemy_id: StringName):
	return enemies_by_id.get(enemy_id)

func next_uid() -> int:
	var u: int = _next_uid
	_next_uid += 1
	return u

## ---------- Mutators (called from Shop / Merge / Combat) ----------

func spend_gold(amount: int) -> bool:
	if gold < amount:
		return false
	gold -= amount
	emit_signal("gold_changed", gold)
	return true

func add_gold(amount: int) -> void:
	gold += amount
	emit_signal("gold_changed", gold)

func set_wave(w: int) -> void:
	wave = w
	emit_signal("wave_changed", wave)

func append_combat_log(line: String) -> void:
	combat_log.append(line)
	if combat_log.size() > 80:
		combat_log.pop_front()
	emit_signal("combat_log_appended", line)

func mark_discovered(recipe_id: StringName) -> void:
	if discovered_recipes.has(recipe_id):
		return
	discovered_recipes[recipe_id] = true
	pending_discoveries.append(recipe_id)
	emit_signal("recipe_discovered", recipe_id)
	_emit_codex_badge()

func _emit_codex_badge() -> void:
	emit_signal("codex_badge_changed", discovered_recipes.size(), recipe_ids.size())
