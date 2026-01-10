<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Services\iTunesService;
use App\Services\GooglePlayService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function __construct(
        private iTunesService $iTunesService,
        private GooglePlayService $googlePlayService
    ) {}

    /**
     * Get available categories for each platform
     */
    public function index(): JsonResponse
    {
        // Try database first
        $iosCategories = Category::ios()->orderBy('name')->get()
            ->map(fn($c) => ['id' => $c->store_id, 'name' => $c->name]);

        $androidCategories = Category::android()->orderBy('name')->get()
            ->map(fn($c) => ['id' => $c->store_id, 'name' => $c->name]);

        // Fallback to static lists if database is empty
        if ($iosCategories->isEmpty()) {
            $iosCategories = collect(iTunesService::getCategories())
                ->map(fn($name, $id) => ['id' => (string) $id, 'name' => $name])
                ->values();
        }

        if ($androidCategories->isEmpty()) {
            $androidCategories = collect(GooglePlayService::getCategories())
                ->map(fn($name, $id) => ['id' => (string) $id, 'name' => $name])
                ->values();
        }

        return response()->json([
            'data' => [
                'ios' => $iosCategories,
                'android' => $androidCategories,
            ],
        ]);
    }

    /**
     * Get top apps for a category
     */
    public function top(Request $request, string $categoryId): JsonResponse
    {
        $validated = $request->validate([
            'platform' => 'required|string|in:ios,android',
            'country' => 'nullable|string|size:2',
            'collection' => 'nullable|string|in:top_free,top_paid,top_grossing',
            'limit' => 'nullable|integer|min:1|max:200',
        ]);

        $platform = $validated['platform'];
        $country = $validated['country'] ?? 'us';
        $collection = $validated['collection'] ?? 'top_free';
        $limit = $validated['limit'] ?? 100;

        if ($platform === 'ios') {
            $results = $this->iTunesService->getTopApps($categoryId, $country, $collection, $limit);
        } else {
            $results = $this->googlePlayService->getTopApps($categoryId, $country, $collection, $limit);
        }

        return response()->json([
            'data' => [
                'category_id' => $categoryId,
                'platform' => $platform,
                'country' => $country,
                'collection' => $collection,
                'results' => $results,
            ],
        ]);
    }
}
