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
signal hero_unlocked(hero_id: StringName)
signal squad_wiped
signal enemies_spawned
signal enemy_hp_changed(enemy_idx: int)
signal enemy_status_changed(enemy_idx: int)

## Emitted by Merge after a successful level-up. UI listens to fire celebration
## VFX on the affected card (gold border flash + "✨ L<n>!" pop).
signal merge_completed(uid: int, new_level: int)

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
const TOTAL_WAVES: int = 15  ## Stage D — 15-wave stage with bosses at W5/W10/W15.

## Boss waves trigger the ReforgeRetryModal on wipe + telegraph banner pre-wave +
## boss-only spawn (1 enemy via id lookup). Keep in sync with boss tres ids.
const BOSS_WAVES: Array = [5, 10, 15]

## XP granted to every deployed hero per cleared wave (spec §9.4 starting value).
const XP_PER_WAVE: int = 100

var wave: int = 1
var gold: int = STARTING_GOLD

## ---------- Roster ----------
##
## Phase 2 multi-hero. Bran starts unlocked; Elara unlocks on wave 2 clear,
## Vex on wave 4 clear. All three share the global shop + inventory + gold.
##
## `hero` is a back-compat shim that returns the first squad member (Bran).
## Removed in a follow-up commit once all callsites migrate to get_hero(id).

var heroes: Dictionary = {}         ## StringName -> HeroState
var squad_order: Array = []         ## ordered list of StringName ids (unlock order = display order)
var unlocked_classes: Dictionary = {}  ## StringName cls -> true (shop class filter)

## Back-compat shim. Reads first squad member (Bran in ultra-MVP). Writable
## for legacy callsites in tests that re-assign GameState.hero = HeroStateT.new(...).
var hero = null

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
func new_session(squad: Array = [&"bran"]) -> void:
	wave = 1
	gold = STARTING_GOLD
	shop_parts = []
	inventory = []
	enemies = []
	discovered_recipes = {}
	pending_discoveries = []
	combat_log = []
	_next_uid = 1

	heroes = {}
	squad_order = []
	unlocked_classes = {}
	hero = null

	## Deploy exactly the selected squad (Home screen passes the picked ids).
	## Default keeps legacy single-Bran behavior for tests/dev scenes.
	for hero_id in squad:
		unlock_hero(hero_id)

	emit_signal("gold_changed", gold)
	emit_signal("wave_changed", wave)
	emit_signal("inventory_changed")
	_emit_codex_badge()

## ---------- Roster helpers ----------

func get_hero(hero_id: StringName):
	return heroes.get(hero_id)

func all_heroes() -> Array:
	var out: Array = []
	for id in squad_order:
		var h = heroes.get(id)
		if h != null:
			out.append(h)
	return out

func active_heroes() -> Array:
	var out: Array = []
	for id in squad_order:
		var h = heroes.get(id)
		if h != null and not h.is_dead:
			out.append(h)
	return out

func any_alive() -> bool:
	for id in squad_order:
		var h = heroes.get(id)
		if h != null and not h.is_dead:
			return true
	return false

## Stage D — Reforge & Retry path. On wipe at a boss wave (5/10/15), the
## ReforgeRetryModal calls this to resurrect every squad member at full HP
## and clear per-fight tracking. Gold, inventory, recipe codex, and current
## wave are NOT reset — only the heroes are restored so the player can
## re-equip and re-engage the same boss fight.
func revive_squad_for_retry() -> void:
	for h in all_heroes():
		h.is_dead = false
		h.hp = h.max_hp
		h.ult_used = false
		h.burn_stack = 0
		h.last_target_name = &""
		emit_signal("hero_hp_changed", h.data.id)
		emit_signal("hero_ult_changed", h.data.id)

## Persistent progression: every deployed hero earns XP per cleared wave.
## Saves immediately so progress survives app close mid-stage.
func award_wave_xp() -> void:
	AccountState.award_squad_xp(squad_order, XP_PER_WAVE)
	AccountState.save_account()

## Instantiates a HeroState from the catalog, appends to squad_order, marks the
## hero's class as unlocked (widens shop pool), and emits hero_unlocked.
##
## First-unlocked hero also populates the `hero` back-compat shim so legacy
## callsites keep working until they migrate to get_hero(id).
func unlock_hero(hero_id: StringName) -> void:
	if heroes.has(hero_id):
		return
	var data = heroes_by_id.get(hero_id)
	if data == null:
		push_error("GameState.unlock_hero: missing HeroData for %s" % hero_id)
		return
	var hs = HeroStateT.new(data, AccountState.stat_mult(hero_id))
	heroes[hero_id] = hs
	squad_order.append(hero_id)
	unlocked_classes[data.cls] = true
	if hero == null:
		hero = hs
	emit_signal("hero_unlocked", hero_id)
	emit_signal("weapon_changed", hero_id)
	emit_signal("hero_hp_changed", hero_id)
	emit_signal("hero_ult_changed", hero_id)

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
