import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../apps/providers/apps_provider.dart';
import '../data/competitors_repository.dart';
import '../domain/competitor_model.dart';

/// Repository provider
final competitorsRepositoryProvider = Provider<CompetitorsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CompetitorsRepository(dio);
});

/// Competitors list provider (context-aware)
final competitorsProvider = FutureProvider<List<CompetitorModel>>((ref) async {
  final repository = ref.watch(competitorsRepositoryProvider);
  final selectedApp = ref.watch(selectedAppProvider);

  if (selectedApp != null) {
    return repository.getCompetitorsForApp(selectedApp.id);
  } else {
    return repository.getCompetitors();
  }
});

/// Competitors for a specific app
final competitorsForAppProvider = FutureProvider.family<List<CompetitorModel>, int>((ref, appId) async {
  final repository = ref.watch(competitorsRepositoryProvider);
  return repository.getCompetitorsForApp(appId);
});

/// Filter state for competitors list
enum CompetitorFilter { all, global, contextual }

final competitorFilterProvider = StateProvider<CompetitorFilter>((ref) => CompetitorFilter.all);

/// Filtered competitors
final filteredCompetitorsProvider = Provider<AsyncValue<List<CompetitorModel>>>((ref) {
  final competitorsAsync = ref.watch(competitorsProvider);
  final filter = ref.watch(competitorFilterProvider);

  return competitorsAsync.whenData((competitors) {
    switch (filter) {
      case CompetitorFilter.all:
        return competitors;
      case CompetitorFilter.global:
        return competitors.where((c) => c.isGlobal).toList();
      case CompetitorFilter.contextual:
        return competitors.where((c) => c.isContextual).toList();
    }
  });
});
