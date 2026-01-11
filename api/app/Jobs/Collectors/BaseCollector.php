<?php

namespace App\Jobs\Collectors;

use App\Models\JobExecution;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Log;

abstract class BaseCollector implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Rate limit between API calls in milliseconds
     */
    protected int $rateLimitMs = 300;

    /**
     * Batch size for processing
     */
    protected int $batchSize = 50;

    /**
     * Maximum retries for the job
     */
    public int $tries = 3;

    /**
     * Timeout in seconds
     */
    public int $timeout = 3600;

    /**
     * Current job execution record
     */
    protected ?JobExecution $execution = null;

    /**
     * Create a new collector instance
     */
    public function __construct()
    {
        $this->onQueue('collectors');
    }

    /**
     * Get the collector name for logging and monitoring
     */
    abstract public function getCollectorName(): string;

    /**
     * Get the items to process
     */
    abstract public function getItems(): Collection;

    /**
     * Process a single item
     */
    abstract public function processItem(mixed $item): void;

    /**
     * Execute the job
     */
    public function handle(): void
    {
        $this->startExecution();

        try {
            $items = $this->getItems();

            Log::info("[{$this->getCollectorName()}] Starting collection", [
                'items_count' => $items->count(),
            ]);

            foreach ($items as $item) {
                try {
                    $this->processItem($item);
                    $this->execution->incrementProcessed();

                    // Rate limiting between API calls
                    if ($this->rateLimitMs > 0) {
                        usleep($this->rateLimitMs * 1000);
                    }
                } catch (\Exception $e) {
                    $this->handleItemError($item, $e);
                }
            }

            $this->completeExecution();

            Log::info("[{$this->getCollectorName()}] Collection completed", [
                'items_processed' => $this->execution->items_processed,
                'items_failed' => $this->execution->items_failed,
                'duration_ms' => $this->execution->duration_ms,
            ]);
        } catch (\Exception $e) {
            $this->failExecution($e->getMessage());

            Log::error("[{$this->getCollectorName()}] Collection failed", [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            throw $e;
        }
    }

    /**
     * Start tracking the job execution
     */
    protected function startExecution(): void
    {
        $this->execution = JobExecution::start($this->getCollectorName());
    }

    /**
     * Mark execution as completed
     */
    protected function completeExecution(): void
    {
        $this->execution->markCompleted();
    }

    /**
     * Mark execution as failed
     */
    protected function failExecution(string $errorMessage): void
    {
        $this->execution->markFailed($errorMessage);
    }

    /**
     * Handle an error for a specific item
     */
    protected function handleItemError(mixed $item, \Exception $e): void
    {
        $this->execution->incrementFailed();

        Log::warning("[{$this->getCollectorName()}] Error processing item", [
            'item' => $this->getItemIdentifier($item),
            'error' => $e->getMessage(),
        ]);
    }

    /**
     * Get an identifier for an item (for logging)
     * Override this to provide meaningful identifiers
     */
    protected function getItemIdentifier(mixed $item): string
    {
        if (is_object($item) && method_exists($item, 'getKey')) {
            return (string) $item->getKey();
        }

        if (is_array($item) && isset($item['id'])) {
            return (string) $item['id'];
        }

        return 'unknown';
    }

    /**
     * Process items in batches
     */
    protected function processInBatches(Collection $items, callable $processor): void
    {
        $items->chunk($this->batchSize)->each(function (Collection $batch) use ($processor) {
            $processor($batch);
        });
    }

    /**
     * Get the tags that should be used for the job
     */
    public function tags(): array
    {
        return [
            'collector',
            $this->getCollectorName(),
        ];
    }
}
