# _meta — Sensor Tower HSR metrics

- Source: Sensor Tower MCP (server 6b3af0bd…). NOT scraped HTML — structured API pulls used because the 3 dashboard URLs are login-gated interactive dashboards (per user decision: "Use Sensor Tower MCP tools").
- Fetch timestamp (UTC): 2026-06-06
- Game: Honkai: Star Rail (unified app 63e5633fded9c9175b7fca1e)
- Dashboard URLs covered:
  - app.sensortower.com/overview/1599719154?os=ios&country=AU&measure=revenue&granularity=daily (window 2026-04-24..2026-05-23)
  - app.sensortower.com/overview/63e5633fded9c9175b7fca1e
  - app.sensortower.com/overview/com.HoYoverse.hkrpgoversea?os=android&country=IT&measure=revenue&granularity=daily (window 2026-04-23..2026-05-22)
- MCP calls made:
  1. app_metadata os=ios id=1599719154 (country US)
  2. app_metadata os=android id=com.HoYoverse.hkrpgoversea (country US)
  3. unified_apps android→unified
  4. download_revenue_estimates os=unified id=63e5633f… monthly 2023-04-01..2026-05-31 (per-country raw → raw/worldwide_monthly_revenue_downloads_BY_COUNTRY.raw.json; aggregated → worldwide_monthly_revenue_downloads.json)
  5. download_revenue_estimates os=unified country=AU daily 2026-04-24..2026-05-23 (raw/AU_daily…json)
  6. download_revenue_estimates os=android country=IT daily 2026-04-23..2026-05-22 (raw/IT_daily…json)
  7. active_users os=unified month 2025-06-01..2026-05-31 (per-country raw → raw/active_users_monthly_BY_COUNTRY.raw.json; aggregated → worldwide_monthly_active_users.json)
  8. retention os=ios id=1599719154 monthly 2026-03-01..2026-05-31 (app_data empty; baseline only)
- Files:
  - content.md — human-readable tables (all genuine Sensor Tower estimates)
  - worldwide_monthly_revenue_downloads.json — aggregated WW monthly
  - worldwide_monthly_active_users.json — aggregated WW monthly MAU
  - raw/ — exact MCP payloads (per-country, daily windows)
- Caveats: All figures are Sensor Tower ESTIMATES (modeled), not actuals. Revenue is gross consumer spend (store fees not deducted). China iOS/3rd-party Android stores not fully captured by Sensor Tower → true global totals (esp. China) are higher than shown.
- retention baseline_data (iOS category baseline, day-N retention fraction, index 0 = day1):
  [0.0307,0.021,0.0173,0.0153,0.0142,0.0133,0.0125,0.0115,0.0108,0.01,0.0096,0.0095,0.0094,0.0089,0.0086,0.0083,0.0081,0.0081,0.008,0.0079,0.0078,0.0075,0.0073,0.007,0.007,0.0067,0.0068,0.0069,0.0067,0.0065,0.0063,0.0063,0.0064,0.0063,0.0062,0.0059,0.0059,0.0059,0.0055,0.0056,0.0056,0.0056,0.0055,0.0053,0.0054,0.0053,0.0054,0.0053,0.0051,0.0049,0.005,0.005,0.005,0.0051,0.0053,0.0049,0.0048,0.0049,0.0048,0.0048,0.0046,0.0046,0.0047,0.0047,0.0047,0.0047,0.0044,0.0045,0.0045,0.0045,0.0042,0.0043,0.0043,0.0043,0.0043,0.0045,0.0044,0.004,0.0038,0.0041,0.0042,0.0041,0.0042,0.0042,0.0042,0.0041,0.0043,0.0042,0.0041,0.004]
