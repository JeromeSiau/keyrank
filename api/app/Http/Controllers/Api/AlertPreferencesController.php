<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AlertPreferencesController extends Controller
{
    /**
     * Get current user's alert delivery preferences
     */
    public function show(Request $request): JsonResponse
    {
        $user = $request->user();

        return response()->json([
            'data' => [
                'email' => $user->email,
                'email_notifications_enabled' => $user->email_notifications_enabled ?? true,
                'delivery_by_type' => $user->alert_delivery_preferences,
                'digest_time' => $user->digest_time ?? '09:00',
                'weekly_digest_day' => $user->weekly_digest_day ?? 'monday',
            ],
        ]);
    }

    /**
     * Update user's alert delivery preferences
     */
    public function update(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'email_notifications_enabled' => 'sometimes|boolean',
            'delivery_by_type' => 'sometimes|array',
            'delivery_by_type.*' => 'sometimes|array',
            'delivery_by_type.*.push' => 'sometimes|boolean',
            'delivery_by_type.*.email' => 'sometimes|boolean',
            'delivery_by_type.*.digest' => 'sometimes|boolean',
            'digest_time' => 'sometimes|string|regex:/^([01]\d|2[0-3]):([0-5]\d)$/',
            'weekly_digest_day' => 'sometimes|string|in:monday,tuesday,wednesday,thursday,friday,saturday,sunday',
        ]);

        $user = $request->user();

        // Update fields if provided
        if (isset($validated['email_notifications_enabled'])) {
            $user->email_notifications_enabled = $validated['email_notifications_enabled'];
        }

        if (isset($validated['delivery_by_type'])) {
            // Merge with existing preferences to preserve any not included in request
            $currentPreferences = $user->alert_delivery_preferences ?? [];
            $user->alert_delivery_preferences = array_merge($currentPreferences, $validated['delivery_by_type']);
        }

        if (isset($validated['digest_time'])) {
            $user->digest_time = $validated['digest_time'];
        }

        if (isset($validated['weekly_digest_day'])) {
            $user->weekly_digest_day = $validated['weekly_digest_day'];
        }

        $user->save();

        return response()->json([
            'data' => [
                'email' => $user->email,
                'email_notifications_enabled' => $user->email_notifications_enabled,
                'delivery_by_type' => $user->alert_delivery_preferences,
                'digest_time' => $user->digest_time,
                'weekly_digest_day' => $user->weekly_digest_day,
            ],
        ]);
    }

    /**
     * Get available alert types with their labels
     */
    public function types(): JsonResponse
    {
        $types = [
            [
                'type' => 'position_change',
                'label' => 'Ranking changes',
                'description' => 'When your app position changes significantly',
                'icon' => 'trending_up',
            ],
            [
                'type' => 'rating_change',
                'label' => 'Rating changes',
                'description' => 'When your app rating changes',
                'icon' => 'star',
            ],
            [
                'type' => 'review_spike',
                'label' => 'Review spikes',
                'description' => 'Unusual review activity detected',
                'icon' => 'reviews',
            ],
            [
                'type' => 'review_keyword',
                'label' => 'Review keywords',
                'description' => 'Specific keywords appear in reviews',
                'icon' => 'search',
            ],
            [
                'type' => 'new_competitor',
                'label' => 'New competitors',
                'description' => 'New apps enter your space',
                'icon' => 'person_add',
            ],
            [
                'type' => 'competitor_passed',
                'label' => 'Competitor overtakes',
                'description' => 'A competitor passes your ranking',
                'icon' => 'sports',
            ],
            [
                'type' => 'mass_movement',
                'label' => 'Mass movements',
                'description' => 'Large ranking shifts in category',
                'icon' => 'waves',
            ],
            [
                'type' => 'keyword_popularity',
                'label' => 'Keyword popularity',
                'description' => 'Keyword popularity changes',
                'icon' => 'local_fire_department',
            ],
            [
                'type' => 'opportunity',
                'label' => 'Opportunities',
                'description' => 'New ranking opportunities detected',
                'icon' => 'diamond',
            ],
        ];

        return response()->json(['data' => $types]);
    }
}
