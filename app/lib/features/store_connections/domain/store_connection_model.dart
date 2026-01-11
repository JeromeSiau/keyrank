import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_connection_model.freezed.dart';
part 'store_connection_model.g.dart';

@freezed
class StoreConnection with _$StoreConnection {
  const factory StoreConnection({
    required int id,
    required String platform,
    required String status,
    @JsonKey(name: 'connected_at') required DateTime connectedAt,
    @JsonKey(name: 'last_sync_at') DateTime? lastSyncAt,
  }) = _StoreConnection;

  factory StoreConnection.fromJson(Map<String, dynamic> json) =>
      _$StoreConnectionFromJson(json);
}
