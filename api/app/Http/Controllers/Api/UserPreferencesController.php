<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UserPreferencesController extends Controller
{
    /**
     * Supported locales
     */
    private const SUPPORTED_LOCALES = ['en', 'fr', 'de', 'es', 'pt', 'it', 'ja', 'ko', 'zh', 'tr'];

    /**
     * Update user preferences
     */
    public function update(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'locale' => 'sometimes|nullable|string|in:' . implode(',', self::SUPPORTED_LOCALES),
            'timezone' => 'sometimes|nullable|string|timezone',
            'quiet_hours_start' => 'sometimes|nullable|date_format:H:i:s',
            'quiet_hours_end' => 'sometimes|nullable|date_format:H:i:s',
        ]);

        $user = $request->user();

        if (array_key_exists('locale', $validated)) {
            $user->locale = $validated['locale'];
        }

        if (array_key_exists('timezone', $validated)) {
            $user->timezone = $validated['timezone'];
        }

        if (array_key_exists('quiet_hours_start', $validated)) {
            $user->quiet_hours_start = $validated['quiet_hours_start'];
        }

        if (array_key_exists('quiet_hours_end', $validated)) {
            $user->quiet_hours_end = $validated['quiet_hours_end'];
        }

        $user->save();

        return response()->json([
            'message' => 'Preferences updated successfully',
            'data' => [
                'locale' => $user->locale,
                'timezone' => $user->timezone,
                'quiet_hours_start' => $user->quiet_hours_start?->format('H:i:s'),
                'quiet_hours_end' => $user->quiet_hours_end?->format('H:i:s'),
            ],
        ]);
    }

    /**
     * Get user preferences
     */
    public function show(Request $request): JsonResponse
    {
        $user = $request->user();

        return response()->json([
            'data' => [
                'locale' => $user->locale,
                'timezone' => $user->timezone,
                'quiet_hours_start' => $user->quiet_hours_start?->format('H:i:s'),
                'quiet_hours_end' => $user->quiet_hours_end?->format('H:i:s'),
            ],
        ]);
    }

    /**
     * Update FCM token for push notifications
     */
    public function updateFcmToken(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'fcm_token' => 'required|string|max:255',
        ]);

        $request->user()->update(['fcm_token' => $validated['fcm_token']]);

        return response()->json(['success' => true]);
    }
}
