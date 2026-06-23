# Game_Prototypes — monorepo-level rules

> Scope: applies to **all** sibling Godot prototype folders in this repo. Each sub-project may override or extend via its own `<sub-project>/CLAUDE.md`.

## Engine

- All sub-projects target **Godot 4.6 Mono**.
- Godot binary on this machine: `C:\Godot_v4.6.2-stable_mono_win64\Godot_v4.6.2-stable_mono_win64_console.exe`.
- Headless test sweep pattern (exit code = failure count):
  ```
  <godot.exe> --headless --path <project_path> res://scenes/dev/<Scene>.tscn
  ```
- AUTOSHOT (non-interactive screenshot) pattern — needs a GL render context, run WITHOUT `--headless`:
  ```powershell
  $env:WC_AUTOSHOT = "<absolute-png-path>"
  & <godot.exe> --path <project_path> "res://scenes/<X>.tscn"
  ```
  The `ScreenshotHelper` autoload (if present in the sub-project) captures the viewport at t≈1.5s and quits.
- `.import` files churn on first open after a Godot version bump or asset re-import. Treat as noise — do **not** commit unless you intentionally re-imported.

## Godot 4.6 GDScript gotchas (apply across all sub-projects)

- **`class_name` types are unreliable in headless parse.** A `class_name MyResource` declared on `extends Resource` may not be resolvable at parse time during `--headless` runs unless the script is `preload()`ed first. Workaround in tests + autoload scripts: `const _MyScript: Script = preload("res://path/to/script.gd")` then check via `res.get_script() == _MyScript` instead of `res is MyResource`.
- **`:=` type inference fails on Node-typed autoload return values.** `var x := autoload_ref.method()` where `autoload_ref` comes from `get_node("/root/X")` returns `Node` (no subtype), so the inferred type is unknown → parse error. Use explicit annotation: `var x: bool = autoload_ref.method()`.
- **`replace_all` across line boundaries is dangerous.** When the replaced pattern spans newlines, the replacement can silently join lines. For multi-line patterns, rewrite the file cleanly instead.

## Branch naming — Game_Prototypes monorepo slug table

This monorepo's branch-naming convention follows the global policy in `~/.claude/CLAUDE.md` ("Branch naming policy"). The sub-project slugs to use here:

| Working in… | `<project-slug>` |
|---|---|
| `1_Robotek_WeaponCraft/` | `robotek` |
| `2_WeaponCraft_Base/` | `weaponcraft-base` |
| `2_Weaponcraft_Godot/` | `weaponcraft-godot` |
| `3_WeaponCraft_RealTime/` | `weaponcraft-realtime` |
| `4_WeaponCraft_ForgeLoop/` | `forgeloop` |
| `5_WeaponForge_Honkai_Godot/` | `weaponforge-honkai` |
| `6_WeaponForge_TFTransistor/` | `weaponforge-tftransistor` |
| repo root (cross-cutting / docs) | `game-prototypes` |

**Good examples:**
- `forgeloop/mvp-0.1.0-anvil-only`
- `forgeloop/round2-bellows-quench-engraver`
- `weaponcraft-base/0.1.10-recipe-codex-polish`
- `weaponcraft-realtime/streaming-defense-tuning`
- `weaponforge-tftransistor/vertical-slice`

Random-slug rename: if tooling forces `claude/<adj>-<scientist>-<hex>`, immediately `git branch -m <slug>/<keywords>` before doing meaningful work.

## TDD on data/config in Godot sub-projects

The global TDD-on-exit-plan policy applies here. Specifically for Godot: adding a `.tres` Resource (recipe, function, status, reaction, hero data, etc.) whose behavior is tested by a `Test*.tscn` headless harness **still counts as production code under TDD**. Write the test asserting the resource's effect first, watch it fail because the `.tres` isn't there yet, then add the file and watch it pass.

## Sub-project rules

Each sub-project owns its own `CLAUDE.md` for project-specific scope (SSOT pointers, active vs frozen status, dying-vs-surviving code lists, sub-project-specific engine notes). The current active project is **`6_WeaponForge_TFTransistor/`**; see [`6_WeaponForge_TFTransistor/CLAUDE.md`](6_WeaponForge_TFTransistor/CLAUDE.md) for its rules.

## Cross-variant prototype lessons

Canonical store: **[`LESSONS.md`](LESSONS.md)** at repo root. Six variants × one post-mortem × one pivot synthesized into ~13 keyed rules. Read on session start when about to design a new mechanic, pivot a variant, or run a content batch.

- Long-form narrative + per-variant retrospective: [`weaponcraft-prototype-retrospective.html`](weaponcraft-prototype-retrospective.html).
- Tool-queryable mirror (gstack): `~/.gstack/projects/BiswajeetLila-Game_Prototypes_WeaponForge/learnings.jsonl`. Query with `gstack-learnings-search --query "<term>"`.
- On conflict between `LESSONS.md` and the gstack mirror, `LESSONS.md` wins.

How to add a new lesson: see [`LESSONS.md`](LESSONS.md) §6.
