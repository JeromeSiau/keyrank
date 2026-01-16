<?php

namespace App\Jobs;

use App\Mail\AlertDigestMail;
use App\Models\Notification;
use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Mail;

class SendAlertDigestJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function __construct(
        public User $user,
        public string $period = 'daily', // 'daily' or 'weekly'
    ) {}

    public function handle(): void
    {
        // Check if user has email notifications enabled
        if (!$this->user->email_notifications_enabled) {
            return;
        }

        // Get user's delivery preferences
        $preferences = $this->user->alert_delivery_preferences ?? [];

        // Get notifications that should be included in digest
        $since = $this->period === 'weekly'
            ? now()->subWeek()
            : now()->subDay();

        $notifications = Notification::query()
            ->forUser($this->user->id)
            ->where('created_at', '>=', $since)
            ->where('digest_sent_at', null) // Not already sent in a digest
            ->orderBy('created_at', 'desc')
            ->get()
            ->filter(function ($notification) use ($preferences) {
                // Check if this notification type has digest enabled
                $typePrefs = $preferences[$notification->type] ?? null;
                return $typePrefs && ($typePrefs['digest'] ?? false);
            });

        if ($notifications->isEmpty()) {
            return;
        }

        // Send the digest email
        Mail::to($this->user->email)->send(
            new AlertDigestMail($this->user, $notifications, $this->period)
        );

        // Mark notifications as sent in digest
        Notification::whereIn('id', $notifications->pluck('id'))
            ->update(['digest_sent_at' => now()]);
    }
}
