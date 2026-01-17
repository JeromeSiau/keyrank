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
     * Get app info with localizations
     * Returns the latest app info record with all localizations
     */
    public function getAppInfo(StoreConnection $connection, string $appStoreId): ?array
    {
        try {
            $token = $this->generateToken($connection->credentials);

            // Get app infos (there can be multiple versions, we want the latest)
            $response = Http::withToken($token)
                ->timeout(30)
                ->get("{$this->baseUrl}/v1/apps/{$appStoreId}/appInfos", [
                    'include' => 'appInfoLocalizations',
                    'limit' => 1,
                ]);

            if (!$response->successful()) {
                if ($response->status() === 401) {
                    $connection->markAsExpired();
                }
                Log::error('App Store Connect getAppInfo error', [
                    'status' => $response->status(),
                    'body' => $response->body(),
                ]);
                return null;
            }

            $data = $response->json();
            $appInfo = $data['data'][0] ?? null;

            if (!$appInfo) {
                return null;
            }

            // Parse included localizations
            $localizations = [];
            foreach ($data['included'] ?? [] as $included) {
                if ($included['type'] === 'appInfoLocalizations') {
                    $attrs = $included['attributes'];
                    $localizations[$attrs['locale']] = [
                        'id' => $included['id'],
                        'locale' => $attrs['locale'],
                        'name' => $attrs['name'] ?? null,
                        'subtitle' => $attrs['subtitle'] ?? null,
                        'privacy_policy_url' => $attrs['privacyPolicyUrl'] ?? null,
                        'privacy_choices_url' => $attrs['privacyChoicesUrl'] ?? null,
                        'privacy_policy_text' => $attrs['privacyPolicyText'] ?? null,
                    ];
                }
            }

            return [
                'id' => $appInfo['id'],
                'state' => $appInfo['attributes']['appStoreState'] ?? null,
                'localizations' => $localizations,
            ];
        } catch (\Exception $e) {
            Log::error('App Store Connect getAppInfo exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Get app store version localizations (title, description, keywords, etc.)
     * This is where the editable metadata lives
     */
    public function getAppStoreVersionLocalizations(StoreConnection $connection, string $appStoreId): ?array
    {
        try {
            $token = $this->generateToken($connection->credentials);

            // First, get the editable app store version
            $versionResponse = Http::withToken($token)
                ->timeout(30)
                ->get("{$this->baseUrl}/v1/apps/{$appStoreId}/appStoreVersions", [
                    'filter[appStoreState]' => 'READY_FOR_SALE,PREPARE_FOR_SUBMISSION,WAITING_FOR_REVIEW,IN_REVIEW',
                    'include' => 'appStoreVersionLocalizations',
                    'limit' => 1,
                ]);

            if (!$versionResponse->successful()) {
                if ($versionResponse->status() === 401) {
                    $connection->markAsExpired();
                }
                Log::error('App Store Connect getAppStoreVersionLocalizations error', [
                    'status' => $versionResponse->status(),
                    'body' => $versionResponse->body(),
                ]);
                return null;
            }

            $data = $versionResponse->json();
            $version = $data['data'][0] ?? null;

            if (!$version) {
                return null;
            }

            // Parse included localizations
            $localizations = [];
            foreach ($data['included'] ?? [] as $included) {
                if ($included['type'] === 'appStoreVersionLocalizations') {
                    $attrs = $included['attributes'];
                    $localizations[$attrs['locale']] = [
                        'id' => $included['id'],
                        'locale' => $attrs['locale'],
                        'description' => $attrs['description'] ?? null,
                        'keywords' => $attrs['keywords'] ?? null,
                        'promotional_text' => $attrs['promotionalText'] ?? null,
                        'whats_new' => $attrs['whatsNew'] ?? null,
                        'marketing_url' => $attrs['marketingUrl'] ?? null,
                        'support_url' => $attrs['supportUrl'] ?? null,
                    ];
                }
            }

            return [
                'version_id' => $version['id'],
                'version_string' => $version['attributes']['versionString'] ?? null,
                'state' => $version['attributes']['appStoreState'] ?? null,
                'localizations' => $localizations,
            ];
        } catch (\Exception $e) {
            Log::error('App Store Connect getAppStoreVersionLocalizations exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Get combined metadata for all locales
     * Merges app info localizations (name, subtitle) with version localizations (description, keywords)
     */
    public function getAppMetadata(StoreConnection $connection, string $appStoreId): ?array
    {
        $appInfo = $this->getAppInfo($connection, $appStoreId);
        $versionInfo = $this->getAppStoreVersionLocalizations($connection, $appStoreId);

        if (!$appInfo && !$versionInfo) {
            return null;
        }

        $locales = [];

        // Merge app info localizations
        foreach ($appInfo['localizations'] ?? [] as $locale => $info) {
            $locales[$locale] = [
                'locale' => $locale,
                'app_info_localization_id' => $info['id'],
                'title' => $info['name'],
                'subtitle' => $info['subtitle'],
            ];
        }

        // Merge version localizations
        foreach ($versionInfo['localizations'] ?? [] as $locale => $version) {
            if (!isset($locales[$locale])) {
                $locales[$locale] = ['locale' => $locale];
            }
            $locales[$locale]['version_localization_id'] = $version['id'];
            $locales[$locale]['description'] = $version['description'];
            $locales[$locale]['keywords'] = $version['keywords'];
            $locales[$locale]['promotional_text'] = $version['promotional_text'];
            $locales[$locale]['whats_new'] = $version['whats_new'];
        }

        return [
            'app_info_id' => $appInfo['id'] ?? null,
            'version_id' => $versionInfo['version_id'] ?? null,
            'version_string' => $versionInfo['version_string'] ?? null,
            'state' => $versionInfo['state'] ?? $appInfo['state'] ?? null,
            'locales' => array_values($locales),
        ];
    }

    /**
     * Update app info localization (name, subtitle)
     */
    public function updateAppInfoLocalization(
        StoreConnection $connection,
        string $localizationId,
        array $attributes
    ): ?array {
        try {
            $token = $this->generateToken($connection->credentials);

            $payload = [
                'data' => [
                    'type' => 'appInfoLocalizations',
                    'id' => $localizationId,
                    'attributes' => array_filter([
                        'name' => $attributes['title'] ?? null,
                        'subtitle' => $attributes['subtitle'] ?? null,
                    ], fn($v) => $v !== null),
                ],
            ];

            $response = Http::withToken($token)
                ->timeout(30)
                ->patch("{$this->baseUrl}/v1/appInfoLocalizations/{$localizationId}", $payload);

            if ($response->successful()) {
                return $response->json();
            }

            Log::error('App Store Connect updateAppInfoLocalization error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('App Store Connect updateAppInfoLocalization exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Update app store version localization (description, keywords, promotional text, what's new)
     */
    public function updateVersionLocalization(
        StoreConnection $connection,
        string $localizationId,
        array $attributes
    ): ?array {
        try {
            $token = $this->generateToken($connection->credentials);

            $payload = [
                'data' => [
                    'type' => 'appStoreVersionLocalizations',
                    'id' => $localizationId,
                    'attributes' => array_filter([
                        'description' => $attributes['description'] ?? null,
                        'keywords' => $attributes['keywords'] ?? null,
                        'promotionalText' => $attributes['promotional_text'] ?? null,
                        'whatsNew' => $attributes['whats_new'] ?? null,
                    ], fn($v) => $v !== null),
                ],
            ];

            $response = Http::withToken($token)
                ->timeout(30)
                ->patch("{$this->baseUrl}/v1/appStoreVersionLocalizations/{$localizationId}", $payload);

            if ($response->successful()) {
                return $response->json();
            }

            Log::error('App Store Connect updateVersionLocalization error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('App Store Connect updateVersionLocalization exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Publish metadata updates for a locale
     * Updates both app info localization and version localization
     */
    public function publishMetadata(
        StoreConnection $connection,
        string $appInfoLocalizationId,
        string $versionLocalizationId,
        array $metadata
    ): array {
        $results = ['success' => true, 'errors' => []];

        // Update app info (title, subtitle)
        if (!empty($metadata['title']) || !empty($metadata['subtitle'])) {
            $appInfoResult = $this->updateAppInfoLocalization($connection, $appInfoLocalizationId, [
                'title' => $metadata['title'] ?? null,
                'subtitle' => $metadata['subtitle'] ?? null,
            ]);

            if (!$appInfoResult) {
                $results['success'] = false;
                $results['errors'][] = 'Failed to update title/subtitle';
            }
        }

        // Update version (description, keywords, promotional text, what's new)
        if (!empty($metadata['description']) || !empty($metadata['keywords']) ||
            !empty($metadata['promotional_text']) || !empty($metadata['whats_new'])) {
            $versionResult = $this->updateVersionLocalization($connection, $versionLocalizationId, [
                'description' => $metadata['description'] ?? null,
                'keywords' => $metadata['keywords'] ?? null,
                'promotional_text' => $metadata['promotional_text'] ?? null,
                'whats_new' => $metadata['whats_new'] ?? null,
            ]);

            if (!$versionResult) {
                $results['success'] = false;
                $results['errors'][] = 'Failed to update description/keywords';
            }
        }

        return $results;
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

    // =========================================================================
    // ANALYTICS API METHODS (for Conversion Funnel)
    // =========================================================================

    /**
     * Request an analytics report for an app
     *
     * @param StoreConnection $connection
     * @param string $appId The App Store app ID
     * @param string $accessType ONGOING or ONE_TIME_SNAPSHOT
     * @return string|null The report request ID
     */
    public function requestAnalyticsReport(StoreConnection $connection, string $appId, string $accessType = 'ONGOING'): ?string
    {
        try {
            $token = $this->generateToken($connection->credentials);

            $payload = [
                'data' => [
                    'type' => 'analyticsReportRequests',
                    'attributes' => [
                        'accessType' => $accessType,
                    ],
                    'relationships' => [
                        'app' => [
                            'data' => [
                                'type' => 'apps',
                                'id' => $appId,
                            ],
                        ],
                    ],
                ],
            ];

            $response = Http::withToken($token)
                ->timeout(30)
                ->post("{$this->baseUrl}/v1/analyticsReportRequests", $payload);

            if ($response->successful()) {
                return $response->json('data.id');
            }

            // Check if report request already exists (409 Conflict)
            if ($response->status() === 409) {
                // Try to get existing report request
                return $this->getExistingAnalyticsReportRequest($connection, $appId);
            }

            Log::error('App Store Connect requestAnalyticsReport error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('App Store Connect requestAnalyticsReport exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Get existing analytics report request for an app
     */
    public function getExistingAnalyticsReportRequest(StoreConnection $connection, string $appId): ?string
    {
        try {
            $token = $this->generateToken($connection->credentials);

            $response = Http::withToken($token)
                ->timeout(30)
                ->get("{$this->baseUrl}/v1/apps/{$appId}/analyticsReportRequests", [
                    'filter[accessType]' => 'ONGOING',
                    'limit' => 1,
                ]);

            if ($response->successful()) {
                $data = $response->json('data');
                return $data[0]['id'] ?? null;
            }

            return null;
        } catch (\Exception $e) {
            Log::error('App Store Connect getExistingAnalyticsReportRequest exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Get analytics reports for a report request, filtered by category
     *
     * @param StoreConnection $connection
     * @param string $reportRequestId
     * @param string $category APP_STORE_ENGAGEMENT, APP_USAGE, APP_STORE_COMMERCE, etc.
     * @return array|null List of reports
     */
    public function getAnalyticsReports(StoreConnection $connection, string $reportRequestId, string $category = 'APP_STORE_ENGAGEMENT'): ?array
    {
        try {
            $token = $this->generateToken($connection->credentials);

            $response = Http::withToken($token)
                ->timeout(30)
                ->get("{$this->baseUrl}/v1/analyticsReportRequests/{$reportRequestId}/reports", [
                    'filter[category]' => $category,
                ]);

            if ($response->successful()) {
                return $response->json('data');
            }

            Log::error('App Store Connect getAnalyticsReports error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('App Store Connect getAnalyticsReports exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Get report instances for a specific report
     *
     * @param StoreConnection $connection
     * @param string $reportId
     * @return array|null List of report instances
     */
    public function getAnalyticsReportInstances(StoreConnection $connection, string $reportId): ?array
    {
        try {
            $token = $this->generateToken($connection->credentials);

            $response = Http::withToken($token)
                ->timeout(30)
                ->get("{$this->baseUrl}/v1/analyticsReports/{$reportId}/instances", [
                    'limit' => 100,
                ]);

            if ($response->successful()) {
                return $response->json('data');
            }

            Log::error('App Store Connect getAnalyticsReportInstances error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('App Store Connect getAnalyticsReportInstances exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Get report segments for a specific instance
     *
     * @param StoreConnection $connection
     * @param string $instanceId
     * @return array|null List of segments with download URLs
     */
    public function getAnalyticsReportSegments(StoreConnection $connection, string $instanceId): ?array
    {
        try {
            $token = $this->generateToken($connection->credentials);

            $response = Http::withToken($token)
                ->timeout(30)
                ->get("{$this->baseUrl}/v1/analyticsReportInstances/{$instanceId}/segments");

            if ($response->successful()) {
                return $response->json('data');
            }

            Log::error('App Store Connect getAnalyticsReportSegments error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('App Store Connect getAnalyticsReportSegments exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Download and parse analytics report data from a segment URL
     *
     * @param string $url The segment download URL
     * @return array|null Parsed report data
     */
    public function downloadAnalyticsReport(string $url): ?array
    {
        try {
            $response = Http::timeout(60)->get($url);

            if (!$response->successful()) {
                Log::error('App Store Connect downloadAnalyticsReport error', [
                    'status' => $response->status(),
                ]);
                return null;
            }

            return $this->parseAnalyticsReport($response->body());
        } catch (\Exception $e) {
            Log::error('App Store Connect downloadAnalyticsReport exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Parse analytics report (gzipped TSV/CSV)
     */
    private function parseAnalyticsReport(string $content): array
    {
        // Try to decompress if gzipped
        $decompressed = @gzdecode($content);
        if ($decompressed !== false) {
            $content = $decompressed;
        }

        $lines = explode("\n", trim($content));
        if (count($lines) < 2) {
            return [];
        }

        // Detect delimiter (tab or comma)
        $firstLine = $lines[0];
        $delimiter = str_contains($firstLine, "\t") ? "\t" : ",";

        $headers = str_getcsv(array_shift($lines), $delimiter);
        $results = [];

        foreach ($lines as $line) {
            if (empty(trim($line))) {
                continue;
            }

            $values = str_getcsv($line, $delimiter);
            if (count($values) !== count($headers)) {
                continue;
            }

            $row = array_combine($headers, $values);
            if ($row !== false) {
                $results[] = $row;
            }
        }

        return $results;
    }

    /**
     * Get conversion funnel data for an app
     *
     * @param StoreConnection $connection
     * @param string $appId
     * @param string $startDate
     * @param string $endDate
     * @return array|null Funnel data with impressions, page views, downloads by source
     */
    public function getConversionFunnelData(StoreConnection $connection, string $appId, string $startDate, string $endDate): ?array
    {
        try {
            // First, ensure we have an analytics report request
            $reportRequestId = $this->requestAnalyticsReport($connection, $appId);
            if (!$reportRequestId) {
                Log::warning('Could not create/get analytics report request for app', ['app_id' => $appId]);
                return null;
            }

            // Get APP_STORE_ENGAGEMENT reports (contains impressions, page views, downloads)
            $reports = $this->getAnalyticsReports($connection, $reportRequestId, 'APP_STORE_ENGAGEMENT');
            if (!$reports) {
                Log::warning('No APP_STORE_ENGAGEMENT reports found', ['report_request_id' => $reportRequestId]);
                return null;
            }

            $funnelData = [
                'by_date' => [],
                'by_source' => [],
                'totals' => [
                    'impressions' => 0,
                    'impressions_unique' => 0,
                    'page_views' => 0,
                    'page_views_unique' => 0,
                    'downloads' => 0,
                    'first_time_downloads' => 0,
                    'redownloads' => 0,
                ],
            ];

            // Process each report
            foreach ($reports as $report) {
                $reportName = $report['attributes']['name'] ?? '';

                // Get instances for this report
                $instances = $this->getAnalyticsReportInstances($connection, $report['id']);
                if (!$instances) {
                    continue;
                }

                foreach ($instances as $instance) {
                    $processingDate = $instance['attributes']['processingDate'] ?? null;
                    if (!$processingDate) {
                        continue;
                    }

                    // Check if date is in our range
                    if ($processingDate < $startDate || $processingDate > $endDate) {
                        continue;
                    }

                    // Get segments for this instance
                    $segments = $this->getAnalyticsReportSegments($connection, $instance['id']);
                    if (!$segments) {
                        continue;
                    }

                    foreach ($segments as $segment) {
                        $url = $segment['attributes']['url'] ?? null;
                        if (!$url) {
                            continue;
                        }

                        // Download and parse the report
                        $data = $this->downloadAnalyticsReport($url);
                        if (!$data) {
                            continue;
                        }

                        // Process the data based on report type
                        $this->processFunnelReportData($funnelData, $data, $reportName, $processingDate);
                    }
                }
            }

            return $funnelData;
        } catch (\Exception $e) {
            Log::error('App Store Connect getConversionFunnelData exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Process funnel report data and aggregate into our structure
     */
    private function processFunnelReportData(array &$funnelData, array $data, string $reportName, string $date): void
    {
        foreach ($data as $row) {
            // Map source type from Apple's naming
            $sourceType = $row['Source Type'] ?? $row['sourceType'] ?? 'total';
            $source = $this->mapAppleSourceType($sourceType);

            // Get metrics
            $impressions = (int) ($row['Impressions'] ?? $row['impressions'] ?? 0);
            $impressionsUnique = (int) ($row['Impressions Unique Devices'] ?? $row['impressionsUnique'] ?? 0);
            $pageViews = (int) ($row['Product Page Views'] ?? $row['pageViews'] ?? 0);
            $pageViewsUnique = (int) ($row['Product Page Views Unique Devices'] ?? $row['pageViewsUnique'] ?? 0);
            $downloads = (int) ($row['Total Downloads'] ?? $row['downloads'] ?? 0);
            $firstTimeDownloads = (int) ($row['First-Time Downloads'] ?? $row['firstTimeDownloads'] ?? 0);
            $redownloads = (int) ($row['Redownloads'] ?? $row['redownloads'] ?? 0);

            // Aggregate by date
            if (!isset($funnelData['by_date'][$date])) {
                $funnelData['by_date'][$date] = [
                    'date' => $date,
                    'impressions' => 0,
                    'impressions_unique' => 0,
                    'page_views' => 0,
                    'page_views_unique' => 0,
                    'downloads' => 0,
                    'first_time_downloads' => 0,
                    'redownloads' => 0,
                ];
            }

            // Aggregate by source
            if (!isset($funnelData['by_source'][$source])) {
                $funnelData['by_source'][$source] = [
                    'source' => $source,
                    'impressions' => 0,
                    'impressions_unique' => 0,
                    'page_views' => 0,
                    'page_views_unique' => 0,
                    'downloads' => 0,
                    'first_time_downloads' => 0,
                    'redownloads' => 0,
                ];
            }

            // Add to date aggregate
            $funnelData['by_date'][$date]['impressions'] += $impressions;
            $funnelData['by_date'][$date]['impressions_unique'] += $impressionsUnique;
            $funnelData['by_date'][$date]['page_views'] += $pageViews;
            $funnelData['by_date'][$date]['page_views_unique'] += $pageViewsUnique;
            $funnelData['by_date'][$date]['downloads'] += $downloads;
            $funnelData['by_date'][$date]['first_time_downloads'] += $firstTimeDownloads;
            $funnelData['by_date'][$date]['redownloads'] += $redownloads;

            // Add to source aggregate
            $funnelData['by_source'][$source]['impressions'] += $impressions;
            $funnelData['by_source'][$source]['impressions_unique'] += $impressionsUnique;
            $funnelData['by_source'][$source]['page_views'] += $pageViews;
            $funnelData['by_source'][$source]['page_views_unique'] += $pageViewsUnique;
            $funnelData['by_source'][$source]['downloads'] += $downloads;
            $funnelData['by_source'][$source]['first_time_downloads'] += $firstTimeDownloads;
            $funnelData['by_source'][$source]['redownloads'] += $redownloads;

            // Add to totals
            $funnelData['totals']['impressions'] += $impressions;
            $funnelData['totals']['impressions_unique'] += $impressionsUnique;
            $funnelData['totals']['page_views'] += $pageViews;
            $funnelData['totals']['page_views_unique'] += $pageViewsUnique;
            $funnelData['totals']['downloads'] += $downloads;
            $funnelData['totals']['first_time_downloads'] += $firstTimeDownloads;
            $funnelData['totals']['redownloads'] += $redownloads;
        }
    }

    /**
     * Map Apple's source type to our internal source naming
     */
    private function mapAppleSourceType(string $appleSource): string
    {
        return match (strtolower($appleSource)) {
            'app store search', 'search' => 'search',
            'app store browse', 'browse' => 'browse',
            'app referrer', 'app referrers' => 'app_referrer',
            'web referrer', 'web referrers' => 'web_referrer',
            'institutional purchases' => 'institutional',
            default => 'referral',
        };
    }
}
