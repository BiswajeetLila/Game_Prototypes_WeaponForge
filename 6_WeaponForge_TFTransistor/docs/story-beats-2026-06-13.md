# WeaponForge TFTransistor — Story Beats

> **Subordinate to** [`01_GDD.md`](01_GDD.md) — folder SSOT. This doc elaborates the GDD's "FTUE" + "Core loop" sections into a narrative wave-by-wave script — the **felt experience** of a player going through their first world and beyond. Use this for art, audio, UX, and playtest observation reference.

**Date:** 2026-06-13 · **Status:** Active. Replaces historical 2_WC story-beats (`story-beats.md`, now HISTORICAL banner-marked).

---

## Beat 0 — Cold start, the question

> Player opens the app. Title card. Wittle/Capybara-Go-flavored portrait UI.

**What they see:** logo, "Tap to start" prompt. Background art: a craftsman's anvil with three glowing weapons hovering above (representing the 3-socket Function Matrix).

**What they think:** "Another mobile RPG. Let's see what's different here."

**What we want them to feel:** mild curiosity. The Wittle/Brotato pedigree visual cues lower their skepticism. The 3-weapon hover image plants the "this is about weapon choice" hook before they tap.

---

## Beat 1 — FTUE Stage 1: Elara solo, first attack

> Player taps start. Game cuts straight into FTUE world 1, stage 1, wave 1. NO menu, no character select — combat immediately, just Elara alone in the middle lane. 3 weak goblins walk in from the right.

**What's on screen:**
- 3-lane corridor (only lane 1 active; lanes 0 + 2 darkened)
- Elara on left side of lane 1, idle stance
- 3 goblins entering from off-screen right, walking left toward Elara
- 7-slot shop at top — 5 slots empty (locked), 2 slots populated with **`FIRE` (T1)** and **`WATER` (T1)** cards (forced FTUE pre-roll)
- Bottom rail showing Elara only — 3 empty sockets pulsing softly
- Tutorial overlay: "Drag FIRE to Elara's Active socket"

**What they do:** drag FIRE card down to Elara's Active pip. Card lands; Elara begins firing red projectiles each tick at the closest goblin.

**What they feel:** "Oh, that's what I drag where. OK." First micro-decision, micro-reward. The forge moment is established in literally one drag.

**Goblins:** die one by one to FIRE attacks, leaving small Burning VFX on the lane floor briefly.

**Wave ends.** Forge break (F1). Tutorial overlay: "Try a Modifier — warps the Active beneath."

---

## Beat 2 — FTUE Stage 2: Elara's first modifier

> Same setup. Elara solo, lane 1. This time the shop populates normally — 2 items at stage start, more drip in across the wave.

**What's on screen:**
- Slow-populate shop fills with FIRE, WATER, AOE, LIGHTNING, LEECH (T1) over the wave
- 4 goblins from N+S edge spawns — wait, no, still lane 1 only (FTUE)
- 4 goblins from off-screen right

**What they think:** "I could put WATER as a Modifier to my FIRE Active. What happens?"

**Discovery moment:** they drag WATER onto Modifier socket below FIRE. Elara's projectiles now have a small blue tinge. On hit, both Burning AND Wet apply to the goblin.

**What they feel:** "Wait, can I now combo this somehow?" The seed is planted; no payoff yet (single-hero combat doesn't trigger reaction between own statuses).

**Wave ends.** F2 forge break begins.

---

## Beat 3 — F2 cinematic: Bran joins

> Mid forge break, the screen darkens. The familiar PullOverlay (carried from 2_WC P0) slides in. A new hero portrait — armored, glowing sword — appears.

**Cinematic:** Bran walks in from the right side of the screen, slams his sword tip into the ground in lane 1 (Elara's spot). Elara gives a small nod, walks one lane up to lane 0. Bran takes lane 1.

**Tutorial line:** "Bran joins the forge. **Try this:** Elara's WATER hits a tile → Bran's swing with FIRE Mod = **STEAM** reaction. First Magicka moment."

**What they think:** "Two heroes! And there's a thing called Steam coming."

**Bottom rail updates:** now shows 2 hero rows. Both have 3 empty sockets (Elara's loadout from previous stages carries — FIRE Active + WATER Mod; Bran fresh).

---

## Beat 4 — FTUE Stage 3 wave 1: THE STEAM MOMENT

> The make-or-break beat. Player drags FIRE onto Bran's Modifier socket. New enemies pour in from N + S + W edges.

**What happens in combat:**
- Elara fires WATER+FIRE-modded ranged projectiles, applying both Wet + Burning to enemies
- Bran's melee swing now carries FIRE damage tag (via FIRE Modifier)
- An enemy walks into Bran's melee range carrying Elara's pre-applied Wet status
- Bran swings → FIRE-tag hits Wet enemy → **STEAM reaction fires**
- Visual: cross-lane splash (Bran's lane + 1 enemy each in lanes 0 + 2), white steam VFX, Blind icon appears on splashed enemies
- Audio: `sfx_steam_hiss` over the impact
- Reaction Chain HUD lights up: **×1 STEAM**

**What they feel:** "I CAUSED THAT." The hook lands. They understand: the heroes don't just fight independently — they combine. Build = reactions = power.

**Observable check (playtest):** can the player articulate "Elara set up Wet, Bran fired FIRE, that was Steam"? PASS = the slice is succeeding at its mission.

---

## Beat 5 — FTUE Stages 3-4: Building the chain

> Player has Bran + Elara. Multiple reactions on the board now. Chain counter starts hitting 2, 3, sometimes more in a single tick.

**What's happening:**
- 7-slot shop slow-populates every wave (2 at stage start, 3 across waves, 2 right before stage break per Mit-D)
- Enemies vary now — some Wet-weak (vulnerable to Electrocute setup), some Burning-resistant
- Wave Telegraph icon shows mid-forge-break — player taps, sees portrait + weak/resist icons for next stage
- Player starts strategically pre-loading Wet via Elara → letting Bran trigger Steam reactions
- Each reaction = +1/3 toward Ult bar fill

**Bottom rail update:** Bran's Ult bar starts filling. Tutorial hint: "Tap Bran's portrait when Ult bar is full = **Leap & Slam**."

**At stage 4 mid-wave:** player taps Bran's portrait when Ult bar full.

---

## Beat 6 — The first Bran Leap & Slam

> The juicy combo event the user requested.

**What happens:**
- Time briefly slows (0.5× for 0.3 sec — slo-mo punctuation)
- Bran's sprite arcs upward, leaving lane 1
- He hangs airborne for a beat (camera pans briefly)
- Crashes down on the back-most enemy in his lane
- 5× base dmg radial blast hits target + 4 nearest enemies (cross-lane)
- Cracked +2 stacks applied to all hit enemies
- Bran returns to home tile in 1 tick
- Audio: heavy bass thump + screen shake

**What they feel:** elation. The cinematic moment lands. "I gotta do that again."

**Strategic implication:** now they know — stacking reactions to fill Ult bar = unlocks juicy moments. Forge feeds combat feeds Ult feeds catharsis.

---

## Beat 7 — F4 cinematic: Vex joins

> Pre stage-5 break (boss stage). Lights dim. PullOverlay again.

**Cinematic:** Vex (rogue, lithe figure with twin daggers) slides into lane 2 from off-screen-right with a quick dash animation. Quick flip. Lands in stance.

**Tutorial line:** "Vex executes Burning targets — innate +20% damage. All 3 heroes now. Full Magicka chain across all lanes."

**Bottom rail updates:** all 3 rows now visible. Full forge interface. Stage 5 boss approaches.

---

## Beat 8 — FTUE Stage 5: Boss climax

> The world's final stage. 3 waves: mini-boss W1, mini-boss W2, BOSS W3.

**Mini-bosses (W1, W2):**
- Single lane, single tile, 5× HP grunt-class enemies with one resistance trait each
- Test the player's loadout depth: does their build handle a Burning-resistant enemy in lane 1?
- If not, they have F4 forge break to course-correct before W2

**The BOSS (W3):**
- Spawns from right, spans all 3 lanes vertically (huge sprite)
- High HP (20× standard enemy), no advance — stays at right side of grid
- Phase 4 slice = stationary stand-in; Phase 5 = real boss AI with phase transitions
- All 3 heroes attack simultaneously
- Reaction chains stack rapidly: Elara pre-Wets, Vex finds Burning targets and crits them, Bran reserves Ult for the Leap & Slam finisher
- Reaction Chain HUD hitting 3+ regularly = chain stinger audio (`sfx_chain_stinger`) becomes the soundtrack
- HP bar of boss draws down visibly

**Climax:** Bran Ult charged → player taps → Leap & Slam crashes on boss → massive damage tick. Boss HP cracks low. Vex finds the Burning sliver target → crit Phantom Strike Ult (stub in slice, polish in Phase 5) → kill.

**Boss dies.** Screen flashes. Audio crescendo.

---

## Beat 9 — Run end: Result modal + meta-XP

> ResultModal from 2_WC P0 (reused unchanged).

**What they see:**
- "VICTORY"
- Run stats: stages cleared, reactions triggered, biggest chain (e.g., ×5), Ults used, gold earned
- Hero portraits with XP bars filling (meta layer — silent in slice, visible in Phase 5+ Wittle-meta)
- "CONTINUE" button → returns to Home

**What they feel:** satisfaction. "I want to play again with a different build."

**Observable check (playtest):** does the player tap CONTINUE → start another run within 10 seconds? PASS = retention working.

---

## Beat 10 — Subsequent worlds (post-FTUE)

> `ftue_complete = true` now. Heroes deploy at all 3 lanes from world 1 stage 1. Functions reset (each world = fresh forge).

**Loop shape:**
- Stage 1 (3 waves) — early enemies, T1 shop heavily-weighted, build foundation
- Stage 2 (3 waves) — first T2 drops, merges become possible
- Stage 3 (3 waves) — T3 starts appearing, builds maturing
- Stage 4 (3 waves) — Legendary T4 rare drops, peak power
- Stage 5 (boss, 3 waves) — climax with full kit + Ults primed

**Each session = one world ≈ 4-5 min.** Players replay for: new Function combos, better tier merges, higher chain counters, hero leveling (Phase 5+ Wittle-meta).

---

## Tonal anchors

- **Wittle/Capybara-Go visual register:** chunky portraits, bold UI, colorful elemental VFX, friendly audio
- **Brotato/Slice-&-Dice strategic flavor:** numbers visible, tooltips clear, every decision communicable
- **Transistor influence:** Function names feel like data blocks (`FIRE`, `BOUNCE`, `LEECH`) not equipment. Cards in shop have a code-block aesthetic. Sockets have a circuit-board hint.
- **Magicka rhythm:** reaction firing = playful "haha gotcha" vibe; chain stingers escalate excitement
- **NO grim dark.** Heroes should feel competent and confident, not desperate. Even dying = "tough one, try again" not "you failed".

---

## Source-of-truth references

- GDD (this doc's parent): [`01_GDD.md`](01_GDD.md)
- Implementation contract: [`superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md`](superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md)
- Phase 4 slice scope (playtest observation script): [`superpowers/specs/2026-06-13-phase4-vertical-slice-scope.md`](superpowers/specs/2026-06-13-phase4-vertical-slice-scope.md)
- Pivot rationale: [`superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`](superpowers/specs/2026-06-12-fork-a-pivot-addendum.md)
- FTUE wave-by-wave table: [function spec §13](superpowers/specs/2026-06-12-function-catalog-and-status-matrix.md#13-ftue--staged-hero-unlock-per-mit-b-revised)
