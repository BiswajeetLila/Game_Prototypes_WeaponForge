#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generic verbatim article extractor for WP-style news sites.
Usage: _extract_article.py <folder> <body_class> [title_selector]
Writes content.md (headline + byline/date + verbatim body) and _imgurls.txt.
No summarizing/paraphrasing. Body text taken exactly from the content container.
"""
import sys, os, re, html
from html.parser import HTMLParser

folder = sys.argv[1]
body_class = sys.argv[2]  # e.g. "entry-content single-content" or "post-content"

with open(os.path.join(folder, "raw.html"), "r", encoding="utf-8", errors="replace") as f:
    HTML = f.read()


def meta(prop_attr, prop_val):
    m = re.search(r'<meta[^>]+%s="%s"[^>]+content="([^"]*)"' % (prop_attr, re.escape(prop_val)), HTML)
    if not m:
        m = re.search(r'<meta[^>]+content="([^"]*)"[^>]+%s="%s"' % (prop_attr, re.escape(prop_val)), HTML)
    return html.unescape(m.group(1)) if m else ""


# ---- headline ----
headline = meta("property", "og:title")
if not headline:
    m = re.search(r'<h1[^>]*>(.*?)</h1>', HTML, re.S)
    if m:
        headline = re.sub(r'<[^>]+>', '', m.group(1)).strip()
if not headline:
    m = re.search(r'<title>(.*?)</title>', HTML, re.S)
    if m:
        headline = html.unescape(m.group(1)).strip()

# ---- date / author ----
pub_date = meta("property", "article:published_time") or meta("itemprop", "datePublished")
if not pub_date:
    m = re.search(r'datetime="([^"]+)"', HTML)
    if m:
        pub_date = m.group(1)
author = meta("name", "author") or meta("property", "article:author")
if not author:
    m = re.search(r'<a[^>]*rel="author"[^>]*>(.*?)</a>', HTML, re.S)
    if m:
        author = re.sub(r'<[^>]+>', '', m.group(1)).strip()
description = meta("name", "description") or meta("property", "og:description")


# ---- find the content container by class, balance divs ----
def find_container(s, cls):
    # find an opening div whose class attribute contains all words of cls
    words = cls.split()
    for m in re.finditer(r'<div\b([^>]*)\bclass="([^"]*)"', s):
        classes = m.group(2).split()
        if all(w in classes for w in words):
            start = m.start()
            open_end = s.index(">", start) + 1
            depth = 1
            i = open_end
            tag_re = re.compile(r"<(/?)div\b", re.I)
            while depth > 0:
                mm = tag_re.search(s, i)
                if not mm:
                    return s[open_end:]
                if mm.group(1) == "/":
                    depth -= 1
                    if depth == 0:
                        return s[open_end:mm.start()]
                    i = mm.end()
                else:
                    depth += 1
                    i = mm.end()
    return ""


container = find_container(HTML, body_class)
if not container:
    print("WARN: container not found for class:", body_class)


# ---- HTML fragment -> verbatim text with structure ----
class FragText(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.out = []
        self.skip_depth = 0  # inside script/style
        self.cur_href = None
        self.captions = []
        self.in_fig = 0
        self.fig_buf = []

    def handle_starttag(self, tag, attrs):
        d = dict(attrs)
        if tag in ("script", "style", "noscript"):
            self.skip_depth += 1
        elif tag in ("p", "div", "section"):
            self.out.append("\n\n")
        elif tag in ("h1", "h2", "h3", "h4", "h5", "h6"):
            self.out.append("\n\n" + "#" * int(tag[1]) + " ")
        elif tag == "br":
            self.out.append("\n")
        elif tag == "li":
            self.out.append("\n- ")
        elif tag in ("ul", "ol"):
            self.out.append("\n")
        elif tag == "blockquote":
            self.out.append("\n\n> ")
        elif tag == "figcaption":
            self.out.append("\n\n_[caption]_ ")
        elif tag == "img":
            src = d.get("src") or d.get("data-src") or ""
            alt = d.get("alt", "")
            if src:
                self.out.append("\n\n![%s](%s)\n" % (alt, src))
        elif tag == "tr":
            self.out.append("\n| ")
        elif tag in ("td", "th"):
            self.out.append(" ")

    def handle_endtag(self, tag):
        if tag in ("script", "style", "noscript") and self.skip_depth > 0:
            self.skip_depth -= 1
        elif tag in ("td", "th"):
            self.out.append(" |")
        elif tag in ("p", "div", "section", "h1", "h2", "h3", "h4", "h5", "h6",
                     "blockquote", "figcaption", "li", "tr"):
            self.out.append("\n")

    def handle_data(self, data):
        if self.skip_depth == 0:
            self.out.append(data)

    def text(self):
        t = "".join(self.out)
        t = re.sub(r'[ \t]+', ' ', t)
        t = re.sub(r' *\n *', '\n', t)
        t = re.sub(r'\n{3,}', '\n\n', t)
        return t.strip()


body_text = ""
if container:
    fp = FragText()
    fp.feed(container)
    body_text = fp.text()

# ---- write content.md ----
lines = []
lines.append("# " + (headline or "[no headline]"))
lines.append("")
if author:
    lines.append("**Author:** " + author + "  ")
if pub_date:
    lines.append("**Published:** " + pub_date + "  ")
if description:
    lines.append("")
    lines.append("**Description (meta):** " + description)
lines.append("")
lines.append("---")
lines.append("")
lines.append(body_text if body_text else "*(content container not extracted)*")
lines.append("")

with open(os.path.join(folder, "content.md"), "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

# ---- collect image urls (from container + og:image) ----
img_urls = []
seen = set()


def add(u):
    u = html.unescape(u).replace("&amp;", "&")
    if u.startswith("//"):
        u = "https:" + u
    if u.startswith("http") and u not in seen:
        seen.add(u)
        img_urls.append(u)


ogimg = meta("property", "og:image")
if ogimg:
    add(ogimg)
scope = container if container else HTML
for m in re.finditer(r'<img[^>]+(?:src|data-src)="([^"]+)"', scope):
    add(m.group(1))
# also srcset first candidate
for m in re.finditer(r'<img[^>]+srcset="([^"]+)"', scope):
    first = m.group(1).split(",")[0].strip().split(" ")[0]
    add(first)

with open(os.path.join(folder, "_imgurls.txt"), "w", encoding="utf-8") as f:
    for u in img_urls:
        f.write(u + "\n")

print("CHARS=%d IMGURLS=%d HEADLINE_OK=%s" % (len(body_text), len(img_urls), bool(headline)))
