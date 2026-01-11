<?php

namespace App\Services;

use App\Models\StoreConnection;
use Firebase\JWT\JWT;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Cache;

class AppStoreConnectService
{
    private string $baseUrl;

    public function __construct()
    {
        $this->baseUrl = config('services.app_store_connect.base_url');
    }

    /**
     * Generate JWT token for App Store Connect API
     */
    public function generateToken(array $credentials): string
    {
        $cacheKey = "asc_token_{$credentials['key_id']}";

        return Cache::remember($cacheKey, 1000, function () use ($credentials) {
            $header = [
                'alg' => 'ES256',
                'kid' => $credentials['key_id'],
                'typ' => 'JWT',
            ];

            $payload = [
                'iss' => $credentials['issuer_id'],
                'iat' => time(),
                'exp' => time() + 1200, // 20 minutes
                'aud' => 'appstoreconnect-v1',
            ];

            return JWT::encode($payload, $credentials['private_key'], 'ES256', null, $header);
        });
    }

    /**
     * Fetch reviews for an app
     */
    public function getReviews(StoreConnection $connection, string $appStoreId, ?string $cursor = null): ?array
    {
        try {
            $token = $this->generateToken($connection->credentials);

            $url = "{$this->baseUrl}/v1/apps/{$appStoreId}/customerReviews";
            $params = [
                'limit' => 100,
                'sort' => '-createdDate',
                'include' => 'response',
            ];

            if ($cursor) {
                $params['cursor'] = $cursor;
            }

            $response = Http::withToken($token)
                ->timeout(30)
                ->get($url, $params);

            if ($response->successful()) {
                return $response->json();
            }

            if ($response->status() === 401) {
                $connection->markAsExpired();
            }

            Log::error('App Store Connect API error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('App Store Connect API exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Reply to a review
     */
    public function replyToReview(StoreConnection $connection, string $reviewId, string $responseBody): ?array
    {
        try {
            $token = $this->generateToken($connection->credentials);

            $response = Http::withToken($token)
                ->timeout(30)
                ->post("{$this->baseUrl}/v1/customerReviewResponses", [
                    'data' => [
                        'type' => 'customerReviewResponses',
                        'attributes' => [
                            'responseBody' => $responseBody,
                        ],
                        'relationships' => [
                            'review' => [
                                'data' => [
                                    'type' => 'customerReviews',
                                    'id' => $reviewId,
                                ],
                            ],
                        ],
                    ],
                ]);

            if ($response->successful()) {
                return $response->json();
            }

            Log::error('App Store Connect reply error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('App Store Connect reply exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Validate credentials by making a test API call
     */
    public function validateCredentials(array $credentials): bool
    {
        try {
            $token = $this->generateToken($credentials);

            $response = Http::withToken($token)
                ->timeout(10)
                ->get("{$this->baseUrl}/v1/apps", ['limit' => 1]);

            return $response->successful();
        } catch (\Exception $e) {
            Log::error('App Store Connect validation failed', ['error' => $e->getMessage()]);
            return false;
        }
    }

    /**
     * Get all apps from App Store Connect account
     */
    public function getApps(StoreConnection $connection): ?array
    {
        try {
            $token = $this->generateToken($connection->credentials);
            $apps = [];
            $cursor = null;

            do {
                $params = ['limit' => 100];
                if ($cursor) {
                    $params['cursor'] = $cursor;
                }

                $response = Http::withToken($token)
                    ->timeout(30)
                    ->get("{$this->baseUrl}/v1/apps", $params);

                if (!$response->successful()) {
                    if ($response->status() === 401) {
                        $connection->markAsExpired();
                    }
                    Log::error('App Store Connect getApps error', [
                        'status' => $response->status(),
                        'body' => $response->body(),
                    ]);
                    return null;
                }

                $data = $response->json();
                foreach ($data['data'] ?? [] as $app) {
                    $apps[] = [
                        'store_id' => $app['id'],
                        'bundle_id' => $app['attributes']['bundleId'] ?? null,
                        'name' => $app['attributes']['name'] ?? 'Unknown',
                        'platform' => 'ios',
                    ];
                }

                // Check for next page
                $cursor = $data['links']['next'] ?? null;
                if ($cursor) {
                    // Extract cursor from the next URL
                    $parsedUrl = parse_url($cursor);
                    parse_str($parsedUrl['query'] ?? '', $queryParams);
                    $cursor = $queryParams['cursor'] ?? null;
                }
            } while ($cursor);

            return $apps;
        } catch (\Exception $e) {
            Log::error('App Store Connect getApps exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Get sales report for a specific date
     *
     * Returns array of sales data grouped by app and country
     */
    public function getSalesReport(StoreConnection $connection, string $date, string $reportSubType = 'SUMMARY'): ?array
    {
        try {
            $token = $this->generateToken($connection->credentials);

            $params = [
                'filter[reportType]' => 'SALES',
                'filter[reportSubType]' => $reportSubType,
                'filter[frequency]' => 'DAILY',
                'filter[reportDate]' => $date,
                'filter[vendorNumber]' => $connection->credentials['vendor_number'] ?? $connection->credentials['issuer_id'],
            ];

            $response = Http::withToken($token)
                ->timeout(60)
                ->get("{$this->baseUrl}/v1/salesReports", $params);

            if ($response->status() === 404) {
                // No data for this date (common for recent dates due to delay)
                return [];
            }

            if (!$response->successful()) {
                if ($response->status() === 401) {
                    $connection->markAsExpired();
                }
                Log::error('App Store Connect sales report error', [
                    'status' => $response->status(),
                    'body' => $response->body(),
                ]);
                return null;
            }

            return $this->parseSalesReport($response->body());
        } catch (\Exception $e) {
            Log::error('App Store Connect sales report exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Get subscription report for a specific date
     */
    public function getSubscriptionReport(StoreConnection $connection, string $date): ?array
    {
        try {
            $token = $this->generateToken($connection->credentials);

            $params = [
                'filter[reportType]' => 'SUBSCRIPTION',
                'filter[reportSubType]' => 'SUMMARY',
                'filter[frequency]' => 'DAILY',
                'filter[reportDate]' => $date,
                'filter[vendorNumber]' => $connection->credentials['vendor_number'] ?? $connection->credentials['issuer_id'],
            ];

            $response = Http::withToken($token)
                ->timeout(60)
                ->get("{$this->baseUrl}/v1/salesReports", $params);

            if ($response->status() === 404) {
                return [];
            }

            if (!$response->successful()) {
                if ($response->status() === 401) {
                    $connection->markAsExpired();
                }
                Log::error('App Store Connect subscription report error', [
                    'status' => $response->status(),
                    'body' => $response->body(),
                ]);
                return null;
            }

            return $this->parseSubscriptionReport($response->body());
        } catch (\Exception $e) {
            Log::error('App Store Connect subscription report exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Parse gzipped TSV sales report
     */
    private function parseSalesReport(string $gzippedContent): array
    {
        $content = gzdecode($gzippedContent);
        if ($content === false) {
            // Try without decompression (sometimes not gzipped)
            $content = $gzippedContent;
        }

        $lines = explode("\n", trim($content));
        if (count($lines) < 2) {
            return [];
        }

        $headers = str_getcsv(array_shift($lines), "\t");
        $results = [];

        foreach ($lines as $line) {
            if (empty(trim($line))) {
                continue;
            }

            $values = str_getcsv($line, "\t");
            $row = array_combine($headers, $values);

            if ($row === false) {
                continue;
            }

            // Map Apple's TSV columns to our format
            $appId = $row['Apple Identifier'] ?? $row['SKU'] ?? null;
            $country = $row['Country Code'] ?? $row['Territory'] ?? 'WW';

            if (!$appId) {
                continue;
            }

            $key = "{$appId}_{$country}";

            if (!isset($results[$key])) {
                $results[$key] = [
                    'store_id' => $appId,
                    'country_code' => $country,
                    'downloads' => 0,
                    'updates' => 0,
                    'revenue' => 0,
                    'proceeds' => 0,
                    'refunds' => 0,
                ];
            }

            $units = (int) ($row['Units'] ?? 0);
            $productType = $row['Product Type Identifier'] ?? '';
            $developerProceeds = (float) ($row['Developer Proceeds'] ?? 0);
            $customerPrice = (float) ($row['Customer Price'] ?? 0);

            // Categorize by product type
            if (in_array($productType, ['1', '1F', '1T', 'F1'])) {
                // New downloads (free or paid)
                $results[$key]['downloads'] += $units;
                $results[$key]['revenue'] += $customerPrice * $units;
                $results[$key]['proceeds'] += $developerProceeds * $units;
            } elseif (in_array($productType, ['7', '7F', '7T', 'F7'])) {
                // Updates/re-downloads
                $results[$key]['updates'] += $units;
            } elseif (str_starts_with($productType, 'IA')) {
                // In-app purchases
                $results[$key]['revenue'] += $customerPrice * $units;
                $results[$key]['proceeds'] += $developerProceeds * $units;
            }

            // Handle refunds (negative units)
            if ($units < 0) {
                $results[$key]['refunds'] += abs($customerPrice * $units);
            }
        }

        return array_values($results);
    }

    /**
     * Parse subscription report
     */
    private function parseSubscriptionReport(string $gzippedContent): array
    {
        $content = gzdecode($gzippedContent);
        if ($content === false) {
            $content = $gzippedContent;
        }

        $lines = explode("\n", trim($content));
        if (count($lines) < 2) {
            return [];
        }

        $headers = str_getcsv(array_shift($lines), "\t");
        $results = [];

        foreach ($lines as $line) {
            if (empty(trim($line))) {
                continue;
            }

            $values = str_getcsv($line, "\t");
            $row = array_combine($headers, $values);

            if ($row === false) {
                continue;
            }

            $appId = $row['App Apple ID'] ?? $row['Apple Identifier'] ?? null;
            $country = $row['Country'] ?? $row['Territory'] ?? 'WW';

            if (!$appId) {
                continue;
            }

            $key = "{$appId}_{$country}";

            if (!isset($results[$key])) {
                $results[$key] = [
                    'store_id' => $appId,
                    'country_code' => $country,
                    'subscribers_new' => 0,
                    'subscribers_cancelled' => 0,
                    'subscribers_active' => 0,
                ];
            }

            $eventType = $row['Event'] ?? $row['Subscription Event'] ?? '';
            $subscribers = (int) ($row['Subscribers'] ?? $row['Quantity'] ?? 0);

            if (stripos($eventType, 'start') !== false || stripos($eventType, 'new') !== false) {
                $results[$key]['subscribers_new'] += $subscribers;
            } elseif (stripos($eventType, 'cancel') !== false || stripos($eventType, 'churn') !== false) {
                $results[$key]['subscribers_cancelled'] += $subscribers;
            }

            // Active subscribers if available
            if (isset($row['Active Subscribers'])) {
                $results[$key]['subscribers_active'] = max(
                    $results[$key]['subscribers_active'],
                    (int) $row['Active Subscribers']
                );
            }
        }

        return array_values($results);
    }
}
