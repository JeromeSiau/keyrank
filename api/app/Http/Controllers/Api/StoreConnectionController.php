<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\StoreConnection;
use App\Services\AppStoreConnectService;
use App\Services\GooglePlayDeveloperService;
use App\Services\iTunesService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

class StoreConnectionController extends Controller
{
    public function __construct(
        private AppStoreConnectService $appStoreService,
        private GooglePlayDeveloperService $googlePlayService,
        private iTunesService $iTunesService,
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
            return response()->json(['error' => $this->getInvalidCredentialsMessage($validated['platform'])], 422);
        }

        return DB::transaction(function () use ($request, $validated, $credentials) {
            $connection = StoreConnection::create([
                'user_id' => $request->user()->id,
                'platform' => $validated['platform'],
                'credentials' => $credentials,
                'connected_at' => now(),
                'status' => 'active',
            ]);

            return response()->json(['data' => $connection], 201);
        });
    }

    public function show(Request $request, StoreConnection $storeConnection): JsonResponse
    {
        $this->authorizeConnection($storeConnection);

        return response()->json(['data' => $storeConnection]);
    }

    public function update(Request $request, StoreConnection $storeConnection): JsonResponse
    {
        $this->authorizeConnection($storeConnection);

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
            return response()->json(['error' => $this->getInvalidCredentialsMessage($storeConnection->platform)], 422);
        }

        $storeConnection->update([
            'credentials' => $newCredentials,
            'status' => 'active', // Reset status on credential update
        ]);

        return response()->json(['data' => $storeConnection->fresh()]);
    }

    public function destroy(Request $request, StoreConnection $storeConnection): Response
    {
        $this->authorizeConnection($storeConnection);

        $storeConnection->delete();

        return response()->noContent();
    }

    public function validateConnection(Request $request, StoreConnection $storeConnection): JsonResponse
    {
        $this->authorizeConnection($storeConnection);

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

    /**
     * Sync apps from the connected store and mark as owned
     */
    public function syncApps(Request $request, StoreConnection $storeConnection): JsonResponse
    {
        $this->authorizeConnection($storeConnection);

        if ($storeConnection->status !== 'active') {
            return response()->json(['error' => 'Connection is not active. Please re-validate credentials.'], 422);
        }

        $user = $request->user();
        $synced = [];

        if ($storeConnection->platform === 'ios') {
            // Fetch all apps from App Store Connect
            $storeApps = $this->appStoreService->getApps($storeConnection);

            if ($storeApps === null) {
                return response()->json(['error' => 'Failed to fetch apps from App Store Connect.'], 500);
            }

            foreach ($storeApps as $storeApp) {
                // Find or create the app in our database
                $app = App::firstOrCreate(
                    ['platform' => 'ios', 'store_id' => $storeApp['store_id']],
                    [
                        'name' => $storeApp['name'],
                        'bundle_id' => $storeApp['bundle_id'],
                    ]
                );

                // Fetch additional metadata from iTunes if needed
                if (!$app->icon_url) {
                    $metadata = $this->iTunesService->lookupApp($storeApp['store_id']);
                    if ($metadata) {
                        $app->update([
                            'icon_url' => $metadata['icon_url'] ?? null,
                            'developer' => $metadata['developer'] ?? null,
                            'rating' => $metadata['rating'] ?? null,
                            'rating_count' => $metadata['rating_count'] ?? 0,
                        ]);
                    }
                }

                // Attach to user with is_owner=true (or update if already attached)
                $user->apps()->syncWithoutDetaching([
                    $app->id => ['is_owner' => true],
                ]);

                $synced[] = [
                    'id' => $app->id,
                    'name' => $app->name,
                    'icon_url' => $app->icon_url,
                    'platform' => $app->platform,
                ];
            }
        } else {
            // For Android, we can't list all apps from Google Play API
            // Instead, mark existing followed Android apps as owned if we can access their reviews
            $androidApps = $user->apps()->where('platform', 'android')->get();

            foreach ($androidApps as $app) {
                $reviews = $this->googlePlayService->getReviews($storeConnection, $app->store_id);

                if ($reviews !== null) {
                    // Successfully accessed reviews, mark as owner
                    $user->apps()->updateExistingPivot($app->id, ['is_owner' => true]);

                    $synced[] = [
                        'id' => $app->id,
                        'name' => $app->name,
                        'icon_url' => $app->icon_url,
                        'platform' => $app->platform,
                    ];
                }
            }
        }

        return response()->json([
            'data' => [
                'synced_count' => count($synced),
                'apps' => $synced,
            ],
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

    private function authorizeConnection(StoreConnection $connection): void
    {
        if ($connection->user_id !== auth()->id()) {
            abort(403, 'Forbidden');
        }
    }

    private function getInvalidCredentialsMessage(string $platform): string
    {
        return $platform === 'ios'
            ? 'Invalid credentials. Please verify your App Store Connect API key.'
            : 'Invalid credentials. Please verify your Google Play Console OAuth credentials.';
    }
}
