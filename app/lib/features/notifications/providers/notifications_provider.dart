import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notifications_repository.dart';
import '../domain/notification_model.dart';

/// Unread count provider - refreshed when notifications change
final unreadCountProvider = FutureProvider.autoDispose<int>((ref) async {
  return ref.watch(notificationsRepositoryProvider).getUnreadCount();
});

/// Notifications state notifier for list management
class NotificationsNotifier extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final NotificationsRepository _repository;
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoadingMore = false;

  NotificationsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadInitial();
  }

  bool get hasMore => _currentPage < _lastPage;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadInitial() async {
    state = const AsyncValue.loading();
    try {
      final page = await _repository.getNotifications(page: 1);
      _currentPage = page.currentPage;
      _lastPage = page.lastPage;
      state = AsyncValue.data(page.data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore) return;
    _isLoadingMore = true;

    try {
      final page = await _repository.getNotifications(page: _currentPage + 1);
      _currentPage = page.currentPage;
      _lastPage = page.lastPage;
      state = AsyncValue.data([...state.value ?? [], ...page.data]);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> markAsRead(int id) async {
    await _repository.markAsRead(id);
    state = state.whenData((notifications) {
      return notifications.map((n) {
        if (n.id == id) {
          return n.copyWith(isRead: true, readAt: DateTime.now());
        }
        return n;
      }).toList();
    });
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
    state = state.whenData((notifications) {
      return notifications.map((n) => n.copyWith(isRead: true, readAt: DateTime.now())).toList();
    });
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
    state = state.whenData((notifications) {
      return notifications.where((n) => n.id != id).toList();
    });
  }
}

final notificationsNotifierProvider =
    StateNotifierProvider.autoDispose<NotificationsNotifier, AsyncValue<List<NotificationModel>>>((ref) {
  return NotificationsNotifier(ref.watch(notificationsRepositoryProvider));
});
