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
}
