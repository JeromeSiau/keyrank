<?php

namespace App\Http\Middleware;

use App\Services\PlanService;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckPlanLimit
{
    public function __construct(
        private PlanService $planService
    ) {}

    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, string $resource): Response
    {
        $user = $request->user();

        if (! $user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        $currentCount = $this->getCurrentCount($user, $resource, $request);
        $canAdd = $this->planService->canAdd($user, $resource, $currentCount);

        if (! $canAdd) {
            $limit = $this->planService->getLimit($user, $resource);
            $planName = $this->planService->getPlanConfig($user)['name'];

            return response()->json([
                'error' => 'limit_exceeded',
                'message' => "You've reached the limit of {$limit} {$resource} on the {$planName} plan. Please upgrade to add more.",
                'limit' => $limit,
                'current' => $currentCount,
                'resource' => $resource,
            ], 403);
        }

        return $next($request);
    }

    private function getCurrentCount($user, string $resource, Request $request): int
    {
        return match ($resource) {
            'apps' => $user->apps()->count(),
            'keywords_per_app' => $this->getKeywordsCount($user, $request),
            'competitors_per_app' => $this->getCompetitorsCount($user, $request),
            default => 0,
        };
    }

    private function getKeywordsCount($user, Request $request): int
    {
        $appId = $request->route('app');
        if (! $appId) {
            return 0;
        }

        return $user->trackedKeywords()->where('app_id', $appId)->count();
    }

    private function getCompetitorsCount($user, Request $request): int
    {
        // Competitors count would be tracked per app
        // For now, return 0 as competitors feature may not be fully implemented
        return 0;
    }
}
