import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/country_provider.dart' show selectedCountryProvider;
import '../data/keywords_repository.dart';
import '../domain/keyword_model.dart';
import '../../categories/data/categories_repository.dart';
import '../../categories/domain/category_model.dart';

/// Selected platform for discovery (ios/android)
final discoverPlatformProvider = StateProvider<String>((ref) => 'ios');

/// Selected tab index (0 = Keywords, 1 = Categories)
final discoverTabProvider = StateProvider<int>((ref) => 0);

/// Keyword search query (raw, immediate)
final discoverSearchQueryProvider = StateProvider<String>((ref) => '');

/// Debounced search query - waits 300ms after last keystroke
final _debouncedSearchQueryProvider = StreamProvider<String>((ref) {
  final query = ref.watch(discoverSearchQueryProvider);
  final controller = StreamController<String>();

  final timer = Timer(const Duration(milliseconds: 300), () {
    controller.add(query);
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});

/// Keyword search results with debounce
final discoverSearchResultsProvider = FutureProvider<KeywordSearchResponse?>((ref) async {
  final debouncedQuery = ref.watch(_debouncedSearchQueryProvider);
  final query = debouncedQuery.valueOrNull ?? '';
  final country = ref.watch(selectedCountryProvider);
  final platform = ref.watch(discoverPlatformProvider);
  if (query.length < 2) return null;

  final repository = ref.watch(keywordsRepositoryProvider);
  return repository.searchKeyword(query: query, country: country.code, platform: platform);
});

/// Selected category for top apps
final discoverCategoryProvider = StateProvider<AppCategory?>((ref) => null);

/// Selected collection type (top_free, top_paid, etc.)
final discoverCollectionProvider = StateProvider<String>((ref) => 'top_free');

/// Available categories
final discoverCategoriesProvider = FutureProvider<CategoriesResponse>((ref) async {
  final repository = ref.watch(categoriesRepositoryProvider);
  return repository.getCategories();
});

/// Top apps for selected category
final discoverTopAppsProvider = FutureProvider<List<TopApp>>((ref) async {
  final category = ref.watch(discoverCategoryProvider);
  final platform = ref.watch(discoverPlatformProvider);
  final country = ref.watch(selectedCountryProvider);
  final collection = ref.watch(discoverCollectionProvider);

  if (category == null) return [];

  final repository = ref.watch(categoriesRepositoryProvider);
  return repository.getTopApps(
    categoryId: category.id,
    platform: platform,
    country: country.code,
    collection: collection,
  );
});
