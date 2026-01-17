import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../domain/actionable_insight_model.dart';
import '../../providers/actionable_insights_provider.dart';
import 'insight_card.dart';

class InsightsDashboardSection extends ConsumerWidget {
  const InsightsDashboardSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(insightsSummaryProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  context.l10n.insights_aiInsights,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                summaryAsync.whenOrNull(
                  data: (summary) => summary.unreadCount > 0
                      ? _UnreadBadge(count: summary.unreadCount)
                      : null,
                ),
              ].whereType<Widget>().toList(),
            ),
            TextButton(
              onPressed: () => context.push('/insights'),
              child: Text(context.l10n.insights_viewAll),
            ),
          ],
        ),
        const SizedBox(height: 16),
        summaryAsync.when(
          data: (summary) => _buildInsightsList(context, summary),
          loading: () => const _InsightsLoadingState(),
          error: (error, _) => _InsightsErrorState(error: error),
        ),
      ],
    );
  }

  Widget _buildInsightsList(BuildContext context, InsightsSummary summary) {
    if (summary.insights.isEmpty) {
      return const _InsightsEmptyState();
    }

    return Column(
      children: [
        ...summary.insights.take(3).map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InsightCard(
                  insight: insight,
                  onTap: () => _handleInsightTap(context, insight),
                ),
              ),
            ),
        if (summary.insights.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: OutlinedButton.icon(
              onPressed: () => context.push('/insights'),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: Text(context.l10n.insights_viewMore(summary.insights.length - 3)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
              ),
            ),
          ),
      ],
    );
  }

  void _handleInsightTap(BuildContext context, ActionableInsight insight) {
    if (insight.actionUrl != null) {
      context.push(insight.actionUrl!);
    }
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;

  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InsightsLoadingState extends StatelessWidget {
  const _InsightsLoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightsEmptyState extends StatelessWidget {
  const _InsightsEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.insights_outlined,
            size: 48,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.insights_noInsightsYet,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.insights_noInsightsDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InsightsErrorState extends StatelessWidget {
  final Object error;

  const _InsightsErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.insights_loadFailed,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
