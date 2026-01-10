# Insights Compare Feature

## Overview

Allow users to compare insights across multiple apps (2-4) side by side. Supports both competitive benchmarking and portfolio analysis use cases.

## User Flow

### Entry Point
- From `AppInsightsScreen`, a "Compare" button in the toolbar (next to app name)
- Button disabled if current app has no insights (tooltip: "Generate insights first")

### App Selection
1. Click "Compare" → opens modal
2. Modal shows list of tracked apps (excluding current app)
3. Each app displays: icon, name, platform badge, "No insights" badge if applicable
4. User checks 1-3 apps to compare
5. Click "Compare" button in modal footer

### Navigation
- Route: `/apps/compare?ids=1,5,12` (current app + selected apps)
- New screen: `InsightsCompareScreen`

### Auto-Generation
- On screen load, call API for each app
- If an app has no insights, automatically trigger generation
- Display loader per column during generation
- Columns appear as data becomes available (no need to wait for all)

## UI Layout

### Sticky Header
- Toolbar: back button + title "Compare Insights"
- Below: row of compared apps (icon + name + average score)
- Stays visible on scroll

### Columns (Side by Side)
Each app gets an equal-width column (flex). Vertical sections:

1. **Metadata** - Review count, countries, analysis period
2. **Strengths** - Green bullet list
3. **Weaknesses** - Red bullet list
4. **Category Scores** - 6 categories with scores (UX, Performance, Features, Pricing, Support, Onboarding)
   - Best score per category highlighted (accent border)
5. **Opportunities** - Yellow bullet list

### Column States
- **Loading**: Spinner + "Analyzing reviews..."
- **Error**: Error message + "Retry" button
- **Success**: Normal content

### Responsive
- 4 apps: compact columns
- 2-3 apps: wider, more comfortable columns
- < 900px width: horizontal scroll (rare on desktop)

## App Selection Modal

- Max height 60% of screen, scrollable
- Search bar at top to filter by name
- Each row: checkbox + app icon (32px) + name + platform chip (iOS/Android)
- Subtle "No insights" badge if not yet generated (but still selectable)
- Sticky footer: "X selected" + "Compare" button (disabled if 0 selected)

## Technical Implementation

### Files to Create

1. `app/lib/features/insights/presentation/insights_compare_screen.dart`
   - Main comparison screen
   - Handles per-app loading/generation

2. `app/lib/features/insights/presentation/widgets/compare_app_selector_modal.dart`
   - Modal for selecting apps to compare

### Files to Modify

1. `app/lib/features/insights/presentation/app_insights_screen.dart`
   - Add "Compare" button in toolbar

2. `app/lib/core/router/app_router.dart`
   - Add route `/apps/compare`

### Data Flow

```
1. User clicks "Compare" → open modal
2. User selects apps → navigate to /apps/compare?ids=1,5,12
3. InsightsCompareScreen loads
4. For each app ID:
   - Call getInsight(appId)
   - If null → call generateInsights(appId, countries, period)
5. Display columns as data arrives
```

### Existing Code
- `compareAppsProvider` exists but doesn't handle auto-generation
- Use local state in screen for individual column loading (simpler)
- `InsightComparison` model already exists in `insight_model.dart`
- API endpoint `GET /insights/compare` already implemented

## Edge Cases

- App with no insights: auto-generate on compare
- Generation fails: show error in column with retry button
- Not enough reviews: show "Not enough reviews" message
- All generations fail: show error state with option to go back
