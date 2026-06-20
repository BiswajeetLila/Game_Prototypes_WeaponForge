# test-run/ — first-run fixture inputs (NOT part of the generic skill)

Isolates the test target's specifics so `skill/SKILL.md` stays game-agnostic. The first full run feeds these in.

## Fixture: 6_WeaponForge_TFTransistor
- **`<game-folder>`:** `C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\6_WeaponForge_TFTransistor`
- **Genre:** casual tactical auto-runner / autobattler (pattern-library key: `tactical-autobattler`)
- **Comparables:** Capybara Go · Wittle Defender · Brotato · Slice & Dice · AFK Journey
- **Read for product sense:** `<game-folder>/docs/01_GDD.md`, `docs/story-beats-2026-06-13.md`
- **Cold-start ref + hosted URL:** `<game-folder>/_art-build/ref-gameplay.png` → `https://i.ibb.co/zhz3TFPq/Gemini-Generated-Image-dhm62ndhm62ndhm6.png` (from `_art-build/manifest.md`)
- **Truth-cut footage source (if used):** AUTOSHOT (`WC_AUTOSHOT` + `screenshot_helper.gd`) of FTUE 1–3.

## Proposed M0 brief (edit at run time)
- **Primary action:** playtest signup (no store yet). **KPI:** predicted hook-rate (3s) + persona-panel pass.
- **Persona:** ex-Archero / Capybara-Go player, bored of one-button autobattlers, wants build expression without APM, watching Reels on commute, **sound OFF**.
- **The ONE hook:** *forge functions, not pulls* + cross-hero reaction chains ("I CAUSED THAT").

## Expected run output
`6_WeaponForge_TFTransistor/_art-build/marketing-reels/<YYYY-MM-DD>/` — verify with `python ../tests/check_run.py <that-folder>`.
