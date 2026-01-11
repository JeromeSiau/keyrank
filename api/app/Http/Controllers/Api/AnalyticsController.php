<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppAnalytics;
use App\Models\AppAnalyticsSummary;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;

class AnalyticsController extends Controller
{
    /**
     * Get analytics summary for an app
     */
    public function index(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'period' => 'nullable|in:7d,30d,90d,ytd,all',
        ]);

        $period = $validated['period'] ?? '30d';

        $summary = $app->getAnalyticsSummary($period);

        if (!$summary) {
            return response()->json([
                'data' => [
                    'period' => $period,
                    'total_downloads' => 0,
                    'total_revenue' => 0,
                    'total_proceeds' => 0,
                    'active_subscribers' => 0,
                    'downloads_change_pct' => null,
                    'revenue_change_pct' => null,
                    'subscribers_change_pct' => null,
                    'computed_at' => null,
                    'has_data' => false,
                ],
            ]);
        }

        return response()->json([
            'data' => [
                'period' => $summary->period,
                'total_downloads' => $summary->total_downloads,
                'total_revenue' => $summary->total_revenue,
                'total_proceeds' => $summary->total_proceeds,
                'active_subscribers' => $summary->active_subscribers,
                'downloads_change_pct' => $summary->downloads_change_pct,
                'revenue_change_pct' => $summary->revenue_change_pct,
                'subscribers_change_pct' => $summary->subscribers_change_pct,
                'computed_at' => $summary->computed_at,
                'has_data' => true,
            ],
        ]);
    }

    /**
     * Get downloads over time
     */
    public function downloads(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'period' => 'nullable|in:7d,30d,90d,ytd,all',
        ]);

        $period = $validated['period'] ?? '30d';

        $data = AppAnalytics::where('app_id', $app->id)
            ->forPeriod($period)
            ->aggregatedByDate()
            ->orderBy('date')
            ->get();

        // Get previous period data for comparison line
        $previousData = $this->getPreviousPeriodData($app, $period, 'downloads');

        return response()->json([
            'data' => [
                'current' => $data->map(fn($row) => [
                    'date' => $row->date,
                    'downloads' => (int) $row->downloads,
                ]),
                'previous' => $previousData,
            ],
        ]);
    }

    /**
     * Get revenue over time
     */
    public function revenue(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'period' => 'nullable|in:7d,30d,90d,ytd,all',
        ]);

        $period = $validated['period'] ?? '30d';

        $data = AppAnalytics::where('app_id', $app->id)
            ->forPeriod($period)
            ->aggregatedByDate()
            ->orderBy('date')
            ->get();

        $previousData = $this->getPreviousPeriodData($app, $period, 'revenue');

        return response()->json([
            'data' => [
                'current' => $data->map(fn($row) => [
                    'date' => $row->date,
                    'revenue' => (float) $row->revenue,
                    'proceeds' => (float) $row->proceeds,
                ]),
                'previous' => $previousData,
            ],
        ]);
    }

    /**
     * Get subscriber metrics over time
     */
    public function subscribers(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'period' => 'nullable|in:7d,30d,90d,ytd,all',
        ]);

        $period = $validated['period'] ?? '30d';

        $data = AppAnalytics::where('app_id', $app->id)
            ->forPeriod($period)
            ->aggregatedByDate()
            ->orderBy('date')
            ->get();

        return response()->json([
            'data' => $data->map(fn($row) => [
                'date' => $row->date,
                'subscribers_new' => (int) $row->subscribers_new,
                'subscribers_cancelled' => (int) $row->subscribers_cancelled,
                'subscribers_active' => (int) $row->subscribers_active,
            ]),
        ]);
    }

    /**
     * Get breakdown by country
     */
    public function countries(Request $request, App $app): JsonResponse
    {
        $validated = $request->validate([
            'period' => 'nullable|in:7d,30d,90d,ytd,all',
            'limit' => 'nullable|integer|min:1|max:50',
        ]);

        $period = $validated['period'] ?? '30d';
        $limit = $validated['limit'] ?? 10;

        $data = AppAnalytics::where('app_id', $app->id)
            ->forPeriod($period)
            ->aggregatedByCountry()
            ->orderByDesc('downloads')
            ->limit($limit)
            ->get();

        return response()->json([
            'data' => $data->map(fn($row) => [
                'country_code' => $row->country_code,
                'downloads' => (int) $row->downloads,
                'revenue' => (float) $row->revenue,
                'proceeds' => (float) $row->proceeds,
            ]),
        ]);
    }

    /**
     * Export analytics data as CSV
     */
    public function export(Request $request, App $app): Response
    {
        $validated = $request->validate([
            'period' => 'nullable|in:7d,30d,90d,ytd,all',
        ]);

        $period = $validated['period'] ?? '30d';

        $data = AppAnalytics::where('app_id', $app->id)
            ->forPeriod($period)
            ->orderBy('date')
            ->orderBy('country_code')
            ->get();

        $csv = "Date,Country,Downloads,Updates,Revenue,Proceeds,Refunds,New Subscribers,Cancelled,Active Subscribers\n";

        foreach ($data as $row) {
            $csv .= implode(',', [
                $row->date->toDateString(),
                $row->country_code,
                $row->downloads,
                $row->updates,
                $row->revenue,
                $row->proceeds,
                $row->refunds,
                $row->subscribers_new,
                $row->subscribers_cancelled,
                $row->subscribers_active,
            ]) . "\n";
        }

        $filename = "{$app->name}_analytics_{$period}_" . now()->format('Y-m-d') . '.csv';

        return response($csv, 200, [
            'Content-Type' => 'text/csv',
            'Content-Disposition' => "attachment; filename=\"{$filename}\"",
        ]);
    }

    /**
     * Get previous period data for comparison
     */
    private function getPreviousPeriodData(App $app, string $period, string $metric): array
    {
        $periodDays = match ($period) {
            '7d' => 7,
            '30d' => 30,
            '90d' => 90,
            'ytd' => now()->dayOfYear,
            'all' => null,
            default => 30,
        };

        if ($periodDays === null) {
            return [];
        }

        $startDate = now()->subDays($periodDays * 2);
        $endDate = now()->subDays($periodDays);

        $data = AppAnalytics::where('app_id', $app->id)
            ->whereBetween('date', [$startDate, $endDate])
            ->aggregatedByDate()
            ->orderBy('date')
            ->get();

        return $data->map(fn($row) => [
            'date' => $row->date,
            $metric => $metric === 'downloads' ? (int) $row->downloads : (float) $row->revenue,
        ])->toArray();
    }
}
