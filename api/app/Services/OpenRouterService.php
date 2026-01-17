<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class OpenRouterService
{
    private ?string $apiKey;
    private string $baseUrl;
    private string $model;

    public function __construct()
    {
        $this->apiKey = config('services.openrouter.api_key');
        $this->baseUrl = config('services.openrouter.base_url', 'https://openrouter.ai/api/v1');
        $this->model = config('services.openrouter.model', 'openai/gpt-5-nano');
    }

    /**
     * Send a chat completion request to OpenRouter
     */
    public function chat(string $systemPrompt, string $userPrompt, bool $jsonMode = true): ?array
    {
        if (!$this->apiKey) {
            Log::error('OpenRouter API key not configured');
            return null;
        }

        try {
            $payload = [
                'model' => $this->model,
                'messages' => [
                    ['role' => 'system', 'content' => $systemPrompt],
                    ['role' => 'user', 'content' => $userPrompt],
                ],
            ];

            if ($jsonMode) {
                $payload['response_format'] = ['type' => 'json_object'];
            }

            $response = Http::timeout(120)
                ->withHeaders([
                    'Authorization' => "Bearer {$this->apiKey}",
                    'Content-Type' => 'application/json',
                    'HTTP-Referer' => config('app.url'),
                    'X-Title' => 'Keyrank ASO',
                ])
                ->post("{$this->baseUrl}/chat/completions", $payload);

            if ($response->successful()) {
                $content = $response->json('choices.0.message.content');
                return $jsonMode ? json_decode($content, true) : ['content' => $content];
            }

            Log::error('OpenRouter API error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('OpenRouter API exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Send a chat completion request with tool calling support
     *
     * @param string $systemPrompt System prompt
     * @param array $messages Array of messages [['role' => 'user|assistant', 'content' => '...']]
     * @param array $tools Tool definitions for function calling
     * @return array|null Returns ['content' => string|null, 'tool_calls' => array, 'tokens_used' => int]
     */
    public function chatWithTools(string $systemPrompt, array $messages, array $tools = []): ?array
    {
        if (!$this->apiKey) {
            Log::error('OpenRouter API key not configured');
            return null;
        }

        try {
            $formattedMessages = array_merge(
                [['role' => 'system', 'content' => $systemPrompt]],
                $messages
            );

            $payload = [
                'model' => $this->model,
                'messages' => $formattedMessages,
            ];

            // Add tools if provided
            if (!empty($tools)) {
                $payload['tools'] = $tools;
                $payload['tool_choice'] = 'auto';
            }

            $response = Http::timeout(120)
                ->withHeaders([
                    'Authorization' => "Bearer {$this->apiKey}",
                    'Content-Type' => 'application/json',
                    'HTTP-Referer' => config('app.url'),
                    'X-Title' => 'Keyrank ASO',
                ])
                ->post("{$this->baseUrl}/chat/completions", $payload);

            if ($response->successful()) {
                $message = $response->json('choices.0.message');

                return [
                    'content' => $message['content'] ?? null,
                    'tool_calls' => $message['tool_calls'] ?? [],
                    'tokens_used' => $response->json('usage.total_tokens') ?? 0,
                ];
            }

            Log::error('OpenRouter API error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('OpenRouter API exception', ['error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Get the action tools definitions for chat
     */
    public static function getActionTools(): array
    {
        return [
            [
                'type' => 'function',
                'function' => [
                    'name' => 'add_keywords',
                    'description' => 'Add one or more keywords to tracking for the current app. Use when the user wants to track new keywords or start monitoring keyword rankings.',
                    'parameters' => [
                        'type' => 'object',
                        'properties' => [
                            'keywords' => [
                                'type' => 'array',
                                'items' => ['type' => 'string'],
                                'description' => 'List of keywords to add to tracking',
                            ],
                            'country' => [
                                'type' => 'string',
                                'description' => 'Two-letter country code (e.g., US, FR, DE). Defaults to US if not specified.',
                            ],
                        ],
                        'required' => ['keywords'],
                    ],
                ],
            ],
            [
                'type' => 'function',
                'function' => [
                    'name' => 'remove_keywords',
                    'description' => 'Remove keywords from tracking. Use when the user wants to stop tracking certain keywords.',
                    'parameters' => [
                        'type' => 'object',
                        'properties' => [
                            'keywords' => [
                                'type' => 'array',
                                'items' => ['type' => 'string'],
                                'description' => 'List of keywords to remove from tracking',
                            ],
                        ],
                        'required' => ['keywords'],
                    ],
                ],
            ],
            [
                'type' => 'function',
                'function' => [
                    'name' => 'create_alert',
                    'description' => 'Create an alert rule to be notified when keyword ranking changes. Use when the user wants to be alerted about ranking changes.',
                    'parameters' => [
                        'type' => 'object',
                        'properties' => [
                            'keyword' => [
                                'type' => 'string',
                                'description' => 'The keyword to monitor',
                            ],
                            'condition' => [
                                'type' => 'string',
                                'enum' => ['reaches_top', 'drops_below', 'improves_by', 'drops_by'],
                                'description' => 'The condition that triggers the alert',
                            ],
                            'threshold' => [
                                'type' => 'integer',
                                'description' => 'The threshold value (e.g., 10 for top 10, or number of positions for change)',
                            ],
                            'channels' => [
                                'type' => 'array',
                                'items' => ['type' => 'string', 'enum' => ['push', 'email']],
                                'description' => 'Notification channels. Defaults to push if not specified.',
                            ],
                        ],
                        'required' => ['keyword', 'condition', 'threshold'],
                    ],
                ],
            ],
            [
                'type' => 'function',
                'function' => [
                    'name' => 'add_competitor',
                    'description' => 'Add a competitor app to track. Use when the user wants to monitor a competing app.',
                    'parameters' => [
                        'type' => 'object',
                        'properties' => [
                            'app_name' => [
                                'type' => 'string',
                                'description' => 'Name of the competitor app to search for',
                            ],
                            'store' => [
                                'type' => 'string',
                                'enum' => ['ios', 'android'],
                                'description' => 'Which app store to search. Defaults to same store as current app.',
                            ],
                        ],
                        'required' => ['app_name'],
                    ],
                ],
            ],
            [
                'type' => 'function',
                'function' => [
                    'name' => 'export_data',
                    'description' => 'Export app data to a CSV file for download. Use when the user wants to export or download their data.',
                    'parameters' => [
                        'type' => 'object',
                        'properties' => [
                            'type' => [
                                'type' => 'string',
                                'enum' => ['keywords', 'analytics', 'reviews'],
                                'description' => 'Type of data to export',
                            ],
                            'date_range' => [
                                'type' => 'string',
                                'enum' => ['7d', '30d', '90d', 'all'],
                                'description' => 'Date range for the export. Defaults to 30d.',
                            ],
                        ],
                        'required' => ['type'],
                    ],
                ],
            ],
        ];
    }
}
