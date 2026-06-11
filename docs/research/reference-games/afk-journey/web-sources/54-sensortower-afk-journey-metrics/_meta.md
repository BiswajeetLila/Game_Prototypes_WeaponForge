# _meta.md — Sensor Tower: AFK Journey Metrics

**Extracted:** 2026-06-11
**Source:** Sensor Tower MCP API (`mcp__6b3af0bd-11b2-4b6a-aeae-b86eb0c40485`)
**Tool schemas loaded via:** ToolSearch

---

## App IDs

| Platform | ID |
|---|---|
| iOS App Store | `1628970855` |
| Android Google Play | `com.farlightgames.igame.gp` |

Confirmed via `search_entities` (os=ios, term="AFK Journey") and (os=android, term="AFK Journey").

---

## MCP Calls Made

### 1. search_entities (iOS)
- **Tool:** `mcp__6b3af0bd-11b2-4b6a-aeae-b86eb0c40485__search_entities`
- **Params:** `{ "os": "ios", "entity_type": "app", "term": "AFK Journey", "limit": 5 }`
- **Result:** First result = `app_id: 1628970855`, name "AFK Journey", publisher "Farlight Games", global_rating_count 274310, release 2024-03-27. Usage count: 76.

### 2. search_entities (Android)
- **Tool:** `mcp__6b3af0bd-11b2-4b6a-aeae-b86eb0c40485__search_entities`
- **Params:** `{ "os": "android", "entity_type": "app", "term": "AFK Journey", "limit": 5 }`
- **Result:** First result = `app_id: "com.farlightgames.igame.gp"`, name "AFK Journey", publisher "FARLIGHT", global_rating_count 296381, release 2024-03-22. Usage count: 78.

### 3. app_metadata (iOS)
- **Tool:** `mcp__6b3af0bd-11b2-4b6a-aeae-b86eb0c40485__app_metadata`
- **Params:** `{ "os": "ios", "app_ids": "1628970855" }`
- **Result:** Full metadata. Rating 4.82974, 274310 global ratings, 72801 US ratings, version 1.7.1.1, last-month downloads ~100k, last-month revenue ~$1M. Usage count: 79.

### 4. app_metadata (Android)
- **Tool:** `mcp__6b3af0bd-11b2-4b6a-aeae-b86eb0c40485__app_metadata`
- **Params:** `{ "os": "android", "app_ids": "com.farlightgames.igame.gp" }`
- **Result:** Full metadata. Rating 4.551099, 296381 global ratings, version 1.7.11, last-month downloads ~100k, last-month revenue ~$800k. Usage count: 80.

### 5. ratings (iOS, US, 2024-03-01 to 2026-06-01)
- **Tool:** `mcp__6b3af0bd-11b2-4b6a-aeae-b86eb0c40485__ratings`
- **Params:** `{ "os": "ios", "app_id": "1628970855", "country": "US", "start_date": "2024-03-01", "end_date": "2026-06-01" }`
- **Result:** Daily breakdown [1star,2star,3star,4star,5star] + average + total for US, from 2024-03-28 to 2026-06-01. Output saved to file (285,280 chars / 16,724 lines). Usage count: 81.

### 6. ratings (Android, US, 2024-03-01 to 2026-06-01)
- **Tool:** `mcp__6b3af0bd-11b2-4b6a-aeae-b86eb0c40485__ratings`
- **Params:** `{ "os": "android", "app_id": "com.farlightgames.igame.gp", "country": "US", "start_date": "2024-03-01", "end_date": "2026-06-01" }`
- **Result:** Daily breakdown for US from 2024-03-27 to 2026-06-01. Output saved to file (213,931 chars / 11,166 lines). Usage count: 82.

### 7. download_revenue_estimates (unified, 2024-03 to 2026-05) — EMPTY
- **Tool:** `mcp__6b3af0bd-11b2-4b6a-aeae-b86eb0c40485__download_revenue_estimates`
- **Params:** `{ "os": "unified", "app_ids": "1628970855,com.farlightgames.igame.gp", "date_granularity": "monthly", "start_date": "2024-03-01", "end_date": "2026-05-01" }`
- **Result:** `{ "data": [] }` — unified cross-platform query returned no data. Usage count: 83.

### 8. active_users (unified) — EMPTY
- **Tool:** `mcp__6b3af0bd-11b2-4b6a-aeae-b86eb0c40485__active_users`
- **Params:** `{ "os": "unified", "app_ids": "1628970855,com.farlightgames.igame.gp", "time_period": "month", "start_date": "2024-03-01", "end_date": "2026-05-01" }`
- **Result:** `{ "data": [] }` — unified query returned no data. Usage count: 84.

### 9. download_revenue_estimates (iOS, monthly, 2024-03 to 2026-05)
- **Tool:** `mcp__6b3af0bd-11b2-4b6a-aeae-b86eb0c40485__download_revenue_estimates`
- **Params:** `{ "os": "ios", "app_ids": "1628970855", "date_granularity": "monthly", "start_date": "2024-03-01", "end_date": "2026-05-01" }`
- **Result:** Per-country monthly records. Fields: `aid` (app_id), `cc` (country), `d` (date), `au` (app units/downloads), `ar` (app revenue cents), `iu` (iap units), `ir` (iap revenue cents). 27 monthly buckets, all countries. Output saved to file (416,469 bytes). Usage count: (from result file).

### 10. download_revenue_estimates (Android, monthly, 2024-03 to 2026-05)
- **Tool:** `mcp__6b3af0bd-11b2-4b6a-aeae-b86eb0c40485__download_revenue_estimates`
- **Params:** `{ "os": "android", "app_ids": "com.farlightgames.igame.gp", "date_granularity": "monthly", "start_date": "2024-03-01", "end_date": "2026-05-01" }`
- **Result:** Per-country monthly records. Fields: `aid`, `c` (country), `d` (date), `u` (downloads), `r` (revenue cents). 27 monthly buckets. Output saved to file (404,202 bytes). Usage count: (from result file).

### 11. active_users (iOS, monthly, 2024-03 to 2026-05)
- **Tool:** `mcp__6b3af0bd-11b2-4b6a-aeae-b86eb0c40485__active_users`
- **Params:** `{ "os": "ios", "app_ids": "1628970855", "time_period": "month", "start_date": "2024-03-01", "end_date": "2026-05-01" }`
- **Result:** Per-country monthly MAU. Fields: `app_id`, `country`, `date`, `ipad_users`, `iphone_users`. 27 monthly buckets. Output saved to file (321,569 bytes).

### 12. active_users (Android, monthly, 2024-03 to 2026-05)
- **Tool:** `mcp__6b3af0bd-11b2-4b6a-aeae-b86eb0c40485__active_users`
- **Params:** `{ "os": "android", "app_ids": "com.farlightgames.igame.gp", "time_period": "month", "start_date": "2024-03-01", "end_date": "2026-05-01" }`
- **Result:** Per-country monthly MAU. Fields: `app_id`, `country`, `date`, `users`. 27 monthly buckets. Output saved to file (290,364 bytes).

---

## Field Key

| Field | Meaning | Units |
|---|---|---|
| iOS `au` | App units (downloads) | count |
| iOS `ar` | App revenue (base price, usually 0 since free) | USD cents |
| iOS `iu` | In-app purchase units | count |
| iOS `ir` | In-app purchase revenue | USD cents |
| Android `u` | Downloads | count |
| Android `r` | Revenue (all IAP) | USD cents |
| Ratings `breakdown` | [1star, 2star, 3star, 4star, 5star] cumulative count | count |

---

## Data Coverage

- **Date range:** 2024-03-01 (launch) through 2026-05-01 (latest full month)
- **Geo scope:** All countries where app is active
- **Ratings:** US only, daily granularity
- **Active users:** All countries, monthly granularity
- **Downloads/Revenue:** All countries, monthly granularity
