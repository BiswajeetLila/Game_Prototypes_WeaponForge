#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Download images listed in _imgurls.txt for a folder; write images.md.
Skips files <2KB (likely sprites/avatars/empty). Uses curl with UA."""
import sys, os, subprocess, re, html

folder = sys.argv[1]
UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
urls_path = os.path.join(folder, "_imgurls.txt")
imgdir = os.path.join(folder, "images")
os.makedirs(imgdir, exist_ok=True)

urls = []
if os.path.exists(urls_path):
    with open(urls_path, encoding="utf-8") as f:
        urls = [l.strip() for l in f if l.strip()]

def ext_for(u):
    m = re.search(r'\.(png|jpe?g|gif|webp)', u.lower())
    if m:
        e = m.group(1)
        return "jpg" if e == "jpeg" else e
    return "img"

rows = []
n = 0
for u in urls:
    n += 1
    ext = ext_for(u)
    fname = f"{n}.{ext}"
    dest = os.path.join(imgdir, fname)
    # decode any residual entities
    cu = html.unescape(u).replace("&amp;", "&")
    try:
        subprocess.run(["curl", "-sL", "-A", UA, cu, "-o", dest],
                       check=False, timeout=60)
    except Exception as e:
        rows.append((None, cu, f"download error: {e}"))
        continue
    size = os.path.getsize(dest) if os.path.exists(dest) else 0
    if size < 2048:
        # too small -> skip (sprite/avatar/empty)
        if os.path.exists(dest):
            os.remove(dest)
        rows.append((None, cu, f"skipped (<2KB, {size} bytes)"))
        continue
    rows.append((fname, cu, f"{size} bytes"))

# write images.md
lines = ["# Images\n", "| local file | source URL | context |", "|---|---|---|"]
kept = 0
for fname, u, ctx in rows:
    if fname:
        kept += 1
        lines.append(f"| images/{fname} | {u} | {ctx} |")
    else:
        lines.append(f"| (not saved) | {u} | {ctx} |")
with open(os.path.join(folder, "images.md"), "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")
print(f"KEPT={kept} TOTAL={len(urls)}")
