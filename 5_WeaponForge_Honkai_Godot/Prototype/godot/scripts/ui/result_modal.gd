## ResultModal — wipe / stage-clear end-of-run screen.
##
## Two flavors driven by `kind`:
##   "wipe"   — Bran died. Single "Try Again" button restarts session.
##   "clear"  — Stage cleared. Single "Play Again" button restarts session.
##
## Main listens to GameState.stage_cleared / hero_died and calls open(kind).
extends ColorRect

signal restart_requested

@onready var _title: Label = %Title
@onready var _subtitle: Label = %Subtitle
@onready var _btn: Button = %ActionBtn

func _ready() -> void:
	hide()
	_btn.pressed.connect(func():
		hide()
		emit_signal(&"restart_requested")
	)

func open(kind: StringName) -> void:
	match kind:
		&"wipe":
			_title.text = "💀 WIPE"
			_title.add_theme_color_override(&"font_color", Color("ff5555"))
			_subtitle.text = "Squad fell at wave %d." % GameState.wave
			_btn.text = "⌂ Home"
		&"clear":
			_title.text = "🏆 BOSS DOWN"
			_title.add_theme_color_override(&"font_color", Color("ffd700"))
			_subtitle.text = "Run complete — +%d💎 banked." % AccountState.RUN_VICTORY_BONUS
			_btn.text = "⌂ Home"
		_:
			_title.text = "?"
			_subtitle.text = ""
			_btn.text = "↺ Restart"
	show()
