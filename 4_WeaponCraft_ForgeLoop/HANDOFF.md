# ForgeLoop — Session Handoff

**Date:** 2026-05-24
**Status:** Design spec complete + approved. Ready for implementation planning.
**Owner:** Biswajeet (biswajeet@lilagames.com)

This doc is the entry point for a fresh chat session that will pick up ForgeLoop implementation. The previous session was a multi-round brainstorm that landed on the W3 Forge Loop mechanic and produced a frozen design spec. That session is being **paused** so the user can continue exploring other parked ideas separately.

---

## TL;DR — what ForgeLoop is

A new mobile auto-battler variant where weapon crafting is a **Loop-Hero-style circular forge ring**. The player places forge-station tiles around an 8-cell ring; a glowing ingot laps the ring; each station triggers a juicy modal minigame (≤7s); the finished weapon reveals with an anvil RING animation and snaps into the hero's hand for combat.

Replaces menu-based crafting (which got boring after 2 minutes in `2_` and `3_`).

Lives in: `Game_Prototypes/4_WeaponCraft_ForgeLoop/`.

---

## Read these first (in order)

1. **`docs/superpowers/specs/2026-05-24-forgeloop-design.md`** — the frozen design spec. Source of truth. Read in full.
2. **`C:/Users/Biswa/.claude/plans/we-ll-use-a-new-tender-treehouse.md`** — the brainstorm trail. Useful for *why* decisions were made and what was considered + rejected. Skim, don't memorize.
3. **`../2_WeaponCraft_Base/docs/superpowers/specs/2026-05-22-BASE-A1-prototype.md`** — sibling variant's spec; format precedent + console event schema to extend.
4. **`../2_WeaponCraft_Base/Prototype/dist/BASE-A1_0.1.9.html`** — the build to fork. Combat layer + hero card + parchment-brass theme reused.
5. **`../2_WeaponCraft_Base/docs/02_GDD.md`** Part I + Part II — canonical pre-prototype GDD + build log.

---

## Locked design (do not relitigate)

| Axis | Value |
|---|---|
| Core mechanic | W3 Forge Loop — 8-cell hex ring, clockwise ingot |
| Fixed cells | Smelter (top) + Inspector (bottom) |
| Customizable cells | 6 |
| Starter stations | Bellows, Anvil, Quench, Engraver (4 of 6 slots; 2 empty) |
| Minigame interrupt | Full pause modal |
| Lap-1 pacing | 25–35s total |
| Weapon persistence | Persist + upgrade across waves |
| Loop direction | Always clockwise |
| Duplicates | Allowed; stack effect |
| Whiff handling | Soft fail — base output, no penalty |
| Forge cost | Flat 5g per lap in 0.1.0 |
| Sensory layer | S7 Lego snap-fit feedback on tile placement + forge complete |
| Combat layer | Turn-based auto-battle from `2_` |
| Roster (0.1.0) | Bran (Warrior) only |
| Reveal climax | 4s anvil-RING sequence + name banner + snap-fit click |
| Base weapon type | Shortsword (only one in 0.1.0) |

---

## 0.1.0 ship scope (one-line each)

1. 8-cell hex ring UI with 2 fixed + 6 customizable cells.
2. Drag-and-drop tile placement from tray with S7 snap-fit.
3. Tap "Start Lap" → ingot travels CW → station modals fire in sequence → lap completes.
4. Four modal minigames implemented: Bellows (rhythm pump), Anvil (timing tap), Quench (stop-the-bar), Engraver (trace-glyph).
5. Forge reveal animation: anvil RING + particle column + name banner + weapon snap-fit to hero.
6. Combat playback with weapon sprite on hero card + per-strike station pulse + ★ crit marker + element burst matching engraved glyph.
7. Weapon persists across waves; "Forge Again? (5g)" prompt re-enters loop.
8. Gold currency (5g start, +5g/wave, 5g/lap).
9. Console event instrumentation per spec schema.

---

## Explicitly OUT of scope for 0.1.0

- Multi-lap tier naming (Rough/Tempered/Masterwork) — 0.1.1
- 3-hero squad — 0.1.3
- Recipe codex + named station combos — 0.1.2
- Weapon durability / breakage — 0.1.2
- Run timer — 0.1.4
- Boss waves / affinity telegraph — 0.1.4
- Station tile rotation (Pipemania-like) — 0.1.4
- Folder / Grindstone / Polisher / Pattern Welder / Cooling Rack stations — 0.1.1-0.1.5 catalogue rollout
- Hard fails / weapon ruin
- Shop economy / tile reroll
- Persistent meta layer (gacha / BP / AFK / stamina)

---

## Build approach

Fork `2_WeaponCraft_Base/Prototype/dist/BASE-A1_0.1.9.html`. **Strip:**

- TFT-style parts shop
- 3-slot anvil grid (Head/Hilt/Rune)
- Recipe codex modal
- Tag-discovery overlay
- 3-hero roster (keep Bran only)

**Add:**

- 8-cell hex ring UI (SVG or CSS clip-path)
- Tile tray + drag-and-drop placement
- Ingot travel animation along ring
- 4 modal minigame implementations
- Forge reveal animation (~4s)
- Weapon sprite generator (composite blade + glyph + tint)
- Hero card weapon-sprite replacement
- "Forge Again" prompt
- New console events: `station_placed`, `forge_lap_started`, `minigame_*`, `lap_complete`, `forge_revealed`, `weapon_equipped`

**Output**: `4_WeaponCraft_ForgeLoop/Prototype/dist/FORGELOOP_0.1.0.html`

---

## Recommended first action in new session

Invoke the `writing-plans` skill (or `feature-dev:feature-dev`) with the design spec as input. The skill will break 0.1.0 into ordered implementation tickets. Expected ticket clusters:

1. **Foundation** — fork base HTML, strip removed systems, set up `4_/Prototype/dist/`.
2. **Ring UI** — 8-cell hex layout, tile tray, drag-drop placement, S7 snap-fit feedback.
3. **Ingot travel** — animation along ring, station-enter triggers.
4. **Minigame: Bellows** — modal, rhythm taps, heat tag output.
5. **Minigame: Anvil** — modal, timing taps, ATK + ★ output.
6. **Minigame: Quench** — modal, stop-the-bar, DUR output.
7. **Minigame: Engraver** — modal, trace-glyph, element tag output.
8. **Lap completion + commit prompt** — "Forge Now" vs "Run Another Lap".
9. **Forge reveal animation** — 4s climax sequence.
10. **Weapon sprite generator** — composite layers + hero card replacement.
11. **Combat playback hooks** — per-strike station pulse + ★ + element burst.
12. **Wave/forge persistence** — re-forge prompt, stat-additive re-laps.
13. **Console event instrumentation**.
14. **Validation pass** — open in browser, hit rubric.

---

## Where parked ideas live (don't bring into this session)

The original brainstorming session also surfaced a top-10 of mechanics that were NOT picked. Those are parked in `C:/Users/Biswa/.claude/plans/we-ll-use-a-new-tender-treehouse.md`. The user will explore those in a separate session. Mechanics parked:

- W1 Worker Routing (Lemmings-style)
- Fold+S11 Folding-Steel + Cheese-Slice combat
- Glyph-Chain Spellforge (standalone, not the Engraver minigame)
- W4 Stacklands forge mat
- W6 Triple Triad rune-flip
- W7 Suika crucible drop-merge
- W9 Programmable forge (Opus Magnum lite)
- S4 Domino chain combat
- W2 Ley-line Pipemania routing

If the new session feels stuck, do not pull from the parked list. Stay focused on ForgeLoop 0.1.0.

---

## Files registry after handoff

| Path | State |
|---|---|
| `4_WeaponCraft_ForgeLoop/HANDOFF.md` | This doc (NEW) |
| `4_WeaponCraft_ForgeLoop/docs/superpowers/specs/2026-05-24-forgeloop-design.md` | Frozen spec (NEW) |
| `4_WeaponCraft_ForgeLoop/Prototype/dist/FORGELOOP_0.1.0.html` | NOT YET CREATED — first deliverable |
| `4_WeaponCraft_ForgeLoop/VARIATION.md` | NOT YET CREATED — write during implementation |
| `4_WeaponCraft_ForgeLoop/docs/04_GDD.md` | NOT YET CREATED — write post-prototype |
| `4_WeaponCraft_ForgeLoop/Mockup/ForgeLoop_mockup_v1.png` | NOT YET CREATED — image prompts in plan file Round 5 |
| `C:/Users/Biswa/.claude/plans/we-ll-use-a-new-tender-treehouse.md` | Brainstorm trail (reference only, do not edit) |
| `../2_WeaponCraft_Base/Prototype/dist/BASE-A1_0.1.9.html` | Source fork target |
| `../2_WeaponCraft_Base/Prototype/dist/assets/heroes/bran_warrior.png` | Sprite to reuse |

---

## Caveman-mode note

User runs Claude with caveman-mode (terse) in the global `CLAUDE.md`. Honor that in chat replies. Design docs + code + commits stay in normal prose. See `C:/Users/Biswa/.claude/CLAUDE.md` for full instructions.

---

## Image-model cost policy reminder

From `~/.claude/CLAUDE.md`: default to `nano-banana` (Gemini 2.5 Flash Image, ~$0.04). Never use `nano-banana-pro` unless user explicitly names it per turn. Applies to any mockup generation during this work.

---

*End of handoff. Open the design spec next.*
