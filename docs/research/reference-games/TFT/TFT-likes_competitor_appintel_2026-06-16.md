# TFT-likes — Competitor Live App-Intel (mobile), pulled 2026-06-16

> **Purpose:** close the gap left by the TFT-only design spec — pull genuine live app-intel for the
> *other* auto-battlers covered in the genre doc (`[S2]`) that have a real mobile presence.
> Companion to `TFT_Design_Spec_Core-Loop_Progression_D1-D30_2026-06-15.md` and
> `TFT_live_appintel_data_2026-06-15.md`.
>
> **Source:** licensed Sensor-Tower-class app-intel MCP. **All figures US, Android** unless noted.
> MAU = panel-modeled monthly active (estimate). Ratings/counts = Play listing (reliable).
>
> **Coverage decision (which genre games got pulled):**
> | Game | Mobile? | Pulled? |
> |---|---|---|
> | Teamfight Tactics | yes | ✅ (see TFT live file) |
> | Hearthstone Battlegrounds | yes (mode inside Hearthstone) | ✅ whole-app proxy |
> | Auto Chess | yes | ✅ |
> | Super Auto Pets | yes | ✅ |
> | Botworld Adventure | yes | ✅ |
> | Dota Underlords | yes (abandoned) | ✅ |
> | Mojo Melee | yes but **inactive since 2024-12, n=101** | ❌ effectively dead — metadata only |
> | Mechabellum | **PC/Steam only** | ❌ no mobile |
> | Backpack Battles | **PC/Steam/itch only** | ❌ no mobile |
> | The Bazaar | **PC/browser only** | ❌ no mobile |

---

## 1. Head-to-head: store rating & distribution (US Android, 2026-06-14)

| Game | Avg ★ | Ratings | %5★ | %1★ | App ID | Last update |
|---|---|---|---|---|---|---|
| **Botworld Adventure** | **4.58** | 154,443 | 77.0% | 3.6% | com.featherweightgames.fx | 2026-06-09 |
| **Teamfight Tactics** | 4.51 | 754,821 | 81.6% | 8.3% | com.riotgames.league.teamfighttactics | 2026-06-05 |
| **Auto Chess** | 4.25 | 229,621 | 67.7% | 10.7% | com.dragonest.autochess.google | 2026-05-20 |
| **Hearthstone** (BG proxy) | 4.14 | 2,019,671 | 68.6% | 14.9% | com.blizzard.wtcg.hearthstone | 2026-06-10 |
| **Super Auto Pets** | 4.07 | 39,974 | 66.5% | 14.6% | com.teamwood.spacewood.unity | 2026-05-27 |
| **Dota Underlords** | **3.36** | 119,205 | 45.9% | 29.4% | com.valvesoftware.underlords | **2023-11-02** |

Distributions (1★/2★/3★/4★/5★ counts):
- Botworld: 5,485 / 2,796 / 6,883 / 20,327 / 118,952
- TFT: 62,887 / 13,192 / 14,280 / 48,436 / 616,026
- Auto Chess: 24,590 / 5,981 / 12,627 / 31,070 / 155,353
- Hearthstone: 300,200 / 66,786 / 69,957 / 196,836 / 1,385,892
- Super Auto Pets: 5,836 / 2,083 / 2,348 / 3,105 / 26,602
- Dota Underlords: 35,083 / 7,983 / 9,551 / 11,832 / 54,756

---

## 2. Head-to-head: monthly active users (US Android, panel estimate)

| Game | Jan | Feb | Mar | Apr | May | Jun | Shape |
|---|---|---|---|---|---|---|---|
| **Super Auto Pets** | 89,934 | 91,915 | **105,189** | 96,507 | 88,556 | 88,632 | largest pure-AB base here; Mar peak |
| **Teamfight Tactics** | 95,476 | 77,620 | 64,413 | **86,995** | 82,484 | 82,517 | set-cycle dip→spike→plateau |
| **Hearthstone** (whole app) | 51,974 | 50,511 | 54,007 | 54,034 | 51,642 | 51,663 | flat (mature CCG; BG is a slice) |
| **Botworld Adventure** | 7,317 | 5,743 | 4,968 | 4,993 | 6,426 | 6,428 | small, recovering |
| **Auto Chess** (global client) | 6 | 4 | 3 | 3 | 3 | 3 | **dead in US** — real base = APAC regional clients |
| **Dota Underlords** | — | — | — | — | — | — | **no data / zero** — abandoned |

---

## 3. Key findings & corrections

1. **Dota Underlords = the cautionary tale, quantified.** 3.36★, **29.4% 1★** (worst of the field),
   zero modeled MAU, **no app update since 2023-11-02**. This is the live-data confirmation of the
   `[S1]`/`[S2]` narrative: Valve removed variance, the game felt solved, updates stalled, it died.
   `[LIVE corroborates S1 L219-221]`.

2. **Correction to `[S2]` on Super Auto Pets.** The genre doc claimed SAP held "~1,000 daily active
   users" by 2026 `[S2 L94]` — but that figure was **Steam-only**. On **mobile (US Android)** SAP runs
   **~89k–105k MAU and rising into March** — the *largest* active base among the pure auto-battlers
   pulled here. The "nostalgia core" framing understated its mobile health. `[LIVE — corrects S2 L94]`.

3. **Botworld Adventure is the most-loved by rating** (4.58★, only **3.6% 1★**) but has a small
   active base (~6k US-Android MAU). It's an RPG-hybrid `[S2 L60-63]`, not a competitive ladder
   game — different retention model (PvE progression vs ranked), which likely explains low 1★ churn
   venting. `[LIVE + INFERRED]`.

4. **TFT is the scale+quality leader among *competitive grid* auto-battlers** — 754k ratings at 4.51★,
   ~82k US-Android MAU with the characteristic set-cycle spike. Only SAP beats it on raw US-Android
   MAU, and SAP is the casual/minimalist end of the genre. `[LIVE]`.

5. **Hearthstone numbers are whole-app**, not Battlegrounds-specific — BG is one mode inside a 2M-rating
   CCG. Treat 4.14★ / ~52k MAU as *context*, not a BG read. A BG-isolated figure isn't separable from
   this data source. `[LIVE + caveat]`.

6. **Retention curves: TFT only.** The panel returned **"no data"** for Auto Chess, Super Auto Pets,
   and Botworld retention, and Underlords has no active data. So the D1/D7/D30 cross-game comparison
   **cannot** be done from this source — only TFT's curve (37.7%/15.9%/7.4%) is available
   (see TFT live file). `[LIVE — limitation]`.

7. **Mojo Melee (Web3) is effectively defunct on mobile** — Android listing inactive since 2024-12
   with **101 lifetime ratings**, iOS 9 ratings. The `[S2]` framing of it as a live "Web3 evolution"
   is not supported by store reality. `[LIVE — contradicts S2 L100-104 framing]`.

---

## 4. Reliability caveats

- US-Android only; global and iOS differ. MAU is **panel-modeled**, directional not exact.
- Ratings averages/distributions are reliable counts from the Play listing.
- "Auto Chess" has multiple regional clients (`com.vng.autochess` SEA, Chinese builds); the US
  `com.dragonest.autochess.google` MAU ≈ 0 does **not** mean the game is globally dead — its base is
  APAC, which this US slice doesn't capture. Pull regional clients / `both_stores` to size it properly.
- Hearthstone MAU/ratings are whole-app, not BG.
- Did **not** pull downloads/revenue (the daily/per-country dump is large and non-essential here).

## 5. Suggested next pulls (still open)
- Regional Auto Chess clients (SEA/CN) + `both_stores` to size APAC base.
- iOS ratings/MAU for all six for a cross-platform view.
- `/play-store-reviews` full review CSVs per competitor for qualitative theme mining (esp. Underlords
  death-spiral reviews, SAP casual-stickiness drivers, Botworld PvE-progression praise).
