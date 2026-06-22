# Stakes — incoming damage + win/lose (WFT-10)

> **Subordinate to** [`../../01_GDD.md`](../../01_GDD.md). **Date:** 2026-06-22 (latest of the 06-22 set) · **Branch:** `weaponforge-tftransistor/post-slice-phase5`.
> **Status:** Decision record + build. Paper-prototype only (`ftue-beat5.html`, "3-Hero Board"). Delivers issue **WFT-10**; makes the costs/budget from `2026-06-22-topology-locked-and-costs-budget.md` finally tunable.

## 1. What changed
Combat was a punching-bag: enemies had HP, heroes couldn't lose. Now there is a **race**.

- **Hero HP** — each hero has HP (Elara 90 · Bran 130 · Vex 100) shown as a bar + number under the name.
- **Enemies attack** on a fixed cadence, independent of the hero's firing: `atk` damage every `aspd` ticks (10 ticks = 1 s). Wisp ⚔6/1.4 s · Brute ⚔10/1.6 s · Shade ⚔7/1.2 s. Shown as a threat readout next to the foe name.
- **Win** = all three enemies dead. **Lose** = **any** hero downed (HP 0).
- A result banner resolves the fight: green "✓ Victory — all enemies cleared" or red "✗ Defeat — [hero] was downed".

## 2. Why "lose if ANY hero is downed"
Not "lose only if all three die." Any-downed makes the **shared forge budget bite**: you can't pour everything into one board and neglect the others — every lane must out-race its enemy. It also gives the cleanest teaching loss: an empty/under-built board never fires, gets ground down, and downs → you lose. (This is deliberately harsh for a prototype; may soften to per-lane survival later if it feels unfair — flagged for WFT-11/WFT-14.)

## 3. Battle flow (state machine)
- **⚔ Battle!** starts a fresh fight (resets both HP pools, charges). **⏸ Pause / ▶ Resume** toggles. On resolution the button becomes **↻ Fight again** (resets + restarts).
- **Editing the board** (place/remove/merge) is blocked while running and otherwise drops you back to **build mode** (resets the fight) — so you always test a fresh build.
- **Reset fight** (was "Reset enemies") restores both HP pools and clears the result.
- **0-group hero loses cleanly:** the tick no longer early-returns on an empty hero — it just skips firing and still lets the enemy attack, so an empty board grinds down to a loss instead of soft-locking.

## 4. Telegraph (Clarity)
Per hero the rail shows: hero HP bar (green→amber→red) + number · the enemy's threat `⚔atk/Ys` · the enemy HP bar. The result banner is colour-coded. The player can read the race before and during combat.

## 5. Starting values (Numbers Policy — provisional, retune WFT-11)

| Hero | HP | Enemy | Enemy HP | Enemy atk / cadence |
|---|---|---|---|---|
| Elara | 90 | Wisp | 120 | 6 / 1.4 s |
| Bran | 130 | Brute | 160 | 10 / 1.6 s |
| Vex | 100 | Shade | 120 | 7 / 1.2 s |

**Test plan (WFT-11):** with the shared budget (18), tune HP/atk/costs so a **well-built** board *barely* wins all three lanes and a **lazy or over-budget** board loses at least one. Pass/fail: a thoughtful build wins with <30% HP to spare on the tightest lane (Bran/Brute); an empty lane always loses.

## 6. Verification (2026-06-22)
- Damage is exact **both directions**: a 3-fire cluster took each enemy down by exactly its 18 volley; each hero lost exactly its enemy's atk per hit (6 / 10 / 7). No console errors.
- The **resolution state machine fires**: after a battle ran to completion the button reached **↻ Fight again** (only set by `setResult`, which also writes the banner and stops the clock). Pause/Resume/Fight-again/edit-resets-fight all verified.
- **Caveat:** the headless preview throttles `setInterval` when backgrounded, so watching a full ~50–90 s throttled battle live is unreliable; verification relied on exact per-volley DOM deltas + the resolution state transition rather than a freeze-frame of the banner.

## 7. Open / next
- **WFT-11 — retune** is now unblocked and is the priority (the budget number 18 and all HP/atk are guesses until tuned against this race).
- Reconsider any-downed vs per-lane survival once tuned.
