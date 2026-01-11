# App Store Connect & Google Play Integration - Design Document

**Date:** 2025-01-11
**Status:** Approved
**Author:** Jerome + Claude

---

## Overview

Transform Keyrank into a complete app management tool by integrating App Store Connect and Google Play Console APIs.

### Phases

| Phase | Feature | Description |
|-------|---------|-------------|
| **Phase 1 (MVP)** | Reply to reviews | Connect store accounts, view and reply to reviews |
| **Phase 2** | Real analytics | Downloads, revenue, subscribers from connected accounts |
| **Phase 3** | Chat with your apps | AI-powered Q&A on all app data |

---

## Pricing Tiers

| | **Free** | **Starter** $9/mo | **Pro** $29/mo | **Agency** $99/mo |
|---|----------|-------------------|----------------|-------------------|
| Apps | 1 | 3 | 10 | 30 |
| Keywords | 5 | 30 | 150 | 750 |
| Reply reviews | ❌ | ✅ | ✅ | ✅ |
| Real analytics | ❌ | Basic | Full | Full + export |
| Chat AI | ❌ | 10 q/mo | 50 q/mo | Unlimited |
| Competitors | ❌ | ❌ | 3 | 15 |
| Alerts | 1 | 5 | 20 | Unlimited |
| Team members | 1 | 1 | 1 | 5 |

---

## Phase 1: Reply to Reviews

### Store Authentication

#### Apple App Store Connect

- **Method:** API Key (no OAuth available)
- **User provides:** `.p8` file + Key ID + Issuer ID
- **Backend:** Generate JWT (ES256), valid 20 min, auto-refresh
- **Required role:** App Manager or higher

**Endpoints:**
```
GET  /v1/apps/{id}/customerReviews          → Fetch reviews
POST /v1/customerReviewResponses            → Reply to review
```

#### Google Play Console

- **Method:** OAuth2
- **Flow:** User clicks "Connect" → Google consent screen → callback with token
- **Storage:** Refresh token for permanent access
- **Scope:** `androidpublisher`

**Endpoints:**
```
GET  /androidpublisher/v3/.../reviews       → Fetch reviews
POST /androidpublisher/v3/.../reviews:reply → Reply to review
```

### Credentials Storage

- Encryption: AES-256-GCM server-side
- Encryption key: Environment variable (not in DB)

**Table: `store_connections`**
```sql
- id
- user_id
- platform (ios/android)
- credentials (encrypted)
- connected_at
- last_sync_at
- status (active/expired/revoked)
```

### Reviews UI

#### Two Views

1. **Global Inbox** (`/reviews`) - All reviews across all apps
2. **Per-app reviews** (`/apps/{id}/reviews`) - Filtered to single app

#### Filters

| Filter | Options |
|--------|---------|
| Status | Unanswered, Answered, All |
| Rating | 1★, 2★, 3★, 4★, 5★ |
| Sentiment | Positive, Negative, Neutral |
| Store | iOS, Android, All |
| Country | Country list |
| Period | 7d, 30d, 90d, Custom |
| Search | Full-text in content |

#### Reply Interface

- Display review with metadata (author, country, date, rating)
- AI suggestion box with "Use this" button
- Text area for custom/edited response
- Send button

### AI Response Suggestions

#### Custom Tone per App

**Table: `app_voice_settings`**
```sql
- app_id
- tone_description (text)  -- e.g., "Friendly, casual, we use emojis"
- language (default: auto-detect)
- signature (optional)     -- e.g., "- The Keyrank Team"
```

The AI prompt includes this context to generate brand-consistent responses.

### Synchronization Strategy

| Type | Frequency | Trigger |
|------|-----------|---------|
| Full sync | Every 12h | CRON |
| Alert sync | Every 1h | CRON (apps with active review alerts) |
| Manual sync | On demand | "Refresh" button |

#### Sync Flow

```
CRON Job (Laravel Scheduler)
    │
    ├─▶ Fetch new reviews since last_sync_at
    ├─▶ Store in DB (reviews table)
    ├─▶ Analyze sentiment (async AI)
    ├─▶ Check matching alert_rules
    │       └─▶ If match → create notification + Firebase push
    └─▶ Update last_sync_at
```

**Table: `reviews`**
```sql
- id
- app_id
- store (ios/android)
- store_review_id
- author_name
- rating (1-5)
- title
- content
- country_code
- review_date
- sentiment (positive/negative/neutral)
- our_response (nullable)
- responded_at (nullable)
- created_at
- updated_at
```

### New Alert Templates

- **New negative review** (1-2★)
- **New review** (all ratings)
- **Review containing keyword** (e.g., "crash", "bug")

---

## Phase 2: Real Analytics Dashboard

### Data Retrieved

| Metric | iOS Source | Android Source |
|--------|------------|----------------|
| Downloads | Sales Reports API | Stats API |
| Revenue | Sales Reports API | Stats API |
| Subscribers | Subscription API | Subscription API |
| Proceeds (net) | Finance Reports | Finance Reports |

### Dashboard UI (`/apps/{id}/analytics`)

**KPI Cards:**
- Downloads (with % change vs previous period)
- Revenue (with % change)
- Subscribers (with % change)

**Charts:**
- Downloads over time (line chart with dotted comparison line)
- Revenue by country (world map + bar chart)
- Ratings breakdown (horizontal bar by star)
- Sentiment indicator (barcode style visualization)

### Database Tables

**Table: `app_analytics`** (daily sync)
```sql
- id
- app_id
- date
- downloads
- revenue
- proceeds
- subscribers_gained
- subscribers_lost
- country_code
```

**Table: `app_analytics_summary`** (computed)
```sql
- app_id
- period (7d/30d/90d)
- total_downloads
- total_revenue
- downloads_change_pct
- revenue_change_pct
```

### Sync Schedule

- Daily CRON at 6 AM
- Apple Sales Reports have 24-48h delay
- Display disclaimer "Data as of D-1 or D-2"

---

## Phase 3: Chat with Your Apps

### Data Sources

| Source | Example Questions |
|--------|-------------------|
| Reviews | "What bugs are mentioned most?" |
| Keywords | "What keywords am I missing vs competitors?" |
| Rankings | "Why did my ranking drop this week?" |
| Analytics (if connected) | "Which country generates the most revenue?" |

### Architecture (RAG)

```
User question
    │
    ▼
┌─────────────────────┐
│ Query analyzer      │ → Determine which data to fetch
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ Data retrieval      │ → Fetch relevant reviews, rankings, etc.
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ LLM (Claude/GPT)    │ → Generate response with context
└─────────────────────┘
    │
    ▼
Formatted response
```

### Chat UI

- Accessible per app (`/apps/{id}/chat`) or global (`/chat`)
- Conversation history saved
- Suggested questions: "Try: What are my weak points according to reviews?"

### Usage Limits

| Tier | Questions/month |
|------|-----------------|
| Free | 0 |
| Starter $9 | 10 |
| Pro $29 | 50 |
| Agency $99 | Unlimited |

**Table: `chat_usage`**
```sql
- user_id
- month (YYYY-MM)
- questions_count
```

---

## Architecture Overview

```
┌─────────────────┐     ┌─────────────────┐     ┌──────────────────┐
│  Flutter App    │────▶│  Laravel API    │────▶│  Apple/Google    │
│  (iOS/Android/  │     │  (encrypted     │     │  Store APIs      │
│   Web/Desktop)  │◀────│   credentials)  │◀────│                  │
└─────────────────┘     └─────────────────┘     └──────────────────┘
                              │
                              ▼
                        ┌─────────────────┐
                        │  DB + Redis     │
                        │  (reviews,      │
                        │   credentials,  │
                        │   analytics)    │
                        └─────────────────┘
```

### Security

- All store API calls go through Laravel backend (never from client)
- Credentials encrypted with AES-256-GCM
- Encryption key in environment variable
- JWT tokens for Apple API auto-refreshed

---

## Next Steps

1. Create implementation plan for Phase 1 (MVP)
2. Set up git worktree for isolated development
3. Implement store connection flows
4. Build reviews inbox UI
5. Add AI suggestion feature
6. Deploy and test
