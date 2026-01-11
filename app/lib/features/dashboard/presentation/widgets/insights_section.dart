import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../apps/providers/apps_provider.dart';

/// Insight types for the dashboard
enum DashboardInsightType {
  opportunity,
  warning,
  win,
  suggestion,
}

/// A simplified insight for the dashboard
class DashboardInsight {
  final String id;
  final DashboardInsightType type;
  final String title;
  final String description;
  final String? actionText;
  final String? actionRoute;
  final int? appId;
  final String? appName;

  const DashboardInsight({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.actionText,
    this.actionRoute,
    this.appId,
    this.appName,
  });
}

/// Section displaying AI-generated insights and opportunities
class InsightsSection extends ConsumerWidget {
  const InsightsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final appsAsync = ref.watch(appsNotifierProvider);

    // Generate insights based on app data
    final insights = appsAsync.when(
      data: (apps) => _generateInsights(apps),
      loading: () => <DashboardInsight>[],
      error: (e, s) => <DashboardInsight>[],
    );

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Divider(height: 1, color: colors.glassBorder),
          if (insights.isEmpty)
            _buildEmptyState(context)
          else
            _buildInsightsList(context, insights),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, size: 18, color: colors.purple),
          const SizedBox(width: AppSpacing.iconTextGap),
          Text(
            'Insights',
            style: AppTypography.titleSmall.copyWith(color: colors.textPrimary),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colors.purple.withAlpha(20),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'AI',
              style: AppTypography.micro.copyWith(
                color: colors.purple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.lightbulb_outline, size: 40, color: colors.textMuted),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No insights yet',
              style: AppTypography.body.copyWith(color: colors.textMuted),
            ),
            Text(
              'Add apps to get AI-powered recommendations',
              style: AppTypography.caption.copyWith(color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsList(
      BuildContext context, List<DashboardInsight> insights) {
    return Column(
      children: insights.take(4).map((insight) {
        return _InsightCard(insight: insight);
      }).toList(),
    );
  }

  List<DashboardInsight> _generateInsights(List apps) {
    final insights = <DashboardInsight>[];

    for (final app in apps) {
      // Low rating warning
      if (app.rating != null && app.rating! < 4.0) {
        insights.add(DashboardInsight(
          id: 'rating_${app.id}',
          type: DashboardInsightType.warning,
          title: 'Rating needs attention',
          description:
              '${app.name} has a ${app.rating!.toStringAsFixed(1)} rating. Consider reviewing recent negative feedback.',
          actionText: 'View Reviews',
          actionRoute: '/apps/${app.id}?tab=reviews',
          appId: app.id,
          appName: app.name,
        ));
      }

      // No keywords tracked
      if ((app.trackedKeywordsCount ?? 0) == 0) {
        insights.add(DashboardInsight(
          id: 'keywords_${app.id}',
          type: DashboardInsightType.suggestion,
          title: 'Add keywords to track',
          description:
              '${app.name} has no tracked keywords. Add keywords to monitor your ASO performance.',
          actionText: 'Add Keywords',
          actionRoute: '/apps/${app.id}?tab=keywords',
          appId: app.id,
          appName: app.name,
        ));
      }

      // Good ranking opportunity
      if (app.bestRank != null && app.bestRank! <= 10) {
        insights.add(DashboardInsight(
          id: 'rank_${app.id}',
          type: DashboardInsightType.win,
          title: 'Top 10 ranking!',
          description:
              '${app.name} is ranking #${app.bestRank} for a keyword. Great performance!',
          actionText: 'View Rankings',
          actionRoute: '/apps/${app.id}?tab=rankings',
          appId: app.id,
          appName: app.name,
        ));
      }
    }

    // General opportunity if few apps
    if (apps.length < 3) {
      insights.add(const DashboardInsight(
        id: 'add_apps',
        type: DashboardInsightType.opportunity,
        title: 'Track competitor apps',
        description:
            'Add competitor apps to compare rankings and discover keyword opportunities.',
        actionText: 'Add App',
        actionRoute: '/apps/add',
      ));
    }

    return insights;
  }
}

class _InsightCard extends StatelessWidget {
  final DashboardInsight insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (icon, color) = _getTypeStyle(colors);

    return InkWell(
      onTap: insight.actionRoute != null
          ? () => context.go(insight.actionRoute!)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: AppSpacing.sm + 2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    insight.description,
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (insight.actionText != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      insight.actionText!,
                      style: AppTypography.caption.copyWith(
                        color: colors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: colors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color) _getTypeStyle(AppColorsExtension colors) {
    switch (insight.type) {
      case DashboardInsightType.opportunity:
        return (Icons.lightbulb_outline, colors.accent);
      case DashboardInsightType.warning:
        return (Icons.warning_amber_rounded, colors.yellow);
      case DashboardInsightType.win:
        return (Icons.emoji_events_outlined, colors.green);
      case DashboardInsightType.suggestion:
        return (Icons.tips_and_updates_outlined, colors.purple);
    }
  }
}
