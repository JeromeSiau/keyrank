import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../domain/chat_models.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(dioProvider));
});

class ChatRepository {
  final Dio dio;

  ChatRepository(this.dio);

  /// List user's conversations
  Future<PaginatedConversations> getConversations({int page = 1, int perPage = 20}) async {
    try {
      final response = await dio.get(
        '/chat/conversations',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      return PaginatedConversations.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Create a new conversation
  Future<ChatConversation> createConversation({int? appId}) async {
    try {
      final response = await dio.post(
        '/chat/conversations',
        data: appId != null ? {'app_id': appId} : null,
      );
      return ChatConversation.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get a conversation with its messages
  Future<ChatConversation> getConversation(int conversationId) async {
    try {
      final response = await dio.get('/chat/conversations/$conversationId');
      return ChatConversation.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Send a message to a conversation and get the assistant's response
  Future<ChatMessage> sendMessage(int conversationId, String message) async {
    try {
      final response = await dio.post(
        '/chat/conversations/$conversationId/messages',
        data: {'message': message},
      );
      return ChatMessage.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Delete a conversation
  Future<void> deleteConversation(int conversationId) async {
    try {
      await dio.delete('/chat/conversations/$conversationId');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get or create an app-specific conversation
  Future<ChatConversation> getAppConversation(int appId) async {
    try {
      final response = await dio.get('/apps/$appId/chat');
      return ChatConversation.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Quick ask - one-off question without conversation history
  Future<QuickAskResponse> quickAsk(int appId, String question) async {
    try {
      final response = await dio.post(
        '/apps/$appId/chat/ask',
        data: {'question': question},
      );
      return QuickAskResponse.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get suggested questions for an app
  Future<List<SuggestedQuestions>> getSuggestedQuestions(int appId) async {
    try {
      final response = await dio.get('/apps/$appId/chat/suggestions');
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => SuggestedQuestions.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get user's chat quota
  Future<ChatQuota> getQuota() async {
    try {
      final response = await dio.get('/chat/quota');
      return ChatQuota.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
