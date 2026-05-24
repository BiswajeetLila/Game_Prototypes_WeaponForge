## HitPause — autoload that briefly freezes Engine.time_scale on impact.
##
## freeze(seconds) sets Engine.time_scale = 0 then waits via a wall-clock loop
## driven by process_frame (which fires regardless of time_scale). Once the
## requested window elapses, time_scale resets to 1.
##
## Concurrent calls stack via max: a longer pause requested mid-freeze extends
## the existing window rather than restarting it. Re-entrancy is safe — only
## the outermost _run_freeze_loop touches time_scale.
##
## Note: tweens, Combat tick timer, and the SquadBar pulse all freeze for the
## duration. ScreenShake's _process keeps firing so the wobble continues during
## the pause, which is intentional — it sells the impact.
extends Node

var _pending_until_ms: int = -1
var _looping: bool = false

func freeze(seconds: float) -> void:
	if seconds <= 0.0:
		return
	var until: int = Time.get_ticks_msec() + int(seconds * 1000.0)
	_pending_until_ms = maxi(_pending_until_ms, until)
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

func _process(_delta: float) -> void:
	pass
