# Android Support Design

## Overview

Add Google Play Store support to the app ranking tracker, enabling users to track both iOS and Android apps in a unified dashboard. This positions the SaaS as a premium alternative to iOS-only competitors like TryAstro.

## Key Decisions

| Aspect | Decision | Rationale |
|--------|----------|-----------|
| Data source | Scraping (not paid API) | Cost control for SaaS margins |
| Scraping stack | Crawlee + google-play-scraper | Robust, battle-tested, Node.js |
| Architecture | Separate micro-service | Isolation, independent scaling |
| Data model | Unified app | Better UX, single dashboard |
| Proxy strategy | Webshare.io → IPRoyal | Free for testing, budget for prod |

---

## Architecture

### Current State

```
Flutter App → Laravel API → iTunes API (free, public)
```

### Target State

```
                                    ┌─────────────────┐
                                    │   iTunes API    │
                                    └────────▲────────┘
                                             │
┌─────────────┐      ┌─────────────┐         │
│ Flutter App │ ───► │ Laravel API │─────────┤
└─────────────┘      └──────┬──────┘         │
                            │                │
                            │ HTTP           │
                            ▼                │
                     ┌─────────────┐  ┌──────▼────────┐
                     │   Node.js   │  │ Google Play   │
                     │  Crawlee    │──│   (scraped)   │
                     │  Service    │  └───────────────┘
                     └─────────────┘
```

### Node.js Micro-service

**Tech stack:**
- Node.js + Express
- Crawlee (queue management, retry logic, proxy rotation)
- google-play-scraper (Play Store parsing)

**Endpoints:**
```
POST /search        - Search apps by keyword
GET  /app/:id       - Get app details
GET  /app/:id/reviews - Get app reviews
POST /rankings      - Batch keyword rankings check
GET  /health        - Health check
```

**Deployment:** Docker container, same server or separate (scale later)

---

## Data Model Changes

### Apps Table

```sql
ALTER TABLE apps ADD COLUMN google_play_id VARCHAR(255) NULL;
ALTER TABLE apps ADD COLUMN google_play_icon_url VARCHAR(500) NULL;
ALTER TABLE apps ADD COLUMN google_ratings_fetched_at TIMESTAMP NULL;
ALTER TABLE apps ADD COLUMN google_reviews_fetched_at TIMESTAMP NULL;
```

### App Ratings Table

```sql
ALTER TABLE app_ratings ADD COLUMN platform ENUM('ios', 'android') DEFAULT 'ios';
```

### App Reviews Table

```sql
ALTER TABLE app_reviews ADD COLUMN platform ENUM('ios', 'android') DEFAULT 'ios';
```

### App Rankings Table

```sql
ALTER TABLE app_rankings ADD COLUMN platform ENUM('ios', 'android') DEFAULT 'ios';
```

### Keywords Table

```sql
-- Keywords can be platform-specific or shared
ALTER TABLE tracked_keywords ADD COLUMN platform ENUM('ios', 'android', 'both') DEFAULT 'both';
```

---

## Refresh Strategy

### Frequency

| Data Type | Frequency | Trigger |
|-----------|-----------|---------|
| Rankings | 1×/day | Cron + on-demand with 24h cache |
| Ratings | 1×/day | Cron + on-demand with 24h cache |
| Reviews | 1×/day | Cron + on-demand with 24h cache |
| App details | 1×/week | On-demand with 7d cache |

### Scheduling

**Hybrid approach (A+B):**
1. **Cron nocturne (2h-6h):** Batch refresh for active paying users
2. **Rolling refresh:** Spread requests across 24h to avoid spikes
3. **On-demand:** Fetch if user visits and cache expired

### Align iOS

Current iOS implementation uses similar pattern. Ensure both platforms:
- Use same staleness thresholds
- Share the same cron job logic
- Report refresh status consistently in UI

---

## Proxy Strategy

### Development/Testing

**Webshare.io (free tier)**
- 10 proxies
- Sufficient for development and early beta
- URL: https://www.webshare.io/

### Production

**IPRoyal (residential)**
- ~$5/GB
- Residential IPs (harder to detect)
- URL: https://iproyal.com/
- Estimated cost: $30-50/month at medium scale

### Implementation

```javascript
// Crawlee proxy configuration
const proxyConfiguration = new ProxyConfiguration({
  proxyUrls: [
    'http://user:pass@proxy1.iproyal.com:12321',
    'http://user:pass@proxy2.iproyal.com:12321',
    // ... rotation pool
  ],
});
```

---

## SaaS Pricing & Limits

| Plan | Apps | Keywords | Countries | Platforms | Price |
|------|------|----------|-----------|-----------|-------|
| Free | 1 | 10 | 3 | iOS only | $0 |
| Starter | 3 | 50 | 10 | iOS + Android | $9/mo |
| Pro | 10 | 200 | All | iOS + Android | $29/mo |
| Business | 50 | 1000 | All | iOS + Android | $99/mo |

**Note:** Free tier is iOS-only to reduce scraping costs while still enabling user acquisition.

---

## UI/UX Design

### App Dashboard - Platform Tabs

```
┌─────────────────────────────────────────────┐
│  🎵 Spotify                            ⚙️   │
├─────────────────────────────────────────────┤
│  ┌────────┐ ┌────────────┐                  │
│  │  iOS   │ │  Android   │                  │
│  └────────┘ └────────────┘                  │
├─────────────────────────────────────────────┤
│                                             │
│  Rankings   Ratings   Reviews               │
│  ─────────────────────────────              │
│  keyword1      #3     ↑2                    │
│  keyword2      #12    ↓1                    │
│  keyword3      #156   ─                     │
│                                             │
└─────────────────────────────────────────────┘
```

### Add App Flow (Semi-automatic linking)

```
1. User searches "Spotify"
2. Show iOS results from iTunes
3. User selects Spotify iOS
4. Auto-search "Spotify" on Google Play
5. Show modal: "Found Spotify on Android. Link it?"
   - [Yes, link] → Creates unified app
   - [No, iOS only] → Creates iOS-only app
   - [Search other] → Manual Android search
```

### Add App Screen Changes

- Add "Platform" selector: iOS / Android / Both
- When "Both" selected, show two search fields or sequential flow
- Show linked status with platform icons: 🍎 🤖

---

## Implementation Phases

### Phase 1: Infrastructure
- [ ] Create Node.js micro-service project
- [ ] Set up Crawlee with google-play-scraper
- [ ] Implement basic endpoints (search, app details)
- [ ] Docker setup
- [ ] Health check endpoint

### Phase 2: Backend Integration
- [ ] Database migrations (platform columns)
- [ ] GooglePlayService.php (calls Node.js service)
- [ ] Update controllers to support platform parameter
- [ ] Unified App model logic

### Phase 3: Flutter UI
- [ ] Platform tabs component
- [ ] Update Add App flow with Android search
- [ ] Semi-automatic linking modal
- [ ] Platform indicators throughout UI

### Phase 4: Scraping Robustness
- [ ] Proxy integration (webshare.io first)
- [ ] Rate limiting logic
- [ ] Retry with exponential backoff
- [ ] Error monitoring/alerting

### Phase 5: SaaS Features
- [ ] Plan limits enforcement
- [ ] Usage tracking per user
- [ ] Upgrade prompts when limits hit

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Google blocks scraping | High | Proxy rotation, rate limiting, backoff |
| google-play-scraper breaks | Medium | Monitor releases, have fallback manual parsing |
| Proxy costs exceed revenue | Medium | Aggressive caching, free tier = iOS only |
| Legal concerns (ToS) | Low-Medium | Common practice, no commercial data resale |

---

## Resolved Questions

1. **Reviews translation?** → **Show in original language.** No translation needed.
2. **Android app categories?** → **Keep separate from iOS.** Categories are secondary info, not critical for ranking tracking. Can map later if needed.
3. **Package name vs Play ID?** → **Package name** (e.g., `com.spotify.music`). On Google Play, the package name IS the store ID - they're the same thing.

---

## References

- [google-play-scraper](https://github.com/facundoolano/google-play-scraper)
- [Crawlee documentation](https://crawlee.dev/)
- [IPRoyal residential proxies](https://iproyal.com/)
- [Webshare.io free proxies](https://www.webshare.io/)
