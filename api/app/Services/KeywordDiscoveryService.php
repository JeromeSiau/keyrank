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
}
