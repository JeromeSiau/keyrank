# Phase 2: Real Analytics Dashboard - Design Document

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Display real downloads, revenue, and subscriber data from connected App Store Connect and Google Play accounts.

**Architecture:** Extend Phase 1's store connection system to also fetch sales/analytics data via CRON jobs and display in a new analytics dashboard.

**Tech Stack:** Same as Phase 1 (Laravel, Flutter/Riverpod, FL Chart for visualizations)

**Prerequisite:** Phase 1 must be completed first (store connections infrastructure).

---

## Features to Implement

### 1. Data Collection

**Apple App Store Connect - Sales Reports API:**
```
GET /v1/salesReports
- reportType: SALES, SUBSCRIPTION, SUBSCRIBER
- reportSubType: SUMMARY, DETAILED
- frequency: DAILY, WEEKLY, MONTHLY
```

**Google Play Developer API:**
```
GET /androidpublisher/v3/applications/{packageName}/reports
- Sales reports
- Subscription reports
- Financial reports
```

### 2. Database Tables

**Table: `app_analytics`** (daily data)
```sql
- id
- app_id
- date
- country_code
- downloads (integer)
- updates (integer)
- revenue (decimal 10,2)
- proceeds (decimal 10,2) -- after Apple/Google cut
- refunds (decimal 10,2)
- subscribers_new (integer)
- subscribers_cancelled (integer)
- subscribers_active (integer)
- created_at
- updated_at

INDEX: (app_id, date)
INDEX: (app_id, country_code, date)
```

**Table: `app_analytics_summary`** (pre-computed for performance)
```sql
- id
- app_id
- period (7d, 30d, 90d, ytd, all)
- total_downloads
- total_revenue
- total_proceeds
- downloads_change_pct
- revenue_change_pct
- computed_at
```

### 3. CRON Jobs

| Job | Schedule | Description |
|-----|----------|-------------|
| `analytics:sync-daily` | 6:00 AM | Fetch yesterday's data from stores |
| `analytics:compute-summaries` | 6:30 AM | Recompute period summaries |

**Note:** Apple Sales Reports have 24-48h delay. Display disclaimer in UI.

### 4. API Endpoints

```
GET  /apps/{app}/analytics                 → Current period summary
GET  /apps/{app}/analytics/downloads       → Downloads over time
GET  /apps/{app}/analytics/revenue         → Revenue over time
GET  /apps/{app}/analytics/subscribers     → Subscriber metrics
GET  /apps/{app}/analytics/countries       → Breakdown by country
GET  /apps/{app}/analytics/export          → CSV export (Agency tier)
```

### 5. Flutter Dashboard UI

**KPI Cards:**
- Downloads (with % change vs previous period)
- Revenue (with % change)
- Proceeds (net after store cut)
- Active Subscribers (with % change)

**Charts:**
- Line chart: Downloads over time (with dotted comparison to previous period)
- Line chart: Revenue over time
- Bar chart: Revenue by country (top 5)
- World map: Downloads distribution

**Period Selector:**
- 7 days, 30 days, 90 days, YTD, All time

### 6. Pricing Gates

| Feature | Starter $9 | Pro $29 | Agency $99 |
|---------|------------|---------|------------|
| Basic analytics | ✅ (downloads only) | ✅ | ✅ |
| Revenue data | ❌ | ✅ | ✅ |
| Subscriber metrics | ❌ | ✅ | ✅ |
| Country breakdown | ❌ | ✅ | ✅ |
| CSV Export | ❌ | ❌ | ✅ |
| Historical data | 30 days | 1 year | 2 years |

---

## Implementation Tasks (High Level)

### Backend (Laravel)

1. Create `app_analytics` migration
2. Create `app_analytics_summary` migration
3. Create `AppAnalytics` model
4. Extend `AppStoreConnectService` with sales reports
5. Extend `GooglePlayDeveloperService` with sales reports
6. Create `AnalyticsSyncService` for data processing
7. Create `analytics:sync-daily` command
8. Create `analytics:compute-summaries` command
9. Create `AnalyticsController` with endpoints
10. Add routes

### Frontend (Flutter)

11. Create `AppAnalytics` model
12. Create `AnalyticsRepository`
13. Create `AnalyticsProvider`
14. Create `AppAnalyticsScreen` with KPIs and charts
15. Create chart widgets (downloads, revenue, countries)
16. Add period selector
17. Add export button (Agency tier)
18. Add to app navigation
19. Add localization strings

---

## Estimated Effort

- Backend: ~15 tasks
- Frontend: ~10 tasks
- Total: ~25 tasks

**Dependencies:**
- Phase 1 completed (store connections)
- FL Chart package (already in project)
- Country map package (may need to add)

---

## Notes

- Consider caching summaries in Redis for dashboard performance
- Apple data is delayed 24-48h - always show "Data as of [date]"
- Google data is near real-time but can have discrepancies
- Revenue data is sensitive - ensure proper access control
