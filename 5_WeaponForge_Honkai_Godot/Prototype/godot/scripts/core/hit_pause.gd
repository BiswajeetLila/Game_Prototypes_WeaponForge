## HitPause — autoload that briefly freezes Engine.time_scale on impact.
##
## freeze(seconds) sets Engine.time_scale = 0 then waits via a wall-clock loop
## driven by process_frame (which fires regardless of time_scale). Once the
## requested window elapses, time_scale resets to 1.
##
## Concurrent calls extend the existing window via max, BUT every request is
## first clamped to MAX_FREEZE_SEC. This is the hard ceiling that protects
## against a runaway chain (Steamburst + Skewer + Hellfire all landing in one
## tick on a multi-hero squad). Without the cap, an attacker-side chain of 5+
## hits during a single tick could keep extending the wall-clock window and
## leave the engine effectively frozen long enough to look like a hard hang.
##
## Note: tweens, Combat tick timer, and the SquadBar pulse all freeze for the
## duration. ScreenShake's _process keeps firing so the wobble continues during
## the pause, which is intentional — it sells the impact.
extends Node

## Absolute ceiling on a single requested pause AND on the wall-clock window.
## 200ms is generous for "punchy-but-cozy" feel without ever stalling the loop.
const MAX_FREEZE_SEC: float = 0.2

var _pending_until_ms: int = -1
var _looping: bool = false

func freeze(seconds: float) -> void:
	if seconds <= 0.0:
		return
	## Cap the requested pause AND the cumulative window so a flood of calls
	## never pushes _pending_until_ms beyond now + MAX_FREEZE_SEC.
	var clamped: float = minf(seconds, MAX_FREEZE_SEC)
	var now: int = Time.get_ticks_msec()
	var ceiling: int = now + int(MAX_FREEZE_SEC * 1000.0)
	var until: int = mini(now + int(clamped * 1000.0), ceiling)
	_pending_until_ms = maxi(_pending_until_ms, until)
	## Even if max'd against an older _pending_until_ms, never exceed ceiling.
	_pending_until_ms = mini(_pending_until_ms, ceiling)
	if not _looping:
		_run_freeze_loop()

func _run_freeze_loop() -> void:
	_looping = true
	Engine.time_scale = 0.0
	while Time.get_ticks_msec() < _pending_until_ms:
		await get_tree().process_frame
	Engine.time_scale = 1.0
	_pending_until_ms = -1
	_looping = false
