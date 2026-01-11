<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class OnboardingController extends Controller
{
    /**
     * Valid onboarding steps in order
     */
    private const STEPS = ['welcome', 'connect', 'apps', 'setup', 'completed'];

    /**
     * Get current onboarding status
     */
    public function status(Request $request): JsonResponse
    {
        $user = $request->user();

        return response()->json([
            'data' => [
                'current_step' => $user->onboarding_step ?? 'welcome',
                'is_completed' => $user->onboarding_completed_at !== null,
                'completed_at' => $user->onboarding_completed_at?->toIso8601String(),
                'steps' => self::STEPS,
                'progress' => $this->calculateProgress($user->onboarding_step),
            ],
        ]);
    }

    /**
     * Update onboarding step
     */
    public function updateStep(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'step' => ['required', 'string', 'in:' . implode(',', self::STEPS)],
        ]);

        $user = $request->user();
        $newStep = $validated['step'];

        // Validate step progression (can only move forward or stay)
        $currentStepIndex = array_search($user->onboarding_step ?? 'welcome', self::STEPS);
        $newStepIndex = array_search($newStep, self::STEPS);

        if ($newStepIndex < $currentStepIndex) {
            return response()->json([
                'error' => 'Cannot go back to a previous onboarding step.',
            ], 422);
        }

        $user->update(['onboarding_step' => $newStep]);

        return response()->json([
            'data' => [
                'current_step' => $newStep,
                'progress' => $this->calculateProgress($newStep),
            ],
        ]);
    }

    /**
     * Mark onboarding as complete
     */
    public function complete(Request $request): JsonResponse
    {
        $user = $request->user();

        if ($user->onboarding_completed_at) {
            return response()->json([
                'message' => 'Onboarding already completed.',
                'data' => [
                    'completed_at' => $user->onboarding_completed_at->toIso8601String(),
                ],
            ]);
        }

        $user->update([
            'onboarding_step' => 'completed',
            'onboarding_completed_at' => now(),
        ]);

        return response()->json([
            'message' => 'Onboarding completed successfully.',
            'data' => [
                'completed_at' => $user->onboarding_completed_at->toIso8601String(),
            ],
        ]);
    }

    /**
     * Skip onboarding entirely
     */
    public function skip(Request $request): JsonResponse
    {
        $user = $request->user();

        if ($user->onboarding_completed_at) {
            return response()->json([
                'message' => 'Onboarding already completed.',
            ]);
        }

        $user->update([
            'onboarding_step' => 'completed',
            'onboarding_completed_at' => now(),
        ]);

        return response()->json([
            'message' => 'Onboarding skipped.',
        ]);
    }

    /**
     * Calculate progress percentage
     */
    private function calculateProgress(?string $step): int
    {
        if (!$step) {
            return 0;
        }

        $index = array_search($step, self::STEPS);
        if ($index === false) {
            return 0;
        }

        return (int) (($index / (count(self::STEPS) - 1)) * 100);
    }
}
