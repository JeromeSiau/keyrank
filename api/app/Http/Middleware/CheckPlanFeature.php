<?php

namespace App\Http\Middleware;

use App\Services\PlanService;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckPlanFeature
{
    public function __construct(
        private PlanService $planService
    ) {}

    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, string $feature): Response
    {
        $user = $request->user();

        if (! $user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        $hasFeature = $this->planService->hasFeature($user, $feature);

        if (! $hasFeature) {
            $planName = $this->planService->getPlanConfig($user)['name'];

            return response()->json([
                'error' => 'feature_not_available',
                'message' => "The '{$feature}' feature is not available on the {$planName} plan. Please upgrade to access this feature.",
                'feature' => $feature,
            ], 403);
        }

        return $next($request);
    }
}
