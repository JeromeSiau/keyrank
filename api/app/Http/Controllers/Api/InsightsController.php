<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppInsight;
use App\Models\Note;
use App\Services\AsoScoreService;
use App\Services\InsightsService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class InsightsController extends Controller
{
    public function __construct(
        private InsightsService $insightsService,
        private AsoScoreService $asoScoreService
    ) {}

    /**
     * Get the latest insight for an app
     */
    public function show(Request $request, App $app): JsonResponse
    {
        $insight = $app->latestInsight;

        if (!$insight) {
            return response()->json([
                'message' => 'No insights available. Generate one first.',
            ], 404);
        }

        return response()->json([
            'data' => $this->formatInsight($insight, $request->user()->id),
        ]);
    }

    /**
     * Get ASO Score for an app
     */
    public function asoScore(Request $request, App $app): JsonResponse
    {
        $userId = $request->user()->id;

        $score = $this->asoScoreService->calculate($app, $userId);

        return response()->json([
            'data' => $score,
        ]);
    }

    /**
     * Generate new insights for an app
     */
    public function generate(Request $request, App $app): JsonResponse
    {
        // Extend execution time for LLM calls (multiple chunks can take a while)
        set_time_limit(300);

        $validated = $request->validate([
            'countries' => 'required|array|min:1',
            'countries.*' => 'string|size:2',
            'period_months' => 'integer|in:3,6,12',
        ]);

        $countries = $validated['countries'];
        $periodMonths = $validated['period_months'] ?? 6;

        // Check if recent insight exists (within 24h) with same countries
        $recentInsight = $app->insights()
            ->where('created_at', '>=', now()->subHours(24))
            ->whereJsonContains('countries', $countries[0])
            ->first();

        $userId = $request->user()->id;

        if ($recentInsight && !$request->boolean('force')) {
            return response()->json([
                'data' => $this->formatInsight($recentInsight, $userId),
                'cached' => true,
            ]);
        }

        $userLocale = $request->user()->locale;
        $insight = $this->insightsService->generateInsights($app, $countries, $periodMonths, $userLocale);

        if (!$insight) {
            return response()->json([
                'message' => 'Failed to generate insights. Not enough reviews or LLM error.',
            ], 422);
        }

        return response()->json([
            'data' => $this->formatInsight($insight, $userId),
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

        // Get apps accessible to user
        $apps = App::whereIn('id', $appIds)->get();

        if ($apps->count() !== count($appIds)) {
            return response()->json([
                'message' => 'One or more apps not found.',
            ], 404);
        }

        $userId = $request->user()->id;

        $insights = [];
        foreach ($apps as $app) {
            $insight = $app->latestInsight;
            $insights[] = [
                'app' => [
                    'id' => $app->id,
                    'name' => $app->name,
                    'icon_url' => $app->icon_url,
                    'platform' => $app->platform,
                    'storefront' => $app->storefront,
                ],
                'insight' => $insight ? $this->formatInsight($insight, $userId) : null,
            ];
        }

        return response()->json([
            'data' => $insights,
        ]);
    }

    private function formatInsight(AppInsight $insight, int $userId): array
    {
        $note = Note::where('user_id', $userId)
            ->where('app_insight_id', $insight->id)
            ->first();

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
            'note' => $note?->content,
        ];
    }
}
