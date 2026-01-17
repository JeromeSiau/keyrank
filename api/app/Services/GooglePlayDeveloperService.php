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

    // ========================================
    // Metadata Editing Methods
    // ========================================

    /**
     * Create an Edit session (required before any metadata changes)
     *
     * @return string|null The edit ID or null on failure
     */
    public function createEdit(StoreConnection $connection, string $packageName): ?string
    {
        try {
            $token = $this->getAccessToken($connection->credentials);
            if (!$token) {
                $connection->markAsExpired();
                return null;
            }

            $response = Http::withToken($token)
                ->timeout(30)
                ->post("{$this->baseUrl}/applications/{$packageName}/edits");

            if ($response->successful()) {
                return $response->json('id');
            }

            if ($response->status() === 401) {
                $connection->markAsExpired();
            }

            Log::error('Google Play create edit error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('Google Play create edit exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Delete/cancel an Edit session
     */
    public function deleteEdit(StoreConnection $connection, string $packageName, string $editId): bool
    {
        try {
            $token = $this->getAccessToken($connection->credentials);
            if (!$token) {
                return false;
            }

            $response = Http::withToken($token)
                ->timeout(30)
                ->delete("{$this->baseUrl}/applications/{$packageName}/edits/{$editId}");

            return $response->successful() || $response->status() === 404;
        } catch (\Exception $e) {
            Log::error('Google Play delete edit exception', ['error' => $e->getMessage()]);
            return false;
        }
    }

    /**
     * Get all listings for an Edit
     *
     * @return array|null Array of listings by language or null on failure
     */
    public function getListings(StoreConnection $connection, string $packageName, string $editId): ?array
    {
        try {
            $token = $this->getAccessToken($connection->credentials);
            if (!$token) {
                $connection->markAsExpired();
                return null;
            }

            $response = Http::withToken($token)
                ->timeout(30)
                ->get("{$this->baseUrl}/applications/{$packageName}/edits/{$editId}/listings");

            if ($response->successful()) {
                return $response->json('listings', []);
            }

            if ($response->status() === 401) {
                $connection->markAsExpired();
            }

            Log::error('Google Play get listings error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('Google Play get listings exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Get a specific listing for a language
     */
    public function getListing(StoreConnection $connection, string $packageName, string $editId, string $language): ?array
    {
        try {
            $token = $this->getAccessToken($connection->credentials);
            if (!$token) {
                $connection->markAsExpired();
                return null;
            }

            $response = Http::withToken($token)
                ->timeout(30)
                ->get("{$this->baseUrl}/applications/{$packageName}/edits/{$editId}/listings/{$language}");

            if ($response->successful()) {
                return $response->json();
            }

            if ($response->status() === 404) {
                return null; // Language not configured
            }

            if ($response->status() === 401) {
                $connection->markAsExpired();
            }

            Log::error('Google Play get listing error', [
                'language' => $language,
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('Google Play get listing exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Update a listing for a specific language
     *
     * @param array $data Keys: title, fullDescription, shortDescription, video
     */
    public function updateListing(
        StoreConnection $connection,
        string $packageName,
        string $editId,
        string $language,
        array $data
    ): ?array {
        try {
            $token = $this->getAccessToken($connection->credentials);
            if (!$token) {
                $connection->markAsExpired();
                return null;
            }

            // Build request body with only provided fields
            $body = ['language' => $language];
            if (isset($data['title'])) {
                $body['title'] = $data['title'];
            }
            if (isset($data['fullDescription'])) {
                $body['fullDescription'] = $data['fullDescription'];
            }
            if (isset($data['shortDescription'])) {
                $body['shortDescription'] = $data['shortDescription'];
            }
            if (isset($data['video'])) {
                $body['video'] = $data['video'];
            }

            $response = Http::withToken($token)
                ->timeout(30)
                ->put(
                    "{$this->baseUrl}/applications/{$packageName}/edits/{$editId}/listings/{$language}",
                    $body
                );

            if ($response->successful()) {
                return $response->json();
            }

            if ($response->status() === 401) {
                $connection->markAsExpired();
            }

            Log::error('Google Play update listing error', [
                'language' => $language,
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('Google Play update listing exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Get release notes (what's new) for a track
     */
    public function getTrackReleaseNotes(
        StoreConnection $connection,
        string $packageName,
        string $editId,
        string $track = 'production'
    ): ?array {
        try {
            $token = $this->getAccessToken($connection->credentials);
            if (!$token) {
                $connection->markAsExpired();
                return null;
            }

            $response = Http::withToken($token)
                ->timeout(30)
                ->get("{$this->baseUrl}/applications/{$packageName}/edits/{$editId}/tracks/{$track}");

            if ($response->successful()) {
                $data = $response->json();
                // Extract release notes from the latest release
                $releases = $data['releases'] ?? [];
                if (!empty($releases)) {
                    $latest = $releases[0];
                    return $latest['releaseNotes'] ?? [];
                }
                return [];
            }

            if ($response->status() === 404) {
                return []; // Track not found
            }

            if ($response->status() === 401) {
                $connection->markAsExpired();
            }

            return null;
        } catch (\Exception $e) {
            Log::error('Google Play get track exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Commit an Edit to publish changes
     */
    public function commitEdit(StoreConnection $connection, string $packageName, string $editId): bool
    {
        try {
            $token = $this->getAccessToken($connection->credentials);
            if (!$token) {
                $connection->markAsExpired();
                return false;
            }

            $response = Http::withToken($token)
                ->timeout(60)
                ->post("{$this->baseUrl}/applications/{$packageName}/edits/{$editId}:commit");

            if ($response->successful()) {
                return true;
            }

            if ($response->status() === 401) {
                $connection->markAsExpired();
            }

            Log::error('Google Play commit edit error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return false;
        } catch (\Exception $e) {
            Log::error('Google Play commit edit exception', ['error' => $e->getMessage()]);
            return false;
        }
    }

    /**
     * Get all app metadata (listings + release notes) in one call
     *
     * Creates a temporary edit, fetches data, then deletes the edit
     */
    public function getAppMetadata(StoreConnection $connection, string $packageName): ?array
    {
        $editId = $this->createEdit($connection, $packageName);
        if (!$editId) {
            return null;
        }

        try {
            $listings = $this->getListings($connection, $packageName, $editId);
            if ($listings === null) {
                $this->deleteEdit($connection, $packageName, $editId);
                return null;
            }

            // Get release notes for production track
            $releaseNotes = $this->getTrackReleaseNotes($connection, $packageName, $editId, 'production');

            // Map release notes by language
            $releaseNotesByLang = [];
            if ($releaseNotes) {
                foreach ($releaseNotes as $note) {
                    $lang = $note['language'] ?? null;
                    if ($lang) {
                        $releaseNotesByLang[$lang] = $note['text'] ?? '';
                    }
                }
            }

            // Format response
            $locales = [];
            foreach ($listings as $listing) {
                $lang = $listing['language'];
                $locales[$lang] = [
                    'locale' => $lang,
                    'title' => $listing['title'] ?? null,
                    'short_description' => $listing['shortDescription'] ?? null,
                    'full_description' => $listing['fullDescription'] ?? null,
                    'video' => $listing['video'] ?? null,
                    'whats_new' => $releaseNotesByLang[$lang] ?? null,
                ];
            }

            // Clean up the edit
            $this->deleteEdit($connection, $packageName, $editId);

            return [
                'package_name' => $packageName,
                'locales' => array_values($locales),
            ];
        } catch (\Exception $e) {
            $this->deleteEdit($connection, $packageName, $editId);
            Log::error('Google Play get metadata exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Publish metadata changes for specific locales
     *
     * @param array $localeData Array of locale => [title, description, shortDescription, whatsNew]
     */
    public function publishMetadata(StoreConnection $connection, string $packageName, array $localeData): array
    {
        $editId = $this->createEdit($connection, $packageName);
        if (!$editId) {
            return ['success' => false, 'errors' => ['Failed to create edit session']];
        }

        $errors = [];
        $updated = [];

        try {
            foreach ($localeData as $locale => $data) {
                // Update listing (title, descriptions)
                $listingData = [];
                if (isset($data['title'])) {
                    $listingData['title'] = $data['title'];
                }
                if (isset($data['description'])) {
                    $listingData['fullDescription'] = $data['description'];
                }
                if (isset($data['short_description'])) {
                    $listingData['shortDescription'] = $data['short_description'];
                }

                if (!empty($listingData)) {
                    $result = $this->updateListing($connection, $packageName, $editId, $locale, $listingData);
                    if ($result === null) {
                        $errors[] = "Failed to update listing for {$locale}";
                    } else {
                        $updated[] = $locale;
                    }
                }

                // Note: Updating release notes (what's new) requires updating track releases
                // which is more complex and typically done during app release
                // For now, we only update listings
            }

            if (empty($errors) && !empty($updated)) {
                $committed = $this->commitEdit($connection, $packageName, $editId);
                if (!$committed) {
                    return ['success' => false, 'errors' => ['Failed to commit changes']];
                }
                return ['success' => true, 'updated' => $updated];
            }

            // Cleanup on failure
            $this->deleteEdit($connection, $packageName, $editId);
            return ['success' => false, 'errors' => $errors];
        } catch (\Exception $e) {
            $this->deleteEdit($connection, $packageName, $editId);
            return ['success' => false, 'errors' => [$e->getMessage()]];
        }
    }

    /**
     * Character limits for Google Play metadata
     */
    public static function getMetadataLimits(): array
    {
        return [
            'title' => 30,
            'short_description' => 80,
            'description' => 4000,
            'whats_new' => 500,
        ];
    }

    /**
     * Get supported languages for Google Play
     */
    public static function getSupportedLanguages(): array
    {
        return [
            'en-US' => 'English (US)',
            'en-GB' => 'English (UK)',
            'fr-FR' => 'French',
            'de-DE' => 'German',
            'es-ES' => 'Spanish (Spain)',
            'es-419' => 'Spanish (Latin America)',
            'it-IT' => 'Italian',
            'pt-BR' => 'Portuguese (Brazil)',
            'pt-PT' => 'Portuguese (Portugal)',
            'ja-JP' => 'Japanese',
            'ko-KR' => 'Korean',
            'zh-CN' => 'Chinese (Simplified)',
            'zh-TW' => 'Chinese (Traditional)',
            'ru-RU' => 'Russian',
            'ar' => 'Arabic',
            'nl-NL' => 'Dutch',
            'pl-PL' => 'Polish',
            'tr-TR' => 'Turkish',
            'th' => 'Thai',
            'vi' => 'Vietnamese',
            'id' => 'Indonesian',
            'hi-IN' => 'Hindi',
            'he' => 'Hebrew',
            'cs-CZ' => 'Czech',
            'el-GR' => 'Greek',
            'hu-HU' => 'Hungarian',
            'ro' => 'Romanian',
            'sk' => 'Slovak',
            'uk' => 'Ukrainian',
            'da-DK' => 'Danish',
            'fi-FI' => 'Finnish',
            'no-NO' => 'Norwegian',
            'sv-SE' => 'Swedish',
        ];
    }

    // =========================================================================
    // CONVERSION FUNNEL METHODS
    // =========================================================================

    /**
     * Get acquisition report for a specific month
     *
     * This report contains store listing visitors (impressions) and acquisitions (installs)
     */
    public function getAcquisitionReport(StoreConnection $connection, int $year, int $month): ?array
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

            $yearMonth = sprintf('%04d%02d', $year, $month);
            $reportPath = "stats/store_performance/store_performance_{$yearMonth}_overview.csv";

            $storageUrl = "https://storage.googleapis.com/storage/v1/b/{$bucketId}/o/" . urlencode($reportPath) . "?alt=media";

            $response = Http::withToken($token)
                ->timeout(60)
                ->get($storageUrl);

            if ($response->status() === 404) {
                // Try alternative path format
                $reportPath = "stats/acquisition/acquisition_{$yearMonth}.csv";
                $storageUrl = "https://storage.googleapis.com/storage/v1/b/{$bucketId}/o/" . urlencode($reportPath) . "?alt=media";

                $response = Http::withToken($token)
                    ->timeout(60)
                    ->get($storageUrl);

                if ($response->status() === 404) {
                    return [];
                }
            }

            if (!$response->successful()) {
                if ($response->status() === 401 || $response->status() === 403) {
                    $connection->markAsExpired();
                }
                Log::error('Google Play acquisition report error', [
                    'status' => $response->status(),
                    'body' => $response->body(),
                ]);
                return null;
            }

            return $this->parseAcquisitionReport($response->body());
        } catch (\Exception $e) {
            Log::error('Google Play acquisition report exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Parse acquisition CSV report
     */
    private function parseAcquisitionReport(string $csvContent): array
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
            if (count($values) !== count($headers)) {
                continue;
            }

            $row = array_combine($headers, $values);
            if ($row === false) {
                continue;
            }

            $packageName = $row['Package Name'] ?? null;
            $country = $row['Country'] ?? $row['Country Code'] ?? 'WW';
            $date = $row['Date'] ?? null;
            $source = $this->mapGoogleAcquisitionSource($row['Acquisition Channel'] ?? $row['Traffic Source'] ?? 'organic');

            if (!$packageName || !$date) {
                continue;
            }

            $key = "{$packageName}_{$country}_{$date}_{$source}";

            if (!isset($results[$key])) {
                $results[$key] = [
                    'package_name' => $packageName,
                    'country_code' => $country,
                    'date' => $date,
                    'source' => $source,
                    'impressions' => 0,         // Store listing visitors
                    'page_views' => 0,          // Store listing visitors (same for Google)
                    'downloads' => 0,           // Store listing acquisitions
                    'first_time_downloads' => 0,
                    'returning_users' => 0,
                ];
            }

            // Google Play metrics
            $visitors = (int) ($row['Store Listing Visitors'] ?? $row['Visitors'] ?? 0);
            $acquisitions = (int) ($row['Store Listing Acquisitions'] ?? $row['Installers'] ?? 0);
            $firstTimeInstallers = (int) ($row['First-time Installers'] ?? $row['New Users'] ?? 0);
            $returningUsers = (int) ($row['Returning Users'] ?? 0);

            $results[$key]['impressions'] += $visitors;
            $results[$key]['page_views'] += $visitors;  // For Google, visitors = page views
            $results[$key]['downloads'] += $acquisitions;
            $results[$key]['first_time_downloads'] += $firstTimeInstallers;
            $results[$key]['returning_users'] += $returningUsers;
        }

        return array_values($results);
    }

    /**
     * Map Google acquisition channel to our internal source naming
     */
    private function mapGoogleAcquisitionSource(string $googleSource): string
    {
        $normalized = strtolower(trim($googleSource));

        return match (true) {
            str_contains($normalized, 'organic') || str_contains($normalized, 'search') => 'search',
            str_contains($normalized, 'explore') || str_contains($normalized, 'browse') => 'browse',
            str_contains($normalized, 'third-party') || str_contains($normalized, 'referral') => 'referral',
            str_contains($normalized, 'google ads') || str_contains($normalized, 'uac') => 'app_ads',
            str_contains($normalized, 'play games') => 'app_referrer',
            default => 'referral',
        };
    }

    /**
     * Get conversion funnel data for an app
     *
     * @param StoreConnection $connection
     * @param string $packageName
     * @param string $startDate YYYY-MM-DD
     * @param string $endDate YYYY-MM-DD
     * @return array|null Funnel data with impressions, page views, downloads by source
     */
    public function getConversionFunnelData(StoreConnection $connection, string $packageName, string $startDate, string $endDate): ?array
    {
        try {
            // Parse date range to determine which months to fetch
            $start = \Carbon\Carbon::parse($startDate);
            $end = \Carbon\Carbon::parse($endDate);

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

            // Fetch reports for each month in the range
            $current = $start->copy()->startOfMonth();
            while ($current <= $end) {
                $report = $this->getAcquisitionReport($connection, $current->year, $current->month);

                if ($report) {
                    foreach ($report as $row) {
                        // Filter by package name
                        if ($row['package_name'] !== $packageName) {
                            continue;
                        }

                        // Filter by date range
                        $date = $row['date'];
                        if ($date < $startDate || $date > $endDate) {
                            continue;
                        }

                        $source = $row['source'];

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

                        $impressions = $row['impressions'];
                        $pageViews = $row['page_views'];
                        $downloads = $row['downloads'];
                        $firstTime = $row['first_time_downloads'];
                        $returning = $row['returning_users'] ?? 0;

                        // Add to date aggregate
                        $funnelData['by_date'][$date]['impressions'] += $impressions;
                        $funnelData['by_date'][$date]['page_views'] += $pageViews;
                        $funnelData['by_date'][$date]['downloads'] += $downloads;
                        $funnelData['by_date'][$date]['first_time_downloads'] += $firstTime;
                        $funnelData['by_date'][$date]['redownloads'] += $returning;

                        // Add to source aggregate
                        $funnelData['by_source'][$source]['impressions'] += $impressions;
                        $funnelData['by_source'][$source]['page_views'] += $pageViews;
                        $funnelData['by_source'][$source]['downloads'] += $downloads;
                        $funnelData['by_source'][$source]['first_time_downloads'] += $firstTime;
                        $funnelData['by_source'][$source]['redownloads'] += $returning;

                        // Add to totals
                        $funnelData['totals']['impressions'] += $impressions;
                        $funnelData['totals']['page_views'] += $pageViews;
                        $funnelData['totals']['downloads'] += $downloads;
                        $funnelData['totals']['first_time_downloads'] += $firstTime;
                        $funnelData['totals']['redownloads'] += $returning;
                    }
                }

                $current->addMonth();
            }

            return $funnelData;
        } catch (\Exception $e) {
            Log::error('Google Play getConversionFunnelData exception', ['error' => $e->getMessage()]);
            return null;
        }
    }
}
