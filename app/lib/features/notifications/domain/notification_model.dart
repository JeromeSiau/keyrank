import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'alert_rule_id') int? alertRuleId,
    required String type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'sent_at') DateTime? sentAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

@freezed
class NotificationsPage with _$NotificationsPage {
  const factory NotificationsPage({
    required List<NotificationModel> data,
    @JsonKey(name: 'current_page') required int currentPage,
    @JsonKey(name: 'last_page') required int lastPage,
    required int total,
  }) = _NotificationsPage;

  factory NotificationsPage.fromJson(Map<String, dynamic> json) =>
      _$NotificationsPageFromJson(json);
}
