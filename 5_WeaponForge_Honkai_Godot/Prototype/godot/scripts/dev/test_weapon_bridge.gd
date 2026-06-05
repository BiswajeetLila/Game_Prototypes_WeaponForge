## Test harness for the weapon_data bridge (#1 of the playable-slice plan).
##
## Contracts under test (migration plan, entry contracts #2 + #3):
##   - HeroState.weapon_data (null default -> ZERO behavior change; 144 suite green).
##   - REPLACEMENT semantics: when weapon_data is equipped it replaces the legacy
##     socket weapon's combat contribution (atk/crit/ult_rate/hp-bonus/tags) —
##     never added on top (additive double-stacking poisons playtest balance signal).
##   - HP rule on the weapon_data path: recompute max, CLAMP current, NEVER refill
##     (blocks the equip-swap free-heal exploit). The legacy socket path keeps its
##     deliberate historical +delta behavior (zero blast radius on the 144 suite).
##   - Debug toggle GameState.combat_stat_source: AUTO / LEGACY_ONLY / PULLED_ONLY /
##     ADDITIVE. PULLED_ONLY must also zero legacy recipe bonuses (recipes read
##     sockets and feed combat damage — FM-1 signal isolation).
##   - GameState.equip_weapon_data() emits weapon_data_changed (the existing
##     weapon_changed signal means SOCKETS mutated).
##
## Run headless:
##   Godot_v4.6.2-stable_mono_win64_console.exe --headless --path <godot dir> \
##     res://scenes/dev/TestWeaponBridge.tscn
extends Control

const WeaponDataT = preload("res://scripts/data/weapon_data.gd")
const HeroStateT = preload("res://scripts/data/hero_state.gd")
const InventoryItemT = preload("res://scripts/data/inventory_item.gd")

var _passed: int = 0
var _failed: int = 0
var _lines: Array = []
var _signal_count: int = 0
var _signal_hero: StringName = &""

func _ready() -> void:
	_log("=== weapon_data bridge (#1) tests ===")
	if not ("weapon_data" in HeroStateT.new(_bran_data())):
		_check("HeroState has weapon_data", false, "property missing (RED)")
	else:
		_test_null_weapon_data_means_legacy_behavior()
		_test_replacement_atk_crit_ult_tags()
		_test_hp_equip_no_refill()
		_test_hp_equip_while_damaged_no_heal()
		_test_hp_swap_exploit_blocked()
		_test_toggle_legacy_only()
		_test_toggle_additive()
		_test_toggle_pulled_only_zeroes_recipes()
		_test_equip_signal()
		_test_run_mods_default_zero()
		_test_run_mods_atk_flat_and_pct()
		_test_run_mods_crit_ult()
		_test_run_mods_hp_raises_max_keeps_current()
		_test_run_mods_reset_on_new_session()
		_test_restore_full_heals_to_max()
		_test_restore_squad_full_notifies()
	if "combat_stat_source" in GameState:
		GameState.combat_stat_source = GameState.STAT_SOURCE_AUTO
	_summary()
	_render_to_ui()
	if DisplayServer.get_name() == "headless":
		get_tree().quit(_failed)

## ---------- Fixtures ----------

func _bran_data():
	return GameState.heroes_by_id.get(&"bran")

func _fresh_hero():
	GameState.new_session()
	return GameState.get_hero(&"bran")

func _pulled(atk: int = 30, hp: int = 50, crit: int = 7, ult: int = 9, rune: StringName = &"fire"):
	var w = WeaponDataT.new()
	w.id = &"w_test_blade"
	w.base_atk = atk
	w.base_hp = hp
	w.base_crit = crit
	w.base_ult_rate = ult
	w.rune = rune
	return w

## Equips a real catalog part into a legacy socket (mirrors test_combat's helper).
func _equip_socket_part(hero, slot: StringName, part_id: StringName) -> void:
	hero.weapon.set_slot(slot, InventoryItemT.new(GameState.next_uid(), part_id, 1))
	hero.refresh_max_hp()

## ---------- Cases ----------

func _test_null_weapon_data_means_legacy_behavior() -> void:
	## The bridge default: no pulled weapon -> identical legacy reads.
	var h = _fresh_hero()
	_check("weapon_data defaults null", h.weapon_data == null, "not null")
	_equip_socket_part(h, &"head", &"h_iron_edge")
	var part = GameState.get_part_def(&"h_iron_edge")
	_check("eff_atk == legacy socket atk when weapon_data null", h.eff_atk() == part.atk,
		"eff=%d part=%d" % [h.eff_atk(), part.atk])
	_check("eff_tags == legacy tags when weapon_data null", h.eff_tags() == h.weapon.get_all_tags(),
		"eff=%s legacy=%s" % [str(h.eff_tags()), str(h.weapon.get_all_tags())])

func _test_replacement_atk_crit_ult_tags() -> void:
	## REPLACEMENT, not additive: socket atk must stop counting once equipped.
	var h = _fresh_hero()
	_equip_socket_part(h, &"head", &"h_iron_edge")     ## legacy contributes atk
	GameState.equip_weapon_data(&"bran", _pulled())
	_check("eff_atk replaced by weapon_data (30, not 30+socket)", h.eff_atk() == 30,
		"eff=%d" % h.eff_atk())
	_check("eff_crit from weapon_data", h.eff_crit() == 7, "eff=%d" % h.eff_crit())
	_check("eff_ult_rate from weapon_data", h.eff_ult_rate() == 9, "eff=%d" % h.eff_ult_rate())
	var tags: Array = h.eff_tags()
	_check("eff_tags from weapon_data rune", &"fire" in tags and tags == h.weapon_data.get_all_tags(),
		"tags=%s" % str(tags))

func _test_hp_equip_no_refill() -> void:
	## Contract #2: equipping a +HP pulled weapon raises MAX but never current.
	var h = _fresh_hero()
	var base_max: int = h.max_hp
	GameState.equip_weapon_data(&"bran", _pulled(30, 50))
	_check("equip raises max_hp by weapon hp", h.max_hp == base_max + 50,
		"max=%d want %d" % [h.max_hp, base_max + 50])
	_check("equip does NOT refill current hp", h.hp == base_max,
		"hp=%d want %d (unchanged)" % [h.hp, base_max])

func _test_restore_full_heals_to_max() -> void:
	## Run-start full heal (#3): equipping a +HP weapon clamps current (mid-run rule),
	## so a hero would enter a stage partially full. restore_full() is the run-start
	## exception — full HP incl. the weapon bonus, death cleared.
	var h = _fresh_hero()
	if not h.has_method(&"restore_full"):
		_check("HeroState has restore_full()", false, "method missing (RED)")
		return
	GameState.equip_weapon_data(&"bran", _pulled(30, 50))   ## max += 50, current NOT refilled
	_check("pre-restore: hero is below max (clamped)", h.hp < h.max_hp, "hp=%d max=%d" % [h.hp, h.max_hp])
	h.is_dead = true
	h.restore_full()
	_check("restore_full sets hp to max", h.hp == h.max_hp, "hp=%d max=%d" % [h.hp, h.max_hp])
	_check("restore_full clears death", h.is_dead == false, "still dead")

func _test_hp_equip_while_damaged_no_heal() -> void:
	var h = _fresh_hero()
	h.hp = 40
	GameState.equip_weapon_data(&"bran", _pulled(30, 50))
	_check("damaged hero stays damaged after equip (40)", h.hp == 40, "hp=%d" % h.hp)

func _test_hp_swap_exploit_blocked() -> void:
	## Codex abuse case: unequip/re-equip must never heal.
	var h = _fresh_hero()
	GameState.equip_weapon_data(&"bran", _pulled(30, 50))
	h.hp = 25
	GameState.equip_weapon_data(&"bran", null)            ## unequip
	GameState.equip_weapon_data(&"bran", _pulled(30, 50)) ## re-equip
	_check("equip-swap cannot heal (hp stays 25)", h.hp == 25, "hp=%d" % h.hp)
	var h2 = _fresh_hero()
	GameState.equip_weapon_data(&"bran", _pulled(30, 80))
	h2.hp = 30
	GameState.equip_weapon_data(&"bran", _pulled(30, 10)) ## swap to small-hp weapon
	_check("swap down clamps hp to new max if above", h2.hp == mini(30, h2.max_hp),
		"hp=%d max=%d" % [h2.hp, h2.max_hp])

func _test_toggle_legacy_only() -> void:
	var h = _fresh_hero()
	_equip_socket_part(h, &"head", &"h_iron_edge")
	GameState.equip_weapon_data(&"bran", _pulled())
	GameState.combat_stat_source = GameState.STAT_SOURCE_LEGACY_ONLY
	var part = GameState.get_part_def(&"h_iron_edge")
	_check("LEGACY_ONLY: eff_atk reads sockets despite equipped weapon_data",
		h.eff_atk() == part.atk, "eff=%d part=%d" % [h.eff_atk(), part.atk])
	GameState.combat_stat_source = GameState.STAT_SOURCE_AUTO

func _test_toggle_additive() -> void:
	var h = _fresh_hero()
	_equip_socket_part(h, &"head", &"h_iron_edge")
	GameState.equip_weapon_data(&"bran", _pulled())
	GameState.combat_stat_source = GameState.STAT_SOURCE_ADDITIVE
	var part = GameState.get_part_def(&"h_iron_edge")
	_check("ADDITIVE: eff_atk sums sockets + weapon_data (experimental mode)",
		h.eff_atk() == part.atk + 30, "eff=%d want %d" % [h.eff_atk(), part.atk + 30])
	GameState.combat_stat_source = GameState.STAT_SOURCE_AUTO

func _test_toggle_pulled_only_zeroes_recipes() -> void:
	## Contract #3: sockets feed combat through recipe bonuses too. PULLED_ONLY
	## must cut that path or FM-1 playtest signal is polluted.
	var h = _fresh_hero()
	_equip_socket_part(h, &"head", &"h_pyro_visor")    ## fire tag
	_equip_socket_part(h, &"rune", &"r_ice")           ## ice tag -> Steamburst active
	var bonuses_auto: Dictionary = Recipes.get_recipe_bonuses(h)
	_check("fixture sanity: sockets DO produce recipe bonuses in AUTO",
		bonuses_auto.size() > 0, "bonuses=%s" % str(bonuses_auto))
	GameState.combat_stat_source = GameState.STAT_SOURCE_PULLED_ONLY
	var bonuses_pulled: Dictionary = Recipes.get_recipe_bonuses(h)
	_check("PULLED_ONLY: legacy recipe bonuses zeroed", bonuses_pulled.is_empty(),
		"bonuses=%s" % str(bonuses_pulled))
	GameState.combat_stat_source = GameState.STAT_SOURCE_AUTO

func _test_equip_signal() -> void:
	var h = _fresh_hero()
	_signal_count = 0
	_signal_hero = &""
	GameState.weapon_data_changed.connect(_on_wd_changed)
	GameState.equip_weapon_data(&"bran", _pulled())
	GameState.weapon_data_changed.disconnect(_on_wd_changed)
	_check("equip emits weapon_data_changed once", _signal_count == 1, "count=%d" % _signal_count)
	_check("signal carries hero_id", _signal_hero == &"bran", "hero=%s" % _signal_hero)
	_check("hero actually holds the weapon", h.weapon_data != null and h.weapon_data.id == &"w_test_blade",
		"wd=%s" % (h.weapon_data.id if h.weapon_data != null else &"null"))

## #1 fix: run-start full heal must NOTIFY the battle bars. restore_full() is silent,
## so restore_squad_full() heals the squad AND emits hero_hp_changed per hero (else the
## bars keep the pre-heal value shown right after equip — the "starts at half HP" bug).
func _test_restore_squad_full_notifies() -> void:
	var h = _fresh_hero()
	if not GameState.has_method(&"restore_squad_full"):
		_check("GameState.restore_squad_full() exists", false, "method missing (RED)")
		return
	GameState.equip_weapon_data(&"bran", _pulled(30, 50))   ## max += 50, current clamped (partial)
	_signal_count = 0
	GameState.hero_hp_changed.connect(_on_wd_changed)
	GameState.restore_squad_full()
	GameState.hero_hp_changed.disconnect(_on_wd_changed)
	_check("restore_squad_full heals to max", h.hp == h.max_hp, "hp=%d max=%d" % [h.hp, h.max_hp])
	_check("restore_squad_full emits hero_hp_changed (bars refresh)", _signal_count >= 1,
		"count=%d" % _signal_count)

func _on_wd_changed(hero_id: StringName) -> void:
	_signal_count += 1
	_signal_hero = hero_id

## ---------- Run-scoped draft mods (R1 — Wittle-style per-run perk upgrades) ----------
## Forge Draft picks write run_mods on the hero; they stack ON TOP of the equipped
## weapon's contribution and reset every run (heroes are recreated by new_session).
## Formula: eff_atk = floor(weapon_atk * (1 + atk_pct)) + atk_flat; crit/ult add;
## hp_flat raises max under the clamp rule (no refill).

func _test_run_mods_default_zero() -> void:
	var h = _fresh_hero()
	if not ("run_mods" in h):
		_check("HeroState has run_mods", false, "property missing (RED)")
		return
	GameState.equip_weapon_data(&"bran", _pulled())     ## atk 30
	_check("zero mods leave eff_atk untouched", h.eff_atk() == 30, "eff=%d" % h.eff_atk())

func _test_run_mods_atk_flat_and_pct() -> void:
	var h = _fresh_hero()
	if not ("run_mods" in h):
		_check("HeroState has run_mods (atk)", false, "property missing (RED)")
		return
	GameState.equip_weapon_data(&"bran", _pulled())     ## atk 30
	h.apply_run_mod(&"atk_flat", 6)
	_check("atk_flat +6: eff_atk 36", h.eff_atk() == 36, "eff=%d" % h.eff_atk())
	h.apply_run_mod(&"atk_pct", 0.5)
	_check("atk_pct +50%: floor(30*1.5)+6 = 51", h.eff_atk() == 51, "eff=%d" % h.eff_atk())

func _test_run_mods_crit_ult() -> void:
	var h = _fresh_hero()
	if not ("run_mods" in h):
		_check("HeroState has run_mods (crit/ult)", false, "property missing (RED)")
		return
	GameState.equip_weapon_data(&"bran", _pulled())     ## crit 7, ult 9
	h.apply_run_mod(&"crit", 5)
	h.apply_run_mod(&"ult_rate", 4)
	_check("crit mod adds: 7+5", h.eff_crit() == 12, "crit=%d" % h.eff_crit())
	_check("ult mod adds: 9+4", h.eff_ult_rate() == 13, "ult=%d" % h.eff_ult_rate())

func _test_run_mods_hp_raises_max_keeps_current() -> void:
	var h = _fresh_hero()
	if not ("run_mods" in h):
		_check("HeroState has run_mods (hp)", false, "property missing (RED)")
		return
	GameState.equip_weapon_data(&"bran", _pulled(30, 50))   ## max = base+50
	var max_before: int = h.max_hp
	var hp_before: int = h.hp
	h.apply_run_mod(&"hp_flat", 20)
	_check("hp_flat raises max by 20", h.max_hp == max_before + 20,
		"max=%d want %d" % [h.max_hp, max_before + 20])
	_check("hp_flat never refills current", h.hp == hp_before, "hp=%d" % h.hp)

func _test_run_mods_reset_on_new_session() -> void:
	var h = _fresh_hero()
	if not ("run_mods" in h):
		_check("HeroState has run_mods (reset)", false, "property missing (RED)")
		return
	h.apply_run_mod(&"atk_flat", 99)
	var h2 = _fresh_hero()                              ## new_session recreates heroes
	_check("new run starts with zero mods", h2.eff_atk() == 0 and h2.run_mods[&"atk_flat"] == 0,
		"eff=%d flat=%d" % [h2.eff_atk(), h2.run_mods[&"atk_flat"]])

## ---------- Test helpers ----------

func _check(name: String, ok: bool, detail: String) -> void:
	if ok:
		_passed += 1
		_log("  PASS  " + name)
	else:
		_failed += 1
		_log("  FAIL  " + name + (("  [" + detail + "]") if detail != "" else ""))

func _summary() -> void:
	_log("=== %d passed / %d failed ===" % [_passed, _failed])

func _log(line: String) -> void:
	print(line)
	_lines.append(line)

func _render_to_ui() -> void:
	var label := Label.new()
	label.add_theme_font_size_override(&"font_size", 12)
	label.text = "\n".join(_lines)
	label.anchor_right = 1.0
	label.anchor_bottom = 1.0
	label.offset_left = 12
	label.offset_top = 12
	add_child(label)
