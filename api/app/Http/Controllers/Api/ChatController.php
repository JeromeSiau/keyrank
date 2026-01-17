<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\App;
use App\Models\ChatAction;
use App\Models\ChatConversation;
use App\Services\ActionExecutorService;
use App\Services\ChatService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ChatController extends Controller
{
    public function __construct(
        private ChatService $chatService,
        private ActionExecutorService $actionExecutor,
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

        $conversation->load(['app:id,name,icon_url,platform', 'messages.actions']);

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
                'messages' => $conversation->messages->map(fn($m) => $this->formatMessage($m)),
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

        // Process the message (returns message with loaded actions)
        $assistantMessage = $this->chatService->ask(
            $conversation,
            $validated['message'],
            $user,
        );

        // Touch the conversation to update the timestamp
        $conversation->touch();

        return response()->json([
            'data' => $this->formatMessage($assistantMessage),
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

        $conversation->load('messages.actions');

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
                'messages' => $conversation->messages->map(fn($m) => $this->formatMessage($m)),
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
    public function suggestedQuestions(Request $request, App $app): JsonResponse
    {
        $user = Auth::user();

        // Verify user has access to this app
        if (!$user->apps()->where('apps.id', $app->id)->exists()) {
            return response()->json(['error' => 'You do not have access to this app.'], 403);
        }

        $locale = $request->header('Accept-Language', 'en');
        $suggestions = $this->getTranslatedSuggestions($locale);

        return response()->json([
            'data' => $suggestions,
        ]);
    }

    /**
     * Get translated suggested questions
     */
    private function getTranslatedSuggestions(string $locale): array
    {
        $translations = [
            'en' => [
                'reviews' => [
                    'What are the most common complaints in recent reviews?',
                    'What features do users love the most?',
                    'How has user sentiment changed over time?',
                ],
                'rankings' => [
                    'Which keywords should I focus on to improve visibility?',
                    'Why did my ranking drop recently?',
                    'What are my best performing keywords?',
                ],
                'analytics' => [
                    'Which country generates the most downloads?',
                    'How is my revenue trending this month?',
                    'What is my conversion rate?',
                ],
                'competitors' => [
                    'Who are my main competitors for top keywords?',
                    'How do I compare to competitors in reviews?',
                ],
            ],
            'fr' => [
                'reviews' => [
                    'Quelles sont les plaintes les plus fréquentes dans les avis récents ?',
                    'Quelles fonctionnalités les utilisateurs apprécient-ils le plus ?',
                    'Comment le sentiment des utilisateurs a-t-il évolué ?',
                ],
                'rankings' => [
                    'Sur quels mots-clés dois-je me concentrer pour améliorer ma visibilité ?',
                    'Pourquoi mon classement a-t-il baissé récemment ?',
                    'Quels sont mes mots-clés les plus performants ?',
                ],
                'analytics' => [
                    'Quel pays génère le plus de téléchargements ?',
                    'Comment évolue mon chiffre d\'affaires ce mois-ci ?',
                    'Quel est mon taux de conversion ?',
                ],
                'competitors' => [
                    'Qui sont mes principaux concurrents sur les mots-clés importants ?',
                    'Comment je me compare aux concurrents dans les avis ?',
                ],
            ],
            'de' => [
                'reviews' => [
                    'Was sind die häufigsten Beschwerden in den letzten Bewertungen?',
                    'Welche Funktionen lieben die Nutzer am meisten?',
                    'Wie hat sich die Nutzerstimmung im Laufe der Zeit verändert?',
                ],
                'rankings' => [
                    'Auf welche Keywords sollte ich mich konzentrieren?',
                    'Warum ist mein Ranking kürzlich gefallen?',
                    'Was sind meine besten Keywords?',
                ],
                'analytics' => [
                    'Welches Land generiert die meisten Downloads?',
                    'Wie entwickelt sich mein Umsatz diesen Monat?',
                    'Wie hoch ist meine Conversion-Rate?',
                ],
                'competitors' => [
                    'Wer sind meine Hauptkonkurrenten bei Top-Keywords?',
                    'Wie schneide ich im Vergleich zur Konkurrenz bei Bewertungen ab?',
                ],
            ],
            'es' => [
                'reviews' => [
                    '¿Cuáles son las quejas más comunes en las reseñas recientes?',
                    '¿Qué características les gustan más a los usuarios?',
                    '¿Cómo ha cambiado el sentimiento de los usuarios?',
                ],
                'rankings' => [
                    '¿En qué palabras clave debo centrarme para mejorar la visibilidad?',
                    '¿Por qué bajó mi ranking recientemente?',
                    '¿Cuáles son mis palabras clave con mejor rendimiento?',
                ],
                'analytics' => [
                    '¿Qué país genera más descargas?',
                    '¿Cómo están evolucionando mis ingresos este mes?',
                    '¿Cuál es mi tasa de conversión?',
                ],
                'competitors' => [
                    '¿Quiénes son mis principales competidores en palabras clave?',
                    '¿Cómo me comparo con la competencia en reseñas?',
                ],
            ],
            'pt' => [
                'reviews' => [
                    'Quais são as reclamações mais comuns nas avaliações recentes?',
                    'Quais recursos os usuários mais gostam?',
                    'Como o sentimento dos usuários mudou ao longo do tempo?',
                ],
                'rankings' => [
                    'Em quais palavras-chave devo focar para melhorar a visibilidade?',
                    'Por que meu ranking caiu recentemente?',
                    'Quais são minhas palavras-chave com melhor desempenho?',
                ],
                'analytics' => [
                    'Qual país gera mais downloads?',
                    'Como está a tendência da minha receita este mês?',
                    'Qual é a minha taxa de conversão?',
                ],
                'competitors' => [
                    'Quem são meus principais concorrentes nas palavras-chave?',
                    'Como me comparo aos concorrentes nas avaliações?',
                ],
            ],
            'it' => [
                'reviews' => [
                    'Quali sono le lamentele più comuni nelle recensioni recenti?',
                    'Quali funzionalità piacciono di più agli utenti?',
                    'Come è cambiato il sentiment degli utenti nel tempo?',
                ],
                'rankings' => [
                    'Su quali parole chiave dovrei concentrarmi per migliorare la visibilità?',
                    'Perché il mio ranking è calato di recente?',
                    'Quali sono le mie parole chiave con le migliori performance?',
                ],
                'analytics' => [
                    'Quale paese genera più download?',
                    'Come sta andando il mio fatturato questo mese?',
                    'Qual è il mio tasso di conversione?',
                ],
                'competitors' => [
                    'Chi sono i miei principali concorrenti per le parole chiave?',
                    'Come mi confronto con i concorrenti nelle recensioni?',
                ],
            ],
            'ja' => [
                'reviews' => [
                    '最近のレビューで最も多い不満は何ですか？',
                    'ユーザーが最も気に入っている機能は何ですか？',
                    'ユーザーの感情は時間とともにどう変化しましたか？',
                ],
                'rankings' => [
                    '可視性を向上させるためにどのキーワードに注力すべきですか？',
                    '最近ランキングが下がったのはなぜですか？',
                    '最もパフォーマンスの良いキーワードは何ですか？',
                ],
                'analytics' => [
                    'どの国が最もダウンロードを生成していますか？',
                    '今月の収益はどのように推移していますか？',
                    'コンバージョン率はどのくらいですか？',
                ],
                'competitors' => [
                    '主要キーワードでの主な競合相手は誰ですか？',
                    'レビューで競合他社と比べてどうですか？',
                ],
            ],
            'ko' => [
                'reviews' => [
                    '최근 리뷰에서 가장 흔한 불만은 무엇인가요?',
                    '사용자들이 가장 좋아하는 기능은 무엇인가요?',
                    '시간이 지남에 따라 사용자 감정은 어떻게 변했나요?',
                ],
                'rankings' => [
                    '가시성을 높이기 위해 어떤 키워드에 집중해야 하나요?',
                    '최근 순위가 떨어진 이유는 무엇인가요?',
                    '가장 성과가 좋은 키워드는 무엇인가요?',
                ],
                'analytics' => [
                    '어느 국가에서 가장 많은 다운로드가 발생하나요?',
                    '이번 달 수익은 어떤 추세인가요?',
                    '전환율은 얼마인가요?',
                ],
                'competitors' => [
                    '주요 키워드에서 주요 경쟁사는 누구인가요?',
                    '리뷰에서 경쟁사와 어떻게 비교되나요?',
                ],
            ],
            'zh' => [
                'reviews' => [
                    '最近评论中最常见的投诉是什么？',
                    '用户最喜欢哪些功能？',
                    '用户情绪随时间如何变化？',
                ],
                'rankings' => [
                    '我应该关注哪些关键词来提高可见度？',
                    '为什么我的排名最近下降了？',
                    '我表现最好的关键词是什么？',
                ],
                'analytics' => [
                    '哪个国家产生的下载量最多？',
                    '本月收入趋势如何？',
                    '我的转化率是多少？',
                ],
                'competitors' => [
                    '在热门关键词上我的主要竞争对手是谁？',
                    '在评论方面我与竞争对手相比如何？',
                ],
            ],
            'tr' => [
                'reviews' => [
                    'Son yorumlardaki en yaygın şikayetler nelerdir?',
                    'Kullanıcılar en çok hangi özellikleri seviyor?',
                    'Kullanıcı duyguları zaman içinde nasıl değişti?',
                ],
                'rankings' => [
                    'Görünürlüğü artırmak için hangi anahtar kelimelere odaklanmalıyım?',
                    'Sıralamam neden son zamanlarda düştü?',
                    'En iyi performans gösteren anahtar kelimelerim hangileri?',
                ],
                'analytics' => [
                    'Hangi ülke en çok indirme üretiyor?',
                    'Bu ay gelirim nasıl bir seyir izliyor?',
                    'Dönüşüm oranım nedir?',
                ],
                'competitors' => [
                    'En önemli anahtar kelimelerde ana rakiplerim kimler?',
                    'Yorumlarda rakiplerle nasıl karşılaştırılıyorum?',
                ],
            ],
        ];

        $questions = $translations[$locale] ?? $translations['en'];

        return [
            ['category' => 'reviews', 'questions' => $questions['reviews']],
            ['category' => 'rankings', 'questions' => $questions['rankings']],
            ['category' => 'analytics', 'questions' => $questions['analytics']],
            ['category' => 'competitors', 'questions' => $questions['competitors']],
        ];
    }

    /**
     * Execute a chat action
     */
    public function executeAction(ChatAction $action): JsonResponse
    {
        $user = Auth::user();

        // Verify ownership through message -> conversation -> user
        $conversation = $action->message->conversation;
        if ($conversation->user_id !== $user->id) {
            return response()->json(['error' => 'Action not found.'], 404);
        }

        // Check if action can be executed
        if (!$action->canExecute()) {
            return response()->json([
                'error' => 'Action cannot be executed.',
                'status' => $action->status,
            ], 400);
        }

        // Get the app context
        $app = $conversation->app;
        if (!$app) {
            return response()->json([
                'error' => 'No app context for this action.',
            ], 400);
        }

        try {
            $result = $this->actionExecutor->execute($action, $app, $user);
            $action->markAsExecuted($result);

            return response()->json([
                'data' => [
                    'success' => true,
                    'action' => $this->formatAction($action->fresh()),
                    'result' => $result,
                ],
            ]);
        } catch (\Exception $e) {
            $action->markAsFailed($e->getMessage());

            return response()->json([
                'data' => [
                    'success' => false,
                    'action' => $this->formatAction($action->fresh()),
                    'error' => $e->getMessage(),
                ],
            ], 500);
        }
    }

    /**
     * Cancel a chat action
     */
    public function cancelAction(ChatAction $action): JsonResponse
    {
        $user = Auth::user();

        // Verify ownership
        $conversation = $action->message->conversation;
        if ($conversation->user_id !== $user->id) {
            return response()->json(['error' => 'Action not found.'], 404);
        }

        // Check if action can be cancelled (only proposed actions)
        if (!$action->isProposed()) {
            return response()->json([
                'error' => 'Action cannot be cancelled.',
                'status' => $action->status,
            ], 400);
        }

        $action->markAsCancelled();

        return response()->json([
            'data' => [
                'success' => true,
                'action' => $this->formatAction($action),
            ],
        ]);
    }

    /**
     * Format a message for JSON response
     */
    private function formatMessage($message): array
    {
        return [
            'id' => $message->id,
            'role' => $message->role,
            'content' => $message->content,
            'data_sources_used' => $message->data_sources_used ?? [],
            'actions' => $message->actions->map(fn($a) => $this->formatAction($a))->toArray(),
            'created_at' => $message->created_at->toIso8601String(),
        ];
    }

    /**
     * Format an action for JSON response
     */
    private function formatAction(ChatAction $action): array
    {
        return [
            'id' => $action->id,
            'type' => $action->type,
            'parameters' => $action->parameters,
            'status' => $action->status,
            'explanation' => $action->explanation,
            'reversible' => $action->reversible,
            'result' => $action->result,
            'created_at' => $action->created_at->toIso8601String(),
        ];
    }
}
