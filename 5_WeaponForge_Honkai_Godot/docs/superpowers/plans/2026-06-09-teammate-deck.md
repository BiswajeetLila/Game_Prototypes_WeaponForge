# Teammate Deck — HTML One-Pager Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a self-contained, dark, forge-themed HTML one-pager that brings Lila internal team + leadership onto the same page about the WeaponForge prototype.

**Architecture:** Single HTML page in `docs/teammate-deck.html` + external CSS + ~30 lines of vanilla JS, all referencing image copies in `docs/decks/assets/`. Sticky top nav, smooth-scroll anchors, 7 sections with `<details>` collapsibles for deeper detail. The unforgettable moment: a Bran 5-tier portrait scrubber driven by `object-position` on a stacked source image. All design parameters locked in `docs/superpowers/specs/2026-06-09-teammate-deck-design.md`.

**Tech Stack:** HTML5 · CSS3 (custom properties, grid, `@media`, `prefers-reduced-motion`, `@media print`) · Vanilla JS (no framework) · Google Fonts (Cinzel + Manrope + JetBrains Mono, WOFF2, swap) · Inline SVG (anvil, dividers, noise filter, icons) · No build step, no bundler.

**Spec:** [`docs/superpowers/specs/2026-06-09-teammate-deck-design.md`](../specs/2026-06-09-teammate-deck-design.md)

**Branch:** `forgeloop/teammate-deck` (already cut). Commit per task. Three chunks (D-1 skeleton+theme, D-2 content, D-3 motion+hook).

---

## File structure (locked from spec §11)

```
docs/teammate-deck.html              (the deck — semantic HTML, references external CSS + JS)
docs/decks/style.css                 (theme tokens, layout, atmosphere, motion)
docs/decks/scrub.js                  (Bran scrubber + IntersectionObserver for dividers)
docs/decks/assets/                   (git-tracked image copies)
  ├─ heroes/bran.png
  ├─ heroes/elara.png
  ├─ heroes/vex.png
  ├─ enemies/slime.png
  ├─ enemies/goblin.png
  ├─ enemies/skeleton.png
  ├─ parts/r_fire.png
  ├─ parts/r_ice.png
  ├─ parts/r_pierce.png
  ├─ parts/h_iron_edge.png
  ├─ parts/p_steel_grip.png
  └─ bran_5tier.png
```

Anvil silhouette, engraved-rule dividers, hammered-noise filter = inline SVG in HTML (no extra files).

---

## CHUNK D-1 — Skeleton + theme

Goal: HTML scaffold loads, fonts render, theme colors apply, sections are empty placeholders, sticky nav works, atmosphere primitives (noise, dividers) render. No content yet. Manual visual check at end.

---

### Task 1: Create asset directory + copy images

**Files:**
- Create: `docs/decks/assets/heroes/bran.png` (copy of `Prototype/godot/assets/generated/heroes/bran_warrior.png`)
- Create: `docs/decks/assets/heroes/elara.png` (copy of `elara_mage.png`)
- Create: `docs/decks/assets/heroes/vex.png` (copy of `vex_rogue.png`)
- Create: `docs/decks/assets/enemies/slime.png` (copy of `enemies/slime.png`)
- Create: `docs/decks/assets/enemies/goblin.png` (copy of `enemies/goblin.png`)
- Create: `docs/decks/assets/enemies/skeleton.png` (copy of `enemies/skeleton.png`)
- Create: `docs/decks/assets/parts/r_fire.png` (copy of `parts/r_fire.png`)
- Create: `docs/decks/assets/parts/r_ice.png` (copy of `parts/r_ice.png`)
- Create: `docs/decks/assets/parts/r_pierce.png` (copy of `parts/r_pierce.png`)
- Create: `docs/decks/assets/parts/h_iron_edge.png` (copy of `parts/h_iron_edge.png`)
- Create: `docs/decks/assets/parts/p_steel_grip.png` (copy of `parts/p_steel_grip.png`)
- Create: `docs/decks/assets/bran_5tier.png` (copy of `docs/research/portrait-tier-test/bran_5tier_evolution.png`)

- [ ] **Step 1: Create directory tree**

Run (from project root):

```bash
mkdir -p 5_WeaponForge_Honkai_Godot/docs/decks/assets/heroes
mkdir -p 5_WeaponForge_Honkai_Godot/docs/decks/assets/enemies
mkdir -p 5_WeaponForge_Honkai_Godot/docs/decks/assets/parts
```

Expected: directories exist, `ls 5_WeaponForge_Honkai_Godot/docs/decks/assets/` shows `assets/`, `heroes/`, `enemies/`, `parts/`.

- [ ] **Step 2: Copy hero portraits**

```bash
cp 5_WeaponForge_Honkai_Godot/Prototype/godot/assets/generated/heroes/bran_warrior.png 5_WeaponForge_Honkai_Godot/docs/decks/assets/heroes/bran.png
cp 5_WeaponForge_Honkai_Godot/Prototype/godot/assets/generated/heroes/elara_mage.png 5_WeaponForge_Honkai_Godot/docs/decks/assets/heroes/elara.png
cp 5_WeaponForge_Honkai_Godot/Prototype/godot/assets/generated/heroes/vex_rogue.png 5_WeaponForge_Honkai_Godot/docs/decks/assets/heroes/vex.png
```

Expected: 3 files in `assets/heroes/`, each non-zero size.

- [ ] **Step 3: Copy enemy art**

```bash
cp 5_WeaponForge_Honkai_Godot/Prototype/godot/assets/generated/enemies/slime.png 5_WeaponForge_Honkai_Godot/docs/decks/assets/enemies/slime.png
cp 5_WeaponForge_Honkai_Godot/Prototype/godot/assets/generated/enemies/goblin.png 5_WeaponForge_Honkai_Godot/docs/decks/assets/enemies/goblin.png
cp 5_WeaponForge_Honkai_Godot/Prototype/godot/assets/generated/enemies/skeleton.png 5_WeaponForge_Honkai_Godot/docs/decks/assets/enemies/skeleton.png
```

Expected: 3 files in `assets/enemies/`.

- [ ] **Step 4: Copy weapon parts**

```bash
cp 5_WeaponForge_Honkai_Godot/Prototype/godot/assets/generated/parts/r_fire.png 5_WeaponForge_Honkai_Godot/docs/decks/assets/parts/r_fire.png
cp 5_WeaponForge_Honkai_Godot/Prototype/godot/assets/generated/parts/r_ice.png 5_WeaponForge_Honkai_Godot/docs/decks/assets/parts/r_ice.png
cp 5_WeaponForge_Honkai_Godot/Prototype/godot/assets/generated/parts/r_pierce.png 5_WeaponForge_Honkai_Godot/docs/decks/assets/parts/r_pierce.png
cp 5_WeaponForge_Honkai_Godot/Prototype/godot/assets/generated/parts/h_iron_edge.png 5_WeaponForge_Honkai_Godot/docs/decks/assets/parts/h_iron_edge.png
cp 5_WeaponForge_Honkai_Godot/Prototype/godot/assets/generated/parts/p_steel_grip.png 5_WeaponForge_Honkai_Godot/docs/decks/assets/parts/p_steel_grip.png
```

Expected: 5 files in `assets/parts/`.

- [ ] **Step 5: Copy the Bran 5-tier**

```bash
cp 5_WeaponForge_Honkai_Godot/docs/research/portrait-tier-test/bran_5tier_evolution.png 5_WeaponForge_Honkai_Godot/docs/decks/assets/bran_5tier.png
```

Expected: `bran_5tier.png` exists in `assets/`.

- [ ] **Step 6: Verify asset count + total size**

```bash
find 5_WeaponForge_Honkai_Godot/docs/decks/assets -type f | wc -l
du -sh 5_WeaponForge_Honkai_Godot/docs/decks/assets
```

Expected: 12 files, total under 3 MB. If over 3 MB, flag for owner — may need optimization in a later task.

- [ ] **Step 7: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/decks/assets
git commit -m "deck(d-1): copy game assets into docs/decks/assets/"
```

---

### Task 2: HTML scaffold

**Files:**
- Create: `docs/teammate-deck.html`

- [ ] **Step 1: Write the scaffold file**

Create `5_WeaponForge_Honkai_Godot/docs/teammate-deck.html` with this content:

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta name="theme-color" content="#0a0710">
  <title>WeaponForge — for teammates</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Cinzel:wght@500;700&family=Manrope:wght@400;600&family=JetBrains+Mono:wght@400&display=swap">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cinzel:wght@500;700&family=Manrope:wght@400;600&family=JetBrains+Mono:wght@400&display=swap">

  <link rel="stylesheet" href="decks/style.css">
</head>
<body>
  <svg aria-hidden="true" width="0" height="0" style="position:absolute">
    <defs>
      <filter id="hammered-noise">
        <feTurbulence type="fractalNoise" baseFrequency="0.85" numOctaves="2" seed="3"/>
        <feColorMatrix values="0 0 0 0 0.05  0 0 0 0 0.04  0 0 0 0 0.07  0 0 0 0.06 0"/>
      </filter>
    </defs>
  </svg>

  <nav class="deck-nav" aria-label="Section navigation">
    <a href="#hero" class="deck-nav__brand">⚒ WEAPONFORGE</a>
    <ul class="deck-nav__list">
      <li><a href="#bet">Bet</a></li>
      <li><a href="#what">What</a></li>
      <li><a href="#roster">Roster</a></li>
      <li><a href="#loop">Loop</a></li>
      <li><a href="#build">Build</a></li>
      <li><a href="#next">Next</a></li>
    </ul>
  </nav>

  <main>
    <section id="hero" class="section section--hero"></section>
    <section id="bet" class="section section--bet"></section>
    <section id="what" class="section section--what"></section>
    <section id="roster" class="section section--roster"></section>
    <section id="loop" class="section section--loop"></section>
    <section id="build" class="section section--build"></section>
    <section id="next" class="section section--next"></section>
  </main>

  <script src="decks/scrub.js" defer></script>
</body>
</html>
```

- [ ] **Step 2: Verify the file opens in a browser**

Run:

```bash
ls -la 5_WeaponForge_Honkai_Godot/docs/teammate-deck.html
```

Expected: file exists, non-zero size. Manually: open in a browser. Expected: blank dark-ish page (default browser styles), no console errors, fonts begin loading.

- [ ] **Step 3: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/teammate-deck.html
git commit -m "deck(d-1): HTML scaffold — semantic sections + sticky nav placeholders"
```

---

### Task 3: CSS theme tokens + base typography

**Files:**
- Create: `docs/decks/style.css`

- [ ] **Step 1: Write the CSS theme**

Create `5_WeaponForge_Honkai_Godot/docs/decks/style.css` with:

```css
/* ======================================================================
   WeaponForge teammate deck — style.css
   Forge industrial × anime rondel.
   Spec: docs/superpowers/specs/2026-06-09-teammate-deck-design.md
   ====================================================================== */

:root {
  /* Forge palette (spec §4) */
  --iron-deep:  #0a0710;
  --iron:       #14101c;
  --iron-2:     #1f1a2a;
  --amber:      #e8a23a;
  --ember:      #ff6b3d;
  --gold-leaf:  #c9a85c;
  --parchment:  #f0e6d6;
  --mute:       #6f6552;
  --link:       #ffb45c;

  /* Rarity (reused from in-game home_screen.gd) */
  --rarity-c: #8c8c8c;
  --rarity-r: #5aa6ff;
  --rarity-e: #bf66ff;
  --rarity-l: #ffbf40;
  --rarity-m: #ff4c4c;

  /* Type */
  --font-display: "Cinzel", Georgia, serif;
  --font-body:    "Manrope", system-ui, -apple-system, sans-serif;
  --font-mono:    "JetBrains Mono", ui-monospace, "SF Mono", monospace;

  /* Rhythm */
  --max-w:    1120px;
  --gutter:   clamp(20px, 4vw, 56px);
  --section-py: clamp(64px, 8vw, 128px);
  --radius-sm: 6px;
  --radius-md: 12px;
}

/* ----------------------------------- reset (minimal) */
*, *::before, *::after { box-sizing: border-box; }
html { -webkit-text-size-adjust: 100%; scroll-behavior: smooth; }
body {
  margin: 0;
  background: var(--iron-deep);
  color: var(--parchment);
  font-family: var(--font-body);
  font-weight: 400;
  font-size: 16px;
  line-height: 1.55;
  -webkit-font-smoothing: antialiased;
}

img, svg { max-width: 100%; height: auto; }

/* ----------------------------------- typography */
h1, h2, h3 { font-family: var(--font-display); font-weight: 700; letter-spacing: 0.04em; line-height: 1.1; margin: 0; }
h1 { font-size: clamp(48px, 8vw, 96px); text-transform: uppercase; }
h2 { font-size: clamp(28px, 4.2vw, 44px); text-transform: uppercase; color: var(--amber); }
h3 { font-size: clamp(18px, 2.6vw, 22px); text-transform: uppercase; color: var(--gold-leaf); }
p  { margin: 0 0 1em; }
a  { color: var(--link); text-decoration: none; border-bottom: 1px solid color-mix(in srgb, var(--link) 35%, transparent); }
a:hover, a:focus { color: var(--amber); border-bottom-color: var(--amber); }
code, pre { font-family: var(--font-mono); font-size: 0.92em; }

/* ----------------------------------- nav */
.deck-nav {
  position: sticky;
  top: 0;
  z-index: 50;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px var(--gutter);
  background: color-mix(in srgb, var(--iron-deep) 92%, transparent);
  backdrop-filter: blur(8px);
  border-bottom: 1px solid color-mix(in srgb, var(--gold-leaf) 18%, transparent);
}
.deck-nav__brand {
  font-family: var(--font-display);
  font-weight: 700;
  font-size: 16px;
  letter-spacing: 0.18em;
  color: var(--parchment);
  border: 0;
}
.deck-nav__list { display: flex; gap: 24px; list-style: none; margin: 0; padding: 0; }
.deck-nav__list a {
  font-family: var(--font-display);
  font-size: 12px;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--mute);
  border: 0;
}
.deck-nav__list a:hover, .deck-nav__list a:focus { color: var(--amber); }

/* ----------------------------------- section */
.section {
  position: relative;
  padding: var(--section-py) var(--gutter);
  background: var(--iron);
  overflow: hidden;
}
.section::before {  /* hammered noise overlay (4%) */
  content: "";
  position: absolute;
  inset: 0;
  filter: url(#hammered-noise);
  pointer-events: none;
  opacity: 0.4;
  z-index: 0;
}
.section > * { position: relative; z-index: 1; }
.section + .section { border-top: 0; }  /* dividers added in Task 5 */

/* ----------------------------------- focus rings (a11y) */
:focus-visible {
  outline: 2px solid var(--ember);
  outline-offset: 4px;
}

/* ----------------------------------- mobile */
@media (max-width: 768px) {
  .deck-nav { flex-direction: column; gap: 8px; padding: 8px var(--gutter); }
  .deck-nav__list { gap: 14px; flex-wrap: wrap; justify-content: center; }
}
```

- [ ] **Step 2: Verify CSS loads and theme renders**

Open `docs/teammate-deck.html` in a browser. Expected:
- Page background = `--iron-deep` (very dark blue-black).
- Sticky nav at top with "⚒ WEAPONFORGE" brand left + 6 nav links right.
- Section areas show `--iron` (slightly lighter dark) with a faint noise texture.
- Cinzel font visible on the brand text (carved-Roman caps).
- No console errors.

- [ ] **Step 3: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/decks/style.css
git commit -m "deck(d-1): CSS theme tokens, base typography, sticky nav, noise atmosphere"
```

---

### Task 4: Gold-leaf engraved divider SVG between sections

**Files:**
- Modify: `docs/decks/style.css` (append divider rule)
- Modify: `docs/teammate-deck.html` (add an inline divider SVG between sections)

- [ ] **Step 1: Add the divider SVG definition into the inline `<defs>` block**

In `docs/teammate-deck.html`, replace the existing `<defs>` content with:

```html
<defs>
  <filter id="hammered-noise">
    <feTurbulence type="fractalNoise" baseFrequency="0.85" numOctaves="2" seed="3"/>
    <feColorMatrix values="0 0 0 0 0.05  0 0 0 0 0.04  0 0 0 0 0.07  0 0 0 0.06 0"/>
  </filter>
  <symbol id="divider-engraved" viewBox="0 0 1200 24" preserveAspectRatio="none">
    <line x1="0" y1="12" x2="1200" y2="12" stroke="currentColor" stroke-width="1" stroke-dasharray="2 6" opacity="0.5"/>
    <path d="M560 6 L600 18 L640 6" fill="none" stroke="currentColor" stroke-width="1.5"/>
    <circle cx="600" cy="18" r="2.5" fill="currentColor"/>
  </symbol>
</defs>
```

- [ ] **Step 2: Add a divider element between every section**

In `docs/teammate-deck.html`, between each `<section>` element inside `<main>`, insert:

```html
<svg class="divider-engraved" role="presentation" aria-hidden="true"><use href="#divider-engraved"/></svg>
```

So the `<main>` becomes:

```html
<main>
  <section id="hero" class="section section--hero"></section>
  <svg class="divider-engraved" role="presentation" aria-hidden="true"><use href="#divider-engraved"/></svg>
  <section id="bet" class="section section--bet"></section>
  <svg class="divider-engraved" role="presentation" aria-hidden="true"><use href="#divider-engraved"/></svg>
  <section id="what" class="section section--what"></section>
  <svg class="divider-engraved" role="presentation" aria-hidden="true"><use href="#divider-engraved"/></svg>
  <section id="roster" class="section section--roster"></section>
  <svg class="divider-engraved" role="presentation" aria-hidden="true"><use href="#divider-engraved"/></svg>
  <section id="loop" class="section section--loop"></section>
  <svg class="divider-engraved" role="presentation" aria-hidden="true"><use href="#divider-engraved"/></svg>
  <section id="build" class="section section--build"></section>
  <svg class="divider-engraved" role="presentation" aria-hidden="true"><use href="#divider-engraved"/></svg>
  <section id="next" class="section section--next"></section>
</main>
```

- [ ] **Step 3: Style the divider in `docs/decks/style.css`**

Append to the end of `style.css`:

```css
/* ----------------------------------- engraved dividers */
.divider-engraved {
  display: block;
  width: 100%;
  height: 24px;
  color: var(--gold-leaf);
  background: var(--iron-deep);
  opacity: 0.7;
}
```

- [ ] **Step 4: Verify dividers render**

Open the deck in a browser. Expected:
- A thin dashed gold-leaf line with a small chevron + dot motif appears between each section.
- Lines span the full width.
- No console errors.

- [ ] **Step 5: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/teammate-deck.html 5_WeaponForge_Honkai_Godot/docs/decks/style.css
git commit -m "deck(d-1): inline SVG engraved gold-leaf section dividers"
```

---

### Task 5: scrub.js stub (just a no-op for now)

**Files:**
- Create: `docs/decks/scrub.js`

This task creates the JS file as an empty no-op so the `<script>` tag in HTML doesn't 404. Real logic lands in Chunk D-3.

- [ ] **Step 1: Create the stub file**

Create `5_WeaponForge_Honkai_Godot/docs/decks/scrub.js` with:

```js
/* WeaponForge teammate deck — scrub.js
   Bran 5-tier scrubber + IntersectionObserver for engraved dividers.
   Stub for Chunk D-1; real logic added in Chunk D-3. */
(() => {
  "use strict";
  // intentionally empty until Chunk D-3
})();
```

- [ ] **Step 2: Verify no 404**

Open the deck in a browser, open DevTools Network tab. Expected: `decks/scrub.js` loads with 200 status (or `file://` equivalent — the file resolves).

- [ ] **Step 3: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/decks/scrub.js
git commit -m "deck(d-1): scrub.js stub (logic lands in D-3)"
```

---

### Task 6: D-1 manual sanity check

- [ ] **Step 1: Open the deck in Chrome and Firefox**

Open `5_WeaponForge_Honkai_Godot/docs/teammate-deck.html` in both browsers.

Checklist:
- [ ] Page loads with dark `--iron-deep` background.
- [ ] Sticky nav visible at top with brand left + 6 anchor links right.
- [ ] Cinzel font on the brand text (carved caps look).
- [ ] Manrope font on the nav links.
- [ ] 7 section blocks visible (mostly empty), each with `--iron` background + faint noise.
- [ ] 6 engraved gold-leaf divider lines between sections.
- [ ] Clicking nav links smooth-scrolls to each section.
- [ ] No console errors, no 404s in Network tab.

- [ ] **Step 2: Mobile responsive check**

DevTools → Device toolbar → iPhone 12 (390×844) or any ≤768 px viewport.

Checklist:
- [ ] Nav stacks vertically (brand on top, links wrapping below).
- [ ] All sections still render with noise + dividers.
- [ ] No horizontal scroll.

- [ ] **Step 3: Mark D-1 complete (no commit; nothing to commit)**

If all checks pass, Chunk D-1 is done. Proceed to Chunk D-2 (content).

---

## CHUNK D-2 — Content

Goal: fill all 7 sections with copy + assets + `<details>` collapsibles. Roster has placeholders for the Bran scrubber + the TBD-hero silhouettes. Loop has the ASCII diagram. Build has the static timeline + right rail. No motion yet.

---

### Task 7: Section 1 — Hero (wordmark, tagline, portrait trio, anvil silhouette, stat ribbon)

**Files:**
- Modify: `docs/teammate-deck.html` (fill `<section id="hero">`)
- Modify: `docs/decks/style.css` (append hero styles + anvil SVG via background data URL or inline)

- [ ] **Step 1: Add anvil silhouette to the inline `<defs>`**

In `docs/teammate-deck.html`, inside the existing `<defs>`, add this symbol definition (alongside `hammered-noise` and `divider-engraved`):

```html
<symbol id="anvil" viewBox="0 0 200 120" preserveAspectRatio="xMidYMid meet">
  <path d="M40 90 L40 70 Q40 50 70 50 L130 50 Q160 50 160 70 L160 90 Z M70 50 L70 30 L130 30 L130 50 Z M20 90 L180 90 L170 110 L30 110 Z" fill="currentColor"/>
</symbol>
```

- [ ] **Step 2: Replace `<section id="hero">` body with hero content**

Replace the empty `<section id="hero" class="section section--hero"></section>` with:

```html
<section id="hero" class="section section--hero">
  <div class="hero-bg" aria-hidden="true">
    <svg class="hero-anvil"><use href="#anvil"/></svg>
  </div>
  <div class="hero-grid">
    <div class="hero-text">
      <h1 class="hero-title">
        <span style="--i:0">W</span><span style="--i:1">E</span><span style="--i:2">A</span><span style="--i:3">P</span><span style="--i:4">O</span><span style="--i:5">N</span><span style="--i:6">F</span><span style="--i:7">O</span><span style="--i:8">R</span><span style="--i:9">G</span><span style="--i:10">E</span>
      </h1>
      <p class="hero-tagline">
        Casual-mobile RPG.<br>
        You pull <em>weapons</em>. You bond with <em>heroes</em>.
      </p>
      <p class="hero-ribbon">
        prototype build  ·  5-wave stages  ·  3-boss rotation  ·  forked 2026-06-01
      </p>
    </div>
    <div class="hero-portraits" aria-label="Founding heroes: Bran, Elara, Vex">
      <div class="rondel rondel--bran"><img src="decks/assets/heroes/bran.png" alt="Bran the warrior"></div>
      <div class="rondel rondel--elara"><img src="decks/assets/heroes/elara.png" alt="Elara the mage"></div>
      <div class="rondel rondel--vex"><img src="decks/assets/heroes/vex.png" alt="Vex the rogue"></div>
    </div>
  </div>
</section>
```

- [ ] **Step 3: Append hero CSS**

Append to `docs/decks/style.css`:

```css
/* ----------------------------------- hero */
.section--hero {
  background: radial-gradient(ellipse at 35% 40%, color-mix(in srgb, var(--ember) 18%, transparent) 0%, transparent 60%), var(--iron);
  min-height: 100svh;
  display: flex; align-items: center;
}
.hero-bg {
  position: absolute; inset: 0;
  display: flex; align-items: center; justify-content: center;
  pointer-events: none;
  z-index: 0;
}
.hero-anvil {
  width: 80%; max-width: 800px; height: auto;
  color: var(--iron-2);
  opacity: 0.18;
}
.hero-grid {
  position: relative; z-index: 1;
  max-width: var(--max-w); margin: 0 auto;
  display: grid;
  grid-template-columns: 6fr 4fr;
  gap: var(--gutter);
  align-items: center;
}
.hero-title { font-size: clamp(64px, 10vw, 128px); color: var(--parchment); letter-spacing: 0.06em; }
.hero-title span { display: inline-block; }
.hero-tagline { font-size: clamp(18px, 2.4vw, 24px); color: var(--parchment); max-width: 36ch; margin-top: 24px; }
.hero-tagline em { color: var(--amber); font-style: normal; font-weight: 600; }
.hero-ribbon {
  margin-top: 32px;
  font-family: var(--font-mono);
  font-size: 12px;
  color: var(--mute);
  letter-spacing: 0.05em;
}
.hero-portraits {
  display: grid;
  grid-template-areas: ". bran ." "elara . vex" ". . .";
  grid-template-columns: 1fr 1fr 1fr;
  gap: 12px;
  align-items: center;
  justify-items: center;
}
.rondel {
  width: 140px; height: 140px;
  border-radius: 50%;
  overflow: hidden;
  border: 3px solid var(--gold-leaf);
  background: var(--iron-2);
  box-shadow: 0 8px 24px rgba(0,0,0,0.6), inset 0 0 0 2px var(--iron);
}
.rondel img { width: 100%; height: 100%; object-fit: cover; object-position: top center; }
.rondel--bran  { grid-area: bran; }
.rondel--elara { grid-area: elara; }
.rondel--vex   { grid-area: vex; }

@media (max-width: 768px) {
  .hero-grid { grid-template-columns: 1fr; gap: 32px; }
  .rondel { width: 110px; height: 110px; }
}
```

- [ ] **Step 4: Verify visually**

Open the deck in a browser. Expected:
- Hero section fills most of the viewport.
- Faint ember-radial glow behind the title area.
- Anvil silhouette visible (dark, ~18% opacity) centered behind.
- "WEAPONFORGE" in carved Cinzel caps, parchment color.
- Tagline + ribbon below, mono-font on the ribbon.
- 3 hero portraits in a diamond formation on the right, each in a gold-bordered circle.
- No console errors.

- [ ] **Step 5: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/teammate-deck.html 5_WeaponForge_Honkai_Godot/docs/decks/style.css
git commit -m "deck(d-2): hero section — wordmark, tagline, portrait trio, anvil silhouette"
```

---

### Task 8: Section 2 — The Bet

**Files:**
- Modify: `docs/teammate-deck.html` (fill `<section id="bet">`)
- Modify: `docs/decks/style.css` (append bet styles)

- [ ] **Step 1: Fill the section body**

Replace the empty `<section id="bet">` with:

```html
<section id="bet" class="section section--bet">
  <div class="section-inner">
    <h2>The Bet</h2>
    <div class="bet-grid">
      <div>
        <h3>Audience</h3>
        <p>Wittle Defender ∩ anime-curious. Casual-mobile RPG players who'd happily install a hero-collector but want more story than the genre normally delivers.</p>
      </div>
      <div>
        <h3>Inversion</h3>
        <p>Wittle pulls heroes. We pull <strong>weapons</strong>. The roster is locked at seven — you master a specific cast instead of chasing a slot machine. Time invested becomes character, not duplicate inventory.</p>
      </div>
      <div>
        <h3>Moat</h3>
        <p>Equipment-gacha is precedented (Archero $263M). Story-locked roster is unprecedented. <em>The combination is the moat.</em></p>
      </div>
    </div>
    <blockquote class="pull-quote">
      Forge weapons.<br>Bond with heroes.
    </blockquote>
    <details class="deep">
      <summary>Competitor landscape (1-paragraph synth)</summary>
      <p>50-game research set, 170 Sensor Tower API calls. Hero-gacha + auto-battler is crowded (AFK Arena, Honkai Star Rail, Wuthering Waves). Weapon-collection is rare and scattered (Archero is the closest analogue but is bullet-hell, not RPG). No competitor combines locked roster + weapon gacha + anime personality + casual auto-resolve combat — the lane is empty. Full doc: <a href="research/2026-05-28-competitor-landscape-synthesis.md">docs/research/2026-05-28-competitor-landscape-synthesis.md</a>.</p>
    </details>
  </div>
</section>
```

- [ ] **Step 2: Append bet CSS**

Append to `style.css`:

```css
/* ----------------------------------- section-inner (shared) */
.section-inner { max-width: var(--max-w); margin: 0 auto; }
.section-inner > h2 { margin-bottom: 32px; }

/* ----------------------------------- bet */
.bet-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 32px;
  margin: 24px 0;
}
.bet-grid h3 { margin-bottom: 8px; }
.bet-grid em, .bet-grid strong { color: var(--amber); font-style: normal; }
.pull-quote {
  font-family: var(--font-display);
  font-size: clamp(28px, 5vw, 56px);
  font-weight: 700;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  text-align: center;
  color: var(--amber);
  margin: 56px 0;
  padding: 32px 24px;
  border-top: 1px solid color-mix(in srgb, var(--gold-leaf) 35%, transparent);
  border-bottom: 1px solid color-mix(in srgb, var(--gold-leaf) 35%, transparent);
  position: relative;
}
.pull-quote::before, .pull-quote::after {
  content: "✦";
  color: var(--gold-leaf);
  font-size: 0.4em;
  position: absolute;
  left: 50%; transform: translateX(-50%);
}
.pull-quote::before { top: -10px; }
.pull-quote::after  { bottom: -10px; }

/* ----------------------------------- details (deep dive) */
details.deep {
  margin-top: 32px;
  padding: 16px 20px;
  background: var(--iron-2);
  border-left: 2px solid var(--gold-leaf);
  border-radius: var(--radius-sm);
}
details.deep summary {
  cursor: pointer;
  font-family: var(--font-display);
  font-size: 13px;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--gold-leaf);
  list-style: none;
  padding-right: 24px;
  position: relative;
}
details.deep summary::-webkit-details-marker { display: none; }
details.deep summary::after {
  content: "▸";
  position: absolute; right: 0; top: 0;
  transition: transform 0.18s ease;
  color: var(--amber);
}
details.deep[open] summary::after { transform: rotate(90deg); }
details.deep > :not(summary) { margin-top: 16px; color: var(--parchment); }

@media (max-width: 768px) {
  .bet-grid { grid-template-columns: 1fr; }
}
```

- [ ] **Step 3: Verify visually**

Open the deck. Expected:
- "THE BET" heading in amber Cinzel caps.
- 3-column grid w/ Audience / Inversion / Moat.
- Pull-quote big amber Cinzel between gold-leaf rules, centered.
- Collapsible "Competitor landscape" with a ▸ marker that rotates 90° on click.
- On mobile, columns stack.

- [ ] **Step 4: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/teammate-deck.html 5_WeaponForge_Honkai_Godot/docs/decks/style.css
git commit -m "deck(d-2): The Bet section — audience/inversion/moat + pull-quote + deep dive"
```

---

### Task 9: Section 3 — What is WeaponForge

**Files:**
- Modify: `docs/teammate-deck.html` (fill `<section id="what">`)
- Modify: `docs/decks/style.css` (append what styles)

- [ ] **Step 1: Fill the section body**

Replace the empty `<section id="what">` with:

```html
<section id="what" class="section section--what">
  <div class="section-inner">
    <h2>What is WeaponForge</h2>
    <div class="what-grid">
      <div class="what-col">
        <h3>Pull</h3>
        <img src="decks/assets/parts/r_fire.png" alt="Fire rune" class="what-icon">
        <p>A slot-machine Forge Wheel drops <strong>weapons</strong> for your locked roster. Pull a Common, a Rare, an Epic. Forge them up. Star them up. The economy revolves around weapons, not heroes.</p>
      </div>
      <div class="what-col">
        <h3>Equip</h3>
        <img src="decks/assets/heroes/elara.png" alt="Elara the mage" class="what-icon what-icon--portrait">
        <p>Three heroes deploy per stage, drawn from a locked cast of seven. Each weapon ties to a class and an element. The squad you choose <em>is</em> the strategy.</p>
      </div>
      <div class="what-col">
        <h3>Fight</h3>
        <img src="decks/assets/enemies/slime.png" alt="A slime enemy" class="what-icon">
        <p>Side-view auto-resolve combat. Five waves per stage; boss on wave 5. Mid-wave the kill meter fills → combat pauses → pick a Forge Draft card → resume. Single-tap ultimates.</p>
      </div>
    </div>
    <details class="deep">
      <summary>The first 10 minutes (FTUE arc)</summary>
      <ul>
        <li>Boot → 5 Ember granted → 3 starter weapons equipped on Bran / Elara / Vex.</li>
        <li>Stage 1 begins. Elara unlocks on Wave 3 cinematic. Vex on Wave 6.</li>
        <li>Wave 5 boss = Slime King. First Forge Draft modal opens between waves.</li>
        <li>Stage clear → +2 Ember → first Forge Wheel pull tutorialized. Pull #1 is scripted Fire-Bran-class.</li>
        <li>Stage 2-4 layers in: Counter-build (boss-weakness telegraph) → counter-loadout.</li>
        <li>~Stage 5: Pull #3 scripted Ice-Elara-class → first <strong>Catalyst</strong> triggers (Firestorm: 🔥+❄).</li>
      </ul>
    </details>
  </div>
</section>
```

- [ ] **Step 2: Append what CSS**

Append to `style.css`:

```css
/* ----------------------------------- what */
.what-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 40px;
  margin: 24px 0;
}
.what-col {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}
.what-col h3 { margin-bottom: 16px; }
.what-icon {
  width: 64px; height: 64px;
  object-fit: contain;
  margin-bottom: 16px;
  filter: drop-shadow(0 4px 12px rgba(0,0,0,0.5));
}
.what-icon--portrait {
  width: 96px; height: 96px;
  object-fit: cover;
  border-radius: 50%;
  border: 2px solid var(--gold-leaf);
  object-position: top center;
}
.what-col em, .what-col strong { color: var(--amber); font-style: normal; }

@media (max-width: 768px) {
  .what-grid { grid-template-columns: 1fr; gap: 32px; }
}
```

- [ ] **Step 3: Verify visually**

Open the deck. Expected:
- "WHAT IS WEAPONFORGE" heading.
- 3 columns: Pull (fire rune icon) / Equip (Elara portrait round) / Fight (slime icon).
- Collapsible "The first 10 minutes" with a bulleted list.

- [ ] **Step 4: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/teammate-deck.html 5_WeaponForge_Honkai_Godot/docs/decks/style.css
git commit -m "deck(d-2): What is WeaponForge — pull/equip/fight + FTUE deep dive"
```

---

### Task 10: Section 4 — The Roster (the moat, w/ Bran 5-tier scrubber placeholder)

**Files:**
- Modify: `docs/teammate-deck.html` (fill `<section id="roster">`)
- Modify: `docs/decks/style.css` (append roster styles + scrubber styles)

The scrubber JS lands in D-3 Task 16; this task wires the HTML/CSS shell so it's ready.

- [ ] **Step 1: Fill the section body**

Replace the empty `<section id="roster">` with:

```html
<section id="roster" class="section section--roster">
  <div class="section-inner">
    <h2>The Roster — the moat</h2>
    <p class="roster-intro">Seven heroes. Locked. The cast you master, the bond you build. <em>Equipment is the gacha. People are the lore.</em></p>
    <div class="roster-grid">

      <article class="hero-card hero-card--big" data-status="ftue" data-rot="-1">
        <div class="hero-card__rondel">
          <img id="bran-scrub" src="decks/assets/bran_5tier.png" alt="Bran portrait at tier 1" data-tier="0">
        </div>
        <h3>Bran</h3>
        <p class="hero-card__class">Warrior · FTUE</p>
        <p class="hero-card__blurb">Stoic, dependable, takes the front. Anchor of every starter squad. Inherited his father's hammer.</p>
        <div class="scrubber">
          <label for="bran-tier" class="scrubber__label" id="bran-tier-label">Tier 1 · Apprentice</label>
          <input id="bran-tier" type="range" min="0" max="4" step="1" value="0" aria-labelledby="bran-tier-label">
          <div class="scrubber__hint">drag to evolve ★1 → ★5</div>
        </div>
      </article>

      <article class="hero-card" data-status="ftue" data-rot="+1">
        <div class="hero-card__rondel"><img src="decks/assets/heroes/elara.png" alt="Elara"></div>
        <h3>Elara</h3>
        <p class="hero-card__class">Mage · FTUE</p>
        <p class="hero-card__blurb">Quiet prodigy. Frost-bolt scholar with a secret meteor lineage. Signature arc unlocks her tree.</p>
      </article>

      <article class="hero-card" data-status="ftue" data-rot="-1">
        <div class="hero-card__rondel"><img src="decks/assets/heroes/vex.png" alt="Vex"></div>
        <h3>Vex</h3>
        <p class="hero-card__class">Rogue · FTUE</p>
        <p class="hero-card__blurb">From the shadow corps. Critting on his off-hand is the love language. Pairs explosively with Elara's chain.</p>
      </article>

      <article class="hero-card" data-status="tbd" data-rot="+1">
        <div class="hero-card__rondel hero-card__rondel--silhouette">
          <span aria-hidden="true">?</span>
        </div>
        <h3>Hot Paladin</h3>
        <p class="hero-card__class">Lance · Stage 2</p>
        <p class="hero-card__blurb">Descends mid-stage in a scripted-defeat cinematic. The FM-8 hero-bond probe.</p>
      </article>

      <article class="hero-card" data-status="tbd" data-rot="-1">
        <div class="hero-card__rondel hero-card__rondel--silhouette">
          <span aria-hidden="true">?</span>
        </div>
        <h3>2nd Rogue</h3>
        <p class="hero-card__class">Rogue variant · TBD</p>
        <p class="hero-card__blurb">Personality + identity to be designed. Mid-game unlock.</p>
      </article>

      <article class="hero-card" data-status="tbd" data-rot="+1">
        <div class="hero-card__rondel hero-card__rondel--silhouette">
          <span aria-hidden="true">?</span>
        </div>
        <h3>2nd Mage</h3>
        <p class="hero-card__class">Mage variant · TBD</p>
        <p class="hero-card__blurb">Personality + identity to be designed. Mid-game unlock.</p>
      </article>

      <article class="hero-card" data-status="tbd" data-rot="-1">
        <div class="hero-card__rondel hero-card__rondel--silhouette">
          <span aria-hidden="true">?</span>
        </div>
        <h3>Hot Assassin</h3>
        <p class="hero-card__class">Assassin · TBD</p>
        <p class="hero-card__blurb">Personality + identity to be designed. Late-game unlock.</p>
      </article>

    </div>
    <details class="deep">
      <summary>Why a locked roster?</summary>
      <p>Hero-collectors win on power-fantasy variety; we win on attachment. A locked 7-hero cast means each character can carry actual personality + story without diluting it across hundreds of pulls. The pre-mortem flag here (FM-1) is "players raised on Archero / AFK Arena expect to collect heroes too." Mitigation: weapon gacha satisfies the slot-machine itch, while the locked cast is sold as "your mains" — the language of competitive games, not gachas.</p>
    </details>
  </div>
</section>
```

- [ ] **Step 2: Append roster CSS**

Append to `style.css`:

```css
/* ----------------------------------- roster */
.roster-intro { font-size: 18px; max-width: 60ch; color: var(--parchment); margin-bottom: 40px; }
.roster-intro em { color: var(--gold-leaf); font-style: normal; }
.roster-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 32px 24px;
  margin-top: 32px;
}
.hero-card {
  background: var(--iron-2);
  border: 1px solid color-mix(in srgb, var(--gold-leaf) 25%, transparent);
  border-radius: var(--radius-md);
  padding: 20px;
  display: flex; flex-direction: column; align-items: center;
  text-align: center;
  transform: rotate(calc(var(--rot, 0) * 1deg));
  transition: transform 0.2s ease;
}
.hero-card[data-rot="-1"] { --rot: -1; }
.hero-card[data-rot="+1"] { --rot: 1; }
.hero-card:hover { transform: rotate(0); }
.hero-card--big {
  grid-column: span 2;
  grid-row: span 2;
  background: linear-gradient(180deg, color-mix(in srgb, var(--amber) 8%, var(--iron-2)) 0%, var(--iron-2) 100%);
  border-color: var(--amber);
}
.hero-card__rondel {
  width: 120px; height: 120px;
  border-radius: 50%;
  overflow: hidden;
  border: 3px solid var(--gold-leaf);
  background: var(--iron);
  margin-bottom: 16px;
  position: relative;
}
.hero-card--big .hero-card__rondel { width: 180px; height: 180px; border-color: var(--amber); }
.hero-card__rondel img { width: 100%; height: 100%; object-fit: cover; object-position: top center; }
.hero-card__rondel--silhouette {
  display: flex; align-items: center; justify-content: center;
  background: radial-gradient(circle, var(--iron-2) 0%, var(--iron) 100%);
  border-style: dashed;
  border-color: var(--mute);
  color: var(--mute);
}
.hero-card__rondel--silhouette span {
  font-family: var(--font-display);
  font-size: 56px;
  font-weight: 700;
  opacity: 0.6;
}
.hero-card h3 { margin-bottom: 4px; color: var(--parchment); font-size: 20px; }
.hero-card--big h3 { font-size: 28px; color: var(--amber); }
.hero-card__class {
  font-family: var(--font-mono);
  font-size: 11px;
  color: var(--mute);
  letter-spacing: 0.1em;
  text-transform: uppercase;
  margin-bottom: 12px;
}
.hero-card[data-status="ftue"] .hero-card__class { color: var(--rarity-l); }
.hero-card[data-status="tbd"] .hero-card__class  { color: var(--mute); }
.hero-card__blurb { color: var(--parchment); font-size: 14px; line-height: 1.45; }

/* Bran 5-tier scrubber */
.scrubber { width: 100%; margin-top: 16px; padding-top: 16px; border-top: 1px solid color-mix(in srgb, var(--gold-leaf) 25%, transparent); }
.scrubber__label {
  display: block;
  font-family: var(--font-display);
  font-size: 13px;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--amber);
  margin-bottom: 8px;
}
.scrubber input[type=range] {
  width: 100%;
  -webkit-appearance: none;
  appearance: none;
  background: transparent;
}
.scrubber input[type=range]::-webkit-slider-runnable-track,
.scrubber input[type=range]::-moz-range-track {
  height: 4px;
  background: var(--iron);
  border-radius: 2px;
}
.scrubber input[type=range]::-webkit-slider-thumb,
.scrubber input[type=range]::-moz-range-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 16px; height: 16px;
  background: var(--amber);
  border: 0;
  border-radius: 4px;
  margin-top: -6px;
  box-shadow: 0 0 12px var(--ember);
  cursor: pointer;
}
.scrubber__hint {
  font-family: var(--font-mono);
  font-size: 11px;
  color: var(--mute);
  margin-top: 6px;
  text-align: center;
}
/* Bran scrubber image is a 5-frame strip; object-position drives the visible tier.
   The source is 5 portraits wide (the existing bran_5tier_evolution.png). */
#bran-scrub {
  position: absolute; inset: 0;
  width: 500%;  /* 5 frames laid out side by side; the rondel masks to 1 frame */
  height: 100%;
  object-fit: cover;
  object-position: 0% center;
  transition: transform 0.2s ease;
}

@media (max-width: 1024px) { .roster-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 768px)  { .roster-grid { grid-template-columns: 1fr; } .hero-card--big { grid-column: span 1; grid-row: span 1; } }
```

- [ ] **Step 3: Verify visually**

Open the deck. Expected:
- "THE ROSTER — THE MOAT" heading.
- 4-column grid (or 2 on mid, 1 on mobile) of hero cards.
- Bran card is bigger (spans 2×2 grid cells) with the 5-tier image visible.
- 3 FTUE cards (Bran/Elara/Vex) have real portraits.
- 4 TBD cards have dashed circles with a `?` placeholder.
- Each card subtly rotates −1°/+1°. On hover, rotates back to 0.
- The scrubber slider is visible under the Bran portrait. Dragging it doesn't yet change the portrait (JS lands in D-3); the label says "Tier 1 · Apprentice".

- [ ] **Step 4: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/teammate-deck.html 5_WeaponForge_Honkai_Godot/docs/decks/style.css
git commit -m "deck(d-2): Roster section — 7 cards (3 FTUE + 4 silhouettes) + Bran scrubber shell"
```

---

### Task 11: Section 5 — The Loop

**Files:**
- Modify: `docs/teammate-deck.html` (fill `<section id="loop">`)
- Modify: `docs/decks/style.css` (append loop styles)

- [ ] **Step 1: Fill the section body**

Replace the empty `<section id="loop">` with:

```html
<section id="loop" class="section section--loop">
  <div class="section-inner">
    <h2>The Loop</h2>
    <div class="loop-grid">
      <pre class="loop-ascii" aria-label="Core gameplay loop diagram">
       ┌──────── HOME ────────┐
       │  pull → equip       │
       │  briefing telegraph │
       └──────────┬──────────┘
                  │
                  ▼
       ┌────── STAGE ─────────┐
       │ W1 → W2 → W3 → W4    │
       │ ↓ mid-wave: meter    │
       │ ↓ Forge Draft pick   │
       │ W5 = BOSS            │
       └──────────┬───────────┘
                  │
                  ▼
       ┌──── reward / wipe ───┐
       │ +Ember +stage++      │
       │ heroes restored      │
       └──────────┬───────────┘
                  │
                  └──→ back to HOME
      </pre>
      <div class="loop-axes">
        <h3>Three progression axes</h3>
        <ol>
          <li><strong>Counter-build</strong> <span class="axis-status axis-status--shipped">shipped</span> — pre-stage briefing tells you the boss + minion weak/resist; you pick a squad that exploits it.</li>
          <li><strong>Catalyst</strong> <span class="axis-status axis-status--inflight">in-flight</span> — squad element-pairs trigger named compound buffs (Firestorm, Wildfire, Plasma...). Cap-1 stages 1-4, no-cap stages 5+.</li>
          <li><strong>Forge Wheel</strong> <span class="axis-status axis-status--shipped">shipped</span> — the weapon gacha. Ember currency, dupe-into-gems, shard-into-rarity, gem-into-star-up.</li>
        </ol>
      </div>
    </div>
    <details class="deep">
      <summary>The 5-wave stage shape</summary>
      <p>Five waves per stage. Boss on wave 5. The boss rotates by stage: Slime King → Iron Golem → Arcane Lich → repeat (with per-stage scaling). Slime heals to 50%, Golem windups + AoE-slams, Lich phase-shifts at 33% HP. The Forge Draft modal opens mid-stage when the kill-meter fills; on the W5 boss wave it shows 5 cards instead of 3. Heroes restored to full HP at the start of every stage. Wipes route back to a loadout-adjust screen — no retry penalty.</p>
    </details>
    <details class="deep">
      <summary>What's a Catalyst? (6 FTUE compounds)</summary>
      <table class="compounds">
        <thead><tr><th>Pair</th><th>Compound</th><th>v1 effect (Numbers Policy)</th></tr></thead>
        <tbody>
          <tr><td>🔥 + ❄</td><td>Firestorm</td><td>+20% squad ATK</td></tr>
          <tr><td>🔥 + 🌪</td><td>Wildfire</td><td>+15% ATK · +10% crit</td></tr>
          <tr><td>🔥 + ⚡</td><td>Plasma</td><td>+15% squad crit</td></tr>
          <tr><td>❄ + 🌪</td><td>Blizzard</td><td>−20% enemy attack speed</td></tr>
          <tr><td>❄ + ⚡</td><td>Glacial Storm</td><td>+15% squad ATK</td></tr>
          <tr><td>🌪 + ⚡</td><td>Stormfront</td><td>+25% ATK vs ≥3 enemies</td></tr>
        </tbody>
      </table>
      <p>Earth-pair compounds (Volcanic / Permafrost / Sandstorm / Magnetic Storm) gate at Stage 10. The first Catalyst reveal lands organically around Stage 4-5: Forge Wheel pull #1 is scripted Fire-Bran-class, pull #3 is Ice-Elara-class. Until then, starter weapons are non-elemental — preserving the stage-1 neutrality contract.</p>
    </details>
  </div>
</section>
```

- [ ] **Step 2: Append loop CSS**

Append to `style.css`:

```css
/* ----------------------------------- loop */
.loop-grid {
  display: grid;
  grid-template-columns: 6fr 4fr;
  gap: 40px;
  align-items: flex-start;
  margin-top: 24px;
}
.loop-ascii {
  font-family: var(--font-mono);
  font-size: 13px;
  line-height: 1.5;
  color: var(--parchment);
  background: var(--iron-2);
  border-left: 2px solid var(--gold-leaf);
  border-radius: var(--radius-sm);
  padding: 24px;
  margin: 0;
  white-space: pre;
  overflow-x: auto;
}
.loop-axes h3 { margin-bottom: 16px; color: var(--gold-leaf); }
.loop-axes ol { padding-left: 20px; margin: 0; }
.loop-axes li { margin-bottom: 14px; line-height: 1.5; }
.loop-axes strong { color: var(--amber); }
.axis-status {
  display: inline-block;
  font-family: var(--font-mono);
  font-size: 10px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  padding: 1px 8px;
  border-radius: 10px;
  margin-left: 6px;
  vertical-align: middle;
}
.axis-status--shipped  { background: color-mix(in srgb, var(--rarity-r) 22%, transparent); color: var(--rarity-r); }
.axis-status--inflight { background: color-mix(in srgb, var(--amber) 22%, transparent); color: var(--amber); }

.compounds { width: 100%; border-collapse: collapse; margin-top: 8px; font-size: 14px; }
.compounds th, .compounds td { padding: 8px 12px; text-align: left; border-bottom: 1px solid color-mix(in srgb, var(--gold-leaf) 18%, transparent); }
.compounds th { color: var(--gold-leaf); font-family: var(--font-display); font-size: 12px; letter-spacing: 0.12em; text-transform: uppercase; }

@media (max-width: 768px) { .loop-grid { grid-template-columns: 1fr; } .loop-ascii { font-size: 11px; } }
```

- [ ] **Step 3: Verify visually**

Open the deck. Expected:
- "THE LOOP" heading.
- 2-column layout: ASCII diagram left, "Three progression axes" list right.
- Two collapsibles below: "The 5-wave stage shape" + "What's a Catalyst? (6 FTUE compounds)" w/ a table.

- [ ] **Step 4: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/teammate-deck.html 5_WeaponForge_Honkai_Godot/docs/decks/style.css
git commit -m "deck(d-2): The Loop section — ASCII diagram + 3 axes + stage + Catalyst deep dives"
```

---

### Task 12: Section 6 — The Build (status timeline + right rail)

**Files:**
- Modify: `docs/teammate-deck.html` (fill `<section id="build">`)
- Modify: `docs/decks/style.css` (append build styles)

- [ ] **Step 1: Fill the section body**

Replace the empty `<section id="build">` with:

```html
<section id="build" class="section section--build">
  <div class="section-inner">
    <h2>The Build</h2>
    <div class="build-grid">
      <ol class="forge-log" aria-label="Build milestones">
        <li class="forge-log__item" data-status="done">
          <time>2026-06-01</time>
          <h3>Forked from Weaponcraft</h3>
          <p>Hot-fork e958745. Frozen playtester build preserved at ../2_Weaponcraft_Godot/.</p>
        </li>
        <li class="forge-log__item" data-status="done">
          <time>2026-06-01</time>
          <h3>P1a — WeaponData unitary schema</h3>
          <p>10/10 tests green. New combat-interface methods landed (get_atk / get_crit / get_ult_rate / get_all_tags / get_hp_bonus).</p>
        </li>
        <li class="forge-log__item" data-status="done">
          <time>2026-06-02</time>
          <h3>Game Frame</h3>
          <p>HOME → STAGE → BOSS loop playable end-to-end. 368 tests green.</p>
        </li>
        <li class="forge-log__item" data-status="done">
          <time>2026-06-03</time>
          <h3>Forge & Infuse Economy</h3>
          <p>Shards-into-rarity + dupes-into-stars + 12-weapon catalog. 415 tests green.</p>
        </li>
        <li class="forge-log__item" data-status="done">
          <time>2026-06-05</time>
          <h3>Playtest Polish</h3>
          <p>Full HP at stage start, softer stage curve, fixed weapon detail panel, Lich phase-2 nerfed. 423 tests green.</p>
        </li>
        <li class="forge-log__item" data-status="done">
          <time>2026-06-08</time>
          <h3>Counter-build</h3>
          <p>Bosses retagged Fire/Ice/Electric/Wind. Deterministic StageAffinity. Pre-stage briefing telegraphs. Defeat → loadout (no retry modal).</p>
        </li>
        <li class="forge-log__item" data-status="done">
          <time>2026-06-08</time>
          <h3>Ember Economy</h3>
          <p>Ember = the pull currency (5/pull, earn from boss+win). Gems → forge currency (star-up). Dupes → gems. Save v3 → v4.</p>
        </li>
        <li class="forge-log__item" data-status="inflight">
          <time>2026-06-09</time>
          <h3>Catalyst</h3>
          <p>Element-pair squad synergy. 6 FTUE compounds + 4 Earth-gated. MVP-6 simple (stat-modifier bag). Spec locked, plan locked, code in-flight.</p>
        </li>
        <li class="forge-log__item" data-status="queued">
          <time>—</time>
          <h3>Spin Cinematic</h3>
          <p>The last Forge Wheel polish: a 0.6s anvil-strike reel on pull, skippable.</p>
        </li>
        <li class="forge-log__item" data-status="queued">
          <time>—</time>
          <h3>Hot Paladin (FM-8 anchor)</h3>
          <p>Stage 2 scripted-defeat cinematic. Probes hero-bond + build-investment.</p>
        </li>
        <li class="forge-log__item" data-status="queued">
          <time>—</time>
          <h3>Elara Signature Arc</h3>
          <p>Spark-chain mechanic + small-B Meteor talent tree. FM-8 hero-bond probe (option B).</p>
        </li>
        <li class="forge-log__item" data-status="queued">
          <time>—</time>
          <h3>Stage 10 — Master Smith</h3>
          <p>Phase-1 Forge Wheel unlocks: part-pull (150 gems) + 5-tier Forge Math + Earth runes.</p>
        </li>
      </ol>

      <aside class="build-rail">
        <h3>Live status</h3>
        <dl class="kv">
          <dt>Tests</dt><dd>~450 green</dd>
          <dt>Branch</dt><dd>forgeloop/teammate-deck</dd>
          <dt>Last commit</dt><dd>(manually updated)</dd>
          <dt>Godot</dt><dd>4.6.2 Mono</dd>
          <dt>Save schema</dt><dd>v4</dd>
        </dl>
        <p class="build-rail__hint">Static — owner edits when stale.</p>
      </aside>
    </div>

    <details class="deep">
      <summary>What shipped this session</summary>
      <p>Counter-build + Ember economy merged to main 2026-06-08. Combat hero-card redesign (weapon row + circle-mask portrait) landed on the Catalyst branch 2026-06-09. Catalyst v1 design spec locked. CLAUDE.md + this deck spec authored.</p>
    </details>
  </div>
</section>
```

- [ ] **Step 2: Append build CSS**

Append to `style.css`:

```css
/* ----------------------------------- build */
.build-grid { display: grid; grid-template-columns: 7fr 3fr; gap: 40px; margin-top: 24px; }
.forge-log { list-style: none; padding: 0; margin: 0; position: relative; }
.forge-log::before { content: ""; position: absolute; left: 11px; top: 8px; bottom: 8px; width: 2px; background: var(--gold-leaf); opacity: 0.4; }
.forge-log__item { position: relative; padding-left: 40px; margin-bottom: 24px; }
.forge-log__item::before {
  content: ""; position: absolute; left: 5px; top: 6px; width: 14px; height: 14px;
  border-radius: 50%; background: var(--iron); border: 2px solid var(--gold-leaf);
}
.forge-log__item[data-status="done"]::before     { background: var(--rarity-r); border-color: var(--rarity-r); }
.forge-log__item[data-status="inflight"]::before { background: var(--amber); border-color: var(--amber); box-shadow: 0 0 12px var(--amber); }
.forge-log__item[data-status="queued"]::before   { background: var(--iron); border-color: var(--mute); }
.forge-log__item time { font-family: var(--font-mono); font-size: 11px; color: var(--mute); letter-spacing: 0.08em; }
.forge-log__item h3 { margin: 2px 0 4px; color: var(--parchment); font-size: 16px; }
.forge-log__item[data-status="inflight"] h3 { color: var(--amber); }
.forge-log__item p { font-size: 14px; color: var(--parchment); margin-bottom: 0; }

.build-rail { background: var(--iron-2); border: 1px solid color-mix(in srgb, var(--gold-leaf) 25%, transparent); border-radius: var(--radius-md); padding: 20px; align-self: flex-start; position: sticky; top: 80px; }
.build-rail h3 { margin-bottom: 12px; }
.kv { display: grid; grid-template-columns: 100px 1fr; gap: 8px 12px; margin: 0; }
.kv dt { font-family: var(--font-mono); font-size: 11px; color: var(--mute); letter-spacing: 0.08em; text-transform: uppercase; }
.kv dd { font-family: var(--font-mono); font-size: 12px; color: var(--parchment); margin: 0; }
.build-rail__hint { font-family: var(--font-mono); font-size: 10px; color: var(--mute); margin: 16px 0 0; }

@media (max-width: 768px) { .build-grid { grid-template-columns: 1fr; } .build-rail { position: static; } }
```

- [ ] **Step 3: Verify visually**

Open the deck. Expected:
- "THE BUILD" heading.
- Timeline left (vertical gold-leaf rail with milestone dots); right rail with key/value table.
- Milestone dots: blue for done, glowing amber for in-flight (Catalyst), dim hollow for queued.
- Right rail sticky-scrolls along with the timeline.

- [ ] **Step 4: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/teammate-deck.html 5_WeaponForge_Honkai_Godot/docs/decks/style.css
git commit -m "deck(d-2): The Build section — forge-log timeline + sticky right rail"
```

---

### Task 13: Section 7 — What's Next (roadmap + links + footer)

**Files:**
- Modify: `docs/teammate-deck.html` (fill `<section id="next">`)
- Modify: `docs/decks/style.css` (append next styles)

- [ ] **Step 1: Fill the section body**

Replace the empty `<section id="next">` with:

```html
<section id="next" class="section section--next">
  <div class="section-inner">
    <h2>What's Next</h2>
    <div class="next-cols">
      <div>
        <h3>Build queue</h3>
        <ol>
          <li>Catalyst (in-flight)</li>
          <li>Spin cinematic</li>
          <li>Hot Paladin (S2 entry)</li>
          <li>Elara signature arc + talents</li>
          <li>Stage 10 — Phase 1 Forge Wheel</li>
        </ol>
      </div>
      <div>
        <h3>Human gates</h3>
        <ol>
          <li>Bran 5-tier portrait eval (≥14/20 Honkai players)</li>
          <li>"Catalyst" trademark check (USPTO + EUIPO)</li>
          <li>10 h internal self-play log</li>
        </ol>
      </div>
      <div>
        <h3>Exit gates (any 2 of 3)</h3>
        <ul class="checklist">
          <li>D1 retention ≥ 35%</li>
          <li>FM-8 hero-bond probe ≥ 6/10 on both axes</li>
          <li>ad CPI ≤ 80% of Wittle benchmark</li>
        </ul>
      </div>
    </div>
    <p class="next-closing">Prototype-end gate at 2 of 3 + 10 h self-play. Kill triggers: D1 &lt; 30% · sat &lt; 6/10 · no creative within 30% of Wittle CPI · FM-8 &lt; 6/10 either axis.</p>
    <nav class="next-links" aria-label="More to read">
      <a href="STATUS.md">STATUS</a>
      <a href="prototype-screen-beats.md">Storyboard</a>
      <a href="superpowers/specs/2026-05-27-wittle-inversion-design.md">Design Spec v2.2</a>
      <a href="superpowers/specs/2026-06-09-catalyst-design.md">Catalyst Spec</a>
      <a href="../CLAUDE.md">CLAUDE.md</a>
    </nav>
    <p class="next-footer">⚒ WeaponForge prototype · forked 2026-06-01 · spec v2.2</p>
  </div>
</section>
```

- [ ] **Step 2: Append next CSS**

Append to `style.css`:

```css
/* ----------------------------------- next */
.section--next { background: var(--iron-deep); padding-bottom: 96px; }
.next-cols { display: grid; grid-template-columns: repeat(3, 1fr); gap: 32px; margin: 32px 0; }
.next-cols h3 { margin-bottom: 12px; }
.next-cols ol, .next-cols ul { padding-left: 20px; margin: 0; font-size: 14px; line-height: 1.6; }
.checklist { list-style: none; padding-left: 0; }
.checklist li::before { content: "□ "; color: var(--gold-leaf); font-family: var(--font-mono); margin-right: 4px; }
.next-closing { font-size: 14px; color: var(--mute); margin-top: 32px; font-style: italic; }
.next-links {
  display: flex; flex-wrap: wrap; gap: 12px 20px;
  margin: 40px 0 20px;
  padding-top: 24px;
  border-top: 1px solid color-mix(in srgb, var(--gold-leaf) 25%, transparent);
}
.next-links a {
  font-family: var(--font-display);
  font-size: 12px;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--gold-leaf);
  border-bottom: 0;
}
.next-footer { font-family: var(--font-mono); font-size: 11px; color: var(--mute); text-align: center; margin: 0; }

@media (max-width: 768px) { .next-cols { grid-template-columns: 1fr; } }
```

- [ ] **Step 3: Verify visually**

Open the deck. Expected:
- "WHAT'S NEXT" heading.
- 3 columns (Build queue / Human gates / Exit gates) with lists; checklist style on the gates.
- Closing line in italic mute.
- Links row at the bottom (STATUS, Storyboard, Design Spec, Catalyst Spec, CLAUDE).
- Centered footer line.

- [ ] **Step 4: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/teammate-deck.html 5_WeaponForge_Honkai_Godot/docs/decks/style.css
git commit -m "deck(d-2): What's Next section + links + footer"
```

---

### Task 14: D-2 manual sanity check

- [ ] **Step 1: Re-open the deck**

Open `5_WeaponForge_Honkai_Godot/docs/teammate-deck.html` in Chrome + Firefox.

Checklist:
- [ ] All 7 sections render with their content.
- [ ] Nav links smooth-scroll to each section.
- [ ] All collapsibles (`<details>`) open + close.
- [ ] All images load (Bran/Elara/Vex portraits, fire/ice runes, slime, Bran 5-tier).
- [ ] Bran 5-tier image is visible inside the rondel; scrubber slider draws but doesn't yet change the image (JS lands in D-3).
- [ ] Loop ASCII diagram is monospaced + readable.
- [ ] Build timeline has correctly-colored dots (blue = done, glowing amber = Catalyst, dim = queued).
- [ ] Build right rail sticky-scrolls.
- [ ] Roster cards rotate −1°/+1° and snap to 0 on hover.
- [ ] No console errors.

- [ ] **Step 2: Mobile responsive check (≤768 px)**

- [ ] All grids collapse to single column.
- [ ] Sticky nav stacks brand on top, links wrap below.
- [ ] No horizontal scroll except inside the ASCII `<pre>` (overflow-x: auto).
- [ ] Bran scrubber + slider remain usable on phone.

- [ ] **Step 3: Mark D-2 complete (no commit; nothing to commit)**

If all checks pass, Chunk D-2 is done. Proceed to Chunk D-3 (motion + hook).

---

## CHUNK D-3 — Motion + the hook

Goal: orchestrated hero reveal (staggered letter fade + ember glow + portrait scale-in + anvil opacity ease), Bran scrubber JS that actually morphs ★1→★5, scroll-triggered SVG divider draw, print fallback, reduced-motion fallback, final visual + a11y check.

---

### Task 15: Bran 5-tier scrubber JS (the hook)

**Files:**
- Modify: `docs/decks/scrub.js`

- [ ] **Step 1: Write the scrubber acceptance criteria (manual "test" comment block)**

Replace the stub `scrub.js` with the criteria-as-comment + the real implementation:

```js
/* WeaponForge teammate deck — scrub.js
   Bran 5-tier portrait scrubber + IntersectionObserver for engraved dividers.

   Acceptance (manual check at end of D-3):
     1. Slider value 0..4 maps to portrait frame 0..4 (★1..★5).
     2. Caption changes per tier: Apprentice / Adept / Veteran / Champion / Master.
     3. Arrow keys nudge the slider one tier left/right when focused.
     4. object-position transitions 200ms ease (visible morph).
     5. prefers-reduced-motion: transitions become instant.
*/
(() => {
  "use strict";

  const TIER_NAMES = ["Apprentice", "Adept", "Veteran", "Champion", "Master"];

  function initScrubber() {
    const slider = document.getElementById("bran-tier");
    const img    = document.getElementById("bran-scrub");
    const label  = document.getElementById("bran-tier-label");
    if (!slider || !img || !label) return;
    // The source is 5 frames wide; the rondel masks to 1 frame.
    // Frame N is shown by translating the wide img to the left by N * 20% (since 5 frames -> 100%/5 = 20% per frame relative to img width which is 500% of container).
    // With object-fit: cover and the img being 500% wide, object-position controls horizontal alignment within that 500% strip; 0% = leftmost frame, 100% = rightmost. The 5 frames are at 0%, 25%, 50%, 75%, 100%.
    const FRAME_POS = [0, 25, 50, 75, 100];
    function paint(idx) {
      const i = Math.max(0, Math.min(4, idx | 0));
      img.style.objectPosition = `${FRAME_POS[i]}% center`;
      label.textContent = `Tier ${i + 1} · ${TIER_NAMES[i]}`;
      img.setAttribute("alt", `Bran portrait at tier ${i + 1} (${TIER_NAMES[i]})`);
    }
    slider.addEventListener("input", e => paint(Number(e.target.value)));
    paint(Number(slider.value));
  }

  function initDividerDrawIn() {
    const dividers = document.querySelectorAll(".divider-engraved");
    if (!("IntersectionObserver" in window) || dividers.length === 0) return;
    const obs = new IntersectionObserver(entries => {
      for (const entry of entries) {
        if (entry.isIntersecting) {
          entry.target.classList.add("divider-engraved--drawn");
          obs.unobserve(entry.target);
        }
      }
    }, { threshold: 0.4 });
    dividers.forEach(d => obs.observe(d));
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", () => { initScrubber(); initDividerDrawIn(); });
  } else {
    initScrubber(); initDividerDrawIn();
  }
})();
```

- [ ] **Step 2: Append CSS for the scrubber image (corrects the object-position approach)**

In `docs/decks/style.css`, REPLACE the existing `#bran-scrub` rule with this corrected version (the previous rule made the image too wide; the proper approach is a normal-sized image with `object-position` driven by the slider, since the source is wider than the visible rondel):

Find this block:

```css
#bran-scrub {
  position: absolute; inset: 0;
  width: 500%;  /* 5 frames laid out side by side; the rondel masks to 1 frame */
  height: 100%;
  object-fit: cover;
  object-position: 0% center;
  transition: transform 0.2s ease;
}
```

Replace it with:

```css
.hero-card__rondel { overflow: hidden; }
#bran-scrub {
  width: 100%;
  height: 100%;
  /* The source bran_5tier.png is a 5-frame horizontal strip. Using
     object-fit: none + object-position lets us pan across the strip. */
  object-fit: none;
  /* Source asset is ~1024×~205 (5 portraits of ~205 each). Adjust if the
     source aspect ratio differs — verify visually in step 4. */
  object-position: 0% center;
  transition: object-position 0.2s ease;
}
```

- [ ] **Step 3: Reduced-motion fallback (append to style.css)**

Append to the end of `style.css`:

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

- [ ] **Step 4: Verify the scrubber works**

Open the deck in a browser. Click on or focus the slider. Expected:
- Dragging the slider 0..4 shifts the portrait through 5 distinct tiers.
- Caption changes: "Tier 1 · Apprentice" → "Tier 2 · Adept" → ... → "Tier 5 · Master".
- Left/Right arrow keys (when slider focused) step one tier at a time.
- The morph between tiers is a smooth 200ms ease (or instant with `prefers-reduced-motion: reduce` emulated in DevTools).
- No console errors.

If the portrait shows the WRONG frame at a tier index, the source asset's per-frame width may differ from 1/5 — adjust `FRAME_POS` percentages in scrub.js or use a fixed pixel `object-position`. Verify visually before committing.

- [ ] **Step 5: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/decks/scrub.js 5_WeaponForge_Honkai_Godot/docs/decks/style.css
git commit -m "deck(d-3): Bran 5-tier scrubber JS + reduced-motion fallback"
```

---

### Task 16: Orchestrated hero entry reveal

**Files:**
- Modify: `docs/decks/style.css` (append hero entry animations)

- [ ] **Step 1: Append the entry-reveal CSS**

Append to `style.css`:

```css
/* ----------------------------------- hero entry reveal */
.hero-title span {
  opacity: 0;
  display: inline-block;
  transform: translateY(8px);
  animation: hero-letter 600ms ease-out forwards;
  animation-delay: calc(var(--i, 0) * 80ms);
  text-shadow: 0 0 0 transparent;
}
@keyframes hero-letter {
  0%   { opacity: 0; transform: translateY(8px); text-shadow: 0 0 0 transparent; }
  60%  { opacity: 1; transform: translateY(0);   text-shadow: 0 0 18px var(--ember); }
  100% { opacity: 1; transform: translateY(0);   text-shadow: 0 0 0 transparent; }
}
.hero-portraits .rondel {
  opacity: 0;
  transform: scale(0.96);
  animation: hero-portrait 700ms cubic-bezier(0.2, 0.7, 0.2, 1) forwards;
}
.rondel--bran  { animation-delay: 800ms; }
.rondel--elara { animation-delay: 1000ms; }
.rondel--vex   { animation-delay: 1200ms; }
@keyframes hero-portrait {
  0%   { opacity: 0; transform: scale(0.96); }
  100% { opacity: 1; transform: scale(1);    }
}
.hero-anvil {
  opacity: 0;
  animation: hero-anvil 1200ms ease-out forwards;
  animation-delay: 200ms;
}
@keyframes hero-anvil {
  0%   { opacity: 0; }
  100% { opacity: 0.18; }
}
```

- [ ] **Step 2: Verify visually**

Refresh the deck. Expected:
- On page load, "WEAPONFORGE" letters fade in one at a time (80ms apart), each with a brief ember glow.
- Anvil silhouette fades in 0 → 18% opacity over 1.2s.
- Hero portraits scale-in 0.96 → 1 with a slight delay each (800/1000/1200ms).
- Total reveal ~2 seconds.
- With `prefers-reduced-motion: reduce` emulated, all reveals are instant.

- [ ] **Step 3: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/decks/style.css
git commit -m "deck(d-3): hero entry — staggered letter fade + ember glow + portrait scale-in + anvil"
```

---

### Task 17: Scroll-triggered SVG divider draw

**Files:**
- Modify: `docs/decks/style.css` (append divider-drawn rule)

The JS (`initDividerDrawIn` in scrub.js) already adds the `.divider-engraved--drawn` class when each divider enters viewport. This task adds the CSS that animates the engraved-rule draw-in.

- [ ] **Step 1: Append divider-draw CSS**

Append to `style.css`:

```css
/* ----------------------------------- divider draw-in */
.divider-engraved {
  opacity: 0;
  transition: opacity 600ms ease;
}
.divider-engraved--drawn { opacity: 0.7; }
/* The dashed line + chevron + dot inherit currentColor; the simplest reveal
   is opacity. A more elaborate stroke-dashoffset draw would need each
   divider to be a unique SVG with its own stroke length — overkill here. */
```

- [ ] **Step 2: Verify visually**

Refresh the deck and scroll slowly. Expected:
- Each engraved divider fades in (opacity 0 → 0.7) as it enters viewport.
- Above-the-fold dividers fade in shortly after page load.
- Scrolling back up does NOT re-animate them (IntersectionObserver unobserves on first reveal).
- With `prefers-reduced-motion: reduce`, they appear instantly.

- [ ] **Step 3: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/decks/style.css
git commit -m "deck(d-3): scroll-triggered engraved-divider fade-in"
```

---

### Task 18: Print fallback

**Files:**
- Modify: `docs/decks/style.css` (append @media print rules)

- [ ] **Step 1: Append print rules**

Append to `style.css`:

```css
/* ----------------------------------- print */
@media print {
  :root { --iron-deep: #fff; --iron: #fff; --iron-2: #fff; --parchment: #000; --mute: #555; }
  body { background: white; color: black; font-size: 11pt; }
  .deck-nav, .scrubber, .build-rail__hint, .next-links { display: none !important; }
  .section { padding: 24pt 24pt; break-before: page; background: white; }
  .section::before { display: none; }
  details { open: true; }
  details > * { display: revert !important; }
  details summary::after { display: none; }
  .divider-engraved { display: none; }
  .hero-title { font-size: 36pt; }
  h2 { color: black; border-bottom: 1px solid #888; padding-bottom: 4pt; }
  a { color: black; border-bottom: 0; }
  .rondel, .hero-card__rondel { border-color: #888; }
  .pull-quote { color: black; border-color: #888; }
  .axis-status--shipped, .axis-status--inflight { background: #eee; color: black; }
  .forge-log__item[data-status="inflight"]::before { background: black; box-shadow: none; }
  #bran-scrub { object-position: 50% center; }  /* show tier 3 in print */
}
```

- [ ] **Step 2: Verify in print preview**

Open the deck in Chrome → File → Print → Preview. Expected:
- White background, black text.
- Sticky nav hidden.
- All `<details>` collapsibles open showing their content.
- Each section starts on a new page.
- Bran scrubber → static tier-3 portrait (Veteran), slider hidden.
- Links rendered as plain black text.

- [ ] **Step 3: Commit**

```bash
git add 5_WeaponForge_Honkai_Godot/docs/decks/style.css
git commit -m "deck(d-3): print fallback — white bg, expanded details, tier-3 static portrait"
```

---

### Task 19: Final manual test pass

This is the spec §17 checklist. No code changes; verifies the deck is ship-ready.

- [ ] **Step 1: Chrome + Firefox + Safari (latest each)**

Open `docs/teammate-deck.html` in each. For each browser:
- [ ] No console errors.
- [ ] All 12 image assets load (Network tab shows no 404s).
- [ ] Sticky nav anchors smooth-scroll to all 6 sections (Bet/What/Roster/Loop/Build/Next).
- [ ] All 7 `<details>` open + close.
- [ ] Bran scrubber 0..4 works, portrait morphs cleanly, caption updates.
- [ ] Arrow keys on focused scrubber step one tier at a time.
- [ ] Engraved dividers fade in on scroll.
- [ ] Hero entry reveal plays once on initial load.

- [ ] **Step 2: Mobile portrait (360×640)**

DevTools → Device toolbar → iPhone SE or any narrow viewport.
- [ ] All sections stack vertically.
- [ ] Nav collapses (brand top, links wrapping below).
- [ ] No horizontal scroll except inside the loop ASCII (which has its own overflow-x).
- [ ] Scrubber works on touch.
- [ ] Bran card big card spans full width.

- [ ] **Step 3: Reduced-motion check**

DevTools → Rendering → Emulate `prefers-reduced-motion: reduce`.
- [ ] Refresh. Hero entry is instant (no letter stagger).
- [ ] Dividers fade-in instant.
- [ ] Scrubber morph instant.
- [ ] All content reachable.

- [ ] **Step 4: Lighthouse audit**

DevTools → Lighthouse → Mobile + Desktop runs.
- [ ] Performance ≥ 90.
- [ ] Accessibility ≥ 95.
- [ ] Best Practices ≥ 90.
- [ ] No critical issues.

If a11y < 95, common culprits: contrast (use DevTools color picker on `--mute` text), missing alt text (verify all `<img>` have alt), focus ring visibility, form labels (scrubber `<label>` already wired).

- [ ] **Step 5: Print preview**

File → Print → Preview.
- [ ] White-bg layout per Task 18.
- [ ] All sections start on new pages.
- [ ] Scrubber slider hidden, tier-3 portrait shown.

- [ ] **Step 6: Final commit (CHANGELOG-style summary)**

```bash
git commit --allow-empty -m "deck(d-3): final manual test pass — Chrome/FF/Safari/mobile/print/reduced-motion all green"
```

- [ ] **Step 7: Push the branch**

```bash
git push
```

Owner playtests the deck. If anything's off → loop back to the relevant task; commit fix; re-push.

---

## Post-build checklist

After D-3 final test pass and owner sign-off:

- [ ] Update `STATUS.md` §3 DONE table — add "Teammate deck shipped".
- [ ] Add a one-line entry to the §10 doc index in CLAUDE.md pointing at `docs/teammate-deck.html`.
- [ ] Optional later: GitHub Pages publish for a shareable URL.
- [ ] Optional later: owner swaps in 3-5 real screenshots of the running build.
- [ ] Optional later: owner generates 2-3 nano-banana key art frames + drops them in.

---

## Self-review notes

This plan covers every spec section:

| Spec § | Plan task(s) |
|---|---|
| §1 Goal | Implicit across all tasks |
| §2 Aesthetic | Task 3 (theme) + Task 7 (hero anvil) + visual choices throughout |
| §3 Typography | Task 2 (font loading) + Task 3 (font-family declarations) |
| §4 Color tokens | Task 3 (`:root` block) |
| §5 Section outline | Tasks 7–13 (one task per section) |
| §6 Bran scrubber | Task 10 (HTML/CSS shell) + Task 15 (JS) |
| §7 Motion | Task 15 (reduced-motion fallback) + Task 16 (hero entry) + Task 17 (dividers) |
| §8 Spatial | Tasks 7–13 per-section layouts |
| §9 Atmosphere | Task 3 (noise filter) + Task 4 (dividers) + Task 7 (ember radial) |
| §10 Assets | Task 1 (copy) + each section task references them |
| §11 File layout | Tasks 1, 2, 3, 5 (file creates) |
| §12 Hosting | Local file:// works as built; GitHub Pages deferred (post-build checklist) |
| §13 A11y | Task 3 (focus rings) + Task 19 (Lighthouse audit) |
| §14 Performance budget | Task 19 (Lighthouse) |
| §15 Print fallback | Task 18 |
| §16 Out of scope | (not built — verified by absence) |
| §17 Test plan | Task 19 |
| §18 Resolved decisions | (consumed during planning, baked into HTML/CSS) |
| §19 Acceptance | Task 19 step 1 |
| §20 Build sequence | Three chunks D-1 / D-2 / D-3 |

No placeholders. No "TODO" steps. Every code step has the actual code. Every commit step has the actual git commands. Type consistency check: scrubber uses `bran-tier` id consistently across HTML (Task 10) + JS (Task 15) + label (Task 10).

If executing this plan, stop at any task whose verification check fails and report back before continuing.
