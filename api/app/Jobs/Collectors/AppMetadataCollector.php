<?php

namespace App\Jobs\Collectors;

use App\Models\App;
use App\Models\AppMetadataHistory;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Log;

class AppMetadataCollector extends BaseCollector
{
    protected int $rateLimitMs = 200;
    public int $timeout = 7200; // 2 hours

    private iTunesService $iTunesService;
    private GooglePlayService $googlePlayService;

    /**
     * Fields to track for changes
     */
    private array $trackedFields = [
        'version',
        'price',
        'size_bytes',
        'description',
        'screenshots',
        'minimum_os',
    ];

    public function __construct()
    {
        parent::__construct();
        $this->iTunesService = app(iTunesService::class);
        $this->googlePlayService = app(GooglePlayService::class);
    }

    public function getCollectorName(): string
    {
        return 'AppMetadataCollector';
    }

    /**
     * Get apps to check for metadata changes
     * Prioritize apps not checked recently
     */
    public function getItems(): Collection
    {
        return App::select('id', 'platform', 'store_id', 'name', 'current_version', 'current_price', 'current_size_bytes', 'current_screenshots', 'metadata_checked_at')
            ->where(function ($query) {
                $query->whereNull('metadata_checked_at')
                    ->orWhere('metadata_checked_at', '<', now()->subHours(12));
            })
            ->orderBy('metadata_checked_at')
            ->limit(1000)
            ->get();
    }

    /**
     * Check app for metadata changes
     */
    public function processItem(mixed $item): void
    {
        $app = $item;

        $newMetadata = $app->platform === 'ios'
            ? $this->fetchIosMetadata($app->store_id)
            : $this->fetchAndroidMetadata($app->store_id);

        if (empty($newMetadata)) {
            return;
        }

        $changes = $this->detectChanges($app, $newMetadata);

        // Record changes
        foreach ($changes as $field => $change) {
            AppMetadataHistory::create([
                'app_id' => $app->id,
                'field' => $field,
                'old_value' => $change['old'],
                'new_value' => $change['new'],
                'changed_at' => now(),
            ]);

            Log::info("[AppMetadataCollector] Change detected", [
                'app_id' => $app->id,
                'app_name' => $app->name,
                'field' => $field,
                'old' => is_array($change['old']) ? 'array' : $change['old'],
                'new' => is_array($change['new']) ? 'array' : $change['new'],
            ]);
        }

        // Update app with current metadata
        $app->update([
            'current_version' => $newMetadata['version'] ?? $app->current_version,
            'current_price' => $newMetadata['price'] ?? $app->current_price,
            'current_size_bytes' => $newMetadata['size_bytes'] ?? $app->current_size_bytes,
            'current_screenshots' => isset($newMetadata['screenshots']) ? json_encode($newMetadata['screenshots']) : $app->current_screenshots,
            'metadata_checked_at' => now(),
        ]);
    }

    /**
     * Fetch iOS app metadata
     */
    private function fetchIosMetadata(string $storeId): ?array
    {
        $details = $this->iTunesService->getAppDetails($storeId);

        if (!$details) {
            return null;
        }

        return [
            'version' => $details['version'] ?? null,
            'price' => $details['price'] ?? 0,
            'size_bytes' => $details['size_bytes'] ?? null,
            'description' => $details['description'] ?? null,
            'screenshots' => $details['screenshots'] ?? [],
            'minimum_os' => $details['minimum_os'] ?? null,
        ];
    }

    /**
     * Fetch Android app metadata
     */
    private function fetchAndroidMetadata(string $storeId): ?array
    {
        $details = $this->googlePlayService->getAppDetails($storeId);

        if (!$details) {
            return null;
        }

        return [
            'version' => $details['version'] ?? null,
            'price' => $details['price'] ?? $details['priceText'] ?? 0,
            'size_bytes' => $details['size'] ?? null,
            'description' => $details['description'] ?? null,
            'screenshots' => $details['screenshots'] ?? [],
            'minimum_os' => $details['androidVersion'] ?? null,
        ];
    }

    /**
     * Detect changes between current app state and new metadata
     */
    private function detectChanges(App $app, array $newMetadata): array
    {
        $changes = [];

        // Version change
        if (isset($newMetadata['version']) && $app->current_version !== null) {
            if ($newMetadata['version'] !== $app->current_version) {
                $changes['version'] = [
                    'old' => $app->current_version,
                    'new' => $newMetadata['version'],
                ];
            }
        }

        // Price change
        if (isset($newMetadata['price']) && $app->current_price !== null) {
            $newPrice = floatval($newMetadata['price']);
            $oldPrice = floatval($app->current_price);
            if (abs($newPrice - $oldPrice) > 0.01) {
                $changes['price'] = [
                    'old' => $oldPrice,
                    'new' => $newPrice,
                ];
            }
        }

        // Size change (significant change > 1MB)
        if (isset($newMetadata['size_bytes']) && $app->current_size_bytes !== null) {
            $sizeDiff = abs($newMetadata['size_bytes'] - $app->current_size_bytes);
            if ($sizeDiff > 1024 * 1024) { // 1MB threshold
                $changes['size_bytes'] = [
                    'old' => $app->current_size_bytes,
                    'new' => $newMetadata['size_bytes'],
                ];
            }
        }

        // Screenshots change (count changed)
        if (isset($newMetadata['screenshots']) && $app->current_screenshots !== null) {
            $oldScreenshots = json_decode($app->current_screenshots, true) ?? [];
            $newScreenshots = $newMetadata['screenshots'];

            if (count($oldScreenshots) !== count($newScreenshots)) {
                $changes['screenshots'] = [
                    'old' => count($oldScreenshots) . ' screenshots',
                    'new' => count($newScreenshots) . ' screenshots',
                ];
            }
        }

        return $changes;
    }

    protected function getItemIdentifier(mixed $item): string
    {
        return "{$item->platform}:{$item->store_id}";
    }
}
