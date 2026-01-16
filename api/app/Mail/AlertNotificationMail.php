<?php

namespace App\Mail;

use App\Models\Notification;
use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class AlertNotificationMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public function __construct(
        public User $user,
        public Notification $notification,
    ) {
        $this->onQueue('emails');
    }

    public function envelope(): Envelope
    {
        $typeLabels = [
            'position_change' => 'Ranking Alert',
            'rating_change' => 'Rating Alert',
            'review_spike' => 'Review Spike Alert',
            'review_keyword' => 'Review Keyword Alert',
            'new_competitor' => 'New Competitor Alert',
            'competitor_passed' => 'Competitor Alert',
            'mass_movement' => 'Market Movement Alert',
            'keyword_popularity' => 'Keyword Alert',
            'opportunity' => 'Opportunity Alert',
        ];

        $typeLabel = $typeLabels[$this->notification->type] ?? 'Alert';

        return new Envelope(
            subject: "[Keyrank] {$typeLabel}: {$this->notification->title}",
        );
    }

    public function content(): Content
    {
        return new Content(
            markdown: 'emails.alert-notification',
            with: [
                'user' => $this->user,
                'notification' => $this->notification,
                'appUrl' => config('app.frontend_url', 'https://app.keyrank.io'),
            ],
        );
    }
}
