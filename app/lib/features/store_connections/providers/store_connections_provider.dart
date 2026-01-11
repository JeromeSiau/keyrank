import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/store_connections_repository.dart';
import '../domain/store_connection_model.dart';

final storeConnectionsProvider =
    AsyncNotifierProvider<StoreConnectionsNotifier, List<StoreConnection>>(() {
  return StoreConnectionsNotifier();
});

class StoreConnectionsNotifier extends AsyncNotifier<List<StoreConnection>> {
  @override
  Future<List<StoreConnection>> build() async {
    return ref.watch(storeConnectionsRepositoryProvider).getConnections();
  }

  Future<void> connectIOS({
    required String name,
    required String keyId,
    required String issuerId,
    required String privateKey,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(storeConnectionsRepositoryProvider).createConnection(
        platform: 'ios',
        name: name,
        credentials: {
          'key_id': keyId,
          'issuer_id': issuerId,
          'private_key': privateKey,
        },
      );
      return ref.read(storeConnectionsRepositoryProvider).getConnections();
    });
  }

  Future<void> connectAndroid({
    required String name,
    required String clientId,
    required String clientSecret,
    required String refreshToken,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(storeConnectionsRepositoryProvider).createConnection(
        platform: 'android',
        name: name,
        credentials: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'refresh_token': refreshToken,
        },
      );
      return ref.read(storeConnectionsRepositoryProvider).getConnections();
    });
  }

  Future<void> disconnect(int connectionId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(storeConnectionsRepositoryProvider)
          .deleteConnection(connectionId);
      return ref.read(storeConnectionsRepositoryProvider).getConnections();
    });
  }

  bool isConnected(String platform) {
    return state.valueOrNull
            ?.any((c) => c.platform == platform && c.status == 'active') ??
        false;
  }
}
