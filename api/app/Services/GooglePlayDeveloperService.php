<?php

namespace App\Services;

use App\Models\StoreConnection;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class GooglePlayDeveloperService
{
    private string $baseUrl = 'https://androidpublisher.googleapis.com/androidpublisher/v3';

    /**
     * Get access token from refresh token
     */
    private function getAccessToken(array $credentials): ?string
    {
        try {
            $response = Http::asForm()->post('https://oauth2.googleapis.com/token', [
                'client_id' => $credentials['client_id'],
                'client_secret' => $credentials['client_secret'],
                'refresh_token' => $credentials['refresh_token'],
                'grant_type' => 'refresh_token',
            ]);

            if ($response->successful()) {
                return $response->json('access_token');
            }

            Log::error('Google OAuth token refresh failed', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('Google OAuth exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Fetch reviews for an app
     */
    public function getReviews(StoreConnection $connection, string $packageName): ?array
    {
        try {
            $token = $this->getAccessToken($connection->credentials);
            if (!$token) {
                $connection->markAsExpired();
                return null;
            }

            $response = Http::withToken($token)
                ->timeout(30)
                ->get("{$this->baseUrl}/applications/{$packageName}/reviews");

            if ($response->successful()) {
                return $response->json();
            }

            if ($response->status() === 401) {
                $connection->markAsExpired();
            }

            Log::error('Google Play API error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('Google Play API exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Reply to a review
     */
    public function replyToReview(StoreConnection $connection, string $packageName, string $reviewId, string $replyText): ?array
    {
        try {
            $token = $this->getAccessToken($connection->credentials);
            if (!$token) {
                $connection->markAsExpired();
                return null;
            }

            $response = Http::withToken($token)
                ->timeout(30)
                ->post("{$this->baseUrl}/applications/{$packageName}/reviews/{$reviewId}:reply", [
                    'replyText' => $replyText,
                ]);

            if ($response->successful()) {
                return $response->json();
            }

            Log::error('Google Play reply error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('Google Play reply exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Validate credentials
     */
    public function validateCredentials(array $credentials): bool
    {
        $token = $this->getAccessToken($credentials);
        return $token !== null;
    }

    /**
     * Get sales/installs report for a specific month
     *
     * Google Play reports are monthly and stored in Cloud Storage
     * Returns array of data grouped by package and country
     */
    public function getSalesReport(StoreConnection $connection, int $year, int $month): ?array
    {
        try {
            $token = $this->getAccessToken($connection->credentials);
            if (!$token) {
                $connection->markAsExpired();
                return null;
            }

            $bucketId = $connection->credentials['bucket_id'] ?? null;
            if (!$bucketId) {
                Log::warning('Google Play bucket_id not configured');
                return [];
            }

            // Google Play stores reports in format: stats/installs/installs_<package>_YYYYMM_<country>.csv
            $yearMonth = sprintf('%04d%02d', $year, $month);
            $reportPath = "stats/installs/installs_{$yearMonth}_overview.csv";

            $storageUrl = "https://storage.googleapis.com/storage/v1/b/{$bucketId}/o/" . urlencode($reportPath) . "?alt=media";

            $response = Http::withToken($token)
                ->timeout(60)
                ->get($storageUrl);

            if ($response->status() === 404) {
                // Report not available yet
                return [];
            }

            if (!$response->successful()) {
                if ($response->status() === 401 || $response->status() === 403) {
                    $connection->markAsExpired();
                }
                Log::error('Google Play sales report error', [
                    'status' => $response->status(),
                    'body' => $response->body(),
                ]);
                return null;
            }

            return $this->parseInstallsReport($response->body());
        } catch (\Exception $e) {
            Log::error('Google Play sales report exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Get earnings report for a specific month
     */
    public function getEarningsReport(StoreConnection $connection, int $year, int $month): ?array
    {
        try {
            $token = $this->getAccessToken($connection->credentials);
            if (!$token) {
                $connection->markAsExpired();
                return null;
            }

            $bucketId = $connection->credentials['bucket_id'] ?? null;
            if (!$bucketId) {
                return [];
            }

            $yearMonth = sprintf('%04d%02d', $year, $month);
            $reportPath = "earnings/earnings_{$yearMonth}.csv";

            $storageUrl = "https://storage.googleapis.com/storage/v1/b/{$bucketId}/o/" . urlencode($reportPath) . "?alt=media";

            $response = Http::withToken($token)
                ->timeout(60)
                ->get($storageUrl);

            if ($response->status() === 404) {
                return [];
            }

            if (!$response->successful()) {
                if ($response->status() === 401 || $response->status() === 403) {
                    $connection->markAsExpired();
                }
                Log::error('Google Play earnings report error', [
                    'status' => $response->status(),
                    'body' => $response->body(),
                ]);
                return null;
            }

            return $this->parseEarningsReport($response->body());
        } catch (\Exception $e) {
            Log::error('Google Play earnings report exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Get subscription report for a specific month
     */
    public function getSubscriptionReport(StoreConnection $connection, int $year, int $month): ?array
    {
        try {
            $token = $this->getAccessToken($connection->credentials);
            if (!$token) {
                $connection->markAsExpired();
                return null;
            }

            $bucketId = $connection->credentials['bucket_id'] ?? null;
            if (!$bucketId) {
                return [];
            }

            $yearMonth = sprintf('%04d%02d', $year, $month);
            $reportPath = "stats/subscriptions/subscriptions_{$yearMonth}_overview.csv";

            $storageUrl = "https://storage.googleapis.com/storage/v1/b/{$bucketId}/o/" . urlencode($reportPath) . "?alt=media";

            $response = Http::withToken($token)
                ->timeout(60)
                ->get($storageUrl);

            if ($response->status() === 404) {
                return [];
            }

            if (!$response->successful()) {
                if ($response->status() === 401 || $response->status() === 403) {
                    $connection->markAsExpired();
                }
                Log::error('Google Play subscription report error', [
                    'status' => $response->status(),
                    'body' => $response->body(),
                ]);
                return null;
            }

            return $this->parseSubscriptionReport($response->body());
        } catch (\Exception $e) {
            Log::error('Google Play subscription report exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Parse installs CSV report
     */
    private function parseInstallsReport(string $csvContent): array
    {
        $lines = explode("\n", trim($csvContent));
        if (count($lines) < 2) {
            return [];
        }

        $headers = str_getcsv(array_shift($lines));
        $results = [];

        foreach ($lines as $line) {
            if (empty(trim($line))) {
                continue;
            }

            $values = str_getcsv($line);
            $row = array_combine($headers, $values);

            if ($row === false) {
                continue;
            }

            $packageName = $row['Package Name'] ?? null;
            $country = $row['Country'] ?? 'WW';
            $date = $row['Date'] ?? null;

            if (!$packageName || !$date) {
                continue;
            }

            $key = "{$packageName}_{$country}_{$date}";

            if (!isset($results[$key])) {
                $results[$key] = [
                    'package_name' => $packageName,
                    'country_code' => $country,
                    'date' => $date,
                    'downloads' => 0,
                    'updates' => 0,
                    'uninstalls' => 0,
                ];
            }

            $results[$key]['downloads'] += (int) ($row['Daily Device Installs'] ?? $row['Store Listing Acquisitions'] ?? 0);
            $results[$key]['updates'] += (int) ($row['Daily Device Updates'] ?? $row['Update Device Installs'] ?? 0);
            $results[$key]['uninstalls'] += (int) ($row['Daily Device Uninstalls'] ?? 0);
        }

        return array_values($results);
    }

    /**
     * Parse earnings CSV report
     */
    private function parseEarningsReport(string $csvContent): array
    {
        $lines = explode("\n", trim($csvContent));
        if (count($lines) < 2) {
            return [];
        }

        $headers = str_getcsv(array_shift($lines));
        $results = [];

        foreach ($lines as $line) {
            if (empty(trim($line))) {
                continue;
            }

            $values = str_getcsv($line);
            $row = array_combine($headers, $values);

            if ($row === false) {
                continue;
            }

            $packageName = $row['Product ID'] ?? $row['Package Name'] ?? null;
            $country = $row['Buyer Country'] ?? 'WW';

            if (!$packageName) {
                continue;
            }

            $key = "{$packageName}_{$country}";

            if (!isset($results[$key])) {
                $results[$key] = [
                    'package_name' => $packageName,
                    'country_code' => $country,
                    'revenue' => 0,
                    'proceeds' => 0,
                    'refunds' => 0,
                ];
            }

            $amount = (float) ($row['Amount (Merchant Currency)'] ?? $row['Charged Amount'] ?? 0);
            $transactionType = $row['Transaction Type'] ?? '';

            if (stripos($transactionType, 'refund') !== false) {
                $results[$key]['refunds'] += abs($amount);
            } else {
                $results[$key]['revenue'] += $amount;
                // Google takes 15-30% cut, estimate proceeds at 70%
                $results[$key]['proceeds'] += $amount * 0.7;
            }
        }

        return array_values($results);
    }

    /**
     * Parse subscription CSV report
     */
    private function parseSubscriptionReport(string $csvContent): array
    {
        $lines = explode("\n", trim($csvContent));
        if (count($lines) < 2) {
            return [];
        }

        $headers = str_getcsv(array_shift($lines));
        $results = [];

        foreach ($lines as $line) {
            if (empty(trim($line))) {
                continue;
            }

            $values = str_getcsv($line);
            $row = array_combine($headers, $values);

            if ($row === false) {
                continue;
            }

            $packageName = $row['Package Name'] ?? null;
            $country = $row['Country'] ?? 'WW';

            if (!$packageName) {
                continue;
            }

            $key = "{$packageName}_{$country}";

            if (!isset($results[$key])) {
                $results[$key] = [
                    'package_name' => $packageName,
                    'country_code' => $country,
                    'subscribers_new' => 0,
                    'subscribers_cancelled' => 0,
                    'subscribers_active' => 0,
                ];
            }

            $results[$key]['subscribers_new'] += (int) ($row['New Subscriptions'] ?? 0);
            $results[$key]['subscribers_cancelled'] += (int) ($row['Cancelled Subscriptions'] ?? 0);
            $results[$key]['subscribers_active'] += (int) ($row['Active Subscriptions'] ?? 0);
        }

        return array_values($results);
    }
}
