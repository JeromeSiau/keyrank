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
