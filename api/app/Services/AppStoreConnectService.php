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
}
