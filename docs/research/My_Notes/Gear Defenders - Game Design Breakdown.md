Gear Defenders — Game Design Breakdown
What you do (core loop)
Pick level → Build Phase (drag gears on grid + refresh shop)
    → Battle Phase (12 waves, auto-fight)
        → Boss Wave (final wave)
            → Win → Loot drop + EXP
            → Lose → Partial rewards (still pays)
Per battle = ~3-5 min. Energy cost = 5 per run, cap 30 → 6 runs per session.

Combat geometry — the actual layout
   ┌──────────────────────────┐
   │ ENEMY SPAWN STRUCTURES   │  ← enemies march DOWN
   │ ↓ ↓ ↓ enemies marching   │
   │                          │
   │ ┌────────────────────┐   │
   │ │ ↑ ↑ troops up      │   │  ← lane / battlefield
   │ └────────────────────┘   │
   │                          │
   │  [ Castle HP bar ]       │  ← lose threshold
   │  ┌──┬──┬──┬──┐           │
   │  │  │  │  │  │           │  ← 4x4 GEAR GRID
   │  ├──┼──┼──┼──┤              (your build space)
   │  │  │ ⚙ │  │  │           
   │  ├──┼──┼──┼──┤             
   │  │  │  │  │  │           
   │  ├──┼──┼──┼──┤             
   │  │  │  │  │  │           
   │  └──┴──┴──┴──┘           
   │                          │
   │  Wave 7/12   [▶ Battle]  │
   │  [3-card gear shop strip]│
   └──────────────────────────┘
Top-down portrait. No camera movement.
Troop-gears placed adjacent to Power Core (yellow orb, fixed center) → auto-spawn troops at displayed rate (X/s).
Troops auto-march up the lane, fight enemies, die or kill.
Enemies march down. If they reach the castle line → Castle HP drops.
Castle HP = 0 → lose.
Gear grid — the puzzle
Gear archetype	Function	Example
Troop Gear	Spawns a troop type	Warrior gear → spawns Warriors at 0.4/s
Speed Gear (connector)	Boosts production of adjacent troop gears	Higher tier = bigger boost
Function Gear (buff)	Buffs adjacent troops	Shield Gear = 31% HP shield to neighbors
Hero Gear (v1.4.9 new)	Troop-specific buffs	Targeted enhancement
Skill Gear (v1.4.9 new)	Modifies skill triggers	TBD per source
Merge rule: stack 2 same-tier identical gears on same slot → tier-up. Doubling pattern:

Tier 1 (grey)  → Tier 2 (blue)  → Tier 4 (gold) → Tier 8 (red)
0.14/s         → 0.21-0.35/s    → 0.34-0.71/s   → 0.53/s+
Strategy decisions per build phase:

Which 3 shop gears to buy (refresh costs gold or ad)
Where to place them (adjacency to Power Core matters)
When to merge vs spread (concentrated higher-tier vs broader low-tier)
Where to drop Speed connectors (multiplies adjacent prod)
Function gear placement (Shield neighbors get protection)
Per-wave mechanics layer
Mechanic	Effect
Counter Warning	Mid-wave preview of incoming enemy formation
Counter Active	Banner sweeps → debuff/buff applies briefly
Unhurt 7s	Castle untouched → small HP regen
Timed Buff x1.5	Stackable global multiplier (ad-triggered or daily reward)
Restore Wall	Mid-battle HP repair (ad/gem gated)
Speed toggle x1.5	15-min game speed boost (ad-gated)
Boss banner	Final wave each level, devil-icon slide-in
Progression axes
1. Vertical content (stage map)

Forest Realm (15 stages)
    ↓
Scorched Sands (15 stages)
    ↓
Aquatic / Ocean Realm (15 stages)
    ↓
... more realms ...
Each realm has 3 difficulties:
  Normal → Elite → Nightmare
Top player cap: ~191 levels per difficulty
Wave count per level scales: L1=5 → L2=6 → L3=7 → L4=8 → L5=9 → caps at 12 waves by mid-game.

Within a level: chests at Wave 3, Wave 7, Wave 12 (milestone rewards).

2. Horizontal collection (gacha)

13 named troops at base + Mythic tier added v1.4.9 (Elephant Knight cavalry, Thunder Caller mage)
3 rarities: Rare (5 troops) / Epic (5) / Legendary (4) / Mythic (new)
Gacha pull rates: Legendary 7.66%, Epic 32%, Rare 60%
CRITICAL: ~99% of pull weight = "Troop Materials," not actual new troops. Specific Legendary = 0.0205% per pull (1 in 5000)
Pity:
10 pulls → guaranteed troop
100 pulls → guaranteed Legendary
Pull cost: 20 coins (single) / 180 gems (10-pull) / ad-watch (gated, 5/day)
3. Hero/troop progression (star-up)

Star-up via duplicate pulls + Troop Materials
Stat scaling + visual upgrade per star
Tier-list emerges from this progression depth
4. Castle upgrades

Castle Lv	HP	Troop cap (Chicken Legs)	Upgrade cost
1	325	10	starter
2	1040	13-15	620 coins
3	2070	17	~1000 coins
5	(mid-range)	24	1430 coins
Cap drives field density. Higher cap = more troops on lane simultaneously.

5. Energy + AFK

Energy: 5/run, cap 30, regen ~3-5min per unit
Patrol/AFK: parallel offline reward collection (gold + materials)
30 ⚡ = 6 runs ≈ 30min active session at full speed
6. Daily/weekly cadence

Daily quests (5-chest bar, refresh ~14h):
  - Watch ads 5x → 500 coins
  - Recharge 1x → 1500 coins
  - Complete elite level 1x → 500 coins
  - Complete nightmare level 1x → 500 coins
  - Log in 2x → (auto-check)
Weekly: 5th chest = 300 gems (enough for 1+ pull)
Events:
  - Battle Festival
  - Boss Appears! (limited)
  - Spring sign-in events
  - Raffle ticket events (paywall-gated)
  - Monster Codex (v1.4.9)
Player journey (D1-D30 sketch)
Day	What happens
D1 (first 30min)	Multi-level unskippable tutorial. Forest L1-L3. First gear placed. First merge. First IAP popup (Beginner Pack ~$1.60). Castle Lv1 → Lv2 unlock.
D2	Daily login chest. Counter Warning mechanic appears. First Function Gear (Shield) tutorial. First boss wave (L3).
D3-4	Scorching Sands unlock. First Epic troop from gacha (32% rate). Visible difficulty bump.
D5-7	Difficulty cliff. 30⚡ depleted faster. Patrol/AFK becomes important. Weekly 5th chest = 300 gems → first 10-pull → often Caveman (low-tier Legendary trap).
D8-14	Mid-game wall (~15min mark in any session). Players hit pay/ad pressure. VIP/SVIP purchases begin. Stage-progression walls (spawn-camping enemies).
D15-30	Castle Lv5+. Top players hit content cliff at ~L191. VIP-deception churn moment.
Why it works (4.50★/88k/5M+ installs)
Tactile combinatorial puzzle — "gear alignment strategies are very diverse" (43t/5★). Combine + arrangement + priority decisions per wave.
No forced ads framing — rewarded-only, user-initiated. Goodwill carry until mid-game cliff.
Tier-list-able cast — meta clarity, creator content thrives.
Generous partial-rewards — losing a wave still pays out. Anti-rage-quit.
Castle/troop-cap progression — visible power growth between sessions.
Why it bleeds players
VIP/SVIP "permanent" deception — top 1★ review @ 793 thumbs. Marketed as permanent, actually 30 days. Bait-and-switch reputation.
Ad SDK crashes → lose level progress (no mid-level save).
Difficulty cliff @ ~15min → ad-pressure → pay-pressure perception inversion.
Spawn-camping piercing enemies at mid-game.
Unskippable tutorials for every new mechanic (220t/2★).
Customer support broken (boilerplate dev replies).
Offline mode removed in recent patch (1.4.6) → 1★ wave.
Late-game content cliff at L191.
Key design DNA to lift for WeaponCraft
Lift this	Why
Grid-as-build-space	Already designed. Forge replaces merge.
Power Core anchor	Forge gets a central "Anvil Core" or similar.
Connector/function archetypes	F3 layer in our forge mechanic.
3-card gear shop + reroll	Current GDD already has TFT shop variant.
Castle HP + troop cap progression	Adapt as "Hero Slot HP + party-size cap."
Partial reward on loss	Anti-rage-quit. Current GDD has boss-retry; extend pattern to wave loss.
Daily 5-chest bar	Wittle pattern overlap. Confirm.
Patrol/AFK parallel income	Current GDD has AFK idle layer (12hr cap). Same.
Avoid these failure modes
Avoid	How
VIP "permanent" deception	Clear perma vs 30d labeling at IAP. Take RICOCHET §10.4 "lifetime means lifetime" stance.
Gacha 99% materials / 0.02% per troop	Transparent rates per RICOCHET §10.3 (0.6%/4.4%/95% pattern).
Mid-level save loss on ad crash	Per-wave save state in WeaponCraft.
Unskippable repeat tutorials	Skippable from session-2.
Offline mode removal post-launch	Lock offline-first as policy.
Difficulty cliff @ 15min	Wittle's 5-min match keeps run length short — sidesteps the cliff structurally.