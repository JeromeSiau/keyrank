<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\AppMetadataDraft;
use App\Models\AppMetadataHistory;
use App\Models\AppMetadataLocale;
use App\Models\StoreConnection;
use App\Models\TrackedKeyword;
use App\Services\AppStoreConnectService;
use App\Services\GooglePlayDeveloperService;
use App\Services\OpenRouterService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class MetadataController extends Controller
{
    public function __construct(
        private AppStoreConnectService $ascService,
        private GooglePlayDeveloperService $gplayService,
        private OpenRouterService $openRouterService
    ) {}

    /**
     * Get metadata for all locales of an app
     */
    public function index(Request $request, App $app): JsonResponse
    {
        $user = $request->user();

        // Check user has access to this app
        if (!$user->apps()->where('apps.id', $app->id)->exists()) {
            return response()->json(['message' => 'App not found'], 404);
        }

        // Check if user owns this app (has store connection)
        $isOwner = $user->apps()
            ->where('apps.id', $app->id)
            ->wherePivot('is_owner', true)
            ->exists();

        // Get cached locales from database
        $locales = AppMetadataLocale::forApp($app->id)
            ->orderBy('locale')
            ->get();

        // Get user's drafts for this app
        $drafts = AppMetadataDraft::forApp($app->id)
            ->forUser($user->id)
            ->get()
            ->keyBy('locale');

        // If no cached locales and user is owner, try to fetch from store
        if ($locales->isEmpty() && $isOwner) {
            $locales = $this->fetchAndCacheMetadata($user, $app);
        }

        $result = $locales->map(function ($locale) use ($drafts, $app) {
            $draft = $drafts->get($locale->locale);
            $limits = AppMetadataDraft::LIMITS[$app->platform] ?? AppMetadataDraft::LIMITS['ios'];

            return [
                'locale' => $locale->locale,
                'live' => [
                    'title' => $locale->title,
                    'subtitle' => $locale->subtitle,
                    'keywords' => $locale->keywords,
                    'description' => $locale->description,
                    'promotional_text' => $locale->promotional_text,
                    'whats_new' => $locale->whats_new,
                ],
                'draft' => $draft ? [
                    'id' => $draft->id,
                    'title' => $draft->title,
                    'subtitle' => $draft->subtitle,
                    'keywords' => $draft->keywords,
                    'description' => $draft->description,
                    'promotional_text' => $draft->promotional_text,
                    'whats_new' => $draft->whats_new,
                    'status' => $draft->status,
                    'changed_fields' => $draft->calculateChangedFields(),
                    'updated_at' => $draft->updated_at,
                ] : null,
                'is_complete' => $locale->isComplete(),
                'completion_percentage' => $locale->getCompletionPercentage(),
                'limits' => $limits,
                'asc_ids' => [
                    'app_info_localization_id' => $locale->asc_app_info_id,
                    'version_localization_id' => $locale->asc_localization_id,
                ],
            ];
        });

        return response()->json([
            'data' => [
                'app_id' => $app->id,
                'platform' => $app->platform,
                'is_owner' => $isOwner,
                'can_edit' => $isOwner && in_array($app->platform, ['ios', 'android']),
                'locales' => $result,
                'limits' => AppMetadataDraft::LIMITS[$app->platform] ?? AppMetadataDraft::LIMITS['ios'],
            ],
        ]);
    }

    /**
     * Get metadata for a specific locale
     */
    public function show(Request $request, App $app, string $locale): JsonResponse
    {
        $user = $request->user();

        if (!$user->apps()->where('apps.id', $app->id)->exists()) {
            return response()->json(['message' => 'App not found'], 404);
        }

        $metadataLocale = AppMetadataLocale::forApp($app->id)
            ->forLocale($locale)
            ->first();

        $draft = AppMetadataDraft::forApp($app->id)
            ->forUser($user->id)
            ->forLocale($locale)
            ->first();

        // Get tracked keywords for analysis
        $trackedKeywords = TrackedKeyword::where('user_id', $user->id)
            ->where('app_id', $app->id)
            ->with('keyword')
            ->get()
            ->map(fn($tk) => ['keyword' => $tk->keyword->keyword, 'popularity' => $tk->keyword->popularity])
            ->toArray();

        $keywordAnalysis = $metadataLocale?->analyzeKeywords($trackedKeywords) ?? [];

        $limits = AppMetadataDraft::LIMITS[$app->platform] ?? AppMetadataDraft::LIMITS['ios'];

        return response()->json([
            'data' => [
                'locale' => $locale,
                'live' => $metadataLocale ? [
                    'title' => $metadataLocale->title,
                    'subtitle' => $metadataLocale->subtitle,
                    'keywords' => $metadataLocale->keywords,
                    'description' => $metadataLocale->description,
                    'promotional_text' => $metadataLocale->promotional_text,
                    'whats_new' => $metadataLocale->whats_new,
                    'fetched_at' => $metadataLocale->fetched_at,
                ] : null,
                'draft' => $draft ? [
                    'id' => $draft->id,
                    'title' => $draft->title,
                    'subtitle' => $draft->subtitle,
                    'keywords' => $draft->keywords,
                    'description' => $draft->description,
                    'promotional_text' => $draft->promotional_text,
                    'whats_new' => $draft->whats_new,
                    'status' => $draft->status,
                    'changed_fields' => $draft->calculateChangedFields(),
                    'updated_at' => $draft->updated_at,
                ] : null,
                'keyword_analysis' => $keywordAnalysis,
                'limits' => $limits,
                'asc_ids' => $metadataLocale ? [
                    'app_info_localization_id' => $metadataLocale->asc_app_info_id,
                    'version_localization_id' => $metadataLocale->asc_localization_id,
                ] : null,
            ],
        ]);
    }

    /**
     * Save draft metadata for a locale
     */
    public function update(Request $request, App $app, string $locale): JsonResponse
    {
        $user = $request->user();

        // Check ownership
        $isOwner = $user->apps()
            ->where('apps.id', $app->id)
            ->wherePivot('is_owner', true)
            ->exists();

        if (!$isOwner) {
            return response()->json(['message' => 'You must own this app to edit metadata'], 403);
        }

        $limits = AppMetadataDraft::LIMITS[$app->platform] ?? AppMetadataDraft::LIMITS['ios'];

        $validated = $request->validate([
            'title' => ['nullable', 'string', 'max:' . $limits['title']],
            'subtitle' => ['nullable', 'string', 'max:' . ($limits['subtitle'] ?? 80)],
            'keywords' => ['nullable', 'string', 'max:' . ($limits['keywords'] ?? 200)],
            'description' => ['nullable', 'string', 'max:' . $limits['description']],
            'promotional_text' => ['nullable', 'string', 'max:' . ($limits['promotional_text'] ?? 170)],
            'whats_new' => ['nullable', 'string', 'max:' . $limits['whats_new']],
        ]);

        $draft = AppMetadataDraft::updateOrCreate(
            [
                'app_id' => $app->id,
                'user_id' => $user->id,
                'locale' => $locale,
            ],
            array_merge($validated, [
                'status' => 'draft',
            ])
        );

        // Calculate changed fields
        $draft->changed_fields = $draft->calculateChangedFields();
        $draft->save();

        return response()->json([
            'data' => [
                'id' => $draft->id,
                'locale' => $draft->locale,
                'title' => $draft->title,
                'subtitle' => $draft->subtitle,
                'keywords' => $draft->keywords,
                'description' => $draft->description,
                'promotional_text' => $draft->promotional_text,
                'whats_new' => $draft->whats_new,
                'status' => $draft->status,
                'changed_fields' => $draft->changed_fields,
                'updated_at' => $draft->updated_at,
            ],
            'message' => 'Draft saved successfully',
        ]);
    }

    /**
     * Publish metadata to App Store Connect or Google Play
     */
    public function publish(Request $request, App $app): JsonResponse
    {
        $user = $request->user();

        $validated = $request->validate([
            'locales' => 'required|array|min:1',
            'locales.*' => 'string|max:20',
        ]);

        // Check ownership
        $isOwner = $user->apps()
            ->where('apps.id', $app->id)
            ->wherePivot('is_owner', true)
            ->exists();

        if (!$isOwner) {
            return response()->json(['message' => 'You must own this app to publish metadata'], 403);
        }

        if (!in_array($app->platform, ['ios', 'android'])) {
            return response()->json(['message' => 'This platform does not support metadata publishing'], 400);
        }

        // Get store connection
        $connection = StoreConnection::where('user_id', $user->id)
            ->where('platform', $app->platform)
            ->where('status', 'active')
            ->first();

        if (!$connection) {
            $storeName = $app->platform === 'ios' ? 'App Store Connect' : 'Google Play Console';
            return response()->json(['message' => "No active {$storeName} connection"], 400);
        }

        // Route to platform-specific publisher
        if ($app->platform === 'android') {
            return $this->publishToGooglePlay($app, $user, $connection, $validated['locales']);
        }

        return $this->publishToAppStore($app, $user, $connection, $validated['locales']);
    }

    /**
     * Publish metadata to App Store Connect (iOS)
     */
    private function publishToAppStore(App $app, $user, StoreConnection $connection, array $locales): JsonResponse
    {
        $results = [];
        $errors = [];

        DB::beginTransaction();

        try {
            foreach ($locales as $locale) {
                $draft = AppMetadataDraft::forApp($app->id)
                    ->forUser($user->id)
                    ->forLocale($locale)
                    ->first();

                if (!$draft) {
                    $errors[] = "No draft found for locale: {$locale}";
                    continue;
                }

                $metadataLocale = AppMetadataLocale::forApp($app->id)
                    ->forLocale($locale)
                    ->first();

                if (!$metadataLocale || !$metadataLocale->asc_app_info_id || !$metadataLocale->asc_localization_id) {
                    $errors[] = "Missing ASC IDs for locale: {$locale}";
                    continue;
                }

                // Publish to ASC
                $publishResult = $this->ascService->publishMetadata(
                    $connection,
                    $metadataLocale->asc_app_info_id,
                    $metadataLocale->asc_localization_id,
                    [
                        'title' => $draft->title,
                        'subtitle' => $draft->subtitle,
                        'keywords' => $draft->keywords,
                        'description' => $draft->description,
                        'promotional_text' => $draft->promotional_text,
                        'whats_new' => $draft->whats_new,
                    ]
                );

                if ($publishResult['success']) {
                    $this->updateLocaleAfterPublish($app, $metadataLocale, $draft, $locale);
                    $results[$locale] = ['success' => true];
                } else {
                    $errors = array_merge($errors, $publishResult['errors']);
                    $results[$locale] = ['success' => false, 'errors' => $publishResult['errors']];
                }
            }

            DB::commit();

            return response()->json([
                'data' => [
                    'results' => $results,
                    'errors' => $errors,
                ],
                'message' => empty($errors) ? 'Metadata published successfully' : 'Some locales failed to publish',
            ], empty($errors) ? 200 : 207);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Failed to publish metadata',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Publish metadata to Google Play (Android)
     */
    private function publishToGooglePlay(App $app, $user, StoreConnection $connection, array $locales): JsonResponse
    {
        $results = [];
        $errors = [];

        // Collect all locale data for batch publish
        $localeData = [];

        foreach ($locales as $locale) {
            $draft = AppMetadataDraft::forApp($app->id)
                ->forUser($user->id)
                ->forLocale($locale)
                ->first();

            if (!$draft) {
                $errors[] = "No draft found for locale: {$locale}";
                continue;
            }

            $localeData[$locale] = [
                'title' => $draft->title,
                'description' => $draft->description,
                'short_description' => $draft->subtitle, // Android uses short_description instead of subtitle
            ];
        }

        if (empty($localeData)) {
            return response()->json([
                'data' => ['results' => [], 'errors' => $errors],
                'message' => 'No valid drafts to publish',
            ], 400);
        }

        DB::beginTransaction();

        try {
            // Publish all locales in one edit session
            $publishResult = $this->gplayService->publishMetadata(
                $connection,
                $app->store_id, // package name for Android
                $localeData
            );

            if ($publishResult['success']) {
                // Update all published locales
                foreach ($publishResult['updated'] ?? array_keys($localeData) as $locale) {
                    $draft = AppMetadataDraft::forApp($app->id)
                        ->forUser($user->id)
                        ->forLocale($locale)
                        ->first();

                    $metadataLocale = AppMetadataLocale::forApp($app->id)
                        ->forLocale($locale)
                        ->first();

                    if ($draft && $metadataLocale) {
                        $this->updateLocaleAfterPublish($app, $metadataLocale, $draft, $locale);
                    }

                    $results[$locale] = ['success' => true];
                }
            } else {
                $errors = array_merge($errors, $publishResult['errors'] ?? ['Unknown error']);
                foreach (array_keys($localeData) as $locale) {
                    $results[$locale] = ['success' => false, 'errors' => $publishResult['errors']];
                }
            }

            DB::commit();

            return response()->json([
                'data' => [
                    'results' => $results,
                    'errors' => $errors,
                ],
                'message' => empty($errors) ? 'Metadata published successfully' : 'Some locales failed to publish',
            ], empty($errors) ? 200 : 207);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Failed to publish metadata',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Update local data after successful publish
     */
    private function updateLocaleAfterPublish(App $app, AppMetadataLocale $metadataLocale, AppMetadataDraft $draft, string $locale): void
    {
        // Update live metadata
        $metadataLocale->update([
            'title' => $draft->title ?? $metadataLocale->title,
            'subtitle' => $draft->subtitle ?? $metadataLocale->subtitle,
            'keywords' => $draft->keywords ?? $metadataLocale->keywords,
            'description' => $draft->description ?? $metadataLocale->description,
            'promotional_text' => $draft->promotional_text ?? $metadataLocale->promotional_text,
            'whats_new' => $draft->whats_new ?? $metadataLocale->whats_new,
            'fetched_at' => now(),
        ]);

        // Update draft status
        $draft->update([
            'status' => 'published',
            'last_published_at' => now(),
        ]);

        // Record in history
        foreach ($draft->changed_fields ?? [] as $field) {
            AppMetadataHistory::create([
                'app_id' => $app->id,
                'field' => "metadata_{$locale}_{$field}",
                'old_value' => $metadataLocale->getOriginal($field),
                'new_value' => $draft->$field,
                'changed_at' => now(),
            ]);
        }
    }

    /**
     * Refresh metadata from App Store Connect or Google Play
     */
    public function refresh(Request $request, App $app): JsonResponse
    {
        $user = $request->user();

        $isOwner = $user->apps()
            ->where('apps.id', $app->id)
            ->wherePivot('is_owner', true)
            ->exists();

        if (!$isOwner || !in_array($app->platform, ['ios', 'android'])) {
            return response()->json(['message' => 'Cannot refresh metadata for this app'], 400);
        }

        $locales = $this->fetchAndCacheMetadata($user, $app);

        return response()->json([
            'data' => [
                'locales_updated' => $locales->count(),
                'locales' => $locales->pluck('locale'),
            ],
            'message' => 'Metadata refreshed successfully',
        ]);
    }

    /**
     * Get metadata change history
     */
    public function history(Request $request, App $app): JsonResponse
    {
        $user = $request->user();

        if (!$user->apps()->where('apps.id', $app->id)->exists()) {
            return response()->json(['message' => 'App not found'], 404);
        }

        $history = AppMetadataHistory::forApp($app->id)
            ->where('field', 'like', 'metadata_%')
            ->orderByDesc('changed_at')
            ->limit(100)
            ->get()
            ->map(function ($item) {
                // Parse field name: metadata_{locale}_{field}
                $parts = explode('_', $item->field, 3);
                return [
                    'id' => $item->id,
                    'locale' => $parts[1] ?? 'unknown',
                    'field' => $parts[2] ?? $item->field,
                    'old_value' => $item->old_value,
                    'new_value' => $item->new_value,
                    'changed_at' => $item->changed_at,
                ];
            });

        return response()->json([
            'data' => $history,
        ]);
    }

    /**
     * Delete a draft
     */
    public function deleteDraft(Request $request, App $app, string $locale): JsonResponse
    {
        $user = $request->user();

        $draft = AppMetadataDraft::forApp($app->id)
            ->forUser($user->id)
            ->forLocale($locale)
            ->first();

        if (!$draft) {
            return response()->json(['message' => 'Draft not found'], 404);
        }

        $draft->delete();

        return response()->json([
            'message' => 'Draft deleted successfully',
        ]);
    }

    /**
     * Fetch metadata from store and cache in database
     */
    private function fetchAndCacheMetadata($user, App $app): \Illuminate\Support\Collection
    {
        $connection = StoreConnection::where('user_id', $user->id)
            ->where('platform', $app->platform)
            ->where('status', 'active')
            ->first();

        if (!$connection) {
            return collect([]);
        }

        // Route to platform-specific fetcher
        if ($app->platform === 'android') {
            return $this->fetchAndCacheGooglePlayMetadata($connection, $app);
        }

        return $this->fetchAndCacheAppStoreMetadata($connection, $app);
    }

    /**
     * Fetch metadata from App Store Connect (iOS)
     */
    private function fetchAndCacheAppStoreMetadata(StoreConnection $connection, App $app): \Illuminate\Support\Collection
    {
        $metadata = $this->ascService->getAppMetadata($connection, $app->store_id);

        if (!$metadata) {
            return collect([]);
        }

        $locales = collect();

        foreach ($metadata['locales'] as $localeData) {
            $locale = AppMetadataLocale::updateOrCreate(
                [
                    'app_id' => $app->id,
                    'locale' => $localeData['locale'],
                ],
                [
                    'title' => $localeData['title'] ?? null,
                    'subtitle' => $localeData['subtitle'] ?? null,
                    'keywords' => $localeData['keywords'] ?? null,
                    'description' => $localeData['description'] ?? null,
                    'promotional_text' => $localeData['promotional_text'] ?? null,
                    'whats_new' => $localeData['whats_new'] ?? null,
                    'asc_app_info_id' => $localeData['app_info_localization_id'] ?? null,
                    'asc_localization_id' => $localeData['version_localization_id'] ?? null,
                    'fetched_at' => now(),
                ]
            );

            $locales->push($locale);
        }

        return $locales;
    }

    /**
     * Fetch metadata from Google Play (Android)
     */
    private function fetchAndCacheGooglePlayMetadata(StoreConnection $connection, App $app): \Illuminate\Support\Collection
    {
        $metadata = $this->gplayService->getAppMetadata($connection, $app->store_id);

        if (!$metadata) {
            return collect([]);
        }

        $locales = collect();

        foreach ($metadata['locales'] as $localeData) {
            $locale = AppMetadataLocale::updateOrCreate(
                [
                    'app_id' => $app->id,
                    'locale' => $localeData['locale'],
                ],
                [
                    'title' => $localeData['title'] ?? null,
                    'subtitle' => $localeData['short_description'] ?? null, // Map short_description to subtitle
                    'keywords' => null, // Google Play doesn't have keywords field
                    'description' => $localeData['full_description'] ?? null,
                    'promotional_text' => null, // Google Play doesn't have promotional text
                    'whats_new' => $localeData['whats_new'] ?? null,
                    'asc_app_info_id' => null, // Not used for Android
                    'asc_localization_id' => null, // Not used for Android
                    'fetched_at' => now(),
                ]
            );

            $locales->push($locale);
        }

        return $locales;
    }

    /**
     * Copy metadata content from one locale to others
     */
    public function copyLocale(Request $request, App $app): JsonResponse
    {
        $user = $request->user();

        $validated = $request->validate([
            'source_locale' => 'required|string|max:20',
            'target_locales' => 'required|array|min:1',
            'target_locales.*' => 'string|max:20',
            'fields' => 'nullable|array',
            'fields.*' => 'string|in:title,subtitle,keywords,description,promotional_text,whats_new',
        ]);

        // Check ownership
        $isOwner = $user->apps()
            ->where('apps.id', $app->id)
            ->wherePivot('is_owner', true)
            ->exists();

        if (!$isOwner) {
            return response()->json(['message' => 'You must own this app to copy metadata'], 403);
        }

        // Get source metadata (from live or draft)
        $sourceLocale = AppMetadataLocale::forApp($app->id)
            ->forLocale($validated['source_locale'])
            ->first();

        $sourceDraft = AppMetadataDraft::forApp($app->id)
            ->forUser($user->id)
            ->forLocale($validated['source_locale'])
            ->first();

        if (!$sourceLocale && !$sourceDraft) {
            return response()->json(['message' => 'Source locale not found'], 404);
        }

        // Get effective content (draft overrides live)
        $sourceContent = [
            'title' => $sourceDraft?->title ?? $sourceLocale?->title,
            'subtitle' => $sourceDraft?->subtitle ?? $sourceLocale?->subtitle,
            'keywords' => $sourceDraft?->keywords ?? $sourceLocale?->keywords,
            'description' => $sourceDraft?->description ?? $sourceLocale?->description,
            'promotional_text' => $sourceDraft?->promotional_text ?? $sourceLocale?->promotional_text,
            'whats_new' => $sourceDraft?->whats_new ?? $sourceLocale?->whats_new,
        ];

        // Filter fields if specified
        $fields = $validated['fields'] ?? array_keys($sourceContent);
        $contentToCopy = array_filter(
            $sourceContent,
            fn($key) => in_array($key, $fields),
            ARRAY_FILTER_USE_KEY
        );

        $results = [];

        foreach ($validated['target_locales'] as $targetLocale) {
            if ($targetLocale === $validated['source_locale']) {
                continue; // Skip copying to itself
            }

            // Create or update draft for target locale
            $draft = AppMetadataDraft::updateOrCreate(
                [
                    'app_id' => $app->id,
                    'user_id' => $user->id,
                    'locale' => $targetLocale,
                ],
                array_merge($contentToCopy, [
                    'status' => 'draft',
                ])
            );

            $draft->changed_fields = $draft->calculateChangedFields();
            $draft->save();

            $results[$targetLocale] = ['success' => true, 'draft_id' => $draft->id];
        }

        return response()->json([
            'data' => [
                'source_locale' => $validated['source_locale'],
                'results' => $results,
                'copied_fields' => $fields,
            ],
            'message' => sprintf('Content copied to %d locales', count($results)),
        ]);
    }

    /**
     * Translate metadata content to other locales using AI
     */
    public function translateLocale(Request $request, App $app): JsonResponse
    {
        $user = $request->user();

        $validated = $request->validate([
            'source_locale' => 'required|string|max:20',
            'target_locales' => 'required|array|min:1|max:5',
            'target_locales.*' => 'string|max:20',
            'fields' => 'nullable|array',
            'fields.*' => 'string|in:title,subtitle,keywords,description,promotional_text,whats_new',
        ]);

        // Check ownership
        $isOwner = $user->apps()
            ->where('apps.id', $app->id)
            ->wherePivot('is_owner', true)
            ->exists();

        if (!$isOwner) {
            return response()->json(['message' => 'You must own this app to translate metadata'], 403);
        }

        // Get source metadata
        $sourceLocale = AppMetadataLocale::forApp($app->id)
            ->forLocale($validated['source_locale'])
            ->first();

        $sourceDraft = AppMetadataDraft::forApp($app->id)
            ->forUser($user->id)
            ->forLocale($validated['source_locale'])
            ->first();

        if (!$sourceLocale && !$sourceDraft) {
            return response()->json(['message' => 'Source locale not found'], 404);
        }

        $sourceContent = [
            'title' => $sourceDraft?->title ?? $sourceLocale?->title,
            'subtitle' => $sourceDraft?->subtitle ?? $sourceLocale?->subtitle,
            'keywords' => $sourceDraft?->keywords ?? $sourceLocale?->keywords,
            'description' => $sourceDraft?->description ?? $sourceLocale?->description,
            'promotional_text' => $sourceDraft?->promotional_text ?? $sourceLocale?->promotional_text,
            'whats_new' => $sourceDraft?->whats_new ?? $sourceLocale?->whats_new,
        ];

        // Filter fields
        $fields = $validated['fields'] ?? ['title', 'subtitle', 'description'];
        $contentToTranslate = array_filter(
            $sourceContent,
            fn($value, $key) => in_array($key, $fields) && !empty($value),
            ARRAY_FILTER_USE_BOTH
        );

        if (empty($contentToTranslate)) {
            return response()->json(['message' => 'No content to translate'], 400);
        }

        $limits = AppMetadataDraft::LIMITS[$app->platform] ?? AppMetadataDraft::LIMITS['ios'];
        $results = [];
        $errors = [];

        foreach ($validated['target_locales'] as $targetLocale) {
            if ($targetLocale === $validated['source_locale']) {
                continue;
            }

            $targetLanguage = $this->getLanguageName($targetLocale);
            $sourceLanguage = $this->getLanguageName($validated['source_locale']);

            // Build translation prompt
            $systemPrompt = <<<PROMPT
You are an expert App Store Optimization (ASO) translator. Translate the following app metadata fields from {$sourceLanguage} to {$targetLanguage}.

IMPORTANT RULES:
1. Keep the same tone and style as the original
2. Optimize for ASO in the target language (natural keyword placement)
3. DO NOT exceed character limits:
   - title: {$limits['title']} chars
   - subtitle: {$limits['subtitle']} chars
   - keywords: {$limits['keywords']} chars (comma-separated)
   - description: {$limits['description']} chars
   - promotional_text: {$limits['promotional_text']} chars
   - whats_new: {$limits['whats_new']} chars
4. Return ONLY valid JSON with the translated fields
5. Do NOT translate app names or brand names
PROMPT;

            $userPrompt = "Translate these app metadata fields to {$targetLanguage}:\n\n" .
                json_encode($contentToTranslate, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

            try {
                $response = $this->openRouterService->chat($systemPrompt, $userPrompt, true);

                if ($response) {
                    // Create draft with translated content
                    $translatedContent = [];
                    foreach ($fields as $field) {
                        $snakeField = $this->toSnakeCase($field);
                        if (isset($response[$field])) {
                            $translatedContent[$snakeField] = $response[$field];
                        } elseif (isset($response[$snakeField])) {
                            $translatedContent[$snakeField] = $response[$snakeField];
                        }
                    }

                    if (!empty($translatedContent)) {
                        $draft = AppMetadataDraft::updateOrCreate(
                            [
                                'app_id' => $app->id,
                                'user_id' => $user->id,
                                'locale' => $targetLocale,
                            ],
                            array_merge($translatedContent, [
                                'status' => 'draft',
                            ])
                        );

                        $draft->changed_fields = $draft->calculateChangedFields();
                        $draft->save();

                        $results[$targetLocale] = [
                            'success' => true,
                            'draft_id' => $draft->id,
                            'translated_fields' => array_keys($translatedContent),
                        ];
                    } else {
                        $errors[] = "No valid translation returned for {$targetLocale}";
                        $results[$targetLocale] = ['success' => false, 'error' => 'No valid translation'];
                    }
                } else {
                    $errors[] = "Translation failed for {$targetLocale}";
                    $results[$targetLocale] = ['success' => false, 'error' => 'AI service error'];
                }
            } catch (\Exception $e) {
                $errors[] = "Translation failed for {$targetLocale}: " . $e->getMessage();
                $results[$targetLocale] = ['success' => false, 'error' => $e->getMessage()];
            }
        }

        $successCount = count(array_filter($results, fn($r) => $r['success'] ?? false));

        return response()->json([
            'data' => [
                'source_locale' => $validated['source_locale'],
                'results' => $results,
                'errors' => $errors,
            ],
            'message' => $successCount > 0
                ? sprintf('Translated to %d locale(s)', $successCount)
                : 'Translation failed',
        ], $successCount > 0 ? 200 : 500);
    }

    /**
     * Get language name from locale code
     */
    private function getLanguageName(string $locale): string
    {
        $languages = [
            'en' => 'English', 'en-US' => 'English (US)', 'en-GB' => 'English (UK)',
            'fr' => 'French', 'fr-FR' => 'French', 'fr-CA' => 'French (Canadian)',
            'de' => 'German', 'de-DE' => 'German',
            'es' => 'Spanish', 'es-ES' => 'Spanish (Spain)', 'es-MX' => 'Spanish (Mexico)',
            'it' => 'Italian', 'it-IT' => 'Italian',
            'pt' => 'Portuguese', 'pt-BR' => 'Portuguese (Brazilian)', 'pt-PT' => 'Portuguese (Portugal)',
            'ja' => 'Japanese', 'ja-JP' => 'Japanese',
            'ko' => 'Korean', 'ko-KR' => 'Korean',
            'zh' => 'Chinese', 'zh-CN' => 'Chinese (Simplified)', 'zh-Hans' => 'Chinese (Simplified)',
            'zh-TW' => 'Chinese (Traditional)', 'zh-Hant' => 'Chinese (Traditional)',
            'ru' => 'Russian', 'ru-RU' => 'Russian',
            'ar' => 'Arabic', 'ar-SA' => 'Arabic',
            'nl' => 'Dutch', 'nl-NL' => 'Dutch',
            'sv' => 'Swedish', 'sv-SE' => 'Swedish',
            'da' => 'Danish', 'da-DK' => 'Danish',
            'fi' => 'Finnish', 'fi-FI' => 'Finnish',
            'no' => 'Norwegian', 'no-NO' => 'Norwegian',
            'pl' => 'Polish', 'pl-PL' => 'Polish',
            'tr' => 'Turkish', 'tr-TR' => 'Turkish',
            'th' => 'Thai', 'th-TH' => 'Thai',
            'vi' => 'Vietnamese', 'vi-VN' => 'Vietnamese',
            'id' => 'Indonesian', 'id-ID' => 'Indonesian',
            'ms' => 'Malay', 'ms-MY' => 'Malay',
            'hi' => 'Hindi', 'hi-IN' => 'Hindi',
            'he' => 'Hebrew', 'he-IL' => 'Hebrew',
            'cs' => 'Czech', 'cs-CZ' => 'Czech',
            'el' => 'Greek', 'el-GR' => 'Greek',
            'hu' => 'Hungarian', 'hu-HU' => 'Hungarian',
            'ro' => 'Romanian', 'ro-RO' => 'Romanian',
            'sk' => 'Slovak', 'sk-SK' => 'Slovak',
            'uk' => 'Ukrainian', 'uk-UA' => 'Ukrainian',
        ];

        return $languages[$locale] ?? $locale;
    }

    /**
     * Convert camelCase to snake_case
     */
    private function toSnakeCase(string $input): string
    {
        return strtolower(preg_replace('/(?<!^)[A-Z]/', '_$0', $input));
    }

    /**
     * Generate AI-powered optimization suggestions for metadata
     */
    public function optimize(Request $request, App $app): JsonResponse
    {
        $user = $request->user();

        $validated = $request->validate([
            'locale' => 'required|string|max:20',
            'field' => 'required|string|in:title,subtitle,keywords,description',
        ]);

        // Check ownership
        $isOwner = $user->apps()
            ->where('apps.id', $app->id)
            ->wherePivot('is_owner', true)
            ->exists();

        if (!$isOwner) {
            return response()->json(['message' => 'You must own this app to optimize metadata'], 403);
        }

        // Get current metadata
        $metadataLocale = AppMetadataLocale::forApp($app->id)
            ->forLocale($validated['locale'])
            ->first();

        $draft = AppMetadataDraft::forApp($app->id)
            ->forUser($user->id)
            ->forLocale($validated['locale'])
            ->first();

        $currentContent = [
            'title' => $draft?->title ?? $metadataLocale?->title ?? '',
            'subtitle' => $draft?->subtitle ?? $metadataLocale?->subtitle ?? '',
            'keywords' => $draft?->keywords ?? $metadataLocale?->keywords ?? '',
            'description' => $draft?->description ?? $metadataLocale?->description ?? '',
        ];

        // Get tracked keywords with popularity
        $trackedKeywords = TrackedKeyword::where('user_id', $user->id)
            ->where('app_id', $app->id)
            ->with(['keyword', 'latestRanking'])
            ->get()
            ->map(fn($tk) => [
                'keyword' => $tk->keyword->keyword,
                'popularity' => $tk->keyword->popularity ?? 0,
                'position' => $tk->latestRanking?->position,
            ])
            ->sortByDesc('popularity')
            ->values()
            ->take(30)
            ->toArray();

        // Get competitor info
        $competitors = $app->competitors()
            ->take(5)
            ->get()
            ->map(fn($c) => [
                'name' => $c->name,
                'title' => $c->title ?? $c->name,
                'subtitle' => $c->subtitle ?? '',
            ])
            ->toArray();

        $limits = AppMetadataDraft::LIMITS[$app->platform] ?? AppMetadataDraft::LIMITS['ios'];
        $field = $validated['field'];
        $fieldLimit = $limits[$field] ?? 100;

        // Build AI prompt
        $suggestions = $this->generateOptimizationSuggestions(
            $app,
            $field,
            $currentContent,
            $trackedKeywords,
            $competitors,
            $fieldLimit,
            $validated['locale']
        );

        return response()->json([
            'data' => [
                'field' => $field,
                'locale' => $validated['locale'],
                'current_value' => $currentContent[$field],
                'character_limit' => $fieldLimit,
                'suggestions' => $suggestions,
                'context' => [
                    'tracked_keywords_count' => count($trackedKeywords),
                    'competitors_count' => count($competitors),
                    'top_keywords' => array_slice(array_column($trackedKeywords, 'keyword'), 0, 5),
                ],
            ],
        ]);
    }

    /**
     * Generate AI optimization suggestions for a specific field
     */
    private function generateOptimizationSuggestions(
        App $app,
        string $field,
        array $currentContent,
        array $trackedKeywords,
        array $competitors,
        int $fieldLimit,
        string $locale
    ): array {
        $language = $this->getLanguageName($locale);
        $platform = $app->platform === 'ios' ? 'App Store' : 'Google Play';

        $fieldInstructions = match ($field) {
            'title' => "Optimize the app title. Include high-popularity keywords naturally. Max {$fieldLimit} characters.",
            'subtitle' => "Optimize the subtitle. Complement the title with different keywords. Max {$fieldLimit} characters.",
            'keywords' => "Optimize the keywords field (iOS only). Comma-separated, no spaces after commas, no duplicates from title/subtitle. Max {$fieldLimit} characters.",
            'description' => "Optimize the first 3 paragraphs of the description for ASO. Focus on natural keyword density. Keep the rest similar to current. Max {$fieldLimit} characters total.",
            default => "Optimize this metadata field. Max {$fieldLimit} characters.",
        };

        $keywordsInfo = empty($trackedKeywords) ? 'No tracked keywords available.' :
            "Tracked keywords (sorted by popularity):\n" . collect($trackedKeywords)
                ->map(fn($k) => "- \"{$k['keyword']}\" (pop: {$k['popularity']}" . ($k['position'] ? ", rank: #{$k['position']}" : ", not ranking") . ")")
                ->join("\n");

        $competitorInfo = empty($competitors) ? 'No competitors tracked.' :
            "Competitor titles for reference:\n" . collect($competitors)
                ->map(fn($c) => "- {$c['name']}: \"{$c['title']}\" | \"{$c['subtitle']}\"")
                ->join("\n");

        $systemPrompt = <<<PROMPT
You are an expert App Store Optimization (ASO) consultant. Generate exactly 3 optimized suggestions for the {$field} field.

RULES:
1. Language: {$language}
2. Platform: {$platform}
3. Character limit: {$fieldLimit} characters (STRICT - never exceed)
4. {$fieldInstructions}
5. Do NOT use generic words like "app", "free", "best" unless they have high search volume
6. Keep brand name "{$app->name}" if it appears in the current content
7. Each suggestion should be meaningfully different in approach

RESPONSE FORMAT (JSON):
{
  "suggestions": [
    {
      "value": "The optimized text",
      "reasoning": "Brief explanation of why this option is good",
      "keywords_added": ["keyword1", "keyword2"],
      "keywords_removed": ["old_keyword"],
      "estimated_impact": 15
    }
  ]
}

estimated_impact is a percentage (0-30) based on:
- Number and popularity of keywords added
- Character usage optimization (closer to limit = better)
- Keywords that competitors rank for

Option A should be the RECOMMENDED option (highest impact).
PROMPT;

        $userPrompt = <<<PROMPT
Current {$field}: "{$currentContent[$field]}"
Current character count: {strlen($currentContent[$field])}/{$fieldLimit}

Context:
- App name: {$app->name}
- Category: {$app->category}

{$keywordsInfo}

{$competitorInfo}

Generate 3 optimized suggestions for the {$field} field in {$language}.
PROMPT;

        try {
            $response = $this->openRouterService->chat($systemPrompt, $userPrompt, true);

            if ($response && isset($response['suggestions'])) {
                return array_map(function ($suggestion, $index) use ($fieldLimit) {
                    return [
                        'option' => chr(65 + $index), // A, B, C
                        'value' => $suggestion['value'] ?? '',
                        'character_count' => strlen($suggestion['value'] ?? ''),
                        'character_limit' => $fieldLimit,
                        'reasoning' => $suggestion['reasoning'] ?? '',
                        'keywords_added' => $suggestion['keywords_added'] ?? [],
                        'keywords_removed' => $suggestion['keywords_removed'] ?? [],
                        'estimated_impact' => min(30, max(0, $suggestion['estimated_impact'] ?? 5)),
                        'is_recommended' => $index === 0,
                    ];
                }, $response['suggestions'], array_keys($response['suggestions']));
            }
        } catch (\Exception $e) {
            \Log::error('AI optimization error', ['error' => $e->getMessage()]);
        }

        // Fallback if AI fails
        return [
            [
                'option' => 'A',
                'value' => $currentContent[$field],
                'character_count' => strlen($currentContent[$field]),
                'character_limit' => $fieldLimit,
                'reasoning' => 'Keep current content (AI suggestions unavailable)',
                'keywords_added' => [],
                'keywords_removed' => [],
                'estimated_impact' => 0,
                'is_recommended' => true,
            ],
        ];
    }
}
