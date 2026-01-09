<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppRanking;
use App\Models\TrackedKeyword;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\StreamedResponse;

class ExportController extends Controller
{
    public function rankings(Request $request, App $app): StreamedResponse
    {
        $user = $request->user();

        $trackedKeywordIds = TrackedKeyword::where('app_id', $app->id)
            ->where('user_id', $user->id)
            ->pluck('keyword_id');

        $rankings = AppRanking::where('app_id', $app->id)
            ->whereIn('keyword_id', $trackedKeywordIds)
            ->with('keyword')
            ->orderBy('recorded_at', 'desc')
            ->get();

        $filename = "rankings-{$app->name}-" . now()->format('Y-m-d') . '.csv';

        return response()->streamDownload(function () use ($rankings) {
            $handle = fopen('php://output', 'w');

            // Header row
            fputcsv($handle, ['Keyword', 'Platform', 'Position', 'Date']);

            // Data rows
            foreach ($rankings as $ranking) {
                fputcsv($handle, [
                    $ranking->keyword->keyword,
                    $ranking->platform,
                    $ranking->position,
                    $ranking->recorded_at->toDateString(),
                ]);
            }

            fclose($handle);
        }, $filename, [
            'Content-Type' => 'text/csv; charset=UTF-8',
        ]);
    }
}
