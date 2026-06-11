## Screenshot Helper — F12 saves a PNG of the current frame to user://.
##
## Closes the visual-feedback gap of Coding-Solo godot-mcp (which has no
## auto-screenshot of the running game).
##
## After running the project, screenshots land in:
##   Windows: %APPDATA%/Godot/app_userdata/WeaponCraft Godot Ultra-MVP/shot_<unix>.png
## You can fetch the latest with PowerShell:
##   Get-ChildItem $env:APPDATA\Godot\app_userdata\"WeaponCraft Godot Ultra-MVP" -Filter shot_*.png |
##     Sort-Object LastWriteTime -Descending | Select-Object -First 1
extends Node

func _ready() -> void:
	## Non-interactive capture: WC_AUTOSHOT=<absolute png path> renders the
	## main scene ~1.5s, saves a screenshot, and quits. Dev/CI tooling only.
	var auto_path: String = OS.get_environment("WC_AUTOSHOT")
	if auto_path != "":
		var t := get_tree().create_timer(1.5)
		t.timeout.connect(func():
			var img := get_viewport().get_texture().get_image()
			img.save_png(auto_path)
			get_tree().quit(0)
		)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"debug_screenshot"):
		_capture()

func _capture() -> void:
	var vp: Viewport = get_viewport()
	if vp == null:
		return
	var img: Image = vp.get_texture().get_image()
	if img == null:
		return
	var path: String = "user://shot_%d.png" % Time.get_unix_time_from_system()
	var err: int = img.save_png(path)
	if err == OK:
		print("[screenshot] saved ", ProjectSettings.globalize_path(path))
	else:
		push_warning("[screenshot] save_png failed err=%d" % err)
