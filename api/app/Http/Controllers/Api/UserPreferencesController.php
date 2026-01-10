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
        ]);

        $user = $request->user();

        if (array_key_exists('locale', $validated)) {
            $user->locale = $validated['locale'];
        }

        $user->save();

        return response()->json([
            'message' => 'Preferences updated successfully',
            'data' => [
                'locale' => $user->locale,
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
            ],
        ]);
    }
}
