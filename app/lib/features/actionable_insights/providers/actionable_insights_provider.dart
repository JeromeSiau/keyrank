import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/actionable_insights_repository.dart';
import '../domain/actionable_insight_model.dart';

/// Provider for insights summary (dashboard widget)
final insightsSummaryProvider = FutureProvider<InsightsSummary>((ref) async {
  final repository = ref.watch(actionableInsightsRepositoryProvider);
  return repository.getSummary();
});

/// Provider for unread count (notification badge)
final insightsUnreadCountProvider =
    FutureProvider<InsightsUnreadCount>((ref) async {
  final repository = ref.watch(actionableInsightsRepositoryProvider);
  return repository.getUnreadCount();
});

/// Provider for filtered insights list
final insightsListProvider = FutureProvider.family<List<ActionableInsight>,
    InsightsFilterParams>((ref, params) async {
  final repository = ref.watch(actionableInsightsRepositoryProvider);
  return repository.getInsights(
    appId: params.appId,
    type: params.type,
    unreadOnly: params.unreadOnly,
    priority: params.priority,
    page: params.page,
    perPage: params.perPage,
  );
});

/// Filter parameters for insights list
class InsightsFilterParams {
  final int? appId;
  final String? type;
  final bool? unreadOnly;
  final String? priority;
  final int page;
  final int perPage;

  const InsightsFilterParams({
    this.appId,
    this.type,
    this.unreadOnly,
    this.priority,
    this.page = 1,
    this.perPage = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightsFilterParams &&
          runtimeType == other.runtimeType &&
          appId == other.appId &&
          type == other.type &&
          unreadOnly == other.unreadOnly &&
          priority == other.priority &&
          page == other.page &&
          perPage == other.perPage;

  @override
  int get hashCode =>
      appId.hashCode ^
      type.hashCode ^
      unreadOnly.hashCode ^
      priority.hashCode ^
      page.hashCode ^
      perPage.hashCode;
}

/// Notifier for managing insight actions (mark as read, dismiss)
class InsightsActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final ActionableInsightsRepository _repository;
  final Ref _ref;

  InsightsActionsNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> markAsRead(int insightId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.markAsRead(insightId);
      // Invalidate related providers
      _ref.invalidate(insightsSummaryProvider);
      _ref.invalidate(insightsUnreadCountProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> dismiss(int insightId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.dismiss(insightId);
      // Invalidate related providers
      _ref.invalidate(insightsSummaryProvider);
      _ref.invalidate(insightsUnreadCountProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAllAsRead({int? appId}) async {
    state = const AsyncValue.loading();
    try {
      await _repository.markAllAsRead(appId: appId);
      // Invalidate related providers
      _ref.invalidate(insightsSummaryProvider);
      _ref.invalidate(insightsUnreadCountProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final insightsActionsProvider =
    StateNotifierProvider<InsightsActionsNotifier, AsyncValue<void>>((ref) {
  return InsightsActionsNotifier(
    ref.watch(actionableInsightsRepositoryProvider),
    ref,
  );
});
