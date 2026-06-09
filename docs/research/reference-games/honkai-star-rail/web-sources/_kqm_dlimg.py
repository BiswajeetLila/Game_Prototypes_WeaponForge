#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Download images listed in _imgurls.txt (url<TAB>alt) for a folder; write images.md.
Skips files <2KB (icons/sprites) and base64 (already excluded at extract). Uses curl+UA."""
import sys, os, subprocess, re

folder = sys.argv[1]
UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
urls_path = os.path.join(folder, "_imgurls.txt")
imgdir = os.path.join(folder, "images")
os.makedirs(imgdir, exist_ok=True)

entries = []
if os.path.exists(urls_path):
    for line in open(urls_path, encoding="utf-8"):
        line = line.rstrip("\n")
        if not line.strip():
            continue
        if "\t" in line:
            u, alt = line.split("\t", 1)
        else:
            u, alt = line, ""
        entries.append((u.strip(), alt.strip()))

def ext_for(u):
    m = re.search(r'\.(png|jpe?g|gif|webp|svg)(?:$|[?#])', u.lower())
    if m:
        e = m.group(1)
        return "jpg" if e == "jpeg" else e
    return "img"

rows = []
n = 0
for u, alt in entries:
    n += 1
    fname = f"{n}.{ext_for(u)}"
    dest = os.path.join(imgdir, fname)
    try:
        subprocess.run(["curl", "-sL", "-A", UA, u, "-o", dest], check=False, timeout=60)
    except Exception as e:
        rows.append((None, u, alt, f"download error: {e}"))
        continue
    size = os.path.getsize(dest) if os.path.exists(dest) else 0
    if size < 2048:
        if os.path.exists(dest):
            os.remove(dest)
        rows.append((None, u, alt, f"skipped (<2KB, {size} bytes)"))
        continue
    rows.append((fname, u, alt, f"{size} bytes"))

lines = ["# Images\n", "| local file | source URL | alt/caption | context |", "|---|---|---|---|"]
kept = 0
for fname, u, alt, ctx in rows:
    a = (alt or "").replace("|", "\\|")
    if fname:
        kept += 1
        lines.append(f"| images/{fname} | {u} | {a} | {ctx} |")
    else:
        lines.append(f"| (not saved) | {u} | {a} | {ctx} |")
with open(os.path.join(folder, "images.md"), "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")
print(f"KEPT={kept} TOTAL={len(entries)}")
