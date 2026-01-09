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
    private const CATEGORIES = ['ux', 'performance', 'features', 'pricing', 'support', 'onboarding'];

    public function __construct(
        private OpenRouterService $openRouter
    ) {}

    /**
     * Generate insights for an app
     */
    public function generateInsights(App $app, array $countries, int $periodMonths = 6): ?AppInsight
    {
        $periodStart = Carbon::now()->subMonths($periodMonths)->startOfDay();
        $periodEnd = Carbon::now()->endOfDay();

        // Fetch reviews
        $reviews = $this->fetchReviews($app, $countries, $periodStart, $periodEnd);

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
            : $this->synthesizeChunks($app, $chunkAnalyses, $reviews->count());

        if (!$finalAnalysis) {
            return null;
        }

        // Store and return
        return AppInsight::create([
            'app_id' => $app->id,
            'analysis_type' => 'full',
            'reviews_count' => $reviews->count(),
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

    private function fetchReviews(App $app, array $countries, Carbon $start, Carbon $end)
    {
        return AppReview::where('app_id', $app->id)
            ->whereIn('country', array_map('strtoupper', $countries))
            ->whereBetween('reviewed_at', [$start, $end])
            ->orderByDesc('reviewed_at')
            ->get(['rating', 'title', 'content', 'reviewed_at', 'country']);
    }

    private function analyzeChunk(App $app, array $reviews): ?array
    {
        $systemPrompt = $this->buildSystemPrompt();
        $userPrompt = $this->buildUserPrompt($app, $reviews);

        return $this->openRouter->chat($systemPrompt, $userPrompt);
    }

    private function synthesizeChunks(App $app, array $analyses, int $totalReviews): ?array
    {
        $systemPrompt = <<<PROMPT
Tu es un analyste ASO expert. Tu reçois plusieurs analyses partielles de reviews d'une même app.
Synthétise-les en une analyse unique et cohérente.
Réponds en JSON avec la même structure que les analyses partielles.
PROMPT;

        $userPrompt = "APP: {$app->name}\n";
        $userPrompt .= "TOTAL REVIEWS: {$totalReviews}\n\n";
        $userPrompt .= "ANALYSES PARTIELLES:\n";
        $userPrompt .= json_encode($analyses, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

        return $this->openRouter->chat($systemPrompt, $userPrompt);
    }

    private function buildSystemPrompt(): string
    {
        return <<<PROMPT
Tu es un analyste ASO expert. Analyse les reviews d'application mobile fournies.

Réponds UNIQUEMENT en JSON valide avec cette structure exacte:
{
  "categories": {
    "ux": { "score": <1-5>, "summary": "<résumé en 1-2 phrases>" },
    "performance": { "score": <1-5>, "summary": "<résumé>" },
    "features": { "score": <1-5>, "summary": "<résumé>" },
    "pricing": { "score": <1-5>, "summary": "<résumé>" },
    "support": { "score": <1-5>, "summary": "<résumé>" },
    "onboarding": { "score": <1-5>, "summary": "<résumé>" }
  },
  "emergent_themes": [
    {
      "label": "<nom court du thème>",
      "sentiment": "positive|negative|mixed",
      "frequency": <nombre de mentions estimé>,
      "summary": "<description en 1-2 phrases>",
      "example_quotes": ["<citation 1>", "<citation 2>"]
    }
  ],
  "overall_strengths": ["<force 1>", "<force 2>"],
  "overall_weaknesses": ["<faiblesse 1>", "<faiblesse 2>"],
  "opportunities": ["<opportunité 1>", "<opportunité 2>"]
}

Règles:
- Score 1 = très mauvais, 5 = excellent
- Maximum 5 thèmes émergents, les plus significatifs
- Maximum 5 items par liste (strengths, weaknesses, opportunities)
- Sois concis et factuel
- Réponds en français si les reviews sont majoritairement en français, sinon en anglais
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
