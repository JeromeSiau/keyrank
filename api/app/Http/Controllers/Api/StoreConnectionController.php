<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\StoreConnection;
use App\Services\AppStoreConnectService;
use App\Services\GooglePlayDeveloperService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Validation\Rule;

class StoreConnectionController extends Controller
{
    public function __construct(
        private AppStoreConnectService $appStoreService,
        private GooglePlayDeveloperService $googlePlayService,
    ) {}

    public function index(Request $request): JsonResponse
    {
        $connections = StoreConnection::where('user_id', $request->user()->id)
            ->orderByDesc('created_at')
            ->get();

        return response()->json(['data' => $connections]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'platform' => [
                'required',
                'string',
                'in:ios,android',
                Rule::unique('store_connections')->where('user_id', $request->user()->id),
            ],
            'name' => 'required|string|max:255',
            // iOS credentials
            'key_id' => 'required_if:platform,ios|string|max:255',
            'issuer_id' => 'required_if:platform,ios|string|max:255',
            'private_key' => 'required_if:platform,ios|string',
            // Android credentials
            'client_id' => 'required_if:platform,android|string|max:255',
            'client_secret' => 'required_if:platform,android|string|max:255',
            'refresh_token' => 'required_if:platform,android|string',
        ]);

        $credentials = $this->buildCredentials($validated);

        // Validate credentials with the appropriate service
        if (!$this->validateWithService($validated['platform'], $credentials)) {
            $message = $validated['platform'] === 'ios'
                ? 'Invalid credentials. Please verify your App Store Connect API key.'
                : 'Invalid credentials. Please verify your Google Play Console OAuth credentials.';

            return response()->json(['message' => $message], 422);
        }

        $connection = StoreConnection::create([
            'user_id' => $request->user()->id,
            'platform' => $validated['platform'],
            'credentials' => $credentials,
            'connected_at' => now(),
            'status' => 'active',
        ]);

        return response()->json(['data' => $connection], 201);
    }

    public function show(Request $request, StoreConnection $storeConnection): JsonResponse
    {
        if ($storeConnection->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        return response()->json(['data' => $storeConnection]);
    }

    public function update(Request $request, StoreConnection $storeConnection): JsonResponse
    {
        if ($storeConnection->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $rules = [
            'name' => 'sometimes|string|max:255',
        ];

        // Add platform-specific rules based on existing connection
        if ($storeConnection->platform === 'ios') {
            $rules += [
                'key_id' => 'sometimes|string|max:255',
                'issuer_id' => 'sometimes|string|max:255',
                'private_key' => 'sometimes|string',
            ];
        } else {
            $rules += [
                'client_id' => 'sometimes|string|max:255',
                'client_secret' => 'sometimes|string|max:255',
                'refresh_token' => 'sometimes|string',
            ];
        }

        $validated = $request->validate($rules);

        // Merge with existing credentials
        $existingCredentials = $storeConnection->credentials;
        $newCredentials = $this->buildCredentials(array_merge(
            ['platform' => $storeConnection->platform],
            ['name' => $existingCredentials['name'] ?? ''],
            $storeConnection->platform === 'ios'
                ? [
                    'key_id' => $existingCredentials['key_id'] ?? '',
                    'issuer_id' => $existingCredentials['issuer_id'] ?? '',
                    'private_key' => $existingCredentials['private_key'] ?? '',
                ]
                : [
                    'client_id' => $existingCredentials['client_id'] ?? '',
                    'client_secret' => $existingCredentials['client_secret'] ?? '',
                    'refresh_token' => $existingCredentials['refresh_token'] ?? '',
                ],
            $validated,
        ));

        // Validate updated credentials
        if (!$this->validateWithService($storeConnection->platform, $newCredentials)) {
            $message = $storeConnection->platform === 'ios'
                ? 'Invalid credentials. Please verify your App Store Connect API key.'
                : 'Invalid credentials. Please verify your Google Play Console OAuth credentials.';

            return response()->json(['message' => $message], 422);
        }

        $storeConnection->update([
            'credentials' => $newCredentials,
            'status' => 'active', // Reset status on credential update
        ]);

        return response()->json(['data' => $storeConnection->fresh()]);
    }

    public function destroy(Request $request, StoreConnection $storeConnection): Response|JsonResponse
    {
        if ($storeConnection->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $storeConnection->delete();

        return response()->noContent();
    }

    public function validateConnection(Request $request, StoreConnection $storeConnection): JsonResponse
    {
        if ($storeConnection->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $isValid = $this->validateWithService($storeConnection->platform, $storeConnection->credentials);

        if (!$isValid && $storeConnection->status === 'active') {
            $storeConnection->markAsExpired();
        } elseif ($isValid && $storeConnection->status !== 'active') {
            $storeConnection->update(['status' => 'active']);
        }

        return response()->json([
            'valid' => $isValid,
            'status' => $storeConnection->fresh()->status,
        ]);
    }

    private function buildCredentials(array $validated): array
    {
        if ($validated['platform'] === 'ios') {
            return [
                'name' => $validated['name'],
                'key_id' => $validated['key_id'],
                'issuer_id' => $validated['issuer_id'],
                'private_key' => $validated['private_key'],
            ];
        }

        return [
            'name' => $validated['name'],
            'client_id' => $validated['client_id'],
            'client_secret' => $validated['client_secret'],
            'refresh_token' => $validated['refresh_token'],
        ];
    }

    private function validateWithService(string $platform, array $credentials): bool
    {
        if ($platform === 'ios') {
            return $this->appStoreService->validateCredentials($credentials);
        }

        return $this->googlePlayService->validateCredentials($credentials);
    }
}
