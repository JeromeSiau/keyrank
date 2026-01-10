import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
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
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              await notifier.markAllAsRead();
              ref.invalidate(unreadCountProvider);
            },
            child: Text(
              'Mark all read',
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
                    'No notifications yet',
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
          );
        },
      ),
    );
  }
}
