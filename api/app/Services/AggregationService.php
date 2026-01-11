<?php

namespace App\Services;

use App\Models\AppRanking;
use App\Models\AppRankingAggregate;
use App\Models\KeywordPopularityAggregate;
use App\Models\KeywordPopularityHistory;
use Illuminate\Support\Facades\DB;

class AggregationService
{
    /**
     * Aggregate daily rankings older than $days into weekly aggregates.
     */
    public function aggregateDailyToWeekly(int $days): array
    {
        $cutoff = now()->subDays($days);
        $stats = ['rankings' => 0, 'popularity' => 0];

        $driver = DB::connection()->getDriverName();

        // Aggregate rankings
        if ($driver === 'sqlite') {
            $rankings = AppRanking::where('recorded_at', '<', $cutoff)
                ->select([
                    'app_id',
                    'keyword_id',
                    DB::raw("strftime('%Y-%W', recorded_at) as year_week"),
                    DB::raw("date(recorded_at, 'weekday 0', '-6 days') as period_start"),
                    DB::raw('AVG(position) as avg_position'),
                    DB::raw('MIN(position) as min_position'),
                    DB::raw('MAX(position) as max_position'),
                    DB::raw('COUNT(*) as data_points'),
                ])
                ->groupBy('app_id', 'keyword_id', DB::raw("strftime('%Y-%W', recorded_at)"))
                ->get();
        } else {
            $rankings = AppRanking::where('recorded_at', '<', $cutoff)
                ->select([
                    'app_id',
                    'keyword_id',
                    DB::raw('YEARWEEK(recorded_at, 1) as year_week'),
                    DB::raw('MIN(DATE(recorded_at) - INTERVAL WEEKDAY(recorded_at) DAY) as period_start'),
                    DB::raw('AVG(position) as avg_position'),
                    DB::raw('MIN(position) as min_position'),
                    DB::raw('MAX(position) as max_position'),
                    DB::raw('COUNT(*) as data_points'),
                ])
                ->groupBy('app_id', 'keyword_id', DB::raw('YEARWEEK(recorded_at, 1)'))
                ->get();
        }

        foreach ($rankings as $row) {
            AppRankingAggregate::updateOrCreate(
                [
                    'app_id' => $row->app_id,
                    'keyword_id' => $row->keyword_id,
                    'period_type' => 'weekly',
                    'period_start' => $row->period_start,
                ],
                [
                    'avg_position' => round($row->avg_position, 2),
                    'min_position' => $row->min_position,
                    'max_position' => $row->max_position,
                    'data_points' => $row->data_points,
                ]
            );
            $stats['rankings']++;
        }

        // Delete aggregated daily rankings
        AppRanking::where('recorded_at', '<', $cutoff)->delete();

        // Aggregate popularity
        if ($driver === 'sqlite') {
            $popularity = KeywordPopularityHistory::where('recorded_at', '<', $cutoff)
                ->select([
                    'keyword_id',
                    DB::raw("strftime('%Y-%W', recorded_at) as year_week"),
                    DB::raw("date(recorded_at, 'weekday 0', '-6 days') as period_start"),
                    DB::raw('AVG(popularity) as avg_popularity'),
                    DB::raw('MIN(popularity) as min_popularity'),
                    DB::raw('MAX(popularity) as max_popularity'),
                    DB::raw('COUNT(*) as data_points'),
                ])
                ->groupBy('keyword_id', DB::raw("strftime('%Y-%W', recorded_at)"))
                ->get();
        } else {
            $popularity = KeywordPopularityHistory::where('recorded_at', '<', $cutoff)
                ->select([
                    'keyword_id',
                    DB::raw('YEARWEEK(recorded_at, 1) as year_week'),
                    DB::raw('MIN(DATE(recorded_at) - INTERVAL WEEKDAY(recorded_at) DAY) as period_start'),
                    DB::raw('AVG(popularity) as avg_popularity'),
                    DB::raw('MIN(popularity) as min_popularity'),
                    DB::raw('MAX(popularity) as max_popularity'),
                    DB::raw('COUNT(*) as data_points'),
                ])
                ->groupBy('keyword_id', DB::raw('YEARWEEK(recorded_at, 1)'))
                ->get();
        }

        foreach ($popularity as $row) {
            KeywordPopularityAggregate::updateOrCreate(
                [
                    'keyword_id' => $row->keyword_id,
                    'period_type' => 'weekly',
                    'period_start' => $row->period_start,
                ],
                [
                    'avg_popularity' => round($row->avg_popularity, 2),
                    'min_popularity' => $row->min_popularity,
                    'max_popularity' => $row->max_popularity,
                    'data_points' => $row->data_points,
                ]
            );
            $stats['popularity']++;
        }

        // Delete aggregated daily popularity
        KeywordPopularityHistory::where('recorded_at', '<', $cutoff)->delete();

        return $stats;
    }

    /**
     * Aggregate weekly aggregates older than $days into monthly aggregates.
     */
    public function aggregateWeeklyToMonthly(int $days): array
    {
        $cutoff = now()->subDays($days);
        $stats = ['rankings' => 0, 'popularity' => 0];

        $driver = DB::connection()->getDriverName();

        // Aggregate rankings
        if ($driver === 'sqlite') {
            $rankings = AppRankingAggregate::where('period_type', 'weekly')
                ->where('period_start', '<', $cutoff)
                ->select([
                    'app_id',
                    'keyword_id',
                    DB::raw("strftime('%Y-%m-01', period_start) as month_start"),
                    DB::raw('CAST(SUM(avg_position * data_points) AS REAL) / CAST(SUM(data_points) AS REAL) as avg_position'),
                    DB::raw('MIN(min_position) as min_position'),
                    DB::raw('MAX(max_position) as max_position'),
                    DB::raw('SUM(data_points) as data_points'),
                ])
                ->groupBy('app_id', 'keyword_id', DB::raw("strftime('%Y-%m-01', period_start)"))
                ->get();
        } else {
            $rankings = AppRankingAggregate::where('period_type', 'weekly')
                ->where('period_start', '<', $cutoff)
                ->select([
                    'app_id',
                    'keyword_id',
                    DB::raw('DATE_FORMAT(period_start, "%Y-%m-01") as month_start'),
                    DB::raw('SUM(avg_position * data_points) / SUM(data_points) as avg_position'),
                    DB::raw('MIN(min_position) as min_position'),
                    DB::raw('MAX(max_position) as max_position'),
                    DB::raw('SUM(data_points) as data_points'),
                ])
                ->groupBy('app_id', 'keyword_id', DB::raw('DATE_FORMAT(period_start, "%Y-%m-01")'))
                ->get();
        }

        foreach ($rankings as $row) {
            AppRankingAggregate::updateOrCreate(
                [
                    'app_id' => $row->app_id,
                    'keyword_id' => $row->keyword_id,
                    'period_type' => 'monthly',
                    'period_start' => $row->month_start,
                ],
                [
                    'avg_position' => round($row->avg_position, 2),
                    'min_position' => $row->min_position,
                    'max_position' => $row->max_position,
                    'data_points' => $row->data_points,
                ]
            );
            $stats['rankings']++;
        }

        // Delete aggregated weekly rankings
        AppRankingAggregate::where('period_type', 'weekly')
            ->where('period_start', '<', $cutoff)
            ->delete();

        // Aggregate popularity
        if ($driver === 'sqlite') {
            $popularity = KeywordPopularityAggregate::where('period_type', 'weekly')
                ->where('period_start', '<', $cutoff)
                ->select([
                    'keyword_id',
                    DB::raw("strftime('%Y-%m-01', period_start) as month_start"),
                    DB::raw('CAST(SUM(avg_popularity * data_points) AS REAL) / CAST(SUM(data_points) AS REAL) as avg_popularity'),
                    DB::raw('MIN(min_popularity) as min_popularity'),
                    DB::raw('MAX(max_popularity) as max_popularity'),
                    DB::raw('SUM(data_points) as data_points'),
                ])
                ->groupBy('keyword_id', DB::raw("strftime('%Y-%m-01', period_start)"))
                ->get();
        } else {
            $popularity = KeywordPopularityAggregate::where('period_type', 'weekly')
                ->where('period_start', '<', $cutoff)
                ->select([
                    'keyword_id',
                    DB::raw('DATE_FORMAT(period_start, "%Y-%m-01") as month_start'),
                    DB::raw('SUM(avg_popularity * data_points) / SUM(data_points) as avg_popularity'),
                    DB::raw('MIN(min_popularity) as min_popularity'),
                    DB::raw('MAX(max_popularity) as max_popularity'),
                    DB::raw('SUM(data_points) as data_points'),
                ])
                ->groupBy('keyword_id', DB::raw('DATE_FORMAT(period_start, "%Y-%m-01")'))
                ->get();
        }

        foreach ($popularity as $row) {
            KeywordPopularityAggregate::updateOrCreate(
                [
                    'keyword_id' => $row->keyword_id,
                    'period_type' => 'monthly',
                    'period_start' => $row->month_start,
                ],
                [
                    'avg_popularity' => round($row->avg_popularity, 2),
                    'min_popularity' => $row->min_popularity,
                    'max_popularity' => $row->max_popularity,
                    'data_points' => $row->data_points,
                ]
            );
            $stats['popularity']++;
        }

        // Delete aggregated weekly popularity
        KeywordPopularityAggregate::where('period_type', 'weekly')
            ->where('period_start', '<', $cutoff)
            ->delete();

        return $stats;
    }
}
