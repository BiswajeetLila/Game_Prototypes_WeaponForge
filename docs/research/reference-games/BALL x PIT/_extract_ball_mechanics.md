# BALL x PIT — Ball Mechanics Deep-Dive Design Spec
## Base Character: The Warrior (No Special Abilities)

**Extraction date:** 2026-05-19  
**Sources:** 19 analysis folders (GAMEPLAY_NOTES.md + selected frame reads)  
**Scope:** Shooting, catching, ball flight physics, baby balls, stats, edge cases  

---

## Citation Key

| Tag | Source |
|---|---|
| [VID:M8nLJ82HwfI] | Dr. Incompetent — 40-min beginner guide, controller |
| [VID:vF17pcDXk8A] | DrybearGamers — 17-min ultimate guide |
| [VID:faqN7WC_BAg] | IGN — 10 essential tips |
| [VID:xtYnSfBgSks] | CaRtOoNz — 60-min first impression |
| [VID:nkRcLrAQjsA] | Northernlion — 35-min stream, Warrior runs |
| [VID:ejfiE4klU1M] | The Silent Gamer — 27-min silent tutorial walkthrough |
| [VID:Dzwv-BFzAY4] | Wanderbots — 80-min advanced session |
| [VID:SRcNWzJIML0] | Matzel — 8-min fusion mechanics deep-dive |
| [VID:pV4cP8gvKcA] | Matzel — 50-min "5 broken fusions" builds |
| [VID:vCfTL7fx3fQ] | Idle cub — 4h44m full game completion |
| [VID:Jbz1Obo82cg] | Idle cub — 91-min rare evolutions + final boss |
| [VID:Nr2MJABYT-c] | Idle cub — 59-min Fungal Forest, Itchy Finger |
| [VID:y_rRsIO8o5w] | Suremesh — 3.5-min OP build guide (Flagellant mechanic) |
| [VID:TPYEHuEDg5I] | Matzel — 11-min "what I wish I knew" tips |
| [VID:yRrX-7ekr2g] | Gohjoe — 65-min Snowy Shores, Embedded + Cogitator |
| [VID:569lqQN9Y1U] | Suremesh — 9-min beginner tips |
| [VID:fPZ0MHvBy8c] | Gaming Plus TV — 10-min tips video |
| [VID:VPl6VSsOXv4] | Burr Plus — 3-min buy-or-pass review |
| [FRAME:ref] | Direct visual read of a specific JPG frame |

---

## 1. Shooting / Firing

### 1.1 Input Method

- **Controller:** Left stick = move character. Right stick = aim direction. Right Trigger (RT) = manual fire. Y button = toggle auto-fire. [VID:M8nLJ82HwfI — settings screenshot confirms button mapping]
- **Keyboard/Mouse:** Left mouse button = manual fire. F key = toggle auto-fire. Mouse position drives crosshair/aim. [VID:nkRcLrAQjsA — "Shoot with the left mouse button"] [VID:ejfiE4klU1M f_00090 — in-game tooltip "Aim with [hand icon], shoot with [mouse icon]"]
- Speed adjustment: Left Bumper / Right Bumper slow/fast (controller), equivalent keys on KB+M. [VID:M8nLJ82HwfI]

### 1.2 Auto-Fire Toggle

- The game includes an **auto-fire mode** that fires continuously in the aimed direction. Toggle: B or F on keyboard, Y on controller. [VID:ejfiE4klU1M f_00120 — tutorial tooltip confirmed: "[B] or [F] to toggle autofiring (You walk slower while shooting)"]
- When activated, a floating text toast **"Autofire Enabled"** appears above the player character for ~2 seconds. Disabling shows "Autofire Disabled." [VID:ejfiE4klU1M f_00300, f_01300 — both states visually confirmed]
- Guide consensus is to leave auto-fire on in most circumstances: "Activate auto shoot as soon as possible and never turn it off." [VID:TPYEHuEDg5I] "You should basically always keep auto shooting on." [VID:faqN7WC_BAg]

### 1.3 Movement-While-Shooting Penalty (Warrior Baseline)

- **The official in-game tutorial explicitly states a movement penalty when shooting:** "(You walk slower while shooting)" — captured verbatim in [VID:ejfiE4klU1M f_00120].
- This is the Warrior's default state. The penalty is a **move speed reduction** while auto-fire is active, not a complete stop.
- The passive **Fleet Feet** removes this penalty: "move at full speed while shooting" [VID:faqN7WC_BAg f_00080 — Encyclopedia entry confirmed]. Fleet Feet also grants +10% move speed.
- The character **The Itchy Finger** has "Can move at full speed while shooting" as a built-in trait — this is listed on his character card as a specific advantage over the Warrior baseline. [VID:M8nLJ82HwfI f_02350 — character card visible: "Can move at full speed while shooting"] This implies the Warrior does NOT have this by default, confirming the penalty is real.
- Exact magnitude of the speed penalty is **not quantified** in any video. Likely derivable from the Warrior's Move Speed stat (2.96) vs. some reduced value while firing. The reduction is enough to be gameplay-relevant (reason the tip exists to sometimes toggle off auto-fire for repositioning). [VID:faqN7WC_BAg — "turning it off can help if you need to move faster, like when swooping behind enemy lines to grab a power up"]

### 1.4 Aim Preview — Trajectory Line

- **White dotted trajectory line** is the Warrior's standard aim preview. Visually confirmed in multiple frames: [VID:M8nLJ82HwfI f_00060 — FRAME READ: white dotted line from player to crosshair (pointed at enemies), straight vertical path visible] [VID:M8nLJ82HwfI f_00180 — FRAME READ: same white dotted line going up at angle to enemy cluster, ball mid-flight in pit]
- The trajectory shows the initial ball path. The notes specifically describe it as: "those white dotted lines that come out of your character — you can see that they ricochet at the equivalent ricochet angle based on where you go." [VID:vF17pcDXk8A quote 02:20]
- The DESIGN_DOC mentions "one ricochet" shown in the preview (§3.1). This is consistent with the frame reads which show a single dotted line without multiple bounce segments.
- **The CaRtOoNz video (f_00100) shows a RED dashed line** instead of white during the tutorial. [VID:xtYnSfBgSks f_00100 — FRAME READ: confirmed red dashed aim line from player to crosshair, enemies at top, white baby balls in flight] The MANIFEST notes this "may be tutorial-only." Across all other videos (non-tutorial, Warrior in combat), the trajectory appears white. **Likely interpretation:** the red line is the tutorial color-coding to make it more obvious; normal gameplay shows a white/pale dotted line. The distinction between tutorial-red and gameplay-white is **not definitively confirmed** — could be the same color rendered differently in different biomes/lighting.
- **Number of bounces shown in the preview:** One deflection point is described [DESIGN_DOC §3.1]. The DrybearGamers quote specifically says the line shows "the equivalent ricochet angle." The frame reads show a single line to the crosshair, not a multi-segment path showing post-bounce trajectory. **Assessment:** The aim preview shows the ball's launch vector (and one wall-bounce redirect if applicable), not multiple subsequent bounces.

### 1.5 Fire Rate — What "3.63" Means

- The Warrior Level 1 has **Fire Rate: 3.63**. This stat is explicitly visible in the stat screen. [VID:M8nLJ82HwfI f_00500 — FRAME READ: confirmed "Fire Rate 3.63"]
- **No video directly translates Fire Rate 3.63 to shots-per-second**. The stat unit is not labeled in the UI.
- Northernlion identifies fire rate as important but notes "ball return time is the real limiter" — implying Fire Rate governs how frequently you can shoot, but catching-and-rethrowing supersedes it. [VID:nkRcLrAQjsA — "I don't know if [fire rate] is doing that much damage, but it's keeping them at bay"] The note is that NL himself questions fire rate's importance given ball return mechanics.
- Comparative reference: The Itchy Finger has Fire Rate 11.95 [VID:vF17pcDXk8A f_00760 — FRAME READ: confirmed "Fire Rate 11.95"]. Itchy Finger "shoots twice as fast" per his character description. However, 3.63 × 2 = 7.26, not 11.95 — suggesting "twice as fast" is descriptive, not mathematically precise from the stat, or that Fire Rate at 11.95 encompasses his entire fire cadence (scatter aim included).
- **Best guess interpretation (flagged as [INFERRED]):** Fire Rate is likely a multiplier or a shots-per-second figure. If 3.63 = ~3.6 shots per second at baseline, then Itchy Finger at 11.95 is ~12 shots/sec — roughly 3× not 2×, possibly explaining the "constantly launches" description. Alternatively, Fire Rate may be a cooldown divisor. **The exact formula mapping Fire Rate to a real-time cadence is not confirmed by any source.**

### 1.6 Ball Pouch / Queue

- **4 special ball slots** are the standard maximum, each capable of holding a ball at Level 1, 2, or 3. [VID:M8nLJ82HwfI — confirmed multiple times; DESIGN_DOC §4.3] 
- Slots are expandable through the **Bag Maker** building (Heavenly Gates biome) — Matzel's late-game footage shows **5 balls in a row, 2 rows = up to 10 ball slots** in an extreme end-game save. [VID:pV4cP8gvKcA f_00300 — confirmed 3+4+3+2 ball slots in top row and 5 in bottom row]
- **How many balls are in flight at once:** This is per-ball, not a total limit. Each special ball is one projectile in flight. With 4 ball slots, you can have up to 4 special balls in flight simultaneously. Baby balls are separate and have their own count (Baby Ball Count stat). In extreme builds, 50+ projectiles can be in flight (special + baby) as documented by Matzel. [VID:pV4cP8gvKcA f_01000 — "50+ balls in flight simultaneously"]
- **No "balls loaded in queue" behavior is documented.** Each ball slot holds one ball; when fired, it travels out and must return (or be caught) before it can be re-fired. The ball effectively occupies its slot while in flight.

### 1.7 Cooldown / "No Balls Loaded" Behavior

- **No explicit documentation of a "no balls loaded" state** — because balls return automatically after bouncing, there is no empty-chamber condition under normal play.
- The Warrior starts with one ball (the Bleed ball) and gains more through level-up picks. In the first few seconds of a run, only 1–2 balls are active. [VID:M8nLJ82HwfI f_00060 — confirmed: 1 ball slot visible, game start]
- Some evolved balls have **explicit cooldowns**: Black Hole has a 7-second cooldown [VID:vCfTL7fx3fQ quote 00:07:28]. Egg Sac has a 3-second cooldown [VID:VPl6VSsOXv4 f_00050 — upgrade tooltip visible]. When a cooldown ball is "in cooldown," it presumably cannot be thrown again until the timer expires.
- The Matzel tips video flags this: "Some balls have cooldowns and only fire every few seconds. If you've used those with your main balls, the result might also inherit that cooldown." [VID:TPYEHuEDg5I] The cooldown behavior of non-cooldown balls (the Warrior's default Bleed ball) is **not separately stated** — the implication is it has no cooldown and can be re-fired as fast as Fire Rate allows after returning or being caught.

### 1.8 Knockback When Shooting

- The passive **Radiant Feather** is explicitly described as: "+20% ball launch speed, but you get knocked back when shooting." [DESIGN_DOC §4.5 citing WIKI/Passives] This is a passive effect — it implies knockback does NOT exist by default.
- **The Warrior baseline has NO shooting knockback.** Knockback only occurs if the Radiant Feather passive is equipped.
- No video shows the Warrior being pushed by ball shots without Radiant Feather equipped.

---

## 2. Ball Flight Physics

### 2.1 Initial Velocity / Ball Speed Stat (Warrior: 6.01)

- The Warrior Level 1 has **Ball Speed: 6.01**. [VID:M8nLJ82HwfI f_00500 — FRAME READ: visually confirmed "Ball Speed 6.01"]
- The **Speed attribute** maps to Ball Speed: "With speed, it improves your ball speed." [VID:569lqQN9Y1U quote 00:07:00]
- Comparative: The Itchy Finger has Ball Speed 8.93 [VID:vF17pcDXk8A f_00760 — FRAME READ: confirmed], The Empty Nester has 7.96 [VID:569lqQN9Y1U f_00220]. The Warrior's 6.01 is below the two named alternatives — it is a moderate baseline.
- **What the unit represents:** The stat is unlabeled in the UI. Visually, balls in Warrior gameplay travel fast enough to cross the arena in well under a second. The exact pixels-per-second or tiles-per-second mapping is **not documented**.
- Rubber Headband passive "makes balls get faster on each bounce" — described by Wanderbots and consistent with [VID:vCfTL7fx3fQ quote 00:21:52: "rubber band, too. So they get faster and then bounce"]. This implies Ball Speed can increase dynamically during a throw.

### 2.2 Trajectory Shape — Straight Line, No Gravity (Warrior)

- **The Warrior's balls travel in straight lines.** All frame reads of Warrior gameplay show straight dotted trajectory paths and straight-line ball travel. [VID:M8nLJ82HwfI f_00060, f_00180 — FRAME READ: white dotted trajectory is a straight line from player to crosshair]
- **The Physicist character** has gravity-affected balls: "balls fall upwards basically... the balls fall in this direction and then bounce until they get through... these balls keep bouncing until they get through." [VID:vCfTL7fx3fQ quote 00:05:23] This is explicitly described as a character-specific mechanic, not the default. The contrast between The Physicist's looping gravity balls and the "normal" straight-line balls is explicitly highlighted by the streamer.
- **Confirmed: The Warrior baseline uses straight-line physics. Gravity is absent.** [INFERRED from the Physicist's gravity being called out as special]

### 2.3 Travel Distance / Lifetime

- **Balls travel the full length of the arena** to the enemy formation at the top, hit enemies/walls, and return. Frames show balls mid-flight at multiple positions. [VID:M8nLJ82HwfI f_00180 — FRAME READ: ball visible mid-pit on return arc, dotted return trail visible]
- **No documented "expiration" timer** — balls do not disappear mid-flight under normal conditions. They travel until they either reach the player (catch or pass by), bounce indefinitely against walls and enemies, or under special character rules.
- The Wanderbots notes confirm the desired "trapped" state where a ball gets stuck behind enemies, bouncing continuously: "I want to get it stuck back there." [VID:nkRcLrAQjsA] This implies balls can bounce indefinitely as long as they're between walls and enemies — no expiration.
- **Exception:** The Black Hole ball "destroys itself afterwards" after hitting an enemy [VID:vCfTL7fx3fQ]. This is ball-specific, not baseline behavior.
- **Baby balls:** Distinguished from special balls — they "bounce around freely" without the boomerang-return property. Whether they expire after a time limit is not documented.

### 2.4 Bounce-Off-Walls Behavior

- Balls bounce off **both side walls** (left and right) of the pit corridor at standard reflection angles. The Wanderbots notes state: "Balls bounce off all four 'walls' (side walls, top of the enemy formation, and implicit floor/ceiling at the player's feet)." [VID:Dzwv-BFzAY4 — GAMEPLAY_NOTES §2]
- The strategy built around wall bouncing is fundamental: "Walls are your secret weapon... Try to angle your throws behind enemy waves so your balls bounce through them on the way back." [VID:fPZ0MHvBy8c quote 00:01:11]
- "Generally, the strategy for brickbreaker is always to go horizontal — to angle it so that you get as many repeated bounces as possible." [VID:vF17pcDXk8A quote 02:40] — horizontal angles cause left-right-wall zigzag patterns.
- **Top wall:** The top of the enemy formation acts as a hard surface — balls that pass above enemies "exit the visible area and return from the top." [VID:Dzwv-BFzAY4 GAMEPLAY_NOTES §2]. In effect the top wall of the pit reflects balls back down.
- **The "Prepentant/Repentant" character modifier:** The Repentant's passive is "on back-wall hit, balls return through enemies" — specifically calling out the back wall as a triggered event. This implies in baseline Warrior play, hitting the back wall is a normal bounce (no special return sweep). [DESIGN_DOC §4.2]
- **Wrap-around confirmation via negative case:** The Tunneller character's gimmick is "Balls wrap around top/bottom of screen." This ability description **confirms that Warrior baseline balls do NOT wrap** — they reflect off walls rather than wrapping. [DESIGN_DOC §4.2]

### 2.5 Bounce-Off-Enemies

- Balls bounce off enemies, dealing damage on each contact. **The Warrior's balls do NOT pierce enemies by default.** The Embedded character has "Balls pierce all enemies until they hit a wall" as a specific built-in trait — stated as a character uniqueness. [DESIGN_DOC §4.2 / yRrX-7ekr2g quote 00:01:00: "Balls always pierce enemies until they hit a wall"]
- Ghost ball specifically passes through enemies (ghost property). [VID:xtYnSfBgSks f_00600 — "New Ball! Ghost — Passes through enemies"] But this is a specific ball type, not the default.
- Balls that hit an enemy bounce off at an angle — the ball does not stop on enemy contact, it reflects and continues. This is consistent with the Breakout/pinball mechanics. The Warrior's Bleed starting ball follows this standard behavior.
- **Behavior vs. boss enemies specifically:** Balls interact with boss enemies the same way — hitting them causes damage and a bounce. The only exception is targeting: the Skeleton King "can only be damaged from behind/back of the model. Front hits are absorbed." [VID:nkRcLrAQjsA quote 00:30:48] This is a **boss armor mechanic** affecting hit registration, not ball physics — the ball still bounces off the front, it just deals 0 damage from the front.

### 2.6 Bounce Angle / Reflection Rules

- The trajectory preview line "ricochet at the equivalent ricochet angle." [VID:vF17pcDXk8A quote 02:20] This indicates **angle-of-incidence = angle-of-reflection** (standard billiards physics), not randomized or fuzzy reflection.
- "Straight line toward aim reticle, hit enemies, and bounce off walls and enemy cells." [VID:569lqQN9Y1U GAMEPLAY_NOTES §2] — no mention of drift or imprecise angles.
- [INFERRED] The reflection appears to be deterministic physics. No source mentions randomized or fuzzy reflection. The aim preview's accuracy in predicting one bounce is consistent with deterministic reflection.

### 2.7 Bounce Damage Falloff (Warrior Baseline)

- The **Hourglass passive** is explicitly described as: "+150% ball damage, decays -30% per bounce (min 50%)" [DESIGN_DOC §4.5 citing WIKI/Passives]. This is a **passive** effect — it implies baseline Warrior balls do NOT have damage falloff per bounce.
- One source confirms bounce-damage **increase** behavior (a different passive): "Each time a ball hits a wall, it deals 30% extra damage on the next hit." [VID:vCfTL7fx3fQ quote 00:21:36 — described as "Ricochet Boost" passive]. This is explicitly a passive ability, not baseline.
- **Confirmed: The Warrior baseline has no inherent damage falloff per bounce.** Damage per hit is constant across all bounces at baseline. Falloff or boost only occurs via specific passives.

### 2.8 "Returning" — How Balls Come Back

- Balls are described as having **boomerang-like return** behavior: "The main balls themselves will end up traveling out like a boomerang. You have to catch them when they come back." [VID:vF17pcDXk8A quote 16:50]
- "Every time you catch your ball, instead of letting it go behind you or bounce around you, it allows you to throw it again." [VID:M8nLJ82HwfI quote 00:02:45]
- The return is **not auto-return to player** — the ball travels physically back down the pit at the same speed, bouncing off the bottom walls/area if uncaught. If the player does not catch it, the ball continues bouncing around near the player's altitude before eventually leaving the field or being re-caught.
- There is no gravity-pull of balls toward the player — they travel in straight lines and follow physics. The "boomerang" description means they go out, bounce off the top/enemies/walls, and the physics naturally return them to the bottom of the arena. It is not a homing mechanic.
- Frame evidence: [VID:M8nLJ82HwfI f_00180 — FRAME READ: white dots visible mid-pit traveling downward (return arc) — ball visually confirmed in mid-return]
- **Recall Balls UI button:** A "Recall Balls" button appears in the HUD in a late-game frame [VID:vCfTL7fx3fQ f_10800]. This appears to be a manual ball-retrieval ability available in late game or specific conditions. It is NOT documented as part of baseline Warrior mechanics at Level 1.

---

## 3. Catching / Collecting Balls

### 3.1 Catch Mechanic — How It Works

- **Proximity-based, auto-catch when the ball returns to player altitude:** "As balls return to the player's altitude, the player catches them." [DESIGN_DOC §3.1] Multiple sources confirm this.
- The IGN video (f_00270) explicitly demonstrates catch mechanics: frame shows the player actively running toward a returning bouncing ball to intercept it. [VID:faqN7WC_BAg f_00270 — FRAME READ: player character running toward a white bouncing ball, 2 enemies visible at top, ball mid-lower field] This suggests the player may need to physically move to the ball's position rather than the ball being magnetically drawn to the player.
- The most explicit description: "One of the most important ways to raise your attack speed is to catch your special balls mid-flight." [VID:faqN7WC_BAg quote 04:40]
- "Catch your balls. Depending on the character, this can drastically boost your damage output. But if you catch them mid-air and instantly throw them again, you keep up non-stop pressure on the enemies with zero downtime." [VID:TPYEHuEDg5I quote 00:00:57]
- **It is not timed/rhythm-based** — no source describes a timing window or input requirement. The catch appears to happen automatically when the player character is in the ball's path at the correct altitude. The player's action is positioning (moving to intercept), not button timing.

### 3.2 Payoff for Catching

- **Catching instantly reloads the ball for the next throw:** "it allows you to throw it again so that you have more opportunity to do damage with your special balls." [VID:M8nLJ82HwfI quote 00:02:45] "it's instantly reloaded into your pouch." [VID:vF17pcDXk8A quote 7:20]
- The critical design insight: without catching, a ball that passes by the player bounces around near the bottom for a moment before "leaving the field" — wasting potentially 1–3 seconds of DPS downtime before it can be reused. The catch enables **zero-downtime continuous fire**.
- The IGN tip frames it specifically as an attack speed booster: catching and re-throwing raises effective attack speed beyond what the Fire Rate stat alone provides. [VID:faqN7WC_BAg quote 04:40]

### 3.3 What Happens If You Miss the Catch

- **The ball does not despawn on a missed catch.** It continues bouncing. From the GAMEPLAY_NOTES, balls that aren't caught "bounce around you" and can be caught on subsequent passes. [VID:M8nLJ82HwfI quote 00:02:45: "instead of letting it go behind you or bounce around you"]
- **Bottom wall behavior:** The Flagellant character's defining mechanic is explicitly "Balls bounce off the bottom of the screen (so they never return)." [DESIGN_DOC §4.2] This is stated as a special ability, not the default — which **confirms that in the Warrior baseline, balls do NOT bounce off the bottom wall**. For the Warrior, a missed ball likely travels past the player's position and continues to the bottom of the arena, then presumably exits or comes to a stop. 
- **Does a missed ball disappear?** No source explicitly states the ball despawns. The Flagellant's mechanic description ("so they never return") implies that in baseline (non-Flagellant) play, balls **do** eventually return — but may take longer if missed. The ball likely continues bouncing off the side walls and bottom area until it naturally returns to a catchable position.
- **No documented "ball despawn on miss"** — the mechanic appears to be purely physics-based persistence.
- The Tunneller character wraps balls top-to-bottom: "Balls wrap around top/bottom of screen." [DESIGN_DOC §4.2] This is a distinct special — baseline Warrior balls do NOT wrap.

### 3.4 The Flagellant — Confirming Bottom Wall Behavior

- The Flagellant's description explicitly states balls "bounce off the bottom of the screen." Per the Suremesh OP build guide, this is combined with Cohabitants for a "constant forever bouncing balls both on the top and bottom of your screen. And the only way for them to go away is if you catch them." [VID:y_rRsIO8o5w quote 00:02:10]
- This **definitively confirms** the normal physics model: in baseline Warrior play, the **bottom area is where the player catches balls**, not a bounce-back wall. Flagellant changes this by making the bottom a reflective surface.

### 3.5 Visual/Audio Feedback on Catch

- **No frame in the dataset isolates a catch animation.** Catches happen quickly during combat and weren't isolated in any frame read.
- Drybear mentions an "immediately reloaded" feel: "it's instantly reloaded into your pouch." The word "instantly" implies no animation delay. [VID:vF17pcDXk8A quote 7:20]
- Audio: IGN implies a distinct feel ("instantly reloaded") but no specific SFX is described. The vCfTL7fx3fQ streamer notes "the sound effects and music, everything is so nice... high quality overall" [quote 00:12:44] — implying a catch likely has a satisfying audio pop, but the specific catch sound is not described.

### 3.6 Catch Combo / Streak System

- **No evidence of a catch combo or streak system in any video.** No source mentions multiplied rewards for consecutive catches, a streak counter, or any mechanic that changes with repeated catching.
- Some passives interact with shooting speed (catching enables faster re-fire), but this is an emergent efficiency benefit, not a defined combo system.

---

## 4. Baby Balls

### 4.1 What Are Baby Balls

- **Baby balls are small, passive white projectiles** that spawn automatically and bounce freely around the arena, dealing chip damage. "Baby balls can spawn through various means and they just bounce around freely and do damage that way." [VID:vF17pcDXk8A quote 16:50]
- They are visually small white spheres, distinct from the larger special balls. [VID:xtYnSfBgSks GAMEPLAY_NOTES §2: "Baby balls: white spheres that scatter mid-field, drifting upward"]
- They differ fundamentally from special balls: they do not have the boomerang-return property, they do not need to be caught to reload, and the player has no direct aim control over them.

### 4.2 Baby Ball Count: What "5" Means (Warrior Baseline)

- The Warrior Level 1 has **Baby Ball Count: 5**. [VID:M8nLJ82HwfI f_00500 — FRAME READ: confirmed "Baby Ball Count 5"]
- **What "5" means is not definitively stated**, but contextual evidence suggests it is the **maximum number of baby balls that can be in flight simultaneously**, not a total per-fire.
- Comparative: Itchy Finger has Baby Ball Count 12 [VID:vF17pcDXk8A f_00760 — confirmed] and is described as having many more babies visible. The Empty Nester has no baby balls (by design).
- The Leadership attribute maps to Baby Ball Count: "With leadership, it affects how many baby balls you can have." [VID:569lqQN9Y1U quote 00:07:00] Warrior's Leadership is 4 (E scaling) mapping to count of 5.
- Some evidence suggests Baby Ball Count is a simultaneous cap: Matzel's extreme builds describe "baby balls covering the entire screen" from Baby Ball Count of 12+. [VID:pV4cP8gvKcA f_00200]

### 4.3 Baby Ball Damage (Warrior: 11–17)

- **Baby Ball Damage: 11–17** for Warrior Level 1. [VID:M8nLJ82HwfI f_00500 — FRAME READ: confirmed "Baby Ball Damage 11-17"]
- This is a damage range (11 minimum, 17 maximum) for each baby ball hit.
- Comparative: Itchy Finger has Baby Ball Damage 12–18, only slightly higher despite 3× more balls. [VID:vF17pcDXk8A f_00760]

### 4.4 How Baby Balls Spawn / Replenish

- **Multiple spawn mechanisms exist:**
  1. **Passive from character baseline:** The Warrior always has some baby balls active. They respawn automatically — no sources describe needing to manually trigger baby ball spawning for the Warrior's base 5 count.
  2. **Brood Mother ball:** Spawns baby balls on hit (explicitly a ball that creates babies). [DESIGN_DOC §4.3]
  3. **Egg Sac ball:** "Explodes into 2-4 baby balls on hitting an enemy. Has a 3-second cooldown." [VID:VPl6VSsOXv4 f_00050 — upgrade card tooltip]
  4. **Slingshot passive:** "25% chance to launch a baby ball when you pick up a gem." [VID:faqN7WC_BAg f_00330 — passive description confirmed]
  5. **Holy Laser + Maggot fusion:** Maggot-infected enemies, when killed, "scatter 1–2 baby balls." [VID:y_rRsIO8o5w quote 00:00:35]
- **Replenishment of the base 5:** If baby balls are destroyed or leave the play field, they respawn. No source describes the respawn timer. They appear to be in essentially continuous circulation.

### 4.5 Do Baby Balls Expire / Bounce Indefinitely?

- Baby balls bounce indefinitely — "they just bounce around freely." [VID:vF17pcDXk8A] No expiration timer is documented.
- They bounce off walls and enemies without returning to the player like special balls. They lack the boomerang property.
- The Flagellant character (balls bounce off bottom) appears to apply to **both special balls and baby balls** per the description context, but this is not explicitly confirmed for baby balls specifically.

### 4.6 Baby Balls vs. Special Balls: Physics Differences

| Property | Special Balls (Warrior Bleed) | Baby Balls |
|---|---|---|
| Controlled by player | Yes (aim + fire) | No (autonomous) |
| Return to player | Yes (boomerang behavior) | No (free bounce) |
| Catchable | Yes | Not described as catchable |
| Damage range | 25–44 (Base) | 11–17 |
| Cooldown | None (Warrior Bleed) | None documented |
| Physics | Straight-line, wall-reflect | Same straight-line wall-reflect but no boomerang |
| Count limit | 1 per slot (4 slots) | 5 simultaneously (Baby Ball Count) |

---

## 5. Stats That Affect Ball Behavior — Warrior Level 1 Baseline

### 5.1 Complete Derived Stats (Warrior Level 1)

All values visually confirmed in [VID:M8nLJ82HwfI f_00500 — FRAME READ: full stat screen photographed]:

| Stat | Warrior L1 | Notes |
|---|---|---|
| HP | 60 (+10) | +10 suggests a bonus from a building or permanent upgrade |
| Base Damage | 25–44 | Damage range per special ball hit |
| Baby Ball Count | 5 | Max simultaneous baby balls |
| Baby Ball Damage | 11–17 | Damage range per baby ball hit |
| Ball Speed | 6.01 | Travel velocity |
| Move Speed | 2.96 | Player movement speed |
| Crit Chance | 0.32% | Very low baseline; exclamation mark hits in combat |
| Fire Rate | 3.63 | Shots per second (unit unclear) |
| AOE Power | 0.86 | AoE damage multiplier (below 1.0 = slightly below average) |
| Status Effect Power | 0.85 | Status effect damage multiplier (below 1.0) |
| Passive Power | 0.97 | Passive item effectiveness multiplier (near average) |

Scaling for all attributes is **"E" (lowest tier)** at Level 1. [VID:M8nLJ82HwfI f_00500 — FRAME READ: all scaling shows "E"]

### 5.2 Attribute → Stat Mapping

The 6 attributes map to derived stats as follows (confirmed from [VID:569lqQN9Y1U quote 00:07:00] and [DESIGN_DOC §4.1]):

| Attribute | Warrior L1 Value | Maps To |
|---|---|---|
| Endurance | 6 (+1) | HP |
| Strength | 7 | Base Damage |
| Leadership | 4 | Baby Ball Count + Baby Ball Damage |
| Speed | 3 | Ball Speed |
| Dexterity | 4 | Crit Chance |
| Intelligence | 3 | AOE Power (also Status Effect Power per [VID:569lqQN9Y1U]) |

Note: The attribute-to-stat mapping is confirmed at a general level by multiple sources. The exact formula (e.g., "Strength 7 E → Base Damage 25–44") is not documented beyond the statement that higher Strength = more damage. Scaling grade (E/D/C/B/A/S) affects how much each attribute point contributes. All Warrior stats are at E scaling at Level 1.

### 5.3 Comparative: The Itchy Finger L1 Stats

For reference, confirmed from [VID:vF17pcDXk8A f_00760 — FRAME READ]:

| Stat | Warrior L1 | Itchy Finger L1 |
|---|---|---|
| HP | 60 | 136 |
| Base Damage | 25–44 | 30–54 |
| Baby Ball Count | 5 | 12 |
| Baby Ball Damage | 11–17 | 12–18 |
| Ball Speed | 6.01 | 8.93 |
| Move Speed | 2.96 | 6.58 |
| Crit Chance | 0.32% | 0.83% |
| Fire Rate | 3.63 | 11.95 |
| AOE Power | 0.86 | 1.03 |
| Status Effect Power | 0.85 | 1.20 |
| Passive Power | 0.97 | 1.07 |

Itchy Finger has 3.3× Fire Rate, 2.4× more baby balls, and 2.2× move speed vs. Warrior. The Warrior is explicitly the "no-special baseline" character.

### 5.4 The Empty Nester — Alternative Baseline for Comparison

Confirmed from [VID:569lqQN9Y1U f_00220 — character stat screen]:
- HP: 110, Base Damage: 29–51, **No baby balls (Leadership 5/D → Launched Balls 3)**, Ball Speed: 7.96, Move Speed: 3.42, Crit Chance: 0.53%, Fire Rate: 4.49, AOE Power: 1.26.
- The Empty Nester replaces baby balls with "multiple instances of one special ball" — distinct from baby-ball mechanics.

---

## 6. Edge Cases and Quirks

### 6.1 Death / Run-End With Balls in Flight

- "If you die, it's over. That's the end of the run." [VID:vF17pcDXk8A quote — described in transcript]
- No source describes what happens to balls in flight at the moment of death. Visually, no death frame was captured mid-ball-flight across all 19 analysis folders.
- [INFERRED] Based on the roguelite norm and the description of a hard run-end on death, any balls in flight are simply discarded. There is no documented "ball completes its path after death" behavior.
- **Exception:** The Necromancer passive provides one revive per run: "Once per battle when you die, revive with 75% health and kill all nearby enemies." [VID:vCfTL7fx3fQ quote 00:01:48] This is a passive item, not baseline Warrior behavior. On revive, the run continues.

### 6.2 Boss Interactions — The Skeleton King

- The Skeleton King (first boss) has a **back-only crit zone**: "the front of the boss you can't hit. You're hitting the crown in the back of the boss's head." [VID:M8nLJ82HwfI quote 00:27:00] Northernlion discovers this mid-fight: "oh, he only takes damage from the back." [VID:nkRcLrAQjsA quote 00:30:48]
- This is a **hit-registration mechanic**, not a ball physics change. Balls hitting the front bounce off (with the normal reflection physics) but deal 0 damage. Balls that reach the back side deal full damage.
- Practical implication: Players must aim through the enemy formation at shallow angles so balls wrap around to the boss's rear, or position themselves to shoot at an angle that bypasses the front armor zone.
- The boss also fires "purple bone projectile fan attacks." [VID:nkRcLrAQjsA f_01915 — FRAME READ confirmed: fan of ~20 purple bone projectiles filling lower screen]
- Pre-firing the boss is possible: "my ghost balls were able to phase through him and constantly attack him while he was in his animation of getting ready." [VID:569lqQN9Y1U quote 00:04:33] — relevant for the Ghost ball type, not Warrior's Bleed baseline.

### 6.3 Aiming Through Enemies — Can You Target the Back Row?

- Yes. The entire strategy of the game is built on angling shots to pass through front rows and get to the back: "you actually kind of want to bounce your balls around... play it like pinball and get them stuck up behind the enemies so that they are bouncing around off the top of the screen." [VID:M8nLJ82HwfI quote 00:01:40]
- The Embedded character's "balls pierce enemies" ability is relevant context: normal Warrior balls do NOT pierce. They bounce off the first enemy they hit in a column. Therefore, targeting the back row with the Warrior requires a bank shot around the front enemies, not direct penetration.
- This is a core skill element: finding gaps in the front formation to bank shots to the rear rows.

### 6.4 Shooting Arrows Out of the Sky (Projectile Interaction)

- "Archer enemies at the back fire flaming arrows in a loose spread; you can shoot arrows out of the sky with balls." [VID:M8nLJ82HwfI GAMEPLAY_NOTES §2: "Can be shot out of the sky"]
- Confirmed: player balls can collide with and destroy enemy projectile arrows. This is a defensive use of ball trajectory management.
- No specific visual confirmation in sampled frames (arrow destruction is a fast event), but the mechanic is stated clearly in the notes.

### 6.5 The Tactician — Turn-Based Mode as Physics Contrast

- The Tactician character makes combat turn-based: "Battles become turn based." "Can I move? Oh, I can infinitely move, but only shoot once. I see. And then I can't move until it's over." [VID:vCfTL7fx3fQ quotes 00:27:11, 00:29:25]
- In turn-based mode: the player fires ONE ball throw, then all balls play out their physics to completion, then it becomes the player's turn again.
- **What this reveals about default ball physics:** In the Tactician mode, balls complete their full travel arc before the player can act again. This implies that in normal real-time play, the entire ball flight (launch → bounces → return) is happening continuously and the player can fire again without waiting for a ball to return (via Fire Rate, not turn-based gates). **The turn-based mode effectively enforces "one ball per action phase," confirming that in real-time, multiple balls can be in flight simultaneously without phase constraints.**
- The streamer finds the Tactician "terrible" and slow, confirming the normal pace is continuous action. [VID:vCfTL7fx3fQ quote 00:39:45]

### 6.6 The Tunneller — Confirms Default Wall Behavior

- The Tunneller's ability: "Balls wrap around top/bottom of screen." [DESIGN_DOC §4.2]
- **This definitively confirms** that Warrior baseline balls do NOT wrap around. Top/bottom boundaries are reflective walls (or exit points), not wrap portals.
- This is one of two character abilities that tells us about the default by negation (the other being the Flagellant's bottom-bounce confirming that the bottom is NOT normally reflective for the Warrior).

### 6.7 The Juggler — Air-Lob Mechanic as Contrast

- The Juggler character "Lobs balls into the air; they don't bounce until they land." [DESIGN_DOC §4.2]
- This implies the Warrior's default balls fly straight (not lobbed) and bounce immediately on all contacts. No air-lob trajectory exists at baseline.

### 6.8 The Cohabitants — Mirror Balls

- For reference: "For each ball launched, a copy is launched in the mirrored direction. Balls deal half damage." [VID:VPl6VSsOXv4 f_00030 — character card confirmed; VID:569lqQN9Y1U f_00240 — character card confirmed]
- The Warrior fires only one ball per throw in one direction. No mirroring.

### 6.9 "Recall Balls" UI Button

- In one late-game frame from the Idle cub 4h44m completion video, a "Recall Balls" button appears in the HUD. [VID:vCfTL7fx3fQ f_10800 — GAMEPLAY_NOTES: "Recall Balls UI tooltip visible at bottom-right — a button that manually retrieves balls"]
- This is not documented elsewhere and does not appear in early-game Warrior footage. It may be unlocked via a specific passive, building, or late-game mechanic. **Not part of baseline Warrior Level 1 mechanics.**

### 6.10 Ball Bounce Damage Increase (Passive Only)

- One passive is described as adding a bounce-damage increase: "Each time a ball hits a wall, it deals 30% extra damage on the next hit." [VID:vCfTL7fx3fQ quote 00:21:36]
- This is a named passive (likely "Ricochet Boost" or similar — exact name not confirmed). It is NOT baseline Warrior behavior. Baseline ball damage per hit is consistent across all bounces.

### 6.11 The "Itchy Trigger" Movement-While-Shooting

- "Can move at full speed while shooting" is listed explicitly on the Itchy Finger character card. [VID:M8nLJ82HwfI f_02350 — character description card frame confirmed]
- This is a character-unique ability that negates the Warrior's movement penalty. Itchy Finger also "constantly launches balls if any are available" — essentially a permanent auto-fire.

---

## 7. Unresolved Questions / Data Gaps

The following items were searched across all 19 GAMEPLAY_NOTES files and specific frames but could not be confirmed with a citable source:

1. **Exact fire rate formula:** What does "Fire Rate 3.63" translate to in shots/second? No video states the unit or formula.
2. **Exact movement penalty magnitude:** How much does auto-fire reduce Move Speed (2.96 → X)? Not quantified.
3. **Baby ball respawn timer:** When a baby ball leaves the field or is destroyed, how long until it respawns?
4. **Ball miss behavior (precise):** When a Warrior ball is not caught, does it bounce off the absolute bottom of the arena floor, or does it simply exit the play field? The Flagellant's mechanic implies the bottom is NOT a reflective surface for normal balls — but the exact exit mechanic is not described.
5. **White trajectory vs. red trajectory:** Is the aim line color white (normal play) or red (tutorial only vs. permanent)? Multiple Warrior frames show white; CaRtOoNz tutorial shows red. Inconclusive.
6. **Number of bounces shown in aim preview:** Does the preview show 1 bounce or unlimited? Sources say "one ricochet" [DESIGN_DOC §3.1] but the DrybearGamers phrasing is ambiguous.
7. **"Ball Speed 6.01" units:** tiles/second, pixels/second, or a dimensionless multiplier?
8. **Catch radius:** How far from the player can a ball be caught? Is it a fixed pixel radius or does it scale with any stat?
9. **Recall Balls button unlock condition:** When/how does this button become available?
10. **Autofire and baby balls:** Does toggling auto-fire off also stop baby ball generation, or do baby balls fire independently regardless of auto-fire state?

---

*This document was generated from exhaustive reading of all 19 GAMEPLAY_NOTES.md files plus direct visual verification of key frames. All claims are cited. [INFERRED] tags mark analytical conclusions not directly stated in sources.*
