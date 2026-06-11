# Juice Foundation — Game Feel PR1

## Context

The ultra-MVP currently ships a complete forge → fight → wave loop with three heroes, but combat *feels* dry. Every hit is a number on a bar and a single line of combat log; ults fire with one purple screen flash and nothing else. The mechanical depth is in place (3 heroes, 8-recipe combat math, per-element bonuses) — what's missing is the moment-to-moment feedback that turns a working game into one that *plays well*.

This spec defines the foundational juice kit: the universal effects every attack benefits from regardless of source. Element-specific particle bursts (PR2), per-ult cinematics (PR3), status-effect icons (PR4), and UI-click bounce (PR5) layer on top of this foundation in later sessions.

Aesthetic locked: **punchy-but-cozy**. Mid-range intensity that punctuates feel without breaking the parchment storybook vibe — Vampire-Survivors-ish but quieter.

Why a foundation-first PR: the four primitives (shake, hit-pause, damage popup, sprite flash) are the API every later PR will call into. Building them first means subsequent PRs only author content; they don't re-invent infrastructure.

Branch: `feature/juice-foundation`.

---

## Locked Decisions

- **Components in scope:**
  1. ScreenShake (autoload)
  2. HitPause (autoload)
  3. DamagePopup (BattleView child scene)
  4. Sprite hit flash (utility on BattleView / HeroCard)

- **Components deferred:**
  - HP bar damage-chunk delta layer (PR2)
  - Per-element particle bursts (PR2)
  - Crit-only screen flash overlay (PR2 — popup colour change is enough for PR1)
  - Per-ult cinematics (PR3)
  - Status-effect icons (PR4)
  - UI-click bounce / hover ripple (PR5)
  - Audio (separate audio PR)

- **No Combat changes.** Pure presentation layer reading existing signals. The 53/53 test suite stays green.

- **Time-scale model for HitPause:** sets `Engine.time_scale = 0.0`, drives an `await get_tree().process_frame` loop measuring elapsed wall-clock via `Time.get_ticks_msec()`. Restores time_scale = 1.0 when the budget is met. Process_frame fires regardless of time_scale, so the loop progresses; tweens and Combat timers freeze together.

- **Shake model:** trauma-based. `kick(amplitude_px, duration_sec)` adds to a `trauma: float` accumulator (capped at 1.0). Per frame, the Main scene root's `position` is set to a random offset scaled by `trauma * trauma * peak_amplitude`. Trauma decays linearly to 0 over `duration_sec`. Simultaneous kicks stack via `max`, so a crit during an ult doesn't double the shake; the bigger of the two wins.

- **Popup model:** Label spawned at the target sprite's centre in BattleView's coordinate space. Tween: scale 0.4 → 1.0 (back-out, 0.18s), drift up 30-40px (quart-out, 0.6-0.8s), modulate alpha 1.0 → 0.0 in last 0.25s. Concurrent popup cap: 8 — when the cap is exceeded, the oldest popup is `queue_free()`'d eagerly.

- **Sprite flash model:** tween `modulate` to `Color(1.8, 1.8, 1.8, 1)` over 0 seconds (instant), then back to `Color.WHITE` over `duration`. Modulate values above 1.0 brighten the rendered sprite without a shader. Restore guaranteed via tween's `tween_callback`.

---

## Tuning (single source of truth)

All numbers live in `scripts/core/juice_config.gd` as constants. Tweak one file, the whole game reads new values.

| Source key | Shake amp px | Shake dur s | Hit pause s | Popup font pt | Popup colour | Popup prefix | Flash dur s |
|---|---|---|---|---|---|---|---|
| `&"basic"` (no crit) | 3 | 0.12 | 0.05 | 18 | `#f0c060` amber | "" | 0.05 |
| `&"basic"` + is_crit | 6 | 0.18 | 0.10 | 26 | `#ff6040` red-orange | "⚡" | 0.07 |
| `&"steamburst"` | 4 | 0.14 | 0.06 | 18 | `#7ec5ff` ice-blue | "" | 0.06 |
| `&"skewer"` | 4 | 0.14 | 0.06 | 18 | `#9fe0ff` cyan | "" | 0.06 |
| `&"hellfire"` | 4 | 0.14 | 0.06 | 18 | `#ff8a4d` orange-red | "" | 0.06 |
| `&"ult"` (Whirlwind) | 10 | 0.35 | 0.18 | 28 | `#cb8aff` purple | "🌀" | 0.10 |
| `&"ult_meteor"` | 10 | 0.35 | 0.18 | 28 | `#ff7ab0` magenta | "🌀" | 0.10 |
| `&"ult_shadowstep"` | 10 | 0.35 | 0.18 | 32 | `#a86bff` violet | "⚡🌀" | 0.12 |
| Enemy hits hero | 4 | 0.15 | 0.06 | 16 | `#ff6060` red | "" | 0.05 |
| Wave clear | 6 | 0.25 | — | — | — | — | — |

`is_crit=true` overrides the popup font/colour/prefix and the shake/pause numbers for `basic` source. For ult sources, `is_crit` is informational only (Shadowstep already has its own row; the crit flag doesn't escalate the row further).

---

## Architecture

### Components

**`scripts/core/screen_shake.gd`** (autoload — registered as `ScreenShake`)

```
extends Node

const PEAK_AMPLITUDE_PX: float = 12.0

var _trauma: float = 0.0
var _decay_per_sec: float = 1.0
var _target: Control = null   ## set by Main on _ready

func register_target(node: Control) -> void:
    _target = node

func kick(amplitude_px: float, duration_sec: float) -> void:
    var traumatic = clampf(amplitude_px / PEAK_AMPLITUDE_PX, 0.0, 1.0)
    _trauma = max(_trauma, traumatic)
    _decay_per_sec = max(_decay_per_sec, traumatic / max(duration_sec, 0.01))

func _process(delta):
    if _target == null or _trauma <= 0.0:
        if _target != null:
            _target.position = Vector2.ZERO
        return
    var shake = _trauma * _trauma * PEAK_AMPLITUDE_PX
    _target.position = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
    _trauma = maxf(0.0, _trauma - _decay_per_sec * delta)
    if _trauma <= 0.0:
        _target.position = Vector2.ZERO
```

Public API: `kick(amplitude_px, duration_sec)`, `register_target(node)`.

**`scripts/core/hit_pause.gd`** (autoload — registered as `HitPause`)

```
extends Node

var _pending_until_ms: int = -1

func freeze(seconds: float) -> void:
    var until = Time.get_ticks_msec() + int(seconds * 1000.0)
    _pending_until_ms = max(_pending_until_ms, until)
    _run_freeze_loop()

func _run_freeze_loop() -> void:
    if Engine.time_scale != 0.0:
        Engine.time_scale = 0.0
    while Time.get_ticks_msec() < _pending_until_ms:
        await get_tree().process_frame
    Engine.time_scale = 1.0
    _pending_until_ms = -1
```

Concurrent calls extend the pause via `max`. Idempotent against re-entrancy: the outer `_run_freeze_loop` is the only one mutating time_scale; subsequent calls bump `_pending_until_ms` and the outer loop notices.

**`scripts/core/juice_config.gd`** (const dictionaries — no script attached, loaded as a resource)

```
class_name JuiceConfig
extends Resource

const PROFILES: Dictionary = {
    &"basic":            { "shake": 3.0, "shake_dur": 0.12, "pause": 0.05, ... },
    &"basic_crit":       { ... },
    &"steamburst":       { ... },
    ...
}

const ENEMY_HIT_HERO: Dictionary = { ... }
const WAVE_CLEAR: Dictionary = { ... }
```

Lookups via `JuiceConfig.PROFILES.get(key, JuiceConfig.PROFILES[&"basic"])` with the basic fallback.

**`scenes/DamagePopup.tscn` + `scripts/ui/damage_popup.gd`**

Root: Label with theme-overridden outline (so it reads against any background).
Method: `play(text: String, color: Color, is_crit: bool, font_pt: int)`. Spawns tweens, queues self-free at end of fade.

**`scripts/ui/juice_bus.gd`** (Node child of BattleView)

Central handler. Connects to `Combat.hero_hit_enemy`, `Combat.enemy_hit_hero`, `Combat.ult_fired` in `_ready`. Per signal: resolves target sprite rect via BattleView's getter, looks up JuiceConfig profile, invokes ScreenShake.kick + HitPause.freeze, calls BattleView.flash_sprite, spawns DamagePopup.

Holds a `_active_popups: Array` queue, caps at 8.

### Data flow

```
Combat.hero_hit_enemy(hero_id, idx, dmg, source, is_crit)
   ↓
JuiceBus._on_hero_hit_enemy
   ↓
   ├─ JuiceConfig.PROFILES[source + crit_suffix]
   ├─ ScreenShake.kick(profile.shake, profile.shake_dur)
   ├─ HitPause.freeze(profile.pause)
   ├─ BattleView.flash_enemy(idx, profile.flash_dur)
   └─ DamagePopupLayer.spawn(battle_view.enemy_rect(idx).center, str(dmg), profile.colour, is_crit, profile.font_pt)
```

`Combat.enemy_hit_hero(idx, hero_id, dmg)` routes through the same pipeline but flashes/popups over the relevant SquadBar.HeroCard instead of the BattleView enemy slot. SquadBar exposes `flash_card(hero_id, duration)` and `card_rect(hero_id) -> Rect2`.

`Combat.ult_fired(hero_id, total_dmg)` triggers ScreenShake + HitPause + a centred big popup. The hero's `hero_hit_enemy` calls (one per enemy hit by the AoE) still fire and each get their own per-enemy popup — that's intentional, the centred ult popup is the *total* summary, the per-enemy popups show distribution.

### Files

**New:**
- `scripts/core/screen_shake.gd`
- `scripts/core/hit_pause.gd`
- `scripts/core/juice_config.gd`
- `scripts/ui/damage_popup.gd`
- `scripts/ui/juice_bus.gd`
- `scenes/DamagePopup.tscn`

**Modified:**
- `project.godot` — register `ScreenShake` + `HitPause` autoloads near the bottom of the existing autoload block.
- `scenes/Main.tscn` — on `_ready`, call `ScreenShake.register_target(self)` so the shake targets the Main root Control.
- `scenes/BattleView.tscn` — add a `DamagePopupLayer` Control child (full-rect overlay) and a `JuiceBus` Node child.
- `scripts/ui/battle_view.gd` — add `enemy_rect(idx: int) -> Rect2` (world-space rect of the enemy sprite) and `flash_enemy(idx: int, duration: float) -> void` (tweens enemy sprite's modulate).
- `scripts/ui/hero_card.gd` — add `flash_card(duration: float)` and `card_rect() -> Rect2` (public so SquadBar can route per-hero juice).
- `scripts/ui/squad_bar.gd` — add `flash_card(hero_id, duration)` + `card_rect(hero_id)` lookup helpers (delegate to the matching HeroCard).
- `scripts/ui/main.gd` — call `ScreenShake.register_target(self)` in `_ready`.

**No changes:** Combat, GameState, Merge, Shop, Recipes, hero data, all dev test scenes.

---

## Testing

No new unit tests — the kit is pure visual feedback driven off signals that the 53/53 suite already verifies.

**Manual verification (F5 in Godot):**

1. **Normal hits** — wave 1 with Bran's iron edge + steel grip. Every Bran swing produces: amber damage popup over the targeted enemy, sprite brightens ~60ms, faint screen shake ~3px. Enemy hits Bran: red popup over his SquadBar card, the card flashes, small shake.
2. **Crits** — gear Bran for crit (h_iron_edge has +15% crit at L3). On crit, the popup is bigger + red-orange with a ⚡ prefix; shake feels noticeably stronger.
3. **Element splash** — equip fire+ice for Steamburst. The primary hit's popup is amber; the two splash popups are ice-blue and slightly smaller. Confirms `source` routing.
4. **Ult fire** — fill Bran's gauge, press Whirlwind. Big shake (~10px), ~180ms hit-pause where time freezes briefly, big purple "🌀 N total" popup centred over the battlefield, plus per-enemy popups for each AoE hit.
5. **Pause sanity** — during hit-pause, banners freeze too. Confirms time_scale=0 works for all tweens.
6. **No regressions** — 4 dev test scenes still 53/53 green.

---

## Critical Files

- [scripts/core/screen_shake.gd](2_Weaponcraft_Godot/Prototype/godot/scripts/core/screen_shake.gd) — NEW
- [scripts/core/hit_pause.gd](2_Weaponcraft_Godot/Prototype/godot/scripts/core/hit_pause.gd) — NEW
- [scripts/core/juice_config.gd](2_Weaponcraft_Godot/Prototype/godot/scripts/core/juice_config.gd) — NEW
- [scripts/ui/damage_popup.gd](2_Weaponcraft_Godot/Prototype/godot/scripts/ui/damage_popup.gd) — NEW
- [scripts/ui/juice_bus.gd](2_Weaponcraft_Godot/Prototype/godot/scripts/ui/juice_bus.gd) — NEW
- [scenes/DamagePopup.tscn](2_Weaponcraft_Godot/Prototype/godot/scenes/DamagePopup.tscn) — NEW
- [scenes/BattleView.tscn](2_Weaponcraft_Godot/Prototype/godot/scenes/BattleView.tscn) — add DamagePopupLayer + JuiceBus children
- [scripts/ui/battle_view.gd](2_Weaponcraft_Godot/Prototype/godot/scripts/ui/battle_view.gd) — add `enemy_rect()` + `flash_enemy()`
- [scripts/ui/hero_card.gd](2_Weaponcraft_Godot/Prototype/godot/scripts/ui/hero_card.gd) — add `flash_card()` + `card_rect()`
- [scripts/ui/squad_bar.gd](2_Weaponcraft_Godot/Prototype/godot/scripts/ui/squad_bar.gd) — add per-hero flash/rect delegators
- [scripts/ui/main.gd](2_Weaponcraft_Godot/Prototype/godot/scripts/ui/main.gd) — register shake target
- [project.godot](2_Weaponcraft_Godot/Prototype/godot/project.godot) — autoload registration

---

## Risks & Mitigations

| Risk | Severity | Mitigation |
|---|---|---|
| HitPause via `Engine.time_scale = 0` freezes the Notifications banner mid-pop, looking stuttery | Low | Pauses are 50-180ms — perceived as deliberate hit-stop. Banners resume cleanly. Acceptable. |
| Shake on Main's root Control offsets UI past viewport edges, clipping into 0/420 horizontally | Low | Peak amplitude capped at 12px; Main sits inside a 420x800 viewport with no critical UI within 12px of the edges. |
| `Engine.time_scale = 0` blocks SceneTreeTimer too — naive `await create_timer` would hang forever | Medium | HitPause uses `Time.get_ticks_msec()` wall-clock loop driven by `process_frame`, which fires regardless of time_scale. Verified pattern. |
| Popup spam during Steamburst-on-3-enemies + Skewer hits: 4+ popups per tick | Low | 8-popup concurrent cap; oldest queue_free'd eagerly when a 9th spawns. The latest hit is always the one a player just made — keep it readable. |
| Modulate brightening sprite to `(1.8, 1.8, 1.8, 1)` looks washed-out on already-bright sprites (e.g. white-robed Elara) | Low | Mid-range modulate value chosen empirically; if a sprite looks bad, drop its flash_dur in JuiceConfig per-source or per-hero override. Tunable in one file. |
| ScreenShake stacking on rapid hits accumulates trauma → constant shake | Low | Trauma stacks via `max` not `+=`, so simultaneous hits don't compound. Decay continues per frame. |
| Tween-on-frozen-time during HitPause = tweens stall at 0% then jump-to-target on unfreeze | Low | Acceptable — popups & flashes started during pause look "delayed" by ~100ms which reinforces the impact feel. |
| Modulate>1 doesn't brighten if a Theme `modulate_self` is also overriding the sprite | Very Low | BattleView sprites + HeroCard portraits don't currently set `modulate_self`; if a future PR does, hit-flash code can fall back to a shader. Documented. |
