## AccountState — persistent, cross-run hero progression. Autoload singleton.
##
## Registered BEFORE GameState in project.godot so it is ready when GameState
## builds the roster. P0: holds per-hero { xp, owned }. Level is derived from
## xp via HeroProgress (never stored, so the curve can be retuned freely).
##
## The live game does not read this yet (wiring is the next plan); P0 only
## builds + tests the engine.
extends Node

const HeroProgressT = preload("res://scripts/core/hero_progress.gd")

## Overridable so tests can target a throwaway file. Real game uses the default.
var save_path: String = "user://account.json"

## String(hero_id) -> { "xp": int, "owned": bool }
var _heroes: Dictionary = {}

func _ready() -> void:
	load_account()
	## Bran is the free starter — owned by default on a fresh account.
	if not is_owned(&"bran"):
		set_owned(&"bran", true)

## Wipe in-memory progression (tests + new-account).
func reset() -> void:
	_heroes = {}

func _entry(hero_id) -> Dictionary:
	var key: String = String(hero_id)
	if not _heroes.has(key):
		_heroes[key] = {"xp": 0, "owned": false}
	return _heroes[key]

func get_xp(hero_id) -> int:
	return int(_entry(hero_id)["xp"])

func get_level(hero_id) -> int:
	return HeroProgressT.level_for_xp(get_xp(hero_id))

func stat_mult(hero_id) -> float:
	return HeroProgressT.stat_mult(get_level(hero_id))

func is_owned(hero_id) -> bool:
	return bool(_entry(hero_id)["owned"])

func set_owned(hero_id, owned: bool) -> void:
	_entry(hero_id)["owned"] = owned

## Adds XP (clamped non-negative) and returns the hero's new level.
func add_hero_xp(hero_id, amount: int) -> int:
	var e: Dictionary = _entry(hero_id)
	e["xp"] = int(e["xp"]) + maxi(0, amount)
	return HeroProgressT.level_for_xp(int(e["xp"]))

## Grants `per_hero` XP to each id in `squad_ids`.
func award_squad_xp(squad_ids: Array, per_hero: int) -> void:
	for hero_id in squad_ids:
		add_hero_xp(hero_id, per_hero)

func save_account() -> void:
	var f := FileAccess.open(save_path, FileAccess.WRITE)
	if f == null:
		push_warning("AccountState: could not open %s for write" % save_path)
		return
	f.store_string(JSON.stringify(_heroes))
	f.close()

func load_account() -> void:
	if not FileAccess.file_exists(save_path):
		_heroes = {}
		return
	var f := FileAccess.open(save_path, FileAccess.READ)
	if f == null:
		_heroes = {}
		return
	var txt: String = f.get_as_text()
	f.close()
	var parsed = JSON.parse_string(txt)
	if typeof(parsed) != TYPE_DICTIONARY:
		_heroes = {}
		return
	## JSON restores numbers as floats; normalize xp back to int.
	var out: Dictionary = {}
	for key in parsed.keys():
		var row = parsed[key]
		if typeof(row) == TYPE_DICTIONARY:
			out[String(key)] = {
				"xp": int(row.get("xp", 0)),
				"owned": bool(row.get("owned", false)),
			}
	_heroes = out
