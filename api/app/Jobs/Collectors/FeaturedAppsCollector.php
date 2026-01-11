<?php

namespace App\Jobs\Collectors;

use App\Models\App;
use App\Models\FeaturedPlacement;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class FeaturedAppsCollector extends BaseCollector
{
    protected int $rateLimitMs = 500;
    public int $timeout = 3600; // 1 hour

    public function getCollectorName(): string
    {
        return 'FeaturedAppsCollector';
    }

    /**
     * Get country/platform combinations to check for featured apps
     */
    public function getItems(): Collection
    {
        $items = collect();
        $countries = config('aso.top_apps.countries', ['us']);

        foreach (['ios', 'android'] as $platform) {
            foreach ($countries as $country) {
                $items->push([
                    'platform' => $platform,
                    'country' => $country,
                ]);
            }
        }

        return $items;
    }

    /**
     * Collect featured apps for a platform/country
     */
    public function processItem(mixed $item): void
    {
        $platform = $item['platform'];
        $country = $item['country'];
        $today = today();

        if ($platform === 'ios') {
            $this->collectIosFeatured($country, $today);
        } else {
            $this->collectAndroidFeatured($country, $today);
        }
    }

    /**
     * Collect iOS featured apps via RSS feeds
     */
    private function collectIosFeatured(string $country, $today): void
    {
        $feeds = [
            'new_apps_we_love' => "https://itunes.apple.com/{$country}/rss/newapplicationswelike/limit=50/json",
            'new_games_we_love' => "https://itunes.apple.com/{$country}/rss/newgameswelike/limit=50/json",
        ];

        foreach ($feeds as $placementType => $url) {
            try {
                $response = Http::timeout(30)->get($url);

                if (!$response->successful()) {
                    continue;
                }

                $feed = $response->json('feed', []);
                $entries = $feed['entry'] ?? [];

                foreach ($entries as $index => $entry) {
                    $appleId = $entry['id']['attributes']['im:id'] ?? null;
                    if (!$appleId) continue;

                    $app = App::where('platform', 'ios')
                        ->where('store_id', $appleId)
                        ->first();

                    if (!$app) {
                        // Create the app if we don't have it
                        $app = App::create([
                            'platform' => 'ios',
                            'store_id' => $appleId,
                            'name' => $entry['im:name']['label'] ?? 'Unknown',
                            'developer' => $entry['im:artist']['label'] ?? null,
                            'icon_url' => $entry['im:image'][2]['label'] ?? null,
                            'discovery_source' => 'featured',
                        ]);
                    }

                    $this->saveFeaturedPlacement(
                        $app->id,
                        'ios',
                        $country,
                        $placementType,
                        null,
                        $this->formatPlacementTitle($placementType),
                        $index + 1,
                        $today
                    );
                }

                usleep(200000); // 200ms between feeds
            } catch (\Exception $e) {
                Log::debug("[FeaturedAppsCollector] iOS feed error ({$placementType}): " . $e->getMessage());
            }
        }
    }

    /**
     * Collect Android featured apps
     * Note: Google Play doesn't have public RSS feeds, we check our tracked apps
     */
    private function collectAndroidFeatured(string $country, $today): void
    {
        // For Android, we can only detect "Editor's Choice" badge from app details
        // This is checked in AppMetadataCollector
        // Here we could add additional scraping if needed
    }

    /**
     * Save or update featured placement
     */
    private function saveFeaturedPlacement(
        int $appId,
        string $platform,
        string $country,
        string $placementType,
        ?string $placementId,
        ?string $placementTitle,
        ?int $position,
        $today
    ): void {
        $existing = FeaturedPlacement::where('app_id', $appId)
            ->where('platform', $platform)
            ->where('country', $country)
            ->where('placement_type', $placementType)
            ->first();

        if ($existing) {
            $existing->update([
                'last_seen_at' => $today,
                'position' => $position,
            ]);
        } else {
            FeaturedPlacement::create([
                'app_id' => $appId,
                'platform' => $platform,
                'country' => $country,
                'placement_type' => $placementType,
                'placement_id' => $placementId,
                'placement_title' => $placementTitle,
                'position' => $position,
                'first_seen_at' => $today,
                'last_seen_at' => $today,
            ]);
        }
    }

    /**
     * Format placement type to human readable title
     */
    private function formatPlacementTitle(string $type): string
    {
        return match ($type) {
            'new_apps_we_love' => 'New Apps We Love',
            'new_games_we_love' => 'New Games We Love',
            'today_tab' => 'Today Tab',
            'apps_tab' => 'Apps Tab Feature',
            'games_tab' => 'Games Tab Feature',
            default => ucwords(str_replace('_', ' ', $type)),
        };
    }

    protected function getItemIdentifier(mixed $item): string
    {
        return "{$item['platform']}:{$item['country']}";
    }
}
