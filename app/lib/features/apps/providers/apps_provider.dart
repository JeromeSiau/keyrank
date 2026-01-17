import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/apps_repository.dart';
import '../domain/app_model.dart';

final myAppsProvider = FutureProvider<List<AppModel>>((ref) async {
  final repository = ref.watch(appsRepositoryProvider);
  return repository.getMyApps();
});

final appSearchProvider = FutureProvider.family<List<AppSearchResult>, String>((ref, query) async {
  if (query.length < 2) return [];
  final repository = ref.watch(appsRepositoryProvider);
  return repository.searchApps(query: query);
});

class AppsNotifier extends StateNotifier<AsyncValue<List<AppModel>>> {
  final AppsRepository _repository;

  AppsNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final apps = await _repository.getMyApps();
      state = AsyncValue.data(apps);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<AppModel> addApp({
    required String platform,
    required String storeId,
    String country = 'us',
  }) async {
    try {
      final app = await _repository.addApp(
        platform: platform,
        storeId: storeId,
        country: country,
      );
      await load();
      return app;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteApp(int id) async {
    try {
      await _repository.deleteApp(id);
      await load();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleFavorite(int appId) async {
    final currentApps = state.valueOrNull;
    if (currentApps == null) return;

    final appIndex = currentApps.indexWhere((a) => a.id == appId);
    if (appIndex == -1) return;

    final app = currentApps[appIndex];
    final newFavorite = !app.isFavorite;

    // Optimistic update
    final updatedApps = List<AppModel>.from(currentApps);
    updatedApps[appIndex] = app.copyWith(
      isFavorite: newFavorite,
      favoritedAt: newFavorite ? DateTime.now() : null,
    );
    state = AsyncValue.data(updatedApps);

    try {
      await _repository.toggleFavorite(appId, newFavorite);
    } catch (e) {
      // Rollback on error
      state = AsyncValue.data(currentApps);
      rethrow;
    }
  }
}

final appsNotifierProvider = StateNotifierProvider<AppsNotifier, AsyncValue<List<AppModel>>>((ref) {
  return AppsNotifier(ref.watch(appsRepositoryProvider));
});
