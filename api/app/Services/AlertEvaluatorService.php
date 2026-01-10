<?php

namespace App\Services;

use App\Models\AlertRule;
use App\Models\AppRanking;
use App\Models\TrackedKeyword;
use App\Models\User;
use Illuminate\Support\Collection;

class AlertEvaluatorService
{
    public function __construct(
        private ?NotificationService $notificationService = null
    ) {
        $this->notificationService = $notificationService ?? new NotificationService();
    }

    public function evaluatePositionChange(AppRanking $ranking): Collection
    {
        $alerts = collect();
        $change = $ranking->change;
        $previous = $ranking->getPreviousRanking();

        // Find users tracking this app+keyword
        $trackedKeywords = TrackedKeyword::where('app_id', $ranking->app_id)
            ->where('keyword_id', $ranking->keyword_id)
            ->get();

        foreach ($trackedKeywords as $tracked) {
            $rule = $this->getApplicableRule(
                $tracked->user_id,
                AlertRule::TYPE_POSITION_CHANGE,
                $ranking->app_id,
                $ranking->keyword_id
            );

            if (!$rule) {
                continue;
            }

            $conditions = $rule->conditions;
            $shouldAlert = false;
            $alertTitle = '';
            $alertBody = '';

            // Check threshold-based conditions
            if (isset($conditions['direction']) && isset($conditions['threshold'])) {
                $threshold = $conditions['threshold'];
                $direction = $conditions['direction'];

                if ($change !== null) {
                    if ($direction === 'down' && $change < 0 && abs($change) >= $threshold) {
                        $shouldAlert = true;
                        $alertTitle = "Position dropped by " . abs($change);
                        $alertBody = "{$ranking->app->name} dropped from #{$previous->position} to #{$ranking->position} on '{$ranking->keyword->keyword}'";
                    } elseif ($direction === 'up' && $change > 0 && $change >= $threshold) {
                        $shouldAlert = true;
                        $alertTitle = "Position improved by {$change}";
                        $alertBody = "{$ranking->app->name} rose from #{$previous->position} to #{$ranking->position} on '{$ranking->keyword->keyword}'";
                    } elseif ($direction === 'any' && abs($change) >= $threshold) {
                        $shouldAlert = true;
                        $word = $change > 0 ? 'improved' : 'dropped';
                        $alertTitle = "Position {$word} by " . abs($change);
                        $alertBody = "{$ranking->app->name} moved from #{$previous->position} to #{$ranking->position} on '{$ranking->keyword->keyword}'";
                    }
                }
            }

            // Check entered_top condition
            if (isset($conditions['entered_top']) && $previous && $ranking->position !== null) {
                $topN = $conditions['entered_top'];
                if ($previous->position > $topN && $ranking->position <= $topN) {
                    $shouldAlert = true;
                    $alertTitle = "Entered top {$topN}!";
                    $alertBody = "{$ranking->app->name} is now #{$ranking->position} on '{$ranking->keyword->keyword}'";
                }
            }

            // Check exited_top condition
            if (isset($conditions['exited_top']) && $previous && $ranking->position !== null) {
                $topN = $conditions['exited_top'];
                if ($previous->position <= $topN && $ranking->position > $topN) {
                    $shouldAlert = true;
                    $alertTitle = "Exited top {$topN}";
                    $alertBody = "{$ranking->app->name} dropped to #{$ranking->position} on '{$ranking->keyword->keyword}'";
                }
            }

            // Check best_ever condition
            if (isset($conditions['best_ever']) && $conditions['best_ever'] && $ranking->position !== null) {
                $bestEver = AppRanking::where('app_id', $ranking->app_id)
                    ->where('keyword_id', $ranking->keyword_id)
                    ->whereNotNull('position')
                    ->min('position');

                if ($ranking->position <= $bestEver) {
                    $shouldAlert = true;
                    $alertTitle = "Best position ever!";
                    $alertBody = "{$ranking->app->name} reached #{$ranking->position} on '{$ranking->keyword->keyword}'";
                }
            }

            if ($shouldAlert) {
                $alerts->push([
                    'user_id' => $tracked->user_id,
                    'alert_rule_id' => $rule->id,
                    'type' => AlertRule::TYPE_POSITION_CHANGE,
                    'title' => $alertTitle,
                    'body' => $alertBody,
                    'data' => [
                        'app_id' => $ranking->app_id,
                        'keyword_id' => $ranking->keyword_id,
                        'position' => $ranking->position,
                        'previous_position' => $previous?->position,
                        'change' => $change,
                    ],
                ]);
            }
        }

        return $alerts;
    }

    public function getApplicableRule(int $userId, string $type, ?int $appId = null, ?int $keywordId = null): ?AlertRule
    {
        // Get all active rules for this user and type, ordered by priority (highest first)
        $rules = AlertRule::forUser($userId)
            ->forType($type)
            ->active()
            ->orderByDesc('priority')
            ->get();

        if ($rules->isEmpty()) {
            return null;
        }

        // Find the most specific applicable rule
        foreach ($rules as $rule) {
            if ($rule->scope_type === AlertRule::SCOPE_KEYWORD && $rule->scope_id === $keywordId) {
                return $rule;
            }
        }

        foreach ($rules as $rule) {
            if ($rule->scope_type === AlertRule::SCOPE_APP && $rule->scope_id === $appId) {
                return $rule;
            }
        }

        // Return global rule if no specific match
        return $rules->firstWhere('scope_type', AlertRule::SCOPE_GLOBAL);
    }

    public function dispatchAlerts(Collection $alerts): void
    {
        $alertsByUser = $alerts->groupBy('user_id');

        foreach ($alertsByUser as $userId => $userAlerts) {
            $user = User::find($userId);
            if ($user) {
                $this->notificationService->send($user, $userAlerts);
            }
        }
    }
}
