# P0 HOME + Squad-Select — Implementation Plan

> **For agentic workers:** execute task-by-task, strict TDD where marked. Env + run command identical to `2026-06-12-p0-hero-progression-foundation.md`. Visual target: `_art-build/screens/home_01.png` (layout/palette truth; numbers come from code).

**Goal:** Boot → HOME (roster grid + FORM SQUAD + BATTLE) → run with the selected squad → run exit returns to HOME. In-run W3/W6 hero unlocks removed. Plus a dev AUTOSHOT helper so rendered screenshots can be captured non-interactively.

**Design decisions (locked):** one Home screen (no separate squad scene) · fresh account owns Bran+Elara (Vex arrives via the scripted pull, next plan) · top bar shows real data only (total hero level), no fake gem/stamina badges · cards built in code, static layout in `Home.tscn`.

**Palette (from home_01 art):** bg `#2e2019` · wood panel `#6b4a32` · panel border `#4a3826` · parchment card `#e8d0a9` · card border `#8a5a3a` · green CTA `#57ab5a` (border `#2e6b33`) · gold `#ffd700` · dim lock `#3f3023` · text dark `#3a2a1c`.

---

### Task 1: AccountState fresh-account defaults (TDD)

**Files:** Modify `Prototype/godot/scripts/core/account_state.gd`, `Prototype/godot/scripts/dev/test_progression.gd`

- [ ] **Step 1 (RED):** Append to test_progression.gd (call `_test_account_defaults()` in `_ready` after `_test_award_wave_xp()`):

```gdscript
func _test_account_defaults() -> void:
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test.json"
	acc.reset()
	acc.ensure_defaults()
	_check("defaults: bran owned", acc.is_owned(&"bran") == true, "")
	_check("defaults: elara owned", acc.is_owned(&"elara") == true, "")
	_check("defaults: vex NOT owned", acc.is_owned(&"vex") == false, "")
	acc.reset()
```

Run TestProgression → FAIL (`ensure_defaults` nonexistent).

- [ ] **Step 2 (GREEN):** In `account_state.gd`, replace the `_ready` body's default block:

```gdscript
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
```

Run → PASS (37 progression checks).

- [ ] **Step 3:** Commit `feat(progression): fresh account owns Bran+Elara (ensure_defaults)`

### Task 2: `new_session(squad)` + remove in-run unlocks (TDD)

**Files:** Modify `Prototype/godot/scripts/core/game_state.gd`, `Prototype/godot/scripts/ui/main.gd`, `Prototype/godot/scripts/dev/test_combat.gd`, `test_progression.gd`

- [ ] **Step 1 (RED):** Append test:

```gdscript
func _test_new_session_squad_param() -> void:
	var gs = get_node("/root/GameState")
	gs.new_session([&"bran", &"elara"])
	_check("squad param: order is [bran, elara]",
		gs.squad_order == [&"bran", &"elara"], "got %s" % str(gs.squad_order))
	gs.new_session()
	_check("squad default: [bran] only", gs.squad_order == [&"bran"], "got %s" % str(gs.squad_order))
```

Run → FAIL (Too many arguments for `new_session`).

- [ ] **Step 2 (GREEN):** In `game_state.gd` change the `new_session` signature and the unlock tail:

```gdscript
func new_session(squad: Array = [&"bran"]) -> void:
```

and replace the line `unlock_hero(&"bran")` (with its comment) with:

```gdscript
	## Deploy exactly the selected squad (Home screen passes the picked ids).
	## Default keeps legacy single-Bran behavior for tests/dev scenes.
	for hero_id in squad:
		unlock_hero(hero_id)
```

- [ ] **Step 3:** In `main.gd`: delete the `ELARA_UNLOCK_WAVE`/`VEX_UNLOCK_WAVE` consts (+ their comment block), delete the whole `match wave:` unlock block inside `_on_wave_cleared`, and delete the now-unused `_show_unlock_card_delayed` function and its three `UNLOCK_*` consts.
- [ ] **Step 4:** In `test_combat.gd`: remove the two checks asserting `Main.ELARA_UNLOCK_WAVE`/`VEX_UNLOCK_WAVE` (delete the two test functions ~lines 720-731 AND their call sites in `_ready`); if the `MainT` preload becomes unused, remove it.
- [ ] **Step 5:** Full sweep — TestProgression 39, TestCombat 55, others unchanged, 0 failed anywhere.
- [ ] **Step 6:** Commit `feat(p0): squad-select session param; remove in-run W3/W6 unlocks`

### Task 3: AUTOSHOT dev helper (smoke-verified, no TDD — dev tooling)

**Files:** Modify `Prototype/godot/scripts/core/screenshot_helper.gd`

- [ ] **Step 1:** Read the file. Add to its `_ready()` (keep existing F12 behavior intact):

```gdscript
	## Non-interactive capture: WC_AUTOSHOT=<absolute png path> renders the
	## main scene ~1.5s, saves a screenshot, and quits. Dev/CI tooling only.
	var auto_path: String = OS.get_environment("WC_AUTOSHOT")
	if auto_path != "":
		var t := get_tree().create_timer(1.5)
		t.timeout.connect(func():
			var img := get_viewport().get_texture().get_image()
			img.save_png(auto_path)
			get_tree().quit(0)
		)
```

- [ ] **Step 2 (smoke):** PowerShell:

```powershell
$env:WC_AUTOSHOT = "C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\2_Weaponcraft_Godot\_art-build\renders\smoke_main.png"
& "C:\Godot_v4.6.2-stable_mono_win64\Godot_v4.6.2-stable_mono_win64_console.exe" --path "C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\2_Weaponcraft_Godot\Prototype\godot" res://scenes/Main.tscn
$env:WC_AUTOSHOT = ""
```

(create `_art-build\renders\` first; expect exit 0 + a PNG of the current forge screen.)

- [ ] **Step 3:** Commit `feat(dev): WC_AUTOSHOT non-interactive screenshot capture`

### Task 4: Home screen (TDD on selection logic)

**Files:** Create `Prototype/godot/scenes/Home.tscn`, `Prototype/godot/scripts/ui/home.gd`; Modify `Prototype/godot/project.godot` (main scene), `Prototype/godot/scripts/ui/main.gd` (exit → Home), `test_progression.gd`

- [ ] **Step 1 (RED):** Append test:

```gdscript
func _test_home_squad_selection() -> void:
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test.json"
	acc.reset()
	acc.ensure_defaults()
	var home = load("res://scenes/Home.tscn").instantiate()
	add_child(home)
	_check("home: starts empty squad", home.get_squad().is_empty(), "")
	home.toggle_hero(&"bran")
	home.toggle_hero(&"elara")
	_check("home: squad order [bran, elara]", home.get_squad() == [&"bran", &"elara"], "got %s" % str(home.get_squad()))
	home.toggle_hero(&"bran")
	_check("home: toggle removes", home.get_squad() == [&"elara"], "got %s" % str(home.get_squad()))
	home.toggle_hero(&"vex")
	_check("home: unowned hero rejected", home.get_squad() == [&"elara"], "got %s" % str(home.get_squad()))
	home.queue_free()
	acc.reset()
```

Run → FAIL (Home.tscn does not exist).

- [ ] **Step 2 (GREEN):** Create `Prototype/godot/scripts/ui/home.gd`:

```gdscript
## Home — persistent meta screen: roster grid + FORM SQUAD + BATTLE.
## Boot scene. BATTLE starts a run (Main.tscn) with the selected squad;
## Main's exit paths come back here. Visual target: _art-build/screens/home_01.png.
extends Control

const MAX_SQUAD: int = 3
const ROSTER_SLOTS: int = 6   ## grid cells; unowned/locked render as "?"
const HERO_ORDER: Array = [&"bran", &"elara", &"vex"]

const COL_BG := Color("2e2019")
const COL_PANEL := Color("6b4a32")
const COL_PANEL_BORDER := Color("4a3826")
const COL_CARD := Color("e8d0a9")
const COL_CARD_BORDER := Color("8a5a3a")
const COL_GREEN := Color("57ab5a")
const COL_GREEN_BORDER := Color("2e6b33")
const COL_GOLD := Color("ffd700")
const COL_LOCK := Color("3f3023")
const COL_TEXT_DARK := Color("3a2a1c")

var _selected: Array = []      ## StringName, tap order
var _roster_cards: Dictionary = {}  ## StringName -> Button

@onready var _roster_grid: GridContainer = %RosterGrid
@onready var _squad_row: HBoxContainer = %SquadRow
@onready var _battle_btn: Button = %BattleBtn
@onready var _total_lv: Label = %TotalLv

func _ready() -> void:
	_style_static()
	_build_roster()
	_refresh()
	_battle_btn.pressed.connect(_on_battle)

## ---------- selection model (headless-tested) ----------

func toggle_hero(hero_id: StringName) -> void:
	if not AccountState.is_owned(hero_id):
		return
	if _selected.has(hero_id):
		_selected.erase(hero_id)
	elif _selected.size() < MAX_SQUAD:
		_selected.append(hero_id)
	_refresh()

func get_squad() -> Array:
	return _selected.duplicate()

## ---------- build / refresh ----------

func _style_static() -> void:
	var bg := StyleBoxFlat.new()
	bg.bg_color = COL_GREEN
	bg.border_color = COL_GREEN_BORDER
	bg.set_border_width_all(3)
	bg.set_corner_radius_all(12)
	_battle_btn.add_theme_stylebox_override(&"normal", bg)
	var bg2 := bg.duplicate()
	bg2.bg_color = COL_GREEN.lightened(0.12)
	_battle_btn.add_theme_stylebox_override(&"hover", bg2)
	var bg3 := bg.duplicate()
	bg3.bg_color = COL_LOCK
	bg3.border_color = COL_PANEL_BORDER
	_battle_btn.add_theme_stylebox_override(&"disabled", bg3)

func _panel_style(card: bool = false, selected: bool = false) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = COL_CARD if card else COL_PANEL
	sb.border_color = COL_GREEN if selected else (COL_CARD_BORDER if card else COL_PANEL_BORDER)
	sb.set_border_width_all(3 if selected else 2)
	sb.set_corner_radius_all(10)
	return sb

func _build_roster() -> void:
	for c in _roster_grid.get_children():
		c.queue_free()
	_roster_cards = {}
	var filled: int = 0
	for hero_id in HERO_ORDER:
		if not AccountState.is_owned(hero_id):
			continue
		var data = GameState.heroes_by_id.get(hero_id)
		if data == null:
			continue
		_roster_grid.add_child(_make_hero_card(hero_id, data))
		filled += 1
	for i in range(ROSTER_SLOTS - filled):
		_roster_grid.add_child(_make_locked_slot())

func _make_hero_card(hero_id: StringName, data) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(110, 132)
	btn.add_theme_stylebox_override(&"normal", _panel_style(true))
	btn.add_theme_stylebox_override(&"hover", _panel_style(true))
	btn.add_theme_stylebox_override(&"pressed", _panel_style(true, true))
	var v := VBoxContainer.new()
	v.set_anchors_preset(Control.PRESET_FULL_RECT)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tex := TextureRect.new()
	tex.texture = data.portrait
	tex.custom_minimum_size = Vector2(0, 72)
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(tex)
	var name_l := Label.new()
	name_l.text = data.name
	name_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_l.add_theme_color_override(&"font_color", COL_TEXT_DARK)
	name_l.add_theme_font_size_override(&"font_size", 14)
	name_l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(name_l)
	var lv_l := Label.new()
	lv_l.text = "Lv %d" % AccountState.get_level(hero_id)
	lv_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lv_l.add_theme_color_override(&"font_color", COL_GREEN_BORDER)
	lv_l.add_theme_font_size_override(&"font_size", 12)
	lv_l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(lv_l)
	btn.add_child(v)
	btn.pressed.connect(func(): toggle_hero(hero_id))
	_roster_cards[hero_id] = btn
	return btn

func _make_locked_slot() -> PanelContainer:
	var p := PanelContainer.new()
	p.custom_minimum_size = Vector2(110, 132)
	var sb := _panel_style()
	sb.bg_color = COL_LOCK
	p.add_theme_stylebox_override(&"panel", sb)
	var q := Label.new()
	q.text = "?"
	q.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	q.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	q.add_theme_font_size_override(&"font_size", 40)
	q.add_theme_color_override(&"font_color", COL_PANEL_BORDER)
	p.add_child(q)
	return p

func _refresh() -> void:
	## Roster selection rims.
	for hero_id in _roster_cards:
		var btn: Button = _roster_cards[hero_id]
		btn.add_theme_stylebox_override(&"normal", _panel_style(true, _selected.has(hero_id)))
	## Squad row: selected mini-cards in order, then empty "+" slots.
	for c in _squad_row.get_children():
		c.queue_free()
	for hero_id in _selected:
		var data = GameState.heroes_by_id.get(hero_id)
		var p := PanelContainer.new()
		p.custom_minimum_size = Vector2(96, 110)
		p.add_theme_stylebox_override(&"panel", _panel_style(true))
		var v := VBoxContainer.new()
		v.alignment = BoxContainer.ALIGNMENT_CENTER
		var tex := TextureRect.new()
		tex.texture = data.portrait if data != null else null
		tex.custom_minimum_size = Vector2(0, 64)
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		v.add_child(tex)
		var l := Label.new()
		l.text = (data.name if data != null else "?") + "  Lv %d" % AccountState.get_level(hero_id)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.add_theme_color_override(&"font_color", COL_TEXT_DARK)
		l.add_theme_font_size_override(&"font_size", 11)
		v.add_child(l)
		p.add_child(v)
		_squad_row.add_child(p)
	for i in range(MAX_SQUAD - _selected.size()):
		var p := PanelContainer.new()
		p.custom_minimum_size = Vector2(96, 110)
		var sb := _panel_style()
		sb.bg_color = COL_LOCK
		p.add_theme_stylebox_override(&"panel", sb)
		var plus := Label.new()
		plus.text = "+"
		plus.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		plus.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		plus.add_theme_font_size_override(&"font_size", 34)
		plus.add_theme_color_override(&"font_color", COL_PANEL_BORDER)
		p.add_child(plus)
		_squad_row.add_child(p)
	_battle_btn.disabled = _selected.is_empty()
	## Real data only: sum of owned hero levels.
	var total: int = 0
	for hero_id in HERO_ORDER:
		if AccountState.is_owned(hero_id):
			total += AccountState.get_level(hero_id)
	_total_lv.text = "⭐ Total Lv %d" % total

func _on_battle() -> void:
	if _selected.is_empty():
		return
	GameState.new_session(_selected.duplicate())
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
```

Create `Prototype/godot/scenes/Home.tscn`:

```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/ui/home.gd" id="1"]

[node name="Home" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource("1")

[node name="Bg" type="ColorRect" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
color = Color(0.180392, 0.12549, 0.0980392, 1)

[node name="Margin" type="MarginContainer" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
theme_override_constants/margin_left = 14
theme_override_constants/margin_right = 14
theme_override_constants/margin_top = 14
theme_override_constants/margin_bottom = 14

[node name="VBox" type="VBoxContainer" parent="Margin"]
layout_mode = 2
theme_override_constants/separation = 10

[node name="TopBar" type="HBoxContainer" parent="Margin/VBox"]
layout_mode = 2

[node name="Title" type="Label" parent="Margin/VBox/TopBar"]
layout_mode = 2
size_flags_horizontal = 3
text = "⚒ WEAPONCRAFT"
theme_override_font_sizes/font_size = 18
theme_override_colors/font_color = Color(0.909804, 0.815686, 0.662745, 1)

[node name="TotalLv" type="Label" parent="Margin/VBox/TopBar"]
unique_name_in_owner = true
layout_mode = 2
text = "⭐ Total Lv 0"
theme_override_font_sizes/font_size = 14
theme_override_colors/font_color = Color(1, 0.843137, 0, 1)

[node name="HeroesHeader" type="Label" parent="Margin/VBox"]
layout_mode = 2
text = "HEROES"
horizontal_alignment = 1
theme_override_font_sizes/font_size = 22
theme_override_colors/font_color = Color(0.909804, 0.815686, 0.662745, 1)

[node name="RosterGrid" type="GridContainer" parent="Margin/VBox"]
unique_name_in_owner = true
layout_mode = 2
size_flags_vertical = 3
columns = 3
theme_override_constants/h_separation = 10
theme_override_constants/v_separation = 10

[node name="SquadHeader" type="Label" parent="Margin/VBox"]
layout_mode = 2
text = "FORM SQUAD"
horizontal_alignment = 1
theme_override_font_sizes/font_size = 18
theme_override_colors/font_color = Color(0.909804, 0.815686, 0.662745, 1)

[node name="SquadRow" type="HBoxContainer" parent="Margin/VBox"]
unique_name_in_owner = true
layout_mode = 2
alignment = 1
theme_override_constants/separation = 10

[node name="BattleBtn" type="Button" parent="Margin/VBox"]
unique_name_in_owner = true
custom_minimum_size = Vector2(0, 52)
layout_mode = 2
text = "⚔  BATTLE"
theme_override_font_sizes/font_size = 22
```

Run TestProgression → PASS (43 checks).

- [ ] **Step 3:** Flow wiring: in `project.godot` set `run/main_scene="res://scenes/Home.tscn"`. In `main.gd` `_on_reset_pressed` replace the body with:

```gdscript
func _on_reset_pressed() -> void:
	Combat.stop()
	get_tree().change_scene_to_file("res://scenes/Home.tscn")
```

- [ ] **Step 4:** Full sweep (7 suites) — 0 failed. NOTE: other suites instance scenes but none boot Main.tscn's scene-change paths headlessly; if any suite asserts main-scene config, fix per failure evidence.
- [ ] **Step 5 (visual):** AUTOSHOT the Home scene:

```powershell
$env:WC_AUTOSHOT = "C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\2_Weaponcraft_Godot\_art-build\renders\home_render.png"
& "C:\Godot_v4.6.2-stable_mono_win64\Godot_v4.6.2-stable_mono_win64_console.exe" --path "C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\2_Weaponcraft_Godot\Prototype\godot" res://scenes/Home.tscn
$env:WC_AUTOSHOT = ""
```

Expect exit 0 + `home_render.png` exists (do not judge aesthetics — the orchestrator reviews it).

- [ ] **Step 6:** Commit `feat(p0): Home screen — roster grid + squad select + battle flow`

---

**Self-review notes:** `new_session()` default `[&"bran"]` keeps every legacy test/dev-scene green. Home guards unowned toggles; GameState trusts its input (Home is the gate). `_on_reset_pressed` reroutes BOTH wipe-retry and stage-clear restart to Home — squad re-pick each run (intended loop). The squad mini-card duplication in `_refresh` is acceptable P0 UI code; revisit if a third card variant appears.
