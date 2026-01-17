import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/providers/app_context_provider.dart';
import '../data/competitors_repository.dart';
import '../domain/competitor_model.dart';
import '../domain/competitor_keywords_model.dart';
import '../domain/competitor_metadata_history_model.dart';

/// Repository provider
final competitorsRepositoryProvider = Provider<CompetitorsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CompetitorsRepository(dio);
});

/// Competitors list provider (context-aware)
final competitorsProvider = FutureProvider<List<CompetitorModel>>((ref) async {
  final repository = ref.watch(competitorsRepositoryProvider);
  final selectedApp = ref.watch(appContextProvider);

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

/// Filter for competitor keywords comparison
enum CompetitorKeywordFilter { all, gaps, youWin, theyWin }

/// Provider for selected competitor keyword filter
final competitorKeywordFilterProvider = StateProvider<CompetitorKeywordFilter>(
  (ref) => CompetitorKeywordFilter.gaps,
);

/// Parameters for competitor keywords provider
typedef CompetitorKeywordsParams = ({int competitorId, int appId, String country});

/// Family provider for competitor keywords
final competitorKeywordsProvider = FutureProvider.family<CompetitorKeywordsResponse, CompetitorKeywordsParams>(
  (ref, params) async {
    final repository = ref.watch(competitorsRepositoryProvider);
    return repository.getCompetitorKeywords(
      competitorId: params.competitorId,
      appId: params.appId,
      country: params.country,
    );
  },
);

/// Filtered competitor keywords based on selected filter
final filteredCompetitorKeywordsProvider = Provider.family<List<KeywordComparison>, List<KeywordComparison>>(
  (ref, keywords) {
    final filter = ref.watch(competitorKeywordFilterProvider);
    switch (filter) {
      case CompetitorKeywordFilter.all:
        return keywords;
      case CompetitorKeywordFilter.gaps:
        return keywords.where((k) => k.isGap).toList();
      case CompetitorKeywordFilter.youWin:
        return keywords.where((k) => k.youWin).toList();
      case CompetitorKeywordFilter.theyWin:
        return keywords.where((k) => k.theyWin).toList();
    }
  },
);

// =============================================================================
// Metadata History Providers
// =============================================================================

/// Parameters for competitor metadata history provider
typedef CompetitorMetadataHistoryParams = ({
  int competitorId,
  String locale,
  int days,
  bool changesOnly,
});

/// Provider for competitor metadata history
final competitorMetadataHistoryProvider = FutureProvider.family<
    CompetitorMetadataHistoryResponse, CompetitorMetadataHistoryParams>(
  (ref, params) async {
    final repository = ref.watch(competitorsRepositoryProvider);
    return repository.getMetadataHistory(
      competitorId: params.competitorId,
      locale: params.locale,
      days: params.days,
      changesOnly: params.changesOnly,
    );
  },
);

/// State provider for metadata history locale filter
final metadataHistoryLocaleProvider = StateProvider<String>((ref) => 'en-US');

/// State provider for metadata history days filter
final metadataHistoryDaysProvider = StateProvider<int>((ref) => 90);

/// State provider for showing only changes
final metadataHistoryChangesOnlyProvider = StateProvider<bool>((ref) => true);

// =============================================================================
// Metadata Insights Providers
// =============================================================================

/// Parameters for competitor metadata insights provider
typedef CompetitorMetadataInsightsParams = ({
  int competitorId,
  String locale,
  int days,
});

/// Provider for AI-generated metadata insights
final competitorMetadataInsightsProvider = FutureProvider.family<
    MetadataInsightsResponse, CompetitorMetadataInsightsParams>(
  (ref, params) async {
    final repository = ref.watch(competitorsRepositoryProvider);
    return repository.getMetadataInsights(
      competitorId: params.competitorId,
      locale: params.locale,
      days: params.days,
    );
  },
);
