<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Cache;

class KeywordDiscoveryService
{
    private const HINTS_URL = 'https://search.itunes.apple.com/WebObjects/MZSearchHints.woa/wa/hints';

    private const STORE_IDS = [
        'US' => '143441',
        'GB' => '143444',
        'FR' => '143442',
        'DE' => '143443',
        'JP' => '143462',
        'CN' => '143465',
        'AU' => '143460',
        'CA' => '143455',
        'IT' => '143450',
        'ES' => '143454',
        'NL' => '143452',
        'BR' => '143503',
        'MX' => '143468',
        'KR' => '143466',
        'RU' => '143469',
        'IN' => '143467',
        'SE' => '143456',
        'NO' => '143457',
        'DK' => '143458',
        'FI' => '143447',
        'CH' => '143459',
        'AT' => '143445',
        'BE' => '143446',
        'PT' => '143453',
        'PL' => '143478',
        'SG' => '143464',
        'HK' => '143463',
        'TW' => '143470',
        'NZ' => '143461',
    ];

    public function __construct(
        private iTunesService $iTunesService
    ) {}

    /**
     * Get search hints/suggestions for a term
     */
    public function getSearchHints(string $term, string $country = 'US'): array
    {
        $country = strtoupper($country);
        $storeId = self::STORE_IDS[$country] ?? self::STORE_IDS['US'];
        $cacheKey = "hints_{$country}_" . md5($term);

        return Cache::remember($cacheKey, now()->addDay(), function () use ($term, $storeId) {
            $response = Http::timeout(10)
                ->withHeaders([
                    'X-Apple-Store-Front' => "{$storeId}-1,29",
                ])
                ->get(self::HINTS_URL, [
                    'clientApplication' => 'Software',
                    'term' => $term,
                ]);

            if (!$response->successful()) {
                return [];
            }

            $body = $response->body();

            // Parse plist XML response
            preg_match_all('/<key>term<\/key>\s*<string>([^<]+)<\/string>/', $body, $matches);

            return $matches[1] ?? [];
        });
    }

    /**
     * Extract seed terms from app metadata
     */
    public function extractSeedTerms(array $appDetails): array
    {
        $seeds = [];

        // From app name
        if (!empty($appDetails['name'])) {
            $nameTerms = $this->tokenize($appDetails['name']);
            $seeds = array_merge($seeds, $nameTerms);
        }

        // From description (first 500 chars)
        if (!empty($appDetails['description'])) {
            $desc = substr($appDetails['description'], 0, 500);
            $descTerms = $this->tokenize($desc);
            // Only keep longer, meaningful terms from description
            $descTerms = array_filter($descTerms, fn($t) => strlen($t) >= 4);
            $seeds = array_merge($seeds, array_slice($descTerms, 0, 5));
        }

        // Deduplicate and limit
        $seeds = array_unique(array_map('strtolower', $seeds));
        return array_slice($seeds, 0, 10);
    }

    /**
     * Tokenize text into meaningful terms
     */
    private function tokenize(string $text): array
    {
        // Remove special characters, keep letters and spaces
        $text = preg_replace('/[^a-zA-Z\s]/', ' ', $text);
        $text = strtolower(trim($text));

        // Split into words
        $words = preg_split('/\s+/', $text, -1, PREG_SPLIT_NO_EMPTY);

        // Filter stop words and short words
        $stopWords = ['the', 'and', 'for', 'with', 'your', 'you', 'from', 'that', 'this', 'are', 'was', 'have', 'has', 'will', 'can', 'app', 'new'];
        $words = array_filter($words, fn($w) => strlen($w) >= 3 && !in_array($w, $stopWords));

        return array_values($words);
    }
}
