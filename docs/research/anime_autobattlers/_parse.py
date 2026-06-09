#!/usr/bin/env python3
"""Extract metadata + clean transcript from yt-dlp output."""
import json, re, sys

VID = "ozCDDzr9OmE"

# --- metadata ---
m = json.load(open(f"{VID}.info.json", encoding="utf-8"))
keys = ["title", "channel", "uploader", "channel_follower_count",
        "duration_string", "upload_date", "view_count", "like_count",
        "comment_count", "categories", "tags", "webpage_url"]
print("="*70)
print("METADATA")
print("="*70)
for k in keys:
    v = m.get(k)
    if isinstance(v, list):
        v = ", ".join(map(str, v[:40]))
    print(f"{k}: {v}")
print("-"*70)
print("DESCRIPTION:")
print((m.get("description") or "")[:4000])

# --- transcript ---
text = open(f"{VID}.en.vtt", encoding="utf-8").read()
seen, lines = set(), []
for line in text.split("\n"):
    if "-->" in line or line.startswith(("WEBVTT", "Kind:", "Language:")) \
       or not line.strip() or line.strip().isdigit():
        continue
    clean = re.sub(r"<[^>]+>", "", line).strip()
    clean = re.sub(r"\[.*?\]", "", clean).strip()
    if clean and clean not in seen:
        seen.add(clean)
        lines.append(clean)
plain = " ".join(lines)
plain = re.sub(r"\s+", " ", plain).strip()

with open(f"{VID}.transcript.txt", "w", encoding="utf-8") as f:
    f.write(plain)

print("="*70)
print(f"TRANSCRIPT: {len(plain)} chars, {len(plain.split())} words")
print("="*70)
print(plain)
