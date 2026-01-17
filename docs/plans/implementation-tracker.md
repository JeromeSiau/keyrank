# Keyrank ASO - Implementation Tracker

> **Roadmap source**: [2026-01-15-aso-competitive-roadmap.md](./2026-01-15-aso-competitive-roadmap.md)

---

## Quick Stats

| Phase | Total | Done | In Progress | Remaining |
|-------|-------|------|-------------|-----------|
| Phase 1: Quick Wins | 6 | 6 | 0 | 0 |
| Phase 2: Core Parity | 6 | 6 | 0 | 0 |
| Phase 3: Différenciation | 4 | 1 | 0 | 3 |
| Phase 4: Enterprise | 5 | 0 | 0 | 5 |
| **TOTAL** | **21** | **13** | **0** | **8** |

---

## Phase 1: Quick Wins

| # | Feature | Status | Branch | Session Date | Notes |
|---|---------|--------|--------|--------------|-------|
| 4.1 | ASO Score Global | ✅ Done | main | 2026-01-16 | Dashboard widget + Insights |
| 4.2 | Keyword Difficulty Score | ✅ Done | main | 2026-01-16 | Liste keywords + filtres |
| 4.3 | Export CSV | ✅ Done | main | 2026-01-16 | Keywords, Analytics, Reviews |
| 4.4 | AI Review Reply Generator | ✅ Done | main | 2026-01-16 | 3 tons: pro/empathetic/brief |
| 4.5 | Email Alerts | ✅ Done | main | 2026-01-16 | Settings + digest scheduling |
| 4.6 | Custom Date Range Picker | ✅ Done | main | 2026-01-16 | Shared widget |

**Phase 1 Complete!** All 6 Quick Wins implemented.

---

## Phase 2: Core Parity

| # | Feature | Status | Branch | Session Date | Notes |
|---|---------|--------|--------|--------------|-------|
| 5.1 | Metadata Editor | ✅ Done | main | 2026-01-16 | Full CRUD + ASC/Google Play API integration |
| 5.2 | Multi-Locale View | ✅ Done | main | 2026-01-16 | Table view, filters, bulk copy/translate (AI) |
| 5.3 | Keyword Suggestions AI | ✅ Done | main | 2026-01-16 | Categorized: High Opp, Competitor, Long-tail, Trending, Related |
| 5.4 | Competitor Keyword Spy | ✅ Done | main | 2026-01-16 | Detail page + comparison |
| 5.5 | Bulk Keyword Actions | ✅ Done | main | 2026-01-16 | Selection mode + bulk export |
| 5.6 | Conversion Funnel | ✅ Done | main | 2026-01-16 | Full implementation with insight text + trend chart |

**Phase 2 Complete!** All 6 Core Parity features implemented.

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
| 6.3 | Chat with Executable Actions | ✅ Done | main | 2026-01-17 | Tool calling + action cards |
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

### Session 2026-01-16 - 5.1 Metadata Editor + 5.2 Multi-Locale View
- **Branch**: main
- **Status**: ✅ Done
- **Notes**:
  - **5.1 Metadata Editor** (already implemented):
    - Backend: Full `MetadataController` with CRUD operations
    - API endpoints: `GET/PUT /apps/{id}/metadata/{locale}`, publish, refresh, history
    - Flutter: Models, Repository, Provider, Editor Screen
    - Features: Live vs Draft comparison, keyword analysis, character limits
  - **5.2 Multi-Locale View** (this session):
    - Backend: Added `POST /metadata/copy` and `POST /metadata/translate` endpoints
    - AI Translation using OpenRouter (gpt-5-nano) with ASO-optimized prompts
    - Flutter: Coverage card with stats and progress bar
    - Flutter: Multi-locale table with filters (All/Live/Draft/Empty)
    - Flutter: Bulk actions bar (Copy, Translate, Publish)
    - Flutter: Selection mode with long-press to select
    - Added l10n strings for all 10 languages (EN, FR, DE, ES, IT, JA, KO, PT, TR, ZH)
- **Files created**:
  - `app/lib/features/metadata/presentation/widgets/metadata_coverage_card.dart`
  - `app/lib/features/metadata/presentation/widgets/metadata_multi_locale_table.dart`
  - `app/lib/features/metadata/presentation/widgets/metadata_bulk_actions_bar.dart`
- **Files modified**:
  - `api/app/Http/Controllers/Api/MetadataController.php` - Added copyLocale, translateLocale
  - `api/routes/api.php` - Added copy and translate routes
  - `app/lib/features/metadata/data/metadata_repository.dart` - Added copyLocale, translateLocale methods
  - `app/lib/features/metadata/providers/metadata_provider.dart` - Added selection/filter providers
  - `app/lib/features/metadata/presentation/screens/metadata_editor_screen.dart` - Integrated new components
  - `app/lib/l10n/*.dart` - Added multi-locale view strings (27 new strings per locale)

### Session 2026-01-16 - 5.3 Keyword Suggestions AI
- **Branch**: main
- **Status**: ✅ Done
- **Notes**:
  - Enhanced keyword suggestions with 5 categories: High Opportunity, Competitor, Long-tail, Trending, Related
  - Backend: Created `KeywordSuggestionService` with cross-platform support (iOS + Android)
  - Competitor extraction from tracked competitors' keywords
  - Long-tail generation with Search Hints validation (real search volume)
  - Related keywords expansion from tracked keywords
  - Trending keywords from category top apps
  - Flutter: Updated models with category, popularity, reason, basedOn, competitorName
  - Flutter: Enhanced modal with category tabs, grouped view, reason display
  - Added l10n strings (EN + FR)
- **Files created**:
  - `api/app/Services/KeywordSuggestionService.php`
  - `api/database/migrations/2026_01_16_100000_add_ai_fields_to_keyword_suggestions_table.php`
  - `docs/plans/5.3-keyword-suggestions-ai.md`
- **Files modified**:
  - `api/app/Models/KeywordSuggestion.php` - Added new fields + scopes
  - `api/app/Jobs/GenerateKeywordSuggestionsJob.php` - Use new service
  - `api/app/Http/Controllers/Api/KeywordController.php` - Categorized response
  - `app/lib/features/keywords/domain/keyword_model.dart` - Added category, reason, etc.
  - `app/lib/features/keywords/presentation/keyword_suggestions_modal.dart` - Category tabs + grouped view
  - `app/lib/l10n/app_en.arb`, `app_fr.arb` - New category strings

### Session 2026-01-16 - 5.6 Conversion Funnel Analytics
- **Branch**: main
- **Status**: ✅ Done
- **Notes**:
  - **Backend**: Full implementation with ASC Analytics API + Google Play acquisition reports
  - Migration: `app_funnel_analytics` table with impressions, page_views, downloads, source
  - AppFunnelAnalytics model with scopes (forPeriod, bySource, byCountry, aggregatedByDate, aggregatedBySource)
  - Extended AppStoreConnectService with Analytics API methods (requestAnalyticsReport, getConversionFunnelData)
  - Extended GooglePlayDeveloperService with acquisition report methods
  - FunnelController: GET /apps/{app}/funnel, POST /apps/{app}/funnel/sync
  - SyncFunnelAnalyticsJob: Daily at 7:00 AM
  - **Flutter**: ConversionFunnel models (Freezed) with summary, bySource, trend, comparison
  - ConversionFunnelCard widget with:
    - Funnel stages visualization (Impressions → Page Views → Downloads)
    - Category average comparison badge
    - Source breakdown table
    - **NEW**: _FunnelInsight widget with AI-generated insight text (e.g., "Search traffic converts 2.4x better than Browse")
    - **NEW**: _FunnelTrendChart with fl_chart line chart for CVR % over time
  - Analytics provider with conversionFunnelProvider, funnelSourceFilterProvider
  - l10n strings for all insight recommendations (EN + FR + fallback for other locales)
- **Files created**:
  - `api/database/migrations/2026_01_16_200000_create_app_funnel_analytics_table.php`
  - `api/app/Models/AppFunnelAnalytics.php`
  - `api/app/Http/Controllers/Api/FunnelController.php`
  - `api/app/Jobs/SyncFunnelAnalyticsJob.php`
  - `app/lib/features/analytics/domain/conversion_funnel_model.dart`
  - `app/lib/features/analytics/presentation/widgets/conversion_funnel_card.dart`
  - `docs/plans/5.6-conversion-funnel.md`
- **Files modified**:
  - `api/app/Services/AppStoreConnectService.php` - Added Analytics API methods
  - `api/app/Services/GooglePlayDeveloperService.php` - Added acquisition report methods
  - `api/routes/api.php` - Added funnel routes
  - `api/routes/console.php` - Added SyncFunnelAnalyticsJob schedule
  - `app/lib/features/analytics/data/analytics_repository.dart` - Added getFunnel, syncFunnel
  - `app/lib/features/analytics/providers/analytics_provider.dart` - Added funnel providers
  - `app/lib/features/analytics/presentation/app_analytics_screen.dart` - Integrated ConversionFunnelCard
  - `app/lib/l10n/*.arb` and `app_localizations*.dart` - Added funnel insight strings

**Phase 2 Complete!** All Core Parity features implemented.

### Session 2026-01-17 - 6.3 Chat with Executable Actions
- **Branch**: main
- **Status**: ✅ Done
- **Notes**:
  - **LLM Tool Calling**: Extended OpenRouterService with function/tool definitions
  - Tools implemented: add_keywords, remove_keywords, create_alert
  - ChatAction model with status (proposed/executed/cancelled/failed)
  - ActionExecutorService for executing actions on user confirmation
  - **Flutter**: ChatAction model (Freezed), ActionCard widget with Confirm/Cancel buttons
  - MessageBubble now renders inline ActionCards for proposed actions
  - Fixed app context provider usage in ChatScreen (was using wrong provider)
  - Fixed ActionExecutorService to use TrackedKeyword model (not Keyword)
  - Removed non-working streaming implementation
  - Added localized suggested questions (10 languages via Accept-Language header)
- **Files created**:
  - `api/app/Models/ChatAction.php`
  - `api/app/Services/ActionExecutorService.php`
  - `api/database/migrations/2026_01_16_300000_create_chat_actions_table.php`
  - `app/lib/features/chat/domain/chat_action_model.dart`
  - `app/lib/features/chat/presentation/widgets/action_card.dart`
  - `docs/plans/6.3-chat-executable-actions.md`
- **Files modified**:
  - `api/app/Http/Controllers/Api/ChatController.php` - execute/cancel actions, localized suggestions
  - `api/app/Services/ChatService.php` - Tool definitions, action extraction from LLM response
  - `api/app/Services/OpenRouterService.php` - Tool calling support
  - `api/routes/api.php` - Action routes
  - `app/lib/features/chat/data/chat_repository.dart` - Execute/cancel action methods
  - `app/lib/features/chat/providers/chat_provider.dart` - Action execution, locale for suggestions
  - `app/lib/features/chat/presentation/chat_screen.dart` - Fixed app context provider
  - `app/lib/features/chat/presentation/widgets/message_bubble.dart` - Render action cards

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
| 5.1 Metadata Editor | ASC API integration | `GET/PUT /apps/{id}/metadata` | ✅ Done |
| 5.2 Multi-Locale | Copy/Translate | `POST /apps/{id}/metadata/copy,translate` | ✅ Done |
| 5.3 Keyword Suggestions | AI + competitor data | `GET /apps/{id}/keywords/suggestions` | ✅ Done |
| 5.4 Competitor Keywords | Keyword comparison | `GET /competitors/{id}/keywords` | ✅ Done |
| 5.6 Conversion Funnel | ASC Analytics API | `GET /apps/{id}/funnel` | ✅ Done |
| 6.2 Competitor History | Scraping service | `GET /competitors/{id}/metadata-history` | ⬚ Todo |
| 6.3 Chat Actions | Action execution | `POST /chat/actions/{id}/execute` | ✅ Done |
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

*Last updated: 2026-01-17 (6.3 Chat with Executable Actions)*
