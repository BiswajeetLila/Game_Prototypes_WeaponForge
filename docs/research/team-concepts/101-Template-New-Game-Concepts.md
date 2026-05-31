# New Game Concept — Template

**Owner:** Concept author

---

## 1. Greenlight checklist

- [ ] Filled out Stage 1–6
- [ ] Text write-ups for SSR
  - [ ] Full description of core loop (~135 words)
  - [ ] Full description of core loop + 1 meta progression (~170 words)
  - [ ] Store-page variant (~55 words)
  - [ ] First 1–5 minutes the player experiences (~280 words)
  - [ ] D1–D14 player journey / progression description (~340 words)
- [ ] Prototype
  - [ ] Playable Gameplay (In Blockout)
  - [ ] Playable Coreloop with 1 Progression layer
  - [ ] Integrate AI art assets
- [ ] AI Art Assets
  - [ ] Mockup of gameplay screen
  - [ ] Key art
  - [ ] Key UI frames
  - [ ] App store icon
- [ ] SSR Test Results
- [ ] Internal Playtest and Conviction
- [ ] Fake App Store Tests
- [ ] Publish AI Prototype on store and test D1 + number of games on D0

---

## 2. Identity

| Field | Value |
|---|---|
| Working title | |
| Genre / subgenre | |
| Target audience | *Primary player archetype this concept is for. One sentence; not a demographics list. Example: "Western mid-core players who graduated from Vampire Survivors and want a team-building hook."* |

---

## 3. Core thesis / idea

**Core idea (player-voice, ~100 words):**

*What a player who's played for 30 minutes would tell a friend the game is. No designer jargon, no monetization, no "we'll execute better than [competitor]" framing. The mechanic and the fantasy in one paragraph.*

---

## 4. Gameplay journey

### Detailed D1

**First 60 seconds:**

- **0–5s:** *What the player sees, what they're asked to do.*
- **5–15s:** *First interaction. Tap target, response.*
- **15–25s:** *First feedback loop closes. What changes on screen.*
- **25–40s:** *Second loop, escalation.*
- **40–60s:** *The "I want more of this" moment — the specific beat that earns a second session.*

---

## 5. Hypothesis of why this would work

*One to two paragraphs. The causal story the concept is betting on: which player need is unmet by current games in this genre, what specific mechanic in this concept addresses that gap, and which prior shipped game's success pattern supports the bet. This is the section a skeptical reader will challenge — write it so the bet is legible, not so the bet sounds inevitable.*

---

## 6. Risks

**Single fragile assumption:**

*The one bet this concept is making that, if wrong, kills the game. Not a list of three "risks" — one assumption, phrased specifically enough to be testable. "Western players will accept fixed positional combat if Chain Skills feel powerful enough" is testable. "The market will respond" is not.*

---

## 7. Reference games

1. **[Game name]** — studio, year, platform. *Why it's comparable in one sentence. What we share, what we don't.*
2. **[Game name]** — studio, year, platform. *Same.*
3. **[Game name]** — studio, year, platform. *Same.*

**Genre mashup formula** (optional, one line): *e.g. "Tower defense × Vampire Survivors × hero collector"*

---

## 8. Progression

### Rest of D1 (~5–10 min after first 60s)

*Bullets, not prose. What does the player do for the rest of their first session? When do they hit the first wall, the first reward, the first meta-loop touchpoint?*

### Vague D1–D14 idea

| Day | What the player has | What brings them back |
|---|---|---|
| D1 | | |
| D3 | | |
| D7 | | |
| D14 | | |

Keep this vague on purpose — Stage 2 SSR will pressure-test the cadence. Don't over-specify; one or two sentences per day.

---

## 9. Deliverables

This is the contract. To take this concept through the SSR pipeline + greenlight gate, the concept author must produce everything below. Each row maps to a specific stage in [`game-testing-approach.md`](../strategy/game-testing-approach.md).

### 9.1 Synthetic testing materials — Design (text)

| Artifact | Used by | Word target | Notes |
|---|---|---|---|
| **Full description of core loop** | Stage 1 | ~135–170 | Player-voice. No title. No monetization. No depth claims. Describes only what happens minute-to-minute in a match/run. |
| **Full description of core loop + 1 meta progression** | Stage 1 (genre-conditional) | ~150–200 | Required for collection-driven genres; optional for run-based; skip for pure-session. One sentence per meta-loop, no mechanism names, no quantities. See `game-testing-approach.md` §"Per-genre stimulus rules" + rule #3b. |
| **Store-page variant** | Stage 1b (optional) | ~50 | The pre-install pitch. Reads like a Play Store description. |
| **First 1–5 minutes the player experiences** | Stage 1 supporting / Stage 2 prep | ~200–300 | Expansion of §4's first-60-seconds into the full opening session. Used as Stage 2 input and as the canonical reference for art/UI mocks. |
| **D1–D14 player journey (progression description)** | Stage 2 | ~200–400 | Prose, not a feature list. What the player unlocks, builds, masters, or competes for across two weeks. Maps to §8's vague D1–D14 table, expanded. |

### 9.2 Synthetic testing materials — Art

Genre-conditional. Not every concept needs every asset; sub-stages of Stage 3 are gated on what the concept is.

| Artifact | Used by | Notes |
|---|---|---|
| **Mockup of gameplay screen** | Stage 3 | All in-match elements visible — heroes/units/cars/characters, bosses, UI HUD, environment. Single static frame that a player could understand the game from. |
| **Key art** | Stage 3 + Stage 1b pairing | Marketing-style hero shot. Characters/heroes/cars/vehicles featured. The image that would lead a store listing. |
| **Key UI frames** | Stage 3 | Genre-conditional set. Typical: gameplay HUD, hero collection screen, hero upgrade / skill tree, shop / banner. For run-based games: run map, draft screen, run-end summary. |
| **App store icon** | Stage 3 (thumbnail click-intent) | The 1024×1024. Tests whether the concept reads at thumbnail size. |

### 9.3 Playable prototype

Required for greenlight (Supercell mandate). SSR cannot validate moment-to-moment feel, input latency, juice, or controls — the prototype is the only artifact that does.

| Artifact | Used by | Notes |
|---|---|---|
| **Playable prototype** | Greenlight gate | Scope: enough to play the core loop end-to-end for one session. Doesn't need meta-loop, monetization, or polish. Must be feel-representative. |
| **Gameplay video (30–90s, beat-sliced)** | Stage 4 | Cut from the prototype. Beats: first 30s onboarding, first win, first loss, first monetization touchpoint (if shown). Each beat is scored separately. |
