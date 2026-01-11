<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppRanking;
use App\Models\AppRating;
use App\Models\AppReview;
use App\Models\TrackedKeyword;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\StreamedResponse;

class ExportController extends Controller
{
    /**
     * Export rankings as CSV
     */
    public function rankings(Request $request, App $app): StreamedResponse
    {
        $request->validate([
            'days' => 'nullable|integer|min:1|max:365',
            'country' => 'nullable|string|size:2',
        ]);

        $user = $request->user();
        $days = $request->input('days', 30);
        $country = $request->input('country');

        $trackedKeywordIds = TrackedKeyword::where('app_id', $app->id)
            ->where('user_id', $user->id)
            ->pluck('keyword_id');

        $query = AppRanking::where('app_id', $app->id)
            ->whereIn('keyword_id', $trackedKeywordIds)
            ->where('recorded_at', '>=', now()->subDays($days))
            ->with('keyword')
            ->orderBy('recorded_at', 'desc');

        if ($country) {
            $query->where('country', $country);
        }

        $rankings = $query->get();

        $filename = "rankings-{$app->name}-" . now()->format('Y-m-d') . '.csv';

        return response()->streamDownload(function () use ($rankings) {
            $handle = fopen('php://output', 'w');

            // BOM for Excel UTF-8 compatibility
            fprintf($handle, chr(0xEF) . chr(0xBB) . chr(0xBF));

            // Header row
            fputcsv($handle, [
                'Keyword',
                'Platform',
                'Country',
                'Position',
                'Change',
                'Date',
            ]);

            // Data rows
            foreach ($rankings as $ranking) {
                fputcsv($handle, [
                    $ranking->keyword->keyword ?? 'Unknown',
                    $ranking->platform,
                    $ranking->country,
                    $ranking->position,
                    $ranking->change ?? 0,
                    $ranking->recorded_at->toDateString(),
                ]);
            }

            fclose($handle);
        }, $filename, [
            'Content-Type' => 'text/csv; charset=UTF-8',
            'Content-Disposition' => "attachment; filename=\"{$filename}\"",
        ]);
    }

    /**
     * Export reviews as CSV
     */
    public function reviews(Request $request, App $app): StreamedResponse
    {
        $request->validate([
            'days' => 'nullable|integer|min:1|max:365',
            'country' => 'nullable|string|size:2',
            'min_rating' => 'nullable|integer|min:1|max:5',
            'max_rating' => 'nullable|integer|min:1|max:5',
        ]);

        $days = $request->input('days', 30);
        $country = $request->input('country');
        $minRating = $request->input('min_rating');
        $maxRating = $request->input('max_rating');

        $query = AppReview::where('app_id', $app->id)
            ->where('created_at', '>=', now()->subDays($days))
            ->orderBy('created_at', 'desc');

        if ($country) {
            $query->where('country', $country);
        }

        if ($minRating) {
            $query->where('rating', '>=', $minRating);
        }

        if ($maxRating) {
            $query->where('rating', '<=', $maxRating);
        }

        $reviews = $query->get();

        $filename = "reviews-{$app->name}-" . now()->format('Y-m-d') . '.csv';

        return response()->streamDownload(function () use ($reviews) {
            $handle = fopen('php://output', 'w');

            // BOM for Excel UTF-8 compatibility
            fprintf($handle, chr(0xEF) . chr(0xBB) . chr(0xBF));

            // Header row
            fputcsv($handle, [
                'ID',
                'Author',
                'Rating',
                'Title',
                'Content',
                'Country',
                'Version',
                'Sentiment',
                'Themes',
                'Date',
                'Reply',
                'Reply Date',
            ]);

            // Data rows
            foreach ($reviews as $review) {
                fputcsv($handle, [
                    $review->store_review_id,
                    $review->author_name,
                    $review->rating,
                    $review->title ?? '',
                    $review->content,
                    $review->country,
                    $review->version ?? '',
                    $review->sentiment ?? '',
                    is_array($review->themes) ? implode(', ', $review->themes) : '',
                    $review->created_at->toDateString(),
                    $review->reply_content ?? '',
                    $review->replied_at?->toDateString() ?? '',
                ]);
            }

            fclose($handle);
        }, $filename, [
            'Content-Type' => 'text/csv; charset=UTF-8',
            'Content-Disposition' => "attachment; filename=\"{$filename}\"",
        ]);
    }

    /**
     * Export ratings history as CSV
     */
    public function ratings(Request $request, App $app): StreamedResponse
    {
        $request->validate([
            'days' => 'nullable|integer|min:1|max:365',
            'country' => 'nullable|string|size:2',
        ]);

        $days = $request->input('days', 30);
        $country = $request->input('country');

        $query = AppRating::where('app_id', $app->id)
            ->where('recorded_at', '>=', now()->subDays($days))
            ->orderBy('recorded_at', 'desc');

        if ($country) {
            $query->where('country', $country);
        }

        $ratings = $query->get();

        $filename = "ratings-{$app->name}-" . now()->format('Y-m-d') . '.csv';

        return response()->streamDownload(function () use ($ratings) {
            $handle = fopen('php://output', 'w');

            // BOM for Excel UTF-8 compatibility
            fprintf($handle, chr(0xEF) . chr(0xBB) . chr(0xBF));

            // Header row
            fputcsv($handle, [
                'Country',
                'Average Rating',
                'Total Ratings',
                '5 Stars',
                '4 Stars',
                '3 Stars',
                '2 Stars',
                '1 Star',
                'Date',
            ]);

            // Data rows
            foreach ($ratings as $rating) {
                fputcsv($handle, [
                    $rating->country,
                    number_format($rating->average_rating, 2),
                    $rating->total_ratings,
                    $rating->rating_5 ?? 0,
                    $rating->rating_4 ?? 0,
                    $rating->rating_3 ?? 0,
                    $rating->rating_2 ?? 0,
                    $rating->rating_1 ?? 0,
                    $rating->recorded_at->toDateString(),
                ]);
            }

            fclose($handle);
        }, $filename, [
            'Content-Type' => 'text/csv; charset=UTF-8',
            'Content-Disposition' => "attachment; filename=\"{$filename}\"",
        ]);
    }

    /**
     * Generate PDF report (returns JSON with report data for client-side PDF generation)
     */
    public function report(Request $request, App $app): JsonResponse
    {
        $request->validate([
            'days' => 'nullable|integer|min:1|max:365',
        ]);

        $user = $request->user();
        $days = $request->input('days', 30);
        $startDate = now()->subDays($days);

        // Get tracked keywords
        $trackedKeywords = TrackedKeyword::where('app_id', $app->id)
            ->where('user_id', $user->id)
            ->with('keyword')
            ->get();

        $keywordIds = $trackedKeywords->pluck('keyword_id');

        // Rankings summary
        $rankings = AppRanking::where('app_id', $app->id)
            ->whereIn('keyword_id', $keywordIds)
            ->where('recorded_at', '>=', $startDate)
            ->get();

        $latestRankings = $rankings->groupBy('keyword_id')->map(function ($group) {
            return $group->sortByDesc('recorded_at')->first();
        });

        $avgPosition = $latestRankings->avg('position');
        $top10Count = $latestRankings->filter(fn($r) => $r->position <= 10)->count();
        $top50Count = $latestRankings->filter(fn($r) => $r->position <= 50)->count();

        // Ratings summary
        $latestRating = AppRating::where('app_id', $app->id)
            ->orderBy('recorded_at', 'desc')
            ->first();

        $ratingHistory = AppRating::where('app_id', $app->id)
            ->where('recorded_at', '>=', $startDate)
            ->where('country', 'us')
            ->orderBy('recorded_at')
            ->get(['recorded_at', 'average_rating', 'total_ratings']);

        // Reviews summary
        $reviewsCount = AppReview::where('app_id', $app->id)
            ->where('created_at', '>=', $startDate)
            ->count();

        $reviewsAvgRating = AppReview::where('app_id', $app->id)
            ->where('created_at', '>=', $startDate)
            ->avg('rating');

        $sentimentBreakdown = AppReview::where('app_id', $app->id)
            ->where('created_at', '>=', $startDate)
            ->whereNotNull('sentiment')
            ->selectRaw('sentiment, COUNT(*) as count')
            ->groupBy('sentiment')
            ->pluck('count', 'sentiment');

        return response()->json([
            'report' => [
                'app' => [
                    'id' => $app->id,
                    'name' => $app->name,
                    'icon_url' => $app->icon_url,
                    'platform' => $app->platform,
                ],
                'period' => [
                    'days' => $days,
                    'start_date' => $startDate->toDateString(),
                    'end_date' => now()->toDateString(),
                ],
                'rankings' => [
                    'total_keywords' => $trackedKeywords->count(),
                    'average_position' => round($avgPosition, 1),
                    'top_10_count' => $top10Count,
                    'top_50_count' => $top50Count,
                    'keywords' => $latestRankings->map(fn($r) => [
                        'keyword' => $r->keyword->keyword ?? 'Unknown',
                        'position' => $r->position,
                        'change' => $r->change ?? 0,
                    ])->values(),
                ],
                'ratings' => [
                    'current' => $latestRating ? [
                        'average' => round($latestRating->average_rating, 2),
                        'total' => $latestRating->total_ratings,
                    ] : null,
                    'history' => $ratingHistory->map(fn($r) => [
                        'date' => $r->recorded_at->toDateString(),
                        'average' => round($r->average_rating, 2),
                        'total' => $r->total_ratings,
                    ]),
                ],
                'reviews' => [
                    'count' => $reviewsCount,
                    'average_rating' => $reviewsAvgRating ? round($reviewsAvgRating, 2) : null,
                    'sentiment' => $sentimentBreakdown,
                ],
                'generated_at' => now()->toIso8601String(),
            ],
        ]);
    }
}
