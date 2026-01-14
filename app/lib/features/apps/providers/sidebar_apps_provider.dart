import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/app_model.dart';
import 'apps_provider.dart';

class SidebarApps {
  final List<AppModel> favorites;
  final List<AppModel> iosList;
  final List<AppModel> androidList;

  const SidebarApps({
    required this.favorites,
    required this.iosList,
    required this.androidList,
  });

  factory SidebarApps.empty() => const SidebarApps(
        favorites: [],
        iosList: [],
        androidList: [],
      );

  bool get hasTooManyFavorites => favorites.length > 5;
  bool get hasApps => favorites.isNotEmpty || iosList.isNotEmpty || androidList.isNotEmpty;
  int get totalCount => favorites.length + iosList.length + androidList.length;
}

final sidebarAppsProvider = Provider<SidebarApps>((ref) {
  final appsAsync = ref.watch(appsNotifierProvider);

  return appsAsync.when(
    data: (apps) {
      // Filter for owned apps only - competitors should not appear in the app context switcher
      final ownedApps = apps.where((app) => app.isOwner).toList();

      final favorites = ownedApps.where((a) => a.isFavorite).toList()
        ..sort((a, b) => (b.favoritedAt ?? DateTime(0)).compareTo(a.favoritedAt ?? DateTime(0)));

      final nonFavorites = ownedApps.where((a) => !a.isFavorite).toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      return SidebarApps(
        favorites: favorites,
        iosList: nonFavorites.where((a) => a.isIos).toList(),
        androidList: nonFavorites.where((a) => a.isAndroid).toList(),
      );
    },
    loading: () => SidebarApps.empty(),
    error: (_, _) => SidebarApps.empty(),
  );
});
