<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\PlanService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BillingController extends Controller
{
    public function __construct(
        private PlanService $planService
    ) {}

    /**
     * Get user's subscription status.
     */
    public function status(Request $request): JsonResponse
    {
        $user = $request->user();

        return response()->json([
            'subscription' => $this->planService->getSubscriptionStatus($user),
        ]);
    }

    /**
     * Get available plans.
     */
    public function plans(): JsonResponse
    {
        return response()->json([
            'plans' => $this->planService->getAvailablePlans(),
        ]);
    }

    /**
     * Create a checkout session for a plan.
     */
    public function checkout(Request $request): JsonResponse
    {
        $request->validate([
            'plan' => 'required|string|in:pro,business',
            'billing_period' => 'required|string|in:monthly,yearly',
        ]);

        $user = $request->user();
        $planKey = $request->input('plan');
        $billingPeriod = $request->input('billing_period');

        $plan = config("plans.{$planKey}");

        if (! $plan) {
            return response()->json(['error' => 'Invalid plan'], 400);
        }

        $priceId = $billingPeriod === 'yearly'
            ? ($plan['stripe_price_id_yearly'] ?? null)
            : ($plan['stripe_price_id'] ?? null);

        if (! $priceId) {
            return response()->json(['error' => 'Price not configured'], 400);
        }

        // Create or get Stripe customer
        if (! $user->hasStripeId()) {
            $user->createAsStripeCustomer();
        }

        $checkout = $user->newSubscription('default', $priceId)
            ->allowPromotionCodes()
            ->checkout([
                'success_url' => config('app.frontend_url') . '/settings/billing?success=true',
                'cancel_url' => config('app.frontend_url') . '/settings/billing?canceled=true',
            ]);

        return response()->json([
            'checkout_url' => $checkout->url,
        ]);
    }

    /**
     * Get URL to Stripe Customer Portal.
     */
    public function portal(Request $request): JsonResponse
    {
        $user = $request->user();

        if (! $user->hasStripeId()) {
            return response()->json(['error' => 'No billing account found'], 400);
        }

        $portalUrl = $user->billingPortalUrl(
            config('app.frontend_url') . '/settings/billing'
        );

        return response()->json([
            'portal_url' => $portalUrl,
        ]);
    }

    /**
     * Cancel subscription.
     */
    public function cancel(Request $request): JsonResponse
    {
        $user = $request->user();

        if (! $user->subscribed('default')) {
            return response()->json(['error' => 'No active subscription'], 400);
        }

        $user->subscription('default')->cancel();

        return response()->json([
            'message' => 'Subscription will be canceled at the end of the billing period',
            'subscription' => $this->planService->getSubscriptionStatus($user),
        ]);
    }

    /**
     * Resume a canceled subscription (if on grace period).
     */
    public function resume(Request $request): JsonResponse
    {
        $user = $request->user();

        if (! $user->subscription('default')?->onGracePeriod()) {
            return response()->json(['error' => 'Cannot resume subscription'], 400);
        }

        $user->subscription('default')->resume();

        return response()->json([
            'message' => 'Subscription resumed',
            'subscription' => $this->planService->getSubscriptionStatus($user),
        ]);
    }
}
