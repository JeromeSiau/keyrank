<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppRanking;
use App\Models\AppRating;
use App\Models\AppReview;
use App\Models\TrackedKeyword;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PublicApiController extends Controller
{
    /**
     * Get all team's apps
     */
    public function apps(Request $request): JsonResponse
    {
        $user = $request->attributes->get('api_user');
        $team = $user->currentTeam;

        if (!$team) {
            return response()->json(['error' => 'No team found'], 400);
        }

        $apps = $team->apps()
            ->select(['apps.id', 'apps.name', 'apps.platform', 'apps.store_id', 'apps.icon_url'])
            ->get();

        return response()->json([
            'data' => $apps,
            'meta' => [
                'total' => $apps->count(),
            ],
        ]);
    }

    /**
     * Get app details
     */
    public function app(Request $request, int $appId): JsonResponse
    {
        $user = $request->attributes->get('api_user');
        $team = $user->currentTeam;

        if (!$team) {
            return response()->json(['error' => 'No team found'], 400);
        }

        $app = $team->apps()->where('apps.id', $appId)->first();

        if (! $app) {
            return response()->json(['error' => 'App not found'], 404);
        }

        return response()->json([
            'data' => [
                'id' => $app->id,
                'name' => $app->name,
                'platform' => $app->platform,
                'store_id' => $app->store_id,
                'bundle_id' => $app->bundle_id,
                'icon_url' => $app->icon_url,
                'developer' => $app->developer,
                'price' => $app->price,
                'currency' => $app->currency,
            ],
        ]);
    }

    /**
     * Get app rankings
     */
    public function rankings(Request $request, int $appId): JsonResponse
    {
        $request->validate([
            'days' => 'nullable|integer|min:1|max:90',
            'country' => 'nullable|string|size:2',
            'keyword' => 'nullable|string',
        ]);

        $user = $request->attributes->get('api_user');
        $team = $user->currentTeam;

        if (!$team) {
            return response()->json(['error' => 'No team found'], 400);
        }

        $app = $team->apps()->where('apps.id', $appId)->first();
        if (! $app) {
            return response()->json(['error' => 'App not found'], 404);
        }

        $days = $request->input('days', 7);
        $country = $request->input('country');
        $keyword = $request->input('keyword');

        $trackedKeywordIds = TrackedKeyword::where('app_id', $appId)
            ->where('team_id', $team->id)
            ->pluck('keyword_id');

        $query = AppRanking::where('app_id', $appId)
            ->whereIn('keyword_id', $trackedKeywordIds)
            ->where('recorded_at', '>=', now()->subDays($days))
            ->with('keyword:id,keyword')
            ->orderBy('recorded_at', 'desc');

        if ($country) {
            $query->where('country', $country);
        }

        if ($keyword) {
            $query->whereHas('keyword', fn($q) => $q->where('keyword', 'like', "%{$keyword}%"));
        }

        $rankings = $query->limit(1000)->get();

        return response()->json([
            'data' => $rankings->map(fn($r) => [
                'keyword' => $r->keyword->keyword ?? null,
                'position' => $r->position,
                'change' => $r->change,
                'country' => $r->country,
                'platform' => $r->platform,
                'date' => $r->recorded_at->toDateString(),
            ]),
            'meta' => [
                'total' => $rankings->count(),
                'days' => $days,
            ],
        ]);
    }

    /**
     * Get app ratings
     */
    public function ratings(Request $request, int $appId): JsonResponse
    {
        $request->validate([
            'days' => 'nullable|integer|min:1|max:90',
            'country' => 'nullable|string|size:2',
        ]);

        $user = $request->attributes->get('api_user');
        $team = $user->currentTeam;

        if (!$team) {
            return response()->json(['error' => 'No team found'], 400);
        }

        $app = $team->apps()->where('apps.id', $appId)->first();
        if (! $app) {
            return response()->json(['error' => 'App not found'], 404);
        }

        $days = $request->input('days', 7);
        $country = $request->input('country');

        $query = AppRating::where('app_id', $appId)
            ->where('recorded_at', '>=', now()->subDays($days))
            ->orderBy('recorded_at', 'desc');

        if ($country) {
            $query->where('country', $country);
        }

        $ratings = $query->limit(500)->get();

        return response()->json([
            'data' => $ratings->map(fn($r) => [
                'country' => $r->country,
                'average_rating' => round($r->average_rating, 2),
                'total_ratings' => $r->total_ratings,
                'date' => $r->recorded_at->toDateString(),
            ]),
            'meta' => [
                'total' => $ratings->count(),
                'days' => $days,
            ],
        ]);
    }

    /**
     * Get app reviews
     */
    public function reviews(Request $request, int $appId): JsonResponse
    {
        $request->validate([
            'days' => 'nullable|integer|min:1|max:90',
            'country' => 'nullable|string|size:2',
            'rating' => 'nullable|integer|min:1|max:5',
            'page' => 'nullable|integer|min:1',
            'per_page' => 'nullable|integer|min:1|max:100',
        ]);

        $user = $request->attributes->get('api_user');
        $team = $user->currentTeam;

        if (!$team) {
            return response()->json(['error' => 'No team found'], 400);
        }

        $app = $team->apps()->where('apps.id', $appId)->first();
        if (! $app) {
            return response()->json(['error' => 'App not found'], 404);
        }

        $days = $request->input('days', 7);
        $country = $request->input('country');
        $rating = $request->input('rating');
        $page = $request->input('page', 1);
        $perPage = $request->input('per_page', 50);

        $query = AppReview::where('app_id', $appId)
            ->where('created_at', '>=', now()->subDays($days))
            ->orderBy('created_at', 'desc');

        if ($country) {
            $query->where('country', $country);
        }

        if ($rating) {
            $query->where('rating', $rating);
        }

        $total = $query->count();
        $reviews = $query->skip(($page - 1) * $perPage)->take($perPage)->get();

        return response()->json([
            'data' => $reviews->map(fn($r) => [
                'id' => $r->store_review_id,
                'author' => $r->author_name,
                'rating' => $r->rating,
                'title' => $r->title,
                'content' => $r->content,
                'country' => $r->country,
                'version' => $r->version,
                'sentiment' => $r->sentiment,
                'date' => $r->created_at->toDateString(),
            ]),
            'meta' => [
                'total' => $total,
                'page' => $page,
                'per_page' => $perPage,
                'total_pages' => ceil($total / $perPage),
            ],
        ]);
    }

    /**
     * Get tracked keywords for an app
     */
    public function keywords(Request $request, int $appId): JsonResponse
    {
        $user = $request->attributes->get('api_user');
        $team = $user->currentTeam;

        if (!$team) {
            return response()->json(['error' => 'No team found'], 400);
        }

        $app = $team->apps()->where('apps.id', $appId)->first();
        if (! $app) {
            return response()->json(['error' => 'App not found'], 404);
        }

        $keywords = TrackedKeyword::where('app_id', $appId)
            ->where('team_id', $team->id)
            ->with('keyword:id,keyword')
            ->get();

        return response()->json([
            'data' => $keywords->map(fn($tk) => [
                'id' => $tk->keyword_id,
                'keyword' => $tk->keyword->keyword ?? null,
                'is_favorite' => $tk->is_favorite,
            ]),
            'meta' => [
                'total' => $keywords->count(),
            ],
        ]);
    }
}
