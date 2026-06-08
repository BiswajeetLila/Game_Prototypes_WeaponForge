# _meta

- URL: https://app.sensortower.com/news-feed/honkai-star-rail-sees-biggest-revenue-spike-since-april-with-fatestay-night-collab/68686daf2afa9dfdb1b535fc
- Fetch UTC: 2026-06-06T11:39:20Z
- HTTP status: 200 (but content empty)
- raw.html bytes: 7059
- content.md chars: 1098
- images downloaded: 0
- Status: FAILED-GATED
- Anomalies:
  - Page is a client-side React/Knockout app (news_feed_application JS bundle). Server returns only an empty HTML shell; <body> has no article text.
  - Embedded st-user-data meta reports "is_signed_in":false — content is login-gated.
  - Project browser $B was NOT available in this environment (no 'B' command/alias), so JS rendering could not be performed.
  - Attempted JSON API fallbacks: /api/news_feed/<id> -> HTTP 404; news-feed/x/<id>.json -> HTTP 406. No accessible data endpoint.
  - Only verbatim content recoverable from the returned HTML: page <title> and site-wide meta description (both saved in content.md). No invented content.
