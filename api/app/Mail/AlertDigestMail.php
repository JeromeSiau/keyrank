<?php

namespace App\Mail;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Collection;

class AlertDigestMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public function __construct(
        public User $user,
        public Collection $notifications,
        public string $period = 'daily', // 'daily' or 'weekly'
    ) {
        $this->onQueue('emails');
    }

    public function envelope(): Envelope
    {
        $count = $this->notifications->count();
        $periodLabel = $this->period === 'weekly' ? 'Weekly' : 'Daily';

        return new Envelope(
            subject: "[Keyrank] {$periodLabel} Digest: {$count} alert" . ($count > 1 ? 's' : ''),
        );
    }

    public function content(): Content
    {
        // Group notifications by type
        $groupedByType = $this->notifications->groupBy('type');

        // Group notifications by app (if available in data)
        $groupedByApp = $this->notifications->groupBy(function ($notification) {
            return $notification->data['app_name'] ?? 'General';
        });

        return new Content(
            markdown: 'emails.alert-digest',
            with: [
                'user' => $this->user,
                'notifications' => $this->notifications,
                'groupedByType' => $groupedByType,
                'groupedByApp' => $groupedByApp,
                'period' => $this->period,
                'count' => $this->notifications->count(),
                'appUrl' => config('app.frontend_url', 'https://app.keyrank.io'),
            ],
        );
    }
}
