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

## Account-level boolean flags (FTUE beats, etc.). Persisted with the save.
var _flags: Dictionary = {}

## v3 schema (Phase 4): sticky bit — set true the first time the FTUE world is
## completed, gates the FTUE replay path. Persisted as a top-level field rather
## than a flag so the slice's gating code can read it without a string key.
var ftue_complete: bool = false

func _ready() -> void:
	load_account()
	ensure_defaults()

## Free-starter ownership for a fresh (or wiped) account. Bran + Elara start
## owned; Vex is granted by the scripted pull beat (P0 slice, pull_01).
func ensure_defaults() -> void:
	if not is_owned(&"bran"):
		set_owned(&"bran", true)
	if not is_owned(&"elara"):
		set_owned(&"elara", true)

func get_flag(flag: StringName) -> bool:
	return bool(_flags.get(String(flag), false))

func set_flag(flag: StringName) -> void:
	_flags[String(flag)] = true

## Wipe in-memory progression (tests + new-account).
func reset() -> void:
	_heroes = {}
	_flags = {}
	ftue_complete = false

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
	f.store_string(JSON.stringify({
		"version": 3,
		"heroes": _heroes,
		"flags": _flags,
		"ftue_complete": ftue_complete,
	}))
	f.close()

func load_account() -> void:
	_heroes = {}
	_flags = {}
	ftue_complete = false
	if not FileAccess.file_exists(save_path):
		return
	var f := FileAccess.open(save_path, FileAccess.READ)
	if f == null:
		return
	var txt: String = f.get_as_text()
	f.close()
	var parsed = JSON.parse_string(txt)
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	## v3 schema: {"version": 3, "heroes": {...}, "flags": {...}, "ftue_complete": bool}.
	## v2 schema: {"heroes": {...}, "flags": {...}} — no version, no ftue_complete.
	## v1 legacy: flat heroes dict — no "heroes" key wrapper.
	var heroes_src: Dictionary = parsed.get("heroes", parsed) if parsed.has("heroes") else parsed
	if typeof(parsed.get("flags", null)) == TYPE_DICTIONARY:
		for k in parsed["flags"].keys():
			_flags[String(k)] = bool(parsed["flags"][k])
	ftue_complete = bool(parsed.get("ftue_complete", false))
	for key in heroes_src.keys():
		var row = heroes_src[key]
		if typeof(row) == TYPE_DICTIONARY and (row.has("xp") or row.has("owned")):
			_heroes[String(key)] = {
				"xp": int(row.get("xp", 0)),
				"owned": bool(row.get("owned", false)),
			}
