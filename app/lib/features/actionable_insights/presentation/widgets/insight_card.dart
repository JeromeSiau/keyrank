import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../domain/actionable_insight_model.dart';
import '../../providers/actionable_insights_provider.dart';

class InsightCard extends ConsumerWidget {
  final ActionableInsight insight;
  final VoidCallback? onTap;
  final bool showDismiss;

  const InsightCard({
    super.key,
    required this.insight,
    this.onTap,
    this.showDismiss = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = _getTypeColors(insight.type, theme);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: insight.isRead
              ? theme.dividerColor
              : colors.border,
          width: insight.isRead ? 1 : 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (!insight.isRead) {
            ref.read(insightsActionsProvider.notifier).markAsRead(insight.id);
          }
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildTypeIcon(colors),
                  const SizedBox(width: 8),
                  _buildPriorityBadge(theme),
                  const Spacer(),
                  if (insight.app != null) _buildAppChip(theme),
                  if (showDismiss) _buildDismissButton(ref, theme),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                insight.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: insight.isRead ? FontWeight.normal : FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                insight.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    timeago.format(insight.generatedAt),
                    style: theme.textTheme.bodySmall,
                  ),
                  if (insight.actionText != null) ...[
                    const Spacer(),
                    TextButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: Text(insight.actionText!),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon(_InsightColors colors) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _getTypeIcon(insight.type),
        size: 16,
        color: colors.icon,
      ),
    );
  }

  Widget _buildPriorityBadge(ThemeData theme) {
    final color = _getPriorityColor(insight.priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        insight.priority.name.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildAppChip(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (insight.app!.iconUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                insight.app!.iconUrl!,
                width: 16,
                height: 16,
                errorBuilder: (_, _, _) => const Icon(Icons.apps, size: 16),
              ),
            ),
          const SizedBox(width: 4),
          Text(
            insight.app!.name,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildDismissButton(WidgetRef ref, ThemeData theme) {
    return IconButton(
      icon: Icon(
        Icons.close,
        size: 18,
        color: theme.textTheme.bodySmall?.color,
      ),
      onPressed: () {
        ref.read(insightsActionsProvider.notifier).dismiss(insight.id);
      },
      tooltip: 'Dismiss',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  IconData _getTypeIcon(InsightType type) {
    return switch (type) {
      InsightType.opportunity => Icons.lightbulb_outline,
      InsightType.warning => Icons.warning_amber_outlined,
      InsightType.win => Icons.emoji_events_outlined,
      InsightType.competitorMove => Icons.people_outline,
      InsightType.theme => Icons.tag,
      InsightType.suggestion => Icons.tips_and_updates_outlined,
    };
  }

  _InsightColors _getTypeColors(InsightType type, ThemeData theme) {
    return switch (type) {
      InsightType.opportunity => _InsightColors(
          icon: Colors.blue,
          background: Colors.blue.withOpacity(0.1),
          border: Colors.blue.withOpacity(0.3),
        ),
      InsightType.warning => _InsightColors(
          icon: Colors.orange,
          background: Colors.orange.withOpacity(0.1),
          border: Colors.orange.withOpacity(0.3),
        ),
      InsightType.win => _InsightColors(
          icon: Colors.green,
          background: Colors.green.withOpacity(0.1),
          border: Colors.green.withOpacity(0.3),
        ),
      InsightType.competitorMove => _InsightColors(
          icon: Colors.purple,
          background: Colors.purple.withOpacity(0.1),
          border: Colors.purple.withOpacity(0.3),
        ),
      InsightType.theme => _InsightColors(
          icon: Colors.teal,
          background: Colors.teal.withOpacity(0.1),
          border: Colors.teal.withOpacity(0.3),
        ),
      InsightType.suggestion => _InsightColors(
          icon: theme.colorScheme.primary,
          background: theme.colorScheme.primary.withOpacity(0.1),
          border: theme.colorScheme.primary.withOpacity(0.3),
        ),
    };
  }

  Color _getPriorityColor(InsightPriority priority) {
    return switch (priority) {
      InsightPriority.high => Colors.red,
      InsightPriority.medium => Colors.orange,
      InsightPriority.low => Colors.green,
    };
  }
}

class _InsightColors {
  final Color icon;
  final Color background;
  final Color border;

  const _InsightColors({
    required this.icon,
    required this.background,
    required this.border,
  });
}
