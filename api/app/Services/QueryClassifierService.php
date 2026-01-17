<?php

namespace App\Services;

use Illuminate\Support\Facades\Cache;

class QueryClassifierService
{
    private const VALID_SOURCES = ['reviews', 'rankings', 'analytics', 'competitors', 'app_info', 'none'];

    public function __construct(
        private OpenRouterService $openRouter,
    ) {}

    /**
     * Classify a user question to determine which data sources are needed.
     * Uses LLM for robust multilingual classification.
     *
     * @return array<string> List of data sources: 'reviews', 'rankings', 'analytics', 'competitors', 'app_info'
     */
    public function classify(string $question): array
    {
        // Cache classification for identical questions (5 min TTL)
        $cacheKey = 'query_class:' . md5($question);

        return Cache::remember($cacheKey, 300, function () use ($question) {
            return $this->classifyWithLLM($question);
        });
    }

    private function classifyWithLLM(string $question): array
    {
        $prompt = <<<'PROMPT'
Classify this user message to determine which data sources are needed to answer it.

Available categories (return one or more, comma-separated):
- reviews: user reviews, feedback, ratings, complaints, bugs, feature requests
- rankings: keyword positions, ASO, search visibility, app store rankings
- analytics: downloads, revenue, sales, subscribers, conversion, retention
- competitors: competitor apps, market comparison
- app_info: app metadata, version, description, screenshots
- none: action requests (add keyword, create alert, etc.) that don't need data

Return ONLY the category names, comma-separated. Example: "reviews,rankings" or "none"

User message: "{question}"
PROMPT;

        $prompt = str_replace('{question}', $question, $prompt);

        $response = $this->openRouter->chat(
            'You are a classification assistant. Return only category names.',
            $prompt,
            false // not streaming
        );

        if (!$response || empty($response['content'])) {
            // Fallback to reviews if LLM fails
            return ['reviews'];
        }

        return $this->parseCategories($response['content']);
    }

    /**
     * Parse LLM response into valid category array.
     */
    private function parseCategories(string $response): array
    {
        $lower = strtolower(trim($response));

        // Extract valid categories from response
        $sources = [];
        foreach (self::VALID_SOURCES as $source) {
            if (str_contains($lower, $source)) {
                if ($source !== 'none') {
                    $sources[] = $source;
                }
            }
        }

        // If "none" was returned (action request), default to rankings for context
        if (empty($sources) && str_contains($lower, 'none')) {
            $sources[] = 'rankings';
        }

        // Fallback if nothing parsed
        if (empty($sources)) {
            $sources[] = 'reviews';
        }

        return array_unique($sources);
    }

    /**
     * Get a human-readable description of the data sources.
     */
    public function describeDataSources(array $sources): string
    {
        $descriptions = [
            'reviews' => 'user reviews and feedback',
            'rankings' => 'keyword rankings and search positions',
            'analytics' => 'downloads, revenue, and analytics data',
            'competitors' => 'competitor comparisons',
            'app_info' => 'app metadata and store listing',
        ];

        $parts = array_map(fn($s) => $descriptions[$s] ?? $s, $sources);

        return implode(', ', $parts);
    }
}
