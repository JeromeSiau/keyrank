<?php

namespace App\Services;

use App\Models\User;

class PlanService
{
    /**
     * Get the user's current plan name.
     */
    public function getCurrentPlan(User $user): string
    {
        if ($user->subscribed('default')) {
            $subscription = $user->subscription('default');

            // Check which plan based on Stripe price
            foreach (['pro', 'business'] as $planKey) {
                $plan = config("plans.{$planKey}");
                $priceIds = [
                    $plan['stripe_price_id'] ?? null,
                    $plan['stripe_price_id_yearly'] ?? null,
                ];

                if (in_array($subscription->stripe_price, array_filter($priceIds))) {
                    return $planKey;
                }
            }
        }

        return config('plans.default', 'free');
    }

    /**
     * Get the plan configuration for a user.
     */
    public function getPlanConfig(User $user): array
    {
        $planKey = $this->getCurrentPlan($user);
        return config("plans.{$planKey}", config('plans.free'));
    }

    /**
     * Get the limits for a user's current plan.
     */
    public function getLimits(User $user): array
    {
        return $this->getPlanConfig($user)['limits'];
    }

    /**
     * Get a specific limit for a user.
     */
    public function getLimit(User $user, string $key): mixed
    {
        return $this->getLimits($user)[$key] ?? null;
    }

    /**
     * Check if a user can perform an action based on limits.
     */
    public function canAdd(User $user, string $resource, int $currentCount): bool
    {
        $limit = $this->getLimit($user, $resource);

        // -1 means unlimited
        if ($limit === -1) {
            return true;
        }

        return $currentCount < $limit;
    }

    /**
     * Check if a user has access to a feature.
     */
    public function hasFeature(User $user, string $feature): bool
    {
        $value = $this->getLimit($user, $feature);

        // Boolean features
        if (is_bool($value)) {
            return $value;
        }

        // Numeric features (-1 = unlimited, 0 = disabled, >0 = has access)
        return $value !== 0 && $value !== false;
    }

    /**
     * Get subscription status details for a user.
     */
    public function getSubscriptionStatus(User $user): array
    {
        $planKey = $this->getCurrentPlan($user);
        $plan = config("plans.{$planKey}");

        $status = [
            'plan' => $planKey,
            'plan_name' => $plan['name'],
            'limits' => $plan['limits'],
            'is_subscribed' => $user->subscribed('default'),
            'on_trial' => $user->onTrial('default'),
            'on_grace_period' => false,
            'ends_at' => null,
            'trial_ends_at' => null,
        ];

        if ($user->subscribed('default')) {
            $subscription = $user->subscription('default');
            $status['on_grace_period'] = $subscription->onGracePeriod();
            $status['ends_at'] = $subscription->ends_at?->toIso8601String();
            $status['trial_ends_at'] = $subscription->trial_ends_at?->toIso8601String();
        }

        return $status;
    }

    /**
     * Get all available plans for display.
     */
    public function getAvailablePlans(): array
    {
        $plans = [];

        foreach (['free', 'pro', 'business'] as $planKey) {
            $plan = config("plans.{$planKey}");
            $plans[] = [
                'key' => $planKey,
                'name' => $plan['name'],
                'limits' => $plan['limits'],
                'has_monthly' => isset($plan['stripe_price_id']),
                'has_yearly' => isset($plan['stripe_price_id_yearly']),
            ];
        }

        return $plans;
    }
}
