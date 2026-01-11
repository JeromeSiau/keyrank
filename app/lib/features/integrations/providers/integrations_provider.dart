import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/integrations_repository.dart';
import '../domain/integration_model.dart';

final integrationsProvider =
    AsyncNotifierProvider<IntegrationsNotifier, List<Integration>>(
  IntegrationsNotifier.new,
);

class IntegrationsNotifier extends AsyncNotifier<List<Integration>> {
  @override
  Future<List<Integration>> build() async {
    return _fetchIntegrations();
  }

  Future<List<Integration>> _fetchIntegrations() async {
    final repository = ref.read(integrationsRepositoryProvider);
    return repository.getIntegrations();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchIntegrations());
  }

  Future<ConnectAppStoreResult> connectAppStore({
    required String keyId,
    required String issuerId,
    required String privateKey,
  }) async {
    final repository = ref.read(integrationsRepositoryProvider);
    final result = await repository.connectAppStore(
      keyId: keyId,
      issuerId: issuerId,
      privateKey: privateKey,
    );
    await refresh();
    return result;
  }

  Future<ConnectGooglePlayResult> connectGooglePlay({
    required String serviceAccountJson,
    required List<String> packageNames,
  }) async {
    final repository = ref.read(integrationsRepositoryProvider);
    final result = await repository.connectGooglePlay(
      serviceAccountJson: serviceAccountJson,
      packageNames: packageNames,
    );
    await refresh();
    return result;
  }

  Future<void> deleteIntegration(int id) async {
    final repository = ref.read(integrationsRepositoryProvider);
    await repository.deleteIntegration(id);
    await refresh();
  }

  Future<({int appsDiscovered, int appsImported})> refreshIntegration(
      int id) async {
    final repository = ref.read(integrationsRepositoryProvider);
    final result = await repository.refreshIntegration(id);
    await refresh();
    return result;
  }
}

final integrationAppsProvider =
    FutureProvider.family<List<IntegrationApp>, int>((ref, integrationId) async {
  final repository = ref.watch(integrationsRepositoryProvider);
  return repository.getIntegrationApps(integrationId);
});
