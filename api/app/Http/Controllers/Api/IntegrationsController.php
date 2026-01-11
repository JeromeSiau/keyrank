<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\Integration;
use App\Services\AppStoreConnectService;
use App\Services\GooglePlayDeveloperService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class IntegrationsController extends Controller
{
    public function __construct(
        private AppStoreConnectService $appStoreConnect,
        private GooglePlayDeveloperService $googlePlay,
    ) {}

    /**
     * List all integrations for the authenticated user
     */
    public function index(Request $request): JsonResponse
    {
        $integrations = $request->user()->integrations()
            ->select(['id', 'type', 'status', 'metadata', 'last_sync_at', 'error_message', 'created_at'])
            ->get();

        return response()->json([
            'data' => $integrations->map(fn($i) => [
                'id' => $i->id,
                'type' => $i->type,
                'status' => $i->status,
                'metadata' => $i->metadata,
                'last_sync_at' => $i->last_sync_at?->toIso8601String(),
                'error_message' => $i->error_message,
                'created_at' => $i->created_at->toIso8601String(),
            ]),
        ]);
    }

    /**
     * Get a specific integration
     */
    public function show(Request $request, Integration $integration): JsonResponse
    {
        if ($integration->user_id !== $request->user()->id) {
            abort(403, 'You do not own this integration.');
        }

        return response()->json([
            'data' => [
                'id' => $integration->id,
                'type' => $integration->type,
                'status' => $integration->status,
                'metadata' => $integration->metadata,
                'last_sync_at' => $integration->last_sync_at?->toIso8601String(),
                'error_message' => $integration->error_message,
                'created_at' => $integration->created_at->toIso8601String(),
            ],
        ]);
    }

    /**
     * Delete an integration
     */
    public function destroy(Request $request, Integration $integration): JsonResponse
    {
        if ($integration->user_id !== $request->user()->id) {
            abort(403, 'You do not own this integration.');
        }

        // Remove integration_id from user_apps pivot
        DB::table('user_apps')
            ->where('integration_id', $integration->id)
            ->update(['integration_id' => null, 'ownership_type' => 'watched']);

        $integration->delete();

        return response()->json(['message' => 'Integration deleted successfully.']);
    }

    /**
     * Connect App Store Connect
     */
    public function connectAppStore(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'key_id' => ['required', 'string', 'size:10'],
            'issuer_id' => ['required', 'uuid'],
            'private_key' => ['required', 'string'],
        ]);

        $user = $request->user();

        // Check if user already has an App Store Connect integration
        $existing = $user->integrations()
            ->where('type', Integration::TYPE_APP_STORE_CONNECT)
            ->first();

        if ($existing) {
            return response()->json([
                'error' => 'You already have an App Store Connect integration. Delete it first to connect a new one.',
            ], 409);
        }

        // Validate the private key format
        if (!str_starts_with($validated['private_key'], '-----BEGIN PRIVATE KEY-----')) {
            return response()->json([
                'error' => 'Invalid private key format. Must start with -----BEGIN PRIVATE KEY-----',
            ], 422);
        }

        $credentials = [
            'key_id' => $validated['key_id'],
            'issuer_id' => $validated['issuer_id'],
            'private_key' => $validated['private_key'],
        ];

        // Create integration in pending state
        $integration = $user->integrations()->create([
            'type' => Integration::TYPE_APP_STORE_CONNECT,
            'status' => Integration::STATUS_PENDING,
            'credentials' => $credentials,
        ]);

        // Test connection and fetch apps
        try {
            if (!$this->appStoreConnect->validateCredentials($credentials)) {
                $integration->markAsError('Failed to authenticate with App Store Connect. Please check your credentials.');
                return response()->json([
                    'error' => 'Failed to authenticate with App Store Connect. Please check your credentials.',
                ], 422);
            }

            // Create a temporary object to use with getApps
            $tempConnection = new \stdClass();
            $tempConnection->credentials = $credentials;

            // Fetch apps from App Store Connect
            $apps = $this->fetchAppStoreApps($credentials);

            if ($apps === null) {
                $integration->markAsError('Failed to fetch apps from App Store Connect.');
                return response()->json([
                    'error' => 'Connected successfully but failed to fetch apps. Please try again.',
                ], 500);
            }

            // Import apps
            $importedCount = $this->importApps($user, $integration, $apps, 'ios');

            // Mark as active
            $integration->update([
                'status' => Integration::STATUS_ACTIVE,
                'metadata' => [
                    'apps_count' => count($apps),
                    'imported_count' => $importedCount,
                ],
                'last_sync_at' => now(),
            ]);

            return response()->json([
                'message' => 'App Store Connect connected successfully.',
                'data' => [
                    'id' => $integration->id,
                    'type' => $integration->type,
                    'status' => $integration->status,
                    'apps_discovered' => count($apps),
                    'apps_imported' => $importedCount,
                ],
            ], 201);
        } catch (\Exception $e) {
            Log::error('App Store Connect connection error', ['error' => $e->getMessage()]);
            $integration->markAsError($e->getMessage());
            return response()->json([
                'error' => 'An error occurred while connecting: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Connect Google Play Console
     */
    public function connectGooglePlay(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'service_account_json' => ['required', 'string'],
            'package_names' => ['required', 'array', 'min:1'],
            'package_names.*' => ['required', 'string', 'regex:/^[a-z][a-z0-9_]*(\.[a-z0-9_]+)+$/i'],
        ]);

        $user = $request->user();

        // Check if user already has a Google Play integration
        $existing = $user->integrations()
            ->where('type', Integration::TYPE_GOOGLE_PLAY_CONSOLE)
            ->first();

        if ($existing) {
            return response()->json([
                'error' => 'You already have a Google Play Console integration. Delete it first to connect a new one.',
            ], 409);
        }

        // Parse and validate service account JSON
        $serviceAccount = json_decode($validated['service_account_json'], true);
        if (!$serviceAccount || !isset($serviceAccount['client_email']) || !isset($serviceAccount['private_key'])) {
            return response()->json([
                'error' => 'Invalid service account JSON. Must contain client_email and private_key.',
            ], 422);
        }

        $credentials = [
            'type' => 'service_account',
            'client_email' => $serviceAccount['client_email'],
            'private_key' => $serviceAccount['private_key'],
            'project_id' => $serviceAccount['project_id'] ?? null,
            'package_names' => $validated['package_names'],
        ];

        // Create integration in pending state
        $integration = $user->integrations()->create([
            'type' => Integration::TYPE_GOOGLE_PLAY_CONSOLE,
            'status' => Integration::STATUS_PENDING,
            'credentials' => $credentials,
        ]);

        try {
            // For Google Play, we don't have a simple validation API
            // We'll just import the specified package names
            $apps = collect($validated['package_names'])->map(fn($packageName) => [
                'store_id' => $packageName,
                'bundle_id' => $packageName,
                'name' => $packageName, // Will be updated by metadata collector
                'platform' => 'android',
            ])->toArray();

            $importedCount = $this->importApps($user, $integration, $apps, 'android');

            // Mark as active
            $integration->update([
                'status' => Integration::STATUS_ACTIVE,
                'metadata' => [
                    'apps_count' => count($apps),
                    'imported_count' => $importedCount,
                    'service_account_email' => $serviceAccount['client_email'],
                ],
                'last_sync_at' => now(),
            ]);

            return response()->json([
                'message' => 'Google Play Console connected successfully.',
                'data' => [
                    'id' => $integration->id,
                    'type' => $integration->type,
                    'status' => $integration->status,
                    'apps_imported' => $importedCount,
                ],
            ], 201);
        } catch (\Exception $e) {
            Log::error('Google Play connection error', ['error' => $e->getMessage()]);
            $integration->markAsError($e->getMessage());
            return response()->json([
                'error' => 'An error occurred while connecting: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Refresh integration - re-sync apps
     */
    public function refresh(Request $request, Integration $integration): JsonResponse
    {
        if ($integration->user_id !== $request->user()->id) {
            abort(403, 'You do not own this integration.');
        }

        if (!$integration->isActive()) {
            return response()->json([
                'error' => 'Cannot refresh integration that is not active.',
            ], 422);
        }

        $user = $request->user();

        try {
            if ($integration->type === Integration::TYPE_APP_STORE_CONNECT) {
                $apps = $this->fetchAppStoreApps($integration->credentials);
                if ($apps === null) {
                    return response()->json(['error' => 'Failed to fetch apps.'], 500);
                }
                $importedCount = $this->importApps($user, $integration, $apps, 'ios');
            } else {
                $packageNames = $integration->credentials['package_names'] ?? [];
                $apps = collect($packageNames)->map(fn($packageName) => [
                    'store_id' => $packageName,
                    'bundle_id' => $packageName,
                    'name' => $packageName,
                    'platform' => 'android',
                ])->toArray();
                $importedCount = $this->importApps($user, $integration, $apps, 'android');
            }

            $integration->update([
                'metadata' => array_merge($integration->metadata ?? [], [
                    'apps_count' => count($apps),
                    'imported_count' => $importedCount,
                ]),
                'last_sync_at' => now(),
            ]);

            return response()->json([
                'message' => 'Integration refreshed successfully.',
                'data' => [
                    'apps_discovered' => count($apps),
                    'apps_imported' => $importedCount,
                ],
            ]);
        } catch (\Exception $e) {
            Log::error('Integration refresh error', ['error' => $e->getMessage()]);
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * Get apps discovered from an integration
     */
    public function apps(Request $request, Integration $integration): JsonResponse
    {
        if ($integration->user_id !== $request->user()->id) {
            abort(403, 'You do not own this integration.');
        }

        $user = $request->user();

        // Get apps that are linked to this integration via user_apps pivot
        $apps = $user->apps()
            ->wherePivot('integration_id', $integration->id)
            ->get(['apps.id', 'apps.store_id', 'apps.bundle_id', 'apps.name', 'apps.icon_url', 'apps.platform']);

        return response()->json([
            'data' => $apps->map(fn($app) => [
                'id' => $app->id,
                'store_id' => $app->store_id,
                'bundle_id' => $app->bundle_id,
                'name' => $app->name,
                'icon_url' => $app->icon_url,
                'platform' => $app->platform,
            ]),
        ]);
    }

    /**
     * Fetch apps from App Store Connect
     */
    private function fetchAppStoreApps(array $credentials): ?array
    {
        try {
            $token = $this->appStoreConnect->generateToken($credentials);
            $baseUrl = config('services.app_store_connect.base_url');

            $response = \Illuminate\Support\Facades\Http::withToken($token)
                ->timeout(30)
                ->get("{$baseUrl}/v1/apps", ['limit' => 200]);

            if (!$response->successful()) {
                Log::error('App Store Connect fetch apps error', [
                    'status' => $response->status(),
                    'body' => $response->body(),
                ]);
                return null;
            }

            $data = $response->json();
            $apps = [];

            foreach ($data['data'] ?? [] as $app) {
                $apps[] = [
                    'store_id' => $app['id'],
                    'bundle_id' => $app['attributes']['bundleId'] ?? null,
                    'name' => $app['attributes']['name'] ?? 'Unknown',
                    'platform' => 'ios',
                ];
            }

            return $apps;
        } catch (\Exception $e) {
            Log::error('App Store Connect fetch apps exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Import apps for a user from an integration
     */
    private function importApps($user, Integration $integration, array $apps, string $platform): int
    {
        $importedCount = 0;

        foreach ($apps as $appData) {
            // Find or create the app
            $app = App::updateOrCreate(
                ['store_id' => $appData['store_id'], 'platform' => $platform],
                [
                    'bundle_id' => $appData['bundle_id'] ?? null,
                    'name' => $appData['name'],
                ]
            );

            // Check if user already has this app
            $existingPivot = DB::table('user_apps')
                ->where('user_id', $user->id)
                ->where('app_id', $app->id)
                ->first();

            if ($existingPivot) {
                // Update to owned
                DB::table('user_apps')
                    ->where('user_id', $user->id)
                    ->where('app_id', $app->id)
                    ->update([
                        'ownership_type' => 'owned',
                        'integration_id' => $integration->id,
                    ]);
            } else {
                // Create new pivot
                DB::table('user_apps')->insert([
                    'user_id' => $user->id,
                    'app_id' => $app->id,
                    'ownership_type' => 'owned',
                    'integration_id' => $integration->id,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }

            $importedCount++;
        }

        return $importedCount;
    }
}
