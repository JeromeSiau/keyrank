<?php

namespace App\Jobs\Collectors;

use App\Models\App;
use App\Models\AppAsoSnapshot;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Log;

class AsoMetadataCollector extends BaseCollector
{
    protected int $rateLimitMs = 200;
    public int $timeout = 7200; // 2 hours

    private iTunesService $iTunesService;
    private GooglePlayService $googlePlayService;

    public function __construct()
    {
        parent::__construct();
        $this->iTunesService = app(iTunesService::class);
        $this->googlePlayService = app(GooglePlayService::class);
    }

    public function getCollectorName(): string
    {
        return 'AsoMetadataCollector';
    }

    /**
     * Get apps to collect ASO metadata for
     */
    public function getItems(): Collection
    {
        $items = collect();

        // Get tracked apps
        $apps = App::select('id', 'platform', 'store_id', 'name')
            ->whereHas('users')
            ->get();

        // For each app, create items for key countries
        $countries = ['us', 'gb', 'fr', 'de', 'jp']; // Key markets for ASO

        foreach ($apps as $app) {
            foreach ($countries as $country) {
                $items->push([
                    'app' => $app,
                    'country' => $country,
                ]);
            }
        }

        return $items;
    }

    /**
     * Collect ASO metadata for an app in a country
     */
    public function processItem(mixed $item): void
    {
        $app = $item['app'];
        $country = $item['country'];

        $metadata = $app->platform === 'ios'
            ? $this->fetchIosMetadata($app->store_id, $country)
            : $this->fetchAndroidMetadata($app->store_id, $country);

        if (empty($metadata)) {
            return;
        }

        // Calculate keyword density from title + description
        $keywordDensity = $this->calculateKeywordDensity(
            ($metadata['title'] ?? '') . ' ' . ($metadata['subtitle'] ?? '') . ' ' . ($metadata['description'] ?? '')
        );

        AppAsoSnapshot::create([
            'app_id' => $app->id,
            'country' => $country,
            'title' => $metadata['title'] ?? null,
            'subtitle' => $metadata['subtitle'] ?? null,
            'description' => $metadata['description'] ?? null,
            'whats_new' => $metadata['whats_new'] ?? null,
            'promotional_text' => $metadata['promotional_text'] ?? null,
            'title_length' => isset($metadata['title']) ? mb_strlen($metadata['title']) : null,
            'subtitle_length' => isset($metadata['subtitle']) ? mb_strlen($metadata['subtitle']) : null,
            'description_length' => isset($metadata['description']) ? mb_strlen($metadata['description']) : null,
            'keyword_density' => $keywordDensity,
            'snapshot_at' => now(),
        ]);
    }

    /**
     * Fetch iOS metadata from iTunes
     */
    private function fetchIosMetadata(string $storeId, string $country): ?array
    {
        $details = $this->iTunesService->getAppDetails($storeId, $country);

        if (!$details) {
            return null;
        }

        return [
            'title' => $details['name'] ?? null,
            'subtitle' => null, // iTunes API doesn't return subtitle directly
            'description' => $details['description'] ?? null,
            'whats_new' => $details['release_notes'] ?? $details['whatsNew'] ?? null,
            'promotional_text' => null, // Not available via API
        ];
    }

    /**
     * Fetch Android metadata from Google Play
     */
    private function fetchAndroidMetadata(string $storeId, string $country): ?array
    {
        $details = $this->googlePlayService->getAppDetails($storeId, $country);

        if (!$details) {
            return null;
        }

        return [
            'title' => $details['title'] ?? $details['name'] ?? null,
            'subtitle' => $details['summary'] ?? null,
            'description' => $details['description'] ?? null,
            'whats_new' => $details['recentChanges'] ?? $details['whatsNew'] ?? null,
            'promotional_text' => null,
        ];
    }

    /**
     * Calculate top keywords from text
     */
    private function calculateKeywordDensity(string $text): array
    {
        if (empty($text)) {
            return [];
        }

        // Normalize text
        $text = mb_strtolower($text);
        $text = preg_replace('/[^\p{L}\p{N}\s]/u', ' ', $text);

        // Split into words
        $words = preg_split('/\s+/', $text, -1, PREG_SPLIT_NO_EMPTY);

        // Filter stop words and short words
        $stopWords = ['the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by', 'is', 'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could', 'should', 'may', 'might', 'can', 'this', 'that', 'these', 'those', 'it', 'its', 'you', 'your', 'we', 'our', 'they', 'their', 'from', 'as', 'all', 'any', 'more', 'most', 'other', 'some', 'such', 'no', 'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very', 'just', 'also', 'now', 'new', 'one', 'two', 'first', 'last', 'long', 'great', 'little', 'own', 'other', 'old', 'right', 'big', 'high', 'different', 'small', 'large', 'next', 'early', 'young', 'important', 'few', 'public', 'bad', 'same', 'able'];

        $words = array_filter($words, fn($w) => mb_strlen($w) >= 3 && !in_array($w, $stopWords));

        // Count frequency
        $frequency = array_count_values($words);
        arsort($frequency);

        // Return top 20 keywords with their frequency
        return array_slice($frequency, 0, 20, true);
    }

    protected function getItemIdentifier(mixed $item): string
    {
        return "{$item['app']->platform}:{$item['app']->store_id}:{$item['country']}";
    }
}
