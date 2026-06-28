## SlotLabels — maps (hero class, backend slot id) → display label for the UI.
##
## Backend slot ids are head · rune · body (rune is the center slot). The *label*
## shown to the player varies by weapon type; only "Rune" is constant. Per the
## 3-hero vertical-UI spec (2026-06-28-3hero-vertical-ui-design.md §2).
##
## Pure data + a static lookup — no node, no autoload. Consumers preload:
##   const SlotLabels = preload("res://scripts/ui/slot_labels.gd")
##   var txt := SlotLabels.label(hero.data.cls, slot_id)
class_name SlotLabels

## class (HeroData.cls) -> { slot_id -> label }
const MAP: Dictionary = {
	&"warrior": {&"head": "Hilt",  &"rune": "Rune", &"body": "Blade"},
	&"mage":    {&"head": "Shaft", &"rune": "Rune", &"body": "Orb"},
	&"rogue":   {&"head": "Grip",  &"rune": "Rune", &"body": "Fang"},
}

## Fallback labels when the class is unknown (generic weapon anatomy).
const FALLBACK: Dictionary = {&"head": "Head", &"rune": "Rune", &"body": "Body"}

## Returns the display label for a slot given the hero's class. Safe for any input.
static func label(cls: StringName, slot: StringName) -> String:
	var by_cls: Dictionary = MAP.get(cls, FALLBACK)
	return String(by_cls.get(slot, FALLBACK.get(slot, String(slot))))

## Ordered [head, rune, body] labels for a class — handy for building a row.
static func ordered(cls: StringName) -> Array:
	return [label(cls, &"head"), label(cls, &"rune"), label(cls, &"body")]
