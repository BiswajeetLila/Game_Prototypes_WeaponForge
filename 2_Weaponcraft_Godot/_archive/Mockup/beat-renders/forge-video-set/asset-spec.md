# Asset Spec — Forge Video Starter (single deliverable)

**Genre archetype:** Casual-mobile auto-battler w/ crafting layer (Wittle Defender / Archero / Hero Wars cohort).
**Scope override:** User requested ONE deliverable — the forge-video starter image (img2vid source for /ai-video-beats). Skip key art, UI frame set, app icon, manifest variants.

---

## A01 · forge-screen-starter (the only deliverable)

| Field | Value |
|---|---|
| **id** | A01 |
| **bucket** | gameplay-mockup |
| **stage tag** | Stage 1 — pre-wave forge state |
| **aspect** | 9:16 portrait |
| **export resolution** | 864×1536 (skill default) |
| **model** | nano-banana base ($0.04) |
| **ref-lock anchor** | `forge-video-anchor.jpg` (CDN: https://cdn.syntheticalresearch.com/image/biswajeet@lilagames.com/2026-06-09/be5951b9-8ec8-44aa-8108-7df3e91107ec.jpg) |
| **file** | `forge-screen-v2.png` |

### Refinements vs anchor
| Anchor issue | v2 fix |
|---|---|
| START WAVE green-looking button (should be greyed pre-equip) | Explicit "GREYED OUT — slot-coverage not met" |
| Two "ATK 6" labels (redundant) | Single "ATK 6" stat near anvil |
| 5 anvil labels for 3 zones (BLADE ZONE/HEAD/HILT/POMMEL RUNE-SOCKET/RUNE — confusing) | ONE clean label per zone: "HEAD" (blade tip), "HILT" (grip), "RUNE" (pommel socket) — small tag w/ thin connecting line |
| Glow telegraphs could be stronger | Increase glow brightness on the 3 empty socket zones — clear "drop here" affordance for img2vid |

### Hierarchical prompt (built from Style Bible)
- **Subject** — empty anvil sword w/ 3 visible drop-target socket zones, all clearly outlined w/ pulsing colored glow
- **Composition** — 8-strip vertical layout (arena/log/hero-card/anvil/start-wave/shop/inventory)
- **Action** — STATIC pre-wave state, Bran ready in arena, slime teaser silhouettes off-screen right, anvil empty + glowing drop zones
- **Location** — wood/parchment forge UI, stone arena BG w/ torches + crowd silhouettes
- **Style** — painterly stylized 2D cel-shaded mobile-RPG (Castle Crashers / Wittle Defender register)
- **Edit** — refined version of the anchor w/ above fixes

### Pass tests
- [ ] 3 anvil zones labeled HEAD / HILT / RUNE w/ clear glow outlines (img2vid will target these)
- [ ] Shop 5 cards: HEAD / HILT / RUNE / HEAD / CONSUMABLE w/ multi-tag chips visible
- [ ] START WAVE button visibly GREYED
- [ ] NO violet pills anywhere
- [ ] Bran on-model (brown hair, green vest, red cape)
- [ ] Slime teaser silhouettes on right edge of arena
- [ ] All UI text legible (Anvil, Head, Hilt, Rune, ATK 6, Pyro Visor, Steel Grip, Fire Rune, Iron Edge, Heal Potion, Reroll (2), Shop, Inventory, etc.)
- [ ] Painterly Castle Crashers register, NO chibi, NO Honkai-realistic

---

## GATE 1 — Cost approval

| Item | Model | Cost |
|---|---|---|
| A01 forge-screen-v2 | nano-banana base | $0.04 |
| **TOTAL** | | **$0.04** |

User scope override = ONE image. Implicit approval per "generate ONLY the image required for forging video". Firing immediately.

## GATE 2 — Pilot review
Pilot = the deliverable itself (single-image scope). Will `Read` inline post-render for user approval.
