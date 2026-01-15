# Keyrank V1 Data Prerequisites (ASA + Proxy)

## 1. Goals
- Deliver reliable keyword search volume (SV) and trend (TR) for tracked keywords.
- Keep costs bounded while expanding coverage beyond tracked keywords.
- Provide a clean competitor signal (top 10 alerts, top 20 analysis).
- Preserve a fallback path if ASA data is unavailable for some keywords.

## 2. Current State (from code)
- Schedules in `api/routes/console.php` cover rankings, ratings, reviews, top charts, metadata, ASO snapshots.
- Tables exist for keyword popularity and aggregates:
  - `keywords.popularity` and `keywords.popularity_updated_at`
  - `keyword_popularity_history`, `keyword_popularity_aggregates`
- No ASA service or collector exists yet.
- Rankings are only for tracked keywords (no untracked sampling).
- Competitors are stored as JSON in `tracked_keywords.top_competitors` (no history table).

## 3. Gaps vs V1 Spec
- Missing Search Volume (SV) and Trend (TR) data pipeline.
- No weekly collection for untracked keywords.
- Competitors lack history and queryable structure.
- Review insights are rule-based only (AI jobs are disabled).

## 4. Action Plan

### Step 1: ASA Popularity Collector (daily)
- Create `AppleSearchAdsService` to call Search Popularity API.
- Create `KeywordPopularityCollector` to:
  - Fetch popularity for tracked keywords (daily).
  - Fetch popularity for top suggestions (weekly).
  - Upsert into `keyword_popularity_history` and update `keywords.popularity`.
- Add schedule in `api/routes/console.php` (daily at 03:00).
- Cap requests with batching and cache (skip if updated < 24h).
- Add proxy fallback for SV (autocomplete frequency) when ASA returns empty.

### Step 2: Trend Calculation (nightly or API)
- Compute TR 7d vs 30d using `keyword_popularity_history`.
- If history missing: TR=50 (neutral) and badge "trend unavailable".
- Option A: compute on read in API.
- Option B: nightly job to store trend in a derived table.

### Step 3: Untracked Keyword Sampling (weekly)
- Weekly job to sample untracked keywords from:
  - Search suggestions (autocomplete)
  - Top charts categories
- Limit per app and per country (e.g., 50-200 keywords/app/week).
- Store as `keywords` with `source='suggestion'`.

### Step 4: Competitor History Table
- Create `keyword_competitors` table with:
  - app_id, keyword_id, competitor_app_id, country, rank, recorded_at
- Populate during `RankingsCollector` using top 10/20 search results.
- Retention:
  - Top 10: 90 days
  - Top 20: 30 days

### Step 5: Reviews Insights (non-AI V1)
- Add rule-based metrics:
  - Rating dip (7d vs 30d)
  - Review spike (volume threshold)
- Optional AI enrichment later (jobs currently disabled).

### Step 6: Countries Alignment
- Set default list to FR/US/UK/DE/ES/IT in config.
- Keep extensible for future expansion.

## 5. Scope Decisions
- ASA is the primary SV source, proxy used only when ASA returns empty/denied.
- Competitors:
  - Top 10 for alerting (signal > noise)
  - Top 20 for analysis (dashboard context)
- Coverage:
  - Daily for tracked keywords
  - Weekly sampling for untracked keywords

## 6. Proxy SV Fallback (if ASA not available)
Proxy SV = weighted signal from:
- Autocomplete frequency (SearchSuggestCollector)
- Top charts name matches (TopChartsCollector + app names)
- Search density from tracked keywords (competition count)

Use only when ASA score missing. Mark as "estimated".

## 7. Work Items (concrete)
- [ ] Add `AppleSearchAdsService` (auth + request signing).
- [ ] Add `KeywordPopularityCollector` + schedule.
- [ ] Add `asa:health-check` command for quick ASA validation.
- [ ] Add API endpoint for trend (or nightly job).
- [ ] Add `keyword_competitors` migration + model.
- [ ] Update `RankingsCollector` to persist competitors.
- [ ] Add config defaults for countries list.

## 8. Open Questions
- ASA quota limits and max batch size per request.
- Preferred trend calculation (on-read vs nightly job).
- Retention policy for popularity history beyond 12 months.
