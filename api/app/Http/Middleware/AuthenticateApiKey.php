<?php

namespace App\Http\Middleware;

use App\Models\User;
use App\Services\PlanService;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Symfony\Component\HttpFoundation\Response;

class AuthenticateApiKey
{
    public function __construct(
        private PlanService $planService
    ) {}

    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $apiKey = $request->header('X-API-Key') ?? $request->query('api_key');

        if (! $apiKey) {
            return response()->json([
                'error' => 'missing_api_key',
                'message' => 'API key is required. Pass it via X-API-Key header or api_key query parameter.',
            ], 401);
        }

        // API keys are stored hashed, we need to find by checking each user
        // In production, you'd want to use a dedicated api_keys table with indexed lookup
        // For now, we'll store API key as a hash prefix for faster lookup

        // Expected format: user_id:random_string
        $parts = explode(':', $apiKey);
        if (count($parts) !== 2) {
            return response()->json([
                'error' => 'invalid_api_key',
                'message' => 'Invalid API key format.',
            ], 401);
        }

        [$userId, $secret] = $parts;

        $user = User::find($userId);

        if (! $user || ! $user->api_key_hash || ! Hash::check($apiKey, $user->api_key_hash)) {
            return response()->json([
                'error' => 'invalid_api_key',
                'message' => 'Invalid API key.',
            ], 401);
        }

        // Check if user has API access
        if (! $this->planService->hasFeature($user, 'api_access')) {
            return response()->json([
                'error' => 'api_access_denied',
                'message' => 'API access is not available on your plan. Please upgrade to Business.',
            ], 403);
        }

        // Attach user to request
        $request->attributes->set('api_user', $user);

        return $next($request);
    }
}
