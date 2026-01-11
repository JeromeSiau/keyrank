import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chat_repository.dart';
import '../domain/chat_models.dart';

/// Provider for fetching the list of conversations
final conversationsProvider =
    FutureProvider<PaginatedConversations>((ref) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getConversations();
});

/// Provider for fetching a specific conversation with messages
final conversationProvider =
    FutureProvider.family<ChatConversation, int>((ref, conversationId) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getConversation(conversationId);
});

/// Provider for fetching or creating an app-specific conversation
final appConversationProvider =
    FutureProvider.family<ChatConversation, int>((ref, appId) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getAppConversation(appId);
});

/// Provider for fetching chat quota
final chatQuotaProvider = FutureProvider<ChatQuota>((ref) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getQuota();
});

/// Provider for fetching suggested questions for an app
final suggestedQuestionsProvider =
    FutureProvider.family<List<SuggestedQuestions>, int>((ref, appId) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getSuggestedQuestions(appId);
});

/// Notifier for managing chat state during a conversation
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;
  final int conversationId;

  ChatNotifier(this._repository, this.conversationId)
      : super(ChatState.initial());

  Future<void> loadConversation() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final conversation = await _repository.getConversation(conversationId);
      state = state.copyWith(
        isLoading: false,
        conversation: conversation,
        messages: conversation.messages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> sendMessage(String message) async {
    if (state.isSending) return;

    // Add optimistic user message
    final userMessage = ChatMessage(
      id: -DateTime.now().millisecondsSinceEpoch,
      role: 'user',
      content: message,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      isSending: true,
      messages: [...state.messages, userMessage],
      error: null,
    );

    try {
      final assistantMessage = await _repository.sendMessage(conversationId, message);

      // Replace optimistic message and add assistant response
      final updatedMessages = state.messages
          .where((m) => m.id != userMessage.id)
          .toList();

      // Add the real user message (with proper ID from server implicit in the conversation)
      // and the assistant message
      state = state.copyWith(
        isSending: false,
        messages: [
          ...updatedMessages,
          ChatMessage(
            id: assistantMessage.id - 1, // User message comes before
            role: 'user',
            content: message,
            createdAt: assistantMessage.createdAt.subtract(const Duration(seconds: 1)),
          ),
          assistantMessage,
        ],
      );
    } catch (e) {
      // Remove optimistic message on error
      state = state.copyWith(
        isSending: false,
        messages: state.messages.where((m) => m.id != userMessage.id).toList(),
        error: e.toString(),
      );
    }
  }
}

class ChatState {
  final bool isLoading;
  final bool isSending;
  final String? error;
  final ChatConversation? conversation;
  final List<ChatMessage> messages;

  ChatState({
    required this.isLoading,
    required this.isSending,
    this.error,
    this.conversation,
    required this.messages,
  });

  factory ChatState.initial() => ChatState(
        isLoading: false,
        isSending: false,
        messages: [],
      );

  ChatState copyWith({
    bool? isLoading,
    bool? isSending,
    String? error,
    ChatConversation? conversation,
    List<ChatMessage>? messages,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
    );
  }
}

/// Provider family for chat notifier per conversation
final chatNotifierProvider =
    StateNotifierProvider.family<ChatNotifier, ChatState, int>(
        (ref, conversationId) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatNotifier(repository, conversationId);
});
