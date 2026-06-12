# Phase 4 — Vertical Slice Scope (Prototype-1)

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md) — folder SSOT. **Companion to** [`2026-06-12-function-catalog-and-status-matrix.md`](2026-06-12-function-catalog-and-status-matrix.md) (the implementation contract). This doc defines WHAT we ship, the MISSION it serves, and the FEEDBACK we collect for Phase 4 (prototype-1).

**Date:** 2026-06-13 · **Status:** DRAFT — awaiting design spec LOCK before Phase 4 branch cut.

---

## 1. Mission

The slice exists to prove **3 things**, in this priority order:

1. **The forge moment is satisfying** — players can articulate a build decision they made, and feel it pay off in combat. The Function Matrix translates from spec to felt experience.
2. **Magicka chain dopamine works** — players experience cross-hero reaction chains (Wet from Elara → Steam from Bran) AND feel the rush. Validates the spatial-grid-replaced-by-lane-corridor format still surfaces the cross-hero hook.
3. **FTUE staged unlock retains the player past the first Steam moment** — Bran-joins-at-F2 cinematic + Stage 3 first-reaction beat keeps a fresh player engaged through stage 3 (the make-or-break onboarding moment).

**If all 3 prove out:** greenlight Phase 5 full rewrite (~5-7 weeks).
**If any fail:** revisit design spec or fork B/C without sunk-cost commitment.

---

## 2. Scope (in)

Exact systems shipped in the slice. **Everything below this line is what the slice must contain to validate the mission.**

### 2.1 World structure
- **1 world only** (= the FTUE world per spec §13)
- 5 stages: stage 1 (1 wave) + stage 2 (1 wave) + stage 3 (3 waves) + stage 4 (3 waves) + stage 5 (3 waves, last wave = stationary mini-boss as boss-stand-in)
- Total = 11 waves per run
- Estimated run time ≈ 4-5 minutes

### 2.2 Heroes
- Elara (lane 1 during FTUE stages 1+2; lane 0 from stage 3 onward)
- Bran (joins at F2 cinematic via PullOverlay; lane 1)
- Vex (joins at F4 cinematic; lane 2)
- Lane assignments per spec §6
- Base weapons + hero stats per spec §6 table
- Vex's innate +20% dmg vs Burning enabled

### 2.3 Functions (6 of 12)
**Chosen to enable the 2 target reactions + cover all 3 slot types meaningfully:**
- `FIRE` (status emitter, melee — needed for Steam)
- `WATER` (status emitter, cross-lane — needed for Steam + Electrocute)
- `LIGHTNING` (status emitter, chain — needed for Electrocute)
- `AOE` (pattern — adds shape variety to forge decisions)
- `LEECH` (tactical — adds sustain build option)
- `BURST` (pattern — multi-hit reaction trigger fuel)

Each ships at **T1 only** (per spec §10.4 — tier system stubbed; 2-to-1 merge indicator shows "2/2 to upgrade" but no T2 spawning).

The other 6 (`ICE`, `EARTH`, `BEAM`, `BOUNCE`, `SEEKER`, `KNOCKBACK`) ship in Phase 5.

### 2.4 Statuses (4 of 5 + 1 aux)
- `Burning` (from FIRE)
- `Wet` (from WATER)
- `Shocked` (from LIGHTNING)
- `Bleed` (aux — Vex Ult only)

`Chilled` and `Cracked` ship in Phase 5 alongside ICE + EARTH.

### 2.5 Reactions (2 of 15)
- **Steam** (FIRE × Wet, 1.0× dmg, cross-lane splash, applies Blind) — the FTUE-first-reaction-moment target
- **Electrocute** (LIGHTNING × Wet, 2.0× dmg, cross-lane chain) — the chain-dopamine target

This pair was deliberately chosen because:
- Both consume Wet (so player learns "set Wet → fire FIRE OR LIGHTNING" pattern)
- They differ in feel (Steam = blind utility; Electrocute = dmg burst) so testing the matrix UI clarity
- They span 2 elements + 1 pattern combo so forge decisions matter

The other 13 reactions ship in Phase 5.

### 2.6 Hero Ultimates
- **Bran Leap & Slam** — fully implemented (the requested kinetic moment)
- **Elara Chain Storm** — stubbed (placeholder 1× lightning across grid, no chain logic yet)
- **Vex Phantom Strike** — stubbed (placeholder teleport + 1 hit, no Bleed application yet)
- Ult charge bar + 3-reaction accumulator working

**Why only Bran fully:** to test the "juicy combo event" hypothesis without Phase 5 polish budget on all 3.

### 2.7 Shop (full 7-item slow-populate per spec §9)
- 7 slots with Mit-D rhythm (2/3/2 across stage)
- Pity counter ≥1 Element per 2 stages
- Re-roll cost 1g
- T1-only drops (per §2.3)
- Auto-merge stub (visual indicator only — no T2 spawning)

### 2.8 Forge UI (full per spec §11)
- Bottom rail always-visible (3 hero portraits + 3 sockets + HP + Ult bars)
- Top shop rail (7 slots)
- Combat HUD between
- Reaction Chain ×N counter (E1 accepted)
- Stage Telegraph icon (§17 medium granularity)

### 2.9 Wave Telegraph (per spec §17)
- Per-stage portrait + weakness/resistance preview
- Tap during forge break

### 2.10 FTUE script + cinematics (per spec §13)
- All 5 stages of FTUE world
- Bran/Vex cinematic via reused `pull_overlay.gd`
- Tutorial overlays per stage
- `ftue_complete` flag in AccountState v3

### 2.11 Audio + VFX
- VFX for Steam + Electrocute (per spec §5 vfx_hooks — Phase 4 polish-lite, Phase 5 art-pass)
- Audio cues for Steam + Electrocute (sfx_steam_hiss + sfx_electrocute_zap)
- Chain stinger (`sfx_chain_stinger`) at 3+ reactions in 2 sec
- Bran Leap & Slam: full VFX + audio
- Other VFX = placeholder colored flashes

### 2.12 Meta layer (ported from 2_WC P0)
- AccountState v3 schema (adds `ftue_complete: bool`)
- HeroProgress unchanged (carried but not exposed in UI yet; meta-XP accrues silently)
- Home.tscn + home.gd (existing, with debug reset btn already in place)
- ResultModal at run end
- Run win/loss state machine

### 2.13 Test surfaces (per spec §14)
- Lane state distance + advance math (unit)
- Status decay + stack + per-enemy effect (unit)
- Element mediator: Steam + Electrocute dispatch (integration)
- Combat v2 tick order (integration)
- Ult controller charge accumulation (unit)
- FTUE script: stages 1+2 = 1 wave, F2 + F4 cinematics fire (integration)
- AccountState v2 → v3 migration (unit)

### 2.14 Debug observability
- F12 debug overlay (status_list, screen-x, attack resolution)
- F11 FTUE skip
- F8 reaction log scrubber

### 2.15 Mobile resolution baseline
- 1080×1920 portrait reference per spec §11.4
- Touch targets ≥44pt
- Tested on 1 phone form factor + 1 tablet for layout sanity

---

## 3. Scope (out — explicit non-goals)

**Anything in this list MUST NOT be in the slice.** If a slice contributor wants to add one, it's a Phase 5 ticket.

- All 6 remaining Functions (ICE, EARTH, BEAM, BOUNCE, SEEKER, KNOCKBACK)
- All 13 remaining reactions
- 4 of 5 statuses' polish (Chilled, Cracked, aux statuses fully)
- Tier system T2-T5 + visual flair
- Real boss AI (only stationary 5× HP mini-stand-in at stage 5 W3)
- Wittle-clone meta-progression (hero levels, skill trees, equipment, talents, stars, dailies, season pass, idle income) — separate spec doc after Phase 4
- Monetization (IAP, battle pass, cosmetics)
- 3-card in-combat module (deferred contingency per spec §20)
- Multi-world progression (only world 1 / FTUE world ships)
- Achievements, leaderboards, social features
- Save-cloud sync
- Polish-art-pass VFX (placeholder VFX only except Bran Leap)
- Polish-art-pass UI (functional UI only)
- More than 1 phone + 1 tablet device tested
- Performance optimization beyond "doesn't drop below 30 FPS on baseline device"

---

## 4. Build sequence (TDD-driven)

Per `superpowers:test-driven-development` policy + 2_WC test-harness pattern. Each numbered step ends with green tests before next step starts.

1. **AccountState v3 migration** — write test for v2 → v3 migration (1 new bool field, default false). Watch fail. Extend schema. Watch pass.
2. **`lane_state.gd` autoload** — distance + tick advance + status apply/decay + stack rules. Unit tests per §14. TDD per case.
3. **`function_data.gd` + 6 .tres Functions** — schema + per-slot behavior fields for FIRE/WATER/LIGHTNING/AOE/LEECH/BURST. Test: each resource loads + matches spec §3 cells.
4. **`status_data.gd` + 4 .tres statuses** — schema + per-enemy effects. Test: every effect applied per tick correctly.
5. **`reaction_data.gd` + 2 .tres reactions** — Steam + Electrocute. Schema + dispatch.
6. **`element_mediator.gd` autoload** — subscribes to hit_landed, dispatches reactions, emits reaction_triggered + chain_increment. Integration test: every (tag × status) input in target pair produces correct output.
7. **`combat_v2.gd`** — tick loop driving §8.3 pass order. Integration test: tick order locked.
8. **`ult_controller.gd`** — charge accumulation + Bran Leap & Slam Ult routine. Unit test: 3 reactions → +1 bar; cap at 3; no-target refund.
9. **`wave_director.gd`** — FTUE script for the 5 stages. Integration test: stages 1+2 = 1 wave each; F2 + F4 cinematic triggers fire at right indices.
10. **`shop_v2.gd`** — 7-slot Mit-D slow-populate + pity counter + auto-merge stub. Integration: rhythm matches 2/3/2 across 3-wave stage; pity guarantees ≥1 Element per 2 stages.
11. **`BattleView_v2.tscn` + `battle_view_v2.gd`** — 3-lane corridor rendering. Connect to lane_state. Visual smoke test via AUTOSHOT.
12. **`ForgePanel_v2.tscn` + `forge_panel_v2.gd`** — bottom rail (3 heroes × 3 sockets + HP + Ult bars) + top shop rail (7 slots). Drag mechanics for forge break.
13. **`WaveTelegraph.tscn`** — pre-stage preview overlay per spec §17.
14. **`ChainHUD.tscn`** — reaction chain ×N counter, top of combat HUD.
15. **`debug_overlay.gd`** — F8/F11/F12 hotkeys.
16. **VFX + audio integration** — Steam + Electrocute + Bran Ult full art-pass.
17. **End-to-end FTUE smoke test** — manual run, full 11 waves, observe FTUE script triggers.
18. **AUTOSHOT visual QC** — capture key beats: F0 deploy, stage 1 W1 (Elara solo), F2 Bran cinematic, stage 3 first Steam reaction, F4 Vex cinematic, stage 5 boss-stand-in.

Target dev time: 2-3 days of focused work. Test sweep target: 90+ tests green (~30 new + 58 from 2_WC carryover).

---

## 5. Success criteria

### 5.1 Quantitative (telemetry + observable)

| Metric | Target | Source |
|---|---|---|
| Test sweep | 100% green (90+ tests) | headless test runner |
| Frame rate floor (mid-combat, peak enemy load) | ≥30 FPS on baseline phone | Godot perf monitor |
| Tester FTUE completion rate | 4/5 testers reach stage 5 alive | playtest observation |
| First-reaction-moment recognition | 3/5 testers can name "Steam" without prompting after stage 3 | playtest interview |
| FTUE replay on debug reset | 100% (reset → FTUE plays from stage 1) | manual test |
| AUTOSHOT capture | all 6 key beat screenshots produced | manual |

### 5.2 Qualitative (interview + observation)

After each tester completes a FTUE run, ask:

1. **"What did you build, and why?"** — Pass = tester articulates a Function-socket decision they made and the reasoning.
2. **"What was the coolest moment?"** — Pass = at least 3/5 testers cite a reaction (Steam or Electrocute) or Bran's Leap & Slam Ult.
3. **"What confused you?"** — Aggregate confusion themes. Acceptable = confusion centered on UI/polish (fixable in Phase 5); failure = confusion on core mechanics (Function slots / reactions).
4. **"Would you play another run?"** — Pass = 3/5 say yes. Retention proxy.

### 5.3 Decision tree post-slice

```
ALL 3 MISSION OBJECTIVES PASS
  → Greenlight Phase 5 full rewrite (5-7 weeks)
  → Lock pitch positioning (Backpack Hero / Slice & Dice / Brotato cohort vs Wittle/AFK)
  → Begin Wittle-meta-progression spec doc
  → Begin monetization design discussion

OBJECTIVE 1 (forge) PASSES, OBJECTIVE 2 (Magicka) FAILS
  → Activate 3-card in-combat module (spec §20)
  → Re-test in Phase 4.5 patch
  → Decide Phase 5 entry after re-test

OBJECTIVE 3 (FTUE retention) FAILS
  → Redesign FTUE pacing in Phase 4.5
  → May require structural change (e.g. shorten/lengthen stages, change forced-shop curriculum)
  → Re-test before Phase 5 entry

≥2 OBJECTIVES FAIL
  → Consider fork B (smaller-scope pivot) or fork C (return to 2_WC polish)
  → Hold Phase 5 decision until forks evaluated
  → User makes final call (no sunk-cost commitment)
```

---

## 6. Failure criteria (explicit kill triggers)

The slice fails (and Phase 5 does NOT cut) if ANY of these occur:

1. **>50% testers cannot articulate any reaction by stage 3 end** — core hook fails clarity
2. **<2/5 testers complete the FTUE world alive** — difficulty curve unrecoverable
3. **Frame rate <20 FPS sustained on baseline device** — performance unfit for mobile
4. **Test sweep <90% green at slice freeze** — engineering quality below baseline
5. **2+ testers describe combat as "boring screensaver"** — addendum's own failure mode resurfacing; design needs re-think

---

## 7. Feedback collection plan

### 7.1 Tester recruitment
- **5 testers** — mix of:
  - 2× casual-mobile-RPG players (Wittle / AFK Journey / Hero Wars cohort) — target audience
  - 2× tactical-roguelike players (Brotato / Slice & Dice / Backpack Hero) — adjacent cohort
  - 1× someone unfamiliar with mobile gaming — naive observer

### 7.2 Session format (30 min per tester)
- 5 min: intro + setup ("This is a prototype. We'd like you to play 1 run. Talk out loud about what you notice.")
- 10-15 min: 1 FTUE run (with verbal think-aloud + observer notes on screen attention + struggles)
- 10-15 min: structured interview (questions in §5.2 above) + open-ended discussion

### 7.3 Data collection
- Audio recording of session (with consent)
- Observer notes (struggles, eye-tracking estimate, key emotional beats)
- Post-session 5-point Likert form:
  - "I understood why I was choosing each Function"
  - "I felt clever when reactions chained"
  - "The forge phase felt rewarding"
  - "The cinematics fit the pacing"
  - "I want to play another run"
- Open-ended response: "What's the ONE change you'd want?"

### 7.4 Synthesis
- Per-tester report (1 page each)
- Aggregate report (3-5 pages): patterns across testers, anomalies, success/failure verdict per §5.3 decision tree
- AUTOSHOT compare: tester's actual moment-of-Steam vs design intent of Steam moment

### 7.5 Timeline
- Slice freeze: end of Phase 4 dev (~day 3)
- Tester sessions: days 4-5 (1-2 testers per day)
- Synthesis report: day 6
- Decision meeting: day 7 → Phase 5 cut or revise

---

## 8. Branch + commit strategy

- Branch: `weaponforge-tftransistor/vertical-slice` off `weaponforge-tftransistor/design-spec` HEAD (after LOCK sign-off)
- Commits per Phase 4 build sequence step (§4 — 18 commits expected)
- WIP commits prefixed `WIP(phase4):` per gstack continuous-checkpoint pattern (optional)
- Final commit on slice freeze: `feat(6_WF_TFT): Phase 4 vertical slice complete — FTUE world playable, 6 Functions, 2 reactions, Bran Ult, ready for playtest`
- Tag on slice freeze: `6_WF_TFT/phase4-slice-frozen-YYYY-MM-DD`
- Push to remote on tag

---

## 9. Out-of-scope (explicit, for orientation)

If a tester asks "where's X?" during playtest, the answer is "not in this prototype":

- Multiple worlds beyond world 1
- 7+ heroes
- 6 of 12 Functions
- 13 of 15 reactions
- Boss with real AI
- Hero levels visible / equipment / talents / season pass
- IAP / monetization / shop for cosmetics
- Daily challenges / achievements
- Replay highlights
- Social features
- Localization (English only in slice)
- Tutorials beyond FTUE script
- Pause menu / settings menu polish (basic only)

---

## 10. Open questions resolved during Phase 4 (logged for Phase 5 entry)

These are anticipated questions that may emerge during slice play and need answers before Phase 5:

- Optimal `walk_speed` per enemy type (depends on feel)
- Final Bran Leap & Slam dmg multiplier (5× is starting; may tune)
- Chain HUD threshold (3 = stinger; may extend to ×5 = bigger stinger)
- Forge break duration (8-10 sec target; may tune)
- Wave 1 enemy count by stage (3 → 4 → 5 scaling target)
- Color-blind palette specific hex values

Logged in `~/.gstack/projects/6_WF_TFT/phase4-tuning-notes.md` (to be created during dev).

---

## 11. Approval

**Status: DRAFT — awaiting:**
1. Design spec REVIEW-3 LOCK sign-off (user)
2. This Phase 4 scope doc sign-off (user)

On approval of both → cut branch `weaponforge-tftransistor/vertical-slice` → begin build sequence §4.
