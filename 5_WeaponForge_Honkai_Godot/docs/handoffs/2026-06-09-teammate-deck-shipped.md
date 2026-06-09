# Handoff — 2026-06-09 — Teammate deck (DECK ONLY)

> **Scope:** this handoff covers the teammate deck and ONLY the teammate deck.
> For the broader session state + the on-hold prototype queue + how to resume
> the whole session, see the companion handoff
> `2026-06-09-session-continuation.md`.

## What the deck is

A self-contained dark-themed HTML one-pager at
`5_WeaponForge_Honkai_Godot/docs/teammate-deck.html`. Opens in any modern
browser. No build step, no server, no external deps beyond Google Fonts.
Aesthetic: forge industrial × anime rondel (Cinzel + Manrope + JetBrains Mono;
hammered iron + amber + ember palette).

Audience: Lila internal team + leadership (mixed).
Goal: get everyone on the same page about the WeaponForge prototype.

## File map (deck only)

```
5_WeaponForge_Honkai_Godot/docs/
├─ teammate-deck.html             ← entry point (open in browser)
└─ decks/
   ├─ style.css                   ← theme + sections + responsive + print + reduced-motion
   ├─ scrub.js                    ← Bran 5-tier scrubber + Beats carousel + IntersectionObserver dividers
   └─ assets/
      ├─ heroes/   bran.png · elara.png · vex.png
      ├─ enemies/  slime.png · goblin.png · skeleton.png
      ├─ parts/    r_fire.png · r_ice.png · r_pierce.png · h_iron_edge.png · p_steel_grip.png
      ├─ bran_5tier.png            ← scrubber source (1344×768, 5-frame horizontal strip)
      └─ beats/
         ├─ beat1-combat-read-2E.jpg
         ├─ beat2-forge-draft-2E.png
         ├─ beat3-boss-defeat-2E.png
         ├─ beat4-forge-wheel-pull-2E.jpg
         ├─ beat4b-forge-phase1-part-pull-2E.jpg
         ├─ beat5-hot-paladin-cinematic-2E.png
         ├─ beat6-elara-signature-mission.png
         ├─ beat7-elara-talent-tree.png
         └─ beat8-elara-gear-screen.png
```

## Sections (7 + sticky nav)

`Hero · Bet · What · Roster · Loop · Beats · Build · Next`

- **Hero** — Cinzel staggered-letter wordmark + anvil silhouette + portrait trio (Bran / Elara / Vex rondels in diamond formation).
- **Bet** — Audience / Inversion / Moat 3-column + pull-quote + competitor-landscape `<details>`.
- **What** — Pull / Equip / Fight 3-column + FTUE 10-min `<details>`.
- **Roster** — 7 hero cards (3 FTUE real portraits + 4 silhouette placeholders) in a rotated grid. **Bran's card is a rectangular 220×290 bg-image frame** (not a circle) holding a 5-tier scrubber.
- **Loop** — ASCII core-loop diagram + 3 progression axes (with shipped/inflight status pills) + `<details>` for 5-wave stage + Catalyst compounds table.
- **Beats** — 8-mockup clickable carousel (featured image + caption card + prev/next arrows + auto-fit thumb strip). Per-beat copy lives in `scrub.js` `BEATS[]` array.
- **Build** — Forge-log timeline (12 milestones with status dots: blue done / glowing amber in-flight / dim queued) + sticky right rail (test count / branch / Godot version / save schema).
- **Next** — Build queue + human gates + exit gates + closing line + footer links.

## Locked design choices (don't reverse without owner sign-off)

- **Direction:** forge industrial × anime rondel (rejected: anime-TCG holo, codex/grimoire, arcade-HUD).
- **Type:** Cinzel display (caps, carved) + Manrope body + JetBrains Mono for code. Three fonts max. NOT Inter.
- **Color:** 8-token forge palette (`--iron-deep / --iron / --iron-2 / --amber / --ember / --gold-leaf / --parchment / --mute`) + rarity colors mirrored from in-game `home_screen.gd`. No purple-on-white anywhere.
- **Motion:** one orchestrated hero reveal (staggered letter fade + ember glow + portrait scale-in + anvil opacity ease) + scroll-triggered engraved divider fade-in + Bran scrubber morph + Beats carousel 200ms cross-fade. `prefers-reduced-motion` respected.
- **Hook:** Bran 5-tier portrait scrubber on the Roster card (`background-image` + `background-size: 500% auto` + `background-position: 0/25/50/75/100%`). Tier labels Basic / Awakened / Ascended / Eternal / Apotheosis (asset-baked).
- **Mobile:** ≤768 px stacks to single column. Sticky nav wraps. Bran scrubber stays usable on touch.
- **A11y:** semantic HTML, AAA contrast on title text, focus rings, keyboard-accessible scrubber + carousel, prefers-reduced-motion fallback, ≥44 px tap targets, role=tab on thumbs.
- **Print:** `@media print` ruleset — white bg, arrows + thumbs hidden, scrubber → tier 3 static, page-break before each section, `<details>` force-open via `details > *:not(summary) { display: block !important; }`.
- **Asset policy:** all images COPIED into `docs/decks/assets/`. Deck does not reach into `Prototype/godot/assets/*` directly. Survives Godot path refactors.
- **Hosting:** local `file://` open is the primary path. GitHub Pages publishing deferred.

## Owner-resolved decisions during the build

- **WEAPONFORGE wordmark** — `white-space: nowrap` on `.hero-title` + font clamp 36-88 px at 8vw + 0.04em letter-spacing. Per-letter spans kept for the entry animation; wrap fixed.
- **Bran scrubber** — rectangular 220×290 frame, not a circle. Background-image approach (not object-fit) — full tier portrait visible head-to-feet with the label band. Slider thumb 22×22 amber circle with ember glow + dark border.
- **Beats section** — caption fonts ~2× bumped (title 22→44, sub 11→18, desc 14→26, intro 16→22). Grid columns 3fr/2fr → 5fr/4fr to give the bigger text room. Stage min-height 360→440. Thumbnail strip uses `repeat(auto-fit, minmax(140px, 1fr))` — wraps gracefully across viewports.
- **101 file** untouched (per owner: maintain that file's RICOCHET-template shape after major GDD changes — no major design change happened on the deck branch).

## Per-beat content (where to edit)

`docs/decks/scrub.js` → `BEATS` array. Each entry has `{ img, alt, title, sub, desc }`. Single-place edit. Add a beat → also add a `<button class="beats-thumb" data-idx="N">` in `docs/teammate-deck.html` and a corresponding image in `docs/decks/assets/beats/`.

## How to resume DECK work on a future fresh branch

The deck is conceptually independent of any feature branch — it was authored on `forgeloop/teammate-deck` (now FF-merged into `forgeloop/catalyst-element-pairs`), but future deck iterations should cut from `main` after the upstream merges.

```bash
# 1. Confirm the deck has landed on main (catalyst merge has happened):
git checkout main && git pull --ff-only
ls 5_WeaponForge_Honkai_Godot/docs/teammate-deck.html

# 2. Cut a fresh deck-continuation branch off main:
git checkout -b forgeloop/<deck-iteration-name>
# Examples: forgeloop/deck-real-screenshots, forgeloop/deck-key-art,
#           forgeloop/deck-101-mirror, forgeloop/deck-gh-pages

# 3. Edit + test in browser (no Godot, no MCP, no test suite).

# 4. Commit per logical unit. Push. Owner-gated merge.
```

## Likely future deck iterations (owner-driven, not yet requested)

| Iteration | Why | Effort |
|---|---|---|
| **Swap mockups → real screenshots** | Currently shows 2E-pass mockups. Owner intended to drop in real-build screenshots once the in-game UI polish lands. | ~30 min per beat (capture + crop + caption refresh) |
| **Generate hero key art** | Hot Paladin / 2nd Rogue / 2nd Mage / Hot Assassin are silhouette placeholders. Generate via nano-banana (~$0.04/img per CLAUDE.md cost policy — confirm before each call). | ~$0.16 + 30 min |
| **Add more beats** | When Hot Paladin descent or Elara arc become real in-game cinematics (not concept art), swap the matching beat. | ~10 min per beat |
| **101 file sync** | Per owner: maintain `101-WeaponCraft-Concept.md` RICOCHET-template after major GDD changes. Renames the file in the process. | ~1 h |
| **GitHub Pages publish** | For a shareable URL. Deferred per deck spec §16. | ~30 min |
| **Print proof** | The `@media print` ruleset exists but hasn't been owner-proofed in actual print preview. | ~10 min visual check |
| **Aesthetic re-skin** | If owner ever wants to flip direction (anime-TCG holo, arcade-HUD, etc.), revise the deck spec FIRST + get sign-off; then re-author CSS. | multi-session |

## Spec + plan (authoritative)

- **Spec:** `docs/superpowers/specs/2026-06-09-teammate-deck-design.md` (20 sections, owner-approved). If a future change wants to repaint the deck's aesthetic, update spec first.
- **Plan:** `docs/superpowers/plans/2026-06-09-teammate-deck.md` (19 tasks across D-1 / D-2 / D-3 chunks; all executed this session).

## Test conventions (deck has no automated tests)

This is HTML/CSS/JS — no game-logic, no Godot tests apply. Verification is the manual checklist in the spec §17:

- Loads in Chrome / Firefox / Safari w/ no console errors.
- All 12 base assets + 9 beat images resolve (no 404 in Network tab).
- All 7 `<details>` collapsibles open + close.
- Bran scrubber drags through 5 tiers; caption updates to Basic / Awakened / Ascended / Eternal / Apotheosis.
- Beats carousel: clicking a thumb + prev/next arrows swap the featured beat; aria-selected updates.
- Mobile (≤768 px DevTools): sections stack, scrubber works on touch, no horizontal scroll outside the loop ASCII.
- Reduced-motion (DevTools → Rendering → emulate): all animations instant.
- Lighthouse: perf ≥ 90, a11y ≥ 95.
- Print preview: white bg, `<details>` expanded, scrubber → static tier 3.

## Last touched

- Branch this lived on while authored: `forgeloop/teammate-deck` (FF-merged into `forgeloop/catalyst-element-pairs` at tip `3b091dc` on 2026-06-09).
- Last deck commit: `2a992b8` — "deck(beats): add 2 Elara concept screens (talent tree + gear screen)".
- File state on disk reflects this commit; owner has visually verified the deck works.

## Standing reminders that apply to deck work

- No automated tests — manual visual checklist substitutes.
- Per CLAUDE.md §12 image-gen cost policy: default `nano-banana` ($0.04/img); never `nano-banana-pro` without explicit owner ask per call.
- Asset copies live in `docs/decks/assets/`. Don't reach into `Prototype/godot/assets/*` directly.
- Per CLAUDE.md §2: in-place branches, no `.claude/worktrees/*`, push freely on feature branches, merge to main = owner say-so only.
- Per CLAUDE.md §10: update `01_GDD.md` inline when design changes. The deck reflects the GDD; if the GDD shifts, the deck shifts.
