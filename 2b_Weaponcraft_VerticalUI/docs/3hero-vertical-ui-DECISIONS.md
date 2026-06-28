# 3-Hero Vertical UI — Decisions & Steps Log

> Running log for the `2b_Weaponcraft_VerticalUI` effort (started 2026-06-28). Append-only-ish;
> this is the working memory that the eventual design spec + Godot port will be built from.
> SSOT for *gameplay* stays `../2_Weaponcraft_Godot/docs/01_GDD.md` — this effort is **UI/layout only**.

## Goal
Re-skin the WeaponCraft run UI so **all 3 heroes (Bran/Elara/Vex) are visible at all times, stacked
vertically**, on the **existing 3-slot crafting system**. Gameplay logic is UNCHANGED. Target the exact
layout of two reference mockups (below). Final destination: port the locked layout to Godot 4.x.

## Reference mockups (the layout truth)
`../6_WeaponForge_TFTransistor/_art-build/screens/`
- **`Forge_State.jpeg`** — the FORGE screen layout to match exactly.
- **`In_Battle.png`** — the BATTLE screen layout to match exactly; its lower panel = a collapsed/compacted
  Forge_State (the "Weapon Rail" + "Shop Rail").

### Forge_State composition (top→bottom)
1. Top bar: Stage badge (left) · "FORGE BREAK" banner (center) · "Wave N incoming" + enemy icon + timer (right).
2. Hero diorama: 3 heroes posed on a green battle-board with name tags + rune-stone edge decor.
3. Ornate forge/anvil divider.
4. Three hero forge rows. Each: circular framed portrait + HP bar + ULT bar (+ cumulative ATK under portrait)
   on the left; then 3 large framed rune slots.
5. Shop rack: 7 element tiles, each with a gold cost.
6. Bottom bar: gold total (left) · RE-ROLL (center) · START NEXT WAVE (right, primary).

### In_Battle composition (top→bottom)
1. Top bar: Wave x/y (left) · center combo/chain badge · Stage (right) · pause + ×2 controls.
2. Battle grid (~55%): heroes in the left column, enemies on the tiled board, status-effect FX
   (Steam/Chilled/Wet/Burning), attack VFX, enemy HP bars.
3. Region 3 "Weapon Rail" = collapsed forge: per hero → small portrait + 3 mini slot icons + HP bar + ULT pips.
4. Region 4 "Shop Rail": gold + element tiles + re-roll.

## Decisions locked so far
- **D1 — Folder:** new top-level sibling `2b_Weaponcraft_VerticalUI/` (full copy of `2_`, minus `_archive`/`.godot`).
- **D2 — Branch:** `weaponcraft-vertical-ui/3hero-stacked-layout` off `main`. Slug `weaponcraft-vertical-ui` added to monorepo branch table.
- **D3 — Unfreeze:** `2_Weaponcraft_Godot` unfrozen permanently (both CLAUDE.md files updated).
- **D4 — Anvil model:** per-hero 3-slot anvil, all 3 heroes' anvils visible at once (data model already supports per-hero weapons).
- **D5 — Slot rename (BOTH `2_` and `2b_`):** backend ids `head` · `rune` · `body` (Rune always middle). Visual
  labels are weapon-anatomy and vary by weapon type; **only "Rune" is constant**. Examples: sword = Hilt·Rune·Blade,
  bow = Grip·Rune·Bow, staff = Shaft·Rune·Orb, daggers = Grip·Rune·Fang.
- **D6 — All slots are weapon-anatomy parts.** Helmet-type parts are removed; every slot holds a weapon part.
- **D7 — Locked heroes:** all 3 boards always present; an un-recruited hero is **greyed with NO hero/weapon info**
  (a locked shell) until owned.
- **D8 — Scope:** both FORGE and BATTLE are restacked vertically.
- **D9 — Clean-by-default rune treatment (feedback 2026-06-28):**
  - No HP%/ULT% numbers anywhere — **bars only**.
  - **Cumulative ATK** shown under each hero portrait (sum of equipped parts).
  - Anvil rune slots show **icons only** by default — no names, no numbers.
  - Clicking a rune reveals its stats (anatomy label + name + ATK increase) under that rune.
  - The **shop panel** is where runes show name + ATK increase + gold cost.
- **D10 — Forge diorama = matchup preview:** heroes clustered on the LEFT, the upcoming wave's enemies on the
  RIGHT each with a `WEAK <element>` telegraph pill. Diorama gets generous height (breathing room); the forge
  rows + shop rack sit at the bottom (no dead space above the bottom bar).
- **D11 — Title:** the forge title is just **"Forge"** (not "Forge Break").
- **D12 — Hero tag controls (under each portrait):** (A) gold **Attack pill** = cumulative ATK; (B) blue **Ult
  button** (⚡); (C) the **Ult charge bar is blue** (HP bar stays green). No numeric HP/ULT.
- **D13 — Battle view chrome:** NO shop panel in battle (removed) and NO combo/chain badge at the top. Battle =
  battle grid (fills) + the collapsed Weapon Rail only. (Shop/reroll happen in Forge between waves.)

## Design session — CLOSED 2026-06-28
HTML paper-prototype `_paper-prototypes/WeaponCraft-VerticalUI-v2.html` is the **visual SSOT** for the port.
Layout is locked per D1–D13. Next = port to Godot (see the spec + plan).

## Resolved (was open)
- Battle top-bar center badge: reference shows "CHAIN ×3" (a 6_TFT mechanic). WeaponCraft equivalent TBD
  (combo? wave? remove?). Placeholder in the prototype for now.
- Band density at 3 rows on a phone — user wants to see it on screen before deciding whether non-focused
  rows collapse.
- Exact per-weapon label sets beyond the examples (table view "maybe later").

## Steps taken
1. Pulled `main` (clean ff; root housekeeping only — `2_`/`2b_` untouched). Working-tree churn = Godot-MCP
   plugin + 4.6→4.7 reimport noise, not real edits.
2. Verified Godot MCP is connected (responds to protocol); CLI/headless probes need the configured binary path
   repointed off `C:\Program Files\Godot\Godot.exe`, and `run_project` before live `game_*` tools work.
3. Unfroze `2_`; created `2b_` copy; created branch; added slug to branch table.
4. Built HTML paper-prototype `_paper-prototypes/WeaponCraft-VerticalUI-v1.html` (initial vertical-stack pass).
5. **v2** (this step): rebuilt to match `Forge_State` + `In_Battle` exactly + applied D9 clean-rune feedback.

## Next
- Get the v2 prototype approved on-screen → write formal design spec in `docs/superpowers/specs/` →
  TDD implementation plan: (1) slot rename in both folders, (2) vertical relayout of ForgePanel + BattleView in `2b_`.
