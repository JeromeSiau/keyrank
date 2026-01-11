<?php

namespace App\Services;

use App\Models\App;
use App\Models\AppAnalyticsSummary;
use App\Models\AppRanking;
use App\Models\AppReview;
use App\Models\TrackedKeyword;
use Illuminate\Support\Collection;

class ContextBuilderService
{
    private const MAX_REVIEWS = 50;
    private const MAX_KEYWORDS = 30;
    private const REVIEW_DAYS = 30;

    /**
     * Build context for the LLM based on the app and required data sources.
     */
    public function build(App $app, array $dataSources, int $userId): array
    {
        $context = [
            'app_info' => $this->buildAppInfo($app),
            'data' => [],
        ];

        foreach ($dataSources as $source) {
            $context['data'][$source] = match ($source) {
                'reviews' => $this->buildReviewsContext($app),
                'rankings' => $this->buildRankingsContext($app, $userId),
                'analytics' => $this->buildAnalyticsContext($app),
                'competitors' => $this->buildCompetitorsContext($app, $userId),
                'app_info' => [], // Already included in app_info
                default => [],
            };
        }

        return $context;
    }

    /**
     * Format context into a string for the LLM prompt.
     */
    public function formatForPrompt(array $context): string
    {
        $parts = [];

        // App info section
        $appInfo = $context['app_info'];
        $parts[] = "## App Information";
        $parts[] = "- Name: {$appInfo['name']}";
        $parts[] = "- Platform: {$appInfo['platform']}";
        $parts[] = "- Rating: {$appInfo['rating']}/5 ({$appInfo['rating_count']} ratings)";
        $parts[] = "- Category: {$appInfo['category']}";
        $parts[] = "";

        // Data sections
        foreach ($context['data'] as $source => $data) {
            if (empty($data)) {
                continue;
            }

            $parts[] = match ($source) {
                'reviews' => $this->formatReviewsSection($data),
                'rankings' => $this->formatRankingsSection($data),
                'analytics' => $this->formatAnalyticsSection($data),
                'competitors' => $this->formatCompetitorsSection($data),
                default => '',
            };
        }

        return implode("\n", array_filter($parts));
    }

    private function buildAppInfo(App $app): array
    {
        return [
            'name' => $app->name,
            'platform' => $app->platform,
            'rating' => $app->rating ?? 'N/A',
            'rating_count' => $app->rating_count ?? 0,
            'category' => $app->category_id ? ($app->category->name ?? 'Unknown') : 'Unknown',
            'version' => $app->version ?? 'Unknown',
            'developer' => $app->developer ?? 'Unknown',
        ];
    }

    private function buildReviewsContext(App $app): array
    {
        $reviews = AppReview::where('app_id', $app->id)
            ->where('reviewed_at', '>=', now()->subDays(self::REVIEW_DAYS))
            ->orderByDesc('reviewed_at')
            ->limit(self::MAX_REVIEWS)
            ->get();

        if ($reviews->isEmpty()) {
            return [];
        }

        // Calculate rating distribution
        $distribution = $reviews->groupBy('rating')->map->count();

        // Group by sentiment if available
        $sentimentGroups = $reviews->groupBy('sentiment');

        // Get sample reviews for each rating
        $sampleReviews = [];
        foreach ([1, 2, 3, 4, 5] as $rating) {
            $sample = $reviews->where('rating', $rating)->take(3);
            if ($sample->isNotEmpty()) {
                $sampleReviews[$rating] = $sample->map(fn($r) => [
                    'title' => $r->title,
                    'content' => mb_substr($r->content, 0, 300),
                    'date' => $r->reviewed_at->format('Y-m-d'),
                ])->values()->toArray();
            }
        }

        return [
            'total_count' => $reviews->count(),
            'period_days' => self::REVIEW_DAYS,
            'average_rating' => round($reviews->avg('rating'), 1),
            'distribution' => $distribution->toArray(),
            'sentiment_counts' => $sentimentGroups->map->count()->toArray(),
            'samples' => $sampleReviews,
        ];
    }

    private function buildRankingsContext(App $app, int $userId): array
    {
        // Get tracked keywords for this app and user
        $trackedKeywords = TrackedKeyword::where('app_id', $app->id)
            ->where('user_id', $userId)
            ->with('keyword')
            ->get();

        if ($trackedKeywords->isEmpty()) {
            return [];
        }

        $keywordIds = $trackedKeywords->pluck('keyword_id');

        // Get latest rankings
        $latestRankings = AppRanking::where('app_id', $app->id)
            ->whereIn('keyword_id', $keywordIds)
            ->where('recorded_at', '>=', now()->subDays(7))
            ->orderByDesc('recorded_at')
            ->get()
            ->groupBy('keyword_id');

        $keywordData = [];
        foreach ($trackedKeywords as $tracked) {
            $rankings = $latestRankings->get($tracked->keyword_id, collect());
            $latest = $rankings->first();
            $previous = $rankings->skip(1)->first();

            $keywordData[] = [
                'keyword' => $tracked->keyword->text ?? 'Unknown',
                'current_position' => $latest?->position,
                'previous_position' => $previous?->position,
                'change' => $latest && $previous ? $previous->position - $latest->position : null,
                'difficulty' => $tracked->difficulty,
                'popularity' => $tracked->keyword->popularity ?? null,
            ];
        }

        // Sort by position (ranked keywords first)
        usort($keywordData, fn($a, $b) => ($a['current_position'] ?? 999) <=> ($b['current_position'] ?? 999));

        return [
            'total_keywords' => count($keywordData),
            'ranked_keywords' => count(array_filter($keywordData, fn($k) => $k['current_position'] !== null)),
            'keywords' => array_slice($keywordData, 0, self::MAX_KEYWORDS),
        ];
    }

    private function buildAnalyticsContext(App $app): array
    {
        $summary = AppAnalyticsSummary::where('app_id', $app->id)
            ->where('period', '30d')
            ->first();

        if (!$summary) {
            return [];
        }

        return [
            'period' => '30 days',
            'downloads' => $summary->total_downloads,
            'revenue' => $summary->total_revenue,
            'proceeds' => $summary->total_proceeds,
            'active_subscribers' => $summary->active_subscribers,
            'downloads_change' => $summary->downloads_change_pct,
            'revenue_change' => $summary->revenue_change_pct,
            'subscribers_change' => $summary->subscribers_change_pct,
        ];
    }

    private function buildCompetitorsContext(App $app, int $userId): array
    {
        // Get tracked keywords with competitor data
        $trackedKeywords = TrackedKeyword::where('app_id', $app->id)
            ->where('user_id', $userId)
            ->whereNotNull('top_competitors')
            ->with('keyword')
            ->limit(10)
            ->get();

        if ($trackedKeywords->isEmpty()) {
            return [];
        }

        $competitorData = [];
        foreach ($trackedKeywords as $tracked) {
            if (!empty($tracked->top_competitors)) {
                $competitorData[] = [
                    'keyword' => $tracked->keyword->text ?? 'Unknown',
                    'competitors' => array_slice($tracked->top_competitors, 0, 5),
                ];
            }
        }

        return [
            'keywords_analyzed' => count($competitorData),
            'keyword_competitors' => $competitorData,
        ];
    }

    private function formatReviewsSection(array $data): string
    {
        $lines = ["## Recent Reviews (last {$data['period_days']} days)"];
        $lines[] = "- Total reviews: {$data['total_count']}";
        $lines[] = "- Average rating: {$data['average_rating']}/5";
        $lines[] = "";
        $lines[] = "Rating distribution:";
        for ($i = 5; $i >= 1; $i--) {
            $count = $data['distribution'][$i] ?? 0;
            $lines[] = "- {$i} stars: {$count}";
        }

        if (!empty($data['samples'])) {
            $lines[] = "";
            $lines[] = "Sample reviews:";
            foreach ($data['samples'] as $rating => $reviews) {
                foreach ($reviews as $review) {
                    $title = $review['title'] ? "\"{$review['title']}\"" : '(no title)';
                    $lines[] = "- [{$rating}★] {$title}: {$review['content']}";
                }
            }
        }

        return implode("\n", $lines);
    }

    private function formatRankingsSection(array $data): string
    {
        $lines = ["## Keyword Rankings"];
        $lines[] = "- Total tracked: {$data['total_keywords']}";
        $lines[] = "- Currently ranked: {$data['ranked_keywords']}";
        $lines[] = "";
        $lines[] = "Top keywords:";

        foreach ($data['keywords'] as $kw) {
            $pos = $kw['current_position'] ?? 'Not ranked';
            $change = '';
            if ($kw['change'] !== null) {
                $change = $kw['change'] > 0 ? " (↑{$kw['change']})" : ($kw['change'] < 0 ? " (↓" . abs($kw['change']) . ")" : " (→)");
            }
            $lines[] = "- \"{$kw['keyword']}\": #{$pos}{$change}";
        }

        return implode("\n", $lines);
    }

    private function formatAnalyticsSection(array $data): string
    {
        $lines = ["## Analytics (last {$data['period']})"];

        if ($data['downloads'] !== null) {
            $change = $data['downloads_change'] !== null ? " ({$data['downloads_change']}%)" : '';
            $lines[] = "- Downloads: " . number_format($data['downloads']) . $change;
        }

        if ($data['revenue'] !== null && $data['revenue'] > 0) {
            $change = $data['revenue_change'] !== null ? " ({$data['revenue_change']}%)" : '';
            $lines[] = "- Revenue: $" . number_format($data['revenue'], 2) . $change;
        }

        if ($data['proceeds'] !== null && $data['proceeds'] > 0) {
            $lines[] = "- Proceeds: $" . number_format($data['proceeds'], 2);
        }

        if ($data['active_subscribers'] !== null && $data['active_subscribers'] > 0) {
            $change = $data['subscribers_change'] !== null ? " ({$data['subscribers_change']}%)" : '';
            $lines[] = "- Active subscribers: " . number_format($data['active_subscribers']) . $change;
        }

        return implode("\n", $lines);
    }

    private function formatCompetitorsSection(array $data): string
    {
        $lines = ["## Competitor Analysis"];
        $lines[] = "Keywords analyzed: {$data['keywords_analyzed']}";
        $lines[] = "";

        foreach ($data['keyword_competitors'] as $item) {
            $lines[] = "For \"{$item['keyword']}\":";
            foreach ($item['competitors'] as $i => $competitor) {
                $pos = $i + 1;
                $name = is_array($competitor) ? ($competitor['name'] ?? 'Unknown') : $competitor;
                $lines[] = "  {$pos}. {$name}";
            }
        }

        return implode("\n", $lines);
    }
}
