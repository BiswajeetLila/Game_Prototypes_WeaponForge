#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Verbatim old.reddit thread extractor.
Parses raw.html in the given folder and writes content.md (post + every comment).
Also emits a JSON-ish summary line to stdout: COMMENTS=<n> IMAGES=<n list file written>
No summarizing/paraphrasing. Bodies taken exactly from <div class="md"> blocks.
"""
import sys, os, re, html, json
from html.parser import HTMLParser

folder = sys.argv[1]
raw_path = os.path.join(folder, "raw.html")
with open(raw_path, "r", encoding="utf-8", errors="replace") as f:
    HTML = f.read()

# ----------------------------------------------------------------------
# Helper: convert an HTML fragment (the inner of a <div class="md">) to text,
# preserving paragraph/line breaks and list markers, verbatim words.
# ----------------------------------------------------------------------
class MdToText(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.out = []
        self.list_stack = []
        self.skip = 0  # depth of tags whose text we keep but we just track
    def handle_starttag(self, tag, attrs):
        if tag in ("p", "blockquote", "h1", "h2", "h3", "h4", "h5", "h6"):
            self.out.append("\n\n")
        elif tag == "br":
            self.out.append("\n")
        elif tag in ("ul", "ol"):
            self.list_stack.append(tag)
            self.out.append("\n")
        elif tag == "li":
            self.out.append("\n- ")
        elif tag == "a":
            d = dict(attrs)
            self._href = d.get("href", "")
        elif tag in ("pre",):
            self.out.append("\n\n")
    def handle_endtag(self, tag):
        if tag in ("ul", "ol") and self.list_stack:
            self.list_stack.pop()
            self.out.append("\n")
        elif tag in ("p", "blockquote", "pre", "h1", "h2", "h3", "h4", "h5", "h6"):
            self.out.append("\n")
    def handle_data(self, data):
        self.out.append(data)
    def text(self):
        t = "".join(self.out)
        t = re.sub(r"\n{3,}", "\n\n", t)
        return t.strip()

def md_to_text(fragment):
    p = MdToText()
    p.feed(fragment)
    return p.text()

# ----------------------------------------------------------------------
# Extract the post (top of thread).
# old.reddit: the main link/self div has class "thing" with id starting t3_.
# Title in <a class="title ...">; selftext in the first <div class="usertext-body"> within the t3 thing's <div class="entry">.
# ----------------------------------------------------------------------

def find_div_span(s, start):
    """Given index of an opening <div...>, return (inner_start, inner_end_exclusive, after_index)
    by balancing div tags. start must point at the '<' of the opening div."""
    # find end of opening tag
    open_end = s.index(">", start) + 1
    depth = 1
    i = open_end
    tag_re = re.compile(r"<(/?)div\b", re.I)
    while depth > 0:
        m = tag_re.search(s, i)
        if not m:
            return open_end, len(s), len(s)
        if m.group(1) == "/":
            depth -= 1
            if depth == 0:
                return open_end, m.start(), s.index(">", m.end()) + 1
            i = m.end()
        else:
            depth += 1
            i = m.end()
    return open_end, len(s), len(s)

# ---- Post title ----
post_title = ""
m = re.search(r'<a[^>]*class="[^"]*\btitle\b[^"]*"[^>]*>(.*?)</a>', HTML, re.S)
if m:
    post_title = md_to_text(m.group(1))

# ---- Post author + score from the t3 thing ----
post_author = ""
post_score = ""
mt3 = re.search(r'<div class="[^"]*\bthing\b[^"]*"[^>]*id="thing_t3_[^"]*"', HTML)
post_selftext = ""
if mt3:
    # author
    seg = HTML[mt3.start():mt3.start()+4000]
    ma = re.search(r'data-author="([^"]*)"', seg)
    if ma:
        post_author = ma.group(1)
    ms = re.search(r'<div class="[^"]*\bthing\b[^"]*"[^>]*data-score="([^"]*)"', HTML[mt3.start():mt3.start()+2000])
    if ms:
        post_score = ms.group(1)
# fallback author/score via data attrs anywhere near top
if not post_author:
    ma = re.search(r'id="thing_t3_[^"]*"[^>]*data-author="([^"]*)"', HTML)
    if ma: post_author = ma.group(1)

# selftext: scope search to START at the t3 post thing (avoids subreddit t5_ sidebar)
# and END before the comment area.
t3_pos = HTML.find('id="thing_t3_')
if t3_pos == -1:
    t3_pos = 0
# back up to the start of that div so the whole post block is included
div_back = HTML.rfind('<div', 0, t3_pos)
post_block_start = div_back if div_back != -1 else t3_pos
comments_marker = HTML.find('class="commentarea"')
if comments_marker == -1:
    comments_marker = HTML.find('class="nestedlisting"')
if comments_marker == -1:
    comments_marker = HTML.find('nestedlisting')
seg_end = comments_marker if comments_marker != -1 and comments_marker > post_block_start else len(HTML)
head = HTML[post_block_start:seg_end]
# The post's editable selftext form belongs to the t3 thing (thing_id value t3_...).
msf = re.search(r'<div class="[^"]*usertext-body[^"]*"[^>]*>\s*<div class="md">(.*?)</div>\s*</div>\s*</form>', head, re.S)
if msf:
    post_selftext = md_to_text(msf.group(1))
else:
    msf = re.search(r'<div class="[^"]*usertext-body[^"]*"[^>]*>(.*?)</div>\s*</form>', head, re.S)
    if msf:
        inner = msf.group(1)
        mmd = re.search(r'<div class="md">(.*)</div>\s*$', inner, re.S)
        post_selftext = md_to_text(mmd.group(1) if mmd else inner)

# ----------------------------------------------------------------------
# Comments. Iterate each comment "thing" (id="thing_t1_...").
# For each: data-author, score (span class="score unvoted" or title attr),
# body = the LAST usertext-body div.md that belongs directly to this comment's entry
# (we take the first md after the thing's tagline, restricted to before child sitetable).
# We compute nesting depth by counting open child "sitetable" / margin via the structure.
# Simpler robust approach: process comment things in document order, depth = count of
# enclosing 'child' divs. We'll compute indentation by scanning.
# ----------------------------------------------------------------------

# Find all comment thing positions
comment_iter = list(re.finditer(r'<div class="[^"]*\bthing[^"]*\bcomment\b[^"]*"[^>]*id="thing_t1_([a-z0-9]+)"', HTML))
# Fallback if class order differs
if not comment_iter:
    comment_iter = list(re.finditer(r'<div class="[^"]*\bthing\b[^"]*"[^>]*id="thing_t1_([a-z0-9]+)"[^>]*data-type="comment"', HTML))
if not comment_iter:
    comment_iter = list(re.finditer(r'id="thing_t1_([a-z0-9]+)"', HTML))

# Build depth by tracking 'child' container nesting using a stack approach:
# We'll instead compute depth from how many '<div class="child">' are open at a thing's position.
# Precompute positions of relevant structural opens/closes is complex; use margin via 'class="thing ... " '
# Reliable enough: depth = number of "<div class=\"child\">" occurrences before pos minus number of matching closes is hard.
# Use a pragmatic method: count occurrences of 'data-type="comment"' ancestors via comment id appearing in parent links.
# Simplest reliable: use the comment's data-* 'data-permalink' depth? Not available.
# We'll approximate depth using the indentation offered by old.reddit: each comment thing is wrapped; we count
# how many comment "thing" divs are currently open (unclosed) before this one.

# Compute open/close events for comment things to derive nesting depth.
events = []  # (pos, +1/-1)
# opening positions
for m in comment_iter:
    events.append((m.start(), 'open', m.group(1), m.start()))
# To find closes we need balanced div matching per thing; do it on the fly below.

results = []
for idx, m in enumerate(comment_iter):
    cid = m.group(1)
    thing_start = m.start()
    inner_start, inner_end, after = find_div_span(HTML, thing_start)
    block = HTML[inner_start:inner_end]
    # author
    author = ""
    ma = re.search(r'data-author="([^"]*)"', HTML[thing_start:inner_start])
    if ma:
        author = ma.group(1)
    if not author:
        ma = re.search(r'data-author="([^"]*)"', block[:1500])
        if ma: author = ma.group(1)
    # deleted/removed authors
    if not author:
        if 'class="author"' not in block[:2000]:
            author = "[deleted]"
    # score
    score = ""
    msc = re.search(r'<span class="score unvoted"[^>]*>([^<]*)</span>', block)
    if msc:
        score = html.unescape(msc.group(1)).strip()
    else:
        msc = re.search(r'<span class="score unvoted"[^>]*title="([^"]*)"', block)
        if msc: score = msc.group(1) + " points"
        else:
            msc2 = re.search(r'<span class="score likes"[^>]*>([^<]*)</span>', block)
            if msc2: score = html.unescape(msc2.group(1)).strip()
    # body: the comment's own usertext-body .md. The first usertext-body in block
    # belongs to this comment (child replies come later and are nested inside child div, after).
    body = ""
    mb = re.search(r'<div class="[^"]*usertext-body[^"]*"[^>]*>\s*<div class="md">(.*?)</div>\s*</div>', block, re.S)
    if mb:
        body = md_to_text(mb.group(1))
    else:
        mb = re.search(r'<div class="md">(.*?)</div>', block, re.S)
        if mb:
            body = md_to_text(mb.group(1))
    # depth: count how many earlier comment things still 'contain' this one (inner_end > this thing_start)
    depth = 0
    for j in range(idx):
        pj = comment_iter[j].start()
        _, pe, _ = find_div_span(HTML, pj)
        if pj < thing_start < pe:
            depth += 1
    results.append({
        "id": cid, "author": author or "[unknown]",
        "score": score, "body": body, "depth": depth
    })

# ----------------------------------------------------------------------
# Write content.md
# ----------------------------------------------------------------------
lines = []
lines.append(f"# {post_title}\n")
lines.append(f"**Author:** {post_author or '[unknown]'}  ")
lines.append(f"**Score:** {post_score or '[n/a]'}\n")
lines.append("---\n")
if post_selftext:
    lines.append("## Post body\n")
    lines.append(post_selftext + "\n")
else:
    lines.append("## Post body\n\n*(no selftext — link/image post)*\n")
lines.append("---\n")
lines.append(f"## Comments ({len(results)})\n")
for c in results:
    indent = "    " * c["depth"]
    prefix = ">" * (c["depth"]) if c["depth"] else ""
    header = f'{indent}- **u/{c["author"]}** ({c["score"] or "n/a"})'
    lines.append(header)
    bodytext = c["body"] if c["body"] else "*(empty / deleted)*"
    for bl in bodytext.split("\n"):
        lines.append(f'{indent}  {bl}' if bl.strip() else "")
    lines.append("")

with open(os.path.join(folder, "content.md"), "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

# ----------------------------------------------------------------------
# Collect image URLs
# ----------------------------------------------------------------------
img_urls = set()
patterns = [
    r'https?://i\.redd\.it/[^\s"\'<>\\]+',
    r'https?://preview\.redd\.it/[^\s"\'<>\\]+',
    r'https?://external-preview\.redd\.it/[^\s"\'<>\\]+',
    r'https?://i\.imgur\.com/[^\s"\'<>\\]+',
]
for pat in patterns:
    for u in re.findall(pat, HTML):
        u = html.unescape(u)
        u = u.replace("&amp;", "&")
        img_urls.add(u)
# also <img src> in md bodies
for m in re.finditer(r'<img[^>]+src="([^"]+)"', HTML):
    u = html.unescape(m.group(1)).replace("&amp;", "&")
    if u.startswith("//"): u = "https:" + u
    if any(s in u for s in ("redd.it", "imgur.com")):
        img_urls.add(u)

with open(os.path.join(folder, "_imgurls.txt"), "w", encoding="utf-8") as f:
    for u in sorted(img_urls):
        f.write(u + "\n")

print(f"COMMENTS={len(results)} IMGURLS={len(img_urls)} TITLE_OK={bool(post_title)}")
