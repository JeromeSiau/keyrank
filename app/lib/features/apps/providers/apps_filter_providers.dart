import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/app_model.dart';
import 'apps_provider.dart';

/// Selected category filter for apps list (null = all categories)
final selectedCategoryFilterProvider = StateProvider<String?>((ref) => null);

/// Available categories derived from current apps
final availableCategoriesProvider = Provider<List<String>>((ref) {
  final appsAsync = ref.watch(appsNotifierProvider);
  return appsAsync.maybeWhen(
    data: (apps) {
      final categories = <String>{};
      for (final app in apps) {
        if (app.categoryId != null) {
          categories.add(app.categoryId!);
        }
      }
      return categories.toList()..sort();
    },
    orElse: () => [],
  );
});

/// Filtered apps based on selected category
final filteredAppsProvider = Provider<List<AppModel>>((ref) {
  final appsAsync = ref.watch(appsNotifierProvider);
  final selectedCategory = ref.watch(selectedCategoryFilterProvider);

  return appsAsync.maybeWhen(
    data: (apps) {
      if (selectedCategory == null) return apps;
      return apps.where((app) => app.categoryId == selectedCategory).toList();
    },
    orElse: () => [],
  );
});
