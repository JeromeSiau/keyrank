# Phase 3: Chat with Your Apps (AI) - Design Document

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Allow users to ask natural language questions about their apps and get AI-powered insights from all their Keyrank data.

**Architecture:** RAG (Retrieval Augmented Generation) system that queries relevant data from DB based on user question, then sends context to LLM for response generation.

**Tech Stack:** Laravel (backend), Flutter (frontend), OpenRouter/Claude/GPT for LLM, optional vector DB for semantic search.

**Prerequisite:** Phase 1 and Phase 2 should be completed for full data access.

---

## Features to Implement

### 1. Data Sources for Chat

| Source | Example Questions |
|--------|-------------------|
| **Reviews** | "What are the most common complaints?" |
| **Keywords** | "What keywords should I focus on?" |
| **Rankings** | "Why did my ranking drop last week?" |
| **Analytics** (Phase 2) | "Which country generates the most revenue?" |
| **Competitors** | "How do I compare to [competitor]?" |
| **Alerts** | "What alerts triggered this week?" |

### 2. RAG Architecture

```
User Question
    │
    ▼
┌─────────────────────────┐
│ 1. Query Classifier     │ → Determine data sources needed
│    (rule-based or LLM)  │    (reviews? rankings? analytics?)
└─────────────────────────┘
    │
    ▼
┌─────────────────────────┐
│ 2. Data Retrieval       │ → Fetch relevant data from DB
│    - Recent reviews     │    - Filter by date, app, country
│    - Ranking history    │    - Aggregate if needed
│    - Analytics summary  │
└─────────────────────────┘
    │
    ▼
┌─────────────────────────┐
│ 3. Context Builder      │ → Format data for LLM prompt
│    - Summarize if large │    - Include metadata
│    - Prioritize recent  │
└─────────────────────────┘
    │
    ▼
┌─────────────────────────┐
│ 4. LLM Generation       │ → Generate response
│    (Claude/GPT via      │    - Use system prompt
│     OpenRouter)         │    - Stream response
└─────────────────────────┘
    │
    ▼
Formatted Response to User
```

### 3. Database Tables

**Table: `chat_conversations`**
```sql
- id
- user_id
- app_id (nullable - global chat vs app-specific)
- title (auto-generated from first question)
- created_at
- updated_at
```

**Table: `chat_messages`**
```sql
- id
- conversation_id
- role (user/assistant)
- content (text)
- data_sources_used (json) -- ["reviews", "rankings"]
- tokens_used (integer)
- created_at
```

**Table: `chat_usage`**
```sql
- id
- user_id
- month (YYYY-MM)
- questions_count
- tokens_used
```

### 4. API Endpoints

```
GET  /chat/conversations                    → List user's conversations
POST /chat/conversations                    → Start new conversation
GET  /chat/conversations/{id}               → Get conversation with messages
POST /chat/conversations/{id}/messages      → Send message (returns streamed response)
DELETE /chat/conversations/{id}             → Delete conversation

GET  /apps/{app}/chat                       → Get/create app-specific conversation
POST /apps/{app}/chat/ask                   → Quick ask (no conversation history)
```

### 5. Query Classification

**Rule-based approach (v1):**

```php
class QueryClassifier
{
    public function classify(string $question): array
    {
        $sources = [];
        $lower = strtolower($question);

        // Reviews indicators
        if (preg_match('/review|complaint|feedback|user|say|mention|bug|crash|feature request/i', $lower)) {
            $sources[] = 'reviews';
        }

        // Rankings indicators
        if (preg_match('/rank|position|keyword|aso|visibility|search/i', $lower)) {
            $sources[] = 'rankings';
        }

        // Analytics indicators
        if (preg_match('/download|revenue|money|earn|subscriber|country|growth/i', $lower)) {
            $sources[] = 'analytics';
        }

        // Competitor indicators
        if (preg_match('/competitor|compare|versus|vs|better|worse/i', $lower)) {
            $sources[] = 'competitors';
        }

        // Default to reviews if nothing matched
        if (empty($sources)) {
            $sources[] = 'reviews';
        }

        return $sources;
    }
}
```

### 6. Context Building

**For Reviews:**
```php
// Fetch recent reviews (last 30 days, max 50)
// Group by sentiment
// Include rating distribution
// Highlight common themes
```

**For Rankings:**
```php
// Current positions for tracked keywords
// Recent changes (up/down)
// Keyword popularity scores
// Competitor positions if tracked
```

**For Analytics:**
```php
// Summary for selected period
// Top countries
// Trend direction
// Comparison to previous period
```

### 7. System Prompt Template

```
You are an ASO (App Store Optimization) expert assistant for Keyrank.
You help app developers understand their app's performance and user feedback.

Current context:
- App: {app_name}
- Platform: {platform}
- Current rating: {rating}/5 ({rating_count} ratings)

Available data:
{formatted_context}

Guidelines:
- Be concise and actionable
- Use bullet points for lists
- Reference specific data when making claims
- Suggest next steps when appropriate
- If data is insufficient, say so honestly
- Match the user's language
```

### 8. Flutter Chat UI

**Chat Screen:**
- Conversation list (sidebar on desktop)
- Message bubbles (user right, assistant left)
- Typing indicator during generation
- Suggested questions on empty state
- Data source indicators on assistant messages

**Quick Ask Widget:**
- Floating action button or input field
- Auto-complete with common questions
- Recent questions history

### 9. Pricing & Limits

| Tier | Questions/month | Features |
|------|-----------------|----------|
| Free | 0 | No chat access |
| Starter $9 | 10 | Basic chat |
| Pro $29 | 50 | Full chat + history |
| Agency $99 | Unlimited | + Team sharing |

**Rate limiting:**
- Max 1 question per 5 seconds
- Max 3 concurrent requests per user

---

## Implementation Tasks (High Level)

### Backend (Laravel)

1. Create `chat_conversations` migration
2. Create `chat_messages` migration
3. Create `chat_usage` migration
4. Create `ChatConversation` model
5. Create `ChatMessage` model
6. Create `QueryClassifierService`
7. Create `ContextBuilderService`
8. Create `ChatService` (orchestrates RAG flow)
9. Create `ChatController` with endpoints
10. Add usage tracking and limits
11. Add routes

### Frontend (Flutter)

12. Create chat models (Conversation, Message)
13. Create `ChatRepository`
14. Create `ChatProvider`
15. Create `ChatScreen` with conversation list
16. Create `ChatConversationScreen` with messages
17. Create message bubbles (user/assistant)
18. Add typing indicator
19. Add suggested questions
20. Add quick ask widget
21. Add to app navigation
22. Add localization strings

---

## Estimated Effort

- Backend: ~12 tasks
- Frontend: ~12 tasks
- Total: ~24 tasks

**Dependencies:**
- Phase 1 completed (reviews data)
- Phase 2 completed (analytics data) - optional but recommended
- OpenRouter API configured (already in project)

---

## Future Enhancements (v2)

1. **Vector embeddings** for semantic search in reviews
2. **Streaming responses** for better UX
3. **Multi-turn context** - remember previous questions
4. **Proactive insights** - "I noticed your ranking dropped, here's why..."
5. **Export conversations** to PDF/Markdown
6. **Share insights** with team members
7. **Custom prompts** - let users customize assistant behavior

---

## Notes

- Start with rule-based query classification, upgrade to LLM-based if needed
- Cache common queries to reduce API costs
- Monitor token usage for cost control
- Consider using Claude Haiku for classification (cheaper, faster)
- Use Claude Sonnet for response generation (better quality)
