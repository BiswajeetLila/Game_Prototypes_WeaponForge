## Dev tool — flood-fill the white/near-white background of an item icon to transparent
## (edge-inward, so white inside the glyph is kept). Operates on absolute file paths in
## the _art-build/icons staging dir. Run headless: --script res://scripts/dev/cut_icon_bg.gd
extends SceneTree

const ICONS := "C:/_BISU/_WORKSPACE/AI_Explorations/_Claude/Game_Prototypes/6_WeaponForge_TFTransistor/_art-build/icons/"
const FILES := ["fire2_nano", "water_nano", "lightning_nano", "aoe_nano", "leech_nano", "burst_nano"]
const WHITE_CUTOFF := 0.82
const SAT_CUTOFF := 0.20

func _init() -> void:
	for f in FILES:
		_cut(ICONS + f + ".png", ICONS + f + "_cut.png")
	quit()

func _cut(src: String, dst: String) -> void:
	var img := Image.load_from_file(src)
	if img == null:
		print("[icon-cut] load fail ", src)
		return
	img.convert(Image.FORMAT_RGBA8)
	var w := img.get_width()
	var h := img.get_height()
	var visited := {}
	var stack: Array = []
	for x in w:
		stack.append(Vector2i(x, 0)); stack.append(Vector2i(x, h - 1))
	for y in h:
		stack.append(Vector2i(0, y)); stack.append(Vector2i(w - 1, y))
	while not stack.is_empty():
		var p: Vector2i = stack.pop_back()
		if p.x < 0 or p.y < 0 or p.x >= w or p.y >= h:
			continue
		var key := p.y * w + p.x
		if visited.has(key):
			continue
		visited[key] = true
		var c := img.get_pixel(p.x, p.y)
		if c.a <= 0.01:
			continue
		var lum := (c.r + c.g + c.b) / 3.0
		var sat := maxf(c.r, maxf(c.g, c.b)) - minf(c.r, minf(c.g, c.b))
		if lum < WHITE_CUTOFF or sat > SAT_CUTOFF:
			continue
		img.set_pixel(p.x, p.y, Color(c.r, c.g, c.b, 0.0))
		stack.append(Vector2i(p.x + 1, p.y)); stack.append(Vector2i(p.x - 1, p.y))
		stack.append(Vector2i(p.x, p.y + 1)); stack.append(Vector2i(p.x, p.y - 1))
	var err := img.save_png(dst)
	print("[icon-cut] %s -> %s (err=%d)" % [src, dst, err])
