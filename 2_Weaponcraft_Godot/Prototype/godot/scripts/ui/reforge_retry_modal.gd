## ReforgeRetryModal — Stage D boss-wipe recovery screen.
##
## Opens only when squad_wiped fires AT a boss wave (5 / 10 / 15). On any
## other wave the existing ResultModal "wipe" path runs.
##
## Two buttons:
##   "↺ Reforge & Retry" — Main calls GameState.revive_squad_for_retry()
##                         then re-opens the forge for the same boss wave.
##                         Inventory + gold + recipes preserved.
##   "💀 Give Up"        — Main routes through to ResultModal.open(&"wipe"),
##                         identical to the non-boss wipe flow.
extends ColorRect

signal retry_requested
signal give_up_requested

@onready var _title: Label = %Title
@onready var _subtitle: Label = %Subtitle
@onready var _retry_btn: Button = %RetryBtn
@onready var _give_up_btn: Button = %GiveUpBtn

func _ready() -> void:
	hide()
	_retry_btn.pressed.connect(func():
		hide()
		emit_signal(&"retry_requested"))
	_give_up_btn.pressed.connect(func():
		hide()
		emit_signal(&"give_up_requested"))

## Called by Main on boss-wave wipe. Boss name + wave drive the title /
## subtitle copy so the player knows which fight is being re-offered.
func open(boss_name: String, wave: int) -> void:
	_title.text = "💀 %s DEFEATED YOU" % boss_name.to_upper()
	_title.add_theme_color_override(&"font_color", Color("ff5555"))
	_subtitle.text = "Wave %d wipe. Inventory + gold preserved." % wave
	show()
