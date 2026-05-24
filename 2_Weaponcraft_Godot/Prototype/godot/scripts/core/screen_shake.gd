## ScreenShake — autoload that wobbles a registered Control target.
##
## Trauma model: kick() adds to a `_trauma` accumulator (clamped 0..1) and a
## decay rate. Per frame, target.position = random vec scaled by trauma squared
## times PEAK_AMPLITUDE_PX. Trauma decays linearly to 0 at decay_per_sec.
##
## Simultaneous kicks stack via max — a crit during an ult doesn't compound;
## the bigger of the two wins. Empty queue restores target to (0, 0).
##
## Public API:
##   register_target(node: Control)   Set the Control whose position to wobble
##                                    (typically Main scene root).
##   kick(amp_px, dur_sec)            Inject a shake. amp_px scales the random
##                                    offset; dur_sec controls how fast it
##                                    decays back to zero.
extends Node

const PEAK_AMPLITUDE_PX: float = 12.0

var _trauma: float = 0.0
var _decay_per_sec: float = 1.0
var _target: Control = null
var _origin_pos: Vector2 = Vector2.ZERO

func register_target(node: Control) -> void:
	_target = node
	_origin_pos = node.position if node != null else Vector2.ZERO

func kick(amplitude_px: float, duration_sec: float) -> void:
	if _target == null:
		return
	var t: float = clampf(amplitude_px / PEAK_AMPLITUDE_PX, 0.0, 1.0)
	_trauma = maxf(_trauma, t)
	## Pick the larger decay rate so a punchier kick during a long shake speeds
	## the decay back to zero rather than dragging the tail.
	_decay_per_sec = maxf(_decay_per_sec, t / maxf(duration_sec, 0.01))

func _process(delta: float) -> void:
	if _target == null:
		return
	if _trauma <= 0.0:
		_target.position = _origin_pos
		return
	var shake: float = _trauma * _trauma * PEAK_AMPLITUDE_PX
	_target.position = _origin_pos + Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
	_trauma = maxf(0.0, _trauma - _decay_per_sec * delta)
	if _trauma <= 0.0:
		_target.position = _origin_pos
