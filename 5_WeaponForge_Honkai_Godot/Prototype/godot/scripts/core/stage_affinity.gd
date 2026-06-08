## StageAffinity — deterministic per-stage element affinities for the pre-stage
## counter-build. Pure static helper (no autoload). Stage 1 mirrors the boss
## (teaching, no spread); stage >=2 the minion affinity differs from the boss
## weakness (spread) and sometimes equals the boss resistance (conflict).
class_name StageAffinity
extends RefCounted

const ELEMENTS: Array = [&"fire", &"ice", &"electric", &"wind"]

static func _boss_def(stage: int):
	return GameState.get_enemy_def(Combat.boss_for_stage(stage))

static func boss_weak(stage: int) -> StringName:
	var d = _boss_def(stage)
	return d.weak_tag if d != null else &""

static func boss_resist(stage: int) -> StringName:
	var d = _boss_def(stage)
	return d.resist_tag if d != null else &""

## Deterministic minion {weak, resist}. STARTING formula (Numbers Policy) — tune
## the index offsets if the conflict-rate test (>=1/3) fails.
static func minion_affinity(stage: int) -> Dictionary:
	var bw: StringName = boss_weak(stage)
	var br: StringName = boss_resist(stage)
	if stage <= 1:
		return {&"weak": bw, &"resist": br}   ## teaching: mirror the boss
	var n: int = ELEMENTS.size()
	var wi: int = (stage * 2 + 1) % n
	var w: StringName = ELEMENTS[wi]
	if w == bw:                                ## guarantee the spread
		w = ELEMENTS[(wi + 1) % n]
	var ri: int = (stage + 1) % n
	var r: StringName = ELEMENTS[ri]
	if r == w:
		r = ELEMENTS[(ri + 1) % n]
	return {&"weak": w, &"resist": r}

static func affinity_for(stage: int) -> Dictionary:
	var m: Dictionary = minion_affinity(stage)
	return {
		&"minion_weak": m[&"weak"], &"minion_resist": m[&"resist"],
		&"boss_weak": boss_weak(stage), &"boss_resist": boss_resist(stage),
	}
