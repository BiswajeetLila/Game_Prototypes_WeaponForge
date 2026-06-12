> **HISTORICAL — describes the previous 2_WC craft+collect direction. Superseded 2026-06-12 by the WeaponForge TFTransistor pivot (Function Matrix + 3-lane auto-runner + Magicka reactions). Current SSOT: [`01_GDD.md`](01_GDD.md). Pivot rationale: [`superpowers/specs/2026-06-12-fork-a-pivot-addendum.md`](superpowers/specs/2026-06-12-fork-a-pivot-addendum.md).**

> **SSOT:** [01_GDD.md](01_GDD.md) — single source of truth for `2_Weaponcraft_Godot`. This doc elaborates the GDD; the Godot build in `Prototype/godot/` wins on current-state facts. `_archive/` is reference-only. Unbuilt intent here is **[ROADMAP]**.
>
> **⟳ Forward note (2026-06-12):** This records the **current/frozen build**. Beat 6's in-run hero unlock (Elara @ W3 / Vex @ W6) is **superseded for forward work** by pre-run **squad-select**; the hero-squad gacha meta is the locked direction. See [hero-squad spec §9](superpowers/specs/2026-06-11-hero-squad-meta-design.md).

# WeaponCraft (2_WC frozen) — Story Beats

> **What this is.** 8 major story beats extracted from the frozen 2_WC playtester build. Each beat = one observable narrative-or-mechanical moment the player experiences. Read this for: pitch decks, marketing trailer cuts, design-review framing, AI-render prompts.
>
> **What 2_WC is** (per the Godot build): the 15-wave prototype with 3 heroes, 3-socket forge (head/hilt/rune TFT shop + merge), part-level merge L1→L5, recipe codex + first-discovery moment, tap-portrait ultimates, bosses at W5/W10/W15, Reforge-&-Retry on wipe. This is the **current game** for `2_Weaponcraft_Godot`. (The separate Wittle-inversion fork continued as `../../5_WeaponForge_Honkai_Godot/` — out of scope here.)
>
> **Visual layout reference** — pull from the running build via the F12 screenshot helper. Vertical strip layout, top→bottom:
> 1. **Combat Arena** — hero sprite(s) left, enemy wave right (pre-wave: empty right side)
> 2. **Combat log strip** — dark brown horizontal bar (damage narration)
> 3. **Hero card** — portrait + name + HP `120/120` green bar + `ULT 0%` button + shield icon
> 4. **Anvil** — 3 horizontal slots labeled `Head / Hilt / Rune` w/ multi-tag chips (FIRE + HEAD), L`<n>` merge badge corner, stat deltas (+8 ATK, +12 ULT)
> 5. **Active recipe pills** — violet rounded rects (e.g. "Inferno" "Quickdraw") + plain-text rules below
> 6. **START WAVE** — green button w/ crossed-swords icon
> 7. **Shop** — currency badge + Reroll(2g) button + 5 horizontal slots (parts OR CONSUMABLE green frames like Heal Potion)
> 8. **Inventory** — label + `(empty)` placeholder or part-card row
>
> Wood/parchment palette w/ green primary CTA + violet recipe accent + tan slots + fire-orange element badges.
>
> **Source docs mined** (historical build specs now archived under [`../_archive/`](../_archive/) — reference-only):
> - [`01_GDD.md`](01_GDD.md) — canonical WeaponCraft design (**SSOT**)
> - `_archive/docs/superpowers/specs/2026-05-23-godot-ultra-mvp-port-design.md` (Godot port spec — what was built)
> - `_archive/docs/superpowers/specs/2026-05-25-juice-foundation-design.md` (game-feel layer)
> - `_archive/docs/superpowers/specs/2026-05-22-BASE-A1-prototype.md` (BASE-A1 reference impl)
> - The running build itself (F12 screenshot helper for layout reference)
> - `_archive/Mockup/gameplay-mockups/vid_analysis/REPORT.md` (Robotek-blueprint design heritage)
>
> Updated 2026-06-09 v2 (layout intel baked in). Status: ✅ = shipped in frozen build, 🛠 = was in-flight at freeze, 📋 = design-locked only.

---

## Beat 1 — First Forge ✅

**Hook:** *"5 parts. 3 slots. Build a weapon, send a hero."*

**Source beats:** GDD §Core-loop step 2 · ultra-MVP §verification step 2-4 · BASE-A1 0.1.0 baseline.

**Player POV.** Stage opens. Bran's tiny sprite stands solo in the **Combat Arena** strip up top — right side empty, no enemies yet. Player's eye drops to the **Hero card** ribbon: `Bran · 120/120 · ULT 0%`. Below that, the **Anvil** shows three empty slots labeled `Head / Hilt / Rune`. Below the anvil — no active-recipe pills yet (no parts equipped). **START WAVE** button is greyed because the slot-coverage check fires from the **Shop** strip: 5 part cards, **Reroll (2g)** button visible. Slot-coverage guarantee on Wave 1 ensures the shop includes ≥1 head + ≥1 hilt + ≥1 rune among the 5. Player taps a head part — auto-routes to the Head slot. Anvil ATK display updates live: `6 (base) + 8 (head) = 14`. Continues until all 3 slots fill.

**Why it matters.** First-touch comprehension. TFT-shop-as-forge metaphor lands in 30 seconds. Auto-route hides drag-drop friction. Sets up the recipe-discovery hook (next beat).

**Visual anchors.**
- Wood/parchment vertical-strip UI
- 3-slot anvil w/ explicit `Head / Hilt / Rune` labels
- Multi-tag chips on parts (slot tag + element tag — FIRE+HEAD, FIRE+HILT, FIRE+RUNE)
- L1 (default, no badge) parts
- Green "+8 ATK" stat-delta text under each part card
- Shop strip below w/ 5 slots + currency coin "4" + Reroll(2g) refresh icon
- Empty anvil slots = brown placeholders (or `EMPTY` text inside)

---

## Beat 2 — First Strike (1.1s Tick) ✅

**Hook:** *"One-second-one tick. Watch the math."*

**Source beats:** GDD §Combat pacing · ultra-MVP §Combat-tick (TICK_MS = 1100) · juice §Damage popup model.

**Player POV.** Tap **START WAVE**. Combat Arena fills — 2-3 enemies (Slime/Goblin/Skeleton) waddle in from the right. **Every 1.1 seconds = one tick.** Bran auto-attacks the leftmost enemy. **Damage number** pops in amber w/ red drop-shadow — `21` floats up + drift + fade. Enemy HP bar drops. Hit-pause freeze (0.05s) on each strike. Screen shake (3px amber on basic, 6px red-orange on crit). Enemies attack Bran on the same ticks — Hero card's HP bar shrinks. **ULT 0% → ULT 18% → ULT 35%** as damage accumulates. The **combat log** strip between arena + hero card narrates: `Bran hits Goblin for 21 (fire weak ×1.8)`.

Element multipliers visible: orange-tagged hit on fire-weak enemy = `× 1.8` → bigger amber number. Fire-resist enemy = `× 0.5` → smaller dimmed number.

**Why it matters.** Combat clarity. The 1.1s tick is the **single most important rhythm decision** — slow enough to read, fast enough to feel alive. Juice layer (shake/pause/popup/combat-log) is the difference between dry and dopaminergic.

**Visual anchors.**
- Damage popups float above enemy sprites (amber basic / red-orange crit / orange fire / cyan ice)
- Sprite hit-flash (modulate 1.8× white) on impact
- HP bars on hero card AND each enemy w/ delta-trail (red lag layer)
- ULT% percentage fills numerically in the hero-card button
- Combat-log strip scrolls one line per tick
- Enemy weak/resist badge floats on enemy sprite

---

## Beat 3 — First Discovery ✅ (THE core hook)

**Hook:** *"🔥 + ❄ = STEAMBURST. Codex 1/2."*

**Source beats:** GDD §Recipe discovery flow · ultra-MVP §Discovery-hook + step 5 · addendum 0.1.7 "Crafting Juice pivot."

**Player POV.** Mid-forge (or during combat after an equip), player slots a fire-tagged rune + an ice-tagged hilt. The **Anvil**'s active-recipe pill row lights up: a new violet pill slides in showing `💨 Steamburst`. Below the pill, plain readable text appears: *"Steamburst — 35% splash to all other alive enemies on hit"*. The combat Timer **pauses**. Full-screen overlay scales in:

```
       💨
   STEAMBURST
   DISCOVERED
   🔥 + ❄
```

Click anywhere → overlay dismisses with a scale-pop tween → Timer resumes. The 📜 **Codex** button on the HUD increments its badge: `0/2 → 1/2`. The recipe is now full-color in the codex; the other (`Inferno`) stays silhouette.

**Why it matters.** **This IS the game's core hook** per addendum 0.1.7 — the "Crafting Juice pivot" that elevated WeaponCraft from "another TFT shop game" to "Potion-Craft-flavored discovery." Many-paths-to-one-effect: Steamburst can be reached via multiple fire+ice part combos. Effect-name visible, recipe hidden = goal-known, path-unknown discovery flavor.

**Visual anchors.**
- Full-screen pause overlay (centered card on dimmed-arena backdrop)
- Recipe pattern hint icons (🔥 + ❄)
- Violet recipe pill slides into the anvil's pill row
- Plain-text rule appears below pill (e.g. "Inferno — Consecutive hits on the same target stack +12% damage, capped at 3 stacks (+36%). Switching targets resets the stack.")
- Codex badge `0/2 → 1/2` increment animation in HUD
- Codex modal (when opened) — recipes listed: full-color if discovered, silhouette if not

---

## Beat 4 — Merge Moment ✅

**Hook:** *"L1 → L2. MERGED! Same part, 1.5× stats."*

**Source beats:** GDD §Merge mechanics · ultra-MVP §Merge mechanic + acquire flow priority · `02_systems/merge_mechanic.md`.

**Player POV.** Player buys a part they already own at the same rarity. Instead of spawning a new L1 copy in inventory, the acquire-priority kicks in:
1. Merge into active hero's equipped duplicate? Yes → **MERGED!**
2. (else equip to empty slot)
3. (else merge into inventory duplicate)
4. (else fresh L1 to inventory)

Existing part card on the **Anvil** flashes gold border + `✨ MERGED! L2` pop. The corner badge updates: previously blank → now shows **`L2`** in gold (per the wireframe — L2/L3/L4/L5 are color-tiered corner badges). Stats apply the level multiplier:

| Level | Multiplier | Visible stat delta |
|---|---|---|
| L1 | ×1.00 | base "+8 ATK" |
| L2 | ×1.50 | "+12 ATK" (jump from +8) |
| L3 | ×2.10 | "+17 ATK" |
| L4 | ×2.85 | "+23 ATK" |
| L5 | ×3.70 | "+30 ATK" |

Anvil ATK display recomputes live w/ a green delta animation. Cap at L5.

**Why it matters.** Solves the gacha-dupe pain (no useless dupes). Adds a clean stat-power axis that's *visible and chase-able* — players see L4 weapons and want them. Per addendum it **replaces** the old "3→1 stash promotion" with a cleaner per-part level model.

**Visual anchors.**
- Gold border flash on the part card (0.3s pulse)
- `MERGED! L<n>` text pop above the card
- **L<n> badge in card's corner** (color-tiered: L2 yellow / L3 cyan / L4 violet / L5 gold)
- Stat number live-updates with green +delta floater
- Same-rarity-only guard — if rarity differs, falls through to fresh L1 in inventory

---

## Beat 5 — Whirlwind Ultimate ✅

**Hook:** *"Tap portrait. Bran spins. Everyone dies."*

**Source beats:** GDD §Combat agency / §Class-specific ultimates · ultra-MVP §Ult fill + step 10 · juice §`&"ult"` row (10px shake, 0.18s pause, 28pt purple popup, 🌀 prefix).

**Player POV.** Bran's `ULT %` on the **Hero card** climbs toward 100 with each tick. When `ULT 100%`, his hero card pulses with a yellow aura ring around the portrait. Player taps. **Whirlwind fires:**

- All alive enemies take `floor(atk × 3.5)` damage simultaneously
- Per-enemy hit popup: `🌀 -75` in big 28pt purple
- Screen shakes 10px for 0.35s
- Hit-pause 0.18s freezes the world
- All enemies (likely) die at once
- Wave clears

**Why it matters.** The drama beat per GDD's "hybrid auto + single-tap ultimate." Combat is otherwise auto-resolved — this is the **one player choice that matters per fight**. Per-ult juice (purple shake, 🌀 prefix popups, ult-gauge persistence across waves per addendum 0.1.4) makes it feel earned. Quickdraw recipe (visible in the wireframe as a violet pill alongside Inferno) accelerates this — "Ult gauge fills 30% faster" when fire+ult_rate are both on the weapon.

**Visual anchors.**
- Yellow aura ring around hero-card portrait at ULT 100%
- Big 🌀-prefixed purple damage pops over each enemy
- Screen-shake punch (10px / 0.35s)
- All-enemy-die cascade w/ smoke clouds rising
- ULT% bar resets to 0 — but per addendum 0.1.4, **gauge persists across waves** between fights; only `ult_used` flag resets

---

## Beat 6 — Squad Grows ✅

**Hook:** *"Elara joins at W3. Vex at W6. Three heroes, three ults."*

**Source beats:** GDD §Roster ramp · ultra-MVP §Phase 2 expansion + 3-hero §0.1.6 acquire-flow active-hero priority.

**Player POV.** Mid-Stage-1, Wave 3 trigger: combat pauses, cinematic stinger plays — Elara's portrait appears, 80-word panel introduces the silver-haired ice mage from "the frozen vale," equipped with a starter Frostcall Stave. Her **Meteor** ultimate is added — a **second Hero card** slides into view below Bran's, also with HP bar + ULT% gauge. Wave resumes. Now both heroes auto-attack on each tick.

Same again at Wave 6: Vex unlocks — purple-haired rogue from "the shadow corps" — twin violet daggers, **Shadowstep** ultimate. Three Hero cards now stacked in the vertical strip. The acquire-flow's **active-hero priority** kicks in: the *currently-tapped* hero gets the merge first when a duplicate part lands.

**Why it matters.** Roster shape pivot: 1 → 2 → 3 heroes ramps complexity gracefully. Each new hero brings a new ult-archetype (AoE / delayed-AoE / teleport-crit) so combat depth doesn't plateau. Active-hero priority in the acquire-flow (per 0.1.6) means the player's *currently-tapped* hero gets the merge first — fixing the "which hero benefits from this dupe?" decision.

**Visual anchors.**
- Mid-wave cinematic stinger (full-screen still-frame portrait + 80-word panel)
- New Hero card slides in below existing — vertical stack grows from 1 → 2 → 3
- Each new hero has their own portrait + HP bar + ULT% button + ult-name label
- New ult-archetype label visible (Meteor / Shadowstep)
- New starter weapon auto-equipped — visible immediately in that hero's anvil view

---

## Beat 7 — Boss Affinity Read ✅

**Hook:** *"Weak fire / resist ice. Read it. Counter it."*

**Source beats:** GDD §Boss-retry counter-build · ultra-MVP §Element multipliers · `03_content/boss_affinities.md`.

**Player POV.** Wave 5 hits. Boss banner slams into the Combat Arena strip:

```
   👑 SLIME KING 👑
   weak fire · resist ice
```

The two affinity icons are visible **above the boss's HP bar** throughout the fight. Player's current weapon build (let's say a heavy ice-leaning Frostcall Stave on Elara) is now **double-penalized**: ice = resist (×0.5) on this boss. Damage numbers come in tiny in the popup layer. Boss's HP barely dents. The combat-log strip narrates: `Elara hits Slime King for 11 (ice resist ×0.5)`.

Some enemies in the wave also carry weak/resist affinities (per addendum 0.1.5 "all enemies have weak/resist, not just bosses") — telegraphed by colored frames around the enemy sprite.

**Why it matters.** The READ. This is where the **crafting-as-strategy hook lives** — the GDD calls boss-retry counter-build "core hook" alongside recipe discovery. Boss affinity makes the player *think* before fighting, not just gawk at numbers. Pulls from AFK Arena elemental rock-paper-scissors + Slay-the-Spire boss adaptation.

**Visual anchors.**
- Boss-banner slam-in across Combat Arena strip
- Weak/resist rune icons next to boss's HP bar (always-visible during fight)
- Enemy-frame color tags (red border for weak, blue for resist)
- Damage numbers visibly smaller/larger based on multiplier
- Combat-log strip surfaces the multiplier inline (`×1.8` / `×0.5`)

---

## Beat 8 — Reforge & Retry ✅

**Hook:** *"You lost. Keep everything. Rebuild. Win."*

**Source beats:** GDD §Boss-retry counter-build · ultra-MVP §Wipe state + addendum-locked ReforgeRetryModal · FROZEN-doc §"15-wave + Reforge-&-Retry on boss wipe."

**Player POV.** Boss wipes the squad. Modal slides up over the dimmed Combat Arena strip:

```
   ⚔ DEFEAT
   The Slime King resists your ice.
   Rebuild your weapons and try again.

   [ Forge & Retry ]   [ Quit Stage ]
```

Player taps **Forge & Retry**. **Everything kept** — every part in the **Inventory** strip, every weapon on the Anvil, every codex pill, every L<n> merge badge. The forge re-opens with the current Shop refreshed. Player swaps Elara's ice rune for a fire rune from inventory. Buys a `p_pyro_pommel` from shop. Equips. **Inferno** pill appears in the anvil pill row (codex 2/2 discovered if not yet). Hits **START WAVE**. Boss falls in the rematch. Stage clears.

If shop refresh doesn't have the right counter — **Reroll(2g)** button is right there. If gold's tight — sell unused inventory parts back for 1g each.

**Why it matters.** The **dopamine loop** of the game. Punitive-loss-with-no-progress-loss is the casual-mobile sweet spot. Failure = a strategic puzzle, not a grind wall. This combined with **Beat 7 (read)** and **Beat 3 (discovery)** is the entire WeaponCraft hook trinity: read → counter-build → discover → win.

**Visual anchors.**
- Defeat modal overlay w/ affinity callout in plain text
- ReforgeRetryModal: 2 buttons (Forge & Retry / Quit Stage)
- Forge re-opens with all parts retained (anvil + inventory + codex untouched)
- New recipe pill appears (e.g. Inferno) when player swaps in counter-element rune
- Second-attempt victory: Stage Clear confetti + reward strip

---

## Beat dependency graph

```
[1 First Forge]
      ↓
[2 First Strike] ─── (1.1s tick combat baseline) ─── ↗ persists
      ↓
[3 First Discovery] (recipe pause-overlay, codex inc, violet pill on anvil)
      ↓
[4 Merge Moment]   (dupe buy → L<n> bump on corner badge)
      ↓
[5 Whirlwind Ult]  (gauge full → tap hero card → AoE)
      ↓
[6 Squad Grows]    (W3 Elara unlock, W6 Vex unlock — second + third Hero card slides in)
      ↓
[7 Boss Affinity Read]  (W5 / W10 / W15 boss banners w/ weak/resist icons)
      ↓ (loss path)
[8 Reforge & Retry]  (keep all → re-equip from inventory → discover counter recipe → win)
      ↑
      └─ loops back to [2] until stage clears
```

---

## Beat → marketing trailer cut (5-shot 30-second version)

1. Beat 1 (forge) — `0:00-0:06` — first impression of TFT-shop-as-crafting + 3-slot anvil
2. Beat 3 (discovery) — `0:06-0:14` — violet recipe pill slides in + full-screen Steamburst overlay, **the USP shot**
3. Beat 5 (Whirlwind) — `0:14-0:20` — tap hero card → big purple AoE damage pops
4. Beat 7 (boss read) — `0:20-0:25` — boss banner w/ affinity icons
5. Beat 8 (reforge & retry) — `0:25-0:30` — defeat → swap rune from inventory → win

---

## Beat → AI-render priority (if rendering these)

| Priority | Beat | Why |
|---|---|---|
| P0 | Beat 3 (First Discovery) | THE core hook — store hero image candidate · violet pill + overlay |
| P0 | Beat 5 (Whirlwind) | The drama beat — ad creative pillar · big purple AoE pops |
| P1 | Beat 1 (First Forge) | First impression / first 6 seconds · TFT shop + 3-slot anvil layout |
| P1 | Beat 8 (Reforge & Retry) | The retention loop visualized · defeat modal + reforge loop |
| P2 | Beat 2, 4, 6, 7 | Supporting beats |

**Render conventions when generating mockups for these beats** (per the actual frozen build wireframe):
- 9:16 portrait
- Wood/parchment palette (tan brown UI, dark-brown dividers, green primary CTA, violet recipe accent)
- 3-slot anvil ALWAYS labeled Head/Hilt/Rune (not 4-socket blueprint — that's the older Robotek-leaning mockup video pitch, see §Design heritage)
- L1-L5 corner badges on merged parts (color-tiered: L2 yellow / L3 cyan / L4 violet / L5 gold)
- Multi-tag chips per part: slot tag (HEAD/HILT/RUNE) + element tag (FIRE/ICE/PIERCE)
- Active recipe pills = violet rounded rect below anvil + plain-text rule string below
- 5-slot shop + Reroll(2g) button + currency coin
- CONSUMABLE items in green frame (e.g. Heal Potion 5g)
- Hero card = portrait + name + HP bar + ULT% percentage button (NOT a separate ult-ring around portrait)
- Combat log strip between arena and hero card

---

## What this beat list deliberately omits

**Things in the GDD but NOT in the frozen build** (per FROZEN-doc):
- Forge Wheel slot-machine pulls (weapon-gacha — design-only)
- Catalyst compounds (Wittle-inversion-fork territory, lives in 5_WF)
- Hot Paladin cinematic (5_WF)
- Hero missions / portrait evolution / signature arcs (5_WF)
- AFK idle accrual + claim (design-only)
- Stamina-gated stage entry (design-only)
- Chapter map node-UI (design-only)
- Battle pass / cosmetics / gacha banners (design-only)

---

## Design heritage — the Robotek-blueprint pitch (2026-05-22 mockup videos)

> Context — not part of the frozen build, but worth knowing.

The earliest mockups (now in `_archive/Mockup/gameplay-mockups/`: `wf_mockup_1.png`, `Vid_wf_mockup_1.mp4`, `Vid_wf_mockup_2.mp4`, dated 2026-05-22) pitched a **different crafting model** that informed the GDD's "Robotek + TFT fusion" framing but **never shipped** in the frozen build:

| Mockup video pitch | Frozen build today |
|---|---|
| Pre-shaped weapon **blueprint** w/ 3-4 empty round socket holes (Iron Longsword / Mage Staff / Bow blueprints) | Generic 3-slot anvil w/ Head/Hilt/Rune labels |
| Multi-weapon-type **left-tab filter** (Sword / Axe / Dagger / Staff) | Single weapon type per hero |
| Turn-based **"TURN N/5"** counter + END TURN button | Real-time 1.1s tick |
| **CRAFT & DEPLOY** single-verb button (craft → fire weapon → hero auto-attacks in one tap) | Separate equip + START WAVE verbs |
| Owned/required **fraction badges** on runes (e.g. "49/15") | Single owned-count number |
| Always-visible **split-screen** combat ↔ forge | Modal-style forge ↔ combat |
| HUGE yellow damage numbers (9101 peak) | Modest amber popups per juice config |
| Painterly Castle-Crashers / Wittle-Defender style | Programmer/Kenney sprite art in frozen build |

**Why those changes were made.** Per addendum 0.1.7 the "Crafting Juice pivot" reframed the core hook from "Robotek turn-based weapon-craft-and-deploy" to "Potion-Craft-flavored recipe discovery." The 3-slot anvil + recipe-pill UI is the materialization of that pivot. The blueprint-w/-sockets variant remains conceptually interesting (and may inspire a Phase 2 visual refresh) but is not what 2_WC plays today.

**If commissioning new art** for marketing/pitch: render the **frozen-build layout** (Head/Hilt/Rune anvil + violet recipe pills + 5-slot shop) — NOT the blueprint-w/-sockets variant. The mockup videos are useful for *style* reference (painterly 5-6-head register, warm forge palette, crowd silhouettes, banners + torches arena) but the *UI* should match the actual playable build.

Full mockup-video analysis: `_archive/Mockup/gameplay-mockups/vid_analysis/REPORT.md`.

---

*Pair this with [`01_GDD.md`](01_GDD.md) (SSOT) for full system design + `_archive/docs/superpowers/specs/2026-05-23-godot-ultra-mvp-port-design.md` for the build-as-shipped reference + `_archive/Mockup/gameplay-mockups/vid_analysis/REPORT.md` for the abandoned Robotek-blueprint heritage.*
