<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class RatingsController extends Controller
{
    /**
     * Get ratings for an app across all countries
     * Data is collected by background collectors - no on-demand fetching
     */
    public function forApp(Request $request, App $app): JsonResponse
    {
        // Get latest ratings from database (no on-demand fetching)
        $latestRatings = $app->latestRatings()
            ->orderByDesc('rating_count')
            ->get();

        // Calculate totals
        $totalRatings = $latestRatings->sum('rating_count');
        $weightedSum = $latestRatings->sum(fn($r) => ($r->rating ?? 0) * $r->rating_count);
        $averageRating = $totalRatings > 0 ? round($weightedSum / $totalRatings, 2) : null;

        return response()->json([
            'data' => [
                'app_id' => $app->id,
                'platform' => $app->platform,
                'total_ratings' => $totalRatings,
                'average_rating' => $averageRating,
                'ratings' => $latestRatings->map(fn($r) => [
                    'country' => $r->country,
                    'rating' => $r->rating,
                    'rating_count' => $r->rating_count,
                    'recorded_at' => $r->recorded_at->toIso8601String(),
                ])->values(),
                'last_updated' => $latestRatings->max('recorded_at')?->toIso8601String(),
            ],
        ]);
    }

    /**
     * Get rating history for a specific country
     */
    public function history(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'country' => 'required|string|size:2',
            'days' => 'nullable|integer|min:1|max:365',
        ]);

        $country = strtoupper($validated['country']);
        $days = $validated['days'] ?? 30;

        $history = $app->ratings()
            ->where('country', $country)
            ->where('recorded_at', '>=', now()->subDays($days))
            ->orderBy('recorded_at')
            ->get();

        return response()->json([
            'data' => [
                'app_id' => $app->id,
                'country' => $country,
                'platform' => $app->platform,
                'history' => $history->map(fn($r) => [
                    'country' => $country,
                    'rating' => $r->rating,
                    'rating_count' => $r->rating_count,
                    'recorded_at' => $r->recorded_at->toIso8601String(),
                ]),
            ],
        ]);
    }
}
