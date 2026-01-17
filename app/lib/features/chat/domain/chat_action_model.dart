import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_action_model.freezed.dart';
part 'chat_action_model.g.dart';

@freezed
class ChatAction with _$ChatAction {
  const ChatAction._();

  const factory ChatAction({
    required int id,
    required String type,
    required Map<String, dynamic> parameters,
    required String status,
    required String explanation,
    @Default(true) bool reversible,
    Map<String, dynamic>? result,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ChatAction;

  factory ChatAction.fromJson(Map<String, dynamic> json) =>
      _$ChatActionFromJson(json);

  // Status checks
  bool get isProposed => status == 'proposed';
  bool get isExecuted => status == 'executed';
  bool get isCancelled => status == 'cancelled';
  bool get isFailed => status == 'failed';
  bool get canExecute => status == 'proposed';

  // Display helpers
  String get displayName => switch (type) {
        'add_keywords' => 'Add Keywords',
        'remove_keywords' => 'Remove Keywords',
        'create_alert' => 'Create Alert',
        'add_competitor' => 'Add Competitor',
        'export_data' => 'Export Data',
        _ => type.replaceAll('_', ' ').toTitleCase(),
      };

  String get icon => switch (type) {
        'add_keywords' => '🎯',
        'remove_keywords' => '🗑️',
        'create_alert' => '🔔',
        'add_competitor' => '👀',
        'export_data' => '📥',
        _ => '⚡',
      };

  // Parameter helpers for specific action types
  List<String> get keywords =>
      (parameters['keywords'] as List<dynamic>?)?.cast<String>() ?? [];

  String get country => parameters['country'] as String? ?? 'US';

  String? get keyword => parameters['keyword'] as String?;

  String? get condition => parameters['condition'] as String?;

  int? get threshold => parameters['threshold'] as int?;

  List<String> get channels =>
      (parameters['channels'] as List<dynamic>?)?.cast<String>() ?? ['push'];

  String? get appName => parameters['app_name'] as String?;

  String? get exportType => parameters['type'] as String?;

  String? get dateRange => parameters['date_range'] as String?;

  // Result helpers
  String? get resultMessage => result?['message'] as String?;

  String? get errorMessage => result?['error'] as String?;

  String? get downloadUrl => result?['download_url'] as String?;
}

extension StringExtension on String {
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }
}
