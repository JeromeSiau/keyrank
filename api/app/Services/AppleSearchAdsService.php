<?php

namespace App\Services;

use Firebase\JWT\JWT;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Cache;

class AppleSearchAdsService
{
    private const TOKEN_URL = 'https://appleid.apple.com/auth/oauth2/token';
    private const API_BASE_URL = 'https://api.searchads.apple.com/api/v5';

    private string $clientId;
    private string $teamId;
    private string $keyId;
    private string $privateKey;

    public function __construct()
    {
        $this->clientId = config('services.apple_search_ads.client_id');
        $this->teamId = config('services.apple_search_ads.team_id');
        $this->keyId = config('services.apple_search_ads.key_id');
        $this->privateKey = $this->loadPrivateKey();
    }

    /**
     * Check if the service is properly configured
     */
    public function isConfigured(): bool
    {
        return !empty($this->clientId)
            && !empty($this->teamId)
            && !empty($this->keyId)
            && !empty($this->privateKey);
    }

    /**
     * Get keyword suggestions for an app
     *
     * @param string $adamId The App Store app ID
     * @param string $countryCode ISO country code (e.g., 'US', 'FR')
     * @param int $limit Max number of suggestions (1-50)
     * @return array
     */
    public function getKeywordSuggestions(string $adamId, string $countryCode = 'US', int $limit = 50): array
    {
        $cacheKey = "asa_keywords_{$adamId}_{$countryCode}_{$limit}";

        return Cache::remember($cacheKey, now()->addHours(12), function () use ($adamId, $countryCode, $limit) {
            $accessToken = $this->getAccessToken();

            if (!$accessToken) {
                \Log::warning('Apple Search Ads: Failed to get access token');
                return [];
            }

            $response = Http::timeout(30)
                ->withHeaders([
                    'Authorization' => "Bearer {$accessToken}",
                    'X-AP-Context' => "orgId={$this->getOrgId()}",
                ])
                ->post(self::API_BASE_URL . '/keywords/targeting', [
                    'adamId' => $adamId,
                    'countriesOrRegions' => [strtoupper($countryCode)],
                    'limit' => min($limit, 50),
                ]);

            if (!$response->successful()) {
                \Log::warning("Apple Search Ads API error: status {$response->status()}", [
                    'body' => $response->body(),
                ]);
                return [];
            }

            $data = $response->json('data', []);

            return collect($data)->map(fn($keyword) => $this->formatKeywordSuggestion($keyword))->toArray();
        });
    }

    /**
     * Search for apps by term (for finding adamId)
     *
     * @param string $query Search query
     * @param string $countryCode ISO country code
     * @param int $limit Max results
     * @return array
     */
    public function searchApps(string $query, string $countryCode = 'US', int $limit = 10): array
    {
        $cacheKey = "asa_search_" . md5($query) . "_{$countryCode}_{$limit}";

        return Cache::remember($cacheKey, now()->addHours(6), function () use ($query, $countryCode, $limit) {
            $accessToken = $this->getAccessToken();

            if (!$accessToken) {
                return [];
            }

            $response = Http::timeout(30)
                ->withHeaders([
                    'Authorization' => "Bearer {$accessToken}",
                    'X-AP-Context' => "orgId={$this->getOrgId()}",
                ])
                ->get(self::API_BASE_URL . '/search/apps', [
                    'query' => $query,
                    'returnOwnedApps' => false,
                    'countriesOrRegions' => strtoupper($countryCode),
                    'limit' => min($limit, 50),
                ]);

            if (!$response->successful()) {
                \Log::warning("Apple Search Ads app search error: status {$response->status()}");
                return [];
            }

            return $response->json('data', []);
        });
    }

    /**
     * Get the OAuth2 access token (cached for 55 minutes)
     */
    private function getAccessToken(): ?string
    {
        return Cache::remember('apple_search_ads_token', now()->addMinutes(55), function () {
            $jwt = $this->generateJWT();

            $response = Http::asForm()->timeout(15)->post(self::TOKEN_URL, [
                'grant_type' => 'client_credentials',
                'client_id' => $this->clientId,
                'client_secret' => $jwt,
                'scope' => 'searchadsorg',
            ]);

            if (!$response->successful()) {
                \Log::error('Apple Search Ads token error', [
                    'status' => $response->status(),
                    'body' => $response->body(),
                ]);
                return null;
            }

            return $response->json('access_token');
        });
    }

    /**
     * Generate JWT for authentication
     */
    private function generateJWT(): string
    {
        $now = time();

        $payload = [
            'iss' => $this->teamId,
            'iat' => $now,
            'exp' => $now + 3600, // 1 hour
            'aud' => 'https://appleid.apple.com',
            'sub' => $this->clientId,
        ];

        return JWT::encode($payload, $this->privateKey, 'ES256', $this->keyId);
    }

    /**
     * Get the organization ID (first one from account)
     */
    private function getOrgId(): ?string
    {
        return Cache::remember('apple_search_ads_org_id', now()->addDay(), function () {
            $accessToken = Cache::get('apple_search_ads_token');

            if (!$accessToken) {
                $accessToken = $this->getAccessToken();
            }

            if (!$accessToken) {
                return null;
            }

            $response = Http::timeout(15)
                ->withHeaders([
                    'Authorization' => "Bearer {$accessToken}",
                ])
                ->get(self::API_BASE_URL . '/acls');

            if (!$response->successful()) {
                \Log::warning("Apple Search Ads ACL error: status {$response->status()}");
                return null;
            }

            $acls = $response->json('data', []);

            return $acls[0]['orgId'] ?? null;
        });
    }

    /**
     * Load private key from file or environment
     */
    private function loadPrivateKey(): string
    {
        // First try path
        $path = config('services.apple_search_ads.private_key_path');
        if ($path && file_exists($path)) {
            return file_get_contents($path);
        }

        // Then try direct content (replace \n with actual newlines)
        $key = config('services.apple_search_ads.private_key');
        if ($key) {
            return str_replace('\\n', "\n", $key);
        }

        return '';
    }

    /**
     * Format keyword suggestion from API response
     */
    private function formatKeywordSuggestion(array $keyword): array
    {
        return [
            'text' => $keyword['text'] ?? '',
            'match_type' => $keyword['matchType'] ?? 'BROAD',
            'bid_amount' => $keyword['bidAmount']['amount'] ?? null,
            'bid_currency' => $keyword['bidAmount']['currency'] ?? 'USD',
            'popularity' => $keyword['popularity'] ?? null,
        ];
    }

    /**
     * Clear cached tokens (useful for debugging)
     */
    public function clearTokenCache(): void
    {
        Cache::forget('apple_search_ads_token');
        Cache::forget('apple_search_ads_org_id');
    }
}
