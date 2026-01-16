# Keyrank ASO - Implementation Tracker

> **Roadmap source**: [2026-01-15-aso-competitive-roadmap.md](./2026-01-15-aso-competitive-roadmap.md)

---

## Quick Stats

| Phase | Total | Done | In Progress | Remaining |
|-------|-------|------|-------------|-----------|
| Phase 1: Quick Wins | 6 | 1 | 0 | 5 |
| Phase 2: Core Parity | 6 | 2 | 0 | 4 |
| Phase 3: Différenciation | 4 | 0 | 0 | 4 |
| Phase 4: Enterprise | 5 | 0 | 0 | 5 |
| **TOTAL** | **21** | **3** | **0** | **18** |

---

## Phase 1: Quick Wins

| # | Feature | Status | Branch | Session Date | Notes |
|---|---------|--------|--------|--------------|-------|
| 4.1 | ASO Score Global | ⬚ Todo | - | - | Dashboard widget + Insights |
| 4.2 | Keyword Difficulty Score | ⬚ Todo | - | - | Liste keywords + filtres |
| 4.3 | Export CSV | ⬚ Todo | - | - | Keywords, Analytics, Reviews |
| 4.4 | AI Review Reply Generator | ⬚ Todo | - | - | 3 tons: pro/empathetic/brief |
| 4.5 | Email Alerts | ✅ Done | main | 2026-01-16 | Settings + digest scheduling |
| 4.6 | Custom Date Range Picker | ⬚ Todo | - | - | Shared widget |

### Suggested Order
```
4.6 → 4.3 → 4.2 → 4.1 → 4.4
(dependencies: date picker used in analytics, export simple, etc.)
```

---

## Phase 2: Core Parity

| # | Feature | Status | Branch | Session Date | Notes |
|---|---------|--------|--------|--------------|-------|
| 5.1 | Metadata Editor | ⬚ Todo | - | - | NEW module, ~1-2h |
| 5.2 | Multi-Locale View | ⬚ Todo | - | - | Depends on 5.1 |
| 5.3 | Keyword Suggestions AI | ⬚ Todo | - | - | Backend AI needed |
| 5.4 | Competitor Keyword Spy | ✅ Done | main | 2026-01-16 | Detail page + comparison |
| 5.5 | Bulk Keyword Actions | ✅ Done | main | 2026-01-16 | Selection mode + bulk export |
| 5.6 | Conversion Funnel | ⬚ Todo | - | - | ASC/Google API data |

### Suggested Order
```
5.5 → 5.4 → 5.3 → 5.1 → 5.2 → 5.6
(5.1/5.2 are big, do smaller ones first for momentum)
```

---

## Phase 3: Différenciation AI

| # | Feature | Status | Branch | Session Date | Notes |
|---|---------|--------|--------|--------------|-------|
| 6.1 | AI Optimization Wizard | ⬚ Todo | - | - | Depends on 5.1 (Metadata) |
| 6.2 | Competitor Metadata History | ⬚ Todo | - | - | Backend scraping needed |
| 6.3 | Chat with Executable Actions | ⬚ Todo | - | - | Extend existing chat |
| 6.4 | Review Intelligence Dashboard | ⬚ Todo | - | - | AI extraction features |

### Suggested Order
```
6.3 → 6.4 → 6.2 → 6.1
(6.1 needs metadata editor first)
```

---

## Phase 4: Enterprise

| # | Feature | Status | Branch | Session Date | Notes |
|---|---------|--------|--------|--------------|-------|
| 7.1 | Team Management | ⬚ Todo | - | - | NEW module |
| 7.2 | Slack Integration | ⬚ Todo | - | - | OAuth + webhooks |
| 7.3 | Scheduled PDF Reports | ⬚ Todo | - | - | Backend jobs |
| 7.4 | Public API | ⬚ Todo | - | - | Backend focus |
| 7.5 | Webhooks | ⬚ Todo | - | - | Backend + settings UI |

### Suggested Order
```
7.1 → 7.2 → 7.5 → 7.3 → 7.4
```

---

## Session Log

### Template
```markdown
### Session [DATE] - [FEATURE]
- **Branch**: feature/xxx
- **Duration**: Xh Xmin
- **Status**: ✅ Done / 🔄 In Progress / ❌ Blocked
- **Commits**: abc1234, def5678
- **Notes**: ...
- **Next**: ...
```

### Sessions

### Session 2026-01-16 - 5.4 Competitor Keyword Spy
- **Branch**: main
- **Status**: ✅ Done
- **Notes**:
  - Backend: Added `GET /competitors/{id}/keywords` endpoint with comparison data
  - Flutter: Created Freezed models for keyword comparison
  - Flutter: Added CompetitorDetailScreen with keywords tab
  - UI: Summary card (total/you win/they win/gaps), filter bar, keyword rows
  - Features: Individual + bulk keyword tracking, selection mode
  - Navigation: From competitor list to detail page
- **Files created**:
  - `api/app/Http/Controllers/Api/CompetitorController.php` (keywords method)
  - `app/lib/features/competitors/domain/competitor_keywords_model.dart`
  - `app/lib/features/competitors/presentation/competitor_detail_screen.dart`
  - `app/lib/features/competitors/presentation/widgets/competitor_keywords_tab.dart`
- **Files modified**:
  - `api/routes/api.php` - Added competitor keywords route
  - `app/lib/features/competitors/data/competitors_repository.dart` - Added getCompetitorKeywords
  - `app/lib/features/competitors/providers/competitors_provider.dart` - Added keyword providers
  - `app/lib/core/router/app_router.dart` - Added competitor detail route
  - `app/lib/features/keywords/presentation/competitors_screen.dart` - Updated navigation

### Session 2026-01-16 - 5.5 Bulk Keyword Actions
- **Branch**: main
- **Status**: ✅ Done
- **Notes**:
  - Ported selection mode from obsolete `app_detail_screen.dart` to `app_keywords_tab.dart`
  - Added selection mode to global keywords view (`keywords_screen.dart`)
  - Implemented bulk actions: Select All, Favorite, Tag, Export, Delete
  - Added export selected keywords feature
  - Deleted obsolete `app_detail_screen.dart`
- **Files changed**:
  - `app/lib/features/apps/presentation/tabs/app_keywords_tab.dart` - Added selection mode + bulk actions
  - `app/lib/features/keywords/presentation/keywords_screen.dart` - Added selection mode to global view
  - Deleted: `app/lib/features/apps/presentation/app_detail_screen.dart`

---

## Blockers & Questions

| Feature | Blocker | Status | Resolution |
|---------|---------|--------|------------|
| - | - | - | - |

---

## Backend Requirements

Features requiring backend changes:

| Feature | Backend Work | API Endpoints | Status |
|---------|--------------|---------------|--------|
| 4.1 ASO Score | Score calculation | `GET /apps/{id}/aso-score` | ⬚ Todo |
| 4.4 AI Reply | LLM integration | `POST /reviews/{id}/generate-reply` | ⬚ Todo |
| 4.5 Email Alerts | Email service | `PUT /settings/alerts` | ✅ Done |
| 5.1 Metadata Editor | ASC API integration | `GET/PUT /apps/{id}/metadata` | ⬚ Todo |
| 5.3 Keyword Suggestions | AI + competitor data | `GET /keywords/suggestions/{appId}` | ⬚ Todo |
| 5.4 Competitor Keywords | Keyword comparison | `GET /competitors/{id}/keywords` | ✅ Done |
| 5.6 Conversion Funnel | ASC Analytics API | `GET /analytics/{id}/funnel` | ⬚ Todo |
| 6.2 Competitor History | Scraping service | `GET /competitors/{id}/metadata-history` | ⬚ Todo |
| 6.3 Chat Actions | Action execution | `POST /chat/execute-action` | ⬚ Todo |
| 7.1 Team | User management | `GET/POST /team/*` | ⬚ Todo |
| 7.2 Slack | OAuth | `POST /integrations/slack` | ⬚ Todo |
| 7.3 Reports | PDF generation | `POST /reports/{id}/generate` | ⬚ Todo |
| 7.4 API | Rate limiting | `/api/v1/*` | ⬚ Todo |
| 7.5 Webhooks | Event system | `POST /webhooks` | ⬚ Todo |

---

## How to Use This Tracker

### Starting a Session
```
1. Pick next feature from "Suggested Order"
2. Update status to 🔄
3. Create branch: git checkout -b feature/[name]
4. Tell Claude:
   "Je travaille sur [FEATURE] du plan.
    Voir section [4-7].X du roadmap."
```

### Ending a Session
```
1. Commit changes
2. Update this tracker:
   - Status: ✅ or 🔄
   - Branch name
   - Session date
   - Notes
3. Update Quick Stats counts
```

### Status Legend
- ⬚ Todo
- 🔄 In Progress
- ✅ Done
- ❌ Blocked
- ⏸️ Paused

---

## Files Created/Modified Log

Track which files each feature touches:

| Feature | Files Created | Files Modified |
|---------|---------------|----------------|
| 4.1 ASO Score | `lib/features/insights/domain/models/aso_score.dart`, `lib/features/dashboard/presentation/widgets/aso_score_widget.dart` | `dashboard_screen.dart` |
| 4.2 Difficulty | `lib/features/keywords/domain/models/keyword_difficulty.dart` | `keyword.dart`, `keyword_list_item.dart` |
| 4.3 Export | `lib/core/utils/csv_exporter.dart`, `lib/shared/widgets/export_dialog.dart` | Multiple screens |
| ... | ... | ... |

---

*Last updated: 2026-01-16 (5.4 Competitor Keyword Spy)*
