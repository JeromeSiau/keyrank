<?php

namespace App\Mail;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class WeeklyDigestMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public User $user,
        public array $digest,
    ) {}

    public function envelope(): Envelope
    {
        $period = $this->digest['period'];

        return new Envelope(
            subject: "Your Weekly ASO Digest - {$period['start']} to {$period['end']}",
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.weekly-digest',
            with: [
                'user' => $this->user,
                'digest' => $this->digest,
            ],
        );
    }
}
