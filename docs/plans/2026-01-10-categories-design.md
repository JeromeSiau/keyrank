# Categories Feature Design

## Overview

Add app store categories support:
1. Store category when adding apps
2. Browse top charts by category (Top Free / Top Paid)
3. Filter tracked apps by category

## Data Model

### Database (table `apps`)

```sql
category_id            VARCHAR(50) NULL   -- "6014" (iOS), "GAME" (Android)
secondary_category_id  VARCHAR(50) NULL   -- iOS only (secondary category)
```

### Flutter (`AppModel`)

```dart
final String? categoryId;
final String? secondaryCategoryId;
```

Category names are localized via `.arb` files, not stored in DB.

## API Endpoints

### List Categories

```
GET /api/categories
```

Response:
```json
{
  "ios": [{"id": "6014", "name": "Games"}, ...],
  "android": [{"id": "GAME", "name": "Games"}, ...]
}
```

### Get Top Charts

```
GET /api/categories/{categoryId}/top
  ?platform=ios|android
  ?country=us
  ?collection=top_free|top_paid
  ?limit=100
```

Response: List of apps with position, name, icon, rating, developer...

### Implementation

- **iOS**: iTunes RSS Feed `https://itunes.apple.com/{country}/rss/topfreeapplications/genre={id}/json`
- **Android**: google-play-scraper `list()` function with `category` and `collection` params

### Cache

- Top charts: 1 hour
- Categories list: 24 hours

## Frontend Changes

### Rename & Restructure

- `KeywordSearchScreen` → `DiscoverScreen`
- File: `keyword_search_screen.dart` → `discover_screen.dart`
- Route: `/keywords/search` → `/discover`

### Discover Screen Layout

```
┌─────────────────────────────────────────────┐
│  Discover          [Keywords] [Categories]  │  ← Tabs
│                    [iOS] [Android]          │  ← Platform toggle
│                    [US ▼]                   │  ← Country picker
├─────────────────────────────────────────────┤
│  Keywords tab:                              │
│  [Search keywords...]                       │
│                                             │
│  Categories tab:                            │
│  [Games ▼]  [Top Free ▼]                    │  ← Category + Collection
├─────────────────────────────────────────────┤
│  Results (same format as current)           │
│  #1  App Name          ⭐ 4.8    [+]        │
│  #2  App Name          ⭐ 4.5    [+]        │
└─────────────────────────────────────────────┘
```

### Apps List Filter

```
┌─────────────────────────────────────────────┐
│  My Apps        [All categories ▼]          │  ← New dropdown
├─────────────────────────────────────────────┤
│  App 1 - Games                              │
│  App 2 - Business                           │
└─────────────────────────────────────────────┘
```

- Dropdown populated from tracked apps' categories only
- Client-side filtering (data already loaded)

### New Widgets

- `CategoryPicker` - dropdown like `CountryPicker`
- `CollectionPicker` - toggle Top Free / Top Paid

### Localization

Add to all `.arb` files:
```json
"category_games": "Games",
"category_business": "Business",
...
```

## Implementation Order

### Backend

1. Migration: add `category_id`, `secondary_category_id` to `apps`
2. Modify `AppController`: extract and store categories on add
3. Create `CategoryController`: list categories + tops
4. Add routes in `api.php`
5. Scraper: endpoint for Android tops (google-play-scraper `list()`)

### Frontend

1. Update `AppModel`: 2 new fields
2. Create category translations in all `.arb` files
3. Rename `KeywordSearchScreen` → `DiscoverScreen`
4. Add Keywords / Categories tabs
5. Create `CategoryPicker` + `CollectionPicker`
6. Create `CategoriesRepository` + provider
7. Add category filter in `AppsListScreen`
8. Update navigation/routes

### Migration

- Artisan command to refresh all existing apps metadata to populate categories
