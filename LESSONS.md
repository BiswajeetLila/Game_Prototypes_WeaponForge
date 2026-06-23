# WeaponCraft / WeaponForge — Cross-variant prototype lessons

> Canonical, human-readable lessons store. Synthesized 2026-06-18 across all six WeaponCraft / WeaponForge variants. Travels with the repo.
>
> **Long-form narrative:** [`weaponcraft-prototype-retrospective.html`](weaponcraft-prototype-retrospective.html) — open in a browser. Per-variant retrospective + gotchas table + game-design fundamentals checklist.
>
> **Tool-queryable mirror:** `~/.gstack/projects/BiswajeetLila-Game_Prototypes_WeaponForge/learnings.jsonl` (gstack store). Query with `gstack-learnings-search --query "<term>"`. Mirror; this markdown is source-of-truth on conflict.

---

## How to read this file

Each entry has a **stable key** (kebab-case, used by the gstack store), a **confidence** score (1–10), and a **source pointer** to the doc(s) where the lesson came from. Confidence ≥ 9 means we have seen the failure or success in this repo. 8 means strong inference from one variant. 7 or below means working hypothesis.

Sections:
1. **Design — do** (patterns to preserve in every future variant)
2. **Design — don't** (antipatterns that bit us)
3. **Architecture** (when-this-then-that structural rules)
4. **Engineering** (test discipline, review process)
5. **Engine / platform** (Godot 4.6 + Windows gotchas)
6. **How to add a new lesson**

---

## 1. Design — do

### `reveal-climax-invariant` — 9/10
Every variant that had a 4-second reveal climax (anvil-RING + name banner + arc-to-hero on craft completion) produced visible dopamine in testers. **Preserve a payoff moment of similar shape in every future variant, even if the build-up changes completely.** Promoted to pattern by ForgeLoop's post-mortem. Source: [`4_WeaponCraft_ForgeLoop/POST_MORTEM.md`](4_WeaponCraft_ForgeLoop/POST_MORTEM.md).

### `depth-per-weapon-not-breadth` — 8/10
Persistent weapons that grow across waves feel rewarding; fresh disposable weapons per wave do not. Mechanism can change (lap re-entry in v4, merge-bumps T1→T4 in v6) but the principle is invariant. Forge-again-to-stack-stats from ForgeLoop was directionally right even though the lap mechanism was wrong. Source: [`4_WeaponCraft_ForgeLoop/POST_MORTEM.md`](4_WeaponCraft_ForgeLoop/POST_MORTEM.md), [`6_WeaponForge_TFTransistor/HANDOFF.md`](6_WeaponForge_TFTransistor/HANDOFF.md).

### `feel-gate-core-before-meta` — 9/10
Do not write the battle-pass / Catalyst codex / scripted-pull cinematic spec until the core-loop CPI is inside the ad-test target. Variant 5 has the cleanest meta layer in the project and the least confidence in its core feel. Meta wraps a working core; it cannot substitute for one. Source: [`5_WeaponForge_Honkai_Godot/docs/STATUS.md`](5_WeaponForge_Honkai_Godot/docs/STATUS.md).

### `pivot-addendum-doc-required` — 8/10
When abandoning or pivoting, write a single-doc rationale that names the new pillars AND explains why the prior architecture was structurally wrong (not just unpolished). Makes the pivot reviewable, reversible, and discoverable months later. Exemplars: [`4_WeaponCraft_ForgeLoop/POST_MORTEM.md`](4_WeaponCraft_ForgeLoop/POST_MORTEM.md), [`6_WeaponForge_TFTransistor/docs/superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`](6_WeaponForge_TFTransistor/docs/superpowers/specs/2026-06-12-fork-a-pivot-addendum.md).

---

## 2. Design — don't

### `polish-not-engagement-fix` — 9/10
Sensory polish (per-tap feedback, juice layers, animation passes) does NOT fix a wrong core loop. ForgeLoop shipped 5-layer Anvil feedback and bounced testers; 2_WC shipped a polished P0 and pivoted the same day. **If playtester signal does not move after a polish pass, the diagnosis lives upstream of feedback strength.** Source: [`4_WeaponCraft_ForgeLoop/POST_MORTEM.md`](4_WeaponCraft_ForgeLoop/POST_MORTEM.md), [`2_Weaponcraft_Godot/NIGHT-LOG.md`](2_Weaponcraft_Godot/NIGHT-LOG.md).

### `no-modal-minigames-per-craft` — 9/10
Modal minigames inside a 4-minute mobile session feel like playing N games in series, not one game. ForgeLoop chained Bellows + Anvil + Quench + Engraver = 20+ s of mode-switched sub-experiences and bounced testers. **If a minigame is used at all, make it THE craft, not part of it.** Hearthstone has zero minigames inside Hearthstone. Source: [`4_WeaponCraft_ForgeLoop/POST_MORTEM.md`](4_WeaponCraft_ForgeLoop/POST_MORTEM.md).

---

## 3. Architecture

### `anatomical-slots-require-spatial-combat` — 9/10
Head + Hilt + Rune anatomical slot crafting forces a shop-RNG bottleneck unless the combat layer carries real-time agency. Side-view single-lane + anatomical slots = shop must bear 100% of cognitive engagement, while the slot system restricts the strategic vocabulary. **v6 fix:** Universal Function Sockets — one drafted Function plays as Active / Modifier / Passive depending on its socket — plus 3-lane spatial combat. Eliminates the missing-hilt progression trap. Source: [`6_WeaponForge_TFTransistor/docs/superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`](6_WeaponForge_TFTransistor/docs/superpowers/specs/2026-06-12-fork-a-pivot-addendum.md).

### `grid-3x3-hybrid-render-snap` — 8/10
The v6 3×3 battle grid is hybrid: `LaneState` keeps continuous `screen_x` advance (mechanic + 268 tests unchanged); `BattleView_v2` adds render-snap to nearest of 3 depth cells per lane for the discrete look. Same-cell enemies need stack-offset rendering or they overlap.

### `phase4-throwaway-explicit` — 8/10
Throwaway-prototype phases must explicitly list the dying code in `CLAUDE.md` to prevent accidental investment. See [`6_WeaponForge_TFTransistor/CLAUDE.md`](6_WeaponForge_TFTransistor/CLAUDE.md) §"Dying gameplay core" for the format.

---

## 4. Engineering

### `data-vs-effect-test-gap` ★ — 10/10
**The single most expensive engineering lesson in the project.** Tests asserting `.tres` / data file shape pass while combat code never reads those fields. v6 Phase-5 went 587/587 green; an adversarial-review workflow caught 5 spec-fidelity gaps. **Always assert the combat EFFECT** (spawn enemies, run a tick, observe hits / status / reaction / damage), not just that the row exists. Source: [`6_WeaponForge_TFTransistor/HANDOFF.md`](6_WeaponForge_TFTransistor/HANDOFF.md) — see Q6a / Q6b commits.

### `adversarial-review-per-batch` — 9/10
Run multi-agent adversarial review on every non-trivial content batch. v6 Phase-5 shipped 587/587 green; a 27-agent review found 5 real spec gaps that effect-level tests then closed. **Green sweeps lie about the things tests do not assert.** Adversarial review surfaces those. Make this default, not one-off.

---

## 5. Engine / platform — Godot 4.6 + Windows

### `godot46-classname-headless` — 9/10
`class_name MyResource` on `extends Resource` is not reliably resolvable at parse time during `--headless` runs unless the script is `preload()`ed first. **Workaround:** `const _MyScript: Script = preload("res://path/to/script.gd")`, then compare via `res.get_script() == _MyScript` instead of `res is MyResource`.

### `gdscript-walrus-node-autoload` — 9/10
`:=` type inference fails on Node-typed autoload return values. `var x := autoload_ref.method()` where `autoload_ref` came from `get_node("/root/X")` returns `Node` (no subtype). Use explicit annotation: `var x: bool = autoload_ref.method()`.

### `replace-all-multiline-hazard` — 9/10
`replace_all` across line boundaries silently joins lines when the pattern spans newlines. For multi-line patterns, rewrite the file cleanly instead.

### Stdout / shell gotchas (run-loop survival)
- PowerShell `*>` writes UTF-16; Godot logs are UTF-8 → garbled grep targets. Use Bash `> file 2>&1`, then `Read` the file plain.
- Parse error → exit 255 with ZERO test output → looks like a pass. Grep `SCRIPT ERROR|Parse Error` before trusting any sweep count.
- Godot processes go zombie under contention. `Stop-Process -Name Godot_v4.6.2-stable_mono_win64_console -Force` between runs.
- New PNGs need `--headless --import` ONCE before `load()` can find them.
- `const` arrays / dicts are read-only in Godot 4. Tests that hand combat heroes from a `const` array must `.duplicate(true)` first.
- Never write `user://account.json` from headless test code — pollutes the real save. Use in-memory state or temp paths.

Full per-bug detail table: see retrospective HTML §6 "Engineering gotchas."

---

## 6. How to add a new lesson

1. Surface during a session — the "ugh, future-me will hit this" moment.
2. Log to the gstack store (mirror, tool-queryable):
   ```bash
   ~/.claude/skills/gstack/bin/gstack-learnings-log '{"skill":"…","type":"pattern|pitfall|architecture","key":"kebab-key","insight":"…","confidence":N,"source":"observed","files":["…"]}'
   ```
3. If the rule is load-bearing for future-prototyper onboarding, mirror a markdown entry into the relevant section above with a pointer to the source doc. Keep narrative in the retrospective HTML, not here.
4. On conflict between this file and the gstack store, **this file wins** (humans edit it directly; gstack store is append-only and can drift on edits).

---

*Maintainer note: when a lesson stops being load-bearing (variant abandoned, mechanic dropped, fix obsoleted), move it to a `## Retired` section at the bottom with a one-line reason and date. Do not delete — historical context survives.*
