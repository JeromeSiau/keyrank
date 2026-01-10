<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AlertRule;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class AlertRulesController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $rules = AlertRule::forUser($request->user()->id)
            ->orderByDesc('priority')
            ->get();

        return response()->json(['data' => $rules]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'type' => 'required|string|in:position_change,rating_change,review_spike,review_keyword,new_competitor,competitor_passed,mass_movement,keyword_popularity,opportunity',
            'scope_type' => 'required|string|in:global,app,category,keyword',
            'scope_id' => 'nullable|integer',
            'conditions' => 'required|array',
            'priority' => 'nullable|integer',
        ]);

        $rule = AlertRule::create([
            'user_id' => $request->user()->id,
            'name' => $validated['name'],
            'type' => $validated['type'],
            'scope_type' => $validated['scope_type'],
            'scope_id' => $validated['scope_id'] ?? null,
            'conditions' => $validated['conditions'],
            'priority' => $validated['priority'] ?? 0,
            'is_active' => true,
        ]);

        return response()->json(['data' => $rule], 201);
    }

    public function update(Request $request, AlertRule $rule): JsonResponse
    {
        if ($rule->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'conditions' => 'sometimes|array',
            'scope_type' => 'sometimes|string|in:global,app,category,keyword',
            'scope_id' => 'nullable|integer',
            'priority' => 'sometimes|integer',
            'is_active' => 'sometimes|boolean',
        ]);

        $rule->update($validated);

        return response()->json(['data' => $rule->fresh()]);
    }

    public function destroy(Request $request, AlertRule $rule): Response
    {
        if ($rule->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $rule->delete();

        return response()->noContent();
    }

    public function toggle(Request $request, AlertRule $rule): JsonResponse
    {
        if ($rule->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $rule->update(['is_active' => !$rule->is_active]);

        return response()->json(['data' => $rule->fresh()]);
    }

    public function templates(): JsonResponse
    {
        $templates = [
            ['name' => 'Chute brutale', 'type' => 'position_change', 'conditions' => ['direction' => 'down', 'threshold' => 10]],
            ['name' => 'Progression', 'type' => 'position_change', 'conditions' => ['direction' => 'up', 'threshold' => 10]],
            ['name' => 'Entrée top 10', 'type' => 'position_change', 'conditions' => ['entered_top' => 10]],
            ['name' => 'Note en baisse', 'type' => 'rating_change', 'conditions' => ['direction' => 'down', 'threshold' => 0.2]],
            ['name' => 'Pic d\'avis négatifs', 'type' => 'review_spike', 'conditions' => ['max_rating' => 2, 'count' => 5, 'period_hours' => 24]],
            ['name' => 'Mot-clé dans avis', 'type' => 'review_keyword', 'conditions' => ['keywords' => ['bug', 'crash', 'lent']]],
            ['name' => 'Nouveau concurrent', 'type' => 'new_competitor', 'conditions' => ['top' => 100]],
            ['name' => 'Concurrent vous dépasse', 'type' => 'competitor_passed', 'conditions' => []],
            ['name' => 'Mouvement de masse', 'type' => 'mass_movement', 'conditions' => ['changes' => 10, 'top' => 20]],
            ['name' => 'Popularité mot-clé', 'type' => 'keyword_popularity', 'conditions' => ['change' => 15]],
            ['name' => 'Opportunité', 'type' => 'opportunity', 'conditions' => ['max_position' => 3, 'min_popularity' => 50]],
        ];

        return response()->json(['data' => $templates]);
    }
}
