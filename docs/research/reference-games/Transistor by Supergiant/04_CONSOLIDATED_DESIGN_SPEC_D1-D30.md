# Transistor — Consolidated Design Specification (D1–D30), Weapon-Focused

**Compiled:** 2026-06-15 · **Subject:** *Transistor* (Supergiant Games, 2014; PC / PS4 / iOS) · **Focus:** the weapon (the Transistor) and its Function system, set in the full game's core loop, progression, and player experience.

### Sourcing protocol
Every substantive claim is tagged:
- **[GS: …]** = *Genuine Source* — stated in the gathered materials. The tag names the source (slug in `Web Sources/`, a video frame, the Steam dataset, or one of the two prior research dossiers in this folder).
- **[ASSUMED]** = a logical inference or framing not stated verbatim in a source.

**Source corpus:** 40 word-for-word web captures in [`Web Sources/`](Web Sources/) (Wikipedia, Fandom ×2 wikis, IGN, gamedeveloper.com/Amir Rao, 9 Reddit threads, 4 Steam community pages, multiple blog/review essays); two analyzed videos — [`QLYkM4YZEMc`](Video Analysis/QLYkM4YZEMc/VIDEO_BREAKDOWN.md) (2014 mechanics tutorial, frame-verified UI) and [`_hhqPQH01Zw`](01_VIDEO_BREAKDOWN.md) (2025 retrospective); 600 Steam reviews + lifetime stats in [`Reviews/`](Reviews/); and the two user dossiers (`Technical Synthesis…`, `Comprehensive Game Design Specification…`).

> **Framing caveat on "D1–D30":** Transistor is a **~4–6-hour, linear, single-player premium game with no daily-login, energy, or live-service systems** [GS: 01-wikipedia; _hhqPQH01Zw]. It has **no in-game "days."** The "D1–D30" structure below is an **[ASSUMED]** analytics lens imposed by the research template: D1–D7 ≈ a first playthrough; D8–D30 ≈ completion, New Game Plus ("Recursion"), and mastery. Retention here means *replay*, not daily return.

---

## 1. Executive summary

Transistor is an isometric action-RPG in the digital city of Cloudbank. You play **Red**, a singer whose voice is stolen; she wields **the Transistor**, a great weapon that has absorbed the consciousness (and voice) of her companion, who narrates [GS: 01-wikipedia; dossier-Comprehensive]. The game's signature is its **weapon system**: there is **no basic attack** [GS: _hhqPQH01Zw] — all power comes from **16 Functions** that can each be slotted three ways (Active / Upgrade / Passive), gated by a **Memory (MEM)** budget, and a hybrid combat mode (**Turn()**) that freezes time to plan a burst of queued actions [GS: 07-fandom-functions; 15-fandom-combat]. Lifetime Steam reception is **"Very Positive," 29,271 👍 / 1,882 👎 of 31,153 (~94%)** [GS: Reviews/steam_237930_summary].

---

## 2. How the game works (premise & frame)

- **Genre / view:** isometric action-RPG [GS: 01-wikipedia].
- **Setting:** Cloudbank, a digital city run by **direct democracy** — citizens vote on everything from the weather to the color of the sky [GS: dossier-Comprehensive; 01-wikipedia]. The city is literally code; this justifies the programming metaphor throughout [GS: 03-reddit-programming-explains; dossier-Technical].
- **Protagonist & weapon:** Red; the **Transistor** holds her companion's Trace/voice and is the **narrator** [GS: 01-wikipedia; dossier-Comprehensive].
- **Antagonists:** **the Camerata** (Grant & Asher Kendrell, Sybil Reisz, Royce Bracket) [GS: dossier-Comprehensive; 07-fandom-functions], and **the Process** — a legion of semi-autonomous robots that, once the Camerata lose control of the Transistor, deconstruct the city back into building blocks [GS: 25-fandom-the-process].
- **Length / shape:** short and linear, ~4–6 h first run [GS: _hhqPQH01Zw; Reviews]. **New Game Plus = "Recursion"** [GS: 07-fandom-functions].

---

## 3. The core loop

```
Explore Cloudbank (isometric) → enter a cordoned combat arena → fight the Process
   using real-time + Turn() planning → defeat units → COLLECT their Cells before they
   respawn → clear arena → reach an ACCESS POINT → respec Functions / level up /
   read unlocked lore / toggle Limiters → continue the linear story
```
[GS: 15-fandom-combat; 24-steam-plot; QLYkM4YZEMc; _hhqPQH01Zw]

- **Two combat modes** [GS: 15-fandom-combat; QLYkM4YZEMc transcript]:
  - **Real-time ("free mode"):** Functions have a use-time and a cooldown; enemies move and attack freely.
  - **Turn():** freeze time, queue movement + attacks against a planning budget, execute in an accelerated burst; enemies are effectively frozen during planning.
- **The Cell-collection sub-loop:** a defeated unit collapses to a **Cell**; if you don't physically reach it before a countdown, **it regenerates at full health** [GS: dossier-Comprehensive; 25-fandom-the-process]. This forces you to *path toward kills*, not snipe safely [GS: dossier-Technical].
- **Access Points** are the save/respec terminals where the loadout, leveling, lore, and Limiters are managed [GS: 07-fandom-functions; f_00125 in _hhqPQH01Zw].

---

## 4. The weapon — the Function system (the heart of the design)

### 4.1 First principles
- **16 equippable Functions**, named like code calls (`Crash()`, `Ping()`…), each derived from the **Trace** of a named Cloudbank citizen [GS: 07-fandom-functions]. Plus **4 unequippable** Functions accessible only in special circumstances: `Check()`, `Bark()`, `Sic()`, `Kill()` [GS: 07-fandom-functions].
- **`Turn()` is itself the one innate Function** of the weapon — not derived from a Trace; any wielder of any Transistor can use it [GS: 07-fandom-functions].
- **`Crash()` and `Breach()` are preinstalled** (Red's own Trace and her companion "Unknown's") [GS: 07-fandom-functions].
- **No vertical investment:** unlike Bastion, you cannot power-level a favorite Function; the system "concerns itself with pairs and trios and the relationship between them" [GS: 05-gamedeveloper/Amir Rao].

### 4.2 The three-slot architecture (authoritative)
[GS: 07-fandom-functions; verbatim-confirmed on the 2014 UI in QLYkM4YZEMc frames f_00012/24/36/86]

- **Active slot** — the Function's primary power. **Up to 4 Active slots.** Duplicates allowed across Active slots (in Recursion).
- **Upgrade slot** — modifies the Active Function it's attached to. **Up to 8 Upgrade slots (2 per Active).** No duplicate Upgrade on the same Active.
- **Passive slot** — a persistent/triggered buff to Red. **Up to 4 Passive slots.** No duplicates.

> **Slot-count reconciliation — IMPORTANT:** max slots = **4 + 8 + 4 = 16** [GS: 07-fandom-functions]. The QLYkM4YZEMc narrator says *"24 available slots,"* but the on-screen **"24 of 24"** is the **MEM** value of that New Game Plus save, **not** a slot count [GS: f_00012; cross-checked vs 07-fandom-functions]. Max **MEM = 32** (achievement "Memory() — Unlock 32 MEM") [GS: 07-fandom-functions]. **[ASSUMED]** the narrator conflated "slots" with the MEM number on screen.
- **Start state:** 3 Active slots, 1 Upgrade slot each, **0 Passive slots** [GS: 07-fandom-functions].

### 4.3 Memory (MEM) economy
- Every installed Function (in any slot) consumes MEM; total MEM grows with **User Level** [GS: 07-fandom-functions; 04.5]. A Function shows greyed-out if MEM is full [GS: QLYkM4YZEMc f_00012].
- High-value combos are expensive: achievement "**Stack()** — create a Function combination requiring 12 MEM" rewards a single big build [GS: 07-fandom-functions].

### 4.4 Full Function reference
Slot effects below are **[GS]** — verbatim from the in-game UI (QLYkM4YZEMc frames) and the wikis [GS: 07/10-fandom-functions; 08-ign-functions]. **MEM costs and exact percentages are [GS: dossier-Comprehensive], sourced there from the wikis; not independently re-measured in-engine for this doc.**

| Function | MEM | Trace (citizen) | Active | Upgrade | Passive |
|---|:--:|---|---|---|---|
| **Crash()** | 1 | Red | Harm/disrupt nearby Targets, expose vulnerabilities | Cause most Functions to stun/disrupt | Damage resistance (~25%) + immunity to slowing |
| **Ping()** | 1 | Henter Jallaford | Rapid kinetic charges in a line | Reduce Turn() planning cost + charge time | Move 200% farther in one Turn() |
| **Mask()** | 1 | Shomar Shasberg | Conceal; amplify next action 200% | Raise backstab potency | Conceal + speed boost after a kill |
| **Get()** | 1 | Bailey Gilande | Magnetic pull (stronger at distance) | Make Functions pull Targets out of position | Draw in Cells faster/farther |
| **Spark()** | 2 | Lillian Platt | Unstable shells that split into explosive particles | Split/subdivide most Functions | Spawn a Copy when attacked, diverting Targets |
| **Bounce()** | 2 | Niola Chein | Ricocheting bolt jumps Target to Target | Add chain-reactive effect | Deflecting shield negates damage to User |
| **Switch()** | 2 | Farrah Yon-Dale | Alter a Target's allegiance (charm) | Integrate allegiance-altering into Functions | Spawn friendly Badcell when retrieving Cells |
| **Purge()** | 2 | Maximilias Darzi | Seeking parasite dismantles from within (DoT) | Apply corruption/slow | Retaliate ~10 dmg when struck |
| **Breach()** | 3 | Unknown (companion) | Pierce Targets across long distances | Raise range + velocity | +120% planning potential (longer Turn() bar) |
| **Jaunt()** | 3 | Preston Moyle | Transport to a nearby location (dash) | Allow Functions during Turn() recovery | Recover faster after Turn() (+125%) |
| **Load()** | 3 | Wave Tennegan | Place a volatile Packet; strike to detonate | Increase AoE of most Functions | Auto-generate Packets (~10s) |
| **Flood()** | 3 | Royce Bracket | Disintegrating storm sphere (lingering) | Add lingering destructive trails | Regen HP when not in Turn() recovery |
| **Help()** | 4 | Sybil Reisz | Summon a Friend (Luna the Fetch) | 50% chance Cells don't spawn on kill | 25% chance SuperUser in Turn() |
| **Cull()** | 4 | Olmarq | Strike Targets upward, massive force | Raise kinetic impact / duration | 150 dmg on contact during Turn() |
| **Tap()** | 4 | Grant Kendrell | Siphon life from Targets in an area | Apply lifesteal to most Functions | +150% total life |
| **Void()** | 4 | Asher Kendrell | Stackable debuff to defense + attack | Augment potency/effects | +125% base damage |

*Combinatorial scale: research cites ~**22.28 trillion** configurations [GS: dossier-Technical]; "thousands of unique combinations" per the designer [GS: 05-gamedeveloper/Amir Rao].*

### 4.5 Function Files = lore gated by mechanical variety
Each Function has a **Function File** (the donor citizen's biography). The three text sections decrypt **only after that Function is used in each of the three slot types at least once** [GS: 07-fandom-functions]. → variety is rewarded with *story*. Achievements: Search()/Find()/Reveal() for inspecting 5/10/all Files [GS: 07-fandom-functions].

---

## 5. Turn() — mechanics in depth

[GS: 20-fandom-turn; 15-fandom-combat unless noted]
- **Planning budget = 100 points.** Movement and each Function consume points (e.g. `Crash()` = 20 pts → 5 uses). Pre-position before Turn() to save points.
- **Overload exception:** with even ~1 point left you may queue **one final Function regardless of cost** — but it **increases recovery time**.
- **Recovery lockout:** after execution, all Functions are disabled **except `Jaunt()`, `Mask()`, and any Function carrying `Jaunt()`** until Turn() recharges [GS: 15-fandom-combat]. (The QLYkM4YZEMc tutorial demos exactly this with Jaunt [GS: f_00086].)
- **Information shown while planning:** blast radius, max range, damage, and risk of a target moving; hold a Function to aim direction while stationary.
- **Estimation, not guarantee:** the Process can still move during execution — e.g. a **Young Lady teleports after the first hit** [GS: 20-fandom-turn].
- **Tips that are really design rules:** don't rush (no planning timer); end Turn() *away* from strong enemies; **unused planning time recharges Turn() faster**; `Breach()`-passive lengthens the bar, `Ping()`-passive lengthens walk distance [GS: 20-fandom-turn].

### 5.1 The (hidden) combo / multiplier system
Not explained in-game [GS: 15-fandom-combat]:
- **Backstab** ×1.5 (hit from behind) · **Unmask** (`Mask()`) ×2 on next action · **Crashed** (vulnerable) ×1.5 · **Void()** ×1.75, **stacks up to 3×**.
- **Multipliers multiply.** Worked example [GS: 15-fandom-combat]: Backstab `Crash()` (75 dmg) → `Mask()` → `Breach()` = **450** (100 base × 1.5 backstab × 1.5 crashed × 2 unmask). Turn() is what makes landing the full chain reliable.

---

## 6. Combat & enemies (the Process)

- **Roster** [GS: 25-fandom-the-process; dossier-Comprehensive]: Cell, Badcell, Creep, Jerk, Young Lady, Weed, Cheerleader, Clucker, Snapshot, Fetch, Man, Operator.
- **Versioning 1.0 → 3.0:** units evolve new abilities as the game progresses [GS: dossier-Technical/Comprehensive]. Notably: **Clucker 3.0 disrupts Turn()** (leaves a grid that force-ends your Turn if you enter it); **Snapshot 3.0 clouds the Turn() screen**; **Young Lady teleports when hit** [GS: 20-fandom-turn; dossier-Comprehensive].
- **Cell lifecycle:** kill → Cell → collect or it **regenerates**; uncollected Cells can become aggressive **Badcells** [GS: dossier-Comprehensive; 25-fandom-the-process].
- **AI model [ASSUMED/secondary]:** dossier-Technical models units as a weighted-random finite-state machine (Unaware → Investigate → Aggressive with range-conditional behaviors); presented as analysis, not first-party documentation [GS: dossier-Technical; 38-reddit-gamedesign; 39-kokkugames].

---

## 7. Progression systems

- **User Level (XP):** leveling raises **MEM capacity**, unlocks **more slots** (Upgrade + Passive), grants **new Functions**, and (in Recursion) **duplicate Functions** [GS: 07-fandom-functions]. Achievements bound the ceiling: **User() = unlock every Upgrade + Passive slot**; **Memory() = 32 MEM** [GS: 07-fandom-functions].
- **Function acquisition** is tied to story progress — Functions are integrated from citizens' Traces as Red advances [GS: 07-fandom-functions; dossier-Comprehensive]. **[ASSUMED]** exact unlock order varies; the spine is: start with Crash()+Breach(), gain Bounce()/Mask() early (Sybil/Empty Set arc), accumulate the rest across the four districts [GS: dossier-Comprehensive D1–D7].
- **"Slow death" (Function Overload)** doubles as progression pressure (see §9).
- **Limiters** convert difficulty into an XP multiplier (see §8).

---

## 8. Limiters — opt-in difficulty for reward

[GS: 35-fandom-limiters; 36-fandom-archive-limiters; QLYkM4YZEMc f_00050; _hhqPQH01Zw f_00190]
- **Unlock at User Level 4.** Each Limiter buffs the Process; in return the User earns **bonus XP**. **Max all-10 bonus = 32%** (confirmed on-screen "User Level Bonus Total: 32%" with 10 active) [GS: 35-fandom-limiters; f_00190].
- Fiction: Limiters are Royce Bracket's **safeguards on the Process**; activating one *disables* a safeguard [GS: 35-fandom-limiters].

| Limiter | Effect when active | XP |
|---|---|:--:|
| Superiority | Process spawn in greater numbers | 6% |
| Efficiency | Process deal twice as much damage | 4% |
| Responsibility | Lose 6+ MEM | 4% |
| Priority | Overload more Functions at once; recover only one per Access Point | 4% |
| Permanence | Uninstalling Functions at Access Points overloads them | 4% |
| Abundance | Process sometimes spawn twin Cells | 2% |
| Initiative | Cells respawn much faster | 2% |
| Resilience | Process spawn shielded Cells | 2% |
| Concentration | Turn() no longer auto-activates at low health | 2% |
| Legacy | Process spawn corrupted (damaging) Cells | 2% |

- **Achievements:** Bet() (5 encounters w/ 1+ Limiter), Dare() (5+ Limiters), **Risk() (all 10)** [GS: 35-fandom-limiters].

---

## 9. The "slow death" — failure as a design engine

[GS: 05-gamedeveloper/Amir Rao; 07-fandom-functions]
- On health depletion, the **highest-MEM Active Function overloads** (disabled). If that would leave Red unable to deal damage, the **next-highest** overloads instead. The slot about to overload is shown by glowing wires to the health gauge.
- Overloaded Functions are **restored after visiting two previously-unvisited Access Points** (only **one at a time** under the *Priority* Limiter).
- Lose **all** Active-bar Functions (up to 4) → reload last Access Point.
- **Designer intent:** this is the "shuffling" mechanic that replaced an abandoned card-draw/randomness model; it makes players try **new combinations** under pressure — and they often **keep** the new combo afterward [GS: 05-gamedeveloper/Amir Rao]. It also grants up to **three attempts** per encounter and induces a **more methodical** style.

---

## 10. What unlocks when — the D1–D30 experience [ASSUMED lens; beats are GS]

> Reminder: no in-game days. Mapping is **[ASSUMED]**; the story beats are **[GS: dossier-Comprehensive; 06-fandom-the-story; 24/30-steam plot]**.

**D1–D7 — first playthrough (~4–6 h):**
- *Opening (Goldwalk):* acquire the Transistor from the dead man whose voice becomes the narrator; fight first **Creeps**; learn real-time + the first Function [GS: dossier-Comprehensive].
- *Early arc (Empty Set / Sybil Reisz):* unlock **Bounce()** and **Mask()**; learn Red's voice was sealed in the weapon [GS: dossier-Comprehensive]. Hit **User Level 4 → Limiters unlock** [GS: 35-fandom-limiters].
- *Mid (Highrise / "The Spine of the World"):* a giant Processed creature slurs the Transistor's narration (simulated system failure) [GS: dossier-Comprehensive].
- *Late (Bracket Towers; Fairview / the Cradle):* discover Grant & Asher's fates; final duel with **Royce Bracket**, who wields his own Transistor [GS: dossier-Comprehensive].
- Throughout: steadily gain Functions, MEM, slots; decrypt Function Files by varying slot use; optional **Backdoor "Tests"** (challenge rooms) teach combos [GS: 07-fandom-functions; dossier-Technical].
- *Ending:* Red rejoins her companion inside the Transistor ("the Country"); short, emotionally resonant close [GS: dossier-Comprehensive; Reviews].

**D8–D30 — completion, Recursion & mastery (replay-driven):**
- **Recursion (NG+)** retains progress and adds **duplicate Functions** — up to **3 copies** of one Function (one each as Active/Upgrade/Passive), enabling ~**32-MEM kits** (e.g. `Void()` upgrading `Void()`) [GS: 07-fandom-functions; dossier-Comprehensive]. Achievement **Self()** = upgrade a Function with a copy of itself (Recursion-only) [GS: 07-fandom-functions].
- Mastery goals: all Function Files (Reveal()), 32 MEM (Memory()), 12-MEM combo (Stack()), and the **all-10-Limiter Risk()** run [GS: 07/35-fandom].

---

## 11. What players like & why they replay

[GS: Reviews/steam_237930_* — 600 reviews sampled, ~94% lifetime positive; keyword sweep = 376 sentiment hits]

**Most-praised, in order of prominence:**
1. **Music / Darren Korb soundtrack** — near-universal; *"darren korb is a visionary and a genius"*; *"go listen to the soundtrack on repeat."*
2. **Art direction / Cloudbank** — *"gorgeous hand-painted art"*, *"absolutely mesmerizing."*
3. **Combat / Function builds** — *"Combat is the real star… I loved experimenting with different builds, stacking passives"*; *"robust skill system really lets you self-express."*
4. **Limiter risk/reward** — *"The risk/reward with Limiters is brilliant… harder for better rewards and faster progression."*
5. **Atmosphere & emotional ending** — *"Had me crying by the end."*

**Why they come back (replay drivers) [GS: Reviews]:** build experimentation + **Recursion** scaling difficulty (*"allows for constant reruns that get increasingly more challenging"*), Limiter mastery, and revisiting the aesthetic years later (*"revisited this game after a decade… amazing experience"*).

**Common criticisms [GS: Reviews]:** **short** (*"I just wanted more when I finished"*); **story can feel opaque** (*"hard to clearly understand"*, *"better off watching youtube"*); **sometimes too easy** absent Limiters; dated AI; one detractor felt combat *"lost in both"* tactical and action. Several wished for deeper on-screen character engagement with the Camerata (lore is gated behind Function-File reading).

**Legacy signal [GS: Reviews]:** players explicitly trace **Hades' build diversity and Heat/difficulty systems back to Transistor's Functions and Limiters.**

---

## 12. Design intent (in the developers' words)

[GS: 05-gamedeveloper/Amir Rao, Studio Director]
- The Function system grew from **love of collectible card games (Magic: The Gathering)** — the pleasure of a known deck drawn in unknown combinations.
- Original goal was the *opposite* of "encourage experimentation": **prevent rigid attachment** to a few abilities. Early prototypes used **randomized draw/shuffle decks**; abandoned because a linear narrative gave **no natural reason to re-shuffle**, and difficulty tuning broke on every reset.
- Two breakthroughs: (1) the **"slow death"** as a *diegetic* shuffle (lose your top Function on death); (2) **collapsing the deck to 16** by making every Function simultaneously a potential Active, Upgrade, and Passive — "16 strong concepts (stun, charm, long range)" combinable into things like *"a powerful long-range attack that stuns and charms enemies in the blast radius."*
- They **stopped fighting** player familiarity ("eat your vegetables" design) and instead built **enough richness** for the curious, plus the **lore-unlock reward** to reciprocate experimentation without punishing the cautious.
- Deliberately **no single-Function leveling** (unlike Bastion) — the system is about **pairs, trios, and relationships**.

---

## 13. Genuine-vs-Assumed ledger (key calls)

| Claim | Tag |
|---|---|
| 16 Functions; 3-slot (Active/Upgrade/Passive); 4+8+4 = 16 max slots; start 3A/1U/0P; Crash()+Breach() preinstalled | **GS** (07-fandom-functions; UI frames) |
| Max MEM 32; tutorial's "24" = MEM, not slots | **GS** for both figures; **ASSUMED** that narrator conflated the terms |
| Function slot-effect text (the §4.4 table) | **GS** (UI frames f_00012/24/36/86 + wikis) |
| Per-Function **MEM costs** & exact **percentages** | **GS via dossier/wiki**, not re-measured here |
| Turn() = 100 pts; Crash() = 20 pts; overload-one-last-action; recovery lockout except Jaunt/Mask | **GS** (15-fandom-combat; 20-fandom-turn) |
| Combo multipliers (Backstab 1.5, Unmask 2, Crashed 1.5, Void 1.75 ×3) + 450-dmg example | **GS** (15-fandom-combat) |
| 10 Limiters, effects, XP%, max 32%, unlock L4, Risk() achievement | **GS** (35/36-fandom-limiters; f_00050/f_00190) |
| "Slow death" intent + CCG origin | **GS** (05-gamedeveloper/Amir Rao) |
| ~22.28 trillion combinations | **GS via dossier-Technical** (single secondary source; treat as cited, not verified) |
| Enemy FSM decision model | **ASSUMED / secondary analysis** (dossier-Technical) |
| Sentiment percentages & themes | **GS** (Steam API dataset) |
| **D1–D30 day mapping** | **ASSUMED** (no in-game days); underlying story beats **GS** |

---

## 14. Source index
- Web: [`Web Sources/`](Web Sources/) — 40 captured sources (`<NN-slug>/content.md` + `_meta.md` + `images.md` + raw payloads). Highest-value for the weapon: `07`/`10`-fandom-functions, `08`-ign-functions, `35`/`36`-fandom-limiters, `20`-fandom-turn, `15`-fandom-combat, `05`-gamedeveloper (Amir Rao), `25`-fandom-the-process.
- Video: [`Video Analysis/QLYkM4YZEMc/`](Video Analysis/QLYkM4YZEMc/VIDEO_BREAKDOWN.md) (frame-verified UI), [`01_VIDEO_BREAKDOWN.md`](01_VIDEO_BREAKDOWN.md) (`_hhqPQH01Zw`).
- Reviews: [`Reviews/`](Reviews/) — `steam_237930_reviews.csv/.jsonl` + `summary.md`.
- Prior dossiers (this folder): `Technical Synthesis…`, `Comprehensive Game Design Specification…`.
- Earlier game-agnostic weapon spec: [`03_WEAPON_DESIGN_GDD.md`](03_WEAPON_DESIGN_GDD.md).
