# WeaponForge — Teammate Deck (HTML one-pager) Design Spec

**Status:** locked design, not yet built.
**Branch:** new branch off main → `forgeloop/teammate-deck`.
**Author:** owner + Claude (brainstorm 2026-06-09).
**Companion files:** `STATUS.md` (state), `prototype-screen-beats.md`
(storyboard), `superpowers/specs/2026-05-27-wittle-inversion-design.md`
v2.2 (locked design).

---

## 1. Goal

A self-contained, dark, forge-themed HTML one-pager that brings two
audiences onto the same page in a single read:

- **Lila internal team** (devs / artists / PM) — wants: what is this,
  where are we, what's hard, where can they contribute.
- **Lila leadership** — wants: the bet, the audience, the moat, the
  exit gates.

Single file (`docs/teammate-deck.html`). Open in any browser. Scroll
top → bottom. Deeper detail lives in `<details>` collapsibles per
section so the *default* read is tight and the *deep* read is one
click away.

This is **informational** (no CTA, no decision-deck). Reads in ~5 min
default, ~15 min with all collapsibles expanded.

---

## 2. Aesthetic direction — Forge industrial × anime rondel

Picked over 3 alternatives (anime-TCG holo, codex/grimoire, arcade-HUD)
because it matches:

- The game's literal name (WeaponForge → blacksmith).
- The in-game palette (dark iron + amber heat from `home_screen.gd`).
- The pitch's emotional core (anime heroes inside hard-edged weapon-craft).

Vocabulary:

- **Hammered iron** — dark blue-black page bg, faint noise texture.
- **Hot metal accents** — amber + ember accents, used sparingly.
- **Gold-leaf dividers** — engraved SVG rules between sections.
- **Anime portrait rondels** — hero portraits inside worn-metal circle
  frames (the same circle-mask shader from the in-game cards).
- **Anvil silhouette** in hero section background only.

What this **is not:** purple-gradient SaaS, parchment fantasy, neon
CRT arcade, holographic TCG. Pick one direction, execute precisely.

---

## 3. Typography (3 fonts, no more)

- **Display:** `Cinzel` (Google Fonts, free). Roman inscriptional caps.
  ALL CAPS for the wordmark + section labels. Reads carved, fits the
  forge metaphor.
- **Body:** `Manrope` (Google Fonts, variable). Sturdy modern sans,
  NOT Inter, reads clean on dark. Weight 400 body / 600 emphasis.
- **Mono:** `JetBrains Mono` for the few code / config snippets
  (status / test counts).

Loading: `<link rel="preconnect">` + `<link rel="preload">` on Cinzel
700 + Manrope 400. All faces `font-display: swap`. WOFF2 only.

---

## 4. Color tokens

```css
:root {
  --iron-deep:  #0a0710;   /* page bg */
  --iron:       #14101c;   /* section bg */
  --iron-2:     #1f1a2a;   /* panel / card bg */
  --amber:      #e8a23a;   /* primary accent — hot metal */
  --ember:      #ff6b3d;   /* sparks — reveal moments only */
  --gold-leaf:  #c9a85c;   /* dividers, borders */
  --parchment:  #f0e6d6;   /* body text — aged white */
  --mute:       #6f6552;   /* secondary text */
  --link:       #ffb45c;   /* link hover */
  /* rarity accents reused from home_screen.gd RARITY_COLORS */
  --rarity-c: #8c8c8c;
  --rarity-r: #5aa6ff;
  --rarity-e: #bf66ff;
  --rarity-l: #ffbf40;
  --rarity-m: #ff4c4c;
}
```

Contrast: amber-on-iron-deep ≥ 7.5:1 (AAA). Parchment-on-iron ≥ 10:1.
No white-on-white, no purple-on-white, no purple gradients anywhere.

---

## 5. Section outline (7 sections, modular)

Sticky top nav with section anchors: **Hero · Bet · What · Roster ·
Loop · Build · Next**.

### 5.1 Hero / intro

- Asymmetric layout: wordmark + tagline left-aligned at 60% width,
  hero portrait trio (Bran/Elara/Vex full-body) in diamond formation
  right of center.
- Anvil silhouette SVG behind everything at 8% opacity.
- Cinzel wordmark `WEAPONFORGE` w/ a faint ember glow trailing each
  letter (staggered 80ms entry).
- One-liner: *"Casual-mobile RPG. You pull weapons. You bond with heroes."*
- Stat ribbon under the trio: `prototype build · 5-wave stages · 3-boss
  rotation · forked 2026-06-01`.

**Assets:** `assets/heroes/bran_warrior.png`, `elara_mage.png`,
`vex_rogue.png` (copies of the godot heroes); inline SVG for the anvil.

### 5.2 The Bet (leadership-leaning)

- Three short paragraphs:
  - **Audience.** Wittle Defender ∩ anime-curious.
  - **Inversion.** Wittle pulls heroes — we pull WEAPONS, lock the
    roster, sell the bond.
  - **Moat.** Equipment-gacha is precedented (Archero $263M). Story-
    locked roster is unprecedented. The combination is the moat.
- Pull-quote callout: *"Forge weapons. Bond with heroes."*
- `<details>`: "competitor landscape" — 1-paragraph synth + link to
  `docs/research/2026-05-28-competitor-landscape-synthesis.md`.

### 5.3 What is WeaponForge

- Three-column layout: **Pull · Equip · Fight.**
- Each column: a small SVG icon + 2-line description + one in-context
  asset (weapon rune for Pull, hero portrait for Equip, enemy art for
  Fight).
- `<details>`: "first 10 minutes" — bullet timeline of the FTUE arc
  (Bran start → Elara unlock W3 → Vex W6 → boss S1 → first pull).

### 5.4 The Roster (the moat)

- 7 hero cards in a slightly-irregular grid (rotated −1° to +1°), each
  in a worn-metal rondel frame (the in-game circle-mask styling).
- Each card: portrait · name · class · short personality blurb · status
  badge (🟢 FTUE / 📋 unlocks S2 / 📋 unlocks Sx / 🧪 TBD).
- Cards: Bran (✅) · Elara (✅) · Vex (✅) · Hot Paladin (📋 S2) · 2nd
  Rogue (📋) · 2nd Mage (📋) · Hot Assassin (📋).
- **The hook lives here** → see §6. Bran's card has a "drag to evolve"
  scrubber that morphs portrait through ★1→★5 using
  `bran_5tier_evolution.png`.
- `<details>`: "why a locked roster?" — pre-mortem FM-1 + the bond probe.

### 5.5 The Loop

- ASCII-style diagram (rendered as CSS-styled `<pre>`) showing the core
  loop: HOME → pull → equip → STAGE → 5 waves → boss → reward → HOME.
- Sub-callouts to the right naming the 3 axes:
  1. Counter-build (pre-stage briefing) — ✅ shipped
  2. Catalyst (element-pair synergy) — 🛠 in flight
  3. Forge Wheel (the gacha) — ✅ shipped
- `<details>`: "the 5-wave stage" — boss rotation (slime/golem/lich)
  + scaling note + draft modal description.
- `<details>`: "what's a Catalyst?" — 6 FTUE compounds table from the
  Catalyst spec (Firestorm / Wildfire / Plasma / Blizzard / Glacial
  Storm / Stormfront) + the "pull #1 Fire, pull #3 Ice" reveal moment.

### 5.6 The Build

- Status timeline. Forge-log layout — each milestone is a stamped
  marker on a vertical iron rail.
- Milestones: Forked from Weaponcraft 2026-06-01 → P1a (WeaponData)
  → Game Frame (combat + draft) → Forge & Infuse Economy → Playtest
  Polish → Counter-build → Ember Economy → 🛠 Catalyst → Spin
  Cinematic → Hot Paladin → Elara arc → Stage 10 / Phase 1.
- Each milestone has a date + 1-line description + a tiny status pill.
- Right rail: test count + branch + last-commit-hash. **Static —
  manually maintained in the HTML** (owner edits when it goes stale;
  see §18 Q3 for a possible dynamic variant later).
- `<details>`: "what shipped this week" — pulled from the most recent
  handoff doc.

### 5.7 What's next

- Roadmap to exit gates (3 chunks):
  - Build queue: Catalyst → Hot Paladin → Elara → Talents → Phase 1.
  - Human gates: Bran 5-tier eval + "Catalyst" TM check.
  - Exit gates: D1 ≥35%, FM-8 ≥6/6, ad CPI ≤80% of Wittle.
- Single closing line: *"prototype-end gate at 2 of 3 + 10h self-play."*
- Tiny links section: STATUS · Storyboard · Design Spec · Catalyst Spec.

---

## 6. The unforgettable moment — Bran 5-tier scrubber

The Roster section's Bran card has an interactive 5-tier portrait
scrubber. Drag the slider → portrait morphs ★1→★5 in real time.

- Source: `bran_5tier_evolution.png` (5 portraits stacked horizontally
  in the existing test asset; already on disk).
- Implementation: an `<img>` rendered inside a fixed-aspect rondel,
  `object-position: -N% 0` driven by a `<input type="range" min=0 max=4
  step=1>`. Snaps to each tier. CSS transition `object-position 200ms
  ease`. No JS framework. ~15 lines of code.
- Keyboard accessible (left/right arrow keys when slider focused).
- A small caption changes per tier: ★1 "Apprentice" → ★5 "Master".
- Why this is the moment: uses an asset that already exists, tells the
  moat story (story-locked roster + tier evolution) in 3 seconds, and
  nobody else has this in their pitch deck.

---

## 7. Motion — one orchestrated reveal + 3 high-impact moments

Not a sprinkle of micro-interactions. Specific moments only.

1. **Hero entry (orchestrated):**
   - Cinzel letters of `WEAPONFORGE` fade in staggered 80ms apart via
     `animation-delay: calc(var(--i) * 80ms)`.
   - Each letter has a 200ms ember glow trailing the fade.
   - Hero portrait trio fades in `scale(.96)→scale(1)` w/ 200ms delay
     per portrait.
   - Anvil silhouette opacity 0 → 0.08 over 600ms.
   - Total reveal ~2 s. Skippable by clicking anywhere.

2. **Section dividers (scroll-triggered):**
   - Engraved gold-leaf SVG line draws via `stroke-dashoffset` as the
     divider enters viewport (IntersectionObserver, no library).
   - One per section; ~600 ms each. Once only — does not re-animate
     on scroll-up.

3. **Bran 5-tier scrubber:**
   - `object-position` transitions per tier change (see §6).
   - Slider thumb is a small hot-amber square w/ a faint glow.

4. **`<details>` open/close:**
   - `<summary>` carat rotates 90° on open via CSS-only transition
     (no JS). Content slides via `details[open] > div` height auto.

**Reduced motion:** all `@media (prefers-reduced-motion: reduce)` →
instant. Scrubber still works (it's the content, not chrome).

No cursor effects. No bouncy hovers. No twirling. No parallax beyond
the anvil opacity ease.

---

## 8. Spatial composition

- **Hero:** asymmetric. Title at 60% column width, trio at 40%, anvil
  silhouette spans full width behind both.
- **Bet:** centered max-width 720px; pull-quote breaks the column for
  emphasis.
- **What:** 3 columns desktop, 1 column mobile; vertical rhythm tight.
- **Roster:** 7 cards in a 4-3 staggered grid. Cards rotated −1°/+1°
  alternating. Bran card slightly bigger (the hook).
- **Loop:** ASCII diagram left 60%, axes callouts right 40%. Bordered
  with engraved-rule SVG.
- **Build:** vertical timeline left 70%, right rail (tests / branch /
  hash) right 30%.
- **Next:** centered, no decoration. Footer-light.

Mobile (≤768px): all sections stack to single column. Sticky nav
collapses to a hamburger. Bran scrubber stays full-bleed (the hook
still works on phone).

---

## 9. Background atmosphere

- **Page bg:** `--iron-deep` flat.
- **Section bg:** `--iron` w/ a 4% hammered-metal noise SVG overlay
  (one shared `<svg>` filter, ~200 bytes inline).
- **Ember radial gradients** at focal points (hero wordmark, pull-quote,
  Bran scrubber). Warm-amber → transparent, ~30% opacity peak, 800px
  radius, blend-mode: screen.
- **Gold-leaf engraved-rule dividers** between sections — inline SVG,
  ~120 bytes each.

No additional textures. No starfields. No floating particles. Restraint.

---

## 10. Asset inventory (confirmed on disk)

| Asset | Location | Use |
|---|---|---|
| Bran 5-tier portrait | `docs/research/portrait-tier-test/bran_5tier_evolution.png` | §6 scrubber |
| Bran portrait | `Prototype/godot/assets/generated/heroes/bran_warrior.png` | Hero trio + roster card |
| Elara portrait | `Prototype/godot/assets/generated/heroes/elara_mage.png` | Hero trio + roster card |
| Vex portrait | `Prototype/godot/assets/generated/heroes/vex_rogue.png` | Hero trio + roster card |
| Slime / Goblin / Skeleton | `Prototype/godot/assets/generated/enemies/*.png` | §5.3 Fight column |
| Weapon parts (heads/pommels) | `Prototype/godot/assets/generated/parts/*.png` | §5.3 Pull column |
| Element runes (fire/ice/pierce) | `Prototype/godot/assets/generated/parts/r_*.png` | §5.5 catalyst table |
| VFX (fire_puff / ice_shard / merge_sparkle) | `Prototype/godot/assets/generated/vfx/*.png` | accents in dividers |
| **Anvil silhouette** | inline SVG, hand-written | §5.1 hero background |
| **Engraved-rule divider** | inline SVG | section dividers |
| **Hammered noise filter** | inline SVG `<filter>` | section bg |
| **Logo / wordmark** | Cinzel typography (no graphic logo) | §5.1 hero title |

**Missing (deliberately, owner accepts):** Hot Paladin / 2nd Rogue /
2nd Mage / Hot Assassin portraits (heroes not yet authored — show
silhouette + "??" placeholder cards with status `📋 TBD`). No
screenshots of the running build yet — owner will paste later and
swap in.

**Asset path policy:** the deck does NOT reach into
`Prototype/godot/assets/*` directly. Instead all images are **copied
into `docs/decks/assets/`** at build time so the deck is portable +
the assets survive any future Godot path refactor. The copies are
git-tracked (small, ~1-2 MB total).

---

## 11. File layout

```
docs/teammate-deck.html              (the deck)
docs/decks/assets/                   (image copies; git-tracked)
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
docs/decks/style.css                 (extracted CSS; could be inlined)
docs/decks/scrub.js                  (the 5-tier scrubber + intersection observer)
```

CSS + JS could be inlined into the HTML for true single-file
portability. Decision: **CSS external, JS external** (easier to
review + maintain). HTML imports them via relative paths. Whole thing
zipped to ~500 KB.

---

## 12. Hosting + sharing

- **Local file:// open** — primary path. Teammates clone the repo,
  open `docs/teammate-deck.html` in browser.
- **GitHub Pages (optional, deferred)** — owner can publish later if
  shareable URL is wanted. Not in v1 scope.
- **No external CDN** other than Google Fonts (one preconnect).
  Everything else is in-repo.

---

## 13. Accessibility

- Semantic HTML: `<nav>` for the sticky nav, `<section>` per chapter,
  `<details><summary>` for collapsibles, `<button>` for any clickable
  thing that isn't a link.
- Contrast: parchment-on-iron ≥ 10:1, amber-on-iron ≥ 7.5:1, mute-on-iron
  ≥ 4.5:1 (AA). No essential text in `--mute`.
- Focus rings: 2px ember outline + 4px offset on every focusable.
- `prefers-reduced-motion: reduce` → all animations instant; scrubber
  still works (it's content, not chrome).
- Scrubber: keyboard-accessible (left/right arrows when focused).
- `<details>` collapsibles work without JS.
- All decorative SVGs `aria-hidden="true"`.
- Mobile: tap targets ≥ 44 px.

---

## 14. Performance budget

- Total page weight ≤ 500 KB (gzip).
- Hero LCP ≤ 1.0 s on 3G fast.
- All images `loading="lazy"` except the hero trio + Bran scrubber.
- WOFF2 fonts only, preloaded.
- No external JS libraries. ~30 lines of vanilla JS total (scrubber +
  IntersectionObserver for divider draw).

---

## 15. Print fallback

`@media print` ruleset:
- Background → white.
- Text → `--iron-deep` on white.
- Sticky nav hidden.
- All `<details>` force-expanded.
- Page breaks before each `<section>`.
- Bran scrubber → static image of ★3 tier (the middle).

Lets teammates email a PDF if needed. Not the primary path.

---

## 16. Out of scope (v1)

- Logo graphic (use Cinzel wordmark only — no separate logomark).
- Video / GIF demos of combat (owner will swap screenshots in later).
- Hot Paladin / 2nd Rogue / 2nd Mage / Hot Assassin art (heroes not
  yet authored — placeholders).
- AI-generated new key art (deferred per owner — reuse existing only
  in v1; cost policy in CLAUDE.md §10).
- A CTA / decision-call ("here's how to help") — informational only.
- Multilingual.
- Dark/light theme toggle (dark-only; the aesthetic IS the dark).
- Sound / audio.
- A "press kit" download bundle.
- GitHub Pages publishing (deferred).
- Analytics / tracking.

---

## 17. Test plan (manual)

No automated tests (HTML deck, not game code). Manual checklist
before owner sign-off:

- [ ] Opens in Chrome / Firefox / Safari (latest) — no JS errors in console.
- [ ] Mobile portrait 360×640 — all sections stack correctly, sticky
      nav collapses, Bran scrubber works.
- [ ] Print preview shows all sections expanded, no clipping.
- [ ] Keyboard nav: Tab through all interactive elements, Bran scrubber
      arrow keys work.
- [ ] `prefers-reduced-motion: reduce` (DevTools emulate) — animations
      instant.
- [ ] All asset paths resolve (no broken images).
- [ ] DevTools Lighthouse: perf ≥ 90, a11y ≥ 95.
- [ ] Bran 5-tier scrubber snaps cleanly to each tier; caption changes.
- [ ] Sticky nav anchors smooth-scroll to each section.
- [ ] All 7 `<details>` collapsibles open + close.

---

## 18. Open questions

1. **Build branch.** Cut a new branch `forgeloop/teammate-deck` off
   `main` (deck has nothing to do with Catalyst) — or stay on
   `forgeloop/catalyst-element-pairs` and just commit the deck
   alongside? Recommend: new branch off main.
2. **Roster card placeholders.** For Hot Paladin / 2nd Rogue / 2nd
   Mage / Hot Assassin — silhouette + `?` or just a "📋 TBD" colored
   tile? Recommend: silhouette in a rondel + small "?" mark — looks
   intentional, not lazy.
3. **Build section's right-rail data.** Static (manually maintained
   in the HTML) or dynamic (a small JSON file the deck reads)? v1 =
   static, easier; revisit if it goes stale.

---

## 19. Acceptance

A reviewer should be able to:

- name the aesthetic direction in one sentence (forge industrial × anime rondel);
- recall the unforgettable moment (Bran 5-tier scrubber);
- locate the 3 font choices and the 5+ color tokens;
- find the file layout (§11);
- find the asset inventory + understand the copy-to-decks policy (§10–§11);
- find the manual test checklist (§17).

If any of those is unclear → revision pass before the implementation
plan starts.

---

## 20. Build sequence (preview for the impl plan)

Three rough chunks (full plan via `superpowers:writing-plans`):

- **Chunk D-1 — Skeleton + CSS theme.** HTML scaffold, font loading,
  color tokens, layout grid, sticky nav, dark theme, noise + ember +
  gold-leaf atmosphere primitives. Asset directory created + copies in.
- **Chunk D-2 — Section content.** All 7 sections filled with copy +
  assets + `<details>` collapsibles. Roster cards laid out (rotated
  grid). Loop ASCII + axes callouts. Build timeline. The Bet pull-quote.
- **Chunk D-3 — Motion + the hook.** Orchestrated hero reveal,
  scroll-triggered dividers, Bran 5-tier scrubber, print fallback,
  reduced-motion fallback. Manual test pass. Commit.

Each chunk = one commit. Owner reviews after chunk D-2 (content) and
again after chunk D-3 (final visual).
