## TierScale — canonical Function tier stat multiplier (spec §10.1).
## T1..T5 = 1.0 / 1.4 / 2.0 / 2.8 / 4.0. Preload to use (class_name unreliable in headless).
class_name TierScale
extends RefCounted

const MULT: Array = [1.0, 1.4, 2.0, 2.8, 4.0]

## Stat multiplier for a tier (T1..T5 -> 1.0..4.0). Out-of-range tiers clamp to the ends.
static func mult(tier: int) -> float:
	var i := clampi(tier - 1, 0, MULT.size() - 1)
	return float(MULT[i])
