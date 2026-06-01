# BASE-A1 Playtest Handout — for testers

Thanks for playing! This takes ~30 min. We're testing a mobile-portrait RPG slice. Your honest reactions matter more than getting it "right."

---

## How to play

1. **Open the file** `BASE-A1_0.1.2.html` in Chrome (or any modern browser). Resize the window narrow if it doesn't look mobile-shaped.
2. **Open the browser console** *before* you start — press `F12` (Windows) or `Cmd+Opt+I` (Mac), click the "Console" tab. We'll save this log later.
3. **Start OBS** (or any screen recorder) and capture the browser window. Hit record before clicking anything in the game.

---

## What you're doing in the game

- You command a fantasy squad: **Bran** (Warrior), **Elara** (Mage), **Vex** (Rogue).
- **Roster ramp:** only Bran starts unlocked at wave 1. Elara unlocks at wave 3. Vex unlocks at wave 5. Locked heroes show a 🔒 overlay.
- Each hero needs a **3-piece weapon**: Head + Hilt + Rune.
- **Forge flow:**
  1. **Shop** (5 random parts). Click a part → popup shows stats → **Buy** sends it to your **inventory** (not equipped yet).
  2. **Inventory strip** (below shop) holds your owned parts. Click a part → popup shows stats → **Equip → [hero]** buttons. Class-locked parts only show their matching hero; Universal parts show all unlocked heroes.
  3. **Anvil** (3-slot panel above shop) shows the active hero's current weapon. Click a filled slot → popup → **Unequip → Inventory**. No parts ever get destroyed.
  4. **Discard** from inventory refunds ⅓ cost if you want to clear space.
- **Reroll** (2🪙) refreshes the shop.
- Tap a hero card to make them "active" in the anvil view.
- Hit **Start Wave** when at least one unlocked hero has a full 3-piece weapon. Combat is auto.
- During combat, the **purple bar** on each hero fills up. Tap it when it's gold (`⚡ TAP`) to fire that hero's **ultimate** — once per fight.
- 5 normal waves then 1 **boss** with a telegraphed weakness (e.g., "Weak to FIRE"). Build a weapon that exploits it.
- If you wipe **at the boss**, you can **Reforge & Retry** — your parts stay equipped + fresh shop opens.

---

## Goals

There's no win condition we're enforcing. Just play. Try to:
- Clear the stage (beat the boss at wave 6).
- Notice what you like, what confuses you, what bores you.

---

## Think-aloud — please narrate

While you play, **say out loud** whatever you're thinking, even when it sounds dumb:
- "Why did that part go there?"
- "I want a fire weapon for this boss but only ice runes are showing."
- "Wait, did the reroll do anything?"
- "I have no idea why my warrior is dying so fast."
- "I love this part / I hate this part."

If you go silent, we lose half the data. Please narrate.

---

## After playing — 6 questions (~5 min)

Please answer these out loud while still recording, or jot them in a note:

1. **Was the forge → fight loop fun?** Would you play another stage?
2. **Did you ever change your weapons because of the boss's weakness?** What did you build?
3. **Did the 3 slots (Head + Hilt + Rune) feel like meaningful choices, or just filler slots?**
4. **Did you use the ultimate? When? Did it feel satisfying or pointless?**
5. **When you wiped at the boss (if you did), did "Reforge & Retry" feel fair, or punishing?**
6. **Anything that felt confusing, frustrating, or boring? Anything you wanted that wasn't there?**

---

## After playing — save the data

1. **Save the console log:**
   - Right-click anywhere in the Console tab → "Save as…" → save as `tester-<yourname>_a1.log` (or similar).
   - On Firefox: there's a small `⋯` menu → "Export Visible Messages To" → "File".
2. **Stop the screen recorder.** Save the file as `tester-<yourname>_a1.mp4`.
3. **Send both files** plus any post-game notes to whoever sent you this handout.

---

## What we're hoping to learn

You're not being graded. We're testing 8 design pillars in our spec — your behavior + reactions tell us which ones are working. Specifically:

- Does the **3-slot weapon** depth feel rich or overwhelming?
- Does the **shop + reroll** rhythm feel right?
- Does **auto-routing** confuse you (where did that part go?) or help?
- Does the **ultimate-tap** add agency or feel ignorable?
- Does the **boss telegraph + retry** create a fun "rebuild for this fight" moment?

Thanks for the time — you'll see this game (hopefully better) again soon.
