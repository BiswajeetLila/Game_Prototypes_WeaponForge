# _meta — 05-reddit-neverness-performance

- **URL:** https://old.reddit.com/r/NevernessToEverness/comments/1t1g6na/performance_feedback/?limit=500
- **Fetch timestamp (UTC):** 2026-06-06T11:38:59Z
- **HTTP status:** 200
- **Byte size (raw.html):** 57397
- **Post type:** text/self post (1701-char selftext)
- **Comments extracted:** 1 (AutoModerator hold-for-review notice)
- **Images downloaded:** 0
- **content.md size:** 2431 bytes

## Anomalies / notes
- Thread is near-empty: post is held in mod queue (only an AutoModerator comment), so just 1 comment exists. Full thread captured.
- No embedded images (no i.redd.it / preview.redd.it / i.imgur.com media in post or comment).
- Selftext preserves original author typos/mixed-language tokens verbatim, e.g. Portuguese placeholder `[coloca a versão aqui]` left in the "Game Version" field.
- raw.html contained a non-UTF-8 byte (0x95) at offset ~629; parsed with errors='replace' — no observed content loss in extracted body text.
- No "load more comments" links present.
