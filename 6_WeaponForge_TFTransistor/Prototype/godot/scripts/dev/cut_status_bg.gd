## Dev tool — make the white/near-white background of the status icons transparent
## (flood-fill from the image edges so white INSIDE a glyph is preserved). Writes
## <name>_cut.png next to each source. Run headless once; re-run if the source art
## changes. Not part of the game; not shipped.
extends SceneTree

const DIR := "res://assets/generated/status/"
const NAMES := ["burning", "wet", "chilled", "shocked", "cracked"]
const WHITE_CUTOFF := 0.86  ## luminance above which a pixel is "background-ish"

func _init() -> void:
	for n in NAMES:
		_cut(DIR + n + ".png", DIR + n + "_cut.png")
	quit()

func _cut(src: String, dst: String) -> void:
	if not ResourceLoader.exists(src) and not FileAccess.file_exists(src):
		print("[cut] MISSING ", src)
		return
	var tex = load(src)
	if tex == null:
		print("[cut] load fail ", src)
		return
	var img: Image = tex.get_image()
	img.convert(Image.FORMAT_RGBA8)
	var w := img.get_width()
	var h := img.get_height()
	## flood-fill transparency inward from every edge pixel that is near-white
	var visited := {}
	var stack: Array = []
	for x in w:
		stack.append(Vector2i(x, 0))
		stack.append(Vector2i(x, h - 1))
	for y in h:
		stack.append(Vector2i(0, y))
		stack.append(Vector2i(w - 1, y))
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
		if lum < WHITE_CUTOFF or sat > 0.18:
			continue  ## hit the glyph edge — stop here, keep this pixel
		img.set_pixel(p.x, p.y, Color(c.r, c.g, c.b, 0.0))
		stack.append(Vector2i(p.x + 1, p.y))
		stack.append(Vector2i(p.x - 1, p.y))
		stack.append(Vector2i(p.x, p.y + 1))
		stack.append(Vector2i(p.x, p.y - 1))
	var err := img.save_png(dst)
	var cut := 0
	for k in visited.keys():
		cut += 1
	print("[cut] %s -> %s (err=%d, edge-visited=%d)" % [src, dst, err, cut])
