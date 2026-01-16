<?php

namespace App\Services;

use App\Models\App;
use App\Models\AppReview;
use App\Models\TrackedKeyword;
use App\Models\AppRating;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class AsoScoreService
{
    private const METADATA_MAX = 25;
    private const KEYWORDS_MAX = 25;
    private const REVIEWS_MAX = 25;
    private const RATINGS_MAX = 25;

    /**
     * Calculate the ASO score for an app
     *
     * @param App $app
     * @param int $userId
     * @return array{score: int, breakdown: array, trend: array, recommendations: array}
     */
    public function calculate(App $app, int $userId): array
    {
        $metadataScore = $this->calculateMetadataScore($app);
        $keywordsScore = $this->calculateKeywordsScore($app, $userId);
        $reviewsScore = $this->calculateReviewsScore($app);
        $ratingsScore = $this->calculateRatingsScore($app);

        $totalScore = $metadataScore['score'] + $keywordsScore['score'] + $reviewsScore['score'] + $ratingsScore['score'];

        // Calculate trend (compare to 7 days ago)
        $trend = $this->calculateTrend($app, $userId, $totalScore);

        // Generate recommendations
        $recommendations = $this->generateRecommendations(
            $metadataScore,
            $keywordsScore,
            $reviewsScore,
            $ratingsScore
        );

        return [
            'score' => $totalScore,
            'breakdown' => [
                'metadata' => [
                    'score' => $metadataScore['score'],
                    'max' => self::METADATA_MAX,
                    'percent' => round(($metadataScore['score'] / self::METADATA_MAX) * 100),
                    'details' => $metadataScore['details'],
                ],
                'keywords' => [
                    'score' => $keywordsScore['score'],
                    'max' => self::KEYWORDS_MAX,
                    'percent' => round(($keywordsScore['score'] / self::KEYWORDS_MAX) * 100),
                    'details' => $keywordsScore['details'],
                ],
                'reviews' => [
                    'score' => $reviewsScore['score'],
                    'max' => self::REVIEWS_MAX,
                    'percent' => round(($reviewsScore['score'] / self::REVIEWS_MAX) * 100),
                    'details' => $reviewsScore['details'],
                ],
                'ratings' => [
                    'score' => $ratingsScore['score'],
                    'max' => self::RATINGS_MAX,
                    'percent' => round(($ratingsScore['score'] / self::RATINGS_MAX) * 100),
                    'details' => $ratingsScore['details'],
                ],
            ],
            'trend' => $trend,
            'recommendations' => $recommendations,
        ];
    }

    /**
     * Calculate metadata score (title, subtitle, description optimization)
     */
    private function calculateMetadataScore(App $app): array
    {
        $score = 0;
        $details = [];

        // Title optimization (max 30 chars for iOS, check if near limit)
        $titleLength = mb_strlen($app->name ?? '');
        if ($titleLength >= 25) {
            $score += 5;
            $details['title'] = ['status' => 'good', 'value' => $titleLength, 'max' => 30];
        } elseif ($titleLength >= 15) {
            $score += 3;
            $details['title'] = ['status' => 'fair', 'value' => $titleLength, 'max' => 30];
        } else {
            $details['title'] = ['status' => 'needs_work', 'value' => $titleLength, 'max' => 30];
        }

        // Description length (good if > 2000 chars)
        $descLength = mb_strlen($app->description ?? '');
        if ($descLength >= 2000) {
            $score += 5;
            $details['description'] = ['status' => 'good', 'value' => $descLength, 'target' => 2000];
        } elseif ($descLength >= 1000) {
            $score += 3;
            $details['description'] = ['status' => 'fair', 'value' => $descLength, 'target' => 2000];
        } elseif ($descLength >= 500) {
            $score += 1;
            $details['description'] = ['status' => 'needs_work', 'value' => $descLength, 'target' => 2000];
        } else {
            $details['description'] = ['status' => 'poor', 'value' => $descLength, 'target' => 2000];
        }

        // Screenshots count (good if >= 5)
        $screenshotsCount = is_array($app->screenshots) ? count($app->screenshots) : 0;
        if ($screenshotsCount >= 5) {
            $score += 5;
            $details['screenshots'] = ['status' => 'good', 'value' => $screenshotsCount, 'target' => 5];
        } elseif ($screenshotsCount >= 3) {
            $score += 3;
            $details['screenshots'] = ['status' => 'fair', 'value' => $screenshotsCount, 'target' => 5];
        } else {
            $details['screenshots'] = ['status' => 'needs_work', 'value' => $screenshotsCount, 'target' => 5];
        }

        // Has icon (+2)
        if (!empty($app->icon_url)) {
            $score += 2;
            $details['icon'] = ['status' => 'good', 'value' => true];
        } else {
            $details['icon'] = ['status' => 'needs_work', 'value' => false];
        }

        // Recent update within 90 days (+5)
        $lastUpdate = $app->updated_date;
        if ($lastUpdate && $lastUpdate->diffInDays(now()) <= 90) {
            $score += 5;
            $details['freshness'] = ['status' => 'good', 'days_since_update' => $lastUpdate->diffInDays(now())];
        } elseif ($lastUpdate && $lastUpdate->diffInDays(now()) <= 180) {
            $score += 3;
            $details['freshness'] = ['status' => 'fair', 'days_since_update' => $lastUpdate->diffInDays(now())];
        } else {
            $details['freshness'] = ['status' => 'needs_work', 'days_since_update' => $lastUpdate?->diffInDays(now())];
        }

        // Has category assigned (+3) - important for discoverability
        if (!empty($app->category_id)) {
            $score += 3;
            $details['category'] = ['status' => 'good', 'value' => true];
        } else {
            $details['category'] = ['status' => 'needs_work', 'value' => false];
        }

        return ['score' => min($score, self::METADATA_MAX), 'details' => $details];
    }

    /**
     * Calculate keywords score (tracked keywords performance)
     */
    private function calculateKeywordsScore(App $app, int $userId): array
    {
        $score = 0;
        $details = [];

        // Get tracked keywords count for this user + app
        $trackedKeywords = TrackedKeyword::where('app_id', $app->id)
            ->where('user_id', $userId)
            ->count();

        $details['tracked_count'] = $trackedKeywords;

        // Score for number of keywords tracked (target: >= 20)
        if ($trackedKeywords >= 20) {
            $score += 5;
            $details['tracking'] = ['status' => 'good', 'value' => $trackedKeywords, 'target' => 20];
        } elseif ($trackedKeywords >= 10) {
            $score += 3;
            $details['tracking'] = ['status' => 'fair', 'value' => $trackedKeywords, 'target' => 20];
        } elseif ($trackedKeywords >= 5) {
            $score += 1;
            $details['tracking'] = ['status' => 'needs_work', 'value' => $trackedKeywords, 'target' => 20];
        } else {
            $details['tracking'] = ['status' => 'poor', 'value' => $trackedKeywords, 'target' => 20];
        }

        // Get ranking performance stats
        $latestRankings = DB::table('app_rankings')
            ->where('app_id', $app->id)
            ->whereDate('recorded_at', today())
            ->get();

        $inTopTen = 0;
        $inTopFifty = 0;
        $totalRanked = 0;
        $positions = [];

        foreach ($latestRankings as $ranking) {
            if ($ranking->position > 0 && $ranking->position <= 200) {
                $totalRanked++;
                $positions[] = $ranking->position;
                if ($ranking->position <= 10) {
                    $inTopTen++;
                }
                if ($ranking->position <= 50) {
                    $inTopFifty++;
                }
            }
        }

        $details['total_ranked'] = $totalRanked;
        $details['in_top_10'] = $inTopTen;
        $details['in_top_50'] = $inTopFifty;

        // Score for % in top 10 (target: >= 30%)
        if ($totalRanked > 0) {
            $topTenPercent = ($inTopTen / $totalRanked) * 100;
            $details['top_10_percent'] = round($topTenPercent, 1);

            if ($topTenPercent >= 30) {
                $score += 10;
                $details['top_10_status'] = 'good';
            } elseif ($topTenPercent >= 15) {
                $score += 6;
                $details['top_10_status'] = 'fair';
            } elseif ($topTenPercent >= 5) {
                $score += 3;
                $details['top_10_status'] = 'needs_work';
            } else {
                $details['top_10_status'] = 'poor';
            }

            // Average position
            $avgPosition = count($positions) > 0 ? array_sum($positions) / count($positions) : 0;
            $details['avg_position'] = round($avgPosition, 1);
        } else {
            $details['top_10_percent'] = 0;
            $details['top_10_status'] = 'no_data';
            $details['avg_position'] = null;
        }

        // Score for position improvements (check trend over last 7 days)
        $weekAgo = Carbon::now()->subDays(7)->startOfDay();
        $positionChanges = DB::table('app_rankings as r1')
            ->join('app_rankings as r2', function ($join) use ($app, $weekAgo) {
                $join->on('r1.keyword_id', '=', 'r2.keyword_id')
                    ->where('r1.app_id', $app->id)
                    ->where('r2.app_id', $app->id)
                    ->whereDate('r1.recorded_at', today())
                    ->whereDate('r2.recorded_at', $weekAgo);
            })
            ->select(DB::raw('(r2.position - r1.position) as improvement'))
            ->whereRaw('r1.position > 0 AND r2.position > 0')
            ->get();

        $totalImprovement = 0;
        $improvedCount = 0;
        $declinedCount = 0;

        foreach ($positionChanges as $change) {
            $totalImprovement += $change->improvement;
            if ($change->improvement > 0) {
                $improvedCount++;
            } elseif ($change->improvement < 0) {
                $declinedCount++;
            }
        }

        $details['improved_count'] = $improvedCount;
        $details['declined_count'] = $declinedCount;

        // Score for positive trend (+5)
        if ($improvedCount > $declinedCount && $totalImprovement > 0) {
            $score += 5;
            $details['trend_status'] = 'improving';
        } elseif ($improvedCount >= $declinedCount) {
            $score += 3;
            $details['trend_status'] = 'stable';
        } else {
            $details['trend_status'] = 'declining';
        }

        // Score for % in top 50 (+5) - shows broader visibility
        if ($totalRanked > 0) {
            $topFiftyPercent = ($inTopFifty / $totalRanked) * 100;
            $details['top_50_percent'] = round($topFiftyPercent, 1);

            if ($topFiftyPercent >= 60) {
                $score += 5;
                $details['top_50_status'] = 'good';
            } elseif ($topFiftyPercent >= 40) {
                $score += 3;
                $details['top_50_status'] = 'fair';
            } elseif ($topFiftyPercent >= 20) {
                $score += 1;
                $details['top_50_status'] = 'needs_work';
            } else {
                $details['top_50_status'] = 'poor';
            }
        } else {
            $details['top_50_percent'] = 0;
            $details['top_50_status'] = 'no_data';
        }

        return ['score' => min($score, self::KEYWORDS_MAX), 'details' => $details];
    }

    /**
     * Calculate reviews score (sentiment, response rate)
     */
    private function calculateReviewsScore(App $app): array
    {
        $score = 0;
        $details = [];

        // Get reviews from last 90 days
        $recentReviews = AppReview::where('app_id', $app->id)
            ->where('reviewed_at', '>=', Carbon::now()->subDays(90))
            ->get();

        $totalReviews = $recentReviews->count();
        $details['total_recent'] = $totalReviews;

        if ($totalReviews === 0) {
            $details['status'] = 'no_data';
            return ['score' => 0, 'details' => $details];
        }

        // Sentiment analysis
        $positiveCount = $recentReviews->where('sentiment', 'positive')->count();
        $negativeCount = $recentReviews->where('sentiment', 'negative')->count();
        $neutralCount = $recentReviews->where('sentiment', 'neutral')->count();

        $positiveSentimentPercent = ($positiveCount / $totalReviews) * 100;
        $details['positive_percent'] = round($positiveSentimentPercent, 1);
        $details['negative_percent'] = round(($negativeCount / $totalReviews) * 100, 1);

        // Score for positive sentiment (target: >= 70%)
        if ($positiveSentimentPercent >= 70) {
            $score += 10;
            $details['sentiment_status'] = 'good';
        } elseif ($positiveSentimentPercent >= 50) {
            $score += 6;
            $details['sentiment_status'] = 'fair';
        } elseif ($positiveSentimentPercent >= 30) {
            $score += 3;
            $details['sentiment_status'] = 'needs_work';
        } else {
            $details['sentiment_status'] = 'poor';
        }

        // Response rate
        $answeredCount = $recentReviews->whereNotNull('our_response')->count();
        $responseRate = ($answeredCount / $totalReviews) * 100;
        $details['response_rate'] = round($responseRate, 1);
        $details['answered_count'] = $answeredCount;

        // Score for response rate (target: >= 50%)
        if ($responseRate >= 50) {
            $score += 10;
            $details['response_status'] = 'good';
        } elseif ($responseRate >= 25) {
            $score += 6;
            $details['response_status'] = 'fair';
        } elseif ($responseRate >= 10) {
            $score += 3;
            $details['response_status'] = 'needs_work';
        } else {
            $details['response_status'] = 'poor';
        }

        // Check for recent negative spike (last 7 days vs previous 7 days)
        $lastWeekNegative = AppReview::where('app_id', $app->id)
            ->where('reviewed_at', '>=', Carbon::now()->subDays(7))
            ->where('sentiment', 'negative')
            ->count();

        $previousWeekNegative = AppReview::where('app_id', $app->id)
            ->whereBetween('reviewed_at', [Carbon::now()->subDays(14), Carbon::now()->subDays(7)])
            ->where('sentiment', 'negative')
            ->count();

        $hasNegativeSpike = $previousWeekNegative > 0 && ($lastWeekNegative / $previousWeekNegative) > 1.5;
        $details['has_negative_spike'] = $hasNegativeSpike;

        if (!$hasNegativeSpike) {
            $score += 5;
            $details['spike_status'] = 'good';
        } else {
            $details['spike_status'] = 'warning';
        }

        return ['score' => min($score, self::REVIEWS_MAX), 'details' => $details];
    }

    /**
     * Calculate ratings score
     */
    private function calculateRatingsScore(App $app): array
    {
        $score = 0;
        $details = [];

        // Get current global rating
        $currentRating = $app->rating;
        $ratingCount = $app->rating_count;

        $details['current_rating'] = $currentRating;
        $details['rating_count'] = $ratingCount;

        if (!$currentRating) {
            $details['status'] = 'no_data';
            return ['score' => 0, 'details' => $details];
        }

        // Score for rating value
        if ($currentRating >= 4.5) {
            $score += 15;
            $details['rating_status'] = 'excellent';
        } elseif ($currentRating >= 4.0) {
            $score += 10;
            $details['rating_status'] = 'good';
        } elseif ($currentRating >= 3.5) {
            $score += 5;
            $details['rating_status'] = 'fair';
        } elseif ($currentRating >= 3.0) {
            $score += 2;
            $details['rating_status'] = 'needs_work';
        } else {
            $details['rating_status'] = 'poor';
        }

        // Check rating trend (compare to 30 days ago)
        $oldRating = AppRating::where('app_id', $app->id)
            ->whereDate('recorded_at', '<=', Carbon::now()->subDays(30))
            ->orderBy('recorded_at', 'desc')
            ->first();

        if ($oldRating) {
            $ratingChange = $currentRating - $oldRating->rating;
            $details['rating_change'] = round($ratingChange, 2);
            $details['old_rating'] = $oldRating->rating;

            // Score for stable or improving rating
            if ($ratingChange >= 0) {
                $score += 10;
                $details['trend_status'] = $ratingChange > 0.1 ? 'improving' : 'stable';
            } elseif ($ratingChange >= -0.2) {
                $score += 5;
                $details['trend_status'] = 'slight_decline';
            } else {
                $details['trend_status'] = 'declining';
            }
        } else {
            $details['trend_status'] = 'no_history';
            // Give partial credit if no history
            $score += 5;
        }

        return ['score' => min($score, self::RATINGS_MAX), 'details' => $details];
    }

    /**
     * Calculate trend compared to previous calculation
     */
    private function calculateTrend(App $app, int $userId, int $currentScore): array
    {
        // For now, we don't store historical ASO scores, so we estimate based on data trends
        // In a future iteration, we could store daily scores in a dedicated table

        // Calculate a simple trend indicator based on component trends
        $weeklyChange = 0;
        $indicators = [];

        // Check keyword rankings trend
        $weekAgo = Carbon::now()->subDays(7)->startOfDay();
        $positionImprovements = DB::table('app_rankings as r1')
            ->join('app_rankings as r2', function ($join) use ($app, $weekAgo) {
                $join->on('r1.keyword_id', '=', 'r2.keyword_id')
                    ->where('r1.app_id', $app->id)
                    ->where('r2.app_id', $app->id)
                    ->whereDate('r1.recorded_at', today())
                    ->whereDate('r2.recorded_at', $weekAgo);
            })
            ->whereRaw('r1.position > 0 AND r2.position > 0')
            ->selectRaw('AVG(r2.position - r1.position) as avg_improvement')
            ->value('avg_improvement');

        if ($positionImprovements !== null) {
            if ($positionImprovements > 2) {
                $weeklyChange += 3;
                $indicators[] = 'keywords_improving';
            } elseif ($positionImprovements < -2) {
                $weeklyChange -= 3;
                $indicators[] = 'keywords_declining';
            }
        }

        // Check rating trend
        $oldRating = AppRating::where('app_id', $app->id)
            ->whereDate('recorded_at', '<=', $weekAgo)
            ->orderBy('recorded_at', 'desc')
            ->first();

        if ($oldRating && $app->rating) {
            $ratingChange = $app->rating - $oldRating->rating;
            if ($ratingChange > 0.1) {
                $weeklyChange += 2;
                $indicators[] = 'rating_improving';
            } elseif ($ratingChange < -0.1) {
                $weeklyChange -= 2;
                $indicators[] = 'rating_declining';
            }
        }

        return [
            'change' => $weeklyChange,
            'period' => 'week',
            'direction' => $weeklyChange > 0 ? 'up' : ($weeklyChange < 0 ? 'down' : 'stable'),
            'indicators' => $indicators,
        ];
    }

    /**
     * Generate actionable recommendations
     */
    private function generateRecommendations(
        array $metadataScore,
        array $keywordsScore,
        array $reviewsScore,
        array $ratingsScore
    ): array {
        $recommendations = [];

        // Metadata recommendations
        if (isset($metadataScore['details']['title']['status']) && $metadataScore['details']['title']['status'] !== 'good') {
            $recommendations[] = [
                'category' => 'metadata',
                'action' => 'Optimize your app title to use more characters (target: 25-30)',
                'impact' => '+2-5 score',
                'priority' => 'medium',
            ];
        }

        if (isset($metadataScore['details']['description']['status']) && $metadataScore['details']['description']['status'] !== 'good') {
            $recommendations[] = [
                'category' => 'metadata',
                'action' => 'Expand your app description to 2000+ characters',
                'impact' => '+2-5 score',
                'priority' => 'medium',
            ];
        }

        if (isset($metadataScore['details']['screenshots']['status']) && $metadataScore['details']['screenshots']['status'] !== 'good') {
            $recommendations[] = [
                'category' => 'metadata',
                'action' => 'Add more screenshots (target: 5+)',
                'impact' => '+2-5 score',
                'priority' => 'high',
            ];
        }

        if (isset($metadataScore['details']['freshness']['status']) && $metadataScore['details']['freshness']['status'] !== 'good') {
            $recommendations[] = [
                'category' => 'metadata',
                'action' => 'Release an app update to improve freshness signals',
                'impact' => '+3-5 score',
                'priority' => 'medium',
            ];
        }

        if (isset($metadataScore['details']['category']['status']) && $metadataScore['details']['category']['status'] !== 'good') {
            $recommendations[] = [
                'category' => 'metadata',
                'action' => 'Ensure your app has a category assigned for better discoverability',
                'impact' => '+3 score',
                'priority' => 'medium',
            ];
        }

        // Keywords recommendations
        if (isset($keywordsScore['details']['tracking']['status']) && $keywordsScore['details']['tracking']['status'] !== 'good') {
            $recommendations[] = [
                'category' => 'keywords',
                'action' => 'Track more keywords (target: 20+)',
                'impact' => '+2-5 score',
                'priority' => 'high',
            ];
        }

        if (isset($keywordsScore['details']['top_10_status']) && $keywordsScore['details']['top_10_status'] !== 'good') {
            $recommendations[] = [
                'category' => 'keywords',
                'action' => 'Focus on improving rankings for keywords close to top 10',
                'impact' => '+4-10 score',
                'priority' => 'high',
            ];
        }

        if (isset($keywordsScore['details']['top_50_status']) && in_array($keywordsScore['details']['top_50_status'], ['needs_work', 'poor'])) {
            $recommendations[] = [
                'category' => 'keywords',
                'action' => 'Improve visibility: aim for 60%+ keywords in top 50',
                'impact' => '+3-5 score',
                'priority' => 'medium',
            ];
        }

        if (isset($keywordsScore['details']['trend_status']) && $keywordsScore['details']['trend_status'] === 'declining') {
            $recommendations[] = [
                'category' => 'keywords',
                'action' => 'Investigate declining keyword positions',
                'impact' => '+3-5 score',
                'priority' => 'high',
            ];
        }

        // Reviews recommendations
        if (isset($reviewsScore['details']['response_status']) && $reviewsScore['details']['response_status'] !== 'good') {
            $recommendations[] = [
                'category' => 'reviews',
                'action' => 'Respond to more user reviews (target: 50%+ response rate)',
                'impact' => '+4-10 score',
                'priority' => 'high',
            ];
        }

        if (isset($reviewsScore['details']['sentiment_status']) && in_array($reviewsScore['details']['sentiment_status'], ['needs_work', 'poor'])) {
            $recommendations[] = [
                'category' => 'reviews',
                'action' => 'Address negative feedback themes to improve sentiment',
                'impact' => '+4-10 score',
                'priority' => 'high',
            ];
        }

        if (isset($reviewsScore['details']['has_negative_spike']) && $reviewsScore['details']['has_negative_spike']) {
            $recommendations[] = [
                'category' => 'reviews',
                'action' => 'Investigate recent spike in negative reviews',
                'impact' => '+5 score',
                'priority' => 'critical',
            ];
        }

        // Ratings recommendations
        if (isset($ratingsScore['details']['rating_status']) && in_array($ratingsScore['details']['rating_status'], ['fair', 'needs_work', 'poor'])) {
            $recommendations[] = [
                'category' => 'ratings',
                'action' => 'Focus on improving your app rating (target: 4.5+)',
                'impact' => '+5-15 score',
                'priority' => 'high',
            ];
        }

        if (isset($ratingsScore['details']['trend_status']) && $ratingsScore['details']['trend_status'] === 'declining') {
            $recommendations[] = [
                'category' => 'ratings',
                'action' => 'Investigate causes of rating decline',
                'impact' => '+5-10 score',
                'priority' => 'critical',
            ];
        }

        // Sort by priority
        usort($recommendations, function ($a, $b) {
            $priorityOrder = ['critical' => 0, 'high' => 1, 'medium' => 2, 'low' => 3];
            return ($priorityOrder[$a['priority']] ?? 99) <=> ($priorityOrder[$b['priority']] ?? 99);
        });

        return array_slice($recommendations, 0, 5); // Return top 5 recommendations
    }
}
