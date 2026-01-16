# 5.4 Competitor Keyword Spy - Design

**Date**: 2026-01-16
**Status**: Approved

---

## Overview

Allow users to see all keywords a competitor ranks for, compare with their own rankings, and discover keyword gaps to track.

## User Stories

- US-10.1: See all keywords for which a competitor ranks
- US-10.2: Compare my position vs competitor for each keyword
- US-10.3: Identify "gaps" (keywords where they rank but I don't)
- US-10.4: Easily add competitor keywords to my tracking

## Entry Points

1. **Competitor list** → tap competitor → CompetitorDetailScreen → Keywords tab
2. **App keywords screen** → "Compare with competitor" action → CompetitorKeywordsScreen

## UI Design

### Summary Stats (top of screen)
```
┌─────────────────────────────────────────┐
│  Keywords analysés: 156                 │
│  🟢 You Win: 47 (30%)                   │
│  🔴 They Win: 86 (55%)                  │
│  ⚠️  Gaps: 23 keywords à découvrir      │
└─────────────────────────────────────────┘
```

### Filters
`[Gaps] [They Win] [You Win] [All]`
- "Gaps" selected by default (main action is discovering what you're missing)

### Comparison Table
```
┌────────────────────────────────────────────────────────────────────┐
│ Keyword              │ You  │ Them │ Gap │ Pop │ Action            │
│──────────────────────┼──────┼──────┼─────┼─────┼───────────────────│
│ budget tracker       │  #3  │  #7  │ +4  │  52 │ ✓ Tracking        │
│ expense manager      │  #8  │  #4  │ -4  │  45 │ ✓ Tracking        │
│ spending tracker     │  -   │  #4  │ gap │  52 │ [+ Track]         │
│ bill reminder        │  -   │  #2  │ gap │  45 │ [+ Track]         │
└────────────────────────────────────────────────────────────────────┘
```

### Actions
- Individual `[+ Track]` button for quick single keyword add
- Selection mode + bulk "Track selected (N)" for power users
- Reuse selection pattern from 5.5 Bulk Keyword Actions

## API Design

### New Endpoint
```
GET /api/competitors/{competitorId}/keywords?app_id={userAppId}&country={storefront}

Response:
{
  "competitor": {
    "id": 123,
    "name": "Mint",
    "icon_url": "..."
  },
  "summary": {
    "total_keywords": 156,
    "you_win": 47,
    "they_win": 86,
    "gaps": 23
  },
  "keywords": [
    {
      "keyword": "budget tracker",
      "your_position": 3,
      "competitor_position": 7,
      "gap": 4,
      "popularity": 52,
      "is_tracking": true
    },
    {
      "keyword": "spending tracker",
      "your_position": null,
      "competitor_position": 4,
      "gap": null,
      "popularity": 52,
      "is_tracking": false
    }
  ]
}
```

## Flutter Structure

### New Files
```
lib/features/competitors/
├── domain/
│   └── competitor_keywords_model.dart      # Freezed models
├── presentation/
│   ├── competitor_detail_screen.dart       # Detail page with tabs
│   └── widgets/
│       ├── competitor_keywords_tab.dart    # Keywords comparison tab
│       ├── keyword_comparison_row.dart     # Table row widget
│       └── competitor_summary_card.dart    # Stats summary
└── providers/
    └── competitor_keywords_provider.dart   # Data fetching
```

### Modified Files
- `competitors_repository.dart` - Add getCompetitorKeywords method
- `app_keywords_tab.dart` - Add "Compare with competitor" action
- Router - Add competitor detail route

## Scope V1

### Included
- CompetitorDetailScreen with Keywords tab
- Comparison table with filters (Gaps/They Win/You Win/All)
- Track individual + bulk selection
- Access from competitor list AND keywords screen

### Excluded (future)
- Multi-competitor matrix (Phase 6)
- Comparison export
- Gap alerts
