<?php

namespace App\Services;

use App\Models\Notification;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Support\Collection;

class NotificationService
{
    public function create(User $user, array $data): Notification
    {
        return Notification::create([
            'user_id' => $user->id,
            'alert_rule_id' => $data['alert_rule_id'] ?? null,
            'type' => $data['type'],
            'title' => $data['title'],
            'body' => $data['body'],
            'data' => $data['data'] ?? null,
            'is_read' => false,
            'sent_at' => now(),
            'created_at' => now(),
        ]);
    }

    public function isQuietHours(User $user): bool
    {
        $now = Carbon::now($user->timezone);
        $start = Carbon::parse($user->quiet_hours_start, $user->timezone);
        $end = Carbon::parse($user->quiet_hours_end, $user->timezone);

        // Handle overnight quiet hours (e.g., 22:00 - 08:00)
        if ($start > $end) {
            return $now >= $start || $now < $end;
        }

        return $now >= $start && $now < $end;
    }

    public function aggregate(Collection $alerts): Collection
    {
        if ($alerts->count() <= 2) {
            return $alerts;
        }

        $grouped = $alerts->groupBy('type');
        $result = collect();

        foreach ($grouped as $type => $typeAlerts) {
            if ($typeAlerts->count() > 2) {
                $result->push([
                    'type' => 'aggregated',
                    'original_type' => $type,
                    'title' => $this->getAggregatedTitle($type, $typeAlerts->count()),
                    'body' => $this->getAggregatedBody($type, $typeAlerts),
                    'data' => [
                        'count' => $typeAlerts->count(),
                        'items' => $typeAlerts->pluck('data')->toArray(),
                    ],
                ]);
            } else {
                $result = $result->merge($typeAlerts);
            }
        }

        return $result;
    }

    public function send(User $user, Collection $alerts): void
    {
        if ($alerts->isEmpty()) {
            return;
        }

        $aggregated = $this->aggregate($alerts);

        foreach ($aggregated as $alert) {
            $notification = $this->create($user, $alert);

            if (!$this->isQuietHours($user) && $user->fcm_token) {
                $this->sendFcm($user, $notification);
            }
        }
    }

    public function sendFcm(User $user, Notification $notification): void
    {
        // FCM implementation will be added in Phase 5
        // For now, just mark as sent
        $notification->update(['sent_at' => now()]);
    }

    private function getAggregatedTitle(string $type, int $count): string
    {
        return match ($type) {
            'position_change' => "{$count} position changes detected",
            'rating_change' => "{$count} rating changes",
            'review_spike' => "{$count} review alerts",
            'new_competitor' => "{$count} new competitors",
            'competitor_passed' => "{$count} competitors passed you",
            'mass_movement' => "{$count} mass movements",
            'keyword_popularity' => "{$count} keyword changes",
            'opportunity' => "{$count} opportunities detected",
            default => "{$count} alerts",
        };
    }

    private function getAggregatedBody(string $type, Collection $alerts): string
    {
        $items = $alerts->take(3)->pluck('title')->join(', ');
        $remaining = $alerts->count() - 3;

        if ($remaining > 0) {
            return "{$items} and {$remaining} more";
        }

        return $items;
    }
}
