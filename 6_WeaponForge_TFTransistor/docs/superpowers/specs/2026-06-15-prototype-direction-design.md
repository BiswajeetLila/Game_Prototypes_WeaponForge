# Prototype Direction — WeaponForge TFTransistor (post grill-me + CEO review)

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md). **Date:** 2026-06-15 · **Branch:** `weaponforge-tftransistor/post-slice-phase5`.
> **Status: STRATEGIC DIRECTION LOCKED. Content (final Functions, juice, items/synergies/catalysts, Wittle-meta) PARKED** for the next session — user has more info to share. This doc is the validated *direction*, not the full implementation spec. Do NOT start the writing-plans / TDD build until the parked content is finalised.

## How we got here
Brainstorm → Gear-Defenders overlay → grill-me → plan-ceo-review. The overlay finding that triggered the rethink: the REVIEW-3 build dropped **both** GD's 4×4 adjacency puzzle **and** TFT's board positioning, leaving auto-combat + a socket-menu forge = the **"passive screensaver"** failure the original pivot addendum existed to kill.

## LOCKED decisions (the spine)
1. **Dominant thrill** = collection power-fantasy (Wittle / AFK / Gear-Defenders lane) **+ a hint of optimization-roguelike**. Runs sit inside a persistent collection shell.
2. **Agency** = **light placement** — lane-assignment (drag heroes onto lanes vs the telegraphed enemy weakness) + **Modifier-socket-as-connector** (GD-style forge adjacency that buffs/warps neighbour sockets) + **ult timing**. Combat stays **auto-resolved**. This is the anti-screensaver fix.
3. **Persistence** = **collection persists** (heroes, levels/XP, unlocked-Function codex, currency, slot-unlocks); the **per-run loadout drafts fresh** from the shop; **partial reward on loss**; heroes revive; **NO across-run permadeath**. (Reverses the per-world Function wipe + hard defeat that fought the hook.)
4. **Prototype proof, STAGED:** first few plays prove **agency/anti-screensaver + FTUE onboarding clarity**; later plays prove **pull-urge/collection + heavier Wittle-Defender meta** lifted almost as-is on top.
5. **CEO scope posture = MOAT-FIRST.** The moat is the **cross-hero Magicka reaction MOMENT**, and it is **unproven-legible** on a portrait auto-combat screen. → **Contract** combat breadth (a tight ~6-Function set for the prototype, NOT the full 12), **deepen** reaction legibility + juice (telegraph the setup, slow-mo the pop-off, chain-counter dopamine, crystal cause→effect VFX + audio), and **stage** the wide meta. **Combat = narrow/deep/legible; meta = wide/generous.**

## The moat (product identity)
> "The one where you line up your team's elements and the whole screen chain-reacts." Magicka-meets-mobile-defender, famous for the pop-off.

Everything else (shop, merge, gacha, levels, tiers, lanes) is genre-commodity. The cross-hero reaction is the only non-commodity asset. **#1 risk = legibility** — if a cold player can't *see* the reaction they set up, the moat is invisible and the game is a me-too. The prototype must nail it.

## What this CHANGES vs the current build
- **Combat breadth:** 12 Functions is premature → prototype uses a tight set (final list TBD next session). The 6-Function slice may have been right.
- **New agency layer:** lane-assignment + Modifier-as-connector adjacency.
- **Persistence rework:** collection persists; soften permadeath → partial reward + revive; reconsider the per-world Function wipe.
- **Reaction juice + legibility = top build priority** (telegraph, slow-mo, chain HUD, per-reaction VFX/audio, unmistakable cause→effect).
- **Hero leveling → slot unlocks** (2 sockets → 3rd @Lv5; reserves @Lv10/15) — **low thresholds for the prototype** so testers feel an unlock in 1–2 runs.
- **Gacha pull → reveals Ashe** (archer; bow weapon-passive **reformats her items into projectiles**). Real-feeling pull, no currency economy.
- **Per-hero innate weapon-passive** (distinct from the Function Passive slot): Bran/sword=Slash, Ashe/bow=projectile, etc.
- Reserve is **level-gated** (supersedes the flat reserve=1 just shipped).

## PARKED for the next session (do NOT finalise the spec without these)
1. **Final Function set + the "juicy bits"** — the moat's content: which Functions/reactions make the prototype, and the exact legibility + juice design (the user has more info).
2. **Items / Synergies / Catalysts deep brainstorm** — define **"catalyst"** (new term, undefined: possibly Modifier-as-connector / a reaction-amplifier item / GD-Jewel-style socket gem); star-up & evolution (T5 FIRE→INFERNO); set-bonuses (a gap GD lacks); synergy surfacing (math + forge preview text + live damage number + combo-ready indicator); Ashe projectile rules.
3. **Wittle-meta lift** — which Wittle Defender systems get lifted ~as-is as the Layer-2 retention engine (research spec: `docs/research/reference-games/Wittle Defender/`).
4. **Balance pass** — hero vs enemy curves per stage, gold econ, partial-reward numbers, low-threshold leveling values.

## NOT in prototype scope (guardrails)
Full gacha currency/economy, repeatable pulls, multi-world, full Wittle-meta build, real multi-phase boss AI, monetization, localization, 2.5D battlefield.

## Next step
Resume the parked content discussion → finalise Functions + juice + items/synergies/catalysts + Wittle-meta → write the full implementation spec → `writing-plans` → TDD build, **moat-first** (reaction legibility + juice + light placement + FTUE before any wide content).
