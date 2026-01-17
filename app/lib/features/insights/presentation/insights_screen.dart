import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/app_context_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../apps/presentation/tabs/app_insights_tab.dart';
import '../providers/global_insights_provider.dart';
import '../../../shared/widgets/safe_image.dart';

/// Insights screen that uses the global app context.
/// - Global mode (no app selected): Shows insight cards for all apps
/// - App mode (app selected): Shows detailed insights for that app
class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedApp = ref.watch(appContextProvider);

    if (selectedApp == null) {
      return const _GlobalInsightsView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.insights_titleWithApp(selectedApp.name)),
      ),
      body: AppInsightsTab(
        appId: selectedApp.id,
        app: selectedApp,
      ),
    );
  }
}

/// Global view showing insight summaries for all apps
class _GlobalInsightsView extends ConsumerWidget {
  const _GlobalInsightsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(globalInsightsProvider);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.insights_allApps),
      ),
      body: insightsAsync.when(
        data: (insights) {
          if (insights.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lightbulb_outlined, size: 64, color: colors.textMuted),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.insights_noInsightsYet,
                    style: TextStyle(fontSize: 18, color: colors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.insights_selectAppToGenerate,
                    style: TextStyle(fontSize: 14, color: colors.textMuted),
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 900
                  ? 3
                  : constraints.maxWidth > 600
                      ? 2
                      : 1;
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.insights_appsWithInsights(insights.length),
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1.3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _InsightCard(data: insights[index]),
                        childCount: insights.length,
                      ),
                    ),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colors.red),
              const SizedBox(height: 16),
              Text(context.l10n.insights_errorLoading, style: TextStyle(color: colors.textSecondary)),
              const SizedBox(height: 8),
              Text(error.toString(), style: TextStyle(color: colors.textMuted, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card showing insight summary for an app
class _InsightCard extends ConsumerWidget {
  final InsightWithApp data;

  const _InsightCard({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final insight = data.insight;
    final app = data.app;

    // Calculate average score from category scores
    double avgScore = 0;
    if (insight.categoryScores.isNotEmpty) {
      avgScore = insight.categoryScores.values.map((c) => c.score).reduce((a, b) => a + b) /
          insight.categoryScores.length;
    }

    return InkWell(
      onTap: () {
        ref.read(appContextProvider.notifier).select(app);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App header
            Row(
              children: [
                if (app.iconUrl != null)
                  SafeImage(
                    imageUrl: app.iconUrl!,
                    width: 40,
                    height: 40,
                    borderRadius: BorderRadius.circular(8),
                    errorWidget: Icon(Icons.apps, size: 40, color: colors.textMuted),
                  )
                else
                  Icon(Icons.apps, size: 40, color: colors.textMuted),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        context.l10n.insights_reviewsAnalyzed(insight.reviewsCount),
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Score indicator
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getScoreColor(avgScore, colors).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    avgScore.toStringAsFixed(1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(avgScore, colors),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  context.l10n.insights_avgScore,
                  style: TextStyle(fontSize: 12, color: colors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Strengths & Weaknesses count
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _StatChip(
                      icon: Icons.thumb_up_outlined,
                      label: 'Strengths',
                      count: insight.overallStrengths.length,
                      color: colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatChip(
                      icon: Icons.thumb_down_outlined,
                      label: 'Weaknesses',
                      count: insight.overallWeaknesses.length,
                      color: colors.red,
                    ),
                  ),
                ],
              ),
            ),

            // Analyzed date
            Text(
              context.l10n.insights_updatedOn(DateFormat.yMMMd().format(insight.analyzedAt)),
              style: TextStyle(fontSize: 11, color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double score, AppColorsExtension colors) {
    if (score >= 4.0) return colors.green;
    if (score >= 3.0) return colors.yellow;
    return colors.red;
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
