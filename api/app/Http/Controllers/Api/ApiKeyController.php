<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\PlanService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class ApiKeyController extends Controller
{
    public function __construct(
        private PlanService $planService
    ) {}

    /**
     * Get API key status (not the actual key)
     */
    public function status(Request $request): JsonResponse
    {
        $user = $request->user();
        $hasApiAccess = $this->planService->hasFeature($user, 'api_access');

        return response()->json([
            'has_api_access' => $hasApiAccess,
            'has_api_key' => $user->api_key_hash !== null,
            'api_key_created_at' => $user->api_key_created_at?->toIso8601String(),
        ]);
    }

    /**
     * Generate a new API key (or regenerate if one exists)
     */
    public function generate(Request $request): JsonResponse
    {
        $user = $request->user();

        // Check if user has API access
        if (! $this->planService->hasFeature($user, 'api_access')) {
            return response()->json([
                'error' => 'api_access_denied',
                'message' => 'API access is not available on your plan. Please upgrade to Business.',
            ], 403);
        }

        // Generate new API key
        $secret = Str::random(32);
        $apiKey = "{$user->id}:{$secret}";

        // Store hashed version
        $user->api_key_hash = Hash::make($apiKey);
        $user->api_key_created_at = now();
        $user->save();

        return response()->json([
            'api_key' => $apiKey,
            'message' => 'API key generated. Store it securely - it cannot be retrieved again.',
            'created_at' => $user->api_key_created_at->toIso8601String(),
        ]);
    }

    /**
     * Revoke the API key
     */
    public function revoke(Request $request): JsonResponse
    {
        $user = $request->user();

        if (! $user->api_key_hash) {
            return response()->json([
                'error' => 'no_api_key',
                'message' => 'No API key to revoke.',
            ], 400);
        }

        $user->api_key_hash = null;
        $user->api_key_created_at = null;
        $user->save();

        return response()->json([
            'message' => 'API key revoked successfully.',
        ]);
    }
}
