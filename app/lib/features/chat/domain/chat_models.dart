import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_models.freezed.dart';
part 'chat_models.g.dart';

@freezed
class ChatConversation with _$ChatConversation {
  const ChatConversation._();

  const factory ChatConversation({
    required int id,
    String? title,
    ChatApp? app,
    @Default([]) List<ChatMessage> messages,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ChatConversation;

  factory ChatConversation.fromJson(Map<String, dynamic> json) =>
      _$ChatConversationFromJson(json);

  String get displayTitle => title ?? 'New Conversation';
}

@freezed
class ChatMessage with _$ChatMessage {
  const ChatMessage._();

  const factory ChatMessage({
    required int id,
    required String role,
    required String content,
    @JsonKey(name: 'data_sources_used') List<String>? dataSourcesUsed,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
}

@freezed
class ChatApp with _$ChatApp {
  const factory ChatApp({
    required int id,
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    required String platform,
  }) = _ChatApp;

  factory ChatApp.fromJson(Map<String, dynamic> json) =>
      _$ChatAppFromJson(json);
}

@freezed
class ChatQuota with _$ChatQuota {
  const ChatQuota._();

  const factory ChatQuota({
    required int used,
    required int limit,
    required int remaining,
    @JsonKey(name: 'has_quota') required bool hasQuota,
  }) = _ChatQuota;

  factory ChatQuota.fromJson(Map<String, dynamic> json) =>
      _$ChatQuotaFromJson(json);

  double get usagePercentage => limit > 0 ? (used / limit) * 100 : 0;
  bool get isUnlimited => limit == -1;
}

@freezed
class QuickAskResponse with _$QuickAskResponse {
  const factory QuickAskResponse({
    required String content,
    @JsonKey(name: 'data_sources_used') List<String>? dataSourcesUsed,
    @JsonKey(name: 'tokens_used') int? tokensUsed,
  }) = _QuickAskResponse;

  factory QuickAskResponse.fromJson(Map<String, dynamic> json) =>
      _$QuickAskResponseFromJson(json);
}

@freezed
class SuggestedQuestions with _$SuggestedQuestions {
  const factory SuggestedQuestions({
    required String category,
    required List<String> questions,
  }) = _SuggestedQuestions;

  factory SuggestedQuestions.fromJson(Map<String, dynamic> json) =>
      _$SuggestedQuestionsFromJson(json);
}

class PaginatedConversations {
  final List<ChatConversation> conversations;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginatedConversations({
    required this.conversations,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginatedConversations.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>?) ?? [];
    final meta = (json['meta'] as Map<String, dynamic>?) ?? {};

    int parseIntOrDefault(dynamic value, int defaultValue) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    return PaginatedConversations(
      conversations: data
          .map((e) => ChatConversation.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: parseIntOrDefault(meta['current_page'], 1),
      lastPage: parseIntOrDefault(meta['last_page'], 1),
      perPage: parseIntOrDefault(meta['per_page'], 20),
      total: parseIntOrDefault(meta['total'], 0),
    );
  }
}
