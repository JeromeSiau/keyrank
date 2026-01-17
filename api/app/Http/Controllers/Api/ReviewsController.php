<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Concerns\AuthorizesTeamActions;
use App\Models\App;
use App\Models\AppReview;
use App\Services\AppStoreConnectService;
use App\Services\GooglePlayDeveloperService;
use App\Services\OpenRouterService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ReviewsController extends Controller
{
    use AuthorizesTeamActions;
    public function __construct(
        private AppStoreConnectService $appStoreConnect,
        private GooglePlayDeveloperService $googlePlay,
        private OpenRouterService $openRouter,
    ) {}

    /**
     * Get reviews inbox for team's owned apps only
     */
    public function inbox(Request $request): JsonResponse
    {
        $user = Auth::user();
        $team = $this->currentTeam();

        // Only show reviews from owned apps (apps synced from connected store accounts)
        $ownedAppIds = $team->apps()->wherePivot('is_owner', true)->pluck('apps.id');

        if ($ownedAppIds->isEmpty()) {
            return response()->json([
                'data' => [],
                'meta' => [
                    'current_page' => 1,
                    'last_page' => 1,
                    'per_page' => $request->input('per_page', 20),
                    'total' => 0,
                ],
            ]);
        }

        // Check which platforms have active store connections
        $hasIosConnection = $user->hasStoreConnection('ios');
        $hasAndroidConnection = $user->hasStoreConnection('android');

        $query = AppReview::whereIn('app_id', $ownedAppIds)
            ->with('app:id,name,icon_url,platform');

        // Filter by status (unanswered/answered)
        if ($request->has('status')) {
            if ($request->status === 'unanswered') {
                $query->unanswered();
            } elseif ($request->status === 'answered') {
                $query->answered();
            }
        }

        // Filter by rating
        if ($request->has('rating')) {
            $query->where('rating', $request->rating);
        }

        // Filter by sentiment
        if ($request->has('sentiment')) {
            $query->bySentiment($request->sentiment);
        }

        // Filter by app_id
        if ($request->has('app_id')) {
            $query->where('app_id', $request->app_id);
        }

        // Filter by country
        if ($request->has('country')) {
            $query->where('country', strtoupper($request->country));
        }

        // Search in title, content, author
        if ($request->has('search') && $request->search) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                    ->orWhere('content', 'like', "%{$search}%")
                    ->orWhere('author', 'like', "%{$search}%");
            });
        }

        $perPage = min($request->input('per_page', 20), 100);
        $reviews = $query->orderByDesc('reviewed_at')->paginate($perPage);

        return response()->json([
            'data' => $reviews->map(function ($review) use ($hasIosConnection, $hasAndroidConnection) {
                // All reviews in inbox are from owned apps
                $hasConnection = $review->app->platform === 'ios' ? $hasIosConnection : $hasAndroidConnection;

                return [
                    'id' => $review->id,
                    'app' => [
                        'id' => $review->app->id,
                        'name' => $review->app->name,
                        'icon_url' => $review->app->icon_url,
                        'platform' => $review->app->platform,
                        'is_owned' => true,
                    ],
                    'author' => $review->author,
                    'title' => $review->title,
                    'content' => $review->content,
                    'rating' => $review->rating,
                    'country' => $review->country,
                    'sentiment' => $review->sentiment,
                    'reviewed_at' => $review->reviewed_at?->toIso8601String(),
                    'our_response' => $review->our_response,
                    'responded_at' => $review->responded_at?->toIso8601String(),
                    'can_reply' => $hasConnection,
                ];
            }),
            'meta' => [
                'current_page' => $reviews->currentPage(),
                'last_page' => $reviews->lastPage(),
                'per_page' => $reviews->perPage(),
                'total' => $reviews->total(),
            ],
        ]);
    }

    /**
     * Reply to a review
     */
    public function reply(Request $request, App $app, AppReview $review): JsonResponse
    {
        $user = Auth::user();
        $team = $this->currentTeam();

        // Check team owns the app
        if (!$team->apps()->where('apps.id', $app->id)->exists()) {
            return response()->json(['error' => 'You do not own this app.'], 403);
        }

        // Check review belongs to this app
        if ($review->app_id !== $app->id) {
            return response()->json(['error' => 'Review does not belong to this app.'], 404);
        }

        // Validate response (max 5970 chars - Apple limit)
        $validated = $request->validate([
            'response' => 'required|string|max:5970',
        ]);

        // Get store connection for app's platform
        $connection = $user->getStoreConnection($app->platform);
        if (!$connection) {
            return response()->json([
                'error' => "No active {$app->platform} store connection found. Please connect your " .
                    ($app->platform === 'ios' ? 'App Store Connect' : 'Google Play Console') . ' account first.',
            ], 422);
        }

        // Send reply to the appropriate store
        $result = null;
        if ($app->platform === 'ios') {
            $result = $this->appStoreConnect->replyToReview(
                $connection,
                $review->review_id,
                $validated['response']
            );
        } else {
            $result = $this->googlePlay->replyToReview(
                $connection,
                $app->store_id,
                $review->review_id,
                $validated['response']
            );
        }

        if (!$result) {
            return response()->json([
                'error' => 'Failed to send reply to the store. Please try again.',
            ], 500);
        }

        // Extract store response ID based on platform
        $storeResponseId = null;
        if ($app->platform === 'ios') {
            $storeResponseId = $result['data']['id'] ?? null;
        } else {
            $storeResponseId = $result['result']['replyId'] ?? null;
        }

        // Update review with our response
        $review->update([
            'our_response' => $validated['response'],
            'responded_at' => now(),
            'store_response_id' => $storeResponseId,
        ]);

        return response()->json([
            'data' => [
                'id' => $review->id,
                'our_response' => $review->our_response,
                'responded_at' => $review->responded_at?->toIso8601String(),
                'store_response_id' => $review->store_response_id,
            ],
        ]);
    }

    /**
     * Generate AI suggestion for a review reply
     */
    public function suggestReply(Request $request, App $app, AppReview $review): JsonResponse
    {
        $user = Auth::user();
        $team = $this->currentTeam();

        // Check team owns the app
        if (!$team->apps()->where('apps.id', $app->id)->exists()) {
            return response()->json(['error' => 'You do not own this app.'], 403);
        }

        // Check review belongs to this app
        if ($review->app_id !== $app->id) {
            return response()->json(['error' => 'Review does not belong to this app.'], 404);
        }

        // Validate optional tone parameter
        $validated = $request->validate([
            'tone' => 'nullable|string|in:professional,empathetic,brief',
        ]);

        $requestedTone = $validated['tone'] ?? null;

        // Get voice settings for the app/user
        $voiceSettings = $app->getVoiceSettingForUser($user->id);

        // Detect issues from review content
        $detectedIssues = $this->detectIssuesFromReview($review);

        // Use enriched sentiment from sync job, or fallback to rating-based
        $sentiment = $review->sentiment ?? ($review->rating >= 4 ? 'positive' : ($review->rating <= 2 ? 'negative' : 'neutral'));

        // Generate suggestions - single API call for all 3 tones, or one tone if specified
        if ($requestedTone) {
            // Single tone requested - make one call
            $suggestions = $this->generateSingleTone($app, $review, $requestedTone, $voiceSettings, $detectedIssues);
        } else {
            // Generate all 3 tones in a single API call (cost optimization: 1 call instead of 3)
            $suggestions = $this->generateAllTones($app, $review, $voiceSettings, $detectedIssues);
        }

        if (empty($suggestions)) {
            return response()->json([
                'error' => 'Failed to generate suggestions. Please try again.',
            ], 500);
        }

        return response()->json([
            'data' => [
                'suggestions' => $suggestions,
                'detected_issues' => $detectedIssues,
                'sentiment' => $sentiment,
            ],
        ]);
    }

    /**
     * Generate all 3 tones in a single API call (cost optimization)
     */
    private function generateAllTones(App $app, AppReview $review, $voiceSettings, array $detectedIssues): array
    {
        $systemPrompt = $this->buildMultiToneSystemPrompt($app, $voiceSettings);
        $userPrompt = $this->buildReplyUserPrompt($review, $detectedIssues);

        $result = $this->openRouter->chat($systemPrompt, $userPrompt, true);

        if (!$result) {
            \Log::error('OpenRouter API failed for multi-tone generation', [
                'app_id' => $app->id,
                'review_id' => $review->id,
            ]);
            return [];
        }

        $suggestions = [];
        $signature = $voiceSettings?->signature;

        // Parse the 3 tones from the response
        foreach (['professional', 'empathetic', 'brief'] as $tone) {
            $content = $result[$tone] ?? null;
            if ($content) {
                if ($signature) {
                    $content .= "\n\n" . $signature;
                }
                $suggestions[] = [
                    'tone' => $tone,
                    'content' => $content,
                ];
            }
        }

        return $suggestions;
    }

    /**
     * Generate a single tone reply
     */
    private function generateSingleTone(App $app, AppReview $review, string $tone, $voiceSettings, array $detectedIssues): array
    {
        $systemPrompt = $this->buildSingleToneSystemPrompt($app, $tone, $voiceSettings);
        $userPrompt = $this->buildReplyUserPrompt($review, $detectedIssues);

        $result = $this->openRouter->chat($systemPrompt, $userPrompt, true);

        if (!$result) {
            \Log::error('OpenRouter API failed', [
                'app_id' => $app->id,
                'review_id' => $review->id,
                'tone' => $tone,
            ]);
            return [];
        }

        $content = $result['reply'] ?? $result['content'] ?? null;

        if (!$content) {
            return [];
        }

        if ($voiceSettings?->signature) {
            $content .= "\n\n" . $voiceSettings->signature;
        }

        return [[
            'tone' => $tone,
            'content' => $content,
        ]];
    }

    /**
     * Detect issues mentioned in the review
     */
    private function detectIssuesFromReview(AppReview $review): array
    {
        $issues = [];
        $content = strtolower($review->content . ' ' . ($review->title ?? ''));

        $issuePatterns = [
            'crash' => ['crash', 'crashes', 'crashing', 'stopped working', 'force close'],
            'bug' => ['bug', 'glitch', 'broken', 'not working', 'doesnt work', "doesn't work"],
            'slow' => ['slow', 'laggy', 'lag', 'freezes', 'freeze', 'hangs', 'performance'],
            'login' => ['login', 'sign in', 'signin', 'authentication', 'password', 'account'],
            'sync' => ['sync', 'syncing', 'synchronize', 'data loss', 'lost data'],
            'ui' => ['confusing', 'hard to use', 'ui', 'interface', 'design', 'ugly'],
            'battery' => ['battery', 'drain', 'power', 'energy'],
            'notifications' => ['notification', 'notifications', 'alerts', 'push'],
            'payment' => ['payment', 'subscription', 'purchase', 'billing', 'refund', 'charge'],
            'update' => ['update', 'new version', 'latest version', 'after update'],
            'ads' => ['ads', 'advertisements', 'too many ads', 'ad'],
            'offline' => ['offline', 'internet', 'connection', 'network'],
        ];

        foreach ($issuePatterns as $issue => $patterns) {
            foreach ($patterns as $pattern) {
                if (str_contains($content, $pattern)) {
                    $issues[] = $issue;
                    break;
                }
            }
        }

        return array_unique($issues);
    }

    /**
     * Build system prompt for generating all 3 tones in one call (cost optimization)
     */
    private function buildMultiToneSystemPrompt(App $app, $voiceSettings): string
    {
        $prompt = "You are a helpful assistant that generates app review replies for '{$app->name}'.";
        $prompt .= " Generate 3 different reply options in different tones.";
        $prompt .= " Keep all replies under 500 characters. Match the language of the review.";

        if ($voiceSettings && $voiceSettings->tone_description) {
            $prompt .= "\n\nAdditional tone guidelines: {$voiceSettings->tone_description}";
        }

        $prompt .= "\n\nRespond with a JSON object containing exactly these 3 fields:";
        $prompt .= "\n- \"professional\": A professional, business-like response. Courteous and solution-focused.";
        $prompt .= "\n- \"empathetic\": A warm, empathetic response showing genuine understanding.";
        $prompt .= "\n- \"brief\": A very concise response (under 200 characters). Friendly but brief.";

        return $prompt;
    }

    /**
     * Build system prompt for a single tone
     */
    private function buildSingleToneSystemPrompt(App $app, string $tone, $voiceSettings): string
    {
        $prompt = "You are a helpful assistant that generates app review replies for '{$app->name}'.";

        switch ($tone) {
            case 'professional':
                $prompt .= " Write in a professional, business-like tone. Be courteous and solution-focused.";
                break;
            case 'empathetic':
                $prompt .= " Write in a warm, empathetic tone. Show genuine understanding.";
                break;
            case 'brief':
                $prompt .= " Write a very concise response (under 200 characters). Be friendly but brief.";
                break;
        }

        $prompt .= " Keep reply under 500 characters. Match the language of the review.";

        if ($voiceSettings && $voiceSettings->tone_description) {
            $prompt .= "\n\nAdditional tone guidelines: {$voiceSettings->tone_description}";
        }

        $prompt .= "\n\nRespond with a JSON object containing a 'reply' field.";

        return $prompt;
    }

    /**
     * Build user prompt for review reply generation
     */
    private function buildReplyUserPrompt(AppReview $review, array $detectedIssues = []): string
    {
        $prompt = "Please generate a reply for this app review:\n\n";
        $prompt .= "Rating: {$review->rating}/5 stars\n";

        if ($review->title) {
            $prompt .= "Title: {$review->title}\n";
        }

        $prompt .= "Review: {$review->content}\n";
        $prompt .= "Author: {$review->author}\n";
        $prompt .= "Country: {$review->country}";

        if (!empty($detectedIssues)) {
            $prompt .= "\n\nDetected issues to address: " . implode(', ', $detectedIssues);
        }

        return $prompt;
    }

    /**
     * Get reviews for an app from a specific country
     * Data is collected by background collectors - no on-demand fetching
     */
    public function forCountry(Request $request, App $app, string $country): JsonResponse
    {
        $country = strtoupper($country);
        $platform = $app->platform;

        if (!$platform) {
            return response()->json(['message' => 'App has no platform'], 400);
        }

        // Get stored reviews from database (no on-demand fetching)
        $reviews = $app->reviews()
            ->select([
                'id',
                'author',
                'title',
                'content',
                'rating',
                'version',
                'sentiment',
                'reviewed_at',
            ])
            ->where('country', $country)
            ->orderByDesc('reviewed_at')
            ->limit(100)
            ->get();

        return response()->json([
            'data' => [
                'app_id' => $app->id,
                'platform' => $platform,
                'country' => $country,
                'reviews' => $reviews->map(fn($r) => [
                    'id' => $r->id,
                    'author' => $r->author,
                    'title' => $r->title,
                    'content' => $r->content,
                    'rating' => $r->rating,
                    'version' => $r->version,
                    'sentiment' => $r->sentiment,
                    'reviewed_at' => $r->reviewed_at->toIso8601String(),
                ]),
                'total' => $reviews->count(),
            ],
        ]);
    }

    /**
     * Get review counts summary for all countries
     */
    public function summary(Request $request, App $app): JsonResponse
    {
        $platform = $app->platform;

        if (!$platform) {
            return response()->json(['message' => 'App has no platform'], 400);
        }

        $summary = $app->reviews()
            ->selectRaw('country, COUNT(*) as review_count, AVG(rating) as avg_rating, MAX(reviewed_at) as latest_review')
            ->groupBy('country')
            ->orderByDesc('review_count')
            ->get();

        return response()->json([
            'data' => [
                'app_id' => $app->id,
                'platform' => $platform,
                'countries' => $summary->map(fn($s) => [
                    'country' => $s->country,
                    'review_count' => (int) $s->review_count,
                    'avg_rating' => round((float) $s->avg_rating, 2),
                    'latest_review' => $s->latest_review,
                ]),
            ],
        ]);
    }
}
