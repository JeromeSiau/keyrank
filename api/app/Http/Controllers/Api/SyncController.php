<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\JobExecution;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SyncController extends Controller
{
    /**
     * Get sync status for all collectors
     */
    public function status(Request $request): JsonResponse
    {
        $user = $request->user();

        $collectors = [
            'RankingsCollector',
            'RatingsCollector',
            'ReviewsCollector',
        ];

        $collectorStatus = [];
        foreach ($collectors as $collector) {
            $lastExecution = JobExecution::where('job_name', $collector)
                ->orderByDesc('started_at')
                ->first();

            $collectorStatus[$collector] = [
                'last_run' => $lastExecution?->started_at?->toIso8601String(),
                'last_completed' => $lastExecution?->status === 'completed'
                    ? $lastExecution->completed_at?->toIso8601String()
                    : null,
                'status' => $lastExecution?->status ?? 'never_run',
                'items_processed' => $lastExecution?->items_processed ?? 0,
                'items_failed' => $lastExecution?->items_failed ?? 0,
                'duration_ms' => $lastExecution?->duration_ms,
            ];
        }

        // Get integration sync status
        $integrations = $user->integrations()
            ->select(['id', 'type', 'status', 'last_sync_at'])
            ->get()
            ->map(fn($i) => [
                'id' => $i->id,
                'type' => $i->type,
                'status' => $i->status,
                'last_sync_at' => $i->last_sync_at?->toIso8601String(),
            ]);

        // Calculate overall sync health
        $lastRankingsSync = $collectorStatus['RankingsCollector']['last_completed'];
        $lastRatingsSync = $collectorStatus['RatingsCollector']['last_completed'];
        $lastReviewsSync = $collectorStatus['ReviewsCollector']['last_completed'];

        $overallHealth = 'healthy';
        $now = now();

        // Check if any collector is overdue
        if ($lastRankingsSync && $now->diffInHours($lastRankingsSync) > 4) {
            $overallHealth = 'degraded';
        }
        if ($lastRatingsSync && $now->diffInHours($lastRatingsSync) > 12) {
            $overallHealth = 'degraded';
        }
        if ($lastReviewsSync && $now->diffInHours($lastReviewsSync) > 8) {
            $overallHealth = 'degraded';
        }

        // Check for failed collectors
        foreach ($collectorStatus as $status) {
            if ($status['status'] === 'failed') {
                $overallHealth = 'error';
                break;
            }
        }

        return response()->json([
            'data' => [
                'overall_health' => $overallHealth,
                'collectors' => $collectorStatus,
                'integrations' => $integrations,
                'last_data_update' => $this->getLastDataUpdate(),
            ],
        ]);
    }

    /**
     * Get detailed collector history
     */
    public function history(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'collector' => 'nullable|string',
            'limit' => 'nullable|integer|min:1|max:100',
        ]);

        $query = JobExecution::query()
            ->orderByDesc('started_at');

        if (isset($validated['collector'])) {
            $query->where('job_name', $validated['collector']);
        }

        $limit = $validated['limit'] ?? 20;
        $executions = $query->limit($limit)->get();

        return response()->json([
            'data' => $executions->map(fn($e) => [
                'id' => $e->id,
                'job_name' => $e->job_name,
                'status' => $e->status,
                'items_processed' => $e->items_processed,
                'items_failed' => $e->items_failed,
                'error_message' => $e->error_message,
                'started_at' => $e->started_at->toIso8601String(),
                'completed_at' => $e->completed_at?->toIso8601String(),
                'duration_ms' => $e->duration_ms,
            ]),
        ]);
    }

    /**
     * Get the most recent data update timestamp
     */
    private function getLastDataUpdate(): ?string
    {
        $lastCompleted = JobExecution::where('status', 'completed')
            ->orderByDesc('completed_at')
            ->first();

        return $lastCompleted?->completed_at?->toIso8601String();
    }
}
