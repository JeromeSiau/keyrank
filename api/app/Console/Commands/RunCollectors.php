<?php

namespace App\Console\Commands;

use App\Jobs\Collectors\RatingsCollector;
use App\Jobs\Collectors\ReviewsCollector;
use Illuminate\Console\Command;

class RunCollectors extends Command
{
    protected $signature = 'collectors:run {--ratings : Run only ratings collector} {--reviews : Run only reviews collector}';

    protected $description = 'Run data collectors immediately for all tracked apps';

    public function handle(): int
    {
        $runRatings = $this->option('ratings') || !$this->option('reviews');
        $runReviews = $this->option('reviews') || !$this->option('ratings');

        if ($runRatings) {
            $this->info('Running ratings collector...');
            $collector = new RatingsCollector();
            $collector->handle();
            $this->info('Ratings collector completed.');
        }

        if ($runReviews) {
            $this->info('Running reviews collector...');
            $collector = new ReviewsCollector();
            $collector->handle();
            $this->info('Reviews collector completed.');
        }

        $this->info('Done!');

        return Command::SUCCESS;
    }
}
