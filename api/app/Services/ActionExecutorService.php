<?php

namespace App\Services;

use App\Models\Alert;
use App\Models\AlertRule;
use App\Models\App;
use App\Models\ChatAction;
use App\Models\Competitor;
use App\Models\Keyword;
use App\Models\TrackedKeyword;
use App\Models\User;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class ActionExecutorService
{
    public function __construct(
        private AppStoreConnectService $ascService,
        private GooglePlayDeveloperService $gpdService,
    ) {}

    /**
     * Execute a chat action.
     *
     * @throws \Exception If action execution fails
     */
    public function execute(ChatAction $action, App $app, User $user): array
    {
        return match ($action->type) {
            ChatAction::TYPE_ADD_KEYWORDS => $this->executeAddKeywords($action, $app, $user),
            ChatAction::TYPE_REMOVE_KEYWORDS => $this->executeRemoveKeywords($action, $app),
            ChatAction::TYPE_CREATE_ALERT => $this->executeCreateAlert($action, $app, $user),
            ChatAction::TYPE_ADD_COMPETITOR => $this->executeAddCompetitor($action, $app, $user),
            ChatAction::TYPE_EXPORT_DATA => $this->executeExportData($action, $app),
            default => throw new \InvalidArgumentException("Unknown action type: {$action->type}"),
        };
    }

    /**
     * Add keywords to tracking.
     */
    private function executeAddKeywords(ChatAction $action, App $app, User $user): array
    {
        $params = $action->parameters;
        $keywords = $params['keywords'] ?? [];
        $country = strtoupper($params['country'] ?? 'US');

        $added = [];
        $skipped = [];

        foreach ($keywords as $keywordText) {
            $keywordText = trim(strtolower($keywordText));

            // Find or create keyword in global keywords table
            $keyword = Keyword::firstOrCreate(
                ['keyword' => $keywordText, 'storefront' => $country],
                ['keyword' => $keywordText, 'storefront' => $country]
            );

            // Check if already tracked for this app
            $exists = TrackedKeyword::where('app_id', $app->id)
                ->where('keyword_id', $keyword->id)
                ->exists();

            if ($exists) {
                $skipped[] = $keywordText;
                continue;
            }

            // Create tracked keyword entry
            $trackedKeyword = TrackedKeyword::create([
                'app_id' => $app->id,
                'user_id' => $user->id,
                'keyword_id' => $keyword->id,
                'created_at' => now(),
            ]);

            $added[] = [
                'id' => $trackedKeyword->id,
                'keyword' => $keywordText,
                'country' => $country,
            ];
        }

        return [
            'success' => true,
            'added_count' => count($added),
            'skipped_count' => count($skipped),
            'keywords' => $added,
            'skipped' => $skipped,
            'message' => count($added) > 0
                ? "Added " . count($added) . " keyword(s) to tracking"
                : "All keywords were already being tracked",
        ];
    }

    /**
     * Remove keywords from tracking.
     */
    private function executeRemoveKeywords(ChatAction $action, App $app): array
    {
        $params = $action->parameters;
        $keywords = $params['keywords'] ?? [];

        $removed = [];
        $notFound = [];

        foreach ($keywords as $keywordText) {
            $keywordText = trim(strtolower($keywordText));

            // Find the tracked keyword through the keyword table
            $trackedKeyword = TrackedKeyword::where('app_id', $app->id)
                ->whereHas('keyword', fn($q) => $q->where('keyword', $keywordText))
                ->first();

            if (!$trackedKeyword) {
                $notFound[] = $keywordText;
                continue;
            }

            $trackedKeyword->delete();
            $removed[] = $keywordText;
        }

        return [
            'success' => true,
            'removed_count' => count($removed),
            'not_found_count' => count($notFound),
            'removed' => $removed,
            'not_found' => $notFound,
            'message' => count($removed) > 0
                ? "Removed " . count($removed) . " keyword(s) from tracking"
                : "No matching keywords found to remove",
        ];
    }

    /**
     * Create an alert rule.
     */
    private function executeCreateAlert(ChatAction $action, App $app, User $user): array
    {
        $params = $action->parameters;

        $keyword = $params['keyword'] ?? '';
        $condition = $params['condition'] ?? 'reaches_top';
        $threshold = $params['threshold'] ?? 10;
        $channels = $params['channels'] ?? ['push'];

        // Find or create the keyword in global keywords table
        $keywordModel = Keyword::firstOrCreate(
            ['keyword' => trim(strtolower($keyword)), 'storefront' => 'US'],
            ['keyword' => trim(strtolower($keyword)), 'storefront' => 'US']
        );

        // Ensure the keyword is tracked for this app
        $trackedKeyword = TrackedKeyword::firstOrCreate(
            ['app_id' => $app->id, 'keyword_id' => $keywordModel->id],
            ['user_id' => $user->id, 'created_at' => now()]
        );

        // Create the alert rule using the actual model schema
        $alertRule = AlertRule::create([
            'user_id' => $user->id,
            'name' => "Alert for \"{$keyword}\"",
            'type' => AlertRule::TYPE_POSITION_CHANGE,
            'scope_type' => AlertRule::SCOPE_KEYWORD,
            'scope_id' => $trackedKeyword->id,
            'conditions' => [
                'condition' => $condition,
                'threshold' => $threshold,
                'channels' => $channels,
            ],
            'is_active' => true,
        ]);

        return [
            'success' => true,
            'alert_id' => $alertRule->id,
            'keyword' => $keyword,
            'condition' => $condition,
            'threshold' => $threshold,
            'channels' => $channels,
            'message' => "Alert created: You'll be notified when \"{$keyword}\" {$this->formatCondition($condition, $threshold)}",
        ];
    }

    /**
     * Add a competitor to track.
     */
    private function executeAddCompetitor(ChatAction $action, App $app, User $user): array
    {
        $params = $action->parameters;
        $appName = $params['app_name'] ?? '';
        $store = $params['store'] ?? $app->platform;

        // Search for the app
        $searchResults = [];
        if ($store === 'ios') {
            $searchResults = $this->ascService->searchApps($appName, 'US', 5);
        } else {
            $searchResults = $this->gpdService->searchApps($appName, 'US', 5);
        }

        if (empty($searchResults)) {
            return [
                'success' => false,
                'message' => "No apps found matching \"{$appName}\"",
                'search_query' => $appName,
            ];
        }

        // Take the first result
        $foundApp = $searchResults[0];

        // Check if already tracking this competitor
        $exists = Competitor::where('app_id', $app->id)
            ->where('competitor_store_id', $foundApp['id'])
            ->exists();

        if ($exists) {
            return [
                'success' => true,
                'already_tracking' => true,
                'message' => "\"{$foundApp['name']}\" is already being tracked as a competitor",
                'competitor_name' => $foundApp['name'],
            ];
        }

        // Create the competitor
        $competitor = Competitor::create([
            'app_id' => $app->id,
            'user_id' => $user->id,
            'competitor_store_id' => $foundApp['id'],
            'name' => $foundApp['name'],
            'platform' => $store,
            'icon_url' => $foundApp['icon_url'] ?? null,
            'developer' => $foundApp['developer'] ?? null,
        ]);

        return [
            'success' => true,
            'competitor_id' => $competitor->id,
            'competitor_name' => $foundApp['name'],
            'competitor_icon' => $foundApp['icon_url'] ?? null,
            'message' => "Added \"{$foundApp['name']}\" as a competitor",
        ];
    }

    /**
     * Export data to CSV.
     */
    private function executeExportData(ChatAction $action, App $app): array
    {
        $params = $action->parameters;
        $type = $params['type'] ?? 'keywords';
        $dateRange = $params['date_range'] ?? '30d';

        // Calculate date range
        $days = match ($dateRange) {
            '7d' => 7,
            '30d' => 30,
            '90d' => 90,
            'all' => 365,
            default => 30,
        };
        $startDate = now()->subDays($days);

        // Generate CSV content based on type
        $csvContent = match ($type) {
            'keywords' => $this->generateKeywordsCsv($app),
            'analytics' => $this->generateAnalyticsCsv($app, $startDate),
            'reviews' => $this->generateReviewsCsv($app, $startDate),
            default => throw new \InvalidArgumentException("Unknown export type: {$type}"),
        };

        // Store the file temporarily
        $filename = "{$app->name}_{$type}_{$dateRange}_" . now()->format('Y-m-d') . ".csv";
        $path = "exports/{$app->user_id}/{$filename}";
        Storage::put($path, $csvContent);

        // Generate a temporary download URL (expires in 1 hour)
        $downloadUrl = Storage::temporaryUrl($path, now()->addHour());

        return [
            'success' => true,
            'filename' => $filename,
            'download_url' => $downloadUrl,
            'type' => $type,
            'date_range' => $dateRange,
            'message' => "Export ready: {$filename}",
        ];
    }

    private function generateKeywordsCsv(App $app): string
    {
        $trackedKeywords = TrackedKeyword::with(['keyword', 'tags'])
            ->where('app_id', $app->id)
            ->get();

        $csv = "Keyword,Popularity,Country,Tags\n";

        foreach ($trackedKeywords as $tracked) {
            $tags = $tracked->tags->pluck('name')->implode(';');
            $csv .= sprintf(
                "%s,%s,%s,%s\n",
                $this->escapeCsv($tracked->keyword->keyword),
                $tracked->keyword->popularity ?? 'N/A',
                $tracked->keyword->storefront,
                $this->escapeCsv($tags)
            );
        }

        return $csv;
    }

    private function generateAnalyticsCsv(App $app, $startDate): string
    {
        // Simplified - would need actual analytics data
        $csv = "Date,Downloads,Revenue,Impressions,PageViews\n";
        $csv .= "Export not fully implemented - please use the Analytics export feature\n";
        return $csv;
    }

    private function generateReviewsCsv(App $app, $startDate): string
    {
        $reviews = $app->reviews()
            ->where('created_at', '>=', $startDate)
            ->orderByDesc('created_at')
            ->get();

        $csv = "Date,Rating,Author,Title,Content,Country\n";

        foreach ($reviews as $review) {
            $csv .= sprintf(
                "%s,%d,%s,%s,%s,%s\n",
                $review->created_at->format('Y-m-d'),
                $review->rating,
                $this->escapeCsv($review->author ?? 'Anonymous'),
                $this->escapeCsv($review->title ?? ''),
                $this->escapeCsv($review->content ?? ''),
                $review->country ?? 'US'
            );
        }

        return $csv;
    }

    private function escapeCsv(string $value): string
    {
        if (str_contains($value, ',') || str_contains($value, '"') || str_contains($value, "\n")) {
            return '"' . str_replace('"', '""', $value) . '"';
        }
        return $value;
    }

    private function formatCondition(string $condition, int $threshold): string
    {
        return match ($condition) {
            'reaches_top' => "reaches top {$threshold}",
            'drops_below' => "drops below position {$threshold}",
            'improves_by' => "improves by {$threshold} positions",
            'drops_by' => "drops by {$threshold} positions",
            default => $condition,
        };
    }
}
