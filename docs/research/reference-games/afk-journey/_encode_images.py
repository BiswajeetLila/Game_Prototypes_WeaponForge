"""Encode all chosen screenshots to base64 JSON manifest for deck assembler."""
import base64
import json
import pathlib

ROOT = pathlib.Path(__file__).parent

IMAGES = {
    "ICON":         ("web-sources/02-appstore-us-listing/images/AppIcon-512x512.jpg", "image/jpeg"),
    "COVER_HERO":   ("videos/v1-f2-9q0wgfOY/frames/f_00060.jpg",                       "image/jpeg"),
    "BATTLE":       ("videos/v1-f2-9q0wgfOY/frames/f_00150.jpg",                       "image/jpeg"),
    "LEVELUP":      ("videos/v1-f2-9q0wgfOY/frames/f_00120.jpg",                       "image/jpeg"),
    "RESONANCE":    ("videos/v2-0mb9XIFjFG4/frames/f_00050.jpg",                       "image/jpeg"),
    "RESONHALL":    ("videos/v3-48SNAAhcKLk/frames/f_00200.jpg",                       "image/jpeg"),
    "VFX":          ("videos/v1-f2-9q0wgfOY/frames/f_00030.jpg",                       "image/jpeg"),
}

out = {}
total = 0
for key, (rel, mime) in IMAGES.items():
    p = ROOT / rel
    data = p.read_bytes()
    b64 = base64.b64encode(data).decode()
    out[key] = {
        "path": rel,
        "size_kb": len(data) // 1024,
        "data_uri": f"data:{mime};base64,{b64}",
        "b64_len": len(b64),
    }
    total += len(data)
    print(f"  {key:12s} {rel:60s} {len(data)//1024:>4d} KB")

print(f"  TOTAL: {total//1024} KB")

manifest_path = ROOT / "_image_manifest.json"
manifest_path.write_text(json.dumps(out, indent=2), encoding="utf-8")
print(f"Wrote {manifest_path} ({manifest_path.stat().st_size//1024} KB)")
