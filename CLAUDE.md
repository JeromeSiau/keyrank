# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Keyrank is a comprehensive App Store Optimization (ASO) platform for mobile app developers and marketers. Multi-platform Flutter frontend with Laravel backend.

### Key Features

- **Keyword Tracking**: Monitor keyword rankings, popularity scores, and historical trends
- **Competitor Analysis**: Track competitor apps and compare performance
- **Review Intelligence**: AI-powered analysis of app reviews with sentiment detection
- **Actionable Insights**: Automated recommendations for ASO improvements
- **Analytics Dashboard**: Comprehensive metrics and visualizations
- **Team Collaboration**: Multi-user teams with role-based access
- **Alerts & Notifications**: Customizable alerts for ranking changes
- **Metadata Management**: A/B testing and optimization of app store listings
- **Multi-Store Support**: Apple App Store and Google Play Store connections
- **Billing & Subscriptions**: Stripe integration with tiered plans
- **Public API**: REST API for third-party integrations
- **AI Chat**: Built-in AI assistant for ASO guidance

## Common Commands

### Flutter App (`app/` directory)

```bash
# Install dependencies
flutter pub get

# Run app (specify API URL)
flutter run --dart-define=API_BASE_URL=http://localhost:8000/api

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Lint
flutter analyze

# Code generation (Freezed, json_serializable, riverpod_generator)
dart run build_runner build --delete-conflicting-outputs

# Generate splash screen and app icons
dart run flutter_native_splash:create
dart run flutter_launcher_icons
```

### Laravel API (`api/` directory)

```bash
# Setup
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate

# Run server
php artisan serve

# Run tests
php artisan test
```

### Docker (from repo root)

```bash
docker-compose up -d  # MySQL, Redis, scraper services
```

## Architecture

### Flutter App Structure

```
app/lib/
├── core/               # Shared infrastructure
│   ├── api/            # Dio client with auth interceptor, ApiException
│   ├── providers/      # Global providers (theme, locale, country)
│   ├── router/         # GoRouter with auth guards and ShellRoute
│   └── theme/          # Material 3 design tokens
│
├── features/           # Feature modules (domain-driven)
│   ├── actionable_insights/  # AI-powered ASO recommendations
│   ├── alerts/         # Alert rules and notification templates
│   ├── analytics/      # Performance metrics and reports
│   ├── apps/           # App management
│   ├── auth/           # Authentication
│   ├── billing/        # Stripe subscriptions and payments
│   ├── categories/     # App Store categories
│   ├── chat/           # AI chat assistant
│   ├── competitors/    # Competitor tracking and analysis
│   ├── dashboard/      # Main dashboard views
│   ├── insights/       # Data insights
│   ├── integrations/   # Third-party integrations
│   ├── keywords/       # Keyword tracking and research
│   ├── metadata/       # App store listing optimization
│   ├── notifications/  # Push notifications
│   ├── onboarding/     # User onboarding flow
│   ├── rankings/       # Position history and charts
│   ├── ratings/        # App ratings tracking
│   ├── reviews/        # Review monitoring and intelligence
│   ├── settings/       # User and app settings
│   ├── store_connections/  # App Store & Play Store API connections
│   ├── tags/           # Keyword and app tagging
│   └── team/           # Team management and collaboration
│
├── l10n/               # Generated localizations (11 languages)
└── shared/             # Shared models and widgets
```

### Feature Module Pattern

Each feature follows Clean Architecture:
```
feature/
├── data/           # Repository implementations (Dio HTTP calls)
├── domain/         # Freezed models with business logic
├── presentation/   # Screens and widgets
└── providers/      # Riverpod state management
```

### Key Technologies

- **State Management**: Riverpod 2.6+ with `FutureProvider`, `StateNotifierProvider`, `StateProvider`
- **Models**: Freezed for immutable classes with `copyWith`, `fromJson`/`toJson`
- **Routing**: GoRouter with nested `ShellRoute` for main navigation shell
- **HTTP**: Dio with `AuthInterceptor` that auto-adds Bearer token, handles 401
- **Charts**: fl_chart for ranking visualizations
- **Push**: Firebase Messaging (FCM token sent to backend on auth)

### State Patterns

- **Async data**: Use `AsyncValue<T>` (loading/error/data states)
- **Optimistic updates**: UI updates immediately, then syncs with API
- **Auth flow**: `authStateProvider` manages login/logout; `unauthorizedEventProvider` triggers auto-logout on 401
- **Dependency injection**: Repositories provided via `Provider`, receive `Dio` from `dioProvider`

### Code Generation

Models use Freezed with JSON serialization:
```dart
@freezed
class AppModel with _$AppModel {
  const factory AppModel({
    required int id,
    @JsonKey(name: 'apple_id') required String appleId,
    required String name,
  }) = _AppModel;

  factory AppModel.fromJson(Map<String, dynamic> json) => _$AppModelFromJson(json);
}
```

Generated files: `*.freezed.dart`, `*.g.dart`. Run `dart run build_runner build` after modifying models.

### Localization

- ARB files in `lib/l10n/app_*.arb` (11 languages)
- Access via `context.l10n.keyName` extension
- Generated `AppLocalizations` class

### API Configuration

Base URL configured via compile-time define:
```bash
flutter run --dart-define=API_BASE_URL=http://localhost:8000/api
```

Defaults to `http://ranking.test/api` if not specified (see `lib/core/constants/api_constants.dart`).

### Responsive Design

- `ResponsiveShell`: Sidebar + content for desktop, bottom nav for mobile
- `Breakpoints` constants for media queries
- `ResponsiveBuilder` widget for conditional rendering

## Backend Notes

Laravel API with:
- Apple Search Ads API integration for keyword popularity
- iTunes API for app search and rankings
- CRON jobs for daily data sync (popularity at 03:00, rankings at 04:00)
- Redis for caching, MySQL/PostgreSQL for persistence
