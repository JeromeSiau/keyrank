<?php

namespace App\Services;

use App\Models\App;
use App\Models\AppRanking;
use App\Models\AppRating;
use App\Models\AppReview;
use Carbon\Carbon;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class AnomalyDetectionService
{
    /**
     * Z-score threshold for detecting anomalies
     * Values above this are considered significant
     */
    private const Z_SCORE_THRESHOLD = 2.0;

    /**
     * Minimum data points needed for reliable z-score calculation
     */
    private const MIN_DATA_POINTS = 7;

    /**
     * Detect all anomalies for an app
     */
    public function detectAnomalies(App $app, int $lookbackDays = 30): array
    {
        $anomalies = [];

        // Ranking anomalies
        $rankingAnomalies = $this->detectRankingAnomalies($app, $lookbackDays);
        $anomalies = array_merge($anomalies, $rankingAnomalies);

        // Rating anomalies
        $ratingAnomalies = $this->detectRatingAnomalies($app, $lookbackDays);
        $anomalies = array_merge($anomalies, $ratingAnomalies);

        // Review volume anomalies
        $reviewAnomalies = $this->detectReviewVolumeAnomalies($app, $lookbackDays);
        $anomalies = array_merge($anomalies, $reviewAnomalies);

        // Sentiment anomalies
        $sentimentAnomalies = $this->detectSentimentAnomalies($app, $lookbackDays);
        $anomalies = array_merge($anomalies, $sentimentAnomalies);

        return $anomalies;
    }

    /**
     * Detect ranking anomalies (sudden position changes)
     */
    public function detectRankingAnomalies(App $app, int $lookbackDays = 30): array
    {
        $anomalies = [];
        $endDate = Carbon::now();
        $startDate = $endDate->copy()->subDays($lookbackDays);

        // Get daily ranking data per keyword
        $rankings = AppRanking::where('app_id', $app->id)
            ->whereBetween('recorded_at', [$startDate, $endDate])
            ->whereNotNull('position')
            ->select('keyword_id', DB::raw('DATE(recorded_at) as date'), DB::raw('AVG(position) as avg_position'))
            ->groupBy('keyword_id', DB::raw('DATE(recorded_at)'))
            ->orderBy('keyword_id')
            ->orderBy('date')
            ->get();

        // Group by keyword and calculate anomalies
        $byKeyword = $rankings->groupBy('keyword_id');

        foreach ($byKeyword as $keywordId => $keywordRankings) {
            if ($keywordRankings->count() < self::MIN_DATA_POINTS) {
                continue;
            }

            $positions = $keywordRankings->pluck('avg_position')->toArray();
            $dailyChanges = $this->calculateDailyChanges($positions);

            if (count($dailyChanges) < self::MIN_DATA_POINTS) {
                continue;
            }

            $latestChange = end($dailyChanges);
            $zScore = $this->calculateZScore($latestChange, $dailyChanges);

            if (abs($zScore) >= self::Z_SCORE_THRESHOLD) {
                $keyword = \App\Models\Keyword::find($keywordId);
                $isImprovement = $latestChange < 0; // Lower position is better

                $anomalies[] = [
                    'type' => $isImprovement ? 'ranking_improvement' : 'ranking_decline',
                    'severity' => $this->getSeverityFromZScore(abs($zScore)),
                    'entity_type' => 'keyword',
                    'entity_id' => $keywordId,
                    'entity_name' => $keyword?->term ?? 'Unknown',
                    'value' => round($latestChange, 1),
                    'z_score' => round($zScore, 2),
                    'description' => $isImprovement
                        ? "Keyword \"{$keyword?->term}\" improved by " . abs(round($latestChange)) . " positions"
                        : "Keyword \"{$keyword?->term}\" dropped by " . abs(round($latestChange)) . " positions",
                    'detected_at' => now()->toIso8601String(),
                ];
            }
        }

        return $anomalies;
    }

    /**
     * Detect rating anomalies (sudden rating changes)
     */
    public function detectRatingAnomalies(App $app, int $lookbackDays = 30): array
    {
        $anomalies = [];
        $endDate = Carbon::now();
        $startDate = $endDate->copy()->subDays($lookbackDays);

        // Get daily average ratings
        $ratings = AppRating::where('app_id', $app->id)
            ->whereBetween('recorded_at', [$startDate, $endDate])
            ->select(DB::raw('DATE(recorded_at) as date'), DB::raw('AVG(average_rating) as avg_rating'))
            ->groupBy(DB::raw('DATE(recorded_at)'))
            ->orderBy('date')
            ->get();

        if ($ratings->count() < self::MIN_DATA_POINTS) {
            return [];
        }

        $ratingValues = $ratings->pluck('avg_rating')->toArray();
        $dailyChanges = $this->calculateDailyChanges($ratingValues);

        if (count($dailyChanges) < self::MIN_DATA_POINTS) {
            return [];
        }

        $latestChange = end($dailyChanges);
        $zScore = $this->calculateZScore($latestChange, $dailyChanges);

        if (abs($zScore) >= self::Z_SCORE_THRESHOLD) {
            $isPositive = $latestChange > 0;

            $anomalies[] = [
                'type' => $isPositive ? 'rating_increase' : 'rating_decrease',
                'severity' => $this->getSeverityFromZScore(abs($zScore)),
                'entity_type' => 'app',
                'entity_id' => $app->id,
                'entity_name' => $app->name,
                'value' => round($latestChange, 2),
                'z_score' => round($zScore, 2),
                'description' => $isPositive
                    ? "Rating increased by " . abs(round($latestChange, 2)) . " points"
                    : "Rating decreased by " . abs(round($latestChange, 2)) . " points",
                'detected_at' => now()->toIso8601String(),
            ];
        }

        return $anomalies;
    }

    /**
     * Detect review volume anomalies (unusual review counts)
     */
    public function detectReviewVolumeAnomalies(App $app, int $lookbackDays = 30): array
    {
        $anomalies = [];
        $endDate = Carbon::now();
        $startDate = $endDate->copy()->subDays($lookbackDays);

        // Get daily review counts
        $reviewCounts = AppReview::where('app_id', $app->id)
            ->whereBetween('reviewed_at', [$startDate, $endDate])
            ->select(DB::raw('DATE(reviewed_at) as date'), DB::raw('COUNT(*) as count'))
            ->groupBy(DB::raw('DATE(reviewed_at)'))
            ->orderBy('date')
            ->get();

        if ($reviewCounts->count() < self::MIN_DATA_POINTS) {
            return [];
        }

        $counts = $reviewCounts->pluck('count')->toArray();
        $latestCount = end($counts);
        $zScore = $this->calculateZScore($latestCount, $counts);

        if (abs($zScore) >= self::Z_SCORE_THRESHOLD) {
            $isSpike = $latestCount > array_sum($counts) / count($counts);

            $anomalies[] = [
                'type' => $isSpike ? 'review_spike' : 'review_drought',
                'severity' => $this->getSeverityFromZScore(abs($zScore)),
                'entity_type' => 'app',
                'entity_id' => $app->id,
                'entity_name' => $app->name,
                'value' => $latestCount,
                'z_score' => round($zScore, 2),
                'description' => $isSpike
                    ? "Unusual spike in reviews: {$latestCount} reviews received"
                    : "Unusual drop in review volume: only {$latestCount} reviews received",
                'detected_at' => now()->toIso8601String(),
            ];
        }

        return $anomalies;
    }

    /**
     * Detect sentiment anomalies (sudden sentiment shifts)
     */
    public function detectSentimentAnomalies(App $app, int $lookbackDays = 30): array
    {
        $anomalies = [];
        $endDate = Carbon::now();
        $startDate = $endDate->copy()->subDays($lookbackDays);

        // Get daily sentiment scores (average sentiment_score for enriched reviews)
        $sentiments = AppReview::where('app_id', $app->id)
            ->whereBetween('reviewed_at', [$startDate, $endDate])
            ->whereNotNull('sentiment_score')
            ->select(DB::raw('DATE(reviewed_at) as date'), DB::raw('AVG(sentiment_score) as avg_sentiment'))
            ->groupBy(DB::raw('DATE(reviewed_at)'))
            ->orderBy('date')
            ->get();

        if ($sentiments->count() < self::MIN_DATA_POINTS) {
            return [];
        }

        $scores = $sentiments->pluck('avg_sentiment')->toArray();
        $dailyChanges = $this->calculateDailyChanges($scores);

        if (count($dailyChanges) < self::MIN_DATA_POINTS) {
            return [];
        }

        $latestChange = end($dailyChanges);
        $zScore = $this->calculateZScore($latestChange, $dailyChanges);

        if (abs($zScore) >= self::Z_SCORE_THRESHOLD) {
            $isPositive = $latestChange > 0;

            $anomalies[] = [
                'type' => $isPositive ? 'sentiment_improvement' : 'sentiment_decline',
                'severity' => $this->getSeverityFromZScore(abs($zScore)),
                'entity_type' => 'app',
                'entity_id' => $app->id,
                'entity_name' => $app->name,
                'value' => round($latestChange, 2),
                'z_score' => round($zScore, 2),
                'description' => $isPositive
                    ? "User sentiment has significantly improved"
                    : "User sentiment has significantly declined",
                'detected_at' => now()->toIso8601String(),
            ];
        }

        return $anomalies;
    }

    /**
     * Calculate z-score for a value against a dataset
     */
    private function calculateZScore(float $value, array $data): float
    {
        if (count($data) < 2) {
            return 0.0;
        }

        $mean = array_sum($data) / count($data);
        $variance = array_sum(array_map(fn($x) => pow($x - $mean, 2), $data)) / count($data);
        $stdDev = sqrt($variance);

        if ($stdDev == 0) {
            return 0.0;
        }

        return ($value - $mean) / $stdDev;
    }

    /**
     * Calculate daily changes from a series of values
     */
    private function calculateDailyChanges(array $values): array
    {
        $changes = [];
        for ($i = 1; $i < count($values); $i++) {
            $changes[] = $values[$i] - $values[$i - 1];
        }
        return $changes;
    }

    /**
     * Get severity level from z-score
     */
    private function getSeverityFromZScore(float $absZScore): string
    {
        if ($absZScore >= 3.0) {
            return 'high';
        }
        if ($absZScore >= 2.5) {
            return 'medium';
        }
        return 'low';
    }
}
