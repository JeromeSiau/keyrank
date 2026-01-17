<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppFunnelAnalytics;
use App\Services\AppStoreConnectService;
use App\Services\GooglePlayDeveloperService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class FunnelController extends Controller
{
    public function __construct(
        private AppStoreConnectService $appStoreService,
        private GooglePlayDeveloperService $googlePlayService,
    ) {}

    /**
     * Get conversion funnel data for an app
     *
     * Returns impressions, page views, downloads with source attribution
     */
    public function index(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'period' => 'nullable|in:7d,30d,90d,ytd,all',
            'country' => 'nullable|string|max:2',
            'source' => 'nullable|string',
        ]);

        $period = $validated['period'] ?? '30d';
        $country = $validated['country'] ?? null;
        $source = $validated['source'] ?? null;

        // Get date range from period
        [$startDate, $endDate] = $this->getDateRange($period);

        // Try to get cached data first
        $cachedData = $this->getCachedFunnelData($app, $startDate, $endDate, $country, $source);

        if ($cachedData) {
            return response()->json(['data' => $cachedData]);
        }

        // If no cached data, return empty state
        return response()->json([
            'data' => $this->emptyFunnelResponse($period),
        ]);
    }

    /**
     * Get funnel data from cached database records
     */
    private function getCachedFunnelData(App $app, string $startDate, string $endDate, ?string $country, ?string $source): ?array
    {
        // Get summary totals
        $totalsQuery = AppFunnelAnalytics::where('app_id', $app->id)
            ->forDateRange($startDate, $endDate)
            ->totalsOnly()
            ->byCountry($country);

        $totals = $totalsQuery->aggregatedTotals()->first();

        if (!$totals || $totals->impressions == 0) {
            return null;
        }

        // Get by source breakdown
        $bySourceData = AppFunnelAnalytics::where('app_id', $app->id)
            ->forDateRange($startDate, $endDate)
            ->bySourceBreakdown()
            ->byCountry($country)
            ->aggregatedBySource()
            ->get();

        // Get trend data (daily)
        $trendData = AppFunnelAnalytics::where('app_id', $app->id)
            ->forDateRange($startDate, $endDate)
            ->totalsOnly()
            ->byCountry($country)
            ->aggregatedByDate()
            ->orderBy('date')
            ->get();

        // Get previous period data for comparison
        $previousStart = date('Y-m-d', strtotime($startDate) - (strtotime($endDate) - strtotime($startDate)));
        $previousEnd = date('Y-m-d', strtotime($startDate) - 1);

        $previousTotals = AppFunnelAnalytics::where('app_id', $app->id)
            ->forDateRange($previousStart, $previousEnd)
            ->totalsOnly()
            ->byCountry($country)
            ->aggregatedTotals()
            ->first();

        // Calculate rates
        $impressions = (int) $totals->impressions;
        $pageViews = (int) $totals->page_views;
        $downloads = (int) $totals->downloads;

        $impressionToPageViewRate = $impressions > 0 ? round(($pageViews / $impressions) * 100, 1) : 0;
        $pageViewToDownloadRate = $pageViews > 0 ? round(($downloads / $pageViews) * 100, 1) : 0;
        $overallConversionRate = $impressions > 0 ? round(($downloads / $impressions) * 100, 2) : 0;

        // Calculate comparison
        $comparison = $this->calculateComparison($totals, $previousTotals);

        // Category average (placeholder - would come from aggregated data)
        $categoryAverage = 2.9; // Default industry average

        return [
            'summary' => [
                'impressions' => $impressions,
                'page_views' => $pageViews,
                'downloads' => $downloads,
                'impression_to_page_view_rate' => $impressionToPageViewRate,
                'page_view_to_download_rate' => $pageViewToDownloadRate,
                'overall_conversion_rate' => $overallConversionRate,
                'category_average' => $categoryAverage,
                'vs_category' => $this->formatVsCategory($overallConversionRate, $categoryAverage),
            ],
            'by_source' => $bySourceData->map(function ($row) use ($impressions) {
                $sourceImpressions = (int) $row->impressions;
                $sourcePageViews = (int) $row->page_views;
                $sourceDownloads = (int) $row->downloads;
                $conversionRate = $sourceImpressions > 0
                    ? round(($sourceDownloads / $sourceImpressions) * 100, 2)
                    : 0;

                return [
                    'source' => $row->source,
                    'source_label' => AppFunnelAnalytics::sourceLabels()[$row->source] ?? ucfirst($row->source),
                    'impressions' => $sourceImpressions,
                    'page_views' => $sourcePageViews,
                    'downloads' => $sourceDownloads,
                    'conversion_rate' => $conversionRate,
                    'percentage_of_total' => $impressions > 0
                        ? round(($sourceImpressions / $impressions) * 100, 1)
                        : 0,
                ];
            })->values(),
            'trend' => $trendData->map(function ($row) {
                $impressions = (int) $row->impressions;
                $downloads = (int) $row->downloads;
                return [
                    'date' => $row->date,
                    'impressions' => $impressions,
                    'page_views' => (int) $row->page_views,
                    'downloads' => $downloads,
                    'conversion_rate' => $impressions > 0
                        ? round(($downloads / $impressions) * 100, 2)
                        : 0,
                ];
            })->values(),
            'comparison' => $comparison,
        ];
    }

    /**
     * Calculate comparison between current and previous period
     */
    private function calculateComparison($current, $previous): array
    {
        $currentImpressions = (int) ($current->impressions ?? 0);
        $currentPageViews = (int) ($current->page_views ?? 0);
        $currentDownloads = (int) ($current->downloads ?? 0);

        $previousImpressions = (int) ($previous->impressions ?? 0);
        $previousPageViews = (int) ($previous->page_views ?? 0);
        $previousDownloads = (int) ($previous->downloads ?? 0);

        $currentCvr = $currentImpressions > 0 ? ($currentDownloads / $currentImpressions) * 100 : 0;
        $previousCvr = $previousImpressions > 0 ? ($previousDownloads / $previousImpressions) * 100 : 0;

        return [
            'impressions_change' => $this->calculatePercentChange($currentImpressions, $previousImpressions),
            'page_views_change' => $this->calculatePercentChange($currentPageViews, $previousPageViews),
            'downloads_change' => $this->calculatePercentChange($currentDownloads, $previousDownloads),
            'conversion_rate_change' => round($currentCvr - $previousCvr, 2),
        ];
    }

    /**
     * Calculate percent change between two values
     */
    private function calculatePercentChange($current, $previous): ?float
    {
        if ($previous == 0) {
            return $current > 0 ? 100.0 : null;
        }
        return round((($current - $previous) / $previous) * 100, 1);
    }

    /**
     * Format vs category string
     */
    private function formatVsCategory(float $rate, float $categoryAvg): string
    {
        if ($categoryAvg == 0) {
            return 'N/A';
        }
        $diff = (($rate - $categoryAvg) / $categoryAvg) * 100;
        $sign = $diff >= 0 ? '+' : '';
        return $sign . round($diff) . '%';
    }

    /**
     * Get date range from period string
     */
    private function getDateRange(string $period): array
    {
        $endDate = now()->format('Y-m-d');

        $startDate = match ($period) {
            '7d' => now()->subDays(7)->format('Y-m-d'),
            '30d' => now()->subDays(30)->format('Y-m-d'),
            '90d' => now()->subDays(90)->format('Y-m-d'),
            'ytd' => now()->startOfYear()->format('Y-m-d'),
            'all' => '2020-01-01',
            default => now()->subDays(30)->format('Y-m-d'),
        };

        return [$startDate, $endDate];
    }

    /**
     * Return empty funnel response structure
     */
    private function emptyFunnelResponse(string $period): array
    {
        return [
            'summary' => [
                'impressions' => 0,
                'page_views' => 0,
                'downloads' => 0,
                'impression_to_page_view_rate' => 0,
                'page_view_to_download_rate' => 0,
                'overall_conversion_rate' => 0,
                'category_average' => null,
                'vs_category' => null,
            ],
            'by_source' => [],
            'trend' => [],
            'comparison' => [
                'impressions_change' => null,
                'page_views_change' => null,
                'downloads_change' => null,
                'conversion_rate_change' => null,
            ],
            'has_data' => false,
            'message' => 'No funnel data available. Data will be synced automatically.',
        ];
    }

    /**
     * Manually trigger funnel data sync for an app
     * This is useful for testing or when data needs immediate refresh
     */
    public function sync(Request $request, App $app): JsonResponse
    {
        $connection = $app->owner->storeConnections()
            ->where('platform', $app->platform)
            ->where('status', 'active')
            ->first();

        if (!$connection) {
            return response()->json([
                'success' => false,
                'message' => 'No active store connection found for this app.',
            ], 400);
        }

        // Get the last 30 days
        $startDate = now()->subDays(30)->format('Y-m-d');
        $endDate = now()->format('Y-m-d');

        try {
            if ($app->platform === 'ios') {
                $data = $this->appStoreService->getConversionFunnelData(
                    $connection,
                    $app->store_id,
                    $startDate,
                    $endDate
                );
            } else {
                $data = $this->googlePlayService->getConversionFunnelData(
                    $connection,
                    $app->store_id,
                    $startDate,
                    $endDate
                );
            }

            if ($data && !empty($data['totals']) && $data['totals']['impressions'] > 0) {
                // Store the data
                $this->storeFunnelData($app, $data);

                return response()->json([
                    'success' => true,
                    'message' => 'Funnel data synced successfully.',
                    'totals' => $data['totals'],
                ]);
            }

            return response()->json([
                'success' => false,
                'message' => 'No funnel data available from store API.',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to sync funnel data: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Store funnel data in the database
     */
    private function storeFunnelData(App $app, array $data): void
    {
        // Store daily totals
        foreach ($data['by_date'] as $dateData) {
            AppFunnelAnalytics::updateOrCreate(
                [
                    'app_id' => $app->id,
                    'date' => $dateData['date'],
                    'country_code' => 'WW',
                    'source' => AppFunnelAnalytics::SOURCE_TOTAL,
                ],
                [
                    'impressions' => $dateData['impressions'],
                    'impressions_unique' => $dateData['impressions_unique'] ?? $dateData['impressions'],
                    'page_views' => $dateData['page_views'],
                    'page_views_unique' => $dateData['page_views_unique'] ?? $dateData['page_views'],
                    'downloads' => $dateData['downloads'],
                    'first_time_downloads' => $dateData['first_time_downloads'] ?? $dateData['downloads'],
                    'redownloads' => $dateData['redownloads'] ?? 0,
                    'conversion_rate' => $dateData['impressions'] > 0
                        ? round(($dateData['downloads'] / $dateData['impressions']) * 100, 2)
                        : null,
                ]
            );
        }

        // Store by source (aggregated across dates)
        foreach ($data['by_source'] as $sourceData) {
            // We'll store the most recent date's source breakdown
            // In a more sophisticated implementation, we'd store daily source data
            $latestDate = array_key_last($data['by_date']);
            if (!$latestDate) {
                $latestDate = now()->format('Y-m-d');
            }

            AppFunnelAnalytics::updateOrCreate(
                [
                    'app_id' => $app->id,
                    'date' => $latestDate,
                    'country_code' => 'WW',
                    'source' => $sourceData['source'],
                ],
                [
                    'impressions' => $sourceData['impressions'],
                    'impressions_unique' => $sourceData['impressions_unique'] ?? $sourceData['impressions'],
                    'page_views' => $sourceData['page_views'],
                    'page_views_unique' => $sourceData['page_views_unique'] ?? $sourceData['page_views'],
                    'downloads' => $sourceData['downloads'],
                    'first_time_downloads' => $sourceData['first_time_downloads'] ?? $sourceData['downloads'],
                    'redownloads' => $sourceData['redownloads'] ?? 0,
                    'conversion_rate' => $sourceData['impressions'] > 0
                        ? round(($sourceData['downloads'] / $sourceData['impressions']) * 100, 2)
                        : null,
                ]
            );
        }
    }
}
