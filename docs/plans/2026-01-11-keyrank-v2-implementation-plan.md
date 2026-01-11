# Keyrank v2 — Plan d'Implémentation Exhaustif

> Plan détaillé pour transformer Keyrank en concurrent d'AppFigures.
> Chaque tâche est atomique, estimée, et a ses dépendances listées.

**Date** : 11 janvier 2026
**Référence** : [Design Document](./2026-01-11-keyrank-v2-design.md)

---

## Table des matières

- [Phase 0: Fondations](#phase-0-fondations)
- [Phase 1: Onboarding & Intégrations](#phase-1-onboarding--intégrations)
- [Phase 2: Dashboard & Visualisations](#phase-2-dashboard--visualisations)
- [Phase 3: Deep Data Collection](#phase-3-deep-data-collection)
- [Phase 4: Intelligence IA](#phase-4-intelligence-ia)
- [Phase 5: Polish & Scale](#phase-5-polish--scale)
- [Dépendances entre phases](#dépendances-entre-phases)
- [Risques et mitigations](#risques-et-mitigations)

---

## Phase 0: Fondations

> **Objectif** : Préparer l'infrastructure pour le nouveau modèle de données.
> **Prérequis** : Aucun
> **Bloque** : Toutes les autres phases

### 0.1 Refactoring Backend - Suppression fetch on-demand

#### 0.1.1 Audit des controllers existants

- [ ] **0.1.1.1** Lister tous les controllers qui font des appels API externes
  - Fichiers concernés : `api/app/Http/Controllers/Api/`
  - Chercher : `Http::get`, `Http::post`, appels iTunes/Google
  - Output : Liste des endpoints à refactorer

- [ ] **0.1.1.2** Documenter le comportement actuel de chaque endpoint
  - Pour chaque controller identifié :
    - Quand fetch-t-il ? (staleness check, à la demande)
    - Quelles données ?
    - Quelle API externe ?

- [ ] **0.1.1.3** Identifier les dépendances frontend → backend
  - Quels écrans Flutter appellent ces endpoints ?
  - Quel comportement attendu si données pas encore collectées ?

#### 0.1.2 Refactoring RatingsController

- [ ] **0.1.2.1** Créer nouvelle version du controller (lecture seule)
  ```php
  // Avant: fetch si stale
  // Après: lecture DB uniquement
  ```
  - Fichier : `api/app/Http/Controllers/Api/RatingsController.php`
  - Supprimer : logique de staleness check
  - Supprimer : appels iTunes/Google Play
  - Garder : lecture DB, formatage réponse

- [ ] **0.1.2.2** Ajouter champ `data_available` dans la réponse
  ```json
  {
    "data": [...],
    "meta": {
      "last_sync": "2026-01-11T10:00:00Z",
      "data_available": true
    }
  }
  ```

- [ ] **0.1.2.3** Gérer le cas "pas encore de données"
  - Retourner 200 avec `data: []` et `data_available: false`
  - Frontend affichera "Données en cours de collecte..."

#### 0.1.3 Refactoring RankingsController

- [ ] **0.1.3.1** Supprimer fetch on-demand des rankings
  - Fichier : `api/app/Http/Controllers/Api/RankingsController.php`

- [ ] **0.1.3.2** Optimiser requête historique rankings
  ```php
  // Utiliser les aggregates pour périodes > 30 jours
  if ($period > 30) {
      return $this->getFromAggregates($appId, $keywordId, $period);
  }
  ```

- [ ] **0.1.3.3** Ajouter endpoint rankings movers
  ```
  GET /api/rankings/movers?period=7d
  Response: { improving: [...], declining: [...] }
  ```

#### 0.1.4 Refactoring ReviewsController

- [ ] **0.1.4.1** Supprimer sync on-demand des reviews
  - Fichier : `api/app/Http/Controllers/Api/ReviewsController.php`

- [ ] **0.1.4.2** Ajouter filtres avancés
  ```
  GET /api/reviews?sentiment=negative&has_reply=false&min_rating=1&max_rating=3
  ```

- [ ] **0.1.4.3** Ajouter pagination cursor-based
  - Pour de meilleures perfs sur grandes listes

#### 0.1.5 Refactoring KeywordsController

- [ ] **0.1.5.1** Supprimer fetch popularity on-demand

- [ ] **0.1.5.2** Ajouter endpoint suggestions amélioré
  ```
  GET /api/keywords/suggestions?app_id=123&source=trending|competitors|metadata
  ```

- [ ] **0.1.5.3** Ajouter endpoint bulk operations
  ```
  POST /api/keywords/bulk
  Body: { action: "add|delete|tag", keyword_ids: [...], tag?: "..." }
  ```

---

### 0.2 Nouvelles tables et migrations

#### 0.2.1 Table `integrations`

- [ ] **0.2.1.1** Créer migration
  ```bash
  php artisan make:migration create_integrations_table
  ```

  ```php
  Schema::create('integrations', function (Blueprint $table) {
      $table->id();
      $table->foreignId('user_id')->constrained()->cascadeOnDelete();
      $table->enum('type', [
          'app_store_connect',
          'google_play_console',
          'apple_search_ads',
          'stripe',
          'slack',
          'webhook'
      ]);
      $table->enum('status', ['pending', 'active', 'error', 'revoked'])->default('pending');
      $table->json('credentials')->nullable(); // Encrypted
      $table->json('metadata')->nullable();
      $table->timestamp('last_sync_at')->nullable();
      $table->text('error_message')->nullable();
      $table->timestamps();

      $table->unique(['user_id', 'type']);
  });
  ```

- [ ] **0.2.1.2** Créer model `Integration`
  ```php
  // Avec cast encrypted pour credentials
  protected $casts = [
      'credentials' => 'encrypted:array',
      'metadata' => 'array',
  ];
  ```

- [ ] **0.2.1.3** Créer IntegrationPolicy pour autorisation

#### 0.2.2 Modification table `user_apps` (pivot)

- [ ] **0.2.2.1** Créer migration modification
  ```php
  Schema::table('user_apps', function (Blueprint $table) {
      $table->enum('ownership_type', ['owned', 'watched'])->default('watched');
      $table->foreignId('integration_id')->nullable()->constrained()->nullOnDelete();
      $table->string('tag', 50)->nullable(); // competitor, inspiration, benchmark
      $table->boolean('is_favorite')->default(false);
      $table->timestamp('added_at')->useCurrent();
  });
  ```

- [ ] **0.2.2.2** Migrer données existantes
  ```php
  // Toutes les apps existantes deviennent "watched" par défaut
  // Sauf si l'user les a créées (is_owner = true) → "owned"
  DB::table('user_apps')
      ->where('is_owner', true)
      ->update(['ownership_type' => 'owned']);
  ```

#### 0.2.3 Table `app_insights`

- [ ] **0.2.3.1** Créer migration
  ```php
  Schema::create('app_insights', function (Blueprint $table) {
      $table->id();
      $table->foreignId('user_id')->constrained()->cascadeOnDelete();
      $table->foreignId('app_id')->nullable()->constrained()->cascadeOnDelete();
      $table->enum('type', [
          'opportunity', 'warning', 'win',
          'competitor_move', 'theme', 'suggestion'
      ]);
      $table->enum('priority', ['high', 'medium', 'low'])->default('medium');
      $table->string('title', 255);
      $table->text('description');
      $table->string('action_text', 255)->nullable();
      $table->string('action_url', 500)->nullable();
      $table->json('data_refs')->nullable();
      $table->boolean('is_read')->default(false);
      $table->boolean('is_dismissed')->default(false);
      $table->timestamp('generated_at')->useCurrent();
      $table->timestamp('expires_at')->nullable();

      $table->index(['user_id', 'is_read', 'is_dismissed', 'generated_at']);
  });
  ```

- [ ] **0.2.3.2** Créer model `AppInsight`

#### 0.2.4 Tables chat

- [ ] **0.2.4.1** Créer migration `chat_conversations`
  ```php
  Schema::create('chat_conversations', function (Blueprint $table) {
      $table->id();
      $table->foreignId('user_id')->constrained()->cascadeOnDelete();
      $table->foreignId('app_id')->nullable()->constrained()->nullOnDelete();
      $table->string('title', 255)->nullable();
      $table->timestamps();
  });
  ```

- [ ] **0.2.4.2** Créer migration `chat_messages`
  ```php
  Schema::create('chat_messages', function (Blueprint $table) {
      $table->id();
      $table->foreignId('conversation_id')->constrained('chat_conversations')->cascadeOnDelete();
      $table->enum('role', ['user', 'assistant']);
      $table->text('content');
      $table->json('context_data')->nullable();
      $table->integer('tokens_used')->nullable();
      $table->timestamp('created_at')->useCurrent();
  });
  ```

- [ ] **0.2.4.3** Créer models `ChatConversation` et `ChatMessage`

#### 0.2.5 Tables aggregates (si pas existantes)

- [ ] **0.2.5.1** Vérifier existence `app_ranking_aggregates`
  - Si manquante, créer migration

- [ ] **0.2.5.2** Vérifier existence `app_rating_aggregates`
  - Si manquante, créer migration

- [ ] **0.2.5.3** Créer `keyword_popularity_aggregates` si manquante

#### 0.2.6 Enrichissement table `app_reviews`

- [ ] **0.2.6.1** Ajouter colonnes enrichissement
  ```php
  Schema::table('app_reviews', function (Blueprint $table) {
      $table->enum('sentiment', ['positive', 'negative', 'neutral', 'mixed'])->nullable();
      $table->decimal('sentiment_score', 3, 2)->nullable(); // -1.00 to 1.00
      $table->json('themes')->nullable();
      $table->string('language', 10)->nullable();
      $table->timestamp('enriched_at')->nullable();
  });
  ```

- [ ] **0.2.6.2** Ajouter index pour queries fréquentes
  ```php
  $table->index(['app_id', 'sentiment', 'review_date']);
  $table->index(['app_id', 'has_reply', 'rating']);
  ```

#### 0.2.7 Table `job_executions` (monitoring)

- [ ] **0.2.7.1** Créer migration
  ```php
  Schema::create('job_executions', function (Blueprint $table) {
      $table->id();
      $table->string('job_name', 100);
      $table->enum('status', ['running', 'completed', 'failed']);
      $table->integer('items_processed')->default(0);
      $table->integer('items_failed')->default(0);
      $table->text('error_message')->nullable();
      $table->timestamp('started_at');
      $table->timestamp('completed_at')->nullable();
      $table->integer('duration_ms')->nullable();

      $table->index(['job_name', 'started_at']);
  });
  ```

---

### 0.3 Partitionnement des tables volumineuses

#### 0.3.1 Partitionnement `app_rankings`

- [ ] **0.3.1.1** Analyser volume actuel
  ```sql
  SELECT COUNT(*) FROM app_rankings;
  SELECT MIN(recorded_at), MAX(recorded_at) FROM app_rankings;
  ```

- [ ] **0.3.1.2** Créer nouvelle table partitionnée
  ```sql
  CREATE TABLE app_rankings_partitioned (
      id BIGINT AUTO_INCREMENT,
      app_id INT NOT NULL,
      keyword_id INT NOT NULL,
      position SMALLINT,
      recorded_at TIMESTAMP NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (id, recorded_at),
      INDEX idx_app_keyword_date (app_id, keyword_id, recorded_at)
  ) PARTITION BY RANGE (UNIX_TIMESTAMP(recorded_at)) (
      PARTITION p_2025_01 VALUES LESS THAN (UNIX_TIMESTAMP('2025-02-01')),
      PARTITION p_2025_02 VALUES LESS THAN (UNIX_TIMESTAMP('2025-03-01')),
      -- ... générer pour chaque mois
      PARTITION p_2026_01 VALUES LESS THAN (UNIX_TIMESTAMP('2026-02-01')),
      PARTITION p_2026_02 VALUES LESS THAN (UNIX_TIMESTAMP('2026-03-01')),
      PARTITION p_future VALUES LESS THAN MAXVALUE
  );
  ```

- [ ] **0.3.1.3** Migrer données vers nouvelle table
  ```sql
  INSERT INTO app_rankings_partitioned
  SELECT * FROM app_rankings;
  ```

- [ ] **0.3.1.4** Renommer tables (swap)
  ```sql
  RENAME TABLE app_rankings TO app_rankings_old,
               app_rankings_partitioned TO app_rankings;
  ```

- [ ] **0.3.1.5** Créer job maintenance partitions
  ```php
  // Ajouter nouvelle partition chaque mois
  // Archiver partitions > 90 jours
  ```

#### 0.3.2 Partitionnement `app_ratings`

- [ ] **0.3.2.1** Même process que rankings
- [ ] **0.3.2.2** Partitionnement par mois

#### 0.3.3 Partitionnement `app_reviews`

- [ ] **0.3.3.1** Partitionnement par mois sur `review_date`

---

### 0.4 Infrastructure Collectors

#### 0.4.1 Base class collector

- [ ] **0.4.1.1** Créer `app/Jobs/Collectors/BaseCollector.php`
  ```php
  <?php

  namespace App\Jobs\Collectors;

  use Illuminate\Bus\Queueable;
  use Illuminate\Contracts\Queue\ShouldQueue;
  use Illuminate\Foundation\Bus\Dispatchable;
  use Illuminate\Queue\InteractsWithQueue;
  use Illuminate\Queue\SerializesModels;
  use Illuminate\Support\Collection;
  use App\Models\JobExecution;

  abstract class BaseCollector implements ShouldQueue
  {
      use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

      protected int $rateLimitMs = 300;
      protected int $batchSize = 50;
      protected int $maxRetries = 3;
      protected ?JobExecution $execution = null;

      abstract public function getCollectorName(): string;
      abstract public function getItems(): Collection;
      abstract public function processItem($item): void;

      public function handle(): void
      {
          $this->startExecution();

          try {
              $items = $this->getItems();

              foreach ($items as $item) {
                  try {
                      $this->processItem($item);
                      $this->execution->increment('items_processed');
                      usleep($this->rateLimitMs * 1000);
                  } catch (\Exception $e) {
                      $this->handleItemError($item, $e);
                  }
              }

              $this->completeExecution('completed');
          } catch (\Exception $e) {
              $this->completeExecution('failed', $e->getMessage());
              throw $e;
          }
      }

      protected function startExecution(): void
      {
          $this->execution = JobExecution::create([
              'job_name' => $this->getCollectorName(),
              'status' => 'running',
              'started_at' => now(),
          ]);
      }

      protected function completeExecution(string $status, ?string $error = null): void
      {
          $this->execution->update([
              'status' => $status,
              'error_message' => $error,
              'completed_at' => now(),
              'duration_ms' => now()->diffInMilliseconds($this->execution->started_at),
          ]);
      }

      protected function handleItemError($item, \Exception $e): void
      {
          $this->execution->increment('items_failed');
          \Log::error("[{$this->getCollectorName()}] Error processing item", [
              'item' => $item,
              'error' => $e->getMessage(),
          ]);
      }
  }
  ```

- [ ] **0.4.1.2** Créer interface `CollectorInterface`

#### 0.4.2 Configuration queue

- [ ] **0.4.2.1** Configurer queue dédiée `collectors`
  ```php
  // config/queue.php
  'connections' => [
      'redis' => [
          'driver' => 'redis',
          'connection' => 'default',
          'queue' => env('REDIS_QUEUE', 'default'),
          'retry_after' => 90,
          'block_for' => null,
      ],
  ],
  ```

- [ ] **0.4.2.2** Configurer worker supervisor
  ```ini
  # /etc/supervisor/conf.d/keyrank-collectors.conf
  [program:keyrank-collectors]
  process_name=%(program_name)s_%(process_num)02d
  command=php /var/www/keyrank/artisan queue:work redis --queue=collectors --sleep=3 --tries=3 --max-time=3600
  autostart=true
  autorestart=true
  stopasgroup=true
  killasgroup=true
  numprocs=2
  ```

#### 0.4.3 Scheduler setup

- [ ] **0.4.3.1** Configurer schedule dans `app/Console/Kernel.php`
  ```php
  protected function schedule(Schedule $schedule): void
  {
      // Collectors
      $schedule->job(new RankingsCollector)->everyTwoHours();
      $schedule->job(new RatingsCollector)->everySixHours();
      $schedule->job(new ReviewsCollector)->everyFourHours();
      $schedule->job(new TopChartsCollector)->everySixHours();
      $schedule->job(new MetadataCollector)->dailyAt('00:00');
      $schedule->job(new SalesCollector)->dailyAt('06:00');
      $schedule->job(new PopularityCollector)->dailyAt('03:00');

      // Processing
      $schedule->job(new EnrichmentJob)->hourly();
      $schedule->job(new InsightGeneratorJob)->dailyAt('08:00');
      $schedule->job(new AggregatorJob)->dailyAt('01:00');

      // Maintenance
      $schedule->job(new CleanupJob)->weeklyOn(0, '02:00');
      $schedule->job(new PartitionMaintenanceJob)->monthlyOn(1, '03:00');

      // Notifications
      $schedule->job(new WeeklyDigestJob)->weeklyOn(1, '09:00');
  }
  ```

---

### 0.5 Services API externes

#### 0.5.1 App Store Connect API Service

- [ ] **0.5.1.1** Créer `app/Services/AppStoreConnect/AppStoreConnectService.php`
  ```php
  <?php

  namespace App\Services\AppStoreConnect;

  use Firebase\JWT\JWT;
  use Illuminate\Support\Facades\Http;
  use Illuminate\Support\Facades\Cache;

  class AppStoreConnectService
  {
      private string $keyId;
      private string $issuerId;
      private string $privateKey;
      private string $baseUrl = 'https://api.appstoreconnect.apple.com/v1';

      public function __construct(array $credentials)
      {
          $this->keyId = $credentials['key_id'];
          $this->issuerId = $credentials['issuer_id'];
          $this->privateKey = $credentials['private_key'];
      }

      public function generateToken(): string
      {
          $cacheKey = "asc_token_{$this->keyId}";

          return Cache::remember($cacheKey, 1000, function () {
              $header = ['alg' => 'ES256', 'kid' => $this->keyId, 'typ' => 'JWT'];
              $payload = [
                  'iss' => $this->issuerId,
                  'iat' => time(),
                  'exp' => time() + 1200, // 20 minutes
                  'aud' => 'appstoreconnect-v1',
              ];

              return JWT::encode($payload, $this->privateKey, 'ES256', null, $header);
          });
      }

      public function listApps(): array
      {
          $response = Http::withToken($this->generateToken())
              ->get("{$this->baseUrl}/apps", [
                  'fields[apps]' => 'name,bundleId,sku,primaryLocale',
                  'limit' => 200,
              ]);

          return $response->json()['data'] ?? [];
      }

      public function getSalesReports(string $appId, string $date): array
      {
          // Implementation for sales reports
      }

      public function getAnalyticsReports(string $appId, array $metrics): array
      {
          // Implementation for analytics
      }
  }
  ```

- [ ] **0.5.1.2** Créer commande de test connexion
  ```bash
  php artisan asc:test-connection {integration_id}
  ```

- [ ] **0.5.1.3** Gérer les erreurs API (rate limit, auth expired)

#### 0.5.2 Google Play Console API Service

- [ ] **0.5.2.1** Créer `app/Services/GooglePlay/GooglePlayService.php`
  ```php
  <?php

  namespace App\Services\GooglePlay;

  use Google\Client;
  use Google\Service\AndroidPublisher;

  class GooglePlayService
  {
      private AndroidPublisher $service;
      private string $packageName;

      public function __construct(array $credentials)
      {
          $client = new Client();
          $client->setAuthConfig($credentials);
          $client->addScope(AndroidPublisher::ANDROIDPUBLISHER);

          $this->service = new AndroidPublisher($client);
      }

      public function listApps(): array
      {
          // Note: Play Console API doesn't have a direct "list apps" endpoint
          // Apps must be known beforehand or fetched from Play Console UI
          // We'll use the package names from the integration metadata
      }

      public function getReviews(string $packageName, int $maxResults = 100): array
      {
          $response = $this->service->reviews->listReviews($packageName, [
              'maxResults' => $maxResults,
          ]);

          return $response->getReviews() ?? [];
      }

      public function getSalesReport(string $packageName, string $month): array
      {
          // Implementation for sales reports
      }
  }
  ```

- [ ] **0.5.2.2** Installer package Google API
  ```bash
  composer require google/apiclient
  ```

- [ ] **0.5.2.3** Créer commande de test connexion

#### 0.5.3 Service iTunes API (existant - améliorer)

- [ ] **0.5.3.1** Audit service existant
- [ ] **0.5.3.2** Ajouter retry logic avec exponential backoff
- [ ] **0.5.3.3** Ajouter cache pour requêtes identiques
- [ ] **0.5.3.4** Ajouter métriques (temps de réponse, erreurs)

#### 0.5.4 Service Google Play Scraper (existant - améliorer)

- [ ] **0.5.4.1** Audit service Node.js existant
- [ ] **0.5.4.2** Ajouter health check endpoint
- [ ] **0.5.4.3** Améliorer gestion des erreurs

---

### 0.6 Refactoring Frontend Flutter

#### 0.6.1 Suppression des triggers de sync

- [ ] **0.6.1.1** Audit des repositories Flutter
  - Fichiers : `app/lib/features/*/data/*_repository.dart`
  - Chercher : appels qui déclenchent un sync backend

- [ ] **0.6.1.2** Refactorer `RatingsRepository`
  - Supprimer : logique de force refresh
  - Garder : lecture simple depuis API

- [ ] **0.6.1.3** Refactorer `KeywordsRepository`
  - Supprimer : sync on-demand

- [ ] **0.6.1.4** Refactorer `ReviewsRepository`
  - Supprimer : sync on-demand

#### 0.6.2 Ajout indicateur "Last Sync"

- [ ] **0.6.2.1** Créer provider `syncStatusProvider`
  ```dart
  final syncStatusProvider = FutureProvider<SyncStatus>((ref) async {
    final api = ref.watch(dioProvider);
    final response = await api.get('/api/sync/status');
    return SyncStatus.fromJson(response.data);
  });
  ```

- [ ] **0.6.2.2** Créer widget `LastSyncIndicator`
  ```dart
  class LastSyncIndicator extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final status = ref.watch(syncStatusProvider);
      return status.when(
        data: (s) => Text('Last sync: ${s.lastSync.timeAgo}'),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      );
    }
  }
  ```

- [ ] **0.6.2.3** Intégrer dans le header/app bar

#### 0.6.3 Gestion état "données pas encore disponibles"

- [ ] **0.6.3.1** Créer widget `DataPendingPlaceholder`
  ```dart
  class DataPendingPlaceholder extends StatelessWidget {
    final String message;

    const DataPendingPlaceholder({
      this.message = 'Data is being collected...',
    });

    @override
    Widget build(BuildContext context) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
            const SizedBox(height: 8),
            Text(
              'Check back in a few minutes',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }
  }
  ```

- [ ] **0.6.3.2** Intégrer dans tous les écrans data-driven

---

### 0.7 Tests Phase 0

#### 0.7.1 Tests unitaires backend

- [ ] **0.7.1.1** Tests IntegrationService
- [ ] **0.7.1.2** Tests AppStoreConnectService
- [ ] **0.7.1.3** Tests GooglePlayService
- [ ] **0.7.1.4** Tests BaseCollector

#### 0.7.2 Tests d'intégration

- [ ] **0.7.2.1** Test migration données existantes
- [ ] **0.7.2.2** Test partitionnement tables
- [ ] **0.7.2.3** Test endpoints refactorés

#### 0.7.3 Tests frontend

- [ ] **0.7.3.1** Test LastSyncIndicator
- [ ] **0.7.3.2** Test DataPendingPlaceholder
- [ ] **0.7.3.3** Test repositories refactorés

---

## Phase 1: Onboarding & Intégrations

> **Objectif** : Permettre aux utilisateurs de connecter leurs comptes développeur
> **Prérequis** : Phase 0 complète
> **Bloque** : Phase 3 (collectors pour données owned)

### 1.1 Backend - Endpoints Intégrations

#### 1.1.1 CRUD Intégrations

- [ ] **1.1.1.1** Créer `IntegrationsController`
  ```php
  <?php

  namespace App\Http\Controllers\Api;

  class IntegrationsController extends Controller
  {
      public function index(Request $request)
      {
          return $request->user()->integrations()
              ->select(['id', 'type', 'status', 'metadata', 'last_sync_at', 'error_message'])
              ->get();
      }

      public function store(Request $request)
      {
          // Validation selon le type
          // Création de l'intégration
          // Test de connexion
          // Fetch initial des apps
      }

      public function destroy(Integration $integration)
      {
          $this->authorize('delete', $integration);
          $integration->delete();
          return response()->noContent();
      }

      public function refresh(Integration $integration)
      {
          $this->authorize('update', $integration);
          // Re-sync apps depuis l'intégration
      }

      public function apps(Integration $integration)
      {
          $this->authorize('view', $integration);
          // Retourne les apps découvertes
      }
  }
  ```

- [ ] **1.1.1.2** Créer routes
  ```php
  Route::middleware('auth:sanctum')->group(function () {
      Route::apiResource('integrations', IntegrationsController::class);
      Route::post('integrations/{integration}/refresh', [IntegrationsController::class, 'refresh']);
      Route::get('integrations/{integration}/apps', [IntegrationsController::class, 'apps']);
  });
  ```

#### 1.1.2 Flow App Store Connect

- [ ] **1.1.2.1** Créer `ConnectAppStoreRequest` (validation)
  ```php
  class ConnectAppStoreRequest extends FormRequest
  {
      public function rules(): array
      {
          return [
              'key_id' => ['required', 'string', 'size:10'],
              'issuer_id' => ['required', 'uuid'],
              'private_key' => ['required', 'string', 'starts_with:-----BEGIN PRIVATE KEY-----'],
          ];
      }
  }
  ```

- [ ] **1.1.2.2** Créer action `ConnectAppStoreAction`
  ```php
  class ConnectAppStoreAction
  {
      public function execute(User $user, array $credentials): Integration
      {
          // 1. Créer intégration pending
          $integration = $user->integrations()->create([
              'type' => 'app_store_connect',
              'status' => 'pending',
              'credentials' => $credentials,
          ]);

          // 2. Tester connexion
          $service = new AppStoreConnectService($credentials);
          try {
              $apps = $service->listApps();
          } catch (\Exception $e) {
              $integration->update([
                  'status' => 'error',
                  'error_message' => $e->getMessage(),
              ]);
              throw $e;
          }

          // 3. Sauvegarder metadata
          $integration->update([
              'status' => 'active',
              'metadata' => [
                  'team_name' => $apps[0]['attributes']['teamName'] ?? null,
                  'apps_count' => count($apps),
              ],
              'last_sync_at' => now(),
          ]);

          // 4. Importer apps
          $this->importApps($user, $integration, $apps);

          return $integration->fresh();
      }

      private function importApps(User $user, Integration $integration, array $apps): void
      {
          foreach ($apps as $appData) {
              // Créer ou trouver l'app
              $app = App::updateOrCreate(
                  ['store_id' => $appData['id'], 'platform' => 'ios'],
                  [
                      'name' => $appData['attributes']['name'],
                      'developer_name' => $appData['attributes']['teamName'] ?? null,
                      // ... autres champs
                  ]
              );

              // Lier à l'utilisateur
              $user->apps()->syncWithoutDetaching([
                  $app->id => [
                      'ownership_type' => 'owned',
                      'integration_id' => $integration->id,
                  ],
              ]);
          }
      }
  }
  ```

- [ ] **1.1.2.3** Endpoint dédié App Store Connect
  ```php
  Route::post('integrations/app-store-connect', [IntegrationsController::class, 'connectAppStore']);
  ```

#### 1.1.3 Flow Google Play Console

- [ ] **1.1.3.1** Créer `ConnectGooglePlayRequest` (validation)
  ```php
  class ConnectGooglePlayRequest extends FormRequest
  {
      public function rules(): array
      {
          return [
              'service_account_json' => ['required', 'json'],
              'package_names' => ['required', 'array', 'min:1'],
              'package_names.*' => ['required', 'string', 'regex:/^[a-z][a-z0-9_]*(\.[a-z0-9_]+)+$/i'],
          ];
      }
  }
  ```

- [ ] **1.1.3.2** Créer action `ConnectGooglePlayAction`
  - Similaire à App Store Connect
  - Nécessite package names car l'API ne liste pas les apps

- [ ] **1.1.3.3** Endpoint dédié Google Play
  ```php
  Route::post('integrations/google-play', [IntegrationsController::class, 'connectGooglePlay']);
  ```

#### 1.1.4 Endpoint Sync Status

- [ ] **1.1.4.1** Créer `SyncController`
  ```php
  class SyncController extends Controller
  {
      public function status(Request $request)
      {
          $user = $request->user();

          return [
              'last_rankings_sync' => $this->getLastSync('RankingsCollector'),
              'last_ratings_sync' => $this->getLastSync('RatingsCollector'),
              'last_reviews_sync' => $this->getLastSync('ReviewsCollector'),
              'integrations' => $user->integrations()
                  ->select(['type', 'status', 'last_sync_at'])
                  ->get(),
          ];
      }

      private function getLastSync(string $jobName): ?string
      {
          return JobExecution::where('job_name', $jobName)
              ->where('status', 'completed')
              ->latest('completed_at')
              ->value('completed_at');
      }
  }
  ```

---

### 1.2 Frontend - Écran Intégrations

#### 1.2.1 Page Settings/Integrations

- [ ] **1.2.1.1** Créer route `/settings/integrations`
  ```dart
  GoRoute(
    path: '/settings/integrations',
    builder: (context, state) => const IntegrationsScreen(),
  ),
  ```

- [ ] **1.2.1.2** Créer `IntegrationsScreen`
  ```dart
  class IntegrationsScreen extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final integrations = ref.watch(integrationsProvider);

      return Scaffold(
        appBar: AppBar(title: const Text('Integrations')),
        body: integrations.when(
          data: (list) => IntegrationsList(integrations: list),
          loading: () => const LoadingIndicator(),
          error: (e, _) => ErrorWidget(error: e),
        ),
      );
    }
  }
  ```

- [ ] **1.2.1.3** Créer `IntegrationCard` widget
  ```dart
  class IntegrationCard extends StatelessWidget {
    final Integration? integration; // null = not connected
    final IntegrationType type;
    final VoidCallback onConnect;
    final VoidCallback? onDisconnect;

    // UI avec status, last sync, actions
  }
  ```

#### 1.2.2 Modal connexion App Store Connect

- [ ] **1.2.2.1** Créer `AppStoreConnectModal`
  ```dart
  class AppStoreConnectModal extends ConsumerStatefulWidget {
    @override
    _AppStoreConnectModalState createState() => _AppStoreConnectModalState();
  }

  class _AppStoreConnectModalState extends ConsumerState<AppStoreConnectModal> {
    final _keyIdController = TextEditingController();
    final _issuerIdController = TextEditingController();
    String? _privateKey;
    bool _isLoading = false;
    String? _error;

    @override
    Widget build(BuildContext context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Connect App Store Connect',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'To connect, you need to create an API key in App Store Connect:',
              ),
              const SizedBox(height: 8),
              _buildInstructions(),
              const SizedBox(height: 24),
              TextField(
                controller: _keyIdController,
                decoration: const InputDecoration(
                  labelText: 'Key ID',
                  hintText: 'ABC123DEFG',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _issuerIdController,
                decoration: const InputDecoration(
                  labelText: 'Issuer ID',
                  hintText: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                ),
              ),
              const SizedBox(height: 16),
              _buildFileUpload(),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _connect,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Connect'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildInstructions() {
      // Step by step instructions with links
    }

    Widget _buildFileUpload() {
      // File picker for .p8 file
    }

    Future<void> _connect() async {
      // Validation + API call
    }
  }
  ```

- [ ] **1.2.2.2** Créer provider `connectAppStoreProvider`

- [ ] **1.2.2.3** Gérer upload fichier .p8
  - Package : `file_picker`

#### 1.2.3 Modal connexion Google Play Console

- [ ] **1.2.3.1** Créer `GooglePlayConnectModal`
  - Upload JSON service account
  - Saisie des package names

- [ ] **1.2.3.2** Créer provider `connectGooglePlayProvider`

#### 1.2.4 Quick Access Header

- [ ] **1.2.4.1** Ajouter bouton ⚡ dans le header
  ```dart
  IconButton(
    icon: const Icon(Icons.bolt),
    tooltip: 'Integrations',
    onPressed: () => _showIntegrationsQuickMenu(context),
  ),
  ```

- [ ] **1.2.4.2** Créer `IntegrationsQuickMenu`
  - Liste des intégrations avec status
  - Lien vers page complète
  - Bouton "+ Add integration"

---

### 1.3 Onboarding Wizard

#### 1.3.1 Backend - Tracking onboarding

- [ ] **1.3.1.1** Ajouter colonne `onboarding_step` à `users`
  ```php
  $table->string('onboarding_step', 20)->nullable(); // welcome, connect, apps, setup, completed
  $table->timestamp('onboarding_completed_at')->nullable();
  ```

- [ ] **1.3.1.2** Créer endpoint update onboarding
  ```php
  Route::post('onboarding/step', [OnboardingController::class, 'updateStep']);
  Route::post('onboarding/complete', [OnboardingController::class, 'complete']);
  ```

#### 1.3.2 Frontend - Wizard screens

- [ ] **1.3.2.1** Créer `OnboardingWelcomeScreen` (Step 1)
  ```dart
  class OnboardingWelcomeScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.track_changes, size: 80, color: Colors.blue),
                const SizedBox(height: 32),
                Text(
                  'Track your apps like never before',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Beautiful insights, deep data, actionable intelligence',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/onboarding/connect'),
                    child: const Text('Get Started'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go('/onboarding/apps'),
                  child: const Text('Skip for now'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
  ```

- [ ] **1.3.2.2** Créer `OnboardingConnectScreen` (Step 2)
  - Cards pour App Store Connect et Google Play
  - Boutons "Connect" qui ouvrent les modals
  - Bouton "Skip" / "Continue"

- [ ] **1.3.2.3** Créer `OnboardingAppsScreen` (Step 3)
  - Liste des apps découvertes (si connecté)
  - Ou recherche manuelle (si non connecté)
  - Checkboxes pour sélection
  - Section "Watch competitor apps"

- [ ] **1.3.2.4** Créer `OnboardingSetupScreen` (Step 4)
  - Sélection pays à tracker
  - Keywords suggérés (depuis metadata app)
  - Bouton "Start Tracking"

#### 1.3.3 Navigation onboarding

- [ ] **1.3.3.1** Configurer routes onboarding
  ```dart
  GoRoute(
    path: '/onboarding',
    redirect: (context, state) {
      // Redirect to current step based on user.onboarding_step
    },
    routes: [
      GoRoute(path: 'welcome', builder: (_, __) => const OnboardingWelcomeScreen()),
      GoRoute(path: 'connect', builder: (_, __) => const OnboardingConnectScreen()),
      GoRoute(path: 'apps', builder: (_, __) => const OnboardingAppsScreen()),
      GoRoute(path: 'setup', builder: (_, __) => const OnboardingSetupScreen()),
    ],
  ),
  ```

- [ ] **1.3.3.2** Ajouter guard pour users non-onboarded
  ```dart
  redirect: (context, state) {
    final user = ref.read(authProvider).value;
    if (user != null && user.onboardingCompletedAt == null) {
      if (!state.uri.path.startsWith('/onboarding')) {
        return '/onboarding';
      }
    }
    return null;
  },
  ```

---

### 1.4 Migration users existants

#### 1.4.1 Script migration ownership

- [ ] **1.4.1.1** Créer commande `MigrateAppOwnership`
  ```php
  class MigrateAppOwnership extends Command
  {
      protected $signature = 'migrate:app-ownership';

      public function handle(): void
      {
          // Apps où l'user est marqué owner → owned
          DB::table('user_apps')
              ->where('is_owner', true)
              ->update(['ownership_type' => 'owned']);

          // Autres apps → watched
          DB::table('user_apps')
              ->where('is_owner', false)
              ->orWhereNull('is_owner')
              ->update(['ownership_type' => 'watched']);

          $this->info('Migration completed.');
      }
  }
  ```

#### 1.4.2 Marquer users existants comme onboarded

- [ ] **1.4.2.1** Créer commande `MarkExistingUsersOnboarded`
  ```php
  class MarkExistingUsersOnboarded extends Command
  {
      public function handle(): void
      {
          User::whereNull('onboarding_completed_at')
              ->whereHas('apps')
              ->update([
                  'onboarding_step' => 'completed',
                  'onboarding_completed_at' => now(),
              ]);
      }
  }
  ```

---

### 1.5 Tests Phase 1

#### 1.5.1 Tests backend

- [ ] **1.5.1.1** Tests IntegrationsController
- [ ] **1.5.1.2** Tests ConnectAppStoreAction
- [ ] **1.5.1.3** Tests ConnectGooglePlayAction
- [ ] **1.5.1.4** Tests OnboardingController

#### 1.5.2 Tests frontend

- [ ] **1.5.2.1** Tests widget IntegrationsScreen
- [ ] **1.5.2.2** Tests modals connexion
- [ ] **1.5.2.3** Tests flow onboarding complet

---

## Phase 2: Dashboard & Visualisations

> **Objectif** : Nouveau dashboard unifié avec visualisations Apple-style
> **Prérequis** : Phase 0 (refactoring controllers), Phase 1 (ownership model)
> **Bloque** : Rien (peut être parallélisé avec Phase 3)

### 2.1 Design System - Composants de base

#### 2.1.1 Constantes design

- [ ] **2.1.1.1** Créer `lib/core/theme/app_colors.dart`
  ```dart
  class AppColors {
    // Semantic
    static const success = Color(0xFF34C759);
    static const warning = Color(0xFFFF9500);
    static const error = Color(0xFFFF3B30);
    static const info = Color(0xFF007AFF);

    // Charts
    static const chartPrimary = Color(0xFF007AFF);
    static const chartSecondary = Color(0xFF5856D6);
    static const chartTertiary = Color(0xFFAF52DE);
    static const chartComparison = Color(0xFF8E8E93);

    // Surfaces
    static const cardBackground = Colors.white;
    static const cardBackgroundHover = Color(0xFFF9F9F9);
    static const surface = Color(0xFFF2F2F7);
    static const divider = Color(0xFFE5E5EA);

    // Text
    static const textPrimary = Colors.black;
    static const textSecondary = Color(0xFF8E8E93);
    static const textTertiary = Color(0xFFC7C7CC);
  }
  ```

- [ ] **2.1.1.2** Créer `lib/core/theme/app_typography.dart`
  ```dart
  class AppTypography {
    static const heroMetric = TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      letterSpacing: -1,
    );

    static const headline = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    );

    static const title = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
    );

    static const body = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
    );

    static const caption = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
    );

    static const micro = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );
  }
  ```

- [ ] **2.1.1.3** Créer `lib/core/theme/app_spacing.dart`
  ```dart
  class AppSpacing {
    static const xs = 4.0;
    static const sm = 8.0;
    static const md = 16.0;
    static const lg = 24.0;
    static const xl = 32.0;
    static const xxl = 48.0;
  }
  ```

- [ ] **2.1.1.4** Créer `lib/core/theme/app_animations.dart`
  ```dart
  class AppAnimations {
    static const defaultDuration = Duration(milliseconds: 200);
    static const defaultCurve = Curves.easeOutCubic;

    static const chartLoadDuration = Duration(milliseconds: 600);
    static const chartCurve = Curves.easeOutQuart;

    static const countDuration = Duration(milliseconds: 400);

    static const shimmerDuration = Duration(milliseconds: 1500);
  }
  ```

#### 2.1.2 ChangeIndicator

- [ ] **2.1.2.1** Créer `lib/shared/widgets/change_indicator.dart`
  ```dart
  enum ChangeFormat { number, percent, position }

  class ChangeIndicator extends StatelessWidget {
    final num value;
    final ChangeFormat format;
    final bool invertColors; // For rankings where down is bad
    final bool showIcon;
    final double? fontSize;

    const ChangeIndicator({
      required this.value,
      this.format = ChangeFormat.number,
      this.invertColors = false,
      this.showIcon = true,
      this.fontSize,
    });

    @override
    Widget build(BuildContext context) {
      final isPositive = invertColors ? value < 0 : value > 0;
      final isNegative = invertColors ? value > 0 : value < 0;

      final color = isPositive
          ? AppColors.success
          : isNegative
              ? AppColors.error
              : AppColors.textSecondary;

      final icon = isPositive
          ? Icons.arrow_upward
          : isNegative
              ? Icons.arrow_downward
              : Icons.arrow_forward;

      final formattedValue = _formatValue();

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon)
            Icon(icon, size: (fontSize ?? 14) + 2, color: color),
          Text(
            formattedValue,
            style: TextStyle(
              color: color,
              fontSize: fontSize ?? 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    String _formatValue() {
      final absValue = value.abs();
      switch (format) {
        case ChangeFormat.number:
          return absValue.toString();
        case ChangeFormat.percent:
          return '${absValue.toStringAsFixed(1)}%';
        case ChangeFormat.position:
          return absValue.toString();
      }
    }
  }
  ```

- [ ] **2.1.2.2** Tests unitaires ChangeIndicator

#### 2.1.3 MetricCard

- [ ] **2.1.3.1** Créer `lib/shared/widgets/metric_card.dart`
  ```dart
  class MetricCard extends StatelessWidget {
    final String title;
    final String value;
    final num? change;
    final ChangeFormat changeFormat;
    final List<double>? sparklineData;
    final String? subtitle;
    final Color? accentColor;
    final VoidCallback? onTap;

    const MetricCard({
      required this.title,
      required this.value,
      this.change,
      this.changeFormat = ChangeFormat.percent,
      this.sparklineData,
      this.subtitle,
      this.accentColor,
      this.onTap,
    });

    @override
    Widget build(BuildContext context) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.divider),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: AppTypography.heroMetric.copyWith(
                          fontSize: 32,
                          color: accentColor,
                        ),
                      ),
                    ),
                    if (sparklineData != null && sparklineData!.isNotEmpty)
                      SizedBox(
                        width: 64,
                        height: 24,
                        child: Sparkline(
                          data: sparklineData!,
                          color: accentColor ?? AppColors.chartPrimary,
                        ),
                      ),
                  ],
                ),
                if (change != null || subtitle != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      if (change != null)
                        ChangeIndicator(
                          value: change!,
                          format: changeFormat,
                        ),
                      if (change != null && subtitle != null)
                        const SizedBox(width: AppSpacing.sm),
                      if (subtitle != null)
                        Expanded(
                          child: Text(
                            subtitle!,
                            style: AppTypography.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }
  }
  ```

- [ ] **2.1.3.2** Tests MetricCard

### 2.2 Charts Components

#### 2.2.1 Sparkline

- [ ] **2.2.1.1** Créer `lib/shared/widgets/charts/sparkline.dart`
  ```dart
  class Sparkline extends StatelessWidget {
    final List<double> data;
    final Color color;
    final double strokeWidth;
    final bool showDots;

    const Sparkline({
      required this.data,
      this.color = AppColors.chartPrimary,
      this.strokeWidth = 1.5,
      this.showDots = false,
    });

    @override
    Widget build(BuildContext context) {
      if (data.isEmpty) return const SizedBox.shrink();

      return CustomPaint(
        painter: SparklinePainter(
          data: data,
          color: color,
          strokeWidth: strokeWidth,
          showDots: showDots,
        ),
        size: Size.infinite,
      );
    }
  }

  class SparklinePainter extends CustomPainter {
    final List<double> data;
    final Color color;
    final double strokeWidth;
    final bool showDots;

    SparklinePainter({
      required this.data,
      required this.color,
      required this.strokeWidth,
      required this.showDots,
    });

    @override
    void paint(Canvas canvas, Size size) {
      if (data.isEmpty) return;

      final paint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final minValue = data.reduce(min);
      final maxValue = data.reduce(max);
      final range = maxValue - minValue;

      final path = Path();

      for (int i = 0; i < data.length; i++) {
        final x = (i / (data.length - 1)) * size.width;
        final normalizedY = range == 0 ? 0.5 : (data[i] - minValue) / range;
        final y = size.height - (normalizedY * size.height);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paint);

      if (showDots) {
        final dotPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

        // Draw last dot
        final lastX = size.width;
        final lastNormalizedY = range == 0 ? 0.5 : (data.last - minValue) / range;
        final lastY = size.height - (lastNormalizedY * size.height);
        canvas.drawCircle(Offset(lastX, lastY), 3, dotPaint);
      }
    }

    @override
    bool shouldRepaint(SparklinePainter oldDelegate) {
      return data != oldDelegate.data || color != oldDelegate.color;
    }
  }
  ```

- [ ] **2.2.1.2** Tests Sparkline

#### 2.2.2 TrendChart

- [ ] **2.2.2.1** Créer `lib/shared/widgets/charts/trend_chart.dart`
  ```dart
  class TrendChart extends StatefulWidget {
    final List<ChartDataPoint> data;
    final List<String> periods;
    final String selectedPeriod;
    final ValueChanged<String> onPeriodChanged;
    final bool showGradient;
    final bool invertYAxis; // For rankings
    final Color? color;
    final String? title;
    final String? subtitle;
    final List<ChartDataPoint>? compareData;

    const TrendChart({
      required this.data,
      required this.periods,
      required this.selectedPeriod,
      required this.onPeriodChanged,
      this.showGradient = true,
      this.invertYAxis = false,
      this.color,
      this.title,
      this.subtitle,
      this.compareData,
    });

    @override
    State<TrendChart> createState() => _TrendChartState();
  }

  class _TrendChartState extends State<TrendChart> {
    int? _touchedIndex;

    @override
    Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            _buildHeader(),
          const SizedBox(height: AppSpacing.md),
          _buildPeriodSelector(),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: _buildChart(),
          ),
        ],
      );
    }

    Widget _buildHeader() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title!, style: AppTypography.title),
              if (widget.subtitle != null)
                Text(widget.subtitle!, style: AppTypography.caption),
            ],
          ),
          if (widget.data.isNotEmpty)
            _buildChangeIndicator(),
        ],
      );
    }

    Widget _buildPeriodSelector() {
      return Row(
        children: widget.periods.map((period) {
          final isSelected = period == widget.selectedPeriod;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(period),
              selected: isSelected,
              onSelected: (_) => widget.onPeriodChanged(period),
            ),
          );
        }).toList(),
      );
    }

    Widget _buildChart() {
      if (widget.data.isEmpty) {
        return const Center(child: Text('No data available'));
      }

      final color = widget.color ?? AppColors.chartPrimary;

      return LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _calculateInterval(),
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.divider,
              strokeWidth: 1,
            ),
          ),
          titlesData: _buildTitlesData(),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            _buildLineBarData(widget.data, color, false),
            if (widget.compareData != null)
              _buildLineBarData(widget.compareData!, AppColors.chartComparison, true),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: _buildTooltipItems,
            ),
            touchCallback: (event, response) {
              setState(() {
                _touchedIndex = response?.lineBarSpots?.first.spotIndex;
              });
            },
          ),
        ),
        duration: AppAnimations.chartLoadDuration,
        curve: AppAnimations.chartCurve,
      );
    }

    LineChartBarData _buildLineBarData(List<ChartDataPoint> data, Color color, bool isDashed) {
      return LineChartBarData(
        spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList(),
        isCurved: true,
        curveSmoothness: 0.3,
        color: color,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        dashArray: isDashed ? [5, 5] : null,
        belowBarData: widget.showGradient && !isDashed
            ? BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withOpacity(0.3),
                    color.withOpacity(0.0),
                  ],
                ),
              )
            : null,
      );
    }

    // ... autres méthodes helper
  }

  class ChartDataPoint {
    final DateTime date;
    final double value;
    final String? label;

    const ChartDataPoint({
      required this.date,
      required this.value,
      this.label,
    });
  }
  ```

- [ ] **2.2.2.2** Tests TrendChart

#### 2.2.3 RingChart (Ratings Distribution)

- [ ] **2.2.3.1** Créer `lib/shared/widgets/charts/ring_chart.dart`
  ```dart
  class RingChart extends StatelessWidget {
    final double average;
    final List<RatingDistribution> distribution;
    final double size;
    final bool showLabels;

    const RingChart({
      required this.average,
      required this.distribution,
      this.size = 120,
      this.showLabels = true,
    });

    @override
    Widget build(BuildContext context) {
      return Row(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: size * 0.35,
                    sections: _buildSections(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      average.toStringAsFixed(1),
                      style: AppTypography.headline,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        final filled = index < average.floor();
                        final partial = index == average.floor();
                        return Icon(
                          filled || partial ? Icons.star : Icons.star_border,
                          size: 12,
                          color: Colors.amber,
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showLabels) ...[
            const SizedBox(width: AppSpacing.lg),
            _buildLegend(),
          ],
        ],
      );
    }

    List<PieChartSectionData> _buildSections() {
      final colors = [
        AppColors.success, // 5 stars
        Color(0xFF8BC34A), // 4 stars
        AppColors.warning, // 3 stars
        Color(0xFFFF5722), // 2 stars
        AppColors.error,   // 1 star
      ];

      return distribution.asMap().entries.map((entry) {
        final index = entry.key;
        final dist = entry.value;
        return PieChartSectionData(
          value: dist.percentage,
          color: colors[index],
          radius: size * 0.15,
          showTitle: false,
        );
      }).toList();
    }

    Widget _buildLegend() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: distribution.map((dist) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Text('★' * dist.stars, style: const TextStyle(color: Colors.amber, fontSize: 12)),
                const SizedBox(width: 8),
                Text('${dist.percentage.toStringAsFixed(0)}%', style: AppTypography.caption),
                const SizedBox(width: 8),
                SizedBox(
                  width: 60,
                  height: 4,
                  child: LinearProgressIndicator(
                    value: dist.percentage / 100,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation(AppColors.success),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }
  }

  class RatingDistribution {
    final int stars;
    final double percentage;
    final int count;

    const RatingDistribution({
      required this.stars,
      required this.percentage,
      required this.count,
    });
  }
  ```

- [ ] **2.2.3.2** Tests RingChart

#### 2.2.4 HeatmapGrid

- [ ] **2.2.4.1** Créer `lib/shared/widgets/charts/heatmap_grid.dart`
  ```dart
  class HeatmapGrid extends StatelessWidget {
    final List<String> rowLabels;
    final List<String> columnLabels;
    final Map<String, int?> values; // "row-col" -> value
    final int? Function(int? value) colorMapper; // value -> intensity 0-3
    final String Function(int? value) tooltipFormatter;

    const HeatmapGrid({
      required this.rowLabels,
      required this.columnLabels,
      required this.values,
      required this.colorMapper,
      required this.tooltipFormatter,
    });

    @override
    Widget build(BuildContext context) {
      return Column(
        children: [
          // Header row (column labels)
          Row(
            children: [
              const SizedBox(width: 100), // Space for row labels
              ...columnLabels.map((label) => Expanded(
                child: Center(
                  child: Text(label, style: AppTypography.caption),
                ),
              )),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Data rows
          ...rowLabels.map((rowLabel) => _buildRow(rowLabel)),
          const SizedBox(height: AppSpacing.md),
          // Legend
          _buildLegend(),
        ],
      );
    }

    Widget _buildRow(String rowLabel) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                rowLabel,
                style: AppTypography.caption,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ...columnLabels.map((colLabel) {
              final key = '$rowLabel-$colLabel';
              final value = values[key];
              final intensity = colorMapper(value);
              return Expanded(
                child: Tooltip(
                  message: tooltipFormatter(value),
                  child: Container(
                    height: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: _getColor(intensity),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    }

    Color _getColor(int? intensity) {
      switch (intensity) {
        case 3: return AppColors.success;
        case 2: return AppColors.success.withOpacity(0.6);
        case 1: return AppColors.success.withOpacity(0.3);
        case 0: return AppColors.divider;
        default: return AppColors.surface;
      }
    }

    Widget _buildLegend() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendItem('Top 10', 3),
          const SizedBox(width: 16),
          _legendItem('Top 50', 2),
          const SizedBox(width: 16),
          _legendItem('Top 100', 1),
          const SizedBox(width: 16),
          _legendItem('Not ranked', 0),
        ],
      );
    }

    Widget _legendItem(String label, int intensity) {
      return Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: _getColor(intensity),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 4),
          Text(label, style: AppTypography.micro),
        ],
      );
    }
  }
  ```

- [ ] **2.2.4.2** Tests HeatmapGrid

#### 2.2.5 ComparisonChart

- [ ] **2.2.5.1** Créer `lib/shared/widgets/charts/comparison_chart.dart`
  - Basé sur TrendChart avec support multi-séries
  - Légende cliquable pour toggle séries

- [ ] **2.2.5.2** Tests ComparisonChart

---

### 2.3 Dashboard Screen

#### 2.3.1 Layout principal

- [ ] **2.3.1.1** Créer `lib/features/dashboard/presentation/dashboard_screen.dart`
  ```dart
  class DashboardScreen extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () => ref.refresh(dashboardProvider.future),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                title: const Text('Dashboard'),
                actions: [
                  LastSyncIndicator(),
                  const SizedBox(width: 8),
                  NotificationBell(),
                  const SizedBox(width: 8),
                  IntegrationsQuickButton(),
                  const SizedBox(width: 8),
                  ProfileMenu(),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildGreeting(context),
                    const SizedBox(height: AppSpacing.lg),
                    const HeroMetricsSection(),
                    const SizedBox(height: AppSpacing.xl),
                    const RankingMoversSection(),
                    const SizedBox(height: AppSpacing.xl),
                    const YourAppsSection(),
                    const SizedBox(height: AppSpacing.xl),
                    const RecentReviewsSection(),
                    const SizedBox(height: AppSpacing.xl),
                    const AlertsSection(),
                    const SizedBox(height: AppSpacing.xl),
                    const InsightsSection(),
                    const SizedBox(height: AppSpacing.xxl),
                  ]),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildGreeting(BuildContext context) {
      final hour = DateTime.now().hour;
      String greeting;
      if (hour < 12) {
        greeting = 'Good morning';
      } else if (hour < 17) {
        greeting = 'Good afternoon';
      } else {
        greeting = 'Good evening';
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$greeting! 👋',
            style: AppTypography.headline,
          ),
          const LastSyncIndicator(),
        ],
      );
    }
  }
  ```

#### 2.3.2 Hero Metrics Section

- [ ] **2.3.2.1** Créer `HeroMetricsSection`
  ```dart
  class HeroMetricsSection extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final metrics = ref.watch(heroMetricsProvider);

      return metrics.when(
        data: (data) => _buildGrid(data),
        loading: () => _buildLoadingGrid(),
        error: (e, _) => ErrorCard(error: e),
      );
    }

    Widget _buildGrid(HeroMetrics data) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.5,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            children: [
              MetricCard(
                title: 'Total Apps',
                value: '${data.totalApps}',
                subtitle: '+${data.newAppsThisMonth} this month',
              ),
              MetricCard(
                title: 'Avg Rating',
                value: '${data.avgRating.toStringAsFixed(1)} ★',
                change: data.ratingChange,
                changeFormat: ChangeFormat.number,
                sparklineData: data.ratingHistory,
              ),
              MetricCard(
                title: 'Keywords',
                value: '${data.totalKeywords}',
                subtitle: '${data.keywordsInTop10} in top 10',
              ),
              MetricCard(
                title: 'Downloads',
                value: _formatNumber(data.totalDownloads),
                change: data.downloadsChange,
                sparklineData: data.downloadsHistory,
              ),
              MetricCard(
                title: 'Revenue',
                value: '\$${_formatNumber(data.totalRevenue)}',
                change: data.revenueChange,
                sparklineData: data.revenueHistory,
              ),
              MetricCard(
                title: 'Reviews',
                value: '${data.reviewsCount}',
                subtitle: '${data.reviewsNeedReply} need reply',
                accentColor: data.reviewsNeedReply > 0 ? AppColors.warning : null,
              ),
            ],
          );
        },
      );
    }
  }
  ```

- [ ] **2.3.2.2** Créer provider `heroMetricsProvider`
- [ ] **2.3.2.3** Créer endpoint backend `/api/dashboard/metrics`

#### 2.3.3 Ranking Movers Section

- [ ] **2.3.3.1** Créer `RankingMoversSection`
  ```dart
  class RankingMoversSection extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final period = ref.watch(moversPeriodProvider);
      final movers = ref.watch(rankingMoversProvider(period));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_up, size: 20),
                  const SizedBox(width: 8),
                  Text('Ranking Movements', style: AppTypography.title),
                ],
              ),
              _buildPeriodSelector(ref, period),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          movers.when(
            data: (data) => _buildMoversGrid(data),
            loading: () => const LoadingIndicator(),
            error: (e, _) => ErrorCard(error: e),
          ),
        ],
      );
    }

    Widget _buildMoversGrid(RankingMoversData data) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildMoversList(
              'Keywords improving',
              data.improving,
              AppColors.success,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildMoversList(
              'Keywords declining',
              data.declining,
              AppColors.error,
            ),
          ),
        ],
      );
    }

    Widget _buildMoversList(String title, List<KeywordMover> movers, Color color) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.caption),
              const SizedBox(height: AppSpacing.sm),
              ...movers.take(5).map((mover) => _buildMoverRow(mover, color)),
              if (movers.length > 5)
                TextButton(
                  onPressed: () {}, // Navigate to keywords
                  child: Text('View all ${movers.length} keywords →'),
                ),
            ],
          ),
        ),
      );
    }
  }
  ```

- [ ] **2.3.3.2** Créer provider `rankingMoversProvider`
- [ ] **2.3.3.3** Créer endpoint backend `/api/dashboard/movers`

#### 2.3.4 Your Apps Section

- [ ] **2.3.4.1** Créer `YourAppsSection`
- [ ] **2.3.4.2** Widget `AppCard` avec sparklines
- [ ] **2.3.4.3** Séparation owned / watched

#### 2.3.5 Recent Reviews Section

- [ ] **2.3.5.1** Créer `RecentReviewsSection`
- [ ] **2.3.5.2** Widget `ReviewCard` compact
- [ ] **2.3.5.3** Bouton reply inline

#### 2.3.6 Alerts Section

- [ ] **2.3.6.1** Créer `AlertsSection`
- [ ] **2.3.6.2** Widget `AlertCard` avec couleurs sémantiques

#### 2.3.7 Insights Section

- [ ] **2.3.7.1** Créer `InsightsSection`
- [ ] **2.3.7.2** Widget `InsightCard` avec actions
- [ ] **2.3.7.3** Bouton "Ask AI"

---

### 2.4 Refonte écrans existants

#### 2.4.1 App Detail Screen

- [ ] **2.4.1.1** Nouveau header avec icon et stats
- [ ] **2.4.1.2** Refonte Tab Overview avec TrendChart
- [ ] **2.4.1.3** Refonte Tab Ratings avec RingChart + HeatmapGrid
- [ ] **2.4.1.4** Refonte Tab Keywords avec Sparklines

#### 2.4.2 Keywords Screen

- [ ] **2.4.2.1** Ajouter sparklines dans tableau
- [ ] **2.4.2.2** Nouveau filtre par app/country/tag
- [ ] **2.4.2.3** Bulk actions améliorées

#### 2.4.3 Reviews Screen

- [ ] **2.4.3.1** Nouveau design cards reviews
- [ ] **2.4.3.2** Filtres sentiment/themes
- [ ] **2.4.3.3** AI reply suggestion inline

---

### 2.5 Tests Phase 2

- [ ] **2.5.1** Tests unitaires tous les widgets charts
- [ ] **2.5.2** Tests d'intégration dashboard
- [ ] **2.5.3** Tests golden images (visual regression)
- [ ] **2.5.4** Tests responsiveness (mobile/tablet/desktop)

---

## Phase 3: Deep Data Collection

> **Objectif** : Collectors autonomes qui tournent en background
> **Prérequis** : Phase 0 (infrastructure), Phase 1 (integrations pour owned apps)
> **Bloque** : Phase 4 (AI needs data)

### 3.1 Rankings Collector

#### 3.1.1 Implementation

- [ ] **3.1.1.1** Créer `app/Jobs/Collectors/RankingsCollector.php`
  ```php
  <?php

  namespace App\Jobs\Collectors;

  use App\Models\TrackedKeyword;
  use App\Models\AppRanking;
  use App\Services\iTunes\iTunesSearchService;
  use App\Services\GooglePlay\GooglePlaySearchService;

  class RankingsCollector extends BaseCollector
  {
      protected int $rateLimitMs = 200;

      public function getCollectorName(): string
      {
          return 'RankingsCollector';
      }

      public function getItems(): Collection
      {
          // Get unique (app_id, keyword_id) pairs
          return TrackedKeyword::query()
              ->select('app_id', 'keyword_id')
              ->distinct()
              ->with(['keyword', 'app'])
              ->get();
      }

      public function processItem($item): void
      {
          $keyword = $item->keyword;
          $app = $item->app;

          // Search in store
          $searchService = $app->platform === 'ios'
              ? app(iTunesSearchService::class)
              : app(GooglePlaySearchService::class);

          $results = $searchService->search(
              term: $keyword->term,
              country: $keyword->country_code,
              limit: 200
          );

          // Find position
          $position = null;
          foreach ($results as $index => $result) {
              if ($this->matchesApp($result, $app)) {
                  $position = $index + 1;
                  break;
              }
          }

          // Store
          AppRanking::create([
              'app_id' => $app->id,
              'keyword_id' => $keyword->id,
              'position' => $position,
              'recorded_at' => now(),
          ]);

          // Also update competitors
          $this->storeCompetitorRankings($keyword, $results);
      }

      private function matchesApp(array $result, App $app): bool
      {
          return $result['store_id'] === $app->store_id;
      }

      private function storeCompetitorRankings(Keyword $keyword, array $results): void
      {
          // Store top 10 for competitor analysis
          foreach (array_slice($results, 0, 10) as $index => $result) {
              // Find or create app
              // Store ranking
          }
      }
  }
  ```

- [ ] **3.1.1.2** Tests unitaires RankingsCollector
- [ ] **3.1.1.3** Test d'intégration avec vraies APIs

#### 3.1.2 Scheduling

- [ ] **3.1.2.1** Ajouter au scheduler (toutes les 2h)
- [ ] **3.1.2.2** Configurer monitoring

### 3.2 Ratings Collector

- [ ] **3.2.1** Créer `RatingsCollector`
- [ ] **3.2.2** Fetch parallel par pays
- [ ] **3.2.3** Scheduling toutes les 6h

### 3.3 Reviews Collector

- [ ] **3.3.1** Créer `ReviewsCollector`
- [ ] **3.3.2** Différentiel (seulement nouveaux)
- [ ] **3.3.3** Scheduling toutes les 4h

### 3.4 Top Charts Collector

- [ ] **3.4.1** Créer `TopChartsCollector`
- [ ] **3.4.2** Par catégorie et pays
- [ ] **3.4.3** Scheduling toutes les 6h

### 3.5 Metadata Collector

- [ ] **3.5.1** Créer `MetadataCollector`
- [ ] **3.5.2** Update icon, description, version
- [ ] **3.5.3** Scheduling journalier

### 3.6 Sales Collector (Owned apps)

- [ ] **3.6.1** Créer `SalesCollector`
- [ ] **3.6.2** Intégration App Store Connect API
- [ ] **3.6.3** Intégration Google Play Console API
- [ ] **3.6.4** Scheduling journalier 6h

### 3.7 Popularity Collector

- [ ] **3.7.1** Créer `PopularityCollector`
- [ ] **3.7.2** Intégration Apple Search Ads API
- [ ] **3.7.3** Scheduling journalier 3h

### 3.8 Aggregator Job

- [ ] **3.8.1** Créer `AggregatorJob`
- [ ] **3.8.2** Calcul weekly aggregates
- [ ] **3.8.3** Calcul monthly aggregates
- [ ] **3.8.4** Scheduling journalier 1h

### 3.9 Monitoring & Alerting

- [ ] **3.9.1** Dashboard admin collectors status
- [ ] **3.9.2** Alertes si collector fail
- [ ] **3.9.3** Metrics Prometheus/Grafana

---

## Phase 4: Intelligence IA

> **Objectif** : Insights automatiques et chat interactif
> **Prérequis** : Phase 3 (data to analyze)
> **Bloque** : Rien

### 4.1 Enrichment Pipeline

#### 4.1.1 Sentiment Analysis

- [ ] **4.1.1.1** Créer `EnrichmentJob`
- [ ] **4.1.1.2** Batch reviews pour GPT-5-nano
- [ ] **4.1.1.3** Stocker sentiment + score
- [ ] **4.1.1.4** Scheduling horaire

#### 4.1.2 Theme Extraction

- [ ] **4.1.2.1** Prompt pour extraction thèmes
- [ ] **4.1.2.2** Liste de thèmes standardisés
- [ ] **4.1.2.3** Stocker dans JSON

#### 4.1.3 Anomaly Detection

- [ ] **4.1.3.1** Détection statistique (z-score)
- [ ] **4.1.3.2** Seuils configurables
- [ ] **4.1.3.3** Génération événements

### 4.2 Insight Generation

#### 4.2.1 Daily Insights Job

- [ ] **4.2.1.1** Créer `InsightGeneratorJob`
- [ ] **4.2.1.2** Gather context (rankings, ratings, reviews, competitors)
- [ ] **4.2.1.3** Prompt GPT-5-nano
- [ ] **4.2.1.4** Parse et stocker insights

#### 4.2.2 Types d'insights

- [ ] **4.2.2.1** Opportunity (keyword trending)
- [ ] **4.2.2.2** Warning (anomalie négative)
- [ ] **4.2.2.3** Win (milestone atteint)
- [ ] **4.2.2.4** Theme (pattern reviews)
- [ ] **4.2.2.5** Competitor move

#### 4.2.3 UI Insights

- [ ] **4.2.3.1** Panneau insights dans dashboard
- [ ] **4.2.3.2** Page /insights dédiée
- [ ] **4.2.3.3** Actions (dismiss, view details)
- [ ] **4.2.3.4** Notifications push high priority

### 4.3 Chat IA

#### 4.3.1 Backend

- [ ] **4.3.1.1** Créer `ChatController`
- [ ] **4.3.1.2** Context retrieval (RAG)
- [ ] **4.3.1.3** Appel GPT-5-nano
- [ ] **4.3.1.4** Historique conversations

#### 4.3.2 Frontend

- [ ] **4.3.2.1** Page /chat
- [ ] **4.3.2.2** Modal chat accessible partout
- [ ] **4.3.2.3** Suggestions de questions
- [ ] **4.3.2.4** Citations cliquables

### 4.4 Weekly Digest

- [ ] **4.4.1** Créer `WeeklyDigestJob`
- [ ] **4.4.2** Template email HTML
- [ ] **4.4.3** Résumé semaine + top insights
- [ ] **4.4.4** Scheduling lundi 9h

---

## Phase 5: Polish & Scale

> **Objectif** : Monétisation et optimisation
> **Prérequis** : Phases 0-4
> **Bloque** : Rien

### 5.1 Plans & Billing

- [ ] **5.1.1** Intégration Stripe
- [ ] **5.1.2** Checkout flow
- [ ] **5.1.3** Customer portal
- [ ] **5.1.4** Webhooks (subscription events)
- [ ] **5.1.5** Enforcement des limites
- [ ] **5.1.6** UI settings/billing

### 5.2 Export

- [ ] **5.2.1** Export CSV rankings
- [ ] **5.2.2** Export CSV reviews
- [ ] **5.2.3** Export PDF reports
- [ ] **5.2.4** API publique (Pro+)

### 5.3 Performance

- [ ] **5.3.1** Query optimization
- [ ] **5.3.2** Redis caching
- [ ] **5.3.3** CDN assets
- [ ] **5.3.4** Load testing

### 5.4 Cold Storage

- [ ] **5.4.1** Migration données > 90 jours
- [ ] **5.4.2** Requêtes on-demand
- [ ] **5.4.3** UI historique étendu

---

## Dépendances entre phases

```
Phase 0 (Fondations)
    │
    ├──► Phase 1 (Onboarding)
    │        │
    │        └──► Phase 3 (Collectors - owned apps)
    │
    └──► Phase 2 (Dashboard)
             │
             └──► (peut commencer en parallèle de Phase 1)

Phase 3 (Collectors)
    │
    └──► Phase 4 (IA - needs data)

Toutes les phases
    │
    └──► Phase 5 (Polish - after core features)
```

---

## Risques et mitigations

| Risque | Impact | Probabilité | Mitigation |
|--------|--------|-------------|------------|
| Rate limiting APIs stores | Haut | Moyen | Exponential backoff, caching, répartition horaire |
| Coûts GPT-5-nano | Moyen | Faible | Batch processing, caching réponses, limites par plan |
| Performance DB avec volume | Haut | Moyen | Partitionnement, aggregates, cold storage |
| Changement APIs Apple/Google | Haut | Faible | Abstraction services, monitoring, alertes |
| Complexité onboarding ASC | Moyen | Moyen | Documentation détaillée, vidéos, support chat |

---

## Checklist de lancement

### Pre-launch

- [ ] Tous les tests passent
- [ ] Performance acceptable (< 200ms p95)
- [ ] Collectors stables 48h+
- [ ] Onboarding testé par 5 beta users
- [ ] Documentation utilisateur
- [ ] Monitoring en place
- [ ] Backup strategy validée

### Launch

- [ ] Annonce blog/social
- [ ] Email liste d'attente
- [ ] Analytics tracking
- [ ] Support channel ready

### Post-launch

- [ ] Monitor errors (Sentry)
- [ ] Monitor performance
- [ ] Collect feedback
- [ ] Iterate rapidement

---

*Document généré le 11 janvier 2026*
