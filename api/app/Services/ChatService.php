<?php

namespace App\Services;

use App\Models\App;
use App\Models\ChatAction;
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

## TOOL USAGE (CRITICAL)

You have access to the following tools:
- add_keywords: Add keywords to tracking (parameters: keywords array, optional country)
- remove_keywords: Remove keywords from tracking (parameters: keywords array)
- create_alert: Create ranking alert (parameters: keyword, condition, threshold, optional channels)
- add_competitor: Add competitor app (parameters: app_name, optional store)
- export_data: Export data (parameters: type, optional date_range)

When the user requests ANY of these actions, you MUST call the appropriate tool function:
- "ajoute le mot-clé X" → call add_keywords with keywords: ["X"]
- "track keyword Y" → call add_keywords with keywords: ["Y"]
- "alert me when Z" → call create_alert
- "remove keyword W" → call remove_keywords
- "add competitor" → call add_competitor
- "export my data" → call export_data

DO NOT just describe what you would do. ACTUALLY CALL THE TOOL.
The user will see a confirmation card in the UI - they must click "Confirm" to execute.
Keep your text response brief: "Here's the action - click Confirm to proceed."
PROMPT;

    public function __construct(
        private QueryClassifierService $classifier,
        private ContextBuilderService $contextBuilder,
        private OpenRouterService $openRouter,
    ) {}

    /**
     * Process a user question and generate a response.
     * Returns the assistant message with any proposed actions.
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

        // 5. Get conversation history for context (format for multi-turn)
        $conversationHistory = $this->getConversationHistory($conversation);

        // 6. Save user message
        $userMessage = $conversation->messages()->create([
            'role' => 'user',
            'content' => $question,
        ]);

        // 7. Build messages array for tool calling API
        $messages = $conversationHistory;
        $messages[] = ['role' => 'user', 'content' => $question];

        // 8. Generate response via LLM with tool calling (only if app context exists)
        $tools = $app ? OpenRouterService::getActionTools() : [];
        $response = $this->openRouter->chatWithTools($systemPrompt, $messages, $tools);

        if (!$response) {
            $assistantContent = 'I apologize, but I was unable to generate a response. Please try again.';
            $tokensUsed = 0;
            $toolCalls = [];
        } else {
            $assistantContent = $response['content'] ?? '';
            $tokensUsed = $response['tokens_used'] ?? 0;
            $toolCalls = $response['tool_calls'] ?? [];

            // Debug logging for tool calls
            Log::info('Chat LLM response', [
                'has_content' => !empty($assistantContent),
                'tool_calls_count' => count($toolCalls),
                'tool_calls' => $toolCalls,
            ]);
        }

        // 9. Save assistant message
        $assistantMessage = $conversation->messages()->create([
            'role' => 'assistant',
            'content' => $assistantContent,
            'data_sources_used' => $dataSources,
            'tokens_used' => $tokensUsed,
        ]);

        // 10. Process tool calls and create action records
        $actions = [];
        foreach ($toolCalls as $toolCall) {
            $functionName = $toolCall['function']['name'] ?? null;
            $arguments = json_decode($toolCall['function']['arguments'] ?? '{}', true);

            Log::info('Processing tool call', [
                'function_name' => $functionName,
                'arguments' => $arguments,
                'is_valid_type' => in_array($functionName, ChatAction::$validTypes),
            ]);

            if ($functionName && in_array($functionName, ChatAction::$validTypes)) {
                $action = ChatAction::create([
                    'message_id' => $assistantMessage->id,
                    'type' => $functionName,
                    'parameters' => $arguments,
                    'status' => ChatAction::STATUS_PROPOSED,
                    'explanation' => $this->generateActionExplanation($functionName, $arguments),
                    'reversible' => $this->isActionReversible($functionName),
                ]);
                $actions[] = $action;

                Log::info('Created chat action', [
                    'action_id' => $action->id,
                    'type' => $functionName,
                    'status' => $action->status,
                ]);
            }
        }

        // 11. Update conversation title if this is the first message
        if ($conversation->messages()->count() <= 2) {
            $conversation->generateTitle();
        }

        // 12. Track usage
        $this->trackUsage($user, $tokensUsed);

        return $assistantMessage->load('actions');
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

    /**
     * Generate a human-readable explanation for an action.
     */
    private function generateActionExplanation(string $type, array $parameters): string
    {
        return match ($type) {
            'add_keywords' => $this->explainAddKeywords($parameters),
            'remove_keywords' => $this->explainRemoveKeywords($parameters),
            'create_alert' => $this->explainCreateAlert($parameters),
            'add_competitor' => $this->explainAddCompetitor($parameters),
            'export_data' => $this->explainExportData($parameters),
            default => "Execute action: {$type}",
        };
    }

    private function explainAddKeywords(array $params): string
    {
        $keywords = $params['keywords'] ?? [];
        $country = $params['country'] ?? 'US';
        $count = count($keywords);
        $keywordList = implode(', ', array_slice($keywords, 0, 3));
        if ($count > 3) {
            $keywordList .= " and " . ($count - 3) . " more";
        }
        return "Add {$count} keyword(s) to tracking: {$keywordList} (Country: {$country})";
    }

    private function explainRemoveKeywords(array $params): string
    {
        $keywords = $params['keywords'] ?? [];
        $count = count($keywords);
        $keywordList = implode(', ', array_slice($keywords, 0, 3));
        if ($count > 3) {
            $keywordList .= " and " . ($count - 3) . " more";
        }
        return "Remove {$count} keyword(s) from tracking: {$keywordList}";
    }

    private function explainCreateAlert(array $params): string
    {
        $keyword = $params['keyword'] ?? 'unknown';
        $condition = $params['condition'] ?? 'changes';
        $threshold = $params['threshold'] ?? 0;
        $channels = implode(' & ', $params['channels'] ?? ['push']);

        $conditionText = match ($condition) {
            'reaches_top' => "reaches top {$threshold}",
            'drops_below' => "drops below position {$threshold}",
            'improves_by' => "improves by {$threshold} positions",
            'drops_by' => "drops by {$threshold} positions",
            default => $condition,
        };

        return "Create alert: Notify via {$channels} when \"{$keyword}\" {$conditionText}";
    }

    private function explainAddCompetitor(array $params): string
    {
        $appName = $params['app_name'] ?? 'unknown';
        $store = $params['store'] ?? 'same store';
        return "Add competitor: Search for \"{$appName}\" on {$store}";
    }

    private function explainExportData(array $params): string
    {
        $type = $params['type'] ?? 'data';
        $range = $params['date_range'] ?? '30d';
        return "Export {$type} data for the last {$range}";
    }

    /**
     * Check if an action type is reversible.
     */
    private function isActionReversible(string $type): bool
    {
        return match ($type) {
            'add_keywords' => true,       // Can be removed
            'remove_keywords' => true,    // Can be re-added
            'create_alert' => true,       // Can be deleted
            'add_competitor' => true,     // Can be removed
            'export_data' => false,       // Download action, not reversible
            default => false,
        };
    }
}
