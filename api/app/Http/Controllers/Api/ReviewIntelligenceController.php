<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Concerns\AuthorizesTeamActions;
use App\Models\App;
use App\Models\ReviewInsight;
use App\Services\ReviewIntelligenceService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ReviewIntelligenceController extends Controller
{
    use AuthorizesTeamActions;

    public function __construct(
        private ReviewIntelligenceService $service
    ) {}

    /**
     * GET /apps/{app}/review-intelligence
     * Returns dashboard data: feature requests, bug reports, version sentiment
     */
    public function index(App $app): JsonResponse
    {
        $team = $this->currentTeam();

        if (!$team->apps()->where('apps.id', $app->id)->exists()) {
            return response()->json(['error' => 'App not found.'], 404);
        }

        $featureRequests = ReviewInsight::where('app_id', $app->id)
            ->featureRequests()
            ->open()
            ->orderByDesc('mention_count')
            ->limit(10)
            ->get();

        $bugReports = ReviewInsight::where('app_id', $app->id)
            ->bugReports()
            ->open()
            ->orderByDesc('priority')
            ->orderByDesc('mention_count')
            ->limit(10)
            ->get();

        $versionSentiment = $this->service->getVersionSentiment($app);
        $versionInsight = $this->service->getVersionInsight($versionSentiment);

        return response()->json([
            'data' => [
                'feature_requests' => $featureRequests->map(fn($i) => $this->formatInsight($i)),
                'bug_reports' => $bugReports->map(fn($i) => $this->formatInsight($i)),
                'version_sentiment' => $versionSentiment,
                'version_insight' => $versionInsight,
                'summary' => [
                    'total_feature_requests' => ReviewInsight::where('app_id', $app->id)->featureRequests()->count(),
                    'total_bug_reports' => ReviewInsight::where('app_id', $app->id)->bugReports()->count(),
                    'open_feature_requests' => ReviewInsight::where('app_id', $app->id)->featureRequests()->open()->count(),
                    'open_bug_reports' => ReviewInsight::where('app_id', $app->id)->bugReports()->open()->count(),
                    'high_priority_bugs' => ReviewInsight::where('app_id', $app->id)->bugReports()->highPriority()->open()->count(),
                ],
            ],
        ]);
    }

    /**
     * GET /apps/{app}/review-intelligence/feature-requests
     */
    public function featureRequests(Request $request, App $app): JsonResponse
    {
        $team = $this->currentTeam();

        if (!$team->apps()->where('apps.id', $app->id)->exists()) {
            return response()->json(['error' => 'App not found.'], 404);
        }

        $query = ReviewInsight::where('app_id', $app->id)
            ->featureRequests()
            ->withCount('mentions');

        // Filter by status
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        // Filter by priority
        if ($request->has('priority')) {
            $query->where('priority', $request->priority);
        }

        $perPage = min($request->input('per_page', 20), 100);
        $insights = $query->orderByDesc('mention_count')->paginate($perPage);

        return response()->json([
            'data' => $insights->map(fn($i) => $this->formatInsight($i)),
            'meta' => [
                'current_page' => $insights->currentPage(),
                'last_page' => $insights->lastPage(),
                'per_page' => $insights->perPage(),
                'total' => $insights->total(),
            ],
        ]);
    }

    /**
     * GET /apps/{app}/review-intelligence/bug-reports
     */
    public function bugReports(Request $request, App $app): JsonResponse
    {
        $team = $this->currentTeam();

        if (!$team->apps()->where('apps.id', $app->id)->exists()) {
            return response()->json(['error' => 'App not found.'], 404);
        }

        $query = ReviewInsight::where('app_id', $app->id)
            ->bugReports()
            ->withCount('mentions');

        // Filter by status
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        // Filter by priority
        if ($request->has('priority')) {
            $query->where('priority', $request->priority);
        }

        // Filter by platform
        if ($request->has('platform')) {
            $query->where('platform', $request->platform);
        }

        $perPage = min($request->input('per_page', 20), 100);
        $insights = $query
            ->orderByRaw("FIELD(priority, 'critical', 'high', 'medium', 'low')")
            ->orderByDesc('mention_count')
            ->paginate($perPage);

        return response()->json([
            'data' => $insights->map(fn($i) => $this->formatInsight($i)),
            'meta' => [
                'current_page' => $insights->currentPage(),
                'last_page' => $insights->lastPage(),
                'per_page' => $insights->perPage(),
                'total' => $insights->total(),
            ],
        ]);
    }

    /**
     * GET /apps/{app}/review-intelligence/insights/{insight}/reviews
     */
    public function insightReviews(App $app, ReviewInsight $insight): JsonResponse
    {
        $team = $this->currentTeam();

        if (!$team->apps()->where('apps.id', $app->id)->exists()) {
            return response()->json(['error' => 'App not found.'], 404);
        }

        if ($insight->app_id !== $app->id) {
            return response()->json(['error' => 'Insight does not belong to this app.'], 404);
        }

        $reviews = $insight->reviews()
            ->orderByDesc('reviewed_at')
            ->limit(50)
            ->get();

        return response()->json([
            'data' => [
                'insight' => $this->formatInsight($insight),
                'reviews' => $reviews->map(fn($r) => [
                    'id' => $r->id,
                    'author' => $r->author,
                    'title' => $r->title,
                    'content' => $r->content,
                    'rating' => $r->rating,
                    'version' => $r->version,
                    'country' => $r->country,
                    'sentiment' => $r->sentiment,
                    'reviewed_at' => $r->reviewed_at?->toIso8601String(),
                ]),
            ],
        ]);
    }

    /**
     * PATCH /apps/{app}/review-intelligence/insights/{insight}
     * Update insight status or priority
     */
    public function updateInsight(Request $request, App $app, ReviewInsight $insight): JsonResponse
    {
        $team = $this->currentTeam();

        if (!$team->apps()->where('apps.id', $app->id)->exists()) {
            return response()->json(['error' => 'App not found.'], 404);
        }

        if ($insight->app_id !== $app->id) {
            return response()->json(['error' => 'Insight does not belong to this app.'], 404);
        }

        $validated = $request->validate([
            'status' => 'sometimes|in:open,planned,in_progress,resolved,wont_fix',
            'priority' => 'sometimes|in:low,medium,high,critical',
        ]);

        $insight->update($validated);

        return response()->json([
            'data' => $this->formatInsight($insight->fresh()),
        ]);
    }

    /**
     * Format insight for JSON response
     */
    private function formatInsight(ReviewInsight $insight): array
    {
        return [
            'id' => $insight->id,
            'type' => $insight->type,
            'title' => $insight->title,
            'description' => $insight->description,
            'keywords' => $insight->keywords,
            'mention_count' => $insight->mention_count,
            'priority' => $insight->priority,
            'status' => $insight->status,
            'platform' => $insight->platform,
            'affected_version' => $insight->affected_version,
            'first_mentioned_at' => $insight->first_mentioned_at?->toIso8601String(),
            'last_mentioned_at' => $insight->last_mentioned_at?->toIso8601String(),
            'created_at' => $insight->created_at?->toIso8601String(),
            'updated_at' => $insight->updated_at?->toIso8601String(),
        ];
    }
}
