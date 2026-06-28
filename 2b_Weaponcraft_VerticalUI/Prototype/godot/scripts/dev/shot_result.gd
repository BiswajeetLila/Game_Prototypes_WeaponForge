## Dev: seeds a finished-run state and opens the victory ResultModal so
## WC_AUTOSHOT can capture it. Not a test — a render rig.
extends Control

func _ready() -> void:
	AccountState.save_path = "user://account_shot.json"
	AccountState.reset()
	AccountState.ensure_defaults()
	AccountState.add_hero_xp(&"bran", 900)   ## L1, near L2 — bar nearly full
	GameState.new_session([&"bran", &"elara"])
	for i in range(3):
		GameState.award_wave_xp()             ## bran crosses into L2 -> LEVEL UP row
	var modal = load("res://scenes/ResultModal.tscn").instantiate()
	add_child(modal)
	## add_child triggers modal._ready() synchronously (sets @onready vars).
	## Call open() immediately — no await needed.
	modal.open(&"clear")
