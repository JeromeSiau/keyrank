# Data Aggregation Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implémenter l'agrégation tiered des données de ranking (daily → weekly → monthly) pour conserver l'historique long terme.

**Architecture:** Deux nouvelles tables d'agrégats. Le cleanup existant est modifié pour agréger avant de supprimer. L'endpoint `history` combine les trois sources de données.

**Tech Stack:** Laravel 11, PHP 8.3, MySQL, PHPUnit

---

## Task 1: Migration - Tables d'agrégats

**Files:**
- Create: `api/database/migrations/2026_01_11_300001_create_aggregate_tables.php`

**Step 1: Créer la migration**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('app_ranking_aggregates', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->cascadeOnDelete();
            $table->foreignId('keyword_id')->constrained()->cascadeOnDelete();
            $table->enum('period_type', ['weekly', 'monthly']);
            $table->date('period_start');
            $table->decimal('avg_position', 5, 2);
            $table->unsignedInteger('min_position');
            $table->unsignedInteger('max_position');
            $table->unsignedTinyInteger('data_points');

            $table->unique(['app_id', 'keyword_id', 'period_type', 'period_start'], 'ranking_agg_unique');
            $table->index(['period_type', 'period_start']);
        });

        Schema::create('keyword_popularity_aggregates', function (Blueprint $table) {
            $table->id();
            $table->foreignId('keyword_id')->constrained()->cascadeOnDelete();
            $table->enum('period_type', ['weekly', 'monthly']);
            $table->date('period_start');
            $table->decimal('avg_popularity', 5, 2);
            $table->unsignedInteger('min_popularity');
            $table->unsignedInteger('max_popularity');
            $table->unsignedTinyInteger('data_points');

            $table->unique(['keyword_id', 'period_type', 'period_start'], 'popularity_agg_unique');
            $table->index(['period_type', 'period_start']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('keyword_popularity_aggregates');
        Schema::dropIfExists('app_ranking_aggregates');
    }
};
```

**Step 2: Exécuter la migration**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/api && php artisan migrate`
Expected: Tables créées sans erreur

**Step 3: Commit**

```bash
git add api/database/migrations/2026_01_11_300001_create_aggregate_tables.php
git commit -m "feat(db): add aggregate tables for ranking and popularity history"
```

---

## Task 2: Modèles Eloquent

**Files:**
- Create: `api/app/Models/AppRankingAggregate.php`
- Create: `api/app/Models/KeywordPopularityAggregate.php`

**Step 1: Créer AppRankingAggregate**

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppRankingAggregate extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'app_id',
        'keyword_id',
        'period_type',
        'period_start',
        'avg_position',
        'min_position',
        'max_position',
        'data_points',
    ];

    protected $casts = [
        'avg_position' => 'float',
        'min_position' => 'integer',
        'max_position' => 'integer',
        'data_points' => 'integer',
        'period_start' => 'date',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }

    public function keyword(): BelongsTo
    {
        return $this->belongsTo(Keyword::class);
    }
}
```

**Step 2: Créer KeywordPopularityAggregate**

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class KeywordPopularityAggregate extends Model
{
    public $timestamps = false;

    protected $table = 'keyword_popularity_aggregates';

    protected $fillable = [
        'keyword_id',
        'period_type',
        'period_start',
        'avg_popularity',
        'min_popularity',
        'max_popularity',
        'data_points',
    ];

    protected $casts = [
        'avg_popularity' => 'float',
        'min_popularity' => 'integer',
        'max_popularity' => 'integer',
        'data_points' => 'integer',
        'period_start' => 'date',
    ];

    public function keyword(): BelongsTo
    {
        return $this->belongsTo(Keyword::class);
    }
}
```

**Step 3: Commit**

```bash
git add api/app/Models/AppRankingAggregate.php api/app/Models/KeywordPopularityAggregate.php
git commit -m "feat(models): add aggregate models for rankings and popularity"
```

---

## Task 3: Service d'agrégation - Tests

**Files:**
- Create: `api/tests/Feature/AggregationServiceTest.php`

**Step 1: Écrire les tests**

```php
<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\AppRanking;
use App\Models\AppRankingAggregate;
use App\Models\Keyword;
use App\Models\KeywordPopularityAggregate;
use App\Models\KeywordPopularityHistory;
use App\Services\AggregationService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AggregationServiceTest extends TestCase
{
    use RefreshDatabase;

    private AggregationService $service;

    protected function setUp(): void
    {
        parent::setUp();
        $this->service = new AggregationService();
    }

    public function test_aggregates_daily_rankings_to_weekly(): void
    {
        $app = App::factory()->create();
        $keyword = Keyword::factory()->create();

        // Create 7 days of rankings starting 100 days ago (> 90 days cutoff)
        $startDate = now()->subDays(100)->startOfWeek();
        for ($i = 0; $i < 7; $i++) {
            AppRanking::create([
                'app_id' => $app->id,
                'keyword_id' => $keyword->id,
                'position' => 10 + $i, // positions 10-16
                'recorded_at' => $startDate->copy()->addDays($i),
            ]);
        }

        $this->service->aggregateDailyToWeekly(90);

        // Verify aggregate was created
        $aggregate = AppRankingAggregate::where('app_id', $app->id)
            ->where('keyword_id', $keyword->id)
            ->where('period_type', 'weekly')
            ->first();

        $this->assertNotNull($aggregate);
        $this->assertEquals(13.0, $aggregate->avg_position); // (10+11+12+13+14+15+16)/7 = 13
        $this->assertEquals(10, $aggregate->min_position);
        $this->assertEquals(16, $aggregate->max_position);
        $this->assertEquals(7, $aggregate->data_points);

        // Verify daily records were deleted
        $this->assertEquals(0, AppRanking::where('app_id', $app->id)->count());
    }

    public function test_does_not_aggregate_recent_daily_rankings(): void
    {
        $app = App::factory()->create();
        $keyword = Keyword::factory()->create();

        // Create ranking within 90 days (should NOT be aggregated)
        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 5,
            'recorded_at' => now()->subDays(30),
        ]);

        $this->service->aggregateDailyToWeekly(90);

        // Verify no aggregate was created
        $this->assertEquals(0, AppRankingAggregate::count());

        // Verify daily record still exists
        $this->assertEquals(1, AppRanking::count());
    }

    public function test_aggregates_weekly_to_monthly(): void
    {
        $app = App::factory()->create();
        $keyword = Keyword::factory()->create();

        // Create 4 weekly aggregates from > 1 year ago
        $monthStart = now()->subMonths(14)->startOfMonth();
        for ($week = 0; $week < 4; $week++) {
            AppRankingAggregate::create([
                'app_id' => $app->id,
                'keyword_id' => $keyword->id,
                'period_type' => 'weekly',
                'period_start' => $monthStart->copy()->addWeeks($week),
                'avg_position' => 10 + $week,
                'min_position' => 8 + $week,
                'max_position' => 12 + $week,
                'data_points' => 7,
            ]);
        }

        $this->service->aggregateWeeklyToMonthly(365);

        // Verify monthly aggregate was created
        $monthly = AppRankingAggregate::where('period_type', 'monthly')->first();

        $this->assertNotNull($monthly);
        $this->assertEquals(11.5, $monthly->avg_position); // (10+11+12+13)/4 = 11.5
        $this->assertEquals(8, $monthly->min_position); // min of all mins
        $this->assertEquals(15, $monthly->max_position); // max of all maxes
        $this->assertEquals(28, $monthly->data_points); // 4 weeks * 7 days

        // Verify weekly records were deleted
        $this->assertEquals(0, AppRankingAggregate::where('period_type', 'weekly')->count());
    }

    public function test_aggregates_popularity_daily_to_weekly(): void
    {
        $keyword = Keyword::factory()->create();

        // Create 7 days of popularity starting 100 days ago
        $startDate = now()->subDays(100)->startOfWeek();
        for ($i = 0; $i < 7; $i++) {
            KeywordPopularityHistory::create([
                'keyword_id' => $keyword->id,
                'popularity' => 50 + $i,
                'recorded_at' => $startDate->copy()->addDays($i),
            ]);
        }

        $this->service->aggregateDailyToWeekly(90);

        $aggregate = KeywordPopularityAggregate::first();

        $this->assertNotNull($aggregate);
        $this->assertEquals(53.0, $aggregate->avg_popularity);
        $this->assertEquals(50, $aggregate->min_popularity);
        $this->assertEquals(56, $aggregate->max_popularity);
        $this->assertEquals(7, $aggregate->data_points);
    }

    public function test_handles_partial_week_data(): void
    {
        $app = App::factory()->create();
        $keyword = Keyword::factory()->create();

        // Create only 3 days of rankings (partial week)
        $startDate = now()->subDays(100)->startOfWeek();
        for ($i = 0; $i < 3; $i++) {
            AppRanking::create([
                'app_id' => $app->id,
                'keyword_id' => $keyword->id,
                'position' => 10 + $i,
                'recorded_at' => $startDate->copy()->addDays($i),
            ]);
        }

        $this->service->aggregateDailyToWeekly(90);

        $aggregate = AppRankingAggregate::first();

        $this->assertNotNull($aggregate);
        $this->assertEquals(3, $aggregate->data_points); // Only 3 days
    }
}
```

**Step 2: Exécuter les tests (doivent échouer)**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/api && php artisan test --filter=AggregationServiceTest`
Expected: FAIL - Class AggregationService not found

**Step 3: Commit le test**

```bash
git add api/tests/Feature/AggregationServiceTest.php
git commit -m "test: add aggregation service tests (red)"
```

---

## Task 4: Service d'agrégation - Implémentation

**Files:**
- Create: `api/app/Services/AggregationService.php`

**Step 1: Implémenter le service**

```php
<?php

namespace App\Services;

use App\Models\AppRanking;
use App\Models\AppRankingAggregate;
use App\Models\KeywordPopularityAggregate;
use App\Models\KeywordPopularityHistory;
use Illuminate\Support\Facades\DB;

class AggregationService
{
    /**
     * Aggregate daily rankings older than $days into weekly aggregates.
     */
    public function aggregateDailyToWeekly(int $days): array
    {
        $cutoff = now()->subDays($days);
        $stats = ['rankings' => 0, 'popularity' => 0];

        // Aggregate rankings
        $rankings = AppRanking::where('recorded_at', '<', $cutoff)
            ->select([
                'app_id',
                'keyword_id',
                DB::raw('YEARWEEK(recorded_at, 1) as year_week'),
                DB::raw('MIN(DATE(recorded_at) - INTERVAL WEEKDAY(recorded_at) DAY) as period_start'),
                DB::raw('AVG(position) as avg_position'),
                DB::raw('MIN(position) as min_position'),
                DB::raw('MAX(position) as max_position'),
                DB::raw('COUNT(*) as data_points'),
            ])
            ->groupBy('app_id', 'keyword_id', DB::raw('YEARWEEK(recorded_at, 1)'))
            ->get();

        foreach ($rankings as $row) {
            AppRankingAggregate::updateOrCreate(
                [
                    'app_id' => $row->app_id,
                    'keyword_id' => $row->keyword_id,
                    'period_type' => 'weekly',
                    'period_start' => $row->period_start,
                ],
                [
                    'avg_position' => round($row->avg_position, 2),
                    'min_position' => $row->min_position,
                    'max_position' => $row->max_position,
                    'data_points' => $row->data_points,
                ]
            );
            $stats['rankings']++;
        }

        // Delete aggregated daily rankings
        AppRanking::where('recorded_at', '<', $cutoff)->delete();

        // Aggregate popularity
        $popularity = KeywordPopularityHistory::where('recorded_at', '<', $cutoff)
            ->select([
                'keyword_id',
                DB::raw('YEARWEEK(recorded_at, 1) as year_week'),
                DB::raw('MIN(DATE(recorded_at) - INTERVAL WEEKDAY(recorded_at) DAY) as period_start'),
                DB::raw('AVG(popularity) as avg_popularity'),
                DB::raw('MIN(popularity) as min_popularity'),
                DB::raw('MAX(popularity) as max_popularity'),
                DB::raw('COUNT(*) as data_points'),
            ])
            ->groupBy('keyword_id', DB::raw('YEARWEEK(recorded_at, 1)'))
            ->get();

        foreach ($popularity as $row) {
            KeywordPopularityAggregate::updateOrCreate(
                [
                    'keyword_id' => $row->keyword_id,
                    'period_type' => 'weekly',
                    'period_start' => $row->period_start,
                ],
                [
                    'avg_popularity' => round($row->avg_popularity, 2),
                    'min_popularity' => $row->min_popularity,
                    'max_popularity' => $row->max_popularity,
                    'data_points' => $row->data_points,
                ]
            );
            $stats['popularity']++;
        }

        // Delete aggregated daily popularity
        KeywordPopularityHistory::where('recorded_at', '<', $cutoff)->delete();

        return $stats;
    }

    /**
     * Aggregate weekly aggregates older than $days into monthly aggregates.
     */
    public function aggregateWeeklyToMonthly(int $days): array
    {
        $cutoff = now()->subDays($days);
        $stats = ['rankings' => 0, 'popularity' => 0];

        // Aggregate rankings
        $rankings = AppRankingAggregate::where('period_type', 'weekly')
            ->where('period_start', '<', $cutoff)
            ->select([
                'app_id',
                'keyword_id',
                DB::raw('DATE_FORMAT(period_start, "%Y-%m-01") as month_start'),
                DB::raw('SUM(avg_position * data_points) / SUM(data_points) as avg_position'),
                DB::raw('MIN(min_position) as min_position'),
                DB::raw('MAX(max_position) as max_position'),
                DB::raw('SUM(data_points) as data_points'),
            ])
            ->groupBy('app_id', 'keyword_id', DB::raw('DATE_FORMAT(period_start, "%Y-%m-01")'))
            ->get();

        foreach ($rankings as $row) {
            AppRankingAggregate::updateOrCreate(
                [
                    'app_id' => $row->app_id,
                    'keyword_id' => $row->keyword_id,
                    'period_type' => 'monthly',
                    'period_start' => $row->month_start,
                ],
                [
                    'avg_position' => round($row->avg_position, 2),
                    'min_position' => $row->min_position,
                    'max_position' => $row->max_position,
                    'data_points' => $row->data_points,
                ]
            );
            $stats['rankings']++;
        }

        // Delete aggregated weekly rankings
        AppRankingAggregate::where('period_type', 'weekly')
            ->where('period_start', '<', $cutoff)
            ->delete();

        // Aggregate popularity
        $popularity = KeywordPopularityAggregate::where('period_type', 'weekly')
            ->where('period_start', '<', $cutoff)
            ->select([
                'keyword_id',
                DB::raw('DATE_FORMAT(period_start, "%Y-%m-01") as month_start'),
                DB::raw('SUM(avg_popularity * data_points) / SUM(data_points) as avg_popularity'),
                DB::raw('MIN(min_popularity) as min_popularity'),
                DB::raw('MAX(max_popularity) as max_popularity'),
                DB::raw('SUM(data_points) as data_points'),
            ])
            ->groupBy('keyword_id', DB::raw('DATE_FORMAT(period_start, "%Y-%m-01")'))
            ->get();

        foreach ($popularity as $row) {
            KeywordPopularityAggregate::updateOrCreate(
                [
                    'keyword_id' => $row->keyword_id,
                    'period_type' => 'monthly',
                    'period_start' => $row->month_start,
                ],
                [
                    'avg_popularity' => round($row->avg_popularity, 2),
                    'min_popularity' => $row->min_popularity,
                    'max_popularity' => $row->max_popularity,
                    'data_points' => $row->data_points,
                ]
            );
            $stats['popularity']++;
        }

        // Delete aggregated weekly popularity
        KeywordPopularityAggregate::where('period_type', 'weekly')
            ->where('period_start', '<', $cutoff)
            ->delete();

        return $stats;
    }
}
```

**Step 2: Exécuter les tests**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/api && php artisan test --filter=AggregationServiceTest`
Expected: PASS (tous les tests)

**Step 3: Commit**

```bash
git add api/app/Services/AggregationService.php
git commit -m "feat: implement aggregation service for daily→weekly→monthly"
```

---

## Task 5: Modifier CleanupHistory

**Files:**
- Modify: `api/app/Console/Commands/CleanupHistory.php`

**Step 1: Écrire le test pour le cleanup modifié**

Add to `api/tests/Feature/CleanupHistoryCommandTest.php`:

```php
<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\AppRanking;
use App\Models\AppRankingAggregate;
use App\Models\Keyword;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CleanupHistoryCommandTest extends TestCase
{
    use RefreshDatabase;

    public function test_cleanup_aggregates_before_deleting(): void
    {
        $app = App::factory()->create();
        $keyword = Keyword::factory()->create();

        // Create old rankings (> 90 days)
        for ($i = 0; $i < 7; $i++) {
            AppRanking::create([
                'app_id' => $app->id,
                'keyword_id' => $keyword->id,
                'position' => 10 + $i,
                'recorded_at' => now()->subDays(100)->startOfWeek()->addDays($i),
            ]);
        }

        // Create recent ranking (should be kept)
        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 5,
            'recorded_at' => now()->subDays(30),
        ]);

        $this->artisan('aso:cleanup', ['--days' => 90])
            ->assertSuccessful();

        // Old rankings should be aggregated then deleted
        $this->assertEquals(1, AppRanking::count()); // Only recent one remains

        // Aggregate should be created
        $aggregate = AppRankingAggregate::first();
        $this->assertNotNull($aggregate);
        $this->assertEquals('weekly', $aggregate->period_type);
    }
}
```

**Step 2: Modifier CleanupHistory.php**

```php
<?php

namespace App\Console\Commands;

use App\Services\AggregationService;
use Illuminate\Console\Command;

class CleanupHistory extends Command
{
    protected $signature = 'aso:cleanup {--days=90 : Keep daily history for this many days}';
    protected $description = 'Aggregate old data and clean up history';

    public function __construct(private AggregationService $aggregationService)
    {
        parent::__construct();
    }

    public function handle(): int
    {
        $days = (int) $this->option('days');

        $this->info("Processing history older than {$days} days...");

        // Step 1: Weekly → Monthly (data older than 1 year)
        $this->info('Aggregating weekly to monthly (> 1 year)...');
        $monthlyStats = $this->aggregationService->aggregateWeeklyToMonthly(365);
        $this->info("Created {$monthlyStats['rankings']} monthly ranking aggregates.");
        $this->info("Created {$monthlyStats['popularity']} monthly popularity aggregates.");

        // Step 2: Daily → Weekly (data older than $days)
        $this->info("Aggregating daily to weekly (> {$days} days)...");
        $weeklyStats = $this->aggregationService->aggregateDailyToWeekly($days);
        $this->info("Created {$weeklyStats['rankings']} weekly ranking aggregates.");
        $this->info("Created {$weeklyStats['popularity']} weekly popularity aggregates.");

        $this->info('Cleanup complete.');

        return 0;
    }
}
```

**Step 3: Exécuter les tests**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/api && php artisan test --filter=CleanupHistoryCommandTest`
Expected: PASS

**Step 4: Commit**

```bash
git add api/app/Console/Commands/CleanupHistory.php api/tests/Feature/CleanupHistoryCommandTest.php
git commit -m "feat: update cleanup command to aggregate before deleting"
```

---

## Task 6: API unifiée - Tests

**Files:**
- Create: `api/tests/Feature/RankingHistoryTest.php`

**Step 1: Écrire les tests pour l'endpoint history modifié**

```php
<?php

namespace Tests\Feature;

use App\Models\App;
use App\Models\AppRanking;
use App\Models\AppRankingAggregate;
use App\Models\Keyword;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class RankingHistoryTest extends TestCase
{
    use RefreshDatabase;

    public function test_history_returns_daily_data(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();

        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 5,
            'recorded_at' => now()->subDays(10),
        ]);

        $response = $this->actingAs($user)
            ->getJson("/api/apps/{$app->id}/rankings/history?keyword_id={$keyword->id}&from=" . now()->subDays(30)->toDateString());

        $response->assertOk();
        $response->assertJsonPath('data.0.type', 'daily');
        $response->assertJsonPath('data.0.position', 5);
    }

    public function test_history_includes_weekly_aggregates(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();

        AppRankingAggregate::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'period_type' => 'weekly',
            'period_start' => now()->subDays(120),
            'avg_position' => 8.5,
            'min_position' => 5,
            'max_position' => 12,
            'data_points' => 7,
        ]);

        $response = $this->actingAs($user)
            ->getJson("/api/apps/{$app->id}/rankings/history?keyword_id={$keyword->id}&from=" . now()->subDays(150)->toDateString());

        $response->assertOk();
        $response->assertJsonPath('data.0.type', 'weekly');
        $response->assertJsonPath('data.0.avg', 8.5);
        $response->assertJsonPath('data.0.min', 5);
        $response->assertJsonPath('data.0.max', 12);
    }

    public function test_history_includes_monthly_aggregates(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();

        AppRankingAggregate::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'period_type' => 'monthly',
            'period_start' => now()->subMonths(14)->startOfMonth(),
            'avg_position' => 15.3,
            'min_position' => 8,
            'max_position' => 25,
            'data_points' => 28,
        ]);

        $response = $this->actingAs($user)
            ->getJson("/api/apps/{$app->id}/rankings/history?keyword_id={$keyword->id}&from=" . now()->subMonths(16)->toDateString());

        $response->assertOk();
        $response->assertJsonPath('data.0.type', 'monthly');
    }

    public function test_history_combines_all_data_types_sorted(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();

        // Daily (recent)
        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 5,
            'recorded_at' => now()->subDays(10),
        ]);

        // Weekly (older)
        AppRankingAggregate::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'period_type' => 'weekly',
            'period_start' => now()->subDays(120),
            'avg_position' => 8.5,
            'min_position' => 5,
            'max_position' => 12,
            'data_points' => 7,
        ]);

        // Monthly (oldest)
        AppRankingAggregate::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'period_type' => 'monthly',
            'period_start' => now()->subMonths(14)->startOfMonth(),
            'avg_position' => 15.3,
            'min_position' => 8,
            'max_position' => 25,
            'data_points' => 28,
        ]);

        $response = $this->actingAs($user)
            ->getJson("/api/apps/{$app->id}/rankings/history?keyword_id={$keyword->id}&from=" . now()->subMonths(16)->toDateString());

        $response->assertOk();
        $data = $response->json('data');

        // Should be sorted by date ascending (oldest first)
        $this->assertEquals('monthly', $data[0]['type']);
        $this->assertEquals('weekly', $data[1]['type']);
        $this->assertEquals('daily', $data[2]['type']);
    }
}
```

**Step 2: Commit le test**

```bash
git add api/tests/Feature/RankingHistoryTest.php
git commit -m "test: add ranking history unified endpoint tests (red)"
```

---

## Task 7: API unifiée - Implémentation

**Files:**
- Modify: `api/app/Http/Controllers/Api/RankingController.php:143-161`

**Step 1: Modifier la méthode history()**

Remplacer la méthode `history()` existante :

```php
/**
 * Get ranking history for a keyword (combines daily + weekly + monthly)
 */
public function history(Request $request, App $app): JsonResponse
{
    $validated = $request->validate([
        'keyword_id' => 'required|integer|exists:keywords,id',
        'from' => 'nullable|date',
        'to' => 'nullable|date',
    ]);

    $keywordId = $validated['keyword_id'];
    $from = isset($validated['from']) ? Carbon::parse($validated['from']) : now()->subDays(30);
    $to = isset($validated['to']) ? Carbon::parse($validated['to']) : now();

    $result = collect();

    // Get daily data
    $daily = $app->rankings()
        ->where('keyword_id', $keywordId)
        ->whereBetween('recorded_at', [$from, $to])
        ->orderBy('recorded_at')
        ->get(['position', 'recorded_at'])
        ->map(fn ($r) => [
            'date' => $r->recorded_at->toDateString(),
            'position' => $r->position,
            'type' => 'daily',
        ]);
    $result = $result->concat($daily);

    // Get weekly aggregates
    $weekly = AppRankingAggregate::where('app_id', $app->id)
        ->where('keyword_id', $keywordId)
        ->where('period_type', 'weekly')
        ->whereBetween('period_start', [$from, $to])
        ->orderBy('period_start')
        ->get()
        ->map(fn ($a) => [
            'period_start' => $a->period_start->toDateString(),
            'avg' => $a->avg_position,
            'min' => $a->min_position,
            'max' => $a->max_position,
            'data_points' => $a->data_points,
            'type' => 'weekly',
        ]);
    $result = $result->concat($weekly);

    // Get monthly aggregates
    $monthly = AppRankingAggregate::where('app_id', $app->id)
        ->where('keyword_id', $keywordId)
        ->where('period_type', 'monthly')
        ->whereBetween('period_start', [$from, $to])
        ->orderBy('period_start')
        ->get()
        ->map(fn ($a) => [
            'period_start' => $a->period_start->toDateString(),
            'avg' => $a->avg_position,
            'min' => $a->min_position,
            'max' => $a->max_position,
            'data_points' => $a->data_points,
            'type' => 'monthly',
        ]);
    $result = $result->concat($monthly);

    // Sort by date (use 'date' for daily, 'period_start' for aggregates)
    $sorted = $result->sortBy(fn ($item) => $item['date'] ?? $item['period_start'])->values();

    return response()->json([
        'data' => $sorted,
    ]);
}
```

**Step 2: Ajouter les imports nécessaires**

En haut du fichier, ajouter :

```php
use App\Models\AppRankingAggregate;
use Carbon\Carbon;
```

**Step 3: Exécuter les tests**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/api && php artisan test --filter=RankingHistoryTest`
Expected: PASS

**Step 4: Commit**

```bash
git add api/app/Http/Controllers/Api/RankingController.php
git commit -m "feat: update history endpoint to include aggregated data"
```

---

## Task 8: Commande de migration one-shot

**Files:**
- Create: `api/app/Console/Commands/MigrateToAggregates.php`

**Step 1: Créer la commande de migration**

```php
<?php

namespace App\Console\Commands;

use App\Services\AggregationService;
use Illuminate\Console\Command;

class MigrateToAggregates extends Command
{
    protected $signature = 'aso:migrate-to-aggregates
                            {--days=90 : Daily data retention in days}
                            {--dry-run : Show what would be done without making changes}';
    protected $description = 'One-time migration: aggregate existing historical data';

    public function __construct(private AggregationService $aggregationService)
    {
        parent::__construct();
    }

    public function handle(): int
    {
        $days = (int) $this->option('days');
        $dryRun = $this->option('dry-run');

        if ($dryRun) {
            $this->warn('DRY RUN - No changes will be made.');
        }

        $this->info('Migrating existing historical data to aggregates...');
        $this->info("Daily retention: {$days} days");
        $this->info('Weekly retention: 365 days');
        $this->info('Monthly retention: unlimited');

        if (!$dryRun && !$this->confirm('This will permanently transform old daily data into aggregates. Continue?')) {
            $this->info('Aborted.');
            return 1;
        }

        if ($dryRun) {
            $this->info('Would aggregate data older than 365 days into monthly aggregates.');
            $this->info("Would aggregate data between {$days} and 365 days into weekly aggregates.");
            return 0;
        }

        // Step 1: Aggregate really old data to monthly first
        $this->info('Step 1: Converting weekly aggregates > 1 year to monthly...');
        $monthlyStats = $this->aggregationService->aggregateWeeklyToMonthly(365);
        $this->info("Created {$monthlyStats['rankings']} monthly ranking aggregates.");
        $this->info("Created {$monthlyStats['popularity']} monthly popularity aggregates.");

        // Step 2: Aggregate old daily data to weekly
        $this->info("Step 2: Converting daily data > {$days} days to weekly...");
        $weeklyStats = $this->aggregationService->aggregateDailyToWeekly($days);
        $this->info("Created {$weeklyStats['rankings']} weekly ranking aggregates.");
        $this->info("Created {$weeklyStats['popularity']} weekly popularity aggregates.");

        $this->info('Migration complete!');

        return 0;
    }
}
```

**Step 2: Commit**

```bash
git add api/app/Console/Commands/MigrateToAggregates.php
git commit -m "feat: add one-time migration command for existing historical data"
```

---

## Task 9: Tests finaux et nettoyage

**Step 1: Exécuter tous les tests**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/api && php artisan test`
Expected: All tests pass

**Step 2: Vérifier le linting**

Run: `cd /Users/jerome/Projets/web/flutter/ranking/api && ./vendor/bin/pint --test`
Expected: No issues (ou fix avec `./vendor/bin/pint`)

**Step 3: Commit final si fixes**

```bash
git add -A
git commit -m "style: apply code formatting"
```

---

## Déploiement

1. Déployer le code
2. Exécuter les migrations : `php artisan migrate`
3. Lancer la migration one-shot : `php artisan aso:migrate-to-aggregates`
4. Le cron existant (`aso:cleanup`) gère maintenant l'agrégation automatique
