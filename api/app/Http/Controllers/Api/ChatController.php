<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\ChatConversation;
use App\Services\ChatService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ChatController extends Controller
{
    public function __construct(
        private ChatService $chatService,
    ) {}

    /**
     * List user's conversations
     */
    public function index(Request $request): JsonResponse
    {
        $user = Auth::user();

        $conversations = ChatConversation::where('user_id', $user->id)
            ->with('app:id,name,icon_url,platform')
            ->orderByDesc('updated_at')
            ->paginate($request->input('per_page', 20));

        return response()->json([
            'data' => $conversations->map(fn($c) => [
                'id' => $c->id,
                'title' => $c->title,
                'app' => $c->app ? [
                    'id' => $c->app->id,
                    'name' => $c->app->name,
                    'icon_url' => $c->app->icon_url,
                    'platform' => $c->app->platform,
                ] : null,
                'created_at' => $c->created_at->toIso8601String(),
                'updated_at' => $c->updated_at->toIso8601String(),
            ]),
            'meta' => [
                'current_page' => $conversations->currentPage(),
                'last_page' => $conversations->lastPage(),
                'per_page' => $conversations->perPage(),
                'total' => $conversations->total(),
            ],
        ]);
    }

    /**
     * Create a new conversation
     */
    public function store(Request $request): JsonResponse
    {
        $user = Auth::user();

        $validated = $request->validate([
            'app_id' => 'nullable|exists:apps,id',
        ]);

        // If app_id is provided, verify user has access to this app
        if (isset($validated['app_id'])) {
            if (!$user->apps()->where('apps.id', $validated['app_id'])->exists()) {
                return response()->json(['error' => 'You do not have access to this app.'], 403);
            }
        }

        $conversation = ChatConversation::create([
            'user_id' => $user->id,
            'app_id' => $validated['app_id'] ?? null,
        ]);

        $conversation->load('app:id,name,icon_url,platform');

        return response()->json([
            'data' => [
                'id' => $conversation->id,
                'title' => $conversation->title,
                'app' => $conversation->app ? [
                    'id' => $conversation->app->id,
                    'name' => $conversation->app->name,
                    'icon_url' => $conversation->app->icon_url,
                    'platform' => $conversation->app->platform,
                ] : null,
                'created_at' => $conversation->created_at->toIso8601String(),
                'updated_at' => $conversation->updated_at->toIso8601String(),
            ],
        ], 201);
    }

    /**
     * Get a conversation with its messages
     */
    public function show(ChatConversation $conversation): JsonResponse
    {
        $user = Auth::user();

        if ($conversation->user_id !== $user->id) {
            return response()->json(['error' => 'Conversation not found.'], 404);
        }

        $conversation->load(['app:id,name,icon_url,platform', 'messages']);

        return response()->json([
            'data' => [
                'id' => $conversation->id,
                'title' => $conversation->title,
                'app' => $conversation->app ? [
                    'id' => $conversation->app->id,
                    'name' => $conversation->app->name,
                    'icon_url' => $conversation->app->icon_url,
                    'platform' => $conversation->app->platform,
                ] : null,
                'messages' => $conversation->messages->map(fn($m) => [
                    'id' => $m->id,
                    'role' => $m->role,
                    'content' => $m->content,
                    'data_sources_used' => $m->data_sources_used,
                    'created_at' => $m->created_at->toIso8601String(),
                ]),
                'created_at' => $conversation->created_at->toIso8601String(),
                'updated_at' => $conversation->updated_at->toIso8601String(),
            ],
        ]);
    }

    /**
     * Send a message to a conversation
     */
    public function sendMessage(Request $request, ChatConversation $conversation): JsonResponse
    {
        $user = Auth::user();

        if ($conversation->user_id !== $user->id) {
            return response()->json(['error' => 'Conversation not found.'], 404);
        }

        // Check quota
        $quota = $this->chatService->checkQuota($user);
        if (!$quota['has_quota']) {
            return response()->json([
                'error' => 'You have reached your monthly chat limit.',
                'quota' => $quota,
            ], 429);
        }

        $validated = $request->validate([
            'message' => 'required|string|max:2000',
        ]);

        // Process the message
        $assistantMessage = $this->chatService->ask(
            $conversation,
            $validated['message'],
            $user,
        );

        // Touch the conversation to update the timestamp
        $conversation->touch();

        return response()->json([
            'data' => [
                'id' => $assistantMessage->id,
                'role' => $assistantMessage->role,
                'content' => $assistantMessage->content,
                'data_sources_used' => $assistantMessage->data_sources_used,
                'created_at' => $assistantMessage->created_at->toIso8601String(),
            ],
        ]);
    }

    /**
     * Delete a conversation
     */
    public function destroy(ChatConversation $conversation): JsonResponse
    {
        $user = Auth::user();

        if ($conversation->user_id !== $user->id) {
            return response()->json(['error' => 'Conversation not found.'], 404);
        }

        $conversation->delete();

        return response()->json(null, 204);
    }

    /**
     * Get or create an app-specific conversation
     */
    public function forApp(App $app): JsonResponse
    {
        $user = Auth::user();

        // Verify user has access to this app
        if (!$user->apps()->where('apps.id', $app->id)->exists()) {
            return response()->json(['error' => 'You do not have access to this app.'], 403);
        }

        // Find existing conversation or create new one
        $conversation = ChatConversation::firstOrCreate(
            [
                'user_id' => $user->id,
                'app_id' => $app->id,
            ],
            ['title' => null]
        );

        $conversation->load('messages');

        return response()->json([
            'data' => [
                'id' => $conversation->id,
                'title' => $conversation->title,
                'app' => [
                    'id' => $app->id,
                    'name' => $app->name,
                    'icon_url' => $app->icon_url,
                    'platform' => $app->platform,
                ],
                'messages' => $conversation->messages->map(fn($m) => [
                    'id' => $m->id,
                    'role' => $m->role,
                    'content' => $m->content,
                    'data_sources_used' => $m->data_sources_used,
                    'created_at' => $m->created_at->toIso8601String(),
                ]),
                'created_at' => $conversation->created_at->toIso8601String(),
                'updated_at' => $conversation->updated_at->toIso8601String(),
            ],
        ]);
    }

    /**
     * Quick ask - one-off question without conversation history
     */
    public function quickAsk(Request $request, App $app): JsonResponse
    {
        $user = Auth::user();

        // Verify user has access to this app
        if (!$user->apps()->where('apps.id', $app->id)->exists()) {
            return response()->json(['error' => 'You do not have access to this app.'], 403);
        }

        // Check quota
        $quota = $this->chatService->checkQuota($user);
        if (!$quota['has_quota']) {
            return response()->json([
                'error' => 'You have reached your monthly chat limit.',
                'quota' => $quota,
            ], 429);
        }

        $validated = $request->validate([
            'question' => 'required|string|max:2000',
        ]);

        $result = $this->chatService->quickAsk($app, $validated['question'], $user);

        return response()->json([
            'data' => $result,
        ]);
    }

    /**
     * Get user's chat usage/quota
     */
    public function quota(): JsonResponse
    {
        $user = Auth::user();
        $quota = $this->chatService->checkQuota($user);

        return response()->json([
            'data' => $quota,
        ]);
    }

    /**
     * Get suggested questions for an app
     */
    public function suggestedQuestions(App $app): JsonResponse
    {
        $user = Auth::user();

        // Verify user has access to this app
        if (!$user->apps()->where('apps.id', $app->id)->exists()) {
            return response()->json(['error' => 'You do not have access to this app.'], 403);
        }

        // Return context-aware suggested questions
        $suggestions = [
            [
                'category' => 'reviews',
                'questions' => [
                    'What are the most common complaints in recent reviews?',
                    'What features do users love the most?',
                    'How has user sentiment changed over time?',
                ],
            ],
            [
                'category' => 'rankings',
                'questions' => [
                    'Which keywords should I focus on to improve visibility?',
                    'Why did my ranking drop recently?',
                    'What are my best performing keywords?',
                ],
            ],
            [
                'category' => 'analytics',
                'questions' => [
                    'Which country generates the most downloads?',
                    'How is my revenue trending this month?',
                    'What is my conversion rate?',
                ],
            ],
            [
                'category' => 'competitors',
                'questions' => [
                    'Who are my main competitors for top keywords?',
                    'How do I compare to competitors in reviews?',
                ],
            ],
        ];

        return response()->json([
            'data' => $suggestions,
        ]);
    }
}
