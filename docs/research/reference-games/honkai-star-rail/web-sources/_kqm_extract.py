#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Verbatim extractor for keqingmains.com (WordPress) character/guide pages.
Extracts ALL human-visible text from the <main>/<article> entry-content region,
in document order: headings, paragraphs, lists, blockquotes, and TABLES
(rendered as markdown tables with cell values exactly as shown).
Nav/header/footer/menu/social/script/style stripped.
No summarizing/paraphrasing/sampling. Words kept verbatim.

Usage: python3 _kqm_extract.py <folder>
Writes: <folder>/content.md  and  <folder>/_imgurls.txt
Prints: CHARS=<n> TABLES=<n> HEADINGS=<n> IMGURLS=<n>
"""
import sys, os, re, html
from html.parser import HTMLParser

folder = sys.argv[1]
HOST = "https://hsr.keqingmains.com"
raw = open(os.path.join(folder, "raw.html"), encoding="utf-8", errors="replace").read()

# ---- Isolate the main content region -------------------------------------
# Prefer <div ... class="...entry-content...">, else <article>, else <main>.
def slice_region(s):
    m = re.search(r'<div[^>]*class="[^"]*\bentry-content\b[^"]*"[^>]*>', s, re.I)
    if m:
        start = m.end()
        # balance divs from the opening of entry-content
        op = m.start()
        depth = 0
        i = op
        for mm in re.finditer(r'<(/?)div\b', s[op:], re.I):
            if mm.group(1) == "/":
                depth -= 1
            else:
                depth += 1
            if depth == 0:
                return s[start: op + mm.start()]
        return s[start:]
    m = re.search(r'<article[^>]*>(.*?)</article>', s, re.I | re.S)
    if m:
        return m.group(1)
    m = re.search(r'<main[^>]*>(.*?)</main>', s, re.I | re.S)
    return m.group(1) if m else s

region = slice_region(raw)

# ---- Remove non-content sub-blocks (nav menus, social, scripts, styles) ---
def strip_blocks(s):
    s = re.sub(r'<script\b.*?</script>', '', s, flags=re.I | re.S)
    s = re.sub(r'<style\b.*?</style>', '', s, flags=re.I | re.S)
    s = re.sub(r'<svg\b.*?</svg>', '', s, flags=re.I | re.S)
    s = re.sub(r'<noscript\b.*?</noscript>', '', s, flags=re.I | re.S)
    # nav menus / share bars by class
    for cls in ("nav", "menu", "social", "share", "breadcrumb", "ez-toc-widget",
                "wp-block-buttons", "site-footer", "comment"):
        # remove <... class="...cls...">...balanced... — only for simple non-nested-safe via div/nav/ul
        pass
    return s

region = strip_blocks(region)

# ---- Image URLs (collect before text parse) -------------------------------
img_urls = []
seen = set()
for m in re.finditer(r'<img\b[^>]*>', region, re.I):
    tag = m.group(0)
    src = None
    for attr in ("data-src", "data-lazy-src", "src"):
        am = re.search(attr + r'="([^"]+)"', tag, re.I)
        if am:
            v = am.group(1)
            if v.startswith("data:"):
                continue
            src = v
            break
    if not src:
        continue
    src = html.unescape(src).replace("&amp;", "&")
    if src.startswith("//"):
        src = "https:" + src
    elif src.startswith("/"):
        src = HOST + src
    alt = ""
    al = re.search(r'\balt="([^"]*)"', tag, re.I)
    if al:
        alt = html.unescape(al.group(1)).replace("&amp;", "&")
    if src not in seen:
        seen.add(src)
        img_urls.append((src, alt))

# ---- Table renderer --------------------------------------------------------
class CellParser(HTMLParser):
    """Flatten a table cell's inner HTML to single-line text."""
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.parts = []
    def handle_starttag(self, tag, attrs):
        if tag in ("br",):
            self.parts.append(" / ")
        if tag == "img":
            d = dict(attrs)
            a = d.get("alt", "")
            if a:
                self.parts.append(f"[{a}]")
    def handle_data(self, data):
        self.parts.append(data)
    def text(self):
        t = "".join(self.parts)
        t = re.sub(r"\s+", " ", t).strip()
        return t.replace("|", "\\|")

def cell_text(frag):
    p = CellParser()
    p.feed(frag)
    return p.text()

def render_table(tbl_html):
    rows = re.findall(r'<tr\b[^>]*>(.*?)</tr>', tbl_html, re.I | re.S)
    out_rows = []
    for r in rows:
        cells = re.findall(r'<t[hd]\b[^>]*>(.*?)</t[hd]>', r, re.I | re.S)
        out_rows.append([cell_text(c) for c in cells])
    out_rows = [r for r in out_rows if any(c for c in r)]
    if not out_rows:
        return ""
    ncol = max(len(r) for r in out_rows)
    out_rows = [r + [""] * (ncol - len(r)) for r in out_rows]
    lines = []
    header = out_rows[0]
    lines.append("| " + " | ".join(header) + " |")
    lines.append("| " + " | ".join(["---"] * ncol) + " |")
    for r in out_rows[1:]:
        lines.append("| " + " | ".join(r) + " |")
    return "\n".join(lines)

# ---- Main streaming parser: emit markdown in document order ----------------
BLOCK_OPEN = {
    "h1": "\n\n# ", "h2": "\n\n## ", "h3": "\n\n### ",
    "h4": "\n\n#### ", "h5": "\n\n##### ", "h6": "\n\n###### ",
    "p": "\n\n", "blockquote": "\n\n> ", "figcaption": "\n\n*",
}

class DocParser(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.out = []
        self.skip_depth = 0       # inside script/style/table handled separately
        self.in_table = 0
        self.table_buf = []
        self.list_stack = []
        self.headings = 0
        self.tables = 0
        self.cur_close = []       # stack of closing markers
        self.in_figcaption = False
        self.suppress = 0         # inside elements we drop entirely
    def handle_starttag(self, tag, attrs):
        d = dict(attrs)
        cls = d.get("class", "")
        # drop nav/menu/social wrappers entirely
        if self.suppress:
            if tag in ("nav", "ul", "div", "footer", "form"):
                self.suppress += 1
            return
        if tag in ("nav", "footer") or any(k in cls for k in
            ("main-navigation", "site-header", "site-footer", "socials",
             "dropdown-menu", "menu-toggle", "ez-toc-widget", "sharedaddy",
             "comment-respond")):
            self.suppress = 1
            return
        if tag == "table":
            self.in_table += 1
            self.table_buf = [self.get_starttag_text()]
            return
        if self.in_table:
            self.table_buf.append(self.get_starttag_text())
            return
        if tag in ("script", "style", "svg", "noscript"):
            self.skip_depth += 1
            return
        if self.skip_depth:
            return
        if tag == "br":
            self.out.append("\n")
        elif tag in ("ul", "ol"):
            self.list_stack.append(tag)
            self.out.append("\n")
        elif tag == "li":
            indent = "  " * (len(self.list_stack) - 1) if self.list_stack else ""
            self.out.append("\n" + indent + "- ")
        elif tag in BLOCK_OPEN:
            self.out.append(BLOCK_OPEN[tag])
            if tag.startswith("h"):
                self.headings += 1
            if tag == "figcaption":
                self.in_figcaption = True
        elif tag == "img":
            a = d.get("alt", "")
            if a:
                self.out.append(f" [img: {a}] ")
    def handle_startendtag(self, tag, attrs):
        if tag == "br" and not self.in_table and not self.skip_depth and not self.suppress:
            self.out.append("\n")
        elif tag == "img":
            self.handle_starttag(tag, attrs)
    def handle_endtag(self, tag):
        if self.suppress:
            if tag in ("nav", "ul", "div", "footer", "form"):
                self.suppress -= 1
            elif tag in ("nav", "footer"):
                self.suppress = 0
            return
        if tag == "table" and self.in_table:
            self.table_buf.append("</table>")
            self.in_table -= 1
            if self.in_table == 0:
                md = render_table("".join(self.table_buf))
                if md:
                    self.tables += 1
                    self.out.append("\n\n" + md + "\n\n")
                self.table_buf = []
            return
        if self.in_table:
            self.table_buf.append(f"</{tag}>")
            return
        if tag in ("script", "style", "svg", "noscript"):
            if self.skip_depth:
                self.skip_depth -= 1
            return
        if self.skip_depth:
            return
        if tag in ("ul", "ol") and self.list_stack:
            self.list_stack.pop()
            self.out.append("\n")
        elif tag in ("p", "blockquote", "h1", "h2", "h3", "h4", "h5", "h6"):
            self.out.append("\n")
        elif tag == "figcaption":
            self.out.append("*\n")
            self.in_figcaption = False
    def handle_data(self, data):
        if self.suppress or self.skip_depth:
            return
        if self.in_table:
            # escape so it survives the second parse pass in render_table
            self.table_buf.append(data.replace("<", "&lt;").replace(">", "&gt;"))
            return
        self.out.append(data)
    def text(self):
        t = "".join(self.out)
        # collapse runs of spaces/tabs but keep newlines
        t = re.sub(r'[ \t]+', ' ', t)
        t = re.sub(r' *\n', '\n', t)
        t = re.sub(r'\n{3,}', '\n\n', t)
        return t.strip()

p = DocParser()
p.feed(region)
body = p.text()

with open(os.path.join(folder, "content.md"), "w", encoding="utf-8") as f:
    f.write(body + "\n")

with open(os.path.join(folder, "_imgurls.txt"), "w", encoding="utf-8") as f:
    for src, alt in img_urls:
        f.write(src + "\t" + alt + "\n")

print(f"CHARS={len(body)} TABLES={p.tables} HEADINGS={p.headings} IMGURLS={len(img_urls)}")
