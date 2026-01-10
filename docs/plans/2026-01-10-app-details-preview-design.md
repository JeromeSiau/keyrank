# App Details & Preview Mode

## Overview

Add detailed app information (description, screenshots, version, etc.) to the database and allow users to preview apps from the Explore screen before tracking them.

## Requirements

1. Store app details fetched from iTunes/Google Play APIs
2. In Explore mode, users can click an app row to view a read-only detail page
3. Preview mode shows app info with a CTA "Add to my apps"
4. Back button to return to Explore

## Database Schema

### New columns for `apps` table

```php
$table->text('description')->nullable();
$table->json('screenshots')->nullable();        // URLs as JSON array
$table->string('version', 50)->nullable();
$table->date('release_date')->nullable();       // iOS only
$table->timestamp('updated_date')->nullable();
$table->bigInteger('size_bytes')->nullable();   // iOS only
$table->string('minimum_os', 20)->nullable();   // iOS only
$table->string('store_url', 500)->nullable();
$table->decimal('price', 8, 2)->nullable();
$table->string('currency', 3)->nullable();
```

### Platform availability

| Field | iOS | Android |
|-------|-----|---------|
| description | ✅ | ✅ |
| screenshots | ✅ | ✅ |
| version | ✅ | ✅ |
| updated_date | ✅ | ✅ |
| store_url | ✅ | ✅ |
| price / currency | ✅ | ✅ |
| release_date | ✅ | ❌ |
| size_bytes | ✅ | ❌ |
| minimum_os | ✅ | ❌ |

## Backend API

### Modified: `POST /api/apps`

When adding an app, fetch full details and store all new fields.

### New: `GET /api/apps/preview/{platform}/{storeId}`

Returns app details WITHOUT adding to tracked apps.

```php
public function preview(string $platform, string $storeId, Request $request)
{
    $country = $request->input('country', 'us');

    if ($platform === 'ios') {
        $details = $this->itunesService->getAppDetails($storeId, $country);
    } else {
        $details = $this->googlePlayService->getAppDetails($storeId, $country);
    }

    return response()->json($details);
}
```

## Flutter Changes

### Updated `AppModel`

```dart
final String? description;
final List<String>? screenshots;
final String? version;
final DateTime? releaseDate;
final DateTime? updatedDate;
final int? sizeBytes;
final String? minimumOs;
final String? storeUrl;
final double? price;
final String? currency;
```

### New `AppPreview` model

For non-tracked apps (response from `/api/apps/preview`):

```dart
class AppPreview {
  final String platform;
  final String storeId;
  final String name;
  final String? iconUrl;
  final String? developer;
  final double? rating;
  final int ratingCount;
  final String? description;
  final List<String>? screenshots;
  final String? version;
  final DateTime? updatedDate;
  final int? sizeBytes;
  final String? storeUrl;
  final double? price;
  final String? currency;
}
```

### New repository method

```dart
Future<AppPreview> getAppPreview(String platform, String storeId, String country);
```

### `AppDetailScreen` modifications

Support two modes:
- **Tracked mode**: `/apps/:id` - current behavior
- **Preview mode**: `/apps/preview/:platform/:storeId?country=us`

```dart
class AppDetailScreen extends ConsumerStatefulWidget {
  final int? appId;           // If tracked app
  final String? platform;     // If preview
  final String? storeId;      // If preview

  bool get isPreviewMode => appId == null;
}
```

### Preview mode layout

```
┌─────────────────────────────────┐
│  ← Back                         │
├─────────────────────────────────┤
│  [Icon]  App Name               │
│          Developer              │
│          ★ 4.5 (1.2K)          │
├─────────────────────────────────┤
│  [Screenshot carousel]          │
├─────────────────────────────────┤
│  Description text...            │
├─────────────────────────────────┤
│  Version: 2.1.0                 │
│  Updated: Jan 10, 2026          │
│  Size: 45 MB                    │
├─────────────────────────────────┤
│  [Open in Store]                │
├─────────────────────────────────┤
│  [★ Add to my apps]             │  <- Primary CTA
└─────────────────────────────────┘
```

### Preview mode visibility

| Element | Visible |
|---------|---------|
| Header (icon, name, dev, rating) | ✅ |
| Description + details | ✅ |
| Screenshots | ✅ |
| "Open in Store" button | ✅ |
| "Add to my apps" CTA | ✅ |
| Keywords section | ❌ |
| Detailed Ratings/Reviews | ❌ |
| Insights section | ❌ |

### `DiscoverScreen` modifications

Make app rows clickable:

```dart
// In _AppResultRow and _TopAppRow
InkWell(
  onTap: () => context.push(
    '/apps/preview/${app.platform}/${app.storeId}?country=$country'
  ),
  child: // ... current row content
)
```

The "Track" button remains functional for quick add.

## Files to Modify

### Backend (Laravel API)
- `database/migrations/xxxx_add_app_details_columns.php` - new migration
- `app/Models/App.php` - add fillables
- `app/Http/Controllers/Api/AppsController.php` - modify `store()`, add `preview()`
- `routes/api.php` - add preview route

### Frontend (Flutter)
- `app/lib/features/apps/domain/app_model.dart` - new fields
- `app/lib/features/apps/domain/app_preview.dart` - new model (create)
- `app/lib/features/apps/data/apps_repository.dart` - new endpoint
- `app/lib/features/apps/presentation/app_detail_screen.dart` - preview mode
- `app/lib/features/keywords/presentation/discover_screen.dart` - clickable rows
- `app/lib/router.dart` - new preview route

## Implementation Order

1. Migration + Laravel Model update
2. Preview endpoint + modify store endpoint
3. Flutter AppModel + AppPreview + Repository
4. AppDetailScreen preview mode
5. DiscoverScreen navigation
