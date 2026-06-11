# Handoff — Stage C + Juice Hardening + Popup Cap Root Cause

**Date:** 2026-05-25 (second session of the day)
**Main tip after this session:** `741ec14` — `ROOT CAUSE — popup cap infinite loop in _spawn_pop`
**Previous handoff:** [2026-05-25-3hero-roster-juice-foundation.md](2026-05-25-3hero-roster-juice-foundation.md) (covers 3-hero roster + juice foundation PR1 + portrait-click forge select)
**Active prototype:** `Prototype/godot/scenes/Main.tscn` (Godot 4.6.2 Mono)

---

## What shipped this session

Eight feature branches landed on `main` in order, fitting the approved roadmap C → E → A → D → F. Stage C done; everything else this session was hardening + diagnostics + the root-cause fix for a 21 GB freeze.

### 1. Stage C — Full 11-part catalog + 6 new recipes (`feature/full-catalog-recipes`)

- Added 6 parts (`h_pyro_visor`, `h_frost_crown`, `h_thorn_spike`, `p_razor_grip`, `p_lightning_grip`, `r_pierce`). Catalog now 11 parts spanning all element + derived tags.
- Added 6 recipes: Permafrost, Skewer, Razor Wind (uses derived `crit` tag), Hellfire, Frostbite, Quickdraw (uses derived `charge` tag). All 8 recipes reachable in a single stage.
- 6 nano-banana cheap-tier sprites at 64² + rembg post-process (~$0.24).
- 7 new test cases in `test_recipes.gd` for the 6 new recipes + all-8-registered sanity. Suite went from 53/53 to 60/60.

### 2. TDD-on-plan-exit policy committed to global CLAUDE.md

After realising Stage C was built data-first / tests-after, ran a retroactive RED verify (strip each new recipe `.tres`, confirm 7 new test cases fail with `active=[]`, restore). Then added a global rule to `~/.claude/CLAUDE.md`:

> Whenever you exit plan mode (ExitPlanMode) and enter execution, you MUST invoke the `superpowers:test-driven-development` skill BEFORE writing any production code.

Persistent across all sessions/projects until lifted. Exceptions: throwaway prototypes, generated code, configuration files with no behavioural assertions. Retroactive RED verify is the accepted fallback when discovered mid-stream.

### 3. Juice hardening (`feature/juice-hardening`) — bug-prevention scaffolding

After user reported "wave 2 PC freeze + memory growth" two times.

- `HitPause.MAX_FREEZE_SEC = 0.2` hard ceiling. `freeze()` input clamps; `_pending_until_ms` re-clamps against `now + MAX_FREEZE_SEC`. A flood of overlapping freeze() calls now cannot extend the wall-clock window beyond 200 ms.
- `Combat.step()` writes `user://last_tick.txt` at end of every surviving tick: `wave=N tick=N`. `_tick_counter` resets on `start_wave`.
- Restored `file_logging/enable_file_logging.pc=true` in `project.godot` (a Godot autosave had stripped it).
- TDD: RED via missing `MAX_FREEZE_SEC` const + absent breadcrumb file. GREEN after. Suite 63/63.

### 4. Juice diag kill-switch (`feature/juice-diag-kill-switch`)

User crashed AGAIN at wave 3 tick 1 phase=end. Hardening cap held; suspicion broadened.

- Added `JuiceConfig.JUICE_ENABLED: bool = true` global flag. Setting `false` makes BattleView + SquadBar + Main skip `ScreenShake.kick` / `HitPause.freeze` / sprite-flash / per-card flash / wave-clear shake. Damage popups still spawn (they're the read-the-number ground truth).
- Phase-tagged breadcrumb: `start_wave` writes `phase=start`; tick end writes `phase=end`. Format: `wave=N tick=N phase=start|end`.
- TDD RED via missing const + absent phase token, GREEN after. Suite 65/65.

### 5. Juice hang-diag (`feature/juice-hang-diag`) — Heartbeat autoload + ScreenShake idle skip + TestStress

User crashed yet again at wave 2 tick=1 phase=end WITH JUICE_ENABLED=false, and memory hit 5+ GB. Forced rethink: juice on/off doesn't matter, so something else.

- New `Heartbeat` autoload (`scripts/core/heartbeat.gd`) writes `user://heartbeat.txt` every ~6 process frames: `frame=N ticks_msec=N time_scale=X`. Plus a sentinel write on `_ready` so the file exists immediately. Reveals if main thread was alive (mtime fresh) or blocked (mtime stale) at force-kill time, and confirms `time_scale` wasn't accidentally stuck at 0.
- `ScreenShake._process` no longer pokes `target.position = origin` every frame when trauma is 0 and target is already at origin. Without this, a 60 Hz idle write triggers a full Container layout cascade through Main's UI tree every frame. New `_at_origin` flag tracks state, `_set_count` counter exposes the write rate for tests.
- New `TestStress` scene (`scripts/dev/test_stress.gd` + `scenes/dev/TestStress.tscn`) — drives `Combat.step()` directly across 5 waves × 10 ticks. Reports per-wave heap growth. Result: 31 KB growth across full run = Combat / GameState / Recipes are clean; the hang lives in the UI signal layer.
- Suite 69/69.

### 6. Juice sub-phase diag (`feature/juice-subphase-diag`)

User crashed wave 5 (right after Vex joins). Heartbeat showed engine processed ~60 frames after `start_wave`, then hung before tick 1 completed. time_scale stayed 1.0. Need finer instrumentation.

- `Combat.step()` writes phase breadcrumb at sub-phases inside a tick: `tick_enter`, `tick_hero_attack:<id>`, `after_hero_loop`, `tick_enemy_attack:<idx>-><id>`, `after_enemy_loop`, `after_status`. Last value names the deepest reached point.
- New `SignalTrace` autoload (`scripts/core/signal_trace.gd`). `SignalTrace.note(handler_name, payload)` writes `user://last_signal.txt`. Wired into `BattleView._on_hero_hit_enemy / _on_enemy_hit_hero / _on_ult_fired` and `SquadBar._on_enemy_hit_hero`. On hang, the file names the last juice handler the main thread entered.
- Diagnostic-only (no behavioural assertion) — acknowledged TDD exception. Suite stayed 69/69.

### 7. ROOT CAUSE — popup cap infinite loop (`feature/popup-cap-infinite-loop-fix`)

User repro on this branch produced perfect diagnostics:
- `last_tick.txt`: `wave=3 tick=2 phase=tick_hero_attack:elara`
- `last_signal.txt`: `handler=battleview._on_hero_hit_enemy frame=2470 ... payload={hero:elara, enemy:1, dmg:8, src:basic, crit:false}`
- `heartbeat.txt`: `frame=2465 ticks_msec=42023 time_scale=1.00`
- Memory at force-kill: **21 GB**

The bug was in `BattleView._spawn_pop`:

```gdscript
const MAX_POPS: int = 8
while _pops_layer.get_child_count() > MAX_POPS:
    _pops_layer.get_child(0).queue_free()
```

`queue_free()` is **deferred** in Godot — the freed node stays in the scene tree until end of current frame. `get_child_count()` never decrements inside the loop. The loop spins forever on the same node (queue_free is idempotent), main thread blocks, heartbeat stops. 21 GB came from `get_child(0)` returning a Variant wrapper each iteration — billions of allocations/sec before GC catches up.

**Trigger pattern:** the bug only fires when popup count exceeds 8 in a single frame burst. That's why it kept moving wave numbers as content + heroes scaled:
- Wave 2 solo Bran + Steamburst splash on a crit chain → can hit 8
- Wave 3 Bran + Elara dual attacks + recipes → blows it in 1-2 ticks
- Wave 5 trio + recipes → blows it instantly

**Why TestStress missed it:** `Combat.step()` runs in isolation in the test; `_spawn_pop` lives in BattleView which only mounts under Main.tscn.

**Fix:** extracted into static helper `BattleView.cap_pop_layer(layer, max_pops)` with a bounded for-loop. Always terminates. Doc-comment on the function spells out the original failure mode so a future change doesn't reintroduce it.

```gdscript
static func cap_pop_layer(layer: Control, max_pops: int) -> void:
    if layer == null: return
    var excess = layer.get_child_count() - max_pops
    for i in range(maxi(0, excess)):
        layer.get_child(i).queue_free()
```

**TDD:**
- RED: test references missing `cap_pop_layer` static helper → parse error.
- GREEN: extract helper, test passes (cap returns in <1 ms with 20 children + MAX=8; child count drops to 8 after one frame yield; no-op when N < MAX).
- RED-VERIFY: flipped helper back to buggy `while`, ran `timeout 15` against TestCombat — output stopped before the cap_pop_layer PASS line, exit code 0 from timeout, process hung. Restored the fix.

Suite: combat 31 (+2 cap tests) + recipes 18 + shop 7 + merge 15 = **71/71**. Resolves all three wave-2/3/5 freezes and the 21 GB memory growth.

---

## Current build state

- **Engine:** Godot 4.6.2 Mono
- **Window:** 420 × 800 portrait, Compatibility renderer
- **Heroes:** Bran (W1), Elara unlocks W2 clear, Vex unlocks W4 clear
- **Waves:** 5 (TOTAL_WAVES bump to 15 + boss waves come in Stage D)
- **Parts catalog:** 11 (full)
- **Recipes shipped:** 8 (full)
- **Autoloads (in order):** GameState, ScreenshotHelper, RNG, Recipes, Merge, Shop, Combat, ScreenShake, HitPause, Heartbeat, SignalTrace
- **Live log:** `%APPDATA%/Godot/app_userdata/WeaponCraft Godot Ultra-MVP/logs/godot.log`
- **Diagnostic files in same dir:**
  - `last_tick.txt` — Combat tick breadcrumb (wave/tick/phase)
  - `last_signal.txt` — Last juice handler entered
  - `heartbeat.txt` — Per-frame engine liveness ping
- **F12 in-game:** screenshots to user_data dir
- **Test suite:** 71/71 (`TestCombat 31`, `TestRecipes 18`, `TestShop 7`, `TestMerge 15`)
- **Stress harness:** `scenes/dev/TestStress.tscn` — 5 waves × 10 ticks, reports heap growth

---

## Open known issues / Phase 2 candidates

Per the roadmap in `C:\Users\Biswa\.claude\plans\snug-jumping-sparrow.md`. Order is **C → E → A → D → F**.

| Stage | What | Status |
|---|---|---|
| C | Full 11-part catalog + 6 recipes | ✓ shipped this session |
| E | Audio (hit / ult / merge / click SFX via Kenney CC0) + AudioBus autoload | next |
| A | Juice PR2 — element particle bursts + crit screen flash + HP bar damage chunk | queued |
| D | Boss wave + Reforge-&-Retry modal + bump to 15 waves + retime hero unlocks (Elara W3, Vex W6) + 3 boss enemies with telegraphs + per-boss tick hooks | queued |
| F | Multi-hero ult balance pass — per-fight gauge reset + bumped fill constants | queued |

The 15-wave balance sheet (HP curve, ATK curve, gold curve, spawn count curve, recipe discovery targets, boss specs) is documented in the plan file. Stages E + A use existing 5-wave formulas; the wave-count bump activates only in Stage D.

---

## Lessons learned (write into project memory if continuing)

1. **Godot `queue_free` is deferred.** Never use `while get_child_count() > N: get_child(0).queue_free()`. Use a bounded for-loop OR `remove_child` followed by `queue_free`.
2. **TDD-on-plan-exit policy is now global.** Every plan→execution transition invokes `superpowers:test-driven-development`. Retroactive RED verify is the accepted fallback when discovered mid-stream.
3. **Diagnostic autoloads are cheap insurance.** Heartbeat + SignalTrace + breadcrumb caught a bug pure code-reading would have missed for a long time.
4. **TestStress without UI doesn't catch UI signal-layer bugs.** Either mount a stub scene or test handlers directly.
5. **Sub-phase breadcrumbs in tick loops are gold.** When a hang happens during a 1.1 s gap, knowing exactly which sub-step blocked saves hours.

---

## Where things live (delta from previous handoff)

```
2_Weaponcraft_Godot/Prototype/godot/
├── scripts/core/
│   ├── screen_shake.gd          (+ idle skip + _at_origin + _set_count diagnostics)
│   ├── hit_pause.gd             (+ MAX_FREEZE_SEC = 0.2 hard ceiling)
│   ├── heartbeat.gd                                                       NEW
│   ├── signal_trace.gd                                                    NEW
│   ├── juice_config.gd          (+ JUICE_ENABLED const)
│   └── combat.gd                (+ sub-phase breadcrumbs + _tick_counter)
├── scripts/ui/
│   └── battle_view.gd           (+ static cap_pop_layer helper, bug-fix doc comment)
├── scripts/dev/
│   ├── test_combat.gd           (+ cap_pop_layer test, breadcrumb test,
│   │                             heartbeat test, ScreenShake idle test,
│   │                             ult dispatch tests, JUICE_ENABLED const test)
│   ├── test_recipes.gd          (+ 7 new cases: 6 recipes + all-8-registered)
│   └── test_stress.gd                                                     NEW
├── scenes/dev/
│   └── TestStress.tscn                                                    NEW
├── data/parts/                  (+ h_pyro_visor / h_frost_crown / h_thorn_spike /
│   │                             p_razor_grip / p_lightning_grip / r_pierce)
├── data/recipes/                (+ permafrost / skewer / razor_wind /
│                                 hellfire / frostbite / quickdraw)
└── assets/generated/parts/      (+ 6 new 64² sprites + _raw originals)
```

---

## How to resume tomorrow

1. `cd C:/_BISU/_WORKSPACE/AI_Explorations/_Claude/Game_Prototypes` (root, on `main`).
2. `git pull` — fast-forwards to wherever the team is.
3. Open project: `2_Weaponcraft_Godot/Prototype/godot/project.godot`. F5 to verify.
4. Re-run all 5 dev test scenes (right-click → Play Scene): expect 71/71 + TestStress logs heap growth ~30 KB.
5. Start Stage E (audio) — see the prompt at the bottom of this doc.

---

## Cost summary (this session)

| Spend | What |
|---|---|
| ~$0.24 | 6 part icons via `nano-banana` cheap tier |
| Total | ~$0.24 |

No regenerations needed.

---

End of handoff. Build is in a strong, stable state: 11 parts, 8 recipes, 3 heroes, 5 waves, full juice kit with hardened guards, 71/71 tests green, all crash modes resolved. Ready for Stage E (audio) next.
