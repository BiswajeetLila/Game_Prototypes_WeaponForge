# Scripted Pacing Rework — Design Spec

**Status:** draft 2026-06-09, owner review pending.
**Branch:** `forgeloop/scripted-pacing-rework`.
**Author:** owner + Claude.
**Builds on:** Catalyst v1 (`2026-06-09-catalyst-design.md`) + the FM-8 hero-attachment probe lineage.
**Successor to:** the original Hot Paladin entry plan (was queued as STATUS §4 NEXT item #2 with the spec's "Stage 2 wave 14" trigger — now Stage 3 boss W5 in the compressed 5-wave shape).

---

## 1. Goal

Layer narrative scripted-pacing on top of the Catalyst v1 mechanics. Tighten the FTUE elemental-reveal cadence to 3 pull beats + 1 stage-defeat beat:

| # | Beat | Trigger | Drop | Hero | Tier |
|---|---|---|---|---|---|
| 1 | First fire reveal | Pull #1 | Cinderbrand Greatsword | Bran | Epic fire ⚒️ |
| 2 | First electric reveal | Pull #3 | **NEW Voltedge Daggers** | Vex | Rare ⚡ |
| 3 | Hot Paladin descend | Stage 3 boss W5 50% HP | scripted defeat → **Helios Cleaver** | Paladin | Epic light ☀ |
| 4 | First ice reveal | Pull #5 | Glacial Aegis Staff | Elara | Legendary ❄ |

Each hero gets their elemental moment. Beats 1+2 prime the player. Beat 3 is the FM-8 hero-attachment payoff (overwhelmed by the boss → rescued by Paladin). Beat 4 unleashes Stage 5's first no-cap-stage Catalyst stack (fire+ice+electric+light → multi-compound storm).

---

## 2. Scripted timeline — detail

### Pull #1 — Bran Epic Fire (unchanged from Catalyst v1)
- Sentinel: `&"pull_1_fire_warrior"` (existing).
- Drop: `w_cinderbrand_greatsword` (Epic warrior fire).
- Auto-equip: Bran's class slot.

### Pull #3 — Vex Rare Electric (CHANGED — was Elara ice)
- New sentinel: `&"pull_3_electric_rogue"`.
- Drop: NEW `w_voltedge_daggers` (Rare rogue electric — see §4.1 for stats).
- Auto-equip: Vex's class slot (if Vex is currently empty-handed of elementals OR per Bug 1 deferred — see §11 Open Qs).

### Pull #5 — Elara Legendary Ice (NEW position — was pull #3)
- New sentinel: `&"pull_5_ice_mage"` (renamed from `&"pull_3_ice_mage"`).
- Drop: `w_glacial_aegis_staff` (Legendary mage ice — existing catalog).
- Auto-equip: Elara's class slot.

### Pull #2 / Pull #4 / Pull ≥6 — Normal RNG
- No script. `_weighted_pick` runs.
- Sentinel-presence + `pull_count + 1` gating per existing logic.

### Stage 3 boss W5 mid-fight — Hot Paladin defeat
- Trigger: Arcane Lich (Stage 3 boss per `STAGE_BOSS_ROTATION`) `hp <= max_hp * 0.5` AND `&"defeat_stage_3_paladin"` NOT in `scripted_pulls_seen` AND `is_boss` AND `wave == 5`.
- Effect: scripted overwhelming AOE deals 999 dmg to every alive squad hero (instant wipe). All 3 deployed heroes drop to 0 HP within 1-2 ticks. No save scumming this — the AOE is unblockable.
- Sentinel set + `paladin_unlocked = true` + autosave.
- `Combat` emits `paladin_descend` signal (new).
- `main.gd` listens, freezes combat, shows defeat-then-descend cinematic (placeholder text overlay for v1 — full motion deferred to v1.1).
- Helios Cleaver granted to Paladin's owned-weapons slot. Auto-equipped on Paladin.
- "RETRY STAGE 3" button reveals on the defeat panel.
- On retry, scripted-wipe trigger is SKIPPED because sentinel is already in `scripted_pulls_seen`. Normal lich phase 2 plays through. Player wins with 4-roster-3-deploy (can rotate Paladin in).

---

## 3. New element: light ☀

Light joins fire/ice/electric/wind/earth in the element set. Earth was already in CatalystData but S10-gated; light is FTUE-accessible (post-Stage-3-defeat).

| Element | StringName | Glyph | Status |
|---|---|---|---|
| fire | `&"fire"` | 🔥 | FTUE |
| ice | `&"ice"` | ❄ | FTUE |
| electric | `&"electric"` | ⚡ | FTUE |
| wind | `&"wind"` | 🌪 | FTUE |
| earth | `&"earth"` | 🪨 | S10+ gated |
| **light** | **`&"light"`** | **☀** | **FTUE (post-defeat)** |

`CatalystData.ELEM_GLYPH` extends with `&"light": "☀"`. UI surfaces using ELEM_GLYPH inherit the change.

### Light catalog membership

- `w_helios_cleaver` (Epic paladin/light) — see §4.2.
- **No other light weapons in the gacha pool.** Helios is scripted-grant only. ForgeWheel's `eligible_weapons()` must EXCLUDE light weapons (add to `STARTER_IDS`-style exclusion list, see §6).

### Light-pair Catalyst compounds — 4 new

| Pair | Compound | v1 starting bag |
|---|---|---|
| Light + Fire | **Solar Flare** | +20% squad ATK (mirrors Firestorm's tier) |
| Light + Ice | **Halo Bloom** | +15% squad ATK · +10% crit |
| Light + Electric | **Plasma Arc** | +25% squad ATK |
| Light + Wind | **Auroral Veil** | -20% enemy atk-spd (mirrors Blizzard's tier) |

Numbers Policy starting values. Tune after playtest. Total compound count: 10 (Catalyst v1) + 4 (light) = **14 in codex**.

### Alphabetical priority order (display)

Existing order: Blizzard > Firestorm > Glacial Storm > Plasma > Stormfront > Wildfire > [Magnetic Storm > Permafrost > Sandstorm > Volcanic at S10+].

Light compounds insert in alpha position:

- **Auroral Veil** (precedes Blizzard)
- (Blizzard, Firestorm, Glacial Storm)
- **Halo Bloom** (between Glacial Storm and Plasma)
- (Plasma)
- **Plasma Arc** (immediately after Plasma)
- **Solar Flare** (between Plasma Arc and Stormfront)
- (Stormfront, Wildfire)
- (Earth quartet at S10+)

Final 14-row codex order: Auroral Veil > Blizzard > Firestorm > Glacial Storm > Halo Bloom > Plasma > Plasma Arc > Solar Flare > Stormfront > Wildfire > Magnetic Storm > Permafrost > Sandstorm > Volcanic.

Implementer: update `CatalystData._PRIORITY_ORDER` const.

---

## 4. New catalog weapons

### 4.1 Voltedge Daggers (NEW Rare electric rogue)

`data/weapons/w_voltedge_daggers.tres`:
```
id = &"w_voltedge_daggers"
name = "Voltedge Daggers"
cls = &"rogue"
ability = "Static Burst"
rune = &"electric"
recipe = &""
base_atk = 21
base_hp = 12
base_crit = 10
base_ult_rate = 5
rarity_idx = 1  ## Rare
```

Slots into the existing 12-weapon catalog → 13 total. Rarity 1 (Rare) fits between Stormpierce Fangs (C, non-elemental post-B2) and Stormfang Reapers (L, electric). Catalog now has a Rare electric rogue (was missing).

### 4.2 Helios Cleaver (NEW Epic light paladin)

`data/weapons/w_helios_cleaver.tres`:
```
id = &"w_helios_cleaver"
name = "Helios Cleaver"
cls = &"paladin"
ability = "Solar Smite"
rune = &"light"
recipe = &""
base_atk = 28
base_hp = 30
base_crit = 8
base_ult_rate = 10
rarity_idx = 2  ## Epic
```

Excluded from gacha pool (see §6). Granted on Stage 3 defeat cinematic via `AccountState.acquire_weapon` + `AccountState.equip(&"paladin", idx)`.

---

## 5. Hot Paladin hero

### Identity
- `id = &"paladin"`, class `&"paladin"` (new class — currently only warrior/mage/rogue in code).
- Display name: "Hot Paladin" (per CLAUDE.md §13 roster line).
- Lore: sun-knight. Descends to rescue the squad when overwhelmed by Stage 3 lich.
- Locked at first boot. Unlocks via Stage 3 boss scripted-defeat.

### Stats — Numbers Policy starting values
- `atk_base = 8` (mid-tier between Bran 6 / Elara 7 / Vex 7).
- `hp_base = 100` (tank-leaning).
- `ult_name = "Solar Burst"` (placeholder ability — full kit deferred to v1.1).
- `ult_atk_multiplier = 2.5x` (mid between Bran Whirlwind 3.0x and Elara Meteor 2.0x).
- `sprite = "paladin"` (placeholder asset to be authored).

### Hero data file
New `data/heroes/paladin.tres` (mirrors existing hero .tres shape — read `bran.tres` for the template).

---

## 6. Forge Wheel scripted-grant exclusion

`forge_wheel.gd::eligible_weapons()` currently includes all 12 catalog weapons (no exclusion logic added in B3 — owner-amended; Common starters stay in pool).

C2 adds a `SCRIPTED_GRANT_IDS` const list of weapon ids that are NEVER in the gacha pool — granted ONLY via scripted events:

```gdscript
## Scripted-grant-only weapons (Hot Paladin defeat, future cinematic events).
## Excluded from eligible_weapons() so RNG never pulls them. They live in the
## catalog only so AccountState.acquire_weapon can hand them out on cue.
const SCRIPTED_GRANT_IDS: Array = [&"w_helios_cleaver"]
```

`eligible_weapons()` filters `if id in SCRIPTED_GRANT_IDS: continue`.

This pattern allows future scripted-grant weapons (e.g. Master Smith S10 cinematic) without re-architecting the gacha.

---

## 7. Combat scripted-wipe + Paladin descend

### Trigger inside `_boss_tick_arcane_lich(idx, boss)`

Existing lich tick handles phase 1 (build-up) and phase 2 (AOE every N ticks). Add a NEW phase-2-entry hook:

```gdscript
## Scripted defeat trigger — fires ONCE per account when lich enters phase 2
## (hp crosses 50% threshold) AND Paladin hasn't been unlocked yet.
const PALADIN_DEFEAT_SENTINEL: StringName = &"defeat_stage_3_paladin"

func _maybe_trigger_paladin_defeat(boss) -> void:
	if PALADIN_DEFEAT_SENTINEL in AccountState.scripted_pulls_seen:
		return   ## already triggered; retry path proceeds normally
	if float(boss.hp) > float(boss.max_hp) * 0.5:
		return   ## haven't crossed the threshold yet
	## Mark + scripted overwhelming AOE: 999 dmg to every alive squad hero.
	var seen: Array = AccountState.scripted_pulls_seen
	seen.append(PALADIN_DEFEAT_SENTINEL)
	AccountState.scripted_pulls_seen = seen
	AccountState.paladin_unlocked = true
	## Auto-grant + equip Helios Cleaver on Paladin
	var helios = GameState.weapons_by_id.get(&"w_helios_cleaver")
	if helios != null:
		var owned = AccountState.acquire_weapon(helios)
		AccountState.equip(&"paladin", AccountState.owned_weapons.size() - 1)
		GameState.equip_weapon_data(&"paladin", owned)
	AccountState.autosave()
	## Apply the scripted AOE
	for h in GameState.active_heroes():
		h.hp = 0
	emit_signal(&"paladin_descend")
```

Existing lich phase-2 entry calls `_maybe_trigger_paladin_defeat(boss)` BEFORE phase-2 AOE damage logic. On retry the sentinel-guard short-circuits and phase 2 plays through normally.

New `Combat.paladin_descend` signal. `main.gd` listens + shows cinematic placeholder + reveals "Continue" button → routes to retry.

### Stage 1 neutrality contract preserved
- Stage 1 boss is slime_king (not lich). Trigger doesn't fire.
- Existing TestCombat assertions unaffected.

---

## 8. Roster expansion — 4 heroes, 3 deploy

Per CLAUDE.md §13 deploy stays at 3. Roster grows to 4 (Bran, Elara, Vex, Paladin) once Paladin unlocks.

`GameState`:
- `ROSTER_IDS: Array = [&"bran", &"elara", &"vex", &"paladin"]` (was 3).
- `active_heroes()` filters on `_unlocked` flag — Paladin's flag = `AccountState.paladin_unlocked`.
- `fielded_classes()` adds `&"paladin"` when Paladin unlocked.

`home_screen.gd`:
- Pre-defeat: 3 hero rows (Bran/Elara/Vex). 4th row = "🔒 Locked" placeholder.
- Post-defeat: 4 hero rows. Squad-selection UI lets player pick 3-of-4 for the next stage.

`forge_wheel.gd`:
- `_first_hero_of_class(&"paladin")` returns `&"paladin"` once unlocked.

`StageAffinity`:
- Stage 3 boss `weak_tag = &"light"`, `resist_tag = &"earth"` (placeholder — Earth-gated until S10 so player can't bring it either).

### Pre-defeat boss telegraph confusion
- Pre-stage 3 briefing dialog shows: "👑 Arcane Lich · weak: ☀ light · resist: 🪨 earth".
- Player has no light access (Helios is scripted-only, only granted post-defeat). Earth gated S10+.
- Narrative payoff: "boss telegraphed light weakness; we couldn't bring light; Paladin arrives with light; retry trivializes the boss."

---

## 9. AccountState v5 → v6 schema bump

Add `paladin_unlocked: bool = false` field. Migration: v5 saves load with `paladin_unlocked = false`. Round-trip + reset cover the field.

```gdscript
const SAVE_VERSION: int = 6   ## v6 adds paladin_unlocked
...
var paladin_unlocked: bool = false
```

`reset_account()` clears: `paladin_unlocked = false`.
`to_save_dict()` emits.
`load_from_dict()` reads with default false; accept v2-v6.

Sentinel `&"defeat_stage_3_paladin"` lives in the existing `scripted_pulls_seen: Array[StringName]` — no new array needed.

---

## 10. Numbers Policy starting values

All numbers in §3, §4, §5 are starting values per CLAUDE.md §8. Playtest tune-pass commits will adjust.

Key candidates for tuning:
- Voltedge Daggers atk 21 (R electric rogue baseline).
- Helios Cleaver atk 28 (E light paladin baseline).
- Paladin atk_base 8 / hp_base 100 / ult_mult 2.5x.
- Light-pair compound bag values (Solar Flare 1.20x, Halo Bloom 1.15x + 0.10 crit, Plasma Arc 1.25x, Auroral Veil 0.80 enemy atk-spd).
- Scripted AOE damage 999 (effectively `INT_MAX`; locked).

---

## 11. Owner-resolved decisions (locked 2026-06-10)

- **Light glyph:** ☀ (sun-knight thematic, default accepted).
- **Compound names:** Solar Flare / Halo Bloom / Plasma Arc / Auroral Veil — accepted as-is (Numbers Policy tunable later).
- **Voltedge Daggers stats:** atk 21 / hp 12 / crit 10 / ult 5 — accepted (R-tier baseline).
- **Helios Cleaver stats:** atk 28 / hp 30 / crit 8 / ult 10 — accepted (mid-Epic, paladin tank-leaning).
- **Paladin ult kit:** placeholder Solar Burst 2.5x AOE for v1. Distinctive kit deferred to v1.1.
- **Pre-defeat boss telegraph:** cold ("weak: ☀ light · resist: 🪨 earth"). No "you may not have what you need" hint. Player learns from the wipe.
- **Scripted-pull auto-equip override:** YES — scripted picks (`_try_scripted_pick` results) force `AccountState.equip(hero_id, idx)` regardless of `get_equipped(hero_id)` state. RNG pulls keep current go-to-bench behavior (Bug 1 remains discarded for organic pulls).
- **Stage 3 retry squad default:** Paladin auto-included in the deployed 3 (player can swap him out via squad-selection if they want — but default = Paladin on the team).

## 11a. Economy adjustment — Option A (locked)

Ember accrual is bumped so the scripted-pull timeline lands consistently:

```
EMBER_BOSS_BONUS      1 -> 3
EMBER_VICTORY_BONUS   2 -> 4
```

Total per cleared stage = **7 ember** (was 3). Pull cost unchanged at 5. Net 1+ pull per stage with a small buffer for tail-end ramp.

### Per-stage ember math (Option A locked)

| Beat | Ember pre | Action | Ember post | Pull # |
|---|---|---|---|---|
| Boot | 5 | Pull #1 Bran fire scripted | 0 | 1 |
| Stage 1 clear | 0 | +7 (boss 3 + victory 4) | 7 | — |
| Pull #2 (mid-stage 2) | 7 | RNG | 2 | 2 |
| Stage 2 clear | 2 | +7 | 9 | — |
| Pull #3 Vex electric scripted | 9 | cost 5 | 4 | 3 |
| Stage 3 first attempt | 4 | scripted wipe → no clear bonus | 4 | — |
| Stage 3 retry clear | 4 | +7 | 11 | — |
| Pull #4 (mid-stage 4) | 11 | RNG | 6 | 4 |
| Stage 4 clear | 6 | +7 | 13 | — |
| Pull #5 Elara ice scripted | 13 | cost 5 | 8 | 5 |
| Stage 5 entry | 8 | no-cap multi-compound stack ✓ | — | — |

Pacing lands clean. Pull #3 (Vex) consistently lands BEFORE Stage 3 boss. Pull #5 (Elara) lands BEFORE Stage 5 (first no-cap stage).

## 11b. Hot Paladin descend cinematic asset (locked)

The descend cinematic uses a single full-screen reveal image:

- **Source:** `5_WeaponForge_Honkai_Godot/Mockup/all-mockups/A13_paladin-entry_2E-ref.png` (1.4MB, 2E mockup-quality reference).
- **Godot asset path:** `Prototype/godot/assets/generated/cinematics/paladin_entry.png` (copied + tracked).
- **Display:** when `Combat.paladin_descend` fires, `main.gd` builds a full-screen `ColorRect` dim overlay + `TextureRect` showing the paladin image, centered. Fade-in over 0.6s, hold 2.0s, "Continue" button reveals → routes to retry.
- **Cinematic copy:** placeholder text overlay: "💎 HOT PALADIN DESCENDS\nHelios Cleaver — Light burns the lich." (Numbers Policy tunable.)

---

## 12. Out of scope (v1.1+)

- Full Hot Paladin kit (proper ult, ability, cinematic motion design, voice).
- Light-pair rich effects (chain heal, holy AoE cleanse, taunt-on-trigger).
- Light tier in Forge Wheel pool (Helios stays scripted-grant only; no Rare/Common/Legendary light weapons exist yet).
- Future scripted-grant events (Master Smith S10 / Hot Assassin / etc).
- Paladin's `_grant_starter_if_first_boot` integration — Paladin starts LOCKED, not granted at boot.

---

## 13. Build sequencing — 4 chunks

### Chunk A — Data + light element
- A1: Add `w_voltedge_daggers.tres` to `data/weapons/`. Register in `GameState.weapon_ids`. Tests: catalog count 12 → 13, electric-rogue-Rare assertion.
- A2: Add `w_helios_cleaver.tres` to `data/weapons/`. Register in `GameState.weapon_ids`. NO addition to gacha pool (filtered out in B).
- A3: Add `data/heroes/paladin.tres`. Register in `GameState`. Locked by default.
- A4: Extend `CatalystData.ELEM_GLYPH` with `&"light": "☀"`.
- A5: Add 4 light-pair compounds + update `_PRIORITY_ORDER` (insert in correct alpha positions). TestCatalyst +6-8 asserts.
- A6: AccountState v5 → v6 (add `paladin_unlocked`). Migration test. TestAccountState +3-4 asserts.

### Chunk B — ForgeWheel scripted-pull reshuffle + exclusion
- B1: Add `SCRIPTED_GRANT_IDS` const + filter `eligible_weapons()`. Test: Helios not in pull pool.
- B2: Rename `SCRIPT_PULL_3_SENTINEL` → `&"pull_3_electric_rogue"`. Add `SCRIPT_PULL_5_SENTINEL` = `&"pull_5_ice_mage"`. Update `_try_scripted_pick` to fire on pull_count+1 == 1, 3, 5. Update existing tests + add pull-5 test. Update Catalyst v1's CLAUDE.md §13 "Catalyst first reveal" entry.

### Chunk C — Combat scripted-wipe + Paladin descend
- C1: Add `Combat.paladin_descend` signal + `PALADIN_DEFEAT_SENTINEL` const + `_maybe_trigger_paladin_defeat` helper.
- C2: Wire trigger into `_boss_tick_arcane_lich` phase-2-entry path. Test: trigger fires on first phase-2 entry; doesn't re-fire on retry; doesn't fire on non-lich bosses.
- C3: GameState roster expansion (4 ids, paladin locked by default). `active_heroes()` filters.
- C4: `home_screen.gd` Paladin row (locked → unlocked toggle). Squad-line shows 4 icons (3 deploy still).
- C5: `main.gd` listens to `paladin_descend` → cinematic overlay placeholder + Continue → routes to retry.

### Chunk D — UI integration + retry flow
- D1: `catalyst_codex.gd` renders 14 rows. Light-pair rows show ☀+X icon. TestCatalystUI codex count 10 → 14.
- D2: Pre-stage 3 briefing telegraphs "weak: ☀ light". StageAffinity .tres update for Arcane Lich.
- D3: Stage 3 retry button on defeat panel. Re-enter stage with sentinel set → normal phase 2 plays.
- D4: Squad-selection UI accommodates 4 heroes (still 3 deploy). Default: include Paladin in retry squad.

---

## 14. Acceptance criteria

A reviewer of this spec should be able to:

- Name the 4 scripted beats + their triggers (pull 1/3/5 + Stage 3 boss W5 50% HP).
- Explain why Vex gets Rare and Elara gets Legendary (FTUE pacing — Vex's reveal is mid-loop while Elara's is the climax).
- Explain why Helios Cleaver isn't in the gacha pool (scripted-grant only; preserves the descent moment).
- Locate the scripted-wipe trigger code path (§7 — `_boss_tick_arcane_lich` extension).
- Locate the AccountState v6 migration (§9).
- Identify the 4 new light-pair compound names (§3) and their alpha-priority insertion points.
- Trace what happens on a player who retries Stage 3 (sentinel-guard skips the AOE; normal phase 2 plays through; 4-roster lets player rotate Paladin in).

If any of those is unclear, this spec needs a revision pass before the implementation plan starts.
