import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/locale_provider.dart';
import '../data/chat_repository.dart';
import '../domain/chat_action_model.dart';
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
  final locale = ref.watch(localeProvider)?.languageCode;
  return repository.getSuggestedQuestions(appId, locale: locale);
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
      // Use non-streaming endpoint
      final assistantMessage = await _repository.sendMessage(conversationId, message);

      // Replace optimistic user message with real messages
      final updatedMessages = state.messages
          .where((m) => m.id != userMessage.id)
          .toList();

      state = state.copyWith(
        isSending: false,
        messages: [
          ...updatedMessages,
          ChatMessage(
            id: assistantMessage.id - 1,
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
        messages: state.messages
            .where((m) => m.id != userMessage.id)
            .toList(),
        error: e.toString(),
      );
    }
  }

  /// Execute an action
  Future<void> executeAction(ChatAction action) async {
    // Mark as executing
    state = state.copyWith(
      executingActionIds: {...state.executingActionIds, action.id},
    );

    try {
      final result = await _repository.executeAction(action.id);

      // Update the action in the message
      state = state.copyWith(
        executingActionIds: {...state.executingActionIds}..remove(action.id),
        messages: _updateActionInMessages(result.action),
      );
    } catch (e) {
      state = state.copyWith(
        executingActionIds: {...state.executingActionIds}..remove(action.id),
        error: e.toString(),
      );
    }
  }

  /// Cancel an action
  Future<void> cancelAction(ChatAction action) async {
    try {
      final cancelledAction = await _repository.cancelAction(action.id);
      state = state.copyWith(
        messages: _updateActionInMessages(cancelledAction),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Helper to update an action within messages
  List<ChatMessage> _updateActionInMessages(ChatAction updatedAction) {
    return state.messages.map((message) {
      if (message.actions.any((a) => a.id == updatedAction.id)) {
        return message.copyWith(
          actions: message.actions
              .map((a) => a.id == updatedAction.id ? updatedAction : a)
              .toList(),
        );
      }
      return message;
    }).toList();
  }
}

class ChatState {
  final bool isLoading;
  final bool isSending;
  final String? error;
  final ChatConversation? conversation;
  final List<ChatMessage> messages;
  final Set<int> executingActionIds;

  ChatState({
    required this.isLoading,
    required this.isSending,
    this.error,
    this.conversation,
    required this.messages,
    this.executingActionIds = const {},
  });

  factory ChatState.initial() => ChatState(
        isLoading: false,
        isSending: false,
        messages: [],
        executingActionIds: {},
      );

  ChatState copyWith({
    bool? isLoading,
    bool? isSending,
    String? error,
    ChatConversation? conversation,
    List<ChatMessage>? messages,
    Set<int>? executingActionIds,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      executingActionIds: executingActionIds ?? this.executingActionIds,
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
