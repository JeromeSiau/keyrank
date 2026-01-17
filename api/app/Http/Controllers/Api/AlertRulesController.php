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
            'type' => 'required|string|in:position_change,rating_change,review_spike,review_keyword,new_competitor,competitor_passed,mass_movement,keyword_popularity,opportunity,competitor_metadata_changed',
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
            [
                'name' => 'Chute brutale',
                'type' => 'position_change',
                'icon' => 'trending_down',
                'description' => 'Alerte quand une app perd 10+ positions',
                'default_conditions' => ['direction' => 'down', 'threshold' => 10],
            ],
            [
                'name' => 'Progression',
                'type' => 'position_change',
                'icon' => 'trending_up',
                'description' => 'Alerte quand une app gagne 10+ positions',
                'default_conditions' => ['direction' => 'up', 'threshold' => 10],
            ],
            [
                'name' => 'Entrée top 10',
                'type' => 'position_change',
                'icon' => 'emoji_events',
                'description' => 'Alerte quand une app entre dans le top 10',
                'default_conditions' => ['entered_top' => 10],
            ],
            [
                'name' => 'Note en baisse',
                'type' => 'rating_change',
                'icon' => 'star_half',
                'description' => 'Alerte quand la note baisse de 0.2+',
                'default_conditions' => ['direction' => 'down', 'threshold' => 0.2],
            ],
            [
                'name' => 'Pic d\'avis négatifs',
                'type' => 'review_spike',
                'icon' => 'sentiment_very_dissatisfied',
                'description' => 'Alerte sur 5+ avis négatifs en 24h',
                'default_conditions' => ['max_rating' => 2, 'count' => 5, 'period_hours' => 24],
            ],
            [
                'name' => 'Mot-clé dans avis',
                'type' => 'review_keyword',
                'icon' => 'search',
                'description' => 'Alerte sur mots-clés spécifiques dans les avis',
                'default_conditions' => ['keywords' => ['bug', 'crash', 'lent']],
            ],
            [
                'name' => 'Nouveau concurrent',
                'type' => 'new_competitor',
                'icon' => 'person_add',
                'description' => 'Alerte quand une nouvelle app entre dans le top 100',
                'default_conditions' => ['top' => 100],
            ],
            [
                'name' => 'Concurrent vous dépasse',
                'type' => 'competitor_passed',
                'icon' => 'sports_martial_arts',
                'description' => 'Alerte quand un concurrent vous dépasse',
                'default_conditions' => (object)[], // Force JSON {} instead of []
            ],
            [
                'name' => 'Mouvement de masse',
                'type' => 'mass_movement',
                'icon' => 'waves',
                'description' => 'Alerte sur 10+ changements dans le top 20',
                'default_conditions' => ['changes' => 10, 'top' => 20],
            ],
            [
                'name' => 'Popularité mot-clé',
                'type' => 'keyword_popularity',
                'icon' => 'local_fire_department',
                'description' => 'Alerte quand la popularité change de 15%+',
                'default_conditions' => ['change' => 15],
            ],
            [
                'name' => 'Opportunité',
                'type' => 'opportunity',
                'icon' => 'diamond',
                'description' => 'Alerte sur opportunités de mots-clés',
                'default_conditions' => ['max_position' => 3, 'min_popularity' => 50],
            ],
            [
                'name' => 'Changement métadonnées concurrent',
                'type' => 'competitor_metadata_changed',
                'icon' => 'history',
                'description' => 'Alerte quand un concurrent modifie ses métadonnées',
                'default_conditions' => ['fields' => ['title', 'subtitle', 'description', 'keywords']],
            ],
        ];

        return response()->json(['data' => $templates]);
    }
}
