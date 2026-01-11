import 'package:freezed_annotation/freezed_annotation.dart';

part 'integration_model.freezed.dart';
part 'integration_model.g.dart';

@freezed
class Integration with _$Integration {
  const Integration._();

  const factory Integration({
    required int id,
    required String type,
    required String status,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'last_sync_at') DateTime? lastSyncAt,
    @JsonKey(name: 'error_message') String? errorMessage,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Integration;

  factory Integration.fromJson(Map<String, dynamic> json) =>
      _$IntegrationFromJson(json);

  bool get isActive => status == 'active';
  bool get isPending => status == 'pending';
  bool get hasError => status == 'error';

  String get typeLabel => switch (type) {
        'app_store_connect' => 'App Store Connect',
        'google_play_console' => 'Google Play Console',
        'apple_search_ads' => 'Apple Search Ads',
        'stripe' => 'Stripe',
        'slack' => 'Slack',
        'webhook' => 'Webhook',
        _ => type,
      };

  String get platform => switch (type) {
        'app_store_connect' => 'ios',
        'google_play_console' => 'android',
        _ => 'other',
      };

  int? get appsCount => metadata?['apps_count'] as int?;
  int? get importedCount => metadata?['imported_count'] as int?;
}

@freezed
class IntegrationApp with _$IntegrationApp {
  const factory IntegrationApp({
    required int id,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'bundle_id') String? bundleId,
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    required String platform,
  }) = _IntegrationApp;

  factory IntegrationApp.fromJson(Map<String, dynamic> json) =>
      _$IntegrationAppFromJson(json);
}

@freezed
class ConnectAppStoreResult with _$ConnectAppStoreResult {
  const factory ConnectAppStoreResult({
    required int id,
    required String type,
    required String status,
    @JsonKey(name: 'apps_discovered') required int appsDiscovered,
    @JsonKey(name: 'apps_imported') required int appsImported,
  }) = _ConnectAppStoreResult;

  factory ConnectAppStoreResult.fromJson(Map<String, dynamic> json) =>
      _$ConnectAppStoreResultFromJson(json);
}

@freezed
class ConnectGooglePlayResult with _$ConnectGooglePlayResult {
  const factory ConnectGooglePlayResult({
    required int id,
    required String type,
    required String status,
    @JsonKey(name: 'apps_imported') required int appsImported,
  }) = _ConnectGooglePlayResult;

  factory ConnectGooglePlayResult.fromJson(Map<String, dynamic> json) =>
      _$ConnectGooglePlayResultFromJson(json);
}
