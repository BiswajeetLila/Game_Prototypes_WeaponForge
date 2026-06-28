# 3-Hero Vertical UI — Design Spec

> **SSOT pointers:** gameplay/logic = `../../../2_Weaponcraft_Godot/docs/01_GDD.md` + the Godot build (unchanged).
> **Visual layout SSOT = `_paper-prototypes/WeaponCraft-VerticalUI-v2.html`** (the approved paper-prototype).
> Decisions log: `../../3hero-vertical-ui-DECISIONS.md` (D1–D13). This spec is **UI/layout only** — no gameplay change.
> Status: design APPROVED 2026-06-28 (live-prototype sign-off). Ready for implementation planning.

## 1. Goal & non-goals
**Goal:** re-skin the WeaponCraft run UI so all 3 heroes (Bran/Elara/Vex) are visible at all times, stacked
vertically, on the existing 3-slot crafting system; both FORGE and BATTLE screens. Match the reference mockups
`6_WeaponForge_TFTransistor/_art-build/screens/{Forge_State.jpeg,In_Battle.png}`.

**Non-goals:** any combat/economy/progression logic change; new parts/recipes/heroes; audio. The data model
already supports per-hero weapons — this work mostly *surfaces* existing state and re-labels slots.

## 2. The slot rename (applies to BOTH `2_` and `2b_`)
Backend slot ids become **`head` · `rune` · `body`** (Rune is always the middle slot). This replaces the old
`head`·`hilt`·`rune` (effectively `hilt`→`body`; Rune moves to center). All slots hold **weapon-anatomy parts**
(helmet parts removed). Visible labels vary by weapon type; **only "Rune" is constant**:

| Weapon | head label | rune | body label |
|---|---|---|---|
| Sword (Bran) | Hilt | Rune | Blade |
| Staff (Elara) | Shaft | Rune | Orb |
| Daggers (Vex) | Grip | Rune | Fang |
| Bow (future) | Grip | Rune | Bow |

A weapon-type→label map drives this (data-driven; extend per weapon). Touch points: `weapon.gd`
(get_slot/set_slot/slots), `forge_panel.gd` slot iteration `[head,hilt,rune]`→`[head,rune,body]`, PartData slot
assignments + the part catalog `.tres`, and any test asserting slot ids/labels (TDD: update the failing test first).

## 3. Screen A — FORGE (matches `Forge_State.jpeg`)
Top→bottom (see prototype `#forgePhone`):
1. **Top bar:** Stage badge (left) · **"Forge"** ribbon (center) · "Wave N incoming" + enemy icon + timer (right).
2. **Diorama / matchup** (generous height, absorbs vertical slack): heroes clustered LEFT (figure + name tag,
   locked hero = `❔ / ???`), upcoming-wave enemies RIGHT each with a `WEAK <element>` telegraph pill.
3. **Three hero forge rows** (one per roster slot, always present):
   - Left **hero tag**: circular portrait (per-hero accent ring) · HP bar (green) · **Ult bar (blue)** ·
     a control row = **Attack pill** (gold, cumulative ATK) + **Ult button** (blue ⚡). No numeric HP/ULT.
   - Right: the **3 rune slots** (`head`/`rune`/`body`), large framed, **icon-only by default**.
   - **Locked hero** = greyed shell: `❔` portrait, three 🔒 slots, "Locked — recruit at Wave N", no info.
4. **Shop rack:** 7 element tiles, each showing **icon + name + +ATK + gold cost** (shop is the only place
   rune name/ATK/gold are shown).
5. **Bottom bar:** gold total (left) · RE-ROLL (center) · **START NEXT WAVE** (right, primary).

**Interaction — clean by default:** anvil rune slots show only the icon. **Tapping a slot reveals its stat card
under that rune** (anatomy label + name + +ATK). Tapping again hides it. (Equip/unequip/merge routing is the
existing `Merge`/`Shop` API, now per-row by `hero_id` instead of a single `_current_hero_id`.)

## 4. Screen B — IN-BATTLE (matches `In_Battle.png`)
1. **Top bar:** Wave x/y (left) · Stage + Pause + ×2 (right). **No combo/chain badge.**
2. **Battle grid (~60%+, fills available height):** heroes in the LEFT column (each with HP green + Ult blue
   bars), enemies on the board, status FX (Steam/Chilled/Burning/Wet), attack VFX. No numeric HP.
3. **Weapon Rail (collapsed forge, bottom panel):** per hero → small portrait + 3 mini slot icons. **No** HP
   bars / ult pips here (they live on the grid heroes). **No shop rail in battle** (shop is Forge-only).

## 5. Godot mapping (for the plan)
- `scenes/ForgePanel.tscn` + `scripts/ui/forge_panel.gd` — replace the single-anvil + `_current_hero_id` model
  with a 3-row stack (one anvil per hero); add the diorama matchup strip; keep shop/gold/inventory global.
- `scenes/BattleView.tscn` + `scripts/ui/battle_view.gd` — vertical hero-lane grid + collapsed weapon rail.
- `scenes/HeroCard.tscn` / `SquadBar.tscn` — fold the per-hero tag (portrait + HP/Ult bars + attack pill + ult
  button) into the forge row; the standalone hero-selector SquadBar is no longer needed in-forge.
- `scenes/PartCard.tscn` — icon-only default + tap-to-reveal stat card; weapon-anatomy label from the slot map.
- `weapon.gd` / PartData / part `.tres` — the slot rename (§2).
- Reuse unchanged: `combat.gd`, `merge.gd`, `recipes.gd`, `shop.gd`, `game_state.gd` (per-hero weapons already exist).

## 6. Implementation sequencing (TDD; details in the plan)
1. **Slot rename** in `2_` and `2b_` — failing test first (assert `body` slot + per-weapon label), then
   `weapon.gd`/PartData/catalog/forge_panel; full headless sweep green.
2. **FORGE relayout** in `2b_` — 3-row stack + diorama matchup + clean-rune tap-reveal + per-weapon labels.
3. **BATTLE relayout** in `2b_` — vertical hero-lane grid + collapsed weapon rail; remove shop/combo in battle.
4. Visual QC vs the prototype + `Forge_State`/`In_Battle`; AUTOSHOT renders.

## 7. Open (non-blocking, post-port tuning)
- Band density at 3 rows on a real device (collapse non-focused rows?) — decide after seeing it in Godot.
- Per-weapon label sets beyond the table above; the "table view" UI is a later nicety.
- Battle top-bar center: left empty for now (the ref's chain badge is a 6_TFT mechanic, not WeaponCraft).
