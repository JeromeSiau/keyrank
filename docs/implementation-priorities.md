# Implementation Priorities (Detailed)

This document translates the prioritized roadmap into concrete, buildable steps.
Priority values use a 1–10 scale (10 = highest business impact).

---

## 1) Opportunity Engine (Value 9.5)

### Goal
Provide an “opportunity score” that tells users what to target next (apps/keywords), with clear reasons.

### Deliverables
- Opportunity score per app/country/period.
- Top reasons (signals) explaining the score.
- API endpoints for score retrieval.
- Flutter UI panel for the opportunity feed.

### Data Model
- `opportunity_scores`
  - `id`
  - `app_id`
  - `country`
  - `period` (e.g. `7d`, `30d`)
  - `score` (0–100)
  - `signals` (json)
  - `computed_at`
- Optional: `opportunity_signals` for per-signal history and analytics.

### Signals (MVP)
- `rank_delta_7d`
- `review_velocity_7d`
- `rating_delta_30d`
- `keyword_gap`
- `price_delta`

### Backend Steps
1. Create migration for `opportunity_scores`.
2. Add `OpportunityScore` model.
3. Implement `OpportunityScoreJob` that computes signals and scores.
4. Normalize signals to 0–100 and weight them.
5. Store `signals` in JSON and `score` as a numeric field.

### API
- `GET /api/apps/{id}/opportunities?country=US&period=30d`
- `GET /api/opportunities/top?country=US&limit=50`

### Flutter UI
- New feature module: `app/lib/features/opportunities/`.
- Cards: score + top 3 signals + CTA to “track keyword/app”.

### Testing
- Unit tests for normalization and scoring.
- Feature tests for endpoints + sorting.

### Metrics
- CTR on suggestions.
- Activation rate for “track keyword/app”.

---

## 2) Data Freshness + SLA per Source (Value 9.0)

### Goal
Reduce costs and ensure data freshness by fetching only when stale.

### Deliverables
- Per-source SLA filtering in collectors.
- Freshness timestamps on key entities.
- Optional admin endpoint for freshness diagnostics.

### Data Model
- Ensure presence of timestamps:
  - `rankings_fetched_at`
  - `reviews_fetched_at`
  - `ratings_fetched_at`
  - `metadata_checked_at`
- Optional: `data_freshness` table for aggregated stats per source/country.

### Backend Steps
1. Define SLA per source (e.g. rankings 2h, reviews 6h).
2. Update `getItems()` in each collector to only fetch stale items.
3. Update timestamps after successful fetch.
4. Add guard in `BaseCollector` to skip fresh items.

### API
- `GET /api/health/data-freshness` (admin-only)

### Flutter UI
- “Last updated” badge for data-heavy screens.

### Testing
- Unit tests for SLA cutoff logic.
- Feature test for freshness API.

---

## 3) Keyword Intelligence (Value 8.5)

### Goal
Surface actionable keyword suggestions with quality scoring.

### Deliverables
- Scored keyword suggestions per app.
- New sources: suggest, co-occurrence, top charts.
- UI list with badges (volume/competition/intent).

### Data Model
- `keyword_suggestions`
  - `id`, `app_id`, `keyword`, `source`
  - `score`, `volume`, `competition`, `intent`
  - `created_at`

### Backend Steps
1. Aggregate sources: search suggest + top charts + ranking co-occurrence.
2. Compute `score` = weighted volume/competition/intent.
3. Add `KeywordSuggestion` model + endpoints.

### API
- `GET /api/apps/{id}/keywords/suggestions`
- `POST /api/keywords/track`

### Flutter UI
- Suggestions list with filters and quick “track” action.

### Testing
- Unit test scoring logic.
- Feature tests for API filtering.

---

## 4) Configurable Alerts (Value 8.0)

### Goal
Increase retention with user-defined alert rules and notifications.

### Deliverables
- Alert rule builder.
- Alert evaluation job.
- Alert events history.

### Data Model
- `alerts`
  - `id`, `user_id`, `type`, `scope`, `params`, `is_active`
- `alert_events`
  - `id`, `alert_id`, `triggered_at`, `payload`

### Backend Steps
1. CRUD endpoints for alerts.
2. `AlertEvaluatorJob` runs hourly/daily.
3. Emit `alert_events` and send push/email.

### Alert Types (MVP)
- `rank_drop`
- `rating_drop`
- `review_spike`
- `price_change`

### Flutter UI
- Implement pickers in:
  - `app/lib/features/alerts/presentation/widgets/builder_steps/scope_step.dart`
- Builder steps: scope → condition → threshold → channels.

### Testing
- Unit tests for rule evaluation.
- Feature tests for CRUD and trigger.

---

## 5) Related Apps Graph (Value 7.5)

### Goal
Enable discovery and competitor mapping via a scored graph.

### Deliverables
- App relationship edges with type + score.
- Related/competitor API endpoints.
- UI section for related apps.

### Data Model
- `app_relations`
  - `from_app_id`, `to_app_id`, `type`, `score`, `source`, `computed_at`
  - Unique: `(from_app_id, to_app_id, type, source)`

### Sources
- Top charts adjacency (same category + rank proximity)
- Keyword overlap (shared keywords)
- Same developer (migrate current discovery)

### Backend Steps
1. Job `AppRelationsJob` (daily).
2. Merge sources → compute scores → upsert edges.

### API
- `GET /api/apps/{id}/related?type=all`
- `GET /api/apps/{id}/competitors`

### Flutter UI
- Related apps carousel + “why this is related”.

---

## 6) Collector Micro-Jobs + Backoff (Value 7.0)

### Goal
Improve scale and resilience of background data collection.

### Deliverables
- Batch processing jobs.
- Backoff strategy for rate limits.
- Per-service rate limit controls.

### Backend Steps
1. Update `BaseCollector` to chunk items and dispatch batch jobs.
2. Introduce `ProcessCollectorBatchJob`.
3. Implement exponential backoff on 429/503.
4. Separate rate limits per service.

### Testing
- Simulate 429 → ensure retry with backoff.

---

## 7) Time-Series Partitioning + Aggregates (Value 6.5)

### Goal
Keep database performance stable as data grows.

### Deliverables
- Partitioned tables.
- Daily/weekly/monthly aggregates.

### Backend Steps
1. Partition `app_rankings`, `app_reviews`, `app_ratings` by month.
2. Create aggregate tables and scheduled rollups.
3. Update queries to use aggregates where possible.

---

## 8) Observability + Quotas (Value 6.0)

### Goal
Monitor system health and avoid runaway costs.

### Deliverables
- Job metrics dashboard.
- Quota tracking per data source.

### Backend Steps
1. Extend `JobExecution` with API call counts + cost.
2. Admin endpoint for monitoring.
3. Alerts for quota thresholds.

---

## Suggested Phasing (Optional)
- Phase 1: Opportunity Engine + Freshness (1–2 sprints)
- Phase 2: Keyword Intelligence + Alerts
- Phase 3: Related Apps + Collector refactor
- Phase 4: Time-series partitions + Observability
