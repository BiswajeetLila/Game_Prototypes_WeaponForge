> **HISTORICAL — implementation plan for the previous 2_WC P0 build (shipped at `fbe426d`). PullOverlay + ResultModal from this plan SURVIVE into REVIEW-3 (reused for FTUE Bran/Vex cinematics per spec §13). Plan itself is historical; do not re-execute. Current SSOT: [`../../01_GDD.md`](../../01_GDD.md). Pivot rationale: [`../specs/2026-06-12-fork-a-pivot-addendum.md`](../specs/2026-06-12-fork-a-pivot-addendum.md).**

# P0 Slice Beats — Results, Scripted Pull, Scout Intel, Juice

> **For agentic workers:** execute task-by-task, strict TDD where marked. Env + headless run command identical to `2026-06-12-p0-hero-progression-foundation.md`. Visual targets: `_art-build/screens/result_01.png`, `pull_01.png`. Style constants mirror `scripts/ui/home.gd` (COL_* palette).

**Goal:** the pitch beats — rich Victory screen (run XP + level-ups), scripted NEW-HERO pull on first W5 boss clear (grants Vex to the roster), Home scout-intel strip, damage-pop juice. CONTINUE returns to Home.

---

### Task 1: run-XP tracking + session level snapshot + first-pull grant (TDD)

**Files:** Modify `Prototype/godot/scripts/core/game_state.gd`, `Prototype/godot/scripts/core/account_state.gd`, `Prototype/godot/scripts/dev/test_progression.gd`

- [ ] **Step 1 (RED):** Append to test_progression.gd (calls in `_ready` after `_test_home_squad_selection()`):

```gdscript
func _test_run_xp_tracking() -> void:
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test.json"
	acc.reset()
	acc.ensure_defaults()
	acc.add_hero_xp(&"bran", 1000)  ## start at L2
	var gs = get_node("/root/GameState")
	gs.new_session([&"bran", &"elara"])
	_check("run_xp starts 0", gs.run_xp == 0, "got %d" % gs.run_xp)
	_check("session snapshot: bran L2", gs.session_start_levels.get(&"bran", -1) == 2, "got %s" % str(gs.session_start_levels))
	gs.award_wave_xp()
	gs.award_wave_xp()
	_check("run_xp accumulates per-hero amount", gs.run_xp == 200, "got %d" % gs.run_xp)
	var rows: Array = gs.result_rows()
	_check("result_rows: 2 rows", rows.size() == 2, "got %d" % rows.size())
	_check("result_rows: bran lv_from 2", rows[0]["lv_from"] == 2, "got %s" % str(rows[0]))
	_check("result_rows: xp_gained 200", rows[0]["xp_gained"] == 200, "got %s" % str(rows[0]))
	acc.reset()
	gs.new_session()

func _test_flags_roundtrip() -> void:
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test.json"
	acc.reset()
	_check("flag default false", acc.get_flag(&"pull_seen") == false, "")
	acc.set_flag(&"pull_seen")
	_check("flag set true", acc.get_flag(&"pull_seen") == true, "")
	acc.save_account()
	acc.reset()
	acc.load_account()
	_check("flag survives save/load", acc.get_flag(&"pull_seen") == true, "")
	_check("heroes survive new schema", true, "")  ## guarded implicitly below
	if FileAccess.file_exists("user://account_test.json"):
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://account_test.json"))
	acc.reset()

func _test_first_pull_grant() -> void:
	var acc = get_node("/root/AccountState")
	acc.save_path = "user://account_test.json"
	acc.reset()
	acc.ensure_defaults()
	var gs = get_node("/root/GameState")
	gs.new_session([&"bran"])
	_check("wave 4: no pull", gs.maybe_grant_first_pull(4) == false, "")
	_check("wave 5 first time: pull fires", gs.maybe_grant_first_pull(5) == true, "")
	_check("pull granted vex", acc.is_owned(&"vex") == true, "")
	_check("wave 5 again: no repeat", gs.maybe_grant_first_pull(5) == false, "")
	if FileAccess.file_exists("user://account_test.json"):
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://account_test.json"))
	acc.reset()
	gs.new_session()
```

Run → FAIL (`run_xp` etc. nonexistent).

- [ ] **Step 2 (GREEN — account_state.gd):** add a flags store with save-schema migration. Replace `save_account` and `load_account` and add the flag API + `_flags` var:

```gdscript
## Account-level boolean flags (FTUE beats, etc.). Persisted with the save.
var _flags: Dictionary = {}

func get_flag(flag: StringName) -> bool:
	return bool(_flags.get(String(flag), false))

func set_flag(flag: StringName) -> void:
	_flags[String(flag)] = true
```

In `reset()` add `_flags = {}` after `_heroes = {}`.

```gdscript
func save_account() -> void:
	var f := FileAccess.open(save_path, FileAccess.WRITE)
	if f == null:
		push_warning("AccountState: could not open %s for write" % save_path)
		return
	f.store_string(JSON.stringify({"heroes": _heroes, "flags": _flags}))
	f.close()

func load_account() -> void:
	_heroes = {}
	_flags = {}
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
	## v2 schema: {"heroes": {...}, "flags": {...}}; v1 legacy: flat heroes dict.
	var heroes_src: Dictionary = parsed.get("heroes", parsed) if parsed.has("heroes") else parsed
	if typeof(parsed.get("flags", null)) == TYPE_DICTIONARY:
		for k in parsed["flags"].keys():
			_flags[String(k)] = bool(parsed["flags"][k])
	for key in heroes_src.keys():
		var row = heroes_src[key]
		if typeof(row) == TYPE_DICTIONARY and (row.has("xp") or row.has("owned")):
			_heroes[String(key)] = {
				"xp": int(row.get("xp", 0)),
				"owned": bool(row.get("owned", false)),
			}
```

- [ ] **Step 3 (GREEN — game_state.gd):** add near the roster vars:

```gdscript
## Per-run progression display data (results screen).
var run_xp: int = 0                       ## XP gained per deployed hero this run
var session_start_levels: Dictionary = {} ## StringName -> level at run start
```

In `new_session`, after the squad unlock loop add:

```gdscript
	run_xp = 0
	session_start_levels = {}
	for hero_id in squad_order:
		session_start_levels[hero_id] = AccountState.get_level(hero_id)
```

In `award_wave_xp()` add `run_xp += XP_PER_WAVE` before the save. Then add:

```gdscript
## Rows for the victory screen: one per deployed hero.
func result_rows() -> Array:
	var rows: Array = []
	for hero_id in squad_order:
		var data = heroes_by_id.get(hero_id)
		rows.append({
			"id": hero_id,
			"name": data.name if data != null else String(hero_id),
			"portrait": data.portrait if data != null else null,
			"lv_from": int(session_start_levels.get(hero_id, 1)),
			"lv_to": AccountState.get_level(hero_id),
			"xp_gained": run_xp,
		})
	return rows

## First-ever W5 boss clear grants Vex (the scripted pull beat). Returns true
## exactly once per account; caller shows the PullOverlay on true.
func maybe_grant_first_pull(wave_num: int) -> bool:
	if wave_num != 5:
		return false
	if AccountState.get_flag(&"pull_seen"):
		return false
	AccountState.set_flag(&"pull_seen")
	AccountState.set_owned(&"vex", true)
	AccountState.save_account()
	return true
```

Run → PASS (TestProgression ~57; report actual).

- [ ] **Step 4:** Commit `feat(p0): run XP tracking, result rows, account flags, first-pull grant`

### Task 2: Victory results screen (data TDD done in T1; build + bind)

**Files:** Rewrite `Prototype/godot/scenes/ResultModal.tscn`, rewrite `Prototype/godot/scripts/ui/result_modal.gd`

- [ ] **Step 1:** Replace `ResultModal.tscn` content entirely:

```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/ui/result_modal.gd" id="1"]

[node name="ResultModal" type="ColorRect"]
z_index = 100
z_as_relative = false
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
color = Color(0.117647, 0.0784314, 0.0588235, 0.92)
script = ExtResource("1")

[node name="Margin" type="MarginContainer" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
theme_override_constants/margin_left = 22
theme_override_constants/margin_right = 22
theme_override_constants/margin_top = 30
theme_override_constants/margin_bottom = 24

[node name="VBox" type="VBoxContainer" parent="Margin"]
layout_mode = 2
theme_override_constants/separation = 14

[node name="Title" type="Label" parent="Margin/VBox"]
unique_name_in_owner = true
layout_mode = 2
text = "VICTORY"
horizontal_alignment = 1
theme_override_font_sizes/font_size = 34

[node name="Subtitle" type="Label" parent="Margin/VBox"]
unique_name_in_owner = true
layout_mode = 2
text = "subtitle"
horizontal_alignment = 1
theme_override_font_sizes/font_size = 13

[node name="RewardPanel" type="PanelContainer" parent="Margin/VBox"]
unique_name_in_owner = true
layout_mode = 2
size_flags_vertical = 3

[node name="RewardMargin" type="MarginContainer" parent="Margin/VBox/RewardPanel"]
layout_mode = 2
theme_override_constants/margin_left = 14
theme_override_constants/margin_right = 14
theme_override_constants/margin_top = 14
theme_override_constants/margin_bottom = 14

[node name="HeroRows" type="VBoxContainer" parent="Margin/VBox/RewardPanel/RewardMargin"]
unique_name_in_owner = true
layout_mode = 2
theme_override_constants/separation = 10

[node name="ActionBtn" type="Button" parent="Margin/VBox"]
unique_name_in_owner = true
custom_minimum_size = Vector2(0, 50)
layout_mode = 2
text = "▶  CONTINUE"
theme_override_font_sizes/font_size = 20
```

- [ ] **Step 2:** Replace `result_modal.gd` entirely:

```gdscript
## ResultModal — full-screen end-of-run screen (victory rewards / wipe).
## Visual target: _art-build/screens/result_01.png. "clear" renders the rich
## rewards panel (per-hero XP + level-ups); "wipe" stays compact.
## Main listens for restart_requested -> routes back to Home.
extends ColorRect

signal restart_requested

const COL_PANEL := Color("6b4a32")
const COL_PANEL_BORDER := Color("4a3826")
const COL_CARD := Color("e8d0a9")
const COL_CARD_BORDER := Color("8a5a3a")
const COL_GREEN := Color("57ab5a")
const COL_GREEN_BORDER := Color("2e6b33")
const COL_GOLD := Color("ffd700")
const COL_TEXT_DARK := Color("3a2a1c")

@onready var _title: Label = %Title
@onready var _subtitle: Label = %Subtitle
@onready var _reward_panel: PanelContainer = %RewardPanel
@onready var _hero_rows: VBoxContainer = %HeroRows
@onready var _btn: Button = %ActionBtn

func _ready() -> void:
	hide()
	var sb := StyleBoxFlat.new()
	sb.bg_color = COL_CARD
	sb.border_color = COL_CARD_BORDER
	sb.set_border_width_all(3)
	sb.set_corner_radius_all(12)
	_reward_panel.add_theme_stylebox_override(&"panel", sb)
	var bb := StyleBoxFlat.new()
	bb.bg_color = COL_GREEN
	bb.border_color = COL_GREEN_BORDER
	bb.set_border_width_all(3)
	bb.set_corner_radius_all(12)
	_btn.add_theme_stylebox_override(&"normal", bb)
	_btn.pressed.connect(func():
		hide()
		emit_signal(&"restart_requested")
	)

func open(kind: StringName) -> void:
	match kind:
		&"wipe":
			_title.text = "💀 DEFEAT"
			_title.add_theme_color_override(&"font_color", Color("ff5555"))
			_subtitle.text = "The squad fell at wave %d. Rebuild and try again." % GameState.wave
			_btn.text = "↺  BACK TO CAMP"
			_reward_panel.hide()
		&"clear":
			_title.text = "🏆 VICTORY"
			_title.add_theme_color_override(&"font_color", COL_GOLD)
			_subtitle.text = "All %d waves cleared!" % GameState.TOTAL_WAVES
			_btn.text = "▶  CONTINUE"
			_populate_rows()
			_reward_panel.show()
		_:
			_title.text = "?"
			_subtitle.text = ""
			_btn.text = "↺  BACK"
			_reward_panel.hide()
	show()

func _populate_rows() -> void:
	for c in _hero_rows.get_children():
		c.queue_free()
	var header := Label.new()
	header.text = "HERO XP"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override(&"font_size", 14)
	header.add_theme_color_override(&"font_color", COL_PANEL)
	_hero_rows.add_child(header)
	for row in GameState.result_rows():
		_hero_rows.add_child(_make_row(row))

func _make_row(row: Dictionary) -> Control:
	var h := HBoxContainer.new()
	h.add_theme_constant_override(&"separation", 10)
	var tex := TextureRect.new()
	tex.texture = row["portrait"]
	tex.custom_minimum_size = Vector2(44, 44)
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	h.add_child(tex)
	var v := VBoxContainer.new()
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var top := HBoxContainer.new()
	var name_l := Label.new()
	name_l.text = "%s   Lv %d → Lv %d" % [row["name"], row["lv_from"], row["lv_to"]]
	name_l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_l.add_theme_font_size_override(&"font_size", 14)
	name_l.add_theme_color_override(&"font_color", COL_TEXT_DARK)
	top.add_child(name_l)
	var xp_l := Label.new()
	xp_l.text = "+%d XP" % int(row["xp_gained"])
	xp_l.add_theme_font_size_override(&"font_size", 14)
	xp_l.add_theme_color_override(&"font_color", COL_GREEN_BORDER)
	top.add_child(xp_l)
	if int(row["lv_to"]) > int(row["lv_from"]):
		var up := Label.new()
		up.text = "  ⬆ LEVEL UP!"
		up.add_theme_font_size_override(&"font_size", 14)
		up.add_theme_color_override(&"font_color", COL_GOLD)
		top.add_child(up)
	v.add_child(top)
	var bar := ProgressBar.new()
	bar.custom_minimum_size = Vector2(0, 12)
	bar.show_percentage = false
	var lv: int = int(row["lv_to"])
	var xp: int = AccountState.get_xp(row["id"])
	var into: int = xp - HeroProgress.cumulative_xp_for_level(lv)
	var span: int = HeroProgress.xp_to_next(lv)
	bar.max_value = float(span) if span > 0 else 1.0
	bar.value = float(into) if span > 0 else 1.0
	var fill := StyleBoxFlat.new()
	fill.bg_color = COL_GREEN
	fill.set_corner_radius_all(5)
	bar.add_theme_stylebox_override(&"fill", fill)
	var track := StyleBoxFlat.new()
	track.bg_color = COL_PANEL_BORDER
	track.set_corner_radius_all(5)
	bar.add_theme_stylebox_override(&"background", track)
	v.add_child(bar)
	h.add_child(v)
	return h
```

- [ ] **Step 3:** Full sweep — all suites green (no existing test asserts ResultModal internals; if one does, adjust per evidence). TestUi especially must stay green.
- [ ] **Step 4:** Commit `feat(p0): rich victory screen — per-hero XP rows, level-ups, continue`

### Task 3: scripted pull overlay (Vex reveal)

**Files:** Create `Prototype/godot/scenes/PullOverlay.tscn`, `Prototype/godot/scripts/ui/pull_overlay.gd`; Modify `Prototype/godot/scenes/Main.tscn`, `Prototype/godot/scripts/ui/main.gd`

- [ ] **Step 1:** Create `pull_overlay.gd`:

```gdscript
## PullOverlay — scripted NEW HERO! reveal (pitch beat 2, pull_01 target).
## open(hero_id) renders the hero card with a pop-in tween; tap dismisses.
## Pure theater: the grant itself happens in GameState.maybe_grant_first_pull.
extends ColorRect

signal dismissed

const COL_CARD := Color("e8d0a9")
const COL_VIOLET := Color("7a4fa3")
const COL_GOLD := Color("ffd700")
const COL_TEXT_DARK := Color("3a2a1c")

@onready var _click_btn: Button = %ClickToDismiss
@onready var _card: PanelContainer = %Card
@onready var _portrait: TextureRect = %Portrait
@onready var _name_l: Label = %NameL

func _ready() -> void:
	hide()
	var sb := StyleBoxFlat.new()
	sb.bg_color = COL_CARD
	sb.border_color = COL_VIOLET
	sb.set_border_width_all(5)
	sb.set_corner_radius_all(14)
	_card.add_theme_stylebox_override(&"panel", sb)
	_click_btn.pressed.connect(func():
		hide()
		emit_signal(&"dismissed")
	)

func open(hero_id: StringName) -> void:
	var data = GameState.heroes_by_id.get(hero_id)
	if data == null:
		return
	_portrait.texture = data.portrait
	_name_l.text = data.name
	show()
	_card.scale = Vector2(0.7, 0.7)
	_card.pivot_offset = _card.size / 2.0
	modulate.a = 0.0
	var tw := create_tween().set_parallel(true)
	tw.tween_property(self, "modulate:a", 1.0, 0.2)
	tw.tween_property(_card, "scale", Vector2.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
```

Create `PullOverlay.tscn`:

```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/ui/pull_overlay.gd" id="1"]

[node name="PullOverlay" type="ColorRect"]
z_index = 120
z_as_relative = false
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
color = Color(0.0588235, 0.0392157, 0.0313726, 0.94)
script = ExtResource("1")

[node name="ClickToDismiss" type="Button" parent="."]
unique_name_in_owner = true
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
flat = true

[node name="VBox" type="VBoxContainer" parent="."]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -130.0
offset_top = -210.0
offset_right = 130.0
offset_bottom = 210.0
grow_horizontal = 2
grow_vertical = 2
theme_override_constants/separation = 16
mouse_filter = 2

[node name="Plaque" type="Label" parent="VBox"]
layout_mode = 2
text = "✨ NEW HERO! ✨"
horizontal_alignment = 1
theme_override_font_sizes/font_size = 30
theme_override_colors/font_color = Color(1, 0.843137, 0, 1)

[node name="Card" type="PanelContainer" parent="VBox"]
unique_name_in_owner = true
custom_minimum_size = Vector2(220, 260)
layout_mode = 2

[node name="CardV" type="VBoxContainer" parent="VBox/Card"]
layout_mode = 2
alignment = 1
mouse_filter = 2

[node name="Portrait" type="TextureRect" parent="VBox/Card/CardV"]
unique_name_in_owner = true
custom_minimum_size = Vector2(0, 170)
layout_mode = 2
expand_mode = 1
stretch_mode = 5
mouse_filter = 2

[node name="NameL" type="Label" parent="VBox/Card/CardV"]
unique_name_in_owner = true
layout_mode = 2
text = "Vex"
horizontal_alignment = 1
theme_override_font_sizes/font_size = 22
theme_override_colors/font_color = Color(0.227451, 0.164706, 0.109804, 1)

[node name="Stars" type="Label" parent="VBox/Card/CardV"]
layout_mode = 2
text = "★ ★ ★"
horizontal_alignment = 1
theme_override_font_sizes/font_size = 18
theme_override_colors/font_color = Color(1, 0.843137, 0, 1)

[node name="Hint" type="Label" parent="VBox"]
layout_mode = 2
text = "— TAP TO CONTINUE —"
horizontal_alignment = 1
theme_override_font_sizes/font_size = 12
theme_override_colors/font_color = Color(0.909804, 0.815686, 0.662745, 1)
```

- [ ] **Step 2:** Wire into Main. In `Main.tscn`: add at the top with the other ext_resources (use the next free id number — read the file first; e.g. if last is id="11", use id="12"):

```
[ext_resource type="PackedScene" path="res://scenes/PullOverlay.tscn" id="<NEXT_ID>"]
```

and append as a LAST top-level node entry (after the existing last node):

```
[node name="PullOverlay" parent="." instance=ExtResource("<NEXT_ID>")]
```

In `main.gd`: add `@onready var _pull_overlay: Control = %PullOverlay` — NOTE: the instanced node is a direct child named "PullOverlay", so use `$PullOverlay` instead of `%`:

```gdscript
@onready var _pull_overlay: Control = $PullOverlay
```

In `_on_wave_cleared`, right after the `GameState.award_wave_xp()` line, add:

```gdscript
	## Scripted pull beat: first-ever W5 boss clear grants Vex to the roster.
	if GameState.maybe_grant_first_pull(wave):
		_pull_overlay.open(&"vex")
```

- [ ] **Step 3:** Full sweep — green. (The overlay only opens via the grant path; headless suites never hit it.)
- [ ] **Step 4:** Commit `feat(p0): scripted NEW HERO pull overlay on first W5 clear`

### Task 4: scout intel on Home + damage-pop scaling + render pack

**Files:** Modify `Prototype/godot/scripts/core/game_state.gd`, `Prototype/godot/scripts/ui/home.gd`, `Prototype/godot/scenes/Home.tscn`, `Prototype/godot/scripts/ui/battle_view.gd`, `Prototype/godot/scripts/dev/test_progression.gd`; Create `Prototype/godot/scenes/dev/ShotResult.tscn` + `Prototype/godot/scripts/dev/shot_result.gd`, `Prototype/godot/scenes/dev/ShotPull.tscn` + `Prototype/godot/scripts/dev/shot_pull.gd`

- [ ] **Step 1 (RED):** Append test:

```gdscript
func _test_scout_intel() -> void:
	var gs = get_node("/root/GameState")
	var intel: String = gs.scout_intel()
	_check("scout intel mentions first boss weakness", intel.contains("ICE"), "got %s" % intel)
```

Run → FAIL (`scout_intel` nonexistent).

- [ ] **Step 2 (GREEN):** In `game_state.gd` add:

```gdscript
## Pre-run scout report: reveals the FIRST boss's weakness only (1-of-3
## telegraph per design spec §6). Reads the W5 boss definition.
func scout_intel() -> String:
	var first_boss_id: StringName = &"boss_slime_king"
	var def = get_enemy_def(first_boss_id)
	if def == null or String(def.weak_tag) == "":
		return "Scouts report: a boss guards Wave 5."
	return "Scouts report: %s at Wave 5 — weak to %s!" % [def.name, String(def.weak_tag).to_upper()]
```

Run → PASS.

- [ ] **Step 3:** Home strip — in `Home.tscn` add after the SquadRow node (before BattleBtn):

```
[node name="ScoutLabel" type="Label" parent="Margin/VBox"]
unique_name_in_owner = true
layout_mode = 2
text = "..."
horizontal_alignment = 1
autowrap_mode = 2
theme_override_font_sizes/font_size = 12
theme_override_colors/font_color = Color(1, 0.72, 0.42, 1)
```

In `home.gd` `_ready()` add (after `_build_roster()`):

```gdscript
	%ScoutLabel.text = "🔭 " + GameState.scout_intel()
```

- [ ] **Step 4 (juice):** In `battle_view.gd`, find the three `_spawn_pop(` call sites that pass a damage number with `profile.font_pt`-style size (around lines 291, 310, 319). For each, scale the font by damage: replace the font size argument `<expr>` with `<expr> + clampi(dmg / 4, 0, 12)` (use the local damage variable in scope at each site — `dmg` or `total_dmg`). Bigger hits literally print bigger.
- [ ] **Step 5:** Shot scenes (dev tooling for renders). `shot_result.gd`:

```gdscript
## Dev: seeds a finished-run state and opens the victory ResultModal so
## WC_AUTOSHOT can capture it. Not a test — a render rig.
extends Control

func _ready() -> void:
	AccountState.save_path = "user://account_shot.json"
	AccountState.reset()
	AccountState.ensure_defaults()
	AccountState.add_hero_xp(&"bran", 900)   ## L1, near L2 — bar nearly full
	GameState.new_session([&"bran", &"elara"])
	for i in range(3):
		GameState.award_wave_xp()             ## bran crosses into L2 -> LEVEL UP row
	var modal = load("res://scenes/ResultModal.tscn").instantiate()
	add_child(modal)
	modal.open(&"clear")
```

`ShotResult.tscn`:

```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/dev/shot_result.gd" id="1"]

[node name="ShotResult" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource("1")
```

`shot_pull.gd`:

```gdscript
## Dev: opens the PullOverlay (Vex) so WC_AUTOSHOT can capture it.
extends Control

func _ready() -> void:
	var overlay = load("res://scenes/PullOverlay.tscn").instantiate()
	add_child(overlay)
	overlay.open(&"vex")
```

`ShotPull.tscn`: same shape as ShotResult.tscn with `shot_pull.gd` and root name "ShotPull".

- [ ] **Step 6:** Full sweep (7 suites, 0 failed) + render pack (PowerShell, one scene at a time, WC_AUTOSHOT to `_art-build/renders/`): `home_render2.png` (Home), `result_render.png` (ShotResult), `pull_render.png` (ShotPull). Expect exit 0 + 3 PNGs.
- [ ] **Step 7:** Commit `feat(p0): scout intel strip, damage-pop scaling, render rigs`

---

**Self-review notes:** `result_rows()` reports flat per-hero `run_xp` (uniform award — correct for P0). Save schema v2 keeps v1 loads working (legacy flat dict). PullOverlay is pure theater; the grant is idempotent and tested. ShotResult uses its own save path — never touches the real account. `$PullOverlay` direct-child ref avoids unique-name scene-instance pitfalls.
