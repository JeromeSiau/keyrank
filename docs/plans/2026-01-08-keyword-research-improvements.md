# Keyword Research Improvements

## Summary

Three improvements to the keyword tracking system:
1. Default keyword country based on app's storefront
2. Android search support in Keyword Research
3. Quick "Track" button in keyword search results

## 1. Storefront on App Model

### Backend (Laravel)
- Migration: add `storefront` column (varchar 2, nullable) to `apps` table
- `AppController::store()`: save `country` parameter as `storefront`
- `AppController::linkAndroid()`: save `country` parameter as `storefront`
- Include `storefront` in JSON responses

### Frontend (Flutter)
- `AppModel`: add `storefront` field
- `app_detail_screen`: use `app.storefront` as default for keyword country selector

## 2. Platform Toggle in Keyword Research

### Backend (Laravel)
- `KeywordController::search()`: add `platform` parameter (ios|android, default ios)
- If `platform=android`: use `GooglePlayService->searchApps()`
- Adapt response format to include `google_play_id` for Android results

### Frontend (Flutter)
- Add `_selectedPlatformProvider` (default: ios)
- Add iOS/Android toggle in toolbar (same style as add app screen)
- Update `KeywordSearchResult` model to support both `appleId` and `googlePlayId`

## 3. Track Button in Search Results

### Frontend (Flutter)
- Add "TRACK" column header in `_ResultsTable`
- Add "+" button in `_ResultRow`
- On click: call `appsNotifier.addApp()` (iOS) or `addAndroidApp()` (Android)
- Show success snackbar
- Handle "already tracked" case (disable button or show indicator)

## Implementation Order

1. Backend migration + App storefront
2. Frontend App storefront + default country
3. Backend keyword search platform parameter
4. Frontend platform toggle
5. Frontend track button
