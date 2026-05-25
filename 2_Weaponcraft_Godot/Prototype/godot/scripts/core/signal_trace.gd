## SignalTrace — autoload diagnostic for tracing the last juice signal
## handler entered. Writes user://last_signal.txt with the handler name +
## payload every call. On a hang, the file pinpoints the last signal handler
## the main thread reached.
##
## Public API:
##   note(handler_name: StringName, payload := {})
extends Node

const PATH: String = "user://last_signal.txt"

func note(handler_name: StringName, payload: Dictionary = {}) -> void:
	var f := FileAccess.open(PATH, FileAccess.WRITE)
	if f == null:
		return
	f.store_line("handler=%s frame=%d ticks_msec=%d payload=%s"
		% [String(handler_name), Engine.get_process_frames(), Time.get_ticks_msec(), str(payload)])
