<?php

namespace App\Services;

use App\Models\App;
use App\Models\ChatConversation;
use App\Models\ChatMessage;
use App\Models\ChatUsage;
use App\Models\User;
use Illuminate\Support\Facades\Log;

class ChatService
{
    private const SYSTEM_PROMPT = <<<'PROMPT'
You are an ASO (App Store Optimization) expert assistant for Keyrank.
You help app developers understand their app's performance and user feedback.

Guidelines:
- Be concise and actionable
- Use bullet points for lists
- Reference specific data when making claims
- Suggest next steps when appropriate
- If data is insufficient, say so honestly
- Match the user's language
- Focus on insights that help improve the app's visibility and ratings
PROMPT;

    public function __construct(
        private QueryClassifierService $classifier,
        private ContextBuilderService $contextBuilder,
        private OpenRouterService $openRouter,
    ) {}

    /**
     * Process a user question and generate a response.
     */
    public function ask(
        ChatConversation $conversation,
        string $question,
        User $user,
    ): ChatMessage {
        $app = $conversation->app;

        // 1. Classify the question to determine data sources
        $dataSources = $this->classifier->classify($question);

        // 2. Build context from relevant data sources
        $context = $app
            ? $this->contextBuilder->build($app, $dataSources, $user->id)
            : [];

        // 3. Format context for the prompt
        $formattedContext = $app
            ? $this->contextBuilder->formatForPrompt($context)
            : 'No specific app selected. Please select an app to get detailed insights.';

        // 4. Build the full prompt
        $systemPrompt = $this->buildSystemPrompt($app, $formattedContext);

        // 5. Get conversation history for context
        $conversationHistory = $this->getConversationHistory($conversation);
        $userPrompt = $this->buildUserPrompt($question, $conversationHistory);

        // 6. Save user message
        $userMessage = $conversation->messages()->create([
            'role' => 'user',
            'content' => $question,
        ]);

        // 7. Generate response via LLM
        $response = $this->openRouter->chat($systemPrompt, $userPrompt, false);

        $assistantContent = $response['content'] ?? 'I apologize, but I was unable to generate a response. Please try again.';
        $tokensUsed = $response['tokens_used'] ?? 0;

        // 8. Save assistant message
        $assistantMessage = $conversation->messages()->create([
            'role' => 'assistant',
            'content' => $assistantContent,
            'data_sources_used' => $dataSources,
            'tokens_used' => $tokensUsed,
        ]);

        // 9. Update conversation title if this is the first message
        if ($conversation->messages()->count() <= 2) {
            $conversation->generateTitle();
        }

        // 10. Track usage
        $this->trackUsage($user, $tokensUsed);

        return $assistantMessage;
    }

    /**
     * Quick ask without conversation history (for one-off questions).
     */
    public function quickAsk(App $app, string $question, User $user): array
    {
        // 1. Classify and build context
        $dataSources = $this->classifier->classify($question);
        $context = $this->contextBuilder->build($app, $dataSources, $user->id);
        $formattedContext = $this->contextBuilder->formatForPrompt($context);

        // 2. Build prompts
        $systemPrompt = $this->buildSystemPrompt($app, $formattedContext);

        // 3. Generate response
        $response = $this->openRouter->chat($systemPrompt, $question, false);

        $content = $response['content'] ?? 'I apologize, but I was unable to generate a response. Please try again.';
        $tokensUsed = $response['tokens_used'] ?? 0;

        // 4. Track usage
        $this->trackUsage($user, $tokensUsed);

        return [
            'content' => $content,
            'data_sources_used' => $dataSources,
            'tokens_used' => $tokensUsed,
        ];
    }

    /**
     * Check if user has remaining questions in their quota.
     */
    public function checkQuota(User $user): array
    {
        $usage = ChatUsage::getOrCreateForUser($user->id);
        $limit = $this->getQuestionLimit($user);

        return [
            'used' => $usage->questions_count,
            'limit' => $limit,
            'remaining' => max(0, $limit - $usage->questions_count),
            'has_quota' => $limit === -1 || $usage->questions_count < $limit,
        ];
    }

    /**
     * Get the question limit for a user based on their subscription tier.
     */
    private function getQuestionLimit(User $user): int
    {
        // TODO: Implement actual subscription tiers
        // For now, return a default limit
        // -1 means unlimited
        return 50; // Default to Pro tier limit
    }

    private function buildSystemPrompt(?App $app, string $context): string
    {
        $prompt = self::SYSTEM_PROMPT;

        if ($app) {
            $prompt .= "\n\nCurrent app context:\n{$context}";
        }

        return $prompt;
    }

    private function buildUserPrompt(string $question, array $history): string
    {
        if (empty($history)) {
            return $question;
        }

        $historyText = "";
        foreach ($history as $msg) {
            $role = $msg['role'] === 'user' ? 'User' : 'Assistant';
            $historyText .= "{$role}: {$msg['content']}\n\n";
        }

        return "Previous conversation:\n{$historyText}\nUser: {$question}";
    }

    private function getConversationHistory(ChatConversation $conversation, int $limit = 6): array
    {
        return $conversation->messages()
            ->orderByDesc('created_at')
            ->limit($limit)
            ->get()
            ->reverse()
            ->map(fn($m) => ['role' => $m->role, 'content' => $m->content])
            ->values()
            ->toArray();
    }

    private function trackUsage(User $user, int $tokensUsed): void
    {
        $usage = ChatUsage::getOrCreateForUser($user->id);
        $usage->incrementUsage($tokensUsed);
    }
}
