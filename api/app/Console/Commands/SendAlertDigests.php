<?php

namespace App\Console\Commands;

use App\Jobs\SendAlertDigestJob;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Console\Command;

class SendAlertDigests extends Command
{
    protected $signature = 'alerts:send-digests
        {--period=daily : Digest period (daily or weekly)}
        {--user= : Send only to specific user ID}
        {--sync : Run synchronously instead of dispatching to queue}';

    protected $description = 'Send alert digest emails to users based on their preferences';

    public function handle(): int
    {
        $period = $this->option('period');
        $userId = $this->option('user');
        $sync = $this->option('sync');

        if (!in_array($period, ['daily', 'weekly'])) {
            $this->error('Period must be "daily" or "weekly"');
            return 1;
        }

        $this->info("Sending {$period} alert digests...");

        // Get users who should receive digest at this time
        $query = User::query()
            ->where('email_notifications_enabled', true)
            ->whereNotNull('alert_delivery_preferences');

        if ($userId) {
            $query->where('id', $userId);
        } else {
            // For daily: match current hour with user's digest_time
            // For weekly: also match the day of week
            $currentTime = now()->format('H:i');
            $currentHour = now()->format('H:00');
            $currentDay = strtolower(now()->format('l'));

            // Match users whose digest_time hour matches current hour
            $query->where(function ($q) use ($currentHour) {
                $q->where('digest_time', 'like', substr($currentHour, 0, 2) . '%')
                  ->orWhereNull('digest_time'); // Default 09:00
            });

            if ($period === 'weekly') {
                $query->where(function ($q) use ($currentDay) {
                    $q->where('weekly_digest_day', $currentDay)
                      ->orWhereNull('weekly_digest_day'); // Default monday
                });
            }
        }

        $users = $query->get();

        if ($users->isEmpty()) {
            $this->info('No users to send digests to at this time.');
            return 0;
        }

        $this->info("Found {$users->count()} users to process.");

        $bar = $this->output->createProgressBar($users->count());
        $bar->start();

        foreach ($users as $user) {
            $job = new SendAlertDigestJob($user, $period);

            if ($sync) {
                $job->handle();
            } else {
                dispatch($job);
            }

            $bar->advance();
        }

        $bar->finish();
        $this->newLine();
        $this->info('Done!');

        return 0;
    }
}
