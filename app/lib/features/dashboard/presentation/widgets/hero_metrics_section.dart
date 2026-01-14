import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/metric_card.dart';
import '../../../../shared/widgets/states.dart';
import '../../domain/hero_metrics.dart';
import '../../providers/dashboard_providers.dart';

/// Hero metrics section displaying key stats at the top of the dashboard
class HeroMetricsSection extends ConsumerWidget {
  const HeroMetricsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(heroMetricsProvider);

    return metricsAsync.when(
      data: (metrics) => _buildMetricsGrid(context, metrics),
      loading: () => _buildLoadingGrid(context),
      error: (e, _) => _buildErrorState(context, ref, e),
    );
  }

  Widget _buildMetricsGrid(BuildContext context, HeroMetrics metrics) {
    final colors = context.colors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 5
            : constraints.maxWidth > 600
                ? 3
                : 2;

        final cards = [
          _MetricItem(
            label: 'Apps Tracked',
            value: metrics.totalApps.toString(),
            change: metrics.newAppsThisMonth > 0
                ? metrics.newAppsThisMonth.toDouble()
                : null,
            subtitle: metrics.newAppsThisMonth > 0
                ? '+${metrics.newAppsThisMonth} this month'
                : null,
            icon: Icons.apps_rounded,
          ),
          _MetricItem(
            label: 'Avg Rating',
            value: metrics.avgRating > 0
                ? '${metrics.avgRating.toStringAsFixed(1)} ★'
                : '--',
            change: metrics.ratingChange != 0 ? metrics.ratingChange : null,
            sparklineData:
                metrics.ratingHistory.isNotEmpty ? metrics.ratingHistory : null,
            icon: Icons.star_rounded,
            accentColor: _getRatingColor(colors, metrics.avgRating),
          ),
          _MetricItem(
            label: 'Keywords',
            value: metrics.totalKeywords.toString(),
            subtitle: '${metrics.keywordsInTop10} in top 10',
            icon: Icons.key_rounded,
          ),
          _MetricItem(
            label: 'Reviews',
            value: _formatCount(metrics.totalReviews),
            subtitle: metrics.reviewsNeedReply > 0
                ? '${metrics.reviewsNeedReply} need reply'
                : null,
            icon: Icons.rate_review_rounded,
            accentColor:
                metrics.reviewsNeedReply > 0 ? colors.yellow : null,
          ),
          _MetricItem(
            label: 'Top 10 Keywords',
            value: metrics.keywordsInTop10.toString(),
            subtitle: 'of ${metrics.totalKeywords} total',
            icon: Icons.trending_up_rounded,
            accentColor: colors.green,
          ),
        ];

        if (crossAxisCount == 2) {
          // Mobile: show only 4 cards in 2x2 grid
          return Wrap(
            spacing: AppSpacing.gridGapSmall,
            runSpacing: AppSpacing.gridGapSmall,
            children: cards.take(4).map((item) {
              return SizedBox(
                width: (constraints.maxWidth - AppSpacing.gridGapSmall) / 2,
                child: _buildMetricCard(context, item),
              );
            }).toList(),
          );
        }

        return SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cards.take(crossAxisCount).map((item) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: item == cards.take(crossAxisCount).last
                        ? 0
                        : AppSpacing.gridGapSmall,
                  ),
                  child: _buildMetricCard(context, item),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(BuildContext context, _MetricItem item) {
    return MetricCard(
      label: item.label,
      value: item.value,
      change: item.change,
      subtitle: item.subtitle,
      icon: item.icon,
    );
  }

  Widget _buildLoadingGrid(BuildContext context) {
    final colors = context.colors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth > 900
            ? 5
            : constraints.maxWidth > 600
                ? 3
                : 2;

        return Row(
          children: List.generate(count, (index) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == count - 1 ? 0 : AppSpacing.gridGapSmall,
                ),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: colors.bgSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return ErrorView(
      message: error.toString(),
      onRetry: () => ref.invalidate(heroMetricsProvider),
    );
  }

  Color _getRatingColor(AppColorsExtension colors, double rating) {
    if (rating >= 4.5) return colors.green;
    if (rating >= 4.0) return const Color(0xFF8BC34A);
    if (rating >= 3.0) return colors.yellow;
    if (rating >= 2.0) return colors.orange;
    return colors.red;
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

class _MetricItem {
  final String label;
  final String value;
  final double? change;
  final String? subtitle;
  final IconData? icon;
  final List<double>? sparklineData;
  final Color? accentColor;

  const _MetricItem({
    required this.label,
    required this.value,
    this.change,
    this.subtitle,
    this.icon,
    this.sparklineData,
    this.accentColor,
  });
}
