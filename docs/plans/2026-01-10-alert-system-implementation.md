# Alert System Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement a configurable alert system with push notifications for ranking changes, ratings, reviews, and competitor movements.

**Architecture:** Event-driven evaluation triggered after sync jobs. AlertEvaluatorService detects rule matches, NotificationService aggregates and sends via Firebase FCM. Rules use layered scope inheritance (global → app/category → specific).

**Tech Stack:** Laravel 11, Firebase Cloud Messaging, laravel-notification-channels/fcm

---

## Phase 1: Database & Models

### Task 1.1: Create alert_rules migration

**Files:**
- Create: `api/database/migrations/2026_01_11_000001_create_alert_rules_table.php`

**Step 1: Create migration file**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('alert_rules', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('name');
            $table->enum('type', [
                'position_change',
                'rating_change',
                'review_spike',
                'review_keyword',
                'new_competitor',
                'competitor_passed',
                'mass_movement',
                'keyword_popularity',
                'opportunity',
            ]);
            $table->enum('scope_type', ['global', 'app', 'category', 'keyword'])->default('global');
            $table->unsignedBigInteger('scope_id')->nullable();
            $table->json('conditions');
            $table->boolean('is_template')->default(false);
            $table->boolean('is_active')->default(true);
            $table->integer('priority')->default(0);
            $table->timestamps();

            $table->index(['user_id', 'type', 'is_active']);
            $table->index(['user_id', 'scope_type', 'scope_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('alert_rules');
    }
};
```

**Step 2: Run migration**

Run: `cd api && php artisan migrate`
Expected: Migration successful

**Step 3: Commit**

```bash
git add api/database/migrations/2026_01_11_000001_create_alert_rules_table.php
git commit -m "feat(alerts): add alert_rules migration"
```

---

### Task 1.2: Create notifications migration

**Files:**
- Create: `api/database/migrations/2026_01_11_000002_create_notifications_table.php`

**Step 1: Create migration file**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('notifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('alert_rule_id')->nullable()->constrained()->nullOnDelete();
            $table->enum('type', [
                'position_change',
                'rating_change',
                'review_spike',
                'review_keyword',
                'new_competitor',
                'competitor_passed',
                'mass_movement',
                'keyword_popularity',
                'opportunity',
                'aggregated',
            ]);
            $table->string('title');
            $table->text('body');
            $table->json('data')->nullable();
            $table->boolean('is_read')->default(false);
            $table->timestamp('read_at')->nullable();
            $table->timestamp('sent_at')->nullable();
            $table->timestamp('created_at')->nullable();

            $table->index(['user_id', 'is_read', 'created_at']);
            $table->index(['user_id', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('notifications');
    }
};
```

**Step 2: Run migration**

Run: `cd api && php artisan migrate`
Expected: Migration successful

**Step 3: Commit**

```bash
git add api/database/migrations/2026_01_11_000002_create_notifications_table.php
git commit -m "feat(alerts): add notifications migration"
```

---

### Task 1.3: Add alert settings to users table

**Files:**
- Create: `api/database/migrations/2026_01_11_000003_add_alert_settings_to_users_table.php`

**Step 1: Create migration file**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('timezone', 50)->default('UTC')->after('locale');
            $table->string('fcm_token', 255)->nullable()->after('timezone');
            $table->time('quiet_hours_start')->default('22:00:00')->after('fcm_token');
            $table->time('quiet_hours_end')->default('08:00:00')->after('quiet_hours_start');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['timezone', 'fcm_token', 'quiet_hours_start', 'quiet_hours_end']);
        });
    }
};
```

**Step 2: Run migration**

Run: `cd api && php artisan migrate`
Expected: Migration successful

**Step 3: Commit**

```bash
git add api/database/migrations/2026_01_11_000003_add_alert_settings_to_users_table.php
git commit -m "feat(alerts): add alert settings to users table"
```

---

### Task 1.4: Create AlertRule model

**Files:**
- Create: `api/app/Models/AlertRule.php`
- Create: `api/database/factories/AlertRuleFactory.php`

**Step 1: Create model**

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class AlertRule extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'type',
        'scope_type',
        'scope_id',
        'conditions',
        'is_template',
        'is_active',
        'priority',
    ];

    protected $casts = [
        'conditions' => 'array',
        'is_template' => 'boolean',
        'is_active' => 'boolean',
        'priority' => 'integer',
    ];

    public const TYPE_POSITION_CHANGE = 'position_change';
    public const TYPE_RATING_CHANGE = 'rating_change';
    public const TYPE_REVIEW_SPIKE = 'review_spike';
    public const TYPE_REVIEW_KEYWORD = 'review_keyword';
    public const TYPE_NEW_COMPETITOR = 'new_competitor';
    public const TYPE_COMPETITOR_PASSED = 'competitor_passed';
    public const TYPE_MASS_MOVEMENT = 'mass_movement';
    public const TYPE_KEYWORD_POPULARITY = 'keyword_popularity';
    public const TYPE_OPPORTUNITY = 'opportunity';

    public const SCOPE_GLOBAL = 'global';
    public const SCOPE_APP = 'app';
    public const SCOPE_CATEGORY = 'category';
    public const SCOPE_KEYWORD = 'keyword';

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function notifications(): HasMany
    {
        return $this->hasMany(Notification::class);
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeForType($query, string $type)
    {
        return $query->where('type', $type);
    }

    public function scopeForUser($query, int $userId)
    {
        return $query->where('user_id', $userId);
    }
}
```

**Step 2: Create factory**

```php
<?php

namespace Database\Factories;

use App\Models\AlertRule;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class AlertRuleFactory extends Factory
{
    protected $model = AlertRule::class;

    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'name' => $this->faker->words(3, true),
            'type' => AlertRule::TYPE_POSITION_CHANGE,
            'scope_type' => AlertRule::SCOPE_GLOBAL,
            'scope_id' => null,
            'conditions' => ['direction' => 'down', 'threshold' => 10],
            'is_template' => false,
            'is_active' => true,
            'priority' => 0,
        ];
    }

    public function inactive(): self
    {
        return $this->state(['is_active' => false]);
    }

    public function template(): self
    {
        return $this->state(['is_template' => true]);
    }

    public function forApp(int $appId): self
    {
        return $this->state([
            'scope_type' => AlertRule::SCOPE_APP,
            'scope_id' => $appId,
        ]);
    }
}
```

**Step 3: Commit**

```bash
git add api/app/Models/AlertRule.php api/database/factories/AlertRuleFactory.php
git commit -m "feat(alerts): add AlertRule model and factory"
```

---

### Task 1.5: Create Notification model

**Files:**
- Create: `api/app/Models/Notification.php`
- Create: `api/database/factories/NotificationFactory.php`

**Step 1: Create model**

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Notification extends Model
{
    use HasFactory;

    public $timestamps = false;

    protected $fillable = [
        'user_id',
        'alert_rule_id',
        'type',
        'title',
        'body',
        'data',
        'is_read',
        'read_at',
        'sent_at',
        'created_at',
    ];

    protected $casts = [
        'data' => 'array',
        'is_read' => 'boolean',
        'read_at' => 'datetime',
        'sent_at' => 'datetime',
        'created_at' => 'datetime',
    ];

    public const TYPE_AGGREGATED = 'aggregated';

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function alertRule(): BelongsTo
    {
        return $this->belongsTo(AlertRule::class);
    }

    public function scopeUnread($query)
    {
        return $query->where('is_read', false);
    }

    public function scopeForUser($query, int $userId)
    {
        return $query->where('user_id', $userId);
    }

    public function markAsRead(): void
    {
        $this->update([
            'is_read' => true,
            'read_at' => now(),
        ]);
    }
}
```

**Step 2: Create factory**

```php
<?php

namespace Database\Factories;

use App\Models\Notification;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class NotificationFactory extends Factory
{
    protected $model = Notification::class;

    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'alert_rule_id' => null,
            'type' => 'position_change',
            'title' => $this->faker->sentence(4),
            'body' => $this->faker->sentence(10),
            'data' => null,
            'is_read' => false,
            'read_at' => null,
            'sent_at' => now(),
            'created_at' => now(),
        ];
    }

    public function read(): self
    {
        return $this->state([
            'is_read' => true,
            'read_at' => now(),
        ]);
    }

    public function unsent(): self
    {
        return $this->state(['sent_at' => null]);
    }
}
```

**Step 3: Commit**

```bash
git add api/app/Models/Notification.php api/database/factories/NotificationFactory.php
git commit -m "feat(alerts): add Notification model and factory"
```

---

### Task 1.6: Update User model with alert relationships

**Files:**
- Modify: `api/app/Models/User.php`

**Step 1: Add fillable fields and relationships**

Add to `$fillable` array:
```php
'timezone',
'fcm_token',
'quiet_hours_start',
'quiet_hours_end',
```

Add casts:
```php
'quiet_hours_start' => 'datetime:H:i:s',
'quiet_hours_end' => 'datetime:H:i:s',
```

Add relationships:
```php
public function alertRules(): HasMany
{
    return $this->hasMany(AlertRule::class);
}

public function notifications(): HasMany
{
    return $this->hasMany(Notification::class);
}

public function unreadNotificationsCount(): int
{
    return $this->notifications()->unread()->count();
}
```

**Step 2: Commit**

```bash
git add api/app/Models/User.php
git commit -m "feat(alerts): add alert relationships to User model"
```

---

## Phase 2: Core Services

### Task 2.1: Create NotificationService

**Files:**
- Create: `api/app/Services/NotificationService.php`
- Create: `api/tests/Feature/NotificationServiceTest.php`

**Step 1: Write failing tests**

```php
<?php

namespace Tests\Feature;

use App\Models\Notification;
use App\Models\User;
use App\Services\NotificationService;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class NotificationServiceTest extends TestCase
{
    use RefreshDatabase;

    private NotificationService $service;

    protected function setUp(): void
    {
        parent::setUp();
        $this->service = new NotificationService();
    }

    public function test_creates_notification_for_user(): void
    {
        $user = User::factory()->create();

        $notification = $this->service->create($user, [
            'type' => 'position_change',
            'title' => 'Position dropped',
            'body' => 'Your app dropped 5 positions',
            'data' => ['app_id' => 1],
        ]);

        $this->assertInstanceOf(Notification::class, $notification);
        $this->assertEquals($user->id, $notification->user_id);
        $this->assertEquals('Position dropped', $notification->title);
    }

    public function test_is_quiet_hours_returns_true_during_quiet_period(): void
    {
        $user = User::factory()->create([
            'timezone' => 'Europe/Paris',
            'quiet_hours_start' => '22:00:00',
            'quiet_hours_end' => '08:00:00',
        ]);

        // Test at 23:00 Paris time (should be quiet)
        Carbon::setTestNow(Carbon::parse('2026-01-10 23:00:00', 'Europe/Paris'));
        $this->assertTrue($this->service->isQuietHours($user));

        // Test at 03:00 Paris time (should be quiet)
        Carbon::setTestNow(Carbon::parse('2026-01-11 03:00:00', 'Europe/Paris'));
        $this->assertTrue($this->service->isQuietHours($user));

        Carbon::setTestNow(); // Reset
    }

    public function test_is_quiet_hours_returns_false_outside_quiet_period(): void
    {
        $user = User::factory()->create([
            'timezone' => 'Europe/Paris',
            'quiet_hours_start' => '22:00:00',
            'quiet_hours_end' => '08:00:00',
        ]);

        // Test at 12:00 Paris time (should not be quiet)
        Carbon::setTestNow(Carbon::parse('2026-01-10 12:00:00', 'Europe/Paris'));
        $this->assertFalse($this->service->isQuietHours($user));

        Carbon::setTestNow(); // Reset
    }

    public function test_aggregates_multiple_notifications_of_same_type(): void
    {
        $user = User::factory()->create();

        $alerts = collect([
            ['type' => 'position_change', 'title' => 'App 1 dropped', 'body' => 'Details 1', 'data' => ['app_id' => 1]],
            ['type' => 'position_change', 'title' => 'App 2 dropped', 'body' => 'Details 2', 'data' => ['app_id' => 2]],
            ['type' => 'position_change', 'title' => 'App 3 dropped', 'body' => 'Details 3', 'data' => ['app_id' => 3]],
        ]);

        $aggregated = $this->service->aggregate($alerts);

        $this->assertCount(1, $aggregated);
        $this->assertEquals('aggregated', $aggregated->first()['type']);
        $this->assertStringContains('3', $aggregated->first()['title']);
    }

    public function test_does_not_aggregate_single_notification(): void
    {
        $alerts = collect([
            ['type' => 'position_change', 'title' => 'App dropped', 'body' => 'Details', 'data' => ['app_id' => 1]],
        ]);

        $aggregated = $this->service->aggregate($alerts);

        $this->assertCount(1, $aggregated);
        $this->assertEquals('position_change', $aggregated->first()['type']);
    }
}
```

**Step 2: Run tests to verify they fail**

Run: `cd api && php artisan test --filter=NotificationServiceTest`
Expected: FAIL - NotificationService class not found

**Step 3: Implement NotificationService**

```php
<?php

namespace App\Services;

use App\Models\Notification;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Support\Collection;

class NotificationService
{
    public function create(User $user, array $data): Notification
    {
        return Notification::create([
            'user_id' => $user->id,
            'alert_rule_id' => $data['alert_rule_id'] ?? null,
            'type' => $data['type'],
            'title' => $data['title'],
            'body' => $data['body'],
            'data' => $data['data'] ?? null,
            'is_read' => false,
            'sent_at' => now(),
            'created_at' => now(),
        ]);
    }

    public function isQuietHours(User $user): bool
    {
        $now = Carbon::now($user->timezone);
        $start = Carbon::parse($user->quiet_hours_start, $user->timezone);
        $end = Carbon::parse($user->quiet_hours_end, $user->timezone);

        // Handle overnight quiet hours (e.g., 22:00 - 08:00)
        if ($start > $end) {
            return $now >= $start || $now < $end;
        }

        return $now >= $start && $now < $end;
    }

    public function aggregate(Collection $alerts): Collection
    {
        if ($alerts->count() <= 2) {
            return $alerts;
        }

        $grouped = $alerts->groupBy('type');
        $result = collect();

        foreach ($grouped as $type => $typeAlerts) {
            if ($typeAlerts->count() > 2) {
                $result->push([
                    'type' => 'aggregated',
                    'original_type' => $type,
                    'title' => $this->getAggregatedTitle($type, $typeAlerts->count()),
                    'body' => $this->getAggregatedBody($type, $typeAlerts),
                    'data' => [
                        'count' => $typeAlerts->count(),
                        'items' => $typeAlerts->pluck('data')->toArray(),
                    ],
                ]);
            } else {
                $result = $result->merge($typeAlerts);
            }
        }

        return $result;
    }

    public function send(User $user, Collection $alerts): void
    {
        if ($alerts->isEmpty()) {
            return;
        }

        $aggregated = $this->aggregate($alerts);

        foreach ($aggregated as $alert) {
            $notification = $this->create($user, $alert);

            if (!$this->isQuietHours($user) && $user->fcm_token) {
                $this->sendFcm($user, $notification);
            }
        }
    }

    public function sendFcm(User $user, Notification $notification): void
    {
        // FCM implementation will be added in Phase 4
        // For now, just mark as sent
        $notification->update(['sent_at' => now()]);
    }

    private function getAggregatedTitle(string $type, int $count): string
    {
        return match ($type) {
            'position_change' => "{$count} position changes detected",
            'rating_change' => "{$count} rating changes",
            'review_spike' => "{$count} review alerts",
            'new_competitor' => "{$count} new competitors",
            'competitor_passed' => "{$count} competitors passed you",
            'mass_movement' => "{$count} mass movements",
            'keyword_popularity' => "{$count} keyword changes",
            'opportunity' => "{$count} opportunities detected",
            default => "{$count} alerts",
        };
    }

    private function getAggregatedBody(string $type, Collection $alerts): string
    {
        $items = $alerts->take(3)->pluck('title')->join(', ');
        $remaining = $alerts->count() - 3;

        if ($remaining > 0) {
            return "{$items} and {$remaining} more";
        }

        return $items;
    }
}
```

**Step 4: Run tests to verify they pass**

Run: `cd api && php artisan test --filter=NotificationServiceTest`
Expected: All tests PASS

**Step 5: Commit**

```bash
git add api/app/Services/NotificationService.php api/tests/Feature/NotificationServiceTest.php
git commit -m "feat(alerts): add NotificationService with quiet hours and aggregation"
```

---

### Task 2.2: Create AlertEvaluatorService - Base structure

**Files:**
- Create: `api/app/Services/AlertEvaluatorService.php`
- Create: `api/tests/Feature/AlertEvaluatorServiceTest.php`

**Step 1: Write failing tests**

```php
<?php

namespace Tests\Feature;

use App\Models\AlertRule;
use App\Models\App;
use App\Models\AppRanking;
use App\Models\Keyword;
use App\Models\TrackedKeyword;
use App\Models\User;
use App\Services\AlertEvaluatorService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AlertEvaluatorServiceTest extends TestCase
{
    use RefreshDatabase;

    private AlertEvaluatorService $service;

    protected function setUp(): void
    {
        parent::setUp();
        $this->service = new AlertEvaluatorService();
    }

    public function test_detects_position_drop_exceeding_threshold(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();
        TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
        ]);

        // Create ranking history: was #10 yesterday, now #25 (dropped 15)
        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 10,
            'recorded_at' => now()->subDay(),
        ]);
        $currentRanking = AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 25,
            'recorded_at' => now(),
        ]);

        // Create rule: alert if drops >= 10 positions
        AlertRule::factory()->create([
            'user_id' => $user->id,
            'type' => AlertRule::TYPE_POSITION_CHANGE,
            'conditions' => ['direction' => 'down', 'threshold' => 10],
        ]);

        $alerts = $this->service->evaluatePositionChange($currentRanking);

        $this->assertCount(1, $alerts);
        $this->assertEquals('position_change', $alerts->first()['type']);
    }

    public function test_does_not_alert_when_below_threshold(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();
        TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
        ]);

        // Create ranking history: was #10 yesterday, now #15 (dropped 5)
        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 10,
            'recorded_at' => now()->subDay(),
        ]);
        $currentRanking = AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 15,
            'recorded_at' => now(),
        ]);

        // Create rule: alert if drops >= 10 positions
        AlertRule::factory()->create([
            'user_id' => $user->id,
            'type' => AlertRule::TYPE_POSITION_CHANGE,
            'conditions' => ['direction' => 'down', 'threshold' => 10],
        ]);

        $alerts = $this->service->evaluatePositionChange($currentRanking);

        $this->assertCount(0, $alerts);
    }

    public function test_respects_app_specific_rule_over_global(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();
        TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
        ]);

        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 10,
            'recorded_at' => now()->subDay(),
        ]);
        $currentRanking = AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 15,
            'recorded_at' => now(),
        ]);

        // Global rule: threshold 10 (would NOT alert)
        AlertRule::factory()->create([
            'user_id' => $user->id,
            'type' => AlertRule::TYPE_POSITION_CHANGE,
            'scope_type' => AlertRule::SCOPE_GLOBAL,
            'conditions' => ['direction' => 'down', 'threshold' => 10],
            'priority' => 0,
        ]);

        // App-specific rule: threshold 3 (WOULD alert)
        AlertRule::factory()->create([
            'user_id' => $user->id,
            'type' => AlertRule::TYPE_POSITION_CHANGE,
            'scope_type' => AlertRule::SCOPE_APP,
            'scope_id' => $app->id,
            'conditions' => ['direction' => 'down', 'threshold' => 3],
            'priority' => 10,
        ]);

        $alerts = $this->service->evaluatePositionChange($currentRanking);

        $this->assertCount(1, $alerts);
    }

    public function test_detects_entered_top_n(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);
        $keyword = Keyword::factory()->create();
        TrackedKeyword::create([
            'user_id' => $user->id,
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
        ]);

        // Was #15, now #8 (entered top 10)
        AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 15,
            'recorded_at' => now()->subDay(),
        ]);
        $currentRanking = AppRanking::create([
            'app_id' => $app->id,
            'keyword_id' => $keyword->id,
            'position' => 8,
            'recorded_at' => now(),
        ]);

        AlertRule::factory()->create([
            'user_id' => $user->id,
            'type' => AlertRule::TYPE_POSITION_CHANGE,
            'conditions' => ['entered_top' => 10],
        ]);

        $alerts = $this->service->evaluatePositionChange($currentRanking);

        $this->assertCount(1, $alerts);
    }
}
```

**Step 2: Run tests to verify they fail**

Run: `cd api && php artisan test --filter=AlertEvaluatorServiceTest`
Expected: FAIL - AlertEvaluatorService class not found

**Step 3: Implement AlertEvaluatorService**

```php
<?php

namespace App\Services;

use App\Models\AlertRule;
use App\Models\AppRanking;
use App\Models\TrackedKeyword;
use App\Models\User;
use Illuminate\Support\Collection;

class AlertEvaluatorService
{
    public function __construct(
        private ?NotificationService $notificationService = null
    ) {
        $this->notificationService = $notificationService ?? new NotificationService();
    }

    public function evaluatePositionChange(AppRanking $ranking): Collection
    {
        $alerts = collect();
        $change = $ranking->change;
        $previous = $ranking->getPreviousRanking();

        // Find users tracking this app+keyword
        $trackedKeywords = TrackedKeyword::where('app_id', $ranking->app_id)
            ->where('keyword_id', $ranking->keyword_id)
            ->get();

        foreach ($trackedKeywords as $tracked) {
            $rule = $this->getApplicableRule(
                $tracked->user_id,
                AlertRule::TYPE_POSITION_CHANGE,
                $ranking->app_id,
                $ranking->keyword_id
            );

            if (!$rule) {
                continue;
            }

            $conditions = $rule->conditions;
            $shouldAlert = false;
            $alertTitle = '';
            $alertBody = '';

            // Check threshold-based conditions
            if (isset($conditions['direction']) && isset($conditions['threshold'])) {
                $threshold = $conditions['threshold'];
                $direction = $conditions['direction'];

                if ($change !== null) {
                    if ($direction === 'down' && $change < 0 && abs($change) >= $threshold) {
                        $shouldAlert = true;
                        $alertTitle = "Position dropped by " . abs($change);
                        $alertBody = "{$ranking->app->name} dropped from #{$previous->position} to #{$ranking->position} on '{$ranking->keyword->keyword}'";
                    } elseif ($direction === 'up' && $change > 0 && $change >= $threshold) {
                        $shouldAlert = true;
                        $alertTitle = "Position improved by {$change}";
                        $alertBody = "{$ranking->app->name} rose from #{$previous->position} to #{$ranking->position} on '{$ranking->keyword->keyword}'";
                    } elseif ($direction === 'any' && abs($change) >= $threshold) {
                        $shouldAlert = true;
                        $word = $change > 0 ? 'improved' : 'dropped';
                        $alertTitle = "Position {$word} by " . abs($change);
                        $alertBody = "{$ranking->app->name} moved from #{$previous->position} to #{$ranking->position} on '{$ranking->keyword->keyword}'";
                    }
                }
            }

            // Check entered_top condition
            if (isset($conditions['entered_top']) && $previous && $ranking->position !== null) {
                $topN = $conditions['entered_top'];
                if ($previous->position > $topN && $ranking->position <= $topN) {
                    $shouldAlert = true;
                    $alertTitle = "Entered top {$topN}!";
                    $alertBody = "{$ranking->app->name} is now #{$ranking->position} on '{$ranking->keyword->keyword}'";
                }
            }

            // Check exited_top condition
            if (isset($conditions['exited_top']) && $previous && $ranking->position !== null) {
                $topN = $conditions['exited_top'];
                if ($previous->position <= $topN && $ranking->position > $topN) {
                    $shouldAlert = true;
                    $alertTitle = "Exited top {$topN}";
                    $alertBody = "{$ranking->app->name} dropped to #{$ranking->position} on '{$ranking->keyword->keyword}'";
                }
            }

            // Check best_ever condition
            if (isset($conditions['best_ever']) && $conditions['best_ever'] && $ranking->position !== null) {
                $bestEver = AppRanking::where('app_id', $ranking->app_id)
                    ->where('keyword_id', $ranking->keyword_id)
                    ->whereNotNull('position')
                    ->min('position');

                if ($ranking->position <= $bestEver) {
                    $shouldAlert = true;
                    $alertTitle = "Best position ever!";
                    $alertBody = "{$ranking->app->name} reached #{$ranking->position} on '{$ranking->keyword->keyword}'";
                }
            }

            if ($shouldAlert) {
                $alerts->push([
                    'user_id' => $tracked->user_id,
                    'alert_rule_id' => $rule->id,
                    'type' => AlertRule::TYPE_POSITION_CHANGE,
                    'title' => $alertTitle,
                    'body' => $alertBody,
                    'data' => [
                        'app_id' => $ranking->app_id,
                        'keyword_id' => $ranking->keyword_id,
                        'position' => $ranking->position,
                        'previous_position' => $previous?->position,
                        'change' => $change,
                    ],
                ]);
            }
        }

        return $alerts;
    }

    public function getApplicableRule(int $userId, string $type, ?int $appId = null, ?int $keywordId = null): ?AlertRule
    {
        // Get all active rules for this user and type, ordered by priority (highest first)
        $rules = AlertRule::forUser($userId)
            ->forType($type)
            ->active()
            ->orderByDesc('priority')
            ->get();

        if ($rules->isEmpty()) {
            return null;
        }

        // Find the most specific applicable rule
        foreach ($rules as $rule) {
            if ($rule->scope_type === AlertRule::SCOPE_KEYWORD && $rule->scope_id === $keywordId) {
                return $rule;
            }
        }

        foreach ($rules as $rule) {
            if ($rule->scope_type === AlertRule::SCOPE_APP && $rule->scope_id === $appId) {
                return $rule;
            }
        }

        // Return global rule if no specific match
        return $rules->firstWhere('scope_type', AlertRule::SCOPE_GLOBAL);
    }

    public function dispatchAlerts(Collection $alerts): void
    {
        $alertsByUser = $alerts->groupBy('user_id');

        foreach ($alertsByUser as $userId => $userAlerts) {
            $user = User::find($userId);
            if ($user) {
                $this->notificationService->send($user, $userAlerts);
            }
        }
    }
}
```

**Step 4: Run tests to verify they pass**

Run: `cd api && php artisan test --filter=AlertEvaluatorServiceTest`
Expected: All tests PASS

**Step 5: Commit**

```bash
git add api/app/Services/AlertEvaluatorService.php api/tests/Feature/AlertEvaluatorServiceTest.php
git commit -m "feat(alerts): add AlertEvaluatorService with position change evaluation"
```

---

## Phase 3: API Endpoints

### Task 3.1: Create AlertRulesController

**Files:**
- Create: `api/app/Http/Controllers/Api/AlertRulesController.php`
- Create: `api/tests/Feature/AlertRulesTest.php`

**Step 1: Write failing tests**

```php
<?php

namespace Tests\Feature;

use App\Models\AlertRule;
use App\Models\App;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AlertRulesTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_list_their_alert_rules(): void
    {
        $user = User::factory()->create();
        AlertRule::factory()->count(3)->create(['user_id' => $user->id]);
        AlertRule::factory()->create(); // Another user's rule

        $response = $this->actingAs($user)->getJson('/api/alerts/rules');

        $response->assertOk();
        $response->assertJsonCount(3, 'data');
    }

    public function test_user_can_create_alert_rule(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->postJson('/api/alerts/rules', [
            'name' => 'Position drop alert',
            'type' => 'position_change',
            'scope_type' => 'global',
            'conditions' => ['direction' => 'down', 'threshold' => 10],
        ]);

        $response->assertCreated();
        $response->assertJsonPath('data.name', 'Position drop alert');
        $this->assertDatabaseHas('alert_rules', [
            'user_id' => $user->id,
            'name' => 'Position drop alert',
        ]);
    }

    public function test_user_can_create_app_scoped_rule(): void
    {
        $user = User::factory()->create();
        $app = App::factory()->create();
        $app->users()->attach($user->id);

        $response = $this->actingAs($user)->postJson('/api/alerts/rules', [
            'name' => 'My app alert',
            'type' => 'position_change',
            'scope_type' => 'app',
            'scope_id' => $app->id,
            'conditions' => ['direction' => 'any', 'threshold' => 1],
        ]);

        $response->assertCreated();
        $response->assertJsonPath('data.scope_type', 'app');
        $response->assertJsonPath('data.scope_id', $app->id);
    }

    public function test_user_can_update_their_rule(): void
    {
        $user = User::factory()->create();
        $rule = AlertRule::factory()->create(['user_id' => $user->id, 'name' => 'Old name']);

        $response = $this->actingAs($user)->putJson("/api/alerts/rules/{$rule->id}", [
            'name' => 'New name',
            'conditions' => ['direction' => 'up', 'threshold' => 5],
        ]);

        $response->assertOk();
        $response->assertJsonPath('data.name', 'New name');
    }

    public function test_user_cannot_update_another_users_rule(): void
    {
        $user = User::factory()->create();
        $otherUser = User::factory()->create();
        $rule = AlertRule::factory()->create(['user_id' => $otherUser->id]);

        $response = $this->actingAs($user)->putJson("/api/alerts/rules/{$rule->id}", [
            'name' => 'Hacked',
        ]);

        $response->assertForbidden();
    }

    public function test_user_can_delete_their_rule(): void
    {
        $user = User::factory()->create();
        $rule = AlertRule::factory()->create(['user_id' => $user->id]);

        $response = $this->actingAs($user)->deleteJson("/api/alerts/rules/{$rule->id}");

        $response->assertNoContent();
        $this->assertDatabaseMissing('alert_rules', ['id' => $rule->id]);
    }

    public function test_user_can_toggle_rule_active_status(): void
    {
        $user = User::factory()->create();
        $rule = AlertRule::factory()->create(['user_id' => $user->id, 'is_active' => true]);

        $response = $this->actingAs($user)->patchJson("/api/alerts/rules/{$rule->id}/toggle");

        $response->assertOk();
        $response->assertJsonPath('data.is_active', false);
    }

    public function test_list_templates_returns_preset_rules(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->getJson('/api/alerts/templates');

        $response->assertOk();
        $response->assertJsonStructure(['data' => [['name', 'type', 'conditions']]]);
    }
}
```

**Step 2: Run tests to verify they fail**

Run: `cd api && php artisan test --filter=AlertRulesTest`
Expected: FAIL - Route not defined

**Step 3: Implement controller**

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AlertRule;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class AlertRulesController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $rules = AlertRule::forUser($request->user()->id)
            ->orderByDesc('priority')
            ->get();

        return response()->json(['data' => $rules]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'type' => 'required|string|in:position_change,rating_change,review_spike,review_keyword,new_competitor,competitor_passed,mass_movement,keyword_popularity,opportunity',
            'scope_type' => 'required|string|in:global,app,category,keyword',
            'scope_id' => 'nullable|integer',
            'conditions' => 'required|array',
            'priority' => 'nullable|integer',
        ]);

        $rule = AlertRule::create([
            'user_id' => $request->user()->id,
            'name' => $validated['name'],
            'type' => $validated['type'],
            'scope_type' => $validated['scope_type'],
            'scope_id' => $validated['scope_id'] ?? null,
            'conditions' => $validated['conditions'],
            'priority' => $validated['priority'] ?? 0,
            'is_active' => true,
        ]);

        return response()->json(['data' => $rule], 201);
    }

    public function update(Request $request, AlertRule $rule): JsonResponse
    {
        if ($rule->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'conditions' => 'sometimes|array',
            'scope_type' => 'sometimes|string|in:global,app,category,keyword',
            'scope_id' => 'nullable|integer',
            'priority' => 'sometimes|integer',
            'is_active' => 'sometimes|boolean',
        ]);

        $rule->update($validated);

        return response()->json(['data' => $rule->fresh()]);
    }

    public function destroy(Request $request, AlertRule $rule): Response
    {
        if ($rule->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $rule->delete();

        return response()->noContent();
    }

    public function toggle(Request $request, AlertRule $rule): JsonResponse
    {
        if ($rule->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $rule->update(['is_active' => !$rule->is_active]);

        return response()->json(['data' => $rule->fresh()]);
    }

    public function templates(): JsonResponse
    {
        $templates = [
            [
                'name' => 'Chute brutale',
                'type' => 'position_change',
                'conditions' => ['direction' => 'down', 'threshold' => 10],
            ],
            [
                'name' => 'Progression',
                'type' => 'position_change',
                'conditions' => ['direction' => 'up', 'threshold' => 10],
            ],
            [
                'name' => 'Entrée top 10',
                'type' => 'position_change',
                'conditions' => ['entered_top' => 10],
            ],
            [
                'name' => 'Note en baisse',
                'type' => 'rating_change',
                'conditions' => ['direction' => 'down', 'threshold' => 0.2],
            ],
            [
                'name' => 'Pic d\'avis négatifs',
                'type' => 'review_spike',
                'conditions' => ['max_rating' => 2, 'count' => 5, 'period_hours' => 24],
            ],
            [
                'name' => 'Mot-clé dans avis',
                'type' => 'review_keyword',
                'conditions' => ['keywords' => ['bug', 'crash', 'lent']],
            ],
            [
                'name' => 'Nouveau concurrent',
                'type' => 'new_competitor',
                'conditions' => ['top' => 100],
            ],
            [
                'name' => 'Concurrent vous dépasse',
                'type' => 'competitor_passed',
                'conditions' => [],
            ],
            [
                'name' => 'Mouvement de masse',
                'type' => 'mass_movement',
                'conditions' => ['changes' => 10, 'top' => 20],
            ],
            [
                'name' => 'Popularité mot-clé',
                'type' => 'keyword_popularity',
                'conditions' => ['change' => 15],
            ],
            [
                'name' => 'Opportunité',
                'type' => 'opportunity',
                'conditions' => ['max_position' => 3, 'min_popularity' => 50],
            ],
        ];

        return response()->json(['data' => $templates]);
    }
}
```

**Step 4: Add routes**

Add to `api/routes/api.php` inside the `auth:sanctum` middleware group:

```php
// Alert Rules
Route::prefix('alerts')->group(function () {
    Route::get('templates', [AlertRulesController::class, 'templates']);
    Route::get('rules', [AlertRulesController::class, 'index']);
    Route::post('rules', [AlertRulesController::class, 'store']);
    Route::put('rules/{rule}', [AlertRulesController::class, 'update']);
    Route::delete('rules/{rule}', [AlertRulesController::class, 'destroy']);
    Route::patch('rules/{rule}/toggle', [AlertRulesController::class, 'toggle']);
});
```

**Step 5: Run tests to verify they pass**

Run: `cd api && php artisan test --filter=AlertRulesTest`
Expected: All tests PASS

**Step 6: Commit**

```bash
git add api/app/Http/Controllers/Api/AlertRulesController.php api/tests/Feature/AlertRulesTest.php api/routes/api.php
git commit -m "feat(alerts): add AlertRulesController with CRUD endpoints"
```

---

### Task 3.2: Create NotificationsController

**Files:**
- Create: `api/app/Http/Controllers/Api/NotificationsController.php`
- Create: `api/tests/Feature/NotificationsTest.php`

**Step 1: Write failing tests**

```php
<?php

namespace Tests\Feature;

use App\Models\Notification;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class NotificationsTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_list_their_notifications(): void
    {
        $user = User::factory()->create();
        Notification::factory()->count(5)->create(['user_id' => $user->id]);
        Notification::factory()->create(); // Another user's notification

        $response = $this->actingAs($user)->getJson('/api/notifications');

        $response->assertOk();
        $response->assertJsonCount(5, 'data');
    }

    public function test_notifications_are_ordered_by_newest_first(): void
    {
        $user = User::factory()->create();
        $old = Notification::factory()->create([
            'user_id' => $user->id,
            'created_at' => now()->subDay(),
        ]);
        $new = Notification::factory()->create([
            'user_id' => $user->id,
            'created_at' => now(),
        ]);

        $response = $this->actingAs($user)->getJson('/api/notifications');

        $response->assertOk();
        $this->assertEquals($new->id, $response->json('data.0.id'));
    }

    public function test_user_can_get_unread_count(): void
    {
        $user = User::factory()->create();
        Notification::factory()->count(3)->create(['user_id' => $user->id, 'is_read' => false]);
        Notification::factory()->count(2)->create(['user_id' => $user->id, 'is_read' => true]);

        $response = $this->actingAs($user)->getJson('/api/notifications/unread-count');

        $response->assertOk();
        $response->assertJsonPath('count', 3);
    }

    public function test_user_can_mark_notification_as_read(): void
    {
        $user = User::factory()->create();
        $notification = Notification::factory()->create([
            'user_id' => $user->id,
            'is_read' => false,
        ]);

        $response = $this->actingAs($user)->patchJson("/api/notifications/{$notification->id}/read");

        $response->assertOk();
        $response->assertJsonPath('data.is_read', true);
        $this->assertNotNull($notification->fresh()->read_at);
    }

    public function test_user_can_mark_all_notifications_as_read(): void
    {
        $user = User::factory()->create();
        Notification::factory()->count(5)->create(['user_id' => $user->id, 'is_read' => false]);

        $response = $this->actingAs($user)->postJson('/api/notifications/mark-all-read');

        $response->assertOk();
        $this->assertEquals(0, $user->notifications()->unread()->count());
    }

    public function test_user_can_delete_notification(): void
    {
        $user = User::factory()->create();
        $notification = Notification::factory()->create(['user_id' => $user->id]);

        $response = $this->actingAs($user)->deleteJson("/api/notifications/{$notification->id}");

        $response->assertNoContent();
        $this->assertDatabaseMissing('notifications', ['id' => $notification->id]);
    }

    public function test_user_cannot_access_another_users_notification(): void
    {
        $user = User::factory()->create();
        $otherUser = User::factory()->create();
        $notification = Notification::factory()->create(['user_id' => $otherUser->id]);

        $response = $this->actingAs($user)->patchJson("/api/notifications/{$notification->id}/read");

        $response->assertForbidden();
    }
}
```

**Step 2: Run tests to verify they fail**

Run: `cd api && php artisan test --filter=NotificationsTest`
Expected: FAIL - Route not defined

**Step 3: Implement controller**

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class NotificationsController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $notifications = Notification::forUser($request->user()->id)
            ->orderByDesc('created_at')
            ->paginate(20);

        return response()->json($notifications);
    }

    public function unreadCount(Request $request): JsonResponse
    {
        $count = Notification::forUser($request->user()->id)
            ->unread()
            ->count();

        return response()->json(['count' => $count]);
    }

    public function markAsRead(Request $request, Notification $notification): JsonResponse
    {
        if ($notification->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $notification->markAsRead();

        return response()->json(['data' => $notification->fresh()]);
    }

    public function markAllAsRead(Request $request): JsonResponse
    {
        Notification::forUser($request->user()->id)
            ->unread()
            ->update([
                'is_read' => true,
                'read_at' => now(),
            ]);

        return response()->json(['success' => true]);
    }

    public function destroy(Request $request, Notification $notification): Response
    {
        if ($notification->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $notification->delete();

        return response()->noContent();
    }
}
```

**Step 4: Add routes**

Add to `api/routes/api.php` inside the `auth:sanctum` middleware group:

```php
// Notifications
Route::prefix('notifications')->group(function () {
    Route::get('/', [NotificationsController::class, 'index']);
    Route::get('unread-count', [NotificationsController::class, 'unreadCount']);
    Route::post('mark-all-read', [NotificationsController::class, 'markAllAsRead']);
    Route::patch('{notification}/read', [NotificationsController::class, 'markAsRead']);
    Route::delete('{notification}', [NotificationsController::class, 'destroy']);
});
```

**Step 5: Run tests to verify they pass**

Run: `cd api && php artisan test --filter=NotificationsTest`
Expected: All tests PASS

**Step 6: Commit**

```bash
git add api/app/Http/Controllers/Api/NotificationsController.php api/tests/Feature/NotificationsTest.php api/routes/api.php
git commit -m "feat(alerts): add NotificationsController with inbox endpoints"
```

---

### Task 3.3: Add FCM token endpoint to UserPreferencesController

**Files:**
- Modify: `api/app/Http/Controllers/Api/UserPreferencesController.php`
- Add tests to existing test file or create new

**Step 1: Add test for FCM token update**

```php
public function test_user_can_update_fcm_token(): void
{
    $user = User::factory()->create();

    $response = $this->actingAs($user)->putJson('/api/user/fcm-token', [
        'fcm_token' => 'test-fcm-token-123',
    ]);

    $response->assertOk();
    $this->assertEquals('test-fcm-token-123', $user->fresh()->fcm_token);
}

public function test_user_can_update_alert_settings(): void
{
    $user = User::factory()->create();

    $response = $this->actingAs($user)->putJson('/api/user/preferences', [
        'timezone' => 'Europe/Paris',
        'quiet_hours_start' => '23:00:00',
        'quiet_hours_end' => '07:00:00',
    ]);

    $response->assertOk();
    $this->assertEquals('Europe/Paris', $user->fresh()->timezone);
}
```

**Step 2: Add endpoint to controller**

```php
public function updateFcmToken(Request $request): JsonResponse
{
    $validated = $request->validate([
        'fcm_token' => 'required|string|max:255',
    ]);

    $request->user()->update(['fcm_token' => $validated['fcm_token']]);

    return response()->json(['success' => true]);
}
```

**Step 3: Add route**

```php
Route::put('user/fcm-token', [UserPreferencesController::class, 'updateFcmToken']);
```

**Step 4: Run tests**

Run: `cd api && php artisan test --filter=UserPreferencesTest`
Expected: All tests PASS

**Step 5: Commit**

```bash
git add api/app/Http/Controllers/Api/UserPreferencesController.php api/routes/api.php
git commit -m "feat(alerts): add FCM token update endpoint"
```

---

## Phase 4: Job Integration

### Task 4.1: Integrate AlertEvaluatorService with SyncRankingsJob

**Files:**
- Modify: `api/app/Console/Commands/SyncRankings.php`
- Create: `api/app/Events/RankingsSynced.php`
- Create: `api/app/Listeners/EvaluateRankingAlerts.php`

**Step 1: Create event**

```php
<?php

namespace App\Events;

use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Support\Collection;

class RankingsSynced
{
    use Dispatchable;

    public function __construct(
        public Collection $rankings
    ) {}
}
```

**Step 2: Create listener**

```php
<?php

namespace App\Listeners;

use App\Events\RankingsSynced;
use App\Services\AlertEvaluatorService;

class EvaluateRankingAlerts
{
    public function __construct(
        private AlertEvaluatorService $evaluator
    ) {}

    public function handle(RankingsSynced $event): void
    {
        $allAlerts = collect();

        foreach ($event->rankings as $ranking) {
            $alerts = $this->evaluator->evaluatePositionChange($ranking);
            $allAlerts = $allAlerts->merge($alerts);
        }

        if ($allAlerts->isNotEmpty()) {
            $this->evaluator->dispatchAlerts($allAlerts);
        }
    }
}
```

**Step 3: Register in EventServiceProvider**

```php
protected $listen = [
    RankingsSynced::class => [
        EvaluateRankingAlerts::class,
    ],
];
```

**Step 4: Dispatch event in SyncRankings command after saving rankings**

Add after rankings are saved:
```php
use App\Events\RankingsSynced;

// After saving new rankings
RankingsSynced::dispatch($newRankings);
```

**Step 5: Commit**

```bash
git add api/app/Events/RankingsSynced.php api/app/Listeners/EvaluateRankingAlerts.php api/app/Providers/EventServiceProvider.php api/app/Console/Commands/SyncRankings.php
git commit -m "feat(alerts): integrate alert evaluation with ranking sync"
```

---

## Phase 5: FCM Integration

### Task 5.1: Install and configure FCM package

**Step 1: Install package**

Run: `cd api && composer require laravel-notification-channels/fcm`

**Step 2: Add config**

Create `api/config/fcm.php`:
```php
<?php

return [
    'driver' => env('FCM_DRIVER', 'http'),
    'project_id' => env('FCM_PROJECT_ID'),
    'credentials' => env('FCM_CREDENTIALS', storage_path('app/firebase-credentials.json')),
];
```

**Step 3: Update .env.example**

```
FCM_PROJECT_ID=your-project-id
FCM_CREDENTIALS=/path/to/firebase-credentials.json
```

**Step 4: Commit**

```bash
git add api/config/fcm.php api/.env.example composer.json composer.lock
git commit -m "feat(alerts): add FCM configuration"
```

---

### Task 5.2: Implement FCM sending in NotificationService

**Files:**
- Modify: `api/app/Services/NotificationService.php`

**Step 1: Update sendFcm method**

```php
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;

public function sendFcm(User $user, Notification $notification): void
{
    if (!$user->fcm_token) {
        return;
    }

    try {
        $factory = (new Factory)->withServiceAccount(config('fcm.credentials'));
        $messaging = $factory->createMessaging();

        $message = CloudMessage::withTarget('token', $user->fcm_token)
            ->withNotification([
                'title' => $notification->title,
                'body' => $notification->body,
            ])
            ->withData([
                'notification_id' => (string) $notification->id,
                'type' => $notification->type,
                'data' => json_encode($notification->data),
            ]);

        $messaging->send($message);

        $notification->update(['sent_at' => now()]);
    } catch (\Exception $e) {
        \Log::error('FCM send failed', [
            'user_id' => $user->id,
            'error' => $e->getMessage(),
        ]);
    }
}
```

**Step 2: Commit**

```bash
git add api/app/Services/NotificationService.php
git commit -m "feat(alerts): implement FCM push notification sending"
```

---

## Summary

### Files Created
- `api/database/migrations/2026_01_11_000001_create_alert_rules_table.php`
- `api/database/migrations/2026_01_11_000002_create_notifications_table.php`
- `api/database/migrations/2026_01_11_000003_add_alert_settings_to_users_table.php`
- `api/app/Models/AlertRule.php`
- `api/app/Models/Notification.php`
- `api/database/factories/AlertRuleFactory.php`
- `api/database/factories/NotificationFactory.php`
- `api/app/Services/NotificationService.php`
- `api/app/Services/AlertEvaluatorService.php`
- `api/app/Http/Controllers/Api/AlertRulesController.php`
- `api/app/Http/Controllers/Api/NotificationsController.php`
- `api/app/Events/RankingsSynced.php`
- `api/app/Listeners/EvaluateRankingAlerts.php`
- `api/config/fcm.php`
- `api/tests/Feature/NotificationServiceTest.php`
- `api/tests/Feature/AlertEvaluatorServiceTest.php`
- `api/tests/Feature/AlertRulesTest.php`
- `api/tests/Feature/NotificationsTest.php`

### Files Modified
- `api/app/Models/User.php`
- `api/routes/api.php`
- `api/app/Http/Controllers/Api/UserPreferencesController.php`
- `api/app/Console/Commands/SyncRankings.php`
- `api/app/Providers/EventServiceProvider.php`

### API Endpoints Added
- `GET /api/alerts/templates` - List preset alert templates
- `GET /api/alerts/rules` - List user's alert rules
- `POST /api/alerts/rules` - Create alert rule
- `PUT /api/alerts/rules/{id}` - Update alert rule
- `DELETE /api/alerts/rules/{id}` - Delete alert rule
- `PATCH /api/alerts/rules/{id}/toggle` - Toggle rule active status
- `GET /api/notifications` - List user's notifications
- `GET /api/notifications/unread-count` - Get unread count
- `PATCH /api/notifications/{id}/read` - Mark as read
- `POST /api/notifications/mark-all-read` - Mark all as read
- `DELETE /api/notifications/{id}` - Delete notification
- `PUT /api/user/fcm-token` - Update FCM token

### Next Steps (Future Tasks)
1. Implement remaining alert evaluators (rating_change, review_spike, etc.)
2. Add trend-based conditions (X days tracking)
3. Flutter UI implementation (Inbox screen, Rules screen, Builder)
4. Add scheduled job for deferred notifications (quiet hours)
5. Add webhook/Slack integration options
