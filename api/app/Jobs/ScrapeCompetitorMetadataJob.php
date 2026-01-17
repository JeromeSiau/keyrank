<?php

namespace App\Jobs;

use App\Models\AlertRule;
use App\Models\App;
use App\Models\AppCompetitor;
use App\Models\CompetitorMetadataSnapshot;
use App\Services\GooglePlayService;
use App\Services\iTunesService;
use App\Services\NotificationService;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Log;

class ScrapeCompetitorMetadataJob implements ShouldQueue
{
    use Queueable;

    public int $timeout = 1800; // 30 minutes max
    public int $tries = 1;

    public function __construct(
        public ?int $competitorAppId = null,
        public string $locale = 'en-US',
    ) {}

    public function handle(
        iTunesService $itunesService,
        GooglePlayService $googlePlayService,
        NotificationService $notificationService,
    ): void {
        Log::info('ScrapeCompetitorMetadataJob started', [
            'competitor_app_id' => $this->competitorAppId,
            'locale' => $this->locale,
        ]);

        if ($this->competitorAppId) {
            // Scrape single competitor
            $app = App::find($this->competitorAppId);
            if ($app) {
                $this->scrapeCompetitor($app, $itunesService, $googlePlayService, $notificationService);
            }
        } else {
            // Scrape all competitors
            $this->scrapeAllCompetitors($itunesService, $googlePlayService, $notificationService);
        }

        Log::info('ScrapeCompetitorMetadataJob completed');
    }

    /**
     * Scrape metadata for all competitors
     */
    private function scrapeAllCompetitors(
        iTunesService $itunesService,
        GooglePlayService $googlePlayService,
        NotificationService $notificationService,
    ): void {
        // Get unique competitor app IDs
        $competitorAppIds = AppCompetitor::distinct()
            ->pluck('competitor_app_id')
            ->unique();

        Log::info("Scraping metadata for {$competitorAppIds->count()} competitors");

        foreach ($competitorAppIds as $competitorAppId) {
            $app = App::find($competitorAppId);
            if (!$app) {
                continue;
            }

            try {
                $this->scrapeCompetitor($app, $itunesService, $googlePlayService, $notificationService);
                // Small delay to avoid rate limiting
                usleep(500000); // 0.5 seconds
            } catch (\Exception $e) {
                Log::error('Failed to scrape competitor metadata', [
                    'app_id' => $competitorAppId,
                    'error' => $e->getMessage(),
                ]);
            }
        }
    }

    /**
     * Scrape metadata for a single competitor
     */
    private function scrapeCompetitor(
        App $app,
        iTunesService $itunesService,
        GooglePlayService $googlePlayService,
        NotificationService $notificationService,
    ): void {
        $country = $this->localeToCountry($this->locale);

        // Fetch metadata based on platform
        if ($app->platform === 'ios') {
            $metadata = $itunesService->getAppMetadata($app->store_id, $country);
        } else {
            $metadata = $googlePlayService->getAppMetadata($app->store_id, $country);
        }

        if (!$metadata) {
            Log::warning('No metadata returned for app', ['app_id' => $app->id]);
            return;
        }

        // Get previous snapshot for comparison
        $previousSnapshot = CompetitorMetadataSnapshot::getLatest($app->id, $this->locale);

        // Determine what changed
        $hasChanges = false;
        $changedFields = [];

        if ($previousSnapshot) {
            $changedFields = $this->detectChanges($previousSnapshot, $metadata);
            $hasChanges = !empty($changedFields);
        }

        // Store new snapshot
        $snapshot = CompetitorMetadataSnapshot::create([
            'app_id' => $app->id,
            'locale' => $this->locale,
            'title' => $metadata['title'],
            'subtitle' => $metadata['subtitle'] ?? null,
            'short_description' => $metadata['short_description'] ?? null,
            'description' => $metadata['description'],
            'keywords' => $metadata['keywords'] ?? null,
            'whats_new' => $metadata['whats_new'] ?? null,
            'version' => $metadata['version'],
            'has_changes' => $hasChanges,
            'changed_fields' => $hasChanges ? $changedFields : null,
            'scraped_at' => now(),
        ]);

        if ($hasChanges) {
            Log::info('Competitor metadata changed', [
                'app_id' => $app->id,
                'app_name' => $app->name,
                'changed_fields' => $changedFields,
            ]);

            // Trigger metadata change alerts
            $this->triggerMetadataChangeAlerts($app, $snapshot, $previousSnapshot, $changedFields, $notificationService);
        } else {
            Log::debug('No metadata changes for app', [
                'app_id' => $app->id,
                'first_snapshot' => !$previousSnapshot,
            ]);
        }
    }

    /**
     * Detect changed fields between previous snapshot and new metadata
     */
    private function detectChanges(CompetitorMetadataSnapshot $previous, array $new): array
    {
        $changedFields = [];
        $comparableFields = [
            'title',
            'subtitle',
            'short_description',
            'description',
            'keywords',
            'whats_new',
        ];

        foreach ($comparableFields as $field) {
            $oldValue = $previous->$field;
            $newValue = $new[$field] ?? null;

            // Normalize empty values
            $oldNormalized = empty($oldValue) ? null : trim($oldValue);
            $newNormalized = empty($newValue) ? null : trim($newValue);

            if ($oldNormalized !== $newNormalized) {
                $changedFields[] = $field;
            }
        }

        return $changedFields;
    }

    /**
     * Trigger alerts for metadata changes
     */
    private function triggerMetadataChangeAlerts(
        App $competitorApp,
        CompetitorMetadataSnapshot $newSnapshot,
        ?CompetitorMetadataSnapshot $previousSnapshot,
        array $changedFields,
        NotificationService $notificationService,
    ): void {
        // Find all users tracking this competitor
        $trackerAppIds = AppCompetitor::where('competitor_app_id', $competitorApp->id)
            ->pluck('app_id')
            ->unique();

        // Get users who own these apps
        $userIds = App::whereIn('id', $trackerAppIds)
            ->pluck('user_id')
            ->unique();

        // Find alert rules for competitor_metadata_changed
        $alertRules = AlertRule::where('type', 'competitor_metadata_changed')
            ->where('is_enabled', true)
            ->whereIn('user_id', $userIds)
            ->get();

        foreach ($alertRules as $rule) {
            // Check if changed fields match the rule conditions
            $watchedFields = $rule->conditions['fields'] ?? ['title', 'subtitle', 'description', 'keywords'];
            $matchedFields = array_intersect($changedFields, $watchedFields);

            if (empty($matchedFields)) {
                continue;
            }

            $user = $rule->user;
            if (!$user) {
                continue;
            }

            // Build notification
            $fieldsText = implode(', ', $matchedFields);
            $notification = [
                'type' => 'competitor_metadata_changed',
                'alert_rule_id' => $rule->id,
                'title' => "{$competitorApp->name} updated their metadata",
                'body' => "Changed: {$fieldsText}",
                'data' => [
                    'competitor_app_id' => $competitorApp->id,
                    'competitor_name' => $competitorApp->name,
                    'changed_fields' => $matchedFields,
                    'snapshot_id' => $newSnapshot->id,
                    'locale' => $this->locale,
                ],
            ];

            $notificationService->send($user, collect([$notification]));

            Log::info('Competitor metadata alert sent', [
                'user_id' => $user->id,
                'competitor_app_id' => $competitorApp->id,
                'changed_fields' => $matchedFields,
            ]);
        }
    }

    /**
     * Convert locale to country code
     */
    private function localeToCountry(string $locale): string
    {
        $mapping = [
            'en-US' => 'us',
            'en-GB' => 'gb',
            'en-AU' => 'au',
            'en-CA' => 'ca',
            'fr-FR' => 'fr',
            'de-DE' => 'de',
            'ja' => 'jp',
            'zh-Hans' => 'cn',
            'ko' => 'kr',
            'it' => 'it',
            'es-ES' => 'es',
            'nl-NL' => 'nl',
            'pt-BR' => 'br',
            'es-MX' => 'mx',
            'ru' => 'ru',
            'en-IN' => 'in',
        ];

        return $mapping[$locale] ?? 'us';
    }

    public function tags(): array
    {
        return ['aso', 'competitor', 'metadata', $this->competitorAppId ? "app:{$this->competitorAppId}" : 'all'];
    }
}
