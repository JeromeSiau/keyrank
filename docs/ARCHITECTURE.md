# Keyrank - Architecture Technique

> Plateforme complète d'App Store Optimization (ASO) pour développeurs et marketeurs d'applications mobiles
> Stack: Laravel (Backend) + Flutter (Frontend multi-plateforme)

---

## Table des matières

1. [Vue d'ensemble](#1-vue-densemble)
2. [Configuration Apple Search Ads](#2-configuration-apple-search-ads)
3. [Architecture Backend Laravel](#3-architecture-backend-laravel)
4. [Schéma Base de Données](#4-schéma-base-de-données)
5. [Architecture Frontend Flutter](#5-architecture-frontend-flutter)
6. [Endpoints API](#6-endpoints-api)
7. [CRON Jobs & Synchronisation](#7-cron-jobs--synchronisation)
8. [Sources de données](#8-sources-de-données)

---

## 1. Vue d'ensemble

### Architecture globale

```
┌─────────────────────────────────────────────────────────────────┐
│                         FLUTTER APP                             │
│                  (iOS, Android, Web, Desktop)                   │
└─────────────────────────────────┬───────────────────────────────┘
                                  │ HTTPS
                                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                      LARAVEL API                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │ Controllers  │  │   Services   │  │    Jobs      │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└─────────────────────────────────┬───────────────────────────────┘
                                  │
        ┌─────────────────────────┼─────────────────────────┐
        ▼                         ▼                         ▼
┌──────────────┐        ┌──────────────┐        ┌──────────────┐
│   MySQL/     │        │    Redis     │        │   Apple &    │
│  PostgreSQL  │        │   (Cache)    │        │   iTunes     │
│              │        │              │        │    APIs      │
└──────────────┘        └──────────────┘        └──────────────┘
```

### Flux de données

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Vos Users  │────▶│ Votre API   │────▶│ Votre BDD   │
└─────────────┘     └─────────────┘     └─────────────┘
                                               │
                           ┌───────────────────┘
                           ▼
                    ┌─────────────┐     ┌─────────────┐
                    │  Job CRON   │────▶│  Apple API  │
                    │ (1x/jour)   │     │  + iTunes   │
                    └─────────────┘     └─────────────┘
```

**Principe clé** : Les utilisateurs interrogent votre BDD (rapide), pas Apple directement. Les jobs CRON mettent à jour les données en arrière-plan.

---

## 2. Configuration Apple Search Ads

### 2.1 Créer le compte

1. Aller sur **https://searchads.apple.com**
2. Se connecter avec son **Apple ID** (celui du compte développeur Apple)
3. Accepter les conditions d'utilisation
4. Pas besoin de lancer de campagne pub - le compte suffit

### 2.2 Configurer l'accès API

1. Aller dans **Account Settings → API**
2. Si l'option n'apparaît pas, aller dans **Account Settings → User Management**
3. S'inviter soi-même avec le rôle **"API Account Manager"**

> **Note** : Pour un projet perso/indie, le compte Admin suffit généralement. Le 2ème compte Apple ID est surtout nécessaire pour les agences/entreprises.

### 2.3 Générer les clés

```bash
# Générer une paire de clés EC (sur votre terminal)
openssl ecparam -genkey -name prime256v1 -noout -out private-key.pem
openssl ec -in private-key.pem -pubout -out public-key.pem
```

### 2.4 Enregistrer dans Apple

1. Copier le contenu complet de `public-key.pem` (avec BEGIN/END)
2. Coller dans le champ "Public Key" sur Apple Search Ads
3. Cliquer **"Generate API Client"**
4. Noter ces 3 valeurs :
   - **Client ID**
   - **Team ID**
   - **Key ID**

⚠️ **IMPORTANT** : Garder `private-key.pem` en sécurité (jamais dans git !)

### 2.5 Variables d'environnement Laravel

```env
# .env
APPLE_ADS_CLIENT_ID=your-client-id
APPLE_ADS_TEAM_ID=your-team-id
APPLE_ADS_KEY_ID=your-key-id
APPLE_ADS_PRIVATE_KEY_PATH=/path/to/private-key.pem
```

---

## 3. Architecture Backend Laravel

### 3.1 Structure des dossiers

```
laravel-aso/
├── app/
│   ├── Console/Commands/
│   │   ├── SyncKeywordPopularity.php    # CRON: maj popularités
│   │   └── ScrapeAppStoreRankings.php   # CRON: scrape rankings
│   │
│   ├── Http/Controllers/Api/
│   │   ├── AuthController.php           # Login/Register
│   │   ├── KeywordController.php        # CRUD keywords
│   │   ├── AppController.php            # CRUD apps à tracker
│   │   └── RankingController.php        # Historique rankings
│   │
│   ├── Models/
│   │   ├── User.php
│   │   ├── App.php                      # Apps trackées
│   │   ├── Keyword.php                  # Mots-clés
│   │   ├── KeywordPopularity.php        # Historique popularité
│   │   └── AppRanking.php               # Position app/keyword
│   │
│   ├── Services/
│   │   ├── AppleSearchAdsService.php    # Client API Apple
│   │   └── AppStoreScraperService.php   # Scraper rankings (iTunes)
│   │
│   └── Jobs/
│       ├── FetchKeywordPopularity.php   # Job queue
│       └── FetchAppRanking.php
│
├── config/
│   └── apple.php                        # Config API Apple
│
├── database/migrations/
│   ├── create_apps_table.php
│   ├── create_keywords_table.php
│   ├── create_tracked_keywords_table.php
│   ├── create_app_rankings_table.php
│   └── create_keyword_popularity_history_table.php
│
└── routes/
    └── api.php
```

### 3.2 Service Apple Search Ads

```php
// app/Services/AppleSearchAdsService.php
<?php

namespace App\Services;

use Firebase\JWT\JWT;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Cache;

class AppleSearchAdsService
{
    private string $clientId;
    private string $teamId;
    private string $keyId;
    private string $privateKey;

    public function __construct()
    {
        $this->clientId = config('apple.client_id');
        $this->teamId = config('apple.team_id');
        $this->keyId = config('apple.key_id');
        $this->privateKey = file_get_contents(config('apple.private_key_path'));
    }

    /**
     * Obtenir un access token (cached 1h)
     */
    private function getAccessToken(): string
    {
        return Cache::remember('apple_ads_token', 3500, function () {
            $payload = [
                'sub' => $this->clientId,
                'aud' => 'https://appleid.apple.com',
                'iat' => time(),
                'exp' => time() + 3600,
                'iss' => $this->teamId,
            ];

            $jwt = JWT::encode($payload, $this->privateKey, 'ES256', $this->keyId);

            $response = Http::asForm()->post('https://appleid.apple.com/auth/oauth2/token', [
                'grant_type' => 'client_credentials',
                'client_id' => $this->clientId,
                'client_secret' => $jwt,
                'scope' => 'searchadsorg',
            ]);

            return $response->json('access_token');
        });
    }

    /**
     * Récupérer la popularité d'un mot-clé (1-100)
     */
    public function getKeywordPopularity(string $keyword, string $storefront = 'US'): ?int
    {
        $token = $this->getAccessToken();

        $response = Http::withToken($token)
            ->withHeaders(['X-AP-Context' => "orgId={$this->teamId}"])
            ->post('https://api.searchads.apple.com/api/v4/keywords/targeting', [
                'keywords' => [$keyword],
                'matchType' => 'BROAD',
            ]);

        return $response->json('data.0.popularity');
    }

    /**
     * Récupérer la popularité de plusieurs mots-clés en batch
     */
    public function getKeywordsPopularity(array $keywords, string $storefront = 'US'): array
    {
        $token = $this->getAccessToken();

        // Max 1000 keywords par appel
        $chunks = array_chunk($keywords, 1000);
        $results = [];

        foreach ($chunks as $chunk) {
            $response = Http::withToken($token)
                ->withHeaders(['X-AP-Context' => "orgId={$this->teamId}"])
                ->post('https://api.searchads.apple.com/api/v4/keywords/targeting', [
                    'keywords' => $chunk,
                    'matchType' => 'BROAD',
                ]);

            foreach ($response->json('data', []) as $item) {
                $results[$item['keyword']] = $item['popularity'] ?? null;
            }
        }

        return $results;
    }
}
```

### 3.3 Service Scraping Rankings (iTunes API)

```php
// app/Services/AppStoreScraperService.php
<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class AppStoreScraperService
{
    /**
     * Chercher des apps sur l'App Store par mot-clé
     * Utilise l'API iTunes Search (gratuite, sans auth)
     */
    public function searchApps(string $keyword, string $country = 'us', int $limit = 100): array
    {
        $response = Http::get('https://itunes.apple.com/search', [
            'term' => $keyword,
            'country' => $country,
            'media' => 'software',
            'limit' => min($limit, 200), // Max 200
        ]);

        $results = $response->json('results', []);

        return collect($results)->map(fn ($app, $index) => [
            'position' => $index + 1,
            'apple_id' => (string) $app['trackId'],
            'name' => $app['trackName'],
            'bundle_id' => $app['bundleId'],
            'icon' => $app['artworkUrl100'],
            'developer' => $app['artistName'],
            'price' => $app['price'],
            'rating' => $app['averageUserRating'] ?? null,
            'rating_count' => $app['userRatingCount'] ?? 0,
        ])->toArray();
    }

    /**
     * Obtenir les détails d'une app par son Apple ID
     */
    public function getAppDetails(string $appleId, string $country = 'us'): ?array
    {
        $response = Http::get('https://itunes.apple.com/lookup', [
            'id' => $appleId,
            'country' => $country,
        ]);

        $results = $response->json('results', []);

        if (empty($results)) {
            return null;
        }

        $app = $results[0];

        return [
            'apple_id' => (string) $app['trackId'],
            'name' => $app['trackName'],
            'bundle_id' => $app['bundleId'],
            'icon' => $app['artworkUrl512'] ?? $app['artworkUrl100'],
            'developer' => $app['artistName'],
            'description' => $app['description'],
            'price' => $app['price'],
            'rating' => $app['averageUserRating'] ?? null,
            'rating_count' => $app['userRatingCount'] ?? 0,
            'version' => $app['version'],
            'release_date' => $app['releaseDate'],
        ];
    }

    /**
     * Trouver la position d'une app pour un mot-clé
     */
    public function getAppRankForKeyword(string $appleId, string $keyword, string $country = 'us'): ?int
    {
        $apps = $this->searchApps($keyword, $country, 200);

        foreach ($apps as $app) {
            if ($app['apple_id'] === $appleId) {
                return $app['position'];
            }
        }

        return null; // Pas dans le top 200
    }
}
```

### 3.4 Config Apple

```php
// config/apple.php
<?php

return [
    'client_id' => env('APPLE_ADS_CLIENT_ID'),
    'team_id' => env('APPLE_ADS_TEAM_ID'),
    'key_id' => env('APPLE_ADS_KEY_ID'),
    'private_key_path' => env('APPLE_ADS_PRIVATE_KEY_PATH'),
];
```

---

## 4. Schéma Base de Données

### 4.1 Tables

```sql
-- users (Laravel default + ajouts)
CREATE TABLE users (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    email_verified_at TIMESTAMP NULL,
    password VARCHAR(255) NOT NULL,
    subscription_tier ENUM('free', 'pro') DEFAULT 'free',
    subscription_ends_at TIMESTAMP NULL,
    remember_token VARCHAR(100) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- apps trackées par les utilisateurs
CREATE TABLE apps (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    apple_id VARCHAR(20) NOT NULL,           -- ex: "1234567890"
    bundle_id VARCHAR(255) NULL,             -- ex: "com.example.app"
    name VARCHAR(255) NOT NULL,
    icon_url VARCHAR(500) NULL,
    developer VARCHAR(255) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_app (user_id, apple_id)
);

-- mots-clés (partagés entre tous les users)
CREATE TABLE keywords (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    keyword VARCHAR(255) NOT NULL,
    storefront VARCHAR(5) NOT NULL DEFAULT 'US',  -- 'US', 'FR', 'GB', etc.
    popularity TINYINT UNSIGNED NULL,              -- 1-100 (Apple)
    popularity_updated_at TIMESTAMP NULL,
    created_at TIMESTAMP NULL,

    UNIQUE KEY unique_keyword_store (keyword, storefront),
    INDEX idx_popularity (popularity DESC)
);

-- keywords suivis par user/app
CREATE TABLE tracked_keywords (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    app_id BIGINT UNSIGNED NOT NULL,
    keyword_id BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NULL,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (app_id) REFERENCES apps(id) ON DELETE CASCADE,
    FOREIGN KEY (keyword_id) REFERENCES keywords(id) ON DELETE CASCADE,
    UNIQUE KEY unique_app_keyword (app_id, keyword_id)
);

-- historique des rankings (positions)
CREATE TABLE app_rankings (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    app_id BIGINT UNSIGNED NOT NULL,
    keyword_id BIGINT UNSIGNED NOT NULL,
    position SMALLINT UNSIGNED NULL,          -- 1-200 ou NULL si pas classé
    recorded_at DATE NOT NULL,

    FOREIGN KEY (app_id) REFERENCES apps(id) ON DELETE CASCADE,
    FOREIGN KEY (keyword_id) REFERENCES keywords(id) ON DELETE CASCADE,
    UNIQUE KEY unique_ranking (app_id, keyword_id, recorded_at),
    INDEX idx_app_date (app_id, recorded_at),
    INDEX idx_keyword_date (keyword_id, recorded_at)
);

-- historique popularité (pour graphiques)
CREATE TABLE keyword_popularity_history (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    keyword_id BIGINT UNSIGNED NOT NULL,
    popularity TINYINT UNSIGNED NOT NULL,
    recorded_at DATE NOT NULL,

    FOREIGN KEY (keyword_id) REFERENCES keywords(id) ON DELETE CASCADE,
    UNIQUE KEY unique_history (keyword_id, recorded_at)
);
```

### 4.2 Migrations Laravel

```php
// database/migrations/2024_01_01_000001_create_apps_table.php
Schema::create('apps', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id')->constrained()->cascadeOnDelete();
    $table->string('apple_id', 20);
    $table->string('bundle_id')->nullable();
    $table->string('name');
    $table->string('icon_url', 500)->nullable();
    $table->string('developer')->nullable();
    $table->timestamps();

    $table->unique(['user_id', 'apple_id']);
});

// database/migrations/2024_01_01_000002_create_keywords_table.php
Schema::create('keywords', function (Blueprint $table) {
    $table->id();
    $table->string('keyword');
    $table->string('storefront', 5)->default('US');
    $table->unsignedTinyInteger('popularity')->nullable();
    $table->timestamp('popularity_updated_at')->nullable();
    $table->timestamp('created_at')->nullable();

    $table->unique(['keyword', 'storefront']);
    $table->index('popularity');
});

// database/migrations/2024_01_01_000003_create_tracked_keywords_table.php
Schema::create('tracked_keywords', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id')->constrained()->cascadeOnDelete();
    $table->foreignId('app_id')->constrained()->cascadeOnDelete();
    $table->foreignId('keyword_id')->constrained()->cascadeOnDelete();
    $table->timestamp('created_at')->nullable();

    $table->unique(['app_id', 'keyword_id']);
});

// database/migrations/2024_01_01_000004_create_app_rankings_table.php
Schema::create('app_rankings', function (Blueprint $table) {
    $table->id();
    $table->foreignId('app_id')->constrained()->cascadeOnDelete();
    $table->foreignId('keyword_id')->constrained()->cascadeOnDelete();
    $table->unsignedSmallInteger('position')->nullable();
    $table->date('recorded_at');

    $table->unique(['app_id', 'keyword_id', 'recorded_at']);
    $table->index(['app_id', 'recorded_at']);
    $table->index(['keyword_id', 'recorded_at']);
});

// database/migrations/2024_01_01_000005_create_keyword_popularity_history_table.php
Schema::create('keyword_popularity_history', function (Blueprint $table) {
    $table->id();
    $table->foreignId('keyword_id')->constrained()->cascadeOnDelete();
    $table->unsignedTinyInteger('popularity');
    $table->date('recorded_at');

    $table->unique(['keyword_id', 'recorded_at']);
});
```

### 4.3 Diagramme ERD

```
┌──────────────┐       ┌──────────────────┐       ┌──────────────┐
│    users     │       │  tracked_keywords │       │   keywords   │
├──────────────┤       ├──────────────────┤       ├──────────────┤
│ id           │──┐    │ id               │    ┌──│ id           │
│ name         │  │    │ user_id       ○──┼────┘  │ keyword      │
│ email        │  └───○┼─app_id           │       │ storefront   │
│ password     │       │ keyword_id    ○──┼───────│ popularity   │
│ subscription │       │ created_at       │       │ updated_at   │
└──────────────┘       └──────────────────┘       └──────┬───────┘
       │                                                  │
       │               ┌──────────────────┐               │
       │               │   app_rankings   │               │
       │               ├──────────────────┤               │
       │               │ id               │               │
       │               │ app_id        ○──┼───┐           │
       │               │ keyword_id    ○──┼───┼───────────┘
       │               │ position         │   │
       │               │ recorded_at      │   │
       │               └──────────────────┘   │
       │                                      │
       │               ┌──────────────────┐   │
       │               │      apps        │   │
       │               ├──────────────────┤   │
       └──────────────○┼─user_id          │   │
                       │ id            ───┼───┘
                       │ apple_id         │
                       │ name             │
                       │ icon_url         │
                       └──────────────────┘
```

---

## 5. Architecture Frontend Flutter

### 5.1 Structure des dossiers

```
flutter_aso/
├── lib/
│   ├── main.dart
│   │
│   ├── core/
│   │   ├── api/
│   │   │   ├── api_client.dart          # Dio HTTP client
│   │   │   ├── api_endpoints.dart       # Constantes URL
│   │   │   └── api_interceptors.dart    # Auth interceptor
│   │   ├── router/
│   │   │   └── app_router.dart          # GoRouter config
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   └── app_typography.dart
│   │   └── utils/
│   │       └── extensions.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── auth_repository.dart
│   │   │   │   └── auth_local_storage.dart
│   │   │   ├── domain/
│   │   │   │   └── user_model.dart
│   │   │   ├── presentation/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   └── providers/
│   │   │       └── auth_provider.dart
│   │   │
│   │   ├── apps/
│   │   │   ├── data/
│   │   │   │   └── apps_repository.dart
│   │   │   ├── domain/
│   │   │   │   └── app_model.dart
│   │   │   ├── presentation/
│   │   │   │   ├── apps_list_screen.dart
│   │   │   │   ├── app_detail_screen.dart
│   │   │   │   └── add_app_screen.dart
│   │   │   └── providers/
│   │   │       └── apps_provider.dart
│   │   │
│   │   ├── keywords/
│   │   │   ├── data/
│   │   │   │   └── keywords_repository.dart
│   │   │   ├── domain/
│   │   │   │   └── keyword_model.dart
│   │   │   ├── presentation/
│   │   │   │   ├── keywords_screen.dart
│   │   │   │   ├── keyword_search_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── keyword_tile.dart
│   │   │   │       ├── popularity_badge.dart
│   │   │   │       └── keyword_suggestions.dart
│   │   │   └── providers/
│   │   │       └── keywords_provider.dart
│   │   │
│   │   ├── rankings/
│   │   │   ├── data/
│   │   │   │   └── rankings_repository.dart
│   │   │   ├── domain/
│   │   │   │   └── ranking_model.dart
│   │   │   ├── presentation/
│   │   │   │   ├── rankings_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── ranking_chart.dart
│   │   │   │       └── ranking_change_indicator.dart
│   │   │   └── providers/
│   │   │       └── rankings_provider.dart
│   │   │
│   │   ├── dashboard/
│   │   │   └── presentation/
│   │   │       ├── dashboard_screen.dart
│   │   │       └── widgets/
│   │   │           ├── stats_card.dart
│   │   │           └── movers_list.dart
│   │   │
│   │   └── settings/
│   │       └── presentation/
│   │           └── settings_screen.dart
│   │
│   └── shared/
│       ├── models/
│       │   └── pagination.dart
│       └── widgets/
│           ├── loading_indicator.dart
│           ├── error_view.dart
│           ├── empty_state.dart
│           └── app_icon.dart
│
├── assets/
│   ├── images/
│   └── fonts/
│
├── pubspec.yaml
└── test/
```

### 5.2 Packages recommandés

```yaml
# pubspec.yaml
name: keyrank
description: Track your App Store rankings
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0

  # HTTP & API
  dio: ^5.4.0
  retrofit: ^4.0.0

  # Routing
  go_router: ^13.0.0

  # Storage
  shared_preferences: ^2.2.0
  flutter_secure_storage: ^9.0.0

  # UI Components
  fl_chart: ^0.66.0              # Graphiques rankings
  shimmer: ^3.0.0                # Loading skeletons
  cached_network_image: ^3.3.0   # Cache images (icônes apps)
  flutter_svg: ^2.0.0

  # Forms & Validation
  reactive_forms: ^16.0.0

  # Utils
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0
  intl: ^0.18.0                  # Formatting dates/numbers

  # Platform specific
  url_launcher: ^6.2.0
  package_info_plus: ^5.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  retrofit_generator: ^8.0.0
  riverpod_generator: ^2.3.0
```

### 5.3 Modèles de données

```dart
// lib/features/keywords/domain/keyword_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'keyword_model.freezed.dart';
part 'keyword_model.g.dart';

@freezed
class Keyword with _$Keyword {
  const factory Keyword({
    required int id,
    required String keyword,
    required String storefront,
    int? popularity,
    DateTime? popularityUpdatedAt,
  }) = _Keyword;

  factory Keyword.fromJson(Map<String, dynamic> json) => _$KeywordFromJson(json);
}

@freezed
class AppRanking with _$AppRanking {
  const factory AppRanking({
    required int id,
    required int appId,
    required int keywordId,
    required String keyword,
    int? position,
    int? previousPosition,
    required DateTime recordedAt,
  }) = _AppRanking;

  factory AppRanking.fromJson(Map<String, dynamic> json) => _$AppRankingFromJson(json);

  // Helper pour calculer le changement
  int? get change {
    if (position == null || previousPosition == null) return null;
    return previousPosition! - position!; // Positif = amélioration
  }
}
```

---

## 6. Endpoints API

### 6.1 Vue d'ensemble

```
BASE URL: https://api.votreapp.com/v1

┌─────────────────────────────────────────────────────────────────┐
│ AUTH                                                            │
├─────────────────────────────────────────────────────────────────┤
│ POST   /auth/register        Créer un compte                    │
│ POST   /auth/login           Connexion → token JWT              │
│ POST   /auth/logout          Déconnexion                        │
│ POST   /auth/refresh         Rafraîchir le token                │
│ GET    /auth/me              Profil utilisateur                 │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ APPS                                                            │
├─────────────────────────────────────────────────────────────────┤
│ GET    /apps                 Liste mes apps trackées            │
│ POST   /apps                 Ajouter une app (par Apple ID)     │
│ GET    /apps/{id}            Détails d'une app                  │
│ DELETE /apps/{id}            Supprimer une app                  │
│ GET    /apps/search?q=       Chercher une app sur l'App Store   │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ KEYWORDS                                                        │
├─────────────────────────────────────────────────────────────────┤
│ GET    /keywords?q=&store=   Chercher un mot-clé + popularité   │
│ GET    /keywords/suggestions?app_id=  Suggestions pour une app  │
│ GET    /keywords/{id}        Détails d'un mot-clé               │
│ GET    /keywords/{id}/history?days=30  Historique popularité    │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ TRACKED KEYWORDS (par app)                                      │
├─────────────────────────────────────────────────────────────────┤
│ GET    /apps/{id}/keywords           Liste keywords trackés     │
│ POST   /apps/{id}/keywords           Ajouter keyword à tracker  │
│ DELETE /apps/{id}/keywords/{kid}     Arrêter de tracker         │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ RANKINGS                                                        │
├─────────────────────────────────────────────────────────────────┤
│ GET    /apps/{id}/rankings           Rankings actuels           │
│ GET    /apps/{id}/rankings/history?keyword_id=&days=30          │
│                                      Historique positions       │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DASHBOARD                                                       │
├─────────────────────────────────────────────────────────────────┤
│ GET    /dashboard/overview   Stats globales (nb apps, keywords) │
│ GET    /dashboard/movers     Keywords qui ont bougé (↑↓)        │
└─────────────────────────────────────────────────────────────────┘
```

### 6.2 Exemples de réponses

```json
// GET /apps/{id}/rankings
{
  "data": [
    {
      "id": 1,
      "keyword": "habit tracker",
      "storefront": "US",
      "popularity": 45,
      "position": 12,
      "previous_position": 15,
      "change": 3,
      "recorded_at": "2024-01-15"
    },
    {
      "id": 2,
      "keyword": "daily habits",
      "storefront": "US",
      "popularity": 38,
      "position": 8,
      "previous_position": 8,
      "change": 0,
      "recorded_at": "2024-01-15"
    }
  ],
  "meta": {
    "total": 25,
    "per_page": 20,
    "current_page": 1
  }
}

// GET /keywords?q=fitness
{
  "data": [
    {
      "id": 1,
      "keyword": "fitness tracker",
      "storefront": "US",
      "popularity": 67,
      "popularity_updated_at": "2024-01-14T03:00:00Z"
    },
    {
      "id": 2,
      "keyword": "fitness app",
      "storefront": "US",
      "popularity": 72,
      "popularity_updated_at": "2024-01-14T03:00:00Z"
    }
  ]
}
```

---

## 7. CRON Jobs & Synchronisation

### 7.1 Scheduler Laravel

```php
// app/Console/Kernel.php
<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    protected function schedule(Schedule $schedule): void
    {
        // Mise à jour popularité keywords (1x/jour, la nuit)
        // Traite tous les keywords qui n'ont pas été mis à jour depuis 7 jours
        $schedule->command('aso:sync-popularity')
            ->dailyAt('03:00')
            ->withoutOverlapping()
            ->runInBackground();

        // Scrape rankings App Store (1x/jour)
        // Récupère la position de chaque app sur ses keywords trackés
        $schedule->command('aso:scrape-rankings')
            ->dailyAt('04:00')
            ->withoutOverlapping()
            ->runInBackground();

        // Cleanup vieilles données (> 90 jours)
        $schedule->command('aso:cleanup-history')
            ->weeklyOn(1, '05:00'); // Lundi 5h

        // Health check API Apple
        $schedule->command('aso:health-check')
            ->hourly();
    }
}
```

### 7.2 Commande de sync popularité

```php
// app/Console/Commands/SyncKeywordPopularity.php
<?php

namespace App\Console\Commands;

use App\Models\Keyword;
use App\Models\KeywordPopularityHistory;
use App\Services\AppleSearchAdsService;
use Illuminate\Console\Command;
use Illuminate\Support\Carbon;

class SyncKeywordPopularity extends Command
{
    protected $signature = 'aso:sync-popularity {--limit=1000}';
    protected $description = 'Sync keyword popularity from Apple Search Ads';

    public function handle(AppleSearchAdsService $appleService): int
    {
        $limit = $this->option('limit');

        // Keywords pas mis à jour depuis 7 jours
        $keywords = Keyword::query()
            ->where(function ($q) {
                $q->whereNull('popularity_updated_at')
                  ->orWhere('popularity_updated_at', '<', Carbon::now()->subDays(7));
            })
            ->limit($limit)
            ->get();

        if ($keywords->isEmpty()) {
            $this->info('No keywords to update.');
            return 0;
        }

        $this->info("Updating {$keywords->count()} keywords...");

        // Grouper par storefront
        $grouped = $keywords->groupBy('storefront');

        foreach ($grouped as $storefront => $storeKeywords) {
            $keywordTexts = $storeKeywords->pluck('keyword')->toArray();

            try {
                $popularities = $appleService->getKeywordsPopularity($keywordTexts, $storefront);

                foreach ($storeKeywords as $keyword) {
                    $popularity = $popularities[$keyword->keyword] ?? null;

                    if ($popularity !== null) {
                        // Update keyword
                        $keyword->update([
                            'popularity' => $popularity,
                            'popularity_updated_at' => now(),
                        ]);

                        // Save history
                        KeywordPopularityHistory::updateOrCreate(
                            ['keyword_id' => $keyword->id, 'recorded_at' => today()],
                            ['popularity' => $popularity]
                        );
                    }
                }

                $this->info("Updated {$storeKeywords->count()} keywords for {$storefront}");

            } catch (\Exception $e) {
                $this->error("Error for {$storefront}: {$e->getMessage()}");
            }

            // Rate limiting - pause entre les stores
            sleep(2);
        }

        return 0;
    }
}
```

### 7.3 Commande de scrape rankings

```php
// app/Console/Commands/ScrapeAppStoreRankings.php
<?php

namespace App\Console\Commands;

use App\Models\App;
use App\Models\AppRanking;
use App\Models\TrackedKeyword;
use App\Services\AppStoreScraperService;
use Illuminate\Console\Command;

class ScrapeAppStoreRankings extends Command
{
    protected $signature = 'aso:scrape-rankings';
    protected $description = 'Scrape App Store rankings for all tracked keywords';

    public function handle(AppStoreScraperService $scraper): int
    {
        // Tous les keywords trackés avec leur app
        $tracked = TrackedKeyword::with(['app', 'keyword'])->get();

        $this->info("Scraping rankings for {$tracked->count()} tracked keywords...");

        $bar = $this->output->createProgressBar($tracked->count());

        foreach ($tracked as $item) {
            $position = $scraper->getAppRankForKeyword(
                $item->app->apple_id,
                $item->keyword->keyword,
                $item->keyword->storefront
            );

            AppRanking::updateOrCreate(
                [
                    'app_id' => $item->app_id,
                    'keyword_id' => $item->keyword_id,
                    'recorded_at' => today(),
                ],
                ['position' => $position]
            );

            $bar->advance();

            // Rate limiting - éviter de surcharger iTunes
            usleep(500000); // 0.5 seconde
        }

        $bar->finish();
        $this->newLine();
        $this->info('Done!');

        return 0;
    }
}
```

---

## 8. Sources de données

### 8.1 Récapitulatif

| Donnée | Source | API | Auth requise | Coût |
|--------|--------|-----|--------------|------|
| Popularité keywords | Apple Search Ads | Campaign Management API | OAuth 2 (votre compte) | Gratuit |
| Rankings apps | iTunes | iTunes Search API | Non | Gratuit |
| Détails app | iTunes | iTunes Lookup API | Non | Gratuit |
| Suggestions keywords | Votre BDD | Crowd-sourcé | - | - |

### 8.2 Limitations connues

**Apple Search Ads API:**
- Rate limits (non documentés précisément, ~100-500 req/heure estimé)
- Popularité = score relatif (1-100), pas le volume exact de recherches
- Disponible dans ~60 pays où Apple Ads est actif

**iTunes Search API:**
- Max 200 résultats par recherche
- Pas de pagination
- Résultats peuvent varier légèrement de l'App Store réel
- Rate limits généreux mais non documentés

### 8.3 Stratégie de cache

```
┌─────────────────────────────────────────────────────────────┐
│                    STRATÉGIE DE CACHE                       │
├─────────────────────────────────────────────────────────────┤
│ Donnée              │ TTL        │ Stockage                 │
├─────────────────────────────────────────────────────────────┤
│ Token Apple OAuth   │ 1 heure    │ Redis                    │
│ Popularité keyword  │ 7 jours    │ MySQL + Redis (1 jour)   │
│ Rankings            │ 24 heures  │ MySQL                    │
│ Détails app         │ 24 heures  │ Redis                    │
│ Recherche apps      │ 1 heure    │ Redis                    │
└─────────────────────────────────────────────────────────────┘
```

---

## Ressources

- [Apple Search Ads API Documentation](https://developer.apple.com/documentation/apple_search_ads)
- [iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/)
- [Laravel Documentation](https://laravel.com/docs)
- [Flutter Documentation](https://docs.flutter.dev)
