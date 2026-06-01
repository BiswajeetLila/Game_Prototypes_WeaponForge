## Heartbeat — autoload that writes a per-frame liveness ping to user://heartbeat.txt.
##
## When Godot hangs, the live `godot.log` often doesn't flush, leaving no
## sign of where the main thread died. This autoload writes a tiny text file
## every Nth process frame so that AFTER a hang, the file's last-modified
## timestamp + body tells us:
##   1. Whether the main thread was alive during the freeze (mtime is recent
##      = engine was still ticking _process; mtime is stale = main thread
##      was blocked).
##   2. Which engine frame was last drawn.
##
## Polling cost: one FileAccess.open/store_line/close every WRITE_EVERY_FRAMES
## process frames. With WRITE_EVERY_FRAMES = 6 (~10 Hz at 60fps), cost is
## ~0.05ms/sec — negligible.
extends Node

const HEARTBEAT_PATH: String = "user://heartbeat.txt"
const WRITE_EVERY_FRAMES: int = 6

var _frame_counter: int = 0

func _ready() -> void:
	## Write a sentinel immediately so anything polling the file at start-up
	## sees a valid heartbeat, not a missing file. _process refreshes it.
	_write()

func _process(_delta: float) -> void:
	_frame_counter += 1
	if _frame_counter % WRITE_EVERY_FRAMES != 0:
		return
	_write()

func _write() -> void:
	var f := FileAccess.open(HEARTBEAT_PATH, FileAccess.WRITE)
	if f == null:
		return
	f.store_line("frame=%d ticks_msec=%d time_scale=%.2f"
		% [Engine.get_process_frames(), Time.get_ticks_msec(), Engine.time_scale])
