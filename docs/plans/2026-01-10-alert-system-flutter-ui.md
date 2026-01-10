# Alert System Flutter UI Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the Flutter UI for the alert/notification system with inbox, templates, and custom rule builder.

**Architecture:** Feature-first structure following existing patterns. Riverpod for state management. Repository pattern for API calls. FCM for push notifications.

**Tech Stack:** Flutter, Riverpod 2.6.1, firebase_messaging, Dio

---

## Phase 1: Foundation - Models & API Layer

### Task 1: Add API Constants for Alerts & Notifications

**Files:**
- Modify: `app/lib/core/constants/api_constants.dart`

**Step 1: Add the new endpoint constants**

```dart
// Alert Rules endpoints
static const String alertTemplates = '/alerts/templates';
static const String alertRules = '/alerts/rules';

// Notifications endpoints
static const String notifications = '/notifications';
static const String notificationsUnreadCount = '/notifications/unread-count';
static const String notificationsMarkAllRead = '/notifications/mark-all-read';

// User preferences
static const String userPreferences = '/user/preferences';
static const String userFcmToken = '/user/fcm-token';
```

**Step 2: Commit**

```bash
git add app/lib/core/constants/api_constants.dart
git commit -m "feat(alerts): add API constants for alerts and notifications"
```

---

### Task 2: Create Notification Model

**Files:**
- Create: `app/lib/features/notifications/domain/notification_model.dart`

**Step 1: Write the model**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required int id,
    required int userId,
    int? alertRuleId,
    required String type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    required bool isRead,
    DateTime? readAt,
    DateTime? sentAt,
    required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

@freezed
class NotificationsPage with _$NotificationsPage {
  const factory NotificationsPage({
    required List<NotificationModel> data,
    required int currentPage,
    required int lastPage,
    required int total,
  }) = _NotificationsPage;

  factory NotificationsPage.fromJson(Map<String, dynamic> json) =>
      _$NotificationsPageFromJson(json);
}
```

**Step 2: Run build_runner**

```bash
cd app && dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Commit**

```bash
git add app/lib/features/notifications/
git commit -m "feat(notifications): add notification model with freezed"
```

---

### Task 3: Create Alert Rule Model

**Files:**
- Create: `app/lib/features/alerts/domain/alert_rule_model.dart`

**Step 1: Write the model**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_rule_model.freezed.dart';
part 'alert_rule_model.g.dart';

@freezed
class AlertRuleModel with _$AlertRuleModel {
  const factory AlertRuleModel({
    required int id,
    required int userId,
    required String name,
    required String type,
    required String scopeType,
    int? scopeId,
    required Map<String, dynamic> conditions,
    required bool isTemplate,
    required bool isActive,
    required int priority,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AlertRuleModel;

  factory AlertRuleModel.fromJson(Map<String, dynamic> json) =>
      _$AlertRuleModelFromJson(json);
}

/// Template returned by GET /alerts/templates
@freezed
class AlertTemplateModel with _$AlertTemplateModel {
  const factory AlertTemplateModel({
    required String name,
    required String type,
    required String icon,
    required String description,
    required Map<String, dynamic> defaultConditions,
  }) = _AlertTemplateModel;

  factory AlertTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$AlertTemplateModelFromJson(json);
}
```

**Step 2: Run build_runner**

```bash
cd app && dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Commit**

```bash
git add app/lib/features/alerts/
git commit -m "feat(alerts): add alert rule and template models"
```

---

### Task 4: Create Notifications Repository

**Files:**
- Create: `app/lib/features/notifications/data/notifications_repository.dart`

**Step 1: Write the repository**

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/notification_model.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepository(dio: ref.watch(dioProvider));
});

class NotificationsRepository {
  final Dio dio;

  NotificationsRepository({required this.dio});

  Future<NotificationsPage> getNotifications({int page = 1}) async {
    try {
      final response = await dio.get(
        ApiConstants.notifications,
        queryParameters: {'page': page},
      );
      return NotificationsPage.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await dio.get(ApiConstants.notificationsUnreadCount);
      return response.data['count'] as int;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await dio.patch('${ApiConstants.notifications}/$id/read');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await dio.post(ApiConstants.notificationsMarkAllRead);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> delete(int id) async {
    try {
      await dio.delete('${ApiConstants.notifications}/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/notifications/data/
git commit -m "feat(notifications): add notifications repository"
```

---

### Task 5: Create Alert Rules Repository

**Files:**
- Create: `app/lib/features/alerts/data/alerts_repository.dart`

**Step 1: Write the repository**

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/alert_rule_model.dart';

final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  return AlertsRepository(dio: ref.watch(dioProvider));
});

class AlertsRepository {
  final Dio dio;

  AlertsRepository({required this.dio});

  Future<List<AlertTemplateModel>> getTemplates() async {
    try {
      final response = await dio.get(ApiConstants.alertTemplates);
      final data = response.data['data'] as List;
      return data.map((e) => AlertTemplateModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<AlertRuleModel>> getRules() async {
    try {
      final response = await dio.get(ApiConstants.alertRules);
      final data = response.data['data'] as List;
      return data.map((e) => AlertRuleModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<AlertRuleModel> createRule({
    required String name,
    required String type,
    required String scopeType,
    int? scopeId,
    required Map<String, dynamic> conditions,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.alertRules,
        data: {
          'name': name,
          'type': type,
          'scope_type': scopeType,
          if (scopeId != null) 'scope_id': scopeId,
          'conditions': conditions,
        },
      );
      return AlertRuleModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<AlertRuleModel> updateRule(int id, {
    String? name,
    Map<String, dynamic>? conditions,
    bool? isActive,
  }) async {
    try {
      final response = await dio.put(
        '${ApiConstants.alertRules}/$id',
        data: {
          if (name != null) 'name': name,
          if (conditions != null) 'conditions': conditions,
          if (isActive != null) 'is_active': isActive,
        },
      );
      return AlertRuleModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> toggleRule(int id) async {
    try {
      await dio.patch('${ApiConstants.alertRules}/$id/toggle');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> deleteRule(int id) async {
    try {
      await dio.delete('${ApiConstants.alertRules}/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/alerts/data/
git commit -m "feat(alerts): add alerts repository"
```

---

## Phase 2: State Management - Providers

### Task 6: Create Notifications Provider

**Files:**
- Create: `app/lib/features/notifications/providers/notifications_provider.dart`

**Step 1: Write the providers**

```dart
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
```

**Step 2: Commit**

```bash
git add app/lib/features/notifications/providers/
git commit -m "feat(notifications): add notifications provider with pagination"
```

---

### Task 7: Create Alerts Provider

**Files:**
- Create: `app/lib/features/alerts/providers/alerts_provider.dart`

**Step 1: Write the providers**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/alerts_repository.dart';
import '../domain/alert_rule_model.dart';

/// Templates provider - cached, rarely changes
final alertTemplatesProvider = FutureProvider<List<AlertTemplateModel>>((ref) async {
  return ref.watch(alertsRepositoryProvider).getTemplates();
});

/// Alert rules state notifier
class AlertRulesNotifier extends StateNotifier<AsyncValue<List<AlertRuleModel>>> {
  final AlertsRepository _repository;

  AlertRulesNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final rules = await _repository.getRules();
      state = AsyncValue.data(rules);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createFromTemplate(AlertTemplateModel template) async {
    final rule = await _repository.createRule(
      name: template.name,
      type: template.type,
      scopeType: 'global',
      conditions: template.defaultConditions,
    );
    state = state.whenData((rules) => [...rules, rule]);
  }

  Future<void> createCustomRule({
    required String name,
    required String type,
    required String scopeType,
    int? scopeId,
    required Map<String, dynamic> conditions,
  }) async {
    final rule = await _repository.createRule(
      name: name,
      type: type,
      scopeType: scopeType,
      scopeId: scopeId,
      conditions: conditions,
    );
    state = state.whenData((rules) => [...rules, rule]);
  }

  Future<void> toggle(int id) async {
    await _repository.toggleRule(id);
    state = state.whenData((rules) {
      return rules.map((r) {
        if (r.id == id) {
          return r.copyWith(isActive: !r.isActive);
        }
        return r;
      }).toList();
    });
  }

  Future<void> updateConditions(int id, Map<String, dynamic> conditions) async {
    final updated = await _repository.updateRule(id, conditions: conditions);
    state = state.whenData((rules) {
      return rules.map((r) => r.id == id ? updated : r).toList();
    });
  }

  Future<void> delete(int id) async {
    await _repository.deleteRule(id);
    state = state.whenData((rules) => rules.where((r) => r.id != id).toList());
  }
}

final alertRulesNotifierProvider =
    StateNotifierProvider<AlertRulesNotifier, AsyncValue<List<AlertRuleModel>>>((ref) {
  return AlertRulesNotifier(ref.watch(alertsRepositoryProvider));
});
```

**Step 2: Commit**

```bash
git add app/lib/features/alerts/providers/
git commit -m "feat(alerts): add alert rules provider with CRUD operations"
```

---

## Phase 3: Notifications UI

### Task 8: Create NotificationTile Widget

**Files:**
- Create: `app/lib/features/notifications/presentation/widgets/notification_tile.dart`

**Step 1: Write the widget**

```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  IconData _iconForType(String type) {
    return switch (type) {
      'position_change' => Icons.trending_up,
      'rating_change' => Icons.star,
      'review_spike' => Icons.reviews,
      'review_keyword' => Icons.search,
      'new_competitor' => Icons.group_add,
      'competitor_passed' => Icons.sports_martial_arts,
      'mass_movement' => Icons.waves,
      'keyword_popularity' => Icons.local_fire_department,
      'opportunity' => Icons.diamond,
      'aggregated' => Icons.folder,
      _ => Icons.notifications,
    };
  }

  Color _colorForType(String type, bool isDark) {
    return switch (type) {
      'position_change' => isDark ? AppColors.accent : AppColorsLight.accent,
      'rating_change' => isDark ? AppColors.orange : AppColorsLight.orange,
      'review_spike' => isDark ? AppColors.red : AppColorsLight.red,
      'opportunity' => isDark ? AppColors.purple : AppColorsLight.purple,
      _ => isDark ? AppColors.green : AppColorsLight.green,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = _colorForType(notification.type, isDark);

    return Dismissible(
      key: Key('notification_${notification.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: isDark ? AppColors.red : AppColorsLight.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Material(
        color: notification.isRead
            ? Colors.transparent
            : (isDark ? AppColors.accent.withAlpha(15) : AppColorsLight.accent.withAlpha(15)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: typeColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _iconForType(notification.type),
                    color: typeColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                                color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: typeColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatDate(notification.createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return DateFormat.MMMd().format(date);
    }
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/notifications/presentation/widgets/
git commit -m "feat(notifications): add notification tile with swipe-to-delete"
```

---

### Task 9: Create NotificationsScreen

**Files:**
- Create: `app/lib/features/notifications/presentation/notifications_screen.dart`

**Step 1: Write the screen**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../shared/widgets/states.dart';
import '../providers/notifications_provider.dart';
import 'widgets/notification_tile.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notificationsAsync = ref.watch(notificationsNotifierProvider);
    final notifier = ref.read(notificationsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      appBar: AppBar(
        title: Text(context.l10n.notifications_title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              await notifier.markAllAsRead();
              ref.invalidate(unreadCountProvider);
            },
            child: Text(
              context.l10n.notifications_markAllRead,
              style: TextStyle(
                color: isDark ? AppColors.accent : AppColorsLight.accent,
              ),
            ),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: notifier.loadInitial,
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.notifications_empty,
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  notification.metrics.extentAfter < 200 &&
                  notifier.hasMore &&
                  !notifier.isLoadingMore) {
                notifier.loadMore();
              }
              return false;
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length + (notifier.hasMore ? 1 : 0),
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: isDark ? AppColors.border : AppColorsLight.border,
              ),
              itemBuilder: (context, index) {
                if (index >= notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final notification = notifications[index];
                return NotificationTile(
                  notification: notification,
                  onTap: () async {
                    if (!notification.isRead) {
                      await notifier.markAsRead(notification.id);
                      ref.invalidate(unreadCountProvider);
                    }
                    // TODO: Navigate to relevant screen based on notification.data
                  },
                  onDismiss: () async {
                    await notifier.delete(notification.id);
                    ref.invalidate(unreadCountProvider);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/notifications/presentation/
git commit -m "feat(notifications): add notifications inbox screen with infinite scroll"
```

---

### Task 10: Add Notification Badge to Navigation

**Files:**
- Modify: `app/lib/core/widgets/responsive_shell.dart`
- Modify: `app/lib/core/widgets/glass_bottom_nav_bar.dart` (if exists)

**Step 1: Add badge provider watch and display**

In the navigation components, add a badge showing unread count:

```dart
// In navigation item for notifications
Consumer(
  builder: (context, ref, child) {
    final unreadCount = ref.watch(unreadCountProvider);
    return Badge(
      isLabelVisible: unreadCount.valueOrNull != null && unreadCount.value! > 0,
      label: Text('${unreadCount.value}'),
      child: Icon(Icons.notifications_outlined),
    );
  },
)
```

**Step 2: Add route to app_router.dart**

```dart
GoRoute(
  path: '/notifications',
  builder: (context, state) => const NotificationsScreen(),
),
```

**Step 3: Commit**

```bash
git add app/lib/core/widgets/ app/lib/core/router/
git commit -m "feat(notifications): add notification badge and route"
```

---

## Phase 4: Alert Rules UI

### Task 11: Create AlertTemplateCard Widget

**Files:**
- Create: `app/lib/features/alerts/presentation/widgets/alert_template_card.dart`

**Step 1: Write the widget**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/alert_rule_model.dart';

class AlertTemplateCard extends StatelessWidget {
  final AlertTemplateModel template;
  final bool isActivated;
  final VoidCallback onActivate;

  const AlertTemplateCard({
    super.key,
    required this.template,
    required this.isActivated,
    required this.onActivate,
  });

  IconData _parseIcon(String iconStr) {
    // Template icons from backend: "trending_down", "trending_up", etc.
    return switch (iconStr) {
      'trending_down' => Icons.trending_down,
      'trending_up' => Icons.trending_up,
      'emoji_events' => Icons.emoji_events,
      'star_half' => Icons.star_half,
      'sentiment_very_dissatisfied' => Icons.sentiment_very_dissatisfied,
      'search' => Icons.search,
      'person_add' => Icons.person_add,
      'sports_martial_arts' => Icons.sports_martial_arts,
      'waves' => Icons.waves,
      'local_fire_department' => Icons.local_fire_department,
      'diamond' => Icons.diamond,
      _ => Icons.notifications,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.accent : AppColorsLight.accent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(
          color: isActivated ? accentColor : (isDark ? AppColors.glassBorder : AppColorsLight.glassBorder),
          width: isActivated ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _parseIcon(template.icon),
                color: isActivated ? accentColor : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
                size: 24,
              ),
              const Spacer(),
              if (isActivated)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            template.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            template.description,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: isActivated ? null : onActivate,
              style: OutlinedButton.styleFrom(
                foregroundColor: accentColor,
                side: BorderSide(color: accentColor.withAlpha(isActivated ? 50 : 150)),
              ),
              child: Text(isActivated ? 'Already active' : 'Activate'),
            ),
          ),
        ],
      ),
    );
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/alerts/presentation/widgets/
git commit -m "feat(alerts): add alert template card widget"
```

---

### Task 12: Create AlertRuleTile Widget

**Files:**
- Create: `app/lib/features/alerts/presentation/widgets/alert_rule_tile.dart`

**Step 1: Write the widget**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/alert_rule_model.dart';

class AlertRuleTile extends StatelessWidget {
  final AlertRuleModel rule;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AlertRuleTile({
    super.key,
    required this.rule,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  String _scopeLabel(String scopeType) {
    return switch (scopeType) {
      'global' => 'All apps',
      'app' => 'Specific app',
      'category' => 'Category',
      'keyword' => 'Keyword',
      _ => scopeType,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.accent : AppColorsLight.accent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Switch.adaptive(
          value: rule.isActive,
          onChanged: (_) => onToggle(),
          activeColor: accentColor,
        ),
        title: Text(
          rule.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: rule.isActive
                ? (isDark ? AppColors.textPrimary : AppColorsLight.textPrimary)
                : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: accentColor.withAlpha(20),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _scopeLabel(rule.scopeType),
                style: TextStyle(
                  fontSize: 10,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
          ),
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEdit();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete', style: TextStyle(color: isDark ? AppColors.red : AppColorsLight.red)),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/alerts/presentation/widgets/
git commit -m "feat(alerts): add alert rule tile with toggle and menu"
```

---

### Task 13: Create AlertsScreen (Templates + Rules List)

**Files:**
- Create: `app/lib/features/alerts/presentation/alerts_screen.dart`

**Step 1: Write the screen**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../shared/widgets/states.dart';
import '../providers/alerts_provider.dart';
import 'widgets/alert_template_card.dart';
import 'widgets/alert_rule_tile.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final templatesAsync = ref.watch(alertTemplatesProvider);
    final rulesAsync = ref.watch(alertRulesNotifierProvider);
    final rulesNotifier = ref.read(alertRulesNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      appBar: AppBar(
        title: Text(context.l10n.alerts_title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/alerts/builder'),
            tooltip: 'Create custom rule',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Templates section
            Text(
              context.l10n.alerts_templatesTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.alerts_templatesSubtitle,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            templatesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (templates) {
                final activeTypes = rulesAsync.valueOrNull?.map((r) => r.type).toSet() ?? {};

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    final template = templates[index];
                    return AlertTemplateCard(
                      template: template,
                      isActivated: activeTypes.contains(template.type),
                      onActivate: () async {
                        try {
                          await rulesNotifier.createFromTemplate(template);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${template.name} activated!')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 32),

            // My Rules section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.alerts_myRulesTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                TextButton.icon(
                  onPressed: () => context.push('/alerts/builder'),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(context.l10n.alerts_createRule),
                ),
              ],
            ),
            const SizedBox(height: 12),

            rulesAsync.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(message: e.toString(), onRetry: rulesNotifier.load),
              data: (rules) {
                if (rules.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.rule_folder_outlined,
                            size: 48,
                            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            context.l10n.alerts_noRulesYet,
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rules.length,
                  itemBuilder: (context, index) {
                    final rule = rules[index];
                    return AlertRuleTile(
                      rule: rule,
                      onToggle: () => rulesNotifier.toggle(rule.id),
                      onEdit: () => context.push('/alerts/builder', extra: rule),
                      onDelete: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete rule?'),
                            content: Text('This will delete "${rule.name}".'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: isDark ? AppColors.red : AppColorsLight.red),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await rulesNotifier.delete(rule.id);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/alerts/presentation/
git commit -m "feat(alerts): add alerts screen with templates grid and rules list"
```

---

### Task 14: Create AlertRuleBuilderScreen (Step-by-Step Wizard)

**Files:**
- Create: `app/lib/features/alerts/presentation/alert_rule_builder_screen.dart`

**Step 1: Write the builder screen**

This is a multi-step form:
1. Choose alert type
2. Choose scope (global, app, category, keyword)
3. Configure conditions (depends on type)
4. Name and save

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../domain/alert_rule_model.dart';
import '../providers/alerts_provider.dart';
import 'widgets/builder_steps/type_step.dart';
import 'widgets/builder_steps/scope_step.dart';
import 'widgets/builder_steps/conditions_step.dart';
import 'widgets/builder_steps/name_step.dart';

class AlertRuleBuilderScreen extends ConsumerStatefulWidget {
  final AlertRuleModel? existingRule;

  const AlertRuleBuilderScreen({super.key, this.existingRule});

  @override
  ConsumerState<AlertRuleBuilderScreen> createState() => _AlertRuleBuilderScreenState();
}

class _AlertRuleBuilderScreenState extends ConsumerState<AlertRuleBuilderScreen> {
  late PageController _pageController;
  int _currentStep = 0;

  // Form state
  String? _selectedType;
  String _scopeType = 'global';
  int? _scopeId;
  Map<String, dynamic> _conditions = {};
  String _name = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Pre-fill if editing
    if (widget.existingRule != null) {
      final rule = widget.existingRule!;
      _selectedType = rule.type;
      _scopeType = rule.scopeType;
      _scopeId = rule.scopeId;
      _conditions = Map.from(rule.conditions);
      _name = rule.name;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  Future<void> _saveRule() async {
    final notifier = ref.read(alertRulesNotifierProvider.notifier);

    try {
      if (widget.existingRule != null) {
        await notifier.updateConditions(widget.existingRule!.id, _conditions);
      } else {
        await notifier.createCustomRule(
          name: _name,
          type: _selectedType!,
          scopeType: _scopeType,
          scopeId: _scopeId,
          conditions: _conditions,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.existingRule != null ? 'Rule updated!' : 'Rule created!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      appBar: AppBar(
        title: Text(widget.existingRule != null
            ? context.l10n.alerts_editRule
            : context.l10n.alerts_createRule),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Step indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: List.generate(4, (index) {
                final isActive = index <= _currentStep;
                return Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isActive
                              ? (isDark ? AppColors.accent : AppColorsLight.accent)
                              : (isDark ? AppColors.bgSurface : AppColorsLight.bgSurface),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: isActive
                                  ? Colors.white
                                  : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
                            ),
                          ),
                        ),
                      ),
                      if (index < 3)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: index < _currentStep
                                ? (isDark ? AppColors.accent : AppColorsLight.accent)
                                : (isDark ? AppColors.border : AppColorsLight.border),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),

          // Pages
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                TypeStep(
                  selectedType: _selectedType,
                  onTypeSelected: (type) {
                    setState(() => _selectedType = type);
                    _nextStep();
                  },
                ),
                ScopeStep(
                  scopeType: _scopeType,
                  scopeId: _scopeId,
                  onScopeChanged: (type, id) {
                    setState(() {
                      _scopeType = type;
                      _scopeId = id;
                    });
                  },
                  onContinue: _nextStep,
                ),
                ConditionsStep(
                  type: _selectedType ?? '',
                  conditions: _conditions,
                  onConditionsChanged: (conditions) {
                    setState(() => _conditions = conditions);
                  },
                  onContinue: _nextStep,
                ),
                NameStep(
                  name: _name,
                  onNameChanged: (name) => setState(() => _name = name),
                  onSave: _saveRule,
                  isEditing: widget.existingRule != null,
                ),
              ],
            ),
          ),

          // Navigation buttons
          if (_currentStep > 0 && _currentStep < 3)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    OutlinedButton(
                      onPressed: _previousStep,
                      child: Text(context.l10n.common_back),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

**Step 2: Create step widgets (type_step.dart, scope_step.dart, conditions_step.dart, name_step.dart)**

Create `app/lib/features/alerts/presentation/widgets/builder_steps/` directory with the 4 step widgets.

**Step 3: Commit**

```bash
git add app/lib/features/alerts/presentation/
git commit -m "feat(alerts): add step-by-step rule builder wizard"
```

---

### Task 15: Create Builder Step Widgets

**Files:**
- Create: `app/lib/features/alerts/presentation/widgets/builder_steps/type_step.dart`
- Create: `app/lib/features/alerts/presentation/widgets/builder_steps/scope_step.dart`
- Create: `app/lib/features/alerts/presentation/widgets/builder_steps/conditions_step.dart`
- Create: `app/lib/features/alerts/presentation/widgets/builder_steps/name_step.dart`

**Step 1: Create type_step.dart**

```dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class TypeStep extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String> onTypeSelected;

  const TypeStep({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  static const _alertTypes = [
    ('position_change', Icons.trending_up, 'Position Change', 'Ranking moved up or down'),
    ('rating_change', Icons.star, 'Rating Change', 'App rating increased or decreased'),
    ('review_spike', Icons.reviews, 'Review Spike', 'Unusual number of reviews'),
    ('review_keyword', Icons.search, 'Review Keyword', 'Specific words in reviews'),
    ('new_competitor', Icons.group_add, 'New Competitor', 'New app entered rankings'),
    ('competitor_passed', Icons.sports_martial_arts, 'Competitor Passed', 'Competitor overtook you'),
    ('mass_movement', Icons.waves, 'Mass Movement', 'Many rankings changed'),
    ('keyword_popularity', Icons.local_fire_department, 'Keyword Trend', 'Search volume change'),
    ('opportunity', Icons.diamond, 'Opportunity', 'Low competition keyword'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What do you want to track?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: _alertTypes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final (type, icon, title, description) = _alertTypes[index];
                final isSelected = selectedType == type;

                return Material(
                  color: isSelected
                      ? (isDark ? AppColors.accent.withAlpha(25) : AppColorsLight.accent.withAlpha(25))
                      : (isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => onTypeSelected(type),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? (isDark ? AppColors.accent : AppColorsLight.accent)
                              : (isDark ? AppColors.glassBorder : AppColorsLight.glassBorder),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(icon, color: isDark ? AppColors.accent : AppColorsLight.accent),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: isDark ? AppColors.accent : AppColorsLight.accent,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

**Step 2: Create scope_step.dart, conditions_step.dart, name_step.dart** (similar pattern)

**Step 3: Commit**

```bash
git add app/lib/features/alerts/presentation/widgets/builder_steps/
git commit -m "feat(alerts): add builder step widgets for wizard flow"
```

---

## Phase 5: Settings Integration

### Task 16: Add Notification Settings to Settings Screen

**Files:**
- Modify: `app/lib/features/settings/presentation/settings_screen.dart`

**Step 1: Add notification preferences section**

Add a new `_SectionCard` for notification settings:

```dart
// Notifications section
_SectionCard(
  isDark: isDark,
  title: context.l10n.settings_notifications,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Quiet hours toggle
      SwitchListTile(
        title: Text(context.l10n.settings_quietHours),
        subtitle: Text(context.l10n.settings_quietHoursDesc),
        value: _quietHoursEnabled,
        onChanged: (value) => _updateQuietHours(value),
      ),
      if (_quietHoursEnabled) ...[
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _TimePicker(
                label: 'From',
                value: _quietHoursStart,
                onChanged: (time) => _updateQuietHoursStart(time),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _TimePicker(
                label: 'To',
                value: _quietHoursEnd,
                onChanged: (time) => _updateQuietHoursEnd(time),
              ),
            ),
          ],
        ),
      ],
      const Divider(height: 32),
      // Timezone picker
      _TimezonePicker(
        value: _timezone,
        onChanged: (tz) => _updateTimezone(tz),
      ),
    ],
  ),
),

const SizedBox(height: 16),

// Link to alerts management
ListTile(
  leading: const Icon(Icons.notifications_active),
  title: Text(context.l10n.settings_manageAlerts),
  trailing: const Icon(Icons.chevron_right),
  onTap: () => context.push('/alerts'),
),
```

**Step 2: Commit**

```bash
git add app/lib/features/settings/
git commit -m "feat(settings): add notification preferences section"
```

---

## Phase 6: FCM Integration

### Task 17: Add Firebase Messaging Dependency

**Files:**
- Modify: `app/pubspec.yaml`

**Step 1: Add dependencies**

```yaml
dependencies:
  firebase_core: ^3.8.0
  firebase_messaging: ^15.1.5
```

**Step 2: Run flutter pub get**

```bash
cd app && flutter pub get
```

**Step 3: Commit**

```bash
git add app/pubspec.yaml app/pubspec.lock
git commit -m "feat(fcm): add firebase_messaging dependency"
```

---

### Task 18: Create FCM Service

**Files:**
- Create: `app/lib/core/services/fcm_service.dart`

**Step 1: Write the FCM service**

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../constants/api_constants.dart';

final fcmServiceProvider = Provider<FcmService>((ref) {
  return FcmService(ref);
});

class FcmService {
  final Ref _ref;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  FcmService(this._ref);

  Future<void> initialize() async {
    // Request permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get token and send to backend
      final token = await _messaging.getToken();
      if (token != null) {
        await _sendTokenToBackend(token);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_sendTokenToBackend);
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background/terminated message taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // Check for initial message (app opened from terminated state)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      final dio = _ref.read(dioProvider);
      await dio.put(ApiConstants.userFcmToken, data: {'fcm_token': token});
    } catch (e) {
      // Log error but don't crash
      print('Failed to send FCM token: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification or update badge
    // Could use flutter_local_notifications here
    print('Foreground message: ${message.notification?.title}');
  }

  void _handleMessageTap(RemoteMessage message) {
    // Navigate to relevant screen based on message data
    final data = message.data;
    // TODO: Use GoRouter to navigate based on data['type'] and data['id']
  }

  Future<void> deleteToken() async {
    await _messaging.deleteToken();
    try {
      final dio = _ref.read(dioProvider);
      await dio.put(ApiConstants.userFcmToken, data: {'fcm_token': null});
    } catch (e) {
      print('Failed to clear FCM token: $e');
    }
  }
}
```

**Step 2: Initialize in main.dart**

```dart
// In main.dart, after Firebase.initializeApp()
final container = ProviderContainer();
await container.read(fcmServiceProvider).initialize();
```

**Step 3: Commit**

```bash
git add app/lib/core/services/ app/lib/main.dart
git commit -m "feat(fcm): add FCM service with token management"
```

---

## Phase 7: Localization

### Task 19: Add Localization Strings

**Files:**
- Modify: `app/lib/l10n/app_en.arb` (and other language files)

**Step 1: Add English strings**

```json
{
  "notifications_title": "Notifications",
  "notifications_markAllRead": "Mark all read",
  "notifications_empty": "No notifications yet",

  "alerts_title": "Alert Rules",
  "alerts_templatesTitle": "Quick Templates",
  "alerts_templatesSubtitle": "Activate common alerts with one tap",
  "alerts_myRulesTitle": "My Rules",
  "alerts_createRule": "Create rule",
  "alerts_editRule": "Edit rule",
  "alerts_noRulesYet": "No rules yet. Activate a template or create your own!",

  "settings_notifications": "NOTIFICATIONS",
  "settings_quietHours": "Quiet Hours",
  "settings_quietHoursDesc": "Pause push notifications during specific hours",
  "settings_manageAlerts": "Manage Alert Rules",

  "common_back": "Back",
  "common_save": "Save",
  "common_cancel": "Cancel"
}
```

**Step 2: Generate localizations**

```bash
cd app && flutter gen-l10n
```

**Step 3: Commit**

```bash
git add app/lib/l10n/
git commit -m "feat(l10n): add localization strings for alerts and notifications"
```

---

## Phase 8: Routing

### Task 20: Add Routes for New Screens

**Files:**
- Modify: `app/lib/core/router/app_router.dart`

**Step 1: Add new routes**

```dart
GoRoute(
  path: '/notifications',
  builder: (context, state) => const NotificationsScreen(),
),
GoRoute(
  path: '/alerts',
  builder: (context, state) => const AlertsScreen(),
),
GoRoute(
  path: '/alerts/builder',
  builder: (context, state) {
    final existingRule = state.extra as AlertRuleModel?;
    return AlertRuleBuilderScreen(existingRule: existingRule);
  },
),
```

**Step 2: Add imports for new screens**

**Step 3: Commit**

```bash
git add app/lib/core/router/
git commit -m "feat(router): add routes for notifications and alerts screens"
```

---

## Summary

**20 tasks total:**
- Phase 1: Foundation (5 tasks) - API constants, models, repositories
- Phase 2: State Management (2 tasks) - Riverpod providers
- Phase 3: Notifications UI (3 tasks) - Tile, screen, badge
- Phase 4: Alert Rules UI (5 tasks) - Templates, rules, builder wizard
- Phase 5: Settings (1 task) - Notification preferences
- Phase 6: FCM Integration (2 tasks) - Firebase setup
- Phase 7: Localization (1 task) - i18n strings
- Phase 8: Routing (1 task) - GoRouter config

**Key patterns followed:**
- Feature-first architecture (`lib/features/alerts/`, `lib/features/notifications/`)
- Riverpod for state (`StateNotifierProvider`, `FutureProvider`)
- Repository pattern for API calls
- Freezed for immutable models
- Glass-morphism UI components
- `context.l10n.key` for localization
