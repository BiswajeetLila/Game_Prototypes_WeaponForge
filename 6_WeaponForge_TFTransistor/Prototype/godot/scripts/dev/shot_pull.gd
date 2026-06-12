## Dev: opens the PullOverlay (Vex) so WC_AUTOSHOT can capture it.
extends Control

func _ready() -> void:
	var overlay = load("res://scenes/PullOverlay.tscn").instantiate()
	add_child(overlay)
	## add_child triggers overlay._ready() synchronously (sets @onready vars).
	## Call open() immediately — no await needed.
	overlay.open(&"vex")
