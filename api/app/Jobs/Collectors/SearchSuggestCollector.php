<?php

namespace App\Jobs\Collectors;

use App\Models\Keyword;
use App\Models\SearchSuggestion;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class SearchSuggestCollector extends BaseCollector
{
    protected int $rateLimitMs = 200;
    public int $timeout = 3600; // 1 hour

    public function getCollectorName(): string
    {
        return 'SearchSuggestCollector';
    }

    /**
     * Get seed keywords to expand via autocomplete
     * Uses existing tracked keywords + top search terms
     */
    public function getItems(): Collection
    {
        $items = collect();
        $countries = config('aso.top_apps.countries', ['us']);

        // Get unique keywords from tracked_keywords
        $keywords = Keyword::select('keyword', 'storefront')
            ->distinct()
            ->get()
            ->map(fn($k) => [
                'keyword' => $k->keyword,
                'country' => strtolower($k->storefront),
                'platform' => 'ios', // iOS first
            ]);

        $items = $items->merge($keywords);

        // Also add Android variants
        $androidKeywords = $keywords->map(fn($k) => [
            'keyword' => $k['keyword'],
            'country' => $k['country'],
            'platform' => 'android',
        ]);

        $items = $items->merge($androidKeywords);

        // Add alphabet expansions for popular keywords (a-z suffix)
        $popularKeywords = Keyword::select('keyword', 'storefront')
            ->whereHas('trackedKeywords', function ($q) {
                $q->selectRaw('count(*) as count')
                    ->groupBy('keyword_id')
                    ->havingRaw('count(*) >= 3');
            })
            ->distinct()
            ->limit(50)
            ->get();

        foreach ($popularKeywords as $kw) {
            foreach (range('a', 'z') as $letter) {
                $items->push([
                    'keyword' => $kw->keyword . ' ' . $letter,
                    'country' => strtolower($kw->storefront),
                    'platform' => 'ios',
                ]);
            }
        }

        return $items->unique(fn($i) => "{$i['platform']}:{$i['country']}:{$i['keyword']}");
    }

    /**
     * Fetch autocomplete suggestions for a keyword
     */
    public function processItem(mixed $item): void
    {
        $keyword = $item['keyword'];
        $country = $item['country'];
        $platform = $item['platform'];

        $suggestions = $platform === 'ios'
            ? $this->getIosSuggestions($keyword, $country)
            : $this->getAndroidSuggestions($keyword, $country);

        if (empty($suggestions)) {
            return;
        }

        $today = today();

        foreach ($suggestions as $index => $suggestion) {
            SearchSuggestion::updateOrCreate(
                [
                    'platform' => $platform,
                    'country' => $country,
                    'seed_keyword' => $keyword,
                    'suggestion' => $suggestion,
                ],
                [
                    'position' => $index + 1,
                    'last_seen_at' => $today,
                ]
            );

            // Also create/update the keyword in keywords table
            Keyword::firstOrCreate(
                [
                    'keyword' => strtolower($suggestion),
                    'storefront' => strtoupper($country),
                ],
                [
                    'source' => 'autocomplete',
                ]
            );
        }
    }

    /**
     * Get iOS App Store autocomplete suggestions
     */
    private function getIosSuggestions(string $keyword, string $country): array
    {
        try {
            // Apple's search hint API
            $response = Http::timeout(10)
                ->get('https://search.itunes.apple.com/WebObjects/MZSearchHints.woa/wa/hints', [
                    'clientApplication' => 'Software',
                    'term' => $keyword,
                    'country' => $country,
                ]);

            if (!$response->successful()) {
                return [];
            }

            $data = $response->json();
            $hints = $data['hints'] ?? [];

            return array_slice($hints, 0, 10);
        } catch (\Exception $e) {
            Log::debug("[SearchSuggestCollector] iOS error for '{$keyword}': " . $e->getMessage());
            return [];
        }
    }

    /**
     * Get Google Play autocomplete suggestions
     */
    private function getAndroidSuggestions(string $keyword, string $country): array
    {
        try {
            // Google Play autocomplete endpoint
            $response = Http::timeout(10)
                ->get('https://market.android.com/suggest/SuggRequest', [
                    'json' => 1,
                    'c' => 3, // apps
                    'query' => $keyword,
                    'hl' => $country,
                ]);

            if (!$response->successful()) {
                return [];
            }

            $data = $response->json();

            return collect($data)
                ->pluck('s')
                ->filter()
                ->take(10)
                ->toArray();
        } catch (\Exception $e) {
            Log::debug("[SearchSuggestCollector] Android error for '{$keyword}': " . $e->getMessage());
            return [];
        }
    }

    protected function getItemIdentifier(mixed $item): string
    {
        return "{$item['platform']}:{$item['country']}:{$item['keyword']}";
    }
}
