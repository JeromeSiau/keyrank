<?php

namespace App\Listeners;

use App\Events\RankingsSynced;
use App\Services\AlertEvaluatorService;

class EvaluateRankingAlerts
{
    public function __construct(
        private AlertEvaluatorService $evaluator
    ) {}

    public function handle(RankingsSynced $event): void
    {
        $allAlerts = collect();

        foreach ($event->rankings as $ranking) {
            $alerts = $this->evaluator->evaluatePositionChange($ranking);
            $allAlerts = $allAlerts->merge($alerts);
        }

        if ($allAlerts->isNotEmpty()) {
            $this->evaluator->dispatchAlerts($allAlerts);
        }
    }
}
