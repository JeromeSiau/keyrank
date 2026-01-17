import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../shared/widgets/states.dart';
import '../../alerts/providers/alerts_provider.dart';
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
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: context.l10n.notifications_manageAlerts,
            onPressed: () => context.push('/alerts'),
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
                    'No notifications yet',
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final rulesAsync = ref.watch(alertRulesNotifierProvider);
          final activeCount = rulesAsync.whenOrNull(
            data: (rules) => rules.where((r) => r.isActive).length,
          ) ?? 0;

          return Column(
            children: [
              // Active rules banner
              if (activeCount > 0)
                Material(
                  color: isDark
                      ? AppColors.accent.withValues(alpha: 0.1)
                      : AppColorsLight.accent.withValues(alpha: 0.1),
                  child: InkWell(
                    onTap: () => context.push('/alerts'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications_active,
                            size: 20,
                            color: isDark
                                ? AppColors.accent
                                : AppColorsLight.accent,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '$activeCount règle${activeCount > 1 ? 's' : ''} active${activeCount > 1 ? 's' : ''}',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColorsLight.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColorsLight.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // Notifications list
              Expanded(
                child: NotificationListener<ScrollNotification>(
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
              separatorBuilder: (_, _) => Divider(
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
          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
