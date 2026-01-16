import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_preferences_model.freezed.dart';
part 'alert_preferences_model.g.dart';

/// Delivery preferences for a single alert type
@freezed
class AlertDelivery with _$AlertDelivery {
  const factory AlertDelivery({
    @Default(true) bool push,
    @Default(false) bool email,
    @Default(false) bool digest,
  }) = _AlertDelivery;

  factory AlertDelivery.fromJson(Map<String, dynamic> json) =>
      _$AlertDeliveryFromJson(json);
}

/// User's alert delivery preferences
@freezed
class AlertPreferences with _$AlertPreferences {
  const AlertPreferences._();

  const factory AlertPreferences({
    required String email,
    @JsonKey(name: 'email_notifications_enabled')
    @Default(true)
    bool emailNotificationsEnabled,
    @JsonKey(name: 'delivery_by_type')
    required Map<String, AlertDelivery> deliveryByType,
    @JsonKey(name: 'digest_time') @Default('09:00') String digestTime,
    @JsonKey(name: 'weekly_digest_day')
    @Default('monday')
    String weeklyDigestDay,
  }) = _AlertPreferences;

  factory AlertPreferences.fromJson(Map<String, dynamic> json) =>
      _$AlertPreferencesFromJson(json);

  /// Get delivery settings for a specific alert type
  AlertDelivery getDeliveryFor(String type) {
    return deliveryByType[type] ?? const AlertDelivery();
  }
}

/// Alert type metadata for display
@freezed
class AlertTypeInfo with _$AlertTypeInfo {
  const factory AlertTypeInfo({
    required String type,
    required String label,
    required String description,
    required String icon,
  }) = _AlertTypeInfo;

  factory AlertTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$AlertTypeInfoFromJson(json);
}

/// Days of the week for digest scheduling
enum DigestDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String get label {
    switch (this) {
      case DigestDay.monday:
        return 'Monday';
      case DigestDay.tuesday:
        return 'Tuesday';
      case DigestDay.wednesday:
        return 'Wednesday';
      case DigestDay.thursday:
        return 'Thursday';
      case DigestDay.friday:
        return 'Friday';
      case DigestDay.saturday:
        return 'Saturday';
      case DigestDay.sunday:
        return 'Sunday';
    }
  }
}
