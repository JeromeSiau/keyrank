<?php

namespace App\Services;

use App\Models\App;
use App\Models\AppInsight;
use App\Models\AppReview;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;

class InsightsService
{
    private const CHUNK_SIZE = 100;
    private const MAX_REVIEWS = 500; // Cap to avoid timeout and cost explosion
    private const CATEGORIES = ['ux', 'performance', 'features', 'pricing', 'support', 'onboarding'];
    private const LANGUAGE_NAMES = [
        'en' => 'English',
        'fr' => 'French',
        'de' => 'German',
        'es' => 'Spanish',
        'pt' => 'Portuguese',
        'it' => 'Italian',
        'ja' => 'Japanese',
        'ko' => 'Korean',
        'zh' => 'Chinese',
        'tr' => 'Turkish',
    ];

    private string $locale = 'en';

    public function __construct(
        private OpenRouterService $openRouter
    ) {}

    /**
     * Generate insights for an app
     */
    public function generateInsights(App $app, array $countries, int $periodMonths = 6, ?string $locale = null): ?AppInsight
    {
        $this->locale = $locale ?? 'en';

        $periodStart = Carbon::now()->subMonths($periodMonths)->startOfDay();
        $periodEnd = Carbon::now()->endOfDay();

        // Fetch reviews (with sampling if too many)
        [$reviews, $totalCount] = $this->fetchReviews($app, $countries, $periodStart, $periodEnd);

        if ($reviews->isEmpty()) {
            return null;
        }

        // Chunk and analyze
        $chunks = $reviews->chunk(self::CHUNK_SIZE);
        $chunkAnalyses = [];

        foreach ($chunks as $chunk) {
            $analysis = $this->analyzeChunk($app, $chunk->toArray());
            if ($analysis) {
                $chunkAnalyses[] = $analysis;
            }
        }

        if (empty($chunkAnalyses)) {
            return null;
        }

        // Synthesize if multiple chunks
        $finalAnalysis = count($chunkAnalyses) === 1
            ? $chunkAnalyses[0]
            : $this->synthesizeChunks($app, $chunkAnalyses, $totalCount);

        if (!$finalAnalysis) {
            return null;
        }

        // Store and return
        return AppInsight::create([
            'app_id' => $app->id,
            'analysis_type' => 'full',
            'reviews_count' => $totalCount,
            'countries' => $countries,
            'period_start' => $periodStart,
            'period_end' => $periodEnd,
            'category_scores' => $finalAnalysis['categories'] ?? [],
            'category_summaries' => $this->extractSummaries($finalAnalysis['categories'] ?? []),
            'emergent_themes' => $finalAnalysis['emergent_themes'] ?? [],
            'overall_strengths' => $finalAnalysis['overall_strengths'] ?? [],
            'overall_weaknesses' => $finalAnalysis['overall_weaknesses'] ?? [],
            'opportunities' => $finalAnalysis['opportunities'] ?? [],
            'raw_llm_response' => json_encode($finalAnalysis),
        ]);
    }

    /**
     * Fetch reviews with stratified sampling if too many
     * @return array [Collection $reviews, int $totalCount]
     */
    private function fetchReviews(App $app, array $countries, Carbon $start, Carbon $end): array
    {
        $query = AppReview::where('app_id', $app->id)
            ->whereIn('country', array_map('strtoupper', $countries))
            ->whereBetween('reviewed_at', [$start, $end]);

        $totalCount = $query->count();

        // If under the limit, fetch all
        if ($totalCount <= self::MAX_REVIEWS) {
            $reviews = $query->orderByDesc('reviewed_at')
                ->get(['rating', 'title', 'content', 'reviewed_at', 'country']);
            return [$reviews, $totalCount];
        }

        // Stratified sampling: proportional to rating distribution
        // This ensures we get a representative sample across all ratings
        Log::info("Sampling {$totalCount} reviews down to " . self::MAX_REVIEWS . " for app {$app->id}");

        $reviews = collect();
        $perRating = (int) ceil(self::MAX_REVIEWS / 5);

        for ($rating = 1; $rating <= 5; $rating++) {
            $ratingReviews = AppReview::where('app_id', $app->id)
                ->whereIn('country', array_map('strtoupper', $countries))
                ->whereBetween('reviewed_at', [$start, $end])
                ->where('rating', $rating)
                ->inRandomOrder()
                ->limit($perRating)
                ->get(['rating', 'title', 'content', 'reviewed_at', 'country']);

            $reviews = $reviews->merge($ratingReviews);
        }

        return [$reviews->shuffle()->take(self::MAX_REVIEWS), $totalCount];
    }

    private function analyzeChunk(App $app, array $reviews): ?array
    {
        $systemPrompt = $this->buildSystemPrompt();
        $userPrompt = $this->buildUserPrompt($app, $reviews);

        return $this->openRouter->chat($systemPrompt, $userPrompt);
    }

    private function synthesizeChunks(App $app, array $analyses, int $totalReviews): ?array
    {
        $language = self::LANGUAGE_NAMES[$this->locale] ?? 'English';

        $systemPrompt = <<<PROMPT
You are an expert ASO analyst. You receive multiple partial analyses of reviews from the same app.
Synthesize them into a single coherent analysis.
Respond in JSON with the same structure as the partial analyses.
IMPORTANT: Respond in {$language}.
PROMPT;

        $userPrompt = "APP: {$app->name}\n";
        $userPrompt .= "TOTAL REVIEWS: {$totalReviews}\n\n";
        $userPrompt .= "PARTIAL ANALYSES:\n";
        $userPrompt .= json_encode($analyses, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

        return $this->openRouter->chat($systemPrompt, $userPrompt);
    }

    private function buildSystemPrompt(): string
    {
        $language = self::LANGUAGE_NAMES[$this->locale] ?? 'English';

        return <<<PROMPT
You are an expert ASO analyst. Analyze the provided mobile app reviews.

Respond ONLY with valid JSON using this exact structure:
{
  "categories": {
    "ux": { "score": <1-5>, "summary": "<1-2 sentence summary>" },
    "performance": { "score": <1-5>, "summary": "<summary>" },
    "features": { "score": <1-5>, "summary": "<summary>" },
    "pricing": { "score": <1-5>, "summary": "<summary>" },
    "support": { "score": <1-5>, "summary": "<summary>" },
    "onboarding": { "score": <1-5>, "summary": "<summary>" }
  },
  "emergent_themes": [
    {
      "label": "<short theme name>",
      "sentiment": "positive|negative|mixed",
      "frequency": <estimated mention count>,
      "summary": "<1-2 sentence description>",
      "example_quotes": ["<quote 1>", "<quote 2>"]
    }
  ],
  "overall_strengths": ["<strength 1>", "<strength 2>"],
  "overall_weaknesses": ["<weakness 1>", "<weakness 2>"],
  "opportunities": ["<opportunity 1>", "<opportunity 2>"]
}

Rules:
- Score 1 = very bad, 5 = excellent
- Maximum 5 emergent themes, the most significant ones
- Maximum 5 items per list (strengths, weaknesses, opportunities)
- Be concise and factual
- IMPORTANT: Respond in {$language}. All summaries, theme labels, strengths, weaknesses, and opportunities must be written in {$language}.
- IMPORTANT for example_quotes: quote EXACTLY the text from the reviews (verbatim, copy-paste). Each quote must come from a DIFFERENT review. If a theme has only one review, include only one quote.
PROMPT;
    }

    private function buildUserPrompt(App $app, array $reviews): string
    {
        $prompt = "APP: {$app->name} ({$app->platform})\n";
        $prompt .= "REVIEWS: " . count($reviews) . "\n\n";
        $prompt .= "---\n";

        foreach ($reviews as $review) {
            $rating = $review['rating'] ?? 'N/A';
            $date = $review['reviewed_at'] ?? 'N/A';
            $title = $review['title'] ?? '';
            $content = $review['content'] ?? '';
            $country = $review['country'] ?? '';

            $prompt .= "[{$rating}/5] [{$country}] {$date}\n";
            if ($title) {
                $prompt .= "Title: {$title}\n";
            }
            $prompt .= "{$content}\n";
            $prompt .= "---\n";
        }

        return $prompt;
    }

    private function extractSummaries(array $categories): array
    {
        $summaries = [];
        foreach ($categories as $key => $data) {
            $summaries[$key] = $data['summary'] ?? '';
        }
        return $summaries;
    }
}
