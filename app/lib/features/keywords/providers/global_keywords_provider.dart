import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/keywords_repository.dart';
import '../domain/keyword_model.dart';
import '../../apps/providers/apps_provider.dart';
import '../../apps/domain/app_model.dart';

/// A keyword with its associated app information for global view
class KeywordWithApp {
  final Keyword keyword;
  final AppModel app;

  const KeywordWithApp({required this.keyword, required this.app});
}

/// Provider that fetches keywords from all apps and enriches them with app info
/// Only includes owned apps, not competitors
final globalKeywordsProvider = FutureProvider<List<KeywordWithApp>>((ref) async {
  final appsState = ref.watch(appsNotifierProvider);
  final allApps = appsState.valueOrNull ?? [];

  // Filter out competitors - only show keywords from owned apps
  final apps = allApps.where((app) => !app.isCompetitor).toList();

  if (apps.isEmpty) {
    return [];
  }

  final repository = ref.read(keywordsRepositoryProvider);
  final allKeywords = <KeywordWithApp>[];

  // Fetch keywords for each app
  for (final app in apps) {
    try {
      final keywords = await repository.getKeywordsForApp(app.id);
      for (final keyword in keywords) {
        allKeywords.add(KeywordWithApp(keyword: keyword, app: app));
      }
    } catch (e) {
      // Skip apps that fail to load, continue with others
    }
  }

  // Sort by app name, then by keyword
  allKeywords.sort((a, b) {
    final appCompare = a.app.name.compareTo(b.app.name);
    if (appCompare != 0) return appCompare;
    return a.keyword.keyword.compareTo(b.keyword.keyword);
  });

  return allKeywords;
});
