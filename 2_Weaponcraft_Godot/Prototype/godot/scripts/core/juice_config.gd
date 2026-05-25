## JuiceConfig — single source of truth for game-feel tuning.
##
## Lookup keys are the `source` StringName argument carried by
## Combat.hero_hit_enemy (e.g. &"basic", &"steamburst", &"ult"), plus the
## special keys for enemy attacks and wave clears.
##
## Crit overrides: a normal-source hit with is_crit=true should use the
## profile from {source}_crit if present, else fall back to the base source.
##
## All numbers are tweakable here — one file, the whole juice pipeline reads
## new values on the next session.
class_name JuiceConfig
extends Object

## Global kill-switch. Set to false to bypass ScreenShake + HitPause + sprite
## flash + popup spawn in all juice signal handlers. Use when isolating the
## juice layer from suspected hang / crash sources. Flip back to true after
## debugging.
const JUICE_ENABLED: bool = true

const PROFILES: Dictionary = {
	&"basic": {
		"shake_amp": 3.0, "shake_dur": 0.12, "pause": 0.05,
		"font_pt": 18, "color": Color("f0c060"), "prefix": "", "flash_dur": 0.05,
	},
	&"basic_crit": {
		"shake_amp": 6.0, "shake_dur": 0.18, "pause": 0.10,
		"font_pt": 26, "color": Color("ff6040"), "prefix": "⚡ ", "flash_dur": 0.07,
	},
	&"steamburst": {
		"shake_amp": 4.0, "shake_dur": 0.14, "pause": 0.06,
		"font_pt": 18, "color": Color("7ec5ff"), "prefix": "", "flash_dur": 0.06,
	},
	&"skewer": {
		"shake_amp": 4.0, "shake_dur": 0.14, "pause": 0.06,
		"font_pt": 18, "color": Color("9fe0ff"), "prefix": "", "flash_dur": 0.06,
	},
	&"hellfire": {
		"shake_amp": 4.0, "shake_dur": 0.14, "pause": 0.06,
		"font_pt": 18, "color": Color("ff8a4d"), "prefix": "", "flash_dur": 0.06,
	},
	&"ult": {
		"shake_amp": 10.0, "shake_dur": 0.35, "pause": 0.18,
		"font_pt": 28, "color": Color("cb8aff"), "prefix": "🌀 ", "flash_dur": 0.10,
	},
	&"ult_meteor": {
		"shake_amp": 10.0, "shake_dur": 0.35, "pause": 0.18,
		"font_pt": 28, "color": Color("ff7ab0"), "prefix": "🌀 ", "flash_dur": 0.10,
	},
	&"ult_shadowstep": {
		"shake_amp": 10.0, "shake_dur": 0.35, "pause": 0.18,
		"font_pt": 32, "color": Color("a86bff"), "prefix": "⚡🌀 ", "flash_dur": 0.12,
	},
}

const ENEMY_HIT_HERO: Dictionary = {
	"shake_amp": 4.0, "shake_dur": 0.15, "pause": 0.06,
	"font_pt": 16, "color": Color("ff6060"), "prefix": "-", "flash_dur": 0.05,
}

const WAVE_CLEAR: Dictionary = {
	"shake_amp": 6.0, "shake_dur": 0.25,
}

const FALLBACK: Dictionary = {
	"shake_amp": 3.0, "shake_dur": 0.12, "pause": 0.05,
	"font_pt": 18, "color": Color.WHITE, "prefix": "", "flash_dur": 0.05,
}

## Resolves a profile for a (source, is_crit) pair. Crit on a normal basic hit
## upgrades to "basic_crit"; crit on other sources keeps that source's profile
## (the source already carries its own visual identity, e.g. an ult crit isn't
## semantically meaningful for the popup).
static func profile_for(source: StringName, is_crit: bool) -> Dictionary:
	if source == &"basic" and is_crit:
		return PROFILES[&"basic_crit"]
	if PROFILES.has(source):
		return PROFILES[source]
	return FALLBACK
