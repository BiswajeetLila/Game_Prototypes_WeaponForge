# WeaponForge — Story Beats (Condensed)

> Condensed view of `prototype-screen-beats.md` — collapsed from ~60 screen-states into **9 major story beats** that map the player's emotional + design journey from cold boot to exit-gate verdict.
>
> Each beat = a narrative chapter the player remembers, NOT a screen-state. Use the canonical doc for screen-level mockup work; use this doc for pitch deck, narrative design, marketing trailer cuts, and exit-gate scoring.
>
> Updated 2026-06-09. Status mix per beat: ✅ shipped · 🛠 in-flight · 📋 queued · 🧪 proposed.

---

## Beat 1 — Awakening 🛠 (mostly ✅)

**Hook:** *"Three heroes. One ember. One pull."*

**Spans canonical beats:** 1.1 cold boot · 1.2 warm boot · 2.1 home fresh · 2.4 wheel spin · 2.5 pull reveal new weapon · 2.7 star-up.

**Player POV.** Splash → forge interior fades in → squad of three (Bran fire, Elara ice, Vex electric) sits in a warm anvil-lit room. 5 Ember icon glows in the corner. Player taps the forge wheel. Reel slams. Gold legendary frame. New weapon flies out. Equip on Bran. Heart-rate +5bpm.

**Why it matters.** First-touch dopamine. Gacha verb established (you pull *weapons*, not heroes). Hero identity locked before any combat — players already feel the cast. Sets the emotional tone for every Catalyst reveal that comes later.

**Status.** Mostly ✅ (boot + home + pull all live). 📋 left: spin cinematic (≤0.6s anvil-strike reel) — currently reveals instantly.

---

## Beat 2 — First Trial ✅

**Hook:** *"Read the affinities. Draft your build. Drop the boss."*

**Spans:** 3.1 briefing (S1 teaching mirror) · 4.1 stage banner · 4.3 wave mid-fight · 4.5 forge draft 3-card · 4.7 fly-to-pip · 4.8 ult glow · 4.9 ult firing · 5.1 boss banner · 5.2 Slime King heal mechanic · 6.1 stage clear.

**Player POV.** Briefing shows Slime King weak/resist. Three heroes face the wave. Numbers pop. Kill-meter fills. Combat freezes — DRAFT modal — pick a card — fly-to-pip animation — combat resumes hotter than before. Boss banner. Heal-tick telegraph. Burn through HP. Stage clear confetti.

**Why it matters.** Core loop verb chain in one beat: *plan → fight → draft → boss → win*. Wittle-inversion playable proof. Every later stage is a remix of this beat. Make-or-break for retention — if the player can't articulate "what just happened" after this, the prototype fails.

**Status.** ✅ end-to-end. The shipped Stage-D prototype IS this beat.

---

## Beat 3 — The Squad Grows ✅

**Hook:** *"You don't recruit heroes. They find you."*

**Spans:** 7.1 Elara unlock cinematic (S1 W3) · 7.2 Vex unlock cinematic (S1 W6).

**Player POV.** Mid-Stage-1 wave, screen freezes. Portrait splash: *"Elara joins the squad."* Brief 80-word panel — frozen vale, ice mage, story stinger. Auto-equipped Frostcall Stave. Continue → back to wave, now three heroes auto-fighting. Three waves later, Vex slides in the same way.

**Why it matters.** Story-locked roster reveal moment (Honkai-style narrative beats, not Wittle's identical pulls). Each hero has a story — this is where the player first feels that. The doubled squad changes combat shape, sets up Catalyst expectation.

**Status.** ✅ shipped. Catalyst-build will adjust starters to non-elemental basics so Beat 4 reveal lands clean.

---

## Beat 4 — The Catalyst Spark 🛠

**Hook:** *"Two elements. One sigil. A new rule of war."*

**Spans:** 9.1 first reveal · 9.2 codex panel · 9.3 in-battle chip · 3.3 briefing-with-catalyst · 4.2 catalyst-active stage banner.

**Player POV.** Around stage 4-5, the scripted Ice-Elara pull lands. Player equips. Popup fires: **FIRESTORM (🔥+❄) +20% squad ATK** — codex 1/10. Next stage's briefing now shows the Catalyst panel. In combat a HUD chip persists. The numbers feel different.

**Why it matters.** The system reveal. Compounds are the strategic depth that separates WeaponForge from "another auto-battler." Codex hooks completionists. The reveal moment is a **make-or-break for ad-frame readability** (first 3s of any creative — see FM-17 trademark check on the name).

**Status.** 🛠 in-flight on `forgeloop/catalyst-element-pairs`. cap-1 alphabetical winner shipped; no-cap stacking + codex tracker queued.

---

## Beat 5 — The Paladin Descends 📋 (make-or-break)

**Hook:** *"Lance from above. The squad becomes four."*

**Spans:** 7.3 Hot Paladin scripted-defeat entry (S2 W3 mid-fight).

**Player POV.** Stage 2 wave 3. Squad fights as normal. Wave-mid trigger: ☄ lance crashes to centre stage, dust shockwave radials outward. Half-realistic anime warrior-priestess descends — blonde braid, storm-blue plate, two-handed greatsword planted point-down. One dialogue line. Her ult-override wipes the wave. Roster unlock popup: *"4-hero deploy slot opens. Retry Stage 2?"*

**Why it matters.** FM-8 hero-bond probe — first test of *"do players feel emotionally moved by a hero arrival?"* If they don't, the 7-hero locked-roster premise is broken. This beat is the trailer's emotional peak (D1 video Beat 5 in the marketing cut renders it as a warm-dawn rescue instead — different framing, same character moment).

**Status.** 📋 queued. P0 make-or-break for both narrative AND marketing creative.

---

## Beat 6 — Setback and Resolve ✅

**Hook:** *"You lost. No retry modal. Adjust and come back."*

**Spans:** 6.2 squad-wipe → home loadout · 6.3 run-state reset.

**Player POV.** Boss overwhelms. Defeat screen — no Reforge-Retry modal (removed, sidesteps FM-14). Return to Home with a soft diagnostic strip: *"Slime King resisted your ice — try fire."* Stage NOT incremented. Player swaps a weapon, replays. Lower friction, more agency, no perma-loss feel.

**Why it matters.** Failure design. Casual-mobile players bounce on punitive losses; we sidestep by making the player feel taught, not punished. Confirms wittle-inversion's "you choose your build outside combat" loop — every loss = a loadout-pivot decision, not a grind wall.

**Status.** ✅ shipped.

---

## Beat 7 — Elara's Mission 📋

**Hook:** *"She felt something. Now her story unlocks."*

**Spans:** 8.1 mission trigger (crit-kill boss) · 8.2 spark-chain combat · 8.3 small-B talent tree · 8.4 mission complete · 11.1/11.2 quest log + complete popups.

**Player POV.** First time Elara crit-kills a stage boss, a cutscene fires. 200-word narrative panel — *"I felt something. Something… more."* Quest enters log. Next runs: chain-lightning visuals on Elara's crits. Talent tree opens — 3-node mini-tree (Meteor → Shower → Storm), gem-spend per node. Final cutscene: *"It's part of me now."* Meteor unlocked permanently. FM-8 datapoint recorded.

**Why it matters.** Story-locked roster proof at full depth. Each of 7 heroes gets this arc (3 quests × 7 = 21 launch quests). Reveals the depth-per-character that distinguishes WeaponForge from Wittle's flat roster. Talent gems become a meaningful spend sink.

**Status.** 📋 queued. Elara is the prototype canary; if she lands, the other 6 heroes' quest content scales linearly.

---

## Beat 8 — Master Smith's Forge 📋

**Hook:** *"Stage 10. The forge goes deeper."*

**Spans:** 7.4 Master Smith cinematic · 10.1 Phase 1 wheel · 10.2 part-pull target select · 10.3 part-pull reveal + Forge Math.

**Player POV.** Stage 10 clear. Cinematic stinger — old smith pulls back a drape to reveal a second slot-machine reel. New verb: **Part Pull** (150💎, pick head/hilt/rune). Reveal shows an Epic part + Forge Math diff (+50% / +1 instant / +2 ½×2 / +3 ⅓×3 / +4 banked). The crafting depth Wittle never had.

**Why it matters.** Stage 10 = the second hook. First hook (Beat 4 Catalyst) is the *combat-meta* spark; second hook (Master Smith) is the *forge-meta* spark. Wittle's hook curve flatlines after Stage 5 — ours has a designed peak at S10 to carry into the deeper roadmap.

**Status.** 📋 queued. Phase 0 forge wheel (one weapon-pull verb) ships before this; Phase 1 is the post-S10 unlock.

---

## Beat 9 — The Verdict 📋

**Hook:** *"Did we earn the next chapter?"*

**Spans:** 12.1 Bran 5-tier portrait eval (20 Honkai players) · 12.2 Catalyst trademark check · 13.1 10h internal log · 13.2 D1 retention panel · 13.3 ad CPI test · 13.4 exit decision.

**Player POV.** N/A — this beat is the **team's** beat, not the player's. External survey on portrait evolution, USPTO/EUIPO trademark check on "Catalyst" (fallback to Alloy / Confluence / Reaction / Harmonic), 10h self-play log, 5-10 player D1 retention panel, optional $100-200 ad CPI test against Wittle benchmark ($3.50).

**Why it matters.** Pre-mortem gates. Green = Phase 2 (monetization, content scale-up, full 7-hero quest content). Red = pivot or shelve. Yellow = 5-day iteration on weakest gate.

**Status.** 📋 queued — all non-code. Belongs in the schedule once Beats 1-8 are playable end-to-end.

---

## Beat dependency graph

```
[1 Awakening] → [2 First Trial] ↔ [6 Setback] (loops as needed)
                      ↓
                [3 Squad Grows] (cross-cuts inside Beat 2 at S1 W3 / S1 W6)
                      ↓
                [4 Catalyst Spark] (fires when Beat 1 pull #3 lands ice on Elara)
                      ↓
                [5 The Paladin Descends] (S2 W3 mid-fight, once per save)
                      ↓
                [7 Elara's Mission] (first crit-kill boss with Elara)
                      ↓
                [8 Master Smith's Forge] (S10 cinematic + Phase 1 unlock)
                      ↓
                [9 The Verdict] (team gate, post-prototype playtest)
```

## Beat → marketing creative map

| Beat | Trailer use | Ad-creative pillar |
|---|---|---|
| 1 Awakening | cold open + Forge Wheel jackpot at 0:22-0:34 (D1 video Beat 4) | gacha-pull dopamine moment |
| 2 First Trial | combat read 0:04-0:12 + draft transform 0:12-0:22 (D1 Beats 1+2) | core-loop verb chain |
| 4 Catalyst Spark | first reveal — codex unlock | meta-strategy hook |
| 5 The Paladin Descends | trailer Beat 5 emotional peak (warm-dawn rescue variant) | hero-bond moment, FM-8 |
| 8 Master Smith's Forge | extended cut Beat 4.5 (75-90s version) | depth hook |

## Beat → exit gate map

| Beat | Gate signal |
|---|---|
| 5 The Paladin Descends | FM-8 hero-bond probe — ≥6/6 score required |
| 4 Catalyst Spark + 7 Elara's Mission | D1 retention panel ≥35% (Beat 9 measures this) |
| 1 Awakening + 2 First Trial | first-3-second ad-frame readability (Beat 9 ad CPI test, target ≤$2.80) |

---

*Pair this with the canonical screen-by-screen storyboard for mockup-level work. Source: `prototype-screen-beats.md`. Beat IDs trace back via the "Spans" line on each beat above.*
