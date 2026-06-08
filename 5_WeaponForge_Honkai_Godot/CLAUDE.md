# CLAUDE.md — WeaponForge prototype

Agent-facing standing rules. Auto-loaded for any session under
`5_WeaponForge_Honkai_Godot/`.

> **Project state lives in `docs/STATUS.md`.** This file is rules, not
> state. Read STATUS first for what is done / planned / queued.

---

## 1. Where to work

- **Active dev folder:** `5_WeaponForge_Honkai_Godot/` (this folder).
- **Active Godot project:** `Prototype/godot/project.godot` (Godot **4.6.2 Mono**).
- **Frozen playtester build:** `../2_Weaponcraft_Godot/` — never develop
  there. Open only to demo. See its `FROZEN-2026-06-01.md`.
- **Godot version is pinned.** Do not upgrade without owner sign-off —
  `.import` UID drift breaks the asset graph repo-wide.

---

## 2. Branch / merge / push policy

- **In-place branches.** `git checkout -b forgeloop/<feature>` cut inside
  `5_WeaponForge_Honkai_Godot/`. NO `.claude/worktrees/*` (owner pref 2026-06-08).
- **Default branch = `main`.** Merge to main = owner say-so only.
- **Push to remote:** allowed on feature branches without asking. Never
  force-push main, never `--no-verify` / `--no-gpg-sign`.
- **Commit style:** `area(scope): subject` (e.g. `ui(card): …`,
  `combat: …`, `docs: …`). HEREDOC the message. Trailer:
  `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>`.

---

## 3. TDD — non-negotiable

- **RED → GREEN per checkpoint.** Write failing test, make it pass, then commit.
- **Whole suite green per commit.** A coverage-dropping commit is a rollback candidate.
- **Stage-1 combat contract = EXACTLY neutral.** TestCombat asserts the
  shipped balance; any combat-math change must keep stage-1 green OR
  explicitly rebaseline + flag the rebaseline in the commit body.

---

## 4. Test conventions

Two cohorts under `scripts/dev/`:

- **Self-quitting** (exit code = fail count):
  TestWeaponData / TestShardData / TestInfuse / TestHomeScreen /
  TestAccountState / TestWeaponBridge / TestForgeWheel / TestForgeDraft /
  TestSkillCardData.
- **Legacy** (needs `--quit-after 400`):
  TestCombat / TestRecipes / TestShop / TestMerge / TestUi.
  godot MCP can't pass that flag → start, wait for the
  `=== N passed / M failed ===` line in `get_debug_output`, then `stop_project`.

~450 tests baseline (grows w/ Catalyst + roster).

---

## 5. Engine ops = godot MCP (owner pref 2026-06-03)

Default to `mcp__godot__*` for everything Godot-related.

- **Run:** `run_project(projectPath="…\\5_WeaponForge_Honkai_Godot\\Prototype\\godot", scene="res://scenes/dev/TestX.tscn")`
- **Read:** `get_debug_output` → find the summary line.
- **Stop:** `stop_project` (legacy scenes don't self-quit).
- **Headless console-exe** = fallback only when CI needs batch exit codes.

`projectPath` is always the main-folder godot path. Never a worktree.

---

## 6. Headless gotchas

- **Never write `user://account.json` from headless test code.** Use
  in-memory state or temp paths. Real saves only via the running app.
- **Cold-clone:** first scene run needs an `--import` pass; subsequent
  runs reuse `.godot/imported/`.
- **`.import` files are TRACKED** (Godot 4 UID stability) but autosave
  churns them on every open. **Discard, do not commit** (K-12). Stage
  files individually — never `git add -A`.

---

## 7. Save-schema policy

Save schema bumps = a NEW `_migrate_vN_to_vN+1()` fn in
`scripts/core/account_state.gd` + a TestAccountState case that loads an
old-format dict and asserts the v+1 defaults. Never silently widen the
schema. Current version: v4.

---

## 8. Numbers Policy

Numbers in code / data = **starting values**. Tune via playtest data,
not vibes. No magic numbers — declare a `const` with a `## Why N` line
when the value deviates from the design spec or encodes a balance call.
All economy / affinity / catalyst numbers are Numbers-Policy starts
until the balance-pass commits.

---

## 9. Caveman mode

A session hook flips chat output to "caveman" — fragments, drop
articles, no filler. **Exceptions** (write normal):

- Code, commit messages, PR bodies, security warnings, irreversible
  action confirmations, multi-step sequences where order risks misread.
- Owner says "stop caveman" / "normal mode".

Caveman is for CHAT, not source. `.gd` / `.tscn` / `.md` read normal.

---

## 10. Doc index (read order)

1. **`docs/STATUS.md`** — SSOT. State + queue + repo/engine rules. Start here.
2. **`docs/handoffs/<newest>.md`** — RESUME doc.
3. **`docs/prototype-screen-beats.md`** — beat-by-beat storyboard (ASCII mockups + status flags).
4. **`docs/teammate-deck.html`** — self-contained one-pager for sharing with teammates (open in any browser; deeper detail in `<details>` collapsibles).
5. **`docs/superpowers/specs/2026-05-27-wittle-inversion-design.md`** v2.2 — locked DESIGN.
6. **`docs/superpowers/specs/2026-06-06-progression-economy-architecture.md`** — depth map.
7. **`docs/superpowers/specs/2026-06-08-prestage-counterbuild-design.md`** + plan (counter-build, shipped).
8. **`docs/research/`** — competitor synthesis + anime auto-battler study.

`docs/05_roadmap.md` = post-launch live-ops, NOT the prototype queue.
Prototype queue = `STATUS §4 NEXT`. Plan-mode scratch
in `C:/Users/Biswa/.claude/plans/` is session-only.

---

## 11. Process discipline (new feature work)

1. `superpowers:brainstorming` → clarify, 2-3 approaches, design, owner approves.
2. Spec → `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`, commit, owner reviews file.
3. `superpowers:writing-plans` → impl plan, owner approves.
4. `superpowers:test-driven-development` + `superpowers:executing-plans`
   (or `superpowers:subagent-driven-development`) → execute via TDD.

Skip steps only on trivial (single-file mechanical) work or owner waiver.

---

## 12. Don't list

- ❌ Don't develop in `2_Weaponcraft_Godot/` (frozen).
- ❌ Don't create `.claude/worktrees/*` (owner pref).
- ❌ Don't write `user://account.json` from headless.
- ❌ Don't `git add -A` (catches `.import` autosave noise).
- ❌ Don't merge to `main` without owner say-so.
- ❌ Don't skip the stage-1 neutrality contract check.
- ❌ Don't upgrade Godot version without owner OK.
- ❌ Don't touch post-launch features (Battle Pass, PvP arena, guilds,
  armor gacha, Prestige Skins, daily challenge modes) — those are
  `05_roadmap.md` territory. Prototype scope = `STATUS §4 NEXT` only.
- ❌ Don't use `nano-banana-pro` (~$0.24/img) — default to `nano-banana`
  (~$0.04/img). Pro only on explicit owner ask per call.
- ❌ Don't create new docs (`.md`) unless task explicitly requires one
  (specs + handoffs + this file + storyboard are the exceptions).

---

## 13. Locked names / decisions

- **Pull currency:** Ember.
- **Forge currency:** gems.
- **Synergy system:** Catalyst (renamed from Resonance — Habby owns
  that term via Archero 2). Trademark check pending — fallbacks:
  Alloy / Confluence / Reaction / Harmonic.
- **Elements:** Fire / Ice / Electric / Wind (FTUE). Earth gates at Stage 10.
- **Roster (7 locked):** Bran / Elara / Vex (FTUE) + Hot Paladin (S2 cinematic)
  + 2nd Rogue + 2nd Mage + Hot Assassin. 3 deploy per stage.
- **Stage shape:** 5 waves / boss on W5. Boss rotates slime → golem → lich;
  scales per stage. (Spec is 15 waves with W5/W10/W15 bosses; prototype
  runs the compressed 5-wave shape.)
- **Catalyst stacking:** cap-1 stages 1-4, no-cap stages 5+ (2026-06-09).
- **Catalyst cap-1 priority order:** alphabetical compound name —
  Blizzard > Firestorm > Glacial Storm > Plasma > Stormfront > Wildfire
  (2026-06-09).
- **Catalyst first reveal:** Forge Wheel scripted pull #1 = Fire-Bran-class,
  pull #3 = Ice-Elara-class. Starters are non-elemental until then (2026-06-09).

New decisions land in `STATUS.md §3` (table) + the relevant design spec.
This file = rules only.

---

## 14. When stuck — escalate to owner

Ask the owner (don't guess) when: design ambiguous mid-build · about to
do something irreversible (mass delete, repo-wide rename, force-push,
dep major bump) · ≥2 failed attempts at a bug · spending money
(image-gen, ad-test, external panels).

---

## 15. Exit gates (prototype-end)

Any **2 of 3**:

- D1 retention ≥ 35 %
- FM-8 hero-bond probe ≥ 6/10 on BOTH axes (attachment + build-investment)
- ad CPI ≤ 80 % of Wittle benchmark (~$3.50 → ≤ $2.80)

\+ 10 h internal self-play, "want to come back?" ≥ 70 %.

**Kill triggers:** D1 < 30 % · satisfaction < 6/10 · no ad creative
within 30 % of Wittle CPI · FM-8 probe < 6/10 on either axis.
