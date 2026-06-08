shader_type canvas_item;

// Soft circular alpha mask + thin rim. UV is the rect-local 0..1 space, so
// the mask works regardless of the texture's aspect (the rect itself must be
// square for a true circle).
uniform float radius : hint_range(0.0, 0.5) = 0.49;
uniform float feather : hint_range(0.0, 0.05) = 0.01;
uniform float rim_width : hint_range(0.0, 0.1) = 0.02;
uniform vec4 rim_color : source_color = vec4(0.949, 0.722, 0.133, 1.0);

void fragment() {
	vec2 uv = UV - vec2(0.5);
	float d = length(uv);
	float inside = 1.0 - smoothstep(radius - feather, radius, d);
	vec4 base = texture(TEXTURE, UV);
	// Rim band just inside the edge (thin gold ring like the reference cards).
	float rim_inner = radius - rim_width;
	float rim_band = smoothstep(rim_inner, rim_inner + feather, d) * inside;
	vec3 rgb = mix(base.rgb, rim_color.rgb, rim_band * rim_color.a);
	COLOR = vec4(rgb, base.a * inside);
}
