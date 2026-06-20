# Custom skills used:

(none required — this task uses Read / Write / Edit / Bash / PowerShell + a single Opus agent dispatch)

# Workflow — Build a game-design HTML slide deck from existing research

This template builds a self-contained HTML slide deck that captures a single game's **essence** from already-completed research. It is **NOT** a copy-paste of any one game's deck — every deck is shaped by the game's own data: how many phases its core loop has, which systems it actually has, which day-cohort breaks down where its players churn.

The goal is **read the game first, then design the deck**.

## Prerequisite

Phases 1-3 of the [game-design research workflow](./game-design-research-with-claude.md) have already completed:
- A tagged design spec (e.g. `<game-slug>-design-spec.md`) with `[WEB:]` / `[V:]` / `[REVIEWS:]` / `[INFERRED:]` / `[ASSUMED]` tags on every claim
- `Web Sources/` tree with per-source `content.md` + `images/`
- `Video Analysis/` tree with per-video `NOTES.md` + `transcript.md` + `frames/`
- `Play Store Reviews/` folder with `listing_metadata.json` + `reviews.csv` + `analysis_pack.md`

## Mental model

A game deck has one job: communicate a game's design **completely enough that a teammate could prototype it** after reading it. To do that, it must answer 8-15 questions (varies by game depth):

- *What is this game?* (genre, positioning)
- *Who's playing it and why?* (audience, fantasy)
- *What is the core loop?* (the cycle a player repeats)
- *What is the in-run experience?* (UI anatomy, moment-to-moment)
- *How does the player progress?* (meta systems, currencies, unlocks)
- *What is the early-game journey?* (D1-D7 if data exists; deeper if needed)
- *What is the mid-to-late game?* (D8-D30+ if data exists)
- *Why do players come back? Why do they leave?* (hooks, pain points)
- *How does it make money?* (monetization, ad-density)
- *What is its competitive position?* (comparators)
- *What should we copy / avoid / watch?* (takeaways)

Not every game's research will support every question. **Design the deck spine to match what the research actually contains** — skip slides where the data is thin, expand slides where the data is rich.

The Gear Defenders deck used 18 slides because its research had rich D-cohort detail AND a structured tier list AND a currency stack AND multiple comparator surfaces. A simpler game might warrant only 10 slides. A deeper, more complex game might warrant 25.

---

## Step 1 — Confirm input paths + read the spec end-to-end

> ⏸ **HITL — Gate A: input paths.** Present the filled placeholder table back to the user. Confirm all paths exist on disk. Do not move on until the user approves.

Fill in:

| Placeholder | Notes |
|---|---|
| `<GAME_NAME>` | display name |
| `<GAME_SLUG>` | kebab-case for filenames |
| `<RESEARCH_ROOT>` | absolute path to research folder |
| `<DESIGN_SPEC>` | path to canonical synthesis doc |
| `<PACKAGE>` | Android package name (if applicable) |
| `<APP_STORE_ID>` | iOS App Store id (if applicable) |
| `<HEADLINE_STATS>` | rating count / average / distribution from `listing_metadata.json` |

After approval, **read the full design spec end-to-end**. Build a mental model of:
- What genre this game inhabits and what archetypes it borrows from
- What its core in-run loop is — how many discrete phases the player cycles through
- Which meta-progression systems exist
- What its monetization model is (subscription / IAP / ads / hybrid)
- Where the player journey has data (D1, D7, D30?) vs where it's `[INFERRED]` or `[ASSUMED]`
- Where the research is thin or has explicit `[Gap]` markers

This reading is non-negotiable. The slide spine in Step 2 is impossible to design without it.

---

## Step 2 — Design the deck spine from the game's data

> ⏸ **HITL — Gate B: deck spine.** Present a proposed slide list (between 10 and 25 slides) with one-line descriptions, sourced from your reading in Step 1. The user approves, removes, adds, or reorders. Do not proceed until approval.

For each question in the mental model above, decide whether the research supports a slide. Use this decision frame:

| Question | Build a slide if research has… | Skip if research lacks… |
|---|---|---|
| What is this game? | publisher + genre + headline stats | (always build — it's the cover) |
| Audience / fantasy | review sentiment + creator framing | thin sentiment data |
| Core gameplay loop | clear in-run flow from gameplay videos | no gameplay footage |
| In-run UI anatomy | annotated UI screenshots / real gameplay frames | only marketing art (consider skip or redesign) |
| Core mechanic detail | mechanic-specific creator commentary | mechanic-equivalent of in-run loop already covered |
| Progression / tier ladder | tier-list video + structured rarity data | unstructured/anecdotal progression mentions only |
| Hero / unit roster | named unit list with tier ratings | unnamed or non-existent unit system |
| Castle / base / building upgrade path | named upgrade tiers + stat scaling | non-builder games (different progression mechanic) |
| Currency sinks | listed currencies with sources + sinks | single-currency game (cover in monetization slide instead) |
| Meta progression map | multiple interconnected systems | linear/single-system progression |
| D1-D3 deep dive | minute-by-minute gameplay footage of first session | only macro-cohort observations |
| D4-D30 journey | version-tagged regression reviews + cohort commentary | no longitudinal data |
| Engagement hooks | 3+ identified retention layers | only one habit driver |
| Monetization stack | IAP pricing + ad mechanic inventory | unmonetized or single-IAP game |
| Pain points | thumb-counted negative reviews with themes | balanced sentiment with no clear themes |
| Comparators | named adjacent titles in research | no comparator data (use storefront "similar games" as fallback) |
| Takeaways | enough cross-source synthesis to form opinions | not yet — synthesis stage incomplete |

The output of this step is a **spine list** like:

```
01. Cover — <GAME_NAME> at a glance
02. What is <GAME_NAME>? — genre + positioning
03. Player fantasy
04. Core gameplay loop (<N> phases per the research)
05. Battle screen anatomy (annotated real UI)
06. <Core mechanic specific to this game — name it: "Card draft" / "Gear merge" / "Auto-aim arc" / "Lane allocation">
07. Progression — <name the progression metaphor: tier ladder / unit ranks / weapon tree>
08. <Roster slide if applicable — heroes / decks / characters>
09. <Base/castle/HQ upgrade path if applicable>
10. Currency sinks dashboard
11. Meta progression map
12. D1 deep dive (first-session detail)
13. D2-D7 (or D1-D3 + D4-D30 split — pick based on data richness)
14. D8-D30 (or onward — depends on data)
15. Engagement hooks
16. Monetization
17. Pain points
18. Comparators
19. Takeaways
```

— but the actual spine is whatever fits the game. **Do not import the Gear Defenders 18-slide structure wholesale.** The Wittle Defender deck might want a "Skill draft" slide where Gear Defenders had a "Gear merge" slide. A Marvel Snap research deck might want a "Deck construction" slide that no Gear Defenders slide maps to. A roguelike research deck might want a "Run variance" slide.

The slide labels should use the **game's own terminology**, not a generic template's terminology.

---

## Step 3 — Map each spine slide to a layout pattern

For each slide in the approved spine, decide its layout based on the **shape of the data** it presents. Don't pre-commit to a layout — pick the one that fits.

| Data shape | Layout pattern | CSS class |
|---|---|---|
| 4-6 numeric headlines | bento grid 2x3 or 3x2 | `.stats-grid` |
| Cyclic process with N nodes (N = 3 to 7) | SVG ring or hub-and-spoke; N drives node placement angles | `.loop-wrap` (SVG sized to N) |
| Linear process | left-to-right step arrows + cards | `.timeline` or `.steps` |
| Annotated visual | image left + callout column right; cap callouts at the visual height | `.anatomy-wrap` + `.anatomy-callouts` (row-locked grid prevents overflow) |
| Ranked list | vertical color-coded ladder | `.tier-ladder` |
| Tabular data (e.g. IAP list, currency table) | sticky-header table | `.iap-table` |
| Many independent items | bento auto-fit | `.bento-grid` |
| Categorical comparison (3-4 groups) | 3-4 column grid | `.comparator-grid` or `.takeaways-grid` |
| Cohort timeline | horizontal day-band timeline | `.cohort-timeline` |
| Deep-dive on one period (e.g. D1) | 3 day-cards with nested sections | `.deep-dive-grid` |
| Branching tree | SVG branching diagram | `.tree-svg` |
| Magnitude comparison | bar chart (CSS flexbox bars) | `.bar-chart` |
| Stacked layered narrative | 5 horizontal cards stacked, each with accent-colored left border | `.layer-stack` |

**Number-of-nodes is data-driven, not template-driven.** If the core loop has 3 phases, draw a triangle; 4 phases, a square; 5, a pentagon; 7, a heptagon. The SVG geometry adapts. Same for tier ladders, mechanic cards, currency cards, etc. — count what the research has and design the layout around that count.

**No 3+ consecutive slides should use the same layout pattern.** If the spine forces it (e.g., 4 consecutive "bento grid" slides), restructure so the eye gets variety.

---

## Step 4 — Derive theme palette + typography from the game

> ⏸ **HITL — Gate C: theme.** Propose a 10-color CSS-variable palette + a display-font choice based on the game's app icon and key art. Show the user the swatches as a rendered HTML chip preview + a "THE QUICK BROWN FOX" sample in the candidate font. Wait for approval.

Method:

1. **Read the game's app icon + 2-3 storefront/key-art screenshots** multimodally (`Read` tool on each).
2. **Identify 2-3 hero colors** that dominate the game's visual identity — these become `--primary`, `--secondary`, optional `--tertiary`.
3. **Identify the mood**: dark/light bg, warm/cool tone, saturated/desaturated. This sets `--bg-deep`, `--bg-panel`, `--bg-panel-2`.
4. **Pick a danger color** that contrasts the primaries — usually red-orange for pain-point sections (`--danger`).
5. **Pick text colors**: a near-white that fits the mood (`--ivory`), a muted secondary (`--mute`), a panel border (`--stroke`).
6. **Display font** matches genre voice:
   - Medieval / fantasy → Cinzel, EB Garamond, Cormorant Garamond
   - Sci-fi / cyberpunk → Orbitron, Rajdhani, Audiowide
   - Arcade / playful → Bungee, Lilita One, Bebas Neue
   - Literary / narrative → Fraunces, Playfair Display
   - Casual / chibi → Lilita One, Fredoka, Baloo 2
   - Dark / horror → Cinzel Decorative, UnifrakturCook
   - Sports / energetic → Anton, Oswald, Teko
7. **Body font** is almost always **Inter** (broadest weight range, good on every device).
8. **Mono font** for tags + labels is almost always **JetBrains Mono** (clear at small sizes, distinct from body).

The palette and fonts are LOCKED after Gate C — the assembler uses them verbatim.

---

## Step 5 — Pre-flight screenshot manifest

(Automated — no HITL.)

The single most error-prone step in deck-building is putting the wrong image on the Battle Anatomy slide. Storefront "screenshots" are almost always marketing key-art collages — **not** real in-game UI. Real UI lives in the `Video Analysis/<videoid>_analysis/frames/` folders.

Build a manifest before writing any HTML:

```powershell
$root = "<RESEARCH_ROOT>"
"=== Storefront screenshots (LIKELY MARKETING ART — examine before use) ==="
Get-ChildItem "$root\Web Sources\play-store-*\images" -Filter "screenshot_*.webp" -ErrorAction SilentlyContinue
"=== App icon + feature graphic (safe for cover/header) ==="
Get-ChildItem "$root\Web Sources\*\images\icon_*.webp", "$root\Web Sources\*\images\feature_graphic_*.webp" -ErrorAction SilentlyContinue
"=== Real gameplay frames (USE these for any in-game UI slide) ==="
foreach ($d in (Get-ChildItem "$root\Video Analysis" -Directory -ErrorAction SilentlyContinue)) {
  $candidates = Get-ChildItem "$($d.FullName)\frames\f_*.jpg" -ErrorAction SilentlyContinue | Select-Object -Index 100,200,300,400,500
  Write-Output "[$($d.Name)]"
  $candidates | ForEach-Object { "  $($_.Name) ({0:N0} KB)" -f ($_.Length/1KB) }
}
```

**Then visually examine candidate frames** by `Read`-ing 4-6 of them. Note which are:
- Real UI (e.g. shows the game's HUD elements, no creator-overlay watermarks, captures a mid-run moment)
- Marketing art (key art renders, character collages, tier-list infographics, end-cards)
- Channel-watermarked (creator's logo / face / subscribe overlay visible — avoid unless you can crop)

Pick the cleanest real-UI frame per slide that needs one. Silent-walkthrough channels (no creator face/logo) are usually the cleanest source.

Build a `<slide-number, image-path, role>` manifest. The assembler in Step 7 uses exactly these images, no others.

---

## Step 6 — Build a 2-slide preview

> ⏸ **HITL — Gate D: preview.** Write `<RESEARCH_ROOT>/<game-slug>-deck-preview.html` containing only the Cover slide + the single most-visual slide from the spine (usually the Core Gameplay Loop, but could be the Battle Anatomy or Meta Progression Map — pick what best stresses the theme). User opens in browser. Approve theme + visual approach. Wait for approval.

The preview validates:
- Palette feels right on real text/numbers
- Display font reads well at h1 size (test with the game's actual name)
- SVG diagram readable at slide scale
- Source chip styling subtle but legible
- Animation/motion taste

Iterate on the preview until the user is happy. **Then** proceed to Step 7 — the full build.

---

## Step 7 — Dispatch the Opus assembler

Send the prompt below to a single Opus general-purpose agent. The assembler reads spec + preview + slide spine + screenshot manifest and writes the full deck file in one pass.

> The assembler step has no HITL gate — it executes the locked-in decisions from Gates A-D.

---

### Prompt to dispatch (paste verbatim, fill placeholders)

You are building the FINAL `<GAME_NAME>` design deck as a single self-contained HTML file.

**Output file (overwrite if exists):** `<RESEARCH_ROOT>/<game-slug>-deck.html`

**Files to read first:**
1. Approved preview (theme/CSS/nav/script template): `<RESEARCH_ROOT>/<game-slug>-deck-preview.html` — copy `<style>` block + script wholesale. Reuse the 2 preview slides verbatim.
2. Design spec (source of every factual claim): `<DESIGN_SPEC>` — every claim must trace to a tag here.
3. Wittle-format spec (cleaner shorthand for chips): `<RESEARCH_ROOT>/<game-slug>-design-spec.md` if present.
4. Locked deck spine (paste below): `<SPINE_LIST_FROM_GATE_B>`
5. Locked screenshot manifest (paste below): `<MANIFEST_FROM_STEP_5>`

**Theme:** locked from preview — do not change palette.

**Typography:** locked from preview.

**Global UX rules:**
- Slide count = length of locked spine.
- Nav: horizontal `.nav-bottom` dot strip (NOT right-side rail), centered, primary-on-active. Dot count = slide count. `data-go` indexes 0 through (slide count − 1).
- Keyboard: `←` / `→` / `Space` / `F` (fullscreen). Reuse the preview's script verbatim, updating dot count.
- Font scaling: +20% globally EXCEPT cover `h1`.
- Cover h1 sizing: scale based on the longest single word in the title. ≤ 7 chars → `clamp(2.8rem, 5.5vw, 5rem)`. 8-9 chars → `clamp(2.4rem, 4.6vw, 4rem)`. 10+ chars → `clamp(2rem, 3.8vw, 3.4rem)`. Verify in self-review the title does not overflow the cover's left column.
- Slide transition: 400ms opacity + 30px translate-X fade.
- Background: dark/light per palette + subtle pattern. Pick a pattern that matches genre — gear-tooth SVG for industrial/medieval-craft, hexgrid for sci-fi, scanlines for arcade, parchment grain for fantasy, etc. Pattern is ~6-8% opacity, never competes with content.
- Footer: every slide has `<span class="pageno">NN</span> / <TOTAL>` (NN zero-padded; TOTAL = locked slide count).

**Slide content rules (general — applies to every slide):**
- The slide's content is **extracted from the spec for THIS game**. Do not paste examples from other games' decks. Every fact, every quote, every number must come from `<DESIGN_SPEC>` or the Video Analysis / Reviews data referenced in it.
- Slide titles use the game's own terminology (e.g. if the game calls them "Gears", not "Cards"; if the game calls progression "Castle Lv", not "Base Lv").
- Number-of-items per slide is data-driven, not template-driven. If the core loop has 4 phases, draw 4 nodes; if 7 phases, 7. If the IAP catalogue has 6 SKUs, table has 6 rows; if 12, 12.
- Layout per slide comes from the locked spine + Step 3 data-shape-to-layout map. Do NOT inventively rearrange a slide's layout — use what was approved.

**Slide-by-slide build instructions (for each slide in `<SPINE_LIST_FROM_GATE_B>`):**

For each slide:
1. Read the spec sections relevant to this slide's topic.
2. Extract the facts, quotes, numbers, and source tags needed.
3. Apply the layout pattern assigned in Step 3.
4. Write the slide markup using the game's terminology.
5. Tag every factual claim with a source chip.

**Screenshot embedding:**

Use only the images in `<MANIFEST_FROM_STEP_5>`. Base64-encode and embed inline as `data:image/<fmt>;base64,...`. Total embedded image weight target: under 5 MB.

Encoding (Windows PowerShell):
```powershell
$bytes = [System.IO.File]::ReadAllBytes("<path>")
"data:image/webp;base64," + [Convert]::ToBase64String($bytes)
```

Encoding (Python):
```python
import base64
print(f"data:image/jpeg;base64,{base64.b64encode(open(p,'rb').read()).decode()}")
```

**Source chip discipline (CRITICAL):**

Every factual claim wrapped in `<span class="src">SourceShorthand</span>`. Shorthand convention is the same as the spec's tagging table — copy it verbatim from the `## Source Tagging Conventions` section of the spec.

One source per chip. Never combine two sources in a single `<span>` (breaks the chip-count regex). If multiple sources support a claim, use two adjacent chips.

Target: chip count ≥ 4 × slide count. (For an 18-slide deck, ≥ 72 chips; for a 12-slide deck, ≥ 48 chips.) If under, the deck is under-sourced — re-pass.

**Self-review pass before finishing:**

1. Re-read end to end.
2. Verify every claim has a source chip — no untagged factual assertion.
3. No invented stats — every number traces to the spec.
4. Anywhere review-based numbers appear, frame them as scraped-sample (biased, ~3-10% of lifetime), NOT as the app's actual rating. The headline rating always comes from `[Reviews-lifetime]`.
5. Game's own terminology used everywhere (no template-language leakage).
6. Theme palette consistent — no off-brand colors leaking.
7. Layout variety — no 3+ consecutive slides using the same pattern.
8. Slide-count integrity: `<section>` count = spine count; nav-dot count = spine count; every footer says `NN / <TOTAL>` correctly; `data-go` indexes contiguous 0 through (TOTAL−1).
9. Cover title not overflowing into right-side stats card.
10. Any "in-game UI" slide uses a `Video Analysis/.../frames/` image, NOT a `Web Sources/.../screenshot_*.webp` image.

**Return when done:**

Brief report:
- File size (KB)
- Slide count (matches locked spine)
- Source chip count
- Embedded image count + total image weight + list of file paths used
- Layout pattern used per slide (numbered list)
- Path to file

---

### After the agent returns

Open the HTML in a browser. Click through every slide. Verify:
- Cover h1 not overflowing
- Each in-game-UI slide shows real gameplay, not marketing art
- Each slide uses the game's own terminology, not template language
- Each slide's content traces back to the spec
- Layout variety holds (no 3+ consecutive same-pattern stretches)
- Nav-dot count + footer `/ <TOTAL>` everywhere correct

If any check fails, **loop back to the assembler with a targeted fix prompt** naming the specific slide + issue. Do NOT use post-hoc Python regex surgery on a 400 KB+ HTML file — it's brittle. Re-run the assembler with a tightened prompt instead.

---

## Step 8 — Render PNGs (optional)

> ⏸ **HITL — Gate E: PNG render.** Confirm with the user that they want PNG exports. Skip if they only want the interactive HTML.

For sharing in Slack, Notion, FigJam, Google Docs etc., render each slide to a 1920×1080 PNG via Playwright. Install once:

```powershell
python -m pip install playwright
python -m playwright install chromium
```

Then run:

```python
import pathlib
from playwright.sync_api import sync_playwright

ROOT = pathlib.Path(r"<RESEARCH_ROOT>")
DECK = ROOT / "<game-slug>-deck.html"
OUT  = ROOT / "_slides_png"
OUT.mkdir(exist_ok=True)
for old in OUT.glob("slide-*.png"):
    old.unlink()

NUM_SLIDES = <LOCKED_SPINE_COUNT>
VIEWPORT = {"width": 1920, "height": 1080}

with sync_playwright() as p:
    browser = p.chromium.launch()
    ctx = browser.new_context(viewport=VIEWPORT, device_scale_factor=1)
    page = ctx.new_page()
    page.goto(f"file:///{DECK.as_posix()}", wait_until="networkidle")
    page.wait_for_timeout(2000)
    for i in range(NUM_SLIDES):
        page.evaluate(f"go({i})")
        page.wait_for_timeout(700)
        out = OUT / f"slide-{i+1:02d}.png"
        page.screenshot(path=str(out), clip={"x":0, "y":0, "width":1920, "height":1080})
        print(f"  saved {out.name}")
    browser.close()
```

Output: `<RESEARCH_ROOT>/_slides_png/slide-NN.png`. Drag-drop into FigJam, Notion, Slack, Google Docs, etc.

---

## Step 9 — Post to Figma Slides (optional)

> ⏸ **HITL — Gate F: Figma push.** Confirm with the user that they want a Figma Slides version. Warn about rate limits up front.

If you want a Figma Slides version (editable presentation that teammates can co-edit), use the Figma MCP `create_new_file` (editorType: `slides`) + `use_figma` calls. Build the same 2-slide preview from Step 6 first, then expand.

**Rate-limit constraint:** Figma MCP caps Collab seats on Organization plans at 6 calls/month. Full/Dev seats: 200-600/day depending on tier. A full deck build needs roughly (slide count) × 1.5 `use_figma` calls. Plan accordingly.

If rate-limited mid-build, the partial deck stays — resume next billing cycle, or upgrade seat, or fall back to drag-dropping PNGs from Step 8 into a FigJam board.

---

## Reference example

See [`Gear Defenders/gear-defenders-deck.html`](../research/reference-games/Gear%20Defenders/gear-defenders-deck.html) for one finished output of this workflow — 18 slides at 424 KB, 170 source chips, 5 embedded screenshots, dark medieval theme. The slide spine, palette, and content are all specific to Gear Defenders; use it as a worked example of the process, not a template to copy.

## Files this template produces

In `<RESEARCH_ROOT>/`:
- `<game-slug>-deck-preview.html` — 2-slide approval preview (Step 6)
- `<game-slug>-deck.html` — full self-contained deck (Step 7)
- `_slides_png/slide-NN.png` (optional) — 1920×1080 PNG renders for sharing (Step 8)
- Figma Slides file URL (optional) — editable co-edit version (Step 9)
