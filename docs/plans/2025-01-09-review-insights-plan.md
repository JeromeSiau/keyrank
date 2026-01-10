# Review Insights - Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add AI-powered review analysis to identify app strengths and weaknesses, with competitive comparison.

**Architecture:** Laravel backend calls OpenRouter API to analyze aggregated reviews, stores results in DB. Flutter frontend displays insights per app and provides a comparison view.

**Tech Stack:** Laravel 11, OpenRouter API (GPT-5 nano), Flutter/Riverpod, GoRouter

---

## Task 1: Create Migration and Model (Backend)

**Files:**
- Create: `api/database/migrations/2026_01_09_000001_create_app_insights_table.php`
- Create: `api/app/Models/AppInsight.php`

**Step 1: Create the migration file**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/api && php artisan make:migration create_app_insights_table
```

**Step 2: Write the migration schema**

Edit the created migration file:

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('app_insights', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->onDelete('cascade');
            $table->enum('analysis_type', ['full', 'refresh'])->default('full');
            $table->integer('reviews_count');
            $table->json('countries');
            $table->date('period_start');
            $table->date('period_end');
            $table->json('category_scores');
            $table->json('category_summaries');
            $table->json('emergent_themes');
            $table->json('overall_strengths');
            $table->json('overall_weaknesses');
            $table->json('opportunities')->nullable();
            $table->text('raw_llm_response')->nullable();
            $table->timestamps();

            $table->index(['app_id', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('app_insights');
    }
};
```

**Step 3: Create the model**

Create `api/app/Models/AppInsight.php`:

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AppInsight extends Model
{
    protected $fillable = [
        'app_id',
        'analysis_type',
        'reviews_count',
        'countries',
        'period_start',
        'period_end',
        'category_scores',
        'category_summaries',
        'emergent_themes',
        'overall_strengths',
        'overall_weaknesses',
        'opportunities',
        'raw_llm_response',
    ];

    protected $casts = [
        'countries' => 'array',
        'category_scores' => 'array',
        'category_summaries' => 'array',
        'emergent_themes' => 'array',
        'overall_strengths' => 'array',
        'overall_weaknesses' => 'array',
        'opportunities' => 'array',
        'period_start' => 'date',
        'period_end' => 'date',
    ];

    public function app(): BelongsTo
    {
        return $this->belongsTo(App::class);
    }
}
```

**Step 4: Add relationship to App model**

Edit `api/app/Models/App.php`, add method:

```php
public function insights(): HasMany
{
    return $this->hasMany(AppInsight::class);
}

public function latestInsight(): HasOne
{
    return $this->hasOne(AppInsight::class)->latestOfMany();
}
```

**Step 5: Run migration**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/api && php artisan migrate
```

**Step 6: Commit**

```bash
git add -A && git commit -m "feat(backend): add app_insights table and model"
```

---

## Task 2: Create OpenRouter Service (Backend)

**Files:**
- Create: `api/app/Services/OpenRouterService.php`
- Modify: `api/config/services.php`

**Step 1: Add config**

Edit `api/config/services.php`, add at the end of the array:

```php
'openrouter' => [
    'api_key' => env('OPENROUTER_API_KEY'),
    'base_url' => env('OPENROUTER_BASE_URL', 'https://openrouter.ai/api/v1'),
    'model' => env('OPENROUTER_MODEL', 'openai/gpt-5-nano'),
],
```

**Step 2: Create service**

Create `api/app/Services/OpenRouterService.php`:

```php
<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class OpenRouterService
{
    private string $apiKey;
    private string $baseUrl;
    private string $model;

    public function __construct()
    {
        $this->apiKey = config('services.openrouter.api_key');
        $this->baseUrl = config('services.openrouter.base_url');
        $this->model = config('services.openrouter.model');
    }

    /**
     * Send a chat completion request to OpenRouter
     *
     * @param string $systemPrompt
     * @param string $userPrompt
     * @param bool $jsonMode
     * @return array|null
     */
    public function chat(string $systemPrompt, string $userPrompt, bool $jsonMode = true): ?array
    {
        if (!$this->apiKey) {
            Log::error('OpenRouter API key not configured');
            return null;
        }

        try {
            $payload = [
                'model' => $this->model,
                'messages' => [
                    ['role' => 'system', 'content' => $systemPrompt],
                    ['role' => 'user', 'content' => $userPrompt],
                ],
            ];

            if ($jsonMode) {
                $payload['response_format'] = ['type' => 'json_object'];
            }

            $response = Http::timeout(120)
                ->withHeaders([
                    'Authorization' => "Bearer {$this->apiKey}",
                    'Content-Type' => 'application/json',
                    'HTTP-Referer' => config('app.url'),
                    'X-Title' => 'Keyrank ASO',
                ])
                ->post("{$this->baseUrl}/chat/completions", $payload);

            if ($response->successful()) {
                $content = $response->json('choices.0.message.content');
                return $jsonMode ? json_decode($content, true) : ['content' => $content];
            }

            Log::error('OpenRouter API error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('OpenRouter API exception', ['error' => $e->getMessage()]);
            return null;
        }
    }
}
```

**Step 3: Commit**

```bash
git add -A && git commit -m "feat(backend): add OpenRouter service for LLM calls"
```

---

## Task 3: Create Insights Service (Backend)

**Files:**
- Create: `api/app/Services/InsightsService.php`

**Step 1: Create the insights service**

Create `api/app/Services/InsightsService.php`:

```php
<?php

namespace App\Services;

use App\Models\App;
use App\Models\AppInsight;
use App\Models\AppReview;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;

class InsightsService
{
    private const CHUNK_SIZE = 100;
    private const CATEGORIES = ['ux', 'performance', 'features', 'pricing', 'support', 'onboarding'];

    public function __construct(
        private OpenRouterService $openRouter
    ) {}

    /**
     * Generate insights for an app
     *
     * @param App $app
     * @param array $countries
     * @param int $periodMonths
     * @return AppInsight|null
     */
    public function generateInsights(App $app, array $countries, int $periodMonths = 6): ?AppInsight
    {
        $periodStart = Carbon::now()->subMonths($periodMonths)->startOfDay();
        $periodEnd = Carbon::now()->endOfDay();

        // Fetch reviews
        $reviews = $this->fetchReviews($app, $countries, $periodStart, $periodEnd);

        if ($reviews->isEmpty()) {
            return null;
        }

        // Chunk and analyze
        $chunks = $reviews->chunk(self::CHUNK_SIZE);
        $chunkAnalyses = [];

        foreach ($chunks as $chunk) {
            $analysis = $this->analyzeChunk($app, $chunk->toArray());
            if ($analysis) {
                $chunkAnalyses[] = $analysis;
            }
        }

        if (empty($chunkAnalyses)) {
            return null;
        }

        // Synthesize if multiple chunks
        $finalAnalysis = count($chunkAnalyses) === 1
            ? $chunkAnalyses[0]
            : $this->synthesizeChunks($app, $chunkAnalyses, $reviews->count());

        if (!$finalAnalysis) {
            return null;
        }

        // Store and return
        return AppInsight::create([
            'app_id' => $app->id,
            'analysis_type' => 'full',
            'reviews_count' => $reviews->count(),
            'countries' => $countries,
            'period_start' => $periodStart,
            'period_end' => $periodEnd,
            'category_scores' => $finalAnalysis['categories'] ?? [],
            'category_summaries' => $this->extractSummaries($finalAnalysis['categories'] ?? []),
            'emergent_themes' => $finalAnalysis['emergent_themes'] ?? [],
            'overall_strengths' => $finalAnalysis['overall_strengths'] ?? [],
            'overall_weaknesses' => $finalAnalysis['overall_weaknesses'] ?? [],
            'opportunities' => $finalAnalysis['opportunities'] ?? [],
            'raw_llm_response' => json_encode($finalAnalysis),
        ]);
    }

    private function fetchReviews(App $app, array $countries, Carbon $start, Carbon $end)
    {
        return AppReview::where('app_id', $app->id)
            ->whereIn('country', array_map('strtoupper', $countries))
            ->whereBetween('reviewed_at', [$start, $end])
            ->orderByDesc('reviewed_at')
            ->get(['rating', 'title', 'content', 'reviewed_at', 'country']);
    }

    private function analyzeChunk(App $app, array $reviews): ?array
    {
        $systemPrompt = $this->buildSystemPrompt();
        $userPrompt = $this->buildUserPrompt($app, $reviews);

        return $this->openRouter->chat($systemPrompt, $userPrompt);
    }

    private function synthesizeChunks(App $app, array $analyses, int $totalReviews): ?array
    {
        $systemPrompt = <<<PROMPT
Tu es un analyste ASO expert. Tu reçois plusieurs analyses partielles de reviews d'une même app.
Synthétise-les en une analyse unique et cohérente.
Réponds en JSON avec la même structure que les analyses partielles.
PROMPT;

        $userPrompt = "APP: {$app->name}\n";
        $userPrompt .= "TOTAL REVIEWS: {$totalReviews}\n\n";
        $userPrompt .= "ANALYSES PARTIELLES:\n";
        $userPrompt .= json_encode($analyses, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

        return $this->openRouter->chat($systemPrompt, $userPrompt);
    }

    private function buildSystemPrompt(): string
    {
        $categories = implode(', ', self::CATEGORIES);

        return <<<PROMPT
Tu es un analyste ASO expert. Analyse les reviews d'application mobile fournies.

Réponds UNIQUEMENT en JSON valide avec cette structure exacte:
{
  "categories": {
    "ux": { "score": <1-5>, "summary": "<résumé en 1-2 phrases>" },
    "performance": { "score": <1-5>, "summary": "<résumé>" },
    "features": { "score": <1-5>, "summary": "<résumé>" },
    "pricing": { "score": <1-5>, "summary": "<résumé>" },
    "support": { "score": <1-5>, "summary": "<résumé>" },
    "onboarding": { "score": <1-5>, "summary": "<résumé>" }
  },
  "emergent_themes": [
    {
      "label": "<nom court du thème>",
      "sentiment": "positive|negative|mixed",
      "frequency": <nombre de mentions estimé>,
      "summary": "<description en 1-2 phrases>",
      "example_quotes": ["<citation 1>", "<citation 2>"]
    }
  ],
  "overall_strengths": ["<force 1>", "<force 2>", ...],
  "overall_weaknesses": ["<faiblesse 1>", "<faiblesse 2>", ...],
  "opportunities": ["<opportunité 1>", "<opportunité 2>", ...]
}

Règles:
- Score 1 = très mauvais, 5 = excellent
- Maximum 5 thèmes émergents, les plus significatifs
- Maximum 5 items par liste (strengths, weaknesses, opportunities)
- Sois concis et factuel
- Réponds en français si les reviews sont majoritairement en français, sinon en anglais
PROMPT;
    }

    private function buildUserPrompt(App $app, array $reviews): string
    {
        $prompt = "APP: {$app->name} ({$app->platform})\n";
        $prompt .= "REVIEWS: " . count($reviews) . "\n\n";
        $prompt .= "---\n";

        foreach ($reviews as $review) {
            $rating = $review['rating'] ?? 'N/A';
            $date = $review['reviewed_at'] ?? 'N/A';
            $title = $review['title'] ?? '';
            $content = $review['content'] ?? '';
            $country = $review['country'] ?? '';

            $prompt .= "[{$rating}/5] [{$country}] {$date}\n";
            if ($title) {
                $prompt .= "Title: {$title}\n";
            }
            $prompt .= "{$content}\n";
            $prompt .= "---\n";
        }

        return $prompt;
    }

    private function extractSummaries(array $categories): array
    {
        $summaries = [];
        foreach ($categories as $key => $data) {
            $summaries[$key] = $data['summary'] ?? '';
        }
        return $summaries;
    }
}
```

**Step 2: Commit**

```bash
git add -A && git commit -m "feat(backend): add InsightsService with chunking and LLM analysis"
```

---

## Task 4: Create Insights Controller (Backend)

**Files:**
- Create: `api/app/Http/Controllers/Api/InsightsController.php`
- Modify: `api/routes/api.php`

**Step 1: Create the controller**

Create `api/app/Http/Controllers/Api/InsightsController.php`:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppInsight;
use App\Services\InsightsService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class InsightsController extends Controller
{
    public function __construct(
        private InsightsService $insightsService
    ) {}

    /**
     * Get the latest insight for an app
     */
    public function show(App $app): JsonResponse
    {
        $insight = $app->latestInsight;

        if (!$insight) {
            return response()->json([
                'message' => 'No insights available. Generate one first.',
            ], 404);
        }

        return response()->json([
            'data' => $this->formatInsight($insight),
        ]);
    }

    /**
     * Generate new insights for an app
     */
    public function generate(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'countries' => 'required|array|min:1',
            'countries.*' => 'string|size:2',
            'period_months' => 'integer|in:3,6,12',
        ]);

        $countries = $validated['countries'];
        $periodMonths = $validated['period_months'] ?? 6;

        // Check if recent insight exists (within 24h)
        $recentInsight = $app->insights()
            ->where('created_at', '>=', now()->subHours(24))
            ->where('countries', json_encode($countries))
            ->first();

        if ($recentInsight && !$request->boolean('force')) {
            return response()->json([
                'data' => $this->formatInsight($recentInsight),
                'cached' => true,
            ]);
        }

        $insight = $this->insightsService->generateInsights($app, $countries, $periodMonths);

        if (!$insight) {
            return response()->json([
                'message' => 'Failed to generate insights. Not enough reviews or LLM error.',
            ], 422);
        }

        return response()->json([
            'data' => $this->formatInsight($insight),
            'cached' => false,
        ]);
    }

    /**
     * Compare multiple apps
     */
    public function compare(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'app_ids' => 'required|array|min:2|max:4',
            'app_ids.*' => 'integer|exists:apps,id',
        ]);

        $user = $request->user();
        $appIds = $validated['app_ids'];

        // Verify user owns all apps
        $apps = App::whereIn('id', $appIds)
            ->where(function ($query) use ($user) {
                $query->whereHas('users', fn($q) => $q->where('user_id', $user->id))
                    ->orWhere('is_public', true);
            })
            ->get();

        if ($apps->count() !== count($appIds)) {
            return response()->json([
                'message' => 'One or more apps not found or not accessible.',
            ], 403);
        }

        $insights = [];
        foreach ($apps as $app) {
            $insight = $app->latestInsight;
            $insights[] = [
                'app' => [
                    'id' => $app->id,
                    'name' => $app->name,
                    'icon_url' => $app->icon_url,
                    'platform' => $app->platform,
                ],
                'insight' => $insight ? $this->formatInsight($insight) : null,
            ];
        }

        return response()->json([
            'data' => $insights,
        ]);
    }

    private function formatInsight(AppInsight $insight): array
    {
        return [
            'id' => $insight->id,
            'reviews_count' => $insight->reviews_count,
            'countries' => $insight->countries,
            'period_start' => $insight->period_start->toDateString(),
            'period_end' => $insight->period_end->toDateString(),
            'category_scores' => $insight->category_scores,
            'category_summaries' => $insight->category_summaries,
            'emergent_themes' => $insight->emergent_themes,
            'overall_strengths' => $insight->overall_strengths,
            'overall_weaknesses' => $insight->overall_weaknesses,
            'opportunities' => $insight->opportunities,
            'analyzed_at' => $insight->created_at->toIso8601String(),
        ];
    }
}
```

**Step 2: Add routes**

Edit `api/routes/api.php`, add inside the `apps` middleware group after reviews routes:

```php
// Insights for app
Route::get('{app}/insights', [InsightsController::class, 'show']);
Route::post('{app}/insights/generate', [InsightsController::class, 'generate']);
```

Add at the top with other use statements:

```php
use App\Http\Controllers\Api\InsightsController;
```

Add compare route inside the protected routes group (after the apps group):

```php
// Insights comparison
Route::get('insights/compare', [InsightsController::class, 'compare']);
```

**Step 3: Commit**

```bash
git add -A && git commit -m "feat(backend): add InsightsController with generate and compare endpoints"
```

---

## Task 5: Create Flutter Models (Frontend)

**Files:**
- Create: `app/lib/features/insights/domain/insight_model.dart`

**Step 1: Create the models**

Create directory and file `app/lib/features/insights/domain/insight_model.dart`:

```dart
class CategoryScore {
  final double score;
  final String summary;

  CategoryScore({
    required this.score,
    required this.summary,
  });

  factory CategoryScore.fromJson(Map<String, dynamic> json) {
    return CategoryScore(
      score: (json['score'] as num).toDouble(),
      summary: json['summary'] as String? ?? '',
    );
  }
}

class EmergentTheme {
  final String label;
  final String sentiment;
  final int frequency;
  final String summary;
  final List<String> exampleQuotes;

  EmergentTheme({
    required this.label,
    required this.sentiment,
    required this.frequency,
    required this.summary,
    required this.exampleQuotes,
  });

  factory EmergentTheme.fromJson(Map<String, dynamic> json) {
    return EmergentTheme(
      label: json['label'] as String? ?? '',
      sentiment: json['sentiment'] as String? ?? 'mixed',
      frequency: json['frequency'] as int? ?? 0,
      summary: json['summary'] as String? ?? '',
      exampleQuotes: (json['example_quotes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

class AppInsight {
  final int id;
  final int reviewsCount;
  final List<String> countries;
  final DateTime periodStart;
  final DateTime periodEnd;
  final Map<String, CategoryScore> categoryScores;
  final List<EmergentTheme> emergentThemes;
  final List<String> overallStrengths;
  final List<String> overallWeaknesses;
  final List<String> opportunities;
  final DateTime analyzedAt;

  AppInsight({
    required this.id,
    required this.reviewsCount,
    required this.countries,
    required this.periodStart,
    required this.periodEnd,
    required this.categoryScores,
    required this.emergentThemes,
    required this.overallStrengths,
    required this.overallWeaknesses,
    required this.opportunities,
    required this.analyzedAt,
  });

  factory AppInsight.fromJson(Map<String, dynamic> json) {
    final scoresJson = json['category_scores'] as Map<String, dynamic>? ?? {};
    final scores = <String, CategoryScore>{};
    scoresJson.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        scores[key] = CategoryScore.fromJson(value);
      }
    });

    return AppInsight(
      id: json['id'] as int,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      countries: (json['countries'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
      categoryScores: scores,
      emergentThemes: (json['emergent_themes'] as List<dynamic>?)
              ?.map((e) => EmergentTheme.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      overallStrengths: (json['overall_strengths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      overallWeaknesses: (json['overall_weaknesses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      opportunities: (json['opportunities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      analyzedAt: DateTime.parse(json['analyzed_at'] as String),
    );
  }
}

class InsightComparison {
  final int appId;
  final String appName;
  final String? iconUrl;
  final String platform;
  final AppInsight? insight;

  InsightComparison({
    required this.appId,
    required this.appName,
    this.iconUrl,
    required this.platform,
    this.insight,
  });

  factory InsightComparison.fromJson(Map<String, dynamic> json) {
    final appJson = json['app'] as Map<String, dynamic>;
    final insightJson = json['insight'] as Map<String, dynamic>?;

    return InsightComparison(
      appId: appJson['id'] as int,
      appName: appJson['name'] as String,
      iconUrl: appJson['icon_url'] as String?,
      platform: appJson['platform'] as String,
      insight: insightJson != null ? AppInsight.fromJson(insightJson) : null,
    );
  }
}
```

**Step 2: Commit**

```bash
git add -A && git commit -m "feat(flutter): add insight models"
```

---

## Task 6: Create Flutter Repository (Frontend)

**Files:**
- Create: `app/lib/features/insights/data/insights_repository.dart`
- Modify: `app/lib/core/constants/api_constants.dart`

**Step 1: Add API constant**

Edit `app/lib/core/constants/api_constants.dart`, add:

```dart
static const String insights = '/insights';
```

**Step 2: Create repository**

Create `app/lib/features/insights/data/insights_repository.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/insight_model.dart';

final insightsRepositoryProvider = Provider<InsightsRepository>((ref) {
  return InsightsRepository(ref.watch(dioProvider));
});

class InsightsRepository {
  final Dio dio;

  InsightsRepository(this.dio);

  /// Get the latest insight for an app
  Future<AppInsight?> getInsight(int appId) async {
    try {
      final response = await dio.get('${ApiConstants.apps}/$appId/insights');
      return AppInsight.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw ApiException.fromDioError(e);
    }
  }

  /// Generate new insights for an app
  Future<AppInsight> generateInsights({
    required int appId,
    required List<String> countries,
    int periodMonths = 6,
    bool force = false,
  }) async {
    try {
      final response = await dio.post(
        '${ApiConstants.apps}/$appId/insights/generate',
        data: {
          'countries': countries,
          'period_months': periodMonths,
          'force': force,
        },
      );
      return AppInsight.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Compare multiple apps
  Future<List<InsightComparison>> compareApps(List<int> appIds) async {
    try {
      final response = await dio.get(
        '${ApiConstants.insights}/compare',
        queryParameters: {'app_ids': appIds},
      );
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => InsightComparison.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
```

**Step 3: Commit**

```bash
git add -A && git commit -m "feat(flutter): add insights repository"
```

---

## Task 7: Create Flutter Provider (Frontend)

**Files:**
- Create: `app/lib/features/insights/providers/insights_provider.dart`

**Step 1: Create providers**

Create `app/lib/features/insights/providers/insights_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/insights_repository.dart';
import '../domain/insight_model.dart';

/// Provider for fetching insight for an app
final appInsightProvider = FutureProvider.family<AppInsight?, int>((ref, appId) async {
  final repository = ref.watch(insightsRepositoryProvider);
  return repository.getInsight(appId);
});

/// Provider for generating insights
final generateInsightProvider = FutureProvider.family<AppInsight, GenerateInsightParams>((ref, params) async {
  final repository = ref.watch(insightsRepositoryProvider);
  return repository.generateInsights(
    appId: params.appId,
    countries: params.countries,
    periodMonths: params.periodMonths,
    force: params.force,
  );
});

class GenerateInsightParams {
  final int appId;
  final List<String> countries;
  final int periodMonths;
  final bool force;

  GenerateInsightParams({
    required this.appId,
    required this.countries,
    this.periodMonths = 6,
    this.force = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenerateInsightParams &&
          appId == other.appId &&
          countries.join(',') == other.countries.join(',') &&
          periodMonths == other.periodMonths &&
          force == other.force;

  @override
  int get hashCode => Object.hash(appId, countries.join(','), periodMonths, force);
}

/// Provider for comparing apps
final compareAppsProvider = FutureProvider.family<List<InsightComparison>, List<int>>((ref, appIds) async {
  final repository = ref.watch(insightsRepositoryProvider);
  return repository.compareApps(appIds);
});
```

**Step 2: Commit**

```bash
git add -A && git commit -m "feat(flutter): add insights providers"
```

---

## Task 8: Create App Insights Screen (Frontend)

**Files:**
- Create: `app/lib/features/insights/presentation/app_insights_screen.dart`

**Step 1: Create the screen**

Create `app/lib/features/insights/presentation/app_insights_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/api/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/country_provider.dart';
import '../domain/insight_model.dart';
import '../providers/insights_provider.dart';
import '../data/insights_repository.dart';

class AppInsightsScreen extends ConsumerStatefulWidget {
  final int appId;
  final String appName;

  const AppInsightsScreen({
    super.key,
    required this.appId,
    required this.appName,
  });

  @override
  ConsumerState<AppInsightsScreen> createState() => _AppInsightsScreenState();
}

class _AppInsightsScreenState extends ConsumerState<AppInsightsScreen> {
  List<String> _selectedCountries = ['US'];
  int _periodMonths = 6;
  bool _isGenerating = false;
  AppInsight? _insight;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadExistingInsight();
  }

  Future<void> _loadExistingInsight() async {
    try {
      final repository = ref.read(insightsRepositoryProvider);
      final insight = await repository.getInsight(widget.appId);
      if (mounted) {
        setState(() => _insight = insight);
      }
    } catch (e) {
      // No existing insight
    }
  }

  Future<void> _generateInsights() async {
    if (_selectedCountries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one country')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _error = null;
    });

    try {
      final repository = ref.read(insightsRepositoryProvider);
      final insight = await repository.generateInsights(
        appId: widget.appId,
        countries: _selectedCountries,
        periodMonths: _periodMonths,
      );
      if (mounted) {
        setState(() {
          _insight = insight;
          _isGenerating = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGenerateSection(),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    _buildError(),
                  ],
                  if (_insight != null) ...[
                    const SizedBox(height: 24),
                    _buildInsightContent(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            child: InkWell(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              hoverColor: AppColors.bgHover,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.textMuted),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accent.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.insights_rounded, size: 18, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.appName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  'Review Insights',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateSection() {
    final countries = ref.watch(countriesProvider).valueOrNull ?? availableCountries;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Generate Analysis',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Country selector
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: countries.take(10).map((country) {
              final isSelected = _selectedCountries.contains(country.code.toUpperCase());
              return FilterChip(
                label: Text('${country.flag} ${country.code}'),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedCountries.add(country.code.toUpperCase());
                    } else {
                      _selectedCountries.remove(country.code.toUpperCase());
                    }
                  });
                },
                selectedColor: AppColors.accentMuted,
                checkmarkColor: AppColors.accent,
                backgroundColor: AppColors.bgActive,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.accent : AppColors.textSecondary,
                  fontSize: 12,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.accent : AppColors.glassBorder,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Period selector
          Row(
            children: [
              const Text(
                'Period:',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              _PeriodChip(label: '3 months', value: 3, selected: _periodMonths, onTap: () => setState(() => _periodMonths = 3)),
              const SizedBox(width: 8),
              _PeriodChip(label: '6 months', value: 6, selected: _periodMonths, onTap: () => setState(() => _periodMonths = 6)),
              const SizedBox(width: 8),
              _PeriodChip(label: '12 months', value: 12, selected: _periodMonths, onTap: () => setState(() => _periodMonths = 12)),
              const Spacer(),
              // Generate button
              Material(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                child: InkWell(
                  onTap: _isGenerating ? null : _generateInsights,
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: _isGenerating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Analyze',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.redMuted,
        border: Border.all(color: AppColors.red.withAlpha(50)),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _error!,
              style: const TextStyle(color: AppColors.red, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightContent() {
    final insight = _insight!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Metadata
        _buildMetadata(insight),
        const SizedBox(height: 20),
        // Strengths & Weaknesses
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildStrengthsCard(insight)),
            const SizedBox(width: 16),
            Expanded(child: _buildWeaknessesCard(insight)),
          ],
        ),
        const SizedBox(height: 20),
        // Category scores
        _buildCategoryScores(insight),
        const SizedBox(height: 20),
        // Emergent themes
        if (insight.emergentThemes.isNotEmpty) _buildEmergentThemes(insight),
        const SizedBox(height: 20),
        // Opportunities
        if (insight.opportunities.isNotEmpty) _buildOpportunities(insight),
      ],
    );
  }

  Widget _buildMetadata(AppInsight insight) {
    final dateFormat = DateFormat('d MMM yyyy');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text(
            '${insight.reviewsCount} reviews',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Text(
            insight.countries.join(', '),
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Text(
            '${dateFormat.format(insight.periodStart)} - ${dateFormat.format(insight.periodEnd)}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const Spacer(),
          Text(
            'Analyzed ${_timeAgo(insight.analyzedAt)}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsCard(AppInsight insight) {
    return _buildListCard(
      title: 'Strengths',
      icon: Icons.thumb_up_rounded,
      iconColor: AppColors.green,
      items: insight.overallStrengths,
      bgColor: AppColors.greenMuted,
    );
  }

  Widget _buildWeaknessesCard(AppInsight insight) {
    return _buildListCard(
      title: 'Weaknesses',
      icon: Icons.thumb_down_rounded,
      iconColor: AppColors.red,
      items: insight.overallWeaknesses,
      bgColor: AppColors.redMuted,
    );
  }

  Widget _buildListCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor.withAlpha(30),
        border: Border.all(color: bgColor),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•', style: TextStyle(color: iconColor, fontSize: 14)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCategoryScores(AppInsight insight) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category Scores',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: insight.categoryScores.entries.map((entry) {
              return _CategoryScoreCard(
                category: entry.key,
                score: entry.value.score,
                summary: entry.value.summary,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergentThemes(AppInsight insight) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Emergent Themes',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...insight.emergentThemes.map((theme) => _EmergentThemeCard(theme: theme)),
        ],
      ),
    );
  }

  Widget _buildOpportunities(AppInsight insight) {
    return _buildListCard(
      title: 'Opportunities',
      icon: Icons.lightbulb_rounded,
      iconColor: AppColors.yellow,
      items: insight.opportunities,
      bgColor: AppColors.yellow.withAlpha(30),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final int value;
  final int selected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return Material(
      color: isSelected ? AppColors.accent : AppColors.bgActive,
      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryScoreCard extends StatelessWidget {
  final String category;
  final double score;
  final String summary;

  const _CategoryScoreCard({
    required this.category,
    required this.score,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final color = score >= 4
        ? AppColors.green
        : score >= 3
            ? AppColors.yellow
            : AppColors.red;

    final categoryLabels = {
      'ux': 'UX / Interface',
      'performance': 'Performance',
      'features': 'Features',
      'pricing': 'Pricing',
      'support': 'Support',
      'onboarding': 'Onboarding',
    };

    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        border: Border.all(color: color.withAlpha(50)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                categoryLabels[category] ?? category,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  score.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (summary.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              summary,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _EmergentThemeCard extends StatefulWidget {
  final EmergentTheme theme;

  const _EmergentThemeCard({required this.theme});

  @override
  State<_EmergentThemeCard> createState() => _EmergentThemeCardState();
}

class _EmergentThemeCardState extends State<_EmergentThemeCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final sentimentColor = theme.sentiment == 'positive'
        ? AppColors.green
        : theme.sentiment == 'negative'
            ? AppColors.red
            : AppColors.yellow;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: sentimentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        theme.label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.bgActive,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${theme.frequency}x',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  theme.summary,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                if (_expanded && theme.exampleQuotes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.glassBorder, height: 1),
                  const SizedBox(height: 12),
                  const Text(
                    'Example quotes:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...theme.exampleQuotes.map((quote) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '"$quote"',
                          style: const TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Commit**

```bash
git add -A && git commit -m "feat(flutter): add app insights screen"
```

---

## Task 9: Add Route and Navigation (Frontend)

**Files:**
- Modify: `app/lib/core/router/app_router.dart`
- Modify: `app/lib/features/apps/presentation/app_detail_screen.dart`

**Step 1: Add route**

Edit `app/lib/core/router/app_router.dart`:

Add import at top:
```dart
import '../../features/insights/presentation/app_insights_screen.dart';
```

Add route after reviews route (inside apps routes):
```dart
GoRoute(
  path: ':id/insights',
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    final appName = state.uri.queryParameters['name'] ?? 'App';
    return AppInsightsScreen(appId: id, appName: appName);
  },
),
```

**Step 2: Add button in toolbar**

Edit `app/lib/features/apps/presentation/app_detail_screen.dart`:

In the `_Toolbar` widget, add a new `ToolbarButton` after the Ratings button:
```dart
const SizedBox(width: 10),
ToolbarButton(
  icon: Icons.insights_rounded,
  label: 'Insights',
  onTap: onViewInsights,
),
```

Add the `onViewInsights` callback to `_Toolbar`:
```dart
final VoidCallback onViewInsights;
```

And in `_Toolbar` constructor:
```dart
required this.onViewInsights,
```

In `AppDetailScreen` build method, update `_Toolbar` usage to include:
```dart
onViewInsights: () => context.push(
  '/apps/${widget.appId}/insights?name=${Uri.encodeComponent(app.name)}',
),
```

**Step 3: Commit**

```bash
git add -A && git commit -m "feat(flutter): add insights route and toolbar button"
```

---

## Task 10: Test End-to-End

**Step 1: Add OpenRouter API key to .env**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/api
echo "OPENROUTER_API_KEY=your_key_here" >> .env
```

**Step 2: Start backend**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/api && php artisan serve
```

**Step 3: Start Flutter app**

```bash
cd /Users/jerome/Projets/web/flutter/ranking/app && flutter run -d chrome
```

**Step 4: Test flow**

1. Login to the app
2. Go to an app with reviews
3. Click "Insights" button in toolbar
4. Select countries and click "Analyze"
5. Verify insights are displayed

**Step 5: Final commit**

```bash
git add -A && git commit -m "feat: complete review insights feature"
```

---

## Future Tasks (Out of Scope for MVP)

- [ ] Compare screen (`/compare`) for side-by-side analysis
- [ ] Alerts for emerging negative themes
- [ ] Export to PDF/CSV
- [ ] Rate limiting per user
