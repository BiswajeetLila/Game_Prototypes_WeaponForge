# _meta — 04-reddit-poco-mtk-8400u

- **URL:** https://old.reddit.com/r/PocoPhones/comments/1kmfyj0/if_you_ever_doubted_mtk_8400u/?limit=500
- **Fetch timestamp (UTC):** 2026-06-06T11:38:59Z
- **HTTP status:** 200
- **Byte size (raw.html):** 454806
- **Post type:** link/image post (no selftext)
- **Comments extracted:** 124
- **Images downloaded:** 9 (8 JPEG, 1 PNG; all user-posted comment screenshots from preview.redd.it)
- **content.md size:** 21342 bytes

## Anomalies / notes
- old.reddit rendered 124 `div.thing.comment` blocks; 121 unique `t1_` fullnames + ~3 deleted/removed comment shells. 20 `[deleted]` markers present in raw HTML. Deleted comments lack `data-type="comment"` (only 120 have it) but are still rendered as comment things — all preserved verbatim, deleted bodies shown as `[deleted/empty]`.
- No "load more comments" / morechildren links present — full thread captured in single fetch.
- 1 image skipped: the `og:image` social-share thumbnail (external-preview.redd.it, 140x62) — sub-threshold thumbnail, not thread content. Its URL also appears truncated/malformed in raw HTML (meta-tag parse artifact).
- All 9 real images returned HTTP 200, sizes 9KB–697KB. Smallest (9.jpeg, ~9KB) is above the 2KB skip threshold.
- raw.html contained occasional non-UTF-8 bytes; parsed with errors='replace' (no content loss in comment/post bodies observed).
- Comment threading preserved via nesting depth (indentation in content.md).
