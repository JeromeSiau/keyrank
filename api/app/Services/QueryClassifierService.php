<?php

namespace App\Services;

class QueryClassifierService
{
    /**
     * Classify a user question to determine which data sources are needed.
     *
     * @return array<string> List of data sources: 'reviews', 'rankings', 'analytics', 'competitors'
     */
    public function classify(string $question): array
    {
        $sources = [];
        $lower = strtolower($question);

        // Reviews indicators
        if (preg_match('/review|complaint|feedback|user|say|mention|bug|crash|feature request|opinion|comment|rate|rating|star/i', $lower)) {
            $sources[] = 'reviews';
        }

        // Rankings indicators
        if (preg_match('/rank|position|keyword|aso|visibility|search|discover|organic|install/i', $lower)) {
            $sources[] = 'rankings';
        }

        // Analytics indicators
        if (preg_match('/download|revenue|money|earn|subscriber|country|growth|sale|purchase|iap|in-app|conversion|retention|arpu|ltv/i', $lower)) {
            $sources[] = 'analytics';
        }

        // Competitor indicators
        if (preg_match('/competitor|compare|versus|vs|better|worse|market|rival|alternative/i', $lower)) {
            $sources[] = 'competitors';
        }

        // General app info indicators
        if (preg_match('/version|update|release|category|description|title|icon|screenshot/i', $lower)) {
            $sources[] = 'app_info';
        }

        // Default to reviews if nothing matched (most common use case)
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
